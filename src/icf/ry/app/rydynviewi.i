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

/* This static temp-table stores the dynamic temp-table table-handles of the
 * temp-tables which will be used to store attributes information about a
 * specified object instance of a particular widget type. 
 */
DEFINE TEMP-TABLE ttWidgetTable         NO-UNDO
    FIELD tWidgetType       AS CHARACTER
    FIELD tTableHandle      AS HANDLE    
    INDEX idxWidgetType
        tWidgetType
    .
/* These are generic attributes for all widgets. */
DEFINE TEMP-TABLE ttWidget          NO-UNDO             RCODE-INFORMATION
    /* Key data */
    FIELD tWidgetType           AS CHARACTER        /* visualisation */
    FIELD tWidgetName           AS CHARACTER
    FIELD tWidgetHandle         AS HANDLE
    FIELD tFrameHandle          AS HANDLE
    FIELD tObjectInstanceObj    AS DECIMAL
    /* DB.Table.Field related stuff */
    FIELD tTableName            AS CHARACTER
    FIELD tDatabaseName         AS CHARACTER
    FIELD tDataType             AS CHARACTER
    FIELD tDataSource           AS CHARACTER
    /* ADM2 stuff */
    FIELD tEnabled              AS LOGICAL      /*}  Used to build replacement &ENABLED- and &DISPLAYED-    */
    FIELD tDisplayField         AS LOGICAL      /*}  -OBJECTS and -FIELDS preprocessor lists.               */
    /* Size, Position */
    FIELD tHeight               AS DECIMAL      /*}                                     */
    FIELD tWidth                AS DECIMAL      /*} These are all in CHARACTER units.   */
    FIELD tRow                  AS DECIMAL      /*}                                     */
    FIELD tColumn               AS DECIMAL      /*}                                     */
    FIELD tTabOrder             AS INTEGER
    /* General Attributes */
    FIELD tPrivateData          AS CHARACTER
    FIELD tVisible              AS LOGICAL      /* Use the VISIBLE attribute instead of HIDDEN. */
    FIELD tFormat               AS CHARACTER
    FIELD tFont                 AS INTEGER
    FIELD tTooltip              AS CHARACTER
    FIELD tInitialValue         AS CHARACTER
    /* Label-related stuff */
    FIELD tLabel                AS CHARACTER        /* A value of ? means that the NO-LABEL option is specified. */
    FIELD tLabelWidth           AS DECIMAL
    FIELD tLabelFont            AS INTEGER
    FIELD tLabelBgColor         AS INTEGER
    FIELD tLabelFgColor         AS INTEGER
    /* SDF-specific stuff */
    FIELD tCustomSuperProc      AS CHARACTER
    INDEX idxObjectInstance
        tObjectInstanceObj
    INDEX idxTabOrder
        tTabOrder
    INDEX idxWidgetHandle
        tWidgetHandle
        tVisible
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
         HEIGHT             = 2
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


