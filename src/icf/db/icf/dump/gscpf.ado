<?xml version="1.0" encoding="ISO8859-1" ?>
<dataset Transactions="5" version_date="02/23/2002" version_time="43004" version_user="admin" entity_mnemonic="GSTDF" key_field_value="3000000399.09" record_version_obj="3000000400.09" version_number_seq="2.09" import_version_number_seq="1.09"><dataset_header DisableRI="yes" DatasetObj="1007600127.08" DateFormat="mdy" FullHeader="yes" SCMManaged="no" YearOffset="1950" DatasetCode="GSCPF" DateCreated="02/23/2002" TimeCreated="11:56:43" NumericFormat="AMERICAN" NumericDecimal="." OriginatingSite="93" NumericSeparator=","><deploy_dataset_obj>1007600127.08</deploy_dataset_obj>
<owner_site_code></owner_site_code>
<dataset_code>GSCPF</dataset_code>
<dataset_description>gsc_profile_type - Profile Types</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<dataset_entity><dataset_entity_obj>1007600128.08</dataset_entity_obj>
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
<entity_mnemonic_description>gsc_profile_type</entity_mnemonic_description>
<entity_dbname>icfdb</entity_dbname>
</dataset_entity>
<dataset_entity><dataset_entity_obj>1007600129.08</dataset_entity_obj>
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
<entity_mnemonic_description>gsc_profile_code</entity_mnemonic_description>
<entity_dbname>icfdb</entity_dbname>
</dataset_entity>
<table_definition><name>gsc_profile_type</name>
<dbname>ICFDB</dbname>
<index-1>XAK1gsc_profile_type,1,0,0,profile_type_code,0</index-1>
<index-2>XIE1gsc_profile_type,0,0,0,profile_type_description,0</index-2>
<index-3>XPKgsc_profile_type,1,1,0,profile_type_obj,0</index-3>
<field><name>profile_type_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>>>>>>>>>>>>>>>>>>9.999999999</format>
<initial>                 0.000000000</initial>
<label>Profile Type Obj</label>
<column-label>Profile Type Obj</column-label>
</field>
<field><name>profile_type_code</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(10)</format>
<initial></initial>
<label>Profile Type Code</label>
<column-label>Profile Type Code</column-label>
</field>
<field><name>profile_type_description</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>Profile Type Description</label>
<column-label>Profile Type Description</column-label>
</field>
<field><name>client_profile_type</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>YES</initial>
<label>Client Profile Type</label>
<column-label>Client Profile Type</column-label>
</field>
<field><name>server_profile_type</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>YES</initial>
<label>Server Profile Type</label>
<column-label>Server Profile Type</column-label>
</field>
<field><name>profile_type_active</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>YES</initial>
<label>Profile Type Active</label>
<column-label>Profile Type Active</column-label>
</field>
</table_definition>
<table_definition><name>gsc_profile_code</name>
<dbname>ICFDB</dbname>
<index-1>XAK1gsc_profile_code,1,0,0,profile_type_obj,0,profile_code,0</index-1>
<index-2>XAK2gsc_profile_code,1,0,0,profile_code_obj,0</index-2>
<index-3>XIE1gsc_profile_code,0,0,0,profile_type_obj,0,profile_description,0</index-3>
<index-4>XPKgsc_profile_code,1,1,0,profile_type_obj,0,profile_code_obj,0</index-4>
<field><name>profile_type_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>>>>>>>>>>>>>>>>>>9.999999999</format>
<initial>                 0.000000000</initial>
<label>Profile Type Obj</label>
<column-label>Profile Type Obj</column-label>
</field>
<field><name>profile_code_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>>>>>>>>>>>>>>>>>>9.999999999</format>
<initial>                 0.000000000</initial>
<label>Profile Code Obj</label>
<column-label>Profile Code Obj</column-label>
</field>
<field><name>profile_code</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(10)</format>
<initial></initial>
<label>Profile Code</label>
<column-label>Profile Code</column-label>
</field>
<field><name>profile_description</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>Profile Description</label>
<column-label>Profile Description</column-label>
</field>
<field><name>profile_narrative</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(500)</format>
<initial></initial>
<label>Profile Narrative</label>
<column-label>Profile Narrative</column-label>
</field>
</table_definition>
</dataset_header>
<dataset_records><dataset_transaction TransactionNo="1"><contained_record DB="ICFDB" Table="gsc_profile_type"><profile_type_obj>1003546818</profile_type_obj>
<profile_type_code>BrwFilters</profile_type_code>
<profile_type_description>Browse Filter</profile_type_description>
<client_profile_type>yes</client_profile_type>
<server_profile_type>no</server_profile_type>
<profile_type_active>yes</profile_type_active>
<contained_record DB="ICFDB" Table="gsc_profile_code"><profile_type_obj>1003546818</profile_type_obj>
<profile_code_obj>1003546819</profile_code_obj>
<profile_code>FilterSet</profile_code>
<profile_description>Filter Settings</profile_description>
<profile_narrative></profile_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="2"><contained_record DB="ICFDB" Table="gsc_profile_type"><profile_type_obj>1003588530</profile_type_obj>
<profile_type_code>General</profile_type_code>
<profile_type_description>General User Settings</profile_type_description>
<client_profile_type>yes</client_profile_type>
<server_profile_type>no</server_profile_type>
<profile_type_active>yes</profile_type_active>
<contained_record DB="ICFDB" Table="gsc_profile_code"><profile_type_obj>1003588530</profile_type_obj>
<profile_code_obj>1380.38</profile_code_obj>
<profile_code>DispRepos</profile_code>
<profile_description>Display Repository</profile_description>
<profile_narrative>Whether to display repository data (databases and/or product modules) for a user.</profile_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_profile_code"><profile_type_obj>1003588530</profile_type_obj>
<profile_code_obj>1003588632</profile_code_obj>
<profile_code>ReportDir</profile_code>
<profile_description>ReportDir</profile_description>
<profile_narrative>ReportDir</profile_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_profile_code"><profile_type_obj>1003588530</profile_type_obj>
<profile_code_obj>1003588633</profile_code_obj>
<profile_code>EmailProf</profile_code>
<profile_description>EmailProf</profile_description>
<profile_narrative>EmailProf</profile_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="3"><contained_record DB="ICFDB" Table="gsc_profile_type"><profile_type_obj>1003588552</profile_type_obj>
<profile_type_code>RepFilters</profile_type_code>
<profile_type_description>Report Filter Settings</profile_type_description>
<client_profile_type>yes</client_profile_type>
<server_profile_type>yes</server_profile_type>
<profile_type_active>yes</profile_type_active>
<contained_record DB="ICFDB" Table="gsc_profile_code"><profile_type_obj>1003588552</profile_type_obj>
<profile_code_obj>1004956476.09</profile_code_obj>
<profile_code>FilterFrom</profile_code>
<profile_description>FilterFrom for Reports</profile_description>
<profile_narrative>Filter From Profile Code</profile_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="4"><contained_record DB="ICFDB" Table="gsc_profile_type"><profile_type_obj>1003588553</profile_type_obj>
<profile_type_code>Window</profile_type_code>
<profile_type_description>Window settings</profile_type_description>
<client_profile_type>yes</client_profile_type>
<server_profile_type>no</server_profile_type>
<profile_type_active>yes</profile_type_active>
<contained_record DB="ICFDB" Table="gsc_profile_code"><profile_type_obj>1003588553</profile_type_obj>
<profile_code_obj>3750.101</profile_code_obj>
<profile_code>DynTVSize</profile_code>
<profile_description>Dynamic TreeView Size</profile_description>
<profile_narrative>Actual Column position of a Dynamic TreeView's width slider.</profile_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_profile_code"><profile_type_obj>1003588553</profile_type_obj>
<profile_code_obj>1003588627</profile_code_obj>
<profile_code>SaveSizPos</profile_code>
<profile_description>Save Window Sizes and Positions</profile_description>
<profile_narrative>Save Window Sizes and Positions</profile_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_profile_code"><profile_type_obj>1003588553</profile_type_obj>
<profile_code_obj>1003588628</profile_code_obj>
<profile_code>SizePos</profile_code>
<profile_description>Window Size and Position</profile_description>
<profile_narrative>Window Size and Position</profile_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_profile_code"><profile_type_obj>1003588553</profile_type_obj>
<profile_code_obj>1003588629</profile_code_obj>
<profile_code>Tooltips</profile_code>
<profile_description>Turn tooltips on/off</profile_description>
<profile_narrative>Turn tooltips on/off</profile_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_profile_code"><profile_type_obj>1003588553</profile_type_obj>
<profile_code_obj>1003588630</profile_code_obj>
<profile_code>OneWindow</profile_code>
<profile_description>OneWindow</profile_description>
<profile_narrative>OneWindow</profile_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_profile_code"><profile_type_obj>1003588553</profile_type_obj>
<profile_code_obj>1003588631</profile_code_obj>
<profile_code>TopOnly</profile_code>
<profile_description>TopOnly</profile_description>
<profile_narrative>TopOnly</profile_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_profile_code"><profile_type_obj>1003588553</profile_type_obj>
<profile_code_obj>1003589912</profile_code_obj>
<profile_code>DebugAlert</profile_code>
<profile_description>DebugAlert</profile_description>
<profile_narrative>DebugAlert</profile_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="5"><contained_record DB="ICFDB" Table="gsc_profile_type"><profile_type_obj>1004819603</profile_type_obj>
<profile_type_code>SDO</profile_type_code>
<profile_type_description>SDO settings</profile_type_description>
<client_profile_type>yes</client_profile_type>
<server_profile_type>no</server_profile_type>
<profile_type_active>yes</profile_type_active>
<contained_record DB="ICFDB" Table="gsc_profile_code"><profile_type_obj>1004819603</profile_type_obj>
<profile_code_obj>1004819604</profile_code_obj>
<profile_code>Attributes</profile_code>
<profile_description>SDO Attributes</profile_description>
<profile_narrative>value is entered as rowstobatch + chr(3) + rebuildonrepos</profile_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
</dataset_records>
</dataset>