<?xml version="1.0" encoding="utf-8" ?>
<dataset Transactions="787"><dataset_header DisableRI="yes" DatasetObj="1007600083.08" DateFormat="mdy" FullHeader="yes" SCMManaged="no" YearOffset="1950" DatasetCode="RYCAT" NumericFormat="AMERICAN" NumericDecimal="." OriginatingSite="90" NumericSeparator=","><deploy_dataset_obj>1007600083.08</deploy_dataset_obj>
<dataset_code>RYCAT</dataset_code>
<dataset_description>ryc_attribute - Attribute Dataset</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<deploy_additions_only>no</deploy_additions_only>
<enable_data_versioning>yes</enable_data_versioning>
<deletion_dataset>yes</deletion_dataset>
<dataset_entity><dataset_entity_obj>1007600084.08</dataset_entity_obj>
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
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
<entity_mnemonic_description>ryc_attribute</entity_mnemonic_description>
<entity_dbname>ICFDB</entity_dbname>
</dataset_entity>
<dataset_entity><dataset_entity_obj>1007600085.08</dataset_entity_obj>
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
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
<entity_mnemonic_description>ryc_attribute_group</entity_mnemonic_description>
<entity_dbname>ICFDB</entity_dbname>
</dataset_entity>
<table_definition><name>ryc_attribute</name>
<dbname>icfdb</dbname>
<index-1>XAK1ryc_attribute,1,0,0,attribute_group_obj,0,attribute_label,0</index-1>
<index-2>XIE2ryc_attribute,0,0,0,attribute_obj,0</index-2>
<index-3>XPKryc_attribute,1,1,0,attribute_label,0</index-3>
<field><name>attribute_label</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>Attribute Label</label>
<column-label>Attribute Label</column-label>
</field>
<field><name>attribute_group_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Attribute Group Obj</label>
<column-label>Attribute Group Obj</column-label>
</field>
<field><name>data_type</name>
<data-type>integer</data-type>
<extent>0</extent>
<format>-&gt;&gt;9</format>
<initial>   0</initial>
<label>Data Type</label>
<column-label>Data Type</column-label>
</field>
<field><name>attribute_narrative</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(500)</format>
<initial></initial>
<label>Attribute Narrative</label>
<column-label>Attribute Narrative</column-label>
</field>
<field><name>override_type</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(3000)</format>
<initial></initial>
<label>Override Type</label>
<column-label>Override Type</column-label>
</field>
<field><name>runtime_only</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>Runtime Only</label>
<column-label>Runtime Only</column-label>
</field>
<field><name>is_private</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>is Private</label>
<column-label>is Private</column-label>
</field>
<field><name>constant_level</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(10)</format>
<initial></initial>
<label>Constant Level</label>
<column-label>Constant Level</column-label>
</field>
<field><name>derived_value</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>Derived Value</label>
<column-label>Derived Value</column-label>
</field>
<field><name>lookup_type</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(10)</format>
<initial></initial>
<label>Lookup Type</label>
<column-label>Lookup Type</column-label>
</field>
<field><name>lookup_value</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(500)</format>
<initial></initial>
<label>Lookup Value</label>
<column-label>Lookup Value</column-label>
</field>
<field><name>design_only</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>Design Only</label>
<column-label>Design Only</column-label>
</field>
<field><name>system_owned</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>System Owned</label>
<column-label>System Owned</column-label>
</field>
<field><name>attribute_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Attribute Obj</label>
<column-label>Attribute Obj</column-label>
</field>
</table_definition>
<table_definition><name>ryc_attribute_group</name>
<dbname>icfdb</dbname>
<index-1>XAK1ryc_attribute_group,1,0,0,attribute_group_name,0</index-1>
<index-2>XPKryc_attribute_group,1,1,0,attribute_group_obj,0</index-2>
<field><name>attribute_group_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Attribute Group Obj</label>
<column-label>Attribute Group Obj</column-label>
</field>
<field><name>attribute_group_name</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(28)</format>
<initial></initial>
<label>Attribute Group Name</label>
<column-label>Attribute Group Name</column-label>
</field>
<field><name>attribute_group_narrative</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(500)</format>
<initial></initial>
<label>Attribute Group Narrative</label>
<column-label>Attribute Group Narrative</column-label>
</field>
</table_definition>
</dataset_header>
<dataset_records><dataset_transaction TransactionNo="1" TransactionType="DELETION"><contained_record version_date="03/21/2003" version_time="36475" version_user="admin" deletion_flag="yes" entity_mnemonic="rycat" key_field_value="1303.6893" record_version_obj="1304.6893" version_number_seq="1.09" secondary_key_value="TokenSecurity" import_version_number_seq="1.09"/>
</dataset_transaction>
<dataset_transaction TransactionNo="2" TransactionType="DELETION"><contained_record version_date="11/22/2002" version_time="64404" version_user="admin" deletion_flag="yes" entity_mnemonic="rycat" key_field_value="17921.66" record_version_obj="17922.66" version_number_seq="1.09" secondary_key_value="Calculation" import_version_number_seq="1.09"/>
</dataset_transaction>
<dataset_transaction TransactionNo="3" TransactionType="DELETION"><contained_record version_date="11/22/2002" version_time="64409" version_user="admin" deletion_flag="yes" entity_mnemonic="rycat" key_field_value="17923.66" record_version_obj="17924.66" version_number_seq="1.09" secondary_key_value="CalculationList" import_version_number_seq="1.09"/>
</dataset_transaction>
<dataset_transaction TransactionNo="4" TransactionType="DELETION"><contained_record version_date="03/13/2003" version_time="64670" version_user="admin" deletion_flag="yes" entity_mnemonic="rycat" key_field_value="829.7063" record_version_obj="3000040782.09" version_number_seq="1.09" secondary_key_value="CurrentKeyValue" import_version_number_seq="1.09"/>
</dataset_transaction>
<dataset_transaction TransactionNo="5" TransactionType="DELETION"><contained_record version_date="03/13/2003" version_time="64670" version_user="admin" deletion_flag="yes" entity_mnemonic="rycat" key_field_value="835.7063" record_version_obj="3000040781.09" version_number_seq="1.09" secondary_key_value="CurrentDescValue" import_version_number_seq="1.09"/>
</dataset_transaction>
<dataset_transaction TransactionNo="6" TransactionType="DELETION"><contained_record version_date="07/08/2002" version_time="67058" version_user="admin" deletion_flag="yes" entity_mnemonic="rycat" key_field_value="DhtmlClass" record_version_obj="16.1713" version_number_seq="1.09" secondary_key_value="" import_version_number_seq="1.09"/>
</dataset_transaction>
<dataset_transaction TransactionNo="7" TransactionType="DELETION"><contained_record version_date="07/08/2002" version_time="67064" version_user="admin" deletion_flag="yes" entity_mnemonic="rycat" key_field_value="DhtmlCssFile" record_version_obj="4.1713" version_number_seq="1.09" secondary_key_value="" import_version_number_seq="1.09"/>
</dataset_transaction>
<dataset_transaction TransactionNo="8" TransactionType="DELETION"><contained_record version_date="07/08/2002" version_time="67070" version_user="admin" deletion_flag="yes" entity_mnemonic="rycat" key_field_value="DhtmlFilterType" record_version_obj="8.1713" version_number_seq="1.09" secondary_key_value="" import_version_number_seq="1.09"/>
</dataset_transaction>
<dataset_transaction TransactionNo="9" TransactionType="DELETION"><contained_record version_date="07/08/2002" version_time="67076" version_user="admin" deletion_flag="yes" entity_mnemonic="rycat" key_field_value="DhtmlFolderType" record_version_obj="12.1713" version_number_seq="1.09" secondary_key_value="" import_version_number_seq="1.09"/>
</dataset_transaction>
<dataset_transaction TransactionNo="10" TransactionType="DELETION"><contained_record version_date="07/08/2002" version_time="67082" version_user="admin" deletion_flag="yes" entity_mnemonic="rycat" key_field_value="DhtmlJsFile" record_version_obj="6.1713" version_number_seq="1.09" secondary_key_value="" import_version_number_seq="1.09"/>
</dataset_transaction>
<dataset_transaction TransactionNo="11" TransactionType="DELETION"><contained_record version_date="07/08/2002" version_time="67088" version_user="admin" deletion_flag="yes" entity_mnemonic="rycat" key_field_value="DhtmlMenuObject" record_version_obj="10.1713" version_number_seq="1.09" secondary_key_value="" import_version_number_seq="1.09"/>
</dataset_transaction>
<dataset_transaction TransactionNo="12" TransactionType="DELETION"><contained_record version_date="07/08/2002" version_time="67095" version_user="admin" deletion_flag="yes" entity_mnemonic="rycat" key_field_value="DhtmlNavType" record_version_obj="14.1713" version_number_seq="1.09" secondary_key_value="" import_version_number_seq="1.09"/>
</dataset_transaction>
<dataset_transaction TransactionNo="13" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ActionEvent</attribute_label>
<attribute_group_obj>436.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The event to publish on Default-action of the browse. The caller should also subscribe to the event.</attribute_narrative>
<override_type>SET</override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>486.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>436.7063</attribute_group_obj>
<attribute_group_name>Browser</attribute_group_name>
<attribute_group_narrative>SmartBrowser attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="14" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ActionGroups</attribute_label>
<attribute_group_obj>430.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Comma separated list of actionGroups.
Repository toolbar uses categories while non-repository objects
uses parent actions</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>1003498429</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>430.7063</attribute_group_obj>
<attribute_group_name>Toolbar</attribute_group_name>
<attribute_group_narrative>SmartToolbar attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="15" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>AddFunction</attribute_label>
<attribute_group_obj>438.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative></attribute_narrative>
<override_type>SET</override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>684.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>438.7063</attribute_group_obj>
<attribute_group_name>Panel</attribute_group_name>
<attribute_group_narrative>SmartPanel attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="16" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>AllFieldHandles</attribute_label>
<attribute_group_obj>7.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Containes the handles of all objects and widgets on the visual objects. The list corresponds to AllFieldNames. The list has the procedure-handle of containerTargets and widget-handle of widgets.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>88.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>7.7063</attribute_group_obj>
<attribute_group_name>Visual</attribute_group_name>
<attribute_group_narrative>Visual Smartobject attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="17" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>AllFieldNames</attribute_label>
<attribute_group_obj>7.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Contains a comma-separated list of names of all objects and widgets on the visual objects. The corresponding handles are stored in AllFieldHandles. The list stores the FieldName of SmartDataFields and the NAME attribute of widgets.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>90.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>7.7063</attribute_group_obj>
<attribute_group_name>Visual</attribute_group_name>
<attribute_group_narrative>Visual Smartobject attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="18" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ALLOW-COLUMN-SEARCHING</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Browser columns are searchable if true</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>14629.409</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="19" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ApplyActionOnExit</attribute_label>
<attribute_group_obj>436.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>TRUE if exit is to perform the same action as the DEFAULT-ACTION. Currently used by the SmartSelect.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>488.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>436.7063</attribute_group_obj>
<attribute_group_name>Browser</attribute_group_name>
<attribute_group_narrative>SmartBrowser attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="20" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ApplyExitOnAction</attribute_label>
<attribute_group_obj>436.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>TRUE if DEFAULT-ACTION is to exit the browse. Currently used by the SmartSelect.
The logic is not performed in the trigger, but in the defaultAction
procedure that gets defined as a persitent DEFAULT-ACTION event when setActionEvent is defined. 
Local DEFAULT-ACTION events could be set up to run defaultAction.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>490.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>436.7063</attribute_group_obj>
<attribute_group_name>Browser</attribute_group_name>
<attribute_group_narrative>SmartBrowser attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="21" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>AppService</attribute_label>
<attribute_group_obj>1003183341</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Stores the AppService name to use when connecting to the AppServer. The get is mandatory to resolve &apos;(none)&apos; value as blank. This may have been stored from the Instance Property Dialog in older versions.</attribute_narrative>
<override_type>GET</override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>1003183455</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="22" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ASDivision</attribute_label>
<attribute_group_obj>11.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Property indicating which side of the AppServer this Object is running on; &apos;Client&apos;, &apos;Server&apos;, or none.
This is the main condition used in code to separate/trigger client or server specific logic.  It&apos;s immediately set to &apos;server&apos; at start up if session:remote. On the client, we traditionally connected in initializeObject and immediately set this property there, but as we now postpone the connection, this value may be unknown. Get is enforced to ensure that unknown never is exposed.</attribute_narrative>
<override_type>GET</override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>130.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>11.7063</attribute_group_obj>
<attribute_group_name>Appserver</attribute_group_name>
<attribute_group_narrative>Appserver attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="23" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ASHandle</attribute_label>
<attribute_group_obj>11.7063</attribute_group_obj>
<data_type>10</data_type>
<attribute_narrative>The handle to this object&apos;s companion procedure (the copy of itself) running on the AppServer. This binds the server and should be avoided alltogether to utilize the one-hit appserver data requests.  If it is used then use unbindServer to unbind the server again.</attribute_narrative>
<override_type>get</override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>135.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>11.7063</attribute_group_obj>
<attribute_group_name>Appserver</attribute_group_name>
<attribute_group_narrative>Appserver attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="24" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ASHasStarted</attribute_label>
<attribute_group_obj>11.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Indicates whether the object has done its first call to its server side object.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>137.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>11.7063</attribute_group_obj>
<attribute_group_name>Appserver</attribute_group_name>
<attribute_group_narrative>Appserver attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="25" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ASInfo</attribute_label>
<attribute_group_obj>11.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The value of the AppServer Information string which is passed to the AppServer connection as a parameter.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>1003183460</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>11.7063</attribute_group_obj>
<attribute_group_name>Appserver</attribute_group_name>
<attribute_group_narrative>Appserver attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="26" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ASInitializeOnRun</attribute_label>
<attribute_group_obj>11.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Indicates whether &apos;runServerObject&apos;  should call &apos;initializeServerObject&apos;. &apos;InitializeServerObject is called on the client, but will call the server to set and/or retrieve context if this property is true. Use with caution.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>139.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>11.7063</attribute_group_obj>
<attribute_group_name>Appserver</attribute_group_name>
<attribute_group_narrative>Appserver attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="27" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>AssignList</attribute_label>
<attribute_group_obj>154.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>List of updatable columns whose names have been modified in the SmartDataObject.
Value format:
&lt;RowObjectFieldName&gt;,&lt;DBFieldName&gt;[,...][CHR(1)...]
with a comma separated list of pairs of fields for each db table,
and CHR(1) between the lists of pairs.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>529.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>154.7063</attribute_group_obj>
<attribute_group_name>Query</attribute_group_name>
<attribute_group_narrative>Query object attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="28" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ASUsePrompt</attribute_label>
<attribute_group_obj>11.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Flag which indicates whether the support code should prompt for a Username and Password when connecting to an AppServer session.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>1003183458</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>11.7063</attribute_group_obj>
<attribute_group_name>Appserver</attribute_group_name>
<attribute_group_narrative>Appserver attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="29" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>AsynchronousSDO</attribute_label>
<attribute_group_obj>152.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Not in use</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>1004959733.09</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>152.7063</attribute_group_obj>
<attribute_group_name>Data</attribute_group_name>
<attribute_group_narrative>SDO Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="30" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ATTR-SPACE</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005099316.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="31" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="03/07/2003" version_time="63469" version_user="admin" deletion_flag="no" entity_mnemonic="RYCAT" key_field_value="36431.48" record_version_obj="36432.48" version_number_seq="1.09" secondary_key_value="AuditingEnabled" import_version_number_seq="1.09"><attribute_label>AuditingEnabled</attribute_label>
<attribute_group_obj>36427.48</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>If set to YES, auditing will be enabled for this table and will be done via the generic triggers generated from</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>36431.48</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="03/12/2003" version_time="66443" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="36427.48" record_version_obj="36428.48" version_number_seq="1.09" secondary_key_value="EntityAttributes" import_version_number_seq="1.09"><attribute_group_obj>36427.48</attribute_group_obj>
<attribute_group_name>EntityAttributes</attribute_group_name>
<attribute_group_narrative>This group contains attributes that are associated with entities. The attributes in this group correspond exactly to the field names in the GSC_ENTITY_MNEMONIC table, excpet that they have had the underscores removed. This convention is used so that it is possible to generically and quickly populate the attributes.</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="32" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>AUTO-COMPLETION</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005099332.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="33" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>AUTO-END-KEY</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005099320.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="34" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>AUTO-GO</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005099319.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="35" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>AUTO-INDENT</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005099275.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="36" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>AUTO-RESIZE</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005099296.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="37" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>AUTO-RETURN</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005099315.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="38" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>AUTO-VALIDATE</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Browser input is automatically validated</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>14631.409</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="39" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>AUTO-ZAP</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005099313.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="40" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>AutoCommit</attribute_label>
<attribute_group_obj>152.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Sets the AutoCommit flag on or off; when On, every call to &apos;submitRow&apos; will result in a Commit.
When applied to a DataContainer (SBO), it is always set to
FALSE for the contained SDOs because they never initiate their own Commit when contained in an SBO.</attribute_narrative>
<override_type>set</override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>168.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>152.7063</attribute_group_obj>
<attribute_group_name>Data</attribute_group_name>
<attribute_group_narrative>SDO Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="41" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="03/07/2003" version_time="63470" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="36429.48" record_version_obj="36430.48" version_number_seq="1.09" secondary_key_value="AutoProperformStrings" import_version_number_seq="1.09"><attribute_label>AutoProperformStrings</attribute_label>
<attribute_group_obj>36427.48</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Should all character fields be properformed, i.e. automatically tidy up the case of the value into correct upper and lower case.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>36429.48</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="03/12/2003" version_time="66443" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="36427.48" record_version_obj="36428.48" version_number_seq="1.09" secondary_key_value="EntityAttributes" import_version_number_seq="1.09"><attribute_group_obj>36427.48</attribute_group_obj>
<attribute_group_name>EntityAttributes</attribute_group_name>
<attribute_group_narrative>This group contains attributes that are associated with entities. The attributes in this group correspond exactly to the field names in the GSC_ENTITY_MNEMONIC table, excpet that they have had the underscores removed. This convention is used so that it is possible to generically and quickly populate the attributes.</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="42" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>AutoRefresh</attribute_label>
<attribute_group_obj>434.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>For future use.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>562.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>434.7063</attribute_group_obj>
<attribute_group_name>Select</attribute_group_name>
<attribute_group_narrative>SmartSelect attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="43" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>AutoSort</attribute_label>
<attribute_group_obj>1005097792.101</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Used to set the property of a SmartTreeView object to Automatically sort the nodes.</attribute_narrative>
<override_type>SET</override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>1005081438.28</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005097792.101</attribute_group_obj>
<attribute_group_name>TreeView</attribute_group_name>
<attribute_group_narrative>TreeView Group</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="44" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>AvailMenuActions</attribute_label>
<attribute_group_obj>430.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The actions that are available in the menu of the toolbar object.
Updated internally from insertMenu. The Instance Property dialog shows these and AvailToolbarActions. 
The actions that are selected will be saved as ActionGroups.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>705.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>430.7063</attribute_group_obj>
<attribute_group_name>Toolbar</attribute_group_name>
<attribute_group_narrative>SmartToolbar attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="45" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>AvailToolbarActions</attribute_label>
<attribute_group_obj>430.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The actions that are available in the toolbar.
Updated internally from createToolbar. The Instance Property dialog shows these and AvailToolbarActions. 
The actions that are selected will be saved as ActionGroups.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>707.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>430.7063</attribute_group_obj>
<attribute_group_name>Toolbar</attribute_group_name>
<attribute_group_narrative>SmartToolbar attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="46" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>BaseQuery</attribute_label>
<attribute_group_obj>154.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>This is used internally by OpenQuery, and directly on client context management. Because setOpenQuery also calls setQueryWhere and wipes out all other query data it cannot be used when setting this when received from server .</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>505.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>154.7063</attribute_group_obj>
<attribute_group_name>Query</attribute_group_name>
<attribute_group_narrative>Query object attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="47" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>BaseQueryString</attribute_label>
<attribute_group_obj>1005095447.101</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Dynamic Lookup/Combo Base Browse query string (design time)</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>1005089874.28</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_group_name>SdfAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Smart Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="48" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>BGCOLOR</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>4</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005099282.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="49" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>BindScope</attribute_label>
<attribute_group_obj>11.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Define the scope of an stateless appserver connection. (See &apos;setBindScope&apos; function for details on use)</attribute_narrative>
<override_type>set</override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>143.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>11.7063</attribute_group_obj>
<attribute_group_name>Appserver</attribute_group_name>
<attribute_group_narrative>Appserver attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="50" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>BindSignature</attribute_label>
<attribute_group_obj>11.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Used internally to resolve whether to unbind in unbindServer.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>yes</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>141.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>11.7063</attribute_group_obj>
<attribute_group_name>Appserver</attribute_group_name>
<attribute_group_narrative>Appserver attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="51" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>BLANK</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005099318.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="52" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="12/05/2002" version_time="35433" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="18282.66" record_version_obj="18283.66" version_number_seq="1.09" secondary_key_value="BlankOnNotAvail" import_version_number_seq="1.09"><attribute_label>BlankOnNotAvail</attribute_label>
<attribute_group_obj>432.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Indicates that the field should be blanked when the typed value has no match rather than leaving the value in the field - providing the field value was modified. The rule is normally applied on the leave event, but some UIs may require a more explicit user action.  
</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>18282.66</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>432.7063</attribute_group_obj>
<attribute_group_name>Field</attribute_group_name>
<attribute_group_narrative>SmartField Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="53" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>BlockDataAvailable</attribute_label>
<attribute_group_obj>428.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>TRUE if DataAvailable messages from contained SDOs are to be ignored and not republished  (usually during updates).</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>yes</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>458.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>428.7063</attribute_group_obj>
<attribute_group_name>DataContainer</attribute_group_name>
<attribute_group_narrative>SmartBusinessObject and other Data Container attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="54" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>BlockQueryPosition</attribute_label>
<attribute_group_obj>428.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>TRUE to block outgoing (from contained SDOs) queryPosition requests.</attribute_narrative>
<override_type>get</override_type>
<runtime_only>yes</runtime_only>
<is_private>yes</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>464.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>428.7063</attribute_group_obj>
<attribute_group_name>DataContainer</attribute_group_name>
<attribute_group_narrative>SmartBusinessObject and other Data Container attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="55" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="02/18/2003" version_time="61275" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="1005099272.101" record_version_obj="32820.48" version_number_seq="1.09" secondary_key_value="BOX" import_version_number_seq="1.09"><attribute_label>BOX</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative></attribute_narrative>
<override_type>SET</override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005099272.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="56" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>BOX-SELECTABLE</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Frame attribute to allow objects to be selected by drawing a box around them</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>14813.409</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="57" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>BoxRectangle</attribute_label>
<attribute_group_obj>438.7063</attribute_group_obj>
<data_type>10</data_type>
<attribute_narrative>The handle to the rectangle, if any, which draws a  &quot;box&quot; around the buttons in the Panel -- used by resizeObject.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>666.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>438.7063</attribute_group_obj>
<attribute_group_name>Panel</attribute_group_name>
<attribute_group_narrative>SmartPanel attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="58" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>BoxRectangle2</attribute_label>
<attribute_group_obj>438.7063</attribute_group_obj>
<data_type>10</data_type>
<attribute_narrative>The handle to the rectangle, if any, which draws a  &quot;box&quot; around the buttons in the Panel -- used for the lower rectangle by a toolbar that has SizeToFit set to true.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>668.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>438.7063</attribute_group_obj>
<attribute_group_name>Panel</attribute_group_name>
<attribute_group_narrative>SmartPanel attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="59" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>BrowseColumnBGColors</attribute_label>
<attribute_group_obj>436.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>CHR(3) list of browse column BGCOLORS</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>14645.409</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>436.7063</attribute_group_obj>
<attribute_group_name>Browser</attribute_group_name>
<attribute_group_narrative>SmartBrowser attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="60" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>BrowseColumnFGColors</attribute_label>
<attribute_group_obj>436.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>CHR(3) list of browse column FGColors</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>14643.409</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>436.7063</attribute_group_obj>
<attribute_group_name>Browser</attribute_group_name>
<attribute_group_narrative>SmartBrowser attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="61" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="10/04/2002" version_time="28707" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="14656.409" record_version_obj="7663.009" version_number_seq="1.009" secondary_key_value="BrowseColumnFonts" import_version_number_seq="1.009"><attribute_label>BrowseColumnFonts</attribute_label>
<attribute_group_obj>436.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>CHR(3) list of fonts for browser columns</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>yes</design_only>
<system_owned>no</system_owned>
<attribute_obj>14656.409</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>436.7063</attribute_group_obj>
<attribute_group_name>Browser</attribute_group_name>
<attribute_group_narrative>SmartBrowser attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="62" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="10/04/2002" version_time="28708" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="14801.409" record_version_obj="7664.009" version_number_seq="1.009" secondary_key_value="BrowseColumnFormats" import_version_number_seq="1.009"><attribute_label>BrowseColumnFormats</attribute_label>
<attribute_group_obj>436.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>CHR(3) list of dynamic browse column formats</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>yes</design_only>
<system_owned>no</system_owned>
<attribute_obj>14801.409</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>436.7063</attribute_group_obj>
<attribute_group_name>Browser</attribute_group_name>
<attribute_group_narrative>SmartBrowser attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="63" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>BrowseColumnLabelBGColors</attribute_label>
<attribute_group_obj>436.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>CHR(3) list of BGCOLORs from browse column labels</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>14652.409</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>436.7063</attribute_group_obj>
<attribute_group_name>Browser</attribute_group_name>
<attribute_group_narrative>SmartBrowser attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="64" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>BrowseColumnLabelFGColors</attribute_label>
<attribute_group_obj>436.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>CHR(3) list of FGCOLORs for browse column labels</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>14650.409</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>436.7063</attribute_group_obj>
<attribute_group_name>Browser</attribute_group_name>
<attribute_group_narrative>SmartBrowser attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="65" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>BrowseColumnLabelFonts</attribute_label>
<attribute_group_obj>436.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>CHR(3) list of fonts for browse column labels</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>14654.409</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>436.7063</attribute_group_obj>
<attribute_group_name>Browser</attribute_group_name>
<attribute_group_narrative>SmartBrowser attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="66" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>BrowseColumnLabels</attribute_label>
<attribute_group_obj>436.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>CHR(3) Delimited list of browser labels</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>14633.409</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>436.7063</attribute_group_obj>
<attribute_group_name>Browser</attribute_group_name>
<attribute_group_narrative>SmartBrowser attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="67" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>BrowseColumnWidths</attribute_label>
<attribute_group_obj>436.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>CHR(3) list of browse column widths (integer values only)</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>14648.409</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>436.7063</attribute_group_obj>
<attribute_group_name>Browser</attribute_group_name>
<attribute_group_narrative>SmartBrowser attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="68" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>BrowseContainer</attribute_label>
<attribute_group_obj>434.7063</attribute_group_obj>
<data_type>10</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>594.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>434.7063</attribute_group_obj>
<attribute_group_name>Select</attribute_group_name>
<attribute_group_narrative>SmartSelect attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="69" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>BrowseFieldDataTypes</attribute_label>
<attribute_group_obj>1005095447.101</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Dynamic Lookup Data types of fields to display in lookup browser, comma list.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005089877.28</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_group_name>SdfAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Smart Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="70" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>BrowseFieldFormats</attribute_label>
<attribute_group_obj>1005095447.101</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Dynamic Lookup Formats of fields to display in lookup browser, comma list. (Default Formats)</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005089878.28</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_group_name>SdfAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Smart Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="71" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>BrowseFields</attribute_label>
<attribute_group_obj>1005095447.101</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Dynamic Lookup Fields to display in lookup browser, comma list of table.field.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005089876.28</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_group_name>SdfAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Smart Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="72" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>BrowseHandle</attribute_label>
<attribute_group_obj>436.7063</attribute_group_obj>
<data_type>10</data_type>
<attribute_narrative>The handle of the browse control.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>470.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>436.7063</attribute_group_obj>
<attribute_group_name>Browser</attribute_group_name>
<attribute_group_narrative>SmartBrowser attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="73" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>BrowseInitted</attribute_label>
<attribute_group_obj>436.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>TRUE if the SmartBrowse has been initialized.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>472.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>436.7063</attribute_group_obj>
<attribute_group_name>Browser</attribute_group_name>
<attribute_group_narrative>SmartBrowser attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="74" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>BrowseObject</attribute_label>
<attribute_group_obj>434.7063</attribute_group_obj>
<data_type>10</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>596.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>434.7063</attribute_group_obj>
<attribute_group_name>Select</attribute_group_name>
<attribute_group_narrative>SmartSelect attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="75" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>BrowseProcedure</attribute_label>
<attribute_group_obj>1005095447.101</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The name of the browser to use for lookup</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>1005089890.28</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_group_name>SdfAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Smart Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="76" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>BrowseTitle</attribute_label>
<attribute_group_obj>1005095447.101</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Title for lookup browser for Dynamic Lookups.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>1005089879.28</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_group_name>SdfAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Smart Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="77" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>BrowseWindowProcedure</attribute_label>
<attribute_group_obj>1005095447.101</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The name of the window to display the browse on for Dynamic Lookups</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>1005089889.28</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_group_name>SdfAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Smart Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="78" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>BUFFER-CHARS</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>4</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005099297.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="79" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>BUFFER-LINES</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>4</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005099298.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="80" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>BufferHandles</attribute_label>
<attribute_group_obj>154.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Comma-separated list of the handles of the query buffers.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>511.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>154.7063</attribute_group_obj>
<attribute_group_name>Query</attribute_group_name>
<attribute_group_narrative>Query object attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="81" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>BuildSequence</attribute_label>
<attribute_group_obj>1005095447.101</attribute_group_obj>
<data_type>4</data_type>
<attribute_narrative>The sequence number in which the Dynamic Combo&apos;s data should be build.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>1005115831.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_group_name>SdfAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Smart Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="82" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ButtonCount</attribute_label>
<attribute_group_obj>438.7063</attribute_group_obj>
<data_type>4</data_type>
<attribute_narrative>The number of buttons in a SmartPanel, for resizeObject.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>658.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>438.7063</attribute_group_obj>
<attribute_group_name>Panel</attribute_group_name>
<attribute_group_narrative>SmartPanel attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="83" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ButtonHandle</attribute_label>
<attribute_group_obj>434.7063</attribute_group_obj>
<data_type>10</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>592.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>434.7063</attribute_group_obj>
<attribute_group_name>Select</attribute_group_name>
<attribute_group_narrative>SmartSelect attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="84" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>CalcWidth</attribute_label>
<attribute_group_obj>436.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Determines whether the width of the browse is calculated to the exact width it should be for the fields it contains.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>474.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>436.7063</attribute_group_obj>
<attribute_group_name>Browser</attribute_group_name>
<attribute_group_narrative>SmartBrowser attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="85" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>CallerObject</attribute_label>
<attribute_group_obj>347.7063</attribute_group_obj>
<data_type>10</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>404.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>347.7063</attribute_group_obj>
<attribute_group_name>Container</attribute_group_name>
<attribute_group_narrative>Container Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="86" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>CallerProcedure</attribute_label>
<attribute_group_obj>347.7063</attribute_group_obj>
<data_type>10</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>402.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>347.7063</attribute_group_obj>
<attribute_group_name>Container</attribute_group_name>
<attribute_group_narrative>Container Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="87" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>CallerWindow</attribute_label>
<attribute_group_obj>347.7063</attribute_group_obj>
<data_type>10</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>400.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>347.7063</attribute_group_obj>
<attribute_group_name>Container</attribute_group_name>
<attribute_group_narrative>Container Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="88" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="03/06/2003" version_time="65763" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="785.7692" record_version_obj="786.7692" version_number_seq="1.09" secondary_key_value="CANCEL-BUTTON" import_version_number_seq="1.09"><attribute_label>CANCEL-BUTTON</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>A button widget in the frame or dialog box to receive the CHOOSE event when a user cancels the current frame or dialog box by pressing the ESC key.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>785.7692</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="89" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>CancelBrowseOnExit</attribute_label>
<attribute_group_obj>434.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Set to true if the value in the browse is NOT to be selected on Exit.
This setting should probably be set to true when ExitBrowseOnAction also is true. Because when the user Exits the browse when a value is selected the close button can function as a Cancel.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>600.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>434.7063</attribute_group_obj>
<attribute_group_name>Select</attribute_group_name>
<attribute_group_narrative>SmartSelect attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="90" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="03/12/2003" version_time="66447" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="32986.66" record_version_obj="32987.66" version_number_seq="1.09" secondary_key_value="CanFilter" import_version_number_seq="1.09"><attribute_label>CanFilter</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Set to FALSE if this field should not be used to filter the data object query.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>32986.66</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="91" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="03/12/2003" version_time="66447" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="32984.66" record_version_obj="32985.66" version_number_seq="1.09" secondary_key_value="CanSort" import_version_number_seq="1.09"><attribute_label>CanSort</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Set to FALSE if this field should not be used to sort the data object query.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>32984.66</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="92" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>CascadeOnBrowse</attribute_label>
<attribute_group_obj>428.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Determines whether data will be retrieved from a dependent SDO if the parent SDO has more than one row in its current dataset; if TRUE (the default), data will be retrieved for the first row in the parent dataset, otherwise not.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>450.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>428.7063</attribute_group_obj>
<attribute_group_name>DataContainer</attribute_group_name>
<attribute_group_narrative>SmartBusinessObject and other Data Container attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="93" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ChangedEvent</attribute_label>
<attribute_group_obj>434.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Stores an optional event to publish on value-changed.
The developer must make sure to define the corresponding SUBSCRIBE, usually in the SmartDataViewer container .</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>570.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>434.7063</attribute_group_obj>
<attribute_group_name>Select</attribute_group_name>
<attribute_group_narrative>SmartSelect attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="94" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>Chars</attribute_label>
<attribute_group_obj>1005098168.101</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The number of characters in an editor. This is denominated in units as
determined by the SizeUnits attribute value.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005098170.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005098168.101</attribute_group_obj>
<attribute_group_name>EditorAttributes</attribute_group_name>
<attribute_group_narrative>Attributes which are specific to an editor widget</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="95" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>CheckCurrentChanged</attribute_label>
<attribute_group_obj>152.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Indicates whether the DataObject should check if database record(s) have been changed since read, before doing an update.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>1003183466</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>152.7063</attribute_group_obj>
<attribute_group_name>Data</attribute_group_name>
<attribute_group_narrative>SDO Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="96" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>CHECKED</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005099329.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="97" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>CheckLastOnOpen</attribute_label>
<attribute_group_obj>154.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Flag indicating whether a get-last should be performed on an open in order for fetchNext to be able to detect that we are on the last row. This is necessary to make the QueryPosition 
attribute reliable.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>521.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>154.7063</attribute_group_obj>
<attribute_group_name>Query</attribute_group_name>
<attribute_group_narrative>Query object attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="98" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ChildDataKey</attribute_label>
<attribute_group_obj>5.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>66.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>5.7063</attribute_group_obj>
<attribute_group_name>Smart</attribute_group_name>
<attribute_group_narrative>Smart Object common attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="99" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ClientID</attribute_label>
<attribute_group_obj>731.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The Client ID for the JMS broker connection.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>898.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>731.7063</attribute_group_obj>
<attribute_group_name>Messaging</attribute_group_name>
<attribute_group_narrative>Messaging SmartObject attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="100" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ClientNames</attribute_label>
<attribute_group_obj>347.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Lst that corresponds to InstanceNames, with the proxy&apos;s ObjectName on the client.
It is set in a server side container, so that containedProperties and assignContainedProperties can receive and return properties to and from a client with a different container structure.
This is required in the dynamic server container, which constructs server side objects for all data objects in the caller container tree, without recreating the child-containers that are not QueryObjects.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>418.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>347.7063</attribute_group_obj>
<attribute_group_name>Container</attribute_group_name>
<attribute_group_narrative>Container Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="101" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="03/14/2003" version_time="58773" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="9927.009" record_version_obj="9928.009" version_number_seq="1.09" secondary_key_value="ColorErrorBG" import_version_number_seq="1.09"><attribute_label>ColorErrorBG</attribute_label>
<attribute_group_obj>7.7063</attribute_group_obj>
<data_type>4</data_type>
<attribute_narrative>Stores error background color number for use by the highlightWidget function.  Should match entry in the color table.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>9927.009</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>7.7063</attribute_group_obj>
<attribute_group_name>Visual</attribute_group_name>
<attribute_group_narrative>Visual Smartobject attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="102" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="03/14/2003" version_time="58773" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="9925.009" record_version_obj="9926.009" version_number_seq="1.09" secondary_key_value="ColorErrorFG" import_version_number_seq="1.09"><attribute_label>ColorErrorFG</attribute_label>
<attribute_group_obj>7.7063</attribute_group_obj>
<data_type>4</data_type>
<attribute_narrative>Stores error foreground color number for use by the highlightWidget function.  Should match entry in the color table.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>9925.009</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>7.7063</attribute_group_obj>
<attribute_group_name>Visual</attribute_group_name>
<attribute_group_narrative>Visual Smartobject attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="103" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="03/14/2003" version_time="58773" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="9917.009" record_version_obj="9918.009" version_number_seq="1.09" secondary_key_value="ColorInfoBG" import_version_number_seq="1.09"><attribute_label>ColorInfoBG</attribute_label>
<attribute_group_obj>7.7063</attribute_group_obj>
<data_type>4</data_type>
<attribute_narrative>Stores information background color number for use by the highlightWidget function.  Should match entry in the color table.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>9917.009</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>7.7063</attribute_group_obj>
<attribute_group_name>Visual</attribute_group_name>
<attribute_group_narrative>Visual Smartobject attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="104" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="03/14/2003" version_time="58773" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="9919.009" record_version_obj="9920.009" version_number_seq="1.09" secondary_key_value="ColorInfoFG" import_version_number_seq="1.09"><attribute_label>ColorInfoFG</attribute_label>
<attribute_group_obj>7.7063</attribute_group_obj>
<data_type>4</data_type>
<attribute_narrative>Stores information foreground color number for use by the highlightWidget function.  Should match entry in the color table.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>9919.009</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>7.7063</attribute_group_obj>
<attribute_group_name>Visual</attribute_group_name>
<attribute_group_narrative>Visual Smartobject attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="105" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="03/14/2003" version_time="58773" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="9921.009" record_version_obj="9922.009" version_number_seq="1.09" secondary_key_value="ColorWarnBG" import_version_number_seq="1.09"><attribute_label>ColorWarnBG</attribute_label>
<attribute_group_obj>7.7063</attribute_group_obj>
<data_type>4</data_type>
<attribute_narrative>Stores warning background color number for use by the highlightWidget function.  Should match entry in the color table.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>9921.009</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>7.7063</attribute_group_obj>
<attribute_group_name>Visual</attribute_group_name>
<attribute_group_narrative>Visual Smartobject attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="106" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="03/14/2003" version_time="58773" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="9923.009" record_version_obj="9924.009" version_number_seq="1.09" secondary_key_value="ColorWarnFG" import_version_number_seq="1.09"><attribute_label>ColorWarnFG</attribute_label>
<attribute_group_obj>7.7063</attribute_group_obj>
<data_type>4</data_type>
<attribute_narrative>Stores warning foreground color number for use by the highlightWidget function.  Should match entry in the color table.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>9923.009</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>7.7063</attribute_group_obj>
<attribute_group_name>Visual</attribute_group_name>
<attribute_group_narrative>Visual Smartobject attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="107" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="10/03/2002" version_time="45358" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="1005078421.09" record_version_obj="5106.66" version_number_seq="3.66" secondary_key_value="COLUMN" import_version_number_seq="3.66"><attribute_label>COLUMN</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>5</data_type>
<attribute_narrative>Column position. This may currently be used when rendering some objects. There is no getColumns function, use getCol to retrieve the realized value from an object.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005078421.09</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="108" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>COLUMN-MOVABLE</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Browse columns can be moved at run-time</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>14635.409</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="109" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>COLUMN-RESIZABLE</attribute_label>
<attribute_group_obj>3000002003.09</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Browse columns can be resized at run-time</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>14637.409</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="02/10/2003" version_time="59461" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="3000002003.09" record_version_obj="3000002004.09" version_number_seq="1.09" secondary_key_value="ADMAttributes" import_version_number_seq="1.09"><attribute_group_obj>3000002003.09</attribute_group_obj>
<attribute_group_name>ADMAttributes</attribute_group_name>
<attribute_group_narrative>This group contains all attributes of ADM objects excepts those that can also be Widget Attributes. In that case, they are in the WidgetAttribute group.</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="110" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>COLUMN-SCROLLING</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Browse column scrolling attribute</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>14639.409</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="111" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ColumnFormat</attribute_label>
<attribute_group_obj>1005095447.101</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Dynamic Lookup browse column format override - comma list.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005089895.28</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_group_name>SdfAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Smart Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="112" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ColumnLabel</attribute_label>
<attribute_group_obj>3000002003.09</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>WidgetAttributes ColumnLabel</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>3000000341.09</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="02/10/2003" version_time="59461" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="3000002003.09" record_version_obj="3000002004.09" version_number_seq="1.09" secondary_key_value="ADMAttributes" import_version_number_seq="1.09"><attribute_group_obj>3000002003.09</attribute_group_obj>
<attribute_group_name>ADMAttributes</attribute_group_name>
<attribute_group_narrative>This group contains all attributes of ADM objects excepts those that can also be Widget Attributes. In that case, they are in the WidgetAttribute group.</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="113" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ColumnLabels</attribute_label>
<attribute_group_obj>1005095447.101</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Dynamic Lookup browse override labels - comma list</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005089894.28</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_group_name>SdfAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Smart Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="114" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ColumnNumber</attribute_label>
<attribute_group_obj>3000002003.09</attribute_group_obj>
<data_type>4</data_type>
<attribute_narrative>The column number of the widget</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005093795.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="02/10/2003" version_time="59461" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="3000002003.09" record_version_obj="3000002004.09" version_number_seq="1.09" secondary_key_value="ADMAttributes" import_version_number_seq="1.09"><attribute_group_obj>3000002003.09</attribute_group_obj>
<attribute_group_name>ADMAttributes</attribute_group_name>
<attribute_group_narrative>This group contains all attributes of ADM objects excepts those that can also be Widget Attributes. In that case, they are in the WidgetAttribute group.</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="115" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>COLUMNS</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>4</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005099309.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="116" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ColumnSequence</attribute_label>
<attribute_group_obj>3000002003.09</attribute_group_obj>
<data_type>4</data_type>
<attribute_narrative>The sequence number of the widget within a column</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005093796.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="02/10/2003" version_time="59461" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="3000002003.09" record_version_obj="3000002004.09" version_number_seq="1.09" secondary_key_value="ADMAttributes" import_version_number_seq="1.09"><attribute_group_obj>3000002003.09</attribute_group_obj>
<attribute_group_name>ADMAttributes</attribute_group_name>
<attribute_group_narrative>This group contains all attributes of ADM objects excepts those that can also be Widget Attributes. In that case, they are in the WidgetAttribute group.</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="117" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ColumnsMovable</attribute_label>
<attribute_group_obj>436.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Determines whether the browser&apos;s columns are movable</attribute_narrative>
<override_type>SET</override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>263.009</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>436.7063</attribute_group_obj>
<attribute_group_name>Browser</attribute_group_name>
<attribute_group_narrative>SmartBrowser attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="118" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ColumnsSortable</attribute_label>
<attribute_group_obj>436.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Determines whether the browser&apos;s columns are sortable</attribute_narrative>
<override_type>SET</override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>271.009</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>436.7063</attribute_group_obj>
<attribute_group_name>Browser</attribute_group_name>
<attribute_group_narrative>SmartBrowser attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="119" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ComboDelimiter</attribute_label>
<attribute_group_obj>1005095447.101</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>831.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_group_name>SdfAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Smart Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="120" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ComboFlag</attribute_label>
<attribute_group_obj>1005095447.101</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Optional Dynamic Combo flags - Contains &apos;A&apos; for &lt;All&gt; or &apos;N&apos; for &lt;None&gt; - Blank will indicate that no extra option should be added to combo.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005111017.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_group_name>SdfAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Smart Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="121" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ComboFlagValue</attribute_label>
<attribute_group_obj>1005095447.101</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The value for the optional Dynamic Combo flags &lt;All&gt; and &lt;None&gt;</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005114147.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_group_name>SdfAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Smart Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="122" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ComboHandle</attribute_label>
<attribute_group_obj>1005095447.101</attribute_group_obj>
<data_type>10</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>837.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_group_name>SdfAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Smart Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="123" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ComboSort</attribute_label>
<attribute_group_obj>1005095447.101</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>YES or NO to set a Dynamic Combo&apos;s COMBO-BOX sort option.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005111019.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_group_name>SdfAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Smart Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="124" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>CommitSource</attribute_label>
<attribute_group_obj>152.7063</attribute_group_obj>
<data_type>10</data_type>
<attribute_narrative>The handle of CommitSource object</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>180.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>152.7063</attribute_group_obj>
<attribute_group_name>Data</attribute_group_name>
<attribute_group_narrative>SDO Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="125" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>CommitSourceEvents</attribute_label>
<attribute_group_obj>152.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The list of events this object subscribes to in its Commit-Source</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level>Class</constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>186.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>152.7063</attribute_group_obj>
<attribute_group_name>Data</attribute_group_name>
<attribute_group_narrative>SDO Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="126" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>CommitTarget</attribute_label>
<attribute_group_obj>152.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The handle of the object&apos;s CommitTarget, in character form</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>182.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>152.7063</attribute_group_obj>
<attribute_group_name>Data</attribute_group_name>
<attribute_group_narrative>SDO Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="127" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>CommitTargetEvents</attribute_label>
<attribute_group_obj>152.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The list of events this object subscribes to in its Commit-Target</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level>Class</constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>184.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>152.7063</attribute_group_obj>
<attribute_group_name>Data</attribute_group_name>
<attribute_group_narrative>SDO Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="128" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ContainedAppServices</attribute_label>
<attribute_group_obj>347.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>List of the Appservices of the Data Objects contained in this container.
The container class uses this to manage dataobjects in the stateless server side APIs.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>422.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>347.7063</attribute_group_obj>
<attribute_group_name>Container</attribute_group_name>
<attribute_group_narrative>Container Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="129" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ContainedDataColumns</attribute_label>
<attribute_group_obj>428.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>List of all the DataColumns of all the DataObjects in this SBO.
The list of columns for each contained Data Object is comma-delimited, with a semicolon between lists for each Data Object (in the same order as the ContainedDataObjects property).</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>442.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>428.7063</attribute_group_obj>
<attribute_group_name>DataContainer</attribute_group_name>
<attribute_group_narrative>SmartBusinessObject and other Data Container attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="130" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ContainedDataObjects</attribute_label>
<attribute_group_obj>347.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>List of the handles of the Data Objects contained in this object.
The container class uses this to keep track of the dataobjects in 
the stateless server side APIs. 
The sbo class uses it on both client and server in almost all logic
also at design time to get names and column lists from the 
individual Data Objects.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>420.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>347.7063</attribute_group_obj>
<attribute_group_name>Container</attribute_group_name>
<attribute_group_narrative>Container Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="131" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ContainerHandle</attribute_label>
<attribute_group_obj>5.7063</attribute_group_obj>
<data_type>10</data_type>
<attribute_narrative>The widget handle of this object&apos;s Window or Frame container</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>25.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>5.7063</attribute_group_obj>
<attribute_group_name>Smart</attribute_group_name>
<attribute_group_narrative>Smart Object common attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="132" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ContainerHidden</attribute_label>
<attribute_group_obj>5.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Flag indicating whether this object&apos;s *parent* container is hidden.
This function also sets the ObjectHidden property, because when a container is hidden or viewed, hideObject and viewObject are not run in the contained objects, since they are hidden implicitly when the container is hidden. However, code in various places checks the ObjectHidden property, and this needs to be set to match ContainerHidden. ContainerHidden is not referenced in the ADM code, and is preserved for compatibility.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>29.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>5.7063</attribute_group_obj>
<attribute_group_name>Smart</attribute_group_name>
<attribute_group_narrative>Smart Object common attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="133" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ContainerMode</attribute_label>
<attribute_group_obj>347.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>1003585204</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>347.7063</attribute_group_obj>
<attribute_group_name>Container</attribute_group_name>
<attribute_group_narrative>Container Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="134" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ContainerSource</attribute_label>
<attribute_group_obj>5.7063</attribute_group_obj>
<data_type>10</data_type>
<attribute_narrative>The handle of this object&apos;s ContainerSource, if any.
&apos;Set&apos; for this property should be run only from add/removeLink and modifyListProperty.
It&apos;s needed because the callers get a variable link name for which {set} can&apos;t be used.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>39.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>5.7063</attribute_group_obj>
<attribute_group_name>Smart</attribute_group_name>
<attribute_group_narrative>Smart Object common attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="135" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ContainerSourceEvents</attribute_label>
<attribute_group_obj>5.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>A comma-separated list of the events this object needs to subscribe to in its ContainerSource.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level>Class</constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>41.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>5.7063</attribute_group_obj>
<attribute_group_name>Smart</attribute_group_name>
<attribute_group_narrative>Smart Object common attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="136" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ContainerTarget</attribute_label>
<attribute_group_obj>347.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>A comma-separated list of the handles of this object&apos;s contained objects.
It should be modified using modifyListProperty, and is normally maintained by &apos;addLink&apos;.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>351.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>347.7063</attribute_group_obj>
<attribute_group_name>Container</attribute_group_name>
<attribute_group_narrative>Container Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="137" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ContainerTargetEvents</attribute_label>
<attribute_group_obj>347.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>A comma-separated list of the events this object needs to subscribe to in its ContainerTarget
</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level>Class</constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>353.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>347.7063</attribute_group_obj>
<attribute_group_name>Container</attribute_group_name>
<attribute_group_narrative>Container Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="138" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ContainerType</attribute_label>
<attribute_group_obj>5.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The Type of Container which this SmartObject is --
blank if the object is not a container, otherwise &quot;WINDOW&quot; for
a SmartWindow , &quot;FRAME&quot; for a SmartFrame.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>19.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>5.7063</attribute_group_obj>
<attribute_group_name>Smart</attribute_group_name>
<attribute_group_narrative>Smart Object common attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="139" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>CONTEXT-HELP-ID</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>4</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005099306.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="140" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>CONVERT-3D-COLORS</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005099322.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="141" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="03/19/2003" version_time="56747" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="104.7063" record_version_obj="3000044720.09" version_number_seq="1.09" secondary_key_value="CreateHandles" import_version_number_seq="1.09"><attribute_label>CreateHandles</attribute_label>
<attribute_group_obj>9.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>A comma-separated list of the handles of the fields in the data visualization object which should be enabled for an Add or Copy operation.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>104.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>9.7063</attribute_group_obj>
<attribute_group_name>DataVisual</attribute_group_name>
<attribute_group_narrative>Data visualization object attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="142" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>CurrentMessage</attribute_label>
<attribute_group_obj>507.49</attribute_group_obj>
<data_type>10</data_type>
<attribute_narrative>Stores the handle to the current message.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>924.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="09/04/2002" version_time="57071" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="507.49" record_version_obj="508.49" version_number_seq="3.49" secondary_key_value="Producer" import_version_number_seq="3.49"><attribute_group_obj>507.49</attribute_group_obj>
<attribute_group_name>Producer</attribute_group_name>
<attribute_group_narrative>SmartProducer attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="143" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>CurrentMessageId</attribute_label>
<attribute_group_obj>509.49</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The Current Message Id holds the id from the last sendMessage 
with ReplyRequired.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>922.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="09/04/2002" version_time="57055" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="509.49" record_version_obj="510.49" version_number_seq="2.49" secondary_key_value="MsgHandler" import_version_number_seq="2.49"><attribute_group_obj>509.49</attribute_group_obj>
<attribute_group_name>MsgHandler</attribute_group_name>
<attribute_group_narrative>Message Handler attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="144" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>CurrentPage</attribute_label>
<attribute_group_obj>347.7063</attribute_group_obj>
<data_type>4</data_type>
<attribute_narrative>The current page number of the Container</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>349.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>347.7063</attribute_group_obj>
<attribute_group_name>Container</attribute_group_name>
<attribute_group_narrative>Container Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="145" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>CurrentQueryString</attribute_label>
<attribute_group_obj>1005095447.101</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>827.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_group_name>SdfAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Smart Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="146" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>CurrentRowid</attribute_label>
<attribute_group_obj>152.7063</attribute_group_obj>
<data_type>9</data_type>
<attribute_narrative>Current ROWID of the RowObject query.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>174.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>152.7063</attribute_group_obj>
<attribute_group_name>Data</attribute_group_name>
<attribute_group_narrative>SDO Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="147" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>CurrentUpdateSource</attribute_label>
<attribute_group_obj>152.7063</attribute_group_obj>
<data_type>10</data_type>
<attribute_narrative>The current updateSource.
This is just set temporarily in updateState before re-publishing updateState, so that the updateSource/DataTarget can avoid a  republish when it is the original publisher.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>178.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>152.7063</attribute_group_obj>
<attribute_group_name>Data</attribute_group_name>
<attribute_group_narrative>SDO Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="148" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>CURSOR-CHAR</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>4</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005099278.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="149" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>CURSOR-LINE</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>4</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005099277.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="150" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>CURSOR-OFFSET</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>4</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005099276.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="151" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="11/05/2002" version_time="42631" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="560.7063" record_version_obj="1000016350.48" version_number_seq="1.09" secondary_key_value="CustomSuperProc" import_version_number_seq="1.09"><attribute_label>CustomSuperProc</attribute_label>
<attribute_group_obj>432.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>A custom super procedure for the object.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>560.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>432.7063</attribute_group_obj>
<attribute_group_name>Field</attribute_group_name>
<attribute_group_narrative>SmartField Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="152" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>DATA-TYPE</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>WidgetAttributes Data-Type</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005078413.09</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="153" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>DatabaseName</attribute_label>
<attribute_group_obj>3000002003.09</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>WidgetAttributes DataBaseName</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005078711.09</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="02/10/2003" version_time="59461" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="3000002003.09" record_version_obj="3000002004.09" version_number_seq="1.09" secondary_key_value="ADMAttributes" import_version_number_seq="1.09"><attribute_group_obj>3000002003.09</attribute_group_obj>
<attribute_group_name>ADMAttributes</attribute_group_name>
<attribute_group_narrative>This group contains all attributes of ADM objects excepts those that can also be Widget Attributes. In that case, they are in the WidgetAttribute group.</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="154" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>DataColumns</attribute_label>
<attribute_group_obj>428.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>A list of all the DataColumns of all the Data Objects in this SBO, each qualified by the SDO ObjectName.
The list of columns for each contained Data Object is comma-delimited, and qualified by Object Names, as an alternative to the ContainedDataColumns form of the list which divides the list by SDO.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>446.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>428.7063</attribute_group_obj>
<attribute_group_name>DataContainer</attribute_group_name>
<attribute_group_narrative>SmartBusinessObject and other Data Container attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="155" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>DataColumnsByTable</attribute_label>
<attribute_group_obj>154.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>A comma-delimited list of the columnNames separated
by CHR(1) to identify groups of columns that belong to the same table. If grouping is not required, use DataColums to get a comma separated summary list.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>507.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>154.7063</attribute_group_obj>
<attribute_group_name>Query</attribute_group_name>
<attribute_group_narrative>Query object attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="156" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>DataContainer</attribute_label>
<attribute_group_obj>347.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Indicates whether or not this container is a Data Container.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>424.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>347.7063</attribute_group_obj>
<attribute_group_name>Container</attribute_group_name>
<attribute_group_narrative>Container Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="157" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>DataDelimiter</attribute_label>
<attribute_group_obj>152.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The delimiter to use for data values passed to the registered DataReadHandler when traversing the query.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>200000003010.66</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>152.7063</attribute_group_obj>
<attribute_group_name>Data</attribute_group_name>
<attribute_group_narrative>SDO Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="158" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>DataFieldDefs</attribute_label>
<attribute_group_obj>152.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The name of the include file in which the field definitions for this SDO&apos;s RowObject table are stored</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level>Master</constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>yes</design_only>
<system_owned>yes</system_owned>
<attribute_obj>204.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>152.7063</attribute_group_obj>
<attribute_group_name>Data</attribute_group_name>
<attribute_group_narrative>SDO Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="159" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>DataHandle</attribute_label>
<attribute_group_obj>152.7063</attribute_group_obj>
<data_type>10</data_type>
<attribute_narrative>The handle to the temp-table (RowObject) query</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>170.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>152.7063</attribute_group_obj>
<attribute_group_name>Data</attribute_group_name>
<attribute_group_narrative>SDO Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="160" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>DataIsFetched</attribute_label>
<attribute_group_obj>428.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>The SBO sets this to true in the SDO when it has fethed  data on the SDOs behalf in order to prevent that the SDO does 
another server call to fetch the data it already has. 
This is checked in query.p dataAvailable and openQuery is skipped if its true. It&apos;s immediately turned off after it is checked.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>468.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>428.7063</attribute_group_obj>
<attribute_group_name>DataContainer</attribute_group_name>
<attribute_group_narrative>SmartBusinessObject and other Data Container attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="161" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>DataLinksEnabled</attribute_label>
<attribute_group_obj>5.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Not in use</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>70.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>5.7063</attribute_group_obj>
<attribute_group_name>Smart</attribute_group_name>
<attribute_group_narrative>Smart Object common attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="162" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>DataLogicObject</attribute_label>
<attribute_group_obj>152.7063</attribute_group_obj>
<data_type>10</data_type>
<attribute_narrative>The handle of the logic procedure that contains business logic for the data object.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>200000003004.66</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>152.7063</attribute_group_obj>
<attribute_group_name>Data</attribute_group_name>
<attribute_group_narrative>SDO Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="163" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="04/01/2003" version_time="52317" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="200000003002.66" record_version_obj="3000045143.09" version_number_seq="2.09" secondary_key_value="DataLogicProcedure" import_version_number_seq="2.09"><attribute_label>DataLogicProcedure</attribute_label>
<attribute_group_obj>152.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The name of the logic procedure that contains business logic for the data object.</attribute_narrative>
<override_type>SET</override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level>Master</constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>200000003002.66</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>152.7063</attribute_group_obj>
<attribute_group_name>Data</attribute_group_name>
<attribute_group_narrative>SDO Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="164" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>DataModified</attribute_label>
<attribute_group_obj>9.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Indicates whether the current SCREEN-VALUES have been modified but not saved.
This property is set when the user modifies some data on the screen.</attribute_narrative>
<override_type>set</override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>96.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>9.7063</attribute_group_obj>
<attribute_group_name>DataVisual</attribute_group_name>
<attribute_group_narrative>Data visualization object attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="165" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>DataObject</attribute_label>
<attribute_group_obj>608.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The name of the filter used at design time.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>614.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>608.7063</attribute_group_obj>
<attribute_group_name>Filter</attribute_group_name>
<attribute_group_narrative>SmartFilter attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="166" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>DataObjectNames</attribute_label>
<attribute_group_obj>428.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Ordered list of ObjectNames of contained SDOs.
It is normally changed through the SBO Instance Property Dialog. Change only after the Object names for the SDOs within the SBO have been set.
Must be run to retrieve the value so that it can check whether the value is still valid, which may not be the case if objects have been removed, added, or replaced since the SBO was last saved. If it no longer matches the list of contained SDOs, then it is blanked and the default value recalculated.</attribute_narrative>
<override_type>get</override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>444.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>428.7063</attribute_group_obj>
<attribute_group_name>DataContainer</attribute_group_name>
<attribute_group_narrative>SmartBusinessObject and other Data Container attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="167" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>DataObjectOrdering</attribute_label>
<attribute_group_obj>428.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Mapping of the order of Update Tables as generated by the AppBuilder to the developer-defined update order.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>454.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>428.7063</attribute_group_obj>
<attribute_group_name>DataContainer</attribute_group_name>
<attribute_group_narrative>SmartBusinessObject and other Data Container attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="168" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>DataQueryBrowsed</attribute_label>
<attribute_group_obj>152.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>TRUE if this SmartDataObject&apos;s Query is being browsed by a SmartDataBrowser.
This is used to prevent two SmartDataBrowsers from attempting to browse the same query, which is not allowed because conflicts would occur.</attribute_narrative>
<override_type>set</override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>190.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>152.7063</attribute_group_obj>
<attribute_group_name>Data</attribute_group_name>
<attribute_group_narrative>SDO Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="169" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>DataQueryString</attribute_label>
<attribute_group_obj>152.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The string used to prepare the RowObject query (see notes in &apos;setDataQueryString&apos;)</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>172.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>152.7063</attribute_group_obj>
<attribute_group_name>Data</attribute_group_name>
<attribute_group_narrative>SDO Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="170" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>DataReadBuffer</attribute_label>
<attribute_group_obj>152.7063</attribute_group_obj>
<data_type>10</data_type>
<attribute_narrative>Specifies a buffer for the receive event. This buffer will only have one record and be used as a transport buffer for data from the data object to the ReadEventHandler&apos;s receiveBuffer event procedure</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>116</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>152.7063</attribute_group_obj>
<attribute_group_name>Data</attribute_group_name>
<attribute_group_narrative>SDO Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="171" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>DataReadColumns</attribute_label>
<attribute_group_obj>152.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>A comma-separated list of columns to pass to the registered DataReadHandler when traversing the query.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>200000003008.66</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>152.7063</attribute_group_obj>
<attribute_group_name>Data</attribute_group_name>
<attribute_group_narrative>SDO Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="172" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>DataReadFormat</attribute_label>
<attribute_group_obj>152.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Specifies the format for read event and updateData and createData APIs. 
-  Blank =  No formatting, just buffer values 
- &apos;Formatted&apos; =  Formatted according to the columnFormat with right
                        justified numeric values.
