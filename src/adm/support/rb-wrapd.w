&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME dlg-frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS dlg-frame 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: rb-wrapd.w

  Description: an Instance Editor dialog box for the RB-WRAP (Report Builder
               Wrapper) SmartObject. It also gets called at run-time and
               automatically disables options the end-user should not control.

  Input Parameters:
      ph_SMO - the SmartObject handle that called this routine (ie. RB-WRAP)

  Output Parameters:
      <none>

  Author:   Rick Kuzyk
  Editor:   Wm.T.Wood
  Created:  February 1996

  Modifed by gfs 11/15/96 Modified screen layout to accomdate Win95 font
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

&GLOBAL-DEFINE WIN95-BTN YES
&IF DEFINED(UIB_is_Running) NE 0 &THEN

/* Local Variable Definitions ---       */

  DEFINE VARIABLE ph_SMO AS HANDLE.

&ELSE

    DEFINE INPUT PARAMETER ph_SMO    AS HANDLE NO-UNDO.

&ENDIF

/* Local Variable Definitions ---                                       */

def var cPrinter   as char    no-undo.
def var iCopies    as integer no-undo.
def var iBegPage   as integer no-undo.
def var iEndPage   as integer no-undo.
def var lDispError as logical no-undo.
def var lStatus    as logical no-undo.
def var lprinter   as logical no-undo.
def var cInclude   as char    no-undo.
def var cConnect   as char    no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME dlg-frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS B-Library R-Library R-Report RS-Printer ~
F-NumberCopies R-PageBeg R-PageEnd B-Output t-printer R-OutputFile ~
R-Include E-Filter T-Batch T-Status R-Database R-Host Btn-Accept F-User ~
R-Server btn-close F-Password R-Network 
&Scoped-Define DISPLAYED-OBJECTS R-Library R-Report RS-Printer ~
F-NumberCopies R-PageBeg R-PageEnd t-printer R-OutputFile R-Include ~
E-Filter T-Batch T-Status R-Database R-Host F-User R-Server F-Password ~
R-Network 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON B-Library 
     LABEL "Files ...":L 
     SIZE 15 BY 1.12.

DEFINE BUTTON B-Output 
     LABEL "Files ...":L 
     SIZE 15 BY 1.12.

DEFINE BUTTON Btn-Accept 
     LABEL "&Accept":L 
     SIZE 14.2 BY 1.12.

DEFINE BUTTON btn-close AUTO-END-KEY 
     LABEL "&Close":L 
     SIZE 14.2 BY 1.12.

DEFINE VARIABLE R-Report AS CHARACTER FORMAT "X(256)":U 
     LABEL "Available &Reports" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "","" 
     SIZE 61 BY 1.

DEFINE VARIABLE E-Filter AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
     SIZE 51 BY 2.43.

DEFINE VARIABLE F-NumberCopies AS INTEGER FORMAT "->>,>>9":U INITIAL 0 
     LABEL "Number of Copies" 
     VIEW-AS FILL-IN 
     SIZE 6 BY 1.

DEFINE VARIABLE F-Password AS CHARACTER FORMAT "X(256)":U 
     LABEL "&Password" 
     VIEW-AS FILL-IN 
     SIZE 15 BY 1.

DEFINE VARIABLE F-User AS CHARACTER FORMAT "X(256)":U 
     LABEL "&User Name" 
     VIEW-AS FILL-IN 
     SIZE 15 BY 1.

DEFINE VARIABLE R-Database AS CHARACTER FORMAT "X(256)":U 
     LABEL "&Database Name" 
     VIEW-AS FILL-IN 
     SIZE 25.8 BY 1.

DEFINE VARIABLE R-Host AS CHARACTER FORMAT "X(256)":U 
     LABEL "&Host" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1.

DEFINE VARIABLE R-Library AS CHARACTER FORMAT "X(256)":U 
     LABEL "&Library Name" 
     VIEW-AS FILL-IN 
     SIZE 46 BY 1.

DEFINE VARIABLE R-Network AS CHARACTER FORMAT "X(256)":U 
     LABEL "&Network Type" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1.

DEFINE VARIABLE R-OutputFile AS CHARACTER FORMAT "X(256)":U 
     LABEL "Output File" 
     VIEW-AS FILL-IN 
     SIZE 39 BY 1.

