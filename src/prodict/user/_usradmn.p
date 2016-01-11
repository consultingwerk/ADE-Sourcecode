/***********************************************************************
* Copyright (C) 2000,2006,2008 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/

/* Progress Lex Converter 7.1A->7.1B Version 1.11 */

/* useradmn - set Security Administrators */

using OpenEdge.DataAdmin.DataAdminService from propath.
using OpenEdge.DataAdmin.IAdministrator from propath.
 
{ prodict/dictvar.i }
{ prodict/user/uservar.i }

DEFINE VARIABLE ans         AS LOGICAL             NO-UNDO.
DEFINE VARIABLE canned      AS LOGICAL   INIT TRUE NO-UNDO.
DEFINE VARIABLE i           AS INTEGER             NO-UNDO.
DEFINE VARIABLE j           AS INTEGER             NO-UNDO.
DEFINE VARIABLE mass        AS CHARACTER           NO-UNDO.
DEFINE VARIABLE msg-num     AS INTEGER   INITIAL 0 NO-UNDO.
DEFINE VARIABLE orig        AS CHARACTER           NO-UNDO.
DEFINE VARIABLE security    AS CHARACTER EXTENT  4 NO-UNDO.
DEFINE VARIABLE user-exists AS LOGICAL             NO-UNDO.
DEFINE VARIABLE msgSecuAdm AS CHAR VIEW-AS EDITOR NO-BOX INNER-CHARS 52 INNER-LINES 1 NO-UNDO.
DEFINE VARIABLE instrSecu1 AS CHAR VIEW-AS EDITOR NO-BOX INNER-CHARS 20 INNER-LINES 7 NO-UNDO.
DEFINE VARIABLE instrSecu2 AS CHAR VIEW-AS EDITOR NO-BOX INNER-CHARS 52 INNER-LINES 7 NO-UNDO.
DEFINE VARIABLE instrSecu3 AS CHAR VIEW-AS EDITOR NO-BOX INNER-CHARS 72 INNER-LINES 1 NO-UNDO.
DEFINE VARIABLE cr AS CHARACTER NO-UNDO.

define variable administrator       as  IAdministrator no-undo.
define variable service             as  DataAdminService no-undo.

/* LANGUAGE DEPENDENCIES START */ /*----------------------------------------*/
DEFINE VARIABLE new_lang AS CHARACTER EXTENT 7 NO-UNDO INITIAL [
  /* 1*/ "This function only works on {&PRO_DISPLAY_NAME} databases.",
  /* 2*/ "You may not use this function with a blank userid.",
  /* 3*/ "You must be a Security Administrator to execute this function.",
  /* 4*/ "You cannot change a security field to exclude yourself.",
  /* 5*/ "At least one security-administrator must be defined as a user.",
  /* 6*/ "Are you sure that you want to make this change?",
  /* 7*/ "The dictionary is in read-only mode - alterations not allowed."
].

FORM 
  SKIP({&TFM_WID})
&IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN 
  msgSecuAdm NO-LABEL AT 2 SKIP
&ELSE
  "Enter login ids to control who can change security.      " AT 2 SKIP
&ENDIF
  security[1] FORMAT "x(63)" {&STDPH_FILL}    	        AT 2 SKIP({&VM_WID})
  security[2] FORMAT "x(63)" {&STDPH_FILL}     	      	AT 2 SKIP({&VM_WID})
  security[3] FORMAT "x(63)" {&STDPH_FILL}    	      	AT 2 SKIP({&VM_WID})
  security[4] FORMAT "x(63)" {&STDPH_FILL}    	        AT 2 SKIP({&VM_WIDG})
&IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN 
  instrSecu1 NO-LABEL at 2
  instrSecu2 NO-LABEL at ROW-OF instrSecu1 COLUMN 24 SKIP
  instrSecu3 NO-LABEL at 2
&ELSE
  {prodict/user/usersecu.i}  /* instructions */
&ENDIF
  {prodict/user/userbtns.i}
  WITH FRAME security 
&IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN 
      CENTERED THREE-D
&ELSE
      ROW 2
&ENDIF
      NO-LABELS ATTR-SPACE 
      DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
      VIEW-AS DIALOG-BOX TITLE "Security Administrators".

&IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
  ASSIGN msgSecuAdm:SCREEN-VALUE =
     "Enter login ids to control who can change security.".
  msgSecuAdm:READ-ONLY = yes.
  
  cr = chr(10).
  
  ASSIGN instrSecu1:SCREEN-VALUE =
  "Examples:" + cr +
  "" +  cr +
  "*" +  cr +
  "<user>,<user>,etc." + cr +
  "!<user>,!<user>,*" + cr +
  "acct*" + cr +
  "" + cr.
  
  ASSIGN instrSecu3:SCREEN-VALUE =
    "Note: Spaces used in the permission string will be taken literally.".
  /*"Do not use spaces in the string (they will be taken literally).".*/
  
  ASSIGN instrSecu2:SCREEN-VALUE =
  "" +  cr +
  "" +  cr +
  " -  All users (login Ids) are allowed access." +  cr +
  "-  Only these users have access." + cr +
  "-  All except these users have access." + cr +
  "-  Only users that begin with ~"acct~" allowed." + cr +
  "".
  
  instrSecu1:READ-ONLY = yes.
  instrSecu2:READ-ONLY = yes.
  instrSecu3:READ-ONLY = yes.
