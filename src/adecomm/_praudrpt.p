/*************************************************************/
/* Copyright (c) 1984-2005,2008,2010 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*----------------------------------------------------------------------------

File: adecomm/_praudrpt.p

Description:
   Quick and dirty report to the screen with option to print.  
   This template is used for all auditing reports.
 
Input Parameters:
   pcDevice     - Output device. This is a list of "output type" followed by 
                  "output destination" separated by a CHR(1) character. The
                  expected output types follow:
                  T = TERMINAL
                  P = PRINTER
                  F = FILE
   piReport     - Numeric Identifier of the report being called
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
                  
   pcFilter     - Date Range filter criterea for the selected report
   plAppend     - Whether or not to append an existing file
   piPgLength   - Page length, for output
   pcDbName     - Logical Database Name for report
   plDetail     - Display Detail information in the report

Author: Kenneth S. McIntosh

Date Created: June 8, 2005

History:
  kmcintos  Sept 19, 2005  Added temp file list to keep track of legitimate 
                           tmp files to remove on the way out 20050919-022.  
  kmcintos  Oct 26, 2005   Encapsulated generateReport to avoid file 
                           conflicts 20050920-013.
  kmcintos  Dec 29, 2005   Fixed truncation issues 20051116-041.
  kmcintos  Jan 03, 2006   Fixed printing issue 20051116-043.
  fernando  Dec 23, 2008   Support for encryption
  fernando  01/05/2010     Expand transaction id format
----------------------------------------------------------------------------*/
CREATE WIDGET-POOL "datasetPool".

&GLOBAL-DEFINE WIN95-BTN YES
{adecomm/commeng.i}      /* Help contexts */
{adecomm/adestds.i}      /* Standard layout defines, colors etc. */
{adecomm/adeintl.i}      /* International support */
{adecomm/aud-tts.i NEW}  /* Audit Data Temp-Tables */

DEFINE INPUT  PARAMETER pcDevice     AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER piReport     AS INTEGER     NO-UNDO.
DEFINE INPUT  PARAMETER pcFilter     AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER plAppend     AS LOGICAL     NO-UNDO.
DEFINE INPUT  PARAMETER piPgLength   AS INTEGER     NO-UNDO.
DEFINE INPUT  PARAMETER pcDbName     AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER plDetail     AS LOGICAL     NO-UNDO.

DEFINE NEW SHARED STREAM reportStream.
DEFINE NEW SHARED STREAM inputStream.

DEFINE VARIABLE cTempFile    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cInput       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE rsDevice     AS CHARACTER   NO-UNDO 
                                VIEW-AS RADIO-SET
                                RADIO-BUTTONS "Printer", "P", 
                                              "File (XML)", "Fx",
                                              "File (Text)", "Ft"
                                INITIAL "Printer".
DEFINE VARIABLE rsSortData   AS CHARACTER   NO-UNDO 
                                VIEW-AS RADIO-SET
                                RADIO-BUTTONS 
                                    "Event Date/Time","_audit-date-time",
                                    "Event Id","_event-id",
                                    "User Id","_user-id",
                                    "Transaction Id","_transaction-id"
                                HORIZONTAL.
DEFINE VARIABLE gcReportTtl  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE gcLastSort   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE edReport     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cTmpFileList AS CHARACTER   NO-UNDO.

DEFINE VARIABLE lStatus      AS LOGICAL     NO-UNDO.
DEFINE VARIABLE glXmlFile    AS LOGICAL     NO-UNDO.
DEFINE VARIABLE lOverwrite   AS LOGICAL     NO-UNDO.
DEFINE VARIABLE glReportGend AS LOGICAL     NO-UNDO.

DEFINE VARIABLE hReport      AS HANDLE      NO-UNDO.

DEFINE VARIABLE gdtDateTime  AS DATETIME    NO-UNDO.

{adecomm/rptvar.i}

DEFINE BUTTON btnPrint   LABEL "&Print"   {&STDPH_OKBTN}.
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

DEFINE QUERY qAudData FOR audData SCROLLING.

