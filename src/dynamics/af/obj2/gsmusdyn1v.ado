<?xml version="1.0" encoding="utf-8" ?>
<dataset Transactions="1"><dataset_header DisableRI="yes" DatasetObj="1004928896.09" DateFormat="mdy" FullHeader="yes" SCMManaged="yes" YearOffset="1950" DatasetCode="RYCSO" NumericFormat="AMERICAN" NumericDecimal="." OriginatingSite="90" NumericSeparator=","><deploy_dataset_obj>1004928896.09</deploy_dataset_obj>
<dataset_code>RYCSO</dataset_code>
<dataset_description>ryc_smartobjects - Logical Objects</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>yes</source_code_data>
<deploy_full_data>no</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<deploy_additions_only>no</deploy_additions_only>
<enable_data_versioning>yes</enable_data_versioning>
<deletion_dataset>yes</deletion_dataset>
<dataset_entity><dataset_entity_obj>1004928912.09</dataset_entity_obj>
<deploy_dataset_obj>1004928896.09</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>RYCSO</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>object_filename</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
<exclude_field_list></exclude_field_list>
<entity_mnemonic_description>ryc_smartobject</entity_mnemonic_description>
<entity_dbname>ICFDB</entity_dbname>
</dataset_entity>
<dataset_entity><dataset_entity_obj>3000004908.09</dataset_entity_obj>
<deploy_dataset_obj>1004928896.09</deploy_dataset_obj>
<entity_sequence>2</entity_sequence>
<entity_mnemonic>RYCUE</entity_mnemonic>
<primary_entity>no</primary_entity>
<join_entity_mnemonic>RYCSO</join_entity_mnemonic>
<join_field_list>primary_smartobject_obj,smartobject_obj</join_field_list>
<filter_where_clause></filter_where_clause>
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
<dataset_entity><dataset_entity_obj>1004928913.09</dataset_entity_obj>
<deploy_dataset_obj>1004928896.09</deploy_dataset_obj>
<entity_sequence>4</entity_sequence>
<entity_mnemonic>RYCPA</entity_mnemonic>
<primary_entity>no</primary_entity>
<join_entity_mnemonic>rycso</join_entity_mnemonic>
<join_field_list>container_smartobject_obj,smartobject_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
<exclude_field_list></exclude_field_list>
<entity_mnemonic_description>ryc_page</entity_mnemonic_description>
<entity_dbname>ICFDB</entity_dbname>
</dataset_entity>
<dataset_entity><dataset_entity_obj>1004936275.09</dataset_entity_obj>
<deploy_dataset_obj>1004928896.09</deploy_dataset_obj>
<entity_sequence>5</entity_sequence>
<entity_mnemonic>RYCOI</entity_mnemonic>
<primary_entity>no</primary_entity>
<join_entity_mnemonic>rycso</join_entity_mnemonic>
<join_field_list>container_smartobject_obj,smartobject_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
<exclude_field_list></exclude_field_list>
<entity_mnemonic_description>ryc_object_instance</entity_mnemonic_description>
<entity_dbname>ICFDB</entity_dbname>
</dataset_entity>
<dataset_entity><dataset_entity_obj>1004936279.09</dataset_entity_obj>
<deploy_dataset_obj>1004928896.09</deploy_dataset_obj>
<entity_sequence>6</entity_sequence>
<entity_mnemonic>RYCSM</entity_mnemonic>
<primary_entity>no</primary_entity>
<join_entity_mnemonic>rycso</join_entity_mnemonic>
<join_field_list>container_smartobject_obj,smartobject_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
<exclude_field_list></exclude_field_list>
<entity_mnemonic_description>ryc_smartlink</entity_mnemonic_description>
<entity_dbname>ICFDB</entity_dbname>
</dataset_entity>
<dataset_entity><dataset_entity_obj>1004936297.09</dataset_entity_obj>
<deploy_dataset_obj>1004928896.09</deploy_dataset_obj>
<entity_sequence>7</entity_sequence>
<entity_mnemonic>RYCAV</entity_mnemonic>
<primary_entity>no</primary_entity>
<join_entity_mnemonic>rycso</join_entity_mnemonic>
<join_field_list>primary_smartobject_obj,smartobject_obj</join_field_list>
<filter_where_clause></filter_where_clause>
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
<dataset_entity><dataset_entity_obj>1007600052.08</dataset_entity_obj>
<deploy_dataset_obj>1004928896.09</deploy_dataset_obj>
<entity_sequence>8</entity_sequence>
<entity_mnemonic>RYCUE</entity_mnemonic>
<primary_entity>no</primary_entity>
<join_entity_mnemonic>RYCSO</join_entity_mnemonic>
<join_field_list>container_smartobject_obj,smartobject_obj</join_field_list>
<filter_where_clause></filter_where_clause>
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
<dataset_entity><dataset_entity_obj>1007600053.08</dataset_entity_obj>
<deploy_dataset_obj>1004928896.09</deploy_dataset_obj>
<entity_sequence>9</entity_sequence>
<entity_mnemonic>RYMDV</entity_mnemonic>
<primary_entity>no</primary_entity>
<join_entity_mnemonic>RYCSO</join_entity_mnemonic>
<join_field_list>related_entity_key,smartobject_obj</join_field_list>
<filter_where_clause>related_entity_mnemonic = &quot;RYCSO&quot;</filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
<exclude_field_list></exclude_field_list>
<entity_mnemonic_description>rym_data_version</entity_mnemonic_description>
<entity_dbname>ICFDB</entity_dbname>
</dataset_entity>
<dataset_entity><dataset_entity_obj>1007600095.08</dataset_entity_obj>
<deploy_dataset_obj>1004928896.09</deploy_dataset_obj>
<entity_sequence>10</entity_sequence>
<entity_mnemonic>GSMTM</entity_mnemonic>
<primary_entity>no</primary_entity>
<join_entity_mnemonic>RYCSO</join_entity_mnemonic>
<join_field_list>object_obj,smartobject_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
<exclude_field_list></exclude_field_list>
<entity_mnemonic_description>gsm_toolbar_menu_structure</entity_mnemonic_description>
<entity_dbname>ICFDB</entity_dbname>
</dataset_entity>
<dataset_entity><dataset_entity_obj>1007600096.08</dataset_entity_obj>
<deploy_dataset_obj>1004928896.09</deploy_dataset_obj>
<entity_sequence>11</entity_sequence>
<entity_mnemonic>GSMOM</entity_mnemonic>
<primary_entity>no</primary_entity>
<join_entity_mnemonic>RYCSO</join_entity_mnemonic>
<join_field_list>object_obj,smartobject_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
<exclude_field_list></exclude_field_list>
<entity_mnemonic_description>gsm_object_menu_structure</entity_mnemonic_description>
<entity_dbname>ICFDB</entity_dbname>
</dataset_entity>
<dataset_entity><dataset_entity_obj>3000000079.09</dataset_entity_obj>
<deploy_dataset_obj>1004928896.09</deploy_dataset_obj>
<entity_sequence>12</entity_sequence>
<entity_mnemonic>GSMVP</entity_mnemonic>
<primary_entity>no</primary_entity>
<join_entity_mnemonic>RYCSO</join_entity_mnemonic>
<join_field_list>object_obj,smartobject_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
<exclude_field_list></exclude_field_list>
<entity_mnemonic_description>gsm_valid_object_partition</entity_mnemonic_description>
<entity_dbname>ICFDB</entity_dbname>
</dataset_entity>
<table_definition><name>ryc_smartobject</name>
<dbname>icfdb</dbname>
<index-1>XAK1ryc_smartobject,1,0,0,object_filename,0,customization_result_obj,0</index-1>
<index-2>XAK3ryc_smartobject,1,0,0,product_module_obj,0,object_filename,0,customization_result_obj,0</index-2>
<index-3>XIE10ryc_smartobject,0,0,0,runnable_from_menu,0</index-3>
<index-4>XIE11ryc_smartobject,0,0,0,template_smartobject,0</index-4>
<index-5>XIE1ryc_smartobject,0,0,0,sdo_smartobject_obj,0</index-5>
<index-6>XIE2ryc_smartobject,0,0,0,layout_obj,0,object_type_obj,0</index-6>
<index-7>XIE5ryc_smartobject,0,0,0,extends_smartobject_obj,0</index-7>
<index-8>XIE6ryc_smartobject,0,0,0,customization_result_obj,0</index-8>
<index-9>XIE7ryc_smartobject,0,0,0,object_type_obj,0</index-9>
<index-10>XIE8ryc_smartobject,0,0,0,security_smartobject_obj,0</index-10>
<index-11>XIE9ryc_smartobject,0,0,0,object_description,0</index-11>
<index-12>XPKryc_smartobject,1,1,0,smartobject_obj,0</index-12>
<field><name>smartobject_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Smartobject obj</label>
<column-label>Smartobject obj</column-label>
</field>
<field><name>object_filename</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Object filename</label>
<column-label>Object filename</column-label>
</field>
<field><name>customization_result_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Customization result obj</label>
<column-label>Customization result obj</column-label>
</field>
<field><name>object_type_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Object type obj</label>
<column-label>Object type obj</column-label>
</field>
<field><name>product_module_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Product module obj</label>
<column-label>Product module obj</column-label>
</field>
<field><name>layout_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Layout obj</label>
<column-label>Layout obj</column-label>
</field>
<field><name>object_description</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>Object description</label>
<column-label>Object description</column-label>
</field>
<field><name>object_path</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Object path</label>
<column-label>Object path</column-label>
</field>
<field><name>object_extension</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>Object extension</label>
<column-label>Object extension</column-label>
</field>
<field><name>static_object</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>Static object</label>
<column-label>Static object</column-label>
</field>
<field><name>generic_object</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>Generic object</label>
<column-label>Generic object</column-label>
</field>
<field><name>template_smartobject</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>Template smartobject</label>
<column-label>Template smartobject</column-label>
</field>
<field><name>system_owned</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>System owned</label>
<column-label>System owned</column-label>
</field>
<field><name>deployment_type</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>Deployment type</label>
<column-label>Deployment type</column-label>
</field>
<field><name>design_only</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>Design only</label>
<column-label>Design only</column-label>
</field>
<field><name>runnable_from_menu</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>YES</initial>
<label>Runnable from menu</label>
<column-label>Runnable from menu</column-label>
</field>
<field><name>container_object</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>YES</initial>
<label>Container object</label>
<column-label>Container object</column-label>
</field>
<field><name>disabled</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>Disabled</label>
<column-label>Disabled</column-label>
</field>
<field><name>run_persistent</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>YES</initial>
<label>Run persistent</label>
<column-label>Run persistent</column-label>
</field>
<field><name>run_when</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(3)</format>
<initial></initial>
<label>Run when</label>
<column-label>Run when</column-label>
</field>
<field><name>shutdown_message_text</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Shutdown message text</label>
<column-label>Shutdown message text</column-label>
</field>
<field><name>required_db_list</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>Required DB list</label>
<column-label>Required DB list</column-label>
</field>
<field><name>sdo_smartobject_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>SDO smartobject obj</label>
<column-label>SDO smartobject obj</column-label>
</field>
<field><name>extends_smartobject_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Extends smartobject obj</label>
<column-label>Extends smartobject obj</column-label>
</field>
<field><name>security_smartobject_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Security smartobject obj</label>
<column-label>Security smartobject obj</column-label>
</field>
<field><name>object_is_runnable</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>YES</initial>
<label>Object is runnable</label>
<column-label>Object is runnable</column-label>
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
<table_definition><name>ryc_page</name>
<dbname>icfdb</dbname>
<index-1>XAK1ryc_page,1,0,0,container_smartobject_obj,0,page_sequence,0</index-1>
<index-2>XAK2ryc_page,1,0,0,container_smartobject_obj,0,page_reference,0</index-2>
<index-3>XIE1ryc_page,0,0,0,layout_obj,0,container_smartobject_obj,0</index-3>
<index-4>XPKryc_page,1,1,0,page_obj,0</index-4>
<field><name>page_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Page obj</label>
<column-label>Page obj</column-label>
</field>
<field><name>container_smartobject_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Container smartobject obj</label>
<column-label>Container smartobject obj</column-label>
</field>
<field><name>layout_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Layout obj</label>
<column-label>Layout obj</column-label>
</field>
<field><name>page_sequence</name>
<data-type>integer</data-type>
<extent>0</extent>
<format>-&gt;9</format>
<initial>  0</initial>
<label>Page sequence</label>
<column-label>Page sequence</column-label>
</field>
<field><name>page_reference</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(28)</format>
<initial></initial>
<label>Page reference</label>
<column-label>Page reference</column-label>
</field>
<field><name>page_label</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(28)</format>
<initial></initial>
<label>Page label</label>
<column-label>Page label</column-label>
</field>
<field><name>security_token</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(28)</format>
<initial></initial>
<label>Security token</label>
<column-label>Security token</column-label>
</field>
<field><name>enable_on_create</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>YES</initial>
<label>Enable on create</label>
<column-label>Enable on create</column-label>
</field>
<field><name>enable_on_modify</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>YES</initial>
<label>Enable on modify</label>
<column-label>Enable on modify</column-label>
</field>
<field><name>enable_on_view</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>YES</initial>
<label>Enable on view</label>
<column-label>Enable on view</column-label>
</field>
</table_definition>
<table_definition><name>ryc_object_instance</name>
<dbname>icfdb</dbname>
<index-1>XAK1ryc_object_instance,1,0,0,container_smartobject_obj,0,instance_name,0</index-1>
<index-2>XIE1ryc_object_instance,0,0,0,smartobject_obj,0</index-2>
<index-3>XIE3ryc_object_instance,0,0,0,container_smartobject_obj,0,smartobject_obj,0,layout_position,0</index-3>
<index-4>XIE4ryc_object_instance,0,0,0,instance_name,0</index-4>
<index-5>XIE5ryc_object_instance,0,0,0,instance_description,0</index-5>
<index-6>XIE6ryc_object_instance,0,0,0,container_smartobject_obj,0,page_obj,0,object_sequence,0</index-6>
<index-7>XIE7ryc_object_instance,0,0,0,page_obj,0</index-7>
<index-8>XPKryc_object_instance,1,1,0,object_instance_obj,0</index-8>
<field><name>object_instance_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Object instance obj</label>
<column-label>Object instance obj</column-label>
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
<field><name>system_owned</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>System owned</label>
<column-label>System owned</column-label>
</field>
<field><name>layout_position</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(15)</format>
<initial></initial>
<label>Layout position</label>
<column-label>Layout position</column-label>
</field>
<field><name>instance_name</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>Instance name</label>
<column-label>Instance name</column-label>
</field>
<field><name>instance_description</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Instance description</label>
<column-label>Instance description</column-label>
</field>
<field><name>page_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Page obj</label>
<column-label>Page obj</column-label>
</field>
<field><name>object_sequence</name>
<data-type>integer</data-type>
<extent>0</extent>
<format>-&gt;&gt;9</format>
<initial>   0</initial>
<label>Object sequence</label>
<column-label>Object sequence</column-label>
</field>
</table_definition>
<table_definition><name>ryc_smartlink</name>
<dbname>icfdb</dbname>
<index-1>XAK1ryc_smartlink,1,0,0,container_smartobject_obj,0,source_object_instance_obj,0,link_name,0,target_object_instance_obj,0</index-1>
<index-2>XIE1ryc_smartlink,0,0,0,link_name,0,container_smartobject_obj,0</index-2>
<index-3>XIE2ryc_smartlink,0,0,0,smartlink_type_obj,0,container_smartobject_obj,0</index-3>
<index-4>XIE3ryc_smartlink,0,0,0,source_object_instance_obj,0,container_smartobject_obj,0</index-4>
<index-5>XIE4ryc_smartlink,0,0,0,target_object_instance_obj,0,container_smartobject_obj,0</index-5>
<index-6>XPKryc_smartlink,1,1,0,smartlink_obj,0</index-6>
<field><name>smartlink_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Smartlink obj</label>
<column-label>Smartlink obj</column-label>
</field>
<field><name>container_smartobject_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Container smartobject obj</label>
<column-label>Container smartobject obj</column-label>
</field>
<field><name>smartlink_type_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Smartlink type obj</label>
<column-label>Smartlink type obj</column-label>
</field>
<field><name>link_name</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(28)</format>
<initial></initial>
<label>Link name</label>
<column-label>Link name</column-label>
</field>
<field><name>source_object_instance_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Source object instance obj</label>
<column-label>Source object instance obj</column-label>
</field>
<field><name>target_object_instance_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Target object instance obj</label>
<column-label>Target object instance obj</column-label>
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
<table_definition><name>rym_data_version</name>
<dbname>icfdb</dbname>
<index-1>XAK1rym_data_version,1,0,0,related_entity_mnemonic,0,related_entity_key,0</index-1>
<index-2>XPKrym_data_version,1,1,0,data_version_obj,0</index-2>
<field><name>data_version_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Data version obj</label>
<column-label>Data version obj</column-label>
</field>
<field><name>related_entity_mnemonic</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(8)</format>
<initial></initial>
<label>Related entity</label>
<column-label>Related entity</column-label>
</field>
<field><name>related_entity_key</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Related entity key</label>
<column-label>Related entity key</column-label>
</field>
<field><name>data_version_number</name>
<data-type>integer</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;9</format>
<initial>      0</initial>
<label>Data version number</label>
<column-label>Data version number</column-label>
</field>
</table_definition>
<table_definition><name>gsm_toolbar_menu_structure</name>
<dbname>icfdb</dbname>
<index-1>XAK1gsm_toolbar_menu_structure,1,0,0,toolbar_menu_structure_obj,0</index-1>
<index-2>XIE1gsm_toolbar_menu_structure,0,0,0,menu_structure_obj,0</index-2>
<index-3>XPKgsm_toolbar_menu_structure,1,1,0,object_obj,0,menu_structure_sequence,0,menu_structure_obj,0</index-3>
<field><name>object_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Object obj</label>
<column-label>Object obj</column-label>
</field>
<field><name>menu_structure_sequence</name>
<data-type>integer</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;9</format>
<initial>    0</initial>
<label>Menu structure sequence</label>
<column-label>Menu structure sequence</column-label>
</field>
<field><name>menu_structure_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Menu structure obj</label>
<column-label>Menu structure obj</column-label>
</field>
<field><name>toolbar_menu_structure_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Toolbar menu structure obj</label>
<column-label>Toolbar menu structure obj</column-label>
</field>
<field><name>menu_structure_spacing</name>
<data-type>integer</data-type>
<extent>0</extent>
<format>-&gt;&gt;9</format>
<initial>   0</initial>
<label>Menu structure spacing</label>
<column-label>Menu structure spacing</column-label>
</field>
<field><name>menu_structure_alignment</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(10)</format>
<initial></initial>
<label>Menu structure alignment</label>
<column-label>Menu structure alignment</column-label>
</field>
<field><name>menu_structure_row</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(10)</format>
<initial></initial>
<label>Menu structure row</label>
<column-label>Menu structure row</column-label>
</field>
<field><name>insert_rule</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>YES</initial>
<label>Insert rule</label>
<column-label>Insert rule</column-label>
</field>
</table_definition>
<table_definition><name>gsm_object_menu_structure</name>
<dbname>icfdb</dbname>
<index-1>XAK1gsm_object_menu_structure,1,0,0,menu_structure_obj,0,object_obj,0,instance_attribute_obj,0</index-1>
<index-2>XAK2gsm_object_menu_structure,1,0,0,object_menu_structure_obj,0</index-2>
<index-3>XIE1gsm_object_menu_structure,0,0,0,instance_attribute_obj,0</index-3>
<index-4>XIE2gsm_object_menu_structure,0,0,0,menu_item_obj,0,object_obj,0,instance_attribute_obj,0</index-4>
<index-5>XPKgsm_object_menu_structure,1,1,0,object_obj,0,menu_structure_obj,0,instance_attribute_obj,0</index-5>
<field><name>object_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Object obj</label>
<column-label>Object obj</column-label>
</field>
<field><name>menu_structure_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Menu structure obj</label>
<column-label>Menu structure obj</column-label>
</field>
<field><name>instance_attribute_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Instance attribute obj</label>
<column-label>Instance attribute obj</column-label>
</field>
<field><name>object_menu_structure_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Object menu structure obj</label>
<column-label>Object menu structure obj</column-label>
</field>
<field><name>menu_item_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Menu item obj</label>
<column-label>Menu item obj</column-label>
</field>
<field><name>insert_submenu</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>YES</initial>
<label>Insert submenu</label>
<column-label>Insert submenu</column-label>
</field>
<field><name>menu_structure_sequence</name>
<data-type>integer</data-type>
<extent>0</extent>
<format>-&gt;&gt;9</format>
<initial>   0</initial>
<label>Menu structure sequence</label>
<column-label>Menu structure sequence</column-label>
</field>
</table_definition>
<table_definition><name>gsm_valid_object_partition</name>
<dbname>icfdb</dbname>
<index-1>XAK1gsm_valid_object_partition,1,0,0,logical_service_obj,0,object_obj,0</index-1>
<index-2>XAK2gsm_valid_object_partition,1,0,0,object_obj,0,logical_service_obj,0</index-2>
<index-3>XPKgsm_valid_object_partition,1,1,0,valid_object_partition_obj,0</index-3>
<field><name>valid_object_partition_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Valid object partition obj</label>
<column-label>Valid object partition obj</column-label>
</field>
<field><name>logical_service_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Logical service obj</label>
<column-label>Logical service obj</column-label>
</field>
<field><name>object_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Object obj</label>
<column-label>Object obj</column-label>
</field>
</table_definition>
</dataset_header>
<dataset_records><dataset_transaction TransactionNo="1" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_smartobject" version_date="10/03/2003" version_time="48757" version_user="admin" deletion_flag="no" entity_mnemonic="RYCSO" key_field_value="124862.9875" record_version_obj="124863.9875" version_number_seq="4.09" secondary_key_value="gsmusdyn1v#CHR(1)#0" import_version_number_seq="4.09"><smartobject_obj>124862.9875</smartobject_obj>
<object_filename>gsmusdyn1v</object_filename>
<customization_result_obj>0</customization_result_obj>
<object_type_obj>1003498162</object_type_obj>
<product_module_obj>1004874683.09</product_module_obj>
<layout_obj>0</layout_obj>
<object_description>User Maintenance - Detail viewer</object_description>
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
<sdo_smartobject_obj>124807.9875</sdo_smartobject_obj>
<extends_smartobject_obj>0</extends_smartobject_obj>
<security_smartobject_obj>124966.9875</security_smartobject_obj>
<object_is_runnable>yes</object_is_runnable>
<contained_record DB="icfdb" Table="ryc_ui_event"><ui_event_obj>125244.9875</ui_event_obj>
<object_type_obj>5483.409</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>6304.409</smartobject_obj>
<object_instance_obj>124986.9875</object_instance_obj>
<event_name>CHOOSE</event_name>
<constant_value>no</constant_value>
<action_type>RUN</action_type>
<action_target>SELF</action_target>
<event_action>chooseButton</event_action>
<event_parameter>Password</event_parameter>
<event_disabled>no</event_disabled>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
</contained_record>
<contained_record DB="icfdb" Table="ryc_ui_event"><ui_event_obj>125245.9875</ui_event_obj>
<object_type_obj>5483.409</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>6304.409</smartobject_obj>
<object_instance_obj>124994.9875</object_instance_obj>
<event_name>CHOOSE</event_name>
<constant_value>no</constant_value>
<action_type>RUN</action_type>
<action_target>SELF</action_target>
<event_action>chooseButton</event_action>
<event_parameter>Confirm</event_parameter>
<event_disabled>no</event_disabled>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
</contained_record>
<contained_record DB="icfdb" Table="ryc_ui_event"><ui_event_obj>125246.9875</ui_event_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>3000023555.09</smartobject_obj>
<object_instance_obj>125009.9875</object_instance_obj>
<event_name>LEAVE</event_name>
<constant_value>no</constant_value>
<action_type>RUN</action_type>
<action_target>SELF</action_target>
<event_action>leaveLoginName</event_action>
<event_parameter></event_parameter>
<event_disabled>no</event_disabled>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
</contained_record>
<contained_record DB="icfdb" Table="ryc_ui_event"><ui_event_obj>125247.9875</ui_event_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>3000023627.09</smartobject_obj>
<object_instance_obj>125027.9875</object_instance_obj>
<event_name>VALUE-CHANGED</event_name>
<constant_value>no</constant_value>
<action_type>RUN</action_type>
<action_target>SELF</action_target>
<event_action>changeProfileUser</event_action>
<event_parameter></event_parameter>
<event_disabled>no</event_disabled>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
</contained_record>
<contained_record DB="icfdb" Table="ryc_object_instance"><object_instance_obj>124986.9875</object_instance_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>6304.409</smartobject_obj>
<system_owned>no</system_owned>
<layout_position></layout_position>
<instance_name>buBlank</instance_name>
<instance_description>Dynamic BUTTON</instance_description>
<page_obj>0</page_obj>
<object_sequence>13</object_sequence>
</contained_record>
<contained_record DB="icfdb" Table="ryc_object_instance"><object_instance_obj>124994.9875</object_instance_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>6304.409</smartobject_obj>
<system_owned>no</system_owned>
<layout_position></layout_position>
<instance_name>buBlank2</instance_name>
<instance_description>Dynamic BUTTON</instance_description>
<page_obj>0</page_obj>
<object_sequence>15</object_sequence>
</contained_record>
<contained_record DB="icfdb" Table="ryc_object_instance"><object_instance_obj>125124.9875</object_instance_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>3000023963.09</smartobject_obj>
<system_owned>no</system_owned>
<layout_position></layout_position>
<instance_name>check_password_history</instance_name>
<instance_description>DataField of type TOGGLE-BOX</instance_description>
<page_obj>0</page_obj>
<object_sequence>20</object_sequence>
</contained_record>
<contained_record DB="icfdb" Table="ryc_object_instance"><object_instance_obj>124981.9875</object_instance_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>124827.9875</smartobject_obj>
<system_owned>no</system_owned>
<layout_position></layout_position>
<instance_name>confirm_password</instance_name>
<instance_description>Dynamic FILL-IN</instance_description>
<page_obj>0</page_obj>
<object_sequence>14</object_sequence>
</contained_record>
<contained_record DB="icfdb" Table="ryc_object_instance"><object_instance_obj>125059.9875</object_instance_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>124766.9875</smartobject_obj>
<system_owned>no</system_owned>
<layout_position></layout_position>
<instance_name>created_from_profile_user_obj</instance_name>
<instance_description>SmartDataField of type DynLookup</instance_description>
<page_obj>0</page_obj>
<object_sequence>8</object_sequence>
</contained_record>
<contained_record DB="icfdb" Table="ryc_object_instance"><object_instance_obj>125131.9875</object_instance_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>125066.9875</smartobject_obj>
<system_owned>no</system_owned>
<layout_position></layout_position>
<instance_name>default_login_company_obj</instance_name>
<instance_description>SmartDataField of type DynLookup</instance_description>
<page_obj>0</page_obj>
<object_sequence>22</object_sequence>
</contained_record>
<contained_record DB="icfdb" Table="ryc_object_instance"><object_instance_obj>125033.9875</object_instance_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>3000024179.09</smartobject_obj>
<system_owned>no</system_owned>
<layout_position></layout_position>
<instance_name>development_user</instance_name>
<instance_description>DataField of type TOGGLE-BOX</instance_description>
<page_obj>0</page_obj>
<object_sequence>6</object_sequence>
</contained_record>
<contained_record DB="icfdb" Table="ryc_object_instance"><object_instance_obj>125021.9875</object_instance_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>3000024035.09</smartobject_obj>
<system_owned>no</system_owned>
<layout_position></layout_position>
<instance_name>disabled</instance_name>
<instance_description>DataField of type TOGGLE-BOX</instance_description>
<page_obj>0</page_obj>
<object_sequence>3</object_sequence>
</contained_record>
<contained_record DB="icfdb" Table="ryc_object_instance"><object_instance_obj>125002.9875</object_instance_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>15870.409</smartobject_obj>
<system_owned>no</system_owned>
<layout_position></layout_position>
<instance_name>fiProfileUserName</instance_name>
<instance_description>Dynamic FILL-IN</instance_description>
<page_obj>0</page_obj>
<object_sequence>9</object_sequence>
</contained_record>
<contained_record DB="icfdb" Table="ryc_object_instance"><object_instance_obj>125097.9875</object_instance_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>124849.9875</smartobject_obj>
<system_owned>no</system_owned>
<layout_position></layout_position>
<instance_name>fmt_password_create_time</instance_name>
<instance_description>Dynamic FILL-IN</instance_description>
<page_obj>0</page_obj>
<object_sequence>17</object_sequence>
</contained_record>
<contained_record DB="icfdb" Table="ryc_object_instance"><object_instance_obj>125045.9875</object_instance_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>124837.9875</smartobject_obj>
<system_owned>no</system_owned>
<layout_position></layout_position>
<instance_name>fmt_user_create_time</instance_name>
<instance_description>Dynamic FILL-IN</instance_description>
<page_obj>0</page_obj>
<object_sequence>11</object_sequence>
</contained_record>
<contained_record DB="icfdb" Table="ryc_object_instance"><object_instance_obj>125106.9875</object_instance_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>1000000761.28</smartobject_obj>
<system_owned>no</system_owned>
<layout_position></layout_position>
<instance_name>language_obj</instance_name>
<instance_description>SmartDataField of type DynCombo</instance_description>
<page_obj>0</page_obj>
<object_sequence>21</object_sequence>
</contained_record>
<contained_record DB="icfdb" Table="ryc_object_instance"><object_instance_obj>125039.9875</object_instance_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>3000024107.09</smartobject_obj>
<system_owned>no</system_owned>
<layout_position></layout_position>
<instance_name>maintain_system_data</instance_name>
<instance_description>DataField of type TOGGLE-BOX</instance_description>
<page_obj>0</page_obj>
<object_sequence>7</object_sequence>
</contained_record>
<contained_record DB="icfdb" Table="ryc_object_instance"><object_instance_obj>125090.9875</object_instance_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>3000023843.09</smartobject_obj>
<system_owned>no</system_owned>
<layout_position></layout_position>
<instance_name>password_creation_date</instance_name>
<instance_description>DataField of type FILL-IN</instance_description>
<page_obj>0</page_obj>
<object_sequence>16</object_sequence>
</contained_record>
<contained_record DB="icfdb" Table="ryc_object_instance"><object_instance_obj>125112.9875</object_instance_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>3000023747.09</smartobject_obj>
<system_owned>no</system_owned>
<layout_position></layout_position>
<instance_name>password_preexpired</instance_name>
<instance_description>DataField of type TOGGLE-BOX</instance_description>
<page_obj>0</page_obj>
<object_sequence>18</object_sequence>
</contained_record>
<contained_record DB="icfdb" Table="ryc_object_instance"><object_instance_obj>125027.9875</object_instance_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>3000023627.09</smartobject_obj>
<system_owned>no</system_owned>
<layout_position></layout_position>
<instance_name>profile_user</instance_name>
<instance_description>DataField of type TOGGLE-BOX</instance_description>
<page_obj>0</page_obj>
<object_sequence>5</object_sequence>
</contained_record>
<contained_record DB="icfdb" Table="ryc_object_instance"><object_instance_obj>125118.9875</object_instance_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>3000023939.09</smartobject_obj>
<system_owned>no</system_owned>
<layout_position></layout_position>
<instance_name>update_password_history</instance_name>
<instance_description>DataField of type TOGGLE-BOX</instance_description>
<page_obj>0</page_obj>
<object_sequence>19</object_sequence>
</contained_record>
<contained_record DB="icfdb" Table="ryc_object_instance"><object_instance_obj>125052.9875</object_instance_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>124790.9875</smartobject_obj>
<system_owned>no</system_owned>
<layout_position></layout_position>
<instance_name>user_category_obj</instance_name>
<instance_description>SmartDataField of type DynCombo</instance_description>
<page_obj>0</page_obj>
<object_sequence>4</object_sequence>
</contained_record>
<contained_record DB="icfdb" Table="ryc_object_instance"><object_instance_obj>124970.9875</object_instance_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>3000023579.09</smartobject_obj>
<system_owned>no</system_owned>
<layout_position></layout_position>
<instance_name>user_creation_date</instance_name>
<instance_description>DataField of type FILL-IN</instance_description>
<page_obj>0</page_obj>
<object_sequence>10</object_sequence>
</contained_record>
<contained_record DB="icfdb" Table="ryc_object_instance"><object_instance_obj>125015.9875</object_instance_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>3000023531.09</smartobject_obj>
<system_owned>no</system_owned>
<layout_position></layout_position>
<instance_name>user_full_name</instance_name>
<instance_description>DataField of type FILL-IN</instance_description>
<page_obj>0</page_obj>
<object_sequence>2</object_sequence>
</contained_record>
<contained_record DB="icfdb" Table="ryc_object_instance"><object_instance_obj>125009.9875</object_instance_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>3000023555.09</smartobject_obj>
<system_owned>no</system_owned>
<layout_position></layout_position>
<instance_name>user_login_name</instance_name>
<instance_description>DataField of type FILL-IN</instance_description>
<page_obj>0</page_obj>
<object_sequence>1</object_sequence>
</contained_record>
<contained_record DB="icfdb" Table="ryc_object_instance"><object_instance_obj>124976.9875</object_instance_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>3000023699.09</smartobject_obj>
<system_owned>no</system_owned>
<layout_position></layout_position>
<instance_name>user_password</instance_name>
<instance_description>DataField of type FILL-IN</instance_description>
<page_obj>0</page_obj>
<object_sequence>12</object_sequence>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>3000052879.09</attribute_value_obj>
<object_type_obj>1003498162</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>124862.9875</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>AppBuilderTabbing</attribute_label>
<character_value>Custom</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>no</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>124991.9875</attribute_value_obj>
<object_type_obj>5483.409</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>6304.409</smartobject_obj>
<object_instance_obj>124986.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>BGCOLOR</attribute_label>
<character_value></character_value>
<integer_value>8</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>124999.9875</attribute_value_obj>
<object_type_obj>5483.409</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>6304.409</smartobject_obj>
<object_instance_obj>124994.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>BGCOLOR</attribute_label>
<character_value></character_value>
<integer_value>8</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125322.9875</attribute_value_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>3000023699.09</smartobject_obj>
<object_instance_obj>124976.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>BLANK</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>yes</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125323.9875</attribute_value_obj>
<object_type_obj>17917.66</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>124827.9875</smartobject_obj>
<object_instance_obj>124981.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>BLANK</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>yes</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>124971.9875</attribute_value_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>3000023579.09</smartobject_obj>
<object_instance_obj>124970.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>CHECKED</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>yes</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125091.9875</attribute_value_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>3000023843.09</smartobject_obj>
<object_instance_obj>125090.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>CHECKED</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>?</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>124972.9875</attribute_value_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>3000023579.09</smartobject_obj>
<object_instance_obj>124970.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>COLUMN</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>24.2</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>124977.9875</attribute_value_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>3000023699.09</smartobject_obj>
<object_instance_obj>124976.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>COLUMN</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>24.2</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>124982.9875</attribute_value_obj>
<object_type_obj>17917.66</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>124827.9875</smartobject_obj>
<object_instance_obj>124981.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>COLUMN</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>24.2</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>124992.9875</attribute_value_obj>
<object_type_obj>5483.409</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>6304.409</smartobject_obj>
<object_instance_obj>124986.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>COLUMN</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>61.8</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125000.9875</attribute_value_obj>
<object_type_obj>5483.409</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>6304.409</smartobject_obj>
<object_instance_obj>124994.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>COLUMN</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>61.8</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125006.9875</attribute_value_obj>
<object_type_obj>473.99</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>15870.409</smartobject_obj>
<object_instance_obj>125002.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>COLUMN</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>54.2</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125010.9875</attribute_value_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>3000023555.09</smartobject_obj>
<object_instance_obj>125009.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>COLUMN</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>24.2</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125016.9875</attribute_value_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>3000023531.09</smartobject_obj>
<object_instance_obj>125015.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>COLUMN</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>24.2</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125022.9875</attribute_value_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>3000024035.09</smartobject_obj>
<object_instance_obj>125021.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>COLUMN</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>65.8</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125028.9875</attribute_value_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>3000023627.09</smartobject_obj>
<object_instance_obj>125027.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>COLUMN</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>24.2</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125034.9875</attribute_value_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>3000024179.09</smartobject_obj>
<object_instance_obj>125033.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>COLUMN</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>53.2</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125040.9875</attribute_value_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>3000024107.09</smartobject_obj>
<object_instance_obj>125039.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>COLUMN</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>82.6</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125046.9875</attribute_value_obj>
<object_type_obj>17917.66</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>124837.9875</smartobject_obj>
<object_instance_obj>125045.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>COLUMN</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>54.2</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125057.9875</attribute_value_obj>
<object_type_obj>1005111020.101</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>124790.9875</smartobject_obj>
<object_instance_obj>125052.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>COLUMN</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>24.2</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125062.9875</attribute_value_obj>
<object_type_obj>1005097658.101</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>124766.9875</smartobject_obj>
<object_instance_obj>125059.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>COLUMN</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>24.2</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125092.9875</attribute_value_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>3000023843.09</smartobject_obj>
<object_instance_obj>125090.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>COLUMN</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>90.8</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125101.9875</attribute_value_obj>
<object_type_obj>17917.66</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>124849.9875</smartobject_obj>
<object_instance_obj>125097.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>COLUMN</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>90.8</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125110.9875</attribute_value_obj>
<object_type_obj>1005111020.101</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>1000000761.28</smartobject_obj>
<object_instance_obj>125106.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>COLUMN</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>24.2</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125113.9875</attribute_value_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>3000023747.09</smartobject_obj>
<object_instance_obj>125112.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>COLUMN</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>24.2</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125119.9875</attribute_value_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>3000023939.09</smartobject_obj>
<object_instance_obj>125118.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>COLUMN</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>49.8</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125127.9875</attribute_value_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>3000023963.09</smartobject_obj>
<object_instance_obj>125124.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>COLUMN</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>78.6</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125134.9875</attribute_value_obj>
<object_type_obj>1005097658.101</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>125066.9875</smartobject_obj>
<object_instance_obj>125131.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>COLUMN</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>24.2</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>124973.9875</attribute_value_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>3000023579.09</smartobject_obj>
<object_instance_obj>124970.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>ColumnLabel</attribute_label>
<character_value>User creation date</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>124978.9875</attribute_value_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>3000023699.09</smartobject_obj>
<object_instance_obj>124976.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>ColumnLabel</attribute_label>
<character_value>User password</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>124983.9875</attribute_value_obj>
<object_type_obj>17917.66</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>124827.9875</smartobject_obj>
<object_instance_obj>124981.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>ColumnLabel</attribute_label>
<character_value>Confirm Password</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125011.9875</attribute_value_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>3000023555.09</smartobject_obj>
<object_instance_obj>125009.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>ColumnLabel</attribute_label>
<character_value>User login name</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125017.9875</attribute_value_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>3000023531.09</smartobject_obj>
<object_instance_obj>125015.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>ColumnLabel</attribute_label>
<character_value>User full name</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125023.9875</attribute_value_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>3000024035.09</smartobject_obj>
<object_instance_obj>125021.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>ColumnLabel</attribute_label>
<character_value>Disabled</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125029.9875</attribute_value_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>3000023627.09</smartobject_obj>
<object_instance_obj>125027.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>ColumnLabel</attribute_label>
<character_value>Profile user</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125035.9875</attribute_value_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>3000024179.09</smartobject_obj>
<object_instance_obj>125033.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>ColumnLabel</attribute_label>
<character_value>Development user</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125041.9875</attribute_value_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>3000024107.09</smartobject_obj>
<object_instance_obj>125039.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>ColumnLabel</attribute_label>
<character_value>Maintain system data</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125047.9875</attribute_value_obj>
<object_type_obj>17917.66</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>124837.9875</smartobject_obj>
<object_instance_obj>125045.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>ColumnLabel</attribute_label>
<character_value>Time</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125093.9875</attribute_value_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>3000023843.09</smartobject_obj>
<object_instance_obj>125090.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>ColumnLabel</attribute_label>
<character_value>Creation date</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125102.9875</attribute_value_obj>
<object_type_obj>17917.66</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>124849.9875</smartobject_obj>
<object_instance_obj>125097.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>ColumnLabel</attribute_label>
<character_value>Creation time</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125114.9875</attribute_value_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>3000023747.09</smartobject_obj>
<object_instance_obj>125112.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>ColumnLabel</attribute_label>
<character_value>Password preexpired</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125120.9875</attribute_value_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>3000023939.09</smartobject_obj>
<object_instance_obj>125118.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>ColumnLabel</attribute_label>
<character_value>Update password history</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125128.9875</attribute_value_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>3000023963.09</smartobject_obj>
<object_instance_obj>125124.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>ColumnLabel</attribute_label>
<character_value>Check password history</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125242.9875</attribute_value_obj>
<object_type_obj>1005111020.101</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>1000000761.28</smartobject_obj>
<object_instance_obj>125106.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>ComboFlag</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125048.9875</attribute_value_obj>
<object_type_obj>17917.66</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>124837.9875</smartobject_obj>
<object_instance_obj>125045.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>ENABLED</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125103.9875</attribute_value_obj>
<object_type_obj>17917.66</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>124849.9875</smartobject_obj>
<object_instance_obj>125097.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>ENABLED</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125202.9875</attribute_value_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>3000023579.09</smartobject_obj>
<object_instance_obj>124970.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>ENABLED</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125203.9875</attribute_value_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>3000023843.09</smartobject_obj>
<object_instance_obj>125090.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>ENABLED</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125205.9875</attribute_value_obj>
<object_type_obj>473.99</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>15870.409</smartobject_obj>
<object_instance_obj>125002.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>ENABLED</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125054.9875</attribute_value_obj>
<object_type_obj>1005111020.101</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>124790.9875</smartobject_obj>
<object_instance_obj>125052.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>FieldName</attribute_label>
<character_value>user_category_obj</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125060.9875</attribute_value_obj>
<object_type_obj>1005097658.101</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>124766.9875</smartobject_obj>
<object_instance_obj>125059.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>FieldName</attribute_label>
<character_value>created_from_profile_user_obj</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125107.9875</attribute_value_obj>
<object_type_obj>1005111020.101</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>1000000761.28</smartobject_obj>
<object_instance_obj>125106.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>FieldName</attribute_label>
<character_value>language_obj</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125132.9875</attribute_value_obj>
<object_type_obj>1005097658.101</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>125066.9875</smartobject_obj>
<object_instance_obj>125131.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>FieldName</attribute_label>
<character_value>default_login_company_obj</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125243.9875</attribute_value_obj>
<object_type_obj>1005111020.101</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>1000000761.28</smartobject_obj>
<object_instance_obj>125106.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>FlagValue</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125004.9875</attribute_value_obj>
<object_type_obj>473.99</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>15870.409</smartobject_obj>
<object_instance_obj>125002.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>FORMAT</attribute_label>
<character_value>X(35)</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>124988.9875</attribute_value_obj>
<object_type_obj>5483.409</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>6304.409</smartobject_obj>
<object_instance_obj>124986.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>HEIGHT-CHARS</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>1</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>124996.9875</attribute_value_obj>
<object_type_obj>5483.409</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>6304.409</smartobject_obj>
<object_instance_obj>124994.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>HEIGHT-CHARS</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>1</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125055.9875</attribute_value_obj>
<object_type_obj>1005111020.101</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>124790.9875</smartobject_obj>
<object_instance_obj>125052.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>HEIGHT-CHARS</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>1.05</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125108.9875</attribute_value_obj>
<object_type_obj>1005111020.101</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>1000000761.28</smartobject_obj>
<object_instance_obj>125106.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>HEIGHT-CHARS</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>1.05</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125324.9875</attribute_value_obj>
<object_type_obj>17917.66</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>124827.9875</smartobject_obj>
<object_instance_obj>124981.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>HELP</attribute_label>
<character_value>?</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125325.9875</attribute_value_obj>
<object_type_obj>17917.66</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>124837.9875</smartobject_obj>
<object_instance_obj>125045.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>HELP</attribute_label>
<character_value>?</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125327.9875</attribute_value_obj>
<object_type_obj>17917.66</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>124849.9875</smartobject_obj>
<object_instance_obj>125097.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>HELP</attribute_label>
<character_value>?</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>124989.9875</attribute_value_obj>
<object_type_obj>5483.409</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>6304.409</smartobject_obj>
<object_instance_obj>124986.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>LABEL</attribute_label>
<character_value>&amp;Blank</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>124997.9875</attribute_value_obj>
<object_type_obj>5483.409</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>6304.409</smartobject_obj>
<object_instance_obj>124994.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>LABEL</attribute_label>
<character_value>B&amp;lank</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125049.9875</attribute_value_obj>
<object_type_obj>17917.66</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>124837.9875</smartobject_obj>
<object_instance_obj>125045.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>LABEL</attribute_label>
<character_value>Time</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125094.9875</attribute_value_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>3000023843.09</smartobject_obj>
<object_instance_obj>125090.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>LABEL</attribute_label>
<character_value>Creation date</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125104.9875</attribute_value_obj>
<object_type_obj>17917.66</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>124849.9875</smartobject_obj>
<object_instance_obj>125097.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>LABEL</attribute_label>
<character_value>Creation time</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125326.9875</attribute_value_obj>
<object_type_obj>473.99</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>15870.409</smartobject_obj>
<object_instance_obj>125002.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>LABEL</attribute_label>
<character_value>fiProfileUserName</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125005.9875</attribute_value_obj>
<object_type_obj>473.99</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>15870.409</smartobject_obj>
<object_instance_obj>125002.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>LABELS</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125053.9875</attribute_value_obj>
<object_type_obj>1005111020.101</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>124790.9875</smartobject_obj>
<object_instance_obj>125052.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>MasterFile</attribute_label>
<character_value>adm2/dyncombo.w</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>124968.9875</attribute_value_obj>
<object_type_obj>1003498162</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>124862.9875</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>MinHeight</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>12.81</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>124969.9875</attribute_value_obj>
<object_type_obj>1003498162</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>124862.9875</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>MinWidth</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>106.8</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>124974.9875</attribute_value_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>3000023579.09</smartobject_obj>
<object_instance_obj>124970.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>Order</attribute_label>
<character_value></character_value>
<integer_value>10</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>124979.9875</attribute_value_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>3000023699.09</smartobject_obj>
<object_instance_obj>124976.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>Order</attribute_label>
<character_value></character_value>
<integer_value>12</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>124984.9875</attribute_value_obj>
<object_type_obj>17917.66</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>124827.9875</smartobject_obj>
<object_instance_obj>124981.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>Order</attribute_label>
<character_value></character_value>
<integer_value>14</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125012.9875</attribute_value_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>3000023555.09</smartobject_obj>
<object_instance_obj>125009.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>Order</attribute_label>
<character_value></character_value>
<integer_value>1</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125018.9875</attribute_value_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>3000023531.09</smartobject_obj>
<object_instance_obj>125015.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>Order</attribute_label>
<character_value></character_value>
<integer_value>2</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125024.9875</attribute_value_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>3000024035.09</smartobject_obj>
<object_instance_obj>125021.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>Order</attribute_label>
<character_value></character_value>
<integer_value>3</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125030.9875</attribute_value_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>3000023627.09</smartobject_obj>
<object_instance_obj>125027.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>Order</attribute_label>
<character_value></character_value>
<integer_value>5</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125036.9875</attribute_value_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>3000024179.09</smartobject_obj>
<object_instance_obj>125033.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>Order</attribute_label>
<character_value></character_value>
<integer_value>6</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125042.9875</attribute_value_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>3000024107.09</smartobject_obj>
<object_instance_obj>125039.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>Order</attribute_label>
<character_value></character_value>
<integer_value>7</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125050.9875</attribute_value_obj>
<object_type_obj>17917.66</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>124837.9875</smartobject_obj>
<object_instance_obj>125045.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>Order</attribute_label>
<character_value></character_value>
<integer_value>11</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125056.9875</attribute_value_obj>
<object_type_obj>1005111020.101</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>124790.9875</smartobject_obj>
<object_instance_obj>125052.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>Order</attribute_label>
<character_value></character_value>
<integer_value>4</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125061.9875</attribute_value_obj>
<object_type_obj>1005097658.101</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>124766.9875</smartobject_obj>
<object_instance_obj>125059.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>Order</attribute_label>
<character_value></character_value>
<integer_value>8</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125088.9875</attribute_value_obj>
<object_type_obj>5483.409</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>6304.409</smartobject_obj>
<object_instance_obj>124986.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>Order</attribute_label>
<character_value></character_value>
<integer_value>13</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125089.9875</attribute_value_obj>
<object_type_obj>5483.409</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>6304.409</smartobject_obj>
<object_instance_obj>124994.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>Order</attribute_label>
<character_value></character_value>
<integer_value>15</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125095.9875</attribute_value_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>3000023843.09</smartobject_obj>
<object_instance_obj>125090.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>Order</attribute_label>
<character_value></character_value>
<integer_value>16</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125098.9875</attribute_value_obj>
<object_type_obj>17917.66</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>124849.9875</smartobject_obj>
<object_instance_obj>125097.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>Order</attribute_label>
<character_value></character_value>
<integer_value>17</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125105.9875</attribute_value_obj>
<object_type_obj>473.99</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>15870.409</smartobject_obj>
<object_instance_obj>125002.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>Order</attribute_label>
<character_value></character_value>
<integer_value>9</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125109.9875</attribute_value_obj>
<object_type_obj>1005111020.101</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>1000000761.28</smartobject_obj>
<object_instance_obj>125106.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>Order</attribute_label>
<character_value></character_value>
<integer_value>21</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125115.9875</attribute_value_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>3000023747.09</smartobject_obj>
<object_instance_obj>125112.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>Order</attribute_label>
<character_value></character_value>
<integer_value>18</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125121.9875</attribute_value_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>3000023939.09</smartobject_obj>
<object_instance_obj>125118.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>Order</attribute_label>
<character_value></character_value>
<integer_value>19</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125129.9875</attribute_value_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>3000023963.09</smartobject_obj>
<object_instance_obj>125124.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>Order</attribute_label>
<character_value></character_value>
<integer_value>20</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125133.9875</attribute_value_obj>
<object_type_obj>1005097658.101</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>125066.9875</smartobject_obj>
<object_instance_obj>125131.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>Order</attribute_label>
<character_value></character_value>
<integer_value>22</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125204.9875</attribute_value_obj>
<object_type_obj>17917.66</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>124849.9875</smartobject_obj>
<object_instance_obj>125097.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>READ-ONLY</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>yes</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125206.9875</attribute_value_obj>
<object_type_obj>17917.66</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>124837.9875</smartobject_obj>
<object_instance_obj>125045.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>READ-ONLY</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>yes</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>124975.9875</attribute_value_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>3000023579.09</smartobject_obj>
<object_instance_obj>124970.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>ROW</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>6.33</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>124980.9875</attribute_value_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>3000023699.09</smartobject_obj>
<object_instance_obj>124976.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>ROW</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>7.38</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>124985.9875</attribute_value_obj>
<object_type_obj>17917.66</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>124827.9875</smartobject_obj>
<object_instance_obj>124981.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>ROW</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>8.43</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>124993.9875</attribute_value_obj>
<object_type_obj>5483.409</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>6304.409</smartobject_obj>
<object_instance_obj>124986.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>ROW</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>7.43</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125001.9875</attribute_value_obj>
<object_type_obj>5483.409</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>6304.409</smartobject_obj>
<object_instance_obj>124994.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>ROW</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>8.48</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125007.9875</attribute_value_obj>
<object_type_obj>473.99</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>15870.409</smartobject_obj>
<object_instance_obj>125002.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>ROW</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>5.29</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125013.9875</attribute_value_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>3000023555.09</smartobject_obj>
<object_instance_obj>125009.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>ROW</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>1</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125019.9875</attribute_value_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>3000023531.09</smartobject_obj>
<object_instance_obj>125015.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>ROW</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>2.05</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125025.9875</attribute_value_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>3000024035.09</smartobject_obj>
<object_instance_obj>125021.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>ROW</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>1</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125031.9875</attribute_value_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>3000023627.09</smartobject_obj>
<object_instance_obj>125027.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>ROW</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>4.19</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125037.9875</attribute_value_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>3000024179.09</smartobject_obj>
<object_instance_obj>125033.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>ROW</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>4.19</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125043.9875</attribute_value_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>3000024107.09</smartobject_obj>
<object_instance_obj>125039.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>ROW</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>4.19</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125051.9875</attribute_value_obj>
<object_type_obj>17917.66</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>124837.9875</smartobject_obj>
<object_instance_obj>125045.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>ROW</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>6.33</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125058.9875</attribute_value_obj>
<object_type_obj>1005111020.101</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>124790.9875</smartobject_obj>
<object_instance_obj>125052.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>ROW</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>3.1</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125063.9875</attribute_value_obj>
<object_type_obj>1005097658.101</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>124766.9875</smartobject_obj>
<object_instance_obj>125059.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>ROW</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>5.24</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125096.9875</attribute_value_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>3000023843.09</smartobject_obj>
<object_instance_obj>125090.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>ROW</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>7.38</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125099.9875</attribute_value_obj>
<object_type_obj>17917.66</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>124849.9875</smartobject_obj>
<object_instance_obj>125097.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>ROW</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>8.43</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125111.9875</attribute_value_obj>
<object_type_obj>1005111020.101</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>1000000761.28</smartobject_obj>
<object_instance_obj>125106.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>ROW</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>10.71</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125116.9875</attribute_value_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>3000023747.09</smartobject_obj>
<object_instance_obj>125112.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>ROW</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>9.57</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125122.9875</attribute_value_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>3000023939.09</smartobject_obj>
<object_instance_obj>125118.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>ROW</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>9.57</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125125.9875</attribute_value_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>3000023963.09</smartobject_obj>
<object_instance_obj>125124.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>ROW</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>9.57</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125135.9875</attribute_value_obj>
<object_type_obj>1005097658.101</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>125066.9875</smartobject_obj>
<object_instance_obj>125131.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>ROW</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>11.81</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125222.9875</attribute_value_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>3000023579.09</smartobject_obj>
<object_instance_obj>124970.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>ShowPopup</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125223.9875</attribute_value_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>3000023843.09</smartobject_obj>
<object_instance_obj>125090.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>ShowPopup</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>3000050277.09</attribute_value_obj>
<object_type_obj>1003498162</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>124862.9875</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>SuperProcedure</attribute_label>
<character_value>af/obj2/gsmussupr1.p</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>3000052808.09</attribute_value_obj>
<object_type_obj>1003498162</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>124862.9875</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>SuperProcedureMode</attribute_label>
<character_value>STATEFUL</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>124990.9875</attribute_value_obj>
<object_type_obj>5483.409</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>6304.409</smartobject_obj>
<object_instance_obj>124986.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>THREE-D</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>124998.9875</attribute_value_obj>
<object_type_obj>5483.409</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>6304.409</smartobject_obj>
<object_instance_obj>124994.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>THREE-D</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125008.9875</attribute_value_obj>
<object_type_obj>473.99</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>15870.409</smartobject_obj>
<object_instance_obj>125002.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>WIDTH-CHARS</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>52.4</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125014.9875</attribute_value_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>3000023555.09</smartobject_obj>
<object_instance_obj>125009.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>WIDTH-CHARS</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>34.8</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125020.9875</attribute_value_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>3000023531.09</smartobject_obj>
<object_instance_obj>125015.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>WIDTH-CHARS</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>82.4</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125026.9875</attribute_value_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>3000024035.09</smartobject_obj>
<object_instance_obj>125021.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>WIDTH-CHARS</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>18.8</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125032.9875</attribute_value_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>3000023627.09</smartobject_obj>
<object_instance_obj>125027.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>WIDTH-CHARS</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>17.2</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125038.9875</attribute_value_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>3000024179.09</smartobject_obj>
<object_instance_obj>125033.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>WIDTH-CHARS</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>22.8</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125044.9875</attribute_value_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>3000024107.09</smartobject_obj>
<object_instance_obj>125039.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>WIDTH-CHARS</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>24.2</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125100.9875</attribute_value_obj>
<object_type_obj>17917.66</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>124849.9875</smartobject_obj>
<object_instance_obj>125097.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>WIDTH-CHARS</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>15.8</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125117.9875</attribute_value_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>3000023747.09</smartobject_obj>
<object_instance_obj>125112.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>WIDTH-CHARS</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>24.4</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125123.9875</attribute_value_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>3000023939.09</smartobject_obj>
<object_instance_obj>125118.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>WIDTH-CHARS</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>28</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125126.9875</attribute_value_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>3000023963.09</smartobject_obj>
<object_instance_obj>125124.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>WIDTH-CHARS</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>28.2</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>125130.9875</attribute_value_obj>
<object_type_obj>1005111020.101</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>124790.9875</smartobject_obj>
<object_instance_obj>125052.9875</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>WIDTH-CHARS</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>82.4</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_ui_event"><ui_event_obj>125244.9875</ui_event_obj>
<object_type_obj>5483.409</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>6304.409</smartobject_obj>
<object_instance_obj>124986.9875</object_instance_obj>
<event_name>CHOOSE</event_name>
<constant_value>no</constant_value>
<action_type>RUN</action_type>
<action_target>SELF</action_target>
<event_action>chooseButton</event_action>
<event_parameter>Password</event_parameter>
<event_disabled>no</event_disabled>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
</contained_record>
<contained_record DB="icfdb" Table="ryc_ui_event"><ui_event_obj>125245.9875</ui_event_obj>
<object_type_obj>5483.409</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>6304.409</smartobject_obj>
<object_instance_obj>124994.9875</object_instance_obj>
<event_name>CHOOSE</event_name>
<constant_value>no</constant_value>
<action_type>RUN</action_type>
<action_target>SELF</action_target>
<event_action>chooseButton</event_action>
<event_parameter>Confirm</event_parameter>
<event_disabled>no</event_disabled>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
</contained_record>
<contained_record DB="icfdb" Table="ryc_ui_event"><ui_event_obj>125246.9875</ui_event_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>3000023555.09</smartobject_obj>
<object_instance_obj>125009.9875</object_instance_obj>
<event_name>LEAVE</event_name>
<constant_value>no</constant_value>
<action_type>RUN</action_type>
<action_target>SELF</action_target>
<event_action>leaveLoginName</event_action>
<event_parameter></event_parameter>
<event_disabled>no</event_disabled>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
</contained_record>
<contained_record DB="icfdb" Table="ryc_ui_event"><ui_event_obj>125247.9875</ui_event_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>124862.9875</container_smartobject_obj>
<smartobject_obj>3000023627.09</smartobject_obj>
<object_instance_obj>125027.9875</object_instance_obj>
<event_name>VALUE-CHANGED</event_name>
<constant_value>no</constant_value>
<action_type>RUN</action_type>
<action_target>SELF</action_target>
<event_action>changeProfileUser</event_action>
<event_parameter></event_parameter>
<event_disabled>no</event_disabled>
<primary_smartobject_obj>124862.9875</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
</dataset_records>
</dataset>