<?xml version="1.0" encoding="UTF-8"?>
<!--XSLT - документ является XML - документом. --> 
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<!-- Описание XSLT - документа -->
<xsl:template match="/">
<!-- Правило обработки корневого элемента XML - документа -->

<TABLE BORDER="2"> 
    <THEAD>
        <TH>No.</TH>
        <TH>Последовательность</TH>
    </THEAD>
    
    <xsl:for-each select="output/calc/s">
        <TR>
            <TH><xsl:value-of select="@i"/></TH>
            <TD><xsl:value-of select="."/></TD>
        </TR> 
    </xsl:for-each> 
    
    <TR>
        <TH>Ответ</TH>
        <TD><xsl:value-of select="output/ans/s"/></TD>
    </TR>
</TABLE> 

</xsl:template>
</xsl:stylesheet>