&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
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
    File        :  ttaction.i
    Purpose     :  Ations for menus, toolbars etc.

    Syntax      :  src/adm2/ttaction.i

    Description :  This temp-table stores actions for all objects
    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

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

&IF DEFINED(ttaction) = 0 &THEN
  
  DEFINE TEMP-TABLE ttCategory NO-UNDO
      FIELD item_category_obj       AS DECIMAL
      FIELD Category                AS CHAR  FORMAT "x(25)":U
      FIELD ParentCategory          AS CHAR  FORMAT "x(25)":U
      FIELD SystemOwned             AS LOG   
      FIELD Link                    AS CHAR FORMAT "x(12)":U
      FIELD ProcedureHandle         AS HANDLE
      INDEX Category        AS UNIQUE Category ProcedureHandle
      INDEX ProcedureHandle           ProcedureHandle
      INDEX ParentName                ParentCategory Category
      INDEX idxDuplicateCheck         item_category_obj.
      
  DEFINE TEMP-TABLE ttAction NO-UNDO 
      FIELD menu_item_obj            AS DECIMAL
      FIELD Action                   AS CHAR FORMAT "x(12)":U
      FIELD Name                     AS CHAR FORMAT "x(15)":U
      FIELD Caption                  AS CHAR FORMAT "x(25)":U
      FIELD Tooltip                  AS CHAR FORMAT "x(35)":U
      FIELD Parent                   AS CHAR FORMAT "x(12)":U
      FIELD Category                 AS CHAR FORMAT "x(25)":U
      FIELD SubstituteProperty       AS CHAR FORMAT "x(25)":U
      FIELD Image                    AS CHAR FORMAT "x(25)":U
      FIELD ImageDown                AS CHAR FORMAT "x(25)":U
      FIELD ImageInsensitive         AS CHAR FORMAT "x(25)":U
      FIELD Image2                   AS CHAR FORMAT "x(25)":U
      FIELD Image2Down               AS CHAR FORMAT "x(25)":U
      FIELD Image2Insensitive        AS CHAR FORMAT "x(25)":U
      FIELD Accelerator              AS CHAR FORMAT "x(25)":U
      FIELD Description              AS CHAR FORMAT "x(40)":U
      FIELD AccessType               AS CHAR FORMAT "x(25)":U
      FIELD SecurityToken            AS CHAR FORMAT "x(25)":U
      FIELD EnableRule               AS CHAR FORMAT "x(70)":U
      FIELD DisableRule              AS CHAR FORMAT "x(70)":U
      FIELD HideRule                 AS CHAR FORMAT "x(70)":U
      FIELD ImageAlternateRule       AS CHAR FORMAT "x(70)":U
      FIELD Disabled                 AS LOG
      FIELD Link                     AS CHAR FORMAT "x(12)":U
      FIELD Type                     AS CHAR FORMAT "x(8)":U
      FIELD ControlType              AS CHAR FORMAT "x(15)":U
      FIELD InitCode                 AS CHAR FORMAT "x(25)":U
      FIELD createEvent              AS CHAR FORMAT "x(25)":U
      FIELD Refresh                  AS LOG
      FIELD OnChoose                 AS CHAR FORMAT "x(25)":U
      FIELD RunParameter             AS CHAR FORMAT "x(12)":U
      FIELD Order                    AS INT  FORMAT "zz9"
      FIELD RunAttribute             AS CHARACTER
      FIELD PhysicalObjectName       AS CHARACTER
      FIELD LogicalObjectName        AS CHARACTER
      FIELD RunPersistent            AS LOGICAL
      FIELD DbRequiredList           AS CHARACTER
      FIELD Module                   AS CHARACTER FORMAT "x(12)"
      FIELD SystemOwned              AS LOG
      FIELD ProcedureHandle          AS HANDLE
      INDEX Action         AS UNIQUE Action ProcedureHandle
      INDEX ProcedureHandle          ProcedureHandle
      INDEX Link                     Link Action
      INDEX Parent                   Parent   ProcedureHandle Order
      INDEX Category                 Category
      INDEX idxDuplicateCheck        menu_item_obj.
      
  &GLOBAL-DEFINE ttaction
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