DEFINE BROWSE bAudData QUERY qAudData
    DISPLAY audData._audit-date-time
            audData._event-id
            audData._user-id FORMAT "x(18)"
            audData._transaction-id FORMAT "->>>>>>>>>9"
    &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
     LABEL "Txn Id" ENABLE audData._audit-date-time &ENDIF
    WITH WIDTH &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN 76 6
               &ELSE 102 12 &ENDIF DOWN FONT 0 
         FIT-LAST-COLUMN SCROLLBAR-VERTICAL.
               
/*=================================Forms================================*/

FORM SKIP(1)
     &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN 
       audData._formatted-event-context FONT 0
                                        LABEL "Event Detail" SKIP
       rsSortData                       LABEL "Sort by" SKIP 
     &ENDIF
     bAudData 
     &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
       SKIP
       audData._formatted-event-context FONT 0
                                        LABEL "Event Detail" SKIP
     &ENDIF
     
     {adecomm/okform.i
      &BOX    = rectBtns
      &STATUS = no
      &OK     = btnOK
      &OTHER  = "SPACE({&HM_DBTNG}) btnPrint"
      {&HLP_BTN}
     } 

    WITH FRAME fAudData WIDTH &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN 78
                              &ELSE 100 &ENDIF
                        CANCEL-BUTTON btnOK
                        SIDE-LABELS SCROLLABLE
                        VIEW-AS DIALOG-BOX
                        TITLE "OpenEdge Custom Audit Filter Report".
                              
/* Form for editor widget containing the report and option buttons */
FORM edReport VIEW-AS EDITOR SCROLLBAR-VERTICAL
              /* Make width one less than we want - we add 1 later */
              &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
                SIZE 77 BY 13 
              &ELSE
                INNER-CHARS 90 INNER-LINES 17 SCROLLBAR-HORIZONTAL LARGE
              &ENDIF FONT 0 /* fixed font */ SKIP
   
   {adecomm/okform.i
      &BOX    = rectBtns
      &STATUS = no
      &OK     = btnOK
      &OTHER = "SPACE({&HM_DBTNG}) btnPrint"
      {&HLP_BTN}
   }
   WITH FRAME reportFrame WIDTH 77
              DEFAULT-BUTTON btnOK CANCEL-BUTTON btnOK
              NO-LABELS VIEW-AS DIALOG-BOX SCROLLABLE.

FORM SKIP({&TFM_WID})
     rsDevice                       LABEL "&Send Output to" 
                                    COLON 16 SKIP({&VM_WIDG})
     fiFileName                     LABEL "File Name" 
                                    FORMAT "x({&PATH_WIDG})" 
                                    &IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN 
                                      AT ROW 4.5 COL 8 &ELSE COLON 16 &ENDIF
                                      VIEW-AS FILL-IN NATIVE 
                                      SIZE 35 BY 1 {&STDPH_FILL} SPACE(.3)
     &IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN
       cbPrinter                    LABEL "Printer" 
                                    FORMAT "x({&PATH_WIDG})" 
                                    AT ROW 4.5 COL 11
     &ENDIF
     btnFile                        AT 54 SKIP({&VM_WID})
     tbAppend                       LABEL "&Append to Existing File?" AT 19
                                    VIEW-AS TOGGLE-BOX SKIP({&VM_WIDG})
     fiPgLength                     LABEL "&Page Length" 
                                    FORMAT ">>9" 
                                    COLON 16 {&STDPH_FILL}
     "(# Lines, 0 for Continuous)"  SKIP({&VM_WIDG})
     txtReport[piReport]            LABEL "Report" 
                                    VIEW-AS TEXT COLON 16 
                                    SKIP({&VM_WIDG})
     rsDetail                       LABEL "Orientation" COLON 16

   {adecomm/okform.i
      &BOX    = rectBtns
      &STATUS = no
      &OK     = btnOK
      &CANCEL = btnCancel
      {&HLP_BTN}
   }

   WITH FRAME printOptions
              SIDE-LABELS DEFAULT-BUTTON btnOK 
                          CANCEL-BUTTON btnCancel
              VIEW-AS DIALOG-BOX 
                      TITLE "OpenEdge Auditing Report Options".

