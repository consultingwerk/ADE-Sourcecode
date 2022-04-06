&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          icfdb            PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Dialog-Frame 
/*------------------------------------------------------------------------

  File: rylookupbd.w

  Description: Browse repository objects

  Input Parameters:
                   pcProduct     Default Product code
                   pcModule      Default Product Module Code
                   pcObjectType  Default Object type to view
                   plOtherTypes  Other allowed types to view

  Output Parameters:
                   pcLookupName  The name of the selected objects

  Author: Mark Davies (MIP)

  Created: 08/23/2001
    
    Modified    : 10/25/2001         Mark Davies (MIP)
                  Sort objects by file name.
                  Added 'WAIT' cursor on query refresh
    Modified    : 03/15/2002        Mark Davies (MIP)
                  Added new input parameter to indicate if the relative 
                  path should be attached to the file name of the object 
                  being returned
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.       */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

DEFINE INPUT  PARAMETER pcProduct     AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcModule      AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcObjectType  AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER plOtherTypes  AS LOGICAL    NO-UNDO.
DEFINE INPUT  PARAMETER plIncludePath AS LOGICAL    NO-UNDO.
DEFINE OUTPUT PARAMETER pcLookupName  AS CHARACTER  NO-UNDO.

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE gcObjectType  AS CHARACTER  NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Dialog-Box
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Dialog-Frame
&Scoped-define BROWSE-NAME BrBrowse

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ryc_smartobject gsc_product_module ~
gsc_product gsc_object_type

/* Definitions for BROWSE BrBrowse                                      */
&Scoped-define FIELDS-IN-QUERY-BrBrowse gsc_product.product_code ~
gsc_product_module.product_module_code ryc_smartobject.object_filename ~
ryc_smartobject.object_description ryc_smartobject.object_path 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BrBrowse 
&Scoped-define QUERY-STRING-BrBrowse FOR EACH ryc_smartobject NO-LOCK, ~
      EACH gsc_product_module WHERE gsc_product_module.product_module_obj = ryc_smartobject.product_module_obj AND ~
gsc_product_module.product_module_code = pcModule  NO-LOCK, ~
      EACH gsc_product WHERE gsc_product.product_obj = gsc_product_module.product_obj AND  ~
gsc_product.product_code = pcProduct  NO-LOCK, ~
      EACH gsc_object_type WHERE gsc_object_type.object_type_obj = ryc_smartobject.object_type_obj AND ~
LOOKUP(gsc_object_type.object_type_code,pcObjectType) > 0   NO-LOCK ~
    BY ryc_smartobject.object_filename INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BrBrowse OPEN QUERY BrBrowse FOR EACH ryc_smartobject NO-LOCK, ~
      EACH gsc_product_module WHERE gsc_product_module.product_module_obj = ryc_smartobject.product_module_obj AND ~
gsc_product_module.product_module_code = pcModule  NO-LOCK, ~
      EACH gsc_product WHERE gsc_product.product_obj = gsc_product_module.product_obj AND  ~
gsc_product.product_code = pcProduct  NO-LOCK, ~
      EACH gsc_object_type WHERE gsc_object_type.object_type_obj = ryc_smartobject.object_type_obj AND ~
LOOKUP(gsc_object_type.object_type_code,pcObjectType) > 0   NO-LOCK ~
    BY ryc_smartobject.object_filename INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BrBrowse ryc_smartobject gsc_product_module ~
gsc_product gsc_object_type
&Scoped-define FIRST-TABLE-IN-QUERY-BrBrowse ryc_smartobject
&Scoped-define SECOND-TABLE-IN-QUERY-BrBrowse gsc_product_module
&Scoped-define THIRD-TABLE-IN-QUERY-BrBrowse gsc_product
&Scoped-define FOURTH-TABLE-IN-QUERY-BrBrowse gsc_object_type


/* Definitions for DIALOG-BOX Dialog-Frame                              */
&Scoped-define OPEN-BROWSERS-IN-QUERY-Dialog-Frame ~
    ~{&OPEN-QUERY-BrBrowse}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS coProduct coProductModule BrBrowse BtnSelect ~
BtnCancel 
&Scoped-Define DISPLAYED-OBJECTS coProduct coProductModule 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnCancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON BtnSelect AUTO-GO 
     LABEL "&Select" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE VARIABLE coProduct AS CHARACTER FORMAT "X(256)":U 
     LABEL "Product" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Item 1","Item 1"
     DROP-DOWN-LIST
     SIZE 48.4 BY 1 NO-UNDO.

DEFINE VARIABLE coProductModule AS CHARACTER FORMAT "X(256)":U 
     LABEL "Product Module" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Item 1","Item 1"
     DROP-DOWN-LIST
     SIZE 48.4 BY 1 NO-UNDO.

