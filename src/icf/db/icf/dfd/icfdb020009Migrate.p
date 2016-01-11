
/* This noddy is to be run after applying icfdb020009delta.df - After .ADO update */

/* Overridew the triggers */
DISABLE TRIGGERS FOR LOAD OF ryc_smartobject.               DISABLE TRIGGERS FOR DUMP OF ryc_smartobject.

/* Include the NextObj Fuction */
FUNCTION getNextObj RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

DEFINE TEMP-TABLE ttCustom  NO-UNDO
    FIELD tfRycsoSmartobjectObj       AS DECIMAL
    FIELD tfRycsoObjectObj            AS DECIMAL
    FIELD tfRycsoObjectFilename       AS CHARACTER
    FIELD tfRycsoObjectExt            AS CHARACTER
    FIELD tfRycsoCustomSuperProcedure AS CHARACTER
    FIELD tfCustomObjectName          AS CHARACTER
    FIELD tfCustomObjectPath          AS CHARACTER
    FIELD tfRycsoCustomSmartobjectObj AS DECIMAL
    .

DEFINE STREAM streamOut.

/*------------------------------------------------------------------------------
  MAIN BLOCK
------------------------------------------------------------------------------*/

RUN updateCustomSmartobject.

/*------------------------------------------------------------------------------
  INTERNAL PROCEDURES
------------------------------------------------------------------------------*/