ASSIGN rsDevice    = ENTRY(1,pcDevice,CHR(1))
       fiFileName  = (IF rsDevice BEGINS "F" THEN 
                        ENTRY(2,pcDevice,CHR(1))
                      ELSE "")
       glXmlFile   = (rsDevice = "Fx")
       rsDetail    = plDetail
       tbAppend    = plAppend
       fiPgLength  = piPgLength
       gcReportTtl = txtReport[piReport] + ": " + 
                     (IF rsDetail THEN " (Detail)" ELSE " (Summary)").
       
&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
  cbPrinter:LIST-ITEMS    = SESSION:GET-PRINTERS().
  cbPrinter               = (IF rsDevice = "P" THEN 
                               ENTRY(2,pcDevice,CHR(1))
                             ELSE SESSION:PRINTER-NAME).
  cbPrinter:VISIBLE       = FALSE.
  BROWSE bAudData:TOOLTIP = "Double-Click or hit " + 
                            KBLABEL("RETURN") + " to view details...".
  audData._audit-date-time:READ-ONLY IN BROWSE bAudData = TRUE.
&ELSE
  BROWSE bAudData:HELP    = "Select record and hit " + 
                            KBLABEL("RETURN") + " to view details...".
  rsSortData:HELP IN FRAME fAudData = "Select item to sort browse. (" +
                                      KBLABEL("CTRL-R") + 
                                      " to reverse direction)".
&ENDIF

/*============================Trigger code===================================*/

