/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* updtabledef.i -- define RowObjUpd temp-table for an SBO */
 
 /* The default is to define the TT with no-undo, but tables can be defined 
    without no-undo by defining &SCOP update-tables-undo . */
 &IF DEFINED(update-tables-undo) <> 0 &THEN
    &SCOP update-tables-no-undo  
 &ELSE 
    &SCOP update-tables-no-undo NO-UNDO 
 &ENDIF
 
 
 &IF '{&SDOInclude{1}}':U NE "":U &THEN
  DEFINE TEMP-TABLE {&UpdTable{1}} {&update-tables-no-undo} {{&SDOInclude{1}}} {src/adm2/rupdflds.i}.
  ghUpdTables[{1}] = TEMP-TABLE {&UpdTable{1}}:HANDLE.
 &ENDIF
