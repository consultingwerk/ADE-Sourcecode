/*********************************************************************
* Copyright (C) 2000-2001 by Progress Software Corporation ("PSC"),  *
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
/*
Procedure:    adecomm/_about.p
Author:       R. Ryan
Created:      1/95
Purpose:      re-written by Bob Ryan 1/95 to look better under 3-D
              and provide some Windows environment info
*/

&SCOPED-DEFINE FRAME-NAME  Dialog-1

&IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
  &SCOPED-DEFINE StartRow 6
  &SCOPED-DEFINE StartCol 4
  &SCOPED-DEFINE OKBtnRow 8.5
&ELSE
  &SCOPED-DEFINE StartRow 5
  &SCOPED-DEFINE StartCol 11.57
  &SCOPED-DEFINE OKBtnRow 7.5
&ENDIF

{adecomm/adestds.i}

DEFINE INPUT PARAMETER pTitle AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pIcon  AS CHARACTER NO-UNDO.

DEFINE VARIABLE result       AS LOGICAL   NO-UNDO.
DEFINE VARIABLE AboutText    AS CHARACTER FORMAT "x(50)" NO-UNDO.
DEFINE VARIABLE Label1       AS CHARACTER FORMAT "x(50)" VIEW-AS TEXT.
DEFINE VARIABLE Label2       AS CHARACTER FORMAT "x(50)" VIEW-AS TEXT.
DEFINE VARIABLE DBEtestvalue AS CHARACTER NO-UNDO.
DEFINE VARIABLE ProName      AS CHARACTER NO-UNDO.
DEFINE VARIABLE ABLic        AS INTEGER   NO-UNDO.
DEFINE VARIABLE ABTools      AS CHARACTER NO-UNDO.
DEFINE VARIABLE Workshop-only AS LOGICAL  NO-UNDO.

DEFINE VARIABLE majorversion  AS INTEGER   NO-UNDO.
DEFINE VARIABLE minorversion  AS CHARACTER NO-UNDO.
DEFINE VARIABLE dot           AS INTEGER   NO-UNDO.
DEFINE VARIABLE patchlevel    AS CHARACTER NO-UNDO.
DEFINE VARIABLE POSSEVersion  AS CHARACTER NO-UNDO.
DEFINE VARIABLE cTextFile     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cCommercialVer   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cLine         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lICF          AS LOGICAL    NO-UNDO.


DEFINE IMAGE AboutImage &IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
                           SIZE-PIXELS 32 BY 32.
                         &ELSE
                           SIZE-PIXELS 42 BY 42.
                         &ENDIF

DEFINE RECTANGLE TopLine    
  EDGE-PIXELS 2 GRAPHIC-EDGE NO-FILL SIZE 45 BY .08.
DEFINE RECTANGLE BottomLine LIKE TopLine.
DEFINE RECTANGLE ContainerRectangle
  EDGE-PIXELS 2 SIZE-PIXELS 40 BY 40 BGCOLOR 8.

DEFINE BUTTON BtnOK AUTO-END-KEY
  LABEL "OK":l SIZE 10 BY 1.

DEFINE FRAME Dialog-1
&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
  ContainerRectangle AT ROW 1.5 COLUMNS 3
  AboutImage AT ROW 1.67 COLUMNS 3.57
  AboutText NO-LABELS AT ROW 1.75 COLUMNS {&StartCol}
            VIEW-AS EDITOR SIZE 55 BY 7 NO-BOX
  SKIP(1)
  TopLine AT 11 SKIP(0.5)
  Label1 AT {&StartCol} NO-LABELS SKIP(.15)
  Label2 AT {&StartCol} NO-LABELS SKIP(0.5)
  BottomLine AT 11 SKIP(1)
  BtnOK AT 27 SKIP(1)
  WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER
  SIDE-LABELS NO-UNDERLINE SCROLLABLE DEFAULT-BUTTON BtnOK.
&ELSE
  ContainerRectangle AT ROW 1.5 COLUMNS 3
  AboutText NO-LABELS AT ROW 1.75 COLUMNS {&StartCol}
            VIEW-AS EDITOR SIZE 50 BY 6 NO-BOX
  SKIP
  TopLine AT 11     SKIP
  BottomLine AT 11  SKIP(1)
  BtnOK AT 27       SKIP
  WITH VIEW-AS DIALOG-BOX SIDE-LABELS DEFAULT-BUTTON BtnOK.
&ENDIF

 
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT EQ ? THEN
  FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

