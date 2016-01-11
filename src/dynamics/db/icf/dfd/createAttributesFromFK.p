DEFINE BUFFER rycso      FOR ryc_smartObject.

/* Disable all triggers */
DISABLE TRIGGERS FOR DUMP OF ryc_attribute.                 DISABLE TRIGGERS FOR LOAD OF ryc_attribute.
DISABLE TRIGGERS FOR DUMP OF ryc_attribute_value.           DISABLE TRIGGERS FOR LOAD OF ryc_attribute_value.

/* Make sure that there are no cases where the attribute value data
   has bad index values.
 */
PUBLISH "DCU_WriteLog":U ("Cleaning up attribute values with bad index data ..."). 
for each ryc_attribute_value where
         ryc_attribute_value.object_type_obj     = 0 and
         ryc_attribute_value.smartobject_obj     = 0 and
         ryc_attribute_value.object_instance_obj = 0
         exclusive-lock:
    delete ryc_attribute_value no-error.
    if error-status:error then
    do:
        PUBLISH "DCU_WriteLog":U ("Unable to delete attribute value record with label " 
                                 + ryc_attribute_value.attribute_label + "~n":U
                                 + " Error: " + error-status:get-message(1)
                                 + " ReturnValue: " + return-value        ).
        undo, next.
    end.    /* error on delete */
    else
        PUBLISH "DCU_WriteLog":U ("Deleted attribute value record with label " + ryc_attribute_value.attribute_label).
end.    /* clear out crummy data */
PUBLISH "DCU_WriteLog":U ("Clean up attribute values with bad index data complete.").
 
IF NOT CAN-FIND(FIRST ryc_attribute WHERE ryc_attribute.attribute_label = "RenderingProcedure":U) THEN
DO:
    PUBLISH "DCU_WriteLog":U ("Creating RenderingProcedure attribute ...").

    /* These values are deliberately hard-coded to match the values of 
     * the original ADO submission.                                    */
    CREATE ryc_attribute.
    ASSIGN ryc_attribute.attribute_label     = "RenderingProcedure":U
           ryc_attribute.attribute_group_obj = 3000002003.09    /* ADMAttributes */
           ryc_attribute.data_type           = 1    /* Character */
           ryc_attribute.attribute_narrative = "This procedure specifies the name of the procedure that will be used to render an object. The value of this attribute will match that of the object name in the Repository, and will be resolved into a pathed filename capable of being run."
           ryc_attribute.system_owned        = YES
           ryc_attribute.attribute_obj       = 18564.48.
    PUBLISH "DCU_WriteLog":U ("Creation of RenderingProcedure attribute complete.").
END.    /* create RenderingProcedure attribute */

IF NOT CAN-FIND(FIRST ryc_attribute WHERE ryc_attribute.attribute_label = "SuperProcedure":U) THEN
DO:
    PUBLISH "DCU_WriteLog":U ("Creating SuperProcedure attribute ...").

    /* These values are deliberately hard-coded to match the values of 
     * the original ADO submission.                                    */
    CREATE ryc_attribute.
    ASSIGN ryc_attribute.attribute_label     = "SuperProcedure":U
           ryc_attribute.attribute_group_obj = 5.706300000    /*  */
           ryc_attribute.data_type           = 1    /* Character */
           ryc_attribute.attribute_narrative = "The class super procedure."
           ryc_attribute.system_owned        = YES
           ryc_attribute.constant_level      = "MASTER"
           ryc_attribute.attribute_obj       = 13156.706300000.
    PUBLISH "DCU_WriteLog":U ("Creation of SuperProcedure attribute complete.").
END.    /* create RenderingProcedure attribute */

PUBLISH "DCU_WriteLog":U ("Starting generation of RenderingProcedure and SuperProcedure attributes ...").

