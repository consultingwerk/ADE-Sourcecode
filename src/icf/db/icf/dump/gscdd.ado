<?xml version="1.0" encoding="utf-8" ?>
<dataset Transactions="60"><dataset_header DisableRI="yes" DatasetObj="1007600169.08" DateFormat="mdy" FullHeader="yes" SCMManaged="no" YearOffset="1950" DatasetCode="GSCDD" NumericFormat="AMERICAN" NumericDecimal="." OriginatingSite="90" NumericSeparator=","><deploy_dataset_obj>1007600169.08</deploy_dataset_obj>
<dataset_code>GSCDD</dataset_code>
<dataset_description>gsc_deploy_dataset - Deployment DS</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<deploy_additions_only>no</deploy_additions_only>
<enable_data_versioning>yes</enable_data_versioning>
<deletion_dataset>yes</deletion_dataset>
<dataset_entity><dataset_entity_obj>1007600170.08</dataset_entity_obj>
<deploy_dataset_obj>1007600169.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSCDD</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>dataset_code</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
<entity_mnemonic_description>gsc_deploy_dataset</entity_mnemonic_description>
<entity_dbname>ICFDB</entity_dbname>
</dataset_entity>
<dataset_entity><dataset_entity_obj>1007600171.08</dataset_entity_obj>
<deploy_dataset_obj>1007600169.08</deploy_dataset_obj>
<entity_sequence>2</entity_sequence>
<entity_mnemonic>GSCDE</entity_mnemonic>
<primary_entity>no</primary_entity>
<join_entity_mnemonic>GSCDD</join_entity_mnemonic>
<join_field_list>deploy_dataset_obj,deploy_dataset_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
<entity_mnemonic_description>gsc_dataset_entity</entity_mnemonic_description>
<entity_dbname>ICFDB</entity_dbname>
</dataset_entity>
<table_definition><name>gsc_deploy_dataset</name>
<dbname>icfdb</dbname>
<index-1>XAK1gsc_deploy_dataset,1,0,0,dataset_code,0</index-1>
<index-2>XIE1gsc_deploy_dataset,0,0,0,dataset_description,0</index-2>
<index-3>XIE2gsc_deploy_dataset,0,0,0,source_code_data,0</index-3>
<index-4>XPKgsc_deploy_dataset,1,1,0,deploy_dataset_obj,0</index-4>
<field><name>deploy_dataset_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Deploy Dataset Obj</label>
<column-label>Deploy Dataset Obj</column-label>
</field>
<field><name>dataset_code</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(10)</format>
<initial></initial>
<label>Dataset Code</label>
<column-label>Dataset Code</column-label>
</field>
<field><name>dataset_description</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(500)</format>
<initial></initial>
<label>Dataset Description</label>
<column-label>Dataset Description</column-label>
</field>
<field><name>disable_ri</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>YES</initial>
<label>Disable Ri</label>
<column-label>Disable Ri</column-label>
</field>
<field><name>source_code_data</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>Source Code Data</label>
<column-label>Source Code Data</column-label>
</field>
<field><name>deploy_full_data</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>Deploy Full Data</label>
<column-label>Deploy Full Data</column-label>
</field>
<field><name>xml_generation_procedure</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Xml Generation Procedure</label>
<column-label>Xml Generation Procedure</column-label>
</field>
<field><name>default_ado_filename</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Default Ado Filename</label>
<column-label>Default Ado Filename</column-label>
</field>
<field><name>deploy_additions_only</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>Deploy Additions Only</label>
<column-label>Deploy Additions Only</column-label>
</field>
<field><name>enable_data_versioning</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>Enable Data Versioning</label>
<column-label>Enable Data Versioning</column-label>
</field>
<field><name>deletion_dataset</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>Deletion Dataset</label>
<column-label>Deletion Dataset</column-label>
</field>
</table_definition>
<table_definition><name>gsc_dataset_entity</name>
<dbname>icfdb</dbname>
<index-1>XAK1gsc_dataset_entity,1,0,0,deploy_dataset_obj,0,entity_sequence,0</index-1>
<index-2>XIE1gsc_dataset_entity,0,0,0,entity_mnemonic,0</index-2>
<index-3>XIE3gsc_dataset_entity,0,0,0,deploy_dataset_obj,0,primary_entity,0,entity_mnemonic,0</index-3>
<index-4>XIE4gsc_dataset_entity,0,0,0,join_entity_mnemonic,0,dataset_entity_obj,0</index-4>
<index-5>XIE5gsc_dataset_entity,0,0,0,relationship_obj,0</index-5>
<index-6>XPKgsc_dataset_entity,1,1,0,dataset_entity_obj,0</index-6>
<field><name>dataset_entity_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Dataset Entity Obj</label>
<column-label>Dataset Entity Obj</column-label>
</field>
<field><name>deploy_dataset_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Deploy Dataset Obj</label>
<column-label>Deploy Dataset Obj</column-label>
</field>
<field><name>entity_sequence</name>
<data-type>integer</data-type>
<extent>0</extent>
<format>-&gt;&gt;9</format>
<initial>   0</initial>
<label>Entity Sequence</label>
<column-label>Entity Seq.</column-label>
</field>
<field><name>entity_mnemonic</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(8)</format>
<initial></initial>
<label>Entity Mnemonic</label>
<column-label>Entity Mnemonic</column-label>
</field>
<field><name>primary_entity</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>Primary Entity</label>
<column-label>Primary Entity</column-label>
</field>
<field><name>join_entity_mnemonic</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(8)</format>
<initial></initial>
<label>Join Entity Mnemonic</label>
<column-label>Join Entity Mnemonic</column-label>
</field>
<field><name>join_field_list</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Join Field List</label>
<column-label>Join Field List</column-label>
</field>
<field><name>filter_where_clause</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(500)</format>
<initial></initial>
<label>Filter Where Clause</label>
<column-label>Filter Where Clause</column-label>
</field>
<field><name>delete_related_records</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>YES</initial>
<label>Delete Related Records</label>
<column-label>Delete Related Records</column-label>
</field>
<field><name>overwrite_records</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>YES</initial>
<label>Overwrite Records</label>
<column-label>Overwrite Records</column-label>
</field>
<field><name>keep_own_site_data</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>Keep Own Site Data</label>
<column-label>Keep Own Site Data</column-label>
</field>
<field><name>use_relationship</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>Use Relationship</label>
<column-label>Use Relationship</column-label>
</field>
<field><name>relationship_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Relationship Obj</label>
<column-label>Relationship Obj</column-label>
</field>
<field><name>deletion_action</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(1)</format>
<initial></initial>
<label>Deletion Action</label>
<column-label>Deletion Action</column-label>
</field>
</table_definition>
</dataset_header>
<dataset_records><dataset_transaction TransactionNo="1" TransactionType="DELETION"><contained_record version_date="05/22/2002" version_time="61354" version_user="admin" deletion_flag="yes" entity_mnemonic="gscdd" key_field_value="1000000148.39" record_version_obj="1000000149.39" version_number_seq="1.09" secondary_key_value="RVMTA" import_version_number_seq="1.09"/>
</dataset_transaction>
<dataset_transaction TransactionNo="2" TransactionType="DELETION"><contained_record version_date="05/22/2002" version_time="61345" version_user="admin" deletion_flag="yes" entity_mnemonic="gscdd" key_field_value="1000000152.39" record_version_obj="1000000153.39" version_number_seq="1.09" secondary_key_value="RVCCT" import_version_number_seq="1.09"/>
</dataset_transaction>
<dataset_transaction TransactionNo="3" TransactionType="DELETION"><contained_record version_date="05/22/2002" version_time="61351" version_user="admin" deletion_flag="yes" entity_mnemonic="gscdd" key_field_value="1000000156.39" record_version_obj="1000000157.39" version_number_seq="1.09" secondary_key_value="RVMCI" import_version_number_seq="1.09"/>
</dataset_transaction>
<dataset_transaction TransactionNo="4" TransactionType="DELETION"><contained_record version_date="05/22/2002" version_time="61358" version_user="admin" deletion_flag="yes" entity_mnemonic="gscdd" key_field_value="1000000162.39" record_version_obj="1000000163.39" version_number_seq="1.09" secondary_key_value="RVMWS" import_version_number_seq="1.09"/>
</dataset_transaction>
<dataset_transaction TransactionNo="5" TransactionType="DELETION"><contained_record version_date="05/22/2002" version_time="61395" version_user="admin" deletion_flag="yes" entity_mnemonic="gscdd" key_field_value="1007600097.08" record_version_obj="3000000076.09" version_number_seq="1.09" secondary_key_value="GSCOB" import_version_number_seq="1.09"/>
</dataset_transaction>
<dataset_transaction TransactionNo="6" TransactionType="DELETION"><contained_record version_date="05/24/2002" version_time="29936" version_user="admin" deletion_flag="yes" entity_mnemonic="gscdd" key_field_value="1007600207.08" record_version_obj="3000000082.09" version_number_seq="1.09" secondary_key_value="GSMSI" import_version_number_seq="1.09"/>
</dataset_transaction>
<dataset_transaction TransactionNo="7" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_deploy_dataset" version_date="06/24/2002" version_time="84534" version_user="bgruenba" deletion_flag="no" entity_mnemonic="gscdd" key_field_value="9843.24" record_version_obj="9844.24" version_number_seq="2.24" secondary_key_value="RYCRE" import_version_number_seq="2.24"><deploy_dataset_obj>9843.24</deploy_dataset_obj>
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
<contained_record DB="icfdb" Table="gsc_dataset_entity"><dataset_entity_obj>9845.24</dataset_entity_obj>
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
</contained_record>
<contained_record DB="icfdb" Table="gsc_dataset_entity"><dataset_entity_obj>9847.24</dataset_entity_obj>
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
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="8" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_deploy_dataset" version_date="07/30/2002" version_time="54091" version_user="admin" deletion_flag="no" entity_mnemonic="gscdd" key_field_value="9849.24" record_version_obj="9850.24" version_number_seq="1.09" secondary_key_value="RYCRI" import_version_number_seq="1.09"><deploy_dataset_obj>9849.24</deploy_dataset_obj>
<dataset_code>RYCRI</dataset_code>
<dataset_description>ryc_ri_default</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename>rycri.ado</default_ado_filename>
<deploy_additions_only>no</deploy_additions_only>
<enable_data_versioning>yes</enable_data_versioning>
<deletion_dataset>yes</deletion_dataset>
<contained_record DB="icfdb" Table="gsc_dataset_entity"><dataset_entity_obj>9851.24</dataset_entity_obj>
<deploy_dataset_obj>9849.24</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>RYCRI</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>ri_default_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="9" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_deploy_dataset" version_date="07/30/2002" version_time="54096" version_user="admin" deletion_flag="no" entity_mnemonic="gscdd" key_field_value="1004928896.09" record_version_obj="3000005370.09" version_number_seq="1.09" secondary_key_value="RYCSO" import_version_number_seq="1.09"><deploy_dataset_obj>1004928896.09</deploy_dataset_obj>
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
<contained_record DB="icfdb" Table="gsc_dataset_entity"><dataset_entity_obj>1004928912.09</dataset_entity_obj>
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
</contained_record>
<contained_record DB="icfdb" Table="gsc_dataset_entity"><dataset_entity_obj>3000004908.09</dataset_entity_obj>
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
</contained_record>
<contained_record DB="icfdb" Table="gsc_dataset_entity"><dataset_entity_obj>1004936278.09</dataset_entity_obj>
<deploy_dataset_obj>1004928896.09</deploy_dataset_obj>
<entity_sequence>3</entity_sequence>
<entity_mnemonic>RYCPO</entity_mnemonic>
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
</contained_record>
<contained_record DB="icfdb" Table="gsc_dataset_entity"><dataset_entity_obj>1004928913.09</dataset_entity_obj>
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
</contained_record>
<contained_record DB="icfdb" Table="gsc_dataset_entity"><dataset_entity_obj>1004936275.09</dataset_entity_obj>
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
</contained_record>
<contained_record DB="icfdb" Table="gsc_dataset_entity"><dataset_entity_obj>1004936279.09</dataset_entity_obj>
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
</contained_record>
<contained_record DB="icfdb" Table="gsc_dataset_entity"><dataset_entity_obj>1004936297.09</dataset_entity_obj>
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
</contained_record>
<contained_record DB="icfdb" Table="gsc_dataset_entity"><dataset_entity_obj>1007600052.08</dataset_entity_obj>
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
</contained_record>
<contained_record DB="icfdb" Table="gsc_dataset_entity"><dataset_entity_obj>1007600053.08</dataset_entity_obj>
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
</contained_record>
<contained_record DB="icfdb" Table="gsc_dataset_entity"><dataset_entity_obj>1007600076.08</dataset_entity_obj>
<deploy_dataset_obj>1004928896.09</deploy_dataset_obj>
<entity_sequence>10</entity_sequence>
<entity_mnemonic>RYMWT</entity_mnemonic>
<primary_entity>no</primary_entity>
<join_entity_mnemonic>RYCSO</join_entity_mnemonic>
<join_field_list>object_name,object_filename</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
</contained_record>
<contained_record DB="icfdb" Table="gsc_dataset_entity"><dataset_entity_obj>1007600095.08</dataset_entity_obj>
<deploy_dataset_obj>1004928896.09</deploy_dataset_obj>
<entity_sequence>11</entity_sequence>
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
</contained_record>
<contained_record DB="icfdb" Table="gsc_dataset_entity"><dataset_entity_obj>1007600096.08</dataset_entity_obj>
<deploy_dataset_obj>1004928896.09</deploy_dataset_obj>
<entity_sequence>12</entity_sequence>
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
</contained_record>
<contained_record DB="icfdb" Table="gsc_dataset_entity"><dataset_entity_obj>3000000079.09</dataset_entity_obj>
<deploy_dataset_obj>1004928896.09</deploy_dataset_obj>
<entity_sequence>13</entity_sequence>
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
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="10" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_deploy_dataset"><deploy_dataset_obj>1007600077.08</deploy_dataset_obj>
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
<contained_record DB="icfdb" Table="gsc_dataset_entity"><dataset_entity_obj>1007600078.08</dataset_entity_obj>
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
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="11" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_deploy_dataset" version_date="07/30/2002" version_time="54102" version_user="admin" deletion_flag="no" entity_mnemonic="gscdd" key_field_value="1007600079.08" record_version_obj="3000005371.09" version_number_seq="1.09" secondary_key_value="RYCST" import_version_number_seq="1.09"><deploy_dataset_obj>1007600079.08</deploy_dataset_obj>
<dataset_code>RYCST</dataset_code>
<dataset_description>ryc_smartlink_type - SmartLinks</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<deploy_additions_only>no</deploy_additions_only>
<enable_data_versioning>yes</enable_data_versioning>
<deletion_dataset>yes</deletion_dataset>
<contained_record DB="icfdb" Table="gsc_dataset_entity"><dataset_entity_obj>1007600080.08</dataset_entity_obj>
<deploy_dataset_obj>1007600079.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>RYCST</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>link_name</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="12" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_deploy_dataset"><deploy_dataset_obj>1007600081.08</deploy_dataset_obj>
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
<contained_record DB="icfdb" Table="gsc_dataset_entity"><dataset_entity_obj>1007600082.08</dataset_entity_obj>
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
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="13" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_deploy_dataset"><deploy_dataset_obj>1007600083.08</deploy_dataset_obj>
<dataset_code>RYCAT</dataset_code>
<dataset_description>ryc_attribute - Attribute Dataset</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<deploy_additions_only>no</deploy_additions_only>
<enable_data_versioning>yes</enable_data_versioning>
<deletion_dataset>yes</deletion_dataset>
<contained_record DB="icfdb" Table="gsc_dataset_entity"><dataset_entity_obj>1007600084.08</dataset_entity_obj>
<deploy_dataset_obj>1007600083.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>RYCAT</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>attribute_label</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
</contained_record>
<contained_record DB="icfdb" Table="gsc_dataset_entity"><dataset_entity_obj>1007600085.08</dataset_entity_obj>
<deploy_dataset_obj>1007600083.08</deploy_dataset_obj>
<entity_sequence>2</entity_sequence>
<entity_mnemonic>RYCAP</entity_mnemonic>
<primary_entity>no</primary_entity>
<join_entity_mnemonic>RYCAT</join_entity_mnemonic>
<join_field_list>attribute_group_obj,attribute_group_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="14" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_deploy_dataset"><deploy_dataset_obj>1007600103.08</deploy_dataset_obj>
<dataset_code>GSMLG</dataset_code>
<dataset_description>gsm_login_company - Login Company</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<deploy_additions_only>no</deploy_additions_only>
<enable_data_versioning>yes</enable_data_versioning>
<deletion_dataset>yes</deletion_dataset>
<contained_record DB="icfdb" Table="gsc_dataset_entity"><dataset_entity_obj>1007600104.08</dataset_entity_obj>
<deploy_dataset_obj>1007600103.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSMLG</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>login_company_code</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="15" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_deploy_dataset" version_date="07/30/2002" version_time="54162" version_user="admin" deletion_flag="no" entity_mnemonic="gscdd" key_field_value="1007600105.08" record_version_obj="3000005372.09" version_number_seq="1.09" secondary_key_value="GSCSQ" import_version_number_seq="1.09"><deploy_dataset_obj>1007600105.08</deploy_dataset_obj>
<dataset_code>GSCSQ</dataset_code>
<dataset_description>gsc_sequence - Sequences</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<deploy_additions_only>yes</deploy_additions_only>
<enable_data_versioning>yes</enable_data_versioning>
<deletion_dataset>yes</deletion_dataset>
<contained_record DB="icfdb" Table="gsc_dataset_entity"><dataset_entity_obj>1007600106.08</dataset_entity_obj>
<deploy_dataset_obj>1007600105.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSCSQ</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>sequence_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
</contained_record>
<contained_record DB="icfdb" Table="gsc_dataset_entity"><dataset_entity_obj>1007600107.08</dataset_entity_obj>
<deploy_dataset_obj>1007600105.08</deploy_dataset_obj>
<entity_sequence>2</entity_sequence>
<entity_mnemonic>GSCSN</entity_mnemonic>
<primary_entity>no</primary_entity>
<join_entity_mnemonic>GSCSQ</join_entity_mnemonic>
<join_field_list>sequence_obj,sequence_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="16" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_deploy_dataset"><deploy_dataset_obj>1007600108.08</deploy_dataset_obj>
<dataset_code>GSCGD</dataset_code>
<dataset_description>gsc_global_defaults - Global deflt</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<deploy_additions_only>no</deploy_additions_only>
<enable_data_versioning>yes</enable_data_versioning>
<deletion_dataset>yes</deletion_dataset>
<contained_record DB="icfdb" Table="gsc_dataset_entity"><dataset_entity_obj>1007600110.08</dataset_entity_obj>
<deploy_dataset_obj>1007600108.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSCGD</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>global_default_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="17" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_deploy_dataset"><deploy_dataset_obj>1007600111.08</deploy_dataset_obj>
<dataset_code>GSCGC</dataset_code>
<dataset_description>gsc_global_control - Global Control</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<deploy_additions_only>no</deploy_additions_only>
<enable_data_versioning>yes</enable_data_versioning>
<deletion_dataset>yes</deletion_dataset>
<contained_record DB="icfdb" Table="gsc_dataset_entity"><dataset_entity_obj>1007600112.08</dataset_entity_obj>
<deploy_dataset_obj>1007600111.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSCGC</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>global_control_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="18" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_deploy_dataset"><deploy_dataset_obj>1007600113.08</deploy_dataset_obj>
<dataset_code>GSMCR</dataset_code>
<dataset_description>gsm_currency - Currencies</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<deploy_additions_only>no</deploy_additions_only>
<enable_data_versioning>yes</enable_data_versioning>
<deletion_dataset>yes</deletion_dataset>
<contained_record DB="icfdb" Table="gsc_dataset_entity"><dataset_entity_obj>1007600114.08</dataset_entity_obj>
<deploy_dataset_obj>1007600113.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSMCR</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>currency_code</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="19" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_deploy_dataset"><deploy_dataset_obj>1007600115.08</deploy_dataset_obj>
<dataset_code>GSMCY</dataset_code>
<dataset_description>gsm_country - Countries</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<deploy_additions_only>no</deploy_additions_only>
<enable_data_versioning>yes</enable_data_versioning>
<deletion_dataset>yes</deletion_dataset>
<contained_record DB="icfdb" Table="gsc_dataset_entity"><dataset_entity_obj>1007600116.08</dataset_entity_obj>
<deploy_dataset_obj>1007600115.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSMCY</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>country_code</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="20" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_deploy_dataset"><deploy_dataset_obj>1007600117.08</deploy_dataset_obj>
<dataset_code>GSCNA</dataset_code>
<dataset_description>gsc_nationality - Nationalities</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<deploy_additions_only>no</deploy_additions_only>
<enable_data_versioning>yes</enable_data_versioning>
<deletion_dataset>yes</deletion_dataset>
<contained_record DB="icfdb" Table="gsc_dataset_entity"><dataset_entity_obj>1007600118.08</dataset_entity_obj>
<deploy_dataset_obj>1007600117.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSCNA</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>nationality_code</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="21" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_deploy_dataset" version_date="09/26/2002" version_time="48490" version_user="admin" deletion_flag="no" entity_mnemonic="GSCDD" key_field_value="1007600119.08" record_version_obj="3000031139.09" version_number_seq="1.09" secondary_key_value="GSCLG" import_version_number_seq="1.09"><deploy_dataset_obj>1007600119.08</deploy_dataset_obj>
<dataset_code>GSCLG</dataset_code>
<dataset_description>gsc_language - Languages</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<deploy_additions_only>no</deploy_additions_only>
<enable_data_versioning>yes</enable_data_versioning>
<deletion_dataset>yes</deletion_dataset>
<contained_record DB="icfdb" Table="gsc_dataset_entity"><dataset_entity_obj>1007600120.08</dataset_entity_obj>
<deploy_dataset_obj>1007600119.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSCLG</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>language_code</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
</contained_record>
<contained_record DB="icfdb" Table="gsc_dataset_entity"><dataset_entity_obj>1007600121.08</dataset_entity_obj>
<deploy_dataset_obj>1007600119.08</deploy_dataset_obj>
<entity_sequence>2</entity_sequence>
<entity_mnemonic>GSMTL</entity_mnemonic>
<primary_entity>no</primary_entity>
<join_entity_mnemonic>GSCLG</join_entity_mnemonic>
<join_field_list>language_obj,language_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
</contained_record>
<contained_record DB="icfdb" Table="gsc_dataset_entity"><dataset_entity_obj>1007600122.08</dataset_entity_obj>
<deploy_dataset_obj>1007600119.08</deploy_dataset_obj>
<entity_sequence>3</entity_sequence>
<entity_mnemonic>GSCLT</entity_mnemonic>
<primary_entity>no</primary_entity>
<join_entity_mnemonic>GSCLG</join_entity_mnemonic>
<join_field_list>language_obj,language_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
</contained_record>
<contained_record DB="icfdb" Table="gsc_dataset_entity"><dataset_entity_obj>3000031138.09</dataset_entity_obj>
<deploy_dataset_obj>1007600119.08</deploy_dataset_obj>
<entity_sequence>4</entity_sequence>
<entity_mnemonic>GSMTI</entity_mnemonic>
<primary_entity>no</primary_entity>
<join_entity_mnemonic>GSCLG</join_entity_mnemonic>
<join_field_list>language_obj,language_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="22" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_deploy_dataset"><deploy_dataset_obj>1007600123.08</deploy_dataset_obj>
<dataset_code>GSMUC</dataset_code>
<dataset_description>gsm_user_category</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<deploy_additions_only>no</deploy_additions_only>
<enable_data_versioning>yes</enable_data_versioning>
<deletion_dataset>yes</deletion_dataset>
<contained_record DB="icfdb" Table="gsc_dataset_entity"><dataset_entity_obj>1007600124.08</dataset_entity_obj>
<deploy_dataset_obj>1007600123.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSMUC</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>user_category_code</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="23" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_deploy_dataset"><deploy_dataset_obj>1007600125.08</deploy_dataset_obj>
<dataset_code>GSMUS</dataset_code>
<dataset_description>gsm_user - User Table</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<deploy_additions_only>no</deploy_additions_only>
<enable_data_versioning>yes</enable_data_versioning>
<deletion_dataset>yes</deletion_dataset>
<contained_record DB="icfdb" Table="gsc_dataset_entity"><dataset_entity_obj>1007600126.08</dataset_entity_obj>
<deploy_dataset_obj>1007600125.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSMUS</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>user_login_name</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="24" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_deploy_dataset"><deploy_dataset_obj>1007600127.08</deploy_dataset_obj>
<dataset_code>GSCPF</dataset_code>
<dataset_description>gsc_profile_type - Profile Types</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<deploy_additions_only>no</deploy_additions_only>
<enable_data_versioning>yes</enable_data_versioning>
<deletion_dataset>yes</deletion_dataset>
<contained_record DB="icfdb" Table="gsc_dataset_entity"><dataset_entity_obj>1007600128.08</dataset_entity_obj>
<deploy_dataset_obj>1007600127.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSCPF</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>profile_type_code</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
</contained_record>
<contained_record DB="icfdb" Table="gsc_dataset_entity"><dataset_entity_obj>1007600129.08</dataset_entity_obj>
<deploy_dataset_obj>1007600127.08</deploy_dataset_obj>
<entity_sequence>2</entity_sequence>
<entity_mnemonic>GSCPC</entity_mnemonic>
<primary_entity>no</primary_entity>
<join_entity_mnemonic>GSCPF</join_entity_mnemonic>
<join_field_list>profile_type_obj,profile_type_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="25" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_deploy_dataset"><deploy_dataset_obj>1007600130.08</deploy_dataset_obj>
<dataset_code>GSCMT</dataset_code>
<dataset_description>gsc_manager_type - Manager Types</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<deploy_additions_only>no</deploy_additions_only>
<enable_data_versioning>yes</enable_data_versioning>
<deletion_dataset>yes</deletion_dataset>
<contained_record DB="icfdb" Table="gsc_dataset_entity"><dataset_entity_obj>1007600131.08</dataset_entity_obj>
<deploy_dataset_obj>1007600130.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSCMT</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>manager_type_code</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="26" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_deploy_dataset"><deploy_dataset_obj>1007600132.08</deploy_dataset_obj>
<dataset_code>GSMSE</dataset_code>
<dataset_description>gsm_session_type - Session Types</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<deploy_additions_only>no</deploy_additions_only>
<enable_data_versioning>yes</enable_data_versioning>
<deletion_dataset>yes</deletion_dataset>
<contained_record DB="icfdb" Table="gsc_dataset_entity"><dataset_entity_obj>1007600134.08</dataset_entity_obj>
<deploy_dataset_obj>1007600132.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSMSE</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>session_type_code</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
</contained_record>
<contained_record DB="icfdb" Table="gsc_dataset_entity"><dataset_entity_obj>1007600135.08</dataset_entity_obj>
<deploy_dataset_obj>1007600132.08</deploy_dataset_obj>
<entity_sequence>2</entity_sequence>
<entity_mnemonic>GSMSY</entity_mnemonic>
<primary_entity>no</primary_entity>
<join_entity_mnemonic>GSMSE</join_entity_mnemonic>
<join_field_list>session_type_obj,session_type_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
</contained_record>
<contained_record DB="icfdb" Table="gsc_dataset_entity"><dataset_entity_obj>1007600136.08</dataset_entity_obj>
<deploy_dataset_obj>1007600132.08</deploy_dataset_obj>
<entity_sequence>3</entity_sequence>
<entity_mnemonic>GSMSV</entity_mnemonic>
<primary_entity>no</primary_entity>
<join_entity_mnemonic>GSMSE</join_entity_mnemonic>
<join_field_list>session_type_obj,session_type_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
</contained_record>
<contained_record DB="icfdb" Table="gsc_dataset_entity"><dataset_entity_obj>1007600137.08</dataset_entity_obj>
<deploy_dataset_obj>1007600132.08</deploy_dataset_obj>
<entity_sequence>4</entity_sequence>
<entity_mnemonic>GSMRM</entity_mnemonic>
<primary_entity>no</primary_entity>
<join_entity_mnemonic>GSMSE</join_entity_mnemonic>
<join_field_list>session_type_obj,session_type_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="27" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_deploy_dataset"><deploy_dataset_obj>1007600138.08</deploy_dataset_obj>
<dataset_code>GSCSP</dataset_code>
<dataset_description>gsc_session_property - Session Prop</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<deploy_additions_only>no</deploy_additions_only>
<enable_data_versioning>yes</enable_data_versioning>
<deletion_dataset>yes</deletion_dataset>
<contained_record DB="icfdb" Table="gsc_dataset_entity"><dataset_entity_obj>1007600139.08</dataset_entity_obj>
<deploy_dataset_obj>1007600138.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSCSP</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>session_property_name</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="28" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_deploy_dataset"><deploy_dataset_obj>1007600140.08</deploy_dataset_obj>
<dataset_code>GSCST</dataset_code>
<dataset_description>gsc_service_type - Service Types</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<deploy_additions_only>no</deploy_additions_only>
<enable_data_versioning>yes</enable_data_versioning>
<deletion_dataset>yes</deletion_dataset>
<contained_record DB="icfdb" Table="gsc_dataset_entity"><dataset_entity_obj>1007600141.08</dataset_entity_obj>
<deploy_dataset_obj>1007600140.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSCST</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>service_type_code</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="29" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_deploy_dataset"><deploy_dataset_obj>1007600151.08</deploy_dataset_obj>
<dataset_code>GSCIC</dataset_code>
<dataset_description>gsc_item_category</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<deploy_additions_only>no</deploy_additions_only>
<enable_data_versioning>yes</enable_data_versioning>
<deletion_dataset>yes</deletion_dataset>
<contained_record DB="icfdb" Table="gsc_dataset_entity"><dataset_entity_obj>1007600152.08</dataset_entity_obj>
<deploy_dataset_obj>1007600151.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSCIC</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>item_category_label</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="30" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_deploy_dataset"><deploy_dataset_obj>1007600153.08</deploy_dataset_obj>
<dataset_code>GSMMI</dataset_code>
<dataset_description>gsm_menu_item - Menu Items</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<deploy_additions_only>no</deploy_additions_only>
<enable_data_versioning>yes</enable_data_versioning>
<deletion_dataset>yes</deletion_dataset>
<contained_record DB="icfdb" Table="gsc_dataset_entity"><dataset_entity_obj>1007600154.08</dataset_entity_obj>
<deploy_dataset_obj>1007600153.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSMMI</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>menu_item_reference</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="31" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_deploy_dataset"><deploy_dataset_obj>1007600155.08</deploy_dataset_obj>
<dataset_code>GSMMS</dataset_code>
<dataset_description>gsm_menu_structure - Menu Structure</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<deploy_additions_only>no</deploy_additions_only>
<enable_data_versioning>yes</enable_data_versioning>
<deletion_dataset>yes</deletion_dataset>
<contained_record DB="icfdb" Table="gsc_dataset_entity"><dataset_entity_obj>1007600156.08</dataset_entity_obj>
<deploy_dataset_obj>1007600155.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSMMS</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>menu_structure_code</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
</contained_record>
<contained_record DB="icfdb" Table="gsc_dataset_entity"><dataset_entity_obj>1007600159.08</dataset_entity_obj>
<deploy_dataset_obj>1007600155.08</deploy_dataset_obj>
<entity_sequence>2</entity_sequence>
<entity_mnemonic>GSMIT</entity_mnemonic>
<primary_entity>no</primary_entity>
<join_entity_mnemonic>GSMMS</join_entity_mnemonic>
<join_field_list>menu_structure_obj,menu_structure_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="32" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_deploy_dataset"><deploy_dataset_obj>1007600160.08</deploy_dataset_obj>
<dataset_code>GSMSS</dataset_code>
<dataset_description>gsm_security_structure - Security</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<deploy_additions_only>no</deploy_additions_only>
<enable_data_versioning>yes</enable_data_versioning>
<deletion_dataset>yes</deletion_dataset>
<contained_record DB="icfdb" Table="gsc_dataset_entity"><dataset_entity_obj>1007600161.08</dataset_entity_obj>
<deploy_dataset_obj>1007600160.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSMSS</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>security_structure_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="33" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_deploy_dataset"><deploy_dataset_obj>1007600162.08</deploy_dataset_obj>
<dataset_code>GSCIA</dataset_code>
<dataset_description>gsc_instance_attribute - Inst Attr</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<deploy_additions_only>no</deploy_additions_only>
<enable_data_versioning>yes</enable_data_versioning>
<deletion_dataset>yes</deletion_dataset>
<contained_record DB="icfdb" Table="gsc_dataset_entity"><dataset_entity_obj>1007600163.08</dataset_entity_obj>
<deploy_dataset_obj>1007600162.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSCIA</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>attribute_code</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="34" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_deploy_dataset"><deploy_dataset_obj>1007600164.08</deploy_dataset_obj>
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
<contained_record DB="icfdb" Table="gsc_dataset_entity"><dataset_entity_obj>1007600165.08</dataset_entity_obj>
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
</contained_record>
<contained_record DB="icfdb" Table="gsc_dataset_entity"><dataset_entity_obj>1000000232.39</dataset_entity_obj>
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
</contained_record>
<contained_record DB="icfdb" Table="gsc_dataset_entity"><dataset_entity_obj>3000004910.09</dataset_entity_obj>
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
</contained_record>
<contained_record DB="icfdb" Table="gsc_dataset_entity"><dataset_entity_obj>3000004931.09</dataset_entity_obj>
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
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="35" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_deploy_dataset"><deploy_dataset_obj>1007600166.08</deploy_dataset_obj>
<dataset_code>GSCPR</dataset_code>
<dataset_description>gsc_product - Products and Modules</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<deploy_additions_only>no</deploy_additions_only>
<enable_data_versioning>yes</enable_data_versioning>
<deletion_dataset>yes</deletion_dataset>
<contained_record DB="icfdb" Table="gsc_dataset_entity"><dataset_entity_obj>1007600167.08</dataset_entity_obj>
<deploy_dataset_obj>1007600166.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSCPR</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>product_code</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
</contained_record>
<contained_record DB="icfdb" Table="gsc_dataset_entity"><dataset_entity_obj>1007600168.08</dataset_entity_obj>
<deploy_dataset_obj>1007600166.08</deploy_dataset_obj>
<entity_sequence>2</entity_sequence>
<entity_mnemonic>GSCPM</entity_mnemonic>
<primary_entity>no</primary_entity>
<join_entity_mnemonic>GSCPR</join_entity_mnemonic>
<join_field_list>product_obj,product_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="36" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_deploy_dataset"><deploy_dataset_obj>1007600169.08</deploy_dataset_obj>
<dataset_code>GSCDD</dataset_code>
<dataset_description>gsc_deploy_dataset - Deployment DS</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<deploy_additions_only>no</deploy_additions_only>
<enable_data_versioning>yes</enable_data_versioning>
<deletion_dataset>yes</deletion_dataset>
<contained_record DB="icfdb" Table="gsc_dataset_entity"><dataset_entity_obj>1007600170.08</dataset_entity_obj>
<deploy_dataset_obj>1007600169.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSCDD</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>dataset_code</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
</contained_record>
<contained_record DB="icfdb" Table="gsc_dataset_entity"><dataset_entity_obj>1007600171.08</dataset_entity_obj>
<deploy_dataset_obj>1007600169.08</deploy_dataset_obj>
<entity_sequence>2</entity_sequence>
<entity_mnemonic>GSCDE</entity_mnemonic>
<primary_entity>no</primary_entity>
<join_entity_mnemonic>GSCDD</join_entity_mnemonic>
<join_field_list>deploy_dataset_obj,deploy_dataset_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="37" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_deploy_dataset"><deploy_dataset_obj>1007600172.08</deploy_dataset_obj>
<dataset_code>GSMEX</dataset_code>
<dataset_description>gsm_external_xref - External XRef</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<deploy_additions_only>no</deploy_additions_only>
<enable_data_versioning>yes</enable_data_versioning>
<deletion_dataset>yes</deletion_dataset>
<contained_record DB="icfdb" Table="gsc_dataset_entity"><dataset_entity_obj>1007600173.08</dataset_entity_obj>
<deploy_dataset_obj>1007600172.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSMEX</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>external_xref_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="38" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_deploy_dataset"><deploy_dataset_obj>1007600174.08</deploy_dataset_obj>
<dataset_code>GSCDU</dataset_code>
<dataset_description>gsc_default_set_usage - Dft Set Use</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<deploy_additions_only>no</deploy_additions_only>
<enable_data_versioning>yes</enable_data_versioning>
<deletion_dataset>yes</deletion_dataset>
<contained_record DB="icfdb" Table="gsc_dataset_entity"><dataset_entity_obj>1007600175.08</dataset_entity_obj>
<deploy_dataset_obj>1007600174.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSCDU</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>default_set_usage_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="39" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_deploy_dataset"><deploy_dataset_obj>1007600176.08</deploy_dataset_obj>
<dataset_code>GSCDS</dataset_code>
<dataset_description>gsc_default_set - Default Sets</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<deploy_additions_only>no</deploy_additions_only>
<enable_data_versioning>yes</enable_data_versioning>
<deletion_dataset>yes</deletion_dataset>
<contained_record DB="icfdb" Table="gsc_dataset_entity"><dataset_entity_obj>1007600177.08</dataset_entity_obj>
<deploy_dataset_obj>1007600176.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSCDS</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>default_set_code</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
</contained_record>
<contained_record DB="icfdb" Table="gsc_dataset_entity"><dataset_entity_obj>1007600178.08</dataset_entity_obj>
<deploy_dataset_obj>1007600176.08</deploy_dataset_obj>
<entity_sequence>2</entity_sequence>
<entity_mnemonic>GSCDC</entity_mnemonic>
<primary_entity>no</primary_entity>
<join_entity_mnemonic>GSCDS</join_entity_mnemonic>
<join_field_list>default_set_code,default_set_code</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="40" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_deploy_dataset"><deploy_dataset_obj>1007600179.08</deploy_dataset_obj>
<dataset_code>GSMEF</dataset_code>
<dataset_description>gsm_entity_field - Entity Fields</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<deploy_additions_only>no</deploy_additions_only>
<enable_data_versioning>yes</enable_data_versioning>
<deletion_dataset>yes</deletion_dataset>
<contained_record DB="icfdb" Table="gsc_dataset_entity"><dataset_entity_obj>1007600180.08</dataset_entity_obj>
<deploy_dataset_obj>1007600179.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSMEF</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>entity_field_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
</contained_record>
<contained_record DB="icfdb" Table="gsc_dataset_entity"><dataset_entity_obj>1007600181.08</dataset_entity_obj>
<deploy_dataset_obj>1007600179.08</deploy_dataset_obj>
<entity_sequence>2</entity_sequence>
<entity_mnemonic>GSMEV</entity_mnemonic>
<primary_entity>no</primary_entity>
<join_entity_mnemonic>GSMEF</join_entity_mnemonic>
<join_field_list>entity_field_obj,entity_field_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="41" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_deploy_dataset"><deploy_dataset_obj>1007600182.08</deploy_dataset_obj>
<dataset_code>GSCEP</dataset_code>
<dataset_description>gsc_entity_mnemonic_procedure</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<deploy_additions_only>no</deploy_additions_only>
<enable_data_versioning>yes</enable_data_versioning>
<deletion_dataset>yes</deletion_dataset>
<contained_record DB="icfdb" Table="gsc_dataset_entity"><dataset_entity_obj>1007600183.08</dataset_entity_obj>
<deploy_dataset_obj>1007600182.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSCEP</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>entity_mnemonic_procedure_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="42" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_deploy_dataset"><deploy_dataset_obj>1007600184.08</deploy_dataset_obj>
<dataset_code>GSCCP</dataset_code>
<dataset_description>gsc_custom_procedure</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<deploy_additions_only>no</deploy_additions_only>
<enable_data_versioning>yes</enable_data_versioning>
<deletion_dataset>yes</deletion_dataset>
<contained_record DB="icfdb" Table="gsc_dataset_entity"><dataset_entity_obj>1007600185.08</dataset_entity_obj>
<deploy_dataset_obj>1007600184.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSCCP</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>procedure_name</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="43" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_deploy_dataset"><deploy_dataset_obj>1007600186.08</deploy_dataset_obj>
<dataset_code>GSMCL</dataset_code>
<dataset_description>gsm_control_code</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<deploy_additions_only>no</deploy_additions_only>
<enable_data_versioning>yes</enable_data_versioning>
<deletion_dataset>yes</deletion_dataset>
<contained_record DB="icfdb" Table="gsc_dataset_entity"><dataset_entity_obj>1007600187.08</dataset_entity_obj>
<deploy_dataset_obj>1007600186.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSMCL</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>control_code_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="44" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_deploy_dataset"><deploy_dataset_obj>1007600188.08</deploy_dataset_obj>
<dataset_code>GSMCM</dataset_code>
<dataset_description>gsm_comment - Comments</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<deploy_additions_only>no</deploy_additions_only>
<enable_data_versioning>yes</enable_data_versioning>
<deletion_dataset>yes</deletion_dataset>
<contained_record DB="icfdb" Table="gsc_dataset_entity"><dataset_entity_obj>1007600189.08</dataset_entity_obj>
<deploy_dataset_obj>1007600188.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSMCM</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>comment_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="45" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_deploy_dataset"><deploy_dataset_obj>1007600190.08</deploy_dataset_obj>
<dataset_code>GSMCA</dataset_code>
<dataset_description>gsm_category - Categories</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<deploy_additions_only>no</deploy_additions_only>
<enable_data_versioning>yes</enable_data_versioning>
<deletion_dataset>yes</deletion_dataset>
<contained_record DB="icfdb" Table="gsc_dataset_entity"><dataset_entity_obj>1007600191.08</dataset_entity_obj>
<deploy_dataset_obj>1007600190.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSMCA</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>category_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="46" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_deploy_dataset"><deploy_dataset_obj>1007600192.08</deploy_dataset_obj>
<dataset_code>GSMMM</dataset_code>
<dataset_description>gsm_multi_media - Multi Media</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<deploy_additions_only>no</deploy_additions_only>
<enable_data_versioning>yes</enable_data_versioning>
<deletion_dataset>yes</deletion_dataset>
<contained_record DB="icfdb" Table="gsc_dataset_entity"><dataset_entity_obj>1007600193.08</dataset_entity_obj>
<deploy_dataset_obj>1007600192.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSMMM</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>multi_media_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="47" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_deploy_dataset"><deploy_dataset_obj>1007600194.08</deploy_dataset_obj>
<dataset_code>GSCMM</dataset_code>
<dataset_description>gsc_multi_media_type - Multi Media</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<deploy_additions_only>no</deploy_additions_only>
<enable_data_versioning>yes</enable_data_versioning>
<deletion_dataset>yes</deletion_dataset>
<contained_record DB="icfdb" Table="gsc_dataset_entity"><dataset_entity_obj>1007600195.08</dataset_entity_obj>
<deploy_dataset_obj>1007600194.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSCMM</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>multi_media_type_code</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="48" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_deploy_dataset"><deploy_dataset_obj>1007600196.08</deploy_dataset_obj>
<dataset_code>GSCEM</dataset_code>
<dataset_description>gsc_entity_mnemonic - Entity Mnemon</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<deploy_additions_only>no</deploy_additions_only>
<enable_data_versioning>yes</enable_data_versioning>
<deletion_dataset>yes</deletion_dataset>
<contained_record DB="icfdb" Table="gsc_dataset_entity"><dataset_entity_obj>1007600197.08</dataset_entity_obj>
<deploy_dataset_obj>1007600196.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSCEM</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>entity_mnemonic</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
</contained_record>
<contained_record DB="icfdb" Table="gsc_dataset_entity"><dataset_entity_obj>1007600198.08</dataset_entity_obj>
<deploy_dataset_obj>1007600196.08</deploy_dataset_obj>
<entity_sequence>2</entity_sequence>
<entity_mnemonic>GSCED</entity_mnemonic>
<primary_entity>no</primary_entity>
<join_entity_mnemonic>GSCEM</join_entity_mnemonic>
<join_field_list>entity_mnemonic,entity_mnemonic</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="49" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_deploy_dataset"><deploy_dataset_obj>1007600199.08</deploy_dataset_obj>
<dataset_code>GSMRA</dataset_code>
<dataset_description>gsm_range - Ranges</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<deploy_additions_only>no</deploy_additions_only>
<enable_data_versioning>yes</enable_data_versioning>
<deletion_dataset>yes</deletion_dataset>
<contained_record DB="icfdb" Table="gsc_dataset_entity"><dataset_entity_obj>1007600200.08</dataset_entity_obj>
<deploy_dataset_obj>1007600199.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSMRA</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>range_code</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="50" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_deploy_dataset"><deploy_dataset_obj>1007600201.08</deploy_dataset_obj>
<dataset_code>GSMFF</dataset_code>
<dataset_description>gsm_field - Fields</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<deploy_additions_only>no</deploy_additions_only>
<enable_data_versioning>yes</enable_data_versioning>
<deletion_dataset>yes</deletion_dataset>
<contained_record DB="icfdb" Table="gsc_dataset_entity"><dataset_entity_obj>1007600202.08</dataset_entity_obj>
<deploy_dataset_obj>1007600201.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSMFF</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>field_name</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="51" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_deploy_dataset"><deploy_dataset_obj>1007600203.08</deploy_dataset_obj>
<dataset_code>GSMTO</dataset_code>
<dataset_description>gsm_token - Tokens</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<deploy_additions_only>no</deploy_additions_only>
<enable_data_versioning>yes</enable_data_versioning>
<deletion_dataset>yes</deletion_dataset>
<contained_record DB="icfdb" Table="gsc_dataset_entity"><dataset_entity_obj>1007600204.08</dataset_entity_obj>
<deploy_dataset_obj>1007600203.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSMTO</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>token_code</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="52" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_deploy_dataset"><deploy_dataset_obj>1007600205.08</deploy_dataset_obj>
<dataset_code>GSCSC</dataset_code>
<dataset_description>gsc_security_control - Security Ctr</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<deploy_additions_only>no</deploy_additions_only>
<enable_data_versioning>yes</enable_data_versioning>
<deletion_dataset>yes</deletion_dataset>
<contained_record DB="icfdb" Table="gsc_dataset_entity"><dataset_entity_obj>1007600206.08</dataset_entity_obj>
<deploy_dataset_obj>1007600205.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSCSC</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>security_control_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="53" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_deploy_dataset"><deploy_dataset_obj>1007600209.08</deploy_dataset_obj>
<dataset_code>GSMST</dataset_code>
<dataset_description>gsm_status</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<deploy_additions_only>no</deploy_additions_only>
<enable_data_versioning>yes</enable_data_versioning>
<deletion_dataset>yes</deletion_dataset>
<contained_record DB="icfdb" Table="gsc_dataset_entity"><dataset_entity_obj>1007600210.08</dataset_entity_obj>
<deploy_dataset_obj>1007600209.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSMST</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>status_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
</contained_record>
<contained_record DB="icfdb" Table="gsc_dataset_entity"><dataset_entity_obj>1007600211.08</dataset_entity_obj>
<deploy_dataset_obj>1007600209.08</deploy_dataset_obj>
<entity_sequence>2</entity_sequence>
<entity_mnemonic>GSMSH</entity_mnemonic>
<primary_entity>no</primary_entity>
<join_entity_mnemonic>GSMST</join_entity_mnemonic>
<join_field_list>status_obj,status_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="54" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_deploy_dataset"><deploy_dataset_obj>1007600212.08</deploy_dataset_obj>
<dataset_code>GSMHE</dataset_code>
<dataset_description>gsm_help - Help</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<deploy_additions_only>no</deploy_additions_only>
<enable_data_versioning>yes</enable_data_versioning>
<deletion_dataset>yes</deletion_dataset>
<contained_record DB="icfdb" Table="gsc_dataset_entity"><dataset_entity_obj>1007600213.08</dataset_entity_obj>
<deploy_dataset_obj>1007600212.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSMHE</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>help_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="55" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_deploy_dataset"><deploy_dataset_obj>1007600214.08</deploy_dataset_obj>
<dataset_code>GSCER</dataset_code>
<dataset_description>gsc_error - Errors</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<deploy_additions_only>no</deploy_additions_only>
<enable_data_versioning>yes</enable_data_versioning>
<deletion_dataset>yes</deletion_dataset>
<contained_record DB="icfdb" Table="gsc_dataset_entity"><dataset_entity_obj>1007600215.08</dataset_entity_obj>
<deploy_dataset_obj>1007600214.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSCER</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>error_group,error_number</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="56" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_deploy_dataset"><deploy_dataset_obj>3000000374.09</deploy_dataset_obj>
<dataset_code>RYCAP</dataset_code>
<dataset_description>ryc_attribute_group - Attribute groups in isolation</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename>rycap.ado</default_ado_filename>
<deploy_additions_only>no</deploy_additions_only>
<enable_data_versioning>yes</enable_data_versioning>
<deletion_dataset>yes</deletion_dataset>
<contained_record DB="icfdb" Table="gsc_dataset_entity"><dataset_entity_obj>3000002001.09</dataset_entity_obj>
<deploy_dataset_obj>3000000374.09</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>RYCAP</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>attribute_group_name</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="57" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_deploy_dataset" version_date="06/27/2002" version_time="25339" version_user="admin" deletion_flag="no" entity_mnemonic="gscdd" key_field_value="3000004885.09" record_version_obj="3000004886.09" version_number_seq="2.09" secondary_key_value="RYCCY" import_version_number_seq="2.09"><deploy_dataset_obj>3000004885.09</deploy_dataset_obj>
<dataset_code>RYCCY</dataset_code>
<dataset_description>ryc_customization</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename>ryccy.ado</default_ado_filename>
<deploy_additions_only>no</deploy_additions_only>
<enable_data_versioning>yes</enable_data_versioning>
<deletion_dataset>yes</deletion_dataset>
<contained_record DB="icfdb" Table="gsc_dataset_entity"><dataset_entity_obj>3000004887.09</dataset_entity_obj>
<deploy_dataset_obj>3000004885.09</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>RYCCY</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>customization_type_code</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
</contained_record>
<contained_record DB="icfdb" Table="gsc_dataset_entity"><dataset_entity_obj>3000004889.09</dataset_entity_obj>
<deploy_dataset_obj>3000004885.09</deploy_dataset_obj>
<entity_sequence>2</entity_sequence>
<entity_mnemonic>RYCCR</entity_mnemonic>
<primary_entity>no</primary_entity>
<join_entity_mnemonic>RYCCY</join_entity_mnemonic>
<join_field_list>customization_type_obj,customization_type_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="58" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_deploy_dataset" version_date="07/30/2002" version_time="54113" version_user="admin" deletion_flag="no" entity_mnemonic="gscdd" key_field_value="3000004891.09" record_version_obj="3000004892.09" version_number_seq="3.09" secondary_key_value="RYMCZ" import_version_number_seq="3.09"><deploy_dataset_obj>3000004891.09</deploy_dataset_obj>
<dataset_code>RYMCZ</dataset_code>
<dataset_description>rym_customization (whole set)</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename>rymcz.ado</default_ado_filename>
<deploy_additions_only>no</deploy_additions_only>
<enable_data_versioning>yes</enable_data_versioning>
<deletion_dataset>yes</deletion_dataset>
<contained_record DB="icfdb" Table="gsc_dataset_entity"><dataset_entity_obj>3000004893.09</dataset_entity_obj>
<deploy_dataset_obj>3000004891.09</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>RYCCY</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>customization_type_code</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
</contained_record>
<contained_record DB="icfdb" Table="gsc_dataset_entity"><dataset_entity_obj>3000004895.09</dataset_entity_obj>
<deploy_dataset_obj>3000004891.09</deploy_dataset_obj>
<entity_sequence>2</entity_sequence>
<entity_mnemonic>RYCCR</entity_mnemonic>
<primary_entity>no</primary_entity>
<join_entity_mnemonic>RYCCY</join_entity_mnemonic>
<join_field_list>customization_type_obj,customization_type_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
</contained_record>
<contained_record DB="icfdb" Table="gsc_dataset_entity"><dataset_entity_obj>3000004897.09</dataset_entity_obj>
<deploy_dataset_obj>3000004891.09</deploy_dataset_obj>
<entity_sequence>3</entity_sequence>
<entity_mnemonic>RYMCZ</entity_mnemonic>
<primary_entity>no</primary_entity>
<join_entity_mnemonic>RYCCR</join_entity_mnemonic>
<join_field_list>customization_result_obj,customization_result_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="59" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_deploy_dataset"><deploy_dataset_obj>3000005364.09</deploy_dataset_obj>
<dataset_code>GSCLS</dataset_code>
<dataset_description>gsc_logical_service - Logical Services</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename>gscls.ado</default_ado_filename>
<deploy_additions_only>no</deploy_additions_only>
<enable_data_versioning>yes</enable_data_versioning>
<deletion_dataset>yes</deletion_dataset>
<contained_record DB="icfdb" Table="gsc_dataset_entity"><dataset_entity_obj>3000005365.09</dataset_entity_obj>
<deploy_dataset_obj>3000005364.09</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSCLS</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>logical_service_code</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="60" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_deploy_dataset"><deploy_dataset_obj>3000005366.09</deploy_dataset_obj>
<dataset_code>GSMPY</dataset_code>
<dataset_description>gsm_physical_service - Physical Services</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename>gsmpy.ado</default_ado_filename>
<deploy_additions_only>no</deploy_additions_only>
<enable_data_versioning>yes</enable_data_versioning>
<deletion_dataset>yes</deletion_dataset>
<contained_record DB="icfdb" Table="gsc_dataset_entity"><dataset_entity_obj>3000005367.09</dataset_entity_obj>
<deploy_dataset_obj>3000005366.09</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSMPY</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>physical_service_code</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
</contained_record>
</contained_record>
</dataset_transaction>
</dataset_records>
</dataset>