&ENDIF
  
/* LANGUAGE DEPENDENCIES END */ /*------------------------------------------*/


/*===============================Triggers=================================*/

&IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN 
/*----- HELP -----*/
on HELP of frame security
   or CHOOSE of btn_Help in frame security
   RUN "adecomm/_adehelp.p" (INPUT "admn", INPUT "CONTEXT", 
      	       	     	     INPUT {&Security_Administrators_Dlg_Box},
      	       	     	     INPUT ?).
&ENDIF


ON GO OF FRAME security
DO:
  ASSIGN
    INPUT FRAME security security[1] 
    INPUT FRAME security security[2] 
    INPUT FRAME security security[3] 
    INPUT FRAME security security[4].   

  ASSIGN
    user-exists = TRUE
    mass        = security[1] + "," + security[2] + ","
                + security[3] + "," + security[4]
    i           = INDEX(mass,",,").

  DO WHILE i > 0:
    ASSIGN
      mass = SUBSTRING(mass,1,i) + SUBSTRING(mass,i + 2)
      i    = INDEX(mass,",,").
  END.
  DO WHILE (LENGTH(mass) > 0) AND SUBSTRING(mass,LENGTH(mass),1) = ",":
    mass = SUBSTRING(mass,1,LENGTH(mass) - 1).
  END.
  
  IF mass <> orig THEN 
  DO:
    ans = FALSE.
    MESSAGE new_lang[6] 
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE ans.
    IF NOT ans THEN RETURN NO-APPLY.
  END.
  
  administrator:Administrators = mass.
  service:UpdateAdministrator(administrator).
  
  catch e as Progress.Lang.Error :
        
      if  e:GetMessageNum(1) > 0 and e:GetMessageNum(1) < 8 then
           message
               new_lang[e:GetMessageNum(1)] 
               VIEW-AS ALERT-BOX ERROR BUTTONS OK.
      else  
          message               
                e:GetMessageNum(1)
                VIEW-AS ALERT-BOX ERROR BUTTONS OK.
                
      APPLY "ENTRY" TO security[1] IN FRAME security.
      RETURN NO-APPLY.          
  end catch.
END.

ON WINDOW-CLOSE OF FRAME security
   APPLY "END-ERROR" TO FRAME security.

/*============================Mainline code===============================*/

&IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
  ENABLE msgSecuAdm instrSecu1 instrSecu2 InstrSecu3 WITH FRAME security.
&ENDIF

service = new DataAdminService(ldbname("DICTDB")).
do on error undo, throw:
    
    /* note: can probably be removed as the AdministratorSource checks dbtype("dictdb") */
    IF user_dbtype <> "PROGRESS" THEN 
        undo, throw new Progress.Lang.AppError(new_lang[1],1). /* dbtype okay */

    administrator = service:GetAdministrator().
   
    catch e as Progress.Lang.Error :
        
        if  e:GetMessageNum(1) > 0 and e:GetMessageNum(1) < 8 then
            message
                new_lang[e:GetMessageNum(1)] 
                VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        else  
            message               
                e:GetMessageNum(1)
                VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        user_path = "".
        RETURN.            
    end catch.
 
end.
 
ASSIGN
  security    = ""
  security[1] = administrator:Administrators
  orig        = administrator:Administrators.
DO j = 1 TO 3:
  IF LENGTH(security[j]) > 63 THEN DO:
    IF SUBSTRING(security[j],64,1) = "," THEN
      ASSIGN security[j + 1 ] = SUBSTRING(security[j], 65)
             security[j] = SUBSTRING(security[j], 1, 63).
    ELSE
      ASSIGN security[j + 1 ] = SUBSTRING(security[j], 64)
             security[j] = SUBSTRING(security[j], 1, 63)
             i = R-INDEX(security[j], ",")
             security[j + 1] = SUBSTRING(security[j],i + 1) + security[j + 1]
             security[j    ] = SUBSTRING(security[j],1,i - 1).
  END.
  ELSE
    ASSIGN j = 3.
END.

/* Adjust the graphical rectangle and the ok and cancel buttons */
{adecomm/okrun.i  
    &FRAME  = "FRAME security" 
    &BOX    = "rect_Btns"
    &OK     = "btn_OK" 
    {&CAN_BTN}
    {&HLP_BTN}
}

DO ON ENDKEY UNDO,LEAVE ON ERROR UNDO, LEAVE:
  PAUSE 0.
  UPDATE security btn_OK btn_Cancel {&HLP_BTN_NAME}
      	 WITH FRAME security.
  canned = FALSE.
END.

HIDE FRAME security NO-PAUSE.
IF canned THEN
  user_path = "".
RETURN.
finally:
    delete object service no-error.		
end finally.


