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

/* usrdump1.i   

function:
     on leave - trigger for field user_env[5] (code-page)
   
text-parameters:
    &frame          frame containing the field
    &variable       name of the field
    
included in:
  prodict/user/_usrdump.p    
  prodict/user/_usrincr.p    
    
history:
    hutegger    94/03/02    creation
    
*/
/*------------------ begin Trailer-INFO ------------------*/

ON LEAVE OF {&variable} in frame {&frame} do:    

  if {&variable}:screen-value in frame {&frame} = "?" 
   then assign {&variable}:screen-value in frame {&frame} = "<internal defaults apply>".

   else do:
    assign
      {&variable} = TRIM({&variable}:screen-value in frame {&frame})
      {&variable}:screen-value in frame {&frame} = {&variable}.
    if codepage-convert("a",{&variable},SESSION:CHARSET) = ? 
     then RETURN NO-APPLY. /* conversion not possible */
    end.      /* {&variable} <> ? */

   end.         /* leave of {&variable} in frame {&frame} */

/*--------------------------------------------------------*/

