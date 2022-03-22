/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: cbcdrop.i  (Combo Box Code Drop)

Description:
   This file contains only the in-line code that controls a drop-down combo 
   box.

   A drop-down combo box is one that contains a fill-in field, a button 
   and a selection list where the list will drop down (become visible)
   or pull up (become invisible) when the button or the fill-in are clicked on.

   This variety of drop combo box will not allow any value to be displayed 
   in the fill-in that is not in the drop down list.

Arguments:
   &Frame   - The name of the frame that the combo box appears in, 
      	      e.g., "frame foo".
   &CBFill  - The variable that is the fill-in field part of the
      	      combo box.
   &CBList  - The variable that is the selection list part of the
      	      combo box.
   &CBBtn   - The button that is the button component of the combo box.
      	      This should have been defined with IMAGE-UP FILE "adeicon/cbbtn".
   &CBInit  - The initial value of the combo box.  e.g., if the list
      	      values are known and they are "May","June","July", set
      	      this to ""June"" to have June be selected when the combo
      	      box is first displayed.  If this is set to the null
      	      string, the first item in the list is selected.

How to use this include file:
   This file should be included when you want to enable and position
   the combo box widgets - e.g. just before you are about to display 
   the frame.
   
   None of the combo box pieces need to be enabled by the caller
   (though the fill-in and button can be) The selection list variable
   should not be enabled by the caller.

   The fill-in, list and button variables need to be included 
   in the FORM but only the fill-in need be given a position.

Author: Laura Stern

Date Created: 03/06/92 

----------------------------------------------------------------------------*/

assign
   /* see choose of button trigger for explanation of these 2 */
   CB_ETime = 0
   CB_JustLeftList = false

   CB_x = {&CBFill}:x in {&Frame}
   CB_y = {&CBFill}:y in {&Frame}
   CB_width  = {&CBFill}:width-pixels in {&Frame}
   CB_height = {&CBFill}:height-pixels in {&Frame}

   /* Position the button directly next to the fill-in field. */   
   {&CBBtn}:x in {&Frame} = CB_x + CB_width 
   {&CBBtn}:y in {&Frame} = CB_y
   
   /* Set sensitivity and visibility of widgets */
   {&CBList}:hidden in {&Frame} = yes
   {&CBBtn}:hidden  in {&Frame} = no
   {&CBFill}:sensitive in {&Frame} = yes
   {&CBBtn}:sensitive  in {&Frame} = yes
   {&CBList}:sensitive in {&Frame} = yes

   /* Position the list directly below the fill-in field and make
      sure it's width is the same.  Setting of the width is particularly
      important w/ a proportional spaced font where the list is sized
      differently than a fill-in unless you use view-as fill-in phrase 
      with size option and use size on list as well.
   */
   {&CBList}:x in {&Frame} = CB_x
   {&CBList}:y in {&Frame} = CB_y + CB_height
   {&CBList}:width-pixels in {&Frame} = CB_width 
   .

/* Initialize fill-in field */
if {&CBInit} <> "" then
   {&CBFill} = {&CBInit}.
else
   {&CBFill} = {&CBList}:entry(1) in {&Frame}.

/* For drop combos, the value of the fill must equal a value in the
   drop list.  If CBFill = ? that means there's nothing in the list
   yet, and caller is not ready to display anything yet.
*/
if {&CBFill} = ? then
   {&CBFill} = "".
else 
   /* Put fillin value in frame widget.  Don't use DISPLAY to avoid
      display of the frame - leave this up to caller to control.
   */
   assign
      {&CBFill}:screen-value in {&Frame} = {&CBFill}
      {&CBList}:screen-value in {&Frame} = {&CBFill}.

