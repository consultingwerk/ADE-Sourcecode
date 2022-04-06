/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* File: dialvars.i */
/* ======================================================================= */
/*               SHARED VARIABLES for Dialog-box Borders                   */
/* ======================================================================= */
/* We show dialog boxes in the UIB as NO-BOX Frames in Windows. At runtime */
/* they will be dialog boxes with a border.  We need to draw the no-box    */
/* frame smaller than the size of the dialog box so that the user sees     */
/* only the usable area of the dialog box.                                 */

/* Border Width-chars & Height-chars. */
DEFINE {1} SHARED VAR _dialog_border_width     AS DECIMAL            NO-UNDO.
DEFINE {1} SHARED VAR _dialog_border_height    AS DECIMAL            NO-UNDO.
