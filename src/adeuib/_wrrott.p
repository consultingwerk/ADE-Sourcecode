&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------
    File        : adeuib/_wrrott.p
    Purpose     : To write out a proper RowObject Temp-Table Definition

    Syntax      : RUN adeuib/_wrrott.p (INPUT cQueryRec)

    Description : When building a scratch file for syntax checking for an
                  SDO, _wrrott.p gets called to generate a RowObject
                  TEMP-TABLE definition.

    Author(s)   : Ross Hunter
    Created     : 10/16/98
    Notes       : This is necessary because adeshar/_calcfld.p is called 
                  from both the AppBuilder and Results and therefore has
                  no understanding of the _BC records necessary for this
                  function.

  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEFINE INPUT PARAMETER cQueryRec AS CHARACTER                     NO-UNDO.

DEFINE VARIABLE rQueryRec        AS INTEGER                       NO-UNDO.

{adeuib/sharvars.i}
{adeuib/brwscols.i}

/* Function Prototypes */
FUNCTION db-fld-name RETURNS CHARACTER
  (INPUT rec-type AS CHARACTER, INPUT rec-recid AS RECID) IN _h_func_lib.

DEFINE SHARED STREAM P_4GL.

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
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

ASSIGN rQueryRec = INTEGER(cQueryRec).  /* Convert character string to INT */

PUT STREAM P_4GL UNFORMATTED
  "DEFINE TEMP-TABLE RowObject   NO-UNDO" + CHR(10).
  
FOR EACH _BC WHERE _BC._x-recid = rQueryRec:
  IF _BC._DBNAME <> "_<CALC>":U THEN
    PUT STREAM P_4GL UNFORMATTED
        "  FIELD ":U + _BC._DISP-NAME + " LIKE ":U + 
                       db-fld-name("_BC":U, RECID(_BC)) + CHR(10).
  ELSE
    PUT STREAM P_4GL UNFORMATTED
        "  FIELD ":U + _BC._DISP-NAME + " AS ":U + 
                       CAPS(_BC._DATA-TYPE) + CHR(10).
END.
PUT STREAM P_4GL UNFORMATTED "  ." + CHR(10) + CHR(10).

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


