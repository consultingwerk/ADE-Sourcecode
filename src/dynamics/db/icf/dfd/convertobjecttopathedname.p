/** This utility ensures that the RenderingProcedure and SuperProcedure attribute values contain
    a relatively-pathed filename rather than the name of an object.
   
   ------------------------------------------------------------------------------------------------------ 
 **/
define variable lError              as logical      no-undo.
define variable cPathedObjectName   as character    no-undo.
define variable cOldValue           as character    no-undo.
define variable cNewValue           as character    no-undo.
define variable iLoop       as integer    no-undo.

define buffer rycav        for ryc_attribute_value.

FUNCTION getNextObj RETURNS DECIMAL forward.

/* First make sure that there are no blanks. */
PUBLISH "DCU_WriteLog":U ("Transforming SuperProcedure and RenderingProcedure from object names to relatively pathed names.").

for each ryc_attribute where
         ryc_attribute.attribute_label = "SuperProcedure":U or 
         ryc_attribute.attribute_label = "RenderingProcedure":U
         no-lock,
    each ryc_attribute_value where
         ryc_attribute_value.attribute_label = ryc_attribute.attribute_label and
         ryc_attribute_value.character_value <> "":U
         exclusive-lock:
         
  assign cOldValue = ryc_attribute_value.character_value
       cNewValue = "":U.
    
  do iLoop = 1 to num-entries(cOldValue):
      find first ryc_smartobject where
                 ryc_smartobject.object_filename = entry(iLoop, cOldValue)
                 no-lock no-error.
      /* There may be an extension involved. */
      if not available ryc_smartobject then
      find first ryc_smartobject where
                 ryc_smartobject.object_filename = entry(1, entry(iLoop, cOldValue), ".":U)
                 no-lock no-error.
      
      if not available ryc_smartobject then
      do:
          assign lError = yes.
          PUBLISH "DCU_WriteLog":U ("Unable to find associated object record for: " + ryc_attribute_value.character_value ).
          next.
      end.    /* can't find smartobject */
      
      IF ryc_smartobject.object_is_runnable THEN
          ASSIGN cPathedObjectName = REPLACE(ryc_smartobject.Object_Path, "~\":U, "/":U)
                 cPathedObjectName = RIGHT-TRIM(cPathedObjectName, "/":U)
                                   + ( IF ryc_smartobject.Object_Path EQ "":U THEN "":U ELSE "/":U )
                                   + ryc_smartobject.Object_Filename
                                   + (IF ryc_smartobject.Object_Extension <> "":U THEN ".":U + ryc_smartobject.Object_Extension
                                       ELSE "":U ).
      ELSE
          ASSIGN cPathedObjectName = ryc_smartobject.object_filename.
          
    assign cNewValue = cNewValue + ",":U + cPathedObjectName.
  end.  /* loop through values */

    assign cNewValue = left-trim(cNewValue, ",").
    
    if cNewValue ne "":U then
    do:
        assign ryc_attribute_value.character_value = cNewValue no-error.
      if error-status:error then
      do:
          assign lError = yes.
          PUBLISH "DCU_WriteLog":U ("Unable to update attribute value record with " + cNewValue ).
          undo, next.    
      end.    /* error updating attribute values. */
    
      /* If we are updating the SuperProcedure attribute for an object,
       * the default behaviour is that the super is run stateful. We need to create/update
       * the SuperProcedureMode attribute to ensure that this still happens.
       */
      IF ryc_attribute.attribute_label eq "SuperProcedure":U and
         ryc_attribute_value.smartobject_obj gt 0 then
      do:
          find first rycav where
                     rycav.object_type_obj     = ryc_attribute_value.object_type_obj and
                     rycav.smartobject_obj     = ryc_attribute_value.smartobject_obj and
                     rycav.object_instance_obj = ryc_attribute_value.object_instance_obj and
                     rycav.attribute_label     = "SuperProcedureMode":U
                     exclusive-lock no-error.
          if not available rycav then
          do:
              create rycav.
              assign rycav.attribute_value_obj = getNextObj().
              
              buffer-copy ryc_attribute_value except attribute_value_obj attribute_label
                       to rycav 
                  assign rycav.attribute_label = "SuperProcedureMode":U
                         no-error.
          if error-status:error then
          do:
              assign lError = yes.
              PUBLISH "DCU_WriteLog":U ("Unable to create SuperProcedureMode attribute value.").
              undo, next.
          end.    /* error updating attribute values. */                       
          end.    /* n/a rycav */
          
          assign rycav.character_value = right-trim(fill("STATEFUL,":U, num-entries(cNewValue)), ",":U) no-error.
        if error-status:error then
        do:
            assign lError = yes.
            PUBLISH "DCU_WriteLog":U ("Unable to update SuperProcedureMode attribute value.").
            undo, next.
        end.    /* error updating attribute values. */
      end.    /* update the superproceduremode */     
    
      /* Record the changes. */    
      if not lError then
          PUBLISH "DCU_WriteLog":U ("Attribute value record changed from " + cOldValue + " to " + cNewValue).
    end.    /* there is a new value. */
end.    /* each attribute  */

PUBLISH "DCU_WriteLog":U ("Transformation of SuperProcedure and RenderingProcedure completed "
                          + (if lError then "with errors!" else "successfully.") ).
return.

FUNCTION getNextObj RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
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
    iSessnId    = CURRENT-VALUE(seq_session_id,ICFDB)    .

  IF iSeqObj1 = 0 THEN
    ASSIGN iSeqObj2 = NEXT-VALUE(seq_obj2,ICFDB).

  ASSIGN dSeqNext = DECIMAL((iSeqObj2 * 1000000000.0) + iSeqObj1).

  IF  iSeqSiteDiv <> 0   AND iSeqSiteRev <> 0   THEN
    ASSIGN dSeqNext = dSeqNext + (iSeqSiteRev / iSeqSiteDiv).

  RETURN dSeqNext. /* Function return value */
END FUNCTION.
/* eof */
