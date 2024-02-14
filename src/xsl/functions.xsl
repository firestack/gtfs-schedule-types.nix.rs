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

<xsl:variable name="foreign-prefix" >Foreign ID referencing</xsl:variable>

<xsl:function name="rs:get-foreign-keys">
	<xsl:param name="type-string"/>
	<xsl:variable name="foreign-keys" select="substring-after($type-string, $foreign-prefix)"/>
	<xsl:copy-of select="tokenize($foreign-keys, ' or')"/>
</xsl:function>

<xsl:function name="rs:is-foreign-id">
	<xsl:param name="type-string"/>
	<xsl:copy-of select="starts-with($type-string, $foreign-prefix)"/>
</xsl:function>

<xsl:function name="rs:split-foreign-key">
	<xsl:param name="type-string"/>
	<xsl:variable name="normal-type-string" select="normalize-space($type-string)"/>
	<out>
		<file>{substring-before($normal-type-string, ".")}</file>
		<type>{substring-after($normal-type-string, ".")}</type>
	</out>
</xsl:function>


<xsl:function name="rs:get-split-foreign-keys">
	<xsl:param name="type-string"/>

	<xsl:for-each select="rs:get-foreign-keys($type-string)">
		<xsl:copy-of select="rs:split-foreign-key(.)"/>
	</xsl:for-each>
</xsl:function>

<!-- <xsl:function name="rs:get-foreign-key-type">
	<xsl:param name="type-string"/>
	<xsl:copy-of select="starts-with($type-string, $foreign-prefix)"/>
</xsl:function> -->

<xsl:function name="rs:get-distinct-types">
	<xsl:param name="nodes"/>
	<xsl:variable name="distinct-types">
		<xsl:for-each select="($nodes)"><xsl:sort select="."/>
			<xsl:choose>
					<xsl:when test="rs:is-foreign-id(.)">
						<xsl:variable name="types">
							<xsl:for-each select="rs:get-split-foreign-keys(.)">
								<foreign-key>{rs:normalize-id-type(./type)}</foreign-key>
							</xsl:for-each>
						</xsl:variable>
						<xsl:for-each select="$types/foreign-key"><type>{.}</type></xsl:for-each>
					</xsl:when>
					<xsl:otherwise><type>{.}</type></xsl:otherwise>
				</xsl:choose>

		</xsl:for-each>
	</xsl:variable>

	<xsl:for-each select="distinct-values($distinct-types/type)">
		<type>{.}</type>
	</xsl:for-each>
</xsl:function>

<xsl:function name="rs:gtfs-type">
	 <xsl:param name="type" />
	 <xsl:param name="presence" />
	 <xsl:param name="field_name" />

	 <xsl:choose>
		<!-- Direct Types -->
		<xsl:when test="$type='Color'">Color</xsl:when>
		<xsl:when test="$type='Date'">Date</xsl:when>
		<xsl:when test="$type='Email'">Email</xsl:when>
		<xsl:when test="$type='Latitude'">Latitude</xsl:when>
		<xsl:when test="$type='Longitude'">Longitude</xsl:when>
		<xsl:when test="$type='Time'">Time</xsl:when>
		<xsl:when test="$type='Text'">Text</xsl:when>
		<xsl:when test="$type='Timezone'">Timezone</xsl:when>

		<!-- ID's -->
		<xsl:when test="$type='Unique ID'">{rs:normalize-id-type($field_name)}</xsl:when>
		<xsl:when test="$type='ID'">{rs:normalize-id-type($field_name)}</xsl:when>
		<!-- TODO --> <!-- <xsl:when test="starts-with($type, 'Foreign ID')">todo!("Foreign ID"); {rs:normalize-id-type(normalize-space(substring-after($type, "Foreign ID referencing")))}</xsl:when> -->
		<xsl:when test="rs:is-foreign-id($type)">{rs:normalize-id-type((rs:get-split-foreign-keys($type)/type)[1])}</xsl:when>
		<!-- TODO <xsl:when test="$type='Foreign ID'">todo!("Foreign ID"); {rs:normalize-id-type(normalize-space(substring-after($type, "Foreign ID referencing")))}</xsl:when> -->

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

		<!-- Enums -->
		<xsl:when test="$type='Enum'">GtfsEnum</xsl:when>
		<xsl:when test="$type='Text or URL or Email or Phone number'">TranslationValue</xsl:when>
		<!-- TODO --> <xsl:when test="$type='Foreign ID' and ($field_name='record_id')">RecordId</xsl:when>
		<!-- TODO --> <xsl:when test="$type='Foreign ID' and ($field_name='record_sub_id')">RecordSubId</xsl:when>
		<!-- TODO --> <xsl:when test="$type='Foreign ID'">todo!("Foreign ID")</xsl:when>
		<!-- TODO --> <xsl:when test="count(tokenize($type, ' or ')) > 1">todo!("enum!"); {$type}</xsl:when>

		<xsl:otherwise>todo!("fallback") {$type}</xsl:otherwise>
		<!-- Default Fallback Error (Todo's) -->
		<!-- <xsl:otherwise><xsl:message terminate="yes">Error: Undefined Type!({$type}): '{$field_name}': '{$type}'</xsl:message></xsl:otherwise> -->
	 </xsl:choose>
</xsl:function>

<xsl:function name="rs:struct-name-from-filename">
	<xsl:param name="filename" />
	<xsl:variable name="name" select="substring-before($filename, '.txt')" />
	<xsl:text>{rs:normalize-id-type($name)}</xsl:text>
</xsl:function>

<xsl:function name="rs:normalize-title-case">
	<xsl:param name="strings" />
	<xsl:for-each select="$strings">
		<xsl:text>{concat(upper-case(substring(., 1,1)), substring(., 2))}</xsl:text>
	</xsl:for-each>
</xsl:function>

<xsl:function name="rs:normalize-id-type">
	<xsl:param name="id" />
	<xsl:text>{rs:normalize-title-case(tokenize($id, "_"))}</xsl:text>
</xsl:function>

</xsl:stylesheet>
