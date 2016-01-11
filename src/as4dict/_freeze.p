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

/* Procedure _Freeze.p to freeze/unfreeze files 
   
   Created 10/25/96 D. McMann to work with PROGRESS/400 Data Dictionary  
   Modified 01/07/96 D. McMann Added assign to p__File._Fil-res1[8] for
                               bug 96-10-25-007
   
*/


{ as4dict/dictvar.i SHARED }
{ as4dict/as4hlp.i }  
{ as4dict/menu.i }

DEFINE VARIABLE file-frozen AS LOGICAL INITIAL FALSE       NO-UNDO.
DEFINE VARIABLE before      AS LOGICAL              	   NO-UNDO.

DEFINE BUTTON btn_Ok          LABEL "&OK"     {&STDPH_OKBTN} AUTO-GO.
DEFINE BUTTON btn_Cancel      LABEL "&Cancel" {&STDPH_OKBTN} AUTO-ENDKEY.
DEFINE BUTTON btn_help        LABEL "&Help"   {&STDPH_OKBTN}. 

Define rectangle rect_Btns {&STDPH_OKBOX}.

/* LANGUAGE DEPENDENCIES START */ /*----------------------------------------*/

DEFINE VARIABLE new_lang AS CHARACTER EXTENT 3 NO-UNDO INITIAL [
  /* 1*/ "WARNING: By making dictionary changes for", /* 32-char filename */
  /* 2*/ "you will have to recompile all procedures referencing it!",
  /* */ "" /* reserved */
  
].

FORM
  SKIP({&TFM_WID})
  as4dict.p__File._File-Name LABEL "Table" VIEW-AS FILL-IN NATIVE COLON 6 
	SKIP({&VM_WID})

  file-frozen    VIEW-AS TOGGLE-BOX LABEL "Frozen" 
	COLON 6 
  {adecomm/okform.i
	 &BOX    = rect_btns
	 &STATUS = no
	 &OK     = btn_OK
	 &CANCEL = btn_Cancel
	 &HELP   = btn_Help}
  WITH FRAME freezing 
  CENTERED SIDE-LABELS
  DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
  VIEW-AS DIALOG-BOX TITLE "Freeze/Unfreeze Table".

/* LANGUAGE DEPENDENCIES END */ /*------------------------------------------*/


/*===============================Triggers=================================*/
&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN 
/*----- HELP -----*/
on HELP of frame freezing
   or CHOOSE of btn_Help in frame freezing
   RUN "adecomm/_adehelp.p" ("as4d", "CONTEXT", {&AS4_Data_Dictionary_Window}, ?).
&ENDIF

ON WINDOW-CLOSE OF FRAME freezing
   APPLY "END-ERROR" TO FRAME freezing.


/*============================Mainline code===============================*/

find as4dict.p__File where as4dict.p__File._File-number = s_TblForNo. 

IF as4dict.p__File._Frozen = "N" THEN ASSIGN file-frozen = false.
ELSE ASSIGN file-frozen = true.

/* Adjust the graphical rectangle and the ok, cancel and help buttons */
{adecomm/okrun.i  
    &FRAME  = "FRAME freezing" 
    &BOX    = "rect_Btns"
    &OK     = "btn_OK" 
    &HELP   = "btn_Help"
}  


ASSIGN before = (IF as4dict.p__File._Frozen = "N" THEN FALSE ELSE TRUE).

DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,RETURN:
  DISPLAY as4dict.p__File._File-Name WITH FRAME freezing.
  UPDATE  file-frozen 
      	  btn_OK  btn_Cancel btn_Help WITH FRAME freezing.
END.                              

ASSIGN as4dict.p__File._Frozen = (IF file-frozen THEN "Y" ELSE "N")
       s_DictDirty = TRUE.
       
                      
                                   
IF (before AND as4dict.p__File._Frozen = "N") OR
   (NOT before AND as4dict.p__File._Frozen = "Y") THEN DO:
  ASSIGN as4dict.p__File._Fil-misc1[1] = as4dict.p__File._Fil-misc1[1] + 1
         as4dict.p__File._Fil-res1[8] = 1.
         
  MESSAGE new_lang[1] '"' + as4dict.p__File._File-name + '"' SKIP /* change warning */
      	  new_lang[2]         	       	     	  /* recompile warning */
      	  VIEW-AS ALERT-BOX WARNING BUTTONS OK.
END.

HIDE FRAME freezing NO-PAUSE.
RETURN.



