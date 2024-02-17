<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:saxon="http://saxon.sf.net/"
	xmlns:rs="https://www.rust-lang.org.kaylafire.me/"
	xmlns:xs="math"

	exclude-result-prefixes="#all"
	expand-text="yes"
	version="3.0"
>
<xsl:include href="./functions.xsl" />
<xsl:output method="text" />
<xsl:strip-space elements="*"/>

<!-- Root Template -->
<xsl:template match="/gtfs-static" mode="#default" saxon:explain="yes" >
	<xsl:result-document href="gtfs-static/types.rs" method="text">
		<xsl:call-template name="types"/>
	</xsl:result-document>
	<xsl:result-document href="gtfs-static/files.rs" method="text">
		<xsl:call-template name="definitions"/>
	</xsl:result-document>
</xsl:template>

<!-- #endregion Types -->
<!-- Call by `@name` because we want access to the whole document -->
<xsl:template name="types">
/* Types */

// #region Field Types
<xsl:apply-templates mode="type-definition" select="//types/type"/>
// #endregion Field Types

// #region Unique Id Types
<xsl:apply-templates mode="type-definition" select="
	//fields/field[
		type/name='Unique ID'
		and
		generate-id()
			= generate-id(
				key(
					'typesDistinct',
					rs:gtfs-type(
						type/name,
						'',
						name
					)
			)[1]
		)]
		/type"/>
// #endregion Unique Id Types

// #region Id Types
<xsl:apply-templates mode="type-definition" select="
	//fields/field[
		type/name='ID'
		and
		generate-id()
			= generate-id(
				key(
					'typesDistinct',
					rs:gtfs-type(
						type/name,
						'',
						name
					)
			)[1]
		)]
		/type"/>
// #endregion Id Types

// #region Other Types
<xsl:apply-templates mode="type-definition" select="
	//fields/field[
		type/name!='ID' and
		type/name!='Unique ID' and

		generate-id()
			= generate-id(
				key(
					'typesDistinct',
					rs:gtfs-type(
						type/name,
						'',
						name
					)
			)[1]
		)]
		/type"/>
// #endregion Other Types

</xsl:template>

<xsl:template mode="type-definition" match=".">
<xsl:variable name="typeName"><xsl:apply-templates select="." mode="type" /></xsl:variable>
/** <!-- {./description} -->
 */
