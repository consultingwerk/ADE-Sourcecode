/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: _somatch.w

  Description: Given smart object handles, it determines if objects match
     The following matches are handled:
 
 * querySmartBrowser = objectType = "smartDataBrowser" AND isQueryObject
 * 
 * NO Signature Check is not supported link : Data, Update
 * NO Signature Check 2 queryObjects, Data Link 
 *                    smartData->Data->smartData
 *                    smartData->Data->querySmartBrowser
 *                    querySmartBrowser->Data->smartData
 *                    querySmartBrowser->Data->querySmartBrowser
 * NO Signature Check if no queryObjects
 * NO Signature Check 1 querySmartBrowser 1 smartDataBrowser
 *                    querySmartBrowser->Data->smartDataBrowser
 * NO Signature Check if dynamic objects

 * STRICT tt signature
 *        getDataSignature(queryObject) = getDataSignature(visualObject)
 *   smartData->Data->smartDataBrowser

 * LENIENT field exists signature
 *   getDisplayedColumns(visualObject) in getDataColumns(queryObject) 
 *
 *   smartData->Data->smartDataViewer   
 *   querySmartBrowser->Data->smartDataViewer   
 *    

 * LENIENT enabled exists updatable signature
 *   getEnabledFlds(visualObject) in getUpdatableFlds(queryObject) 
 *
 *   smartDataViewer->Update->smartData
 *   smartDataBrowser->Update->smartData
 *   queryDataBrowser->Update->smartData
 *

     Returns YES if above criteria succeed
             "" for error message
     Returns NO  if above criteria does not succeed
             error message
     Returns ?   if we can not determine if match 
                   (ie. ERROR when running functions, ? returned from functions)
  Input Parameters:
      ph_1stObject       handle of first  smart object
      ph_2ndObject       handle of second smart object 
      pc_link-type       What type of link are we attempting 
      pl_details         Do they want details? 
  Output Parameters:
      pl_objectsMatch    logical  
  Author: SLK
  Created: 3/98

------------------------------------------------------------------------*/
/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
DEFINE INPUT  PARAMETER ph_1stObject        AS HANDLE              NO-UNDO.
DEFINE INPUT  PARAMETER ph_2ndObject        AS HANDLE              NO-UNDO.
DEFINE INPUT  PARAMETER pc_link-type        AS CHARACTER           NO-UNDO.
DEFINE INPUT  PARAMETER pl_details          AS LOGICAL             NO-UNDO.
DEFINE OUTPUT PARAMETER pl_objectsMatch     AS LOGICAL INIT YES    NO-UNDO.
DEFINE OUTPUT PARAMETER pc_errorMsg         AS CHARACTER           NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE c_VisualSignature           AS CHARACTER           NO-UNDO.
DEFINE VARIABLE c_1stObjType                AS CHARACTER           NO-UNDO.
DEFINE VARIABLE c_QuerySignature            AS CHARACTER           NO-UNDO.
DEFINE VARIABLE c_2ndObjType                AS CHARACTER           NO-UNDO.
DEFINE VARIABLE c_EnabledFlds               AS CHARACTER           NO-UNDO.
DEFINE VARIABLE c_SQueryColumns             AS CHARACTER           NO-UNDO.
DEFINE VARIABLE c_SVisualColumns            AS CHARACTER           NO-UNDO.
DEFINE VARIABLE c_SQueryColumnsExp          AS CHARACTER           NO-UNDO.
DEFINE VARIABLE c_SVisualColumnsExp         AS CHARACTER           NO-UNDO.
DEFINE VARIABLE c_UpdatableFlds             AS CHARACTER           NO-UNDO.
DEFINE VARIABLE cnt                         AS INTEGER             NO-UNDO.
DEFINE VARIABLE cDataType                   AS CHARACTER           NO-UNDO.
DEFINE VARIABLE cTemp                       AS CHARACTER           NO-UNDO.
DEFINE VARIABLE h_SVisualObject             AS HANDLE              NO-UNDO.
DEFINE VARIABLE h_SQueryObject              AS HANDLE              NO-UNDO.
DEFINE VARIABLE i                           AS INTEGER             NO-UNDO.
DEFINE VARIABLE iDataType                   AS INTEGER             NO-UNDO.
DEFINE VARIABLE l_1stObjIsQueryObject       AS LOGICAL             NO-UNDO.
DEFINE VARIABLE l_2ndObjIsQueryObject       AS LOGICAL             NO-UNDO.

