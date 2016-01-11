<?xml version="1.0" encoding="ISO8859-1" ?>
<dataset Transactions="20" version_date="02/23/2002" version_time="43065" version_user="admin" entity_mnemonic="GSTDF" key_field_value="3000000437.09" record_version_obj="3000000438.09" version_number_seq="2.09" import_version_number_seq="1.09"><dataset_header DisableRI="yes" DatasetObj="1007600077.08" DateFormat="mdy" FullHeader="yes" SCMManaged="no" YearOffset="1950" DatasetCode="GSMND" DateCreated="02/23/2002" TimeCreated="11:57:44" NumericFormat="AMERICAN" NumericDecimal="." OriginatingSite="93" NumericSeparator=","><deploy_dataset_obj>1007600077.08</deploy_dataset_obj>
<owner_site_code></owner_site_code>
<dataset_code>GSMND</dataset_code>
<dataset_description>gsm_node - TreeView Nodes</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
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
<entity_mnemonic_description>gsm_node</entity_mnemonic_description>
<entity_dbname>icfdb</entity_dbname>
</dataset_entity>
<table_definition><name>gsm_node</name>
<dbname>ICFDB</dbname>
<index-1>XAK1gsm_node,1,0,0,node_code,0</index-1>
<index-2>XIE1gsm_node,0,0,0,parent_node_obj,0</index-2>
<index-3>XPKgsm_node,1,1,0,node_obj,0</index-3>
<field><name>node_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>>>>>>>>>>>>>>>>>>9.999999999</format>
<initial>                 0.000000000</initial>
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
<format>>>>>>>>>>>>>>>>>>9.999999999</format>
<initial>                 0.000000000</initial>
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
<dataset_records><dataset_transaction TransactionNo="1"><contained_record DB="ICFDB" Table="gsm_node"><node_obj>1005118188.101</node_obj>
<node_code>SmartObj</node_code>
<node_description>Smart Object Control</node_description>
<parent_node_obj>1005124213.101</parent_node_obj>
<node_label>Smart Object</node_label>
<node_checked>no</node_checked>
<data_source_type>SDO</data_source_type>
<data_source>gscobful2o.w</data_source>
<primary_sdo>gscobful2o.w</primary_sdo>
<logical_object>rycsofoltw</logical_object>
<run_attribute></run_attribute>
<fields_to_store></fields_to_store>
<node_text_label_expression>&amp;1</node_text_label_expression>
<label_text_substitution_fields>gsc_object.object_filename</label_text_substitution_fields>
<foreign_fields>gsc_object.object_type_obj,object_type_obj</foreign_fields>
<image_file_name>af/bmp/treefile.ico</image_file_name>
<selected_image_file_name>af/bmp/treefils.ico</selected_image_file_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="2"><contained_record DB="ICFDB" Table="gsm_node"><node_obj>1005119441.101</node_obj>
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
<node_text_label_expression>&amp;1</node_text_label_expression>
<label_text_substitution_fields>ryc_smartobject.object_filename</label_text_substitution_fields>
<foreign_fields>ryc_object_instance.container_smartobject_obj,smartobject_obj</foreign_fields>
<image_file_name>af/bmp/treefile.ico</image_file_name>
<selected_image_file_name>af/bmp/treefils.ico</selected_image_file_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="3"><contained_record DB="ICFDB" Table="gsm_node"><node_obj>1005119708.101</node_obj>
<node_code>SmrtObjTAt</node_code>
<node_description>SmrtObj Attribute Text</node_description>
<parent_node_obj>1005118188.101</parent_node_obj>
<node_label>Attribute</node_label>
<node_checked>no</node_checked>
<data_source_type>TXT</data_source_type>
<data_source>Attributes</data_source>
<primary_sdo>gscobful2o.w</primary_sdo>
<logical_object></logical_object>
<run_attribute></run_attribute>
<fields_to_store></fields_to_store>
<node_text_label_expression></node_text_label_expression>
<label_text_substitution_fields></label_text_substitution_fields>
<foreign_fields></foreign_fields>
<image_file_name>af/bmp/treefile.ico</image_file_name>
<selected_image_file_name>af/bmp/treefils.ico</selected_image_file_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="4"><contained_record DB="ICFDB" Table="gsm_node"><node_obj>1005119799.101</node_obj>
<node_code>SmrtObjTOI</node_code>
<node_description>SmrtObj Instance Text</node_description>
<parent_node_obj>1005118188.101</parent_node_obj>
<node_label>Object Instance</node_label>
<node_checked>no</node_checked>
<data_source_type>TXT</data_source_type>
<data_source>Object Instances</data_source>
<primary_sdo>gscobful2o.w</primary_sdo>
<logical_object></logical_object>
<run_attribute></run_attribute>
<fields_to_store></fields_to_store>
<node_text_label_expression></node_text_label_expression>
<label_text_substitution_fields></label_text_substitution_fields>
<foreign_fields></foreign_fields>
<image_file_name>af/bmp/treefile.ico</image_file_name>
<selected_image_file_name>af/bmp/treefils.ico</selected_image_file_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="5"><contained_record DB="ICFDB" Table="gsm_node"><node_obj>1005119800.101</node_obj>
<node_code>SmrtObjTPg</node_code>
<node_description>SmrtObj Page Text</node_description>
<parent_node_obj>1005118188.101</parent_node_obj>
<node_label>Smart Object Page</node_label>
<node_checked>no</node_checked>
<data_source_type>TXT</data_source_type>
<data_source>Pages</data_source>
<primary_sdo>gscobful2o.w</primary_sdo>
<logical_object></logical_object>
<run_attribute></run_attribute>
<fields_to_store></fields_to_store>
<node_text_label_expression></node_text_label_expression>
<label_text_substitution_fields></label_text_substitution_fields>
<foreign_fields></foreign_fields>
<image_file_name>af/bmp/treefile.ico</image_file_name>
<selected_image_file_name>af/bmp/treefils.ico</selected_image_file_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="6"><contained_record DB="ICFDB" Table="gsm_node"><node_obj>1005119801.101</node_obj>
<node_code>SmrtObjTSL</node_code>
<node_description>SmrtObj Smart Links Text</node_description>
<parent_node_obj>1005118188.101</parent_node_obj>
<node_label>Smart Object Link</node_label>
<node_checked>no</node_checked>
<data_source_type>TXT</data_source_type>
<data_source>Links</data_source>
<primary_sdo>gscobful2o.w</primary_sdo>
<logical_object></logical_object>
<run_attribute></run_attribute>
<fields_to_store></fields_to_store>
<node_text_label_expression></node_text_label_expression>
<label_text_substitution_fields></label_text_substitution_fields>
<foreign_fields></foreign_fields>
<image_file_name>af/bmp/treefile.ico</image_file_name>
<selected_image_file_name>af/bmp/treefils.ico</selected_image_file_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="7"><contained_record DB="ICFDB" Table="gsm_node"><node_obj>1005119919.101</node_obj>
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
<image_file_name>af/bmp/treefile.ico</image_file_name>
<selected_image_file_name>af/bmp/treefils.ico</selected_image_file_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="8"><contained_record DB="ICFDB" Table="gsm_node"><node_obj>1005120273.101</node_obj>
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
<image_file_name>af/bmp/treefile.ico</image_file_name>
<selected_image_file_name>af/bmp/treefils.ico</selected_image_file_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="9"><contained_record DB="ICFDB" Table="gsm_node"><node_obj>1005120293.101</node_obj>
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
<image_file_name>af/bmp/treefile.ico</image_file_name>
<selected_image_file_name>af/bmp/treefils.ico</selected_image_file_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="10"><contained_record DB="ICFDB" Table="gsm_node"><node_obj>1005120448.101</node_obj>
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
<image_file_name>af/bmp/treefile.ico</image_file_name>
<selected_image_file_name>af/bmp/treefils.ico</selected_image_file_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="11"><contained_record DB="ICFDB" Table="gsm_node"><node_obj>1005121602.101</node_obj>
<node_code>ObjectType</node_code>
<node_description>Object Type</node_description>
<parent_node_obj>0</parent_node_obj>
<node_label>Object Type</node_label>
<node_checked>no</node_checked>
<data_source_type>SDO</data_source_type>
<data_source>gscotful1o.w</data_source>
<primary_sdo>gscotful1o.w</primary_sdo>
<logical_object>gscotfoldw</logical_object>
<run_attribute></run_attribute>
<fields_to_store></fields_to_store>
<node_text_label_expression>&amp;1</node_text_label_expression>
<label_text_substitution_fields>gsc_object_type.object_type_code</label_text_substitution_fields>
<foreign_fields></foreign_fields>
<image_file_name>af/bmp/treefile.ico</image_file_name>
<selected_image_file_name>af/bmp/treefils.ico</selected_image_file_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="12"><contained_record DB="ICFDB" Table="gsm_node"><node_obj>1005122064.101</node_obj>
<node_code>UIEventTSO</node_code>
<node_description>UI Events SmartObject</node_description>
<parent_node_obj>1005118188.101</parent_node_obj>
<node_label>UI Events</node_label>
<node_checked>no</node_checked>
<data_source_type>TXT</data_source_type>
<data_source>UI Events</data_source>
<primary_sdo>gscobful2o.w</primary_sdo>
<logical_object></logical_object>
<run_attribute></run_attribute>
<fields_to_store></fields_to_store>
<node_text_label_expression></node_text_label_expression>
<label_text_substitution_fields></label_text_substitution_fields>
<foreign_fields></foreign_fields>
<image_file_name>af/bmp/treefile.ico</image_file_name>
<selected_image_file_name>af/bmp/treefils.ico</selected_image_file_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="13"><contained_record DB="ICFDB" Table="gsm_node"><node_obj>1005122268.101</node_obj>
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
<image_file_name>af/bmp/treefile.ico</image_file_name>
<selected_image_file_name>af/bmp/treefils.ico</selected_image_file_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="14"><contained_record DB="ICFDB" Table="gsm_node"><node_obj>1005122269.101</node_obj>
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
<image_file_name>af/bmp/treefile.ico</image_file_name>
<selected_image_file_name>af/bmp/treefils.ico</selected_image_file_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="15"><contained_record DB="ICFDB" Table="gsm_node"><node_obj>1005122270.101</node_obj>
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
<image_file_name>af/bmp/treefile.ico</image_file_name>
<selected_image_file_name>af/bmp/treefils.ico</selected_image_file_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="16"><contained_record DB="ICFDB" Table="gsm_node"><node_obj>1005122641.101</node_obj>
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
<image_file_name>af/bmp/treefile.ico</image_file_name>
<selected_image_file_name>af/bmp/treefils.ico</selected_image_file_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="17"><contained_record DB="ICFDB" Table="gsm_node"><node_obj>1005124213.101</node_obj>
<node_code>ObjTpTSmOb</node_code>
<node_description>Object Type SmartObject Text</node_description>
<parent_node_obj>1005121602.101</parent_node_obj>
<node_label>SmartObject</node_label>
<node_checked>no</node_checked>
<data_source_type>TXT</data_source_type>
<data_source>Objects</data_source>
<primary_sdo>gscotful1o.w</primary_sdo>
<logical_object></logical_object>
<run_attribute></run_attribute>
<fields_to_store></fields_to_store>
<node_text_label_expression></node_text_label_expression>
<label_text_substitution_fields></label_text_substitution_fields>
<foreign_fields></foreign_fields>
<image_file_name>af/bmp/treefile.ico</image_file_name>
<selected_image_file_name>af/bmp/treefils.ico</selected_image_file_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="18"><contained_record DB="ICFDB" Table="gsm_node"><node_obj>1005124226.101</node_obj>
<node_code>ObjTpTAtOb</node_code>
<node_description>Object Type Attribute Value Text</node_description>
<parent_node_obj>1005121602.101</parent_node_obj>
<node_label>Attribute Value</node_label>
<node_checked>no</node_checked>
<data_source_type>TXT</data_source_type>
<data_source>Attributes</data_source>
<primary_sdo>gscotful1o.w</primary_sdo>
<logical_object></logical_object>
<run_attribute></run_attribute>
<fields_to_store></fields_to_store>
<node_text_label_expression></node_text_label_expression>
<label_text_substitution_fields></label_text_substitution_fields>
<foreign_fields></foreign_fields>
<image_file_name>af/bmp/treefile.ico</image_file_name>
<selected_image_file_name>af/bmp/treefils.ico</selected_image_file_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="19"><contained_record DB="ICFDB" Table="gsm_node"><node_obj>1005124552.101</node_obj>
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
<image_file_name>af/bmp/treefile.ico</image_file_name>
<selected_image_file_name>af/bmp/treefils.ico</selected_image_file_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="20"><contained_record DB="ICFDB" Table="gsm_node"><node_obj>1005126430.101</node_obj>
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
<image_file_name>af/bmp/treefile.ico</image_file_name>
<selected_image_file_name>af/bmp/treefils.ico</selected_image_file_name>
</contained_record>
</dataset_transaction>
</dataset_records>
</dataset>