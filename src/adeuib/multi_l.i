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
/* multi_l.i   add _L records for non-current layout                              */

DEF BUFFER alt_L FOR _L.

FOR EACH _LAYOUT WHERE _LAYOUT._LO-NAME NE cur-lo AND _LAYOUT._ACTIVE:   
  FIND parent_L WHERE parent_L._u-recid = RECID(parent_U) AND
                      parent_L._LO-NAME = _LAYOUT._LO-NAME NO-ERROR.

  IF AVAILABLE parent_L THEN DO:
    CREATE alt_L.
    ASSIGN alt_L._LO-NAME            = _LAYOUT._LO-NAME
           alt_L._u-recid            = _L._u-recid
           alt_L._3-D                = _L._3-D
           alt_L._COL                = _L._COL
           alt_L._CONVERT-3D-COLORS  = _L._CONVERT-3D-COLORS
           alt_L._COL-MULT           = parent_L._COL-MULT
           alt_L._HEIGHT             = _L._HEIGHT
           alt_L._NO-BOX             = _L._NO-BOX
           alt_L._NO-FOCUS           = _L._NO-FOCUS
           alt_L._REMOVE-FROM-LAYOUT = IF cur-lo NE "Master Layout" THEN yes ELSE no
           alt_L._ROW                = _L._ROW
           alt_L._ROW-MULT           = parent_L._ROW-MULT
           alt_L._VIRTUAL-HEIGHT     = _L._VIRTUAL-HEIGHT
           alt_L._VIRTUAL-WIDTH      = _L._VIRTUAL-WIDTH
           alt_L._WIDTH              = _L._WIDTH
           alt_L._WIN-TYPE           = parent_L._WIN-TYPE.

  &IF DEFINED(from-slider) &THEN
    IF NOT alt_L._WIN-TYPE THEN
      ASSIGN alt_L._HEIGHT = MAX(2,INTEGER(alt_L._HEIGHT))
             alt_L._WIDTH  = IF _F._HORIZONTAL THEN INTEGER(alt_L._WIDTH)
                                               ELSE MAX(9,INTEGER(alt_L._WIDTH)).
  &ENDIF
  END. /* If this layout is active for this window */                 
END.
_U._LAYOUT-NAME = cur-lo.