ON WINDOW-CLOSE OF FRAME {&FRAME-NAME} 
  APPLY "END-ERROR":u TO SELF.

/*---------------------------------------------------------------------------*/
main-block:
DO ON ERROR   UNDO main-block, LEAVE main-block
   ON END-KEY UNDO main-block, LEAVE main-block:

  /* general assignments... */
  ASSIGN
    FRAME {&FRAME-NAME}:THREE-D = SESSION:THREE-D
    FRAME {&FRAME-NAME}:TITLE   = "About " + pTitle
    BtnOK:WIDTH                 = IF SESSION:WINDOW-SYSTEM = "TTY":u THEN 
                                    4 ELSE 14
    BtnOK:HEIGHT                = IF SESSION:WINDOW-SYSTEM = "TTY":u THEN 
                                    1 ELSE 1.14
    BtnOK:X                     = (FRAME {&FRAME-NAME}:WIDTH-PIXELS / 2) 
                                - (BtnOK:WIDTH-PIXELS / 2).

  &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
    ASSIGN
      AboutImage:AUTO-RESIZE = TRUE
      result                 = AboutImage:LOAD-IMAGE(pIcon).

    /* Check for WebSpeed Workshop */
    RUN adeshar/_ablic.p (INPUT NO /* ShowMsgs */ , OUTPUT ABLic, OUTPUT ABTools).
    IF ABLic = 2 THEN Workshop-Only = TRUE.
    ELSE Workshop-Only = FALSE.
  &ENDIF 

 RUN GetPatchLevel(OUTPUT patchLevel). /* Read patch level from version file */

 IF Workshop-Only THEN
 DO:
   ASSIGN dot          = INDEX(PROVERSION,".":U)
          majorversion = INT(SUBSTRING(PROVERSION,1,(dot - 1)))
          minorversion = SUBSTRING(PROVERSION,(dot + 1))
          ProName      = "WebSpeed Workshop ":U + 
            STRING(majorversion - 6) + ".":U + minorversion + patchLevel.
 END.
 ELSE
 DO:
 /* Are we running with DBE PROGRESS or not? Test the LENGTH of a value 
   * that is double byte in all 4 languages.  If the RAW LENGTH equals the 
   * character LENGTH, then either the core is not DBE, or the character 
   * set is not one of the 4...
   */
  ASSIGN
    DBEtestvalue = CHR(224) + CHR(164)

    ProName      = IF ( OPSYS <> "WIN32" OR SESSION:DISPLAY-TYPE <> "TTY" OR SESSION:BATCH)
                      AND LENGTH(DBEtestvalue,"CHARACTER":u) <>
                          LENGTH(DBEtestvalue,"RAW":u) THEN
                     "DBE PROGRESS ":u + pTitle
                   ELSE
                     "PROGRESS ":u + pTitle.
  END.
  
  /* Determine whether Dynamics is running */
  ASSIGN lICF = (DYNAMIC-FUNCTION("isICFRunning":U IN THIS-PROCEDURE) = YES) NO-ERROR.
  ERROR-STATUS:ERROR = NO.
  IF lICF THEN    /* Get the commercial version */
    ASSIGN cTextFile = SEARCH("Version":U)
           cTextFile = IF cTextFile = ? THEN SEARCH("Version.txt":U)
                                    ELSE cTextFile.
  /* Only get Posseversion if this is not a commercial version */
  IF cTextFile = "" OR ctextFile = ? THEN
  DO: /* Read the POSSE version from POSSEINFO.XML */
      RUN adecomm/_readpossever.p (OUTPUT POSSEVersion).
  END.
  ELSE DO:
     /* Read the commercial version from the "Version" text file */
    ASSIGN cCommercialVer = "".
    INPUT FROM VALUE(cTextFile) NO-ECHO.
    REPEAT:
        IMPORT UNFORMATTED cLine.
        ASSIGN cCommercialVer = cCommercialVer + cLine + CHR(10).
    END.
    INPUT CLOSE.
  END.

  /* If this is MS-WINDOWS, go out and make some WIN API calls */
  IF SESSION:WINDOW-SYSTEM BEGINS "MS-WIN":u THEN
    RUN adecomm/_winsys.p (OUTPUT Label1, OUTPUT Label2).
  ELSE
    ASSIGN
      Label1 = "Use the ""showcfg"" utility at the operating " +
               "system prompt for licensing information.".
  
  RUN Realize.
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.

HIDE FRAME Dialog-1.

RETURN.

/*---------------------------------------------------------------------------*/
PROCEDURE Realize:
    
