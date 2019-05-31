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
       {"af/obj2/gsmmmfullo.i"}.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS vTableWin 
/* Copyright (C) 2005-2007,2012 by Progress Software Corporation. All rights
   reserved.  Prior versions of this work may contain portions
   contributed by participants of Possenet. */
/*---------------------------------------------------------------------------------
  File: gsmmmimg1v.w

  Description:  Multi Media Image SmartDataViewer

  Purpose:      Multi Media Image SmartDataViewer

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:   101000022   UserRef:    
                Date:   08/28/2001  Author:     Mark Davies

  Update Notes: Created from Template rysttviewv.w
                Multi Media Image SmartDataViewer

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

&scop object-name       gsmmmimg1v.w
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
&Scoped-define DATA-FIELD-DEFS "af/obj2/gsmmmfullo.i"

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS RowObject.multi_media_description ~
RowObject.physical_file_name 
&Scoped-define ENABLED-TABLES RowObject
&Scoped-define FIRST-ENABLED-TABLE RowObject
&Scoped-Define ENABLED-OBJECTS iImage buImage 
&Scoped-Define DISPLAYED-FIELDS RowObject.multi_media_description ~
RowObject.physical_file_name 
&Scoped-define DISPLAYED-TABLES RowObject
&Scoped-define FIRST-DISPLAYED-TABLE RowObject


/* Custom List Definitions                                              */
/* ADM-ASSIGN-FIELDS,List-2,List-3,List-4,List-5,List-6                 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE hCategory AS HANDLE NO-UNDO.
DEFINE VARIABLE hMultiMediaType AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON buImage 
     LABEL "&Image" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE IMAGE iImage
     FILENAME "adeicon/blank":U
     SIZE 93.4 BY 3.14.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     RowObject.multi_media_description AT ROW 3.19 COL 23 COLON-ALIGNED
          LABEL "Multi media description"
          VIEW-AS FILL-IN 
          SIZE 78.4 BY 1
     RowObject.physical_file_name AT ROW 4.29 COL 23 COLON-ALIGNED
          LABEL "Physical file name"
          VIEW-AS FILL-IN 
          SIZE 78.4 BY 1
     buImage AT ROW 4.19 COL 103.8
     iImage AT ROW 5.38 COL 25.2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY USE-DICT-EXPS 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataViewer
   Data Source: "af/obj2/gsmmmfullo.w"
   Allow: Basic,DB-Fields,Smart
   Container Links: Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: RowObject D "?" ?  
      ADDITIONAL-FIELDS:
          {af/obj2/gsmmmfullo.i}
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
         HEIGHT             = 7.67
         WIDTH              = 117.8.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit L-To-R,COLUMNS                    */
ASSIGN 
       FRAME frMain:SCROLLABLE       = FALSE
       FRAME frMain:HIDDEN           = TRUE.

ASSIGN 
       iImage:HIDDEN IN FRAME frMain           = TRUE.

