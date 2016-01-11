/* This program fixes the instance_name field in ryc_object_instance table
   by changing it to whatever the 'fieldName' ryc_attribute_value record
   has stored for the instance.
   
   Depending upon when the instance was added this might be copying bad 
   information over bad.  This will not break the instance anymore than 
   it already is, though in these cases the object instances will have 
   to be fixed manually. 
   
   This fix program addresses issue # 12624 */
   
DEFINE BUFFER rycoi    FOR icfdb.ryc_object_instance.
DEFINE BUFFER instance FOR icfdb.ryc_object_instance.
DEFINE BUFFER otherinst FOR icfdb.ryc_object_instance.

DEFINE BUFFER rycso   FOR icfdb.ryc_smartobject.
DEFINE BUFFER rycav   FOR icfdb.ryc_attribute_value.
DEFINE BUFFER attribute FOR icfdb.ryc_attribute_value.
DEFINE BUFFER gscot   FOR icfdb.gsc_object_type.
DEFINE BUFFER bViewer FOR icfdb.ryc_smartobject.

DEFINE VARIABLE cViewer    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cFieldName AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cInstance  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cUsedName  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cClassList AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lNameClash AS LOGICAL    NO-UNDO.
DEFINE VARIABLE lLocal     AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cOldName   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iSeq       AS INTEGER    NO-UNDO.
DEFINE VARIABLE iClass     AS INTEGER    NO-UNDO.
DEFINE VARIABLE rRycav     AS ROWID      NO-UNDO.
DEFINE VARIABLE rRycoi     AS ROWID      NO-UNDO.

FUNCTION getClassChildren   RETURNS CHARACTER
	(INPUT pcClass AS CHARACTER) FORWARD.

function inheritsFrom	returns logical
	(input pcClass		  as character,
	 input pcInheritsFrom as character) forward.

FUNCTION isInstanceLocal RETURNS LOGICAL
    ( INPUT pdObjectType     AS DECIMAL,
      INPUT pdSmartObject    AS DECIMAL,
      INPUT pdObjectInstance AS DECIMAL) FORWARD.

FUNCTION IsDesignSourceSBO RETURNS LOGICAL
   (pdSDOObj AS DECIMAL ) FORWARD.


PUBLISH "DCU_SetStatus":U ("Starting conversion of instance_name values from FieldName values").
PUBLISH "DCU_WriteLog":U ("Starting conversion of instance_name values from FieldName values").

