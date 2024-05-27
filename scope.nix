{ lib
	, makeScope
	, newScope
	, craneLib
	, stdenv
}:
makeScope newScope (self: {
	inherit craneLib;

	mbta-gtfs = self.callPackage ./mbta-gtfs.nix {};

	gtfs-schedule-html = self.callPackage ./gtfs-schedule-xslt/gtfs-schedule-html.nix {};

	gtfs-schedule-xhtml = self.callPackage ./gtfs-schedule-xslt/gtfs-schedule-xhtml.nix {};

	gtfs-schedule-xml = self.callPackage ./gtfs-schedule-xslt/gtfs-schedule-xml.nix {};

	gtfs-schedule-generated-rs-src = self.callPackage ./gtfs-schedule-xslt/gtfs-schedule-generated-rs-src.nix {};

	gtfs-schedule-types-rs-common-args = {
		src = self.callPackage ./gtfs-schedule-types/combined-srcs.nix {};

		strictDeps = true;
		doCheck = false;
	};

	gtfs-schedule-types-rs = self.callPackage (./gtfs-schedule-types) {};

	gtfs-schedule-types-rs-doc = self.callPackage (./gtfs-schedule-types/rustdoc.nix) {};

	gtfs-schedule-types-rs-cargo-artifacts = self.callPackage ./gtfs-schedule-types/cargo-artifacts.nix {
	};
})
