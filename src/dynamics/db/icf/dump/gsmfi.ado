<?xml version="1.0" encoding="utf-8" ?>
<dataset Transactions="1"><dataset_header DisableRI="yes" DatasetObj="500380.24" DateFormat="mdy" FullHeader="yes" SCMManaged="no" YearOffset="1950" DatasetCode="GSMFI" NumericFormat="AMERICAN" NumericDecimal="." OriginatingSite="90" NumericSeparator=","><deploy_dataset_obj>500380.24</deploy_dataset_obj>
<dataset_code>GSMFI</dataset_code>
<dataset_description>gsm_filter_set - Filter Sets</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename>gsmfi.ado</default_ado_filename>
<deploy_additions_only>no</deploy_additions_only>
<enable_data_versioning>yes</enable_data_versioning>
<deletion_dataset>yes</deletion_dataset>
<dataset_entity><dataset_entity_obj>500382.24</dataset_entity_obj>
<deploy_dataset_obj>500380.24</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSMFI</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>filter_set_code</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
<exclude_field_list></exclude_field_list>
<entity_mnemonic_description>gsm_filter_set</entity_mnemonic_description>
<entity_dbname>ICFDB</entity_dbname>
</dataset_entity>
<dataset_entity><dataset_entity_obj>500383.24</dataset_entity_obj>
<deploy_dataset_obj>500380.24</deploy_dataset_obj>
<entity_sequence>2</entity_sequence>
<entity_mnemonic>GSMFD</entity_mnemonic>
<primary_entity>no</primary_entity>
<join_entity_mnemonic>GSMFI</join_entity_mnemonic>
<join_field_list>filter_set_obj,filter_set_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
<exclude_field_list></exclude_field_list>
<entity_mnemonic_description>gsm_filter_data</entity_mnemonic_description>
<entity_dbname>ICFDB</entity_dbname>
</dataset_entity>
<table_definition><name>gsm_filter_set</name>
<dbname>icfdb</dbname>
<index-1>XAK1gsm_filter_set,1,0,0,filter_set_code,0</index-1>
<index-2>XIE1gsm_filter_set,0,0,0,filter_set_description,0</index-2>
<index-3>XPKgsm_filter_set,1,1,0,filter_set_obj,0</index-3>
<field><name>filter_set_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Filter set obj</label>
<column-label>Filter set obj</column-label>
</field>
<field><name>filter_set_code</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>Filter set code</label>
<column-label>Filter set code</column-label>
</field>
<field><name>filter_set_description</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Filter set description</label>
<column-label>Filter set description</column-label>
</field>
</table_definition>
<table_definition><name>gsm_filter_data</name>
<dbname>icfdb</dbname>
<index-1>XIE1gsm_filter_data,0,0,0,filter_set_obj,0</index-1>
<index-2>XIE2gsm_filter_data,0,0,0,owning_entity_mnemonic,0</index-2>
<index-3>XIE3gsm_filter_data,0,0,0,owning_reference,0</index-3>
<index-4>XIE4gsm_filter_data,0,0,0,expression_field_name,0</index-4>
<index-5>XPKgsm_filter_data,1,1,0,filter_data_obj,0</index-5>
<field><name>filter_data_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Filter data obj</label>
<column-label>Filter data obj</column-label>
</field>
<field><name>filter_set_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Filter set obj</label>
<column-label>Filter set obj</column-label>
</field>
<field><name>owning_entity_mnemonic</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(8)</format>
<initial></initial>
<label>Owning entity</label>
<column-label>Owning entity</column-label>
</field>
<field><name>owning_reference</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(3000)</format>
<initial></initial>
<label>Owning reference</label>
<column-label>Owning reference</column-label>
</field>
<field><name>expression_field_name</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>Expression field name</label>
<column-label>Expression field name</column-label>
</field>
<field><name>expression_operator</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(15)</format>
<initial></initial>
<label>Expression operator</label>
<column-label>Expression operator</column-label>
</field>
<field><name>expression_value</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(500)</format>
<initial></initial>
<label>Expression value</label>
<column-label>Expression value</column-label>
</field>
<field><name>include_data</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>Include data</label>
<column-label>Include data</column-label>
</field>
</table_definition>
</dataset_header>
<dataset_records><dataset_transaction TransactionNo="1" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_filter_set"><filter_set_obj>725000009368.5566</filter_set_obj>
<filter_set_code>dyn-repository</filter_set_code>
<filter_set_description>Dynamics Repository Filter Set</filter_set_description>
<contained_record DB="icfdb" Table="gsm_filter_data"><filter_data_obj>725000009369.5566</filter_data_obj>
<filter_set_obj>725000009368.5566</filter_set_obj>
<owning_entity_mnemonic>RYCSO</owning_entity_mnemonic>
<owning_reference></owning_reference>
<expression_field_name>object_filename</expression_field_name>
<expression_operator>BEGINS</expression_operator>
<expression_value>palette</expression_value>
<include_data>yes</include_data>
</contained_record>
<contained_record DB="icfdb" Table="gsm_filter_data"><filter_data_obj>725000009370.5566</filter_data_obj>
<filter_set_obj>725000009368.5566</filter_set_obj>
<owning_entity_mnemonic>RYCSO</owning_entity_mnemonic>
<owning_reference></owning_reference>
<expression_field_name>object_filename</expression_field_name>
<expression_operator>BEGINS</expression_operator>
<expression_value>rytem</expression_value>
<include_data>yes</include_data>
</contained_record>
<contained_record DB="icfdb" Table="gsm_filter_data"><filter_data_obj>725000009371.5566</filter_data_obj>
<filter_set_obj>725000009368.5566</filter_set_obj>
<owning_entity_mnemonic>RYCSO</owning_entity_mnemonic>
<owning_reference></owning_reference>
<expression_field_name>object_filename</expression_field_name>
<expression_operator>BEGINS</expression_operator>
<expression_value>rywin</expression_value>
<include_data>yes</include_data>
</contained_record>
<contained_record DB="icfdb" Table="gsm_filter_data"><filter_data_obj>725000009372.5566</filter_data_obj>
<filter_set_obj>725000009368.5566</filter_set_obj>
<owning_entity_mnemonic>RYCSO</owning_entity_mnemonic>
<owning_reference></owning_reference>
<expression_field_name>object_filename</expression_field_name>
<expression_operator>BEGINS</expression_operator>
<expression_value>template</expression_value>
<include_data>yes</include_data>
</contained_record>
<contained_record DB="icfdb" Table="gsm_filter_data"><filter_data_obj>725000009373.5566</filter_data_obj>
<filter_set_obj>725000009368.5566</filter_set_obj>
<owning_entity_mnemonic>RYCSO</owning_entity_mnemonic>
<owning_reference></owning_reference>
<expression_field_name>object_filename</expression_field_name>
<expression_operator>LOOKUP</expression_operator>
<expression_value>BrowseToolbar,
BrowseToolbarNoUpdate,
BrowseToolbarView,
ContainerBuilderToolbar,
DynToolbar,
FilterToolbar,
FolderPageTop,
FolderTop,
FolderTopNoSDO,
LookupToolbar,
MenuController,
NavToolbar,
ObjcTop,
SimpleToolbar,
StandardToolbar,
TopToolOkCancel,
TopToolOkCancelNoNav</expression_value>
<include_data>yes</include_data>
</contained_record>
<contained_record DB="icfdb" Table="gsm_filter_data"><filter_data_obj>725000009375.5566</filter_data_obj>
<filter_set_obj>725000009368.5566</filter_set_obj>
<owning_entity_mnemonic>RYCSO</owning_entity_mnemonic>
<owning_reference></owning_reference>
<expression_field_name>generic_object</expression_field_name>
<expression_operator>=</expression_operator>
<expression_value>yes</expression_value>
<include_data>no</include_data>
</contained_record>
<contained_record DB="icfdb" Table="gsm_filter_data"><filter_data_obj>725000009376.5566</filter_data_obj>
<filter_set_obj>725000009368.5566</filter_set_obj>
<owning_entity_mnemonic>GSCPM</owning_entity_mnemonic>
<owning_reference></owning_reference>
<expression_field_name>product_module_code</expression_field_name>
<expression_operator>BEGINS</expression_operator>
<expression_value>af-</expression_value>
<include_data>no</include_data>
</contained_record>
<contained_record DB="icfdb" Table="gsm_filter_data"><filter_data_obj>725000009377.5566</filter_data_obj>
<filter_set_obj>725000009368.5566</filter_set_obj>
<owning_entity_mnemonic>GSCPM</owning_entity_mnemonic>
<owning_reference></owning_reference>
<expression_field_name>product_module_code</expression_field_name>
<expression_operator>BEGINS</expression_operator>
<expression_value>db-</expression_value>
<include_data>no</include_data>
</contained_record>
<contained_record DB="icfdb" Table="gsm_filter_data"><filter_data_obj>725000009378.5566</filter_data_obj>
<filter_set_obj>725000009368.5566</filter_set_obj>
<owning_entity_mnemonic>GSCPM</owning_entity_mnemonic>
<owning_reference></owning_reference>
<expression_field_name>product_module_code</expression_field_name>
<expression_operator>BEGINS</expression_operator>
<expression_value>dcu-</expression_value>
<include_data>no</include_data>
</contained_record>
<contained_record DB="icfdb" Table="gsm_filter_data"><filter_data_obj>725000009379.5566</filter_data_obj>
<filter_set_obj>725000009368.5566</filter_set_obj>
<owning_entity_mnemonic>GSCPM</owning_entity_mnemonic>
<owning_reference></owning_reference>
<expression_field_name>product_module_code</expression_field_name>
<expression_operator>BEGINS</expression_operator>
<expression_value>dlc-</expression_value>
<include_data>no</include_data>
</contained_record>
<contained_record DB="icfdb" Table="gsm_filter_data"><filter_data_obj>725000009380.5566</filter_data_obj>
<filter_set_obj>725000009368.5566</filter_set_obj>
<owning_entity_mnemonic>GSCPM</owning_entity_mnemonic>
<owning_reference></owning_reference>
<expression_field_name>product_module_code</expression_field_name>
<expression_operator>BEGINS</expression_operator>
<expression_value>dlcdb-</expression_value>
<include_data>no</include_data>
</contained_record>
<contained_record DB="icfdb" Table="gsm_filter_data"><filter_data_obj>725000009381.5566</filter_data_obj>
<filter_set_obj>725000009368.5566</filter_set_obj>
<owning_entity_mnemonic>GSCPM</owning_entity_mnemonic>
<owning_reference></owning_reference>
<expression_field_name>product_module_code</expression_field_name>
<expression_operator>BEGINS</expression_operator>
<expression_value>icf-</expression_value>
<include_data>no</include_data>
</contained_record>
<contained_record DB="icfdb" Table="gsm_filter_data"><filter_data_obj>725000009382.5566</filter_data_obj>
<filter_set_obj>725000009368.5566</filter_set_obj>
<owning_entity_mnemonic>GSCPM</owning_entity_mnemonic>
<owning_reference></owning_reference>
<expression_field_name>product_module_code</expression_field_name>
<expression_operator>BEGINS</expression_operator>
<expression_value>rtb-</expression_value>
<include_data>no</include_data>
</contained_record>
<contained_record DB="icfdb" Table="gsm_filter_data"><filter_data_obj>725000009383.5566</filter_data_obj>
<filter_set_obj>725000009368.5566</filter_set_obj>
<owning_entity_mnemonic>GSCPM</owning_entity_mnemonic>
<owning_reference></owning_reference>
<expression_field_name>product_module_code</expression_field_name>
<expression_operator>BEGINS</expression_operator>
<expression_value>ry-</expression_value>
<include_data>no</include_data>
</contained_record>
<contained_record DB="icfdb" Table="gsm_filter_data"><filter_data_obj>725000009384.5566</filter_data_obj>
<filter_set_obj>725000009368.5566</filter_set_obj>
<owning_entity_mnemonic>GSCPM</owning_entity_mnemonic>
<owning_reference></owning_reference>
<expression_field_name>product_module_code</expression_field_name>
<expression_operator>BEGINS</expression_operator>
<expression_value>scmrtb-</expression_value>
<include_data>no</include_data>
</contained_record>
<contained_record DB="icfdb" Table="gsm_filter_data"><filter_data_obj>725000009385.5566</filter_data_obj>
<filter_set_obj>725000009368.5566</filter_set_obj>
<owning_entity_mnemonic>GSCPR</owning_entity_mnemonic>
<owning_reference></owning_reference>
<expression_field_name>product_code</expression_field_name>
<expression_operator>=</expression_operator>
<expression_value>090DCU</expression_value>
<include_data>no</include_data>
</contained_record>
<contained_record DB="icfdb" Table="gsm_filter_data"><filter_data_obj>725000009386.5566</filter_data_obj>
<filter_set_obj>725000009368.5566</filter_set_obj>
<owning_entity_mnemonic>GSCPR</owning_entity_mnemonic>
<owning_reference></owning_reference>
<expression_field_name>product_code</expression_field_name>
<expression_operator>=</expression_operator>
<expression_value>090DLC</expression_value>
<include_data>no</include_data>
</contained_record>
<contained_record DB="icfdb" Table="gsm_filter_data"><filter_data_obj>725000009387.5566</filter_data_obj>
<filter_set_obj>725000009368.5566</filter_set_obj>
<owning_entity_mnemonic>GSCPR</owning_entity_mnemonic>
<owning_reference></owning_reference>
<expression_field_name>product_code</expression_field_name>
<expression_operator>=</expression_operator>
<expression_value>090DLCDB</expression_value>
<include_data>no</include_data>
</contained_record>
<contained_record DB="icfdb" Table="gsm_filter_data"><filter_data_obj>725000009388.5566</filter_data_obj>
<filter_set_obj>725000009368.5566</filter_set_obj>
<owning_entity_mnemonic>GSCPR</owning_entity_mnemonic>
<owning_reference></owning_reference>
<expression_field_name>product_code</expression_field_name>
<expression_operator>=</expression_operator>
<expression_value>090ICF</expression_value>
<include_data>no</include_data>
</contained_record>
<contained_record DB="icfdb" Table="gsm_filter_data"><filter_data_obj>725000009389.5566</filter_data_obj>
<filter_set_obj>725000009368.5566</filter_set_obj>
<owning_entity_mnemonic>GSCPR</owning_entity_mnemonic>
<owning_reference></owning_reference>
<expression_field_name>product_code</expression_field_name>
<expression_operator>=</expression_operator>
<expression_value>090RTB</expression_value>
<include_data>no</include_data>
</contained_record>
<contained_record DB="icfdb" Table="gsm_filter_data"><filter_data_obj>725000009390.5566</filter_data_obj>
<filter_set_obj>725000009368.5566</filter_set_obj>
<owning_entity_mnemonic>GSCPR</owning_entity_mnemonic>
<owning_reference></owning_reference>
<expression_field_name>product_code</expression_field_name>
<expression_operator>=</expression_operator>
<expression_value>090RY</expression_value>
<include_data>no</include_data>
</contained_record>
<contained_record DB="icfdb" Table="gsm_filter_data"><filter_data_obj>725000009391.5566</filter_data_obj>
<filter_set_obj>725000009368.5566</filter_set_obj>
<owning_entity_mnemonic>RYCSO</owning_entity_mnemonic>
<owning_reference></owning_reference>
<expression_field_name>object_filename</expression_field_name>
<expression_operator>=</expression_operator>
<expression_value>afspfoldrw.w</expression_value>
<include_data>yes</include_data>
</contained_record>
<contained_record DB="icfdb" Table="gsm_filter_data"><filter_data_obj>725000009392.5566</filter_data_obj>
<filter_set_obj>725000009368.5566</filter_set_obj>
<owning_entity_mnemonic>GSCPR</owning_entity_mnemonic>
<owning_reference></owning_reference>
<expression_field_name>product_code</expression_field_name>
<expression_operator>=</expression_operator>
<expression_value>090AF</expression_value>
<include_data>no</include_data>
</contained_record>
<contained_record DB="icfdb" Table="gsm_filter_data"><filter_data_obj>725000009393.5566</filter_data_obj>
<filter_set_obj>725000009368.5566</filter_set_obj>
<owning_entity_mnemonic>GSCPR</owning_entity_mnemonic>
<owning_reference></owning_reference>
<expression_field_name>product_code</expression_field_name>
<expression_operator>=</expression_operator>
<expression_value>090AFDB</expression_value>
<include_data>no</include_data>
</contained_record>
<contained_record DB="icfdb" Table="gsm_filter_data"><filter_data_obj>725000009394.5566</filter_data_obj>
<filter_set_obj>725000009368.5566</filter_set_obj>
<owning_entity_mnemonic>GSCPR</owning_entity_mnemonic>
<owning_reference></owning_reference>
<expression_field_name>product_code</expression_field_name>
<expression_operator>=</expression_operator>
<expression_value>090DB</expression_value>
<include_data>no</include_data>
</contained_record>
<contained_record DB="icfdb" Table="gsm_filter_data"><filter_data_obj>725000009395.5566</filter_data_obj>
<filter_set_obj>725000009368.5566</filter_set_obj>
<owning_entity_mnemonic>GSCPR</owning_entity_mnemonic>
<owning_reference></owning_reference>
<expression_field_name>product_code</expression_field_name>
<expression_operator>=</expression_operator>
<expression_value>090SCM</expression_value>
<include_data>no</include_data>
</contained_record>
</contained_record>
</dataset_transaction>
</dataset_records>
</dataset>