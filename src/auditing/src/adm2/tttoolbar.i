&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
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
  File: ttdynmenu.i

  Description:  Dynamic Menus Temp Tables

  Purpose:      Dynamic Menus Temp Tables

  Parameters:   <none>

  Modified: 11/08/2001 - Mark Davies (MIP)
            Removed XFTR for version updates
-----------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */



/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       tttoolbar.i
&scop object-version    000000

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
         HEIGHT             = 5.57
         WIDTH              = 64.4.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

&IF DEFINED(tttoolbar) = 0 &THEN
  DEFINE TEMP-TABLE ttBand NO-UNDO      
      FIELD Band                     AS CHARACTER FORMAT "x(28)":U
      FIELD BandType                 AS CHAR FORMAT "x(12)":U
      FIELD BandLabelAction          AS CHARACTER FORMAT "x(12)":U
      FIELD SystemOwned              AS LOG
      FIELD Hidden                   AS LOG
      FIELD Module                   AS CHARACTER FORMAT "x(12)"
      FIELD ButtonSpacing            AS INT
      FIELD ButtonPadding            AS INT        
      FIELD ProcedureHandle          AS HANDLE      
      INDEX Band AS UNIQUE  Band ProcedureHandle 
      INDEX ProcedureHandle ProcedureHandle.

  DEFINE TEMP-TABLE ttBandAction NO-UNDO
      FIELD Band                     AS CHARACTER FORMAT "x(28)":U
      FIELD Action                   AS CHARACTER FORMAT "x(12)":U
      FIELD ChildBand                AS CHARACTER FORMAT "x(28)":U
      FIELD Sequence                 AS INTEGER
      FIELD Cached                   AS LOGICAL
      FIELD ProcedureHandle          AS HANDLE     
      INDEX Band AS UNIQUE  Band Sequence ProcedureHandle            
      INDEX Childband       Childband
      INDEX Action          Action Band
      INDEX ProcedureHandle ProcedureHandle.

  /* temp table of which menu structures used by object
     NB: if object does not use any menu strutures, a record with no band 
     will be added to temp-table for object to prevent it from going and 
     checking in the database again to see if it needs any menu structures.
  */
  
  DEFINE TEMP-TABLE ttObjectBand NO-UNDO     
      FIELD ObjectName    AS CHARACTER FORMAT "x(15)"
      FIELD RunAttribute  AS CHARACTER FORMAT "x(15)"
      FIELD ResultCode    AS CHARACTER                /* This field is required for customization of menus on a container - part of the unique primary index */
      FIELD Sequence      AS INTEGER  
      FIELD Action        AS CHAR 
      FIELD Band          AS CHARACTER FORMAT "x(28)"
      FIELD InsertSubmenu AS LOGICAL       
      INDEX key1 AS PRIMARY UNIQUE ObjectName RunAttribute ResultCode Sequence      
      INDEX key2 Band ObjectName RunAttribute
      INDEX key3 Action ObjectName RunAttribute Sequence.

  /* temp-table of menu structures - for client caching in toolbars */
  DEFINE TEMP-TABLE ttToolbarBand NO-UNDO      
      FIELD ToolbarName AS CHARACTER FORMAT "x(15)"
      FIELD Band        AS CHARACTER FORMAT "x(28)" 
      FIELD Alignment   AS CHARACTER
      FIELD RowPosition AS CHARACTER
      FIELD Sequence    AS INTEGER  
      FIELD Spacing     AS INTEGER
      FIELD InsertRule  AS LOGICAL      
      FIELD ResultCode  AS CHARACTER
      INDEX key1 AS UNIQUE PRIMARY ToolbarName Sequence ResultCode
      INDEX key2 AS UNIQUE Band toolbarName.

  &GLOBAL-DEFINE tttoolbar
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


