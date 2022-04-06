&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" sObject _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" sObject _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS sObject 
/*************************************************************/  
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*---------------------------------------------------------------------------------
  File: afgenbrowv.w

  Description:  Object Generator Browse Viewer

  Purpose:      Object Generator Browse Viewer

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   07/03/2002  Author:     Peter Judge

  Update Notes: Created from Template rysttsimpv.w

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afgenbrowv.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/*  object identifying preprocessor */
&glob   astra2-staticSmartObject yes

{src/adm2/globals.i}

DEFINE VARIABLE ghContainerSource                       AS HANDLE           NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartObject
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS coProductModule coObjectType fiBrowseSuffix ~
fiNumFields toDeleteInstance toUseSDO toUseSDOFieldOrder 
&Scoped-Define DISPLAYED-OBJECTS coProductModule coObjectType ~
fiBrowseSuffix fiNumFields toDeleteInstance toUseSDO toUseSDOFieldOrder 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE coObjectType AS CHARACTER FORMAT "X(256)":U 
     LABEL "Object type" 
     VIEW-AS COMBO-BOX SORT INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 48 BY 1 TOOLTIP "The class to which the Browse objects belong." NO-UNDO.

DEFINE VARIABLE coProductModule AS CHARACTER FORMAT "X(256)":U 
     LABEL "Product module" 
     VIEW-AS COMBO-BOX SORT INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 48 BY 1 TOOLTIP "The product module in which the Browses will be created." NO-UNDO.

DEFINE VARIABLE fiBrowseSuffix AS CHARACTER FORMAT "X(35)":U 
     LABEL "Name suffix" 
     VIEW-AS FILL-IN 
     SIZE 48 BY 1 TOOLTIP "This suffix is used with the table entity to create the browse name" NO-UNDO.

DEFINE VARIABLE fiNumFields AS INTEGER FORMAT ">>>9":U INITIAL 0 
     LABEL "Max mumber of fields" 
     VIEW-AS FILL-IN 
     SIZE 11.2 BY 1 TOOLTIP "Number of fields to add to the browse" NO-UNDO.

DEFINE VARIABLE toDeleteInstance AS LOGICAL INITIAL no 
     LABEL "Delete contained DataField instances" 
     VIEW-AS TOGGLE-BOX
     SIZE 48 BY .81 TOOLTIP "Delete the existing data field instances which are contained by the browse" NO-UNDO.

DEFINE VARIABLE toUseSDO AS LOGICAL INITIAL no 
     LABEL "Use data object fields" 
     VIEW-AS TOGGLE-BOX
     SIZE 48 BY .81 TOOLTIP "Use the fields of the DataObject" NO-UNDO.

DEFINE VARIABLE toUseSDOFieldOrder AS LOGICAL INITIAL no 
     LABEL "Use data object field order" 
     VIEW-AS TOGGLE-BOX
     SIZE 48 BY .81 TOOLTIP "Use the order of fields in the DataObject when displaying them in the Browse" NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     coProductModule AT ROW 1.14 COL 29.8 COLON-ALIGNED
     coObjectType AT ROW 2.24 COL 29.8 COLON-ALIGNED
     fiBrowseSuffix AT ROW 3.33 COL 29.8 COLON-ALIGNED
     fiNumFields AT ROW 4.43 COL 29.8 COLON-ALIGNED
     toDeleteInstance AT ROW 5.48 COL 31.8
     toUseSDO AT ROW 6.29 COL 31.8
     toUseSDOFieldOrder AT ROW 7.19 COL 31.8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartObject
   Allow: Basic
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW sObject ASSIGN
         HEIGHT             = 7.14
         WIDTH              = 80.8.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB sObject 
/* ************************* Included-Libraries *********************** */

