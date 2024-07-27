//! GTFS Schedule Types generated from the HTML Documentation
//!

/// Generated Code
mod generated;
pub use generated::{field_types, records, schedule::Dataset};

/// Temporary type alias to provide generic error (Error type to be made discrete later)
pub type Result<T, E = Box<dyn std::error::Error + Send + Sync + 'static>> =
	core::result::Result<T, E>;

#[cfg(feature = "from-dataset")]
mod parse;

