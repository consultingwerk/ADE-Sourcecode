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

File: _sim_lbl.p

Description:
    Updates the label in the UIB for Toggles and Buttons and simulates
    combo-boxes in Character mode.
    
    The actual txt we use for the label is:
      - the name of the variable (_U._NAME) if _U._LABEL-SOURCE = "D"efault.
      - or _U._LABEL (after accounting for string-attributes).
    
    For TTY Simulations, make the following substitution.
    
    For example:         Using:
       Toggle            [ ]Label
       Button            <label>
       Combo-box         ________[V]
       FILL-IN           INITL______
       

Input Parameters:
   h_self       : the handle of the widget 
   
Output Parameters:
   <None>

Author:   Wm.T.Wood

Date Created: December 6, 1992 

----------------------------------------------------------------------------*/
/* -------------------------- INPUT PARAMETERS ---------------------------- */
define input parameter h_self        as widget-handle 	    	     NO-UNDO.

{adeuib/sharvars.i}
{adeuib/layout.i}
{adeuib/uniwidg.i}

/* -------------------------- LOCAL VARIABLES ----------------------------- */
/* Note we care about the case of labels */
DEFINE VAR      txt             AS CHAR           CASE-SENSITIVE     NO-UNDO.
DEFINE VAR      i-fill          AS INTEGER                           NO-UNDO.
DEFINE VAR      lwidth          AS INTEGER                           NO-UNDO.

/* ---------------------------- LOCAL CONSTANTS --------------------------- */
/* The new-line character                                                   */
&Scoped-define NL  CHR(10)

/* See what we are modifing and act accordingly                             */
FIND _U WHERE _U._HANDLE = h_self.
FIND _F WHERE RECID(_F)  = _U._x-recid.
FIND _L WHERE RECID(_L)  = _U._lo-recid.

/* Account for the label source & string attributes on the label */
IF CAN-DO("TOGGLE-BOX,BUTTON",_U._TYPE) THEN DO:
  IF (_U._LABEL-SOURCE = "D") AND (_U._TABLE EQ ?) THEN txt = _U._NAME.
  ELSE IF _U._LABEL-ATTR EQ "" OR _U._LABEL-ATTR EQ "U":U
                                                   THEN txt = _U._LABEL.
  ELSE RUN adeuib/_strfmt.p (_U._LABEL, _U._LABEL-ATTR, no, OUTPUT txt). 
END.
ELSE IF _F._INITIAL-DATA NE ? THEN
       CASE _F._DATA-TYPE:
         WHEN "DATE":U        THEN 
             IF _F._INITIAL-DATA = "TODAY" 
             THEN txt = STRING(TODAY). 
             ELSE txt = _F._INITIAL-DATA.
         WHEN "DATETIME":U    THEN 
             IF _F._INITIAL-DATA = "NOW"   
             THEN txt = STRING(NOW).   
             ELSE txt = _F._INITIAL-DATA.
         WHEN "DATETIME-TZ":U THEN 
             IF _F._INITIAL-DATA = "NOW"   
             THEN txt = STRING(NOW).   
             ELSE txt = _F._INITIAL-DATA.
       END CASE.
     ELSE txt = "".
ASSIGN txt = TRIM(txt).

IF _L._WIN-TYPE AND NOT CAN-DO("FILL-IN,COMBO-BOX",_U._TYPE) THEN DO: /* GUI mode */
  /* NOTE: txt is CASE-SENSITIVE and we also care about "x" ne "x  ". */
  IF h_self:LABEL NE txt  OR LENGTH(h_self:LABEL, "raw":U) ne LENGTH(txt, "raw":U)
  THEN h_self:LABEL = txt.
