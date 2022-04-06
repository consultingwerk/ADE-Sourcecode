/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*--------------------------------------------------------------------------
  dsearch.i
  Search  Defines for Editor 
  
  p_Buffer  WIDGET-HANDLE to edit buffer to operate on.
--------------------------------------------------------------------------*/

/* Tool should set these to their tool name to adhere to 
   application style standards. 
*/
DEFINE VARIABLE Search_Info_Title  AS CHAR INIT "Information" NO-UNDO.
DEFINE VARIABLE Search_Quest_Title AS CHAR INIT "Question?"   NO-UNDO.

DEFINE VARIABLE Find_Flags       AS INTEGER NO-UNDO.
DEFINE VARIABLE Find_Criteria    AS INTEGER NO-UNDO.
DEFINE VARIABLE Find_Command     AS INTEGER NO-UNDO.
DEFINE VARIABLE Replace_Flags    AS INTEGER NO-UNDO.
DEFINE VARIABLE Replace_Criteria AS INTEGER NO-UNDO.
DEFINE VARIABLE Replace_Command  AS INTEGER NO-UNDO.

DEFINE VARIABLE Search_All       AS LOGICAL NO-UNDO. /* UIB Section Editor */

DEFINE VARIABLE Find_Text AS CHARACTER LABEL "&Find What"
  FORMAT "x(128)" VIEW-AS FILL-IN SIZE 40 By 1 {&STDPH_FILL} NO-UNDO.
DEFINE VARIABLE Replace_Text AS CHARACTER LABEL "&Replace With"
  FORMAT "x(128)" VIEW-AS FILL-IN SIZE 40 By 1 {&STDPH_FILL} NO-UNDO.

DEFINE VAR Find_Direction AS CHAR LABEL "Direction" INIT "DOWN"
	VIEW-AS RADIO-SET HORIZONTAL
		RADIO-BUTTONS "&Up",   "UP",
			      "&Down", "DOWN" .

DEFINE VARIABLE Wrap_Find         AS LOGICAL NO-UNDO.
DEFINE VARIABLE Text_Found        AS LOGICAL NO-UNDO.
DEFINE VARIABLE Last_Replace_Find AS INTEGER NO-UNDO.
DEFINE VARIABLE Find_Executed     AS LOGICAL NO-UNDO.
/* Set to TRUE on first executed Find. */

/* These three used to confirm replace when text to be replaced is selected. */
DEFINE VARIABLE Find_Sel_Text  AS CHAR NO-UNDO.
DEFINE VARIABLE Find_Sel_Start AS INTEGER NO-UNDO.
DEFINE VARIABLE Find_Sel_End   AS INTEGER NO-UNDO.


/* Find and Find/Replace Filter Types. */
DEFINE VARIABLE Case_Sensitive    AS INTEGER INITIAL 1 NO-UNDO.
DEFINE VARIABLE Wrap_Around       AS INTEGER INITIAL 2 NO-UNDO.

DEFINE VARIABLE Find_Filters AS LOGICAL EXTENT 2
  INITIAL ["FALSE","TRUE"]
  LABEL "Match &Case":L20,
        "&Wrap at Beginning/End":L20
  VIEW-AS TOGGLE-BOX NO-UNDO.

DEFINE VARIABLE Replace_Filters AS LOGICAL EXTENT 2
  INITIAL ["FALSE","TRUE"]
  LABEL "Match &Case":L15,
        "&Wrap at End":L15
  VIEW-AS TOGGLE-BOX NO-UNDO.

DEFINE VARIABLE Search_Filters AS LOGICAL EXTENT 2
  INITIAL ["FALSE"]
  LABEL "Search A&ll Sections":L25,
        "Unknown Feature":L25
  VIEW-AS TOGGLE-BOX NO-UNDO.

DEFINE BUTTON btn_Find_OK LABEL "OK"
    {&STDPH_OKBTN} AUTO-GO.
    
DEFINE BUTTON btn_Find_Cancel LABEL "Cancel"
    {&STDPH_OKBTN} AUTO-ENDKEY.

DEFINE BUTTON btn_Find_Help LABEL "&Help"
    {&STDPH_OKBTN}.

/* Dialog Button Box */
&IF {&OKBOX} &THEN
DEFINE RECTANGLE FT_Btn_Box    {&STDPH_OKBOX}.
&ENDIF

def var vDirection AS CHAR LABEL "Direction" VIEW-AS FILL-IN SIZE 1 BY 1.

