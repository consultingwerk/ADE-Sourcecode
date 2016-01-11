<?xml version="1.0" encoding="ISO8859-1" ?>
<dataset Transactions="53" version_date="02/23/2002" version_time="42907" version_user="admin" entity_mnemonic="GSTDF" key_field_value="3000000367.09" record_version_obj="3000000368.09" version_number_seq="2.09" import_version_number_seq="2.09"><dataset_header DisableRI="yes" DatasetObj="1007600169.08" DateFormat="mdy" FullHeader="yes" SCMManaged="no" YearOffset="1950" DatasetCode="GSCDD" DateCreated="02/23/2002" TimeCreated="15:14:22" NumericFormat="AMERICAN" NumericDecimal="." OriginatingSite="93" NumericSeparator=","><deploy_dataset_obj>1007600169.08</deploy_dataset_obj>
<owner_site_code></owner_site_code>
<dataset_code>GSCDD</dataset_code>
<dataset_description>gsc_deploy_dataset - Deployment DS</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<dataset_entity><dataset_entity_obj>1007600170.08</dataset_entity_obj>
<deploy_dataset_obj>1007600169.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSCDD</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>dataset_code</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<entity_mnemonic_description>gsc_deploy_dataset</entity_mnemonic_description>
<entity_dbname>icfdb</entity_dbname>
</dataset_entity>
<dataset_entity><dataset_entity_obj>1007600171.08</dataset_entity_obj>
<deploy_dataset_obj>1007600169.08</deploy_dataset_obj>
<entity_sequence>2</entity_sequence>
<entity_mnemonic>GSCDE</entity_mnemonic>
<primary_entity>no</primary_entity>
<join_entity_mnemonic>GSCDD</join_entity_mnemonic>
<join_field_list>deploy_dataset_obj,deploy_dataset_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<entity_mnemonic_description>gsc_dataset_entity</entity_mnemonic_description>
<entity_dbname>icfdb</entity_dbname>
</dataset_entity>
<table_definition><name>gsc_deploy_dataset</name>
<dbname>ICFDB</dbname>
<index-1>XAK1gsc_deploy_dataset,1,0,0,owner_site_code,0,dataset_code,0</index-1>
<index-2>XAK2gsc_deploy_dataset,1,0,0,dataset_code,0</index-2>
<index-3>XIE1gsc_deploy_dataset,0,0,0,dataset_description,0</index-3>
<index-4>XIE2gsc_deploy_dataset,0,0,0,source_code_data,0</index-4>
<index-5>XPKgsc_deploy_dataset,1,1,0,deploy_dataset_obj,0</index-5>
<field><name>deploy_dataset_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>>>>>>>>>>>>>>>>>>9.999999999</format>
<initial>                 0.000000000</initial>
<label>Deploy Dataset Obj</label>
<column-label>Deploy Dataset Obj</column-label>
</field>
<field><name>owner_site_code</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(10)</format>
<initial></initial>
<label>Owner Site Code</label>
<column-label>Owner Site Code</column-label>
</field>
<field><name>dataset_code</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(10)</format>
<initial></initial>
<label>Dataset Code</label>
<column-label>Dataset Code</column-label>
</field>
<field><name>dataset_description</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(500)</format>
<initial></initial>
<label>Dataset Description</label>
<column-label>Dataset Description</column-label>
</field>
<field><name>disable_ri</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>YES</initial>
<label>Disable Ri</label>
<column-label>Disable Ri</column-label>
</field>
<field><name>source_code_data</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>Source Code Data</label>
<column-label>Source Code Data</column-label>
</field>
<field><name>deploy_full_data</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>Deploy Full Data</label>
<column-label>Deploy Full Data</column-label>
</field>
<field><name>xml_generation_procedure</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Xml Generation Procedure</label>
<column-label>Xml Generation Procedure</column-label>
</field>
<field><name>default_ado_filename</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Default Ado Filename</label>
<column-label>Default Ado Filename</column-label>
</field>
</table_definition>
<table_definition><name>gsc_dataset_entity</name>
<dbname>ICFDB</dbname>
<index-1>XAK1gsc_dataset_entity,1,0,0,deploy_dataset_obj,0,entity_sequence,0</index-1>
<index-2>XIE1gsc_dataset_entity,0,0,0,entity_mnemonic,0</index-2>
<index-3>XIE3gsc_dataset_entity,0,0,0,deploy_dataset_obj,0,primary_entity,0,entity_mnemonic,0</index-3>
<index-4>XIE4gsc_dataset_entity,0,0,0,join_entity_mnemonic,0,dataset_entity_obj,0</index-4>
<index-5>XPKgsc_dataset_entity,1,1,0,dataset_entity_obj,0</index-5>
<field><name>dataset_entity_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>>>>>>>>>>>>>>>>>>9.999999999</format>
<initial>                 0.000000000</initial>
<label>Dataset Entity Obj</label>
<column-label>Dataset Entity Obj</column-label>
</field>
<field><name>deploy_dataset_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>>>>>>>>>>>>>>>>>>9.999999999</format>
<initial>                 0.000000000</initial>
<label>Deploy Dataset Obj</label>
<column-label>Deploy Dataset Obj</column-label>
</field>
<field><name>entity_sequence</name>
<data-type>integer</data-type>
<extent>0</extent>
<format>->>9</format>
<initial>   0</initial>
<label>Entity Sequence</label>
<column-label>Entity Seq.</column-label>
</field>
<field><name>entity_mnemonic</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(8)</format>
<initial></initial>
<label>Entity Mnemonic</label>
<column-label>Entity Mnemonic</column-label>
</field>
<field><name>primary_entity</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>Primary Entity</label>
<column-label>Primary Entity</column-label>
</field>
<field><name>join_entity_mnemonic</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(8)</format>
<initial></initial>
<label>Join Entity Mnemonic</label>
<column-label>Join Entity Mnemonic</column-label>
</field>
<field><name>join_field_list</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Join Field List</label>
<column-label>Join Field List</column-label>
</field>
<field><name>filter_where_clause</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(500)</format>
<initial></initial>
<label>Filter Where Clause</label>
<column-label>Filter Where Clause</column-label>
</field>
<field><name>delete_related_records</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>YES</initial>
<label>Delete Related Records</label>
<column-label>Delete Related Records</column-label>
</field>
<field><name>overwrite_records</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>YES</initial>
<label>Overwrite Records</label>
<column-label>Overwrite Records</column-label>
</field>
<field><name>keep_own_site_data</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>Keep Own Site Data</label>
<column-label>Keep Own Site Data</column-label>
</field>
</table_definition>
</dataset_header>
<dataset_records><dataset_transaction TransactionNo="1"><contained_record DB="ICFDB" Table="gsc_deploy_dataset" version_date="02/11/2002" version_time="59954" version_user="admin" entity_mnemonic="gscdd" key_field_value="1000000148.39" record_version_obj="1000000149.39" version_number_seq="3.39" import_version_number_seq="3.39"><deploy_dataset_obj>1000000148.39</deploy_dataset_obj>
<owner_site_code></owner_site_code>
<dataset_code>RVMTA</dataset_code>
<dataset_description>rvm_task</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<contained_record DB="ICFDB" Table="gsc_dataset_entity" version_date="02/11/2002" version_time="59747" version_user="admin" entity_mnemonic="gscde" key_field_value="1000000150.39" record_version_obj="1000000151.39" version_number_seq="2.39" import_version_number_seq="2.39"><dataset_entity_obj>1000000150.39</dataset_entity_obj>
<deploy_dataset_obj>1000000148.39</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>RVMTA</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>task_number</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>no</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="2"><contained_record DB="ICFDB" Table="gsc_deploy_dataset" version_date="02/11/2002" version_time="60019" version_user="admin" entity_mnemonic="gscdd" key_field_value="1000000152.39" record_version_obj="1000000153.39" version_number_seq="2.39" import_version_number_seq="2.39"><deploy_dataset_obj>1000000152.39</deploy_dataset_obj>
<owner_site_code></owner_site_code>
<dataset_code>RVCCT</dataset_code>
<dataset_description>rvc_configuration_type</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<contained_record DB="ICFDB" Table="gsc_dataset_entity" version_date="02/11/2002" version_time="60046" version_user="admin" entity_mnemonic="gscde" key_field_value="1000000154.39" record_version_obj="1000000155.39" version_number_seq="2.39" import_version_number_seq="2.39"><dataset_entity_obj>1000000154.39</dataset_entity_obj>
<deploy_dataset_obj>1000000152.39</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>RVCCT</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>configuration_type</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>no</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="3"><contained_record DB="ICFDB" Table="gsc_deploy_dataset" version_date="02/11/2002" version_time="60094" version_user="admin" entity_mnemonic="gscdd" key_field_value="1000000156.39" record_version_obj="1000000157.39" version_number_seq="2.39" import_version_number_seq="2.39"><deploy_dataset_obj>1000000156.39</deploy_dataset_obj>
<owner_site_code></owner_site_code>
<dataset_code>RVMCI</dataset_code>
<dataset_description>rvm_configuration_item</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<contained_record DB="ICFDB" Table="gsc_dataset_entity" version_date="02/11/2002" version_time="60167" version_user="admin" entity_mnemonic="gscde" key_field_value="1000000158.39" record_version_obj="1000000159.39" version_number_seq="2.39" import_version_number_seq="2.39"><dataset_entity_obj>1000000158.39</dataset_entity_obj>
<deploy_dataset_obj>1000000156.39</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>RVMCI</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>configuration_type,scm_object_name,product_module_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>no</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_dataset_entity" version_date="02/11/2002" version_time="60638" version_user="admin" entity_mnemonic="gscde" key_field_value="1000000160.39" record_version_obj="1000000161.39" version_number_seq="3.39" import_version_number_seq="3.39"><dataset_entity_obj>1000000160.39</dataset_entity_obj>
<deploy_dataset_obj>1000000156.39</deploy_dataset_obj>
<entity_sequence>2</entity_sequence>
<entity_mnemonic>RVTIV</entity_mnemonic>
<primary_entity>no</primary_entity>
<join_entity_mnemonic>RVMCI</join_entity_mnemonic>
<join_field_list>configuration_type,configuration_type,scm_object_name,scm_object_name,product_module_obj,product_module_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>no</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="4"><contained_record DB="ICFDB" Table="gsc_deploy_dataset" version_date="02/11/2002" version_time="60754" version_user="admin" entity_mnemonic="gscdd" key_field_value="1000000162.39" record_version_obj="1000000163.39" version_number_seq="2.39" import_version_number_seq="2.39"><deploy_dataset_obj>1000000162.39</deploy_dataset_obj>
<owner_site_code></owner_site_code>
<dataset_code>RVMWS</dataset_code>
<dataset_description>rvm_workspace</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<contained_record DB="ICFDB" Table="gsc_dataset_entity" version_date="02/11/2002" version_time="60784" version_user="admin" entity_mnemonic="gscde" key_field_value="1000000164.39" record_version_obj="1000000165.39" version_number_seq="2.39" import_version_number_seq="2.39"><dataset_entity_obj>1000000164.39</dataset_entity_obj>
<deploy_dataset_obj>1000000162.39</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>RVMWS</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>workspace_code</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>no</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_dataset_entity" version_date="02/11/2002" version_time="60827" version_user="admin" entity_mnemonic="gscde" key_field_value="1000000166.39" record_version_obj="1000000167.39" version_number_seq="2.39" import_version_number_seq="2.39"><dataset_entity_obj>1000000166.39</dataset_entity_obj>
<deploy_dataset_obj>1000000162.39</deploy_dataset_obj>
<entity_sequence>2</entity_sequence>
<entity_mnemonic>RVMWM</entity_mnemonic>
<primary_entity>no</primary_entity>
<join_entity_mnemonic>RVMWS</join_entity_mnemonic>
<join_field_list>workspace_obj,workspace_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>no</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_dataset_entity" version_date="02/11/2002" version_time="60850" version_user="admin" entity_mnemonic="gscde" key_field_value="1000000168.39" record_version_obj="1000000169.39" version_number_seq="2.39" import_version_number_seq="2.39"><dataset_entity_obj>1000000168.39</dataset_entity_obj>
<deploy_dataset_obj>1000000162.39</deploy_dataset_obj>
<entity_sequence>3</entity_sequence>
<entity_mnemonic>RVMWI</entity_mnemonic>
<primary_entity>no</primary_entity>
<join_entity_mnemonic>RVMWS</join_entity_mnemonic>
<join_field_list>workspace_obj,workspace_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>no</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="5"><contained_record DB="ICFDB" Table="gsc_deploy_dataset"><deploy_dataset_obj>1004928896.09</deploy_dataset_obj>
<owner_site_code></owner_site_code>
<dataset_code>RYCSO</dataset_code>
<dataset_description>ryc_smartobjects - Logical Objects</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>yes</source_code_data>
<deploy_full_data>no</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<contained_record DB="ICFDB" Table="gsc_dataset_entity"><dataset_entity_obj>1004928912.09</dataset_entity_obj>
<deploy_dataset_obj>1004928896.09</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>RYCSO</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>object_filename</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_dataset_entity"><dataset_entity_obj>1004936305.09</dataset_entity_obj>
<deploy_dataset_obj>1004928896.09</deploy_dataset_obj>
<entity_sequence>2</entity_sequence>
<entity_mnemonic>GSCOB</entity_mnemonic>
<primary_entity>no</primary_entity>
<join_entity_mnemonic>rycso</join_entity_mnemonic>
<join_field_list>object_filename,object_filename</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_dataset_entity"><dataset_entity_obj>1004936278.09</dataset_entity_obj>
<deploy_dataset_obj>1004928896.09</deploy_dataset_obj>
<entity_sequence>3</entity_sequence>
<entity_mnemonic>RYCPO</entity_mnemonic>
<primary_entity>no</primary_entity>
<join_entity_mnemonic>rycso</join_entity_mnemonic>
<join_field_list>container_smartobject_obj,smartobject_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_dataset_entity"><dataset_entity_obj>1004928913.09</dataset_entity_obj>
<deploy_dataset_obj>1004928896.09</deploy_dataset_obj>
<entity_sequence>4</entity_sequence>
<entity_mnemonic>RYCPA</entity_mnemonic>
<primary_entity>no</primary_entity>
<join_entity_mnemonic>rycso</join_entity_mnemonic>
<join_field_list>container_smartobject_obj,smartobject_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_dataset_entity"><dataset_entity_obj>1004936275.09</dataset_entity_obj>
<deploy_dataset_obj>1004928896.09</deploy_dataset_obj>
<entity_sequence>5</entity_sequence>
<entity_mnemonic>RYCOI</entity_mnemonic>
<primary_entity>no</primary_entity>
<join_entity_mnemonic>rycso</join_entity_mnemonic>
<join_field_list>container_smartobject_obj,smartobject_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_dataset_entity"><dataset_entity_obj>1004936279.09</dataset_entity_obj>
<deploy_dataset_obj>1004928896.09</deploy_dataset_obj>
<entity_sequence>6</entity_sequence>
<entity_mnemonic>RYCSM</entity_mnemonic>
<primary_entity>no</primary_entity>
<join_entity_mnemonic>rycso</join_entity_mnemonic>
<join_field_list>container_smartobject_obj,smartobject_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_dataset_entity"><dataset_entity_obj>1004936297.09</dataset_entity_obj>
<deploy_dataset_obj>1004928896.09</deploy_dataset_obj>
<entity_sequence>7</entity_sequence>
<entity_mnemonic>RYCAV</entity_mnemonic>
<primary_entity>no</primary_entity>
<join_entity_mnemonic>rycso</join_entity_mnemonic>
<join_field_list>primary_smartobject_obj,smartobject_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_dataset_entity"><dataset_entity_obj>1007600052.08</dataset_entity_obj>
<deploy_dataset_obj>1004928896.09</deploy_dataset_obj>
<entity_sequence>8</entity_sequence>
<entity_mnemonic>RYCUE</entity_mnemonic>
<primary_entity>no</primary_entity>
<join_entity_mnemonic>RYCSO</join_entity_mnemonic>
<join_field_list>container_smartobject_obj,smartobject_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_dataset_entity"><dataset_entity_obj>1007600053.08</dataset_entity_obj>
<deploy_dataset_obj>1004928896.09</deploy_dataset_obj>
<entity_sequence>9</entity_sequence>
<entity_mnemonic>RYMDV</entity_mnemonic>
<primary_entity>no</primary_entity>
<join_entity_mnemonic>RYCSO</join_entity_mnemonic>
<join_field_list>related_entity_key,smartobject_obj</join_field_list>
<filter_where_clause>related_entity_mnemonic = "RYCSO"</filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_dataset_entity"><dataset_entity_obj>1007600076.08</dataset_entity_obj>
<deploy_dataset_obj>1004928896.09</deploy_dataset_obj>
<entity_sequence>10</entity_sequence>
<entity_mnemonic>RYMWT</entity_mnemonic>
<primary_entity>no</primary_entity>
<join_entity_mnemonic>RYCSO</join_entity_mnemonic>
<join_field_list>object_name,object_filename</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_dataset_entity"><dataset_entity_obj>1007600095.08</dataset_entity_obj>
<deploy_dataset_obj>1004928896.09</deploy_dataset_obj>
<entity_sequence>11</entity_sequence>
<entity_mnemonic>GSMTM</entity_mnemonic>
<primary_entity>no</primary_entity>
<join_entity_mnemonic>GSCOB</join_entity_mnemonic>
<join_field_list>object_obj,object_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_dataset_entity"><dataset_entity_obj>1007600096.08</dataset_entity_obj>
<deploy_dataset_obj>1004928896.09</deploy_dataset_obj>
<entity_sequence>12</entity_sequence>
<entity_mnemonic>GSMOM</entity_mnemonic>
<primary_entity>no</primary_entity>
<join_entity_mnemonic>GSCOB</join_entity_mnemonic>
<join_field_list>object_obj,object_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="6"><contained_record DB="ICFDB" Table="gsc_deploy_dataset"><deploy_dataset_obj>1007600077.08</deploy_dataset_obj>
<owner_site_code></owner_site_code>
<dataset_code>GSMND</dataset_code>
<dataset_description>gsm_node - TreeView Nodes</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<contained_record DB="ICFDB" Table="gsc_dataset_entity"><dataset_entity_obj>1007600078.08</dataset_entity_obj>
<deploy_dataset_obj>1007600077.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSMND</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>node_code</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="7"><contained_record DB="ICFDB" Table="gsc_deploy_dataset"><deploy_dataset_obj>1007600079.08</deploy_dataset_obj>
<owner_site_code></owner_site_code>
<dataset_code>RYCST</dataset_code>
<dataset_description>ryc_smartlink_type - SmartLinks</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<contained_record DB="ICFDB" Table="gsc_dataset_entity"><dataset_entity_obj>1007600080.08</dataset_entity_obj>
<deploy_dataset_obj>1007600079.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>RYCST</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>link_name</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="8"><contained_record DB="ICFDB" Table="gsc_deploy_dataset"><deploy_dataset_obj>1007600081.08</deploy_dataset_obj>
<owner_site_code></owner_site_code>
<dataset_code>RYCLA</dataset_code>
<dataset_description>ryc_layout - Layouts</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<contained_record DB="ICFDB" Table="gsc_dataset_entity"><dataset_entity_obj>1007600082.08</dataset_entity_obj>
<deploy_dataset_obj>1007600081.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>RYCLA</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>layout_name</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="9"><contained_record DB="ICFDB" Table="gsc_deploy_dataset"><deploy_dataset_obj>1007600083.08</deploy_dataset_obj>
<owner_site_code></owner_site_code>
<dataset_code>RYCAT</dataset_code>
<dataset_description>ryc_attribute - Attribute Dataset</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<contained_record DB="ICFDB" Table="gsc_dataset_entity"><dataset_entity_obj>1007600084.08</dataset_entity_obj>
<deploy_dataset_obj>1007600083.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>RYCAT</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>attribute_label</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_dataset_entity"><dataset_entity_obj>1007600085.08</dataset_entity_obj>
<deploy_dataset_obj>1007600083.08</deploy_dataset_obj>
<entity_sequence>2</entity_sequence>
<entity_mnemonic>RYCAP</entity_mnemonic>
<primary_entity>no</primary_entity>
<join_entity_mnemonic>RYCAT</join_entity_mnemonic>
<join_field_list>attribute_group_obj,attribute_group_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_dataset_entity"><dataset_entity_obj>1007600086.08</dataset_entity_obj>
<deploy_dataset_obj>1007600083.08</deploy_dataset_obj>
<entity_sequence>3</entity_sequence>
<entity_mnemonic>RYCAY</entity_mnemonic>
<primary_entity>no</primary_entity>
<join_entity_mnemonic>RYCAT</join_entity_mnemonic>
<join_field_list>attribute_type_tla,attribute_type_tla</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="10"><contained_record DB="ICFDB" Table="gsc_deploy_dataset"><deploy_dataset_obj>1007600097.08</deploy_dataset_obj>
<owner_site_code></owner_site_code>
<dataset_code>GSCOB</dataset_code>
<dataset_description>gsc_object - Object Table</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<contained_record DB="ICFDB" Table="gsc_dataset_entity"><dataset_entity_obj>1007600098.08</dataset_entity_obj>
<deploy_dataset_obj>1007600097.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSCOB</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>object_filename</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_dataset_entity"><dataset_entity_obj>1007600099.08</dataset_entity_obj>
<deploy_dataset_obj>1007600097.08</deploy_dataset_obj>
<entity_sequence>2</entity_sequence>
<entity_mnemonic>GSMOM</entity_mnemonic>
<primary_entity>no</primary_entity>
<join_entity_mnemonic>GSCOB</join_entity_mnemonic>
<join_field_list>object_obj,object_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_dataset_entity"><dataset_entity_obj>1007600101.08</dataset_entity_obj>
<deploy_dataset_obj>1007600097.08</deploy_dataset_obj>
<entity_sequence>3</entity_sequence>
<entity_mnemonic>GSMTM</entity_mnemonic>
<primary_entity>no</primary_entity>
<join_entity_mnemonic>GSCOB</join_entity_mnemonic>
<join_field_list>object_obj,object_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_dataset_entity"><dataset_entity_obj>1007600102.08</dataset_entity_obj>
<deploy_dataset_obj>1007600097.08</deploy_dataset_obj>
<entity_sequence>4</entity_sequence>
<entity_mnemonic>GSMVP</entity_mnemonic>
<primary_entity>no</primary_entity>
<join_entity_mnemonic>GSCOB</join_entity_mnemonic>
<join_field_list>object_obj,object_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="11"><contained_record DB="ICFDB" Table="gsc_deploy_dataset"><deploy_dataset_obj>1007600103.08</deploy_dataset_obj>
<owner_site_code></owner_site_code>
<dataset_code>GSMLG</dataset_code>
<dataset_description>gsm_login_company - Login Company</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<contained_record DB="ICFDB" Table="gsc_dataset_entity"><dataset_entity_obj>1007600104.08</dataset_entity_obj>
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
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="12"><contained_record DB="ICFDB" Table="gsc_deploy_dataset"><deploy_dataset_obj>1007600105.08</deploy_dataset_obj>
<owner_site_code></owner_site_code>
<dataset_code>GSCSQ</dataset_code>
<dataset_description>gsc_sequence - Sequences</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<contained_record DB="ICFDB" Table="gsc_dataset_entity"><dataset_entity_obj>1007600106.08</dataset_entity_obj>
<deploy_dataset_obj>1007600105.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSCSQ</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>sequence_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_dataset_entity"><dataset_entity_obj>1007600107.08</dataset_entity_obj>
<deploy_dataset_obj>1007600105.08</deploy_dataset_obj>
<entity_sequence>2</entity_sequence>
<entity_mnemonic>GSCSN</entity_mnemonic>
<primary_entity>no</primary_entity>
<join_entity_mnemonic>GSCSQ</join_entity_mnemonic>
<join_field_list>sequence_obj,sequence_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="13"><contained_record DB="ICFDB" Table="gsc_deploy_dataset"><deploy_dataset_obj>1007600108.08</deploy_dataset_obj>
<owner_site_code></owner_site_code>
<dataset_code>GSCGD</dataset_code>
<dataset_description>gsc_global_defaults - Global deflt</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<contained_record DB="ICFDB" Table="gsc_dataset_entity"><dataset_entity_obj>1007600110.08</dataset_entity_obj>
<deploy_dataset_obj>1007600108.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSCGD</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>global_default_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="14"><contained_record DB="ICFDB" Table="gsc_deploy_dataset"><deploy_dataset_obj>1007600111.08</deploy_dataset_obj>
<owner_site_code></owner_site_code>
<dataset_code>GSCGC</dataset_code>
<dataset_description>gsc_global_control - Global Control</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<contained_record DB="ICFDB" Table="gsc_dataset_entity"><dataset_entity_obj>1007600112.08</dataset_entity_obj>
<deploy_dataset_obj>1007600111.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSCGC</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>global_control_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="15"><contained_record DB="ICFDB" Table="gsc_deploy_dataset"><deploy_dataset_obj>1007600113.08</deploy_dataset_obj>
<owner_site_code></owner_site_code>
<dataset_code>GSMCR</dataset_code>
<dataset_description>gsm_currency - Currencies</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<contained_record DB="ICFDB" Table="gsc_dataset_entity"><dataset_entity_obj>1007600114.08</dataset_entity_obj>
<deploy_dataset_obj>1007600113.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSMCR</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>currency_code</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="16"><contained_record DB="ICFDB" Table="gsc_deploy_dataset"><deploy_dataset_obj>1007600115.08</deploy_dataset_obj>
<owner_site_code></owner_site_code>
<dataset_code>GSMCY</dataset_code>
<dataset_description>gsm_country - Countries</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<contained_record DB="ICFDB" Table="gsc_dataset_entity"><dataset_entity_obj>1007600116.08</dataset_entity_obj>
<deploy_dataset_obj>1007600115.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSMCY</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>country_code</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="17"><contained_record DB="ICFDB" Table="gsc_deploy_dataset"><deploy_dataset_obj>1007600117.08</deploy_dataset_obj>
<owner_site_code></owner_site_code>
<dataset_code>GSCNA</dataset_code>
<dataset_description>gsc_nationality - Nationalities</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<contained_record DB="ICFDB" Table="gsc_dataset_entity"><dataset_entity_obj>1007600118.08</dataset_entity_obj>
<deploy_dataset_obj>1007600117.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSCNA</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>nationality_code</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="18"><contained_record DB="ICFDB" Table="gsc_deploy_dataset"><deploy_dataset_obj>1007600119.08</deploy_dataset_obj>
<owner_site_code></owner_site_code>
<dataset_code>GSCLG</dataset_code>
<dataset_description>gsc_language - Languages</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<contained_record DB="ICFDB" Table="gsc_dataset_entity"><dataset_entity_obj>1007600120.08</dataset_entity_obj>
<deploy_dataset_obj>1007600119.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSCLG</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>language_code</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_dataset_entity"><dataset_entity_obj>1007600121.08</dataset_entity_obj>
<deploy_dataset_obj>1007600119.08</deploy_dataset_obj>
<entity_sequence>2</entity_sequence>
<entity_mnemonic>GSMTL</entity_mnemonic>
<primary_entity>no</primary_entity>
<join_entity_mnemonic>GSCLG</join_entity_mnemonic>
<join_field_list>language_obj,language_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_dataset_entity"><dataset_entity_obj>1007600122.08</dataset_entity_obj>
<deploy_dataset_obj>1007600119.08</deploy_dataset_obj>
<entity_sequence>3</entity_sequence>
<entity_mnemonic>GSCLT</entity_mnemonic>
<primary_entity>no</primary_entity>
<join_entity_mnemonic>GSCLG</join_entity_mnemonic>
<join_field_list>language_obj,language_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="19"><contained_record DB="ICFDB" Table="gsc_deploy_dataset"><deploy_dataset_obj>1007600123.08</deploy_dataset_obj>
<owner_site_code></owner_site_code>
<dataset_code>GSMUC</dataset_code>
<dataset_description>gsm_user_category</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<contained_record DB="ICFDB" Table="gsc_dataset_entity"><dataset_entity_obj>1007600124.08</dataset_entity_obj>
<deploy_dataset_obj>1007600123.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSMUC</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>user_category_code</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="20"><contained_record DB="ICFDB" Table="gsc_deploy_dataset"><deploy_dataset_obj>1007600125.08</deploy_dataset_obj>
<owner_site_code></owner_site_code>
<dataset_code>GSMUS</dataset_code>
<dataset_description>gsm_user - User Table</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<contained_record DB="ICFDB" Table="gsc_dataset_entity"><dataset_entity_obj>1007600126.08</dataset_entity_obj>
<deploy_dataset_obj>1007600125.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSMUS</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>user_login_name</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="21"><contained_record DB="ICFDB" Table="gsc_deploy_dataset"><deploy_dataset_obj>1007600127.08</deploy_dataset_obj>
<owner_site_code></owner_site_code>
<dataset_code>GSCPF</dataset_code>
<dataset_description>gsc_profile_type - Profile Types</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<contained_record DB="ICFDB" Table="gsc_dataset_entity"><dataset_entity_obj>1007600128.08</dataset_entity_obj>
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
</contained_record>
<contained_record DB="ICFDB" Table="gsc_dataset_entity"><dataset_entity_obj>1007600129.08</dataset_entity_obj>
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
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="22"><contained_record DB="ICFDB" Table="gsc_deploy_dataset"><deploy_dataset_obj>1007600130.08</deploy_dataset_obj>
<owner_site_code></owner_site_code>
<dataset_code>GSCMT</dataset_code>
<dataset_description>gsc_manager_type - Manager Types</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<contained_record DB="ICFDB" Table="gsc_dataset_entity"><dataset_entity_obj>1007600131.08</dataset_entity_obj>
<deploy_dataset_obj>1007600130.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSCMT</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>manager_type_code</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="23"><contained_record DB="ICFDB" Table="gsc_deploy_dataset"><deploy_dataset_obj>1007600132.08</deploy_dataset_obj>
<owner_site_code></owner_site_code>
<dataset_code>GSMSE</dataset_code>
<dataset_description>gsm_session_type - Session Types</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<contained_record DB="ICFDB" Table="gsc_dataset_entity"><dataset_entity_obj>1007600134.08</dataset_entity_obj>
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
</contained_record>
<contained_record DB="ICFDB" Table="gsc_dataset_entity"><dataset_entity_obj>1007600135.08</dataset_entity_obj>
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
</contained_record>
<contained_record DB="ICFDB" Table="gsc_dataset_entity"><dataset_entity_obj>1007600136.08</dataset_entity_obj>
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
</contained_record>
<contained_record DB="ICFDB" Table="gsc_dataset_entity"><dataset_entity_obj>1007600137.08</dataset_entity_obj>
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
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="24"><contained_record DB="ICFDB" Table="gsc_deploy_dataset"><deploy_dataset_obj>1007600138.08</deploy_dataset_obj>
<owner_site_code></owner_site_code>
<dataset_code>GSCSP</dataset_code>
<dataset_description>gsc_session_property - Session Prop</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<contained_record DB="ICFDB" Table="gsc_dataset_entity"><dataset_entity_obj>1007600139.08</dataset_entity_obj>
<deploy_dataset_obj>1007600138.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSCSP</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>session_property_name</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="25"><contained_record DB="ICFDB" Table="gsc_deploy_dataset"><deploy_dataset_obj>1007600140.08</deploy_dataset_obj>
<owner_site_code></owner_site_code>
<dataset_code>GSCST</dataset_code>
<dataset_description>gsc_service_type - Service Types</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<contained_record DB="ICFDB" Table="gsc_dataset_entity"><dataset_entity_obj>1007600141.08</dataset_entity_obj>
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
</contained_record>
<contained_record DB="ICFDB" Table="gsc_dataset_entity"><dataset_entity_obj>1007600142.08</dataset_entity_obj>
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
</contained_record>
<contained_record DB="ICFDB" Table="gsc_dataset_entity"><dataset_entity_obj>1007600143.08</dataset_entity_obj>
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
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="26"><contained_record DB="ICFDB" Table="gsc_deploy_dataset"><deploy_dataset_obj>1007600151.08</deploy_dataset_obj>
<owner_site_code></owner_site_code>
<dataset_code>GSCIC</dataset_code>
<dataset_description>gsc_item_category</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<contained_record DB="ICFDB" Table="gsc_dataset_entity"><dataset_entity_obj>1007600152.08</dataset_entity_obj>
<deploy_dataset_obj>1007600151.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSCIC</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>item_category_label</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="27"><contained_record DB="ICFDB" Table="gsc_deploy_dataset"><deploy_dataset_obj>1007600153.08</deploy_dataset_obj>
<owner_site_code></owner_site_code>
<dataset_code>GSMMI</dataset_code>
<dataset_description>gsm_menu_item - Menu Items</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<contained_record DB="ICFDB" Table="gsc_dataset_entity"><dataset_entity_obj>1007600154.08</dataset_entity_obj>
<deploy_dataset_obj>1007600153.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSMMI</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>menu_item_reference</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="28"><contained_record DB="ICFDB" Table="gsc_deploy_dataset"><deploy_dataset_obj>1007600155.08</deploy_dataset_obj>
<owner_site_code></owner_site_code>
<dataset_code>GSMMS</dataset_code>
<dataset_description>gsm_menu_structure - Menu Structure</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<contained_record DB="ICFDB" Table="gsc_dataset_entity"><dataset_entity_obj>1007600156.08</dataset_entity_obj>
<deploy_dataset_obj>1007600155.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSMMS</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>menu_structure_code</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_dataset_entity"><dataset_entity_obj>1007600159.08</dataset_entity_obj>
<deploy_dataset_obj>1007600155.08</deploy_dataset_obj>
<entity_sequence>2</entity_sequence>
<entity_mnemonic>GSMIT</entity_mnemonic>
<primary_entity>no</primary_entity>
<join_entity_mnemonic>GSMMS</join_entity_mnemonic>
<join_field_list>menu_structure_obj,menu_structure_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="29"><contained_record DB="ICFDB" Table="gsc_deploy_dataset"><deploy_dataset_obj>1007600160.08</deploy_dataset_obj>
<owner_site_code></owner_site_code>
<dataset_code>GSMSS</dataset_code>
<dataset_description>gsm_security_structure - Security</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<contained_record DB="ICFDB" Table="gsc_dataset_entity"><dataset_entity_obj>1007600161.08</dataset_entity_obj>
<deploy_dataset_obj>1007600160.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSMSS</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>security_structure_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="30"><contained_record DB="ICFDB" Table="gsc_deploy_dataset"><deploy_dataset_obj>1007600162.08</deploy_dataset_obj>
<owner_site_code></owner_site_code>
<dataset_code>GSCIA</dataset_code>
<dataset_description>gsc_instance_attribute - Inst Attr</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<contained_record DB="ICFDB" Table="gsc_dataset_entity"><dataset_entity_obj>1007600163.08</dataset_entity_obj>
<deploy_dataset_obj>1007600162.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSCIA</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>attribute_code</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="31"><contained_record DB="ICFDB" Table="gsc_deploy_dataset"><deploy_dataset_obj>1007600164.08</deploy_dataset_obj>
<owner_site_code></owner_site_code>
<dataset_code>GSCOT</dataset_code>
<dataset_description>gsc_object_type - Object Types</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<contained_record DB="ICFDB" Table="gsc_dataset_entity"><dataset_entity_obj>1007600165.08</dataset_entity_obj>
<deploy_dataset_obj>1007600164.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSCOT</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>object_type_code</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_dataset_entity" version_date="02/23/2002" version_time="54816" version_user="admin" entity_mnemonic="gscde" key_field_value="1000000232.39" record_version_obj="1000000233.39" version_number_seq="2.39" import_version_number_seq="0"><dataset_entity_obj>1000000232.39</dataset_entity_obj>
<deploy_dataset_obj>1007600164.08</deploy_dataset_obj>
<entity_sequence>2</entity_sequence>
<entity_mnemonic>RYCAV</entity_mnemonic>
<primary_entity>no</primary_entity>
<join_entity_mnemonic>GSCOT</join_entity_mnemonic>
<join_field_list>object_type_obj,object_type_obj</join_field_list>
<filter_where_clause>ryc_attribute_value.primary_smartobject_obj = 0 AND
ryc_attribute_value.smartobject_obj = 0 AND
ryc_attribute_value.container_smartobject_obj = 0 AND
ryc_attribute_value.object_instance_obj = 0
</filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="32"><contained_record DB="ICFDB" Table="gsc_deploy_dataset"><deploy_dataset_obj>1007600166.08</deploy_dataset_obj>
<owner_site_code></owner_site_code>
<dataset_code>GSCPR</dataset_code>
<dataset_description>gsc_product - Products and Modules</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<contained_record DB="ICFDB" Table="gsc_dataset_entity"><dataset_entity_obj>1007600167.08</dataset_entity_obj>
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
</contained_record>
<contained_record DB="ICFDB" Table="gsc_dataset_entity"><dataset_entity_obj>1007600168.08</dataset_entity_obj>
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
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="33"><contained_record DB="ICFDB" Table="gsc_deploy_dataset"><deploy_dataset_obj>1007600169.08</deploy_dataset_obj>
<owner_site_code></owner_site_code>
<dataset_code>GSCDD</dataset_code>
<dataset_description>gsc_deploy_dataset - Deployment DS</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<contained_record DB="ICFDB" Table="gsc_dataset_entity"><dataset_entity_obj>1007600170.08</dataset_entity_obj>
<deploy_dataset_obj>1007600169.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSCDD</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>dataset_code</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_dataset_entity"><dataset_entity_obj>1007600171.08</dataset_entity_obj>
<deploy_dataset_obj>1007600169.08</deploy_dataset_obj>
<entity_sequence>2</entity_sequence>
<entity_mnemonic>GSCDE</entity_mnemonic>
<primary_entity>no</primary_entity>
<join_entity_mnemonic>GSCDD</join_entity_mnemonic>
<join_field_list>deploy_dataset_obj,deploy_dataset_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="34"><contained_record DB="ICFDB" Table="gsc_deploy_dataset"><deploy_dataset_obj>1007600172.08</deploy_dataset_obj>
<owner_site_code></owner_site_code>
<dataset_code>GSMEX</dataset_code>
<dataset_description>gsm_external_xref - External XRef</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<contained_record DB="ICFDB" Table="gsc_dataset_entity"><dataset_entity_obj>1007600173.08</dataset_entity_obj>
<deploy_dataset_obj>1007600172.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSMEX</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>external_xref_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="35"><contained_record DB="ICFDB" Table="gsc_deploy_dataset"><deploy_dataset_obj>1007600174.08</deploy_dataset_obj>
<owner_site_code></owner_site_code>
<dataset_code>GSCDU</dataset_code>
<dataset_description>gsc_default_set_usage - Dft Set Use</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<contained_record DB="ICFDB" Table="gsc_dataset_entity"><dataset_entity_obj>1007600175.08</dataset_entity_obj>
<deploy_dataset_obj>1007600174.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSCDU</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>default_set_usage_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="36"><contained_record DB="ICFDB" Table="gsc_deploy_dataset"><deploy_dataset_obj>1007600176.08</deploy_dataset_obj>
<owner_site_code></owner_site_code>
<dataset_code>GSCDS</dataset_code>
<dataset_description>gsc_default_set - Default Sets</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<contained_record DB="ICFDB" Table="gsc_dataset_entity"><dataset_entity_obj>1007600177.08</dataset_entity_obj>
<deploy_dataset_obj>1007600176.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSCDS</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>default_set_code</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_dataset_entity"><dataset_entity_obj>1007600178.08</dataset_entity_obj>
<deploy_dataset_obj>1007600176.08</deploy_dataset_obj>
<entity_sequence>2</entity_sequence>
<entity_mnemonic>GSCDC</entity_mnemonic>
<primary_entity>no</primary_entity>
<join_entity_mnemonic>GSCDS</join_entity_mnemonic>
<join_field_list>default_set_code,default_set_code</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="37"><contained_record DB="ICFDB" Table="gsc_deploy_dataset"><deploy_dataset_obj>1007600179.08</deploy_dataset_obj>
<owner_site_code></owner_site_code>
<dataset_code>GSMEF</dataset_code>
<dataset_description>gsm_entity_field - Entity Fields</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<contained_record DB="ICFDB" Table="gsc_dataset_entity"><dataset_entity_obj>1007600180.08</dataset_entity_obj>
<deploy_dataset_obj>1007600179.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSMEF</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>entity_field_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_dataset_entity"><dataset_entity_obj>1007600181.08</dataset_entity_obj>
<deploy_dataset_obj>1007600179.08</deploy_dataset_obj>
<entity_sequence>2</entity_sequence>
<entity_mnemonic>GSMEV</entity_mnemonic>
<primary_entity>no</primary_entity>
<join_entity_mnemonic>GSMEF</join_entity_mnemonic>
<join_field_list>entity_field_obj,entity_field_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="38"><contained_record DB="ICFDB" Table="gsc_deploy_dataset"><deploy_dataset_obj>1007600182.08</deploy_dataset_obj>
<owner_site_code></owner_site_code>
<dataset_code>GSCEP</dataset_code>
<dataset_description>gsc_entity_mnemonic_procedure</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<contained_record DB="ICFDB" Table="gsc_dataset_entity"><dataset_entity_obj>1007600183.08</dataset_entity_obj>
<deploy_dataset_obj>1007600182.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSCEP</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>entity_mnemonic_procedure_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="39"><contained_record DB="ICFDB" Table="gsc_deploy_dataset"><deploy_dataset_obj>1007600184.08</deploy_dataset_obj>
<owner_site_code></owner_site_code>
<dataset_code>GSCCP</dataset_code>
<dataset_description>gsc_custom_procedure</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<contained_record DB="ICFDB" Table="gsc_dataset_entity"><dataset_entity_obj>1007600185.08</dataset_entity_obj>
<deploy_dataset_obj>1007600184.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSCCP</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>procedure_name</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="40"><contained_record DB="ICFDB" Table="gsc_deploy_dataset"><deploy_dataset_obj>1007600186.08</deploy_dataset_obj>
<owner_site_code></owner_site_code>
<dataset_code>GSMCL</dataset_code>
<dataset_description>gsm_control_code</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<contained_record DB="ICFDB" Table="gsc_dataset_entity"><dataset_entity_obj>1007600187.08</dataset_entity_obj>
<deploy_dataset_obj>1007600186.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSMCL</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>control_code_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="41"><contained_record DB="ICFDB" Table="gsc_deploy_dataset"><deploy_dataset_obj>1007600188.08</deploy_dataset_obj>
<owner_site_code></owner_site_code>
<dataset_code>GSMCM</dataset_code>
<dataset_description>gsm_comment - Comments</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<contained_record DB="ICFDB" Table="gsc_dataset_entity"><dataset_entity_obj>1007600189.08</dataset_entity_obj>
<deploy_dataset_obj>1007600188.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSMCM</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>comment_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="42"><contained_record DB="ICFDB" Table="gsc_deploy_dataset"><deploy_dataset_obj>1007600190.08</deploy_dataset_obj>
<owner_site_code></owner_site_code>
<dataset_code>GSMCA</dataset_code>
<dataset_description>gsm_category - Categories</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<contained_record DB="ICFDB" Table="gsc_dataset_entity"><dataset_entity_obj>1007600191.08</dataset_entity_obj>
<deploy_dataset_obj>1007600190.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSMCA</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>category_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="43"><contained_record DB="ICFDB" Table="gsc_deploy_dataset"><deploy_dataset_obj>1007600192.08</deploy_dataset_obj>
<owner_site_code></owner_site_code>
<dataset_code>GSMMM</dataset_code>
<dataset_description>gsm_multi_media - Multi Media</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<contained_record DB="ICFDB" Table="gsc_dataset_entity"><dataset_entity_obj>1007600193.08</dataset_entity_obj>
<deploy_dataset_obj>1007600192.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSMMM</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>multi_media_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="44"><contained_record DB="ICFDB" Table="gsc_deploy_dataset"><deploy_dataset_obj>1007600194.08</deploy_dataset_obj>
<owner_site_code></owner_site_code>
<dataset_code>GSCMM</dataset_code>
<dataset_description>gsc_multi_media_type - Multi Media</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<contained_record DB="ICFDB" Table="gsc_dataset_entity"><dataset_entity_obj>1007600195.08</dataset_entity_obj>
<deploy_dataset_obj>1007600194.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSCMM</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>multi_media_type_code</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="45"><contained_record DB="ICFDB" Table="gsc_deploy_dataset"><deploy_dataset_obj>1007600196.08</deploy_dataset_obj>
<owner_site_code></owner_site_code>
<dataset_code>GSCEM</dataset_code>
<dataset_description>gsc_entity_mnemonic - Entity Mnemon</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<contained_record DB="ICFDB" Table="gsc_dataset_entity"><dataset_entity_obj>1007600197.08</dataset_entity_obj>
<deploy_dataset_obj>1007600196.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSCEM</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>entity_mnemonic</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_dataset_entity"><dataset_entity_obj>1007600198.08</dataset_entity_obj>
<deploy_dataset_obj>1007600196.08</deploy_dataset_obj>
<entity_sequence>2</entity_sequence>
<entity_mnemonic>GSCED</entity_mnemonic>
<primary_entity>no</primary_entity>
<join_entity_mnemonic>GSCEM</join_entity_mnemonic>
<join_field_list>entity_mnemonic,entity_mnemonic</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="46"><contained_record DB="ICFDB" Table="gsc_deploy_dataset"><deploy_dataset_obj>1007600199.08</deploy_dataset_obj>
<owner_site_code></owner_site_code>
<dataset_code>GSMRA</dataset_code>
<dataset_description>gsm_range - Ranges</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<contained_record DB="ICFDB" Table="gsc_dataset_entity"><dataset_entity_obj>1007600200.08</dataset_entity_obj>
<deploy_dataset_obj>1007600199.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSMRA</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>range_code</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="47"><contained_record DB="ICFDB" Table="gsc_deploy_dataset"><deploy_dataset_obj>1007600201.08</deploy_dataset_obj>
<owner_site_code></owner_site_code>
<dataset_code>GSMFF</dataset_code>
<dataset_description>gsm_field - Fields</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<contained_record DB="ICFDB" Table="gsc_dataset_entity"><dataset_entity_obj>1007600202.08</dataset_entity_obj>
<deploy_dataset_obj>1007600201.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSMFF</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>field_name</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="48"><contained_record DB="ICFDB" Table="gsc_deploy_dataset"><deploy_dataset_obj>1007600203.08</deploy_dataset_obj>
<owner_site_code></owner_site_code>
<dataset_code>GSMTO</dataset_code>
<dataset_description>gsm_token - Tokens</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<contained_record DB="ICFDB" Table="gsc_dataset_entity"><dataset_entity_obj>1007600204.08</dataset_entity_obj>
<deploy_dataset_obj>1007600203.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSMTO</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>token_code</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="49"><contained_record DB="ICFDB" Table="gsc_deploy_dataset"><deploy_dataset_obj>1007600205.08</deploy_dataset_obj>
<owner_site_code></owner_site_code>
<dataset_code>GSCSC</dataset_code>
<dataset_description>gsc_security_control - Security Ctr</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<contained_record DB="ICFDB" Table="gsc_dataset_entity"><dataset_entity_obj>1007600206.08</dataset_entity_obj>
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
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="50"><contained_record DB="ICFDB" Table="gsc_deploy_dataset"><deploy_dataset_obj>1007600207.08</deploy_dataset_obj>
<owner_site_code></owner_site_code>
<dataset_code>GSMSI</dataset_code>
<dataset_description>gsm_site - Sites</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<contained_record DB="ICFDB" Table="gsc_dataset_entity"><dataset_entity_obj>1007600208.08</dataset_entity_obj>
<deploy_dataset_obj>1007600207.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSMSI</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>site_code</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="51"><contained_record DB="ICFDB" Table="gsc_deploy_dataset"><deploy_dataset_obj>1007600209.08</deploy_dataset_obj>
<owner_site_code></owner_site_code>
<dataset_code>GSMST</dataset_code>
<dataset_description>gsm_status</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<contained_record DB="ICFDB" Table="gsc_dataset_entity"><dataset_entity_obj>1007600210.08</dataset_entity_obj>
<deploy_dataset_obj>1007600209.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSMST</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>status_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_dataset_entity"><dataset_entity_obj>1007600211.08</dataset_entity_obj>
<deploy_dataset_obj>1007600209.08</deploy_dataset_obj>
<entity_sequence>2</entity_sequence>
<entity_mnemonic>GSMSH</entity_mnemonic>
<primary_entity>no</primary_entity>
<join_entity_mnemonic>GSMST</join_entity_mnemonic>
<join_field_list>status_obj,status_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="52"><contained_record DB="ICFDB" Table="gsc_deploy_dataset"><deploy_dataset_obj>1007600212.08</deploy_dataset_obj>
<owner_site_code></owner_site_code>
<dataset_code>GSMHE</dataset_code>
<dataset_description>gsm_help - Help</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<contained_record DB="ICFDB" Table="gsc_dataset_entity"><dataset_entity_obj>1007600213.08</dataset_entity_obj>
<deploy_dataset_obj>1007600212.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSMHE</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>help_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="53"><contained_record DB="ICFDB" Table="gsc_deploy_dataset"><deploy_dataset_obj>1007600214.08</deploy_dataset_obj>
<owner_site_code></owner_site_code>
<dataset_code>GSCER</dataset_code>
<dataset_description>gsc_error - Errors</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<contained_record DB="ICFDB" Table="gsc_dataset_entity"><dataset_entity_obj>1007600215.08</dataset_entity_obj>
<deploy_dataset_obj>1007600214.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSCER</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>error_group,error_number</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
</contained_record>
</contained_record>
</dataset_transaction>
</dataset_records>
</dataset>