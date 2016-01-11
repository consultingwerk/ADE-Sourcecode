&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2002 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/
/*--------------------------------------------------------------------------------
  File: icfsite.w

  Description:  Dynamics Site Number allocation
  
  Purpose:      Dynamics Site

  Updated: 02/12/02 pm@mip.co.za
             Initial version
           04/12/02 adams@progress.com
             Cleaned up error messages, added required field markers, added
               POSSE header
           10/31/02 adams@progress.com
             Modified superuser access to Update Site feature

---------------------------------------------------------------------------------*/
/*              This .w file was created with the Progress AppBuilder.           */
/*-------------------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */
CREATE WIDGET-POOL.

&glob xICFCGIWrapper yes

/* ***************************  Definitions  ************************** */

DEFINE VARIABLE cEXWebIDDate      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cEXWebIDSite      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cEXWebIDUser      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cOutBody          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cOutCaption       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cOutColSpan       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cOutColumns       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cOutMessage       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cOutMeta          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cOutSearch        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cOutSubCaption    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cOutTitle         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cSiteSubmit       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cUserSubmit       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cWebAction        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cWebFirst         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cWebIDSite        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cWebIDUser        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cWebLast          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cWebNavigation    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cWebPasswd        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cWebPath          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cWebRun           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cWebSearch        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iBrowseLoop       AS INTEGER    NO-UNDO.
DEFINE VARIABLE iBrowseRows       AS INTEGER    NO-UNDO.
DEFINE VARIABLE iWebLine          AS INTEGER    NO-UNDO.
DEFINE VARIABLE lIsIE             AS LOGICAL    NO-UNDO.
DEFINE VARIABLE lOutNext          AS LOGICAL    NO-UNDO.
DEFINE VARIABLE lOutPrev          AS LOGICAL    NO-UNDO.

DEFINE TEMP-TABLE ttWeb NO-UNDO
  FIELD ttWLine   AS INTEGER
  FIELD ttWValue  AS CHARACTER
  INDEX ittBLine  IS UNIQUE PRIMARY ttWLine ASCENDING.

DEFINE TEMP-TABLE tt_site_number  LIKE rsm_site_number.
DEFINE TEMP-TABLE tt_site         LIKE rsm_site.
DEFINE TEMP-TABLE tt_user         LIKE rsm_user.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&SCOPED-DEFINE PROCEDURE-TYPE Procedure
&SCOPED-DEFINE DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 23.33
         WIDTH              = 52.4.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/web2/wrap-cgi.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ************************  Main Code Block  *********************** */

ASSIGN
  cWebPath = AppUrl
  cWebPath = TRIM(cWebPath,"/":U)
  cWebPath = "/":U + cWebPath + "/":U
  .

ASSIGN
  cEXWebIDDate    = get-value("wEXD":U)
  cEXWebIDSite    = get-value("wEXS":U)
  cEXWebIDUser    = get-value("wEXU":U)
	cSiteSubmit     = get-value("wSiteSubmit":U)
	cUserSubmit     = get-value("wUserSubmit":U)
  cWebAction      = get-value("wAction":U)
  cWebFirst       = get-value("wFirst":U)
  cWebIDSite      = get-value("wIDSite":U)
  cWebIDUser      = get-value("wIDUser":U)
  cWebLast        = get-value("wLast":U)
  cWebNavigation  = get-value("wNavigation":U)
  cWebPasswd      = get-value("wPasswd":U)
  cWebRun         = get-value("wRun":U)
  cWebSearch      = get-value("wSearch":U)
  lIsIE           = INDEX(get-cgi('HTTP_USER_AGENT':U), " MSIE ":U) > 0
  .

RUN verifyID.

ASSIGN
  cOutTitle       = ""
  cOutCaption     = ""
  cOutSubCaption  = ""
  cOutMeta        = ""
  cOutBody        = ""
  cOutColSpan     = ""
  cOutSearch      = ""
  cOutColumns     = ""
  cOutMessage     = ""
  lOutPrev        = NO
  lOutNext        = NO
  iBrowseLoop     = 0
  iBrowseRows     = 20
  .

/* Process the latest Web event. */
RUN processWebRequest.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-displayFrames) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE displayFrames Procedure 
PROCEDURE displayFrames :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  CREATE ttWeb.
  ASSIGN
    cOutTitle = "Dynamics Site Allocation"
    iWebLine  = iWebLine + 1
    ttWLine   = iWebLine
    ttWValue  = '<HTML>~n'
              + '<HEAD>~n'
              + '<TITLE>~n'
              + cOutTitle
              + '</TITLE>~n'
              + '</HEAD>~n'
              + '<FRAMESET NAME="frameSetRows" COLS="280,*" FRAMESPACING="0" FRAMEBORDER="0" BORDERCOLOR="#C0C0C0">~n'
              + '<FRAME NAME="frameIndex" SRC="'
              + cWebPath 
              + 'icfsite.w?wRun=runIndex'
              + '">~n'
              + '<FRAME NAME="frameMain" SRC="'
              + cWebPath 
              + 'icfsite.w?wRun=runMain'
              + '">~n'
              + '</FRAMESET>~n'
              + '</BODY>~n'
              + '</HTML>~n'
              .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-displayHelp) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE displayHelp Procedure 
PROCEDURE displayHelp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  ASSIGN
    cOutTitle   = "Dynamics Help About"
    cOutColSpan = "1"
    .

  RUN setHeader.

  CREATE ttWeb.
  ASSIGN
    iWebLine = iWebLine + 1
    ttWLine  = iWebLine
    ttWValue = '<TR>~n'
             + '<TD>~n'
             + '<BR>~n'
             + '<A HREF="#" ID="ID_top"></A>'
             + '<H3 ALIGN="CENTER"><A HREF="#link_site">Dynamics Sites</A></H3>~n'
             + '<H3 ALIGN="CENTER"><A HREF="#link_number">Dynamics Site Numbers</A></H3>~n'
             + '<HR WIDTH=80%>~n'
             + '<A NAME="link_site"><H2 ALIGN="center">Dynamics Sites</H2></A>~n'
             + '<P>~n'
             + '<H3 ALIGN="CENTER">What is a site?</H3>~n'
             + '</P>~n'
             + '<P>~n'
             + ' A site is a location where the Dynamics software is installed.'
             + ' There are two types of sites: development sites where you develop Dynamics applications,'
             + ' and end-user sites where you deploy Dynamics applications.'
             + ' A site is uniquely identified with a site code that you define.'
             + '</P>~n'
             + '<P>~n'
             + '<H3 ALIGN="CENTER">How do you register a site?</H3>~n'
             + '</P>~n'
             + '<P>~n'
             + ' You register a site in the Site Creation control by entering a site code and other site information and pressing the Register button.'
             + ' If a site already exists with that site code, the control will display a message.'
             + '</P>~n'
             + '<P>~n'
             + '<H3 ALIGN="CENTER">How is my site information used?</H3>~n'
             + '</P>~n'
             + '<P>~n'
             + ' Only site owners and system administrators can access site information.'
             + ' Site detail is for information purposes only.'
             + '</P>~n'
             + '<P>~n'
             + '<H3 ALIGN="CENTER">How is my e-mail address used?</H3>~n'
             + '</P>~n'
             + '<P>~n'
             + ' Using either your e-mail address or site code with your password is the only way you can view or modify your information.'
             + ' Your e-mail address could also be used to send you site number information.'
             + '</P>~n'
             + '<H5 ALIGN="CENTER"><A HREF="#ID_top">(Back to top)</A></H5>~n'
             + '<HR WIDTH=80%>~n'
             + '<A NAME="link_number"><H2 ALIGN="center">Dynamics Site Numbers</H2></A>~n'
             + '<P>~n'
             + '<H3 ALIGN="CENTER">What is a site number?</H3>~n'
             + '</P>~n'
             + '<P>~n'
             + ' A site number uniquely identifies a Dynamics repository and the data it contains.'
             + ' You should set a site number at installation time. Once set, it should not be changed.'
             + ' A site number cannot exceed 10 digits (or 9,999,999,999).'
             + ' You can allocate site numbers for multiple Dynamics repositories at an individual site.'
             + '</P>~n'
             + '<P>~n'.
  ASSIGN
    ttWValue = ttWValue
             + '<H3 ALIGN="CENTER">Why do you need unique site numbers?</H3>~n'
             + '</P>~n'
             + '<P>~n'
             + ' Unique site numbers ensure the integrity of Dynamics repository data among Dynamics sites and applications,'
             + ' worldwide, as well as between versions of Dynamics.'
             + ' They make it possible to combine object data from multiple Dynamics repositories without causing a conflict.'
             + '</P>~n'
             + '<P>~n'
             + ' If you do not register a unique site number for each individual Dynamics repository at your site,'
             + ' deploying object data you created in that repository could cause that data to become lost or corrupted.'
             + '</P>~n'
             + '<P>~n'
             + '<H3 ALIGN="CENTER">How many site numbers do you need?</H3>~n'
             + '</P>~n'
             + '<P>~n'
             + ' You need a site number for each Dynamics repository at an individual site.'
             + '</P>~n'
             + '<P>~n'
             + '<H3 ALIGN="CENTER">How do you register a site number?</H3>~n'
             + '</P>~n'
             + '<P>~n'
             + ' You register one or more site numbers in the Allocate New Site Numbers control by entering a registered site code,'
             + ' and other site number information, and pressing the Register button.'
             + '</P>~n'
             + '<P>~n'
             + ' You may allocate individual site numbers as you need them, or allocate a block of site numbers to keep in reserve.'
             + ' When allocating an individual site number, you can enter a specific site number or let the control automatically generate one for you.'
             + ' When allocating a block of site numbers, you can enter a starting site number value and the number of site numbers you want to allocate.'
             + ' You can also let the control automatically generate a starting site number value for you.'
             + ' If you specify a site number that already exists, the control will display a message.'
             + '</P>~n'
             + '<P>~n'
             + ' <B><U>Note:</U></B> If you are already using a specific site number for a repository, you can try to allocate that same number.'
             + ' If that number has already been allocated for another repository, the control will display a message and you will need to allocate a new number.'
             + '</P>~n'
             + '<H5 ALIGN="CENTER"><A HREF="#ID_top">(Back to top)</A></H5>~n'
             + '</TD>~n'
             + '</TR>~n'
             .

  RUN setFooter.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-displayIndex) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE displayIndex Procedure 
