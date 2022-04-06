FUNCTION getRequiredPropertyValues RETURNS CHARACTER (pcProperties AS CHARACTER, pcPropsWithValues AS CHARACTER, pcObjectType AS CHARACTER) FORWARD.

  DEFINE INPUT  PARAMETER phContainerBuilder    AS HANDLE     NO-UNDO.
  DEFINE INPUT  PARAMETER pcObject              AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcInstanceName        AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcSdoname             AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER plReturnedChangesOnly AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER pcSdoInstanceName     AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcAttributeLabels     AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcAttributeValues     AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE cOldPropertyList AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNewPropertyList AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNewAttribList   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNewValueList    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPhysicalName    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNewProperty     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cOldProperty     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLogicalName     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCustomProc      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cWinContext      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSmoContext      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNewValue        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cOldValue        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cWindow          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cProc            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFile            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cWin             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAttributeValue  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSDOProperty     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSdoPropertyList AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iLoop            AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hSmart           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hObj             AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hSdo             AS HANDLE     NO-UNDO.

  {src/adm2/globals.i}


  cWindow = SEARCH("af/cod2/afprpwind.w":U).

  IF cWindow = ? THEN
    cWindow = SEARCH("af/cod2/afprpwind.r":U).

  IF pcObject <> "":U THEN
    RUN getObjectNames IN gshRepositoryManager (INPUT  pcObject, 
                                                INPUT  "":U,        /* pcRunAttribute */
                                                OUTPUT cPhysicalName, 
                                                OUTPUT cLogicalName).

  IF pcSdoName <> "":U THEN
  DO:
    RUN startDataObject IN gshRepositoryManager (INPUT pcSDOName, OUTPUT hSDO).

    IF NOT VALID-HANDLE(hSDO) THEN 
      RETURN ERROR "No SDO/SBO object exists for ":U + pcSdoName.

    DYNAMIC-FUNCTION("setObjectName":U IN hSDO, DYNAMIC-FUNCTION("getLogicalObjectName":U IN hSDO)).

    /* If this is a DataView then we need to set the
       BusinessEntity and DataTable attributes for its instance in order to 
       maintain instance attributes for objects linked to it.  */
    IF {fnarg instanceOf 'DataView':U hSDO} THEN
    DO:

      /* Destroy the DataView, so that we can set the pertinent information. */
      {fn destroyView hSDO}.
          
      RUN getAttributeList IN phContainerBuilder (INPUT pcSdoInstanceName, OUTPUT cSdoPropertyList).

      DO iLoop = 1 TO NUM-ENTRIES(cSdoPropertyList, CHR(3)):
        cSDOProperty     = ENTRY(iLoop, cSdoPropertyList, CHR(3)).
        
        IF ENTRY(1, cSDOProperty, CHR(4)) = "BusinessEntity":U THEN
        DO:
          cAttributeValue = ENTRY(2, cSDOProperty, CHR(4)).
          {set BusinessEntity cAttributeValue hSDO}.
        END.

        IF ENTRY(1, cSDOProperty, CHR(4)) = "DataTable":U THEN
        DO:
          cAttributeValue = ENTRY(2, cSDOProperty, CHR(4)).
          {set DataTable cAttributeValue hSDO}.
        END.

      END.  /* do iLoop */

      /* Now construct the DataView again. */
      run createObjects in hSDO.
    END.  /* if dataview */

  END.

  IF SEARCH(cPhysicalName) = ? AND SEARCH(REPLACE(cPhysicalName, ".w":U, ".r":U)) = ? THEN 
    RETURN ERROR "No object exists for ":U + pcObject.

  IF cPhysicalName = ? THEN
    RETURN ERROR "No repository records exist for ":U + pcObject.

  RUN getAttributeList IN phContainerBuilder (INPUT pcInstanceName, 
                                              OUTPUT cOldPropertyList).


  /* Call using OPEN-NOEDIT to prevent the file from opening in OpenEdge Architect. */
  RUN adeuib/_open-w.p (INPUT cWindow,
                        INPUT "":U,
                        INPUT "OPEN-NOEDIT":U).
  RUN adeuib/_uibinfo.p (INPUT  ?,
                         INPUT  "WINDOW ?":U,
                         INPUT  "HANDLE":U,
                         OUTPUT cWin).
  ASSIGN
      hObj        = WIDGET-HANDLE(cWin)
      hObj:HIDDEN = TRUE.
      
  /* Set this Property so that we can use this from the AppBuilder to disregard any prompting for links etc. */
  hObj:PRIVATE-DATA = "DynamicsGenericPropSheet":U.

  RUN adeuib/_uibinfo.p (INPUT  ?,
                         INPUT  ?,
                         INPUT  "FILE-NAME":U,
                         OUTPUT cFile).
  RUN adeuib/_uibinfo.p (INPUT  ?,
                         INPUT  ?,
                         INPUT  "CONTEXT":U,
                         OUTPUT cWinContext).

  ASSIGN
      hObj        = WIDGET-HANDLE(cWin)
      hObj:HIDDEN = TRUE.

  RUN adeuib/_uib_crt.p (INPUT  INTEGER(cWinContext),
                         INPUT  "SmartObject":U,
                         INPUT  "SmartObject: ":U + cPhysicalName,
                         INPUT  0,
                         INPUT  0,
                         INPUT  0,
                         INPUT  0,
                         OUTPUT cSmoContext).

  RUN adeuib/_uibinfo.p (INPUT  INTEGER(cSmoContext),
                         INPUT  ?,
                         INPUT  "PROCEDURE-HANDLE":U,
                         OUTPUT cProc).

  hSmart = WIDGET-HANDLE(cProc).

  /* If the SmartObject is a Dynamic SmartBusinessObject, the AppBuilder code above
     initializes the object before we have a chance to set the LogicalObjectName.
     Without this, the Dynamic SmartBusinessObject cannot - and was not initialized.
     Set the property then and re-attempt the intialization of the SBO */
  IF {fn getObjectType        hSmart} = "SmartBusinessObject":U AND
     {fn getObjectInitialized hSmart} = FALSE                   THEN
  DO:
    {set LogicalObjectName cLogicalName hSmart}.

    RUN initializeObject IN hSmart.
  END.

  /* Set a user property in the SDO to show that it is contained within an SBO,
     so that the property sheet knows what fields to disable/enable          */
  IF {fn getObjectType hSmart} = "SmartDataObject":U THEN
    IF {fnarg getUserProperty '"dataContainer"' phContainerBuilder} = "YES":U THEN 
      {fnarg setUserProperty "'ContainerObject', 'SmartBusinessObject'" hSmart}.
      

  IF VALID-HANDLE(hSmart) THEN
  DO:
    IF VALID-HANDLE(hSDO) THEN
    DO:
      {fnarg setUserProperty "'DataSource', STRING(hSDO)" hSmart}.
    
      IF {fn getObjectType hSmart} MATCHES "*toolbar*":U AND
         {fn getObjectType hSDO}   =       "SmartBusinessObject":U THEN
        RUN addLink IN hSmart (hSmart, 'Navigation':U, hSDO).
    END.

    DYNAMIC-FUNCTION("setUserProperty":U IN hSmart, "EditSingleInstance":U, "YES":U).

    cOldPropertyList = getRequiredPropertyValues(DYNAMIC-FUNCTION("instancePropertyList":U IN hSmart, "":U),
                                                 cOldPropertyList, 
                                                 DYNAMIC-FUNCTION("getObjectType":U IN hSmart)).
    IF cOldPropertyList <> "":U THEN
      RUN setAttributesInObject IN gshSessionManager( INPUT hSmart,
                                                      INPUT cOldPropertyList) NO-ERROR.
    ELSE 
      cOldPropertyList = DYNAMIC-FUNCTION("instancePropertyList":U IN hSmart, "":U) NO-ERROR.

    DYNAMIC-FUNCTION ("setLogicalObjectName":U IN hSmart , cLogicalName).

    RUN editInstanceProperties IN hSmart.

    ASSIGN
      cNewPropertyList = DYNAMIC-FUNCTION("instancePropertyList":U IN hSmart, "":U)
      cNewPropertyList = REPLACE(cNewPropertyList, CHR(4), CHR(3)) NO-ERROR.

    IF VALID-HANDLE(hSDO) THEN
      RUN destroyObject IN hSDO.
  END.

  DO iLoop = 1 TO NUM-ENTRIES(cOldPropertyList, CHR(3)):
    ASSIGN
        cOldProperty = ENTRY(iLoop, cOldPropertyList, CHR(3))
        cOldValue    = ENTRY(2, cOldProperty, CHR(4))
        cOldProperty = ENTRY(1, cOldProperty, CHR(4)).

    /* Ignore LogicalObjectName */
    IF cOldProperty = "LogicalObjectName":U THEN NEXT.

    IF LOOKUP(cOldProperty, cNewPropertyList, CHR(3)) > 0 THEN
      cNewValue = ENTRY(1 + LOOKUP(cOldProperty, cNewPropertyList, CHR(3)), cNewPropertyList, CHR(3)).
    ELSE
      cNewValue = cOldValue.

    IF (plReturnedChangesOnly = TRUE       AND
        cOldValue            <> cNewValue) OR
        plReturnedChangesOnly = FALSE      THEN
      ASSIGN
          cNewAttribList = cNewAttribList + ",":U WHEN cNewAttribList <> ""
          cNewValueList  = cNewValueList  + CHR(3) WHEN cNewAttribList <> ""
          cNewAttribList = cNewAttribList + cOldProperty
          cNewValueList  = cNewValueList  + cNewValue.
  END.

  IF VALID-HANDLE(hObj) THEN 
  DO:
    /* Tell the AppBuilder that it is saved so we avoid the save yes-no-cancel */
    RUN adeuib/_winsave.p(INPUT hObj,
                          INPUT YES).

    APPLY "WINDOW-CLOSE":U TO hObj.
  END.

  ASSIGN
      pcAttributeLabels = cNewAttribList
      pcAttributeValues = cNewValueList.

  RETURN.

