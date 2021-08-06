/*******************************************************************/
 /* Copyright (c) 2010,2020,2021 by progress Software Corporation. */
 /*                                                                */
 /* all rights reserved.  no part of this program or document      */
 /* may be  reproduced in  any form  or by  any means without      */
 /* permission in writing from progress Software Corporation.      */
 /******************************************************************/
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
DEFINE INPUT  PARAMETER  pFileRecid    AS RECID    NO-UNDO.

DEFINE INPUT  PARAMETER  pInvalidAreas AS CHARACTER NO-UNDO. 
/* delimiter - commas in area names allowed */
DEFINE INPUT  PARAMETER  pdlm          AS CHARACTER NO-UNDO. 
DEFINE INPUT  PARAMETER  pobjname      AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER  pAreas        AS CHARACTER NO-UNDO.

DEFINE VARIABLE cSkipArea AS CHARACTER NO-UNDO.
DEFINE BUFFER b_file FOR dictdb._File. 

DEFINE VARIABLE lMt     AS LOGICAL NO-UNDO.
DEFINE VARIABLE ltp     AS LOGICAL NO-UNDO.
DEFINE VARIABLE ltypeII AS LOGICAL NO-UNDO INITIAL FALSE.
/* ***************************  Main Block  *************************** */
IF pdlm = "" OR pdlm = ? THEN 
   pdlm = CHR(1).
   
IF LOOKUP("DEFAULT-AREAS", DBRESTRICTIONS("DICTDB")) = 0 THEN DO:
   FIND DICTDB._Db SHARE-LOCK NO-ERROR.
   IF AVAILABLE DICTDB._Db THEN
   DO: 
      IF ENTRY(1,pobjname) = "Table" AND dictdb._Db._Db-misc1[1] <> 0 THEN
         FIND DICTDB._Area WHERE DICTDB._Area._Area-num = dictdb._Db._Db-misc1[1] NO-LOCK NO-ERROR.
      ELSE IF ENTRY(1,pobjname) = "Index" AND dictdb._Db._Db-misc1[2] <> 0 THEN
         FIND DICTDB._Area WHERE DICTDB._Area._Area-num = dictdb._Db._Db-misc1[2] NO-LOCK NO-ERROR.
      ELSE IF ENTRY(1,pobjname) = "Lob" AND dictdb._Db._Db-misc1[3] <> 0 THEN
         FIND DICTDB._Area WHERE DICTDB._Area._Area-num = dictdb._Db._Db-misc1[3] NO-LOCK NO-ERROR.
   
      IF AVAILABLE DICTDB._Area THEN   
         ASSIGN pAreas    = dictdb._Area._area-name + pdlm
                cSkipArea = pAreas .
   END.
   RELEASE DICTDB._Db.

   IF NUM-ENTRIES(pobjname) > 1 AND ENTRY(2,pobjname) = "typeII" THEN
      ASSIGN ltypeII = TRUE.
END. 
     
IF pFileRecid <> ? THEN 
DO:     
    FIND b_file WHERE RECID(b_file) = pFileRecid NO-LOCK.
    lMt = b_file._file-attributes[1].
    ltp = b_file._file-attributes[3].        
    
    /* find the table's area and add first in list */
    IF (NOT lMt OR  b_file._file-attributes[2] = TRUE) AND NOT ltypeII  THEN
    DO:     
        IF b_file._File-number <> ? THEN DO:
            FIND dictdb._storageobject WHERE dictdb._Storageobject._Db-recid      = b_file._Db-recid 
                                         AND dictdb._Storageobject._Object-type   = 1
                                         AND dictdb._Storageobject._Object-number = b_file._File-Number 
                                         AND dictdb._Storageobject._Partitionid = 0 
                                      NO-LOCK NO-ERROR.
                      
            IF AVAILABLE dictdb._StorageObject AND dictdb._StorageObject._Area-number NE 0 THEN            
                FIND DICTDB._Area 
                    WHERE DICTDB._Area._Area-number = dictdb._StorageObject._Area-number NO-LOCK NO-ERROR.           
        END.
        ELSE IF b_file._ianum NE 0 THEN 
            FIND DICTDB._Area WHERE DICTDB._Area._Area-num = b_file._ianum NO-LOCK NO-ERROR.
            
        IF AVAIL DICTDB._Area THEN
        DO:
            IF pAreas = "" THEN
              pAreas = dictdb._Area._area-name + pdlm.
            ELSE
              pAreas = pAreas + dictdb._Area._area-name + pdlm.  
            /* set flag so that we don;t add it again */
            cSkipArea = pAreas.
        END.
    END.
END.

FOR EACH DICTDB._Area  FIELDS (_Area-num _Area-type _Area-name _Area-clustersize)
         WHERE DICTDB._Area._Area-num > 6 
         AND DICTDB._Area._Area-type = 6 
         AND NOT can-do(pInvalidAreas, DICTDB._AREA._Area-name)
         AND LOOKUP(DICTDB._Area._Area-name, cSkipArea, pdlm) = 0
         AND ((NOT lMt AND NOT ltp AND NOT ltypeII) 
              OR   
              (DICTDB._Area._Area-clustersize = 8 
               OR
               DICTDB._Area._Area-clustersize = 64 
               OR
               DICTDB._Area._Area-clustersize = 512))  
         NO-LOCK:
   
     pAreas = pAreas + DICTDB._Area._Area-name + pdlm.
          
END.

IF NOT lmt AND NOT ltp AND NOT ltypeII THEN
DO:
    FIND DICTDB._Area WHERE DICTDB._Area._Area-num = 6 NO-LOCK NO-ERROR.
    IF AVAIL DICTDB._Area 
    AND NOT can-do(pInvalidAreas, DICTDB._AREA._Area-name) 
    AND LOOKUP(DICTDB._Area._Area-name, cSkipArea, pdlm) = 0 THEN
        pAreas = pAreas + DICTDB._Area._Area-name.        
END.
pAreas = RIGHT-TRIM(pAreas,pdlm).  
