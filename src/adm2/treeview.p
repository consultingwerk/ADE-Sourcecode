&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*--------------------------------------------------------------------------
    File        : treeview.p
    Purpose     : Super procedure for treeview class.

    Syntax      : RUN start-super-proc("adm2/treeview.p":u).

    Modified    : 04/05/2001
    Modified: 03/25/2002      Mark Davies (MIP)
              Moved getTreeDataTable to dyntreeview.w to avoid the 
              same table being used for all running TreeViews.
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */


&SCOP ADMSuper treeview.p

/* Custom exclude file */
 
{src/adm2/custom/treeviewexclcustom.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-ExpandNode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD ExpandNode Procedure 
FUNCTION ExpandNode RETURNS LOGICAL
  ( INPUT pcNodeKey AS CHARACTER,
    INPUT plExpand  AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getAutoSort) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getAutoSort Procedure 
FUNCTION getAutoSort RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getExpandOnAdd) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getExpandOnAdd Procedure 
FUNCTION getExpandOnAdd RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFullRowSelect) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFullRowSelect Procedure 
FUNCTION getFullRowSelect RETURNS LOGICAL
 (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getHideSelection) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getHideSelection Procedure 
FUNCTION getHideSelection RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getImageHeight) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getImageHeight Procedure 
FUNCTION getImageHeight RETURNS INTEGER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getImageWidth) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getImageWidth Procedure 
FUNCTION getImageWidth RETURNS INTEGER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getIndentation) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getIndentation Procedure 
FUNCTION getIndentation RETURNS INTEGER
 (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLabelEdit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getLabelEdit Procedure 
FUNCTION getLabelEdit RETURNS INTEGER
(  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLineStyle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getLineStyle Procedure 
FUNCTION getLineStyle RETURNS INTEGER
(  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getOLEDrag) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getOLEDrag Procedure 
FUNCTION getOLEDrag RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getOLEDrop) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getOLEDrop Procedure 
FUNCTION getOLEDrop RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getProperty) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getProperty Procedure 
FUNCTION getProperty RETURNS CHARACTER
  ( pcProperty AS CHAR ,
    pcKey  AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRootNodeParentKey) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getRootNodeParentKey Procedure 
