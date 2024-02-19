<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:txt="https://txt.xsl.kaylafire.me/"

	exclude-result-prefixes="#all"
	version="1.0"
>
<xsl:function name="txt:normalize-title-case">
	<xsl:param name="strings" />
	<xsl:for-each select="$strings">
		<xsl:value-of select="concat(upper-case(substring(., 1,1)), substring(., 2))"/>
	</xsl:for-each>
</xsl:function>

</xsl:stylesheet>
