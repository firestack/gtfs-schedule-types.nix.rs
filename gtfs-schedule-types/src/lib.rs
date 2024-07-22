//! GTFS Schedule Types generated from the HTML Documentation
//!

mod generated;
pub use generated::{field_types, records, schedule::Dataset};

/// Temporary type alias to provide generic error (Error type to be made discrete later)
pub type Result<T, E = Box<dyn std::error::Error + Send + Sync + 'static>> =
	core::result::Result<T, E>;

#[cfg(feature = "from-dataset")]
use std::path::Path;

#[cfg(feature = "from-dataset")]
fn parse_csv<RecordType>(filename: &Path) -> Result<Vec<RecordType>>
where
	RecordType: serde::de::DeserializeOwned,
{
	csv::Reader::from_path(filename)
		.and_then(|mut reader| reader.deserialize().collect::<Result<Vec<RecordType>, _>>())
		.map_err(|e| e.into())
}
