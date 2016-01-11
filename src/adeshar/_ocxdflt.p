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

File: _ocxdflt.p

Description:
    Generate the default code for OCX events as well as PROGESS triggers.
    This function is expected to be only called for OCX controls.
    
        
Input Parameters:
    p_event    - The event.
    p_template - the type of code to generate (see list above).
    p_recid    - the RECID(_U) for the window (or dialog-box) [or widget]
 
Output Parameters:
    p_code     - the text created for this widget.

Author: David Lee 
  ----------------------------------------------------------------------------*/

DEFINE INPUT  PARAMETER p_event    AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER p_template AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER p_recid    AS RECID     NO-UNDO.
DEFINE OUTPUT PARAMETER p_code     AS CHARACTER NO-UNDO initial "".

{adeuib/uniwidg.i}           /* Definition of Universal Widget TEMP-TABLE    */
{adeuib/layout.i}
{adeuib/sharvars.i}  
/* Standard End-of-line character - adjusted in 7.3A to be just chr(10) */
&Scoped-define EOL CHR(10)

define variable tempCode  as character no-undo initial "".
define variable pList     as character no-undo.
define variable s         as integer   no-undo.
define variable i         as integer   no-undo.
define variable paramItem as character no-undo.
define variable varMode   as character no-undo.
define variable varName   as character no-undo.
define variable varType   as character no-undo.
define variable AlignName as integer   no-undo.
define variable AlignMode as integer   no-undo.


set p_code = "".

if p_recid <> ? then
  find _U where recid(_U) = p_recid.

if num-entries(p_event, ".") > 1 then
do:
    /*
     * Since an OCX event is a procedure and not a trigger, make
     * it look like a procedure.
     */
    
    run adeshar/_coddflt.p ("_OCX-EVENTPROC-TOP", p_recid, output tempCode).
    set p_code = tempCode.

    run adeuib/_ocxevnt.p
        ( INPUT _U._handle, INPUT entry(2, p_event, "."), OUTPUT pList ). 

    if ( pList = "" ) then
        assign p_code = p_code + "None required for OCX." + chr(10) .
    else
    do:
      p_code = p_code + "Required for OCX." + chr(10).
      do i = 1 to num-entries(pList, ","):
        assign paramItem   = entry(i, pList).
        assign varMode = entry(1, paramItem, " ")
               varName = entry(2, paramItem, " ").
        assign p_code  = p_code + "    " + varName + CHR(10) .
        /* We'll use mode & name to align the define parameter statements. */
        assign AlignMode = maximum(AlignMode, length(varMode, "character"))
               AlignName = maximum(AlignName, length(varName, "character")).
      end.
    end.

    run adeshar/_coddflt.p ("_OCX-EVENTPROC-MID", p_recid, output tempCode).
    set p_code = p_code + tempCode.
	        
    do i = 1 to num-entries(pList):
        /* Extract the parameter mode, name and type. We also use the previously
           calculated maximum name length to align the "AS" phrases in the
           define parameter statements. */
        assign paramItem   = entry(i, pList).
        assign varMode = entry(1, paramItem, " ")
               varMode = varMode + FILL(" " , AlignMode - length(varMode, "character"))
               varName = entry(2, paramItem, " ")
               varName = "p-" + varName + FILL(" " , AlignName - length(varName, "character"))
               varType = entry(3, paramItem, " ").
        assign
            p_code = p_code
                   + CAPS("DEFINE " + varMode + " PARAMETER ")
                   + varName
                   + CAPS(" AS " + varType + " NO-UNDO.") + chr(10).
    end.
    run adeshar/_coddflt.p("_OCX-EVENTPROC-END", p_recid, output tempCode).
    set p_code = p_code + tempCode.
end.
else
    run adeshar/_coddflt.p(p_template, p_recid, output p_code).
