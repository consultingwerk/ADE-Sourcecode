/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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


