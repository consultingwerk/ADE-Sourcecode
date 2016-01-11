/* fixTreeStructures.p 
 * This program will move all the data stored in run_attribute and
 * fields_to_store that were related to creating a Structured TreeView 
 * MA Davies - 06/03/2003 
 * Should be run after standard migration 
 * Could be run multiple times on both old and new data */

/* This program will do the following:
   Scan all TreeNodes where the gsm_node.run_attribute is 
   equal to 'STRUCTURED' and move the data in the fields_to_store
   field out to the newly created fields to hold this information
   */

PUBLISH "DCU_WriteLog":U ("--- Starting Dynamic TreeView Structure data Convertion":U).

FOR EACH gsm_node
    WHERE gsm_node.run_attribute = "STRUCTURED":U
    AND   gsm_node.fields_to_store <> "":U
    EXCLUSIVE-LOCK:
  ASSIGN gsm_node.structured_node    = TRUE
         gsm_node.run_attribute      = "":U
         gsm_node.parent_node_filter = ENTRY(1,gsm_node.fields_to_store,"^":U)
         gsm_node.parent_field       = IF NUM-ENTRIES(gsm_node.fields_to_store,"^":U) >= 2 THEN ENTRY(2,gsm_node.fields_to_store,"^":U) ELSE "":U
         gsm_node.child_field        = IF NUM-ENTRIES(gsm_node.fields_to_store,"^":U) >= 3 THEN ENTRY(3,gsm_node.fields_to_store,"^":U) ELSE "":U
         gsm_node.data_type          = IF NUM-ENTRIES(gsm_node.fields_to_store,"^":U) >= 4 THEN ENTRY(4,gsm_node.fields_to_store,"^":U) ELSE "":U
         gsm_node.fields_to_store    = "":U.
         
END.
PUBLISH "DCU_WriteLog":U ("--- Dynamic TreeView Structure data Convertion Complete":U).

RETURN.

