/***********************************************************************
* Copyright (C) 2000,2007 by Progress Software Corporation. All rights *
* reserved. Prior versions of this work may contain portions           *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/

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
    moloney     07/03/21    Unicode support for MSS
    fernando    06/18/07    Unicode support for ORACLE
    
*/

DEFINE BUFFER m_Db for _Db.

/*------------------ begin Trailer-INFO ------------------*/

ON LEAVE OF {&variable} in frame {&frame} do:    

  if {&variable}:screen-value in frame {&frame} = "?" 
   then assign {&variable}:screen-value in frame {&frame} = "<internal defaults apply>".

   else do:
    assign
      {&variable} = TRIM({&variable}:screen-value in frame {&frame})
      {&variable}:screen-value in frame {&frame} = {&variable}.

    if ( UPPER(TRIM( {&variable} ) ) = "UTF-8" AND 
         ({&adbtype} = "MSS" OR {&adbtype} = "ORACLE")) 
      then do:
        /* use a differet buffer so that we don't mess up with the currently available _db rec */
        FIND FIRST m_Db WHERE m_Db._Db-local AND m_Db._Db-type = "PROGRESS".
        IF ( AVAILABLE(m_Db) AND UPPER( m_Db._Db-xl-name ) <> UPPER(TRIM( {&variable} ) ) ) 
          THEN DO:

            MESSAGE "Logical DataServer schema and physical schema holder " skip
                    "codepages must both be 'utf-8'." VIEW-AS ALERT-BOX ERROR BUTTONS OK.

            RETURN NO-APPLY.
          END.
      END.  /* {&adbtype} = "MSS" */

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





