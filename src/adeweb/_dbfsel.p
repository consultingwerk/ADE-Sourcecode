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

/*----------------------------------------------------------------------------

File: _dbfsel.p

Description:
    Allow user to map and unmap HTML Fields and Database Fields.
    Mapping is down via the Field Selector dialog.

Note:
    
Input Parameters:
    h_self : The handle of the _U object to be mapped or unmapped.

    p_Option :
        "_SELECT"
            Prompt for field to map to and do the mapping.
        
        "_SELECT-AUTO"
            Do not prompt for a field, but do the mapping using the
            current _U values in _DBNAME, _TABLE, and _NAME.

        "_DESELECT"
            Unmap the field from a database field.
            
Output Parameters:
   <None>

Author: J. Palazzo

Date Created: May, 1996

Changed: 2/12/98  HD   
                 Updated to be compatible with _fldinfo.p 
                 (description, valexp, valmsg, valmsg_sa , mandatory)         
         Mars 98  HD   
                  Added logic for SmartDataObjects.  
         4/6/98   HD 
                  Added logic for remote SmartDataObjects.
                  A call to get-sdo-hdl creates the persistent sdo if its 
                  the first time in this context. 
                  If its called from _automap it uses getDataSourceHandle
                  to get the handle of _automap's SOURCE-PROCEDURE.
                  in other cases it uses its own SOURCE-PROCEDURE.    
                  By using the SOURCE-PROCEDURE as input to that function 
                  the SDO will stay alive until the SOURCE-PROCEDURE
                  calls shutdown-sdo.
            NOTE: Because the SDO remote pretender runs a HTTP OCX that 
                  requires a wait-for, this part must be kept outside of the 
                  get-sdo-hdl function, this is solved by RUN initializeObject 
                  in the SDO if its remote. 
                 (We might consider making a get-sdo-hdl procedure instead,
                  but I did not know where to put it)                                                    
----------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER p_self   AS WIDGET                            NO-UNDO.
DEFINE INPUT PARAMETER p_Option AS CHARACTER                         NO-UNDO.

/* Define a SKIP for alert-boxes that only exists under Motif */
&Global-define SKP &IF "{&WINDOW-SYSTEM}" = "OSF/Motif" &THEN SKIP &ELSE &ENDIF

{adecomm/adestds.i}             /* Standards for "Sullivan Look"            */
{adeuib/uniwidg.i}              /* Universal widget definition              */

{adeuib/layout.i}               /* Definitions of the layout records        */
{adeuib/uibhlp.i}               /* Help pre-processor directives            */
{adeuib/sharvars.i}             /* The shared variables                     */
{adeweb/htmwidg.i}              /* WEB/HTML related temp-tables             */

DEFINE VARIABLE  name         AS    CHAR    NO-UNDO.
DEFINE VARIABLE  hDataObject  AS    HANDLE  NO-UNDO.

DEFINE VARIABLE  gSourceHdl   AS    HANDLE  NO-UNDO.

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
         HEIGHT             = 2
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

ASSIGN gSourceHdl = SOURCE-PROCEDURE.

RUN FieldSelection NO-ERROR.

