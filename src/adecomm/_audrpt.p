/*************************************************************/
/* Copyright (c) 1984-2005,2008 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*----------------------------------------------------------------------------

File: adecomm/_audrpt.p

Description:
   Report template for auditing reports.
 
Input Parameters:
   pcDbRecid - Recid of the _Db record corresponding to the current database
   pcDbName  - Logical name of the database
   piReport  - Numeric Identifier of the report being called
               1    = Track Audit Policy Changes
               2    = Track Database Schema Changes
               3    = Track Audit Data Administration (Dump/Load)
               4    = Track Application Data Administration (Dump/Load)
               5    = Track User Account Changes
               6    = Track Security Permissions Changes
               7    = Track SQL Permissions Changes
               8    = Track Authentication System Changes
               9    = Client Session Authentication Report
               10   = Database Administration Report (Utilities)
               11   = Database Access Report (Login/Logout/etc...)
               12   = Custom Audit Data Filter
               13   = Encryption Policy Changes
               14   = Key-store Changes 
               15   = Database Encryption Administration (Utilities)

   pcFilter  - Date Range Filter criterea for the selected report
   
Author: Kenneth S. McIntosh

Date Created: June 7, 2005
History:

     kmcintos  Jan  03, 2006  Fixed printing bug 20051116-043.
     fernando  Dec  23, 2008  Support for Encryption reports
----------------------------------------------------------------------------*/
&GLOBAL-DEFINE WIN95-BTN YES

{adecomm/commeng.i}      /* Help contexts */
{adecomm/adestds.i}      /* Standard layout defines, colors etc. */
{adecomm/adeintl.i}      /* International support */

DEFINE INPUT  PARAMETER prDbRecid AS RECID       NO-UNDO.
DEFINE INPUT  PARAMETER pcDbName  AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER piReport  AS INTEGER     NO-UNDO.
DEFINE INPUT  PARAMETER pcFilter  AS CHARACTER   NO-UNDO.

DEFINE NEW SHARED STREAM reportStream.

DEFINE VARIABLE lXmlFile     AS LOGICAL     NO-UNDO INITIAL TRUE.
DEFINE VARIABLE lOverwrite   AS LOGICAL     NO-UNDO.

DEFINE VARIABLE rsDevice     AS CHARACTER   NO-UNDO VIEW-AS RADIO-SET
    RADIO-BUTTONS "Terminal","T",
                  "Printer","P",
                  "File (XML)","Fx",
                  "File (Text)","Ft"
    INITIAL "T".

DEFINE VARIABLE hReport      AS HANDLE      NO-UNDO.

DEFINE BUTTON btnOk      LABEL "OK"       {&STDPH_OKBTN} AUTO-GO.
DEFINE BUTTON btnCancel  LABEL "Cancel"   {&STDPH_OKBTN} AUTO-ENDKEY.
DEFINE BUTTON btnFile    LABEL "&Files..." 
   &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN SIZE 15 by 1.125 &ENDIF.

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
  DEFINE BUTTON    btnHelp  LABEL "&Help" {&STDPH_OKBTN}.
  DEFINE RECTANGLE rectBtns {&STDPH_OKBOX}. /* standard button rectangle */
  &GLOBAL-DEFINE HLP_BTN  &HELP = "btnHelp"
&ELSE
   &GLOBAL-DEFINE HLP_BTN  
&ENDIF

{adecomm/rptvar.i}   /* Common Variables */

