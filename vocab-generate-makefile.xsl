<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
  xmlns:owl="http://www.w3.org/2002/07/owl#"
  xmlns:vann="http://purl.org/vocab/vann/"
  xmlns:dcterms="http://purl.org/dc/terms/">

  <xsl:output method="text" version="1.0" encoding="ascii"/>

  <xsl:param name="namespace"/>
  <xsl:param name="toolchain-dir" select="'./toolchain/'"/>

  <xsl:variable name="identifier" select="/*/*[dcterms:isVersionOf/@rdf:resource=$namespace]/dcterms:identifier"/>
  <xsl:variable name="version" select="/*/*[@rdf:about=$identifier]/owl:versionInfo | /*/*[@rdf:about=$identifier]/@owl:versionInfo"/>
  <xsl:variable name="prefix" select="/*/*[@rdf:about=$identifier]/vann:preferredNamespacePrefix"/>

  <xsl:template match="/">
    <xsl:choose>
      <xsl:when test="string-length($namespace)=0">
        <xsl:message>Namespace parameter not supplied</xsl:message>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>XSLT=xsltproc&#x0a;</xsl:text>
        <xsl:text>&#x0a;</xsl:text>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="rdf:RDF">
    <xsl:variable name="vocab-rdf-filename" select="concat($prefix, '.rdf')"/>
    <xsl:variable name="vocab-version-rdf-filename" select="concat($version, '/rdf')"/>
    <xsl:variable name="vocab-version-ttl-filename" select="concat($version, '/ttl')"/>
    <xsl:variable name="vocab-version-html-filename" select="concat($version, '/html')"/>
    <xsl:variable name="vocab-version-htaccess-filename" select="concat($version, '/.htaccess')"/>

    <xsl:call-template name="RuleAll">
      <xsl:with-param name="vocab-version-rdf-filename" select="$vocab-version-rdf-filename"/>
      <xsl:with-param name="vocab-version-htaccess-filename" select="$vocab-version-htaccess-filename"/>
    </xsl:call-template>

    <xsl:call-template name="RuleHtaccess">
      <xsl:with-param name="vocab-version-rdf-filename" select="$vocab-version-rdf-filename"/>
      <xsl:with-param name="vocab-version-html-filename" select="$vocab-version-html-filename"/>
      <xsl:with-param name="vocab-version-htaccess-filename" select="$vocab-version-htaccess-filename"/>
    </xsl:call-template>

    <xsl:call-template name="RuleRdfToHtml">
      <xsl:with-param name="vocab-version-rdf-filename" select="$vocab-version-rdf-filename"/>
      <xsl:with-param name="vocab-version-ttl-filename" select="$vocab-version-ttl-filename"/>
      <xsl:with-param name="vocab-version-html-filename" select="$vocab-version-html-filename"/>
    </xsl:call-template>

    <xsl:for-each select="*[@rdf:about=$identifier]/dcterms:hasFormat">
      <xsl:variable name="format-uri" select="@rdf:resource"/>
      <xsl:variable name="format-type" select="/*/*[@rdf:about=$format-uri]/dcterms:format/dcterms:IMT/rdf:value"/>
        <xsl:if test="$format-type='text/turtle'">
          <xsl:call-template name="RuleRdfToTtl">
            <xsl:with-param name="vocab-version-rdf-filename" select="$vocab-version-rdf-filename"/>
            <xsl:with-param name="vocab-version-ttl-filename" select="$vocab-version-ttl-filename"/>
          </xsl:call-template>
        </xsl:if>
    </xsl:for-each>

    <xsl:call-template name="RuleRdfToRdf">
      <xsl:with-param name="vocab-rdf-filename" select="$vocab-rdf-filename"/>
      <xsl:with-param name="vocab-version-rdf-filename" select="$vocab-version-rdf-filename"/>
    </xsl:call-template>

    <xsl:call-template name="RuleClean"/>
  </xsl:template>

  <xsl:template name="RuleAll">
    <xsl:param name="vocab-version-rdf-filename" />
    <xsl:param name="vocab-version-htaccess-filename" />

    <xsl:text>all: </xsl:text>
    <xsl:value-of select="$vocab-version-htaccess-filename"/>
    <xsl:text>&#x0a;</xsl:text>

    <xsl:call-template name="DoXslt">
      <xsl:with-param name="stylesheet" select="concat($toolchain-dir, 'vocab-htaccess.xsl')"/>
      <xsl:with-param name="input" select="$vocab-version-rdf-filename"/>
      <xsl:with-param name="output" select="'.htaccess'"/>
    </xsl:call-template>

    <xsl:call-template name="DoLink">
      <xsl:with-param name="from" select="$version"/>
      <xsl:with-param name="to" select="'latest'"/>
    </xsl:call-template>

    <xsl:text>&#x0a;</xsl:text>
  </xsl:template>

  <xsl:template name="RuleClean">
    <xsl:text>clean: </xsl:text>
    <xsl:text>&#x0a;</xsl:text>

    <xsl:call-template name="DoDelete">
      <xsl:with-param name="filename" select="'.htaccess'"/>
    </xsl:call-template>

    <xsl:call-template name="DoDelete">
      <xsl:with-param name="filename" select="'latest'"/>
    </xsl:call-template>

    <xsl:call-template name="DoDelete">
      <xsl:with-param name="filename" select="$version"/>
    </xsl:call-template>

    <xsl:text>&#x0a;</xsl:text>
  </xsl:template>

  <xsl:template name="RuleHtaccess">
    <xsl:param name="vocab-version-rdf-filename"/>
    <xsl:param name="vocab-version-html-filename"/>
    <xsl:param name="vocab-version-htaccess-filename"/>

    <xsl:value-of select="$vocab-version-htaccess-filename"/>
    <xsl:text>: </xsl:text>
    <xsl:value-of select="$vocab-version-html-filename"/>
    <xsl:text>&#x0a;</xsl:text>

    <xsl:call-template name="DoXslt">
      <xsl:with-param name="stylesheet" select="concat($toolchain-dir, 'vocab-htaccess.xsl')"/>
      <xsl:with-param name="input" select="$vocab-version-rdf-filename"/>
      <xsl:with-param name="output" select="$vocab-version-htaccess-filename"/>
      <xsl:with-param name="version" select="$version"/>
    </xsl:call-template>
    <xsl:text>&#x0a;</xsl:text>
  </xsl:template>

  <xsl:template name="RuleRdfToHtml">
    <xsl:param name="vocab-version-rdf-filename"/>
    <xsl:param name="vocab-version-ttl-filename"/>
    <xsl:param name="vocab-version-html-filename"/>

    <xsl:value-of select="$vocab-version-html-filename"/>
    <xsl:text>: </xsl:text>
    <xsl:for-each select="*[@rdf:about=$identifier]/dcterms:hasFormat">
      <xsl:variable name="format-uri" select="@rdf:resource"/>
      <xsl:variable name="format-type" select="/*/*[@rdf:about=$format-uri]/dcterms:format/dcterms:IMT/rdf:value"/>
        <xsl:if test="$format-type='text/turtle'">
          <xsl:value-of select="$vocab-version-ttl-filename"/>
          <xsl:text> </xsl:text>
        </xsl:if>
    </xsl:for-each>
    <xsl:value-of select="$vocab-version-rdf-filename"/>
    <xsl:text>&#x0a;</xsl:text>

    <xsl:call-template name="DoXslt">
      <xsl:with-param name="stylesheet" select="concat($toolchain-dir, 'vocab-html-docs.xsl')"/>
      <xsl:with-param name="input" select="$vocab-version-rdf-filename"/>
      <xsl:with-param name="output" select="$vocab-version-html-filename"/>
    </xsl:call-template>

    <xsl:text>&#x0a;</xsl:text>
  </xsl:template>

  <xsl:template name="RuleRdfToTtl">
    <xsl:param name="vocab-version-rdf-filename"/>
    <xsl:param name="vocab-version-ttl-filename"/>

    <xsl:value-of select="$vocab-version-ttl-filename"/>
    <xsl:text>: </xsl:text>
    <xsl:value-of select="$vocab-version-rdf-filename"/>
    <xsl:text>&#x0a;</xsl:text>

    <xsl:text>&#x09;rapper -q -i rdfxml -o turtle </xsl:text>
    <xsl:value-of select="$vocab-version-rdf-filename"/>
    <xsl:text> &gt; </xsl:text>
    <xsl:value-of select="$vocab-version-ttl-filename"/>
    <xsl:text>&#x0a;</xsl:text>

    <xsl:text>&#x0a;</xsl:text>
  </xsl:template>

  <xsl:template name="RuleRdfToRdf">
    <xsl:param name="vocab-rdf-filename"/>
    <xsl:param name="vocab-version-rdf-filename"/>

    <xsl:value-of select="$vocab-version-rdf-filename"/>
    <xsl:text>: </xsl:text>
    <xsl:value-of select="$vocab-rdf-filename"/>
    <xsl:text>&#x0a;</xsl:text>

    <xsl:call-template name="MakeDirectory">
      <xsl:with-param name="directory" select="$version"/>
    </xsl:call-template>

    <xsl:call-template name="DoCopy">
      <xsl:with-param name="from" select="$vocab-rdf-filename"/>
      <xsl:with-param name="to" select="$vocab-version-rdf-filename"/>
    </xsl:call-template>

    <xsl:text>&#x0a;</xsl:text>
  </xsl:template>

  <xsl:template name="MakeDirectory">
    <xsl:param name="directory"/>

    <xsl:text>&#x09;mkdir -p </xsl:text>
    <xsl:value-of select="$directory"/>
    <xsl:text>&#x0a;</xsl:text>
  </xsl:template>

  <xsl:template name="DoLink">
    <xsl:param name="from"/>
    <xsl:param name="to"/>

    <xsl:text>&#x09;ln -sf </xsl:text>
    <xsl:value-of select="$from"/>
    <xsl:text> </xsl:text>
    <xsl:value-of select="$to"/>
    <xsl:text>&#x0a;</xsl:text>
  </xsl:template>

  <xsl:template name="DoDelete">
    <xsl:param name="filename"/>

    <xsl:text>&#x09;rm -rf </xsl:text>
    <xsl:value-of select="$filename"/>
    <xsl:text>&#x0a;</xsl:text>
  </xsl:template>

  <xsl:template name="DoCopy">
    <xsl:param name="from"/>
    <xsl:param name="to"/>

    <xsl:text>&#x09;cp -f </xsl:text>
    <xsl:value-of select="$from"/>
    <xsl:text> </xsl:text>
    <xsl:value-of select="$to"/>
    <xsl:text>&#x0a;</xsl:text>
  </xsl:template>

  <xsl:template name="DoXslt">
    <xsl:param name="stylesheet"/>
    <xsl:param name="input"/>
    <xsl:param name="output"/>
    <xsl:param name="version"/>

    <xsl:text>&#09;$(XSLT) $(XSLTOPT)</xsl:text>

    <xsl:text> --param namespace "'</xsl:text>
    <xsl:value-of select="$namespace"/>
    <xsl:text>'" </xsl:text>

    <xsl:if test="$version">
      <xsl:text> --param version "'</xsl:text>
      <xsl:value-of select="$version"/>
      <xsl:text>'" </xsl:text>
    </xsl:if>

    <xsl:text> -o </xsl:text>
    <xsl:value-of select="$output"/>
    <xsl:text> </xsl:text>

    <xsl:value-of select="$stylesheet"/>
    <xsl:text> </xsl:text>
    <xsl:value-of select="$input"/>
    <xsl:text>&#x0a;</xsl:text>
  </xsl:template>

</xsl:stylesheet>