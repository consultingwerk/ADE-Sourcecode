<?xml version="1.0" encoding="utf-8" ?>
<dataset Transactions="1"><dataset_header DisableRI="yes" DatasetObj="1004928896.09" DateFormat="mdy" FullHeader="no" SCMManaged="yes" YearOffset="1950" DatasetCode="RYCSO" NumericFormat="AMERICAN" NumericDecimal="." OriginatingSite="91" NumericSeparator=","/>
<dataset_records><dataset_transaction TransactionNo="1" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_smartobject" version_date="09/20/2003" version_time="80503" version_user="admin" deletion_flag="no" entity_mnemonic="RYCSO" key_field_value="1004841197.09" record_version_obj="14143.0766" version_number_seq="11.09" secondary_key_value="gscscfol2w#CHR(1)#0" import_version_number_seq="11.09"><smartobject_obj>1004841197.09</smartobject_obj>
<object_filename>gscscfol2w</object_filename>
<customization_result_obj>0</customization_result_obj>
<object_type_obj>1003498200</object_type_obj>
<product_module_obj>1004874679.09</product_module_obj>
<layout_obj>1007500101.09</layout_obj>
<object_description>Security Control Maintenance</object_description>
<object_path>af/cod2</object_path>
<object_extension></object_extension>
<static_object>no</static_object>
<generic_object>no</generic_object>
<template_smartobject>no</template_smartobject>
<system_owned>no</system_owned>
<deployment_type></deployment_type>
<design_only>no</design_only>
<runnable_from_menu>yes</runnable_from_menu>
<container_object>yes</container_object>
<disabled>no</disabled>
<run_persistent>yes</run_persistent>
<run_when>ANY</run_when>
<shutdown_message_text></shutdown_message_text>
<required_db_list></required_db_list>
<sdo_smartobject_obj>0</sdo_smartobject_obj>
<extends_smartobject_obj>0</extends_smartobject_obj>
<security_smartobject_obj>1004841197.09</security_smartobject_obj>
<object_is_runnable>yes</object_is_runnable>
<contained_record DB="icfdb" Table="ryc_page"><page_obj>1004843784.09</page_obj>
<container_smartobject_obj>1004841197.09</container_smartobject_obj>
<layout_obj>1007500101.09</layout_obj>
<page_sequence>1</page_sequence>
<page_reference>Details01</page_reference>
<page_label>Details</page_label>
<security_token>Details</security_token>
<enable_on_create>yes</enable_on_create>
<enable_on_modify>yes</enable_on_modify>
<enable_on_view>yes</enable_on_view>
</contained_record>
<contained_record DB="icfdb" Table="ryc_object_instance"><object_instance_obj>1004843631.09</object_instance_obj>
<container_smartobject_obj>1004841197.09</container_smartobject_obj>
<smartobject_obj>1003504456</smartobject_obj>
<system_owned>no</system_owned>
<layout_position>B91</layout_position>
<instance_name>afspfoldrww</instance_name>
<instance_description>afspfoldrw.w</instance_description>
<page_obj>0</page_obj>
<object_sequence>0</object_sequence>
</contained_record>
<contained_record DB="icfdb" Table="ryc_object_instance"><object_instance_obj>1004843792.09</object_instance_obj>
<container_smartobject_obj>1004841197.09</container_smartobject_obj>
<smartobject_obj>1000708643.09</smartobject_obj>
<system_owned>no</system_owned>
<layout_position>M11</layout_position>
<instance_name>FolderTop</instance_name>
<instance_description>FolderTop</instance_description>
<page_obj>0</page_obj>
<object_sequence>0</object_sequence>
</contained_record>
<contained_record DB="icfdb" Table="ryc_object_instance"><object_instance_obj>1004843790.09</object_instance_obj>
<container_smartobject_obj>1004841197.09</container_smartobject_obj>
<smartobject_obj>123521.9875</smartobject_obj>
<system_owned>no</system_owned>
<layout_position>M11</layout_position>
<instance_name>gscscdynv</instance_name>
<instance_description>Dynamic viewer for gsc_security_control</instance_description>
<page_obj>1004843784.09</page_obj>
<object_sequence>201</object_sequence>
</contained_record>
<contained_record DB="icfdb" Table="ryc_object_instance"><object_instance_obj>1004843786.09</object_instance_obj>
<container_smartobject_obj>1004841197.09</container_smartobject_obj>
<smartobject_obj>123508.9875</smartobject_obj>
<system_owned>no</system_owned>
<layout_position> 11</layout_position>
<instance_name>gscscful2o</instance_name>
<instance_description>DynSDO for gsc_security_control</instance_description>
<page_obj>0</page_obj>
<object_sequence>0</object_sequence>
</contained_record>
<contained_record DB="icfdb" Table="ryc_smartlink"><smartlink_obj>1004843778.09</smartlink_obj>
<container_smartobject_obj>1004841197.09</container_smartobject_obj>
<smartlink_type_obj>1003202300</smartlink_type_obj>
<link_name>Page</link_name>
<source_object_instance_obj>1004843631.09</source_object_instance_obj>
<target_object_instance_obj>0</target_object_instance_obj>
</contained_record>
<contained_record DB="icfdb" Table="ryc_smartlink"><smartlink_obj>1004843868.09</smartlink_obj>
<container_smartobject_obj>1004841197.09</container_smartobject_obj>
<smartlink_type_obj>1003183649</smartlink_type_obj>
<link_name>Data</link_name>
<source_object_instance_obj>1004843786.09</source_object_instance_obj>
<target_object_instance_obj>1004843790.09</target_object_instance_obj>
</contained_record>
<contained_record DB="icfdb" Table="ryc_smartlink"><smartlink_obj>1004843866.09</smartlink_obj>
<container_smartobject_obj>1004841197.09</container_smartobject_obj>
<smartlink_type_obj>1003183650</smartlink_type_obj>
<link_name>Update</link_name>
<source_object_instance_obj>1004843790.09</source_object_instance_obj>
<target_object_instance_obj>1004843786.09</target_object_instance_obj>
</contained_record>
<contained_record DB="icfdb" Table="ryc_smartlink"><smartlink_obj>123753.9875</smartlink_obj>
<container_smartobject_obj>1004841197.09</container_smartobject_obj>
<smartlink_type_obj>463.5498</smartlink_type_obj>
<link_name>ContainerToolbar</link_name>
<source_object_instance_obj>1004843792.09</source_object_instance_obj>
<target_object_instance_obj>0</target_object_instance_obj>
</contained_record>
<contained_record DB="icfdb" Table="ryc_smartlink"><smartlink_obj>1004843860.09</smartlink_obj>
<container_smartobject_obj>1004841197.09</container_smartobject_obj>
<smartlink_type_obj>1003518046</smartlink_type_obj>
<link_name>TableIO</link_name>
<source_object_instance_obj>1004843792.09</source_object_instance_obj>
<target_object_instance_obj>1004843790.09</target_object_instance_obj>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>123755.9875</attribute_value_obj>
<object_type_obj>1003498168</object_type_obj>
<container_smartobject_obj>1004841197.09</container_smartobject_obj>
<smartobject_obj>1000708643.09</smartobject_obj>
<object_instance_obj>1004843792.09</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>ActionGroups</attribute_label>
<character_value>Tableio</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>1004841197.09</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>1004843629.09</attribute_value_obj>
<object_type_obj>1003498200</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>1004841197.09</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>ContainerMode</attribute_label>
<character_value>modify</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>1004841197.09</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>4162.6893</attribute_value_obj>
<object_type_obj>1003498168</object_type_obj>
<container_smartobject_obj>1004841197.09</container_smartobject_obj>
<smartobject_obj>1000708643.09</smartobject_obj>
<object_instance_obj>1004843792.09</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>DisabledActions</attribute_label>
<character_value>Delete</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>1004841197.09</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>123754.9875</attribute_value_obj>
<object_type_obj>1003498168</object_type_obj>
<container_smartobject_obj>1004841197.09</container_smartobject_obj>
<smartobject_obj>1000708643.09</smartobject_obj>
<object_instance_obj>1004843792.09</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>HiddenActions</attribute_label>
<character_value>Spell,Update</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>1004841197.09</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>123758.9875</attribute_value_obj>
<object_type_obj>1003498168</object_type_obj>
<container_smartobject_obj>1004841197.09</container_smartobject_obj>
<smartobject_obj>1000708643.09</smartobject_obj>
<object_instance_obj>1004843792.09</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>HiddenMenuBands</attribute_label>
<character_value>Navigation</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>1004841197.09</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>123757.9875</attribute_value_obj>
<object_type_obj>1003498168</object_type_obj>
<container_smartobject_obj>1004841197.09</container_smartobject_obj>
<smartobject_obj>1000708643.09</smartobject_obj>
<object_instance_obj>1004843792.09</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>HiddenToolbarBands</attribute_label>
<character_value>Navigation,Folderfunction</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>1004841197.09</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>123756.9875</attribute_value_obj>
<object_type_obj>1003498168</object_type_obj>
<container_smartobject_obj>1004841197.09</container_smartobject_obj>
<smartobject_obj>1000708643.09</smartobject_obj>
<object_instance_obj>1004843792.09</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>SupportedLinks</attribute_label>
<character_value>Tableio-source</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>1004841197.09</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>123752.9875</attribute_value_obj>
<object_type_obj>1003498168</object_type_obj>
<container_smartobject_obj>1004841197.09</container_smartobject_obj>
<smartobject_obj>1000708643.09</smartobject_obj>
<object_instance_obj>1004843792.09</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>TableIOType</attribute_label>
<character_value>Update</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>1004841197.09</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>1004843833.09</attribute_value_obj>
<object_type_obj>1003498168</object_type_obj>
<container_smartobject_obj>1004841197.09</container_smartobject_obj>
<smartobject_obj>1000708643.09</smartobject_obj>
<object_instance_obj>1004843792.09</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>ToolbarAutoSize</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>1004841197.09</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>1004843836.09</attribute_value_obj>
<object_type_obj>1003498168</object_type_obj>
<container_smartobject_obj>1004841197.09</container_smartobject_obj>
<smartobject_obj>1000708643.09</smartobject_obj>
<object_instance_obj>1004843792.09</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>ToolbarBands</attribute_label>
<character_value>adm2Navigation,folder2tableio</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>1004841197.09</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>1004843627.09</attribute_value_obj>
<object_type_obj>1003498200</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>1004841197.09</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>WindowName</attribute_label>
<character_value>Security Maintenance</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>1004841197.09</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
</contained_record>
</dataset_transaction>
</dataset_records>
</dataset>