- &apos;TrimNumeric&apos; =  Formatted according to the columnFormat with LEFT 
                            justified numeric data</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>114</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>152.7063</attribute_group_obj>
<attribute_group_name>Data</attribute_group_name>
<attribute_group_narrative>SDO Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="173" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>DataReadHandler</attribute_label>
<attribute_group_obj>152.7063</attribute_group_obj>
<data_type>10</data_type>
<attribute_narrative>The handle of a procedure that has been registered to receive 
output from the object.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>200000003006.66</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>152.7063</attribute_group_obj>
<attribute_group_name>Data</attribute_group_name>
<attribute_group_narrative>SDO Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="174" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>DataSource</attribute_label>
<attribute_group_obj>5.7063</attribute_group_obj>
<data_type>10</data_type>
<attribute_narrative>WidgetAttributes DataSource</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>1005109051.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>5.7063</attribute_group_obj>
<attribute_group_name>Smart</attribute_group_name>
<attribute_group_narrative>Smart Object common attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="175" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>DataSourceEvents</attribute_label>
<attribute_group_obj>5.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>A comma-separated list of the events this object needs to subscribe to in its DataSource.
Because this is a comma-separated list, it should normally be
invoked indirectly, through &apos;modifyListProperty&apos;</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level>Class</constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>44.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>5.7063</attribute_group_obj>
<attribute_group_name>Smart</attribute_group_name>
<attribute_group_narrative>Smart Object common attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="176" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>DataSourceFilter</attribute_label>
<attribute_group_obj>434.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>An optional filter expression for the data-source.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>572.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>434.7063</attribute_group_obj>
<attribute_group_name>Select</attribute_group_name>
<attribute_group_narrative>SmartSelect attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="177" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>DataSourceName</attribute_label>
<attribute_group_obj>3000002003.09</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>DataSourceName</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005104898.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="02/10/2003" version_time="59461" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="3000002003.09" record_version_obj="3000002004.09" version_number_seq="1.09" secondary_key_value="ADMAttributes" import_version_number_seq="1.09"><attribute_group_obj>3000002003.09</attribute_group_obj>
<attribute_group_name>ADMAttributes</attribute_group_name>
<attribute_group_narrative>This group contains all attributes of ADM objects excepts those that can also be Widget Attributes. In that case, they are in the WidgetAttribute group.</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="178" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>DataSourceNames</attribute_label>
<attribute_group_obj>5.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Stores the ObjectName of the Data Object that sends data to this object. This would be set if the data-Source is an SBO or other Container with DataObjects.
See the SBOs addDataTarget for more details on how this is set.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>1004945563.09</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>5.7063</attribute_group_obj>
<attribute_group_name>Smart</attribute_group_name>
<attribute_group_narrative>Smart Object common attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="179" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>DataTarget</attribute_label>
<attribute_group_obj>5.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The DataTarget object handle, normally for pass-through support.
Because this can be a list, it should normally be changed using
&apos;modifyListProperty&apos;.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>55.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>5.7063</attribute_group_obj>
<attribute_group_name>Smart</attribute_group_name>
<attribute_group_narrative>Smart Object common attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="180" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>DataTargetEvents</attribute_label>
<attribute_group_obj>5.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>A comma-separated list of events to subscribe to.
Normally modifyListProperty should be used to ADD or REMOVE 
events from this list.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level>Class</constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>57.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>5.7063</attribute_group_obj>
<attribute_group_name>Smart</attribute_group_name>
<attribute_group_narrative>Smart Object common attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="181" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="03/12/2003" version_time="66447" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="32992.66" record_version_obj="32993.66" version_number_seq="1.09" secondary_key_value="DataValidationOperator" import_version_number_seq="1.09"><attribute_label>DataValidationOperator</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Specifies the operator used to validate the value against the DataValidationValue. Currently supported values are RANGE, BEGINS and MATCHES.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>32992.66</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="182" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="03/12/2003" version_time="66448" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="32994.66" record_version_obj="32995.66" version_number_seq="1.09" secondary_key_value="DataValidationValue" import_version_number_seq="1.09"><attribute_label>DataValidationValue</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Specifies valid value(s) for the field. The DataValidationOperator specifies 
the validation expression.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>32994.66</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="183" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>DataValue</attribute_label>
<attribute_group_obj>432.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Holds the value of the SmartDataField.</attribute_narrative>
<override_type>get,set</override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>551.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>432.7063</attribute_group_obj>
<attribute_group_name>Field</attribute_group_name>
<attribute_group_narrative>SmartField Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="184" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>DBAware</attribute_label>
<attribute_group_obj>5.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Flag indicating whether this object is dependent on being connected to a database or not, to allow some code to execute two different ways (for DataObjects, e.g.)</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>50.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>5.7063</attribute_group_obj>
<attribute_group_name>Smart</attribute_group_name>
<attribute_group_narrative>Smart Object common attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="185" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>DBNames</attribute_label>
<attribute_group_obj>154.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Comma-separated list of the database names associated with the query buffers. Used actively in all column functions to be able to resolve calls that are qualified differently than the design time setting. The mandatory use of the get function is to ensure that the client side data object calls the server if the value is not present, which only will be the case if the get function is called before initialization as this is one of the &apos;first-time&apos; attributes.  Qualify properly before init !</attribute_narrative>
<override_type>get</override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>513.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>154.7063</attribute_group_obj>
<attribute_group_name>Query</attribute_group_name>
<attribute_group_narrative>Query object attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="186" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>DCOLOR</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>4</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005099287.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="187" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>DeactivateTargetOnHide</attribute_label>
<attribute_group_obj>438.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>FALSE indicates that the hidden targets are deactivated on view of another target.
TRUE should be used to disable a toolbar when the object is hidden also when the object has only one target or to disable the toolbar when the current page is a page that does not have any target. FALSE (default) ensures that the targets always are active if only one link even if they are hidden and avoids the disabling in a paged container when switching pages.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>1779.66</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>438.7063</attribute_group_obj>
<attribute_group_name>Panel</attribute_group_name>
<attribute_group_narrative>SmartPanel attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="188" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>DEBLANK</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005099317.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="189" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>DEFAULT</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005099324.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="190" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>DefaultCharWidth</attribute_label>
<attribute_group_obj>608.7063</attribute_group_obj>
<data_type>5</data_type>
<attribute_narrative>Defalt width for character fields.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>632.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>608.7063</attribute_group_obj>
<attribute_group_name>Filter</attribute_group_name>
<attribute_group_narrative>SmartFilter attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="191" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>DefaultColumnData</attribute_label>
<attribute_group_obj>436.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Stores default column positions and sizes to support reset</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>261.009</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>436.7063</attribute_group_obj>
<attribute_group_name>Browser</attribute_group_name>
<attribute_group_narrative>SmartBrowser attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="192" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>DefaultEditorLines</attribute_label>
<attribute_group_obj>608.7063</attribute_group_obj>
<data_type>4</data_type>
<attribute_narrative>The default inner-lines for editor fields.
Editors are used for fields with word-index.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>636.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>608.7063</attribute_group_obj>
<attribute_group_name>Filter</attribute_group_name>
<attribute_group_narrative>SmartFilter attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="193" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>DefaultHeight</attribute_label>
<attribute_group_obj>608.7063</attribute_group_obj>
<data_type>5</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>634.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>608.7063</attribute_group_obj>
<attribute_group_name>Filter</attribute_group_name>
<attribute_group_narrative>SmartFilter attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="194" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>DefaultLayout</attribute_label>
<attribute_group_obj>7.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The default layout name for this object.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level>Class</constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>80.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>7.7063</attribute_group_obj>
<attribute_group_name>Visual</attribute_group_name>
<attribute_group_narrative>Visual Smartobject attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="195" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="03/12/2003" version_time="66448" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="33010.66" record_version_obj="33011.66" version_number_seq="1.09" secondary_key_value="DefaultValue" import_version_number_seq="1.09"><attribute_label>DefaultValue</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Specifies the default value for a new record. This can be any value that matches the field&apos;s data type as well as TODAY for date fields.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>33010.66</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="196" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>DefaultWidth</attribute_label>
<attribute_group_obj>608.7063</attribute_group_obj>
<data_type>5</data_type>
<attribute_narrative>Defualt width for fields that are non-char.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>630.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>608.7063</attribute_group_obj>
<attribute_group_name>Filter</attribute_group_name>
<attribute_group_narrative>SmartFilter attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="197" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>DefineAnyKeyTrigger</attribute_label>
<attribute_group_obj>434.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Set to true if a persistent trigger is to be defined on ANY-KEY.
Only used for the fill-in that are generated for the view-as browse 
option.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>604.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>434.7063</attribute_group_obj>
<attribute_group_name>Select</attribute_group_name>
<attribute_group_narrative>SmartSelect attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="198" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>DELIMITER</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005099335.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="199" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="03/07/2003" version_time="63470" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="36433.48" record_version_obj="36434.48" version_number_seq="1.09" secondary_key_value="DeployData" import_version_number_seq="1.09"><attribute_label>DeployData</attribute_label>
<attribute_group_obj>36427.48</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>If set to yes, then data in this table needs to be deployed.

Whether data has changed and needs to be deployed is identified by the existence of records in the gst_record_version table for this entity.

