/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _dbprop.p

Description:
   Display database properties for the current db in the prop window.

Author: Laura Stern

Date Created: 12/04/92

History:
    tomn    01/10/96    Added codepage to DB Properties form (s_Db _Cp)
    
    fernando 05/24/2005 Added db-description and custom-details to the DB Properties form. Accessing
                                  the _Db record with a dynamic buffer now
    
----------------------------------------------------------------------------*/
&GLOBAL-DEFINE WIN95-BTN YES

{adedict/dictvar.i shared}
{adedict/uivar.i shared}
{adedict/DB/dbvar.i shared}

DEFINE VARIABLE has_db_detail      AS LOGICAL NO-UNDO INITIAL NO.
DEFINE VARIABLE hBuffer_DB          AS HANDLE NO-UNDO.
DEFINE VARIABLE hBuffer_DB-detail AS HANDLE NO-UNDO.

/* create a buffer for _Db because the _db-guid field is not present on a non-upgraded db (pre-10.1A) */
CREATE BUFFER hBuffer_DB FOR TABLE "DICTDB._Db" NO-ERROR.

hBuffer_DB:FIND-FIRST ("where  recid(dictdb._db) = " + STRING(s_DbRecId), NO-LOCK) NO-ERROR.

/* check if we can find the _db-detail table */
FIND FIRST dictdb._file WHERE dictdb._file._file-name = "_db-detail":U NO-LOCK NO-ERROR.

IF hBuffer_DB:AVAILABLE THEN DO:
                                                                   
    /* create a dynamic buffer to try to find the record. If this is a pre-101a db or the schema was not
       upgraded, then this table won't exist, so can't add static reference to it 
    */
    CREATE BUFFER hBuffer_DB-detail FOR TABLE "DICTDB._Db-detail" NO-ERROR.
    
    IF VALID-HANDLE(hBuffer_DB-detail) THEN DO:
    
        /* try to find the db-detail record */
        hBuffer_DB-detail:FIND-FIRST("where _db-guid = " + QUOTER(hBuffer_DB::_db-guid),NO-LOCK) NO-ERROR.

        IF hBuffer_DB-detail:AVAILABLE THEN
            ASSIGN has_db_detail = YES.

    END.

END.

assign
   s_Db_PName  = s_DbCache_Pname[s_DbCache_ix]
   s_Db_Holder = s_DbCache_Holder[s_DbCache_ix]
   s_Db_Type   = s_DbCache_Type[s_DbCache_ix]
   s_Db_Cp     = if hBuffer_DB:AVAILABLE then hBuffer_DB::_db-xl-name else "".

/* if we have data in the db-detail record to display, assign it now */
IF has_db_detail AND VALID-HANDLE( hBuffer_DB-detail) THEN DO:
    
    ASSIGN
        s_db_description = hBuffer_DB-detail::_Db-description
        s_Db_Add_Details = hBuffer_DB-detail::_Db-custom-detail.

    /* don't need the dynamic buffer anymore */
    DELETE OBJECT hBuffer_DB-detail.
    ASSIGN hBuffer_DB-detail= ?.
END.
ELSE
    ASSIGN s_db_description = "":U
                 s_Db_Add_Details = "".

DELETE OBJECT hBuffer_DB.

/* Run time layout for button area.  Only do this the first time. */
if frame dbprops:private-data <> "alive" then
do:
   /* okrun.i widens frame by 1 for margin */
   assign
      frame dbprops:private-data = "alive"
      s_win_Db:width = s_win_Db:width + 1.  

   {adecomm/okrun.i  
      &FRAME = "frame dbprops" 
      &BOX   = "s_rect_Btns"
      &OK    = "s_btn_OK" 
      &HELP  = "s_btn_Help"
   }
end.

display s_CurrDb
	s_Db_Pname
	s_Db_Holder
        s_Db_Type
        s_Db_Cp
    s_db_description
    s_Db_Add_Details
	with frame dbprops.

enable s_btn_OK s_btn_Cancel s_btn_Help with frame dbprops.  

/* if we found the db detail record for this db, make it enabled, so user can update it, otherwise disable it
   in case the user switched db's while this frame is up. Also, if db is read-only, don't allow updates.
*/

IF has_db_detail AND NOT s_DB_ReadOnly THEN 
    ENABLE s_db_description s_Db_Add_Details with frame dbprops.
ELSE
    DISABLE s_db_description s_Db_Add_Details with frame dbprops.

apply "entry" to s_btn_OK in frame dbprops.