DO WITH FRAME {&FRAME-NAME}:
  AboutText =
    ProName + CHR(10) +

    (IF Workshop-Only
     THEN pTitle + " (Build: ":U + PROVERSION + patchLevel + ")":U 
     ELSE "Version ":U + PROVERSION + patchLevel
    ) + CHR(10) +
    (IF cCommercialVer <> "" AND cCommercialVer <> ?
     THEN cCommercialVer + CHR(10) 
     ELSE ""
    ) +
    (IF POSSEVersion <> "" AND POSSEVersion <> ? 
     THEN ("POSSE Version ":U + POSSEVersion + CHR(10) ) 
     ELSE ""
    )  + 
    "Copyright (c) 1984-" + STRING(YEAR(TODAY)) + " Progress Software Corp." + CHR(10) +
    "All rights reserved" + CHR(10).

  IF NOT SESSION:WINDOW-SYSTEM BEGINS "TTY":u THEN
    ASSIGN AboutText = AboutText + CHR(10) +
        "Progress Software Corporation acknowledges the use of Raster Imaging " +
        "Technology copyrighted by Snowbound Software Corporation 1993-1997.".
  ELSE
    ASSIGN AboutText = AboutText + CHR(10) + Label1.

  ASSIGN AboutText:READ-ONLY = TRUE
         AboutText:TAB-STOP  = NO   
         AboutText:SENSITIVE = SESSION:WINDOW-SYSTEM <> "TTY":U
         NO-ERROR.

  &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
  DISPLAY
    AboutText
    Label1 
    Label2 
    WITH FRAME {&FRAME-NAME}.
  &ELSE
  DISPLAY
    AboutText
    WITH FRAME {&FRAME-NAME}.
  &ENDIF

  /* Enable everything so we can test some enabled properties */
  ENABLE btnOK WITH FRAME {&FRAME-NAME}.

  IF FRAME {&FRAME-NAME}:THREE-D THEN
    ASSIGN
      ContainerRectangle:HIDDEN = FALSE
      result                    = ContainerRectangle:MOVE-TO-BOTTOM()
      TopLine:EDGE-PIXELS       = 2
      BottomLine:EDGE-PIXELS    = TopLine:EDGE-PIXELS.
  ELSE
    ASSIGN
      ContainerRectangle:HIDDEN = TRUE
      TopLine:EDGE-PIXELS       = 1
      BottomLine:EDGE-PIXELS    = TopLine:EDGE-PIXELS.
END. /* DO WITH FRAME */

END PROCEDURE.
  
PROCEDURE GetPatchLevel:
  /* Reads the Version file to see if there is a patch level */
  DEFINE OUTPUT PARAMETER patchLevel AS CHARACTER NO-UNDO.

  DEFINE VARIABLE i        AS INTEGER             NO-UNDO.
  DEFINE VARIABLE dlcValue AS CHARACTER           NO-UNDO. /* DLC */
  DEFINE VARIABLE inp      AS CHARACTER           NO-UNDO. /* hold 1st line of version file */
    
  IF OPSYS = "Win32":U THEN /* Get DLC from Registry */
    GET-KEY-VALUE SECTION "Startup":U KEY "DLC":U VALUE dlcValue.

  IF (dlcValue = "" OR dlcValue = ?) THEN DO:
    ASSIGN dlcValue = OS-GETENV("DLC":U). /* Get DLC from environment */
      IF (dlcValue = "" OR dlcValue = ?) THEN DO: /* Still nothing? */
        ASSIGN patchLevel = "".
        RETURN.
      END.
  END.
  FILE-INFO:FILE-NAME = dlcValue + "/version":U.
  IF FILE-INFO:FULL-PATHNAME NE ? THEN DO: /* Read the version file */
    INPUT FROM VALUE(FILE-INFO:FULL-PATHNAME).
      IMPORT UNFORMATTED inp. /* Get the first line */
    INPUT CLOSE.
    /* 
     * As of version 9.1D just append everything from the version file
     * after the version from PROVERSION property
     */
    LEVEL:
    DO i = 2 TO NUM-ENTRIES(inp," ":U):
      IF ENTRY(i,inp," ") BEGINS PROVERSION THEN DO:
        ASSIGN patchLevel = REPLACE(ENTRY(i,inp," "),PROVERSION,"").
        LEAVE LEVEL.
      END.
    END.
  END.         
END PROCEDURE.

&UNDEFINE FRAME-NAME

/* _about.p - end of file */






