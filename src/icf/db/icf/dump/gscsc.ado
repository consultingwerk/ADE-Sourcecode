<?xml version="1.0" encoding="ISO8859-1" ?>
<dataset Transactions="1" version_date="02/23/2002" version_time="43009" version_user="admin" entity_mnemonic="GSTDF" key_field_value="3000000403.09" record_version_obj="3000000404.09" version_number_seq="2.09" import_version_number_seq="1.09"><dataset_header DisableRI="yes" DatasetObj="1007600205.08" DateFormat="mdy" FullHeader="yes" SCMManaged="no" YearOffset="1950" DatasetCode="GSCSC" DateCreated="02/23/2002" TimeCreated="11:56:48" NumericFormat="AMERICAN" NumericDecimal="." OriginatingSite="93" NumericSeparator=","><deploy_dataset_obj>1007600205.08</deploy_dataset_obj>
<owner_site_code></owner_site_code>
<dataset_code>GSCSC</dataset_code>
<dataset_description>gsc_security_control - Security Ctr</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
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
<entity_mnemonic_description>gsc_security_control</entity_mnemonic_description>
<entity_dbname>icfdb</entity_dbname>
</dataset_entity>
<table_definition><name>gsc_security_control</name>
<dbname>ICFDB</dbname>
<index-1>XPKgsc_security_control,1,1,0,security_control_obj,0</index-1>
<field><name>security_control_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>>>>>>>>>>>>>>>>>>9.999999999</format>
<initial>                 0.000000000</initial>
<label>Security Control Obj</label>
<column-label>Security Control Obj</column-label>
</field>
<field><name>password_max_retries</name>
<data-type>integer</data-type>
<extent>0</extent>
<format>->>9</format>
<initial>   0</initial>
<label>Password Max. Retries</label>
<column-label>Password Max. Retries</column-label>
</field>
<field><name>password_history_life_time</name>
<data-type>integer</data-type>
<extent>0</extent>
<format>->>>>>9</format>
<initial>      0</initial>
<label>Password History Life Time</label>
<column-label>Password History Life Time</column-label>
</field>
<field><name>full_access_by_default</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>YES</initial>
<label>Full Access by Default</label>
<column-label>Full Access by Default</column-label>
</field>
<field><name>security_enabled</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>YES</initial>
<label>Security Enabled</label>
<column-label>Security Enabled</column-label>
</field>
<field><name>help_writer_enabled</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>Help Writer Enabled</label>
<column-label>Help Writer Enabled</column-label>
</field>
<field><name>build_top_menus_only</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>YES</initial>
<label>Build Top Menus Only</label>
<column-label>Build Top Menus Only</column-label>
</field>
<field><name>default_help_filename</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Default Help Filename</label>
<column-label>Default Help Filename</column-label>
</field>
<field><name>error_log_filename</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Error Log Filename</label>
<column-label>Error Log Filename</column-label>
</field>
<field><name>translation_enabled</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>Translation Enabled</label>
<column-label>Translation Enabled</column-label>
</field>
<field><name>login_filename</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Login Filename</label>
<column-label>Login Filename</column-label>
</field>
<field><name>multi_user_check</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>YES</initial>
<label>Multi User Check</label>
<column-label>Multi User Check</column-label>
</field>
<field><name>program_access_check</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>YES</initial>
<label>Program Access Check</label>
<column-label>Program Access Check</column-label>
</field>
<field><name>minimise_siblings</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>YES</initial>
<label>Minimise Siblings</label>
<column-label>Minimise Siblings</column-label>
</field>
<field><name>enable_window_positioning</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>YES</initial>
<label>Enable Window Positioning</label>
<column-label>Enable Window Positioning</column-label>
</field>
<field><name>force_unique_password</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>Force Unique Password</label>
<column-label>Force Unique Password</column-label>
</field>
<field><name>company_logo_filename</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Company Logo Filename</label>
<column-label>Company Logo Filename</column-label>
</field>
<field><name>system_icon_filename</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>System Icon Filename</label>
<column-label>System Icon Filename</column-label>
</field>
<field><name>small_icon_filename</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Small Icon Filename</label>
<column-label>Small Icon Filename</column-label>
</field>
<field><name>product_logo_filename</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Product Logo Filename</label>
<column-label>Product Logo Filename</column-label>
</field>
<field><name>scm_checks_on</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>YES</initial>
<label>Scm Checks On</label>
<column-label>Scm Checks On</column-label>
</field>
<field><name>scm_tool_code</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>Scm Tool Code</label>
<column-label>Scm Tool Code</column-label>
</field>
</table_definition>
</dataset_header>
<dataset_records><dataset_transaction TransactionNo="1"><contained_record DB="ICFDB" Table="gsc_security_control"><security_control_obj>1004926868.09</security_control_obj>
<password_max_retries>5</password_max_retries>
<password_history_life_time>365</password_history_life_time>
<full_access_by_default>yes</full_access_by_default>
<security_enabled>yes</security_enabled>
<help_writer_enabled>yes</help_writer_enabled>
<build_top_menus_only>yes</build_top_menus_only>
<default_help_filename></default_help_filename>
<error_log_filename>c:/temp/errlog&amp;1.lg</error_log_filename>
<translation_enabled>yes</translation_enabled>
<login_filename>af/cod/gsmuslognw.w</login_filename>
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
<scm_tool_code>RTB</scm_tool_code>
</contained_record>
</dataset_transaction>
</dataset_records>
</dataset>