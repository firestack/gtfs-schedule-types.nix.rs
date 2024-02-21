//! GTFS Schedule Types generated from the HTML Documentation
//!

mod generated;
pub use generated::{field_types, records, schedule::Dataset};

/// Temporary type alias to provide generic error (Error type to be made discrete later)
pub type Result<T, E = Box<dyn std::error::Error + Send + Sync + 'static>> =
	core::result::Result<T, E>;

use std::{
	convert::{AsRef, From},
	path::Path,
};

#[cfg(feature = "from-dataset")]
impl<T: AsRef<Path>> From<T> for Dataset {
	fn from(dataset_path: T) -> Self {
		let dataset_path = dataset_path.as_ref();
		Self {
			agency: parse_csv(&dataset_path.join("agency.txt")).expect("failure parsing file"),
			feed_info: parse_csv(&dataset_path.join("feed_info.txt"))
				.expect("failure parsing file"),
			routes: parse_csv(&dataset_path.join("routes.txt")).expect("failure parsing file"),
			stop_times: parse_csv(&dataset_path.join("stop_times.txt"))
				.expect("failure parsing file"),
			stops: parse_csv(&dataset_path.join("stops.txt")).expect("failure parsing file"),
			trips: parse_csv(&dataset_path.join("trips.txt")).expect("failure parsing file"),

			areas: parse_csv(&dataset_path.join("areas.txt")).ok(),
			attributions: parse_csv(&dataset_path.join("attributions.txt")).ok(),
			calendar_dates: parse_csv(&dataset_path.join("calendar_dates.txt")).ok(),
			calendar: parse_csv(&dataset_path.join("calendar.txt")).ok(),
			fare_attributes: parse_csv(&dataset_path.join("fare_attributes.txt")).ok(),
			fare_leg_rules: parse_csv(&dataset_path.join("fare_leg_rules.txt")).ok(),
			fare_media: parse_csv(&dataset_path.join("fare_media.txt")).ok(),
			fare_products: parse_csv(&dataset_path.join("fare_products.txt")).ok(),
			fare_rules: parse_csv(&dataset_path.join("fare_rules.txt")).ok(),
			fare_transfer_rules: parse_csv(&dataset_path.join("fare_transfer_rules.txt")).ok(),
			frequencies: parse_csv(&dataset_path.join("frequencies.txt")).ok(),
			levels: parse_csv(&dataset_path.join("levels.txt")).ok(),
			networks: parse_csv(&dataset_path.join("networks.txt")).ok(),
			pathways: parse_csv(&dataset_path.join("pathways.txt")).ok(),
			route_networks: parse_csv(&dataset_path.join("route_networks.txt")).ok(),
			shapes: parse_csv(&dataset_path.join("shapes.txt")).ok(),
			stop_areas: parse_csv(&dataset_path.join("stop_areas.txt")).ok(),
			timeframes: parse_csv(&dataset_path.join("timeframes.txt")).ok(),
			transfers: parse_csv(&dataset_path.join("transfers.txt")).ok(),
			translations: parse_csv(&dataset_path.join("translations.txt")).ok(),
		}
	}
}

#[cfg(feature = "from-dataset")]
fn parse_csv<RecordType>(filename: &Path) -> Result<Vec<RecordType>>
where
	RecordType: serde::de::DeserializeOwned,
{
	csv::Reader::from_path(filename)
		.and_then(|mut reader| reader.deserialize().collect::<Result<Vec<RecordType>, _>>())
		.map_err(|e| e.into())
}
