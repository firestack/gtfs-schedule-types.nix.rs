{
	description = "GTFS Types from GTFS Spec";

	inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
	inputs.devshell.url = "github:numtide/devshell";
	inputs.flake-parts.url = "github:hercules-ci/flake-parts";

	inputs.crane = {
		url = "github:ipetkov/crane";
		inputs.nixpkgs.follows = "nixpkgs";
	};

	outputs = inputs@{ self, flake-parts, devshell, nixpkgs, crane }:
		flake-parts.lib.mkFlake { inherit inputs; } {
			imports = [
				devshell.flakeModule
			];

			systems = [
				"aarch64-darwin"
				"aarch64-linux"
				"i686-linux"
				"x86_64-darwin"
				"x86_64-linux"
			];

			perSystem = { pkgs, lib, self', system, ... }: let
				craneLib = crane.lib.${system};

				# src = craneLib.cleanCargoSource (craneLib.path ./gtfs-static-types);
				src = let
					# Only keeps markdown files
					graphQLFilter = path: _type: builtins.match ".*/src/.*\.gql$" path != null;
					testData = path: _type: builtins.match ".*/test_data/.*$" path != null;
					qglOrCargo = path: type:
						builtins.any (fn: fn path type) [
							graphQLFilter
							testData
							craneLib.filterCargoSources
						];
					cleanedSource = lib.cleanSourceWith {
						src = craneLib.path ./gtfs-static-types; # The original, unfiltered source
						filter = qglOrCargo;
					};
				# in cleanedSource;
				in pkgs.stdenvNoCC.mkDerivation {
					pname = "gtfs-static-types";
					version = "0.0.1";

					src = cleanedSource.outPath;
					buildPhase = lib.concatLines [
						"set -x"
						"cp ${self'.packages.gtfs-static-rs}/*.rs ./src/"
						"set +x"
					];
					doCheck = false;
					installPhase = (lib.concatLines [
						"set -x"
						"ls -la"
						"mkdir -p $out"
						"cp -a . $out"
						"set +x"
					]);
				};

				commonArgs = {
					inherit src;
					strictDeps = true;
					doCheck = false;

					buildInputs = [
						# Add additional build inputs here
					] ++ lib.optionals pkgs.stdenv.isDarwin [
						# Additional darwin specific inputs can be set here
						pkgs.libiconv
					];

					# Additional environment variables can be set directly
					# MY_CUSTOM_VAR = "some value";
				};

				cargoArtifacts = craneLib.buildDepsOnly commonArgs;

				gtfs-static-types = craneLib.buildPackage (commonArgs // {
					inherit cargoArtifacts;
				});

				linesFrom = lib.concatLines;
			in {
				packages.default = self'.packages.gtfs-static-types-doc;

				packages.gtfs-static-types = gtfs-static-types;

				packages.gtfs-static-types-doc = craneLib.cargoDoc (commonArgs // {
					inherit cargoArtifacts;
				});

				packages.mbta-gtfs = pkgs.fetchzip {
					name = "MBTA GTFS Static";
					url = "https://cdn.mbtace.com/archive/20240111.zip";
					stripRoot = false;
					hash = "sha256-QGLOPY9CVbW6BjcjBt2UmMh5tOeeozwE92p+vnZoK1o=";
				};

				packages.gtfs-static-html = pkgs.fetchurl {
					name = "gtfs-static.html";
					url = "https://gtfs.org/schedule/reference";
					hash = "sha256-r5qin6byMXoC5KQk8sfSg/knQkFjmC8KaoUS1uTb3mo=";
				};

				packages.gtfs-static-xhtml = pkgs.runCommand "gtfs-static.xhtml" {
					buildInputs = [pkgs.html-tidy];
				} (linesFrom [
					"tidy -asxhtml --new-inline-tags c -o $out ${self'.packages.gtfs-static-html} || true"
				]);

				# packages.gtfs-static-xml = pkgs.runCommand "gtfs-static.xml" {
				# 	buildInputs = [ pkgs.saxon-he ];
				# } (linesFrom [
				# 	"saxon-he -t \\"
				# 		"-s:${self'.packages.gtfs-static-xhtml} \\"
				# 		"-xsl:${./src/xsl/gtfs-static.xml.xsl} \\"
				# 		"-o:$out"
				# ]);

				packages.gtfs-static-xml = pkgs.stdenvNoCC.mkDerivation {
					pname = "gtfs-static.xml";
					version = "0.0.1";

					src = lib.cleanSourceWith {
						filter = (path: _: builtins.match ".*(txt-fns|functions|gtfs-static.xml)\.xsl" path != null);
						src = ./src/xsl;
					};

					buildInputs = [ pkgs.saxon-he ];

					buildPhase = lib.concatLines [
						"ls -la"
						# "mkdir $out"

						"saxon-he -t \\"
							"-s:${self'.packages.gtfs-static-xhtml} \\"
							"-xsl:gtfs-static.xml.xsl \\"
							"-o:$out"
					];

					dontInstall = true;
					# installPhase = linesFrom [
					# 	"cp ./ $out/"
					# ];

				};

				packages.gtfs-static-rs = pkgs.stdenvNoCC.mkDerivation {
					pname = "gtfs-static-rs";
					version = "0.0.2";

					src = ./src/xsl;

					buildInputs = [ pkgs.saxon-he ];

					buildPhase = linesFrom [
						"ls -la"
						"mkdir $out"

						"saxon-he -t \\"
							"-s:${self'.packages.gtfs-static-xml} \\"
							"-xsl:gtfs-static.rs.xsl"
					];

					installPhase = linesFrom [
						"cp ./gtfs-static/* $out/"
						"ln -s ${self'.packages.gtfs-static-xml} $out/gtfs-static.xml"
					];

				};

				devshells.default = {
					packages = [
						pkgs.saxon-he
						pkgs.entr
						pkgs.evcxr
						pkgs.rustc
						pkgs.cargo
						pkgs.clippy
						pkgs.rustfmt
					];

					commands = [{
						help = "develop XSLT with saxon-he";
						name = "dev-he-java";
						command = ''fd . src/ | entr -rc saxon-he -t $@'';
					}];
				};

				checks = {
					inherit (self'.packages)
						gtfs-static-types
						gtfs-static-types-doc;

					inherit (self'.devShells)
						default;
				};
			};
		};
}
