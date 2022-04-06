<?xml version="1.0" encoding="utf-8" ?>
<dataset Transactions="1"><dataset_header DisableRI="yes" DatasetObj="1004928896.09" DateFormat="mdy" FullHeader="no" SCMManaged="yes" YearOffset="1950" DatasetCode="RYCSO" NumericFormat="AMERICAN" NumericDecimal="." OriginatingSite="91" NumericSeparator=","/>
<dataset_records><dataset_transaction TransactionNo="1" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_smartobject" version_date="10/08/2003" version_time="65370" version_user="admin" deletion_flag="no" entity_mnemonic="RYCSO" key_field_value="123888.9875" record_version_obj="123889.9875" version_number_seq="4.09" secondary_key_value="gsmssful2o#CHR(1)#0" import_version_number_seq="4.09"><smartobject_obj>123888.9875</smartobject_obj>
<object_filename>gsmssful2o</object_filename>
<customization_result_obj>0</customization_result_obj>
<object_type_obj>18007.409</object_type_obj>
<product_module_obj>1004874683.09</product_module_obj>
<layout_obj>0</layout_obj>
<object_description>DynSDO for gsm_security_structure</object_description>
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
<security_smartobject_obj>123888.9875</security_smartobject_obj>
<object_is_runnable>yes</object_is_runnable>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>123996.9875</attribute_value_obj>
<object_type_obj>18007.409</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>123888.9875</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>AssignList</attribute_label>
<character_value>;;;</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>123888.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>123894.9875</attribute_value_obj>
<object_type_obj>18007.409</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>123888.9875</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>BaseQuery</attribute_label>
<character_value>FOR EACH gsm_security_structure NO-LOCK,
      FIRST gsc_product_module WHERE gsc_product_module.product_module_obj = gsm_security_structure.product_module_obj OUTER-JOIN NO-LOCK,
      FIRST ryc_smartobject WHERE ryc_smartobject.smartobject_obj =  gsm_security_structure.object_obj OUTER-JOIN NO-LOCK,
      FIRST gsc_instance_attribute WHERE gsc_instance_attribute.instance_attribute_obj = gsm_security_structure.instance_attribute_obj OUTER-JOIN NO-LOCK
    BY gsm_security_structure.owning_entity_mnemonic
       BY gsm_security_structure.owning_obj
        BY gsm_security_structure.product_module_obj
         BY gsm_security_structure.object_obj
          BY gsm_security_structure.instance_attribute_obj INDEXED-REPOSITION</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>123888.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>123892.9875</attribute_value_obj>
<object_type_obj>18007.409</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>123888.9875</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>DataColumns</attribute_label>
<character_value>security_structure_obj,attribute_code_display,owning_entity_mnemonic,owning_obj,product_module_obj,object_obj,instance_attribute_obj,disabled</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>123888.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>123893.9875</attribute_value_obj>
<object_type_obj>18007.409</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>123888.9875</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>DataColumnsByTable</attribute_label>
<character_value>security_structure_obj,owning_entity_mnemonic,owning_obj,product_module_obj,object_obj,instance_attribute_obj,disabled;;;;attribute_code_display</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>123888.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>123898.9875</attribute_value_obj>
<object_type_obj>18007.409</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>123888.9875</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>DataLogicProcedure</attribute_label>
<character_value>af/obj2/gsmsslogcp.p</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>123888.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>3000052943.09</attribute_value_obj>
<object_type_obj>18007.409</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>123888.9875</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>Label</attribute_label>
<character_value>Security structure</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>123888.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>3000052760.09</attribute_value_obj>
<object_type_obj>18007.409</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>123888.9875</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>PhysicalTables</attribute_label>
<character_value>gsm_security_structure,gsc_product_module,ryc_smartobject,gsc_instance_attribute</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>123888.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>123990.9875</attribute_value_obj>
<object_type_obj>18007.409</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>123888.9875</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>QueryBuilderDBNames</attribute_label>
<character_value>ICFDB,_&lt;CALC&gt;,ICFDB,ICFDB,ICFDB,ICFDB,ICFDB,ICFDB</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>123888.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>no</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>123991.9875</attribute_value_obj>
<object_type_obj>18007.409</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>123888.9875</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>QueryBuilderFieldDataTypes</attribute_label>
<character_value>decimal,character,character,decimal,decimal,decimal,decimal,logical</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>123888.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>no</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>123992.9875</attribute_value_obj>
<object_type_obj>18007.409</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>123888.9875</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>QueryBuilderFieldWidths</attribute_label>
<character_value>?,35,?,?,?,?,?,?</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>123888.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>no</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>123993.9875</attribute_value_obj>
<object_type_obj>18007.409</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>123888.9875</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>QueryBuilderJoinCode</attribute_label>
<character_value>?#CHR(5)#gsc_product_module.product_module_obj = gsm_security_structure.product_module_obj#CHR(5)#ryc_smartobject.smartobject_obj =  gsm_security_structure.object_obj#CHR(5)#gsc_instance_attribute.instance_attribute_obj = gsm_security_structure.instance_attribute_obj</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>123888.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>no</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>123896.9875</attribute_value_obj>
<object_type_obj>18007.409</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>123888.9875</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>QueryBuilderOptionList</attribute_label>
<character_value>NO-LOCK INDEXED-REPOSITION</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>123888.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>no</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>123994.9875</attribute_value_obj>
<object_type_obj>18007.409</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>123888.9875</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>QueryBuilderOrderList</attribute_label>
<character_value>ICFDB.gsm_security_structure.owning_entity_mnemonic|yes,ICFDB.gsm_security_structure.owning_obj|yes,ICFDB.gsm_security_structure.product_module_obj|yes,ICFDB.gsm_security_structure.object_obj|yes,ICFDB.gsm_security_structure.instance_attribute_obj|yes</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>123888.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>no</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>123895.9875</attribute_value_obj>
<object_type_obj>18007.409</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>123888.9875</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>QueryBuilderTableList</attribute_label>
<character_value>ICFDB.gsm_security_structure,ICFDB.gsc_product_module WHERE ICFDB.gsm_security_structure ...,ICFDB.ryc_smartobject WHERE ICFDB.gsm_security_structure ...,ICFDB.gsc_instance_attribute WHERE ICFDB.gsm_security_structure ...</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>123888.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>no</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>123995.9875</attribute_value_obj>
<object_type_obj>18007.409</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>123888.9875</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>QueryBuilderTableOptionList</attribute_label>
<character_value>, FIRST OUTER USED, FIRST OUTER USED, FIRST OUTER USED</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>123888.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>no</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>123890.9875</attribute_value_obj>
<object_type_obj>18007.409</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>123888.9875</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>Tables</attribute_label>
<character_value>gsm_security_structure,gsc_product_module,ryc_smartobject,gsc_instance_attribute</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>123888.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>123891.9875</attribute_value_obj>
<object_type_obj>18007.409</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>123888.9875</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>UpdatableColumnsByTable</attribute_label>
<character_value>owning_entity_mnemonic,owning_obj,product_module_obj,object_obj,instance_attribute_obj,disabled;;;</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>123888.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
</contained_record>
</dataset_transaction>
</dataset_records>
</dataset>