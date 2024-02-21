{ lib
, craneLib
, stdenvNoCC
, gtfs-schedule-generated-rs-src
, cargo
, rustfmt

}: stdenvNoCC.mkDerivation {
	pname = "gtfs-schedule-types";
	version = "0.0.1";

	buildInputs = [
		cargo
		rustfmt
	];

	src = craneLib.cleanCargoSource (craneLib.path ./.);

	buildPhase = lib.concatLines [
		# "set -x"
		"mkdir -p ./src/generated"
		"install ${gtfs-schedule-generated-rs-src}/generated/*.rs ./src/generated/"
		"cargo fmt"
		# "set +x"
	];

	doCheck = false;

	installPhase = (lib.concatLines [
		# "set -x"
		# "ls -la"
		"mkdir -p $out"
		"cp -a . $out"
		# "set +x"
	]);
}
