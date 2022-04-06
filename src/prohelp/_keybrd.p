/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*****************************************************************************

Procedure: _keybrd.p

Syntax: RUN prohelp/_keybrd.p.

Purpose: To dynamically display the key bindings of the users keyboard.

Description:
    This procedure dynamically displays the key bindings of the users keyboard.
    When the program is run, the keyboard mappings are saved in an array and
    they are displayed to the user.  The mappings are saved to an array for
    performance reasons.  The radio button is used to display runtime or editor
    bindings and the "Close" button closes the dialog box.

Author: Ravi-Chandar Ramalingam

Date Created: 12/09/92
******************************************************************************/
&GLOBAL-DEFINE WIN95-BTN YES
{adecomm/commeng.i}
{adecomm/adestds.i}

/******************************* Definitions *********************************/
DEFINE VARIABLE runtime-list AS CHARACTER EXTENT 88 NO-UNDO.
DEFINE VARIABLE editor-list LIKE runtime-list.

DEFINE VARIABLE rsKeyType AS INTEGER LABEL "Key Bindings for" INITIAL 1
	VIEW-AS RADIO-SET HORIZONTAL
	RADIO-BUTTONS "Editor Keys  ", 1, "Run-time Keys", 2.

DEFINE BUTTON bOk LABEL "OK" {&STDPH_OKBTN} AUTO-GO.
DEFINE BUTTON bHelp LABEL "Help" {&STDPH_OKBTN}.

/* standard button rectangle */
&IF {&OKBOX} &THEN
DEFINE RECTANGLE rHeavyRule {&STDPH_OKBOX}.
&ENDIF

