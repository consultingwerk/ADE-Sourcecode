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
TRIGGER PROCEDURE FOR DELETE OF xlatedb.XL_Instance.
    find first xlatedb.XL_Project exclusive-lock no-error.
    if avail xlatedb.XL_Project then
       xlatedb.XL_Project.NumberOfPhrases = 
         xlatedb.XL_Project.NumberOfPhrases - 1.
         
         
    define buffer bufInst for xlatedb.XL_instance.
    
    FOR EACH xlatedb.XL_Translation 
	WHERE xlatedb.XL_Translation.Sequence_num = 
            xlatedb.XL_Instance.Sequence_num
        AND xlatedb.XL_Translation.Instance_Num = 
	      xlatedb.XL_Instance.Instance_Num EXCLUSIVE-LOCK:
       DELETE xlatedb.XL_Translation.
    END.

    if not can-find(first bufInst where
                (bufInst.sequence_num = xlatedb.XL_instance.sequence_num) and
                (bufInst.Instance_num <> xlatedb.XL_Instance.Instance_Num)) then
    do: 
       find xlatedb.xl_string_info where xlatedb.xl_string_info.sequence_num  = 
                    xlatedb.xl_Instance.sequence_num exclusive-lock no-error.
       if avail xlatedb.xl_string_info then
          delete xlatedb.xl_string_info.               
    end.       


