<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:saxon="http://saxon.sf.net/"
	xmlns:rs="https://www.rust-lang.org.kaylafire.me/"
	xmlns:xs="math"
	xmlns:x="http://www.w3.org/1999/xhtml"

	exclude-result-prefixes="#all"
	expand-text="yes"
	version="3.0"
>
<xsl:import href="./markdown.xsl" />
<xsl:include href="./functions.xsl" />
<xsl:output method="adaptive" />
<xsl:strip-space elements="*"/>

<xsl:variable name="unique-field-id-map">
	<xsl:copy-of select="//fields/field[type/name='Unique ID' or type/name='ID']"/>
</xsl:variable>
<!-- Root Template -->
<xsl:template match="/gtfs-static" mode="#default" saxon:explain="yes" >

	<xsl:result-document href="gtfs-static/search.xml" method="xml" indent="yes">
		<xsl:for-each select="distinct-values(//field/presence)">
			<xsl:copy-of select="."/>
		</xsl:for-each>
	</xsl:result-document>

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

////////////////////////////////////////////////////////////////////////////////

// #region Unique Id Types
<xsl:apply-templates mode="type-definition" select="
	//fields/field[
		generate-id()
			= generate-id(
				key(
					'typesDistinct',
					rs:gtfs-type(
						type/name,
						'',
						name,
						$unique-field-id-map
					)
			)[type/name='Unique ID']
		)]
		/type"/>
// #endregion Unique Id Types

////////////////////////////////////////////////////////////////////////////////

// #region Id Types
<xsl:apply-templates mode="type-definition" select="
	//fields/field[
		generate-id()
			= generate-id(
				key(
					'typesDistinct',
					rs:gtfs-type(
						type/name,
						'',
						name,
						$unique-field-id-map
					)
			)[type/name='ID']
		)]
		/type"/>
// #endregion Id Types

////////////////////////////////////////////////////////////////////////////////

// #region Other Types
<xsl:apply-templates mode="type-definition" select="
	//fields/field[
		not(type/name='ID') and
		not(type/name='Unique ID') and
		not(rs:is-foreign-id(type/name)) and

		generate-id()
			= generate-id(
				key(
					'typesDistinct',
					rs:gtfs-type(
						type/name,
						'',
						name,
						$unique-field-id-map
					)
			)[1]
		)]
		/type"/>
// #endregion Other Types

</xsl:template>

<xsl:template mode="type-definition" match=".">
<xsl:variable name="typeName"><xsl:apply-templates select="." mode="type" /></xsl:variable>
/** <xsl:copy-of select="description/x:body"/>
 */
pub type <xsl:value-of select="$typeName"/> = <xsl:value-of select="rs:map-gtfs-type-to-rust($typeName)"/>;
</xsl:template>

<!-- #region Type Formatting -->
<!-- Type `XML -> Rust` Formatting -->
<xsl:key
	name="typesDistinct"
	match="//types/type | //fields/field"
>
	<xsl:apply-templates mode="type" select="."/>
</xsl:key>

<!-- <xsl:key name="" match=""></xsl:key> -->

<xsl:template mode="type" match="field/type">
	<xsl:copy-of select="rs:gtfs-type(name, '', ../name, $unique-field-id-map)" />
</xsl:template>

<xsl:template mode="type" match="types/type">
	<xsl:copy-of select='rs:gtfs-type(name, "unknown", "GtfsId", $unique-field-id-map)' />
</xsl:template>
<!-- #endregion Type Formatting -->

<!-- #endregion Types -->

<!-- #region Structs -->
<!-- Call by `@name` because we want access to the whole document -->
<xsl:template name="definitions">
use crate::types::*;

/* Structs */
<xsl:apply-templates mode="struct" select="//definitions/file" />
</xsl:template>

<xsl:template mode="struct" match="file">
/** {name}
 */
#[derive(serde::Serialize, serde::Deserialize, Debug, Clone)]
pub struct {rs:struct-name-from-filename(name)} {{<xsl:apply-templates
	mode="struct"
	select="fields/field"
/>}}
</xsl:template>

<xsl:template mode="struct" match="field" >
	/** {description}
	 <!-- * {presence} -->
	 */
	pub {name}: {rs:gtfs-type(type, presence, name, $unique-field-id-map)},
</xsl:template>
<!-- #endregion Structs -->

</xsl:stylesheet>
