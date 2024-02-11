<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:saxon="http://saxon.sf.net/"
	xmlns:rs="https://www.rust-lang.org/"
	xmlns:xs="math"

	exclude-result-prefixes="#all"
	expand-text="yes"
	version="3.0"
>
<xsl:output method="text" />
<xsl:strip-space elements="*"/>

<!-- Root Template -->
<xsl:template match="/gtfs-static" mode="#default" saxon:explain="yes" >
	<xsl:result-document href="gtfs-static/types.rs" method="text">
		<xsl:apply-templates select="types"/>
	</xsl:result-document>
	<xsl:result-document href="gtfs-static/files.rs" method="text">
		<xsl:apply-templates select="definitions"/>
	</xsl:result-document>
</xsl:template>

<xsl:template match="types">
/* Types */
<xsl:for-each select="type">
/*
{./description}
*/
pub type {@id} = ();

</xsl:for-each>
</xsl:template>

<xsl:template match="definitions">
/* Structs */<xsl:for-each select="file">
<xsl:variable name="struct-name" select="rs:struct-name(@id)" />

/**
	{./description}
*/
pub struct {$struct-name} {{<xsl:for-each select="fields/field">
	/**
	 *
	 */
	pub {@id}: {rs:gtfs-type(@type, @presence, @id)},
</xsl:for-each>}}
</xsl:for-each>
</xsl:template>

<xsl:function name="rs:gtfs-type">
	 <xsl:param name="type" />
	 <xsl:param name="presence" />
	 <xsl:param name="field_name" />

	 <xsl:choose>
		<!-- Enums -->
		<xsl:when test="$type='Enum'">NumericalEnum</xsl:when>
		<!-- TODO --> <xsl:when test="count(tokenize($type, 'or')) > 1">todo!("enum!")</xsl:when>

		<!-- ID's -->
		<xsl:when test="$type='Unique ID'">{rs:normalize-id-type($field_name)}</xsl:when>
		<xsl:when test="$type='ID'">{rs:normalize-id-type($field_name)}</xsl:when>
		<!-- TODO --> <xsl:when test="starts-with($type, 'Foreign ID')">###{rs:normalize-id-type(normalize-space(substring-after($type, "Foreign ID referencing")))}</xsl:when>

		<!-- Integer and Float Types -->
		<xsl:when test="$type='Float'">Float</xsl:when>
		<xsl:when test="$type='Integer'">Integer</xsl:when>
		<xsl:when test="$type='Non-zero integer'">NonZeroInteger</xsl:when>
		<xsl:when test="$type='Non-negative integer'">NonNegativeInteger</xsl:when>
		<xsl:when test="$type='Non-null integer'">NonNullInteger</xsl:when>
		<xsl:when test="$type='Positive integer'">PositiveInteger</xsl:when>
		<xsl:when test="$type='Non-negative float'">NonNegativeFloat</xsl:when>
		<xsl:when test="$type='Positive float'">PositiveFloat</xsl:when>

		<!-- Mapped Types -->
		<xsl:when test="$type='URL'">Url</xsl:when>
		<xsl:when test="$type='Language code'">LanguageCode</xsl:when>
		<xsl:when test="$type='Phone number'">PhoneNumber</xsl:when>
		<xsl:when test="$type='Currency code'">CurrencyCode</xsl:when>
		<xsl:when test="$type='Currency amount'">CurrencyAmount</xsl:when>

		<!-- Direct Types -->
		<xsl:when test="$type='Color'">Color</xsl:when>
		<xsl:when test="$type='Date'">Date</xsl:when>
		<xsl:when test="$type='Email'">Email</xsl:when>
		<xsl:when test="$type='Latitude'">Latitude</xsl:when>
		<xsl:when test="$type='Longitude'">Longitude</xsl:when>
		<xsl:when test="$type='Time'">Time</xsl:when>
		<xsl:when test="$type='Text'">Text</xsl:when>
		<xsl:when test="$type='Timezone'">Timezone</xsl:when>

		<!-- Default Fallback Error (Todo's) -->
		<xsl:otherwise><xsl:message terminate="yes">Error: Undefined Type!({$type}): '{$field_name}': '{$type}'</xsl:message></xsl:otherwise>
	 </xsl:choose>
</xsl:function>

<xsl:function name="rs:struct-name">
	<xsl:param name="filename" />
	<xsl:variable name="name" select="substring-before($filename, '.txt')" />
	<xsl:text>{rs:normalize-title-case($name)}</xsl:text>
	<!-- <xsl:text>{concat(upper-case(substring($name, 1,1)), substring($name, 2))}</xsl:text> -->
</xsl:function>

<xsl:function name="rs:normalize-title-case">
	<xsl:param name="strings" />
	<xsl:for-each select="trace($strings)">
		<xsl:text>{concat(trace(upper-case(substring(., 1,1))), trace(substring(., 2)))}</xsl:text>
	</xsl:for-each>
</xsl:function>

<xsl:function name="rs:normalize-id-type">
	<xsl:param name="id" />
	<xsl:text>{rs:normalize-title-case(tokenize($id, "_"))}</xsl:text>
</xsl:function>
</xsl:stylesheet>
