&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r2 GUI
/* Procedure Description
"Basic Window Template

Use this template to create a new window. Alter this default template or create new ones to accomodate your needs for different default sizes and/or attributes."
*/
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME Window-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Window-1 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
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
/*------------------------------------------------------------------------

  File:                 break.w

  Description:          Persistent procedure to set/modify breakpoints

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author:               J. Rothermal
  Created:              3/24/95
  Updated:              J. Palazzo 10/95
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to Add all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

DEFINE INPUT PARAMETER pType AS CHAR NO-UNDO.


/* Local Variable Definitions -----------                     */

{protools/psvar.i} 
{protools/ptlshlp.i}

DEFINE VAR h_app           AS HANDLE NO-UNDO.
DEFINE VAR fOK             AS LOG    NO-UNDO.
DEFINE VAR pvalue          AS CHAR   NO-UNDO.
DEFINE VAR cnt             AS INT    NO-UNDO.

{adecomm/_adetool.i}   /* Signify as an ADE Persistent object. */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE WINDOW
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frm-break

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS btn-close slct-objects slct-methods btn-help ~
bf-defined 
&Scoped-Define DISPLAYED-OBJECTS slct-objects slct-methods bf-defined ~
def-label 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR Window-1 AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btn-Add 
     LABEL "&Add" 
     SIZE 12 BY 1
     BGCOLOR 8 .

DEFINE BUTTON btn-close 
     LABEL "Close" 
     SIZE 12 BY 1.

DEFINE BUTTON btn-help 
     LABEL "&Help" 
     SIZE 12 BY 1.

DEFINE BUTTON btn-rmv 
     LABEL "&Remove" 
     SIZE 12 BY 1.

DEFINE VARIABLE def-label AS CHARACTER FORMAT "x(15)":U 
      VIEW-AS TEXT 
     SIZE 25 BY .81 NO-UNDO.

DEFINE VARIABLE bf-defined AS CHARACTER 
     VIEW-AS SELECTION-LIST MULTIPLE 
     SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL 
     SIZE 51 BY 5.24 NO-UNDO.

DEFINE VARIABLE slct-methods AS CHARACTER 
     VIEW-AS SELECTION-LIST MULTIPLE 
     SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL 
     SIZE 24.8 BY 6.67 NO-UNDO.

DEFINE VARIABLE slct-objects AS CHARACTER 
     VIEW-AS SELECTION-LIST MULTIPLE 
     SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL 
     SIZE 24.8 BY 6.67 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frm-break
     btn-close AT ROW 1.48 COL 54
     slct-objects AT ROW 2.33 COL 2 NO-LABEL
     slct-methods AT ROW 2.33 COL 28 NO-LABEL
     btn-Add AT ROW 2.67 COL 54
     btn-help AT ROW 3.95 COL 54
     bf-defined AT ROW 10.1 COL 2 NO-LABEL
     btn-rmv AT ROW 10.1 COL 54
     def-label AT ROW 9.33 COL 2 NO-LABEL
     "SmartObjects" VIEW-AS TEXT
          SIZE 25 BY .76 AT ROW 1.48 COL 2
     "Methods/States" VIEW-AS TEXT
          SIZE 25 BY .76 AT ROW 1.48 COL 28
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 66.57 BY 14.81
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: WINDOW
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW Window-1 ASSIGN
         HIDDEN             = YES
         TITLE              = "Breakpoints"
         HEIGHT             = 14.81
         WIDTH              = 66.6
         MAX-HEIGHT         = 17.48
         MAX-WIDTH          = 91.2
         VIRTUAL-HEIGHT     = 17.48
         VIRTUAL-WIDTH      = 91.2
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW Window-1
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME frm-break
                                                                        */
/* SETTINGS FOR BUTTON btn-Add IN FRAME frm-break
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON btn-rmv IN FRAME frm-break
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN def-label IN FRAME frm-break
   NO-ENABLE ALIGN-L                                                    */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(Window-1)
