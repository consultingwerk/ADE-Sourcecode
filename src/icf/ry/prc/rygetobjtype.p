{src/adm2/globals.i}

DEFINE INPUT  PARAMETER icDelim     AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER ocOutString AS CHARACTER  NO-UNDO.

DEFINE VARIABLE cLipString AS CHARACTER NO-UNDO.

DEFINE BUFFER gsc_object_type FOR gsc_object_type.

DEFINE VARIABLE cClassList AS CHARACTER  NO-UNDO.
ASSIGN cClassList = DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, INPUT "DynObjc,DynFold,DynWind,DynMenc":U)
       cClassList = REPLACE(cClassList, CHR(3), ",":U).

FOR EACH gsc_object_type NO-LOCK
   WHERE LOOKUP(gsc_object_type.object_type_code, cClassList) <> 0:

    ASSIGN cLipString = cLipString + (IF NUM-ENTRIES(cLipString, icDelim) EQ 0 THEN "":U ELSE icDelim) 
                      + (gsc_object_type.object_type_code + " // ":U + gsc_object_type.object_type_description + icDelim + gsc_object_type.object_type_code).
END.    /* object type */
ocOutString = cLipString.


