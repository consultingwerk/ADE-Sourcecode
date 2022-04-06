/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* import for rycso */

DEFINE VARIABLE ip_export_file AS CHARACTER.
DEFINE VARIABLE ip_object_file AS CHARACTER.
DEFINE VARIABLE lv_tablename AS CHARACTER.
DEFINE STREAM str-import.
DEFINE STREAM str-objects.

ASSIGN
  ip_export_file = SESSION:TEMP-DIRECTORY + "export\export.d"
  ip_object_file = SESSION:TEMP-DIRECTORY + "export\export.o"
  .

{af/sup2/afglobals.i}

RUN rv/prc/rvutlimptp.p (INPUT ip_object_file) NO-ERROR.
{af/sup2/afcheckerr.i}

MESSAGE "test".

RUN delete-RYCSO-objects NO-ERROR.
{af/sup2/afcheckerr.i}

RETURN.
/* 
RUN doTheImport NO-ERROR.
{af/sup2/afcheckerr.i}
*/

PROCEDURE doTheImport:                      
    INPUT STREAM str-import FROM VALUE(ip_export_file).

    IMPORT STREAM str-import lv_tablename.

    import-blk:
    REPEAT:

    txn-blk:    
        DO TRANSACTION ON ERROR UNDO, RETURN ERROR RETURN-VALUE:
            REPEAT:
                CASE lv_tablename:
                    WHEN "ryc_smartobject"       THEN DO: CREATE ryc_smartobject.       IMPORT STREAM str-import ryc_smartobject.       END.
                    WHEN "ryc_object_instance"   THEN DO: CREATE ryc_object_instance.   IMPORT STREAM str-import ryc_object_instance.   END.
                    WHEN "ryc_attribute_value"   THEN DO: CREATE ryc_attribute_value.   IMPORT STREAM str-import ryc_attribute_value.   END.
                    WHEN "ryc_page"              THEN DO: CREATE ryc_page.              IMPORT STREAM str-import ryc_page.              END.
                    WHEN "ryc_smartlink"         THEN DO: CREATE ryc_smartlink.         IMPORT STREAM str-import ryc_smartlink.         END.
                END CASE.

                IMPORT STREAM str-import lv_tablename.
                IF lv_tablename = "eof" THEN LEAVE import-blk.
                IF lv_tablename = "ryc_smartobject" THEN LEAVE txn-blk.
            END.

        END.


    END.

    /* our work is done */

    INPUT STREAM str-import CLOSE.
    MESSAGE "Done." VIEW-AS ALERT-BOX.
END PROCEDURE.

PROCEDURE delete-RYCSO-objects:
    DEFINE VARIABLE lv_object_name AS CHARACTER NO-UNDO.
    INPUT STREAM str-objects FROM VALUE( ip_object_file ).
    REPEAT:
        IMPORT STREAM str-objects ^ lv_object_name.
        FIND FIRST ryc_smartobject WHERE object_filename = lv_object_name EXCLUSIVE-LOCK NO-ERROR.
        IF AVAILABLE(ryc_smartobject) THEN
        DO: 
            MESSAGE "deleting " lv_object_name.
/*             {af/sup/afvalidtrg.i &ACTION=DELETE &TABLE=ryc_smartobject} */
        END.
        ELSE MESSAGE "not deleting " lv_object_name.
    END.
    INPUT STREAM str-objects CLOSE.

END PROCEDURE.
