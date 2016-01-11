/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

  genshar.i - Shared variables for workshop/_gendefs.p.  This is 
              defined in workshop/_gen4gl.p, workshop/_qikcomp.p and 
              workshop/_writedf.p .
  Author:  Wm.T.Wood 
  Created: 01/14/97
  
----------------------------------------------------------------------------*/

DEFINE {1} SHARED VARIABLE frame_name_f AS CHARACTER                  NO-UNDO.
DEFINE {1} SHARED VARIABLE stmnt_strt   AS INTEGER                    NO-UNDO.
DEFINE {1} SHARED VARIABLE u_status     AS CHARACTER INITIAL "NORMAL" NO-UNDO.

/* Output stream. */
DEFINE {1} SHARED STREAM P_4GL.

/* genshar.i - end of file */
