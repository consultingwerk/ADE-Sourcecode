/* fixgscmtobjfields.p
   This procedure takes the object_obj field off the gsm_required_manager field and uses it to
   populate the manager type's smartobject_obj field.
    
   It does this ny populating a temp-table (ttManager) with a list of all the managers that are
   used and then determining which is most frequently used to populate the gsc_manager_type table */

DEFINE TEMP-TABLE ttManager NO-UNDO
  FIELD cManagerType  AS CHARACTER FORMAT "X(25)":U
  FIELD dManagerObj   AS DECIMAL
  FIELD cFileName     AS CHARACTER FORMAT "X(25)":U
  FIELD dSMOObj       AS DECIMAL
  FIELD lDBBound      AS LOGICAL  LABEL "Bound"
  FIELD iHitCount     AS INTEGER  LABEL "Hits" FORMAT ">>9":U
  INDEX pudx IS  PRIMARY UNIQUE
    dManagerObj
    lDBBound
    dSMOObj
  INDEX dx 
    dManagerObj
    lDBBound
    iHitCount DESCENDING
  .

/* To determine whether the manager in gsm_required_manager is bound or not, we need to look at the 
   run_local session property. This section looks up the session_property_obj of the run_local property
   so that we can cache it and not read it repeatedly. */
DEFINE VARIABLE dRunLocalObj  AS DECIMAL NO-UNDO.
DO FOR gsc_session_property:
  FIND FIRST gsc_session_property NO-LOCK
    WHERE gsc_session_property.session_property_name = "run_local":U
    NO-ERROR.

  IF NOT AVAILABLE(gsc_session_property) THEN
  DO:
    PUBLISH "DCU_WriteLog":U ("** ERROR: run_local property not found in session property table. Terminating procedure.").
    RETURN ERROR "** ERROR: run_local property not found in session property table. Terminating procedure.".
  END.

  ASSIGN
    dRunLocalObj = gsc_session_property.session_property_obj
  .
END.

/* This function figures out whether a session type is bound or not. It does so by checking the run_local
   property on the current session type or any of its parents. */
FUNCTION isSessionTypeBound 
  RETURNS LOGICAL
  (INPUT pdObj AS DECIMAL,
   INPUT plRunLocal AS LOGICAL):
  
  DEFINE BUFFER   bgsm_session_type FOR gsm_session_type.
  DEFINE VARIABLE lRunLocal         AS LOGICAL    NO-UNDO.

  FIND FIRST bgsm_session_type NO-LOCK
    WHERE bgsm_session_type.session_type_obj = pdObj
    NO-ERROR.

  IF NOT AVAILABLE(bgsm_session_type) THEN
    RETURN FALSE.

  IF plRunLocal = ? THEN
  DO:
    FIND FIRST gsm_session_type_property NO-LOCK
      WHERE gsm_session_type_property.session_type_obj = bgsm_session_type.session_type_obj
        AND gsm_session_type_property.session_property_obj = dRunLocalObj
      NO-ERROR.
    IF AVAILABLE(gsm_session_type_property) THEN
    DO: 
      IF (gsm_session_type_property.property_value = "YES":U OR gsm_session_type_property.property_value = "TRUE":U) THEN
        lRunLocal = TRUE.
      ELSE
        lRunLocal = FALSE.
    END.
    ELSE
      lRunLocal = ?.
  END.
  ELSE
    lRunLocal = plRunLocal.

  IF lRunLocal = YES THEN
    RETURN TRUE.
    
  IF bgsm_session_type.extends_session_type_obj <> 0.0 AND
     bgsm_session_type.extends_session_type_obj <> ?   THEN
    RETURN isSessionTypeBound(bgsm_session_type.extends_session_type_obj, lRunLocal).
  
  RETURN FALSE.
END.


/* This section loops through all the session types, determines whether the session type is bound or not, 
   obtains the list of managers for the session type and adds them to the ttManager temp-table */
