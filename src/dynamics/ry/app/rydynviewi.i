&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" Include _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
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
/*---------------------------------------------------------------------------------
  File: rydynviewi.i

  Description:  Dynamic Viewer Temp-table Definition Inc

  Purpose:      Dynamic Viewer Temp-table Definition Include

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:   101000006   UserRef:    
                Date:   08/16/2001  Author:     Peter Judge

  Update Notes: Created from Template ryteminclu.i

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* Astra 2 object identifying preprocessor */
&glob   AstraInclude    yes

/* These are generic attributes for all widgets. */
DEFINE TEMP-TABLE ttWidget          NO-UNDO             RCODE-INFORMATION
    /* Key data */
    FIELD tWidgetType           AS CHARACTER        /* visualisation */
    FIELD tWidgetHandle         AS HANDLE
    FIELD tTargetProcedure      AS HANDLE
    /* DB.Table.Field related stuff */
    FIELD tTableName            AS CHARACTER    INITIAL ?
    /* Size, Position */
    FIELD tWidth                AS DECIMAL      INITIAL ?      /*} These are all in CHARACTER units.   */
    FIELD tRow                  AS DECIMAL      INITIAL ?      /*}                                     */
    FIELD tEndRow               AS DECIMAL      INITIAL ?      /*} Used when repositioning widgets     */
    FIELD tColumn               AS DECIMAL      INITIAL ?      /*}                                     */
    FIELD tTabOrder             AS INTEGER      INITIAL ?
    /* General Attributes */
    FIELD tTranslated           AS LOGICAL
    FIELD tVisible              AS LOGICAL      INITIAL ?      /* Use the VISIBLE attribute instead of HIDDEN. */
    FIELD tFont                 AS INTEGER      INITIAL ?
    FIELD tInitialValue         AS CHARACTER    INITIAL ?
    /* Label-related stuff */
    FIELD tLabel                AS CHARACTER    INITIAL ?        /* A value of ? means that the NO-LABEL option is specified. */
    INDEX idxTabOrder
        tTargetProcedure
        tTabOrder
    INDEX idxWidgetHandle
        tWidgetHandle
        tVisible
        tTargetProcedure
    INDEX idxTranslation
        tTargetProcedure
        tTranslated
        tColumn.

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
         HEIGHT             = 6
         WIDTH              = 49.8.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
