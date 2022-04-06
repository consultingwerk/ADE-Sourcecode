<?xml version="1.0" encoding="utf-8" ?>
<dataset Transactions="4"><dataset_header DisableRI="yes" DatasetObj="1007600209.08" DateFormat="mdy" FullHeader="no" SCMManaged="no" YearOffset="1950" DatasetCode="GSMST" NumericFormat="AMERICAN" NumericDecimal="." OriginatingSite="91" NumericSeparator=","/>
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