DEFINE VARIABLE line1 AS CHARACTER FORMAT "x(17)".
DEFINE VARIABLE line2 AS CHARACTER FORMAT "x(20)".
DEFINE VARIABLE line3 AS CHARACTER FORMAT "x(17)".
DEFINE VARIABLE line4 AS CHARACTER FORMAT "x(17)".
DEFINE VARIABLE line5 AS CHARACTER FORMAT "x(17)".
DEFINE VARIABLE line6 AS CHARACTER FORMAT "x(20)".
DEFINE VARIABLE line7 AS CHARACTER FORMAT "x(17)".
DEFINE VARIABLE line8 AS CHARACTER FORMAT "x(17)".
DEFINE VARIABLE line9 AS CHARACTER FORMAT "x(17)".
DEFINE VARIABLE line10 AS CHARACTER FORMAT "x(20)".
DEFINE VARIABLE line11 AS CHARACTER FORMAT "x(17)".
DEFINE VARIABLE line12 AS CHARACTER FORMAT "x(17)".
DEFINE VARIABLE line13 AS CHARACTER FORMAT "x(17)".
DEFINE VARIABLE line14 AS CHARACTER FORMAT "x(20)".
DEFINE VARIABLE line15 AS CHARACTER FORMAT "x(17)".
DEFINE VARIABLE line16 AS CHARACTER FORMAT "x(17)".
DEFINE VARIABLE line17 AS CHARACTER FORMAT "x(17)".
DEFINE VARIABLE line18 AS CHARACTER FORMAT "x(20)".
DEFINE VARIABLE line19 AS CHARACTER FORMAT "x(17)".
DEFINE VARIABLE line20 AS CHARACTER FORMAT "x(17)".
DEFINE VARIABLE line21 AS CHARACTER FORMAT "x(17)".
DEFINE VARIABLE line22 AS CHARACTER FORMAT "x(20)".
DEFINE VARIABLE line23 AS CHARACTER FORMAT "x(17)".
DEFINE VARIABLE line24 AS CHARACTER FORMAT "x(17)".
DEFINE VARIABLE line25 AS CHARACTER FORMAT "x(17)".
DEFINE VARIABLE line26 AS CHARACTER FORMAT "x(20)".
DEFINE VARIABLE line27 AS CHARACTER FORMAT "x(17)".
DEFINE VARIABLE line28 AS CHARACTER FORMAT "x(17)".
DEFINE VARIABLE line29 AS CHARACTER FORMAT "x(17)".
DEFINE VARIABLE line30 AS CHARACTER FORMAT "x(20)".
DEFINE VARIABLE line31 AS CHARACTER FORMAT "x(17)".
DEFINE VARIABLE line32 AS CHARACTER FORMAT "x(17)".
DEFINE VARIABLE line33 AS CHARACTER FORMAT "x(17)".
DEFINE VARIABLE line34 AS CHARACTER FORMAT "x(20)".
DEFINE VARIABLE line35 AS CHARACTER FORMAT "x(17)".
DEFINE VARIABLE line36 AS CHARACTER FORMAT "x(17)".
DEFINE VARIABLE line37 AS CHARACTER FORMAT "x(17)".
DEFINE VARIABLE line38 AS CHARACTER FORMAT "x(20)".
DEFINE VARIABLE line39 AS CHARACTER FORMAT "x(17)".
DEFINE VARIABLE line40 AS CHARACTER FORMAT "x(17)".
DEFINE VARIABLE line41 AS CHARACTER FORMAT "x(17)".
DEFINE VARIABLE line42 AS CHARACTER FORMAT "x(20)".
DEFINE VARIABLE line43 AS CHARACTER FORMAT "x(17)".
DEFINE VARIABLE line44 AS CHARACTER FORMAT "x(17)".
DEFINE VARIABLE line45 AS CHARACTER FORMAT "x(17)".
DEFINE VARIABLE line46 AS CHARACTER FORMAT "x(20)".
DEFINE VARIABLE line47 AS CHARACTER FORMAT "x(17)".
DEFINE VARIABLE line48 AS CHARACTER FORMAT "x(17)".
DEFINE VARIABLE line49 AS CHARACTER FORMAT "x(17)".
DEFINE VARIABLE line50 AS CHARACTER FORMAT "x(20)".
DEFINE VARIABLE line51 AS CHARACTER FORMAT "x(17)".
DEFINE VARIABLE line52 AS CHARACTER FORMAT "x(17)".
DEFINE VARIABLE line53 AS CHARACTER FORMAT "x(17)".
DEFINE VARIABLE line54 AS CHARACTER FORMAT "x(20)".
DEFINE VARIABLE line55 AS CHARACTER FORMAT "x(17)".
DEFINE VARIABLE line56 AS CHARACTER FORMAT "x(17)".
DEFINE VARIABLE line57 AS CHARACTER FORMAT "x(17)".
DEFINE VARIABLE line58 AS CHARACTER FORMAT "x(20)".
DEFINE VARIABLE line59 AS CHARACTER FORMAT "x(17)".
DEFINE VARIABLE line60 AS CHARACTER FORMAT "x(17)".
DEFINE VARIABLE line61 AS CHARACTER FORMAT "x(17)".
DEFINE VARIABLE line62 AS CHARACTER FORMAT "x(20)".
DEFINE VARIABLE line63 AS CHARACTER FORMAT "x(17)".
DEFINE VARIABLE line64 AS CHARACTER FORMAT "x(17)".
DEFINE VARIABLE line65 AS CHARACTER FORMAT "x(17)".
DEFINE VARIABLE line66 AS CHARACTER FORMAT "x(20)".
DEFINE VARIABLE line67 AS CHARACTER FORMAT "x(17)".
DEFINE VARIABLE line68 AS CHARACTER FORMAT "x(17)".
DEFINE VARIABLE line69 AS CHARACTER FORMAT "x(17)".
DEFINE VARIABLE line70 AS CHARACTER FORMAT "x(20)".
DEFINE VARIABLE line71 AS CHARACTER FORMAT "x(17)".
DEFINE VARIABLE line72 AS CHARACTER FORMAT "x(17)".
DEFINE VARIABLE line73 AS CHARACTER FORMAT "x(17)".
DEFINE VARIABLE line74 AS CHARACTER FORMAT "x(20)".
DEFINE VARIABLE line75 AS CHARACTER FORMAT "x(17)".
DEFINE VARIABLE line76 AS CHARACTER FORMAT "x(17)".
DEFINE VARIABLE line77 AS CHARACTER FORMAT "x(17)".
DEFINE VARIABLE line78 AS CHARACTER FORMAT "x(20)".
DEFINE VARIABLE line79 AS CHARACTER FORMAT "x(17)".
DEFINE VARIABLE line80 AS CHARACTER FORMAT "x(17)".
DEFINE VARIABLE line81 AS CHARACTER FORMAT "x(17)".
DEFINE VARIABLE line82 AS CHARACTER FORMAT "x(20)".
DEFINE VARIABLE line83 AS CHARACTER FORMAT "x(17)".
DEFINE VARIABLE line84 AS CHARACTER FORMAT "x(17)".
DEFINE VARIABLE line85 AS CHARACTER FORMAT "x(17)".
DEFINE VARIABLE line86 AS CHARACTER FORMAT "x(20)".
DEFINE VARIABLE line87 AS CHARACTER FORMAT "x(17)".
DEFINE VARIABLE line88 AS CHARACTER FORMAT "x(17)".

