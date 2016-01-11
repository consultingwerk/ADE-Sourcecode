&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
/* Procedure Description
"This is the Astra 2 Dynamic Browser. No new instances of this should be created. Use the Astra 2 Wizard Menu Controller to create instances using Repository Data."
*/
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Check Version Notes Wizard" bTableWin _INLINE
/* Actions: af/cod/aftemwizcw.w ? ? ? ? */
/* MIP Update Version Notes Wizard
Check object version notes.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" bTableWin _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" bTableWin _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS bTableWin 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: rydynbrowb.w

  Description:  Dynamic SmartBrowser

  Purpose:      Dynamic SmartBrowser

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:        6180   UserRef:    
                Date:   28/06/2000  Author:     Anthony Swindells

  Update Notes: Write Astra 2 Templates

  (v:010002)    Task:        6180   UserRef:    
                Date:   28/06/2000  Author:     Anthony Swindells

  Update Notes: V9 Templates

  (v:010003)    Task:        6205   UserRef:    
                Date:   30/06/2000  Author:     Robin Roos

  Update Notes: Dynamic Viewer

  (v:010004)    Task:        6246   UserRef:    
                Date:   13/07/2000  Author:     Jenny Bond

  Update Notes: Implement transfer to Excel

  (v:010005)    Task:        6290   UserRef:    
                Date:   13/07/2000  Author:     Jenny Bond

  Update Notes: Fix Title Problems

  (v:010006)    Task:        6406   UserRef:    9.1B
                Date:   03/08/2000  Author:     Anthony Swindells

  Update Notes: Many tuning enhancements plus correct mode handling

  (v:010008)    Task:        6838   UserRef:    
                Date:   10/10/2000  Author:     Anthony Swindells

  Update Notes: Make browsers refreshable

  (v:010009)    Task:        6838   UserRef:    
                Date:   10/10/2000  Author:     Anthony Swindells

  Update Notes: fix sort issue with empty browser

  (v:010010)    Task:        6842   UserRef:    
                Date:   10/10/2000  Author:     Anthony Swindells

  Update Notes: fix sort on calculated field

  (v:010011)    Task:        6937   UserRef:    
                Date:   23/10/2000  Author:     Jenny Bond

  Update Notes: Field too large for data item error in browse Removed selected_fields field out of
                the browser.

  (v:010012)    Task:        7487   UserRef:    
                Date:   12/01/2001  Author:     Anthony Swindells

  Update Notes: Fix issues with multi-pages and folder wizard

  (v:010001)    Task:    90000087   UserRef:    POSSE
                Date:   01/05/2001  Author:     Haavard Danielsen

  Update Notes: Changed defaultAction to be ADM compatible

---------------------------------------------------------*/
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

&scop object-name       rydynbrowb.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    010001

/* Astra 2 object identifying preprocessor */
&glob   astra2-dynamicbrowser yes

