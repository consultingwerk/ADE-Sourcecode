/* fixloginfilename.p
   This program checks the gsc_security_control record for the login_filename 
   field. If the field is set to "af/cod/gsmuslognw.w", we replace the value
   with "af/cod2/aftemlognw.w" */
   
   DO TRANSACTION:
     FIND FIRST gsc_security_control EXCLUSIVE-LOCK
       NO-ERROR.

     IF AVAILABLE(gsc_security_control) AND
        gsc_security_control.login_filename = "af/cod/gsmuslognw.w":U THEN
     DO:
       ASSIGN
         gsc_security_control.login_filename = "af/cod2/aftemlognw.w":U
       .
       PUBLISH "DCU_WriteLog":U ("gsc_security_control.login_filename changed from 'af/cod/gsmuslognw.w' to 'af/cod2/aftemlognw.w'.").
     END.
   END.