/*----- CHOOSE of Print Button in reportFrame -----*/
ON CHOOSE OF btnPrint IN FRAME reportFrame OR
   CHOOSE OF btnPrint IN FRAME fAudData    DO:
  /*===================Trigger section for Print===============*/
  &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN 
    /*----- HELP -----*/
    ON HELP OF FRAME printOptions OR 
       CHOOSE OF btnHelp IN FRAME printOptions
      RUN adecomm/_adehelp.p ( INPUT "comm":u,
                               INPUT "CONTEXT":u,
                               INPUT {&OpenEdge_Auditing_Report_Options_dialog_box},
                               INPUT ? ).
  &ENDIF
  
  /*-----WINDOW-CLOSE-----*/
  ON WINDOW-CLOSE OF FRAME printOptions
    APPLY "END-ERROR" TO FRAME printOptions.

  /*----- OK or GO -----*/
  ON GO OF FRAME printOptions DO:
    ASSIGN rsDevice
           fiFileName
           &IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN cbPrinter &ENDIF
           fiPgLength
           tbAppend.

    IF rsDevice BEGINS "F" THEN DO:
      IF fiFileName NE "" AND 
         fiFileName NE ? THEN
        ASSIGN fiFileName = TRIM(fiFileName)
               glXmlFile  = (rsDevice = "Fx").
      ELSE DO:
        MESSAGE "You must enter a filename!"
            VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        APPLY "ENTRY" TO fiFileName IN FRAME printOptions.
        RETURN NO-APPLY.
      END. /* Filename is blank */

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
    END. /* If device = f */
  
    RUN generateReport ( INPUT &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
                                 (IF rsDevice NE "P" THEN 
                                    fiFileName
                                  ELSE cbPrinter)
                               &ELSE fiFileName &ENDIF,
                         INPUT rsDevice,
                         INPUT rsDetail,
                         INPUT tbAppend,
                         INPUT fiPgLength,
                         INPUT FALSE,
                         INPUT piReport ).
  END. /* GO of frame printOptions */
  
  /* VALUE-CHANGED of Detail radio-set */
  ON VALUE-CHANGED OF rsDetail IN FRAME printOptions DO:
    ASSIGN rsDetail.

    gcReportTtl = txtReport[piReport] + ": " + 
                  (IF rsDetail THEN " (Detail)" ELSE " (Summary)").
    IF rsDetail NE plDetail THEN
      glReportGend = FALSE.
  END.

  /*----- VALUE-CHANGED of DEVICE RADIO SET -----*/
  ON VALUE-CHANGED OF rsDevice IN FRAME printOptions DO:
   
    ASSIGN rsDevice.
    ASSIGN glXmlFile        = (rsDevice = "Fx")
           tbAppend:CHECKED = FALSE.

    IF rsDevice BEGINS "F" /* file */ THEN DO WITH FRAME printOptions:

      /* make sure we regenerate it if choosing XML and the orientation
         was set to 'summary'
      */
      IF glXmlFile AND NOT plDetail AND 
         rsDetail:INPUT-VALUE = NO /* summary */ THEN DO:
      
         ASSIGN glReportGend = NO
                plDetail = YES.
      END.

      ASSIGN btnFile:LABEL            = "&Files..."
            fiFileName:SCREEN-VALUE   = cDefaultFile + 
                       (IF glXmlFile THEN ".xml" ELSE ".txt")
            fiFileName:VISIBLE        = TRUE
            fiPgLength:SCREEN-VALUE   = "0"
            fiPgLength:SENSITIVE      = (NOT glXmlFile)
            tbAppend:SENSITIVE        = (NOT glXmlFile)
            rsDetail:SENSITIVE        = (NOT glXmlFile)
            rsDetail:SCREEN-VALUE     = (IF glXmlFile THEN "yes" ELSE rsDetail:SCREEN-VALUE)
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
                   rsDetail:SENSITIVE      = TRUE
                   fiPgLength:SENSITIVE    = TRUE.

      IF rsDevice = "T" THEN
            ASSIGN fiPgLength:SCREEN-VALUE = "0"
                   btnFile:SENSITIVE       = FALSE
                   glXmlFile               = FALSE
                   &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
                     cbPrinter:SENSITIVE   = FALSE
                   &ENDIF .
      ELSE IF rsDevice = "P" THEN
            ASSIGN fiPgLength:SCREEN-VALUE  = "60"
                   glXmlFile                = FALSE
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

  &IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN
    ON VALUE-CHANGED OF cbPrinter IN FRAME printOptions
      SESSION:PRINTER-NAME = SELF:SCREEN-VALUE.
  &ENDIF 
        
  /*----- CHOOSE of FILE BUTTON -----*/
  ON CHOOSE OF btnFile IN FRAME printOptions DO:
    DEFINE VARIABLE cName       AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE lPickedOne  AS LOGICAL      NO-UNDO.
    DEFINE VARIABLE cTitle      AS CHARACTER    NO-UNDO INITIAL "Report File".

    glXmlFile = (rsDevice = "Fx").
    IF rsDevice BEGINS "F" THEN DO:
      cName = TRIM(fiFileName:SCREEN-VALUE IN FRAME printOptions).
      &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
        IF glXmlFile THEN
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
                                 INPUT FALSE /* File Open */,
                                 INPUT cTitle,
                                 INPUT "" /* Dialog Options */,
                                 INPUT-OUTPUT cName,
                                 OUTPUT lPickedOne ). 
      &ENDIF

      IF lPickedOne THEN DO WITH FRAME printOptions:
        ASSIGN fiFileName:SCREEN-VALUE = cName
               glXmlFile               = (rsDevice = "Fx")
               tbAppend:SENSITIVE      = (NOT glXmlFile)
               rsDetail:SENSITIVE      = (NOT glXmlFile)
               fiPgLength:SENSITIVE    = (NOT glXmlFile).
      END.
    END. /* If device = File */
    ELSE IF rsDevice = "P" THEN DO:
      &IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN
        SYSTEM-DIALOG PRINTER-SETUP.
        cbPrinter:SCREEN-VALUE IN FRAME printOptions = SESSION:PRINTER-NAME.
      &ENDIF
    END. /* If device = Printer */
  END. /* Choose of files button */

  /*=======Mainline for Print processing=========*/

  DISPLAY rsDevice 
          fiFileName
          tbAppend
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
         &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN cbPrinter &ENDIF
         btnFile
         tbAppend
         fiPgLength 
         rsDetail
         btnOk 
         btnCancel
         &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN btnHelp &ENDIF
    WITH FRAME printOptions.

  APPLY "VALUE-CHANGED" TO rsDevice IN FRAME printOptions.
  DO ON ERROR UNDO, LEAVE  ON ENDKEY UNDO, LEAVE:
    WAIT-FOR CHOOSE of btnOK in FRAME printOptions OR 
             GO OF FRAME printOptions 
             FOCUS rsDevice.
  END.
  HIDE FRAME printOptions.   
END. /* On CHOOSE Of btnPrint */

/*-----WINDOW-CLOSE-----*/
ON WINDOW-CLOSE OF FRAME reportFrame
  APPLY "END-ERROR" TO FRAME reportFrame.

