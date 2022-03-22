/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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
