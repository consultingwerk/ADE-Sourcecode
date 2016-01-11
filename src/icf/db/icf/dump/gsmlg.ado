<?xml version="1.0" encoding="utf-8" ?>
<dataset Transactions="1"><dataset_header DisableRI="yes" DatasetObj="1007600103.08" DateFormat="mdy" FullHeader="yes" SCMManaged="no" YearOffset="1950" DatasetCode="GSMLG" NumericFormat="AMERICAN" NumericDecimal="." OriginatingSite="90" NumericSeparator=","><deploy_dataset_obj>1007600103.08</deploy_dataset_obj>
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
<dataset_entity><dataset_entity_obj>1007600104.08</dataset_entity_obj>
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
<entity_mnemonic_description>gsm_login_company</entity_mnemonic_description>
<entity_dbname>ICFDB</entity_dbname>
</dataset_entity>
<table_definition><name>gsm_login_company</name>
<dbname>icfdb</dbname>
<index-1>XAK1gsm_login_company,1,0,0,login_company_code,0</index-1>
<index-2>XIE1gsm_login_company,0,0,0,login_company_short_name,0</index-2>
<index-3>XIE2gsm_login_company,0,0,0,login_company_name,0</index-3>
<index-4>XPKgsm_login_company,1,1,0,login_company_obj,0</index-4>
<field><name>login_company_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Login Company Obj</label>
<column-label>Login Company Obj</column-label>
</field>
<field><name>login_company_code</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>Login Company Code</label>
<column-label>Login Company Code</column-label>
</field>
<field><name>login_company_short_name</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(15)</format>
<initial></initial>
<label>Login Company Short Name</label>
<column-label>Login Company Short Name</column-label>
</field>
<field><name>login_company_name</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Login Company Name</label>
<column-label>Login Company Name</column-label>
</field>
<field><name>login_company_email</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>Login Company Email</label>
<column-label>Login Company Email</column-label>
</field>
<field><name>login_company_disabled</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>Login Company Disabled</label>
<column-label>Login Company Disabled</column-label>
</field>
</table_definition>
</dataset_header>
<dataset_records><dataset_transaction TransactionNo="1" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_login_company"><login_company_obj>1008000220.09</login_company_obj>
<login_company_code>Dynamics</login_company_code>
<login_company_short_name>Default Co</login_company_short_name>
<login_company_name>Default Company</login_company_name>
<login_company_email></login_company_email>
<login_company_disabled>no</login_company_disabled>
</contained_record>
</dataset_transaction>
</dataset_records>
</dataset>