FORM
    SKIP({&TFM_WID})
    rsKeyType AT 15 SKIP({&VM_WIDG})
    line1 VIEW-AS TEXT AT 3 NO-LABEL
    line2 VIEW-AS TEXT NO-LABEL
    line3 VIEW-AS TEXT NO-LABEL
    line4 VIEW-AS TEXT NO-LABEL SKIP
    line5 VIEW-AS TEXT AT 3 NO-LABEL 
    line6 VIEW-AS TEXT NO-LABEL
    line7 VIEW-AS TEXT NO-LABEL
    line8 VIEW-AS TEXT NO-LABEL SKIP
    line9 VIEW-AS TEXT AT 3 NO-LABEL
    line10 VIEW-AS TEXT NO-LABEL
    line11 VIEW-AS TEXT NO-LABEL
    line12 VIEW-AS TEXT NO-LABEL SKIP
    line13 VIEW-AS TEXT AT 3 NO-LABEL
    line14 VIEW-AS TEXT NO-LABEL
    line15 VIEW-AS TEXT NO-LABEL
    line16 VIEW-AS TEXT NO-LABEL SKIP
    line17 VIEW-AS TEXT AT 3 NO-LABEL
    line18 VIEW-AS TEXT NO-LABEL
    line19 VIEW-AS TEXT NO-LABEL
    line20 VIEW-AS TEXT NO-LABEL SKIP
    line21 VIEW-AS TEXT AT 3 NO-LABEL 
    line22 VIEW-AS TEXT NO-LABEL
    line23 VIEW-AS TEXT NO-LABEL
    line24 VIEW-AS TEXT NO-LABEL SKIP
    line25 VIEW-AS TEXT AT 3 NO-LABEL
    line26 VIEW-AS TEXT NO-LABEL
    line27 VIEW-AS TEXT NO-LABEL
    line28 VIEW-AS TEXT NO-LABEL SKIP
    line29 VIEW-AS TEXT AT 3 NO-LABEL
    line30 VIEW-AS TEXT NO-LABEL
    line31 VIEW-AS TEXT NO-LABEL
    line32 VIEW-AS TEXT NO-LABEL SKIP
    line33 VIEW-AS TEXT AT 3 NO-LABEL
    line34 VIEW-AS TEXT NO-LABEL
    line35 VIEW-AS TEXT NO-LABEL
    line36 VIEW-AS TEXT NO-LABEL SKIP
    line37 VIEW-AS TEXT AT 3 NO-LABEL
    line38 VIEW-AS TEXT NO-LABEL
    line39 VIEW-AS TEXT NO-LABEL
    line40 VIEW-AS TEXT NO-LABEL SKIP
    line41 VIEW-AS TEXT AT 3 NO-LABEL 
    line42 VIEW-AS TEXT NO-LABEL
    line43 VIEW-AS TEXT NO-LABEL
    line44 VIEW-AS TEXT NO-LABEL SKIP
    line45 VIEW-AS TEXT AT 3 NO-LABEL
    line46 VIEW-AS TEXT NO-LABEL
    line47 VIEW-AS TEXT NO-LABEL
    line48 VIEW-AS TEXT NO-LABEL SKIP
    line49 VIEW-AS TEXT AT 3 NO-LABEL
    line50 VIEW-AS TEXT NO-LABEL
    line51 VIEW-AS TEXT NO-LABEL
    line52 VIEW-AS TEXT NO-LABEL SKIP
    line53 VIEW-AS TEXT AT 3 NO-LABEL
    line54 VIEW-AS TEXT NO-LABEL
    line55 VIEW-AS TEXT NO-LABEL
    line56 VIEW-AS TEXT NO-LABEL SKIP
    line57 VIEW-AS TEXT AT 3 NO-LABEL
    line58 VIEW-AS TEXT NO-LABEL
    line59 VIEW-AS TEXT NO-LABEL
    line60 VIEW-AS TEXT NO-LABEL SKIP
    line61 VIEW-AS TEXT AT 3 NO-LABEL 
    line62 VIEW-AS TEXT NO-LABEL
    line63 VIEW-AS TEXT NO-LABEL
    line64 VIEW-AS TEXT NO-LABEL SKIP
    line65 VIEW-AS TEXT AT 3 NO-LABEL
    line66 VIEW-AS TEXT NO-LABEL
    line67 VIEW-AS TEXT NO-LABEL
    line68 VIEW-AS TEXT NO-LABEL SKIP
    line69 VIEW-AS TEXT AT 3 NO-LABEL
    line70 VIEW-AS TEXT NO-LABEL
    line71 VIEW-AS TEXT NO-LABEL
    line72 VIEW-AS TEXT NO-LABEL SKIP
    line73 VIEW-AS TEXT AT 3 NO-LABEL
    line74 VIEW-AS TEXT NO-LABEL
    line75 VIEW-AS TEXT NO-LABEL
    line76 VIEW-AS TEXT NO-LABEL SKIP
    line77 VIEW-AS TEXT AT 3 NO-LABEL
    line78 VIEW-AS TEXT NO-LABEL
    line79 VIEW-AS TEXT NO-LABEL
    line80 VIEW-AS TEXT NO-LABEL SKIP
    line81 VIEW-AS TEXT AT 3 NO-LABEL 
    line82 VIEW-AS TEXT NO-LABEL
    line83 VIEW-AS TEXT NO-LABEL
    line84 VIEW-AS TEXT NO-LABEL SKIP
    line85 VIEW-AS TEXT AT 3 NO-LABEL
    line86 VIEW-AS TEXT NO-LABEL
    line87 VIEW-AS TEXT NO-LABEL
    line88 VIEW-AS TEXT NO-LABEL

   {adecomm/okform.i
      &BOX    = "rHeavyRule"
      &STATUS = "no"
      &OK     = "bOk"
      &HELP   = "bHelp"}

   WITH FRAME frKeyboard SIDE-LABELS VIEW-AS DIALOG-BOX.

