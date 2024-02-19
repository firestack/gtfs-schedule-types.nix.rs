{ lib
, runCommand
, html-tidy
, gtfs-schedule-html
}:
runCommand "gtfs-schedule.xhtml" {
	buildInputs = [html-tidy];
} (lib.concatLines [
	"tidy -asxhtml --new-inline-tags c -o $out ${gtfs-schedule-html} || true"
])