/*-----WINDOW-CLOSE-----*/
ON WINDOW-CLOSE OF FRAME fAudData
  APPLY "END-ERROR" TO FRAME fAudData.

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
  /*----- HELP -----*/
  ON HELP OF FRAME reportFrame OR 
     CHOOSE OF btnHelp IN FRAME reportFrame
    RUN "adecomm/_adehelp.p" ( INPUT "comm", 
                               INPUT "CONTEXT", 
                               INPUT {&OpenEdge_Auditing_Report_Options_dialog_box},
                               INPUT ? ).
&ENDIF

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
  /*----- HELP -----*/
  ON HELP OF FRAME fAudData OR 
     CHOOSE OF btnHelp IN FRAME fAudData
    RUN "adecomm/_adehelp.p" ( INPUT "comm", 
                               INPUT "CONTEXT", 
                               INPUT 0,
                               INPUT ? ).

  ON START-SEARCH OF BROWSE bAudData DO:
    DEFINE VARIABLE hCol AS HANDLE      NO-UNDO.

    hCol = SELF:CURRENT-COLUMN.
    RUN resortQuery ( INPUT hCol:NAME ).
    APPLY "END-SEARCH" TO SELF.
  END.
&ENDIF

ON DEFAULT-ACTION OF BROWSE bAudData DO:
  IF NOT AVAILABLE audData THEN
    RETURN NO-APPLY.

  RUN adecomm/_auddtl.p ( INPUT ROWID(audData),
                          INPUT "audData",
                          INPUT QUERY qAudData:HANDLE ).
END.

&IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
  ON VALUE-CHANGED OF rsSortData IN FRAME fAudData
    RUN resortQuery ( INPUT SELF:SCREEN-VALUE ).
  
  ON CTRL-R OF rsSortData IN FRAME fAudData
    RUN resortQuery ( INPUT SELF:SCREEN-VALUE ).
&ENDIF

ON VALUE-CHANGED OF BROWSE bAudData DO:
  IF NOT AVAILABLE audData THEN LEAVE.
    
  DISPLAY audData._formatted-event-context
     WITH FRAME fAudData.
END.
                                                     
/*=============================Mainline code================================*/

/* Run time layout for button area.  
   Do it for print frame here.  This way, it's only done once. Also 
   because, if you do it in the trigger the define for eff_frame_width
   becomes local to the trigger and it screws up second call to okrun.i.
*/
{adecomm/okrun.i  
   &FRAME = "FRAME printOptions" 
   &BOX   = "rectBtns"
   &OK    = "btnOK" 
   &CANCEL = "btnCancel"   /* to center for TTY mode */
   {&HLP_BTN}
}

/* Fix up report frame second so that eff_frame_width is available for
   button calculation below.
*/
{adecomm/okrun.i  
   &FRAME  = "FRAME reportFrame" 
   &BOX    = "rectBtns"
   &OK     = "btnOK"
   &CANCEL = "btnPrint"   /* to center for TTY mode */
   {&HLP_BTN}
}

/* Fix up report frame second so that eff_frame_width is available for
   button calculation below.
*/
{adecomm/okrun.i  
   &FRAME  = "FRAME fAudData" 
   &BOX    = "rectBtns"
   &OK     = "btnOK"
   &CANCEL = "btnPrint"   /* to center for TTY mode */
   {&HLP_BTN}
}

IF piReport NE 12 AND
   NOT glXmlFile THEN DO:

  /* Do the work */
  RUN generateReport ( INPUT &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
                               (IF rsDevice NE "P" THEN 
                                  fiFileName
                                ELSE cbPrinter)
                             &ELSE fiFileName &ENDIF,
                       INPUT rsDevice,
                       INPUT rsDetail,
                       INPUT tbAppend,
                       INPUT fiPgLength,
                       INPUT TRUE,
                       INPUT piReport ).
     
  IF rsDevice = "T" THEN DO:
    edReport:WIDTH-PIXELS = FRAME reportFrame:WIDTH-PIXELS - 
                            FRAME reportFrame:BORDER-LEFT-PIXEL - 
                            FRAME reportFrame:BORDER-RIGHT-PIXEL.
    FRAME reportFrame:SCROLLABLE = FALSE.
    RUN editorReport.
  END.
 