/**************************** Internal Procedures ****************************/
PROCEDURE ShowRunTimeScreens.
DO WITH FRAME frKeyboard:
   ASSIGN FRAME frKeyboard:title = "Run-time Key Bindings"
   line1:screen-value = runtime-list[1]
   line2:screen-value = runtime-list[2]
   line3:screen-value = runtime-list[3]
   line4:screen-value = runtime-list[4]
   line5:screen-value = runtime-list[5]
   line6:screen-value = runtime-list[6]
   line7:screen-value = runtime-list[7]
   line8:screen-value = runtime-list[8]
   line9:screen-value = runtime-list[9]
   line10:screen-value = runtime-list[10]
   line11:screen-value = runtime-list[11]
   line12:screen-value = runtime-list[12]
   line13:screen-value = runtime-list[13]
   line14:screen-value = runtime-list[14]
   line15:screen-value = runtime-list[15]
   line16:screen-value = runtime-list[16]
   line17:screen-value = runtime-list[17]
   line18:screen-value = runtime-list[18]
   line19:screen-value = runtime-list[19]
   line20:screen-value = runtime-list[20]
   line21:screen-value = runtime-list[21]
   line22:screen-value = runtime-list[22]
   line23:screen-value = runtime-list[23]
   line24:screen-value = runtime-list[24]
   line25:screen-value = runtime-list[25]
   line26:screen-value = runtime-list[26]
   line27:screen-value = runtime-list[27]
   line28:screen-value = runtime-list[28]
   line29:screen-value = runtime-list[29]
   line30:screen-value = runtime-list[30]
   line31:screen-value = runtime-list[31]
   line32:screen-value = runtime-list[32]
   line33:screen-value = runtime-list[33]
   line34:screen-value = runtime-list[34]
   line35:screen-value = runtime-list[35]
   line36:screen-value = runtime-list[36]
   line37:screen-value = runtime-list[37]
   line38:screen-value = runtime-list[38]
   line39:screen-value = runtime-list[39]
   line40:screen-value = runtime-list[40]
   line41:screen-value = runtime-list[41]
   line42:screen-value = runtime-list[42]
   line43:screen-value = runtime-list[43]
   line44:screen-value = runtime-list[44]
   line45:screen-value = runtime-list[45]
   line46:screen-value = runtime-list[46]
   line47:screen-value = runtime-list[47]
   line48:screen-value = runtime-list[48]
   line49:screen-value = runtime-list[49]
   line50:screen-value = runtime-list[50]
   line51:screen-value = runtime-list[51]
   line52:screen-value = runtime-list[52]
   line53:screen-value = runtime-list[53]
   line54:screen-value = runtime-list[54]
   line55:screen-value = runtime-list[55]
   line56:screen-value = runtime-list[56]
   line57:screen-value = runtime-list[57]
   line58:screen-value = runtime-list[58]
   line59:screen-value = runtime-list[59]
   line60:screen-value = runtime-list[60].
   ASSIGN line61:screen-value = runtime-list[61]
   line62:screen-value = runtime-list[62]
   line63:screen-value = runtime-list[63]
   line64:screen-value = runtime-list[64]
   line65:screen-value = runtime-list[65]
   line66:screen-value = runtime-list[66]
   line67:screen-value = runtime-list[67]
   line68:screen-value = runtime-list[68]
   line69:screen-value = runtime-list[69]
   line70:screen-value = runtime-list[70]
   line71:screen-value = runtime-list[71]
   line72:screen-value = runtime-list[72]
   line73:screen-value = runtime-list[73]
   line74:screen-value = runtime-list[74]
   line75:screen-value = runtime-list[75]
   line76:screen-value = runtime-list[76]
   line77:screen-value = runtime-list[77]
   line78:screen-value = runtime-list[78]
   line79:screen-value = runtime-list[79]
   line80:screen-value = runtime-list[80]
   line81:screen-value = runtime-list[81]
   line82:screen-value = runtime-list[82]
   line83:screen-value = runtime-list[83]
   line84:screen-value = runtime-list[84]
   line85:screen-value = runtime-list[85]
   line86:screen-value = runtime-list[86]
   line87:screen-value = runtime-list[87]
   line88:screen-value = runtime-list[88].
