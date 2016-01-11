/*********************************************************************
* Copyright (C) 2006 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*
    File        : compvars.i
    Syntax      : { adecomp/compvars.i [ "NEW" ] }
                  Note: [] means optional.

    Description : Progress Application Compiler Tool SHARED VARs.
 
    Author      : John Palazzo
    Date Created: 03/24/92
    Date Updated: May, 2000 9.1B

		fernando  07/28/2006 Support for XREF-XML
*/

&GLOBAL-DEFINE COMP_NAME "Application Compiler"

/* MinVersion is definded temporarily in order to global-def CompileOn91C */
&SCOPED-DEFINE MinVersion "9.1C"
&GLOBAL-DEFINE CompileOn91C~
    DECIMAL(SUBSTRING(PROVERSION,1,R-INDEX(PROVERSION,".":U) + 1)) >~
    DECIMAL(SUBSTRING({&MinVersion},1,R-INDEX({&MinVersion},".":U) + 1))~
    OR~
   (DECIMAL(SUBSTRING(PROVERSION,1,R-INDEX(PROVERSION,".":U) + 1)) =~
    DECIMAL(SUBSTRING({&MinVersion},1,R-INDEX({&MinVersion},".":U) + 1))~
    AND~
    SUBSTRING(PROVERSION,R-INDEX(PROVERSION,".":U) + 1,2) >=~
    SUBSTRING({&MinVersion},R-INDEX({&MinVersion},".":U) + 1,2))
&UNDEFINE MinVersion

/* Default ("Factory") settings for Compiler Options. */
&GLOBAL-DEFINE def_fspecSaved  "*.p *.w *.cls"
&GLOBAL-DEFINE def_logfile     "compile.log"
&GLOBAL-DEFINE def_saveinto    ""
&GLOBAL-DEFINE def_languages   ""
&GLOBAL-DEFINE def_v6frame     "No"
&GLOBAL-DEFINE def_stream_io   NO
&GLOBAL-DEFINE def_listing     ""
&GLOBAL-DEFINE def_lappend     NO
&GLOBAL-DEFINE def_lpwid       80
&GLOBAL-DEFINE def_lplen       60
&GLOBAL-DEFINE def_xref        ""
&GLOBAL-DEFINE def_xappend     NO
&GLOBAL-DEFINE def_debuglist   ""
&GLOBAL-DEFINE def_encrkey     ""
&GLOBAL-DEFINE def_minsize     NO
&GLOBAL-DEFINE def_gen_md5     NO
&GLOBAL-DEFINE def_xrefxml     NO


&GLOBAL-DEFINE LABEL_XREF "&Xref File"

DEFINE {1} SHARED VAR s_propathdir AS CHAR NO-UNDO. /* dir to compile in */
DEFINE {1} SHARED VAR s_fspecSaved AS CHAR NO-UNDO  /* file spec to compile */
  FORMAT "x(75)" VIEW-AS FILL-IN SIZE 42 BY 1 LABEL "Default &File Spec." INIT {&def_fspecSaved}.
DEFINE {1} SHARED VAR s_fspec     AS CHAR NO-UNDO  /* file spec to compile */
  FORMAT "x(75)".
DEFINE {1} SHARED VAR s_Show_Status   AS LOGICAL NO-UNDO INIT YES.
DEFINE {1} SHARED VAR s_Save_Settings AS LOGICAL NO-UNDO INIT NO.

DEFINE {1} SHARED VAR s_saver     AS log NO-UNDO INIT YES
  view-as toggle-box SIZE 25 BY 1 LABEL "Sa&ve New .r Files".
DEFINE {1} SHARED VAR s_subdirs   AS log NO-UNDO INIT YES
  view-as toggle-box SIZE 31 BY 1 LABEL "&Look in Subdirectories".
DEFINE {1} SHARED VAR s_rmoldr    AS log NO-UNDO INIT YES
  view-as toggle-box SIZE 27 BY 1 LABEL "&Remove Old .r Files".
DEFINE {1} SHARED VAR s_ifnor     AS log NO-UNDO INIT NO
  view-as toggle-box SIZE 34 BY 1 LABEL "Only Compile if &No .r File".
DEFINE {1} SHARED VAR s_oldonly   AS log NO-UNDO INIT NO
  view-as toggle-box SIZE 33 BY 1 LABEL "Compile &Old .r Files Only".


DEFINE {1} SHARED VAR s_logfile   AS char NO-UNDO /* name of status out file */
  FORMAT "x(60)" VIEW-AS FILL-IN SIZE 42 BY 1 INIT {&def_logfile} LABEL "  &Message Log File".
DEFINE {1} SHARED VAR s_saveinto  AS char NO-UNDO  /* directory to save into */
  FORMAT "x(60)" VIEW-AS FILL-IN SIZE 42 BY 1 LABEL "&Save into".
