
/* This noddy is to be run after applying icfdb020009delta.df */

DEFINE VARIABLE lDeleteRecord       AS LOGICAL    NO-UNDO.

DEFINE VARIABLE cScmChecksOn        AS LOGICAL    NO-UNDO.

DEFINE VARIABLE cObjectPath         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cObjectBase         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cObjectExt          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cObjectName         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cObjectType         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iObjectLoop         AS INTEGER    NO-UNDO.

DEFINE BUFFER b_gsc_product_module  FOR gsc_product_module.
DEFINE BUFFER b_ryc_smartobject     FOR ryc_smartobject.

DISABLE TRIGGERS FOR LOAD OF gsc_security_control.  DISABLE TRIGGERS FOR DUMP OF gsc_security_control.
DISABLE TRIGGERS FOR LOAD OF gsc_entity_mnemonic.   DISABLE TRIGGERS FOR DUMP OF gsc_entity_mnemonic.

ASSIGN
  cScmChecksOn = NO.

/* OVERRIDE SCM checks */
FIND FIRST gsc_security_control EXCLUSIVE-LOCK
  NO-ERROR.
IF AVAILABLE gsc_security_control
THEN DO:
  ASSIGN
    cScmChecksOn = gsc_security_control.scm_checks_on.
  ASSIGN
    gsc_security_control.scm_checks_on = NO.
END.

/* Entity Mnemonic - FIX */
/* Set unknown values to NO in the version_data field */
RUN runEntity (INPUT YES  /* UPD */
              ,INPUT ?    /* OLD */
              ,INPUT NO   /* NEW */
              ).

/* Entity Mnemonic - OVERRIDE BEGIN */
/* Set YES values temparory to ? in the version_data field */
RUN runEntity (INPUT YES  /* UPD */
              ,INPUT YES  /* OLD */
              ,INPUT ?    /* NEW */
              ).

/* Delete the RVDB logical services and the allocations to the session types  */
FOR EACH gsc_logical_service EXCLUSIVE-LOCK
  WHERE gsc_logical_service.logical_service_code BEGINS "RVDB"
  :
  FOR EACH gsm_session_service EXCLUSIVE-LOCK
    WHERE gsm_session_service.logical_service_obj = gsc_logical_service.logical_service_obj
    :
    FIND FIRST gsm_physical_service EXCLUSIVE-LOCK
      WHERE gsm_physical_service.physical_service_obj = gsm_session_service.physical_service_obj
      NO-ERROR.
    IF AVAILABLE gsm_physical_service
    THEN
       DELETE gsm_physical_service.
     DELETE gsm_session_service.
  END.
   DELETE gsc_logical_service.
END.

/* Delete the RVDB physical services and the allocations to the session types  */
FOR EACH gsm_physical_service EXCLUSIVE-LOCK
  WHERE gsm_physical_service.physical_service_code BEGINS "RVDB"
  :
  FOR EACH gsm_session_service EXCLUSIVE-LOCK
    WHERE gsm_session_service.physical_service_obj = gsm_physical_service.physical_service_obj
    :
     DELETE gsm_session_service.
  END.
   DELETE gsm_physical_service.
END.

/* Clean out RVDB Object and Data */

