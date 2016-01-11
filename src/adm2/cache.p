&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*************************************************************/
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*---------------------------------------------------------------------------------
  File: 
  Description:  
  Purpose:
  Parameters:   
---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* **************************  Definitions  ************************** */
{src/adm2/globals.i}
  
DEFINE TEMP-TABLE ttCache 
  FIELD CacheKey        AS CHAR
  FIELD CacheContext    AS CHAR 
  FIELD TableHandle     AS HANDLE 
  FIELD IsCached        AS LOG 
  FIELD LastRequestTime AS DATETIME 
  FIELD CacheTime       AS DATETIME 
  FIELD ExpirationTime  AS DATETIME-TZ 
  FIELD NumInstances    AS INTEGER /* Number of running instances.*/
  FIELD NumRecords      AS INTEGER
  INDEX CacheKey AS PRIMARY UNIQUE CacheKey 
  INDEX TableHandle TableHandle.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-clearTimedCache) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD clearTimedCache Procedure 
FUNCTION clearTimedCache RETURNS LOGICAL PRIVATE
  ( phHandle AS HANDLE)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createSharedBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createSharedBuffer Procedure 
FUNCTION createSharedBuffer RETURNS HANDLE
  ( pcKey    AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-destroySharedBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD destroySharedBuffer Procedure 
FUNCTION destroySharedBuffer RETURNS LOGICAL
  ( phBuffer AS HANDLE)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-findCacheItem) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD findCacheItem Procedure 
FUNCTION findCacheItem RETURNS LOGICAL
  ( pcKey    AS CHAR,
    piMaxAge AS INT)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-obtainContextFromCache) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD obtainContextFromCache Procedure 
FUNCTION obtainContextFromCache RETURNS CHARACTER
  ( pcKey AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-registerCacheItem) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD registerCacheItem Procedure 
FUNCTION registerCacheItem RETURNS LOGICAL
  ( pcKey        AS CHAR,
    phTable      AS HANDLE,
    piTimeSpan   AS INTEGER,
    piNumRecords AS INTEGER,
    pcContext    AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 15.48
         WIDTH              = 43.4.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-clearCache) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE clearCache Procedure 
PROCEDURE clearCache :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcKey AS CHARACTER  NO-UNDO.

  IF pcKey = '*' THEN
  DO:
    FOR EACH ttCache:
      RUN clearCache IN TARGET-PROCEDURE(ttCache.CacheKey).
    END.
  END.
  ELSE DO:
    FIND ttCache WHERE ttCache.CacheKey = pcKey NO-ERROR.
    IF AVAIL ttCache THEN
    DO:
      ASSIGN
        ttCache.expirationTIME = NOW.
      clearTimedCache(ttCache.TableHandle).
    END. 
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-displayCache) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE displayCache Procedure 
PROCEDURE displayCache :
DEFINE VARIABLE hContainer AS HANDLE NO-UNDO.
DEFINE VARIABLE Radio-Sort AS CHARACTER  LABEL "Sort By" INIT "Type":U   

     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Key", "Key":U,
          "Num", "Num":U,
          "Time", "Time":U
     SIZE 32 BY 1 NO-UNDO.

  DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "OK" 
     SIZE 12 BY 1.08
     BGCOLOR 8 .

  /* Query definitions                                */
  DEFINE QUERY BROWSE-1 FOR 
      ttCache SCROLLING.

&SCOP OPEN-QUERY-BROWSE-1  ~
  IF Radio-Sort = "Time":U THEN ~
    OPEN QUERY BROWSE-1 FOR EACH ttCache BY CacheTime. ~
  ELSE IF Radio-Sort = "Num":U THEN ~
    OPEN QUERY BROWSE-1 FOR EACH ttCache BY  NumInstances. ~
  ELSE ~
    OPEN QUERY BROWSE-1 FOR EACH ttCache BY CacheKey . ~


