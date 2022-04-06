<?xml version="1.0" encoding="utf-8" ?>
<dataset Transactions="1"><dataset_header DisableRI="yes" DatasetObj="1004928896.09" DateFormat="mdy" FullHeader="no" SCMManaged="yes" YearOffset="1950" DatasetCode="RYCSO" NumericFormat="AMERICAN" NumericDecimal="." OriginatingSite="91" NumericSeparator=","/>
<dataset_records><dataset_transaction TransactionNo="1" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_smartobject" version_date="10/08/2003" version_time="65370" version_user="admin" deletion_flag="no" entity_mnemonic="RYCSO" key_field_value="17363.0766" record_version_obj="17364.0766" version_number_seq="4.09" secondary_key_value="gsccpfullo#CHR(1)#0" import_version_number_seq="4.09"><smartobject_obj>17363.0766</smartobject_obj>
<object_filename>gsccpfullo</object_filename>
<customization_result_obj>0</customization_result_obj>
<object_type_obj>18007.409</object_type_obj>
<product_module_obj>1004874683.09</product_module_obj>
<layout_obj>0</layout_obj>
<object_description>DynSDO for gsc_custom_procedure</object_description>
<object_path>af/obj2</object_path>
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
<security_smartobject_obj>17363.0766</security_smartobject_obj>
<object_is_runnable>yes</object_is_runnable>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>17469.0766</attribute_value_obj>
<object_type_obj>18007.409</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>17363.0766</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>AssignList</attribute_label>
<character_value>;</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>17363.0766</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>17369.0766</attribute_value_obj>
<object_type_obj>18007.409</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>17363.0766</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>BaseQuery</attribute_label>
<character_value>FOR EACH gsc_custom_procedure NO-LOCK,
      FIRST gsm_category WHERE gsm_category.category_obj = gsc_custom_procedure.category_obj NO-LOCK
    BY gsc_custom_procedure.procedure_name INDEXED-REPOSITION</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>17363.0766</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>17367.0766</attribute_value_obj>
<object_type_obj>18007.409</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>17363.0766</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>DataColumns</attribute_label>
<character_value>custom_procedure_obj,category_obj,custom_procedure_short_desc,custom_procedure_description,custom_procedure_notes,procedure_name,run_this_procedure,category_description</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>17363.0766</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>17368.0766</attribute_value_obj>
<object_type_obj>18007.409</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>17363.0766</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>DataColumnsByTable</attribute_label>
<character_value>custom_procedure_obj,category_obj,custom_procedure_short_desc,custom_procedure_description,custom_procedure_notes,procedure_name,run_this_procedure;category_description</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>17363.0766</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>17373.0766</attribute_value_obj>
<object_type_obj>18007.409</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>17363.0766</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>DataLogicProcedure</attribute_label>
<character_value>af/obj2/gsccplogcp.p</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>17363.0766</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>3000052938.09</attribute_value_obj>
<object_type_obj>18007.409</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>17363.0766</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>Label</attribute_label>
<character_value>Custom procedure</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>17363.0766</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>3000052755.09</attribute_value_obj>
<object_type_obj>18007.409</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>17363.0766</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>PhysicalTables</attribute_label>
<character_value>gsc_custom_procedure,gsm_category</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>17363.0766</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>17467.0766</attribute_value_obj>
<object_type_obj>18007.409</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>17363.0766</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>QueryBuilderJoinCode</attribute_label>
<character_value>?#CHR(5)#icfdb.gsm_category.category_obj = icfdb.gsc_custom_procedure.category_obj</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>17363.0766</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>no</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>17371.0766</attribute_value_obj>
<object_type_obj>18007.409</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>17363.0766</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>QueryBuilderOptionList</attribute_label>
<character_value>NO-LOCK INDEXED-REPOSITION</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>17363.0766</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>no</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>17465.0766</attribute_value_obj>
<object_type_obj>18007.409</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>17363.0766</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>QueryBuilderOrderList</attribute_label>
<character_value>icfdb.gsc_custom_procedure.procedure_name|yes</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>17363.0766</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>no</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>17370.0766</attribute_value_obj>
<object_type_obj>18007.409</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>17363.0766</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>QueryBuilderTableList</attribute_label>
<character_value>icfdb.gsc_custom_procedure,icfdb.gsm_category WHERE icfdb.gsc_custom_procedure ...</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>17363.0766</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>no</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>17466.0766</attribute_value_obj>
<object_type_obj>18007.409</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>17363.0766</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>QueryBuilderTableOptionList</attribute_label>
<character_value>,FIRST</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>17363.0766</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>no</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>17365.0766</attribute_value_obj>
<object_type_obj>18007.409</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>17363.0766</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>Tables</attribute_label>
<character_value>gsc_custom_procedure,gsm_category</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>17363.0766</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>17366.0766</attribute_value_obj>
<object_type_obj>18007.409</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>17363.0766</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>UpdatableColumnsByTable</attribute_label>
<character_value>category_obj,custom_procedure_short_desc,custom_procedure_description,custom_procedure_notes,procedure_name,run_this_procedure;</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>17363.0766</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
</contained_record>
</dataset_transaction>
</dataset_records>
</dataset>