END. /* Not xml output */
ELSE RUN generateReport ( INPUT &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
                                  (IF rsDevice NE "P" THEN 
                                     fiFileName
                                   ELSE cbPrinter)
                                &ELSE fiFileName &ENDIF,
                          INPUT rsDevice,
                          INPUT rsDetail,
                          INPUT tbAppend,
                          INPUT fiPgLength,
                          INPUT TRUE,
                          INPUT piReport ).

IF piReport EQ 12 AND 
   rsDevice EQ "T" THEN
  RUN browseReport.

DELETE WIDGET-POOL "datasetPool".

/* proDataset objects do not get destroyed in widget pools.  This needs to 
   be destroyed explicitly. */
IF VALID-HANDLE(ghDataSet) THEN
  DELETE OBJECT ghDataSet.

/*==========================Internal Procedures==============================*/

PROCEDURE generateReport:
  /*   Purpose: Runs the report generation procedure */
  DEFINE INPUT  PARAMETER pcFileName AS CHARACTER   NO-UNDO.
  DEFINE INPUT  PARAMETER pcDevice   AS CHARACTER   NO-UNDO.
  DEFINE INPUT  PARAMETER plDetail   AS LOGICAL     NO-UNDO.
  DEFINE INPUT  PARAMETER plAppend   AS LOGICAL     NO-UNDO.
  DEFINE INPUT  PARAMETER pipgLength AS INTEGER     NO-UNDO.
  DEFINE INPUT  PARAMETER plFirstRun AS LOGICAL     NO-UNDO.
  DEFINE INPUT  PARAMETER piReport   AS INTEGER     NO-UNDO.
 
  DEFINE VARIABLE cOutFile AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cInFile  AS CHARACTER   NO-UNDO.

  DEFINE VARIABLE lXmlFile AS LOGICAL     NO-UNDO.

  lXmlFile = pcDevice = "Fx".
  
  gdtDateTime = NOW.

  RUN adecomm/_setcurs.p ("WAIT").
  
  /* Adjust contents of frame so everything always fits */
  IF pcDevice EQ "T" THEN DO WITH FRAME reportFrame:
    IF piReport NE 12 THEN DO:
      /* Generate a name for a tempfile to use to store report so we can view it
         with an editor widget.  Display the data to the file.  
      */
      RUN adecomm/_tmpfile.p ( INPUT "", 
                               INPUT ".dct", 
                               OUTPUT cOutFile ).
      /* Add to list of files to cleanup later */
      cTmpFileList = cTmpFileList + (IF cTmpFileList NE "" THEN "," ELSE "") +
                     cOutFile.

      /* This is used by external procedures */
      cTempFile = cOutFile.
    END.
  END. 
  ELSE IF pcDevice BEGINS "F" THEN
    ASSIGN cTempFile = pcFileName
           cOutFile  = pcFileName.
  
  IF NOT pcDevice EQ "P" AND
     cOutFile     NE "" THEN DO:
    
    /* Open the file to make sure we have permission */
    IF cOutFile BEGINS "|" THEN
      OUTPUT THROUGH VALUE(SUBSTRING(cOutFile,2,-1,"CHARACTER":U))
             PAGE-SIZE VALUE(piPgLength).
    ELSE IF plAppend THEN
      OUTPUT TO VALUE(cOutFile) PAGE-SIZE VALUE(piPgLength) APPEND.
    ELSE IF NOT glXmlFile THEN
      OUTPUT TO VALUE(cOutFile) PAGE-SIZE VALUE(fiPgLength).
    ELSE
      OUTPUT TO VALUE(cOutFile).

    OUTPUT CLOSE.
  END. /* Not printer output */
  
  /* XML Output requires no header, cannot be paged and page size 
     is also meaningless, so don't go here for xml files. */
  IF NOT lXmlFile    AND
     (cOutFile NE "" OR
      pcDevice EQ "P") THEN DO:
    IF piPgLength > 0 THEN
      /* Header with Page specification */
      FORM HEADER gdtDateTime "OpenEdge Auditing Report" 
                  "Page" AT &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN 60
                            &ELSE 70 &ENDIF PAGE-NUMBER(reportStream) 
                            FORMAT "ZZ9" SKIP
                  gcReportTtl VIEW-AS TEXT FORMAT "x(77)"
        WITH FRAME page_head_paged
             PAGE-TOP NO-LABELS NO-BOX NO-ATTR-SPACE
             NO-UNDERLINE USE-TEXT STREAM-IO.
    ELSE
      /* Header with no Page specification */
      FORM HEADER gdtDateTime "OpenEdge Auditing Report" SKIP
                  gcReportTtl VIEW-AS TEXT FORMAT "x(77)" 
          WITH FRAME page_head_not_paged
               PAGE-TOP NO-LABELS NO-BOX NO-ATTR-SPACE
               NO-UNDERLINE USE-TEXT STREAM-IO.

    IF cOutFile BEGINS "|" THEN 
      OUTPUT STREAM reportStream THROUGH 
                    VALUE(SUBSTRING(pcDevice,2,-1,"CHARACTER":U)) 
                    PAGE-SIZE VALUE(piPgLength).
    ELSE IF pcDevice BEGINS "P" THEN DO:
      IF pcFileName > '' THEN
        OUTPUT STREAM reportStream TO PRINTER VALUE(pcFileName) 
              PAGE-SIZE VALUE(piPgLength).
      ELSE
        OUTPUT STREAM reportStream TO PRINTER PAGE-SIZE VALUE(piPgLength).
    END.
    ELSE IF plAppend THEN 
      OUTPUT STREAM reportStream TO VALUE(cOutFile) 
                    PAGE-SIZE VALUE(piPgLength) APPEND.
    ELSE
      OUTPUT STREAM reportStream TO VALUE(cOutFile) 
                    PAGE-SIZE VALUE(piPgLength).
      
    IF piPgLength > 0 THEN
        VIEW STREAM reportStream FRAME page_head_paged.
     ELSE 
        VIEW STREAM reportStream FRAME page_head_not_paged.
    
    DO ON STOP UNDO, LEAVE:
      gdtDateTime = NOW.
      
      /* If the report was already generated then let's get the output 
         from the tempfile instead of running it all over again. */
      IF glReportGend THEN DO:    
        IF cTmpFileList > "" THEN
          cInFile = ENTRY(NUM-ENTRIES(cTmpFileList),cTmpFileList).

        IF cInFile EQ "" THEN DO:
          RUN adecomm/_auddat.p ( INPUT piReport,
                                  INPUT cOutFile,
                                  INPUT pcFilter,
                                  INPUT pcDbName,
                                  INPUT plDetail,
                                  INPUT (NOT plFirstRun) ).
          glReportGend = TRUE.
        END. /* Can't find input filename */
        ELSE DO:
          INPUT STREAM inputStream FROM VALUE(cInFile) NO-ECHO.
          REPEAT:
            IMPORT STREAM inputStream UNFORMATTED cInput.
            PUT STREAM reportStream UNFORMATTED cInput SKIP.
            /* make the output be the same as if you generated the report 
               straight to the text file. */
            IF cInput = "" THEN
               PUT STREAM reportStream UNFORMATTED SKIP(1).
          END.
          INPUT STREAM inputStream CLOSE.
        END. /* Can find input filename */
      END. /* If Report File was already generated */
      ELSE DO:
        RUN adecomm/_auddat.p ( INPUT piReport,
                                INPUT (IF pcDevice EQ "P" THEN 
                                         pcFileName ELSE cOutFile),
                                INPUT pcFilter,
                                INPUT pcDbName,
                                INPUT rsDetail,
                                INPUT (NOT plFirstRun) ).
        glReportGend = TRUE.
      END.

      OUTPUT STREAM reportStream CLOSE.
    END. /* Do on stop */
    
  END. /* Not xml file */
  ELSE DO:
    IF glReportGend THEN 
      ghDataset:WRITE-XML("FILE",cOutFile,TRUE,"UTF-8",?,TRUE,TRUE).
    ELSE
      RUN adecomm/_auddat.p ( INPUT piReport,
                              INPUT cOutFile,
                              INPUT pcFilter,
                              INPUT pcDbName,
                              INPUT rsDetail,
                              INPUT (NOT plFirstRun) ).
  END. 

  RUN adecomm/_setcurs.p ("").
