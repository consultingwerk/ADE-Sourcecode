&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
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
/*--------------------------------------------------------------------------
    File        : adeuib\_crtsobj.w
    Purpose     : To generate _BC records for a SmartDataBrowser 
                  or _U records and _TT  for a SmartDataViewer.

    Syntax      : RUN adeuib\_crtsobj.w (pType, pAction, pFields).

    Description : The Wizard calls this after a user has sucessfully choosen a
                  DataObject and at least one field for a SmartDataBrowser or 
                  SmartDataViewer.

    Author(s)   : Ross Hunter
    Created     : 2/12/98
    Changed     : 3/19/98 HD  
                  Moved create _TT to _upddott.w to let SmartViewer 
                  share logic with WebObject.  
                  04/07/99 tsm
                  Added support for various Intl Numeric formats (in addition
                  to American and European) by using session set-numeric-format
                  method to set format back to user's setting after it is set
                  to American.
                  05/18/2000 BSG
                  Changed the viewer generation process to not qualify field
                  names with RowObject if they're already qualified.
                                                      
   ---------------------------------------------------------------------------                    
    Parameters  : pType   - One of these values:   
                            - SmartDataBrowser 
                            - SmartDataViewer
                  pfields - List of fields, semicolon separated with
                            opitional list of objects that are qualifiers
                            of fields to enable.                               
  -------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.                */
/*-------------------------------------------------------------------------*/

/* *****************************  Definitions  *************************** */
DEFINE INPUT PARAMETER pcType    AS CHARACTER                         NO-UNDO.
DEFINE INPUT PARAMETER pcFields  AS CHARACTER                         NO-UNDO.

{adeuib/sharvars.i}  /* Shared variables needed by the AB                  */
{adeuib/uniwidg.i}
{adeuib/layout.i}
{adeuib/brwscols.i}  /* Temp-Table definition for the columns of a browser */


DEFINE VARIABLE giNumFields     AS INTEGER    NO-UNDO.
DEFINE VARIABLE gcFields        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcEnableObjects AS CHARACTER  NO-UNDO.

/* Function prototypes */
FUNCTION get-proc-hdl RETURNS HANDLE
    (INPUT proc-file-name AS CHARACTER) IN _h_func_lib.

FUNCTION shutdown-proc RETURNS CHARACTER
    (INPUT proc-file-name AS CHARACTER ) IN _h_func_lib.

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
   Compile into: 
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
         HEIGHT             = 13.86
         WIDTH              = 50.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

ASSIGN 
  gcEnableObjects = IF NUM-ENTRIES(pcFields,";":U) > 1 
                    THEN ENTRY(2,pcFields,";":U)
                    ELSE ?
  gcFields        = ENTRY(1,pcFields,";":U).

CASE pcType:
  WHEN "SmartDataBrowser":U THEN RUN create_a_SmartBrowser.
  WHEN "SmartDataViewer":U  THEN RUN create_a_SmartViewer.
END CASE.  /* Case on pType */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-adjustWindowSize) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adjustWindowSize Procedure 
PROCEDURE adjustWindowSize :
/*------------------------------------------------------------------------------
  Purpose:     To enlarge the standard template window of SmartViewers if
               necessary.
  Parameters:  
        INPUT cScratch - Name of the file with field layout
              hFrame   - Handle of the frame to adjust (along with _h_win)
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER cScratch AS CHARACTER                       NO-UNDO.
    DEFINE INPUT  PARAMETER hFrame   AS HANDLE                          NO-UNDO.

    DEFINE VARIABLE cLine            AS CHARACTER EXTENT 100            NO-UNDO.
    DEFINE VARIABLE dHeight          AS DECIMAL                         NO-UNDO.
    DEFINE VARIABLE dWidth           AS DECIMAL                         NO-UNDO.

    DEFINE BUFFER w_U FOR _U.
    DEFINE BUFFER f_U FOR _U.
    DEFINE BUFFER w_L FOR _L.
    DEFINE BUFFER f_L FOR _L.

    ANALYZE VALUE(cScratch) VALUE(SESSION:TEMP-DIR + "scratch.qs":U).

    INPUT FROM VALUE(SESSION:TEMP-DIR + "scratch.qs":U).

    IMPORT cLine.
    DO WHILE cLine[1] NE "FR":U:
      IMPORT cLine.
    END.

    /* Have found the frame record, get its dimensions */
    IMPORT cLine.
    ASSIGN dWidth  = DECIMAL(cLine[6]) / 100
           dHeight = DECIMAL(cLine[7]) / 100.
    IF dWidth > hFrame:WIDTH OR dHeight > hFrame:HEIGHT THEN DO:
      /* Window needs to be enlarged */

      FIND w_U WHERE w_U._handle = _h_win.       /* Get the window _U */
      FIND w_L WHERE w_L._u-recid = RECID(w_U).  /* Get window _L     */
      FIND f_U WHERE f_U._handle = _h_win.       /* Get the frame _U  */
      FIND f_L WHERE f_L._u-recid = RECID(w_U).  /* Get frame _L      */

      IF dWidth > hFrame:WIDTH THEN
        ASSIGN _h_win:WIDTH        = dWidth
               hFrame:WIDTH        = dWidth
               w_L._WIDTH          = dWidth
               w_L._VIRTUAL-WIDTH  = MAX(w_L._VIRTUAL-WIDTH, dWidth)
               f_L._WIDTH          = dWidth
               f_L._VIRTUAL-WIDTH  = MAX(f_L._VIRTUAL-WIDTH, dWidth).


      IF dHeight > hFrame:HEIGHT THEN
        ASSIGN _h_win:HEIGHT       = dHeight
               hFrame:HEIGHT       = dHeight
               w_L._HEIGHT         = dHeight
               w_L._VIRTUAL-HEIGHT = MAX(w_L._VIRTUAL-HEIGHT, dHeight)
               f_L._HEIGHT         = dWidth
               f_L._VIRTUAL-HEIGHT = MAX(f_L._VIRTUAL-HEIGHT, dHeight).

    END.  /* IF the window needs to get bigger */

    INPUT CLOSE.
    OS-DELETE VALUE(SESSION:TEMP-DIR + "scratch.qs":U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-create_a_SmartBrowser) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE create_a_SmartBrowser Procedure 
