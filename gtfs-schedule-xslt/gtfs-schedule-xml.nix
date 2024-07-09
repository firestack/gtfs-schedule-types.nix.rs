{ lib
, stdenvNoCC
, saxon-he
, gtfs-schedule-xhtml
, include-docs ? true
, debug ? false
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
			"debug=${lib.boolToString debug} \\"
			"import_docs=${lib.boolToString include-docs} \\"
			"-s:${gtfs-schedule-xhtml} \\"
			"-o:$out \\"
			"-xsl:gtfs-schedule.xml.xsl"
	];

	dontInstall = true;
}
