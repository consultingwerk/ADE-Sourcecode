DEFINE INPUT PARAM pcfilename  AS CHAR NO-UNDO.

{adeuib/sharvars.i}
DEFINE VARIABLE level          AS INTEGER NO-UNDO INITIAL 1. 
DEFINE VARIABLE uib_is_running AS LOGICAL NO-UNDO INITIAL NO.

REPEAT WHILE PROGRAM-NAME(level) <> ?.
    IF PROGRAM-NAME(level) = "adeuib/_uibmain.p" THEN uib_is_running = TRUE.
    ASSIGN level = level + 1.
END. /*repeat*/

IF NOT uib_is_running THEN DO:
    MESSAGE "The UIB is not running. You must start the UIB before running the SmartObject Upgrade Utility." VIEW-AS ALERT-BOX ERROR.
    RETURN.
END. /*not uib_is_running*/

ELSE DO:
    RUN adeuib/_open-w.p (pcFileName, "", "OPEN").
    RUN choose_file_save in _h_uib.
    RUN choose_close in _h_uib.
END. /*else do*/
       