DEFINE VARIABLE R-PageBeg AS INTEGER FORMAT "->>,>>9":U INITIAL 0 
     LABEL "Page From" 
     VIEW-AS FILL-IN 
     SIZE 6 BY 1.

DEFINE VARIABLE R-PageEnd AS INTEGER FORMAT "->>,>>9":U INITIAL 0 
     LABEL "Page To" 
     VIEW-AS FILL-IN 
     SIZE 6 BY 1.

DEFINE VARIABLE R-Server AS CHARACTER FORMAT "X(256)":U 
     LABEL "&Server" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1.

DEFINE VARIABLE R-Include AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Use Saved Filter", 1,
"Override Saved Filter", 2,
"Include All Records", 3,
"Prompt by Runtime", 4
     SIZE 25 BY 3.14.

DEFINE VARIABLE RS-Printer AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Screen", 1,
"Printer", 2,
"File", 3
     SIZE 11 BY 2.19.

DEFINE VARIABLE T-Batch AS LOGICAL INITIAL no 
     LABEL "Display Errors On Screen":L 
     VIEW-AS TOGGLE-BOX
     SIZE 29 BY .76.

DEFINE VARIABLE t-printer AS LOGICAL INITIAL no 
     LABEL "Prompt for Printer at Run-time" 
     VIEW-AS TOGGLE-BOX
     SIZE 32 BY 1.05 NO-UNDO.

DEFINE VARIABLE T-Status AS LOGICAL INITIAL no 
     LABEL "Display Print Status Dialog":L 
     VIEW-AS TOGGLE-BOX
     SIZE 28.6 BY .76.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME dlg-frame
     B-Library AT ROW 1.24 COL 66
     R-Library AT ROW 1.29 COL 18 COLON-ALIGNED
     R-Report AT ROW 2.33 COL 18 COLON-ALIGNED
     RS-Printer AT ROW 4.52 COL 2 NO-LABEL
     F-NumberCopies AT ROW 4.52 COL 16.2
     R-PageBeg AT ROW 4.52 COL 43.8
     R-PageEnd AT ROW 4.52 COL 63.2
     B-Output AT ROW 5.76 COL 66
     t-printer AT ROW 5.86 COL 27
     R-OutputFile AT ROW 5.86 COL 15.8
     R-Include AT ROW 8 COL 2 NO-LABEL
     E-Filter AT ROW 8.52 COL 28 NO-LABEL
     T-Batch AT ROW 12.33 COL 9
     T-Status AT ROW 12.33 COL 40
     R-Database AT ROW 14.19 COL 16 COLON-ALIGNED
     R-Host AT ROW 14.19 COL 50 COLON-ALIGNED
     Btn-Accept AT ROW 14.71 COL 68
     F-User AT ROW 15.29 COL 16 COLON-ALIGNED
     R-Server AT ROW 15.29 COL 50 COLON-ALIGNED
     btn-close AT ROW 16.1 COL 68
     F-Password AT ROW 16.33 COL 16 COLON-ALIGNED
     R-Network AT ROW 16.33 COL 50 COLON-ALIGNED
     " Default Print Options" VIEW-AS TEXT
          SIZE 81 BY .67 AT ROW 3.62 COL 2
          BGCOLOR 1 FGCOLOR 15 
     " Report Options" VIEW-AS TEXT
          SIZE 81 BY .67 AT ROW 7.1 COL 2
          BGCOLOR 1 FGCOLOR 15 
     "&Filter:" VIEW-AS TEXT
          SIZE 6 BY .81 AT ROW 7.71 COL 28
     " Runtime Status Options" VIEW-AS TEXT
          SIZE 81.2 BY .67 AT ROW 11.48 COL 1.8
          BGCOLOR 1 FGCOLOR 15 
     " Database Connection Options" VIEW-AS TEXT
          SIZE 80.2 BY .67 AT ROW 13.38 COL 2
          BGCOLOR 1 FGCOLOR 15 
     SPACE(0.79) SKIP(3.46)
    WITH VIEW-AS DIALOG-BOX 
         SIDE-LABELS THREE-D  SCROLLABLE 
         TITLE "Report Builder Instance Editor":L
         CANCEL-BUTTON btn-close.

 

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX dlg-frame
   UNDERLINE Default                                                    */