/* SETTINGS FOR FILL-IN RowObject.multi_media_description IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN RowObject.physical_file_name IN FRAME frMain
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

&Scoped-define SELF-NAME buImage
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buImage vTableWin
ON CHOOSE OF buImage IN FRAME frMain /* Image */
DO:
  DEFINE VARIABLE lOk                 AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cFilename           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDirectory          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAbsFileName        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cErrorMessage       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButton             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cImageFormats       AS CHARACTER  NO-UNDO.
  
  DO WITH FRAME {&FRAME-NAME}:

    cFilename = RowObject.physical_file_name:SCREEN-VALUE.

    ASSIGN cFileName     = SUBSTRING(cFileName, 1, R-INDEX(cFileName , ".":U)- 1)
           cDirectory    = "adeicon,ry/img":U
           cImageFormats = "All Picture Files|*.bmp,*.gif,*.ico,*.jpg,*.png,*.tif" +
                        "|Bitmap (*.bmp)|*.bmp" +
                        "|GIF (*.gif)|*.gif" +
                        "|Icon (*.ico)|*.ico" + 
                        "|JPEG (*.jpg)|*.jpg" + 
                        "|PNG (*.png)|*.png" + 
                        "|TIFF (*.tif)|*.tif" +
                        "|All Files|*.*":U
                        NO-ERROR.

    RUN adecomm/_fndfile.p (INPUT "Image",
                            INPUT "IMAGE":U,
                            &IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
                            INPUT cImageFormats,
                            &ELSE
                            INPUT "*.xpm,*.xbm|*.*",
                            &ENDIF
                            INPUT-OUTPUT cDirectory,
                            INPUT-OUTPUT cFileName,
                            OUTPUT cAbsFileName,
                            OUTPUT lOk).

    
    cFileName = REPLACE(cFileName,"~\":U,"/":U).
    
    IF lOk THEN DO:
      IF SEARCH(cFileName) = ? OR 
         REPLACE(SEARCH(cFileName),"~\":U,"/":U) = cFileName THEN DO:
        ASSIGN cErrorMessage = {af/sup2/aferrortxt.i 'AF' '21' '' '' '"be relatively pathed"'}.
        RUN showMessages IN gshSessionManager (INPUT  cErrorMessage,            /* message to display */
                                               INPUT  "ERR":U,                  /* error type */
                                               INPUT  "&OK":U,                  /* button list */
                                               INPUT  "&OK":U,                  /* default button */ 
                                               INPUT  "&OK":U,                  /* cancel button */
                                               INPUT  "Error":U,                /* error window title */
                                               INPUT  YES,                      /* display if empty */ 
                                               INPUT  THIS-PROCEDURE,           /* container handle */ 
                                               OUTPUT cButton                   /* button pressed */
                                              ).
        RETURN NO-APPLY.
      END.
      ELSE DO:
        ASSIGN RowObject.physical_file_name:SCREEN-VALUE = cFileName.
               iImage:LOAD-IMAGE(cFileName).
        {set DataModified TRUE}.
      END.
    END.
  END.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addRecord vTableWin 
PROCEDURE addRecord :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.
  /* Make sure the image is cleared before we get in here 
    it will be re-loaded in displayFields */
  DO WITH FRAME {&FRAME-NAME}:
    iImage:LOAD-IMAGE("":U).
  END.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects vTableWin  _ADM-CREATE-OBJECTS
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
             INPUT  'adm2/dyncombo.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldgsc_multi_media_type.multi_media_type_code,gsc_multi_media_type.multi_media_type_descriptionKeyFieldgsc_multi_media_type.multi_media_type_objFieldLabelMulti media typeFieldTooltipSelect a multi media typeKeyFormat->>>>>>>>>>>>>>>>>9.999999999KeyDatatypedecimalDisplayFormatX(10)DisplayDatatypecharacterBaseQueryStringFOR EACH gsc_multi_media_typeQueryTablesgsc_multi_media_typeSDFFileNameSDFTemplateParentFieldParentFilterQueryDescSubstitute&1 / &2ComboDelimiterListItemPairsInnerLines5SortnoComboFlagFlagValueBuildSequence1SecurednoCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListQueryBuilderOrderListQueryBuilderTableOptionListQueryBuilderTuneOptionsQueryBuilderWhereClausesUseCacheyesSuperProcedureDataSourceNameFieldNamemulti_media_type_objDisplayFieldyesEnableFieldyesLocalFieldnoHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT hMultiMediaType ).
       RUN repositionObject IN hMultiMediaType ( 1.00 , 25.00 ) NO-ERROR.
       RUN resizeObject IN hMultiMediaType ( 1.05 , 78.40 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dyncombo.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldgsm_category.category_description,gsm_category.category_type,gsm_category.category_group,gsm_category.category_subgroupKeyFieldgsm_category.category_objFieldLabelCategoryFieldTooltipSelect a categoryKeyFormat->>>>>>>>>>>>>>>>>9.999999999KeyDatatypedecimalDisplayFormatX(256)DisplayDatatypeCHARACTERBaseQueryStringFOR EACH gsm_category
                     WHERE gsm_category.related_entity_mnemonic = "GSMMM":UQueryTablesgsm_categorySDFFileNameSDFTemplateParentFieldParentFilterQueryDescSubstitute&1 (&2,&3,&4)ComboDelimiterListItemPairsInnerLines5SortnoComboFlagFlagValueBuildSequence1SecurednoCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListQueryBuilderOrderListQueryBuilderTableOptionListQueryBuilderTuneOptionsQueryBuilderWhereClausesUseCacheyesSuperProcedureDataSourceNameFieldNamecategory_objDisplayFieldyesEnableFieldyesLocalFieldnoHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT hCategory ).
       RUN repositionObject IN hCategory ( 2.10 , 25.00 ) NO-ERROR.
       RUN resizeObject IN hCategory ( 0.91 , 78.40 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( hMultiMediaType ,
             RowObject.multi_media_description:HANDLE IN FRAME frMain , 'BEFORE':U ).
       RUN adjustTabOrder ( hCategory ,
             hMultiMediaType , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.

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
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcColValues AS CHARACTER NO-UNDO.

  DEFINE VARIABLE cImageFile AS CHARACTER  NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER( INPUT pcColValues).
  DO WITH FRAME {&FRAME-NAME}:
    cImageFile = ENTRY(3,pcColValues,CHR(1)).
    IF SEARCH(cImageFile) <> ? THEN
      iImage:LOAD-IMAGE(cImageFile).
    ELSE
      iImage:LOAD-IMAGE(?).
    iImage:HIDDEN = FALSE.
  END.
  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getImmage vTableWin 
PROCEDURE getImmage :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER phImageUp  AS HANDLE    NO-UNDO.

  DEFINE INPUT  PARAMETER phButton   AS HANDLE    NO-UNDO.


  define variable cFileName     as character format "x(60)":U no-undo.
  define variable cDirectory    as character format "x(60)":U no-undo.
  define variable cAbsFilename  as character format "x(60)":U no-undo.
  define variable cExtension    as character no-undo.
  DEFINE VARIABLE lOK           AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE image-formats AS CHARACTER  NO-UNDO.
  assign cFileName  = phImageUp:SCREEN-VALUE
         cFileName  = substring(cFileName, 1, r-index(cFileName , ".":u)- 1)
         cDirectory = "adeicon,ry/img":U
         image-formats = "All Picture Files|*.bmp,*.gif,*.ico,*.jpg,*.png,*.tif" +
                        "|Bitmap (*.bmp)|*.bmp" +
                        "|GIF (*.gif)|*.gif" +
                        "|Icon (*.ico)|*.ico" + 
                        "|JPEG (*.jpg)|*.jpg" + 
                        "|PNG (*.png)|*.png" + 
                        "|TIFF (*.tif)|*.tif" +
                        "|All Files|*.*":U
                        NO-ERROR.

  run adecomm/_fndfile.p   (input "Image",
                            input "IMAGE":u,
                            &IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
                              INPUT image-formats,
                            &ELSE
                              INPUT "*.xpm,*.xbm|*.*",
                            &ENDIF
                            input-output cDirectory,
                            input-output cFileName,
                            output cAbsFileName,
                            output lOk).

  IF lOK THEN DO:
     phButton:load-image(cFileName) NO-ERROR.
     phImageUp:SCREEN-VALUE = cFileName.
    {set DataModified YES}.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeObject vTableWin 
PROCEDURE resizeObject :
/*------------------------------------------------------------------------------
  Purpose:    Resize the viewer
  Parameters: pd_height AS DECIMAL - the desired height (in rows)
              pd_width  AS DECIMAL - the desired width (in columns)
    Notes:    Used internally. Calls to resizeObject are generated by the
              AppBuilder in adm-create-objects for objects which implement it.
              Having a resizeObject procedure is also the signal to the AppBuilder
              to allow the object to be resized at design time.
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pdHeight       AS DECIMAL NO-UNDO.
  DEFINE INPUT PARAMETER pdWidth        AS DECIMAL NO-UNDO.

  DEFINE VARIABLE lPreviouslyHidden     AS LOGICAL NO-UNDO.
  DEFINE VARIABLE hWindow               AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hContainerSource      AS HANDLE  NO-UNDO.

  DEFINE VARIABLE dFramePrevWidth       AS DECIMAL NO-UNDO.
  DEFINE VARIABLE dFramePrevHeight      AS DECIMAL NO-UNDO.
  DEFINE VARIABLE dWidthDiff            AS DECIMAL NO-UNDO.
  DEFINE VARIABLE dHeightDiff           AS DECIMAL NO-UNDO.

  /* Get container and window handles */
  {get ContainerSource hContainerSource}.
  {get ContainerHandle hWindow hContainerSource}.

  /* Save prev size */
  ASSIGN dFramePrevWidth  = FRAME {&FRAME-NAME}:WIDTH-CHARS
         dFramePrevHeight = FRAME {&FRAME-NAME}:HEIGHT-CHARS.

  /* Save hidden state of current frame, then hide it */
  FRAME {&FRAME-NAME}:SCROLLABLE = FALSE.                                               
  lPreviouslyHidden = FRAME {&FRAME-NAME}:HIDDEN.                                                           
  FRAME {&FRAME-NAME}:HIDDEN = TRUE.

  /* Resize frame relative to containing window size */
  FRAME {&FRAME-NAME}:HEIGHT-CHARS = pdHeight.
  FRAME {&FRAME-NAME}:WIDTH-CHARS  = pdWidth.

  ASSIGN dWidthDiff  = dFramePrevWidth  - FRAME {&FRAME-NAME}:WIDTH-CHARS
         dHeightDiff = dFramePrevHeight - FRAME {&FRAME-NAME}:HEIGHT-CHARS.

  /* Resize image - relative to current frame */
  ASSIGN   
    iImage:WIDTH-CHARS  = iImage:WIDTH-CHARS  - dWidthDiff - 1
    iImage:HEIGHT-CHARS = iImage:HEIGHT-CHARS - dHeightDiff - .5.

  /* Restore original hidden state of current frame */
  APPLY "end-resize":U TO FRAME {&FRAME-NAME}.
  FRAME {&FRAME-NAME}:HIDDEN = lPreviouslyHidden NO-ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


