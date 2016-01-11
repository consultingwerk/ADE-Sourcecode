/*************************************************************/
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/

/*----------------------------------------------------------------------------

File: _savdbprop.p

Description:
   Save any changes the user made in the db property window. 

Returns: "error" if the save is not complete for any reason, otherwise "".

Author: Fernando de Souza

Date Created: 05/24/2005
    Modified: 

----------------------------------------------------------------------------*/
&GLOBAL-DEFINE WIN95-BTN YES
{adedict/dictvar.i shared}
{adedict/menu.i shared}
{adedict/uivar.i shared}
{adedict/DB/dbvar.i shared}

DEFINE VARIABLE changed          AS LOGICAL       NO-UNDO INITIAL NO.
DEFINE VARIABLE new-description AS CHARACTER NO-UNDO.
DEFINE VARIABLE new-add-details AS CHARACTER NO-UNDO.

/* check if the field is enabled for input. If not, just return. */
IF NOT s_Db_Description:sensitive in frame dbprops THEN
    return "".

DEFINE VAR hBuffer AS HANDLE NO-UNDO.

do ON ERROR UNDO, LEAVE  ON STOP UNDO, LEAVE:

   run adecomm/_setcurs.p ("WAIT").

   /* find the _db record */
   find dictdb._db where recid(dictdb._db) = s_DbRecId NO-LOCK NO-ERROR.
   
   /* find the _db-detail record for this _db record */
   CREATE BUFFER hBuffer FOR TABLE "DICTDB._Db-detail" NO-ERROR.

   IF VALID-HANDLE(hBuffer) THEN
       hBuffer:FIND-FIRST ("where _db-guid = " + QUOTER(dictdb._db._db-guid) ) NO-ERROR.

   /* get the values from the screen buffer */
   ASSIGN new-description = INPUT FRAME dbprops s_db_description
                new-add-details = INPUT FRAME dbprops s_Db_Add_Details.

   /* check if the value has changed and update them */
   IF hBuffer::_Db-description <>  new-description  THEN DO:
       ASSIGN changed = YES
                    hBuffer::_Db-description =  new-description.
   END.

   IF hBuffer::_Db-custom-detail <>  new-add-details  THEN DO:
       ASSIGN changed = YES
                    hBuffer::_Db-custom-detail = new-add-details.
   END.

   DELETE OBJECT hBuffer.

   /* if the user changed anything, set the dirty flag */
   IF changed THEN
       {adedict/setdirty.i &Dirty = "true"}.

   run adecomm/_setcurs.p ("").
   return "".
end.

run adecomm/_setcurs.p ("").
return "error".