ASSIGN 
       FRAME dlg-frame:SCROLLABLE       = FALSE.

/* SETTINGS FOR FILL-IN F-NumberCopies IN FRAME dlg-frame
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN R-OutputFile IN FRAME dlg-frame
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN R-PageBeg IN FRAME dlg-frame
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN R-PageEnd IN FRAME dlg-frame
   ALIGN-L                                                              */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME dlg-frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL dlg-frame dlg-frame
ON ALT-F OF FRAME dlg-frame /* Report Builder Instance Editor */
anywhere
DO:
  APPLY "ENTRY" TO E-Filter IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL dlg-frame dlg-frame
ON WINDOW-CLOSE OF FRAME dlg-frame /* Report Builder Instance Editor */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-Library
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-Library dlg-frame
ON CHOOSE OF B-Library IN FRAME dlg-frame /* Files ... */
DO:
def var name    as char    no-undo.
def var bPicked as logical no-undo.

  system-dialog get-file
      name
      filters           "*.prl" "*.prl"  /* Filter                */
      default-extension "*.prl"        /* default-extensions     */
      title             "Report Library"
      must-exist
      update bPicked.

  if bPicked then
    R-library:screen-value = name.  
      
      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-Output
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-Output dlg-frame
ON CHOOSE OF B-Output IN FRAME dlg-frame /* Files ... */
DO:
def var name    as char    no-undo.
def var bPicked as logical no-undo.

  system-dialog get-file
      name
      filters           "*.*" "*.*"  /* Filter                */
      default-extension "*.*"        /* default-extensions     */
      title             "Report Output"
      must-exist
      update bPicked.

  if bPicked then
    R-OutputFile:screen-value = name.  
      

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-Accept
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-Accept dlg-frame
ON CHOOSE OF Btn-Accept IN FRAME dlg-frame /* Accept */
DO:

assign
  cPrinter   = if (RS-Printer:screen-value = "1") then "D"
               else if (RS-Printer:screen-value = "2") then " " else "A"
  lDispError = if (T-Batch:screen-value = "yes") then TRUE else FALSE
  lStatus    = if (T-Status:screen-value = "yes") then TRUE else FALSE .
  lPrinter   = if (T-printer:screen-value = "yes") then TRUE else FALSE .
  cInclude   = if      (R-Include:screen-value = "1") then "S" 
               else if (R-Include:screen-value = "2") then "O" 
               else if (R-Include:screen-value = "3") then "E" 
               else "?".


  cConnect = "".
  if R-Database:screen-value > "" then do:
      cConnect = "-db " + R-Database:screen-value.
         
      if (R-Host:screen-value > "") then
        cConnect = cConnect + " -H " + R-Host:screen-value.

      if (R-Server:screen-value > "") then
        cConnect = cConnect + " -S " + R-Server:screen-value.
        
      if (R-Network:screen-value > "") then
        cConnect = cConnect + " -N " + R-Network:screen-value.

      if (F-User:screen-value > "") then
        cConnect = cConnect + " -U " + F-User:screen-value.
    
      if (F-Password:screen-value > "") then
        cConnect = cConnect + " -P " + F-Password:screen-value.

   end.

  def var cName  as char    no-undo.
  def var iCount as integer no-undo.
  run aderb/_getname.p (R-Library:screen-value, output cName, output iCount).
  if iCount eq 0 then do:
    message "Report Library chosen has no reports. Please try again." 
        view-as alert-box error.
    end.
   
  /* Set the values in the object. NOTE: this will not, 
     by default cause the object to rebuild itself. */
     
  RUN set-attribute-list IN ph_SMO ('Report-Library = ' + r-library:SCREEN-VALUE +  
                                    ',Printer = ' + cprinter + 
                                    ',Include = ' + cInclude +
                                    ',Filter =  ' + E-Filter:screen-value +
                                    ',Copies = ' + F-NumberCopies:screen-value + 
                                    ',BegPage = ' + R-PageBeg:screen-value + 
                                    ',EndPage = ' + R-PageEnd:screen-value + 
                                    ',Display-Errors = ' + T-Batch:screen-value + 
                                    ',Display-Status = ' + T-Status:screen-value + 
                                    ',Database = ' + R-Database:screen-value + 
                                    ',Host = ' + R-Host:screen-value + 
                                    ',Server = ' + R-Server:screen-value  + 
                                    ',Network = ' + R-Network:screen-value  + 
                                    ',User = ' + F-User:screen-value + 
                                    ',Password = ' + F-Password:screen-value + 
                                    ',Connect = ' + cConnect + 
                                    ',Printer-prompt = ' + T-Printer:screen-value +
                                    ',OutputFile = ' + R-OutputFile:screen-value).
 

  /* Reinitialize the object - this will rebuild it based
     on the new attribute values. */
         
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME R-Include
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL R-Include dlg-frame
ON VALUE-CHANGED OF R-Include IN FRAME dlg-frame
DO:
  E-Filter:sensitive = (r-include:screen-value = "2").
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME R-Library
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL R-Library dlg-frame
ON LEAVE OF R-Library IN FRAME dlg-frame /* Library Name */
DO:
  run fill-report-list.
