&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Method-Library 
/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*-------------------------------------------------------------------------
    Library     : containr.i  
    Purpose     : Default V9 Main Block code and Method Procedures
                  for ADM Container procedures.
  
    Syntax      : {src/adm2/containr.i}

    Modified    : February 18, 2001 Version 9.1C 
    
    Note: !!!   : Method Libraries are maintained manually for 
                  conditional inclusion.        
-------------------------------------------------------------------------*/
/***********************  DEFINITIONS  ***********************************/


&IF "{&ADMClass}":U = "":U &THEN
  &GLOB ADMClass containr
&ENDIF

/* If this is a SmartFrame with no Frame, then re-identify it as a 'virtual'
   -- i.e, non-visual -- container. */
&IF "{&ADM-CONTAINER}":U = "FRAME":U AND "{&FRAME-NAME}":U = "":U &THEN
  &SCOP ADM-CONTAINER VIRTUAL
&ENDIF

/* make the window's max size the session size, but do it no-error 
   as window-name may be current-window with no window (serverside sbo) */     
&IF '{&WINDOW-NAME}' <> '':U &THEN
  /* Avoid this if current-window = {Window-name} already. (a suppressed window) */
  /* The current-window will be set to {&window-name} later for a normal window */  
  IF {&WINDOW-NAME} <> CURRENT-WINDOW THEN
  DO:
    /* only change if the max-width is default */ 
    IF {&WINDOW-NAME}:MAX-WIDTH = {&WINDOW-NAME}:VIRTUAL-WIDTH THEN  
      {&WINDOW-NAME}:MAX-WIDTH  = SESSION:WIDTH - 1 NO-ERROR.

    /* only change if the max-height is default */ 
    IF {&WINDOW-NAME}:MAX-HEIGHT = {&WINDOW-NAME}:VIRTUAL-HEIGHT THEN  
      {&WINDOW-NAME}:MAX-HEIGHT = SESSION:HEIGHT - 1 NO-ERROR.

  END.
&ENDIF

&IF "{&ADMClass}":U = "containr":U &THEN
  {src/adm2/cntnprop.i}
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
         HEIGHT             = 8
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Method-Library 
/* ************************* Included-Libraries *********************** */

/* If this container has no visualization 
   -- is either defined to be 'virtual' or is a SmartFrame with no frame --
   (This can be used simply by opening a SmartFrame and deleting the frame.) 
   If virtual then it is simply a container for non-visual objects; 
   so skip visual.i, and include smart.i or appserver.i depending on the  
   appserver aware preprocessor defined for Appserver aware objects in 
   adecomm/appserv.i */
   
&IF "{&ADM-CONTAINER}":U = "VIRTUAL":U &THEN   
        &IF DEFINED(APP-SERVER-VARS) = 0 &THEN   
                {src/adm2/smart.i}
        &ELSE  
                {src/adm2/appserver.i}
        &ENDIF  
&ELSE
                {src/adm2/visual.i}
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Method-Library 


/* ***************************  Main Block  *************************** */

&IF DEFINED(ADM-EXCLUDE-STATIC) = 0 &THEN
IF NOT {&ADM-LOAD-FROM-REPOSITORY} THEN
DO:
  RUN start-super-proc("adm2/containr.p":U).

  RUN modifyListProperty IN TARGET-PROCEDURE 
                         (TARGET-PROCEDURE,
                          'Add':U,
                          'ContainerSourceEvents':U,
                          'initializeDataObjects':U). 
  
  /* Viewers subscribe to this from their data-source, so only subscribe
     if pass-thru  */
  IF  CAN-DO({fn getSupportedLinks},'data-target':U) 
  AND CAN-DO({fn getSupportedLinks},'data-source':U) THEN
    RUN modifyListProperty IN TARGET-PROCEDURE 
                           (TARGET-PROCEDURE,
                            'Add':U,
                            'ContainerSourceEvents':U,
                            'buildDataRequest':U). 

  IF NOT CAN-DO({fn getSupportedLinks},'containertoolbar-target':U) THEN
    RUN modifyListProperty IN TARGET-PROCEDURE 
                          (TARGET-PROCEDURE,
                           'Add':U,
                           'SupportedLinks':U,
                           'ContainerToolbar-Target':U).
END.  /* if not adm-load-from-repos */
&ENDIF

&IF "{&WINDOW-NAME}":U <> "":U AND "{&ADM-CONTAINER}":U = "WINDOW":U &THEN
  IF VALID-HANDLE(gshSessionManager) THEN
  DO:
    ON HELP OF {&WINDOW-NAME} ANYWHERE    
      RUN contextHelp IN gshSessionManager (INPUT THIS-PROCEDURE, INPUT FOCUS). 
  END.       
&ENDIF

/* Best default for GUI applications - this will apply to the whole session: */
PAUSE 0 BEFORE-HIDE.

&IF DEFINED(ADM-EXCLUDE-STATIC) = 0 &THEN
  /* _ADM-CODE-BLOCK-START _CUSTOM _INCLUDED-LIB-CUSTOM CUSTOM */
  {src/adm2/custom/containrcustom.i}
  /* _ADM-CODE-BLOCK-END */
&ENDIF

/* see explanation in setWindowFrameHandle */
&IF '{&WINDOW-NAME}' <> ''  &THEN
  &IF '{&FRAME-NAME}' <> '' &THEN  
                      /* double quote allows spaces in preprocessor arg */
 {set WindowFrameHandle "FRAME {&frame-name}:handle"}.
  &ENDIF
&ENDIF

&IF DEFINED(APP-SERVER-VARS) <> 0 &THEN   
 {set DataContainer TRUE}.
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