FUNCTION getRootNodeParentKey RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getScroll) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getScroll Procedure 
FUNCTION getScroll RETURNS LOGICAL
 (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getShowCheckBoxes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getShowCheckBoxes Procedure 
FUNCTION getShowCheckBoxes RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getShowRootLines) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getShowRootLines Procedure 
FUNCTION getShowRootLines RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSingleSel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSingleSel Procedure 
FUNCTION getSingleSel RETURNS LOGICAL
(  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTreeStyle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTreeStyle Procedure 
FUNCTION getTreeStyle RETURNS INTEGER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTVControllerSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTVControllerSource Procedure 
FUNCTION getTVControllerSource RETURNS HANDLE
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-isNodeExpanded) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD isNodeExpanded Procedure 
FUNCTION isNodeExpanded RETURNS LOGICAL
  ( INPUT pcNodeKey AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loadImage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD loadImage Procedure 
FUNCTION loadImage RETURNS INTEGER 
  ( INPUT pcImageFile AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-RefreshTree) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD RefreshTree Procedure 
FUNCTION RefreshTree RETURNS LOGICAL
( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-selectNode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD selectNode Procedure 
FUNCTION selectNode RETURNS LOGICAL
  ( INPUT pcNodeKey AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setAutoSort) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setAutoSort Procedure 
FUNCTION setAutoSort RETURNS LOGICAL
  ( INPUT plAutoSort AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setExpandOnAdd) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setExpandOnAdd Procedure 
FUNCTION setExpandOnAdd RETURNS LOGICAL
 (plvar AS LOGICAL  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFullRowSelect) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setFullRowSelect Procedure 
FUNCTION setFullRowSelect RETURNS LOGICAL
 (plvar AS LOGICAL  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setHideSelection) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setHideSelection Procedure 
FUNCTION setHideSelection RETURNS LOGICAL
  ( INPUT plHideSelection AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setImageHeight) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setImageHeight Procedure 
FUNCTION setImageHeight RETURNS LOGICAL
  ( INPUT piImageHeight AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setImageWidth) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setImageWidth Procedure 
FUNCTION setImageWidth RETURNS LOGICAL
  ( INPUT piImageWidth AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setIndentation) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setIndentation Procedure 
FUNCTION setIndentation RETURNS LOGICAL
  (pivar AS INTEGER  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setLabelEdit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setLabelEdit Procedure 
FUNCTION setLabelEdit RETURNS LOGICAL
 (pivar AS INTEGER  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setLineStyle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setLineStyle Procedure 
FUNCTION setLineStyle RETURNS LOGICAL
 (pivar AS INTEGER  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setOLEDrag) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setOLEDrag Procedure 
FUNCTION setOLEDrag RETURNS LOGICAL
  ( plvar AS LOGICAL)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setOLEDrop) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setOLEDrop Procedure 
FUNCTION setOLEDrop RETURNS LOGICAL
( plvar AS LOGICAL)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setProperty) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setProperty Procedure 
FUNCTION setProperty RETURNS LOGICAL
( pcProperty AS CHAR ,
  pcKey      AS CHAR,
  pcValue    AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setScroll) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setScroll Procedure 
FUNCTION setScroll RETURNS LOGICAL
   (plvar AS LOGICAL  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setShowCheckBoxes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setShowCheckBoxes Procedure 
FUNCTION setShowCheckBoxes RETURNS LOGICAL
  ( INPUT plShowCheckBoxes AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setShowRootLines) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setShowRootLines Procedure 
FUNCTION setShowRootLines RETURNS LOGICAL
  ( INPUT plShowRootLines AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSingleSel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setSingleSel Procedure 
FUNCTION setSingleSel RETURNS LOGICAL
 (plvar AS LOGICAL  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setTreeStyle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setTreeStyle Procedure 
FUNCTION setTreeStyle RETURNS LOGICAL
  ( INPUT piTreeStyle AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setTVControllerSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setTVControllerSource Procedure 
FUNCTION setTVControllerSource RETURNS LOGICAL
  ( INPUT phSource AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ValidNodeKey) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD ValidNodeKey Procedure 
FUNCTION ValidNodeKey RETURNS LOGICAL
  ( pcKey AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


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
         HEIGHT             = 15.19
         WIDTH              = 54.4.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/adm2/treeprop.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-addNode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addNode Procedure 
PROCEDURE addNode :
/*------------------------------------------------------------------------------
 Purpose:       This procedure is used to add a node to the treeview. A buffer handle
                is passed which contains the node details.
Parameters:     phBuffer    Handle to buffer of temp table tTreeData which includes
                            the following fields: (as defined in TVController.i)
                  node_key          Unique key of node
                  parent_node_key   Key of either parent node or sibling node(depending on node_insert)
                  node_label        Label of node that appears in treeview
                  private_data      Information stored for the node in the node's TAG' property
                  image             Relative path and filename of the image of the node
                  selected_image    Relative path and filename of the node when it is selected. (If blank,
                                    it used the same image as the image field.
                  node_insert       Specifies where to insert the node, rlative to the parent node
                                    0 - Insert as first node at same level as the parent_node_key
                                    1 - Insert as last node at same level as the parent_node_key
                                    2 - Insert after (next) the parent_node_key 
                                    3 - Insert before (previous) the parent_node_key 
                                    4 - Insert as child of parent_node_key   
                  node_sort         Yes Sort node (This must be specified for all nodes within the same level)
                                    No (default) Do not sort
                  node_expanded     Yes Expand node upon adding it to treeview
                                    No  (default) Do not expand node. 
                  node_checked      YES If  property 'ShowCheckBoxes' is set to yes, the node appears checked.
                                    No (default) Node is not checked.
                  
Note:           This procedure is called from populateTree, but can be called by itself.                            
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER phBuffer AS  HANDLE NO-UNDO.

  /* Buffer field handles */
  DEFINE VARIABLE hNodeKey            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hParentKey          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hNodeLabel          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hPrivateData        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hNodeSort           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hNodeExpand         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hImage              AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hSelectedImage      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hNodeInsert         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hChecked            AS HANDLE     NO-UNDO.

  DEFINE VARIABLE iImageIndex         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iSelectedImageIndex AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iInsertAs           AS INTEGER    NO-UNDO.
  DEFINE VARIABLE chTreeview          AS COM-HANDLE NO-UNDO.
  DEFINE VARIABLE hTreeview           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE chNode              AS COM-HANDLE NO-UNDO.
  DEFINE VARIABLE chParent            AS COM-HANDLE NO-UNDO.

  DEFINE VARIABLE lAutoSort           AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hTreeTable          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cParentKey          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNodeKey            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNodeLabel          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPrivateData        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lChecked            AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lExpand             AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cChildKey           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSortLabel          AS CHARACTER  NO-UNDO.

  IF NOT VALID-HANDLE(phBuffer) THEN DO:
    RUN showTVError('Invalid buffer handle passed to addNode.').
    RETURN ?.
  END.

  /* Get the handle to the TreeView itself. */
  {get TVCtrlFrame hTreeview }.
  ASSIGN chTreeview   = hTreeview:COM-HANDLE
         chTreeview   = chTreeview:CONTROLS:ITEM(1)  
         NO-ERROR. 

  IF NOT VALID-HANDLE(chTreeview) THEN
  DO:
    RUN showTVError('Unable to obtain the com-handle of the TreeView in addNode.').
    RETURN ?.
  END.

  /* Check if the TreeView is set to AutoSort */
  {get AutoSort lAutoSort}.
  /* Grab handles to the fields we are going to need. */
  ASSIGN hNodeKey       = phBuffer:BUFFER-FIELD('node_key':U)
         hParentKey     = phBuffer:BUFFER-FIELD('parent_node_key':U)
         hNodeLabel     = phBuffer:BUFFER-FIELD('node_label':U)
         hPrivateData   = phBuffer:BUFFER-FIELD('private_data':U)
         hImage         = phBuffer:BUFFER-FIELD('image':U)
         hSelectedImage = phBuffer:BUFFER-FIELD('selected_image':U)
         hNodeInsert    = phBuffer:BUFFER-FIELD('node_insert':U)
         hNodeSort      = phBuffer:BUFFER-FIELD('node_sort':U)
         hNodeExpand    = phBuffer:BUFFER-FIELD('node_expanded':U)
         hChecked       = phBuffer:BUFFER-FIELD('node_checked':U)
         NO-ERROR.

  /* Check whether node_key is unique */
  IF hNodeKey:BUFFER-VALUE <> "" AND hNodeKey:BUFFER-VALUE <> ? THEN DO:
    chNode = chTreeview:Nodes:ITEM(hNodeKey:BUFFER-VALUE) NO-ERROR.
    IF VALID-HANDLE(chNode) THEN DO:
      MESSAGE SUBSTITUTE({fnarg messageNumber 83}, hNodeKey:BUFFER-VALUE)  
           VIEW-AS ALERT-BOX INFO BUTTONS OK.
      RELEASE OBJECT chTreeview NO-ERROR.
      RELEASE OBJECT chNode    NO-ERROR.
      RETURN ?.
    END.
  END.
  ELSE 
     hNodeKey:BUFFER-VALUE = DYNAMIC-FUNCTION("getNextNodeKey" IN TARGET-PROCEDURE).
  
     /* Check whether parent node exists */
 IF hParentKey:BUFFER-VALUE <> "" AND hParentKey:BUFFER-VALUE <> ? THEN DO:
   chParent = chTreeview:Nodes:ITEM(hParentKey:BUFFER-VALUE) NO-ERROR.
   IF NOT VALID-HANDLE(chParent) THEN DO:
     MESSAGE SUBSTITUTE({fnarg messageNumber 84}, hParentKey:BUFFER-VALUE)
          VIEW-AS ALERT-BOX INFO BUTTONS OK.
     RETURN.
   END.
   ELSE  /* Set the sorted attribute to the parent */
     chParent:Sorted = IF hNodeSort:BUFFER-VALUE = TRUE THEN 1 ELSE 0.
 END.

   /* If images have been defined, load them into the ImageList and get the index. */
  IF hImage:BUFFER-VALUE <> '':U OR hSelectedImage:BUFFER-VALUE <> '':U THEN
  DO:
    IF hImage:BUFFER-VALUE <> '':U THEN
        iImageIndex = DYNAMIC-FUNCTION("loadImage" IN TARGET-PROCEDURE,  hImage:BUFFER-VALUE).

      IF hSelectedImage:BUFFER-VALUE <> '':U THEN
        iSelectedImageIndex = DYNAMIC-FUNCTION("loadImage" IN TARGET-PROCEDURE, hSelectedImage:BUFFER-VALUE).
        /* If no selectedImage is specified, set it the same as the image */
      IF iImageIndex > 0 AND iSelectedImageIndex = 0 THEN
        iSelectedImageIndex = iImageIndex.
  END. /* End of 'have we got an image conditions. */

  
  /* Validate data is not ? */
  iInsertAs = hNodeInsert:BUFFER-VALUE.
  IF iInsertAs = ? OR iInsertAs > 4 THEN
    iInsertAs = {&tvwFirst}.
  IF hNodeLabel:BUFFER-VALUE = ? THEN
     hNodeLabel:BUFFER-VALUE = "".

 IF hParentKey:BUFFER-VALUE = "" THEN
     hParentKey:BUFFER-VALUE = ?.
  IF NOT VALID-HANDLE(chtreeview) THEN DO:
    {get TVCtrlFrame hTreeview }.
    ASSIGN chTreeview   = hTreeview:COM-HANDLE
           chTreeview   = chTreeview:CONTROLS:ITEM(1)  
           NO-ERROR. 
  END.

  /* Assign buffer values */
  ASSIGN cParentKey   = hParentKey:BUFFER-VALUE
         cNodeKey     = hNodeKey:BUFFER-VALUE
         cNodeLabel   = hNodeLabel:BUFFER-VALUE
         cPrivateData = hPrivateData:BUFFER-VALUE
         lChecked     = hChecked:BUFFER-VALUE
         lExpand      = hNodeExpand:BUFFER-VALUE.

  /* Check if the node to be added is set to Sort, if this is set to sort
     and the AutoSort option is false for the whole TreeView then this means
     we will need to do some manual sorting */
  IF lAutoSort = ? AND cPrivateData <> "@MORE":U THEN
  DO:
    /* We cannot use the getProperty function since it corrups the handles to 
       the nodes causing all sorts of errors when trying to add our new node */
    IF cParentKey <> "" AND cParentKey <> ? THEN DO:
      chNode = chTreeview:Nodes:ITEM(cParentKey) NO-ERROR.
      IF NOT VALID-HANDLE(chNode) THEN
        /* Check whether key is an integer */
        chNode = chTreeview:Nodes:ITEM(INT(cParentKey)) NO-ERROR.
    END.
    
    IF VALID-HANDLE(chNode) THEN
    DO:
      cChildKey = chNode:CHILD:KEY NO-ERROR.
      Child-Loop:
      DO WHILE cChildKey <> "" AND cChildKey <> ?:
        IF cChildKey <> "" AND cChildKey <> ? THEN DO:
          chNode = chTreeview:Nodes:ITEM(cChildKey) NO-ERROR.
          IF NOT VALID-HANDLE(chNode) THEN
          DO:  /* Check whether key is an integer */
            chNode = chTreeview:Nodes:ITEM(INT(cChildKey)) NO-ERROR.
            IF NOT VALID-HANDLE(chNode) THEN
              LEAVE Child-Loop.
          END.
        END.
        cSortLabel  = chNode:TEXT.
        IF cSortLabel > cNodeLabel THEN DO:
          ASSIGN iInsertAs  = IF chNode:TAG = "@MORE":U THEN 2 ELSE 3
                 cParentKey = cChildKey.
          LEAVE Child-Loop.
        END.
        cChildKey  = chNode:NEXT:KEY NO-ERROR.
      END. /* End Loop through Child nodes */
    END.
  END.
  ELSE DO: 
    /* When adding the MORE node as a Child node we want to force it
       to be the last node in the list, here is how */
    IF lAutoSort = ? AND cPrivateData = "@MORE":U AND iInsertAs = 4 THEN
    DO:
      /* We cannot use the getProperty function since it corrups the handles to 
         the nodes causing all sorts of errors when trying to add our new node */
      IF cParentKey <> "" AND cParentKey <> ? THEN DO:
        chNode = chTreeview:Nodes:ITEM(cParentKey) NO-ERROR.
        IF NOT VALID-HANDLE(chNode) THEN
          /* Check whether key is an integer */
          chNode = chTreeview:Nodes:ITEM(INT(cParentKey)) NO-ERROR.
      END.
      IF VALID-HANDLE(chNode) THEN
      DO:
        cChildKey = chNode:CHILD:KEY NO-ERROR.
        IF cChildKey <> "":U AND cChildKey <> ? THEN
          cParentKey = cChildKey.
        iInsertAs = 1.
      END.
    END.
  END.
  
  /* add the node using the add method of the treeview OCX */
  chNode = chTreeview:Nodes:ADD(cParentKey         ,  /* Parent Key (optional) */
                                iInsertAs          ,  /* Insert relative to parent key  0-first 1-last 2-next 3-previous 4-child  */
                                cNodeKey           ,  /* Key - Must be unique */ 
                                cNodeLabel         ,  /* Label Text           */
                                iImageIndex        ,  /* Normal Image         */
                                iSelectedImageIndex). /* Selected Image       */  
  IF VALID-HANDLE(chNode) THEN 
    ASSIGN chNode:TAG = cPrivateData.

  IF lChecked = YES THEN
     chNode:CHECKED = YES.

  IF VALID-HANDLE(chParent) AND NOT chParent:Expanded AND lExpand THEN
     ASSIGN chparent:Expanded = TRUE NO-ERROR. 

  /* Release com-handles */
  RELEASE OBJECT chNode     NO-ERROR.
  RELEASE OBJECT chParent   NO-ERROR.
  RELEASE OBJECT chTreeview NO-ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deleteNode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteNode Procedure 
PROCEDURE deleteNode :
/*------------------------------------------------------------------------------
  Purpose:     Removes an individual node from the tree
  Parameters:  pcKey  A unique string that can be used to retrieve the Node
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE INPUT PARAMETER pckey        AS CHARACTER NO-UNDO.

 DEFINE VARIABLE chTreeView     AS COM-HANDLE NO-UNDO.
 DEFINE VARIABLE Htreeview      AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hTreeDataTable AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hBuf           AS HANDLE     NO-UNDO.
 
  /* Get the handle to the TreeView itself. */
  {get TVCtrlFrame hTreeview }.
  ASSIGN chTreeview   = hTreeview:COM-HANDLE
         chTreeview   = chTreeview:CONTROLS:ITEM(1)  
         NO-ERROR. 

 IF NOT VALID-HANDLE(chTreeView) THEN
 DO:
   RUN showTVError("Unable to get the TreeView's com-handle in updateTree.").
   RETURN ?.
 END.

   /* If no key is specified, remove the current selected key */
 IF pcKey = "" OR pcKey = ? THEN
    pcKey = chTreeView:SelectedItem:KEY NO-ERROR.

  chTreeView:Nodes:Remove(pcKey) NO-ERROR.
 
 RELEASE OBJECT chtreeView NO-ERROR.

  /* C&C - PEVP 2003/01/02 BEGIN:
     Delete node and his subnodes from treeview temp-table 'hTreeDataTable'*/
  {get TreeDataTable hTreeDataTable TARGET-PROCEDURE}.
  hBuf = hTreeDataTable:DEFAULT-BUFFER-HANDLE.
  hBuf:FIND-FIRST(SUBSTITUTE("WHERE &1.node_key = '&2'":u, hBuf:NAME, pckey),NO-LOCK) NO-ERROR.
  IF hBuf:AVAILABLE THEN DO:
    RUN deleteSubnodesInTDT (hBuf:BUFFER-FIELD("node_key":u):BUFFER-VALUE, hTreeDataTable).
    hBuf:BUFFER-DELETE.
  END.
  /* C&C - PEVP 2003/01/02 */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deleteSubnodesInTDT) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteSubnodesInTDT Procedure 
PROCEDURE deleteSubnodesInTDT :
/*------------------------------------------------------------------------------
  Purpose:     Delete nodes in temp-table 'parent_node_key'
  Parameters:  <none>
  Notes:       C&C - PEVP 2002/01/02
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pckey           AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER phTreeDataTable AS HANDLE     NO-UNDO.
  
  DEFINE VARIABLE hBuf     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hQry     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hNodeKey AS HANDLE     NO-UNDO.
  
  CREATE BUFFER hBuf FOR TABLE phTreeDataTable:DEFAULT-BUFFER-HANDLE.
  hNodeKey = hBuf:BUFFER-FIELD("node_key":u).
  CREATE QUERY hQry.
  
  hQry:SET-BUFFERS(hBuf).
  hQry:QUERY-PREPARE(SUBSTITUTE("FOR EACH &1 WHERE &1.parent_node_key = '&2'":U, hBuf:NAME, pcKey)).
  hQry:QUERY-OPEN().
  hQry:GET-FIRST(NO-LOCK).
  
  DO WHILE hBuf:AVAILABLE:
    RUN deleteSubnodesInTDT (hNodeKey:BUFFER-VALUE, phTreeDataTable).
    hBuf:BUFFER-DELETE().
    hQry:GET-NEXT(NO-LOCK).
  END.
  
  DELETE OBJECT hQry.
  DELETE OBJECT hBuf.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deleteTree) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteTree Procedure 
PROCEDURE deleteTree :
/*------------------------------------------------------------------------------
 Purpose:    This procedure can be called to remove nodes from the Tree. 
 Parameters: phTable  Handle of temp table tTreeData (as defined in TVController.i)
 
 Notes:      This differs from deleteNode procedure in that the tempTable can specify
             multiple nodes to delete at one time.
 ------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER phTable AS HANDLE NO-UNDO.

  DEFINE VARIABLE chtreeview AS COM-HANDLE NO-UNDO.
  DEFINE VARIABLE hTreeview  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE chNode     AS COM-HANDLE NO-UNDO.
  DEFINE VARIABLE hBuf       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hNodeKey   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hQry       AS HANDLE     NO-UNDO.

  IF NOT VALID-HANDLE(phTable) THEN
  DO:
    RUN showTVError('Invalid table handle passed to updateTree.').
    RETURN ?.
  END.

  /* Get the handle to the TreeView itself. */
  {get TVCtrlFrame hTreeview }.
  ASSIGN chTreeview   = hTreeview:COM-HANDLE
         chTreeview   = chTreeview:CONTROLS:ITEM(1)  
         NO-ERROR. 
  IF NOT VALID-HANDLE(chtreeview) THEN
  DO:
    RUN showTVError("Unable to get the TreeView's com-handle in updateTree.").
    RETURN {&xcFailure}.
  END.
  
  /* For some instances, the buffer-handle will be passed */
  IF CAN-QUERY(phTable,"DEFAULT-BUFFER-HANDLE":U) THEN
    ASSIGN hBuf = phTable:DEFAULT-BUFFER-HANDLE.
  ELSE
    hBuf = phTable.

  ASSIGN hNodeKey = hBuf:BUFFER-FIELD('Node_Key':U).

  CREATE QUERY hQry.

  hQry:ADD-BUFFER(hBuf).
  hQry:QUERY-PREPARE(SUBSTITUTE('FOR EACH &1':u, phTable:NAME)).
  hQry:QUERY-OPEN().
  hQry:GET-FIRST().

  DO WHILE hBuf:AVAILABLE:

    chNode = hNodeKey:BUFFER-VALUE NO-ERROR.

    IF VALID-HANDLE(chNode) THEN
      chtreeview:Nodes:Remove(chNode:INDEX) NO-ERROR.
    hBuf:BUFFER-DELETE().
    hQry:GET-NEXT.
  END.

  IF VALID-HANDLE(hQry) THEN
    DELETE OBJECT hQry.

  RELEASE OBJECT chtreeview NO-ERROR.
  RELEASE OBJECT chNode     NO-ERROR.
  RETURN {&xcSuccess}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-disableObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disableObject Procedure 
PROCEDURE disableObject :
/*------------------------------------------------------------------------------
 Purpose:  TreeView version of disableObject.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE chtreeview AS COM-HANDLE NO-UNDO.
  DEFINE VARIABLE hTreeview  AS HANDLE     NO-UNDO.

  RUN SUPER.

  /* Get the handle to the TreeView itself. */
  {get TVCtrlFrame hTreeview }.
  ASSIGN chTreeview   = hTreeview:COM-HANDLE
         chTreeview   = chTreeview:CONTROLS:ITEM(1)  
         NO-ERROR. 

  IF VALID-HANDLE(chtreeview) THEN
    chtreeview:ENABLED = 0.

  RELEASE OBJECT chTreeview NO-ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-emptyTree) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE emptyTree Procedure 
PROCEDURE emptyTree :
/*------------------------------------------------------------------------------
 Purpose: Clears all nodes on the TreeView.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE chTreeView AS COM-HANDLE NO-UNDO.
  DEFINE VARIABLE hTreeview  AS HANDLE     NO-UNDO.

 /* Get the handle to the TreeView itself. */
  {get TVCtrlFrame hTreeview }.
  ASSIGN chTreeview   = hTreeview:COM-HANDLE
         chTreeview   = chTreeview:CONTROLS:ITEM(1)  
         NO-ERROR. 

  IF VALID-HANDLE(chTreeView) THEN
  DO:
    chTreeView:Nodes:CLEAR().
    RELEASE OBJECT chTreeview NO-ERROR.
    RETURN {&xcFailure}.
  END.

  RETURN {&xcSuccess}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-enableObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableObject Procedure 
PROCEDURE enableObject :
/*------------------------------------------------------------------------------
 Purpose: TreeView version of enableObject.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE chTreeView AS COM-HANDLE NO-UNDO.
  DEFINE VARIABLE hTreeview  AS HANDLE     NO-UNDO.

  RUN SUPER.

  /* Get the handle to the TreeView itself. */
  {get TVCtrlFrame hTreeview }.
  ASSIGN chTreeview   = hTreeview:COM-HANDLE
         chTreeview   = chTreeview:CONTROLS:ITEM(1)  
         NO-ERROR. 

  IF VALID-HANDLE(chTreeView) THEN
    chTreeView:ENABLED = 1.

  RELEASE OBJECT chTreeview NO-ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject Procedure 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
 Purpose: Intializes all Instance properties of the Treeview OCX. Also set control
          to be hidden when in design mode. This allows the control to be resized.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE lLogicalProp AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iIntProp     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cMode        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hCtrlFrame   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hFrame       AS HANDLE     NO-UNDO.
 
  
  /* Need to super first because initializeObject in smart.p has the 
   * call to control_load in. Prior to this the TreeView and ImageList
   * do not exist. */

  RUN SUPER.
  
  {get UIBMode cMode}.
  IF cMode BEGINS "DESIGN":U THEN
     RETURN.

  /* Set the TreeView properties. We can only do this once the TreeView
   * itself has been instantiated. */
  
  {get AutoSort lLogicalProp}.
  {set AutoSort lLogicalProp}.
  {get HideSelection lLogicalProp}.
  {set HideSelection lLogicalProp}.
  {get ImageWidth iIntProp}.
  {set ImageWidth iIntProp}.
  {get ImageHeight iIntProp}.
  {set ImageHeight iIntProp}.  
  {get ShowCheckBoxes lLogicalProp}.
  {set ShowCheckBoxes lLogicalProp}.
  {get ShowRootLines lLogicalProp}.
  {set ShowRootLines lLogicalProp}.
  {get TreeStyle iIntProp}.
  {set TreeStyle iIntProp}.

  {get ExpandOnAdd lLogicalProp}.
  {set ExpandOnAdd lLogicalProp}.
  {get FullRowSelect lLogicalProp}.
  {set FullRowSelect lLogicalProp}.
  {get OLEDrag lLogicalProp}.
  {set OLEDrag lLogicalProp}.
  {get OLEDrop lLogicalProp}.
  {set OLEDrop lLogicalProp}.
  {get SingleSel lLogicalProp}.
  {set SingleSel lLogicalProp}.
  {get SCROLL lLogicalProp}.
  {set SCROLL lLogicalProp}.

  {get Indentation iIntProp}.
  {set Indentation iIntProp}.
  {get LabelEdit iIntProp}.
  {set LabelEdit iIntProp}.
  {get LineStyle iIntProp}.
  {set LineStyle iIntProp}.
  
  {get UIBMode cMode}.
  {get CtrlFrameHandle hCtrlFrame}.
  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-populateTree) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE populateTree Procedure 
PROCEDURE populateTree :
/*------------------------------------------------------------------------------
 Purpose:   Controls the population of the TreeView. This procedure is passed the handle 
            to a temp-table and the key of the highest level node. The passed node, along 
            with all children, grand children, etc..  of that node are created.
            The temp table tTreeData includes the following fields: (as defined in TVController.i)
                  node_key          Unique key of node
                  parent_node_key   Key of either parent node or sibling node (depending on node_insert)
                  node_label        Label of node that appears in treeview
                  private_data      Information stored for the node in the node's TAG' property
                  image             Relative path and filename of the image of the node
                  selected_image    Relative path and filename of the node when it is selected. (If blank,
                                    it used the same image as the image field.
                  node_insert       Specifies where to insert the node, rlative to the parent node
                                    0 - Insert as first node at same level as the parent_node_key
                                    1 - Insert as last node at same level as the parent_node_key
                                    2 - Insert after (next) the parent_node_key 
                                    3 - Insert before (previous) the parent_node_key 
                                    4 - Insert as child of parent_node_key   
                  node_sort         Yes Sort node (This must be specified for all nodes within the same level)
                                    No (default) Do not sort
                  node_expanded     Yes Expand node upon adding it to treeview
                                    No  (default) Do not expand node. 
                  node_checked      YES If  property 'ShowCheckBoxes' is set to yes, the node appears checked.
                                    No (default) Node is not checked.
Parameters: phTable          Handle of temp table tTreeData.
            pcStartNodeKey   Key of the node of the          
 
 Note:      This routine is called recursively to descend the tree pointed to by
            phTable.
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER phTable        AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER pcStartNodeKey AS CHARACTER NO-UNDO. 

  DEFINE VARIABLE hTreeTable  AS HANDLE NO-UNDO.
  DEFINE VARIABLE hBuf        AS HANDLE NO-UNDO.
  DEFINE VARIABLE hParentKey  AS HANDLE NO-UNDO.
  DEFINE VARIABLE hQry        AS HANDLE NO-UNDO.
  DEFINE VARIABLE hLocalBuffer AS HANDLE  NO-UNDO.

  IF NOT VALID-HANDLE(phTable) THEN
  DO:
    RUN showTVError('Invalid table handle passed to populateTree.').
    RETURN ?.
  END.

  /* For some instances, the buffer-handle will be passed */
  IF CAN-QUERY(phTable,"DEFAULT-BUFFER-HANDLE":U) THEN
    ASSIGN hBuf = phTable:DEFAULT-BUFFER-HANDLE.
  ELSE
    hBuf = phTable.
         
  CREATE BUFFER hLocalBuffer FOR TABLE hBuf BUFFER-NAME "tTreeData":U. 
  ASSIGN hParentKey = hLocalBuffer:BUFFER-FIELD('node_key':u).

  CREATE QUERY hQry.
  hQry:ADD-BUFFER(hLocalBuffer).
  hQry:QUERY-PREPARE(SUBST("FOR EACH &1 WHERE  &1.parent_node_key = '&2' USE-INDEX puNodeKey BY &1.node_key":U,
                           phTable:NAME, pcStartNodeKey)).
  hQry:QUERY-OPEN().
  hQry:GET-FIRST(NO-LOCK) NO-ERROR.

  DO WHILE hLocalBuffer:AVAILABLE:
    RUN addNode IN TARGET-PROCEDURE (hLocalBuffer).
    RUN populateTree IN TARGET-PROCEDURE (phTable, hParentKey:BUFFER-VALUE).
    hQry:GET-NEXT().
  END.
  
  IF VALID-HANDLE(hQry) THEN 
    DELETE OBJECT hQry.

  IF VALID-HANDLE(hLocalBuffer) THEN
    DELETE OBJECT hLocalBuffer.

  RETURN {&xcSuccess}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-repositionObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE repositionObject Procedure 
PROCEDURE repositionObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pdRow AS DECIMAL NO-UNDO.
  DEFINE INPUT PARAMETER pdCol AS DECIMAL NO-UNDO.

  DEFINE VARIABLE hContainer AS HANDLE NO-UNDO.
  DEFINE VARIABLE cMode      AS CHARACTER  NO-UNDO.

  {get ContainerHandle hContainer}.
  {get  UIBMode cMode}.

  IF NOT cMode BEGINS "DESIGN":U THEN
        hContainer:VISIBLE = TRUE.

  ASSIGN hContainer:ROW    = pdRow
         hContainer:COLUMN = pdCol 
         NO-ERROR.
 
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resizeObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeObject Procedure 
PROCEDURE resizeObject :
/*------------------------------------------------------------------------------
  Purpose: Resizes the SmartTreeView. 
 ------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pdHeight AS DECIMAL NO-UNDO.
  DEFINE INPUT PARAMETER pdWidth  AS DECIMAL NO-UNDO.
  
  DEFINE VARIABLE hFrame        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hCtrlFrame    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE dMinWidth     AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dMinHeight    AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE cMode         AS CHARACTER  NO-UNDO.

  {get ContainerHandle hFrame}.
  {get CtrlFrameHandle hCtrlFrame}.
  {get MinWidth  dMinWidth}.
  {get MinHeight dMinHeight}.

  ASSIGN pdWidth  = MAX(pdWidth,dMinWidth)
         pdHeight = MAX(pdHeight,dMinHeight).
  

  IF hFrame:WIDTH < pdWidth THEN
    ASSIGN
        hFrame:WIDTH     = pdWidth
        hCtrlFrame:WIDTH = pdWidth - 0.5
        NO-ERROR.
  ELSE
    ASSIGN
        hCtrlFrame:WIDTH = pdWidth - 0.5
        hFrame:WIDTH     = pdWidth
        NO-ERROR.

  IF hFrame:HEIGHT < pdHeight THEN
    ASSIGN
        hFrame:HEIGHT     = pdHeight
        hCtrlFrame:HEIGHT = pdHeight 
        NO-ERROR.
  ELSE
    ASSIGN
        hCtrlFrame:HEIGHT = pdHeight 
        hFrame:HEIGHT     = pdHeight
        NO-ERROR.
 
  /* When in design mode - hide the object to allow 
         the developer to move and resize the control     */
  {get UIBMode cMode}.
  ASSIGN hCtrlFrame:HIDDEN = IF cMode BEGINS 'DESIGN':U THEN TRUE ELSE FALSE
         hFrame            = hCtrlFrame:FRAME
         hFrame:BGCOLOR    = IF cMode BEGINS 'DESIGN':U THEN 15 ELSE ?
         .

 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-selectFirstNode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE selectFirstNode Procedure 
PROCEDURE selectFirstNode :
/*------------------------------------------------------------------------------
 Purpose: Selects the first node in the TreeView. 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE chTreeView AS COM-HANDLE NO-UNDO.
  DEFINE VARIABLE chNode     AS COM-HANDLE NO-UNDO.
  DEFINE VARIABLE hTreeview  AS HANDLE     NO-UNDO.
  /* Get the handle to the TreeView itself. */
  {get TVCtrlFrame hTreeview }.
  ASSIGN chTreeview   = hTreeview:COM-HANDLE
         chTreeview   = chTreeview:CONTROLS:ITEM(1)  
         NO-ERROR. 

  IF VALID-HANDLE(chTreeView) THEN
  DO:
    IF chTreeView:Nodes:COUNT > 0 THEN
    DO:
      chNode = chTreeView:Nodes:ITEM(1).

      IF VALID-HANDLE(chNode) THEN
      DO:
        chNode:SELECTED = 1.
        RELEASE OBJECT chTreeview NO-ERROR.
        RELEASE OBJECT chNode NO-ERROR.
        RETURN {&xcSuccess}.
      END.
    END.
  END.
  
  RELEASE OBJECT chTreeview NO-ERROR.
  RELEASE OBJECT chNode      NO-ERROR.
  RETURN {&xcFailure}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-showTVError) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE showTVError Procedure 
PROCEDURE showTVError :
/*------------------------------------------------------------------------------
  Purpose:     Displays error messages.
  Parameters:  pcMessage   Message to display.
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcMessage AS CHARACTER NO-UNDO.

  DEFINE VARIABLE cButton    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hContainer AS HANDLE   NO-UNDO.
  

  {get ContainerSource hContainer TARGET-PROCEDURE} NO-ERROR.  
    IF VALID-HANDLE(gshSessionManager) AND valid-handle(hContainer) THEN
    RUN showMessages IN gshSessionManager (INPUT  pcMessage,          /* message to display */
                                           INPUT  "ERR":U,            /* error type         */
                                           INPUT  "&OK":U,            /* button list        */
                                           INPUT  "&OK":U,            /* default button     */ 
                                           INPUT  "&OK":U,            /* cancel button      */
                                           INPUT  "TreeView Error":U, /* error window title */
                                           INPUT  YES,                /* display if empty   */ 
                                           INPUT  hContainer,         /* container handle   */ 
                                           OUTPUT cButton).           /* button pressed     */

  ELSE
    MESSAGE pcMessage
            VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN "".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateTree) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateTree Procedure 
PROCEDURE updateTree :
/*------------------------------------------------------------------------------
 Purpose:    This procedure can be called to update details of nodes that are currently 
             in the tree.
 Parameters: phTable    Table handle of tTreeData  
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER phTable AS HANDLE NO-UNDO.

  DEFINE VARIABLE chtreeview   AS COM-HANDLE NO-UNDO.
  DEFINE VARIABLE hTreeview    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cNodeKey     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE chNode       AS COM-HANDLE NO-UNDO.
  DEFINE VARIABLE hBuf         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hNodeKey     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hNodeLabel   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hPrivateData AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hQry         AS HANDLE     NO-UNDO.

  IF NOT VALID-HANDLE(phTable) THEN
  DO:
    RUN showTVError('Invalid table handle passed to updateTree.').
    RETURN ?.
  END.

   /* Get the handle to the TreeView itself. */
  {get TVCtrlFrame hTreeview }.
  ASSIGN chTreeview   = hTreeview:COM-HANDLE
         chTreeview   = chTreeview:CONTROLS:ITEM(1)  
         NO-ERROR. 

  IF NOT VALID-HANDLE(chtreeview) THEN
  DO:
    RUN showTVError("Unable to get the TreeView's com-handle in updateTree.").
    RETURN ?.
  END.

  IF CAN-QUERY(phTable,"DEFAULT-BUFFER-HANDLE":U) THEN
    ASSIGN hBuf = phTable:DEFAULT-BUFFER-HANDLE.
  ELSE
    hBuf = phTable.

  ASSIGN hNodeKey     = hBuf:BUFFER-FIELD('Node_Key':U)
         hNodeLabel   = hBuf:BUFFER-FIELD('Node_Label':U)
         hPrivateData = hBuf:BUFFER-FIELD('Private_Data':U).

  CREATE QUERY hQry.

  hQry:ADD-BUFFER(hBuf).
  hQry:QUERY-PREPARE(SUBST('FOR EACH &1':U, phTable:NAME)).
  hQry:QUERY-OPEN().
  hQry:GET-FIRST().

  DO WHILE hBuf:AVAILABLE:

    cNodeKey = hNodeKey:BUFFER-VALUE NO-ERROR.
    
    IF cNodeKey = "" OR cNodeKey = ? THEN
       cNodeKey = chtreeview:SelectedItem:KEY NO-ERROR.

    IF cNodeKey <> "" AND cNodeKey <> ? THEN DO:
      chNode = chtreeview:Nodes:ITEM(cNodeKey) NO-ERROR.
      IF ERROR-STATUS:ERROR THEN DO:  /* Check whether key is an integer */
        chNode = chtreeview:Nodes:ITEM(INT(cNodeKey)) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
          RUN showTVError (INPUT "The key you have specified does not exist.").
          RELEASE OBJECT chTreeview NO-ERROR.
          RETURN.
        END.
      END.
    END.

    IF VALID-HANDLE(chNode) THEN DO:
      ASSIGN chNode:TEXT = hNodeLabel:BUFFER-VALUE
             chNode:TAG  = hPrivateData:BUFFER-VALUE.
      RELEASE OBJECT chNode NO-ERROR.
    END.

    hQry:GET-NEXT.
  END.

  IF VALID-HANDLE(hQry) THEN
    DELETE OBJECT hQry.
  
  RELEASE OBJECT chTreeview NO-ERROR.
  RETURN {&xcSuccess}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-ExpandNode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION ExpandNode Procedure 
FUNCTION ExpandNode RETURNS LOGICAL
  ( INPUT pcNodeKey AS CHARACTER,
    INPUT plExpand  AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  This function will either expand or collapse a node 
Parameters: pcNodeKey  Key of node to expand/collapse 
            plNode     TRUE  - Expand
                       FALSE - Collapse
------------------------------------------------------------------------------*/
  DEFINE VARIABLE chNodeKey   AS COM-HANDLE NO-UNDO.  
  DEFINE VARIABLE chTreeview  AS COM-HANDLE NO-UNDO.
  DEFINE VARIABLE hTreeview   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cNodeKey    AS CHARACTER  NO-UNDO.
  
   /* Get the handle to the TreeView itself. */
  {get TVCtrlFrame hTreeview }.
  ASSIGN chTreeview   = hTreeview:COM-HANDLE
         chTreeview   = chTreeview:CONTROLS:ITEM(1)  
         NO-ERROR. 

  chNodeKey = ?.

  IF pcNodeKey = "" OR pcNodeKey = ? THEN
     pcNodeKey = chTreeview:SelectedItem:KEY NO-ERROR.

  IF pcNodeKey <> "" AND pcNodeKey <> ? THEN DO:
      chNodeKey = chTreeview:Nodes:ITEM(pcNodeKey) NO-ERROR.
      IF NOT VALID-HANDLE(chNodeKey) THEN
      DO:  /* Check whether key is an integer */
         chNodeKey = chTreeview:Nodes:ITEM(INT(pcNodeKey)) NO-ERROR.
         IF NOT VALID-HANDLE(chNodeKey) THEN
         DO:
            RUN showTVError (INPUT "The key you have specified does not exist.").
            RELEASE OBJECT chTreeview NO-ERROR.
            RETURN ?.
         END.
      END.
  END.
  
  IF VALID-HANDLE(chNodeKey) THEN
    ASSIGN chNodeKey:EXPANDED = plExpand
           NO-ERROR.
  RELEASE OBJECT chNodeKey NO-ERROR.
  chNodeKey = ?.
  RELEASE OBJECT chTreeview NO-ERROR.
  
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getAutoSort) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getAutoSort Procedure 
FUNCTION getAutoSort RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
 Purpose: Returns whether the root nose should be sorted. 
 ------------------------------------------------------------------------------*/
DEFINE VARIABLE lAutoSort AS LOGICAL    NO-UNDO.

  &SCOPED-DEFINE xpAutoSort
  {get AutoSort lAutoSort}.
  &UNDEFINE xpAutoSort

  RETURN lAutoSort.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getExpandOnAdd) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getExpandOnAdd Procedure 
