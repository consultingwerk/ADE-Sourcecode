/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* 1=normal 2=minimized for second parameter */
RUN ProExec ("PRORB32.EXE", INPUT 1, INPUT 1, INPUT 3).

PROCEDURE ProExec EXTERNAL "proexec.dll" cdecl: 
    DEFINE INPUT PARAMETER prog_name AS CHARACTER. 
    DEFINE INPUT PARAMETER prog_style AS LONG.
    DEFINE INPUT PARAMETER wait_for_me as LONG.
    DEFINE INPUT PARAMETER num_seconds as SHORT.
END.