What data gets deployed and how it relates to other data is specified via setting up deployment datasets.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>36433.48</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="03/12/2003" version_time="66443" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="36427.48" record_version_obj="36428.48" version_number_seq="1.09" secondary_key_value="EntityAttributes" import_version_number_seq="1.09"><attribute_group_obj>36427.48</attribute_group_obj>
<attribute_group_name>EntityAttributes</attribute_group_name>
<attribute_group_narrative>This group contains attributes that are associated with entities. The attributes in this group correspond exactly to the field names in the GSC_ENTITY_MNEMONIC table, excpet that they have had the underscores removed. This convention is used so that it is possible to generically and quickly populate the attributes.</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="200" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>DescSubstitute</attribute_label>
<attribute_group_obj>1005095447.101</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The field substitution list for Dynamic Combos</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005111016.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_group_name>SdfAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Smart Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="201" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>DesignDataObject</attribute_label>
<attribute_group_obj>5.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The name of the design time SDO for objects that need SDO data but cannot be linked.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>52.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>5.7063</attribute_group_obj>
<attribute_group_name>Smart</attribute_group_name>
<attribute_group_narrative>Smart Object common attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="202" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>Destination</attribute_label>
<attribute_group_obj>509.49</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The Destination for the current message</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>912.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="09/04/2002" version_time="57055" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="509.49" record_version_obj="510.49" version_number_seq="2.49" secondary_key_value="MsgHandler" import_version_number_seq="2.49"><attribute_group_obj>509.49</attribute_group_obj>
<attribute_group_name>MsgHandler</attribute_group_name>
<attribute_group_narrative>Message Handler attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="203" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>DestinationList</attribute_label>
<attribute_group_obj>515.49</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The list of Destinations this B2B uses as a producer.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>841.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="09/04/2002" version_time="57075" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="515.49" record_version_obj="516.49" version_number_seq="2.49" secondary_key_value="B2B" import_version_number_seq="2.49"><attribute_group_obj>515.49</attribute_group_obj>
<attribute_group_name>B2B</attribute_group_name>
<attribute_group_narrative>SmartB2B attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="204" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>Destinations</attribute_label>
<attribute_group_obj>505.49</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Stores the Destinations (Topics or Queues) this consumer can 
receive messages from.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>874.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="09/04/2002" version_time="57079" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="505.49" record_version_obj="506.49" version_number_seq="3.49" secondary_key_value="Consumer" import_version_number_seq="3.49"><attribute_group_obj>505.49</attribute_group_obj>
<attribute_group_name>Consumer</attribute_group_name>
<attribute_group_narrative>SmartConsumer attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="205" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>DestroyStateless</attribute_label>
<attribute_group_obj>152.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Defines if the persistent SDO should be destroyed on stateless requests.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>1003183472</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>152.7063</attribute_group_obj>
<attribute_group_name>Data</attribute_group_name>
<attribute_group_narrative>SDO Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="206" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>DirectionList</attribute_label>
<attribute_group_obj>515.49</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The list of Directions this B2B uses</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>843.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="09/04/2002" version_time="57075" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="515.49" record_version_obj="516.49" version_number_seq="2.49" secondary_key_value="B2B" import_version_number_seq="2.49"><attribute_group_obj>515.49</attribute_group_obj>
<attribute_group_name>B2B</attribute_group_name>
<attribute_group_narrative>SmartB2B attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="207" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>DISABLE-AUTO-ZAP</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005099314.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="208" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>DisabledActions</attribute_label>
<attribute_group_obj>438.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>A comma separated list of disabled actions.
- The actions will be immediately disabled and subsequent calls 
to enableActions will not enable them again. This makes it 
possible to permanently disable actions independent of state 
changes.
- If you remove actions from the list they will be enabled the next
time enableActions is used on them.
- Use the modifyDisabledActions to add or remove actions.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>181</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>438.7063</attribute_group_obj>
<attribute_group_name>Panel</attribute_group_name>
<attribute_group_narrative>SmartPanel attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="209" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>DisabledAddModeTabs</attribute_label>
<attribute_group_obj>347.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>406.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>347.7063</attribute_group_obj>
<attribute_group_name>Container</attribute_group_name>
<attribute_group_narrative>Container Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="210" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="06/19/2002" version_time="44548" version_user="ross" deletion_flag="no" entity_mnemonic="rycat" key_field_value="1003183449" record_version_obj="12873.409" version_number_seq="1.409" secondary_key_value="DisableOnInit" import_version_number_seq="1.409"><attribute_label>DisableOnInit</attribute_label>
<attribute_group_obj>7.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Flag indicating whether the object should be disabled when it&apos;s first realized.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>1003183449</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>7.7063</attribute_group_obj>
<attribute_group_name>Visual</attribute_group_name>
<attribute_group_narrative>Visual Smartobject attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="211" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>DisableStates</attribute_label>
<attribute_group_obj>1003183341</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>1003202028</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="212" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>DisconnectAppServer</attribute_label>
<attribute_group_obj>152.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Should the persistent SDO disconnect the AppServer.  
This is only used for stateless WebSpeed SDO&apos;s that are never destroyed</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>1003183474</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>152.7063</attribute_group_obj>
<attribute_group_name>Data</attribute_group_name>
<attribute_group_narrative>SDO Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="213" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>DisplayDataType</attribute_label>
<attribute_group_obj>1005095447.101</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Datatype of Dynamic Lookup display field.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>1005089873.28</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_group_name>SdfAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Smart Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="214" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>DisplayedField</attribute_label>
<attribute_group_obj>1005095447.101</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>For Dynamic Lookups. The name of the field being displayed from the query. (Table.Field). For Dynamic Combo&apos;s a comma seperated list of table.field name of the fields to be displayed as description values in the combo-box.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>1005089864.28</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_group_name>SdfAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Smart Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="215" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>DisplayedFields</attribute_label>
<attribute_group_obj>9.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>A comma-separated list of the columns displayed by the visualization object.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>1003466914</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>9.7063</attribute_group_obj>
<attribute_group_name>DataVisual</attribute_group_name>
<attribute_group_narrative>Data visualization object attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="216" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>DisplayedTables</attribute_label>
<attribute_group_obj>9.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The list of SDO table names used by the visualization.
May be just &quot;RowObject&quot; or if the object was built against an SBO, will be the list of SDO ObjectNames whose fields are used.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level>Class</constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>126.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>9.7063</attribute_group_obj>
<attribute_group_name>DataVisual</attribute_group_name>
<attribute_group_narrative>Data visualization object attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="217" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>DisplayField</attribute_label>
<attribute_group_obj>432.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>This property determines whether the field is to be displayd
along with other fields in its Container.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>1005078597.09</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>432.7063</attribute_group_obj>
<attribute_group_name>Field</attribute_group_name>
<attribute_group_narrative>SmartField Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="218" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>DisplayFormat</attribute_label>
<attribute_group_obj>1005095447.101</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Format of Dynamic Lookup/Dynamic Combo display field. In the case of the Dynamic Combo, if more than one field is being displayed in the combo-box - the default value must always be CHARACTER</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>1005089872.28</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_group_name>SdfAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Smart Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="219" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>DisplayValue</attribute_label>
<attribute_group_obj>432.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Holds the saved screen/display value of the SmartDataField.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>553.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>432.7063</attribute_group_obj>
<attribute_group_name>Field</attribute_group_name>
<attribute_group_narrative>SmartField Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="220" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>DocTypeList</attribute_label>
<attribute_group_obj>515.49</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The list of Document Types this B2B uses.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>845.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="09/04/2002" version_time="57075" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="515.49" record_version_obj="516.49" version_number_seq="2.49" secondary_key_value="B2B" import_version_number_seq="2.49"><attribute_group_obj>515.49</attribute_group_obj>
<attribute_group_name>B2B</attribute_group_name>
<attribute_group_narrative>SmartB2B attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="221" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>DocumentElement</attribute_label>
<attribute_group_obj>511.49</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The Id of the root element</attribute_narrative>
<override_type>get</override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>yes</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>944.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="09/04/2002" version_time="57077" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="511.49" record_version_obj="512.49" version_number_seq="2.49" secondary_key_value="XML" import_version_number_seq="2.49"><attribute_group_obj>511.49</attribute_group_obj>
<attribute_group_name>XML</attribute_group_name>
<attribute_group_narrative>SmartXML attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="222" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>DocumentHandle</attribute_label>
<attribute_group_obj>511.49</attribute_group_obj>
<data_type>10</data_type>
<attribute_narrative>The handle of the current document.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>942.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="09/04/2002" version_time="57077" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="511.49" record_version_obj="512.49" version_number_seq="2.49" secondary_key_value="XML" import_version_number_seq="2.49"><attribute_group_obj>511.49</attribute_group_obj>
<attribute_group_name>XML</attribute_group_name>
<attribute_group_narrative>SmartXML attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="223" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>Domain</attribute_label>
<attribute_group_obj>731.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The domain for messages being sent.
Once a session has been started, the messaging Domain cannot change.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>900.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>731.7063</attribute_group_obj>
<attribute_group_name>Messaging</attribute_group_name>
<attribute_group_narrative>Messaging SmartObject attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="224" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>DOWN</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Frame attribute to indicate a down frame</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>14815.409</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="225" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>DRAG-ENABLED</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005099337.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="226" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>DROP-TARGET</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005099307.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="227" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>DTDPublicId</attribute_label>
<attribute_group_obj>511.49</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The Public Id of the next document that is being created.
This property is stored until a document is produced. 
It will then be used as the DTD publicId in the call to the 
nitialize-document-type method. This method MUST run as soon 
as the document is created. 
The get version of this property will return the adm property when DocumentInitialized is false, but otherwise read from the actual document PUBLIC-ID.</attribute_narrative>
<override_type>get,set</override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>946.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="09/04/2002" version_time="57077" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="511.49" record_version_obj="512.49" version_number_seq="2.49" secondary_key_value="XML" import_version_number_seq="2.49"><attribute_group_obj>511.49</attribute_group_obj>
<attribute_group_name>XML</attribute_group_name>
<attribute_group_narrative>SmartXML attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="228" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>DTDPublicIdList</attribute_label>
<attribute_group_obj>515.49</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Stores a CHR(1) separated list of DTD PublicIds for producer. 
If this or DTDSystemId is defined, a DTD reference will be produced instead of an XML namespace.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>847.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="09/04/2002" version_time="57075" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="515.49" record_version_obj="516.49" version_number_seq="2.49" secondary_key_value="B2B" import_version_number_seq="2.49"><attribute_group_obj>515.49</attribute_group_obj>
<attribute_group_name>B2B</attribute_group_name>
<attribute_group_narrative>SmartB2B attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="229" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>DTDSystemId</attribute_label>
<attribute_group_obj>511.49</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The System Id of the next document that is being created.
This property is stored until a document is produced. 
It will then be used as the DTD SystemId in the call to the 
initialize-document-type method. This method MUST run as soon as the document is created. 
The get version of this property will return the adm property when DocumentInitialized is false, but otherwise read from the actual document System-ID.</attribute_narrative>
<override_type>get,set</override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>948.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="09/04/2002" version_time="57077" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="511.49" record_version_obj="512.49" version_number_seq="2.49" secondary_key_value="XML" import_version_number_seq="2.49"><attribute_group_obj>511.49</attribute_group_obj>
<attribute_group_name>XML</attribute_group_name>
<attribute_group_narrative>SmartXML attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="230" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>DTDSystemIdList</attribute_label>
<attribute_group_obj>515.49</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Stores a CHR(1) separated list of DTD SystemIds for producer. 
If this or DTDPublicId is defined, a DTD reference will be produced instead of an XML namespace.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>849.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="09/04/2002" version_time="57075" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="515.49" record_version_obj="516.49" version_number_seq="2.49" secondary_key_value="B2B" import_version_number_seq="2.49"><attribute_group_obj>515.49</attribute_group_obj>
<attribute_group_name>B2B</attribute_group_name>
<attribute_group_narrative>SmartB2B attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="231" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="02/05/2003" version_time="56607" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="40001.7063" record_version_obj="40002.7063" version_number_seq="1.09" secondary_key_value="DynamicData" import_version_number_seq="1.09"><attribute_label>DynamicData</attribute_label>
<attribute_group_obj>152.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Indicates whether the data management temp-tables (RowObject, RowObjUpd) are static or dynamic.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>40001.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>152.7063</attribute_group_obj>
<attribute_group_name>Data</attribute_group_name>
<attribute_group_narrative>SDO Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="232" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>DynamicObject</attribute_label>
<attribute_group_obj>1003183341</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Whether an object ins a dynamic object..</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005109093.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="233" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>DynamicSDOProcedure</attribute_label>
<attribute_group_obj>347.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The name of the dynamic SDO procedure, &apos;adm2/dyndata.w&apos;
by default.  Can be modified if the dynamic SDO is customized.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>373.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>347.7063</attribute_group_obj>
<attribute_group_name>Container</attribute_group_name>
<attribute_group_narrative>Container Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="234" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>EDGE-CHARS</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>4</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005099326.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="235" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>EDGE-PIXELS</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>4</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005099327.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="236" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>EdgePixels</attribute_label>
<attribute_group_obj>430.7063</attribute_group_obj>
<data_type>4</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>1003498439</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>430.7063</attribute_group_obj>
<attribute_group_name>Toolbar</attribute_group_name>
<attribute_group_narrative>SmartToolbar attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="237" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>EDIT-CAN-UNDO</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005099305.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="238" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>Editable</attribute_label>
<attribute_group_obj>9.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Indicates whether this object can be edited (add/copy/save/update).
Used by the toolbar to indicate whether actions like add/copy etc. should be enabled.</attribute_narrative>
<override_type>GET</override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>94.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>9.7063</attribute_group_obj>
<attribute_group_name>DataVisual</attribute_group_name>
<attribute_group_narrative>Data visualization object attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="239" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ENABLED</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>WidgetAttributes Enabled</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005078422.09</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="240" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>EnabledField</attribute_label>
<attribute_group_obj>3000002003.09</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Whether the fields should be enabled</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>1005078596.09</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="02/10/2003" version_time="59461" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="3000002003.09" record_version_obj="3000002004.09" version_number_seq="1.09" secondary_key_value="ADMAttributes" import_version_number_seq="1.09"><attribute_group_obj>3000002003.09</attribute_group_obj>
<attribute_group_name>ADMAttributes</attribute_group_name>
<attribute_group_narrative>This group contains all attributes of ADM objects excepts those that can also be Widget Attributes. In that case, they are in the WidgetAttribute group.</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="241" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>EnabledFields</attribute_label>
<attribute_group_obj>9.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>A comma-separated list of the enabled fields (name) in this object which map to fields in the SmartDataObject.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>1003466921</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>9.7063</attribute_group_obj>
<attribute_group_name>DataVisual</attribute_group_name>
<attribute_group_narrative>Data visualization object attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="242" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>EnabledHandles</attribute_label>
<attribute_group_obj>9.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>A comma-separared list of the handles of the enabled fields in the visualization object.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>102.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>9.7063</attribute_group_obj>
<attribute_group_name>DataVisual</attribute_group_name>
<attribute_group_narrative>Data visualization object attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="243" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>EnabledObjFlds</attribute_label>
<attribute_group_obj>7.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>A comma-separated list of the field names of widgets enabled in this object NOT associated with data fields.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>84.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>7.7063</attribute_group_obj>
<attribute_group_name>Visual</attribute_group_name>
<attribute_group_narrative>Visual Smartobject attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="244" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="11/05/2002" version_time="42632" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="9071.66" record_version_obj="9072.66" version_number_seq="1.09" secondary_key_value="EnabledObjFldsToDisable" import_version_number_seq="1.09"><attribute_label>EnabledObjFldsToDisable</attribute_label>
<attribute_group_obj>9.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>This property decides whether non-db objects should be disabled/enabled 
when the fields are disabled. The supported values are:   
1. (All) - All EnabledObjects should be disabled in view mode
2. (None)  - All EnabledObjects should remain enabled when the                fields are disabled.  
3. Comma separated list of object names to disable/enable. 

? as repository value tells the get function to return default;  (All) for normal viewers and (none) for viewers with no db fields.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>9071.66</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>9.7063</attribute_group_obj>
<attribute_group_name>DataVisual</attribute_group_name>
<attribute_group_narrative>Data visualization object attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="245" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>EnabledObjHdls</attribute_label>
<attribute_group_obj>7.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>A comma-separated list of the handles of widgets enabled in this object NOT associated with data fields</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>82.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>7.7063</attribute_group_obj>
<attribute_group_name>Visual</attribute_group_name>
<attribute_group_narrative>Visual Smartobject attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="246" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>EnableField</attribute_label>
<attribute_group_obj>432.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>TRUE if the SmartDataField is to be enabled for user input along with other fields in its Container, otherwise false.
This instance property is initialized by the AppBuilder in adm-create-objects.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>1005101029.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>432.7063</attribute_group_obj>
<attribute_group_name>Field</attribute_group_name>
<attribute_group_narrative>SmartField Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="247" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ENableStates</attribute_label>
<attribute_group_obj>1003183341</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1003202026</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="248" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="03/07/2003" version_time="63470" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="36486.48" record_version_obj="36487.48" version_number_seq="1.09" secondary_key_value="EntityDbname" import_version_number_seq="1.09"><attribute_label>EntityDbname</attribute_label>
<attribute_group_obj>36427.48</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>This is the logical database name in which this table resides.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>36486.48</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="03/12/2003" version_time="66443" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="36427.48" record_version_obj="36428.48" version_number_seq="1.09" secondary_key_value="EntityAttributes" import_version_number_seq="1.09"><attribute_group_obj>36427.48</attribute_group_obj>
<attribute_group_name>EntityAttributes</attribute_group_name>
<attribute_group_narrative>This group contains attributes that are associated with entities. The attributes in this group correspond exactly to the field names in the GSC_ENTITY_MNEMONIC table, excpet that they have had the underscores removed. This convention is used so that it is possible to generically and quickly populate the attributes.</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="249" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="03/07/2003" version_time="63470" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="36456.48" record_version_obj="36457.48" version_number_seq="1.09" secondary_key_value="EntityDescriptionField" import_version_number_seq="1.09"><attribute_label>EntityDescriptionField</attribute_label>
<attribute_group_obj>36427.48</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The name of the description field for this entity. Armed with this information and the object number, we can dynamically return the description of any record in any table.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>36456.48</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="03/12/2003" version_time="66443" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="36427.48" record_version_obj="36428.48" version_number_seq="1.09" secondary_key_value="EntityAttributes" import_version_number_seq="1.09"><attribute_group_obj>36427.48</attribute_group_obj>
<attribute_group_name>EntityAttributes</attribute_group_name>
<attribute_group_narrative>This group contains attributes that are associated with entities. The attributes in this group correspond exactly to the field names in the GSC_ENTITY_MNEMONIC table, excpet that they have had the underscores removed. This convention is used so that it is possible to generically and quickly populate the attributes.</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="250" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="03/07/2003" version_time="63470" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="36435.48" record_version_obj="36436.48" version_number_seq="1.09" secondary_key_value="EntityDescriptionProcedure" import_version_number_seq="1.09"><attribute_label>EntityDescriptionProcedure</attribute_label>
<attribute_group_obj>36427.48</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The name of a procedure to run in order to work out the description of the entity. This is only required in the event that the entity description spans multiple fields (potentially from related entities). If this field is specified, it will override the entity description field.

A relative path to the procedure must be included. The procedure written must take the object number as an input parameter, and output a single character string containing the object description.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>36435.48</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="03/12/2003" version_time="66443" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="36427.48" record_version_obj="36428.48" version_number_seq="1.09" secondary_key_value="EntityAttributes" import_version_number_seq="1.09"><attribute_group_obj>36427.48</attribute_group_obj>
<attribute_group_name>EntityAttributes</attribute_group_name>
<attribute_group_narrative>This group contains attributes that are associated with entities. The attributes in this group correspond exactly to the field names in the GSC_ENTITY_MNEMONIC table, excpet that they have had the underscores removed. This convention is used so that it is possible to generically and quickly populate the attributes.</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="251" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>EntityFields</attribute_label>
<attribute_group_obj>154.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Comma separated list of fields that is to be read from the Entity Mnemonic table at run time. This list is currently set at start up based on CAN-FIND of related tables. Currently supported values are HasComment, HasAudit and AutoComment.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>549.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>154.7063</attribute_group_obj>
<attribute_group_name>Query</attribute_group_name>
<attribute_group_narrative>Query object attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="252" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="03/07/2003" version_time="63470" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="36437.48" record_version_obj="36438.48" version_number_seq="1.09" secondary_key_value="EntityKeyField" import_version_number_seq="1.09"><attribute_label>EntityKeyField</attribute_label>
<attribute_group_obj>36427.48</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The name of the unique key field or fields for this entity. This should be a field or fields other than the object field that could be used to uniquely find information in this entity. This would often be used in lookups, etc. so the code and description can be displayed to the user.
If more than one field is necesarry to uniquely identify a record, the field names will be stored in a comma seperated list</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>36437.48</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="03/12/2003" version_time="66443" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="36427.48" record_version_obj="36428.48" version_number_seq="1.09" secondary_key_value="EntityAttributes" import_version_number_seq="1.09"><attribute_group_obj>36427.48</attribute_group_obj>
<attribute_group_name>EntityAttributes</attribute_group_name>
<attribute_group_narrative>This group contains attributes that are associated with entities. The attributes in this group correspond exactly to the field names in the GSC_ENTITY_MNEMONIC table, excpet that they have had the underscores removed. This convention is used so that it is possible to generically and quickly populate the attributes.</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="253" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="03/12/2003" version_time="66442" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="48711.48" record_version_obj="48712.48" version_number_seq="1.09" secondary_key_value="EntityMnemonic" import_version_number_seq="1.09"><attribute_label>EntityMnemonic</attribute_label>
<attribute_group_obj>36427.48</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The code allocated to every table in the database that uniquely identifies the database table. This code is used when generically joining to tables, as the basis for naming conventions (e.g. a prefix to all objects that maintain this table), etc. 
This code is usually stored in the dump name of the table.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>48711.48</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="03/12/2003" version_time="66443" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="36427.48" record_version_obj="36428.48" version_number_seq="1.09" secondary_key_value="EntityAttributes" import_version_number_seq="1.09"><attribute_group_obj>36427.48</attribute_group_obj>
<attribute_group_name>EntityAttributes</attribute_group_name>
<attribute_group_narrative>This group contains attributes that are associated with entities. The attributes in this group correspond exactly to the field names in the GSC_ENTITY_MNEMONIC table, excpet that they have had the underscores removed. This convention is used so that it is possible to generically and quickly populate the attributes.</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="254" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="03/07/2003" version_time="63470" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="36482.48" record_version_obj="36483.48" version_number_seq="1.09" secondary_key_value="EntityMnemonicDescription" import_version_number_seq="1.09"><attribute_label>EntityMnemonicDescription</attribute_label>
<attribute_group_obj>36427.48</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>This field should store the actual table name in full, e.g. gsm_user. The fact that this field contains the table name is relied upon within the framework.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>36482.48</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="03/12/2003" version_time="66443" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="36427.48" record_version_obj="36428.48" version_number_seq="1.09" secondary_key_value="EntityAttributes" import_version_number_seq="1.09"><attribute_group_obj>36427.48</attribute_group_obj>
<attribute_group_name>EntityAttributes</attribute_group_name>
<attribute_group_narrative>This group contains attributes that are associated with entities. The attributes in this group correspond exactly to the field names in the GSC_ENTITY_MNEMONIC table, excpet that they have had the underscores removed. This convention is used so that it is possible to generically and quickly populate the attributes.</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="255" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="03/07/2003" version_time="63470" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="36458.48" record_version_obj="36459.48" version_number_seq="1.09" secondary_key_value="EntityMnemonicLabelPrefix" import_version_number_seq="1.09"><attribute_label>EntityMnemonicLabelPrefix</attribute_label>
<attribute_group_obj>36427.48</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>An optional prefix to selectively replace the first word of screen labels for fields in the associated table. This will primarily be used for tables in the framework to provide more meaningful labels.

For example a table gsm_region in a specfic application may be used for suburbs and have a label prefix of &quot;suburb&quot; rather than &quot;region&quot;.

The label prefix will actually replace the first word in the field label defined on the database.

Where the table has more than one meaning, e.g. a gsm_</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>36458.48</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="03/12/2003" version_time="66443" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="36427.48" record_version_obj="36428.48" version_number_seq="1.09" secondary_key_value="EntityAttributes" import_version_number_seq="1.09"><attribute_group_obj>36427.48</attribute_group_obj>
<attribute_group_name>EntityAttributes</attribute_group_name>
<attribute_group_narrative>This group contains attributes that are associated with entities. The attributes in this group correspond exactly to the field names in the GSC_ENTITY_MNEMONIC table, excpet that they have had the underscores removed. This convention is used so that it is possible to generically and quickly populate the attributes.</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="256" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="03/07/2003" version_time="63470" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="36484.48" record_version_obj="36485.48" version_number_seq="1.09" secondary_key_value="EntityMnemonicShortDesc" import_version_number_seq="1.09"><attribute_label>EntityMnemonicShortDesc</attribute_label>
<attribute_group_obj>36427.48</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>A short reference for the table used to lookup the table - this is a free text description</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>36484.48</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="03/12/2003" version_time="66443" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="36427.48" record_version_obj="36428.48" version_number_seq="1.09" secondary_key_value="EntityAttributes" import_version_number_seq="1.09"><attribute_group_obj>36427.48</attribute_group_obj>
<attribute_group_name>EntityAttributes</attribute_group_name>
<attribute_group_narrative>This group contains attributes that are associated with entities. The attributes in this group correspond exactly to the field names in the GSC_ENTITY_MNEMONIC table, excpet that they have had the underscores removed. This convention is used so that it is possible to generically and quickly populate the attributes.</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="257" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="03/07/2003" version_time="63470" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="36462.48" record_version_obj="36463.48" version_number_seq="1.09" secondary_key_value="EntityObjectField" import_version_number_seq="1.09"><attribute_label>EntityObjectField</attribute_label>
<attribute_group_obj>36427.48</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The name of the unique object field for this entity used to join to other tables. Usually this field is the same as the tablename without the 4 character prefix and ends in _obj. The datatype of this field should be a decimal with at least decimals 9. 

If left blank, then the above assumption will be used to find the object field where required.
</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>36462.48</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="03/12/2003" version_time="66443" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="36427.48" record_version_obj="36428.48" version_number_seq="1.09" secondary_key_value="EntityAttributes" import_version_number_seq="1.09"><attribute_group_obj>36427.48</attribute_group_obj>
<attribute_group_name>EntityAttributes</attribute_group_name>
<attribute_group_narrative>This group contains attributes that are associated with entities. The attributes in this group correspond exactly to the field names in the GSC_ENTITY_MNEMONIC table, excpet that they have had the underscores removed. This convention is used so that it is possible to generically and quickly populate the attributes.</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="258" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ErrorConsumer</attribute_label>
<attribute_group_obj>731.7063</attribute_group_obj>
<data_type>10</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>876.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>731.7063</attribute_group_obj>
<attribute_group_name>Messaging</attribute_group_name>
<attribute_group_narrative>Messaging SmartObject attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="259" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ExitBrowseOnAction</attribute_label>
<attribute_group_obj>434.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>TRUE if the selection of a value in the browse also should  Exit the browse.
The selection of a value is triggered by DEFAULT-ACTION 
 (RETURN or double-click )</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>598.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>434.7063</attribute_group_obj>
<attribute_group_name>Select</attribute_group_name>
<attribute_group_narrative>SmartSelect attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="260" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="06/19/2002" version_time="44548" version_user="ross" deletion_flag="no" entity_mnemonic="rycat" key_field_value="13479.409" record_version_obj="13480.409" version_number_seq="2.409" secondary_key_value="EXPAND" import_version_number_seq="2.409"><attribute_label>EXPAND</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>When TRUE, horizontal Radio-Set expand labels to evenly space the buttons.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>13479.409</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="261" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ExpandOnAdd</attribute_label>
<attribute_group_obj>1005097792.101</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>If Yes, nodes will always be expanded when added to node</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>3507.66</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005097792.101</attribute_group_obj>
<attribute_group_name>TreeView</attribute_group_name>
<attribute_group_narrative>TreeView Group</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="262" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ExternalRefList</attribute_label>
<attribute_group_obj>513.49</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Stores the External References this router uses to determine
how external target namespaces map to internal XML mapping
schemas</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>936.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="09/04/2002" version_time="57056" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="513.49" record_version_obj="514.49" version_number_seq="2.49" secondary_key_value="Router" import_version_number_seq="2.49"><attribute_group_obj>513.49</attribute_group_obj>
<attribute_group_name>Router</attribute_group_name>
<attribute_group_narrative>SmartRouter attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="263" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>FetchAutoComment</attribute_label>
<attribute_group_obj>154.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>TRUE if auto comments flag should be retrieved with the data.
This is used in transferRows and transferDbRow .
These comments will be automatically displayed by visual objects and will be set to true by the visual object&apos;s LinkStateHandler if the property value is unknown.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>547.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>154.7063</attribute_group_obj>
<attribute_group_name>Query</attribute_group_name>
<attribute_group_narrative>Query object attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="264" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>FetchHasAudit</attribute_label>
<attribute_group_obj>154.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>TRUE if Audit exists flag should be retrieved with the data.
This is used in transferRows and transferDbRow .</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>545.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>154.7063</attribute_group_obj>
<attribute_group_name>Query</attribute_group_name>
<attribute_group_narrative>Query object attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="265" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>FetchHasComment</attribute_label>
<attribute_group_obj>154.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>TRUE if &apos;comments exists&apos; flag should be retrieved with the data.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>1130.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>154.7063</attribute_group_obj>
<attribute_group_name>Query</attribute_group_name>
<attribute_group_narrative>Query object attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="266" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>FetchOnOpen</attribute_label>
<attribute_group_obj>154.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>- A blank value means don&apos;t fetch on open, any other value is just being run as fetch + &lt;property value&gt;
- Unknown value indicates default which is blank on &apos;server&apos; and&apos;first&apos; otherwise.
- This is a replacement of the return that used to be in data.p 
fetchFirst. The blank gives the same effect as it prevents openQuery from calling fetchFirst.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>541.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>154.7063</attribute_group_obj>
<attribute_group_name>Query</attribute_group_name>
<attribute_group_narrative>Query object attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="267" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>FetchOnReposToEnd</attribute_label>
<attribute_group_obj>436.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>TRUE if the browse should fetch more data from the server to 
fill the batch when repositioing to the end of a batch.
This gives the correct visual appearance, but will require an 
additional request to the server.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>503.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>436.7063</attribute_group_obj>
<attribute_group_name>Browser</attribute_group_name>
<attribute_group_narrative>SmartBrowser attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="268" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>FGCOLOR</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>4</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005099283.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="269" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>FieldColumn</attribute_label>
<attribute_group_obj>608.7063</attribute_group_obj>
<data_type>5</data_type>
<attribute_narrative>Stores the Column position of the fields</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>638.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>608.7063</attribute_group_obj>
<attribute_group_name>Filter</attribute_group_name>
<attribute_group_narrative>SmartFilter attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="270" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>FieldEnabled</attribute_label>
<attribute_group_obj>432.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>TRUE if the SmartDataField is enabled for user input, otherwise false.
This property is set from user-defined procedures enableField and disableField.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>557.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>432.7063</attribute_group_obj>
<attribute_group_name>Field</attribute_group_name>
<attribute_group_narrative>SmartField Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="271" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>FieldFormats</attribute_label>
<attribute_group_obj>608.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Stores the internal list of overridden fields and formats</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>644.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>608.7063</attribute_group_obj>
<attribute_group_name>Filter</attribute_group_name>
<attribute_group_narrative>SmartFilter attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="272" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>FieldHandles</attribute_label>
<attribute_group_obj>9.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>A comma-separated list of Data Field handles in the visualization object</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>106.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>9.7063</attribute_group_obj>
<attribute_group_name>DataVisual</attribute_group_name>
<attribute_group_narrative>Data visualization object attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="273" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>FieldHelpIds</attribute_label>
<attribute_group_obj>608.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Stores the internal list of fields and helpids.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>652.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>608.7063</attribute_group_obj>
<attribute_group_name>Filter</attribute_group_name>
<attribute_group_narrative>SmartFilter attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="274" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>FieldLabel</attribute_label>
<attribute_group_obj>1005095447.101</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Label for the Dynamic Lookup/Dynamic Combo field on the viewer.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>1005089868.28</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_group_name>SdfAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Smart Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="275" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>FieldLabels</attribute_label>
<attribute_group_obj>608.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Store the internal list of overridden fields and labels.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>648.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>608.7063</attribute_group_obj>
<attribute_group_name>Filter</attribute_group_name>
<attribute_group_narrative>SmartFilter attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="276" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>FieldName</attribute_label>
<attribute_group_obj>432.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The name of the associated SDO field this SmartDataField maps to. This is usually &apos;set&apos; from the containing SmartDataViewer.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>1005078709.09</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>432.7063</attribute_group_obj>
<attribute_group_name>Field</attribute_group_name>
<attribute_group_narrative>SmartField Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="277" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="03/07/2003" version_time="63471" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="36464.48" record_version_obj="36465.48" version_number_seq="1.09" secondary_key_value="FieldNameSeparator" import_version_number_seq="1.09"><attribute_label>FieldNameSeparator</attribute_label>
<attribute_group_obj>36427.48</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The basis of identifying what is used to break up field names into words.
The framework standard is to separate fields with an underscore so this field would be set to &quot;_&quot;.
Some database designs separate fields by uppercasing the first character of each word and in this case the value of this field would be &quot;upper&quot;.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>36464.48</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="03/12/2003" version_time="66443" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="36427.48" record_version_obj="36428.48" version_number_seq="1.09" secondary_key_value="EntityAttributes" import_version_number_seq="1.09"><attribute_group_obj>36427.48</attribute_group_obj>
<attribute_group_name>EntityAttributes</attribute_group_name>
<attribute_group_narrative>This group contains attributes that are associated with entities. The attributes in this group correspond exactly to the field names in the GSC_ENTITY_MNEMONIC table, excpet that they have had the underscores removed. This convention is used so that it is possible to generically and quickly populate the attributes.</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="278" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="03/17/2003" version_time="33828" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="34784.66" record_version_obj="34785.66" version_number_seq="1.09" secondary_key_value="FieldPopupMapping" import_version_number_seq="1.09"><attribute_label>FieldPopupMapping</attribute_label>
<attribute_group_obj>1005095446.101</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Stores the mapping of field and object handles and their dynamically created popup handle. The list can be used directly, but is also used by functions that take the field name as input.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>34784.66</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005095446.101</attribute_group_obj>
<attribute_group_name>ViewerAttributes</attribute_group_name>
<attribute_group_narrative>These are attributes which belong to a Dynamic Viewer</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="279" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="10/01/2002" version_time="66020" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="86.7063" record_version_obj="3000038028.09" version_number_seq="1.09" secondary_key_value="FieldSecurity" import_version_number_seq="1.09"><attribute_label>FieldSecurity</attribute_label>
<attribute_group_obj>7.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>For viewers, this attribute contains a comma-separated list of the security type corresponding to AllFieldHandles. For browsers the list corresponds to DisplayedFields.
&lt;security type&gt;,&lt;security type&gt;...

