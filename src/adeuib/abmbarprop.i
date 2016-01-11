/*********************************************************************
* Copyright (C) 2000-2001 by Progress Software Corporation ("PSC"),  *
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
*********************************************************************/
/*------------------------------------------------------------------------

  File:         abmbarprop.i

  Description:  Include File for adeuib/_abmbar.w in procedure 
                prop_synchProperties
                   
------------------------------------------------------------------------*/

WHEN "ALLOW-COLUMN-SEARCHING":U THEN
  IF AVAILABLE f_C AND isValueLogical(hBuffer) <> f_C._COLUMN-SEARCHING AND f_C._COLUMN-SEARCHING <> ? THEN
       cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + string(f_C._COLUMN-SEARCHING,"Yes/No":U).  
WHEN "AppService":U THEN
  IF AVAILABLE _P AND hBuffer:BUFFER-FIELD("setValue":U):BUFFER-VALUE <> _P._PARTITION AND _P._PARTITION <> ? THEN
      cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + _P._PARTITION.  
WHEN "AssignList":U THEN  /* SDO specific */
  IF AVAILABLE q_Q AND hBuffer:BUFFER-FIELD("setValue":U):BUFFER-VALUE <> cAssignList AND cAssignList <> ? THEN
       cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + cAssignList.  
WHEN "AUTO-COMPLETION":U  THEN 
   IF AVAILABLE f_F AND isValueLogical(hBuffer) <> f_F._AUTO-COMPLETION AND f_F._AUTO-COMPLETION <> ? THEN
      cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + STRING(f_F._AUTO-COMPLETION,"yes/no":U).
WHEN "AUTO-END-KEY":U     THEN 
   IF AVAILABLE f_F AND isValueLogical(hBuffer) <> f_F._AUTO-ENDKEY AND f_F._AUTO-ENDKEY <> ? THEN
     cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + STRING(f_F._AUTO-ENDKEY,"yes/no":U).
WHEN "AUTO-GO":U          THEN 
   IF  AVAILABLE f_F AND isValueLogical(hBuffer) <> f_F._AUTO-GO AND  f_F._AUTO-GO <> ? THEN
     cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + STRING(f_F._AUTO-GO,"yes/no":U).
WHEN "AUTO-INDENT":U      THEN 
   IF AVAILABLE f_F AND isValueLogical(hBuffer) <> f_F._AUTO-INDENT AND f_F._AUTO-INDENT <> ?  THEN
     cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + STRING(f_F._AUTO-INDENT,"yes/no":U). 
WHEN "AUTO-RESIZE":U      THEN 
   IF AVAILABLE f_F AND isValueLogical(hBuffer) <>  f_F._AUTO-RESIZE AND  f_F._AUTO-RESIZE <> ?  THEN
     cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + STRING(f_F._AUTO-RESIZE,"yes/no":U). 
WHEN "AUTO-RETURN":U      THEN 
   IF AVAILABLE f_F AND isValueLogical(hBuffer) <>  f_F._AUTO-RETURN AND f_F._AUTO-RETURN <> ? THEN
     cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + STRING(f_F._AUTO-RETURN,"yes/no":U). 
WHEN "AUTO-VALIDATE":U THEN
  IF AVAILABLE f_C AND isValueLogical(hBuffer) <> f_C._NO-AUTO-VALIDATE AND f_C._NO-AUTO-VALIDATE <> ? THEN
       cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + string(NOT f_C._NO-AUTO-VALIDATE,"Yes/No":U).  
WHEN "BaseQuery":U THEN
   IF AVAILABLE q_U AND hBuffer:BUFFER-FIELD("setValue":U):BUFFER-VALUE <> cBaseQuery AND cBaseQuery <> ? THEN
       cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + cBaseQuery.  
WHEN "BLANK":U            THEN 
   IF AVAILABLE f_F AND isValueLogical(hBuffer) <>  f_F._BLANK AND f_F._BLANK <> ? THEN
     cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + string(f_F._BLANK,"yes/no":U). 
WHEN "BGColor":U          THEN 
   IF AVAILABLE f_L AND hBuffer:BUFFER-FIELD("setValue":U):BUFFER-VALUE <> STRING(f_L._BGCOLOR) THEN
     cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + (IF f_L._BGColor = ? THEN "?" ELSE string(f_L._BGCOLOR)).  
WHEN "BrowseColumnBGColors":U THEN
  IF AVAILABLE f_C AND hBuffer:BUFFER-FIELD("setValue":U):BUFFER-VALUE <> cBrwsColBGColors AND cBrwsColBGColors <> ? THEN
      cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + cBrwsColBGColors.
WHEN "BrowseColumnFGColors":U THEN
  IF AVAILABLE f_C AND hBuffer:BUFFER-FIELD("setValue":U):BUFFER-VALUE <> cBrwsColFGColors AND cBrwsColFGColors <> ? THEN
      cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + cBrwsColFGColors.
WHEN "BrowseColumnFonts":U THEN
  IF AVAILABLE f_C AND hBuffer:BUFFER-FIELD("setValue":U):BUFFER-VALUE <> cBrwsColFonts AND cBrwsColFonts <> ? THEN
      cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + cBrwsColFonts.
