/* This fix program changes any toolbar links from toolbars to 
   containers to containertoolbar links.  */

DEFINE VARIABLE cError        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cFromLinkName AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cMessage      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cToLinkName   AS CHARACTER  NO-UNDO.

DEFINE BUFFER bryc_smartlink_type FOR ryc_smartlink_type.

  ASSIGN 
    cFromLinkName = 'Toolbar':U
    cToLinkName   = 'ContainerToolbar':U.
  
  FIND ryc_smartlink_type WHERE ryc_smartlink_type.link_name = cFromLinkName NO-LOCK NO-ERROR.
  FIND bryc_smartlink_type WHERE bryc_smartlink_type.link_name = cToLinkName NO-LOCK NO-ERROR.
  IF AVAILABLE ryc_smartlink_type AND AVAILABLE bryc_smartlink_type THEN
  DO:
    FOR EACH ryc_smartobject WHERE ryc_smartobject.container_object = TRUE NO-LOCK: 

      FOR EACH ryc_smartlink WHERE 
          ryc_smartlink.container_smartobject = ryc_smartobject.smartobject_obj EXCLUSIVE-LOCK:

        IF ryc_smartlink.smartlink_type_obj = ryc_smartlink_type.smartlink_type_obj AND
           ryc_smartlink.target_object_instance = 0 THEN
        DO:
           ASSIGN
             ryc_smartlink.smartlink_type_obj = bryc_smartlink_type.smartlink_type_obj
             ryc_smartlink.link_name          = bryc_smartlink_type.link_name NO-ERROR.
           IF NOT ERROR-STATUS:ERROR THEN 
           DO:
             cMessage = 'Toolbar link changed to ContainerToolbar in ':U + 
                        ryc_smartobject.object_filename.
             PUBLISH 'DCU_WriteLog':U (cMessage).
           END.  /* if no error */
        END.  /* if smartlink_type_obj and target is 0 */
      END.  /* for each link */
    END.  /* for each container */
  END.  /* if available smartlink types */
  
  RETURN.  

    
