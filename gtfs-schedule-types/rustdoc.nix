{ lib
, craneLib
, gtfs-schedule-types-rs-cargo-artifacts
, gtfs-schedule-types-rs-common-args
}: craneLib.cargoDoc (gtfs-schedule-types-rs-common-args // {
	cargoArtifacts = gtfs-schedule-types-rs-cargo-artifacts;
})