WHEN "BrowseColumnFormats":U THEN
  IF AVAILABLE f_C AND hBuffer:BUFFER-FIELD("setValue":U):BUFFER-VALUE <> cBrwsColFormats AND cBrwsColFormats <> ? THEN
      cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + cBrwsColFormats.
WHEN "BrowseColumnLabelBGColors":U THEN
  IF AVAILABLE f_C AND hBuffer:BUFFER-FIELD("setValue":U):BUFFER-VALUE <> cBrwsColLabelBGColors AND cBrwsColLabelBGColors <> ? THEN
      cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + cBrwsColLabelBGColors.
WHEN "BrowseColumnLabelFGColors":U THEN
  IF AVAILABLE f_C AND hBuffer:BUFFER-FIELD("setValue":U):BUFFER-VALUE <> cBrwsColLabelFGColors AND cBrwsColLabelFGColors <> ? THEN
      cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + cBrwsColLabelFGColors.
WHEN "BrowseColumnLabelFonts":U THEN
  IF AVAILABLE f_C AND hBuffer:BUFFER-FIELD("setValue":U):BUFFER-VALUE <> cBrwsColLabelFonts AND cBrwsColLabelFonts <> ? THEN
      cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + cBrwsColLabelFonts.
WHEN "BrowseColumnLabels":U THEN
  IF AVAILABLE f_C AND hBuffer:BUFFER-FIELD("setValue":U):BUFFER-VALUE <> cBrwsColLabels AND cBrwsColLabels <> ? THEN
      cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + cBrwsColLabels.
WHEN "BrowseColumnWidths":U THEN
  IF AVAILABLE f_C AND hBuffer:BUFFER-FIELD("setValue":U):BUFFER-VALUE <> cBrwsColWidths AND cBrwsColWidths <> ? THEN
      cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + cBrwsColWidths.
WHEN "BOX":U              THEN 
   IF AVAILABLE f_L AND isValueLogical(hBuffer) = f_L._NO-BOX AND f_L._NO-BOX <> ? THEN
     cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + STRING(NOT f_L._NO-BOX,"yes/no":U).  
WHEN "BOX-SELECTABLE":U THEN
   IF AVAILABLE f_C AND isValueLogical(hBuffer) <> f_C._BOX-SELECTABLE AND f_C._BOX-SELECTABLE <> ? THEN
      cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + string(f_C._BOX-SELECTABLE,"Yes/No":U).  
WHEN "COLUMN-MOVABLE":U THEN
   IF AVAILABLE f_C AND isValueLogical(hBuffer) <> f_C._COLUMN-MOVABLE AND f_C._COLUMN-MOVABLE <> ? THEN
      cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + string(f_C._COLUMN-MOVABLE,"Yes/No":U).  
WHEN "COLUMN-RESIZABLE":U THEN
   IF AVAILABLE f_C AND isValueLogical(hBuffer) <> f_C._COLUMN-RESIZABLE AND f_C._COLUMN-RESIZABLE <> ? THEN
      cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + string(f_C._COLUMN-RESIZABLE,"Yes/No":U).  
WHEN "COLUMN-SCROLLING":U THEN
   IF AVAILABLE f_C AND isValueLogical(hBuffer) <> f_C._COLUMN-SCROLLING AND f_C._COLUMN-SCROLLING <> ? THEN
      cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + string(f_C._COLUMN-SCROLLING,"Yes/No":U).  
WHEN "CHECKED":U          THEN 
  IF AVAILABLE f_F THEN
  DO:
     lTmp = (f_F._INITIAL-DATA = "Yes":U OR f_F._INITIAL-DATA = "True":U).
     IF hBuffer:BUFFER-FIELD("setValue":U):BUFFER-VALUE <> lTmp AND lTmp <> ? THEN
        cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + STRING(lTmp).
  END.
WHEN "COLUMN":U           THEN
   IF AVAILABLE f_L AND hBuffer:BUFFER-FIELD("setValue":U):BUFFER-VALUE <> STRING(f_L._COL) AND f_L._COL <> ? THEN
     cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + STRING(f_L._COL).  
WHEN "CONTEXT-HELP-ID":U  THEN 
  IF AVAILABLE f_U AND hBuffer:BUFFER-FIELD("setValue":U):BUFFER-VALUE <>   string(f_U._CONTEXT-HELP-ID) AND f_U._CONTEXT-HELP-ID <> ? THEN
       cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + string(f_U._CONTEXT-HELP-ID).  
WHEN "CONVERT-3D-COLORS":U THEN 
  IF AVAILABLE f_L AND isValueLogical(hBuffer) <>  f_L._CONVERT-3D-COLORS AND f_L._CONVERT-3D-COLORS <> ? THEN
      cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + string(f_L._CONVERT-3D-COLORS,"yes/no":U).  
WHEN "DataColumns":U THEN
   IF AVAILABLE q_U AND hBuffer:BUFFER-FIELD("setValue":U):BUFFER-VALUE <> cDataColumns AND cDataColumns <> ? THEN
       cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + cDataColumns.  