</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>86.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>7.7063</attribute_group_obj>
<attribute_group_name>Visual</attribute_group_name>
<attribute_group_narrative>Visual Smartobject attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="280" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>FieldsEnabled</attribute_label>
<attribute_group_obj>9.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Indicates whether the fields in this visualization object are enabled or not.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>92.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>9.7063</attribute_group_obj>
<attribute_group_name>DataVisual</attribute_group_name>
<attribute_group_narrative>Data visualization object attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="281" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>FieldSeparatorPxl</attribute_label>
<attribute_group_obj>608.7063</attribute_group_obj>
<data_type>4</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>642.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>608.7063</attribute_group_obj>
<attribute_group_name>Filter</attribute_group_name>
<attribute_group_narrative>SmartFilter attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="282" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>FieldSpacingPxl</attribute_label>
<attribute_group_obj>608.7063</attribute_group_obj>
<data_type>4</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>640.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>608.7063</attribute_group_obj>
<attribute_group_name>Filter</attribute_group_name>
<attribute_group_narrative>SmartFilter attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="283" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>FieldTooltip</attribute_label>
<attribute_group_obj>1005095447.101</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Tooltip for displayed Dynamic Lookup/Dynamic Combo field.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005089869.28</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_group_name>SdfAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Smart Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="284" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>FieldTooltips</attribute_label>
<attribute_group_obj>608.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Stores the internal list of fields and TOOLTIPs</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>650.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>608.7063</attribute_group_obj>
<attribute_group_name>Filter</attribute_group_name>
<attribute_group_narrative>SmartFilter attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="285" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>FieldWidths</attribute_label>
<attribute_group_obj>608.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Stores the internal list of overridden field widths.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>646.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>608.7063</attribute_group_obj>
<attribute_group_name>Filter</attribute_group_name>
<attribute_group_narrative>SmartFilter attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="286" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>FillBatchOnRepos</attribute_label>
<attribute_group_obj>152.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Sets the flag on or off which indicates whether &apos;fetchRowIdent&apos;
will fetch enough rows to fill a batch when repositioning to (or near) the end of a dataset where an entire batch wouldn&apos;t be retrieved.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>213.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>152.7063</attribute_group_obj>
<attribute_group_name>Data</attribute_group_name>
<attribute_group_narrative>SDO Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="287" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>FILLED</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005099325.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="288" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>FilterActive</attribute_label>
<attribute_group_obj>428.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Flag to indicate that filter is active.
&apos;getFilterActive&apos; also checks the  caller&apos;s DataTargetNames.</attribute_narrative>
<override_type>get</override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>462.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>428.7063</attribute_group_obj>
<attribute_group_name>DataContainer</attribute_group_name>
<attribute_group_narrative>SmartBusinessObject and other Data Container attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="289" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>FilterAvailable</attribute_label>
<attribute_group_obj>428.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Flag to indicate that filter is available.</attribute_narrative>
<override_type>set</override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>460.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>428.7063</attribute_group_obj>
<attribute_group_name>DataContainer</attribute_group_name>
<attribute_group_narrative>SmartBusinessObject and other Data Container attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="290" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>FilterSource</attribute_label>
<attribute_group_obj>347.7063</attribute_group_obj>
<data_type>10</data_type>
<attribute_narrative>The handle of the Filter Source for Pass-through support.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>365.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>347.7063</attribute_group_obj>
<attribute_group_name>Container</attribute_group_name>
<attribute_group_narrative>Container Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="291" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>FilterTarget</attribute_label>
<attribute_group_obj>608.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The linked filter object handle. Currently supports only one.
Use columnFilterTarget for a column.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>610.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>608.7063</attribute_group_obj>
<attribute_group_name>Filter</attribute_group_name>
<attribute_group_narrative>SmartFilter attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="292" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>FilterTargetEvents</attribute_label>
<attribute_group_obj>608.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>A comma-separated list of the events this object needs to subscribe to in its FilterTarget.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level>Class</constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>612.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>608.7063</attribute_group_obj>
<attribute_group_name>Filter</attribute_group_name>
<attribute_group_narrative>SmartFilter attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="293" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>FilterType</attribute_label>
<attribute_group_obj>436.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>526.1713</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>436.7063</attribute_group_obj>
<attribute_group_name>Browser</attribute_group_name>
<attribute_group_narrative>SmartBrowser attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="294" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>FilterWindow</attribute_label>
<attribute_group_obj>428.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The name of the filter container, if any.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>466.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>428.7063</attribute_group_obj>
<attribute_group_name>DataContainer</attribute_group_name>
<attribute_group_narrative>SmartBusinessObject and other Data Container attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="295" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>FirstResultRow</attribute_label>
<attribute_group_obj>152.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Unknown if the first row has not been fetched.  Otherwise &apos;1&apos; concatenated with the rowid, if it has been fetched.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>192.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>152.7063</attribute_group_obj>
<attribute_group_name>Data</attribute_group_name>
<attribute_group_narrative>SDO Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="296" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>FirstRowNum</attribute_label>
<attribute_group_obj>152.7063</attribute_group_obj>
<data_type>4</data_type>
<attribute_narrative>The temp-table row number of the first row</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>164.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>152.7063</attribute_group_obj>
<attribute_group_name>Data</attribute_group_name>
<attribute_group_narrative>SDO Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="297" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>FIT-LAST-COLUMN</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Browse will fit last column to exactly fit in the browse.  This will result in the last field narrowing or expanding to fit.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>14641.409</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="298" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>FlagValue</attribute_label>
<attribute_group_obj>1005095447.101</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Dynamic Combo. This field contains the default optional combo flag value for the &lt;All&gt; and &lt;None&gt; options. This allows the user to override the default values like . or 0.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005111018.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_group_name>SdfAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Smart Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="299" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>FLAT-BUTTON</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005099323.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="300" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>FlatButtons</attribute_label>
<attribute_group_obj>430.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>1003498425</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>430.7063</attribute_group_obj>
<attribute_group_name>Toolbar</attribute_group_name>
<attribute_group_narrative>SmartToolbar attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="301" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>FolderFont</attribute_label>
<attribute_group_obj>3000002003.09</attribute_group_obj>
<data_type>4</data_type>
<attribute_narrative>Font for tabs</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>3483.66</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="02/10/2003" version_time="59461" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="3000002003.09" record_version_obj="3000002004.09" version_number_seq="1.09" secondary_key_value="ADMAttributes" import_version_number_seq="1.09"><attribute_group_obj>3000002003.09</attribute_group_obj>
<attribute_group_name>ADMAttributes</attribute_group_name>
<attribute_group_narrative>This group contains all attributes of ADM objects excepts those that can also be Widget Attributes. In that case, they are in the WidgetAttribute group.</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="302" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>FolderLabels</attribute_label>
<attribute_group_obj>3000002003.09</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>This attribute is used to store the FolderLabels when construct</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1000000276.48</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="02/10/2003" version_time="59461" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="3000002003.09" record_version_obj="3000002004.09" version_number_seq="1.09" secondary_key_value="ADMAttributes" import_version_number_seq="1.09"><attribute_group_obj>3000002003.09</attribute_group_obj>
<attribute_group_name>ADMAttributes</attribute_group_name>
<attribute_group_narrative>This group contains all attributes of ADM objects excepts those that can also be Widget Attributes. In that case, they are in the WidgetAttribute group.</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="303" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>FolderMenu</attribute_label>
<attribute_group_obj>3000002003.09</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>SmartPak Folder</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>3495.66</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="02/10/2003" version_time="59461" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="3000002003.09" record_version_obj="3000002004.09" version_number_seq="1.09" secondary_key_value="ADMAttributes" import_version_number_seq="1.09"><attribute_group_obj>3000002003.09</attribute_group_obj>
<attribute_group_name>ADMAttributes</attribute_group_name>
<attribute_group_narrative>This group contains all attributes of ADM objects excepts those that can also be Widget Attributes. In that case, they are in the WidgetAttribute group.</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="304" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>FolderTabHeight</attribute_label>
<attribute_group_obj>3000002003.09</attribute_group_obj>
<data_type>5</data_type>
<attribute_narrative>Height for tabs</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>3485.66</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="02/10/2003" version_time="59461" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="3000002003.09" record_version_obj="3000002004.09" version_number_seq="1.09" secondary_key_value="ADMAttributes" import_version_number_seq="1.09"><attribute_group_obj>3000002003.09</attribute_group_obj>
<attribute_group_name>ADMAttributes</attribute_group_name>
<attribute_group_narrative>This group contains all attributes of ADM objects excepts those that can also be Widget Attributes. In that case, they are in the WidgetAttribute group.</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="305" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>FolderTabType</attribute_label>
<attribute_group_obj>1003183341</attribute_group_obj>
<data_type>4</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>1003202016</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="306" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>FolderTabWidth</attribute_label>
<attribute_group_obj>3000002003.09</attribute_group_obj>
<data_type>5</data_type>
<attribute_narrative>Optional width for tabs</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>3484.66</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="02/10/2003" version_time="59461" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="3000002003.09" record_version_obj="3000002004.09" version_number_seq="1.09" secondary_key_value="ADMAttributes" import_version_number_seq="1.09"><attribute_group_obj>3000002003.09</attribute_group_obj>
<attribute_group_name>ADMAttributes</attribute_group_name>
<attribute_group_narrative>This group contains all attributes of ADM objects excepts those that can also be Widget Attributes. In that case, they are in the WidgetAttribute group.</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="307" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>FolderType</attribute_label>
<attribute_group_obj>1003183341</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>528.1713</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="308" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>FolderWindowToLaunch</attribute_label>
<attribute_group_obj>436.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>If Dynamics is running, this property specifies a window to launch upon the occurence of toolbar events &quot;View&quot;, &quot;Copy&quot;, &quot;Modify&quot; or &quot;Add&quot;.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>1003466958</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>436.7063</attribute_group_obj>
<attribute_group_name>Browser</attribute_group_name>
<attribute_group_narrative>SmartBrowser attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="309" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>FONT</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>4</data_type>
<attribute_narrative>WidgetAttributes Font</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005099311.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="310" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ForeignFields</attribute_label>
<attribute_group_obj>154.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>A comma-separated list, consisting of thefirst local db fieldname, followed by the matching source temp-table field name, followed by more pairs if there is more than one field to match.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>1003183462</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>154.7063</attribute_group_obj>
<attribute_group_name>Query</attribute_group_name>
<attribute_group_narrative>Query object attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="311" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ForeignValues</attribute_label>
<attribute_group_obj>154.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The values are character strings formatted according to the field format specification and they are separated by the CHR(1) character.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>519.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>154.7063</attribute_group_obj>
<attribute_group_name>Query</attribute_group_name>
<attribute_group_narrative>Query object attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="312" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>FORMAT</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>WidgetAttributes Format</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005078460.09</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="313" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>FRAME</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005099310.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="314" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>FrameMinHeightChars</attribute_label>
<attribute_group_obj>1005095446.101</attribute_group_obj>
<data_type>5</data_type>
<attribute_narrative>The calculated minimum height of the viewer&apos;s frame, in characters.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005109052.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005095446.101</attribute_group_obj>
<attribute_group_name>ViewerAttributes</attribute_group_name>
<attribute_group_narrative>These are attributes which belong to a Dynamic Viewer</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="315" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>FrameMinWidthChars</attribute_label>
<attribute_group_obj>1005095446.101</attribute_group_obj>
<data_type>5</data_type>
<attribute_narrative>The calculated minimum width of the viewer&apos;s frame, in characters.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005109053.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005095446.101</attribute_group_obj>
<attribute_group_name>ViewerAttributes</attribute_group_name>
<attribute_group_narrative>These are attributes which belong to a Dynamic Viewer</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="316" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>FullRowSelect</attribute_label>
<attribute_group_obj>1005097792.101</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>If yes, the entire row of the node is selected. If no, only the text is selected.</attribute_narrative>
<override_type>SET</override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>3508.66</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005097792.101</attribute_group_obj>
<attribute_group_name>TreeView</attribute_group_name>
<attribute_group_narrative>TreeView Group</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="317" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>GRAPHIC-EDGE</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005099328.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="318" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>GroupAssignSource</attribute_label>
<attribute_group_obj>9.7063</attribute_group_obj>
<data_type>10</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>118.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>9.7063</attribute_group_obj>
<attribute_group_name>DataVisual</attribute_group_name>
<attribute_group_narrative>Data visualization object attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="319" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>GroupAssignSourceEvents</attribute_label>
<attribute_group_obj>9.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level>Class</constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>122.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>9.7063</attribute_group_obj>
<attribute_group_name>DataVisual</attribute_group_name>
<attribute_group_narrative>Data visualization object attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="320" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>GroupAssignTarget</attribute_label>
<attribute_group_obj>9.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>120.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>9.7063</attribute_group_obj>
<attribute_group_name>DataVisual</attribute_group_name>
<attribute_group_narrative>Data visualization object attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="321" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>GroupAssignTargetEvents</attribute_label>
<attribute_group_obj>9.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level>Class</constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>124.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>9.7063</attribute_group_obj>
<attribute_group_name>DataVisual</attribute_group_name>
<attribute_group_narrative>Data visualization object attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="322" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>HasDynamicProxy</attribute_label>
<attribute_group_obj>347.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Indicates whether or not this container has a dynamic client proxy. Maintained from constructObject.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>426.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>347.7063</attribute_group_obj>
<attribute_group_name>Container</attribute_group_name>
<attribute_group_narrative>Container Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="323" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>Height</attribute_label>
<attribute_group_obj>3000002003.09</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>A widget&apos;s height. The unit of measurement is determined by another 
parameter.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>1005078415.09</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="02/10/2003" version_time="59461" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="3000002003.09" record_version_obj="3000002004.09" version_number_seq="1.09" secondary_key_value="ADMAttributes" import_version_number_seq="1.09"><attribute_group_obj>3000002003.09</attribute_group_obj>
<attribute_group_name>ADMAttributes</attribute_group_name>
<attribute_group_narrative>This group contains all attributes of ADM objects excepts those that can also be Widget Attributes. In that case, they are in the WidgetAttribute group.</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="324" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="10/03/2002" version_time="45358" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="1005099284.101" record_version_obj="5108.66" version_number_seq="1.66" secondary_key_value="HEIGHT-CHARS" import_version_number_seq="1.66"><attribute_label>HEIGHT-CHARS</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>5</data_type>
<attribute_narrative>Height in characters. This may currently be used when rendering some objects. There is no get function, use getHeight to retrieve the realized value from an object.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005099284.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="325" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>HEIGHT-PIXELS</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>4</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005099264.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="326" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>HELP</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>WidgetAttributes Help</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005099308.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="327" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>HelpId</attribute_label>
<attribute_group_obj>434.7063</attribute_group_obj>
<data_type>4</data_type>
<attribute_narrative>Stores the optionally defined HelpId of the selection .</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>568.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>434.7063</attribute_group_obj>
<attribute_group_name>Select</attribute_group_name>
<attribute_group_narrative>SmartSelect attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="328" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>HIDDEN</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005099301.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="329" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>HiddenActions</attribute_label>
<attribute_group_obj>430.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>A comma separated list of hidden actions.
The actions will be immediately hidden or viewed.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>183</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>430.7063</attribute_group_obj>
<attribute_group_name>Toolbar</attribute_group_name>
<attribute_group_narrative>SmartToolbar attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="330" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>HiddenMenuBands</attribute_label>
<attribute_group_obj>430.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>A comma separated list of hidden menu bands.
This must be set before initialization.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>187</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>430.7063</attribute_group_obj>
<attribute_group_name>Toolbar</attribute_group_name>
<attribute_group_narrative>SmartToolbar attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="331" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>HiddenToolbarBands</attribute_label>
<attribute_group_obj>430.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>A comma separated list of hidden toolbar bands.
This must be set before initialization.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>185</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>430.7063</attribute_group_obj>
<attribute_group_name>Toolbar</attribute_group_name>
<attribute_group_narrative>SmartToolbar attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="332" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>HideOnInit</attribute_label>
<attribute_group_obj>5.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Flag indicating whether to visualize at initialization.
Also used for non visual object in order to publish LinkState correctly for activation and deactivation of links.   
Defaults to &apos;NO&apos;, set to &apos;YES&apos; from the container when it runs initPages to initialize non visible pages</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>1003183447</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>5.7063</attribute_group_obj>
<attribute_group_name>Smart</attribute_group_name>
<attribute_group_narrative>Smart Object common attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="333" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>HideSelection</attribute_label>
<attribute_group_obj>1005097792.101</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Used to set the property of a SmartTreeView object to indicate that a node should appear as selected or not.</attribute_narrative>
<override_type>SET</override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>1005081439.28</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005097792.101</attribute_group_obj>
<attribute_group_name>TreeView</attribute_group_name>
<attribute_group_narrative>TreeView Group</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="334" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="06/19/2002" version_time="44549" version_user="ross" deletion_flag="no" entity_mnemonic="rycat" key_field_value="13481.409" record_version_obj="13482.409" version_number_seq="2.409" secondary_key_value="HORIZONTAL" import_version_number_seq="2.409"><attribute_label>HORIZONTAL</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>When TRUE, radio-sets are oriented horizontally.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>13481.409</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="335" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>HotKey</attribute_label>
<attribute_group_obj>3000002003.09</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>For SmartPak folder</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>3496.66</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="02/10/2003" version_time="59461" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="3000002003.09" record_version_obj="3000002004.09" version_number_seq="1.09" secondary_key_value="ADMAttributes" import_version_number_seq="1.09"><attribute_group_obj>3000002003.09</attribute_group_obj>
<attribute_group_name>ADMAttributes</attribute_group_name>
<attribute_group_narrative>This group contains all attributes of ADM objects excepts those that can also be Widget Attributes. In that case, they are in the WidgetAttribute group.</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="336" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>HtmlClass</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>CLASS property for an HTML tag</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>522.1713</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="337" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="03/18/2003" version_time="55855" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="3012.1713" record_version_obj="3013.1713" version_number_seq="1.09" secondary_key_value="HtmlStyle" import_version_number_seq="1.09"><attribute_label>HtmlStyle</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>STYLE property for an HTML tag</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>3012.1713</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="338" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>IMAGE-DOWN-FILE</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>3000040674.09</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="339" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>IMAGE-FILE</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>3000040675.09</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="340" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>IMAGE-INSENSITIVE-FILE</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>3000040676.09</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="341" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ImageDisabled</attribute_label>
<attribute_group_obj>3000002003.09</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>SmartPak Folder</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>3494.66</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="02/10/2003" version_time="59461" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="3000002003.09" record_version_obj="3000002004.09" version_number_seq="1.09" secondary_key_value="ADMAttributes" import_version_number_seq="1.09"><attribute_group_obj>3000002003.09</attribute_group_obj>
<attribute_group_name>ADMAttributes</attribute_group_name>
<attribute_group_narrative>This group contains all attributes of ADM objects excepts those that can also be Widget Attributes. In that case, they are in the WidgetAttribute group.</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="342" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ImageEnabled</attribute_label>
<attribute_group_obj>3000002003.09</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>SmartPak Folder</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>3493.66</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="02/10/2003" version_time="59461" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="3000002003.09" record_version_obj="3000002004.09" version_number_seq="1.09" secondary_key_value="ADMAttributes" import_version_number_seq="1.09"><attribute_group_obj>3000002003.09</attribute_group_obj>
<attribute_group_name>ADMAttributes</attribute_group_name>
<attribute_group_narrative>This group contains all attributes of ADM objects excepts those that can also be Widget Attributes. In that case, they are in the WidgetAttribute group.</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="343" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ImageHeight</attribute_label>
<attribute_group_obj>1003183341</attribute_group_obj>
<data_type>4</data_type>
<attribute_narrative></attribute_narrative>
<override_type>SET</override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>1003202044</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="344" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ImagePath</attribute_label>
<attribute_group_obj>430.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>702.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>430.7063</attribute_group_obj>
<attribute_group_name>Toolbar</attribute_group_name>
<attribute_group_narrative>SmartToolbar attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="345" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ImageWidth</attribute_label>
<attribute_group_obj>1003183341</attribute_group_obj>
<data_type>4</data_type>
<attribute_narrative></attribute_narrative>
<override_type>SET</override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>1003202042</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="346" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ImageXOffset</attribute_label>
<attribute_group_obj>1003183341</attribute_group_obj>
<data_type>4</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>1003202046</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="347" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ImageYOffset</attribute_label>
<attribute_group_obj>1003183341</attribute_group_obj>
<data_type>4</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>1003202048</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="348" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>InactiveLinks</attribute_label>
<attribute_group_obj>5.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>72.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>5.7063</attribute_group_obj>
<attribute_group_name>Smart</attribute_group_name>
<attribute_group_narrative>Smart Object common attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="349" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="03/18/2003" version_time="54706" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="35975.66" record_version_obj="35976.66" version_number_seq="1.09" secondary_key_value="IncludeInDefaultListView" import_version_number_seq="1.09"><attribute_label>IncludeInDefaultListView</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Indicates whether the field should be included in default list oriented views, like the browse. This applies to runtime list oriented views if not other field list is specified and is also used by object generators to decide which fields to add to generated browsers. The attribute defaults to unknown, which means that the IncludeInDefaultView setting should be used.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level>Master</constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>35975.66</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="350" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="03/18/2003" version_time="54706" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="35973.66" record_version_obj="35974.66" version_number_seq="1.09" secondary_key_value="IncludeInDefaultView" import_version_number_seq="1.09"><attribute_label>IncludeInDefaultView</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Indicates whether the field should be included in default views of the entity. This applies to runtime created views when no other field list is specified and is also used by object generators to decide which fields to add to generated visual objects.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level>Master</constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>35973.66</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="351" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>Indentation</attribute_label>
<attribute_group_obj>1005097792.101</attribute_group_obj>
<data_type>4</data_type>
<attribute_narrative>Number of pixels of indentation between a node and it&apos;s child node.</attribute_narrative>
<override_type>SET</override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>3509.66</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005097792.101</attribute_group_obj>
<attribute_group_name>TreeView</attribute_group_name>
<attribute_group_narrative>TreeView Group</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="352" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>IndexInformation</attribute_label>
<attribute_group_obj>152.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Stores indexInormation formatted as the 4GL index-information attribute, but with RowObject column names and chr(1) as index 
separator and chr(2) as table separator.  See &apos;getIndexInformation&apos; ovrride for more info.</attribute_narrative>
<override_type>get</override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>208.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>152.7063</attribute_group_obj>
<attribute_group_name>Data</attribute_group_name>
<attribute_group_narrative>SDO Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="353" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>InheritColor</attribute_label>
<attribute_group_obj>1003183341</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>1003202064</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="354" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>InitialPageList</attribute_label>
<attribute_group_obj>347.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>A comma-separated list of pages to construct at startup.
A special value of * will indicate all pages must be initialized at startup.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>377.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>347.7063</attribute_group_obj>
<attribute_group_name>Container</attribute_group_name>
<attribute_group_narrative>Container Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="355" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>InitialValue</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>WidgetAttributes InitialValue</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>3000000338.09</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="356" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>InMessageSource</attribute_label>
<attribute_group_obj>509.49</attribute_group_obj>
<data_type>10</data_type>
<attribute_narrative>The handle of the In Message source</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>914.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="09/04/2002" version_time="57055" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="509.49" record_version_obj="510.49" version_number_seq="2.49" secondary_key_value="MsgHandler" import_version_number_seq="2.49"><attribute_group_obj>509.49</attribute_group_obj>
<attribute_group_name>MsgHandler</attribute_group_name>
<attribute_group_narrative>Message Handler attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="357" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>InMessageTarget</attribute_label>
<attribute_group_obj>505.49</attribute_group_obj>
<data_type>10</data_type>
<attribute_narrative>The handle of the In Message target.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>878.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="09/04/2002" version_time="57079" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="505.49" record_version_obj="506.49" version_number_seq="3.49" secondary_key_value="Consumer" import_version_number_seq="3.49"><attribute_group_obj>505.49</attribute_group_obj>
<attribute_group_name>Consumer</attribute_group_name>
<attribute_group_narrative>SmartConsumer attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="358" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>INNER-CHARS</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>4</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005099289.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="359" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>INNER-LINES</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>4</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005099288.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="360" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>InnerLines</attribute_label>
<attribute_group_obj>1005095447.101</attribute_group_obj>
<data_type>4</data_type>
<attribute_narrative>Sets the INNER-LINES property of a Dynamic Combo</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>10.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_group_name>SdfAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Smart Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="361" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>InstanceId</attribute_label>
<attribute_group_obj>3000002003.09</attribute_group_obj>
<data_type>5</data_type>
<attribute_narrative>The unique identifer of the running instance in the Repository Manager. The Repository Manager ensures that this is set when the object is fetched from the Repository so that the object can use it as input to Repository Manager APIs.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>4250.66</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="02/10/2003" version_time="59461" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="3000002003.09" record_version_obj="3000002004.09" version_number_seq="1.09" secondary_key_value="ADMAttributes" import_version_number_seq="1.09"><attribute_group_obj>3000002003.09</attribute_group_obj>
<attribute_group_name>ADMAttributes</attribute_group_name>
<attribute_group_narrative>This group contains all attributes of ADM objects excepts those that can also be Widget Attributes. In that case, they are in the WidgetAttribute group.</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="362" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>InstanceNames</attribute_label>
<attribute_group_obj>347.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Ordered list of ObjectNames of Container-Targets.
The list is in ContainerTarget order and each name is currently also stored in each object&apos;s ObjectName property.
It is used to enforce unique instance names in the container and is updated in constructObject and destroyObject together with the container link.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>416.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>347.7063</attribute_group_obj>
<attribute_group_name>Container</attribute_group_name>
<attribute_group_narrative>Container Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="363" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>InstanceProperties</attribute_label>
<attribute_group_obj>5.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>yes</design_only>
<system_owned>yes</system_owned>
<attribute_obj>27.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>5.7063</attribute_group_obj>
<attribute_group_name>Smart</attribute_group_name>
<attribute_group_narrative>Smart Object common attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="364" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>InternalRefList</attribute_label>
<attribute_group_obj>513.49</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Stores the Internal References this router uses to determine how external target namespaces map to internal XML mapping schemas.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>938.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="09/04/2002" version_time="57056" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="513.49" record_version_obj="514.49" version_number_seq="2.49" secondary_key_value="Router" import_version_number_seq="2.49"><attribute_group_obj>513.49</attribute_group_obj>
<attribute_group_name>Router</attribute_group_name>
<attribute_group_narrative>SmartRouter attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="365" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>IsRowObjectExternal</attribute_label>
<attribute_group_obj>152.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Decides whether a dynamic RowObject table should be deleted on destroy of the object. Set to true in prepareRowObject, which is called to prepare an externally created RowObject in non-persistent procedures that outputs the RowObject as table-handle.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>3228.66</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>152.7063</attribute_group_obj>
<attribute_group_name>Data</attribute_group_name>
<attribute_group_narrative>SDO Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="366" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>IsRowObjUpdExternal</attribute_label>
<attribute_group_obj>152.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Indicates that the RowObjUpd is external, usually from a client. This flag is currently set to true in setRowObjUpdTable if called BEFORE the object has been initialized. The flag then tells the dynamic SDO that it must skip the creation of this temp-table during initialization.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>4275.66</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>152.7063</attribute_group_obj>
<attribute_group_name>Data</attribute_group_name>
<attribute_group_narrative>SDO Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="367" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>JavaScriptFile</attribute_label>
<attribute_group_obj>347.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>530.1713</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>347.7063</attribute_group_obj>
<attribute_group_name>Container</attribute_group_name>
<attribute_group_narrative>Container Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="368" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="03/24/2003" version_time="39229" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="5338.1713" record_version_obj="5339.1713" version_number_seq="1.09" secondary_key_value="JavaScriptObject" import_version_number_seq="1.09"><attribute_label>JavaScriptObject</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>JavaScript object to be used for rendering/behavior support</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>5338.1713</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="369" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>JMSpartition</attribute_label>
<attribute_group_obj>731.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The JMS partition for the JMS session.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>902.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>731.7063</attribute_group_obj>
<attribute_group_name>Messaging</attribute_group_name>
<attribute_group_narrative>Messaging SmartObject attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="370" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>JMSPassword</attribute_label>
<attribute_group_obj>731.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The JMS Password for the JMS session.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>882.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>731.7063</attribute_group_obj>
<attribute_group_name>Messaging</attribute_group_name>
<attribute_group_narrative>Messaging SmartObject attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="371" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>JMSUser</attribute_label>
<attribute_group_obj>731.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The JMS User for the JMS session.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>880.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>731.7063</attribute_group_obj>
<attribute_group_name>Messaging</attribute_group_name>
<attribute_group_narrative>Messaging SmartObject attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="372" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>KeyDataType</attribute_label>
<attribute_group_obj>1005095447.101</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Data type of Dynamic Lookup/Dynamic Combo key field.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005089871.28</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_group_name>SdfAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Smart Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="373" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>KeyField</attribute_label>
<attribute_group_obj>1005095447.101</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Name of the Dynamic Lookup/Dynamic Combo key field to assign value from (Table.Field)</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005089867.28</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_group_name>SdfAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Smart Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="374" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>KeyFields</attribute_label>
<attribute_group_obj>154.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The indexInformation will be used to try to figure out the
default KeyFields list, but this is currently restricted to cases 
where: 
     - The First Table in the join is the Only enabled table.
     - All the fields of the index is present is the SDO.             
The following index may be selected.                          
            1. Primary index if unique.
            2. First Unique index.</attribute_narrative>
<override_type>get</override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>537.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>154.7063</attribute_group_obj>
<attribute_group_name>Query</attribute_group_name>
<attribute_group_narrative>Query object attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="375" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>KeyFormat</attribute_label>
<attribute_group_obj>1005095447.101</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Format of Dynamic Lookup/Dynaic Combo key field.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005089870.28</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_group_name>SdfAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Smart Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="376" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>KeyTableId</attribute_label>
<attribute_group_obj>154.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>This is a unique Table identifier across databases for all tables 
used by the framework (Dynamics FiveLetterAcronym).</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>539.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>154.7063</attribute_group_obj>
<attribute_group_name>Query</attribute_group_name>
<attribute_group_narrative>Query object attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="377" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>LABEL</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>WidgetAttributes Label</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005095224.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="378" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>LabelBgColor</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>4</data_type>
<attribute_narrative>WidgetAttributes LabelBgColor</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005104906.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="379" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>LabelEdit</attribute_label>
<attribute_group_obj>1005097792.101</attribute_group_obj>
<data_type>4</data_type>
<attribute_narrative>Is the node label editable. 1 = yes</attribute_narrative>
<override_type>SET</override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>3510.66</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005097792.101</attribute_group_obj>
<attribute_group_name>TreeView</attribute_group_name>
<attribute_group_narrative>TreeView Group</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="380" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>LabelFgColor</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>4</data_type>
<attribute_narrative>WidgetAttributes LabelFgColor</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005104908.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="381" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>LabelFont</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>4</data_type>
<attribute_narrative>WidgetAttributes LabelFont</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005104904.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="382" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>LabelHandle</attribute_label>
<attribute_group_obj>432.7063</attribute_group_obj>
<data_type>10</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>586.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>432.7063</attribute_group_obj>
<attribute_group_name>Field</attribute_group_name>
<attribute_group_narrative>SmartField Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="383" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>LabelOffset</attribute_label>
<attribute_group_obj>1003183341</attribute_group_obj>
<data_type>4</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1003202040</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="384" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="06/19/2002" version_time="44549" version_user="ross" deletion_flag="no" entity_mnemonic="rycat" key_field_value="13470.409" record_version_obj="13471.409" version_number_seq="2.409" secondary_key_value="LABELS" import_version_number_seq="2.409"><attribute_label>LABELS</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>If false then NO-LABEL is used.  This attribute applies to most field level widgets and frames</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>13470.409</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="385" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="06/19/2002" version_time="44549" version_user="ross" deletion_flag="no" entity_mnemonic="rycat" key_field_value="1005098171.101" record_version_obj="13472.409" version_number_seq="1.409" secondary_key_value="LARGE" import_version_number_seq="1.409"><attribute_label>LARGE</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Whether the editor is a large editor.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005098171.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="386" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="03/05/2003" version_time="66053" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="49813.7063" record_version_obj="49814.7063" version_number_seq="1.09" secondary_key_value="LastCommitErrorKeys" import_version_number_seq="1.09"><attribute_label>LastCommitErrorKeys</attribute_label>
<attribute_group_obj>152.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Stores a comma-separated list of key values of every record that failed to be committed the last time data was committed. Blank indicates that the last commit was successful while unkown indicates that a commit never has been attempted since the object was initialized.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>49813.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>152.7063</attribute_group_obj>
<attribute_group_name>Data</attribute_group_name>
<attribute_group_narrative>SDO Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="387" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="12/05/2002" version_time="52224" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="18288.66" record_version_obj="18289.66" version_number_seq="1.09" secondary_key_value="LastCommitErrorType" import_version_number_seq="1.09"><attribute_label>LastCommitErrorType</attribute_label>
<attribute_group_obj>152.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Stores the type of error encountered the last time data was committed. Blank indicates that the last commit was successful, while unkown indicates that a commit never has been attempted since the object was initialized. 

