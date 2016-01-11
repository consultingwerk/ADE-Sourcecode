/** Ths utility will ensure that the instance_name field is correct in that it matches the value of the
    attribute that contains the name of the instance.
   
   ------------------------------------------------------------------------------------------------------ **/
DEFINE VARIABLE lError        AS LOGICAL             NO-UNDO.
DEFINE BUFFER rycso    FOR ryc_smartobject.

FUNCTION getNextObj RETURNS DECIMAL forward.

PUBLISH "DCU_WriteLog":U ("Starting creation of missing `Page` links.").

FIND FIRST gsc_object_type WHERE 
           gsc_object_type.object_type_code = "SmartFolder":u
           NO-LOCK.

FOR EACH ryc_smartObject WHERE
         ryc_smartObject.object_type_obj = gsc_object_type.object_type_obj
         NO-LOCK:
    FOR EACH ryc_object_instance WHERE
             ryc_object_instance.smartobject_obj = ryc_smartObject.smartobject_obj
             NO-LOCK:
                 
        ASSIGN lError = NO.
        FIND FIRST ryc_smartlink WHERE
                   ryc_smartlink.source_object_instance_obj = ryc_object_instance.object_instance_obj AND
                   ryc_smartlink.link_name                  = "Page":U      AND
                   ryc_smartlink.target_object_instance_obj = 0
                   NO-LOCK NO-ERROR.
        IF NOT AVAILABLE ryc_smartlink THEN
        DO:
            FIND FIRST ryc_smartlink_type WHERE
                       ryc_smartlink_type.link_name = "Page":U
                       NO-LOCK NO-ERROR.
                            
            CREATE ryc_smartlink.
            ASSIGN ryc_smartlink.smartlink_obj              = getNextObj() NO-ERROR.
            
            ASSIGN ryc_smartlink.container_smartobject_obj  = ryc_object_instance.container_smartobject_obj
                   ryc_smartlink.smartlink_type_obj         = ryc_smartlink_type.smartlink_type_obj
                   ryc_smartlink.link_name                  = ryc_smartlink_type.link_name
                   ryc_smartlink.source_object_instance_obj = ryc_object_instance.object_instance_obj
                   ryc_smartlink.target_object_instance_obj = 0    /* indicate container. */
                   NO-ERROR.
		    if error-status:error then
		    do:
		        assign lError = yes.
		        PUBLISH "DCU_WriteLog":U ("Unable to create new link record attribute value.").
		        undo, next.
		    end.    /* error updating attribute values. */
      
            FIND FIRST rycso WHERE
                       rycso.smartobject_obj = ryc_object_instance.container_smartobject_obj
                       NO-LOCK.
            
            PUBLISH "DCU_WriteLog":U ("Created new `Page` link on object " + rycso.object_filename).
        END.    /* n/a link */
    END.    /* each object instance of that class object */
END.    /* objects in SmartFolder class. */

PUBLISH "DCU_WriteLog":U ("Creation of missing `Page` link completed "
                          + (if lError then "with errors!" else "successfully.") ).
                          
RETURN.

/** FUNCTION IMPLEMENTAIONS **/
FUNCTION getNextObj RETURNS DECIMAL ( ) :
/*------------------------------------------------------------------------------
  Purpose:  To return the next available unique object number.
    Notes:  
-----------------------------------------------------------------------------*/
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
    iSessnId    = CURRENT-VALUE(seq_session_id,ICFDB).

  IF iSeqObj1 = 0 THEN
    ASSIGN iSeqObj2 = NEXT-VALUE(seq_obj2,ICFDB).

  ASSIGN dSeqNext = DECIMAL((iSeqObj2 * 1000000000.0) + iSeqObj1).

  IF iSeqSiteDiv <> 0 AND iSeqSiteRev <> 0 THEN
    ASSIGN dSeqNext = dSeqNext + (iSeqSiteRev / iSeqSiteDiv).

  RETURN dSeqNext. /* Function return value */
END FUNCTION.
/* eof */