WHEN "DataColumnsByTable":U THEN  /* SDO specific */
  IF AVAILABLE q_Q AND hBuffer:BUFFER-FIELD("setValue":U):BUFFER-VALUE <> cDataColumnsByTable AND cDataColumnsByTable <> ? THEN
       cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + cDataColumnsByTable.  
WHEN "DataLogicProcedure":U THEN
  IF AVAILABLE f_C AND hBuffer:BUFFER-FIELD("setValue":U):BUFFER-VALUE <> f_C._DATA-LOGIC-PROC AND f_C._DATA-LOGIC-PROC <> ? THEN
       cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + f_C._DATA-LOGIC-PROC.  
WHEN "Data-Type":U        THEN 
  IF AVAILABLE f_F AND hBuffer:BUFFER-FIELD("setValue":U):BUFFER-VALUE <> f_F._DATA-TYPE AND f_F._DATA-TYPE <> ? THEN
       cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + f_F._DATA-TYPE.  
WHEN "DEBLANK":U          THEN 
  IF AVAILABLE f_F AND isValueLogical(hBuffer) <>  f_F._DEBLANK  AND f_F._DEBLANK <> ? THEN
      cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + string(f_F._DEBLANK,"yes/no":U).  
WHEN "DEFAULT":U          THEN 
  IF AVAILABLE f_F AND isValueLogical(hBuffer) <> f_F._DEFAULT AND f_F._DEFAULT <> ? THEN
      cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + string(f_F._DEFAULT,"yes/no":U).  
WHEN "DELIMITER":U        THEN 
  IF AVAILABLE f_F AND hBuffer:BUFFER-FIELD("setValue":U):BUFFER-VALUE <> f_F._DELIMITER AND f_F._DELIMITER <> ? THEN
      cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + f_F._DELIMITER.  
WHEN "DISABLE-AUTO-ZAP":U THEN
  IF AVAILABLE f_F AND isValueLogical(hBuffer) <> f_F._DISABLE-AUTO-ZAP AND f_F._DISABLE-AUTO-ZAP <> ? THEN
       cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + string(f_F._DISABLE-AUTO-ZAP,"yes/no":U).  
WHEN "DisplayedFields":U THEN
  IF AVAILABLE f_C AND hBuffer:BUFFER-FIELD("setValue":U):BUFFER-VALUE <> cBrowseFields AND cBrowseFields <> ? THEN
      cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + cBrowseFields.
WHEN "DisplayField":U     THEN 
  IF AVAILABLE f_U AND isValueLogical(hBuffer) <>  f_U._DISPLAY AND  f_U._DISPLAY <> ? THEN
      cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + STRING(f_U._DISPLAY,"yes/no":U).  
WHEN "DOWN":U            THEN
  IF AVAILABLE f_C AND isValueLogical(hBuffer) <> f_C._DOWN AND f_C._DOWN <> ? THEN
       cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + string(f_C._DOWN,"Yes/No":U).  
WHEN "DRAG-ENABLED":U     THEN 
  IF AVAILABLE f_F AND isValueLogical(hBuffer) <> f_F._DRAG-ENABLED AND f_F._DRAG-ENABLED <> ? THEN
      cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + string(f_F._DRAG-ENABLED,"yes/no":U).  
WHEN "DROP-TARGET":U      THEN
  IF AVAILABLE f_U AND isValueLogical(hBuffer) <> f_U._DROP-TARGET AND f_U._DROP-TARGET <> ? THEN
       cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + string(f_U._DROP-TARGET,"yes/no":U).  
WHEN "EDGE-PIXELS":U      THEN 
  IF AVAILABLE f_L AND hBuffer:BUFFER-FIELD("setValue":U):BUFFER-VALUE <> STRING(f_L._EDGE-PIXELS) AND f_L._EDGE-PIXELS <> ? THEN
      cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + STRING(f_L._EDGE-PIXEL).  
WHEN "ENABLED":U          THEN 
  IF AVAILABLE f_U AND isValueLogical(hBuffer) <> f_U._ENABLE  AND f_U._ENABLE <> ? THEN
       cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + string(f_U._ENABLE,"yes/no":U).  
WHEN "EnabledFields":U THEN
  IF AVAILABLE f_C AND hBuffer:BUFFER-FIELD("setValue":U):BUFFER-VALUE <> cEnabledFields AND cEnabledFields <> ? THEN
      cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + cEnabledFields.
WHEN "EXPAND":U           THEN 
  IF AVAILABLE f_F AND isValueLogical(hBuffer) <> f_F._EXPAND AND f_F._EXPAND <> ? THEN
     cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + string(f_F._EXPAND,"yes/no":U).  
WHEN "FGCOLOR":U          THEN 
  IF AVAILABLE f_L AND hBuffer:BUFFER-FIELD("setValue":U):BUFFER-VALUE <>  STRING(f_L._FGCOLOR) THEN
     cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + (IF f_L._FGColor = ? THEN "?" ELSE string(f_L._FGCOLOR)).    
WHEN "FILLED":U           THEN 
  IF AVAILABLE f_L AND isValueLogical(hBuffer) <> f_L._FILLED AND f_L._FILLED <> ? THEN
     cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + string(f_L._FILLED,"yes/no":U).  
