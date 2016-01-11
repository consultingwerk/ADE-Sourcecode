<?xml version="1.0" encoding="ISO8859-1" ?>
<dataset Transactions="9" version_date="02/23/2002" version_time="43069" version_user="admin" entity_mnemonic="GSTDF" key_field_value="3000000441.09" record_version_obj="3000000442.09" version_number_seq="2.09" import_version_number_seq="1.09"><dataset_header DisableRI="yes" DatasetObj="1007600132.08" DateFormat="mdy" FullHeader="yes" SCMManaged="no" YearOffset="1950" DatasetCode="GSMSE" DateCreated="02/23/2002" TimeCreated="11:57:45" NumericFormat="AMERICAN" NumericDecimal="." OriginatingSite="93" NumericSeparator=","><deploy_dataset_obj>1007600132.08</deploy_dataset_obj>
<owner_site_code></owner_site_code>
<dataset_code>GSMSE</dataset_code>
<dataset_description>gsm_session_type - Session Types</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<dataset_entity><dataset_entity_obj>1007600134.08</dataset_entity_obj>
<deploy_dataset_obj>1007600132.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSMSE</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>session_type_code</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<entity_mnemonic_description>gsm_session_type</entity_mnemonic_description>
<entity_dbname>icfdb</entity_dbname>
</dataset_entity>
<dataset_entity><dataset_entity_obj>1007600135.08</dataset_entity_obj>
<deploy_dataset_obj>1007600132.08</deploy_dataset_obj>
<entity_sequence>2</entity_sequence>
<entity_mnemonic>GSMSY</entity_mnemonic>
<primary_entity>no</primary_entity>
<join_entity_mnemonic>GSMSE</join_entity_mnemonic>
<join_field_list>session_type_obj,session_type_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<entity_mnemonic_description>gsm_session_type_property</entity_mnemonic_description>
<entity_dbname>icfdb</entity_dbname>
</dataset_entity>
<dataset_entity><dataset_entity_obj>1007600136.08</dataset_entity_obj>
<deploy_dataset_obj>1007600132.08</deploy_dataset_obj>
<entity_sequence>3</entity_sequence>
<entity_mnemonic>GSMSV</entity_mnemonic>
<primary_entity>no</primary_entity>
<join_entity_mnemonic>GSMSE</join_entity_mnemonic>
<join_field_list>session_type_obj,session_type_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<entity_mnemonic_description>gsm_session_service</entity_mnemonic_description>
<entity_dbname>icfdb</entity_dbname>
</dataset_entity>
<dataset_entity><dataset_entity_obj>1007600137.08</dataset_entity_obj>
<deploy_dataset_obj>1007600132.08</deploy_dataset_obj>
<entity_sequence>4</entity_sequence>
<entity_mnemonic>GSMRM</entity_mnemonic>
<primary_entity>no</primary_entity>
<join_entity_mnemonic>GSMSE</join_entity_mnemonic>
<join_field_list>session_type_obj,session_type_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<entity_mnemonic_description>gsm_required_manager</entity_mnemonic_description>
<entity_dbname>icfdb</entity_dbname>
</dataset_entity>
<table_definition><name>gsm_session_type</name>
<dbname>ICFDB</dbname>
<index-1>XAK1gsm_session_type,1,0,0,session_type_code,0</index-1>
<index-2>XIE1gsm_session_type,0,0,0,session_type_description,0</index-2>
<index-3>XPKgsm_session_type,1,1,0,session_type_obj,0</index-3>
<field><name>session_type_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>>>>>>>>>>>>>>>>>>9.999999999</format>
<initial>                 0.000000000</initial>
<label>Session Type Obj</label>
<column-label>Session Type Obj</column-label>
</field>
<field><name>session_type_code</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(20)</format>
<initial></initial>
<label>Session Type Code</label>
<column-label>Session Type Code</column-label>
</field>
<field><name>session_type_description</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>Session Type Description</label>
<column-label>Session Type Description</column-label>
</field>
<field><name>physical_session_list</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Physical Session List</label>
<column-label>Physical Session List</column-label>
</field>
<field><name>valid_os_list</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(15)</format>
<initial></initial>
<label>Valid OS List</label>
<column-label>Valid OS List</column-label>
</field>
</table_definition>
<table_definition><name>gsm_session_type_property</name>
<dbname>ICFDB</dbname>
<index-1>XAK1gsm_session_type_property,1,0,0,session_property_obj,0,session_type_obj,0</index-1>
<index-2>XIE1gsm_session_type_property,0,0,0,session_type_obj,0</index-2>
<index-3>XPKgsm_session_type_property,1,1,0,session_type_property_obj,0</index-3>
<field><name>session_type_property_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>>>>>>>>>>>>>>>>>>9.999999999</format>
<initial>                 0.000000000</initial>
<label>Session Type Property Obj</label>
<column-label>Session Type Property Obj</column-label>
</field>
<field><name>session_type_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>>>>>>>>>>>>>>>>>>9.999999999</format>
<initial>                 0.000000000</initial>
<label>Session Type Obj</label>
<column-label>Session Type Obj</column-label>
</field>
<field><name>session_property_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>>>>>>>>>>>>>>>>>>9.999999999</format>
<initial>                 0.000000000</initial>
<label>Session Property Obj</label>
<column-label>Session Property Obj</column-label>
</field>
<field><name>property_value</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Property Value</label>
<column-label>Property Value</column-label>
</field>
</table_definition>
<table_definition><name>gsm_session_service</name>
<dbname>ICFDB</dbname>
<index-1>XAK1gsm_session_service,1,0,0,session_type_obj,0,logical_service_obj,0</index-1>
<index-2>XAK2gsm_session_service,1,0,0,logical_service_obj,0,session_type_obj,0</index-2>
<index-3>XIE1gsm_session_service,0,0,0,physical_service_obj,0</index-3>
<index-4>XPKgsm_session_service,1,1,0,session_service_obj,0</index-4>
<field><name>session_service_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>>>>>>>>>>>>>>>>>>9.999999999</format>
<initial>                 0.000000000</initial>
<label>Session Service Obj</label>
<column-label>Session Service Obj</column-label>
</field>
<field><name>session_type_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>>>>>>>>>>>>>>>>>>9.999999999</format>
<initial>                 0.000000000</initial>
<label>Session Type Obj</label>
<column-label>Session Type Obj</column-label>
</field>
<field><name>logical_service_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>>>>>>>>>>>>>>>>>>9.999999999</format>
<initial>                 0.000000000</initial>
<label>Logical Service Obj</label>
<column-label>Logical Service Obj</column-label>
</field>
<field><name>physical_service_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>>>>>>>>>>>>>>>>>>9.999999999</format>
<initial>                 0.000000000</initial>
<label>Physical Service Obj</label>
<column-label>Physical Service Obj</column-label>
</field>
</table_definition>
<table_definition><name>gsm_required_manager</name>
<dbname>ICFDB</dbname>
<index-1>XAK1gsm_required_manager,1,0,0,session_type_obj,0,startup_order,0</index-1>
<index-2>XAK2gsm_required_manager,1,0,0,manager_type_obj,0,session_type_obj,0</index-2>
<index-3>XIE2gsm_required_manager,0,0,0,object_obj,0</index-3>
<index-4>XPKgsm_required_manager,1,1,0,required_manager_obj,0</index-4>
<field><name>required_manager_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>>>>>>>>>>>>>>>>>>9.999999999</format>
<initial>                 0.000000000</initial>
<label>Required Manager Obj</label>
<column-label>Required Manager Obj</column-label>
</field>
<field><name>session_type_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>>>>>>>>>>>>>>>>>>9.999999999</format>
<initial>                 0.000000000</initial>
<label>Session Type Obj</label>
<column-label>Session Type Obj</column-label>
</field>
<field><name>startup_order</name>
<data-type>integer</data-type>
<extent>0</extent>
<format>->>9</format>
<initial>   0</initial>
<label>Startup Order</label>
<column-label>Startup Order</column-label>
</field>
<field><name>manager_type_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>>>>>>>>>>>>>>>>>>9.999999999</format>
<initial>                 0.000000000</initial>
<label>Manager Type Obj</label>
<column-label>Manager Type Obj</column-label>
</field>
<field><name>object_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>>>>>>>>>>>>>>>>>>9.999999999</format>
<initial>                 0.000000000</initial>
<label>Object Obj</label>
<column-label>Object Obj</column-label>
</field>
<field><name>system_owned</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>System Owned</label>
<column-label>System Owned</column-label>
</field>
</table_definition>
</dataset_header>
<dataset_records><dataset_transaction TransactionNo="1"><contained_record DB="ICFDB" Table="gsm_session_type" version_date="02/08/2002" version_time="32245" version_user="admin" entity_mnemonic="gsmse" key_field_value="1000000011.39" record_version_obj="1000000012.39" version_number_seq="4.39" import_version_number_seq="0"><session_type_obj>1000000011.39</session_type_obj>
<session_type_code>rtb_090dyndep</session_type_code>
<session_type_description>Roundtable 090dyn-dep AppServer</session_type_description>
<physical_session_list>APP</physical_session_list>
<valid_os_list>WIN32</valid_os_list>
<contained_record DB="ICFDB" Table="gsm_session_type_property" version_date="02/08/2002" version_time="32470" version_user="admin" entity_mnemonic="gsmsy" key_field_value="1000000035.39" record_version_obj="1000000036.39" version_number_seq="2.39" import_version_number_seq="0"><session_type_property_obj>1000000035.39</session_type_property_obj>
<session_type_obj>1000000011.39</session_type_obj>
<session_property_obj>1004955844.09</session_property_obj>
<property_value>YES</property_value>
</contained_record>
<contained_record DB="ICFDB" Table="gsm_session_service" version_date="02/08/2002" version_time="32326" version_user="admin" entity_mnemonic="gsmsv" key_field_value="1000000019.39" record_version_obj="1000000020.39" version_number_seq="2.39" import_version_number_seq="0"><session_service_obj>1000000019.39</session_service_obj>
<session_type_obj>1000000011.39</session_type_obj>
<logical_service_obj>1004947455.09</logical_service_obj>
<physical_service_obj>1000000003.39</physical_service_obj>
</contained_record>
<contained_record DB="ICFDB" Table="gsm_required_manager" version_date="02/08/2002" version_time="32367" version_user="admin" entity_mnemonic="gsmrm" key_field_value="1000000021.39" record_version_obj="1000000022.39" version_number_seq="2.39" import_version_number_seq="0"><required_manager_obj>1000000021.39</required_manager_obj>
<session_type_obj>1000000011.39</session_type_obj>
<startup_order>1</startup_order>
<manager_type_obj>1004947362.09</manager_type_obj>
<object_obj>1004955826.09</object_obj>
<system_owned>yes</system_owned>
</contained_record>
<contained_record DB="ICFDB" Table="gsm_required_manager" version_date="02/08/2002" version_time="32392" version_user="admin" entity_mnemonic="gsmrm" key_field_value="1000000023.39" record_version_obj="1000000024.39" version_number_seq="2.39" import_version_number_seq="0"><required_manager_obj>1000000023.39</required_manager_obj>
<session_type_obj>1000000011.39</session_type_obj>
<startup_order>2</startup_order>
<manager_type_obj>1004947428.09</manager_type_obj>
<object_obj>1004956693.09</object_obj>
<system_owned>yes</system_owned>
</contained_record>
<contained_record DB="ICFDB" Table="gsm_required_manager" version_date="02/08/2002" version_time="32411" version_user="admin" entity_mnemonic="gsmrm" key_field_value="1000000025.39" record_version_obj="1000000026.39" version_number_seq="2.39" import_version_number_seq="0"><required_manager_obj>1000000025.39</required_manager_obj>
<session_type_obj>1000000011.39</session_type_obj>
<startup_order>3</startup_order>
<manager_type_obj>1004947431.09</manager_type_obj>
<object_obj>1004956698.09</object_obj>
<system_owned>yes</system_owned>
</contained_record>
<contained_record DB="ICFDB" Table="gsm_required_manager" version_date="02/08/2002" version_time="32424" version_user="admin" entity_mnemonic="gsmrm" key_field_value="1000000027.39" record_version_obj="1000000028.39" version_number_seq="2.39" import_version_number_seq="0"><required_manager_obj>1000000027.39</required_manager_obj>
<session_type_obj>1000000011.39</session_type_obj>
<startup_order>4</startup_order>
<manager_type_obj>1004947448.09</manager_type_obj>
<object_obj>1004956695.09</object_obj>
<system_owned>yes</system_owned>
</contained_record>
<contained_record DB="ICFDB" Table="gsm_required_manager" version_date="02/08/2002" version_time="32433" version_user="admin" entity_mnemonic="gsmrm" key_field_value="1000000029.39" record_version_obj="1000000030.39" version_number_seq="2.39" import_version_number_seq="0"><required_manager_obj>1000000029.39</required_manager_obj>
<session_type_obj>1000000011.39</session_type_obj>
<startup_order>5</startup_order>
<manager_type_obj>1004947430.09</manager_type_obj>
<object_obj>1004956696.09</object_obj>
<system_owned>yes</system_owned>
</contained_record>
<contained_record DB="ICFDB" Table="gsm_required_manager" version_date="02/08/2002" version_time="32444" version_user="admin" entity_mnemonic="gsmrm" key_field_value="1000000031.39" record_version_obj="1000000032.39" version_number_seq="2.39" import_version_number_seq="0"><required_manager_obj>1000000031.39</required_manager_obj>
<session_type_obj>1000000011.39</session_type_obj>
<startup_order>6</startup_order>
<manager_type_obj>1004947429.09</manager_type_obj>
<object_obj>1004956694.09</object_obj>
<system_owned>yes</system_owned>
</contained_record>
<contained_record DB="ICFDB" Table="gsm_required_manager" version_date="02/08/2002" version_time="32454" version_user="admin" entity_mnemonic="gsmrm" key_field_value="1000000033.39" record_version_obj="1000000034.39" version_number_seq="2.39" import_version_number_seq="0"><required_manager_obj>1000000033.39</required_manager_obj>
<session_type_obj>1000000011.39</session_type_obj>
<startup_order>7</startup_order>
<manager_type_obj>1004947432.09</manager_type_obj>
<object_obj>1004956697.09</object_obj>
<system_owned>yes</system_owned>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="2"><contained_record DB="ICFDB" Table="gsm_session_type" version_date="02/08/2002" version_time="32258" version_user="admin" entity_mnemonic="gsmse" key_field_value="1000000013.39" record_version_obj="1000000014.39" version_number_seq="3.39" import_version_number_seq="0"><session_type_obj>1000000013.39</session_type_obj>
<session_type_code>rtb_091dyndep</session_type_code>
<session_type_description>Roundtable 091dyn-dep AppServer</session_type_description>
<physical_session_list>APP</physical_session_list>
<valid_os_list>WIN32</valid_os_list>
<contained_record DB="ICFDB" Table="gsm_session_type_property" version_date="02/08/2002" version_time="33223" version_user="admin" entity_mnemonic="gsmsy" key_field_value="1000000053.39" record_version_obj="1000000054.39" version_number_seq="2.39" import_version_number_seq="0"><session_type_property_obj>1000000053.39</session_type_property_obj>
<session_type_obj>1000000013.39</session_type_obj>
<session_property_obj>1004955844.09</session_property_obj>
<property_value>YES</property_value>
</contained_record>
<contained_record DB="ICFDB" Table="gsm_session_service" version_date="02/08/2002" version_time="32570" version_user="admin" entity_mnemonic="gsmsv" key_field_value="1000000037.39" record_version_obj="1000000038.39" version_number_seq="2.39" import_version_number_seq="0"><session_service_obj>1000000037.39</session_service_obj>
<session_type_obj>1000000013.39</session_type_obj>
<logical_service_obj>1004947455.09</logical_service_obj>
<physical_service_obj>1000000007.39</physical_service_obj>
</contained_record>
<contained_record DB="ICFDB" Table="gsm_required_manager" version_date="02/08/2002" version_time="32683" version_user="admin" entity_mnemonic="gsmrm" key_field_value="1000000039.39" record_version_obj="1000000040.39" version_number_seq="2.39" import_version_number_seq="0"><required_manager_obj>1000000039.39</required_manager_obj>
<session_type_obj>1000000013.39</session_type_obj>
<startup_order>1</startup_order>
<manager_type_obj>1004947362.09</manager_type_obj>
<object_obj>1004955826.09</object_obj>
<system_owned>yes</system_owned>
</contained_record>
<contained_record DB="ICFDB" Table="gsm_required_manager" version_date="02/08/2002" version_time="33000" version_user="admin" entity_mnemonic="gsmrm" key_field_value="1000000041.39" record_version_obj="1000000042.39" version_number_seq="2.39" import_version_number_seq="0"><required_manager_obj>1000000041.39</required_manager_obj>
<session_type_obj>1000000013.39</session_type_obj>
<startup_order>2</startup_order>
<manager_type_obj>1004947428.09</manager_type_obj>
<object_obj>1004956693.09</object_obj>
<system_owned>yes</system_owned>
</contained_record>
<contained_record DB="ICFDB" Table="gsm_required_manager" version_date="02/08/2002" version_time="33017" version_user="admin" entity_mnemonic="gsmrm" key_field_value="1000000043.39" record_version_obj="1000000044.39" version_number_seq="2.39" import_version_number_seq="0"><required_manager_obj>1000000043.39</required_manager_obj>
<session_type_obj>1000000013.39</session_type_obj>
<startup_order>3</startup_order>
<manager_type_obj>1004947431.09</manager_type_obj>
<object_obj>1004956698.09</object_obj>
<system_owned>yes</system_owned>
</contained_record>
<contained_record DB="ICFDB" Table="gsm_required_manager" version_date="02/08/2002" version_time="33194" version_user="admin" entity_mnemonic="gsmrm" key_field_value="1000000047.39" record_version_obj="1000000048.39" version_number_seq="2.39" import_version_number_seq="0"><required_manager_obj>1000000047.39</required_manager_obj>
<session_type_obj>1000000013.39</session_type_obj>
<startup_order>4</startup_order>
<manager_type_obj>1004947448.09</manager_type_obj>
<object_obj>1004956695.09</object_obj>
<system_owned>yes</system_owned>
</contained_record>
<contained_record DB="ICFDB" Table="gsm_required_manager" version_date="02/08/2002" version_time="33041" version_user="admin" entity_mnemonic="gsmrm" key_field_value="1000000045.39" record_version_obj="1000000046.39" version_number_seq="2.39" import_version_number_seq="0"><required_manager_obj>1000000045.39</required_manager_obj>
<session_type_obj>1000000013.39</session_type_obj>
<startup_order>5</startup_order>
<manager_type_obj>1004947430.09</manager_type_obj>
<object_obj>1004956696.09</object_obj>
<system_owned>yes</system_owned>
</contained_record>
<contained_record DB="ICFDB" Table="gsm_required_manager" version_date="02/08/2002" version_time="33202" version_user="admin" entity_mnemonic="gsmrm" key_field_value="1000000049.39" record_version_obj="1000000050.39" version_number_seq="2.39" import_version_number_seq="0"><required_manager_obj>1000000049.39</required_manager_obj>
<session_type_obj>1000000013.39</session_type_obj>
<startup_order>6</startup_order>
<manager_type_obj>1004947429.09</manager_type_obj>
<object_obj>1004956694.09</object_obj>
<system_owned>yes</system_owned>
</contained_record>
<contained_record DB="ICFDB" Table="gsm_required_manager" version_date="02/08/2002" version_time="33210" version_user="admin" entity_mnemonic="gsmrm" key_field_value="1000000051.39" record_version_obj="1000000052.39" version_number_seq="2.39" import_version_number_seq="0"><required_manager_obj>1000000051.39</required_manager_obj>
<session_type_obj>1000000013.39</session_type_obj>
<startup_order>7</startup_order>
<manager_type_obj>1004947432.09</manager_type_obj>
<object_obj>1004956697.09</object_obj>
<system_owned>yes</system_owned>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="3"><contained_record DB="ICFDB" Table="gsm_session_type" version_date="02/08/2002" version_time="32269" version_user="admin" entity_mnemonic="gsmse" key_field_value="1000000015.39" record_version_obj="1000000016.39" version_number_seq="3.39" import_version_number_seq="0"><session_type_obj>1000000015.39</session_type_obj>
<session_type_code>rtb_091dyndev</session_type_code>
<session_type_description>Roundtable 091dyn-dev AppServer</session_type_description>
<physical_session_list>APP</physical_session_list>
<valid_os_list>WIN32</valid_os_list>
<contained_record DB="ICFDB" Table="gsm_session_type_property" version_date="02/08/2002" version_time="33475" version_user="admin" entity_mnemonic="gsmsy" key_field_value="1000000071.39" record_version_obj="1000000072.39" version_number_seq="2.39" import_version_number_seq="0"><session_type_property_obj>1000000071.39</session_type_property_obj>
<session_type_obj>1000000015.39</session_type_obj>
<session_property_obj>1004955844.09</session_property_obj>
<property_value>YES</property_value>
</contained_record>
<contained_record DB="ICFDB" Table="gsm_session_service" version_date="02/08/2002" version_time="33340" version_user="admin" entity_mnemonic="gsmsv" key_field_value="1000000055.39" record_version_obj="1000000056.39" version_number_seq="2.39" import_version_number_seq="0"><session_service_obj>1000000055.39</session_service_obj>
<session_type_obj>1000000015.39</session_type_obj>
<logical_service_obj>1004947455.09</logical_service_obj>
<physical_service_obj>1000000005.39</physical_service_obj>
</contained_record>
<contained_record DB="ICFDB" Table="gsm_required_manager" version_date="02/08/2002" version_time="33355" version_user="admin" entity_mnemonic="gsmrm" key_field_value="1000000057.39" record_version_obj="1000000058.39" version_number_seq="2.39" import_version_number_seq="0"><required_manager_obj>1000000057.39</required_manager_obj>
<session_type_obj>1000000015.39</session_type_obj>
<startup_order>1</startup_order>
<manager_type_obj>1004947362.09</manager_type_obj>
<object_obj>1004955826.09</object_obj>
<system_owned>yes</system_owned>
</contained_record>
<contained_record DB="ICFDB" Table="gsm_required_manager" version_date="02/08/2002" version_time="33367" version_user="admin" entity_mnemonic="gsmrm" key_field_value="1000000059.39" record_version_obj="1000000060.39" version_number_seq="2.39" import_version_number_seq="0"><required_manager_obj>1000000059.39</required_manager_obj>
<session_type_obj>1000000015.39</session_type_obj>
<startup_order>2</startup_order>
<manager_type_obj>1004947428.09</manager_type_obj>
<object_obj>1004956693.09</object_obj>
<system_owned>yes</system_owned>
</contained_record>
<contained_record DB="ICFDB" Table="gsm_required_manager" version_date="02/08/2002" version_time="33380" version_user="admin" entity_mnemonic="gsmrm" key_field_value="1000000061.39" record_version_obj="1000000062.39" version_number_seq="2.39" import_version_number_seq="0"><required_manager_obj>1000000061.39</required_manager_obj>
<session_type_obj>1000000015.39</session_type_obj>
<startup_order>3</startup_order>
<manager_type_obj>1004947431.09</manager_type_obj>
<object_obj>1004956698.09</object_obj>
<system_owned>yes</system_owned>
</contained_record>
<contained_record DB="ICFDB" Table="gsm_required_manager" version_date="02/08/2002" version_time="33391" version_user="admin" entity_mnemonic="gsmrm" key_field_value="1000000063.39" record_version_obj="1000000064.39" version_number_seq="2.39" import_version_number_seq="0"><required_manager_obj>1000000063.39</required_manager_obj>
<session_type_obj>1000000015.39</session_type_obj>
<startup_order>4</startup_order>
<manager_type_obj>1004947448.09</manager_type_obj>
<object_obj>1004956695.09</object_obj>
<system_owned>yes</system_owned>
</contained_record>
<contained_record DB="ICFDB" Table="gsm_required_manager" version_date="02/08/2002" version_time="33406" version_user="admin" entity_mnemonic="gsmrm" key_field_value="1000000065.39" record_version_obj="1000000066.39" version_number_seq="2.39" import_version_number_seq="0"><required_manager_obj>1000000065.39</required_manager_obj>
<session_type_obj>1000000015.39</session_type_obj>
<startup_order>5</startup_order>
<manager_type_obj>1004947430.09</manager_type_obj>
<object_obj>1004956696.09</object_obj>
<system_owned>yes</system_owned>
</contained_record>
<contained_record DB="ICFDB" Table="gsm_required_manager" version_date="02/08/2002" version_time="33453" version_user="admin" entity_mnemonic="gsmrm" key_field_value="1000000067.39" record_version_obj="1000000068.39" version_number_seq="2.39" import_version_number_seq="0"><required_manager_obj>1000000067.39</required_manager_obj>
<session_type_obj>1000000015.39</session_type_obj>
<startup_order>6</startup_order>
<manager_type_obj>1004947429.09</manager_type_obj>
<object_obj>1004956694.09</object_obj>
<system_owned>yes</system_owned>
</contained_record>
<contained_record DB="ICFDB" Table="gsm_required_manager" version_date="02/08/2002" version_time="33461" version_user="admin" entity_mnemonic="gsmrm" key_field_value="1000000069.39" record_version_obj="1000000070.39" version_number_seq="2.39" import_version_number_seq="0"><required_manager_obj>1000000069.39</required_manager_obj>
<session_type_obj>1000000015.39</session_type_obj>
<startup_order>7</startup_order>
<manager_type_obj>1004947432.09</manager_type_obj>
<object_obj>1004956697.09</object_obj>
<system_owned>yes</system_owned>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="4"><contained_record DB="ICFDB" Table="gsm_session_type" version_date="02/08/2002" version_time="32280" version_user="admin" entity_mnemonic="gsmse" key_field_value="1000000017.39" record_version_obj="1000000018.39" version_number_seq="3.39" import_version_number_seq="0"><session_type_obj>1000000017.39</session_type_obj>
<session_type_code>rtb_091dyntst</session_type_code>
<session_type_description>Roundtable 091dyn-tst AppServer</session_type_description>
<physical_session_list>APP</physical_session_list>
<valid_os_list>WIN32</valid_os_list>
<contained_record DB="ICFDB" Table="gsm_session_type_property" version_date="02/08/2002" version_time="33700" version_user="admin" entity_mnemonic="gsmsy" key_field_value="1000000089.39" record_version_obj="1000000090.39" version_number_seq="2.39" import_version_number_seq="0"><session_type_property_obj>1000000089.39</session_type_property_obj>
<session_type_obj>1000000017.39</session_type_obj>
<session_property_obj>1004955844.09</session_property_obj>
<property_value>YES</property_value>
</contained_record>
<contained_record DB="ICFDB" Table="gsm_session_service" version_date="02/08/2002" version_time="33564" version_user="admin" entity_mnemonic="gsmsv" key_field_value="1000000073.39" record_version_obj="1000000074.39" version_number_seq="2.39" import_version_number_seq="0"><session_service_obj>1000000073.39</session_service_obj>
<session_type_obj>1000000017.39</session_type_obj>
<logical_service_obj>1004947455.09</logical_service_obj>
<physical_service_obj>1000000009.39</physical_service_obj>
</contained_record>
<contained_record DB="ICFDB" Table="gsm_required_manager" version_date="02/08/2002" version_time="33603" version_user="admin" entity_mnemonic="gsmrm" key_field_value="1000000075.39" record_version_obj="1000000076.39" version_number_seq="2.39" import_version_number_seq="0"><required_manager_obj>1000000075.39</required_manager_obj>
<session_type_obj>1000000017.39</session_type_obj>
<startup_order>1</startup_order>
<manager_type_obj>1004947362.09</manager_type_obj>
<object_obj>1004955826.09</object_obj>
<system_owned>yes</system_owned>
</contained_record>
<contained_record DB="ICFDB" Table="gsm_required_manager" version_date="02/08/2002" version_time="33612" version_user="admin" entity_mnemonic="gsmrm" key_field_value="1000000077.39" record_version_obj="1000000078.39" version_number_seq="2.39" import_version_number_seq="0"><required_manager_obj>1000000077.39</required_manager_obj>
<session_type_obj>1000000017.39</session_type_obj>
<startup_order>2</startup_order>
<manager_type_obj>1004947428.09</manager_type_obj>
<object_obj>1004956693.09</object_obj>
<system_owned>yes</system_owned>
</contained_record>
<contained_record DB="ICFDB" Table="gsm_required_manager" version_date="02/08/2002" version_time="33637" version_user="admin" entity_mnemonic="gsmrm" key_field_value="1000000079.39" record_version_obj="1000000080.39" version_number_seq="2.39" import_version_number_seq="0"><required_manager_obj>1000000079.39</required_manager_obj>
<session_type_obj>1000000017.39</session_type_obj>
<startup_order>3</startup_order>
<manager_type_obj>1004947431.09</manager_type_obj>
<object_obj>1004956698.09</object_obj>
<system_owned>yes</system_owned>
</contained_record>
<contained_record DB="ICFDB" Table="gsm_required_manager" version_date="02/08/2002" version_time="33661" version_user="admin" entity_mnemonic="gsmrm" key_field_value="1000000081.39" record_version_obj="1000000082.39" version_number_seq="2.39" import_version_number_seq="0"><required_manager_obj>1000000081.39</required_manager_obj>
<session_type_obj>1000000017.39</session_type_obj>
<startup_order>4</startup_order>
<manager_type_obj>1004947448.09</manager_type_obj>
<object_obj>1004956695.09</object_obj>
<system_owned>yes</system_owned>
</contained_record>
<contained_record DB="ICFDB" Table="gsm_required_manager" version_date="02/08/2002" version_time="33672" version_user="admin" entity_mnemonic="gsmrm" key_field_value="1000000083.39" record_version_obj="1000000084.39" version_number_seq="2.39" import_version_number_seq="0"><required_manager_obj>1000000083.39</required_manager_obj>
<session_type_obj>1000000017.39</session_type_obj>
<startup_order>5</startup_order>
<manager_type_obj>1004947430.09</manager_type_obj>
<object_obj>1004956696.09</object_obj>
<system_owned>yes</system_owned>
</contained_record>
<contained_record DB="ICFDB" Table="gsm_required_manager" version_date="02/08/2002" version_time="33678" version_user="admin" entity_mnemonic="gsmrm" key_field_value="1000000085.39" record_version_obj="1000000086.39" version_number_seq="2.39" import_version_number_seq="0"><required_manager_obj>1000000085.39</required_manager_obj>
<session_type_obj>1000000017.39</session_type_obj>
<startup_order>6</startup_order>
<manager_type_obj>1004947429.09</manager_type_obj>
<object_obj>1004956694.09</object_obj>
<system_owned>yes</system_owned>
</contained_record>
<contained_record DB="ICFDB" Table="gsm_required_manager" version_date="02/08/2002" version_time="33688" version_user="admin" entity_mnemonic="gsmrm" key_field_value="1000000087.39" record_version_obj="1000000088.39" version_number_seq="2.39" import_version_number_seq="0"><required_manager_obj>1000000087.39</required_manager_obj>
<session_type_obj>1000000017.39</session_type_obj>
<startup_order>7</startup_order>
<manager_type_obj>1004947432.09</manager_type_obj>
<object_obj>1004956697.09</object_obj>
<system_owned>yes</system_owned>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="5"><contained_record DB="ICFDB" Table="gsm_session_type"><session_type_obj>1004947449.09</session_type_obj>
<session_type_code>ICFDevAS</session_type_code>
<session_type_description>Dynamics Development with AS</session_type_description>
<physical_session_list>GUI</physical_session_list>
<valid_os_list>WIN32</valid_os_list>
<contained_record DB="ICFDB" Table="gsm_session_type_property"><session_type_property_obj>1004956690.09</session_type_property_obj>
<session_type_obj>1004947449.09</session_type_obj>
<session_property_obj>1004956689.09</session_property_obj>
<property_value>_ab.p</property_value>
</contained_record>
<contained_record DB="ICFDB" Table="gsm_session_type_property"><session_type_property_obj>1005079052.09</session_type_property_obj>
<session_type_obj>1004947449.09</session_type_obj>
<session_property_obj>1004955844.09</session_property_obj>
<property_value>NO</property_value>
</contained_record>
<contained_record DB="ICFDB" Table="gsm_session_service"><session_service_obj>1004947561.09</session_service_obj>
<session_type_obj>1004947449.09</session_type_obj>
<logical_service_obj>1004947455.09</logical_service_obj>
<physical_service_obj>1004947554.09</physical_service_obj>
</contained_record>
<contained_record DB="ICFDB" Table="gsm_session_service"><session_service_obj>1004947559.09</session_service_obj>
<session_type_obj>1004947449.09</session_type_obj>
<logical_service_obj>1004947456.09</logical_service_obj>
<physical_service_obj>1004947547.09</physical_service_obj>
</contained_record>
<contained_record DB="ICFDB" Table="gsm_session_service"><session_service_obj>1004947556.09</session_service_obj>
<session_type_obj>1004947449.09</session_type_obj>
<logical_service_obj>1004947458.09</logical_service_obj>
<physical_service_obj>1004947549.09</physical_service_obj>
</contained_record>
<contained_record DB="ICFDB" Table="gsm_required_manager"><required_manager_obj>1004955827.09</required_manager_obj>
<session_type_obj>1004947449.09</session_type_obj>
<startup_order>1</startup_order>
<manager_type_obj>1004947362.09</manager_type_obj>
<object_obj>1004955826.09</object_obj>
<system_owned>yes</system_owned>
</contained_record>
<contained_record DB="ICFDB" Table="gsm_required_manager"><required_manager_obj>1004956705.09</required_manager_obj>
<session_type_obj>1004947449.09</session_type_obj>
<startup_order>2</startup_order>
<manager_type_obj>1004947428.09</manager_type_obj>
<object_obj>1004956700.09</object_obj>
<system_owned>no</system_owned>
</contained_record>
<contained_record DB="ICFDB" Table="gsm_required_manager"><required_manager_obj>1004956706.09</required_manager_obj>
<session_type_obj>1004947449.09</session_type_obj>
<startup_order>3</startup_order>
<manager_type_obj>1004947448.09</manager_type_obj>
<object_obj>1004956704.09</object_obj>
<system_owned>no</system_owned>
</contained_record>
<contained_record DB="ICFDB" Table="gsm_required_manager"><required_manager_obj>1004956707.09</required_manager_obj>
<session_type_obj>1004947449.09</session_type_obj>
<startup_order>4</startup_order>
<manager_type_obj>1004947430.09</manager_type_obj>
<object_obj>1004956702.09</object_obj>
<system_owned>no</system_owned>
</contained_record>
<contained_record DB="ICFDB" Table="gsm_required_manager"><required_manager_obj>1004956723.09</required_manager_obj>
<session_type_obj>1004947449.09</session_type_obj>
<startup_order>5</startup_order>
<manager_type_obj>1004947431.09</manager_type_obj>
<object_obj>1004956699.09</object_obj>
<system_owned>no</system_owned>
</contained_record>
<contained_record DB="ICFDB" Table="gsm_required_manager"><required_manager_obj>1004956724.09</required_manager_obj>
<session_type_obj>1004947449.09</session_type_obj>
<startup_order>6</startup_order>
<manager_type_obj>1004947429.09</manager_type_obj>
<object_obj>1004956701.09</object_obj>
<system_owned>no</system_owned>
</contained_record>
<contained_record DB="ICFDB" Table="gsm_required_manager"><required_manager_obj>1004956725.09</required_manager_obj>
<session_type_obj>1004947449.09</session_type_obj>
<startup_order>7</startup_order>
<manager_type_obj>1004947432.09</manager_type_obj>
<object_obj>1004956703.09</object_obj>
<system_owned>no</system_owned>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="6"><contained_record DB="ICFDB" Table="gsm_session_type"><session_type_obj>1004947452.09</session_type_obj>
<session_type_code>ASICFDev</session_type_code>
<session_type_description>AppServer Service Type for ICF Dev</session_type_description>
<physical_session_list>APP</physical_session_list>
<valid_os_list>WIN32,UNIX</valid_os_list>
<contained_record DB="ICFDB" Table="gsm_session_type_property"><session_type_property_obj>1005080568.09</session_type_property_obj>
<session_type_obj>1004947452.09</session_type_obj>
<session_property_obj>1004955844.09</session_property_obj>
<property_value>YES</property_value>
</contained_record>
<contained_record DB="ICFDB" Table="gsm_session_service"><session_service_obj>1005080567.09</session_service_obj>
<session_type_obj>1004947452.09</session_type_obj>
<logical_service_obj>1004947455.09</logical_service_obj>
<physical_service_obj>1004947554.09</physical_service_obj>
</contained_record>
<contained_record DB="ICFDB" Table="gsm_session_service"><session_service_obj>1004956735.09</session_service_obj>
<session_type_obj>1004947452.09</session_type_obj>
<logical_service_obj>1004947456.09</logical_service_obj>
<physical_service_obj>1004947547.09</physical_service_obj>
</contained_record>
<contained_record DB="ICFDB" Table="gsm_session_service"><session_service_obj>1004956732.09</session_service_obj>
<session_type_obj>1004947452.09</session_type_obj>
<logical_service_obj>1004947458.09</logical_service_obj>
<physical_service_obj>1004947549.09</physical_service_obj>
</contained_record>
<contained_record DB="ICFDB" Table="gsm_required_manager"><required_manager_obj>1004956070.09</required_manager_obj>
<session_type_obj>1004947452.09</session_type_obj>
<startup_order>1</startup_order>
<manager_type_obj>1004947362.09</manager_type_obj>
<object_obj>1004955826.09</object_obj>
<system_owned>yes</system_owned>
</contained_record>
<contained_record DB="ICFDB" Table="gsm_required_manager"><required_manager_obj>1004956736.09</required_manager_obj>
<session_type_obj>1004947452.09</session_type_obj>
<startup_order>2</startup_order>
<manager_type_obj>1004947428.09</manager_type_obj>
<object_obj>1004956693.09</object_obj>
<system_owned>no</system_owned>
</contained_record>
<contained_record DB="ICFDB" Table="gsm_required_manager"><required_manager_obj>1004956737.09</required_manager_obj>
<session_type_obj>1004947452.09</session_type_obj>
<startup_order>3</startup_order>
<manager_type_obj>1004947448.09</manager_type_obj>
<object_obj>1004956695.09</object_obj>
<system_owned>no</system_owned>
</contained_record>
<contained_record DB="ICFDB" Table="gsm_required_manager"><required_manager_obj>1004956738.09</required_manager_obj>
<session_type_obj>1004947452.09</session_type_obj>
<startup_order>4</startup_order>
<manager_type_obj>1004947430.09</manager_type_obj>
<object_obj>1004956696.09</object_obj>
<system_owned>no</system_owned>
</contained_record>
<contained_record DB="ICFDB" Table="gsm_required_manager"><required_manager_obj>1004956739.09</required_manager_obj>
<session_type_obj>1004947452.09</session_type_obj>
<startup_order>5</startup_order>
<manager_type_obj>1004947431.09</manager_type_obj>
<object_obj>1004956698.09</object_obj>
<system_owned>no</system_owned>
</contained_record>
<contained_record DB="ICFDB" Table="gsm_required_manager"><required_manager_obj>1004956740.09</required_manager_obj>
<session_type_obj>1004947452.09</session_type_obj>
<startup_order>6</startup_order>
<manager_type_obj>1004947429.09</manager_type_obj>
<object_obj>1004956694.09</object_obj>
<system_owned>no</system_owned>
</contained_record>
<contained_record DB="ICFDB" Table="gsm_required_manager"><required_manager_obj>1004956741.09</required_manager_obj>
<session_type_obj>1004947452.09</session_type_obj>
<startup_order>7</startup_order>
<manager_type_obj>1004947432.09</manager_type_obj>
<object_obj>1004956697.09</object_obj>
<system_owned>no</system_owned>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="7"><contained_record DB="ICFDB" Table="gsm_session_type"><session_type_obj>1004955892.09</session_type_obj>
<session_type_code>ICFRuntime</session_type_code>
<session_type_description>Dynamics Run Time Environment</session_type_description>
<physical_session_list>GUI,WBC</physical_session_list>
<valid_os_list>WIN32</valid_os_list>
<contained_record DB="ICFDB" Table="gsm_session_type_property"><session_type_property_obj>1005079480.09</session_type_property_obj>
<session_type_obj>1004955892.09</session_type_obj>
<session_property_obj>1004956689.09</session_property_obj>
<property_value>ICFOBJ|afallmencw</property_value>
</contained_record>
<contained_record DB="ICFDB" Table="gsm_session_service"><session_service_obj>1004955894.09</session_service_obj>
<session_type_obj>1004955892.09</session_type_obj>
<logical_service_obj>1004947455.09</logical_service_obj>
<physical_service_obj>1004947554.09</physical_service_obj>
</contained_record>
<contained_record DB="ICFDB" Table="gsm_required_manager"><required_manager_obj>1004955909.09</required_manager_obj>
<session_type_obj>1004955892.09</session_type_obj>
<startup_order>1</startup_order>
<manager_type_obj>1004947362.09</manager_type_obj>
<object_obj>1004955826.09</object_obj>
<system_owned>yes</system_owned>
</contained_record>
<contained_record DB="ICFDB" Table="gsm_required_manager"><required_manager_obj>1004956726.09</required_manager_obj>
<session_type_obj>1004955892.09</session_type_obj>
<startup_order>2</startup_order>
<manager_type_obj>1004947428.09</manager_type_obj>
<object_obj>1004956700.09</object_obj>
<system_owned>no</system_owned>
</contained_record>
<contained_record DB="ICFDB" Table="gsm_required_manager"><required_manager_obj>1004956727.09</required_manager_obj>
<session_type_obj>1004955892.09</session_type_obj>
<startup_order>3</startup_order>
<manager_type_obj>1004947448.09</manager_type_obj>
<object_obj>1004956704.09</object_obj>
<system_owned>no</system_owned>
</contained_record>
<contained_record DB="ICFDB" Table="gsm_required_manager"><required_manager_obj>1004956728.09</required_manager_obj>
<session_type_obj>1004955892.09</session_type_obj>
<startup_order>4</startup_order>
<manager_type_obj>1004947430.09</manager_type_obj>
<object_obj>1004956702.09</object_obj>
<system_owned>no</system_owned>
</contained_record>
<contained_record DB="ICFDB" Table="gsm_required_manager"><required_manager_obj>1004956729.09</required_manager_obj>
<session_type_obj>1004955892.09</session_type_obj>
<startup_order>5</startup_order>
<manager_type_obj>1004947431.09</manager_type_obj>
<object_obj>1004956699.09</object_obj>
<system_owned>no</system_owned>
</contained_record>
<contained_record DB="ICFDB" Table="gsm_required_manager"><required_manager_obj>1004956730.09</required_manager_obj>
<session_type_obj>1004955892.09</session_type_obj>
<startup_order>6</startup_order>
<manager_type_obj>1004947429.09</manager_type_obj>
<object_obj>1004956701.09</object_obj>
<system_owned>no</system_owned>
</contained_record>
<contained_record DB="ICFDB" Table="gsm_required_manager"><required_manager_obj>1004956731.09</required_manager_obj>
<session_type_obj>1004955892.09</session_type_obj>
<startup_order>7</startup_order>
<manager_type_obj>1004947432.09</manager_type_obj>
<object_obj>1004956703.09</object_obj>
<system_owned>no</system_owned>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="8"><contained_record DB="ICFDB" Table="gsm_session_type"><session_type_obj>1005079481.09</session_type_obj>
<session_type_code>Default</session_type_code>
<session_type_description>Default Session Type</session_type_description>
<physical_session_list>GUI</physical_session_list>
<valid_os_list>WIN32</valid_os_list>
<contained_record DB="ICFDB" Table="gsm_session_type_property"><session_type_property_obj>1005079492.09</session_type_property_obj>
<session_type_obj>1005079481.09</session_type_obj>
<session_property_obj>1004955844.09</session_property_obj>
<property_value>yes</property_value>
</contained_record>
<contained_record DB="ICFDB" Table="gsm_session_type_property"><session_type_property_obj>1005079493.09</session_type_property_obj>
<session_type_obj>1005079481.09</session_type_obj>
<session_property_obj>1004956689.09</session_property_obj>
<property_value>ICFOBJ|afallmencw</property_value>
</contained_record>
<contained_record DB="ICFDB" Table="gsm_session_service"><session_service_obj>1005079482.09</session_service_obj>
<session_type_obj>1005079481.09</session_type_obj>
<logical_service_obj>1004947455.09</logical_service_obj>
<physical_service_obj>1004947554.09</physical_service_obj>
</contained_record>
<contained_record DB="ICFDB" Table="gsm_session_service"><session_service_obj>1005079484.09</session_service_obj>
<session_type_obj>1005079481.09</session_type_obj>
<logical_service_obj>1004947456.09</logical_service_obj>
<physical_service_obj>1004947547.09</physical_service_obj>
</contained_record>
<contained_record DB="ICFDB" Table="gsm_session_service"><session_service_obj>1005079483.09</session_service_obj>
<session_type_obj>1005079481.09</session_type_obj>
<logical_service_obj>1004947458.09</logical_service_obj>
<physical_service_obj>1004947549.09</physical_service_obj>
</contained_record>
<contained_record DB="ICFDB" Table="gsm_required_manager"><required_manager_obj>1005079485.09</required_manager_obj>
<session_type_obj>1005079481.09</session_type_obj>
<startup_order>1</startup_order>
<manager_type_obj>1004947362.09</manager_type_obj>
<object_obj>1004955826.09</object_obj>
<system_owned>yes</system_owned>
</contained_record>
<contained_record DB="ICFDB" Table="gsm_required_manager"><required_manager_obj>1005079486.09</required_manager_obj>
<session_type_obj>1005079481.09</session_type_obj>
<startup_order>2</startup_order>
<manager_type_obj>1004947428.09</manager_type_obj>
<object_obj>1004956693.09</object_obj>
<system_owned>yes</system_owned>
</contained_record>
<contained_record DB="ICFDB" Table="gsm_required_manager"><required_manager_obj>1005079487.09</required_manager_obj>
<session_type_obj>1005079481.09</session_type_obj>
<startup_order>3</startup_order>
<manager_type_obj>1004947431.09</manager_type_obj>
<object_obj>1004956698.09</object_obj>
<system_owned>yes</system_owned>
</contained_record>
<contained_record DB="ICFDB" Table="gsm_required_manager"><required_manager_obj>1005079488.09</required_manager_obj>
<session_type_obj>1005079481.09</session_type_obj>
<startup_order>4</startup_order>
<manager_type_obj>1004947448.09</manager_type_obj>
<object_obj>1004956695.09</object_obj>
<system_owned>yes</system_owned>
</contained_record>
<contained_record DB="ICFDB" Table="gsm_required_manager"><required_manager_obj>1005079489.09</required_manager_obj>
<session_type_obj>1005079481.09</session_type_obj>
<startup_order>5</startup_order>
<manager_type_obj>1004947430.09</manager_type_obj>
<object_obj>1004956696.09</object_obj>
<system_owned>yes</system_owned>
</contained_record>
<contained_record DB="ICFDB" Table="gsm_required_manager"><required_manager_obj>1005079490.09</required_manager_obj>
<session_type_obj>1005079481.09</session_type_obj>
<startup_order>6</startup_order>
<manager_type_obj>1004947429.09</manager_type_obj>
<object_obj>1004956694.09</object_obj>
<system_owned>yes</system_owned>
</contained_record>
<contained_record DB="ICFDB" Table="gsm_required_manager"><required_manager_obj>1005079491.09</required_manager_obj>
<session_type_obj>1005079481.09</session_type_obj>
<startup_order>7</startup_order>
<manager_type_obj>1004947432.09</manager_type_obj>
<object_obj>1004956697.09</object_obj>
<system_owned>yes</system_owned>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="9"><contained_record DB="ICFDB" Table="gsm_session_type"><session_type_obj>1005080066.09</session_type_obj>
<session_type_code>ICFDev</session_type_code>
<session_type_description>Dynamics Development Environment</session_type_description>
<physical_session_list>GUI</physical_session_list>
<valid_os_list>WIN32</valid_os_list>
<contained_record DB="ICFDB" Table="gsm_session_type_property"><session_type_property_obj>1005080077.09</session_type_property_obj>
<session_type_obj>1005080066.09</session_type_obj>
<session_property_obj>1004955844.09</session_property_obj>
<property_value>YES</property_value>
</contained_record>
<contained_record DB="ICFDB" Table="gsm_session_type_property"><session_type_property_obj>1005080078.09</session_type_property_obj>
<session_type_obj>1005080066.09</session_type_obj>
<session_property_obj>1004956689.09</session_property_obj>
<property_value>_ab.p</property_value>
</contained_record>
<contained_record DB="ICFDB" Table="gsm_session_service"><session_service_obj>1005080067.09</session_service_obj>
<session_type_obj>1005080066.09</session_type_obj>
<logical_service_obj>1004947455.09</logical_service_obj>
<physical_service_obj>1004947554.09</physical_service_obj>
</contained_record>
<contained_record DB="ICFDB" Table="gsm_session_service"><session_service_obj>1005080069.09</session_service_obj>
<session_type_obj>1005080066.09</session_type_obj>
<logical_service_obj>1004947456.09</logical_service_obj>
<physical_service_obj>1004947547.09</physical_service_obj>
</contained_record>
<contained_record DB="ICFDB" Table="gsm_session_service"><session_service_obj>1005080068.09</session_service_obj>
<session_type_obj>1005080066.09</session_type_obj>
<logical_service_obj>1004947458.09</logical_service_obj>
<physical_service_obj>1004947549.09</physical_service_obj>
</contained_record>
<contained_record DB="ICFDB" Table="gsm_required_manager"><required_manager_obj>1005080070.09</required_manager_obj>
<session_type_obj>1005080066.09</session_type_obj>
<startup_order>1</startup_order>
<manager_type_obj>1004947362.09</manager_type_obj>
<object_obj>1004955826.09</object_obj>
<system_owned>yes</system_owned>
</contained_record>
<contained_record DB="ICFDB" Table="gsm_required_manager"><required_manager_obj>1005080072.09</required_manager_obj>
<session_type_obj>1005080066.09</session_type_obj>
<startup_order>2</startup_order>
<manager_type_obj>1004947428.09</manager_type_obj>
<object_obj>1004956693.09</object_obj>
<system_owned>yes</system_owned>
</contained_record>
<contained_record DB="ICFDB" Table="gsm_required_manager"><required_manager_obj>1005080073.09</required_manager_obj>
<session_type_obj>1005080066.09</session_type_obj>
<startup_order>3</startup_order>
<manager_type_obj>1004947431.09</manager_type_obj>
<object_obj>1004956698.09</object_obj>
<system_owned>yes</system_owned>
</contained_record>
<contained_record DB="ICFDB" Table="gsm_required_manager"><required_manager_obj>1005080074.09</required_manager_obj>
<session_type_obj>1005080066.09</session_type_obj>
<startup_order>4</startup_order>
<manager_type_obj>1004947429.09</manager_type_obj>
<object_obj>1004956694.09</object_obj>
<system_owned>yes</system_owned>
</contained_record>
<contained_record DB="ICFDB" Table="gsm_required_manager"><required_manager_obj>1005080071.09</required_manager_obj>
<session_type_obj>1005080066.09</session_type_obj>
<startup_order>5</startup_order>
<manager_type_obj>1004947448.09</manager_type_obj>
<object_obj>1004956695.09</object_obj>
<system_owned>no</system_owned>
</contained_record>
<contained_record DB="ICFDB" Table="gsm_required_manager"><required_manager_obj>1005080075.09</required_manager_obj>
<session_type_obj>1005080066.09</session_type_obj>
<startup_order>6</startup_order>
<manager_type_obj>1004947432.09</manager_type_obj>
<object_obj>1004956697.09</object_obj>
<system_owned>yes</system_owned>
</contained_record>
<contained_record DB="ICFDB" Table="gsm_required_manager"><required_manager_obj>1005080076.09</required_manager_obj>
<session_type_obj>1005080066.09</session_type_obj>
<startup_order>7</startup_order>
<manager_type_obj>1004947430.09</manager_type_obj>
<object_obj>1004956696.09</object_obj>
<system_owned>yes</system_owned>
</contained_record>
</contained_record>
</dataset_transaction>
</dataset_records>
</dataset>