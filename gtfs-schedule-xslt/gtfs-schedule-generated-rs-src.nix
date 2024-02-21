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
		"saxon-he -t \\"
			"-s:${gtfs-schedule-xml} \\"
			"-xsl:gtfs-schedule.rs.xsl"
	];

	installPhase = lib.concatLines [
		"mkdir -p $out/generated"
		"cp ./generated/* $out/generated"
		"ln -s ${gtfs-schedule-xml} $out/gtfs-schedule.xml"
	];
}