/*-------------------------------Forms------------------------------------*/
FORM SKIP({&TFM_WID})
     rsDevice   LABEL "&Send Output to" COLON 16 SKIP({&VM_WIDG})
     fiFileName LABEL "File Name" FORMAT "x({&PATH_WIDG})" 
                &IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN 
                  AT ROW 5 COL 8 &ELSE COLON 16 &ENDIF
                VIEW-AS FILL-IN NATIVE 
                        SIZE 35 BY 1 {&STDPH_FILL} SPACE(.3)
     &IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN
       cbPrinter  LABEL "Printer" 
                  FORMAT "x({&PATH_WIDG})" 
                  AT ROW 5 COL 11
     &ENDIF
     btnFile  AT 54 SKIP({&VM_WID})
     tbAppend   LABEL "&Append to Existing File?" AT 19
               VIEW-AS TOGGLE-BOX SKIP({&VM_WIDG})
     fiPgLength LABEL "&Page Length" 
                FORMAT ">>9" 
                COLON 16 {&STDPH_FILL}
     "(# Lines, 0 for Continuous)" SKIP({&VM_WIDG})
     txtReport[piReport] LABEL "Report" 
                         VIEW-AS TEXT 
                         COLON 16 SKIP({&VM_WIDG})
     rsDetail LABEL "Orientation" COLON 16
   {adecomm/okform.i
      &BOX    = rectBtns
      &STATUS = no
      &OK     = btnOK
      &CANCEL = btnCancel
      {&HLP_BTN}
   }
   WITH FRAME printOptions
      SIDE-LABELS 
      DEFAULT-BUTTON btnOK CANCEL-BUTTON btnCancel
      VIEW-AS DIALOG-BOX TITLE "OpenEdge Auditing Report Options".

&IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN
  cbPrinter:LIST-ITEMS   = SESSION:GET-PRINTERS().
  cbPrinter:SCREEN-VALUE = SESSION:PRINTER-NAME.
  cbPrinter:VISIBLE      = FALSE.
&ENDIF

/*-----------------------------Triggers------------------------------------*/

/*----- OK or GO -----*/
ON GO OF FRAME printOptions DO:
  DEFINE VARIABLE lChoice AS LOGICAL     NO-UNDO.

  ASSIGN rsDevice
         fiFileName
         &IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN cbPrinter &ENDIF
         fiPgLength
         tbAppend
         rsDetail.

  IF rsDevice BEGINS "F" THEN DO:
    IF fiFileName NE "" AND 
       fiFileName NE ? THEN
      ASSIGN fiFileName = TRIM(fiFileName)
             lXmlFile   = (rsDevice = "Fx").
    ELSE DO:
      MESSAGE "You must enter a filename!"
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
      APPLY "ENTRY" TO fiFileName IN FRAME printOptions.
      RETURN NO-APPLY.
    END.

    IF NOT tbAppend THEN DO:
      FILE-INFO:FILE-NAME = fiFileName.
      IF FILE-INFO:FULL-PATHNAME NE ? THEN DO:
        MESSAGE fiFileName "already exists. Overwrite?"
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
                              UPDATE lOverwrite.
        IF NOT lOverwrite THEN DO:
          APPLY "ENTRY" TO fiFileName.
          RETURN NO-APPLY.
        END. /* Not overwrite */
      END. /* File Exists */
    END. /* Not Append */
    rsDevice = "F" + (IF lXmlFile THEN "x" ELSE "t") +
               CHR(1) + fiFileName.
  END. /* If rsDevice BEGINS F */
  &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
  ELSE IF rsDevice = "P" THEN
    rsDevice = "P" + CHR(1) + cbPrinter. &ENDIF
  ELSE IF rsDevice = "T" THEN
    rsDevice = "T" + CHR(1) + "".
  
  HIDE FRAME printOptions.

  RUN adecomm/_praudrpt.p ( INPUT rsDevice,
                            INPUT piReport,
                            INPUT pcFilter,
                            INPUT tbAppend,
                            INPUT fiPgLength,
                            INPUT pcDbName,
                            INPUT rsDetail ).

END. /* GO of frame printOptions */

