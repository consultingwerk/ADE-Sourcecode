&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*************************************************************/
/* Copyright (c) 1984-2007 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : smartcustom.i
    Purpose     : References the start of the custom super procedure.
                  Allows properties initialization.

    Syntax      : {src/adm2/custom/smartcustom.i}

    Description :

    Created     : 06/03/1999
    Notes       : Referenced in {src/adm2/smart.i}
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

/* Start the custom super procedure from here unless supers are loaded from 
   repository which case the custom super need to be stored in repository
   and loaded from there.  
   
   Uncomment to run it */   
   
/* IF NOT {&ADM-LOAD-FROM-REPOSITORY} THEN
     RUN start-super-proc ("adm2/custom/smartcustom.p":U).*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




&IF DEFINED(EXCLUDE-start-super-proc) = 0 &THEN

&GLOBAL-DEFINE EXCLUDE-start-super-proc

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE start-super-proc Method-Library 
PROCEDURE start-super-proc :
/*------------------------------------------------------------------------------
  Purpose:     Procedure to start a super proc if it's not already running, 
               and to add it as a super proc in any case.
  Parameters:  Procedure name to make super.
  Notes:       NOTE: This presumes that we want only one copy of an ADM
               super procedure running per session, meaning that they are 
               stateless and "multi-threaded". This is intended to be the case
               for ours, but may not be true for all super procs.
            -  The LAST-SUPER-PROCEDURE-PROP preprocessor allows classes
               to specify a property of char or handle that stores
               super-procedures that need to be kept at the bottom of the list 
               (defined by data.i and sbo.i if they are extended by other classes)        
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcProcName AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE hProc             AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iPos              AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cFile             AS CHARACTER  NO-UNDO.

  /* We no run the ADM2 under auditing/adm2. So need to adjust relative path to file
     name and also the file names are now prefixed with "aud_".
  */
  ASSIGN /* find the file name */
         iPos = R-INDEX(pcProcName,"/")
		 iPos = (IF Ipos < 0 THEN R-INDEX(pcProcName,"\") ELSE iPos)
		 /* get the file name */
         cFile = SUBSTRING(pcProcName,iPos + 1)
		 /* now add the prefix for the file name */
         pcProcName = "auditing/":U + REPLACE(pcProcName,cFile,"aud_" + cFile).	

  hProc = SESSION:FIRST-PROCEDURE.
  DO WHILE VALID-HANDLE(hProc) AND hProc:FILE-NAME NE pcProcName:
    hProc = hProc:NEXT-SIBLING.
  END.
  IF NOT VALID-HANDLE(hProc) THEN
    RUN VALUE(pcProcName) PERSISTENT SET hProc.
  

     &IF '{&LAST-SUPER-PROCEDURE-PROP}':U <> '':U &THEN
  DEFINE VARIABLE cLast    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hLast    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iLast    AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cSupers  AS CHARACTE   NO-UNDO.
  DEFINE VARIABLE cRemoved AS CHARACTER  NO-UNDO.
  
  cLast = DYNAMIC-FUNCTION('get' + '{&LAST-SUPER-PROCEDURE-PROP}':U) NO-ERROR.
  IF cLast > '':U THEN
  DO:
    cSupers = THIS-PROCEDURE:SUPER-PROCEDURES. 
    DO iLast = 1 TO NUM-ENTRIES(cLast):
      hLast = WIDGET-HANDLE(ENTRY(iLast,cLast)). 
      IF VALID-HANDLE(hLast) AND LOOKUP(STRING(hLast),cSupers) > 0 THEN
      DO:
        THIS-PROCEDURE:REMOVE-SUPER-PROCEDURE(hLast).
        cRemoved = cRemoved 
                   + (IF cRemoved = '':u THEN '':U ELSE ',':U)
                   +  STRING(hLast). 
      END.
    END.
  END.
     &ENDIF

  THIS-PROCEDURE:ADD-SUPER-PROCEDURE(hProc, SEARCH-TARGET).
     
     &IF '{&LAST-SUPER-PROCEDURE-PROP}':U <> '':U &THEN
  IF cRemoved > '':U THEN
  DO:
    DO iLast = NUM-ENTRIES(cRemoved) TO 1:
      hLast = WIDGET-HANDLE(ENTRY(iLast,cRemoved)). 
      IF VALID-HANDLE(hLast) THEN
        THIS-PROCEDURE:ADD-SUPER-PROCEDURE(hLast, SEARCH-TARGET).
    END.
  END.
     &ENDIF
  
  RETURN.
  
END PROCEDURE.


&ENDIF


/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


