/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------
  File: convcp.p
  
  Description:       MIME-to-Progress code page translation
  Input Parameters:  MIME code page, defined by IANA
  Output Parameters: Progress code page equivalent, else input parameter pcFromPage
                     (which means that name was not on the list)
  Notes:             Code page list is accurate as of 7 February 2001.
  
  Updated: 10/01/2001 swatt@progress.com
             Intial version
           10/01/2001 adams@progress.com
             Adapted for POSSE coding standards
           07/09/04  Changed it to return input parameter if name not on the list. 
             
------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcFromPage AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcAction   AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pcCodePage AS CHARACTER  NO-UNDO.

DEFINE VARIABLE cMimeList AS CHARACTER  NO-UNDO INITIAL
"windows-1250,windows-1251,windows-1252,windows-1253,windows-1254,windows-1255,windows-1256,windows-1257,windows-1258,TIS-620,Big5,EUC-JP,GB_2312-80,IBM037,IBM273,IBM277,IBM278,IBM284,IBM297,IBM437,IBM500,IBM850,IBM851,IBM852,IBM857,IBM00858,IBM861,IBM862,IBM866,ISO-8859-1,ISO-8859-10,ISO-8859-15,ISO-8859-2,ISO-8859-3,ISO-8859-4,ISO-8859-5,ISO-8859-6,ISO-8859-7,ISO-8859-8,ISO-8859-9,KOI8-R,KS_C_5601-1987,hp-roman8,Shift_JIS,UTF-8,GB18030,GBK":U.
DEFINE VARIABLE cProgList AS CHARACTER  NO-UNDO INITIAL
"1250,1251,1252,1253,1254,1255,1256,1257,1258,620-2533,BIG-5,EUCJIS,GB2312,IBM037,IBM273,IBM277,IBM278,IBM284,IBM297,IBM437,IBM500,IBM850,IBM851,IBM852,IBM857,IBM858,IBM861,IBM862,IBM866,ISO8859-1,ISO8859-10,ISO8859-15,ISO8859-2,ISO8859-3,ISO8859-4,ISO8859-5,ISO8859-6,ISO8859-7,ISO8859-8,ISO8859-9,KOI8-R,KSC5601,ROMAN-8,SHIFT-JIS,UTF-8,GB18030,CP936":U.

CASE pcAction:
  /* Progress-to-MIME conversion */
  WHEN "toMime":U THEN DO:
    IF pcFromPage = ? THEN
      /* Return the entire MIME codepage list */
      ASSIGN pcCodePage = cMimeList.
    ELSE DO:
      /* Return the desired MIME codepage equivalent */
      ASSIGN  
        pcCodePage = ENTRY(1 + LOOKUP(pcFromPage, cProgList), pcFromPage + "," + cMimeList).
    END.
  END.
  /* MIME-to-Progress conversion */
  WHEN "toProg":U   THEN DO:
    IF pcFromPage = ? THEN
      /* Return the entire Progress codepage list */
      ASSIGN pcCodePage = cProgList.
    ELSE DO:
      /* Return the desired Progress codepage equivalent */
      ASSIGN  
        pcCodePage = ENTRY(1 + LOOKUP(pcFromPage, cMimeList), pcFromPage + "," + cProgList).
    END.
  END.
END CASE.

/* convcp.p - end of file */