PROCEDURE displayIndex :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cLoginCode        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLoginPassword    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSubmitLogin      AS CHARACTER  NO-UNDO.

  ASSIGN
    cLoginCode         = get-value("wLoginCode":U)
    cLoginPassword     = get-value("wLoginPassword":U)
    cSubmitLogin       = get-value("wSubmitLogin":U)
    .

  blk_Login:
  DO WITH TRANSACTION:
    IF cSubmitLogin = "LOGOUT" THEN
      ASSIGN
        cLoginCode      = ""
        cLoginPassword  = ""
        .

    IF cLoginCode = "" THEN DO:
      ASSIGN
        cOutMessage = 'Enter a Site code or User ID and password to login.' + '<BR>~n'
        cWebIDSite  = ""
        cWebIDUser  = ""
        .
      LEAVE blk_Login.
    END.
    ELSE DO:
      FIND FIRST rsm_site NO-LOCK
        WHERE rsm_site.site_code     = cLoginCode
        AND   rsm_site.site_password = ENCODE(cLoginPassword) NO-ERROR.
      IF AVAILABLE rsm_site THEN
        ASSIGN
          cWebIDSite = rsm_site.site_code
          cWebIDUser = "".
      ELSE DO:
        ASSIGN
          cWebIDSite = "".

        FIND FIRST rsm_user NO-LOCK
          WHERE rsm_user.user_code     = cLoginCode
          AND   rsm_user.user_password = ENCODE(cLoginPassword) NO-ERROR.
        IF AVAILABLE rsm_user THEN
          ASSIGN
            cWebIDUser = rsm_user.user_code
            cWebIDSite = "".
        ELSE
          ASSIGN
            cWebIDUser = "".
      END.
    END.

    IF cWebIDSite = "" AND cWebIDUser = "" THEN DO:
      ASSIGN
        cOutMessage = '<FONT COLOR="red">~n'
                    + 'The Site/User information entered is invalid.  Please correct and try again.'
                    + '</FONT>~n'
                    + '<BR>~n'.
      LEAVE blk_Login.
    END.
    ELSE
      ASSIGN
        cOutMessage   = 'Login Successful'
                      + '<BR>~n'
                      .
  END.

  ASSIGN
    cOutTitle     = "Dynamics Index"
    cEXWebIDUser  = ENCODE(cWebIDUser)
    cEXWebIDSite  = ENCODE(cWebIDSite)
    cEXWebIDDate  = ENCODE(STRING(TODAY))
    .

  CREATE ttWeb.
  ASSIGN
    iWebLine = iWebLine + 1
    ttWLine  = iWebLine
    ttWValue = '<HTML>~n'
             + '<HEAD>~n'
             + '<TITLE>~n'
             + cOutTitle
             + '</TITLE>~n'
             + '</HEAD>~n'
             + '<BODY COLOR="000000" BGCOLOR="C0C0C0" TEXT="000000">~n'
             + '<FORM METHOD="post" ACTION="icfsite.w">~n'
             + '<INPUT TYPE="hidden" NAME="wIDUser" VALUE="' + cWebIDUser   + '">~n'
             + '<INPUT TYPE="hidden" NAME="wIDSite" VALUE="' + cWebIDSite   + '">~n'
             + '<INPUT TYPE="hidden" NAME="wRun"    VALUE="' + cWebRun      + '">~n'
             + '<INPUT TYPE="hidden" NAME="wAction" VALUE="' + cWebAction   + '">~n'
             + '<TABLE BORDER="1" CELLSPACING="0" CELLPADDING="2" WIDTH="100%" BGCOLOR="#CDCDCD">~n'
             + '<THEAD>~n'
             + '<TR>~n'
             + '<TH ALIGN="CENTER" BGCOLOR="000080">~n'
             + '<FONT COLOR="FFFFFF" SIZE="4">~n'
             + cOutTitle
             + '</FONT>~n'
             + '</TH>~n'
             + '</TR>~n'
             + '</THEAD>~n'
             + '<TBODY>~n'
             + '<TR>~n'
             + '<TD BGCOLOR="CCCCCC" VALIGN="MIDDLE">~n'
             .

  CREATE ttWeb.
  ASSIGN
    iWebLine = iWebLine + 1
    ttWLine  = iWebLine
    ttWValue = '&nbsp;<B><U>Sites</U></B>~n'
             .

  CREATE ttWeb.
  ASSIGN
    iWebLine = iWebLine + 1
    ttWLine  = iWebLine
    ttWValue = '<LI><A TARGET="frameMain" HREF="'
             + cWebPath 
             + 'icfsite.w?wEXU=' + cEXWebIDUser + '&wEXS=' + cEXWebIDSite + '&wEXD=' + cEXWebIDDate + '&wRun=runSiteMasterControl&wAction=actionNewSite">Register Site</A>~n'
             .

  IF cWebIDUser <> "" OR cWebIDSite <> "" THEN DO:
    CREATE ttWeb.
    ASSIGN
      iWebLine = iWebLine + 1
      ttWLine  = iWebLine
      ttWValue = '<LI><A TARGET="frameMain" HREF="'
               + cWebPath
               + 'icfsite.w?wEXU=' + cEXWebIDUser + '&wEXS=' + cEXWebIDSite + '&wEXD=' + cEXWebIDDate + '&wRun=runSiteMasterControl&wAction=actionModifySite">Update Site</A>~n'
               .
  END.

  IF cWebIDUser <> "" THEN DO:
    CREATE ttWeb.
    ASSIGN
      iWebLine = iWebLine + 1
      ttWLine  = iWebLine
      ttWValue = '<LI><A TARGET="frameMain" HREF="'
               + cWebPath 
               + 'icfsite.w?wEXU=' + cEXWebIDUser + '&wEXS=' + cEXWebIDSite + '&wEXD=' + cEXWebIDDate + '&wRun=runSiteMasterQuery">List Sites</A>~n'
               .
  END.

  /* Site Numbers */
  CREATE ttWeb.
  ASSIGN
    iWebLine = iWebLine + 1
    ttWLine  = iWebLine
    ttWValue = '<HR WIDTH=90%>~n'
             + '&nbsp;<B><U>Site Numbers</U></B>~n'
             .

  CREATE ttWeb.
  ASSIGN
    iWebLine = iWebLine + 1
    ttWLine  = iWebLine
    ttWValue = '<LI><A TARGET="frameMain" HREF="'
             + cWebPath 
             + 'icfsite.w?wEXU=' + cEXWebIDUser + '&wEXS=' + cEXWebIDSite + '&wEXD=' + cEXWebIDDate + '&wRun=runSiteNumberControl">Register Site Numbers</A>~n'
             + '<BR>&nbsp;'
             .

  IF cWebIDUser <> "" THEN DO:
    CREATE ttWeb.
    ASSIGN
      iWebLine = iWebLine + 1
      ttWLine  = iWebLine
      ttWValue = '<LI><A TARGET="frameMain" HREF="'
               + cWebPath 
               + 'icfsite.w?wEXU=' + cEXWebIDUser + '&wEXS=' + cEXWebIDSite + '&wEXD=' + cEXWebIDDate + '&wRun=runSiteNumberReAssign">Re-Assign Site Numbers</A>~n'
               .
  END.

  IF cWebIDUser <> "" THEN DO:
    CREATE ttWeb.
    ASSIGN
      iWebLine = iWebLine + 1
      ttWLine  = iWebLine
      ttWValue = '<LI><A TARGET="frameMain" HREF="'
               + cWebPath 
               + 'icfsite.w?wEXU=' + cEXWebIDUser + '&wEXS=' + cEXWebIDSite + '&wEXD=' + cEXWebIDDate + '&wRun=runSiteNumberQuerySite">List Numbers by Owning Site</A>~n'
               .
  END.

  IF cWebIDUser <> "" OR cWebIDSite <> "" THEN DO:
    CREATE ttWeb.
    ASSIGN
      iWebLine = iWebLine + 1
      ttWLine  = iWebLine
      ttWValue = '<LI><A TARGET="frameMain" HREF="'
               + cWebPath 
               + 'icfsite.w?wEXU=' + cEXWebIDUser + '&wEXS=' + cEXWebIDSite + '&wEXD=' + cEXWebIDDate + '&wRun=runSiteNumberQueryNum">List Numbers by Site Number</A>~n'
               .
  END.

  IF cWebIDUser <> "" THEN DO:
    CREATE ttWeb.
    ASSIGN
      iWebLine = iWebLine + 1
      ttWLine  = iWebLine
      ttWValue = '<HR WIDTH=90%>~n'
               + '&nbsp;<B><U>Users</U></B>~n'
               + '<LI><A TARGET="frameMain" HREF="'
               + cWebPath 
               + 'icfsite.w?wEXU=' + cEXWebIDUser + '&wEXS=' + cEXWebIDSite + '&wEXD=' + cEXWebIDDate + '&wRun=runSiteUserControl&wAction=actionModifyUser">Update User</A>~n'
               + '<LI><A TARGET="frameMain" HREF="'
               + cWebPath 
               + 'icfsite.w?wEXU=' + cEXWebIDUser + '&wEXS=' + cEXWebIDSite + '&wEXD=' + cEXWebIDDate + '&wRun=runSiteUserControl&wAction=actionNewUser">Register User</A>~n'
               + '<LI><A TARGET="frameMain" HREF="'
               + cWebPath 
               + 'icfsite.w?wEXU=' + cEXWebIDUser + '&wEXS=' + cEXWebIDSite + '&wEXD=' + cEXWebIDDate + '&wRun=runSiteUserQuery">List Users</A>~n'
               .
  END.

  CREATE ttWeb.
  ASSIGN
    iWebLine = iWebLine + 1
    ttWLine  = iWebLine
    ttWValue = '<HR WIDTH=90%>~n'
             + '<LI><A TARGET="frameMain" HREF="'
             + cWebPath 
             + 'icfsite.w?wEXU=' + cEXWebIDUser + '&wEXS=' + cEXWebIDSite + '&wEXD=' + cEXWebIDDate + '&wRun=runMain">Home</A>~n'
             + '<LI><A TARGET="frameMain" HREF="'
             + cWebPath 
             + 'icfsite.w?wEXU=' + cEXWebIDUser + '&wEXS=' + cEXWebIDSite + '&wEXD=' + cEXWebIDDate + '&wRun=runHelp">Help About</A>~n'
             + '<BR>&nbsp;'
             .

  CREATE ttWeb.
  ASSIGN
    iWebLine = iWebLine + 1
    ttWLine  = iWebLine
    ttWValue = '</TD>~n'
             + '</TR>~n'
             .

  CREATE ttWeb.
  ASSIGN
    iWebLine = iWebLine + 1
    ttWLine  = iWebLine
    ttWValue = '<TR>~n'
             + '<TD>~n'
             .

  CREATE ttWeb.
  ASSIGN
    iWebLine = iWebLine + 1
    ttWLine  = iWebLine
    ttWValue = '<TABLE SUMMARY="Dynamics Site Inner" BORDER="0" CELLSPACING="0" CELLPADDING="2" WIDTH="100%">~n'
             + '<TBODY>~n'
             + '<TR>~n'
             + '<TD WIDTH="30%">~n'
             + '&nbsp;<B><U>Login</U></B>~n'
             + '</TD>~n'
             + '<TD WIDTH="70%">~n'
             + '&nbsp;'
             + '</TD>~n'
             + '</TR>~n'
             .

  CREATE ttWeb.
  ASSIGN
    iWebLine = iWebLine + 1
    ttWLine  = iWebLine
    ttWValue = '<TR>~n'
             + '<TD ALIGN="RIGHT">~n'
             + 'Site&nbsp;Code:'
             + '</TD>~n'
             + '<TD>~n'
             + '<INPUT TYPE="text" NAME="wLoginCode" SIZE="20" VALUE="'
             + cLoginCode
             + '">~n'
             + '</TD>~n'
             + '</TR>~n'
             + '<TR>~n'
             + '<TD ALIGN="RIGHT">~n'
             + 'Password:'
             + '</TD>~n'
             + '<TD>~n'
             + '<INPUT TYPE="password" NAME="wLoginPassword" SIZE="20">~n'
             + '</TD>~n'
             + '</TR>~n'
             .

  CREATE ttWeb.
  ASSIGN
    iWebLine = iWebLine + 1
    ttWLine  = iWebLine.
    
  IF lIsIE THEN
    ttWValue = '<TR>~n'
             + '<TD COLSPAN=2 ALIGN="CENTER">~n'
             + '<INPUT TYPE="submit" NAME="wSubmitLogin" SIZE="40" VALUE="'
             + 'Login'
             + '"'
             + (IF cWebIDSite <> "" OR cWebIDUser <> "" THEN " DISABLED " ELSE "")
             + '>~n'
             + '&nbsp;'
             + '<INPUT TYPE="submit" NAME="wSubmitLogin" SIZE="40" VALUE="'
             + 'Logout'
             + '"'
             + (IF (cWebIDSite = "" AND cWebIDUser = "") OR cLoginCode = "" THEN " DISABLED " ELSE "")
             + '>~n'
             + '</TD>~n'
             + '</TR>~n'
             .
  ELSE
  IF (cWebIDSite = "" AND cWebIDUser = "") OR cLoginCode <> "" THEN DO:
    ttWValue = '<TR>~n'
             + '<TD COLSPAN=2 ALIGN="CENTER">~n'    
             .
    IF cWebIDSite = "" AND cWebIDUser = "" THEN
      ttWValue = ttWValue
               + '<INPUT TYPE="submit" NAME="wSubmitLogin" SIZE="40" VALUE="'
               + 'Login'
               + '">~n'
               .
    IF (cWebIDSite <> "" OR cWebIDUser <> "") AND cLoginCode <> "" THEN
      ttWValue = ttWValue
               + '&nbsp;'
               + '<INPUT TYPE="submit" NAME="wSubmitLogin" SIZE="40" VALUE="'
               + 'Logout'
               + '">~n'
               .
    ttWValue = ttWValue
             + '</TD>~n'
             + '</TR>~n'
             .
  END.

  CREATE ttWeb.
  ASSIGN
    iWebLine = iWebLine + 1
    ttWLine  = iWebLine
    ttWValue = '</TBODY>~n'
             + '</TABLE>~n'
             + '</TD>~n'
             + '</TR>~n'
             .

  RUN setFooter.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-displayInformation) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE displayInformation Procedure 
PROCEDURE displayInformation :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  cMessage    AS CHARACTER    NO-UNDO.

  IF cMessage = "" THEN
    ASSIGN
      cMessage = '<FONT COLOR="red" SIZE="5">~n'
               + 'Page Under Construction'
               + '</FONT>~n'
               + '<BR>~n'
               .

  ASSIGN
    cOutTitle   = "Dynamics Information"
    cOutColSpan = "1"
    cOutMessage = cMessage
    .

  RUN setHeader.

  RUN setFooter.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-displayMain) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE displayMain Procedure 
PROCEDURE displayMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  ASSIGN
    cOutTitle   = 'Dynamics Site Number Allocation'
    cOutColSpan = "1"
    cOutMessage = '<P>~n'
                + '<H2 ALIGN="CENTER">Welcome to Dynamics Site Number Allocation</H2>~n'
                + '</P>~n'
                + '<P>~n'
                + '<H4 ALIGN="CENTER">A Free Service For Allocating Site Numbers For Your Dynamics Installation.</H4>~n'
                + '</P>~n'
                + '<P>~n'
                + ' Before installing and configuring Dynamics on your system, you must use this application to:'
                + '</P>~n'
                + '<P>~n'
                + ' 1.  Register your Dynamics site with a unique site code (that you define).'
                + ' A site code uniquely identifies a Dynamics site.'
                + ' This could be your company or organization code, or if you are an individual, your name.'
                + '</P>~n'
                + '<P>~n'
                + ' 2.  Register each Dynamics repository at your site with a unique site identification number.'
                + ' A site identification number uniquely identifies a Dynamics repository.'
                + ' More importantly, it ensures the integrity of Dynamics repository data among Dynamics sites and applications,'
                + ' worldwide, as well as between versions of Dynamics.'
                + '</P>~n'
                + '<P>~n'
                + '<B><U>Caution:</U></B> If you do not register a unique site number for each individual Dynamics repository at your site,'
                + ' deploying object data you created in that repository could cause that data to become lost or corrupted.'
                + '</P>~n'
                + '<P>~n'
                + ' If you plan to develop objects for submission to the Progress Open Source Software exchange (POSSE),'
                + ' you must register your Dynamics development repository.'
                + ' Any submissions of objects created in a repository that has not been registered with a unique site number will not be accepted.'
                + '</P>~n'
                + '<P>~n'
                + ' For more information about using this application, click the "Help About" link on the application menu.'
                + '</P>~n'
                + '<P>~n'
                + '<LI>Have you registered your sites ? '
                + '<LI>Do you have a site number ? '
                + '</P>~n'
                + '<P>~n'
                + '<BR>Progress Dynamics is a trademark of Progress Software Corporation in the US and other countries.'
                + '</P>~n'
                .

  RUN setHeader.

  RUN setFooter.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-outputHeader) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE outputHeader Procedure 
