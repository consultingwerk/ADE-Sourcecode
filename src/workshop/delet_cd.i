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
  /* delet_cd.i -- include file to delete a code block
   * and the associated _code-text records. 
   * (by Wm.T.Wood 2/3/97) 
   */  
  &IF DEFINED(delet_cd) eq 0 &THEN 
  /* Define the variables used by this include file only once per file */
  &Global-define delet_cd yes
  DEFINE VARIABLE delcdText-id LIKE _code._text-id NO-UNDO.
  &ENDIF  
  
  delcdText-id = _code._text-id.
  DO WHILE delcdText-id ne ?:
  FIND _code-text WHERE RECID(_code-text) eq delcdText-id.
  delcdText-id = _code-text._next-id.
    DELETE _code-text.
  END.
  DELETE _code.

