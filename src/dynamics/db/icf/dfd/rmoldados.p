/* rmoldados.p 
   Fix program to whack ADOs that are no longer needed */
   
DEFINE VARIABLE cFiles AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iCount AS INTEGER    NO-UNDO.
DEFINE VARIABLE cFile  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cPath  AS CHARACTER  NO-UNDO.

ASSIGN
  cFiles = "ry/uib/rvmwsfoldw.ado,ry/obj/dyncombo.ado":U
  cPath  = DYNAMIC-FUNCTION("getSessionParam":U IN THIS-PROCEDURE,
                            "path_install":U).

DO iCount = 1 TO NUM-ENTRIES(cFiles):
  cFile = SEARCH(cPath + "/src/":U + ENTRY(iCount,cFiles)).
  IF cFile <> ? THEN
    OS-DELETE VALUE(cFile).

  cFile = SEARCH(cPath + "/gui/":U + ENTRY(iCount,cFiles)).
  IF cFile <> ? THEN
    OS-DELETE VALUE(cFile).
  
  cFile = SEARCH(cPath + "/tty/":U + ENTRY(iCount,cFiles)).
  IF cFile <> ? THEN
    OS-DELETE VALUE(cFile).
END.