DEFINE {1} SHARED VAR s_languages AS char NO-UNDO  /* comma list of languages */
  FORMAT "x(60)" VIEW-AS FILL-IN SIZE 42 BY 1 LABEL "&Languages".
DEFINE {1} SHARED VAR s_V6Frame AS Character NO-UNDO /* Use V6Frame when compiling */
  FORMAT "X(20)" INITIAL {&def_v6frame} LABEL "&V6Frame" 
  VIEW-AS COMBO-BOX SIZE 20 BY 1 INNER-LINES 4
  LIST-ITEMS "No","Box","Reverse Video","Underline".
DEFINE {1} SHARED VAR s_stream_io AS log NO-UNDO   /* Use STREAM-IO when compiling */
  FORMAT "Yes/No" LABEL "Strea&m-IO" INITIAL {&def_stream_io}.
DEFINE {1} SHARED VAR s_listing   AS char NO-UNDO  /* listing file */
  FORMAT "x(60)" VIEW-AS FILL-IN SIZE 31 BY 1 LABEL "L&isting File".
DEFINE {1} SHARED VAR s_lpwid    AS int NO-UNDO    /* listing page width */
  init {&def_lpwid} LABEL "Page &Width" format ">>9".
DEFINE {1} SHARED VAR s_lplen    AS int NO-UNDO    /* listing page length */
  init {&def_lplen} LABEL "L&ength" format ">>9".
  
DEFINE {1} SHARED VAR s_xref      AS char NO-UNDO  /* xref file name */
  FORMAT "x(60)" VIEW-AS FILL-IN SIZE 31 BY 1 LABEL {&LABEL_XREF}.

DEFINE {1} SHARED VAR s_xrefxml   AS log NO-UNDO  /* xref xml file */
  view-as toggle-box init {&def_xrefxml} LABEL "XML Fo&rmat".
DEFINE {1} SHARED VAR s_lappend   AS log NO-UNDO
  view-as toggle-box  /* listing append? */
  init {&def_lappend} LABEL "&Append".
DEFINE {1} SHARED VAR s_xappend   AS log NO-UNDO  /* xref file append? */
  view-as toggle-box init {&def_xappend} LABEL "&Append".
DEFINE {1} SHARED VAR s_debuglist AS char NO-UNDO
  FORMAT "x(60)" VIEW-AS FILL-IN SIZE 31 BY 1 LABEL "De&bug File".
DEFINE {1} SHARED VAR s_encrkey   AS char NO-UNDO  /* encryption key */
  FORMAT "x(60)" VIEW-AS FILL-IN SIZE 31 BY 1 LABEL "Encryption &Key" .
DEFINE {1} SHARED VAR s_minsize   AS log NO-UNDO
  FORMAT "Yes/No" LABEL "Minimize R-code Si&ze" INITIAL {&def_minsize}.
DEFINE {1} SHARED VAR s_gen_md5   AS LOG NO-UNDO
  FORMAT "Yes/No" LABEL "Generate M&D-5" INITIAL {&def_gen_md5}.

DEFINE {1} SHARED VAR s_CompCount AS INT NO-UNDO.
DEFINE {1} SHARED VAR s_Appl_Title AS CHAR INIT "Application Compiler"
    NO-UNDO.
/*
** The following frame is used to interactivley show results of the compile
** when _compile.p is running.  If you are calling _compile.p directly and
** you want on screen feedback, just view the frame and enable the 
** editor.  If you want the user to be able to cancel the compile, enable
** b_CompileCancel.  b_ViewOK is to be used by the caller when _compile.p
** is done.
*/

DEFINE {1} SHARED FRAME EditorDisplay.

DEFINE VAR Get_License AS INTEGER NO-UNDO.
DEFINE VAR v_EditorOut as char view-as editor size 75 by 9 LARGE
  SCROLLBAR-VERTICAL PFCOLOR 0 .

DEFINE BUTTON b_ViewOK        LABEL "OK"      {&STDPH_OKBTN} AUTO-GO.
DEFINE BUTTON b_CompileCancel LABEL "Cancel"  {&STDPH_OKBTN}.
DEFINE BUTTON b_CompileHelp   LABEL "&Help"   {&STDPH_OKBTN}.

DEFINE RECTANGLE s_rct_bottom                 {&STDPH_OKBOX}.

FORMAT
  SKIP({&TFM_WID}) SPACE({&HFM_WID})
  v_EditorOut SKIP
  { adecomm/okform.i 
         &BOX="s_rct_bottom" 
         &OK="b_ViewOK" 
         &CANCEL="b_CompileCancel"
         &HELP="b_CompileHelp"
   }
  WITH FRAME EditorDisplay CENTERED TITLE "Compiler Results"
       NO-LABELS OVERLAY VIEW-AS DIALOG-BOX DEFAULT-BUTTON b_ViewOK.
