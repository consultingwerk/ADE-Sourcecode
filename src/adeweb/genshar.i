/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
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