WHEN "FIT-LAST-COLUMN":U  THEN
  IF AVAILABLE f_C AND isValueLogical(hBuffer) <> f_C._FIT-LAST-COLUMN AND f_C._FIT-LAST-COLUMN <> ? THEN
       cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + string(f_C._FIT-LAST-COLUMN,"Yes/No":U).  
WHEN "FolderWindowToLaunch":U THEN
  IF AVAILABLE f_C AND hBuffer:BUFFER-FIELD("setValue":U):BUFFER-VALUE <> f_C._FOLDER-WINDOW-TO-LAUNCH AND f_C._FOLDER-WINDOW-TO-LAUNCH <> ? THEN
       cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + f_C._FOLDER-WINDOW-TO-LAUNCH .  
WHEN "FLAT-BUTTON":U      THEN 
  IF AVAILABLE f_F AND isValueLogical(hBuffer) <> f_F._FLAT  AND f_F._FLAT <> ? THEN
     cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + string(f_F._FLAT,"yes/no":U).  
WHEN "FONT":U             THEN 
  IF hBuffer:BUFFER-FIELD("setValue":U):BUFFER-VALUE <>  STRING(f_L._FONT)  THEN
    cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + (IF f_L._FONT = ? THEN "?" ELSE string(f_L._FONT)).     
WHEN "FORMAT":U THEN 
  IF AVAILABLE f_F AND hBuffer:BUFFER-FIELD("setValue":U):BUFFER-VALUE <>  STRING(f_F._FORMAT) AND f_F._FORMAT <> ? THEN
    cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + STRING(f_F._FORMAT).  
WHEN "GRAPHIC-EDGE":U     THEN 
  IF AVAILABLE f_L AND isValueLogical(hBuffer) <>  f_L._GRAPHIC-EDGE  AND f_L._GRAPHIC-EDGE <> ?  THEN
    cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + string(f_L._GRAPHIC-EDGE,"yes/no":U).  
WHEN "HEIGHT-CHARS":U THEN
  IF AVAILABLE f_L AND hBuffer:BUFFER-FIELD("setValue":U):BUFFER-VALUE <> STRING(f_L._HEIGHT)  AND f_L._HEIGHT <> ?  THEN
    cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + string(f_L._HEIGHT).  
WHEN "HELP":U             THEN 
  IF AVAILABLE f_U AND hBuffer:BUFFER-FIELD("setValue":U):BUFFER-VALUE <> f_U._HELP AND f_U._HELP <> ? THEN
    cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + f_U._HELP.  
WHEN "HIDDEN":U           THEN 
  IF AVAILABLE f_U AND isValueLogical(hBuffer) <>  f_U._HIDDEN  AND  f_U._HIDDEN <> ?  THEN
    cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + string(f_U._HIDDEN,"yes/no":U) + CHR(3) 
                                     + "VISIBLE":u + CHR(3) + cResultCode + CHR(3) + string(NOT f_U._HIDDEN,"yes/no":U) .
WHEN "HORIZONTAL":U       THEN 
  IF AVAILABLE f_F AND isValueLogical(hBuffer) <>  f_F._HORIZONTAL  AND f_F._HORIZONTAL <> ? THEN
    cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + string(f_F._HORIZONTAL,"yes/no":U).  
WHEN "IMAGE-FILE":U       THEN 
    IF AVAILABLE f_F AND hBuffer:BUFFER-FIELD("setValue":U):BUFFER-VALUE <>  f_F._IMAGE-FILE  AND f_F._IMAGE-FILE <> ? THEN
      cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + f_F._IMAGE-FILE.  
WHEN "InitialValue":U THEN 
   IF AVAILABLE f_F AND hBuffer:BUFFER-FIELD("setValue":U):BUFFER-VALUE <> f_F._INITIAL-DATA  AND f_F._INITIAL-DATA <> ?  THEN
     cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + string(f_F._INITIAL-DATA).          
WHEN "Inner-Lines":U      THEN 
  IF AVAILABLE f_F AND hBuffer:BUFFER-FIELD("setValue":U):BUFFER-VALUE <> STRING(f_F._INNER-LINES) AND f_F._INNER-LINES <> ? THEN
     cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + STRING(f_F._INNER-LINES).  
WHEN "LABEL":U  OR WHEN "ColumnLabel"THEN
  IF AVAILABLE f_U AND hBuffer:BUFFER-FIELD("setValue":U):BUFFER-VALUE <> f_U._LABEL  THEN
     cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + (IF f_U._LABEL = ? THEN f_U._NAME ELSE f_U._LABEL).  
WHEN "FieldLabel":U THEN  
  IF AVAILABLE f_U AND hBuffer:BUFFER-FIELD("setValue":U):BUFFER-VALUE <> f_U._LABEL THEN
     cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + (IF f_U._LABEL = ? THEN "" ELSE f_U._LABEL).  
WHEN "LABELS":U           THEN 
  IF AVAILABLE f_L AND isValueLogical(hBuffer) = f_L._NO-LABELS  AND f_L._NO-LABELS <> ?  THEN
    cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + string(NOT f_L._NO-LABELS,"yes/no":U).  