IF ERROR-STATUS:ERROR THEN RETURN ERROR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FieldSelection Procedure 
PROCEDURE FieldSelection :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VAR ans             AS LOGICAL       NO-UNDO.
  DEFINE VAR use_Prefix      AS INTEGER       NO-UNDO.
  DEFINE VAR def_var         AS CHAR          NO-UNDO  INITIAL
             "CHARACTER,DATE,DECIMAL,LOGICAL,INTEGER,RECID".              
  DEFINE VAR pressed_ok      AS LOGICAL       NO-UNDO.
  DEFINE VAR fld_name        AS CHAR          NO-UNDO.
  DEFINE VAR fld_save        AS CHAR          NO-UNDO.
  DEFINE VAR fmt             AS CHAR          NO-UNDO.
  DEFINE VAR db_name         AS CHAR          NO-UNDO.
  DEFINE VAR tbl_name        AS CHAR          NO-UNDO.
  DEFINE VAR fld_type        AS CHAR          NO-UNDO.
  DEFINE VAR fld_help        AS CHAR          NO-UNDO.
  DEFINE VAR fld_help_sa     AS CHAR          NO-UNDO.
  DEFINE VAR fld_label       AS CHAR          NO-UNDO.
  DEFINE VAR fld_label_sa    AS CHAR          NO-UNDO.
  DEFINE VAR fld_format      AS CHAR          NO-UNDO.
  DEFINE VAR fld_format_sa   AS CHAR          NO-UNDO.
  DEFINE VAR fld_extent      AS INTEGER       NO-UNDO.
  DEFINE VAR fld_readonly    AS LOGICAL       NO-UNDO.
  DEFINE VAR fld_index       AS INTEGER       NO-UNDO.
  DEFINE VAR fld_initial     AS CHARACTER     NO-UNDO.
  DEFINE VAR fld_description AS CHARACTER     NO-UNDO.
  DEFINE VAR fld_valexp      AS CHARACTER     NO-UNDO.
  DEFINE VAR fld_valmsg      AS CHARACTER     NO-UNDO.
  DEFINE VAR fld_valmsg_sa   AS CHARACTER     NO-UNDO.
  DEFINE VAR fld_mandatory   AS CHARACTER     NO-UNDO.
  DEFINE VAR old-dt          AS CHARACTER     NO-UNDO.
  DEFINE VAR tmp-name        AS CHARACTER     NO-UNDO.
  DEFINE VAR UsesDataOBject  AS LOG           NO-UNDO.
  DEFINE VAR tt-info         AS CHAR          NO-UNDO.
  DEFINE VAR tbl_list        AS CHAR          NO-UNDO.
  DEFINE VAR num_ent         AS INT           NO-UNDO.
  DEFINE VAR num_count       AS INT           NO-UNDO.
  DEFINE VAR show_items      AS CHAR          NO-UNDO.
  
      
  DEFINE BUFFER ip_U FOR _U.
 
  /* Find related temp-tables */
  FIND _U WHERE _U._HANDLE = p_self.
  FIND _L WHERE RECID(_L) = _U._lo-recid.
  FIND _P WHERE _P._WINDOW-HANDLE eq _U._WINDOW-HANDLE.
  FIND _F WHERE RECID(_F) = _U._x-recid NO-ERROR.
  
  /** This cannot happen for HTML mapping  (HD)(?)
      
  IF NOT AVAILABLE _F THEN
  DO:
    FIND _C WHERE RECID(_C) = _U._x-recid.
    IF _C._q-recid NE ? THEN 
       FIND _Q WHERE RECID(_Q) = _C._q-recid NO-ERROR.
  END.
  */
  
  FIND _HTM WHERE _HTM._U-RECID = RECID(_U).

  /* Text widgets are not changeable in an alternative layout */
  IF _U._TYPE = "TEXT" AND _U._LAYOUT-NAME NE "Master Layout" THEN
  DO:
    /* Text widgets are not changeable in an alternative layout */
    MESSAGE "Text objects may only be modified in the Master Layout." SKIP
            "Use a fill-in with the VIEW-AS-TEXT attribute instead."
        VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    RETURN.
  END.

  IF _U._TYPE = "EDITOR"              THEN def_var = "CHARACTER".
  ELSE IF _U._TYPE = "SELECTION-LIST" THEN def_var = "CHARACTER".
  ELSE IF _U._TYPE = "SLIDER"         THEN def_var = "INTEGER".
  ELSE IF _U._TYPE = "TOGGLE-BOX"     THEN def_var = "LOGICAL".

  ASSIGN 
    old-dt         = _F._DATA-TYPE
    UsesDataObject = (_P._DATA-OBJECT <> "").
  
  IF p_Option BEGINS "_SELECT":U THEN
  DO:
    
    IF NUM-DBS > 0 Or _remote_file THEN ans = YES.
    ELSE RUN adecomm/_dbcnnct.p
              (INPUT  "You must have at least one connected database to select a field.",
               OUTPUT ans).
    IF ans <> YES THEN RETURN.
    
    ASSIGN db_name = "Temp-Tables":U.
      /* Build the temp-table info to pass to the field picker. */
             tbl_name = "".
      
    IF CAN-FIND(FIRST _TT WHERE _TT._p-recid = RECID(_P)
                AND  _TT._NAME <> '{&WS-TEMPTABLE}') THEN
    DO:
      FOR EACH _TT WHERE _TT._p-recid = RECID(_P)
                   AND _TT._NAME <> '{&WS-TEMPTABLE}':
         tt-info = tt-info + ",":U + _TT._LIKE-DB + ".":U + _TT._LIKE-TABLE +
                    "|":U + (IF _TT._NAME = ? THEN "?":U ELSE _TT._NAME).
         tbl_name = tbl_name + (IF _TT._NAME = ? THEN _TT._LIKE-TABLE ELSE _TT._NAME) + ",".
      END.
      tt-info = LEFT-TRIM(tt-info,",":U).
      tbl_name = TRIM(tbl_name, ",":U).
      
    END.
    ELSE tt-info = ?.
      
    ASSIGN 
      fld_name   = _U._NAME
      pressed_ok = TRUE.
          
    IF UsesDataObject = NO THEN
    DO:  
      ASSIGN
        db_name    = _U._DBNAME
        tbl_name   = _U._TABLE
        use_Prefix = ?.
   
      IF p_Option = "_SELECT":U THEN
      DO:
         RUN adecomm/_fldsel.p (FALSE,
                                IF NUM-ENTRIES(def_var) > 1 THEN ? ELSE def_var,
                                tt-info,
                                INPUT-OUTPUT use_Prefix,
                                INPUT-OUTPUT db_name, 
                                INPUT-OUTPUT tbl_name,
                                INPUT-OUTPUT fld_name,
                                OUTPUT pressed_ok).
                       
                                
         IF pressed_ok <> TRUE THEN RETURN. /* WEB-JEP 5/30/96 */
       END.
    END.   
    ELSE
    DO:
      
      IF p_option = "_SELECT-AUTO" THEN
        hDataObject = DYNAMIC-FUNC("getDataObjecthandle" IN gSourceHdl). 
      ELSE
        hDataObject = DYNAMIC-FUNC("get-sdo-hdl" IN _h_func_lib, 
                                    INPUT _P._DATA-OBJECT,
                                    gSourceHdl).
      IF NOT VALID-HANDLE(hDataObject) THEN
      DO:
        MESSAGE "Unable to start data object " _P._DATA-OBJECT "."
                      VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
        RETURN ERROR.
      END.
      IF _remote_file THEN 
      DO:
        RUN initializeObject IN hDataObject NO-ERROR.         
        IF ERROR-STATUS:ERROR THEN RETURN ERROR.
      END.
             
      IF tbl_name = "" OR tbl_name = ? THEN
      DO:
        MESSAGE "Unable to determine data source information."
               VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
        RETURN ERROR.
      END.
        
      ASSIGN num_ent  = NUM-ENTRIES(tbl_name)
             tbl_list = tbl_name.
             
      IF p_Option = "_SELECT":U 
      AND num_ent > 0 THEN
      DO:
        /* Get a list of "database.table,database.table" */
        DO num_count = 1 TO num_ent:
          ENTRY(num_count, tbl_list) = db_name + "." + ENTRY(num_count, tbl_name).
        END.
        /* If user does not have any temp-tables defined other than RowObject,
           display only the field name. Otherwise, display table.field.  jep-code */
        ASSIGN show_items = (IF NUM-ENTRIES(tbl_list) <= 1 THEN "1":U
                                                           ELSE "2":U).
        RUN adecomm/_fldseld.p
            (INPUT tbl_list, 
             INPUT hDataObject, 
             INPUT tt-info, 
              show_items, 
              ",",
             INPUT IF NUM-ENTRIES(def_var) > 1 THEN ? ELSE def_var /* data-type */,
             INPUT-OUTPUT fld_name).
             
        num_ent = NUM-ENTRIES(fld_name).
        
        ASSIGN pressed_ok = (RETURN-VALUE <> "CANCEL":U) AND (num_ent > 0).
        
        /* At this point, fld_name is in the form Temp-Tables.RowObject.Fieldname.
           Strip out what we need. jep-code */
        IF pressed_OK THEN
          ASSIGN tbl_name = ENTRY(2, fld_name, ".":U) 
                 fld_name = ENTRY(3, fld_name, ".":U) NO-ERROR.
      END.
    END.
    
    IF pressed_ok AND LENGTH(fld_name,"RAW":U) > 0 THEN
    DO:
          /* Verify that this field is not already in the same frame */
          FIND ip_U WHERE ip_U._HANDLE ne p_self
                      AND ip_U._STATUS ne "DELETED":U
                      AND ip_U._DBNAME eq db_name
                      AND ip_U._TABLE  eq tbl_name
                      AND ip_U._NAME   eq fld_name
                      AND ip_U._PARENT eq _U._PARENT NO-ERROR.
                      
          IF AVAILABLE ip_U THEN 
          DO: 
              
              MESSAGE 
                 (IF UsesDataObject 
                  THEN
                  "The SmartDataObject field" + " ":U + fld_name
                  ELSE              
                  "The database field" + " ":U
                  + ( db_name + "." + tbl_name + "." + fld_name)
                  )                                    
                  "is already in the current frame.":T SKIP
                  "It cannot be connected to a second object in the":T
                  "same frame.":T
                            
                  VIEW-AS ALERT-BOX ERROR BUTTONS OK.
             RETURN ERROR.
          END.
          ELSE
          DO:
            /* Mark .w file as changed, so user is warned of they try and
               close file without saving changes. */
            RUN adeuib/_winsave.p (_U._WINDOW-HANDLE, FALSE).

            /* Did the user return an array element? If so, parse it for the
              variable (fld_save) and the array index (fld_index). */
            IF (fld_name MATCHES ("*[*]"))
              THEN ASSIGN fld_save  = SUBSTRING (fld_name, INDEX (fld_name, "[") + 1,
                                           -1,"CHARACTER":U)
                          fld_index = INTEGER (REPLACE (fld_save, "]", ""))
                          fld_save  = SUBSTRING (fld_name, 1, INDEX (fld_name, "[") - 1,
                                              "CHARACTER":U)
                          fld_label = fld_name.
              ELSE ASSIGN fld_save  = fld_name
                          fld_index = ?.
            IF UsesDataObject THEN 
            DO:
              fld_format   = DYNAMIC-FUNC("columnFormat" IN hDataObject, fld_save ) NO-ERROR.
              fld_help     = DYNAMIC-FUNC("columnHelp" IN hDataObject, fld_save ) NO-ERROR.
              fld_type     = DYNAMIC-FUNC("columnDataType" IN hDataObject, fld_save ) NO-ERROR.
              fld_initial  = DYNAMIC-FUNC("columnIntial" IN hDataObject, fld_save ) NO-ERROR.            
              fld_ReadOnly = DYNAMIC-FUNC("columnReadOnly" IN hDataObject, fld_save ) NO-ERROR.                             
            END.        
            ELSE  
              RUN adeuib/_fldinfo.p 
                      (db_name,
                       tbl_name, 
                       fld_save,
                       OUTPUT fld_label,
                       OUTPUT fld_label_sa,
                       OUTPUT fld_format,
                       OUTPUT fld_format_sa, 
                       OUTPUT fld_type,
                       OUTPUT fld_help,   
                       OUTPUT fld_help_sa,   
                       OUTPUT fld_extent,
                       OUTPUT fld_initial,
                       OUTPUT fld_description,
                       OUTPUT fld_valexp,
                       OUTPUT fld_valmsg, 
                       OUTPUT fld_valmsg_sa,
                       OUTPUT fld_mandatory).                       
            IF fld_type <> old-dt THEN
              RUN adeuib/_dtchng.p
                  (INPUT _U._TYPE, INPUT ROWID(_F), fld_type).
            
            ASSIGN _U._NAME          = fld_name
                   _U._DBNAME        = db_name
                   _U._TABLE         = tbl_name
                   _U._BUFFER        = tbl_name
                                     /* fld_readonly can only be TRUE for SDO's */
                   _U._ENABLE        = NOT fld_readonly
                   _F._SUBSCRIPT     = fld_index
                   _U._HELP          = fld_help
                   _U._HELP-ATTR     = fld_help_sa
                   _F._DATA-TYPE     = CAPS(fld_type)
                   _F._FORMAT        = fld_format
                   _F._FORMAT-ATTR   = fld_format_sa
                   _F._FORMAT-SOURCE = "D"
                   _U._HELP-SOURCE   = "D"
                   _U._DEFINED-BY    = "TOOL":U
                   _F._INITIAL-DATA  = fld_initial.
          
            /* Add the Index to the Label */
            IF fld_index NE ? 
            THEN _U._LABEL = _U._LABEL + 
                             "[":U + LEFT-TRIM(STRING(fld_index,">>>>>>>9")) + "]":U.
            /* Remove unknown values */
            IF _F._FORMAT-ATTR EQ ? THEN _F._FORMAT-ATTR = "".
            IF _U._LABEL-ATTR EQ ?  THEN _U._LABEL-ATTR = "".
            IF _U._HELP-ATTR EQ ?   THEN _U._HELP-ATTR = "".
  
            /* Tack on the table and db name to the end of the widget name */
            ASSIGN name = _U._NAME.
            IF _suppress_dbname THEN 
              ASSIGN name = name + " (" + _U._TABLE + ")".
            ELSE
              ASSIGN name = name + " (" + _U._DBNAME + "." + _U._TABLE + ")".
          END.
    END.      
  END. /* If p_option BEGINS "_SELECT" */ 
      
  ELSE IF p_Option = "_DESELECT":U THEN
  DO:
        /* Mark .w file as changed, so user is warned of they try and
           close file without saving changes. */
        RUN adeuib/_winsave.p (_U._WINDOW-HANDLE, FALSE).

        ASSIGN  _U._DBNAME          = ?
                _U._TABLE           = ?
                _U._BUFFER          = ?
                _F._SUBSCRIPT       = ?
                _U._NAME            = REPLACE(_HTM._HTM-NAME,' ':U,'_':U)
                _U._NAME            = REPLACE(_U._NAME,'.':U,'_':U)
                /* WEB-JEP _U._TYPE + "_" + ENTRY(1,_U._NAME,"[") */

                _U._LABEL-SOURCE    = "E"
                _F._FORMAT-SOURCE   = "E"
                _U._HELP-SOURCE     = "E" 
                _U._HELP          = ""
                _U._HELP-ATTR     = ""
                _F._INITIAL-DATA  = "".
                           
    END. /* IF _U._DBNAME <> ? */
/***
    /* Put this field in the query definition */
    RUN adeuib/_vrfyqry.p (INPUT _h_frame,
                           INPUT "ADD-FIELDS":U,
                           INPUT _U._DBNAME + "." + _U._TABLE + "." + _U._NAME).
                      
***/

/*********
  /* SEW call to update widget name and label in SEW if necessary. */
  RUN call_sew IN _h_uib ( INPUT "SE_PROPS" ).
**********/
/******  HD No labels in version 3 
  /* Update the label in the design window. */
  RUN adeuib/_showlbl.p (_U._HANDLE).
*****/

       
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