FOR EACH ryc_smartObject NO-LOCK,
    FIRST gsc_object_type WHERE 
        gsc_object_type.OBJECT_type_obj = ryc_smartObject.object_type_obj NO-LOCK:

    /* Create RenderingProcedure attribute  */
    IF ryc_smartObject.physical_smartobject_obj > 0 THEN
    DO:
        FIND FIRST rycso WHERE
                   rycso.smartobject_obj = ryc_smartObject.physical_smartobject_obj
                   NO-LOCK  NO-ERROR.
        IF AVAILABLE rycso THEN
        DO:
            FIND FIRST ryc_attribute_value WHERE
                       ryc_attribute_value.object_Type_obj     = ryc_smartObject.object_Type_obj AND
                       ryc_attribute_value.smartobject_obj     = ryc_smartObject.smartobject_obj AND
                       ryc_attribute_value.object_instance_obj = 0                     AND
                       ryc_attribute_value.attribute_label     = "RenderingProcedure":U
                       EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE ryc_attribute_value THEN
            DO:
                CREATE ryc_attribute_value.
                ASSIGN ryc_attribute_value.attribute_value_obj     = DYNAMIC-FUNCTION("getNextObj":U IN TARGET-PROCEDURE)
                       ryc_attribute_value.object_type_obj         = ryc_smartObject.object_Type_obj
                       ryc_attribute_value.smartobject_obj         = ryc_smartObject.smartobject_obj
                       ryc_attribute_value.object_instance_obj     = 0                           
                       ryc_attribute_value.attribute_label         = "RenderingProcedure":U
                       ryc_attribute_value.primary_smartobject_obj = ryc_smartObject.smartobject_obj
                       NO-ERROR.
            END.

            ASSIGN ryc_attribute_value.character_value = rycso.object_filename NO-ERROR.
            IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN 
            DO:
                PUBLISH "DCU_WriteLog":U ("Update of RenderingProcedure attribute failed for: " 
                                           + " Class: " + gsc_object_type.object_type_code
                                           + "  Master: " + ryc_smartobject.object_filename                                           
                                           + " **RETURN-VALUE: " + RETURN-VALUE     ).
                UNDO, NEXT.
            END.                

            /* Does the class have the correct RenderingProcedure? */
            IF NOT CAN-FIND(FIRST ryc_attribute_value WHERE
                                  ryc_attribute_value.object_Type_obj     = ryc_smartObject.object_Type_obj AND
                                  ryc_attribute_value.smartobject_obj     = 0                               AND
                                  ryc_attribute_value.object_instance_obj = 0                               AND
                                  ryc_attribute_value.attribute_label     = "RenderingProcedure":U              ) THEN
            DO:
                CREATE ryc_attribute_value.
                ASSIGN ryc_attribute_value.attribute_value_obj     = DYNAMIC-FUNCTION("getNextObj":U IN TARGET-PROCEDURE)
                       ryc_attribute_value.object_Type_obj         = ryc_smartObject.object_Type_obj
                       ryc_attribute_value.smartobject_obj         = 0
                       ryc_attribute_value.object_instance_obj     = 0                           
                       ryc_attribute_value.attribute_label         = "RenderingProcedure":U
                       ryc_attribute_value.character_value         = rycso.object_filename
                       ryc_attribute_value.primary_smartobject_obj = ryc_smartObject.smartobject_obj
                       NO-ERROR.
            END.    /* attribute value for class. */
        END.    /* renderer */
    END.    /* has physical object */

    /* Create SuperProcedure attribute  */
    IF ryc_smartObject.custom_smartobject_obj > 0 THEN
    DO:
        FIND FIRST rycso WHERE
                   rycso.smartobject_obj = ryc_smartObject.custom_smartobject_obj
                   NO-LOCK NO-ERROR.
        IF AVAILABLE rycso THEN 
        DO:
            FIND FIRST ryc_attribute_value WHERE
                       ryc_attribute_value.object_Type_obj     = ryc_smartObject.object_Type_obj AND
                       ryc_attribute_value.smartobject_obj     = ryc_smartObject.smartobject_obj AND
                       ryc_attribute_value.object_instance_obj = 0                     AND
                       ryc_attribute_value.attribute_label     = "SuperProcedure":U
                       EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE ryc_attribute_value THEN
            DO:
                CREATE ryc_attribute_value.
                ASSIGN ryc_attribute_value.attribute_value_obj     = DYNAMIC-FUNCTION("getNextObj":U IN TARGET-PROCEDURE)
                       ryc_attribute_value.object_type_obj         = ryc_smartObject.object_Type_obj
                       ryc_attribute_value.smartobject_obj         = ryc_smartObject.smartobject_obj
                       ryc_attribute_value.primary_smartobject_obj = ryc_smartObject.smartobject_obj
                       ryc_attribute_value.object_instance_obj     = 0                           
                       ryc_attribute_value.attribute_label         = "SuperProcedure":U
                       NO-ERROR.
            END.    /* create attribute value */

            ASSIGN ryc_attribute_value.CHARACTER_value = rycso.object_filename NO-ERROR.
            IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN 
            DO:
                PUBLISH "DCU_WriteLog":U ("Update of SuperProcedure attribute failed for: " 
                                           + " Class: " + gsc_object_type.object_type_code
                                           + "  Master: " + ryc_smartobject.object_filename                                           
                                           + " **RETURN-VALUE: " + RETURN-VALUE     ).
                UNDO, NEXT.
            END.                

        END.    /* super procedure */
    END.    /* has physical object */
