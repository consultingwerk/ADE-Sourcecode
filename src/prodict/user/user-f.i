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

/*
-------------------------------------------------------------------------------
TABLE-TRIGGERS:
---------------

                                                               Override- Check
                        Trigger Programs                       able	 CRC?
    
             for CREATE: ____________________________________   ___	  __ 
             for DELETE: ____________________________________   ___	  __ 
               for FIND: ____________________________________   ___	  __ 
              for WRITE: ____________________________________   ___	  __ 
 for REPLICATION-CREATE: ____________________________________   ___	  __ 
 for REPLICATION-DELETE: ____________________________________   ___	  __ 
  for REPLICATION-WRITE: ____________________________________   ___	  __ 

[^Description] [^Validation]         (press [PUT] to edit trigger source)
-------------------------------------------------------------------------------
*/

FORM
  "Override-"	      at 62 view-as TEXT 
  "Check"	      at 73 view-as TEXT  SKIP
  "Trigger Programs"  at 26 view-as TEXT 
  "able?"	      at 62 view-as TEXT 
  "CRC?"	      at 73 view-as TEXT  SKIP(1)

  pname[1]    at 2 FORMAT "x(100)" ATTR-SPACE LABEL "            For CREATE" 
              view-as fill-in size 33 by 1
  override[1] at 62 ATTR-SPACE NO-LABEL 
  crc[1]      at 73 ATTR-SPACE NO-LABEL  SKIP

  pname[2]    at 2 FORMAT "x(100)" ATTR-SPACE LABEL "            For DELETE"
              view-as fill-in size 33 by 1 
  override[2] at 62 ATTR-SPACE NO-LABEL
  crc[2]      at 73 ATTR-SPACE NO-LABEL  SKIP

  pname[3]    at 2 FORMAT "x(100)" ATTR-SPACE LABEL "              For FIND" 
              view-as fill-in size 33 by 1
  override[3] at 62 ATTR-SPACE NO-LABEL 
  crc[3]      at 73 ATTR-SPACE NO-LABEL  SKIP

  pname[4]    at 2 FORMAT "x(100)" ATTR-SPACE LABEL "             For WRITE"
              view-as fill-in size 33 by 1 
  override[4] at 62 ATTR-SPACE NO-LABEL 
  crc[4]      at 73 ATTR-SPACE NO-LABEL  SKIP

  pname[5]    at 2 FORMAT "x(100)" ATTR-SPACE LABEL "For REPLICATION-CREATE"
              view-as fill-in size 33 by 1 
  override[5] at 62 ATTR-SPACE NO-LABEL 
  crc[5]      at 73 ATTR-SPACE NO-LABEL  SKIP

  pname[6]    at 2 FORMAT "x(100)" ATTR-SPACE LABEL "For REPLICATION-DELETE"
              view-as fill-in size 33 by 1 
  override[6] at 62 ATTR-SPACE NO-LABEL 
  crc[6]      at 73 ATTR-SPACE NO-LABEL  SKIP

  pname[7]    at 2 FORMAT "x(100)" ATTR-SPACE LABEL " For REPLICATION-WRITE"
              view-as fill-in size 33 by 1 
  override[7] at 62 ATTR-SPACE NO-LABEL 
  crc[7]      at 73 ATTR-SPACE NO-LABEL  SKIP

  SPACE(12) "(removing the trigger file name deletes the trigger)" SKIP
  SPACE(12) do-get FORMAT "x(45)" NO-LABEL 

  {prodict/user/userbtns.i}
  WITH FRAME frame-f
    NO-ATTR-SPACE SIDE-LABELS SCROLLABLE
    VIEW-AS DIALOG-BOX TITLE "Table Triggers"
    ROW 2 COLUMN 1.

{adecomm/okrun.i  
   &BOX    = "rect_Btns"
   &FRAME  = "FRAME frame-f"
   &OK     = "btn_OK"
   &CANCEL = "btn_Cancel"}


DEFINE VAR committed AS LOGICAL NO-UNDO.

/*=========================Internal Procedures=============================*/

