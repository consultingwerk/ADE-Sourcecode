<?xml version="1.0" encoding="ISO8859-1" ?>
<dataset Transactions="247" version_date="02/23/2002" version_time="43178" version_user="admin" entity_mnemonic="GSTDF" key_field_value="3000000455.09" record_version_obj="3000000456.09" version_number_seq="2.09" import_version_number_seq="1.09"><dataset_header DisableRI="yes" DatasetObj="1007600083.08" DateFormat="mdy" FullHeader="yes" SCMManaged="no" YearOffset="1950" DatasetCode="RYCAT" DateCreated="02/23/2002" TimeCreated="11:58:56" NumericFormat="AMERICAN" NumericDecimal="." OriginatingSite="93" NumericSeparator=","><deploy_dataset_obj>1007600083.08</deploy_dataset_obj>
<owner_site_code></owner_site_code>
<dataset_code>RYCAT</dataset_code>
<dataset_description>ryc_attribute - Attribute Dataset</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
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
<entity_mnemonic_description>ryc_attribute</entity_mnemonic_description>
<entity_dbname>icfdb</entity_dbname>
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
<entity_mnemonic_description>ryc_attribute_group</entity_mnemonic_description>
<entity_dbname>icfdb</entity_dbname>
</dataset_entity>
<dataset_entity><dataset_entity_obj>1007600086.08</dataset_entity_obj>
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
<entity_mnemonic_description>ryc_attribute_type</entity_mnemonic_description>
<entity_dbname>icfdb</entity_dbname>
</dataset_entity>
<table_definition><name>ryc_attribute</name>
<dbname>ICFDB</dbname>
<index-1>XAK2ryc_attribute,1,0,0,attribute_label,0</index-1>
<index-2>XIE1ryc_attribute,0,0,0,attribute_type_tla,0</index-2>
<index-3>XIE2ryc_attribute,0,0,0,attribute_obj,0</index-3>
<index-4>XPKryc_attribute,1,1,0,attribute_group_obj,0,attribute_label,0,attribute_type_tla,0</index-4>
<field><name>attribute_group_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>>>>>>>>>>>>>>>>>>9.999999999</format>
<initial>                 0.000000000</initial>
<label>Attribute Group Obj</label>
<column-label>Attribute Group Obj</column-label>
</field>
<field><name>attribute_label</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>Attribute Label</label>
<column-label>Attribute Label</column-label>
</field>
<field><name>attribute_type_tla</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(3)</format>
<initial></initial>
<label>Attribute Type TLA</label>
<column-label>Attribute Type TLA</column-label>
</field>
<field><name>attribute_narrative</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(500)</format>
<initial></initial>
<label>Attribute Narrative</label>
<column-label>Attribute Narrative</column-label>
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
<format>>>>>>>>>>>>>>>>>>9.999999999</format>
<initial>                 0.000000000</initial>
<label>Attribute Obj</label>
<column-label>Attribute Obj</column-label>
</field>
</table_definition>
<table_definition><name>ryc_attribute_group</name>
<dbname>ICFDB</dbname>
<index-1>XAK1ryc_attribute_group,1,0,0,attribute_group_name,0</index-1>
<index-2>XPKryc_attribute_group,1,1,0,attribute_group_obj,0</index-2>
<field><name>attribute_group_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>>>>>>>>>>>>>>>>>>9.999999999</format>
<initial>                 0.000000000</initial>
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
<table_definition><name>ryc_attribute_type</name>
<dbname>ICFDB</dbname>
<index-1>XAK1ryc_attribute_type,1,0,0,attribute_type_obj,0</index-1>
<index-2>XIE1ryc_attribute_type,0,0,0,attribute_type_description,0</index-2>
<index-3>XPKryc_attribute_type,1,1,0,attribute_type_tla,0</index-3>
<field><name>attribute_type_tla</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(3)</format>
<initial></initial>
<label>Attribute Type TLA</label>
<column-label>Attribute Type TLA</column-label>
</field>
<field><name>attribute_type_description</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>Attribute Type Description</label>
<column-label>Attribute Type Description</column-label>
</field>
<field><name>collection_attribute</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>Collection Attribute</label>
<column-label>Collection Attribute</column-label>
</field>
<field><name>edit_program</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Edit Program</label>
<column-label>Edit Program</column-label>
</field>
<field><name>attribute_type_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>>>>>>>>>>>>>>>>>>9.999999999</format>
<initial>                 0.000000000</initial>
<label>Attribute Type Obj</label>
<column-label>Attribute Type Obj</column-label>
</field>
</table_definition>
</dataset_header>
<dataset_records><dataset_transaction TransactionNo="1"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_label>ActionGroups</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1003498429</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="2"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_label>AppService</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1003183455</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="3"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_label>ASInfo</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1003183460</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="4"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_label>ASUsePrompt</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1003183458</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="5"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_label>AsynchronousSDO</attribute_label>
<attribute_type_tla>LOG</attribute_type_tla>
<attribute_narrative>Stops updateState so that an SDO can have several updateSources</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1004959733.09</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>LOG</attribute_type_tla>
<attribute_type_description>Logical</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183350</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="6"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_label>CheckCurrentChanged</attribute_label>
<attribute_type_tla>LOG</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1003183466</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>LOG</attribute_type_tla>
<attribute_type_description>Logical</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183350</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="7"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_label>ContainerMode</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1003585204</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="8"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_label>DataSourceNames</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1004945563.09</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="9"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_label>DeactivateTargetOnHide</attribute_label>
<attribute_type_tla>LOG</attribute_type_tla>
<attribute_narrative>Created automatically from the object's instance attributes.</attribute_narrative>
<system_owned>yes</system_owned>
<attribute_obj>1779.66</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>LOG</attribute_type_tla>
<attribute_type_description>Logical</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183350</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="10"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_label>DestroyStateless</attribute_label>
<attribute_type_tla>LOG</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1003183472</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>LOG</attribute_type_tla>
<attribute_type_description>Logical</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183350</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="11"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_label>DisabledActions</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative>Created automatically from the object's instance attributes.</attribute_narrative>
<system_owned>yes</system_owned>
<attribute_obj>181</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="12"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_label>DisableOnInit</attribute_label>
<attribute_type_tla>LOG</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1003183449</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>LOG</attribute_type_tla>
<attribute_type_description>Logical</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183350</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="13"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_label>DisableStates</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1003202028</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="14"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_label>DisconnectAppServer</attribute_label>
<attribute_type_tla>LOG</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1003183474</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>LOG</attribute_type_tla>
<attribute_type_description>Logical</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183350</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="15"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_label>DisplayedFields</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1003466914</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="16"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_label>DynamicObject</attribute_label>
<attribute_type_tla>LOG</attribute_type_tla>
<attribute_narrative>Whether an object ins a dynamic object..</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005109093.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>LOG</attribute_type_tla>
<attribute_type_description>Logical</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183350</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="17"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_label>EdgePixels</attribute_label>
<attribute_type_tla>INT</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1003498439</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>INT</attribute_type_tla>
<attribute_type_description>Integer</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183380</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="18"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_label>EnabledFields</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1003466921</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="19"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_label>EnableField</attribute_label>
<attribute_type_tla>LOG</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005101029.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>LOG</attribute_type_tla>
<attribute_type_description>Logical</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183350</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="20"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_label>ENableStates</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1003202026</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="21"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_label>FlatButtons</attribute_label>
<attribute_type_tla>LOG</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1003498425</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>LOG</attribute_type_tla>
<attribute_type_description>Logical</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183350</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="22"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_label>FolderTabType</attribute_label>
<attribute_type_tla>INT</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1003202016</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>INT</attribute_type_tla>
<attribute_type_description>Integer</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183380</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="23"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_label>FolderWindowToLaunch</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1003466958</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="24"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_label>ForeignFields</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1003183462</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="25"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_label>HiddenActions</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative>Created automatically from the object's instance attributes.</attribute_narrative>
<system_owned>yes</system_owned>
<attribute_obj>183</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="26"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_label>HiddenMenuBands</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative>Created automatically from the object's instance attributes.</attribute_narrative>
<system_owned>yes</system_owned>
<attribute_obj>187</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="27"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_label>HiddenToolbarBands</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative>Created automatically from the object's instance attributes.</attribute_narrative>
<system_owned>yes</system_owned>
<attribute_obj>185</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="28"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_label>HideOnInit</attribute_label>
<attribute_type_tla>LOG</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1003183447</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>LOG</attribute_type_tla>
<attribute_type_description>Logical</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183350</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="29"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_label>ImageHeight</attribute_label>
<attribute_type_tla>INT</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1003202044</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>INT</attribute_type_tla>
<attribute_type_description>Integer</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183380</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="30"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_label>ImageWidth</attribute_label>
<attribute_type_tla>INT</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1003202042</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>INT</attribute_type_tla>
<attribute_type_description>Integer</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183380</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="31"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_label>ImageXOffset</attribute_label>
<attribute_type_tla>INT</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1003202046</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>INT</attribute_type_tla>
<attribute_type_description>Integer</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183380</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="32"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_label>ImageYOffset</attribute_label>
<attribute_type_tla>INT</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1003202048</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>INT</attribute_type_tla>
<attribute_type_description>Integer</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183380</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="33"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_label>InheritColor</attribute_label>
<attribute_type_tla>LOG</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1003202064</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>LOG</attribute_type_tla>
<attribute_type_description>Logical</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183350</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="34"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_label>LabelOffset</attribute_label>
<attribute_type_tla>INT</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1003202040</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>INT</attribute_type_tla>
<attribute_type_description>Integer</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183380</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="35"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_label>LogicalObjectName</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1003299781</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="36"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_label>Menu</attribute_label>
<attribute_type_tla>LOG</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1003498426</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>LOG</attribute_type_tla>
<attribute_type_description>Logical</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183350</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="37"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_label>MenuMergeOrder</attribute_label>
<attribute_type_tla>INT</attribute_type_tla>
<attribute_narrative>Created automatically from the object's instance attributes.</attribute_narrative>
<system_owned>yes</system_owned>
<attribute_obj>189</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>INT</attribute_type_tla>
<attribute_type_description>Integer</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183380</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="38"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_label>MinHeight</attribute_label>
<attribute_type_tla>DEC</attribute_type_tla>
<attribute_narrative>WidgetAttributes MinHeight</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>12.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>DEC</attribute_type_tla>
<attribute_type_description>Decimal</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1005091922.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="39"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_label>MinWidth</attribute_label>
<attribute_type_tla>DEC</attribute_type_tla>
<attribute_narrative>WidgetAttributes MinWidth</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>11.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>DEC</attribute_type_tla>
<attribute_type_description>Decimal</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1005091922.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="40"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_label>MouseCursor</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1003202062</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="41"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_label>NavigationTargetName</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative>Identifies the navigated object when the linked Navigationtarget is an object container.</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1004979019.09</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="42"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_label>ObjectLayout</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1003183452</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="43"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_label>PanelOffset</attribute_label>
<attribute_type_tla>INT</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1003202032</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>INT</attribute_type_tla>
<attribute_type_description>Integer</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183380</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="44"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_label>PanelType</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1003498440</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="45"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_label>RebuildOnRepos</attribute_label>
<attribute_type_tla>LOG</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1003183468</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>LOG</attribute_type_tla>
<attribute_type_description>Logical</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183350</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="46"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_label>ResizeHorizontal</attribute_label>
<attribute_type_tla>LOG</attribute_type_tla>
<attribute_narrative>Indicates if an object is Horizontally Resizable.</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>102.28</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>LOG</attribute_type_tla>
<attribute_type_description>Logical</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183350</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="47"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_label>ResizeVertical</attribute_label>
<attribute_type_tla>LOG</attribute_type_tla>
<attribute_narrative>Indicates if an object is Vertically Resizable.</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>103.28</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>LOG</attribute_type_tla>
<attribute_type_description>Logical</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183350</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="48"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_label>RowsToBatch</attribute_label>
<attribute_type_tla>INT</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1003183464</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>INT</attribute_type_tla>
<attribute_type_description>Integer</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183380</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="49"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_label>SelectorBGcolor</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1003202054</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="50"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_label>SelectorFGcolor</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1003202052</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="51"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_label>SelectorFont</attribute_label>
<attribute_type_tla>INT</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1003202056</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>INT</attribute_type_tla>
<attribute_type_description>Integer</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183380</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="52"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_label>SelectorWidth</attribute_label>
<attribute_type_tla>INT</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1003202058</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>INT</attribute_type_tla>
<attribute_type_description>Integer</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183380</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="53"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_label>ServerOperatingMode</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1003183470</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="54"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_label>ServerSubmitValidation</attribute_label>
<attribute_type_tla>LOG</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1003586096</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>LOG</attribute_type_tla>
<attribute_type_description>Logical</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183350</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="55"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_label>ShowBorder</attribute_label>
<attribute_type_tla>LOG</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1003498427</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>LOG</attribute_type_tla>
<attribute_type_description>Logical</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183350</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="56"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_label>SubModules</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1003498431</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="57"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_label>SupportedLinks</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1003498433</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="58"><contained_record DB="ICFDB" Table="ryc_attribute" version_date="02/14/2002" version_time="37307" version_user="admin" entity_mnemonic="rycat" key_field_value="1003202020" record_version_obj="1000015726.38" version_number_seq="1.39" import_version_number_seq="1.38"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_label>TabBGcolor</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1003202020</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="59"><contained_record DB="ICFDB" Table="ryc_attribute" version_date="02/14/2002" version_time="37309" version_user="admin" entity_mnemonic="rycat" key_field_value="1003202018" record_version_obj="1000015727.38" version_number_seq="1.39" import_version_number_seq="1.38"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_label>TabFGcolor</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1003202018</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="60"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_label>TabFont</attribute_label>
<attribute_type_tla>INT</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1003202038</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>INT</attribute_type_tla>
<attribute_type_description>Integer</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183380</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="61"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_label>TabHeight</attribute_label>
<attribute_type_tla>INT</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1003202036</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>INT</attribute_type_tla>
<attribute_type_description>Integer</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183380</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="62"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_label>TabHidden</attribute_label>
<attribute_type_tla>LOG</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1003202024</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>LOG</attribute_type_tla>
<attribute_type_description>Logical</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183350</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="63"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_label>TabINcolor</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1003202022</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="64"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_label>TableIOType</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1003498432</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="65"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_label>TabPosition</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1003202060</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="66"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_label>TabSize</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1003202050</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="67"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_label>TabsPerRow</attribute_label>
<attribute_type_tla>INT</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1003202034</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>INT</attribute_type_tla>
<attribute_type_description>Integer</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183380</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="68"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_label>TemplateObjectName</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative>Used by the Dynamic Container Builder Property Sheet.</attribute_narrative>
<system_owned>yes</system_owned>
<attribute_obj>1007500648.09</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="69"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_label>Toolbar</attribute_label>
<attribute_type_tla>LOG</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1003498428</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>LOG</attribute_type_tla>
<attribute_type_description>Logical</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183350</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="70"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_label>ToolbarAutoSize</attribute_label>
<attribute_type_tla>LOG</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1003498436</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>LOG</attribute_type_tla>
<attribute_type_description>Logical</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183350</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="71"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_label>ToolbarBands</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1003498434</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="72"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_label>ToolbarDrawDirection</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1003498437</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="73"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_label>ToolbarInitialState</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1003498438</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="74"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_label>ToolbarParentMenu</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1003498435</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="75"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_label>ToolMarginPxl</attribute_label>
<attribute_type_tla>INT</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1003504309</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>INT</attribute_type_tla>
<attribute_type_description>Integer</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183380</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="76"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_label>UpdateTargetNames</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1004945564.09</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="77"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_label>VisibleRows</attribute_label>
<attribute_type_tla>INT</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1003202030</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>INT</attribute_type_tla>
<attribute_type_description>Integer</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183380</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="78"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_label>WindowName</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1003571459</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="79"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_label>WindowTitleField</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1003591184</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1003183341</attribute_group_obj>
<attribute_group_name>Defaults</attribute_group_name>
<attribute_group_narrative>Default group for all attributes initially</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="80"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>ATTR-SPACE</attribute_label>
<attribute_type_tla>LOG</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005099316.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>LOG</attribute_type_tla>
<attribute_type_description>Logical</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183350</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="81"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>AUTO-COMPLETION</attribute_label>
<attribute_type_tla>LOG</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005099332.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>LOG</attribute_type_tla>
<attribute_type_description>Logical</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183350</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="82"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>AUTO-END-KEY</attribute_label>
<attribute_type_tla>LOG</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005099320.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>LOG</attribute_type_tla>
<attribute_type_description>Logical</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183350</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="83"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>AUTO-GO</attribute_label>
<attribute_type_tla>LOG</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005099319.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>LOG</attribute_type_tla>
<attribute_type_description>Logical</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183350</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="84"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>AUTO-INDENT</attribute_label>
<attribute_type_tla>LOG</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005099275.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>LOG</attribute_type_tla>
<attribute_type_description>Logical</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183350</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="85"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>AUTO-RESIZE</attribute_label>
<attribute_type_tla>LOG</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005099296.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>LOG</attribute_type_tla>
<attribute_type_description>Logical</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183350</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="86"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>AUTO-RETURN</attribute_label>
<attribute_type_tla>LOG</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005099315.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>LOG</attribute_type_tla>
<attribute_type_description>Logical</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183350</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="87"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>AUTO-ZAP</attribute_label>
<attribute_type_tla>LOG</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005099313.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>LOG</attribute_type_tla>
<attribute_type_description>Logical</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183350</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="88"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>BGCOLOR</attribute_label>
<attribute_type_tla>INT</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005099282.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>INT</attribute_type_tla>
<attribute_type_description>Integer</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183380</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="89"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>BLANK</attribute_label>
<attribute_type_tla>LOG</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005099318.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>LOG</attribute_type_tla>
<attribute_type_description>Logical</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183350</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="90"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>BOX</attribute_label>
<attribute_type_tla>LOG</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005099272.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>LOG</attribute_type_tla>
<attribute_type_description>Logical</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183350</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="91"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>BUFFER-CHARS</attribute_label>
<attribute_type_tla>INT</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005099297.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>INT</attribute_type_tla>
<attribute_type_description>Integer</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183380</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="92"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>BUFFER-LINES</attribute_label>
<attribute_type_tla>INT</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005099298.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>INT</attribute_type_tla>
<attribute_type_description>Integer</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183380</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="93"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>CHECKED</attribute_label>
<attribute_type_tla>LOG</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005099329.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>LOG</attribute_type_tla>
<attribute_type_description>Logical</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183350</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="94"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>Column</attribute_label>
<attribute_type_tla>DEC</attribute_type_tla>
<attribute_narrative>WidgetAttributes Column</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005078421.09</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>DEC</attribute_type_tla>
<attribute_type_description>Decimal</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1005091922.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="95"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>ColumnLabel</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative>WidgetAttributes ColumnLabel</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>3000000341.09</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="96"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>ColumnNumber</attribute_label>
<attribute_type_tla>INT</attribute_type_tla>
<attribute_narrative>The column number of the widget</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005093795.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>INT</attribute_type_tla>
<attribute_type_description>Integer</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183380</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="97"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>COLUMNS</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005099309.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="98"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>ColumnSequence</attribute_label>
<attribute_type_tla>INT</attribute_type_tla>
<attribute_narrative>The sequence number of the widget within a column</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005093796.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>INT</attribute_type_tla>
<attribute_type_description>Integer</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183380</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="99"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>CONTEXT-HELP-ID</attribute_label>
<attribute_type_tla>INT</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005099306.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>INT</attribute_type_tla>
<attribute_type_description>Integer</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183380</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="100"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>CONVERT-3D-COLORS</attribute_label>
<attribute_type_tla>LOG</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005099322.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>LOG</attribute_type_tla>
<attribute_type_description>Logical</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183350</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="101"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>CURSOR-CHAR</attribute_label>
<attribute_type_tla>INT</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005099278.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>INT</attribute_type_tla>
<attribute_type_description>Integer</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183380</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="102"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>CURSOR-LINE</attribute_label>
<attribute_type_tla>INT</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005099277.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>INT</attribute_type_tla>
<attribute_type_description>Integer</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183380</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="103"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>CURSOR-OFFSET</attribute_label>
<attribute_type_tla>INT</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005099276.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>INT</attribute_type_tla>
<attribute_type_description>Integer</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183380</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="104"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>DATA-TYPE</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative>WidgetAttributes Data-Type</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005078413.09</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="105"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>DatabaseName</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative>WidgetAttributes DataBaseName</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005078711.09</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="106"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>DataSourceName</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative>DataSourceName</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005104898.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="107"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>DCOLOR</attribute_label>
<attribute_type_tla>INT</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005099287.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>INT</attribute_type_tla>
<attribute_type_description>Integer</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183380</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="108"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>DEBLANK</attribute_label>
<attribute_type_tla>LOG</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005099317.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>LOG</attribute_type_tla>
<attribute_type_description>Logical</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183350</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="109"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>DEFAULT</attribute_label>
<attribute_type_tla>LOG</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005099324.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>LOG</attribute_type_tla>
<attribute_type_description>Logical</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183350</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="110"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>DELIMITER</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005099335.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="111"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>DISABLE-AUTO-ZAP</attribute_label>
<attribute_type_tla>LOG</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005099314.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>LOG</attribute_type_tla>
<attribute_type_description>Logical</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183350</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="112"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>DisplayField</attribute_label>
<attribute_type_tla>LOG</attribute_type_tla>
<attribute_narrative>WidgetAttributes DisplayField</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005078597.09</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>LOG</attribute_type_tla>
<attribute_type_description>Logical</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183350</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="113"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>DRAG-ENABLED</attribute_label>
<attribute_type_tla>LOG</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005099337.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>LOG</attribute_type_tla>
<attribute_type_description>Logical</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183350</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="114"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>DROP-TARGET</attribute_label>
<attribute_type_tla>LOG</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005099307.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>LOG</attribute_type_tla>
<attribute_type_description>Logical</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183350</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="115"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>DropTarget</attribute_label>
<attribute_type_tla>LOG</attribute_type_tla>
<attribute_narrative>Whetehr the widget is a drop target or not.</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005098176.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>LOG</attribute_type_tla>
<attribute_type_description>Logical</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183350</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="116"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>EDGE-CHARS</attribute_label>
<attribute_type_tla>DEC</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005099326.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>DEC</attribute_type_tla>
<attribute_type_description>Decimal</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1005091922.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="117"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>EDGE-PIXELS</attribute_label>
<attribute_type_tla>INT</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005099327.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>INT</attribute_type_tla>
<attribute_type_description>Integer</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183380</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="118"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>EDIT-CAN-UNDO</attribute_label>
<attribute_type_tla>LOG</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005099305.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>LOG</attribute_type_tla>
<attribute_type_description>Logical</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183350</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="119"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>Enabled</attribute_label>
<attribute_type_tla>LOG</attribute_type_tla>
<attribute_narrative>WidgetAttributes Enabled</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005078422.09</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>LOG</attribute_type_tla>
<attribute_type_description>Logical</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183350</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="120"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>EnabledField</attribute_label>
<attribute_type_tla>LOG</attribute_type_tla>
<attribute_narrative>Whether the fields should be enabled</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005078596.09</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>LOG</attribute_type_tla>
<attribute_type_description>Logical</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183350</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="121"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>FGCOLOR</attribute_label>
<attribute_type_tla>INT</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005099283.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>INT</attribute_type_tla>
<attribute_type_description>Integer</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183380</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="122"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>FieldName</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative>WidgetAttributes FieldName</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005078709.09</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="123"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>FieldOrder</attribute_label>
<attribute_type_tla>INT</attribute_type_tla>
<attribute_narrative>WidgetAttributes FieldOrder</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005124464.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>INT</attribute_type_tla>
<attribute_type_description>Integer</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183380</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="124"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>FILLED</attribute_label>
<attribute_type_tla>LOG</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005099325.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>LOG</attribute_type_tla>
<attribute_type_description>Logical</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183350</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="125"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>FLAT-BUTTON</attribute_label>
<attribute_type_tla>LOG</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005099323.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>LOG</attribute_type_tla>
<attribute_type_description>Logical</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183350</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="126"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>FONT</attribute_label>
<attribute_type_tla>INT</attribute_type_tla>
<attribute_narrative>WidgetAttributes Font</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005099311.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>INT</attribute_type_tla>
<attribute_type_description>Integer</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183380</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="127"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>Format</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative>WidgetAttributes Format</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005078460.09</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="128"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>FRAME</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005099310.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="129"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>GRAPHIC-EDGE</attribute_label>
<attribute_type_tla>LOG</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005099328.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>LOG</attribute_type_tla>
<attribute_type_description>Logical</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183350</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="130"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>Height</attribute_label>
<attribute_type_tla>DEC</attribute_type_tla>
<attribute_narrative>A widget's height. The unit of measurement is determined by another 
parameter.</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005078415.09</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>DEC</attribute_type_tla>
<attribute_type_description>Decimal</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1005091922.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="131"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>HEIGHT-CHARS</attribute_label>
<attribute_type_tla>DEC</attribute_type_tla>
<attribute_narrative>WidgetAttributes Height-Chars</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005099284.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>DEC</attribute_type_tla>
<attribute_type_description>Decimal</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1005091922.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="132"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>HEIGHT-PIXELS</attribute_label>
<attribute_type_tla>INT</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005099264.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>INT</attribute_type_tla>
<attribute_type_description>Integer</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183380</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="133"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>HELP</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative>WidgetAttributes Help</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005099308.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="134"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>HIDDEN</attribute_label>
<attribute_type_tla>LOG</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005099301.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>LOG</attribute_type_tla>
<attribute_type_description>Logical</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183350</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="135"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>InitialValue</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative>WidgetAttributes InitialValue</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>3000000338.09</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="136"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>INNER-CHARS</attribute_label>
<attribute_type_tla>INT</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005099289.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>INT</attribute_type_tla>
<attribute_type_description>Integer</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183380</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="137"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>INNER-LINES</attribute_label>
<attribute_type_tla>INT</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005099288.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>INT</attribute_type_tla>
<attribute_type_description>Integer</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183380</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="138"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>Label</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative>WidgetAttributes Label</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005095224.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="139"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>LabelBgColor</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative>WidgetAttributes LabelBgColor</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005104906.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="140"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>LabelFgColor</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative>WidgetAttributes LabelFgColor</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005104908.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="141"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>LabelFont</attribute_label>
<attribute_type_tla>INT</attribute_type_tla>
<attribute_narrative>WidgetAttributes LabelFont</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005104904.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>INT</attribute_type_tla>
<attribute_type_description>Integer</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183380</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="142"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>LIST-ITEM-PAIRS</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005099334.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="143"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>LIST-ITEMS</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005099330.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="144"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>Mandatory</attribute_label>
<attribute_type_tla>LOG</attribute_type_tla>
<attribute_narrative>WidgetAttributes Mandatory</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005104900.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>LOG</attribute_type_tla>
<attribute_type_description>Logical</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183350</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="145"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>MANUAL-HIGHLIGHT</attribute_label>
<attribute_type_tla>LOG</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005099291.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>LOG</attribute_type_tla>
<attribute_type_description>Logical</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183350</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="146"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>MAX-CHARS</attribute_label>
<attribute_type_tla>DEC</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005099271.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>DEC</attribute_type_tla>
<attribute_type_description>Decimal</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1005091922.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="147"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>MENU-KEY</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005099292.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="148"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>MENU-MOUSE</attribute_label>
<attribute_type_tla>INT</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005099293.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>INT</attribute_type_tla>
<attribute_type_description>Integer</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183380</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="149"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>MODIFIED</attribute_label>
<attribute_type_tla>LOG</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005099279.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>LOG</attribute_type_tla>
<attribute_type_description>Logical</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183350</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="150"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>MOVABLE</attribute_label>
<attribute_type_tla>LOG</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005099268.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>LOG</attribute_type_tla>
<attribute_type_description>Logical</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183350</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="151"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>MULTIPLE</attribute_label>
<attribute_type_tla>LOG</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005099336.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>LOG</attribute_type_tla>
<attribute_type_description>Logical</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183350</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="152"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>NAME</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005099281.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="153"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>NO-FOCUS</attribute_label>
<attribute_type_tla>LOG</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005099321.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>LOG</attribute_type_tla>
<attribute_type_description>Logical</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183350</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="154"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>NoLabel</attribute_label>
<attribute_type_tla>LOG</attribute_type_tla>
<attribute_narrative>WidgetAttributes NoLabel</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>3000000331.09</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>LOG</attribute_type_tla>
<attribute_type_description>Logical</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183350</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="155"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>NoLookups</attribute_label>
<attribute_type_tla>LOG</attribute_type_tla>
<attribute_narrative>Whether to display a lookup or not</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005095449.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>LOG</attribute_type_tla>
<attribute_type_description>Logical</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183350</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="156"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>PARENT</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005099269.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="157"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>PFCOLOR</attribute_label>
<attribute_type_tla>INT</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005099295.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>INT</attribute_type_tla>
<attribute_type_description>Integer</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183380</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="158"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>POPUP-MENU</attribute_label>
<attribute_type_tla>LOG</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005099294.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>LOG</attribute_type_tla>
<attribute_type_description>Logical</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183350</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="159"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>PRIVATE-DATA</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005099265.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="160"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>PROGRESS-SOURCE</attribute_label>
<attribute_type_tla>LOG</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005099300.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>LOG</attribute_type_tla>
<attribute_type_description>Logical</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183350</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="161"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>READ-ONLY</attribute_label>
<attribute_type_tla>LOG</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005099280.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>LOG</attribute_type_tla>
<attribute_type_description>Logical</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183350</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="162"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>RESIZABLE</attribute_label>
<attribute_type_tla>LOG</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005099270.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>LOG</attribute_type_tla>
<attribute_type_description>Logical</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183350</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="163"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>RETURN-INSERTED</attribute_label>
<attribute_type_tla>LOG</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005099302.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>LOG</attribute_type_tla>
<attribute_type_description>Logical</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183350</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="164"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>Row</attribute_label>
<attribute_type_tla>DEC</attribute_type_tla>
<attribute_narrative>WidgetAttributes Row</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005078420.09</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>DEC</attribute_type_tla>
<attribute_type_description>Decimal</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1005091922.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="165"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>SCREEN-VALUE</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005099299.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="166"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>SCROLLBAR-HORIZONTAL</attribute_label>
<attribute_type_tla>LOG</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005099273.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>LOG</attribute_type_tla>
<attribute_type_description>Logical</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183350</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="167"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>SCROLLBAR-VERTICAL</attribute_label>
<attribute_type_tla>LOG</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005099274.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>LOG</attribute_type_tla>
<attribute_type_description>Logical</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183350</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="168"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>SELECTABLE</attribute_label>
<attribute_type_tla>LOG</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005099266.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>LOG</attribute_type_tla>
<attribute_type_description>Logical</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183350</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="169"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>SELECTED</attribute_label>
<attribute_type_tla>LOG</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005099267.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>LOG</attribute_type_tla>
<attribute_type_description>Logical</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183350</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="170"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>SENSITIVE</attribute_label>
<attribute_type_tla>LOG</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005099263.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>LOG</attribute_type_tla>
<attribute_type_description>Logical</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183350</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="171"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>ShowPopup</attribute_label>
<attribute_type_tla>LOG</attribute_type_tla>
<attribute_narrative>WidgetAttributes ShowPopup</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>3000000298.09</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>LOG</attribute_type_tla>
<attribute_type_description>Logical</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183350</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="172"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>SIDE-LABEL-HANDLE</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005099286.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="173"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>SORT</attribute_label>
<attribute_type_tla>LOG</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005099331.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>LOG</attribute_type_tla>
<attribute_type_description>Logical</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183350</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="174"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>SUBTYPE</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005099312.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="175"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>TAB-STOP</attribute_label>
<attribute_type_tla>LOG</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005099303.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>LOG</attribute_type_tla>
<attribute_type_description>Logical</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183350</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="176"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>TableName</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative>WidgetAttributes TableName</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005078710.09</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="177"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>TabOrder</attribute_label>
<attribute_type_tla>INT</attribute_type_tla>
<attribute_narrative>TabOrder</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005104902.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>INT</attribute_type_tla>
<attribute_type_description>Integer</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183380</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="178"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>TOOLTIP</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005099304.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="179"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>UNIQUE-MATCH</attribute_label>
<attribute_type_tla>LOG</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005099333.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>LOG</attribute_type_tla>
<attribute_type_description>Logical</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183350</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="180"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>Visible</attribute_label>
<attribute_type_tla>LOG</attribute_type_tla>
<attribute_narrative>WidgetAttributes Visible</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005078423.09</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>LOG</attribute_type_tla>
<attribute_type_description>Logical</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183350</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="181"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>VisualizationType</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative>WidgetAttributes VisualizationType</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005095448.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="182"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>WidgetName</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative>The name of the widget</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005078414.09</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="183"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>Width</attribute_label>
<attribute_type_tla>DEC</attribute_type_tla>
<attribute_narrative>A widget's width. The unit of measurement is determined by another
parameter.</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005078416.09</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>DEC</attribute_type_tla>
<attribute_type_description>Decimal</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1005091922.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="184"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>WIDTH-CHARS</attribute_label>
<attribute_type_tla>DEC</attribute_type_tla>
<attribute_narrative>WidgetAttributes Width-Chars</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005099285.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>DEC</attribute_type_tla>
<attribute_type_description>Decimal</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1005091922.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="185"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>WIDTH-PIXELS</attribute_label>
<attribute_type_tla>INT</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005099262.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>INT</attribute_type_tla>
<attribute_type_description>Integer</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183380</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="186"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>WORD-WRAP</attribute_label>
<attribute_type_tla>LOG</attribute_type_tla>
<attribute_narrative></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005099290.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>LOG</attribute_type_tla>
<attribute_type_description>Logical</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183350</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="187"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>x</attribute_label>
<attribute_type_tla>INT</attribute_type_tla>
<attribute_narrative>A widget's X coordinate</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005078417.09</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>INT</attribute_type_tla>
<attribute_type_description>Integer</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183380</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="188"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_label>y</attribute_label>
<attribute_type_tla>INT</attribute_type_tla>
<attribute_narrative>A widget's Y coordinate</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005078419.09</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005078412.09</attribute_group_obj>
<attribute_group_name>WidgetAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>INT</attribute_type_tla>
<attribute_type_description>Integer</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183380</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="189"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005095446.101</attribute_group_obj>
<attribute_label>DataSource</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative>WidgetAttributes DataSource</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005109051.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005095446.101</attribute_group_obj>
<attribute_group_name>ViewerAttributes</attribute_group_name>
<attribute_group_narrative>These are attributes which belong to a Dynamic Viewer</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="190"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005095446.101</attribute_group_obj>
<attribute_label>FrameMinHeightChars</attribute_label>
<attribute_type_tla>DEC</attribute_type_tla>
<attribute_narrative>The calculated minimum height of the viewer's frame, in characters.</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005109052.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005095446.101</attribute_group_obj>
<attribute_group_name>ViewerAttributes</attribute_group_name>
<attribute_group_narrative>These are attributes which belong to a Dynamic Viewer</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>DEC</attribute_type_tla>
<attribute_type_description>Decimal</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1005091922.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="191"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005095446.101</attribute_group_obj>
<attribute_label>FrameMinWidthChars</attribute_label>
<attribute_type_tla>DEC</attribute_type_tla>
<attribute_narrative>The calculated minimum width of the viewer's frame, in characters.</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005109053.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005095446.101</attribute_group_obj>
<attribute_group_name>ViewerAttributes</attribute_group_name>
<attribute_group_narrative>These are attributes which belong to a Dynamic Viewer</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>DEC</attribute_type_tla>
<attribute_type_description>Decimal</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1005091922.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="192"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005095446.101</attribute_group_obj>
<attribute_label>LayoutType</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative>The type of layout to use. Valid values include Manager, Widget and 
Column.</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005095450.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005095446.101</attribute_group_obj>
<attribute_group_name>ViewerAttributes</attribute_group_name>
<attribute_group_narrative>These are attributes which belong to a Dynamic Viewer</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="193"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005095446.101</attribute_group_obj>
<attribute_label>LayoutUnits</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative>The units to use for layout purposes.</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005095452.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005095446.101</attribute_group_obj>
<attribute_group_name>ViewerAttributes</attribute_group_name>
<attribute_group_narrative>These are attributes which belong to a Dynamic Viewer</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="194"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005095446.101</attribute_group_obj>
<attribute_label>SizeUnits</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative>The units to use when sizing the widgets on a viewer.</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005095451.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005095446.101</attribute_group_obj>
<attribute_group_name>ViewerAttributes</attribute_group_name>
<attribute_group_narrative>These are attributes which belong to a Dynamic Viewer</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="195"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_label>BaseQueryString</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative>Dynamic Lookup/Combo Base Browse query string (design time)</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005089874.28</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_group_name>SdfAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Smart Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="196"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_label>BrowseFieldDataTypes</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative>Dynamic Lookup Data types of fields to display in lookup browser, comma list.</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005089877.28</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_group_name>SdfAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Smart Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="197"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_label>BrowseFieldFormats</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative>Dynamic Lookup Formats of fields to display in lookup browser, comma list. (Default Formats)</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005089878.28</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_group_name>SdfAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Smart Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="198"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_label>BrowseFields</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative>Dynamic Lookup Fields to display in lookup browser, comma list of table.field.</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005089876.28</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_group_name>SdfAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Smart Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="199"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_label>BrowseProcedure</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative>The name of the browser to use for Dynamic Lookup - default is ry/obj/rydynbrowb.w</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005089890.28</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_group_name>SdfAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Smart Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="200"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_label>BrowseTitle</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative>Title for lookup browser for Dynamic Lookups.</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005089879.28</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_group_name>SdfAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Smart Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="201"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_label>BrowseWindowProcedure</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative>The name of the window to display the browse on for Dynamic Lookups - default is ry/uib/rydyncontw.w</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005089889.28</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_group_name>SdfAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Smart Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="202"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_label>BuildSequence</attribute_label>
<attribute_type_tla>INT</attribute_type_tla>
<attribute_narrative>The sequence number in which the Dynamic Combo's data should be build.</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005115831.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_group_name>SdfAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Smart Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>INT</attribute_type_tla>
<attribute_type_description>Integer</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183380</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="203"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_label>ColumnFormat</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative>Dynamic Lookup browse column format override - comma list.</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005089895.28</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_group_name>SdfAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Smart Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="204"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_label>ColumnLabels</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative>Dynamic Lookup browse override labels - comma list</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005089894.28</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_group_name>SdfAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Smart Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="205"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_label>ComboFlag</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative>Optional Dynamic Combo flags - Contains 'A' for &lt;All> or 'N' for &lt;None> - Blank will indicate that no extra option should be added to combo.</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005111017.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_group_name>SdfAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Smart Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="206"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_label>ComboFlagValue</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative>The value for the optional Dynamic Combo flags &lt;All> and &lt;None></attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005114147.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_group_name>SdfAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Smart Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="207"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_label>ComboSort</attribute_label>
<attribute_type_tla>LOG</attribute_type_tla>
<attribute_narrative>YES or NO to set a Dynamic Combo's COMBO-BOX sort option.</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005111019.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_group_name>SdfAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Smart Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>LOG</attribute_type_tla>
<attribute_type_description>Logical</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183350</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="208"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_label>DescSubstitute</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative>The field substitution list for Dynamic Combos</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005111016.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_group_name>SdfAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Smart Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="209"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_label>DisplayDataType</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative>Datatype of Dynamic Lookup display field.</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005089873.28</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_group_name>SdfAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Smart Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="210"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_label>DisplayedField</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative>For Dynamic Lookups. The name of the field being displayed from the query. (Table.Field). For Dynamic Combo's a comma seperated list of table.field name of the fields to be displayed as description values in the combo-box.</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005089864.28</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_group_name>SdfAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Smart Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="211"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_label>DisplayFormat</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative>Format of Dynamic Lookup/Dynamic Combo display field. In the case of the Dynamic Combo, if more than one field is being displayed in the combo-box - the default value must always be CHARACTER</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005089872.28</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_group_name>SdfAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Smart Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="212"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_label>FieldLabel</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative>Label for the Dynamic Lookup/Dynamic Combo field on the viewer.</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005089868.28</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_group_name>SdfAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Smart Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="213"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_label>FieldTooltip</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative>Tooltip for displayed Dynamic Lookup/Dynamic Combo field.</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005089869.28</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_group_name>SdfAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Smart Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="214"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_label>FlagValue</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative>Dynamic Combo. This field contains the default optional combo flag value for the &lt;All> and &lt;None> options. This allows the user to override the default values like . or 0.</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005111018.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_group_name>SdfAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Smart Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="215"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_label>InnerLines</attribute_label>
<attribute_type_tla>INT</attribute_type_tla>
<attribute_narrative>Sets the INNER-LINES property of a Dynamic Combo</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>10.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_group_name>SdfAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Smart Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>INT</attribute_type_tla>
<attribute_type_description>Integer</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183380</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="216"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_label>KeyDataType</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative>Data type of Dynamic Lookup/Dynamic Combo key field.</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005089871.28</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_group_name>SdfAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Smart Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="217"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_label>KeyField</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative>Name of the Dynamic Lookup/Dynamic Combo key field to assign value from (Table.Field)</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005089867.28</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_group_name>SdfAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Smart Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="218"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_label>KeyFormat</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative>Format of Dynamic Lookup/Dynaic Combo key field.</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005089870.28</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_group_name>SdfAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Smart Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="219"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_label>LinkedFieldDataTypes</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative>Dynamic Lookup linked fields data types to display in viewer, comma list.</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005089881.28</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_group_name>SdfAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Smart Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="220"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_label>LinkedFieldFormats</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative>Dynamic Lookup linked field formats from lookup to display in viewer, comma list.</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005089882.28</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_group_name>SdfAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Smart Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="221"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_label>LookupImage</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative>Image to use for Dynamic Lookup button (binoculars) - default will always be adeicon/select.bmp</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005089887.28</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_group_name>SdfAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Smart Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="222"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_label>MaintenanceObject</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative>The logical object name of the object to be used when data for the table being queried using Dynamic Lookups can be maintained.</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005089898.28</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_group_name>SdfAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Smart Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="223"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_label>MaintenanceSDO</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative>This attribute contains the name of an SDO to be assosiated with a maintenance folder for the Dynamic Lookups.</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005101356.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_group_name>SdfAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Smart Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="224"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_label>MasterFile</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative>The physical file used to launch the SmartDataField. The default value for a Dynamic Lookup is adm2/dynlookup.w; and for a Dynamic Combo it is adm2/dyncombo.w.</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005101640.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_group_name>SdfAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Smart Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="225"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_label>ParentField</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative>A field or widget name to a parent field on the viewer that will determine the filter query for a Dynamic Lookup/Dynamic Combo.</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005089896.28</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_group_name>SdfAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Smart Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="226"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_label>ParentFilterQuery</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative>A Query sting used to filter the Base query of Dynamic Lookups/Dynamic Combos that depends on a parent field.</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005089897.28</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_group_name>SdfAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Smart Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="227"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_label>QueryTables</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative>Comma list of query tables for Dynamic Lookups/Dynamic Combos (Buffers)</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005089875.28</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_group_name>SdfAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Smart Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="228"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_label>SDFFileName</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative>The SmarObject file name of the file used for the SmartLookupObject/SmartComboObject.</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005089865.28</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_group_name>SdfAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Smart Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="229"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_label>SDFTemplate</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative>The template SmartObject used to create a Dynamic Lookup/Dynamic Combo.</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005090095.28</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_group_name>SdfAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Smart Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="230"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_label>ViewerLinkedFields</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative>Dynamic Lookup Linked fields to update value of on viewer, comma list of table.fieldname.</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005089880.28</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_group_name>SdfAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Smart Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="231"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_label>ViewerLinkedWidgets</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative>Dynamic Lookup linked field corresponding widget names to update value of in viewer, comma list, ? if not widget</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005089883.28</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005095447.101</attribute_group_obj>
<attribute_group_name>SdfAttributes</attribute_group_name>
<attribute_group_narrative>Attributes for Smart Data Fields</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="232"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005097792.101</attribute_group_obj>
<attribute_label>AutoSort</attribute_label>
<attribute_type_tla>LOG</attribute_type_tla>
<attribute_narrative>Used to set the property of a SmartTreeView object to Automatically sort the nodes.</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005081438.28</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005097792.101</attribute_group_obj>
<attribute_group_name>TreeView</attribute_group_name>
<attribute_group_narrative>TreeView Group</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>LOG</attribute_type_tla>
<attribute_type_description>Logical</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183350</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="233"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005097792.101</attribute_group_obj>
<attribute_label>HideSelection</attribute_label>
<attribute_type_tla>LOG</attribute_type_tla>
<attribute_narrative>Used to set the property of a SmartTreeView object to indicate that a node should appear as selected or not.</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005081439.28</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005097792.101</attribute_group_obj>
<attribute_group_name>TreeView</attribute_group_name>
<attribute_group_narrative>TreeView Group</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>LOG</attribute_type_tla>
<attribute_type_description>Logical</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183350</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="234"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005097792.101</attribute_group_obj>
<attribute_label>RootNodeCode</attribute_label>
<attribute_type_tla>CHR</attribute_type_tla>
<attribute_narrative>The Root Node Code to be used when populating a SmartTreeView object on a Dynamic TreeView object.</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005081437.28</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005097792.101</attribute_group_obj>
<attribute_group_name>TreeView</attribute_group_name>
<attribute_group_narrative>TreeView Group</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>CHR</attribute_type_tla>
<attribute_type_description>Character</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1004928887.09</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="235"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005097792.101</attribute_group_obj>
<attribute_label>ShowCheckBoxes</attribute_label>
<attribute_type_tla>LOG</attribute_type_tla>
<attribute_narrative>Used to set the property of a SmartTreeView object to indicate that check boxes should appear next to each node.</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005081440.28</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005097792.101</attribute_group_obj>
<attribute_group_name>TreeView</attribute_group_name>
<attribute_group_narrative>TreeView Group</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>LOG</attribute_type_tla>
<attribute_type_description>Logical</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183350</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="236"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005097792.101</attribute_group_obj>
<attribute_label>ShowRootLines</attribute_label>
<attribute_type_tla>LOG</attribute_type_tla>
<attribute_narrative>Used to set the property of a SmartTreeView object to indicate that root lines should appear on the OCX.</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005081441.28</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005097792.101</attribute_group_obj>
<attribute_group_name>TreeView</attribute_group_name>
<attribute_group_narrative>TreeView Group</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>LOG</attribute_type_tla>
<attribute_type_description>Logical</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183350</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="237"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005097792.101</attribute_group_obj>
<attribute_label>TreeStyle</attribute_label>
<attribute_type_tla>INT</attribute_type_tla>
<attribute_narrative>Used to set the property of a SmartTreeView object to indicate the style of the TreeView. The following options are supported:
0 - Text only
1 - Pictures &amp; Text
2 - Text only (Plus/Minus)
3 - Pictures &amp; Text (Plus/Minus)
4 - Text only with tree lines
5 - Pictures &amp; Text with tree lines
6 - Text only with tree lines &amp; plus/minus
7 - Pictures &amp; text with tree lines &amp; plus/minus</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005081442.28</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005097792.101</attribute_group_obj>
<attribute_group_name>TreeView</attribute_group_name>
<attribute_group_narrative>TreeView Group</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>INT</attribute_type_tla>
<attribute_type_description>Integer</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183380</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="238"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005098168.101</attribute_group_obj>
<attribute_label>Chars</attribute_label>
<attribute_type_tla>INT</attribute_type_tla>
<attribute_narrative>The number of characters in an editor. This is denominated in units as
determined by the SizeUnits attribute value.</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005098170.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005098168.101</attribute_group_obj>
<attribute_group_name>EditorAttributes</attribute_group_name>
<attribute_group_narrative>Attributes which are specific to an editor widget</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>INT</attribute_type_tla>
<attribute_type_description>Integer</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183380</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="239"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005098168.101</attribute_group_obj>
<attribute_label>Large</attribute_label>
<attribute_type_tla>LOG</attribute_type_tla>
<attribute_narrative>Whether the editor is a large editor.</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005098171.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005098168.101</attribute_group_obj>
<attribute_group_name>EditorAttributes</attribute_group_name>
<attribute_group_narrative>Attributes which are specific to an editor widget</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>LOG</attribute_type_tla>
<attribute_type_description>Logical</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183350</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="240"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005098168.101</attribute_group_obj>
<attribute_label>Lines</attribute_label>
<attribute_type_tla>INT</attribute_type_tla>
<attribute_narrative>The number of lines in an editor. This is denominatd in SizeUnits units,
which are an attribute of the widget.</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005098169.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005098168.101</attribute_group_obj>
<attribute_group_name>EditorAttributes</attribute_group_name>
<attribute_group_narrative>Attributes which are specific to an editor widget</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>INT</attribute_type_tla>
<attribute_type_description>Integer</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183380</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="241"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005098168.101</attribute_group_obj>
<attribute_label>MaxChars</attribute_label>
<attribute_type_tla>INT</attribute_type_tla>
<attribute_narrative>The maximum characters in an editor widget.</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005098172.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005098168.101</attribute_group_obj>
<attribute_group_name>EditorAttributes</attribute_group_name>
<attribute_group_narrative>Attributes which are specific to an editor widget</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>INT</attribute_type_tla>
<attribute_type_description>Integer</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183380</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="242"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005098168.101</attribute_group_obj>
<attribute_label>ProgressSource</attribute_label>
<attribute_type_tla>LOG</attribute_type_tla>
<attribute_narrative>Whether the editor should act as a Progress source code editor</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005098178.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005098168.101</attribute_group_obj>
<attribute_group_name>EditorAttributes</attribute_group_name>
<attribute_group_narrative>Attributes which are specific to an editor widget</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>LOG</attribute_type_tla>
<attribute_type_description>Logical</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183350</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="243"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005098168.101</attribute_group_obj>
<attribute_label>ReadOnly</attribute_label>
<attribute_type_tla>LOG</attribute_type_tla>
<attribute_narrative>Whether the editor is a read only or not</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005098177.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005098168.101</attribute_group_obj>
<attribute_group_name>EditorAttributes</attribute_group_name>
<attribute_group_narrative>Attributes which are specific to an editor widget</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>LOG</attribute_type_tla>
<attribute_type_description>Logical</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183350</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="244"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005098168.101</attribute_group_obj>
<attribute_label>ReturnInserted</attribute_label>
<attribute_type_tla>LOG</attribute_type_tla>
<attribute_narrative>Determines the action when the "return"key is pressed.</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005098179.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005098168.101</attribute_group_obj>
<attribute_group_name>EditorAttributes</attribute_group_name>
<attribute_group_narrative>Attributes which are specific to an editor widget</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>LOG</attribute_type_tla>
<attribute_type_description>Logical</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183350</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="245"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005098168.101</attribute_group_obj>
<attribute_label>ScrollbarHorizontal</attribute_label>
<attribute_type_tla>LOG</attribute_type_tla>
<attribute_narrative>Whether the editor has a horizontal scrollbar or not</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005098173.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005098168.101</attribute_group_obj>
<attribute_group_name>EditorAttributes</attribute_group_name>
<attribute_group_narrative>Attributes which are specific to an editor widget</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>LOG</attribute_type_tla>
<attribute_type_description>Logical</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183350</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="246"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005098168.101</attribute_group_obj>
<attribute_label>ScrollbarVertical</attribute_label>
<attribute_type_tla>LOG</attribute_type_tla>
<attribute_narrative>Whether the editor has a vertical scrollbar</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005098174.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005098168.101</attribute_group_obj>
<attribute_group_name>EditorAttributes</attribute_group_name>
<attribute_group_narrative>Attributes which are specific to an editor widget</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>LOG</attribute_type_tla>
<attribute_type_description>Logical</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183350</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="247"><contained_record DB="ICFDB" Table="ryc_attribute"><attribute_group_obj>1005098168.101</attribute_group_obj>
<attribute_label>WordWrap</attribute_label>
<attribute_type_tla>LOG</attribute_type_tla>
<attribute_narrative>Whether the editor has word wrapping enabled.</attribute_narrative>
<system_owned>no</system_owned>
<attribute_obj>1005098175.101</attribute_obj>
<contained_record DB="ICFDB" Table="ryc_attribute_group"><attribute_group_obj>1005098168.101</attribute_group_obj>
<attribute_group_name>EditorAttributes</attribute_group_name>
<attribute_group_narrative>Attributes which are specific to an editor widget</attribute_group_narrative>
</contained_record>
<contained_record DB="ICFDB" Table="ryc_attribute_type"><attribute_type_tla>LOG</attribute_type_tla>
<attribute_type_description>Logical</attribute_type_description>
<collection_attribute>no</collection_attribute>
<edit_program></edit_program>
<attribute_type_obj>1003183350</attribute_type_obj>
</contained_record>
</contained_record>
</dataset_transaction>
</dataset_records>
</dataset>