PROCEDURE outputHeader :
/*------------------------------------------------------------------------------
  Purpose:     Output the MIME header, and any "cookie" information needed 
               by this procedure.  
  Parameters:  <none>
  Notes:       In the event that this Web object is state-aware, this is
               a good place to set the webState and webTimeout attributes.
------------------------------------------------------------------------------*/

  output-content-type ("text/html":U).
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processWebRequest) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE processWebRequest Procedure 
PROCEDURE processWebRequest :
/*------------------------------------------------------------------------------
  Purpose:     Process the web request.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  EMPTY TEMP-TABLE ttWeb.
  
  ASSIGN
    iWebLine = 0.

  CASE cWebRun:
    WHEN "runFrames"              THEN RUN displayFrames.
    WHEN "runIndex"               THEN RUN displayIndex.
    WHEN "runMain"                THEN RUN displayMain.
    WHEN "runHelp"                THEN RUN displayHelp.
    WHEN "runSiteNumberQueryNum"  THEN RUN siteNumberQueryNum.
    WHEN "runSiteNumberQuerySite" THEN RUN siteNumberQuerySite.
    WHEN "runSiteNumberControl"   THEN RUN siteNumberControl.
    WHEN "runSiteNumberReAssign"  THEN RUN siteNumberReAssign.
    WHEN "runSiteMasterQuery"     THEN RUN siteMasterQuery.
    WHEN "runSiteMasterControl"   THEN RUN siteMasterControl.
    WHEN "runSiteUserQuery"       THEN RUN siteUserQuery.
    WHEN "runSiteUserControl"     THEN RUN siteUserControl.
    OTHERWISE DO:                      RUN displayInformation (INPUT "").
    END.
  END CASE.

  RUN outputHeader.

  FOR EACH ttWeb NO-LOCK BY ttWLine:
    {&OUT} ttWValue SKIP.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFooter) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setFooter Procedure 
PROCEDURE setFooter :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  IF cOutMessage <> ""
  THEN DO:
    CREATE ttWeb.
    ASSIGN
      iWebLine = iWebLine + 1
      ttWLine  = iWebLine
      ttWValue = '<TR>~n'
               + '<TD COLSPAN='
               + cOutColSpan
               + ' >~n'
               + '<BR>~n'
               + cOutMessage
               + '<BR>~n'
               + '</TD>~n'
               + '</TR>~n'
               .
  END.

  CREATE ttWeb.
  ASSIGN
    iWebLine = iWebLine + 1
    ttWLine  = iWebLine
    ttWValue = '</TBODY>~n'
             + '</TABLE>~n'
             + '</FORM>~n'
             + '</BODY>~n'
             + '</HTML>~n'
             .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setHeader) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setHeader Procedure 
PROCEDURE setHeader :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE iLoop AS INTEGER NO-UNDO.

  IF cOutCaption = "" AND cOutTitle <> "" THEN
    ASSIGN
      cOutCaption = cOutTitle.

  IF  cOutTitle   = "" AND cOutCaption <> "" THEN
    ASSIGN
      cOutTitle = cOutCaption.

  CREATE ttWeb.
  ASSIGN
    iWebLine = iWebLine + 1
    ttWLine  = iWebLine
    ttWValue = '<HTML>~n'
             + '<HEAD>~n'
             + '<TITLE>~n'
             + cOutTitle
             + '</TITLE>~n'
             + (IF cOutMeta <> "" THEN cOutMeta ELSE '')
             + '</HEAD>~n'
             .

  CREATE ttWeb.
  ASSIGN
    iWebLine = iWebLine + 1
    ttWLine  = iWebLine
    ttWValue = '<BODY COLOR="000000" BGCOLOR="C0C0C0" TEXT="000000";'
             + (IF cOutBody <> "" THEN cOutBody ELSE '')
             + '>~n'
             .

  CREATE ttWeb.
  ASSIGN
    iWebLine = iWebLine + 1
    ttWLine  = iWebLine
    ttWValue = '<FORM METHOD="post" ACTION="icfsite.w">~n'
             + '<INPUT TYPE="hidden" NAME="wIDUser" VALUE="' + cWebIDUser + '">~n'
             + '<INPUT TYPE="hidden" NAME="wIDSite" VALUE="' + cWebIDSite + '">~n'
             + '<INPUT TYPE="hidden" NAME="wRun"    VALUE="' + cWebRun    + '">~n'
             + '<INPUT TYPE="hidden" NAME="wAction" VALUE="' + cWebAction + '">~n'
             + '<INPUT TYPE="hidden" NAME="wFirst"  VALUE="' + cWebFirst  + '">~n'
             + '<INPUT TYPE="hidden" NAME="wLast"   VALUE="' + cWebLAst   + '">~n'
             + '<TABLE BORDER="1" CELLSPACING="0" CELLPADDING="2" WIDTH="100%">~n'
             + '<THEAD>~n'
             .

  IF cOutCaption <> "" THEN DO:
    CREATE ttWeb.
    ASSIGN
      iWebLine = iWebLine + 1
      ttWLine  = iWebLine
      ttWValue = '<TR>~n'
               + '<TH COLSPAN='
               + cOutColSpan
               + ' BGCOLOR="000080">~n'
               + '<FONT COLOR="FFFFFF" SIZE="5">~n'
               + cOutCaption
               + '</FONT>~n'
               + '</TH>~n'
               + '</TR>~n'
               .
  END.

  IF cOutSubCaption <> "" THEN DO:
    CREATE ttWeb.
    ASSIGN
      iWebLine = iWebLine + 1
      ttWLine  = iWebLine
      ttWValue = '<TR>~n'
               + '<TH COLSPAN='
               + cOutColSpan
               + ' >~n'
               + '<FONT SIZE=3>~n'
               + cOutSubCaption
               + '</FONT>~n'
               + '</TH>~n'
               + '</TR>~n'
               .
  END.

  IF cOutSearch <> "" THEN DO:
    CREATE ttWeb.
    ASSIGN
      iWebLine = iWebLine + 1
      ttWLine  = iWebLine
      ttWValue = '<TR>~n'
               + '<TH COLSPAN='
               + cOutColSpan
               + '>~n'
               + cOutSearch
               + '&nbsp;&nbsp;'
               + '<INPUT NAME="wSearch" VALUE="'
               + cWebSearch
               + '" SIZE="30">~n'
               + '&nbsp;'
               + '<INPUT TYPE="submit" NAME="wbSearch" VALUE="Find/Filter">~n'
               + '&nbsp;&nbsp;'
               .
               
    ASSIGN
      ttWValue = ttWValue
               + (IF lIsIE OR (NOT lIsIE AND lOutPrev) THEN
                  '<INPUT TYPE="submit" NAME="wNavigation" VALUE="Prev"' +
                  (IF NOT lOutPrev THEN ' DISABLED ' ELSE '') + '>~n' 
                  ELSE '')
               + (IF lIsIE OR (NOT lIsIE AND lOutNext) THEN
                  '&nbsp;' +
                  '<INPUT TYPE="submit" NAME="wNavigation" VALUE="Next"' +
                  (IF NOT lOutNext THEN ' DISABLED ' ELSE '') + '>~n'
                  ELSE '')
               + '&nbsp;'
               .
    
    ASSIGN
      ttWValue = ttWValue + '</TH>~n' + '</TR>~n'.
  END.

  IF cOutColumns <> ""
    AND NUM-ENTRIES(cOutColumns) = INTEGER(cOutColSpan) THEN DO:
    CREATE ttWeb.
    ASSIGN
      iWebLine = iWebLine + 1
      ttWLine  = iWebLine
      ttWValue = ttWValue + '<TR>~n'.

    DO iLoop = 1 TO NUM-ENTRIES(cOutColumns):
      ASSIGN
        ttWValue = ttWValue
                 + '<TH>~n'
                 + ENTRY(iLoop,cOutColumns)
                 + '</TH>~n'.
    END.

    ASSIGN
      ttWValue = ttWValue + '</TR>~n'.

  END.

  CREATE ttWeb.
  ASSIGN
    iWebLine = iWebLine + 1
    ttWLine  = iWebLine
    ttWValue = '</THEAD>~n' + '<TBODY>~n'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-siteMasterControl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE siteMasterControl Procedure 
PROCEDURE siteMasterControl :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       For superusers
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cMessage         AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cSiteCode        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSiteEmail       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSitePassword    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSitePassword2   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSiteDescription AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSiteReference   AS CHARACTER  NO-UNDO.

  ASSIGN
    cMessage           = ""
    cSiteCode          = get-value("wSiteCode":U)
    cSiteEmail         = get-value("wSiteEmail":U)
    cSitePassword      = get-value("wSitePassword":U)
    cSitePassword2     = get-value("wSitePassword2":U)
    cSiteDescription   = get-value("wSiteDescription":U)
    cSiteReference     = get-value("wSiteReference":U)
    .

  blk_Site:
  DO WITH TRANSACTION:
    IF cSiteSubmit = "" THEN DO:
      ASSIGN
        cMessage = '<LI>'
                 + SUBSTITUTE('Enter your site information and press the &1 button.',
                              (IF cWebAction = 'actionNewSite' THEN 'Register' ELSE 'Update'))
                 + '<LI>Required fields are marked with a red asterisk (<FONT COLOR="red">*</FONT>).'
                 + '<BR>~n'.
      LEAVE blk_Site.
    END.

    IF cWebAction = "actionModifySite" THEN DO:
      ASSIGN
        cWebIDSite = "".

      IF cSiteCode <> "" THEN
        FIND FIRST rsm_site NO-LOCK
          WHERE rsm_site.site_code = cSiteCode
          AND (IF cWebIDUser = "" THEN rsm_site.site_password = ENCODE(cSitePassword) ELSE TRUE)
          NO-ERROR.
      ELSE 
      IF cSiteEmail <> "" THEN
        FIND FIRST rsm_site NO-LOCK
          WHERE rsm_site.site_email = cSiteEmail
          AND (IF cWebIDUser = "" THEN rsm_site.site_password = ENCODE(cSitePassword) ELSE TRUE)
          NO-ERROR.
      IF AVAILABLE rsm_site THEN
        ASSIGN cWebIDSite = rsm_site.site_code.

      IF cWebIDSite = "" THEN DO:
        ASSIGN
          cMessage = '<FONT COLOR="red">~n'
                   + 'One or more required fields are blank. Please correct and try again.'
                   + '</FONT>~n'
                   + '<BR>~n'.
        LEAVE blk_Site.
      END.
      ELSE
        ASSIGN
          cWebAction       = "actionUpdateSite"
          cSiteCode        = rsm_site.site_code
          cSiteEmail       = rsm_site.site_email
          cSiteDescription = rsm_site.site_description
          cSiteReference   = rsm_site.external_reference
          cMessage         = '<LI>Update site information and press the Update button.'
                           + '<LI>Required fields are marked with a red asterisk (<FONT COLOR="red">*</FONT>).'
          .
    END.
    ELSE
    IF cWebAction = "actionUpdateSite" THEN DO:
      IF  (cSitePassword <> "" OR cSitePassword2 <> "")
        AND (cSitePassword <> cSitePassword2
        OR ENCODE(cSitePassword) <> ENCODE(cSitePassword2)) THEN DO:
        ASSIGN
          cMessage = cMessage
                   + '<FONT COLOR="red">~n'
                   + 'The passwords entered do not match.  Please correct and try again.'
                   + '<BR>~n'
                   + cSitePassword
                   + '<BR>~n'
                   + cSitePassword2
                   + '<BR>~n'
                   + '</FONT>~n'
                   + '<BR>~n'.
        LEAVE blk_Site.
      END.

      IF cWebIDSite = "" THEN DO:
        ASSIGN
          cMessage = '<FONT COLOR="red">~n'
                   + 'The site information entered is invalid.  Please re-login and try again.'
                   + '</FONT>~n'
                   + '<BR>~n'.
        LEAVE blk_Site.
      END.

      IF NOT CAN-FIND(FIRST rsm_site WHERE rsm_site.site_code = cWebIDSite) THEN DO:
        ASSIGN
          cMessage = '<FONT COLOR="red">~n'
                   + 'The site information entered is invalid.  Please correct and try again.'
                   + '</FONT>~n'
                   + '<BR>~n'.
        LEAVE blk_Site.
      END.

      FIND rsm_site EXCLUSIVE-LOCK
        WHERE rsm_site.site_code = cWebIDSite NO-ERROR.
      ASSIGN
        rsm_site.site_email         = cSiteEmail
        rsm_site.site_password      = (IF cSitePassword <> "" AND cSitePassword2 <> "" 
                                       THEN ENCODE(cSitePassword) ELSE rsm_site.site_password)
        rsm_site.site_description   = cSiteDescription
        rsm_site.external_reference = cSiteReference
        NO-ERROR.
      IF ERROR-STATUS:ERROR THEN DO:
        ASSIGN
          cMessage = '<FONT COLOR="red">~n'
                   + 'Error updating site with site code &quot;' + cSiteCode + '&quot;.'
                   + '<BR>~n'
                   + ERROR-STATUS:GET-MESSAGE(1)
                   + '</FONT>~n'
                   + '<BR>~n'.
      END.
      ELSE
        ASSIGN
          cSiteCode        = rsm_site.site_code
          cSiteEmail       = rsm_site.site_email
          cSiteDescription = rsm_site.site_description
          cSiteReference   = rsm_site.external_reference
          cMessage         = '<FONT COLOR="green">~n'
                           + 'Site updated succesfully.'
                           + '</FONT>~n'
                           + '<BR>~n'.

      LEAVE blk_Site.
    END.

    /* cWebAction = "actionNewSite" */
    ELSE DO:
      IF cSiteSubmit <> "" AND
        (cSiteCode = "" OR cSitePassword = "") THEN DO:
        ASSIGN
          cMessage = cMessage
                   + '<FONT COLOR="red">~n'
                   + 'One or more required fields are blank. Please correct and try again.'
                   + '</FONT>~n'
                   + '<BR>~n'.
        LEAVE blk_Site.
      END.

      IF        cSitePassword  <>        cSitePassword2
      OR ENCODE(cSitePassword) <> ENCODE(cSitePassword2) THEN DO:
        ASSIGN
          cMessage = cMessage
                   + '<FONT COLOR="red">~n'
                   + 'The passwords entered do not match.  Please correct and try again.'
                   + '</FONT>~n'
                   + '<BR>~n'.
        LEAVE blk_Site.
      END.

      FIND FIRST rsm_site NO-LOCK
        WHERE rsm_site.site_code = cSiteCode NO-ERROR.
      IF AVAILABLE rsm_site THEN DO:
        ASSIGN
          cMessage = '<FONT COLOR="red">~n'
                   + 'Site Code &quot;' + cSiteCode + '&quot; already exists.  Please enter a new Site Code and try again.'
                   + '</FONT>~n'
                   + '<BR>~n'.
        LEAVE blk_Site.
      END.
      ELSE DO:
        CREATE rsm_site.
        ASSIGN
          rsm_site.site_code          = cSiteCode
          rsm_site.site_email         = cSiteEmail
          rsm_site.site_password      = ENCODE(cSitePassword)
          rsm_site.site_description   = cSiteDescription
          rsm_site.external_reference = cSiteReference
          rsm_site.create_date        = TODAY
          NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
          ASSIGN
            cMessage = '<FONT COLOR="red">~n'
                     + 'Error creating site with Site Code &quot;' + cSiteCode + '&quot;.'
                     + '<BR>~n'
                     + ERROR-STATUS:GET-MESSAGE(1)
                     + '</FONT>~n'
                     + '<BR>~n'.
        END.
        ELSE
          ASSIGN
            cWebIDSite = cSiteCode
            cMessage   = '<FONT COLOR="green">~n'
                       + 'Site created succesfully.'
                       + '</FONT>~n'
                       + '<BR>~n'.
        LEAVE blk_Site.
      END.
    END.
  END. /* blk_Site */

  ASSIGN
    cOutTitle   = "Dynamics Site Control"
    cOutColSpan = "2"
    cOutMessage = cMessage
    .

  CASE cWebAction:
    WHEN "actionNewSite"    THEN cOutSubCaption = "Register Site".
    WHEN "actionModifySite" THEN cOutSubCaption = "Update Site".
    WHEN "actionUpdateSite" THEN cOutSubCaption = "Update Site".
    OTHERWISE                    cOutSubCaption = "Site Control".
  END CASE.

  RUN setHeader.

  CREATE ttWeb.
  ASSIGN
    iWebLine = iWebLine + 1
    ttWLine  = iWebLine
    ttWValue = '<TR>~n'
             + '<TD>~n'
             .

  CREATE ttWeb.
  ASSIGN
    iWebLine = iWebLine + 1
    ttWLine  = iWebLine
    ttWValue = '<TABLE SUMMARY="Dynamics Site Inner" BORDER="0" CELLSPACING="0" CELLPADDING="2" WIDTH="100%">~n'
             + '<TBODY>~n'
             + '<TR>~n'
             + '<TD WIDTH="30%">~n'
             + '&nbsp;'
             + '</TD>~n'
             + '<TD WIDTH="70%">~n'
             + '&nbsp;'
             + '</TD>~n'
             + '</TR>~n'
             .

  CREATE ttWeb.
  ASSIGN
    iWebLine = iWebLine + 1
    ttWLine  = iWebLine
    ttWValue = '<TR>~n'
             + '<TD ALIGN="RIGHT">~n'
             + (IF cWebAction = "actionModifySite" THEN 'Site Code:'
             	  ELSE 'Site Code<FONT COLOR="red">*</FONT>:')
             + '</TD>~n'
             + '<TD>~n'
             + '<INPUT TYPE="text" NAME="wSiteCode" SIZE="30" VALUE="' 
             + cSiteCode 
             + '"'
             + (IF cWebAction = "actionUpdateSite" THEN 'DISABLED' ELSE '')
             + '>~n'
             + '</TD>~n'
             + '</TR>~n'
             .

  CREATE ttWeb.
  ASSIGN
    iWebLine = iWebLine + 1
    ttWLine  = iWebLine
    ttWValue = '<TR>~n'
             + '<TD ALIGN="RIGHT">~n'
             + 'E-mail address:'
             + '</TD>~n'
             + '<TD>~n'
             + '<INPUT TYPE="text" NAME="wSiteEmail" SIZE="30" VALUE="'
             + cSiteEmail
             + '">~n'
             + '</TD>~n'
             + '</TR>~n'
             .

  IF (cWebAction = "actionModifySite" AND cWebIDUser = "") 
    OR cWebAction <> "actionModifySite" THEN DO: /*dma*/
    CREATE ttWeb.
    ASSIGN
      iWebLine = iWebLine + 1
      ttWLine  = iWebLine
      ttWValue = '<TR>~n'
               + '<TD ALIGN="RIGHT">~n'
               + (IF cWebAction = "actionModifySite" THEN 'Password<FONT COLOR="red">*</FONT>:' 
                  ELSE 'New Password<FONT COLOR="red">*</FONT>:')
               + '</TD>~n'
               + '<TD>~n'
               + '<INPUT TYPE="password" NAME="wSitePassword" SIZE="30">~n'
               + '</TD>~n'
               + '</TR>~n'
               .
  END.

  IF cWebAction = "actionNewSite" OR cWebAction = "actionUpdateSite" THEN DO:
    CREATE ttWeb.
    ASSIGN
      iWebLine = iWebLine + 1
      ttWLine  = iWebLine
      ttWValue = '<TR>~n'
               + '<TR>~n'
               + '<TD ALIGN="RIGHT">~n'
               + 'Confirm Password<FONT COLOR="red">*</FONT>:'
               + '</TD>~n'
               + '<TD>~n'
               + '<INPUT TYPE="password" NAME="wSitePassword2" SIZE="30">~n'
               + '</TD>~n'
               + '</TR>~n'
               .

    CREATE ttWeb.
    ASSIGN
      iWebLine = iWebLine + 1
      ttWLine  = iWebLine
      ttWValue = '<TR>~n'
               + '<TD ALIGN="RIGHT">~n'
               + 'Description:'
               + '</TD>~n'
               + '<TD>~n'
               + '<TEXTAREA ROWS="5" COLS="30" NAME="wSiteDescription">~n'
               + cSiteDescription
               + '</TEXTAREA>~n'
               + '</TD>~n'
               + '</TR>~n'
               .
  END.

  CREATE ttWeb.
  ASSIGN
    iWebLine = iWebLine + 1
    ttWLine  = iWebLine
    ttWValue = '<TR>~n'
             + '<TD COLSPAN=2 ALIGN="CENTER">~n'
             + '<BR>~n'
             + '<INPUT TYPE="submit" NAME="wSiteSubmit" VALUE="'
             + (IF cWebAction = "actionNewSite"    THEN 'Register' ELSE
                IF cWebAction = "actionModifySite" THEN 'Update'   ELSE
                IF cWebAction = "actionUpdateSite" THEN 'Update'   ELSE 'Register')
             + '">~n'
             + '</TD>~n'
             + '</TR>~n'
             + '<TR>~n'
             + '<TD COLSPAN=2>&nbsp;</TD>~n'
             + '</TR>~n'
             .

  CREATE ttWeb.
  ASSIGN
    iWebLine = iWebLine + 1
    ttWLine  = iWebLine
    ttWValue = '</TBODY>~n'
             + '</TABLE>~n'
             + '</TD>~n'
             + '</TR>~n'
             .

  RUN setFooter.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-siteMasterQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE siteMasterQuery Procedure 
