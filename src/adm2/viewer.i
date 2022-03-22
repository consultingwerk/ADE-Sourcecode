&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Method-Library 
/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*-------------------------------------------------------------------------
    File        : viewer.i  
    Purpose     : Basic SmartDataViewer methods for the ADM
  
    Syntax      : {src/adm2/viewer.i}

    Description :
  
    Modified    :  May 18, 2000 -- version 9.1B
-------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
&IF "{&ADMClass}":U = "":U &THEN
  &GLOB ADMClass viewer
&ENDIF

&IF "{&ADMClass}":U = "viewer":U &THEN
  {src/adm2/viewprop.i}
&ENDIF

/* don't define the adm-datafield-mapping function if not needed */
&IF DEFINED(adm-datafield-mapping) = 0 &THEN
   &SCOPED-DEFINE exclude-adm-datafield-mapping
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-adm-datafield-mapping) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD adm-datafield-mapping Method-Library 
FUNCTION adm-datafield-mapping RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


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

  {src/adm2/datavis.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Method-Library 


/* ***************************  Main Block  *************************** */
    DEFINE VARIABLE cViewCols AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cEnabled  AS CHARACTER NO-UNDO.
    DEFINE VARIABLE iCol      AS INTEGER   NO-UNDO.
    DEFINE VARIABLE iEntries  AS INTEGER   NO-UNDO.
    DEFINE VARIABLE cEntry    AS CHARACTER NO-UNDO.

    /* Capture update keystrokes and signal the start of an update, so that
     * checkModified can work and to control the state of Panels. */
    ON VALUE-CHANGED OF FRAME {&FRAME-NAME} ANYWHERE
        RUN valueChanged IN THIS-PROCEDURE.

    /* Application code that defines vbalue-changed should run valueChanged
     * as above, but for backwards compatibility we also support 
     * VALUE-CHANGED triggers that APPLY 'U10' TO THIS-PROCECURE.*/
    ON 'U10':U OF THIS-PROCEDURE
        RUN valueChanged IN THIS-PROCEDURE.

&IF DEFINED(ADM-EXCLUDE-STATIC) = 0 &THEN
    IF NOT {&ADM-LOAD-FROM-REPOSITORY} THEN
    DO:
      RUN start-super-proc("adm2/viewer.p":U).
      RUN modifyListProperty IN TARGET-PROCEDURE 
                            (TARGET-PROCEDURE,
                            'Add':U,
                            'DataSourceEvents':U,
                            'buildDataRequest':U). 
    END.
 &IF DEFINED(DISPLAYED-FIELDS) > 0 OR DEFINED(ENABLED-FIELDS) > 0  &THEN
    /* The fields can be qualified by the SDO ObjectName rather
       than just RowObject. In that case keep the SDO ObjectName qualifier. 
       */
    ASSIGN
      cViewCols = REPLACE("{&DISPLAYED-FIELDS}":U," ":U,",":U)
      cEnabled  = REPLACE("{&ENABLED-FIELDS}":U," ":U,",":U)
      cViewCols = LEFT-TRIM(REPLACE(",":U + cViewCols,",RowObject.":U,",":U),",":U)
      cEnabled  = LEFT-TRIM(REPLACE(",":U + cEnabled,",RowObject.":U,",":U),",":U).

    &SCOPED-DEFINE xp-assign
    {set DisplayedFields cViewCols}
    {set EnabledFields cEnabled}
    /* Ensure that the viewer is disabled if it is an update-target without
       tableio-source (? will enable ) */
    {set SaveSource NO}
    .
    &UNDEFINE xp-assign
 &ENDIF
    

    /* _ADM-CODE-BLOCK-START _CUSTOM _INCLUDED-LIB-CUSTOM CUSTOM */
    {src/adm2/custom/viewercustom.i}
    /* _ADM-CODE-BLOCK-END */

&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-adm-datafield-mapping) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION adm-datafield-mapping Method-Library 
FUNCTION adm-datafield-mapping RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the contents of the datafield mapping preprocessor so that it
           can be called from the getDataFieldMapping of the viewer class.  
    Notes: This is currently not defined as a normal property due to the fact 
           that it is 
           - rare (only needed for clob fields) 
           - Only applies to static objects, but needed in Dynamics, so that 
             it cannot be defined as prop in viewprop.i.     
           - used only ONCE (in createObjects)
        -  Excluded if no mapping defined. 
------------------------------------------------------------------------------*/

  RETURN "{&adm-datafield-mapping}":U.   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

