&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*--------------------------------------------------------------------------
    File        : _setwatr.w
    Purpose     : To set individual attributes of widgets inside the AppBuilder

    Syntax      : RUN adeuib/_setwatr.w (pi_context, pc_attribute, pc_value,
                                         OUTPUT pl_status).

    Description : The first 3 attributes are input values.
                  pi_context   is the context id of the object or widget that
                               has the attribute that needs to be set.
                  pc_attribute is the name of the attribute to be set.
                      Current possibilities are:
                      "DataObject" - the filename of the DataObject
                                     that is associated with the 
                                     procedure pointed to by 
                                     pi_context
                     "HTMLFileName" - the filename of the HTML File
                                     that is associated with the 
                                     procedure pointed to by 
                                     pi_context
                     "Data-Logic-Proc"  - the name of the associated
                                          data logic procedure
                     "Data-Logic-Proc-Template"  - the name of the associated
                                          data logic procedure template to use for generation
                     "RowObject-NO-UNDO" - Use NO-UNDO for RowObject definition option                     
                     
                  pc_value     is the value that pc_attribute will be set to.
                  pl_status    (OUTPUT) - TRUE if the value was successfully set.

    Author(s)   : Ross Hunter
    Created     : 2/10/98
    
    Notes       :
   
    Modified    : 2/18/98  Haavard Danielsen
                  Added HTMLFileName  
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEFINE INPUT PARAMETER  pi_context   AS INTEGER                      NO-UNDO.
DEFINE INPUT PARAMETER  pc_attribute AS CHARACTER                    NO-UNDO.
DEFINE INPUT PARAMETER  pc_value     AS CHARACTER                    NO-UNDO.
DEFINE OUTPUT PARAMETER pl_status    AS LOGICAL    INITIAL YES       NO-UNDO.

{adeuib/uniwidg.i}

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
         HEIGHT             = 5.57
         WIDTH              = 65.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

CASE pc_attribute:
  WHEN "DataObject" THEN DO:
    FIND _P WHERE RECID(_P) eq pi_context NO-ERROR.
    IF AVAILABLE _P THEN _P._data-object = pc_value.
    ELSE pl_status = no.
  END. /* WHEN "DataObject" */
  WHEN "HTMLFileName" THEN DO:
    FIND _P WHERE RECID(_P) eq pi_context NO-ERROR.
    IF AVAILABLE _P THEN _P._HTML-File = pc_value.
    ELSE pl_status = no.
  END. /* WHEN "DataObject" */
  WHEN "DATA-LOGIC-PROC":U THEN
  DO:
      FIND _P WHERE RECID(_P) eq pi_context NO-ERROR.
      IF AVAILABLE _P THEN
         FIND _U WHERE _U._HANDLE = _P._WINDOW-HANDLE NO-ERROR.
      IF AVAILABLE _U THEN
         FIND _C WHERE RECID(_C) = _U._x-recid NO-ERROR.
      IF AVAILABLE _C THEN
         ASSIGN _C._DATA-LOGIC-PROC = pc_value.
  END.
  WHEN "DATA-LOGIC-PROC-NEW":U THEN
  DO:
      FIND _P WHERE RECID(_P) eq pi_context NO-ERROR.
      IF AVAILABLE _P THEN
         FIND _U WHERE _U._HANDLE = _P._WINDOW-HANDLE NO-ERROR.
      IF AVAILABLE _U THEN
         FIND _C WHERE RECID(_C) = _U._x-recid NO-ERROR.
      IF AVAILABLE _C THEN
         ASSIGN _C._DATA-LOGIC-PROC-NEW = LOGICAL(pc_value).
  END.
  WHEN "DATA-LOGIC-PROC-TEMPLATE":U THEN
  DO:
      FIND _P WHERE RECID(_P) eq pi_context NO-ERROR.
      IF AVAILABLE _P THEN
         FIND _U WHERE _U._HANDLE = _P._WINDOW-HANDLE NO-ERROR.
      IF AVAILABLE _U THEN
         FIND _C WHERE RECID(_C) = _U._x-recid NO-ERROR.
      IF AVAILABLE _C THEN
         ASSIGN _C._DATA-LOGIC-PROC-TEMPLATE = pc_value.
  END.
  WHEN "RowObject-NO-UNDO":U THEN
  DO:
      FIND _P WHERE RECID(_P) EQ pi_context NO-ERROR.
      IF AVAILABLE _P THEN
          FIND _U WHERE _U._HANDLE = _P._WINDOW-HANDLE NO-ERROR.
      IF AVAILABLE _U THEN
          FIND _C WHERE RECID(_C) = _U._x-recid NO-ERROR.
      IF AVAILABLE _C THEN
          ASSIGN _C._RowObject-NO-UNDO = LOGICAL(pc_value).
  END.

END.  /* Case on pc_attribute */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


