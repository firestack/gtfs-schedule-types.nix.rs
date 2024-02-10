<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:saxon="http://saxon.sf.net/"
	xmlns:x="http://www.w3.org/1999/xhtml"

	exclude-result-prefixes="#all"
	expand-text="yes"
	version="3.0"
>
<xsl:output method="xml" indent="true" />
<xsl:strip-space elements="x:*"/>

<!-- Root Template -->
<xsl:template match="/" mode="#default" saxon:explain="yes" >
	<gtfs-static>
		<xsl:apply-templates select="//x:main//x:article"></xsl:apply-templates>
	</gtfs-static>
</xsl:template>

<xsl:template match="//x:main//x:article" saxon:explain="yes" >
	<types><xsl:apply-templates select='*[@id="field-types"]'/></types>
	<definitions><xsl:apply-templates select='*[@id="field-definitions"]'/></definitions>
</xsl:template>

<!-- Types -->
<xsl:template match='*[@id="field-types"]' saxon:explain="yes">
	<title>{./text()/normalize-space()}</title>

	<xsl:apply-templates
		select="(./following::x:ul)[1]/x:li"
		mode="field-type"
	/>
</xsl:template>

<xsl:template match="x:*" mode="field-type">
	<type
		id="{x:strong}"
	>
		<description>
			<xsl:copy-of select="./node()" />
		</description>
	</type>
</xsl:template>

<!-- files -->
<xsl:template match='*[@id="field-definitions"]' saxon:explain="yes">
	<title>{./text()/normalize-space()}</title>

	<xsl:apply-templates mode="file" select="./following-sibling::x:h3" />
</xsl:template>

<xsl:template match="x:h3" mode="file">
	<file
		id="{./text()/normalize-space()}"
		presence="{./following-sibling::x:p[1]/x:strong/text()}"
	>
		<primary-key>
			<xsl:for-each select="./following-sibling::x:p[2]/x:code">
				<key>{./text()}</key>
			</xsl:for-each>
		</primary-key>
		<description>{//x:tr[./x:a[href=@id]]}</description>
		<fields>
			<xsl:apply-templates select="(./following::x:table)[1]/x:tbody/x:tr" mode="file-field" />
		</fields>
	</file>
</xsl:template>

<xsl:template match="x:tr" mode="file-field">
	<field
		id="{x:td[1]/node()}"
		type="{x:td[2]/node()}"
		presence="{x:td[3]/node()}"
	>
		<description><xsl:copy-of select="x:td[4]/node()"/></description>
	</field>
</xsl:template>
</xsl:stylesheet>
