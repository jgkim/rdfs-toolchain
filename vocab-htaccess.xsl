<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
  xmlns:owl="http://www.w3.org/2002/07/owl#"
  xmlns:dcterms="http://purl.org/dc/terms/">

	<xsl:output method="text" version="1.0" encoding="UTF-8"/>

  <xsl:param name="namespace"/>
  <xsl:param name="version" select="'latest'"/>

  <xsl:variable name="identifier" select="/*/*[dcterms:isVersionOf/@rdf:resource=$namespace]/dcterms:identifier"/>

	<xsl:template match="rdf:RDF">
    <xsl:text>Options +FollowSymLinks -MultiViews&#x0a;</xsl:text>
    <xsl:text>&#x0a;</xsl:text>

    <xsl:text>AddType application/rdf+xml .rdf&#x0a;</xsl:text>
    <xsl:for-each select="*[@rdf:about=$identifier]/dcterms:hasFormat">
      <xsl:variable name="format-uri" select="@rdf:resource"/>
      <xsl:variable name="format-type" select="/*/*[@rdf:about=$format-uri]/dcterms:format/dcterms:MediaType/rdf:value"/>
        <xsl:if test="$format-type='text/turtle'">
          <xsl:text>AddType text/turtle .ttl&#x0a;</xsl:text>
        </xsl:if>
    </xsl:for-each>
    <xsl:text>&#x0a;</xsl:text>

    <xsl:text>RewriteEngine On&#x0a;</xsl:text>
    <xsl:text>&#x0a;</xsl:text>

    <xsl:text>RewriteCond %{REQUEST_FILENAME} -f&#x0a;</xsl:text>
    <xsl:text>RewriteRule .* - [L]&#x0a;</xsl:text>
    <xsl:text>&#x0a;</xsl:text>

    <xsl:text>RewriteCond %{HTTP_ACCEPT} text/html [OR]&#x0a;</xsl:text>
    <xsl:text>RewriteCond %{HTTP_ACCEPT} application/xhtml\+xml [OR]&#x0a;</xsl:text>
    <xsl:text>RewriteCond %{HTTP_USER_AGENT} ^Mozilla/.*&#x0a;</xsl:text>
    <xsl:text>RewriteCond $1#%{REQUEST_URI} ([^#]*)#(.*)\1$&#x0a;</xsl:text>
    <xsl:text>RewriteRule </xsl:text>
    <xsl:choose>
      <xsl:when test="$version='latest'">
        <xsl:text>^$ %2latest/</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>^(.*)$ %2</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>html [R=303,L]&#x0a;</xsl:text>
    <xsl:text>&#x0a;</xsl:text>

    <xsl:if test="$version='latest'">
      <xsl:text>RewriteCond %{HTTP_ACCEPT} text/html [OR]&#x0a;</xsl:text>
      <xsl:text>RewriteCond %{HTTP_ACCEPT} application/xhtml\+xml [OR]&#x0a;</xsl:text>
      <xsl:text>RewriteCond %{HTTP_USER_AGENT} ^Mozilla/.*&#x0a;</xsl:text>
      <xsl:text>RewriteCond $1#%{REQUEST_URI} ([^#]*)#(.*)\1$&#x0a;</xsl:text>
      <xsl:text>RewriteRule ^(.*)$ %2latest/html#term-$1 [R=303,L,NE]&#x0a;</xsl:text>
      <xsl:text>&#x0a;</xsl:text>
    </xsl:if>

    <xsl:text>RewriteCond %{HTTP_ACCEPT} application/rdf\+xml&#x0a;</xsl:text>
    <xsl:text>RewriteCond $1#%{REQUEST_URI} ([^#]*)#(.*)\1$&#x0a;</xsl:text>
    <xsl:text>RewriteRule ^(.*)$ %2</xsl:text>
    <xsl:if test="$version='latest'">
      <xsl:text>latest/</xsl:text>
    </xsl:if>
    <xsl:text>rdf [R=303,L]&#x0a;</xsl:text>
    <xsl:text>&#x0a;</xsl:text>
    <xsl:for-each select="*[@rdf:about=$identifier]/dcterms:hasFormat">
      <xsl:variable name="format-uri" select="@rdf:resource"/>
      <xsl:variable name="format-type" select="/*/*[@rdf:about=$format-uri]/dcterms:format/dcterms:MediaType/rdf:value"/>
        <xsl:if test="$format-type='text/turtle'">
          <xsl:text>RewriteCond %{HTTP_ACCEPT} text/turtle [OR]&#x0a;</xsl:text>
          <xsl:text>RewriteCond %{HTTP_ACCEPT} application/rdf\+turtle [OR]&#x0a;</xsl:text>
          <xsl:text>RewriteCond %{HTTP_ACCEPT} application/turtle&#x0a;</xsl:text>
          <xsl:text>RewriteCond $1#%{REQUEST_URI} ([^#]*)#(.*)\1$&#x0a;</xsl:text>
          <xsl:text>RewriteRule ^(.*)$ %2</xsl:text>
          <xsl:if test="$version='latest'">
            <xsl:text>latest/</xsl:text>
          </xsl:if>
          <xsl:text>ttl [R=303,L]&#x0a;</xsl:text>
          <xsl:text>&#x0a;</xsl:text>
        </xsl:if>
    </xsl:for-each>

    <xsl:text>RewriteCond $1#%{REQUEST_URI} ([^#]*)#(.*)\1$&#x0a;</xsl:text>
    <xsl:text>RewriteRule ^(.*)$ %2</xsl:text>
    <xsl:if test="$version='latest'">
      <xsl:text>latest/</xsl:text>
    </xsl:if>
    <xsl:text>rdf [R=303,L]&#x0a;</xsl:text>
    <xsl:text>&#x0a;</xsl:text>
  </xsl:template>

</xsl:stylesheet>