FUNCTION getExpandOnAdd RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Gets the Expanded property of the tree . 
------------------------------------------------------------------------------*/
 DEFINE VARIABLE lVar        AS LOGICAL NO-UNDO.
  
  {get ExpandOnAdd lVar}.
  
  RETURN lVar.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFullRowSelect) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFullRowSelect Procedure 
FUNCTION getFullRowSelect RETURNS LOGICAL
 (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Gets the FullRowSelect property of the tree . If Yes, the entire node
            (text and icon)  is highlighted
------------------------------------------------------------------------------*/
 DEFINE VARIABLE lProp         AS LOGICAL NO-UNDO.
 
 &SCOPED-DEFINE xpFullRowSelect
 {get FullRowSelect lProp}.
 &UNDEFINE xpFullRowSelect
 
 RETURN lProp.


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getHideSelection) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getHideSelection Procedure 
FUNCTION getHideSelection RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
 Purpose: Returns whether the current node in the TreeView will remain highlighted 
          when focus leaves the TreeView.
 
 Note:    The {get HideSelection ...} syntax is not used. This is because there 
          is no xpHideSelection defined for this property so that setHideSelection() is
          always called.
------------------------------------------------------------------------------*/
DEFINE VARIABLE lHide AS LOGICAL    NO-UNDO.

  &SCOPED-DEFINE xpHideSelection
  {get HideSelection lHide}.
  &UNDEFINE xpHideSelection

  RETURN lHide.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getImageHeight) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getImageHeight Procedure 
