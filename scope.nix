{ lib
	, makeScope
	, newScope
	, craneLib
	, stdenvNoCC
	, fetchzip
	, runCommand
	, html-tidy
	, saxon-he
	, stdenv
	, libiconv
	, fetchurl
}:
makeScope newScope (self: {
	inherit craneLib;

	mbta-gtfs = fetchzip {
		name = "MBTA GTFS Static";
		url = "https://cdn.mbtace.com/archive/20240111.zip";
		stripRoot = false;
		hash = "sha256-QGLOPY9CVbW6BjcjBt2UmMh5tOeeozwE92p+vnZoK1o=";
	};

	gtfs-schedule-html = fetchurl {
		name = "gtfs-schedule.html";
		url = "https://gtfs.org/schedule/reference";
		hash = "sha256-r5qin6byMXoC5KQk8sfSg/knQkFjmC8KaoUS1uTb3mo=";
	};

	gtfs-schedule-xhtml = runCommand "gtfs-schedule.xhtml" {
		buildInputs = [html-tidy];
	} (lib.concatLines [
		"tidy -asxhtml --new-inline-tags c -o $out ${self.gtfs-schedule-html} || true"
	]);

	gtfs-schedule-xml = stdenvNoCC.mkDerivation {
		pname = "gtfs-schedule.xml";
		version = "0.0.1";

		src = lib.cleanSourceWith {
			filter = (path: _: builtins.match ".*(txt-fns|functions|gtfs-schedule.xml)\.xsl" path != null);
			src = ./src/xsl;
		};

		buildInputs = [ saxon-he ];

		buildPhase = lib.concatLines [
			"ls -la"
			# "mkdir $out"

			"saxon-he -t \\"
				"-s:${self.gtfs-schedule-xhtml} \\"
				"-xsl:gtfs-schedule.xml.xsl \\"
				"-o:$out"
		];

		dontInstall = true;
		# installPhase = lib.concatLines [
		# 	"cp ./ $out/"
		# ];
	};

	gtfs-schedule-generated-rs-src = stdenvNoCC.mkDerivation {
		pname = "gtfs-schedule-generated-rs-src";
		version = "0.0.2";

		src = ./src/xsl;

		buildInputs = [ saxon-he ];

		buildPhase = lib.concatLines [
			"ls -la"
			"mkdir $out"

			"saxon-he -t \\"
				"-s:${self.gtfs-schedule-xml} \\"
				"-xsl:gtfs-schedule.rs.xsl"
		];

		installPhase = lib.concatLines [
			"cp ./gtfs-schedule/* $out/"
			"ln -s ${self.gtfs-schedule-xml} $out/gtfs-schedule.xml"
		];
	};

	gtfs-schedule-types-rs-common-args = {
		src = let
			# cleanedSource = lib.cleanSourceWith {
			# 	src = craneLib.path ./gtfs-schedule-types; # The original, unfiltered source
			# 	filter = craneLib.filterCargoSources;
			# };
			cleanedSource = craneLib.cleanCargoSource (craneLib.path ./gtfs-schedule-types);
		# in cleanedSource;
		in stdenvNoCC.mkDerivation {
			pname = "gtfs-schedule-types";
			version = "0.0.1";

			src = cleanedSource.outPath;
			buildPhase = lib.concatLines [
				"set -x"
				"cp ${self.gtfs-schedule-generated-rs-src}/*.rs ./src/"
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

		strictDeps = true;
		doCheck = false;

		buildInputs = [
			# Add additional build inputs here
		] ++ lib.optionals stdenv.isDarwin [
			# Additional darwin specific inputs can be set here
			libiconv
		];

		# Additional environment variables can be set directly
		# MY_CUSTOM_VAR = "some value";
	};

	gtfs-schedule-types-rs-cargo-artifacts = self.callPackage ({ craneLib, gtfs-schedule-types-rs-common-args }:
		craneLib.buildDepsOnly gtfs-schedule-types-rs-common-args
	) {};

	gtfs-schedule-types-rs = self.callPackage ({ lib
		, craneLib
		, gtfs-schedule-types-rs-cargo-artifacts
		, gtfs-schedule-types-rs-common-args
	}: craneLib.buildPackage ( gtfs-schedule-types-rs-common-args // {
		cargoArtifacts = gtfs-schedule-types-rs-cargo-artifacts;
	})) {};

	gtfs-schedule-types-rs-doc = self.callPackage ({ lib
		, craneLib
		, gtfs-schedule-types-rs-cargo-artifacts
		, gtfs-schedule-types-rs-common-args
	}: craneLib.cargoDoc (gtfs-schedule-types-rs-common-args // {
		cargoArtifacts = gtfs-schedule-types-rs-cargo-artifacts;
	})) {};
})
