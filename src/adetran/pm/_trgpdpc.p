/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
TRIGGER PROCEDURE FOR DELETE OF xlatedb.XL_Procedure.  
  DEFINE VARIABLE Dir         AS CHARACTER        NO-UNDO.
  DEFINE VARIABLE File_Name   AS CHARACTER        NO-UNDO.
    
  FIND FIRST xlatedb.XL_Project EXCLUSIVE-LOCK NO-ERROR.
  IF AVAIL xlatedb.XL_Project THEN
     xlatedb.XL_Project.NumberOfProcedures = xlatedb.XL_Project.NumberOfProcedures - 1. 
       
  ASSIGN Dir = TRIM(xlatedb.XL_Procedure.directory , ".":u).
  RUN adecomm/_osfmush.p
    (INPUT  Dir,
     INPUT  TRIM(xlatedb.xl_Procedure.FileName),
     OUTPUT File_Name).
     
  FOR EACH xlatedb.XL_Instance WHERE xlatedb.XL_Instance.Proc_Name = File_Name 
    EXCLUSIVE-LOCK:
    DELETE xlatedb.XL_Instance.
  END.                        

  /* Note that xlatedb.XL_Invalid contains the current sub-set list 
   * XL_Invalid.GlossaryName = directory
   * XL_Invalid.TargetPhrase = filename
   * This is NOT the case in the kit!
   */
  FOR EACH xlatedb.XL_Invalid WHERE
          xlatedb.XL_Invalid.GlossaryName = xlatedb.XL_Procedure.Directory 
      AND xlatedb.XL_Invalid.TargetPhrase = xlatedb.XL_Procedure.FileName
      EXCLUSIVE-LOCK:
    DELETE xlatedb.XL_Invalid.
  END.
    
/* EOF */
