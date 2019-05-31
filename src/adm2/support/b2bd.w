&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME gDialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS gDialog 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: b2bd.w 
  Description: Instance Properties Dialog for SmartB2BObjects.

  Input Parameters:
     p_hSMO -- Procedure Handle of calling SmartObject.

  Output Parameters:
      <none>

    Notes: Producer and Consumer
           The object runs TWO instances of dB2B and THREE of vB2B.
           The Consumer Viewer is on page 1 and the Producer Viewer on page 2 
           and 3) The setDirection() is called in these objects to make them 
           distinguish between 'Consumer' or 'Producer'. 
         
          Size adjustments:
           If new fields need to be added or removed do the following.             
           1. vb2b.w
            a) Add/remove fields in vb2b.w and adjust the rectangle accordingly.
              (Just as any normal viewer). 
            b) Change initializeObject 
            - To set the fields hidden attribute depending on the 
              getDirection  (Consumer or not). 
            - If changes for consumer also change the code that adjusts HEIGHT
              of the rectangle to use the the last visible fields.          
           2. This Container object.
            a) Manually move the panel and the browser in this container to 
               fit the new size. (Again just as any normal container)       
            b) Trial and error with the multiple and single button is required 
               to find the new value for the xiDiff variable below.   
                                                                       
          Producer Modes:
          - The Single Producer is on page 2 and the multiple page 3. 
          - getCurrentPage() and selectPage checks SOURCE and tricks the folder
            to always show page 2 also when page is 3.  
            The producer viewer has a button where the user can switch between 
            multiple or single. (The multiple = lDataDriven in this object)  
          - This button switches the mode by calling selectPage in this container 
            with the opposite of page 2 or 3.  
            changePage calls setDataDriven() that does the actual change 
            of height of the folder and the frame.  xdDiff is a constant with
            the diff.
            changePage also links/unlinks the viewer on page 2 and 3 to
            the producer SDO.  
          - The viewer rectangle is adjusted in the viewer's initializeObject 
            depending of Direction and DataDriven
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */


&GLOBAL-DEFINE WIN95-BTN YES

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER p_hSMO AS HANDLE NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE gcDirections  AS CHARACTER NO-UNDO.

/* internal flag used in createObjects to avoid to run getSMOProperties 
   and startup logic twice when selectPage is called from createObjects  */  
DEFINE VARIABLE glStarted     AS LOGICAL  NO-UNDO.
/* Keep track of height */

DEFINE VARIABLE giBigHeight   AS INTEGER  NO-UNDO.
DEFINE VARIABLE glBig         AS LOG      NO-UNDO.

/* NOTE: This is the difference in size of max and min .*/
DEFINE VARIABLE xiDiff        AS DEC      NO-UNDO INIT 262.  

