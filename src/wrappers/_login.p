/*********************************************************************
* Copyright (C) 2000,2011 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/******************************************************************************* 
*
*   PROGRAM:  _login.p
*
*   PROGRAM SUMMARY:
*       Prompt user for userid and password and set the userid.
*       Caller must include login.i NEW.
*
*   RUN/CALL SYNTAX:
*       { login.i NEW }
*       RUN login.p
* 
*   PARAMETERS/ARGUMENTS LIST:
*       None
*
*******************************************************************************/

     
DEFINE INPUT PARAMETER viewAsDialog AS LOGICAL NO-UNDO.
 
{ login.i }
DEFINE VARIABLE tries     AS INTEGER NO-UNDO.
DEFINE VARIABLE lFound    AS LOGICAL NO-UNDO.
DEFINE VARIABLE hCP       AS HANDLE  NO-UNDO.
DEFINE VARIABLE setdbclnt AS LOGICAL NO-UNDO.
define variable cUserid   as character no-undo.

IF USERID("DICTDB") <> ""  THEN 
    RETURN.

if integer(dbversion("DICTDB")) > 10 then 
do:
    find first  dictdb._sec-authentication-domain 
         where (dictdb._sec-authentication-domain._Domain-enabled = yes 
           and  dictdb._sec-authentication-domain._Domain-id > -1 and
                dictdb._sec-authentication-domain._Domain-type = "_oeusertable") no-error.
    if available(dictdb._sec-authentication-domain) then
    do on error undo, throw:
        lFound = buffer dictdb._user:find-first("WHERE dictdb._User._sql-only-user = FALSE") .
        catch e as Progress.Lang.Error : 
            /* 138 means no ABL user record found.  
               Otherwise we assume readpermission error due to disallow blank user access in which 
               case we assume a prompt is needed (disallow blank user access cannot be set by blank uer) */
            lFound = e:GetMessageNum(1) <> 138.
        end catch.                  
    end.
    if not lFound then 
    do:
        for each dictdb._sec-authentication-domain 
                 where (dictdb._sec-authentication-domain._Domain-enabled = yes 
                   and  dictdb._sec-authentication-domain._Domain-type <> "_oeusertable" 
                   and  dictdb._sec-authentication-domain._Domain-id > -1 ): 
            find dictdb._sec-authentication-system of dictdb._sec-authentication-domain 
                 where (dictdb._sec-authentication-system._PAM-plug-in = yes ).
            lFound = yes.
            leave.
            catch e as Progress.Lang.Error :
                /* 138 means no record, we could get readpermission error on which case we
                   assume a prompt is needed  */ 
                if e:GetMessageNum(1) <> 138 then 
                do:
                    lFound = yes.
                    leave.
                end.                		
            end catch.                  
        end.
    end.
    
    if lFound = false then 
        return.
end.
else if not can-find(first DICTDB._User) then
    return.
    
create client-principal hCP. /* create a CLIENT-PRINCIPAL only once during login*/
    
DO ON ENDKEY UNDO, LEAVE:
    currentdb = LDBNAME("DICTDB").

    /* reset id and password to blank in case of retry */
    ASSIGN id = ""
           domain = ""
           password = "".
 
    if viewAsDialog then 
    do:

      DISPLAY currentdb WITH FRAME logindb_frame view-as dialog-box.

      UPDATE id password domain ok_btn cancel_btn help_btn {&WHEN_HELP}
             WITH FRAME logindb_frame view-as dialog-box.
    end.
    else do:
      DISPLAY currentdb WITH FRAME login_frame.

      UPDATE id password domain ok_btn cancel_btn help_btn {&WHEN_HELP}
             WITH FRAME login_frame.
    end.
    cUserid = id 
            + if domain = "" then "" else "@" + domain.
     
    /* Use SET-DB-CLIENT instead of SETUSERID */ 
    hCP:initialize(cUserid,?,?,password).
    
    setdbclnt = set-db-client(hCP,currentdb) NO-ERROR. 
    if NOT setdbclnt THEN 
    DO:
        MESSAGE "Userid/Password is incorrect."
                VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        IF tries > 1 THEN 
            QUIT. /* only allow 3 tries*/
        tries = tries + 1.
        UNDO, RETRY.
    END.     
        
           
END.

delete object hCP.
hcp = ?.
 
HIDE FRAME login_frame.


