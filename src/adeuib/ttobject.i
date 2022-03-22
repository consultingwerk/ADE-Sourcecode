/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/* _RyObject - Temp-Table to track repository object information.         */
/* Define preprocessor RYOBJECT-FIELDS-ONLY to imbed these field defs     */
/* into another temp-table. This is done for _P so both tables have the   */
/* same field defs for these fields. See adeuib/uniwidg.i for details.    */
/* You can also just include this file to get _RyObject shared temp-table. */

&IF DEFINED(RYOBJECT-FIELDS-ONLY) = 0 &THEN
DEFINE {1} SHARED TEMP-TABLE _RyObject NO-UNDO
&ENDIF
  FIELD smartobject_obj         AS   DECIMAL    LABEL "Object Obj":u
  FIELD object_type_obj         AS   DECIMAL    LABEL "Object Type Obj":u
  FIELD object_type_code        AS   CHARACTER  LABEL "Object Type Code":u
  FIELD product_module_obj      AS   DECIMAL    LABEL "Product Module Obj":u
  FIELD product_module_code     AS   CHARACTER  LABEL "Product Module Code":u
  FIELD object_description      AS   CHARACTER  LABEL "Object Description":u
  FIELD object_filename         AS   CHARACTER  LABEL "Object Filename":u
  FIELD object_path             AS   CHARACTER  LABEL "Object Path":u
  FIELD object_extension        AS   CHARACTER  LABEL "Object Extension":u
  FIELD toolbar_image_filename  AS   CHARACTER  LABEL "Toolbar Image Filename":u
  FIELD runnable_from_menu      AS   LOGICAL    LABEL "Runable From Menu":u
  FIELD disabled                AS   LOGICAL    LABEL "Disbled":u
  FIELD run_persistent          AS   LOGICAL    LABEL "Run Persistent":u
  FIELD run_when                AS   CHARACTER  LABEL "Run When":u
  FIELD security_smartobject_obj 
                                AS   DECIMAL    LABEL "Security Object Obj":u
  FIELD container_object        AS   LOGICAL    LABEL "Container Object":u
  FIELD static_object           AS   LOGICAL    LABEL "Static Object":u INITIAL YES
  FIELD generic_object          AS   LOGICAL    LABEL "Generic Object":u
  FIELD required_db_list        AS   CHARACTER  LABEL "Required DB List":u
  FIELD layout_name             AS   CHARACTER  LABEL "Layout Name":u
  FIELD layout_obj              AS   DECIMAL    LABEL "Layout Obj":u
  FIELD layout_stack            AS   CHARACTER  LABEL "Layout Stack":U INITIAL "Master Layout":U
  FIELD design_template_file    AS   CHARACTER  LABEL "Design Template Filename":u
  FIELD design_image_file       AS   CHARACTER  LABEL "Design Image Filename":u
  FIELD design_propsheet_file   AS   CHARACTER  LABEL "Design Prop Sheet Filename":u
  FIELD design_hpropsheet       AS   HANDLE     LABEL "Handle to Prop Sheet Procedure":u
  FIELD design_action           AS   CHARACTER  LABEL "Action (NEW | OPEN)":u
  FIELD design_ryobject         AS   LOGICAL    LABEL "Is Repository Object":u
  FIELD design_attr_names       AS   CHARACTER  LABEL "Attribute Names (Comma-list)":u
  FIELD design_attr_values      AS   CHARACTER  LABEL "Attribute Values (Chr(2)-list)":u
  FIELD design_precid           AS   RECID      LABEL "_P recid":u
  FIELD deployment_type         AS   CHARACTER  LABEL "Static Object Deployment Type"
  FIELD design_only             AS   LOGICAL    LABEL "Design Object Only"
  FIELD parent_classes          AS   CHARACTER
&IF DEFINED(RYOBJECT-FIELDS-ONLY) = 0 &THEN
 INDEX object_filename IS PRIMARY object_filename
 INDEX smartobject_obj            smartobject_obj
 INDEX design_precid              design_precid.
&ENDIF
