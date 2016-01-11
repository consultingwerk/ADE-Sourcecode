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

File: _getxftr.p

Description:
   Loads user xftrs from the xftr file. And displays the palette.

Input Parameters:
   <None>
   
Output Parameters:
   <None>
   
Author:  Gerry Seidl

Date Created: September 29, 1994 

----------------------------------------------------------------------------*/
{ adeuib/sharvars.i }
{ adeuib/xftr.i }

DEFINE INPUT PARAMETER  hUIB     AS HANDLE NO-UNDO. /* handle of _uibmain.p */
DEFINE OUTPUT PARAMETER hPalette AS HANDLE NO-UNDO. /* handle of palette */

DEFINE VARIABLE hdl            AS WIDGET   NO-UNDO.
DEFINE VARIABLE pitems         AS CHAR     NO-UNDO. /* palette items */
DEFINE VARIABLE ptdat          AS CHAR     NO-UNDO. /* loc of dat file */
DEFINE VARIABLE s_pxpy         AS CHAR     NO-UNDO. /* x,y Loc from INI */
DEFINE VARIABLE px             AS INTEGER  NO-UNDO. /* x co-ordinate */
DEFINE VARIABLE py             AS INTEGER  NO-UNDO. /* y co=ordinate */
DEFINE VARIABLE citems-per-row AS CHAR     NO-UNDO. /* i-p-r from INI */
DEFINE VARIABLE items-per-row  AS INTEGER  NO-UNDO.
DEFINE VARIABLE lbl-or-btn     AS CHAR     NO-UNDO. /* setting in INI */
DEFINE VARIABLE ptlabels       AS LOGICAL  NO-UNDO. /* labels ? */
DEFINE VARIABLE rc             AS LOGICAL  NO-UNDO. /* return code */

RUN adeuib/_cr_xftr.p (OUTPUT rc).
IF NOT rc THEN DO:
    MESSAGE "Extended features could not be loaded." VIEW-AS ALERT-BOX
        ERROR BUTTONS OK.
    RETURN.
END.

FOR EACH _XFTR:
    ASSIGN pitems = pitems + CHR(10).
    ASSIGN pitems = pitems + "HANDLE"     + "," +
                             "AddXFTR"    + "," + 
                             _image       + "," + 
                             _name        + "," +
                             STRING(hUIB) + "," +
                             "yes".
END.       
ASSIGN pitems = substring(pitems,2).

RUN adecomm/_palette.w PERSISTENT SET hPalette.
RUN set-items       IN hPalette (INPUT pitems).

/**********
GET-KEY-VALUE SECTION "ProTools" KEY "Visualization" VALUE lbl-or-btn.
IF lbl-or-btn = "labels" THEN ptlabels = yes.
ELSE ptlabels = no.**********/

RUN set-labels      IN hPalette (INPUT yes).
RUN set-menu        IN hPalette (INPUT no).
/*RUN set-parent      IN hPalette (INPUT this-procedure). */
RUN set-title       IN hPalette (INPUT "UIB Extentions").

/****************
GET-KEY-VALUE SECTION "ProTools" KEY "PaletteLoc" VALUE s_pxpy.
ASSIGN px = INT(ENTRY(1,s_pxpy))
       py = INT(ENTRY(2,s_pxpy)).
GET-KEY-VALUE SECTION "ProTools" KEY "ItemsPerRow" VALUE citems-per-row.
ASSIGN items-per-row = INT(citems-per-row). *************/   
assign px = 0
       py = 300.
IF items-per-row = 0 THEN items-per-row = 3.
RUN Realize         IN hPalette (INPUT px, INPUT py, INPUT items-per-row).

RETURN.

/*                               
/* Close this procedure */
ON CLOSE OF THIS-PROCEDURE DO:
    RUN destroy.
END.                                    

IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
    
PROCEDURE destroy:
   /* Delete all widgets created here */
   DELETE WIDGET-POOL.
   /* Free up the Persistem Procedure */
   IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END.

PROCEDURE Customize:
    RUN protools/_custmiz.w (INPUT hPalette, INPUT-OUTPUT ptdat).
END.

PROCEDURE About:
    RUN adecomm/_about.p (INPUT "PRO*Tools", INPUT "protools/protools").
END.
*/