END.
END PROCEDURE. /* ShowRunTimeScreens */

PROCEDURE ShowToolKeysScreen.
DO WITH FRAME frKeyboard:
   ASSIGN FRAME frKeyboard:title = "Editor Key Bindings"
   line1:screen-value = editor-list[1]
   line2:screen-value = editor-list[2]
   line3:screen-value = editor-list[3]
   line4:screen-value = editor-list[4]
   line5:screen-value = editor-list[5]
   line6:screen-value = editor-list[6]
   line7:screen-value = editor-list[7]
   line8:screen-value = editor-list[8]
   line9:screen-value = editor-list[9]
   line10:screen-value = editor-list[10]
   line11:screen-value = editor-list[11]
   line12:screen-value = editor-list[12]
   line13:screen-value = editor-list[13]
   line14:screen-value = editor-list[14]
   line15:screen-value = editor-list[15]
   line16:screen-value = editor-list[16]
   line17:screen-value = editor-list[17]
   line18:screen-value = editor-list[18]
   line19:screen-value = editor-list[19]
   line20:screen-value = editor-list[20]
   line21:screen-value = editor-list[21]
   line22:screen-value = editor-list[22]
   line23:screen-value = editor-list[23]
   line24:screen-value = editor-list[24]
   line25:screen-value = editor-list[25]
   line26:screen-value = editor-list[26]
   line27:screen-value = editor-list[27]
   line28:screen-value = editor-list[28]
   line29:screen-value = editor-list[29]
   line30:screen-value = editor-list[30]
   line31:screen-value = editor-list[31]
   line32:screen-value = editor-list[32]
   line33:screen-value = editor-list[33]
   line34:screen-value = editor-list[34]
   line35:screen-value = editor-list[35]
   line36:screen-value = editor-list[36]
   line37:screen-value = editor-list[37]
   line38:screen-value = editor-list[38]
   line39:screen-value = editor-list[39]
   line40:screen-value = editor-list[40]
   line41:screen-value = editor-list[41]
   line42:screen-value = editor-list[42]
   line43:screen-value = editor-list[43]
   line44:screen-value = editor-list[44]
   line45:screen-value = editor-list[45]
   line46:screen-value = editor-list[46]
   line47:screen-value = editor-list[47]
   line48:screen-value = editor-list[48]
   line49:screen-value = editor-list[49]
   line50:screen-value = editor-list[50]
   line51:screen-value = editor-list[51]
   line52:screen-value = editor-list[52]
   line53:screen-value = editor-list[53]
   line54:screen-value = editor-list[54]
   line55:screen-value = editor-list[55]
   line56:screen-value = editor-list[56]
   line57:screen-value = editor-list[57]
   line58:screen-value = editor-list[58]
   line59:screen-value = editor-list[59]
   line60:screen-value = editor-list[60].
   ASSIGN line61:screen-value = editor-list[61]
   line62:screen-value = editor-list[62]
   line63:screen-value = editor-list[63]
   line64:screen-value = editor-list[64]
   line65:screen-value = editor-list[65]
   line66:screen-value = editor-list[66]
   line67:screen-value = editor-list[67]
   line68:screen-value = editor-list[68]
   line69:screen-value = editor-list[69]
   line70:screen-value = editor-list[70]
   line71:screen-value = editor-list[71]
   line72:screen-value = editor-list[72]
   line73:screen-value = editor-list[73]
   line74:screen-value = editor-list[74]
   line75:screen-value = editor-list[75]
   line76:screen-value = editor-list[76]
   line77:screen-value = editor-list[77]
   line78:screen-value = editor-list[78]
   line79:screen-value = editor-list[79]
   line80:screen-value = editor-list[80]
   line81:screen-value = editor-list[81]
   line82:screen-value = editor-list[82]
   line83:screen-value = editor-list[83]
   line84:screen-value = editor-list[84]
   line85:screen-value = editor-list[85]
   line86:screen-value = editor-list[86]
   line87:screen-value = editor-list[87]
   line88:screen-value = editor-list[88].
