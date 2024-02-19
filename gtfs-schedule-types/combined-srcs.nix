{ lib
, craneLib
, stdenvNoCC
, gtfs-schedule-generated-rs-src

}: stdenvNoCC.mkDerivation {
	pname = "gtfs-schedule-types";
	version = "0.0.1";

	src = craneLib.cleanCargoSource (craneLib.path ./.);

	buildPhase = lib.concatLines [
		"set -x"
		"cp ${gtfs-schedule-generated-rs-src}/*.rs ./src/"
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
}