THEN Window-1:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Window-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Window-1 Window-1
ON END-ERROR OF Window-1 /* Breakpoints */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Window-1 Window-1
ON WINDOW-CLOSE OF Window-1 /* Breakpoints */
DO:
  /* These events will close the window and terminate the procedure.      */
  /* (NOTE: this will override any user-defined triggers previously       */
  /*  defined on the window.)                                             */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bf-defined
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bf-defined Window-1
ON VALUE-CHANGED OF bf-defined IN FRAME frm-break
DO:                                                        
  DEF VAR lFileName AS CHAR NO-UNDO.

  RUN Chk_Run_Win.
  IF RETURN-VALUE = "CLOSE":U THEN RETURN.
                                            
  ASSIGN     
  lFileName = SUBSTRING(bf-defined:SCREEN-VALUE,1,
                        INDEX(bf-defined:SCREEN-VALUE," ") - 1).
                        
  FIND FIRST pp WHERE pp.cFileName = lFileName NO-ERROR.
  IF NOT AVAILABLE pp THEN RETURN.
  
  ASSIGN                                                               
    slct-objects:SCREEN-VALUE = "" 
    slct-objects:SCREEN-VALUE = lFileName 
    slct-methods:LIST-ITEMS   = pp.pHandle:INTERNAL-ENTRIES
    slct-methods:SCREEN-VALUE = "".
  IF pp.cMethod <> "NONE" THEN    
  DO:
    Run LoadMethods.
    
    IF pType = "Breaks" THEN
    DO:
      FIND FIRST pgm-bf WHERE pgm-bf.cFileName = lFileName
                    AND pgm-bf.cType = yes NO-ERROR.
      IF AVAILABLE pgm-bf THEN
        slct-methods:SCREEN-VALUE = pgm-bf.cMethod.   
      ELSE
        slct-methods:SCREEN-VALUE = "".
    END.
    ELSE
    DO:
      FIND FIRST pgm-bf WHERE pgm-bf.cFileName = lFileName
                      AND pgm-bf.cType = no NO-ERROR.
      IF AVAILABLE pgm-bf THEN
        slct-methods:SCREEN-VALUE = pgm-bf.cMethod.
      ELSE
        slct-methods:SCREEN-VALUE = "".
    END.
    
    ASSIGN btn-rmv:SENSITIVE = YES.
  END.
 
  RUN adecomm/_scroll.p (INPUT slct-objects:HANDLE,
                         INPUT slct-objects:SCREEN-VALUE).
  RUN adecomm/_scroll.p (INPUT slct-methods:HANDLE,
                         INPUT slct-methods:SCREEN-VALUE).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-Add
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-Add Window-1
ON CHOOSE OF btn-Add IN FRAME frm-break /* Add */
DO:
  RUN Chk_Run_Win.
  IF RETURN-VALUE = "CLOSE":U THEN RETURN.
  
  RUN Add-bf.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-close
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-close Window-1
ON CHOOSE OF btn-close IN FRAME frm-break /* Close */
DO:
    APPLY "WINDOW-CLOSE" TO {&WINDOW-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-help Window-1
ON CHOOSE OF btn-help IN FRAME frm-break /* Help */
OR HELP OF FRAME frm-break DO:

  IF pType = "Breaks" THEN
    RUN adecomm/_adehelp.p 
        ( INPUT "ptls", INPUT "CONTEXT" , INPUT {&PRO_Spy_Breakpoints}  , INPUT "" ).
  ELSE
    RUN adecomm/_adehelp.p 
        ( INPUT "ptls", INPUT "CONTEXT" , INPUT {&PRO_Spy_Filters}  , INPUT "" ).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-rmv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-rmv Window-1
ON CHOOSE OF btn-rmv IN FRAME frm-break /* Remove */
DO:
   
   DEFINE VAR tList   AS CHAR  NO-UNDO.
   DEFINE VAR temp    AS CHAR  NO-UNDO.
   DEFINE VAR tpgm    AS CHAR  NO-UNDO.
   DEFINE VAR tmethod AS CHAR  NO-UNDO.
   DEFINE VAR bflist  AS CHAR  NO-UNDO.
   
   RUN Chk_Run_Win.
   IF RETURN-VALUE = "CLOSE":U THEN RETURN.
      
   IF bf-defined:SCREEN-VALUE = "" OR
      bf-defined:SCREEN-VALUE = ? THEN DO:
       MESSAGE "No entry in the Defined list has been selected."
          VIEW-AS ALERT-BOX INFORMATION BUTTONS OK IN WINDOW WINDOW-1.
       RETURN.
   END.                                  
                                
   ASSIGN
     tList = bf-defined:SCREEN-VALUE
     slct-objects:SCREEN-VALUE = ?
     slct-objects:SCREEN-VALUE = ""
     slct-objects:SCREEN-VALUE = ?
     slct-methods:SCREEN-VALUE = "".

                                           
   DO cnt = 1 TO NUM-ENTRIES(tList):    
          
       ASSIGN
       temp = ENTRY(cnt,tList)
       tpgm = SUBSTR(temp,1,INDEX(temp," ") - 1)
       tmethod = TRIM(REPLACE(temp,tpgm," ")).             

       IF cnt < NUM-ENTRIES(tList) THEN
         tmethod = tmethod + ",".
                    
       IF pType = "Breaks" THEN    
         FIND pgm-bf WHERE pgm-bf.cFileName = tpgm
                       AND pgm-bf.cType = yes
                       NO-ERROR.
       ELSE
         FIND pgm-bf WHERE pgm-bf.cFileName = tpgm
                       AND pgm-bf.cType = no
                       NO-ERROR.         
                                                                
       ASSIGN
           pgm-bf.cMethod = REPLACE(pgm-bf.cMethod,tmethod,"")
           pgm-bf.cMethod = REPLACE(pgm-bf.cMethod,",,", ",").
       
       pgm-bf.cMethod = TRIM(pgm-bf.cMethod, ",").
                                                 
       IF pgm-bf.cMethod = "" THEN DELETE pgm-bf.
                         
       FIND def-bf WHERE def-bf.cFileName = tpgm
                  AND def-bf.cMethod   = tmethod
                  NO-ERROR.
       IF AVAILABLE def-bf THEN DELETE def-bf.

       IF AVAILABLE pgm-bf AND pgm-bf.cMethod <> "" THEN
         ASSIGN  
             bflist = pgm-bf.cMethod.
       ELSE
         ASSIGN 
             bflist = "".
       
   END.                      
   
   
   fOK   = bf-defined:DELETE(tList).   
   DISPLAY bf-defined WITH FRAME {&FRAME-NAME}.

   slct-objects:SCREEN-VALUE = ?.
   slct-objects:SCREEN-VALUE = pp.cFileName.
   
   slct-methods:SCREEN-VALUE = ?.
   slct-methods:SCREEN-VALUE = bflist.   
   
   IF bf-defined:LIST-ITEMS = ? THEN
   DO:
     FOR EACH def-bf:
       DELETE def-bf NO-ERROR.
     END.
    
     FOR EACH adm-methods-bf:
       DELETE adm-methods-bf NO-ERROR.
     END.     
   END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME slct-methods
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL slct-methods Window-1
ON MOUSE-SELECT-DBLCLICK OF slct-methods IN FRAME frm-break
DO:

  RUN Add-bf.
   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL slct-methods Window-1
ON VALUE-CHANGED OF slct-methods IN FRAME frm-break
DO:
   RUN Chk_Run_Win.
   IF RETURN-VALUE = "CLOSE":U THEN RETURN.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME slct-objects
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL slct-objects Window-1
ON VALUE-CHANGED OF slct-objects IN FRAME frm-break
DO:
  RUN Chk_Run_Win.
  IF RETURN-VALUE = "CLOSE":U THEN RETURN.
      
  IF NUM-ENTRIES(slct-objects:SCREEN-VALUE) > 1 THEN DO:
      slct-methods:LIST-ITEMS = "".
      bf-defined:LIST-ITEMS = "".
      RETURN.
  END.

  IF slct-objects:SCREEN-VALUE = "" THEN
    bf-defined:LIST-ITEMS = "".
  
  FIND FIRST pp WHERE pp.cFileName = slct-objects:SCREEN-VALUE 
      NO-ERROR.
  
  RUN LoadMethods.

  FOR EACH def-bf:
    DELETE def-bf.    
  END.

  IF pType = "Breaks" THEN
    FIND FIRST pgm-bf WHERE pgm-bf.cFileName = slct-objects:SCREEN-VALUE
                  AND pgm-bf.cType     = yes
                  AND pgm-bf.cMethod  <> "" NO-ERROR.
  ELSE
    FIND FIRST pgm-bf WHERE pgm-bf.cFileName = slct-objects:SCREEN-VALUE
                  AND pgm-bf.cType     = no 
                  AND pgm-bf.cMethod  <> "" NO-ERROR.
  
  IF AVAILABLE pgm-bf THEN 
  DO:
     ASSIGN
     slct-methods:SCREEN-VALUE = pgm-bf.cMethod.      

     IF pType = "Breaks" THEN
     DO:     
       FOR EACH pgm-bf WHERE pgm-bf.cFileName = slct-objects:SCREEN-VALUE
                             AND pgm-bf.cType = yes
                             AND pgm-bf.cMethod <> "" :
       
         bf-defined:LIST-ITEMS = "".
       
         DO cnt = 1 TO NUM-ENTRIES(pgm-bf.cMethod):
           CREATE def-bf.
           ASSIGN def-bf.cFileName = pgm-bf.cFileName
              def-bf.cMethod   = ENTRY(cnt,pgm-bf.cMethod)
              fOK = bf-defined:ADD-LAST(pgm-bf.cFileName + " " + ENTRY(cnt,pgm-bf.cMethod)).
         END.
       
       END. /* for each pgm-bf */    
     END.
     ELSE
     DO:
       FOR EACH pgm-bf WHERE pgm-bf.cFileName = slct-objects:SCREEN-VALUE
                             AND pgm-bf.cType = no
                             AND pgm-bf.cMethod <> "" :
       
         bf-defined:LIST-ITEMS = "".
       
         DO cnt = 1 TO NUM-ENTRIES(pgm-bf.cMethod):
           CREATE def-bf.
           ASSIGN def-bf.cFileName = pgm-bf.cFileName
              def-bf.cMethod   = ENTRY(cnt,pgm-bf.cMethod)
              fOK = bf-defined:ADD-LAST(pgm-bf.cFileName + " " + ENTRY(cnt,pgm-bf.cMethod)).
         END.
       
       END. /* for each pgm-bf */  
     END.       
  END.
  ELSE
      bf-defined:LIST-ITEMS = "".
  
  RUN adecomm/_scroll.p (INPUT slct-methods:HANDLE,
                         INPUT slct-methods:SCREEN-VALUE).
   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Window-1 


/* ***************************  Main Block  *************************** */

ASSIGN THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}
       {&WINDOW-NAME}:TITLE = "PRO*Spy - Setting " + pType
       def-label            = "Defined " + pType.
       