FUNCTION getImageHeight RETURNS INTEGER
  (  ) :
/*------------------------------------------------------------------------------
 Purpose:  Returns the height of images in the image list associated with the TreeView.
 
 Note:     The {get ImageHeight ...} syntax is not used. This is because there 
 is no xpImageHeight defined for this property so that setImageHeight() is
 always called.
------------------------------------------------------------------------------*/
DEFINE VARIABLE iHeight AS INTEGER    NO-UNDO.

  &SCOPED-DEFINE xpImageHeight
  {get ImageHeight iHeight}.
  &UNDEFINE xpImageHeight

  RETURN iHeight.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getImageWidth) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getImageWidth Procedure 
FUNCTION getImageWidth RETURNS INTEGER
  (  ) :
/*------------------------------------------------------------------------------
Purpose:  Returns the width of images in the image list associated with the TreeView.
 
 Note:    The {get ImageWidth ...} syntax is not used. This is because there 
 is no xpImageWidth defined for this property so that setImageWidth() is
 always called.
------------------------------------------------------------------------------*/
DEFINE VARIABLE iWidth AS INTEGER    NO-UNDO.

  &SCOPED-DEFINE xpImageWidth
  {get ImageWidth iWidth}.
  &UNDEFINE xpImageWidth

  RETURN iWidth.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getIndentation) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getIndentation Procedure 
FUNCTION getIndentation RETURNS INTEGER
 (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Gets the Indentation property of the tree . This is the number of pixels
            of indentation between a node and it's child node.
------------------------------------------------------------------------------*/
DEFINE VARIABLE iProp         AS INTEGER NO-UNDO.
 
  &SCOPED-DEFINE xpIndentation
  {get Indentation iProp}.
  &UNDEFINE xpIndentation
   
  RETURN iProp.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLabelEdit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getLabelEdit Procedure 
FUNCTION getLabelEdit RETURNS INTEGER
(  ) :
/*------------------------------------------------------------------------------
  Purpose:  Gets the LabelEdit property of the tree. If yes, the user can click on the
            node to edit it.
------------------------------------------------------------------------------*/
DEFINE VARIABLE iProp         AS INTEGER NO-UNDO.
 
  &SCOPED-DEFINE xpLabelEdit
  {get LabelEdit iProp}.
  &UNDEFINE xpLabelEdit
 
  RETURN iProp.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLineStyle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getLineStyle Procedure 
FUNCTION getLineStyle RETURNS INTEGER
(  ) :
/*------------------------------------------------------------------------------
  Purpose:  Gets the LineStyle property of the tree. 
            0  (Default) Tree lines. Displays lines between Node siblings and their 
            parent Node. 
            1  Root Lines. In addition to displaying lines between Node siblings and 
               their parent Node, also displays lines between the root nodes. 

------------------------------------------------------------------------------*/
DEFINE VARIABLE iProp         AS INTEGER NO-UNDO.
 
  &SCOPED-DEFINE xpLineStyle
  {get LineStyle iProp}.
  &UNDEFINE xpLineStyle
 
  RETURN iProp.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getOLEDrag) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getOLEDrag Procedure 