pub type <xsl:value-of select="$typeName"/> = <xsl:choose>
	<xsl:when test="$typeName='Text'">core:str</xsl:when>
	<xsl:when test="$typeName='GtfsEnum'">u32</xsl:when>


	<xsl:when test="$typeName='Color'">[u8; 3]</xsl:when>

	<xsl:when test="$typeName='CurrencyCode'">core:str /*ISO 4217*/</xsl:when>
	<!-- <xsl:when test="$typeName='CurrencyAmount'">ok!()</xsl:when> -->

	<!-- <xsl:when test="$typeName='Time'">ok!()</xsl:when> -->
	<!-- <xsl:when test="$typeName='Date'">ok!()</xsl:when> -->
	<!-- <xsl:when test="$typeName='Timezone'">ok!()</xsl:when> -->
	<!-- <xsl:when test="$typeName='Email'">ok!()</xsl:when> -->
		<!-- <xsl:when test="$typeName='PhoneNumber'">ok!()</xsl:when> -->

	<xsl:when test="$typeName='GtfsId'">&amp;core::str</xsl:when>





	<xsl:when test="$typeName='Url'">url::Url</xsl:when>


	<!-- <xsl:when test="$typeName='LanguageCode'">ok!()</xsl:when> -->
	<!-- <xsl:when test="$typeName='TranslationValue'">ok!()</xsl:when> -->
	<!-- <xsl:when test="$typeName='RecordId'">GtfsId</xsl:when> -->
	<!-- <xsl:when test="$typeName='RecordSubId'">GtfsId</xsl:when> -->



	<xsl:when test="$typeName='Latitude'">Float</xsl:when>
	<xsl:when test="$typeName='Longitude'">Float</xsl:when>

	<xsl:when test="$typeName='Float'">f64</xsl:when>
	<xsl:when test="$typeName='Integer'">i64</xsl:when>
	<xsl:when test="$typeName='NonZeroInteger'">Integer</xsl:when>
	<xsl:when test="$typeName='PositiveInteger'">Integer</xsl:when>
	<xsl:when test="$typeName='NonNullInteger'">Integer</xsl:when>
	<xsl:when test="$typeName='PositiveFloat'">Float</xsl:when>


	<!-- Id's -->
	<xsl:when test="$typeName='AgencyId'">GtfsId</xsl:when>
	<xsl:when test="$typeName='StopId'">GtfsId</xsl:when>
	<xsl:when test="$typeName='RouteId'">GtfsId</xsl:when>
	<xsl:when test="$typeName='TripId'">GtfsId</xsl:when>
	<xsl:when test="$typeName='FareId'">GtfsId</xsl:when>
	<xsl:when test="$typeName='FareMediaId'">GtfsId</xsl:when>
	<xsl:when test="$typeName='PathwayId'">GtfsId</xsl:when>
	<xsl:when test="$typeName='AttributionId'">GtfsId</xsl:when>
	<xsl:when test="$typeName='ZoneId'">GtfsId</xsl:when>
	<xsl:when test="$typeName='NetworkId'">GtfsId</xsl:when>
	<xsl:when test="$typeName='BlockId'">GtfsId</xsl:when>
	<xsl:when test="$typeName='TimeframeGroupId'">GtfsId</xsl:when>
	<xsl:when test="$typeName='FareProductId'">GtfsId</xsl:when>
	<xsl:when test="$typeName='LegGroupId'">GtfsId</xsl:when>
	<xsl:when test="$typeName='LevelId'">GtfsId</xsl:when>
	<xsl:when test="$typeName='NonNegativeInteger'">GtfsId</xsl:when>
	<xsl:when test="$typeName='ServiceId'">GtfsId</xsl:when>
	<xsl:when test="$typeName='ShapeId'">GtfsId</xsl:when>
	<xsl:when test="$typeName='NonNegativeFloat'">GtfsId</xsl:when>
	<xsl:when test="$typeName='AreaId'">GtfsId</xsl:when>

	<!-- Fallback -->
	<xsl:otherwise>()</xsl:otherwise>
</xsl:choose>;
</xsl:template>


<!-- #region Type Formatting -->
<!-- Type `XML -> Rust` Formatting -->
<xsl:key
	name="typesDistinct"
	match="//types/type | //fields/field"
>
	<xsl:apply-templates mode="type" select="."/>
</xsl:key>

<xsl:template mode="type" match="field/type">
	<xsl:copy-of select="rs:gtfs-type(name, ../presence, ../name)" />
</xsl:template>

<xsl:template mode="type" match="types/type">
	<xsl:copy-of select='rs:gtfs-type(name, "unknown", "GtfsId")' />
</xsl:template>
<!-- #endregion Type Formatting -->

<!-- #endregion Types -->

<!-- #region Structs -->
<!-- Call by `@name` because we want access to the whole document -->
<xsl:template name="definitions">
use super::types::*;

/* Structs */
<xsl:apply-templates mode="struct" select="//definitions/file" />
</xsl:template>

<xsl:template mode="struct" match="file">
/** <!-- {description} -->
*/
#[derive(Debug, Copy, Clone)]
pub struct {rs:struct-name-from-filename(name)} {{<xsl:apply-templates mode="struct" select="fields/field"/>}}
</xsl:template>

<xsl:template mode="struct" match="field" >
	/** <!-- {./description} -->
	 */
	pub {name}: {rs:gtfs-type(type, presence, name)},
</xsl:template>
<!-- #endregion Structs -->

</xsl:stylesheet>