END. 
ELSE DO:
  ASSIGN lwidth = IF _L._WIDTH = ? THEN
                    INTEGER(h_self:WIDTH / _cur_col_mult) 
                  ELSE 
                    INTEGER(_L._WIDTH).
  CASE _U._TYPE:
     WHEN "BUTTON" THEN DO:
       /* Make it <Label> */
       IF LENGTH(txt, "raw":U) > _L._WIDTH - 2 THEN DO:
         /* Button is smaller than label - truncate the label              */
	/* ksu 02/22/94 no raw mode in SUBSTRING with LENGTH as parameter */
         IF _L._WIDTH < 1.5 THEN ASSIGN txt = "<".
         ELSE IF _L._WIDTH < 2.5 THEN ASSIGN txt = "<>".
         ELSE ASSIGN txt = "<" + SUBSTRING(txt,
                                    INTEGER((LENGTH(txt) + 3 - _L._WIDTH) / 2),
                                    INTEGER(_L._WIDTH) - 2) + ">".
       END.
       ELSE DO:  /* Label will fit */
         ASSIGN i-fill  = INTEGER((_L._WIDTH - LENGTH(txt, "raw":U) - 2) / 2)
                txt     = "<" + FILL(" ", i-fill) + txt +
                                FILL(" ", INTEGER(_L._WIDTH - 2 -
                                     i-fill -  LENGTH(txt, "raw":U))) + ">".
       END. 
       ASSIGN h_self:WIDTH           = LENGTH(txt) * _cur_col_mult
              h_self:FORMAT          = "X(" + STRING(LENGTH(txt, "raw":U)) + ")"
              h_self:SCREEN-VALUE    = txt
              _L._WIDTH              = h_self:WIDTH / _cur_col_mult.
     END.

     WHEN "TOGGLE-BOX" THEN
       /* Use [ ]Label */
       ASSIGN txt                    = (IF CAN-DO("YES,TRUE",_F._INITIAL-DATA) THEN
                                               "[X]"  ELSE "[ ]") + txt
/*    	      h_self:AUTO-RESIZE     = TRUE */
              h_self:FORMAT          = "X(" + STRING(LENGTH(txt, "raw":U)) + ")"
              h_self:SCREEN-VALUE    = txt
              /* Set _L width if it hasn't already been set. */
              _L._WIDTH              = lwidth.

     WHEN "COMBO-BOX" THEN
       ASSIGN _L._WIDTH           = lwidth
              txt                 = IF LENGTH(txt, "raw":U) >= _L._WIDTH - 3 THEN
                                      SUBSTRING(txt,1, INTEGER(_L._WIDTH) - 3) + "[V]":U
                                    ELSE 
                                      txt + FILL("_":U,INTEGER(_L._WIDTH) - 3 -
                                                LENGTH(txt, "raw":U)) + "[V]":U
              h_self:FORMAT       = "X(" + STRING(LENGTH(txt, "raw":U)) + ")"
              h_self:SCREEN-VALUE = txt.            

     WHEN "FILL-IN" THEN DO:
       IF NOT _U._SUBTYPE = "TEXT":U THEN
        ASSIGN _L._WIDTH          = lwidth
              txt                 = IF LENGTH(txt, "raw":U) >= _L._WIDTH THEN
                                      SUBSTRING(txt,1, INTEGER(_L._WIDTH))
                                    ELSE IF _U._SUBTYPE = "TEXT":U AND
                                         CAN-DO("INTEGER,DECIMAL":U,_F._DATA-TYPE) AND
                                         txt = "" THEN TRIM(STRING(0,_F._FORMAT))
                                    ELSE IF _U._SUBTYPE = "TEXT":U AND
                                            _F._DATA-TYPE NE "Character":U THEN txt
                                    ELSE 
                                      txt + FILL(IF _U._SUBTYPE = "TEXT" THEN
                                                       " ":U
                                                  ELSE "_":U, INTEGER(_L._WIDTH) -
                                                LENGTH(txt, "raw":U)).
       ASSIGN h_self:FORMAT       = IF _F._DATA-TYPE NE "Character":U AND
                                       _cur_win_type THEN _F._FORMAT
                                    ELSE "X(" + STRING(MAX(1,LENGTH(txt,"raw":U))) + ")"
              h_self:SCREEN-VALUE = txt.            
     END.
     OTHERWISE /* DO NOTHING */ .
  END CASE.
END.