WHEN "LARGE":U            THEN 
  IF AVAILABLE f_F AND isValueLogical(hBuffer) <> f_F._LARGE AND f_F._LARGE <> ? THEN
    cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + string(f_F._LARGE,"yes/no":U).  
WHEN "LIST-ITEM-PAIRS":U  THEN
  IF AVAILABLE f_F THEN 
  DO:
     cTmp = REPLACE(f_F._LIST-ITEM-PAIRS, CHR(10), "":U). 
     IF hBuffer:BUFFER-FIELD("setValue":U):BUFFER-VALUE <> cTmp AND cTmp <> ? THEN
      cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + cTmp.  
  END.
WHEN "LIST-ITEMS":U       THEN 
   IF AVAILABLE f_F AND f_U._TYPE NE "RADIO-SET":U THEN 
   DO:
      cTmp = REPLACE(f_F._LIST-ITEMS, CHR(10), f_F._DELIMITER) .
      IF hBuffer:BUFFER-FIELD("setValue":U):BUFFER-VALUE <> cTmp AND cTmp <> ?  THEN
         cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + cTmp.  
   END.
WHEN "MANUAL-HIGHLIGHT":U THEN 
   IF AVAILABLE f_U AND isValueLogical(hBuffer) <>  f_U._MANUAL-HIGHLIGHT AND f_U._MANUAL-HIGHLIGHT <> ? THEN
      cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + string(f_U._MANUAL-HIGHLIGHT,"yes/no":U).  
WHEN "MAX-DATA-GUESS":U  THEN
  IF AVAILABLE f_C AND hBuffer:BUFFER-FIELD("setValue":U):BUFFER-VALUE <> f_C._MAX-DATA-GUESS AND f_C._MAX-DATA-GUESS <> ? THEN
       cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + STRING(f_C._MAX-DATA-GUESS).  
WHEN "MAX-CHARS":U        THEN 
   IF AVAILABLE f_F AND hBuffer:BUFFER-FIELD("setValue":U):BUFFER-VALUE <>  STRING(f_F._MAX-CHARS) AND f_F._MAX-CHARS <> ? THEN
     cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + STRING(f_F._MAX-CHARS).  
WHEN "MOVABLE":U          THEN 
   IF AVAILABLE f_U AND isValueLogical(hBuffer) <> f_U._MOVABLE AND f_U._MOVABLE <> ? THEN
    cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + string(f_U._MOVABLE,"yes/no":U).  
WHEN "MULTIPLE":U         THEN 
   IF AVAILABLE f_F AND isValueLogical(hBuffer) <> f_F._MULTIPLE AND f_F._MULTIPLE <> ? THEN
       cAttribute = cAttribute + CHR(3) + "MULTIPLE" + CHR(3) + cResultCode + CHR(3) + string(f_F._MULTIPLE,"yes/no":U).  
WHEN "NAME":U  THEN
  IF AVAILABLE f_U AND hBuffer:BUFFER-FIELD("setValue":U):BUFFER-VALUE <> f_U._NAME AND f_U._NAME  <> ? THEN
      cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + f_U._NAME.  
WHEN "WidgetName":U       THEN 
  IF AVAILABLE f_U AND hBuffer:BUFFER-FIELD("setValue":U):BUFFER-VALUE <> f_U._NAME AND f_U._NAME  <> ? THEN
      cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + f_U._NAME.  
WHEN "NO-FOCUS":U         THEN 
  IF AVAILABLE f_L AND isValueLogical(hBuffer) <> f_L._NO-FOCUS AND f_L._NO-FOCUS <> ? THEN
     cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + string(f_L._NO-FOCUS,"yes/no":U).  
WHEN "NO-EMPTY-SPACE":U  THEN
  IF AVAILABLE f_C AND isValueLogical(hBuffer) <> f_C._NO-EMPTY-SPACE AND f_C._NO-EMPTY-SPACE <> ? THEN
       cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + string(f_C._NO-EMPTY-SPACE,"Yes/No":U).  
WHEN "NUM-LOCKED-COLUMNS":U  THEN
  IF AVAILABLE f_C AND hBuffer:BUFFER-FIELD("setValue":U):BUFFER-VALUE <> f_C._NUM-LOCKED-COLUMNS AND f_C._NUM-LOCKED-COLUMNS <> ? THEN
       cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + STRING(f_C._NUM-LOCKED-COLUMNS).  
WHEN "ORDER":U            THEN 
   IF AVAILABLE f_U AND hBuffer:BUFFER-FIELD("setValue":U):BUFFER-VALUE <>  STRING(f_U._TAB-ORDER) AND f_U._TAB-ORDER > 0 AND f_U._TAB-ORDER <> ? THEN
      cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + STRING(f_U._TAB-ORDER).  
WHEN "OVERLAY":U  THEN
  IF AVAILABLE f_C AND isValueLogical(hBuffer) <> f_C._OVERLAY AND f_C._OVERLAY <> ? THEN
       cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + string(f_C._OVERLAY,"Yes/No":U).  
WHEN "PAGE-BOTTOM":U  THEN
  IF AVAILABLE f_C AND isValueLogical(hBuffer) <> f_C._PAGE-BOTTOM AND f_C._PAGE-BOTTOM <> ? THEN
       cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + string(f_C._PAGE-BOTTOM,"Yes/No":U).  