PROCEDURE create_a_SmartBrowser :
/*------------------------------------------------------------------------------
  Purpose:  To create a SmartBrowser from the fields picked in the Wizard.   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE ret-msg  AS CHARACTER                 NO-UNDO.
  DEFINE VARIABLE iw       AS INTEGER                   NO-UNDO.
  DEFINE VARIABLE hSDO     AS HANDLE                    NO-UNDO.
  DEFINE VARIABLE i        AS INTEGER                   NO-UNDO.
  
  /* Find the dummy browser created by the template */
  FIND _U WHERE _U._WINDOW-HANDLE = _h_win AND
                _U._TYPE = "BROWSE".
  FIND _C WHERE RECID(_C)  = _U._x-recid.
  FIND _P WHERE _P._WINDOW-HANDLE = _h_win.
  
  /* Set up _Q record - two cases use the query built against the database
     if that is the case, or define the query if going against the SDO     */
  FIND _Q WHERE RECID(_Q) = _C._q-recid.
  IF _Q._4GLQury = "" THEN DO: /* This is the SDO case */
    ASSIGN _Q._tblList    = "rowObject"
           _Q._4GLQury    = "EACH rowObject"
           _Q._OptionList = RIGHT-TRIM(REPLACE(_Q._OptionList, "KEY-PHRASE", ""))
           _Q._OptionList = RIGHT-TRIM(REPLACE(_Q._OptionList, "SORTBY-PHRASE", "")).
           /* KeyPhrase and SortBy options are not needed for SDB's defined
              w/ SDO */

    /* Get the handle of the SDO */
    hSDO = get-proc-hdl(_P._data-object).
    DO i = 1 TO NUM-ENTRIES(gcFields):
      CREATE _BC.
      /* Need separate ASSIGN for key */
      ASSIGN _BC._x-recid      = RECID(_U).
      ASSIGN
             _BC._NAME         = ENTRY(i,gcFields)
             _BC._DATA-TYPE    = dynamic-function("columnDataType" IN hSDO,_BC._NAME)
             _BC._DBNAME       = "_<SDO>"
             _BC._DEF-FORMAT   = dynamic-function("columnFormat" IN hSDO,_BC._NAME)
             _BC._DEF-HELP     = dynamic-function("columnHelp" IN hSDO,_BC._NAME)
             _BC._DEF-LABEL    = dynamic-function("columnColumnLabel" IN hSDO,_BC._NAME)
             _BC._DEF-WIDTH    = MAX(dynamic-function("columnWidth" IN hSDO,_BC._NAME),
                                              FONT-TABLE:GET-TEXT-WIDTH(ENTRY(1,_BC._DEF-LABEL,"!":U)))
             _BC._DISP-NAME    = _BC._NAME
             _BC._FORMAT       = _BC._DEF-FORMAT
             _BC._HELP         = _BC._DEF-HELP
             _BC._LABEL        = _BC._DEF-LABEL
             _BC._WIDTH        = _BC._DEF-WIDTH
             _BC._SEQUENCE     = i
             _BC._TABLE        = "rowObject".
      IF NUM-ENTRIES(_BC._DEF-LABEL,"!":U) > 1 THEN DO:
        DO iw = 2 TO NUM-ENTRIES(_BC._DEF-LABEL,"!":U):
          ASSIGN _BC._DEF-WIDTH = MAX(_BC._DEF-WIDTH, 
                                     FONT-TABLE:GET-TEXT-WIDTH(ENTRY(iw,_BC._DEF-LABEL,"!":U)))
                 _BC._WIDTH     = _BC._WIDTH.
        END.
      END.  /* IF Stacked Columns */
    END.  /* Loop through the fields */

    IF VALID-HANDLE(_U._PROC-HANDLE) THEN RUN destroyOBJECT IN _U._PROC-HANDLE.
    ret-msg = shutdown-proc(_P._data-object).
  END.  /* SDO CASE */

  IF VALID-HANDLE(_U._HANDLE) THEN DELETE WIDGET _U._HANDLE.
  RUN adeuib\_undbrow.p (RECID(_U)).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-create_a_SmartViewer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE create_a_SmartViewer Procedure 
