<?xml version="1.0" encoding="utf-8" ?>
<dataset Transactions="9" deletion_flag="no" entity_mnemonic="GSTDF" import_version_number_seq="3.39" key_field_value="3000033319.09" record_version_obj="100000006126.39" secondary_key_value="" version_date="10/04/2007" version_number_seq="4.39" version_time="51891" version_user="admin"><dataset_header DatasetCode="GSMPY" DatasetObj="3000005366.09" DateFormat="mdy" DisableRI="yes" FullHeader="no" NumericDecimal="." NumericFormat="AMERICAN" NumericSeparator="," OriginatingSite="94" SCMManaged="no" YearOffset="1950"/>
<dataset_records><dataset_transaction TransactionNo="1" TransactionType="DELETION"><contained_record deletion_flag="yes" entity_mnemonic="gsmpy" import_version_number_seq="1.09" key_field_value="1004947546.09" record_version_obj="3000001847.09" secondary_key_value="RVDBd" version_date="03/01/2002" version_number_seq="1.09" version_time="55653" version_user="admin"/>
</dataset_transaction>
<dataset_transaction TransactionNo="2" TransactionType="DELETION"><contained_record deletion_flag="yes" entity_mnemonic="gsmpy" import_version_number_seq="1.09" key_field_value="1004947547.09" record_version_obj="3000001846.09" secondary_key_value="RVDBn" version_date="03/01/2002" version_number_seq="1.09" version_time="55649" version_user="admin"/>
</dataset_transaction>
<dataset_transaction TransactionNo="3" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_physical_service" deletion_flag="no" entity_mnemonic="gsmpy" import_version_number_seq="9.49" key_field_value="1000000003.39" record_version_obj="1000000004.39" secondary_key_value="asb_093dyndep" version_date="05/01/2007" version_number_seq="9.49" version_time="54869" version_user="admin"><physical_service_obj>1000000003.39</physical_service_obj>
<physical_service_code>asb_093dyndep</physical_service_code>
<physical_service_description>Dynamics AppServer for Roundtable</physical_service_description>
<service_type_obj>1004947358.09</service_type_obj>
<connection_parameters>R#CHR(3)#-H localhost -S NS1 -AppService asb_093dyndep</connection_parameters>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="4" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_physical_service" deletion_flag="no" entity_mnemonic="gsmpy" import_version_number_seq="7.49" key_field_value="1000000005.39" record_version_obj="1000000006.39" secondary_key_value="asb_094dyndev" version_date="05/01/2007" version_number_seq="7.49" version_time="54869" version_user="admin"><physical_service_obj>1000000005.39</physical_service_obj>
<physical_service_code>asb_094dyndev</physical_service_code>
<physical_service_description>Dynamics AppServer for Roundtable</physical_service_description>
<service_type_obj>1004947358.09</service_type_obj>
<connection_parameters>R#CHR(3)#-H localhost -S NS1 -AppService asb_094dyndev</connection_parameters>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="5" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_physical_service" deletion_flag="no" entity_mnemonic="gsmpy" import_version_number_seq="7.49" key_field_value="1000000007.39" record_version_obj="1000000008.39" secondary_key_value="asb_094dyndep" version_date="05/01/2007" version_number_seq="7.49" version_time="54869" version_user="admin"><physical_service_obj>1000000007.39</physical_service_obj>
<physical_service_code>asb_094dyndep</physical_service_code>
<physical_service_description>Dynamics AppServer for Roundtable</physical_service_description>
<service_type_obj>1004947358.09</service_type_obj>
<connection_parameters>R#CHR(3)#-H localhost -S NS1 -AppService asb_094dyndep</connection_parameters>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="6" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_physical_service" deletion_flag="no" entity_mnemonic="gsmpy" import_version_number_seq="7.49" key_field_value="1000000009.39" record_version_obj="1000000010.39" secondary_key_value="asb_094dyntst" version_date="05/01/2007" version_number_seq="7.49" version_time="54869" version_user="admin"><physical_service_obj>1000000009.39</physical_service_obj>
<physical_service_code>asb_094dyntst</physical_service_code>
<physical_service_description>Dynamics AppServer for Roundtable</physical_service_description>
<service_type_obj>1004947358.09</service_type_obj>
<connection_parameters>R#CHR(3)#-H localhost -S NS1 -AppService asb_094dyntst</connection_parameters>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="7" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_physical_service" deletion_flag="no" entity_mnemonic="gsmpy" import_version_number_seq="1.09" key_field_value="1004947548.09" record_version_obj="3000059019.09" secondary_key_value="ICFDBd" version_date="10/04/2007" version_number_seq="3.49" version_time="51852" version_user="admin"><physical_service_obj>1004947548.09</physical_service_obj>
<physical_service_code>ICFDBd</physical_service_code>
<physical_service_description>Direct connection to Dynamics DB</physical_service_description>
<service_type_obj>1004947359.09</service_type_obj>
<connection_parameters>-db &lt;workarea&gt;\database\icfdb\icfdb.db</connection_parameters>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="8" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_physical_service" deletion_flag="no" entity_mnemonic="GSMPY" import_version_number_seq="1.09" key_field_value="1004947549.09" record_version_obj="3000059020.09" secondary_key_value="ICFDBn" version_date="10/02/2003" version_number_seq="1.09" version_time="49466" version_user="admin"><physical_service_obj>1004947549.09</physical_service_obj>
<physical_service_code>ICFDBn</physical_service_code>
<physical_service_description>Network connect to ICFDB</physical_service_description>
<service_type_obj>1004947359.09</service_type_obj>
<connection_parameters>-db icfdb -N TCP -H localhost -S icfdb</connection_parameters>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="9" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_physical_service" deletion_flag="no" entity_mnemonic="GSMPY" import_version_number_seq="1.09" key_field_value="1004947554.09" record_version_obj="3000059021.09" secondary_key_value="ICFDevAS" version_date="10/02/2003" version_number_seq="1.09" version_time="49466" version_user="admin"><physical_service_obj>1004947554.09</physical_service_obj>
<physical_service_code>ICFDevAS</physical_service_code>
<physical_service_description>Dynamics Development AppServer</physical_service_description>
<service_type_obj>1004947358.09</service_type_obj>
<connection_parameters>R#CHR(3)#-H localhost -S NS1 -AppService icfrepos</connection_parameters>
</contained_record>
</dataset_transaction>
</dataset_records>
</dataset>