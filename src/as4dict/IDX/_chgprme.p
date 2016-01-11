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
/* File:_chgprme.p

Description:
    This procedure allows the user to change the AS/400 name and/or Library
    for an index which was the primary but now a secondary.  This change
    is necessary because a file object with the same name is already in the
    specified library.  This procedure is used in both _newidx.p and _idxprop.p
    
History:
     Created  08/09/95  D. McMann
     Modified 12/02/96  D. McMann changed spacing for as400 name because
                        82 nt tty changed font
*/                                                                       

{as4dict/dictvar.i shared}
{as4dict/brwvar.i shared}
{as4dict/menu.i shared}
{as4dict/uivar.i shared}
{as4dict/IDX/idxvar.i shared}         


FORM
   SKIP({&TFM_WID})                 
  "A new logical file for the old primary index can not be created "   at 3
            view-as TEXT
  "because a file object exists in library with specified AS/400 name.  "   at 3
            view-as TEXT 
  "Enter a new AS/400 name and/or library for old primary index."  at 3
            view-as TEXT 
  "If you choose Cancel, the physical file key will not change."  at 3
            view-as TEXT SKIP (1)     
  as4dict.p__Index._AS4-file label "AS/400 Name" FORMAT "x(10)" colon 16 {&STDPH_FILL}     
  as4dict.p__Index._AS4-Library  Label "Library Name" FORMAT "x(10)" {&STDPH_FILL}
  SPACE({&HM_BTN})   SKIP  (1)     
  
   SPACE(12)  s_btn_ok  SPACE({&HM_BTN})  s_btn_done SPACE({&HM_BTN})
         s_Btn_help SKIP (1)

      WITH FRAME chgprime  
      DEFAULT-BUTTON s_btn_ok CANCEL-BUTTON s_btn_Done
      SIDE-LABELS
      VIEW-AS DIALOG-BOX       TITLE "Change AS/400 Names".      
 
DEFINE OUTPUT PARAMETER chgname AS LOGICAL NO-UNDO.      
DEFINE VARIABLE okay AS LOGICAL NO-UNDO.

/* User has changed the name(s) and now check to see if logical file
     with name can be created.  If not try again */
ON CHOOSE OF s_Btn_OK in frame chgprime
DO:            
    okay = false.
     dba_cmd = "CHKF".
     RUN as4dict/_dbaocmd.p 
	 (INPUT "LF", 
	  INPUT CAPS(input frame chgprime as4dict.p__Index._AS4-File),
      	  INPUT  CAPS(input frame chgprime as4dict.p__Index._AS4-Library),
	  INPUT 0,
	  INPUT 0).

    IF dba_return =   2 then DO :
        dba_cmd = "RESERVE".
        RUN as4dict/_dbaocmd.p 
	       (INPUT "LF", 
	       INPUT CAPS(input frame chgprime as4dict.p__Index._AS4-File),
      	       INPUT CAPS(input frame chgprime as4dict.p__Index._AS4-Library),
	       INPUT 0,
	       INPUT 0).    
        ASSIGN chgname = true       
	       okay = true.   
      END.            
      ELSE DO:
              MESSAGE "Duplicate names try again"
                        VIEW-AS ALERT-BOX ERROR BUTTON OK.     
               RETURN  NO-APPLY.
       END.
 END.                                                                                                          
 
/* User choose to cancel and not change physical file key */ 
ON CHOOSE OF s_Btn_done in frame chgprime
DO:            
      okay = true.  
    RETURN.
 END.

/* Selection of Help */
ON HELP of frame chgprime OR CHOOSE OF s_Btn_help in frame chgprime     
   RUN "adecomm/_adehelp.p" ("as4d", "CONTEXT", {&AS4_Change_AS_400_Name_Dlg_Box}, ?).                                                     

FIND as4dict.p__File WHERE as4dict.p__File._File-number = s_TblForNo.

/* Physical File Key Index number is stored in _Fil-Misc1[7]  and will not have a logical
    file in library */
FIND as4dict.p__Index WHERE as4dict.p__Index._File-number = as4dict.p__File._file-number
                                             AND as4dict.p__Index._Idx-num = as4dict.p__File._Fil-misc1[7].    

/* Execute loop until either the user selects done or a name passes CHKF */
DO WHILE TRUE:
    ENABLE
         as4dict.p__Index._AS4-file 
         as4dict.p__Index._AS4-Library
         s_btn_ok     
         s_btn_done
         s_Btn_help
      with frame chgprime.
       
       DISPLAY as4dict.p__Index._AS4-File
                          as4dict.p__Index._AS4-Library
       WITH FRAME chgprime.             
             
      wait-for choose of s_btn_ok.
      
      IF okay THEN DO:    
            IF chgname THEN  DO:
                ASSIGN as4dict.p__Index._AS4-file =  CAPS(input frame chgprime as4dict.p__Index._AS4-File)
                                 as4dict.p__Index._AS4-Library = CAPS(input frame chgprime as4dict.p__Index._AS4-Library).
                FOR EACH as4dict.p__Idxfd WHERE as4dict.p__Idxfd._File-number = as4dict.p__Index._File-number
                                                                              AND as4dict.p__Idxfd._Idx-num = as4dict.p__Index._Idx-num:
                        ASSIGN as4dict.p__Idxfd._AS4-File =  as4dict.p__Index._AS4-file
                                         as4dict.p__Idxfd._AS4-Library = as4dict.p__Index._AS4-Library.                                                                       END.
             END.             
            RETURN.
      END.
      ELSE NEXT.
END.     


 
