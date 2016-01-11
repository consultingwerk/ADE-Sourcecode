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

/*----------------------------------------------------------------------------

File: cbdropx.i

Description:
   This file contains both in-line code and trigger code that 
   controls an editable drop-down combo box.

   A drop-down combo box is one that contains a fill-in field, a button 
   and a selection list where the list will drop down (become visible)
   or pull up (become invisible) when the button or the fill-in are clicked on.

   This variety of drop combo box will allow a value to be displayed 
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

Events Generated:
   U1 may be sent to either the fill-in widget or the selection list
   widget when the selection list value has changed.  You must have a
   trigger on both in order to detect this correctly.

How to use this include file:
   This file should be included before the frame is made visible
   but after the FORM definition, if there is one. 
   
   None of the combo box pieces need to be ENABLEd by the caller
   (though the fill-in and button can be) The selection list variable
   should not be ENABLEd by the caller.

   The fill-in, list and button variables need to be included 
   in the FORM but only the fill-in need be given a position.


Author: Laura Stern

Date Created: 07/29/92 

----------------------------------------------------------------------------*/


/* triggers */
{adecomm/cbtdropx.i &Frame  = "{&Frame}"
      	       	    &CBFill = "{&CBFill}"
		    &CBList = "{&CBList}"
		    &CBBtn  = "{&CBBtn}"
		    &CBInit = "{&CBInit}"}


/* Initialization code */
{adecomm/cbcdropx.i &Frame  = "{&Frame}"
      	       	    &CBFill = "{&CBFill}"
		    &CBList = "{&CBList}"
		    &CBBtn  = "{&CBBtn}"
		    &CBInit = "{&CBInit}"}


