<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:mods="http://www.loc.gov/mods/v3"
                version="2.0">

   <xsl:output omit-xml-declaration="yes" encoding="UTF-8" method="xml" indent="yes" version="1.0"
	       doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
	       doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>


  <xsl:template match="/">
    <xsl:variable name="allheadlines" select="number(results/@artcount)"/>
    <xsl:variable name="headlines" select="number(count(results/title))"/>
      <html xml:lang="en" xmlns="http://www.w3.org/1999/xhtml">
      <head>
	<title>Princeton Periodicals QC</title>
	<link rel="stylesheet" type="text/css" href="main.css"/>
      </head>
      <body>
	<div id="wrapper">
	  <div id="introduction">
	    <h2>Instructions</h2>

	    <p>Print out this page.</p>

	    <p>Use the following tables to assess the quality of this
	    batch. Errors are counted by <em>character</em>, not by
	    <em>word</em>.  The following are errors:</p>

	<ol>
	  <li>Incorrect characters (e.g., <samp>c</samp> for
	  <samp>e</samp>).</li>

	  <li>Transposed characters (e.g., <samp>teh</samp> for
	  <samp>the</samp>).</li>

	  <li>Missing characters, including missing spaces (e.g.,
	  <samp>tht</samp> for <samp>that</samp> or <samp>isit</samp>
	  for <samp>is it</samp>).</li>

	  <li>Inserted characters, including spaces (e.g., <samp>c
	  at</samp> for <samp>cat</samp>).</li>
	</ol>

	<p>The following are not considered errors:</p>

	<ol>
	  <li>Differences in capitalization (e.g., <samp>pRince</samp>
	  for <samp>Prince</samp>).</li>

	  <li>Extra spaces (e.g., <pre>is    it</pre> for <samp>is
	  it</samp>.</li>

	  <li>Typographical errors present in the original.</li>
	</ol>
	  </div>

	  <xsl:apply-templates />

	  <div id="footer">
<hr/>
	    <p><i>Thanks to Adriane Hanson for developing the instructions and procedure.</i></p>
	  </div>
	</div>
      </body>
      </html>
  </xsl:template>

  <xsl:template match="results">
    <div id="results">
	<h2>Sample Headlines
        <xsl:if test="@batch">
	  <xsl:value-of select="concat(' from ', @batch)"/>
	</xsl:if>
	</h2>
      <xsl:apply-templates />
    </div>
  </xsl:template>

  <xsl:template match="stats">
    <p>
      <xsl:value-of select="/results/@batch"/> contains <xsl:value-of select="totalheadlinecount"/> headlines.  The 
      following sample of <xsl:value-of select="sampleheadlinecount"/> headlines contains 
      <xsl:value-of select="samplecharcount"/> characters.  To match an error rate of 
      <xsl:value-of select="errorrate"/> per cent, this sample can contain no more than
      <strong><xsl:value-of select="maxerrors"/></strong> significant errors.
    </p>
  </xsl:template>

  <xsl:template match="sample">
    <h3>Headlines</h3>
	<p>Article titles are weighted most heavily in searching and
	so must be particularly accurate.</p>

	<ol>
	  <li>Open each article to be tested on the <a
	  href="http://libserv23.princeton.edu/princetonperiodicals/cgi-bin/princetonperiodicals">Princeton Periodicals</a> website.  It may be faster to search for an article title than navigate to it.</li>

	  <li>Check the spelling of each word in the title. Circle
	  errors or highlight them in red.  Record the number of errors in the <samp>error count</samp> box.</li>

	  <li>When you have checked all titles, count the number of
	  character errors and note the total at the bottom of the table.</li>
	</ol>
    <table>
      <thead>
	<tr>
	  <th>#</th>
	  <th>title</th>
	  <th>page</th>
	  <th class="date">date</th>
	  <th>error count</th>
	</tr>
      </thead>
      <tbody>
	<xsl:apply-templates/>
	<tr>
	  <td colspan="4" align="right"><b>Total Number of Errors:</b></td>
	  <td class="fail"><xsl:text> </xsl:text></td>
	</tr>
      </tbody>
    </table>
  </xsl:template>

  <xsl:template match="title">
    <tr>
	<xsl:if test="position() mod 2">
	  <xsl:attribute name="class">shaded</xsl:attribute>
	</xsl:if>
      <td><xsl:value-of select="position()"/></td>
      <td><xsl:value-of select="."/></td>
      <td><xsl:value-of select="./@page"/></td>
      <td><xsl:value-of select="./@date"/></td>
      <td class="fail"><xsl:text> </xsl:text></td>
    </tr>
  </xsl:template>

  <xsl:template match="mastheads">
    <h3>Issue-Level Metadata</h3>

    <ol>
      <li>Open the issue you are going to test on the <a
      href="http://libserv23.princeton.edu/princetonperiodicals/cgi-bin/princetonperiodicals">Princeton Periodicals</a> website.</li>

      <li>Check that the title, volume number, issue number, and date
      in the masthead match what is in the table below.</li>

      <li>Check that the edition number is correct: if there is one
      issue that day, it should be 01.  If there are more, the
      editions are numbered consecutively.  The edition number is not
      printed on the issue. </li>

      <li>Check that the total number of pages is correct, and that
      the pages are in the correct order.  Zoom in enough to read the
      page number and then scroll across.</li>
    </ol>


    <table>
      <thead>
	<tr>
	  <th>#</th>
	  <th>text</th>
	  <th>volume</th>
	  <th>issue</th>
	  <th>date</th>
	  <th class="pass">pass</th>
	  <th class="fail">fail</th>
	</tr>
      </thead>
      <tbody>
	<xsl:for-each select="masthead">
	  <tr>
	    <xsl:if test="position() mod 2">
	      <xsl:attribute name="class">shaded</xsl:attribute>
	    </xsl:if>
	    <td><xsl:value-of select="position()" /></td>
	    <td><xsl:value-of select="." /></td>
	    <td><xsl:value-of select="@volume" /></td>
	    <td><xsl:value-of select="@issue" /></td>
	    <td><xsl:value-of select="@date" /></td>
	    <td class="pass"><xsl:text> </xsl:text></td>
	    <td class="fail"><xsl:text> </xsl:text></td>
	  </tr>
	</xsl:for-each>
      </tbody>
    </table>
  </xsl:template>

  <xsl:template match="zones">
    <h3>Zones</h3>

    <p>Zoning is how the different sections and articles of the newspaper
    are divided and identified.  Articles that are printed on more than
    one page are zoned together as one article.  Advertisements are zoned
    together as a block, by column.</p>

    <ol>
      <li>Open the issue you are going to test on the <a
      href="http://libserv23.princeton.edu/princetonperiodicals/cgi-bin/princetonperiodicals">Newspapers</a>
      website in the issue images view.</li>

      <li>Mouse over each article and confirm that the grey box
      includes all of the right text.  If the article continues on
      another page, both sections should be highlighted when you mouse
      over one.  Common errors are to link the wrong two sections, to
      cut off a few lines that belong at the end of an article, or to
      include the first few lines of the next article.  </li>

      <li>Mouse over each article and confirm that the right article
      title is in the pop up box.  The most common error is that no
      title pops up, but occasionally the wrong title pops up.</li>
    </ol>

    <table>
      <thead>
	<tr>
	  <th>#</th>
	  <th>issue</th>
	  <th class="pass">pass</th>
	  <th class="fail">fail</th>
	</tr>
      </thead>
      <tbody>
	<xsl:for-each select="issue">
	  <tr>
	    <xsl:if test="position() mod 2">
	      <xsl:attribute name="class">shaded</xsl:attribute>
	    </xsl:if>
	    <td><xsl:value-of select="position()" /></td>
	    <td><xsl:value-of select="." /></td>
	    <td class="pass"><xsl:text> </xsl:text></td>
	    <td class="fail"><xsl:text> </xsl:text></td>
	  </tr>
	</xsl:for-each>
      </tbody>
    </table>
  </xsl:template>

  <xsl:template match="articleText">
    <h3>Article Text</h3>

    <p>The vendors are allowed 50 errors per article, so as long as the
    number is not approaching that, it is acceptable to not catch
    absolutely every single error.</p>

    <ol>
      <li>Open the article you are going to test on the <a
      href="http://libserv23.princeton.edu/princetonperiodicals/cgi-bin/princetonperiodicals">Newspapers</a>
      website.</li>

      <li>Click on the article and select "Text of this article" to get the OCR of the article. </li>

      <li>Copy the text to a Word document.  Use spell check to
      identify potential errors.  For each of these, check the
      original text of the article to confirm if it is an error. </li>

      <li>Record the number of character errors in the spreadsheet.
      We will add five errors to this count using a formula once you
      are done checking, which is the average number of errors missed
      by using spell check, so do not include in your count any errors
      you notice that are not highlighted by spell check.</li>

      <li>For articles with a large number of errors (20 or more),
      note what caused the problem.  Examples are: incorrectly
      inserted lines of text, specific characters always incorrectly
      rendered (e.g., <samp>1</samp> for <samp>i</samp>), characters inserted where there is a
      column border, and very long articles with a mix of errors.</li>
    </ol>


    <table>
      <thead>
	<tr>
	  <th>#</th>
	  <th>title</th>
	  <th>page</th>
	  <th class="date">date</th>
	  <th class="pass">pass</th>
	  <th class="fail">fail</th>
	</tr>
      </thead>
      <tbody>
	<xsl:for-each select="title">
	  <tr>
	    <xsl:if test="position() mod 2">
	      <xsl:attribute name="class">shaded</xsl:attribute>
	    </xsl:if>
	    <td><xsl:value-of select="position()"/></td>
	    <td><xsl:value-of select="."/></td>
	    <td><xsl:value-of select="./@page"/></td>
	    <td><xsl:value-of select="./@date"/></td>
	    <td class="pass"><xsl:text> </xsl:text></td>
	    <td class="fail"><xsl:text> </xsl:text></td>
	  </tr>
	</xsl:for-each>
      </tbody>
    </table>
  </xsl:template>

</xsl:stylesheet>
