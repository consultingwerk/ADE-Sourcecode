/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
DEFINE BUFFER new_rycav FOR ryc_attribute_value.

FOR EACH gsc_object_type:

    DISPLAY OBJECT_type_CODE OBJECT_type_description.

    FOR EACH ryc_attribute_value
        WHERE ryc_attribute_value.OBJECT_type_obj = gsc_object_type.OBJECT_type_obj
        AND   ryc_attribute_value.smartobject_obj = 0
        AND   ryc_attribute_value.OBJECT_instance_obj = 0
        AND   ryc_attribute_value.container_smartobject_obj = 0:

        DISPLAY attribute_label.

        FOR EACH ryc_smartobject 
            WHERE ryc_smartobject.OBJECT_type_obj = gsc_object_type.OBJECT_type_obj:

            FIND FIRST new_rycav 
                WHERE new_rycav.attribute_label = ryc_attribute_value.attribute_label
                AND   new_rycav.smartobject_obj = ryc_smartobject.smartobject_obj
                AND   new_rycav.OBJECT_instance_obj = 0
                AND   new_rycav.container_smartobject_obj = 0
                NO-ERROR.

            IF NOT AVAILABLE new_rycav THEN
            DO:
                CREATE new_rycav.
                ASSIGN
                    new_rycav.attribute_label = ryc_attribute_value.attribute_label
                    new_rycav.smartobject_obj = ryc_smartobject.smartobject_obj
                    new_rycav.OBJECT_instance_obj = 0
                    new_rycav.container_smartobject_obj = 0.

                BUFFER-COPY ryc_attribute_value 
                    EXCEPT attribute_value_obj attribute_label smartobject_obj object_instance_obj container_smartobject_obj
                    TO new_rycav.                
            END.

            FOR EACH ryc_object_instance
                WHERE ryc_object_instance.smartobject_obj = ryc_smartobject.smartobject_obj:


                FIND FIRST new_rycav 
                    WHERE new_rycav.attribute_label = ryc_attribute_value.attribute_label
                    AND   new_rycav.smartobject_obj = ryc_smartobject.smartobject_obj
                    AND   new_rycav.OBJECT_instance_obj = ryc_object_instance.OBJECT_instance_obj
                    AND   new_rycav.container_smartobject_obj = ryc_object_instance.container_smartobject_obj
                    NO-ERROR.

                IF NOT AVAILABLE new_rycav THEN
                DO:
                    CREATE new_rycav.
                    ASSIGN
                        new_rycav.attribute_label = ryc_attribute_value.attribute_label
                        new_rycav.smartobject_obj = ryc_smartobject.smartobject_obj
                        new_rycav.OBJECT_instance_obj = ryc_object_instance.OBJECT_instance_obj
                        new_rycav.container_smartobject_obj = ryc_object_instance.container_smartobject_obj.

                    BUFFER-COPY ryc_attribute_value 
                        EXCEPT attribute_value_obj attribute_label smartobject_obj object_instance_obj container_smartobject_obj
                        TO new_rycav.                
                END.
            END.               
        END.
    END.
END.