PROCEDURE Tbl_Triggers:
   /* See if the table we are adding/editing is committed to the
      database yet.  If we're adding, we know it's not committed.  
      On edit, we have a problem if the user is renaming the table. 
   */
   committed = (IF adding THEN no else 
      	        IF wfil._File-name <> INPUT FRAME frame-d wfil._File-name 
      	       	  then no else yes).

  VIEW FRAME frame-f.

  ASSIGN
    pname = ""
    override = no
    crc = committed  /* if trig won't compile no else yes */
    old_crc_val = ?.

  DO i = 1 TO 7:
    FIND FIRST wfit WHERE wfit._Event = events[i] NO-ERROR.
    IF AVAILABLE wfit THEN 
      ASSIGN
    	pname[i]	= wfit._Proc-name
    	override[i]	= wfit._Override
    	crc[i]	     	= (if wfit._Trig-CRC = ? then no else yes)
    	old_crc_val[i] 	= wfit._Trig-CRC.

    new_crc_val[i] = old_crc_val[i].
  END.
     
  IF romode = 0 THEN
    HIDE MESSAGE NO-PAUSE.

  DISPLAY
    pname[1] override[1] crc[1]
    pname[2] override[2] crc[2]
    pname[3] override[3] crc[3]
    pname[4] override[4] crc[4]
    pname[5] override[5] crc[5]
    pname[6] override[6] crc[6]
    pname[7] override[7] crc[7]
    do-get WHEN romode = 0
    WITH FRAME frame-f.

  UPDATE
    pname[1] WHEN romode =0 override[1] WHEN romode =0 crc[1] WHEN romode=0
    pname[2] WHEN romode =0 override[2] WHEN romode =0 crc[2] WHEN romode=0
    pname[3] WHEN romode =0 override[3] WHEN romode =0 crc[3] WHEN romode=0
    pname[4] WHEN romode =0 override[4] WHEN romode =0 crc[4] WHEN romode=0
    pname[5] WHEN romode =0 override[5] WHEN romode =0 crc[5] WHEN romode=0
    pname[6] WHEN romode =0 override[6] WHEN romode =0 crc[6] WHEN romode=0
    pname[7] WHEN romode =0 override[7] WHEN romode =0 crc[7] WHEN romode=0
    btn_OK btn_Cancel
    WITH FRAME frame-f.
END.

/*----------------------------------------------------------------
   Dispatch to editing trigger code sub-dialog.

   Note: I should be able to just pass in the event index for
   all the pieces (pname, events, crc and new_crc_val) but 
   using indexes on widget arrays doesn't work real well in 
   Progress!
----------------------------------------------------------------*/
PROCEDURE Edit_Trig_Code:
   DEFINE INPUT PARAMETER ev_ix  AS INTEGER   	  NO-UNDO.  /* event index */   
   DEFINE INPUT PARAMETER w_crc  AS WIDGET-HANDLE NO-UNDO.
   DEFINE INPUT PARAMETER p_name AS CHAR          NO-UNDO. 

   DEFINE VAR crc_val AS LOGICAL NO-UNDO.

   crc_val = (IF w_crc:SCREEN-VALUE = "yes" THEN yes ELSE no).

   /* In case they hit "PUT" before leaving the crc field */
   if crc_val AND NOT committed THEN 
   DO:
      /* It won't compile so put up error and reset crc to no */
     { prodict/user/usertrgw.i &widg = w_crc } 
   END.

   /* check syntax can be determined by user except: if not committed
      so trigger won't compile then no, and if user requests
      crc checking than they must compile.  This determines 5th 
      input parameter.
   */
   check_syntax = (IF NOT committed THEN no ELSE check_syntax OR crc_val).
   RUN "prodict/user/_usrtrig.p"
      (INPUT p_name,
       INPUT events[ev_ix],
       INPUT wfil._File-Name:SCREEN-VALUE IN FRAME frame-d, 
       INPUT "",
       INPUT (NOT committed) OR crc_val,
       INPUT-OUTPUT new_crc_val[ev_ix],
       INPUT-OUTPUT check_syntax).
END.

/*===============================Triggers=================================*/

/*----- PUT FROM ANY TRIGGER FRAME FIELD-----*/
ON PUT OF pname[1] IN FRAME frame-f,
          override[1] IN FRAME frame-f,
      	  crc[1] IN FRAME frame-f
DO:
   pname[1]:SCREEN-VALUE IN FRAME frame-f = 
      TRIM(pname[1]:SCREEN-VALUE IN FRAME frame-f).

   RUN Edit_Trig_Code (INPUT 1, 
      	       	       INPUT crc[1]:HANDLE IN FRAME frame-f,
      	       	       INPUT FRAME frame-f pname[1]). 
END.

ON PUT OF pname[2] IN FRAME frame-f,
          override[2] IN FRAME frame-f,
      	  crc[2] IN FRAME frame-f
DO:
   pname[2]:SCREEN-VALUE IN FRAME frame-f = 
      TRIM(pname[2]:SCREEN-VALUE IN FRAME frame-f).

   RUN Edit_Trig_Code (INPUT 2, 
      	       	       INPUT crc[2]:HANDLE IN FRAME frame-f,
      	       	       INPUT FRAME frame-f pname[2]). 
END.

ON PUT OF pname[3] IN FRAME frame-f,
          override[3] IN FRAME frame-f,
      	  crc[3] IN FRAME frame-f
DO:
   pname[3]:SCREEN-VALUE IN FRAME frame-f = 
      TRIM(pname[3]:SCREEN-VALUE IN FRAME frame-f).

   RUN Edit_Trig_Code (INPUT 3, 
      	       	       INPUT crc[3]:HANDLE IN FRAME frame-f,
      	       	       INPUT FRAME frame-f pname[3]). 
END.

ON PUT OF pname[4] IN FRAME frame-f,
          override[4] IN FRAME frame-f,
      	  crc[4] IN FRAME frame-f