/* Define the value of the "No Layout Options" supplied. */
&Scoped-define no-layout [default]

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME gDialog

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCurrentPage gDialog 
FUNCTION getCurrentPage RETURNS INTEGER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDataDriven gDialog 
FUNCTION getDataDriven RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSmartObject gDialog 
FUNCTION getSmartObject RETURNS HANDLE
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD hasLink gDialog 
FUNCTION hasLink RETURNS LOGICAL
  (pcLink AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD initViewer gDialog 
FUNCTION initViewer RETURNS LOGICAL
  ( phViewer AS HANDLE)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD linkViewer gDialog 
FUNCTION linkViewer RETURNS LOGICAL
  (phViewer AS HANDLE) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD saveCancelViewer gDialog 
FUNCTION saveCancelViewer RETURNS LOGICAL
  (phViewer AS HANDLE,
   plSave   AS LOG) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setBig gDialog 
FUNCTION setBig RETURNS LOGICAL
  (plIncrease AS LOGICAL)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_bb2b AS HANDLE NO-UNDO.
DEFINE VARIABLE h_db2bConsumer AS HANDLE NO-UNDO.
DEFINE VARIABLE h_db2bProducer AS HANDLE NO-UNDO.
DEFINE VARIABLE h_folder AS HANDLE NO-UNDO.
DEFINE VARIABLE h_pupdsav AS HANDLE NO-UNDO.
DEFINE VARIABLE h_vb2bConsumer AS HANDLE NO-UNDO.
DEFINE VARIABLE h_vb2bproddata AS HANDLE NO-UNDO.
DEFINE VARIABLE h_vb2bProducer AS HANDLE NO-UNDO.
DEFINE VARIABLE h_vb2bProducerbig AS HANDLE NO-UNDO.

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME gDialog
     SPACE(98.02) SKIP(24.54)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "SmartB2BObject Properties".


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target
   Design Page: 3
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB gDialog 
/* ************************* Included-Libraries *********************** */

{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX gDialog
   NOT-VISIBLE                                                          */
ASSIGN 
       FRAME gDialog:SCROLLABLE       = FALSE
       FRAME gDialog:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX gDialog
/* Query rebuild information for DIALOG-BOX gDialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX gDialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME gDialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gDialog gDialog
ON GO OF FRAME gDialog /* SmartB2BObject Properties */
DO:
  RUN SaveData NO-ERROR.
  IF ERROR-STATUS:ERROR THEN
     RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gDialog gDialog
ON WINDOW-CLOSE OF FRAME gDialog /* SmartB2BObject Properties */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK gDialog 


/* **************** Standard Buttons and Help Setup ******************* */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

/* define the buttoins names so we can move them in setDataDriven */
&SCOPED-DEFINE OK     btnOK
&SCOPED-DEFINE CANCEL btnCancel
&SCOPED-DEFINE HELP   btnHelp

/* Define Context ID's for HELP files */
{ src/adm2/support/admhlp.i }    

/* Attach the standard OK/Cancel/Help button bar. */
{ adecomm/okbar.i  &TOOL = "AB"
                   &CONTEXT = {&SmartB2BObject_Instance_Properties_Dialog_Box} }

/* ***************************  Main Block  *************************** */

{src/adm2/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects gDialog  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE currentPage  AS INTEGER NO-UNDO.

  ASSIGN currentPage = getCurrentPage().

  CASE currentPage: 

    WHEN 0 THEN DO:
       RUN constructObject (
             INPUT  'adm2/support/db2b.wDB-AWARE':U ,
             INPUT  FRAME gDialog:HANDLE ,
             INPUT  'AppServiceASUsePromptASInfoForeignFieldsRowsToBatch200CheckCurrentChangedyesRebuildOnReposnoServerOperatingModeNONEDestroyStatelessnoDisconnectAppServernoObjectNameConsumer':U ,
             OUTPUT h_db2bConsumer ).
       RUN repositionObject IN h_db2bConsumer ( 1.00 , 69.00 ) NO-ERROR.
       /* Size in AB:  ( 1.67 , 10.80 ) */

       RUN constructObject (
             INPUT  'adm2/support/db2b.wDB-AWARE':U ,
             INPUT  FRAME gDialog:HANDLE ,
             INPUT  'AppServiceASUsePromptASInfoForeignFieldsRowsToBatch200CheckCurrentChangedyesRebuildOnReposnoServerOperatingModeNONEDestroyStatelessnoDisconnectAppServernoObjectNameProducer':U ,
             OUTPUT h_db2bProducer ).
       RUN repositionObject IN h_db2bProducer ( 1.00 , 87.60 ) NO-ERROR.
       /* Size in AB:  ( 1.67 , 10.80 ) */

       RUN constructObject (
             INPUT  'adm2/folder.w':U ,
             INPUT  FRAME gDialog:HANDLE ,
             INPUT  'FolderLabels':U + 'Consumer|Producer' + 'FolderTabWidth0FolderFont-1HideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_folder ).
       RUN repositionObject IN h_folder ( 1.24 , 2.00 ) NO-ERROR.
       RUN resizeObject IN h_folder ( 24.29 , 97.00 ) NO-ERROR.

       /* Links to SmartFolder h_folder. */
       RUN addLink ( h_folder , 'Page':U , THIS-PROCEDURE ).

    END. /* Page 0 */

    WHEN 1 THEN DO:
       RUN constructObject (
             INPUT  'adm2/support/vb2b.w':U ,
             INPUT  FRAME gDialog:HANDLE ,
             INPUT  'DataSourceNamesUpdateTargetNamesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_vb2bConsumer ).
       RUN repositionObject IN h_vb2bConsumer ( 2.67 , 4.00 ) NO-ERROR.
       /* Size in AB:  ( 10.00 , 93.00 ) */

       /* Links to SmartDataViewer h_vb2bConsumer. */
       RUN addLink ( h_db2bConsumer , 'Data':U , h_vb2bConsumer ).
       RUN addLink ( h_vb2bConsumer , 'Update':U , h_db2bConsumer ).

    END. /* Page 1 */

    WHEN 2 THEN DO:
       RUN constructObject (
             INPUT  'adm2/support/vb2b.w':U ,
             INPUT  FRAME gDialog:HANDLE ,
             INPUT  'DataSourceNamesUpdateTargetNamesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_vb2bProducer ).
       RUN repositionObject IN h_vb2bProducer ( 2.67 , 4.00 ) NO-ERROR.
       /* Size in AB:  ( 10.00 , 93.00 ) */

       /* Links to SmartDataViewer h_vb2bProducer. */
       RUN addLink ( h_db2bProducer , 'Data':U , h_vb2bProducer ).

    END. /* Page 2 */

    WHEN 3 THEN DO:
       RUN constructObject (
             INPUT  'adm2/support/vb2b.w':U ,
             INPUT  FRAME gDialog:HANDLE ,
             INPUT  'DataSourceNamesUpdateTargetNamesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_vb2bProducerbig ).
       RUN repositionObject IN h_vb2bProducerbig ( 2.67 , 4.00 ) NO-ERROR.
       /* Size in AB:  ( 10.00 , 93.00 ) */

       RUN constructObject (
             INPUT  'adm2/dynbrowser.w':U ,
             INPUT  FRAME gDialog:HANDLE ,
             INPUT  'DisplayedFieldsname,xmlschema,destinationEnabledFieldsSearchFieldNumDown0CalcWidthnoMaxWidth80DataSourceNamesUpdateTargetNamesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_bb2b ).
       RUN repositionObject IN h_bb2b ( 14.81 , 6.00 ) NO-ERROR.
       RUN resizeObject IN h_bb2b ( 5.71 , 88.80 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/pupdsav.w':U ,
             INPUT  FRAME gDialog:HANDLE ,
             INPUT  'AddFunctionOne-RecordEdgePixels2PanelTypeSaveHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_pupdsav ).
       RUN repositionObject IN h_pupdsav ( 12.91 , 6.00 ) NO-ERROR.
       RUN resizeObject IN h_pupdsav ( 1.48 , 89.00 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/support/vb2bdata.w':U ,
             INPUT  FRAME gDialog:HANDLE ,
             INPUT  'HideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_vb2bproddata ).
       RUN repositionObject IN h_vb2bproddata ( 20.76 , 4.00 ) NO-ERROR.
       /* Size in AB:  ( 4.38 , 93.00 ) */

       /* Links to SmartDataViewer h_vb2bProducerbig. */
       RUN addLink ( h_db2bProducer , 'Data':U , h_vb2bProducerbig ).
       RUN addLink ( h_pupdsav , 'TableIO':U , h_vb2bProducerbig ).

       /* Links to SmartDataBrowser h_bb2b. */
       RUN addLink ( h_db2bProducer , 'Data':U , h_bb2b ).

       /* Adjust the tab order of the smart objects. */
    END. /* Page 3 */

  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE changePage gDialog 
PROCEDURE changePage :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:      Call the function setDataDriven that increases or shrinks 
              the object before SUPER.
              Add and remove links for page 2 and 3.
              Enable or set add mode in viwers. 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cPos         AS CHAR   NO-UNDO.
  DEFINE VARIABLE hProducerUpd AS HANDLE NO-UNDO.
  DEFINE VARIABLE iPage        AS INT    NO-UNDO.
  
  iPage = DYNAMIC-FUNCTION('getcurrentPage').
  
  /* Change the size */
  IF iPage = 3 THEN 
    setBig(TRUE).
  
  ELSE IF iPage = 2 THEN
    setBig(FALSE).

  RUN SUPER.
  
  IF iPage = 1 THEN
    initViewer(h_vb2bConsumer).
  
  IF iPage = 2 THEN
  DO:
    linkViewer(h_vb2bProducer).
    initViewer(h_vb2bProducer).
  END.

  IF iPage = 3 THEN
  DO:
    linkViewer(h_vb2bProducerBig).
    initViewer(h_vb2bProducerBig).
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createObjects gDialog 
PROCEDURE createObjects :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:      setdirection 'consumer' or 'producer' in the viewers. 
              setButtonLabel 'multiple or single' in producer viewer 
              (page 2 or 3) 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE dRow         AS DEC        NO-UNDO.
  DEFINE VARIABLE dHeight      AS DEC        NO-UNDO.
  DEFINE VARIABLE iNumDocDest  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lAnyConsumer AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cMapObject   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lDataDriven  AS LOGICAL    NO-UNDO.

  RUN SUPER.
  
  IF NOT glStarted THEN
  DO:    
    RUN getSmoProperties. 
    ASSIGN
      giBigHeight  = FRAME {&FRAME-NAME}:HEIGHT-PIXELS
      glStarted    = TRUE
      cMapObject   = DYNAMIC-FUNCTION('getMapObjectProducer':U IN p_hSMO).
    
    /* We have data from before so figure out where to go */
    IF gcDirections <> '':U OR cMapObject <> '':U THEN
    DO:
      ASSIGN
       iNumDocDest  = NUM-ENTRIES(gcDirections,CHR(1))
       lAnyConsumer = LOOKUP('Consumer':U,gcDirections,CHR(1)) > 0
       glBig        = cMapObject <> '':U 
                      OR iNumDocDest >  (IF lAnyConsumer THEN 2 ELSE 1). 
     /* If any consumer def then start on the consumer page */     
     IF lAnyConsumer THEN      
       RUN selectPage(1). 
     ELSE IF NOT glBig THEN
       RUN selectPage(2).
     ELSE 
       RUN selectPage(3).  
    END. /* if gcDirections <> "" or cMapObject <> '':U */ 
    ELSE DO: /* if no data then check links */
      IF hasLink('InMessage-Source':U) THEN
        RUN selectPage(1). 
      ELSE IF hasLink('OutMessage-Target':U) THEN
        RUN selectPage(2). 
      /* Start on page 0 if no clue */
    END.

  END.

  IF VALID-HANDLE(h_vb2bConsumer) THEN
    DYNAMIC-FUNCTION('setDirection':U in h_vb2bConsumer,'Consumer':U).
  
  IF VALID-HANDLE(h_vb2bProducer) THEN
  DO:
    DYNAMIC-FUNCTION('setDirection':U in h_vb2bProducer,'Producer':U).
    DYNAMIC-FUNCTION('setButtonLabel':U in h_vb2bProducer,
                     '&Multiple Documents >>':U).
  END.

  IF VALID-HANDLE(h_vb2bProducerBig) THEN
  DO:
    DYNAMIC-FUNCTION('setDirection':U in h_vb2bProducerBig,'Producer':U).
    DYNAMIC-FUNCTION('setNameVisible':U in h_vb2bProducerBig,TRUE).
    DYNAMIC-FUNCTION('setButtonLabel':U in h_vb2bProducerBig,
                     '<< &Single Document':U).

    dHeight = DYNAMIC-FUNCTION('getHeight':U IN  h_bb2b).
    dRow    = DYNAMIC-FUNCTION('getRow':U IN  h_bb2b).
    DYNAMIC-FUNCTION('setHeight':U in h_vb2bProducerBig, 
                      dHeight + dRow 
                      - DYNAMIC-FUNCTION('getRow':U in h_vb2bProducerBig)
                      + 1.5).    
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyObject gDialog 
PROCEDURE destroyObject :
/*------------------------------------------------------------------------------
  Purpose: Ensure that we don't get yes-no-cancel message when we cancel.      
  Notes:       
------------------------------------------------------------------------------*/
  /* Cancel Data in viewers */
  saveCancelViewer(h_vb2bConsumer,NO).
  saveCancelViewer(h_vb2bProducer,NO).
  
  saveCancelViewer(h_vb2bProducerBig,NO). 

  RUN SUPER. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI gDialog  _DEFAULT-DISABLE
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
  HIDE FRAME gDialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI gDialog  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  {&OPEN-BROWSERS-IN-QUERY-gDialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getSmoProperties gDialog 
PROCEDURE getSmoProperties :
/*------------------------------------------------------------------------------
  Purpose: Ask the "parent" SmartObject for the properties that can be 
           changed in this dialog and pass them to the SDOs.  
  Notes:  saveData will get the data back on OK.       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cDestinations    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cDTDPublicIds    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cDTDSystemIds    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cNames           AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cReplyReqs       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cReplySelectors  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cSchemas         AS CHARACTER NO-UNDO.
  
  /* Get the attributes used in this Instance Attribute dialog-box. */
  
  /* gcDirections is used in create objects */
  gcDirections    = DYNAMIC-FUNCTION('getDirectionList':U IN p_hSMO).

  cDestinations   = DYNAMIC-FUNCTION('getDestinationList':U IN p_hSMO).
  cDTDPublicIds   = DYNAMIC-FUNCTION('getDTDPublicIdList':U IN p_hSMO).
  cDTDSystemIds   = DYNAMIC-FUNCTION('getDTDSystemIdList':U IN p_hSMO).
  cNames          = DYNAMIC-FUNCTION('getNameList':U IN p_hSMO).
  cReplyReqs      = DYNAMIC-FUNCTION('getReplyReqList':U IN p_hSMO).
  cReplySelectors = DYNAMIC-FUNCTION('getReplySelectorList':U IN p_hSMO).
  cSchemas        = DYNAMIC-FUNCTION('getSchemaList':U IN p_hSMO).

 DYNAMIC-FUNCTION('setDirection':U in h_db2bconsumer,'Consumer':U).

 RUN createMappings IN h_db2bConsumer 
     (INPUT gcDirections,
      INPUT cNames,
      INPUT cSchemas,
      INPUT cDTDPublicIds,
      INPUT cDTDSystemIds,
      INPUT cDestinations,
      INPUT cReplyReqs,
      INPUT cReplySelectors).
 
 DYNAMIC-FUNCTION('setDirection':U in h_db2bProducer,'Producer':U).
 
 RUN createMappings IN h_db2bProducer 
     (INPUT gcDirections,
      INPUT cNames,
      INPUT cSchemas,
      INPUT cDTDPublicIds,
      INPUT cDTDSystemIds,
      INPUT cDestinations,
      INPUT cReplyReqs,
      INPUT cReplySelectors).
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject gDialog 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       Ensure the object has the size according to the mode
------------------------------------------------------------------------------*/   
  /* glBig is set in createobjects the FIRST time */
   
  setBig(glBig). 
  
  RUN SUPER.
  
  initViewer(h_vb2bConsumer).
  initViewer(h_vb2bProducer).
  initViewer(h_vb2bProducerBig).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveData gDialog 
PROCEDURE saveData :
/*------------------------------------------------------------------------------
  Purpose: Save changes    
  Notes:   We must retrieve data from the SDOs also when no changes, because 
           we don't keep them in local variables. (This is much simpler 
           than having to merge variables with possible changes).       
------------------------------------------------------------------------------*/     
  DEFINE VARIABLE cDestinations    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cDirections      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cDTDPublicIds    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cDTDSystemIds    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cNames           AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cReplyReqs       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cReplySelectors  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cSchemas         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iPage            AS INTEGER    NO-UNDO.

  IF saveCancelViewer(h_vb2bConsumer,YES)  = NO THEN 
    RETURN ERROR.

  IF getDataDriven() THEN
  DO:
    IF saveCancelViewer(h_vb2bProducerBig,YES) = NO THEN 
      RETURN ERROR.
  END.
  ELSE DO:  
    IF saveCancelViewer(h_vb2bProducer,YES) = NO THEN 
      RETURN ERROR.
  END.
  
  RUN returnMappings IN h_db2bConsumer
     (INPUT-OUTPUT cDirections, 
      INPUT-OUTPUT cNames,
      INPUT-OUTPUT cSchemas,
      INPUT-OUTPUT cDTDPublicIds,
      INPUT-OUTPUT cDTDSystemIds,
      INPUT-OUTPUT cDestinations,
      INPUT-OUTPUT cReplyReqs,
      INPUT-OUTPUT cReplySelectors).
  
  RUN returnMappings IN h_db2bProducer
      (INPUT-OUTPUT cDirections, 
       INPUT-OUTPUT cNames,
       INPUT-OUTPUT cSchemas,
       INPUT-OUTPUT cDTDPublicIds,
       INPUT-OUTPUT cDTDSystemIds,
       INPUT-OUTPUT cDestinations,
       INPUT-OUTPUT cReplyReqs,
       INPUT-OUTPUT cReplySelectors).
  
  IF VALID-HANDLE(h_vb2bproddata) THEN
    DYNAMIC-FUNCTION('storeSMOProperties':U IN h_vb2bproddata). 

  DYNAMIC-FUNCTION('setDestinationList':U IN p_hSMO, INPUT cDestinations) NO-ERROR.
  DYNAMIC-FUNCTION('setDirectionList':U IN p_hSMO, INPUT cDirections) NO-ERROR.
  DYNAMIC-FUNCTION('setDTDPublicIdList':U IN p_hSMO, INPUT cDTDPublicIds) NO-ERROR.
  DYNAMIC-FUNCTION('setDTDSystemIdList':U IN p_hSMO, INPUT cDTDSystemIds) NO-ERROR.
  DYNAMIC-FUNCTION('setNameList':U IN p_hSMO, INPUT cNames) NO-ERROR.
  DYNAMIC-FUNCTION('setReplyReqList':U IN p_hSMO, INPUT cReplyReqs) NO-ERROR.
  DYNAMIC-FUNCTION('setReplySelectorList':U IN p_hSMO, INPUT cReplySelectors) NO-ERROR.
  DYNAMIC-FUNCTION('setSchemaList':U IN p_hSMO, INPUT cSchemas) NO-ERROR.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE selectPage gDialog 
PROCEDURE selectPage :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER piPageNum AS INTEGER NO-UNDO.

  DEFINE VARIABLE cObjectType AS CHAR   NO-UNDO.
 
  /* The folder has been cheated to believe that 3 is 2 when data driven  */
  IF getDataDriven() AND piPagenum > 1 THEN
  DO:
    cObjectType = DYNAMIC-FUNCTION('getObjectType' IN SOURCE-PROCEDURE).
    IF cObjectType = 'SmartFolder':U THEN
      piPagenum = 3.
  END.

  RUN SUPER( INPUT piPageNum).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCurrentPage gDialog 
FUNCTION getCurrentPage RETURNS INTEGER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iPage       AS INT  NO-UNDO.
  DEFINE VARIABLE cObjectType AS CHAR NO-UNDO.

  iPage = SUPER(). 
  
  /* Lie to the folder to visualize tab 2 when 3  */  
  IF getDataDriven() AND iPage > 1 THEN
  DO:
    cObjectType = DYNAMIC-FUNCTION('getObjectType' IN SOURCE-PROCEDURE).
    IF cObjectType = 'SmartFolder':U THEN
      RETURN 2.
  END. /* dataDriven and super's page > 1 */

  RETURN iPage.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDataDriven gDialog 
FUNCTION getDataDriven RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  RETURN glBig.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSmartObject gDialog 
FUNCTION getSmartObject RETURNS HANDLE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN p_hSMO.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION hasLink gDialog 
FUNCTION hasLink RETURNS LOGICAL
  (pcLink AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Check if linked  
    Notes: used in createObjects to start on Producer of Consumer page  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cContext AS CHARACTER  NO-UNDO.
 
  RUN adeuib/_uibinfo (?, "HANDLE ":U + STRING(p_hSMO), "LINK ":U + pcLink, 
     OUTPUT cContext).      /* Returns the Context ID of our Data-Source */
  
  RETURN cContext <> "":U.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION initViewer gDialog 
FUNCTION initViewer RETURNS LOGICAL
  ( phViewer AS HANDLE) :
/*------------------------------------------------------------------------------
  Purpose: Make the viewer ready for update    
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cPos     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lInitted AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cNew     AS CHARACTER   NO-UNDO.

  IF VALID-HANDLE(phViewer) THEN
  DO:
    lInitted = DYNAMIC-FUNCTION('getObjectInitialized':U IN phViewer).
    cNew     = DYNAMIC-FUNCTION('getNewRecord':U IN phViewer).

    IF lInitted THEN
    DO:      
      cPos = DYNAMIC-FUNCTION('getRecordState':U IN phViewer).
      IF cPos = "NoRecordAvailable":U AND cNew = "no":U THEN
         RUN addRecord IN phViewer.
      ELSE 
        RUN enableFields IN phViewer.
     /*updateMode IN h_vb2bProducer('UpdateBegin':U).   */
    END.
  END.
  RETURN TRUE.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION linkViewer gDialog 
FUNCTION linkViewer RETURNS LOGICAL
  (phViewer AS HANDLE):
/*------------------------------------------------------------------------------
  Purpose: Link/unlink the viewers on page 2 or 3 at start up or when 
           switching multiple/single    
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hUpdSource AS HANDLE  NO-UNDO.

  IF VALID-HANDLE(phViewer) THEN
  DO:
    {get UpdateSource hUpdSource h_db2bProducer}.    
  
    IF VALID-HANDLE(hUpdSource) AND hUpdSource <> phViewer THEN
      RUN removeLink ( hUpdSource , 'Update':U , h_db2bProducer ).  

    IF hUpdSource <> phViewer THEN
    DO:
      RUN addLink ( phViewer, 'Update':U , h_db2bProducer ). 
      DYNAMIC-FUNCTION('openQuery':U IN h_db2bProducer ).
    END.
  END.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION saveCancelViewer gDialog 
FUNCTION saveCancelViewer RETURNS LOGICAL
  (phViewer AS HANDLE,
   plSave   AS LOG):
/*------------------------------------------------------------------------------
  Purpose: Save data in viewer if Modified.
Parameter: phViewer - A viewer handle
           plsave   - save if modified   
    Notes: called from saveData 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lHidden AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lError  AS LOGICAL    NO-UNDO.

  IF VALID-HANDLE(phViewer) THEN
  DO: 
    /* Currently the viewer denies to save/cancel when hidden! */  
    {get ObjectHidden lHidden phViewer}.

    {set ObjectHidden NO phViewer}.
    IF plSave AND DYNAMIC-FUNCTION('getDataModified':U IN phViewer) THEN
    DO:     
      RUN updateRecord IN phViewer.
      /* if still modified the Save failed so we must return false */
      lError = DYNAMIC-FUNCTION('getDataModified':U IN phViewer).
    END.
    ELSE 
      RUN cancelRecord IN phViewer.
    
    {set ObjectHidden lHidden phViewer}.
  END.
  
  RETURN NOT lError.

 END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setBig gDialog 
FUNCTION setBig RETURNS LOGICAL
  (plIncrease AS LOGICAL) :
/*------------------------------------------------------------------------------
  Purpose: Switch the object between the two modes. 
           Multiple producers/DataDriven 
           Single Producer/not DataDriven   
           See notes in the Definition Section on how this function is used
           and an overview of the logic (and a few hardcoded sizes) in the other
           objects.    
    Notes:  
------------------------------------------------------------------------------*/
   DEFINE VAR      dHeight AS DEC  NO-UNDO.
   DEFINE VAR      dWidth  AS DEC  NO-UNDO.
   DEFINE VARIABLE iY      AS DEC  NO-UNDO.
   DEFINE VARIABLE iDiff   AS DEC  NO-UNDO.
   DEFINE VARIABLE hPanel  AS HANDLE NO-UNDO.
   
        
   glBig = plIncrease.
   IF plIncrease THEN
   DO:
     IF FRAME {&FRAME-NAME}:HEIGHT-P = giBigHeight THEN 
       RETURN FALSE.  
     iDiff = xiDiff. 
   END.
   ELSE DO:
     IF FRAME {&FRAME-NAME}:HEIGHT-P = giBigHeight - xiDiff THEN 
       RETURN FALSE.
     iDiff = xiDiff * -1.      
   END.

   DO WITH FRAME {&FRAME-NAME}:
     IF iDiff > 0 THEN
       ASSIGN 
         btnOk:Y       = btnOk:Y + iDiff 
         btnCancel:Y   = btnCancel:Y + iDiff 
         btnHelp:Y     = btnHelp:Y  + iDiff
         iY            = FRAME {&FRAME-NAME}:Y
         FRAME {&FRAME-NAME}:HEIGHT-P = FRAME {&FRAME-NAME}:HEIGHT-P + iDiff
         FRAME {&FRAME-NAME}:Y = iY 
       NO-ERROR.

     /* Resize Folder */
     ASSIGN 
       dHeight = DYNAMIC-FUNCTION('getHeight' IN h_folder)
       dWidth  = DYNAMIC-FUNCTION('getWidth'  IN h_folder).   
    
     RUN resizeObject IN h_folder ( dHeight + (iDiff / SESSION:PIXELS-PER-ROW), dWidth). 

     IF iDiff < 0 THEN
     ASSIGN 
       btnOk:Y       = btnOk:Y + iDiff 
       btnCancel:Y   = btnCancel:Y + iDiff 
       btnHelp:Y     = btnHelp:Y + iDiff
       iY            = FRAME {&FRAME-NAME}:Y
       FRAME {&FRAME-NAME}:HEIGHT-P = FRAME {&FRAME-NAME}:HEIGHT-P + iDiff
       FRAME {&FRAME-NAME}:Y = iY 
       NO-ERROR.
   
   END.

   RETURN TRUE. 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