END.
END PROCEDURE. /* ShowToolKeysScreen */

PROCEDURE GetRunTimeKeys.
  FRAME frKeyboard:TITLE = "Runtime Key Bindings".
  runtime-list[1] = "ABORT".
  runtime-list[2] = kblabel("ABORT").
  runtime-list[3] = "BACK-TAB".
  runtime-list[4] = kblabel("BACK-TAB").

  runtime-list[5] = "CLEAR".
  runtime-list[6] = kblabel("CLEAR").
  runtime-list[7] = "CURSOR-DOWN".
  runtime-list[8] = kblabel("CURSOR-DOWN").

  runtime-list[9] = "CURSOR-LEFT".
  runtime-list[10] = kblabel("CURSOR-LEFT").
  runtime-list[11] = "CURSOR-RIGHT".
  runtime-list[12] = kblabel("CURSOR-RIGHT").

  runtime-list[13] = "CURSOR-UP".
  runtime-list[14] = kblabel("CURSOR-UP").
  runtime-list[15] = "END-ERROR".
  runtime-list[16] = kblabel("END-ERROR").

  runtime-list[17] = "ENTER-MENUBAR".
  runtime-list[18] = kblabel("ENTER-MENUBAR").
  runtime-list[19] = "GO".
  runtime-list[20] = kblabel("GO").

  runtime-list[21] = "HELP".
  runtime-list[22] = kblabel("HELP"). 
  runtime-list[23] = "INSERT-MODE".
  runtime-list[24] = kblabel("INSERT-MODE").

  runtime-list[25] = "LEFT-END".
  runtime-list[26] = kblabel("LEFT-END").
  runtime-list[27] = "NEXT-FRAME".
  runtime-list[28] = kblabel("NEXT-FRAME").

  runtime-list[29] = "PREV-FRAME".
  runtime-list[30] = kblabel("PREV-FRAME").
  runtime-list[31] = "RECALL".
  runtime-list[32] = kblabel("RECALL").

  runtime-list[33] = "RESUME-DISPLAY".
  runtime-list[34] = kblabel("RESUME-DISPLAY").
  runtime-list[35] = "RETURN".
  runtime-list[36] = kblabel("RETURN").

  runtime-list[37] = "RIGHT-END".
  runtime-list[38] = kblabel("RIGHT-END").
  runtime-list[39] = "SCROLL-MODE".
  runtime-list[40] = kblabel("SCROLL-MODE").

  runtime-list[41] = "STOP".
  runtime-list[42] = kblabel("STOP").
  runtime-list[43] = "STOP-DISPLAY".
  runtime-list[44] = kblabel("STOP-DISPLAY").

  runtime-list[45] = "TAB".
  runtime-list[46] = kblabel("TAB").
  runtime-list[47] = "".
  runtime-list[48] = "".

  runtime-list[49] = "".
  runtime-list[50] = "".
  runtime-list[51] = "".
  runtime-list[52] = "".

  runtime-list[53] = "".
  runtime-list[54] = "".
  runtime-list[55] = "".
  runtime-list[56] = "".

  runtime-list[57] = "".
  runtime-list[58] = "".
  runtime-list[59] = "".
  runtime-list[60] = "".

  runtime-list[61] = "".
  runtime-list[62] = "".
  runtime-list[63] = "".
  runtime-list[64] = "".

  runtime-list[65] = "".
  runtime-list[66] = "".
  runtime-list[67] = "".
  runtime-list[68] = "".

  runtime-list[69] = "".
  runtime-list[70] = "".
  runtime-list[71] = "".
  runtime-list[72] = "".

  runtime-list[73] = "".
  runtime-list[74] = "".
  runtime-list[75] = "".
  runtime-list[76] = "".

  runtime-list[77] = "".
  runtime-list[78] = "".
  runtime-list[79] = "".
  runtime-list[80] = "".

  runtime-list[81] = "".
  runtime-list[82] = "".
  runtime-list[83] = "".
  runtime-list[84] = "".

  runtime-list[85] = "".
  runtime-list[86] = "".
  runtime-list[87] = "".
  runtime-list[88] = "".