PROCEDURE siteMasterQuery :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cDesc         AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cCountSite    AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cSiteHtml     AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cSiteUrl      AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE iCountSite    AS INTEGER     NO-UNDO.
  DEFINE VARIABLE iCountChild   AS INTEGER     NO-UNDO.

  IF NOT TRANSACTION THEN EMPTY TEMP-TABLE tt_site. ELSE FOR EACH tt_site: DELETE tt_site. END.

  loop_Blk:
  DO iBrowseLoop = 1 TO iBrowseRows:
    IF iBrowseLoop = 1 THEN DO:
      IF cWebNavigation = "PREV":U AND cWebFirst <> "" THEN
        FIND FIRST rsm_site NO-LOCK
          WHERE rsm_site.site_code = cWebFirst NO-ERROR.
      ELSE
      IF cWebNavigation = "NEXT":U AND cWebLast <> "" THEN
        FIND FIRST rsm_site NO-LOCK
          WHERE rsm_site.site_code = cWebLast NO-ERROR.
      ELSE
      IF cWebSearch <> "" THEN
        FIND FIRST rsm_site NO-LOCK
          WHERE rsm_site.site_code BEGINS cWebSearch NO-ERROR.
      ELSE
        FIND FIRST rsm_site NO-LOCK NO-ERROR.
    END.
    ELSE DO:
      IF cWebNavigation = "PREV":U THEN 
        FIND PREV rsm_site NO-LOCK NO-ERROR.
      ELSE
        FIND NEXT rsm_site NO-LOCK NO-ERROR.
    END.

    IF AVAILABLE rsm_site THEN DO:
      CREATE tt_site.
      BUFFER-COPY rsm_site TO tt_site.
    END.
    ELSE
      LEAVE loop_Blk.
  END.

  ASSIGN
    cOutTitle   = "Dynamics Site List"
    cOutColSpan = "4":U
    cOutSearch  = "Site Code:"
    cOutColumns = "Site Code,Site Description,Site Numbers,Created"
    .

  FIND FIRST tt_site NO-ERROR.
  IF AVAILABLE tt_site THEN
    ASSIGN cWebFirst = STRING(tt_site.site_code).
  FIND FIRST rsm_site NO-LOCK
    WHERE rsm_site.site_code = tt_site.site_code NO-ERROR.
  FIND PREV rsm_site NO-LOCK NO-ERROR.
  IF AVAILABLE rsm_site THEN
    ASSIGN lOutPrev = YES.

  FIND LAST tt_site NO-ERROR.
  IF AVAILABLE tt_site THEN
    ASSIGN cWebLast = STRING(tt_site.site_code).
  FIND FIRST rsm_site NO-LOCK
    WHERE rsm_site.site_code = tt_site.site_code NO-ERROR.
  FIND NEXT rsm_site NO-LOCK NO-ERROR.
  IF AVAILABLE rsm_site THEN
    ASSIGN lOutNext = YES.

  RUN setHeader.

  FOR EACH tt_site
    BY tt_site.site_code:

    ASSIGN
      cCountSite  = ""
      iCountSite  = 0
      iCountChild = 0.

    FOR EACH rsm_site_number NO-LOCK
      WHERE rsm_site_number.owning_site_code = tt_site.site_code:
      ASSIGN
        iCountSite = iCountSite + 1.
    END.

    FOR EACH rsm_site_number NO-LOCK
      WHERE rsm_site_number.allocated_site_code = tt_site.site_code:
      ASSIGN
        iCountChild = iCountChild + 1.
    END.

    ASSIGN
      cCountSite = STRING(iCountSite,">>>>>>>>>9":U) + " (":U 
                 + STRING(iCountChild,">>>>>>>>>9":U) + ")":U
                 .

    CREATE ttWeb.
    ASSIGN
      cDesc     = html-encode(tt_site.site_description)
      cSiteHtml = html-encode(tt_site.site_code)
      cSiteUrl  = url-encode(tt_site.site_code,"query":U) 
      iWebLine  = iWebLine + 1
      ttWLine   = iWebLine
      ttWValue  = '<TR>~n'
                + '<TD>~n'
                + '<A HREF="' + cWebPath 
                + 'icfsite.w?wEXU=' + cEXWebIDUser 
                  + '&wEXS=' + cEXWebIDSite 
                  + '&wEXD=' + cEXWebIDDate 
                  + '&wRun=runSiteNumberQuerySite'
                  + '&wSearch=' + cSiteUrl + '">' + cSiteHtml
                + '</A>'
                + '</TD>~n'
                + '<TD>~n'
                + (IF tt_site.site_description = "" THEN '&nbsp;' ELSE cDesc)
                + '</TD>~n'
                + '<TD ALIGN="RIGHT">~n'
                + cCountSite
                + '</TD>~n'
                + '<TD>~n'
                + STRING(tt_site.create_date,"99/99/9999":U)
                + '</TD>~n'
                + '</TR>~n'
                .
  END.

  RUN setFooter.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-siteNumberControl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE siteNumberControl Procedure 
