/***********************************************************************
* Copyright (C) 2007-2009 by Progress Software Corporation. All rights *
* reserved. Prior versions of this work may contain portions           *
* contributed by participants of Possenet.                             *
*                                                                      *
************************************************************************/

/*--------------------------------------------------------------------

File: prodict/gate/presel.i

Description:
    
    extracts initial-values for name,owner, type and qualifier out of
    user_env[25], and, if user_env[25] not begins with "AUTO", calls 
    the dialog-box-program for the preselection-criterias.
            
Text-Parameters:
    &block     label of block to leave if canceled or no obj found  
    &frame     name of preselection-frame ("frm_ntoq" or "frm_nto")

    
Included in:
    odb/_odb_get.p
    ora/_ora_lk1.p
    ora/ora_get.i
    syb/syb_getp.i
    
History:
    hutegger    94/07/29    creation
    mcmann      05/21/2002  Added new input-output parameter
    knavneet    08/12/2007  if as400, s_owner is not assigned to *
    fernando    02/25/2008  Added new input-output parameter for datetime
    knavneet    04/28/2009  BLOB support for MSS (OE00178319)
--------------------------------------------------------------------*/        
/*h-*/

if NUM-ENTRIES(user_env[25]) = 5
 then assign
  s_name  = ENTRY(2,user_env[25])
  s_owner = ENTRY(3,user_env[25])
  s_type  = ENTRY(4,user_env[25])
  s_qual  = ENTRY(5,user_env[25]).
else if user_dbtype <> "ORACLE" 
then assign /* oracle-routine inits these values by itself */
  s_name  = "*"
  s_owner = (IF "{&frame}" = "frm_as400" THEN s_owner ELSE "*")
  s_type  = "*"
  s_qual  = "*".

assign
  s_vrfy  = (user_env[25] begins "COMPARE"
          or user_env[25] begins "auto-compare").

if NOT user_env[25] begins "AUTO"
 then do:  /* allow user to update preselection-criterias */
   
  RUN prodict/user/_usr_gsl.p
    ( INPUT-OUTPUT s_name,
      INPUT-OUTPUT s_owner,
      INPUT-OUTPUT s_qual,
      INPUT-OUTPUT s_type,
      INPUT-OUTPUT s_vrfy,
      INPUT-OUTPUT s_outf,
      INPUT-OUTPUT s_datetime,
      INPUT-OUTPUT s_lob,
      INPUT-OUTPUT s_wildcard,
      INPUT        "{&frame}",
      INPUT        {&link},
      INPUT        {&master}
      
    ).

  IF RETURN-VALUE = "cancel"
   then do:
    &IF "{&block}" <> ""
     &THEN
      assign l_rep-presel = FALSE.
     &ENDIF
    assign user_path = "".
    LEAVE {&block}.
    end.

  end.     /* allow user to update preselection-citerias */


/*------------------------------------------------------------------*/        