FUNCTION getOLEDrag RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns whether OLEDrag is supported
    Notes:  
------------------------------------------------------------------------------*/
 DEFINE VARIABLE lCheck         AS LOGICAL NO-UNDO.
 
 &SCOPED-DEFINE xpOLEDrag
 {get OLEDrag lCheck}.
 &UNDEFINE xpOLEDrag
 
 RETURN lCheck.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getOLEDrop) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getOLEDrop Procedure 
FUNCTION getOLEDrop RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:   Returns whether OLEDrop is supported
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE lCheck         AS LOGICAL NO-UNDO.
 
  &SCOPED-DEFINE xpOLEDrop
  {get OLEDrop lCheck}.
  &UNDEFINE xpOLEDrop
 
  RETURN lCheck.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getProperty) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getProperty Procedure 
FUNCTION getProperty RETURNS CHARACTER
  ( pcProperty AS CHAR ,
    pcKey  AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:      Sets the specified treeview property 
  Paramaters:   pcProperty  Name of specified property
                   BACKCOLOR     gets the background color of the requested note 
                   BOLD          Gets whether the Node is bold
                   CHECKED       Gets whether the node is checked 
                   CHILD         Gets the firsat child node
                   CHILDREN      Gets the number of children for a specific node
                   COUNT         Gets the number of nodes in the tree
                   EXPANDED      Gets whether the node is expanded or collapsed
                   FIRSTSIBLING  gets the first sibling of a specified node
                   FORECOLOR     Gets the foreground color of the requested note 
                   FULLPATH      gets the full path of a specified node
                   GETVISIBLECOUNT Gets the # of visible nodes
                   IMAGE         Gets the image (contained in imagelist) for a node
                   INDEX         gets the index of the node
                   KEY           gets the unique key ot a specified node
                   LASTSIBLING   gets the last  sibling of a specified node
                   PARENT        gets the parent of a specified node
                   NEXT          gets the next node key
                   PATHSEPARATOR Gets the delimiter returned by the FullPath property
                   PREVIOUS      gets the previous node key
                   ROOT          gets the root of a specified node
                   SELECTEDITEM  Gets the selected node
                   SORTED        Gets whether the children of the specified node is sorted
                   TAG           Gets the tag of the specified node
                   TEXT          Gets the label text of the specified node
                   VISIBLE       Gets whether the entire tree is visible/invisible
              
                pcKey     Key of specified node. (IF blank, selected node is used)
    
    Syntax:     cCount = Dynamic-Function("getProperty" in h_Treeview, "COUNT","")
                do i = 1 to INT(cCount):
------------------------------------------------------------------------------*/
 DEFINE VARIABLE cValue         AS CHARACTER NO-UNDO.
 DEFINE VARIABLE chtreeview     AS COM-HANDLE NO-UNDO.
 DEFINE VARIABLE hTreeview      AS HANDLE     NO-UNDO.
 DEFINE VARIABLE chNodeKey      AS COM-HANDLE NO-UNDO.

  /* Get the handle to the TreeView itself. */
  {get TVCtrlFrame hTreeview }.
  ASSIGN chTreeview   = hTreeview:COM-HANDLE
         chTreeview   = chTreeview:CONTROLS:ITEM(1)  
         NO-ERROR. 

 IF pcKey = "" OR pcKey = ? THEN
    pcKey = chtreeview:SelectedItem:KEY NO-ERROR.
 
 IF pcKey <> "" AND pcKey <> ? THEN DO:
     chNodeKey = chtreeview:Nodes:ITEM(pckey) NO-ERROR.
     IF NOT VALID-HANDLE(chNodeKey) THEN
     DO:  /* Check whether key is an integer */
        chNodeKey = chtreeview:Nodes:ITEM(INT(pckey)) NO-ERROR.
        IF NOT VALID-HANDLE(chNodeKey) THEN
        DO:
           RUN showTVError (INPUT "The key you have specified does not exist." + pcKey).
           RELEASE OBJECT chtreeview NO-ERROR.
           RETURN ?.
        END.
     END.
 END.
  
  CASE pcProperty:
      WHEN "BACKCOLOR":U THEN DO:
        IF VALID-HANDLE(chNodeKey) THEN
           cValue = STRING(chNodeKey:BackColor) NO-ERROR.
      END.
      WHEN "BOLD":U THEN DO:
        IF VALID-HANDLE(chNodeKey) THEN
           cValue = (IF chNodeKey:Bold = TRUE THEN "yes":U ELSE "no":U) NO-ERROR.
      END.
      WHEN "CHECKED":U THEN
        IF VALID-HANDLE(chNodeKey) THEN
           cValue = (IF chNodeKey:CHECKED = TRUE THEN "yes":U ELSE "no":U) NO-ERROR.

      WHEN "CHILD":U THEN
        IF VALID-HANDLE(chNodeKey) THEN
           cValue = chNodeKey:Child:KEY NO-ERROR.

      WHEN "CHILDREN":U THEN
        IF VALID-HANDLE(chNodeKey) THEN
           cValue = STRING(chNodeKey:Children) NO-ERROR.
      
      WHEN "COMHANDLE":U THEN DO:
         RELEASE OBJECT chtreeview NO-ERROR.
         RETURN STRING(chNodeKey).
      END.
      
      WHEN "COUNT":U THEN
        cValue = STRING(chtreeview:Nodes:Count) NO-ERROR.
      
      WHEN "EXPANDED":U THEN
        IF VALID-HANDLE(chNodeKey) THEN
           cValue = (IF chNodeKey:Expanded = TRUE THEN "yes":U ELSE "no":U) NO-ERROR.
           
      WHEN "FIRSTSIBLING":U THEN
        IF VALID-HANDLE(chNodeKey) THEN
           cValue = chNodeKey:FirstSibling:KEY NO-ERROR.
      
      WHEN "FORECOLOR" THEN DO:
        IF VALID-HANDLE(chNodeKey) THEN
           cValue = STRING(chNodeKey:ForeColor) NO-ERROR.
      END.
           
      WHEN "FULLPATH":U THEN
        IF VALID-HANDLE(chNodeKey) THEN
           cValue = chNodeKey:FullPath NO-ERROR.
      
      WHEN "GETVISIBLECOUNT":U THEN
        cValue = STRING(chtreeview:GetVisibleCount()) NO-ERROR.
           
      WHEN "KEY":U THEN
        IF VALID-HANDLE(chNodeKey) THEN
           cValue = chNodeKey:KEY NO-ERROR.
      
      WHEN "IMAGE":U THEN
        IF VALID-HANDLE(chNodeKey) THEN
           cValue = chNodeKey:IMAGE NO-ERROR.
      
      WHEN "INDEX":U THEN
        IF VALID-HANDLE(chNodeKey) THEN
           cValue = string(chNodeKey:INDEX) NO-ERROR.     

      WHEN "LASTSIBLING":U THEN
        IF VALID-HANDLE(chNodeKey) THEN
           cValue = chNodeKey:LastSibling:KEY NO-ERROR.           
           
      WHEN "NEXT":U THEN
        IF VALID-HANDLE(chNodeKey) THEN
           cValue = chNodeKey:Next:KEY NO-ERROR.
           
      WHEN "PARENT":U THEN DO:
        IF VALID-HANDLE(chNodeKey) THEN
           cValue = chNodeKey:Parent:KEY  NO-ERROR.           
        IF cValue = ? THEN
          cValue = getRootNodeParentKey().
      END.
      
      WHEN "PATHSEPARATOR":U THEN
           cValue = chtreeview:PathSeparator NO-ERROR.
      
      WHEN "PREVIOUS":U THEN
        IF VALID-HANDLE(chNodeKey) THEN
           cValue = chNodeKey:Previous:KEY NO-ERROR.
           
      WHEN "ROOT":U THEN
        IF VALID-HANDLE(chNodeKey) THEN
           cValue = chNodeKey:Root:KEY NO-ERROR.           
      
      WHEN "SELECTEDITEM":u THEN
         cValue = chtreeview:SelectedItem:KEY NO-ERROR.
                
      WHEN "SORTED":U THEN
        IF VALID-HANDLE(chNodeKey) THEN
           cValue = (IF chNodeKey:Sorted = TRUE THEN "yes":U ELSE "no":U) NO-ERROR.

      WHEN "TAG":U THEN
        IF VALID-HANDLE(chNodeKey) THEN
           cValue = chNodeKey:Tag NO-ERROR.

      WHEN "TEXT":U THEN
        IF VALID-HANDLE(chNodeKey) THEN
           cValue = chNodeKey:TEXT NO-ERROR.
      
      WHEN "VISIBLE":U THEN
        IF VALID-HANDLE(chNodeKey) THEN
           cvalue = (IF chNodeKey:VISIBLE = TRUE THEN "yes":U ELSE "no":U) NO-ERROR.
      OTHERWISE DO:
           RUN showTVError (INPUT "The requested property " + pcProperty + " is not available.").
           cValue = ?.
      END.

  END CASE.
  
  RELEASE OBJECT chNodeKey NO-ERROR.
  RELEASE OBJECT chtreeview NO-ERROR.
 
  
  RETURN cValue.   

  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRootNodeParentKey) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getRootNodeParentKey Procedure 
FUNCTION getRootNodeParentKey RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
 Purpose: Returns the value to use as the ParentKey for root nodes on the tree. By
          searching for nodes with this value as the parent all the root nodes can
          be found.
------------------------------------------------------------------------------*/

  RETURN {&xcRootNodeParentKey}.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getScroll) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getScroll Procedure 
FUNCTION getScroll RETURNS LOGICAL
 (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Gets the Scroll property of the tree. If yes, scrollbars appear.
------------------------------------------------------------------------------*/
DEFINE VARIABLE lProp         AS LOGICAL NO-UNDO.
 
  &SCOPED-DEFINE xpScroll
  {get SCROLL lProp}.
  &UNDEFINE xpScroll
 
  RETURN lProp.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getShowCheckBoxes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getShowCheckBoxes Procedure 
FUNCTION getShowCheckBoxes RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
 Purpose: Returns whether there will be check boxes beside each node on the TreeView.
 
 ------------------------------------------------------------------------------*/
DEFINE VARIABLE lShowBoxes AS LOGICAL    NO-UNDO.

  &SCOPED-DEFINE xpShowCheckBoxes
  {get ShowCheckBoxes lShowBoxes}.
  &UNDEFINE xpShowCheckBoxes

  RETURN lShowBoxes.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getShowRootLines) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getShowRootLines Procedure 
FUNCTION getShowRootLines RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
 Purpose: Returns whether there should be lines leading to the roots of the tree or
          not.
 Note:    Same as getLineStyle.
 ------------------------------------------------------------------------------*/
DEFINE VARIABLE lShowLines AS LOGICAL    NO-UNDO.

  &SCOPED-DEFINE xpShowRootLines
  {get ShowRootLines lShowLines}.
  &UNDEFINE xpShowRootLines

  RETURN lShowLines.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSingleSel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSingleSel Procedure 
FUNCTION getSingleSel RETURNS LOGICAL
(  ) :
/*------------------------------------------------------------------------------
  Purpose:  Gets the SingleSel property of the tree. If yes, the node is expnaded 
            when the node is selected or clicked.
------------------------------------------------------------------------------*/
DEFINE VARIABLE lProp         AS LOGICAL NO-UNDO.
 
  &SCOPED-DEFINE xpSingleSel
  {get SingleSel lProp}.
  &UNDEFINE xpSingleSel
 
  RETURN lProp.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTreeStyle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTreeStyle Procedure 
FUNCTION getTreeStyle RETURNS INTEGER
  (  ) :
/*------------------------------------------------------------------------------
 Purpose: Returns style of the TreeView. Possible values are:
          0 Text only. 
          1 Image and text. 
          2 Plus/minus and text. 
          3 Plus/minus, image, and text. 
          4 Lines and text. 
          5 Lines, image, and text. 
          6 Lines, plus/minus, and text. 
          7 (Default) Lines, plus/minus, image, and text. 
 ------------------------------------------------------------------------------*/