PROCEDURE updateCustomSmartobject:
/*-----------------------------------------------------------------------*/
/* Purpose: Update and correct the ryc_smartobject values                */
/*  Notes:                                                               */
/*-----------------------------------------------------------------------*/

  DEFINE VARIABLE dRycsoSmartobjectObj  AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dCustomSmartobjectObj AS DECIMAL    NO-UNDO.

  DEFINE VARIABLE cCustomObjects        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCustomOutput         AS CHARACTER  NO-UNDO.

  DEFINE BUFFER b_ryc_smartobject       FOR ryc_smartobject.

  EMPTY TEMP-TABLE ttCustom.

  ASSIGN
    cCustomObjects  = "customobjects.tmp"
    cCustomOutput   = "customoutput.tmp"
    .

  ASSIGN
    cCustomObjects = SEARCH(cCustomObjects).
    
  PUBLISH "DCU_WriteLog":U ("Updating custom objects...").
  
  IF cCustomObjects <> ?
  THEN DO:

    FILE-INFO:FILE-NAME = cCustomObjects.
    IF FILE-INFO:FILE-SIZE > 0
    THEN DO:

      INPUT STREAM streamOut FROM VALUE(cCustomObjects).
      PUBLISH "DCU_WriteLog":U ("  Reading input from " + cCustomObjects).

      REPEAT:

        CREATE ttCustom.
        IMPORT STREAM streamOut
          ttCustom.tfRycsoSmartobjectObj
          ttCustom.tfRycsoObjectObj
          ttCustom.tfRycsoObjectFilename
          ttCustom.tfRycsoObjectExt
          ttCustom.tfRycsoCustomSuperProcedure
          ttCustom.tfCustomObjectName
          ttCustom.tfCustomObjectPath
          ttCustom.tfRycsoCustomSmartobjectObj
          .

      END.

      INPUT STREAM streamOut CLOSE.

    END.

  END.
  ELSE
      PUBLISH "DCU_WriteLog":U ("  **Unable to find file customobjects.tmp").    

  OUTPUT STREAM streamOut TO VALUE(cCustomOutput).

  customBlock:
  FOR EACH ttCustom EXCLUSIVE-LOCK:

    IF ttCustom.tfRycsoSmartobjectObj = 0
    THEN NEXT customBlock.

    RUN findRycsmartobject (INPUT  ttCustom.tfRycsoSmartobjectObj
                           ,INPUT  ttCustom.tfRycsoObjectObj
                           ,INPUT  ttCustom.tfRycsoObjectFilename
                           ,INPUT  ttCustom.tfRycsoObjectExt
                           ,OUTPUT dRycsoSmartobjectObj
                           ).

    FIND FIRST b_ryc_smartobject EXCLUSIVE-LOCK
      WHERE b_ryc_smartobject.smartobject_obj = dRycsoSmartobjectObj
      NO-ERROR.
    IF dRycsoSmartobjectObj = 0
    OR NOT AVAILABLE b_ryc_smartobject
    THEN NEXT customBlock.

    PUBLISH "DCU_WriteLog":U ("  Updating object " + ttCustom.tfRycsoObjectFilename).    

    RUN findRycsmartobject (INPUT  ttCustom.tfRycsoCustomSmartobjectObj
                           ,INPUT  ttCustom.tfRycsoCustomSmartobjectObj
                           ,INPUT  ttCustom.tfCustomObjectName
                           ,INPUT  "":U
                           ,OUTPUT dCustomSmartobjectObj
                           ).

    IF dCustomSmartobjectObj = 0
    THEN DO:

      FIND gsc_object_type NO-LOCK
        WHERE gsc_object_type.object_type_code = "PROCEDURE":U
        NO-ERROR.

      FIND FIRST gsc_product_module NO-LOCK
        WHERE gsc_product_module.relative_path = ttCustom.tfCustomObjectPath
        NO-ERROR.

      CREATE ryc_smartobject.
      ASSIGN
        /* EXISTING */
        ryc_smartobject.smartobject_obj           = getNextObj()
        ryc_smartobject.object_filename           = ttCustom.tfCustomObjectName
        ryc_smartobject.object_description        = "Custom procedure for " + ttCustom.tfRycsoObjectFilename
        ryc_smartobject.object_type_obj           = (IF AVAILABLE gsc_object_type    THEN gsc_object_type.object_type_obj       ELSE 0)
        ryc_smartobject.product_module_obj        = (IF AVAILABLE gsc_product_module THEN gsc_product_module.product_module_obj ELSE 0)
        ryc_smartobject.object_path               = (IF AVAILABLE gsc_product_module THEN gsc_product_module.relative_path      ELSE ttCustom.tfCustomObjectPath)
        ryc_smartobject.object_extension          = "":U
        ryc_smartobject.run_when                  = "":U
        ryc_smartobject.shutdown_message_text     = "":U
        ryc_smartobject.deployment_type           = "":U
        ryc_smartobject.required_db_list          = "":U
        ryc_smartobject.system_owned              = YES
        ryc_smartobject.static_object             = YES
        ryc_smartobject.run_persistent            = YES
        ryc_smartobject.runnable_from_menu        = NO
        ryc_smartobject.container_object          = NO
        ryc_smartobject.generic_object            = NO
        ryc_smartobject.design_only               = NO
        ryc_smartobject.template_smartobject      = NO
        ryc_smartobject.disabled                  = NO
        ryc_smartobject.security_smartobject_obj  = 0
        ryc_smartobject.physical_smartobject_obj  = 0
        ryc_smartobject.customization_result_obj  = 0
        ryc_smartobject.custom_smartobject_obj    = 0
        ryc_smartobject.extends_smartobject_obj   = 0
        ryc_smartobject.sdo_smartobject_obj       = 0
        ryc_smartobject.layout_obj                = 0
        .
      ASSIGN
        dCustomSmartobjectObj                     = ryc_smartobject.smartobject_obj
        ryc_smartobject.security_smartobject_obj  = ryc_smartobject.smartobject_obj
        .

    END.

    FIND FIRST ryc_smartobject NO-LOCK
      WHERE ryc_smartobject.smartobject_obj = dCustomSmartobjectObj
      NO-ERROR.
    IF AVAILABLE ryc_smartobject
    THEN DO:
      ASSIGN
        b_ryc_smartobject.custom_smartobject_obj  = ryc_smartobject.smartobject_obj
        ttCustom.tfRycsoCustomSmartobjectObj      = ryc_smartobject.smartobject_obj
        .
    END.
    ELSE DO:

      ASSIGN
        b_ryc_smartobject.custom_smartobject_obj  = 0
        ttCustom.tfRycsoCustomSmartobjectObj      = 0
        .
      PUBLISH "DCU_WriteLog":U 
      ("  Smartobject: " + b_ryc_smartobject.object_filename + " / ":U 
       + ttCustom.tfRycsoObjectFilename + " / ":U + ttCustom.tfRycsoObjectExt
       + "   SO Obj: " + STRING(ttCustom.tfRycsoSmartobjectObj) + " / ":U + STRING(ttCustom.tfRycsoObjectObj)
       + "   **ERROR Custom Procedure Object Record not Available"
       + "   Super Proc: " + ttCustom.tfRycsoCustomSuperProcedure + " / ":U + ttCustom.tfCustomObjectName 
       + " / ":U + ttCustom.tfCustomObjectPath
       + "   Custom SO Obj: " + STRING(b_ryc_smartobject.custom_smartobject_obj) + " / ":U 
       + STRING(ttCustom.tfRycsoCustomSmartobjectObj)
       ).
    END.

    EXPORT STREAM streamOut
      ttCustom.tfRycsoSmartobjectObj
      ttCustom.tfRycsoObjectObj
      ttCustom.tfRycsoObjectFilename
      ttCustom.tfRycsoObjectExt
      ttCustom.tfRycsoCustomSuperProcedure
      ttCustom.tfCustomObjectName
      ttCustom.tfCustomObjectPath
      ttCustom.tfRycsoCustomSmartobjectObj
      .

  END.

  OUTPUT STREAM streamOut CLOSE.

  FOR EACH ryc_smartobject EXCLUSIVE-LOCK:

    /* Ensure the new obj field values is not null */
    ASSIGN
      ryc_smartobject.custom_smartobject_obj    = (IF ryc_smartobject.custom_smartobject_obj    = ? THEN 0 ELSE ryc_smartobject.custom_smartobject_obj)
      .

  END.

