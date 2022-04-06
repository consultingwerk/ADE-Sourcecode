/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* 
 */
DEFINE {&NEW} {&SHARED} TEMP-TABLE bDirList
   FIELD Project    AS   CHARACTER
   FIELD Directory  AS   CHARACTER
   FIELD AllFiles   AS   LOGICAL       
   FIELD AllSubDir  AS   LOGICAL       
   FIELD Active     AS   LOGICAL INITIAL TRUE
   INDEX idxActiveDir  IS PRIMARY Active Project Directory
   INDEX idxDir                   Project Directory.  
   
DEFINE {&NEW} {&SHARED} TEMP-TABLE bFileList
   FIELD Project             AS   CHARACTER
   FIELD Directory           AS   CHARACTER 
   FIELD FileName            AS   CHARACTER 
   FIELD Active              AS   LOGICAL INITIAL TRUE
   FIELD OrigNeedsExtracting AS   LOGICAL INITIAL FALSE
   INDEX idxActiveFile    IS PRIMARY Active Project FileName           
   INDEX idxActiveDirFile            Active Project Directory FileName.   
 
DEFINE {&NEW} {&SHARED} TEMP-TABLE bSubsetList
   FIELD Project    AS   CHARACTER
   FIELD Directory  AS   CHARACTER
   FIELD FileName   AS   CHARACTER 
   FIELD AllFiles   AS   LOGICAL       
   FIELD AllSubDirs AS   LOGICAL       
   FIELD Active     AS   LOGICAL INITIAL TRUE
   INDEX idxActiveFile    Active Project FileName           
   INDEX idxFile          Project FileName           
   INDEX idxDir           Project Directory           
   INDEX idxActiveDirFile Active Project Directory FileName.  

DEFINE {&NEW} {&SHARED} BUFFER bbDirList         FOR bDirList.  
DEFINE {&NEW} {&SHARED} BUFFER bbFileList        FOR bFileList.   
DEFINE {&NEW} {&SHARED} BUFFER bThisSubsetList   FOR bSubsetList.   

DEFINE {&NEW} {&SHARED} VARIABLE sAppDir    AS CHARACTER     NO-UNDO.  
DEFINE {&NEW} {&SHARED} VARIABLE lSubset    AS LOGICAL    INITIAL NO NO-UNDO.  
DEFINE VARIABLE cAllFiles AS CHARACTER  INITIAL "<All Files>"       NO-UNDO.
DEFINE VARIABLE cAllDirs  AS CHARACTER  INITIAL "<All Directories>" NO-UNDO.
DEFINE VARIABLE cSubset   AS CHARACTER  INITIAL " (Subset)" NO-UNDO.
