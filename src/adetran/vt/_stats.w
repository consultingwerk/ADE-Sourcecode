&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v7r11 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME WINDOW-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS WINDOW-1 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
Procedure:    adetran/vt/_stats.w
Author:       R. Ryan
Created:      1/95 
Updated:      9/95
		11/96 SLK Long FileName
			BGCOLOR
Purpose:      Visual Translator's Statistics tab procedure
Background:   This is a persistent procedure that is run from
              vt/_main.p *only* after a database is connected.
              Once connected, this procedure has the browser
              associated with the statistics functions. 
Notes:        Each time the statistics tab is selected, the
              underlying temp-table is re-populated with statistical
              information and the query is re-opened. Once useful
              statistics is the size of the kit database just in
              case it closes in on the 8mb DOS limit.
Procedures:   key procedures include:   
                Realize         enables the browse and opens the
                                query.
                GetByteSize     scans the size of the kit database.
                SetStatistics   deletes the temp-table then reads
                                various kit tables and sets the 
                                statistics.    
Called By:    vt/_main.p
*/
{ adetran/vt/vthlp.i } /* definitions for help context strings */  
define shared var MainWindow as widget-handle no-undo.
define shared var pFileName as Char no-undo.  
define shared var TotFrame  as integer no-undo. 
define shared var CurObj    as widget-handle no-undo.   
define shared var TotObject as integer no-undo. 
DEFINE SHARED VAR tModFlag  AS LOGICAL NO-UNDO. 

define shared var Priv1 as logical no-undo.
define shared var Priv2 as logical no-undo.
define shared var Priv3 as logical no-undo.
define variable ByteSize as decimal no-undo.    

DEFINE VARIABLE indentValue AS INTEGER NO-UNDO.

define temp-table Stats
  FIELD ItemIndent AS INTEGER
  field Item as char format "x(45)":u
  field ItemValue as char format "x(70)":u.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME StatsFrame
&Scoped-define BROWSE-NAME BROWSE-1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES Stats