/* Parent to the main ProSpy window. */
ASSIGN {&WINDOW-NAME}:PARENT = ps_window.

/* Ensure that the window cannot be resized by the WINDOW-MAXIMIZED event. */
ASSIGN {&WINDOW-NAME}:MAX-WIDTH  = {&WINDOW-NAME}:WIDTH
       {&WINDOW-NAME}:MAX-HEIGHT = {&WINDOW-NAME}:HEIGHT .

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

&IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
fOK = {&WINDOW-NAME}:LOAD-ICON("adeicon/prospy.ico").
&ELSE
fOK = {&WINDOW-NAME}:LOAD-ICON("adeicon/prospy.xpm").
&ENDIF

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
   
   RUN Init_Window.
   RUN Move_To_Top (INPUT "_ENTRY":U).
       
   IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Add-bf Window-1 
PROCEDURE Add-bf :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEF VAR tItem                   AS INT  NO-UNDO.
  DEF VAR cnt1                    AS INT  NO-UNDO.
  DEF VAR cnt2                    AS INT  NO-UNDO.
  
  DEF VAR svalue                  AS CHAR NO-UNDO.
  DEF VAR pvalue                  AS CHAR NO-UNDO.  
      
  DEF VAR l-choice                AS LOG  NO-UNDO.
  DEF VAR fOK                     AS LOG  NO-UNDO.
  
  DEF VAR bfMethods               AS CHAR NO-UNDO.

                
  svalue = slct-objects:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
  pvalue = slct-methods:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

  if pvalue = "" OR pvalue = ? THEN
  DO:
    MESSAGE "No Methods/States have been selected."
            VIEW-AS ALERT-BOX INFORMATION BUTTONS OK IN WINDOW WINDOW-1.
    RETURN.
  END.

   
  RUN Chk-for-bf.
  pvalue = slct-methods:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
  IF pvalue = ""  OR pvalue = ? THEN RETURN.

  FIND FIRST pp WHERE pp.cFileName = svalue
    NO-ERROR.  

  IF pType = "Breaks" THEN
  DO:
    FIND FIRST pgm-bf WHERE pgm-bf.cFileName = pp.cFileName
                        AND pgm-bf.cType     = yes
                        AND pgm-bf.cMethod   = pvalue NO-ERROR.
  
    IF AVAILABLE pgm-bf THEN 
    DO:
      MESSAGE pgm-bf.cFileName + ":  " pgm-bf.cMethod SKIP
              "You have already defined this break."
              VIEW-AS ALERT-BOX INFORMATION BUTTONS OK IN WINDOW WINDOW-1.
      RETURN.         
    END.
  END.
  ELSE
    IF pType = "Filters" THEN
    DO:
      FIND FIRST pgm-bf WHERE pgm-bf.cFileName = pp.cFileName
                          AND pgm-bf.cType     = no
                          AND pgm-bf.cMethod   = pvalue NO-ERROR.

      IF AVAILABLE pgm-bf THEN 
      DO:
        MESSAGE pgm-bf.cFileName + ":  " pgm-bf.cMethod SKIP
                "You have already defined this filter."
                VIEW-AS ALERT-BOX INFORMATION BUTTONS OK IN WINDOW WINDOW-1.
        RETURN.
      END.
    END.
                              
  IF pType = "Breaks" THEN     
    FIND pgm-bf WHERE pgm-bf.cFileName = pp.cFileName 
                  AND pgm-bf.cType     = yes NO-ERROR.   
  ELSE
    FIND pgm-bf WHERE pgm-bf.cFileName = pp.cFileName 
                  AND pgm-bf.cType     = no NO-ERROR.   

  IF AVAILABLE pgm-bf THEN
    ASSIGN                                  
      bfMethods = pgm-bf.cMethod.
  ELSE
    ASSIGN
      bfMethods = "".

  IF NUM-ENTRIES(slct-methods:SCREEN-VALUE IN FRAME {&FRAME-NAME}) = 1 AND
     NOT CAN-DO(pp.cMethod,slct-methods:SCREEN-VALUE IN FRAME {&FRAME-NAME}) THEN
    bfMethods = 
                 (IF bfMethods = "" OR bfMethods = "NONE" THEN 
                  slct-methods:SCREEN-VALUE IN FRAME {&FRAME-NAME}
  ELSE bfMethods + "," + slct-methods:SCREEN-VALUE IN FRAME {&FRAME-NAME}).
    ELSE 
      DO cnt = 1 TO NUM-ENTRIES(slct-methods:SCREEN-VALUE IN FRAME {&FRAME-NAME}):
        IF NOT CAN-DO(ENTRY(cnt, slct-methods:SCREEN-VALUE),bfMethods) THEN
        bfMethods = 
                     IF bfMethods = "" OR bfMethods = "NONE" THEN 
                       ENTRY(cnt, slct-methods:SCREEN-VALUE IN FRAME {&FRAME-NAME})
                     ELSE bfMethods + "," + ENTRY(cnt, slct-methods:SCREEN-VALUE IN FRAME {&FRAME-NAME}).
      END.
              
  IF bfMethods = "" OR bfMethods = ? THEN bfMethods = "NONE". 

  IF pType = "Breaks" THEN    
    IF NOT AVAILABLE pgm-bf THEN 
    DO:
      CREATE pgm-bf.
      ASSIGN pgm-bf.cFileName = pp.cFileName
             pgm-bf.cType     = yes
             pgm-bf.cMethod   = bfMethods.
    END.   
    ELSE                    
      ASSIGN                                  
             pgm-bf.cMethod = bfMethods.
      ELSE
        IF NOT AVAILABLE pgm-bf THEN 
        DO:
          CREATE pgm-bf.
          ASSIGN pgm-bf.cFileName = pp.cFileName
                 pgm-bf.cType     = no
                 pgm-bf.cMethod   = bfMethods.
        END.   
        ELSE                    
          ASSIGN                                  
                 pgm-bf.cMethod = bfMethods.     

  FOR EACH def-bf:
    DELETE def-bf.
  END.
     
  DO cnt = 1 TO NUM-ENTRIES(pgm-bf.cMethod):
    FIND def-bf WHERE def-bf.cFileName = pgm-bf.cFileName 
                  AND def-bf.cMethod   = ENTRY(cnt,pgm-bf.cMethod) NO-ERROR. 
                   
    IF NOT AVAILABLE def-bf THEN 
    DO:
      CREATE def-bf.
      ASSIGN def-bf.cFileName = pgm-bf.cFileName
             def-bf.cMethod   = ENTRY(cnt,pgm-bf.cMethod).
    END.
  END.    

              
  bf-defined:LIST-ITEMS = "".
   
  FOR EACH def-bf:
     fOK = bf-defined:ADD-LAST(def-bf.cFileName + " " + def-bf.cMethod).
  END.

  btn-rmv:SENSITIVE IN FRAME {&FRAME-NAME} = yes.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Chk-for-bf Window-1 
