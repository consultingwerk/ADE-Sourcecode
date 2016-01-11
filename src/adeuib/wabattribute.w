&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
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

  File: 

  Description: from cntnrwin.w - ADM SmartWindow Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  History: New V9 Version - January 15, 1998
          
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
&Scoped-Define ENABLED-OBJECTS btnReSeq btnGenCode 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_dabattribute AS HANDLE NO-UNDO.
DEFINE VARIABLE h_dynbrowser AS HANDLE NO-UNDO.
DEFINE VARIABLE h_dyntoolbar AS HANDLE NO-UNDO.
DEFINE VARIABLE h_folder AS HANDLE NO-UNDO.
DEFINE VARIABLE h_vabattraction AS HANDLE NO-UNDO.
DEFINE VARIABLE h_vabattribute AS HANDLE NO-UNDO.
DEFINE VARIABLE h_vabattrwidg AS HANDLE NO-UNDO.
DEFINE VARIABLE h_wabattrgencode AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btnGenCode 
     LABEL "&Generate Code..." 
     SIZE 22 BY 1.14.

DEFINE BUTTON btnReSeq 
     LABEL "&Re-sequence" 
     SIZE 22 BY 1.14.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     btnReSeq AT ROW 26.95 COL 26
     btnGenCode AT ROW 26.95 COL 69
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 124.8 BY 27.38.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source
   Design Page: 3
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWin ASSIGN
         HIDDEN             = YES
         TITLE              = "Property Sheet Attributes"
         HEIGHT             = 27.38
         WIDTH              = 124.8
         MAX-HEIGHT         = 34
         MAX-WIDTH          = 204.8
         VIRTUAL-HEIGHT     = 34
         VIRTUAL-WIDTH      = 204.8
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

