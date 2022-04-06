&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Check Version Notes Wizard" Procedure _INLINE
/* Actions: af/cod/aftemwizcw.w ? ? ? ? */
/* MIP Update Version Notes Wizard
Check object version notes.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" Procedure _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" Procedure _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: afexpplipp.p

  Description:  Data Export Plip - Crystal & Excel
  
  Purpose:      Contains code to create excel and crystal reports data exports from
                temp-table browsers

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:    90000149   UserRef:    
                Date:   24/05/2001  Author:     Bruce Gruenbaum

  Update Notes: Created from Template rytemplipp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afexpplipp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Astra object identifying preprocessor */
&glob   AstraPlip    yes

DEFINE VARIABLE cObjectName         AS CHARACTER NO-UNDO.

ASSIGN cObjectName = "{&object-name}":U.

&scop   mip-notify-user-on-plip-close   NO

{af/sup2/afglobals.i}
{af/sup2/afcheckerr.i &define-only = YES}

DEFINE TEMP-TABLE tt_datasource NO-UNDO
FIELD tt_tag   AS CHARACTER
FIELD tt_value AS CHARACTER EXTENT {&max-crystal-fields}.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



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
         HEIGHT             = 11.19
         WIDTH              = 43.8.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  ******************************* */

{ry/app/ryplipmain.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-exportCrystal) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE exportCrystal Procedure 
PROCEDURE exportCrystal :
/*------------------------------------------------------------------------------
  Purpose:     Creates a on-the-fly crystal report from a temp-table browser
  Parameters:  phBrowse
               pcHeader
               pcFooter
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT  PARAMETER phBrowse AS HANDLE     NO-UNDO.
DEFINE INPUT  PARAMETER pcHeader AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcFooter AS CHARACTER  NO-UNDO.
    
DEFINE VARIABLE cDataObject   AS CHARACTER NO-UNDO.
DEFINE VARIABLE cTemplate     AS CHARACTER NO-UNDO.
DEFINE VARIABLE cNewReport    AS CHARACTER NO-UNDO.

DEFINE VARIABLE iLoop           AS INTEGER NO-UNDO.
DEFINE VARIABLE hBrowserColumn  AS HANDLE  NO-UNDO.
DEFINE VARIABLE lFinished       AS LOGICAL    NO-UNDO.

DEFINE VARIABLE cTableName  AS CHARACTER  NO-UNDO.

  IF SEARCH(SESSION:TEMP-DIRECTORY + "/aftemfullb.mdb":U) = ? THEN 
  DO:
    IF SEARCH("af/rep/aftemfullb.mdb":U) = ? THEN
      RETURN {af/sup2/aferrortxt.i 'AF' '14' '?' '?' '"Crystal reports dataobject "' '"af/rep/aftemfullb.mdb "'}.
    ELSE DO:
      OS-COPY VALUE(SEARCH("af/rep/aftemfullb.mdb":U)) VALUE((SESSION:TEMP-DIRECTORY + "/aftemfullb.mdb":U)).
      IF OS-ERROR <> 0 THEN
        RETURN {af/sup2/aferrortxt.i 'AF' '16' '?' '?' '"Crystal reports dataobject "' '"af/rep/aftemfullb.mdb "'}.
    END.
  END.    
  
  IF SEARCH("af/rep/aflandscap.rpt":U) = ? THEN
    RETURN {af/sup2/aferrortxt.i 'AF' '14' '?' '?' '"Crystal reports landscape template "' '"af/rep/aflandscap.rpt "'}.
  
  IF SEARCH("af/rep/afportrait.rpt":U) = ? THEN
    RETURN {af/sup2/aferrortxt.i 'AF' '14' '?' '?' '"Crystal reports portrait template "' '"af/rep/afportrait.rpt "'}.
  
  ASSIGN
    cTableName  = "browsecrystal":U
    cDataObject = SEARCH(SESSION:TEMP-DIRECTORY + "/aftemfullb.mdb":U)
    cTemplate   = IF phBrowse:WIDTH-CHARS * 96 < 13000 THEN SEARCH("af/rep/afportrait.rpt":U) ELSE SEARCH("af/rep/aflandscap.rpt":U)
    cNewReport  = SESSION:TEMP-DIRECTORY + IF NOT CAN-DO("/,~\":U,SUBSTRING(SESSION:TEMP-DIRECTORY,LENGTH(SESSION:TEMP-DIRECTORY),1)) THEN "/":U ELSE "":U
    cNewReport  = cNewReport + cTableName + ".rpt":U.
  
  EMPTY TEMP-TABLE tt_datasource.
  
  /*Heading*/
  CREATE tt_datasource.
  ASSIGN 
    tt_datasource.tt_tag      = "F0":U
    tt_datasource.tt_value[1] = pcHeader
    tt_datasource.tt_value[2] = pcFooter 
    NO-ERROR.
  
  /*Field names*/
  CREATE tt_datasource.
  ASSIGN 
    tt_datasource.tt_tag = "F1":U
    hBrowserColumn       = phBrowse:FIRST-COLUMN.
  DO iLoop = 1 TO phBrowse:NUM-COLUMNS:
    ASSIGN
      tt_datasource.tt_value[iLoop] = TRIM(hBrowserColumn:NAME) /* TRIM(REPLACE(hBrowserColumn:LABEL," ":U,"_":U))*/
      hBrowserColumn                = hBrowserColumn:NEXT-COLUMN.
  END.

  /*Labels*/
  CREATE tt_datasource.
  ASSIGN 
    tt_datasource.tt_tag = "F2":U
    hBrowserColumn       = phBrowse:FIRST-COLUMN.
  DO iLoop = 1 TO phBrowse:NUM-COLUMNS:
    ASSIGN
      tt_datasource.tt_value[iLoop] = TRIM(hBrowserColumn:LABEL)      
      hBrowserColumn                = hBrowserColumn:NEXT-COLUMN.
  END.
  
  /*Column Widths*/
  CREATE tt_datasource.
  ASSIGN 
    tt_datasource.tt_tag = "F3":U
    hBrowserColumn       = phBrowse:FIRST-COLUMN.
  DO iLoop = 1 TO phBrowse:NUM-COLUMNS:
    ASSIGN
      tt_datasource.tt_value[iLoop] = STRING(hBrowserColumn:WIDTH-CHARS)
      hBrowserColumn                = hBrowserColumn:NEXT-COLUMN.
  END.
  
  /*Data Types*/
  CREATE tt_datasource.
  ASSIGN 
      tt_datasource.tt_tag = "F4":U
      hBrowserColumn       = phBrowse:FIRST-COLUMN.
  DO iLoop = 1 TO phBrowse:NUM-COLUMNS:
    ASSIGN
      tt_datasource.tt_value[iLoop] = "CHARACTER":U /* hBrowserColumn:DATA-TYPE */
      hBrowserColumn                = hBrowserColumn:NEXT-COLUMN.
  END.
  
  IF phBrowse:SELECT-ROW(1) AND phBrowse:SCROLL-TO-SELECTED-ROW(1) THEN
  DO WHILE NOT lFinished:
    CREATE tt_datasource.
    ASSIGN
      tt_datasource.tt_tag  = "D":U
      hBrowserColumn        = phBrowse:FIRST-COLUMN.
    /*Send Data*/      
    DO iLoop = 1 TO MIN(phBrowse:NUM-COLUMNS,{&max-crystal-fields}):
      ASSIGN
        tt_datasource.tt_value[iLoop] = IF hBrowserColumn:DATA-TYPE = "INTEGER":U THEN STRING(INTEGER(hBrowserColumn:SCREEN-VALUE))
                                        ELSE IF hBrowserColumn:DATA-TYPE = "DECIMAL":U THEN STRING(DECIMAL(REPLACE(hBrowserColumn:SCREEN-VALUE,"%":U,"":U)))
                                        ELSE IF hBrowserColumn:DATA-TYPE = "CHARACTER":U AND LENGTH( hBrowserColumn:SCREEN-VALUE ) > 319
                                        THEN SUBSTRING( hBrowserColumn:SCREEN-VALUE, 1, 319 )
                                        ELSE hBrowserColumn:SCREEN-VALUE 
        hBrowserColumn = hBrowserColumn:NEXT-COLUMN.
    END.
    IF phBrowse:SELECT-NEXT-ROW() THEN
      PROCESS EVENTS.
    ELSE
      ASSIGN
        lFinished = YES.
  END.

  {af/sup2/afrun2.i &PLIP =  'af/sup2/afcrplip2p.p'
                    &IProc = 'mip-print-report'
                    &OnApp = 'NO'
                    &PList = "(INPUT TABLE tt_datasource, ~
                               INPUT cDataObject,~
                               INPUT cTableName,~
                               INPUT NO,~
                               INPUT cTemplate,~
                               INPUT cNewReport) NO-ERROR
                               "}

  {af/sup2/afcheckerr.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-exportExcel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE exportExcel Procedure 
PROCEDURE exportExcel :
/*------------------------------------------------------------------------------
  Purpose:     Creates an excel spreadsheet from a temp-table browser
  Parameters:  phBrowse
               pcHeader
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER phBrowse AS HANDLE     NO-UNDO.
DEFINE INPUT  PARAMETER pcHeader AS CHARACTER  NO-UNDO.

DEFINE VARIABLE hExcel                AS COM-HANDLE        NO-UNDO.
DEFINE VARIABLE hWorkbook             AS COM-HANDLE        NO-UNDO.
DEFINE VARIABLE hWorksheet            AS COM-HANDLE        NO-UNDO.
DEFINE VARIABLE iRow                  AS INTEGER INITIAL 1 NO-UNDO.
DEFINE VARIABLE cRow                  AS CHARACTER         NO-UNDO.
DEFINE VARIABLE cRange1               AS CHARACTER         NO-UNDO.
DEFINE VARIABLE cRange2               AS CHARACTER         NO-UNDO.
DEFINE VARIABLE cRange3               AS CHARACTER         NO-UNDO.
DEFINE VARIABLE cHeading              AS CHARACTER         NO-UNDO.
DEFINE VARIABLE iSplit                AS INTEGER           NO-UNDO.
DEFINE VARIABLE hBrowserColumn        AS WIDGET-HANDLE     NO-UNDO.

DEFINE VARIABLE iColumns    AS INTEGER           NO-UNDO.
DEFINE VARIABLE iLoop                 AS INTEGER           NO-UNDO.
DEFINE VARIABLE lFinished             AS LOGICAL           NO-UNDO INITIAL NO.
DEFINE VARIABLE iTemp1                AS INTEGER           NO-UNDO.
DEFINE VARIABLE iTemp2                AS INTEGER           NO-UNDO.

  IF SESSION:SET-WAIT-STATE("GENERAL") THEN PROCESS EVENTS.

  CREATE "Excel.Application" hExcel.    /* Create new Excel Application object          */              
  ASSIGN
    hExcel:VISIBLE = FALSE              /* Launch Excel so it is visible to the user    */              
    hWorkbook = hExcel:Workbooks:ADD()  /* Create a new Workbook                        */              
    hWorksheet = hExcel:Sheets:ITEM(1)  /* Get the active Worksheet                     */              
    hWorksheet:NAME = "Browser"         /* Set the worksheet name                       */              
    hBrowserColumn  = phBrowse:FIRST-COLUMN
    iColumns        = phBrowse:NUM-COLUMNS.
/*     iColumns        = MIN(phBrowse:NUM-COLUMNS,26). */

DEFINE VARIABLE cRangeTest               AS CHARACTER         NO-UNDO.
  /* Load the headings */
  ASSIGN
    cRow = "A"
    iTemp1  = IF iColumns MODULO 26 = 0 THEN 1 ELSE 0
    iTemp2  = IF iColumns MODULO 26 = 0 THEN 26 ELSE 0
    cRange1 = IF iColumns LE 26 
              THEN STRING((CHR(ASC("A") + (iColumns - 1)) + STRING(1)))
              ELSE CHR(64 + INTEGER(TRUNCATE(iColumns / 26, 0)) - iTemp1 ) + CHR(64 + (iColumns MODULO 26) + iTemp2) + STRING(1)
    hWorksheet:Range(cRange1):VALUE       = pcHeader
    hWorksheet:Range(cRange1):FONT:Bold   = TRUE.
    
  DO iLoop = 1 TO iColumns:    /* Send cHeadings */

    ASSIGN
      iTemp1  = IF iLoop MODULO 26 = 0 THEN 1 ELSE 0
      iTemp2  = IF iLoop MODULO 26 = 0 THEN 26 ELSE 0
      cRange1 = IF iLoop LE 26 
                THEN STRING((CHR(ASC("A") + (iLoop - 1)) + STRING(2)))
                ELSE CHR(64 + INTEGER(TRUNCATE(iLoop / 26, 0)) - iTemp1 ) + CHR(64 + (iLoop MODULO 26) + iTemp2) + STRING(2)
      cHeading = hBrowserColumn:LABEL.
      iSplit   = INDEX(cHeading,"!").
      
    IF iSplit = 0 THEN
      ASSIGN
        hWorksheet:Range(cRange1):Value     = cHeading
        hWorksheet:Range(cRange1):Font:Bold = TRUE.
    ELSE DO:
      ASSIGN
        iTemp1  = IF iLoop MODULO 26 = 0 THEN 1 ELSE 0
        iTemp2  = IF iLoop MODULO 26 = 0 THEN 26 ELSE 0
        cRange2 = IF iLoop LE 26 
                  THEN STRING((CHR(ASC(cRow) + (iLoop - 1)) + STRING(3)))
                  ELSE CHR(64 + INTEGER(TRUNCATE(iLoop / 26, 0)) - iTemp1 ) + CHR(64 + (iLoop MODULO 26) + iTemp2) + STRING(3)
        hWorksheet:Range(cRange1):Value     = SUBSTRING(cHeading, 1, iSplit - 1)
        hWorksheet:Range(cRange1):Font:Bold = TRUE
        hWorksheet:Range(cRange2):Value     = SUBSTRING(cHeading, iSplit + 1)
        hWorksheet:Range(cRange2):Font:Bold = TRUE.
    END.

    ASSIGN
      cRange3 = IF iLoop LE 26 
                THEN SUBSTRING(cRange1, 1, 1)
                ELSE SUBSTRING(cRange1, 1, 2)
      hWorksheet:Columns(cRange3):ColumnWidth  = IF hBrowserColumn:DATA-TYPE = "DECIMAL":U THEN 12
                                                 ELSE IF hBrowserColumn:DATA-TYPE = "INTEGER":U THEN 6
                                                 ELSE IF hBrowserColumn:WIDTH-CHARS > 100 THEN 100
                                                 ELSE hBrowserColumn:WIDTH-CHARS
      hWorksheet:Columns(cRange3):NumberFormat = IF hBrowserColumn:DATA-TYPE = "DECIMAL":U THEN "###,###,###,##0.00"
                                                 ELSE IF hBrowserColumn:DATA-TYPE = "INTEGER":U THEN "########0"
                                                 ELSE "@"
      hBrowserColumn                           = hBrowserColumn:NEXT-COLUMN.
  END.

  ASSIGN
    cRow      = "A"
    iRow      = 2
    lFinished = NO.

  /* Load the data */
  IF phBrowse:SELECT-ROW(1) AND phBrowse:SCROLL-TO-SELECTED-ROW(1) THEN
  DO WHILE NOT lFinished:
    ASSIGN
      hBrowserColumn = phBrowse:FIRST-COLUMN
      iRow            = iRow + 1.
    /*Send Data*/      
    DO iLoop = 1 TO iColumns:
      ASSIGN
        iTemp1  = IF iLoop MODULO 26 = 0 THEN 1 ELSE 0
        iTemp2  = IF iLoop MODULO 26 = 0 THEN 26 ELSE 0
        cRange1 = IF iLoop LE 26 
                  THEN STRING((CHR(ASC(cRow) + (iLoop - 1)) + STRING(iRow)))
                  ELSE CHR(64 + INTEGER(TRUNCATE(iLoop / 26, 0)) - iTemp1 ) + CHR(64 + (iLoop MODULO 26) + iTemp2) + STRING(iRow)
        hWorksheet:Range(cRange1):Value = IF hBrowserColumn:DATA-TYPE = "INTEGER":U THEN STRING(INTEGER(hBrowserColumn:SCREEN-VALUE))
                                          ELSE IF hBrowserColumn:DATA-TYPE = "DECIMAL":U THEN STRING(DECIMAL(hBrowserColumn:SCREEN-VALUE))
                                          ELSE IF hBrowserColumn:DATA-TYPE = "CHARACTER":U AND LENGTH( hBrowserColumn:SCREEN-VALUE ) > 319
                                          THEN SUBSTRING( hBrowserColumn:SCREEN-VALUE, 1, 319 )
                                          ELSE hBrowserColumn:SCREEN-VALUE 
        hBrowserColumn = hBrowserColumn:NEXT-COLUMN.
    END.
    IF phBrowse:SELECT-NEXT-ROW() THEN
      PROCESS EVENTS.
    ELSE
      ASSIGN
        lFinished = YES.
  END.

  ASSIGN
    cRange1 = "A2:" + cRange3 + STRING(iRow).
    
  hWorksheet:Range(cRange1):SELECT.
  hExcel:SELECTION:COLUMNS:AutoFit.
  hWorksheet:Range("A2"):SELECT.
  

  IF SESSION:SET-WAIT-STATE("") THEN PROCESS EVENTS.
  ASSIGN
      hExcel:Visible = True.
  
  RELEASE OBJECT hWorksheet.
  RELEASE OBJECT hWorkbook.
  RELEASE OBJECT hExcel.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-killPlip) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE killPlip Procedure 
PROCEDURE killPlip :
/*------------------------------------------------------------------------------
  Purpose:     entry point to instantly kill the plip if it should get lost in memory
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{ry/app/ryplipkill.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-objectDescription) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE objectDescription Procedure 
PROCEDURE objectDescription :
/*------------------------------------------------------------------------------
  Purpose:     Pass out a description of the PLIP, used in Plip temp-table
  Parameters:  <none>
  Notes:       This should be changed manually for each plip
------------------------------------------------------------------------------*/

DEFINE OUTPUT PARAMETER cDescription AS CHARACTER NO-UNDO.

ASSIGN cDescription = "Dynamics Template PLIP".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-plipSetup) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE plipSetup Procedure 
PROCEDURE plipSetup :
/*------------------------------------------------------------------------------
  Purpose:    Run by main-block of PLIP at startup of PLIP
  Parameters: <none>
  Notes:       
------------------------------------------------------------------------------*/

{ry/app/ryplipsetu.i}
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-plipShutdown) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE plipShutdown Procedure 
PROCEDURE plipShutdown :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will be run just before the calling program 
               terminates
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{ry/app/ryplipshut.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