cClassList = getClassChildren('Field').
DO iClass = 1 TO NUM-ENTRIES(cClassList,CHR(1)):

  FIND FIRST gscot WHERE gscot.OBJECT_type_obj EQ DEC(ENTRY(iClass,cClassList,CHR(1))) NO-LOCK NO-ERROR.

  IF AVAILABLE gscot THEN 
  DO:
    SDFLoop:
    FOR EACH rycso  WHERE rycso.OBJECT_type_obj EQ gscot.OBJECT_type_obj NO-LOCK,
        EACH rycoi  WHERE rycoi.smartobject_obj EQ rycso.smartobject_obj NO-LOCK:
        
      FIND FIRST rycav WHERE rycav.object_type_obj     EQ gscot.object_type_obj     AND
                             rycav.OBJECT_instance_obj EQ rycoi.OBJECT_instance_obj AND
                             rycav.smartobject_obj     EQ rycoi.smartobject_obj     AND
                             rycav.attribute_label     EQ 'FieldName'               NO-LOCK NO-ERROR.
    
      /* Try to find a fieldName attribute related to the instance, if not 
         available, try to find one at the master. */
      IF NOT AVAILABLE rycav THEN
        FIND FIRST rycav WHERE rycav.object_type_obj     EQ gscot.object_type_obj     AND
                               rycav.smartobject_obj     EQ rycoi.smartobject_obj     AND
                               rycav.attribute_label     EQ 'FieldName'               AND
                               rycav.OBJECT_instance_obj EQ 0 NO-LOCK NO-ERROR.
      
      /* No FieldName; the object is a template (or useless), just get next*/
      IF NOT AVAIL rycav THEN
        NEXT.
      
      ASSIGN
        rRycav     = ROWID(rycav)
        rRycoi     = ROWID(rycoi)
        cFieldName = rycav.CHARACTER_value
        .

      IF cFieldName <> rycoi.instance_name THEN
      DO:
        /* Grab the viewer record for check of design source */
        FIND bViewer WHERE bViewer.smartobject_obj EQ rycoi.container_smartobject_obj NO-LOCK NO-ERROR.
        IF cFieldName = '':U OR cFieldName = ? THEN
        DO TRANSACTION:
          FIND attribute WHERE ROWID(attribute) = rRycav EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
           
          if locked attribute then
          do:
            publish "DCU_WriteLog":U ("ERROR: Unable to lock object attribute " + string(rycav.attribute_value_obj) + " for update.").
            next.
          end.	/* locked */
           
          attribute.CHARACTER_value = rycoi.instance_name.
           
          PUBLISH "DCU_WriteLog":U ("Changed blank FieldName attribute to " 
                                    + rycoi.instance_name 
                                    + " (Instance Object Id: " + string(rycoi.object_instance_obj) + ")"
                                    + " on viewer: " + bViewer.OBJECT_filename).
        END.
        ELSE DO:
          /* if local instance, use the Fieldname as-is as instance name */ 
          lLocal = isInstanceLocal(gscot.OBJECT_type_obj,
                             rycso.smartobject_obj,
                             rycoi.object_instance_obj).
          IF lLocal THEN
            cInstance = cFieldName.
          /* space was used bewtween table field, use the field.  */
          ELSE IF NUM-ENTRIES(cFieldName,' ':U) > 1 THEN
            cInstance = ENTRY(NUM-ENTRIES(cFieldName,' ':U),cFieldName,' ':U).

          /* keep period in name if SBO, remove table if not */
          ELSE IF NUM-ENTRIES(cFieldName,'.':U) > 1 THEN
          DO:
            IF isDesignSourceSBO(bViewer.sdo_smartobject_obj) THEN
              cInstance = cFieldname.
            ELSE 
              cInstance = ENTRY(NUM-ENTRIES(cFieldName,'.':U),cFieldName,'.':U).
          END.
          ELSE 
            cInstance = cFieldName.
          /* ensure new instance name is unique within the container */
          iSeq = 0.
          DO WHILE TRUE:
            IF CAN-FIND(otherinst 
                        WHERE otherinst.container_smartObject_obj = rycoi.container_smartobject_obj
                        AND   otherinst.instance_name             = cInstance
                        AND   ROWID(otherinst) <> ROWID(rycoi) ) THEN
            DO:
              IF NOT lLocal THEN
              DO:
                PUBLISH "DCU_WriteLog":U 
                             ("ERROR: Could not change instance name from " 
                             + cOldname  + " to " + cInstance
                             + " (Object Id: " + string(rycoi.object_instance_obj) + ")"
                             + " on viewer: " + bViewer.OBJECT_filename + "."
                             + "The name is in use on another instance! "
                             ).
                NEXT SDFLoop.
              END.

              IF NOT lNameClash THEN
                 cUsedName = cInstance. 
              lNameClash = TRUE.

              IF R-INDEX(cInstance,'(') > 0 THEN 
              DO:
                /* is there a number between paranthesis */
                iSeq = INT(SUBSTR(cInstance,R-INDEX(cInstance,'(') + 1,(R-INDEX(cInstance,')')) - (R-INDEX(cInstance,'(') + 1))) NO-ERROR.
                /* if number was found then remove the parenthesis */
                IF iSeq > 0 THEN
                  cInstance = SUBSTR(cInstance,1,R-INDEX(cInstance,'(') - 1).
              END.
              iSeq = iSeq + 1.
              cInstance = cInstance + '(' + STRING(iSeq) + ')'. 
            END.
            ELSE 
              LEAVE.
          END.  /* do whilew true */
    
          DO TRANSACTION:
            FIND instance WHERE rowid(instance) = rowid(rycoi) exclusive-lock no-wait no-error.
        		if locked instance then
    	    	do:
    			  	publish "DCU_WriteLog":U ("ERROR: Unable to lock object instance ' + rycoi.instance_name + 'for update.").
    		    	next.
    	    	end.   /* locked */
            
            /*
            IF cInstance <> cFieldName THEN
            DO:
              FIND attribute WHERE ROWID(attribute) = rRycav EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
           
              if locked attribute then
              do:
                publish "DCU_WriteLog":U ("ERROR: Unable to lock object attribute " + string(rycav.attribute_value_obj) + " for update.").
                next.
              end.	/* locked */

              attribute.CHARacter_value = cInstance.
              PUBLISH "DCU_WriteLog":U ("Changed FieldName attribute from " 
                           + cFieldName  + " to " + attribute.CHARacter_value
                           + " (Object Id: " + string(attribute.attribute_value_obj) + ")"
                           + (IF attribute.OBJECT_instance_obj <> 0 THEN
                             " on viewer: " + bViewer.OBJECT_filename + "."
                             ELSE 
                             " on master.")

                           + (IF lNameClash THEN " Instance Name " + cUsedName + " was in use already! "
                              ELSE "")
                           ).

            END.
            */

            ASSIGN
              cOldname = instance.instance_name
			        instance.instance_name = cInstance.
            
            PUBLISH "DCU_WriteLog":U ("Changed instance name from " 
                                       + cOldname  + " to " + instance.instance_name
                                       + " (Object Id: " + string(instance.object_instance_obj) + ")"
                                       + " on viewer: " + bViewer.OBJECT_filename + "."
                                       + (IF lNameClash THEN " Instance Name " + cUsedName + " was in use already! "
                                          ELSE "")
                                       ).
          END. /* do transaction */
        END. /* else (fieldName <> '')*/
      END. /* FieldName <> instance_name */
    END. /* for each rycso,rycoi*/
  END. /* avail gsot */
