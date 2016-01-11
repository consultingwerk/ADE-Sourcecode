<?xml version="1.0" encoding="utf-8" ?>
<dataset Transactions="9"><dataset_header DisableRI="yes" DatasetObj="3000005366.09" DateFormat="mdy" FullHeader="yes" SCMManaged="no" YearOffset="1950" DatasetCode="GSMPY" NumericFormat="AMERICAN" NumericDecimal="." OriginatingSite="90" NumericSeparator=","><deploy_dataset_obj>3000005366.09</deploy_dataset_obj>
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
<dataset_entity><dataset_entity_obj>3000005367.09</dataset_entity_obj>
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
<exclude_field_list>connection_parameters</exclude_field_list>
<entity_mnemonic_description>gsm_physical_service</entity_mnemonic_description>
<entity_dbname>ICFDB</entity_dbname>
</dataset_entity>
<table_definition><name>gsm_physical_service</name>
<dbname>icfdb</dbname>
<index-1>XAK1gsm_physical_service,1,0,0,physical_service_code,0</index-1>
<index-2>XIE1gsm_physical_service,0,0,0,physical_service_description,0</index-2>
<index-3>XIE2gsm_physical_service,0,0,0,service_type_obj,0</index-3>
<index-4>XPKgsm_physical_service,1,1,0,physical_service_obj,0</index-4>
<field><name>physical_service_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Physical service obj</label>
<column-label>Physical service obj</column-label>
</field>
<field><name>physical_service_code</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(20)</format>
<initial></initial>
<label>Physical service code</label>
<column-label>Physical service code</column-label>
</field>
<field><name>physical_service_description</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>Physical service description</label>
<column-label>Physical service description</column-label>
</field>
<field><name>service_type_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Service type obj</label>
<column-label>Service type obj</column-label>
</field>
<field><name>connection_parameters</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(500)</format>
<initial></initial>
<label>Connection parameters</label>
<column-label>Connection parameters</column-label>
</field>
</table_definition>
</dataset_header>
<dataset_records><dataset_transaction TransactionNo="1" TransactionType="DELETION"><contained_record version_date="03/01/2002" version_time="55653" version_user="admin" deletion_flag="yes" entity_mnemonic="gsmpy" key_field_value="1004947546.09" record_version_obj="3000001847.09" version_number_seq="1.09" secondary_key_value="RVDBd" import_version_number_seq="1.09"/>
</dataset_transaction>
<dataset_transaction TransactionNo="2" TransactionType="DELETION"><contained_record version_date="03/01/2002" version_time="55649" version_user="admin" deletion_flag="yes" entity_mnemonic="gsmpy" key_field_value="1004947547.09" record_version_obj="3000001846.09" version_number_seq="1.09" secondary_key_value="RVDBn" import_version_number_seq="1.09"/>
</dataset_transaction>
<dataset_transaction TransactionNo="3" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_physical_service" version_date="02/13/2002" version_time="39350" version_user="admin" deletion_flag="no" entity_mnemonic="gsmpy" key_field_value="1000000003.39" record_version_obj="1000000004.39" version_number_seq="3.39" secondary_key_value="asb_090dyndep" import_version_number_seq="3.39"><physical_service_obj>1000000003.39</physical_service_obj>
<physical_service_code>asb_090dyndep</physical_service_code>
<physical_service_description>Dynamics AppServer for Roundtable</physical_service_description>
<service_type_obj>1004947358.09</service_type_obj>
<connection_parameters>R#CHR(3)#-H localhost -S NS1 -AppService asb_090dyndep</connection_parameters>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="4" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_physical_service" version_date="02/13/2002" version_time="39350" version_user="admin" deletion_flag="no" entity_mnemonic="gsmpy" key_field_value="1000000005.39" record_version_obj="1000000006.39" version_number_seq="2.39" secondary_key_value="asb_091dyndev" import_version_number_seq="2.39"><physical_service_obj>1000000005.39</physical_service_obj>
<physical_service_code>asb_091dyndev</physical_service_code>
<physical_service_description>Dynamics AppServer for Roundtable</physical_service_description>
<service_type_obj>1004947358.09</service_type_obj>
<connection_parameters>R#CHR(3)#-H localhost -S NS1 -AppService asb_091dyndev</connection_parameters>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="5" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_physical_service" version_date="02/13/2002" version_time="39350" version_user="admin" deletion_flag="no" entity_mnemonic="gsmpy" key_field_value="1000000007.39" record_version_obj="1000000008.39" version_number_seq="2.39" secondary_key_value="asb_091dyndep" import_version_number_seq="2.39"><physical_service_obj>1000000007.39</physical_service_obj>
<physical_service_code>asb_091dyndep</physical_service_code>
<physical_service_description>Dynamics AppServer for Roundtable</physical_service_description>
<service_type_obj>1004947358.09</service_type_obj>
<connection_parameters>R#CHR(3)#-H localhost -S NS1 -AppService asb_091dyndep</connection_parameters>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="6" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_physical_service" version_date="02/13/2002" version_time="39350" version_user="admin" deletion_flag="no" entity_mnemonic="gsmpy" key_field_value="1000000009.39" record_version_obj="1000000010.39" version_number_seq="2.39" secondary_key_value="asb_091dyntst" import_version_number_seq="2.39"><physical_service_obj>1000000009.39</physical_service_obj>
<physical_service_code>asb_091dyntst</physical_service_code>
<physical_service_description>Dynamics AppServer for Roundtable</physical_service_description>
<service_type_obj>1004947358.09</service_type_obj>
<connection_parameters>R#CHR(3)#-H localhost -S NS1 -AppService asb_091dyntst</connection_parameters>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="7" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_physical_service" version_date="10/02/2003" version_time="49466" version_user="admin" deletion_flag="no" entity_mnemonic="GSMPY" key_field_value="1004947548.09" record_version_obj="3000059019.09" version_number_seq="1.09" secondary_key_value="ICFDBd" import_version_number_seq="1.09"><physical_service_obj>1004947548.09</physical_service_obj>
<physical_service_code>ICFDBd</physical_service_code>
<physical_service_description>Direct connection to Dynamics DB</physical_service_description>
<service_type_obj>1004947359.09</service_type_obj>
<connection_parameters>-db d:\workarea\database\icfdb\icfdb.db</connection_parameters>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="8" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_physical_service" version_date="10/02/2003" version_time="49466" version_user="admin" deletion_flag="no" entity_mnemonic="GSMPY" key_field_value="1004947549.09" record_version_obj="3000059020.09" version_number_seq="1.09" secondary_key_value="ICFDBn" import_version_number_seq="1.09"><physical_service_obj>1004947549.09</physical_service_obj>
<physical_service_code>ICFDBn</physical_service_code>
<physical_service_description>Network connect to ICFDB</physical_service_description>
<service_type_obj>1004947359.09</service_type_obj>
<connection_parameters>-db icfdb -N TCP -H localhost -S icfdb</connection_parameters>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="9" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_physical_service" version_date="10/02/2003" version_time="49466" version_user="admin" deletion_flag="no" entity_mnemonic="GSMPY" key_field_value="1004947554.09" record_version_obj="3000059021.09" version_number_seq="1.09" secondary_key_value="ICFDevAS" import_version_number_seq="1.09"><physical_service_obj>1004947554.09</physical_service_obj>
<physical_service_code>ICFDevAS</physical_service_code>
<physical_service_description>Dynamics Development AppServer</physical_service_description>
<service_type_obj>1004947358.09</service_type_obj>
<connection_parameters>R#CHR(3)#-H localhost -S NS1 -AppService icfrepos</connection_parameters>
</contained_record>
</dataset_transaction>
</dataset_records>
</dataset>