DEFINE VARIABLE iStyle AS INTEGER    NO-UNDO.

  &SCOPED-DEFINE xpTreeStyle
  {get TreeStyle iStyle}.
  &UNDEFINE xpTreeStyle

  RETURN iStyle.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTVControllerSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTVControllerSource Procedure 
FUNCTION getTVControllerSource RETURNS HANDLE
  ( ) :
/*------------------------------------------------------------------------------
 Purpose: Returns the handle of the procedure that is controlling this TreeView.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hSource AS HANDLE NO-UNDO.

  {get TVControllerSource hSource}.

  RETURN hSource.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-isNodeExpanded) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION isNodeExpanded Procedure 
FUNCTION isNodeExpanded RETURNS LOGICAL
  ( INPUT pcNodeKey AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Receives the handle to a node and returns TRUE if that node is expanded
Parameter:  pcNodeKey   Name of key to verify.    
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE chNodeKey      AS COM-HANDLE NO-UNDO.  
  DEFINE VARIABLE chtreeview    AS COM-HANDLE NO-UNDO.
  DEFINE VARIABLE hTreeview     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lNodeExpanded AS LOGICAL    NO-UNDO.

  /* Get the handle to the TreeView itself. */
  {get TVCtrlFrame hTreeview }.
  ASSIGN chTreeview   = hTreeview:COM-HANDLE
         chTreeview   = chTreeview:CONTROLS:ITEM(1)  
         NO-ERROR. 

  chNodeKey = ?.

  IF pcNodeKey = "" OR pcNodeKey = ? THEN
     pcNodeKey = chtreeview:SelectedItem:KEY NO-ERROR.

  IF pcNodeKey <> "" AND pcNodeKey <> ? THEN DO:
      chNodeKey = chtreeview:Nodes:ITEM(pcNodeKey) NO-ERROR.
      IF NOT VALID-HANDLE(chNodeKey) THEN
      DO:  /* Check whether key is an integer */
         chNodeKey = chtreeview:Nodes:ITEM(INT(pcNodeKey)) NO-ERROR.
         IF NOT VALID-HANDLE(chNodeKey) THEN
         DO:
            RUN showTVError (INPUT "The key you have specified does not exist.").
            RELEASE OBJECT chtreeview NO-ERROR.
            RETURN ?.
         END.
      END.
  END.

  IF VALID-HANDLE(chNodeKey) THEN DO:
    lNodeExpanded = chNodeKey:Expanded.
    RELEASE OBJECT chNodeKey NO-ERROR.
    chNodeKey = ?.
    RELEASE OBJECT chtreeview NO-ERROR.
    RETURN lNodeExpanded.
  END.
    
  RELEASE OBJECT chtreeview NO-ERROR.
  RETURN FALSE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loadImage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION loadImage Procedure 
FUNCTION loadImage RETURNS INTEGER 
  ( INPUT pcImageFile AS CHARACTER ) :
/*------------------------------------------------------------------------------
 Purpose:  Takes the file referenced in pcImageFile, checks to see if it is already in
           the ImageList and if not, loads it. If this is successful then its index in 
           the ImageList is returned. If the file is already in the ImageList, its index is returned.
 
           If the load fails, 0 is returned.
 
 Note:    The filename must specify the relative path and filename with the extension.
 
          Since the imagelist does not contain any images, the ImageList property is assigned 
          to the Treeview only once, after an image is added.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE chImage      AS COM-HANDLE NO-UNDO.
  DEFINE VARIABLE chNewImage   AS COM-HANDLE NO-UNDO.
  DEFINE VARIABLE chTreeview   AS COM-HANDLE NO-UNDO.
  DEFINE VARIABLE hTreeview    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iImageIndex  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE chImageList  AS COM-HANDLE NO-UNDO.
  DEFINE VARIABLE hImageList   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cExtension   AS CHARACTER  NO-UNDO.

  /* Check if we have an image to load */
  IF pcImageFile = ? OR
     pcImageFile = "":U THEN
    RETURN 0.
  /* Find out if the image has already been loaded. If it has we need to 
   * find its index. */
  /* Get the handle to the TreeView itself. */
  {get TVCtrlFrame hTreeview }.
  ASSIGN chTreeview   = hTreeview:COM-HANDLE
         chTreeview   = chTreeview:CONTROLS:ITEM(1)  
         NO-ERROR. 
    
  {get ILCtrlFrame hImageList }.
  ASSIGN chImageList   = hImageList:COM-HANDLE
         chImageList   = chImageList:CONTROLS:ITEM(1)  
         NO-ERROR. 

  chImage = chImageList:ListImages:ITEM(pcImageFile) NO-ERROR.

  IF NOT VALID-HANDLE(chImage) THEN
  DO:
    /* Get the full path of the image */
    FILE-INFO:FILE-NAME = pcImageFile.

    IF FILE-INFO:FULL-PATHNAME <> ? THEN
    DO:
    
      /* Ensure that the image type is one that is supported by the LOAD-PICTURE statement */
      ASSIGN cExtension = ENTRY(NUM-ENTRIES(pcImageFile, ".":U),pcImageFile, ".":U) NO-ERROR.
  
      IF LOOKUP(cExtension,"BMP,WMF,EMF,ICO,CUR,DIB":U) = 0 
      OR LOOKUP(cExtension,"BMP,WMF,EMF,ICO,CUR,DIB":U) = ? THEN
          RETURN 0.
      
      chImage = LOAD-PICTURE(FILE-INFO:FULL-PATHNAME).
    END.

    IF VALID-HANDLE(chImage) THEN
    DO:
      ASSIGN chNewImage  = chImageList:ListImages:ADD(chImageList:ListImages:COUNT + 1, pcImageFile, chImage)
             iImageIndex = chNewImage:INDEX.
      /* assign the imagelist to the treeview */
      IF chImageList:ListImages:COUNT = 1 THEN DO:
          chTreeview:ImageList = chImageList.
      END.
    END.
  END.
  ELSE
    iImageIndex = chImage:INDEX.

  RELEASE OBJECT chImage     NO-ERROR.
  RELEASE OBJECT chNewImage  NO-ERROR.
  RELEASE OBJECT chtreeview  NO-ERROR.
  RELEASE OBJECT chImageList NO-ERROR.
   
  RETURN iImageIndex.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-RefreshTree) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION RefreshTree Procedure 
FUNCTION RefreshTree RETURNS LOGICAL
( ) :
/*------------------------------------------------------------------------------
  Purpose:  Refreshes the treeview
------------------------------------------------------------------------------*/
 DEFINE VARIABLE chTreeview  AS COM-HANDLE NO-UNDO.
 DEFINE VARIABLE hTreeview   AS HANDLE     NO-UNDO.
 
 DEFINE VARIABLE lok        AS LOGICAL NO-UNDO. 
 
  /* Get the handle to the TreeView itself. */
  {get TVCtrlFrame hTreeview }.
  ASSIGN chTreeview   = hTreeview:COM-HANDLE
         chTreeview   = chTreeview:CONTROLS:ITEM(1)  
         NO-ERROR. 
           
 IF VALID-HANDLE(chTreeview) THEN
    lok = chTreeview:REFRESH NO-ERROR.
    
 RELEASE OBJECT chTreeview NO-ERROR. 

 RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-selectNode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION selectNode Procedure 
FUNCTION selectNode RETURNS LOGICAL
  ( INPUT pcNodeKey AS CHARACTER) :
/*------------------------------------------------------------------------------
 Purpose:   Switches focus to node passed in by pchNodeKey and selects this node. Also 
            generates a tvNodeSelected event.
Parameters: pcNodeKey  Key of node to select.          
------------------------------------------------------------------------------*/
  DEFINE VARIABLE chTreeview      AS COM-HANDLE NO-UNDO.
  DEFINE VARIABLE hTreeview       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE chNodeKey       AS COM-HANDLE NO-UNDO.
  DEFINE VARIABLE hTreeviewFrame  AS HANDLE     NO-UNDO.
  
  /* Get the handle to the TreeView itself. */
  {get TVCtrlFrame hTreeview }.
  ASSIGN chTreeview   = hTreeview:COM-HANDLE
         chTreeview   = chTreeview:CONTROLS:ITEM(1)  
         NO-ERROR. 

  chNodeKey = ?.

  IF pcNodeKey = "" OR pcNodeKey = ? THEN
     pcNodeKey = chTreeview:SelectedItem:KEY NO-ERROR.
    
  IF pcNodeKey <> "" AND pcNodeKey <> ? THEN 
  DO:
    chNodeKey = chTreeview:Nodes:ITEM(pcNodeKey) NO-ERROR.
    IF NOT VALID-HANDLE(chNodeKey) THEN
    DO:  /* Check whether key is an integer */
       chNodeKey = chTreeview:Nodes:ITEM(INT(pcNodeKey)) NO-ERROR.
       IF NOT VALID-HANDLE(chNodeKey) THEN
       DO:
          RUN showTVError (INPUT "The key you have specified does not exist.(" + pcNodeKey + ")":U).
          RELEASE OBJECT chTreeview NO-ERROR.
          RETURN ?.
       END.
    END.
  END.
  
  IF VALID-HANDLE(chNodeKey) THEN
    chNodeKey:SELECTED = TRUE.
  ELSE DO:
    RELEASE OBJECT chTreeview NO-ERROR.
    RETURN FALSE.
  END.
  
  {get CtrlFrameHandle hTreeviewFrame}.
  IF VALID-HANDLE(hTreeviewFrame) THEN
    PUBLISH 'tvNodeSelected':U FROM hTreeviewFrame (chNodeKey:KEY).
    
  RELEASE OBJECT chNodeKey NO-ERROR.
  RELEASE OBJECT chTreeview NO-ERROR.

  chNodeKey = ?.
  
  RETURN TRUE.
 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setAutoSort) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setAutoSort Procedure 
FUNCTION setAutoSort RETURNS LOGICAL
  ( INPUT plAutoSort AS LOGICAL ) :
/*------------------------------------------------------------------------------
 Purpose: Determines whether the TreeView will automatically sort root nodes in label 
          order.
 ------------------------------------------------------------------------------*/
  DEFINE VARIABLE chTreeView AS COM-HANDLE NO-UNDO.
  DEFINE VARIABLE hTreeview  AS HANDLE     NO-UNDO.

  &SCOPED-DEFINE xpAutoSort
  {set AutoSort plAutoSort}.
  &UNDEFINE xpAutoSort

  /* Get the handle to the TreeView itself. */
  {get TVCtrlFrame hTreeview }.
  ASSIGN chTreeview   = hTreeview:COM-HANDLE
         chTreeview   = chTreeview:CONTROLS:ITEM(1)  
         NO-ERROR. 

  IF VALID-HANDLE(chTreeView) THEN
    chTreeView:sorted = IF plAutoSort THEN 1 ELSE 0.

  RELEASE OBJECT chTreeview NO-ERROR.

  RETURN TRUE.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setExpandOnAdd) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setExpandOnAdd Procedure 
FUNCTION setExpandOnAdd RETURNS LOGICAL
 (plvar AS LOGICAL  ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the ExpandedOnAdd property of the tree. If Yes, nodes will always
            be expanded when added to node
------------------------------------------------------------------------------*/ 
  {set ExpandOnAdd plvar}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFullRowSelect) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setFullRowSelect Procedure 
FUNCTION setFullRowSelect RETURNS LOGICAL
 (plvar AS LOGICAL  ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the FullRowSelect property of the tree. If yes, the entire row 
            of the node is selected. If no, only the text is selected.
------------------------------------------------------------------------------*/
 DEFINE VARIABLE chTreeview   AS COM-HANDLE NO-UNDO.
 DEFINE VARIABLE hTreeview    AS HANDLE     NO-UNDO.
 
 /* Get the handle to the TreeView itself. */
  {get TVCtrlFrame hTreeview }.
  ASSIGN chTreeview   = hTreeview:COM-HANDLE
         chTreeview   = chTreeview:CONTROLS:ITEM(1)  
         NO-ERROR. 
 
 &SCOPED-DEFINE xpFullRowSelect
 {set FullRowSelect plvar}.
 &UNDEFINE xpFullRowSelect
          
 IF VALID-HANDLE(chTreeview) AND plvar <> ? THEN
    chTreeview:FullRowSelect = plVar NO-ERROR.
    
 RELEASE OBJECT chTreeview NO-ERROR. 
 RETURN TRUE.



END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setHideSelection) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setHideSelection Procedure 
FUNCTION setHideSelection RETURNS LOGICAL
  ( INPUT plHideSelection AS LOGICAL ) :