END.    /* has a physical object. */

RUN cleanUpAttribute.

RETURN.
/* - EOF - */

PROCEDURE cleanUpAttribute:
/*-----------------------------------------------------------------------*/
/* Purpose: Remove cascaded attributes.                                  */
/*  Notes:                                                               */
/*-----------------------------------------------------------------------*/
  DEFINE VARIABLE lDelete                 AS LOGICAL      NO-UNDO.

  DEFINE BUFFER b1_ryc_attribute_value    FOR ryc_attribute_value.
  DEFINE BUFFER b2_ryc_attribute_value    FOR ryc_attribute_value.
  
  PUBLISH "DCU_WriteLog":U ("Cleaning up RenderingProcedure attribute values...").
 
  /* Loop through all object types */
  FOR EACH gsc_object_type NO-LOCK:

    /* Loop through all masters for the object type */
    FOR EACH ryc_smartobject NO-LOCK
      WHERE ryc_smartobject.object_type_obj = gsc_object_type.object_type_obj:
      
      /* Loop through all the instances of the master */
      FOR EACH ryc_object_instance NO-LOCK
        WHERE ryc_object_instance.smartobject_obj = ryc_smartobject.smartobject_obj:

        /* Loop through all attributes of the instance. */
        FOR EACH ryc_attribute_value EXCLUSIVE-LOCK
          WHERE ryc_attribute_value.object_type_obj           = ryc_smartobject.object_type_obj
          AND   ryc_attribute_value.smartobject_obj           = ryc_smartobject.smartobject_obj
          AND   ryc_attribute_value.object_instance_obj       = ryc_object_instance.object_instance_obj
          AND   ryc_attribute_value.container_smartobject_obj = ryc_object_instance.container_smartobject_obj

            AND ryc_attribute_value.attribute_label = "RenderingProcedure":U

          ,FIRST ryc_attribute NO-LOCK
            WHERE ryc_attribute.attribute_label = ryc_attribute_value.attribute_label:

          ASSIGN
            lDelete = NO.

          /* Find the corresponding attribute value for the master */ 
          FIND FIRST b1_ryc_attribute_value NO-LOCK
            WHERE b1_ryc_attribute_value.object_type_obj           = ryc_smartobject.object_type_obj
            AND   b1_ryc_attribute_value.smartobject_obj           = ryc_smartobject.smartobject_obj
            AND   b1_ryc_attribute_value.object_instance_obj       = 0
            AND   b1_ryc_attribute_value.container_smartobject_obj = 0
            AND   b1_ryc_attribute_value.attribute_label           = ryc_attribute_value.attribute_label 
            NO-ERROR.
            
          /* If we have found an attribute value for the instance, delete the instance attribute
             if it has the same value as the master. */
          IF AVAILABLE b1_ryc_attribute_value THEN 
          DO:
            /* Values are the same */
            ASSIGN
              lDelete = (ryc_attribute_value.character_value = b1_ryc_attribute_value.character_value).
            IF lDelete THEN 
            DO:
              DELETE ryc_attribute_value NO-ERROR.
              IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN 
                DO:
                PUBLISH "DCU_WriteLog":U 
                  ("  Delete failed for Class: " + gsc_object_type.object_type_code
                   + "  Master: " + ryc_smartobject.object_filename
                   + "  Instance: " + ryc_object_instance.instance_name
                   + "  Attribute: " + ryc_attribute.attribute_label
                   + " **RETURN-VALUE: " + RETURN-VALUE
                  ).
                  UNDO, NEXT.
              END.    /* error */
            END.    /* delete attribute value. */
          END.    /* avail b1_ryc_attribute_value (master of instance) */
        END.    /* each attribute value for instance  */
      END.    /* each object instance. */

      /* Loop through the master attributes. */
      FOR EACH ryc_attribute_value EXCLUSIVE-LOCK
        WHERE ryc_attribute_value.object_type_obj           = ryc_smartobject.object_type_obj
        AND   ryc_attribute_value.smartobject_obj           = ryc_smartobject.smartobject_obj
        AND   ryc_attribute_value.object_instance_obj       = 0
        AND   ryc_attribute_value.container_smartobject_obj = 0

          AND ryc_attribute_value.attribute_label = "RenderingProcedure":U

        ,FIRST ryc_attribute NO-LOCK
          WHERE ryc_attribute.attribute_label = ryc_attribute_value.attribute_label
        :

        ASSIGN
          lDelete = NO.
          
        /* Find the corresponding attribute on the object type. */  
        FIND FIRST b1_ryc_attribute_value NO-LOCK
          WHERE b1_ryc_attribute_value.object_type_obj           = ryc_smartobject.object_type_obj
          AND   b1_ryc_attribute_value.smartobject_obj           = 0
          AND   b1_ryc_attribute_value.object_instance_obj       = 0
          AND   b1_ryc_attribute_value.container_smartobject_obj = 0
          AND   b1_ryc_attribute_value.attribute_label           = ryc_attribute_value.attribute_label
          NO-ERROR.
          
        /* If we find the attribute on the object type and the values are the same, delete it */
        IF AVAILABLE b1_ryc_attribute_value THEN         
          /* Values are the same */
          ASSIGN
            lDelete = (ryc_attribute_value.character_value = b1_ryc_attribute_value.character_value).
        
        IF lDelete THEN 
        DO:

          DELETE ryc_attribute_value NO-ERROR.
          IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN
          DO:
            PUBLISH "DCU_WriteLog":U 
              ("  Delete failed for Class: " + gsc_object_type.object_type_code
               + "  Master: " + ryc_smartobject.object_filename
               + "  Attribute: " + ryc_attribute.attribute_label
               + " **RETURN-VALUE: " + RETURN-VALUE
              ).
            UNDO, NEXT.
          END.  /* error */
        END.    /* delete attribute value. */
      END.    /* each attribute value  for master object */
    END.    /* each master smartobject */
  END.    /* object type. */

  RETURN.