{src/adm2/visual.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW sObject
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME frMain
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME frMain:SCROLLABLE       = FALSE
       FRAME frMain:HIDDEN           = TRUE
       FRAME frMain:PRIVATE-DATA     = 
                "BROWSE".

ASSIGN 
       coObjectType:PRIVATE-DATA IN FRAME frMain     = 
                "OBJECT-TYPE".

ASSIGN 
       coProductModule:PRIVATE-DATA IN FRAME frMain     = 
                "MODULE".

ASSIGN 
       fiBrowseSuffix:PRIVATE-DATA IN FRAME frMain     = 
                "SUFFIX".

ASSIGN 
       fiNumFields:PRIVATE-DATA IN FRAME frMain     = 
                "NUM-FIELDS".

ASSIGN 
       toDeleteInstance:PRIVATE-DATA IN FRAME frMain     = 
                "DELETE-INSTANCES".

ASSIGN 
       toUseSDO:PRIVATE-DATA IN FRAME frMain     = 
                "USE-DATA-OBJECT".

ASSIGN 
       toUseSDOFieldOrder:PRIVATE-DATA IN FRAME frMain     = 
                "USE-DATA-OBJECT-FIELD-ORDER".

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME frMain
/* Query rebuild information for FRAME frMain
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME frMain */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK sObject 


/* ***************************  Main Block  *************************** */

/* If testing in the UIB, initialize the SmartObject. */  
&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
  RUN initializeObject.
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DataObjectChanged sObject 
PROCEDURE DataObjectChanged :
/*------------------------------------------------------------------------------
  Purpose:     The header viewer publishes this event when the Data Objects
               toggle's value changes
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER plChecked AS LOGICAL    NO-UNDO.
  DO WITH FRAME {&FRAME-NAME}:
    IF plChecked THEN
      ASSIGN toUseSDOFieldOrder:CHECKED   = FALSE
             toUseSDO:CHECKED             = FALSE
             toUseSDOFieldOrder:SENSITIVE = FALSE
             toUseSDO:SENSITIVE           = FALSE.
    ELSE
      ASSIGN toUseSDOFieldOrder:SENSITIVE = TRUE
             toUseSDO:SENSITIVE           = TRUE.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI sObject  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME frMain.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getBrowseFrame sObject 
PROCEDURE getBrowseFrame :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER phFrame                 AS HANDLE           NO-UNDO.

    ASSIGN phFrame = FRAME {&FRAME-NAME}:HANDLE.

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject sObject 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hHeaderInfoBuffer           AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hQuery                      AS HANDLE               NO-UNDO.
    DEFINE VARIABLE cLabel                      AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cValue                      AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cProductModuleCode          AS CHARACTER            NO-UNDO.
    
    RUN SUPER.

    SUBSCRIBE PROCEDURE THIS-PROCEDURE TO "ProductModuleChanged":U IN ghContainerSource.
    
    DO WITH FRAME {&FRAME-NAME}:
        /* Clear the combo. */
        ASSIGN coProductModule:LIST-ITEM-PAIRS = coProductModule:SCREEN-VALUE.

        PUBLISH "getHeaderInfoBuffer" FROM ghContainerSource ( OUTPUT hHeaderInfoBuffer ).
    
        IF VALID-HANDLE(hHeaderInfoBuffer) THEN
        DO:
            CREATE WIDGET-POOL "initializeObject":U.
        
            CREATE QUERY hQuery IN WIDGET-POOL "initializeObject":U.
            hQuery:ADD-BUFFER(hHeaderInfoBuffer).
    
            hQuery:QUERY-PREPARE(" FOR EACH ttHeaderInfo WHERE ttHeaderInfo.tType = 'MODULE' AND ttHeaderInfo.tDisplayRecord ":U).
            hQuery:QUERY-OPEN().
            hQuery:GET-FIRST().
            DO WHILE hHeaderInfoBuffer:AVAILABLE:
                ASSIGN cLabel = hHeaderInfoBuffer:BUFFER-FIELD("tName":U):BUFFER-VALUE + " ( ":U + ENTRY(2, hHeaderInfoBuffer:BUFFER-FIELD("tExtraInfo":U):BUFFER-VALUE, CHR(1)) + " )":U
                       cValue = hHeaderInfoBuffer:BUFFER-FIELD("tName":U):BUFFER-VALUE
                       .
                coProductModule:ADD-LAST(cLabel, cValue).
    
                hQuery:GET-NEXT().
            END.    /* available headerinfo */
            hQuery:QUERY-CLOSE().
   
            DELETE WIDGET-POOL "initializeObject":U.
    
            ASSIGN coProductModule:SCREEN-VALUE = coProductModule:ENTRY(1) NO-ERROR.
        END.    /* valid buffer handle */
    
        /* Set to the default value. */
        PUBLISH "getDefaultModuleInfo":U FROM ghContainerSource ( OUTPUT cProductModuleCode ).
    
        ASSIGN coProductModule:SCREEN-VALUE = cProductModuleCode NO-ERROR.

        ASSIGN fiBrowseSuffix:SCREEN-VALUE = "fullb":U
               fiNumFields:SCREEN-VALUE    = STRING(48)               
               .
        /* Make sure that the relevant object types are cached. */
        RUN createClassCache IN gshRepositoryManager ( INPUT "DynBrow":U ).

        /* Get the object type */
        ASSIGN
          coObjectType:LIST-ITEMS = REPLACE(DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, "DynBrow":U),CHR(3),",":U)
          NO-ERROR.

        IF coObjectType:LIST-ITEMS = "":U
        OR coObjectType:LIST-ITEMS = ?
        THEN ASSIGN coObjectType:LIST-ITEMS = "DynBrow":U.

        ASSIGN coObjectType:SCREEN-VALUE = coObjectType:ENTRY(1) NO-ERROR.

    END.    /* with frame ... */

    SUBSCRIBE "getBrowseFrame":U IN ghContainerSource.
    SUBSCRIBE "DataObjectChanged":U IN ghContainerSource.
    SUBSCRIBE "setPreferences":U IN ghContainerSource.
    RUN setPreferences.

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkStateHandler sObject 
PROCEDURE linkStateHandler :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcState  AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER phObject AS HANDLE NO-UNDO.
    DEFINE INPUT PARAMETER pcLink   AS CHARACTER NO-UNDO.

    RUN SUPER( INPUT pcState, INPUT phObject, INPUT pcLink).

    /* Set the handle of the container source immediately upon making the link */
    IF pcLink = "ContainerSource":U AND pcState = "Add":U THEN
        ASSIGN ghContainerSource = phObject.

    RETURN.    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ProductModuleChanged sObject 