Currently supported values 
- Conflict, locking conflict.  
- Error, unspecified error type</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>18288.66</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>152.7063</attribute_group_obj>
<attribute_group_name>Data</attribute_group_name>
<attribute_group_narrative>SDO Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="388" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>LastDBRowIdent</attribute_label>
<attribute_group_obj>154.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Unknown if the last row has not been fetched. Otherwise it is the database rowid(s) for the last row.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>527.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>154.7063</attribute_group_obj>
<attribute_group_name>Query</attribute_group_name>
<attribute_group_narrative>Query object attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="389" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>LastResultRow</attribute_label>
<attribute_group_obj>152.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Unknown if the last row has not been fetched. Otherwise its &apos;rownum&apos; concatinated with the rowid, if it has been fetched.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>194.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>152.7063</attribute_group_obj>
<attribute_group_name>Data</attribute_group_name>
<attribute_group_narrative>SDO Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="390" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>LastRowNum</attribute_label>
<attribute_group_obj>152.7063</attribute_group_obj>
<data_type>4</data_type>
<attribute_narrative>The temp-table row number of the last row</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>166.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>152.7063</attribute_group_obj>
<attribute_group_name>Data</attribute_group_name>
<attribute_group_narrative>SDO Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="391" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>LayoutOptions</attribute_label>
<attribute_group_obj>7.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>List of multi-layout options for the object.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>74.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>7.7063</attribute_group_obj>
<attribute_group_name>Visual</attribute_group_name>
<attribute_group_narrative>Visual Smartobject attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="392" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>LayoutType</attribute_label>
<attribute_group_obj>1005095446.101</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The type of layout to use. Valid values include Manager, Widget and 
Column.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005095450.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005095446.101</attribute_group_obj>
<attribute_group_name>ViewerAttributes</attribute_group_name>
<attribute_group_narrative>These are attributes which belong to a Dynamic Viewer</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="393" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>LayoutUnits</attribute_label>
<attribute_group_obj>1005095446.101</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The units to use for layout purposes.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005095452.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005095446.101</attribute_group_obj>
<attribute_group_name>ViewerAttributes</attribute_group_name>
<attribute_group_narrative>These are attributes which belong to a Dynamic Viewer</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="394" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>LayoutVariable</attribute_label>
<attribute_group_obj>7.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>78.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>7.7063</attribute_group_obj>
<attribute_group_name>Visual</attribute_group_name>
<attribute_group_narrative>Visual Smartobject attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="395" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>Lines</attribute_label>
<attribute_group_obj>1005098168.101</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The number of lines in an editor. This is denominatd in SizeUnits units,
which are an attribute of the widget.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005098169.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005098168.101</attribute_group_obj>
<attribute_group_name>EditorAttributes</attribute_group_name>
<attribute_group_narrative>Attributes which are specific to an editor widget</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="396" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>LineStyle</attribute_label>
<attribute_group_obj>1005097792.101</attribute_group_obj>
<data_type>4</data_type>
<attribute_narrative>0 -  (Default) Tree lines. Displays lines between Node siblings and their parent Node. 
1 - Root Lines. In addition to displaying lines between Node siblings and their parent Node, also displays lines between the root nodes.</attribute_narrative>
<override_type>SET</override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>3511.66</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005097792.101</attribute_group_obj>
<attribute_group_name>TreeView</attribute_group_name>
<attribute_group_narrative>TreeView Group</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="397" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>LinkedFieldDataTypes</attribute_label>
<attribute_group_obj>1005095447.101</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Dynamic Lookup linked fields data types to display in viewer, comma list.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005089881.28</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_group_name>SdfAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Smart Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="398" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>LinkedFieldFormats</attribute_label>
<attribute_group_obj>1005095447.101</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Dynamic Lookup linked field formats from lookup to display in viewer, comma list.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005089882.28</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_group_name>SdfAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Smart Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="399" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>LinkTargetNames</attribute_label>
<attribute_group_obj>430.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The list of the supported toolbar links. This is based on either the tool&apos;s specified item-Link, or the Category the tools
belong to.
</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>729.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>430.7063</attribute_group_obj>
<attribute_group_name>Toolbar</attribute_group_name>
<attribute_group_narrative>SmartToolbar attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="400" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>LIST-ITEM-PAIRS</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005099334.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="401" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>LIST-ITEMS</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005099330.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="402" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ListInitialized</attribute_label>
<attribute_group_obj>434.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>584.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>434.7063</attribute_group_obj>
<attribute_group_name>Select</attribute_group_name>
<attribute_group_narrative>SmartSelect attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="403" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ListItemPairs</attribute_label>
<attribute_group_obj>1005095447.101</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>833.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_group_name>SdfAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Smart Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="404" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>LoadedByRouter</attribute_label>
<attribute_group_obj>515.49</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Set to true from the router to indicate that XML and Schema already  is loaded by the router.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>864.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="09/04/2002" version_time="57075" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="515.49" record_version_obj="516.49" version_number_seq="2.49" secondary_key_value="B2B" import_version_number_seq="2.49"><attribute_group_obj>515.49</attribute_group_obj>
<attribute_group_name>B2B</attribute_group_name>
<attribute_group_narrative>SmartB2B attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="405" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="03/17/2003" version_time="33825" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="10477.009" record_version_obj="10478.009" version_number_seq="1.09" secondary_key_value="LocalField" import_version_number_seq="1.09"><attribute_label>LocalField</attribute_label>
<attribute_group_obj>432.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Indicates that the field is providing data to a local field rather than a data field.</attribute_narrative>
<override_type>GET</override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>10477.009</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>432.7063</attribute_group_obj>
<attribute_group_name>Field</attribute_group_name>
<attribute_group_narrative>SmartField Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="406" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>LogFile</attribute_label>
<attribute_group_obj>505.49</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The LogFile used to log errors for the consumer when running
in batch mode.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>884.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="09/04/2002" version_time="57079" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="505.49" record_version_obj="506.49" version_number_seq="3.49" secondary_key_value="Consumer" import_version_number_seq="3.49"><attribute_group_obj>505.49</attribute_group_obj>
<attribute_group_name>Consumer</attribute_group_name>
<attribute_group_narrative>SmartConsumer attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="407" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>LogicalObjectName</attribute_label>
<attribute_group_obj>5.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Maps to the object name in the Repository. Managed by the Repository manager at runtime.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>1003299781</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>5.7063</attribute_group_obj>
<attribute_group_name>Smart</attribute_group_name>
<attribute_group_narrative>Smart Object common attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="408" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>LogicalVersion</attribute_label>
<attribute_group_obj>3000002003.09</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The version of a logical (non-static) object, as stored in the</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1000000272.48</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="02/10/2003" version_time="59461" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="3000002003.09" record_version_obj="3000002004.09" version_number_seq="1.09" secondary_key_value="ADMAttributes" import_version_number_seq="1.09"><attribute_group_obj>3000002003.09</attribute_group_obj>
<attribute_group_name>ADMAttributes</attribute_group_name>
<attribute_group_narrative>This group contains all attributes of ADM objects excepts those that can also be Widget Attributes. In that case, they are in the WidgetAttribute group.</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="409" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>LookupFilterValue</attribute_label>
<attribute_group_obj>3000002003.09</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Filter value for the lookup</attribute_narrative>
<override_type>SET</override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>3232.66</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="02/10/2003" version_time="59461" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="3000002003.09" record_version_obj="3000002004.09" version_number_seq="1.09" secondary_key_value="ADMAttributes" import_version_number_seq="1.09"><attribute_group_obj>3000002003.09</attribute_group_obj>
<attribute_group_name>ADMAttributes</attribute_group_name>
<attribute_group_narrative>This group contains all attributes of ADM objects excepts those that can also be Widget Attributes. In that case, they are in the WidgetAttribute group.</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="410" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>LookupHandle</attribute_label>
<attribute_group_obj>1005095447.101</attribute_group_obj>
<data_type>10</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>825.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_group_name>SdfAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Smart Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="411" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>LookupImage</attribute_label>
<attribute_group_obj>1005095447.101</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Image to use for Dynamic Lookup button (binoculars) - default will always be adeicon/select.bmp</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>1005089887.28</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_group_name>SdfAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Smart Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="412" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>MaintenanceObject</attribute_label>
<attribute_group_obj>1005095447.101</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The logical object name of the object to be used when data for the table being queried using Dynamic Lookups can be maintained.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005089898.28</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_group_name>SdfAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Smart Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="413" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>MaintenanceSDO</attribute_label>
<attribute_group_obj>1005095447.101</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>This attribute contains the name of an SDO to be assosiated with a maintenance folder for the Dynamic Lookups.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005101356.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_group_name>SdfAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Smart Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="414" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>Mandatory</attribute_label>
<attribute_group_obj>3000002003.09</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>WidgetAttributes Mandatory</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005104900.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="02/10/2003" version_time="59461" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="3000002003.09" record_version_obj="3000002004.09" version_number_seq="1.09" secondary_key_value="ADMAttributes" import_version_number_seq="1.09"><attribute_group_obj>3000002003.09</attribute_group_obj>
<attribute_group_name>ADMAttributes</attribute_group_name>
<attribute_group_narrative>This group contains all attributes of ADM objects excepts those that can also be Widget Attributes. In that case, they are in the WidgetAttribute group.</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="415" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>MANUAL-HIGHLIGHT</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005099291.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="416" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ManualAddQueryWhere</attribute_label>
<attribute_group_obj>152.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Store manual calls to addQueryWhere so that filter can reapply this when filter is changed, thus ensuring the original query stays intact. 
See &apos;setManualAddQueryWhere&apos; for more info.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>219.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>152.7063</attribute_group_obj>
<attribute_group_name>Data</attribute_group_name>
<attribute_group_narrative>SDO Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="417" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ManualAssignQuerySelection</attribute_label>
<attribute_group_obj>152.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Store manual calls to assignQuerySelection so that filter can reapply this when filter is changed, thus ensuring the original query stays intact.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>221.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>152.7063</attribute_group_obj>
<attribute_group_name>Data</attribute_group_name>
<attribute_group_narrative>SDO Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="418" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ManualSetQuerySort</attribute_label>
<attribute_group_obj>152.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Store manual calls to setQuerySort so that filter can reapply this
when filter is changed, thus ensuring the original query stays intact.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>223.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>152.7063</attribute_group_obj>
<attribute_group_name>Data</attribute_group_name>
<attribute_group_narrative>SDO Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="419" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>MapNameProducer</attribute_label>
<attribute_group_obj>515.49</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>870.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="09/04/2002" version_time="57075" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="515.49" record_version_obj="516.49" version_number_seq="2.49" secondary_key_value="B2B" import_version_number_seq="2.49"><attribute_group_obj>515.49</attribute_group_obj>
<attribute_group_name>B2B</attribute_group_name>
<attribute_group_narrative>SmartB2B attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="420" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>MapObjectProducer</attribute_label>
<attribute_group_obj>515.49</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>866.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="09/04/2002" version_time="57075" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="515.49" record_version_obj="516.49" version_number_seq="2.49" secondary_key_value="B2B" import_version_number_seq="2.49"><attribute_group_obj>515.49</attribute_group_obj>
<attribute_group_name>B2B</attribute_group_name>
<attribute_group_narrative>SmartB2B attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="421" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>MapTypeProducer</attribute_label>
<attribute_group_obj>515.49</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>868.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="09/04/2002" version_time="57075" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="515.49" record_version_obj="516.49" version_number_seq="2.49" secondary_key_value="B2B" import_version_number_seq="2.49"><attribute_group_obj>515.49</attribute_group_obj>
<attribute_group_name>B2B</attribute_group_name>
<attribute_group_narrative>SmartB2B attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="422" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>MarginPixels</attribute_label>
<attribute_group_obj>438.7063</attribute_group_obj>
<data_type>4</data_type>
<attribute_narrative>The number of pixels to reserve for the Panel margin -- used by resizeObject.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>664.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>438.7063</attribute_group_obj>
<attribute_group_name>Panel</attribute_group_name>
<attribute_group_narrative>SmartPanel attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="423" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>MasterDataObject</attribute_label>
<attribute_group_obj>428.7063</attribute_group_obj>
<data_type>10</data_type>
<attribute_narrative>The handle of the &quot;Master&quot; SDO, the one which has no data source of its own and is the parent to other SDOs.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>440.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>428.7063</attribute_group_obj>
<attribute_group_name>DataContainer</attribute_group_name>
<attribute_group_narrative>SmartBusinessObject and other Data Container attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="424" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>MasterFile</attribute_label>
<attribute_group_obj>1005095447.101</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The physical file used to launch the SmartDataField. The default value for a Dynamic Lookup is adm2/dynlookup.w; and for a Dynamic Combo it is adm2/dyncombo.w.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005101640.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_group_name>SdfAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Smart Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="425" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>MAX-CHARS</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>4</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005099271.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="426" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>MAX-DATA-GUESS</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>4</data_type>
<attribute_narrative>Guess to help accuracy of the browser &quot;thumb&quot; position.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>14658.409</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="427" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>MaxWidth</attribute_label>
<attribute_group_obj>436.7063</attribute_group_obj>
<data_type>5</data_type>
<attribute_narrative>The maximum value to use for setting the width of the browse when CalcWidth is TRUE.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>476.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>436.7063</attribute_group_obj>
<attribute_group_name>Browser</attribute_group_name>
<attribute_group_narrative>SmartBrowser attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="428" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>Menu</attribute_label>
<attribute_group_obj>430.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>TRUE if a menu is to be generated.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>1003498426</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>430.7063</attribute_group_obj>
<attribute_group_name>Toolbar</attribute_group_name>
<attribute_group_narrative>SmartToolbar attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="429" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>MENU-KEY</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005099292.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="430" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>MENU-MOUSE</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>4</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005099293.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="431" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>MenuBarHandle</attribute_label>
<attribute_group_obj>430.7063</attribute_group_obj>
<data_type>10</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>690.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>430.7063</attribute_group_obj>
<attribute_group_name>Toolbar</attribute_group_name>
<attribute_group_narrative>SmartToolbar attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="432" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>MenuMergeOrder</attribute_label>
<attribute_group_obj>430.7063</attribute_group_obj>
<data_type>4</data_type>
<attribute_narrative>Decides the order of which the menus will be merged with other 
toolbar instances.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>189</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>430.7063</attribute_group_obj>
<attribute_group_name>Toolbar</attribute_group_name>
<attribute_group_narrative>SmartToolbar attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="433" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>MenuObject</attribute_label>
<attribute_group_obj>430.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>532.1713</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>430.7063</attribute_group_obj>
<attribute_group_name>Toolbar</attribute_group_name>
<attribute_group_narrative>SmartToolbar attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="434" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>MessageType</attribute_label>
<attribute_group_obj>731.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The type for messages being sent</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>904.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>731.7063</attribute_group_obj>
<attribute_group_name>Messaging</attribute_group_name>
<attribute_group_narrative>Messaging SmartObject attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="435" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>MinHeight</attribute_label>
<attribute_group_obj>7.7063</attribute_group_obj>
<data_type>5</data_type>
<attribute_narrative>The pre-determined minimum height of a visual object</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>12.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>7.7063</attribute_group_obj>
<attribute_group_name>Visual</attribute_group_name>
<attribute_group_narrative>Visual Smartobject attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="436" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>MinWidth</attribute_label>
<attribute_group_obj>7.7063</attribute_group_obj>
<data_type>5</data_type>
<attribute_narrative>The pre-determined minimum width of a visual object.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>11.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>7.7063</attribute_group_obj>
<attribute_group_name>Visual</attribute_group_name>
<attribute_group_narrative>Visual Smartobject attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="437" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>MODIFIED</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005099279.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="438" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ModifiedFields</attribute_label>
<attribute_group_obj>436.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>A comma-separated list of browse cell handles whose value has been modified. The first entry is the RowIdent for the row.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>478.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>436.7063</attribute_group_obj>
<attribute_group_name>Browser</attribute_group_name>
<attribute_group_narrative>SmartBrowser attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="439" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>Modify</attribute_label>
<attribute_group_obj>434.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Used  internally to identify wheter a value changed triggers the cahnge of the field or vice versa</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>566.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>434.7063</attribute_group_obj>
<attribute_group_name>Select</attribute_group_name>
<attribute_group_narrative>SmartSelect attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="440" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ModRowIdent</attribute_label>
<attribute_group_obj>152.7063</attribute_group_obj>
<data_type>10</data_type>
<attribute_narrative>The default BUFFER handle of the &apos;ModRowIdent&apos; temp table.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>1197.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>152.7063</attribute_group_obj>
<attribute_group_name>Data</attribute_group_name>
<attribute_group_narrative>SDO Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="441" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ModRowIdentTable</attribute_label>
<attribute_group_obj>152.7063</attribute_group_obj>
<data_type>10</data_type>
<attribute_narrative>The table handle of the &apos;ModRowIdent&apos; temp table</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>1195.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>152.7063</attribute_group_obj>
<attribute_group_name>Data</attribute_group_name>
<attribute_group_narrative>SDO Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="442" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>MouseCursor</attribute_label>
<attribute_group_obj>1003183341</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1003202062</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="443" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>MOVABLE</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005099268.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="444" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>MovableHandle</attribute_label>
<attribute_group_obj>436.7063</attribute_group_obj>
<data_type>10</data_type>
<attribute_narrative>Stores handle of movable columns popup menu</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>265.009</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>436.7063</attribute_group_obj>
<attribute_group_name>Browser</attribute_group_name>
<attribute_group_narrative>SmartBrowser attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="445" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>MultiInstanceActivated</attribute_label>
<attribute_group_obj>347.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>385.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>347.7063</attribute_group_obj>
<attribute_group_name>Container</attribute_group_name>
<attribute_group_narrative>Container Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="446" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>MultiInstanceSupported</attribute_label>
<attribute_group_obj>347.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>383.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>347.7063</attribute_group_obj>
<attribute_group_name>Container</attribute_group_name>
<attribute_group_narrative>Container Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="447" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>MULTIPLE</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005099336.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="448" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="02/26/2003" version_time="66394" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="1005099281.101" record_version_obj="32973.66" version_number_seq="1.09" secondary_key_value="NAME" import_version_number_seq="1.09"><attribute_label>NAME</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The NAME attribute uniquely identifes the widget in its container.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>1005099281.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="449" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="03/24/2003" version_time="39236" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="2127.7692" record_version_obj="2128.7692" version_number_seq="1.09" secondary_key_value="NameDefault" import_version_number_seq="1.09"><attribute_label>NameDefault</attribute_label>
<attribute_group_obj>1003183341</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Default name of object used in design time environment. Used in conjunction with palette items.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>yes</design_only>
<system_owned>no</system_owned>
<attribute_obj>2127.7692</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="450" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>NameList</attribute_label>
<attribute_group_obj>515.49</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Stores the list of logical schema Names this B2B uses.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>851.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="09/04/2002" version_time="57075" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="515.49" record_version_obj="516.49" version_number_seq="2.49" secondary_key_value="B2B" import_version_number_seq="2.49"><attribute_group_obj>515.49</attribute_group_obj>
<attribute_group_name>B2B</attribute_group_name>
<attribute_group_narrative>SmartB2B attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="451" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>NameSpaceHandle</attribute_label>
<attribute_group_obj>515.49</attribute_group_obj>
<data_type>10</data_type>
<attribute_narrative>The handle of the loaded XML mapping schema namespaces</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>858.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="09/04/2002" version_time="57075" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="515.49" record_version_obj="516.49" version_number_seq="2.49" secondary_key_value="B2B" import_version_number_seq="2.49"><attribute_group_obj>515.49</attribute_group_obj>
<attribute_group_name>B2B</attribute_group_name>
<attribute_group_narrative>SmartB2B attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="452" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>NavigationSource</attribute_label>
<attribute_group_obj>347.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The handle of the object&apos;s Navigation Source.
Used for pass-thru for regular containers, but also inherited by the SBO that uses it for &apos;real&apos;.
Because multiple Navigation-Sources are supported, this is a 
comma-separated list of strings.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>392.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>347.7063</attribute_group_obj>
<attribute_group_name>Container</attribute_group_name>
<attribute_group_narrative>Container Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="453" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>NavigationSourceEvents</attribute_label>
<attribute_group_obj>347.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>List of events to be subscribed to in the Navigation Panel or other Navigation-Source.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level>Class</constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>398.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>347.7063</attribute_group_obj>
<attribute_group_name>Container</attribute_group_name>
<attribute_group_narrative>Container Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="454" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>NavigationTarget</attribute_label>
<attribute_group_obj>347.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Used for pass-thru for regular containers, but also inherited by the SBO that uses it for &apos;real&apos;.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>394.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>347.7063</attribute_group_obj>
<attribute_group_name>Container</attribute_group_name>
<attribute_group_narrative>Container Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="455" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>NavigationTargetEvents</attribute_label>
<attribute_group_obj>438.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level>Class</constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>676.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>438.7063</attribute_group_obj>
<attribute_group_name>Panel</attribute_group_name>
<attribute_group_narrative>SmartPanel attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="456" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>NavigationTargetName</attribute_label>
<attribute_group_obj>438.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The ObjectName of the Data Object to be navigated by this
panel. This would be set if the Navigation-Target is an SBO
or other Container with DataObjects.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>1004979019.09</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>438.7063</attribute_group_obj>
<attribute_group_name>Panel</attribute_group_name>
<attribute_group_narrative>SmartPanel attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="457" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>NavigationType</attribute_label>
<attribute_group_obj>438.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>534.1713</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>438.7063</attribute_group_obj>
<attribute_group_name>Panel</attribute_group_name>
<attribute_group_narrative>SmartPanel attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="458" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>NeedContext</attribute_label>
<attribute_group_obj>11.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Set to true to indicate that the object requires context to be passed back and forth between client and server</attribute_narrative>
<override_type>get</override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>150.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>11.7063</attribute_group_obj>
<attribute_group_name>Appserver</attribute_group_name>
<attribute_group_narrative>Appserver attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="459" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>NewRecord</attribute_label>
<attribute_group_obj>9.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Is &apos;ADD&apos; or &apos;COPY&apos; when the current record is a new unsaved record.  Otherwise the value is &apos;NO&apos;.</attribute_narrative>
<override_type>set</override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>98.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>9.7063</attribute_group_obj>
<attribute_group_name>DataVisual</attribute_group_name>
<attribute_group_narrative>Data visualization object attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="460" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>NO-EMPTY-SPACE</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Browse last column will widen, if necessary, to fill any empty space in the right of the browse.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>14660.409</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="461" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>NO-FOCUS</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005099321.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="462" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>NoLookups</attribute_label>
<attribute_group_obj>3000002003.09</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Whether to display a lookup or not</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005095449.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="02/10/2003" version_time="59461" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="3000002003.09" record_version_obj="3000002004.09" version_number_seq="1.09" secondary_key_value="ADMAttributes" import_version_number_seq="1.09"><attribute_group_obj>3000002003.09</attribute_group_obj>
<attribute_group_name>ADMAttributes</attribute_group_name>
<attribute_group_narrative>This group contains all attributes of ADM objects excepts those that can also be Widget Attributes. In that case, they are in the WidgetAttribute group.</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="463" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="03/12/2003" version_time="66448" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="32990.66" record_version_obj="32991.66" version_number_seq="1.09" secondary_key_value="NotEmpty" import_version_number_seq="1.09"><attribute_label>NotEmpty</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Set to TRUE if this field cannot be empty. Not empty means not blank for a character field and not 0 for an integer or a decimal.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>32990.66</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="464" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="03/12/2003" version_time="66448" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="32988.66" record_version_obj="32989.66" version_number_seq="1.09" secondary_key_value="NotNull" import_version_number_seq="1.09"><attribute_label>NotNull</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Set to TRUE if a null value (unknown value) is not allowed in this field.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>32988.66</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="465" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>NUM-LOCKED-COLUMNS</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>4</data_type>
<attribute_narrative>Browser attributes to keep left-most columns from scrolling off the viewport.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>14662.409</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="466" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>NumDown</attribute_label>
<attribute_group_obj>436.7063</attribute_group_obj>
<data_type>4</data_type>
<attribute_narrative>The number of rows that are displayed DOWN in the browse.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>480.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>436.7063</attribute_group_obj>
<attribute_group_name>Browser</attribute_group_name>
<attribute_group_narrative>SmartBrowser attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="467" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>NumRows</attribute_label>
<attribute_group_obj>434.7063</attribute_group_obj>
<data_type>4</data_type>
<attribute_narrative>The number of rows to use in the selection.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>574.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>434.7063</attribute_group_obj>
<attribute_group_name>Select</attribute_group_name>
<attribute_group_narrative>SmartSelect attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="468" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="01/29/2003" version_time="22955" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="76.7063" record_version_obj="3000040750.09" version_number_seq="1.09" secondary_key_value="ObjectEnabled" import_version_number_seq="1.09"><attribute_label>ObjectEnabled</attribute_label>
<attribute_group_obj>7.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Flag indicating whether the current object is enabled.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>76.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>7.7063</attribute_group_obj>
<attribute_group_name>Visual</attribute_group_name>
<attribute_group_narrative>Visual Smartobject attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="469" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ObjectHidden</attribute_label>
<attribute_group_obj>5.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Returns a flag indicating whether the current object is hidden.
Note that &quot;Hidden&quot; is a logical concept in the ADM. A non-visual object can be &quot;hidden&quot; to indicate that it is not currently active in some way (e.g.  a Container-Target of some visual object that is hidden).</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>33.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>5.7063</attribute_group_obj>
<attribute_group_name>Smart</attribute_group_name>
<attribute_group_narrative>Smart Object common attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="470" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ObjectInitialized</attribute_label>
<attribute_group_obj>5.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Flag indicating whether this object has been initialized</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>31.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>5.7063</attribute_group_obj>
<attribute_group_name>Smart</attribute_group_name>
<attribute_group_narrative>Smart Object common attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="471" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ObjectLayout</attribute_label>
<attribute_group_obj>7.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Stores the Layout of the object for Alternate Layout support.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>1003183452</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>7.7063</attribute_group_obj>
<attribute_group_name>Visual</attribute_group_name>
<attribute_group_narrative>Visual Smartobject attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="472" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ObjectMapping</attribute_label>
<attribute_group_obj>428.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Lst of handles of Navigation-Source objects (panels) or other objects which are mapped to contained Data Objects,and the SDOs the SBO has connected them up to, per their NavigationTargetName property or setCurrentMappedObject request.
Used by queryPosition to identify which Object a queryPosition event should get passed on to. 
    Format is hNavSource,hSDOTarget[,...]
Application code can run getCurrentMappedObject to get back the name of the object they are currently linked to.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>452.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>428.7063</attribute_group_obj>
<attribute_group_name>DataContainer</attribute_group_name>
<attribute_group_narrative>SmartBusinessObject and other Data Container attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="473" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ObjectMode</attribute_label>
<attribute_group_obj>9.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Store the mode of the object 
MODIFY: This is a non-modal mode that can be turned off with view,  UPDATE: This is a modal mode that is turned off with save or cancel, VIEW: Non-editable
Note that &apos;setting&apos; this attribute is not actually changing the mode. This happens with updateMode and sometimes enable and disable.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>128.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>9.7063</attribute_group_obj>
<attribute_group_name>DataVisual</attribute_group_name>
<attribute_group_narrative>Data visualization object attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="474" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="02/26/2003" version_time="66394" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="3.7063" record_version_obj="32972.66" version_number_seq="1.09" secondary_key_value="ObjectName" import_version_number_seq="1.09"><attribute_label>ObjectName</attribute_label>
<attribute_group_obj>5.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>This name uniquely identifies an object instance in a container, so it is  really the object instance name.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>3.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>5.7063</attribute_group_obj>
<attribute_group_name>Smart</attribute_group_name>
<attribute_group_narrative>Smart Object common attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="475" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ObjectPage</attribute_label>
<attribute_group_obj>5.7063</attribute_group_obj>
<data_type>4</data_type>
<attribute_narrative>The logical page on which this object has been placed.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>48.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>5.7063</attribute_group_obj>
<attribute_group_name>Smart</attribute_group_name>
<attribute_group_narrative>Smart Object common attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="476" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ObjectParent</attribute_label>
<attribute_group_obj>5.7063</attribute_group_obj>
<data_type>10</data_type>
<attribute_narrative>The widget handle of this SmartObject&apos;s Container-Source&apos;s Frame or Window</attribute_narrative>
<override_type>get,set</override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>yes</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>230.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>5.7063</attribute_group_obj>
<attribute_group_name>Smart</attribute_group_name>
<attribute_group_narrative>Smart Object common attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="477" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ObjectsCreated</attribute_label>
<attribute_group_obj>347.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Flag indicating whether this object has run createObjects for page 0.
Some containers run createObjects from the main block while othersstart them from initializeObject. The create initializeObject is often too late so this flag was introduced to allow us to have more control over when the objects are created and run createObjects before initializeObject for all objects</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>414.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>347.7063</attribute_group_obj>
<attribute_group_name>Container</attribute_group_name>
<attribute_group_narrative>Container Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="478" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="10/04/2002" version_time="51720" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="3000040660.09" record_version_obj="3000040661.09" version_number_seq="2.09" secondary_key_value="ObjectSecured" import_version_number_seq="2.09"><attribute_label>ObjectSecured</attribute_label>
<attribute_group_obj>7.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>This indicates whether the object has had security applied to it already.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>3000040660.09</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>7.7063</attribute_group_obj>
<attribute_group_name>Visual</attribute_group_name>
<attribute_group_narrative>Visual Smartobject attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="479" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="10/04/2002" version_time="51765" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="3000040662.09" record_version_obj="3000040663.09" version_number_seq="2.09" secondary_key_value="ObjectTranslated" import_version_number_seq="2.09"><attribute_label>ObjectTranslated</attribute_label>
<attribute_group_obj>7.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>This indicates whether an object has had translations applied to it.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>3000040662.09</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>7.7063</attribute_group_obj>
<attribute_group_name>Visual</attribute_group_name>
<attribute_group_narrative>Visual Smartobject attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="480" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ObjectType</attribute_label>
<attribute_group_obj>5.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>17.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>5.7063</attribute_group_obj>
<attribute_group_name>Smart</attribute_group_name>
<attribute_group_narrative>Smart Object common attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="481" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ObjectVersion</attribute_label>
<attribute_group_obj>5.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>15.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>5.7063</attribute_group_obj>
<attribute_group_name>Smart</attribute_group_name>
<attribute_group_narrative>Smart Object common attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="482" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>OLEDrag</attribute_label>
<attribute_group_obj>3000002003.09</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Accept OLE drag operations</attribute_narrative>
<override_type>SET</override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>3513.66</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="02/10/2003" version_time="59461" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="3000002003.09" record_version_obj="3000002004.09" version_number_seq="1.09" secondary_key_value="ADMAttributes" import_version_number_seq="1.09"><attribute_group_obj>3000002003.09</attribute_group_obj>
<attribute_group_name>ADMAttributes</attribute_group_name>
<attribute_group_narrative>This group contains all attributes of ADM objects excepts those that can also be Widget Attributes. In that case, they are in the WidgetAttribute group.</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="483" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>OLEDrop</attribute_label>
<attribute_group_obj>3000002003.09</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Accept OLE drop operations</attribute_narrative>
<override_type>SET</override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>3514.66</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="02/10/2003" version_time="59461" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="3000002003.09" record_version_obj="3000002004.09" version_number_seq="1.09" secondary_key_value="ADMAttributes" import_version_number_seq="1.09"><attribute_group_obj>3000002003.09</attribute_group_obj>
<attribute_group_name>ADMAttributes</attribute_group_name>
<attribute_group_narrative>This group contains all attributes of ADM objects excepts those that can also be Widget Attributes. In that case, they are in the WidgetAttribute group.</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="484" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>OpenOnInit</attribute_label>
<attribute_group_obj>154.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>3225.66</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>154.7063</attribute_group_obj>
<attribute_group_name>Query</attribute_group_name>
<attribute_group_narrative>Query object attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="485" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>Operator</attribute_label>
<attribute_group_obj>608.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The default operator when OperatorStyle eq &quot;Implicit&quot;</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>620.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>608.7063</attribute_group_obj>
<attribute_group_name>Filter</attribute_group_name>
<attribute_group_narrative>SmartFilter attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="486" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>OperatorLongValues</attribute_label>
<attribute_group_obj>608.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>A list of operators and long text.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>626.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>608.7063</attribute_group_obj>
<attribute_group_name>Filter</attribute_group_name>
<attribute_group_narrative>SmartFilter attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="487" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>OperatorShortValues</attribute_label>
<attribute_group_obj>608.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>628.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>608.7063</attribute_group_obj>
<attribute_group_name>Filter</attribute_group_name>
<attribute_group_narrative>SmartFilter attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="488" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>OperatorStyle</attribute_label>
<attribute_group_obj>608.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>- &quot;Explicit&quot;  - specify operator in a separate widget
- &quot;Implicit&quot;  - Use the Operator and UseBegins property 
- &quot;Range&quot;     - Use two fill-ins and specify GE and LE values
- &quot;Inline&quot;    - Type the operator in the field (Defualt Equals or BEGINS if UseBegins eq true)     
</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>616.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>608.7063</attribute_group_obj>
<attribute_group_name>Filter</attribute_group_name>
<attribute_group_narrative>SmartFilter attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="489" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>OperatorViewAs</attribute_label>
<attribute_group_obj>608.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The view-as type used to define the operator when  OperatorStyle equals &quot;Explicit&quot;.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>618.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>608.7063</attribute_group_obj>
<attribute_group_name>Filter</attribute_group_name>
<attribute_group_narrative>SmartFilter attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="490" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>Optional</attribute_label>
<attribute_group_obj>434.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>TRUE if the selection is supposed to be optional.
If optional is TRUE the OptionalString defines the value to display.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>576.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>434.7063</attribute_group_obj>
<attribute_group_name>Select</attribute_group_name>
<attribute_group_narrative>SmartSelect attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="491" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>OptionalBlank</attribute_label>
<attribute_group_obj>434.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>TRUE if the optional value is a Blank value.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>580.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>434.7063</attribute_group_obj>
<attribute_group_name>Select</attribute_group_name>
<attribute_group_narrative>SmartSelect attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="492" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>OptionalString</attribute_label>
<attribute_group_obj>434.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The value to display as an optional value  when the Optional property is set to true.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>578.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>434.7063</attribute_group_obj>
<attribute_group_name>Select</attribute_group_name>
<attribute_group_narrative>SmartSelect attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="493" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="03/12/2003" version_time="66448" version_user="ross" deletion_flag="no" entity_mnemonic="rycat" key_field_value="13468.409" record_version_obj="13469.409" version_number_seq="2.409" secondary_key_value="Order" import_version_number_seq="2.409"><attribute_label>Order</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>4</data_type>
<attribute_narrative>Generic order attribute.  Typically used for TAB-POSITION.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>13468.409</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="494" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>OutMessageSource</attribute_label>
<attribute_group_obj>507.49</attribute_group_obj>
<data_type>10</data_type>
<attribute_narrative>The handle of the Out Message source</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>926.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="09/04/2002" version_time="57071" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="507.49" record_version_obj="508.49" version_number_seq="3.49" secondary_key_value="Producer" import_version_number_seq="3.49"><attribute_group_obj>507.49</attribute_group_obj>
<attribute_group_name>Producer</attribute_group_name>
<attribute_group_narrative>SmartProducer attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="495" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>OutMessageTarget</attribute_label>
<attribute_group_obj>509.49</attribute_group_obj>
<data_type>10</data_type>
<attribute_narrative>The handle of the Out Message target</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>916.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="09/04/2002" version_time="57055" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="509.49" record_version_obj="510.49" version_number_seq="2.49" secondary_key_value="MsgHandler" import_version_number_seq="2.49"><attribute_group_obj>509.49</attribute_group_obj>
<attribute_group_name>MsgHandler</attribute_group_name>
<attribute_group_narrative>Message Handler attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="496" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>OVERLAY</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Frame attribute to allow a frame to cover all or part of another.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>14817.409</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="497" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>PAGE-BOTTOM</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Frame attribute used for forcing a frame to the bottom of a printed page</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>14819.409</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="498" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>PAGE-TOP</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Frrame attribute used to force a frame at the top of a printed page.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>14821.409</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="499" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>Page0LayoutManager</attribute_label>
<attribute_group_obj>347.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>381.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>347.7063</attribute_group_obj>
<attribute_group_name>Container</attribute_group_name>
<attribute_group_narrative>Container Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="500" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>PageNTarget</attribute_label>
<attribute_group_obj>347.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The list of objects which are on some page other than 0.
This property has a special format of &quot;handle|page#&apos; for each entry, and should not be manipulated directly. Use &apos;addLink&apos;.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>361.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>347.7063</attribute_group_obj>
<attribute_group_name>Container</attribute_group_name>
<attribute_group_narrative>Container Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="501" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>PageSource</attribute_label>
<attribute_group_obj>347.7063</attribute_group_obj>
<data_type>10</data_type>
<attribute_narrative>The handle of the object&apos;s Page-Source (folder), if any.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>363.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>347.7063</attribute_group_obj>
<attribute_group_name>Container</attribute_group_name>
<attribute_group_narrative>Container Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="502" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>PageTarget</attribute_label>
<attribute_group_obj>3000002003.09</attribute_group_obj>
<data_type>10</data_type>
<attribute_narrative>Link to container for paging</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>3481.66</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="02/10/2003" version_time="59461" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="3000002003.09" record_version_obj="3000002004.09" version_number_seq="1.09" secondary_key_value="ADMAttributes" import_version_number_seq="1.09"><attribute_group_obj>3000002003.09</attribute_group_obj>
<attribute_group_name>ADMAttributes</attribute_group_name>
<attribute_group_narrative>This group contains all attributes of ADM objects excepts those that can also be Widget Attributes. In that case, they are in the WidgetAttribute group.</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="503" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>PageTargetEvents</attribute_label>
<attribute_group_obj>3000002003.09</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Subscribed events from pagetarget</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level>Class</constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>3482.66</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="02/10/2003" version_time="59461" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="3000002003.09" record_version_obj="3000002004.09" version_number_seq="1.09" secondary_key_value="ADMAttributes" import_version_number_seq="1.09"><attribute_group_obj>3000002003.09</attribute_group_obj>
<attribute_group_name>ADMAttributes</attribute_group_name>
<attribute_group_narrative>This group contains all attributes of ADM objects excepts those that can also be Widget Attributes. In that case, they are in the WidgetAttribute group.</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="504" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="03/06/2003" version_time="65763" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="728.7692" record_version_obj="729.7692" version_number_seq="1.09" secondary_key_value="PaletteControl" import_version_number_seq="1.09"><attribute_label>PaletteControl</attribute_label>
<attribute_group_obj>700.7692</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Control information for OCX&apos;s</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>yes</design_only>
<system_owned>no</system_owned>
<attribute_obj>728.7692</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="03/06/2003" version_time="65764" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="700.7692" record_version_obj="701.7692" version_number_seq="1.09" secondary_key_value="Palette" import_version_number_seq="1.09"><attribute_group_obj>700.7692</attribute_group_obj>
<attribute_group_name>Palette</attribute_group_name>
<attribute_group_narrative>Palette group for design only attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="505" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="03/06/2003" version_time="65763" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="730.7692" record_version_obj="731.7692" version_number_seq="1.09" secondary_key_value="PaletteDBConnect" import_version_number_seq="1.09"><attribute_label>PaletteDBConnect</attribute_label>
<attribute_group_obj>700.7692</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>If Yes, specifies the DB must be connected before using this item</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>yes</design_only>
<system_owned>no</system_owned>
<attribute_obj>730.7692</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="03/06/2003" version_time="65764" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="700.7692" record_version_obj="701.7692" version_number_seq="1.09" secondary_key_value="Palette" import_version_number_seq="1.09"><attribute_group_obj>700.7692</attribute_group_obj>
<attribute_group_name>Palette</attribute_group_name>
<attribute_group_narrative>Palette group for design only attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="506" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="03/06/2003" version_time="65763" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="720.7692" record_version_obj="721.7692" version_number_seq="1.09" secondary_key_value="PaletteDirectoryList" import_version_number_seq="1.09"><attribute_label>PaletteDirectoryList</attribute_label>
<attribute_group_obj>700.7692</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Comma delimited list of directories displayed in choose dialog</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>yes</design_only>
<system_owned>no</system_owned>
<attribute_obj>720.7692</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="03/06/2003" version_time="65764" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="700.7692" record_version_obj="701.7692" version_number_seq="1.09" secondary_key_value="Palette" import_version_number_seq="1.09"><attribute_group_obj>700.7692</attribute_group_obj>
<attribute_group_name>Palette</attribute_group_name>
<attribute_group_narrative>Palette group for design only attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="507" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="03/06/2003" version_time="65763" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="1357.7692" record_version_obj="1358.7692" version_number_seq="1.09" secondary_key_value="PaletteEditOnDrop" import_version_number_seq="1.09"><attribute_label>PaletteEditOnDrop</attribute_label>
<attribute_group_obj>700.7692</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Indicates whether to automatically display the property sheet when the object is dropped onto the appBuilder design window.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1357.7692</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="03/06/2003" version_time="65764" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="700.7692" record_version_obj="701.7692" version_number_seq="1.09" secondary_key_value="Palette" import_version_number_seq="1.09"><attribute_group_obj>700.7692</attribute_group_obj>
<attribute_group_name>Palette</attribute_group_name>
<attribute_group_narrative>Palette group for design only attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="508" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="03/06/2003" version_time="65763" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="722.7692" record_version_obj="723.7692" version_number_seq="1.09" secondary_key_value="PaletteFilter" import_version_number_seq="1.09"><attribute_label>PaletteFilter</attribute_label>
<attribute_group_obj>700.7692</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Comma delimited filter lists availabel in the choose dialog (i.e. *.w, d*.p)</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>yes</design_only>
<system_owned>no</system_owned>
<attribute_obj>722.7692</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="03/06/2003" version_time="65764" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="700.7692" record_version_obj="701.7692" version_number_seq="1.09" secondary_key_value="Palette" import_version_number_seq="1.09"><attribute_group_obj>700.7692</attribute_group_obj>
<attribute_group_name>Palette</attribute_group_name>
<attribute_group_narrative>Palette group for design only attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="509" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="03/06/2003" version_time="65763" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="716.7692" record_version_obj="717.7692" version_number_seq="1.09" secondary_key_value="PaletteImageDown" import_version_number_seq="1.09"><attribute_label>PaletteImageDown</attribute_label>
<attribute_group_obj>700.7692</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>This is the down image to use in the palette</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>yes</design_only>
<system_owned>no</system_owned>
<attribute_obj>716.7692</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="03/06/2003" version_time="65764" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="700.7692" record_version_obj="701.7692" version_number_seq="1.09" secondary_key_value="Palette" import_version_number_seq="1.09"><attribute_group_obj>700.7692</attribute_group_obj>
<attribute_group_name>Palette</attribute_group_name>
<attribute_group_narrative>Palette group for design only attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="510" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="03/06/2003" version_time="65763" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="714.7692" record_version_obj="715.7692" version_number_seq="1.09" secondary_key_value="PaletteImageUp" import_version_number_seq="1.09"><attribute_label>PaletteImageUp</attribute_label>
<attribute_group_obj>700.7692</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>This is the Up image to use in the palette</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>yes</design_only>
<system_owned>no</system_owned>
<attribute_obj>714.7692</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="03/06/2003" version_time="65764" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="700.7692" record_version_obj="701.7692" version_number_seq="1.09" secondary_key_value="Palette" import_version_number_seq="1.09"><attribute_group_obj>700.7692</attribute_group_obj>
<attribute_group_name>Palette</attribute_group_name>
<attribute_group_narrative>Palette group for design only attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="511" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="03/06/2003" version_time="65763" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="726.7692" record_version_obj="727.7692" version_number_seq="1.09" secondary_key_value="PaletteIsDefault" import_version_number_seq="1.09"><attribute_label>PaletteIsDefault</attribute_label>
<attribute_group_obj>700.7692</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>If Yes, that item is used as the default when pressing the icon in the palette</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>yes</design_only>
<system_owned>no</system_owned>
<attribute_obj>726.7692</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="03/06/2003" version_time="65764" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="700.7692" record_version_obj="701.7692" version_number_seq="1.09" secondary_key_value="Palette" import_version_number_seq="1.09"><attribute_group_obj>700.7692</attribute_group_obj>
<attribute_group_name>Palette</attribute_group_name>
<attribute_group_narrative>Palette group for design only attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="512" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="03/06/2003" version_time="65764" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="706.7692" record_version_obj="707.7692" version_number_seq="1.09" secondary_key_value="PaletteLabel" import_version_number_seq="1.09"><attribute_label>PaletteLabel</attribute_label>
<attribute_group_obj>700.7692</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Label displayed in drop-down menu. This must be unique.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>yes</design_only>
<system_owned>no</system_owned>
<attribute_obj>706.7692</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="03/06/2003" version_time="65764" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="700.7692" record_version_obj="701.7692" version_number_seq="1.09" secondary_key_value="Palette" import_version_number_seq="1.09"><attribute_group_obj>700.7692</attribute_group_obj>
<attribute_group_name>Palette</attribute_group_name>
<attribute_group_narrative>Palette group for design only attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="513" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="03/06/2003" version_time="65764" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="718.7692" record_version_obj="719.7692" version_number_seq="1.09" secondary_key_value="PaletteNewTemplate" import_version_number_seq="1.09"><attribute_label>PaletteNewTemplate</attribute_label>
<attribute_group_obj>700.7692</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>This is the static file used for rendering smartObjects</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>yes</design_only>
<system_owned>no</system_owned>
<attribute_obj>718.7692</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="03/06/2003" version_time="65764" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="700.7692" record_version_obj="701.7692" version_number_seq="1.09" secondary_key_value="Palette" import_version_number_seq="1.09"><attribute_group_obj>700.7692</attribute_group_obj>
<attribute_group_name>Palette</attribute_group_name>
<attribute_group_narrative>Palette group for design only attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="514" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="03/06/2003" version_time="65764" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="745.7692" record_version_obj="746.7692" version_number_seq="1.09" secondary_key_value="PaletteOrder" import_version_number_seq="1.09"><attribute_label>PaletteOrder</attribute_label>
<attribute_group_obj>700.7692</attribute_group_obj>
<data_type>4</data_type>
<attribute_narrative>Order of palette icon in paltte</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>yes</design_only>
<system_owned>no</system_owned>
<attribute_obj>745.7692</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="03/06/2003" version_time="65764" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="700.7692" record_version_obj="701.7692" version_number_seq="1.09" secondary_key_value="Palette" import_version_number_seq="1.09"><attribute_group_obj>700.7692</attribute_group_obj>
<attribute_group_name>Palette</attribute_group_name>
<attribute_group_narrative>Palette group for design only attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="515" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="03/06/2003" version_time="65764" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="724.7692" record_version_obj="725.7692" version_number_seq="1.09" secondary_key_value="PaletteTitle" import_version_number_seq="1.09"><attribute_label>PaletteTitle</attribute_label>
<attribute_group_obj>700.7692</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Title used in the choose dialog</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>yes</design_only>
<system_owned>no</system_owned>
<attribute_obj>724.7692</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="03/06/2003" version_time="65764" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="700.7692" record_version_obj="701.7692" version_number_seq="1.09" secondary_key_value="Palette" import_version_number_seq="1.09"><attribute_group_obj>700.7692</attribute_group_obj>
<attribute_group_name>Palette</attribute_group_name>
<attribute_group_narrative>Palette group for design only attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="516" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="03/06/2003" version_time="65764" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="708.7692" record_version_obj="709.7692" version_number_seq="1.09" secondary_key_value="PaletteTooltip" import_version_number_seq="1.09"><attribute_label>PaletteTooltip</attribute_label>
<attribute_group_obj>700.7692</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Tooltip used for the palette button. If not defined, the paletteLabel is used.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>yes</design_only>
<system_owned>no</system_owned>
<attribute_obj>708.7692</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="03/06/2003" version_time="65764" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="700.7692" record_version_obj="701.7692" version_number_seq="1.09" secondary_key_value="Palette" import_version_number_seq="1.09"><attribute_group_obj>700.7692</attribute_group_obj>
<attribute_group_name>Palette</attribute_group_name>
<attribute_group_narrative>Palette group for design only attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="517" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="03/06/2003" version_time="65764" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="712.7692" record_version_obj="713.7692" version_number_seq="1.09" secondary_key_value="PaletteTriggerCode" import_version_number_seq="1.09"><attribute_label>PaletteTriggerCode</attribute_label>
<attribute_group_obj>700.7692</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>This is a PIPE delimited list of CODE to write out in the trigger. It must correspond to PaletteTriggerEvent</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>yes</design_only>
<system_owned>no</system_owned>
<attribute_obj>712.7692</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="03/06/2003" version_time="65764" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="700.7692" record_version_obj="701.7692" version_number_seq="1.09" secondary_key_value="Palette" import_version_number_seq="1.09"><attribute_group_obj>700.7692</attribute_group_obj>
<attribute_group_name>Palette</attribute_group_name>
<attribute_group_narrative>Palette group for design only attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="518" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="03/06/2003" version_time="65764" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="710.7692" record_version_obj="711.7692" version_number_seq="1.09" secondary_key_value="PaletteTriggerEvent" import_version_number_seq="1.09"><attribute_label>PaletteTriggerEvent</attribute_label>
<attribute_group_obj>700.7692</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>This is a PIPE delimited list of static trigger events. Must correspond to the number of pipe delimited items in PaletteTriggerCode</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>yes</design_only>
<system_owned>no</system_owned>
<attribute_obj>710.7692</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="03/06/2003" version_time="65764" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="700.7692" record_version_obj="701.7692" version_number_seq="1.09" secondary_key_value="Palette" import_version_number_seq="1.09"><attribute_group_obj>700.7692</attribute_group_obj>
<attribute_group_name>Palette</attribute_group_name>
<attribute_group_narrative>Palette group for design only attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="519" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="03/06/2003" version_time="65764" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="704.7692" record_version_obj="705.7692" version_number_seq="1.09" secondary_key_value="PaletteType" import_version_number_seq="1.09"><attribute_label>PaletteType</attribute_label>
<attribute_group_obj>700.7692</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Type of Palette widget (i.e. Button,Editor, SmartFolder,etc)</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>yes</design_only>
<system_owned>no</system_owned>
<attribute_obj>704.7692</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="03/06/2003" version_time="65764" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="700.7692" record_version_obj="701.7692" version_number_seq="1.09" secondary_key_value="Palette" import_version_number_seq="1.09"><attribute_group_obj>700.7692</attribute_group_obj>
<attribute_group_name>Palette</attribute_group_name>
<attribute_group_narrative>Palette group for design only attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="520" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>PanelFrame</attribute_label>
<attribute_group_obj>438.7063</attribute_group_obj>
<data_type>10</data_type>
<attribute_narrative>Returns the Frame handle of the SmartPanel, for resizeObject.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>662.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>438.7063</attribute_group_obj>
<attribute_group_name>Panel</attribute_group_name>
<attribute_group_narrative>SmartPanel attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="521" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>PanelLabel</attribute_label>
<attribute_group_obj>438.7063</attribute_group_obj>
<data_type>10</data_type>
<attribute_narrative>The handle of the Panel&apos;s Label, if any.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>670.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>438.7063</attribute_group_obj>
<attribute_group_name>Panel</attribute_group_name>
<attribute_group_narrative>SmartPanel attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="522" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>PanelOffset</attribute_label>
<attribute_group_obj>1003183341</attribute_group_obj>
<data_type>4</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1003202032</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="523" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>PanelState</attribute_label>
<attribute_group_obj>438.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Deprecated.</attribute_narrative>
<override_type>set</override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>672.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>438.7063</attribute_group_obj>
<attribute_group_name>Panel</attribute_group_name>
<attribute_group_narrative>SmartPanel attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="524" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>PanelType</attribute_label>
<attribute_group_obj>438.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The type of Panel: Navigation, Save, Update</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>yes</design_only>
<system_owned>yes</system_owned>
<attribute_obj>1003498440</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>438.7063</attribute_group_obj>
<attribute_group_name>Panel</attribute_group_name>
<attribute_group_narrative>SmartPanel attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="525" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>PARENT</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005099269.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="526" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ParentClassSubstitute</attribute_label>
<attribute_group_obj>5.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Temporary (V2) bypass of the repository-defined class hierarchy to accomodate the current ADM2 conditional class parenting.
</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>1283.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>5.7063</attribute_group_obj>
<attribute_group_name>Smart</attribute_group_name>
<attribute_group_narrative>Smart Object common attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="527" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ParentDataKey</attribute_label>
<attribute_group_obj>5.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>68.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>5.7063</attribute_group_obj>
<attribute_group_name>Smart</attribute_group_name>
<attribute_group_narrative>Smart Object common attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="528" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ParentField</attribute_label>
<attribute_group_obj>1005095447.101</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>A field or widget name to a parent field on the viewer that will determine the filter query for a Dynamic Lookup/Dynamic Combo.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005089896.28</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_group_name>SdfAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Smart Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="529" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ParentFilterQuery</attribute_label>
<attribute_group_obj>1005095447.101</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>A Query sting used to filter the Base query of Dynamic Lookups/Dynamic Combos that depends on a parent field.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005089897.28</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_group_name>SdfAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Smart Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="530" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="02/07/2003" version_time="56201" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="18292.66" record_version_obj="18293.66" version_number_seq="1.09" secondary_key_value="PendingPage" import_version_number_seq="1.09"><attribute_label>PendingPage</attribute_label>
<attribute_group_obj>347.7063</attribute_group_obj>
<data_type>4</data_type>
<attribute_narrative>The pending page number is set immediately in selectPage so that objects can check what will become the new current page before the CurrentPage
is set. This was specifically implemented so that hideObject -&gt; linkState  can avoid disabling links for objects that will become active/visible.
It is set to ? when CurrentPage is set. This should ONLY be set by selectPage.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>18292.66</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>347.7063</attribute_group_obj>
<attribute_group_name>Container</attribute_group_name>
<attribute_group_narrative>Container Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="531" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>Persistency</attribute_label>
<attribute_group_obj>507.49</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Stores Persistency value for messages being sent</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>930.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="09/04/2002" version_time="57071" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="507.49" record_version_obj="508.49" version_number_seq="3.49" secondary_key_value="Producer" import_version_number_seq="3.49"><attribute_group_obj>507.49</attribute_group_obj>
<attribute_group_name>Producer</attribute_group_name>
<attribute_group_narrative>SmartProducer attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="532" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>PFCOLOR</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>4</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005099295.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="533" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>PhysicalObjectName</attribute_label>
<attribute_group_obj>5.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>59.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>5.7063</attribute_group_obj>
<attribute_group_name>Smart</attribute_group_name>
<attribute_group_narrative>Smart Object common attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="534" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="09/24/2002" version_time="45909" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="3000031111.09" record_version_obj="3000031112.09" version_number_seq="3.09" secondary_key_value="PhysicalTableNames" import_version_number_seq="3.09"><attribute_label>PhysicalTableNames</attribute_label>
<attribute_group_obj>152.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>This list contains the names of the actual database tables.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>3000031111.09</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>152.7063</attribute_group_obj>
<attribute_group_name>Data</attribute_group_name>
<attribute_group_narrative>SDO Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="535" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>PhysicalVersion</attribute_label>
<attribute_group_obj>5.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level>Class</constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>62.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>5.7063</attribute_group_obj>
<attribute_group_name>Smart</attribute_group_name>
<attribute_group_narrative>Smart Object common attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="536" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>PingInterval</attribute_label>
<attribute_group_obj>731.7063</attribute_group_obj>
<data_type>4</data_type>
<attribute_narrative>The Ping Interval for the JMS session.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>906.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>731.7063</attribute_group_obj>
<attribute_group_name>Messaging</attribute_group_name>
<attribute_group_narrative>Messaging SmartObject attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="537" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>POPUP-MENU</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005099294.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="538" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>PopupActive</attribute_label>
<attribute_group_obj>436.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Determines whether the browse popup is active</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>267.009</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>436.7063</attribute_group_obj>
<attribute_group_name>Browser</attribute_group_name>
<attribute_group_narrative>SmartBrowser attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="539" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="12/06/2002" version_time="51786" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="4.6893" record_version_obj="5.6893" version_number_seq="1.09" secondary_key_value="PopupButtonsInFields" import_version_number_seq="1.09"><attribute_label>PopupButtonsInFields</attribute_label>
<attribute_group_obj>7.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>When set to YES, calendar and calculator popup buttons will be placed inside, on the right hand side of the field.  When NO, the popup button will be placed outside, to the right of the field.
</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>4.6893</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>7.7063</attribute_group_obj>
<attribute_group_name>Visual</attribute_group_name>
<attribute_group_narrative>Visual Smartobject attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="540" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="12/05/2002" version_time="35434" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="18276.66" record_version_obj="18277.66" version_number_seq="1.09" secondary_key_value="PopupOnAmbiguous" import_version_number_seq="1.09"><attribute_label>PopupOnAmbiguous</attribute_label>
<attribute_group_obj>432.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Indicates that the lookup should popup automatically when a field is modified and the value is ambiguous, i.e. partially entered some data and no record could be uniquely identified. The rule is normally applied on the leave event, but some UIs may require a more explicit user action.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>18276.66</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>432.7063</attribute_group_obj>
<attribute_group_name>Field</attribute_group_name>
<attribute_group_narrative>SmartField Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="541" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="12/05/2002" version_time="35434" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="18280.66" record_version_obj="18281.66" version_number_seq="1.09" secondary_key_value="PopupOnNotAvail" import_version_number_seq="1.09"><attribute_label>PopupOnNotAvail</attribute_label>
<attribute_group_obj>432.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Indicates that the lookup should popup automatically when a field is modified and the value does not match any existing record. The rule is normally applied on the leave event, but some UIs may require a more explicit user action.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>18280.66</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>432.7063</attribute_group_obj>
<attribute_group_name>Field</attribute_group_name>
<attribute_group_narrative>SmartField Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="542" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="12/05/2002" version_time="35434" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="18278.66" record_version_obj="18279.66" version_number_seq="1.09" secondary_key_value="PopupOnUniqueAmbiguous" import_version_number_seq="1.09"><attribute_label>PopupOnUniqueAmbiguous</attribute_label>
<attribute_group_obj>432.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Indicates that the lookup should popup automatically when a field is modified and the value uniquely identifies a record, if one or more other records exists that begins with that value. The rule is normally applied on the leave event, but some UIs may require a more explicit user action.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>18278.66</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>432.7063</attribute_group_obj>
<attribute_group_name>Field</attribute_group_name>
<attribute_group_narrative>SmartField Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="543" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="02/10/2003" version_time="59461" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="178000000721.5566" record_version_obj="178000000722.5566" version_number_seq="1.09" secondary_key_value="PopupSelectionEnabled" import_version_number_seq="1.09"><attribute_label>PopupSelectionEnabled</attribute_label>
<attribute_group_obj>3000002003.09</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Set this to TRUE to allow the building of a popup-menu (on MOUSE-MENU-DOWN - right-clicking) in the tab area, of all the tabs available on the SmartFolder sorted in page sequence order. Upon selection of a popup-menu item, the page would be selected. The current page will be shown with a tick mark.

