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

/* gat_cpvl.i   

function:
     on leave - trigger for field user_env[5] (code-page)
   
text-parameters:
    &frame          frame containing the field
    &variable       name of the field
    &adbtype        dbtype

included in:
  prodict/gate/_gat_cp.p
  prodict/user/_usrschg.p    
    
history:
    semeniuk    94/08/18    creation
    
*/

/*------------------ begin Trailer-INFO ------------------*/

ON LEAVE OF {&variable} in frame {&frame} do:    

  if {&variable}:screen-value in frame {&frame} = "?" 
   then assign {&variable}:screen-value in frame {&frame} = "<internal defaults apply>".

   else do:
    assign
      {&variable} = TRIM({&variable}:screen-value in frame {&frame})
      {&variable}:screen-value in frame {&frame} = {&variable}.

    if ( {&adbtype} = "SYB10" or {&adbtype} = "MSSQLSRV")
      then do:
        if INDEX ({&variable}, "/") > 0 and 
             substring ({&variable}, INDEX ({&variable}, "/") + 1) = "" then
          {&variable} = 
             substring ({&variable}, 1, INDEX ({&variable}, "/") - 1).
        if INDEX ({&variable}, "/") = 0
          then do:
            /*  complete the name */
            if {&variable} = "undefined" then  {&variable} = 
                     {&variable}  + "/" + "undefined".
            else if {&variable} = "iso8859-1" then {&variable} =
                     {&variable}  + "/" + "iso_1".
            else if {&variable} = "ibm850" then {&variable} =
                     {&variable}  + "/" + "cp850".
            else do:
                assign 
                  {&variable} = {&variable}  + "/" 
                  {&variable}:screen-value in frame {&frame} = {&variable}.  
                message "Please supply" {&adbtype} "code page name "
                     view-as alert-box error.
                RETURN NO-APPLY.
              end.  /*  {&variable} <> known value  */
            {&variable}:screen-value in frame {&frame} = {&variable}.
          end.  /* INDEX ({&variable}, "/")  = 0 */ 
        if INDEX ({&variable}, "/") > 0 
          then do:
            /*  code page name consists of <cp name>/<foreigndb cp name>  */
            if codepage-convert("a", SUBSTRING({&variable}, 1, 
                    INDEX ({&variable}, "/") - 1), SESSION:CHARSET) = ?
            then RETURN NO-APPLY. /* conversion not possible */    
          end.  /* INDEX ({&variable}, "/") > 0 */
      end.  /* {&adbtype} = "SYB10" */
    else
      if codepage-convert("a", {&variable}, SESSION:CHARSET) = ?
      then RETURN NO-APPLY. /* conversion not possible */
    end.      /* {&variable} <> ? */

   end.         /* leave of {&variable} in frame {&frame} */

/*--------------------------------------------------------*/





