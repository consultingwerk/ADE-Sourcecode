/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
* _alayout.i
*
*    Provides the constants needed to layout in the administration code in
*    a consistant way. The sizes of some widgets are defined here
*    as well as the gap between widgets.
*
*    This file is best use with the row-of/column-of syntax
*/

/*
* Eventually worry about Motif sizes here too.
*
* Finally, there are some definitions, like AMD_H_FLIST_OFF that should
* be a simple arithmetic statement. But since the compiler doesn't allow
* in the row-of phrase we've got to do the arithmetic here and provide the
* final number. Those definitions that are formulas have the formula
* stated in a comment for future enhancements.
*/

&GLOBAL-DEFINE ADM_H_GAP          1
&GLOBAL-DEFINE ADM_V_GAP          1.225 /* H_OKBTN + VM_WID */

&GLOBAL-DEFINE ADM_S_GAP          2
&GLOBAL-DEFINE ADM_X_START        2

/* Feature selection list size (FLIST) */
&GLOBAL-DEFINE ADM_IC_FLIST      28
&GLOBAL-DEFINE ADM_IL_FLIST      11

&IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
&GLOBAL-DEFINE ADM_H_FLIST_OFF   32
&ELSE
&GLOBAL-DEFINE ADM_H_FLIST_OFF   34
&ENDIF

&GLOBAL-DEFINE ADM_B_FLIST        7.25
&GLOBAL-DEFINE ADM_P_FLIST        8.5 /* Past the flist (below) */

/* Other things */
&GLOBAL-DEFINE ADM_H_BUTTON      {&H_OKBTN}
&GLOBAL-DEFINE ADM_W_BUTTON      12
&GLOBAL-DEFINE ADM_H_BUTTON_OFF  13 /* ADM_W_BUTTON + ADM_H_GAP */

/* Little Buttons (LBUTTON) */
&GLOBAL-DEFINE ADM_W_LBUTTON      8
&GLOBAL-DEFINE ADM_H_LBUTTON_OFF  9 /* ADM_W_BUTTON + ADM_H_GAP */

/* Standard fillin (SFILL) */
&GLOBAL-DEFINE ADM_W_SFILL       32
&GLOBAL-DEFINE ADM_H_SFILL_OFF   33 /* ADM_W_SFILL + ADM_H_GAP */

/* Little fillin (LFILL) */
&GLOBAL-DEFINE ADM_W_LFILL       20
&GLOBAL-DEFINE ADM_H_LFILL_OFF   21 /* ADM_W_SFILL + ADM_H_GAP */

/*
* Standard sized selection list, including height, width, horizontal
* offset to get past the selection list, the second starting offset of
* side-by side lists (using standard Buttons), "really" beyond the
* bottom of the selection (for grouping gaps) and the row of the bottom of
* the selection list (SLIST)
*/

&GLOBAL-DEFINE ADM_H_SLIST        5
&GLOBAL-DEFINE ADM_W_SLIST       28
&GLOBAL-DEFINE ADM_IL_SLIST       6
&GLOBAL-DEFINE ADM_IL_LLIST       9
&GLOBAL-DEFINE ADM_IC_SLIST      25

&IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
&GLOBAL-DEFINE ADM_H_SLIST_OFF   29 /* ADM_W_SLIST + ADM_H_GAP */
&GLOBAL-DEFINE ADM_H_SLIST_SBS   42 /* ADM_H_SLIST_OFF + ADM_H_BUTTON_OFF */
&ELSE
&GLOBAL-DEFINE ADM_H_SLIST_OFF   31 /* ADM_W_SLIST + ADM_H_GAP */
&GLOBAL-DEFINE ADM_H_SLIST_SBS   44 /* ADM_H_SLIST_OFF + ADM_H_BUTTON_OFF */
&ENDIF

&GLOBAL-DEFINE ADM_B_SLIST        4 /* ADM_H_SLIST - 1 */
&GLOBAL-DEFINE ADM_P_SLIST        5
&GLOBAL-DEFINE ADM_R_SLIST      5.5 /* ADM_P_SLIST + .5 */

&GLOBAL-DEFINE ADM_W_SLIST_SBS   70 /* 2xADM_H_SLIST_OFF + ADM_H_BUTTON_OFF */

&GLOBAL-DEFINE ADM_LIMIT_CHARS 3800

/* _alayout.i - end of file */

