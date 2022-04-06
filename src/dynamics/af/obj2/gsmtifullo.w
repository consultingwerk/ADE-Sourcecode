&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          icfdb            PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
{adecomm/appserv.i}
DEFINE VARIABLE h_Astra                    AS HANDLE          NO-UNDO.
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" dTables _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" dTables _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "SmartDataObjectWizard" dTables _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* SmartDataObject Wizard
Welcome to the SmartDataObject Wizard! During the next few steps, the wizard will lead you through creating a SmartDataObject. You will define the query that you will use to retrieve data from your database(s) and define a set of field values to make available to visualization objects. Press Next to proceed.
adm2/support/_wizqry.w,adm2/support/_wizfld.w 
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS dTables 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: rysttasdoo.w

  Description:  Template SmartDataObject Template

  Purpose:      Template SmartDataObject Template

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:        6180   UserRef:    
                Date:   28/06/2000  Author:     Anthony Swindells

  Update Notes: V9 Templates

--------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

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

&scop object-name       gsmtifullo.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Object identifying preprocessor */
&glob   astra2-staticSmartDataObject yes

{src/adm2/globals.i}

&glob DATA-LOGIC-PROCEDURE       af/obj2/gsmtilogcp.p

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDataObject
&Scoped-define DB-AWARE yes

&Scoped-define ADM-SUPPORTED-LINKS Data-Source,Data-Target,Navigation-Target,Update-Target,Commit-Target,Filter-Target


/* Db-Required definitions. */
&IF DEFINED(DB-REQUIRED) = 0 &THEN
    &GLOBAL-DEFINE DB-REQUIRED TRUE
&ENDIF
&GLOBAL-DEFINE DB-REQUIRED-START   &IF {&DB-REQUIRED} &THEN
&GLOBAL-DEFINE DB-REQUIRED-END     &ENDIF


&Scoped-define QUERY-NAME Query-Main

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES gsm_translated_menu_item

/* Definitions for QUERY Query-Main                                     */
&Scoped-Define ENABLED-FIELDS  menu_item_obj source_language_obj language_obj menu_item_label tooltip_text~
 alternate_shortcut_key item_toolbar_label image1_up_filename~
 image1_down_filename image1_insensitive_filename image2_up_filename~
 image2_down_filename image2_insensitive_filename item_narration
&Scoped-define ENABLED-FIELDS-IN-gsm_translated_menu_item menu_item_obj ~
source_language_obj language_obj menu_item_label tooltip_text ~
alternate_shortcut_key item_toolbar_label image1_up_filename ~
image1_down_filename image1_insensitive_filename image2_up_filename ~
image2_down_filename image2_insensitive_filename item_narration 
&Scoped-Define DATA-FIELDS  translated_menu_item_obj menu_item_obj source_language_obj language_obj~
 menu_item_label tooltip_text alternate_shortcut_key item_toolbar_label~
 image1_up_filename image1_down_filename image1_insensitive_filename~
 image2_up_filename image2_down_filename image2_insensitive_filename~
 item_narration
&Scoped-define DATA-FIELDS-IN-gsm_translated_menu_item ~
translated_menu_item_obj menu_item_obj source_language_obj language_obj ~
menu_item_label tooltip_text alternate_shortcut_key item_toolbar_label ~
image1_up_filename image1_down_filename image1_insensitive_filename ~
image2_up_filename image2_down_filename image2_insensitive_filename ~
item_narration 
&Scoped-Define MANDATORY-FIELDS 
&Scoped-Define APPLICATION-SERVICE 
&Scoped-Define ASSIGN-LIST 
&Scoped-Define DATA-FIELD-DEFS "af/obj2/gsmtifullo.i"
&Scoped-define QUERY-STRING-Query-Main FOR EACH gsm_translated_menu_item NO-LOCK INDEXED-REPOSITION
{&DB-REQUIRED-START}
&Scoped-define OPEN-QUERY-Query-Main OPEN QUERY Query-Main FOR EACH gsm_translated_menu_item NO-LOCK INDEXED-REPOSITION.
{&DB-REQUIRED-END}
&Scoped-define TABLES-IN-QUERY-Query-Main gsm_translated_menu_item
&Scoped-define FIRST-TABLE-IN-QUERY-Query-Main gsm_translated_menu_item


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