FUNCTION getRequiredPropertyValues RETURNS CHARACTER (pcProperties AS CHARACTER,
                                                      pcPropsWithValues AS CHARACTER, 
                                                      pcObjectType AS CHARACTER):
  DEFINE VARIABLE cRequiredValues AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cProperty       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iCounter        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iLookup         AS INTEGER    NO-UNDO.

  IF pcObjectType = "SmartDataObject":U OR LOOKUP(pcObjectType, {fnarg getClassChildrenFromDB 'SDO':U gshRepositoryManager}) <> 0 THEN
    IF LOOKUP("DataColumns":U, pcProperties) = 0 THEN
      pcProperties = pcProperties + (IF pcProperties = "":U THEN "":U ELSE CHR(3)) + "DataColumns":U + CHR(4).

  ASSIGN
      pcPropsWithValues = REPLACE(pcPropsWithValues, CHR(4), CHR(3))
      pcProperties      = REPLACE(pcProperties,      CHR(4), CHR(3)) NO-ERROR.

  DO iCounter = 1 TO NUM-ENTRIES(pcProperties, CHR(3)) BY 2:
    ASSIGN
      cProperty       = ENTRY(iCounter, pcProperties, CHR(3))
      iLookup         = LOOKUP(cProperty, pcPropsWithValues, CHR(3)).

    /* Check if the property is already listed - if so, then do not create an entry for it again */
    IF INDEX(cRequiredValues, CHR(4)) <> 0 THEN
      IF LOOKUP(cProperty, REPLACE(cRequiredValues, CHR(4), CHR(3)), CHR(3)) <> 0 THEN 
        NEXT.

    cRequiredValues = cRequiredValues + (IF cRequiredValues = "" THEN "" ELSE CHR(3))
                    + cProperty + CHR(4)
                    + (IF iLookup <> 0 THEN ENTRY(iLookup + 1, pcPropsWithValues, CHR(3)) ELSE ENTRY(iCounter + 1, pcProperties, CHR(3))).
  END.

  RETURN cRequiredValues.
  
END FUNCTION.