END PROCEDURE. /* GetRunTimeKeys */

PROCEDURE GetToolKeys.
  FRAME frKeyboard:TITLE = "Editor Key Bindings". 

  editor-list[1] = "APPEND-LINE".
  editor-list[2] = kblabel("APPEND-LINE").
  editor-list[3] = "BACK-TAB".
  editor-list[4] = kblabel("BACK-TAB").

  editor-list[5] = "BACKSPACE".
  editor-list[6] = kblabel("BACKSPACE").
  editor-list[7] = "BLOCK".
  editor-list[8] = kblabel("BLOCK").

  editor-list[9] = "CLOSE".
  editor-list[10] = kblabel("CLOSE").
  editor-list[11] = "COMPILE".
  editor-list[12] = kblabel("COMPILE").

  editor-list[13] = "COPY".
  editor-list[14] = kblabel("COPY").
  editor-list[15] = "CURSOR-DOWN".
  editor-list[16] = kblabel("CURSOR-DOWN").

  editor-list[17] = "CURSOR-LEFT".
  editor-list[18] = kblabel("CURSOR-LEFT").
  editor-list[19] = "CURSOR-RIGHT".
  editor-list[20] = kblabel("CURSOR-RIGHT").

  editor-list[21] = "CURSOR-UP".
  editor-list[22] = kblabel("CURSOR-UP").
  editor-list[23] = "CUT".
  editor-list[24] = kblabel("CUT").

  editor-list[25] = "DELETE-CHARACTER".
  editor-list[26] = kblabel("DELETE-CHARACTER").
  editor-list[27] = "DELETE-END-LINE".
  editor-list[28] = kblabel("DELETE-END-LINE").

  editor-list[29] = "DELETE-LINE".
  editor-list[30] = kblabel("DELETE-LINE").
  editor-list[31] = "DELETE-WORD".
  editor-list[32] = kblabel("DELETE-WORD").

  editor-list[33] = "EDITOR-BACKTAB".
  editor-list[34] = kblabel("EDITOR-BACKTAB").
  editor-list[35] = "EDITOR-TAB".
  editor-list[36] = kblabel("EDITOR-TAB").

  editor-list[37] = "END".
  editor-list[38] = kblabel("END").
  editor-list[39] = "ENTER-MENUBAR".
  editor-list[40] = kblabel("ENTER-MENUBAR").

  editor-list[41] = "EXIT".
  editor-list[42] = kblabel("EXIT").
  editor-list[43] = "FIND".
  editor-list[44] = kblabel("FIND").

  editor-list[45] = "FIND-NEXT".
  editor-list[46] = kblabel("FIND-NEXT").
  editor-list[47] = "FIND-PREVIOUS".
  editor-list[48] = kblabel("FIND-PREVIOUS").

  editor-list[49] = "GET".
  editor-list[50] = kblabel("GET").
  editor-list[51] = "GO".
  editor-list[52] = kblabel("GO").

  editor-list[53] = "GOTO".
  editor-list[54] = kblabel("GOTO").
  editor-list[55] = "HELP".
  editor-list[56] = kblabel("HELP").

  editor-list[57] = "HOME".
  editor-list[58] = kblabel("HOME").
  editor-list[59] = "INSERT-MODE".
  editor-list[60] = kblabel("INSERT-MODE").

  editor-list[61] = "LEFT-END".
  editor-list[62] = kblabel("LEFT-END").
  editor-list[63] = "NEW".
  editor-list[64] = kblabel("NEW").

  editor-list[65] = "NEW-LINE".
  editor-list[66] = kblabel("NEW-LINE").
  editor-list[67] = "NEXT-WORD".
  editor-list[68] = kblabel("NEXT-WORD").

  editor-list[69] = "OPEN-LINE-ABOVE".
  editor-list[70] = kblabel("OPEN-LINE-ABOVE").
  editor-list[71] = "PAGE-DOWN".
  editor-list[72] = kblabel("PAGE-DOWN").

  editor-list[73] = "PAGE-UP".
  editor-list[74] = kblabel("PAGE-UP").
  editor-list[75] = "PASTE".
  editor-list[76] = kblabel("PASTE").

  editor-list[77] = "PREV-WORD".
  editor-list[78] = kblabel("PREV-WORD").
  editor-list[79] = "PUT".
  editor-list[80] = kblabel("PUT").

  editor-list[81] = "REPLACE".
  editor-list[82] = kblabel("REPLACE").
  editor-list[83] = "RIGHT-END".
  editor-list[84] = kblabel("RIGHT-END").

  editor-list[85] = "SAVE-AS".
  editor-list[86] = kblabel("SAVE-AS").
  editor-list[87] = "TAB".
  editor-list[88] = kblabel("TAB").


