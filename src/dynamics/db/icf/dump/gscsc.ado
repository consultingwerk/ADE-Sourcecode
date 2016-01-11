<?xml version="1.0" encoding="utf-8" ?>
<dataset Transactions="1"><dataset_header DisableRI="yes" DatasetObj="1007600205.08" DateFormat="mdy" FullHeader="yes" SCMManaged="no" YearOffset="1950" DatasetCode="GSCSC" NumericFormat="AMERICAN" NumericDecimal="." OriginatingSite="90" NumericSeparator=","><deploy_dataset_obj>1007600205.08</deploy_dataset_obj>
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
<dataset_entity><dataset_entity_obj>1007600206.08</dataset_entity_obj>
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
<exclude_field_list></exclude_field_list>
<entity_mnemonic_description>gsc_security_control</entity_mnemonic_description>
<entity_dbname>ICFDB</entity_dbname>
</dataset_entity>
<table_definition><name>gsc_security_control</name>
<dbname>icfdb</dbname>
<index-1>XIE1gsc_security_control,0,0,0,scm_tool_obj,0</index-1>
<index-2>XPKgsc_security_control,1,1,0,security_control_obj,0</index-2>
<field><name>security_control_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Security control obj</label>
<column-label>Security control obj</column-label>
</field>
<field><name>password_max_retries</name>
<data-type>integer</data-type>
<extent>0</extent>
<format>-&gt;&gt;9</format>
<initial>   0</initial>
<label>Password max. retries</label>
<column-label>Password max. retries</column-label>
</field>
<field><name>password_history_life_time</name>
<data-type>integer</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;9</format>
<initial>      0</initial>
<label>Password history life time</label>
<column-label>Password history life time</column-label>
</field>
<field><name>full_access_by_default</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>YES</initial>
<label>Full access by default</label>
<column-label>Full access by default</column-label>
</field>
<field><name>security_enabled</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>YES</initial>
<label>Security enabled</label>
<column-label>Security enabled</column-label>
</field>
<field><name>help_writer_enabled</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>Help writer enabled</label>
<column-label>Help writer enabled</column-label>
</field>
<field><name>build_top_menus_only</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>YES</initial>
<label>Build top menus only</label>
<column-label>Build top menus only</column-label>
</field>
<field><name>default_help_filename</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Default help filename</label>
<column-label>Default help filename</column-label>
</field>
<field><name>error_log_filename</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Error log filename</label>
<column-label>Error log filename</column-label>
</field>
<field><name>translation_enabled</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>Translation enabled</label>
<column-label>Translation enabled</column-label>
</field>
<field><name>login_filename</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Login filename</label>
<column-label>Login filename</column-label>
</field>
<field><name>multi_user_check</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>YES</initial>
<label>Multi user check</label>
<column-label>Multi user check</column-label>
</field>
<field><name>program_access_check</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>YES</initial>
<label>Program access check</label>
<column-label>Program access check</column-label>
</field>
<field><name>minimise_siblings</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>YES</initial>
<label>Minimise siblings</label>
<column-label>Minimise siblings</column-label>
</field>
<field><name>enable_window_positioning</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>YES</initial>
<label>Enable window positioning</label>
<column-label>Enable window positioning</column-label>
</field>
<field><name>force_unique_password</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>Force unique password</label>
<column-label>Force unique password</column-label>
</field>
<field><name>company_logo_filename</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Company logo filename</label>
<column-label>Company logo filename</column-label>
</field>
<field><name>system_icon_filename</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>System icon filename</label>
<column-label>System icon filename</column-label>
</field>
<field><name>small_icon_filename</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Small icon filename</label>
<column-label>Small icon filename</column-label>
</field>
<field><name>product_logo_filename</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Product logo filename</label>
<column-label>Product logo filename</column-label>
</field>
<field><name>scm_checks_on</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>YES</initial>
<label>SCM checks on</label>
<column-label>SCM checks on</column-label>
</field>
<field><name>scm_tool_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>SCM tool obj</label>
<column-label>SCM tool obj</column-label>
</field>
<field><name>user_context_expiry_period</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>User context expiry period</label>
<column-label>User context expiry period</column-label>
</field>
</table_definition>
</dataset_header>
<dataset_records><dataset_transaction TransactionNo="1" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_security_control"><security_control_obj>1004926868.09</security_control_obj>
<password_max_retries>5</password_max_retries>
<password_history_life_time>365</password_history_life_time>
<full_access_by_default>yes</full_access_by_default>
<security_enabled>yes</security_enabled>
<help_writer_enabled>yes</help_writer_enabled>
<build_top_menus_only>yes</build_top_menus_only>
<default_help_filename></default_help_filename>
<error_log_filename>c:/temp/errlog&amp;1.lg</error_log_filename>
<translation_enabled>yes</translation_enabled>
<login_filename>af/cod2/aftemlognw.w</login_filename>
<multi_user_check>yes</multi_user_check>
<program_access_check>yes</program_access_check>
<minimise_siblings>yes</minimise_siblings>
<enable_window_positioning>yes</enable_window_positioning>
<force_unique_password>no</force_unique_password>
<company_logo_filename>adeicon/login.bmp</company_logo_filename>
<system_icon_filename>adeicon/icfdev.ico</system_icon_filename>
<small_icon_filename>adeicon/icfdev.ico</small_icon_filename>
<product_logo_filename>adeicon/icfdev.ico</product_logo_filename>
<scm_checks_on>yes</scm_checks_on>
<scm_tool_obj>5101.81</scm_tool_obj>
<user_context_expiry_period>0</user_context_expiry_period>
</contained_record>
</dataset_transaction>
</dataset_records>
</dataset>