PROCEDURE siteNumberControl :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cMessage              AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cNumberOwningSite     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNumberAllocatedSite  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNumberValue          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNumberCount          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNumberOverride       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNumberUserCode       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNumberUserPassword   AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE iNumberValue          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iNumberCount          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iNumberCurrent        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iNumberCreate         AS INTEGER    NO-UNDO.

  DEFINE VARIABLE iNumberAllocated      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iNumberMaximum        AS INTEGER    NO-UNDO.

  DEFINE VARIABLE lNumberAuto           AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iNumberErrors         AS INTEGER    NO-UNDO.

  DEFINE VARIABLE iNumberLoop           AS INTEGER    NO-UNDO.

  ASSIGN
    lNumberAuto           = YES
    iNumberErrors         = 0
    cMessage              = ""
    iNumberValue          = 0
    iNumberCount          = 0
    iNumberCurrent        = 0
    iNumberCreate         = 0
    iNumberAllocated      = 0
    iNumberMaximum        = 100
    iNumberLoop           = 0
    cNumberOwningSite     = get-value("wNumberOwningSite":U)
    cNumberAllocatedSite  = get-value("wNumberAllocatedSite":U)
    cNumberValue          = get-value("wNumberValue":U)
    cNumberCount          = get-value("wNumberCount":U)
    cNumberOverride       = get-value("wNumberOverride":U)
    cNumberUserCode       = get-value("wNumberUserCode":U)
    cNumberUserPassword   = get-value("wNumberUserPassword":U)
    .

  FIND FIRST rsm_control NO-LOCK NO-ERROR.
  iNumberCurrent = IF AVAILABLE rsm_control THEN rsm_control.last_number ELSE 1.
  
  blk_SiteNumber:
  DO TRANSACTION:
    IF cSiteSubmit <> "" AND cNumberOwningSite = "" THEN DO:
      ASSIGN
        cMessage = cMessage
                 + '<FONT COLOR="red">~n'
                 + 'One or more required fields are blank. Please correct and try again.'
                 + '</FONT>~n'
                 + '<BR>~n'.
      LEAVE blk_SiteNumber.
    END.

    IF (cNumberValue      = "" AND cNumberCount         = "")
    OR (cNumberOwningSite = "" AND cNumberAllocatedSite = "")
    THEN DO:
      ASSIGN
        cMessage = cMessage
                 + '<LI>Enter your site information and site requirements.'
                 + '<LI>Required fields are marked with a red asterisk (<FONT COLOR="red">*</FONT>).'
                 + '<LI>The Owning Site Code is your actual user or system to which the Site Number is being allocated.'
                 + '<LI>The Allocated Site Code is the company, group or organization code, if applicable.'
                 .
      LEAVE blk_SiteNumber.
    END.

    IF cNumberOwningSite <> "" THEN DO:
      FIND FIRST rsm_site NO-LOCK
        WHERE rsm_site.site_code = cNumberOwningSite NO-ERROR.
      IF NOT AVAILABLE rsm_site THEN DO:
        ASSIGN
          cMessage = cMessage
                   + '<FONT COLOR="red">~n'
                   + 'The owning site information entered is invalid.  Please correct and try again.'
                   + '</FONT>~n'
                   + '<BR>~n'.
        LEAVE blk_SiteNumber.
      END.

      FOR EACH rsm_site NO-LOCK
        WHERE rsm_site.site_code = cNumberOwningSite,
        EACH rsm_site_number NO-LOCK
        WHERE rsm_site_number.owning_site_code = rsm_site.site_code:
        ASSIGN iNumberAllocated = iNumberAllocated + 1.
      END.
    END.

    IF cNumberAllocatedSite <> "" THEN DO:
      FIND FIRST rsm_site NO-LOCK
        WHERE rsm_site.site_code = cNumberAllocatedSite NO-ERROR.
      IF NOT AVAILABLE rsm_site THEN DO:
        ASSIGN
          cMessage = cMessage
                   + '<FONT COLOR="red">~n'
                   + 'The allocated site information entered is invalid.  Please correct and try again.'
                   + '</FONT>~n'
                   + '<BR>~n'.
        LEAVE blk_SiteNumber.
      END.
    END.

    IF cNumberOverride = "YES" AND cNumberUserCode <> "" THEN DO:
      FIND FIRST rsm_user NO-LOCK
        WHERE rsm_user.user_code     = cNumberUserCode
        AND   rsm_user.user_password = ENCODE(cNumberUserPassword) NO-ERROR.
      IF AVAILABLE rsm_user THEN DO:
        IF rsm_user.maintain_system_data = YES
          AND rsm_user.maximum_authorize > iNumberMaximum THEN
          ASSIGN
            iNumberMaximum = rsm_user.maximum_authorize.
      END.
      ELSE DO:
        ASSIGN
          cMessage = '<FONT COLOR="red">~n'
                   + 'The authorized user information entered is invalid.  Please correct and try again.'
                   + '</FONT>~n'
                   + '<BR>~n'.
        LEAVE blk_SiteNumber.
      END.

    END.

    IF iNumberAllocated >= iNumberMaximum THEN DO:
      ASSIGN
        cMessage = cMessage
                 + '<FONT COLOR="red">~n'
                 + 'Maximum allocated numbers reached.  Please get authorization to allocate additional site numbers.'
                 + '</FONT>~n'
                 + '<BR>~n'.
      LEAVE blk_SiteNumber.
    END.

    ASSIGN iNumberValue = INTEGER(cNumberValue) NO-ERROR.
    ASSIGN iNumberCount = INTEGER(cNumberCount) NO-ERROR.

    IF iNumberValue > 0 THEN DO:
      FIND FIRST rsm_site_number NO-LOCK
        WHERE rsm_site_number.site_number = iNumberValue NO-ERROR.
      IF AVAILABLE rsm_site_number
        AND rsm_site_number.owning_site_code <> "" THEN DO:
        ASSIGN
          iNumberErrors = iNumberErrors + 1
          cMessage = cMessage
                   + '<FONT COLOR="red">~n'
                   + 'Site Number &quot;' + STRING(iNumberValue) + '&quot; is already allocated.  Please enter a new Site Number and try again.'
                   + '</FONT>~n'
                   + '<BR><BR>Auto-generated number(s) are also available by entering the number of site numbers required.'
                   + '<BR>~n'.
        LEAVE blk_SiteNumber.
      END.
      ELSE DO:
        CREATE rsm_site_number.
        ASSIGN
          rsm_site_number.site_number         = iNumberValue
          rsm_site_number.owning_site_code    = cNumberOwningSite
          rsm_site_number.allocated_site_code = cNumberAllocatedSite
          NO-ERROR.
        IF ERROR-STATUS:ERROR THEN
          ASSIGN
            cMessage = cMessage
                     + '<FONT COLOR="red">~n'
                     + 'Error creating site with Site Number &quot;' + STRING(iNumberValue) + '&quot;.'
                     + '<BR><BR>~n'
                     + ERROR-STATUS:GET-MESSAGE(1)
                     + '</FONT>~n'
                     + '<BR>~n'.
        ELSE
          ASSIGN
            iNumberCreate     = 1
            iNumberAllocated  = iNumberAllocated + 1
            iNumberCurrent    = rsm_site_number.site_number
            lNumberAuto       = NO.
      END.
    END.

    IF iNumberCount > 0
      /* AND iNumberCount > iNumberCreate */ THEN DO:
      blk_transaction:
      REPEAT:
        IF iNumberCount = iNumberCreate THEN
          LEAVE blk_transaction.

        IF iNumberAllocated >= iNumberMaximum THEN DO:
          ASSIGN
            cMessage = cMessage
                     + '<FONT COLOR="red">~n'
                     + 'Maximum allocated numbers reached.  Please get authorization to allocate additional site numbers.'
                     + '</FONT>~n'
                     + '<BR>~n'.
          LEAVE blk_transaction.
        END.

        FIND FIRST rsm_site_number NO-LOCK
          WHERE rsm_site_number.site_number = iNumberCurrent NO-ERROR.
        IF NOT AVAILABLE rsm_site_number THEN DO:
          CREATE rsm_site_number NO-ERROR.
          ASSIGN
            rsm_site_number.site_number          = iNumberCurrent
            rsm_site_number.owning_site_code     = cNumberOwningSite
            rsm_site_number.allocated_site_code  = cNumberAllocatedSite
            NO-ERROR.
          IF ERROR-STATUS:ERROR THEN DO:
            ASSIGN
              cMessage = cMessage
                       + '<FONT COLOR="red">~n'
                       + 'Error creating site with Site Number &quot;'
                       + STRING(iNumberCurrent)
                       + ' / '
                       + STRING(rsm_site_number.site_number)
                       + '&quot;.'
                       + '<BR>~n'
                       + ERROR-STATUS:GET-MESSAGE(1)
                       + '</FONT>~n'
                       + '<BR>~n'.

            LEAVE blk_transaction.

          END.
          ELSE
            ASSIGN
              iNumberCreate    = iNumberCreate    + 1
              iNumberAllocated = iNumberAllocated + 1
              .
        END.

        ASSIGN
          iNumberCurrent = iNumberCurrent + 1.
      END.
    END.
    ELSE DO:
      ASSIGN
        cMessage = cMessage
                 + '<FONT COLOR="red">~n'
                 + 'The information entered is invalid.  Please correct and try again.'
                 + '</FONT>~n'
                 + '<BR>~n'.
      LEAVE blk_SiteNumber.
    END.
  END.

  IF iNumberCreate > 0 THEN DO:
    ASSIGN
      cMessage    = cMessage
                  + '<FONT COLOR="green">~n'
                  + 'Site number(s) created succesfully.'
                  + '</FONT>~n'
                  + '<BR>~n'.

    IF lNumberAuto
      AND iNumberCurrent <> 1 THEN DO:
      FIND FIRST rsm_control EXCLUSIVE-LOCK NO-ERROR.
      IF AVAILABLE rsm_control AND rsm_control.last_number <> iNumberCurrent THEN
        ASSIGN 
          rsm_control.last_number = iNumberCurrent.
    END.
  END.

  ASSIGN
    cOutTitle       = "Dynamics Site Control"
    cOutCaption     = "Dynamics Site Control"
    cOutSubCaption  = "Register Site Numbers"
    cOutColSpan     = "2"
    cOutMessage     = cMessage
    .

  RUN setHeader.

  CREATE ttWeb.
  ASSIGN
    iWebLine = iWebLine + 1
    ttWLine  = iWebLine
    ttWValue = '<TR>~n'
             + '<TD COLSPAN="2">~n'
             .

  CREATE ttWeb.
  ASSIGN
    iWebLine = iWebLine + 1
    ttWLine  = iWebLine
    ttWValue = '<TABLE SUMMARY="Dynamics Site Inner" BORDER="0" CELLSPACING="0" CELLPADDING="2" WIDTH="100%">~n'
             + '<TBODY>~n'
             + '<TR>~n'
             + '<TD WIDTH="30%">~n'
             + '&nbsp;'
             + '</TD>~n'
             + '<TD WIDTH="70%">~n'
             + '&nbsp;'
             + '</TD>~n'
             + '</TR>~n'
             .

  CREATE ttWeb.
  ASSIGN
    iWebLine = iWebLine + 1
    ttWLine  = iWebLine
    ttWValue = '<TR>~n'
             + '<TD COLSPAN="2">~n' + '1. Enter a registered site code to identify the owning site.' + '</TD>~n'
             + '</TR>~n'
             
             + '<TR>~n'
             + '<TD ALIGN="RIGHT">~n' + 'Owning Site<FONT COLOR="red">*</FONT>:' + '</TD>~n'
             + '<TD>~n' + '<INPUT TYPE="text" NAME="wNumberOwningSite" SIZE="30" VALUE="' + cNumberOwningSite + '"></TD>~n'
             + '</TR>~n'

             + '<TR>~n'
             + '<TD COLSPAN="2">~n' + '<BR>2. (OPTIONAL) Enter a registered site code to identify the allocated site.' + '</TD>~n'
             + '</TR>~n'
             
             + '<TR>~n'
             + '<TD ALIGN="RIGHT">~n' + 'Allocated Site:' + '</TD>~n'
             + '<TD>~n' + '<INPUT TYPE="text" NAME="wNumberAllocatedSite" SIZE="30" VALUE="' + cNumberAllocatedSite + '"></TD>~n'
             + '</TR>~n'
             
             + '<TR>~n'
             + '<TD COLSPAN="2">~n' + '<BR>3. Enter a site number to allocate or start from, or leave empty for auto assignment.' + '</TD>~n'
             + '</TR>~n'
             
             + '<TR>~n'
             + '<TD ALIGN="RIGHT">~n' + 'Site Number:' + '</TD>~n'
             + '<TD>~n' + '<INPUT TYPE="text" NAME="wNumberValue" SIZE="10" MAXLENGTH="9" VALUE="' + cNumberValue + '"></TD>~n'
             + '</TR>~n'
             
             + '<TR>~n'
             + '<TD COLSPAN="2">~n' + '<BR>4. Specify the number of site numbers (maximum of 100).' + '</TD>~n'
             + '</TR>~n'
             
             + '<TR>~n'
             + '<TD ALIGN="RIGHT">~n' + 'Site Count:' + '</TD>~n'
             + '<TD>~n' + '<INPUT TYPE="text" NAME="wNumberCount" SIZE="10" MAXLENGTH="9" VALUE="'
             + (IF cNumberCount <> "" THEN cNumberCount ELSE "1":U) + '"></TD>~n'
             + '</TR>~n'
             .

  CREATE ttWeb.
  ASSIGN
    iWebLine = iWebLine + 1
    ttWLine  = iWebLine
    ttWValue = '<TR>~n'
             + '<TD COLSPAN="2" ALIGN="center">~n'
             + '<BR>~n'
             + '<INPUT TYPE="submit" NAME="wSiteSubmit" VALUE="'
             + (IF cWebAction = "actionNewSite"    THEN 'Register' ELSE
                IF cWebAction = "actionModifySite" THEN 'Login'    ELSE
                IF cWebAction = "actionUpdateSite" THEN 'Update'   ELSE 'Register')
             + '">~n'
             + '</TD>~n'
             + '</TR>~n'
             + '<TR>~n'
             + '<TD COLSPAN="2">&nbsp;</TD>~n'
             + '</TR>~n'
             .

  IF cWebIDUser <> ""
  THEN DO:

    CREATE ttWeb.
    ASSIGN
      iWebLine = iWebLine + 1
      ttWLine  = iWebLine
      ttWValue = '<TR>~n'
               + '<TD ALIGN="RIGHT">~n'
               + '&nbsp;'
               + '</TD>~n'
               + '<TD COLSPAN="2">~n'
               + '<INPUT NAME="wNumberOverride" TYPE="CHECKBOX" SIZE="20" VALUE="YES" TITLE="Check to override default maximum of 100">~n'
               + 'Override Default Maximum Value of 100 per Site'
               + '</TD>~n'
               + '</TR>~n'
               + '<TR>~n'
               + '<TD ALIGN="RIGHT">~n'
               + 'Authorized User Code:'
               + '</TD>~n'
               + '<TD COLSPAN="2">~n'
               + '<INPUT TYPE="text" NAME="wNumberUserCode" SIZE="30" MAXLENGTH="40">~n'
               + '</TD>~n'
               + '</TR>~n'
               + '<TR>~n'
               + '<TD ALIGN="RIGHT">~n'
               + 'User Password:'
               + '</TD>~n'
               + '<TD COLSPAN="2">~n'
               + '<INPUT TYPE="password" NAME="wNumberUserPassword" SIZE="30" MAXLENTGH="40">~n'
               + '</TD>~n'
               + '</TR>~n'
               + '<TR>~n'
               + '<TD COLSPAN=3>&nbsp;</TD>~n'
               + '</TR>~n'
               .
  END.

  CREATE ttWeb.
  ASSIGN
    iWebLine = iWebLine + 1
    ttWLine  = iWebLine
    ttWValue = '</TBODY>~n'
             + '</TABLE>~n'
             + '</TD>~n'
             + '</TR>~n'
             .

  IF iNumberCreate > 0 AND cNumberOwningSite <> "" THEN DO:
    CREATE ttWeb.
    ASSIGN
      iWebLine = iWebLine + 1
      ttWLine  = iWebLine
      ttWValue = '<TR>~n'
               + '<TD ALIGN="RIGHT" BGCOLOR="000080">~n'
               + '<FONT COLOR="FFFFFF">~n'
               + '<U>~n'
               + 'Allocated'
               + '</U>~n'
               + '</FONT>~n'
               + '</TD>~n'
               + '<TD ALIGN="RIGHT" BGCOLOR="000080">~n'
               + '<FONT COLOR="FFFFFF">~n'
               + '<U>~n'
               + 'Site Number'
               + '</U>~n'
               + '</FONT>~n'
               + '</TD>~n'
               + '<TD ALIGN="CENTER" BGCOLOR="000080">~n'
               + '<FONT COLOR="FFFFFF">~n'
               + '<U>~n'
               + 'Active'
               + '</U>~n'
               + '</FONT>~n'
               + '</TD>~n'
               + '</TR>~n'
               .

    FOR EACH rsm_site_number NO-LOCK
      WHERE rsm_site_number.owning_site_code  = cNumberOwningSite
      BY rsm_site_number.site_number:

      ASSIGN
        iNumberLoop = iNumberLoop + 1
        .

      CREATE ttWeb.
      ASSIGN
        iWebLine = iWebLine + 1
        ttWLine  = iWebLine
        ttWValue = '<TR>~n'
                 + '<TD ALIGN="RIGHT">~n'
                 + STRING(iNumberLoop,"zzzzzzzzz9":U) + '&nbsp;&nbsp;'
                 + '</TD>~n'
                 + '<TD ALIGN="RIGHT">~n'
                 + STRING(rsm_site_number.site_number,"zzzzzzzzz9":U) + '&nbsp;&nbsp;'
                 + '</TD>~n'
                 + '<TD ALIGN="CENTER">~n'
                 + STRING(rsm_site_number.site_number_active)
                 + '</TD>~n'
                 + '</TR>~n'
                 .
    END.

  END.

  RUN setFooter.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-siteNumberQueryNum) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE siteNumberQueryNum Procedure 