/*----- VALUE-CHANGED of DEVICE RADIO SET -----*/
ON VALUE-CHANGED OF rsDevice IN FRAME printOptions DO:
   
   ASSIGN rsDevice.
   ASSIGN lXmlFile         = (rsDevice = "Fx")
          tbAppend:CHECKED = FALSE.

   IF rsDevice BEGINS "F" /* file */ THEN DO WITH FRAME printOptions:
     ASSIGN btnFile:LABEL             = "&Files..."
            fiFileName:SCREEN-VALUE   = cDefaultFile + 
                          (IF lXmlFile THEN ".xml" ELSE ".txt")
            fiFileName:VISIBLE        = TRUE
            fiPgLength:SCREEN-VALUE   = "0"
            fiPgLength:SENSITIVE      = FALSE
            tbAppend:SENSITIVE        = (NOT lXmlFile)
            fiPgLength:SENSITIVE      = (NOT lXmlFile)
            rsDetail:SCREEN-VALUE     = (IF lXmlFile THEN "yes" ELSE rsDetail:SCREEN-VALUE)
            rsDetail:SENSITIVE        = (NOT lXmlFile)
            &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN 
              btnFile:VISIBLE         = TRUE
              btnFile:SENSITIVE       = TRUE
            &ELSE
              cbPrinter:VISIBLE       = FALSE
              fiFileName:SENSITIVE    = TRUE
              btnFile:SENSITIVE       = TRUE
            &ENDIF .
   END. /* Output to File */
   ELSE DO WITH FRAME printOptions:
      &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN 
            ASSIGN fiFileName:VISIBLE      = FALSE
                   btnFile:VISIBLE         = FALSE
      &ELSE
            ASSIGN fiFileName:SENSITIVE    = FALSE
      &ENDIF 
                   fiFileName:SCREEN-VALUE = ""
                   tbAppend:SENSITIVE      = FALSE
                   fiPgLength:SENSITIVE    = TRUE
                   rsDetail:SENSITIVE      = TRUE.

      IF rsDevice = "T" THEN
            ASSIGN fiPgLength:SCREEN-VALUE = "0"
                   btnFile:SENSITIVE       = FALSE
                   &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
                     cbPrinter:SENSITIVE   = FALSE
                   &ENDIF .
      ELSE IF rsDevice = "P" THEN
            ASSIGN fiPgLength:SCREEN-VALUE  = "60"
                   &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
                     cbPrinter:VISIBLE      = TRUE        
                     cbPrinter:SCREEN-VALUE = SESSION:PRINTER-NAME
                     fiFileName:VISIBLE     = FALSE
                     cbPrinter:SENSITIVE    = TRUE
                     btnFile:SENSITIVE      = TRUE
                     btnFile:LABEL          = "Printer Setup"
                   &ENDIF .
   END. /* Output to Terminal or Printer */
END. /* Value-Changed of rsDevice */

ON RETURN OF rsDevice IN FRAME printOptions
  APPLY "GO" TO FRAME printOptions.
  
&IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN
  ON VALUE-CHANGED OF cbPrinter IN FRAME printOptions
    SESSION:PRINTER-NAME = SELF:SCREEN-VALUE.
&ENDIF 
      
/*----- CHOOSE of btnFile -----*/
ON CHOOSE OF btnFile IN FRAME printOptions DO:
  DEFINE VARIABLE cName       AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE lPickedOne  AS LOGICAL      NO-UNDO.
  DEFINE VARIABLE cTitle      AS CHARACTER    NO-UNDO INITIAL "Report File".
  DEFINE VARIABLE cFilters    AS CHARACTER    NO-UNDO.
  
  lXmlFile = (rsDevice = "Fx").
               
  IF rsDevice BEGINS "F" THEN DO:
    cName = TRIM(fiFileName:SCREEN-VALUE IN FRAME printOptions).
    &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
      IF lXmlFile THEN
        SYSTEM-DIALOG GET-FILE           cName 
                      FILTERS            "XML Files  (*.xml)" "*.xml"
                      DEFAULT-EXTENSION  ".xml"
                      TITLE              cTitle
                      UPDATE             lPickedOne.
      ELSE
        SYSTEM-DIALOG GET-FILE           cName
                      FILTERS            "Text Files (*.txt)" "*.txt",
                                         "All Files  (*.*)"   "*.*"
                      DEFAULT-EXTENSION  ".txt"
                      TITLE              cTitle
                      UPDATE             lPickedOne.
    &ELSE
      RUN adecomm/_filecom.p ( INPUT "" /* p_Filter */, 
                               INPUT "" /* p_Dir */, 
                               INPUT "" /* p_Drive */,
                               INPUT no /* File Open */,
                               INPUT cTitle,
                               INPUT "" /* Dialog Options */,
                               INPUT-OUTPUT cName,
                               OUTPUT lPickedOne ). 
    &ENDIF

    IF lPickedOne THEN DO WITH FRAME printOptions:
      ASSIGN fiFileName:SCREEN-VALUE = cName
             lXmlFile                = (rsDevice = "Fx")                                      tbAppend:SENSITIVE      = (NOT lXmlFile)
             fiPgLength:SENSITIVE    = (NOT lXmlFile)
             rsDetail:SENSITIVE      = (NOT lXmlFile).
    END.
  END. /* If device = File */
  ELSE IF rsDevice = "P" THEN DO:
    &IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN
      SYSTEM-DIALOG PRINTER-SETUP.
      cbPrinter:SCREEN-VALUE IN FRAME printOptions = SESSION:PRINTER-NAME.
    &ENDIF
  END. /* If device = Printer */
