
/* Types */

// #region Field Types

/**

 */
pub type Color = String;

/**

 */
pub type CurrencyCode = String /*ISO 4217*/;

/**

 */
pub type CurrencyAmount = Text;

/**

 */
pub type Date = Text;

/**

 */
pub type Email = Text;

/**

 */
pub type GtfsEnum = u32;

/**

 */
pub type GtfsId = String;

/**

 */
pub type LanguageCode = Text;

/**

 */
pub type Latitude = Float;

/**

 */
pub type Longitude = Float;

/**

 */
pub type Float = f64;

/**

 */
pub type Integer = i64;

/**

 */
pub type PhoneNumber = Text;

/**

 */
pub type Time = Text;

/**

 */
pub type Text = String;

/**

 */
pub type Timezone = Text;

/**

 */
pub type Url = Text;

// #endregion Field Types

////////////////////////////////////////////////////////////////////////////////

// #region Unique Id Types

/**

 */
pub type AgencyUid = GtfsId;

/**

 */
pub type StopUid = GtfsId;

/**

 */
pub type RouteUid = GtfsId;

/**

 */
pub type TripUid = GtfsId;

/**

 */
pub type ServiceUid = GtfsId;

/**

 */
pub type FareUid = GtfsId;

/**

 */
pub type FareMediaUid = GtfsId;

/**

 */
pub type AreaUid = GtfsId;

/**

 */
pub type NetworkUid = GtfsId;

/**

 */
pub type PathwayUid = GtfsId;

/**

 */
pub type LevelUid = GtfsId;

/**

 */
pub type LocationGroupUid = GtfsId;

/**

 */
pub type BookingRuleUid = GtfsId;

/**

 */
pub type AttributionUid = GtfsId;

// #endregion Unique Id Types

////////////////////////////////////////////////////////////////////////////////

// #region Id Types

/**

 */
pub type ZoneId = GtfsId;

/**

 */
pub type NetworkId = GtfsId;

/**

 */
pub type BlockId = GtfsId;

/**

 */
pub type TimeframeGroupId = GtfsId;

/**

 */
pub type FareProductId = GtfsId;

/**

 */
pub type LegGroupId = GtfsId;

/**

 */
pub type ShapeId = GtfsId;

// #endregion Id Types

////////////////////////////////////////////////////////////////////////////////

// #region Other Types

/**

 */
pub type NonNegativeInteger = u64;

/**

 */
pub type NonNegativeFloat = Float;

/**

 */
pub type NonZeroInteger = Integer;

/**

 */
pub type PositiveInteger = Integer;

/**

 */
pub type NonNullInteger = Integer;

/**

 */
pub type PositiveFloat = Float;

/**

 */
pub type TranslationValue = Text;

/**

 */
pub type RecordId = GtfsId;

/**

 */
pub type RecordSubId = GtfsId;

// #endregion Other Types

