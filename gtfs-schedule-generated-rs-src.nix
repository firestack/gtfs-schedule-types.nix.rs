{ lib
, stdenvNoCC
, saxon-he
, gtfs-schedule-xml
}: stdenvNoCC.mkDerivation {
	pname = "gtfs-schedule-generated-rs-src";
	version = "0.0.2";

	src = ./src/xsl;

	buildInputs = [ saxon-he ];

	buildPhase = lib.concatLines [
		"ls -la"
		"mkdir $out"

		"saxon-he -t \\"
			"-s:${gtfs-schedule-xml} \\"
			"-xsl:gtfs-schedule.rs.xsl"
	];

	installPhase = lib.concatLines [
		"cp ./gtfs-schedule/* $out/"
		"ln -s ${gtfs-schedule-xml} $out/gtfs-schedule.xml"
	];
}
