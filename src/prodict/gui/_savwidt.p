/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _savefld.p

Description:
   Save any changes the user made in the field property window.

Author: Mario Brunetti

Date Created: 04/02/99

-----------------------------------------------------------------------------*/

/*--------------------------------- Definitions -----------------------------*/
&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
&GLOBAL-DEFINE WIN95-BTN YES
{adedict/dictvar.i shared}
{adedict/brwvar.i shared}
{adedict/menu.i shared}
{adedict/uivar.i shared}
{adecomm/cbvar.i shared}
&ELSE
{prodict/dictvar.i}  /* automatically shared unless "new" is passed in char */
&ENDIF
{prodict/gui/widthvar.i shared}

DEF VAR rows-changed AS LOGICAL NO-UNDO.
DEF VAR ret-val      AS CHAR    NO-UNDO.

RUN adecomm/_setcurs.p (INPUT "WAIT").

/*--------------------------------- Mainline Code ----------------------------*/
width-subtran:
DO ON ERROR UNDO, LEAVE
   ON STOP  UNDO, LEAVE:
    
   save-changed: 
   FOR EACH w_Field:
  
      FIND _Field WHERE 
         _Field._File-Recid = w_Field._File-Recid AND
         _Field._Field-Name = w_Field._Field-NAME
      EXCLUSIVE-LOCK NO-ERROR.   
      IF NOT AVAIL _Field THEN
      DO:
         MESSAGE "A row that was changed has since been deleted." SKIP
                 "Changes will be backed out.  Please click OK." 
         VIEW-AS ALERT-BOX.
         ret-val = "error".
         RUN adecomm/_setcurs.p (INPUT "").
         UNDO, LEAVE width-subtran.
         /* I don't like the above either,                           *
          * but it's backward compatable with the existing code base */
      END.
      IF _Field._Width = w_Field._Width THEN NEXT save-changed.
      ASSIGN _Field._Width = w_Field._Width
             rows-changed = YES.
   END.

   IF rows-changed THEN
   DO:
      &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
         dict_dirty = YES.
      &ELSE
         {adedict/setdirty.i &Dirty = "true"}
      &ENDIF
   END.
       
END.

RUN adecomm/_setcurs.p (INPUT "").

RETURN ret-val.
