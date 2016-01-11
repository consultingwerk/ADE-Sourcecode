/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* _HTM - .htm Objects
           Contains .htm field information.                                  */ 

DEFINE {1} SHARED TEMP-TABLE _HTM
  /* Cross reference indices. */
  FIELD _U-recid   AS RECID  LABEL "_U Recid" INITIAL ?
  FIELD _P-recid   AS RECID  LABEL "_P Recid" INITIAL ?
  /* Fields */
  FIELD _HTM-name  AS CHARACTER LABEL "HTML Field"
  FIELD _HTM-tag   AS CHARACTER LABEL "HTML Tag"
  FIELD _HTM-type  AS CHARACTER LABEL "HTML Type"
  FIELD _MDT-type  AS CHARACTER LABEL "Progress Type"    
  FIELD _i-order   AS INTEGER   LABEL "Read Order"
  INDEX U-recid    IS PRIMARY _U-recid
  INDEX P-recid               _P-recid
  INDEX i-order               _i-order
  .

/* htmwidg.i - end of file */

