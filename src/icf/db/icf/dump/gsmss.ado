<?xml version="1.0" encoding="ISO8859-1" ?>
<dataset Transactions="14" version_date="02/23/2002" version_time="43071" version_user="admin" entity_mnemonic="GSTDF" key_field_value="3000000445.09" record_version_obj="3000000446.09" version_number_seq="2.09" import_version_number_seq="1.09"><dataset_header DisableRI="yes" DatasetObj="1007600160.08" DateFormat="mdy" FullHeader="yes" SCMManaged="no" YearOffset="1950" DatasetCode="GSMSS" DateCreated="02/23/2002" TimeCreated="11:57:50" NumericFormat="AMERICAN" NumericDecimal="." OriginatingSite="93" NumericSeparator=","><deploy_dataset_obj>1007600160.08</deploy_dataset_obj>
<owner_site_code></owner_site_code>
<dataset_code>GSMSS</dataset_code>
<dataset_description>gsm_security_structure - Security</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<dataset_entity><dataset_entity_obj>1007600161.08</dataset_entity_obj>
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
<entity_mnemonic_description>gsm_security_structure</entity_mnemonic_description>
<entity_dbname>icfdb</entity_dbname>
</dataset_entity>
<table_definition><name>gsm_security_structure</name>
<dbname>ICFDB</dbname>
<index-1>XAK1gsm_security_structure,1,0,0,owning_entity_mnemonic,0,owning_obj,0,product_module_obj,0,object_obj,0,instance_attribute_obj,0</index-1>
<index-2>XAK2gsm_security_structure,1,0,0,product_module_obj,0,object_obj,0,instance_attribute_obj,0,owning_entity_mnemonic,0,owning_obj,0</index-2>
<index-3>XPKgsm_security_structure,1,1,0,security_structure_obj,0</index-3>
<field><name>security_structure_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>>>>>>>>>>>>>>>>>>9.999999999</format>
<initial>                 0.000000000</initial>
<label>Security Structure Obj</label>
<column-label>Security Structure Obj</column-label>
</field>
<field><name>owning_entity_mnemonic</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(8)</format>
<initial></initial>
<label>Owning Entity Mnemonic</label>
<column-label>Owning Entity Mnemonic</column-label>
</field>
<field><name>owning_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>>>>>>>>>>>>>>>>>>9.999999999</format>
<initial>                 0.000000000</initial>
<label>Owning Obj</label>
<column-label>Owning Obj</column-label>
</field>
<field><name>product_module_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>>>>>>>>>>>>>>>>>>9.999999999</format>
<initial>                 0.000000000</initial>
<label>Product Module Obj</label>
<column-label>Product Module Obj</column-label>
</field>
<field><name>object_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>>>>>>>>>>>>>>>>>>9.999999999</format>
<initial>                 0.000000000</initial>
<label>Object Obj</label>
<column-label>Object Obj</column-label>
</field>
<field><name>instance_attribute_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>>>>>>>>>>>>>>>>>>9.999999999</format>
<initial>                 0.000000000</initial>
<label>Instance Attribute Obj</label>
<column-label>Instance Attribute Obj</column-label>
</field>
<field><name>disabled</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>Disabled</label>
<column-label>Disabled</column-label>
</field>
</table_definition>
</dataset_header>
<dataset_records><dataset_transaction TransactionNo="1"><contained_record DB="ICFDB" Table="gsm_security_structure"><security_structure_obj>5905</security_structure_obj>
<owning_entity_mnemonic>GSMTO</owning_entity_mnemonic>
<owning_obj>920</owning_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<disabled>no</disabled>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="2"><contained_record DB="ICFDB" Table="gsm_security_structure"><security_structure_obj>5906</security_structure_obj>
<owning_entity_mnemonic>GSMTO</owning_entity_mnemonic>
<owning_obj>921</owning_obj>
<product_module_obj>1004874683.09</product_module_obj>
<object_obj>1004841104.09</object_obj>
<instance_attribute_obj>1003576832</instance_attribute_obj>
<disabled>no</disabled>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="3"><contained_record DB="ICFDB" Table="gsm_security_structure"><security_structure_obj>5907</security_structure_obj>
<owning_entity_mnemonic>GSMTO</owning_entity_mnemonic>
<owning_obj>922</owning_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<disabled>no</disabled>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="4"><contained_record DB="ICFDB" Table="gsm_security_structure"><security_structure_obj>5910</security_structure_obj>
<owning_entity_mnemonic>GSMTO</owning_entity_mnemonic>
<owning_obj>924</owning_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<disabled>no</disabled>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="5"><contained_record DB="ICFDB" Table="gsm_security_structure"><security_structure_obj>5911</security_structure_obj>
<owning_entity_mnemonic>GSMTO</owning_entity_mnemonic>
<owning_obj>925</owning_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<disabled>no</disabled>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="6"><contained_record DB="ICFDB" Table="gsm_security_structure"><security_structure_obj>2121962</security_structure_obj>
<owning_entity_mnemonic>GSMTO</owning_entity_mnemonic>
<owning_obj>919</owning_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<disabled>no</disabled>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="7"><contained_record DB="ICFDB" Table="gsm_security_structure"><security_structure_obj>2122011</security_structure_obj>
<owning_entity_mnemonic>GSMTO</owning_entity_mnemonic>
<owning_obj>2122009</owning_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<disabled>no</disabled>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="8"><contained_record DB="ICFDB" Table="gsm_security_structure"><security_structure_obj>2122022</security_structure_obj>
<owning_entity_mnemonic>GSMTO</owning_entity_mnemonic>
<owning_obj>2122020</owning_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<disabled>no</disabled>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="9"><contained_record DB="ICFDB" Table="gsm_security_structure"><security_structure_obj>1004865945.09</security_structure_obj>
<owning_entity_mnemonic>GSMRA</owning_entity_mnemonic>
<owning_obj>?</owning_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<disabled>no</disabled>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="10"><contained_record DB="ICFDB" Table="gsm_security_structure"><security_structure_obj>1004865977.09</security_structure_obj>
<owning_entity_mnemonic>GSMTO</owning_entity_mnemonic>
<owning_obj>?</owning_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<disabled>no</disabled>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="11"><contained_record DB="ICFDB" Table="gsm_security_structure"><security_structure_obj>1004897990.09</security_structure_obj>
<owning_entity_mnemonic>GSMTO</owning_entity_mnemonic>
<owning_obj>1004897989.09</owning_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<disabled>no</disabled>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="12"><contained_record DB="ICFDB" Table="gsm_security_structure"><security_structure_obj>1005053597.09</security_structure_obj>
<owning_entity_mnemonic>GSMTO</owning_entity_mnemonic>
<owning_obj>919</owning_obj>
<product_module_obj>1004874679.09</product_module_obj>
<object_obj>1004826829.09</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<disabled>no</disabled>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="13"><contained_record DB="ICFDB" Table="gsm_security_structure"><security_structure_obj>1005053620.09</security_structure_obj>
<owning_entity_mnemonic>GSMTO</owning_entity_mnemonic>
<owning_obj>921</owning_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<disabled>no</disabled>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="14"><contained_record DB="ICFDB" Table="gsm_security_structure"><security_structure_obj>1005053718.09</security_structure_obj>
<owning_entity_mnemonic>GSMTO</owning_entity_mnemonic>
<owning_obj>919</owning_obj>
<product_module_obj>1004874679.09</product_module_obj>
<object_obj>1004830645.09</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<disabled>no</disabled>
</contained_record>
</dataset_transaction>
</dataset_records>
</dataset>