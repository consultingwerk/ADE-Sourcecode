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
<exclude_field_list></exclude_field_list>
<entity_mnemonic_description>gsm_user</entity_mnemonic_description>
<entity_dbname>ICFDB</entity_dbname>
</dataset_entity>
<dataset_entity><dataset_entity_obj>500378.24</dataset_entity_obj>
<deploy_dataset_obj>1007600125.08</deploy_dataset_obj>
<entity_sequence>2</entity_sequence>
<entity_mnemonic>GSMGA</entity_mnemonic>
<primary_entity>no</primary_entity>
<join_entity_mnemonic>GSMUS</join_entity_mnemonic>
<join_field_list>user_obj,user_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
<exclude_field_list></exclude_field_list>
<entity_mnemonic_description>gsm_group_allocation</entity_mnemonic_description>
<entity_dbname>ICFDB</entity_dbname>
</dataset_entity>
<dataset_entity><dataset_entity_obj>964088.24</dataset_entity_obj>
<deploy_dataset_obj>1007600125.08</deploy_dataset_obj>
<entity_sequence>3</entity_sequence>
<entity_mnemonic>GSMUL</entity_mnemonic>
<primary_entity>no</primary_entity>
<join_entity_mnemonic>GSMUS</join_entity_mnemonic>
<join_field_list>user_obj,user_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
<exclude_field_list></exclude_field_list>
<entity_mnemonic_description>gsm_user_allocation</entity_mnemonic_description>
<entity_dbname>ICFDB</entity_dbname>
</dataset_entity>
<table_definition><name>gsm_user</name>
<dbname>icfdb</dbname>
<index-1>XAK2gsm_user,1,0,0,user_login_name,0</index-1>
<index-2>XIE10gsm_user,0,0,0,security_group,0</index-2>
<index-3>XIE1gsm_user,0,0,0,user_full_name,0</index-3>
<index-4>XIE2gsm_user,0,0,0,profile_user,0,user_full_name,0</index-4>
<index-5>XIE3gsm_user,0,0,0,external_userid,0</index-5>
<index-6>XIE4gsm_user,0,0,0,user_password,0</index-6>
<index-7>XIE6gsm_user,0,0,0,default_login_company_obj,0</index-7>
<index-8>XIE7gsm_user,0,0,0,user_category_obj,0</index-8>
<index-9>XIE8gsm_user,0,0,0,created_from_profile_user_obj,0</index-9>
<index-10>XIE9gsm_user,0,0,0,language_obj,0</index-10>
<index-11>XPKgsm_user,1,1,0,user_obj,0</index-11>
<field><name>user_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>User obj</label>
<column-label>User obj</column-label>
</field>
<field><name>user_category_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>User category obj</label>
<column-label>User category obj</column-label>
</field>
<field><name>user_full_name</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>User full name</label>
<column-label>User full name</column-label>
</field>
<field><name>user_login_name</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(15)</format>
<initial></initial>
<label>User login name</label>
<column-label>User login name</column-label>
</field>
<field><name>user_creation_date</name>
<data-type>date</data-type>
<extent>0</extent>
<format>99/99/9999</format>
<initial>10/21/2003</initial>
<label>User creation date</label>
<column-label>User creation date</column-label>
</field>
<field><name>user_creation_time</name>
<data-type>integer</data-type>
<extent>0</extent>
<format>&gt;&gt;&gt;&gt;9</format>
<initial>    0</initial>
<label>User creation time</label>
<column-label>User creation time</column-label>
</field>
<field><name>profile_user</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>Profile user</label>
<column-label>Profile user</column-label>
</field>
<field><name>created_from_profile_user_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Created from profile user obj</label>
<column-label>Created from profile user obj</column-label>
</field>
<field><name>external_userid</name>
<data-type>integer</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;9</format>
<initial>        0</initial>
<label>External userid</label>
<column-label>External userid</column-label>
</field>
<field><name>user_password</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>User password</label>
<column-label>User password</column-label>
</field>
<field><name>password_minimum_length</name>
<data-type>integer</data-type>
<extent>0</extent>
<format>-&gt;9</format>
<initial>  0</initial>
<label>Password minimum length</label>
<column-label>Password minimum length</column-label>
</field>
<field><name>password_preexpired</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>Password preexpired</label>
<column-label>Password preexpired</column-label>
</field>
<field><name>password_fail_count</name>
<data-type>integer</data-type>
<extent>0</extent>
<format>-&gt;&gt;9</format>
<initial>   0</initial>
<label>Password fail count</label>
<column-label>Password fail count</column-label>
</field>
<field><name>password_fail_date</name>
<data-type>date</data-type>
<extent>0</extent>
<format>99/99/9999</format>
<initial></initial>
<label>Password fail date</label>
<column-label>Password fail date</column-label>
</field>
<field><name>password_fail_time</name>
<data-type>integer</data-type>
<extent>0</extent>
<format>&gt;&gt;&gt;&gt;9</format>
<initial>    0</initial>
<label>Password fail time</label>
<column-label>Password fail time</column-label>
</field>
<field><name>password_creation_date</name>
<data-type>date</data-type>
<extent>0</extent>
<format>99/99/9999</format>
<initial></initial>
<label>Password creation date</label>
<column-label>Password creation date</column-label>
</field>
<field><name>password_creation_time</name>
<data-type>integer</data-type>
<extent>0</extent>
<format>&gt;&gt;&gt;&gt;9</format>
<initial>    0</initial>
<label>Password creation time</label>
<column-label>Password creation time</column-label>
</field>
<field><name>password_expiry_date</name>
<data-type>date</data-type>
<extent>0</extent>
<format>99/99/9999</format>
<initial></initial>
<label>Password expiry date</label>
<column-label>Password expiry date</column-label>
</field>
<field><name>password_expiry_time</name>
<data-type>integer</data-type>
<extent>0</extent>
<format>&gt;&gt;&gt;&gt;9</format>
<initial>    0</initial>
<label>Password expiry time</label>
<column-label>Password expiry time</column-label>
</field>
<field><name>update_password_history</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>Update password history</label>
<column-label>Update password history</column-label>
</field>
<field><name>check_password_history</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>Check password history</label>
<column-label>Check password history</column-label>
</field>
<field><name>last_login_date</name>
<data-type>date</data-type>
<extent>0</extent>
<format>99/99/9999</format>
<initial></initial>
<label>Last login date</label>
<column-label>Last login date</column-label>
</field>
<field><name>last_login_time</name>
<data-type>integer</data-type>
<extent>0</extent>
<format>&gt;&gt;&gt;&gt;9</format>
<initial>    0</initial>
<label>Last login time</label>
<column-label>Last login time</column-label>
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
<label>Language obj</label>
<column-label>Language obj</column-label>
</field>
<field><name>password_expiry_days</name>
<data-type>integer</data-type>
<extent>0</extent>
<format>-&gt;&gt;9</format>
<initial>   0</initial>
<label>Password expiry days</label>
<column-label>Password expiry days</column-label>
</field>
<field><name>maintain_system_data</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>Maintain system data</label>
<column-label>Maintain system data</column-label>
</field>
<field><name>default_login_company_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Default login company obj</label>
<column-label>Default login company obj</column-label>
</field>
<field><name>user_email_address</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>User email address</label>
<column-label>User email address</column-label>
</field>
<field><name>development_user</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>Development user</label>
<column-label>Development user</column-label>
</field>
<field><name>security_group</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>Security group</label>
<column-label>Security group</column-label>
</field>
<field><name>default_security_group</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>Default security group</label>
<column-label>Default security group</column-label>
</field>
</table_definition>
<table_definition><name>gsm_group_allocation</name>
<dbname>icfdb</dbname>
<index-1>XAK1gsm_group_allocation,1,0,0,group_user_obj,0,user_obj,0,login_company_obj,0</index-1>
<index-2>XIE1gsm_group_allocation,0,0,0,user_obj,0</index-2>
<index-3>XIE2gsm_group_allocation,0,0,0,login_company_obj,0</index-3>
<index-4>XPKgsm_group_allocation,1,1,0,group_allocation_obj,0</index-4>
<field><name>group_allocation_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Group allocation obj</label>
<column-label>Group allocation obj</column-label>
</field>
<field><name>group_user_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Group user obj</label>
<column-label>Group user obj</column-label>
</field>
<field><name>user_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>User obj</label>
<column-label>User obj</column-label>
</field>
<field><name>login_company_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Login company obj</label>
<column-label>Login company obj</column-label>
</field>
</table_definition>
<table_definition><name>gsm_user_allocation</name>
<dbname>icfdb</dbname>
<index-1>XAK1gsm_user_allocation,1,0,0,user_allocation_obj,0</index-1>
<index-2>XIE1gsm_user_allocation,0,0,0,login_organisation_obj,0,user_obj,0,owning_entity_mnemonic,0,owning_obj,0</index-2>
<index-3>XIE2gsm_user_allocation,0,0,0,owning_entity_mnemonic,0,owning_obj,0,user_obj,0,login_organisation_obj,0</index-3>
<index-4>XIE3gsm_user_allocation,0,0,0,owning_entity_mnemonic,0,owning_obj,0,login_organisation_obj,0,user_obj,0</index-4>
<index-5>XIE4gsm_user_allocation,0,0,0,owning_obj,0</index-5>
<index-6>XPKgsm_user_allocation,1,1,0,user_obj,0,login_organisation_obj,0,owning_entity_mnemonic,0,owning_obj,0</index-6>
<field><name>user_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>User obj</label>
<column-label>User obj</column-label>
</field>
<field><name>login_organisation_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Login organisation obj</label>
<column-label>Login organisation obj</column-label>
</field>
<field><name>owning_entity_mnemonic</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(8)</format>
<initial></initial>
<label>Owning entity</label>
<column-label>Owning entity</column-label>
</field>
<field><name>owning_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Owning obj</label>
<column-label>Owning obj</column-label>
</field>
<field><name>user_allocation_value1</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>User allocation value1</label>
<column-label>User allocation value1</column-label>
</field>
<field><name>user_allocation_value2</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>User allocation value2</label>
<column-label>User allocation value2</column-label>
</field>
<field><name>user_allocation_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>User allocation obj</label>
<column-label>User allocation obj</column-label>
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
<last_login_date>10/21/03</last_login_date>
<last_login_time>33383</last_login_time>
<disabled>no</disabled>
<language_obj>426</language_obj>
<password_expiry_days>0</password_expiry_days>
<maintain_system_data>yes</maintain_system_data>
<default_login_company_obj>1008000220.09</default_login_company_obj>
<user_email_address></user_email_address>
<development_user>yes</development_user>
<security_group>no</security_group>
<default_security_group>no</default_security_group>
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
<security_group>no</security_group>
<default_security_group>no</default_security_group>
</contained_record>
</dataset_transaction>
</dataset_records>
</dataset>