PROCEDURE siteNumberQueryNum :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cASiteHtml    AS CHARACTER  NO-UNDO. /* allocated site */
  DEFINE VARIABLE cOSiteHtml    AS CHARACTER  NO-UNDO. /* owning site */
  DEFINE VARIABLE iValueSearch  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iValueFirst   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iValueLast    AS INTEGER    NO-UNDO.

  IF NOT TRANSACTION THEN EMPTY TEMP-TABLE tt_site_number. ELSE FOR EACH tt_site_number: DELETE tt_site_number. END.

  ASSIGN iValueSearch = INTEGER(cWebSearch) NO-ERROR.
  ASSIGN iValueFirst  = INTEGER(cWebFirst)  NO-ERROR.
  ASSIGN iValueLast   = INTEGER(cWebLast)   NO-ERROR.

  loop_Blk:
  DO iBrowseLoop = 1 TO iBrowseRows:
    IF iBrowseLoop = 1 THEN DO:
      IF cWebNavigation = "PREV":U AND iValueFirst > 0 THEN
        FIND FIRST rsm_site_number NO-LOCK
          WHERE rsm_site_number.owning_site_code = 
            (IF cWebIDUser <> "" THEN rsm_site_number.owning_site_code ELSE cWebIDSite)
          AND   rsm_site_number.site_number = iValueFirst NO-ERROR.
      ELSE
      IF cWebNavigation = "NEXT":U AND iValueLast > 0 THEN
        FIND FIRST rsm_site_number NO-LOCK
          WHERE rsm_site_number.owning_site_code = 
            (IF cWebIDUser <> "" THEN rsm_site_number.owning_site_code ELSE cWebIDSite)
          AND rsm_site_number.site_number = iValueLast NO-ERROR.
      ELSE
      IF iValueSearch > 0 THEN
        FIND FIRST rsm_site_number NO-LOCK
          WHERE rsm_site_number.owning_site_code = 
            (IF cWebIDUser <> "" THEN rsm_site_number.owning_site_code ELSE cWebIDSite)
          AND   rsm_site_number.site_number = iValueSearch NO-ERROR.
      ELSE
        FIND FIRST rsm_site_number NO-LOCK
          WHERE rsm_site_number.owning_site_code = 
            (IF cWebIDUser <> "" THEN rsm_site_number.owning_site_code ELSE cWebIDSite)
          NO-ERROR.
    END.
    ELSE DO:
      IF cWebNavigation = "PREV":U THEN 
        FIND PREV rsm_site_number NO-LOCK
          WHERE rsm_site_number.owning_site_code = 
            (IF cWebIDUser <> "" THEN rsm_site_number.owning_site_code ELSE cWebIDSite)
          NO-ERROR.
      ELSE
        FIND NEXT rsm_site_number NO-LOCK
          WHERE rsm_site_number.owning_site_code = 
            (IF cWebIDUser <> "" THEN rsm_site_number.owning_site_code ELSE cWebIDSite)
          NO-ERROR.
    END.

    IF AVAILABLE rsm_site_number THEN DO:
      CREATE tt_site_number NO-ERROR.
      BUFFER-COPY rsm_site_number TO tt_site_number NO-ERROR.
    END.
    ELSE
      LEAVE loop_Blk.
  END.

  ASSIGN
    cOutTitle   = "Dynamics Site List"
    cOutColSpan = "4":U
    cOutSearch  = "Site Number:"
    cOutColumns = "Site Number,Owning Site,Allocated Site,Active"
    .

  /* Reset pointer to first site record. */
  FIND FIRST tt_site_number NO-LOCK NO-ERROR.
  IF AVAILABLE tt_site_number THEN 
    ASSIGN cWebFirst = STRING(tt_site_number.site_number).
  FIND FIRST rsm_site_number NO-LOCK
    WHERE rsm_site_number.site_number = tt_site_number.site_number NO-ERROR.
  FIND PREV rsm_site_number 
    WHERE rsm_site_number.owning_site_code = 
      (IF cWebIDUser <> "" THEN rsm_site_number.owning_site_code ELSE cWebIDSite)
    NO-LOCK NO-ERROR.
  IF AVAILABLE rsm_site_number THEN 
    ASSIGN lOutPrev = YES.

  /* Reset pointer to last site record. */
  FIND LAST tt_site_number NO-LOCK NO-ERROR.
  IF AVAILABLE tt_site_number THEN 
    ASSIGN cWebLast = STRING(tt_site_number.site_number).
  FIND FIRST rsm_site_number NO-LOCK
    WHERE rsm_site_number.site_number = tt_site_number.site_number NO-ERROR.
  FIND NEXT rsm_site_number 
    WHERE rsm_site_number.owning_site_code = 
      (IF cWebIDUser <> "" THEN rsm_site_number.owning_site_code ELSE cWebIDSite)
    NO-LOCK NO-ERROR.
  IF AVAILABLE rsm_site_number THEN 
    ASSIGN lOutNext = YES.

  RUN setHeader.

  FOR EACH tt_site_number NO-LOCK
    BY tt_site_number.site_number:
    CREATE ttWeb.
    ASSIGN
      cOSiteHtml = html-encode(TRIM(tt_site_number.owning_site_code))
      cASiteHtml = html-encode(TRIM(tt_site_number.allocated_site_code))
      iWebLine   = iWebLine + 1
      ttWLine    = iWebLine
      ttWValue   = '<TR>~n'
                 + '<TD ALIGN="RIGHT">~n'
                 + STRING(tt_site_number.site_number,"zzzzzzzzz9":U) + '&nbsp;&nbsp;'
                 + '</TD>~n'
                 + '<TD>~n'
                 + (IF tt_site_number.owning_site_code <> "" THEN cOSiteHtml ELSE '(NONE)' )
                 + '</TD>~n'
                 + '<TD>~n'
                 + (IF tt_site_number.allocated_site_code <> "" THEN cASiteHtml ELSE '&nbsp;' )
                 + '</TD>~n'
                 + '<TD ALIGN="CENTER">~n'
                 + STRING(tt_site_number.site_number_active)
                 + '</TD>~n'
                 + '</TR>~n'
                 .
  END.

  RUN setFooter.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-siteNumberQuerySite) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE siteNumberQuerySite Procedure 
PROCEDURE siteNumberQuerySite :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cASiteHtml    AS CHARACTER  NO-UNDO. /* allocated site */
  DEFINE VARIABLE cOSiteHtml    AS CHARACTER  NO-UNDO. /* owning site */
  DEFINE VARIABLE iValueFirst   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iValueLast    AS INTEGER    NO-UNDO.

  IF NOT TRANSACTION THEN 
  	EMPTY TEMP-TABLE tt_site_number. 
  ELSE 
  	FOR EACH tt_site_number: DELETE tt_site_number. END.

  ASSIGN iValueFirst  = INTEGER(cWebFirst)  NO-ERROR.
  ASSIGN iValueLast   = INTEGER(cWebLast)   NO-ERROR.
  
  loop_Blk:
  DO iBrowseLoop = 1 TO iBrowseRows:
    IF iBrowseLoop = 1 THEN DO:
      IF cWebNavigation = "PREV":U AND cWebFirst <> "" THEN
        FIND FIRST rsm_site_number NO-LOCK
          WHERE rsm_site_number.owning_site_code BEGINS
            (IF cWebSearch = "" THEN rsm_site_number.owning_site_code ELSE cWebSearch)
            AND rsm_site_number.site_number = 
              (IF iValueFirst = 0 THEN rsm_site_number.site_number ELSE iValueFirst)
          NO-ERROR.
      ELSE
      IF cWebNavigation = "NEXT":U AND cWebLast <> "" THEN
        FIND FIRST rsm_site_number NO-LOCK
          WHERE rsm_site_number.owning_site_code BEGINS
            (IF cWebSearch = "" THEN rsm_site_number.owning_site_code ELSE cWebSearch)
            AND rsm_site_number.site_number = 
              (IF iValueLast = 0 THEN rsm_site_number.site_number ELSE iValueLast)
          NO-ERROR.
      ELSE
      IF cWebSearch <> "" THEN
        FIND FIRST rsm_site_number NO-LOCK
          WHERE rsm_site_number.owning_site_code BEGINS cWebSearch NO-ERROR.
      ELSE
        FIND FIRST rsm_site_number NO-LOCK
          USE-INDEX owning_site_code NO-ERROR.
    END.
    ELSE DO:
      IF cWebNavigation = "PREV":U THEN 
        FIND PREV rsm_site_number NO-LOCK
          WHERE rsm_site_number.owning_site_code BEGINS
            (IF cWebSearch = "" THEN rsm_site_number.owning_site_code ELSE cWebSearch)
          USE-INDEX owning_site_code
          NO-ERROR.
      ELSE
        FIND NEXT rsm_site_number NO-LOCK
          WHERE rsm_site_number.owning_site_code BEGINS
            (IF cWebSearch = "" THEN rsm_site_number.owning_site_code ELSE cWebSearch)
          USE-INDEX owning_site_code
          NO-ERROR.
    END.

    IF AVAILABLE rsm_site_number THEN DO:
      CREATE tt_site_number NO-ERROR.
      BUFFER-COPY rsm_site_number TO tt_site_number NO-ERROR.
    END.
    ELSE
      LEAVE loop_Blk.
  END.

  ASSIGN
    cOutTitle   = "Dynamics Site List"
    cOutColSpan = "4"
    cOutSearch  = "Owning Site:"
    cOutColumns = "Site Number,Owning Site,Allocated Site,Active"
    .

  FIND FIRST tt_site_number NO-LOCK USE-INDEX owning_site_code NO-ERROR.
  IF AVAILABLE tt_site_number THEN 
    ASSIGN cWebFirst = STRING(tt_site_number.site_number).
  FIND FIRST rsm_site_number NO-LOCK
    WHERE rsm_site_number.site_number = tt_site_number.site_number
    USE-INDEX owning_site_code NO-ERROR.
  FIND PREV rsm_site_number
    WHERE rsm_site_number.owning_site_code BEGINS
      (IF cWebSearch = "" THEN rsm_site_number.owning_site_code ELSE cWebSearch)
    USE-INDEX owning_site_code NO-LOCK NO-ERROR.
  IF AVAILABLE rsm_site_number THEN 
    ASSIGN lOutPrev = YES.

  FIND LAST tt_site_number NO-LOCK USE-INDEX owning_site_code NO-ERROR.
  IF AVAILABLE tt_site_number THEN 
    ASSIGN cWebLast = STRING(tt_site_number.site_number).
  FIND FIRST rsm_site_number NO-LOCK
    WHERE rsm_site_number.site_number = tt_site_number.site_number
    USE-INDEX owning_site_code NO-ERROR.
  FIND NEXT rsm_site_number
    WHERE rsm_site_number.owning_site_code BEGINS
      (IF cWebSearch = "" THEN rsm_site_number.owning_site_code ELSE cWebSearch)
    USE-INDEX owning_site_code NO-LOCK NO-ERROR.
  IF AVAILABLE rsm_site_number THEN 
    ASSIGN lOutNext = YES.

  RUN setHeader.

  FOR EACH tt_site_number NO-LOCK
    USE-INDEX owning_site_code:

    CREATE ttWeb.
    ASSIGN
      cOSiteHtml = html-encode(tt_site_number.owning_site_code)
      cASiteHtml = html-encode(tt_site_number.allocated_site_code)
      iWebLine   = iWebLine + 1
      ttWLine    = iWebLine
      ttWValue   = '<TR>~n'
                 + '<TD ALIGN="RIGHT">~n'
                 + STRING(tt_site_number.site_number,"zzzzzzzzz9":U) + '&nbsp;&nbsp;'
                 + '</TD>~n'
                 + '<TD>~n'
                 + (IF tt_site_number.owning_site_code <> "" THEN cOSiteHtml ELSE '(NONE)' )
                 + '</TD>~n'
                 + '<TD>~n'
                 + (IF tt_site_number.allocated_site_code <> "" THEN cASiteHtml ELSE '&nbsp;' )
                 + '</TD>~n'
                 + '<TD ALIGN="CENTER">~n'
                 + STRING(tt_site_number.site_number_active)
                 + '</TD>~n'
                 + '</TR>~n'
                 .
  END.

  RUN setFooter.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-siteNumberReAssign) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE siteNumberReAssign Procedure 