/*------------------------------------------------------------------------------
 Purpose: Sets whether the current node in the TreeView will remain highlighted 
          when focus leaves the TreeView.
 ------------------------------------------------------------------------------*/
  DEFINE VARIABLE chTreeView AS COM-HANDLE NO-UNDO.
  DEFINE VARIABLE hTreeview  AS HANDLE     NO-UNDO.

  &SCOPED-DEFINE xpHideSelection
  {set HideSelection plHideSelection}.
  &UNDEFINE xpHideSelection

   /* Get the handle to the TreeView itself. */
  {get TVCtrlFrame hTreeview }.
  ASSIGN chTreeview   = hTreeview:COM-HANDLE
         chTreeview   = chTreeview:CONTROLS:ITEM(1)  
         NO-ERROR. 

  IF VALID-HANDLE(chTreeView) THEN
    chTreeView:HideSelection = plHideSelection.
  
  RELEASE OBJECT chTreeview NO-ERROR.

  RETURN TRUE.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setImageHeight) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setImageHeight Procedure 
FUNCTION setImageHeight RETURNS LOGICAL
  ( INPUT piImageHeight AS INTEGER ) :
/*------------------------------------------------------------------------------
 Purpose: Sets the height of the images in image list.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE chIL       AS COM-HANDLE NO-UNDO.
  DEFINE VARIABLE hImageList AS HANDLE     NO-UNDO.

  &SCOPED-DEFINE xpImageHeight
  {set ImageHeight piImageHeight}.
  &UNDEFINE xpImageHeight

 {get ILCtrlFrame hImageList }.
  ASSIGN chIL   = hImageList:COM-HANDLE
         chIL   = chIL:CONTROLS:ITEM(1)  
         NO-ERROR. 
  IF VALID-HANDLE(chIL) THEN
    chIL:ImageHeight = piImageHeight .

  RELEASE OBJECT chIL NO-ERROR.
  RETURN TRUE.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setImageWidth) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setImageWidth Procedure 
FUNCTION setImageWidth RETURNS LOGICAL
  ( INPUT piImageWidth AS INTEGER ) :
/*------------------------------------------------------------------------------
 Purpose:  Sets the Width of the images in image list.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE chIL       AS COM-HANDLE NO-UNDO.
  DEFINE VARIABLE hImageList AS HANDLE     NO-UNDO.

  &SCOPED-DEFINE xpImageWidth
  {set ImageWidth piImageWidth}.
  &UNDEFINE xpImageWidth

  {get ILCtrlFrame hImageList}.
  ASSIGN chIL   = hImageList:COM-HANDLE
         chIL   = chIL:CONTROLS:ITEM(1)  
         NO-ERROR. 

  IF VALID-HANDLE(chIL) THEN
    chIL:ImageWidth = piImageWidth NO-ERROR.

  RELEASE OBJECT chIL NO-ERROR.

  RETURN TRUE.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setIndentation) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setIndentation Procedure 
FUNCTION setIndentation RETURNS LOGICAL
  (pivar AS INTEGER  ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the Indentation property of the tree. This is the number of pixels
            of indentation between a node and it's child node.
------------------------------------------------------------------------------*/
 DEFINE VARIABLE chTreeview  AS COM-HANDLE NO-UNDO.
 DEFINE VARIABLE hTreeview   AS HANDLE     NO-UNDO.
 
  /* Get the handle to the TreeView itself. */
  {get TVCtrlFrame hTreeview }.
  ASSIGN chTreeview   = hTreeview:COM-HANDLE
         chTreeview   = chTreeview:CONTROLS:ITEM(1)  
         NO-ERROR. 
 
 &SCOPED-DEFINE xpIndentation
 {set Indentation pivar}.
 &UNDEFINE xpIndentation
          
 IF VALID-HANDLE(chTreeview) AND pivar <> 0 THEN
    chTreeview:Indentation = piVar NO-ERROR.
    
 RELEASE OBJECT chTreeview NO-ERROR. 

 RETURN TRUE.


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setLabelEdit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setLabelEdit Procedure 
FUNCTION setLabelEdit RETURNS LOGICAL
 (pivar AS INTEGER  ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the LabelEdit property of the tree. If yes, the user can click 
            on the node to edit it. The "tvLabelEdit" event is published once the 
            node label is edited.
------------------------------------------------------------------------------*/
 DEFINE VARIABLE chTreeview AS COM-HANDLE NO-UNDO.
 DEFINE VARIABLE htreeview  AS HANDLE     NO-UNDO.

  /* Get the handle to the TreeView itself. */
  {get TVCtrlFrame hTreeview }.
  ASSIGN chTreeview   = hTreeview:COM-HANDLE
         chTreeview   = chTreeview:CONTROLS:ITEM(1)  
         NO-ERROR. 
 
 &SCOPED-DEFINE xpLabelEdit
 {set LabelEdit pivar}.
 &UNDEFINE xpLabelEdit
          
 IF VALID-HANDLE(chTreeview) THEN
    chTreeview:LabelEdit = piVar NO-ERROR.
    
 RELEASE OBJECT chTreeview NO-ERROR. 

 RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setLineStyle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setLineStyle Procedure 
FUNCTION setLineStyle RETURNS LOGICAL
 (pivar AS INTEGER  ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the LineStyle property of the tree. 
            0  (Default) Tree lines. Displays lines between Node siblings and their 
               parent Node. 
            1  Root Lines. In addition to displaying lines between Node siblings and 
               their parent Node, also displays lines between the root nodes. 
------------------------------------------------------------------------------*/
 DEFINE VARIABLE chTreeview  AS COM-HANDLE NO-UNDO.
 DEFINE VARIABLE hTreeview   AS HANDLE     NO-UNDO.

  /* Get the handle to the TreeView itself. */
  {get TVCtrlFrame hTreeview }.
  ASSIGN chTreeview   = hTreeview:COM-HANDLE
         chTreeview   = chTreeview:CONTROLS:ITEM(1)  
         NO-ERROR. 
 
 &SCOPED-DEFINE xpLineStyle
 {set LineStyle pivar}.
 &UNDEFINE xpLineStyle
          
 IF VALID-HANDLE(chTreeview) THEN
    chTreeview:LineStyle = piVar NO-ERROR.
    
 RELEASE OBJECT chTreeview NO-ERROR. 

 RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setOLEDrag) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setOLEDrag Procedure 
FUNCTION setOLEDrag RETURNS LOGICAL
  ( plvar AS LOGICAL) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the treeview to accept OLE drag operations
    Notes:  
------------------------------------------------------------------------------*/
 DEFINE VARIABLE chTreeview  AS COM-HANDLE NO-UNDO.
 DEFINE VARIABLE hTreeview   AS HANDLE     NO-UNDO.

  /* Get the handle to the TreeView itself. */
  {get TVCtrlFrame hTreeview }.
  ASSIGN chTreeview   = hTreeview:COM-HANDLE
         chTreeview   = chTreeview:CONTROLS:ITEM(1)  
         NO-ERROR. 
 
 &SCOPED-DEFINE xpOLEDrag
 {set OLEDrag plvar}.
 &UNDEFINE xpOLEDrag
          
 IF VALID-HANDLE(chTreeview) AND plvar <> ? THEN 
     chTreeview:OleDragMode = IF plVar THEN 1 ELSE 0 NO-ERROR.
     
 RELEASE OBJECT chTreeview NO-ERROR. 

 RETURN TRUE.
 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setOLEDrop) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setOLEDrop Procedure 
FUNCTION setOLEDrop RETURNS LOGICAL
( plvar AS LOGICAL) :
/*------------------------------------------------------------------------------
  Purpose:   Sets the treeview to accept OLE drop operations
    Notes:  
------------------------------------------------------------------------------*/
 DEFINE VARIABLE chTreeview  AS COM-HANDLE NO-UNDO.
 DEFINE VARIABLE hTreeview   AS HANDLE     NO-UNDO.

 /* Get the handle to the TreeView itself. */
  {get TVCtrlFrame hTreeview }.
  ASSIGN chTreeview   = hTreeview:COM-HANDLE
         chTreeview   = chTreeview:CONTROLS:ITEM(1)  
         NO-ERROR. 

  &SCOPED-DEFINE xpOLEDrop
  {set OLEDrop plvar}.
  &UNDEFINE xpOLEDrop
          
  IF VALID-HANDLE(chTreeview) AND plvar <> ? THEN
      chTreeview:OleDropMode = IF plVar THEN 1 ELSE 0 NO-ERROR.
     
  RELEASE OBJECT chTreeview NO-ERROR. 
 
  RETURN TRUE.
 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setProperty) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setProperty Procedure 
