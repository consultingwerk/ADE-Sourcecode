/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* HTMOFF - .htm Objects
            Contains .htm field information from .off file.  */
/* input htm file */

&GLOB HTMOFF  /* used in columnHTMLName */ 

DEFINE {1} SHARED VARIABLE htmFname AS CHARACTER NO-UNDO.    

/* HTM Offset records. */
DEFINE {1} SHARED TEMP-TABLE HTMOFF NO-UNDO
  FIELD PROC-ID   AS HANDLE    LABEL "Procedure handle"
  FIELD HTM-NAME  AS CHARACTER LABEL "HTML Field"
  FIELD HTM-TAG   AS CHARACTER LABEL "HTML Tag"
  FIELD HTM-TYPE  AS CHARACTER LABEL "HTML Type"
  FIELD WDT-NAME  AS CHARACTER LABEL "WDT Field"
  FIELD WDT-TYPE  AS CHARACTER LABEL "WDT Type"
  FIELD ITEM-CNT  AS INTEGER   LABEL "Item counter"
  FIELD HANDLE    AS HANDLE    LABEL "Widget Handle"
  FIELD BEG-LINE  AS INTEGER   LABEL "Begin Line"
  FIELD BEG-BYTE  AS INTEGER   LABEL "Begin Byte"
  FIELD END-LINE  AS INTEGER   LABEL "End Line"
  FIELD END-BYTE  AS INTEGER   LABEL "End Byte"

  INDEX offset    IS PRIMARY PROC-ID BEG-LINE BEG-BYTE
  INDEX wdt-name             PROC-ID WDT-NAME ITEM-CNT.

/* htmoff.i - end of file */
 

