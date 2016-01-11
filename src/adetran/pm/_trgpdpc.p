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
