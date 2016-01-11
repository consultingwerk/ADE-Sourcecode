<?xml version="1.0" encoding="utf-8" ?>
<dataset Transactions="4"><dataset_header DisableRI="yes" DatasetObj="1007600209.08" DateFormat="mdy" FullHeader="yes" SCMManaged="no" YearOffset="1950" DatasetCode="GSMST" NumericFormat="AMERICAN" NumericDecimal="." OriginatingSite="90" NumericSeparator=","><deploy_dataset_obj>1007600209.08</deploy_dataset_obj>
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
<dataset_entity><dataset_entity_obj>1007600210.08</dataset_entity_obj>
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
<exclude_field_list></exclude_field_list>
<entity_mnemonic_description>gsm_status</entity_mnemonic_description>
<entity_dbname>ICFDB</entity_dbname>
</dataset_entity>
<dataset_entity><dataset_entity_obj>1007600211.08</dataset_entity_obj>
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
<exclude_field_list></exclude_field_list>
<entity_mnemonic_description>gsm_status_history</entity_mnemonic_description>
<entity_dbname>ICFDB</entity_dbname>
</dataset_entity>
<table_definition><name>gsm_status</name>
<dbname>icfdb</dbname>
<index-1>XAK1gsm_status,1,0,0,category_obj,0,status_seq,0</index-1>
<index-2>XAK2gsm_status,1,0,0,category_obj,0,status_tla,0</index-2>
<index-3>XIE1gsm_status,0,0,0,category_obj,0,status_description,0</index-3>
<index-4>XIE2gsm_status,0,0,0,category_obj,0,status_short_desc,0</index-4>
<index-5>XPKgsm_status,1,1,0,status_obj,0</index-5>
<field><name>status_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Status obj</label>
<column-label>Status obj</column-label>
</field>
<field><name>category_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Category obj</label>
<column-label>Category obj</column-label>
</field>
<field><name>status_seq</name>
<data-type>integer</data-type>
<extent>0</extent>
<format>-&gt;&gt;9</format>
<initial>   0</initial>
<label>Status seq</label>
<column-label>Status seq</column-label>
</field>
<field><name>status_tla</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(3)</format>
<initial></initial>
<label>Status TLA</label>
<column-label>Status TLA</column-label>
</field>
<field><name>status_short_desc</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(15)</format>
<initial></initial>
<label>Status short desc.</label>
<column-label>Status short desc.</column-label>
</field>
<field><name>status_description</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>Status description</label>
<column-label>Status description</column-label>
</field>
<field><name>retain_status_history</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>Retain status history</label>
<column-label>Retain status history</column-label>
</field>
<field><name>system_owned</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>System owned</label>
<column-label>System owned</column-label>
</field>
<field><name>auto_display</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>Auto display</label>
<column-label>Auto display</column-label>
</field>
</table_definition>
<table_definition><name>gsm_status_history</name>
<dbname>icfdb</dbname>
<index-1>XAK1gsm_status_history,1,0,0,status_obj,0,owning_obj,0,from_date,0</index-1>
<index-2>XAK2gsm_status_history,1,0,0,status_history_obj,0</index-2>
<index-3>XIE1gsm_status_history,0,0,0,owning_obj,0,from_date,0</index-3>
<index-4>XPKgsm_status_history,1,1,0,owning_obj,0,from_date,0,status_obj,0</index-4>
<field><name>owning_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Owning obj</label>
<column-label>Owning obj</column-label>
</field>
<field><name>from_date</name>
<data-type>date</data-type>
<extent>0</extent>
<format>99/99/9999</format>
<initial></initial>
<label>From date</label>
<column-label>From date</column-label>
</field>
<field><name>status_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Status obj</label>
<column-label>Status obj</column-label>
</field>
<field><name>to_date</name>
<data-type>date</data-type>
<extent>0</extent>
<format>99/99/9999</format>
<initial></initial>
<label>To date</label>
<column-label>To date</column-label>
</field>
<field><name>status_history_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Status history obj</label>
<column-label>Status history obj</column-label>
</field>
</table_definition>
</dataset_header>
<dataset_records><dataset_transaction TransactionNo="1" TransactionType="DELETION"><contained_record version_date="03/21/2003" version_time="51311" version_user="admin" deletion_flag="yes" entity_mnemonic="gsmst" key_field_value="2124893" record_version_obj="3000044737.09" version_number_seq="1.09" secondary_key_value="2122116#CHR(1)#ANT" import_version_number_seq="1.09"/>
</dataset_transaction>
<dataset_transaction TransactionNo="2" TransactionType="DELETION"><contained_record version_date="03/21/2003" version_time="51313" version_user="admin" deletion_flag="yes" entity_mnemonic="gsmst" key_field_value="2292439" record_version_obj="3000044738.09" version_number_seq="1.09" secondary_key_value="2292438#CHR(1)#HLD" import_version_number_seq="1.09"/>
</dataset_transaction>
<dataset_transaction TransactionNo="3" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_status" version_date="10/02/2003" version_time="49463" version_user="admin" deletion_flag="no" entity_mnemonic="GSMST" key_field_value="2122131" record_version_obj="3000058722.09" version_number_seq="1.09" secondary_key_value="2122116#CHR(1)#HST" import_version_number_seq="1.09"><status_obj>2122131</status_obj>
<category_obj>2122116</category_obj>
<status_seq>1</status_seq>
<status_tla>HST</status_tla>
<status_short_desc>New Status hist</status_short_desc>
<status_description>New Status history flag</status_description>
<retain_status_history>yes</retain_status_history>
<system_owned>no</system_owned>
<auto_display>no</auto_display>
<contained_record DB="icfdb" Table="gsm_status_history"><owning_obj>249</owning_obj>
<from_date>06/20/00</from_date>
<status_obj>2122131</status_obj>
<to_date>?</to_date>
<status_history_obj>1003548059</status_history_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="4" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_status" version_date="10/02/2003" version_time="49463" version_user="admin" deletion_flag="no" entity_mnemonic="GSMST" key_field_value="2292399" record_version_obj="3000058723.09" version_number_seq="1.09" secondary_key_value="2122116#CHR(1)#HLD" import_version_number_seq="1.09"><status_obj>2292399</status_obj>
<category_obj>2122116</category_obj>
<status_seq>0</status_seq>
<status_tla>HLD</status_tla>
<status_short_desc>Hold Batch/Tran</status_short_desc>
<status_description>Hold Batch/Transaction</status_description>
<retain_status_history>yes</retain_status_history>
<system_owned>no</system_owned>
<auto_display>no</auto_display>
<contained_record DB="icfdb" Table="gsm_status_history"><owning_obj>250140</owning_obj>
<from_date>06/27/00</from_date>
<status_obj>2292399</status_obj>
<to_date>?</to_date>
<status_history_obj>1003581391</status_history_obj>
</contained_record>
</contained_record>
</dataset_transaction>
</dataset_records>
</dataset>