/*
  def var cName  as char    no-undo.
  def var iCount as integer no-undo.
  
  run aderb/_getname.p (R-Library:screen-value, output cName, output iCount).
  
  assign
    R-Report:sensitive    = yes
    R-Report:list-items   = cName
    R-Report:screen-value = ENTRY (1,cName)
  .
*/  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME R-Report
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL R-Report dlg-frame
ON ENTRY OF R-Report IN FRAME dlg-frame /* Available Reports */
DO:
  run fill-report-list.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RS-Printer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RS-Printer dlg-frame
ON VALUE-CHANGED OF RS-Printer IN FRAME dlg-frame
DO:
  if RS-Printer:screen-value = '1' then  /* output to screen */
    assign
      F-NumberCopies:sensitive = FALSE
      R-PageBeg:sensitive    = TRUE
      R-PageEnd:sensitive    = TRUE
      R-OutputFile:visible   = FALSE
      B-Output:visible       = FALSE
      t-Printer:visible      = FALSE
      .
  else if RS-Printer:screen-value = '2' then /* Output to Printer */
    assign
      F-NumberCopies:sensitive = TRUE
      R-PageBeg:sensitive      = TRUE
      R-PageEnd:sensitive      = TRUE
      R-OutputFile:visible   = FALSE
      B-Output:visible       = FALSE
      t-printer:visible      = TRUE
      .
   else                                      /* Output to File */
   assign
      F-NumberCopies:sensitive = FALSE
      R-PageBeg:sensitive    = FALSE
      R-PageEnd:sensitive    = FALSE   
      R-PageEnd:screen-value = "0"
      R-PageBeg:screen-value = "0"
      R-OutputFile:visible   = TRUE
      B-Output:visible       = TRUE
      t-printer:visible      = FALSE
      .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK dlg-frame 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent    */
IF VALID-HANDLE(ACTIVE-WINDOW)AND FRAME {&FRAME-NAME}:PARENT eq ?
  THEN  FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

  RUN enable_UI.   
  
  RUN load-screen.
 
  RUN get-attribute in ph_SMO ('UIB-Mode').
  IF return-value eq ? THEN
    DISABLE b-library R-Library F-Password F-User R-Database R-Host R-Network R-Report R-Server WITH FRAME {&FRAME-NAME}.
 
  WAIT-FOR ENDKEY OF FRAME {&FRAME-NAME}.

