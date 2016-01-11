<?xml version="1.0" encoding="utf-8" ?>
<dataset Transactions="14"><dataset_header DisableRI="yes" DatasetObj="1007600160.08" DateFormat="mdy" FullHeader="yes" SCMManaged="no" YearOffset="1950" DatasetCode="GSMSS" NumericFormat="AMERICAN" NumericDecimal="." OriginatingSite="90" NumericSeparator=","><deploy_dataset_obj>1007600160.08</deploy_dataset_obj>
<dataset_code>GSMSS</dataset_code>
<dataset_description>gsm_security_structure - Security</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<deploy_additions_only>no</deploy_additions_only>
<enable_data_versioning>yes</enable_data_versioning>
<deletion_dataset>yes</deletion_dataset>
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
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
<entity_mnemonic_description>gsm_security_structure</entity_mnemonic_description>
<entity_dbname>ICFDB</entity_dbname>
</dataset_entity>
<table_definition><name>gsm_security_structure</name>
<dbname>icfdb</dbname>
<index-1>XAK1gsm_security_structure,1,0,0,owning_entity_mnemonic,0,owning_obj,0,product_module_obj,0,object_obj,0,instance_attribute_obj,0</index-1>
<index-2>XAK2gsm_security_structure,1,0,0,product_module_obj,0,object_obj,0,instance_attribute_obj,0,owning_entity_mnemonic,0,owning_obj,0</index-2>
<index-3>XPKgsm_security_structure,1,1,0,security_structure_obj,0</index-3>
<field><name>security_structure_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
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
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Owning Obj</label>
<column-label>Owning Obj</column-label>
</field>
<field><name>product_module_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Product Module Obj</label>
<column-label>Product Module Obj</column-label>
</field>
<field><name>object_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Object Obj</label>
<column-label>Object Obj</column-label>
</field>
<field><name>instance_attribute_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
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
<dataset_records><dataset_transaction TransactionNo="1" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_security_structure"><security_structure_obj>5905</security_structure_obj>
<owning_entity_mnemonic>GSMTO</owning_entity_mnemonic>
<owning_obj>920</owning_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<disabled>no</disabled>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="2" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_security_structure"><security_structure_obj>5906</security_structure_obj>
<owning_entity_mnemonic>GSMTO</owning_entity_mnemonic>
<owning_obj>921</owning_obj>
<product_module_obj>1004874683.09</product_module_obj>
<object_obj>1004841105.09</object_obj>
<instance_attribute_obj>1003576832</instance_attribute_obj>
<disabled>no</disabled>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="3" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_security_structure"><security_structure_obj>5907</security_structure_obj>
<owning_entity_mnemonic>GSMTO</owning_entity_mnemonic>
<owning_obj>922</owning_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<disabled>no</disabled>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="4" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_security_structure"><security_structure_obj>5910</security_structure_obj>
<owning_entity_mnemonic>GSMTO</owning_entity_mnemonic>
<owning_obj>924</owning_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<disabled>no</disabled>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="5" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_security_structure"><security_structure_obj>5911</security_structure_obj>
<owning_entity_mnemonic>GSMTO</owning_entity_mnemonic>
<owning_obj>925</owning_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<disabled>no</disabled>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="6" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_security_structure"><security_structure_obj>2121962</security_structure_obj>
<owning_entity_mnemonic>GSMTO</owning_entity_mnemonic>
<owning_obj>919</owning_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<disabled>no</disabled>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="7" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_security_structure"><security_structure_obj>2122011</security_structure_obj>
<owning_entity_mnemonic>GSMTO</owning_entity_mnemonic>
<owning_obj>2122009</owning_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<disabled>no</disabled>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="8" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_security_structure"><security_structure_obj>2122022</security_structure_obj>
<owning_entity_mnemonic>GSMTO</owning_entity_mnemonic>
<owning_obj>2122020</owning_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<disabled>no</disabled>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="9" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_security_structure"><security_structure_obj>1004865945.09</security_structure_obj>
<owning_entity_mnemonic>GSMRA</owning_entity_mnemonic>
<owning_obj>?</owning_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<disabled>no</disabled>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="10" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_security_structure"><security_structure_obj>1004865977.09</security_structure_obj>
<owning_entity_mnemonic>GSMTO</owning_entity_mnemonic>
<owning_obj>?</owning_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<disabled>no</disabled>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="11" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_security_structure"><security_structure_obj>1004897990.09</security_structure_obj>
<owning_entity_mnemonic>GSMTO</owning_entity_mnemonic>
<owning_obj>1004897989.09</owning_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<disabled>no</disabled>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="12" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_security_structure"><security_structure_obj>1005053597.09</security_structure_obj>
<owning_entity_mnemonic>GSMTO</owning_entity_mnemonic>
<owning_obj>919</owning_obj>
<product_module_obj>1004874679.09</product_module_obj>
<object_obj>1004826830.09</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<disabled>no</disabled>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="13" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_security_structure"><security_structure_obj>1005053620.09</security_structure_obj>
<owning_entity_mnemonic>GSMTO</owning_entity_mnemonic>
<owning_obj>921</owning_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<disabled>no</disabled>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="14" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_security_structure"><security_structure_obj>1005053718.09</security_structure_obj>
<owning_entity_mnemonic>GSMTO</owning_entity_mnemonic>
<owning_obj>919</owning_obj>
<product_module_obj>1004874679.09</product_module_obj>
<object_obj>1004830646.09</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<disabled>no</disabled>
</contained_record>
</dataset_transaction>
</dataset_records>
</dataset>