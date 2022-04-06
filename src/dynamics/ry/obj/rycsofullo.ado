<?xml version="1.0" encoding="utf-8" ?>
<dataset Transactions="1"><dataset_header DisableRI="yes" DatasetObj="1004928896.09" DateFormat="mdy" FullHeader="no" SCMManaged="yes" YearOffset="1950" DatasetCode="RYCSO" NumericFormat="AMERICAN" NumericDecimal="." OriginatingSite="91" NumericSeparator=","/>
<dataset_records><dataset_transaction TransactionNo="1" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_smartobject" version_date="10/08/2003" version_time="65370" version_user="admin" deletion_flag="no" entity_mnemonic="RYCSO" key_field_value="90325.9875" record_version_obj="90326.9875" version_number_seq="5.09" secondary_key_value="rycsofullo#CHR(1)#0" import_version_number_seq="5.09"><smartobject_obj>90325.9875</smartobject_obj>
<object_filename>rycsofullo</object_filename>
<customization_result_obj>0</customization_result_obj>
<object_type_obj>18007.409</object_type_obj>
<product_module_obj>1004874707.09</product_module_obj>
<layout_obj>0</layout_obj>
<object_description>DynSDO for ryc_smartobject</object_description>
<object_path>ry/obj</object_path>
<object_extension></object_extension>
<static_object>no</static_object>
<generic_object>no</generic_object>
<template_smartobject>no</template_smartobject>
<system_owned>no</system_owned>
<deployment_type></deployment_type>
<design_only>no</design_only>
<runnable_from_menu>no</runnable_from_menu>
<container_object>no</container_object>
<disabled>no</disabled>
<run_persistent>no</run_persistent>
<run_when>ANY</run_when>
<shutdown_message_text></shutdown_message_text>
<required_db_list></required_db_list>
<sdo_smartobject_obj>0</sdo_smartobject_obj>
<extends_smartobject_obj>0</extends_smartobject_obj>
<security_smartobject_obj>90325.9875</security_smartobject_obj>
<object_is_runnable>yes</object_is_runnable>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>90339.9875</attribute_value_obj>
<object_type_obj>18007.409</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>90325.9875</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>AssignList</attribute_label>
<character_value>;;</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>90325.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>90331.9875</attribute_value_obj>
<object_type_obj>18007.409</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>90325.9875</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>BaseQuery</attribute_label>
<character_value>FOR EACH gsc_object_type NO-LOCK,
      EACH ryc_smartobject WHERE ryc_smartobject.object_type_obj = gsc_object_type.object_type_obj NO-LOCK,
      FIRST gsc_product_module WHERE gsc_product_module.product_module_obj = ryc_smartobject.product_module_obj NO-LOCK INDEXED-REPOSITION</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>90325.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>90329.9875</attribute_value_obj>
<object_type_obj>18007.409</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>90325.9875</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>DataColumns</attribute_label>
<character_value>smartobject_obj,static_object,generic_object,template_smartobject,system_owned,deployment_type,design_only,runnable_from_menu,container_object,disabled,run_persistent,object_filename,run_when,shutdown_message_text,required_db_list,sdo_smartobject_obj,extends_smartobject_obj,security_smartobject_obj,customization_result_obj,object_type_obj,product_module_obj,layout_obj,object_description,object_path,object_extension,object_type_code,object_type_description,product_module_code,product_module_description</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>90325.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>90330.9875</attribute_value_obj>
<object_type_obj>18007.409</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>90325.9875</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>DataColumnsByTable</attribute_label>
<character_value>object_type_code,object_type_description;smartobject_obj,static_object,generic_object,template_smartobject,system_owned,deployment_type,design_only,runnable_from_menu,container_object,disabled,run_persistent,object_filename,run_when,shutdown_message_text,required_db_list,sdo_smartobject_obj,extends_smartobject_obj,security_smartobject_obj,customization_result_obj,object_type_obj,product_module_obj,layout_obj,object_description,object_path,object_extension;product_module_code,product_module_description</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>90325.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>90334.9875</attribute_value_obj>
<object_type_obj>18007.409</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>90325.9875</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>DataLogicProcedure</attribute_label>
<character_value>ry/obj/rycsologcp.p</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>90325.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>3000052940.09</attribute_value_obj>
<object_type_obj>18007.409</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>90325.9875</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>Label</attribute_label>
<character_value>Smartobject</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>90325.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>3000052757.09</attribute_value_obj>
<object_type_obj>18007.409</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>90325.9875</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>PhysicalTables</attribute_label>
<character_value>gsc_object_type,ryc_smartobject,gsc_product_module</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>90325.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>90340.9875</attribute_value_obj>
<object_type_obj>18007.409</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>90325.9875</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>QueryBuilderFieldWidths</attribute_label>
<character_value>?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,17,?</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>90325.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>no</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>90341.9875</attribute_value_obj>
<object_type_obj>18007.409</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>90325.9875</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>QueryBuilderJoinCode</attribute_label>
<character_value>?#CHR(5)#ryc_smartobject.object_type_obj = gsc_object_type.object_type_obj#CHR(5)#gsc_product_module.product_module_obj = ryc_smartobject.product_module_obj</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>90325.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>no</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>90333.9875</attribute_value_obj>
<object_type_obj>18007.409</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>90325.9875</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>QueryBuilderOptionList</attribute_label>
<character_value>NO-LOCK INDEXED-REPOSITION</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>90325.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>no</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>90332.9875</attribute_value_obj>
<object_type_obj>18007.409</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>90325.9875</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>QueryBuilderTableList</attribute_label>
<character_value>ICFDB.gsc_object_type,ICFDB.ryc_smartobject WHERE ICFDB.gsc_object_type ...,ICFDB.gsc_product_module WHERE ICFDB.ryc_smartobject ...</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>90325.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>no</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>90338.9875</attribute_value_obj>
<object_type_obj>18007.409</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>90325.9875</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>QueryBuilderTableOptionList</attribute_label>
<character_value>,, FIRST</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>90325.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>no</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>90327.9875</attribute_value_obj>
<object_type_obj>18007.409</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>90325.9875</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>Tables</attribute_label>
<character_value>gsc_object_type,ryc_smartobject,gsc_product_module</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>90325.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>90328.9875</attribute_value_obj>
<object_type_obj>18007.409</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>90325.9875</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>UpdatableColumnsByTable</attribute_label>
<character_value>;static_object,generic_object,template_smartobject,system_owned,deployment_type,design_only,runnable_from_menu,container_object,disabled,run_persistent,object_filename,run_when,shutdown_message_text,required_db_list,sdo_smartobject_obj,extends_smartobject_obj,security_smartobject_obj,customization_result_obj,object_type_obj,product_module_obj,layout_obj,object_description,object_path,object_extension;</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>90325.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
</contained_record>
</dataset_transaction>
</dataset_records>
</dataset>