<?xml version="1.0" encoding="ISO8859-1" ?>
<dataset Transactions="8" version_date="02/23/2002" version_time="43008" version_user="admin" entity_mnemonic="GSTDF" key_field_value="3000000401.09" record_version_obj="3000000402.09" version_number_seq="2.09" import_version_number_seq="1.09"><dataset_header DisableRI="yes" DatasetObj="1007600166.08" DateFormat="mdy" FullHeader="yes" SCMManaged="no" YearOffset="1950" DatasetCode="GSCPR" DateCreated="02/23/2002" TimeCreated="11:56:44" NumericFormat="AMERICAN" NumericDecimal="." OriginatingSite="93" NumericSeparator=","><deploy_dataset_obj>1007600166.08</deploy_dataset_obj>
<owner_site_code></owner_site_code>
<dataset_code>GSCPR</dataset_code>
<dataset_description>gsc_product - Products and Modules</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<dataset_entity><dataset_entity_obj>1007600167.08</dataset_entity_obj>
<deploy_dataset_obj>1007600166.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSCPR</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>product_code</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<entity_mnemonic_description>gsc_product</entity_mnemonic_description>
<entity_dbname>icfdb</entity_dbname>
</dataset_entity>
<dataset_entity><dataset_entity_obj>1007600168.08</dataset_entity_obj>
<deploy_dataset_obj>1007600166.08</deploy_dataset_obj>
<entity_sequence>2</entity_sequence>
<entity_mnemonic>GSCPM</entity_mnemonic>
<primary_entity>no</primary_entity>
<join_entity_mnemonic>GSCPR</join_entity_mnemonic>
<join_field_list>product_obj,product_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<entity_mnemonic_description>gsc_product_module</entity_mnemonic_description>
<entity_dbname>icfdb</entity_dbname>
</dataset_entity>
<table_definition><name>gsc_product</name>
<dbname>ICFDB</dbname>
<index-1>XAK1gsc_product,1,0,0,product_code,0</index-1>
<index-2>XIE1gsc_product,0,0,0,product_description,0</index-2>
<index-3>XIE2gsc_product,0,0,0,supplier_organisation_obj,0</index-3>
<index-4>XPKgsc_product,1,1,0,product_obj,0</index-4>
<field><name>product_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>>>>>>>>>>>>>>>>>>9.999999999</format>
<initial>                 0.000000000</initial>
<label>Product Obj</label>
<column-label>Product Obj</column-label>
</field>
<field><name>product_code</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(10)</format>
<initial></initial>
<label>Product Code</label>
<column-label>Product Code</column-label>
</field>
<field><name>product_description</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>Product Description</label>
<column-label>Product Description</column-label>
</field>
<field><name>product_installed</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>Product Installed</label>
<column-label>Product Installed</column-label>
</field>
<field><name>number_of_users</name>
<data-type>integer</data-type>
<extent>0</extent>
<format>->>>>>9</format>
<initial>      0</initial>
<label>Number of Users</label>
<column-label>Number of Users</column-label>
</field>
<field><name>db_connection_pf_file</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Db Connection Pf File</label>
<column-label>Db Connection Pf File</column-label>
</field>
<field><name>supplier_organisation_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>>>>>>>>>>>>>>>>>>9.999999999</format>
<initial>                 0.000000000</initial>
<label>Supplier Organisation Obj</label>
<column-label>Supplier Organisation Obj</column-label>
</field>
</table_definition>
<table_definition><name>gsc_product_module</name>
<dbname>ICFDB</dbname>
<index-1>XAK1gsc_product_module,1,0,0,product_module_code,0</index-1>
<index-2>XIE1gsc_product_module,0,0,0,product_module_description,0</index-2>
<index-3>XIE2gsc_product_module,0,0,0,product_obj,0,product_module_code,0</index-3>
<index-4>XPKgsc_product_module,1,1,0,product_module_obj,0</index-4>
<field><name>product_module_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>>>>>>>>>>>>>>>>>>9.999999999</format>
<initial>                 0.000000000</initial>
<label>Product Module Obj</label>
<column-label>Product Module Obj</column-label>
</field>
<field><name>product_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>>>>>>>>>>>>>>>>>>9.999999999</format>
<initial>                 0.000000000</initial>
<label>Product Obj</label>
<column-label>Product Obj</column-label>
</field>
<field><name>product_module_code</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(10)</format>
<initial></initial>
<label>Product Module Code</label>
<column-label>Product Module Code</column-label>
</field>
<field><name>product_module_description</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>Product Module Description</label>
<column-label>Product Module Description</column-label>
</field>
<field><name>product_module_installed</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>Product Module Installed</label>
<column-label>Product Module Installed</column-label>
</field>
<field><name>number_of_users</name>
<data-type>integer</data-type>
<extent>0</extent>
<format>->>>>>9</format>
<initial>      0</initial>
<label>Number of Users</label>
<column-label>Number of Users</column-label>
</field>
<field><name>db_connection_pf_file</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Db Connection Pf File</label>
<column-label>Db Connection Pf File</column-label>
</field>
<field><name>relative_path</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Relative Path</label>
<column-label>Relative Path</column-label>
</field>
</table_definition>
</dataset_header>
<dataset_records><dataset_transaction TransactionNo="1"><contained_record DB="ICFDB" Table="gsc_product" version_date="02/08/2002" version_time="34160" version_user="admin" entity_mnemonic="gscpr" key_field_value="1000000091.39" record_version_obj="1000000092.39" version_number_seq="3.39" import_version_number_seq="0"><product_obj>1000000091.39</product_obj>
<product_code>090DCU</product_code>
<product_description>ICF Install (090DCU)</product_description>
<product_installed>yes</product_installed>
<number_of_users>0</number_of_users>
<db_connection_pf_file></db_connection_pf_file>
<supplier_organisation_obj>0</supplier_organisation_obj>
<contained_record DB="ICFDB" Table="gsc_product_module" version_date="02/08/2002" version_time="36146" version_user="admin" entity_mnemonic="gscpm" key_field_value="1000000127.39" record_version_obj="1000000128.39" version_number_seq="2.39" import_version_number_seq="0"><product_module_obj>1000000127.39</product_module_obj>
<product_obj>1000000091.39</product_obj>
<product_module_code>dcu-img</product_module_code>
<product_module_description>DCU Install Images</product_module_description>
<product_module_installed>yes</product_module_installed>
<number_of_users>0</number_of_users>
<db_connection_pf_file></db_connection_pf_file>
<relative_path>install/img</relative_path>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_product_module" version_date="02/08/2002" version_time="36135" version_user="admin" entity_mnemonic="gscpm" key_field_value="1000000125.39" record_version_obj="1000000126.39" version_number_seq="2.39" import_version_number_seq="0"><product_module_obj>1000000125.39</product_module_obj>
<product_obj>1000000091.39</product_obj>
<product_module_code>dcu-inc</product_module_code>
<product_module_description>DCU Install Includes</product_module_description>
<product_module_installed>yes</product_module_installed>
<number_of_users>0</number_of_users>
<db_connection_pf_file></db_connection_pf_file>
<relative_path>install/inc</relative_path>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_product_module" version_date="02/08/2002" version_time="36102" version_user="admin" entity_mnemonic="gscpm" key_field_value="1000000119.39" record_version_obj="1000000120.39" version_number_seq="2.39" import_version_number_seq="0"><product_module_obj>1000000119.39</product_module_obj>
<product_obj>1000000091.39</product_obj>
<product_module_code>dcu-obj</product_module_code>
<product_module_description>DCU Install Objects</product_module_description>
<product_module_installed>yes</product_module_installed>
<number_of_users>0</number_of_users>
<db_connection_pf_file></db_connection_pf_file>
<relative_path>install/obj</relative_path>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_product_module" version_date="02/08/2002" version_time="36126" version_user="admin" entity_mnemonic="gscpm" key_field_value="1000000123.39" record_version_obj="1000000124.39" version_number_seq="2.39" import_version_number_seq="0"><product_module_obj>1000000123.39</product_module_obj>
<product_obj>1000000091.39</product_obj>
<product_module_code>dcu-prc</product_module_code>
<product_module_description>DCU Install Procedures</product_module_description>
<product_module_installed>yes</product_module_installed>
<number_of_users>0</number_of_users>
<db_connection_pf_file></db_connection_pf_file>
<relative_path>install/prc</relative_path>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_product_module" version_date="02/08/2002" version_time="36116" version_user="admin" entity_mnemonic="gscpm" key_field_value="1000000121.39" record_version_obj="1000000122.39" version_number_seq="2.39" import_version_number_seq="0"><product_module_obj>1000000121.39</product_module_obj>
<product_obj>1000000091.39</product_obj>
<product_module_code>dcu-uib</product_module_code>
<product_module_description>DCU Install Containers</product_module_description>
<product_module_installed>yes</product_module_installed>
<number_of_users>0</number_of_users>
<db_connection_pf_file></db_connection_pf_file>
<relative_path>install/uib</relative_path>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="2"><contained_record DB="ICFDB" Table="gsc_product" version_date="02/08/2002" version_time="34220" version_user="admin" entity_mnemonic="gscpr" key_field_value="1000000093.39" record_version_obj="1000000094.39" version_number_seq="3.39" import_version_number_seq="0"><product_obj>1000000093.39</product_obj>
<product_code>090ICF</product_code>
<product_description>ICF Framework (090ICF)</product_description>
<product_installed>yes</product_installed>
<number_of_users>0</number_of_users>
<db_connection_pf_file></db_connection_pf_file>
<supplier_organisation_obj>0</supplier_organisation_obj>
<contained_record DB="ICFDB" Table="gsc_product_module" version_date="02/08/2002" version_time="36181" version_user="admin" entity_mnemonic="gscpm" key_field_value="1000000129.39" record_version_obj="1000000130.39" version_number_seq="2.39" import_version_number_seq="0"><product_module_obj>1000000129.39</product_module_obj>
<product_obj>1000000093.39</product_obj>
<product_module_code>icf-trg</product_module_code>
<product_module_description>ICF Database Triggers</product_module_description>
<product_module_installed>yes</product_module_installed>
<number_of_users>0</number_of_users>
<db_connection_pf_file></db_connection_pf_file>
<relative_path>icf/trg</relative_path>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="3"><contained_record DB="ICFDB" Table="gsc_product" version_date="02/08/2002" version_time="34210" version_user="admin" entity_mnemonic="gscpr" key_field_value="1000000095.39" record_version_obj="1000000096.39" version_number_seq="2.39" import_version_number_seq="0"><product_obj>1000000095.39</product_obj>
<product_code>090SCM</product_code>
<product_description>ICF SCM Custom (090SCM)</product_description>
<product_installed>yes</product_installed>
<number_of_users>0</number_of_users>
<db_connection_pf_file></db_connection_pf_file>
<supplier_organisation_obj>0</supplier_organisation_obj>
<contained_record DB="ICFDB" Table="gsc_product_module" version_date="02/08/2002" version_time="37094" version_user="admin" entity_mnemonic="gscpm" key_field_value="1000000135.39" record_version_obj="1000000136.39" version_number_seq="5.39" import_version_number_seq="0"><product_module_obj>1000000135.39</product_module_obj>
<product_obj>1000000095.39</product_obj>
<product_module_code>scmrtb-aaa</product_module_code>
<product_module_description>SCM Custom Root</product_module_description>
<product_module_installed>yes</product_module_installed>
<number_of_users>0</number_of_users>
<db_connection_pf_file></db_connection_pf_file>
<relative_path>scm/custom</relative_path>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_product_module" version_date="02/08/2002" version_time="37470" version_user="admin" entity_mnemonic="gscpm" key_field_value="1000000137.39" record_version_obj="1000000138.39" version_number_seq="4.39" import_version_number_seq="0"><product_module_obj>1000000137.39</product_module_obj>
<product_obj>1000000095.39</product_obj>
<product_module_code>scmrtb-adecomm</product_module_code>
<product_module_description>SCM Custom Adecomm</product_module_description>
<product_module_installed>yes</product_module_installed>
<number_of_users>0</number_of_users>
<db_connection_pf_file></db_connection_pf_file>
<relative_path>scm/custom/rtb/adecomm</relative_path>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_product_module" version_date="02/08/2002" version_time="40223" version_user="admin" entity_mnemonic="gscpm" key_field_value="1000000145.39" record_version_obj="1000000146.39" version_number_seq="3.39" import_version_number_seq="0"><product_module_obj>1000000145.39</product_module_obj>
<product_obj>1000000095.39</product_obj>
<product_module_code>scmrtb-p</product_module_code>
<product_module_description>SCM Custom p directory</product_module_description>
<product_module_installed>yes</product_module_installed>
<number_of_users>0</number_of_users>
<db_connection_pf_file></db_connection_pf_file>
<relative_path>scm/custom/rtb/p</relative_path>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_product_module" version_date="02/08/2002" version_time="37374" version_user="admin" entity_mnemonic="gscpm" key_field_value="1000000139.39" record_version_obj="1000000140.39" version_number_seq="5.39" import_version_number_seq="0"><product_module_obj>1000000139.39</product_module_obj>
<product_obj>1000000095.39</product_obj>
<product_module_code>scmrtb-rtb</product_module_code>
<product_module_description>SCM Custom rtb directory</product_module_description>
<product_module_installed>yes</product_module_installed>
<number_of_users>0</number_of_users>
<db_connection_pf_file></db_connection_pf_file>
<relative_path>scm/custom/rtb</relative_path>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="4"><contained_record DB="ICFDB" Table="gsc_product"><product_obj>1004874669.09</product_obj>
<product_code>090AF</product_code>
<product_description>ICF Framework (090AF)</product_description>
<product_installed>yes</product_installed>
<number_of_users>0</number_of_users>
<db_connection_pf_file></db_connection_pf_file>
<supplier_organisation_obj>0</supplier_organisation_obj>
<contained_record DB="ICFDB" Table="gsc_product_module"><product_module_obj>1004874674.09</product_module_obj>
<product_obj>1004874669.09</product_obj>
<product_module_code>af-aaa</product_module_code>
<product_module_description>ICF Root Directory</product_module_description>
<product_module_installed>yes</product_module_installed>
<number_of_users>0</number_of_users>
<db_connection_pf_file></db_connection_pf_file>
<relative_path></relative_path>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_product_module"><product_module_obj>1004874676.09</product_module_obj>
<product_obj>1004874669.09</product_obj>
<product_module_code>af-app</product_module_code>
<product_module_description>ICF Appserver Procedures</product_module_description>
<product_module_installed>yes</product_module_installed>
<number_of_users>0</number_of_users>
<db_connection_pf_file></db_connection_pf_file>
<relative_path>af/app</relative_path>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_product_module"><product_module_obj>1004874677.09</product_module_obj>
<product_obj>1004874669.09</product_obj>
<product_module_code>af-bmp</product_module_code>
<product_module_description>ICF Images</product_module_description>
<product_module_installed>yes</product_module_installed>
<number_of_users>0</number_of_users>
<db_connection_pf_file></db_connection_pf_file>
<relative_path>af/bmp</relative_path>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_product_module"><product_module_obj>1004874678.09</product_module_obj>
<product_obj>1004874669.09</product_obj>
<product_module_code>af-cod</product_module_code>
<product_module_description>ICF Old Containers</product_module_description>
<product_module_installed>yes</product_module_installed>
<number_of_users>0</number_of_users>
<db_connection_pf_file></db_connection_pf_file>
<relative_path>af/cod</relative_path>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_product_module"><product_module_obj>1004874679.09</product_module_obj>
<product_obj>1004874669.09</product_obj>
<product_module_code>af-cod2</product_module_code>
<product_module_description>ICF New Containers</product_module_description>
<product_module_installed>yes</product_module_installed>
<number_of_users>0</number_of_users>
<db_connection_pf_file></db_connection_pf_file>
<relative_path>af/cod2</relative_path>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_product_module"><product_module_obj>1004874681.09</product_module_obj>
<product_obj>1004874669.09</product_obj>
<product_module_code>af-doc</product_module_code>
<product_module_description>ICF Documentation</product_module_description>
<product_module_installed>yes</product_module_installed>
<number_of_users>0</number_of_users>
<db_connection_pf_file></db_connection_pf_file>
<relative_path>af/doc</relative_path>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_product_module"><product_module_obj>1004874683.09</product_module_obj>
<product_obj>1004874669.09</product_obj>
<product_module_code>af-obj2</product_module_code>
<product_module_description>ICF Objects</product_module_description>
<product_module_installed>yes</product_module_installed>
<number_of_users>0</number_of_users>
<db_connection_pf_file></db_connection_pf_file>
<relative_path>af/obj2</relative_path>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_product_module"><product_module_obj>1004874684.09</product_module_obj>
<product_obj>1004874669.09</product_obj>
<product_module_code>af-rep</product_module_code>
<product_module_description>ICF Reports</product_module_description>
<product_module_installed>yes</product_module_installed>
<number_of_users>0</number_of_users>
<db_connection_pf_file></db_connection_pf_file>
<relative_path>af/rep</relative_path>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_product_module"><product_module_obj>1004874686.09</product_module_obj>
<product_obj>1004874669.09</product_obj>
<product_module_code>af-spl</product_module_code>
<product_module_description>ICF Report Spool Files</product_module_description>
<product_module_installed>yes</product_module_installed>
<number_of_users>0</number_of_users>
<db_connection_pf_file></db_connection_pf_file>
<relative_path>spool</relative_path>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_product_module"><product_module_obj>1004874687.09</product_module_obj>
<product_obj>1004874669.09</product_obj>
<product_module_code>af-sup</product_module_code>
<product_module_description>ICF Old Support Files</product_module_description>
<product_module_installed>yes</product_module_installed>
<number_of_users>0</number_of_users>
<db_connection_pf_file></db_connection_pf_file>
<relative_path>af/sup</relative_path>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_product_module"><product_module_obj>1004874688.09</product_module_obj>
<product_obj>1004874669.09</product_obj>
<product_module_code>af-sup2</product_module_code>
<product_module_description>ICF New Support Files</product_module_description>
<product_module_installed>yes</product_module_installed>
<number_of_users>0</number_of_users>
<db_connection_pf_file></db_connection_pf_file>
<relative_path>af/sup2</relative_path>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="5"><contained_record DB="ICFDB" Table="gsc_product"><product_obj>1004874670.09</product_obj>
<product_code>090AFDB</product_code>
<product_description>ICF Application Database (090AFDB)</product_description>
<product_installed>yes</product_installed>
<number_of_users>0</number_of_users>
<db_connection_pf_file></db_connection_pf_file>
<supplier_organisation_obj>0</supplier_organisation_obj>
<contained_record DB="ICFDB" Table="gsc_product_module" version_date="02/08/2002" version_time="35406" version_user="admin" entity_mnemonic="gscpm" key_field_value="1000000097.39" record_version_obj="1000000098.39" version_number_seq="2.39" import_version_number_seq="0"><product_module_obj>1000000097.39</product_module_obj>
<product_obj>1004874670.09</product_obj>
<product_module_code>db-aferw</product_module_code>
<product_module_description>ERwin Macro Code</product_module_description>
<product_module_installed>yes</product_module_installed>
<number_of_users>0</number_of_users>
<db_connection_pf_file></db_connection_pf_file>
<relative_path>db/af/erw</relative_path>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_product_module" version_date="02/08/2002" version_time="35474" version_user="admin" entity_mnemonic="gscpm" key_field_value="1000000099.39" record_version_obj="1000000100.39" version_number_seq="2.39" import_version_number_seq="0"><product_module_obj>1000000099.39</product_module_obj>
<product_obj>1004874670.09</product_obj>
<product_module_code>db-icfdb</product_module_code>
<product_module_description>Database ICFDB</product_module_description>
<product_module_installed>yes</product_module_installed>
<number_of_users>0</number_of_users>
<db_connection_pf_file></db_connection_pf_file>
<relative_path></relative_path>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_product_module" version_date="02/08/2002" version_time="35834" version_user="admin" entity_mnemonic="gscpm" key_field_value="1000000101.39" record_version_obj="1000000102.39" version_number_seq="3.39" import_version_number_seq="0"><product_module_obj>1000000101.39</product_module_obj>
<product_obj>1004874670.09</product_obj>
<product_module_code>db-icfdfd</product_module_code>
<product_module_description>Database ICFDB Definitions</product_module_description>
<product_module_installed>yes</product_module_installed>
<number_of_users>0</number_of_users>
<db_connection_pf_file></db_connection_pf_file>
<relative_path>db/icf/dfd</relative_path>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_product_module" version_date="02/08/2002" version_time="35986" version_user="admin" entity_mnemonic="gscpm" key_field_value="1000000117.39" record_version_obj="1000000118.39" version_number_seq="2.39" import_version_number_seq="0"><product_module_obj>1000000117.39</product_module_obj>
<product_obj>1004874670.09</product_obj>
<product_module_code>db-icfdoc</product_module_code>
<product_module_description>Database ICFDB Documents</product_module_description>
<product_module_installed>yes</product_module_installed>
<number_of_users>0</number_of_users>
<db_connection_pf_file></db_connection_pf_file>
<relative_path>db/icf/doc</relative_path>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_product_module" version_date="02/08/2002" version_time="35622" version_user="admin" entity_mnemonic="gscpm" key_field_value="1000000103.39" record_version_obj="1000000104.39" version_number_seq="2.39" import_version_number_seq="0"><product_module_obj>1000000103.39</product_module_obj>
<product_obj>1004874670.09</product_obj>
<product_module_code>db-icfdump</product_module_code>
<product_module_description>Database ICFDB Dumps</product_module_description>
<product_module_installed>yes</product_module_installed>
<number_of_users>0</number_of_users>
<db_connection_pf_file></db_connection_pf_file>
<relative_path>db/icf/dump</relative_path>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_product_module" version_date="02/08/2002" version_time="35759" version_user="admin" entity_mnemonic="gscpm" key_field_value="1000000107.39" record_version_obj="1000000108.39" version_number_seq="2.39" import_version_number_seq="0"><product_module_obj>1000000107.39</product_module_obj>
<product_obj>1004874670.09</product_obj>
<product_module_code>db-rtbdb</product_module_code>
<product_module_description>Database RTBDB</product_module_description>
<product_module_installed>yes</product_module_installed>
<number_of_users>0</number_of_users>
<db_connection_pf_file></db_connection_pf_file>
<relative_path></relative_path>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_product_module" version_date="02/08/2002" version_time="35824" version_user="admin" entity_mnemonic="gscpm" key_field_value="1000000111.39" record_version_obj="1000000112.39" version_number_seq="2.39" import_version_number_seq="0"><product_module_obj>1000000111.39</product_module_obj>
<product_obj>1004874670.09</product_obj>
<product_module_code>db-rtbdfd</product_module_code>
<product_module_description>Database RTBDB Definitions</product_module_description>
<product_module_installed>yes</product_module_installed>
<number_of_users>0</number_of_users>
<db_connection_pf_file></db_connection_pf_file>
<relative_path>db/rtb/dfd</relative_path>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_product_module" version_date="02/08/2002" version_time="35768" version_user="admin" entity_mnemonic="gscpm" key_field_value="1000000109.39" record_version_obj="1000000110.39" version_number_seq="2.39" import_version_number_seq="0"><product_module_obj>1000000109.39</product_module_obj>
<product_obj>1004874670.09</product_obj>
<product_module_code>db-rvdb</product_module_code>
<product_module_description>Database RVDB</product_module_description>
<product_module_installed>yes</product_module_installed>
<number_of_users>0</number_of_users>
<db_connection_pf_file></db_connection_pf_file>
<relative_path></relative_path>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_product_module" version_date="02/08/2002" version_time="35848" version_user="admin" entity_mnemonic="gscpm" key_field_value="1000000113.39" record_version_obj="1000000114.39" version_number_seq="2.39" import_version_number_seq="0"><product_module_obj>1000000113.39</product_module_obj>
<product_obj>1004874670.09</product_obj>
<product_module_code>db-rvdfd</product_module_code>
<product_module_description>Database RVDB Definitions</product_module_description>
<product_module_installed>yes</product_module_installed>
<number_of_users>0</number_of_users>
<db_connection_pf_file></db_connection_pf_file>
<relative_path>db/rv/dfd</relative_path>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_product_module" version_date="02/08/2002" version_time="35922" version_user="admin" entity_mnemonic="gscpm" key_field_value="1000000105.39" record_version_obj="1000000106.39" version_number_seq="3.39" import_version_number_seq="0"><product_module_obj>1000000105.39</product_module_obj>
<product_obj>1004874670.09</product_obj>
<product_module_code>db-rvdoc</product_module_code>
<product_module_description>Database RVDB Documents</product_module_description>
<product_module_installed>yes</product_module_installed>
<number_of_users>0</number_of_users>
<db_connection_pf_file></db_connection_pf_file>
<relative_path>db/rv/doc</relative_path>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_product_module" version_date="02/08/2002" version_time="35909" version_user="admin" entity_mnemonic="gscpm" key_field_value="1000000115.39" record_version_obj="1000000116.39" version_number_seq="2.39" import_version_number_seq="0"><product_module_obj>1000000115.39</product_module_obj>
<product_obj>1004874670.09</product_obj>
<product_module_code>db-rvdump</product_module_code>
<product_module_description>Database RVDB Dumps</product_module_description>
<product_module_installed>yes</product_module_installed>
<number_of_users>0</number_of_users>
<db_connection_pf_file></db_connection_pf_file>
<relative_path>db/rv/dump</relative_path>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="6"><contained_record DB="ICFDB" Table="gsc_product"><product_obj>1004874672.09</product_obj>
<product_code>090RV</product_code>
<product_description>ICF Versioning (090RV)</product_description>
<product_installed>yes</product_installed>
<number_of_users>0</number_of_users>
<db_connection_pf_file></db_connection_pf_file>
<supplier_organisation_obj>0</supplier_organisation_obj>
<contained_record DB="ICFDB" Table="gsc_product_module"><product_module_obj>1004874693.09</product_module_obj>
<product_obj>1004874672.09</product_obj>
<product_module_code>rv-app</product_module_code>
<product_module_description>ICF Versioning Appserver Procs</product_module_description>
<product_module_installed>yes</product_module_installed>
<number_of_users>0</number_of_users>
<db_connection_pf_file></db_connection_pf_file>
<relative_path>rv/app</relative_path>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_product_module"><product_module_obj>1004874696.09</product_module_obj>
<product_obj>1004874672.09</product_obj>
<product_module_code>rv-img</product_module_code>
<product_module_description>ICF Versioning Image Files</product_module_description>
<product_module_installed>yes</product_module_installed>
<number_of_users>0</number_of_users>
<db_connection_pf_file></db_connection_pf_file>
<relative_path>rv/img</relative_path>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_product_module"><product_module_obj>1004874697.09</product_module_obj>
<product_obj>1004874672.09</product_obj>
<product_module_code>rv-inc</product_module_code>
<product_module_description>ICF Versioning Include Files</product_module_description>
<product_module_installed>yes</product_module_installed>
<number_of_users>0</number_of_users>
<db_connection_pf_file></db_connection_pf_file>
<relative_path>rv/inc</relative_path>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_product_module"><product_module_obj>1004874698.09</product_module_obj>
<product_obj>1004874672.09</product_obj>
<product_module_code>rv-obj</product_module_code>
<product_module_description>ICF Versioning Objects</product_module_description>
<product_module_installed>yes</product_module_installed>
<number_of_users>0</number_of_users>
<db_connection_pf_file></db_connection_pf_file>
<relative_path>rv/obj</relative_path>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_product_module"><product_module_obj>1004874699.09</product_module_obj>
<product_obj>1004874672.09</product_obj>
<product_module_code>rv-prc</product_module_code>
<product_module_description>ICF Versioning Procedures</product_module_description>
<product_module_installed>yes</product_module_installed>
<number_of_users>0</number_of_users>
<db_connection_pf_file></db_connection_pf_file>
<relative_path>rv/prc</relative_path>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_product_module" version_date="02/08/2002" version_time="36542" version_user="admin" entity_mnemonic="gscpm" key_field_value="1000000133.39" record_version_obj="1000000134.39" version_number_seq="2.39" import_version_number_seq="0"><product_module_obj>1000000133.39</product_module_obj>
<product_obj>1004874672.09</product_obj>
<product_module_code>rv-trg</product_module_code>
<product_module_description>ICF RVDB Database Triggers</product_module_description>
<product_module_installed>yes</product_module_installed>
<number_of_users>0</number_of_users>
<db_connection_pf_file></db_connection_pf_file>
<relative_path>rv/trg</relative_path>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_product_module"><product_module_obj>1004874701.09</product_module_obj>
<product_obj>1004874672.09</product_obj>
<product_module_code>rv-uib</product_module_code>
<product_module_description>ICF Versioning Containers</product_module_description>
<product_module_installed>yes</product_module_installed>
<number_of_users>0</number_of_users>
<db_connection_pf_file></db_connection_pf_file>
<relative_path>rv/uib</relative_path>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="7"><contained_record DB="ICFDB" Table="gsc_product"><product_obj>1004874673.09</product_obj>
<product_code>090RY</product_code>
<product_description>ICF Repository (090RY)</product_description>
<product_installed>yes</product_installed>
<number_of_users>0</number_of_users>
<db_connection_pf_file></db_connection_pf_file>
<supplier_organisation_obj>0</supplier_organisation_obj>
<contained_record DB="ICFDB" Table="gsc_product_module"><product_module_obj>1004874702.09</product_module_obj>
<product_obj>1004874673.09</product_obj>
<product_module_code>ry-app</product_module_code>
<product_module_description>ICF Repository Appserver Procs</product_module_description>
<product_module_installed>yes</product_module_installed>
<number_of_users>0</number_of_users>
<db_connection_pf_file></db_connection_pf_file>
<relative_path>ry/app</relative_path>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_product_module"><product_module_obj>1004874705.09</product_module_obj>
<product_obj>1004874673.09</product_obj>
<product_module_code>ry-img</product_module_code>
<product_module_description>ICF Repository Images</product_module_description>
<product_module_installed>yes</product_module_installed>
<number_of_users>0</number_of_users>
<db_connection_pf_file></db_connection_pf_file>
<relative_path>ry/img</relative_path>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_product_module"><product_module_obj>1004874706.09</product_module_obj>
<product_obj>1004874673.09</product_obj>
<product_module_code>ry-inc</product_module_code>
<product_module_description>ICF Repository Include Files</product_module_description>
<product_module_installed>yes</product_module_installed>
<number_of_users>0</number_of_users>
<db_connection_pf_file></db_connection_pf_file>
<relative_path>ry/inc</relative_path>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_product_module"><product_module_obj>1004874707.09</product_module_obj>
<product_obj>1004874673.09</product_obj>
<product_module_code>ry-obj</product_module_code>
<product_module_description>ICF Repository Objects</product_module_description>
<product_module_installed>yes</product_module_installed>
<number_of_users>0</number_of_users>
<db_connection_pf_file></db_connection_pf_file>
<relative_path>ry/obj</relative_path>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_product_module"><product_module_obj>1004874708.09</product_module_obj>
<product_obj>1004874673.09</product_obj>
<product_module_code>ry-prc</product_module_code>
<product_module_description>ICF Repository Procedures</product_module_description>
<product_module_installed>yes</product_module_installed>
<number_of_users>0</number_of_users>
<db_connection_pf_file></db_connection_pf_file>
<relative_path>ry/prc</relative_path>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_product_module"><product_module_obj>1004874710.09</product_module_obj>
<product_obj>1004874673.09</product_obj>
<product_module_code>ry-uib</product_module_code>
<product_module_description>ICF Repository Containers</product_module_description>
<product_module_installed>yes</product_module_installed>
<number_of_users>0</number_of_users>
<db_connection_pf_file></db_connection_pf_file>
<relative_path>ry/uib</relative_path>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="8"><contained_record DB="ICFDB" Table="gsc_product"><product_obj>1007500652.09</product_obj>
<product_code>090RTB</product_code>
<product_description>ICF RTB (090RTB) SCM Tool</product_description>
<product_installed>yes</product_installed>
<number_of_users>0</number_of_users>
<db_connection_pf_file></db_connection_pf_file>
<supplier_organisation_obj>0</supplier_organisation_obj>
<contained_record DB="ICFDB" Table="gsc_product_module"><product_module_obj>1007500653.09</product_module_obj>
<product_obj>1007500652.09</product_obj>
<product_module_code>rtb-app</product_module_code>
<product_module_description>ICF RTB Appserver Procs</product_module_description>
<product_module_installed>yes</product_module_installed>
<number_of_users>0</number_of_users>
<db_connection_pf_file></db_connection_pf_file>
<relative_path>rtb/app</relative_path>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_product_module"><product_module_obj>1007500654.09</product_module_obj>
<product_obj>1007500652.09</product_obj>
<product_module_code>rtb-img</product_module_code>
<product_module_description>ICF RTB Images</product_module_description>
<product_module_installed>yes</product_module_installed>
<number_of_users>0</number_of_users>
<db_connection_pf_file></db_connection_pf_file>
<relative_path>rtb/img</relative_path>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_product_module"><product_module_obj>1007500655.09</product_module_obj>
<product_obj>1007500652.09</product_obj>
<product_module_code>rtb-inc</product_module_code>
<product_module_description>ICF RTB Include Files</product_module_description>
<product_module_installed>yes</product_module_installed>
<number_of_users>0</number_of_users>
<db_connection_pf_file></db_connection_pf_file>
<relative_path>rtb/inc</relative_path>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_product_module"><product_module_obj>1007500656.09</product_module_obj>
<product_obj>1007500652.09</product_obj>
<product_module_code>rtb-obj</product_module_code>
<product_module_description>ICF RTB Objects</product_module_description>
<product_module_installed>yes</product_module_installed>
<number_of_users>0</number_of_users>
<db_connection_pf_file></db_connection_pf_file>
<relative_path>rtb/obj</relative_path>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_product_module"><product_module_obj>1007500657.09</product_module_obj>
<product_obj>1007500652.09</product_obj>
<product_module_code>rtb-prc</product_module_code>
<product_module_description>ICF RTB Procedures</product_module_description>
<product_module_installed>yes</product_module_installed>
<number_of_users>0</number_of_users>
<db_connection_pf_file></db_connection_pf_file>
<relative_path>rtb/prc</relative_path>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_product_module" version_date="02/08/2002" version_time="36210" version_user="admin" entity_mnemonic="gscpm" key_field_value="1000000131.39" record_version_obj="1000000132.39" version_number_seq="2.39" import_version_number_seq="0"><product_module_obj>1000000131.39</product_module_obj>
<product_obj>1007500652.09</product_obj>
<product_module_code>rtb-trg</product_module_code>
<product_module_description>ICF RTB Database Triggers</product_module_description>
<product_module_installed>yes</product_module_installed>
<number_of_users>0</number_of_users>
<db_connection_pf_file></db_connection_pf_file>
<relative_path>rtb/trg</relative_path>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_product_module"><product_module_obj>1007500659.09</product_module_obj>
<product_obj>1007500652.09</product_obj>
<product_module_code>rtb-uib</product_module_code>
<product_module_description>ICF RTB Containers</product_module_description>
<product_module_installed>yes</product_module_installed>
<number_of_users>0</number_of_users>
<db_connection_pf_file></db_connection_pf_file>
<relative_path>rtb/uib</relative_path>
</contained_record>
</contained_record>
</dataset_transaction>
</dataset_records>
</dataset>