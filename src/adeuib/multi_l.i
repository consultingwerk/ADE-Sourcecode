/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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