Popup-menu items of disabledPages will be disabled.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type>LIST</lookup_type>
<lookup_value>Yes#CHR(3)#yes#CHR(3)#No#CHR(3)#no</lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>178000000721.5566</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="02/10/2003" version_time="59461" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="3000002003.09" record_version_obj="3000002004.09" version_number_seq="1.09" secondary_key_value="ADMAttributes" import_version_number_seq="1.09"><attribute_group_obj>3000002003.09</attribute_group_obj>
<attribute_group_name>ADMAttributes</attribute_group_name>
<attribute_group_narrative>This group contains all attributes of ADM objects excepts those that can also be Widget Attributes. In that case, they are in the WidgetAttribute group.</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="544" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="02/14/2003" version_time="55416" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="29682.66" record_version_obj="29683.66" version_number_seq="1.09" secondary_key_value="PositionForClient" import_version_number_seq="1.09"><attribute_label>PositionForClient</attribute_label>
<attribute_group_obj>154.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>This property is set on the server and returned to the client so that it is able to position correctly in the new batch of data. The client need this information under certain cicumstances, for example when other settings decides that a full batch of data always is needed.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>29682.66</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>154.7063</attribute_group_obj>
<attribute_group_name>Query</attribute_group_name>
<attribute_group_narrative>Query object attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="545" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>PrimarySDOTarget</attribute_label>
<attribute_group_obj>347.7063</attribute_group_obj>
<data_type>10</data_type>
<attribute_narrative>The handle of the &apos;master&apos; SDO in an SBO container.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>396.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>347.7063</attribute_group_obj>
<attribute_group_name>Container</attribute_group_name>
<attribute_group_narrative>Container Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="546" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>PrintPreviewActive</attribute_label>
<attribute_group_obj>436.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Indicates whether print preview functionality is active.
The &apos;get&apos; function for this property starts an OLE object (Crystal).</attribute_narrative>
<override_type>get</override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>501.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>436.7063</attribute_group_obj>
<attribute_group_name>Browser</attribute_group_name>
<attribute_group_narrative>SmartBrowser attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="547" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>Priority</attribute_label>
<attribute_group_obj>507.49</attribute_group_obj>
<data_type>4</data_type>
<attribute_narrative>Priority value for messages being sent</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>932.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="09/04/2002" version_time="57071" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="507.49" record_version_obj="508.49" version_number_seq="3.49" secondary_key_value="Producer" import_version_number_seq="3.49"><attribute_group_obj>507.49</attribute_group_obj>
<attribute_group_name>Producer</attribute_group_name>
<attribute_group_narrative>SmartProducer attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="548" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>PRIVATE-DATA</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005099265.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="549" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>PROGRESS-SOURCE</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005099300.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="550" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>PromptColumns</attribute_label>
<attribute_group_obj>152.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Specifies contents of a standard message prompt like the confirm delete. Values is &apos;(None)&apos;, &apos;(All)&apos; or a specific list of columns.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>200000003021.66</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>152.7063</attribute_group_obj>
<attribute_group_name>Data</attribute_group_name>
<attribute_group_narrative>SDO Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="551" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>PromptLogin</attribute_label>
<attribute_group_obj>731.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>This property determines whether the producer or consumer will prompt the user for JMS broker login.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>908.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>731.7063</attribute_group_obj>
<attribute_group_name>Messaging</attribute_group_name>
<attribute_group_narrative>Messaging SmartObject attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="552" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>PromptOnDelete</attribute_label>
<attribute_group_obj>152.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Specifies whether a delete requires a prompt to confirm the deletion.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type>LIST</lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>200000003019.66</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>152.7063</attribute_group_obj>
<attribute_group_name>Data</attribute_group_name>
<attribute_group_narrative>SDO Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="553" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>PropertyDialog</attribute_label>
<attribute_group_obj>5.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The name of the dialog procedure that sets &apos;InstanceProperties&apos;.
This property is usually used only internally, but must be callable
from the AppBuilder to determine whether to enable the InstanceProperties menu item.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level>Class</constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>21.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>5.7063</attribute_group_obj>
<attribute_group_name>Smart</attribute_group_name>
<attribute_group_narrative>Smart Object common attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="554" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>QueryBuilderDBNames</attribute_label>
<attribute_group_obj>154.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Design only attribute string containing query information to support calculated fields in SDOs</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>yes</design_only>
<system_owned>no</system_owned>
<attribute_obj>20023.409</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>154.7063</attribute_group_obj>
<attribute_group_name>Query</attribute_group_name>
<attribute_group_narrative>Query object attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="555" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>QueryBuilderFieldDataTypes</attribute_label>
<attribute_group_obj>154.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Design only attribute string containing query information to support calculated fields in SDOs</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>yes</design_only>
<system_owned>no</system_owned>
<attribute_obj>20021.409</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>154.7063</attribute_group_obj>
<attribute_group_name>Query</attribute_group_name>
<attribute_group_narrative>Query object attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="556" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>QueryBuilderFieldFormatList</attribute_label>
<attribute_group_obj>154.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Design Only string containing the current SDO field formats to support AppBuilder SDO editor</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>yes</design_only>
<system_owned>no</system_owned>
<attribute_obj>19719.409</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>154.7063</attribute_group_obj>
<attribute_group_name>Query</attribute_group_name>
<attribute_group_narrative>Query object attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="557" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>QueryBuilderFieldHelp</attribute_label>
<attribute_group_obj>154.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Design only attribute string containing query information to support customer helps strings in SDOs</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>yes</design_only>
<system_owned>no</system_owned>
<attribute_obj>20027.409</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>154.7063</attribute_group_obj>
<attribute_group_name>Query</attribute_group_name>
<attribute_group_narrative>Query object attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="558" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>QueryBuilderFieldLabelList</attribute_label>
<attribute_group_obj>154.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Design Only string containing the current SDO labels to support AppBuilder SDO editor</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>yes</design_only>
<system_owned>no</system_owned>
<attribute_obj>19717.409</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>154.7063</attribute_group_obj>
<attribute_group_name>Query</attribute_group_name>
<attribute_group_narrative>Query object attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="559" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>QueryBuilderFieldWidths</attribute_label>
<attribute_group_obj>154.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Design only attribute string containing query information to support custom field widths in SDOs</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>yes</design_only>
<system_owned>no</system_owned>
<attribute_obj>20029.409</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>154.7063</attribute_group_obj>
<attribute_group_name>Query</attribute_group_name>
<attribute_group_narrative>Query object attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="560" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>QueryBuilderInheritValidations</attribute_label>
<attribute_group_obj>154.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Design only attribute string containing query information to support SDOs</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>yes</design_only>
<system_owned>no</system_owned>
<attribute_obj>20031.409</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>154.7063</attribute_group_obj>
<attribute_group_name>Query</attribute_group_name>
<attribute_group_narrative>Query object attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="561" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>QueryBuilderJoinCode</attribute_label>
<attribute_group_obj>154.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Design Only string containing the current query join information to support AppBuilder Query Builder</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>yes</design_only>
<system_owned>no</system_owned>
<attribute_obj>19725.409</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>154.7063</attribute_group_obj>
<attribute_group_name>Query</attribute_group_name>
<attribute_group_narrative>Query object attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="562" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>QueryBuilderOptionList</attribute_label>
<attribute_group_obj>154.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Design Only string containing the current query option to support AppBuilder Query Builder</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>yes</design_only>
<system_owned>no</system_owned>
<attribute_obj>19723.409</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>154.7063</attribute_group_obj>
<attribute_group_name>Query</attribute_group_name>
<attribute_group_narrative>Query object attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="563" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>QueryBuilderOrderList</attribute_label>
<attribute_group_obj>154.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Design Only string containing the current query break by and by clauses to support AppBuilder Query Builder</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>yes</design_only>
<system_owned>no</system_owned>
<attribute_obj>19721.409</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>154.7063</attribute_group_obj>
<attribute_group_name>Query</attribute_group_name>
<attribute_group_narrative>Query object attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="564" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>QueryBuilderTableList</attribute_label>
<attribute_group_obj>154.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Design Only string containing the current table list  to support AppBuilder Query Builder</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>yes</design_only>
<system_owned>no</system_owned>
<attribute_obj>6140.009</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>154.7063</attribute_group_obj>
<attribute_group_name>Query</attribute_group_name>
<attribute_group_narrative>Query object attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="565" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>QueryBuilderTableOptionList</attribute_label>
<attribute_group_obj>154.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Design Only string containing the current query table options to support AppBuilder Query Builder</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>yes</design_only>
<system_owned>no</system_owned>
<attribute_obj>19727.409</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>154.7063</attribute_group_obj>
<attribute_group_name>Query</attribute_group_name>
<attribute_group_narrative>Query object attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="566" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>QueryBuilderTuneOptions</attribute_label>
<attribute_group_obj>154.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Design Only string containing the current query tuning options to support AppBuilder Query Builder</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>yes</design_only>
<system_owned>no</system_owned>
<attribute_obj>19731.409</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>154.7063</attribute_group_obj>
<attribute_group_name>Query</attribute_group_name>
<attribute_group_narrative>Query object attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="567" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>QueryBuilderWhereClauses</attribute_label>
<attribute_group_obj>154.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Design Only string containing the current query where clauses to support AppBuilder Query Builder</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>yes</design_only>
<system_owned>no</system_owned>
<attribute_obj>19729.409</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>154.7063</attribute_group_obj>
<attribute_group_name>Query</attribute_group_name>
<attribute_group_narrative>Query object attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="568" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>QueryColumns</attribute_label>
<attribute_group_obj>154.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Keeps track of the position for each column/operator combination added with assignQuerySelection.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>yes</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>525.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>154.7063</attribute_group_obj>
<attribute_group_name>Query</attribute_group_name>
<attribute_group_narrative>Query object attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="569" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>QueryContainer</attribute_label>
<attribute_group_obj>152.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Indicates whether our Container is itself a QueryObject. It is used to determine whether we&apos;re in an SBO which handles the transaction for us.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>206.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>152.7063</attribute_group_obj>
<attribute_group_name>Data</attribute_group_name>
<attribute_group_narrative>SDO Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="570" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>QueryContext</attribute_label>
<attribute_group_obj>152.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Stores the Query Context on the Client. For internal use only.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>211.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>152.7063</attribute_group_obj>
<attribute_group_name>Data</attribute_group_name>
<attribute_group_narrative>SDO Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="571" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>QueryHandle</attribute_label>
<attribute_group_obj>154.7063</attribute_group_obj>
<data_type>10</data_type>
<attribute_narrative>The handle of the database query.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>515.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>154.7063</attribute_group_obj>
<attribute_group_name>Query</attribute_group_name>
<attribute_group_narrative>Query object attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="572" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>QueryObject</attribute_label>
<attribute_group_obj>5.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>23.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>5.7063</attribute_group_obj>
<attribute_group_name>Smart</attribute_group_name>
<attribute_group_narrative>Smart Object common attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="573" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>QueryPosition</attribute_label>
<attribute_group_obj>154.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Valid return values are:
FirstRecord, LastRecord, NotFirstOrLast, NoRecordAvailable and NoRecordAvailableExt</attribute_narrative>
<override_type>set</override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>509.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>154.7063</attribute_group_obj>
<attribute_group_name>Query</attribute_group_name>
<attribute_group_narrative>Query object attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="574" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>QueryRowIdent</attribute_label>
<attribute_group_obj>154.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Rowid or comma-separated list of Rowids of the database record(s) to be positioned to.
Generally used to save the position of a query when it is closed so that position can be restored on re-open.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>517.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>154.7063</attribute_group_obj>
<attribute_group_name>Query</attribute_group_name>
<attribute_group_narrative>Query object attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="575" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>QueryRowObject</attribute_label>
<attribute_group_obj>436.7063</attribute_group_obj>
<data_type>10</data_type>
<attribute_narrative>The buffer handle of the RowObject temp-table associated with the browse&apos;s query.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>494.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>436.7063</attribute_group_obj>
<attribute_group_name>Browser</attribute_group_name>
<attribute_group_narrative>SmartBrowser attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="576" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>QueryString</attribute_label>
<attribute_group_obj>154.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Working storage for all query manipulation methods.
If the QueryString property has not been set then the current where clause will be used (QueryWhere).
If there&apos;s no current QueryWhere then the design where clause will be used (OpenQuery) -&gt; (BaseQuery). 
The openQuery will call prepareQuery with the value.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>523.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>154.7063</attribute_group_obj>
<attribute_group_name>Query</attribute_group_name>
<attribute_group_narrative>Query object attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="577" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>QueryTables</attribute_label>
<attribute_group_obj>1005095447.101</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Comma list of query tables for Dynamic Lookups/Dynamic Combos (Buffers)</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005089875.28</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_group_name>SdfAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Smart Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="578" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="06/19/2002" version_time="44549" version_user="ross" deletion_flag="no" entity_mnemonic="rycat" key_field_value="13483.409" record_version_obj="13484.409" version_number_seq="2.409" secondary_key_value="RADIO-BUTTONS" import_version_number_seq="2.409"><attribute_label>RADIO-BUTTONS</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Label- value pairs of a radio-set</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>13483.409</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="579" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>READ-ONLY</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005099280.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="580" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="03/12/2003" version_time="66448" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="32996.66" record_version_obj="32997.66" version_number_seq="1.09" secondary_key_value="ReadOnly" import_version_number_seq="1.09"><attribute_label>ReadOnly</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Set to true if the field never should be updated.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>32996.66</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="581" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>RebuildOnRepos</attribute_label>
<attribute_group_obj>152.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>If TRUE, the RowObject temp-table will be rebuilt when a reposition is done which is outside the bounds of the current result set.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>1003183468</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>152.7063</attribute_group_obj>
<attribute_group_name>Data</attribute_group_name>
<attribute_group_narrative>SDO Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="582" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>RecordState</attribute_label>
<attribute_group_obj>9.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Indicates whether a record is available or not.
Possible values are: RecordAvailable, NoRecorAvailable</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>114.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>9.7063</attribute_group_obj>
<attribute_group_name>DataVisual</attribute_group_name>
<attribute_group_narrative>Data visualization object attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="583" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ReEnableDataLinks</attribute_label>
<attribute_group_obj>347.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Not in use</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>408.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>347.7063</attribute_group_obj>
<attribute_group_name>Container</attribute_group_name>
<attribute_group_narrative>Container Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="584" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="03/07/2003" version_time="63471" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="36466.48" record_version_obj="36467.48" version_number_seq="1.09" secondary_key_value="ReplicateEntityMnemonic" import_version_number_seq="1.09"><attribute_label>ReplicateEntityMnemonic</attribute_label>
<attribute_group_obj>36427.48</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>If SCM data versioning is to be enabled for this entity, then the FLA of the primary replication table should be specified, e.g. RYCSO for the ryc_smartobject table.
For the primary table, the entity_mnemonic and this field will be the same.
This field corresponds to the entity level UDP setup in ERwin as ReplicateFLA.
If this field is defined and scm checking is enabled via the flag in the security control table, then modifications to data in this table will be prevented without a valid task</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>36466.48</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="03/12/2003" version_time="66443" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="36427.48" record_version_obj="36428.48" version_number_seq="1.09" secondary_key_value="EntityAttributes" import_version_number_seq="1.09"><attribute_group_obj>36427.48</attribute_group_obj>
<attribute_group_name>EntityAttributes</attribute_group_name>
<attribute_group_narrative>This group contains attributes that are associated with entities. The attributes in this group correspond exactly to the field names in the GSC_ENTITY_MNEMONIC table, excpet that they have had the underscores removed. This convention is used so that it is possible to generically and quickly populate the attributes.</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="585" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="03/07/2003" version_time="63471" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="36468.48" record_version_obj="36469.48" version_number_seq="1.09" secondary_key_value="ReplicateKey" import_version_number_seq="1.09"><attribute_label>ReplicateKey</attribute_label>
<attribute_group_obj>36427.48</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>This field is only applicable if the replicate_entity_mnemonic field has been specified turning on SCM data versioning for this entity.This is the join field to the primary replication table being versioned Usually this will be the same field as the primary key of the primary table, e.g. smartobject_obj, but if the foreign key field has been role named, as is the case with page table, it could be something else, e.g. container_smartobject_obj. Multiple primary key fields are supported.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>36468.48</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="03/12/2003" version_time="66443" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="36427.48" record_version_obj="36428.48" version_number_seq="1.09" secondary_key_value="EntityAttributes" import_version_number_seq="1.09"><attribute_group_obj>36427.48</attribute_group_obj>
<attribute_group_name>EntityAttributes</attribute_group_name>
<attribute_group_narrative>This group contains attributes that are associated with entities. The attributes in this group correspond exactly to the field names in the GSC_ENTITY_MNEMONIC table, excpet that they have had the underscores removed. This convention is used so that it is possible to generically and quickly populate the attributes.</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="586" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ReplyConsumer</attribute_label>
<attribute_group_obj>507.49</attribute_group_obj>
<data_type>10</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>928.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="09/04/2002" version_time="57071" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="507.49" record_version_obj="508.49" version_number_seq="3.49" secondary_key_value="Producer" import_version_number_seq="3.49"><attribute_group_obj>507.49</attribute_group_obj>
<attribute_group_name>Producer</attribute_group_name>
<attribute_group_narrative>SmartProducer attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="587" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ReplyReqList</attribute_label>
<attribute_group_obj>515.49</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Stores the list of Reply Required flags this B2B uses as a producer to determine if a reply is required for an outgoing message.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>853.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="09/04/2002" version_time="57075" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="515.49" record_version_obj="516.49" version_number_seq="2.49" secondary_key_value="B2B" import_version_number_seq="2.49"><attribute_group_obj>515.49</attribute_group_obj>
<attribute_group_name>B2B</attribute_group_name>
<attribute_group_narrative>SmartB2B attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="588" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ReplyRequired</attribute_label>
<attribute_group_obj>509.49</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Stores the Reply Required flag for the current message</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>918.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="09/04/2002" version_time="57055" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="509.49" record_version_obj="510.49" version_number_seq="2.49" secondary_key_value="MsgHandler" import_version_number_seq="2.49"><attribute_group_obj>509.49</attribute_group_obj>
<attribute_group_name>MsgHandler</attribute_group_name>
<attribute_group_narrative>Message Handler attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="589" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ReplySelector</attribute_label>
<attribute_group_obj>509.49</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The Reply Selector for the current message</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>920.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="09/04/2002" version_time="57055" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="509.49" record_version_obj="510.49" version_number_seq="2.49" secondary_key_value="MsgHandler" import_version_number_seq="2.49"><attribute_group_obj>509.49</attribute_group_obj>
<attribute_group_name>MsgHandler</attribute_group_name>
<attribute_group_narrative>Message Handler attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="590" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>RepositionDataSource</attribute_label>
<attribute_group_obj>434.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Set to true if the data-source is to be repositioned on VALUE-CHANGED. 
This is not needed for the view-as browse option.
This must be set to true if for example the data-source also 
 is a data-source for other objects and those objects need to be 
