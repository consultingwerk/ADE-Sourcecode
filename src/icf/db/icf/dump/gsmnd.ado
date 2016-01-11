<?xml version="1.0" encoding="utf-8" ?>
<dataset Transactions="38"><dataset_header DisableRI="yes" DatasetObj="1007600077.08" DateFormat="mdy" FullHeader="yes" SCMManaged="no" YearOffset="1950" DatasetCode="GSMND" NumericFormat="AMERICAN" NumericDecimal="." OriginatingSite="90" NumericSeparator=","><deploy_dataset_obj>1007600077.08</deploy_dataset_obj>
<dataset_code>GSMND</dataset_code>
<dataset_description>gsm_node - TreeView Nodes</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<deploy_additions_only>no</deploy_additions_only>
<enable_data_versioning>yes</enable_data_versioning>
<deletion_dataset>yes</deletion_dataset>
<dataset_entity><dataset_entity_obj>1007600078.08</dataset_entity_obj>
<deploy_dataset_obj>1007600077.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSMND</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>node_code</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
<entity_mnemonic_description>gsm_node</entity_mnemonic_description>
<entity_dbname>ICFDB</entity_dbname>
</dataset_entity>
<table_definition><name>gsm_node</name>
<dbname>icfdb</dbname>
<index-1>XAK1gsm_node,1,0,0,node_code,0</index-1>
<index-2>XIE1gsm_node,0,0,0,parent_node_obj,0</index-2>
<index-3>XPKgsm_node,1,1,0,node_obj,0</index-3>
<field><name>node_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Node Obj</label>
<column-label>Node Obj</column-label>
</field>
<field><name>node_code</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(10)</format>
<initial></initial>
<label>Node Code</label>
<column-label>Node Code</column-label>
</field>
<field><name>node_description</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>Node Description</label>
<column-label>Node Description</column-label>
</field>
<field><name>parent_node_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Parent Node Obj</label>
<column-label>Parent Node Obj</column-label>
</field>
<field><name>node_label</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(28)</format>
<initial></initial>
<label>Node Label</label>
<column-label>Node Label</column-label>
</field>
<field><name>node_checked</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>Node Checked</label>
<column-label>Node Checked</column-label>
</field>
<field><name>data_source_type</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(3)</format>
<initial></initial>
<label>Data Source Type</label>
<column-label>Data Source Type</column-label>
</field>
<field><name>data_source</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>Data Source</label>
<column-label>Data Source</column-label>
</field>
<field><name>primary_sdo</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>Primary Sdo</label>
<column-label>Primary Sdo</column-label>
</field>
<field><name>logical_object</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>Logical Object</label>
<column-label>Logical Object</column-label>
</field>
<field><name>run_attribute</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>Run Attribute</label>
<column-label>Run Attribute</column-label>
</field>
<field><name>fields_to_store</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Fields to Store</label>
<column-label>Fields to Store</column-label>
</field>
<field><name>node_text_label_expression</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Node Text Label Expression</label>
<column-label>Node Text Label Expression</column-label>
</field>
<field><name>label_text_substitution_fields</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Label Text Substitution Fields</label>
<column-label>Label Text Substitution Fields</column-label>
</field>
<field><name>foreign_fields</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Foreign Fields</label>
<column-label>Foreign Fields</column-label>
</field>
<field><name>image_file_name</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Image File Name</label>
<column-label>Image File Name</column-label>
</field>
<field><name>selected_image_file_name</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Selected Image File Name</label>
<column-label>Selected Image File Name</column-label>
</field>
</table_definition>
</dataset_header>
<dataset_records><dataset_transaction TransactionNo="1" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_node" version_date="08/20/2002" version_time="84568" version_user="admin" deletion_flag="no" entity_mnemonic="gsmnd" key_field_value="17112.53" record_version_obj="17113.53" version_number_seq="4.5053" secondary_key_value="ObjTpStTSL" import_version_number_seq="4.5053"><node_obj>17112.53</node_obj>
<node_code>ObjTpStTSL</node_code>
<node_description>Object Type Supported Link Text</node_description>
<parent_node_obj>2000000863.28</parent_node_obj>
<node_label>Supported Link</node_label>
<node_checked>no</node_checked>
<data_source_type>TXT</data_source_type>
<data_source> Supported Link</data_source>
<primary_sdo>gscotfullo.w</primary_sdo>
<logical_object></logical_object>
<run_attribute></run_attribute>
<fields_to_store></fields_to_store>
<node_text_label_expression></node_text_label_expression>
<label_text_substitution_fields></label_text_substitution_fields>
<foreign_fields></foreign_fields>
<image_file_name>ry/img/links16.ico</image_file_name>
<selected_image_file_name>ry/img/links16.ico</selected_image_file_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="2" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_node" version_date="08/20/2002" version_time="84568" version_user="admin" deletion_flag="no" entity_mnemonic="gsmnd" key_field_value="17114.53" record_version_obj="17115.53" version_number_seq="4.5053" secondary_key_value="ObjTpSuppL" import_version_number_seq="4.5053"><node_obj>17114.53</node_obj>
<node_code>ObjTpSuppL</node_code>
<node_description>Object Type Supported Link Control</node_description>
<parent_node_obj>17112.53</parent_node_obj>
<node_label>Supported Link</node_label>
<node_checked>no</node_checked>
<data_source_type>SDO</data_source_type>
<data_source>rycslfullo</data_source>
<primary_sdo>rycslfullo</primary_sdo>
<logical_object>rycslfoldw</logical_object>
<run_attribute></run_attribute>
<fields_to_store></fields_to_store>
<node_text_label_expression>&amp;1</node_text_label_expression>
<label_text_substitution_fields>ryc_smartlink_type.link_name</label_text_substitution_fields>
<foreign_fields>ryc_supported_link.object_type_obj,object_type_obj</foreign_fields>
<image_file_name>ry/img/links16.ico</image_file_name>
<selected_image_file_name>ry/img/links16.ico</selected_image_file_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="3" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_node" version_date="03/07/2003" version_time="63469" version_user="admin" deletion_flag="no" entity_mnemonic="gsmnd" key_field_value="36439.48" record_version_obj="36440.48" version_number_seq="1.09" secondary_key_value="AttribGrp" import_version_number_seq="1.09"><node_obj>36439.48</node_obj>
<node_code>AttribGrp</node_code>
<node_description>Attribute Group</node_description>
<parent_node_obj>0</parent_node_obj>
<node_label>Attribute Group</node_label>
<node_checked>no</node_checked>
<data_source_type>SDO</data_source_type>
<data_source>rycapfullo.w</data_source>
<primary_sdo>rycapfullo.w</primary_sdo>
<logical_object>rycapfoldw</logical_object>
<run_attribute></run_attribute>
<fields_to_store></fields_to_store>
<node_text_label_expression>&amp;1</node_text_label_expression>
<label_text_substitution_fields>ryc_attribute_group.attribute_group_name</label_text_substitution_fields>
<foreign_fields></foreign_fields>
<image_file_name>ry/img/treefile.ico</image_file_name>
<selected_image_file_name>ry/img/treefils.ico</selected_image_file_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="4" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_node" version_date="03/07/2003" version_time="63469" version_user="admin" deletion_flag="no" entity_mnemonic="gsmnd" key_field_value="36441.48" record_version_obj="36442.48" version_number_seq="1.09" secondary_key_value="AttribMain" import_version_number_seq="1.09"><node_obj>36441.48</node_obj>
<node_code>AttribMain</node_code>
<node_description>Attribute Maintenance Node</node_description>
<parent_node_obj>36439.48</parent_node_obj>
<node_label>Attribute</node_label>
<node_checked>no</node_checked>
<data_source_type>SDO</data_source_type>
<data_source>rycatfullo.w</data_source>
<primary_sdo>rycatfullo.w</primary_sdo>
<logical_object>rycatfol2w</logical_object>
<run_attribute></run_attribute>
<fields_to_store></fields_to_store>
<node_text_label_expression>&amp;1</node_text_label_expression>
<label_text_substitution_fields>ryc_attribute.attribute_label</label_text_substitution_fields>
<foreign_fields>attribute_group_obj,attribute_group_obj</foreign_fields>
<image_file_name>ry/img/treefile.ico</image_file_name>
<selected_image_file_name>ry/img/treefils.ico</selected_image_file_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="5" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_node" version_date="05/27/2002" version_time="35685" version_user="admin" deletion_flag="no" entity_mnemonic="gsmnd" key_field_value="1005118188.101" record_version_obj="2000000004.82" version_number_seq="1.82" secondary_key_value="SmartObj" import_version_number_seq="1.82"><node_obj>1005118188.101</node_obj>
<node_code>SmartObj</node_code>
<node_description>Smart Object Control</node_description>
<parent_node_obj>1005124213.101</parent_node_obj>
<node_label>Smart Object</node_label>
<node_checked>no</node_checked>
<data_source_type>SDO</data_source_type>
<data_source>rycsoful2o.w</data_source>
<primary_sdo>rycsoful2o.w</primary_sdo>
<logical_object>rycsofoltw</logical_object>
<run_attribute></run_attribute>
<fields_to_store></fields_to_store>
<node_text_label_expression>&amp;1 &amp;2</node_text_label_expression>
<label_text_substitution_fields>ryc_smartobject.object_filename,CustomizedResultCode</label_text_substitution_fields>
<foreign_fields>ryc_smartobject.object_type_obj,object_type_obj</foreign_fields>
<image_file_name>ry/img/treefile.ico</image_file_name>
<selected_image_file_name>ry/img/treefils.ico</selected_image_file_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="6" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_node" version_date="10/03/2002" version_time="45357" version_user="admin" deletion_flag="no" entity_mnemonic="gsmnd" key_field_value="1005119441.101" record_version_obj="2000074586.28" version_number_seq="1.28" secondary_key_value="SmrtObjOIn" import_version_number_seq="1.28"><node_obj>1005119441.101</node_obj>
<node_code>SmrtObjOIn</node_code>
<node_description>Object Instances</node_description>
<parent_node_obj>1005119799.101</parent_node_obj>
<node_label>Object Instance</node_label>
<node_checked>no</node_checked>
<data_source_type>SDO</data_source_type>
<data_source>rycoiful3o.w</data_source>
<primary_sdo>rycoiful3o.w</primary_sdo>
<logical_object>rycoifoltw</logical_object>
<run_attribute></run_attribute>
<fields_to_store></fields_to_store>
<node_text_label_expression>&amp;1 (&amp;2)</node_text_label_expression>
<label_text_substitution_fields>ryc_object_instance.instance_name,ryc_smartobject.object_filename</label_text_substitution_fields>
<foreign_fields>ryc_object_instance.container_smartobject_obj,smartobject_obj</foreign_fields>
<image_file_name>ry/img/treefile.ico</image_file_name>
<selected_image_file_name>ry/img/treefils.ico</selected_image_file_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="7" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_node"><node_obj>1005119708.101</node_obj>
<node_code>SmrtObjTAt</node_code>
<node_description>SmrtObj Attribute Text</node_description>
<parent_node_obj>1005118188.101</parent_node_obj>
<node_label>Attribute</node_label>
<node_checked>no</node_checked>
<data_source_type>TXT</data_source_type>
<data_source>Attributes</data_source>
<primary_sdo>rycsoful2o.w</primary_sdo>
<logical_object></logical_object>
<run_attribute></run_attribute>
<fields_to_store></fields_to_store>
<node_text_label_expression></node_text_label_expression>
<label_text_substitution_fields></label_text_substitution_fields>
<foreign_fields></foreign_fields>
<image_file_name>ry/img/treefile.ico</image_file_name>
<selected_image_file_name>ry/img/treefils.ico</selected_image_file_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="8" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_node"><node_obj>1005119799.101</node_obj>
<node_code>SmrtObjTOI</node_code>
<node_description>SmrtObj Instance Text</node_description>
<parent_node_obj>1005118188.101</parent_node_obj>
<node_label>Object Instance</node_label>
<node_checked>no</node_checked>
<data_source_type>TXT</data_source_type>
<data_source>Object Instances</data_source>
<primary_sdo>rycsoful2o.w</primary_sdo>
<logical_object></logical_object>
<run_attribute></run_attribute>
<fields_to_store></fields_to_store>
<node_text_label_expression></node_text_label_expression>
<label_text_substitution_fields></label_text_substitution_fields>
<foreign_fields></foreign_fields>
<image_file_name>ry/img/treefile.ico</image_file_name>
<selected_image_file_name>ry/img/treefils.ico</selected_image_file_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="9" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_node"><node_obj>1005119800.101</node_obj>
<node_code>SmrtObjTPg</node_code>
<node_description>SmrtObj Page Text</node_description>
<parent_node_obj>1005118188.101</parent_node_obj>
<node_label>Smart Object Page</node_label>
<node_checked>no</node_checked>
<data_source_type>TXT</data_source_type>
<data_source>Pages</data_source>
<primary_sdo>rycsoful2o.w</primary_sdo>
<logical_object></logical_object>
<run_attribute></run_attribute>
<fields_to_store></fields_to_store>
<node_text_label_expression></node_text_label_expression>
<label_text_substitution_fields></label_text_substitution_fields>
<foreign_fields></foreign_fields>
<image_file_name>ry/img/treefile.ico</image_file_name>
<selected_image_file_name>ry/img/treefils.ico</selected_image_file_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="10" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_node"><node_obj>1005119801.101</node_obj>
<node_code>SmrtObjTSL</node_code>
<node_description>SmrtObj Smart Links Text</node_description>
<parent_node_obj>1005118188.101</parent_node_obj>
<node_label>Smart Object Link</node_label>
<node_checked>no</node_checked>
<data_source_type>TXT</data_source_type>
<data_source>Links</data_source>
<primary_sdo>rycsoful2o.w</primary_sdo>
<logical_object></logical_object>
<run_attribute></run_attribute>
<fields_to_store></fields_to_store>
<node_text_label_expression></node_text_label_expression>
<label_text_substitution_fields></label_text_substitution_fields>
<foreign_fields></foreign_fields>
<image_file_name>ry/img/treefile.ico</image_file_name>
<selected_image_file_name>ry/img/treefils.ico</selected_image_file_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="11" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_node"><node_obj>1005119919.101</node_obj>
<node_code>SmrtObjOAv</node_code>
<node_description>Object Attribute Values</node_description>
<parent_node_obj>1005119708.101</parent_node_obj>
<node_label>Attribute Value</node_label>
<node_checked>no</node_checked>
<data_source_type>SDO</data_source_type>
<data_source>rycavful3o.w</data_source>
<primary_sdo>rycavful3o.w</primary_sdo>
<logical_object>rycavflt1w</logical_object>
<run_attribute></run_attribute>
<fields_to_store></fields_to_store>
<node_text_label_expression>&amp;1</node_text_label_expression>
<label_text_substitution_fields>ryc_attribute_value.attribute_label</label_text_substitution_fields>
<foreign_fields>ryc_attribute_value.smartobject_obj,smartobject_obj,ryc_attribute_value.primary_smartobject_obj,smartobject_obj,ryc_attribute_value.object_type_obj,object_type_obj</foreign_fields>
<image_file_name>ry/img/treefile.ico</image_file_name>
<selected_image_file_name>ry/img/treefils.ico</selected_image_file_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="12" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_node"><node_obj>1005120273.101</node_obj>
<node_code>SmrtObjPg</node_code>
<node_description>SmartObject Pages</node_description>
<parent_node_obj>1005119800.101</parent_node_obj>
<node_label>SmartObject Page</node_label>
<node_checked>no</node_checked>
<data_source_type>SDO</data_source_type>
<data_source>rycpaful2o.w</data_source>
<primary_sdo>rycpaful2o.w</primary_sdo>
<logical_object>rycpafldtw</logical_object>
<run_attribute></run_attribute>
<fields_to_store></fields_to_store>
<node_text_label_expression>&amp;1-&amp;2</node_text_label_expression>
<label_text_substitution_fields>ryc_page.page_sequence,ryc_page.page_label</label_text_substitution_fields>
<foreign_fields>ryc_page.container_smartobject_obj,smartobject_obj</foreign_fields>
<image_file_name>ry/img/treefile.ico</image_file_name>
<selected_image_file_name>ry/img/treefils.ico</selected_image_file_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="13" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_node"><node_obj>1005120293.101</node_obj>
<node_code>SmrtObjOIA</node_code>
<node_description>Object Instance Attribute Values</node_description>
<parent_node_obj>1005122641.101</parent_node_obj>
<node_label>Attribute Value</node_label>
<node_checked>no</node_checked>
<data_source_type>SDO</data_source_type>
<data_source>rycavful4o.w</data_source>
<primary_sdo>rycavful4o.w</primary_sdo>
<logical_object>rycavflt2w</logical_object>
<run_attribute></run_attribute>
<fields_to_store></fields_to_store>
<node_text_label_expression>&amp;1</node_text_label_expression>
<label_text_substitution_fields>ryc_attribute_value.attribute_label</label_text_substitution_fields>
<foreign_fields>ryc_attribute_value.object_type_obj,object_type_obj,ryc_attribute_value.container_smartobject_obj,container_smartobject_obj,ryc_attribute_value.object_instance_obj,object_instance_obj,ryc_attribute_value.smartobject_obj,smartobject_obj</foreign_fields>
<image_file_name>ry/img/treefile.ico</image_file_name>
<selected_image_file_name>ry/img/treefils.ico</selected_image_file_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="14" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_node"><node_obj>1005120448.101</node_obj>
<node_code>SmrtObjSlk</node_code>
<node_description>Smart Links</node_description>
<parent_node_obj>1005119801.101</parent_node_obj>
<node_label>Smart Link</node_label>
<node_checked>no</node_checked>
<data_source_type>SDO</data_source_type>
<data_source>rycsmful2o.w</data_source>
<primary_sdo>rycsmful2o.w</primary_sdo>
<logical_object>rycsmfoltw</logical_object>
<run_attribute></run_attribute>
<fields_to_store></fields_to_store>
<node_text_label_expression>&amp;1</node_text_label_expression>
<label_text_substitution_fields>ryc_smartlink.link_name</label_text_substitution_fields>
<foreign_fields>ryc_smartlink.container_smartobject_obj,smartobject_obj</foreign_fields>
<image_file_name>ry/img/treefile.ico</image_file_name>
<selected_image_file_name>ry/img/treefils.ico</selected_image_file_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="15" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_node" version_date="05/27/2002" version_time="35684" version_user="admin" deletion_flag="no" entity_mnemonic="gsmnd" key_field_value="1005121602.101" record_version_obj="2000000001.82" version_number_seq="1.82" secondary_key_value="ObjectType" import_version_number_seq="1.82"><node_obj>1005121602.101</node_obj>
<node_code>ObjectType</node_code>
<node_description>Object Type</node_description>
<parent_node_obj>0</parent_node_obj>
<node_label>Object Type</node_label>
<node_checked>no</node_checked>
<data_source_type>SDO</data_source_type>
<data_source>gscotfullo.w</data_source>
<primary_sdo>gscotfullo.w</primary_sdo>
<logical_object>gscotfoldw</logical_object>
<run_attribute></run_attribute>
<fields_to_store></fields_to_store>
<node_text_label_expression>&amp;1</node_text_label_expression>
<label_text_substitution_fields>gsc_object_type.object_type_code</label_text_substitution_fields>
<foreign_fields></foreign_fields>
<image_file_name>ry/img/treefile.ico</image_file_name>
<selected_image_file_name>ry/img/treefils.ico</selected_image_file_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="16" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_node"><node_obj>1005122064.101</node_obj>
<node_code>UIEventTSO</node_code>
<node_description>UI Events SmartObject</node_description>
<parent_node_obj>1005118188.101</parent_node_obj>
<node_label>UI Events</node_label>
<node_checked>no</node_checked>
<data_source_type>TXT</data_source_type>
<data_source>UI Events</data_source>
<primary_sdo>rycsoful2o.w</primary_sdo>
<logical_object></logical_object>
<run_attribute></run_attribute>
<fields_to_store></fields_to_store>
<node_text_label_expression></node_text_label_expression>
<label_text_substitution_fields></label_text_substitution_fields>
<foreign_fields></foreign_fields>
<image_file_name>ry/img/treefile.ico</image_file_name>
<selected_image_file_name>ry/img/treefils.ico</selected_image_file_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="17" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_node"><node_obj>1005122268.101</node_obj>
<node_code>UIEventsSO</node_code>
<node_description>UI Events SmartObject</node_description>
<parent_node_obj>1005122064.101</parent_node_obj>
<node_label>UI Events</node_label>
<node_checked>no</node_checked>
<data_source_type>SDO</data_source_type>
<data_source>rycuefullo.w</data_source>
<primary_sdo>rycuefullo.w</primary_sdo>
<logical_object>rycuefoldw</logical_object>
<run_attribute></run_attribute>
<fields_to_store></fields_to_store>
<node_text_label_expression>&amp;1</node_text_label_expression>
<label_text_substitution_fields>ryc_ui_event.event_name</label_text_substitution_fields>
<foreign_fields>ryc_ui_event.smartobject_obj,smartobject_obj,ryc_ui_event.primary_smartobject_obj,smartobject_obj</foreign_fields>
<image_file_name>ry/img/treefile.ico</image_file_name>
<selected_image_file_name>ry/img/treefils.ico</selected_image_file_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="18" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_node"><node_obj>1005122269.101</node_obj>
<node_code>UIEventTOI</node_code>
<node_description>UI Events Object Instance</node_description>
<parent_node_obj>1005119441.101</parent_node_obj>
<node_label>UI Events</node_label>
<node_checked>no</node_checked>
<data_source_type>TXT</data_source_type>
<data_source>UI Events</data_source>
<primary_sdo>rycoiful3o.w</primary_sdo>
<logical_object></logical_object>
<run_attribute></run_attribute>
<fields_to_store></fields_to_store>
<node_text_label_expression></node_text_label_expression>
<label_text_substitution_fields></label_text_substitution_fields>
<foreign_fields></foreign_fields>
<image_file_name>ry/img/treefile.ico</image_file_name>
<selected_image_file_name>ry/img/treefils.ico</selected_image_file_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="19" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_node"><node_obj>1005122270.101</node_obj>
<node_code>UIEventsOI</node_code>
<node_description>UI Events SmartObject</node_description>
<parent_node_obj>1005122269.101</parent_node_obj>
<node_label>UI Events</node_label>
<node_checked>no</node_checked>
<data_source_type>SDO</data_source_type>
<data_source>rycueful2o.w</data_source>
<primary_sdo>rycueful2o.w</primary_sdo>
<logical_object>rycuefol2w</logical_object>
<run_attribute></run_attribute>
<fields_to_store></fields_to_store>
<node_text_label_expression>&amp;1</node_text_label_expression>
<label_text_substitution_fields>ryc_ui_event.event_name</label_text_substitution_fields>
<foreign_fields>ryc_ui_event.object_type_obj,object_type_obj,ryc_ui_event.container_smartobject_obj,container_smartobject_obj,ryc_ui_event.object_instance_obj,object_instance_obj,ryc_ui_event.smartobject_obj,smartobject_obj</foreign_fields>
<image_file_name>ry/img/treefile.ico</image_file_name>
<selected_image_file_name>ry/img/treefils.ico</selected_image_file_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="20" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_node"><node_obj>1005122641.101</node_obj>
<node_code>SmrtObjOTA</node_code>
<node_description>Object Instance Attribute Val Text</node_description>
<parent_node_obj>1005119441.101</parent_node_obj>
<node_label>Attribute Value</node_label>
<node_checked>no</node_checked>
<data_source_type>TXT</data_source_type>
<data_source>Attributes</data_source>
<primary_sdo>rycoiful3o.w</primary_sdo>
<logical_object></logical_object>
<run_attribute></run_attribute>
<fields_to_store></fields_to_store>
<node_text_label_expression></node_text_label_expression>
<label_text_substitution_fields></label_text_substitution_fields>
<foreign_fields></foreign_fields>
<image_file_name>ry/img/treefile.ico</image_file_name>
<selected_image_file_name>ry/img/treefils.ico</selected_image_file_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="21" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_node" version_date="05/27/2002" version_time="35685" version_user="admin" deletion_flag="no" entity_mnemonic="gsmnd" key_field_value="1005124213.101" record_version_obj="2000000003.82" version_number_seq="1.82" secondary_key_value="ObjTpTSmOb" import_version_number_seq="1.82"><node_obj>1005124213.101</node_obj>
<node_code>ObjTpTSmOb</node_code>
<node_description>Object Type SmartObject Text</node_description>
<parent_node_obj>1005121602.101</parent_node_obj>
<node_label>SmartObject</node_label>
<node_checked>no</node_checked>
<data_source_type>TXT</data_source_type>
<data_source>Objects</data_source>
<primary_sdo>gscotfullo.w</primary_sdo>
<logical_object></logical_object>
<run_attribute></run_attribute>
<fields_to_store></fields_to_store>
<node_text_label_expression></node_text_label_expression>
<label_text_substitution_fields></label_text_substitution_fields>
<foreign_fields></foreign_fields>
<image_file_name>ry/img/treefile.ico</image_file_name>
<selected_image_file_name>ry/img/treefils.ico</selected_image_file_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="22" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_node" version_date="05/27/2002" version_time="35684" version_user="admin" deletion_flag="no" entity_mnemonic="gsmnd" key_field_value="1005124226.101" record_version_obj="2000000002.82" version_number_seq="1.82" secondary_key_value="ObjTpTAtOb" import_version_number_seq="1.82"><node_obj>1005124226.101</node_obj>
<node_code>ObjTpTAtOb</node_code>
<node_description>Object Type Attribute Value Text</node_description>
<parent_node_obj>1005121602.101</parent_node_obj>
<node_label>Attribute Value</node_label>
<node_checked>no</node_checked>
<data_source_type>TXT</data_source_type>
<data_source>Attributes</data_source>
<primary_sdo>gscotfullo.w</primary_sdo>
<logical_object></logical_object>
<run_attribute></run_attribute>
<fields_to_store></fields_to_store>
<node_text_label_expression></node_text_label_expression>
<label_text_substitution_fields></label_text_substitution_fields>
<foreign_fields></foreign_fields>
<image_file_name>ry/img/treefile.ico</image_file_name>
<selected_image_file_name>ry/img/treefils.ico</selected_image_file_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="23" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_node"><node_obj>1005124552.101</node_obj>
<node_code>ObjTpAttVa</node_code>
<node_description>Object Type Attribute Value Control</node_description>
<parent_node_obj>1005124226.101</parent_node_obj>
<node_label>Attribute Value</node_label>
<node_checked>no</node_checked>
<data_source_type>SDO</data_source_type>
<data_source>rycavful5o.w</data_source>
<primary_sdo>rycavful5o.w</primary_sdo>
<logical_object>rycavflt3w</logical_object>
<run_attribute></run_attribute>
<fields_to_store></fields_to_store>
<node_text_label_expression>&amp;1</node_text_label_expression>
<label_text_substitution_fields>ryc_attribute_value.attribute_label</label_text_substitution_fields>
<foreign_fields>ryc_attribute_value.object_type_obj,object_type_obj</foreign_fields>
<image_file_name>ry/img/treefile.ico</image_file_name>
<selected_image_file_name>ry/img/treefils.ico</selected_image_file_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="24" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_node"><node_obj>1005126430.101</node_obj>
<node_code>SmrtObjPIn</node_code>
<node_description>Page Object Instances</node_description>
<parent_node_obj>1005120273.101</parent_node_obj>
<node_label>Object Instance</node_label>
<node_checked>no</node_checked>
<data_source_type>SDO</data_source_type>
<data_source>rycoiful4o.w</data_source>
<primary_sdo>rycoiful4o.w</primary_sdo>
<logical_object>rycoifoltw</logical_object>
<run_attribute></run_attribute>
<fields_to_store></fields_to_store>
<node_text_label_expression>&amp;1</node_text_label_expression>
<label_text_substitution_fields>object_filename</label_text_substitution_fields>
<foreign_fields>ryc_object_instance.container_smartobject_obj,container_smartobject_obj,ryc_page_object.page_obj,page_obj</foreign_fields>
<image_file_name>ry/img/treefile.ico</image_file_name>
<selected_image_file_name>ry/img/treefils.ico</selected_image_file_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="25" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_node" version_date="06/19/2002" version_time="26818" version_user="admin" deletion_flag="no" entity_mnemonic="gsmnd" key_field_value="2000000396.28" record_version_obj="2000000397.28" version_number_seq="7.28" secondary_key_value="SmObWhUs" import_version_number_seq="7.28"><node_obj>2000000396.28</node_obj>
<node_code>SmObWhUs</node_code>
<node_description>Smart Object Master Where Used</node_description>
<parent_node_obj>1005118188.101</parent_node_obj>
<node_label>Where Used</node_label>
<node_checked>no</node_checked>
<data_source_type>TXT</data_source_type>
<data_source>Where Used</data_source>
<primary_sdo>rycsoful2o.w</primary_sdo>
<logical_object></logical_object>
<run_attribute></run_attribute>
<fields_to_store></fields_to_store>
<node_text_label_expression></node_text_label_expression>
<label_text_substitution_fields></label_text_substitution_fields>
<foreign_fields></foreign_fields>
<image_file_name>ry/img/treefile.ico</image_file_name>
<selected_image_file_name>ry/img/treefils.ico</selected_image_file_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="26" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_node" version_date="06/18/2002" version_time="26657" version_user="admin" deletion_flag="no" entity_mnemonic="gsmnd" key_field_value="2000000415.28" record_version_obj="2000000416.28" version_number_seq="2.28" secondary_key_value="InWhUsSm" import_version_number_seq="2.28"><node_obj>2000000415.28</node_obj>
<node_code>InWhUsSm</node_code>
<node_description>Instances Where Used SmartObject</node_description>
<parent_node_obj>2000000396.28</parent_node_obj>
<node_label>Where Used</node_label>
<node_checked>no</node_checked>
<data_source_type>SDO</data_source_type>
<data_source>rycoiful1o</data_source>
<primary_sdo>rycoiful1o</primary_sdo>
<logical_object></logical_object>
<run_attribute></run_attribute>
<fields_to_store></fields_to_store>
<node_text_label_expression>&amp;1</node_text_label_expression>
<label_text_substitution_fields>ryc_smartobject.object_filename</label_text_substitution_fields>
<foreign_fields>ryc_object_instance.smartobject_obj,smartobject_obj</foreign_fields>
<image_file_name>ry/img/treefile.ico</image_file_name>
<selected_image_file_name>ry/img/treefils.ico</selected_image_file_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="27" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_node" version_date="06/19/2002" version_time="26818" version_user="admin" deletion_flag="no" entity_mnemonic="gsmnd" key_field_value="2000000417.28" record_version_obj="2000000418.28" version_number_seq="4.28" secondary_key_value="ObInWhUs" import_version_number_seq="4.28"><node_obj>2000000417.28</node_obj>
<node_code>ObInWhUs</node_code>
<node_description>Object Instance Where Used</node_description>
<parent_node_obj>1005119441.101</parent_node_obj>
<node_label>Where Used</node_label>
<node_checked>no</node_checked>
<data_source_type>TXT</data_source_type>
<data_source>Where Used</data_source>
<primary_sdo>rycoiful3o.w</primary_sdo>
<logical_object></logical_object>
<run_attribute></run_attribute>
<fields_to_store></fields_to_store>
<node_text_label_expression></node_text_label_expression>
<label_text_substitution_fields></label_text_substitution_fields>
<foreign_fields></foreign_fields>
<image_file_name>ry/img/treefile.ico</image_file_name>
<selected_image_file_name>ry/img/treefils.ico</selected_image_file_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="28" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_node" version_date="06/18/2002" version_time="26657" version_user="admin" deletion_flag="no" entity_mnemonic="gsmnd" key_field_value="2000000419.28" record_version_obj="2000000420.28" version_number_seq="3.28" secondary_key_value="InWhUsOi" import_version_number_seq="3.28"><node_obj>2000000419.28</node_obj>
<node_code>InWhUsOi</node_code>
<node_description>Instances Where Used Object Instanc</node_description>
<parent_node_obj>2000000417.28</parent_node_obj>
<node_label>Where Used</node_label>
<node_checked>no</node_checked>
<data_source_type>SDO</data_source_type>
<data_source>rycoiful5o</data_source>
<primary_sdo>rycoiful5o</primary_sdo>
<logical_object></logical_object>
<run_attribute></run_attribute>
<fields_to_store></fields_to_store>
<node_text_label_expression>&amp;1</node_text_label_expression>
<label_text_substitution_fields>ryc_smartobject.object_filename</label_text_substitution_fields>
<foreign_fields>ryc_object_instance.smartobject_obj,smartobject_obj</foreign_fields>
<image_file_name>ry/img/treefile.ico</image_file_name>
<selected_image_file_name>ry/img/treefils.ico</selected_image_file_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="29" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_node" version_date="06/20/2002" version_time="26118" version_user="admin" deletion_flag="no" entity_mnemonic="gsmnd" key_field_value="2000000735.28" record_version_obj="2000000736.28" version_number_seq="2.28" secondary_key_value="UIEventTOt" import_version_number_seq="2.28"><node_obj>2000000735.28</node_obj>
<node_code>UIEventTOt</node_code>
<node_description>UI Events ObjectType</node_description>
<parent_node_obj>1005121602.101</parent_node_obj>
<node_label>UI Events</node_label>
<node_checked>no</node_checked>
<data_source_type>TXT</data_source_type>
<data_source>UI Events</data_source>
<primary_sdo>gscotfullo.w</primary_sdo>
<logical_object></logical_object>
<run_attribute></run_attribute>
<fields_to_store></fields_to_store>
<node_text_label_expression></node_text_label_expression>
<label_text_substitution_fields></label_text_substitution_fields>
<foreign_fields></foreign_fields>
<image_file_name>ry/img/treefile.ico</image_file_name>
<selected_image_file_name>ry/img/treefils.ico</selected_image_file_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="30" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_node" version_date="06/20/2002" version_time="26118" version_user="admin" deletion_flag="no" entity_mnemonic="gsmnd" key_field_value="2000000737.28" record_version_obj="2000000738.28" version_number_seq="2.28" secondary_key_value="UIEventObT" import_version_number_seq="2.28"><node_obj>2000000737.28</node_obj>
<node_code>UIEventObT</node_code>
<node_description>UI Events ObjectType</node_description>
<parent_node_obj>2000000735.28</parent_node_obj>
<node_label>UI Events</node_label>
<node_checked>no</node_checked>
<data_source_type>SDO</data_source_type>
<data_source>rycueful1o</data_source>
<primary_sdo>rycueful1o</primary_sdo>
<logical_object>rycuefoldw</logical_object>
<run_attribute></run_attribute>
<fields_to_store></fields_to_store>
<node_text_label_expression>&amp;1</node_text_label_expression>
<label_text_substitution_fields>ryc_ui_event.event_name</label_text_substitution_fields>
<foreign_fields>ryc_ui_event.object_type_obj,object_type_obj</foreign_fields>
<image_file_name>ry/img/treefile.ico</image_file_name>
<selected_image_file_name>ry/img/treefils.ico</selected_image_file_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="31" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_node" version_date="06/24/2002" version_time="86288" version_user="admin" deletion_flag="no" entity_mnemonic="gsmnd" key_field_value="2000000863.28" record_version_obj="2000000864.28" version_number_seq="2.28" secondary_key_value="ObjTpStcr" import_version_number_seq="2.28"><node_obj>2000000863.28</node_obj>
<node_code>ObjTpStcr</node_code>
<node_description>Object Type Structure</node_description>
<parent_node_obj>0</parent_node_obj>
<node_label>Object Type</node_label>
<node_checked>no</node_checked>
<data_source_type>SDO</data_source_type>
<data_source>gscotfullo.w</data_source>
<primary_sdo>gscotfullo.w</primary_sdo>
<logical_object>gscotfoldw</logical_object>
<run_attribute>STRUCTURED</run_attribute>
<fields_to_store>extends_object_type_obj = 0^extends_object_type_obj^object_type_obj^DECIMAL</fields_to_store>
<node_text_label_expression>&amp;1</node_text_label_expression>
<label_text_substitution_fields>gsc_object_type.object_type_code</label_text_substitution_fields>
<foreign_fields></foreign_fields>
<image_file_name>ry/img/treefile.ico</image_file_name>
<selected_image_file_name>ry/img/treefils.ico</selected_image_file_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="32" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_node" version_date="06/24/2002" version_time="86288" version_user="admin" deletion_flag="no" entity_mnemonic="gsmnd" key_field_value="2000000865.28" record_version_obj="2000000866.28" version_number_seq="3.28" secondary_key_value="ObjTpStTAt" import_version_number_seq="3.28"><node_obj>2000000865.28</node_obj>
<node_code>ObjTpStTAt</node_code>
<node_description>Object Type Attribute Value Text</node_description>
<parent_node_obj>2000000863.28</parent_node_obj>
<node_label>Attribute Value</node_label>
<node_checked>no</node_checked>
<data_source_type>TXT</data_source_type>
<data_source> Attributes</data_source>
<primary_sdo>gscotfullo.w</primary_sdo>
<logical_object></logical_object>
<run_attribute></run_attribute>
<fields_to_store></fields_to_store>
<node_text_label_expression></node_text_label_expression>
<label_text_substitution_fields></label_text_substitution_fields>
<foreign_fields></foreign_fields>
<image_file_name>ry/img/treefile.ico</image_file_name>
<selected_image_file_name>ry/img/treefils.ico</selected_image_file_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="33" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_node" version_date="06/24/2002" version_time="86288" version_user="admin" deletion_flag="no" entity_mnemonic="gsmnd" key_field_value="2000000867.28" record_version_obj="2000000868.28" version_number_seq="3.28" secondary_key_value="UIEvTSOt" import_version_number_seq="3.28"><node_obj>2000000867.28</node_obj>
<node_code>UIEvTSOt</node_code>
<node_description>UI Events ObjectType</node_description>
<parent_node_obj>2000000863.28</parent_node_obj>
<node_label>UI Events</node_label>
<node_checked>no</node_checked>
<data_source_type>TXT</data_source_type>
<data_source> UI Events</data_source>
<primary_sdo>gscotfullo.w</primary_sdo>
<logical_object></logical_object>
<run_attribute></run_attribute>
<fields_to_store></fields_to_store>
<node_text_label_expression></node_text_label_expression>
<label_text_substitution_fields></label_text_substitution_fields>
<foreign_fields></foreign_fields>
<image_file_name>ry/img/treefile.ico</image_file_name>
<selected_image_file_name>ry/img/treefils.ico</selected_image_file_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="34" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_node" version_date="06/24/2002" version_time="86288" version_user="admin" deletion_flag="no" entity_mnemonic="gsmnd" key_field_value="2000000869.28" record_version_obj="2000000870.28" version_number_seq="3.28" secondary_key_value="ObjTpStAtt" import_version_number_seq="3.28"><node_obj>2000000869.28</node_obj>
<node_code>ObjTpStAtt</node_code>
<node_description>Object Type Attribute Value Control</node_description>
<parent_node_obj>2000000865.28</parent_node_obj>
<node_label>Attribute Value</node_label>
<node_checked>no</node_checked>
<data_source_type>SDO</data_source_type>
<data_source>rycavful5o.w</data_source>
<primary_sdo>rycavful5o.w</primary_sdo>
<logical_object>rycavflt3w</logical_object>
<run_attribute></run_attribute>
<fields_to_store></fields_to_store>
<node_text_label_expression>&amp;1</node_text_label_expression>
<label_text_substitution_fields>ryc_attribute_value.attribute_label</label_text_substitution_fields>
<foreign_fields>ryc_attribute_value.object_type_obj,object_type_obj</foreign_fields>
<image_file_name>ry/img/treefile.ico</image_file_name>
<selected_image_file_name>ry/img/treefils.ico</selected_image_file_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="35" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_node" version_date="06/24/2002" version_time="86288" version_user="admin" deletion_flag="no" entity_mnemonic="gsmnd" key_field_value="2000000871.28" record_version_obj="2000000872.28" version_number_seq="3.28" secondary_key_value="UIEvStObT" import_version_number_seq="3.28"><node_obj>2000000871.28</node_obj>
<node_code>UIEvStObT</node_code>
<node_description>UI Events ObjectType</node_description>
<parent_node_obj>2000000867.28</parent_node_obj>
<node_label>UI Events</node_label>
<node_checked>no</node_checked>
<data_source_type>SDO</data_source_type>
<data_source>rycueful1o</data_source>
<primary_sdo>rycueful1o</primary_sdo>
<logical_object>rycuefoldw</logical_object>
<run_attribute></run_attribute>
<fields_to_store></fields_to_store>
<node_text_label_expression>&amp;1</node_text_label_expression>
<label_text_substitution_fields>ryc_ui_event.event_name</label_text_substitution_fields>
<foreign_fields>ryc_ui_event.object_type_obj,object_type_obj</foreign_fields>
<image_file_name>ry/img/treefile.ico</image_file_name>
<selected_image_file_name>ry/img/treefils.ico</selected_image_file_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="36" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_node" version_date="08/06/2002" version_time="43371" version_user="admin" deletion_flag="no" entity_mnemonic="gsmnd" key_field_value="2000041395.28" record_version_obj="2000041396.28" version_number_seq="4.28" secondary_key_value="CustType" import_version_number_seq="4.28"><node_obj>2000041395.28</node_obj>
<node_code>CustType</node_code>
<node_description>Customization Types</node_description>
<parent_node_obj>0</parent_node_obj>
<node_label>Customization Type</node_label>
<node_checked>no</node_checked>
<data_source_type>SDO</data_source_type>
<data_source>ryccyfullo</data_source>
<primary_sdo>ryccyfullo</primary_sdo>
<logical_object>ryccyfoltw</logical_object>
<run_attribute></run_attribute>
<fields_to_store></fields_to_store>
<node_text_label_expression>&amp;1</node_text_label_expression>
<label_text_substitution_fields>ryc_customization_type.customization_type_code</label_text_substitution_fields>
<foreign_fields></foreign_fields>
<image_file_name>ry/img/treefile.ico</image_file_name>
<selected_image_file_name>ry/img/treefils.ico</selected_image_file_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="37" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_node" version_date="08/06/2002" version_time="43371" version_user="admin" deletion_flag="no" entity_mnemonic="gsmnd" key_field_value="2000041397.28" record_version_obj="2000041398.28" version_number_seq="5.28" secondary_key_value="CustResult" import_version_number_seq="5.28"><node_obj>2000041397.28</node_obj>
<node_code>CustResult</node_code>
<node_description>Customization Result</node_description>
<parent_node_obj>2000041395.28</parent_node_obj>
<node_label>Customization Result</node_label>
<node_checked>no</node_checked>
<data_source_type>SDO</data_source_type>
<data_source>ryccrfullo</data_source>
<primary_sdo>ryccrfullo</primary_sdo>
<logical_object>ryccrfoltw</logical_object>
<run_attribute></run_attribute>
<fields_to_store></fields_to_store>
<node_text_label_expression>&amp;1</node_text_label_expression>
<label_text_substitution_fields>ryc_customization_result.customization_result_code</label_text_substitution_fields>
<foreign_fields>ryc_customization_result.customization_type_obj,customization_type_obj</foreign_fields>
<image_file_name>ry/img/treefile.ico</image_file_name>
<selected_image_file_name>ry/img/treefils.ico</selected_image_file_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="38" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_node" version_date="08/06/2002" version_time="43371" version_user="admin" deletion_flag="no" entity_mnemonic="gsmnd" key_field_value="2000041399.28" record_version_obj="2000041400.28" version_number_seq="4.28" secondary_key_value="CustRef" import_version_number_seq="4.28"><node_obj>2000041399.28</node_obj>
<node_code>CustRef</node_code>
<node_description>Customization Reference</node_description>
<parent_node_obj>2000041397.28</parent_node_obj>
<node_label>Customization Reference</node_label>
<node_checked>no</node_checked>
<data_source_type>SDO</data_source_type>
<data_source>rymczfullo</data_source>
<primary_sdo>rymczfullo</primary_sdo>
<logical_object>rymczfoltw</logical_object>
<run_attribute></run_attribute>
<fields_to_store></fields_to_store>
<node_text_label_expression>&amp;1</node_text_label_expression>
<label_text_substitution_fields>rym_customization.customization_reference</label_text_substitution_fields>
<foreign_fields>rym_customization.customization_type_obj,customization_type_obj,rym_customization.customization_result_obj,customization_result_obj</foreign_fields>
<image_file_name>ry/img/treefile.ico</image_file_name>
<selected_image_file_name>ry/img/treefils.ico</selected_image_file_name>
</contained_record>
</dataset_transaction>
</dataset_records>
</dataset>