PROCEDURE ProductModuleChanged :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcOldProdMod    AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcProductModule AS CHARACTER  NO-UNDO.
  
  DO WITH FRAME {&FRAME-NAME}:
    IF pcOldProdMod = coProductModule:SCREEN-VALUE THEN
      ASSIGN coProductModule:SCREEN-VALUE = pcProductModule.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setPreferences sObject 
PROCEDURE setPreferences :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE rRowid    AS ROWID      NO-UNDO.
  DEFINE VARIABLE cPrefData AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSDBType  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSDBPM    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSDBSuf   AS CHARACTER  NO-UNDO.
  
  /* Get Report Directory */
  ASSIGN rRowid = ?.
  IF VALID-HANDLE(gshProfileManager) THEN
  RUN getProfileData IN gshProfileManager (INPUT "General":U,         /* Profile type code     */
                                           INPUT "Preference":U,      /* Profile code          */
                                           INPUT "GenerateObjects":U, /* Profile data key      */
                                           INPUT "NO":U,              /* Get next record flag  */
                                           INPUT-OUTPUT rRowid,       /* Rowid of profile data */
                                           OUTPUT cPrefData).     /* Found profile data.   */
  IF cPrefData <> ? AND
     cPrefData <> "":U THEN DO:
    cSDBType = DYNAMIC-FUNCTION("mappedEntry" IN target-procedure,"SDB_Type":U,cPrefData,TRUE,CHR(3)).
    cSDBPM   = DYNAMIC-FUNCTION("mappedEntry" IN target-procedure,"SDB_PM":U,cPrefData,TRUE,CHR(3)).
    cSDBSuf  = DYNAMIC-FUNCTION("mappedEntry" IN target-procedure,"OG_SDB_Suf":U,cPrefData,TRUE,CHR(3)).
    
    DO WITH FRAME {&FRAME-NAME}:
      IF cSDBType <> ? AND
         cSDBType <> "":U THEN
        coObjectType:SCREEN-VALUE = cSDBType.
  
      IF cSDBPM <> ? AND
         cSDBPM <> "":U THEN
      DO:
        coProductModule:SCREEN-VALUE = cSDBPM NO-ERROR.
        APPLY "VALUE-CHANGED":U TO coProductModule.
      END.

      IF cSDBSuf <> ? AND 
         cSDBSuf <> "":U THEN
        fiBrowseSuffix:SCREEN-VALUE = cSDBSuf.
    END.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

