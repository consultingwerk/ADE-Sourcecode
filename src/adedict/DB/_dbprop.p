/************************************************************************
* Copyright (C) 2006,2013,2020,2021 by Progress Software Corporation.   *
* All rights reserved. Prior versions of this work may contain portions *
* contributed by participants of Possenet.                              *
*                                                                       *
*************************************************************************/

/*----------------------------------------------------------------------------

File: _dbprop.p

Description:
   Display database properties for the current db in the prop window.

Author: Laura Stern

Date Created: 12/04/92

History:
    tomn    01/10/96    Added codepage to DB Properties form (s_Db _Cp)
    
    fernando 05/24/2005 Added db-description and custom-details to the DB Properties form.
                        Accessing the _Db record with a dynamic buffer now
    fernando 06/06/06  Added large sequence and large key support to the DB Properties form.
    tmasood  10/29/20  Added default area support for db properties
    kberlia  11/23/20  Added support to store type II area only in the default area of db objects drop down.
    tmasood  12/04/20  Added the check for default area in pre OE 12.4
    tmasood  02/25/21  Changed return value of DBRESTRICTIONS function
    
----------------------------------------------------------------------------*/
&GLOBAL-DEFINE WIN95-BTN YES

{adedict/dictvar.i shared}
{adedict/uivar.i shared}
{adedict/DB/dbvar.i shared}

DEFINE VARIABLE has_db_detail      AS LOGICAL NO-UNDO INITIAL NO.
DEFINE VARIABLE hBuffer_DB          AS HANDLE NO-UNDO.
DEFINE VARIABLE hBuffer_DB-detail AS HANDLE NO-UNDO.
DEFINE VARIABLE numitems          AS INTEGER NO-UNDO.

/* create a buffer for _Db because the _db-guid field is not present on a non-upgraded db (pre-10.1A) */
CREATE BUFFER hBuffer_DB FOR TABLE "DICTDB._Db" NO-ERROR.

hBuffer_DB:FIND-FIRST ("where  recid(dictdb._db) = " + STRING(s_DbRecId)) NO-ERROR.

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

s_Db_Table_Area:DELIMITER in frame dbprops = CHR(1).
s_Db_Index_Area:DELIMITER in frame dbprops = CHR(1).
s_Db_LOB_Area:DELIMITER in frame dbprops   = CHR(1).

assign
   s_Db_PName  = s_DbCache_Pname[s_DbCache_ix]
   s_Db_Holder = s_DbCache_Holder[s_DbCache_ix]
   s_Db_Type   = s_DbCache_Type[s_DbCache_ix]
   s_Db_Cp     = if hBuffer_DB:AVAILABLE then hBuffer_DB::_db-xl-name else "".

/* check large sequence, large key support and mulit-tenancy, but only for Progress databases */
IF hBuffer_DB:AVAILABLE AND hBuffer_DB::_Db-type = "PROGRESS" THEN 
DO:
 
    IF LOOKUP("DEFAULT-AREAS", DBRESTRICTIONS("DICTDB")) > 0 THEN DO:
        ASSIGN s_Db_Table_Area:list-items in frame dbprops   = "n/a"
               s_Db_Index_Area:list-items in frame dbprops   = "n/a"
               s_Db_LOB_Area:list-items in frame dbprops     = "n/a"
               s_Db_Table_Area:screen-value in frame dbprops = "n/a"
               s_Db_Index_Area:screen-value in frame dbprops = "n/a"
               s_Db_LOB_Area:screen-value in frame dbprops   = "n/a"
               s_Db_Table_Area:sensitive in frame dbprops    = false
               s_Db_Index_Area:sensitive in frame dbprops    = false
               s_Db_LOB_Area:sensitive in frame dbprops      = false.
    END.
    ELSE DO:
        IF hBuffer_DB::_Db-misc1(1) <> ? THEN
           RUN FillArea(true,"Table").
        ELSE
           RUN FillArea(false,"Table").

        IF hBuffer_DB::_Db-misc1(2) <> ? THEN
          RUN FillArea(true,"Index").
        ELSE
          RUN FillArea(false,"Index").

        IF hBuffer_DB::_Db-misc1(3) <> ? THEN
          RUN FillArea(true,"LOB").
        ELSE
          RUN FillArea(false,"LOB").
    END.

    find dictdb._Database-feature where dictdb._Database-feature._DBFeature_Name = "Table Partitioning" no-lock no-error.
    if avail dictdb._Database-feature and dictdb._Database-feature._dbfeature_enabled="1" then
            s_Db_Partition_Enabled = "enabled".
    else
            s_Db_Partition_Enabled = "not enabled".

    find dictdb._Database-feature where dictdb._Database-feature._DBFeature_Name = "Change Data Capture" no-lock no-error.
    if avail dictdb._Database-feature and dictdb._Database-feature._dbfeature_enabled="1" then
            s_Db_CDC_Enabled = "enabled".
    else
            s_Db_CDC_Enabled = "not enabled".

    /* For large key support, we look at the _Database-feature table.
       For large sequence - if 'Large Keys' is not a valid feature, than this
       is a pre-10.1B db in which case large sequences is not
       applicable. Otherwise we look at db-res1[1].
    */
    FIND DICTDB._Database-feature WHERE dictdb._Database-feature._DBFeature_Name = "Large Keys" NO-LOCK NO-ERROR.
    IF AVAILABLE DICTDB._Database-feature THEN DO:
        if can-find(first dictdb._tenant) then 
           s_Db_Multi_Tenancy = "enabled".     
        else 
           s_Db_Multi_Tenancy = "not enabled".
        
        IF DICTDB._Database-feature._DBFeature_Enabled = "1" THEN
           s_Db_Large_Keys = "enabled".
        ELSE
           s_Db_Large_Keys = "not enabled".

         IF hBuffer_DB::_db-res1(1) = 1 THEN 
             s_Db_Large_Sequence = "enabled".
         ELSE
             s_Db_Large_Sequence = "not enabled".
    END.
    ELSE 
        ASSIGN s_Db_Large_Keys = "n/a"
               s_Db_Large_Sequence = "n/a".
