/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: blobvar.i

Description:   
   Include file which defines the user interface components and related data
   for the lob fields editor window and its subsidiary dialog boxes.   
 
Arguments:
   {1} - this is either "new shared" or "shared".

Author: Donna L. McMann

Date Created: 01/31/03
     History: 08/27/03 Changed Size label
              09/03/03 Change clob-size format 20030829-039
  
----------------------------------------------------------------------------*/

DEFINE {1} VARIABLE clob-size AS CHARACTER FORMAT "x(10)" NO-UNDO.
DEFINE {1} VARIABLE wdth      AS DECIMAL                  NO-UNDO.  
DEFINE {1} VARIABLE size-type AS CHARACTER FORMAT "x"     NO-UNDO.

DEFINE {1} FRAME cfldprop.

&SCOPED-DEFINE VM_WIDG 0.33


FORM
  SKIP({&VM_WID})  
  b_Field._Field-name LABEL "&Field Name" colon 18 {&STDPH_FILL}
   SKIP({&VM_WID})
  s_clob_Area LABEL "Area" COLON 18 {&STDPH_FILL}
   SKIP({&VM_WID})
  clob-size LABEL "&Max Size" COLON 18 {&STDPH_FILL}
   SKIP({&VM_WID})
  b_Field._Order label "&Order #"        colon 18 {&STDPH_FILL}
    SKIP({&VM_WID})
  b_Field._Fld-case LABEL "Case &Sensitive" COLON 18 {&STDPH_FILL}
    SKIP({&VM_WID})
  b_Field._Charset LABEL "Code Page" COLON 18 {&STDPH_FILL}
    SKIP({&VM_WID})
  b_Field._Collation LABEL "Collation" COLON 18 {&STDPH_FILL}
    SKIP({&VM_WID})

  {adecomm/okform.i
      &BOX = "rect_btns"
      &STATUS = no
      &OK     = btn_OK
      &CANCEL = btn_Cancel
      &HELP   = btn_Help
   }
  with FRAME cfldprop 
  VIEW-AS DIALOG-BOX THREE-D  
  SIDE-LABELS ROW 5 COLUMN 5 
  DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
   TITLE "Clob Field Attributes".
