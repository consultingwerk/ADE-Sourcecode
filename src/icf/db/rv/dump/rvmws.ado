<?xml version="1.0" encoding="ISO8859-1" ?>
<dataset Transactions="4"><dataset_header DisableRI="yes" DatasetObj="1000000162.39" DateFormat="mdy" FullHeader="yes" SCMManaged="no" YearOffset="1950" DatasetCode="RVMWS" DateCreated="02/14/2002" TimeCreated="11:20:05" NumericFormat="AMERICAN" NumericDecimal="." OriginatingSite="93" NumericSeparator=","><deploy_dataset_obj>1000000162.39</deploy_dataset_obj>
<owner_site_code></owner_site_code>
<dataset_code>RVMWS</dataset_code>
<dataset_description>rvm_workspace</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<dataset_entity><dataset_entity_obj>1000000164.39</dataset_entity_obj>
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
<entity_mnemonic_description>rvm_workspace</entity_mnemonic_description>
<entity_dbname>rvdb</entity_dbname>
</dataset_entity>
<dataset_entity><dataset_entity_obj>1000000166.39</dataset_entity_obj>
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
<entity_mnemonic_description>rvm_workspace_module</entity_mnemonic_description>
<entity_dbname>rvdb</entity_dbname>
</dataset_entity>
<dataset_entity><dataset_entity_obj>1000000168.39</dataset_entity_obj>
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
<entity_mnemonic_description>rvm_workspace_item</entity_mnemonic_description>
<entity_dbname>rvdb</entity_dbname>
</dataset_entity>
<table_definition><name>rvm_workspace</name>
<dbname>RVDB</dbname>
<index-1>XAK1rvm_workspace,1,0,0,workspace_code,0</index-1>
<index-2>XIE1rvm_workspace,0,0,0,workspace_description,0</index-2>
<index-3>XPKrvm_workspace,1,1,0,workspace_obj,0</index-3>
<field><name>workspace_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>>>>>>>>>>>>>>>>>>9.999999999</format>
<initial>                 0.000000000</initial>
<label>Workspace Obj</label>
<column-label>Workspace Obj</column-label>
</field>
<field><name>workspace_code</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(10)</format>
<initial></initial>
<label>Workspace Code</label>
<column-label>Workspace Code</column-label>
</field>
<field><name>workspace_description</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>Workspace Description</label>
<column-label>Workspace Description</column-label>
</field>
<field><name>workspace_locked</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>Workspace Locked</label>
<column-label>Workspace Locked</column-label>
</field>
<field><name>data_version_table</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>Data Version Table</label>
<column-label>Data Version Table</column-label>
</field>
<field><name>root_directory</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Root Directory</label>
<column-label>Root Directory</column-label>
</field>
</table_definition>
<table_definition><name>rvm_workspace_module</name>
<dbname>RVDB</dbname>
<index-1>XAK1rvm_workspace_module,1,0,0,workspace_obj,0,product_module_obj,0</index-1>
<index-2>XAK2rvm_workspace_module,1,0,0,product_module_obj,0,workspace_obj,0</index-2>
<index-3>XIE1rvm_workspace_module,0,0,0,source_workspace_obj,0,workspace_obj,0</index-3>
<index-4>XPKrvm_workspace_module,1,1,0,workspace_module_obj,0</index-4>
<field><name>workspace_module_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>>>>>>>>>>>>>>>>>>9.999999999</format>
<initial>                 0.000000000</initial>
<label>Workspace Module Obj</label>
<column-label>Workspace Module Obj</column-label>
</field>
<field><name>workspace_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>>>>>>>>>>>>>>>>>>9.999999999</format>
<initial>                 0.000000000</initial>
<label>Workspace Obj</label>
<column-label>Workspace Obj</column-label>
</field>
<field><name>product_module_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>>>>>>>>>>>>>>>>>>9.999999999</format>
<initial>                 0.000000000</initial>
<label>Product Module Obj</label>
<column-label>Product Module Obj</column-label>
</field>
<field><name>source_workspace_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>>>>>>>>>>>>>>>>>>9.999999999</format>
<initial>                 0.000000000</initial>
<label>Source Workspace Obj</label>
<column-label>Source Workspace Obj</column-label>
</field>
<field><name>include_in_import</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>YES</initial>
<label>Include in Import</label>
<column-label>Include in Import</column-label>
</field>
</table_definition>
<table_definition><name>rvm_workspace_item</name>
<dbname>RVDB</dbname>
<index-1>XAK1rvm_workspace_item,1,0,0,workspace_obj,0,configuration_type,0,scm_object_name,0</index-1>
<index-2>XAK3rvm_workspace_item,1,0,0,configuration_type,0,scm_object_name,0,product_module_obj,0,item_version_number,0,workspace_obj,0</index-2>
<index-3>XAK4rvm_workspace_item,1,0,0,configuration_type,0,scm_object_name,0,task_version_number,0,task_product_module_obj,0,workspace_obj,0</index-3>
<index-4>XIE1rvm_workspace_item,0,0,0,product_module_obj,0</index-4>
<index-5>XIE2rvm_workspace_item,0,0,0,task_product_module_obj,0</index-5>
<index-6>XPKrvm_workspace_item,1,1,0,workspace_item_obj,0</index-6>
<field><name>workspace_item_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>>>>>>>>>>>>>>>>>>9.999999999</format>
<initial>                 0.000000000</initial>
<label>Workspace Item Obj</label>
<column-label>Workspace Item Obj</column-label>
</field>
<field><name>workspace_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>>>>>>>>>>>>>>>>>>9.999999999</format>
<initial>                 0.000000000</initial>
<label>Workspace Obj</label>
<column-label>Workspace Obj</column-label>
</field>
<field><name>configuration_type</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(8)</format>
<initial></initial>
<label>Configuration Type</label>
<column-label>Configuration Type</column-label>
</field>
<field><name>scm_object_name</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>Scm Object Name</label>
<column-label>Scm Object Name</column-label>
</field>
<field><name>product_module_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>>>>>>>>>>>>>>>>>>9.999999999</format>
<initial>                 0.000000000</initial>
<label>Product Module Obj</label>
<column-label>Product Module Obj</column-label>
</field>
<field><name>item_version_number</name>
<data-type>integer</data-type>
<extent>0</extent>
<format>->>>>>9</format>
<initial>      0</initial>
<label>Item Version Number</label>
<column-label>Item Version Number</column-label>
</field>
<field><name>task_product_module_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>>>>>>>>>>>>>>>>>>9.999999999</format>
<initial>                 0.000000000</initial>
<label>Task Product Module Obj</label>
<column-label>Task Product Module Obj</column-label>
</field>
<field><name>task_version_number</name>
<data-type>integer</data-type>
<extent>0</extent>
<format>->>>>>9</format>
<initial>      0</initial>
<label>Task Version Number</label>
<column-label>Task Version Number</column-label>
</field>
</table_definition>
</dataset_header>
<dataset_records><dataset_transaction TransactionNo="1"><contained_record DB="RVDB" Table="rvm_workspace"><workspace_obj>1000000142.39</workspace_obj>
<workspace_code>090dyn-dep</workspace_code>
<workspace_description>Dynamics Deployment Workspace</workspace_description>
<workspace_locked>no</workspace_locked>
<data_version_table>rym_data_version</data_version_table>
<root_directory>c:/dynamics/090/dep/src</root_directory>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="2"><contained_record DB="RVDB" Table="rvm_workspace"><workspace_obj>1004873307.09</workspace_obj>
<workspace_code>091dyn-dev</workspace_code>
<workspace_description>Dynamics Application Development</workspace_description>
<workspace_locked>no</workspace_locked>
<data_version_table>rym_data_version</data_version_table>
<root_directory>c:/dynamics/091/dev/src</root_directory>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004935448.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>rycso</configuration_type>
<scm_object_name>aaaaafullb</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004874770.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>afallmencw</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10003</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004874803.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>afspfoldrw.w</scm_object_name>
<product_module_obj>1004874688.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957073.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>rycso</configuration_type>
<scm_object_name>benefitsfullo.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>1004874683.09</task_product_module_obj>
<task_version_number>10000</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1005077594.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>rycso</configuration_type>
<scm_object_name>customerb</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>1004874683.09</task_product_module_obj>
<task_version_number>10000</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004956784.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>rycso</configuration_type>
<scm_object_name>customerfullo.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>1004874683.09</task_product_module_obj>
<task_version_number>10000</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1005077622.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>rycso</configuration_type>
<scm_object_name>customerobjcw</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>1004874679.09</task_product_module_obj>
<task_version_number>10000</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004936315.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>rycso</configuration_type>
<scm_object_name>gscad2fullb</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>1004874683.09</task_product_module_obj>
<task_version_number>10000</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004874808.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscadfullo.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004944383.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscddfol2w</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004929064.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscddfullb</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004928870.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscddfullo.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004929095.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscddobjcw</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004929912.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscddviewv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004932274.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscdeccsfv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004930431.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscdefullb</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004930387.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscdefullo.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004931189.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscdeviewv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10005</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004893045.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscemfol2w</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004888127.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscemfullb</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004887722.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscemfullo.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004888360.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscemobjcw</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004892173.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscemviewv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10003</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004874813.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscerfiltv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004874880.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscerfol2w</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004874889.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscerfullb</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004874894.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscerfullo.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004874956.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscerobjcw</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004874961.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscerviewv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004886754.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsciafol2w</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004886545.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsciafullb</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004886504.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsciafullo.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004886564.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsciaobjcw</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004886742.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsciaviewv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004875028.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsclgfol2w</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004875037.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsclgfullb</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004875042.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsclgfullo.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004875101.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsclgobjcw</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004875106.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsclgviewv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004899248.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsclsdcsfv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004901132.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsclsfol2w</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004900922.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsclsfullb</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004900913.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsclsfullo.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004900939.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsclsobjcw</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004901113.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsclsviewv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004875173.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscmmfol2w</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004875182.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscmmfullb</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004875187.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscmmfullo.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004875246.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscmmobjcw</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004875305.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscmmobscw</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004875310.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscmmviewv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004907000.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscmtdcsfv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004898373.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscmtfol2w</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004898170.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscmtfullb</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004898160.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscmtfullo.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004898188.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscmtobjcw</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004898362.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscmtviewv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004875315.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscobfiltv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10003</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004875382.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscobfol2w</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004875387.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscobful2o.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10005</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004875396.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscobfullb</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004936419.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscobfullo.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10101</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004875471.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscobobjcw</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004875530.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscobobjw</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004875535.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscobviewv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10004</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004875540.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscotcmsfv.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004875545.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscotdcs2v.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004913613.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscotfoldw</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004875624.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscotfullb</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004875640.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscotfullo.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004913867.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscotobjcw</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004875646.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscotviewv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004896267.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscpcfullb</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004896227.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscpcfullo.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004897045.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscpcviewv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004895996.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscpffol2w</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004894560.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscpffullb</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004894550.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscpffullo.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004894578.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscpfobjcw</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004895804.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscpfviewv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004875651.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscpmcsdfv.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004885406.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscpmfullb</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004884323.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscpmfullo.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>1004874683.09</task_product_module_obj>
<task_version_number>10003</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004875656.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscpmprdfv.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004885782.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscpmviewv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004875661.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscprcsdfv.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004875728.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscprfol2w</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10003</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004875737.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscprfullb</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004875742.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscprfullo.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004875801.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscprobjcw</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004875806.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscprviewv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004882861.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscrffol2w</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004882619.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscrffullb</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004882609.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscrffullo.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004882637.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscrfobjcw</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004882811.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscrfviewv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004875896.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscscfol2w</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004875901.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscscfullo.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004875906.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscscviewv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004916874.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscspdcsfv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004914668.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscspfol2w</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004914460.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscspfullb</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004914450.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscspfullo.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004914478.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscspobjcw</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004935487.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscspviewv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10003</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004875973.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscsqfol2w</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004875982.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscsqfullb</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004875987.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscsqfullo.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004876046.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscsqobjcw</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004876051.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscsqviewv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004901122.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscstdcsfv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10003</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004899258.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscstfol2</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004899441.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscstfol2w</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004898570.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscstfullb</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004898560.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscstfullo.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004898587.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscstobjcw</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004898996.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscstviewv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004936447.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmca3fullb</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004876118.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmcafol2w</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004876127.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmcafullb</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004876132.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmcafullo.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10003</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004876191.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmcaobjcw</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004876196.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmcaviewv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10003</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004876208.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmcofullb</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004933211.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmddfullb</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004933201.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmddfullo.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004933832.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmddviewv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004876341.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmfffol2w</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004876350.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmfffullb</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004876355.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmfffullo.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004876414.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmffobjcw</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004876423.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmffullb</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004876428.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmffviewv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004876487.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmfobjcw</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004876554.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmhefol2w</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004876563.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmhefullb</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004876568.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmhefullo.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004876627.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmheobjcw</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004876632.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmheviewv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004876637.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmlgdcsfv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10102</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004876704.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmlgfol2w</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004876713.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmlgfullb</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004876718.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmlgfullo.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004876777.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmlgobjcw</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004876782.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmlgviewv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004917066.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmmidcsfv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10004</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004876791.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmmifullb</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004876796.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmmifullo.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10003</item_version_number>
<task_product_module_obj>1004874683.09</task_product_module_obj>
<task_version_number>10004</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004876801.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmmiviewv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10004</item_version_number>
<task_product_module_obj>1004874683.09</task_product_module_obj>
<task_version_number>10005</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004876934.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmmsfol2w</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004876943.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmmsfullb</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004876948.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmmsfullo.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004877007.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmmsobjcw</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004877012.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmmsviewv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004910260.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmomfullb</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004910250.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmomfullo.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10003</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004912206.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmomviewv.w</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10003</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004919106.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmpydatfv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10003</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004903235.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmpydcsfv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004904318.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmpyfol2w</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004904116.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmpyfullb</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004956389.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmpyfullo.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10003</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004904133.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmpyobjcw</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004925757.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmpyviewv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10005</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004877017.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmra6viewv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004877150.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmrafol2w</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004877159.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmrafullb</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004877164.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmrafullo.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004877223.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmraobjcw</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004877228.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmraview.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004877233.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmraviewv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004949782.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>rycso</configuration_type>
<scm_object_name>gsmrdfullb</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>1004874683.09</task_product_module_obj>
<task_version_number>10000</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004950063.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>rycso</configuration_type>
<scm_object_name>gsmrdobjcw</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>1004874679.09</task_product_module_obj>
<task_version_number>10000</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004906381.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmrmfullb</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004906372.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmrmfullo.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004907009.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmrmviewv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004901958.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmsedcsfv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004910216.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmsedtf1v.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10003</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004911035.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmsedtf2v.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10004</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004905760.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmsefol2w</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004905513.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmsefullb</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004905503.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmsefullo.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004905530.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmseobjcw</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004905704.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmseviewv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004894188.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmsifol2w</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004893468.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmsifullb</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004893458.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmsifullo.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004893486.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmsiobjcw</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004893660.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmsiviewv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004877242.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmssfullb</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004877247.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmssfullo.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004877252.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmssviewv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004877318.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmstfol2w</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004877327.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmstfullb</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004877332.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmstfullo.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004877391.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmstobjcw</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004877396.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmstview.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004901571.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmsvfullb</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004901562.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmsvfullo.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10003</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004901934.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmsvviewv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10004</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004916068.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmsyfullb</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004914852.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmsyfullo.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10003</item_version_number>
<task_product_module_obj>1004874683.09</task_product_module_obj>
<task_version_number>10004</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004916436.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmsyviewv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10004</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004877463.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmtfol2w</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004877530.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmtlfol2w</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004877539.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmtlfullb</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004877544.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmtlfullo.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004877603.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmtlobjcw</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004877608.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmtlviewv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004877741.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmtofol2w</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004877750.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmtofullb</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004877755.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmtofullo.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004935569.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmtoobjcw</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004877819.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmtoviewv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004877903.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmucdcsfv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>1004874683.09</task_product_module_obj>
<task_version_number>10100</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004877970.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmucfol2w</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004877975.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmucful2o.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004877984.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmucfullb</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004878043.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmucobjcw</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004878048.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmucviewv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004883886.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>rycso</configuration_type>
<scm_object_name>gsmulfol2w</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>1004874679.09</task_product_module_obj>
<task_version_number>10000</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004924339.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmulfullo.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>1004874683.09</task_product_module_obj>
<task_version_number>10000</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004883877.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmullkpfv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>1004874683.09</task_product_module_obj>
<task_version_number>10000</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004900144.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmulvie2v.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>1004874683.09</task_product_module_obj>
<task_version_number>10000</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004883868.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmulviewv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>1004874683.09</task_product_module_obj>
<task_version_number>10000</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004898058.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmusdcsfv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>1004874683.09</task_product_module_obj>
<task_version_number>10000</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004948131.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>rycso</configuration_type>
<scm_object_name>gsmusfldr</scm_object_name>
<product_module_obj>1004874674.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>1004874674.09</task_product_module_obj>
<task_version_number>10000</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004878115.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmusfol2w</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>1004874679.09</task_product_module_obj>
<task_version_number>10100</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004947613.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>rycso</configuration_type>
<scm_object_name>gsmusful2b</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>1004874683.09</task_product_module_obj>
<task_version_number>10000</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004878124.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmusfullb</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004878129.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmusfullo.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>1004874683.09</task_product_module_obj>
<task_version_number>10100</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004947641.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>rycso</configuration_type>
<scm_object_name>gsmusobj2w</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>1004874679.09</task_product_module_obj>
<task_version_number>10000</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004878188.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmusobjcw</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>1004874679.09</task_product_module_obj>
<task_version_number>10100</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004892624.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmusvie3v.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>1004874683.09</task_product_module_obj>
<task_version_number>10000</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004878193.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmusviewv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>1004874683.09</task_product_module_obj>
<task_version_number>10100</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004887358.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>rycso</configuration_type>
<scm_object_name>gstphfullb</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>1004874683.09</task_product_module_obj>
<task_version_number>10000</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004887198.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gstphfullo.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>1004874683.09</task_product_module_obj>
<task_version_number>10000</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004928205.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gstrvfullb</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004936170.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gstrvfullo.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004928236.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gstrvobjcw</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004948739.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>rycso</configuration_type>
<scm_object_name>itemfullb</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>1004874683.09</task_product_module_obj>
<task_version_number>10000</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957633.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>rycso</configuration_type>
<scm_object_name>itemfullo.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>1004874683.09</task_product_module_obj>
<task_version_number>10000</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004948796.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>rycso</configuration_type>
<scm_object_name>itemobjcw</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>1004874683.09</task_product_module_obj>
<task_version_number>10000</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1005020350.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>rycso</configuration_type>
<scm_object_name>ordlintamb</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>1004874683.09</task_product_module_obj>
<task_version_number>10000</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1005019958.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>rycso</configuration_type>
<scm_object_name>ordtamb1</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>1004874683.09</task_product_module_obj>
<task_version_number>10000</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1005019987.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>rycso</configuration_type>
<scm_object_name>ordtamfold1</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>1004874679.09</task_product_module_obj>
<task_version_number>10000</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1005025398.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>rycso</configuration_type>
<scm_object_name>ordtamfold2</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>1004874679.09</task_product_module_obj>
<task_version_number>10000</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1005043439.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>rycso</configuration_type>
<scm_object_name>ordtamfold3</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>1004874679.09</task_product_module_obj>
<task_version_number>10000</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1005043971.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>rycso</configuration_type>
<scm_object_name>ordtamfold4</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>1004874679.09</task_product_module_obj>
<task_version_number>10000</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1005047468.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>rycso</configuration_type>
<scm_object_name>ordtamfold5</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>1004874679.09</task_product_module_obj>
<task_version_number>10000</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1005047893.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>rycso</configuration_type>
<scm_object_name>ordtamfold6</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>1004874679.09</task_product_module_obj>
<task_version_number>10000</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1005048913.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>rycso</configuration_type>
<scm_object_name>ordtamfold7</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>1004874679.09</task_product_module_obj>
<task_version_number>10000</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1005049347.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>rycso</configuration_type>
<scm_object_name>ordtamfold8</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>1004874679.09</task_product_module_obj>
<task_version_number>10000</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1005049767.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>rycso</configuration_type>
<scm_object_name>ordtamfold9</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>1004874679.09</task_product_module_obj>
<task_version_number>10000</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004895813.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>pscpffol2w</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004943656.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>rycso</configuration_type>
<scm_object_name>rvcctfol2w</scm_object_name>
<product_module_obj>1004874698.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>1004874698.09</task_product_module_obj>
<task_version_number>10000</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004943385.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>rycso</configuration_type>
<scm_object_name>rvcctfullb</scm_object_name>
<product_module_obj>1004874698.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>1004874698.09</task_product_module_obj>
<task_version_number>10000</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004943319.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rvcctfullo.w</scm_object_name>
<product_module_obj>1004874698.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>1004874698.09</task_product_module_obj>
<task_version_number>10000</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004943440.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>rycso</configuration_type>
<scm_object_name>rvcctobjcw</scm_object_name>
<product_module_obj>1004874701.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>1004874701.09</task_product_module_obj>
<task_version_number>10000</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004943350.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rvcctviewv.w</scm_object_name>
<product_module_obj>1004874698.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>1004874698.09</task_product_module_obj>
<task_version_number>10000</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004878260.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rvmwsfol2w</scm_object_name>
<product_module_obj>1004874701.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004878272.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rvmwsfullb</scm_object_name>
<product_module_obj>1004874698.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004919273.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rvmwsobjcw</scm_object_name>
<product_module_obj>1004874701.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004878288.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rvmwssdoo.w</scm_object_name>
<product_module_obj>1004874698.09</product_module_obj>
<item_version_number>10003</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004878294.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rvmwsviewv.w</scm_object_name>
<product_module_obj>1004874698.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004919139.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rvutlmencw</scm_object_name>
<product_module_obj>1004874701.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004878299.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycagdcsfv.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004878419.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycagfoldw</scm_object_name>
<product_module_obj>1004874710.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004878428.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycagful2v</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004878436.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycagfullb</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004878445.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycagfullo.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004878451.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycagfullv.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004878514.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycagobjcw</scm_object_name>
<product_module_obj>1004874710.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004878581.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycapfoldw</scm_object_name>
<product_module_obj>1004874710.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004878593.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycapfullb</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004878609.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycapfullo.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004878682.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycapobjcw</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004878688.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycapviewv.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004878693.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycatccsfv.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004878698.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycatfiltv.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004878765.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycatfoldw</scm_object_name>
<product_module_obj>1004874710.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004878777.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycatfullb</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004946703.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycatfullo.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004878869.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycatobjcw</scm_object_name>
<product_module_obj>1004874710.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004878875.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycatvew2v.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004878880.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycatviewv.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004878885.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycavfgrpv.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004878890.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycavfiltv.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004878957.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycavfoldw</scm_object_name>
<product_module_obj>1004874710.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004964880.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycavful2o.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004984052.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycavful3b</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004878969.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycavfullb</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10100</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004997649.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycavfullo.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10100</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004878990.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycavfullv.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004879066.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycavobjcw</scm_object_name>
<product_module_obj>1004874710.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004879072.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycavviewv.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004879077.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycaycsdfv.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004879144.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycayfoldw</scm_object_name>
<product_module_obj>1004874710.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004879156.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycayfullb</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004879171.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycayfullo.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004879243.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycayobjcw</scm_object_name>
<product_module_obj>1004874710.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004879249.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycayviewv.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004879261.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycbafullb</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004879277.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycbafullo.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004879350.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycbaobjcw</scm_object_name>
<product_module_obj>1004874710.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004879417.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycbdfoldw</scm_object_name>
<product_module_obj>1004874710.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004879429.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycbdful2b</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004879445.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycbdful2o.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004879464.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycbdfullb</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004879537.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycbdobj2w</scm_object_name>
<product_module_obj>1004874710.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004879543.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycbdviewv.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004879548.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>ryclacmsfv.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004879615.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>ryclafoldw</scm_object_name>
<product_module_obj>1004874710.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004879627.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>ryclafullb</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004879643.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>ryclafullo.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004879648.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>ryclafullv.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004879721.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>ryclaobjcw</scm_object_name>
<product_module_obj>1004874710.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004960703.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycoiful2b</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004990788.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycoiful2o.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>1004874707.09</task_product_module_obj>
<task_version_number>10000</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004989364.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycoiful3b</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004879733.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycoifullb</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004992999.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycoifullo.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10100</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004879822.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycoiobjcw</scm_object_name>
<product_module_obj>1004874710.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004961526.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycoiviewv.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004966042.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycpafullb</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004966010.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycpafullo.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1005035457.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycpaviewv.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1005022064.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycsmful2b</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004971323.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycsmfullb</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1005011944.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycsmfullo.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10100</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1005038940.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycsmviewv.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004921063.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycsofol2w</scm_object_name>
<product_module_obj>1004874710.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004984797.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycsofol3w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004879908.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycsofoldw</scm_object_name>
<product_module_obj>1004874710.09</product_module_obj>
<item_version_number>10100</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004879920.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycsoful2b</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004879932.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycsofullb</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10100</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004879948.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycsofullo.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10100</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004880021.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycsoobjcw</scm_object_name>
<product_module_obj>1004874698.09</product_module_obj>
<item_version_number>10100</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004880026.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycsovie2v.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10100</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957833.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycsovie3v.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1005054779.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycsovie4v.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1005040809.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycsovie5v.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004880031.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycsoviewv.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10100</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004880098.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycstfoldw</scm_object_name>
<product_module_obj>1004874710.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004880110.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycstfullb</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004880126.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycstfullo.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004880199.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycstobjcw</scm_object_name>
<product_module_obj>1004874710.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004880204.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycstviewv.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004880269.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rydynlookw</scm_object_name>
<product_module_obj>1004874710.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004880297.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rydynmenu1</scm_object_name>
<product_module_obj>1004874710.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004880362.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rydynprefw</scm_object_name>
<product_module_obj>1004874710.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004880367.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rydynprf1v.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004880372.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rydynprf2v.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004880396.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rydyntoolt.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>1004874707.09</task_product_module_obj>
<task_version_number>10100</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004880401.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rydyntranv.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>1004874707.09</task_product_module_obj>
<task_version_number>10100</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004880462.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rydyntranw</scm_object_name>
<product_module_obj>1004874710.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004880467.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rylookupbv.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004880472.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rylookupfv.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004880539.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rymfpfoldw</scm_object_name>
<product_module_obj>1004874710.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004880551.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rymfpfullb</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004880567.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rymfpfullo.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004880640.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rymfpobjcw</scm_object_name>
<product_module_obj>1004874710.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004880646.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rymfpviewv.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004880713.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rymlffoldw</scm_object_name>
<product_module_obj>1004874710.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004880725.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rymlffullb</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004880741.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rymlffullo.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004880814.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rymlfobjcw</scm_object_name>
<product_module_obj>1004874710.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004880819.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rymlfviewv.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004880886.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rymwbfoldw</scm_object_name>
<product_module_obj>1004874710.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004880898.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rymwbfullb</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004880914.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rymwbfullo.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004880990.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rymwbobjcw</scm_object_name>
<product_module_obj>1004874710.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004880997.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rymwbviewv.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004881144.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rymwffol2w</scm_object_name>
<product_module_obj>1004874710.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004946241.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rymwffoldw</scm_object_name>
<product_module_obj>1004874710.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004881303.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rymwffullb</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004881319.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rymwffullo.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004946164.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rymwfobjcw</scm_object_name>
<product_module_obj>1004874710.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004881401.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rymwfviewv.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004881469.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rymwmfol3w</scm_object_name>
<product_module_obj>1004874710.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004881536.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rymwmfoldw</scm_object_name>
<product_module_obj>1004874710.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004881548.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rymwmful2b</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004881560.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rymwmful3b</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004881572.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rymwmfullb</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004936814.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rymwmfullo.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004881660.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rymwmobj2w</scm_object_name>
<product_module_obj>1004874710.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004881733.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rymwmobj3w</scm_object_name>
<product_module_obj>1004874710.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004881809.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rymwmobjcw</scm_object_name>
<product_module_obj>1004874710.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004881815.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rymwmviewv.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004881882.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rymwofoldw</scm_object_name>
<product_module_obj>1004874710.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004937563.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rymwofullb</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004881910.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rymwofullo.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004937486.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rymwoobjcw</scm_object_name>
<product_module_obj>1004874710.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004881992.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rymwoviewv.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004882004.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rymwvfullb</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004882020.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rymwvfullo.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004882096.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rymwvobjcw</scm_object_name>
<product_module_obj>1004874710.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004882101.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rystatusbv.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004882106.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rysttdcsfv.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004882111.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rysttfcsfv.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004882139.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rytstmencw</scm_object_name>
<product_module_obj>1004874710.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004882167.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>ryutlmencw</scm_object_name>
<product_module_obj>1004874710.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004882195.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rywizmencw</scm_object_name>
<product_module_obj>1004874710.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004882200.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rywizpmodv.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004936368.09</workspace_item_obj>
<workspace_obj>1004873307.09</workspace_obj>
<configuration_type>rycso</configuration_type>
<scm_object_name>test</scm_object_name>
<product_module_obj>1004874674.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>1004874674.09</task_product_module_obj>
<task_version_number>10000</task_version_number>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="3"><contained_record DB="RVDB" Table="rvm_workspace"><workspace_obj>1004957150.09</workspace_obj>
<workspace_code>091dyn-tst</workspace_code>
<workspace_description>Dynamics Appliaction Testing</workspace_description>
<workspace_locked>no</workspace_locked>
<data_version_table>rym_data_version</data_version_table>
<root_directory>c:/dynamics/091/tst/src</root_directory>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="4"><contained_record DB="RVDB" Table="rvm_workspace"><workspace_obj>1004957151.09</workspace_obj>
<workspace_code>091dyn-dep</workspace_code>
<workspace_description>Dynamics Application Deployment</workspace_description>
<workspace_locked>no</workspace_locked>
<data_version_table>rym_data_version</data_version_table>
<root_directory>c:/dynamics/091/dep/src</root_directory>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004959362.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>aaaaafullb</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957170.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>afallmencw</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10003</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957171.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>afspfoldrw.w</scm_object_name>
<product_module_obj>1004874688.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957172.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscadfullo.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957173.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscddfol2w</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957174.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscddfullb</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957175.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscddfullo.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957176.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscddobjcw</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957177.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscddviewv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957178.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscdeccsfv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957179.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscdefullb</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957180.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscdefullo.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957181.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscdeviewv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10005</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957182.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscemfol2w</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957183.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscemfullb</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957184.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscemfullo.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957185.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscemobjcw</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957186.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscemviewv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10003</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957187.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscerfiltv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957188.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscerfol2w</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957189.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscerfullb</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957190.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscerfullo.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957191.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscerobjcw</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957192.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscerviewv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957193.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsciafol2w</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957194.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsciafullb</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957195.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsciafullo.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957196.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsciaobjcw</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957197.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsciaviewv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957198.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsclgfol2w</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957199.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsclgfullb</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957200.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsclgfullo.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957201.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsclgobjcw</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957202.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsclgviewv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957203.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsclsdcsfv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957204.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsclsfol2w</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957205.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsclsfullb</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957206.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsclsfullo.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957207.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsclsobjcw</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957208.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsclsviewv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957209.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscmmfol2w</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957210.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscmmfullb</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957211.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscmmfullo.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957212.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscmmobjcw</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957213.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscmmobscw</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957214.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscmmviewv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957215.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscmtdcsfv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957216.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscmtfol2w</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957217.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscmtfullb</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957218.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscmtfullo.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957219.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscmtobjcw</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957220.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscmtviewv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957221.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscobfiltv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10003</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957222.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscobfol2w</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957223.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscobful2o.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10005</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957224.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscobfullb</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957225.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscobfullo.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10101</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957226.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscobobjcw</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957227.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscobobjw</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957228.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscobviewv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10004</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957229.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscotcmsfv.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957230.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscotdcs2v.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957231.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscotfoldw</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957232.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscotfullb</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957233.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscotfullo.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957234.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscotobjcw</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957235.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscotviewv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957236.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscpcfullb</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957237.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscpcfullo.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957238.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscpcviewv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957239.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscpffol2w</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957240.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscpffullb</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957241.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscpffullo.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957242.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscpfobjcw</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957243.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscpfviewv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957244.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscpmcsdfv.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957245.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscpmfullb</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004958368.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscpmfullo.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957246.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscpmprdfv.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004958427.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscpmviewv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957247.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscprcsdfv.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957248.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscprfol2w</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10003</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957249.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscprfullb</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957250.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscprfullo.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957251.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscprobjcw</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957252.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscprviewv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957253.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscrffol2w</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957254.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscrffullb</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957255.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscrffullo.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957256.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscrfobjcw</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957257.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscrfviewv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957258.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscscfol2w</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957259.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscscfullo.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957260.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscscviewv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957261.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscspdcsfv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957262.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscspfol2w</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957263.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscspfullb</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957264.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscspfullo.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957265.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscspobjcw</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957266.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscspviewv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10003</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957267.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscsqfol2w</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957268.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscsqfullb</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957269.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscsqfullo.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957270.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscsqobjcw</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957271.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscsqviewv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957272.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscstdcsfv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10003</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957273.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscstfol2</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957274.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscstfol2w</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957275.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscstfullb</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957276.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscstfullo.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957277.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscstobjcw</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957278.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gscstviewv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957279.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmca3fullb</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957280.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmcafol2w</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957281.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmcafullb</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957282.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmcafullo.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10003</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957283.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmcaobjcw</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957284.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmcaviewv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10003</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957285.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmcofullb</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957286.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmddfullb</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957287.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmddfullo.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957288.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmddviewv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957289.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmfffol2w</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957290.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmfffullb</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957291.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmfffullo.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957292.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmffobjcw</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957293.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmffullb</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957294.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmffviewv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957295.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmfobjcw</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957296.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmhefol2w</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957297.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmhefullb</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957298.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmhefullo.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957299.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmheobjcw</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957300.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmheviewv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957301.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmlgdcsfv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10102</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957302.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmlgfol2w</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957303.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmlgfullb</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957304.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmlgfullo.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957305.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmlgobjcw</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957306.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmlgviewv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957307.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmmidcsfv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10004</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957308.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmmifullb</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957309.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmmifullo.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10003</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957310.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmmiviewv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10004</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957311.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmmsfol2w</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957312.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmmsfullb</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957313.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmmsfullo.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957314.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmmsobjcw</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957315.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmmsviewv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957316.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmomfullb</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957317.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmomfullo.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10003</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957318.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmomviewv.w</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10003</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957319.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmpydatfv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10003</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957320.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmpydcsfv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957321.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmpyfol2w</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957322.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmpyfullb</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957323.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmpyfullo.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10003</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957324.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmpyobjcw</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957325.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmpyviewv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10005</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957326.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmra6viewv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957327.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmrafol2w</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957328.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmrafullb</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957329.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmrafullo.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957330.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmraobjcw</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957331.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmraview.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957332.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmraviewv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957333.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmrmfullb</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957334.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmrmfullo.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957335.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmrmviewv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957336.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmsedcsfv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957337.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmsedtf1v.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10003</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957338.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmsedtf2v.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10004</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957339.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmsefol2w</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957340.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmsefullb</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957341.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmsefullo.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957342.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmseobjcw</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957343.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmseviewv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957344.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmsifol2w</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957345.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmsifullb</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957346.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmsifullo.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957347.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmsiobjcw</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957348.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmsiviewv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957349.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmssfullb</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957350.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmssfullo.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957351.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmssviewv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957352.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmstfol2w</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957353.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmstfullb</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957354.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmstfullo.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957355.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmstobjcw</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957356.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmstview.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957357.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmsvfullb</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957358.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmsvfullo.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10003</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957359.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmsvviewv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10004</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957360.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmsyfullb</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957361.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmsyfullo.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10003</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957362.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmsyviewv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10004</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957363.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmtfol2w</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957364.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmtlfol2w</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957365.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmtlfullb</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957366.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmtlfullo.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957367.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmtlobjcw</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957368.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmtlviewv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957369.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmtofol2w</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957370.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmtofullb</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957371.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmtofullo.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957372.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmtoobjcw</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957373.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmtoviewv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957374.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmucdcsfv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957375.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmucfol2w</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957376.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmucful2o.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957377.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmucfullb</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957378.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmucobjcw</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957379.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmucviewv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957380.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmusfol2w</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957381.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmusfullb</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957382.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmusfullo.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957383.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmusobjcw</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957384.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gsmusviewv.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957385.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gstrvfullb</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957386.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gstrvfullo.w</scm_object_name>
<product_module_obj>1004874683.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957387.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>gstrvobjcw</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957388.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>pscpffol2w</scm_object_name>
<product_module_obj>1004874679.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957389.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rvmwsfol2w</scm_object_name>
<product_module_obj>1004874701.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957390.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rvmwsfullb</scm_object_name>
<product_module_obj>1004874698.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957391.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rvmwsobjcw</scm_object_name>
<product_module_obj>1004874701.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004958281.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rvmwssdoo.w</scm_object_name>
<product_module_obj>1004874698.09</product_module_obj>
<item_version_number>10003</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957392.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rvmwsviewv.w</scm_object_name>
<product_module_obj>1004874698.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957393.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rvutlmencw</scm_object_name>
<product_module_obj>1004874701.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957394.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycagdcsfv.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957395.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycagfoldw</scm_object_name>
<product_module_obj>1004874710.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957396.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycagful2v</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957397.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycagfullb</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957398.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycagfullo.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957399.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycagfullv.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957400.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycagobjcw</scm_object_name>
<product_module_obj>1004874710.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957401.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycapfoldw</scm_object_name>
<product_module_obj>1004874710.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957402.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycapfullb</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957403.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycapfullo.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957404.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycapobjcw</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957405.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycapviewv.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957406.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycatccsfv.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957407.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycatfiltv.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957408.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycatfoldw</scm_object_name>
<product_module_obj>1004874710.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957409.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycatfullb</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957410.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycatfullo.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957411.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycatobjcw</scm_object_name>
<product_module_obj>1004874710.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957412.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycatvew2v.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957413.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycatviewv.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957414.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycavfgrpv.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957415.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycavfiltv.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957416.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycavfoldw</scm_object_name>
<product_module_obj>1004874710.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1005065691.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycavful2o.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1005065706.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycavful3b</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957417.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycavfullb</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10100</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957418.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycavfullo.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10100</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957419.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycavfullv.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957420.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycavobjcw</scm_object_name>
<product_module_obj>1004874710.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957421.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycavviewv.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957422.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycaycsdfv.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957423.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycayfoldw</scm_object_name>
<product_module_obj>1004874710.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957424.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycayfullb</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957425.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycayfullo.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957426.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycayobjcw</scm_object_name>
<product_module_obj>1004874710.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957427.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycayviewv.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957428.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycbafullb</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957429.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycbafullo.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957430.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycbaobjcw</scm_object_name>
<product_module_obj>1004874710.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957431.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycbdfoldw</scm_object_name>
<product_module_obj>1004874710.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957432.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycbdful2b</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957433.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycbdful2o.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957434.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycbdfullb</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957435.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycbdobj2w</scm_object_name>
<product_module_obj>1004874710.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957436.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycbdviewv.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957437.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>ryclacmsfv.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957438.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>ryclafoldw</scm_object_name>
<product_module_obj>1004874710.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957439.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>ryclafullb</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957440.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>ryclafullo.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957441.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>ryclafullv.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957442.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>ryclaobjcw</scm_object_name>
<product_module_obj>1004874710.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1005065717.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycoiful2b</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1005065728.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycoiful3b</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957443.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycoifullb</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957444.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycoifullo.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10100</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957445.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycoiobjcw</scm_object_name>
<product_module_obj>1004874710.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1005065742.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycoiviewv.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1005065747.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycpafullb</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1005065758.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycpafullo.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1005065773.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycpaviewv.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1005065778.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycsmful2b</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1005065789.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycsmfullb</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957446.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycsmfullo.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10100</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1005065803.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycsmviewv.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1005065808.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycsofol2w</scm_object_name>
<product_module_obj>1004874710.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957447.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycsofoldw</scm_object_name>
<product_module_obj>1004874710.09</product_module_obj>
<item_version_number>10100</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957448.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycsoful2b</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957449.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycsofullb</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10100</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957450.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycsofullo.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10100</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957451.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycsoobjcw</scm_object_name>
<product_module_obj>1004874698.09</product_module_obj>
<item_version_number>10100</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957452.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycsovie2v.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10100</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1005066434.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycsovie3v.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1005066439.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycsovie4v.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1005066444.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycsovie5v.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957453.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycsoviewv.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10100</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957454.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycstfoldw</scm_object_name>
<product_module_obj>1004874710.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957455.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycstfullb</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957456.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycstfullo.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957457.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycstobjcw</scm_object_name>
<product_module_obj>1004874710.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957458.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rycstviewv.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957459.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rydynlookw</scm_object_name>
<product_module_obj>1004874710.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957460.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rydynmenu1</scm_object_name>
<product_module_obj>1004874710.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957461.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rydynprefw</scm_object_name>
<product_module_obj>1004874710.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957462.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rydynprf1v.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957463.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rydynprf2v.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957464.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rydyntoolt.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957465.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rydyntranv.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957466.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rydyntranw</scm_object_name>
<product_module_obj>1004874710.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957467.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rylookupbv.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957468.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rylookupfv.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957469.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rymfpfoldw</scm_object_name>
<product_module_obj>1004874710.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957470.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rymfpfullb</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957471.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rymfpfullo.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957472.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rymfpobjcw</scm_object_name>
<product_module_obj>1004874710.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957473.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rymfpviewv.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957474.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rymlffoldw</scm_object_name>
<product_module_obj>1004874710.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957475.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rymlffullb</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957476.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rymlffullo.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957477.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rymlfobjcw</scm_object_name>
<product_module_obj>1004874710.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957478.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rymlfviewv.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957479.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rymwbfoldw</scm_object_name>
<product_module_obj>1004874710.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957480.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rymwbfullb</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957481.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rymwbfullo.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957482.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rymwbobjcw</scm_object_name>
<product_module_obj>1004874710.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957483.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rymwbviewv.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957484.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rymwffol2w</scm_object_name>
<product_module_obj>1004874710.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957485.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rymwffoldw</scm_object_name>
<product_module_obj>1004874710.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957486.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rymwffullb</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957487.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rymwffullo.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957488.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rymwfobjcw</scm_object_name>
<product_module_obj>1004874710.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957489.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rymwfviewv.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957490.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rymwmfol3w</scm_object_name>
<product_module_obj>1004874710.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957491.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rymwmfoldw</scm_object_name>
<product_module_obj>1004874710.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957492.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rymwmful2b</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957493.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rymwmful3b</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957494.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rymwmfullb</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957495.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rymwmfullo.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957496.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rymwmobj2w</scm_object_name>
<product_module_obj>1004874710.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957497.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rymwmobj3w</scm_object_name>
<product_module_obj>1004874710.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957498.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rymwmobjcw</scm_object_name>
<product_module_obj>1004874710.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957499.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rymwmviewv.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957500.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rymwofoldw</scm_object_name>
<product_module_obj>1004874710.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957501.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rymwofullb</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957502.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rymwofullo.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957503.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rymwoobjcw</scm_object_name>
<product_module_obj>1004874710.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957504.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rymwoviewv.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10002</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957505.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rymwvfullb</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957506.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rymwvfullo.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957507.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rymwvobjcw</scm_object_name>
<product_module_obj>1004874710.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957508.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rystatusbv.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957509.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rysttdcsfv.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957510.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rysttfcsfv.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957511.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rytstmencw</scm_object_name>
<product_module_obj>1004874710.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957512.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>ryutlmencw</scm_object_name>
<product_module_obj>1004874710.09</product_module_obj>
<item_version_number>10000</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957513.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rywizmencw</scm_object_name>
<product_module_obj>1004874710.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
<contained_record DB="RVDB" Table="rvm_workspace_item"><workspace_item_obj>1004957514.09</workspace_item_obj>
<workspace_obj>1004957151.09</workspace_obj>
<configuration_type>RYCSO</configuration_type>
<scm_object_name>rywizpmodv.w</scm_object_name>
<product_module_obj>1004874707.09</product_module_obj>
<item_version_number>10001</item_version_number>
<task_product_module_obj>0</task_product_module_obj>
<task_version_number>0</task_version_number>
</contained_record>
</contained_record>
</dataset_transaction>
</dataset_records>
</dataset>