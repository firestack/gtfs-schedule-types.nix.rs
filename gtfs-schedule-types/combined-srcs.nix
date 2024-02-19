{ lib
, craneLib
, stdenvNoCC
, gtfs-schedule-generated-rs-src

}: let
	# cleanedSource = lib.cleanSourceWith {
	# 	src = craneLib.path ./gtfs-schedule-types; # The original, unfiltered source
	# 	filter = craneLib.filterCargoSources;
	# };
	cleanedSource = craneLib.cleanCargoSource (craneLib.path ./.);
# in cleanedSource;
in stdenvNoCC.mkDerivation {
	pname = "gtfs-schedule-types";
	version = "0.0.1";

	src = cleanedSource.outPath;
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
