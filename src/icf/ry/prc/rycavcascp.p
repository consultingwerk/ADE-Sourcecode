/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
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
                    new_rycav.container_smartobject_obj = 0                
                    new_rycav.inheritted_value = TRUE
                    new_rycav.collect_attribute_value_obj = new_rycav.attribute_value_obj.

                BUFFER-COPY ryc_attribute_value 
                    EXCEPT attribute_value_obj attribute_label smartobject_obj object_instance_obj container_smartobject_obj inheritted_value collect_attribute_value_obj
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
                        new_rycav.container_smartobject_obj = ryc_object_instance.container_smartobject_obj                
                        new_rycav.inheritted_value = TRUE
                        new_rycav.collect_attribute_value_obj = new_rycav.attribute_value_obj.

                    BUFFER-COPY ryc_attribute_value 
                        EXCEPT attribute_value_obj attribute_label smartobject_obj object_instance_obj container_smartobject_obj inheritted_value collect_attribute_value_obj
                        TO new_rycav.                
                END.
            END.               
        END.
    END.
END.