DEFINE VARIABLE is_enabled          AS LOGICAL                     NO-UNDO.
DEFINE VARIABLE is_errorFld         AS LOGICAL                     NO-UNDO.
DEFINE VARIABLE cblank              AS CHARACTER INITIAL " "       NO-UNDO.
DEFINE VARIABLE enableMark          AS CHARACTER INITIAL "e"       NO-UNDO.
DEFINE VARIABLE errorMark           AS CHARACTER INITIAL "*"       NO-UNDO.
DEFINE VARIABLE updatableMark       AS CHARACTER INITIAL "u"       NO-UNDO.

DEFINE TEMP-TABLE ttMismatch
   FIELD posLoc                 AS INTEGER        
   FIELD visualFld              AS CHARACTER      LABEL "Visual Object Fields"
   FIELD queryCol               AS CHARACTER      LABEL "Query Object Columns"
.
/* ******************************************************************** */

/* determine the type of object */
ASSIGN
   c_1stObjType = DYNAMIC-FUNCTION("getObjectType":U IN ph_1stObject) 
   c_2ndObjType = DYNAMIC-FUNCTION("getObjectType":U IN ph_2ndObject)
   l_1stObjIsQueryObject = DYNAMIC-FUNCTION("getQueryObject":U IN ph_1stObject) 
   l_2ndObjIsQueryObject = DYNAMIC-FUNCTION("getQueryObject":U IN ph_2ndObject)
   pl_objectsMatch = ?
   NO-ERROR.


/* 
 * querySmartBrowser = objectType = "smartDataBrowser" AND isQueryObject
 * 
 * NO Signature Check is not supported link : Data, Update
 * NO Signature Check 2 queryObjects, Data Link 
 *                    smartData->Data->smartData
 *                    smartData->Data->querySmartBrowser
 *                    querySmartBrowser->Data->smartData
 *                    querySmartBrowser->Data->querySmartBrowser
 * NO Signature Check if no queryObjects
 * NO Signature Check 1 querySmartBrowser 1 smartDataBrowser
 *                    querySmartBrowser->Data->smartDataBrowser
 */
IF (NOT CAN-DO("Data,Update,Filter":U,pc_link-type))
  OR
   (l_1stObjIsQueryObject AND
    l_2ndObjIsQueryObject AND
    pc_link-type = "Data":U)
  OR 
    (NOT (l_1stObjIsQueryObject OR l_2ndObjIsQueryObject)) 
  OR
   (c_1stObjType = "smartDataBrowser":U AND 
    c_2ndObjType = "smartDataBrowser":U AND
    (l_1stObjIsQueryObject OR
    l_2ndObjIsQueryObject))
THEN RETURN.


/* 
 * STRICT tt signature
 *        getDataSignature(queryObject) = getDataSignature(visualObject)
 *   smartData->Data->smartDataBrowser
 */
IF CAN-DO("Data":U,pc_link-type) AND
  ((c_1stObjType = "smartDataBrowser":U AND c_2ndObjType = "smartDataObject":U) OR
   (c_1stObjType = "smartDataObject":U        AND c_2ndObjType = "smartDataBrowser":U)) AND
   (NOT (l_1stObjIsQueryObject AND l_2ndObjIsQueryObject)) THEN
