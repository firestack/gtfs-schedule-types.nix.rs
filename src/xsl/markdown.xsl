<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:h="http://www.w3.org/1999/xhtml">

<xsl:template match="h:body//*">
  <xsl:element name="{name()}">
    <xsl:apply-templates select="* | @* | text()"/>
  </xsl:element>
</xsl:template>

<xsl:template match="h:body//@*">
  <xsl:attribute name="{name(.)}">
    <xsl:value-of select="."/>
  </xsl:attribute>
</xsl:template>

<xsl:template match="h:body//*[@*] | intro//*[@*]" mode="markdown">
    <xsl:copy-of select="."/>
</xsl:template><xsl:template match="h:h1" mode="markdown">
  <xsl:text># </xsl:text><xsl:value-of select="text()"/>
</xsl:template>

<xsl:template match="h:h2" mode="markdown">
  <xsl:text>## </xsl:text><xsl:value-of select="text()"/>
</xsl:template>

<xsl:template match="h:h3" mode="markdown">
  <xsl:text>### </xsl:text><xsl:value-of select="text()"/>
</xsl:template>

<xsl:template match="h:h4" mode="markdown">
  <xsl:text>#### </xsl:text><xsl:value-of select="text()"/>
</xsl:template>

<xsl:template match="h:h5" mode="markdown">
  <xsl:text>##### </xsl:text><xsl:value-of select="text()"/>
</xsl:template>

<xsl:template match="h:h6" mode="markdown">
  <xsl:text>###### </xsl:text><xsl:value-of select="text()"/>
</xsl:template>

<xsl:template match="h:p" mode="markdown">
  <xsl:apply-templates select="* | text()" mode="markdown"/>
</xsl:template>

<xsl:template match="h:ul" mode="markdown">
  <xsl:apply-templates select="*" mode="markdown"/>
</xsl:template>

<xsl:template match="h:ul/h:li/text()" mode="markdown">
  <xsl:value-of select="normalize-space(.)"/>
</xsl:template>

<xsl:template match="h:ul/h:li" mode="markdown">
  <xsl:text>* </xsl:text>
  <xsl:apply-templates select="* | text()" mode="markdown"/>
  <xsl:text>
</xsl:text>
</xsl:template>

<xsl:template match="h:ul/h:li/h:ul/h:li" mode="markdown">
  <xsl:text>
    * </xsl:text>
  <xsl:apply-templates select="* | text()" mode="markdown"/>
</xsl:template>

<xsl:template match="h:ul/h:li/h:ul/h:li/h:ul/h:li" mode="markdown">
  <xsl:text>
        * </xsl:text>
  <xsl:apply-templates select="* | text()" mode="markdown"/>
</xsl:template>

<xsl:template match="h:ol" mode="markdown">
  <xsl:apply-templates select="*" mode="markdown"/>
</xsl:template>

<xsl:template match="h:ol/h:li/text()" mode="markdown">
  <xsl:value-of select="normalize-space(.)"/>
</xsl:template>

<xsl:template match="h:ol/h:li" mode="markdown">
  <xsl:value-of select="position()"/>
  <xsl:text>. </xsl:text>
  <xsl:apply-templates select="* | text()" mode="markdown"/>
  <xsl:text>
</xsl:text>
</xsl:template>

<xsl:template match="h:ol/h:li/h:ol/h:li" mode="markdown">
  <xsl:text>
    </xsl:text>
  <xsl:value-of select="position()"/>
  <xsl:text>. </xsl:text><xsl:apply-templates select="* | text()" mode="markdown"/>
</xsl:template>

<xsl:template match="h:ol/h:li/h:ol/h:li/h:ol/h:li" mode="markdown">
  <xsl:text>
        </xsl:text>
  <xsl:value-of select="position()"/>
  <xsl:text>. </xsl:text><xsl:apply-templates select="* | text()" mode="markdown"/>
</xsl:template>

<xsl:template match="h:strong" mode="markdown">
  <xsl:text>**</xsl:text><xsl:value-of select="text()"/><xsl:text>**</xsl:text>
</xsl:template>

<xsl:template match="h:em" mode="markdown">
  <xsl:text>_</xsl:text><xsl:value-of select="text()"/><xsl:text>_</xsl:text>
</xsl:template>

<xsl:template match="h:br" mode="markdown">
  <xsl:text>  </xsl:text>
</xsl:template>

<xsl:template match="h:a" priority="1" mode="markdown">
  <xsl:text>[</xsl:text>
  <xsl:value-of select="text()"/>
  <xsl:text>](</xsl:text>
  <xsl:value-of select="@href"/>
  <xsl:if test="@title">
    <xsl:text> "</xsl:text>
    <xsl:value-of select="@title"/>
    <xsl:text>"</xsl:text>
  </xsl:if>
  <xsl:text>)</xsl:text>
</xsl:template>

<xsl:template match="h:p/h:code" mode="markdown">
  <xsl:text> `</xsl:text><xsl:value-of select="text()"/><xsl:text>` </xsl:text>
</xsl:template>

<xsl:template match="h:li/h:code" mode="markdown">
  <xsl:text> `</xsl:text><xsl:value-of select="text()"/><xsl:text>` </xsl:text>
</xsl:template>

<xsl:template match="h:blockquote" mode="markdown">
  <xsl:text>&gt; </xsl:text><xsl:apply-templates select="* | text()" mode="markdown"/>
</xsl:template>

<xsl:template match="h:blockquote/text()" mode="markdown">
  <xsl:value-of select="normalize-space(.)"/>
</xsl:template>

<xsl:template match="h:pre" mode="markdown">
  <xsl:apply-templates select="* | text()" mode="markdown"/>
</xsl:template>

<xsl:template match="h:pre/h:code" mode="markdown">
  <xsl:apply-templates select="* | text()" mode="markdown"/>
</xsl:template>

<xsl:template match="h:pre/h:code/text()" mode="markdown">
  <xsl:text>    </xsl:text>
  <xsl:call-template name="markdown-code-block">
    <xsl:with-param name="input" select="."/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="markdown-code-block">
  <xsl:param name="input"/>
  <xsl:param name="value">
    <xsl:choose>
      <xsl:when test="contains($input,'&#xa;')">
        <xsl:value-of select="substring-before($input,'&#xa;')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$input"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:param>
  <xsl:param name="remaining-values" select="substring-after($input,'&#xa;')"/>
  <xsl:value-of select="substring-before($input,'&#xa;')"/><xsl:text>&#xa;    </xsl:text>
  <xsl:if test="$remaining-values != ''">
    <xsl:call-template name="markdown-code-block">
      <xsl:with-param name="input" select="$remaining-values"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template match="h:img" priority="1" mode="markdown">
  <xsl:text>![</xsl:text>
  <xsl:value-of select="@alt"/>
  <xsl:text>](</xsl:text>
  <xsl:value-of select="@src"/>
  <xsl:if test="@title">
    <xsl:text> "</xsl:text>
    <xsl:value-of select="@title"/>
    <xsl:text>"</xsl:text>
  </xsl:if>
  <xsl:text>)</xsl:text>
</xsl:template>

</xsl:stylesheet>