DEFINE VARIABLE ToShowAll AS LOGICAL INITIAL no 
     LABEL "Show All Types" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BrBrowse FOR 
      ryc_smartobject
    FIELDS(ryc_smartobject.object_filename
      ryc_smartobject.object_description
      ryc_smartobject.object_path), 
      gsc_product_module
    FIELDS(gsc_product_module.product_module_code), 
      gsc_product
    FIELDS(gsc_product.product_code), 
      gsc_object_type
    FIELDS() SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BrBrowse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BrBrowse Dialog-Frame _STRUCTURED
  QUERY BrBrowse NO-LOCK DISPLAY
      gsc_product.product_code FORMAT "X(10)":U
      gsc_product_module.product_module_code FORMAT "X(35)":U
      ryc_smartobject.object_filename FORMAT "X(70)":U WIDTH 35
      ryc_smartobject.object_description FORMAT "X(35)":U WIDTH 50
      ryc_smartobject.object_path FORMAT "X(70)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 120.4 BY 8.29 ROW-HEIGHT-CHARS .62 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     coProduct AT ROW 1 COL 16.6 COLON-ALIGNED
     ToShowAll AT ROW 1.1 COL 67.4
     coProductModule AT ROW 2.05 COL 16.6 COLON-ALIGNED
     BrBrowse AT ROW 3.38 COL 1
     BtnSelect AT ROW 11.76 COL 90.6
     BtnCancel AT ROW 11.76 COL 106.2
     SPACE(0.20) SKIP(0.04)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Select a Dynamic lookup to base your new lookup on."
         DEFAULT-BUTTON BtnSelect CANCEL-BUTTON BtnCancel.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Dialog-Box
   Allow: Basic,Browse,DB-Fields,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX Dialog-Frame
                                                                        */
/* BROWSE-TAB BrBrowse coProductModule Dialog-Frame */
ASSIGN 
       FRAME Dialog-Frame:SCROLLABLE       = FALSE
       FRAME Dialog-Frame:HIDDEN           = TRUE.

