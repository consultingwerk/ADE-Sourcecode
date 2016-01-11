<?xml version="1.0" encoding="utf-8" ?>
<dataset Transactions="7"><dataset_header DisableRI="yes" DatasetObj="1007600081.08" DateFormat="mdy" FullHeader="yes" SCMManaged="no" YearOffset="1950" DatasetCode="RYCLA" NumericFormat="AMERICAN" NumericDecimal="." OriginatingSite="90" NumericSeparator=","><deploy_dataset_obj>1007600081.08</deploy_dataset_obj>
<dataset_code>RYCLA</dataset_code>
<dataset_description>ryc_layout - Layouts</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<deploy_additions_only>no</deploy_additions_only>
<enable_data_versioning>yes</enable_data_versioning>
<deletion_dataset>yes</deletion_dataset>
<dataset_entity><dataset_entity_obj>1007600082.08</dataset_entity_obj>
<deploy_dataset_obj>1007600081.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>RYCLA</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>layout_name</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
<exclude_field_list></exclude_field_list>
<entity_mnemonic_description>ryc_layout</entity_mnemonic_description>
<entity_dbname>ICFDB</entity_dbname>
</dataset_entity>
<table_definition><name>ryc_layout</name>
<dbname>icfdb</dbname>
<index-1>XAK1ryc_layout,1,0,0,layout_name,0</index-1>
<index-2>XAK2ryc_layout,1,0,0,layout_type,0,layout_name,0</index-2>
<index-3>XPKryc_layout,1,1,0,layout_obj,0</index-3>
<field><name>layout_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Layout obj</label>
<column-label>Layout obj</column-label>
</field>
<field><name>layout_name</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(28)</format>
<initial></initial>
<label>Layout name</label>
<column-label>Layout name</column-label>
</field>
<field><name>layout_type</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(3)</format>
<initial></initial>
<label>Layout type</label>
<column-label>Layout type</column-label>
</field>
<field><name>layout_narrative</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(500)</format>
<initial></initial>
<label>Layout narrative</label>
<column-label>Layout narrative</column-label>
</field>
<field><name>layout_filename</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Layout filename</label>
<column-label>Layout filename</column-label>
</field>
<field><name>sample_image_filename</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Sample image filename</label>
<column-label>Sample image filename</column-label>
</field>
<field><name>system_owned</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>System owned</label>
<column-label>System owned</column-label>
</field>
<field><name>layout_code</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(10)</format>
<initial></initial>
<label>Layout code</label>
<column-label>Layout code</column-label>
</field>
</table_definition>
</dataset_header>
<dataset_records><dataset_transaction TransactionNo="1" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_layout" version_date="10/02/2003" version_time="49452" version_user="admin" deletion_flag="no" entity_mnemonic="RYCLA" key_field_value="1003201406" record_version_obj="3000057825.09" version_number_seq="1.09" secondary_key_value="Everything Centered" import_version_number_seq="1.09"><layout_obj>1003201406</layout_obj>
<layout_name>Everything Centered</layout_name>
<layout_type>WIN</layout_type>
<layout_narrative>Everything Centered</layout_narrative>
<layout_filename>ry/prc/rylayout01.p</layout_filename>
<sample_image_filename></sample_image_filename>
<system_owned>no</system_owned>
<layout_code>01</layout_code>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="2" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_layout" version_date="10/02/2003" version_time="49452" version_user="admin" deletion_flag="no" entity_mnemonic="RYCLA" key_field_value="1003501078" record_version_obj="3000057826.09" version_number_seq="1.09" secondary_key_value="Top/Center/Bottom" import_version_number_seq="1.09"><layout_obj>1003501078</layout_obj>
<layout_name>Top/Center/Bottom</layout_name>
<layout_type>WIN</layout_type>
<layout_narrative></layout_narrative>
<layout_filename>ry/prc/rylayout02.p</layout_filename>
<sample_image_filename></sample_image_filename>
<system_owned>no</system_owned>
<layout_code>02</layout_code>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="3" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_layout" version_date="10/02/2003" version_time="49452" version_user="admin" deletion_flag="no" entity_mnemonic="RYCLA" key_field_value="1003516362" record_version_obj="3000057827.09" version_number_seq="1.09" secondary_key_value="None" import_version_number_seq="1.09"><layout_obj>1003516362</layout_obj>
<layout_name>None</layout_name>
<layout_type>WIN</layout_type>
<layout_narrative></layout_narrative>
<layout_filename></layout_filename>
<sample_image_filename></sample_image_filename>
<system_owned>no</system_owned>
<layout_code>00</layout_code>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="4" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_layout" version_date="10/02/2003" version_time="49452" version_user="admin" deletion_flag="no" entity_mnemonic="RYCLA" key_field_value="1003704644" record_version_obj="3000057828.09" version_number_seq="1.09" secondary_key_value="Left/Center/Right" import_version_number_seq="1.09"><layout_obj>1003704644</layout_obj>
<layout_name>Left/Center/Right</layout_name>
<layout_type>WIN</layout_type>
<layout_narrative>Left/Center/Right</layout_narrative>
<layout_filename>ry/prc/rylayout04.p</layout_filename>
<sample_image_filename></sample_image_filename>
<system_owned>yes</system_owned>
<layout_code>04</layout_code>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="5" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_layout" version_date="10/02/2003" version_time="49452" version_user="admin" deletion_flag="no" entity_mnemonic="RYCLA" key_field_value="1004899067" record_version_obj="3000057829.09" version_number_seq="1.09" secondary_key_value="Top/Multi/Bottom" import_version_number_seq="1.09"><layout_obj>1004899067</layout_obj>
<layout_name>Top/Multi/Bottom</layout_name>
<layout_type>WIN</layout_type>
<layout_narrative>This layout assumes a maximum of 1 top and 1 bottom object, and any number of objects in the centre.
Objects that are resizable in the centre will share the remaining space equally, after working out how much space the non resizable centre objects need.
A small gap is left between the centre objects, and a smaller gap is left if it is a toolbar, to cope with toolbars under browsers in the centre.
All objects must be full width and toolbars must be horizontal.</layout_narrative>
<layout_filename>ry/prc/rylayoutsp.p</layout_filename>
<sample_image_filename></sample_image_filename>
<system_owned>no</system_owned>
<layout_code>03</layout_code>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="6" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_layout" version_date="10/02/2003" version_time="49452" version_user="admin" deletion_flag="no" entity_mnemonic="RYCLA" key_field_value="1005097657.101" record_version_obj="3000057830.09" version_number_seq="1.09" secondary_key_value="TreeView" import_version_number_seq="1.09"><layout_obj>1005097657.101</layout_obj>
<layout_name>TreeView</layout_name>
<layout_type>WIN</layout_type>
<layout_narrative>This is the layout procedure for the Dynamic TreeView object.</layout_narrative>
<layout_filename>ry/prc/rylayoutsp.p</layout_filename>
<sample_image_filename></sample_image_filename>
<system_owned>no</system_owned>
<layout_code>05</layout_code>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="7" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_layout" version_date="10/02/2003" version_time="49452" version_user="admin" deletion_flag="no" entity_mnemonic="RYCLA" key_field_value="1007500101.09" record_version_obj="3000057831.09" version_number_seq="1.09" secondary_key_value="Relative" import_version_number_seq="1.09"><layout_obj>1007500101.09</layout_obj>
<layout_name>Relative</layout_name>
<layout_type>WIN</layout_type>
<layout_narrative>This is a flexible layout that replaces all other layouts and should be used in future in place of all the other layouts. It supports a grid of 9x9 objects with flexible object positioning.
</layout_narrative>
<layout_filename>ry/prc/rylayoutsp.p</layout_filename>
<sample_image_filename></sample_image_filename>
<system_owned>yes</system_owned>
<layout_code>06</layout_code>
</contained_record>
</dataset_transaction>
</dataset_records>
</dataset>