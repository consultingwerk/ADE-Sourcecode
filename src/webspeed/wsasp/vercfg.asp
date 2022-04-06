<%

Dim objAgent
Dim custErrHtmlPage
custErrHtmlPage = ""

On Error Resume Next

If IsEmpty(Session("Agent")) Then
	Set objAgent = Server.CreateObject("WSASP.WSAgent")
	If Err Then
		strLog = "WSAgent CreateObject: ERROR " & Err.Number 
	Else
		Set Session("Agent") = objAgent
		strLog = "WSAgent CreateObject: Successful<BR>"
		strLog = strLog & "Version: " & objAgent.Version 
	End If
	Session("Create") = strLog
Else
	Set objAgent = Session("Agent")
End If

Select Case Request("Level")

Case "1"
	strLog = objAgent.VerifyConfig("1")
	Session("Level1") = strLog
Case "2"
	If Request("Service") = "(Default)" Then
		objAgent.ServiceName = ""
	Else
		objAgent.ServiceName = Request("Service")
	End If
	strLog = objAgent.VerifyConfig("2")
	Session("Level2") = strLog
Case "3"
	If Request("Service") = "(Default)" Then
		objAgent.ServiceName = ""
	Else
		objAgent.ServiceName = Request("Service")
	End If
	objAgent.RunScript "/Ping"
	Session("Level3") = objAgent.Output
End Select

If Request.QueryString = "ProcessErrMsgs" Then
	objAgent.ProcessErrorMessages
	custErrHtmlPage = objAgent.Output
End If
%>

<HTML>
<HEAD><TITLE>WebSpeed Active Server Messenger Configuration Page</TITLE></HEAD>
<BODY BGCOLOR="#FFFFCC" TEXT="#000000" LINK="#660066" VLINK="#99000">
<style><!--
	BODY  {font-family: "Verdana, Arial, Helvetica"; font-size: 10pt; color: 000000}
	A:link {font-family: "Verdana, Arial, Helvetica"; font-size: 10pt; color: 000000; font-weight: bold}
	A:visited {font-family: "Verdana, Arial, Helvetica"; font-size: 10pt; color: 808080; font-weight: bold}
	STRONG {font-family: "Verdana, Arial, Helvetica"; font-size: 10pt; color: 003366; text-decoration: none}
	BIG {font-family: "Verdana, Arial, Helvetica"; font-size: 8pt; color: 000000; text-decoration: none}
	H1  {font-family: "Times"; font-size: 18pt; color: 000000}
	H2  {font-family: "Times"; font-size: 14pt; color: 000000}--></style>

<H1><CENTER>WebSpeed Configuration and Verification Page</CENTER></H1>
<img src="./images/contline.gif" align="bottom" width="100%">

<CENTER>
<TABLE BORDER=0 CELLSPACING=10 CELLPADDING=0 WIDTH="90%">

<!-- Security Info -->
<%
	'See if we have security on this page
	If Request.ServerVariables("REMOTE_USER") = "" Then
