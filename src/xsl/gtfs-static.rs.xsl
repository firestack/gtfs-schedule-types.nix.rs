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

<xsl:key
	name="typesDistinct"
	match="//fields/field"
	use="rs:gtfs-type(type, '', id)"
/>

<!-- <xsl:key
	name="typesDistinct"
	match="//fields/field | //types/type"
>
	<xsl:choose>
		<xsl:when test="../id">{rs:gtfs-type(id, ../presence, ../id)}</xsl:when>
		<xsl:otherwise>{rs:gtfs-type(id, "", id)}</xsl:otherwise>
	</xsl:choose>
</xsl:key> -->

<!-- Root Template -->
<xsl:template match="/gtfs-static" mode="#default" saxon:explain="yes" >
	<xsl:result-document href="gtfs-static/types.rs" method="text">
		<!-- <xsl:apply-templates select="types"/> -->
/* Types */
<xsl:for-each select="//types/type | //fields/field[generate-id() = generate-id(key('typesDistinct', rs:gtfs-type(type, '', id))[1])]/type">
<!-- <xsl:for-each select="types/type | //fields/field/type"> -->
<xsl:sort select="rs:gtfs-type(./id, 'unknown', 'GtfsId')"/>
/** <!-- {./description} -->
 */
pub type <xsl:choose>
	<xsl:when test="../id">{rs:gtfs-type(id, ../presence, ../id)} = ();</xsl:when>
	<xsl:otherwise>{rs:gtfs-type(id, "unknown", "GtfsId")} = ();</xsl:otherwise>
</xsl:choose>


</xsl:for-each>
	</xsl:result-document>
	<xsl:result-document href="gtfs-static/files.rs" method="text">
		<xsl:text>use super::types::*;
</xsl:text>

		<xsl:apply-templates select="definitions"/>
	</xsl:result-document>
</xsl:template>

<xsl:template match="types">

</xsl:template>

<xsl:template match="definitions">
/* Structs */
<xsl:for-each select="file">
<xsl:variable name="struct-name" select="rs:struct-name-from-filename(id)" />
/** <!-- {description} -->
*/
pub struct {$struct-name} {{<xsl:for-each select="fields/field">
	/** <!-- {./description} -->
	 */
	pub {id}: {rs:gtfs-type(type, presence, id)},
</xsl:for-each>}}
</xsl:for-each>
</xsl:template>
</xsl:stylesheet>
