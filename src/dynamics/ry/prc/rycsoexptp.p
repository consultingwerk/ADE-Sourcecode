/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
DEFINE STREAM str-export.
DEFINE STREAM str-object.

OUTPUT STREAM str-export TO VALUE( SESSION:TEMP-DIRECTORY + "EXPORT\EXPORT.d.").
OUTPUT STREAM str-object TO VALUE( SESSION:TEMP-DIRECTORY + "EXPORT\EXPORT.o.").
RUN recur-rycso(0).
PUT STREAM str-export "eof" SKIP.
OUTPUT STREAM str-export CLOSE.

PROCEDURE recur-rycso:
    DEFINE INPUT PARAM ip_obj AS DECIMAL.

    FOR EACH ryc_smartobject 
        WHERE ryc_smartobject.sdo_smartobject_obj = ip_obj:

        /* export the object definition */

        FIND FIRST gsc_product_module WHERE gsc_product_module.product_module_obj = ryc_smartobject.product_module_obj.                                    
        EXPORT STREAM str-object "RYCSO" ryc_smartobject.OBJECT_filename ryc_smartobject.OBJECT_filename "LSmartObject" gsc_product_module.product_module_code.

        /* export the object itself */

        RUN export-rycso(BUFFER ryc_smartobject).               
        FOR EACH ryc_page WHERE ryc_page.container_smartobject_obj = ryc_smartobject.smartobject_obj: 
            RUN export-rycpa(BUFFER ryc_page). 
        END.
        FOR EACH ryc_object_instance WHERE ryc_object_instance.container_smartobject_obj = ryc_smartobject.smartobject_obj: 
            RUN EXPORT-rycoi(BUFFER ryc_object_instance). 
        END.
        FOR EACH ryc_smartlink WHERE ryc_smartlink.container_smartobject_obj = ryc_smartobject.smartobject_obj:
            RUN export-rycsl(BUFFER ryc_smartlink).
        END.

        RUN recur-rycav(INPUT ryc_smartobject.smartobject_obj).

        /* and now export its children */

        RUN recur-rycso(ryc_smartobject.smartobject_obj).    
    END.
END.

PROCEDURE recur-rycav:

    DEFINE INPUT PARAM ip_smartobject_obj AS DECIMAL.

    DEFINE BUFFER ryc_attribute_value FOR ryc_attribute_value.

    FOR EACH ryc_attribute_value
        WHERE ryc_attribute_value.primary_smartobject_obj = ip_smartobject_obj:

        /* export the attribute value */
        RUN export-rycav(BUFFER ryc_attribute_value).               

        /* and now export its children */

        RUN recur-rycav(ryc_attribute_value.smartobject_obj, ryc_attribute_value.attribute_value_obj).    
    END.
END.


PROCEDURE export-rycso:
    DEFINE PARAM BUFFER ip_rycso FOR ryc_smartobject.
    PUT STREAM str-export "~"ryc_smartobject~"" SKIP.
    EXPORT STREAM str-export ip_rycso.
END.

PROCEDURE export-rycoi:
    DEFINE PARAM BUFFER ip_buff FOR ryc_object_instance.
    PUT STREAM str-export "~"ryc_object_instance~"" SKIP.
    EXPORT STREAM str-export ip_buff.
END.

PROCEDURE export-rycsl:
    DEFINE PARAM BUFFER ip_buff FOR ryc_smartlink.
    PUT STREAM str-export "~"ryc_smartlink~"" SKIP.
    EXPORT STREAM str-export ip_buff.
END.

PROCEDURE export-rycpa:
    DEFINE PARAM BUFFER ip_buff FOR ryc_page.
    PUT STREAM str-export "~"ryc_page~"" SKIP.
    EXPORT STREAM str-export ip_buff.
END.

PROCEDURE export-rycav:
    DEFINE PARAM BUFFER ip_buff FOR ryc_attribute_value.
    PUT STREAM str-export "~"ryc_attribute_value~"" SKIP.
    EXPORT STREAM str-export ip_buff.
END.





