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
/*--------------------------------------------------------------------------
    File        : assigntablehdl.i
    Purpose     : Assign a variable from the SDOs getRowObjectTable.
    Param         handlename - Variable name excluding number 
                              ---
                               def var hRowObject1 
                               def var hRowObject2
                               &scop handlename hRowObject  
                              ---
                  SDOHandles - List of SDO handles
                  StartNum   - The number in this list to start with 
                             
    Syntax      : &scop handleName hRowObject 
                  &scop SDOHandles cList
                  &scop startNum   iSDONum
                  ASSIGN
                  {assigntablehdl.i 1}
                  {assigntablehdl.i 2}
                  {assigntablehdl.i 3} 
                  .                  
    Modified    : January 20, 2001 -- Version 9.1B+
---------------------------------------------------------------------*/                  
{&HandleName}{1} = (IF NUM-ENTRIES({&SDOHandles}) >= {1} AND {&StartNum} <= {1}  
                    THEN {fn getRowObjectTable WIDGET-HANDLE(ENTRY({1},{&SDOHandles}))}
                    ELSE ?).
     