WHEN "PAGE-TOP":U  THEN
  IF AVAILABLE f_C AND isValueLogical(hBuffer) <> f_C._PAGE-TOP AND f_C._PAGE-TOP <> ? THEN
       cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + string(f_C._PAGE-TOP,"Yes/No":U).  
WHEN "PRIVATE-DATA":U     THEN 
   IF AVAILABLE f_U AND hBuffer:BUFFER-FIELD("setValue":U):BUFFER-VALUE <>  f_U._PRIVATE-DATA  AND f_U._PRIVATE-DATA <> ? THEN
      cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + f_U._PRIVATE-DATA.  
WHEN "QueryBuilderFieldDataTypes":U THEN
       IF AVAILABLE q_Q AND hBuffer:BUFFER-FIELD("setValue":U):BUFFER-VALUE <> cQBFieldDataTypes AND cQBFieldDataTypes <> ? THEN
          cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + cQBFieldDataTypes.  
WHEN "QueryBuilderDBNames":U THEN
   IF AVAILABLE q_Q AND hBuffer:BUFFER-FIELD("setValue":U):BUFFER-VALUE <> cQBFieldDBNames AND cQBFieldDBNames <> ? THEN
       cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + cQBFieldDBNames.  
WHEN "QueryBuilderFieldFormatList":U THEN
   IF AVAILABLE q_Q AND hBuffer:BUFFER-FIELD("setValue":U):BUFFER-VALUE <> cQBFieldFormats AND cQBFieldFormats <> ? THEN
       cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + cQBFieldFormats.  
WHEN "QueryBuilderFieldHelp":U THEN
   IF AVAILABLE q_Q AND hBuffer:BUFFER-FIELD("setValue":U):BUFFER-VALUE <> cQBFieldHelp AND cQBFieldHelp <> ? THEN
      cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + cQBFieldHelp.  
WHEN "QueryBuilderFieldLabelList":U THEN
   IF AVAILABLE q_Q AND hBuffer:BUFFER-FIELD("setValue":U):BUFFER-VALUE <> cQBFieldLabels AND cQBFieldLabels <> ? THEN
      cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + cQBFieldLabels.  
WHEN "QueryBuilderFieldWidths":U THEN
   IF AVAILABLE q_Q AND hBuffer:BUFFER-FIELD("setValue":U):BUFFER-VALUE <> cQBFieldWidths AND cQBFieldWidths <> ? THEN
      cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + cQBFieldWidths.
WHEN "QueryBuilderInheritValidations":U THEN
   IF AVAILABLE q_Q AND hBuffer:BUFFER-FIELD("setValue":U):BUFFER-VALUE <> cQBInhVals AND cQBInhVals <> ? THEN
      cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + cQBInhVals.
WHEN "QueryBuilderJoinCode":U THEN
   IF AVAILABLE q_Q AND hBuffer:BUFFER-FIELD("setValue":U):BUFFER-VALUE <> cQBJoinCode AND cQBJoinCode <> ? THEN
      cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + cQBJoinCode.
WHEN "QueryBuilderOptionList":U THEN
   IF AVAILABLE q_Q AND hBuffer:BUFFER-FIELD("setValue":U):BUFFER-VALUE <> q_Q._OptionList THEN
      cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) +  q_Q._OptionList.
WHEN "QueryBuilderOrderList":U THEN
   IF AVAILABLE q_Q AND hBuffer:BUFFER-FIELD("setValue":U):BUFFER-VALUE <> q_Q._OrdList THEN
      cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) +  q_Q._OrdList.
WHEN "QueryBuilderTableOptionList":U THEN
   IF AVAILABLE q_Q AND hBuffer:BUFFER-FIELD("setValue":U):BUFFER-VALUE <> q_Q._TblOptList THEN
      cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) +  q_Q._TblOptList.
WHEN "QueryBuilderTuneOptions":U THEN
   IF AVAILABLE q_Q AND hBuffer:BUFFER-FIELD("setValue":U):BUFFER-VALUE <> q_Q._TuneOptions THEN
      cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) +  q_Q._TuneOptions.   
WHEN "QueryBuilderWhereClauses":U THEN
   IF AVAILABLE q_Q AND hBuffer:BUFFER-FIELD("setValue":U):BUFFER-VALUE <> cQBWhereClauses AND cQBWhereClauses <> ? THEN
      cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + cQBWhereClauses.
WHEN "RADIO-BUTTONS":U  THEN 
  IF AVAILABLE f_F AND f_U._TYPE = "RADIO-SET":U THEN 
  DO:
    cTmp = f_F._LIST-ITEMS.
    DO i = 1 TO NUM-ENTRIES(cTmp, f_F._DELIMITER):
       ENTRY(i, cTmp, f_F._DELIMITER) = TRIM(TRIM(ENTRY(i, cTmp, f_F._DELIMITER)), '"').
    END.
    IF hBuffer:BUFFER-FIELD("setValue":U):BUFFER-VALUE <> cTmp AND cTmp <> ?  THEN
        cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + f_F._LIST-ITEMS.  
  END.