refreshed when a value is changed in the combo-box.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>602.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>434.7063</attribute_group_obj>
<attribute_group_name>Select</attribute_group_name>
<attribute_group_narrative>SmartSelect attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="591" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>RequiredProperties</attribute_label>
<attribute_group_obj>3000002003.09</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Properties that are required to run an object. These properties has to be defined at object or instance level and must be set in the object to be 
able to run it.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>121</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="02/10/2003" version_time="59461" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="3000002003.09" record_version_obj="3000002004.09" version_number_seq="1.09" secondary_key_value="ADMAttributes" import_version_number_seq="1.09"><attribute_group_obj>3000002003.09</attribute_group_obj>
<attribute_group_name>ADMAttributes</attribute_group_name>
<attribute_group_narrative>This group contains all attributes of ADM objects excepts those that can also be Widget Attributes. In that case, they are in the WidgetAttribute group.</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="592" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>RESIZABLE</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005099270.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="593" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ResizeHorizontal</attribute_label>
<attribute_group_obj>7.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Indicates if an object is Horizontally Resizable.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>102.28</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>7.7063</attribute_group_obj>
<attribute_group_name>Visual</attribute_group_name>
<attribute_group_narrative>Visual Smartobject attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="594" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ResizeVertical</attribute_label>
<attribute_group_obj>7.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Indicates if an object is Vertically Resizable.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>103.28</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>7.7063</attribute_group_obj>
<attribute_group_name>Visual</attribute_group_name>
<attribute_group_narrative>Visual Smartobject attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="595" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="06/19/2002" version_time="44549" version_user="ross" deletion_flag="no" entity_mnemonic="rycat" key_field_value="13473.409" record_version_obj="13474.409" version_number_seq="2.409" secondary_key_value="RETAIN-SHAPE" import_version_number_seq="2.409"><attribute_label>RETAIN-SHAPE</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>When TRUE, IMAGES automatically maintain a constant aspect ratio.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>13473.409</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="596" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>RETURN-INSERTED</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005099302.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="597" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="03/07/2003" version_time="63471" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="36470.48" record_version_obj="36471.48" version_number_seq="1.09" secondary_key_value="ReuseDeletedKeys" import_version_number_seq="1.09"><attribute_label>ReuseDeletedKeys</attribute_label>
<attribute_group_obj>36427.48</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>This flag is only relevant for entities that have record versioning enabled and the table has obj field is true - i.e. this is a table that has an object id field and some other unique key field(s). If this flag is set to YES, then if a record is created with a key value that has been previously deleted, then the new record will be created with the deleted records object id and key value, ensuring the link between a key value and an object id are never broken.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>36470.48</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="03/12/2003" version_time="66443" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="36427.48" record_version_obj="36428.48" version_number_seq="1.09" secondary_key_value="EntityAttributes" import_version_number_seq="1.09"><attribute_group_obj>36427.48</attribute_group_obj>
<attribute_group_name>EntityAttributes</attribute_group_name>
<attribute_group_narrative>This group contains attributes that are associated with entities. The attributes in this group correspond exactly to the field names in the GSC_ENTITY_MNEMONIC table, excpet that they have had the underscores removed. This convention is used so that it is possible to generically and quickly populate the attributes.</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="598" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>RightToLeft</attribute_label>
<attribute_group_obj>438.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>678.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>438.7063</attribute_group_obj>
<attribute_group_name>Panel</attribute_group_name>
<attribute_group_narrative>SmartPanel attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="599" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>RootNodeCode</attribute_label>
<attribute_group_obj>1005097792.101</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The Root Node Code to be used when populating a SmartTreeView object on a Dynamic TreeView object.</attribute_narrative>
<override_type>SET</override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005081437.28</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005097792.101</attribute_group_obj>
<attribute_group_name>TreeView</attribute_group_name>
<attribute_group_narrative>TreeView Group</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="600" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>RouterSource</attribute_label>
<attribute_group_obj>513.49</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Stores a list of handles for router-source objects.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>940.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="09/04/2002" version_time="57056" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="513.49" record_version_obj="514.49" version_number_seq="2.49" secondary_key_value="Router" import_version_number_seq="2.49"><attribute_group_obj>513.49</attribute_group_obj>
<attribute_group_name>Router</attribute_group_name>
<attribute_group_narrative>SmartRouter attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="601" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>RouterTarget</attribute_label>
<attribute_group_obj>505.49</attribute_group_obj>
<data_type>10</data_type>
<attribute_narrative>The handle of the RouterTarget</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>886.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="09/04/2002" version_time="57079" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="505.49" record_version_obj="506.49" version_number_seq="3.49" secondary_key_value="Consumer" import_version_number_seq="3.49"><attribute_group_obj>505.49</attribute_group_obj>
<attribute_group_name>Consumer</attribute_group_name>
<attribute_group_narrative>SmartConsumer attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="602" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="10/03/2002" version_time="45358" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="1005078420.09" record_version_obj="5105.66" version_number_seq="1.66" secondary_key_value="ROW" import_version_number_seq="1.66"><attribute_label>ROW</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>5</data_type>
<attribute_narrative>Row position.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005078420.09</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="603" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ROW-HEIGHT-CHARS</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>5</data_type>
<attribute_narrative>Height of a row in a browse or down frame</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>14664.409</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="604" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ROW-MARKERS</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Browser will have row markers on the left side</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>14666.409</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="605" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ROW-RESIZABLE</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Browser&apos;s row can be resized at run-time</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>14668.409</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="606" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>RowIdent</attribute_label>
<attribute_group_obj>9.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The RowIdent of the current row in the visualization.
The DB rowids may be stored as the second entry of the list, if the updateTarget is an SDO.
When connected to an SBO the rowids returned are a semi-colon separated list corresponding to the SBOs DataObjectNames, if the SBO is a valid UpdateTarget the rowids are for the UpdateTargetNames, otherwise the DataSourceNames are used.</attribute_narrative>
<override_type>get</override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>100.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>9.7063</attribute_group_obj>
<attribute_group_name>DataVisual</attribute_group_name>
<attribute_group_narrative>Data visualization object attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="607" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>RowObject</attribute_label>
<attribute_group_obj>152.7063</attribute_group_obj>
<data_type>10</data_type>
<attribute_narrative>The handle of the RowObject Temp-Table buffer</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>156.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>152.7063</attribute_group_obj>
<attribute_group_name>Data</attribute_group_name>
<attribute_group_narrative>SDO Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="608" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>RowObjectState</attribute_label>
<attribute_group_obj>152.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Signals whether there are uncommitted updates in the object.
The two possible return values are: &apos;NoUpdates&apos; and &apos;RowUpdated&apos;</attribute_narrative>
<override_type>set</override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>197.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>152.7063</attribute_group_obj>
<attribute_group_name>Data</attribute_group_name>
<attribute_group_narrative>SDO Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="609" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>RowObjectTable</attribute_label>
<attribute_group_obj>152.7063</attribute_group_obj>
<data_type>10</data_type>
<attribute_narrative>This is the handle to the temp-table itself, not its buffer.
Supports dynamic SDO (not valid RowObject) by also setting RowObject and DataHandle if it is unknown or different.</attribute_narrative>
<override_type>set</override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>162.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>152.7063</attribute_group_obj>
<attribute_group_name>Data</attribute_group_name>
<attribute_group_narrative>SDO Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="610" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>RowObjUpd</attribute_label>
<attribute_group_obj>152.7063</attribute_group_obj>
<data_type>10</data_type>
<attribute_narrative>The handle of the RowObjUpd Temp-Table buffer</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>158.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>152.7063</attribute_group_obj>
<attribute_group_name>Data</attribute_group_name>
<attribute_group_narrative>SDO Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="611" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>RowObjUpdTable</attribute_label>
<attribute_group_obj>152.7063</attribute_group_obj>
<data_type>10</data_type>
<attribute_narrative>This is the handle to the temp-table itself, not its buffer.
Supports dynamic SDO (not valid RowObject) by also setting RowObject and DataHandle if it is unknown or different.</attribute_narrative>
<override_type>set</override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>160.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>152.7063</attribute_group_obj>
<attribute_group_name>Data</attribute_group_name>
<attribute_group_narrative>SDO Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="612" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>RowsToBatch</attribute_label>
<attribute_group_obj>152.7063</attribute_group_obj>
<data_type>4</data_type>
<attribute_narrative>The number of rows to be transferred from the database query into the RowObject temp-table at a time.
Setting RowsToBatch to 0 indicates that ALL records should be  read.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>1003183464</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>152.7063</attribute_group_obj>
<attribute_group_name>Data</attribute_group_name>
<attribute_group_narrative>SDO Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="613" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>RunAttribute</attribute_label>
<attribute_group_obj>5.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>64.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>5.7063</attribute_group_obj>
<attribute_group_name>Smart</attribute_group_name>
<attribute_group_narrative>Smart Object common attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="614" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>RunDOOptions</attribute_label>
<attribute_group_obj>347.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>A comma-separated list with options that determine how Data Objects are run from constructObject
The options available are:
     dynamicOnly - this runs dynamic data objects only and supercedes all other options
     sourceSearch - this searches for source code if rcode is not found 
    clientOnly - this runs proxy (_cl) code only (for both rcode and source code)</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>375.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>347.7063</attribute_group_obj>
<attribute_group_name>Container</attribute_group_name>
<attribute_group_narrative>Container Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="615" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>RunMultiple</attribute_label>
<attribute_group_obj>347.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>369.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>347.7063</attribute_group_obj>
<attribute_group_name>Container</attribute_group_name>
<attribute_group_narrative>Container Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="616" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>SavedColumnData</attribute_label>
<attribute_group_obj>436.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Stores saved column data for setting column positions and sizes, format is

column1ame CHR(4) column1width CHR(3) column2name CHR(4) column2width, etc...</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>269.009</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>436.7063</attribute_group_obj>
<attribute_group_name>Browser</attribute_group_name>
<attribute_group_narrative>SmartBrowser attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="617" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>SavedContainerMode</attribute_label>
<attribute_group_obj>347.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>388.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>347.7063</attribute_group_obj>
<attribute_group_name>Container</attribute_group_name>
<attribute_group_narrative>Container Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="618" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>SaveSource</attribute_label>
<attribute_group_obj>9.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Used internally to indicate the state of the Tableio-Source. TRUE if the Tableio-Source is a &apos;Save&apos; and false if &apos;Update&apos;.
Can be set to FALSE to override the default enabling of a viewer that has an Update-Source, but has no Tableio-Source</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>112.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>9.7063</attribute_group_obj>
<attribute_group_name>DataVisual</attribute_group_name>
<attribute_group_narrative>Data visualization object attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="619" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="03/12/2003" version_time="66448" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="32980.66" record_version_obj="32981.66" version_number_seq="1.09" secondary_key_value="SCHEMA-CASE-SENSITIVE" import_version_number_seq="1.09"><attribute_label>SCHEMA-CASE-SENSITIVE</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>The Case Sensitive flag imported from the Data Dictionary.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>yes</design_only>
<system_owned>yes</system_owned>
<attribute_obj>32980.66</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="620" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>SCHEMA-COLUMN-LABEL</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The column-label imported from the Data Dictionary.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>yes</design_only>
<system_owned>yes</system_owned>
<attribute_obj>4317.66</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="621" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="03/12/2003" version_time="66448" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="32976.66" record_version_obj="32977.66" version_number_seq="1.09" secondary_key_value="SCHEMA-DECIMALS" import_version_number_seq="1.09"><attribute_label>SCHEMA-DECIMALS</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>4</data_type>
<attribute_narrative>The Decimals value imported from the Data Dictionary.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>yes</design_only>
<system_owned>yes</system_owned>
<attribute_obj>32976.66</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="622" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="03/12/2003" version_time="66448" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="32978.66" record_version_obj="32979.66" version_number_seq="1.09" secondary_key_value="SCHEMA-DESCRIPTION" import_version_number_seq="1.09"><attribute_label>SCHEMA-DESCRIPTION</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The Description imported from the Data Dictionary.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>yes</design_only>
<system_owned>yes</system_owned>
<attribute_obj>32978.66</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="623" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>SCHEMA-FORMAT</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The format imported from the Data Dictionary.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>yes</design_only>
<system_owned>yes</system_owned>
<attribute_obj>4313.66</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="624" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>SCHEMA-HELP</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The help imported from the Data Dictionary.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level>Master</constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>yes</design_only>
<system_owned>yes</system_owned>
<attribute_obj>4311.66</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="625" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>SCHEMA-INITIAL</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The initial value imported from the Data Dictionary.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level>Master</constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>yes</design_only>
<system_owned>yes</system_owned>
<attribute_obj>4319.66</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="626" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>SCHEMA-LABEL</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The label imported from the Data Dictionary.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>yes</design_only>
<system_owned>yes</system_owned>
<attribute_obj>4315.66</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="627" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="03/12/2003" version_time="66448" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="32974.66" record_version_obj="32975.66" version_number_seq="1.09" secondary_key_value="SCHEMA-MANDATORY" import_version_number_seq="1.09"><attribute_label>SCHEMA-MANDATORY</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>The Mandatory flag imported from the Data Dictionary.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>yes</design_only>
<system_owned>yes</system_owned>
<attribute_obj>32974.66</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="628" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="03/12/2003" version_time="66448" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="32982.66" record_version_obj="32983.66" version_number_seq="1.09" secondary_key_value="SCHEMA-ORDER" import_version_number_seq="1.09"><attribute_label>SCHEMA-ORDER</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>4</data_type>
<attribute_narrative>The Order imported from the Data Dictionary.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>yes</design_only>
<system_owned>yes</system_owned>
<attribute_obj>32982.66</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="629" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>SCHEMA-VALIDATE-EXPRESSION</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The validate expression imported from the Data Dictionary.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level>Master</constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>yes</design_only>
<system_owned>yes</system_owned>
<attribute_obj>4321.66</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="630" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>SCHEMA-VALIDATE-MESSAGE</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The validate message imported from the Data Dictionary.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level>Master</constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>yes</design_only>
<system_owned>yes</system_owned>
<attribute_obj>4325.66</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="631" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>SCHEMA-VIEW-AS</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The view-as expression imported from the Data Dictionary.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level>Master</constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>yes</design_only>
<system_owned>yes</system_owned>
<attribute_obj>4327.66</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="632" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>SchemaHandle</attribute_label>
<attribute_group_obj>515.49</attribute_group_obj>
<data_type>10</data_type>
<attribute_narrative>Stores the handle of the loaded XML mapping schema</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>855.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="09/04/2002" version_time="57075" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="515.49" record_version_obj="516.49" version_number_seq="2.49" secondary_key_value="B2B" import_version_number_seq="2.49"><attribute_group_obj>515.49</attribute_group_obj>
<attribute_group_name>B2B</attribute_group_name>
<attribute_group_narrative>SmartB2B attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="633" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>SchemaList</attribute_label>
<attribute_group_obj>515.49</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The list of Schemas this B2B uses.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>862.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="09/04/2002" version_time="57075" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="515.49" record_version_obj="516.49" version_number_seq="2.49" secondary_key_value="B2B" import_version_number_seq="2.49"><attribute_group_obj>515.49</attribute_group_obj>
<attribute_group_name>B2B</attribute_group_name>
<attribute_group_narrative>SmartB2B attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="634" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>SchemaName</attribute_label>
<attribute_group_obj>515.49</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>860.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="09/04/2002" version_time="57075" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="515.49" record_version_obj="516.49" version_number_seq="2.49" secondary_key_value="B2B" import_version_number_seq="2.49"><attribute_group_obj>515.49</attribute_group_obj>
<attribute_group_name>B2B</attribute_group_name>
<attribute_group_narrative>SmartB2B attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="635" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="03/07/2003" version_time="63471" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="36472.48" record_version_obj="36473.48" version_number_seq="1.09" secondary_key_value="ScmFieldName" import_version_number_seq="1.09"><attribute_label>ScmFieldName</attribute_label>
<attribute_group_obj>36427.48</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>This field is only applicable if the replicate_entity_mnemonic field has been specified turning on SCM data versioning for this entity
This is only required for the primary entity being versioned and is the unique field for the data that is also used as the object name in the SCM Tool. E.g. for ryc_smartobject this would be the object_filename, but in other tables it may be some unique reference field that identifies the data.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>36472.48</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="03/12/2003" version_time="66443" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="36427.48" record_version_obj="36428.48" version_number_seq="1.09" secondary_key_value="EntityAttributes" import_version_number_seq="1.09"><attribute_group_obj>36427.48</attribute_group_obj>
<attribute_group_name>EntityAttributes</attribute_group_name>
<attribute_group_narrative>This group contains attributes that are associated with entities. The attributes in this group correspond exactly to the field names in the GSC_ENTITY_MNEMONIC table, excpet that they have had the underscores removed. This convention is used so that it is possible to generically and quickly populate the attributes.</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="636" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>SCREEN-VALUE</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005099299.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="637" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>Scroll</attribute_label>
<attribute_group_obj>3000002003.09</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Scroll property of the tree.</attribute_narrative>
<override_type>SET</override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>3516.66</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="02/10/2003" version_time="59461" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="3000002003.09" record_version_obj="3000002004.09" version_number_seq="1.09" secondary_key_value="ADMAttributes" import_version_number_seq="1.09"><attribute_group_obj>3000002003.09</attribute_group_obj>
<attribute_group_name>ADMAttributes</attribute_group_name>
<attribute_group_narrative>This group contains all attributes of ADM objects excepts those that can also be Widget Attributes. In that case, they are in the WidgetAttribute group.</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="638" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>SCROLLABLE</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Frame attribute to allow a down frame to scroll</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>14823.409</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="639" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>SCROLLBAR-HORIZONTAL</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005099273.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="640" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>SCROLLBAR-VERTICAL</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005099274.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="641" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ScrollRemote</attribute_label>
<attribute_group_obj>436.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>492.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>436.7063</attribute_group_obj>
<attribute_group_name>Browser</attribute_group_name>
<attribute_group_narrative>SmartBrowser attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="642" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>SDFFileName</attribute_label>
<attribute_group_obj>1005095447.101</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The SmarObject file name of the file used for the SmartLookupObject/SmartComboObject.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005089865.28</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_group_name>SdfAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Smart Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="643" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>SDFTemplate</attribute_label>
<attribute_group_obj>1005095447.101</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The template SmartObject used to create a Dynamic Lookup/Dynamic Combo.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005090095.28</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_group_name>SdfAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Smart Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="644" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>SDOForeignFields</attribute_label>
<attribute_group_obj>347.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>390.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>347.7063</attribute_group_obj>
<attribute_group_name>Container</attribute_group_name>
<attribute_group_narrative>Container Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="645" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>SearchField</attribute_label>
<attribute_group_obj>436.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The name of a field on which can be searched on for repositioning the query the browse is attached to.
The field name is the actual field name in the SmartDataObject NOT the one referenced in the Data Dictionnary.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>482.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>436.7063</attribute_group_obj>
<attribute_group_name>Browser</attribute_group_name>
<attribute_group_narrative>SmartBrowser attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="646" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>SearchHandle</attribute_label>
<attribute_group_obj>436.7063</attribute_group_obj>
<data_type>10</data_type>
<attribute_narrative>The handle of the field whose name is stored in &apos;SearchField&apos;.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>484.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>436.7063</attribute_group_obj>
<attribute_group_name>Browser</attribute_group_name>
<attribute_group_narrative>SmartBrowser attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="647" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>Secured</attribute_label>
<attribute_group_obj>1005095447.101</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>839.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_group_name>SdfAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Smart Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="648" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>SecuredTokens</attribute_label>
<attribute_group_obj>430.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The list of secured tokens (from the container really).
SET from &apos;getSecuredTokens&apos; the first time (when the value is ?)</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>727.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>430.7063</attribute_group_obj>
<attribute_group_name>Toolbar</attribute_group_name>
<attribute_group_narrative>SmartToolbar attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="649" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>SELECTABLE</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005099266.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="650" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>SELECTED</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005099267.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="651" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>SelectionHandle</attribute_label>
<attribute_group_obj>434.7063</attribute_group_obj>
<data_type>10</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>588.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>434.7063</attribute_group_obj>
<attribute_group_name>Select</attribute_group_name>
<attribute_group_narrative>SmartSelect attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="652" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>SelectionImage</attribute_label>
<attribute_group_obj>434.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>590.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>434.7063</attribute_group_obj>
<attribute_group_name>Select</attribute_group_name>
<attribute_group_narrative>SmartSelect attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="653" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="06/19/2002" version_time="44549" version_user="ross" deletion_flag="no" entity_mnemonic="rycat" key_field_value="1003202054" record_version_obj="12867.409" version_number_seq="1.409" secondary_key_value="SelectorBGcolor" import_version_number_seq="1.409"><attribute_label>SelectorBGcolor</attribute_label>
<attribute_group_obj>3000002003.09</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Set the background color of the folder</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type>DIALOG</lookup_type>
<lookup_value>af/sup2/afspgetcow.w</lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1003202054</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="02/10/2003" version_time="59461" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="3000002003.09" record_version_obj="3000002004.09" version_number_seq="1.09" secondary_key_value="ADMAttributes" import_version_number_seq="1.09"><attribute_group_obj>3000002003.09</attribute_group_obj>
<attribute_group_name>ADMAttributes</attribute_group_name>
<attribute_group_narrative>This group contains all attributes of ADM objects excepts those that can also be Widget Attributes. In that case, they are in the WidgetAttribute group.</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="654" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="06/19/2002" version_time="44549" version_user="ross" deletion_flag="no" entity_mnemonic="rycat" key_field_value="1003202052" record_version_obj="12868.409" version_number_seq="1.409" secondary_key_value="SelectorFGcolor" import_version_number_seq="1.409"><attribute_label>SelectorFGcolor</attribute_label>
<attribute_group_obj>1005095446.101</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Set the foreground color of the folder</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type>DIALOG</lookup_type>
<lookup_value>af/sup2/afspgetcow.w</lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1003202052</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005095446.101</attribute_group_obj>
<attribute_group_name>ViewerAttributes</attribute_group_name>
<attribute_group_narrative>These are attributes which belong to a Dynamic Viewer</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="655" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>SelectorFont</attribute_label>
<attribute_group_obj>1003183341</attribute_group_obj>
<data_type>4</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1003202056</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="656" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>Selectors</attribute_label>
<attribute_group_obj>505.49</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Stores the Message Selectors used for receiving messages.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>888.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="09/04/2002" version_time="57079" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="505.49" record_version_obj="506.49" version_number_seq="3.49" secondary_key_value="Consumer" import_version_number_seq="3.49"><attribute_group_obj>505.49</attribute_group_obj>
<attribute_group_name>Consumer</attribute_group_name>
<attribute_group_narrative>SmartConsumer attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="657" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>SelectorWidth</attribute_label>
<attribute_group_obj>1003183341</attribute_group_obj>
<data_type>4</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1003202058</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="658" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>SENSITIVE</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005099263.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="659" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>SEPARATOR-FGCOLOR</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>4</data_type>
<attribute_narrative>The color of a browse&apos;s separator lines</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>14672.409</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="660" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="10/01/2002" version_time="65132" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="14670.409" record_version_obj="4714.66" version_number_seq="1.66" secondary_key_value="Separators" import_version_number_seq="1.66"><attribute_label>Separators</attribute_label>
<attribute_group_obj>436.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Decides whether the browser will have separator lines to demark rows and columns.</attribute_narrative>
<override_type>GET,SET</override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>14670.409</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>436.7063</attribute_group_obj>
<attribute_group_name>Browser</attribute_group_name>
<attribute_group_narrative>SmartBrowser attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="661" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ServerFileName</attribute_label>
<attribute_group_obj>11.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The actual server-side object filename to run on the AppServer -- may not be the ObjectName if that has been modified.
Defaults to the target-procedure file-name without the _cl.</attribute_narrative>
<override_type>get</override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>146.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>11.7063</attribute_group_obj>
<attribute_group_name>Appserver</attribute_group_name>
<attribute_group_narrative>Appserver attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="662" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ServerFirstCall</attribute_label>
<attribute_group_obj>11.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Indicates that this is the first call to the server side object.
It&apos;s the client&apos;s responsibility to tell the server when is the first call.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>148.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>11.7063</attribute_group_obj>
<attribute_group_name>Appserver</attribute_group_name>
<attribute_group_narrative>Appserver attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="663" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ServerOperatingMode</attribute_label>
<attribute_group_obj>11.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative></attribute_narrative>
<override_type>set</override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type>LIST</lookup_type>
<lookup_value>Set from server#CHR(3)#None#CHR(3)#Force to stateful operating mode#CHR(3)#State-reset</lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>1003183470</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>11.7063</attribute_group_obj>
<attribute_group_name>Appserver</attribute_group_name>
<attribute_group_narrative>Appserver attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="664" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ServerSubmitValidation</attribute_label>
<attribute_group_obj>152.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Signals whether the column and RowObject Validation procedures done as part of client validation should be executed on the server. 
It is &apos;NO&apos; by default; an SDO which uses client validation and which may be run from the open client interface should set it to &apos;YES&apos;, either in the SDO itself or at runtime.
If it is *no* when serverCommit executes, it will execute &apos;submitValidation&apos; itself.</attribute_narrative>
<override_type>set</override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>1003586096</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>152.7063</attribute_group_obj>
<attribute_group_name>Data</attribute_group_name>
<attribute_group_narrative>SDO Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="665" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ShowBorder</attribute_label>
<attribute_group_obj>430.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>1003498427</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>430.7063</attribute_group_obj>
<attribute_group_name>Toolbar</attribute_group_name>
<attribute_group_narrative>SmartToolbar attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="666" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ShowCheckBoxes</attribute_label>
<attribute_group_obj>1005097792.101</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Used to set the property of a SmartTreeView object to indicate that check boxes should appear next to each node.</attribute_narrative>
<override_type>SET</override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005081440.28</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005097792.101</attribute_group_obj>
<attribute_group_name>TreeView</attribute_group_name>
<attribute_group_narrative>TreeView Group</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="667" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ShowPopup</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>WidgetAttributes ShowPopup</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>3000000298.09</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="668" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ShowRootLines</attribute_label>
<attribute_group_obj>1005097792.101</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Used to set the property of a SmartTreeView object to indicate that root lines should appear on the OCX.</attribute_narrative>
<override_type>SET</override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005081441.28</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005097792.101</attribute_group_obj>
<attribute_group_name>TreeView</attribute_group_name>
<attribute_group_narrative>TreeView Group</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="669" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ShutDownDest</attribute_label>
<attribute_group_obj>505.49</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Stores the Shut Down Destination used to consume a shut down  message which shuts down the consumer.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>890.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="09/04/2002" version_time="57079" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="505.49" record_version_obj="506.49" version_number_seq="3.49" secondary_key_value="Consumer" import_version_number_seq="3.49"><attribute_group_obj>505.49</attribute_group_obj>
<attribute_group_name>Consumer</attribute_group_name>
<attribute_group_narrative>SmartConsumer attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="670" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>SIDE-LABEL-HANDLE</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005099286.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="671" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>SIDE-LABELS</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Frame attribute to allow a frame to have labels to the left of an object.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>14825.409</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="672" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>SingleSel</attribute_label>
<attribute_group_obj>3000002003.09</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>If yes, the node is expanded when the node is selected or clicked.</attribute_narrative>
<override_type>GET</override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>3517.66</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="02/10/2003" version_time="59461" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="3000002003.09" record_version_obj="3000002004.09" version_number_seq="1.09" secondary_key_value="ADMAttributes" import_version_number_seq="1.09"><attribute_group_obj>3000002003.09</attribute_group_obj>
<attribute_group_name>ADMAttributes</attribute_group_name>
<attribute_group_narrative>This group contains all attributes of ADM objects excepts those that can also be Widget Attributes. In that case, they are in the WidgetAttribute group.</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="673" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>SizeToFit</attribute_label>
<attribute_group_obj>1005095446.101</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>If a Viewer is marked &quot;SizeToFit&quot;, it will be sized to the minimum dimensions that will accomodate all included widgets.  Otherwise, the viewer will retain its design-time size.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>yes</design_only>
<system_owned>yes</system_owned>
<attribute_obj>25001.409</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005095446.101</attribute_group_obj>
<attribute_group_name>ViewerAttributes</attribute_group_name>
<attribute_group_narrative>These are attributes which belong to a Dynamic Viewer</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="674" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>SizeUnits</attribute_label>
<attribute_group_obj>1005095446.101</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The units to use when sizing the widgets on a viewer.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005095451.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005095446.101</attribute_group_obj>
<attribute_group_name>ViewerAttributes</attribute_group_name>
<attribute_group_narrative>These are attributes which belong to a Dynamic Viewer</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="675" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>SkipTransferDBRow</attribute_label>
<attribute_group_obj>154.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Internal flag used for performance optimization. It is used to avoid the call to the transferDBRow function for each record. The property is set to true in transferDBRow if the function is not overridden. transferRows then avoids calling it for the rest of the batch. Although a function call is fast, the performance gain by skipping it is substantial due to the fact that inline logic and query navigation is very fast.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>yes</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>543.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>154.7063</attribute_group_obj>
<attribute_group_name>Query</attribute_group_name>
<attribute_group_narrative>Query object attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="676" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>SORT</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005099331.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="677" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>SortableHandle</attribute_label>
<attribute_group_obj>436.7063</attribute_group_obj>
<data_type>10</data_type>
<attribute_narrative>Handle for sortable popup menu item</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>273.009</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>436.7063</attribute_group_obj>
<attribute_group_name>Browser</attribute_group_name>
<attribute_group_narrative>SmartBrowser attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="678" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>Starting</attribute_label>
<attribute_group_obj>434.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>564.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>434.7063</attribute_group_obj>
<attribute_group_name>Select</attribute_group_name>
<attribute_group_narrative>SmartSelect attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="679" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>StartPage</attribute_label>
<attribute_group_obj>347.7063</attribute_group_obj>
<data_type>4</data_type>
<attribute_narrative>The page number of the initial container page to be made visible.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>367.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>347.7063</attribute_group_obj>
<attribute_group_name>Container</attribute_group_name>
<attribute_group_narrative>Container Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="680" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>StatelessSavedProperties</attribute_label>
<attribute_group_obj>152.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>199.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>152.7063</attribute_group_obj>
<attribute_group_name>Data</attribute_group_name>
<attribute_group_narrative>SDO Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="681" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>StaticPrefix</attribute_label>
<attribute_group_obj>438.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The prefix used before the action name in static definitions.
This allows static panels to use action/repository data.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>660.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>438.7063</attribute_group_obj>
<attribute_group_name>Panel</attribute_group_name>
<attribute_group_narrative>SmartPanel attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="682" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="06/19/2002" version_time="44549" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="12937.5053" record_version_obj="12938.5053" version_number_seq="2.5053" secondary_key_value="StatusArea" import_version_number_seq="2.5053"><attribute_label>StatusArea</attribute_label>
<attribute_group_obj>1003183341</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Indicates if a window is should have a status area.</attribute_narrative>
<override_type>SET</override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>12937.5053</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="683" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>StopConsumer</attribute_label>
<attribute_group_obj>505.49</attribute_group_obj>
<data_type>10</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>892.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="09/04/2002" version_time="57079" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="505.49" record_version_obj="506.49" version_number_seq="3.49" secondary_key_value="Consumer" import_version_number_seq="3.49"><attribute_group_obj>505.49</attribute_group_obj>
<attribute_group_name>Consumer</attribute_group_name>
<attribute_group_narrative>SmartConsumer attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="684" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="03/19/2003" version_time="56963" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="13475.409" record_version_obj="13476.409" version_number_seq="1.09" secondary_key_value="STRETCH-TO-FIT" import_version_number_seq="1.09"><attribute_label>STRETCH-TO-FIT</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>When TRUE, images are automatically resized to fit the available space.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>13475.409</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="685" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>StyleSheetFile</attribute_label>
<attribute_group_obj>347.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Cascading StyleSheet include file(s)</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>524.1713</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>347.7063</attribute_group_obj>
<attribute_group_name>Container</attribute_group_name>
<attribute_group_narrative>Container Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="686" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>SubModules</attribute_label>
<attribute_group_obj>430.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>NOT IN USE</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>1003498431</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>430.7063</attribute_group_obj>
<attribute_group_name>Toolbar</attribute_group_name>
<attribute_group_narrative>SmartToolbar attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="687" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>Subscriptions</attribute_label>
<attribute_group_obj>505.49</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Stores the Subscriptions this consumer uses when subscribing
to topics (only for Pub/Sub domain)</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>894.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="09/04/2002" version_time="57079" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="505.49" record_version_obj="506.49" version_number_seq="3.49" secondary_key_value="Consumer" import_version_number_seq="3.49"><attribute_group_obj>505.49</attribute_group_obj>
<attribute_group_name>Consumer</attribute_group_name>
<attribute_group_narrative>SmartConsumer attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="688" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>SUBTYPE</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005099312.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="689" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>SupportedLinks</attribute_label>
<attribute_group_obj>5.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>A comma-seaprated list of links that this object supports. The links must be specified as &lt;linktype&gt;-target or &lt;linktype&gt;-source</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level>Class</constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>1003498433</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>5.7063</attribute_group_obj>
<attribute_group_name>Smart</attribute_group_name>
<attribute_group_narrative>Smart Object common attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="690" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>SupportedMessageTypes</attribute_label>
<attribute_group_obj>731.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>910.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>731.7063</attribute_group_obj>
<attribute_group_name>Messaging</attribute_group_name>
<attribute_group_narrative>Messaging SmartObject attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="691" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>TAB-STOP</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005099303.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="692" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="06/19/2002" version_time="44550" version_user="ross" deletion_flag="no" entity_mnemonic="rycat" key_field_value="1003202020" record_version_obj="1000015726.38" version_number_seq="2.09" secondary_key_value="TabBGcolor" import_version_number_seq="2.09"><attribute_label>TabBGcolor</attribute_label>
<attribute_group_obj>3000002003.09</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Set the background color of the selectd tab</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type>DIALOG</lookup_type>
<lookup_value>af/sup2/afspgetcow.w</lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1003202020</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="02/10/2003" version_time="59461" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="3000002003.09" record_version_obj="3000002004.09" version_number_seq="1.09" secondary_key_value="ADMAttributes" import_version_number_seq="1.09"><attribute_group_obj>3000002003.09</attribute_group_obj>
<attribute_group_name>ADMAttributes</attribute_group_name>
<attribute_group_narrative>This group contains all attributes of ADM objects excepts those that can also be Widget Attributes. In that case, they are in the WidgetAttribute group.</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="693" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="10/04/2002" version_time="29478" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="3000040656.09" record_version_obj="3000040657.09" version_number_seq="3.09" secondary_key_value="TabEnabled" import_version_number_seq="3.09"><attribute_label>TabEnabled</attribute_label>
<attribute_group_obj>3000002003.09</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>This attribute contains a pipe-delimited list of logical values which indicate whether a particular tab page is enabled or not.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>3000040656.09</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="02/10/2003" version_time="59461" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="3000002003.09" record_version_obj="3000002004.09" version_number_seq="1.09" secondary_key_value="ADMAttributes" import_version_number_seq="1.09"><attribute_group_obj>3000002003.09</attribute_group_obj>
<attribute_group_name>ADMAttributes</attribute_group_name>
<attribute_group_narrative>This group contains all attributes of ADM objects excepts those that can also be Widget Attributes. In that case, they are in the WidgetAttribute group.</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="694" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="06/19/2002" version_time="44550" version_user="ross" deletion_flag="no" entity_mnemonic="rycat" key_field_value="1003202018" record_version_obj="1000015727.38" version_number_seq="2.09" secondary_key_value="TabFGcolor" import_version_number_seq="2.09"><attribute_label>TabFGcolor</attribute_label>
<attribute_group_obj>3000002003.09</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Set the foreground color of the selected tab</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type>DIALOG</lookup_type>
<lookup_value>af/sup2/afspgetcow.w</lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1003202018</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="02/10/2003" version_time="59461" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="3000002003.09" record_version_obj="3000002004.09" version_number_seq="1.09" secondary_key_value="ADMAttributes" import_version_number_seq="1.09"><attribute_group_obj>3000002003.09</attribute_group_obj>
<attribute_group_name>ADMAttributes</attribute_group_name>
<attribute_group_narrative>This group contains all attributes of ADM objects excepts those that can also be Widget Attributes. In that case, they are in the WidgetAttribute group.</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="695" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>TabFont</attribute_label>
<attribute_group_obj>1003183341</attribute_group_obj>
<data_type>4</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1003202038</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="696" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>TabHeight</attribute_label>
<attribute_group_obj>1003183341</attribute_group_obj>
<data_type>4</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1003202036</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="697" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>TabHidden</attribute_label>
<attribute_group_obj>1003183341</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>This attribute contains a pipe-delimited list of logical values which indicate whether a particular tab page is hidden or not.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1003202024</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="698" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>TabINcolor</attribute_label>
<attribute_group_obj>1003183341</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1003202022</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="699" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="03/07/2003" version_time="63471" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="36474.48" record_version_obj="36475.48" version_number_seq="1.09" secondary_key_value="TableHasObjectField" import_version_number_seq="1.09"><attribute_label>TableHasObjectField</attribute_label>
<attribute_group_obj>36427.48</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>If set to NO, this table does not contain a generic object field used to join to generic tables, e.g. comments, auditing, etc.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>36474.48</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="03/12/2003" version_time="66443" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="36427.48" record_version_obj="36428.48" version_number_seq="1.09" secondary_key_value="EntityAttributes" import_version_number_seq="1.09"><attribute_group_obj>36427.48</attribute_group_obj>
<attribute_group_name>EntityAttributes</attribute_group_name>
<attribute_group_narrative>This group contains attributes that are associated with entities. The attributes in this group correspond exactly to the field names in the GSC_ENTITY_MNEMONIC table, excpet that they have had the underscores removed. This convention is used so that it is possible to generically and quickly populate the attributes.</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="700" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>TableIOSource</attribute_label>
<attribute_group_obj>9.7063</attribute_group_obj>
<data_type>10</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>108.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>9.7063</attribute_group_obj>
<attribute_group_name>DataVisual</attribute_group_name>
<attribute_group_narrative>Data visualization object attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="701" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>TableIOSourceEvents</attribute_label>
<attribute_group_obj>9.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level>Class</constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>110.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>9.7063</attribute_group_obj>
<attribute_group_name>DataVisual</attribute_group_name>
<attribute_group_narrative>Data visualization object attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="702" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>TableioTarget</attribute_label>
<attribute_group_obj>438.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>680.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>438.7063</attribute_group_obj>
<attribute_group_name>Panel</attribute_group_name>
<attribute_group_narrative>SmartPanel attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="703" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>TableioTargetEvents</attribute_label>
<attribute_group_obj>438.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>682.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>438.7063</attribute_group_obj>
<attribute_group_name>Panel</attribute_group_name>
<attribute_group_narrative>SmartPanel attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="704" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>TableIOType</attribute_label>
<attribute_group_obj>430.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The TableIOType link value.
This is the same as PanelType in the update panel.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>1003498432</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>430.7063</attribute_group_obj>
<attribute_group_name>Toolbar</attribute_group_name>
<attribute_group_narrative>SmartToolbar attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="705" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>TableName</attribute_label>
<attribute_group_obj>3000002003.09</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>WidgetAttributes TableName</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005078710.09</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="02/10/2003" version_time="59461" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="3000002003.09" record_version_obj="3000002004.09" version_number_seq="1.09" secondary_key_value="ADMAttributes" import_version_number_seq="1.09"><attribute_group_obj>3000002003.09</attribute_group_obj>
<attribute_group_name>ADMAttributes</attribute_group_name>
<attribute_group_narrative>This group contains all attributes of ADM objects excepts those that can also be Widget Attributes. In that case, they are in the WidgetAttribute group.</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="706" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="03/07/2003" version_time="63471" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="36476.48" record_version_obj="36477.48" version_number_seq="1.09" secondary_key_value="TablePrefixLength" import_version_number_seq="1.09"><attribute_label>TablePrefixLength</attribute_label>
<attribute_group_obj>36427.48</attribute_group_obj>
<data_type>4</data_type>
<attribute_narrative>This is the length of the table prefix appended to all table names as per the framework standards. The framework uses a 4 character table prefix - see the standards documentation for further details.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>36476.48</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="03/12/2003" version_time="66443" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="36427.48" record_version_obj="36428.48" version_number_seq="1.09" secondary_key_value="EntityAttributes" import_version_number_seq="1.09"><attribute_group_obj>36427.48</attribute_group_obj>
<attribute_group_name>EntityAttributes</attribute_group_name>
<attribute_group_narrative>This group contains attributes that are associated with entities. The attributes in this group correspond exactly to the field names in the GSC_ENTITY_MNEMONIC table, excpet that they have had the underscores removed. This convention is used so that it is possible to generically and quickly populate the attributes.</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="707" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>Tables</attribute_label>
<attribute_group_obj>154.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>A comma delimited list of tables in the Query Object. Qualified with database name if the query is defined with dbname.
It is a design time property, as it&apos;s very expensive to resolve on the server at run-time.
There is no way to change the order of the tables at run time. But it would be even more important to have this as a property
if the order of the tables were changed dynamically, because several other properties have table delimiters and are depending on the design-time order of this.</attribute_narrative>
<override_type>GET,SET</override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>535.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>154.7063</attribute_group_obj>
<attribute_group_name>Query</attribute_group_name>
<attribute_group_narrative>Query object attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="708" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="06/19/2002" version_time="44550" version_user="ross" deletion_flag="no" entity_mnemonic="rycat" key_field_value="1003202060" record_version_obj="12870.409" version_number_seq="1.409" secondary_key_value="TabPosition" import_version_number_seq="1.409"><attribute_label>TabPosition</attribute_label>
<attribute_group_obj>3000002003.09</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Set the position of the tabs (either top [&quot;Upper&quot;] or bottom [&quot;Lower&quot;])</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type>LIST</lookup_type>
<lookup_value>Upper#CHR(3)#Upper#CHR(3)#Lower#CHR(3)#Lower</lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1003202060</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="02/10/2003" version_time="59461" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="3000002003.09" record_version_obj="3000002004.09" version_number_seq="1.09" secondary_key_value="ADMAttributes" import_version_number_seq="1.09"><attribute_group_obj>3000002003.09</attribute_group_obj>
<attribute_group_name>ADMAttributes</attribute_group_name>
<attribute_group_narrative>This group contains all attributes of ADM objects excepts those that can also be Widget Attributes. In that case, they are in the WidgetAttribute group.</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="709" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="06/19/2002" version_time="44550" version_user="ross" deletion_flag="no" entity_mnemonic="rycat" key_field_value="1003202050" record_version_obj="12869.409" version_number_seq="1.409" secondary_key_value="TabSize" import_version_number_seq="1.409"><attribute_label>TabSize</attribute_label>
<attribute_group_obj>3000002003.09</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Set the sizing method of the folder</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type>LIST</lookup_type>
<lookup_value>Autosize#CHR(3)#Autosize#CHR(3)#Proportional#CHR(3)#Proportional#CHR(3)#Justified#CHR(3)#Justified</lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1003202050</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="02/10/2003" version_time="59461" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="3000002003.09" record_version_obj="3000002004.09" version_number_seq="1.09" secondary_key_value="ADMAttributes" import_version_number_seq="1.09"><attribute_group_obj>3000002003.09</attribute_group_obj>
<attribute_group_name>ADMAttributes</attribute_group_name>
<attribute_group_narrative>This group contains all attributes of ADM objects excepts those that can also be Widget Attributes. In that case, they are in the WidgetAttribute group.</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="710" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>TabsPerRow</attribute_label>
<attribute_group_obj>1003183341</attribute_group_obj>
<data_type>4</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1003202034</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="711" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="02/10/2003" version_time="59461" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="178000000719.5566" record_version_obj="178000000720.5566" version_number_seq="1.09" secondary_key_value="TabVisualization" import_version_number_seq="1.09"><attribute_label>TabVisualization</attribute_label>
<attribute_group_obj>3000002003.09</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>This could have a value of &quot;Tabs&quot;, &quot;Combo-Box&quot; or &quot;Radio-Set&quot; and will determine how the tabs on the SmartFolder objects are visualized.

