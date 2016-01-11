/*************************************************************/
 /* Copyright (c) 2010 by progress Software Corporation.      */
 /*                                                           */
 /* all rights reserved.  no part of this program or document */
 /* may be  reproduced in  any form  or by  any means without */
 /* permission in writing from progress Software Corporation. */
 /*************************************************************/
/*------------------------------------------------------------------------
    File        : _pro_area_list.p
    Purpose     : return a list of area names 
    Author(s)   : hdaniels - copied from old code - added type 2
    Created     : Fri Dec 17 EST 2010
    Notes       : If pfilerecid is passed
                  - the file area is added as first item in list.  
                  - only type 2 areas area added to the list 
                  
                  The schema area is added last in the list, 
                  (unless it was added first when file has no area.)        
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* passed when filling area for index or field  */
define input  parameter  pFileRecid    as recid    no-undo.

define input  parameter  pInvalidAreas as character no-undo. 
/* delimiter - commas in area names allowed */
define input  parameter  pdlm          as character no-undo.    
define output parameter  pAreas        as character no-undo.

define variable cSkipArea as character no-undo.
define buffer b_file for dictdb._File. 

define variable lMt as logical no-undo.
define variable ltp as logical no-undo.
/* ***************************  Main Block  *************************** */
if pdlm = "" or pdlm = ? then 
   pdlm = chr(1).
   
if pFileRecid <> ? then 
do:
     
    find b_file where recid(b_file) = pFileRecid no-lock.
    lMt = b_file._file-attributes[1].
    ltp = b_file._file-attributes[3].
    
    /* find the table's area and add first in list */
    if (not lMt or  b_file._file-attributes[2] = true)  then
    do:     
        IF b_file._File-number <> ? THEN DO:
            FIND dictdb._storageobject WHERE dictdb._Storageobject._Db-recid      = b_file._Db-recid 
                                         AND dictdb._Storageobject._Object-type   = 1
                                         AND dictdb._Storageobject._Object-number = b_file._File-Number 
                                         and dictdb._Storageobject._Partitionid = 0 
                                      NO-LOCK NO-ERROR.
				      
            IF AVAILABLE dictdb._StorageObject and dictdb._StorageObject._Area-number NE 0 THEN            
                FIND DICTDB._Area 
                    WHERE DICTDB._Area._Area-number = dictdb._StorageObject._Area-number NO-LOCK NO-ERROR.           
        END.
        ELSE if b_file._ianum NE 0 THEN 
            FIND DICTDB._Area WHERE DICTDB._Area._Area-num = b_file._ianum NO-LOCK NO-ERROR.
            
        if avail DICTDB._Area then
        do:
            pAreas = dictdb._Area._area-name + pdlm.
            /* set flag so that we don;t add it again */
            cSkipArea = dictdb._Area._area-name.
        end.
    end.
end.

for each DICTDB._Area  fields (_Area-num _Area-type _Area-name _Area-clustersize)
         where DICTDB._Area._Area-num > 6 
         and DICTDB._Area._Area-type = 6 
         and not can-do(pInvalidAreas, DICTDB._AREA._Area-name)
         and DICTDB._Area._Area-name <> cSkipArea
         and ((not lMt and not ltp) 
              or   
              (DICTDB._Area._Area-clustersize = 8 
               or
               DICTDB._Area._Area-clustersize = 64 
               or
               DICTDB._Area._Area-clustersize = 512))  
         no-lock:
             
     pAreas = pAreas + DICTDB._Area._Area-name + pdlm.
end.
if not lmt and not ltp then
do:
    find DICTDB._Area where DICTDB._Area._Area-num = 6 no-lock no-error.
    if avail DICTDB._Area 
    and not can-do(pInvalidAreas, DICTDB._AREA._Area-name) then
        pAreas = pAreas + DICTDB._Area._Area-name.
end.
pAreas = right-trim(pAreas,pdlm).  