PROCEDURE siteNumberReAssign :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cMessage              AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cNumberUserCode       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNumberUserPassword   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNumberOwningSite     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNumberAllocatedSite  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNumberValue          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iNumberValue          AS INTEGER    NO-UNDO.

  DEFINE VARIABLE iNumberAllocated      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iNumberMaximum        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iNumberLoop           AS INTEGER    NO-UNDO.

  ASSIGN
    cMessage              = ""
    iNumberValue          = 0
    iNumberAllocated      = 0
    iNumberLoop           = 0
    iNumberMaximum        = 100
    cNumberUserCode       = get-value("wReNumberUserCode":U)
    cNumberUserPassword   = get-value("wReNumberUserPassword":U)
    cNumberOwningSite     = get-value("wReNumberOwningSite":U)
    cNumberAllocatedSite  = get-value("wReNumberAllocatedSite":U)
    cNumberValue          = get-value("wReNumberValue":U)
    .

  blk_ReNumber:
  DO TRANSACTION:
    IF cSiteSubmit = "re-assign":U AND
      (cNumberAllocatedSite = "" OR
       cNumberUserPassword  = "" OR
       cNumberValue         = "" OR
       cNumberOwningSite    = "") THEN DO:
      ASSIGN
        cMessage = '<FONT COLOR="red">~n'
                 + 'One or more required fields are blank. Please correct and try again.'
                 + '</FONT>~n'
                 + '<BR>~n'.
      LEAVE blk_ReNumber.
    END. 
    
    IF  cNumberValue      = ""
    OR (cNumberOwningSite = "" AND cNumberAllocatedSite = "") THEN DO:
      ASSIGN
        cMessage = cMessage
                 + '<LI>Enter the Site Number and the new site information.'
                 + '<LI>Required fields are marked with a red asterisk (<FONT COLOR="red">*</FONT>).'
                 + '<LI>The Owning Site Code is your actual user or system to which the Site Number is being allocated.'
                 + '<LI>The Allocated Site Code is the company, group or organization code, if applicable.'
                 .
      LEAVE blk_ReNumber.
    END.

    IF cNumberUserCode <> "" THEN DO:
     FIND FIRST rsm_user NO-LOCK
       WHERE rsm_user.user_code     = cNumberUserCode
       AND   rsm_user.user_password = ENCODE(cNumberUserPassword) NO-ERROR.
      IF AVAILABLE rsm_user THEN DO:
        IF rsm_user.maintain_system_data = YES
          AND rsm_user.maximum_authorize > iNumberMaximum THEN
          ASSIGN
            iNumberMaximum = rsm_user.maximum_authorize.
      END.
      ELSE DO:
        ASSIGN
          cMessage = '<FONT COLOR="red">~n'
                   + 'The authorized user information entered is invalid.  Please correct and try again.'
                   + '</FONT>~n'
                   + '<BR>~n'.
        LEAVE blk_ReNumber.
      END.
    END.

    IF cNumberOwningSite <> "" THEN DO:
      FIND FIRST rsm_site NO-LOCK
        WHERE rsm_site.site_code = cNumberOwningSite NO-ERROR.
      IF NOT AVAILABLE rsm_site THEN DO:
        ASSIGN
          cMessage = cMessage
                   + '<FONT COLOR="red">~n'
                   + 'The owning site information entered is invalid.  Please correct and try again.'
                   + '</FONT>~n'
                   + '<BR>~n'.
        LEAVE blk_ReNumber.
      END.

      FOR EACH rsm_site NO-LOCK
        WHERE rsm_site.site_code = cNumberOwningSite,
        EACH rsm_site_number NO-LOCK
          WHERE rsm_site_number.owning_site_code = rsm_site.site_code:
        ASSIGN iNumberAllocated = iNumberAllocated + 1.
      END.

    END.

    IF cNumberAllocatedSite <> "" THEN DO:
      FIND FIRST rsm_site NO-LOCK
        WHERE rsm_site.site_code = cNumberAllocatedSite NO-ERROR.
      IF NOT AVAILABLE rsm_site THEN DO:
        ASSIGN
          cMessage = cMessage
                   + '<FONT COLOR="red">~n'
                   + 'The allocated site information entered is invalid.  Please correct and try again.'
                   + '</FONT>~n'
                   + '<BR>~n'.
        LEAVE blk_ReNumber.
      END.

    END.

    IF iNumberAllocated >= iNumberMaximum THEN DO:
      ASSIGN
        cMessage = cMessage
                 + '<FONT COLOR="red">~n'
                 + 'Maximum allocated numbers reached.  Please get authorization to allocate additional site numbers.'
                 + '</FONT>~n'
                 + '<BR>~n'.
      LEAVE blk_ReNumber.
    END.

    ASSIGN iNumberValue = INTEGER(cNumberValue) NO-ERROR.

    IF iNumberValue > 0 THEN DO:
      FIND FIRST rsm_site_number EXCLUSIVE-LOCK
        WHERE rsm_site_number.site_number = iNumberValue NO-ERROR.
      IF NOT AVAILABLE rsm_site_number THEN DO:
        ASSIGN
          cMessage = cMessage
                   + '<FONT COLOR="red">~n'
                   + 'Site Number &quot;' + STRING(iNumberValue) + '&quot; are not allocated.  Please enter a new Site Number and try again.'
                   + '</FONT>~n'
                   + '<BR>~n'.
        LEAVE blk_ReNumber.
      END.
      ELSE DO:

        ASSIGN
          rsm_site_number.owning_site_code    = cNumberOwningSite
          rsm_site_number.allocated_site_code = cNumberAllocatedSite
          NO-ERROR.
        IF ERROR-STATUS:ERROR
        THEN DO:
          ASSIGN
            cMessage = cMessage
                     + '<FONT COLOR="red">~n'
                     + 'Error re-assigning Site Number &quot;' + STRING(iNumberValue) + '&quot;.'
                     + '<BR>~n'
                     + ERROR-STATUS:GET-MESSAGE(1)
                     + '</FONT>~n'
                     + '<BR>~n'.
        END.
        ELSE
          ASSIGN
            iNumberAllocated  = iNumberAllocated + 1.
      END.

      IF iNumberAllocated >= iNumberMaximum THEN DO:
        ASSIGN
          cMessage = cMessage
                   + '<FONT COLOR="red">~n'
                   + 'Maximum allocated numbers reached.  Please get authorization to allocate additional site numbers.'
                   + '</FONT>~n'
                   + '<BR>~n'.
        UNDO blk_ReNumber, LEAVE blk_ReNumber.
      END.
      ELSE
        ASSIGN
          cMessage    = cMessage
                      + '<FONT COLOR="green">~n'
                      + 'Site number(s) re-assigned succesfully.'
                      + '</FONT>~n'
                      + '<BR>~n'.

    END.

  END.

  ASSIGN
    cOutTitle       = "Dynamics Site Number Re-Assignment"
    cOutCaption     = "Dynamics Site Number Re-Assignment"
    cOutSubCaption  = "Re-Assign Site Numbers"
    cOutColSpan     = "2"
    cOutMessage     = cMessage
    .

  RUN setHeader.

  CREATE ttWeb.
  ASSIGN
    iWebLine = iWebLine + 1
    ttWLine  = iWebLine
    ttWValue = '<TR>~n'
             + '<TD COLSPAN="2">~n'
             .

  CREATE ttWeb.
  ASSIGN
    iWebLine = iWebLine + 1
    ttWLine  = iWebLine
    ttWValue = '<TABLE SUMMARY="Dynamics Site Inner" BORDER="0" CELLSPACING="0" CELLPADDING="2" WIDTH="100%">~n'
             + '<TBODY>~n'
             + '<TR>~n'
             + '<TD>~n'
             + '&nbsp;'
             + '</TD>~n'
             + '<TD>~n'
             + '&nbsp;'
             + '</TD>~n'
             + '</TR>~n'
             .

  CREATE ttWeb.
  ASSIGN
    iWebLine = iWebLine + 1
    ttWLine  = iWebLine
    ttWValue = '<TR>~n'
             + '<TD ALIGN="RIGHT">~n'
             + 'Authorized User Code<FONT COLOR="red">*</FONT>:'
             + '</TD>~n'
             + '<TD>~n'
             + '<INPUT TYPE="text" NAME="wReNumberUserCode" SIZE="30" MAXLENGTH="40">~n'
             + '</TD>~n'
             + '</TR>~n'
             + '<TR>~n'
             + '<TD ALIGN="RIGHT">~n'
             + 'User Password<FONT COLOR="red">*</FONT>:'
             + '</TD>~n'
             + '<TD>~n'
             + '<INPUT TYPE="password" NAME="wReNumberUserPassword" SIZE="30" MAXLENTGH="40">~n'
             + '</TD>~n'
             + '</TR>~n'
             + '<TR>~n'
             + '<TD ALIGN="RIGHT">~n'
             + 'Site Number<FONT COLOR="red">*</FONT>:'
             + '</TD>~n'
             + '<TD>~n'
             + '<INPUT TYPE="text" NAME="wReNumberValue" SIZE="10" MAXLENGTH="9" VALUE="'
             + cNumberValue
             + '">~n'
             + '</TD>~n'
             + '</TR>~n'
             + '<TR>~n'
             + '<TD ALIGN="RIGHT">~n'
             + 'Owning Site<FONT COLOR="red">*</FONT>:'
             + '</TD>~n'
             + '<TD>~n'
             + '<INPUT TYPE="text" NAME="wReNumberOwningSite" SIZE="30" VALUE="'
             + cNumberOwningSite
             + '">~n'
             + '</TD>~n'
             + '</TR>~n'
             + '<TR>~n'
             + '<TD ALIGN="RIGHT">~n'
             + 'Allocated Site:'
             + '</TD>~n'
             + '<TD>~n'
             + '<INPUT TYPE="text" NAME="wReNumberAllocatedSite" SIZE="30" VALUE="'
             + cNumberAllocatedSite
             + '">~n'
             + '</TD>~n'
             + '</TR>~n'
             .

  CREATE ttWeb.
  ASSIGN
    iWebLine = iWebLine + 1
    ttWLine  = iWebLine
    ttWValue = '<TR>~n'
             + '<TD COLSPAN=2 ALIGN="CENTER">~n'
             + '<BR>~n'
             + '<INPUT TYPE="submit" NAME="wSiteSubmit" VALUE="'
             + 'Re-Assign'
             + '">~n'
             + '</TD>~n'
             + '</TR>~n'
             + '<TR>~n'
             + '<TD COLSPAN=2>&nbsp;</TD>~n'
             + '</TR>~n'
             .

  CREATE ttWeb.
  ASSIGN
    iWebLine = iWebLine + 1
    ttWLine  = iWebLine
    ttWValue = '</TBODY>~n'
             + '</TABLE>~n'
             + '</TD>~n'
             + '</TR>~n'
             .

  RUN setFooter.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-siteUserControl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE siteUserControl Procedure 