DO:
   pname[4]:SCREEN-VALUE IN FRAME frame-f = 
      TRIM(pname[4]:SCREEN-VALUE IN FRAME frame-f).

   RUN Edit_Trig_Code (INPUT 4, 
      	       	       INPUT crc[4]:HANDLE IN FRAME frame-f,
      	       	       INPUT FRAME frame-f pname[4]). 
END.

ON PUT OF pname[5] IN FRAME frame-f,
          override[5] IN FRAME frame-f,
      	  crc[5] IN FRAME frame-f
DO:
   pname[5]:SCREEN-VALUE IN FRAME frame-f = 
      TRIM(pname[5]:SCREEN-VALUE IN FRAME frame-f).

   RUN Edit_Trig_Code (INPUT 5, 
      	       	       INPUT crc[5]:HANDLE IN FRAME frame-f,
      	       	       INPUT FRAME frame-f pname[5]). 
END.

ON PUT OF pname[6] IN FRAME frame-f,
          override[6] IN FRAME frame-f,
      	  crc[6] IN FRAME frame-f
DO:
   pname[6]:SCREEN-VALUE IN FRAME frame-f = 
      TRIM(pname[6]:SCREEN-VALUE IN FRAME frame-f).

   RUN Edit_Trig_Code (INPUT 6, 
      	       	       INPUT crc[6]:HANDLE IN FRAME frame-f,
      	       	       INPUT FRAME frame-f pname[6]). 
END.

ON PUT OF pname[7] IN FRAME frame-f,
          override[7] IN FRAME frame-f,
      	  crc[7] IN FRAME frame-f
DO:
   pname[7]:SCREEN-VALUE IN FRAME frame-f = 
      TRIM(pname[7]:SCREEN-VALUE IN FRAME frame-f).

   RUN Edit_Trig_Code (INPUT 7, 
      	       	       INPUT crc[7]:HANDLE IN FRAME frame-f,
      	       	       INPUT FRAME frame-f pname[7]). 
END.

/*----- GO or OK of TRIGGER FRAME -----*/
ON GO OF FRAME frame-f
DO:
   pname[1]:SCREEN-VALUE IN FRAME frame-f = 
      TRIM(pname[1]:SCREEN-VALUE IN FRAME frame-f).
   pname[2]:SCREEN-VALUE IN FRAME frame-f = 
      TRIM(pname[2]:SCREEN-VALUE IN FRAME frame-f).
   pname[3]:SCREEN-VALUE IN FRAME frame-f = 
      TRIM(pname[3]:SCREEN-VALUE IN FRAME frame-f).
   pname[4]:SCREEN-VALUE IN FRAME frame-f = 
      TRIM(pname[4]:SCREEN-VALUE IN FRAME frame-f).
   pname[5]:SCREEN-VALUE IN FRAME frame-f = 
      TRIM(pname[5]:SCREEN-VALUE IN FRAME frame-f).
   pname[6]:SCREEN-VALUE IN FRAME frame-f = 
      TRIM(pname[6]:SCREEN-VALUE IN FRAME frame-f).
   pname[7]:SCREEN-VALUE IN FRAME frame-f = 
      TRIM(pname[7]:SCREEN-VALUE IN FRAME frame-f).

   DO i = 1 TO 7:
      {prodict/user/usertrig.i
         &Frame	      = "FRAME frame-f"
         &pname	      = "pname[i]"
         &override    = "override[i]"
         &crc	      = "crc[i]"
         &new_crc_val = "new_crc_val[i]"
         &old_crc_val = "old_crc_val[i]"
         &changed     = touched}
   END.

   /* replace altered trigger definitions */
   DO ON ERROR UNDO, LEAVE:
     DO i = 1 TO 7:
        pname[i] = INPUT FRAME frame-f pname[i].
        FIND FIRST wfit WHERE wfit._Event = events[i] NO-ERROR.
        IF (pname[i] = "" OR pname[i] = ?) AND AVAILABLE wfit THEN
          DELETE wfit.
        IF pname[i] <> "" AND pname[i] <> ? AND NOT AVAILABLE wfit THEN
          CREATE wfit.
        IF AVAILABLE wfit THEN 
        DO:
          ASSIGN
            wfit._Event = events[i]
            wfit._Proc-Name = pname[i]
            wfit._Override  = INPUT FRAME frame-f override[i]
            wfit._Trig-CRC = (IF INPUT FRAME frame-f crc[i] 
      			THEN new_crc_val[i] ELSE ?).
        END.
     END.
     RETURN.
   END.

   /* There was an error */
   RETURN NO-APPLY.
END.

/*----- VALUE-CHANGED of CHECK CRC TOGGLE -----*/
on leave of crc[1],crc[2],crc[3],crc[4],crc[5],crc[6],crc[7] in frame frame-f
do:
   /* If user wants to check crc and it was not on before
      he must compile before saving.  Make sure compile can succeed.
   */
   if SELF:screen-value = "yes" AND NOT committed then
   do:
      /* It won't compile so put up error and reset crc to no */
      { prodict/user/usertrgw.i &widg = SELF }
   end.
end.





