<?xml version="1.0" encoding="utf-8" ?>
<dataset Transactions="3"><dataset_header DisableRI="yes" DatasetObj="1007600164.08" DateFormat="mdy" FullHeader="yes" SCMManaged="no" YearOffset="1950" DatasetCode="GSCOT" NumericFormat="AMERICAN" NumericDecimal="." OriginatingSite="66" NumericSeparator=","><deploy_dataset_obj>1007600164.08</deploy_dataset_obj>
<dataset_code>GSCOT</dataset_code>
<dataset_description>gsc_object_type - Object Types</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<deploy_additions_only>no</deploy_additions_only>
<enable_data_versioning>yes</enable_data_versioning>
<deletion_dataset>yes</deletion_dataset>
<dataset_entity><dataset_entity_obj>1007600165.08</dataset_entity_obj>
<deploy_dataset_obj>1007600164.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSCOT</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>object_type_code</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
<exclude_field_list></exclude_field_list>
<entity_mnemonic_description>gsc_object_type</entity_mnemonic_description>
<entity_dbname>ICFDB</entity_dbname>
</dataset_entity>
<dataset_entity><dataset_entity_obj>1000000232.39</dataset_entity_obj>
<deploy_dataset_obj>1007600164.08</deploy_dataset_obj>
<entity_sequence>2</entity_sequence>
<entity_mnemonic>RYCAV</entity_mnemonic>
<primary_entity>no</primary_entity>
<join_entity_mnemonic>GSCOT</join_entity_mnemonic>
<join_field_list>object_type_obj,object_type_obj</join_field_list>
<filter_where_clause>ryc_attribute_value.primary_smartobject_obj = 0 AND
ryc_attribute_value.smartobject_obj = 0 AND
ryc_attribute_value.container_smartobject_obj = 0 AND
ryc_attribute_value.object_instance_obj = 0
</filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
<exclude_field_list></exclude_field_list>
<entity_mnemonic_description>ryc_attribute_value</entity_mnemonic_description>
<entity_dbname>ICFDB</entity_dbname>
</dataset_entity>
<dataset_entity><dataset_entity_obj>3000004910.09</dataset_entity_obj>
<deploy_dataset_obj>1007600164.08</deploy_dataset_obj>
<entity_sequence>3</entity_sequence>
<entity_mnemonic>RYCUE</entity_mnemonic>
<primary_entity>no</primary_entity>
<join_entity_mnemonic>GSCOT</join_entity_mnemonic>
<join_field_list>object_type_obj,object_type_obj</join_field_list>
<filter_where_clause>ryc_ui_event.primary_smartobject_obj = 0 AND
ryc_ui_event.smartobject_obj = 0 AND
ryc_ui_event.container_smartobject_obj = 0 AND
ryc_ui_event.object_instance_obj = 0</filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
<exclude_field_list></exclude_field_list>
<entity_mnemonic_description>ryc_ui_event</entity_mnemonic_description>
<entity_dbname>ICFDB</entity_dbname>
</dataset_entity>
<dataset_entity><dataset_entity_obj>3000004931.09</dataset_entity_obj>
<deploy_dataset_obj>1007600164.08</deploy_dataset_obj>
<entity_sequence>4</entity_sequence>
<entity_mnemonic>RYCSL</entity_mnemonic>
<primary_entity>no</primary_entity>
<join_entity_mnemonic>GSCOT</join_entity_mnemonic>
<join_field_list>object_type_obj,object_type_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
<exclude_field_list></exclude_field_list>
<entity_mnemonic_description>ryc_supported_link</entity_mnemonic_description>
<entity_dbname>ICFDB</entity_dbname>
</dataset_entity>
<table_definition><name>gsc_object_type</name>
<dbname>icfdb</dbname>
<index-1>XAK1gsc_object_type,1,0,0,object_type_code,0</index-1>
<index-2>XIE1gsc_object_type,0,0,0,object_type_description,0</index-2>
<index-3>XIE2gsc_object_type,0,0,0,extends_object_type_obj,0</index-3>
<index-4>XIE3gsc_object_type,0,0,0,class_smartobject_obj,0</index-4>
<index-5>XPKgsc_object_type,1,1,0,object_type_obj,0</index-5>
<field><name>object_type_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Object type obj</label>
<column-label>Object type obj</column-label>
</field>
<field><name>object_type_code</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>Object type code</label>
<column-label>Object type code</column-label>
</field>
<field><name>object_type_description</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>Object type description</label>
<column-label>Object type description</column-label>
</field>
<field><name>disabled</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>Disabled</label>
<column-label>Disabled</column-label>
</field>
<field><name>layout_supported</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>Layout supported</label>
<column-label>Layout supported</column-label>
</field>
<field><name>deployment_type</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>Deployment type</label>
<column-label>Deployment type</column-label>
</field>
<field><name>static_object</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>Static object</label>
<column-label>Static object</column-label>
</field>
<field><name>class_smartobject_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Class smartobject obj</label>
<column-label>Class smartobject obj</column-label>
</field>
<field><name>extends_object_type_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Extends object type obj</label>
<column-label>Extends object type obj</column-label>
</field>
<field><name>cache_on_client</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>Cache on client</label>
<column-label>Cache on client</column-label>
</field>
</table_definition>
<table_definition><name>ryc_attribute_value</name>
<dbname>icfdb</dbname>
<index-1>XAK1ryc_attribute_value,1,0,0,object_type_obj,0,smartobject_obj,0,object_instance_obj,0,render_type_obj,0,attribute_label,0</index-1>
<index-2>XIE1ryc_attribute_value,0,0,0,attribute_label,0,object_type_obj,0</index-2>
<index-3>XIE2ryc_attribute_value,0,0,0,primary_smartobject_obj,0,attribute_label,0</index-3>
<index-4>XIE3ryc_attribute_value,0,0,0,object_instance_obj,0</index-4>
<index-5>XIE4ryc_attribute_value,0,0,0,container_smartobject_obj,0</index-5>
<index-6>XIE5ryc_attribute_value,0,0,0,smartobject_obj,0</index-6>
<index-7>XIE6ryc_attribute_value,0,0,0,render_type_obj,0</index-7>
<index-8>XIE7ryc_attribute_value,0,0,0,attribute_label,0</index-8>
<index-9>XIE8ryc_attribute_value,0,0,0,smartobject_obj,0,object_instance_obj,0,render_type_obj,0,applies_at_runtime,0</index-9>
<index-10>XPKryc_attribute_value,1,1,0,attribute_value_obj,0</index-10>
<field><name>attribute_value_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Attribute value obj</label>
<column-label>Attribute value obj</column-label>
</field>
<field><name>object_type_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Object type obj</label>
<column-label>Object type obj</column-label>
</field>
<field><name>container_smartobject_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Container smartobject obj</label>
<column-label>Container smartobject obj</column-label>
</field>
<field><name>smartobject_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Smartobject obj</label>
<column-label>Smartobject obj</column-label>
</field>
<field><name>object_instance_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Object instance obj</label>
<column-label>Object instance obj</column-label>
</field>
<field><name>constant_value</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>Constant value</label>
<column-label>Constant value</column-label>
</field>
<field><name>attribute_label</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>Attribute label</label>
<column-label>Attribute label</column-label>
</field>
<field><name>character_value</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Character value</label>
<column-label>Character value</column-label>
</field>
<field><name>integer_value</name>
<data-type>integer</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;9</format>
<initial>        0</initial>
<label>Integer value</label>
<column-label>Integer value</column-label>
</field>
<field><name>date_value</name>
<data-type>date</data-type>
<extent>0</extent>
<format>99/99/9999</format>
<initial></initial>
<label>Date value</label>
<column-label>Date value</column-label>
</field>
<field><name>decimal_value</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;,&gt;&gt;&gt;,&gt;&gt;&gt;,&gt;&gt;9.99</format>
<initial>               0.00</initial>
<label>Decimal value</label>
<column-label>Decimal value</column-label>
</field>
<field><name>logical_value</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>Logical value</label>
<column-label>Logical value</column-label>
</field>
<field><name>raw_value</name>
<data-type>raw</data-type>
<extent>0</extent>
<format>X(15)</format>
<initial></initial>
<label>Raw value</label>
<column-label>Raw value</column-label>
</field>
<field><name>primary_smartobject_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Primary smartobject obj</label>
<column-label>Primary smartobject obj</column-label>
</field>
<field><name>render_type_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Render type obj</label>
<column-label>Render type obj</column-label>
</field>
<field><name>applies_at_runtime</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>YES</initial>
<label>Applies at runtime</label>
<column-label>Applies at runtime</column-label>
</field>
</table_definition>
<table_definition><name>ryc_ui_event</name>
<dbname>icfdb</dbname>
<index-1>XAK1ryc_ui_event,1,0,0,object_type_obj,0,smartobject_obj,0,object_instance_obj,0,render_type_obj,0,event_name,0</index-1>
<index-2>XIE1ryc_ui_event,0,0,0,primary_smartobject_obj,0</index-2>
<index-3>XIE2ryc_ui_event,0,0,0,object_instance_obj,0</index-3>
<index-4>XIE3ryc_ui_event,0,0,0,container_smartobject_obj,0</index-4>
<index-5>XIE4ryc_ui_event,0,0,0,smartobject_obj,0</index-5>
<index-6>XIE5ryc_ui_event,0,0,0,render_type_obj,0</index-6>
<index-7>XPKryc_ui_event,1,1,0,ui_event_obj,0</index-7>
<field><name>ui_event_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>UI event obj</label>
<column-label>UI event obj</column-label>
</field>
<field><name>object_type_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Object type obj</label>
<column-label>Object type obj</column-label>
</field>
<field><name>container_smartobject_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Container smartobject obj</label>
<column-label>Container smartobject obj</column-label>
</field>
<field><name>smartobject_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Smartobject obj</label>
<column-label>Smartobject obj</column-label>
</field>
<field><name>object_instance_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Object instance obj</label>
<column-label>Object instance obj</column-label>
</field>
<field><name>event_name</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>Event name</label>
<column-label>Event name</column-label>
</field>
<field><name>constant_value</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>Constant value</label>
<column-label>Constant value</column-label>
</field>
<field><name>action_type</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(3)</format>
<initial></initial>
<label>Action type</label>
<column-label>Action type</column-label>
</field>
<field><name>action_target</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(28)</format>
<initial></initial>
<label>Action target</label>
<column-label>Action target</column-label>
</field>
<field><name>event_action</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>Event action</label>
<column-label>Event action</column-label>
</field>
<field><name>event_parameter</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(500)</format>
<initial></initial>
<label>Event parameter</label>
<column-label>Event parameter</column-label>
</field>
<field><name>event_disabled</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>Event disabled</label>
<column-label>Event disabled</column-label>
</field>
<field><name>primary_smartobject_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Primary smartobject obj</label>
<column-label>Primary smartobject obj</column-label>
</field>
<field><name>render_type_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Render type obj</label>
<column-label>Render type obj</column-label>
</field>
</table_definition>
<table_definition><name>ryc_supported_link</name>
<dbname>icfdb</dbname>
<index-1>XAK1ryc_supported_link,1,0,0,object_type_obj,0,smartlink_type_obj,0</index-1>
<index-2>XAK2ryc_supported_link,1,0,0,smartlink_type_obj,0,object_type_obj,0</index-2>
<index-3>XPKryc_supported_link,1,1,0,supported_link_obj,0</index-3>
<field><name>supported_link_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Supported link obj</label>
<column-label>Supported link obj</column-label>
</field>
<field><name>object_type_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Object type obj</label>
<column-label>Object type obj</column-label>
</field>
<field><name>smartlink_type_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Smartlink type obj</label>
<column-label>Smartlink type obj</column-label>
</field>
<field><name>link_source</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>YES</initial>
<label>Link source</label>
<column-label>Link source</column-label>
</field>
<field><name>link_target</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>YES</initial>
<label>Link target</label>
<column-label>Link target</column-label>
</field>
<field><name>deactivated_link_on_hide</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>Deactivated link on hide</label>
<column-label>Deactivated link on hide</column-label>
</field>
</table_definition>
</dataset_header>
<dataset_records><dataset_transaction TransactionNo="1" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_object_type" version_date="11/12/2003" version_time="36558" version_user="admin" deletion_flag="no" entity_mnemonic="gscot" key_field_value="735.7063" record_version_obj="15010.7063" version_number_seq="12" secondary_key_value="Panel" import_version_number_seq="4"><object_type_obj>735.7063</object_type_obj>
<object_type_code>Panel</object_type_code>
<object_type_description>Panel base class</object_type_description>
<disabled>no</disabled>
<layout_supported>no</layout_supported>
<deployment_type></deployment_type>
<static_object>yes</static_object>
<class_smartobject_obj>0</class_smartobject_obj>
<extends_object_type_obj>47340.66</extends_object_type_obj>
<cache_on_client>no</cache_on_client>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>1202.7063</attribute_value_obj>
<object_type_obj>735.7063</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>0</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>AddFunction</attribute_label>
<character_value>One-Record</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>0</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>no</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>1205.7063</attribute_value_obj>
<object_type_obj>735.7063</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>0</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>ButtonCount</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>0</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>no</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>1208.7063</attribute_value_obj>
<object_type_obj>735.7063</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>0</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>MarginPixels</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>0</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>1211.7063</attribute_value_obj>
<object_type_obj>735.7063</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>0</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>PanelFrame</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>0</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>no</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>1212.7063</attribute_value_obj>
<object_type_obj>735.7063</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>0</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>PanelLabel</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>0</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>no</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>1213.7063</attribute_value_obj>
<object_type_obj>735.7063</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>0</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>PanelState</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>0</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>no</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>1214.7063</attribute_value_obj>
<object_type_obj>735.7063</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>0</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>PanelType</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>0</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>no</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>1215.7063</attribute_value_obj>
<object_type_obj>735.7063</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>0</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>RightToLeft</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>0</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>1216.7063</attribute_value_obj>
<object_type_obj>735.7063</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>0</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>StaticPrefix</attribute_label>
<character_value>Btn-</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>0</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>1219.7063</attribute_value_obj>
<object_type_obj>735.7063</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>0</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>UpdatingRecord</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>0</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>no</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>15009.7063</attribute_value_obj>
<object_type_obj>735.7063</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>0</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>SuperProcedure</attribute_label>
<character_value>adm2/panel.p</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>0</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="2" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_object_type" version_date="11/12/2003" version_time="36562" version_user="admin" deletion_flag="no" entity_mnemonic="gscot" key_field_value="1003498168" record_version_obj="1354.7063" version_number_seq="98" secondary_key_value="SmartToolbar" import_version_number_seq="83.09"><object_type_obj>1003498168</object_type_obj>
<object_type_code>SmartToolbar</object_type_code>
<object_type_description>SmartToolbar Object</object_type_description>
<disabled>no</disabled>
<layout_supported>no</layout_supported>
<deployment_type></deployment_type>
<static_object>yes</static_object>
<class_smartobject_obj>0</class_smartobject_obj>
<extends_object_type_obj>47340.66</extends_object_type_obj>
<cache_on_client>yes</cache_on_client>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="3" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_object_type" version_date="11/12/2003" version_time="36894" version_user="admin" deletion_flag="no" entity_mnemonic="gscot" key_field_value="47340.66" record_version_obj="47341.66" version_number_seq="63" secondary_key_value="Toolbar" import_version_number_seq="0"><object_type_obj>47340.66</object_type_obj>
<object_type_code>Toolbar</object_type_code>
<object_type_description>Toolbar base class</object_type_description>
<disabled>no</disabled>
<layout_supported>no</layout_supported>
<deployment_type></deployment_type>
<static_object>no</static_object>
<class_smartobject_obj>0</class_smartobject_obj>
<extends_object_type_obj>237.7063</extends_object_type_obj>
<cache_on_client>yes</cache_on_client>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>182</attribute_value_obj>
<object_type_obj>47340.66</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>0</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>DisabledActions</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>0</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>184</attribute_value_obj>
<object_type_obj>47340.66</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>0</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>HiddenActions</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>0</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>186</attribute_value_obj>
<object_type_obj>47340.66</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>0</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>HiddenToolbarBands</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>0</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>188</attribute_value_obj>
<object_type_obj>47340.66</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>0</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>HiddenMenuBands</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>0</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>190</attribute_value_obj>
<object_type_obj>47340.66</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>0</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>MenuMergeOrder</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>0</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>457.5498</attribute_value_obj>
<object_type_obj>47340.66</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>0</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>ContainerToolbarTarget</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>0</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>no</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>458.5498</attribute_value_obj>
<object_type_obj>47340.66</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>0</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>ContainerToolbarTargetEvents</attribute_label>
<character_value>resetContainerToolbar,linkState</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>0</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>526.28</attribute_value_obj>
<object_type_obj>47340.66</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>0</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>ResizeHorizontal</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>yes</logical_value>
<primary_smartobject_obj>0</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>548.28</attribute_value_obj>
<object_type_obj>47340.66</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>0</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>ResizeVertical</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>0</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>1203.7063</attribute_value_obj>
<object_type_obj>47340.66</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>0</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>BoxRectangle</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>0</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>no</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>1204.7063</attribute_value_obj>
<object_type_obj>47340.66</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>0</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>BoxRectangle2</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>0</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>no</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>1209.7063</attribute_value_obj>
<object_type_obj>47340.66</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>0</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>NavigationTargetEvents</attribute_label>
<character_value>queryPosition,updateState,linkState,filterState</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>0</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>1210.7063</attribute_value_obj>
<object_type_obj>47340.66</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>0</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>NavigationTargetName</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>0</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>1217.7063</attribute_value_obj>
<object_type_obj>47340.66</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>0</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>TableioTarget</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>0</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>no</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>1218.7063</attribute_value_obj>
<object_type_obj>47340.66</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>0</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>TableioTargetEvents</attribute_label>
<character_value>queryPosition,updateState,linkState,resetTableio</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>0</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>1220.7063</attribute_value_obj>
<object_type_obj>47340.66</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>0</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>NavigationTarget</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>0</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>no</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>1221.7063</attribute_value_obj>
<object_type_obj>47340.66</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>0</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>CommitTarget</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>0</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>no</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>1222.7063</attribute_value_obj>
<object_type_obj>47340.66</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>0</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>CommitTargetEvents</attribute_label>
<character_value>rowObjectState</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>0</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>1341.7063</attribute_value_obj>
<object_type_obj>47340.66</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>0</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>AvailMenuActions</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>0</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>no</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>1342.7063</attribute_value_obj>
<object_type_obj>47340.66</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>0</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>AvailToolbarActions</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>0</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>no</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>1343.7063</attribute_value_obj>
<object_type_obj>47340.66</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>0</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>ImagePath</attribute_label>
<character_value>adm2/image</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>0</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>1344.7063</attribute_value_obj>
<object_type_obj>47340.66</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>0</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>LinkTargetNames</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>0</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>no</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>1345.7063</attribute_value_obj>
<object_type_obj>47340.66</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>0</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>MenuBarHandle</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>0</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>no</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>1347.7063</attribute_value_obj>
<object_type_obj>47340.66</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>0</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>ToolbarTarget</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>0</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>no</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>1348.7063</attribute_value_obj>
<object_type_obj>47340.66</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>0</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>ToolbarTargetEvents</attribute_label>
<character_value>resetToolbar,linkState</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>0</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>1349.7063</attribute_value_obj>
<object_type_obj>47340.66</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>0</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>ToolHeightPxl</attribute_label>
<character_value></character_value>
<integer_value>22</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>0</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>1350.7063</attribute_value_obj>
<object_type_obj>47340.66</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>0</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>ToolMaxWidthPxl</attribute_label>
<character_value></character_value>
<integer_value>24</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>0</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>1351.7063</attribute_value_obj>
<object_type_obj>47340.66</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>0</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>ToolSeparatorPxl</attribute_label>
<character_value></character_value>
<integer_value>3</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>0</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>1352.7063</attribute_value_obj>
<object_type_obj>47340.66</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>0</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>ToolSpacingPxl</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>0</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>1353.7063</attribute_value_obj>
<object_type_obj>47340.66</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>0</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>ToolWidthPxl</attribute_label>
<character_value></character_value>
<integer_value>24</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>0</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>1780.66</attribute_value_obj>
<object_type_obj>47340.66</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>0</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>DeactivateTargetOnHide</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>0</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>2759.5498</attribute_value_obj>
<object_type_obj>47340.66</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>0</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>PropertyDialog</attribute_label>
<character_value>adm2/support/toold.w</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>0</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>3765.5498</attribute_value_obj>
<object_type_obj>47340.66</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>0</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>InstanceProperties</attribute_label>
<character_value>FlatButtons,Menu,ShowBorder,Toolbar,ActionGroups,SubModules,TableIOType,SupportedLinks,ToolbarBands,ToolbarParentMenu,ToolbarAutoSize,ToolbarDrawDirection,ToolbarInitialState,LogicalObjectName,AutoResize,DisabledActions,HiddenActions,HiddenToolbarBands,HiddenMenuBands,MenuMergeOrder,EdgePixels,PanelType,DeactivateTargetOnHide,DisabledActions,NavigationTargetName,HideOnInit,DisableOnInit,ObjectLayout</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>0</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>no</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>15011.7063</attribute_value_obj>
<object_type_obj>47340.66</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>0</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>SuperProcedure</attribute_label>
<character_value>adm2/toolbar.p</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>0</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>47335.66</attribute_value_obj>
<object_type_obj>47340.66</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>0</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>ContainerSourceEvents</attribute_label>
<character_value>initializeObject,hideObject,viewObject,destroyObject,enableObject,removeMenu,rebuildMenu</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>0</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>47338.66</attribute_value_obj>
<object_type_obj>47340.66</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>0</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>RemoveMenuOnHide</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>0</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>1003498931</attribute_value_obj>
<object_type_obj>47340.66</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>0</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>yes</constant_value>
<attribute_label>FlatButtons</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>yes</logical_value>
<primary_smartobject_obj>0</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>1003498935</attribute_value_obj>
<object_type_obj>47340.66</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>0</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>yes</constant_value>
<attribute_label>Menu</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>yes</logical_value>
<primary_smartobject_obj>0</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>1003498939</attribute_value_obj>
<object_type_obj>47340.66</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>0</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>yes</constant_value>
<attribute_label>ShowBorder</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>yes</logical_value>
<primary_smartobject_obj>0</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>1003498943</attribute_value_obj>
<object_type_obj>47340.66</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>0</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>yes</constant_value>
<attribute_label>Toolbar</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>yes</logical_value>
<primary_smartobject_obj>0</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>1003498947</attribute_value_obj>
<object_type_obj>47340.66</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>0</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>ActionGroups</attribute_label>
<character_value>Tableio,Navigation</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>0</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>1003498951</attribute_value_obj>
<object_type_obj>47340.66</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>0</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>SubModules</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>0</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>1003498955</attribute_value_obj>
<object_type_obj>47340.66</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>0</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>TableIOType</attribute_label>
<character_value>save</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>0</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>1003498959</attribute_value_obj>
<object_type_obj>47340.66</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>0</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>yes</constant_value>
<attribute_label>SupportedLinks</attribute_label>
<character_value>Navigation-Source,Tableio-Source</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>0</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>1003498963</attribute_value_obj>
<object_type_obj>47340.66</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>0</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>ToolbarBands</attribute_label>
<character_value>Adm2Navigation</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>0</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>1003498967</attribute_value_obj>
<object_type_obj>47340.66</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>0</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>ToolbarParentMenu</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>0</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>1003498971</attribute_value_obj>
<object_type_obj>47340.66</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>0</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>ToolbarAutoSize</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>yes</logical_value>
<primary_smartobject_obj>0</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>1003498975</attribute_value_obj>
<object_type_obj>47340.66</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>0</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>ToolbarDrawDirection</attribute_label>
<character_value>horizontal</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>0</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>1003498979</attribute_value_obj>
<object_type_obj>47340.66</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>0</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>ToolbarInitialState</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>0</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>1003498983</attribute_value_obj>
<object_type_obj>47340.66</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>0</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>EdgePixels</attribute_label>
<character_value></character_value>
<integer_value>2</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>0</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>1003498987</attribute_value_obj>
<object_type_obj>47340.66</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>0</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>yes</constant_value>
<attribute_label>PanelType</attribute_label>
<character_value>Toolbar</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>0</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>no</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>1003499217</attribute_value_obj>
<object_type_obj>47340.66</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>0</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>HideOnInit</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>0</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>1003499221</attribute_value_obj>
<object_type_obj>47340.66</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>0</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>DisableOnInit</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>0</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>1003499225</attribute_value_obj>
<object_type_obj>47340.66</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>0</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>ObjectLayout</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>0</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>1003504310</attribute_value_obj>
<object_type_obj>47340.66</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>0</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>ToolMarginPxl</attribute_label>
<character_value></character_value>
<integer_value>2</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>0</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>3000000027.09</attribute_value_obj>
<object_type_obj>47340.66</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>0</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>TemplateObjectName</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>0</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>3000000028.09</attribute_value_obj>
<object_type_obj>47340.66</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>0</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>MinHeight</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>0</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>3000050117.09</attribute_value_obj>
<object_type_obj>47340.66</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>0</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>RenderingProcedure</attribute_label>
<character_value>ry/obj/rydyntoolt.w</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>0</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>3000052930.09</attribute_value_obj>
<object_type_obj>47340.66</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>0</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>CreateSubMenuOnConflict</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>yes</logical_value>
<primary_smartobject_obj>0</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>3000052931.09</attribute_value_obj>
<object_type_obj>47340.66</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>0</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>SubMenuLabelRetrieval</attribute_label>
<character_value>Label</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>0</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_supported_link"><supported_link_obj>47343.66</supported_link_obj>
<object_type_obj>47340.66</object_type_obj>
<smartlink_type_obj>463.5498</smartlink_type_obj>
<link_source>yes</link_source>
<link_target>no</link_target>
<deactivated_link_on_hide>no</deactivated_link_on_hide>
</contained_record>
<contained_record DB="icfdb" Table="ryc_supported_link"><supported_link_obj>47344.66</supported_link_obj>
<object_type_obj>47340.66</object_type_obj>
<smartlink_type_obj>1003183651</smartlink_type_obj>
<link_source>yes</link_source>
<link_target>no</link_target>
<deactivated_link_on_hide>no</deactivated_link_on_hide>
</contained_record>
<contained_record DB="icfdb" Table="ryc_supported_link"><supported_link_obj>47345.66</supported_link_obj>
<object_type_obj>47340.66</object_type_obj>
<smartlink_type_obj>1003518046</smartlink_type_obj>
<link_source>yes</link_source>
<link_target>no</link_target>
<deactivated_link_on_hide>no</deactivated_link_on_hide>
</contained_record>
<contained_record DB="icfdb" Table="ryc_supported_link"><supported_link_obj>47346.66</supported_link_obj>
<object_type_obj>47340.66</object_type_obj>
<smartlink_type_obj>1003543798</smartlink_type_obj>
<link_source>yes</link_source>
<link_target>no</link_target>
<deactivated_link_on_hide>no</deactivated_link_on_hide>
</contained_record>
<contained_record DB="icfdb" Table="ryc_supported_link"><supported_link_obj>47342.66</supported_link_obj>
<object_type_obj>47340.66</object_type_obj>
<smartlink_type_obj>1004947046.09</smartlink_type_obj>
<link_source>yes</link_source>
<link_target>no</link_target>
<deactivated_link_on_hide>no</deactivated_link_on_hide>
</contained_record>
</contained_record>
</dataset_transaction>
</dataset_records>
</dataset>