/*********************************************************************
* Copyright (C) 2000,2012 by Progress Software Corporation. All rights *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
Procedure:    adecomm/fileinfo.i
Author:       Steve Texin, Robert Ryan
Created:      2/95
Purpose:      Initializes the fileinfo.dll that returns file size
              and various date information for the modified date.
              The various date TOkens can be ASsembled in different
              combinations TO create an international date.  
              
              This DLL is best used in combination with the 
              'dirsrch.dll' which returns files for a direcTOry
              and filter.  For each file that dirsrch returns, you
              can pASs this file-spec TO file_info.   

*/

/*
 * FILEINFO.I
 *
 * PROCEDURE NAME:  file_info
 *     PARAMETERS:  
 *                  file-spec               : path TO file
 *                  file-year, mon, day     : ptr TO short
 *                  file-hour, min, sec     : ptr TO short
 *                  file-length             : ptr TO long
 *                  error-val               : ptr TO short
 *                                            0 - if there were no errors.
 *                                            1 - cant open file
 *                                            2 - cant get status
 *
 * USAGE:           run LoadFileInfo.
 *                  run file_info (...).
 *                  run FreeLibrary (hThisDLL).

 */
 
DEFINE VAR hThisDLL AS INTEGER no-undo.

/* 32bit API */
PROCEDURE LoadLibraryA EXTERNAL "KERNEL32.DLL":
    DEFINE INPUT  PARAMETER dllname AS MEMPTR.
    DEFINE RETURN PARAMETER hdll    AS LONG.
END.

PROCEDURE FreeLibrary EXTERNAL "KERNEL32.DLL":
    DEFINE INPUT PARAMETER hdll     AS LONG.
END.


PROCEDURE LoadFileInfo :
  DEFINE VARIABLE ThisDLL AS CHARACTER INITIAL "fileinfo.dll" NO-UNDO.
  DEFINE VARIABLE pDLL   AS MEMPTR.
  
  SET-SIZE(pDLL) = length(ThisDLL) + 1.
  PUT-STRING(pDLL,1) = ThisDLL.
  RUN LoadLibraryA(pDLL, OUTPUT hThisDLL). 
  SET-SIZE(pDLL) = 0.
END.

PROCEDURE UnloadDLL : 
  RUN FreeLibrary (hThisDLL).
END.

/* Win32 API */
PROCEDURE file_info EXTERNAL "fileinfo.dll":
 DEFINE INPUT    PARAMETER File-path    AS CHARACTER.
 DEFINE OUTPUT   PARAMETER file-year    AS HANDLE TO LONG.
 DEFINE OUTPUT   PARAMETER file-mon     AS HANDLE TO LONG.
 DEFINE OUTPUT   PARAMETER file-day     AS HANDLE TO LONG.
 DEFINE OUTPUT   PARAMETER file-hour    AS HANDLE TO LONG.
 DEFINE OUTPUT   PARAMETER file-min     AS HANDLE TO LONG.
 DEFINE OUTPUT   PARAMETER file-sec     AS HANDLE TO LONG.
 DEFINE OUTPUT   PARAMETER file-size    AS HANDLE TO LONG.
 DEFINE OUTPUT   PARAMETER error        AS HANDLE TO LONG.
END PROCEDURE.

/*
DEFINE VARIABLE file-year AS INTEGER.
DEFINE VARIABLE file-mon AS INTEGER.
DEFINE VARIABLE file-day AS INTEGER.
DEFINE VARIABLE file-hour AS INTEGER.
DEFINE VARIABLE file-min AS INTEGER.
DEFINE VARIABLE file-sec AS INTEGER.
DEFINE VARIABLE file-size AS INTEGER.    
DEFINE VARIABLE error AS INTEGER.   
*/