PROCEDURE Chk-for-bf :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/ 

  DEF VAR cnt1                    AS INT  NO-UNDO.
  DEF VAR cnt2                    AS INT  NO-UNDO.
  
  DEF VAR svalue                  AS CHAR NO-UNDO.
  DEF VAR pvalue                  AS CHAR NO-UNDO.  
  DEF VAR stored-method-state     AS CHAR NO-UNDO.
  DEF VAR new-method-state        AS CHAR NO-UNDO.
  DEF VAR method-state            AS CHAR NO-UNDO.
  DEF VAR rmv-method-state        AS CHAR NO-UNDO.
  DEF VAR old-method-state        AS CHAR NO-UNDO.
  DEF VAR common-method-state     AS CHAR NO-UNDO.
  DEF VAR rmv-break-list          AS CHAR NO-UNDO.
  DEF VAR rmv-filter-list         AS CHAR NO-UNDO.
  DEF VAR rmv-break-selection     AS CHAR NO-UNDO.
  DEF VAR rmv-filter-selection    AS CHAR NO-UNDO.
      
  DEF VAR l-choice                AS LOG  NO-UNDO.

  DEF VAR position                AS INT  NO-UNDO.  
  DEF VAR startposition           AS INT  NO-UNDO.
  
  ASSIGN
    rmv-break-list       = ""
    rmv-filter-list      = ""
    rmv-break-selection  = ""
    rmv-filter-selection = "".
    
                
  svalue = slct-objects:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
  pvalue = slct-methods:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
  
  
  FIND FIRST pp WHERE pp.cFileName = svalue NO-ERROR.

  /* Generate a list of methods/states that are common between */
  /* what have already been created and what are attempted to  */
  /* be created now.                                           */ 
   
  IF AVAILABLE pp THEN
  DO:
    IF pType = "Filters" THEN 
      FIND FIRST pgm-bf WHERE pgm-bf.cFileName = pp.cFileName
                          AND pgm-bf.cType     = yes NO-ERROR.
    ELSE IF pType = "Breaks" THEN
      FIND FIRST pgm-bf WHERE pgm-bf.cFileName = pp.cFileName
                          AND pgm-bf.cType     = no NO-ERROR.
                          
    IF AVAILABLE pgm-bf THEN
    DO:
      DO cnt1 = 1 TO NUM-ENTRIES(pgm-bf.cMethod):
        stored-method-state = ENTRY(cnt1, pgm-bf.cMethod).
          
        DO cnt2 = 1 TO NUM-ENTRIES(pvalue):
          new-method-state = ENTRY(cnt2, pvalue).
            
          IF new-method-state = stored-method-state THEN
            IF common-method-state = "" THEN
              common-method-state = new-method-state.
            ELSE IF common-method-state <> "" THEN
              common-method-state = common-method-state + "," + new-method-state.
        END.  
        
      END. 
      
    END.
    ELSE IF NOT AVAILABLE pgm-bf THEN 
      RETURN.
      
  END.
  ELSE IF NOT AVAILABLE pp THEN
    RETURN.


  /* Based on the list of common methods/states that is being attempted to  */
  /* create -- go through and inform the user                               */
    
  DO cnt1 = 1 TO NUM-ENTRIES(common-method-state):
    method-state = ENTRY(cnt1, common-method-state).

    IF pType = "Filters" THEN
    DO:    
      MESSAGE "A Break has already been set on:  " method-state + "." SKIP(1)
              " Would you like to remove the Break?" 
              VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
              UPDATE l-choice IN WINDOW WINDOW-1.
            
      IF l-choice EQ TRUE THEN
      DO:
        IF rmv-break-list = "" THEN
          rmv-break-list = method-state.
        ELSE IF rmv-break-list <> "" THEN
          rmv-break-list = rmv-break-list + "," + method-state.
      END.      
      ELSE IF l-choice EQ FALSE THEN
      DO:
        IF rmv-filter-selection = "" THEN
          rmv-filter-selection = method-state.
        ELSE IF rmv-filter-selection <> "" THEN
          rmv-filter-selection = rmv-filter-selection + "," + method-state.
      END.
      
    END.
    
    ELSE IF pType = "Breaks" THEN
    DO:
      MESSAGE "A Filter has already been set on:  " method-state + "." SKIP(1)
              "Would you like to remove the Filter?"
              VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
              UPDATE l-choice IN WINDOW WINDOW-1.
              
      IF l-choice EQ TRUE THEN
      DO: 
        IF rmv-filter-list = "" THEN
          rmv-filter-list = method-state.
        ELSE IF rmv-filter-list <> "" THEN
          rmv-filter-list = rmv-filter-list + "," + method-state.
      END.      
      ELSE IF l-choice EQ FALSE THEN
      DO:
        IF rmv-break-selection = "" THEN
          rmv-break-selection = method-state.
        ELSE IF rmv-break-selection <> "" THEN
          rmv-break-selection = rmv-break-selection + "," + method-state.
      END.
      
    END.
  END.

  
  /* Update temp-tables now that remove break/filter lists have been updated. */
  
  FIND FIRST pp WHERE pp.cFileName = svalue NO-ERROR.
  
  IF AVAILABLE pp THEN
  DO:
  
    IF pType = "Filters" THEN
    DO:         
      IF rmv-break-list <> "" THEN
      DO:
        FIND FIRST pgm-bf WHERE pgm-bf.cFileName = pp.cFileName 
                            AND pgm-bf.cType     = yes NO-ERROR.
        
        IF AVAILABLE pgm-bf THEN
        DO:        
          DO cnt1 = 1 TO NUM-ENTRIES(rmv-break-list):
            rmv-method-state = ENTRY(cnt1, rmv-break-list).
            
            position = LOOKUP(rmv-method-state, pgm-bf.cMethod).
            
            IF position <> 0 THEN
            DO:
              old-method-state = ENTRY(position, pgm-bf.cMethod).
                
              IF old-method-state = rmv-method-state THEN
              DO:
                IF position = 1 AND NUM-ENTRIES(pgm-bf.cMethod) > 1 THEN
                DO:
                  startposition = INDEX(pgm-bf.cMethod, ",", 1).
                  pgm-bf.cMethod = SUBSTRING(pgm-bf.cMethod, startposition + 1).
                END.
                ELSE
                  IF position = NUM-ENTRIES(pgm-bf.cMethod) AND NUM-ENTRIES(pgm-bf.cMethod) > 1 THEN
                  DO:
                    startposition = R-INDEX(pgm-bf.cMethod, ",", LENGTH(pgm-bf.cMethod)).  
                    pgm-bf.cMethod = SUBSTRING(pgm-bf.cMethod, 1, startposition - 1).
                  END.
                  ELSE
                    ENTRY(position, pgm-bf.cMethod) = "".
                      
                pgm-bf.cMethod = REPLACE(pgm-bf.cMethod, ",,", ",").

              END.
            END.
          END.
        END.  
        
        
        DO cnt1 = 1 TO NUM-ENTRIES(rmv-break-list):
          rmv-method-state = ENTRY(cnt1, rmv-break-list).
          
          FIND FIRST def-bf WHERE def-bf.cFileName = pp.cFileName
                              AND def-bf.cMethod   = rmv-method-state NO-ERROR.
                              
          IF AVAILABLE def-bf THEN DELETE def-bf.
        END.
        
        IF pgm-bf.cMethod = "" THEN DELETE pgm-bf.
        
      END.
    END.    
    ELSE IF pType = "Breaks" THEN
    DO:     
      IF rmv-filter-list <> "" THEN
      DO:
        FIND FIRST pgm-bf WHERE pgm-bf.cFileName = pp.cFileName 
                            AND pgm-bf.cType     = no NO-ERROR.
        
        IF AVAILABLE pgm-bf THEN
        DO:
          DO cnt1 = 1 TO NUM-ENTRIES(rmv-filter-list):
            rmv-method-state = ENTRY(cnt1, rmv-filter-list).

            position = LOOKUP(rmv-method-state, pgm-bf.cMethod).
            
            IF position <> 0 THEN
            DO:
              old-method-state = ENTRY(position, pgm-bf.cMethod).
                
              IF old-method-state = rmv-method-state THEN
              DO:
                IF position = 1 AND NUM-ENTRIES(pgm-bf.cMethod) > 1 THEN
                DO:
                  startposition = INDEX(pgm-bf.cMethod, ",", 1).
                  pgm-bf.cMethod = SUBSTRING(pgm-bf.cMethod, startposition + 1).
                END.
                ELSE
                  IF position = NUM-ENTRIES(pgm-bf.cMethod) AND NUM-ENTRIES(pgm-bf.cMethod) > 1 THEN
                  DO:
                    startposition = R-INDEX(pgm-bf.cMethod, ",", LENGTH(pgm-bf.cMethod)).  
                    pgm-bf.cMethod = SUBSTRING(pgm-bf.cMethod, 1, startposition - 1).
                  END.
                  ELSE
                    ENTRY(position, pgm-bf.cMethod) = "".
                      
                pgm-bf.cMethod = REPLACE(pgm-bf.cMethod, ",,", ",").
              END.                   
            END.
          END.
        END.
        
        DO cnt1 = 1 TO NUM-ENTRIES(rmv-filter-list):
          rmv-method-state = ENTRY(cnt1, rmv-filter-list).
          
          FIND FIRST def-bf WHERE def-bf.cFileName = pp.cFileName
                              AND def-bf.cMethod   = rmv-method-state NO-ERROR.
                              
          IF AVAILABLE def-bf THEN DELETE def-bf.
        END.
        
        IF pgm-bf.cMethod = "" THEN DELETE pgm-bf.
        
      END.
    END.
  END.    
  
    
  /* Update screen-value of slct-methods selection-list box based on remove break/filter */
  /* selection lists                                                                     */

  IF pType = "Filters" AND rmv-filter-selection <> "" THEN
  DO:
    ASSIGN
      slct-methods:SCREEN-VALUE = ?                       
      slct-methods:SCREEN-VALUE = rmv-break-list.       
  END.          
  ELSE IF pType = "Breaks" AND rmv-break-selection <> "" THEN
  DO:                
    ASSIGN 
      slct-methods:SCREEN-VALUE = ?
      slct-methods:SCREEN-VALUE = rmv-filter-list.    
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Chk_Run_Win Window-1 
PROCEDURE Chk_Run_Win :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