%>
		<TR VALIGN="top" ALIGN="left">
		<TD COLSPAN=2>
		<H2><CENTER> Security Alert! </CENTER></H2>
		</TD>
		<TR VALIGN="top" ALIGN="left">
		<TD WIDTH="10%"><img src="./images/trffc14.gif" align="bottom"></TD>
		<TD><!-- <TD WIDTH="90%"> -->
		You currently have no security set on this Active Server Page. This will allow any user 
		to come in and view your server configuration and modify any custom error pages you may 
		have generated. It is strongly reccomended that set up access security to this page. You 
		can do that by following these steps:<br>
		<OL TYPE="1">
		<LI>Create a new directory under the server’s Document Root.</LI>
		<LI>Using INETMGR, create a new virtual directory for this directory. Be sure to give 
		this directory Execute and Read permission.</LI>
		<LI>Using NT Explorer, modify the permissions for this directory to only include the 
		users and groups who you want to access this application. Be sure to remove the Everyone and
		anonymous user account (IUSR_*) IIS created.</LI>
		<LI>Move the contents of 
		<%	wsaspPath= server.mappath(Request.ServerVariables("PATH_INFO"))
			aspPage = InstrRev(wsaspPath, "\")
			Response.Write Left(wsaspPath, aspPage)
		%>
		, including subdirectories, to your new directorty.</LI>
		<LI>Using INETMGR, make sure that Basic and/or NT Challenger/Response password authentication 
		is enabled. WARNING! If you do not use Interenet Explore as your browser, you must allow 
		Basic authentication to be enabled. This will cause NT user accounts and passwords to be 
		transmitted across the network as clear text.</LI>
		</TD>
		</TR>
<%
	End If
%>

<!-- Client info section -->
<TD COLSPAN=2>
<H2><CENTER> WebSpeed Client Information </CENTER></H2>
</TD>
<TR VALIGN="top" ALIGN="left">
<TD WIDTH="10%">&nbsp;</TD>
<TD WIDTH="90%"> 
<% Set bc = Server.CreateObject("MSWC.BrowserType") %>
<STRONG>User Account:</STRONG> <%= Request.ServerVariables("LOGON_USER")%><BR>
<STRONG>Authorization Type: </STRONG> <%=Request.ServerVariables("AUTH_TYPE")%><BR> 
<STRONG>Remote Hostname: </STRONG> <%= Request.ServerVariables("REMOTE_HOST")%><BR>
<STRONG>Remote Address: </STRONG> <%= Request.ServerVariables("REMOTE_ADDR")%><BR>
<STRONG>Browser Type: </STRONG> <%= bc.Browser %><BR>
<STRONG>Browser Version: </STRONG> <%= bc.Version %><BR>
<% 
	a = CBool(bc.VBScript)
	If Err Then 
%>
<BR>
You are using an outdated version of Browser.ini. You can obtain an updated version
on the <A HREF="http://www.browscap.com">cyScape Web Site</A>

<% Else %>
<STRONG>Frames: </STRONG> <%= CStr(CBool(bc.Frames)) %><BR>
<STRONG>Tables: </STRONG> <%= CStr(CBool(bc.Tables)) %><BR>
<STRONG>Cookies: </STRONG> <%= CStr(CBool(bc.cookies)) %><BR>
<STRONG>Background Sounds: </STRONG> <%= CStr(CBool(bc.BackgroundSounds)) %><BR>
<STRONG>VBScript: </STRONG> <%= CStr(CBool(bc.VBScript)) %><BR>
<STRONG>JavaScript: </STRONG> <%= CStr(CBool(bc.Javascript)) %><BR>
<% End If %>
</TD></TR>

<!-- Verification section -->
<TR VALIGN="top" ALIGN="left">
<TD COLSPAN=2>
<H2><CENTER> WebSpeed Verification Tests </CENTER></H2>
</TD>
<TR VALIGN="top" ALIGN="center">
<TD COLSPAN=2>
<img src="./images/contline.gif" align="bottom" width="100%">
</TD>

<!-- Icon -->
<TR VALIGN="top" ALIGN="left">
<TD WIDTH="10%"><img src="./images/config.gif" align="bottom"></TD>
<TD WIDTH="90%">

<!-- Configuration Info Table -->
<TABLE BORDER=1 CELLSPACING=0 CELLPADDING=0 WIDTH="100%">
<TR VALIGN="top" ALIGN="left">
<TH WIDTH="40%">Description</TH><TH WIDTH="60%">Results</TH></TR>

<!-- WSAgent Creation Info -->
<TR VALIGN="top" ALIGN="left">
<TD WIDTH="40%">WSAgent Active Server Component</TD>
<TD WIDTH="60%"><%Response.Write Session("Create") %></TD>
</TR>

<!-- Level 1 Ping -->
<TR VALIGN="top" ALIGN="left">
<TD WIDTH="40%"><BR>
<FORM ACTION=vercfg.asp METHOD="POST">
&nbsp;&nbsp;&nbsp;&nbsp;<INPUT TYPE=SUBMIT VALUE="Messenger Verify"><INPUT TYPE=HIDDEN NAME="Level" VALUE="1">
<BR>Round trip test from the Browser to the WSASP Messenger. This test will retrieve configuration information 
from the Messenger regarding what WebSpeed Broker it would use for a full connection.
</FORM></TD>
<TD WIDTH="60%">&nbsp;<%=Session("Level1")%></TD>
</TR>

<!-- Level 2 Ping -->
<TR VALIGN="top" ALIGN="left">
<TD WIDTH="40%"><BR>
<FORM ACTION=vercfg.asp METHOD="POST">
&nbsp;&nbsp;&nbsp;&nbsp;<INPUT TYPE=SUBMIT VALUE="Broker Verify"><INPUT TYPE=HIDDEN NAME="Level" VALUE="2">
<INPUT TYPE=TEXT SIZE=20 MAXLENGTH=20 NAME="Service">
<BR>Round trip test from the Browser to a WebSpeed Broker using the WSASP Messenger. This test instructs the 
Messenger to make a connection to the Broker and report the results.
</FORM></TD>
<TD WIDTH="60%">&nbsp;<%=Session("Level2")%></TD>
</TR>

<!-- Level 3 Ping -->
<TR VALIGN="top" ALIGN="left">
<TD WIDTH="40%"><BR>
<FORM ACTION=vercfg.asp METHOD="POST">
&nbsp;&nbsp;&nbsp;&nbsp;<INPUT TYPE=SUBMIT VALUE="Agent Verify"><INPUT TYPE=HIDDEN NAME="Level" VALUE="3">
<INPUT TYPE=TEXT SIZE=20 MAXLENGTH=20 NAME="Service">
<BR>Round trip test from the Browser to a WebSpeed Agent using the WSASP Messenger. This test instructs the
Messenger to make a connection to the Broker and an available Agent. The Agent reports back Agent information.
</FORM></TD>
<TD WIDTH="60%">&nbsp;<%=Session("Level3")%></TD>
</TR>
</TABLE>
</TR>

<!-- Custom Error Message section -->
<TR VALIGN="top" ALIGN="left">
<TD COLSPAN=2>
<H2><CENTER> WebSpeed Custom Error Messages </CENTER></H2>
</TD>
<TR VALIGN="top" ALIGN="center">
<TD COLSPAN=2>
<img src="./images/contline.gif" align="bottom" width="100%">
</TD>

<!-- Icon -->
<TR VALIGN="top" ALIGN="left">
<TD WIDTH="10%"><img src="./images/trffc14.gif" align="bottom"></TD>
<TD WIDTH="90%">
<%If custErrHtmlPage <> "" Then%>
	<%=custErrHtmlPage%>
<%Else%>
    <%=objAgent.CustomizeErrorMessages%>
<%End If%>
</TD>
</TABLE>
</CENTER>
<BR>
<BR>
<!--#include virtual="/wsasp/srcform.inc"-->
</BODY>
</HTML>