{src/adm2/containr.i}

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
ON END-ERROR OF wWin /* Property Sheet Attributes */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* Property Sheet Attributes */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnGenCode
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnGenCode wWin
ON CHOOSE OF btnGenCode IN FRAME fMain /* Generate Code... */
DO:

  DEFINE VARIABLE pioCancel AS LOGICAL              NO-UNDO.

  RUN confirmContinue IN h_dabattribute
    ( INPUT-OUTPUT pioCancel /* LOGICAL */).

  IF NOT pioCancel THEN 
    RUN viewPage ( INPUT 4 /* INTEGER */).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnReSeq
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnReSeq wWin
ON CHOOSE OF btnReSeq IN FRAME fMain /* Re-sequence */
DO:
  DEFINE VARIABLE iSeq      AS INTEGER INITIAL 1000 NO-UNDO.
  DEFINE VARIABLE iDispSeq  AS INTEGER              NO-UNDO. 
  DEFINE VARIABLE pioCancel AS LOGICAL              NO-UNDO.

  RUN confirmContinue IN h_dabattribute
    ( INPUT-OUTPUT pioCancel /* LOGICAL */).

  IF NOT pioCancel THEN DO:
    
    /* Re-sequence abAttribute.sq */
    FOR EACH abAttribute BY NOT multiLayout BY NAME:
      ASSIGN iSeq = iSeq + 1
             abAttribute.sq = iSeq.
    END.  /* for each abAttribute */

    iSeq = 0.

    FOR EACH abAttribute BY NOT multiLayout BY NAME:
      ASSIGN iSeq = iSeq + 1
             abAttribute.sq = iSeq.
    END.  /* for each abAttribute */

    /* Re-sequence abAttribute.displaySeq */
    FOR EACH abAttribute BY displaySeq:
      iDispSeq = iDispSeq + 5.
      abAttribute.displaySeq = iDispSeq.
    END.  /* for each abAttribute */

    /* Re-open the SDO query */
    DYNAMIC-FUNCTION('openQuery':U IN h_dabattribute).
  END.  /* if not pioCancel */
  
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
             INPUT  'adeuib/dabattribute.wDB-AWARE':U ,
             INPUT  FRAME fMain:HANDLE ,
             INPUT  'AppServiceASUsePromptASInfoForeignFieldsRowsToBatch200CheckCurrentChangedyesRebuildOnReposnoServerOperatingModeNONEDestroyStatelessnoDisconnectAppServernoObjectNamedabattribute':U ,
             OUTPUT h_dabattribute ).
       RUN repositionObject IN h_dabattribute ( 1.00 , 101.00 ) NO-ERROR.
       /* Size in AB:  ( 1.86 , 10.80 ) */

       RUN constructObject (
             INPUT  'adm2/dynbrowser.w':U ,
             INPUT  FRAME fMain:HANDLE ,
             INPUT  'DisplayedFieldsname,custom,displaySeq,class,chrDataEnabledFieldsSearchFieldNumDown10CalcWidthnoMaxWidth80HideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_dynbrowser ).
       RUN repositionObject IN h_dynbrowser ( 2.67 , 5.00 ) NO-ERROR.
       RUN resizeObject IN h_dynbrowser ( 6.67 , 116.00 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dyntoolbar.w':U ,
             INPUT  FRAME fMain:HANDLE ,
             INPUT  'FlatButtonsyesMenuyesShowBorderyesToolbaryesActionGroupsTableio,NavigationSubModulesTableIOTypeSaveSupportedLinksNavigation-Source,TableIo-SourceEdgePixels2PanelTypeToolbarNavigationTargetNameHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_dyntoolbar ).
       RUN repositionObject IN h_dyntoolbar ( 1.00 , 1.00 ) NO-ERROR.
       RUN resizeObject IN h_dyntoolbar ( 1.33 , 124.80 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/folder.w':U ,
             INPUT  FRAME fMain:HANDLE ,
             INPUT  'FolderLabels':U + 'Default|Widgets|Actions' + 'FolderTabWidth0FolderFont-1HideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_folder ).
       RUN repositionObject IN h_folder ( 12.67 , 5.00 ) NO-ERROR.
       RUN resizeObject IN h_folder ( 13.81 , 116.00 ) NO-ERROR.

       /* Links to SmartDataObject h_dabattribute. */
       RUN addLink ( h_dyntoolbar , 'Navigation':U , h_dabattribute ).

       /* Links to SmartDataBrowser h_dynbrowser. */
       RUN addLink ( h_dabattribute , 'Data':U , h_dynbrowser ).

       /* Links to SmartFolder h_folder. */
       RUN addLink ( h_folder , 'Page':U , THIS-PROCEDURE ).

    END. /* Page 0 */

    WHEN 1 THEN DO:
       RUN constructObject (
             INPUT  'adeuib/vabattribute.w':U ,
             INPUT  FRAME fMain:HANDLE ,
             INPUT  'HideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_vabattribute ).
       RUN repositionObject IN h_vabattribute ( 14.57 , 15.00 ) NO-ERROR.
       /* Size in AB:  ( 11.10 , 94.00 ) */

       /* Links to SmartDataViewer h_vabattribute. */
       RUN addLink ( h_dabattribute , 'Data':U , h_vabattribute ).
       RUN addLink ( h_vabattribute , 'Update':U , h_dabattribute ).
       RUN addLink ( h_dyntoolbar , 'TableIo':U , h_vabattribute ).

    END. /* Page 1 */

    WHEN 2 THEN DO:
       RUN constructObject (
             INPUT  'adeuib/vabattrwidg.w':U ,
             INPUT  FRAME fMain:HANDLE ,
             INPUT  'HideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_vabattrwidg ).
       RUN repositionObject IN h_vabattrwidg ( 14.33 , 16.00 ) NO-ERROR.
       /* Size in AB:  ( 7.86 , 84.00 ) */

       /* Initialize other pages that this page requires. */
       RUN initPages ('1') NO-ERROR.

       /* Links to SmartDataViewer h_vabattrwidg. */
       RUN addLink ( h_dabattribute , 'Data':U , h_vabattrwidg ).
       RUN addLink ( h_vabattribute , 'GroupAssign':U , h_vabattrwidg ).

    END. /* Page 2 */

    WHEN 3 THEN DO:
       RUN constructObject (
             INPUT  'adeuib/vabattraction.w':U ,
             INPUT  FRAME fMain:HANDLE ,
             INPUT  'HideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_vabattraction ).
       RUN repositionObject IN h_vabattraction ( 14.57 , 11.00 ) NO-ERROR.
       /* Size in AB:  ( 11.62 , 86.00 ) */

       /* Initialize other pages that this page requires. */
       RUN initPages ('1') NO-ERROR.

       /* Links to SmartDataViewer h_vabattraction. */
       RUN addLink ( h_dabattribute , 'Data':U , h_vabattraction ).
       RUN addLink ( h_vabattribute , 'GroupAssign':U , h_vabattraction ).

    END. /* Page 3 */

    WHEN 4 THEN DO:
       RUN constructObject (
             INPUT  'adeuib/wabattrgencode.w':U ,
             INPUT  {&WINDOW-NAME} ,
             INPUT  'HideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_wabattrgencode ).
       /* Position in AB:  ( 26.95 , 104.00 ) */
       /* Size in AB:  ( 1.86 , 10.80 ) */

       /* Adjust the tab order of the smart objects. */
    END. /* Page 4 */

  END CASE.
  /* Select a Startup page. */
  IF currentPage eq 0
  THEN RUN selectPage IN THIS-PROCEDURE ( 1 ).

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
  ENABLE btnReSeq btnGenCode 
      WITH FRAME fMain IN WINDOW wWin.
  {&OPEN-BROWSERS-IN-QUERY-fMain}
  VIEW wWin.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE exitObject wWin 
PROCEDURE exitObject :
/*------------------------------------------------------------------------------
  Purpose:  Window-specific override of this procedure which destroys 
            its contents and itself.
    Notes:  
------------------------------------------------------------------------------*/

  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