DEFINE VARIABLE isBound   AS LOGICAL    NO-UNDO.
FOR EACH gsm_session_type NO-LOCK:
  
  /* We skip ICFDEVAS because the session type is a problem. */
  IF gsm_session_type.session_type_code = "ICFDEVAS" THEN
    NEXT.

  isBound = isSessionTypeBound(gsm_session_type.session_type_obj, ?). 
  PUBLISH "DCU_WriteLog":U ("  Session Type: ":U + gsm_session_type.session_type_code + "   Bound: ":U + STRING(isBound,"YES/NO":U)).
  
  FOR EACH gsm_required_manager NO-LOCK
    WHERE gsm_required_manager.session_type_obj = gsm_session_type.session_type_obj:

    FIND FIRST ryc_smartobject NO-LOCK
      WHERE ryc_smartobject.smartobject_obj = gsm_required_manager.object_obj
      NO-ERROR.
    
    IF NOT AVAILABLE(ryc_smartobject) THEN
      NEXT.
    
    FIND FIRST gsc_manager_type NO-LOCK
      WHERE gsc_manager_type.manager_type_obj = gsm_required_manager.manager_type_obj
      NO-ERROR.
    
    IF NOT AVAILABLE(gsc_manager_type) THEN
      NEXT.

    FIND FIRST ttManager 
      WHERE ttManager.dManagerObj = gsc_manager_type.manager_type_obj
        AND ttManager.lDBBound    = isBound
        AND ttManager.dSMOObj     = gsm_required_manager.object_obj
      NO-ERROR.
    IF NOT AVAILABLE(ttManager) THEN
    DO:
      CREATE ttManager.
      ASSIGN
        ttManager.cManagerType = gsc_manager_type.manager_type_code
        ttManager.dManagerObj  = gsc_manager_type.manager_type_obj
        ttManager.cFileName    = ryc_smartobject.object_filename
        ttManager.dSMOObj      = gsm_required_manager.object_obj
        ttManager.lDBBound     = isBound
        ttManager.iHitCount    = 1
      .
    END.
    ELSE
    DO:
      ASSIGN
        ttManager.iHitCount = ttManager.iHitCount + 1
      .
    END.

  END.
END.


/* The following section loops through the ttManager records and writes the first of each bound break group
   to the gsc_manager_type table and lists all managers to the log file. */
PUBLISH "DCU_WriteLog":U ("  MANAGER LIST").

DEFINE BUFFER bgsc_manager_type FOR gsc_manager_type.
DISABLE TRIGGERS FOR LOAD OF bgsc_manager_type.
DISABLE TRIGGERS FOR DUMP OF bgsc_manager_type.
DEFINE VARIABLE lStored   AS LOGICAL    NO-UNDO.

FOR EACH ttManager 
  BREAK BY dManagerObj 
        BY lDBBound 
        BY iHitCount:

  IF FIRST-OF(ttManager.lDBBound) THEN
  DO FOR bgsc_manager_type TRANSACTION:
    FIND bgsc_manager_type EXCLUSIVE-LOCK
      WHERE bgsc_manager_type.manager_type_obj = ttManager.dManagerObj.
    IF ttManager.lDBBound THEN
    DO:
      ASSIGN
        bgsc_manager_type.db_bound_smartobject_obj = ttManager.dSMOObj
      .
    END.
    ELSE
    DO:
      ASSIGN
        bgsc_manager_type.db_unbound_smartobject_obj = ttManager.dSMOObj
      .
    END.
    lStored = YES.
  END.
  ELSE
    lStored = NO.
  
  PUBLISH "DCU_WriteLog":U ("    " + STRING(lStored,"*/ ") + "Manager: ":U + ttManager.cManagerType + "   Object: ":U + ttManager.cFileName 
                            + "   DBBound: " + STRING(ttManager.lDBBound,"Yes/No":U) + "   Hits: " + STRING(iHitCount)).
END.


    

