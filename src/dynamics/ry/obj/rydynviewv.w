&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
/* Procedure Description
"This is the Astra 2 Dynamic Viewer. No new instances of this should be created. Use the Astra 2 Wizard Menu Controller to create instances using Repository Data."
*/
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
{adecomm/appserv.i}
DEFINE VARIABLE h_Astra                    AS HANDLE          NO-UNDO.
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Check Version Notes Wizard" vTableWin _INLINE
/* Actions: af/cod/aftemwizcw.w ? ? ? ? */
/* MIP Update Version Notes Wizard
Check object version notes.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS vTableWin 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: rydynviewv.w

  Description:  ICF Dynamic SmartDataViewer

  Purpose:      ICF Dynamic SmartDataViewer

  Parameters:

  History:
  --------
  (v:010000)    Task:   101000006   UserRef:    
                Date:   07/31/2001  Author:     Peter Judge

  Update Notes: Move for customisation

  (v:010001)    Task:   101000006   UserRef:    
                Date:   07/31/2001  Author:     Peter Judge

  Update Notes: NEW/ Dynamic Viewer

  (v:010002)    Task:   101000028   UserRef:    
                Date:   09/11/2001  Author:     Peter Judge

  Update Notes: - change NoLookups to NoPopups
                - change TabOrder to use FieldOrder
                - remove EnabledField attribute. Will use Enabled instead
                - change DataSourceName to DataSource

  (v:010003)    Task:           0   UserRef:    
                Date:   02/05/2002  Author:     Mark Davies (MIP)

  Update Notes: Fix for issue #3627 - Toolbar with tableiotype ‘UPDATE’ does not sentisize correctly
                Always ensure that all fields on the viewer are disabled on initialization.

  (v:010004)    Task:           0   UserRef:    
                Date:   02/05/2002  Author:     Mark Davies (MIP)

  Update Notes: Implemented HideOnInit property to keep the object hidden if this
                attribute was set to TRUE.
-------------------------------------------------------------------------------*/
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

&scop object-name       rydynviewv.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* tell smart.i that we can use the default destroyObject */ 
&SCOPED-DEFINE include-destroyobject

/* The displayObjects procedure is contained in datavis.i and
   displays the initial values for non-database widgets when the
   viewer is first instantiated. This uses the {&DISPLAYED-OBJECTS}
   pre-processor.
   However, in a dynamic viewer, all of this information is contained
   in the Repository, and there is an displayObjects override in the
   viewer's rendering super (rydynviewp.p). We need to exclude the
   static behaviour completely.
 */
&SCOPED-DEFINE EXCLUDE-displayObjects

/* Astra 2 object identifying preprocessor */
&glob   astra2-dynamicviewer YES

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDataViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER FRAME

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frMain

/* Custom List Definitions                                              */
/* ADM-ASSIGN-FIELDS,List-2,List-3,List-4,List-5,List-6                 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getHeight vTableWin 
FUNCTION getHeight RETURNS DECIMAL
    ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getWidth vTableWin 
FUNCTION getWidth RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY USE-DICT-EXPS 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1
         SIZE 58.2 BY 1.67.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataViewer
   Compile into: ry/obj
   Allow: Basic,DB-Fields,Smart
   Container Links: Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE APPSERVER
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
         HEIGHT             = 1.67
         WIDTH              = 58.2.
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
   NOT-VISIBLE                                                          */
ASSIGN 
       FRAME frMain:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME frMain
/* Query rebuild information for FRAME frMain
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME frMain */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK vTableWin 


/* ***************************  Main Block  *************************** */
    
&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN
    RUN initializeObject.
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeObject vTableWin 
PROCEDURE resizeObject :
/*------------------------------------------------------------------------------
  Purpose:     Resize procedure.
  Parameters:  pdHeight -
               pcWidth  -
  Notes:       * This procedure is here because resizeObject is not part of the ADM
                 procedures and is thus not 'visible' from the INTERNAL-ENTRIES
                 attribute. This API is needed so that resizing will happen for 
                 dynamic viewers.
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pdHeight             AS DECIMAL              NO-UNDO.
    DEFINE INPUT PARAMETER pdWidth              AS DECIMAL              NO-UNDO.
    
    /* We don't check for errors because there will be many cases where
     * there is no resizeObject for the viewer. In this cse, simply ignore 
     * any errors.                                                         */
    RUN SUPER (INPUT pdHeight, INPUT pdWidth) NO-ERROR.
    
    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* resizeObject */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getHeight vTableWin 
FUNCTION getHeight RETURNS DECIMAL
    ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Notes:       * This function must appear here because the Dynamics viewer super
                 procedure is not an ADM2 procedure and thus dones't have the 
                 ghProp variable defined.
------------------------------------------------------------------------------*/
    DEFINE VARIABLE dHeight             AS DECIMAL                      NO-UNDO.
    DEFINE VARIABLE dMinHeight          AS DECIMAL                      NO-UNDO.

    /* Code placed here will execute PRIOR to standard behavior. */
    ASSIGN dHeight = SUPER( ).

    IF dHeight NE 0 AND dHeight NE ? THEN
    DO:
        /* We take the code from getMinHeight in visual.p and put it here since
         * that API causes a recursive call if the Height and MinHeight values 
         * differ. */
        /*{get MinHeight dMinHeight}.*/
        &SCOPED-DEFINE xpMinHeight
        {get MinHeight dMinHeight}.
        &UNDEFINE xpMinHeight
        
        IF dMinHeight EQ 0 OR dMinHeight EQ ? THEN
            {set MinHeight dHeight}.
        ELSE
        IF dHeight LT dMinHeight THEN
            ASSIGN dHeight = dMinHeight.
    END.
    ELSE
    IF dHeight EQ 0 OR dHeight EQ ? THEN
        ASSIGN dHeight = 0.1.

    RETURN dHeight.
END FUNCTION.   /* getHeight */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getWidth vTableWin 
FUNCTION getWidth RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Notes:       * This function must appear here because the Dynamics viewer super
                 procedure is not an ADM2 procedure and thus dones't have the 
                 ghProp variable defined.
------------------------------------------------------------------------------*/
    DEFINE VARIABLE dWidth     AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE dMinWidth  AS DECIMAL    NO-UNDO.

    /* Code placed here will execute PRIOR to standard behavior. */
    ASSIGN dWidth = SUPER( ).

    IF dWidth NE 0 AND dWidth NE ? THEN
    DO:
        /* We take the code from getMinWidth in visual.p and put it here since
         * that API causes a recursive call if the Width and MinWidth values 
         * differ. */
        /*{get MinWidth dMinWidth}.*/
        &SCOPED-DEFINE xpMinWidth
        {get MinWidth dMinWidth}.
        &UNDEFINE xpMinWidth
        
        IF dMinWidth EQ 0 OR dMinWidth EQ ? THEN
            {set MinWidth dWidth}.
        ELSE
        IF dWidth LT dMinWidth THEN
            ASSIGN dWidth = dMinWidth.
    END.
    ELSE
    IF dWidth EQ 0 OR dWidth EQ ? THEN
        ASSIGN dWidth = 0.1.

    RETURN dWidth.
END FUNCTION.   /* getWidth */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

