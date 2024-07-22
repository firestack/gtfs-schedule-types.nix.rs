<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:saxon="http://saxon.sf.net/"
	xmlns:x="http://www.w3.org/1999/xhtml"
	xmlns:rs="https://www.rust-lang.org.kaylafire.me/"

	exclude-result-prefixes="#all"
	expand-text="yes"
	version="3.0"
>
	<xsl:param name="debug" as="xs:boolean" select="false()" />
	<xsl:param name="import_docs" as="xs:boolean" select="true()" />

	<xsl:include href="./functions.xsl" />
	<xsl:output method="xml" indent="true" />
	<xsl:strip-space elements="*"/>

	<xsl:variable name="dataset-files-table" select="(//*[@id='dataset-files']/following::x:table)[1]"/>

	<xsl:key name="recordDescriptions" match="$dataset-files-table/x:tbody/x:tr">
		<xsl:value-of select="x:td[1]"/>
	</xsl:key>

	<!-- Root Template -->
	<xsl:template match="/" mode="#default" saxon:explain="yes" >
		<gtfs-schedule>
			<xsl:apply-templates select="//x:main//x:article" />
		</gtfs-schedule>
	</xsl:template>

	<xsl:template match="//x:main//x:article" saxon:explain="yes" >
		<xsl:apply-templates select='*[@id="field-types"]'/>
		<xsl:apply-templates select='*[@id="field-definitions"]'/>
	</xsl:template>

	<!-- Types -->
	<xsl:template match='*[@id="field-types"]' saxon:explain="yes">
		<types>
			<title>{./text()/normalize-space()}</title>

			<xsl:apply-templates
				select="(./following::x:ul)[1]/x:li"
				mode="field-type"
				/>
		</types>
	</xsl:template>

	<xsl:template match="x:*" mode="field-type">
		<type>
			<name>{x:strong}</name>
			<xsl:if test="$import_docs = true()">
				<description>
					<x:body>
						<xsl:copy-of select="node()" />
					</x:body>
				</description>
			</xsl:if>
		</type>
	</xsl:template>

	<!-- records -->
	<xsl:template match='*[@id="field-definitions"]' saxon:explain="yes">
		<records>
			<title>{./text()/normalize-space()}</title>

			<xsl:apply-templates mode="record" select="./following-sibling::x:h3" />
		</records>
	</xsl:template>

	<xsl:template match="x:h3" mode="record">
		<xsl:variable name="record-name" select="./text()/normalize-space()"/>
		<record
			id="{$record-name}"
			presence="{./following-sibling::x:p[1]/x:strong/text()}"
		>
			<name>{$record-name}</name>
			<presence>{./following-sibling::x:p[1]/x:strong/text()}</presence>
			<primary-key>
				<xsl:for-each select="./following-sibling::x:p[2]/x:code">
					<key>{./text()}</key>
				</xsl:for-each>
			</primary-key>
			<xsl:if test="$import_docs = true()">
				<description>
					<summary><xsl:copy-of select="key('recordDescriptions', $record-name)/x:td[3]/node()"/></summary>
					<x:body>
						<xsl:variable name="reference-header" select="."/>
						<xsl:variable name="following-table" select="($reference-header/(following-sibling::x:table | following-sibling::*//x:table))[1]"/>
						<xsl:copy-of select="
								$following-table/preceding-sibling::*[
									count(
										preceding-sibling::*[generate-id()=generate-id($reference-header)]
									) = 1
								]
								"/>
					</x:body>
				</description>
				<!-- <description><x:body>{./following-sibling::*[contains(., "Primary key")]/following-sibling::*[1]}</x:body></description> -->
			</xsl:if>
			<fields>
				<xsl:apply-templates select="(./following::x:table)[1]/x:tbody/x:tr" mode="record-field" />
			</fields>
		</record>
	</xsl:template>


	<xsl:template match="x:tr" mode="record-field">
		<field>
			<name>{x:td[1]/node()}</name>
			<type><name>{x:td[2]/node()}</name></type>
			<presence>{x:td[3]/node()}</presence>
			<xsl:if test="$import_docs = true()">
				<description><x:body><xsl:copy-of select="x:td[4]/node()"/></x:body></description>
			</xsl:if>
		</field>
	</xsl:template>
</xsl:stylesheet>
