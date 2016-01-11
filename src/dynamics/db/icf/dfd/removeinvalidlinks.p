/* This fix program removes invalid links in containers */

DEFINE VARIABLE cLinkName AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cMessage  AS CHARACTER  NO-UNDO.

DEFINE BUFFER bryc_object_instance FOR ryc_object_instance.

  FOR EACH ryc_smartlink:
    
    IF ryc_smartlink.source_object_instance_obj NE 0 THEN
      FIND ryc_object_instance WHERE 
        ryc_object_instance.object_instance_obj = ryc_smartlink.source_object_instance_obj NO-LOCK NO-ERROR.
      
    IF ryc_smartlink.target_object_instance_obj NE 0 THEN
      FIND bryc_object_instance WHERE
        bryc_object_instance.object_instance_obj = ryc_smartlink.target_object_instance_obj NO-LOCK NO-ERROR.

    IF (NOT AVAILABLE ryc_object_instance AND 
        ryc_smartlink.source_object_instance_obj NE 0) OR 
       (NOT AVAILABLE bryc_object_instance AND
        ryc_smartlink.target_object_instance_obj NE 0) THEN
    DO:
      FIND ryc_smartobject WHERE 
        ryc_smartobject.smartobject_obj = ryc_smartlink.container_smartobject_obj NO-LOCK NO-ERROR.
      IF AVAILABLE ryc_smartobject THEN
      DO:
        cLinkName = ryc_smartlink.link_name.
        DELETE ryc_smartlink NO-ERROR.
        IF NOT ERROR-STATUS:ERROR THEN
        DO:
          cMessage = 'Invalid Smartlink removed from ':U +
                      ryc_smartobject.object_filename + CHR(10) + 
                     'Link: ':U + cLinkName + CHR(10) + 
                     'Source: ':U + 
                     IF NOT AVAILABLE ryc_object_instance THEN 
                       'Invalid':U ELSE ryc_object_instance.instance_name + CHR(10) +
                     'Target: ':U + 
                     IF NOT AVAILABLE bryc_object_instance THEN 
                       'Invalid':U ELSE bryc_object_instance.instance_name.
          PUBLISH 'DCU_WriteLog':U (cMessage).
        END.  /* if no error */
      END.  /* if available container */
    END.  /* if source or target are not available */ 

  END.  /* for each smartlink */

  RETURN.
