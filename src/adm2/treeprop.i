&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*--------------------------------------------------------------------------
    File        : SmTVprop.i
    Purpose     : Defines basic properties.
    Syntax      : {src/adm2/smTVprop.i}

    Description :

    Modified    : 04/05/2001
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

&IF DEFINED(ADM-EXCLUDE-STATIC) = 0 &THEN
/* Custom instance definition file */    
{src/adm2/custom/treeviewdefscustom.i}
&ENDIF

/* Return values for procedures to indicate whether they have 
 * completed successfully or not. */

&GLOBAL-DEFINE xcSuccess '':U
&GLOBAL-DEFINE xcFailure '1':U

/*  Tree line style constants. */

&GLOBAL-DEFINE tvwTreeLines 0
&GLOBAL-DEFINE tvwRootLines 1

/*  Tree relationship constants. */   

&GLOBAL-DEFINE tvwFirst    0    
&GLOBAL-DEFINE tvwLast     1
&GLOBAL-DEFINE tvwNext     2
&GLOBAL-DEFINE tvwPrevious 3
&GLOBAL-DEFINE tvwChild    4

/*  Tree style constants. */
    
&GLOBAL-DEFINE tvwTextOnly                      0
&GLOBAL-DEFINE tvwPictureText                   1
&GLOBAL-DEFINE tvwPlusMinusText                 2
&GLOBAL-DEFINE tvwPlusPictureText               3
&GLOBAL-DEFINE tvwTreelinesText                 4
&GLOBAL-DEFINE tvwTreelinesPictureText          5
&GLOBAL-DEFINE tvwTreelinesPlusMinusText        6
&GLOBAL-DEFINE tvwTreelinesPlusMinusPictureText 7
  
/* Value used to prefix the node key - see
 * getNextNodeKey() in TreeView.i for usage. */

&GLOBAL-DEFINE xcNodePrefix 'i':U

/* Value used to provide a value for the parent of
 * root nodes. See getRootNodeParentKey() in TreeViewSuper.p
 * for usage. */

&GLOBAL-DEFINE xcRootNodeParentKey '':U

/* Define the additional properties that a TreeView has. */

&IF DEFINED(ADM-EXCLUDE-STATIC) = 0 &THEN
&IF "{&xcInstanceProperties}":U NE "":U &THEN
  &GLOBAL-DEFINE xcInstanceProperties {&xcInstanceProperties},
&ENDIF
&GLOBAL-DEFINE xcInstanceProperties {&xcInstanceProperties}AutoSort,HideSelection,ImageHeight,ImageWidth,ShowCheckBoxes,ShowRootLines,TreeStyle,~
ExpandOnAdd,FullRowSelect,OLEDrag,OLEDrop,Scroll,SingleSel,Indentation,LabelEdit,LineStyle

/* This is the procedure to execute to set InstanceProperties at 
 * design time. */

&IF DEFINED (ADM-PROPERTY-DLG) = 0 &THEN
  &SCOP ADM-PROPERTY-DLG adm2/support/treeviewd.w
&ENDIF

&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Include
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Include ASSIGN
         HEIGHT             = 8
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

  /* Include the file which defines prototypes for all of the super
     procedure's entry points. 
     And skip including the prototypes if we are *any* super procedure. */
&IF DEFINED(ADM-EXCLUDE-PROTOTYPES) = 0 &THEN
  &IF "{&ADMSuper}":U EQ "":U &THEN
    {src/adm2/treeprto.i}
  &ENDIF
&ENDIF

/* Put your xp{&Property} preprocessor definitions here.
   Use the following format, e.g.,
   &GLOBAL-DEFINE xpMyProperty
   These preprocessors tell at compile time which properties can
   be retrieved directly from the temp-table */

  &GLOBAL-DEFINE xpTVControllerSource
  &GLOBAL-DEFINE xpExpandOnAdd 
  &GLOBAL-DEFINE xpMinWidth
  &GLOBAL-DEFINE xpMinHeight  
  
{src/adm2/visprop.i}

&IF DEFINED(ADM-EXCLUDE-STATIC) = 0 &THEN
IF NOT {&ADM-PROPS-DEFINED} THEN
DO:
&IF "{&ADMSuper}":U = "":U &THEN
  /* Put your property field definitions here.
     Use the following syntax, e.g.,
     ghADMProps:ADD-NEW-FIELD('MyProperty':U, 'CHAR':U, 0,'X(20)':U, 'Hi':U). */
     
     ghADMProps:ADD-NEW-FIELD('TVControllerSource':U, 'HANDLE':U).
     ghADMProps:ADD-NEW-FIELD('AutoSort':U, 'LOGICAL':U, 0, ?, TRUE).
     ghADMProps:ADD-NEW-FIELD('HideSelection':U, 'LOGICAL':U, 0, ?, TRUE).
     ghADMProps:ADD-NEW-FIELD('ImageHeight':U, 'INTEGER':U, 0, ?, 16).
     ghADMProps:ADD-NEW-FIELD('ImageWidth':U, 'INTEGER':U, 0, ?, 16).
     ghADMProps:ADD-NEW-FIELD('ShowCheckBoxes':U, 'LOGICAL':U, 0, ?, FALSE).     
     ghADMProps:ADD-NEW-FIELD('ShowRootLines':U, 'LOGICAL':U, 0, ?, FALSE).
     ghADMProps:ADD-NEW-FIELD('TreeStyle':U, 'INTEGER':U,0,?,7).
     ghADMProps:ADD-NEW-FIELD('ExpandOnAdd':U, 'LOGICAL':U, 0,?,NO ).
     ghADMProps:ADD-NEW-FIELD('FullRowSelect':U, 'LOGICAL':U, 0,?,NO ).
     ghADMProps:ADD-NEW-FIELD('Indentation':U, 'INTEGER':U, 0,?, 20 ).
     ghADMProps:ADD-NEW-FIELD('LabelEdit':U, 'INTEGER':U, 0,?, 1 ).
     ghADMProps:ADD-NEW-FIELD('LineStyle':U, 'INTEGER':U, 0,?,0 ).
     ghADMProps:ADD-NEW-FIELD('SingleSel':U, 'LOGICAL':U, 0,?,0 ).
     ghADMProps:ADD-NEW-FIELD('OLEDrag':U, 'LOGICAL':U, 0,?,NO ).
     ghADMProps:ADD-NEW-FIELD('OLEDrop':U, 'LOGICAL':U, 0,?,NO ).
     ghADMProps:ADD-NEW-FIELD('Scroll':U, 'LOGICAL':U, 0,?,YES ).
     ghADMProps:ADD-NEW-FIELD('MinWidth':U, 'INTEGER':U, 0,?, 7 ).
     ghADMProps:ADD-NEW-FIELD('MinHeight':U, 'INTEGER':U, 0,?,2 ).

&ENDIF

{src/adm2/custom/treepropcustom.i}

END.

&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


