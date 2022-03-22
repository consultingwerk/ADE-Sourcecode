&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/********************************************************************   *
* Copyright (C) 2005-2006 by Progress Software Corporation.  All rights *
* reserved.  Prior versions of this work may contain portions           *
* contributed by participants of Possenet.                              *
************************************************************************/
/*--------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

&SCOPED-DEFINE USE-3D           YES

{adecomm/adestds.i}             /* Standards for "Sullivan Look"            */
{adeuib/uniwidg.i}              /* Universal widget definition              */
{adeuib/layout.i}               /* Definitions of the layout records        */
{adeuib/property.i}             /* Temp-Table containing attribute info     */
{adeuib/triggers.i}             /* Trigger Temp-table definition            */
{adeuib/uibhlp.i}               /* Help pre-processor directives            */
{adeuib/sharvars.i}             /* The shared variables                     */

&IF DEFINED(ADEICONDIR) = 0 &THEN
 {adecomm/icondir.i}
&ENDIF

&SCOPED-DEFINE datatypes CHARACTER,DATE,DATETIME,DATETIME-TZ,DECIMAL,LOGICAL,INTEGER,INT64,RECID

DEFINE INPUT  PARAM p_U_Type   AS CHAR  NO-UNDO.
DEFINE INPUT  PARAM p_F-Rowid  AS ROWID NO-UNDO.
DEFINE INPUT  PARAM p_New-Type AS CHAR  NO-UNDO.

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
   Other Settings: CODE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 19.48
         WIDTH              = 77.4.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

RUN data-type_change.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-data-type_change) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE data-type_change Procedure 
PROCEDURE data-type_change :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VAR formats       AS CHAR                    NO-UNDO.
  DEFINE VAR i             AS INTEGER                 NO-UNDO.
  DEFINE VAR raw-value     AS CHAR                    NO-UNDO.
  DEFINE VAR tmp-strng     AS CHAR                    NO-UNDO.
  DEFINE VAR tmp-value     AS CHAR                    NO-UNDO.

  FIND _F WHERE ROWID(_F) = p_F-Rowid.
    
  /* The FORMATS variable store the format to use for each DATA-TYPE.  Store   */
  /* the existing format in the ENTRY of the existing data-type.  Then set the */
  /* new DATA-TYPE and get the default value for the format again.  Formats is */
  /* a CHR(10) delimited list of formats to use for each data-type.            */
  ASSIGN formats       =
            REPLACE ("X(8)|99/99/99|99/99/9999 HH:MM:SS.SSS|99/99/9999 HH:MM:SS.SSS+HH:MM|->>,>>9.99|yes/no|->,>>>,>>9|->,>>>,>>9|>>>>>>9":U,
                     "|":U,CHR(10))
         i             = LOOKUP(_F._DATA-TYPE, "{&datatypes}")
         ENTRY(i,formats,CHR(10)) = _F._FORMAT
         _F._DATA-TYPE = p_New-Type
         i             = LOOKUP(_F._DATA-TYPE, "{&datatypes}")
         _F._FORMAT    = ENTRY(i,formats,CHR(10)).

  CASE _F._DATA-TYPE:
    WHEN "CHARACTER":U THEN
      ASSIGN _F._INITIAL-DATA = _F._INITIAL-DATA.
    WHEN "LOGICAL":U   THEN 
      ASSIGN _F._INITIAL-DATA = "No".
    WHEN "DECIMAL"   THEN
    DO:
      ASSIGN _F._INITIAL-DATA = STRING(DECIMAL(TRIM(_F._INITIAL-DATA))) NO-ERROR.
      IF ERROR-STATUS:ERROR THEN _F._INITIAL-DATA = "0".
    END.
    WHEN "INTEGER":U   THEN
    DO:
      ASSIGN _F._INITIAL-DATA = STRING(INTEGER(TRIM(_F._INITIAL-DATA))) NO-ERROR.
      IF ERROR-STATUS:ERROR THEN _F._INITIAL-DATA = "0".
    END.
    WHEN "INT64":U   THEN
    DO:
      ASSIGN _F._INITIAL-DATA = STRING(INT64(TRIM(_F._INITIAL-DATA))) NO-ERROR.
      IF ERROR-STATUS:ERROR THEN _F._INITIAL-DATA = "0".
    END.
    WHEN "RECID":U THEN
      ASSIGN _F._INITIAL-DATA = "?".
    OTHERWISE                             
     ASSIGN _F._INITIAL-DATA = ?.
  END CASE.

  /* A radio set - try to morph the values */
  IF p_U_TYPE = "RADIO-SET":U THEN
  DO:
    ASSIGN _F._INITIAL-DATA = TRIM(_F._INITIAL-DATA)
           tmp-strng        = "".
    DO i = 1 to NUM-ENTRIES(_F._LIST-ITEMS,CHR(10)):
      ASSIGN raw-value = TRIM(TRIM(ENTRY(2,ENTRY(i,_F._LIST-ITEMS,CHR(10)))),"~"").
      CASE _F._DATA-TYPE:
        WHEN "CHARACTER" THEN
          ASSIGN tmp-value = "~"" + raw-value + "~"," + CHR(10).
        WHEN "LOGICAL" THEN
          ASSIGN tmp-value = (IF i = 1 THEN "Yes," ELSE
                              IF i = 2 THEN "No,"  ELSE "?,") + CHR(10).
        WHEN "INTEGER" THEN DO:
          ASSIGN tmp-value = STRING(INTEGER(raw-value)) NO-ERROR.
          IF NOT ERROR-STATUS:ERROR AND tmp-value NE ? THEN
            tmp-value = tmp-value + "," + CHR(10).
          ELSE tmp-value = "?," + CHR(10).
        END.
        WHEN "INT64" THEN DO:
          ASSIGN tmp-value = STRING(INT64(RAW-VALUE)) NO-ERROR.
          IF NOT ERROR-STATUS:ERROR AND tmp-value NE ? THEN
            tmp-value = tmp-value + "," + CHR(10).
          ELSE tmp-value = "?," + CHR(10).
        END.
        WHEN "DECIMAL" THEN DO:
          ASSIGN tmp-value = STRING(DECIMAL(raw-value)) NO-ERROR. 
          IF NOT ERROR-STATUS:ERROR AND tmp-value NE ? THEN
            tmp-value = tmp-value + "," + CHR(10).
          ELSE tmp-value = "?," + CHR(10).
        END.
        WHEN "RECID" THEN 
          ASSIGN tmp-value = "?," + CHR(10).   
        WHEN "DATE" THEN
          ASSIGN tmp-value = (IF i = 1 THEN STRING(TODAY) ELSE "?") + "," + CHR(10).
        WHEN "DATETIME" OR WHEN "DATETIME-TZ" THEN
          ASSIGN tmp-value = (IF i = 1 THEN STRING(NOW) ELSE "?") + "," + CHR(10).
         
      END CASE.
      ASSIGN tmp-strng = tmp-strng +
                         ENTRY(1,ENTRY(i,_F._LIST-ITEMS,CHR(10))) + ", " + tmp-value.
   END.
   ASSIGN _F._LIST-ITEMS       = TRIM(TRIM(tmp-strng,CHR(10)),",")
          tmp-strng            = _F._INITIAL-DATA
          _F._INITIAL-DATA     = ?.
   DO i = 1 TO NUM-ENTRIES(_F._LIST-ITEMS,CHR(10)):
     IF tmp-strng = ENTRY(2,ENTRY(i,_F._LIST-ITEMS,CHR(10)))
        THEN _F._INITIAL-DATA = tmp-strng.
   END. 
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