WHEN "READ-ONLY":U        THEN 
  IF AVAILABLE f_F AND isValueLogical(hBuffer) <>  f_F._READ-ONLY  AND f_F._READ-ONLY <> ?  THEN
     cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + string(f_F._READ-ONLY,"yes/no":U).  
WHEN "RESIZABLE":U        THEN 
  IF AVAILABLE f_U AND isValueLogical(hBuffer) <>  f_U._RESIZABLE AND f_U._RESIZABLE <> ?  THEN
     cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + string(f_U._RESIZABLE,"yes/no":U).  
WHEN "RETAIN-SHAPE":U     THEN 
  IF AVAILABLE f_F AND isValueLogical(hBuffer) <>  f_F._RETAIN-SHAPE AND f_F._RETAIN-SHAPE <> ? THEN
     cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + string(f_F._RETAIN-SHAPE,"yes/no":U).  
WHEN "RETURN-INSERTED":U  THEN 
  IF AVAILABLE f_F AND isValueLogical(hBuffer) <>  f_F._RETURN-INSERTED AND f_F._RETURN-INSERTED <> ? THEN
    cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + string(f_F._RETURN-INSERTED,"yes/no":U).  
WHEN "ROW":U               THEN
  IF AVAILABLE f_L AND hBuffer:BUFFER-FIELD("setValue":U):BUFFER-VALUE <> STRING(f_L._ROW) AND f_L._ROW <> ? THEN
     cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + STRING(f_L._ROW).  
WHEN "ROW-HEIGHT-CHARS":U  THEN
  IF AVAILABLE f_C AND hBuffer:BUFFER-FIELD("setValue":U):BUFFER-VALUE <> f_C._ROW-HEIGHT AND f_C._ROW-HEIGHT <> ? THEN
       cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + STRING(f_C._ROW-HEIGHT).  
WHEN "ROW-MARKERS":U       THEN
  IF AVAILABLE f_C AND isValueLogical(hBuffer) <> f_C._NO-ROW-MARKERS AND f_C._NO-ROW-MARKERS <> ? THEN
       cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + string(NOT f_C._NO-ROW-MARKERS,"Yes/No":U).  
WHEN "SCROLLABLE":U        THEN
  IF AVAILABLE f_C AND isValueLogical(hBuffer) <> f_C._SCROLLABLE AND f_C._SCROLLABLE <> ? THEN
       cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + string(f_C._SCROLLABLE,"Yes/No":U).  
WHEN "SCROLLBAR-HORIZONTAL":U THEN 
  IF AVAILABLE f_F AND isValueLogical(hBuffer) <>  f_F._SCROLLBAR-H AND f_F._SCROLLBAR-H <> ? THEN
    cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + string(f_F._SCROLLBAR-H,"yes/no":U).  
WHEN "SCROLLBAR-VERTICAL":U THEN 
  IF AVAILABLE f_U AND isValueLogical(hBuffer) <>  f_U._SCROLLBAR-V  AND f_U._SCROLLBAR-V <> ? THEN
    cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + string(f_U._SCROLLBAR-V,"yes/no":U).  
WHEN "SELECTABLE":U        THEN 
  IF AVAILABLE f_U AND isValueLogical(hBuffer) <>  f_U._SELECTABLE  AND f_U._SELECTABLE <> ? THEN
    cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + string(f_U._SELECTABLE,"yes/no":U).  
WHEN "SENSITIVE":U         THEN 
  IF AVAILABLE f_U AND isValueLogical(hBuffer) <>  f_U._SENSITIVE AND f_U._SENSITIVE <> ? THEN
    cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + string(f_U._SENSITIVE,"yes/no":U).  
WHEN "SEPARATOR-FGCOLOR":U THEN
  IF AVAILABLE f_L AND hBuffer:BUFFER-FIELD("setValue":U):BUFFER-VALUE <> STRING(f_L._SEPARATOR-FGCOLOR) AND f_L._SEPARATOR-FGCOLOR <> ? THEN
     cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + STRING(f_L._SEPARATOR-FGCOLOR).  
WHEN "SEPARATORS":U        THEN 
  IF AVAILABLE f_L AND isValueLogical(hBuffer) <> f_L._SEPARATORS AND f_L._SEPARATORS <> ? THEN
     cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + string(f_L._SEPARATORS,"yes/no":U).  
WHEN "ShowPopup":U        THEN 
  IF AVAILABLE f_U AND isValueLogical(hBuffer) <>  f_U._SHOW-POPUP AND f_U._SHOW-POPUP <> ? THEN
    cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + string(f_U._SHOW-POPUP,"yes/no":U).  
WHEN "SIDE-LABELS":U        THEN
  IF AVAILABLE f_C AND isValueLogical(hBuffer) <> f_C._SIDE-LABELS AND f_C._SIDE-LABELS <> ? THEN
       cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + string(f_C._SIDE-LABELS,"Yes/No":U).  
WHEN "SizeToFit":U        THEN
  IF AVAILABLE f_C AND isValueLogical(hBuffer) <> f_C._SIZE-TO-FIT AND f_C._SIZE-TO-FIT <> ? THEN
       cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + string(f_C._SIZE-TO-FIT,"Yes/No":U).  
