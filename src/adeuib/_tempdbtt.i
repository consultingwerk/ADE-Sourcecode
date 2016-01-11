&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
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
    File        : adeuib/_tempdbtt.i
    Purpose     : TempTable definitions for tempdb maintenance

    Syntax      :

    Description :

    Author(s)   : Don Bulua
    Created     : 05/01/2004
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEFINE TEMP-TABLE tttempDB 
    FIELD ttProcedure        AS HANDLE
    FIELD ttTableID          AS CHAR
    FIELD ttTableName        AS CHAR COLUMN-LABEL "Table Name" FORMAT "X(25)"
    FIELD ttSourceFile       AS CHAR LABEL "Source File" FORMAT "X(30)"
    FIELD ttTableDate        AS DATETIME LABEL "Date Modified" FORMAT "99/99/9999 HH:MM:SS AM"
    FIELD ttFileDate         AS DATETIME FORMAT "99/99/9999 HH:MM:SS AM"
    FIELD ttFileChanged      AS LOGICAL LABEL "File Changed"
    FIELD ttUseInclude       AS LOG LABEL "Use Include"
    FIELD ttEntityImported   AS LOG
    FIELD ttStatus           AS CHAR LABEL "Status" FORMAT "X(100)"
    FIELD ttStatusCode       AS CHAR
    FIELD ttUserModified     AS CHARACTER FORMAT "X(15)" LABEL "User"
    INDEX ttIDX IS PRIMARY ttProcedure ttTableID 
    INDEX ttIdxName ttProcedure ttTableName
    INDEX ttIdxFile ttProcedure ttSourceFile
    .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Include
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Include ASSIGN
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


