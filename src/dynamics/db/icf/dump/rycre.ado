<?xml version="1.0" encoding="utf-8" ?>
<dataset Transactions="196"><dataset_header DisableRI="yes" DatasetObj="9843.24" DateFormat="mdy" FullHeader="yes" SCMManaged="no" YearOffset="1950" DatasetCode="RYCRE" NumericFormat="AMERICAN" NumericDecimal="." OriginatingSite="90" NumericSeparator=","><deploy_dataset_obj>9843.24</deploy_dataset_obj>
<dataset_code>RYCRE</dataset_code>
<dataset_description>ryc_relationship</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename>rycre.ado</default_ado_filename>
<deploy_additions_only>no</deploy_additions_only>
<enable_data_versioning>yes</enable_data_versioning>
<deletion_dataset>yes</deletion_dataset>
<dataset_entity><dataset_entity_obj>9845.24</dataset_entity_obj>
<deploy_dataset_obj>9843.24</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>RYCRE</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>relationship_reference</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
<exclude_field_list></exclude_field_list>
<entity_mnemonic_description>ryc_relationship</entity_mnemonic_description>
<entity_dbname>ICFDB</entity_dbname>
</dataset_entity>
<dataset_entity><dataset_entity_obj>9847.24</dataset_entity_obj>
<deploy_dataset_obj>9843.24</deploy_dataset_obj>
<entity_sequence>2</entity_sequence>
<entity_mnemonic>RYCRF</entity_mnemonic>
<primary_entity>no</primary_entity>
<join_entity_mnemonic>RYCRE</join_entity_mnemonic>
<join_field_list>relationship_obj,relationship_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
<exclude_field_list></exclude_field_list>
<entity_mnemonic_description>ryc_relationship_field</entity_mnemonic_description>
<entity_dbname>ICFDB</entity_dbname>
</dataset_entity>
<table_definition><name>ryc_relationship</name>
<dbname>icfdb</dbname>
<index-1>XAK1ryc_relationship,1,0,0,relationship_reference,0</index-1>
<index-2>XAK2ryc_relationship,1,0,0,model_external_reference,0</index-2>
<index-3>XIE1ryc_relationship,0,0,0,relationship_description,0</index-3>
<index-4>XIE2ryc_relationship,0,0,0,parent_entity,0</index-4>
<index-5>XIE3ryc_relationship,0,0,0,child_entity,0</index-5>
<index-6>XIE4ryc_relationship,0,0,0,primary_relationship,0</index-6>
<index-7>XPKryc_relationship,1,1,0,relationship_obj,0</index-7>
<field><name>relationship_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Relationship obj</label>
<column-label>Relationship obj</column-label>
</field>
<field><name>relationship_reference</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(15)</format>
<initial></initial>
<label>Relationship reference</label>
<column-label>Relationship reference</column-label>
</field>
<field><name>relationship_description</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Relationship description</label>
<column-label>Relationship description</column-label>
</field>
<field><name>parent_entity</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(8)</format>
<initial></initial>
<label>Parent entity</label>
<column-label>Parent entity</column-label>
</field>
<field><name>child_entity</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(8)</format>
<initial></initial>
<label>Child entity</label>
<column-label>Child entity</column-label>
</field>
<field><name>primary_relationship</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>YES</initial>
<label>Primary relationship</label>
<column-label>Primary relationship</column-label>
</field>
<field><name>identifying_relationship</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>Identifying relationship</label>
<column-label>Identifying relationship</column-label>
</field>
<field><name>nulls_allowed</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>Nulls allowed</label>
<column-label>Nulls allowed</column-label>
</field>
<field><name>cardinality</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(5)</format>
<initial></initial>
<label>Cardinality</label>
<column-label>Cardinality</column-label>
</field>
<field><name>update_parent_allowed</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>YES</initial>
<label>Update parent allowed</label>
<column-label>Update parent allowed</column-label>
</field>
<field><name>parent_delete_action</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(1)</format>
<initial></initial>
<label>Parent delete action</label>
<column-label>Parent delete action</column-label>
</field>
<field><name>parent_insert_action</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(1)</format>
<initial></initial>
<label>Parent insert action</label>
<column-label>Parent insert action</column-label>
</field>
<field><name>parent_update_action</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(1)</format>
<initial></initial>
<label>Parent update action</label>
<column-label>Parent update action</column-label>
</field>
<field><name>parent_verb_phrase</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>Parent verb phrase</label>
<column-label>Parent verb phrase</column-label>
</field>
<field><name>child_delete_action</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(1)</format>
<initial></initial>
<label>Child delete action</label>
<column-label>Child delete action</column-label>
</field>
<field><name>child_insert_action</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(1)</format>
<initial></initial>
<label>Child insert action</label>
<column-label>Child insert action</column-label>
</field>
<field><name>child_update_action</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(1)</format>
<initial></initial>
<label>Child update action</label>
<column-label>Child update action</column-label>
</field>
<field><name>child_verb_phrase</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>Child verb phrase</label>
<column-label>Child verb phrase</column-label>
</field>
<field><name>model_external_reference</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Model external reference</label>
<column-label>Model external reference</column-label>
</field>
</table_definition>
<table_definition><name>ryc_relationship_field</name>
<dbname>icfdb</dbname>
<index-1>XAK1ryc_relationship_field,1,0,0,relationship_obj,0,join_sequence,0</index-1>
<index-2>XIE1ryc_relationship_field,0,0,0,parent_table_name,0</index-2>
<index-3>XIE2ryc_relationship_field,0,0,0,parent_field_name,0</index-3>
<index-4>XIE3ryc_relationship_field,0,0,0,child_table_name,0</index-4>
<index-5>XIE4ryc_relationship_field,0,0,0,child_field_name,0</index-5>
<index-6>XPKryc_relationship_field,1,1,0,relationship_field_obj,0</index-6>
<field><name>relationship_field_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Relationship field obj</label>
<column-label>Relationship field obj</column-label>
</field>
<field><name>relationship_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Relationship obj</label>
<column-label>Relationship obj</column-label>
</field>
<field><name>join_sequence</name>
<data-type>integer</data-type>
<extent>0</extent>
<format>-&gt;&gt;9</format>
<initial>   0</initial>
<label>Join sequence</label>
<column-label>Join sequence</column-label>
</field>
<field><name>parent_table_name</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>Parent table name</label>
<column-label>Parent table name</column-label>
</field>
<field><name>parent_field_name</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>Parent field name</label>
<column-label>Parent field name</column-label>
</field>
<field><name>use_parent_constant_value</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>Use parent constant value</label>
<column-label>Use parent constant value</column-label>
</field>
<field><name>parent_constant_value</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Parent constant value</label>
<column-label>Parent constant value</column-label>
</field>
<field><name>child_table_name</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>Child table name</label>
<column-label>Child table name</column-label>
</field>
<field><name>child_field_name</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>Child field name</label>
<column-label>Child field name</column-label>
</field>
<field><name>use_child_constant_value</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>Use child constant value</label>
<column-label>Use child constant value</column-label>
</field>
<field><name>child_constant_value</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Child constant value</label>
<column-label>Child constant value</column-label>
</field>
</table_definition>
</dataset_header>
<dataset_records><dataset_transaction TransactionNo="1" TransactionType="DELETION"><contained_record version_date="08/05/2003" version_time="24859" version_user="admin" deletion_flag="yes" entity_mnemonic="rycre" key_field_value="9805.24" record_version_obj="3000045071.09" version_number_seq="7.09" secondary_key_value="ICFREL_00000158" import_version_number_seq="7.09"/>
</dataset_transaction>
<dataset_transaction TransactionNo="2" TransactionType="DELETION"><contained_record version_date="08/05/2003" version_time="24859" version_user="admin" deletion_flag="yes" entity_mnemonic="rycre" key_field_value="9815.24" record_version_obj="3000045081.09" version_number_seq="7.09" secondary_key_value="ICFREL_00000163" import_version_number_seq="7.09"/>
</dataset_transaction>
<dataset_transaction TransactionNo="3" TransactionType="DELETION"><contained_record version_date="08/05/2003" version_time="24859" version_user="admin" deletion_flag="yes" entity_mnemonic="rycre" key_field_value="9819.24" record_version_obj="3000045085.09" version_number_seq="7.09" secondary_key_value="ICFREL_00000165" import_version_number_seq="7.09"/>
</dataset_transaction>
<dataset_transaction TransactionNo="4" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61389" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9489.24" record_version_obj="3000044757.09" version_number_seq="4" secondary_key_value="ICFREL_00000001" import_version_number_seq="4"><relationship_obj>9489.24</relationship_obj>
<relationship_reference>ICFREL_00000001</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSCCP</parent_entity>
<child_entity>GSCEP</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>R</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>is used by</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>is used by</child_verb_phrase>
<model_external_reference>c829bc84_4154d629_a567dd8a_32a73d54_239_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051099.09</relationship_field_obj>
<relationship_obj>9489.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsc_custom_procedure</parent_table_name>
<parent_field_name>custom_procedure_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsc_entity_mnemonic_procedure</child_table_name>
<child_field_name>custom_procedure_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="5" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61389" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9491.24" record_version_obj="3000044759.09" version_number_seq="4" secondary_key_value="ICFREL_00000002" import_version_number_seq="4"><relationship_obj>9491.24</relationship_obj>
<relationship_reference>ICFREL_00000002</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSMCA</parent_entity>
<child_entity>GSCCP</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>R</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>of</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>of</child_verb_phrase>
<model_external_reference>a192e710_429731d6_c55a7399_23a1543f_c7_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051100.09</relationship_field_obj>
<relationship_obj>9491.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsm_category</parent_table_name>
<parent_field_name>category_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsc_custom_procedure</child_table_name>
<child_field_name>category_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="6" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61389" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9493.24" record_version_obj="3000044761.09" version_number_seq="4" secondary_key_value="ICFREL_00000003" import_version_number_seq="4"><relationship_obj>9493.24</relationship_obj>
<relationship_reference>ICFREL_00000003</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>RYCRE</parent_entity>
<child_entity>GSCDE</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>yes</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>S</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>S</parent_update_action>
<parent_verb_phrase>is the join for</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>S</child_insert_action>
<child_update_action>S</child_update_action>
<child_verb_phrase>is the join for</child_verb_phrase>
<model_external_reference>1e644fd7_495e375f_e9e44e92_48ba9ab9_0_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051101.09</relationship_field_obj>
<relationship_obj>9493.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>ryc_relationship</parent_table_name>
<parent_field_name>relationship_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsc_dataset_entity</child_table_name>
<child_field_name>relationship_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="7" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61389" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9495.24" record_version_obj="3000044763.09" version_number_seq="4" secondary_key_value="ICFREL_00000004" import_version_number_seq="4"><relationship_obj>9495.24</relationship_obj>
<relationship_reference>ICFREL_00000004</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSCEM</parent_entity>
<child_entity>GSCDE</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>yes</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>R</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>S</parent_update_action>
<parent_verb_phrase>is the join partner for</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>S</child_insert_action>
<child_update_action>S</child_update_action>
<child_verb_phrase>is the join partner for</child_verb_phrase>
<model_external_reference>b6ba4bbf_441f1f7f_fd615aa2_ca24a472_392_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051102.09</relationship_field_obj>
<relationship_obj>9495.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsc_entity_mnemonic</parent_table_name>
<parent_field_name>entity_mnemonic</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsc_dataset_entity</child_table_name>
<child_field_name>join_entity_mnemonic</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="8" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61389" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9497.24" record_version_obj="3000044765.09" version_number_seq="4" secondary_key_value="ICFREL_00000005" import_version_number_seq="4"><relationship_obj>9497.24</relationship_obj>
<relationship_reference>ICFREL_00000005</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSCEM</parent_entity>
<child_entity>GSCDE</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>R</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>is included in</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>is included in</child_verb_phrase>
<model_external_reference>a82b2a07_44d3adc8_2c6f47af_c5d11fef_38c_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051103.09</relationship_field_obj>
<relationship_obj>9497.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsc_entity_mnemonic</parent_table_name>
<parent_field_name>entity_mnemonic</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsc_dataset_entity</child_table_name>
<child_field_name>entity_mnemonic</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="9" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61389" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9499.24" record_version_obj="3000044767.09" version_number_seq="4" secondary_key_value="ICFREL_00000006" import_version_number_seq="4"><relationship_obj>9499.24</relationship_obj>
<relationship_reference>ICFREL_00000006</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSCDD</parent_entity>
<child_entity>GSCDE</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>C</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>includes</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>includes</child_verb_phrase>
<model_external_reference>9792f069_417bb205_36fd6ab4_57ba0c95_38b_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051104.09</relationship_field_obj>
<relationship_obj>9499.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsc_deploy_dataset</parent_table_name>
<parent_field_name>deploy_dataset_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsc_dataset_entity</child_table_name>
<child_field_name>deploy_dataset_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="10" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61389" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9501.24" record_version_obj="3000044769.09" version_number_seq="4" secondary_key_value="ICFREL_00000007" import_version_number_seq="4"><relationship_obj>9501.24</relationship_obj>
<relationship_reference>ICFREL_00000007</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSCEM</parent_entity>
<child_entity>GSCDC</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>N</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>N</parent_update_action>
<parent_verb_phrase></parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase></child_verb_phrase>
<model_external_reference>68854408_446384c6_f7243490_2403a62_280_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051105.09</relationship_field_obj>
<relationship_obj>9501.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsc_entity_mnemonic</parent_table_name>
<parent_field_name>entity_mnemonic</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsc_default_code</child_table_name>
<child_field_name>owning_entity_mnemonic</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="11" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61389" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9503.24" record_version_obj="3000044771.09" version_number_seq="4" secondary_key_value="ICFREL_00000008" import_version_number_seq="4"><relationship_obj>9503.24</relationship_obj>
<relationship_reference>ICFREL_00000008</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSCDS</parent_entity>
<child_entity>GSCDC</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>R</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>has</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>has</child_verb_phrase>
<model_external_reference>b68db715_4a2a481b_95dc12bc_155cd01f_27f_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051106.09</relationship_field_obj>
<relationship_obj>9503.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsc_default_set</parent_table_name>
<parent_field_name>default_set_code</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsc_default_code</child_table_name>
<child_field_name>default_set_code</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="12" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61389" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9505.24" record_version_obj="3000044773.09" version_number_seq="4" secondary_key_value="ICFREL_00000009" import_version_number_seq="4"><relationship_obj>9505.24</relationship_obj>
<relationship_reference>ICFREL_00000009</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSCDS</parent_entity>
<child_entity>GSCDU</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>R</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>is used by</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>is used by</child_verb_phrase>
<model_external_reference>7f6c64ad_4f18937e_fd087a8d_f61206c6_27e_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051107.09</relationship_field_obj>
<relationship_obj>9505.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsc_default_set</parent_table_name>
<parent_field_name>default_set_code</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsc_default_set_usage</child_table_name>
<child_field_name>default_set_code</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="13" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61389" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9507.24" record_version_obj="3000044775.09" version_number_seq="4" secondary_key_value="ICFREL_00000010" import_version_number_seq="4"><relationship_obj>9507.24</relationship_obj>
<relationship_reference>ICFREL_00000010</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSCEM</parent_entity>
<child_entity>GSCDU</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>N</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>N</parent_update_action>
<parent_verb_phrase></parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase></child_verb_phrase>
<model_external_reference>2fe4558_40cd3659_3991f896_c47c105e_289_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051108.09</relationship_field_obj>
<relationship_obj>9507.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsc_entity_mnemonic</parent_table_name>
<parent_field_name>entity_mnemonic</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsc_default_set_usage</child_table_name>
<child_field_name>owning_entity_mnemonic</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="14" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61389" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9509.24" record_version_obj="3000044777.09" version_number_seq="4" secondary_key_value="ICFREL_00000011" import_version_number_seq="4"><relationship_obj>9509.24</relationship_obj>
<relationship_reference>ICFREL_00000011</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSCDM</parent_entity>
<child_entity>GSCDT</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>R</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>is the default for</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>is the default for</child_verb_phrase>
<model_external_reference>5425309d_4cf84eba_dafcb19f_f3ac7bff_111_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051109.09</relationship_field_obj>
<relationship_obj>9509.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsc_delivery_method</parent_table_name>
<parent_field_name>delivery_method_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsc_document_type</child_table_name>
<child_field_name>default_delivery_method</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="15" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61389" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9511.24" record_version_obj="3000044779.09" version_number_seq="4" secondary_key_value="ICFREL_00000012" import_version_number_seq="4"><relationship_obj>9511.24</relationship_obj>
<relationship_reference>ICFREL_00000012</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSCDD</parent_entity>
<child_entity>GSCPD</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>C</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>is included in</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>is included in</child_verb_phrase>
<model_external_reference>f61ac00d_4c90d4f8_232b2588_1a4318dc_3cf_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051110.09</relationship_field_obj>
<relationship_obj>9511.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsc_deploy_dataset</parent_table_name>
<parent_field_name>deploy_dataset_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsc_package_dataset</child_table_name>
<child_field_name>deploy_dataset_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="16" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61389" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9513.24" record_version_obj="3000044781.09" version_number_seq="4" secondary_key_value="ICFREL_00000013" import_version_number_seq="4"><relationship_obj>9513.24</relationship_obj>
<relationship_reference>ICFREL_00000013</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSCDD</parent_entity>
<child_entity>GSTDF</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>C</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>generated</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>generated</child_verb_phrase>
<model_external_reference>9bf75b4c_439162c4_fff3b79c_eed69acc_3cd_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051111.09</relationship_field_obj>
<relationship_obj>9513.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsc_deploy_dataset</parent_table_name>
<parent_field_name>deploy_dataset_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gst_dataset_file</child_table_name>
<child_field_name>deploy_dataset_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="17" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61389" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9515.24" record_version_obj="3000044783.09" version_number_seq="4" secondary_key_value="ICFREL_00000014" import_version_number_seq="4"><relationship_obj>9515.24</relationship_obj>
<relationship_reference>ICFREL_00000014</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSCDP</parent_entity>
<child_entity>GSTDP</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>R</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>has</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>has</child_verb_phrase>
<model_external_reference>d3d5135f_449ccfb9_b12d139e_33089edd_3d0_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051112.09</relationship_field_obj>
<relationship_obj>9515.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsc_deploy_package</parent_table_name>
<parent_field_name>deploy_package_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gst_deployment</child_table_name>
<child_field_name>deploy_package_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="18" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61390" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9517.24" record_version_obj="3000044785.09" version_number_seq="4" secondary_key_value="ICFREL_00000015" import_version_number_seq="4"><relationship_obj>9517.24</relationship_obj>
<relationship_reference>ICFREL_00000015</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSCDP</parent_entity>
<child_entity>GSCPD</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>C</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>includes</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>includes</child_verb_phrase>
<model_external_reference>27cbc9f3_4b588f41_37d94cbb_11765ace_3ce_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051113.09</relationship_field_obj>
<relationship_obj>9517.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsc_deploy_package</parent_table_name>
<parent_field_name>deploy_package_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsc_package_dataset</child_table_name>
<child_field_name>deploy_package_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="19" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61390" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9519.24" record_version_obj="3000044787.09" version_number_seq="4" secondary_key_value="ICFREL_00000016" import_version_number_seq="4"><relationship_obj>9519.24</relationship_obj>
<relationship_reference>ICFREL_00000016</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSCDT</parent_entity>
<child_entity>GSMRD</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>R</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>has</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>has</child_verb_phrase>
<model_external_reference>94cccd87_4d6bfa72_7b0faebe_83da6c60_31d_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051114.09</relationship_field_obj>
<relationship_obj>9519.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsc_document_type</parent_table_name>
<parent_field_name>document_type_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsm_report_definition</child_table_name>
<child_field_name>document_type_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="20" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61390" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9521.24" record_version_obj="3000044789.09" version_number_seq="4" secondary_key_value="ICFREL_00000017" import_version_number_seq="4"><relationship_obj>9521.24</relationship_obj>
<relationship_reference>ICFREL_00000017</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSCDT</parent_entity>
<child_entity>GSMDR</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>R</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>uses</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>uses</child_verb_phrase>
<model_external_reference>7bfc95a2_4b005535_73544785_fc703653_31b_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051115.09</relationship_field_obj>
<relationship_obj>9521.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsc_document_type</parent_table_name>
<parent_field_name>document_type_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsm_default_report_format</child_table_name>
<child_field_name>document_type_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="21" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61390" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9523.24" record_version_obj="3000044791.09" version_number_seq="4" secondary_key_value="ICFREL_00000018" import_version_number_seq="4"><relationship_obj>9523.24</relationship_obj>
<relationship_reference>ICFREL_00000018</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSCEM</parent_entity>
<child_entity>GSCED</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>C</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>has</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>has</child_verb_phrase>
<model_external_reference>196dfe20_47333988_a7c340bb_f4c9d18d_3ba_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051116.09</relationship_field_obj>
<relationship_obj>9523.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsc_entity_mnemonic</parent_table_name>
<parent_field_name>entity_mnemonic</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsc_entity_display_field</child_table_name>
<child_field_name>entity_mnemonic</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="22" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61390" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9525.24" record_version_obj="3000044793.09" version_number_seq="4" secondary_key_value="ICFREL_00000019" import_version_number_seq="4"><relationship_obj>9525.24</relationship_obj>
<relationship_reference>ICFREL_00000019</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSCEM</parent_entity>
<child_entity>RYCRE</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>R</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>is the child of</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>is the child of</child_verb_phrase>
<model_external_reference>6b319892_48d669db_5bb6778a_c2a7819f_0_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051123.09</relationship_field_obj>
<relationship_obj>9525.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsc_entity_mnemonic</parent_table_name>
<parent_field_name>entity_mnemonic</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>ryc_relationship</child_table_name>
<child_field_name>child_entity</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="23" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61390" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9527.24" record_version_obj="3000044795.09" version_number_seq="4" secondary_key_value="ICFREL_00000020" import_version_number_seq="4"><relationship_obj>9527.24</relationship_obj>
<relationship_reference>ICFREL_00000020</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSCEM</parent_entity>
<child_entity>RYCRE</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>R</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>is the parent of</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>is the parent of</child_verb_phrase>
<model_external_reference>5b236368_42a18463_eb4ce39d_7f21709a_0_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051124.09</relationship_field_obj>
<relationship_obj>9527.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsc_entity_mnemonic</parent_table_name>
<parent_field_name>entity_mnemonic</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>ryc_relationship</child_table_name>
<child_field_name>parent_entity</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="24" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="10/02/2003" version_time="49444" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9529.24" record_version_obj="3000057796.09" version_number_seq="1.09" secondary_key_value="ICFREL_00000021" import_version_number_seq="1.09"><relationship_obj>9529.24</relationship_obj>
<relationship_reference>ICFREL_00000021</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSCEM</parent_entity>
<child_entity>GSCEM</child_entity>
<primary_relationship>no</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>yes</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>no</update_parent_allowed>
<parent_delete_action>S</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>S</parent_update_action>
<parent_verb_phrase>is the master of</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>S</child_insert_action>
<child_update_action>S</child_update_action>
<child_verb_phrase>is the master of</child_verb_phrase>
<model_external_reference>22843c84_44344329_afe6b93_7e7262dc_0_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000004957.09</relationship_field_obj>
<relationship_obj>9529.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsc_entity_mnemonic</parent_table_name>
<parent_field_name>entity_mnemonic</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsc_entity_mnemonic</child_table_name>
<child_field_name>version_master_entity</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="25" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61390" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9531.24" record_version_obj="3000044797.09" version_number_seq="4" secondary_key_value="ICFREL_00000022" import_version_number_seq="4"><relationship_obj>9531.24</relationship_obj>
<relationship_reference>ICFREL_00000022</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSCEM</parent_entity>
<child_entity>GSTAD</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>C</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>has</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>has</child_verb_phrase>
<model_external_reference>76abe77a_41c77c1d_2632dc8b_100df2fc_3b9_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051125.09</relationship_field_obj>
<relationship_obj>9531.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsc_entity_mnemonic</parent_table_name>
<parent_field_name>entity_mnemonic</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gst_audit</child_table_name>
<child_field_name>owning_entity_mnemonic</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="26" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61390" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9533.24" record_version_obj="3000044799.09" version_number_seq="4" secondary_key_value="ICFREL_00000023" import_version_number_seq="4"><relationship_obj>9533.24</relationship_obj>
<relationship_reference>ICFREL_00000023</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSCEM</parent_entity>
<child_entity>GSTRV</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>R</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>contains</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>contains</child_verb_phrase>
<model_external_reference>2d2932d6_4abe52cf_12a6ca89_fd4b2c94_38a_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051126.09</relationship_field_obj>
<relationship_obj>9533.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsc_entity_mnemonic</parent_table_name>
<parent_field_name>entity_mnemonic</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gst_record_version</child_table_name>
<child_field_name>entity_mnemonic</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="27" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61390" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9535.24" record_version_obj="3000044801.09" version_number_seq="4" secondary_key_value="ICFREL_00000024" import_version_number_seq="4"><relationship_obj>9535.24</relationship_obj>
<relationship_reference>ICFREL_00000024</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSCEM</parent_entity>
<child_entity>GSMCM</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>yes</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>R</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>S</parent_update_action>
<parent_verb_phrase></parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>S</child_insert_action>
<child_update_action>S</child_update_action>
<child_verb_phrase></child_verb_phrase>
<model_external_reference>6ca3e0e7_4120b9d7_50215a85_fb2c20e8_35a_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051127.09</relationship_field_obj>
<relationship_obj>9535.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsc_entity_mnemonic</parent_table_name>
<parent_field_name>entity_mnemonic</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsm_comment</child_table_name>
<child_field_name>owning_entity_mnemonic</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="28" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61390" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9537.24" record_version_obj="3000044803.09" version_number_seq="4" secondary_key_value="ICFREL_00000025" import_version_number_seq="4"><relationship_obj>9537.24</relationship_obj>
<relationship_reference>ICFREL_00000025</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSCEM</parent_entity>
<child_entity>GSMEX</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>yes</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>N</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>S</parent_update_action>
<parent_verb_phrase></parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>S</child_insert_action>
<child_update_action>S</child_update_action>
<child_verb_phrase></child_verb_phrase>
<model_external_reference>adb3d04e_4942dec3_76a135a8_d94233f3_30f_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051128.09</relationship_field_obj>
<relationship_obj>9537.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsc_entity_mnemonic</parent_table_name>
<parent_field_name>entity_mnemonic</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsm_external_xref</child_table_name>
<child_field_name>external_entity_mnemonic</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="29" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61390" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9539.24" record_version_obj="3000044805.09" version_number_seq="4" secondary_key_value="ICFREL_00000026" import_version_number_seq="4"><relationship_obj>9539.24</relationship_obj>
<relationship_reference>ICFREL_00000026</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSCEM</parent_entity>
<child_entity>GSMEX</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>N</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase></parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase></child_verb_phrase>
<model_external_reference>cce802cc_49e68ff8_e0943288_8d10f607_30e_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051129.09</relationship_field_obj>
<relationship_obj>9539.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsc_entity_mnemonic</parent_table_name>
<parent_field_name>entity_mnemonic</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsm_external_xref</child_table_name>
<child_field_name>internal_entity_mnemonic</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="30" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61390" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9541.24" record_version_obj="3000044807.09" version_number_seq="4" secondary_key_value="ICFREL_00000027" import_version_number_seq="4"><relationship_obj>9541.24</relationship_obj>
<relationship_reference>ICFREL_00000027</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSCEM</parent_entity>
<child_entity>GSMEX</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>N</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase></parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase></child_verb_phrase>
<model_external_reference>32babb97_483fca96_b5ccaaad_ef4495d8_30d_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051130.09</relationship_field_obj>
<relationship_obj>9541.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsc_entity_mnemonic</parent_table_name>
<parent_field_name>entity_mnemonic</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsm_external_xref</child_table_name>
<child_field_name>related_entity_mnemonic</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="31" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61390" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9543.24" record_version_obj="3000044809.09" version_number_seq="4" secondary_key_value="ICFREL_00000028" import_version_number_seq="4"><relationship_obj>9543.24</relationship_obj>
<relationship_reference>ICFREL_00000028</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSCEM</parent_entity>
<child_entity>GSMSS</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>R</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>is for</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>is for</child_verb_phrase>
<model_external_reference>fe819636_4ae3a90b_245e09a2_75a83d9a_2b0_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051131.09</relationship_field_obj>
<relationship_obj>9543.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsc_entity_mnemonic</parent_table_name>
<parent_field_name>entity_mnemonic</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsm_security_structure</child_table_name>
<child_field_name>owning_entity_mnemonic</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="32" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61390" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9545.24" record_version_obj="3000044811.09" version_number_seq="4" secondary_key_value="ICFREL_00000029" import_version_number_seq="4"><relationship_obj>9545.24</relationship_obj>
<relationship_reference>ICFREL_00000029</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSCEM</parent_entity>
<child_entity>GSMUL</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>R</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>is allocated to</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>is allocated to</child_verb_phrase>
<model_external_reference>a9de6d2c_47e86c66_208954b4_40876689_2a2_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051132.09</relationship_field_obj>
<relationship_obj>9545.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsc_entity_mnemonic</parent_table_name>
<parent_field_name>entity_mnemonic</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsm_user_allocation</child_table_name>
<child_field_name>owning_entity_mnemonic</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="33" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61390" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9547.24" record_version_obj="3000044813.09" version_number_seq="4" secondary_key_value="ICFREL_00000030" import_version_number_seq="4"><relationship_obj>9547.24</relationship_obj>
<relationship_reference>ICFREL_00000030</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSCEM</parent_entity>
<child_entity>GSMEF</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>R</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>has</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>has</child_verb_phrase>
<model_external_reference>b423b832_4443bed1_21111087_97efce5a_2a0_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051133.09</relationship_field_obj>
<relationship_obj>9547.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsc_entity_mnemonic</parent_table_name>
<parent_field_name>entity_mnemonic</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsm_entity_field</child_table_name>
<child_field_name>owning_entity_mnemonic</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="34" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61390" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9549.24" record_version_obj="3000044815.09" version_number_seq="4" secondary_key_value="ICFREL_00000031" import_version_number_seq="4"><relationship_obj>9549.24</relationship_obj>
<relationship_reference>ICFREL_00000031</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSCEM</parent_entity>
<child_entity>GSCEP</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>R</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>uses</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>uses</child_verb_phrase>
<model_external_reference>dbd299fc_4a842a88_5c2c1cae_d26710a0_238_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051134.09</relationship_field_obj>
<relationship_obj>9549.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsc_entity_mnemonic</parent_table_name>
<parent_field_name>entity_mnemonic</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsc_entity_mnemonic_procedure</child_table_name>
<child_field_name>owning_entity_mnemonic</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="35" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61390" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9551.24" record_version_obj="3000044817.09" version_number_seq="4" secondary_key_value="ICFREL_00000032" import_version_number_seq="4"><relationship_obj>9551.24</relationship_obj>
<relationship_reference>ICFREL_00000032</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSCEM</parent_entity>
<child_entity>GSCSQ</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>R</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase></parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase></child_verb_phrase>
<model_external_reference>83e86b2c_48e8f99b_17c5388f_b3d4db41_121_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051135.09</relationship_field_obj>
<relationship_obj>9551.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsc_entity_mnemonic</parent_table_name>
<parent_field_name>entity_mnemonic</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsc_sequence</child_table_name>
<child_field_name>owning_entity_mnemonic</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="36" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61390" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9553.24" record_version_obj="3000044819.09" version_number_seq="4" secondary_key_value="ICFREL_00000033" import_version_number_seq="4"><relationship_obj>9553.24</relationship_obj>
<relationship_reference>ICFREL_00000033</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSCEM</parent_entity>
<child_entity>GSMCA</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>R</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase></parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase></child_verb_phrase>
<model_external_reference>75afff6d_4a944aab_b31d068c_44f9166e_11f_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051136.09</relationship_field_obj>
<relationship_obj>9553.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsc_entity_mnemonic</parent_table_name>
<parent_field_name>entity_mnemonic</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsm_category</child_table_name>
<child_field_name>related_entity_mnemonic</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="37" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61390" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9555.24" record_version_obj="3000044821.09" version_number_seq="4" secondary_key_value="ICFREL_00000034" import_version_number_seq="4"><relationship_obj>9555.24</relationship_obj>
<relationship_reference>ICFREL_00000034</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSCEM</parent_entity>
<child_entity>GSMCA</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>yes</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>S</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>S</parent_update_action>
<parent_verb_phrase>is for the owning object in the related</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>S</child_insert_action>
<child_update_action>S</child_update_action>
<child_verb_phrase>is for the owning object in the related</child_verb_phrase>
<model_external_reference>9ad58af3_42d7b9cd_73f239ba_f8f378e_11e_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051137.09</relationship_field_obj>
<relationship_obj>9555.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsc_entity_mnemonic</parent_table_name>
<parent_field_name>entity_mnemonic</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsm_category</child_table_name>
<child_field_name>owning_entity_mnemonic</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="38" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61390" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9557.24" record_version_obj="3000044823.09" version_number_seq="4" secondary_key_value="ICFREL_00000035" import_version_number_seq="4"><relationship_obj>9557.24</relationship_obj>
<relationship_reference>ICFREL_00000035</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSCLG</parent_entity>
<child_entity>GSCER</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>R</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>has</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>has</child_verb_phrase>
<model_external_reference>93a47ed0_4e8de2b6_407e02bd_debcbfcd_33f_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051138.09</relationship_field_obj>
<relationship_obj>9557.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsc_language</parent_table_name>
<parent_field_name>language_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsc_error</child_table_name>
<child_field_name>language_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="39" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61391" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9559.24" record_version_obj="3000044825.09" version_number_seq="4" secondary_key_value="ICFREL_00000036" import_version_number_seq="4"><relationship_obj>9559.24</relationship_obj>
<relationship_reference>ICFREL_00000036</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSMCR</parent_entity>
<child_entity>GSCGC</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>yes</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>R</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>S</parent_update_action>
<parent_verb_phrase>is the default currency for</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>S</child_insert_action>
<child_update_action>S</child_update_action>
<child_verb_phrase>is the default currency for</child_verb_phrase>
<model_external_reference>18f539e3_4bf9015c_3b43a39f_99352b7d_246_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051139.09</relationship_field_obj>
<relationship_obj>9559.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsm_currency</parent_table_name>
<parent_field_name>currency_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsc_global_control</child_table_name>
<child_field_name>default_currency_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="40" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61391" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9561.24" record_version_obj="3000044827.09" version_number_seq="4" secondary_key_value="ICFREL_00000037" import_version_number_seq="4"><relationship_obj>9561.24</relationship_obj>
<relationship_reference>ICFREL_00000037</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSCNA</parent_entity>
<child_entity>GSCGC</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>R</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>is the default for</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>is the default for</child_verb_phrase>
<model_external_reference>dc6e1db8_4976e48e_c86912bf_11e437e2_125_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051140.09</relationship_field_obj>
<relationship_obj>9561.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsc_nationality</parent_table_name>
<parent_field_name>nationality_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsc_global_control</child_table_name>
<child_field_name>default_nationality_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="41" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61391" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9563.24" record_version_obj="3000044829.09" version_number_seq="4" secondary_key_value="ICFREL_00000038" import_version_number_seq="4"><relationship_obj>9563.24</relationship_obj>
<relationship_reference>ICFREL_00000038</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSMCY</parent_entity>
<child_entity>GSCGC</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>R</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>is the default for</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>is the default for</child_verb_phrase>
<model_external_reference>b60ae5bc_4b4a288f_6b9ba283_ae3a2a7e_11a_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051141.09</relationship_field_obj>
<relationship_obj>9563.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsm_country</parent_table_name>
<parent_field_name>country_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsc_global_control</child_table_name>
<child_field_name>default_country_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="42" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61391" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9565.24" record_version_obj="3000044831.09" version_number_seq="4" secondary_key_value="ICFREL_00000039" import_version_number_seq="4"><relationship_obj>9565.24</relationship_obj>
<relationship_reference>ICFREL_00000039</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSCLG</parent_entity>
<child_entity>GSCGC</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>N</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>N</parent_update_action>
<parent_verb_phrase></parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase></child_verb_phrase>
<model_external_reference>7795d843_4031b2d2_d9a400b1_d4da3c38_f5_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051142.09</relationship_field_obj>
<relationship_obj>9565.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsc_language</parent_table_name>
<parent_field_name>language_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsc_global_control</child_table_name>
<child_field_name>default_language_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="43" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61391" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9567.24" record_version_obj="3000044833.09" version_number_seq="4" secondary_key_value="ICFREL_00000040" import_version_number_seq="4"><relationship_obj>9567.24</relationship_obj>
<relationship_reference>ICFREL_00000040</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSCIA</parent_entity>
<child_entity>GSMOM</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>yes</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>C</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>S</parent_update_action>
<parent_verb_phrase>is applicable to</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>S</child_insert_action>
<child_update_action>S</child_update_action>
<child_verb_phrase>is applicable to</child_verb_phrase>
<model_external_reference>5b757f3f_4e588fc6_35d0718e_feb05615_334_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051143.09</relationship_field_obj>
<relationship_obj>9567.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsc_instance_attribute</parent_table_name>
<parent_field_name>instance_attribute_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsm_object_menu_structure</child_table_name>
<child_field_name>instance_attribute_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="44" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61391" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9569.24" record_version_obj="3000044835.09" version_number_seq="4" secondary_key_value="ICFREL_00000041" import_version_number_seq="4"><relationship_obj>9569.24</relationship_obj>
<relationship_reference>ICFREL_00000041</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSCIA</parent_entity>
<child_entity>GSMMI</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>yes</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>R</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>S</parent_update_action>
<parent_verb_phrase>is posted by</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>S</child_insert_action>
<child_update_action>S</child_update_action>
<child_verb_phrase>is posted by</child_verb_phrase>
<model_external_reference>ef46c0ad_48eef137_7e4462bc_92892f55_2fd_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051144.09</relationship_field_obj>
<relationship_obj>9569.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsc_instance_attribute</parent_table_name>
<parent_field_name>instance_attribute_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsm_menu_item</child_table_name>
<child_field_name>instance_attribute_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="45" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61391" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9571.24" record_version_obj="3000044837.09" version_number_seq="4" secondary_key_value="ICFREL_00000042" import_version_number_seq="4"><relationship_obj>9571.24</relationship_obj>
<relationship_reference>ICFREL_00000042</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSCIA</parent_entity>
<child_entity>GSMSS</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>yes</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>R</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>S</parent_update_action>
<parent_verb_phrase>uses</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>S</child_insert_action>
<child_update_action>S</child_update_action>
<child_verb_phrase>uses</child_verb_phrase>
<model_external_reference>7b2df56c_4c8bae03_fe32a3a3_fc44330_2fc_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051145.09</relationship_field_obj>
<relationship_obj>9571.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsc_instance_attribute</parent_table_name>
<parent_field_name>instance_attribute_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsm_security_structure</child_table_name>
<child_field_name>instance_attribute_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="46" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61391" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9573.24" record_version_obj="3000044839.09" version_number_seq="4" secondary_key_value="ICFREL_00000043" import_version_number_seq="4"><relationship_obj>9573.24</relationship_obj>
<relationship_reference>ICFREL_00000043</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSCIC</parent_entity>
<child_entity>GSMMI</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>yes</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>R</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>S</parent_update_action>
<parent_verb_phrase>has</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>S</child_insert_action>
<child_update_action>S</child_update_action>
<child_verb_phrase>has</child_verb_phrase>
<model_external_reference>43f425f3_4f72d9af_465f2daf_377fc957_3c4_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051146.09</relationship_field_obj>
<relationship_obj>9573.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsc_item_category</parent_table_name>
<parent_field_name>item_category_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsm_menu_item</child_table_name>
<child_field_name>item_category_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="47" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61391" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9575.24" record_version_obj="3000044841.09" version_number_seq="4" secondary_key_value="ICFREL_00000044" import_version_number_seq="4"><relationship_obj>9575.24</relationship_obj>
<relationship_reference>ICFREL_00000044</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSCIC</parent_entity>
<child_entity>GSCIC</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>yes</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>N</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>N</parent_update_action>
<parent_verb_phrase></parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>N</child_insert_action>
<child_update_action>N</child_update_action>
<child_verb_phrase></child_verb_phrase>
<model_external_reference>c34bcca2_439c1023_5ab65680_992ae143_3c3_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051147.09</relationship_field_obj>
<relationship_obj>9575.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsc_item_category</parent_table_name>
<parent_field_name>item_category_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsc_item_category</child_table_name>
<child_field_name>parent_item_category_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="48" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61391" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9577.24" record_version_obj="3000044843.09" version_number_seq="4" secondary_key_value="ICFREL_00000045" import_version_number_seq="4"><relationship_obj>9577.24</relationship_obj>
<relationship_reference>ICFREL_00000045</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSCLG</parent_entity>
<child_entity>GSMTI</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>R</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>has</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>has</child_verb_phrase>
<model_external_reference>9ac7835f_4c8c01c3_8e9588ba_3f14428a_0_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051148.09</relationship_field_obj>
<relationship_obj>9577.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsc_language</parent_table_name>
<parent_field_name>language_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsm_translated_menu_item</child_table_name>
<child_field_name>language_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="49" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61391" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9579.24" record_version_obj="3000044845.09" version_number_seq="4" secondary_key_value="ICFREL_00000046" import_version_number_seq="4"><relationship_obj>9579.24</relationship_obj>
<relationship_reference>ICFREL_00000046</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSCLG</parent_entity>
<child_entity>GSMTI</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>R</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>is the source language of</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>is the source language of</child_verb_phrase>
<model_external_reference>b52a51bd_4d1c6032_72e13396_a9449f5f_0_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051149.09</relationship_field_obj>
<relationship_obj>9579.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsc_language</parent_table_name>
<parent_field_name>language_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsm_translated_menu_item</child_table_name>
<child_field_name>source_language_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="50" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61391" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9581.24" record_version_obj="3000044847.09" version_number_seq="4" secondary_key_value="ICFREL_00000047" import_version_number_seq="4"><relationship_obj>9581.24</relationship_obj>
<relationship_reference>ICFREL_00000047</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSCLG</parent_entity>
<child_entity>GSMMI</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>R</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>is the source language of</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>is the source language of</child_verb_phrase>
<model_external_reference>7c51fe3b_465ce37f_59044489_fa5561ff_0_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051150.09</relationship_field_obj>
<relationship_obj>9581.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsc_language</parent_table_name>
<parent_field_name>language_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsm_menu_item</child_table_name>
<child_field_name>source_language_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="51" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61391" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9583.24" record_version_obj="3000044849.09" version_number_seq="4" secondary_key_value="ICFREL_00000048" import_version_number_seq="4"><relationship_obj>9583.24</relationship_obj>
<relationship_reference>ICFREL_00000048</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSCLG</parent_entity>
<child_entity>GSMTL</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>R</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>is source language of</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>is source language of</child_verb_phrase>
<model_external_reference>9d77bdd6_48eedfb5_849ab39b_da39d13b_0_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051151.09</relationship_field_obj>
<relationship_obj>9583.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsc_language</parent_table_name>
<parent_field_name>language_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsm_translation</child_table_name>
<child_field_name>source_language_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="52" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61391" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9585.24" record_version_obj="3000044851.09" version_number_seq="4" secondary_key_value="ICFREL_00000049" import_version_number_seq="4"><relationship_obj>9585.24</relationship_obj>
<relationship_reference>ICFREL_00000049</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSCLG</parent_entity>
<child_entity>GSMHE</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>yes</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>R</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>S</parent_update_action>
<parent_verb_phrase>has</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>S</child_insert_action>
<child_update_action>S</child_update_action>
<child_verb_phrase>has</child_verb_phrase>
<model_external_reference>d6c59da8_478c54fb_86a31588_b65bb041_33e_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051152.09</relationship_field_obj>
<relationship_obj>9585.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsc_language</parent_table_name>
<parent_field_name>language_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsm_help</child_table_name>
<child_field_name>language_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="53" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61391" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9587.24" record_version_obj="3000044853.09" version_number_seq="4" secondary_key_value="ICFREL_00000050" import_version_number_seq="4"><relationship_obj>9587.24</relationship_obj>
<relationship_reference>ICFREL_00000050</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSCLG</parent_entity>
<child_entity>GSMTL</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>R</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>has</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>has</child_verb_phrase>
<model_external_reference>d1d1b07c_4e71ac2a_9efbdc88_8c25fe8a_308_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051153.09</relationship_field_obj>
<relationship_obj>9587.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsc_language</parent_table_name>
<parent_field_name>language_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsm_translation</child_table_name>
<child_field_name>language_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="54" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61391" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9589.24" record_version_obj="3000044855.09" version_number_seq="4" secondary_key_value="ICFREL_00000051" import_version_number_seq="4"><relationship_obj>9589.24</relationship_obj>
<relationship_reference>ICFREL_00000051</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSCLG</parent_entity>
<child_entity>GSMUS</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>yes</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>R</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>S</parent_update_action>
<parent_verb_phrase></parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>S</child_insert_action>
<child_update_action>S</child_update_action>
<child_verb_phrase></child_verb_phrase>
<model_external_reference>b87b9f53_454be449_f9f251bc_78e4e309_307_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051154.09</relationship_field_obj>
<relationship_obj>9589.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsc_language</parent_table_name>
<parent_field_name>language_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsm_user</child_table_name>
<child_field_name>language_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="55" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61391" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9591.24" record_version_obj="3000044857.09" version_number_seq="4" secondary_key_value="ICFREL_00000052" import_version_number_seq="4"><relationship_obj>9591.24</relationship_obj>
<relationship_reference>ICFREL_00000052</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSCLG</parent_entity>
<child_entity>GSCLT</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>R</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase></parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase></child_verb_phrase>
<model_external_reference>e061c31e_414f3b3c_d6b04187_30c1287c_3a_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051155.09</relationship_field_obj>
<relationship_obj>9591.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsc_language</parent_table_name>
<parent_field_name>language_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsc_language_text</child_table_name>
<child_field_name>language_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="56" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61391" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9593.24" record_version_obj="3000044859.09" version_number_seq="4" secondary_key_value="ICFREL_00000053" import_version_number_seq="4"><relationship_obj>9593.24</relationship_obj>
<relationship_reference>ICFREL_00000053</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSMCA</parent_entity>
<child_entity>GSCLT</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>R</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>of</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>of</child_verb_phrase>
<model_external_reference>bd3036bc_448b6e09_9fdcd39a_ab77e4d3_4e_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051156.09</relationship_field_obj>
<relationship_obj>9593.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsm_category</parent_table_name>
<parent_field_name>category_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsc_language_text</child_table_name>
<child_field_name>category_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="57" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61391" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9595.24" record_version_obj="3000044861.09" version_number_seq="4" secondary_key_value="ICFREL_00000054" import_version_number_seq="4"><relationship_obj>9595.24</relationship_obj>
<relationship_reference>ICFREL_00000054</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSCLS</parent_entity>
<child_entity>GSMSV</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>C</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>abstracts</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>abstracts</child_verb_phrase>
<model_external_reference>9b917d1a_4d8524ae_1e37e8ac_6696d063_37d_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051157.09</relationship_field_obj>
<relationship_obj>9595.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsc_logical_service</parent_table_name>
<parent_field_name>logical_service_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsm_session_service</child_table_name>
<child_field_name>logical_service_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="58" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61391" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9597.24" record_version_obj="3000044863.09" version_number_seq="4" secondary_key_value="ICFREL_00000055" import_version_number_seq="4"><relationship_obj>9597.24</relationship_obj>
<relationship_reference>ICFREL_00000055</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSCLS</parent_entity>
<child_entity>GSCST</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>yes</nulls_allowed>
<cardinality>01</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>R</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>S</parent_update_action>
<parent_verb_phrase>specifies the default for the</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>S</child_insert_action>
<child_update_action>S</child_update_action>
<child_verb_phrase>specifies the default for the</child_verb_phrase>
<model_external_reference>ac31b048_4067f803_bc71e3b6_4ee79354_377_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051158.09</relationship_field_obj>
<relationship_obj>9597.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsc_logical_service</parent_table_name>
<parent_field_name>logical_service_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsc_service_type</child_table_name>
<child_field_name>default_logical_service_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="59" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61391" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9599.24" record_version_obj="3000044865.09" version_number_seq="4" secondary_key_value="ICFREL_00000056" import_version_number_seq="4"><relationship_obj>9599.24</relationship_obj>
<relationship_reference>ICFREL_00000056</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSCLS</parent_entity>
<child_entity>GSMVP</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>C</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>provides partition information to</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>provides partition information to</child_verb_phrase>
<model_external_reference>b43584e1_42ec74ac_dafe23b6_880cb5f6_375_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051159.09</relationship_field_obj>
<relationship_obj>9599.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsc_logical_service</parent_table_name>
<parent_field_name>logical_service_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsm_valid_object_partition</child_table_name>
<child_field_name>logical_service_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="60" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61391" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9601.24" record_version_obj="3000044867.09" version_number_seq="4" secondary_key_value="ICFREL_00000057" import_version_number_seq="4"><relationship_obj>9601.24</relationship_obj>
<relationship_reference>ICFREL_00000057</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSCST</parent_entity>
<child_entity>GSCLS</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>R</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>categorizes</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>categorizes</child_verb_phrase>
<model_external_reference>15baf303_4ced39c9_3fb1c68c_97fd7d7f_376_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051160.09</relationship_field_obj>
<relationship_obj>9601.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsc_service_type</parent_table_name>
<parent_field_name>service_type_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsc_logical_service</child_table_name>
<child_field_name>service_type_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="61" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61391" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9603.24" record_version_obj="3000044869.09" version_number_seq="4" secondary_key_value="ICFREL_00000058" import_version_number_seq="4"><relationship_obj>9603.24</relationship_obj>
<relationship_reference>ICFREL_00000058</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSCMT</parent_entity>
<child_entity>GSMRM</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>R</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>describes</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>describes</child_verb_phrase>
<model_external_reference>2a62a469_4a6937da_81ca26b0_30ebb597_371_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051161.09</relationship_field_obj>
<relationship_obj>9603.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsc_manager_type</parent_table_name>
<parent_field_name>manager_type_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsm_required_manager</child_table_name>
<child_field_name>manager_type_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="62" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61391" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9605.24" record_version_obj="3000044871.09" version_number_seq="4" secondary_key_value="ICFREL_00000059" import_version_number_seq="4"><relationship_obj>9605.24</relationship_obj>
<relationship_reference>ICFREL_00000059</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSCMM</parent_entity>
<child_entity>GSMMM</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>R</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase></parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase></child_verb_phrase>
<model_external_reference>3daee90_4af0fac4_744f6a99_1dc01e1e_35e_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051168.09</relationship_field_obj>
<relationship_obj>9605.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsc_multi_media_type</parent_table_name>
<parent_field_name>multi_media_type_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsm_multi_media</child_table_name>
<child_field_name>multi_media_type_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="63" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61391" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9607.24" record_version_obj="3000044873.09" version_number_seq="4" secondary_key_value="ICFREL_00000060" import_version_number_seq="4"><relationship_obj>9607.24</relationship_obj>
<relationship_reference>ICFREL_00000060</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSCSQ</parent_entity>
<child_entity>GSCSN</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>R</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>has</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>has</child_verb_phrase>
<model_external_reference>f351ece3_4f8da9f2_758f379e_d4122a35_340_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051169.09</relationship_field_obj>
<relationship_obj>9607.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsc_sequence</parent_table_name>
<parent_field_name>sequence_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsc_next_sequence</child_table_name>
<child_field_name>sequence_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="64" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61392" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9609.24" record_version_obj="3000044875.09" version_number_seq="4" secondary_key_value="ICFREL_00000061" import_version_number_seq="4"><relationship_obj>9609.24</relationship_obj>
<relationship_reference>ICFREL_00000061</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSCOT</parent_entity>
<child_entity>GSCOT</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>yes</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>R</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>S</parent_update_action>
<parent_verb_phrase>is extended by</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>S</child_insert_action>
<child_update_action>S</child_update_action>
<child_verb_phrase>is extended by</child_verb_phrase>
<model_external_reference>e88d8e58_4b78bf6c_3c47d499_56ad106b_0_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051170.09</relationship_field_obj>
<relationship_obj>9609.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsc_object_type</parent_table_name>
<parent_field_name>object_type_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsc_object_type</child_table_name>
<child_field_name>extends_object_type_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="65" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61392" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9611.24" record_version_obj="3000044877.09" version_number_seq="4" secondary_key_value="ICFREL_00000062" import_version_number_seq="4"><relationship_obj>9611.24</relationship_obj>
<relationship_reference>ICFREL_00000062</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSCOT</parent_entity>
<child_entity>RYCUE</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>yes</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>C</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>S</parent_update_action>
<parent_verb_phrase>has</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>S</child_insert_action>
<child_update_action>S</child_update_action>
<child_verb_phrase>has</child_verb_phrase>
<model_external_reference>4e55a86d_4f6304fb_79179d93_da6571cc_3bd_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051171.09</relationship_field_obj>
<relationship_obj>9611.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsc_object_type</parent_table_name>
<parent_field_name>object_type_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>ryc_ui_event</child_table_name>
<child_field_name>object_type_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="66" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61392" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9613.24" record_version_obj="3000044879.09" version_number_seq="4" secondary_key_value="ICFREL_00000063" import_version_number_seq="4"><relationship_obj>9613.24</relationship_obj>
<relationship_reference>ICFREL_00000063</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSCOT</parent_entity>
<child_entity>RYCSL</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>R</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>supports</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>supports</child_verb_phrase>
<model_external_reference>703139b7_4bbb6b67_7c30d994_74363d13_3b7_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051172.09</relationship_field_obj>
<relationship_obj>9613.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsc_object_type</parent_table_name>
<parent_field_name>object_type_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>ryc_supported_link</child_table_name>
<child_field_name>object_type_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="67" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61392" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9615.24" record_version_obj="3000044881.09" version_number_seq="4" secondary_key_value="ICFREL_00000064" import_version_number_seq="4"><relationship_obj>9615.24</relationship_obj>
<relationship_reference>ICFREL_00000064</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSCOT</parent_entity>
<child_entity>RYCAV</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>yes</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>C</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>S</parent_update_action>
<parent_verb_phrase>has</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>S</child_insert_action>
<child_update_action>S</child_update_action>
<child_verb_phrase>has</child_verb_phrase>
<model_external_reference>70124048_40e9779a_a9d605ba_306d08c7_3b6_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051173.09</relationship_field_obj>
<relationship_obj>9615.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsc_object_type</parent_table_name>
<parent_field_name>object_type_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>ryc_attribute_value</child_table_name>
<child_field_name>object_type_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="68" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61392" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9617.24" record_version_obj="3000044883.09" version_number_seq="4" secondary_key_value="ICFREL_00000065" import_version_number_seq="4"><relationship_obj>9617.24</relationship_obj>
<relationship_reference>ICFREL_00000065</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSCOT</parent_entity>
<child_entity>RYCSO</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>R</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>defines</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>defines</child_verb_phrase>
<model_external_reference>c33ca748_48e51222_d7b83bba_fa4d61d_3b5_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051174.09</relationship_field_obj>
<relationship_obj>9617.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsc_object_type</parent_table_name>
<parent_field_name>object_type_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>ryc_smartobject</child_table_name>
<child_field_name>object_type_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="69" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61392" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9619.24" record_version_obj="3000044885.09" version_number_seq="4" secondary_key_value="ICFREL_00000066" import_version_number_seq="4"><relationship_obj>9619.24</relationship_obj>
<relationship_reference>ICFREL_00000066</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>RYCSO</parent_entity>
<child_entity>GSCOT</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>yes</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>R</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>is the class procedure for</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>S</child_insert_action>
<child_update_action>S</child_update_action>
<child_verb_phrase>is the class procedure for</child_verb_phrase>
<model_external_reference>679c40c9_44505b71_217b4799_2d223a59_0_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051175.09</relationship_field_obj>
<relationship_obj>9619.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>ryc_smartobject</parent_table_name>
<parent_field_name>smartobject_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsc_object_type</child_table_name>
<child_field_name>class_smartobject_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="70" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61392" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9621.24" record_version_obj="3000044887.09" version_number_seq="4" secondary_key_value="ICFREL_00000067" import_version_number_seq="4"><relationship_obj>9621.24</relationship_obj>
<relationship_reference>ICFREL_00000067</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSCPR</parent_entity>
<child_entity>GSMMS</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>yes</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>S</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>S</parent_update_action>
<parent_verb_phrase></parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>S</child_insert_action>
<child_update_action>S</child_update_action>
<child_verb_phrase></child_verb_phrase>
<model_external_reference>3abccf3a_48a5b1fc_f8cd74a2_93267284_2a9_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051176.09</relationship_field_obj>
<relationship_obj>9621.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsc_product</parent_table_name>
<parent_field_name>product_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsm_menu_structure</child_table_name>
<child_field_name>product_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="71" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61392" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9623.24" record_version_obj="3000044889.09" version_number_seq="4" secondary_key_value="ICFREL_00000068" import_version_number_seq="4"><relationship_obj>9623.24</relationship_obj>
<relationship_reference>ICFREL_00000068</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSCPR</parent_entity>
<child_entity>GSCPM</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>C</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>is made up of</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>is made up of</child_verb_phrase>
<model_external_reference>73c28597_44c2228a_936360bf_23cc1c3d_2a8_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051177.09</relationship_field_obj>
<relationship_obj>9623.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsc_product</parent_table_name>
<parent_field_name>product_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsc_product_module</child_table_name>
<child_field_name>product_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="72" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61392" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9625.24" record_version_obj="3000044891.09" version_number_seq="4" secondary_key_value="ICFREL_00000069" import_version_number_seq="4"><relationship_obj>9625.24</relationship_obj>
<relationship_reference>ICFREL_00000069</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSMLG</parent_entity>
<child_entity>GSCPR</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>yes</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>S</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>S</parent_update_action>
<parent_verb_phrase>supplied</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>S</child_insert_action>
<child_update_action>S</child_update_action>
<child_verb_phrase>supplied</child_verb_phrase>
<model_external_reference>b2330607_4d47c74c_8fb1fa82_da8ebe80_2b3_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051178.09</relationship_field_obj>
<relationship_obj>9625.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsm_login_company</parent_table_name>
<parent_field_name>login_company_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsc_product</child_table_name>
<child_field_name>supplier_organisation_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="73" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61392" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9627.24" record_version_obj="3000044893.09" version_number_seq="4" secondary_key_value="ICFREL_00000070" import_version_number_seq="4"><relationship_obj>9627.24</relationship_obj>
<relationship_reference>ICFREL_00000070</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSCPM</parent_entity>
<child_entity>GSCPM</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>yes</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>R</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>S</parent_update_action>
<parent_verb_phrase>contains</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>S</child_insert_action>
<child_update_action>S</child_update_action>
<child_verb_phrase>contains</child_verb_phrase>
<model_external_reference>4ba7bcd9_4ea25864_c60d9193_7b188782_0_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051179.09</relationship_field_obj>
<relationship_obj>9627.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsc_product_module</parent_table_name>
<parent_field_name>product_module_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsc_product_module</child_table_name>
<child_field_name>parent_product_module_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="74" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61392" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9629.24" record_version_obj="3000044895.09" version_number_seq="4" secondary_key_value="ICFREL_00000071" import_version_number_seq="4"><relationship_obj>9629.24</relationship_obj>
<relationship_reference>ICFREL_00000071</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSCPM</parent_entity>
<child_entity>GSMMI</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>yes</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>R</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>S</parent_update_action>
<parent_verb_phrase>has</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>S</child_insert_action>
<child_update_action>S</child_update_action>
<child_verb_phrase>has</child_verb_phrase>
<model_external_reference>bc2b42d9_4df6a61a_cfe8a84_1c7d4d4e_3c5_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051180.09</relationship_field_obj>
<relationship_obj>9629.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsc_product_module</parent_table_name>
<parent_field_name>product_module_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsm_menu_item</child_table_name>
<child_field_name>product_module_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="75" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61392" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9631.24" record_version_obj="3000044897.09" version_number_seq="4" secondary_key_value="ICFREL_00000072" import_version_number_seq="4"><relationship_obj>9631.24</relationship_obj>
<relationship_reference>ICFREL_00000072</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSCPM</parent_entity>
<child_entity>RYCSO</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>R</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>contains</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>contains</child_verb_phrase>
<model_external_reference>a0653206_4d4c19f6_cddb54b6_397036f_3b8_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051181.09</relationship_field_obj>
<relationship_obj>9631.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsc_product_module</parent_table_name>
<parent_field_name>product_module_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>ryc_smartobject</child_table_name>
<child_field_name>product_module_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="76" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61392" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9633.24" record_version_obj="3000044899.09" version_number_seq="4" secondary_key_value="ICFREL_00000073" import_version_number_seq="4"><relationship_obj>9633.24</relationship_obj>
<relationship_reference>ICFREL_00000073</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSCPM</parent_entity>
<child_entity>GSMFW</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>R</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>contains</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>contains</child_verb_phrase>
<model_external_reference>21cb232e_46b2ccb2_25bfe2a7_34ed8dec_387_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051182.09</relationship_field_obj>
<relationship_obj>9633.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsc_product_module</parent_table_name>
<parent_field_name>product_module_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsm_flow</child_table_name>
<child_field_name>product_module_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="77" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61393" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9635.24" record_version_obj="3000044901.09" version_number_seq="4" secondary_key_value="ICFREL_00000074" import_version_number_seq="4"><relationship_obj>9635.24</relationship_obj>
<relationship_reference>ICFREL_00000074</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSCPM</parent_entity>
<child_entity>GSMMS</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>yes</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>S</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>S</parent_update_action>
<parent_verb_phrase></parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>S</child_insert_action>
<child_update_action>S</child_update_action>
<child_verb_phrase></child_verb_phrase>
<model_external_reference>ce020aee_407c4798_2f2163bb_3520a1e7_2aa_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051183.09</relationship_field_obj>
<relationship_obj>9635.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsc_product_module</parent_table_name>
<parent_field_name>product_module_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsm_menu_structure</child_table_name>
<child_field_name>product_module_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="78" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61393" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9637.24" record_version_obj="3000044903.09" version_number_seq="4" secondary_key_value="ICFREL_00000075" import_version_number_seq="4"><relationship_obj>9637.24</relationship_obj>
<relationship_reference>ICFREL_00000075</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSCPM</parent_entity>
<child_entity>GSMSS</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>yes</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>S</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>S</parent_update_action>
<parent_verb_phrase>uses</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>S</child_insert_action>
<child_update_action>S</child_update_action>
<child_verb_phrase>uses</child_verb_phrase>
<model_external_reference>c1949a4e_449da0c3_134323b7_bac28efa_2a7_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051184.09</relationship_field_obj>
<relationship_obj>9637.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsc_product_module</parent_table_name>
<parent_field_name>product_module_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsm_security_structure</child_table_name>
<child_field_name>product_module_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="79" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61393" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9639.24" record_version_obj="3000044905.09" version_number_seq="6" secondary_key_value="ICFREL_00000076" import_version_number_seq="6"><relationship_obj>9639.24</relationship_obj>
<relationship_reference>ICFREL_00000076</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSCPC</parent_entity>
<child_entity>GSMPF</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>R</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>is used by</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>is used by</child_verb_phrase>
<model_external_reference>5419d8ed_4843c58b_1d9e149b_e7d715c0_358_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051185.09</relationship_field_obj>
<relationship_obj>9639.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsc_profile_code</parent_table_name>
<parent_field_name>profile_type_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsm_profile_data</child_table_name>
<child_field_name>profile_type_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051186.09</relationship_field_obj>
<relationship_obj>9639.24</relationship_obj>
<join_sequence>2</join_sequence>
<parent_table_name>gsc_profile_code</parent_table_name>
<parent_field_name>profile_code_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsm_profile_data</child_table_name>
<child_field_name>profile_code_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="80" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61393" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9642.24" record_version_obj="3000044908.09" version_number_seq="4" secondary_key_value="ICFREL_00000077" import_version_number_seq="4"><relationship_obj>9642.24</relationship_obj>
<relationship_reference>ICFREL_00000077</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSCPF</parent_entity>
<child_entity>GSCPC</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>C</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>consists of</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>consists of</child_verb_phrase>
<model_external_reference>4526afe9_4c942e5e_d3fd749f_87ea5d21_357_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051187.09</relationship_field_obj>
<relationship_obj>9642.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsc_profile_type</parent_table_name>
<parent_field_name>profile_type_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsc_profile_code</child_table_name>
<child_field_name>profile_type_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="81" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61393" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9644.24" record_version_obj="3000044910.09" version_number_seq="4" secondary_key_value="ICFREL_00000078" import_version_number_seq="4"><relationship_obj>9644.24</relationship_obj>
<relationship_reference>ICFREL_00000078</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSMLG</parent_entity>
<child_entity>GSCSQ</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>yes</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>C</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>S</parent_update_action>
<parent_verb_phrase></parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>S</child_insert_action>
<child_update_action>S</child_update_action>
<child_verb_phrase></child_verb_phrase>
<model_external_reference>3314b86_408a3894_91863bbd_cc72694e_322_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051194.09</relationship_field_obj>
<relationship_obj>9644.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsm_login_company</parent_table_name>
<parent_field_name>login_company_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsc_sequence</child_table_name>
<child_field_name>company_organisation_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="82" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61393" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9646.24" record_version_obj="3000044912.09" version_number_seq="4" secondary_key_value="ICFREL_00000079" import_version_number_seq="4"><relationship_obj>9646.24</relationship_obj>
<relationship_reference>ICFREL_00000079</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSCST</parent_entity>
<child_entity>GSMPY</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>R</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>provides management data to</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>provides management data to</child_verb_phrase>
<model_external_reference>b760d5ee_44237432_76b16c84_77bfb08c_37a_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051195.09</relationship_field_obj>
<relationship_obj>9646.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsc_service_type</parent_table_name>
<parent_field_name>service_type_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsm_physical_service</child_table_name>
<child_field_name>service_type_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="83" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61393" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9648.24" record_version_obj="3000044914.09" version_number_seq="4" secondary_key_value="ICFREL_00000080" import_version_number_seq="4"><relationship_obj>9648.24</relationship_obj>
<relationship_reference>ICFREL_00000080</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>RYCSO</parent_entity>
<child_entity>GSCST</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>R</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>is the management object for</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>is the management object for</child_verb_phrase>
<model_external_reference>81392be3_42391c8c_e62a0392_883f7200_0_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051196.09</relationship_field_obj>
<relationship_obj>9648.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>ryc_smartobject</parent_table_name>
<parent_field_name>smartobject_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsc_service_type</child_table_name>
<child_field_name>management_object_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="84" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61393" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9650.24" record_version_obj="3000044916.09" version_number_seq="4" secondary_key_value="ICFREL_00000081" import_version_number_seq="4"><relationship_obj>9650.24</relationship_obj>
<relationship_reference>ICFREL_00000081</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>RYCSO</parent_entity>
<child_entity>GSCST</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>R</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>maintains</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>maintains</child_verb_phrase>
<model_external_reference>28a68ddc_4a62d0f1_7e329fb2_5526c9bd_0_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051197.09</relationship_field_obj>
<relationship_obj>9650.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>ryc_smartobject</parent_table_name>
<parent_field_name>smartobject_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsc_service_type</child_table_name>
<child_field_name>maintenance_object_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="85" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61393" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9652.24" record_version_obj="3000044918.09" version_number_seq="4" secondary_key_value="ICFREL_00000082" import_version_number_seq="4"><relationship_obj>9652.24</relationship_obj>
<relationship_reference>ICFREL_00000082</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSCSP</parent_entity>
<child_entity>GSMSY</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>C</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>has session specific values defined by</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>has session specific values defined by</child_verb_phrase>
<model_external_reference>81634ff0_4733fba5_b879779b_bb273941_388_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051198.09</relationship_field_obj>
<relationship_obj>9652.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsc_session_property</parent_table_name>
<parent_field_name>session_property_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsm_session_type_property</child_table_name>
<child_field_name>session_property_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="86" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61393" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9654.24" record_version_obj="3000044920.09" version_number_seq="4" secondary_key_value="ICFREL_00000083" import_version_number_seq="4"><relationship_obj>9654.24</relationship_obj>
<relationship_reference>ICFREL_00000083</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSMCA</parent_entity>
<child_entity>GSMCL</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>R</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>of</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>of</child_verb_phrase>
<model_external_reference>aaa467df_46ea3571_81b57aa6_51a5c184_326_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051199.09</relationship_field_obj>
<relationship_obj>9654.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsm_category</parent_table_name>
<parent_field_name>category_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsm_control_code</child_table_name>
<child_field_name>category_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="87" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61393" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9656.24" record_version_obj="3000044922.09" version_number_seq="4" secondary_key_value="ICFREL_00000084" import_version_number_seq="4"><relationship_obj>9656.24</relationship_obj>
<relationship_reference>ICFREL_00000084</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSMCA</parent_entity>
<child_entity>GSMPR</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>N</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>N</parent_update_action>
<parent_verb_phrase>of</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>of</child_verb_phrase>
<model_external_reference>a550a0b4_4ada24dc_3baa30b8_ef4573eb_4f_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051200.09</relationship_field_obj>
<relationship_obj>9656.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsm_category</parent_table_name>
<parent_field_name>category_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsm_profile</child_table_name>
<child_field_name>category_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="88" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61393" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9658.24" record_version_obj="3000044924.09" version_number_seq="4" secondary_key_value="ICFREL_00000085" import_version_number_seq="4"><relationship_obj>9658.24</relationship_obj>
<relationship_reference>ICFREL_00000085</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSMCA</parent_entity>
<child_entity>GSMST</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>R</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>of</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>of</child_verb_phrase>
<model_external_reference>af3510d0_4ccf04bb_f3cf3788_e779775c_4b_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051201.09</relationship_field_obj>
<relationship_obj>9658.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsm_category</parent_table_name>
<parent_field_name>category_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsm_status</child_table_name>
<child_field_name>category_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="89" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61393" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9660.24" record_version_obj="3000044926.09" version_number_seq="4" secondary_key_value="ICFREL_00000086" import_version_number_seq="4"><relationship_obj>9660.24</relationship_obj>
<relationship_reference>ICFREL_00000086</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSMCA</parent_entity>
<child_entity>GSMMM</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>R</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>of</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>of</child_verb_phrase>
<model_external_reference>af0c33d3_42e8e875_4b439aba_1b2c731e_3d_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051202.09</relationship_field_obj>
<relationship_obj>9660.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsm_category</parent_table_name>
<parent_field_name>category_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsm_multi_media</child_table_name>
<child_field_name>category_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="90" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61393" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9662.24" record_version_obj="3000044928.09" version_number_seq="4" secondary_key_value="ICFREL_00000087" import_version_number_seq="4"><relationship_obj>9662.24</relationship_obj>
<relationship_reference>ICFREL_00000087</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSMCA</parent_entity>
<child_entity>GSMCM</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>R</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>of</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>of</child_verb_phrase>
<model_external_reference>a179e7be_42c5a638_2cbdbcb9_77a8666a_3c_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051203.09</relationship_field_obj>
<relationship_obj>9662.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsm_category</parent_table_name>
<parent_field_name>category_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsm_comment</child_table_name>
<child_field_name>category_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="91" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61393" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9664.24" record_version_obj="3000044930.09" version_number_seq="6" secondary_key_value="ICFREL_00000088" import_version_number_seq="6"><relationship_obj>9664.24</relationship_obj>
<relationship_reference>ICFREL_00000088</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSMRF</parent_entity>
<child_entity>GSMDR</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>C</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>is the default for</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>is the default for</child_verb_phrase>
<model_external_reference>de15a409_4b5f28f3_2a7c30a8_f687e504_31c_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051204.09</relationship_field_obj>
<relationship_obj>9664.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsm_report_format</parent_table_name>
<parent_field_name>report_definition_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsm_default_report_format</child_table_name>
<child_field_name>report_definition_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051205.09</relationship_field_obj>
<relationship_obj>9664.24</relationship_obj>
<join_sequence>2</join_sequence>
<parent_table_name>gsm_report_format</parent_table_name>
<parent_field_name>report_format_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsm_default_report_format</child_table_name>
<child_field_name>report_format_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="92" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61393" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9667.24" record_version_obj="3000044933.09" version_number_seq="4" secondary_key_value="ICFREL_00000089" import_version_number_seq="4"><relationship_obj>9667.24</relationship_obj>
<relationship_reference>ICFREL_00000089</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSMEF</parent_entity>
<child_entity>GSMEV</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>C</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>has</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>has</child_verb_phrase>
<model_external_reference>98ac331e_4cf13b55_10be1eb4_9da80409_29f_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051206.09</relationship_field_obj>
<relationship_obj>9667.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsm_entity_field</parent_table_name>
<parent_field_name>entity_field_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsm_entity_field_value</child_table_name>
<child_field_name>entity_field_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="93" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61393" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9669.24" record_version_obj="3000044935.09" version_number_seq="4" secondary_key_value="ICFREL_00000090" import_version_number_seq="4"><relationship_obj>9669.24</relationship_obj>
<relationship_reference>ICFREL_00000090</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSMFW</parent_entity>
<child_entity>GSMFS</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>yes</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>R</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>N</parent_update_action>
<parent_verb_phrase>is run during</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>S</child_insert_action>
<child_update_action>S</child_update_action>
<child_verb_phrase>is run during</child_verb_phrase>
<model_external_reference>7654fc56_4c2307a4_c7a9cdbc_bff79a5f_374_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051210.09</relationship_field_obj>
<relationship_obj>9669.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsm_flow</parent_table_name>
<parent_field_name>flow_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsm_flow_step</child_table_name>
<child_field_name>flow_step_flow_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="94" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61393" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9671.24" record_version_obj="3000044937.09" version_number_seq="4" secondary_key_value="ICFREL_00000091" import_version_number_seq="4"><relationship_obj>9671.24</relationship_obj>
<relationship_reference>ICFREL_00000091</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSMFW</parent_entity>
<child_entity>GSMSF</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>R</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>is used as</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>is used as</child_verb_phrase>
<model_external_reference>75d66dae_49a197a1_c8f283be_4dc9e5f8_373_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051211.09</relationship_field_obj>
<relationship_obj>9671.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsm_flow</parent_table_name>
<parent_field_name>flow_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsm_startup_flow</child_table_name>
<child_field_name>flow_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="95" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61393" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9673.24" record_version_obj="3000044939.09" version_number_seq="4" secondary_key_value="ICFREL_00000092" import_version_number_seq="4"><relationship_obj>9673.24</relationship_obj>
<relationship_reference>ICFREL_00000092</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSMFW</parent_entity>
<child_entity>GSMFS</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>C</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>consists of</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>consists of</child_verb_phrase>
<model_external_reference>eba17dea_4a903ec2_10b79c9c_52744a63_372_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051212.09</relationship_field_obj>
<relationship_obj>9673.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsm_flow</parent_table_name>
<parent_field_name>flow_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsm_flow_step</child_table_name>
<child_field_name>flow_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="96" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61393" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9675.24" record_version_obj="3000044941.09" version_number_seq="4" secondary_key_value="ICFREL_00000093" import_version_number_seq="4"><relationship_obj>9675.24</relationship_obj>
<relationship_reference>ICFREL_00000093</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>RYCSO</parent_entity>
<child_entity>GSMFS</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>yes</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>R</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>is run during</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>S</child_insert_action>
<child_update_action>S</child_update_action>
<child_verb_phrase>is run during</child_verb_phrase>
<model_external_reference>d4f7495d_4afdf725_f8821382_77be5880_0_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051213.09</relationship_field_obj>
<relationship_obj>9675.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>ryc_smartobject</parent_table_name>
<parent_field_name>smartobject_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsm_flow_step</child_table_name>
<child_field_name>object_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="97" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61393" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9677.24" record_version_obj="3000044943.09" version_number_seq="4" secondary_key_value="ICFREL_00000094" import_version_number_seq="4"><relationship_obj>9677.24</relationship_obj>
<relationship_reference>ICFREL_00000094</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSMLG</parent_entity>
<child_entity>GSMFS</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>yes</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>S</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>S</parent_update_action>
<parent_verb_phrase>requires a specialised</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>S</child_insert_action>
<child_update_action>S</child_update_action>
<child_verb_phrase>requires a specialised</child_verb_phrase>
<model_external_reference>9dbb282c_45063d63_105fa09d_1dcddc8c_385_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051214.09</relationship_field_obj>
<relationship_obj>9677.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsm_login_company</parent_table_name>
<parent_field_name>login_company_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsm_flow_step</child_table_name>
<child_field_name>login_company_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="98" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61394" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9679.24" record_version_obj="3000044945.09" version_number_seq="4" secondary_key_value="ICFREL_00000095" import_version_number_seq="4"><relationship_obj>9679.24</relationship_obj>
<relationship_reference>ICFREL_00000095</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSMLG</parent_entity>
<child_entity>GSMUS</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>yes</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>S</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>S</parent_update_action>
<parent_verb_phrase>is the default login company for</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>S</child_insert_action>
<child_update_action>S</child_update_action>
<child_verb_phrase>is the default login company for</child_verb_phrase>
<model_external_reference>8d36e70a_471475fc_4cc806b7_8512e06_316_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051224.09</relationship_field_obj>
<relationship_obj>9679.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsm_login_company</parent_table_name>
<parent_field_name>login_company_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsm_user</child_table_name>
<child_field_name>default_login_company_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="99" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61394" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9681.24" record_version_obj="3000044947.09" version_number_seq="4" secondary_key_value="ICFREL_00000096" import_version_number_seq="4"><relationship_obj>9681.24</relationship_obj>
<relationship_reference>ICFREL_00000096</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSMLG</parent_entity>
<child_entity>GSMUL</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>yes</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>C</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>S</parent_update_action>
<parent_verb_phrase>affects this</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>S</child_insert_action>
<child_update_action>S</child_update_action>
<child_verb_phrase>affects this</child_verb_phrase>
<model_external_reference>179d7814_4aba344c_721cc595_e57ffe04_300_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051225.09</relationship_field_obj>
<relationship_obj>9681.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsm_login_company</parent_table_name>
<parent_field_name>login_company_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsm_user_allocation</child_table_name>
<child_field_name>login_organisation_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="100" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61394" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9683.24" record_version_obj="3000044949.09" version_number_seq="4" secondary_key_value="ICFREL_00000097" import_version_number_seq="4"><relationship_obj>9683.24</relationship_obj>
<relationship_reference>ICFREL_00000097</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSMMI</parent_entity>
<child_entity>GSMTI</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>C</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>is translated as</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>is translated as</child_verb_phrase>
<model_external_reference>3c178634_4f162eef_c9ad23a2_8001960d_0_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051226.09</relationship_field_obj>
<relationship_obj>9683.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsm_menu_item</parent_table_name>
<parent_field_name>menu_item_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsm_translated_menu_item</child_table_name>
<child_field_name>menu_item_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="101" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61394" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9685.24" record_version_obj="3000044951.09" version_number_seq="4" secondary_key_value="ICFREL_00000098" import_version_number_seq="4"><relationship_obj>9685.24</relationship_obj>
<relationship_reference>ICFREL_00000098</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSMMI</parent_entity>
<child_entity>GSMOM</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>yes</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>R</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>S</parent_update_action>
<parent_verb_phrase>may contain</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>S</child_insert_action>
<child_update_action>S</child_update_action>
<child_verb_phrase>may contain</child_verb_phrase>
<model_external_reference>c30fb3e8_4c8aa710_6f9e0195_80a7f46c_3ca_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051227.09</relationship_field_obj>
<relationship_obj>9685.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsm_menu_item</parent_table_name>
<parent_field_name>menu_item_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsm_object_menu_structure</child_table_name>
<child_field_name>menu_item_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="102" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61394" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9687.24" record_version_obj="3000044953.09" version_number_seq="4" secondary_key_value="ICFREL_00000099" import_version_number_seq="4"><relationship_obj>9687.24</relationship_obj>
<relationship_reference>ICFREL_00000099</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSMMI</parent_entity>
<child_entity>GSMMS</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>yes</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>R</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>S</parent_update_action>
<parent_verb_phrase>default label</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>S</child_insert_action>
<child_update_action>S</child_update_action>
<child_verb_phrase>default label</child_verb_phrase>
<model_external_reference>2b5f96c6_41a2b5c6_e59462b6_ef7d30d3_3c9_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051228.09</relationship_field_obj>
<relationship_obj>9687.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsm_menu_item</parent_table_name>
<parent_field_name>menu_item_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsm_menu_structure</child_table_name>
<child_field_name>menu_item_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="103" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61394" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9689.24" record_version_obj="3000044955.09" version_number_seq="4" secondary_key_value="ICFREL_00000100" import_version_number_seq="4"><relationship_obj>9689.24</relationship_obj>
<relationship_reference>ICFREL_00000100</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSMMI</parent_entity>
<child_entity>GSMIT</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>yes</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>R</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>S</parent_update_action>
<parent_verb_phrase>may contain</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>S</child_insert_action>
<child_update_action>S</child_update_action>
<child_verb_phrase>may contain</child_verb_phrase>
<model_external_reference>b8b9f17e_4b0f5f63_820512b4_4bcc9079_3c8_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051229.09</relationship_field_obj>
<relationship_obj>9689.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsm_menu_item</parent_table_name>
<parent_field_name>menu_item_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsm_menu_structure_item</child_table_name>
<child_field_name>menu_item_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="104" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61394" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9691.24" record_version_obj="3000044957.09" version_number_seq="4" secondary_key_value="ICFREL_00000101" import_version_number_seq="4"><relationship_obj>9691.24</relationship_obj>
<relationship_reference>ICFREL_00000101</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>RYCSO</parent_entity>
<child_entity>GSMMI</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>yes</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>C</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>appears on</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>S</child_insert_action>
<child_update_action>S</child_update_action>
<child_verb_phrase>appears on</child_verb_phrase>
<model_external_reference>8b855c6e_4143dfb4_4ccc1ba1_e5030434_0_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051230.09</relationship_field_obj>
<relationship_obj>9691.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>ryc_smartobject</parent_table_name>
<parent_field_name>smartobject_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsm_menu_item</child_table_name>
<child_field_name>object_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="105" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61394" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9693.24" record_version_obj="3000044959.09" version_number_seq="4" secondary_key_value="ICFREL_00000102" import_version_number_seq="4"><relationship_obj>9693.24</relationship_obj>
<relationship_reference>ICFREL_00000102</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSMMS</parent_entity>
<child_entity>GSMTM</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>R</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>is used by</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>is used by</child_verb_phrase>
<model_external_reference>cae18d10_42a855c8_6afc46a3_8d2fb68c_3cc_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051231.09</relationship_field_obj>
<relationship_obj>9693.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsm_menu_structure</parent_table_name>
<parent_field_name>menu_structure_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsm_toolbar_menu_structure</child_table_name>
<child_field_name>menu_structure_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="106" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61394" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9695.24" record_version_obj="3000044961.09" version_number_seq="4" secondary_key_value="ICFREL_00000103" import_version_number_seq="4"><relationship_obj>9695.24</relationship_obj>
<relationship_reference>ICFREL_00000103</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSMMS</parent_entity>
<child_entity>GSMIT</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>yes</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>R</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>S</parent_update_action>
<parent_verb_phrase>is the child of</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>S</child_insert_action>
<child_update_action>S</child_update_action>
<child_verb_phrase>is the child of</child_verb_phrase>
<model_external_reference>5565e6ab_45dc44bf_40b3929f_ec1b0889_3c7_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051232.09</relationship_field_obj>
<relationship_obj>9695.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsm_menu_structure</parent_table_name>
<parent_field_name>menu_structure_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsm_menu_structure_item</child_table_name>
<child_field_name>child_menu_structure_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="107" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61394" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9697.24" record_version_obj="3000044963.09" version_number_seq="4" secondary_key_value="ICFREL_00000104" import_version_number_seq="4"><relationship_obj>9697.24</relationship_obj>
<relationship_reference>ICFREL_00000104</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSMMS</parent_entity>
<child_entity>GSMIT</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>C</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>contains</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>contains</child_verb_phrase>
<model_external_reference>7fcfd32b_4a0800c2_f019f986_18f432c7_3c6_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051233.09</relationship_field_obj>
<relationship_obj>9697.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsm_menu_structure</parent_table_name>
<parent_field_name>menu_structure_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsm_menu_structure_item</child_table_name>
<child_field_name>menu_structure_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="108" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61394" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9699.24" record_version_obj="3000044965.09" version_number_seq="4" secondary_key_value="ICFREL_00000105" import_version_number_seq="4"><relationship_obj>9699.24</relationship_obj>
<relationship_reference>ICFREL_00000105</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSMMS</parent_entity>
<child_entity>GSMOM</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>C</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>is used by</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>is used by</child_verb_phrase>
<model_external_reference>f1c0101b_46585279_d5fd9bb0_238d31e9_2f8_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051234.09</relationship_field_obj>
<relationship_obj>9699.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsm_menu_structure</parent_table_name>
<parent_field_name>menu_structure_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsm_object_menu_structure</child_table_name>
<child_field_name>menu_structure_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="109" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61394" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9701.24" record_version_obj="3000044967.09" version_number_seq="4" secondary_key_value="ICFREL_00000106" import_version_number_seq="4"><relationship_obj>9701.24</relationship_obj>
<relationship_reference>ICFREL_00000106</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSMND</parent_entity>
<child_entity>GSMND</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>yes</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>S</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>S</parent_update_action>
<parent_verb_phrase>is the parent of</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>S</child_insert_action>
<child_update_action>S</child_update_action>
<child_verb_phrase>is the parent of</child_verb_phrase>
<model_external_reference>bc0dcbcb_4e8e767f_14d2b6b1_4279a267_3c2_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051235.09</relationship_field_obj>
<relationship_obj>9701.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsm_node</parent_table_name>
<parent_field_name>node_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsm_node</child_table_name>
<child_field_name>parent_node_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="110" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61394" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9703.24" record_version_obj="3000044969.09" version_number_seq="4" secondary_key_value="ICFREL_00000107" import_version_number_seq="4"><relationship_obj>9703.24</relationship_obj>
<relationship_reference>ICFREL_00000107</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>RYCSO</parent_entity>
<child_entity>GSMOM</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>C</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>uses these dynamic</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>uses these dynamic</child_verb_phrase>
<model_external_reference>2accb670_4a5e64e1_2e52e18a_677b3cb1_0_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051236.09</relationship_field_obj>
<relationship_obj>9703.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>ryc_smartobject</parent_table_name>
<parent_field_name>smartobject_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsm_object_menu_structure</child_table_name>
<child_field_name>object_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="111" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61394" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9705.24" record_version_obj="3000044971.09" version_number_seq="4" secondary_key_value="ICFREL_00000108" import_version_number_seq="4"><relationship_obj>9705.24</relationship_obj>
<relationship_reference>ICFREL_00000108</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSMPY</parent_entity>
<child_entity>GSMSV</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>R</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>provides connection parameters to</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>provides connection parameters to</child_verb_phrase>
<model_external_reference>52db5337_4f088d18_6390f4b3_e1e27d13_37c_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051237.09</relationship_field_obj>
<relationship_obj>9705.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsm_physical_service</parent_table_name>
<parent_field_name>physical_service_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsm_session_service</child_table_name>
<child_field_name>physical_service_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="112" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61394" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9707.24" record_version_obj="3000044973.09" version_number_seq="4" secondary_key_value="ICFREL_00000109" import_version_number_seq="4"><relationship_obj>9707.24</relationship_obj>
<relationship_reference>ICFREL_00000109</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSMPR</parent_entity>
<child_entity>GSMPD</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>C</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase></parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase></child_verb_phrase>
<model_external_reference>45ca1873_4dc0b9dc_abe0869a_8b834a3a_55_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051238.09</relationship_field_obj>
<relationship_obj>9707.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsm_profile</parent_table_name>
<parent_field_name>profile_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsm_profile_date_value</child_table_name>
<child_field_name>profile_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="113" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61394" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9709.24" record_version_obj="3000044975.09" version_number_seq="4" secondary_key_value="ICFREL_00000110" import_version_number_seq="4"><relationship_obj>9709.24</relationship_obj>
<relationship_reference>ICFREL_00000110</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSMPR</parent_entity>
<child_entity>GSMNV</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>C</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase></parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase></child_verb_phrase>
<model_external_reference>c159e0c8_40b2c40d_634ae998_c3c911bd_54_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051239.09</relationship_field_obj>
<relationship_obj>9709.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsm_profile</parent_table_name>
<parent_field_name>profile_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsm_profile_numeric_value</child_table_name>
<child_field_name>profile_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="114" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61394" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9711.24" record_version_obj="3000044977.09" version_number_seq="4" secondary_key_value="ICFREL_00000111" import_version_number_seq="4"><relationship_obj>9711.24</relationship_obj>
<relationship_reference>ICFREL_00000111</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSMPR</parent_entity>
<child_entity>GSMAV</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>C</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase></parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase></child_verb_phrase>
<model_external_reference>5d96720f_4d7fcedf_6039ccba_9da132bf_53_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051240.09</relationship_field_obj>
<relationship_obj>9711.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsm_profile</parent_table_name>
<parent_field_name>profile_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsm_profile_alpha_value</child_table_name>
<child_field_name>profile_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="115" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61394" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9713.24" record_version_obj="3000044979.09" version_number_seq="4" secondary_key_value="ICFREL_00000112" import_version_number_seq="4"><relationship_obj>9713.24</relationship_obj>
<relationship_reference>ICFREL_00000112</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSMPR</parent_entity>
<child_entity>GSMPN</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>C</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase></parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase></child_verb_phrase>
<model_external_reference>ee503669_45254b2a_f67c1ab8_b5d0b95b_52_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051241.09</relationship_field_obj>
<relationship_obj>9713.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsm_profile</parent_table_name>
<parent_field_name>profile_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsm_profile_numeric_options</child_table_name>
<child_field_name>profile_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="116" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61394" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9715.24" record_version_obj="3000044981.09" version_number_seq="4" secondary_key_value="ICFREL_00000113" import_version_number_seq="4"><relationship_obj>9715.24</relationship_obj>
<relationship_reference>ICFREL_00000113</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSMPR</parent_entity>
<child_entity>GSMPA</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>C</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase></parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase></child_verb_phrase>
<model_external_reference>485baf0f_48445ebe_92534980_d6740dd5_51_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051242.09</relationship_field_obj>
<relationship_obj>9715.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsm_profile</parent_table_name>
<parent_field_name>profile_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsm_profile_alpha_options</child_table_name>
<child_field_name>profile_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="117" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61394" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9717.24" record_version_obj="3000044983.09" version_number_seq="4" secondary_key_value="ICFREL_00000114" import_version_number_seq="4"><relationship_obj>9717.24</relationship_obj>
<relationship_reference>ICFREL_00000114</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSMPR</parent_entity>
<child_entity>GSMPH</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>R</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase></parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase></child_verb_phrase>
<model_external_reference>f9aa7cf7_4900ea7d_4f8adbae_a7459900_50_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051243.09</relationship_field_obj>
<relationship_obj>9717.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsm_profile</parent_table_name>
<parent_field_name>profile_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsm_profile_history</child_table_name>
<child_field_name>profile_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="118" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61394" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9719.24" record_version_obj="3000044985.09" version_number_seq="4" secondary_key_value="ICFREL_00000115" import_version_number_seq="4"><relationship_obj>9719.24</relationship_obj>
<relationship_reference>ICFREL_00000115</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSMUS</parent_entity>
<child_entity>GSMPF</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>C</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>has</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>has</child_verb_phrase>
<model_external_reference>c7276cf7_469b37e6_3ef59797_a0760bb1_356_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051244.09</relationship_field_obj>
<relationship_obj>9719.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsm_user</parent_table_name>
<parent_field_name>user_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsm_profile_data</child_table_name>
<child_field_name>user_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="119" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61394" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9721.24" record_version_obj="3000044987.09" version_number_seq="4" secondary_key_value="ICFREL_00000116" import_version_number_seq="4"><relationship_obj>9721.24</relationship_obj>
<relationship_reference>ICFREL_00000116</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSMRD</parent_entity>
<child_entity>GSMRF</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>R</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>can be processed by</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>can be processed by</child_verb_phrase>
<model_external_reference>5c44c911_4749b838_d2589f89_e5f3f924_370_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051248.09</relationship_field_obj>
<relationship_obj>9721.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsm_report_definition</parent_table_name>
<parent_field_name>report_definition_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsm_report_format</child_table_name>
<child_field_name>report_definition_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="120" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61394" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9723.24" record_version_obj="3000044989.09" version_number_seq="4" secondary_key_value="ICFREL_00000117" import_version_number_seq="4"><relationship_obj>9723.24</relationship_obj>
<relationship_reference>ICFREL_00000117</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSMRD</parent_entity>
<child_entity>GSTEL</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>N</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>N</parent_update_action>
<parent_verb_phrase>has</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>has</child_verb_phrase>
<model_external_reference>78f30b85_4abb352f_84cc4ab0_ee3fd86d_2b8_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051249.09</relationship_field_obj>
<relationship_obj>9723.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsm_report_definition</parent_table_name>
<parent_field_name>report_definition_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gst_extract_log</child_table_name>
<child_field_name>report_definition_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="121" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61394" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9725.24" record_version_obj="3000044991.09" version_number_seq="4" secondary_key_value="ICFREL_00000118" import_version_number_seq="4"><relationship_obj>9725.24</relationship_obj>
<relationship_reference>ICFREL_00000118</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSMRE</parent_entity>
<child_entity>GSMRF</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>C</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase></parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase></child_verb_phrase>
<model_external_reference>c6aacd9b_4f2bf49d_fde45b2_dcc14c80_2c2_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051250.09</relationship_field_obj>
<relationship_obj>9725.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsm_reporting_tool</parent_table_name>
<parent_field_name>reporting_tool_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsm_report_format</child_table_name>
<child_field_name>reporting_tool_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="122" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="03/24/2003" version_time="51398" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9727.24" record_version_obj="3000044993.09" version_number_seq="1.09" secondary_key_value="ICFREL_00000119" import_version_number_seq="1.09"><relationship_obj>9727.24</relationship_obj>
<relationship_reference>ICFREL_00000119</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>RYCSO</parent_entity>
<child_entity>GSMRM</child_entity>
<primary_relationship>no</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>no</update_parent_allowed>
<parent_delete_action>R</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>is the procedure object for</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>is the procedure object for</child_verb_phrase>
<model_external_reference>d62d5dc7_4b45d106_80b4f98f_ca4c3c6e_0_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000044992.09</relationship_field_obj>
<relationship_obj>9727.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>ryc_smartobject</parent_table_name>
<parent_field_name>smartobject_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsm_required_manager</child_table_name>
<child_field_name>object_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="123" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61395" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9729.24" record_version_obj="3000044995.09" version_number_seq="4" secondary_key_value="ICFREL_00000120" import_version_number_seq="4"><relationship_obj>9729.24</relationship_obj>
<relationship_reference>ICFREL_00000120</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSMSE</parent_entity>
<child_entity>GSMRM</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>C</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>is responsible for starting</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>is responsible for starting</child_verb_phrase>
<model_external_reference>6b5870fe_42b62003_86786a8_d5d7ad04_379_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051251.09</relationship_field_obj>
<relationship_obj>9729.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsm_session_type</parent_table_name>
<parent_field_name>session_type_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsm_required_manager</child_table_name>
<child_field_name>session_type_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="124" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61395" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9731.24" record_version_obj="3000044997.09" version_number_seq="4" secondary_key_value="ICFREL_00000121" import_version_number_seq="4"><relationship_obj>9731.24</relationship_obj>
<relationship_reference>ICFREL_00000121</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>RYCSO</parent_entity>
<child_entity>GSMSS</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>yes</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>S</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>S</parent_update_action>
<parent_verb_phrase>uses</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>S</child_insert_action>
<child_update_action>S</child_update_action>
<child_verb_phrase>uses</child_verb_phrase>
<model_external_reference>88d7b76f_4cf78755_38211ca8_e7d3264b_0_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051252.09</relationship_field_obj>
<relationship_obj>9731.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>ryc_smartobject</parent_table_name>
<parent_field_name>smartobject_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsm_security_structure</child_table_name>
<child_field_name>object_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="125" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="03/24/2003" version_time="51398" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9733.24" record_version_obj="3000044999.09" version_number_seq="1.09" secondary_key_value="ICFREL_00000122" import_version_number_seq="1.09"><relationship_obj>9733.24</relationship_obj>
<relationship_reference>ICFREL_00000122</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSTSS</parent_entity>
<child_entity>GSMSC</child_entity>
<primary_relationship>no</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>no</update_parent_allowed>
<parent_delete_action>C</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>has</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>has</child_verb_phrase>
<model_external_reference>e342a554_4cf84795_78f27c8d_a65b9fbd_0_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000044998.09</relationship_field_obj>
<relationship_obj>9733.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gst_session</parent_table_name>
<parent_field_name>session_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsm_server_context</child_table_name>
<child_field_name>session_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="126" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61395" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9735.24" record_version_obj="3000045001.09" version_number_seq="4" secondary_key_value="ICFREL_00000123" import_version_number_seq="4"><relationship_obj>9735.24</relationship_obj>
<relationship_reference>ICFREL_00000123</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSMSE</parent_entity>
<child_entity>GSMSV</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>C</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>has access to</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>has access to</child_verb_phrase>
<model_external_reference>2a29ce8b_4928896c_5dfa4b82_e1be27f6_37b_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051256.09</relationship_field_obj>
<relationship_obj>9735.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsm_session_type</parent_table_name>
<parent_field_name>session_type_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsm_session_service</child_table_name>
<child_field_name>session_type_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="127" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61395" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9737.24" record_version_obj="3000045003.09" version_number_seq="4" secondary_key_value="ICFREL_00000124" import_version_number_seq="4"><relationship_obj>9737.24</relationship_obj>
<relationship_reference>ICFREL_00000124</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSMSE</parent_entity>
<child_entity>GSTSS</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>yes</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>S</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>S</parent_update_action>
<parent_verb_phrase></parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>S</child_insert_action>
<child_update_action>S</child_update_action>
<child_verb_phrase></child_verb_phrase>
<model_external_reference>d632b797_43378c49_fba5a5ba_e5b7ed63_0_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051257.09</relationship_field_obj>
<relationship_obj>9737.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsm_session_type</parent_table_name>
<parent_field_name>session_type_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gst_session</child_table_name>
<child_field_name>session_type_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="128" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61395" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9739.24" record_version_obj="3000045005.09" version_number_seq="4" secondary_key_value="ICFREL_00000125" import_version_number_seq="4"><relationship_obj>9739.24</relationship_obj>
<relationship_reference>ICFREL_00000125</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSMSE</parent_entity>
<child_entity>GSMSE</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>yes</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>S</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>S</parent_update_action>
<parent_verb_phrase>is extended by</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>S</child_insert_action>
<child_update_action>S</child_update_action>
<child_verb_phrase>is extended by</child_verb_phrase>
<model_external_reference>e788de30_459725c9_c0d007ab_e5ed2e98_0_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051258.09</relationship_field_obj>
<relationship_obj>9739.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsm_session_type</parent_table_name>
<parent_field_name>session_type_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsm_session_type</child_table_name>
<child_field_name>extends_session_type_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="129" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61395" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9741.24" record_version_obj="3000045007.09" version_number_seq="4" secondary_key_value="ICFREL_00000126" import_version_number_seq="4"><relationship_obj>9741.24</relationship_obj>
<relationship_reference>ICFREL_00000126</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSMSE</parent_entity>
<child_entity>GSMSY</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>C</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>is modified by</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>is modified by</child_verb_phrase>
<model_external_reference>bedd35b1_43d5362a_4b80e598_84b19015_389_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051259.09</relationship_field_obj>
<relationship_obj>9741.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsm_session_type</parent_table_name>
<parent_field_name>session_type_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsm_session_type_property</child_table_name>
<child_field_name>session_type_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="130" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61395" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9743.24" record_version_obj="3000045009.09" version_number_seq="4" secondary_key_value="ICFREL_00000127" import_version_number_seq="4"><relationship_obj>9743.24</relationship_obj>
<relationship_reference>ICFREL_00000127</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSMSE</parent_entity>
<child_entity>GSMSF</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>C</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>initializes with</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>initializes with</child_verb_phrase>
<model_external_reference>c7b0d2bf_4c8b7164_ea0e1d92_308a04e9_378_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051260.09</relationship_field_obj>
<relationship_obj>9743.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsm_session_type</parent_table_name>
<parent_field_name>session_type_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsm_startup_flow</child_table_name>
<child_field_name>session_type_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="131" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61395" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9745.24" record_version_obj="3000045011.09" version_number_seq="4" secondary_key_value="ICFREL_00000128" import_version_number_seq="4"><relationship_obj>9745.24</relationship_obj>
<relationship_reference>ICFREL_00000128</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSMST</parent_entity>
<child_entity>GSTBT</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>N</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>N</parent_update_action>
<parent_verb_phrase></parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase></child_verb_phrase>
<model_external_reference>4ba8d219_49a7ce3b_6acd2493_11d5ad26_2bf_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051261.09</relationship_field_obj>
<relationship_obj>9745.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsm_status</parent_table_name>
<parent_field_name>status_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gst_batch_job</child_table_name>
<child_field_name>status_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="132" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61395" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9747.24" record_version_obj="3000045013.09" version_number_seq="4" secondary_key_value="ICFREL_00000129" import_version_number_seq="4"><relationship_obj>9747.24</relationship_obj>
<relationship_reference>ICFREL_00000129</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSMST</parent_entity>
<child_entity>GSMSH</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>R</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase></parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase></child_verb_phrase>
<model_external_reference>53c63cf_42a8ba0c_5ab93a93_18a7ab9f_4c_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051262.09</relationship_field_obj>
<relationship_obj>9747.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsm_status</parent_table_name>
<parent_field_name>status_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsm_status_history</child_table_name>
<child_field_name>status_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="133" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61395" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9749.24" record_version_obj="3000045015.09" version_number_seq="4" secondary_key_value="ICFREL_00000130" import_version_number_seq="4"><relationship_obj>9749.24</relationship_obj>
<relationship_reference>ICFREL_00000130</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>RYCSO</parent_entity>
<child_entity>GSMTM</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>C</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>contains (for SmartToolbar type)</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>contains (for SmartToolbar type)</child_verb_phrase>
<model_external_reference>614df9e4_4b0c43f0_9cf6f4a0_78645985_0_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051263.09</relationship_field_obj>
<relationship_obj>9749.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>ryc_smartobject</parent_table_name>
<parent_field_name>smartobject_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsm_toolbar_menu_structure</child_table_name>
<child_field_name>object_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="134" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61395" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9751.24" record_version_obj="3000045017.09" version_number_seq="4" secondary_key_value="ICFREL_00000131" import_version_number_seq="4"><relationship_obj>9751.24</relationship_obj>
<relationship_reference>ICFREL_00000131</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSMUS</parent_entity>
<child_entity>GSTSS</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>yes</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>C</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>S</parent_update_action>
<parent_verb_phrase>has</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>S</child_insert_action>
<child_update_action>S</child_update_action>
<child_verb_phrase>has</child_verb_phrase>
<model_external_reference>9e7c0d26_40f09cbc_b75b51bb_b2021965_0_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051267.09</relationship_field_obj>
<relationship_obj>9751.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsm_user</parent_table_name>
<parent_field_name>user_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gst_session</child_table_name>
<child_field_name>user_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="135" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61395" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9753.24" record_version_obj="3000045019.09" version_number_seq="4" secondary_key_value="ICFREL_00000132" import_version_number_seq="4"><relationship_obj>9753.24</relationship_obj>
<relationship_reference>ICFREL_00000132</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSMUS</parent_entity>
<child_entity>RYTDS</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>yes</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>R</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>S</parent_update_action>
<parent_verb_phrase>updated</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>S</child_insert_action>
<child_update_action>S</child_update_action>
<child_verb_phrase>updated</child_verb_phrase>
<model_external_reference>3aa2644f_43fdc31d_926f0bb2_aad1f10b_0_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051268.09</relationship_field_obj>
<relationship_obj>9753.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsm_user</parent_table_name>
<parent_field_name>user_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>ryt_dbupdate_status</child_table_name>
<child_field_name>run_by_user_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="136" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61395" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9755.24" record_version_obj="3000045021.09" version_number_seq="4" secondary_key_value="ICFREL_00000133" import_version_number_seq="4"><relationship_obj>9755.24</relationship_obj>
<relationship_reference>ICFREL_00000133</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSMUS</parent_entity>
<child_entity>GSTPH</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>yes</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>S</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>S</parent_update_action>
<parent_verb_phrase>changed</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>S</child_insert_action>
<child_update_action>S</child_update_action>
<child_verb_phrase>changed</child_verb_phrase>
<model_external_reference>3f001cd1_40a4b322_1f20dfa6_d85e59bc_309_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051269.09</relationship_field_obj>
<relationship_obj>9755.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsm_user</parent_table_name>
<parent_field_name>user_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gst_password_history</child_table_name>
<child_field_name>changed_by_user_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="137" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61395" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9757.24" record_version_obj="3000045023.09" version_number_seq="4" secondary_key_value="ICFREL_00000134" import_version_number_seq="4"><relationship_obj>9757.24</relationship_obj>
<relationship_reference>ICFREL_00000134</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSMUS</parent_entity>
<child_entity>GSTER</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>N</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>N</parent_update_action>
<parent_verb_phrase>generated</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>generated</child_verb_phrase>
<model_external_reference>a69d01c2_4837e07b_5f584d8f_789334cf_2f5_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051270.09</relationship_field_obj>
<relationship_obj>9757.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsm_user</parent_table_name>
<parent_field_name>user_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gst_error_log</child_table_name>
<child_field_name>user_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="138" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61395" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9759.24" record_version_obj="3000045025.09" version_number_seq="4" secondary_key_value="ICFREL_00000135" import_version_number_seq="4"><relationship_obj>9759.24</relationship_obj>
<relationship_reference>ICFREL_00000135</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSMUS</parent_entity>
<child_entity>GSTBT</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>N</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>N</parent_update_action>
<parent_verb_phrase></parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase></child_verb_phrase>
<model_external_reference>1cae6df7_4ca3b457_450a2790_36579f82_2bd_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051271.09</relationship_field_obj>
<relationship_obj>9759.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsm_user</parent_table_name>
<parent_field_name>user_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gst_batch_job</child_table_name>
<child_field_name>user_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="139" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61395" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9761.24" record_version_obj="3000045027.09" version_number_seq="4" secondary_key_value="ICFREL_00000136" import_version_number_seq="4"><relationship_obj>9761.24</relationship_obj>
<relationship_reference>ICFREL_00000136</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSMUS</parent_entity>
<child_entity>GSTEL</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>N</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>N</parent_update_action>
<parent_verb_phrase></parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase></child_verb_phrase>
<model_external_reference>3af796b3_4e90fe2a_ab7bb48c_bc13dd5_2bc_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051272.09</relationship_field_obj>
<relationship_obj>9761.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsm_user</parent_table_name>
<parent_field_name>user_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gst_extract_log</child_table_name>
<child_field_name>user_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="140" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61395" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9763.24" record_version_obj="3000045029.09" version_number_seq="4" secondary_key_value="ICFREL_00000137" import_version_number_seq="4"><relationship_obj>9763.24</relationship_obj>
<relationship_reference>ICFREL_00000137</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSMUS</parent_entity>
<child_entity>GSMUL</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>yes</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>C</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>S</parent_update_action>
<parent_verb_phrase>is allocated</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>S</child_insert_action>
<child_update_action>S</child_update_action>
<child_verb_phrase>is allocated</child_verb_phrase>
<model_external_reference>5738a51f_45617124_2b6b69a9_13e476da_2a1_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051273.09</relationship_field_obj>
<relationship_obj>9763.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsm_user</parent_table_name>
<parent_field_name>user_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsm_user_allocation</child_table_name>
<child_field_name>user_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="141" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61395" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9765.24" record_version_obj="3000045031.09" version_number_seq="4" secondary_key_value="ICFREL_00000138" import_version_number_seq="4"><relationship_obj>9765.24</relationship_obj>
<relationship_reference>ICFREL_00000138</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSMUS</parent_entity>
<child_entity>GSTPH</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>C</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>has</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>has</child_verb_phrase>
<model_external_reference>fc548fe1_43beada6_6cffbdbc_8a0256a7_29d_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051274.09</relationship_field_obj>
<relationship_obj>9765.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsm_user</parent_table_name>
<parent_field_name>user_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gst_password_history</child_table_name>
<child_field_name>user_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="142" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61395" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9767.24" record_version_obj="3000045033.09" version_number_seq="4" secondary_key_value="ICFREL_00000139" import_version_number_seq="4"><relationship_obj>9767.24</relationship_obj>
<relationship_reference>ICFREL_00000139</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSMUS</parent_entity>
<child_entity>GSMUS</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>yes</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>N</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>N</parent_update_action>
<parent_verb_phrase>is a profile for</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>S</child_insert_action>
<child_update_action>S</child_update_action>
<child_verb_phrase>is a profile for</child_verb_phrase>
<model_external_reference>ccb0e12e_4466e4f8_b57e42ab_994bd036_29b_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051275.09</relationship_field_obj>
<relationship_obj>9767.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsm_user</parent_table_name>
<parent_field_name>user_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsm_user</child_table_name>
<child_field_name>created_from_profile_user_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="143" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61395" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9769.24" record_version_obj="3000045035.09" version_number_seq="4" secondary_key_value="ICFREL_00000140" import_version_number_seq="4"><relationship_obj>9769.24</relationship_obj>
<relationship_reference>ICFREL_00000140</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSMUS</parent_entity>
<child_entity>GSTAD</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>N</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>N</parent_update_action>
<parent_verb_phrase>caused</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>caused</child_verb_phrase>
<model_external_reference>bbb71f45_405c2824_9f4e0585_baff57e3_1be_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051276.09</relationship_field_obj>
<relationship_obj>9769.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsm_user</parent_table_name>
<parent_field_name>user_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gst_audit</child_table_name>
<child_field_name>audit_user_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="144" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61395" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9771.24" record_version_obj="3000045037.09" version_number_seq="4" secondary_key_value="ICFREL_00000141" import_version_number_seq="4"><relationship_obj>9771.24</relationship_obj>
<relationship_reference>ICFREL_00000141</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSMUC</parent_entity>
<child_entity>GSMUS</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>R</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>consists of</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>consists of</child_verb_phrase>
<model_external_reference>544566f9_4e0a7c59_e546b69f_fa2822f1_29c_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051277.09</relationship_field_obj>
<relationship_obj>9771.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsm_user_category</parent_table_name>
<parent_field_name>user_category_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsm_user</child_table_name>
<child_field_name>user_category_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="145" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61395" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9773.24" record_version_obj="3000045039.09" version_number_seq="4" secondary_key_value="ICFREL_00000142" import_version_number_seq="4"><relationship_obj>9773.24</relationship_obj>
<relationship_reference>ICFREL_00000142</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>RYCSO</parent_entity>
<child_entity>GSMVP</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>C</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>may be run on</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>may be run on</child_verb_phrase>
<model_external_reference>8906f9e6_44168909_ec65e1a8_3c70a319_0_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051278.09</relationship_field_obj>
<relationship_obj>9773.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>ryc_smartobject</parent_table_name>
<parent_field_name>smartobject_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsm_valid_object_partition</child_table_name>
<child_field_name>object_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="146" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61395" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9775.24" record_version_obj="3000045041.09" version_number_seq="4" secondary_key_value="ICFREL_00000143" import_version_number_seq="4"><relationship_obj>9775.24</relationship_obj>
<relationship_reference>ICFREL_00000143</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSTBT</parent_entity>
<child_entity>GSTEL</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>yes</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>S</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>S</parent_update_action>
<parent_verb_phrase></parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>S</child_insert_action>
<child_update_action>S</child_update_action>
<child_verb_phrase></child_verb_phrase>
<model_external_reference>57074b1f_43302e4f_a6fa5287_ade666bf_2b9_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051279.09</relationship_field_obj>
<relationship_obj>9775.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gst_batch_job</parent_table_name>
<parent_field_name>batch_job_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gst_extract_log</child_table_name>
<child_field_name>batch_job_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="147" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61396" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9777.24" record_version_obj="3000045043.09" version_number_seq="4" secondary_key_value="ICFREL_00000144" import_version_number_seq="4"><relationship_obj>9777.24</relationship_obj>
<relationship_reference>ICFREL_00000144</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSTDP</parent_entity>
<child_entity>GSTDF</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>yes</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>S</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>S</parent_update_action>
<parent_verb_phrase>consists of</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>S</child_insert_action>
<child_update_action>S</child_update_action>
<child_verb_phrase>consists of</child_verb_phrase>
<model_external_reference>8dec2c08_4bc63028_23eed5bc_19a7e957_3d5_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051289.09</relationship_field_obj>
<relationship_obj>9777.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gst_deployment</parent_table_name>
<parent_field_name>deployment_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gst_dataset_file</child_table_name>
<child_field_name>deployment_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="148" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61396" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9779.24" record_version_obj="3000045045.09" version_number_seq="4" secondary_key_value="ICFREL_00000145" import_version_number_seq="4"><relationship_obj>9779.24</relationship_obj>
<relationship_reference>ICFREL_00000145</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSTDP</parent_entity>
<child_entity>GSTDP</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>yes</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>S</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>S</parent_update_action>
<parent_verb_phrase>must be loaded after</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>S</child_insert_action>
<child_update_action>S</child_update_action>
<child_verb_phrase>must be loaded after</child_verb_phrase>
<model_external_reference>197dc403_47fa7e97_c15409b3_f31af7d3_3d9_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051290.09</relationship_field_obj>
<relationship_obj>9779.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gst_deployment</parent_table_name>
<parent_field_name>deployment_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gst_deployment</child_table_name>
<child_field_name>load_after_deployment_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="149" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61396" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9781.24" record_version_obj="3000045047.09" version_number_seq="4" secondary_key_value="ICFREL_00000146" import_version_number_seq="4"><relationship_obj>9781.24</relationship_obj>
<relationship_reference>ICFREL_00000146</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>RYCAT</parent_entity>
<child_entity>RYCAV</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>R</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>has</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>has</child_verb_phrase>
<model_external_reference>735d8e82_46bedd20_12645dbf_18b9c265_39a_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051297.09</relationship_field_obj>
<relationship_obj>9781.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>ryc_attribute</parent_table_name>
<parent_field_name>attribute_label</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>ryc_attribute_value</child_table_name>
<child_field_name>attribute_label</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="150" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61396" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9783.24" record_version_obj="3000045049.09" version_number_seq="4" secondary_key_value="ICFREL_00000147" import_version_number_seq="4"><relationship_obj>9783.24</relationship_obj>
<relationship_reference>ICFREL_00000147</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>RYCAP</parent_entity>
<child_entity>RYCAT</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>yes</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>R</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>has</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>S</child_insert_action>
<child_update_action>S</child_update_action>
<child_verb_phrase>has</child_verb_phrase>
<model_external_reference>c076a5e1_4eeae91f_5d67fbbc_80cbe6a7_39b_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051298.09</relationship_field_obj>
<relationship_obj>9783.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>ryc_attribute_group</parent_table_name>
<parent_field_name>attribute_group_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>ryc_attribute</child_table_name>
<child_field_name>attribute_group_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="151" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61396" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9785.24" record_version_obj="3000045051.09" version_number_seq="4" secondary_key_value="ICFREL_00000148" import_version_number_seq="4"><relationship_obj>9785.24</relationship_obj>
<relationship_reference>ICFREL_00000148</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>RYCOI</parent_entity>
<child_entity>RYCAV</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>yes</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>C</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>S</parent_update_action>
<parent_verb_phrase>has</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>S</child_insert_action>
<child_update_action>S</child_update_action>
<child_verb_phrase>has</child_verb_phrase>
<model_external_reference>bc0b0e8e_41b6fb68_5df65a9d_fd0ce670_3a2_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051302.09</relationship_field_obj>
<relationship_obj>9785.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>ryc_object_instance</parent_table_name>
<parent_field_name>object_instance_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>ryc_attribute_value</child_table_name>
<child_field_name>object_instance_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="152" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61396" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9787.24" record_version_obj="3000045053.09" version_number_seq="4" secondary_key_value="ICFREL_00000149" import_version_number_seq="4"><relationship_obj>9787.24</relationship_obj>
<relationship_reference>ICFREL_00000149</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>RYCSO</parent_entity>
<child_entity>RYCAV</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>yes</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>N</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>N</parent_update_action>
<parent_verb_phrase>container has</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>N</child_insert_action>
<child_update_action>N</child_update_action>
<child_verb_phrase>container has</child_verb_phrase>
<model_external_reference>aeb16cd7_445c6968_684aabaf_cabc3334_3a0_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051303.09</relationship_field_obj>
<relationship_obj>9787.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>ryc_smartobject</parent_table_name>
<parent_field_name>smartobject_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>ryc_attribute_value</child_table_name>
<child_field_name>container_smartobject_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="153" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61396" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9789.24" record_version_obj="3000045055.09" version_number_seq="4" secondary_key_value="ICFREL_00000150" import_version_number_seq="4"><relationship_obj>9789.24</relationship_obj>
<relationship_reference>ICFREL_00000150</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>RYCSO</parent_entity>
<child_entity>RYCAV</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>yes</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>N</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>S</parent_update_action>
<parent_verb_phrase>has</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>S</child_insert_action>
<child_update_action>S</child_update_action>
<child_verb_phrase>has</child_verb_phrase>
<model_external_reference>d71800f9_4876977e_6036f989_53a4093b_39f_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051304.09</relationship_field_obj>
<relationship_obj>9789.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>ryc_smartobject</parent_table_name>
<parent_field_name>smartobject_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>ryc_attribute_value</child_table_name>
<child_field_name>smartobject_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="154" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61396" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9791.24" record_version_obj="3000045057.09" version_number_seq="4" secondary_key_value="ICFREL_00000151" import_version_number_seq="4"><relationship_obj>9791.24</relationship_obj>
<relationship_reference>ICFREL_00000151</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>RYCCR</parent_entity>
<child_entity>RYCSO</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>yes</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>R</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>customizes</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>S</child_insert_action>
<child_update_action>S</child_update_action>
<child_verb_phrase>customizes</child_verb_phrase>
<model_external_reference>8ed70e48_410d4024_bca13082_e1ae39ed_0_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051305.09</relationship_field_obj>
<relationship_obj>9791.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>ryc_customization_result</parent_table_name>
<parent_field_name>customization_result_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>ryc_smartobject</child_table_name>
<child_field_name>customization_result_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="155" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61396" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9793.24" record_version_obj="3000045059.09" version_number_seq="4" secondary_key_value="ICFREL_00000152" import_version_number_seq="4"><relationship_obj>9793.24</relationship_obj>
<relationship_reference>ICFREL_00000152</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>RYCCR</parent_entity>
<child_entity>RYMCZ</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>R</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>is used by</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>is used by</child_verb_phrase>
<model_external_reference>c1b1b992_423bb74c_4a4d7180_61254bdc_0_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051306.09</relationship_field_obj>
<relationship_obj>9793.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>ryc_customization_result</parent_table_name>
<parent_field_name>customization_result_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>rym_customization</child_table_name>
<child_field_name>customization_result_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="156" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61396" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9795.24" record_version_obj="3000045061.09" version_number_seq="4" secondary_key_value="ICFREL_00000153" import_version_number_seq="4"><relationship_obj>9795.24</relationship_obj>
<relationship_reference>ICFREL_00000153</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>RYCCY</parent_entity>
<child_entity>RYCCR</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>C</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>supports</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>supports</child_verb_phrase>
<model_external_reference>2ba1a4a4_45375c73_7c4a95ae_e78b64fe_0_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051307.09</relationship_field_obj>
<relationship_obj>9795.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>ryc_customization_type</parent_table_name>
<parent_field_name>customization_type_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>ryc_customization_result</child_table_name>
<child_field_name>customization_type_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="157" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61396" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9797.24" record_version_obj="3000045063.09" version_number_seq="4" secondary_key_value="ICFREL_00000154" import_version_number_seq="4"><relationship_obj>9797.24</relationship_obj>
<relationship_reference>ICFREL_00000154</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>RYCCY</parent_entity>
<child_entity>RYMCZ</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>C</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>has</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>has</child_verb_phrase>
<model_external_reference>b7e28cbf_467344f2_1e5c7b87_18b01ca0_0_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051308.09</relationship_field_obj>
<relationship_obj>9797.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>ryc_customization_type</parent_table_name>
<parent_field_name>customization_type_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>rym_customization</child_table_name>
<child_field_name>customization_type_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="158" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61396" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9799.24" record_version_obj="3000045065.09" version_number_seq="4" secondary_key_value="ICFREL_00000155" import_version_number_seq="4"><relationship_obj>9799.24</relationship_obj>
<relationship_reference>ICFREL_00000155</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>RYCLA</parent_entity>
<child_entity>RYCPA</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>R</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>organises</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>organises</child_verb_phrase>
<model_external_reference>a8aff9b3_47c5bf19_b0595789_214463da_3ad_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051309.09</relationship_field_obj>
<relationship_obj>9799.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>ryc_layout</parent_table_name>
<parent_field_name>layout_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>ryc_page</child_table_name>
<child_field_name>layout_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="159" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61396" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9801.24" record_version_obj="3000045067.09" version_number_seq="4" secondary_key_value="ICFREL_00000156" import_version_number_seq="4"><relationship_obj>9801.24</relationship_obj>
<relationship_reference>ICFREL_00000156</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>RYCLA</parent_entity>
<child_entity>RYCSO</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>yes</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>R</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>S</parent_update_action>
<parent_verb_phrase>organises</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>S</child_insert_action>
<child_update_action>S</child_update_action>
<child_verb_phrase>organises</child_verb_phrase>
<model_external_reference>d637e0d2_48e1b572_1618b193_c49dc117_3aa_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051310.09</relationship_field_obj>
<relationship_obj>9801.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>ryc_layout</parent_table_name>
<parent_field_name>layout_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>ryc_smartobject</child_table_name>
<child_field_name>layout_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="160" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61396" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9803.24" record_version_obj="3000045069.09" version_number_seq="4" secondary_key_value="ICFREL_00000157" import_version_number_seq="4"><relationship_obj>9803.24</relationship_obj>
<relationship_reference>ICFREL_00000157</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>RYCOI</parent_entity>
<child_entity>RYCUE</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>yes</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>C</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>S</parent_update_action>
<parent_verb_phrase>has</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>S</child_insert_action>
<child_update_action>S</child_update_action>
<child_verb_phrase>has</child_verb_phrase>
<model_external_reference>4f9ef9bf_4c42a958_3ae2ccb5_e2f7ce71_3c0_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051311.09</relationship_field_obj>
<relationship_obj>9803.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>ryc_object_instance</parent_table_name>
<parent_field_name>object_instance_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>ryc_ui_event</child_table_name>
<child_field_name>object_instance_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="161" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61396" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9807.24" record_version_obj="3000045073.09" version_number_seq="4" secondary_key_value="ICFREL_00000159" import_version_number_seq="4"><relationship_obj>9807.24</relationship_obj>
<relationship_reference>ICFREL_00000159</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>RYCOI</parent_entity>
<child_entity>RYCSM</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>yes</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>C</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>N</parent_update_action>
<parent_verb_phrase>source</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>N</child_insert_action>
<child_update_action>N</child_update_action>
<child_verb_phrase>source</child_verb_phrase>
<model_external_reference>d0bcae68_4cf778db_5ae4a687_9c237a77_3a6_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051313.09</relationship_field_obj>
<relationship_obj>9807.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>ryc_object_instance</parent_table_name>
<parent_field_name>object_instance_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>ryc_smartlink</child_table_name>
<child_field_name>source_object_instance_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="162" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61396" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9809.24" record_version_obj="3000045075.09" version_number_seq="4" secondary_key_value="ICFREL_00000160" import_version_number_seq="4"><relationship_obj>9809.24</relationship_obj>
<relationship_reference>ICFREL_00000160</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>RYCOI</parent_entity>
<child_entity>RYCSM</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>yes</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>C</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>N</parent_update_action>
<parent_verb_phrase>target</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>N</child_insert_action>
<child_update_action>N</child_update_action>
<child_verb_phrase>target</child_verb_phrase>
<model_external_reference>6e9d6eed_42866046_5bcaf9a1_f5f5558c_3a5_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051314.09</relationship_field_obj>
<relationship_obj>9809.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>ryc_object_instance</parent_table_name>
<parent_field_name>object_instance_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>ryc_smartlink</child_table_name>
<child_field_name>target_object_instance_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="163" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61396" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9811.24" record_version_obj="3000045077.09" version_number_seq="4" secondary_key_value="ICFREL_00000161" import_version_number_seq="4"><relationship_obj>9811.24</relationship_obj>
<relationship_reference>ICFREL_00000161</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>RYCSO</parent_entity>
<child_entity>RYCOI</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>R</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>container</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>container</child_verb_phrase>
<model_external_reference>711124ed_47b53343_b54fb6b4_c23f3762_3a4_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051315.09</relationship_field_obj>
<relationship_obj>9811.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>ryc_smartobject</parent_table_name>
<parent_field_name>smartobject_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>ryc_object_instance</child_table_name>
<child_field_name>container_smartobject_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="164" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61396" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9813.24" record_version_obj="3000045079.09" version_number_seq="4" secondary_key_value="ICFREL_00000162" import_version_number_seq="4"><relationship_obj>9813.24</relationship_obj>
<relationship_reference>ICFREL_00000162</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>RYCSO</parent_entity>
<child_entity>RYCOI</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>N</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>N</parent_update_action>
<parent_verb_phrase>instance</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>N</child_insert_action>
<child_update_action>N</child_update_action>
<child_verb_phrase>instance</child_verb_phrase>
<model_external_reference>91e6607b_455791f6_4ef461a1_e2b0f211_3a3_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051316.09</relationship_field_obj>
<relationship_obj>9813.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>ryc_smartobject</parent_table_name>
<parent_field_name>smartobject_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>ryc_object_instance</child_table_name>
<child_field_name>smartobject_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="165" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61396" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9817.24" record_version_obj="3000045083.09" version_number_seq="4" secondary_key_value="ICFREL_00000164" import_version_number_seq="4"><relationship_obj>9817.24</relationship_obj>
<relationship_reference>ICFREL_00000164</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>RYCSO</parent_entity>
<child_entity>RYCPA</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>R</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>contains</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>contains</child_verb_phrase>
<model_external_reference>30e5ad2d_42fc69f8_66167690_f77ea3a2_3ae_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051318.09</relationship_field_obj>
<relationship_obj>9817.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>ryc_smartobject</parent_table_name>
<parent_field_name>smartobject_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>ryc_page</child_table_name>
<child_field_name>container_smartobject_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="166" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61396" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9821.24" record_version_obj="3000045087.09" version_number_seq="4" secondary_key_value="ICFREL_00000166" import_version_number_seq="4"><relationship_obj>9821.24</relationship_obj>
<relationship_reference>ICFREL_00000166</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>RYCRE</parent_entity>
<child_entity>RYCRF</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>R</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>is joined using</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>is joined using</child_verb_phrase>
<model_external_reference>e725a1db_4fe82e6c_6c330f90_f49a7de2_0_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051320.09</relationship_field_obj>
<relationship_obj>9821.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>ryc_relationship</parent_table_name>
<parent_field_name>relationship_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>ryc_relationship_field</child_table_name>
<child_field_name>relationship_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="167" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61397" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9823.24" record_version_obj="3000045089.09" version_number_seq="4" secondary_key_value="ICFREL_00000167" import_version_number_seq="4"><relationship_obj>9823.24</relationship_obj>
<relationship_reference>ICFREL_00000167</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>RYCST</parent_entity>
<child_entity>RYCSM</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>R</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>identifies</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>identifies</child_verb_phrase>
<model_external_reference>5057ac1e_4b3410e7_e0b294a2_3a9ffb22_3a8_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051324.09</relationship_field_obj>
<relationship_obj>9823.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>ryc_smartlink_type</parent_table_name>
<parent_field_name>smartlink_type_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>ryc_smartlink</child_table_name>
<child_field_name>smartlink_type_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="168" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61397" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9825.24" record_version_obj="3000045091.09" version_number_seq="4" secondary_key_value="ICFREL_00000168" import_version_number_seq="4"><relationship_obj>9825.24</relationship_obj>
<relationship_reference>ICFREL_00000168</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>RYCSO</parent_entity>
<child_entity>RYCSM</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>C</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>N</parent_update_action>
<parent_verb_phrase>contains</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>N</child_insert_action>
<child_update_action>N</child_update_action>
<child_verb_phrase>contains</child_verb_phrase>
<model_external_reference>20520bdb_422dfc03_c2b6c0aa_f323bb5d_3a7_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051325.09</relationship_field_obj>
<relationship_obj>9825.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>ryc_smartobject</parent_table_name>
<parent_field_name>smartobject_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>ryc_smartlink</child_table_name>
<child_field_name>container_smartobject_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="169" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61397" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9827.24" record_version_obj="3000045093.09" version_number_seq="4" secondary_key_value="ICFREL_00000169" import_version_number_seq="4"><relationship_obj>9827.24</relationship_obj>
<relationship_reference>ICFREL_00000169</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>RYCST</parent_entity>
<child_entity>RYCSL</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>C</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>is supported by</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>is supported by</child_verb_phrase>
<model_external_reference>d55535d5_4d00b021_8192c89d_a3e9829e_3a9_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051326.09</relationship_field_obj>
<relationship_obj>9827.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>ryc_smartlink_type</parent_table_name>
<parent_field_name>smartlink_type_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>ryc_supported_link</child_table_name>
<child_field_name>smartlink_type_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="170" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61397" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9829.24" record_version_obj="3000045095.09" version_number_seq="4" secondary_key_value="ICFREL_00000170" import_version_number_seq="4"><relationship_obj>9829.24</relationship_obj>
<relationship_reference>ICFREL_00000170</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>RYCSO</parent_entity>
<child_entity>RYCSO</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>yes</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>N</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>N</parent_update_action>
<parent_verb_phrase>secures</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>N</child_insert_action>
<child_update_action>N</child_update_action>
<child_verb_phrase>secures</child_verb_phrase>
<model_external_reference>17773703_4b999ffa_f9bd9d83_74a0b035_0_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051327.09</relationship_field_obj>
<relationship_obj>9829.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>ryc_smartobject</parent_table_name>
<parent_field_name>smartobject_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>ryc_smartobject</child_table_name>
<child_field_name>security_smartobject_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="171" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="03/24/2003" version_time="51402" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9831.24" record_version_obj="3000045097.09" version_number_seq="1.09" secondary_key_value="ICFREL_00000171" import_version_number_seq="1.09"><relationship_obj>9831.24</relationship_obj>
<relationship_reference>ICFREL_00000171</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>RYCSO</parent_entity>
<child_entity>RYCSO</child_entity>
<primary_relationship>no</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>yes</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>no</update_parent_allowed>
<parent_delete_action>N</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>N</parent_update_action>
<parent_verb_phrase>is the physical object for</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>N</child_insert_action>
<child_update_action>N</child_update_action>
<child_verb_phrase>is the physical object for</child_verb_phrase>
<model_external_reference>827dba6d_4a91460a_85235cbb_66ba4256_0_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000045096.09</relationship_field_obj>
<relationship_obj>9831.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>ryc_smartobject</parent_table_name>
<parent_field_name>smartobject_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>ryc_smartobject</child_table_name>
<child_field_name>physical_smartobject_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="172" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61397" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9833.24" record_version_obj="3000045099.09" version_number_seq="4" secondary_key_value="ICFREL_00000172" import_version_number_seq="4"><relationship_obj>9833.24</relationship_obj>
<relationship_reference>ICFREL_00000172</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>RYCSO</parent_entity>
<child_entity>RYCSO</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>yes</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>N</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>N</parent_update_action>
<parent_verb_phrase>is extended by</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>N</child_insert_action>
<child_update_action>N</child_update_action>
<child_verb_phrase>is extended by</child_verb_phrase>
<model_external_reference>b97dcc75_4a1d963f_39382684_9825fd88_0_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051328.09</relationship_field_obj>
<relationship_obj>9833.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>ryc_smartobject</parent_table_name>
<parent_field_name>smartobject_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>ryc_smartobject</child_table_name>
<child_field_name>extends_smartobject_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="173" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="03/24/2003" version_time="51402" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9835.24" record_version_obj="3000045101.09" version_number_seq="1.09" secondary_key_value="ICFREL_00000173" import_version_number_seq="1.09"><relationship_obj>9835.24</relationship_obj>
<relationship_reference>ICFREL_00000173</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>RYCSO</parent_entity>
<child_entity>RYCSO</child_entity>
<primary_relationship>no</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>yes</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>no</update_parent_allowed>
<parent_delete_action>N</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>N</parent_update_action>
<parent_verb_phrase>is the custom procedure for</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>N</child_insert_action>
<child_update_action>N</child_update_action>
<child_verb_phrase>is the custom procedure for</child_verb_phrase>
<model_external_reference>16ccdb49_47e079aa_86cd8395_80fd3314_0_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000045100.09</relationship_field_obj>
<relationship_obj>9835.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>ryc_smartobject</parent_table_name>
<parent_field_name>smartobject_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>ryc_smartobject</child_table_name>
<child_field_name>custom_smartobject_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="174" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61397" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9837.24" record_version_obj="3000045103.09" version_number_seq="4" secondary_key_value="ICFREL_00000174" import_version_number_seq="4"><relationship_obj>9837.24</relationship_obj>
<relationship_reference>ICFREL_00000174</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>RYCSO</parent_entity>
<child_entity>RYCUE</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>yes</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>N</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>S</parent_update_action>
<parent_verb_phrase>has</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>S</child_insert_action>
<child_update_action>S</child_update_action>
<child_verb_phrase>has</child_verb_phrase>
<model_external_reference>ce319c30_4743a088_4973d9a_66495f_3bf_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051329.09</relationship_field_obj>
<relationship_obj>9837.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>ryc_smartobject</parent_table_name>
<parent_field_name>smartobject_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>ryc_ui_event</child_table_name>
<child_field_name>smartobject_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="175" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61397" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9839.24" record_version_obj="3000045105.09" version_number_seq="4" secondary_key_value="ICFREL_00000175" import_version_number_seq="4"><relationship_obj>9839.24</relationship_obj>
<relationship_reference>ICFREL_00000175</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>RYCSO</parent_entity>
<child_entity>RYCUE</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>yes</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>N</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>N</parent_update_action>
<parent_verb_phrase>container has</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>N</child_insert_action>
<child_update_action>N</child_update_action>
<child_verb_phrase>container has</child_verb_phrase>
<model_external_reference>fcab7ee9_43ea76d5_b5f09b6_e34cb182_3be_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051330.09</relationship_field_obj>
<relationship_obj>9839.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>ryc_smartobject</parent_table_name>
<parent_field_name>smartobject_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>ryc_ui_event</child_table_name>
<child_field_name>container_smartobject_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="176" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61397" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="9841.24" record_version_obj="3000045107.09" version_number_seq="4" secondary_key_value="ICFREL_00000176" import_version_number_seq="4"><relationship_obj>9841.24</relationship_obj>
<relationship_reference>ICFREL_00000176</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>RYCSO</parent_entity>
<child_entity>RYCSO</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>yes</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>N</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>N</parent_update_action>
<parent_verb_phrase>provides data for</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>N</child_insert_action>
<child_update_action>N</child_update_action>
<child_verb_phrase>provides data for</child_verb_phrase>
<model_external_reference>694dc9f0_42525aef_cd13c481_f7d1b59c_3a1_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051331.09</relationship_field_obj>
<relationship_obj>9841.24</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>ryc_smartobject</parent_table_name>
<parent_field_name>smartobject_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>ryc_smartobject</child_table_name>
<child_field_name>sdo_smartobject_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="177" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61390" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="3000051117.09" record_version_obj="3000051118.09" version_number_seq="3" secondary_key_value="ICFREL90_00000177" import_version_number_seq="3"><relationship_obj>3000051117.09</relationship_obj>
<relationship_reference>ICFREL90_00000177</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSCEM</parent_entity>
<child_entity>GSMFD</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>R</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>has</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>has</child_verb_phrase>
<model_external_reference>30f77e71_497cf492_1825f3bf_8f0f94c0_0_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051119.09</relationship_field_obj>
<relationship_obj>3000051117.09</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsc_entity_mnemonic</parent_table_name>
<parent_field_name>entity_mnemonic</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsm_filter_data</child_table_name>
<child_field_name>owning_entity_mnemonic</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="178" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61390" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="3000051120.09" record_version_obj="3000051121.09" version_number_seq="3" secondary_key_value="ICFREL90_00000178" import_version_number_seq="3"><relationship_obj>3000051120.09</relationship_obj>
<relationship_reference>ICFREL90_00000178</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSCEM</parent_entity>
<child_entity>GSMSX</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>R</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>has</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>has</child_verb_phrase>
<model_external_reference>9421eb4d_4be1f9dd_4a629e9b_56d6371e_0_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051122.09</relationship_field_obj>
<relationship_obj>3000051120.09</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsc_entity_mnemonic</parent_table_name>
<parent_field_name>entity_mnemonic</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsm_scm_xref</child_table_name>
<child_field_name>owning_entity_mnemonic</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="179" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61391" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="3000051162.09" record_version_obj="3000051163.09" version_number_seq="3" secondary_key_value="ICFREL90_00000179" import_version_number_seq="3"><relationship_obj>3000051162.09</relationship_obj>
<relationship_reference>ICFREL90_00000179</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>RYCSO</parent_entity>
<child_entity>GSCMT</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>yes</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>R</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>is the db unbound object for</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>S</child_insert_action>
<child_update_action>S</child_update_action>
<child_verb_phrase>is the db unbound object for</child_verb_phrase>
<model_external_reference>92d0b9da_409b7132_6a6623a7_e1a102aa_0_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051164.09</relationship_field_obj>
<relationship_obj>3000051162.09</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>ryc_smartobject</parent_table_name>
<parent_field_name>smartobject_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsc_manager_type</child_table_name>
<child_field_name>db_unbound_smartobject_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="180" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61391" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="3000051165.09" record_version_obj="3000051166.09" version_number_seq="3" secondary_key_value="ICFREL90_00000180" import_version_number_seq="3"><relationship_obj>3000051165.09</relationship_obj>
<relationship_reference>ICFREL90_00000180</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>RYCSO</parent_entity>
<child_entity>GSCMT</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>yes</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>R</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>is the db bound object for</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>S</child_insert_action>
<child_update_action>S</child_update_action>
<child_verb_phrase>is the db bound object for</child_verb_phrase>
<model_external_reference>7541c5b5_43d3bbc3_cd519384_ab020e48_0_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051167.09</relationship_field_obj>
<relationship_obj>3000051165.09</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>ryc_smartobject</parent_table_name>
<parent_field_name>smartobject_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsc_manager_type</child_table_name>
<child_field_name>db_bound_smartobject_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="181" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61393" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="3000051188.09" record_version_obj="3000051189.09" version_number_seq="3" secondary_key_value="ICFREL90_00000181" import_version_number_seq="3"><relationship_obj>3000051188.09</relationship_obj>
<relationship_reference>ICFREL90_00000181</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSCSM</parent_entity>
<child_entity>GSMSX</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>C</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>C</parent_update_action>
<parent_verb_phrase>is integrated via</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>is integrated via</child_verb_phrase>
<model_external_reference>c11674f4_4cf15e62_cd1603bc_fdb081a2_0_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051190.09</relationship_field_obj>
<relationship_obj>3000051188.09</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsc_scm_tool</parent_table_name>
<parent_field_name>scm_tool_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsm_scm_xref</child_table_name>
<child_field_name>scm_tool_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="182" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61393" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="3000051191.09" record_version_obj="3000051192.09" version_number_seq="3" secondary_key_value="ICFREL90_00000182" import_version_number_seq="3"><relationship_obj>3000051191.09</relationship_obj>
<relationship_reference>ICFREL90_00000182</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSCSM</parent_entity>
<child_entity>GSCSC</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>yes</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>S</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>S</parent_update_action>
<parent_verb_phrase>is used by</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>S</child_insert_action>
<child_update_action>S</child_update_action>
<child_verb_phrase>is used by</child_verb_phrase>
<model_external_reference>a337677a_480bbec8_8a61ca1_b59ce866_0_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051193.09</relationship_field_obj>
<relationship_obj>3000051191.09</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsc_scm_tool</parent_table_name>
<parent_field_name>scm_tool_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsc_security_control</child_table_name>
<child_field_name>scm_tool_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="183" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61393" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="3000051207.09" record_version_obj="3000051208.09" version_number_seq="3" secondary_key_value="ICFREL90_00000183" import_version_number_seq="3"><relationship_obj>3000051207.09</relationship_obj>
<relationship_reference>ICFREL90_00000183</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSMFI</parent_entity>
<child_entity>GSMFD</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>C</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>C</parent_update_action>
<parent_verb_phrase>contains</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>contains</child_verb_phrase>
<model_external_reference>a2c3dbba_43a6ce37_e4a94ea1_8ee14122_0_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051209.09</relationship_field_obj>
<relationship_obj>3000051207.09</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsm_filter_set</parent_table_name>
<parent_field_name>filter_set_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsm_filter_data</child_table_name>
<child_field_name>filter_set_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="184" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61393" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="3000051215.09" record_version_obj="3000051216.09" version_number_seq="3" secondary_key_value="ICFREL90_00000184" import_version_number_seq="3"><relationship_obj>3000051215.09</relationship_obj>
<relationship_reference>ICFREL90_00000184</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSMUS</parent_entity>
<child_entity>GSMGA</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>R</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>is in</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>is in</child_verb_phrase>
<model_external_reference>41d16388_4a9f25f3_4230e389_26275f1b_0_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051217.09</relationship_field_obj>
<relationship_obj>3000051215.09</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsm_user</parent_table_name>
<parent_field_name>user_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsm_group_allocation</child_table_name>
<child_field_name>user_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="185" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61394" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="3000051218.09" record_version_obj="3000051219.09" version_number_seq="3" secondary_key_value="ICFREL90_00000185" import_version_number_seq="3"><relationship_obj>3000051218.09</relationship_obj>
<relationship_reference>ICFREL90_00000185</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSMUS</parent_entity>
<child_entity>GSMGA</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>R</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>group user contains</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>group user contains</child_verb_phrase>
<model_external_reference>622d05f5_4596c56e_8e4372a6_a670e0f1_0_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051220.09</relationship_field_obj>
<relationship_obj>3000051218.09</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsm_user</parent_table_name>
<parent_field_name>user_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsm_group_allocation</child_table_name>
<child_field_name>group_user_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="186" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61394" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="3000051221.09" record_version_obj="3000051222.09" version_number_seq="3" secondary_key_value="ICFREL90_00000186" import_version_number_seq="3"><relationship_obj>3000051221.09</relationship_obj>
<relationship_reference>ICFREL90_00000186</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSMLG</parent_entity>
<child_entity>GSMGA</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>yes</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>C</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>C</parent_update_action>
<parent_verb_phrase>has</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>S</child_insert_action>
<child_update_action>S</child_update_action>
<child_verb_phrase>has</child_verb_phrase>
<model_external_reference>10ea4d6_4f270010_7edaa9d_e76a99e6_0_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051223.09</relationship_field_obj>
<relationship_obj>3000051221.09</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsm_login_company</parent_table_name>
<parent_field_name>login_company_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsm_group_allocation</child_table_name>
<child_field_name>login_company_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="187" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61394" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="3000051245.09" record_version_obj="3000051246.09" version_number_seq="3" secondary_key_value="ICFREL90_00000187" import_version_number_seq="3"><relationship_obj>3000051245.09</relationship_obj>
<relationship_reference>ICFREL90_00000187</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSMRL</parent_entity>
<child_entity>GSTRL</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>C</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>C</parent_update_action>
<parent_verb_phrase>contains</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>contains</child_verb_phrase>
<model_external_reference>f67430a5_41b4f512_d1d7edb6_e9fa1dd8_0_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051247.09</relationship_field_obj>
<relationship_obj>3000051245.09</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsm_release</parent_table_name>
<parent_field_name>release_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gst_release_version</child_table_name>
<child_field_name>release_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="188" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61395" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="3000051253.09" record_version_obj="3000051254.09" version_number_seq="3" secondary_key_value="ICFREL90_00000188" import_version_number_seq="3"><relationship_obj>3000051253.09</relationship_obj>
<relationship_reference>ICFREL90_00000188</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSTCS</parent_entity>
<child_entity>GSMSC</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>C</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>C</parent_update_action>
<parent_verb_phrase>has</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>has</child_verb_phrase>
<model_external_reference>98027536_47911c3f_3ccd21bc_e6f8871c_0_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051255.09</relationship_field_obj>
<relationship_obj>3000051253.09</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gst_context_scope</parent_table_name>
<parent_field_name>context_scope_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gsm_server_context</child_table_name>
<child_field_name>context_scope_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="189" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61395" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="3000051264.09" record_version_obj="3000051265.09" version_number_seq="3" secondary_key_value="ICFREL90_00000189" import_version_number_seq="3"><relationship_obj>3000051264.09</relationship_obj>
<relationship_reference>ICFREL90_00000189</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSMUS</parent_entity>
<child_entity>GSTCS</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>yes</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>C</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>C</parent_update_action>
<parent_verb_phrase>has</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>S</child_insert_action>
<child_update_action>S</child_update_action>
<child_verb_phrase>has</child_verb_phrase>
<model_external_reference>a232426b_406b5d57_c4cc07be_7ecda3c7_0_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051266.09</relationship_field_obj>
<relationship_obj>3000051264.09</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gsm_user</parent_table_name>
<parent_field_name>user_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gst_context_scope</child_table_name>
<child_field_name>user_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="190" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61395" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="3000051280.09" record_version_obj="3000051281.09" version_number_seq="3" secondary_key_value="ICFREL90_00000190" import_version_number_seq="3"><relationship_obj>3000051280.09</relationship_obj>
<relationship_reference>ICFREL90_00000190</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSTCS</parent_entity>
<child_entity>GSTSS</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>yes</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>S</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>S</parent_update_action>
<parent_verb_phrase>is the default for</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>S</child_insert_action>
<child_update_action>S</child_update_action>
<child_verb_phrase>is the default for</child_verb_phrase>
<model_external_reference>187b2573_45bfb61d_b8746788_5cb68c2b_0_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051282.09</relationship_field_obj>
<relationship_obj>3000051280.09</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gst_context_scope</parent_table_name>
<parent_field_name>context_scope_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gst_session</child_table_name>
<child_field_name>default_context_scope_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="191" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61395" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="3000051283.09" record_version_obj="3000051284.09" version_number_seq="3" secondary_key_value="ICFREL90_00000191" import_version_number_seq="3"><relationship_obj>3000051283.09</relationship_obj>
<relationship_reference>ICFREL90_00000191</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSTCS</parent_entity>
<child_entity>GSTCS</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>yes</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>C</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>C</parent_update_action>
<parent_verb_phrase>is the parent  scope for</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>S</child_insert_action>
<child_update_action>S</child_update_action>
<child_verb_phrase>is the parent  scope for</child_verb_phrase>
<model_external_reference>adb0367d_460ce821_128adca2_d5a8a64c_0_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051285.09</relationship_field_obj>
<relationship_obj>3000051283.09</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gst_context_scope</parent_table_name>
<parent_field_name>context_scope_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gst_context_scope</child_table_name>
<child_field_name>parent_context_scope_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="192" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61396" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="3000051286.09" record_version_obj="3000051287.09" version_number_seq="3" secondary_key_value="ICFREL90_00000192" import_version_number_seq="3"><relationship_obj>3000051286.09</relationship_obj>
<relationship_reference>ICFREL90_00000192</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSTSS</parent_entity>
<child_entity>GSTCS</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>yes</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>C</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>C</parent_update_action>
<parent_verb_phrase>has</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>S</child_insert_action>
<child_update_action>S</child_update_action>
<child_verb_phrase>has</child_verb_phrase>
<model_external_reference>253cb3eb_47a19136_6dd1ea9d_3fe41b7e_0_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051288.09</relationship_field_obj>
<relationship_obj>3000051286.09</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gst_session</parent_table_name>
<parent_field_name>session_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gst_context_scope</child_table_name>
<child_field_name>session_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="193" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61396" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="3000051291.09" record_version_obj="3000051292.09" version_number_seq="3" secondary_key_value="ICFREL90_00000193" import_version_number_seq="3"><relationship_obj>3000051291.09</relationship_obj>
<relationship_reference>ICFREL90_00000193</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>GSTRV</parent_entity>
<child_entity>GSTRL</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>no</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>R</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>is in</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>R</child_insert_action>
<child_update_action>R</child_update_action>
<child_verb_phrase>is in</child_verb_phrase>
<model_external_reference>ca2dc660_451a50e7_84dababb_dc5931cb_0_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051293.09</relationship_field_obj>
<relationship_obj>3000051291.09</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>gst_record_version</parent_table_name>
<parent_field_name>record_version_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gst_release_version</child_table_name>
<child_field_name>record_version_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="194" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61396" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="3000051294.09" record_version_obj="3000051295.09" version_number_seq="3" secondary_key_value="ICFREL90_00000194" import_version_number_seq="3"><relationship_obj>3000051294.09</relationship_obj>
<relationship_reference>ICFREL90_00000194</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>RYCRT</parent_entity>
<child_entity>GSTSS</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>yes</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>S</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>S</parent_update_action>
<parent_verb_phrase>is used in</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>S</child_insert_action>
<child_update_action>S</child_update_action>
<child_verb_phrase>is used in</child_verb_phrase>
<model_external_reference>dea94548_47a9d9c0_59d2018e_a4ce3e3d_0_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051296.09</relationship_field_obj>
<relationship_obj>3000051294.09</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>ryc_render_type</parent_table_name>
<parent_field_name>render_type_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>gst_session</child_table_name>
<child_field_name>render_type_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="195" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61396" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="3000051299.09" record_version_obj="3000051300.09" version_number_seq="3" secondary_key_value="ICFREL90_00000195" import_version_number_seq="3"><relationship_obj>3000051299.09</relationship_obj>
<relationship_reference>ICFREL90_00000195</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>RYCRT</parent_entity>
<child_entity>RYCAV</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>yes</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>R</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>has</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>S</child_insert_action>
<child_update_action>S</child_update_action>
<child_verb_phrase>has</child_verb_phrase>
<model_external_reference>b3f027e6_4fb5ca9c_f250588d_2af8fab8_0_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051301.09</relationship_field_obj>
<relationship_obj>3000051299.09</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>ryc_render_type</parent_table_name>
<parent_field_name>render_type_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>ryc_attribute_value</child_table_name>
<child_field_name>render_type_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="196" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_relationship" version_date="06/05/2003" version_time="61397" version_user="admin" deletion_flag="no" entity_mnemonic="RYCRE" key_field_value="3000051321.09" record_version_obj="3000051322.09" version_number_seq="3" secondary_key_value="ICFREL90_00000196" import_version_number_seq="3"><relationship_obj>3000051321.09</relationship_obj>
<relationship_reference>ICFREL90_00000196</relationship_reference>
<relationship_description></relationship_description>
<parent_entity>RYCRT</parent_entity>
<child_entity>RYCUE</child_entity>
<primary_relationship>yes</primary_relationship>
<identifying_relationship>yes</identifying_relationship>
<nulls_allowed>yes</nulls_allowed>
<cardinality>01M</cardinality>
<update_parent_allowed>yes</update_parent_allowed>
<parent_delete_action>R</parent_delete_action>
<parent_insert_action>N</parent_insert_action>
<parent_update_action>R</parent_update_action>
<parent_verb_phrase>has</parent_verb_phrase>
<child_delete_action>N</child_delete_action>
<child_insert_action>S</child_insert_action>
<child_update_action>S</child_update_action>
<child_verb_phrase>has</child_verb_phrase>
<model_external_reference>a708d06c_43d596ea_8996c8aa_7d23e644_0_</model_external_reference>
<contained_record DB="icfdb" Table="ryc_relationship_field"><relationship_field_obj>3000051323.09</relationship_field_obj>
<relationship_obj>3000051321.09</relationship_obj>
<join_sequence>1</join_sequence>
<parent_table_name>ryc_render_type</parent_table_name>
<parent_field_name>render_type_obj</parent_field_name>
<use_parent_constant_value>no</use_parent_constant_value>
<parent_constant_value></parent_constant_value>
<child_table_name>ryc_ui_event</child_table_name>
<child_field_name>render_type_obj</child_field_name>
<use_child_constant_value>no</use_child_constant_value>
<child_constant_value></child_constant_value>
</contained_record>
</contained_record>
</dataset_transaction>
</dataset_records>
</dataset>