{af/sup2/afglobals.i}

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

  &IF "{&xcInstanceProperties}":U NE "":U &THEN
    &GLOB xcInstanceProperties {&xcInstanceProperties},
  &ENDIF
  &GLOB xcInstanceProperties {&xcInstanceProperties}DisplayedFields,EnabledFields

  &SCOP ADM-PROPERTY-DLG adm2/support/dynbrowserd.w

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDataBrowser
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS TableIO-Target,Data-Target,Update-Source

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br_table

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD notNull bTableWin 
FUNCTION notNull RETURNS CHARACTER
  ( pcValue AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table bTableWin _STRUCTURED

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN NO-ROW-MARKERS NO-COLUMN-SCROLLING SEPARATORS SIZE 66 BY 6.67.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataBrowser
   Allow: Basic,Browse
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
  CREATE WINDOW bTableWin ASSIGN
         HEIGHT             = 6.86
         WIDTH              = 66.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB bTableWin 
/* ************************* Included-Libraries *********************** */

  {src/adm2/browser.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW bTableWin
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit                                              */
/* BROWSE-TAB br_table 1 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _Query            is NOT OPENED
*/  /* BROWSE br_table */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME





/* ************************  Control Triggers  ************************ */

&Scoped-define BROWSE-NAME br_table
&Scoped-define SELF-NAME br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table bTableWin
ON END OF br_table IN FRAME F-Main
DO:
  {src/adm2/brsend.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table bTableWin
ON F5 OF br_table IN FRAME F-Main
DO:
  /* Refresh browse query and reposition to currently selected row */
  DEFINE VARIABLE hSource   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cRowIdent AS CHARACTER  NO-UNDO.

  BROWSE {&BROWSE-NAME}:REFRESHABLE = NO.
  {get DataSource hSource}.
  cRowident = DYNAMIC-FUNCTION('getRowIdent':U IN hSource) NO-ERROR.
  IF VALID-HANDLE(hSource) THEN
  DO:
    DYNAMIC-FUNCTION('openQuery' IN hSource).
    IF cRowIdent <> ? AND cRowIdent <> "":U THEN
      DYNAMIC-FUNCTION('fetchRowIdent' IN hSource, cRowIdent, '':U) NO-ERROR.
  END.
  BROWSE {&BROWSE-NAME}:REFRESHABLE = YES.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table bTableWin
ON HOME OF br_table IN FRAME F-Main
DO:
  {src/adm2/brshome.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table bTableWin
ON MOUSE-MENU-DBLCLICK OF br_table IN FRAME F-Main
DO:
/*     DEFINE VARIABLE hBrowse AS HANDLE.                                                */
/*     DEFINE VARIABLE cNames AS CHARACTER.                                              */
/*     DEFINE VARIABLE hColumn AS HANDLE.                                                */
/*     hBrowse = {&BROWSE-NAME}:HANDLE.                                                  */
/*                                                                                       */
/*                                                                                       */
/*     hColumn = hBrowse:FIRST-COLUMN.                                                   */
/*     REPEAT WHILE VALID-HANDLE(hColumn).                                               */
/*         cNames = cNames + notNull(hColumn:TABLE) + "*" + notNull(hColumn:NAME) + " ". */
/*         hColumn = hColumn:NEXT-COLUMN.                                                */
/*     END.                                                                              */
/*                                                                                       */
/*     MESSAGE cNames.                                                                   */

/*     DEFINE VARIABLE hDataSource AS HANDLE NO-UNDO.                                    */
/*     DEFINE VARIABLE hDataSOurce2 AS HANDLE NO-UNDO.                                   */
/*     DEFINE VARIABLE cForeignFields AS CHARACTER NO-UNDO.                              */
/*     {get DataSource hDataSource}.                                                     */
/*     {get DataSOurce hDataSource2 hDataSOurce}.                                        */
/*     {set ForeignFields 'attribute_group_obj,attribute_group_obj' hDataSource}.        */
/*     {get ForeignFields cForeignFields hDataSource}.                                   */
/*                                                                                       */
/*                                                                                       */
/*     MESSAGE "datasource" hDataSOurce:FILE-NAME cForeignFields hDataSOurce2:FILE-NAME. */
/*     DYNAMIC-FUNCTION('setFilterActive' IN hDataSource, TRUE).                         */

    MESSAGE "browse width=" {&BROWSE-NAME}:WIDTH.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table bTableWin
ON MOUSE-SELECT-DBLCLICK OF br_table IN FRAME F-Main
DO:
  RUN launchFolderWindow ("View").
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table bTableWin
ON OFF-END OF br_table IN FRAME F-Main
DO:
  {src/adm2/brsoffnd.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table bTableWin
ON OFF-HOME OF br_table IN FRAME F-Main
DO:
  {src/adm2/brsoffhm.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table bTableWin
ON ROW-ENTRY OF br_table IN FRAME F-Main
DO:
  {src/adm2/brsentry.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table bTableWin
ON ROW-LEAVE OF br_table IN FRAME F-Main
DO:
  {src/adm2/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table bTableWin
ON START-SEARCH OF br_table IN FRAME F-Main
DO:
  RUN startSearch IN TARGET-PROCEDURE(SELF).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table bTableWin
ON VALUE-CHANGED OF br_table IN FRAME F-Main
DO:
  /* If this browser data source is on the same container and the data links are
     disabled - then enable them whilst we do the browse change code - to fix
     problems with header / detail windows with browsers on them, so subpages
     are always refreshed when move in browser.
     The datalinks to the sub SDO are usually disabled to prevent parent browser
     moving the data.
  */    
  DEFINE VARIABLE hvcDataSource           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hvcContainerSource      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hvcDataContainer        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hvlDataLinksEnabled     AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hvlDisable              AS LOGICAL    NO-UNDO.

  {get DataSource hvcDataSource}.                       /* browser datasource */
  ASSIGN hvlDisable = NO.

  {get DataLinksEnabled hvlDataLinksEnabled hvcDataSource}. 
  IF NOT hvlDataLinksEnabled THEN
  DO:
    {get ContainerSource hvcContainerSource}.             /* browsers container */
    {get ContainerSource hvcDataContainer hvcDataSource}. /* datasource container */
    IF hvcContainerSource = hvcDataContainer THEN
    DO:
      {set DataLinksEnabled YES hvcDataSource}.           /* Enable data links */ 
      ASSIGN hvlDisable = YES.
    END.
  END.

    {src/adm2/brschnge.i}

  IF hvlDisable THEN
  DO:
    {set DataLinksEnabled NO hvcDataSource}.
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK bTableWin 


/* ***************************  Main Block  *************************** */
&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN initializeObject.        
&ENDIF

DEFINE VARIABLE cEnabledFields   AS CHARACTER NO-UNDO.
DEFINE VARIABLE cDisplayedFields AS CHARACTER NO-UNDO.

ON VALUE-CHANGED OF BROWSE {&BROWSE-NAME} ANYWHERE 
DO:
  {get EnabledFields cEnabledFields}.
  IF cEnabledFields NE "":U THEN 
    APPLY 'U10':U TO THIS-PROCEDURE.
END.  /* END ON VALUE-CHANGED */

ON 'U10':U OF THIS-PROCEDURE 
DO:
  {get DisplayedFields cDisplayedFields}.
  /* Ignore the event if it wasn't a browse field. */
  IF LOOKUP(FOCUS:NAME, cDisplayedFields) NE 0 
  THEN DO:
    {get FieldsEnabled lResult}.
    IF lResult THEN                 /* Only if browse enabled for input. */
    DO:             
      {get DataModified lResult}.
      IF NOT lResult THEN           /* Don't send the event more than once. */
        {set DataModified yes}.
    END.  /* END DO IF lResult */
  END.    /* END DO IF LOOKUP */
END.      /* END ON U10 */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE childObjc bTableWin 
PROCEDURE childObjc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cFolderWindow AS CHARACTER NO-UNDO.
DEFINE VARIABLE hContainerSource AS HANDLE NO-UNDO.
DEFINE VARIABLE hFolderWindow AS HANDLE NO-UNDO.    
DEFINE VARIABLE hWindowHandle AS HANDLE NO-UNDO.
DEFINE VARIABLE hDataSource AS HANDLE NO-UNDO.
DEFINE VARIABLE hDataTarget AS HANDLE NO-UNDO.
DEFINE VARIABLE hNavigationSource AS HANDLE NO-UNDO.
DEFINE VARIABLE cProcedureType AS CHARACTER NO-UNDO.

    {get FolderWindowToLaunch cFolderWindow}.
    {get ContainerSource hContainerSource}.
    {get DataSource hDataSource}.
    {get ContainerHandle hWindowHandle hContainerSource}.

    RUN launchContainer IN gshSessionManager (                                                    
        INPUT "rycatobjcw",    /* pcObjectFileName  */
        INPUT "",               /* pcPhysicalName    */
        INPUT "",               /* pcLogicalName     */
        INPUT FALSE,            /* plOnceOnly        */
        INPUT "SdoForeignFields" + CHR(4) + "attribute_group_obj,attribute_group_obj",
        INPUT "",               /* pcChildDataKey    */
        INPUT "",               /* pcRunAttribute    */
        INPUT "",               /* pcContainerMode   */
        INPUT hWindowHandle,    /* phParentWindow    */
        INPUT hContainerSource, /* phParentProcedure */
        INPUT THIS-PROCEDURE,   /* phObjectProcedure */
        OUTPUT hFolderWindow,   /* phProcedureHandle */
        OUTPUT cProcedureType   /* pcProcedureType   */       
    ).

    PUBLISH "toggleData" FROM hFolderWindow (TRUE).

       /* the removal of these links is ok if multiple update sources can be supported by SDO's */ 

/*        RUN removeLink IN hContainerSource ( hDataSource , 'Data':U , hDataTarget ).     */
/*        RUN removeLink IN hContainerSource ( hFolderWindow , 'Update':U , hDataSource ). */

/*                                                                                    */
/*        RUN addLink IN hContainerSource (hDataSource, 'Data', hFolderWindow).       */
/*        RUN addLink IN hContainerSource (hFolderWindow, 'Navigation', hDataSource). */
/*                                                                                    */
/*        RUN initializeObject IN hFolderWindow.                                      */
/*                                                                                    */
/* MESSAGE "Removing Link".                                                           */
/*                                                                                    */
/*        RUN removeLink IN hContainerSource (hDataSource, 'Data', hFolderWindow).    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI bTableWin  _DEFAULT-DISABLE
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
  HIDE FRAME F-Main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject bTableWin 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RUN SUPER.

    BROWSE {&BROWSE-NAME}:EXPANDABLE = TRUE.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION notNull bTableWin 
FUNCTION notNull RETURNS CHARACTER
  ( pcValue AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN (IF pcValue = ? THEN "?" ELSE pcValue).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