/* Browse definitions                                */
  DEFINE BROWSE BROWSE-1
  QUERY BROWSE-1 NO-LOCK DISPLAY
   CacheKey  FORMAT "x(35)"      
   INT(TableHandle) @ TableHandle
   NumInstances     
   CacheContext    
   LastRequestTime
   CacheTime      
   ExpirationTime   
   NumRecords      
   WITH NO-ROW-MARKERS SEPARATORS 10 DOWN.


  DEFINE FRAME Dialog-Frame
     Radio-Sort AT ROW 1.5 COL 30
     Btn_OK AT ROW 13 COL 32
     BROWSE-1 AT ROW 3 COL 3 SPACE(2)
     SPACE(3) SKIP(1)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Cache ".
         
  browse-1:COLUMN-RESIZABLE = TRUE.  
  ON VALUE-CHANGED OF Radio-Sort 
  DO:
    ASSIGN Radio-Sort.
    {&OPEN-QUERY-BROWSE-1}
  END.
      
  ENABLE Radio-Sort BROWSE-1 Btn_OK   
      WITH FRAME Dialog-Frame.
  
  {&OPEN-QUERY-BROWSE-1} 

  WAIT-FOR GO OF FRAME Dialog-Frame.
 
                                          
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchDataFromCache) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchDataFromCache Procedure 
PROCEDURE fetchDataFromCache :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcKey AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject.

  FIND ttCache WHERE ttCache.CacheKey = pcKey NO-ERROR.
  IF AVAIL ttCache THEN
    ASSIGN
      ttCache.LastRequestTIME = NOW
      phRowObject = ttCache.TableHandle.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-clearTimedCache) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION clearTimedCache Procedure 
FUNCTION clearTimedCache RETURNS LOGICAL PRIVATE
  ( phHandle AS HANDLE) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  IF NOT AVAIL ttCache OR ttCache.TableHandle <> phHandle THEN 
     FIND ttCache WHERE ttCache.TableHandle = phHandle NO-ERROR. 

  IF AVAIL ttCache THEN 
  DO:
    IF ttCache.ExpirationTime <= NOW  
    OR (ttCache.CacheKey       =  ?) THEN
    DO:
      /* We do not delete a record with running shared instances. */ 
      IF ttCache.NumInstances <= 0 THEN
      DO:
        DELETE OBJECT ttCache.TableHandle.
        DELETE ttCache.
        RETURN TRUE.
      END.
      /* if shared and cached then set key to signal that this is expired. 
         (shared non-cached only expires when there are no more instances) */
      ELSE IF isCached THEN
      DO:
        ttCache.CacheKey = ?.
        RETURN TRUE.
      END.

      RETURN FALSE.
    END. 
  END.

  RETURN ?.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createSharedBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createSharedBuffer Procedure 
FUNCTION createSharedBuffer RETURNS HANDLE
  ( pcKey    AS CHAR) :
/*------------------------------------------------------------------------------
   Purpose: create a buffer for the cache with the passed key as 
            identifier. 
Parameters: pcKey   - Identifier. 
                     (LogicalObjectName or Containername + instance)
     Notes: The call increments NumInstances! 
------------------------------------------------------------------------------*/
 DEFINE VARIABLE hBuffer AS HANDLE     NO-UNDO.
 FIND ttCache WHERE ttCache.CacheKey = pcKey NO-ERROR.
 IF AVAIL ttCache THEN
 DO:
   ASSIGN
     ttCache.NumInstances    = ttCache.NumInstances + 1
     ttCache.LastRequestTIME = NOW
     .
   CREATE BUFFER hBuffer FOR TABLE ttCache.TableHandle:DEFAULT-BUFFER-HANDLE.
 END.
  
 ERROR-STATUS:ERROR = NO.
 
 RETURN hBuffer. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-destroySharedBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION destroySharedBuffer Procedure 
FUNCTION destroySharedBuffer RETURNS LOGICAL
  ( phBuffer AS HANDLE) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
 FIND ttCache WHERE ttCache.TableHandle = phBuffer:TABLE-HANDLE NO-ERROR. 
 ERROR-STATUS:ERROR = NO.
 IF AVAIL ttCache THEN
 DO:
   DELETE OBJECT phBuffer.
   ttCache.NumInstances = ttCache.NumInstances - 1. 
   clearTimedCache(ttCache.TableHandle).
   RETURN TRUE.
 END.
 RETURN FALSE. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-findCacheItem) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION findCacheItem Procedure 
