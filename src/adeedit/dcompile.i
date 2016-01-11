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

/*--------------------------------------------------------------------------
  dcompile.i
  Compile Commands-Related Defines for Editor 
--------------------------------------------------------------------------*/

DEFINE STREAM Comp_Msgs.
DEFINE STREAM ttyStream.

DEFINE VARIABLE Run_Window AS WIDGET-HANDLE NO-UNDO.
  /* PROEDIT uses this window when executing procs. */

DEFINE VARIABLE  Compile_FileName AS CHARACTER NO-UNDO.
  /*  Name of temporary OS file name to compile.  */

DEFINE VARIABLE Compiler_Message_Log AS CHARACTER NO-UNDO. /* Log File */

DEFINE VARIABLE Compiler_Messages AS CHARACTER  /* Hold compiler messages. */
    VIEW-AS EDITOR SIZE 75 BY  8 SCROLLBAR-V PFCOLOR 0 FONT 5.

DEFINE VARIABLE System_Error AS LOGICAL NO-UNDO.

/* CW = Compiler_Window */
DEFINE BUTTON CW_Close_Button   LABEL "OK" {&STDPH_OKBTN} AUTO-GO .

/* CW = Compiler_Window */
DEFINE BUTTON CW_Help_Button    LABEL "&Help" {&STDPH_OKBTN}.

/* Dialog Button Box */
&IF {&OKBOX} &THEN
DEFINE RECTANGLE CM_Btn_Box    {&STDPH_OKBOX}.
&ENDIF

/* Dialog Box */    
FORM
    SKIP( {&TFM_WID} )
    Compiler_Messages NO-LABEL {&AT_OKBOX}
&IF FALSE &THEN
    &IF "{&WINDOW-SYSTEM}" <> "TTY":U &THEN
    SKIP({&VM_WIDG})
    "Highlight a keyword and press Help to display PROGRESS 4GL Help."
    VIEW-AS TEXT {&AT_OKBOX}
    &ENDIF
&ENDIF
    { adecomm/okform.i
        &BOX    ="CM_Btn_Box"
        &OK     ="CW_Close_Button"
        &HELP   ="CW_Help_Button" 
    }
    WITH FRAME Compiler-Frame NO-LABELS
         VIEW-AS DIALOG-BOX TITLE "Compiler Messages"
                 DEFAULT-BUTTON CW_Close_Button . 
{ adecomm/okrun.i
    &FRAME  = "FRAME Compiler-Frame"
    &BOX    = "CM_Btn_Box"
    &OK     = "CW_Close_Button"
    &HELP   = "CW_Help_Button"
}
