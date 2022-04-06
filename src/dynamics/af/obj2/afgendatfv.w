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
  File: afgendatfv.w

  Description:  Object Generator DataField Viewer

  Purpose:      Object Generator DataField Viewer

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

&scop object-name       afgendatfv.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/*  object identifying preprocessor */
&glob   astra2-staticSmartObject yes

{src/adm2/globals.i}
DEFINE VARIABLE ghContainerSource                       AS HANDLE                   NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartObject
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS coProductModule coObjectType 
&Scoped-Define DISPLAYED-OBJECTS coProductModule coObjectType toUseSDO 

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
     SIZE 48 BY 1 TOOLTIP "The class to which the DataField Objects belong." NO-UNDO.

DEFINE VARIABLE coProductModule AS CHARACTER FORMAT "X(256)":U 
     LABEL "Product module" 
     VIEW-AS COMBO-BOX SORT INNER-LINES 5
     LIST-ITEM-PAIRS "Item 1","Item 1"
     DROP-DOWN-LIST
     SIZE 48 BY 1 TOOLTIP "The product module in which the DataFields will be created." NO-UNDO.

DEFINE VARIABLE toUseSDO AS LOGICAL INITIAL no 
     LABEL "Use data object fields" 
     VIEW-AS TOGGLE-BOX
     SIZE 48 BY .81 TOOLTIP "Use the fields of the DataObject" NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     coProductModule AT ROW 1.14 COL 23.4 COLON-ALIGNED
     coObjectType AT ROW 2.24 COL 23.4 COLON-ALIGNED
     toUseSDO AT ROW 3.29 COL 25.4
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
         HEIGHT             = 3.19
         WIDTH              = 72.4.
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
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME frMain:SCROLLABLE       = FALSE
       FRAME frMain:HIDDEN           = TRUE.

ASSIGN 
       coObjectType:PRIVATE-DATA IN FRAME frMain     = 
                "OBJECT-TYPE".

ASSIGN 
       coProductModule:PRIVATE-DATA IN FRAME frMain     = 
                "MODULE".

/* SETTINGS FOR TOGGLE-BOX toUseSDO IN FRAME frMain
   NO-ENABLE                                                            */
ASSIGN 
       toUseSDO:PRIVATE-DATA IN FRAME frMain     = 
                "USE-DATA-OBJECT".

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
      ASSIGN toUseSDO:CHECKED   = FALSE
             toUseSDO:SENSITIVE = FALSE.
    ELSE
      ASSIGN toUseSDO:SENSITIVE = TRUE.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDataFieldFrame sObject 
PROCEDURE getDataFieldFrame :
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
    DEFINE VARIABLE cCalcFieldChildren          AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cLabel                      AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cValue                      AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cProductModuleCode          AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE iNumChild                   AS INTEGER              NO-UNDO.
    
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
                ASSIGN cLabel = hHeaderInfoBuffer:BUFFER-FIELD("tName":U):BUFFER-VALUE
                              + " ( ":U + ENTRY(2, hHeaderInfoBuffer:BUFFER-FIELD("tExtraInfo":U):BUFFER-VALUE, CHR(1)) + " )":U
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

        /* Make sure that the relevant object types are cached. */
        RUN createClassCache IN gshRepositoryManager ( INPUT "DataField":U ).

        /* Get the object type */
        ASSIGN
          coObjectType:LIST-ITEMS = REPLACE(DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, "DataField":U),CHR(3),",":U)
          NO-ERROR.
        /* Calculated fields should not be included in the list of object types
           for import.  This is a temporary fix that should be removed once
           CalculatedFields are changed to be siblings of DataFields rather
           than children of DataFields. */
        cCalcFieldChildren = DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, "CalculatedField":U).
        DO iNumChild = 1 TO NUM-ENTRIES(cCalcFieldChildren):
          coObjectType:DELETE(ENTRY(iNumChild,cCalcFieldChildren)).
        END.  /* do iNumChild */
        IF coObjectType:LIST-ITEMS = "":U
        OR coObjectType:LIST-ITEMS = ?
        THEN ASSIGN coObjectType:LIST-ITEMS = "DataField":U.
        ASSIGN coObjectType:SCREEN-VALUE = coObjectType:ENTRY(1) NO-ERROR.

    END.    /* with frame ... */

    SUBSCRIBE TO "getDataFieldFrame":U IN ghContainerSource.
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
  DEFINE VARIABLE cDFLType  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDFLPM    AS CHARACTER  NO-UNDO.
  
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
    cDFLType = DYNAMIC-FUNCTION("mappedEntry" IN target-procedure,"DFL_Type":U,cPrefData,TRUE,CHR(3)).
    cDFLPM   = DYNAMIC-FUNCTION("mappedEntry" IN target-procedure,"DFL_PM":U,cPrefData,TRUE,CHR(3)).
    
    DO WITH FRAME {&FRAME-NAME}:
      IF cDFLType <> ? AND
         cDFLType <> "":U THEN
        coObjectType:SCREEN-VALUE = cDFLType.
  
      IF cDFLPM <> ? AND
         cDFLPM <> "":U THEN DO:
        coProductModule:SCREEN-VALUE = cDFLPM.
        APPLY "VALUE-CHANGED":U TO coProductModule.
      END.
    END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