{&DB-REQUIRED-START}

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY Query-Main FOR 
      gsm_translated_menu_item SCROLLING.
&ANALYZE-RESUME
{&DB-REQUIRED-END}


/* ************************  Frame Definitions  *********************** */


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataObject
   Allow: Query
   Frames: 0
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE APPSERVER DB-AWARE
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
  CREATE WINDOW dTables ASSIGN
         HEIGHT             = 1.62
         WIDTH              = 57.8.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB dTables 
/* ************************* Included-Libraries *********************** */

{src/adm2/data.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW dTables
  VISIBLE,,RUN-PERSISTENT                                               */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK QUERY Query-Main
/* Query rebuild information for SmartDataObject Query-Main
     _TblList          = "ICFDB.gsm_translated_menu_item"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > ICFDB.gsm_translated_menu_item.translated_menu_item_obj
"translated_menu_item_obj" "translated_menu_item_obj" ? ? "decimal" ? ? ? ? ? ? no ? no 24 yes
     _FldNameList[2]   > ICFDB.gsm_translated_menu_item.menu_item_obj
"menu_item_obj" "menu_item_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 24 yes
     _FldNameList[3]   > ICFDB.gsm_translated_menu_item.source_language_obj
"source_language_obj" "source_language_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 24 yes
     _FldNameList[4]   > ICFDB.gsm_translated_menu_item.language_obj
"language_obj" "language_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 24 yes
     _FldNameList[5]   > ICFDB.gsm_translated_menu_item.menu_item_label
"menu_item_label" "menu_item_label" ? ? "character" ? ? ? ? ? ? yes ? no 56 no
     _FldNameList[6]   > ICFDB.gsm_translated_menu_item.tooltip_text
"tooltip_text" "tooltip_text" ? ? "character" ? ? ? ? ? ? yes ? no 140 no
     _FldNameList[7]   > ICFDB.gsm_translated_menu_item.alternate_shortcut_key
"alternate_shortcut_key" "alternate_shortcut_key" ? ? "character" ? ? ? ? ? ? yes ? no 30 no
     _FldNameList[8]   > ICFDB.gsm_translated_menu_item.item_toolbar_label
"item_toolbar_label" "item_toolbar_label" ? ? "character" ? ? ? ? ? ? yes ? no 56 no
     _FldNameList[9]   > ICFDB.gsm_translated_menu_item.image1_up_filename
"image1_up_filename" "image1_up_filename" ? ? "character" ? ? ? ? ? ? yes ? no 140 no
     _FldNameList[10]   > ICFDB.gsm_translated_menu_item.image1_down_filename
"image1_down_filename" "image1_down_filename" ? ? "character" ? ? ? ? ? ? yes ? no 140 no
     _FldNameList[11]   > ICFDB.gsm_translated_menu_item.image1_insensitive_filename
"image1_insensitive_filename" "image1_insensitive_filename" ? ? "character" ? ? ? ? ? ? yes ? no 140 no
     _FldNameList[12]   > ICFDB.gsm_translated_menu_item.image2_up_filename
"image2_up_filename" "image2_up_filename" ? ? "character" ? ? ? ? ? ? yes ? no 140 no
     _FldNameList[13]   > ICFDB.gsm_translated_menu_item.image2_down_filename
"image2_down_filename" "image2_down_filename" ? ? "character" ? ? ? ? ? ? yes ? no 140 no
     _FldNameList[14]   > ICFDB.gsm_translated_menu_item.image2_insensitive_filename
"image2_insensitive_filename" "image2_insensitive_filename" ? ? "character" ? ? ? ? ? ? yes ? no 140 no
     _FldNameList[15]   > ICFDB.gsm_translated_menu_item.item_narration
"item_narration" "item_narration" ? ? "character" ? ? ? ? ? ? yes ? no 1000 no
     _Design-Parent    is WINDOW dTables @ ( 1.14 , 2.6 )
*/  /* QUERY Query-Main */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK dTables 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN initializeObject.
  &ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI dTables  _DEFAULT-DISABLE
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
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

