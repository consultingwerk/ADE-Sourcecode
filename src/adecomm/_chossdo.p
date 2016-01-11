&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
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
    File        : adecomm/_chossdo.p
    Purpose     : Start the Choose SO dialog-box to choose a SmartDataObject.  
  
  Input Parameters:
     pcShowOptions (char) - Buttons to enable in the Choose SO dialog-box.
                            
                            BROWSE, NEW, PREVIEW 
                            
                            Avoid the use of NEW if this is called from a 
                            WIZARD, because NEW will try to call another wizard.
                            This does not work. 
                            
     plWeb         (log)  - Yes for WEB. 
                            The dialog will check the development mode and 
                            search remotely or locally accordingly.     
                          - No - always search locally
  Input-Output Parameters:
     piocDataObject(char) - Filename of selected SmartDataObject.
                            There's no real use of the input value 
                            except that it is returned unchanged if the dialog
                            is cancelled.    
  
  Description   : Reads info to use as input to the dialog from  .cst definitions.  
                   
  Author: Håvard Danielsen 

  Created: 06/22/99
  
  Note:    The object type "SmartDataObject" is a constant.
           The reason is that it isn't a parameter is that the SDO is the
           only SO that needs to be read outside of the AppBuilder
           and also the only one that need to be read from a remote file system.                 
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
  DEFINE INPUT        PARAMETER pcShowOptions  AS CHARACTER NO-UNDO.
  DEFINE INPUT        PARAMETER plWeb          AS LOGICAL   NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER piocDataObject AS CHARACTER NO-UNDO.
  
  
  DEFINE VARIABLE lCancelled  AS LOGICAL              NO-UNDO.
  DEFINE VARIABLE cOtherthing AS CHARACTER            NO-UNDO.
  DEFINE VARIABLE cAttributes AS CHARACTER            NO-UNDO.  
  DEFINE VARIABLE cTemplate   AS CHARACTER            NO-UNDO.  
  DEFINE VARIABLE cObjLabel   AS CHARACTER            NO-UNDO.  
  DEFINE VARIABLE cDataObject AS CHARACTER            NO-UNDO.  
 
  DEFINE VARIABLE xcSmartDataObject AS CHAR NO-UNDO INIT "SmartDataObject":U.

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

  RUN adeuib/_uibinfo.p (
      INPUT ?,
      INPUT "PALETTE-ITEM ":U + xcSmartDataObject,
      INPUT "ATTRIBUTES":U,
      OUTPUT cAttributes).
  
  /* Get template if the NEW button is shown */
    
  IF CAN-DO(pcShowOptions,"NEW":U) THEN
    RUN adeuib/_uibinfo.p (
       INPUT ?,
       INPUT "PALETTE-ITEM ":U + xcSmartDataObject,
       INPUT "TEMPLATE":U,
       OUTPUT cTemplate).
  
  cDataObject = piocDataObject.
  IF cAttributes <> "":U THEN
  DO:
    RUN adecomm/_chosobj.w (
        INPUT (IF plweb THEN "WEB":U  
               ELSE "SmartObject":U),           
        INPUT cAttributes,
        INPUT cTemplate,
        INPUT  pcShowOptions,
        OUTPUT piocDataObject,
        OUTPUT cOtherThing,
        OUTPUT lCancelled).
   
    /* Reset if cancelled */
    IF lCancelled THEN 
      piocDataObject = cDataObject.
    
    /* Remove 'current directory' period and replace backslashes with slash */  
    ELSE DO:
      piocDataObject = REPLACE(piocDataObject,"~\":U,"/":U).
      IF piocDataObject BEGINS "./":U THEN        
        piocDataObject = SUBSTR(piocDataObject,3).
    END.
  END. /* IF cAttributes <> "" */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