/*---------------- Find Text Dialog Box ----------------*/    
FORM
    SKIP( {&TFM_WID} )
      Find_Text {&AT_OKBOX}
      SKIP( {&VM_WIDG} )
      Find_Filters[ 1 /* Match Case */ ] {&AT_OKBOX} 
      SKIP( {&VM_WID} )
      Find_Filters[2 /* Wrap_Around */ ] {&AT_OKBOX} 
      "Direction:" VIEW-AS TEXT 
          AT ROW-OF Find_Filters[1] + {&VM_WID}
             COL-OF Find_Filters[1] + 35
      SKIP( {&VM_WID} )
      Find_Direction NO-LABEL AT ROW-OF Find_Filters[ 2 ]
                                 COL-OF Find_Filters[ 2 ] + 35
      SKIP( {&VM_WIDG} )
    { adecomm/okform.i
        &BOX    ="FT_Btn_Box"
        &OK     ="btn_Find_OK"
        &CANCEL ="btn_Find_Cancel"
        &OTHER  =" "
        &HELP   ="btn_Find_Help" 
    }
    WITH FRAME FindText 
         VIEW-AS DIALOG-BOX TITLE "Find" SIDE-LABELS
                 DEFAULT-BUTTON btn_Find_OK
                 CANCEL-BUTTON  btn_Find_Cancel.
    { adecomm/okrun.i
        &FRAME  = "FRAME FindText"
        &BOX    = "FT_Btn_Box"
        &OK     = "btn_Find_OK"
        &CANCEL = "btn_Find_Cancel"
        &HELP   = "btn_Find_Help"
    }
    
/*---------------- Replace Dialog Box ----------------*/    
  DEFINE BUTTON btn_Replace_OK LABEL "OK"
    {&STDPH_OKBTN} AUTO-GO.
  
  DEFINE BUTTON btn_Replace_Cancel LABEL "Cancel"
    {&STDPH_OKBTN} AUTO-ENDKEY.
  
  DEFINE BUTTON btn_Replace_All LABEL "Replace &All"
    SIZE &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN 15 &ELSE 13 &ENDIF
         BY {&H_OKBTN} MARGIN-EXTRA DEFAULT.
  
  DEFINE BUTTON btn_Replace_Help  LABEL "&Help"
    {&STDPH_OKBTN}.

  /* Dialog Button Box */
  &IF {&OKBOX} &THEN
  DEFINE RECTANGLE RT_Btn_Box    {&STDPH_OKBOX}.
  &ENDIF
				
  FORM
      SKIP( {&TFM_WID} )
      Find_Text COLON 14
      SKIP( {&VM_WID} )
      Replace_Text COLON 14
      SKIP( {&VM_WIDG} )
      Replace_Filters[1 /* Case_Sensitive */] {&AT_OKBOX}
/* Wrap not currently supported for Replace. 
      SKIP( {&VM_WID} )
      Replace_Filters[2 /* Wrap_Around */] {&AT_OKBOX}
*/
      &IF DEFINED(SEARCH_ALL) <> 0 &THEN
      SKIP( {&VM_WID} )
      Search_Filters[1] {&AT_OKBOX}
      &ENDIF
    { adecomm/okform.i
        &BOX    ="RT_Btn_Box"
        &OK     ="btn_Replace_OK"
        &CANCEL ="btn_Replace_Cancel"
        &OTHER  ="SPACE( {&HM_BTNG} ) btn_Replace_All"
        &HELP   ="btn_Replace_Help" 
    }
    WITH FRAME ReplaceText SIDE-LABELS
         VIEW-AS DIALOG-BOX TITLE "Replace"
                 DEFAULT-BUTTON btn_Replace_OK
                 CANCEL-BUTTON  btn_Replace_Cancel.
    { adecomm/okrun.i
        &FRAME  = "FRAME ReplaceText"
        &BOX    = "RT_Btn_Box"
        &OK     = "btn_Replace_OK"
        &CANCEL = "btn_Replace_Cancel"
        &OTHER  = "btn_Replace_All"
        &HELP   = "btn_Replace_Help"
    }


/*---------------- Goto-Line Related ----------------*/

DEFINE VAR Goto_Line AS INTEGER LABEL "&Line Number"
    FORMAT ">>>>>>9".
    
DEFINE BUTTON btn_GL_OK     LABEL "OK" AUTO-GO         {&STDPH_OKBTN} .
DEFINE BUTTON btn_GL_Cancel LABEL "Cancel" AUTO-ENDKEY {&STDPH_OKBTN} .
DEFINE BUTTON btn_GL_Help   LABEL "&Help"              {&STDPH_OKBTN} .
    
/* Dialog Button Box */
&IF {&OKBOX} &THEN
DEFINE RECTANGLE GL_Btn_Box    {&STDPH_OKBOX}.
&ENDIF

/* Dialog Box */    
FORM
    SKIP( {&TFM_WID} )
    Goto_Line {&AT_OKBOX} {&STDPH_FILL}
    { adecomm/okform.i
        &BOX    ="GL_Btn_Box"
        &OK     ="btn_GL_OK"
        &CANCEL ="btn_GL_Cancel"
        &HELP   ="btn_GL_Help" 
    }
    WITH FRAME Goto_Line
         VIEW-AS DIALOG-BOX TITLE "Goto Line" SIDE-LABELS
                 DEFAULT-BUTTON btn_GL_OK
                 CANCEL-BUTTON  btn_GL_Cancel.

{ adecomm/okrun.i
    &FRAME  = "FRAME Goto_Line"
    &BOX    = "GL_Btn_Box"
    &OK     = "btn_GL_OK"
    &CANCEL = "btn_GL_Cancel"
    &HELP   = "btn_GL_Help"
}
