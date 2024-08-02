use std::path::Path;

pub(crate) fn parse_csv<RecordType>(filename: &Path) -> Result<Vec<RecordType>, csv::Error>
where
	RecordType: serde::de::DeserializeOwned,
{
	csv::Reader::from_path(filename)
		.and_then(|mut reader| reader.deserialize().collect::<Result<Vec<RecordType>, _>>())
}