END.
ELSE
    ASSIGN s_Db_Multi_Tenancy = "n/a"
           s_Db_Partition_Enabled = "n/a"
           s_Db_CDC_Enabled = "n/a"
           s_Db_Large_Sequence = "n/a"
           s_Db_Large_Keys = "n/a".

hBuffer_DB:BUFFER-RELEASE().

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
    s_Db_Partition_Enabled
    s_Db_Multi_tenancy
    s_Db_CDC_Enabled
    s_Db_Large_Sequence
    s_Db_Large_Keys
    s_Db_Table_Area
    s_Db_Index_Area
    s_Db_LOB_Area
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

procedure FillArea:
define input parameter plShow as logical no-undo.
define input parameter pcObject as character no-undo.
define variable cAreaList as character no-undo.
define variable cEmpty    as character initial "" no-undo.
  
    run prodict/pro/_pro_area_list(if pcObject = "Table" then ? else recid(dictdb._file),{&INVALID_AREAS},s_Db_Table_Area:DELIMITER in frame dbprops,pcObject + ",typeII", output cAreaList).
    
    case pcObject:
        when "Table" then do:
            if plShow then 
            do:
                assign
                   cAreaList = cAreaList + CHR(1) + cEmpty
                   s_Db_Table_Area:list-items in frame dbprops = cAreaList
                   s_Db_Table_Area:screen-value in frame dbprops = s_Db_Table_Area:entry(1) in frame dbprops 
                   numitems = s_Db_Table_Area:num-items in frame dbprops
                   s_Db_Table_Area:inner-lines in frame dbprops = min(numitems,10).  
                   s_Db_Table_Area:sensitive in frame dbprops = true.
            end.
            else do:
                assign
                   cAreaList = cEmpty + CHR(1) + cAreaList 
                   s_Db_Table_Area:list-items in frame dbprops = cAreaList
                   s_Db_Table_Area:screen-value in frame dbprops = cAreaList 
                   s_Db_Table_Area:sensitive in frame dbprops = true. 
            end.
        end.
        when "Index" then do:
            if plShow then 
            do:
                assign
                   cAreaList = cAreaList + CHR(1) + cEmpty
                   s_Db_Index_Area:list-items in frame dbprops = cAreaList
                   s_Db_Index_Area:screen-value in frame dbprops = s_Db_Index_Area:entry(1) in frame dbprops 
                   numitems = s_Db_Index_Area:num-items in frame dbprops
                   s_Db_Index_Area:inner-lines in frame dbprops = min(numitems,10).  
                   s_Db_Index_Area:sensitive in frame dbprops = true.
            end.
            else do:
                assign
                   cAreaList = cEmpty + CHR(1) + cAreaList 
                   s_Db_Index_Area:list-items in frame dbprops = cAreaList
                   s_Db_Index_Area:screen-value in frame dbprops = cAreaList 
                   s_Db_Index_Area:sensitive in frame dbprops = true. 
            end.
        end.
        when "LOB" then do:
            if plShow then 
            do:
                assign
                   cAreaList = cAreaList + CHR(1) + cEmpty
                   s_Db_LOB_Area:list-items in frame dbprops = cAreaList
                   s_Db_LOB_Area:screen-value in frame dbprops = s_Db_LOB_Area:entry(1) in frame dbprops 
                   numitems = s_Db_LOB_Area:num-items in frame dbprops
                   s_Db_LOB_Area:inner-lines in frame dbprops = min(numitems,10).  
                   s_Db_LOB_Area:sensitive in frame dbprops = true.
            end.
            else do:
                assign
                   cAreaList = cEmpty + CHR(1) + cAreaList 
                   s_Db_LOB_Area:list-items in frame dbprops = cAreaList
                   s_Db_LOB_Area:screen-value in frame dbprops = cAreaList 
                   s_Db_LOB_Area:sensitive in frame dbprops = true. 
            end.
        end.
    end case.
end procedure.