END PROCEDURE. /* GetToolKeys */

/********************************* Triggers **********************************/
/* Help triggers */
ON CHOOSE OF bHelp IN FRAME frKeyboard OR HELP OF FRAME frKeyboard DO:
  IF INTEGER(rsKeyType:SCREEN-VALUE IN FRAME frKeyboard) > 1 THEN
    RUN adecomm/_adehelp.p ( "comm", "CONTEXT", {&Runtime_Keys_Dlg_Box}, ? ).
  ELSE
    RUN adecomm/_adehelp.p ( "comm", "CONTEXT", {&Editor_Keys_Dlg_Box}, ? ).
END.

ON VALUE-CHANGED OF rsKeyType IN FRAME frKeyboard DO:
  IF INTEGER(rsKeyType:SCREEN-VALUE IN FRAME frKeyboard) > 1 THEN
    RUN ShowRunTimeScreens.
  ELSE
    RUN ShowToolKeysScreen.
END.


/*********************************** Main ************************************/
/* Run time layout for button area. */
{adecomm/okrun.i  
    &FRAME = "FRAME frKeyboard" 
    &BOX   = "rHeavyRule"
    &OK    = "bOK" 
    &HELP  = "bHelp"
}


DO ON ERROR UNDO, LEAVE ON ENDKEY UNDO, LEAVE ON STOP UNDO, LEAVE:
  RUN adecomm/_setcurs.p ("WAIT"). /* set the busy cursor */

  RUN GetToolKeys.
  RUN GetRunTimeKeys.

  ENABLE rsKeyType bOk bHelp {&WHEN_HELP} WITH FRAME frKeyboard.
  RUN ShowToolKeysScreen.
  RUN adecomm/_setcurs.p (""). /* reset the busy cursor */
  WAIT-FOR CHOOSE OF bOk IN FRAME frKeyboard
    OR WINDOW-CLOSE OF FRAME frKeyboard
    OR GO OF FRAME frKeyboard FOCUS rsKeyType.
END.
