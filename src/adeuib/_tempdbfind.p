&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
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
/*------------------------------------------------------------------------
    File        : adeuib/_Tempdbfind
    Purpose     : Find the record in the control table and return
                  the either the Source file if the UseInclude flag is set 
                  to Yes, or whether the specified input source file is in
                  the control table

    Parameters  : pcType  TABLE  Assumes pcInput is a Table in the control 
                                 table and returns the source file if UseInclude 
                                 flag is set to Yes.
                          SOURCE Assumes pcInput is a SOurce file (relatively pathed)
                                 and returns 'yes' if the source file is found in the 
                                 control table.
                 pcInput  If pctype= 'TABLE', this is the table to find
                          If pcType = "SOURCE", this is the  source file
                          (relatively pathed) or ('yes' or 'no') 
         OUTPUT  pcOutput If pcType = "TABLE", the corresponding source file is returned
                          If pcType = Source,the coprresponding tables are returned.                  

    Description :

    Author(s)   : Don Bulua
    Created     : 05/01/2004
    Notes       : Requires A TEMP-DB connection
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
&IF DEFINED(UIB_is_Running) = 0 &THEN
  DEFINE INPUT  PARAMETER pcType    AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER pcInput   AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER pcOutput AS CHARACTER NO-UNDO.
&ELSE
  DEFINE VARIABLE pcType    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE pcInput   AS CHARACTER  NO-UNDO .
  DEFINE VARIABLE pcOutput  AS CHARACTER  NO-UNDO.
&ENDIF

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
         HEIGHT             = 4.43
         WIDTH              = 46.8.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
 
 /* Find the control record. If the UseInclude is set to YES, return 
    the source file . */
 IF pcType = "TABLE":U THEN
 DO:
    FIND FIRST TEMP-DB.temp-db-ctrl 
         WHERE TEMP-DB.temp-db-ctrl.TableName = pcInput NO-LOCK NO-ERROR.
    IF AVAILABLE TEMP-DB.temp-db-ctrl THEN
        pcOutput = IF TEMP-DB.temp-db-ctrl.UseInclude 
                   THEN TEMP-DB.temp-db-ctrl.SourceFile
                   ELSE "".
    ELSE
        pcOutput = "".

 END.
 /* Find all tables used by the specified source */
 ELSE IF pcType = "SOURCE":U THEN
 DO :
   /* Ensure forward slashes are specified */
   ASSIGN pcInput = REPLACE(pcInput,"~\", "~/").
   FOR EACH TEMP-DB.temp-db-ctrl 
         WHERE TEMP-DB.temp-db-ctrl.SourceFile = pcInput NO-LOCK:
       pcOutput = pcOutput + (IF pcOutput = "" THEN "" ELSE ",") 
                           + TEMP-DB.temp-db-ctrl.TableName.
   END.
 END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