END PROCEDURE.  /* cleanUpAttribute. */

FUNCTION getNextObj RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  To return the next available unique object number.
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE dSeqNext    AS DECIMAL  NO-UNDO.

  DEFINE VARIABLE iSeqObj1    AS INTEGER  NO-UNDO.
  DEFINE VARIABLE iSeqObj2    AS INTEGER  NO-UNDO.

  DEFINE VARIABLE iSeqSiteDiv AS INTEGER  NO-UNDO.
  DEFINE VARIABLE iSeqSiteRev AS INTEGER  NO-UNDO.

  DEFINE VARIABLE iSessnId    AS INTEGER  NO-UNDO.

  ASSIGN
    iSeqObj1    = NEXT-VALUE(seq_obj1,ICFDB)
    iSeqObj2    = CURRENT-VALUE(seq_obj2,ICFDB)
    iSeqSiteDiv = CURRENT-VALUE(seq_site_division,ICFDB)
    iSeqSiteRev = CURRENT-VALUE(seq_site_reverse,ICFDB)
    iSessnId    = CURRENT-VALUE(seq_session_id,ICFDB)
    .

  IF iSeqObj1 = 0 THEN
    ASSIGN
      iSeqObj2 = NEXT-VALUE(seq_obj2,ICFDB).

  ASSIGN
    dSeqNext = DECIMAL((iSeqObj2 * 1000000000.0) + iSeqObj1)
    .

  IF  iSeqSiteDiv <> 0
  AND iSeqSiteRev <> 0 THEN
    ASSIGN
      dSeqNext = dSeqNext + (iSeqSiteRev / iSeqSiteDiv).

  RETURN dSeqNext. /* Function return value */
END FUNCTION.   /* getNextObj */