DO:

   ASSIGN 
      h_SQueryObject  =  IF l_1stObjIsQueryObject THEN 
                            ph_1stObject
                         ELSE 
                            ph_2ndObject
      h_SVisualObject =  IF l_1stObjIsQueryObject THEN 
                            ph_2ndObject
                         ELSE 
                            ph_1stObject
      c_VisualSignature = DYNAMIC-FUNCTION("getDataSignature":U IN h_SVisualObject)
      c_QuerySignature = DYNAMIC-FUNCTION("getDataSignature":U IN h_SQueryObject)
   NO-ERROR.
   /* If we get any kind of error or the answer is ? then there is no match */
   IF ERROR-STATUS:ERROR THEN ASSIGN pl_objectsMatch =  ?.
   /* If ? or "" then assume dynamic then leave as unknown */
   ELSE IF c_VisualSignature = ? OR  c_VisualSignature = "":U OR
        c_QuerySignature = ?  OR  c_QuerySignature = "":U
   THEN ASSIGN pl_objectsMatch =  ?.
   ELSE IF c_VisualSignature <> c_QuerySignature THEN
   DO:  /* NO */
      ASSIGN pl_objectsMatch = NO.

      /* Only if an advisor will be displayed will be attempt to check the fields */
      IF pl_details THEN
      DO:
         ASSIGN
             c_SQueryColumns  = DYNAMIC-FUNCTION("getDataColumns":U IN h_SQueryObject)
             c_SVisualColumns = DYNAMIC-FUNCTION("getDisplayedFields":U IN h_SVisualObject)
             pc_errorMsg       = "For a Temp-Table signature match, the temp-table definition "
                                + "in each object must be an exact match of each other "
                                + "(order, name and data type)."
                                + "The visual object contains the following field(s):"
         NO-ERROR.

         /****** Expand the visual fields  - adding order and data type */
         DO cnt = 1 TO NUM-ENTRIES(c_SVisualColumns):
            ASSIGN 
               cTemp = ENTRY(cnt,c_SVisualColumns)
               cDataType = SUBSTRING(c_VisualSignature,cnt,1).
            RUN adecomm/_datatyp.p (INPUT INTEGER(cDataType), OUTPUT cDataType).
            ASSIGN
               pc_errorMsg = pc_errorMsg + CHR(10) 
                             + "    ":U + STRING(cnt,">>>>9") + " ":U
                             + cTemp  + " ":U 
                             + cDataType.
         END. /* Visual Columns */
   
         ASSIGN pc_errorMsg = pc_errorMsg + CHR(10) + CHR(10)
                           + "The query object contains the following column(s):".
         /****** Expand the query columns  - adding order and data type */
         DO cnt = 1 TO NUM-ENTRIES(c_SQueryColumns):
            ASSIGN 
               cTemp = ENTRY(cnt,c_SQueryColumns)
               cDataType = SUBSTRING(c_QuerySignature,cnt,1).
            RUN adecomm/_datatyp.p (INPUT INTEGER(cDataType), OUTPUT cDataType).
            ASSIGN
               pc_errorMsg = pc_errorMsg + CHR(10) 
                             + "    ":U + STRING(cnt,">>>>9") + " ":U
                             + cTemp  + " ":U 
                             + cDataType.
         END. /* Query Columns */
      END. /* pl_details */
   END. /* NO */
   ELSE
   DO:  /* YES */
      ASSIGN pl_objectsMatch =  YES
             pc_errorMsg = "":U.
   END. /* YES */
   RETURN.
END. /* Strict signature check */


/*
 * LENIENT field exists signature
 *   getDisplayedColumns(visualObject) in getDataColumns(queryObject) 
 *
 *   smartData->Data->smartDataViewer   
 *   querySmartBrowser->Data->smartDataViewer   
 2yy*    
 *"SmartDataViewer vcust.w needs field(s) xxx, which SmartDataObject dcust.w
  cannot provide.".
 */
IF CAN-DO("Data,Filter":U,pc_link-type) AND
   (((CAN-DO("smartDataViewer,SmartFilter,SmartDataField":U,c_1stObjType)) AND 
     (CAN-DO("smartDataObject,smartDataBrowser":U,c_2ndObjType) AND 
      l_2ndObjIsQueryObject))
    OR
    ((CAN-DO("smartDataViewer,SmartFilter,SmartDataField":U,c_2ndObjType)) AND 
     (CAN-DO("smartDataObject,smartDataBrowser":U,c_1stObjType) AND 
      l_1stObjIsQueryObject))) THEN
DO:

   ASSIGN h_SQueryObject  =  IF l_1stObjIsQueryObject 
                             THEN ph_1stObject
                             ELSE ph_2ndObject
          h_SVisualObject =  IF l_1stObjIsQueryObject
                             THEN ph_2ndObject
                             ELSE ph_1stObject
          c_SQueryColumns  = DYNAMIC-FUNCTION("getDataColumns":U IN h_SQueryObject)
          c_SVisualColumns = DYNAMIC-FUNCTION("getDisplayedFields":U IN h_SVisualObject)
   NO-ERROR.
   
   IF ERROR-STATUS:ERROR THEN 
      ASSIGN pl_objectsMatch = ?.
   /* If ? or "" then assume dynamic then leave as unknown */
   ELSE IF c_SVisualColumns = "":U OR c_SVisualColumns = ? OR
           c_SQueryColumns = "":U  OR c_SQueryColumns = ? THEN
      ASSIGN pl_objectsMatch = ?.
   ELSE
   DO:
      ASSIGN pl_objectsMatch = YES.
      /* A visualization that does not use ANY queryObject fields 
       * still successfully matches a queryObject... meaning we can
       * still use that viewer with that queryObject
       */
      IF c_SVisualColumns <> "":U THEN
      DO cnt = 1 TO NUM-ENTRIES(c_SVisualColumns):
         cTemp = ENTRY(cnt,c_SVisualColumns).
         IF NOT CAN-DO(c_SQueryColumns,cTemp) THEN
         DO:
            ASSIGN pl_objectsMatch = NO.
            IF NOT pl_details THEN LEAVE.
         END. /* Can't find viewer field in DO */
      END. /* cycle through viewer fields */
      IF pl_objectsMatch = NO AND pl_details THEN
      DO:
         ASSIGN pc_errorMsg = 
            "For the Displayed-Field signature match, all the visual object's fields must be a subset of the query object's columns."
            + "The visual object needs field(s):".
         DO cnt = 1 TO NUM-ENTRIES(c_SVisualColumns):
            ASSIGN cTemp = ENTRY(cnt,c_SVisualColumns).
            IF NOT CAN-DO(c_SQueryColumns,cTemp) THEN
               ASSIGN    pc_errorMsg = pc_errorMsg + CHR(10) + "   ":U + cTemp. 
         END. /* VisualColumns */
         ASSIGN pc_errorMsg = pc_errorMsg + CHR(10) + 
           "which the query object cannot provide.".
      END. 
   END. /* No error or ? */
   RETURN.