END PROCEDURE. /* updateCustomSmartobject */



PROCEDURE findRycsmartobject:
/*------------------------------------------------------------------------------
  Purpose:  determine if a ryc_smartobject or gsc_object record is available
            depending on the passed in values
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE INPUT  PARAMETER ipcRycsmartobjectObj    AS DECIMAL              NO-UNDO.
  DEFINE INPUT  PARAMETER ipcGscObjectObj         AS DECIMAL              NO-UNDO.
  DEFINE INPUT  PARAMETER ipcGscObjectName        AS CHARACTER            NO-UNDO.
  DEFINE INPUT  PARAMETER ipcGscObjectExt         AS CHARACTER            NO-UNDO.
  DEFINE OUTPUT PARAMETER opcRycObjectObj         AS DECIMAL              NO-UNDO.

  DEFINE BUFFER pb_ryc_smartobject     FOR ryc_smartobject.

  ASSIGN
    opcRycObjectObj = 0.

  IF opcRycObjectObj = 0
  AND ipcRycsmartobjectObj <> 0
  THEN DO:
    FIND FIRST pb_ryc_smartobject NO-LOCK
      WHERE pb_ryc_smartobject.smartobject_obj = ipcRycsmartobjectObj
      NO-ERROR.
    IF AVAILABLE pb_ryc_smartobject
    THEN
      ASSIGN
        opcRycObjectObj = pb_ryc_smartobject.smartobject_obj.
  END.

  IF opcRycObjectObj = 0
  AND TRIM(ipcGscObjectName) <> "":U
  THEN DO:
    FIND FIRST pb_ryc_smartobject NO-LOCK
      WHERE pb_ryc_smartobject.object_filename = TRIM(ipcGscObjectName)
      NO-ERROR.
    IF AVAILABLE pb_ryc_smartobject
    THEN
      ASSIGN
        opcRycObjectObj = pb_ryc_smartobject.smartobject_obj.
  END.

  IF opcRycObjectObj = 0
  AND TRIM(ipcGscObjectName) <> "":U
  AND TRIM(ipcGscObjectName) <> "":U
  THEN DO:
    FIND FIRST pb_ryc_smartobject NO-LOCK
      WHERE pb_ryc_smartobject.object_filename = TRIM(ipcGscObjectName,".":U) + "." + TRIM(ipcGscObjectExt,".":U)
      NO-ERROR.
    IF AVAILABLE pb_ryc_smartobject
    THEN
      ASSIGN
        opcRycObjectObj = pb_ryc_smartobject.smartobject_obj.
  END.

  IF opcRycObjectObj = 0
  AND ipcGscObjectObj <> 0
  THEN DO:
    FIND FIRST pb_ryc_smartobject NO-LOCK
      WHERE pb_ryc_smartobject.smartobject_obj = ipcGscObjectObj
/*
  The object_obj field does not exist any more, so check the object_obj value against the smartobject_obj field instead
      WHERE pb_ryc_smartobject.object_obj = ipcGscObjectObj
*/
      NO-ERROR.
    IF AVAILABLE pb_ryc_smartobject
    THEN
      ASSIGN
        opcRycObjectObj = pb_ryc_smartobject.smartobject_obj.
  END.

END PROCEDURE.



/*------------------------------------------------------------------------------
  FUNCTIONS
------------------------------------------------------------------------------*/

FUNCTION getNextObj RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  To return the next available unique object number.
    Notes:  
------------------------------------------------------------------------------*/

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
    iSessnId    = CURRENT-VALUE(seq_session_id,ICFDB)
    .

  IF iSeqObj1 = 0
  THEN
    ASSIGN
      iSeqObj2 = NEXT-VALUE(seq_obj2,ICFDB).

  ASSIGN
    dSeqNext = DECIMAL((iSeqObj2 * 1000000000.0) + iSeqObj1)
    .

  IF  iSeqSiteDiv <> 0
  AND iSeqSiteRev <> 0
  THEN
    ASSIGN
      dSeqNext = dSeqNext + (iSeqSiteRev / iSeqSiteDiv).

  RETURN dSeqNext. /* Function return value */

END FUNCTION.
