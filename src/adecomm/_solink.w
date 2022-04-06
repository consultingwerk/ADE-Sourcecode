/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: _solink.w

  Description: Given smart object handles, it determines if objects 
     should be linked
     The following 'illegal' matches are handled:
 
** ALLOWS dynamic objects with NO fields to be linked to anything

 * querySmartBrowser -> Data Link -> smartDataBrowser
 * SmartDataObject   -> Data Link -> smartDataBrowser
     if SmartDataObject already has another 
        SmartDataObject   -> Data Link -> smartDataBrowser
 * Commit Panel -> Commit  -> SmartDataObject with no updateable fields
 * Update Panel -> TableIO -> visual (SmartDataBrowser, SmartDataViewer) 
      with no enabled fields 

     Returns NO  if above criteria fails
     Returns YES if above criteria succeeds 
     Returns ?   if we can not determine if match 
                   (ie. ERROR when running functions, ? returned from functions)
  Input Parameters:
      ph_1stObject       handle of first  smart object
      ph_2ndObject       handle of second smart object 
      pc_link-type       What type of link are we attempting 
      pl_details         Do they want details? 
  Output Parameters:
      pl_objectsLink    logical  
  Author: SLK
  Created: 12/98

------------------------------------------------------------------------*/
/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
DEFINE INPUT  PARAMETER ph_1stObject        AS HANDLE              NO-UNDO.
DEFINE INPUT  PARAMETER ph_2ndObject        AS HANDLE              NO-UNDO.
DEFINE INPUT  PARAMETER pc_link-type        AS CHARACTER           NO-UNDO.
DEFINE INPUT  PARAMETER pl_details          AS LOGICAL             NO-UNDO.
DEFINE OUTPUT PARAMETER pl_objectsLink      AS LOGICAL INIT YES    NO-UNDO.
DEFINE OUTPUT PARAMETER pc_errorMsg         AS CHARACTER           NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE c_1stObjType                AS CHARACTER           NO-UNDO.
DEFINE VARIABLE c_2ndObjType                AS CHARACTER           NO-UNDO.
DEFINE VARIABLE l_1stObjIsQueryObject       AS LOGICAL             NO-UNDO.
DEFINE VARIABLE l_2ndObjIsQueryObject       AS LOGICAL             NO-UNDO.
DEFINE VARIABLE h_Temp                      AS HANDLE              NO-UNDO.
DEFINE VARIABLE l_Temp                      AS LOGICAL             NO-UNDO.
DEFINE VARIABLE c_Temp                      AS CHARACTER           NO-UNDO.

/* ******************************************************************** */

/* determine the type of object */
ASSIGN
   c_1stObjType = DYNAMIC-FUNCTION("getObjectType":U IN ph_1stObject) 
   c_2ndObjType = DYNAMIC-FUNCTION("getObjectType":U IN ph_2ndObject)
   l_1stObjIsQueryObject = DYNAMIC-FUNCTION("getQueryObject":U IN ph_1stObject) 
   l_2ndObjIsQueryObject = DYNAMIC-FUNCTION("getQueryObject":U IN ph_2ndObject)
   pl_objectsLink = ?
   NO-ERROR.

/* QuerySmartBrowser -> Data Link -> smartDataBrowser */
IF CAN-DO("Data":U,pc_link-type) AND
   (c_1stObjType = "smartDataBrowser":U AND 
    c_2ndObjType = "smartDataBrowser":U AND
    (l_1stObjIsQueryObject OR
    l_2ndObjIsQueryObject)) AND
    (NOT (l_1stObjIsQueryObject AND l_2ndObjIsQueryObject)) THEN 
DO:
   ASSIGN pl_objectsLink = NO
            pc_errorMsg = pc_link-type +
               " link two SmartDataBrowsers. They cannot share a query.".       
   RETURN.
END.

/* Commit Panel -> Commit  -> SmartDataObject with no updateable fields
 */
IF CAN-DO("Commit":U,pc_link-type) AND
   ((c_1stObjType = "smartPanel":U 
     AND c_2ndObjType = "smartDataObject":U) OR
    (c_1stObjType = "smartDataObject":U 
     AND c_2ndObjType = "smartPanel":U)) THEN 
DO:
   ASSIGN 
      h_Temp = IF c_1stObjType = "SmartDataObject":U 
                    THEN ph_1stObject
                    ELSE ph_2ndObject
      c_Temp = DYNAMIC-FUNCTION("getUpdatableColumns":U IN h_Temp)
   NO-ERROR.

   /* If we get an error when getting UpdatableColumns, then link fails
    * If we get a blank or ? then let's test if the object is dynamic
    * If dynamic (no fields in the object), then link possible , else not
    */
   IF ERROR-STATUS:ERROR THEN ASSIGN pl_objectsLink = NO.
   IF c_Temp = "" OR c_Temp = ? THEN
   DO: /* Determine if dynamic object */
      ASSIGN
         c_Temp = DYNAMIC-FUNCTION("getDataColumns":U IN h_Temp)
      NO-ERROR.
      IF ERROR-STATUS:ERROR OR (c_Temp <> "":U AND c_Temp <> ?) THEN 
      ASSIGN pl_objectsLink = NO.
   END.

   IF NOT pl_objectsLink THEN 
   DO:
      ASSIGN 
          pc_errorMsg = pc_link-type + " link a SmartPanel with a SmartDataObject "
             + " with no updateable fields.".       
      RETURN.
   END. /* No Updateable fields */
END.

/* Update Panel -> TableIO -> visual (SmartDataBrowser, SmartDataViewer)
 *    with no enabled fields
 */
IF CAN-DO("TableIO":U,pc_link-type) AND
   ((c_1stObjType = "smartPanel":U 
     AND CAN-DO("smartDataViewer,smartDataBrowser",c_2ndObjType)) OR
    (CAN-DO("smartDataViewer,smartDataBrowser",c_1stObjType) 
     AND c_2ndObjType = "smartPanel":U)) AND 
    ( NOT (l_1stObjIsQueryObject OR l_2ndObjIsQueryObject)) THEN
DO:
   ASSIGN 
      h_Temp = IF CAN-DO("smartDataViewer,smartDataBrowser":U,c_1stObjType) 
                    THEN ph_1stObject
                    ELSE ph_2ndObject
      c_Temp = DYNAMIC-FUNCTION("getEnabledFields":U IN h_Temp)
   NO-ERROR.
   /* If we get an error when getting UpdatableColumns, then link fails
    * If we get a blank or ? then let's test if the object is dynamic
    * If dynamic (no fields in the object), then link possible , else not
    */
   IF ERROR-STATUS:ERROR THEN ASSIGN pl_objectsLink = NO.
   IF c_Temp = "" OR c_Temp = ? THEN
   DO: /* Determine if dynamic object */
      ASSIGN
         c_Temp = DYNAMIC-FUNCTION("getDisplayedFields":U IN h_Temp)
      NO-ERROR.
      IF ERROR-STATUS:ERROR OR (c_Temp <> "":U AND c_Temp <> ?) THEN 
      ASSIGN pl_objectsLink = NO.
   END.
   IF NOT pl_objectsLink THEN
   DO:
      pc_errorMsg = pc_link-type + " link a SmartPanel with a VisualObject "
             + " with no enabled fields.".       
      RETURN.
   END.
END.
