{ lib
, stdenvNoCC
, saxon-he
, gtfs-schedule-xhtml
}: stdenvNoCC.mkDerivation {
	pname = "gtfs-schedule.xml";
	version = "0.0.1";

	src = lib.cleanSourceWith {
		filter = (path: _: builtins.match ".*(txt-fns|functions|gtfs-schedule.xml)\.xsl" path != null);
		src = ./src/xsl;
	};

	buildInputs = [ saxon-he ];

	buildPhase = lib.concatLines [
		"saxon-he -t \\"
			"-s:${gtfs-schedule-xhtml} \\"
			"-o:$out \\"
			"-xsl:gtfs-schedule.xml.xsl"
	];

	dontInstall = true;
}
