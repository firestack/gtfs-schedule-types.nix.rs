{ lib
, stdenvNoCC
, saxon-he
, gtfs-schedule-xml
, debug ? false
}: stdenvNoCC.mkDerivation {
	pname = "gtfs-schedule-generated-rs-src";
	version = "0.0.2";

	src = ./src/xsl;

	buildInputs = [ saxon-he ];

	buildPhase = lib.concatLines [
		"saxon-he -t \\"
			"debug=${lib.boolToString debug} \\"
			"out=$out/ \\"
			"-s:${gtfs-schedule-xml} \\"
			"-xsl:gtfs-schedule.rs.xsl"
	];

	dontInstall = true;
}
