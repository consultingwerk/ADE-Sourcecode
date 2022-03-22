<%@ LANGUAGE="VBSCRIPT" %>

<HTML>
<HEAD>
<META NAME="GENERATOR" Content="Microsoft Visual InterDev 1.0">
<META HTTP-EQUIV="Content-Type" content="text/html; charset=iso-8859-1">
<TITLE>WSASP Messenger Example Page</TITLE>
</HEAD>
<BODY BGCOLOR="white">
<center>
<img src="images/sports.jpg">
<p>
<h1>SportsPro Sales Rep Performance</h1><p>

<%	
	'-- Is this our first time here?
	If IsEmpty(Session("ExampleAgent")) Then
		'-- Create our WebSpeed Agent 
		Set SalesReport = Server.CreateObject("WSASP.WSAgent")
		'-- Set the WService to connect 
		SalesReport.ServiceName = "wsbroker1"
		'-- Don't overload user with data
		SalesReport.QueryString = "ResultRows=25"
	Else
		Set SalesReport = Session("ExampleAgent")
	End If

	'-- Call our WebSpeed Script
	SalesReport.RunScript "/src/web/examples/aspexp.p"
	Response.Write SalesReport.Output

	'-- Save our Agent object since we will probably be back here
	Set Session("ExampleAgent") = SalesReport
	
%>
</center>
<BR>
<BR>
<!--#include virtual="/wsasp/srcform.inc"-->
</BODY>
</HTML>