PROCEDURE siteUserControl :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cMessage                AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cUserCode               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cUserEmail              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cUserPassword           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cUserPassword2          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cUserMaxAuthorize       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cUserMaintainSystemData AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAuthUserCode           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAuthUserPassword       AS CHARACTER  NO-UNDO.

  ASSIGN
    cMessage                = ""
    cUserCode               = get-value("wUserCode":U)
    cUserEmail              = get-value("wUserEmail":U)
    cUserPassword           = get-value("wUserPassword":U)
    cUserPassword2          = get-value("wUserPassword2":U)
    cUserMaxAuthorize       = get-value("wUserMaxAuthorize":U)
    cUserMaintainSystemData = get-value("wUserMaintainSystemData":U)
    cAuthUserCode           = get-value("wAuthUserCode":U)
    cAuthUserPassword       = get-value("wAuthUserPassword":U)
    .

  blk_User:
  DO WITH TRANSACTION:
    IF cUserSubmit <> "" AND cWebAction = "actionModifyUser" 
      AND (cUserCode = "" OR cUserPassword = "") THEN DO:
      ASSIGN
        cMessage = cMessage
                 + '<FONT COLOR="red">~n'
                 + 'One or more required fields are blank. Please correct and try again.'
                 + '</FONT>~n'
                 + '<BR>~n'.
      LEAVE blk_User.
    END.

    IF cUserSubmit = "" THEN DO:
      ASSIGN
        cMessage = '<LI>' 
                 + SUBSTITUTE('Enter your user information and press the &1 button.',
                     (IF cWebAction = 'actionNewUser' THEN 'Register' ELSE 'Update'))
                 + '<LI>Required fields are marked with a red asterisk (<FONT COLOR="red">*</FONT>).'
                 + '<BR>~n'.
      LEAVE blk_User.
    END.

    IF cWebAction = "actionModifyUser" THEN DO:
      ASSIGN
        cWebIDUser = "".

      IF cWebIDUser = "" AND cUserCode <> "" THEN
        FIND FIRST rsm_user NO-LOCK
          WHERE rsm_user.user_code     = cUserCode
          AND   rsm_user.user_password = ENCODE(cUserPassword) NO-ERROR.
      IF AVAILABLE rsm_user THEN
        ASSIGN cWebIDUser = rsm_user.user_code.

      IF  cWebIDUser = ""
        AND cUserEmail <> "" THEN
        FIND FIRST rsm_user NO-LOCK
          WHERE rsm_user.user_email    = cUserEmail
          AND   rsm_user.user_password = ENCODE(cUserPassword) NO-ERROR.
      IF AVAILABLE rsm_user THEN
        ASSIGN cWebIDUser = rsm_user.user_code.

      IF cWebIDUser = "" THEN DO:
        ASSIGN
          cMessage = '<FONT COLOR="red">~n'
                   + 'The user information entered is invalid.  Please correct and try again.'
                   + '</FONT>~n'
                   + '<BR>~n'.
        LEAVE blk_User.
      END.
      ELSE
        ASSIGN
          cWebAction              = "actionUpdateUser"
          cUserCode               = rsm_user.user_code
          cUserEmail              = rsm_user.user_email
          cUserMaxAuthorize       = STRING(rsm_user.maximum_authorize)
          cUserMaintainSystemData = (IF rsm_user.maintain_system_data = YES THEN "YES" ELSE "NO")
          cMessage                = '<LI>Update user information and press the Update button.' + '<BR>~n'.
          .
    END.
    ELSE
    IF cWebAction = "actionUpdateUser" THEN DO:
      IF  (cUserPassword <> ""
        OR cUserPassword2 <> "")
      AND (cUserPassword <> cUserPassword2
        OR ENCODE(cUserPassword) <> ENCODE(cUserPassword2)) THEN DO:
        ASSIGN
          cMessage = cMessage
                   + '<FONT COLOR="red">~n'
                   + 'The new passwords entered do not match.  Please correct and try again.'
                   + '<BR>~n'
                   + cUserPassword
                   + '<BR>~n'
                   + cUserPassword2
                   + '<BR>~n'
                   + '</FONT>~n'
                   + '<BR>~n'.
        LEAVE blk_User.
      END.

      IF cWebIDUser = "" THEN DO:
        ASSIGN
          cMessage = '<FONT COLOR="red">~n'
                   + 'The user information entered is invalid.  Please re-login and try again.'
                   + '</FONT>~n'
                   + '<BR>~n'.
        LEAVE blk_User.
      END.

      FIND FIRST rsm_user NO-LOCK
        WHERE rsm_user.user_code = cWebIDUser NO-ERROR.
      IF NOT AVAILABLE rsm_user THEN DO:
        ASSIGN
          cMessage = '<FONT COLOR="red">~n'
                   + 'The user information entered is invalid.  Please correct and try again.'
                   + '</FONT>~n'
                   + '<BR>~n'.
        LEAVE blk_User.
      END.
      ELSE
        ASSIGN
          cWebIDUser = rsm_user.user_code.

      FIND rsm_user EXCLUSIVE-LOCK
        WHERE rsm_user.user_code = cWebIDUser
        NO-ERROR.
      ASSIGN
        rsm_user.user_email           = cUserEmail
        rsm_user.user_password        = (IF cUserPassword <> "" AND cUserPassword2 <> "" THEN ENCODE(cUserPassword) ELSE rsm_user.user_password)
        rsm_user.maximum_authorize    = INTEGER(cUserMaxAuthorize)
        rsm_user.maintain_system_data = (IF cUserMaintainSystemData = "YES" THEN YES ELSE NO)
        NO-ERROR.
      IF ERROR-STATUS:ERROR THEN DO:
        ASSIGN
          cMessage = '<FONT COLOR="red">~n'
                   + 'Error updating user with User Code &quot;' + cUserCode + '&quot;.'
                   + '<BR>~n'
                   + ERROR-STATUS:GET-MESSAGE(1)
                   + '</FONT>~n'
                   + '<BR>~n'.
      END.
      ELSE
        ASSIGN
          cUserCode               = rsm_user.user_code
          cUserEmail              = rsm_user.user_email
          cUserMaxAuthorize       = STRING(rsm_user.maximum_authorize)
          cUserMaintainSystemData = (IF rsm_user.maintain_system_data = YES THEN "YES" ELSE "NO")
          cMessage                = '<FONT COLOR="green">~n'
                                  + 'User updated successfully.'
                                  + '</FONT>~n'
                                  + '<BR>~n'.
      LEAVE blk_User.
    END.
  
    /* cWebAction = "actionNewUser" */
    ELSE DO: 
      IF cAuthUserCode = "" OR cUserCode = "" THEN DO:
        ASSIGN
          cMessage = '<FONT COLOR="red">~n'
                   + 'One or more required fields are blank. Please correct and try again.'
                   + '</FONT>~n'
                   + '<BR>~n'.
        LEAVE blk_User.
      END.

      IF  cAuthUserCode <> "" THEN DO:
        FIND FIRST rsm_user NO-LOCK
          WHERE rsm_user.user_code     = cAuthUserCode
          AND   rsm_user.user_password = ENCODE(cAuthUserPassword) NO-ERROR.
        IF NOT AVAILABLE rsm_user THEN DO:
          ASSIGN
            cMessage = '<FONT COLOR="red">~n'
                     + 'The authorized user information entered is invalid.  Please correct and try again.'
                     + '</FONT>~n'
                     + '<BR>~n'.
          LEAVE blk_User.
        END.
        IF AVAILABLE rsm_user AND rsm_user.maintain_system_data = NO THEN DO:
          ASSIGN
            cMessage = '<FONT COLOR="red">~n'
                     + 'The authorized user does not have the required privileges.  Please correct and try again.'
                     + '</FONT>~n'
                     + '<BR>~n'.
          LEAVE blk_User.
        END.
      END.

      IF cUserPassword <> cUserPassword2
        OR ENCODE(cUserPassword) <> ENCODE(cUserPassword2) THEN DO:
        ASSIGN
          cMessage = cMessage
                   + '<FONT COLOR="red">~n'
                   + 'The passwords entered do not match.  Please correct and try again.'
                   + '</FONT>~n'
                   + '<BR>~n'.
        LEAVE blk_User.
      END.

      FIND FIRST rsm_user NO-LOCK
        WHERE rsm_user.user_code = cUserCode NO-ERROR.
      IF AVAILABLE rsm_user THEN DO:
        ASSIGN
          cMessage = '<FONT COLOR="red">~n'
                   + 'User Code &quot;' + cUserCode + '&quot; already exists.  Please enter a new User Code and try again.'
                   + '</FONT>~n'
                   + '<BR>~n'.
        LEAVE blk_User.
      END.
      ELSE DO:
        CREATE rsm_user.
        ASSIGN
          rsm_user.user_code            = cUserCode
          rsm_user.user_email           = cUserEmail
          rsm_user.user_password        = ENCODE(cUserPassword)
          rsm_user.maximum_authorize    = INTEGER(cUserMaxAuthorize)
          rsm_user.maintain_system_data = (IF cUserMaintainSystemData = "YES" THEN YES ELSE NO)
          NO-ERROR.
      IF ERROR-STATUS:ERROR
      THEN DO:
        ASSIGN
          cMessage = '<FONT COLOR="red">~n'
                   + 'Error creating user with User Code &quot;' + cUserCode + '&quot;.'
                   + '<BR>~n'
                   + ERROR-STATUS:GET-MESSAGE(1)
                   + '</FONT>~n'
                   + '<BR>~n'.
      END.
      ELSE
        ASSIGN
          cWebIDUser = cUserCode
          cMessage    = '<FONT COLOR="green">~n'
                      + 'User created succesfully.'
                      + '</FONT>~n'
                      + '<BR>~n'.
        LEAVE blk_User.
      END.

    END.

  END.

  ASSIGN
    cOutTitle   = "Dynamics User Control"
    cOutColSpan = "2"
    cOutMessage = cMessage
    .

  CASE cWebAction:
    WHEN "actionNewUser"    THEN cOutSubCaption = "Register User".
    WHEN "actionModifyUser" THEN cOutSubCaption = "Update User".
    WHEN "actionUpdateUser" THEN cOutSubCaption = "Update User".
    OTHERWISE                    cOutSubCaption = "User Control".
  END CASE.

  RUN setHeader.

  CREATE ttWeb.
  ASSIGN
    iWebLine = iWebLine + 1
    ttWLine  = iWebLine
    ttWValue = '<TR>~n'
             + '<TD>~n'
             .

  CREATE ttWeb.
  ASSIGN
    iWebLine = iWebLine + 1
    ttWLine  = iWebLine
    ttWValue = '<TABLE SUMMARY="Dynamics User Inner" BORDER="0" CELLSPACING="0" CELLPADDING="2" WIDTH="100%">~n'
             + '<TBODY>~n'
             + '<TR>~n'
             + '<TD WIDTH="30%">~n'
             + '&nbsp;'
             + '</TD>~n'
             + '<TD WIDTH="70%">~n'
             + '&nbsp;'
             + '</TD>~n'
             + '</TR>~n'
             .

  CREATE ttWeb.
  ASSIGN
    iWebLine = iWebLine + 1
    ttWLine  = iWebLine
    ttWValue = '<TR>~n'
             + '<TD ALIGN="RIGHT">~n'
             + 'User Code<FONT COLOR="red">*</FONT>:'
             + '</TD>~n'
             + '<TD>~n'
             + '<INPUT TYPE="text" NAME="wUserCode" SIZE="30" VALUE="'
             + cUserCode
             + '"'
             + (IF cWebAction = "actionUpdateUser" THEN ' DISABLED ' ELSE '')
             + '>~n'
             + '</TD>~n'
             + '</TR>~n'
             .

  CREATE ttWeb.
  ASSIGN
    iWebLine = iWebLine + 1
    ttWLine  = iWebLine
    ttWValue = '<TR>~n'
             + '<TD ALIGN="RIGHT">~n'
             + 'E-mail address:'
             + '</TD>~n'
             + '<TD>~n'
             + '<INPUT TYPE="text" NAME="wUserEmail" SIZE="30" VALUE="'
             + cUserEmail
             + '">~n'
             + '</TD>~n'
             + '</TR>~n'
             .

  CREATE ttWeb.
  ASSIGN
    iWebLine = iWebLine + 1
    ttWLine  = iWebLine
    ttWValue = '<TR>~n'
             + '<TD ALIGN="RIGHT">~n'
             + (IF cWebAction = "actionModifyUser" THEN 'Password<FONT COLOR="red">*</FONT>:' 
                ELSE 'New&nbsp;Password:')
             + '</TD>~n'
             + '<TD>~n'
             + '<INPUT TYPE="password" NAME="wUserPassword" SIZE="30">~n'
             + '</TD>~n'
             + '</TR>~n'
             .

  IF cWebAction = "actionNewUser"
  OR cWebAction = "actionUpdateUser"
  THEN DO:
    CREATE ttWeb.
    ASSIGN
      iWebLine = iWebLine + 1
      ttWLine  = iWebLine
      ttWValue = '<TR>~n'
               + '<TR>~n'
               + '<TD ALIGN="RIGHT">~n'
               + 'Confirm&nbsp;Password:'
               + '</TD>~n'
               + '<TD>~n'
               + '<INPUT TYPE="password" NAME="wUserPassword2" SIZE="30">~n'
               + '</TD>~n'
               + '</TR>~n'
               .

    CREATE ttWeb.
    ASSIGN
      iWebLine = iWebLine + 1
      ttWLine  = iWebLine
      ttWValue = '<TR>~n'
               + '<TD ALIGN="RIGHT">~n'
               + 'Maximum Authorize:'
               + '</TD>~n'
               + '<TD>~n'
               + '<INPUT TYPE="text" NAME="wUserMaxAuthorize" SIZE="10" MAXLENGTH="9" VALUE="'
               + cUserMaxAuthorize
               + '">~n'
               + '</TD>~n'
               + '</TR>~n'
               + '<TR>~n'
               + '<TD ALIGN="RIGHT">~n'
               + '&nbsp;'
               + '</TD>~n'
               + '<TD>~n'
               + '<INPUT TYPE="checkbox" NAME="wUserMaintainSystemData" VALUE="YES"'
               + (IF cUserMaintainSystemData = "YES" THEN ' CHECKED ' ELSE '')
               + '>Maintain System Data'
               + '</TD>~n'
               + '</TR>~n'
               .
  END.

  CREATE ttWeb.
  ASSIGN
    iWebLine = iWebLine + 1
    ttWLine  = iWebLine
    ttWValue = '<TR>~n'
             + '<TD COLSPAN=2 ALIGN="CENTER">~n'
             + '<BR>~n'
             + '<INPUT TYPE="submit" NAME="wUserSubmit" VALUE="'
             + (IF cWebAction = "actionNewUser"    THEN 'Register' ELSE
                IF cWebAction = "actionModifyUser" THEN 'Login'   ELSE
                IF cWebAction = "actionUpdateUser" THEN 'Update'   ELSE 'Register')
             + '">~n'
             + '</TD>~n'
             + '</TR>~n'
             + '<TR>~n'
             + '<TD COLSPAN=2>&nbsp;</TD>~n'
             + '</TR>~n'
             .

  IF cWebAction = "actionNewUser"
  THEN DO:
    CREATE ttWeb.
    ASSIGN
      iWebLine = iWebLine + 1
      ttWLine  = iWebLine
      ttWValue = '<TR>~n'
               + '<TD ALIGN="RIGHT">~n'
               + 'Authorized&nbsp;User&nbsp;Code:'
               + '</TD>~n'
               + '<TD>~n'
               + '<INPUT TYPE="text" NAME="wAuthUserCode" SIZE="30" MAXLENGTH="40">~n'
               + '</TD>~n'
               + '</TR>~n'
               + '<TR>~n'
               + '<TD ALIGN="RIGHT">~n'
               + 'User&nbsp;Password:'
               + '</TD>~n'
               + '<TD>~n'
               + '<INPUT TYPE="password" NAME="wAuthUserPassword" SIZE="30" MAXLENTGH="40">~n'
               + '</TD>~n'
               + '</TR>~n'
               + '<TR>~n'
               + '<TD COLSPAN=2>&nbsp;</TD>~n'
               + '</TR>~n'
               .
  END.

  CREATE ttWeb.
  ASSIGN
    iWebLine = iWebLine + 1
    ttWLine  = iWebLine
    ttWValue = '</TBODY>~n'
             + '</TABLE>~n'
             + '</TD>~n'
             + '</TR>~n'
             .

  RUN setFooter.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-siteUserQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE siteUserQuery Procedure 
PROCEDURE siteUserQuery :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  IF NOT TRANSACTION THEN EMPTY TEMP-TABLE tt_user. ELSE FOR EACH tt_user: DELETE tt_user. END.

  loop_Blk:
  DO iBrowseLoop = 1 TO iBrowseRows:
    IF iBrowseLoop = 1 THEN DO:
      IF cWebNavigation = "PREV":U
      AND cWebFirst <> "" THEN
        FIND FIRST rsm_user NO-LOCK
          WHERE rsm_user.user_code = cWebFirst NO-ERROR.
      ELSE
      IF cWebNavigation = "NEXT":U
      AND cWebLast <> "" THEN
        FIND FIRST rsm_user NO-LOCK
          WHERE rsm_user.user_code = cWebLast NO-ERROR.
      ELSE
      IF cWebSearch <> "" THEN
        FIND FIRST rsm_user NO-LOCK
          WHERE rsm_user.user_code BEGINS cWebSearch NO-ERROR.
      ELSE
        FIND FIRST rsm_user NO-LOCK NO-ERROR.
    END.
    ELSE DO:
      IF cWebNavigation = "PREV":U THEN 
        FIND PREV rsm_user NO-LOCK
          NO-ERROR.
      ELSE
        FIND NEXT rsm_user NO-LOCK
          NO-ERROR.
    END.

    IF AVAILABLE rsm_user THEN DO:
      CREATE tt_user.
      BUFFER-COPY rsm_user TO tt_user.
    END.
    ELSE
      LEAVE loop_Blk.
  END.

  ASSIGN
    cOutTitle   = "Dynamics User List"
    cOutColSpan = "4"
    cOutSearch  = "User Code:"
    cOutColumns = "User Code,User E-mail,Maximum Authorize,Maintain System Data"
    .

  FIND FIRST tt_user NO-ERROR.
  IF AVAILABLE tt_user THEN 
    ASSIGN cWebFirst = STRING(tt_user.user_code).
  FIND FIRST rsm_user NO-LOCK
    WHERE rsm_user.user_code = tt_user.user_code NO-ERROR.
  FIND PREV rsm_user NO-LOCK NO-ERROR.
  IF AVAILABLE rsm_user THEN 
    ASSIGN lOutPrev = YES.

  FIND LAST tt_user NO-ERROR.
  IF AVAILABLE tt_user THEN 
    ASSIGN cWebLast = STRING(tt_user.user_code).
  FIND FIRST rsm_user NO-LOCK
    WHERE rsm_user.user_code = tt_user.user_code NO-ERROR.
  FIND NEXT rsm_user NO-LOCK NO-ERROR.
  IF AVAILABLE rsm_user THEN 
    ASSIGN lOutNext = YES.

  RUN setHeader.

  FOR EACH tt_user
    BY tt_user.user_code:

    CREATE ttWeb.
    ASSIGN
      iWebLine = iWebLine + 1
      ttWLine  = iWebLine
      ttWValue = '<TR>~n'
               + '<TD>~n'
               + tt_user.user_code
               + '</TD>~n'
               + '<TD>~n'
               + (IF tt_user.user_email <> "" THEN ( '<A HREF="mailto:'
                                                     + TRIM(tt_user.user_email)
                                                     + '">~n'
                                                     + TRIM(tt_user.user_email)
                                                     ) ELSE '&nbsp;' )
               + '</TD>~n'
               + '<TD ALIGN="RIGHT">~n'
               + STRING(tt_user.maximum_authorize,"zzzzzzzzz9":U)
               + '</TD>~n'
               + '<TD ALIGN="CENTER">~n'
               + STRING(tt_user.maintain_system_data)
               + '</TD>~n'
               + '</TR>~n'
               .
  END.

  RUN setFooter.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-verifyID) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verifyID Procedure 
PROCEDURE verifyID :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  IF cEXWebIDSite <> "" THEN DO:
    FIND FIRST rsm_site NO-LOCK
      WHERE ENCODE(rsm_site.site_code) = cEXWebIDSite NO-ERROR.
    ASSIGN cWebIDSite = IF AVAILABLE rsm_site THEN rsm_site.site_code ELSE "".
  END.

  IF cEXWebIDUser <> "" THEN DO:
    FIND FIRST rsm_user NO-LOCK
      WHERE ENCODE(rsm_user.user_code) = cEXWebIDUser NO-ERROR.
    ASSIGN cWebIDUser = IF AVAILABLE rsm_user THEN rsm_user.user_code ELSE "".
  END.

  IF cWebIDSite <> "" THEN DO:
    FIND FIRST rsm_site NO-LOCK
      WHERE rsm_site.site_code = cWebIDSite NO-ERROR.
    ASSIGN cWebIDSite = IF AVAILABLE rsm_site THEN rsm_site.site_code ELSE "".
  END.

  IF cWebIDUser <> "" THEN DO:
    FIND FIRST rsm_user NO-LOCK
      WHERE rsm_user.user_code = cWebIDUser NO-ERROR.
    ASSIGN cWebIDUser = IF AVAILABLE rsm_user THEN rsm_user.user_code ELSE "".
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

