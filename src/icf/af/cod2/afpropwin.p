DEFINE INPUT  PARAMETER pcObject                AS CHARACTER                NO-UNDO.
DEFINE INPUT  PARAMETER pdObjectInstance        AS DECIMAL                  NO-UNDO.
DEFINE INPUT  PARAMETER pcSdoname               AS CHARACTER                NO-UNDO.
DEFINE INPUT  PARAMETER plReturnedChangesOnly   AS LOGICAL                  NO-UNDO.
DEFINE OUTPUT PARAMETER pcAttributeLabels       AS CHARACTER                NO-UNDO.
DEFINE OUTPUT PARAMETER pcAttributeValues       AS CHARACTER                NO-UNDO.

DEFINE VARIABLE cWindow          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cProc            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hObj             AS HANDLE     NO-UNDO.
DEFINE VARIABLE cWin             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iProc            AS CHAR       NO-UNDO.
DEFINE VARIABLE cFile            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cWinContext      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cSmoContext      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cSdoContext      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hSmart           AS HANDLE     NO-UNDO.
DEFINE VARIABLE hSdo             AS HANDLE     NO-UNDO.
DEFINE VARIABLE iLoop            AS INTEGER    NO-UNDO.
DEFINE VARIABLE dSmartObject     AS DECIMAL    INITIAL ? NO-UNDO.

DEFINE VARIABLE cOldPropertyList AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cNewPropertyList AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cOldProperty     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cOldValue        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cNewProperty     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cNewValue        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cNewAttribList   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cNewValueList    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cPhysicalName    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cLogicalName     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cSdoPhysicalName AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cSdoLogicalName  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cCustomProc      AS CHARACTER  NO-UNDO.

{src/adm2/globals.i}

ASSIGN
  cWindow = SEARCH("af/cod2/afprpwind.w").

