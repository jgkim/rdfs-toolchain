<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema#"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
  xmlns:owl="http://www.w3.org/2002/07/owl#"
  xmlns:skos="http://www.w3.org/2004/02/skos/core#"
  xmlns:adms="http://www.w3.org/ns/adms#"
  xmlns:vann="http://purl.org/vocab/vann/"
  xmlns:status="http://www.w3.org/2003/06/sw-vocab-status/ns#"
  xmlns:dcterms="http://purl.org/dc/terms/"
  xmlns:cc="http://creativecommons.org/ns#"
  xmlns:foaf="http://xmlns.com/foaf/0.1/">

  <!--
    This stylesheet was originally authored and released by Ian Davis
    (http://purl.org/NET/iand) in the public domain. It has been modified by
    James G. Kim (http://jayg.me/).

    This stylesheet would work with a RDF/XML file that in translated from
    a Turtle file by tools built with Raptor RDF Syntax Library
    (http://librdf.org/raptor/) such as Rapper, a standalone RDF parser utility
    program.

    Brief notes on the kind of RDF/XML this stylesheet requires:
      * Add an owl:Ontology element as a child of rdf:RDF with an rdf:about
        attribute containing the namespace for the vocabulary.
      * To the owl:Ontology element,
        o Add a dcterms:title element containing the title of the schema
        o Add as many dcterms:description or rdfs:comment elements as necessary
          - these become the introductory text for the schema
        o Add a dcterms:creator element for each author
        o Add a vann:preferredNamespaceUri element containing the literal value
          of the namespace for the vocabulary
        o Add a vann:preferredNamespacePrefix element containing a short
          namespace prefix (e.g. vocab)
        o Add a adms:status element with an rdf:resource attribute containing
          a URI of a ADMS status
        o Add a dcterms:issued element with the date the schema was first
          issued in xsd:date
        o Add a dcterms:identifier element containing the URI of the schema
          version
        o Add a dcterms:isVersionOf element with an rdf:resource attribute
          containing the URI of the namespace for the vocabulary
        o Add a owl:versionInfo element with the version of the schema
        o If the schema is a revision of another then add a dcterms:replaces
          element with an rdf:resource attribute pointing to the URI of the
          previous version (without file types)
        o Add links to formats:
          <dcterms:hasFormat>
            <rdf:Description rdf:about="&identifier;/html">
              <dcterms:format>
                <dcterms:IMT>
                  <rdf:value>text/html</rdf:value>
                  <rdfs:label xml:lang="en">HTML</rdfs:label>
                </dcterms:IMT>
              </dcterms:format>
            </rdf:Description>
          </dcterms:hasFormat>

          <dcterms:hasFormat>
            <rdf:Description rdf:about="&identifier;/rdf">
              <dcterms:format>
                <dcterms:IMT>
                  <rdf:value>application/rdf+xml</rdf:value>
                  <rdfs:label xml:lang="en">RDF/XML</rdfs:label>
                </dcterms:IMT>
              </dcterms:format>
            </rdf:Description>
          </dcterms:hasFormat>

          <dcterms:hasFormat>
            <rdf:Description rdf:about="&identifier;/ttl">
              <dcterms:format>
                <dcterms:IMT>
                  <rdf:value>text/turtle</rdf:value>
                  <rdfs:label xml:lang="en">Turtle</rdfs:label>
                </dcterms:IMT>
              </dcterms:format>
            </rdf:Description>
          </dcterms:hasFormat>
        o Add a dcterms:rights element containing a copyright statement
        o Add a dcterms:license element containing a license, but if the
          license is a Creative Commons License, add a cc:license element
          instead

      * For each property and class definition,
        o Important: add an rdfs:isDefinedBy element with an rdf:resource
          attribute with the URI of the namespace for the vocabulary (whatever
          appeared in dcterms:isVersionOf)
        o Add an skos:prefLabel or rdfs:label element containing the short
          label for the term
        o Add a skos:definition element containing the definition of the term
        o Add as many rdfs:comment elements as necessary to document the term
        o Add a dcterms:issued element containing the date the term was first
          issued in xsd:date
        o For each editorial change to the previous version add a
          skos:changeNote element with an rdf:value attribute describing the
          change, a dcterms:date attribute containing the date of the change in
          xsd:date and a dcterms:creator attribute pointing to the URI of the
          change author
        o For each semantic change to the previous version add a
          skos:historyNote element with an rdf:value attribute describing the
          change, a dcterms:date attribute containing the date of the change in
          xsd:date and a dcterms:creator attribute pointing to the URI of the
          change author

      * Add an owl:NamedIndividual element as a child of rdf:RDF for each named
        individuals in the vocabulary with an rdf:about attribute containing
        a URI that starts with the namespace for the vocabulary
  -->

  <xsl:output method="xml" version="1.0" encoding="UTF-8"/>

  <xsl:param name="namespace"/>

  <xsl:variable name="identifier" select="/*/*[dcterms:isVersionOf/@rdf:resource=$namespace]/dcterms:identifier"/>
  <xsl:variable name="title" select="/*/*[@rdf:about=$identifier]/dcterms:title | /*/*[@rdf:about=$identifier]/@dcterms:title"/>
  <xsl:variable name="classes" select="/*/rdfs:Class[rdfs:isDefinedBy/@rdf:resource=$namespace] | /*/owl:Class[rdfs:isDefinedBy/@rdf:resource=$namespace]"/>
  <xsl:variable name="properties" select="/*/rdf:Property[rdfs:isDefinedBy/@rdf:resource=$namespace] | /*/owl:TransitiveProperty[rdfs:isDefinedBy/@rdf:resource=$namespace] | /*/owl:SymmetricProperty[rdfs:isDefinedBy/@rdf:resource=$namespace] | /*/owl:AnnotationProperty[rdfs:isDefinedBy/@rdf:resource=$namespace] | /*/owl:DatatypeProperty[rdfs:isDefinedBy/@rdf:resource=$namespace] | /*/owl:FunctionalProperty[rdfs:isDefinedBy/@rdf:resource=$namespace] | /*/owl:InverseFunctionalProperty[rdfs:isDefinedBy/@rdf:resource=$namespace] | /*/owl:ObjectProperty[rdfs:isDefinedBy/@rdf:resource=$namespace] | /*/owl:OntologyProperty[rdfs:isDefinedBy/@rdf:resource=$namespace]"/>

  <xsl:template match="rdf:RDF">
    <html xmlns="http://www.w3.org/1999/xhtml">
      <head>
        <title><xsl:value-of select="$title"/></title>
        <xsl:for-each select="*[@rdf:about=$identifier]/dcterms:hasFormat">
          <xsl:variable name="format-uri" select="@rdf:resource"/>
          <xsl:variable name="format-type" select="/*/*[@rdf:about=$format-uri]/dcterms:format/dcterms:IMT/rdf:value"/>

          <xsl:if test="not($format-type='text/html') and not($format-type='application/xhtml+xml')">
            <link rel="meta" type="{$format-type}" title="{$title}" href="{$format-uri}"/>
          </xsl:if>
        </xsl:for-each>

        <xsl:call-template name="OutputStyle"/>
      </head>
      <body>
        <h1><xsl:value-of select="$title"/></h1>

        <dl class="doc-info">
          <dt>This Version</dt>
          <dd>
            <a href="{$identifier}"><xsl:value-of select="$identifier"/></a>
            <xsl:for-each select="*[@rdf:about=$identifier]/dcterms:hasFormat">
              <xsl:variable name="format-uri" select="@rdf:resource"/>
              <xsl:variable name="format-label" select="/*/*[@rdf:about=$format-uri]/dcterms:format/dcterms:IMT/rdfs:label"/>

              <xsl:text> [</xsl:text><a href="{$format-uri}"><xsl:value-of select="$format-label"/></a><xsl:text>]</xsl:text>
            </xsl:for-each>
          </dd>

          <dt>Latest Version</dt>
          <dd>
            <a href="{*[@rdf:about=$identifier]/dcterms:isVersionOf/@rdf:resource}">
              <xsl:value-of select="*[@rdf:about=$identifier]/dcterms:isVersionOf/@rdf:resource"/>
            </a>
          </dd>

          <xsl:if test="*[@rdf:about=$identifier]/dcterms:replaces/@rdf:resource">
            <dt>Previous Version</dt>
            <dd>
              <a href="{*[@rdf:about=$identifier]/dcterms:replaces/@rdf:resource}">
                <xsl:value-of select="*[@rdf:about=$identifier]/dcterms:replaces/@rdf:resource"/>
              </a>
            </dd>
          </xsl:if>

          <xsl:if test="*[@rdf:about=$identifier]/dcterms:isPartOf/@rdf:resource">
            <dt>Part Of</dt>
            <xsl:for-each select="*[@rdf:about=$identifier]/dcterms:isPartOf">
              <dd>
                <a href="{@rdf:resource}"><xsl:value-of select="@rdf:resource"/></a>
              </dd>
            </xsl:for-each>
          </xsl:if>

          <xsl:if test="*[@rdf:about=$identifier]/dcterms:creator">
            <dt>
              Author<xsl:if test="count(*[@rdf:about=$identifier]/dcterms:creator)&gt;1">s</xsl:if>
            </dt>
            <xsl:for-each select="*[@rdf:about=$identifier]/dcterms:creator">
              <dd><xsl:apply-templates select="."/></dd>
            </xsl:for-each>
          </xsl:if>

          <xsl:if test="*[@rdf:about=$identifier]/dcterms:contributor">
            <dt>
              Contributor<xsl:if test="count(*[@rdf:about=$identifier]/dcterms:contributor)&gt;1">s</xsl:if>
            </dt>
            <xsl:for-each select="*[@rdf:about=$identifier]/dcterms:contributor">
              <dd><xsl:apply-templates select="."/></dd>
            </xsl:for-each>
          </xsl:if>
        </dl>

        <xsl:if test="*[@rdf:about=$identifier]/adms:status">
          <xsl:variable name="status-url" select="*[@rdf:about=$identifier]/adms:status/@rdf:resource"/>

          <p class="status">
            <xsl:text>This vocabulary is </xsl:text>
            <em>
              <xsl:call-template name="Uncapitalize">
                <xsl:with-param name="text" select="document('ADMS_SKOS_v1.00.rdf')/*/*[@rdf:about=$status-url]/skos:prefLabel"/>
              </xsl:call-template>
            </em>
            <xsl:text>.</xsl:text>
          </p>
        </xsl:if>

        <xsl:if test="*[@rdf:about=$identifier]/dcterms:rights">
          <p class="rights">
            <xsl:value-of select="*[@rdf:about=$identifier]/dcterms:rights"/>
          </p>
        </xsl:if>

        <xsl:if test="*[@rdf:about=$identifier]/cc:license">
          <p class="license">
            <xsl:text>This work is licensed under a </xsl:text>
            <a href="{*[@rdf:about=$identifier]/cc:license/@rdf:resource}">Creative Commons License</a>
            <xsl:text>.</xsl:text>
          </p>
        </xsl:if>

        <xsl:call-template name="GenerateHtml"/>
      </body>
    </html>
  </xsl:template>

  <xsl:template name="GenerateHtml">
    <h2 id="toc">Table of Contents</h2>

    <ul class="toc">
      <li><a href="#sec-introduction">Introduction</a></li>

      <xsl:if test="*[@rdf:about=$identifier]/vann:changes | *[@rdf:about=$identifier]/skos:changeNote | *[@rdf:about=$identifier]/skos:historyNote">
        <li><a href="#sec-changes">Changes From Previous Version</a></li>
      </xsl:if>

      <xsl:if test="*[@rdf:about=$identifier]/vann:preferredNamespaceUri">
        <li><a href="#sec-namespace">Namespace</a></li>
      </xsl:if>

      <xsl:if test="count(*[@rdf:about=$identifier]/vann:termGroup)&gt;0">
        <li><a href="#sec-groups">Terms Grouped by Theme</a></li>
      </xsl:if>

      <li><a href="#sec-terms">Summary of Terms</a></li>

      <xsl:if test="count($classes)&gt;0">
        <li>
          <a href="#sec-classes">Vocabulary Classes</a>
        </li>
      </xsl:if>

      <xsl:if test="count($properties)&gt;0">
        <li>
          <a href="#sec-properties">Vocabulary Properties</a>
        </li>
      </xsl:if>

      <xsl:if test="count(*[@rdf:about=$identifier]/vann:example | *[@rdf:about=$identifier]/skos:example)&gt;0">
        <li>
          <a href="#sec-examples">Examples</a>
        </li>
      </xsl:if>

      <xsl:if test="*[@rdf:about=$identifier]/cc:license">
        <li>
          <a href="#sec-license">License</a>
        </li>
      </xsl:if>
    </ul>

    <h2 id="sec-introduction">Introduction</h2>
    <xsl:apply-templates select="*[@rdf:about=$identifier]/dcterms:description | *[@rdf:about=$identifier]/rdfs:comment"/>

    <xsl:if test="*[@rdf:about=$identifier]/vann:changes | *[@rdf:about=$identifier]/skos:changeNote | *[@rdf:about=$identifier]/skos:historyNote">
      <h2 id="sec-changes">Changes From Previous Version</h2>
      <ul>
        <xsl:if test="*[@rdf:about=$identifier]/dcterms:issued | *[@rdf:about=$identifier]/@dcterms:issued">
          <li>
            <span class="date">
              <xsl:call-template name="RemoveTimeZone">
                <xsl:with-param name="date" select="*[@rdf:about=$identifier]/dcterms:issued | *[@rdf:about=$identifier]/@dcterms:issued"/>
              </xsl:call-template>
            </span>
            - first issued
          </li>
        </xsl:if>

        <xsl:for-each select="*[@rdf:about=$identifier]/skos:changeNote | *[@rdf:about=$identifier]/skos:historyNote">
          <xsl:sort select="*/dcterms:date | */@dcterms:date"/>
          <xsl:apply-templates select="."/>
        </xsl:for-each>
      </ul>

      <xsl:apply-templates select="*[@rdf:about=$identifier]/vann:changes"/>
    </xsl:if>

    <xsl:if test="*[@rdf:about=$identifier]/vann:preferredNamespaceUri">
      <h2 id="sec-namespace">Namespace</h2>
      <p>The URI for this vocabulary is </p>
      <pre><code><xsl:value-of select="*[@rdf:about=$identifier]/vann:preferredNamespaceUri"/></code></pre>

      <xsl:if test="*[@rdf:about=$identifier]/vann:preferredNamespacePrefix">
        <p>
          When used in XML documents the suggested prefix is
          <code><xsl:value-of select="*[@rdf:about=$identifier]/vann:preferredNamespacePrefix"/></code>.
        </p>
      </xsl:if>
      <p>Each class or property in the vocabulary has a URI constructed by appending a term name to the vocabulary URI. For example:</p>
      <pre>
        <code>
          <xsl:value-of select="$properties[1]/@rdf:about"/>
          <xsl:text>&#x0a;</xsl:text>
          <xsl:value-of select="$classes[1]/@rdf:about"/>
        </code>
      </pre>
    </xsl:if>

    <xsl:if test="count(*[@rdf:about=$identifier]/vann:termGroup)&gt;0">
      <h2 id="sec-groups">Terms Grouped by Theme</h2>

      <ul class="groupList">
        <xsl:for-each select="*[@rdf:about=$identifier]/vann:termGroup">
          <xsl:variable name="group" select="@rdf:resource"/>
          <li>
            <p class="definition">
              <strong>
                <xsl:value-of select="/*/*[@rdf:about=$group]/rdfs:label"/>:
              </strong>
              <xsl:value-of select="/*/*[@rdf:about=$group]/rdfs:comment"/>
            </p>
            <p>
              <xsl:for-each select="/*/*[@rdf:about=$group]/*[translate(name(.), '0123456789', '')='_'] | /*/*[@rdf:about=$group]/rdf:li">
                <xsl:if test="count(/*/*[@rdf:about=$group]/*[translate(name(.), '0123456789', '')='_'] | /*/*[@rdf:about=$group]/rdf:li)&gt;1">
                  <xsl:choose>
                    <xsl:when test="not(position()=1) and not(position()=last())">
                      <xsl:text>, </xsl:text>
                    </xsl:when>
                    <xsl:when test="position()=last()">
                      <xsl:text> and </xsl:text>
                    </xsl:when>
                  </xsl:choose>
                </xsl:if>

                <xsl:call-template name="MakeTermReference">
                  <xsl:with-param name="uri" select="@rdf:resource"/>
                </xsl:call-template>
              </xsl:for-each>
            </p>
          </li>
        </xsl:for-each>
      </ul>
    </xsl:if>

    <h2 id="sec-terms">Summary of Terms</h2>
    <p>
      This vocabulary defines
      <xsl:choose>
        <xsl:when test="count($classes)=0">
          no classes
        </xsl:when>
        <xsl:when test="count($classes)=1">
          one class
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="count($classes)"/> classes
        </xsl:otherwise>
      </xsl:choose>
      and
      <xsl:choose>
        <xsl:when test="count($properties)=0">
          no properties.
        </xsl:when>
        <xsl:when test="count($properties)=1">
          one property.
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="count($properties)"/> properties.
        </xsl:otherwise>
      </xsl:choose>
    </p>

    <table>
      <thead>
        <tr>
          <th>Term Name</th>
          <th>Type</th>
          <th>Definition</th>
        </tr>
      </thead>

      <tbody>
        <xsl:for-each select="$classes">
          <xsl:sort select="@rdf:about"/>

          <xsl:variable name="term-name">
            <xsl:call-template name="TermName">
              <xsl:with-param name="uri" select="@rdf:about"/>
            </xsl:call-template>
          </xsl:variable>

          <tr>
            <td>
              <a>
                <xsl:attribute name="href"><xsl:text>#term-</xsl:text><xsl:value-of select="$term-name"/></xsl:attribute>
                <xsl:attribute name="title"><xsl:value-of select="@rdf:about"/></xsl:attribute>
                <xsl:value-of select="$term-name"/>
              </a>
            </td>
            <td><em>class</em></td>
            <td>
              <xsl:choose>
                <xsl:when test="skos:definition">
                  <xsl:value-of select="skos:definition[1]"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="rdfs:comment[1]"/>
                </xsl:otherwise>
              </xsl:choose>
            </td>
          </tr>
        </xsl:for-each>

        <xsl:for-each select="$properties">
          <xsl:sort select="@rdf:about"/>

          <xsl:variable name="term-name">
            <xsl:call-template name="TermName">
              <xsl:with-param name="uri" select="@rdf:about"/>
            </xsl:call-template>
          </xsl:variable>

          <tr>
            <td>
              <a>
                <xsl:attribute name="href"><xsl:text>#term-</xsl:text><xsl:value-of select="$term-name"/></xsl:attribute>
                <xsl:attribute name="title"><xsl:value-of select="@rdf:about"/></xsl:attribute>
                <xsl:value-of select="$term-name"/>
              </a>
            </td>
            <td><em>property</em></td>
            <td>
              <xsl:choose>
                <xsl:when test="skos:definition">
                  <xsl:value-of select="skos:definition[1]"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="rdfs:comment[1]"/>
                </xsl:otherwise>
              </xsl:choose>
            </td>
          </tr>
        </xsl:for-each>
      </tbody>
    </table>

    <xsl:if test="count($classes)&gt;0">
      <h2 id="sec-classes">Vocabulary Classes</h2>
      <xsl:apply-templates select="$classes">
        <xsl:sort select="@rdf:about"/>
      </xsl:apply-templates>
    </xsl:if>

    <xsl:if test="count($properties)&gt;0">
      <h2 id="sec-properties">Vocabulary Properties</h2>
      <xsl:apply-templates select="$properties">
        <xsl:sort select="@rdf:about"/>
      </xsl:apply-templates>
    </xsl:if>

    <xsl:if test="*[@rdf:about=$identifier]/vann:example | *[@rdf:about=$identifier]/skos:example">
      <h2 id="sec-examples">Examples</h2>
      <xsl:apply-templates select="*[@rdf:about=$identifier]/vann:example | *[@rdf:about=$identifier]/skos:example"/>
    </xsl:if>

    <xsl:if test="*[@rdf:about=$identifier]/cc:license">
      <h2 id="sec-license">License</h2>
      <xsl:for-each select="*[@rdf:about=$identifier]/cc:license">
        <xsl:variable name="uri" select="@rdf:resource"/>

        <div class="license">
          <p>
            <xsl:text>This work is licensed under a </xsl:text>
            <a href="{@rdf:resource}">Creative Commons License</a>
            <xsl:text>.</xsl:text>

            <xsl:apply-templates select="document(concat(@rdf:resource, 'rdf'))/*/cc:License[@rdf:about=$uri]"/>
          </p>
        </div>
      </xsl:for-each>
    </xsl:if>

    <div id="footer">
      Documentation generated using the <a href="http://github.com/jgkim/rdfs-toolchain">rdfs.co toolchain</a><br/>
      based on <a href="http://iandavis.com">Ian Davis</a>'s <a href="http://vocab.org/2004/03/toolchain">vocab.org toolchain</a>.
    </div>
  </xsl:template>

  <xsl:template match="rdfs:Class | owl:Class">
    <xsl:variable name="class-uri" select="@rdf:about"/>

    <div class="class">
      <h3>
        <xsl:attribute name="id">
          <xsl:text>term-</xsl:text>
          <xsl:call-template name="TermName">
            <xsl:with-param name="uri" select="$class-uri"/>
          </xsl:call-template>
        </xsl:attribute>
        <xsl:text>Class: </xsl:text>
        <xsl:call-template name="TermName">
          <xsl:with-param name="uri" select="$class-uri"/>
        </xsl:call-template>
      </h3>

      <div class="description">
        <xsl:apply-templates select="skos:definition"/>
        <xsl:apply-templates select="rdfs:comment | @rdfs:comment"/>

        <table class="properties">
          <tbody>
            <tr>
              <th>URI:</th>
              <td>
                <xsl:value-of select="$class-uri"/>
              </td>
            </tr>

            <xsl:if test="count(rdfs:label)&gt;0">
              <tr>
                <th>Label:</th>
                <td>
                  <xsl:apply-templates select="rdfs:label"/>
                </td>
              </tr>
            </xsl:if>

            <xsl:if test="count(skos:prefLabel)&gt;0">
              <tr>
                <th>Preferred Label:</th>
                <td>
                  <xsl:apply-templates select="skos:prefLabel"/>
                </td>
              </tr>
            </xsl:if>

            <xsl:if test="count(skos:altLabel)&gt;0">
              <tr>
                <th>Alternate Label:</th>
                <td>
                  <xsl:apply-templates select="skos:altLabel"/>
                </td>
              </tr>
            </xsl:if>

            <xsl:if test="count(/*/*[rdfs:domain/@rdf:resource=$class-uri])&gt;0">
              <tr>
                <th>Properties include:</th>
                <td>
                  <xsl:for-each select="/*/*[rdfs:domain/@rdf:resource=$class-uri]">
                    <xsl:if test="count(/*/*[rdfs:domain/@rdf:resource=$class-uri])&gt;1">
                      <xsl:choose>
                        <xsl:when test="not(position()=1) and not(position()=last())">
                          <xsl:text>, </xsl:text>
                        </xsl:when>
                        <xsl:when test="position()=last()">
                          <xsl:text> and </xsl:text>
                        </xsl:when>
                      </xsl:choose>
                    </xsl:if>

                    <xsl:call-template name="MakeTermReference">
                      <xsl:with-param name="uri" select="@rdf:about"/>
                    </xsl:call-template>
                  </xsl:for-each>
                </td>
              </tr>
            </xsl:if>

            <xsl:if test="count(/*/*[rdfs:range/@rdf:resource=$class-uri])&gt;0">
              <tr>
                <th>Used with:</th>
                <td>
                  <xsl:for-each select="/*/*[rdfs:range/@rdf:resource=$class-uri]">
                    <xsl:if test="count(/*/*[rdfs:range/@rdf:resource=$class-uri])&gt;1">
                      <xsl:choose>
                        <xsl:when test="not(position()=1) and not(position()=last())">
                          <xsl:text>, </xsl:text>
                        </xsl:when>
                        <xsl:when test="position()=last()">
                          <xsl:text> and </xsl:text>
                        </xsl:when>
                      </xsl:choose>
                    </xsl:if>

                    <xsl:call-template name="MakeTermReference">
                      <xsl:with-param name="uri" select="@rdf:about"/>
                    </xsl:call-template>
                  </xsl:for-each>
                </td>
              </tr>
            </xsl:if>

            <xsl:call-template name="ResourceList">
              <xsl:with-param name="properties" select="rdfs:subClassOf"/>
              <xsl:with-param name="label" select="'Subclass of:'"/>
            </xsl:call-template>

            <xsl:call-template name="ResourceList">
              <xsl:with-param name="properties" select="owl:disjointWith"/>
              <xsl:with-param name="label" select="'Disjoint with:'"/>
            </xsl:call-template>

            <xsl:call-template name="ResourceList">
              <xsl:with-param name="properties" select="owl:equivalentClass"/>
              <xsl:with-param name="label" select="'Equivalent to:'"/>
            </xsl:call-template>

            <xsl:call-template name="ResourceList">
              <xsl:with-param name="properties" select="owl:sameAs"/>
              <xsl:with-param name="label" select="'Same as:'"/>
            </xsl:call-template>

            <xsl:call-template name="ResourceList">
              <xsl:with-param name="properties" select="rdfs:seeAlso"/>
              <xsl:with-param name="label" select="'See Also:'"/>
            </xsl:call-template>

            <xsl:if test="status:term_status">
              <tr>
                <th>Status:</th>
                <td>
                  <xsl:call-template name="CapitalizeFirstLetter">
                    <xsl:with-param name="text" select="status:term_status"/>
                  </xsl:call-template>
                </td>
              </tr>
            </xsl:if>
          </tbody>
        </table>

        <xsl:if test="dcterms:issued | @dcterms:issued">
          <h4>History</h4>
          <ul class="historyList">
            <li>
              <span class="date">
                <xsl:call-template name="RemoveTimeZone">
                  <xsl:with-param name="date" select="dcterms:issued | @dcterms:issued"/>
                </xsl:call-template>
              </span>
              - first issued
            </li>

            <xsl:apply-templates select="skos:changeNote|skos:historyNote"/>
          </ul>
        </xsl:if>
      </div>
    </div>
  </xsl:template>

  <xsl:template match="rdf:Property | owl:TransitiveProperty | owl:SymmetricProperty | owl:AnnotationProperty | owl:DatatypeProperty | owl:FunctionalProperty | owl:InverseFunctionalProperty | owl:ObjectProperty | owl:OntologyProperty">
    <div class="property">
      <h3>
        <xsl:attribute name="id">
          <xsl:text>term-</xsl:text>
          <xsl:call-template name="TermName">
            <xsl:with-param name="uri" select="@rdf:about"/>
          </xsl:call-template>
        </xsl:attribute>
        <xsl:text>Property: </xsl:text>
        <xsl:call-template name="TermName">
          <xsl:with-param name="uri" select="@rdf:about"/>
        </xsl:call-template>
      </h3>

      <div class="description">
        <xsl:apply-templates select="skos:definition"/>
        <xsl:apply-templates select="rdfs:comment | @rdfs:comment"/>

        <table class="properties">
          <tbody>
            <tr>
              <th>URI:</th>
              <td>
                <xsl:value-of select="@rdf:about"/>
              </td>
            </tr>

            <xsl:if test="count(rdfs:label)&gt;0">
              <tr>
                <th>Label:</th>
                <td>
                  <xsl:apply-templates select="rdfs:label"/>
                </td>
              </tr>
            </xsl:if>

            <xsl:if test="count(skos:prefLabel)&gt;0">
              <tr>
                <th>Preferred Label:</th>
                <td>
                  <xsl:apply-templates select="skos:prefLabel"/>
                </td>
              </tr>
            </xsl:if>

            <xsl:if test="count(skos:altLabel)&gt;0">
              <tr>
                <th>Alternate Label:</th>
                <td>
                  <xsl:apply-templates select="skos:altLabel"/>
                </td>
              </tr>
            </xsl:if>

            <xsl:call-template name="ResourceList">
              <xsl:with-param name="properties" select="rdfs:domain"/>
              <xsl:with-param name="label" select="'Domain:'"/>
            </xsl:call-template>

            <xsl:call-template name="ResourceList">
              <xsl:with-param name="properties" select="rdfs:range"/>
              <xsl:with-param name="label" select="'Range:'"/>
            </xsl:call-template>

            <xsl:call-template name="ResourceList">
              <xsl:with-param name="properties" select="rdfs:subPropertyOf"/>
              <xsl:with-param name="label" select="'Subproperty of:'"/>
            </xsl:call-template>

            <xsl:call-template name="ResourceList">
              <xsl:with-param name="properties" select="owl:inverseOf"/>
              <xsl:with-param name="label" select="'Inverse of:'"/>
            </xsl:call-template>

            <xsl:call-template name="ResourceList">
              <xsl:with-param name="properties" select="owl:sameAs"/>
              <xsl:with-param name="label" select="'Same as:'"/>
            </xsl:call-template>

            <xsl:call-template name="ResourceList">
              <xsl:with-param name="properties" select="rdfs:seeAlso"/>
              <xsl:with-param name="label" select="'See Also:'"/>
            </xsl:call-template>

            <xsl:if test="status:term_status">
              <tr>
                <th>Status:</th>
                <td>
                  <xsl:call-template name="CapitalizeFirstLetter">
                    <xsl:with-param name="text" select="status:term_status"/>
                  </xsl:call-template>
                </td>
              </tr>
            </xsl:if>
          </tbody>
        </table>

        <xsl:if test="dcterms:issued | @dcterms:issued">
          <h4>History</h4>
          <ul class="historyList">
            <li>
              <span class="date">
                <xsl:call-template name="RemoveTimeZone">
                  <xsl:with-param name="date" select="dcterms:issued | @dcterms:issued"/>
                </xsl:call-template>
              </span>
              - first issued
            </li>

            <xsl:apply-templates select="skos:changeNote|skos:historyNote"/>
          </ul>
        </xsl:if>
      </div>
    </div>
  </xsl:template>

  <xsl:template match="skos:prefLabel | skos:altLabel | rdfs:label">
    <xsl:variable name="name" select="name(.)"/>

    <xsl:if test="count(preceding-sibling::*[name()=$name])&gt;0">
      <xsl:choose>
        <xsl:when test="count(following-sibling::*[name()=$name])=0">
          <xsl:text> and </xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>, </xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>

    <xsl:value-of select="."/>
    <span class="lang">@<xsl:value-of select="@xml:lang"/></span>
  </xsl:template>

  <xsl:template match="skos:definition">
    <p class="definition">
      <strong>Definition:</strong>
      <xsl:value-of select="."/>
    </p>
  </xsl:template>

  <xsl:template match="cc:License">
    <p>
      The following section is informational only, please refer to the
      <a href="{cc:legalcode/@rdf:resource}">original license</a>
      for complete license terms.
    </p>

    <xsl:if test="count(cc:permits)&gt;0">
      <p>This license grants the following rights:</p>
      <ul>
        <xsl:for-each select="cc:permits">
          <li>
            <xsl:call-template name="CcTerm">
              <xsl:with-param name="uri" select="@rdf:resource"/>
            </xsl:call-template>
          </li>
        </xsl:for-each>
      </ul>
    </xsl:if>

    <xsl:if test="count(cc:requires)&gt;0">
      <p>This license imposes the following restrictions:</p>
      <ul>
        <xsl:for-each select="cc:requires">
          <li>
            <xsl:call-template name="CcTerm">
              <xsl:with-param name="uri" select="@rdf:resource"/>
            </xsl:call-template>
          </li>
        </xsl:for-each>
      </ul>
    </xsl:if>

    <xsl:if test="count(cc:prohibits)&gt;0">
      <p>This license prohibits the following:</p>
      <ul>
        <xsl:for-each select="cc:prohibits">
          <li>
            <xsl:call-template name="CcTerm">
              <xsl:with-param name="uri" select="@rdf:resource"/>
            </xsl:call-template>
          </li>
        </xsl:for-each>
      </ul>
    </xsl:if>
  </xsl:template>

  <xsl:template match="vann:example | skos:example">
    <div class="example">
      <h3>
        <xsl:choose>
          <xsl:when test="dcterms:title | @dcterms:title">
            <xsl:value-of select="dcterms:title | @dcterms:title"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="document(@rdf:resource)/*[local-name()='html'][1]/*[local-name()='head'][1]/*[local-name()='title'][1]"/>
          </xsl:otherwise>
        </xsl:choose>
      </h3>
      <xsl:copy-of select="document(@rdf:resource)/*[local-name()='html'][1]/*[local-name()='body'][1]"/>
    </div>
  </xsl:template>

  <xsl:template match="vann:changes">
    <div class="changes">
      <xsl:copy-of select="document(@rdf:resource)/*[local-name()='html'][1]/*[local-name()='body'][1]"/>
    </div>
  </xsl:template>

  <xsl:template match="skos:changeNote | skos:historyNote">
    <li class="{local-name(.)}">
      <xsl:call-template name="RemoveTimeZone">
        <xsl:with-param name="date" select="*/dcterms:date | */@dcterms:date"/>
      </xsl:call-template>
      <xsl:choose>
        <xsl:when test="local-name(.)='changeNote'">
        - editorial change by
        </xsl:when>
        <xsl:otherwise>
        - semantic change by
        </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*/dcterms:creator"/>:
      <xsl:value-of select="*/rdf:value | */@rdf:value"/>
    </li>
  </xsl:template>

  <xsl:template match="dcterms:description">
    <p class="description">
      <xsl:value-of select="." disable-output-escaping="yes"/>
    </p>
  </xsl:template>

  <xsl:template match="rdfs:comment | @rdfs:comment">
    <p class="comment">
      <xsl:value-of select="." disable-output-escaping="yes"/>
    </p>
  </xsl:template>

  <xsl:template match="dcterms:creator | dcterms:contributor">
    <xsl:choose>
      <xsl:when test="*/foaf:name">
        <xsl:choose>
          <xsl:when test="*/foaf:homepage">
            <a href="{*/foaf:homepage}"><xsl:value-of select="*/foaf:name"/></a>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="*/foaf:name"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="uri" select="@rdf:resource"/>
        <xsl:choose>
          <xsl:when test="/*/*[@rdf:about=$uri]/foaf:homepage">
            <a href="{/*/*[@rdf:about=$uri]/foaf:homepage/@rdf:resource}"><xsl:value-of select="/*/*[@rdf:about=$uri]/foaf:name"/></a>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="/*/*[@rdf:about=$uri]/foaf:name"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="OutputStyle">
    <style type="text/css">
      h1, h2, h3, h4, h5, h6 {
        font-family: Georgia, "Times New Roman", Times, serif;
        font-style: italic;
      }

      pre {
        border: 1px #9999cc dotted;
        background-color: #f3f3ff;
        color: #000000;
        width: 90%;
      }

      blockquote {
        border-style: solid;
        border-color: #d0dbe7;
        border-width: 0 0 0 .25em;
        padding-left: 0.5em;
      }

      blockquote, q {
        font-style: italic;
      }

      body {
        font-family: verdana, geneva, arial, sans-serif;
        font-size: 0.8em;
      }

      a, p, blockquote, q, dl, dd, dt {
        font-family: verdana, geneva, arial, sans-serif;
        font-size: 1em;
      }

      dt {
        font-weight: bold;
      }

      :link { color: #005533; background: transparent }
      :visited { color: #008866; background: transparent }
      :link:active, :visited:active { color: #CC0000; background: transparent }
      :link:hover, :visited:hover { background: #ffa; }
      code :link, code :visited { color: inherit; }

      h1, h2, h3, h4, h5, h6 { text-align: left }
      h1, h2, h3 { color: #006644; background: transparent; }
      h1 { font: 900 170% sans-serif; border-bottom: 1px solid gray; }
      h2 { font: 800 140% sans-serif; border-bottom: 1px solid gray; }
      h3 { font: 700 120% sans-serif }
      h4 { font: bold 100% sans-serif }
      h5 { font: italic 100% sans-serif }
      h6 { font: small-caps 100% sans-serif }

      body { margin: 1em; padding: 1em 4em;  line-height: 1.35; }

      pre { margin-left: 2em; padding: 1em; width: auto; overflow: auto; }
      h1 + h2 { margin-top: 0; }
      h2 { margin: 2.5em 0 1em 0; }
      h2 + h3 { margin-top: 0; }
      h3 { margin: 2em 0 1em 0; }
      h4 { margin: 1.5em 0 0.75em 0; }
      h5, h6 { margin: 1.5em 0 1em; }
      p { margin: 1em 0; }
      dl, dd { margin-top: 0; margin-bottom: 0; }
      dl { margin-left: 2em; }
      dl dd { margin-left: 2em; }
      dt { margin-top: 0.75em; margin-bottom: 0.25em; clear: left; }
      dd dt { margin-top: 0.25em; margin-bottom: 0; }
      dd p { margin-top: 0; }
      p + * > li, dd li { margin: 1em 0; }
      dt, dfn { font-weight: bold; font-style: normal; }
      code { font-size: 1.2em; font-family: monospace; }
      pre strong { color: black; font: inherit; font-weight: bold; background: yellow; }
      pre em { font-weight: bolder; font-style: normal; }
      var sub { vertical-align: bottom; font-size: smaller; position: relative; top: 0.1em; }
      blockquote { margin: 0 0 0 2em; border: 0; padding: 0; font-style: italic; }
      ins { background: green; color: white; /* color: green; border: solid thin lime; padding: 0.3em; line-height: 1.6em; */ text-decoration: none; }
      del { background: maroon; color: white; /* color: maroon; border: solid thin red; padding: 0.3em; line-height: 1.6em; */ text-decoration: line-through; }
      body ins, body del { display: block; }
      body * ins, body * del { display: inline; }

      .groupList li p:first-child { margin: 0; }
      .groupList li p:first-child + p { margin: 0 1em 1em 1em; }

      table.properties { width: 90%; }
      table.properties th { text-align: right; width: 10em; font-weight: normal;}

      table { border-collapse: collapse;  border: none; font-size: inherit; }
      table thead { border-bottom: solid #999999 2px; }
      table td, table th { border-bottom: solid #CCCCCC 1px; vertical-align: top; padding: 0.5em; }

      span.lang { color: #999999; background-color: transparent; font-size: 0.7em; }

      .historyList { font-size: 0.9em; }

      #footer { margin-top: 4em; font-size: 0.8em; font-style: italic; text-align: right; }
    </style>
  </xsl:template>

  <xsl:template name="ResourceList">
    <xsl:param name="properties"/>
    <xsl:param name="label"/>

    <xsl:if test="count($properties)&gt;0">
      <tr>
        <th><xsl:value-of select="$label"/></th>
        <td>
          <xsl:apply-templates select="$properties" mode="property"/>
        </td>
      </tr>
    </xsl:if>
  </xsl:template>

  <xsl:template match="*[@rdf:resource]" mode="property">
    <xsl:variable name="name" select="name(.)"/>

    <xsl:if test="count(preceding-sibling::*[name()=$name])&gt;0">
      <xsl:choose>
        <xsl:when test="count(following-sibling::*[name()=$name])=0">
          <xsl:text> and </xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>, </xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>

    <xsl:call-template name="MakeTermReference">
      <xsl:with-param name="uri" select="@rdf:resource"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="*[owl:Class]" mode="property">
    <xsl:variable name="name" select="name(.)"/>

    <xsl:if test="count(preceding-sibling::*[name()=$name])&gt;0">
      <xsl:choose>
        <xsl:when test="count(following-sibling::*[name()=$name])=0">
          <xsl:text> and </xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>, </xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>

    <xsl:apply-templates select="owl:Class" mode="reference"/>
  </xsl:template>

  <xsl:template match="*" mode="property">
    <xsl:if test="count(preceding-sibling::*)&gt;0">
      <xsl:choose>
        <xsl:when test="count(following-sibling::*)=0">
          <xsl:text> and </xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>, </xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>

    <xsl:text>(a composite term, see schema)</xsl:text>
  </xsl:template>

  <xsl:template match="owl:Class" mode="reference">
    <!-- Describes a reference to an owl:Class -->
    <xsl:choose>
      <xsl:when test="owl:unionOf[@rdf:parseType='Collection']/owl:Class">
        <xsl:text>Union of </xsl:text>
        <xsl:apply-templates mode="reference"/>
      </xsl:when>
      <xsl:when test="owl:intersectionOf[@rdf:parseType='Collection']/owl:Class">
        <xsl:text>Intersection of </xsl:text>
        <xsl:apply-templates mode="reference"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>(composite term, see schema)</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="owl:unionOf/owl:Class" mode="reference">
    <!-- Describes a reference to an owl:Class that is part of a union with other classes -->
    <xsl:if test="count(preceding-sibling::*)&gt;0">
      <xsl:choose>
        <xsl:when test="count(following-sibling::*)=0">
          <xsl:text> or a </xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>, </xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>

    <xsl:call-template name="MakeTermReference">
      <xsl:with-param name="uri" select="@rdf:about"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="owl:intersectionOf/owl:Class" mode="reference">
    <!-- Describes a reference to an owl:Class that is part of an intersection with other classes -->
    <xsl:if test="count(preceding-sibling::*)&gt;0">
      <xsl:choose>
        <xsl:when test="count(following-sibling::*)=0">
          <xsl:text> and </xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>, </xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>

    <xsl:choose>
      <xsl:when test="owl:complementOf/@rdf:resource">
        <xsl:text>everything that is not a </xsl:text>
        <xsl:call-template name="MakeTermReference">
          <xsl:with-param name="uri" select="owl:complementOf/@rdf:resource"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="MakeTermReference">
          <xsl:with-param name="uri" select="@rdf:about"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="owl:intersectionOf/owl:Restriction" mode="reference">
    <xsl:if test="count(preceding-sibling::*)&gt;0">
      <xsl:choose>
        <xsl:when test="count(following-sibling::*)=0">
          <xsl:text> and </xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>, </xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>

    <xsl:text> things that have </xsl:text>

    <xsl:choose>
      <xsl:when test="owl:minCardinality">
        <xsl:text> at least </xsl:text>
        <xsl:value-of select="owl:minCardinality"/>
        <xsl:text> </xsl:text>
        <xsl:call-template name="MakeTermReference">
          <xsl:with-param name="uri" select="owl:onProperty/@rdf:resource"/>
        </xsl:call-template>
        <xsl:text> property</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        (a complex restriction, see schema)
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="CapitalizeFirstLetter">
    <xsl:param name="text"/>

    <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
    <xsl:variable name="lowercase" select="'abcdefghijklmnopqrstuvwxyz'"/>

    <xsl:value-of select="concat(translate(substring($text, 1, 1), $lowercase, $uppercase), substring($text, 2))"/>
  </xsl:template>

  <xsl:template name="Uncapitalize">
    <xsl:param name="text"/>

    <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
    <xsl:variable name="lowercase" select="'abcdefghijklmnopqrstuvwxyz'"/>

    <xsl:value-of select="translate($text, $uppercase, $lowercase)"/>
  </xsl:template>

  <xsl:template name="CcTerm">
    <xsl:param name="uri"/>

    <xsl:value-of select="document('http://creativecommons.org/schema.rdf')/*/*[@rdf:about=$uri]/rdfs:comment"/>
    (<a href="{$uri}"><xsl:value-of select="$uri"/></a>)
  </xsl:template>

  <xsl:template name="RemoveTimeZone">
    <xsl:param name="date"/>

    <xsl:value-of select="substring($date,1,10)"/>
  </xsl:template>

  <xsl:template name="TermName">
    <xsl:param name="uri"/>

    <xsl:choose>
      <xsl:when test="contains($uri, '#')">
        <xsl:value-of select="substring-after($uri, '#')"/>
      </xsl:when>
      <xsl:when test="contains($uri, '/')">
        <xsl:call-template name="TermName">
          <xsl:with-param name="uri" select="substring-after($uri, '/')"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$uri"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="MakeTermReference">
    <xsl:param name="uri"/>

    <xsl:choose>
      <xsl:when test="$uri">
        <xsl:variable name="term-qname">
          <xsl:choose>
            <xsl:when test="starts-with($uri, $namespace) and count(//*[@rdf:about=$identifier]/vann:preferredNamespacePrefix )">
              <xsl:value-of select="//*[@rdf:about=$identifier]/vann:preferredNamespacePrefix"/>
              <xsl:text>:</xsl:text>
              <xsl:value-of select="substring-after($uri, $namespace)"/>
            </xsl:when>
            <xsl:when test="starts-with($uri, 'http://www.w3.org/2001/XMLSchema#')">
              <xsl:text>xsd:</xsl:text>
              <xsl:value-of select="substring-after($uri, 'http://www.w3.org/2001/XMLSchema#')"/>
            </xsl:when>
            <xsl:when test="starts-with($uri, 'http://www.w3.org/1999/02/22-rdf-syntax-ns#')">
              <xsl:text>rdf:</xsl:text>
              <xsl:value-of select="substring-after($uri, 'http://www.w3.org/1999/02/22-rdf-syntax-ns#')"/>
            </xsl:when>
            <xsl:when test="starts-with($uri, 'http://www.w3.org/2000/01/rdf-schema#')">
              <xsl:text>rdfs:</xsl:text>
              <xsl:value-of select="substring-after($uri, 'http://www.w3.org/2000/01/rdf-schema#')"/>
            </xsl:when>
            <xsl:when test="starts-with($uri, 'http://www.w3.org/2002/07/owl#')">
              <xsl:text>owl:</xsl:text>
              <xsl:value-of select="substring-after($uri, 'http://www.w3.org/2002/07/owl#')"/>
            </xsl:when>
            <xsl:when test="starts-with($uri, 'http://www.w3.org/2004/02/skos/core#')">
              <xsl:text>skos:</xsl:text>
              <xsl:value-of select="substring-after($uri, 'http://www.w3.org/2004/02/skos/core#')"/>
            </xsl:when>
            <xsl:when test="starts-with($uri, 'http://www.w3.org/ns/adms#')">
              <xsl:text>adms:</xsl:text>
              <xsl:value-of select="substring-after($uri, 'http://www.w3.org/ns/adms#')"/>
            </xsl:when>
            <xsl:when test="starts-with($uri, 'http://purl.org/vocab/vann/')">
              <xsl:text>vann:</xsl:text>
              <xsl:value-of select="substring-after($uri, 'http://purl.org/vocab/vann/')"/>
            </xsl:when>
            <xsl:when test="starts-with($uri, 'http://www.w3.org/2003/06/sw-vocab-status/ns#')">
              <xsl:text>status:</xsl:text>
              <xsl:value-of select="substring-after($uri, 'http://www.w3.org/2003/06/sw-vocab-status/ns#')"/>
            </xsl:when>
            <xsl:when test="starts-with($uri, 'http://purl.org/dc/elements/1.1/')">
              <xsl:text>dc:</xsl:text>
              <xsl:value-of select="substring-after($uri, 'http://purl.org/dc/elements/1.1/')"/>
            </xsl:when>
            <xsl:when test="starts-with($uri, 'http://purl.org/dc/terms/')">
              <xsl:text>dcterms:</xsl:text>
              <xsl:value-of select="substring-after($uri, 'http://purl.org/dc/terms/')"/>
            </xsl:when>
            <xsl:when test="starts-with($uri, 'http://creativecommons.org/ns#')">
              <xsl:text>cc:</xsl:text>
              <xsl:value-of select="substring-after($uri, 'http://creativecommons.org/ns#')"/>
            </xsl:when>
            <xsl:when test="starts-with($uri, 'http://xmlns.com/foaf/0.1/')">
              <xsl:text>foaf:</xsl:text>
              <xsl:value-of select="substring-after($uri, 'http://xmlns.com/foaf/0.1/')"/>
            </xsl:when>
            <xsl:when test="starts-with($uri, 'http://www.w3.org/2003/01/geo/wgs84_pos#')">
              <xsl:text>geo:</xsl:text>
              <xsl:value-of select="substring-after($uri, 'http://www.w3.org/2003/01/geo/wgs84_pos#')"/>
            </xsl:when>
            <xsl:when test="starts-with($uri, 'http://www.w3.org/2006/time#')">
              <xsl:text>time:</xsl:text>
              <xsl:value-of select="substring-after($uri, 'http://www.w3.org/2006/time#')"/>
            </xsl:when>
            <xsl:when test="starts-with($uri, 'http://purl.org/goodrelations/v1#')">
              <xsl:text>gr:</xsl:text>
              <xsl:value-of select="substring-after($uri, 'http://purl.org/goodrelations/v1#')"/>
            </xsl:when>
            <xsl:when test="starts-with($uri, 'http://www.productontology.org/id/')">
              <xsl:text>pto:</xsl:text>
              <xsl:value-of select="substring-after($uri, 'http://www.productontology.org/id/')"/>
            </xsl:when>
            <xsl:when test="starts-with($uri, 'http://dbpedia.org/ontology/')">
              <xsl:text>dbpedia:</xsl:text>
              <xsl:value-of select="substring-after($uri, 'http://dbpedia.org/ontology/')"/>
            </xsl:when>
            <xsl:when test="starts-with($uri, 'http://dbpedia.org/class/yago/')">
              <xsl:text>yago:</xsl:text>
              <xsl:value-of select="substring-after($uri, 'http://dbpedia.org/class/yago/')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$uri"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>

        <xsl:choose>
          <xsl:when test="//*[@rdf:about=$uri]/skos:prefLabel | //*[@rdf:about=$uri]/rdfs:label">
            <xsl:variable name="term-name">
              <xsl:call-template name="TermName">
                <xsl:with-param name="uri" select="$uri"/>
              </xsl:call-template>
            </xsl:variable>
            <a>
              <xsl:attribute name="href"><xsl:text>#term-</xsl:text><xsl:value-of select="$term-name"/></xsl:attribute>
              <xsl:attribute name="title"><xsl:value-of select="$uri"/></xsl:attribute>
              <xsl:value-of select="$term-qname"/>
            </a>
          </xsl:when>
          <xsl:otherwise>
            <a>
              <xsl:attribute name="href"><xsl:value-of select="$uri"/></xsl:attribute>
              <xsl:value-of select="$term-qname"/>
            </a>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>(composite term ref, see schema)</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>