/* 1 = gsc_product */
FOR EACH gsc_product EXCLUSIVE-LOCK
  WHERE gsc_product.product_code BEGINS "090RV"
  :

  /* 1 = gsc_product : 2 = gsc_product_module */
  FOR EACH gsc_product_module EXCLUSIVE-LOCK
    WHERE gsc_product_module.product_obj = gsc_product.product_obj
    :

    /* 1 = gsc_product : 2 = gsc_product_module : 3 = b_ryc_smartobject */
    FOR EACH b_ryc_smartobject EXCLUSIVE-LOCK
      WHERE b_ryc_smartobject.product_module_obj = gsc_product_module.product_module_obj
      :

      RUN deleteRycSmartObject (INPUT b_ryc_smartobject.smartobject_obj).

    END.
    /* 1 = gsc_product : 2 = gsc_product_module : 3 = b_ryc_smartobject */

    /* 1 = gsc_product : 2 = gsc_product_module  : 3 = gsm_menu_item */
    FOR EACH gsm_menu_item EXCLUSIVE-LOCK
      WHERE gsm_menu_item.product_module_obj = gsc_product_module.product_module_obj
      :

      /* 1 = gsc_product : 2 = gsc_product_module : 3 = gsm_menu_item : 4 = gsm_object_menu_structure */
      FOR EACH gsm_object_menu_structure EXCLUSIVE-LOCK
        WHERE gsm_object_menu_structure.menu_item_obj = gsm_menu_item.menu_item_obj
        :

         DELETE gsm_object_menu_structure.

      END.
      /* 1 = gsc_product : 2 = gsc_product_module : 3 = gsm_menu_item : 4 = gsm_object_menu_structure */

      /* 1 = gsc_product : 2 = gsc_product_module : 3 = gsm_menu_item : 4 = gsm_menu_structure_item */
      FOR EACH gsm_menu_structure_item EXCLUSIVE-LOCK
        WHERE gsm_menu_structure_item.menu_item_obj = gsm_menu_item.menu_item_obj
        :

         DELETE gsm_menu_structure_item.

      END.
      /* 1 = gsc_product : 2 = gsc_product_module : 3 = gsm_menu_item : 4 = gsm_menu_structure_item */

       DELETE gsm_menu_item.

    END.
    /* 1 = gsc_product : 2 = gsc_product_module  : 3 = gsm_menu_item */

    /* 1 = gsc_product : 2 = gsc_product_module : 3 = gsm_security_structure */
    FOR EACH gsm_security_structure EXCLUSIVE-LOCK
      WHERE gsm_security_structure.product_module_obj = gsc_product_module.product_module_obj
      :

       DELETE gsm_security_structure.

    END.
    /* 1 = gsc_product : 2 = gsc_product_module : 3 = gsm_security_structure */

    /* 1 = gsc_product : 2 = gsc_product_module  : 3 = gsm_menu_structure */
    FOR EACH gsm_menu_structure EXCLUSIVE-LOCK
      WHERE gsm_menu_structure.product_module_obj = gsc_product_module.product_module_obj
      :

      /* 1 = gsc_product : 2 = gsc_product_module : 3 = gsm_menu_structure : 4 = gsm_toolbar_menu_structure */
      FOR EACH gsm_toolbar_menu_structure EXCLUSIVE-LOCK
        WHERE gsm_toolbar_menu_structure.menu_structure_obj = gsm_menu_structure.menu_structure_obj
        :

         DELETE gsm_toolbar_menu_structure.

      END.
      /* 1 = gsc_product : 2 = gsc_product_module : 3 = gsm_menu_structure : 4 = gsm_toolbar_menu_structure */

      /* 1 = gsc_product : 2 = gsc_product_module : 3 = gsm_menu_structure : 4 = gsm_object_menu_structure */
      FOR EACH gsm_object_menu_structure EXCLUSIVE-LOCK
        WHERE gsm_object_menu_structure.menu_structure_obj = gsm_menu_structure.menu_structure_obj
        :

         DELETE gsm_object_menu_structure.

      END.
      /* 1 = gsc_product : 2 = gsc_product_module : 3 = gsm_menu_structure : 4 = gsm_object_menu_structure */

      /* 1 = gsc_product : 2 = gsc_product_module : 3 = gsm_menu_structure : 4 = gsm_menu_structure_item (parent) */
      FOR EACH gsm_menu_structure_item EXCLUSIVE-LOCK
        WHERE gsm_menu_structure_item.menu_structure_obj = gsm_menu_structure.menu_structure_obj
        :

         DELETE gsm_menu_structure_item.

      END.
      /* 1 = gsc_product : 2 = gsc_product_module : 3 = gsm_menu_structure : 4 = gsm_menu_structure_item (parent) */

      /* 1 = gsc_product : 2 = gsc_product_module : 3 = gsm_menu_structure : 4 = gsm_menu_structure_item (child) */
      FOR EACH gsm_menu_structure_item EXCLUSIVE-LOCK
        WHERE gsm_menu_structure_item.child_menu_structure_obj = gsm_menu_structure.menu_structure_obj
        :

         DELETE gsm_menu_structure_item.

      END.
      /* 1 = gsc_product : 2 = gsc_product_module : 3 = gsm_menu_structure : 4 = gsm_menu_structure_item (child) */

       DELETE gsm_menu_structure.

    END.
    /* 1 = gsc_product : 2 = gsc_product_module  : 3 = gsm_menu_structure */

     DELETE gsc_product_module.

  END.
  /* 1 = gsc_product : 2 = gsc_product_module */

  /* 1 = gsc_product : 2 = gsm_menu_structure */
  FOR EACH gsm_menu_structure EXCLUSIVE-LOCK
    WHERE gsm_menu_structure.product_obj = gsc_product.product_obj
    :

    /* 1 = gsc_product : 2 = gsm_menu_structure : 3 = gsm_toolbar_menu_structure */
    FOR EACH gsm_toolbar_menu_structure EXCLUSIVE-LOCK
      WHERE gsm_toolbar_menu_structure.menu_structure_obj = gsm_menu_structure.menu_structure_obj
      :

       DELETE gsm_toolbar_menu_structure.

    END.
    /* 1 = gsc_product : 2 = gsm_menu_structure : 3 = gsm_toolbar_menu_structure */

    /* 1 = gsc_product : 2 = gsm_menu_structure : 3 = gsm_object_menu_structure */
    FOR EACH gsm_object_menu_structure EXCLUSIVE-LOCK
      WHERE gsm_object_menu_structure.menu_structure_obj = gsm_menu_structure.menu_structure_obj
      :

       DELETE gsm_object_menu_structure.

    END.
    /* 1 = gsc_product : 2 = gsm_menu_structure : 3 = gsm_object_menu_structure */

    /* 1 = gsc_product : 2 = gsm_menu_structure : 3 = gsm_menu_structure_item (parent) */
    FOR EACH gsm_menu_structure_item EXCLUSIVE-LOCK
      WHERE gsm_menu_structure_item.menu_structure_obj = gsm_menu_structure.menu_structure_obj
      :

       DELETE gsm_menu_structure_item.

    END.
    /* 1 = gsc_product : 2 = gsm_menu_structure : 3 = gsm_menu_structure_item (parent) */

    /* 1 = gsc_product : 2 = gsm_menu_structure : 3 = gsm_menu_structure_item (child) */
    FOR EACH gsm_menu_structure_item EXCLUSIVE-LOCK
      WHERE gsm_menu_structure_item.child_menu_structure_obj = gsm_menu_structure.menu_structure_obj
      :

       DELETE gsm_menu_structure_item.

    END.
    /* 1 = gsc_product : 2 = gsm_menu_structure : 3 = gsm_menu_structure_item (child) */

     DELETE gsm_menu_structure.
  END.
  /* 1 = gsc_product : 2 = gsm_menu_structure */

   DELETE gsc_product.