IF cWindow = ? THEN
  ASSIGN
    cWindow = SEARCH("af/cod2/afprpwind.r").
  
  IF pcObject <> "":U THEN
  DO: 
    RUN getObjectNames IN gshRepositoryManager
      (INPUT  pcObject, 
       OUTPUT cPhysicalName, 
       OUTPUT cLogicalName).
    FIND FIRST gsc_object NO-LOCK
      WHERE gsc_object.object_filename = pcObject
      NO-ERROR.
    
    IF AVAILABLE gsc_object THEN
    FIND FIRST ryc_smartObject 
      WHERE ryc_smartObject.object_obj = gsc_object.object_obj
      NO-LOCK NO-ERROR.

    FIND FIRST ryc_object_instance WHERE
               ryc_object_instance.object_instance_obj = pdObjectInstance
               NO-LOCK NO-ERROR.
    IF AVAILABLE ryc_object_instance THEN
        ASSIGN dSmartObject = ryc_object_instance.object_instance_obj.
    ELSE
    IF AVAILABLE ryc_smartobject THEN
        ASSIGN dSmartObject = ryc_smartobject.smartobject_obj.
  END.

  IF pcSdoName <> "":U THEN
  DO:
      RUN getObjectNames IN gshRepositoryManager ( INPUT  pcSdoName,
                                                   OUTPUT cSdoPhysicalName,
                                                   OUTPUT cSdoLogicalName).
  END.

  IF SEARCH(cPhysicalName) = ? AND SEARCH(REPLACE(cPhysicalName,".w":U,".r":U)) = ? THEN 
    RETURN ERROR "No object exists for ":U + pcObject.
  IF dSmartObject = ? THEN RETURN ERROR "No repository records exist for ":U + pcObject.
  
  IF pcSdoName <> "":U AND 
     SEARCH(cSdoPhysicalName) = ? AND 
     SEARCH(REPLACE(cSdoPhysicalName,".w":U,".r":U)) = ? THEN 
    RETURN ERROR "No SDO object exists for ":U + pcSdoName.
   
  { launch.i 
      &PLIP  = 'ry/app/ryreposobp.p'
      &IProc = 'fetchAttributeValues'
      &PList = "( INPUT dSmartObject, OUTPUT cOldPropertyList)"
  } 
  {afcheckerr.i}            
  
  RUN adeuib/_open-w.p (cWindow,'','open').
  RUN adeuib/_uibinfo.p(?,'WINDOW ?','HANDLE', OUTPUT cWin).
  hObj = WIDGET-HANDLE(cWin) NO-ERROR.
  hObj:HIDDEN = TRUE.
  RUN adeuib/_uibinfo.p(?,?,'file-name', OUTPUT cFile).
  RUN adeuib/_uibinfo.p(?,?,'CONTEXT', OUTPUT cWinContext).

  hObj = WIDGET-HANDLE(cWin) NO-ERROR.
  hObj:HIDDEN = TRUE.

  IF cSdoPhysicalName <> "":U THEN
  RUN adeuib/_uib_crt.p
    (INTEGER(cWinContext),
    'SmartObject',
    'SmartObject: ' + cSdoPhysicalName,
    0,0,0,0,
    OUTPUT cSdoContext).
  
  RUN adeuib/_uib_crt.p
    (INTEGER(cWinContext),
    'SmartObject',
    'SmartObject: ' + cPhysicalName,
    0,0,0,0,
    OUTPUT cSmoContext).
  

  RUN adeuib/_uibinfo.p(INT(cSmoContext),?,'procedure-handle', OUTPUT cProc).
  ASSIGN
    hSmart = WIDGET-HANDLE(cProc).
  
  IF cSdoContext <> "":U THEN DO:
    RUN adeuib/_uibinfo.p(INT(cSdoContext),?,'procedure-handle', OUTPUT cProc).
    ASSIGN
      hSdo = WIDGET-HANDLE(cProc).
  END.

  IF VALID-HANDLE(hSmart) THEN DO:
  
    DYNAMIC-FUNCTION("setUserProperty":U IN hSmart, "EditSingleInstance":U, "YES":U).

    IF cOldPropertyList <> "" THEN
        RUN setAttributesInObject IN gshSessionManager( INPUT hSmart, INPUT cOldPropertyList) NO-ERROR.
    ELSE 
      ASSIGN 
        cOldPropertyList = DYNAMIC-FUNCTION("instancePropertyList":U IN hSmart, "":U) NO-ERROR.

    DYNAMIC-FUNCTION ("setLogicalObjectName":U IN hSmart , cLogicalName).

    RUN editInstanceProperties IN hSmart.

    ASSIGN
      cNewPropertyList = DYNAMIC-FUNCTION("instancePropertyList":U IN hSmart, "":U) 
      cNewPropertyList = REPLACE(cNewPropertyList,CHR(4),CHR(3)) NO-ERROR.
  END.

  DO iLoop = 1 TO NUM-ENTRIES(cOldPropertyList,CHR(3)):

    ASSIGN
      cOldProperty = ENTRY(iLoop,cOldPropertyList,CHR(3))
      cOldValue    = ENTRY(2,cOldProperty,CHR(4))
      cOldProperty = ENTRY(1,cOldProperty,CHR(4))
      .
    /* Ignore LogicalObjectName */
    IF cOldProperty EQ "LogicalObjectName":U THEN NEXT.

    IF LOOKUP(cOldProperty,cNewPropertyList,CHR(3)) > 0 THEN
      ASSIGN
        cNewValue    = ENTRY(1 + LOOKUP(cOldProperty,cNewPropertyList,CHR(3)),cNewPropertyList,CHR(3)).
    ELSE
      ASSIGN
        cNewValue = cOldValue.

     IF (plReturnedChangesOnly AND cOldValue <> cNewValue) OR
        NOT plReturnedChangesOnly THEN
        ASSIGN
          cNewAttribList = cNewAttribList + ",":U WHEN cNewAttribList <> ""
          cNewValueList  = cNewValueList  + CHR(3) WHEN cNewAttribList <> ""
          cNewAttribList = cNewAttribList + cOldProperty
          cNewValueList  = cNewValueList  + cNewValue.
  END.
     
  IF VALID-HANDLE(hObj) THEN 
  DO:
    /* tell the AppBuilder that it is saved so we avoid the save yes-no-cancel*/
    RUN adeuib/_winsave.p(hObj,YES).
    APPLY 'window-close' TO hObj.
  END.

  ASSIGN pcAttributeLabels = cNewAttribList
         pcAttributeValues = cNewValueList
         .
  RETURN.
  /* EOF */
