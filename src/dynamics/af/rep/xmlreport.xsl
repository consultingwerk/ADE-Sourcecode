<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
  <xsl:template match="/">
    <html>
      <head>
        <title>
          <xsl:value-of select="@title"/>
        </title>
        <style>
          .titlemain {background-color:lightgrey; font-size:small}
          .titledate {align:right; background-color:white; font-size:10}
          .tablemain {font-family:Lucida Console; font-size:small}
          .tableheader {background-color:white;font-family:Arial;font-weight:bold}
          .datacharacter {font-family:Arial; font-size:smaller}
          .datanumeric {font-family:Lucida Console; font-size:smaller}
        </style>
        <script language="JScript"><![CDATA[
     
        // Declare the global variables
        var XSLSource = new Object();          
        var XMLSource = new Object();
       
        // Get the XML and XSL documents
        XMLSource = document.XMLDocument;
        XSLSource = document.XSLDocument;
 
        function sortit (sortfield, datatype) {
        
          // Declare the variables
          var XSLSort = new  Object();            
          
          // Find the sort xsl:sort
          XSLSort = XSLSource.documentElement.selectNodes("//xsl:sort");
       
          // Determine the sort order
          if (XSLSort[0].attributes(0).text == sortfield.toString()){
            if ( XSLSort[0].attributes(1).text == "ascending") {
              XSLSort[0].attributes(1).text = "descending";
            } else {
              XSLSort[0].attributes(1).text = "ascending";
            }
          } else {
            XSLSort[0].attributes(1).text = "ascending";
          }
          // Set the sort field
          XSLSort[0].attributes(0).text = sortfield.toString();
          // Set the sort Datatype
          if (datatype.toString() == "character") {
            XSLSort[0].attributes(2).text = "text";
          } else {
            XSLSort[0].attributes(2).text = "number";
          }
          
          // Render the page
          document.body.innerHTML = XMLSource.transformNode(XSLSource);
        }]]></script>
      </head>
      <body>
        <!-- Page Title -->
        <table width="100%" border="0" cellspacing="0" cellpadding="3" style="font-family:Arial">
          <tr>
            <th class="titlemain" width="70%">
              <xsl:value-of select="report/@title"/>
            </th>
            <th class="titledate">
              <xsl:value-of select="report/@date"/> @ 
                <xsl:value-of select="report/@time"/> - 
                <xsl:value-of select="report/@user"/>
            </th>
          </tr>
        </table>
        <!-- Schema fields -->
        <table class="tablemain" border="0" cellspacing="5">
          <!-- Create columns -->
          <xsl:for-each select="report/header/field">
            <xsl:choose>
              <xsl:when test="@DATA-TYPE='character'">
                <col class="datacharacter" align="left"/>
              </xsl:when>
              <xsl:otherwise>
                <col class="datanumeric" align="right"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:for-each>
          <!-- Create column header labels -->
          <tr valign="baseline">
            <xsl:for-each select="report/header/field">
              <th id="SchemaColumn{@NAME}" onclick="javascript:sortit('{@NAME}','{@DATA-TYPE}');">
                <table class="tableheader" width="100%" border="0" cellspacing="1">
                  <td>
                    <xsl:choose>
                      <xsl:when test="string-length(text())!=0">
                        <xsl:value-of select="."/>
                      </xsl:when>
                      <xsl:otherwise>
                            
                      </xsl:otherwise>
                    </xsl:choose>
                  </td>
                </table>
              </th>
            </xsl:for-each>
          </tr>
          <!-- Data values -->
          <xsl:apply-templates select="report/data/record">
            <xsl:sort select="_nosorting_" order="ascending" data-type="text"/>
          </xsl:apply-templates>
          <!-- Filters -->
          <xsl:apply-templates select="extract/filter"/>
        </table>
      </body>
    </html>
  </xsl:template>
  <!-- Template for data values -->
  <xsl:template match="record">
    <tr>
      <xsl:for-each select="*">
        <td>
          <xsl:value-of select="."/>
        </td>
      </xsl:for-each>
    </tr>
  </xsl:template>
  <!-- Template for filters  -->
  <xsl:template match="filter">
    <tr/><td/>
    <tr/><td/>
    <tr class="tableheader">
      <td>Filters</td>
    </tr>
    <xsl:for-each select="*">
      <tr>
        <td>
          <xsl:value-of select="name()"/>
        </td>
        <td>
          <xsl:value-of select="."/>
        </td>
      </tr>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>

