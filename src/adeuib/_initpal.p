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

File: _initpal.p

Description:
   Initialize the object palette temp-table.

Input Parameters:
   <None>

Output Parameters:
   <None>

Author: Gerry Seidl

Date Created: 02/09/1995

----------------------------------------------------------------------------*/
{adeuib/sharvars.i} /* Most common shared variables        */
{adeuib/custwidg.i} /* temp-table def */
{adecomm/adestds.i} /* std ADE globals */

/*
 * When adding any new widgets, they must be added before DB-Fields and the
 * Pointer. Otherwise the palette layout algorithm falls apart.
 *
 * TheVBX control is a 16bit windows only feature. This list drives the palette
 * code. Don't put the control into the list on an non PC 16bit platform.
 */

DEFINE VARIABLE palette_widgets AS CHAR INITIAL "Browse,Frame,Rectangle,Image,Radio-Set,~
Toggle-Box,Slider,Button,Selection-List,Editor,Combo-Box,Fill-In,Text,~
{&WT-CONTROL},DB-Fields,Pointer,Query".

DEFINE VARIABLE menu_name AS CHAR INITIAL "Br&owse,&Frame,Rect&angle,&Image,&Radio-Set,~
&Toggle-Box,Sli&der,&Button,&Selection-List,&Editor,&Combo-Box,Fi&ll-in,Te&xt,~
{&WL-CONTROL},&DB Fields,Poi&nter,&Query".


DEFINE VARIABLE i     AS INTEGER   NO-UNDO.
DEFINE VARIABLE nextX AS INTEGER   NO-UNDO INITIAL 0.
DEFINE VARIABLE nextY AS INTEGER   NO-UNDO INITIAL 0.
DEFINE VARIABLE o-pp  AS CHARACTER NO-UNDO.

o-pp = PROPATH.
MOD-PROPATH:
DO i = 1 TO NUM-ENTRIES(o-pp):
  IF ENTRY(i,o-pp) MATCHES "*adeicon.pl*" THEN DO:
    PROPATH = ENTRY(i,o-pp) + "," + PROPATH.
    LEAVE MOD-PROPATH.
  END.
END.

&IF DEFINED(ADEICONDIR) = 0 &THEN
 {adecomm/icondir.i}
&ENDIF

/*
 * The VBX control/container is only suppotred on the 16-bit MSW platform (MSDOS).
 */
IF NOT SESSION:WINDOW-SYSTEM BEGINS "MS-WIN" THEN
ASSIGN
  palette_widgets = REPLACE(palette_widgets, ",{&WT-CONTROL}", "")
  menu_name = REPLACE(menu_name, ",{&WL-CONTROL}", "") .

ASSIGN _palette_count = NUM-ENTRIES(palette_widgets).
FOR EACH _palette_item:
    DELETE _palette_item.
END.

DO i = 1 to _palette_count:

    CREATE _palette_item.
    ASSIGN _palette_item._NAME      = ENTRY(i,palette_widgets)
           _palette_item._LABEL     = ENTRY(i,menu_name)
           _palette_item._LABEL2    = REPLACE(ENTRY(i,palette_widgets),"-"," ")
           _palette_item._ORDER     = IF _palette_item._NAME = "Pointer"   THEN 1 ELSE 
                                      IF _palette_item._NAME = "DB-Fields" THEN 2 ELSE
                                      IF _palette_item._NAME = "Query"     THEN 3 
                                      ELSE (i + 3)
           _palette_item._ICON_UP   = {&ADEICON-DIR} + "wp_up"
           _palette_item._ICON_DOWN = {&ADEICON-DIR} + "wp_down"
           _palette_item._ICON_UP_X   = nextX
           _palette_item._ICON_DOWN_X = nextX
           _palette_item._ICON_UP_Y   = nextY
           _palette_item._ICON_DOWN_Y = nextY.
           
    IF nextX = 0 THEN
      ASSIGN nextX = nextX + {&ImageSize}.
    ELSE
      ASSIGN nextX = 0
             nextY = nextY + {&ImageSize}.
             
    CASE _palette_item._NAME:
        WHEN "{&WT-CONTROL}" THEN DO:
            define variable wDir as character no-undo.
            define variable s    as integer   no-undo.
            
            run adeshar/_getwdir.p(output wDir, output s).

            ASSIGN _palette_item._TYPE = {&P-XCONTROL}
            	   _palette_item._attr = "DIRECTORY-LIST "
            	                       + wDir
                                       + "~\system32"
            	                       + ","
                                       + wDir
                                       + ",.,"
                                       + replace(os-getenv("PATH"), ";", ",")
                                       + CHR(10)
            	                       + "FILTER *.ocx"
                   _palette_item._ICON_UP_X   = 0
                   _palette_item._ICON_DOWN_X = 0
                   _palette_item._ICON_UP_Y   = 240
                   _palette_item._ICON_DOWN_Y = 240.
        END.                                    
        WHEN "DB-Fields" THEN
            ASSIGN _palette_item._TYPE = {&P-BASIC}
                   _palette_item._ICON_UP_X   = 0
                   _palette_item._ICON_DOWN_X = 0
                   _palette_item._ICON_UP_Y   = 216
                   _palette_item._ICON_DOWN_Y = 216
                   _palette_item._dbconnect   = YES.
        WHEN "Pointer" THEN
            ASSIGN _palette_item._TYPE = {&P-BASIC}
                   _palette_item._ICON_UP_X   = 24
                   _palette_item._ICON_DOWN_X = 24
                   _palette_item._ICON_UP_Y   = 216
                   _palette_item._ICON_DOWN_Y = 216.
        WHEN "Query" THEN
            ASSIGN _palette_item._TYPE = {&P-BASIC}
                   _palette_item._ICON_UP_X   = 24
                   _palette_item._ICON_DOWN_X = 24
                   _palette_item._ICON_UP_Y   = 240
                   _palette_item._ICON_DOWN_Y = 240
                   _palette_item._dbconnect   = YES.
        WHEN "Browse" THEN
            ASSIGN _palette_item._TYPE = {&P-BASIC}
                   _palette_item._dbconnect   = YES.
        OTHERWISE ASSIGN _palette_item._TYPE = {&P-BASIC}.  
    END CASE.                                                                       
END.
PROPATH = o-pp.