END. /* CHOOSE of btnFile */

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
  ON HELP OF FRAME printOptions OR 
     CHOOSE OF btnHelp IN FRAME printOptions
    RUN adecomm/_adehelp.p ( INPUT "comm", 
                             INPUT "CONTEXT", 
                             INPUT {&OpenEdge_Auditing_Report_Options_dialog_box},
                             INPUT ? ).
&ENDIF
/*-------------------------------Mainline code-----------------------------*/

RUN printOptions.

PROCEDURE printOptions:
  /* "File" related fields start insensitive or hidden by default */
  ASSIGN &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN 
           fiFileName:HIDDEN    IN FRAME printOptions = TRUE
           btnFile:HIDDEN       IN FRAME printOptions = TRUE
           fiFileName:SENSITIVE IN FRAME printOptions = TRUE
           btnFile:SENSITIVE    IN FRAME printOptions = TRUE
         &ELSE
           fiFileName:SENSITIVE IN FRAME printOptions = FALSE
           cbPrinter:SENSITIVE  IN FRAME printOptions = FALSE
           btnFile:SENSITIVE    IN FRAME printOptions = FALSE
           cbPrinter:VISIBLE    IN FRAME printOptions = FALSE
         &ENDIF .

  /* Run time layout for button area. */
  {adecomm/okrun.i  
    &FRAME  = "FRAME printOptions" 
    &BOX    = "rectBtns"
    &OK     = "btnOk" 
    &Cancel = "btnCancel"
    {&HLP_BTN} }

  DISPLAY rsDevice
          fiPgLength
          txtReport[piReport]
          rsDetail
      WITH FRAME printOptions.

  /* Need fixed array element to get the handle of the Report fill-in in the 
     frame, and we don't know what that element will be rill runtime, so we 
     have to walk the frame's widget tree to get it's handle. */
  hReport = FRAME printOptions:FIRST-CHILD:FIRST-CHILD NO-ERROR.
  WIDG-BLK:
  DO WHILE VALID-HANDLE(hReport):
    IF CAN-QUERY(hReport,"LABEL") AND 
      hReport:LABEL = "Report" THEN LEAVE WIDG-BLK.
    hReport= hReport:NEXT-SIBLING.
  END.

  &IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN 
    hReport:TOOLTIP   = txtReport[piReport].
  &ELSE
    hReport:READ-ONLY = TRUE.
  &ENDIF

  ENABLE rsDevice 
         fiFileName
         cbPrinter
         btnFile
         tbAppend
         fiPgLength 
         txtReport[piReport] WHEN SESSION:DISPLAY-TYPE = "TTY"
         rsDetail
         btnOk 
         btnCancel
         &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN btnHelp &ENDIF
      WITH FRAME printOptions.

  &IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN
    ASSIGN btnFile:SENSITIVE    = FALSE
           fiFileName:SENSITIVE = FALSE
           cbPrinter:SENSITIVE  = FALSE
           cbPrinter:VISIBLE    = FALSE
  &ELSE
    ASSIGN btnFile:VISIBLE      = FALSE
           fiFileName:VISIBLE   = FALSE
           cbPrinter:VISIBLE    = FALSE
  &ENDIF 
           tbAppend:SENSITIVE   = FALSE.

  APPLY "VALUE-CHANGED" TO rsDevice IN FRAME printOptions.

  /* If user chose print and there's a problem with the printer, 
     Progress may generate a STOP condition - so trap that so
     we don't get kicked out of the whole application.  */
  DO ON ERROR UNDO, LEAVE ON ENDKEY UNDO, LEAVE ON STOP UNDO, LEAVE:
    WAIT-FOR CHOOSE OF btnOk IN FRAME printOptions OR 
             GO OF FRAME printOptions 
             FOCUS rsDevice. 
        /* Possibly change this back after beta 1 */
  END.

  HIDE FRAME printOptions.
  RETURN RETURN-VALUE.
END PROCEDURE.
