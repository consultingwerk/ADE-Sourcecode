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

DEFINE {1} SHARED FRAME  marker
  DICTDB._File._File-name FORMAT "x(32)" LABEL "Table" COLON 11   
  DICTDB._field._Field-name FORMAT "x(32)":u LABEL "Field" COLON 11 SKIP
  DICTDB._Index._Index-name FORMAT "x(32)":u LABEL "Index" COLON 11 SKIP
  HEADER 
    " Dumping definitions.  Press" +
    KBLABEL("STOP") + " to terminate the dump process. " format "x(70)"
  WITH  OVERLAY ROW 4 CENTERED SIDE-LABELS ATTR-SPACE USE-TEXT.

COLOR DISPLAY MESSAGES 
                       DICTDB._File._File-name 
                       DICTDB._Field._Field-name
                       DICTDB._Index._Index-name
              WITH FRAME marker.         
