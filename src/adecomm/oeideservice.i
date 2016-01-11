/*************************************************************/
/* Copyright (c) 1984-2006 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : oeideservice.i
    Purpose     : Function prototypes for oeideservice.p

    Syntax      : {adecomm/oeideservice.i}

    Description : 

    Author(s)   : egarcia
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
  
  
/* Code is only included once */

&IF DEFINED(OEIDESERVICE_I) = 0 &THEN
&GLOBAL-DEFINE OEIDESERVICE_I

/* ***************************  Definitions  ************************** */

/* 
 * OEIDEIsRunning	Flag indicating that the OpenEdge IDE is running
 * hOEIDEService	Handle to the oeideservice.p persistent procedure
 */
DEFINE NEW GLOBAL SHARED VAR OEIDEIsRunning AS LOGICAL    NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR hOEIDEService  AS HANDLE     NO-UNDO.

DEFINE VARIABLE cProcName                   AS CHARACTER  NO-UNDO INITIAL "adecomm/oeideservice.p":U.


/* ********************  Preprocessor Definitions  ******************** */

&GLOBAL-DEFINE VIEW_ACTIVATE 1
&GLOBAL-DEFINE VIEW_VISIBLE  2
&GLOBAL-DEFINE VIEW_CREATE   3


/* **********************  Forward Declarations  ********************** */

&IF DEFINED(OEIDE-EXCLUDE-PROTOTYPES) = 0 &THEN

FUNCTION showView RETURNS LOGICAL 
         (viewId      AS CHARACTER,
          secondaryId AS CHARACTER,
          mode        AS INTEGER)
         IN hOEIDEService.

FUNCTION hideView RETURNS LOGICAL 
         (viewId      AS CHARACTER,
          secondaryId AS CHARACTER)
         IN hOEIDEService.
         
FUNCTION setViewTitle RETURNS LOGICAL 
         (viewId      AS CHARACTER,
          secondaryId AS CHARACTER,
          viewTitle   AS CHARACTER)
         IN hOEIDEService.         

FUNCTION displayEmbeddedWindow RETURNS LOGICAL 
         (viewId      AS CHARACTER,
          secondaryId AS CHARACTER,
          hWindow     AS HANDLE)
         IN hOEIDEService.

FUNCTION setEmbeddedWindow RETURNS LOGICAL 
         (viewId      AS CHARACTER,
          secondaryId AS CHARACTER,
          hWindow     AS HANDLE)
         IN hOEIDEService.
         
FUNCTION getProjectName RETURNS CHARACTER 
         ()
         IN hOEIDEService.
         
FUNCTION openEditor RETURNS LOGICAL 
         (projectName  AS CHARACTER,
          fileName     AS CHARACTER,
          tempFileName AS CHARACTER,
          windowHandle AS HANDLE)
         IN hOEIDEService.         

FUNCTION saveEditor RETURNS LOGICAL 
         (projectName   AS CHARACTER,
          fileName      AS CHARACTER,
          ask_file_name AS LOGICAL)
         IN hOEIDEService.         

FUNCTION closeEditor RETURNS LOGICAL 
         (projectName  AS CHARACTER,
          fileName     AS CHARACTER,
          saveChanges  AS LOGICAL)
         IN hOEIDEService.         

FUNCTION findAndSelect RETURNS LOGICAL 
         (projectName  AS CHARACTER,
          fileName     AS CHARACTER,
          cText        AS CHARACTER,
          activateEditor AS LOGICAL)
         IN hOEIDEService.         

FUNCTION createLinkedFile RETURNS CHARACTER 
         (user_chars   AS CHARACTER,
          extension    AS CHARACTER)
         IN hOEIDEService. 
                           
&ENDIF
                           
/* ***************************  Main Block  *************************** */

OEIDEIsRunning = IF OS-GETENV("OEA_PORT":U) > "" THEN TRUE ELSE FALSE.
IF OEIDEIsRunning AND NOT VALID-HANDLE(hOEIDEService) THEN
DO:
    /* Check to see if OEIDEService is already running */
    hOEIDEService = SESSION:FIRST-PROCEDURE.
    DO WHILE VALID-HANDLE(hOEIDEService) 
         AND hOEIDEService:FILE-NAME <> cProcName:
       hOEIDEService = hOEIDEService:NEXT-SIBLING.
    END.
    IF NOT VALID-HANDLE(hOEIDEService) THEN
        RUN VALUE(cProcName) PERSISTENT SET hOEIDEService.
END.

&ENDIF