/* Definitions for BROWSE BROWSE-1                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-1 Stats.Item Stats.ItemValue 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-1 
&Scoped-define OPEN-QUERY-BROWSE-1 OPEN QUERY BROWSE-1 FOR EACH kit.Stats NO-LOCK.
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-1 Stats
&Scoped-define TABLES-IN-QUERY-BROWSE-1 Stats

/* Definitions for FRAME StatsFrame                                     */
&Scoped-define OPEN-BROWSERS-IN-QUERY-StatsFrame ~
    ~{&OPEN-QUERY-BROWSE-1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BROWSE-1 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR WINDOW-1 AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */

/* Query definitions                                                    */
DEFINE QUERY BROWSE-1 FOR 
      Stats SCROLLING.

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-1 QUERY BROWSE-1 NO-LOCK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-1 WINDOW-1 _STRUCTURED
  DISPLAY
      Stats.Item width 42 FORMAT "x(45)"
      Stats.ItemValue width 70 FORMAT "x(255)"
  ENABLE
      Stats.ItemValue 
&ANALYZE-RESUME
    WITH NO-LABELS
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 86 BY 12
          &ELSE SIZE-PIXELS 602 BY 299 &ENDIF
         FONT 4
         TITLE "Statistics".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME StatsFrame
     BROWSE-1 AT Y 0 X 0
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT X 14 Y 52
         SIZE-PIXELS 602 BY 299
         FONT 4.

 

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: WINDOW
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* SUPPRESS Window definition (used by the UIB) 
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW WINDOW-1 ASSIGN
         HIDDEN             = YES
         TITLE              = "Window 1"
         COLUMN             = 7.86
         ROW                = 5.08
         HEIGHT             = 16.12
         WIDTH              = 90.57
         MAX-HEIGHT         = 16.12
         MAX-WIDTH          = 92.86
         VIRTUAL-HEIGHT     = 16.12
         VIRTUAL-WIDTH      = 92.86
         RESIZE             = yes
         SCROLL-BARS        = yes
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
                                                                        */
&ANALYZE-RESUME
ASSIGN WINDOW-1 = CURRENT-WINDOW.



/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW WINDOW-1
  VISIBLE,,RUN-PERSISTENT                                               */
ASSIGN 
       BROWSE-1:NUM-LOCKED-COLUMNS IN FRAME StatsFrame = 1.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-1
/* Query rebuild information for BROWSE BROWSE-1
     _TblList          = "Stats"
     _Options          = "NO-LOCK"
     _FldNameList[1]   > "_<CALC>"
"Stats.Item" ? ? ? ? ? ? ? ? ? no ?
     _FldNameList[2]   > "_<CALC>"
"Stats.ItemValue" ? ? ? ? ? ? ? ? ? no ?
     _Query            is OPENED
*/  /* BROWSE BROWSE-1 */
&ANALYZE-RESUME

/* ************************  Control Triggers  ************************ */

&Scoped-define BROWSE-NAME BROWSE-1

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK WINDOW-1 

ON HELP OF FRAME StatsFrame DO:
  RUN adecomm/_adehelp.p ("VT":U, "CONTEXT":U, {&VT_Statistics_Tab_Folder}, ?).
END.

ON ANY-KEY OF Stats.ItemValue IN BROWSE BROWSE-1
DO:
  IF NOT CAN-DO("CURSOR-*,END,HOME,TAB",KEYLABEL(LASTKEY)) THEN RETURN NO-APPLY.
END.
/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/*
** Note: all the close stuff has been excluded from processing
*/

{adetran/common/noscroll.i}

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

   find first kit.XL_Project no-lock no-error.
   if avail kit.XL_Project then
      assign Priv1 = kit.XL_Project.MustUseGlossary
             Priv2 = kit.XL_Project.SuperSedeGlossary
             Priv3 = kit.XL_Project.DeleteTranslations.

  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.
{adecomm/_adetool.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI WINDOW-1 _DEFAULT-DISABLE
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
  HIDE FRAME StatsFrame.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GetByteSize: WINDOW-1 
PROCEDURE GetByteSize : 
def var TestFileName as char no-undo.
   
  assign  
    TestFileName       = if num-entries(pdbname("kit":u),".":u) = 1 then
                         pdbname("kit":u) + ".db":u
                         else pdbname("kit":u)                               
    file-info:filename = TestFileName
    TestFileName       = file-info:full-pathname.
 
  if TestFileName = ? then do:
    ByteSize = 0.
    return.
  end.

  input from value(TestFileName).
  
  seek input to end.
  ByteSize = seek(input). 
  input close.    

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE HideMe WINDOW-1 
PROCEDURE HideMe :
frame StatsFrame:hidden = true.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenQuery WINDOW-1 
PROCEDURE OpenQuery :
open query browse-1 for each Stats no-lock.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Realize WINDOW-1 
PROCEDURE Realize :
  DEFINE VARIABLE ErrorStatus  AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE ThisMessage  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lNeedUpdate  AS LOGICAL   NO-UNDO INIT no.

  ENABLE ALL WITH FRAME StatsFrame IN WINDOW MainWindow.
  RUN ViewStats (INPUT NO).

  FIND FIRST stats WHERE TRIM(stats.item) = "Last Updated" NO-LOCK NO-ERROR.
  IF NOT AVAILABLE stats THEN
    lNeedUpdate = yes. 

  FIND FIRST kit.XL_Project NO-LOCK NO-ERROR.
  IF AVAILABLE Kit.XL_Project THEN DO:
    IF (NUM-ENTRIES(Kit.XL_Project.ProjectRevision,CHR(4)) > 1 AND
        ENTRY(2, Kit.XL_Project.ProjectRevision,CHR(4)) = "no":U) OR
       (NUM-ENTRIES(Kit.XL_Project.ProjectRevision,CHR(4)) > 2 AND
        ENTRY(3, Kit.XL_Project.ProjectRevision,CHR(4)) = "yes":U) OR
       tModFlag = yes THEN
      ASSIGN lNeedUpdate = yes.
  END.  /* If found project record */

  IF NOT lNeedUpdate THEN
    RUN SetStatistics (INPUT NO).  /* Just reopen the query */
  ELSE
  DO:
    ASSIGN
      ThisMessage =
        "Statistic data may not be current. If you have a large project, it may take some time to recalculate the data. Recalculate?".
    RUN adecomm/_s-alert.p (INPUT-OUTPUT ErrorStatus, "q":U, "ok-cancel":U, ThisMessage).
    IF ErrorStatus <> ? THEN
    DO:
      RUN adetran/vt/_recount.p (INPUT WINDOW-1).
      RUN adetran/vt/_proccnt.p.
      RUN SetStatistics (INPUT YES).
    END.
    ELSE
      RUN SetStatistics (INPUT NO).
    RUN OpenQuery.
  END.

  FRAME StatsFrame:HIDDEN = no.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetStatistics WINDOW-1 
PROCEDURE SetStatistics :
   DEFINE INPUT PARAMETER p-clear AS LOGICAL NO-UNDO.
   define variable tDec as dec no-undo. 
   define variable tInt as int no-undo.
    
   FIND FIRST stats NO-ERROR.
   IF NOT p-clear AND AVAILABLE stats THEN
   DO:
      RUN OpenQuery.
      RUN ViewStats (INPUT YES).
      RETURN.
   END. /* NOT p-clear */

   /* Clear out old statistics from the temp-table */
   for each Stats:
    delete Stats.
  end.  

  find first kit.XL_Project no-lock NO-ERROR.
  if available kit.XL_Project then do:
    run GetByteSize.  
    
    create stats. assign indentValue = 0
		         ItemIndent = indentValue
		         Item = FILL(" ":U,indentValue) + "Project Name"
                         ItemValue = kit.XL_Project.ProjectName.
                
    create stats. assign indentValue = 0
		         ItemIndent = indentValue
			 Item = FILL(" ":U,indentValue) + "Description"
                         ItemValue = kit.XL_Project.ProjectDesc.
               
    create stats. assign indentValue = 0
		         ItemIndent = indentValue
			 Item = FILL(" ":U,indentValue) + "Revision"
                         ItemValue = ENTRY(1, kit.XL_Project.ProjectRevision, CHR(4)). 
               
    create stats. assign indentValue = 0
		         ItemIndent = indentValue
			 Item = FILL(" ":U,indentValue) + "Create Date"
                         ItemValue = string(kit.XL_Project.CreateDate). 
               
    create stats. assign indentValue = 0
		         ItemIndent = indentValue
			 Item = FILL(" ":U,indentValue) + "Last Updated" 
                         ItemValue = string(kit.XL_Project.UpdateDate).
               
    create stats. assign indentValue = 0
		         ItemIndent = indentValue
			 Item = FILL(" ":U,indentValue) + "Database Size (in Bytes)"            
                         ItemValue = trim(string(ByteSize / 1000,">>>,>>>,>>9.9K":u)).

    create stats. assign indentValue = 0
		         ItemIndent = indentValue
			 Item = FILL(" ":U,indentValue) + "Display Type" 
                         ItemValue = if kit.XL_Project.DisplayType = "G":u 
                              then "Graphical":u
                              else "Character":u. 
                                                        
    create stats. assign indentValue = 0
		         ItemIndent = indentValue
			 Item = FILL(" ":U,indentValue) + "Number of Procedures"
                         ItemValue = string(kit.XL_Project.NumberOfProcedures).
               
    create stats. assign indentValue = 0
		         ItemIndent = indentValue
			 Item = FILL(" ":U,indentValue) + "Number of Phrases"
                         ItemValue = string(kit.XL_Project.NumberOfPhrases).
               
    create stats. assign indentValue = 0
		         ItemIndent = indentValue
	 		 Item = FILL(" ":U,indentValue) + "Number of Unique Phrases"
                         ItemValue = string(kit.XL_Project.NumberOfUniquePhrases).
               
    create stats. assign indentValue = 0
		         ItemIndent = indentValue
			 Item = FILL(" ":U,indentValue) + "Number of Words" 
                         ItemValue = string(kit.XL_Project.NumberOfWords). 
               
    create stats. assign indentValue = 0
		         ItemIndent = indentValue
			 Item = FILL(" ":U,indentValue) + "Number of Unique Words"
                         ItemValue = string(kit.XL_Project.NumberOfUniqueWords).  
                  
    create stats. assign indentValue = 0
		         ItemIndent = indentValue
			 Item = FILL(" ":U,indentValue) + "Current Procedure"
                         ItemValue = if pFileName = "" then "None" 
                         else pFileName.                
                          
    create stats. assign indentValue = 0
		         ItemIndent = indentValue
			 Item = FILL(" ":U,indentValue) + "Current Object"
                         ItemValue = if can-query(CurObj,"name":u) then CurObj:name
                                     else "None".
                                     
    create stats. assign indentValue = 0
		         ItemIndent = indentValue
			 Item = FILL(" ":U,indentValue) + "Number of Frames"
                         ItemValue = string(TotFrame,">>9":u). 
    
    create stats. assign indentValue = 0
		         ItemIndent = indentValue
			 Item = FILL(" ":U,indentValue) + "Number of Objects"
                         ItemValue = string(TotObject,">>9":u).
                         
    tDec = kit.XL_Project.TranslationCount / kit.XL_Project.NumberOfPhrases.
    tInt = tDec * 100.               
                         
    create stats. assign indentValue = 0
		         ItemIndent = indentValue
			Item    = FILL(" ":U,indentValue) + "% Translated"        
                         ItemValue = string(tInt) + "%":u. 
                         
    create stats. assign indentValue = 0
		         ItemIndent = indentValue
			 Item    = FILL(" ":U,indentValue) + "# Items In Glossary"        
                         ItemValue = string(kit.XL_Project.GlossaryCount).                      
  end. 

  run OpenQuery. 
  RUN ViewStats (INPUT YES).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ViewStats WINDOW-1 
PROCEDURE ViewStats:
  DEFINE INPUT PARAMETER plView AS LOGICAL NO-UNDO.  /* View statistics? */

  Browse-1:HIDDEN IN FRAME Statsframe = NOT plView.  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE print_statistics WINDOW-1 
PROCEDURE print_statistics:
  {adetran/common/pr_stats.i "kit.XL_Project.ProjectName"}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