PROCEDURE create_a_SmartViewer :
/*------------------------------------------------------------------------------
  Purpose:    Generate a SmartDataViewer from th fields picked in the Wizard 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VAR ctmp         AS CHARACTER NO-UNDO.
    DEFINE VAR hframe       AS HANDLE    NO-UNDO.
    DEFINE VAR drawn        AS LOGICAL   NO-UNDO.
    DEFINE VAR upd-fields   AS CHARACTER NO-UNDO.
    DEFINE VAR iField      AS INTEGER   NO-UNDO.
    
    DEFINE VARIABLE cField  AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cName   AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cBuffer AS CHARACTER  NO-UNDO.

    DEFINE BUFFER X_U FOR _U. 

    IF gcFields = '':U THEN RETURN.
    
    /* Update _TT for DataObject */
    FIND _P WHERE _P._WINDOW-HANDLE = _h_win. 
    
    RUN adeuib/_upddott.w(RECID(_P)).

    /* Get handle of the SmartViewer frame. */
    RUN adeuib/_uibinfo.p (INPUT ?, INPUT "FRAME ?", INPUT "HANDLE", OUTPUT ctmp).

    /* Setup frame for drawing fields on it. */
    ASSIGN hframe = WIDGET-HANDLE(ctmp)
           _frmx = 0
           _frmy = 0
           _second_corner_x = hframe:WIDTH-P
           _second_corner_y = hframe:HEIGHT-P.  

    /* If the field names are not qualified with a table */
    IF NUM-ENTRIES(ENTRY(1,gcFields),".") LE 1 THEN
      /* Before drawing, must add in RowObject table name. */
      ASSIGN gcFields = "RowObject.":U + gcFields
             gcFields = REPLACE(gcFields, ",", ",RowObject.":u).
           
    /* Generate the file to import and draw the fields with by calling _drwflds.p and
       then using _qssuckr.p to import that file. */
    RUN adeuib/_drwflds.p (INPUT gcFields, INPUT-OUTPUT drawn, OUTPUT ctmp).
    IF drawn THEN
    DO:
      SESSION:NUMERIC-FORMAT = "AMERICAN":U.
      RUN adjustWindowSize(INPUT ctmp,    /* Name of scratch file created by _drwflds.p */
                           INPUT hframe). /* Handle of new frame to be adjusted         */
      RUN adeuib/_qssuckr.p (ctmp, "", "IMPORT":U, TRUE).
      SESSION:SET-NUMERIC-FORMAT(_numeric_separator,_numeric_decimal).

      /* When drawing a data field for an object that is using a SmartData
        object, set the data field's Enable property based on the data object
        getUpdatableColumns. Must do this here since its not picked up automatically
        in the temp-table definition like format and label.  jep-code 4/29/98 */
      IF gcEnableObjects = ? THEN
      DO:
        RUN setDataFieldEnable IN _h_uib (INPUT RECID(_P)).
      END.
      ELSE DO iField = 1 TO NUM-ENTRIES(gcFields):
        ASSIGN
          cField  = ENTRY(iField,gcFields)
          cBuffer = IF NUM-ENTRIES(cField,".":U) > 1
                    THEN ENTRY(1,cField,".":U)
                    ELSE "RowObject":U.
        /* if not enabled then disable */
        IF LOOKUP(cBuffer,gcEnableObjects) = 0 THEN
        DO:
          cName   = ENTRY(NUM-ENTRIES(cField,".":U),cField,".":U).
          FIND x_U WHERE x_U._WINDOW-HANDLE = _h_win
                   AND   x_U._DBNAME = "Temp-Tables":U
                   AND   x_U._TABLE  = cBuffer
                   AND   x_U._NAME   = cName NO-ERROR.
          IF AVAIL X_U THEN
            x_U._ENABLE = NO.
         
        END. /* IF LOOKUP(cField,gcEnableFields) = 0 THEN */
      END.

      /* set the file-saved state to false */
      RUN adeuib/_winsave.p (_h_win, FALSE).
      /* Delete the temporary file */
      OS-DELETE VALUE(ctmp) NO-ERROR.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

