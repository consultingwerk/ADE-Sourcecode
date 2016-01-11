<?xml version="1.0" encoding="utf-8" ?>
<dataset Transactions="3"><dataset_header DisableRI="yes" DatasetObj="1007600140.08" DateFormat="mdy" FullHeader="yes" SCMManaged="no" YearOffset="1950" DatasetCode="GSCST" NumericFormat="AMERICAN" NumericDecimal="." OriginatingSite="90" NumericSeparator=","><deploy_dataset_obj>1007600140.08</deploy_dataset_obj>
<dataset_code>GSCST</dataset_code>
<dataset_description>gsc_service_type - Service Types</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<deploy_additions_only>no</deploy_additions_only>
<enable_data_versioning>yes</enable_data_versioning>
<deletion_dataset>yes</deletion_dataset>
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
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
<entity_mnemonic_description>gsc_service_type</entity_mnemonic_description>
<entity_dbname>ICFDB</entity_dbname>
</dataset_entity>
<table_definition><name>gsc_service_type</name>
<dbname>icfdb</dbname>
<index-1>XAK1gsc_service_type,1,0,0,service_type_code,0</index-1>
<index-2>XIE1gsc_service_type,0,0,0,service_type_description,0</index-2>
<index-3>XIE4gsc_service_type,0,0,0,default_logical_service_obj,0</index-3>
<index-4>XIE5gsc_service_type,0,0,0,maintenance_object_obj,0</index-4>
<index-5>XIE6gsc_service_type,0,0,0,management_object_obj,0</index-5>
<index-6>XPKgsc_service_type,1,1,0,service_type_obj,0</index-6>
<field><name>service_type_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
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
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Management Object Obj</label>
<column-label>Management Object Obj</column-label>
</field>
<field><name>maintenance_object_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Maintenance Object Obj</label>
<column-label>Maintenance Object Obj</column-label>
</field>
<field><name>default_logical_service_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Default Logical Service Obj</label>
<column-label>Default Logical Service Obj</column-label>
</field>
</table_definition>
</dataset_header>
<dataset_records><dataset_transaction TransactionNo="1" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_service_type"><service_type_obj>1004947358.09</service_type_obj>
<service_type_code>AppServer</service_type_code>
<service_type_description>AppServer Partition</service_type_description>
<management_object_obj>1004955736.09</management_object_obj>
<maintenance_object_obj>1004950652.09</maintenance_object_obj>
<default_logical_service_obj>1004947455.09</default_logical_service_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="2" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_service_type"><service_type_obj>1004947359.09</service_type_obj>
<service_type_code>Database</service_type_code>
<service_type_description>Database Connection</service_type_description>
<management_object_obj>1004955735.09</management_object_obj>
<maintenance_object_obj>1004950634.09</maintenance_object_obj>
<default_logical_service_obj>0</default_logical_service_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="3" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_service_type"><service_type_obj>1004947360.09</service_type_obj>
<service_type_code>JMS</service_type_code>
<service_type_description>JMS Partition</service_type_description>
<management_object_obj>1004955737.09</management_object_obj>
<maintenance_object_obj>1004955709.09</maintenance_object_obj>
<default_logical_service_obj>0</default_logical_service_obj>
</contained_record>
</dataset_transaction>
</dataset_records>
</dataset>