END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI dlg-frame _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME dlg-frame.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI dlg-frame _DEFAULT-ENABLE
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
  DISPLAY R-Library R-Report RS-Printer F-NumberCopies R-PageBeg R-PageEnd 
          t-printer R-OutputFile R-Include E-Filter T-Batch T-Status R-Database 
          R-Host F-User R-Server F-Password R-Network 
      WITH FRAME dlg-frame.
  ENABLE B-Library R-Library R-Report RS-Printer F-NumberCopies R-PageBeg 
         R-PageEnd B-Output t-printer R-OutputFile R-Include E-Filter T-Batch 
         T-Status R-Database R-Host Btn-Accept F-User R-Server btn-close 
         F-Password R-Network 
      WITH FRAME dlg-frame.
  {&OPEN-BROWSERS-IN-QUERY-dlg-frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fill-report-list dlg-frame 
PROCEDURE fill-report-list :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:

  def var cName  as char    no-undo.
  def var iCount as integer no-undo.
  
  run aderb/_getname.p (R-Library:screen-value in frame {&FRAME-NAME},
                        output cName, 
                        output iCount).
  
  assign
    R-Report:sensitive    = yes
    R-Report:list-items   = cName
    R-Report:screen-value = ENTRY (1,cName). 
 END. 
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE load-screen dlg-frame 
PROCEDURE load-screen :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO WITH FRAME {&FRAME-NAME}:
   
  IF VALID-HANDLE(PH_SMO) THEN DO:
  
    RUN GET-ATTRIBUTE IN ph_SMO ('REPORT-LIBRARY').
    IF RETURN-VALUE NE ? 
        THEN R-Library:SCREEN-VALUE = RETURN-VALUE.

    RUN GET-ATTRIBUTE IN ph_SMO ('Printer').
    IF RETURN-VALUE NE ? THEN DO:
        CASE return-value:
            WHEN "D" THEN RS-Printer:screen-value = "1".
            WHEN " " THEN RS-Printer:screen-value = "2".
            OTHERWISE RS-Printer:screen-value = "3".
        END CASE.
    END.
    
    RUN GET-ATTRIBUTE IN ph_SMO ('Include').
    IF RETURN-VALUE NE ? THEN DO:
        CASE return-value:
            WHEN "S" THEN R-Include:screen-value = "1".
            WHEN "O" THEN R-Include:screen-value = "2".
            WHEN "E" THEN R-Include:screen-value = "3". 
            OTHERWISE R-Include:screen-value = "4".
        END CASE.
    END.

    RUN GET-ATTRIBUTE IN ph_SMO ('Filter').
    IF RETURN-VALUE NE ? 
        THEN E-Filter:screen-value = RETURN-VALUE.

    RUN GET-ATTRIBUTE IN ph_SMO ('Copies').
    IF RETURN-VALUE NE ? 
        THEN F-NumberCopies:screen-value = RETURN-VALUE.

    RUN GET-ATTRIBUTE IN ph_SMO ('BegPage').
    IF RETURN-VALUE NE ? 
        THEN R-PageBeg:screen-value = RETURN-VALUE.

    RUN GET-ATTRIBUTE IN ph_SMO ('EndPage').
    IF RETURN-VALUE NE ? 
        THEN R-PageEnd:screen-value = RETURN-VALUE.

    RUN GET-ATTRIBUTE IN ph_SMO ('Display-Errors').
    IF RETURN-VALUE NE ? 
        THEN T-Batch:screen-value = RETURN-VALUE.

    RUN GET-ATTRIBUTE IN ph_SMO ('Display-Status').
    IF RETURN-VALUE NE ? 
        THEN T-Status:screen-value = RETURN-VALUE.
 
    RUN GET-ATTRIBUTE IN ph_SMO ('Printer-prompt').
    IF RETURN-VALUE NE ? 
        THEN T-printer:screen-value = RETURN-VALUE.

    RUN GET-ATTRIBUTE IN ph_SMO ('Database').
    IF RETURN-VALUE NE ? 
        THEN R-Database:screen-value = RETURN-VALUE.

    RUN GET-ATTRIBUTE IN ph_SMO ('Host').
    IF RETURN-VALUE NE ? 
        THEN R-Host:screen-value = RETURN-VALUE.

    RUN GET-ATTRIBUTE IN ph_SMO ('Server').
    IF RETURN-VALUE NE ? 
        THEN R-Server:SCREEN-VALUE = RETURN-VALUE.

    RUN GET-ATTRIBUTE IN ph_SMO ('Network').
    IF RETURN-VALUE NE ? 
        THEN R-Network:screen-value = RETURN-VALUE.

    RUN GET-ATTRIBUTE IN ph_SMO ('User').
    IF RETURN-VALUE NE ? 
        THEN F-User:screen-value = RETURN-VALUE.

    RUN GET-ATTRIBUTE IN ph_SMO ('Password').
    IF RETURN-VALUE NE ? 
        THEN F-Password:screen-value = RETURN-VALUE.
        
    RUN GET-ATTRIBUTE IN ph_SMO ('OutputFile').
    IF RETURN-VALUE NE ? 
        THEN R-OutputFile:screen-value = RETURN-VALUE.

  
  APPLY "VALUE-CHANGED":U TO RS-Printer.

  END.

END.  


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


