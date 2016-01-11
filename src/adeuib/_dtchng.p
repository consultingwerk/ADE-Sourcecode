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

&SCOPED-DEFINE datatypes CHARACTER,DATE,DECIMAL,LOGICAL,INTEGER,RECID

DEFINE INPUT  PARAM p_U_Type   AS CHAR  NO-UNDO.
DEFINE INPUT  PARAM p_F-Rowid  AS ROWID NO-UNDO.
DEFINE INPUT  PARAM p_New-Type AS CHAR  NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure



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
         HEIGHT             = 2
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

RUN data-type_change.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

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
            REPLACE ("X(8)|99/99/99|->>,>>9.99|yes/no|->,>>>,>>9|>>>>>>9":U,
                     "|":U,CHR(10))
         i             = LOOKUP(_F._DATA-TYPE, "{&datatypes}")
         ENTRY(i,formats,CHR(10)) = _F._FORMAT
         _F._DATA-TYPE = p_New-Type
         i             = LOOKUP(_F._DATA-TYPE, "{&datatypes}")
         _F._FORMAT    = ENTRY(i,formats,CHR(10)).

  CASE _F._DATA-TYPE:
    WHEN "CHARACTER" THEN
      ASSIGN _F._INITIAL-DATA = _F._INITIAL-DATA.
    WHEN "LOGICAL"   THEN 
      ASSIGN _F._INITIAL-DATA = "No".
    WHEN "DECIMAL"   THEN
    DO:
      ASSIGN _F._INITIAL-DATA = STRING(DECIMAL(TRIM(_F._INITIAL-DATA))) NO-ERROR.
      IF ERROR-STATUS:ERROR THEN _F._INITIAL-DATA = "0".
    END.
    WHEN "INTEGER"   THEN
    DO:
      ASSIGN _F._INITIAL-DATA = STRING(INTEGER(TRIM(_F._INITIAL-DATA))) NO-ERROR.
      IF ERROR-STATUS:ERROR THEN _F._INITIAL-DATA = "0".
    END.
    WHEN "RECID" THEN
      ASSIGN _F._INITIAL-DATA = "?".
    OTHERWISE                             
     ASSIGN _F._INITIAL-DATA = ?.
  END CASE.

  /* A radio set - try to morph the values */
  IF p_U_TYPE = "RADIO-SET" THEN
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

