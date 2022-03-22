/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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
     