FUNCTION findCacheItem RETURNS LOGICAL
  ( pcKey    AS CHAR,
    piMaxAge AS INT) :
/*------------------------------------------------------------------------------
   Purpose: Search for a temp-table in the data cache with the passed key as 
            identifier. 
Parameters: pcKey  - Identifier. 
                    (LogicalObjectName or Containername + instance)
            piMaxAge - Optional - Maximum age in seconds        
     Notes:  
------------------------------------------------------------------------------*/
 DEFINE BUFFER btCache FOR ttCache.

 DEFINE VARIABLE iAge AS INTEGER    NO-UNDO.

 FIND btCache WHERE btCache.CacheKey = pcKey NO-ERROR.
 
 ERROR-STATUS:ERROR = NO.

 IF AVAIL btCache THEN
 DO:
   /* 0 means shared only - return true if record in use and false otherwise */   
   IF piMaxAge = 0 THEN
     RETURN btCache.numInstances > 0.
   
   IF clearTimedCache(btCache.TableHandle) = TRUE THEN
     RETURN FALSE.

   /* Check that the requested max age is within the current cache age */
   ELSE IF piMaxAge > 0 THEN 
   DO:
      IF btCache.CacheTime + (piMaxAge * 1000) <= NOW THEN  
        RETURN FALSE. 
   END.

   RETURN TRUE.
 END.

 RETURN FALSE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-obtainContextFromCache) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION obtainContextFromCache Procedure 
FUNCTION obtainContextFromCache RETURNS CHARACTER
  ( pcKey AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose: Return the cached context  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE BUFFER btCache FOR ttCache.
  FIND btCache WHERE btCache.CacheKey = pcKey NO-ERROR.
  
  RETURN btCache.CacheContext.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-registerCacheItem) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION registerCacheItem Procedure 
FUNCTION registerCacheItem RETURNS LOGICAL
  ( pcKey        AS CHAR,
    phTable      AS HANDLE,
    piTimeSpan   AS INTEGER,
    piNumRecords AS INTEGER,
    pcContext    AS CHAR) :
/*------------------------------------------------------------------------------
   Purpose: Register a temp-table in the data cache with the passed key as 
            identifier. 
Parameters: 
    pcKey      - Identifier. (LogicalObjectName or Containername + instance)
    phHandle   - The Temp-table handle that is registered as cached. 
    piTimeSpan - Specifies the number of seconds the Data in the cache should 
                 be considered valid. 
                 Typically the TimeSpan property on the DataObject. 
                 0 = Valid as long as inuse = Share data, but don't cache.
                 ? = Valid as long as the session
    pcContext  - Optional info (not in use) 
                 - Possibly needed for server to refresh the cache etc.         
      Notes:  Replaces existing cache with same key. 
------------------------------------------------------------------------------*/
  DEFINE BUFFER btCache FOR ttCache.

  IF piTimeSpan < 0 THEN piTimeSpan = ?.

  DO ON ERROR UNDO, LEAVE TRANSACTION:
    RUN clearCache IN TARGET-PROCEDURE (pcKey).    
    CREATE btCache.
    ASSIGN
      btCache.CacheKey       = pcKey
      btCache.TableHandle    = phTable
      btCache.IsCached       = piTimeSpan <> 0
      btCache.CacheTime      = NOW              
      btCache.ExpirationTime = btCache.CacheTime + (piTimeSpan * 1000) /*unknown is OK */
      btCache.NumRecords     = piNumRecords
      btCache.CacheContext   = pcContext.
  END.
/*   MESSAGE                                 */
/*      'register ' SKIP                     */
/*         'new' lnew SKIP                   */
/*        'key'  btCache.CacheKey SKIP       */
/*        'handle' btCache.TableHandle  SKIP */
/*        'num' btCache.NumInstances SKIP    */
/*        'time' btCache.CacheTime  SKIP     */
/*        'expir' btCache.ExpirationTime     */
/*                                           */
/*     VIEW-AS ALERT-BOX INFO BUTTONS OK.    */

  RETURN AVAIL btCache.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

