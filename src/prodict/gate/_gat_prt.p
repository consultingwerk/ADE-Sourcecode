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

/*--------------------------------------------------------------------

File: prodict/gate/_gat_prt.p

Description:
    
    creating the report to be printed

        
Input:
    p_param     code of what to output: {a | l | r + recid(gate-work)}

Output:
    none
    
Called from:
    gui/guiget.i (via misc/_prt_rpt.p)

History:
    hutegger    95/03   creation
    
--------------------------------------------------------------------*/        
/*h-*/

&SCOPED-DEFINE DATASERVER                 YES
{ prodict/dictvar.i }
&UNDEFINE DATASERVER

define input parameter     p_param      as character.

/*
define            variable l_line       as character.
define            variable l_tmp-file   as character.
*/
define            variable l_txt        as character.

define     shared stream   rpt.
define            stream   l_stm_tmp.


/*---------------------  Internal Procedures  ----------------------*/

/*---------------------------  TRIGGERS  ---------------------------*/

/*------------------------------------------------------------------*/
/*---------------------------  MAIN-CODE  --------------------------*/
/*------------------------------------------------------------------*/

/* paged-output ignores chr(10) embedded in the text, so we output line
 * by line, and not the whole text at once
 */

for each gate-work
  where gate-work.gate-slct = TRUE:
  
  if p_param = "s" and gate-work.gate-flag = FALSE then next.
  if p_param = "d" and gate-work.gate-flg2 = FALSE then next.
  
  assign
    l_txt = gate-work.gate-edit.
  repeat while index(l_txt,chr(10)) > 0:
    if index(l_txt,chr(10)) > 1
     then put stream rpt unformatted
      substring(l_txt,1,index(l_txt,chr(10)) - 1, "character") skip.
     else put stream rpt skip(1).
    assign
      l_txt = substring(l_txt,index(l_txt,chr(10)) + 1,-1,"character").
    end.   /* repeat */
  put stream rpt unformatted
    l_txt        skip(1)
    fill("-",77) skip(1).  
  
  end.  /* for each gate-work */
  
/*------------------------------------------------------------------*/
