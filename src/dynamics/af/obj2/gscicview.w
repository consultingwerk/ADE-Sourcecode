&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          icfdb            PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" vTableWin _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" vTableWin _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE RowObject
       {"af/obj2/gscicfullo.i"}.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS vTableWin 
/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: gscicviewv.w

  Description:  Category Viewer

  Purpose:      Used in UI of categroies

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   08/21/2001  Author:     Donald Bulua

  Update Notes: Created from Template rysttviewv.w

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

&scop object-name       gscicview.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Astra 2 object identifying preprocessor */
&glob   astra2-staticSmartDataViewer yes

{af/sup2/afglobals.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDataViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER FRAME

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target

/* Include file with RowObject temp-table definition */
&Scoped-define DATA-FIELD-DEFS "af/obj2/gscicfullo.i"

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS RowObject.item_category_label ~
RowObject.item_link RowObject.item_category_description ~
RowObject.system_owned 
&Scoped-define ENABLED-TABLES RowObject
&Scoped-define FIRST-ENABLED-TABLE RowObject
&Scoped-Define ENABLED-OBJECTS RECT-1 fiItem raTarget 
&Scoped-Define DISPLAYED-FIELDS RowObject.item_category_label ~
RowObject.item_link RowObject.item_category_description ~
RowObject.system_owned RowObject.item_category_obj 
&Scoped-define DISPLAYED-TABLES RowObject
&Scoped-define FIRST-DISPLAYED-TABLE RowObject
&Scoped-Define DISPLAYED-OBJECTS fiItem raTarget fiCategoriesLabel 

/* Custom List Definitions                                              */
/* ADM-ASSIGN-FIELDS,List-2,List-3,List-4,List-5,List-6                 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE fiCategoriesLabel AS CHARACTER FORMAT "X(15)":U INITIAL "Categories" 
      VIEW-AS TEXT 
     SIZE 10.6 BY .62 NO-UNDO.

DEFINE VARIABLE fiItem AS CHARACTER FORMAT "X(70)":U 
     LABEL "Item link default" 
     VIEW-AS FILL-IN 
     SIZE 57 BY 1 NO-UNDO.

DEFINE VARIABLE raTarget AS CHARACTER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Source", "1",
"Target", "2"
     SIZE 28 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 104 BY 6.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     RowObject.item_category_label AT ROW 1.86 COL 23 COLON-ALIGNED
          LABEL "Category label"
          VIEW-AS FILL-IN 
          SIZE 30 BY 1
     RowObject.item_link AT ROW 1.86 COL 55.6 NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 11 BY 1
     RowObject.item_category_description AT ROW 2.95 COL 23 COLON-ALIGNED
          LABEL "Description"
          VIEW-AS FILL-IN 
          SIZE 78.6 BY 1
     fiItem AT ROW 4.05 COL 23 COLON-ALIGNED
     raTarget AT ROW 5.1 COL 25 HELP
          "This item will publish the action acrros the specified link" NO-LABEL
     RowObject.system_owned AT ROW 6.19 COL 25
          LABEL "System owned"
          VIEW-AS TOGGLE-BOX
          SIZE 42.4 BY 1
     fiCategoriesLabel AT ROW 1.24 COL 2.8 NO-LABEL
     RowObject.item_category_obj AT ROW 1.95 COL 89 COLON-ALIGNED
          LABEL "Item Category Obj"
           VIEW-AS TEXT 
          SIZE 8.6 BY .62
     RECT-1 AT ROW 1.48 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY USE-DICT-EXPS 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataViewer
   Data Source: "af/obj2/gscicfullo.w"
   Allow: Basic,DB-Fields,Smart
   Container Links: Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: RowObject D "?" ?  
      ADDITIONAL-FIELDS:
          {af/obj2/gscicfullo.i}
      END-FIELDS.
   END-TABLES.
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
  CREATE WINDOW vTableWin ASSIGN
         HEIGHT             = 6.48
         WIDTH              = 104.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB vTableWin 
/* ************************* Included-Libraries *********************** */

{src/adm2/viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW vTableWin
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME frMain
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME frMain:SCROLLABLE       = FALSE
       FRAME frMain:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN fiCategoriesLabel IN FRAME frMain
   NO-ENABLE ALIGN-L                                                    */
ASSIGN 
       fiCategoriesLabel:PRIVATE-DATA IN FRAME frMain     = 
                "Categories".

/* SETTINGS FOR FILL-IN RowObject.item_category_description IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN RowObject.item_category_label IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN RowObject.item_category_obj IN FRAME frMain
   NO-ENABLE EXP-LABEL                                                  */
ASSIGN 
       RowObject.item_category_obj:HIDDEN IN FRAME frMain           = TRUE
       RowObject.item_category_obj:READ-ONLY IN FRAME frMain        = TRUE.

/* SETTINGS FOR FILL-IN RowObject.item_link IN FRAME frMain
   ALIGN-L EXP-LABEL                                                    */
ASSIGN 
       RowObject.item_link:HIDDEN IN FRAME frMain           = TRUE.

/* SETTINGS FOR TOGGLE-BOX RowObject.system_owned IN FRAME frMain
   EXP-LABEL                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME frMain
/* Query rebuild information for FRAME frMain
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME frMain */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME fiItem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiItem vTableWin
ON ANY-PRINTABLE OF fiItem IN FRAME frMain /* Item link default */
DO:   
   /* Do not permit dash or space character */
  IF CHR(LASTKEY) = "-" OR chr(lastkey) = " " THEN
      RETURN NO-APPLY.
      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK vTableWin 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN initializeObject.
  &ENDIF         

  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cancelRecord vTableWin 
PROCEDURE cancelRecord :
/*------------------------------------------------------------------------------
  Purpose:    If Add or Copy action is cancelled, it may be that the selected tree 
              is not in synch with the current record. This happens if the user 
              selected to add a record from the popup menus
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cNew    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hSource AS HANDLE     NO-UNDO.
DEFINE VARIABLE cKey    AS CHARACTER  NO-UNDO.


  /* Code placed here will execute PRIOR to standard behavior. */
 {get NewRecord cNew}.
  RUN SUPER.
  IF cNew = "Add":U OR cNew = "Copy":U THEN DO:
    {get ContainerSource hSource}.
    IF VALID-HANDLE(hSource) THEN
       RUN treeSynch IN hSource ("CATG":U).
  END.


  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteComplete vTableWin 
PROCEDURE deleteComplete :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE hSource AS HANDLE     NO-UNDO.

{get ContainerSource hSource}.

IF VALID-HANDLE(hSource) THEN
    RUN deleteNode IN hSource ("Category":U,NO).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI vTableWin  _DEFAULT-DISABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE displayFields vTableWin 
PROCEDURE displayFields :
/*------------------------------------------------------------------------------
  Purpose:     Assign radio-set screen value to source or target. 
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcColValues AS CHARACTER NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER( INPUT pcColValues).

  /* Code placed here will execute AFTER standard behavior.    */
  IF INDEX(RowObject.Item_link:SCREEN-VALUE IN FRAME {&FRAME-NAME},"-Target":U) > 0  THEN 
     ASSIGN raTarget:SCREEN-VALUE = "2"
            fiItem:SCREEN-VALUE   = ENTRY(1,RowObject.Item_link:SCREEN-VALUE,"-")
            NO-ERROR.
  ELSE IF INDEX(RowObject.Item_link:SCREEN-VALUE,"-Source":U) > 0 THEN
      ASSIGN raTarget:SCREEN-VALUE = "1"
             fiItem:SCREEN-VALUE   = ENTRY(1,RowObject.Item_link:SCREEN-VALUE,"-")
             NO-ERROR.
  fiItem:HELP = RowObject.Item_link:HELP.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateRecord vTableWin 
PROCEDURE updateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Append Source or Target value to the item field
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cNew      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hSource   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lModified AS LOGICAL    NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */
  IF fiItem:SCREEN-VALUE IN FRAME {&FRAME-NAME} > "" THEN
      ASSIGN RowObject.Item_link:SCREEN-VALUE = trim(fiItem:SCREEN-VALUE)
                                               + IF  raTarget:SCREEN-VALUE = "1" 
                                                 THEN "-Source":U
                                                 ELSE "-Target":U.
  ELSE 
    ASSIGN RowObject.Item_link:SCREEN-VALUE = "".
 {get NewRecord cNew}.
 lModified=  ROWObject.ITEM_category_label:MODIFIED OR RowObject.item_category_description:MODIFIED.
         
  RUN SUPER.
  /* If sucessfull, add node if adding */
  IF RETURN-VALUE <> "ADM-ERROR":U THEN DO:
    {get ContainerSource hSource}.
     IF (cNew = "Add":U OR cNew = "Copy":U) AND VALID-HANDLE(hSource)  THEN 
       RUN addNode IN hSource ("Category":U,
                                RowObject.item_category_label:SCREEN-VALUE 
                              + (IF RowObject.item_category_description:SCREEN-VALUE > "" 
                                    AND trim(RowObject.item_category_label:SCREEN-VALUE) <> trim(RowObject.item_category_description:SCREEN-VALUE)
                                 THEN "  (":U + RowObject.item_category_description:SCREEN-VALUE + ")":U
                                 ELSE ""),
                                RowObject.ITEM_category_obj:SCREEN-VALUE).
     ELSE IF lModified THEN
       RUN updateNode IN hSource("Category":U,"",ROWObject.ITEM_category_label:SCREEN-VALUE 
                                 + (IF RowObject.item_category_description:SCREEN-VALUE > "" 
                                      AND trim(RowObject.item_category_label:SCREEN-VALUE) <> trim(RowObject.item_category_description:SCREEN-VALUE)
                                    THEN "  (":U + RowObject.item_category_description:SCREEN-VALUE + ")":U
                                    ELSE "")).
  END.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

