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

<xsl:variable name="words" select="'*a*,*an*,*the*,*and*,*but*,*for*,*nor*,*or*,*so*,*yet*,*as*,*at*,*by*,*if*,*in*,*of*,*on*,*to*,*with*,*when*,*where*'"/>

<xsl:function name="rs:normalize-to-title-case">
	<xsl:param name="string" />
	<xsl:for-each select="tokenize(lower-case($string), ' ')">
		<xsl:choose>
			<!-- The first letter of the first word of a title is always Uppercase -->
			<xsl:when test="position()=1">
				<xsl:value-of select="upper-case(substring(.,1,1))"/>
				<xsl:value-of select="substring(.,2)"/>
				<xsl:if test="position()!=last()">
						<xsl:text> </xsl:text>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
						<!-- If the word is contained in $words, leave it Lowercase -->
						<xsl:when test="contains($words,concat('*',.,'*'))">
							<xsl:value-of select="."/>
							<xsl:if test="position()!=last()">
								<xsl:text> </xsl:text>
							</xsl:if>
						</xsl:when>
						<!-- If not, first letter is Uppercase -->
						<xsl:otherwise>
							<xsl:value-of select="upper-case(substring(.,1,1))"/>
							<xsl:value-of select="substring(.,2)"/>
							<xsl:if test="position()!=last()">
								<xsl:text> </xsl:text>
							</xsl:if>
						</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:for-each>
</xsl:function>

</xsl:stylesheet>
