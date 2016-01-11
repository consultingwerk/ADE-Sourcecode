/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* _anykey.p

    This looks wierd but it really does make sense!

    This routine will be run from ON ANYKEY persistent trigger on the fields
    in Form view.  (Because the trigger is persistent the body must be in a 
    separate .p - i.e. this one).  The whole point of this is to get around
    the GUI anomaly that in order to make a field moveable, it must be
    made sensitive as well.  This unfortunately makes it editable which is
    very misleading in Form View.  In order to really edit those fields the
    user must hit the Update button and proceed from there.

    This will act like a NO-APPLY from the ANYKEY trigger, which will block
    the editing from happening.
*/

RETURN ERROR.