FUNCTION setProperty RETURNS LOGICAL
( pcProperty AS CHAR ,
  pcKey      AS CHAR,
  pcValue    AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:      Sets the specified treeview property 
  Paramaters:   pcProperty   Name of specified property
                   BACKCOLOR      Sets the Node to the background color
                   BOLD           Sets the Node to bold
                   ITALIC         Sets the entire tree to italic
                   CHECKED        Sets the node to checked if checkboxes is set  
                   ENABLED        Sets the entire tree to enabled/disabled
                   ENSUREVISIBLE   Scrolls the item so its visible
                   EXPANDED       Expands/collapses the specified node
                   FORECOLOR      Sets the Node to the foreground color
                   IMAGE          Sets the image (contained in imagelist) for a node
                   KEY            Set the unique Key of the node
                   PATHSEPARATOR  Sets the delimiter returned by the FullPath property
                   PARENT
                   SELECTEDITEM   Sets the selected node
                   SORTED         Sets the children of the specified node to be sorted
                   STARTLABELEDIT Performs the StartLabelEdit method 
                   TAG            Sets the tag of the specified node
                   TEXT           Sets the label text of the specified node
                   VISIBLE        Sets the entire tree visible/invisible
               pcKey         Key value of a specified node. 
                                (If blank or ?, the selected node is used)
               pcValue       Value  for the specified property
    
    Syntax:    lBold = DYNAIMC-FUNC("setProperty" in h_Treeview, "BOLD","","YES").
------------------------------------------------------------------------------*/
 DEFINE VARIABLE chTreeview  AS COM-HANDLE NO-UNDO.
 DEFINE VARIABLE hTreeview   AS HANDLE     NO-UNDO.
 DEFINE VARIABLE chNodeKey   AS COM-HANDLE NO-UNDO.

  /* Get the handle to the TreeView itself. */
  {get TVCtrlFrame hTreeview }.
  ASSIGN chTreeview   = hTreeview:COM-HANDLE
         chTreeview   = chTreeview:CONTROLS:ITEM(1)  
         NO-ERROR. 
 
 IF pcKey = "" OR pcKey = ? THEN
    pcKey = chTreeview:SelectedItem:KEY NO-ERROR.
 
 IF pcKey <> "" AND pcKey <> ? THEN DO:
     chNodeKey = chTreeview:Nodes:ITEM(pckey) NO-ERROR.
     IF ERROR-STATUS:ERROR THEN
     DO:  /* Check whether key is an integer */
        chNodeKey = chTreeview:Nodes:ITEM(INT(pckey)) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN
        DO:
           RELEASE OBJECT chTreeview NO-ERROR.
           RUN showTVError (INPUT "The key you have specified does not exist.").
           RETURN ?.
        END.
     END.
 END.
  
  CASE pcProperty:
      WHEN "BACKCOLOR":U THEN DO:
          IF VALID-HANDLE(chNodeKey) THEN
             ASSIGN chNodeKey:BackColor = 
                      RGB-VALUE(COLOR-TABLE:GET-RED-VALUE(INT(pcValue)),
                                COLOR-TABLE:GET-GREEN-VALUE(INT(pcValue)),
                                COLOR-TABLE:GET-BLUE-VALUE(INT(pcValue)))
             NO-ERROR.
      END.
      WHEN "BOLD":U THEN
        IF VALID-HANDLE(chNodeKey) THEN
           chNodeKey:Bold = IF pcValue = "yes" OR pcValue = "1" THEN TRUE ELSE FALSE NO-ERROR.

      WHEN "ITALIC":U THEN
          chTreeview:Font:Italic = IF pcValue = "yes" OR pcValue = "1" THEN TRUE ELSE FALSE NO-ERROR.
      
      WHEN "CHECKED":U THEN
        IF VALID-HANDLE(chNodeKey) THEN
           chNodeKey:CHECKED = IF pcValue = "yes" OR pcValue = "1" THEN TRUE ELSE FALSE NO-ERROR.
      
      WHEN "ENABLED":U THEN
          chTreeview:Enabled = IF pcValue = "yes" OR pcValue = "1" THEN TRUE ELSE FALSE NO-ERROR.
      
      WHEN "EXPANDED":U THEN
        IF VALID-HANDLE(chNodeKey) THEN
           chNodeKey:Expanded = IF pcValue = "yes" OR pcValue = "1" THEN TRUE ELSE FALSE NO-ERROR.
      
      WHEN "ENSUREVISIBLE":U THEN
        IF VALID-HANDLE(chNodeKey) THEN                
           NO-RETURN-VALUE  chNodeKey:EnsureVisible().             
                        
      WHEN "FORECOLOR":U THEN DO:
          IF VALID-HANDLE(chNodeKey) THEN
             ASSIGN chNodeKey:ForeColor = 
                      RGB-VALUE(COLOR-TABLE:GET-RED-VALUE(INT(pcValue)),
                                COLOR-TABLE:GET-GREEN-VALUE(INT(pcValue)),
                                COLOR-TABLE:GET-BLUE-VALUE(INT(pcValue)))
             NO-ERROR.
      END.
          
      WHEN "HIDESELECTION":U THEN
          chTreeview:HideSelection = IF pcValue = "yes" OR pcValue = "1" THEN 1 ELSE 0 .

      WHEN "IMAGE" THEN
         IF VALID-HANDLE(chNodeKey) THEN
           chNodeKey:IMAGE = pcvalue NO-ERROR.

      WHEN "SELECTEDIMAGE" THEN
         IF VALID-HANDLE(chNodeKey) THEN
           chNodeKey:SelectedImage = pcvalue NO-ERROR.
           
      WHEN "KEY":U THEN
        IF VALID-HANDLE(chNodeKey) THEN
           chNodeKey:KEY = pcValue NO-ERROR.           

      WHEN "PARENT" THEN
         IF VALID-HANDLE(chNodeKey) THEN
           chNodeKey:PARENT = chTreeview:nodes:ITEM(pcValue) NO-ERROR.
      
      WHEN "PATHSEPARATOR":U THEN
           chTreeview:PathSeparator = pcValue NO-ERROR. 
      
      WHEN "SELECTEDITEM":u THEN
         chTreeview:SelectedItem = chTreeview:Nodes:ITEM(pcKey) NO-ERROR.
                
      WHEN "SORTED":U THEN
        IF VALID-HANDLE(chNodeKey) THEN
           chNodeKey:Sorted = IF pcValue = "yes" OR pcValue = "1" THEN TRUE ELSE FALSE NO-ERROR.           
      
      WHEN "STARTLABELEDIT":U THEN
           NO-RETURN-VALUE chTreeview:StartLabelEdit().
           
      WHEN "TAG":U THEN
        IF VALID-HANDLE(chNodeKey) THEN
           chNodeKey:Tag = pcValue NO-ERROR.           

      WHEN "TEXT":U THEN
        IF VALID-HANDLE(chNodeKey) THEN
           chNodeKey:TEXT = pcValue NO-ERROR.           

      WHEN "VISIBLE":U THEN
          chTreeview:VISIBLE = IF pcValue = "yes" OR pcValue = "1" THEN TRUE ELSE FALSE NO-ERROR.                      
      OTHERWISE
        RUN showTVError (INPUT "The requested property " + pcProperty + " is not available.").
  END CASE.
  
  RELEASE OBJECT chNodeKey  NO-ERROR.
  RELEASE OBJECT chTreeview NO-ERROR.

  RETURN TRUE.   


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setScroll) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setScroll Procedure 
FUNCTION setScroll RETURNS LOGICAL
   (plvar AS LOGICAL  ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the Scroll property of the tree. If Yes, scrollbars will appear.
------------------------------------------------------------------------------*/
 DEFINE VARIABLE chTreeview  AS COM-HANDLE NO-UNDO.
 DEFINE VARIABLE hTreeview   AS HANDLE     NO-UNDO.
 
  /* Get the handle to the TreeView itself. */
  {get TVCtrlFrame hTreeview }.
  ASSIGN chTreeview   = hTreeview:COM-HANDLE
         chTreeview   = chTreeview:CONTROLS:ITEM(1)  
         NO-ERROR. 
 
 &SCOPED-DEFINE xpScroll
 {set SCROLL plvar}.
 &UNDEFINE xpScroll
          
 IF VALID-HANDLE(chTreeview) AND plvar <> ? THEN
    chTreeview:SCROLL = plVar NO-ERROR.
    
 RELEASE OBJECT chTreeview NO-ERROR. 

 RETURN TRUE.



END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setShowCheckBoxes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setShowCheckBoxes Procedure 
FUNCTION setShowCheckBoxes RETURNS LOGICAL
  ( INPUT plShowCheckBoxes AS LOGICAL ) :
/*------------------------------------------------------------------------------
 Purpose: Determines whether checkboxes are displayed beside each node. 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE chTreeview AS COM-HANDLE NO-UNDO.
  DEFINE VARIABLE hTreeview  AS HANDLE     NO-UNDO.

  &SCOPED-DEFINE xpShowCheckBoxes
  {set ShowCheckBoxes plShowCheckBoxes}.
  &UNDEFINE xpShowCheckBoxes

   /* Get the handle to the TreeView itself. */
  {get TVCtrlFrame hTreeview }.
  ASSIGN chTreeview   = hTreeview:COM-HANDLE
         chTreeview   = chTreeview:CONTROLS:ITEM(1)  
         NO-ERROR. 

  IF VALID-HANDLE(chTreeview) THEN
    chTreeview:checkboxes = IF plShowCheckBoxes THEN 1 ELSE 0.

  RELEASE OBJECT chTreeview NO-ERROR.

  RETURN TRUE.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setShowRootLines) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setShowRootLines Procedure 
FUNCTION setShowRootLines RETURNS LOGICAL
  ( INPUT plShowRootLines AS LOGICAL ) :
/*------------------------------------------------------------------------------
 Purpose: Determines whether lines leading to the roots of the tree will be displayed
          or not. Same as setLineStyle.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE chTreeView AS COM-HANDLE NO-UNDO.
  DEFINE VARIABLE hTreeview  AS HANDLE     NO-UNDO.

  &SCOPED-DEFINE xpShowRootLines
  {set ShowRootLines plShowRootLines}.
  &UNDEFINE xpShowRootLines

   /* Get the handle to the TreeView itself. */
  {get TVCtrlFrame hTreeview }.
  ASSIGN chTreeview   = hTreeview:COM-HANDLE
         chTreeview   = chTreeview:CONTROLS:ITEM(1)  
         NO-ERROR. 

  IF VALID-HANDLE(chTreeView) THEN
    chTreeView:LineStyle = IF plShowRootLines THEN {&tvwRootLines} ELSE {&tvwTreeLines}.

  RELEASE OBJECT chTreeview NO-ERROR.

  RETURN TRUE.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSingleSel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setSingleSel Procedure 
FUNCTION setSingleSel RETURNS LOGICAL
 (plvar AS LOGICAL  ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the SingleSel property of the tree. If yes, the node is expanded 
            when the node is selected or clicked.
------------------------------------------------------------------------------*/
 DEFINE VARIABLE chTreeview  AS COM-HANDLE NO-UNDO.
 DEFINE VARIABLE hTreeview   AS HANDLE     NO-UNDO.
 
 /* Get the handle to the TreeView itself. */
  {get TVCtrlFrame hTreeview }.
  ASSIGN chTreeview   = hTreeview:COM-HANDLE
         chTreeview   = chTreeview:CONTROLS:ITEM(1)  
         NO-ERROR. 
 
 &SCOPED-DEFINE xpSingleSel
 {set SingleSel plvar}.
 &UNDEFINE xpSingleSel
          
 IF VALID-HANDLE(chTreeview) AND plvar <> ? THEN
    chTreeview:SingleSel = plVar NO-ERROR.
    
 RELEASE OBJECT chTreeview NO-ERROR. 

 RETURN TRUE.


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setTreeStyle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setTreeStyle Procedure 
FUNCTION setTreeStyle RETURNS LOGICAL
  ( INPUT piTreeStyle AS INTEGER ) :
/*------------------------------------------------------------------------------
 Purpose: Sets style of the TreeView. Possible values are:
          0 Text only. 
          1 Image and text. 
          2 Plus/minus and text. 
          3 Plus/minus, image, and text. 
          4 Lines and text. 
          5 Lines, image, and text. 
          6 Lines, plus/minus, and text. 
          7 (Default) Lines, plus/minus, image, and text. 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE chTreeview AS COM-HANDLE NO-UNDO.
  DEFINE VARIABLE hTreeview  AS HANDLE     NO-UNDO.
  
  &SCOPED-DEFINE xpTreeStyle
  {set TreeStyle piTreeStyle}.
  &UNDEFINE xpTreeStyle

   /* Get the handle to the TreeView itself. */
  {get TVCtrlFrame hTreeview }.
  ASSIGN chTreeview   = hTreeview:COM-HANDLE
         chTreeview   = chTreeview:CONTROLS:ITEM(1)  
         NO-ERROR. 

  IF VALID-HANDLE(chTreeview) THEN 
    chTreeview:Style = piTreeStyle.
  
  RELEASE OBJECT chTreeview NO-ERROR.

  RETURN TRUE.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setTVControllerSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setTVControllerSource Procedure 
FUNCTION setTVControllerSource RETURNS LOGICAL
  ( INPUT phSource AS HANDLE ) :
/*------------------------------------------------------------------------------
 Purpose: Sets the handle of the procedure that will control this TreeView.
------------------------------------------------------------------------------*/

  {set TVControllerSource phSource}.

  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ValidNodeKey) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION ValidNodeKey Procedure 
FUNCTION ValidNodeKey RETURNS LOGICAL
  ( pcKey AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns whether the specified key is valid
Parameter:  pcKey  Name of key to verify.    
    Notes:  
------------------------------------------------------------------------------*/
 DEFINE VARIABLE chtreeview    AS COM-HANDLE NO-UNDO.
 DEFINE VARIABLE hTreeview     AS HANDLE     NO-UNDO.
 DEFINE VARIABLE chNodeKey     AS COM-HANDLE NO-UNDO.
 DEFINE VARIABLE lFound        AS LOGICAL    NO-UNDO.
 
 /* Get the handle to the TreeView itself. */
  {get TVCtrlFrame hTreeview }.
  ASSIGN chTreeview   = hTreeview:COM-HANDLE
         chTreeview   = chTreeview:CONTROLS:ITEM(1)  
         NO-ERROR. 
 
 IF pcKey = "" OR pcKey = ? THEN DO:
   RUN showTVMessage (INPUT {fnarg messageNumber 85}).
   RELEASE OBJECT chtreeview NO-ERROR.
   RETURN FALSE.
 END.

 chNodeKey = chtreeview:Nodes:ITEM(pckey) NO-ERROR. 
 IF NOT VALID-HANDLE(chNodeKey) THEN 
    chNodeKey = chtreeview:Nodes:ITEM(INT(pckey)) NO-ERROR.
 
 IF VALID-HANDLE(chNodeKey) THEN 
    lFound = TRUE.
 ELSE
    lfound = FALSE.
       
 RELEASE OBJECT chNodeKey NO-ERROR.
 RELEASE OBJECT chtreeview NO-ERROR.

 
 RETURN lFound.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

