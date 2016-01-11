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
<dataset_records><dataset_transaction TransactionNo="1" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_smartobject" version_date="05/27/2003" version_time="63946" version_user="admin" deletion_flag="no" entity_mnemonic="rycso" key_field_value="3000030780.09" record_version_obj="3000030781.09" version_number_seq="40.09" secondary_key_value="ryt_dbupdate_status.update_successful#CHR(1)#0" import_version_number_seq="40.09"><smartobject_obj>3000030780.09</smartobject_obj>
<object_filename>ryt_dbupdate_status.update_successful</object_filename>
<customization_result_obj>0</customization_result_obj>
<object_type_obj>1005091923.09</object_type_obj>
<product_module_obj>3000005456.09</product_module_obj>
<layout_obj>0</layout_obj>
<object_description>DataField for update_successful</object_description>
<object_path>ry/dfo</object_path>
<object_extension></object_extension>
<static_object>yes</static_object>
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
<security_smartobject_obj>3000030780.09</security_smartobject_obj>
<object_is_runnable>no</object_is_runnable>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>3000030788.09</attribute_value_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>3000030780.09</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>ColumnLabel</attribute_label>
<character_value>?</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>3000030780.09</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>no</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>3000030784.09</attribute_value_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>3000030780.09</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>yes</constant_value>
<attribute_label>DATA-TYPE</attribute_label>
<character_value>logical</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>3000030780.09</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>no</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>3000045690.09</attribute_value_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>3000030780.09</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>DefaultValue</attribute_label>
<character_value>NO</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>3000030780.09</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>no</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>3000030786.09</attribute_value_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>3000030780.09</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>FORMAT</attribute_label>
<character_value>YES/NO</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>3000030780.09</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>no</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>3000030790.09</attribute_value_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>3000030780.09</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>HEIGHT-CHARS</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>1</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>3000030780.09</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>3000030789.09</attribute_value_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>3000030780.09</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>HELP</attribute_label>
<character_value>Update successful</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>3000030780.09</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>3000030785.09</attribute_value_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>3000030780.09</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>InitialValue</attribute_label>
<character_value>NO</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>3000030780.09</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>3000030787.09</attribute_value_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>3000030780.09</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>LABEL</attribute_label>
<character_value>Update successful</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>3000030780.09</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>no</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>3000030803.09</attribute_value_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>3000030780.09</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>LABELS</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>yes</logical_value>
<primary_smartobject_obj>3000030780.09</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>3000030782.09</attribute_value_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>3000030780.09</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>NAME</attribute_label>
<character_value>update_successful</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>3000030780.09</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>no</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>3000030795.09</attribute_value_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>3000030780.09</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>yes</constant_value>
<attribute_label>SCHEMA-COLUMN-LABEL</attribute_label>
<character_value>?</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>3000030780.09</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>no</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>3000042750.09</attribute_value_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>3000030780.09</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>yes</constant_value>
<attribute_label>SCHEMA-DECIMALS</attribute_label>
<character_value></character_value>
<integer_value>?</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>3000030780.09</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>no</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>3000042751.09</attribute_value_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>3000030780.09</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>yes</constant_value>
<attribute_label>SCHEMA-DESCRIPTION</attribute_label>
<character_value>This is a logical flag, default NO, used in conjunction with the update_completed flag. The flag indetofies whether the step was successful or not after it has been completed. IF the step was not successful and the mandatory option is selected, the update will need to terminate until the problem is resolved. This may involve resorting to a backup and starting again, depending on the situation.</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>3000030780.09</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>no</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>3000030793.09</attribute_value_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>3000030780.09</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>yes</constant_value>
<attribute_label>SCHEMA-FORMAT</attribute_label>
<character_value>YES/NO</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>3000030780.09</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>no</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>3000030796.09</attribute_value_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>3000030780.09</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>yes</constant_value>
<attribute_label>SCHEMA-HELP</attribute_label>
<character_value>Update successful</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>3000030780.09</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>no</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>3000030792.09</attribute_value_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>3000030780.09</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>yes</constant_value>
<attribute_label>SCHEMA-INITIAL</attribute_label>
<character_value>NO</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>3000030780.09</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>no</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>3000030794.09</attribute_value_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>3000030780.09</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>yes</constant_value>
<attribute_label>SCHEMA-LABEL</attribute_label>
<character_value>Update successful</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>3000030780.09</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>no</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>3000042752.09</attribute_value_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>3000030780.09</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>yes</constant_value>
<attribute_label>SCHEMA-ORDER</attribute_label>
<character_value></character_value>
<integer_value>90</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>3000030780.09</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>no</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>3000030798.09</attribute_value_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>3000030780.09</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>yes</constant_value>
<attribute_label>SCHEMA-VALIDATE-EXPRESSION</attribute_label>
<character_value>?</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>3000030780.09</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>no</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>3000030799.09</attribute_value_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>3000030780.09</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>yes</constant_value>
<attribute_label>SCHEMA-VALIDATE-MESSAGE</attribute_label>
<character_value>l_noyes</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>3000030780.09</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>no</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>3000030797.09</attribute_value_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>3000030780.09</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>yes</constant_value>
<attribute_label>SCHEMA-VIEW-AS</attribute_label>
<character_value>VIEW-AS TOGGLE-BOX</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>3000030780.09</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>no</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>3000030800.09</attribute_value_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>3000030780.09</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>ShowPopup</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>3000030780.09</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>3000030783.09</attribute_value_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>3000030780.09</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>yes</constant_value>
<attribute_label>TableName</attribute_label>
<character_value>ryt_dbupdate_status</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>3000030780.09</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>3000030802.09</attribute_value_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>3000030780.09</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>VISIBLE</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>yes</logical_value>
<primary_smartobject_obj>3000030780.09</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>3000030801.09</attribute_value_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>3000030780.09</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>VisualizationType</attribute_label>
<character_value>TOGGLE-BOX</character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>0</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>3000030780.09</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
<contained_record DB="icfdb" Table="ryc_attribute_value"><attribute_value_obj>3000030791.09</attribute_value_obj>
<object_type_obj>1005091923.09</object_type_obj>
<container_smartobject_obj>0</container_smartobject_obj>
<smartobject_obj>3000030780.09</smartobject_obj>
<object_instance_obj>0</object_instance_obj>
<constant_value>no</constant_value>
<attribute_label>WIDTH-CHARS</attribute_label>
<character_value></character_value>
<integer_value>0</integer_value>
<date_value>?</date_value>
<decimal_value>10.4</decimal_value>
<logical_value>no</logical_value>
<primary_smartobject_obj>3000030780.09</primary_smartobject_obj>
<render_type_obj>0</render_type_obj>
<applies_at_runtime>yes</applies_at_runtime>
</contained_record>
</contained_record>
</dataset_transaction>
</dataset_records>
</dataset>