END. /* Visualization / queryObject */


/*  
 * LENIENT enabled exists updatable signature
 *   getEnabledFlds(visualObject) in getUpdatableFlds(queryObject) 
 *
 *   smartDataViewer->Update->smartData
 *   smartDataBrowser->Update->smartData
 *   queryDataBrowser->Update->smartData
 */
IF CAN-DO("Update":U,pc_link-type) AND 
   ((c_1stObjType = "smartDataObject":U AND
    (CAN-DO("smartDataViewer,smartDataBrowser":U,c_2ndObjType)))
    OR
    (c_2ndObjType = "smartDataObject":U AND
    (CAN-DO("smartDataViewer,smartDataBrowser":U,c_1stObjType)))) THEN
DO:
    IF l_1stObjIsQueryObject AND l_2ndObjIsQueryObject THEN
    DO:
       IF c_1stObjType = "smartDataObject":U THEN
         ASSIGN h_SQueryObject  =  ph_1stObject
                h_SVisualObject =  ph_2ndObject
         .
      ELSE
         ASSIGN h_SQueryObject  =  ph_2ndObject
                h_SVisualObject =  ph_1stObject.
      .
    END.
    ELSE
      ASSIGN h_SQueryObject  =  IF l_1stObjIsQueryObject 
                             THEN ph_1stObject
                             ELSE ph_2ndObject
          h_SVisualObject =  IF l_1stObjIsQueryObject
                             THEN ph_2ndObject
                             ELSE ph_1stObject.

    ASSIGN
        c_updatableFlds = DYNAMIC-FUNCTION("getUpdatableColumns":U IN h_SQueryObject)
        c_EnabledFlds = DYNAMIC-FUNCTION("getEnabledFields":U IN h_SVisualObject)
      NO-ERROR.
      IF ERROR-STATUS:ERROR THEN
         ASSIGN  pl_objectsMatch = ?.
   /* If ? or "" then assume dynamic then leave as unknown */
      ELSE IF c_EnabledFlds   = "":U OR c_EnabledFlds   = ? OR
              c_UpdatableFlds = "":U OR c_UpdatableFlds = ? THEN 
         ASSIGN  pl_objectsMatch = ?.
      ELSE
      DO:
         /* A visualization that does not have ANY enabled fields 
          * still successfully matches a queryObject's updatable fields... 
          * meaning we can still use that viewer with that queryObject
          */
         IF c_EnabledFlds <> "":U THEN
         DO cnt = 1 TO NUM-ENTRIES(c_EnabledFlds):
            cTemp = ENTRY(cnt,c_EnabledFlds).
            IF NOT CAN-DO(c_updatableFlds,cTemp) THEN 
            DO: 
                ASSIGN pl_objectsMatch = NO.
                IF NOT pl_details THEN LEAVE.
            END.
         END.

         IF pl_objectsMatch = NO AND pl_details THEN
         DO:
            ASSIGN
               pc_errorMsg = "For a Enabled Field signature match all the Visual object's "
                            + "enabled fields must be a subset of the SmartDataObject's "
                            + "updatable columns." 
                            + CHR(10)
                            + "The visual object has the enabled field(s):".

         DO cnt = 1 TO NUM-ENTRIES(c_EnabledFlds):
            cTemp = ENTRY(cnt,c_EnabledFlds).
            IF NOT CAN-DO(c_updatableFlds,cTemp) THEN 
               ASSIGN pc_errorMsg = pc_errorMsg + CHR(10) + "   ":U + cTemp.
            END. /* VisualColumns */
         END.
            ASSIGN pc_errorMsg = pc_errorMsg + CHR(10) 
               + "which are not updatable in the SmartDataObject.":U.
         END.
  RETURN.
END. /* Update Link */ 

