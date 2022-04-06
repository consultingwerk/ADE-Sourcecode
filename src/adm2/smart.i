&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Method-Library 
/***********************************************************************
* Copyright (C) 2005-2006 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                      *
************************************************************************/
/*--------------------------------------------------------------------------
    Library     : smart.i - NEW V9 version of top-level SmartObject include

    Modified    : May 22, 2000 -- Version 9.1B
  ------------------------------------------------------------------------*/
/*          This .i file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

  /* If smart.i has already been included, skip everything 
      (matching ENDIF is at the end of the file). */
&IF DEFINED(adm-smart) = 0 &THEN
  &GLOB adm-smart yes
  
  /* Define the preprocessor that identifies the basic "class" of the object;
     ADMClass will remain undefined here only if the object uses no sub-class
     include files. */
  &IF "{&ADMClass}":U = "":U &THEN
    &GLOB ADMClass smart
  &ENDIF
    
  /* If this object is of type "smart", i.e., uses no lower class include
     files, then include the property file here. Otherwise this will be
     done in the class include file of the base class of the object. */

&IF "{&ADMClass}":U = "smart":U &THEN
  {src/adm2/smrtprop.i}
&ENDIF


 /* Window or Frame handle (not used, but kept for backwards comaptibility) */
DEFINE VARIABLE ghContainer AS HANDLE NO-UNDO.   
  &IF DEFINED(ADM-CONTAINER-HANDLE) &THEN
ghContainer = {&ADM-CONTAINER-HANDLE}.                                        
  &ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Method-Library
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Method-Library ASSIGN
         HEIGHT             = 8.62
         WIDTH              = 52.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Method-Library 
