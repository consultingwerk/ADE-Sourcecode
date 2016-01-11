    DEFINE INPUT  PARAMETER icDelim     AS CHARACTER  NO-UNDO.
    DEFINE OUTPUT PARAMETER ocOutString AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cLipString          AS CHARACTER                    NO-UNDO.
    DEFINE BUFFER gsc_object_type           FOR gsc_object_type.
    FOR EACH gsc_object_type WHERE
             gsc_object_type.object_type_code = "DynObjc":U OR
             gsc_object_type.object_type_code = "DynFold":U OR
             gsc_object_type.object_type_code = "DynWind":U OR
             gsc_object_type.object_type_code = "DynMenc":U
             NO-LOCK:
             
        ASSIGN cLipString = cLipString + (IF NUM-ENTRIES(cLipString, icDelim) EQ 0 THEN "":U ELSE icDelim) 
                          + (gsc_object_type.object_type_code + " // ":U + gsc_object_type.object_type_description + icDelim + gsc_object_type.object_type_code).
    END.    /* object type */
    ocOutString = cLipString.
