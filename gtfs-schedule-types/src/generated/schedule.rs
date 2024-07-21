
use crate::records::*;

/**
 * Container referencing all records contained in a GTFS Schedule dataset
 */
#[derive(Debug, Default)]
pub struct Dataset {

/** __File Name:__ `agency.txt`

__Presence:__ Required


*/
	pub agency: Vec<Agency>,

/** __File Name:__ `stops.txt`

__Presence:__ Required


*/
	pub stops: Vec<Stops>,

/** __File Name:__ `routes.txt`

__Presence:__ Required


*/
	pub routes: Vec<Routes>,

/** __File Name:__ `trips.txt`

__Presence:__ Required


*/
	pub trips: Vec<Trips>,

/** __File Name:__ `stop_times.txt`

__Presence:__ Required


*/
	pub stop_times: Vec<StopTimes>,

/** __File Name:__ `calendar.txt`

__Presence:__ Conditionally Required


*/
	pub calendar: Option<Vec<Calendar>>,

/** __File Name:__ `calendar_dates.txt`

__Presence:__ Conditionally Required


*/
	pub calendar_dates: Option<Vec<CalendarDates>>,

/** __File Name:__ `fare_attributes.txt`

__Presence:__ Optional


*/
	pub fare_attributes: Option<Vec<FareAttributes>>,

/** __File Name:__ `fare_rules.txt`

__Presence:__ Optional


*/
	pub fare_rules: Option<Vec<FareRules>>,

/** __File Name:__ `timeframes.txt`

__Presence:__ Optional


*/
	pub timeframes: Option<Vec<Timeframes>>,

/** __File Name:__ `fare_media.txt`

__Presence:__ Optional


*/
	pub fare_media: Option<Vec<FareMedia>>,

/** __File Name:__ `fare_products.txt`

__Presence:__ Optional


*/
	pub fare_products: Option<Vec<FareProducts>>,

/** __File Name:__ `fare_leg_rules.txt`

__Presence:__ Optional


*/
	pub fare_leg_rules: Option<Vec<FareLegRules>>,

/** __File Name:__ `fare_transfer_rules.txt`

__Presence:__ Optional


*/
	pub fare_transfer_rules: Option<Vec<FareTransferRules>>,

/** __File Name:__ `areas.txt`

__Presence:__ Optional


*/
	pub areas: Option<Vec<Areas>>,

/** __File Name:__ `stop_areas.txt`

__Presence:__ Optional


*/
	pub stop_areas: Option<Vec<StopAreas>>,

/** __File Name:__ `networks.txt`

__Presence:__ Conditionally Forbidden


*/
	pub networks: Option<Vec<Networks>>,

/** __File Name:__ `route_networks.txt`

__Presence:__ Conditionally Forbidden


*/
	pub route_networks: Option<Vec<RouteNetworks>>,

/** __File Name:__ `shapes.txt`

__Presence:__ Optional


*/
	pub shapes: Option<Vec<Shapes>>,

/** __File Name:__ `frequencies.txt`

__Presence:__ Optional


*/
	pub frequencies: Option<Vec<Frequencies>>,

/** __File Name:__ `transfers.txt`

__Presence:__ Optional


*/
	pub transfers: Option<Vec<Transfers>>,

/** __File Name:__ `pathways.txt`

__Presence:__ Optional


*/
	pub pathways: Option<Vec<Pathways>>,

/** __File Name:__ `levels.txt`

__Presence:__ Conditionally Required


*/
	pub levels: Option<Vec<Levels>>,

/** __File Name:__ `location_groups.txt`

__Presence:__ Optional


*/
	pub location_groups: Option<Vec<LocationGroups>>,

/** __File Name:__ `location_group_stops.txt`

__Presence:__ Optional


*/
	pub location_group_stops: Option<Vec<LocationGroupStops>>,

/** __File Name:__ `booking_rules.txt`

__Presence:__ Optional


*/
	pub booking_rules: Option<Vec<BookingRules>>,

/** __File Name:__ `translations.txt`

__Presence:__ Optional


*/
	pub translations: Option<Vec<Translations>>,

/** __File Name:__ `feed_info.txt`

__Presence:__ RecommendedRequired


*/
	pub feed_info: Vec<FeedInfo>,

/** __File Name:__ `attributions.txt`

__Presence:__ Optional


*/
	pub attributions: Option<Vec<Attributions>>,

}