END.
/* 1 = gsc_product */

/* 1 = b_ryc_smartobject */
FOR EACH b_ryc_smartobject EXCLUSIVE-LOCK
  WHERE b_ryc_smartobject.object_filename BEGINS "rv"
  :

  RUN deleteRycSmartObject (INPUT b_ryc_smartobject.smartobject_obj).

END.
/* 1 = b_ryc_smartobject */

/* Entity Mnemonic - OVERRIDE END */
/* Set ? values back to YES in the version_data field */
RUN runEntity (INPUT YES  /* UPD */
              ,INPUT ?    /* OLD */
              ,INPUT YES  /* NEW */
              ).

/* OVERRIDE SCM checks */
FIND FIRST gsc_security_control EXCLUSIVE-LOCK
  NO-ERROR.
IF AVAILABLE gsc_security_control
THEN DO:
  ASSIGN
    gsc_security_control.scm_checks_on = cScmChecksOn.
  ASSIGN
    cScmChecksOn = NO.
END.

/***********************/
/* INTERNAL PROCEDURES */
/***********************/

PROCEDURE deleteRycSmartObject:

  DEFINE INPUT PARAMETER dRycSmartObjectObj  AS DECIMAL NO-UNDO.

  /* 1 = ryc_smartobject */
  FOR EACH ryc_smartobject EXCLUSIVE-LOCK
    WHERE ryc_smartobject.smartobject_obj = dRycSmartObjectObj
    :

    /* 1 = ryc_smartobject : 2 = gsm_menu_item */
    FOR EACH gsm_menu_item EXCLUSIVE-LOCK
      WHERE gsm_menu_item.object_obj = ryc_smartobject.smartobject_obj
      :

      /* 1 = ryc_smartobject : 2 = gsm_menu_item : 3 = gsm_object_menu_structure */
      FOR EACH gsm_object_menu_structure EXCLUSIVE-LOCK
        WHERE gsm_object_menu_structure.menu_item_obj = gsm_menu_item.menu_item_obj
        :

         DELETE gsm_object_menu_structure.

      END.
      /* 1 = ryc_smartobject : 2 = gsm_menu_item : 3 = gsm_object_menu_structure */

      /* 1 = ryc_smartobject : 2 = gsm_menu_item : 3 = gsm_menu_structure_item */
      FOR EACH gsm_menu_structure_item EXCLUSIVE-LOCK
        WHERE gsm_menu_structure_item.menu_item_obj = gsm_menu_item.menu_item_obj
        :

         DELETE gsm_menu_structure_item.

      END.
      /* 1 = ryc_smartobject : 2 = gsm_menu_item : 3 = gsm_menu_structure_item */

       DELETE gsm_menu_item.

    END.
    /* 1 = ryc_smartobject : 2 = gsm_menu_item */

    /* 1 = ryc_smartobject : 2 = gsm_object_menu_structure */
    FOR EACH gsm_object_menu_structure EXCLUSIVE-LOCK
      WHERE gsm_object_menu_structure.object_obj = ryc_smartobject.smartobject_obj
      :

       DELETE gsm_object_menu_structure.

    END.
    /* 1 = ryc_smartobject : 2 = gsm_object_menu_structure */

    /* 1 = ryc_smartobject : 2 = gsm_toolbar_menu_structure */
    FOR EACH gsm_toolbar_menu_structure EXCLUSIVE-LOCK
      WHERE gsm_toolbar_menu_structure.object_obj = ryc_smartobject.smartobject_obj
      :

       DELETE gsm_toolbar_menu_structure.

    END.
    /* 1 = ryc_smartobject : 2 = gsm_toolbar_menu_structure */

    /* 1 = ryc_smartobject : 2 = gsm_security_structure */
    FOR EACH gsm_security_structure EXCLUSIVE-LOCK
      WHERE gsm_security_structure.object_obj = ryc_smartobject.smartobject_obj
      :

       DELETE gsm_security_structure.

    END.
    /* 1 = ryc_smartobject : 2 = gsm_security_structure */

    /* 1 = ryc_smartobject : 2 = ryc_smartlink */
    FOR EACH ryc_smartlink EXCLUSIVE-LOCK
      WHERE ryc_smartlink.container_smartobject_obj = ryc_smartobject.smartobject_obj
      :

       DELETE ryc_smartlink.

    END.
    /* 1 = ryc_smartobject : 2 = ryc_smartlink */

    /* 1 = ryc_smartobject : 2 = ryc_page */
    FOR EACH ryc_page EXCLUSIVE-LOCK
      WHERE ryc_page.container_smartobject_obj = ryc_smartobject.smartobject_obj
      :

      /* 1 = ryc_smartobject : 2 = ryc_page : 3 = ryc_page_object */
      FOR EACH ryc_page_object EXCLUSIVE-LOCK
        WHERE ryc_page_object.page_obj                  = ryc_page.page_obj
        AND   ryc_page_object.container_smartobject_obj = ryc_page.container_smartobject_obj
        :

         DELETE ryc_page_object.

      END.
      /* 1 = ryc_smartobject : 2 = ryc_page : 3 = ryc_page_object */

       DELETE ryc_page.

    END.
    /* 1 = ryc_smartobject : 2 = ryc_page */

    /* 1 = ryc_smartobject : 2 = ryc_object_instance */
    FOR EACH ryc_object_instance EXCLUSIVE-LOCK
      WHERE ryc_object_instance.container_smartobject_obj = ryc_smartobject.smartobject_obj
      :

      /* 1 = ryc_smartobject : 2 = ryc_object_instance : 3 = ryc_page_object */
      FOR EACH ryc_page_object EXCLUSIVE-LOCK
        WHERE ryc_page_object.page_obj                  = ryc_object_instance.object_instance_obj
        AND   ryc_page_object.container_smartobject_obj = ryc_object_instance.container_smartobject_obj
        :

         DELETE ryc_page_object.
      /* 1 = ryc_smartobject : 2 = ryc_object_instance : 3 = ryc_page_object */

      END.

       DELETE ryc_object_instance.

    END.
    /* 1 = ryc_smartobject : 2 = ryc_object_instance */

    /* 1 = ryc_smartobject : 2 = ryc_object_instance */
    FOR EACH ryc_object_instance EXCLUSIVE-LOCK
      WHERE ryc_object_instance.smartobject_obj = ryc_smartobject.smartobject_obj
      :

       DELETE ryc_object_instance.

    END.
    /* 1 = ryc_smartobject : 2 = ryc_object_instance */

    /* 1 = ryc_smartobject : 2 = ryc_attribute_value */
    FOR EACH ryc_attribute_value EXCLUSIVE-LOCK
      WHERE ryc_attribute_value.container_smartobject_obj = ryc_smartobject.smartobject_obj
      :

       DELETE ryc_attribute_value.

    END.
    /* 1 = ryc_smartobject : 2 = ryc_attribute_value */

    /* 1 = ryc_smartobject : 2 = ryc_attribute_value */
    FOR EACH ryc_attribute_value EXCLUSIVE-LOCK
      WHERE ryc_attribute_value.primary_smartobject_obj = ryc_smartobject.smartobject_obj
      :

       DELETE ryc_attribute_value.

    END.
    /* 1 = ryc_smartobject : 2 = ryc_attribute_value */

    /* 1 = ryc_smartobject : 2 = ryc_attribute_value */
    FOR EACH ryc_attribute_value EXCLUSIVE-LOCK
      WHERE ryc_attribute_value.smartobject_obj = ryc_smartobject.smartobject_obj
      :

       DELETE ryc_attribute_value.

    END.
    /* 1 = ryc_smartobject : 2 = ryc_attribute_value */

    ASSIGN
      cObjectExt          = TRIM(ryc_smartobject.object_extension)
      cObjectBase         = TRIM(ryc_smartobject.object_filename)
      cObjectName         = TRIM(ryc_smartobject.object_filename)
      .

    IF NUM-ENTRIES(ryc_smartobject.object_filename,".":U) > 1
    THEN DO:
      IF ryc_smartobject.object_extension = "":U
      AND LENGTH(ENTRY(NUM-ENTRIES(ryc_smartobject.object_filename,".":U),ryc_smartobject.object_filename,".":U)) < 4
      THEN
        ASSIGN
          cObjectExt  = TRIM( ENTRY(NUM-ENTRIES(ryc_smartobject.object_filename ,".":U),ryc_smartobject.object_filename,".":U) ).
      ASSIGN
        cObjectBase = TRIM( SUBSTRING(ryc_smartobject.object_filename , 1 , R-INDEX(cObjectName,".":U) - 1) ).
    END.

   
   /* Fix for Issue 5661 */ 
   IF ryc_smartobject.object_path <> "":U THEN 
     cObjectPath = ryc_smartobject.object_path.
   ELSE IF AVAILABLE(gsc_product_module) THEN
     cObjectPath = gsc_product_module.relative_path.
   ELSE
     cObjectPath = "":U.
     
   ASSIGN
     cObjectPath = REPLACE(cObjectPath,"~\":U,"~/":U)
     cObjectPath = TRIM(cObjectPath,"~/":U) + "~/":U.

    ASSIGN
      cObjectType  = "":U  /* Look for empty extensions in case */
           + ",":U + (IF cObjectExt <> "":U THEN ".":U + cObjectExt ELSE "":U)
           + ",":U + ".r":U
           + ",":U + ".p":U
           + ",":U + ".w":U
           + ",":U + ".i":U
           + ",":U + ".ado":U
           + ",":U + "_cl":U /* Look for empty extensions in case */
           + ",":U + "_cl":U + (IF cObjectExt <> "":U THEN ".":U + cObjectExt ELSE "":U)
           + ",":U + "_cl.r":U
           + ",":U + "_cl.p":U
           + ",":U + "_cl.w":U
           + ",":U + "_cl.i":U
           + ",":U + "_cl.ado":U
           .

     DELETE ryc_smartobject.

    DO iObjectLoop = 1 TO NUM-ENTRIES(cObjectType):

      ASSIGN
        cObjectName = cObjectPath + cObjectBase + ENTRY(iObjectLoop,cObjectType).

      
      IF SEARCH(cObjectName) <> ?
      THEN
        OS-DELETE VALUE( SEARCH(cObjectName) ).

    END.

  END.
  /* 1 = ryc_smartobject */

END PROCEDURE.

PROCEDURE runEntity:

  DEFINE INPUT PARAMETER lUpd     AS LOGICAL NO-UNDO.
  DEFINE INPUT PARAMETER lOld     AS LOGICAL NO-UNDO.
  DEFINE INPUT PARAMETER lNew     AS LOGICAL NO-UNDO.

  FOR EACH gsc_entity_mnemonic EXCLUSIVE-LOCK
    :

    IF gsc_entity_mnemonic.version_data = lOld
    THEN DO:
      IF lUpd
      THEN
        ASSIGN
          gsc_entity_mnemonic.version_data = lNew.
    END.

    IF gsc_entity_mnemonic.auditing_enabled = lOld
    THEN DO:
      IF lUpd
      THEN
        ASSIGN
          gsc_entity_mnemonic.auditing_enabled = lNew.
    END.

  END.

END PROCEDURE.
