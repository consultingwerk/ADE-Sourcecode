&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWin 
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
/*------------------------------------------------------------------------

  File:               protools/waspartn.w

  Description:        Service Partition Maintenance Tool.
                      This is a container window for the objects required
                      to maintain the partitions in appserv-TT.

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Notes:

  Created:            May 9, 2000 - Bruce Gruenbaum
          
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AB.              */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE lTblChanged AS LOGICAL INITIAL NO NO-UNDO.

DEFINE VARIABLE lSave AS LOGICAL INITIAL YES    NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME fMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-5 btn_Close btn_Help 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_asbrowser AS HANDLE NO-UNDO.
DEFINE VARIABLE h_dappsrv AS HANDLE NO-UNDO.
DEFINE VARIABLE h_djmssrv AS HANDLE NO-UNDO.
DEFINE VARIABLE h_dyntoolbar AS HANDLE NO-UNDO.
DEFINE VARIABLE h_folder AS HANDLE NO-UNDO.
DEFINE VARIABLE h_jmsbrowser AS HANDLE NO-UNDO.
DEFINE VARIABLE h_vappsrv AS HANDLE NO-UNDO.
DEFINE VARIABLE h_vjmssrv AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btn_Close DEFAULT 
     LABEL "&Close" 
     SIZE 15 BY 1.14.

DEFINE BUTTON btn_Help 
     LABEL "&Help" 
     SIZE 15 BY 1.14.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 81 BY 1.67.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     btn_Close AT ROW 25.05 COL 2
     btn_Help AT ROW 25.05 COL 66
     RECT-5 AT ROW 24.81 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 81 BY 25.67
         DEFAULT-BUTTON btn_Close.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source
   Design Page: 1
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWin ASSIGN
         HIDDEN             = YES
         TITLE              = "Service Parameter Maintenance"
         HEIGHT             = 25.67
         WIDTH              = 81
         MAX-HEIGHT         = 28.81
         MAX-WIDTH          = 146.2
         VIRTUAL-HEIGHT     = 28.81
         VIRTUAL-WIDTH      = 146.2
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWin 
/* ************************* Included-Libraries *********************** */

