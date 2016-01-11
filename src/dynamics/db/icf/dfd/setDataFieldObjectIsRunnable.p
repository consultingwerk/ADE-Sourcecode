/** Sets the OBJECT_IS_RUNNABLE flag on all DataField objects to NO.
 *  ----------------------------------------------------------------------- **/

FUNCTION getClassChildren RETURNS CHARACTER
    (INPUT pcClasses AS CHARACTER) :

    DEFINE VARIABLE cClassList        AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cCurrentClassList AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cCurrentClass     AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE dObjectTypeObj    AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE iCounter          AS INTEGER    NO-UNDO.

    /* Localize the gsc_object_type buffer to this function. This is particularly important seeing that the function is called recursively */
    DEFINE BUFFER gsc_object_type FOR gsc_object_type.
  
        /* Ensure the value is empty */
        cClassList = "":U.

        /* Make sure we read through all entries of requested classes */
        DO iCounter = 1 TO NUM-ENTRIES(pcClasses):
          /* Ensure the variables are cleared */
          ASSIGN
              cCurrentClassList = "":U
              cCurrentClass     = ENTRY(iCounter, pcClasses).

          /* See if the given class exists */
          FIND FIRST gsc_object_type NO-LOCK
               WHERE gsc_object_type.object_type_code = cCurrentClass NO-ERROR.

          /* See if the specified class exists */
          IF AVAILABLE gsc_object_type THEN
          DO:
            ASSIGN
                cCurrentClassList = gsc_object_type.object_type_code
                dObjectTypeObj    = gsc_object_type.object_type_obj.

            /* Step through all the children of the current class */
            FOR EACH gsc_object_type NO-LOCK
               WHERE gsc_object_type.extends_object_type_obj = dObjectTypeObj
                  BY gsc_object_type.object_type_code:

              /* For every child, see if there are any children underneath it, by recursively calling this function */
              cCurrentClassList = cCurrentClassList + ",":U
                                + DYNAMIC-FUNCTION("getClassChildren":U IN TARGET-PROCEDURE, gsc_object_type.object_type_code).
            END.
          END.
          ELSE
            cCurrentClassList = CHR(1). /* Assign a temporary placeholder if the specified class does not exist */

          /* Append the CurrentClassList to the global ClassList. The placeholder above was inserted so the correct number of entries are added to the output value */
          cClassList = cClassList
                     + (IF cClassList = "":U THEN "":U ELSE CHR(3))
                     + cCurrentClassList.
        END.

        /* If any temporay placeholders exist, ensure they are removed from the output value */
        IF INDEX(cClassList, CHR(1)) <> 0 THEN
          cClassList = REPLACE(cClassList, CHR(1), "":U).

    RETURN cClassList.
END FUNCTION. /* getClassChildren. */

/* -- Main Code Block -- */
DISABLE TRIGGERS FOR DUMP OF ryc_smartObject.                 DISABLE TRIGGERS FOR LOAD OF ryc_smartObject.

DEFINE VARIABLE iClassLoop                  AS INTEGER                  NO-UNDO.
DEFINE VARIABLE cDataFieldClasses           AS CHARACTER                NO-UNDO.

PUBLISH "DCU_WriteLog":U ("Starting update of Object_Is_Runnable flag for all DataField objects ...").

ASSIGN cDataFieldClasses = DYNAMIC-FUNCTION("getClassChildren":U IN TARGET-PROCEDURE, INPUT "DataField":U).

DO iClassLoop = 1 TO NUM-ENTRIES(cDataFieldClasses):
    FIND FIRST gsc_object_type WHERE
               gsc_object_type.object_type_code = ENTRY(iClassLoop, cDataFieldClasses)
               NO-LOCK NO-ERROR.
    IF AVAILABLE gsc_object_type THEN
    DO:
        FOR EACH ryc_smartObject WHERE
                 ryc_smartObject.object_type_obj = gsc_object_type.object_type_obj
                 EXCLUSIVE-LOCK:
            ASSIGN ryc_smartObject.object_is_runnable = NO NO-ERROR.

            VALIDATE ryc_smartObject NO-ERROR.
            IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN
            DO:
                PUBLISH "DCU_WriteLog":U ("Update of Object_Is_Runnable flag failed for object: " 
                                          + ryc_smartObject.object_filename + " **RETURN-VALUE: " + RETURN-VALUE ).
                UNDO, NEXT.
            END.    /* there was an error. */
        END.    /* all rycso object .*/
    END.    /* avialable class */
END.    /* class loop */

PUBLISH "DCU_WriteLog":U ("Completed update of Object_Is_Runnable flag for all DataField objects.").

ASSIGN ERROR-STATUS:ERROR = NO.
RETURN.
/* EOF */