END PROCEDURE.

PROCEDURE browseReport:
  gcLastSort = "_audit-date-time".
  RUN resortQuery ( INPUT gcLastSort ).

  IF NOT AVAILABLE audData THEN DO:
    MESSAGE "No records were found that match your criteria"
        VIEW-AS ALERT-BOX INFO.
    RETURN "".
  END.

  DISPLAY audData._formatted-event-context
  &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
    rsSortData 
  &ENDIF
  WITH FRAME fAudData.

  ENABLE &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN 
           audData._formatted-event-context rsSortData &ENDIF
         bAudData
         &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
           audData._formatted-event-context &ENDIF
         btnOk
         btnPrint
         &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
           btnHelp &ENDIF
     WITH FRAME fAudData.

  audData._formatted-event-context:READ-ONLY IN FRAME fAudData = TRUE.

  &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
    audData._formatted-event-context:BGCOLOR = 8. &ENDIF

  DO ON ERROR UNDO, LEAVE  ON ENDKEY UNDO, LEAVE:
    WAIT-FOR CHOOSE OF btnOK IN FRAME fAudData OR
             GO     OF          FRAME fAudData
        FOCUS bAudData.
  END.
END PROCEDURE.

PROCEDURE editorReport:
  DEFINE VARIABLE iFile AS INTEGER     NO-UNDO.

  /* Show the report in the editor widget. */
  ASSIGN edReport:PFCOLOR   IN FRAME reportFrame = 0
         edReport:READ-ONLY IN FRAME reportFrame = TRUE
         edReport:SENSITIVE IN FRAME reportFrame = TRUE
         FRAME reportFrame:TITLE                 = txtReport[piReport].

  lStatus = edReport:READ-FILE(cTempFile) IN FRAME reportFrame NO-ERROR.

  /* Display frame only if report could be read into the editor-widget */
  IF lStatus THEN DO:
    ENABLE edReport 
           btnOK 
           btnPrint 
           &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
                 btnHelp
           &ENDIF
        WITH FRAME reportFrame.
      
    DO ON ERROR UNDO, LEAVE  ON ENDKEY UNDO, LEAVE:
      WAIT-FOR CHOOSE OF btnOK IN FRAME reportFrame OR
               GO     OF          FRAME reportFrame
          FOCUS edReport.
    END.
      
    /* Close up shop. */
    DO iFile = 1 TO NUM-ENTRIES(cTmpFileList):
      FILE-INFO:FILE-NAME = ENTRY(iFile,cTmpFileList).
      IF FILE-INFO:FILE-NAME NE ? THEN
        OS-DELETE VALUE(FILE-INFO:FULL-PATHNAME).
    END.
    HIDE FRAME reportFrame NO-PAUSE.
    HIDE MESSAGE NO-PAUSE.
  END. /* If file was read into editor */
