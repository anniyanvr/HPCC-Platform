<?xml version="1.0" encoding="UTF-8"?>
<!--
################################################################################
#    HPCC SYSTEMS software Copyright (C) 2012 HPCC Systems.
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.
################################################################################
-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xml:space="default">
<xsl:param name="process" select="'unknown'"/>
  
<xsl:strip-space elements="*"/>
<xsl:output method="text" indent="no" omit-xml-declaration="yes"/>
   
<xsl:template match="text()"/>
   
    <xsl:template match="/">
        <xsl:apply-templates select="Environment/Software/RoxieCluster[@name=$process]"/>
    </xsl:template>
   
   <xsl:template match="RoxieCluster">
      <xsl:if test="@name=$process"># roxievars file generated by roxievars_linux.xsl
export roxiedir=<xsl:call-template name="makeAbsolutePath"><xsl:with-param name="path" select="@directory"/></xsl:call-template>
export querydir=<xsl:call-template name="makeAbsolutePath"><xsl:with-param name="path" select="@queryDir"/></xsl:call-template>
export logdir=<xsl:choose>
                <xsl:when test="@logDir">
                    <xsl:call-template name="makeAbsolutePath"><xsl:with-param name="path" select="@logDir"/></xsl:call-template>
                </xsl:when>
                <xsl:otherwise>/c$/roxie_logs</xsl:otherwise>
            </xsl:choose>
       </xsl:if>
<xsl:variable name="MaxFilesOpen" select="2*(@maxLocalFilesOpen+@maxRemoteFilesOpen)"/>
<xsl:variable name="NumHandles">
    <xsl:choose>
        <xsl:when test="$MaxFilesOpen > 8192">
            <xsl:value-of select="$MaxFilesOpen"/>
        </xsl:when>
        <xsl:otherwise>8192</xsl:otherwise>
    </xsl:choose>
</xsl:variable>
export NUM_ROXIE_HANDLES=<xsl:value-of select="$NumHandles"/>
<xsl:if test="string(@SSHidentityfile) != ''">
export SSHidentityfile=<xsl:value-of select="@SSHidentityfile"/>
</xsl:if>
<xsl:if test="string(@SSHusername) != ''">
export SSHusername=<xsl:value-of select="@SSHusername"/>
</xsl:if>
<xsl:if test="string(@SSHpassword) != ''">
export SSHpassword=<xsl:value-of select="@SSHpassword"/>
</xsl:if>
<xsl:if test="string(@SSHtimeout) != ''">
export SSHtimeout=<xsl:value-of select="@SSHtimeout"/>
</xsl:if>
<xsl:if test="string(@SSHretries) != ''">
export SSHretries=<xsl:value-of select="@SSHretries"/>
</xsl:if>
<xsl:if test="string(@SSHsudomount) != ''">
export SSHsudomount=<xsl:value-of select="@SSHsudomount"/>
</xsl:if>
   </xsl:template>

    <xsl:template name="makeAbsolutePath">
        <xsl:param name="path"/>
        <xsl:variable name="newPath" select="translate($path, '\:', '/$')"/>
       <xsl:if test="not(starts-with($newPath, '/'))">/</xsl:if>            
       <xsl:value-of select="$newPath"/>
    </xsl:template>

</xsl:stylesheet>
