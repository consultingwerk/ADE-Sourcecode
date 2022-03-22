&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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
  define variable cProjects as character no-undo.
  define variable cDirs as character no-undo.
  define variable iPos as integer no-undo.
  DEFINE VARIABLE xcSmartDataObject AS CHAR NO-UNDO INIT "SmartDataObject":U.

{adecomm/oeideservice.i}
function getRequestContext returns char () in hOEIDEService.

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
    if OEIDE_CanLaunchDialog() then
    do:    
        IF ENTRY(1,cAttributes,CHR(10)) BEGINS "DIRECTORY-LIST" THEN 
        DO:
            cProjects = getRequestContext().          
            /** if shared projects add them to directory list (replace  current if applicable)  */
            if cProjects > "" then 
            do:
                cDirs = TRIM(SUBSTRING(TRIM(ENTRY(1,cAttributes,CHR(10))),15,-1,"CHARACTER")).
                iPos = lookup(".",cDirs).
                if(iPos > 0) then
                do:
                    entry(iPos,cDirs) = cProjects. 
                end.    
                else do:
                    cDirs = cProjects + "," + cDirs.
                end.
                ENTRY(1,cAttributes,CHR(10)) = "DIRECTORY-LIST" + " " + cDirs.
            end.    
        END. 
        
        RUN adeuib/ide/_dialog_chosobj.p(
            INPUT (IF plweb THEN "WEB":U  
                   ELSE "SmartObject":U),           
            INPUT cAttributes,
            INPUT cTemplate,
            INPUT  pcShowOptions,
            OUTPUT piocDataObject,
            OUTPUT cOtherThing,
            OUTPUT lCancelled).
    end.
    else do:
         RUN adecomm/_chosobj.w (
            INPUT (IF plweb THEN "WEB":U  
                   ELSE "SmartObject":U),           
            INPUT cAttributes,
            INPUT cTemplate,
            INPUT  pcShowOptions,
            OUTPUT piocDataObject,
            OUTPUT cOtherThing,
            OUTPUT lCancelled).  
    end.
         
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