IF NOT VALID-HANDLE(app_handle) THEN
DO ON STOP UNDO, RETRY:

  IF NOT RETRY THEN
  MESSAGE "Run window has been shut down."  SKIP(1)
          "Closing " + pType + " Window."          
          VIEW-AS ALERT-BOX INFORMATION BUTTONS OK IN WINDOW WINDOW-1.
    
  RUN Reset_Lists.
  APPLY "WINDOW-CLOSE" TO {&WINDOW-NAME}.
  RETURN "CLOSE":U.
  
END.                           

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI Window-1  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(Window-1)
  THEN DELETE WIDGET Window-1.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI Window-1  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  DISPLAY slct-objects slct-methods bf-defined def-label 
      WITH FRAME frm-break IN WINDOW Window-1.
  ENABLE btn-close slct-objects slct-methods btn-help bf-defined 
      WITH FRAME frm-break IN WINDOW Window-1.
  {&OPEN-BROWSERS-IN-QUERY-frm-break}
  VIEW Window-1.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Init_Window Window-1 
PROCEDURE Init_Window :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO WITH FRAME {&FRAME-NAME}:  

  /* Case 1: Setup for a new running application. */
  IF VALID-HANDLE(app_handle) AND (h_app <> app_handle) THEN
  DO:
    RUN Reset_Lists.
    ASSIGN h_app = app_handle.
  END.
  /* Case 2: Same running app, just bring the window forward. */
  ELSE
  IF VALID-HANDLE(app_handle) AND (h_app = app_handle) THEN
  DO:
    RUN Move_To_Top (INPUT "_ENTRY":U).
    RETURN.
  END.
  /* Case 3: No app running, clear window and bring forward. */
  ELSE
  DO:
    RUN Reset_Lists.
    RUN enable_UI.
    RUN Move_To_Top (INPUT "_ENTRY":U).
    RETURN.
  END.
  
  IF pType = "Breaks" THEN
    FOR EACH pgm-bf WHERE pgm-bf.cType = yes:
       DO cnt = 1 TO NUM-ENTRIES(pgm-bf.cMethod):
         CREATE def-bf.
         ASSIGN def-bf.cFileName = pgm-bf.cFileName
                def-bf.cMethod   = ENTRY(cnt,pgm-bf.cMethod)
                fOK = bf-defined:ADD-LAST(pgm-bf.cFileName + " " + 
                                          ENTRY(cnt,pgm-bf.cMethod)).
       END.
    END. /* for each pgm-bf */    
  ELSE
    FOR EACH pgm-bf WHERE pgm-bf.cType = no:
       DO cnt = 1 TO NUM-ENTRIES(pgm-bf.cMethod):
         CREATE def-bf.
         ASSIGN def-bf.cFileName = pgm-bf.cFileName
                def-bf.cMethod   = ENTRY(cnt,pgm-bf.cMethod)
                fOK = bf-defined:ADD-LAST(pgm-bf.cFileName + " " + 
                                          ENTRY(cnt,pgm-bf.cMethod)).
       END.
    END. /* for each pgm-bf */ 
  
  RUN LoadLists.
     
  RUN enable_UI.
  ASSIGN btn-rmv:SENSITIVE = (bf-defined:NUM-ITEMS <> 0).
  ASSIGN btn-Add:SENSITIVE = (slct-objects:NUM-ITEMS <> 0).
  