/* ************************* Included-Libraries *********************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Method-Library 


/* ***************************  Main Block  *************************** */
  
  &IF DEFINED(ADM-EXCLUDE-STATIC) = 0 &THEN
    IF NOT {&ADM-LOAD-FROM-REPOSITORY} THEN
      RUN start-super-proc ("adm2/smart.p":U).
  &ENDIF
  
  &IF DEFINED(ADM-EXCLUDE-STATIC) = 0 &THEN
  
    DEFINE VARIABLE cObjectName AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE iStart      AS INTEGER    NO-UNDO.

  /* Use the old adm definition */
  IF NOT {&ADM-PROPS-DEFINED} THEN
  DO:
    /* Now create the one record in this property temp-table, and store its
       handle in ADM-DATA. The CHR(1) delimiters are to set aside spots
       for UserProperties and UserLinks. */
    ghADMProps:TEMP-TABLE-PREPARE('ADMProps':U).
    ghADMPropsBuf = ghADMProps:DEFAULT-BUFFER-HANDLE.
    ghADMPropsBuf:BUFFER-CREATE().
    /* ... and save it. This ADM object is now open for business! */   
    THIS-PROCEDURE:ADM-DATA = STRING(ghADMPropsBuf) + CHR(1) + CHR(1).
    /* from this point  {&ADM-PROPS-DEFINED} is true for all cases */

    cObjectName =  '{&xcInstanceProperties}':U.
    {set InstanceProperties cObjectName}.

    /* Set the default object name to the simple procedure file name. */
    ASSIGN cObjectName = REPLACE(THIS-PROCEDURE:FILE-NAME, "~\":U, "~/":U)
           iStart = R-INDEX(cObjectName, "~/":U) + 1
           cObjectName =
                IF R-INDEX(THIS-PROCEDURE:FILE-NAME, ".":U) <= iStart THEN
                   SUBSTR(cObjectName, iStart)
                ELSE
                   SUBSTR(cObjectName,
                          iStart,
                          R-INDEX(THIS-PROCEDURE:FILE-NAME, ".":U) - iStart).
    {set ObjectName cObjectName}.    

      &IF DEFINED(ADM-CONTAINER-HANDLE) <> 0 &THEN
    {set ContainerHandle "{&adm-container-handle}"}.
      &ENDIF  
      
  END.
  
  ELSE DO:
  &ENDIF
  /* If this object is a generated object, then we set these properties 
     manually in the generated object
   */
  &if defined(adm-prepare-static-object) eq 0 &then
    /* Set the properties that get their value from preprocessor initial values
       in smrtprop.i (This is temporary until all of this is moved to the 
       repository/ or handled by the repository manager)*/
        
    /* (we steal the objectname to avoid adding variables to instances) */    
    &SCOPED-DEFINE xp-assign
    {set ObjectType "'{&PROCEDURE-TYPE}':U"}
    {set ContainerType "'{&ADM-CONTAINER}':U"}
    {set PhysicalVersion "'{&OBJECT-VERSION}':U"}
    {set PhysicalObjectName "(IF '{&OBJECT-NAME}':U <> '':U THEN '{&OBJECT-NAME}':U ELSE THIS-PROCEDURE:FILE-NAME)"}
    . 
    &UNDEFINE xp-assign
  &endif
            
   &IF DEFINED(ADM-EXCLUDE-STATIC) = 0 &THEN
  END. /* properties defined by repository manager */
  &ENDIF

  &IF DEFINED(ADM-EXCLUDE-STATIC) = 0 &THEN
  /* _ADM-CODE-BLOCK-START _CUSTOM _INCLUDED-LIB-CUSTOM CUSTOM */
  {src/adm2/custom/smartcustom.i}
  /* _ADM-CODE-BLOCK-END */
  &ENDIF

&IF DEFINED(include-destroyobject) = 0 &THEN
   &SCOPED-DEFINE exclude-destroyObject
&ELSE
   &SCOPED-DEFINE exclude-adm-clone-props
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-adm-clone-props) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-clone-props Method-Library 
PROCEDURE adm-clone-props :
/*------------------------------------------------------------------------------
     Purpose:  Clone the current adm property temp-table
  Parameters: 
       Notes:  This is used to clone the dynamic property record for static 
               objects that does not call deleteProperties from destroyObject
               in the target-procedure. This way the properties are kept alive 
               until destroyObject is completed without creating a memory leak,
               since this TT is created in the object's widget-pool.  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hReposBuffer AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hPropTable   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hBuffer      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTable       AS HANDLE     NO-UNDO.
  
  hReposBuffer = WIDGET-H(ENTRY(1,THIS-PROCEDURE:ADM-DATA,CHR(1))).
  IF VALID-HANDLE(hReposBuffer) AND hReposBuffer:NAME <> 'ADMProps':U THEN
  DO:
    hReposBuffer:FIND-FIRST('WHERE Target = WIDGET-H("':U + STRING(THIS-PROCEDURE) + '")':U)
    NO-ERROR.
    IF hReposBuffer:AVAIL THEN
    DO:
      CREATE TEMP-TABLE hPropTable.
      hPropTable:CREATE-LIKE(hReposBuffer).
      hPropTable:TEMP-TABLE-PREPARE('ADMProps':U).
      hBuffer = hPropTable:DEFAULT-BUFFER-HANDLE.
      hBuffer:BUFFER-CREATE().
      hBuffer:BUFFER-COPY(hReposBuffer).
      /* delete the dynamic's property record */
      {fn deleteProperties}.
      /* ... and save it. This ADM object is now open for business! */   
      THIS-PROCEDURE:ADM-DATA = STRING(hBuffer) + CHR(1) + CHR(1).
    END.
  END.  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-destroyObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyObject Method-Library 
PROCEDURE destroyObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/  
    RUN SUPER.
    
    /* If there are errors from destroyObject, don't delete the properties. Errors
       may be raised in the destroyObject call by things like the confirmExit() call
       for example.
    */
    IF ERROR-STATUS:ERROR EQ NO AND RETURN-VALUE <> 'ADM-ERROR':U THEN
      {fn deleteProperties}.
    
    /* Never clear the error status here; it must be passed back to a caller. */    
END PROCEDURE.    /* destroyOject */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-start-super-proc) = 0 &THEN

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
  
  DEFINE VARIABLE        hProc      AS HANDLE     NO-UNDO.
  
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
  
  cLast = DYNAMIC-FUNCTION('get':U + '{&LAST-SUPER-PROCEDURE-PROP}':U) NO-ERROR.
  IF cLast > '':U THEN
  DO:
    cSupers = THIS-PROCEDURE:SUPER-PROCEDURES. 
    DO iLast = 1 TO NUM-ENTRIES(cLast):
      hLast = WIDGET-HANDLE(ENTRY(iLast,cLast)). 
      IF VALID-HANDLE(hLast) AND LOOKUP(STRING(hLast),cSupers) > 0 THEN
      DO:
        THIS-PROCEDURE:REMOVE-SUPER-PROCEDURE(hLast).
        cRemoved = cRemoved 
                   + (IF cRemoved = '':U THEN '':U ELSE ',':U)
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

/* Note: This ENDIF matches the adm-smart definition at the top of file.
   Do not delete it and if another procedure or function is defined which
   occurs later in the file, move it to the end of that. */
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