END.  /* class loop */

FUNCTION IsDesignSourceSBO RETURNS LOGICAL
  (pdSDOObj AS DECIMAL ):
  
  DEFINE BUFFER rycso FOR ryc_smartobject. 
  DEFINE BUFFER gscot FOR gsc_object_type.

  FIND FIRST rycso WHERE 
           rycso.smartobject_obj = pdSDOObj NO-LOCK NO-ERROR.
  
  IF AVAILABLE rycso THEN 
    FIND gscot WHERE 
               gscot.object_type_obj = rycso.object_type_obj
               NO-LOCK NO-ERROR.
  
  IF (AVAILABLE gscot AND inheritsFrom(gscot.object_type_code, 'SBO')) THEN 
    RETURN TRUE.
  ELSE 
    RETURN FALSE.

END.

function getClassChildren	returns character
	(input pcClass as character):
	
  DEFINE VARIABLE cCurrentClassList AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dObjectTypeObj    AS DECIMAL    NO-UNDO.

  /* Localize the gsc_object_type buffer to this function. This is particularly important seeing that the function is called recursively */
  DEFINE BUFFER gsc_object_type FOR gsc_object_type.
  
	/* See if the given class exists */
	FIND FIRST gsc_object_type WHERE	
			   gsc_object_type.object_type_code = pcClass 
			   no-lock NO-ERROR.
	/* See if the specified class exists */
  	IF AVAILABLE gsc_object_type THEN
  	DO:
        ASSIGN dObjectTypeObj    = gsc_object_type.object_type_obj
        	   cCurrentClassList = string(dObjectTypeObj).
        	   
        /* Step through all the children of the current class */
        FOR EACH gsc_object_type WHERE 
        	     gsc_object_type.extends_object_type_obj = dObjectTypeObj
        	     no-lock:
        	/* For every child, see if there are any children underneath it, by recursively calling this function */
			assign cCurrentClassList = cCurrentClassList + chr(1) + getClassChildren(gsc_object_type.object_type_code).
        END.	/* each class */
    END.	/* available class */
    
	return cCurrentClassList.                 
end function.	/* getclasschildren */

function inheritsFrom	returns logical
	( input pcClass		   as character,
	  input pcInheritsFrom as character	  ):
	
	DEFINE BUFFER gscot FOR gsc_object_type.
  DEFINE VARIABLE cHierarchy  AS CHARACTER  NO-UNDO.

  ASSIGN 
    cHierarchy = getClassChildren(pcInheritsFrom).
	
  IF cHierarchy = "":U THEN   
	  RETURN FALSE .
        	
  FIND gscot WHERE 
			 gscot.object_type_code = pcClass
			 NO-LOCK NO-ERROR.
  IF NOT AVAILABLE gscot THEN   
	  RETURN NO.
    		
  RETURN LOOKUP(STRING(gscot.object_type_obj), cHierarchy, CHR(1)) GT 0.
end function.


FUNCTION isInstanceLocal RETURNS LOGICAL
    ( INPUT pdObjectType     AS DECIMAL,
      INPUT pdSmartObject    AS DECIMAL,
      INPUT pdObjectInstance AS DECIMAL):
  
  DEFINE BUFFER rycav FOR ryc_attribute_value.

  FIND FIRST rycav WHERE rycav.attribute_label     EQ 'LocalField'     AND
                         rycav.OBJECT_type_obj     EQ pdObjectType     AND
                         rycav.OBJECT_instance_obj EQ pdObjectInstance AND
                         rycav.smartobject_obj     EQ pdSmartObject NO-LOCK NO-ERROR.
  RETURN AVAILABLE rycav.
END FUNCTION.