/* SETTINGS FOR TOGGLE-BOX ToShowAll IN FRAME Dialog-Frame
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       ToShowAll:HIDDEN IN FRAME Dialog-Frame           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BrBrowse
/* Query rebuild information for BROWSE BrBrowse
     _TblList          = "ICFDB.ryc_smartobject,ICFDB.gsc_product_module WHERE ICFDB.ryc_smartobject ...,ICFDB.gsc_product WHERE ICFDB.gsc_product_module  ...,ICFDB.gsc_object_type WHERE ICFDB.ryc_smartobject  ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = "USED, USED, USED, USED, FIRST USED"
     _OrdList          = "ICFDB.ryc_smartobject.object_filename|yes"
     _JoinCode[2]      = "gsc_product_module.product_module_obj = ryc_smartobject.product_module_obj AND
gsc_product_module.product_module_code = pcModule "
     _JoinCode[3]      = "gsc_product.product_obj = gsc_product_module.product_obj AND 
gsc_product.product_code = pcProduct "
     _JoinCode[4]      = "gsc_object_type.object_type_obj = ryc_smartobject.object_type_obj AND
LOOKUP(gsc_object_type.object_type_code,pcObjectType) > 0  "
     _FldNameList[1]   = icfdb.gsc_product.product_code
     _FldNameList[2]   = icfdb.gsc_product_module.product_module_code
     _FldNameList[3]   > icfdb.ryc_smartobject.object_filename
"ryc_smartobject.object_filename" ? ? "character" ? ? ? ? ? ? no ? no no "35" yes no no "U" "" ""
     _FldNameList[4]   > icfdb.ryc_smartobject.object_description
"ryc_smartobject.object_description" ? ? "character" ? ? ? ? ? ? no ? no no "50" yes no no "U" "" ""
     _FldNameList[5]   = icfdb.ryc_smartobject.object_path
     _Query            is OPENED
*/  /* BROWSE BrBrowse */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Select a Dynamic lookup to base your new lookup on. */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BrBrowse
&Scoped-define SELF-NAME BrBrowse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BrBrowse Dialog-Frame
ON MOUSE-SELECT-DBLCLICK OF BrBrowse IN FRAME Dialog-Frame
DO:
  APPLY "CHOOSE":U TO BtnSelect IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnSelect
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnSelect Dialog-Frame
ON CHOOSE OF BtnSelect IN FRAME Dialog-Frame /* Select */
DO:
  IF AVAILABLE ryc_smartobject THEN
    ASSIGN pcLookupName = ryc_smartobject.object_filename
           pcLookupName = IF plIncludePath THEN ryc_smartobject.object_path + "/":U + pcLookupName ELSE pcLookupName
           pcLookupName = REPLACE(pcLookupName,"~\":U,"/":U).
  ELSE
    ASSIGN pcLookupName = "":U.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coProduct
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coProduct Dialog-Frame
ON VALUE-CHANGED OF coProduct IN FRAME Dialog-Frame /* Product */
DO:
  DEFINE VARIABLE cListItems  AS CHARACTER  NO-UNDO.
  
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN coProduct.
    ASSIGN coProductModule:LIST-ITEM-PAIRS = "<None>,Node":U
           cListItems                      = "":U.
    FOR EACH  gsc_product NO-LOCK
        WHERE gsc_product.product_code = coProduct,
        EACH  gsc_product_module NO-LOCK 
        WHERE gsc_product_module.product_obj = gsc_product.product_obj
        BY gsc_product_module.product_module_code:
      cListItems = IF cListItems = "":U 
                      THEN gsc_product_module.product_module_code + " / ":U + gsc_product_module.product_module_description + ",":U + gsc_product_module.product_module_code
                      ELSE cListItems + ",":U + gsc_product_module.product_module_code + " / ":U + gsc_product_module.product_module_description + ",":U + gsc_product_module.product_module_code.
    END.
    coProductModule:LIST-ITEM-PAIRS = cListItems.
    ASSIGN coProductModule:SCREEN-VALUE = coProductModule:ENTRY(1).
    APPLY "VALUE-CHANGED":U TO coProductModule.
  END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coProductModule
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coProductModule Dialog-Frame
ON VALUE-CHANGED OF coProductModule IN FRAME Dialog-Frame /* Product Module */
DO:
  ASSIGN coProduct
         coProductModule.
  ASSIGN pcProduct = coProduct
         pcModule  = coProductModule.
  RUN adecomm/_setcurs.p ("WAIT").
  {&OPEN-QUERY-{&BROWSE-NAME}}
  RUN adecomm/_setcurs.p ("").
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ToShowAll
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ToShowAll Dialog-Frame
ON VALUE-CHANGED OF ToShowAll IN FRAME Dialog-Frame /* Show All Types */
DO:
  ASSIGN toShowAll.
  IF toShowAll THEN
    pcObjectType = "":U.
  ELSE
    pcObjectType = gcObjectType.
  FRAME {&FRAME-NAME}:TITLE = "Lookup Objects - Type '" + IF pcObjectType = "":U THEN "ALL" ELSE pcObjectType + "'".
  {&OPEN-QUERY-{&BROWSE-NAME}}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Dialog-Frame 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.


/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  SESSION:SET-WAIT-STATE("GENERAL":U).  
  RUN buildCombo.
  gcObjectType = pcObjectType.
  IF plOtherTypes THEN
    ASSIGN toShowAll:SENSITIVE IN FRAME {&FRAME-NAME} = TRUE
           toShowAll:HIDDEN IN FRAME {&FRAME-NAME}    = FALSE.
           
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN coProduct = pcProduct.
    APPLY "VALUE-CHANGED":U TO coProduct IN FRAME {&FRAME-NAME}.
    ASSIGN coProductModule = pcModule.
    APPLY "VALUE-CHANGED":U TO coProductModule IN FRAME {&FRAME-NAME}.
  END.
  RUN enable_UI.
  FRAME {&FRAME-NAME}:TITLE = "Lookup Objects - Type '" + IF pcObjectType = "":U THEN "ALL" ELSE pcObjectType + "'".
  SESSION:SET-WAIT-STATE("":U).  
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildCombo Dialog-Frame 
PROCEDURE buildCombo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cListItems  AS CHARACTER  NO-UNDO.
  
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN coProduct:LIST-ITEM-PAIRS = "<None>,Node":U
           cListItems                = "":U.
    FOR EACH gsc_product 
        NO-LOCK 
        BY gsc_product.product_code:
      cListItems = IF cListItems = "":U 
                      THEN gsc_product.product_code + " / ":U + gsc_product.product_description + ",":U + gsc_product.product_code
                      ELSE cListItems + ",":U + gsc_product.product_code + " / ":U + gsc_product.product_description + ",":U + gsc_product.product_code.
    END.
    coProduct:LIST-ITEM-PAIRS = cListItems.
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI Dialog-Frame  _DEFAULT-DISABLE
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
  HIDE FRAME Dialog-Frame.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI Dialog-Frame  _DEFAULT-ENABLE
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
  DISPLAY coProduct coProductModule 
      WITH FRAME Dialog-Frame.
  ENABLE coProduct coProductModule BrBrowse BtnSelect BtnCancel 
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