END PROCEDURE.

PROCEDURE resortQuery:
  DEFINE INPUT  PARAMETER pcColumn AS CHARACTER   NO-UNDO.

  DEFINE VARIABLE cSort  AS CHARACTER   NO-UNDO.

  DEFINE VARIABLE hQuery AS HANDLE      NO-UNDO.
  
  CASE pcColumn:
    WHEN "_audit-date-time" THEN DO:
      IF gcLastSort = pcColumn THEN
        ASSIGN cSort      = " BY " + pcColumn + " DESC"
               gcLastSort = pcColumn + " DESC".
      ELSE 
        ASSIGN cSort      = " BY " + pcColumn
               gcLastSort = pcColumn.
    END.
    OTHERWISE DO:
      IF gcLastSort = pcColumn THEN
        ASSIGN cSort      = " BY " + pcColumn + " DESC" + 
                            " BY _audit-date-time DESC" 
               gcLastSort = pcColumn + " DESC".
      ELSE 
        ASSIGN cSort      = " BY " + pcColumn + 
                            " BY _audit-date-time DESC"
               gcLastSort = pcColumn.
    END.
  END CASE.

  hQuery = QUERY qAudData:HANDLE.

  hQuery:QUERY-CLOSE.
  hQuery:QUERY-PREPARE("FOR EACH audData NO-LOCK" + cSort).
  hQuery:QUERY-OPEN().
END PROCEDURE.