When TabVisualization is &quot;Combo-Box&quot;, disabledPages will NOT appear in the combo. If pages are re-enabled, they will be re-added to the list.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type>LIST</lookup_type>
<lookup_value>Tabs#CHR(3)#TABS#CHR(3)#Combo-Box#CHR(3)#COMBO-BOX#CHR(3)#Radio-Set#CHR(3)#RADIO-SET</lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>178000000719.5566</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="02/10/2003" version_time="59461" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="3000002003.09" record_version_obj="3000002004.09" version_number_seq="1.09" secondary_key_value="ADMAttributes" import_version_number_seq="1.09"><attribute_group_obj>3000002003.09</attribute_group_obj>
<attribute_group_name>ADMAttributes</attribute_group_name>
<attribute_group_narrative>This group contains all attributes of ADM objects excepts those that can also be Widget Attributes. In that case, they are in the WidgetAttribute group.</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="712" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="03/06/2003" version_time="65764" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="702.7692" record_version_obj="703.7692" version_number_seq="1.09" secondary_key_value="TemplateControl" import_version_number_seq="1.09"><attribute_label>TemplateControl</attribute_label>
<attribute_group_obj>505.7692</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Stores OCX control information</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>yes</design_only>
<system_owned>no</system_owned>
<attribute_obj>702.7692</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="03/17/2003" version_time="41317" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="505.7692" record_version_obj="506.7692" version_number_seq="1.09" secondary_key_value="Template" import_version_number_seq="1.09"><attribute_group_obj>505.7692</attribute_group_obj>
<attribute_group_name>Template</attribute_group_name>
<attribute_group_narrative>Template group applies to all objects that may be created as a template and used for new objects in the IDE</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="713" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="03/17/2003" version_time="41316" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="515.7692" record_version_obj="516.7692" version_number_seq="1.09" secondary_key_value="TemplateDescription" import_version_number_seq="1.09"><attribute_label>TemplateDescription</attribute_label>
<attribute_group_obj>505.7692</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The description of the template</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>yes</design_only>
<system_owned>no</system_owned>
<attribute_obj>515.7692</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="03/17/2003" version_time="41317" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="505.7692" record_version_obj="506.7692" version_number_seq="1.09" secondary_key_value="Template" import_version_number_seq="1.09"><attribute_group_obj>505.7692</attribute_group_obj>
<attribute_group_name>Template</attribute_group_name>
<attribute_group_narrative>Template group applies to all objects that may be created as a template and used for new objects in the IDE</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="714" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="03/17/2003" version_time="41317" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="507.7692" record_version_obj="508.7692" version_number_seq="1.09" secondary_key_value="TemplateFile" import_version_number_seq="1.09"><attribute_label>TemplateFile</attribute_label>
<attribute_group_obj>505.7692</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The relative path and filename of the static object used as the template at design time</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>yes</design_only>
<system_owned>no</system_owned>
<attribute_obj>507.7692</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="03/17/2003" version_time="41317" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="505.7692" record_version_obj="506.7692" version_number_seq="1.09" secondary_key_value="Template" import_version_number_seq="1.09"><attribute_group_obj>505.7692</attribute_group_obj>
<attribute_group_name>Template</attribute_group_name>
<attribute_group_narrative>Template group applies to all objects that may be created as a template and used for new objects in the IDE</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="715" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="03/17/2003" version_time="41317" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="509.7692" record_version_obj="510.7692" version_number_seq="1.09" secondary_key_value="TemplateGroup" import_version_number_seq="1.09"><attribute_label>TemplateGroup</attribute_label>
<attribute_group_obj>505.7692</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Used for grouping templates into one of 4 groups: Container, SmartObject, Procedure and WebObject</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>yes</design_only>
<system_owned>no</system_owned>
<attribute_obj>509.7692</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="03/17/2003" version_time="41317" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="505.7692" record_version_obj="506.7692" version_number_seq="1.09" secondary_key_value="Template" import_version_number_seq="1.09"><attribute_group_obj>505.7692</attribute_group_obj>
<attribute_group_name>Template</attribute_group_name>
<attribute_group_narrative>Template group applies to all objects that may be created as a template and used for new objects in the IDE</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="716" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="03/17/2003" version_time="41317" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="519.7692" record_version_obj="520.7692" version_number_seq="1.09" secondary_key_value="TemplateImageFile" import_version_number_seq="1.09"><attribute_label>TemplateImageFile</attribute_label>
<attribute_group_obj>505.7692</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Specifies the image to use in the design window.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>yes</design_only>
<system_owned>no</system_owned>
<attribute_obj>519.7692</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="03/17/2003" version_time="41317" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="505.7692" record_version_obj="506.7692" version_number_seq="1.09" secondary_key_value="Template" import_version_number_seq="1.09"><attribute_group_obj>505.7692</attribute_group_obj>
<attribute_group_name>Template</attribute_group_name>
<attribute_group_narrative>Template group applies to all objects that may be created as a template and used for new objects in the IDE</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="717" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="03/17/2003" version_time="41317" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="513.7692" record_version_obj="514.7692" version_number_seq="1.09" secondary_key_value="TemplateLabel" import_version_number_seq="1.09"><attribute_label>TemplateLabel</attribute_label>
<attribute_group_obj>505.7692</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The label used for display in the new dialog and in the popup menu</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>yes</design_only>
<system_owned>no</system_owned>
<attribute_obj>513.7692</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="03/17/2003" version_time="41317" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="505.7692" record_version_obj="506.7692" version_number_seq="1.09" secondary_key_value="Template" import_version_number_seq="1.09"><attribute_group_obj>505.7692</attribute_group_obj>
<attribute_group_name>Template</attribute_group_name>
<attribute_group_narrative>Template group applies to all objects that may be created as a template and used for new objects in the IDE</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="718" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>TemplateObjectName</attribute_label>
<attribute_group_obj>1003183341</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Used by the Dynamic Container Builder Property Sheet.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>1007500648.09</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="719" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="03/17/2003" version_time="41317" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="517.7692" record_version_obj="518.7692" version_number_seq="1.09" secondary_key_value="TemplateOrder" import_version_number_seq="1.09"><attribute_label>TemplateOrder</attribute_label>
<attribute_group_obj>505.7692</attribute_group_obj>
<data_type>4</data_type>
<attribute_narrative>Order of the template within it&apos;s group</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>yes</design_only>
<system_owned>no</system_owned>
<attribute_obj>517.7692</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="03/17/2003" version_time="41317" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="505.7692" record_version_obj="506.7692" version_number_seq="1.09" secondary_key_value="Template" import_version_number_seq="1.09"><attribute_group_obj>505.7692</attribute_group_obj>
<attribute_group_name>Template</attribute_group_name>
<attribute_group_narrative>Template group applies to all objects that may be created as a template and used for new objects in the IDE</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="720" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="03/17/2003" version_time="41317" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="521.7692" record_version_obj="522.7692" version_number_seq="1.09" secondary_key_value="TemplatePropertySheet" import_version_number_seq="1.09"><attribute_label>TemplatePropertySheet</attribute_label>
<attribute_group_obj>505.7692</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Used to associate the dynamic property sheet file to use for the template object.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>yes</design_only>
<system_owned>no</system_owned>
<attribute_obj>521.7692</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="03/17/2003" version_time="41317" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="505.7692" record_version_obj="506.7692" version_number_seq="1.09" secondary_key_value="Template" import_version_number_seq="1.09"><attribute_group_obj>505.7692</attribute_group_obj>
<attribute_group_name>Template</attribute_group_name>
<attribute_group_narrative>Template group applies to all objects that may be created as a template and used for new objects in the IDE</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="721" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="03/17/2003" version_time="41317" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="511.7692" record_version_obj="512.7692" version_number_seq="1.09" secondary_key_value="TemplateType" import_version_number_seq="1.09"><attribute_label>TemplateType</attribute_label>
<attribute_group_obj>505.7692</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>For static and dynamic smartObjects, refers to the data type: (i.e 
SmartDataField, SmartDataBrowser, SmartDataViewer, DynView, etc..)</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>yes</design_only>
<system_owned>no</system_owned>
<attribute_obj>511.7692</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="03/17/2003" version_time="41317" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="505.7692" record_version_obj="506.7692" version_number_seq="1.09" secondary_key_value="Template" import_version_number_seq="1.09"><attribute_group_obj>505.7692</attribute_group_obj>
<attribute_group_name>Template</attribute_group_name>
<attribute_group_narrative>Template group applies to all objects that may be created as a template and used for new objects in the IDE</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="722" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="09/24/2002" version_time="45981" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="3000031113.09" record_version_obj="3000031114.09" version_number_seq="2.09" secondary_key_value="TempTables" import_version_number_seq="2.09"><attribute_label>TempTables</attribute_label>
<attribute_group_obj>152.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>This property contains a list of temp-table info corresponding to the Tables property or QueryTables property</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>3000031113.09</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>152.7063</attribute_group_obj>
<attribute_group_name>Data</attribute_group_name>
<attribute_group_narrative>SDO Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="723" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="06/19/2002" version_time="44550" version_user="ross" deletion_flag="no" entity_mnemonic="rycat" key_field_value="13517.409" record_version_obj="13518.409" version_number_seq="2.409" secondary_key_value="THREE-D" import_version_number_seq="2.409"><attribute_label>THREE-D</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>IF TRUE then Buttons have the 3-D look</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>13517.409</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="724" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>TimeToLive</attribute_label>
<attribute_group_obj>507.49</attribute_group_obj>
<data_type>5</data_type>
<attribute_narrative>Time To Live value for messages being sent</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>934.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="09/04/2002" version_time="57071" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="507.49" record_version_obj="508.49" version_number_seq="3.49" secondary_key_value="Producer" import_version_number_seq="3.49"><attribute_group_obj>507.49</attribute_group_obj>
<attribute_group_name>Producer</attribute_group_name>
<attribute_group_narrative>SmartProducer attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="725" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>TITLE</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Browser, Frame, Dialog and Window title</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>14674.409</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="726" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ToggleDataTargets</attribute_label>
<attribute_group_obj>152.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Set to FALSE if dataTargets should not be toggled on/of in LinkStatebased based on the passed &apos;active&apos; or &apos;inactive&apos; parameter.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>217.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>152.7063</attribute_group_obj>
<attribute_group_name>Data</attribute_group_name>
<attribute_group_narrative>SDO Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="727" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>Toolbar</attribute_label>
<attribute_group_obj>430.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>TRUE if a Toolbar is to be generated.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>1003498428</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>430.7063</attribute_group_obj>
<attribute_group_name>Toolbar</attribute_group_name>
<attribute_group_narrative>SmartToolbar attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="728" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ToolbarAutoSize</attribute_label>
<attribute_group_obj>430.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Indicates whether the toolbar should be auto-sized to the width of the window at run-time.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>1003498436</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>430.7063</attribute_group_obj>
<attribute_group_name>Toolbar</attribute_group_name>
<attribute_group_narrative>SmartToolbar attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="729" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ToolbarBands</attribute_label>
<attribute_group_obj>430.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Comma separated list of Toolbar Bands.
NOT USED</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>1003498434</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>430.7063</attribute_group_obj>
<attribute_group_name>Toolbar</attribute_group_name>
<attribute_group_narrative>SmartToolbar attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="730" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ToolbarDrawDirection</attribute_label>
<attribute_group_obj>430.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The draw direction of the toolbar (horizontal or vertical).</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>1003498437</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>430.7063</attribute_group_obj>
<attribute_group_name>Toolbar</attribute_group_name>
<attribute_group_narrative>SmartToolbar attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="731" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ToolbarInitialState</attribute_label>
<attribute_group_obj>430.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>1003498438</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>430.7063</attribute_group_obj>
<attribute_group_name>Toolbar</attribute_group_name>
<attribute_group_narrative>SmartToolbar attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="732" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ToolbarParentMenu</attribute_label>
<attribute_group_obj>430.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Only required if any toolbar menus need to be added under a specific submenu, which will also be created if it does not exist.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>1003498435</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>430.7063</attribute_group_obj>
<attribute_group_name>Toolbar</attribute_group_name>
<attribute_group_narrative>SmartToolbar attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="733" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ToolbarSource</attribute_label>
<attribute_group_obj>347.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>A comma-separated list of the handle(s) of the object&apos;s toolbar-source</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>355.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>347.7063</attribute_group_obj>
<attribute_group_name>Container</attribute_group_name>
<attribute_group_narrative>Container Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="734" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ToolbarSourceEvents</attribute_label>
<attribute_group_obj>347.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The list of events to be subscribed to in the Toolbar-Source</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level>Class</constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>357.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>347.7063</attribute_group_obj>
<attribute_group_name>Container</attribute_group_name>
<attribute_group_narrative>Container Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="735" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ToolbarTarget</attribute_label>
<attribute_group_obj>430.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The handle of the object&apos;s toolbar-target. This may be a
delimited list of handles.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>723.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>430.7063</attribute_group_obj>
<attribute_group_name>Toolbar</attribute_group_name>
<attribute_group_narrative>SmartToolbar attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="736" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ToolbarTargetEvents</attribute_label>
<attribute_group_obj>430.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The list of events to be subscribed to in the Toolbar-target.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level>Class</constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>725.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>430.7063</attribute_group_obj>
<attribute_group_name>Toolbar</attribute_group_name>
<attribute_group_narrative>SmartToolbar attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="737" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ToolHeightPxl</attribute_label>
<attribute_group_obj>430.7063</attribute_group_obj>
<data_type>4</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>700.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>430.7063</attribute_group_obj>
<attribute_group_name>Toolbar</attribute_group_name>
<attribute_group_narrative>SmartToolbar attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="738" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ToolMarginPxl</attribute_label>
<attribute_group_obj>430.7063</attribute_group_obj>
<data_type>4</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>1003504309</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>430.7063</attribute_group_obj>
<attribute_group_name>Toolbar</attribute_group_name>
<attribute_group_narrative>SmartToolbar attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="739" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ToolMaxWidthPxl</attribute_label>
<attribute_group_obj>430.7063</attribute_group_obj>
<data_type>4</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>719.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>430.7063</attribute_group_obj>
<attribute_group_name>Toolbar</attribute_group_name>
<attribute_group_narrative>SmartToolbar attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="740" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ToolSeparatorPxl</attribute_label>
<attribute_group_obj>430.7063</attribute_group_obj>
<data_type>4</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>696.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>430.7063</attribute_group_obj>
<attribute_group_name>Toolbar</attribute_group_name>
<attribute_group_narrative>SmartToolbar attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="741" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ToolSpacingPxl</attribute_label>
<attribute_group_obj>430.7063</attribute_group_obj>
<data_type>4</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>694.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>430.7063</attribute_group_obj>
<attribute_group_name>Toolbar</attribute_group_name>
<attribute_group_narrative>SmartToolbar attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="742" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>TOOLTIP</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005099304.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="743" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ToolWidthPxl</attribute_label>
<attribute_group_obj>430.7063</attribute_group_obj>
<data_type>4</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>698.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>430.7063</attribute_group_obj>
<attribute_group_name>Toolbar</attribute_group_name>
<attribute_group_narrative>SmartToolbar attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="744" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="06/19/2002" version_time="44550" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="2000000085.82" record_version_obj="2000000086.82" version_number_seq="2.82" secondary_key_value="TopOnly" import_version_number_seq="2.82"><attribute_label>TopOnly</attribute_label>
<attribute_group_obj>1003183341</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Indicates if a window is always on top of any other running windows.</attribute_narrative>
<override_type>SET</override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>2000000085.82</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="745" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>TransferChildrenForAll</attribute_label>
<attribute_group_obj>152.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>This flag decides whether children for all records (of the batch) is to be transferred from the database. Currently only supported for read event handlers during a fetch. The child SDO is only left with temp-table records for one parent when the fetch*batch is finished.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>124</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>152.7063</attribute_group_obj>
<attribute_group_name>Data</attribute_group_name>
<attribute_group_narrative>SDO Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="746" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>TranslatableProperties</attribute_label>
<attribute_group_obj>5.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The list of translatable properties, those which should not have a &quot;:U&quot; following their literal values when code is generated in adm-create-objects.
Because this is a comma-separated list, it should normally be
 invoked indirectly, through modifyListAttribute.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level>Class</constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>yes</design_only>
<system_owned>yes</system_owned>
<attribute_obj>46.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>5.7063</attribute_group_obj>
<attribute_group_name>Smart</attribute_group_name>
<attribute_group_narrative>Smart Object common attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="747" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="06/19/2002" version_time="44550" version_user="ross" deletion_flag="no" entity_mnemonic="rycat" key_field_value="13477.409" record_version_obj="13478.409" version_number_seq="2.409" secondary_key_value="TRANSPARENT" import_version_number_seq="2.409"><attribute_label>TRANSPARENT</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>When TRUE, image background color changes to match the backgorund color of its parent.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>13477.409</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="748" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>TreeStyle</attribute_label>
<attribute_group_obj>1005097792.101</attribute_group_obj>
<data_type>4</data_type>
<attribute_narrative>Used to set the property of a SmartTreeView object to indicate the style of the TreeView. The following options are supported:
0 - Text only
1 - Pictures &amp; Text
2 - Text only (Plus/Minus)
3 - Pictures &amp; Text (Plus/Minus)
4 - Text only with tree lines
5 - Pictures &amp; Text with tree lines
6 - Text only with tree lines &amp; plus/minus
7 - Pictures &amp; text with tree lines &amp; plus/minus</attribute_narrative>
<override_type>SET</override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005081442.28</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005097792.101</attribute_group_obj>
<attribute_group_name>TreeView</attribute_group_name>
<attribute_group_narrative>TreeView Group</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="749" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>TVControllerSource</attribute_label>
<attribute_group_obj>3000002003.09</attribute_group_obj>
<data_type>10</data_type>
<attribute_narrative>Treeview pointer to the special TVcontainer</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>3506.66</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="02/10/2003" version_time="59461" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="3000002003.09" record_version_obj="3000002004.09" version_number_seq="1.09" secondary_key_value="ADMAttributes" import_version_number_seq="1.09"><attribute_group_obj>3000002003.09</attribute_group_obj>
<attribute_group_name>ADMAttributes</attribute_group_name>
<attribute_group_narrative>This group contains all attributes of ADM objects excepts those that can also be Widget Attributes. In that case, they are in the WidgetAttribute group.</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="750" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>TypeName</attribute_label>
<attribute_group_obj>515.49</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The name that identifes the document/destination for multi 
document producers</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>872.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="09/04/2002" version_time="57075" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="515.49" record_version_obj="516.49" version_number_seq="2.49" secondary_key_value="B2B" import_version_number_seq="2.49"><attribute_group_obj>515.49</attribute_group_obj>
<attribute_group_name>B2B</attribute_group_name>
<attribute_group_narrative>SmartB2B attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="751" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>UIBMode</attribute_label>
<attribute_group_obj>5.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>35.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>5.7063</attribute_group_obj>
<attribute_group_name>Smart</attribute_group_name>
<attribute_group_narrative>Smart Object common attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="752" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>UNIQUE-MATCH</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005099333.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="753" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>UpdatableColumns</attribute_label>
<attribute_group_obj>154.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>A combined, comma-separated list of updatable columns in all tables of the query. It is derived from &apos;UpdatableColumnsByTable&apos;.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>yes</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>533.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>154.7063</attribute_group_obj>
<attribute_group_name>Query</attribute_group_name>
<attribute_group_narrative>Query object attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="754" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>UpdatableColumnsByTable</attribute_label>
<attribute_group_obj>154.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>A comma-separated list of updatable columns grouped by table and delimited by CHR(1).</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>531.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>154.7063</attribute_group_obj>
<attribute_group_name>Query</attribute_group_name>
<attribute_group_narrative>Query object attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="755" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>UpdateActive</attribute_label>
<attribute_group_obj>347.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>TRUE if ANY of the contained object&apos;s have active updates.
- Updating objects publishes &apos;updateActive&apos; (true or false) to their  container targets. (from setDataModified, setNewRecord or setRowObjectState).
- If the value is FALSE updateActive turns around and publishes 
 &apos;isUpdateActive&apos;, which checks properties involved, to ALL ContainerTargets before it is stored in the UpdateActive property.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>412.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>347.7063</attribute_group_obj>
<attribute_group_name>Container</attribute_group_name>
<attribute_group_narrative>Container Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="756" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>UpdateFromSource</attribute_label>
<attribute_group_obj>152.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>&apos;TRUE&apos; if this object should be updated as one-to-one with the datasource updates (one-to-one)</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>215.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>152.7063</attribute_group_obj>
<attribute_group_name>Data</attribute_group_name>
<attribute_group_narrative>SDO Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="757" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>UpdateSource</attribute_label>
<attribute_group_obj>152.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The handle of the object&apos;s Update-Source.
This is used for pass-through links, to connect an object inside the container with an object outside the container. It is CHARACTER because at least one type of container (SBO)
supports multiple update sources</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>176.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>152.7063</attribute_group_obj>
<attribute_group_name>Data</attribute_group_name>
<attribute_group_narrative>SDO Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="758" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>UpdateStateInProcess</attribute_label>
<attribute_group_obj>428.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>456.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>428.7063</attribute_group_obj>
<attribute_group_name>DataContainer</attribute_group_name>
<attribute_group_narrative>SmartBusinessObject and other Data Container attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="759" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="02/03/2003" version_time="56823" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="30044.7063" record_version_obj="30045.7063" version_number_seq="1.09" secondary_key_value="UpdateTables" import_version_number_seq="1.09"><attribute_label>UpdateTables</attribute_label>
<attribute_group_obj>428.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>List of RowObjUpd table handles for contained SDOs</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>30044.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>428.7063</attribute_group_obj>
<attribute_group_name>DataContainer</attribute_group_name>
<attribute_group_narrative>SmartBusinessObject and other Data Container attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="760" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>UpdateTarget</attribute_label>
<attribute_group_obj>9.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>A character value of the handle of the object&apos;s Update Target.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>116.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>9.7063</attribute_group_obj>
<attribute_group_name>DataVisual</attribute_group_name>
<attribute_group_narrative>Data visualization object attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="761" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>UpdateTargetNames</attribute_label>
<attribute_group_obj>9.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The ObjectName of the Data Object to be updated by this
visual object. This would be set if the Update-Target is an SBO
or other Container with DataObjects.
Currently used when visual objects designed against an SDO with RowObject is linked to an SBO.</attribute_narrative>
<override_type>get</override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>1004945564.09</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>9.7063</attribute_group_obj>
<attribute_group_name>DataVisual</attribute_group_name>
<attribute_group_narrative>Data visualization object attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="762" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>UpdatingRecord</attribute_label>
<attribute_group_obj>438.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>686.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>438.7063</attribute_group_obj>
<attribute_group_name>Panel</attribute_group_name>
<attribute_group_narrative>SmartPanel attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="763" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>UseBegins</attribute_label>
<attribute_group_obj>608.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>TRUE when BEGINS is supposed to be used as operator  for character values.
NOT used for OperatorStyle &quot;RANGE&quot; or &quot;EXPLICIT&quot;.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>622.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>608.7063</attribute_group_obj>
<attribute_group_name>Filter</attribute_group_name>
<attribute_group_narrative>SmartFilter attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="764" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>UseContains</attribute_label>
<attribute_group_obj>608.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>TRUE when CONTAINS is supposed to be used as operator  for character values.
NOT used for OperatorStyle &quot;EXPLICIT&quot;.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>624.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>608.7063</attribute_group_obj>
<attribute_group_name>Filter</attribute_group_name>
<attribute_group_narrative>SmartFilter attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="765" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ValidateOnLoad</attribute_label>
<attribute_group_obj>511.49</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Defines whether the document should be validated on load.
See help for X-DOCUMENT:LOAD</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>950.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="09/04/2002" version_time="57077" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="511.49" record_version_obj="512.49" version_number_seq="2.49" secondary_key_value="XML" import_version_number_seq="2.49"><attribute_group_obj>511.49</attribute_group_obj>
<attribute_group_name>XML</attribute_group_name>
<attribute_group_narrative>SmartXML attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="766" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="03/07/2003" version_time="63471" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="36478.48" record_version_obj="36479.48" version_number_seq="1.09" secondary_key_value="VersionData" import_version_number_seq="1.09"><attribute_label>VersionData</attribute_label>
<attribute_group_obj>36427.48</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>If set to YES, this field indicates that the data in the table should be version-stamped.This will result in replication triggers on the table writing data to the gst_record_version table. This field corresponds to the entity level UDP setup in ERwin as VersionData. The version information is used to identify which records have changed for deployment purposes. This flag is used in conjunction with the enable_data_versioning on the dataset entity to determine exactly how the entity is versioned.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>36478.48</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="03/12/2003" version_time="66443" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="36427.48" record_version_obj="36428.48" version_number_seq="1.09" secondary_key_value="EntityAttributes" import_version_number_seq="1.09"><attribute_group_obj>36427.48</attribute_group_obj>
<attribute_group_name>EntityAttributes</attribute_group_name>
<attribute_group_narrative>This group contains attributes that are associated with entities. The attributes in this group correspond exactly to the field names in the GSC_ENTITY_MNEMONIC table, excpet that they have had the underscores removed. This convention is used so that it is possible to generically and quickly populate the attributes.</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="767" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ViewAs</attribute_label>
<attribute_group_obj>434.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The &apos;ViewAs&apos; definition  of the selection.
- combo-box,radio-set,selection-list OR browse 
- Uses colon as separator to define SUB-TYPE for combo-box or 
horizontal/vertical radio-set,</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>582.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>434.7063</attribute_group_obj>
<attribute_group_name>Select</attribute_group_name>
<attribute_group_narrative>SmartSelect attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="768" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ViewerLinkedFields</attribute_label>
<attribute_group_obj>1005095447.101</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Dynamic Lookup Linked fields to update value of on viewer, comma list of table.fieldname.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005089880.28</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_group_name>SdfAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Smart Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="769" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>ViewerLinkedWidgets</attribute_label>
<attribute_group_obj>1005095447.101</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>Dynamic Lookup linked field corresponding widget names to update value of in viewer, comma list, ? if not widget</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005089883.28</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_group_name>SdfAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Smart Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="770" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>VISIBLE</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>WidgetAttributes Visible</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005078423.09</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="771" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>VisibleRowids</attribute_label>
<attribute_group_obj>436.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>This property is used for the scrolling of the browse to trap the 
scroll notify event properly.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>496.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>436.7063</attribute_group_obj>
<attribute_group_name>Browser</attribute_group_name>
<attribute_group_narrative>SmartBrowser attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="772" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>VisibleRowReset</attribute_label>
<attribute_group_obj>436.7063</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Used to reset the list of rowids (VisibleRowids) in rowDisplay.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>498.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>436.7063</attribute_group_obj>
<attribute_group_name>Browser</attribute_group_name>
<attribute_group_narrative>SmartBrowser attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="773" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>VisibleRows</attribute_label>
<attribute_group_obj>1003183341</attribute_group_obj>
<data_type>4</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1003202030</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="774" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>VisualBlank</attribute_label>
<attribute_group_obj>608.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>The value that are used to visualize that we actually are 
searching for BLANK values. 
Toggles on and off with space-bar and off with back-space.</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>654.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>608.7063</attribute_group_obj>
<attribute_group_name>Filter</attribute_group_name>
<attribute_group_narrative>SmartFilter attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="775" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>VisualizationType</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>WidgetAttributes VisualizationType</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005095448.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="776" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>WaitForObject</attribute_label>
<attribute_group_obj>347.7063</attribute_group_obj>
<data_type>10</data_type>
<attribute_narrative>The handle of the object (most likely a SmartConsumer)  in the container that contains a WAIT-FOR that needs to be started 
with &apos;startWaitFor&apos;</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>371.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>347.7063</attribute_group_obj>
<attribute_group_name>Container</attribute_group_name>
<attribute_group_narrative>Container Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="777" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>Waiting</attribute_label>
<attribute_group_obj>505.49</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative>Stores the Waiting property which is used by the adapter&apos;s waitForMessages to determne whether to continue waiting for messages.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>896.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="09/04/2002" version_time="57079" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="505.49" record_version_obj="506.49" version_number_seq="3.49" secondary_key_value="Consumer" import_version_number_seq="3.49"><attribute_group_obj>505.49</attribute_group_obj>
<attribute_group_name>Consumer</attribute_group_name>
<attribute_group_narrative>SmartConsumer attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="778" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>Width</attribute_label>
<attribute_group_obj>3000002003.09</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative>A widget&apos;s width. The unit of measurement is determined by another
parameter.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005078416.09</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group" version_date="02/10/2003" version_time="59461" version_user="admin" deletion_flag="no" entity_mnemonic="rycap" key_field_value="3000002003.09" record_version_obj="3000002004.09" version_number_seq="1.09" secondary_key_value="ADMAttributes" import_version_number_seq="1.09"><attribute_group_obj>3000002003.09</attribute_group_obj>
<attribute_group_name>ADMAttributes</attribute_group_name>
<attribute_group_narrative>This group contains all attributes of ADM objects excepts those that can also be Widget Attributes. In that case, they are in the WidgetAttribute group.</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="779" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute" version_date="10/03/2002" version_time="45358" version_user="admin" deletion_flag="no" entity_mnemonic="rycat" key_field_value="1005099285.101" record_version_obj="5107.66" version_number_seq="2.66" secondary_key_value="WIDTH-CHARS" import_version_number_seq="2.66"><attribute_label>WIDTH-CHARS</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>5</data_type>
<attribute_narrative>Width in characters. This may currently be used when rendering some objects. There is no get function, use getWidth to retrieve the realized value from an object.</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005099285.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="780" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>WIDTH-PIXELS</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>4</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005099262.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="781" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>WindowFrameHandle</attribute_label>
<attribute_group_obj>347.7063</attribute_group_obj>
<data_type>10</data_type>
<attribute_narrative>Stores the optional frame of a Window container.
The somewhat strange name is used because this property ONLY  identifies the frame of a window container and must not be confused with the important ContainerHandle, which is the
widget handle of the container in all objects and in most cases 
stores the frame handle also for a SmartContainer.  
</attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>379.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>347.7063</attribute_group_obj>
<attribute_group_name>Container</attribute_group_name>
<attribute_group_narrative>Container Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="782" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>WindowName</attribute_label>
<attribute_group_obj>1003183341</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative></attribute_narrative>
<override_type>SET</override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1003571459</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="783" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>WindowTitleField</attribute_label>
<attribute_group_obj>1003183341</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1003591184</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="784" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>WindowTitleViewer</attribute_label>
<attribute_group_obj>347.7063</attribute_group_obj>
<data_type>1</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>yes</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>yes</system_owned>
<attribute_obj>410.7063</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>347.7063</attribute_group_obj>
<attribute_group_name>Container</attribute_group_name>
<attribute_group_narrative>Container Attributes</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="785" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>WORD-WRAP</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>3</data_type>
<attribute_narrative></attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005099290.101</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="786" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>X</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>4</data_type>
<attribute_narrative>A widget&apos;s X coordinate</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005078417.09</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="787" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_attribute"><attribute_label>Y</attribute_label>
<attribute_group_obj>1005078412.09</attribute_group_obj>
<data_type>4</data_type>
<attribute_narrative>A widget&apos;s Y coordinate</attribute_narrative>
<override_type></override_type>
<runtime_only>no</runtime_only>
<is_private>no</is_private>
<constant_level></constant_level>
<derived_value>no</derived_value>
<lookup_type></lookup_type>
<lookup_value></lookup_value>
<design_only>no</design_only>
<system_owned>no</system_owned>
<attribute_obj>1005078419.09</attribute_obj>
<contained_record DB="icfdb" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
</contained_record>
</dataset_transaction>
</dataset_records>
</dataset>