END. /* DO WITH FRAME */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE LoadLists Window-1 
PROCEDURE LoadLists :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VAR thandle AS HANDLE     NO-UNDO.
  
  thandle = app_handle.
  
  DO WHILE VALID-HANDLE(thandle): 
   
    IF INDEX(thandle:FILE-NAME,"adecomm") = 0 AND
       INDEX(thandle:FILE-NAME,"protools") = 0 AND
       INDEX(thandle:FILE-NAME,"adeshar") = 0 THEN DO:
        CREATE pp.
        ASSIGN pp.pHANDLE   = thandle
               pp.cFileName = thandle:FILE-NAME
               fOK          = slct-objects:ADD-LAST(pp.cFileName) 
                              IN FRAME frm-break.
    END.
    ASSIGN thandle      = thandle:NEXT-SIBLING.         
  END.
  
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE LoadMethods Window-1 
PROCEDURE LoadMethods :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
  DEFINE VAR icount AS INTEGER.
  DEFINE VAR numofmethods AS INTEGER.  
  DEFINE VAR lstatus AS LOGICAL.   
  DEFINE VAR pcmethods AS CHARACTER.

  FIND FIRST pp WHERE pp.cFileName = slct-objects:SCREEN-VALUE IN FRAME frm-break NO-ERROR.
    
  ASSIGN 
     numofmethods = NUM-ENTRIES(pp.phandle:INTERNAL-ENTRIES)
     pcmethods = pp.phandle:INTERNAL-ENTRIES.

  slct-methods:LIST-ITEMS IN FRAME frm-break = "".
    
  DO icount=1 TO numofmethods:
    CREATE adm-methods-bf.
    adm-methods-bf.slctmethod = ENTRY(icount, pcmethods).
  END.
  
  FOR EACH adm-methods-bf:
    lstatus = slct-methods:ADD-LAST(adm-methods-bf.slctmethod) IN FRAME frm-break.
  END.

  FOR EACH adm-methods-bf:
    DELETE adm-methods-bf NO-ERROR.
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Move_To_Top Window-1 
PROCEDURE Move_To_Top :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p_Flags AS CHARACTER NO-UNDO.
  
  ASSIGN fOK = {&window-name}:MOVE-TO-TOP().
  ASSIGN {&window-name}:WINDOW-STATE = WINDOW-NORMAL.
  
  IF CAN-DO(p_Flags, "_ENTRY":U) THEN
    APPLY "ENTRY":U TO btn-help IN FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Reset_Lists Window-1 
PROCEDURE Reset_Lists :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DO WITH FRAME {&FRAME-NAME}:  
    FOR EACH pgm-bf:
      DELETE pgm-bf NO-ERROR.
    END.
    
    FOR EACH pp:
      DELETE pp NO-ERROR.
    END.
      
    FOR EACH def-bf:
      DELETE def-bf NO-ERROR.
    END.
      
    FOR EACH adm-methods-bf:
      DELETE adm-methods-bf NO-ERROR.
    END.

    ASSIGN slct-objects:LIST-ITEMS = ""
           slct-methods:LIST-ITEMS = ""
           bf-defined:LIST-ITEMS   = ""
           btn-rmv:SENSITIVE = NO
           btn-add:SENSITIVE = NO.
           
    DISPLAY {&DISPLAYED-OBJECTS} WITH FRAME {&FRAME-NAME} NO-ERROR.

    ASSIGN h_app = ?.
           
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

