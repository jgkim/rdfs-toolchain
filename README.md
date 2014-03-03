rdfs.co Toolchain
=================

Introduction
------------

The documentation for each vocabulary on rdfs.co is built from that vocabulary's RDF schema using a set of XSLT stylesheets and makefiles.

Toolchain Components
--------------------

* **vocab-generate-makefile.xsl:** An XSLT stylesheet that generates makefiles for building documentation of an RDF schema.
* **vocab-htaccess.xsl:** An XSLT stylesheet that generates .htaccess files for the Apache HTTP Server.
* **vocab-html-docs.xsl:** An XSLT stylesheet that styles an RDF schema as XHTML.

Using the Toolchain
-------------------

1. Generate the makefile using vocab-generate-makefile.xsl. This stylesheet takes two parameters:

    * **namespace (required):** The URI of the namespace for the vocabulary (e.g. http://rdfs.co/bevon/)
    * **toolchain-dir (optional):** The directory of the toolchain (defaults to ./toolchain/)

    Apply the stylesheet to the vocabulary RDF schema document. For example:

        xsltproc --param namespace "'http://rdfs.co/bevon/'" bevon.rdf > Makefile-0.6

    (Note how the parameters are enclosed in both types of quotes to ensure that they are passed as text and not interpreted as XPath references.)

    The result is a makefile that contains targets for all the files needed to completely document the vocabulary. I pipe the output to a new makefile for each version of the schema which means I can regenerate the documentation for any version at any time.

2. Run make with the generated makefile. This applies vocab-html-docs.xsl to the schema document for the HTML version of the schema.

    The makefile generates RDF, Turtle and HTML files for the vocabulary. These files are generated in the directory of the version with the short file names (e.g. rdf, ttl, or html).

RDF Schema Constraints
----------------------

The toolchain uses XSLT which operates at the syntactic level on the RDF schemas. This means that the RDF used in the schemas has to be authored in a consistent manner. The first child of the rdf:RDF needs to be an owl:Ontology element. This contains all the metadata about the vocabulary. The most important properties used here are:

* **dcterms:identifier:** Must contain the URI of the current version of the vocabulary without the file extension. (e.g. http://rdfs.co/bevon/0.6)
* **dcterms:isVersionOf:** Must reference the vocabulary namespace URI (e.g. http://rdfs.co/bevon/)
* **vann:preferredNamespacePrefix:** Must contain a short namespace prefix (e.g. bevon)
* **owl:versionInfo:** Must contain the version of the vocabulary (e.g. 0.6)
* **dcterms:hasFormat:** This is used to describe the HTML, RDF and Turtle versions of the vocabulary, for example:

        <dcterms:hasFormat>
          <rdf:Description rdf:about="http://rdfs.co/bevon/0.6/html">
            <dcterms:format>
              <dcterms:IMT>
                <rdf:value>text/html</rdf:value>
                <rdfs:label xml:lang="en">HTML</rdfs:label>
              </dcterms:IMT>
            </dcterms:format>
          </rdf:Description>
        </dcterms:hasFormat>

        <dcterms:hasFormat>
          <rdf:Description rdf:about="http://rdfs.co/bevon/0.6/rdf">
            <dcterms:format>
              <dcterms:IMT>
                <rdf:value>application/rdf+xml</rdf:value>
                <rdfs:label xml:lang="en">RDF/XML</rdfs:label>
              </dcterms:IMT>
            </dcterms:format>
          </rdf:Description>
        </dcterms:hasFormat>

        <dcterms:hasFormat>
          <rdf:Description rdf:about="http://rdfs.co/bevon/0.6/ttl">
            <dcterms:format>
              <dcterms:IMT>
                <rdf:value>text/turtle</rdf:value>
                <rdfs:label xml:lang="en">Turtle</rdfs:label>
              </dcterms:IMT>
            </dcterms:format>
          </rdf:Description>
        </dcterms:hasFormat>

This toolchain was originally authored and released by [Ian Davis](http://iandavis.com) in the public domain. It has been modified by [James G. Kim](http://jayg.org/).

EOD.