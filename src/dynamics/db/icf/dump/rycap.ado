<?xml version="1.0" encoding="utf-8" ?>
<dataset Transactions="32"><dataset_header DisableRI="yes" DatasetObj="3000000374.09" DateFormat="mdy" FullHeader="yes" SCMManaged="no" YearOffset="1950" DatasetCode="RYCAP" NumericFormat="AMERICAN" NumericDecimal="." OriginatingSite="90" NumericSeparator=","><deploy_dataset_obj>3000000374.09</deploy_dataset_obj>
<dataset_code>RYCAP</dataset_code>
<dataset_description>ryc_attribute_group - Attribute groups in isolation</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename>rycap.ado</default_ado_filename>
<deploy_additions_only>no</deploy_additions_only>
<enable_data_versioning>yes</enable_data_versioning>
<deletion_dataset>yes</deletion_dataset>
<dataset_entity><dataset_entity_obj>3000002001.09</dataset_entity_obj>
<deploy_dataset_obj>3000000374.09</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>RYCAP</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>attribute_group_name</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
<exclude_field_list></exclude_field_list>
<entity_mnemonic_description>ryc_attribute_group</entity_mnemonic_description>
<entity_dbname>ICFDB</entity_dbname>
</dataset_entity>
<table_definition><name>ryc_attribute_group</name>
<dbname>icfdb</dbname>
<index-1>XAK1ryc_attribute_group,1,0,0,attribute_group_name,0</index-1>
<index-2>XPKryc_attribute_group,1,1,0,attribute_group_obj,0</index-2>
<field><name>attribute_group_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Attribute group obj</label>
<column-label>Attribute group obj</column-label>
</field>
<field><name>attribute_group_name</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(28)</format>
<initial></initial>
<label>Attribute group name</label>
<column-label>Attribute group name</column-label>
</field>
<field><name>attribute_group_narrative</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(500)</format>
<initial></initial>
<label>Attribute group narrative</label>
<column-label>Attribute group narrative</column-label>
</field>
</table_definition>
</dataset_header>
<dataset_records><dataset_transaction TransactionNo="1" TransactionType="DELETION"><contained_record version_date="07/08/2002" version_time="67111" version_user="admin" deletion_flag="yes" entity_mnemonic="rycap" key_field_value="1.1713" record_version_obj="2.1713" version_number_seq="1.09" secondary_key_value="1.1713" import_version_number_seq="1.09"/>
</dataset_transaction>
<dataset_transaction TransactionNo="2" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute_group" version_date="10/03/2003" version_time="53247" version_user="admin" deletion_flag="no" entity_mnemonic="RYCAP" key_field_value="5.7063" record_version_obj="3000060257.09" version_number_seq="1.09" secondary_key_value="Smart" import_version_number_seq="1.09"><attribute_group_obj>5.7063</attribute_group_obj>
<attribute_group_name>Smart</attribute_group_name>
<attribute_group_narrative>Smart Object common attributes</attribute_group_narrative>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="3" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute_group" version_date="10/02/2003" version_time="49466" version_user="admin" deletion_flag="no" entity_mnemonic="RYCAP" key_field_value="7.7063" record_version_obj="3000058996.09" version_number_seq="1.09" secondary_key_value="Visual" import_version_number_seq="1.09"><attribute_group_obj>7.7063</attribute_group_obj>
<attribute_group_name>Visual</attribute_group_name>
<attribute_group_narrative>Visual Smartobject attributes</attribute_group_narrative>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="4" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute_group" version_date="10/02/2003" version_time="49466" version_user="admin" deletion_flag="no" entity_mnemonic="RYCAP" key_field_value="9.7063" record_version_obj="3000058997.09" version_number_seq="1.09" secondary_key_value="DataVisual" import_version_number_seq="1.09"><attribute_group_obj>9.7063</attribute_group_obj>
<attribute_group_name>DataVisual</attribute_group_name>
<attribute_group_narrative>Data visualization object attributes</attribute_group_narrative>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="5" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute_group" version_date="10/02/2003" version_time="49466" version_user="admin" deletion_flag="no" entity_mnemonic="RYCAP" key_field_value="11.7063" record_version_obj="3000058998.09" version_number_seq="1.09" secondary_key_value="Appserver" import_version_number_seq="1.09"><attribute_group_obj>11.7063</attribute_group_obj>
<attribute_group_name>Appserver</attribute_group_name>
<attribute_group_narrative>Appserver attributes</attribute_group_narrative>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="6" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute_group" version_date="10/02/2003" version_time="49466" version_user="admin" deletion_flag="no" entity_mnemonic="RYCAP" key_field_value="152.7063" record_version_obj="3000058999.09" version_number_seq="1.09" secondary_key_value="Data" import_version_number_seq="1.09"><attribute_group_obj>152.7063</attribute_group_obj>
<attribute_group_name>Data</attribute_group_name>
<attribute_group_narrative>SDO Attributes</attribute_group_narrative>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="7" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute_group" version_date="10/02/2003" version_time="49466" version_user="admin" deletion_flag="no" entity_mnemonic="RYCAP" key_field_value="154.7063" record_version_obj="3000059000.09" version_number_seq="1.09" secondary_key_value="Query" import_version_number_seq="1.09"><attribute_group_obj>154.7063</attribute_group_obj>
<attribute_group_name>Query</attribute_group_name>
<attribute_group_narrative>Query object attributes</attribute_group_narrative>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="8" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute_group" version_date="10/02/2003" version_time="49466" version_user="admin" deletion_flag="no" entity_mnemonic="RYCAP" key_field_value="347.7063" record_version_obj="3000059001.09" version_number_seq="1.09" secondary_key_value="Container" import_version_number_seq="1.09"><attribute_group_obj>347.7063</attribute_group_obj>
<attribute_group_name>Container</attribute_group_name>
<attribute_group_narrative>Container Attributes</attribute_group_narrative>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="9" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute_group" version_date="10/02/2003" version_time="49466" version_user="admin" deletion_flag="no" entity_mnemonic="RYCAP" key_field_value="428.7063" record_version_obj="3000059002.09" version_number_seq="1.09" secondary_key_value="DataContainer" import_version_number_seq="1.09"><attribute_group_obj>428.7063</attribute_group_obj>
<attribute_group_name>DataContainer</attribute_group_name>
<attribute_group_narrative>SmartBusinessObject and other Data Container attributes</attribute_group_narrative>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="10" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute_group" version_date="10/02/2003" version_time="49466" version_user="admin" deletion_flag="no" entity_mnemonic="RYCAP" key_field_value="430.7063" record_version_obj="3000059003.09" version_number_seq="1.09" secondary_key_value="Toolbar" import_version_number_seq="1.09"><attribute_group_obj>430.7063</attribute_group_obj>
<attribute_group_name>Toolbar</attribute_group_name>
<attribute_group_narrative>SmartToolbar attributes</attribute_group_narrative>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="11" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute_group" version_date="10/02/2003" version_time="49466" version_user="admin" deletion_flag="no" entity_mnemonic="RYCAP" key_field_value="432.7063" record_version_obj="3000059004.09" version_number_seq="1.09" secondary_key_value="Field" import_version_number_seq="1.09"><attribute_group_obj>432.7063</attribute_group_obj>
<attribute_group_name>Field</attribute_group_name>
<attribute_group_narrative>SmartField Attributes</attribute_group_narrative>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="12" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute_group" version_date="10/02/2003" version_time="49466" version_user="admin" deletion_flag="no" entity_mnemonic="RYCAP" key_field_value="434.7063" record_version_obj="3000059005.09" version_number_seq="1.09" secondary_key_value="Select" import_version_number_seq="1.09"><attribute_group_obj>434.7063</attribute_group_obj>
<attribute_group_name>Select</attribute_group_name>
<attribute_group_narrative>SmartSelect attributes</attribute_group_narrative>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="13" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute_group" version_date="10/02/2003" version_time="49466" version_user="admin" deletion_flag="no" entity_mnemonic="RYCAP" key_field_value="436.7063" record_version_obj="3000059006.09" version_number_seq="1.09" secondary_key_value="Browser" import_version_number_seq="1.09"><attribute_group_obj>436.7063</attribute_group_obj>
<attribute_group_name>Browser</attribute_group_name>
<attribute_group_narrative>SmartBrowser attributes</attribute_group_narrative>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="14" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute_group" version_date="10/02/2003" version_time="49466" version_user="admin" deletion_flag="no" entity_mnemonic="RYCAP" key_field_value="438.7063" record_version_obj="3000059007.09" version_number_seq="1.09" secondary_key_value="Panel" import_version_number_seq="1.09"><attribute_group_obj>438.7063</attribute_group_obj>
<attribute_group_name>Panel</attribute_group_name>
<attribute_group_narrative>SmartPanel attributes</attribute_group_narrative>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="15" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute_group" version_date="09/04/2002" version_time="57079" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="505.49" record_version_obj="506.49" version_number_seq="3.49" secondary_key_value="Consumer" import_version_number_seq="3.49"><attribute_group_obj>505.49</attribute_group_obj>
<attribute_group_name>Consumer</attribute_group_name>
<attribute_group_narrative>SmartConsumer attributes</attribute_group_narrative>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="16" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute_group" version_date="03/17/2003" version_time="41317" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="505.7692" record_version_obj="506.7692" version_number_seq="1.09" secondary_key_value="Template" import_version_number_seq="1.09"><attribute_group_obj>505.7692</attribute_group_obj>
<attribute_group_name>Template</attribute_group_name>
<attribute_group_narrative>Template group applies to all objects that may be created as a template and used for new objects in the IDE</attribute_group_narrative>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="17" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute_group" version_date="09/04/2002" version_time="57071" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="507.49" record_version_obj="508.49" version_number_seq="3.49" secondary_key_value="Producer" import_version_number_seq="3.49"><attribute_group_obj>507.49</attribute_group_obj>
<attribute_group_name>Producer</attribute_group_name>
<attribute_group_narrative>SmartProducer attributes</attribute_group_narrative>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="18" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute_group" version_date="09/04/2002" version_time="57055" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="509.49" record_version_obj="510.49" version_number_seq="2.49" secondary_key_value="MsgHandler" import_version_number_seq="2.49"><attribute_group_obj>509.49</attribute_group_obj>
<attribute_group_name>MsgHandler</attribute_group_name>
<attribute_group_narrative>Message Handler attributes</attribute_group_narrative>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="19" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute_group" version_date="09/04/2002" version_time="57077" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="511.49" record_version_obj="512.49" version_number_seq="2.49" secondary_key_value="XML" import_version_number_seq="2.49"><attribute_group_obj>511.49</attribute_group_obj>
<attribute_group_name>XML</attribute_group_name>
<attribute_group_narrative>SmartXML attributes</attribute_group_narrative>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="20" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute_group" version_date="09/04/2002" version_time="57056" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="513.49" record_version_obj="514.49" version_number_seq="2.49" secondary_key_value="Router" import_version_number_seq="2.49"><attribute_group_obj>513.49</attribute_group_obj>
<attribute_group_name>Router</attribute_group_name>
<attribute_group_narrative>SmartRouter attributes</attribute_group_narrative>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="21" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute_group" version_date="09/04/2002" version_time="57075" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="515.49" record_version_obj="516.49" version_number_seq="2.49" secondary_key_value="B2B" import_version_number_seq="2.49"><attribute_group_obj>515.49</attribute_group_obj>
<attribute_group_name>B2B</attribute_group_name>
<attribute_group_narrative>SmartB2B attributes</attribute_group_narrative>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="22" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute_group" version_date="10/02/2003" version_time="49466" version_user="admin" deletion_flag="no" entity_mnemonic="RYCAP" key_field_value="608.7063" record_version_obj="3000059008.09" version_number_seq="1.09" secondary_key_value="Filter" import_version_number_seq="1.09"><attribute_group_obj>608.7063</attribute_group_obj>
<attribute_group_name>Filter</attribute_group_name>
<attribute_group_narrative>SmartFilter attributes</attribute_group_narrative>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="23" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute_group" version_date="03/06/2003" version_time="65764" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="700.7692" record_version_obj="701.7692" version_number_seq="1.09" secondary_key_value="Palette" import_version_number_seq="1.09"><attribute_group_obj>700.7692</attribute_group_obj>
<attribute_group_name>Palette</attribute_group_name>
<attribute_group_narrative>Palette group for design only attributes</attribute_group_narrative>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="24" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute_group" version_date="10/02/2003" version_time="49466" version_user="admin" deletion_flag="no" entity_mnemonic="RYCAP" key_field_value="731.7063" record_version_obj="3000059009.09" version_number_seq="1.09" secondary_key_value="Messaging" import_version_number_seq="1.09"><attribute_group_obj>731.7063</attribute_group_obj>
<attribute_group_name>Messaging</attribute_group_name>
<attribute_group_narrative>Messaging SmartObject attributes</attribute_group_narrative>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="25" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute_group" version_date="03/12/2003" version_time="66443" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="36427.48" record_version_obj="36428.48" version_number_seq="1.09" secondary_key_value="EntityAttributes" import_version_number_seq="1.09"><attribute_group_obj>36427.48</attribute_group_obj>
<attribute_group_name>EntityAttributes</attribute_group_name>
<attribute_group_narrative>This group contains attributes that are associated with entities. The attributes in this group correspond exactly to the field names in the GSC_ENTITY_MNEMONIC table, excpet that they have had the underscores removed. This convention is used so that it is possible to generically and quickly populate the attributes.</attribute_group_narrative>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="26" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute_group" version_date="10/02/2003" version_time="49466" version_user="admin" deletion_flag="no" entity_mnemonic="RYCAP" key_field_value="1003183341" record_version_obj="3000059010.09" version_number_seq="1.09" secondary_key_value="Defaults" import_version_number_seq="1.09"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="27" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute_group" version_date="10/02/2003" version_time="49466" version_user="admin" deletion_flag="no" entity_mnemonic="RYCAP" key_field_value="1005078412.09" record_version_obj="3000059011.09" version_number_seq="1.09" secondary_key_value="WidgetAttributes" import_version_number_seq="1.09"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="28" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute_group" version_date="10/06/2003" version_time="62606" version_user="admin" deletion_flag="no" entity_mnemonic="RYCAP" key_field_value="1005095446.101" record_version_obj="3000059012.09" version_number_seq="1.09" secondary_key_value="ViewerAttributes" import_version_number_seq="1.09"><attribute_group_obj>1005095446.101</attribute_group_obj>
<attribute_group_name>ViewerAttributes</attribute_group_name>
<attribute_group_narrative>These are attributes which belong to a Dynamic Viewer</attribute_group_narrative>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="29" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute_group" version_date="10/02/2003" version_time="49466" version_user="admin" deletion_flag="no" entity_mnemonic="RYCAP" key_field_value="1005095447.101" record_version_obj="3000059013.09" version_number_seq="1.09" secondary_key_value="SdfAttributes" import_version_number_seq="1.09"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_group_name>SdfAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Smart Data Fields</attribute_group_narrative>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="30" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute_group" version_date="10/02/2003" version_time="49466" version_user="admin" deletion_flag="no" entity_mnemonic="RYCAP" key_field_value="1005097792.101" record_version_obj="3000059014.09" version_number_seq="1.09" secondary_key_value="TreeView" import_version_number_seq="1.09"><attribute_group_obj>1005097792.101</attribute_group_obj>
<attribute_group_name>TreeView</attribute_group_name>
<attribute_group_narrative>TreeView Group</attribute_group_narrative>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="31" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute_group" version_date="10/02/2003" version_time="49466" version_user="admin" deletion_flag="no" entity_mnemonic="RYCAP" key_field_value="1005098168.101" record_version_obj="3000059015.09" version_number_seq="1.09" secondary_key_value="EditorAttributes" import_version_number_seq="1.09"><attribute_group_obj>1005098168.101</attribute_group_obj>
<attribute_group_name>EditorAttributes</attribute_group_name>
<attribute_group_narrative>Attributes which are specific to an editor widget</attribute_group_narrative>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="32" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute_group" version_date="10/06/2003" version_time="37776" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="3000002003.09" record_version_obj="3000002004.09" version_number_seq="1.09" secondary_key_value="ADMAttributes" import_version_number_seq="1.09"><attribute_group_obj>3000002003.09</attribute_group_obj>
<attribute_group_name>ADMAttributes</attribute_group_name>
<attribute_group_narrative>This group contains all attributes of ADM objects excepts those that can also be Widget Attributes. In that case, they are in the WidgetAttribute group.</attribute_group_narrative>
</contained_record>
</dataset_transaction>
</dataset_records>
</dataset>