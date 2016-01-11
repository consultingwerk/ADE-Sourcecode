/*************************************************************/
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
  File: adedict/FLD/lob-misc.i

  Description: Include with triggers for clob / blob fields used by the
               field properties dialogs (_newfld.p and _dcttran.p)
               
  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: Fernando de Souza

  Created: August 10, 2005
  History:
  
------------------------------------------------------------------------*/

&SCOPED-DEFINE CTYPE (IF iType = 1 THEN "Blob" ELSE "Clob")

DEFINE VARIABLE bnum       AS INTEGER            NO-UNDO.
DEFINE VARIABLE hldcp      AS CHARACTER          NO-UNDO.
DEFINE VARIABLE i          AS INTEGER            NO-UNDO.


ON LEAVE OF s_lob_size IN {&Frame} 
DO:
DEFINE VARIABLE cType     AS CHARACTER                 NO-UNDO.
DEFINE VARIABLE iType     AS INTEGER                   NO-UNDO.
DEFINE VARIABLE size-type AS CHARACTER FORMAT "x"      NO-UNDO.

  ASSIGN cType = s_Fld_DType:SCREEN-VALUE IN {&FRAME}
         iType = (IF cType = "BLOB" THEN 1 ELSE 2)
         s_lob_size = CAPS(INPUT {&Frame} s_lob_size).

  IF NOT isNumeric(SUBSTRING(s_lob_size,1,1)) THEN DO:
    MESSAGE {&CTYPE} " field size must begin with a numeric character!"
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    
    s_lob_size:SCREEN-VALUE IN {&Frame} = "100M".
    
    RETURN NO-APPLY.
  END.
  ELSE IF badFormat(ctype,"s_lob_size",s_lob_size) THEN DO:
    MESSAGE {&CTYPE} " field size contains invalid characters!" SKIP(1)
            "Please enter a numeric value followed by one of" SKIP
            "the following alphabetic values:" SKIP(1) 
            "B = Bytes" SKIP
            "K or KB = Kilobytes" SKIP
            "M or MB = Megabytes" SKIP
            "G or GB = Gigabytes" SKIP
       VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    
    s_lob_size:SCREEN-VALUE IN {&Frame} = "100M".
    
    RETURN NO-APPLY.
  END.
  IF INDEX(s_lob_size, "K") <> 0 THEN
    ASSIGN size-type = "K".
  ELSE IF INDEX(s_lob_size, "M") <> 0 THEN
    ASSIGN size-type = "M".
  ELSE IF INDEX(s_lob_size, "G") <> 0 THEN
    ASSIGN size-type = "G".
  ELSE IF INDEX(s_lob_size, "B") <> 0 THEN
    ASSIGN size-type = "B".
  ELSE IF INDEX("ACDEFHIJLNOPQRSTUVWXYZ", SUBSTRING(s_lob_size, LENGTH(s_lob_size), 1)) <> 0 THEN DO:
    MESSAGE "Size of " (IF iType = 1 THEN "blob" ELSE "clob") " must be expressed as #B, #K, #M, or #G"
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    s_lob_size:SCREEN-VALUE IN {&FRAME} = "100M".
    RETURN NO-APPLY.
  END.    
  ELSE 
    ASSIGN size-type = "B"
           s_lob_size = s_lob_size + "B"
           s_lob_size:SCREEN-VALUE IN {&FRAME} = s_lob_size.
   
  CASE size-type:
    WHEN "K" THEN DO:
        ASSIGN s_lob_wdth = INTEGER(TRIM(SUBSTRING(s_lob_size, 1, (INDEX(s_lob_size, "K") - 1)))).
        ASSIGN s_lob_wdth = (s_lob_wdth * 1024).
    END.
    WHEN "M" THEN DO:
        ASSIGN s_lob_wdth = INTEGER(TRIM(SUBSTRING(s_lob_size, 1, (INDEX(s_lob_size, "M") - 1)))).
        ASSIGN s_lob_wdth = (s_lob_wdth * (1024 * 1024)).
    END.
    WHEN "G" THEN
        ASSIGN s_lob_wdth = INTEGER(TRIM(SUBSTRING(s_lob_size, 1, (INDEX(s_lob_size, "G") - 1))))
               s_lob_wdth = (s_lob_wdth * (1024 * 1024 * 1024) - 1).
    OTHERWISE
        ASSIGN s_lob_wdth = INTEGER(TRIM(SUBSTRING(s_lob_size, 1, (INDEX(s_lob_size, "B") - 1)))). 
  END CASE.

  IF s_lob_wdth < 1 OR s_lob_wdth > 1073741823 THEN DO:
    MESSAGE "Size of " {&CTYPE} " must be between 1B and 1G" SKIP
               "The default value is 100M" SKIP
           VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        /* Set size to default 1Mb */
       s_lob_size:SCREEN-VALUE IN {&FRAME} = "100M".
    RETURN NO-APPLY.
  END.
END.

/* When code page changes, we need to redo the collations that belong to that
   code page.  adecomm/cbtdrop.i applys U1 to this variable.
*/   

ON "U1" OF s_clob_cp IN {&Frame}
DO:
    IF s_clob_cp:SCREEN-VALUE <> "*Use DB Code Page" THEN DO:
      ASSIGN hldcp = GET-COLLATIONS(s_clob_cp:SCREEN-VALUE)
             s_clob_cp = s_clob_cp:SCREEN-VALUE.
         
      DO i = 1 TO NUM-ENTRIES(hldcp):
        IF i = 1 THEN
          ASSIGN s_clob_col = ENTRY(i, hldcp)
                 s_clob_col:SCREEN-VALUE = ENTRY(i, hldcp).
          s_res = s_lst_clob_col:ADD-LAST(ENTRY(i, hldcp)) IN {&Frame}.
      END.
    END.
    ELSE 
      ASSIGN s_clob_col = DICTDB._DB._Db-coll-name
             s_lst_clob_col:LIST-ITEMS IN {&Frame} = ""
             s_res = s_lst_clob_col:ADD-FIRST("*Use DB Collation") IN {&Frame}.
    RETURN.
END.

ON LEAVE OF s_clob_cp IN {&Frame} DO:

  ASSIGN s_lst_clob_col:LIST-ITEMS IN {&Frame} = "".
  IF s_clob_cp:SCREEN-VALUE <> "*Use DB Code Page" THEN DO:
    ASSIGN hldcp = GET-COLLATIONS(s_clob_cp:SCREEN-VALUE)
           s_clob_cp = s_clob_cp:SCREEN-VALUE.
         
    DO i = 1 TO NUM-ENTRIES(hldcp):
      IF i = 1 THEN
        ASSIGN s_clob_col = ENTRY(i, hldcp)
               s_clob_col:SCREEN-VALUE = ENTRY(i, hldcp).
        s_res = s_lst_clob_col:ADD-LAST(ENTRY(i, hldcp)) IN {&Frame}.
    END.
  END.
  ELSE DO:
    ASSIGN s_clob_col = DICTDB._DB._Db-coll-name
       s_lst_clob_col:LIST-ITEMS IN {&Frame} = ""
       s_res = s_lst_clob_col:ADD-FIRST("*Use DB Collation") IN {&Frame}
       s_clob_col:SCREEN-VALUE IN {&Frame} = "*Use DB Collation" .
     
  END.
  RETURN.
END.
