<?xml version="1.0" encoding="ISO8859-1" ?>
<dataset Transactions="3" version_date="02/23/2002" version_time="43011" version_user="admin" entity_mnemonic="GSTDF" key_field_value="3000000409.09" record_version_obj="3000000410.09" version_number_seq="2.09" import_version_number_seq="1.09"><dataset_header DisableRI="yes" DatasetObj="1007600140.08" DateFormat="mdy" FullHeader="yes" SCMManaged="no" YearOffset="1950" DatasetCode="GSCST" DateCreated="02/23/2002" TimeCreated="11:56:50" NumericFormat="AMERICAN" NumericDecimal="." OriginatingSite="93" NumericSeparator=","><deploy_dataset_obj>1007600140.08</deploy_dataset_obj>
<owner_site_code></owner_site_code>
<dataset_code>GSCST</dataset_code>
<dataset_description>gsc_service_type - Service Types</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<dataset_entity><dataset_entity_obj>1007600141.08</dataset_entity_obj>
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
<entity_mnemonic_description>gsc_service_type</entity_mnemonic_description>
<entity_dbname>icfdb</entity_dbname>
</dataset_entity>
<dataset_entity><dataset_entity_obj>1007600142.08</dataset_entity_obj>
<deploy_dataset_obj>1007600140.08</deploy_dataset_obj>
<entity_sequence>2</entity_sequence>
<entity_mnemonic>GSMPY</entity_mnemonic>
<primary_entity>no</primary_entity>
<join_entity_mnemonic>GSCST</join_entity_mnemonic>
<join_field_list>service_type_obj,service_type_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<entity_mnemonic_description>gsm_physical_service</entity_mnemonic_description>
<entity_dbname>icfdb</entity_dbname>
</dataset_entity>
<dataset_entity><dataset_entity_obj>1007600143.08</dataset_entity_obj>
<deploy_dataset_obj>1007600140.08</deploy_dataset_obj>
<entity_sequence>3</entity_sequence>
<entity_mnemonic>GSCLS</entity_mnemonic>
<primary_entity>no</primary_entity>
<join_entity_mnemonic>GSCST</join_entity_mnemonic>
<join_field_list>service_type_obj,service_type_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<entity_mnemonic_description>gsc_logical_service</entity_mnemonic_description>
<entity_dbname>icfdb</entity_dbname>
</dataset_entity>
<table_definition><name>gsc_service_type</name>
<dbname>ICFDB</dbname>
<index-1>XAK1gsc_service_type,1,0,0,service_type_code,0</index-1>
<index-2>XIE1gsc_service_type,0,0,0,service_type_description,0</index-2>
<index-3>XIE4gsc_service_type,0,0,0,default_logical_service_obj,0</index-3>
<index-4>XIE5gsc_service_type,0,0,0,maintenance_object_obj,0</index-4>
<index-5>XIE6gsc_service_type,0,0,0,management_object_obj,0</index-5>
<index-6>XPKgsc_service_type,1,1,0,service_type_obj,0</index-6>
<field><name>service_type_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>>>>>>>>>>>>>>>>>>9.999999999</format>
<initial>                 0.000000000</initial>
<label>Service Type Obj</label>
<column-label>Service Type Obj</column-label>
</field>
<field><name>service_type_code</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(20)</format>
<initial></initial>
<label>Service Type Code</label>
<column-label>Service Type Code</column-label>
</field>
<field><name>service_type_description</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>Service Type Description</label>
<column-label>Service Type Description</column-label>
</field>
<field><name>management_object_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>>>>>>>>>>>>>>>>>>9.999999999</format>
<initial>                 0.000000000</initial>
<label>Management Object Obj</label>
<column-label>Management Object Obj</column-label>
</field>
<field><name>maintenance_object_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>>>>>>>>>>>>>>>>>>9.999999999</format>
<initial>                 0.000000000</initial>
<label>Maintenance Object Obj</label>
<column-label>Maintenance Object Obj</column-label>
</field>
<field><name>default_logical_service_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>>>>>>>>>>>>>>>>>>9.999999999</format>
<initial>                 0.000000000</initial>
<label>Default Logical Service Obj</label>
<column-label>Default Logical Service Obj</column-label>
</field>
</table_definition>
<table_definition><name>gsm_physical_service</name>
<dbname>ICFDB</dbname>
<index-1>XAK1gsm_physical_service,1,0,0,physical_service_code,0</index-1>
<index-2>XIE1gsm_physical_service,0,0,0,physical_service_description,0</index-2>
<index-3>XIE2gsm_physical_service,0,0,0,service_type_obj,0</index-3>
<index-4>XPKgsm_physical_service,1,1,0,physical_service_obj,0</index-4>
<field><name>physical_service_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>>>>>>>>>>>>>>>>>>9.999999999</format>
<initial>                 0.000000000</initial>
<label>Physical Service Obj</label>
<column-label>Physical Service Obj</column-label>
</field>
<field><name>physical_service_code</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(20)</format>
<initial></initial>
<label>Physical Service Code</label>
<column-label>Physical Service Code</column-label>
</field>
<field><name>physical_service_description</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>Physical Service Description</label>
<column-label>Physical Service Description</column-label>
</field>
<field><name>service_type_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>>>>>>>>>>>>>>>>>>9.999999999</format>
<initial>                 0.000000000</initial>
<label>Service Type Obj</label>
<column-label>Service Type Obj</column-label>
</field>
<field><name>connection_parameters</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(500)</format>
<initial></initial>
<label>Connection Parameters</label>
<column-label>Connection Parameters</column-label>
</field>
</table_definition>
<table_definition><name>gsc_logical_service</name>
<dbname>ICFDB</dbname>
<index-1>XAK1gsc_logical_service,1,0,0,logical_service_code,0</index-1>
<index-2>XIE1gsc_logical_service,0,0,0,logical_service_description,0</index-2>
<index-3>XIE2gsc_logical_service,0,0,0,service_type_obj,0</index-3>
<index-4>XPKgsc_logical_service,1,1,0,logical_service_obj,0</index-4>
<field><name>logical_service_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>>>>>>>>>>>>>>>>>>9.999999999</format>
<initial>                 0.000000000</initial>
<label>Logical Service Obj</label>
<column-label>Logical Service Obj</column-label>
</field>
<field><name>logical_service_code</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(20)</format>
<initial></initial>
<label>Logical Service Code</label>
<column-label>Logical Service Code</column-label>
</field>
<field><name>logical_service_description</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>Logical Service Description</label>
<column-label>Logical Service Description</column-label>
</field>
<field><name>service_type_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>>>>>>>>>>>>>>>>>>9.999999999</format>
<initial>                 0.000000000</initial>
<label>Service Type Obj</label>
<column-label>Service Type Obj</column-label>
</field>
<field><name>can_run_locally</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>YES</initial>
<label>Can Run Locally</label>
<column-label>Can Run Locally</column-label>
</field>
<field><name>system_owned</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>System Owned</label>
<column-label>System Owned</column-label>
</field>
<field><name>write_to_config</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>Write to Config</label>
<column-label>Write to Config</column-label>
</field>
</table_definition>
</dataset_header>
<dataset_records><dataset_transaction TransactionNo="1"><contained_record DB="ICFDB" Table="gsc_service_type"><service_type_obj>1004947358.09</service_type_obj>
<service_type_code>AppServer</service_type_code>
<service_type_description>AppServer Partition</service_type_description>
<management_object_obj>1004955736.09</management_object_obj>
<maintenance_object_obj>1004950652.09</maintenance_object_obj>
<default_logical_service_obj>1004947455.09</default_logical_service_obj>
<contained_record DB="ICFDB" Table="gsm_physical_service"><physical_service_obj>1004947554.09</physical_service_obj>
<physical_service_code>ICFDevAS</physical_service_code>
<physical_service_description>Dynamics Development AppServer</physical_service_description>
<service_type_obj>1004947358.09</service_type_obj>
<connection_parameters>R#CHR(3)#-H localhost -S NS1 -AppService icfrepos</connection_parameters>
</contained_record>
<contained_record DB="ICFDB" Table="gsm_physical_service" version_date="02/08/2002" version_time="40605" version_user="admin" entity_mnemonic="gsmpy" key_field_value="1000000003.39" record_version_obj="1000000004.39" version_number_seq="3.39" import_version_number_seq="0"><physical_service_obj>1000000003.39</physical_service_obj>
<physical_service_code>asb_090dyndep</physical_service_code>
<physical_service_description>Dynamics AppServer for Roundtable</physical_service_description>
<service_type_obj>1004947358.09</service_type_obj>
<connection_parameters>R#CHR(3)#-H localhost -S NS1 -AppService asb_090dyndep</connection_parameters>
</contained_record>
<contained_record DB="ICFDB" Table="gsm_physical_service" version_date="02/08/2002" version_time="31994" version_user="admin" entity_mnemonic="gsmpy" key_field_value="1000000005.39" record_version_obj="1000000006.39" version_number_seq="2.39" import_version_number_seq="0"><physical_service_obj>1000000005.39</physical_service_obj>
<physical_service_code>asb_091dyndev</physical_service_code>
<physical_service_description>Dynamics AppServer for Roundtable</physical_service_description>
<service_type_obj>1004947358.09</service_type_obj>
<connection_parameters>R#CHR(3)#-H localhost -S NS1 -AppService asb_091dyndev</connection_parameters>
</contained_record>
<contained_record DB="ICFDB" Table="gsm_physical_service" version_date="02/08/2002" version_time="32004" version_user="admin" entity_mnemonic="gsmpy" key_field_value="1000000007.39" record_version_obj="1000000008.39" version_number_seq="2.39" import_version_number_seq="0"><physical_service_obj>1000000007.39</physical_service_obj>
<physical_service_code>asb_091dyndep</physical_service_code>
<physical_service_description>Dynamics AppServer for Roundtable</physical_service_description>
<service_type_obj>1004947358.09</service_type_obj>
<connection_parameters>R#CHR(3)#-H localhost -S NS1 -AppService asb_091dyndep</connection_parameters>
</contained_record>
<contained_record DB="ICFDB" Table="gsm_physical_service" version_date="02/08/2002" version_time="32014" version_user="admin" entity_mnemonic="gsmpy" key_field_value="1000000009.39" record_version_obj="1000000010.39" version_number_seq="2.39" import_version_number_seq="0"><physical_service_obj>1000000009.39</physical_service_obj>
<physical_service_code>asb_091dyntst</physical_service_code>
<physical_service_description>Dynamics AppServer for Roundtable</physical_service_description>
<service_type_obj>1004947358.09</service_type_obj>
<connection_parameters>R#CHR(3)#-H localhost -S NS1 -AppService asb_091dyntst</connection_parameters>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_logical_service"><logical_service_obj>1004947455.09</logical_service_obj>
<logical_service_code>Astra</logical_service_code>
<logical_service_description>Dynamics AppServer Partition</logical_service_description>
<service_type_obj>1004947358.09</service_type_obj>
<can_run_locally>yes</can_run_locally>
<system_owned>yes</system_owned>
<write_to_config>yes</write_to_config>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="2"><contained_record DB="ICFDB" Table="gsc_service_type"><service_type_obj>1004947359.09</service_type_obj>
<service_type_code>Database</service_type_code>
<service_type_description>Database Connection</service_type_description>
<management_object_obj>1004955735.09</management_object_obj>
<maintenance_object_obj>1004950634.09</maintenance_object_obj>
<default_logical_service_obj>0</default_logical_service_obj>
<contained_record DB="ICFDB" Table="gsm_physical_service"><physical_service_obj>1004947546.09</physical_service_obj>
<physical_service_code>RVDBd</physical_service_code>
<physical_service_description>Direct connection to RVDB</physical_service_description>
<service_type_obj>1004947359.09</service_type_obj>
<connection_parameters>-db d:\workarea\database\rvdb\rvdb.db</connection_parameters>
</contained_record>
<contained_record DB="ICFDB" Table="gsm_physical_service"><physical_service_obj>1004947547.09</physical_service_obj>
<physical_service_code>RVDBn</physical_service_code>
<physical_service_description>Network connect to RVDB</physical_service_description>
<service_type_obj>1004947359.09</service_type_obj>
<connection_parameters>-db rvdb -N TCP -H localhost -S rvdb</connection_parameters>
</contained_record>
<contained_record DB="ICFDB" Table="gsm_physical_service"><physical_service_obj>1004947548.09</physical_service_obj>
<physical_service_code>ICFDBd</physical_service_code>
<physical_service_description>Direct connection to Dynamics DB</physical_service_description>
<service_type_obj>1004947359.09</service_type_obj>
<connection_parameters>-db d:\workarea\database\icfdb\icfdb.db</connection_parameters>
</contained_record>
<contained_record DB="ICFDB" Table="gsm_physical_service"><physical_service_obj>1004947549.09</physical_service_obj>
<physical_service_code>ICFDBn</physical_service_code>
<physical_service_description>Network connect to ICFDB</physical_service_description>
<service_type_obj>1004947359.09</service_type_obj>
<connection_parameters>-db icfdb -N TCP -H localhost -S icfdb</connection_parameters>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_logical_service"><logical_service_obj>1004947456.09</logical_service_obj>
<logical_service_code>RVDB</logical_service_code>
<logical_service_description>Repository Version Database</logical_service_description>
<service_type_obj>1004947359.09</service_type_obj>
<can_run_locally>yes</can_run_locally>
<system_owned>yes</system_owned>
<write_to_config>yes</write_to_config>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_logical_service"><logical_service_obj>1004947458.09</logical_service_obj>
<logical_service_code>ICFDB</logical_service_code>
<logical_service_description>Application Framework Database</logical_service_description>
<service_type_obj>1004947359.09</service_type_obj>
<can_run_locally>yes</can_run_locally>
<system_owned>yes</system_owned>
<write_to_config>yes</write_to_config>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_logical_service"><logical_service_obj>1007600070.09</logical_service_obj>
<logical_service_code>RTB</logical_service_code>
<logical_service_description>Roundtable Database</logical_service_description>
<service_type_obj>1004947359.09</service_type_obj>
<can_run_locally>yes</can_run_locally>
<system_owned>yes</system_owned>
<write_to_config>yes</write_to_config>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="3"><contained_record DB="ICFDB" Table="gsc_service_type"><service_type_obj>1004947360.09</service_type_obj>
<service_type_code>JMS</service_type_code>
<service_type_description>JMS Partition</service_type_description>
<management_object_obj>1004955737.09</management_object_obj>
<maintenance_object_obj>1004955709.09</maintenance_object_obj>
<default_logical_service_obj>0</default_logical_service_obj>
</contained_record>
</dataset_transaction>
</dataset_records>
</dataset>