{adecomm/appserv.i}
{src/adm2/containr.i}
{protools/ptlshlp.i}
{adecomm/_adetool.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWin
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME fMain
                                                                        */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* Service Parameter Maintenance */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* Service Parameter Maintenance */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn_Close
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn_Close wWin
ON CHOOSE OF btn_Close IN FRAME fMain /* Close */
DO:
  lSave = YES.
  APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn_Help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn_Help wWin
ON CHOOSE OF btn_Help IN FRAME fMain /* Help */
DO:
  /* Call the help function. */
  RUN adecomm/_adehelp.p ("ptls":U,"CONTEXT":U, {&AppServer_Partition}, ?).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWin 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm2/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects wWin  _ADM-CREATE-OBJECTS
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
             INPUT  'adm2/dyntoolbar.w':U ,
             INPUT  FRAME fMain:HANDLE ,
             INPUT  'EdgePixels2DeactivateTargetOnHidenoDisabledActionsFlatButtonsyesMenuyesShowBorderyesToolbaryesActionGroupsTableio,NavigationTableIOTypeSaveSupportedLinksNavigation-Source,TableIo-SourceToolbarBandsToolbarAutoSizenoToolbarDrawDirectionhorizontalLogicalObjectNameAutoResizeDisabledActionsHiddenActionsUpdateHiddenToolbarBandsHiddenMenuBandsMenuMergeOrder0RemoveMenuOnHidenoCreateSubMenuOnConflictyesNavigationTargetNameHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_dyntoolbar ).
       RUN repositionObject IN h_dyntoolbar ( 1.00 , 1.00 ) NO-ERROR.
       RUN resizeObject IN h_dyntoolbar ( 1.33 , 81.00 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/folder.w':U ,
             INPUT  FRAME fMain:HANDLE ,
             INPUT  'FolderLabels':U + 'AppServers|JMS Servers' + 'FolderTabWidth0FolderFont-1HideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_folder ).
       RUN repositionObject IN h_folder ( 2.67 , 1.00 ) NO-ERROR.
       RUN resizeObject IN h_folder ( 21.91 , 81.00 ) NO-ERROR.

       /* Links to SmartFolder h_folder. */
       RUN addLink ( h_folder , 'Page':U , THIS-PROCEDURE ).

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( h_dyntoolbar ,
             btn_Close:HANDLE IN FRAME fMain , 'BEFORE':U ).
       RUN adjustTabOrder ( h_folder ,
             h_dyntoolbar , 'AFTER':U ).
    END. /* Page 0 */
    WHEN 1 THEN DO:
       RUN constructObject (
             INPUT  'protools/dappsrv.wDB-AWARE':U ,
             INPUT  FRAME fMain:HANDLE ,
             INPUT  'AppServiceASUsePromptASInfoForeignFieldsRowsToBatch200CheckCurrentChangedyesRebuildOnReposnoServerOperatingModeNONEDestroyStatelessnoDisconnectAppServernoObjectNamedappsrvUpdateFromSourcenoToggleDataTargetsyesOpenOnInityesPromptOnDeleteyesPromptColumns(NONE)':U ,
             OUTPUT h_dappsrv ).
       RUN repositionObject IN h_dappsrv ( 4.10 , 4.00 ) NO-ERROR.
       /* Size in AB:  ( 1.86 , 10.80 ) */

       RUN constructObject (
             INPUT  'adm2/dynbrowser.w':U ,
             INPUT  FRAME fMain:HANDLE ,
             INPUT  'DisplayedFieldsPartitionEnabledFieldsScrollRemotenoNumDown0CalcWidthnoMaxWidth80FetchOnReposToEndyesSearchFieldDataSourceNamesUpdateTargetNamesLogicalObjectNameHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_asbrowser ).
       RUN repositionObject IN h_asbrowser ( 4.10 , 7.00 ) NO-ERROR.
       RUN resizeObject IN h_asbrowser ( 5.00 , 68.00 ) NO-ERROR.

       RUN constructObject (
             INPUT  'protools/vappsrv.w':U ,
             INPUT  FRAME fMain:HANDLE ,
             INPUT  'EnabledObjFldsToDisableModifyFields(All)DataSourceNamesUpdateTargetNamesLogicalObjectNameLogicalObjectNamePhysicalObjectNameDynamicObjectnoRunAttributeHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_vappsrv ).
       RUN repositionObject IN h_vappsrv ( 9.29 , 7.00 ) NO-ERROR.
       /* Size in AB:  ( 15.10 , 68.00 ) */

       /* Links to SmartDataObject h_dappsrv. */
       RUN addLink ( h_dyntoolbar , 'Navigation':U , h_dappsrv ).
       RUN addLink ( h_dappsrv , 'tableChanged':U , THIS-PROCEDURE ).

       /* Links to SmartDataBrowser h_asbrowser. */
       RUN addLink ( h_dappsrv , 'Data':U , h_asbrowser ).

       /* Links to SmartDataViewer h_vappsrv. */
       RUN addLink ( h_dappsrv , 'Data':U , h_vappsrv ).
       RUN addLink ( h_vappsrv , 'Update':U , h_dappsrv ).
       RUN addLink ( h_dyntoolbar , 'TableIo':U , h_vappsrv ).

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( h_dyntoolbar ,
             btn_Close:HANDLE IN FRAME fMain , 'BEFORE':U ).
       RUN adjustTabOrder ( h_folder ,
             h_dyntoolbar , 'AFTER':U ).
       RUN adjustTabOrder ( h_asbrowser ,
             h_folder , 'AFTER':U ).
       RUN adjustTabOrder ( h_vappsrv ,
             h_asbrowser , 'AFTER':U ).
    END. /* Page 1 */
    WHEN 2 THEN DO:
       RUN constructObject (
             INPUT  'protools/dappsrv.wDB-AWARE':U ,
             INPUT  FRAME fMain:HANDLE ,
             INPUT  'AppServiceASUsePromptASInfoForeignFieldsRowsToBatch200CheckCurrentChangedyesRebuildOnReposnoServerOperatingModeNONEDestroyStatelessnoDisconnectAppServernoObjectNamedappsrvUpdateFromSourcenoToggleDataTargetsyesOpenOnInityesPromptOnDeleteyesPromptColumns(NONE)':U ,
             OUTPUT h_djmssrv ).
       RUN repositionObject IN h_djmssrv ( 4.57 , 8.00 ) NO-ERROR.
       /* Size in AB:  ( 1.86 , 10.80 ) */

       RUN constructObject (
             INPUT  'adm2/dynbrowser.w':U ,
             INPUT  FRAME fMain:HANDLE ,
             INPUT  'DisplayedFieldsPartitionEnabledFieldsScrollRemotenoNumDown0CalcWidthnoMaxWidth80FetchOnReposToEndyesSearchFieldDataSourceNamesUpdateTargetNamesLogicalObjectNameHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_jmsbrowser ).
       RUN repositionObject IN h_jmsbrowser ( 4.57 , 5.00 ) NO-ERROR.
       RUN resizeObject IN h_jmsbrowser ( 6.67 , 72.00 ) NO-ERROR.

       RUN constructObject (
             INPUT  'protools/vjmssrv.w':U ,
             INPUT  FRAME fMain:HANDLE ,
             INPUT  'EnabledObjFldsToDisableModifyFields(All)DataSourceNamesUpdateTargetNamesLogicalObjectNameLogicalObjectNamePhysicalObjectNameDynamicObjectnoRunAttributeHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_vjmssrv ).
       RUN repositionObject IN h_vjmssrv ( 11.71 , 5.00 ) NO-ERROR.
       /* Size in AB:  ( 7.62 , 73.00 ) */

       /* Links to SmartDataObject h_djmssrv. */
       RUN addLink ( h_dyntoolbar , 'Navigation':U , h_djmssrv ).
       RUN addLink ( h_djmssrv , 'tableChanged':U , THIS-PROCEDURE ).

       /* Links to SmartDataBrowser h_jmsbrowser. */
       RUN addLink ( h_djmssrv , 'Data':U , h_jmsbrowser ).

       /* Links to SmartDataViewer h_vjmssrv. */
       RUN addLink ( h_djmssrv , 'Data':U , h_vjmssrv ).
       RUN addLink ( h_vjmssrv , 'Update':U , h_djmssrv ).
       RUN addLink ( h_dyntoolbar , 'TableIO':U , h_vjmssrv ).

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( h_dyntoolbar ,
             btn_Close:HANDLE IN FRAME fMain , 'BEFORE':U ).
       RUN adjustTabOrder ( h_folder ,
             h_dyntoolbar , 'AFTER':U ).
       RUN adjustTabOrder ( h_jmsbrowser ,
             h_folder , 'AFTER':U ).
       RUN adjustTabOrder ( h_vjmssrv ,
             h_jmsbrowser , 'AFTER':U ).
    END. /* Page 2 */

  END CASE.
  /* Select a Startup page. */
  IF currentPage eq 0
  THEN RUN selectPage IN THIS-PROCEDURE ( 1 ).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createObjects wWin 
PROCEDURE createObjects :
/*------------------------------------------------------------------------------
  Purpose:     Super Override - Sets up the SDOs for their partition type
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  RUN SUPER.
  
  /* For each of the SDOs, if they have been instantiated, set the PartitionType
     property so that the appropriate records are read for appserv-tt */
  IF VALID-HANDLE(h_dappsrv) THEN
    DYNAMIC-FUNCTION('setUserProperty':U IN h_dappsrv,
                     INPUT "PartitionType":U,
                     INPUT "A":U).  /* AppServer SDO - "A" */


  IF VALID-HANDLE(h_djmssrv) THEN
    DYNAMIC-FUNCTION('setUserProperty':U IN h_djmssrv,
                     INPUT "PartitionType":U,
                     INPUT "J":U). /* JMS SDO - "J" */


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyObject wWin 
PROCEDURE destroyObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  RUN SUPER.

  /* Save the changes to the temp tables away */
  IF lSave THEN
    RUN saveAppSrvTT.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI wWin  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
  THEN DELETE WIDGET wWin.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI wWin  _DEFAULT-ENABLE
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
  ENABLE RECT-5 btn_Close btn_Help 
      WITH FRAME fMain IN WINDOW wWin.
  {&OPEN-BROWSERS-IN-QUERY-fMain}
  VIEW wWin.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE exitObject wWin 
PROCEDURE exitObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  APPLY "CLOSE":U TO THIS-PROCEDURE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveAppSrvtt wWin 
PROCEDURE saveAppSrvtt :
/*------------------------------------------------------------------------------
  Purpose:     Allows the user to save the changes from the appsrv-tt temp-table
               to the appsrvtt.d file.

  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE lAns AS LOGICAL    NO-UNDO.

  /* If the lTblChanged variable has been set, the contents have been written
     to appsrvtt.d */
  IF lTblChanged THEN /* The contents of appsrv-tt have changed. */
    MESSAGE "The partition setup has been changed only for this session." SKIP
            "Do you want to save these partition setups permanently" SKIP
            "for future sessions?"
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO SET lAns.
  IF lAns THEN 
    RUN savePartitionInfo IN appSrvUtils.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE tableChanged wWin 
PROCEDURE tableChanged :
/*------------------------------------------------------------------------------
  Purpose:     Sets the tableChanged flag. 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  lTblChanged = YES.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

