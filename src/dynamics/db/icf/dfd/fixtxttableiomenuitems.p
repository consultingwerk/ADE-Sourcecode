/* Fix program to replace txttabliook and txttableiocancel items on any 
   bands with txtok and txtcancel.  It then deletes txttableiook and 
   txttableiocancel.   */

DEFINE VARIABLE cMessage AS CHARACTER  NO-UNDO.

DEFINE BUFFER bItem FOR gsm_menu_item.

  FIND gsm_menu_item WHERE gsm_menu_item.MENU_item_reference = 'txttableiook':U EXCLUSIVE-LOCK NO-ERROR.
  FIND bItem WHERE bItem.MENU_item_reference = 'txtok':U NO-LOCK NO-ERROR.
  IF AVAIL gsm_menu_item AND AVAIL bItem THEN 
  DO:
    FOR EACH gsm_menu_structure_item WHERE 
        gsm_menu_structure_item.MENU_item_obj = gsm_menu_item.MENU_item_obj EXCLUSIVE-LOCK:
        ASSIGN gsm_menu_structure_item.MENU_item_obj = bItem.MENU_item_obj NO-ERROR.
        FIND gsm_menu_structure WHERE gsm_menu_structure.MENU_structure_obj = gsm_menu_structure_item.MENU_structure_obj NO-LOCK NO-ERROR.
        cMessage = 'txttableiook changed to txtok on band: ':U + 
                    IF AVAIL gsm_menu_structure THEN gsm_menu_structure.MENU_structure_code
                    ELSE STRING(gsm_menu_structure_item.MENU_structure_obj).
        PUBLISH 'DCU_WriteLog':U (cMessage).
    END.  /* for each menu structure item */
    DELETE gsm_menu_item NO-ERROR.
  END.  /* if avail menu items */
    
  FIND gsm_menu_item WHERE gsm_menu_item.MENU_item_reference = 'txttableiocancel':U EXCLUSIVE-LOCK NO-ERROR.
  FIND bItem WHERE bItem.MENU_item_reference = 'txtcancel':U NO-LOCK NO-ERROR.
  IF AVAIL gsm_menu_item AND AVAIL bItem THEN 
  DO:
    FOR EACH gsm_menu_structure_item WHERE 
        gsm_menu_structure_item.MENU_item_obj = gsm_menu_item.MENU_item_obj EXCLUSIVE-LOCK:
        ASSIGN gsm_menu_structure_item.MENU_item_obj = bItem.MENU_item_obj NO-ERROR.
        FIND gsm_menu_structure WHERE gsm_menu_structure.MENU_structure_obj = gsm_menu_structure_item.MENU_structure_obj NO-LOCK NO-ERROR.
        cMessage = 'txttableiocancel changed to txtcancel on band: ':U + 
                    IF AVAIL gsm_menu_structure THEN gsm_menu_structure.MENU_structure_code
                    ELSE STRING(gsm_menu_structure_item.MENU_structure_obj).
        PUBLISH 'DCU_WriteLog':U (cMessage).
    END.  /* for each menu structure item */
    DELETE gsm_menu_item NO-ERROR.
  END.  /* if avail menu items */
    
  RETURN.