WHEN "SORT":U             THEN 
  IF AVAILABLE f_F AND isValueLogical(hBuffer) <>  f_F._SORT AND f_F._SORT <> ? THEN
    cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + string(f_F._SORT,"yes/no":U).  
WHEN "STRETCH-TO-FIT":U   THEN 
  IF AVAILABLE f_F AND isValueLogical(hBuffer) <>  f_F._STRETCH-TO-FIT  AND f_F._STRETCH-TO-FIT <> ? THEN
     cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + string(f_F._STRETCH-TO-FIT,"yes/no":U).  
WHEN "SUBTYPE":U          THEN 
IF AVAILABLE f_U THEN DO:
   IF f_U._TYPE EQ "FILL-IN":U AND  f_U._SUBTYPE EQ "":U THEN
      f_U._SUBTYPE = "PROGRESS":U.
   IF hBuffer:BUFFER-FIELD("setValue":U):BUFFER-VALUE <>   f_U._SUBTYPE   AND f_U._SUBTYPE <> ? THEN
     cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + f_U._SUBTYPE.  
END.
WHEN "TAB-STOP":U         THEN 
   IF AVAILABLE f_U AND isValueLogical(hBuffer) =  f_U._NO-TAB-STOP AND f_U._NO-TAB-STOP <> ?  THEN
     cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + STRING(NOT f_U._NO-TAB-STOP,"yes/no":U).  
WHEN "TableName":U        THEN 
   IF AVAILABLE f_U AND hBuffer:BUFFER-FIELD("setValue":U):BUFFER-VALUE <>   f_U._TABLE   AND f_U._TABLE <> ? THEN
     cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + f_U._TABLE.  
WHEN "Tables":U THEN  /* DynSDO specific */
   IF AVAILABLE q_U AND hBuffer:BUFFER-FIELD("setValue":U):BUFFER-VALUE <> cTables AND cTables <> ? THEN
      cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + cTables.
WHEN "THREE-D":U          THEN 
  IF AVAILABLE f_L AND isValueLogical(hBuffer) <>  f_L._3-D AND  f_L._3-D <> ?  THEN
     cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + string(f_L._3-D,"yes/no":U).  
WHEN "Tooltip":U          THEN 
   IF AVAILABLE f_U AND hBuffer:BUFFER-FIELD("setValue":U):BUFFER-VALUE <> f_U._TOOLTIP AND f_U._TOOLTIP <> ? THEN
     cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + f_U._TOOLTIP.  
WHEN "TRANSPARENT":U      THEN 
    IF AVAILABLE f_F AND isValueLogical(hBuffer) <>  f_F._TRANSPARENT AND f_F._TRANSPARENT <> ?   THEN
     cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + string(f_F._TRANSPARENT,"yes/no":U).  
WHEN "UpdatableColumns":U THEN  /* SDO specific */
  IF AVAILABLE q_Q AND hBuffer:BUFFER-FIELD("setValue":U):BUFFER-VALUE <> cUpdatableColumns AND cUpdatableColumns <> ? THEN
     cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + cUpdatableColumns.
WHEN "UpdatableColumnsByTable":U THEN  /* SDO specific */
  IF AVAILABLE q_Q AND hBuffer:BUFFER-FIELD("setValue":U):BUFFER-VALUE <> cUpdatableColumnsByTable AND cUpdatableColumnsByTable <> ? THEN
     cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + cUpdatableColumnsByTable.      
WHEN "VISIBLE":U THEN 
  IF AVAILABLE f_U AND NOT isValueLogical(hBuffer) <>  f_U._HIDDEN  AND  f_U._HIDDEN <> ?  THEN
    cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + string(NOT f_U._HIDDEN,"yes/no":U) + CHR(3) 
                                     + "HIDDEN":u + CHR(3) + cResultCode + CHR(3) + string(f_U._HIDDEN,"yes/no":U) .
WHEN "VisualizationType":U THEN 
   IF AVAILABLE f_U AND hBuffer:BUFFER-FIELD("setValue":U):BUFFER-VALUE <> f_U._TYPE AND f_U._TYPE <> ? THEN
      cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + f_U._TYPE.  
WHEN "WIDTH-CHARS":U THEN
   IF AVAILABLE f_L AND hBuffer:BUFFER-FIELD("setValue":U):BUFFER-VALUE <> STRING(f_L._WIDTH)  AND f_L._WIDTH <> ?  THEN
      cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + string(f_L._WIDTH).  
WHEN "WindowTitleField":U  THEN
  IF AVAILABLE f_C AND hBuffer:BUFFER-FIELD("setValue":U):BUFFER-VALUE <> f_C._WINDOW-TITLE-FIELD AND f_C._WINDOW-TITLE-FIELD <> ? THEN
       cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + f_C._WINDOW-TITLE-FIELD.  
WHEN "WORD-WRAP":U        THEN 
   IF AVAILABLE f_F AND isValueLogical(hBuffer) <>  f_F._WORD-WRAP AND  f_F._WORD-WRAP <> ?  THEN
          cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + string(f_F._WORD-WRAP,"yes/no":U).  
