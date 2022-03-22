/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* tagmap.i - 
           Contains mappings of Progress types, utility proc names and handles  */ 
DEFINE {1} SHARED TEMP-TABLE tagmap NO-UNDO
    FIELD i-order        AS INTEGER   LABEL "Order"
    FIELD htm-Tag        AS CHARACTER LABEL "HTML Tag"
    FIELD htm-Type       AS CHARACTER LABEL "HTML Type"
    FIELD psc-Type       AS CHARACTER LABEL "PSC Type"
    FIELD util-Proc-Name AS CHARACTER LABEL "Util Proc Name"
    FIELD util-Proc-Hdl  AS HANDLE    LABEL "Util Proc Handle"
  INDEX i-order  IS UNIQUE PRIMARY i-order
  INDEX Tag-Type                   htm-Tag htm-Type
  .

/* tagmap.i - end of file */
