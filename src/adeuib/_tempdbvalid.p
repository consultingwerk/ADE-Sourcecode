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
    File        : adeuib/_Tempdbvalid.p
    Purpose     : Checks that the connected TEMP-DB database contains
                  the control table 'TEMP-DB-CTRL'.

    Syntax      :

    Description :

    Author(s)   : Don Bulua
    Created     : 05/01/2004
    Notes       : Requires A TEMP-DB connection
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
&IF DEFINED(UIB_is_Running) = 0 &THEN
    DEFINE OUTPUT PARAMETER plValid AS LOGICAL NO-UNDO.
&ELSE
  DEFINE VARIABLE plValid AS LOGICAL NO-UNDO.
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
         HEIGHT             = 4.29
         WIDTH              = 47.8.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
 FIND TEMP-DB._db WHERE TEMP-DB._db._db-name = ? 
                    AND TEMP-DB._db._db-type = "PROGRESS" NO-LOCK NO-ERROR. /*local */
 IF NOT AVAIL TEMP-DB._db THEN
     RETURN "ERROR":U.

 FIND TEMP-DB._FILE NO-LOCK
     WHERE TEMP-DB._File._DB-recid  = RECID(TEMP-DB._db)
       AND TEMP-DB._FILE._File-Name = "temp-db-ctrl":U  NO-ERROR.

 IF AVAIL TEMP-DB._FILE THEN
     plValid = Yes.
 ELSE
     plValid = No.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


