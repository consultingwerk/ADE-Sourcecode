<?xml version="1.0" encoding="utf-8" ?>
<dataset Transactions="2"><dataset_header DisableRI="yes" DatasetObj="1007600125.08" DateFormat="mdy" FullHeader="yes" SCMManaged="no" YearOffset="1950" DatasetCode="GSMUS" NumericFormat="AMERICAN" NumericDecimal="." OriginatingSite="90" NumericSeparator=","><deploy_dataset_obj>1007600125.08</deploy_dataset_obj>
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
<dataset_entity><dataset_entity_obj>1007600126.08</dataset_entity_obj>
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
<entity_mnemonic_description>gsm_user</entity_mnemonic_description>
<entity_dbname>ICFDB</entity_dbname>
</dataset_entity>
<table_definition><name>gsm_user</name>
<dbname>icfdb</dbname>
<index-1>XAK2gsm_user,1,0,0,user_login_name,0</index-1>
<index-2>XIE1gsm_user,0,0,0,user_full_name,0</index-2>
<index-3>XIE2gsm_user,0,0,0,profile_user,0,user_full_name,0</index-3>
<index-4>XIE3gsm_user,0,0,0,external_userid,0</index-4>
<index-5>XIE4gsm_user,0,0,0,user_password,0</index-5>
<index-6>XIE6gsm_user,0,0,0,default_login_company_obj,0</index-6>
<index-7>XIE7gsm_user,0,0,0,user_category_obj,0</index-7>
<index-8>XIE8gsm_user,0,0,0,created_from_profile_user_obj,0</index-8>
<index-9>XIE9gsm_user,0,0,0,language_obj,0</index-9>
<index-10>XPKgsm_user,1,1,0,user_obj,0</index-10>
<field><name>user_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>User Obj</label>
<column-label>User Obj</column-label>
</field>
<field><name>user_category_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>User Category Obj</label>
<column-label>User Category Obj</column-label>
</field>
<field><name>user_full_name</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>User Full Name</label>
<column-label>User Full Name</column-label>
</field>
<field><name>user_login_name</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(15)</format>
<initial></initial>
<label>User Login Name</label>
<column-label>User Login Name</column-label>
</field>
<field><name>user_creation_date</name>
<data-type>date</data-type>
<extent>0</extent>
<format>99/99/9999</format>
<initial>04/02/2003</initial>
<label>User Creation Date</label>
<column-label>User Creation Date</column-label>
</field>
<field><name>user_creation_time</name>
<data-type>integer</data-type>
<extent>0</extent>
<format>&gt;&gt;&gt;&gt;9</format>
<initial>    0</initial>
<label>User Creation Time</label>
<column-label>User Creation Time</column-label>
</field>
<field><name>profile_user</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>Profile User</label>
<column-label>Profile User</column-label>
</field>
<field><name>created_from_profile_user_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Created From Profile User Obj</label>
<column-label>Created From Profile User Obj</column-label>
</field>
<field><name>external_userid</name>
<data-type>integer</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;9</format>
<initial>        0</initial>
<label>External Userid</label>
<column-label>External Userid</column-label>
</field>
<field><name>user_password</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>User Password</label>
<column-label>User Password</column-label>
</field>
<field><name>password_minimum_length</name>
<data-type>integer</data-type>
<extent>0</extent>
<format>-&gt;9</format>
<initial>  0</initial>
<label>Password Minimum Length</label>
<column-label>Password Minimum Length</column-label>
</field>
<field><name>password_preexpired</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>Password Preexpired</label>
<column-label>Password Preexpired</column-label>
</field>
<field><name>password_fail_count</name>
<data-type>integer</data-type>
<extent>0</extent>
<format>-&gt;&gt;9</format>
<initial>   0</initial>
<label>Password Fail Count</label>
<column-label>Password Fail Count</column-label>
</field>
<field><name>password_fail_date</name>
<data-type>date</data-type>
<extent>0</extent>
<format>99/99/9999</format>
<initial></initial>
<label>Password Fail Date</label>
<column-label>Password Fail Date</column-label>
</field>
<field><name>password_fail_time</name>
<data-type>integer</data-type>
<extent>0</extent>
<format>&gt;&gt;&gt;&gt;9</format>
<initial>    0</initial>
<label>Password Fail Time</label>
<column-label>Password Fail Time</column-label>
</field>
<field><name>password_creation_date</name>
<data-type>date</data-type>
<extent>0</extent>
<format>99/99/9999</format>
<initial></initial>
<label>Password Creation Date</label>
<column-label>Password Creation Date</column-label>
</field>
<field><name>password_creation_time</name>
<data-type>integer</data-type>
<extent>0</extent>
<format>&gt;&gt;&gt;&gt;9</format>
<initial>    0</initial>
<label>Password Creation Time</label>
<column-label>Password Creation Time</column-label>
</field>
<field><name>password_expiry_date</name>
<data-type>date</data-type>
<extent>0</extent>
<format>99/99/9999</format>
<initial></initial>
<label>Password Expiry Date</label>
<column-label>Password Expiry Date</column-label>
</field>
<field><name>password_expiry_time</name>
<data-type>integer</data-type>
<extent>0</extent>
<format>&gt;&gt;&gt;&gt;9</format>
<initial>    0</initial>
<label>Password Expiry Time</label>
<column-label>Password Expiry Time</column-label>
</field>
<field><name>update_password_history</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>Update Password History</label>
<column-label>Update Password History</column-label>
</field>
<field><name>check_password_history</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>Check Password History</label>
<column-label>Check Password History</column-label>
</field>
<field><name>last_login_date</name>
<data-type>date</data-type>
<extent>0</extent>
<format>99/99/9999</format>
<initial></initial>
<label>Last Login Date</label>
<column-label>Last Login Date</column-label>
</field>
<field><name>last_login_time</name>
<data-type>integer</data-type>
<extent>0</extent>
<format>&gt;&gt;&gt;&gt;9</format>
<initial>    0</initial>
<label>Last Login Time</label>
<column-label>Last Login Time</column-label>
</field>
<field><name>disabled</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>Disabled</label>
<column-label>Disabled</column-label>
</field>
<field><name>language_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Language Obj</label>
<column-label>Language Obj</column-label>
</field>
<field><name>password_expiry_days</name>
<data-type>integer</data-type>
<extent>0</extent>
<format>-&gt;&gt;9</format>
<initial>   0</initial>
<label>Password Expiry Days</label>
<column-label>Password Expiry Days</column-label>
</field>
<field><name>maintain_system_data</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>Maintain System Data</label>
<column-label>Maintain System Data</column-label>
</field>
<field><name>default_login_company_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Default Login Company Obj</label>
<column-label>Default Login Company Obj</column-label>
</field>
<field><name>user_email_address</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>User Email Address</label>
<column-label>User Email Address</column-label>
</field>
<field><name>development_user</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>Development User</label>
<column-label>Development User</column-label>
</field>
</table_definition>
</dataset_header>
<dataset_records><dataset_transaction TransactionNo="1" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_user"><user_obj>22042</user_obj>
<user_category_obj>926</user_category_obj>
<user_full_name>Admin User</user_full_name>
<user_login_name>admin</user_login_name>
<user_creation_date>07/19/99</user_creation_date>
<user_creation_time>58713</user_creation_time>
<profile_user>yes</profile_user>
<created_from_profile_user_obj>0</created_from_profile_user_obj>
<external_userid>0</external_userid>
<user_password></user_password>
<password_minimum_length>0</password_minimum_length>
<password_preexpired>no</password_preexpired>
<password_fail_count>0</password_fail_count>
<password_fail_date>?</password_fail_date>
<password_fail_time>0</password_fail_time>
<password_creation_date>04/18/01</password_creation_date>
<password_creation_time>56716</password_creation_time>
<password_expiry_date>?</password_expiry_date>
<password_expiry_time>0</password_expiry_time>
<update_password_history>no</update_password_history>
<check_password_history>no</check_password_history>
<last_login_date>04/02/03</last_login_date>
<last_login_time>45929</last_login_time>
<disabled>no</disabled>
<language_obj>426</language_obj>
<password_expiry_days>0</password_expiry_days>
<maintain_system_data>yes</maintain_system_data>
<default_login_company_obj>1008000220.09</default_login_company_obj>
<user_email_address></user_email_address>
<development_user>yes</development_user>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="2" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_user"><user_obj>3000004934.09</user_obj>
<user_category_obj>1004834867.09</user_category_obj>
<user_full_name>anonymous</user_full_name>
<user_login_name>anonymous</user_login_name>
<user_creation_date>07/02/02</user_creation_date>
<user_creation_time>28476</user_creation_time>
<profile_user>no</profile_user>
<created_from_profile_user_obj>0</created_from_profile_user_obj>
<external_userid>0</external_userid>
<user_password></user_password>
<password_minimum_length>0</password_minimum_length>
<password_preexpired>no</password_preexpired>
<password_fail_count>0</password_fail_count>
<password_fail_date>?</password_fail_date>
<password_fail_time>0</password_fail_time>
<password_creation_date>07/02/02</password_creation_date>
<password_creation_time>28476</password_creation_time>
<password_expiry_date>?</password_expiry_date>
<password_expiry_time>0</password_expiry_time>
<update_password_history>no</update_password_history>
<check_password_history>no</check_password_history>
<last_login_date>?</last_login_date>
<last_login_time>0</last_login_time>
<disabled>yes</disabled>
<language_obj>0</language_obj>
<password_expiry_days>0</password_expiry_days>
<maintain_system_data>no</maintain_system_data>
<default_login_company_obj>0</default_login_company_obj>
<user_email_address></user_email_address>
<development_user>no</development_user>
</contained_record>
</dataset_transaction>
</dataset_records>
</dataset>