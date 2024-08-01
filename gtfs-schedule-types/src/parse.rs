use std::path::Path;
use thiserror::Error;

#[derive(Error, Debug)]
pub(crate) enum ParseCsvError {
	#[error("wtf")]
	Csv(#[from] csv::Error)
}

pub(crate) fn parse_csv<RecordType>(filename: &Path) -> Result<Vec<RecordType>, ParseCsvError>
where
	RecordType: serde::de::DeserializeOwned,
{
	csv::Reader::from_path(filename)
		.and_then(|mut reader| reader.deserialize().collect::<Result<Vec<RecordType>, _>>())
		.map_err(|e| e.into())
}
