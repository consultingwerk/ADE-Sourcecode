/* Program:     fixSuperProcedureAttr.p 
   Parameters:  <none>
   Purpose:     This utility fixes the SuperProcedure attribute and ensures only
                the relative class is specified. The appBuilder accidentally wrote
                out the full pathname in the 2.1 release.
                
                It retrieves all super Procedures of DynViewers and DynBrowsers and
                ensures the relative path is specified.
                
   Note:        The adetools must be be specified in the Propath as this program runs
                the procedure _relname.p in the adecomm directory (adecomm.pl)
 * ------------------------------------------------------------------------------------------------------ **/
DEFINE VARIABLE cDynClassList      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cExtClassList      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iObjectTypeLoop    AS INTEGER    NO-UNDO.
DEFINE VARIABLE iClass             AS INTEGER    NO-UNDO.
DEFINE VARIABLE cFullPathName      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cRelFileName       AS CHARACTER  NO-UNDO.

/* Only checking Dynviewers and dynbrowsers as these are the only objects that were    
   incorrectly assigned super procedures with full path names */   
ASSIGN cDynClassList = "dynView,dynBrow":U.

 /* Find Extended classes  */
DO iClass = 1 to NUM-ENTRIES(cDynClassList): 
   FIND FIRST gsc_object_type NO-LOCK
        WHERE gsc_object_type.object_type_code = ENTRY(iClass,cDynClassList) NO-ERROR.
   IF AVAILABLE gsc_object_type THEN 
   DO:
      ASSIGN cExtClassList = cExtClassList + (IF cExtClassList = "" THEN "" ELSE ",") 
                                           +  gsc_object_type.object_type_code.           
      RUN FindExtendedClass IN THIS-PROCEDURE (gsc_object_type.object_type_obj).
   END.    
END.

/* Loop through object classes */
dynObjectBlock:
DO iObjectTypeLoop = 1 TO NUM-ENTRIES(cExtClassList):
   FIND FIRST gsc_object_type NO-LOCK
      WHERE gsc_object_type.object_type_code = ENTRY(iObjectTypeLoop,cExtClassList)
      NO-ERROR.           
   IF AVAIL gsc_object_type THEN
   DO:
     dynSmartobjectBlock:
     FOR EACH ryc_smartobject NO-LOCK
         WHERE ryc_smartobject.object_type_obj = gsc_object_type.object_type_obj:
              
        FIND FIRST ryc_attribute_value NO-LOCK WHERE
                   ryc_attribute_value.object_Type_obj     = ryc_smartObject.object_Type_obj AND
                   ryc_attribute_value.smartobject_obj     = ryc_smartObject.smartobject_obj AND
                   ryc_attribute_value.object_instance_obj = 0                               AND
                   ryc_attribute_value.attribute_label     = "SuperProcedure":U
                   NO-ERROR.
        
        IF AVAIL ryc_attribute_value AND ryc_attribute_value.character_value > "" THEN
        DO:
           /* Check if relative path is specified. */
           ASSIGN FILE-INFO:FILE-NAME = ryc_attribute_value.character_value 
                  cFullPathName       = FILE-INFO:FULL-PATHNAME NO-ERROR.
           /* If the fullPathName is the same as the stored value, then we have a full-pathname defined*/
           IF cFullPathName = REPLACE(ryc_attribute_value.character_value,"/":U,"~\":U) AND cFullPathName <> ? THEN
           DO:
              RUN adecomm/_relname.p (ryc_attribute_value.character_value , "MUST-BE-REL":U,
                                      OUTPUT cRelFileName) NO-ERROR.
              IF cRelFileName > "" AND NOT ERROR-STATUS:ERROR THEN
              DO:
                 FIND CURRENT ryc_attribute_value  EXCLUSIVE-LOCK NO-ERROR.
                 IF AVAIL ryc_attribute_value THEN
                   ASSIGN ryc_attribute_value.character_value = cRelFileName.
              END.
           END.
        END. /* End if Super Proc has a value*/                           
     END. /* End FOR EACH ryc_smartobject */  
   END.  /* End avail gsc_object_type */
END. /* Object type loop */

RETURN.

PROCEDURE FindExtendedClass:
  DEFINE INPUT PARAMETER pdObj AS DECIMAL NO-UNDO.
  DEFINE BUFFER bObjectType FOR gsc_object_type.

  FOR EACH bObjectType NO-LOCK
      WHERE bObjectType.extends_object_type_obj = pdObj
         BY bObjectType.object_type_code:
      /* For every child, see if there are any children underneath it, by recursively calling this procedure */
         cExtClassList = cExtClassList + ",":U  + bObjectType.object_type_code.
      RUN FindExtendedClass IN THIS-PROCEDURE (bObjectType.object_type_obj).
  END.

END PROCEDURE.

/* eof */
