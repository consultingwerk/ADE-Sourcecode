<?xml version="1.0" encoding="utf-8" ?>
<dataset Transactions="268"><dataset_header DisableRI="yes" DatasetObj="1007600153.08" DateFormat="mdy" FullHeader="yes" SCMManaged="no" YearOffset="1950" DatasetCode="GSMMI" NumericFormat="AMERICAN" NumericDecimal="." OriginatingSite="90" NumericSeparator=","><deploy_dataset_obj>1007600153.08</deploy_dataset_obj>
<dataset_code>GSMMI</dataset_code>
<dataset_description>gsm_menu_item - Menu Items</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<deploy_additions_only>no</deploy_additions_only>
<enable_data_versioning>yes</enable_data_versioning>
<deletion_dataset>yes</deletion_dataset>
<dataset_entity><dataset_entity_obj>1007600154.08</dataset_entity_obj>
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
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
<exclude_field_list></exclude_field_list>
<entity_mnemonic_description>gsm_menu_item</entity_mnemonic_description>
<entity_dbname>ICFDB</entity_dbname>
</dataset_entity>
<table_definition><name>gsm_menu_item</name>
<dbname>icfdb</dbname>
<index-1>XAK1gsm_menu_item,1,0,0,menu_item_reference,0</index-1>
<index-2>XIE1gsm_menu_item,0,0,0,product_module_obj,0</index-2>
<index-3>XIE2gsm_menu_item,0,0,0,object_obj,0</index-3>
<index-4>XIE3gsm_menu_item,0,0,0,instance_attribute_obj,0</index-4>
<index-5>XIE4gsm_menu_item,0,0,0,item_category_obj,0</index-5>
<index-6>XIE5gsm_menu_item,0,0,0,menu_item_label,0</index-6>
<index-7>XIE6gsm_menu_item,0,0,0,menu_item_description,0</index-7>
<index-8>XIE7gsm_menu_item,0,0,0,security_token,0</index-8>
<index-9>XIE8gsm_menu_item,0,0,0,item_toolbar_label,0</index-9>
<index-10>XIE9gsm_menu_item,0,0,0,source_language_obj,0</index-10>
<index-11>XPKgsm_menu_item,1,1,0,menu_item_obj,0</index-11>
<field><name>menu_item_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Menu item obj</label>
<column-label>Menu item obj</column-label>
</field>
<field><name>product_module_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Product module obj</label>
<column-label>Product module obj</column-label>
</field>
<field><name>object_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Object obj</label>
<column-label>Object obj</column-label>
</field>
<field><name>instance_attribute_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Instance attribute obj</label>
<column-label>Instance attribute obj</column-label>
</field>
<field><name>item_category_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Item category obj</label>
<column-label>Item category obj</column-label>
</field>
<field><name>menu_item_label</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(28)</format>
<initial></initial>
<label>Menu item label</label>
<column-label>Menu item label</column-label>
</field>
<field><name>menu_item_description</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>Menu item description</label>
<column-label>Menu item description</column-label>
</field>
<field><name>toggle_menu_item</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>Toggle menu item</label>
<column-label>Toggle menu item</column-label>
</field>
<field><name>tooltip_text</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Tooltip text</label>
<column-label>Tooltip text</column-label>
</field>
<field><name>shortcut_key</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(15)</format>
<initial></initial>
<label>Shortcut key</label>
<column-label>Shortcut key</column-label>
</field>
<field><name>hide_if_disabled</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>Hide if disabled</label>
<column-label>Hide if disabled</column-label>
</field>
<field><name>disabled</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>Disabled</label>
<column-label>Disabled</column-label>
</field>
<field><name>system_owned</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>YES</initial>
<label>System owned</label>
<column-label>System owned</column-label>
</field>
<field><name>under_development</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>Under development</label>
<column-label>Under development</column-label>
</field>
<field><name>menu_item_reference</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(15)</format>
<initial></initial>
<label>Menu item reference</label>
<column-label>Menu item reference</column-label>
</field>
<field><name>propagate_links</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Propagate links</label>
<column-label>Propagate links</column-label>
</field>
<field><name>security_token</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(28)</format>
<initial></initial>
<label>Security token</label>
<column-label>Security token</column-label>
</field>
<field><name>item_toolbar_label</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(28)</format>
<initial></initial>
<label>Item toolbar label</label>
<column-label>Item toolbar label</column-label>
</field>
<field><name>image1_up_filename</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Image1 up filename</label>
<column-label>Image1 up filename</column-label>
</field>
<field><name>image1_down_filename</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Image1 down filename</label>
<column-label>Image1 down filename</column-label>
</field>
<field><name>image1_insensitive_filename</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Image1 insensitive filename</label>
<column-label>Image1 insensitive filename</column-label>
</field>
<field><name>image2_up_filename</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Image2 up filename</label>
<column-label>Image2 up filename</column-label>
</field>
<field><name>image2_down_filename</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Image2 down filename</label>
<column-label>Image2 down filename</column-label>
</field>
<field><name>image2_insensitive_filename</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Image2 insensitive filename</label>
<column-label>Image2 insensitive filename</column-label>
</field>
<field><name>item_select_type</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(10)</format>
<initial></initial>
<label>Item select type</label>
<column-label>Item select type</column-label>
</field>
<field><name>item_select_action</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Item select action</label>
<column-label>Item select action</column-label>
</field>
<field><name>item_link</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Item link</label>
<column-label>Item link</column-label>
</field>
<field><name>item_select_parameter</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Item select parameter</label>
<column-label>Item select parameter</column-label>
</field>
<field><name>item_menu_drop</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Item menu drop</label>
<column-label>Item menu drop</column-label>
</field>
<field><name>on_create_publish_event</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>On create publish event</label>
<column-label>On create publish event</column-label>
</field>
<field><name>enable_rule</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(500)</format>
<initial></initial>
<label>Enable rule</label>
<column-label>Enable rule</column-label>
</field>
<field><name>disable_rule</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(500)</format>
<initial></initial>
<label>Disable rule</label>
<column-label>Disable rule</column-label>
</field>
<field><name>image_alternate_rule</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(500)</format>
<initial></initial>
<label>Image alternate rule</label>
<column-label>Image alternate rule</column-label>
</field>
<field><name>hide_rule</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(500)</format>
<initial></initial>
<label>Hide rule</label>
<column-label>Hide rule</column-label>
</field>
<field><name>item_control_type</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(15)</format>
<initial></initial>
<label>Item control type</label>
<column-label>Item control type</column-label>
</field>
<field><name>item_control_style</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(15)</format>
<initial></initial>
<label>Item control style</label>
<column-label>Item control style</column-label>
</field>
<field><name>substitute_text_property</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>Substitute text property</label>
<column-label>Substitute text property</column-label>
</field>
<field><name>item_narration</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(500)</format>
<initial></initial>
<label>Item narration</label>
<column-label>Item narration</column-label>
</field>
<field><name>source_language_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Source language obj</label>
<column-label>Source language obj</column-label>
</field>
</table_definition>
</dataset_header>
<dataset_records><dataset_transaction TransactionNo="1" TransactionType="DELETION"><contained_record version_date="09/23/2003" version_time="63003" version_user="admin" deletion_flag="yes" entity_mnemonic="gsmmi" key_field_value="1000009546.81" record_version_obj="1000009547.81" version_number_seq="1.09" secondary_key_value="ICF18_00000206" import_version_number_seq="1.09"/>
</dataset_transaction>
<dataset_transaction TransactionNo="2" TransactionType="DELETION"><contained_record version_date="06/05/2003" version_time="61529" version_user="admin" deletion_flag="yes" entity_mnemonic="gsmmi" key_field_value="1000708119.09" record_version_obj="3000051334.09" version_number_seq="1" secondary_key_value="TxtTableioOK" import_version_number_seq="1"/>
</dataset_transaction>
<dataset_transaction TransactionNo="3" TransactionType="DELETION"><contained_record version_date="06/05/2003" version_time="61529" version_user="admin" deletion_flag="yes" entity_mnemonic="gsmmi" key_field_value="1000708123.09" record_version_obj="3000051335.09" version_number_seq="1" secondary_key_value="TxtTableioCancel" import_version_number_seq="1"/>
</dataset_transaction>
<dataset_transaction TransactionNo="4" TransactionType="DELETION"><contained_record version_date="09/23/2002" version_time="56075" version_user="admin" deletion_flag="yes" entity_mnemonic="gsmmi" key_field_value="1003606424" record_version_obj="3000031033.09" version_number_seq="1.09" secondary_key_value="ASMNU_00001669" import_version_number_seq="1.09"/>
</dataset_transaction>
<dataset_transaction TransactionNo="5" TransactionType="DELETION"><contained_record version_date="09/23/2002" version_time="55978" version_user="admin" deletion_flag="yes" entity_mnemonic="gsmmi" key_field_value="1003608670" record_version_obj="3000031028.09" version_number_seq="1.09" secondary_key_value="ASMNU_00001670" import_version_number_seq="1.09"/>
</dataset_transaction>
<dataset_transaction TransactionNo="6" TransactionType="DELETION"><contained_record version_date="09/23/2002" version_time="56483" version_user="admin" deletion_flag="yes" entity_mnemonic="gsmmi" key_field_value="1003608671" record_version_obj="3000031042.09" version_number_seq="1.09" secondary_key_value="ASMNU_00001671" import_version_number_seq="1.09"/>
</dataset_transaction>
<dataset_transaction TransactionNo="7" TransactionType="DELETION"><contained_record version_date="09/23/2002" version_time="57872" version_user="admin" deletion_flag="yes" entity_mnemonic="gsmmi" key_field_value="1003608672" record_version_obj="3000031063.09" version_number_seq="1.09" secondary_key_value="ASMNU_00001672" import_version_number_seq="1.09"/>
</dataset_transaction>
<dataset_transaction TransactionNo="8" TransactionType="DELETION"><contained_record version_date="09/23/2002" version_time="55931" version_user="admin" deletion_flag="yes" entity_mnemonic="gsmmi" key_field_value="1003608673" record_version_obj="3000031025.09" version_number_seq="1.09" secondary_key_value="ASMNU_00001673" import_version_number_seq="1.09"/>
</dataset_transaction>
<dataset_transaction TransactionNo="9" TransactionType="DELETION"><contained_record version_date="09/23/2002" version_time="58452" version_user="admin" deletion_flag="yes" entity_mnemonic="gsmmi" key_field_value="1003662702" record_version_obj="3000031085.09" version_number_seq="1.09" secondary_key_value="ASMNU_00001701" import_version_number_seq="1.09"/>
</dataset_transaction>
<dataset_transaction TransactionNo="10" TransactionType="DELETION"><contained_record version_date="09/23/2002" version_time="58822" version_user="admin" deletion_flag="yes" entity_mnemonic="gsmmi" key_field_value="1003692888" record_version_obj="3000031092.09" version_number_seq="1.09" secondary_key_value="ASMNU_00001861" import_version_number_seq="1.09"/>
</dataset_transaction>
<dataset_transaction TransactionNo="11" TransactionType="DELETION"><contained_record version_date="09/23/2002" version_time="59669" version_user="admin" deletion_flag="yes" entity_mnemonic="gsmmi" key_field_value="1003694842" record_version_obj="3000031108.09" version_number_seq="1.09" secondary_key_value="ASMNU_00001862" import_version_number_seq="1.09"/>
</dataset_transaction>
<dataset_transaction TransactionNo="12" TransactionType="DELETION"><contained_record version_date="05/22/2002" version_time="55703" version_user="admin" deletion_flag="yes" entity_mnemonic="gsmmi" key_field_value="1003695950" record_version_obj="3000000051.09" version_number_seq="1.09" secondary_key_value="Smart" import_version_number_seq="1.09"/>
</dataset_transaction>
<dataset_transaction TransactionNo="13" TransactionType="DELETION"><contained_record version_date="09/23/2002" version_time="57036" version_user="admin" deletion_flag="yes" entity_mnemonic="gsmmi" key_field_value="1003699874" record_version_obj="3000031056.09" version_number_seq="1.09" secondary_key_value="ASMNU_00001875" import_version_number_seq="1.09"/>
</dataset_transaction>
<dataset_transaction TransactionNo="14" TransactionType="DELETION"><contained_record version_date="09/23/2002" version_time="56999" version_user="admin" deletion_flag="yes" entity_mnemonic="gsmmi" key_field_value="1003700002" record_version_obj="3000031050.09" version_number_seq="1.09" secondary_key_value="ASMNU_00001877" import_version_number_seq="1.09"/>
</dataset_transaction>
<dataset_transaction TransactionNo="15" TransactionType="DELETION"><contained_record version_date="09/23/2002" version_time="57040" version_user="admin" deletion_flag="yes" entity_mnemonic="gsmmi" key_field_value="1003700022" record_version_obj="3000031058.09" version_number_seq="1.09" secondary_key_value="ASMNU_00001878" import_version_number_seq="1.09"/>
</dataset_transaction>
<dataset_transaction TransactionNo="16" TransactionType="DELETION"><contained_record version_date="09/23/2002" version_time="57043" version_user="admin" deletion_flag="yes" entity_mnemonic="gsmmi" key_field_value="1003700023" record_version_obj="3000031060.09" version_number_seq="1.09" secondary_key_value="ASMNU_00001879" import_version_number_seq="1.09"/>
</dataset_transaction>
<dataset_transaction TransactionNo="17" TransactionType="DELETION"><contained_record version_date="09/23/2002" version_time="57016" version_user="admin" deletion_flag="yes" entity_mnemonic="gsmmi" key_field_value="1003701200" record_version_obj="3000031052.09" version_number_seq="1.09" secondary_key_value="ASMNU_00001887" import_version_number_seq="1.09"/>
</dataset_transaction>
<dataset_transaction TransactionNo="18" TransactionType="DELETION"><contained_record version_date="09/23/2002" version_time="57033" version_user="admin" deletion_flag="yes" entity_mnemonic="gsmmi" key_field_value="1003701806" record_version_obj="3000031054.09" version_number_seq="1.09" secondary_key_value="ASMNU_00001888" import_version_number_seq="1.09"/>
</dataset_transaction>
<dataset_transaction TransactionNo="19" TransactionType="DELETION"><contained_record version_date="09/23/2002" version_time="58033" version_user="admin" deletion_flag="yes" entity_mnemonic="gsmmi" key_field_value="1003750512" record_version_obj="3000031070.09" version_number_seq="1.09" secondary_key_value="ASMNU_00002042" import_version_number_seq="1.09"/>
</dataset_transaction>
<dataset_transaction TransactionNo="20" TransactionType="DELETION"><contained_record version_date="09/23/2002" version_time="54491" version_user="admin" deletion_flag="yes" entity_mnemonic="gsmmi" key_field_value="1003764343" record_version_obj="3000031007.09" version_number_seq="1.09" secondary_key_value="ASMNU_00002052" import_version_number_seq="1.09"/>
</dataset_transaction>
<dataset_transaction TransactionNo="21" TransactionType="DELETION"><contained_record version_date="09/23/2002" version_time="58064" version_user="admin" deletion_flag="yes" entity_mnemonic="gsmmi" key_field_value="1003766394" record_version_obj="3000031073.09" version_number_seq="1.09" secondary_key_value="ASMNU_00002058" import_version_number_seq="1.09"/>
</dataset_transaction>
<dataset_transaction TransactionNo="22" TransactionType="DELETION"><contained_record version_date="10/03/2003" version_time="49637" version_user="admin" deletion_flag="yes" entity_mnemonic="gsmmi" key_field_value="1004918496.09" record_version_obj="3000058570.09" version_number_seq="2.09" secondary_key_value="ICF_00000058" import_version_number_seq="2.09"/>
</dataset_transaction>
<dataset_transaction TransactionNo="23" TransactionType="DELETION"><contained_record version_date="09/23/2002" version_time="53960" version_user="admin" deletion_flag="yes" entity_mnemonic="gsmmi" key_field_value="1004919031.09" record_version_obj="3000030999.09" version_number_seq="1.09" secondary_key_value="ICF_00000081" import_version_number_seq="1.09"/>
</dataset_transaction>
<dataset_transaction TransactionNo="24" TransactionType="DELETION"><contained_record version_date="05/22/2002" version_time="55708" version_user="admin" deletion_flag="yes" entity_mnemonic="gsmmi" key_field_value="1005016780" record_version_obj="3000000060.09" version_number_seq="1.09" secondary_key_value="ASMNU_00002446" import_version_number_seq="1.09"/>
</dataset_transaction>
<dataset_transaction TransactionNo="25" TransactionType="DELETION"><contained_record version_date="05/22/2002" version_time="55707" version_user="admin" deletion_flag="yes" entity_mnemonic="gsmmi" key_field_value="1005016822" record_version_obj="3000000058.09" version_number_seq="1.09" secondary_key_value="ASMNU_00002449" import_version_number_seq="1.09"/>
</dataset_transaction>
<dataset_transaction TransactionNo="26" TransactionType="DELETION"><contained_record version_date="05/22/2002" version_time="55710" version_user="admin" deletion_flag="yes" entity_mnemonic="gsmmi" key_field_value="1005016859" record_version_obj="3000000070.09" version_number_seq="1.09" secondary_key_value="ASMNU_00002450" import_version_number_seq="1.09"/>
</dataset_transaction>
<dataset_transaction TransactionNo="27" TransactionType="DELETION"><contained_record version_date="05/22/2002" version_time="55709" version_user="admin" deletion_flag="yes" entity_mnemonic="gsmmi" key_field_value="1005016860" record_version_obj="3000000067.09" version_number_seq="1.09" secondary_key_value="ASMNU_00002451" import_version_number_seq="1.09"/>
</dataset_transaction>
<dataset_transaction TransactionNo="28" TransactionType="DELETION"><contained_record version_date="09/23/2002" version_time="58064" version_user="admin" deletion_flag="yes" entity_mnemonic="gsmmi" key_field_value="1005110251.101" record_version_obj="3000031074.09" version_number_seq="1.09" secondary_key_value="ICF_00000132" import_version_number_seq="1.09"/>
</dataset_transaction>
<dataset_transaction TransactionNo="29" TransactionType="DELETION"><contained_record version_date="09/30/2002" version_time="23559" version_user="admin" deletion_flag="yes" entity_mnemonic="gsmmi" key_field_value="1007600015.09" record_version_obj="2000001252.28" version_number_seq="1.09" secondary_key_value="ICF_00000160" import_version_number_seq="1.09"/>
</dataset_transaction>
<dataset_transaction TransactionNo="30" TransactionType="DELETION"><contained_record version_date="09/23/2002" version_time="55129" version_user="admin" deletion_flag="yes" entity_mnemonic="gsmmi" key_field_value="5.101" record_version_obj="3000031019.09" version_number_seq="1.09" secondary_key_value="ICF_00000200" import_version_number_seq="1.09"/>
</dataset_transaction>
<dataset_transaction TransactionNo="31" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="09/04/2002" version_time="56936" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="-1294967293.91" record_version_obj="3000001565.09" version_number_seq="1.09" secondary_key_value="ICF_00000202" import_version_number_seq="1.09"><menu_item_obj>-1294967293.91</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>5188.19</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>Deployment Package Control</menu_item_label>
<menu_item_description>Deployment Package Control</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>yes</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>ICF_00000202</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label>Deployment Package Control</item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>LAUNCH</item_select_type>
<item_select_action></item_select_action>
<item_link>?</item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="32" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="09/04/2002" version_time="56937" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="-1294967288.91" record_version_obj="3000001566.09" version_number_seq="1.09" secondary_key_value="ICF_00000203" import_version_number_seq="1.09"><menu_item_obj>-1294967288.91</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>7117.24</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>Package Import/Export</menu_item_label>
<menu_item_description>Package Import/Export</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>yes</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>ICF_00000203</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label>Package Import/Export</item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>LAUNCH</item_select_type>
<item_select_action></item_select_action>
<item_link>?</item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="33" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="06/05/2003" version_time="61320" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="71.6893" record_version_obj="72.6893" version_number_seq="2.766" secondary_key_value="ICF_00000205" import_version_number_seq="2.766"><menu_item_obj>71.6893</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>19.6893</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;Map Help Context...</menu_item_label>
<menu_item_description>Map Help Context...</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>ICF_00000205</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label>Map Help Context...</item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>LAUNCH</item_select_type>
<item_select_action></item_select_action>
<item_link>?</item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="34" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="05/15/2003" version_time="60017" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="489.5053" record_version_obj="490.5053" version_number_seq="4.5498" secondary_key_value="Pages" import_version_number_seq="4.5498"><menu_item_obj>489.5053</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;Pages</menu_item_label>
<menu_item_description>Container Builder Pages</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Page maintenance</tooltip_text>
<shortcut_key>ALT-P</shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>Pages</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label>Pages</item_toolbar_label>
<image1_up_filename>ry/img/pages16.bmp</image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>PUBLISH</item_select_type>
<item_select_action>toolbar</item_select_action>
<item_link>containertoolbar-target</item_link>
<item_select_parameter>launchPages</item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style>Icon only</item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="35" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="05/15/2003" version_time="60016" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="552.5053" record_version_obj="553.5053" version_number_seq="4.5498" secondary_key_value="Links" import_version_number_seq="4.5498"><menu_item_obj>552.5053</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;Links</menu_item_label>
<menu_item_description>Container Builder Links</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Links maintenance</tooltip_text>
<shortcut_key>ALT-K</shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>Links</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label>Links</item_toolbar_label>
<image1_up_filename>ry/img/links16.bmp</image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>PUBLISH</item_select_type>
<item_select_action>toolbar</item_select_action>
<item_link>containertoolbar-target</item_link>
<item_select_parameter>launchLinks</item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style>Icon only</item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="36" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="05/15/2003" version_time="60016" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="556.5053" record_version_obj="557.5053" version_number_seq="5.5498" secondary_key_value="CntainerPreview" import_version_number_seq="5.5498"><menu_item_obj>556.5053</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;Run</menu_item_label>
<menu_item_description>Container Builder Run</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Preview container</tooltip_text>
<shortcut_key>F2</shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>CntainerPreview</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label>Preview</item_toolbar_label>
<image1_up_filename>ry/img/run.bmp</image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>PUBLISH</item_select_type>
<item_select_action>toolbar</item_select_action>
<item_link>containertoolbar-target</item_link>
<item_select_parameter>previewContainer</item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style>Icon only</item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="37" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="05/15/2003" version_time="60017" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="558.5053" record_version_obj="559.5053" version_number_seq="4.5498" secondary_key_value="Properties" import_version_number_seq="4.5498"><menu_item_obj>558.5053</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>Proper&amp;ties</menu_item_label>
<menu_item_description>Container Builder Properties</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Container properties</tooltip_text>
<shortcut_key>ALT-R</shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>Properties</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label>Properties</item_toolbar_label>
<image1_up_filename>ry/img/properties.gif</image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>PUBLISH</item_select_type>
<item_select_action>toolbar</item_select_action>
<item_link>containertoolbar-target</item_link>
<item_select_parameter>containerProperties</item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style>Icon only</item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="38" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="08/11/2003" version_time="46711" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="710.5053" record_version_obj="711.5053" version_number_seq="4" secondary_key_value="save2" import_version_number_seq="4"><menu_item_obj>710.5053</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;Save record</menu_item_label>
<menu_item_description>Save record</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Save record</tooltip_text>
<shortcut_key>ALT-A</shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>save2</menu_item_reference>
<propagate_links></propagate_links>
<security_token>Save</security_token>
<item_toolbar_label>&amp;Save</item_toolbar_label>
<image1_up_filename>ry/img/saverec.gif</image1_up_filename>
<image1_down_filename>ry/img/toolclip.bmp,80,0,16,16</image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>PUBLISH</item_select_type>
<item_select_action>toolbar</item_select_action>
<item_link>toolbar-target</item_link>
<item_select_parameter>Save</item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style>Icon only</item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="39" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="08/11/2003" version_time="46711" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="712.5053" record_version_obj="713.5053" version_number_seq="4" secondary_key_value="reset2" import_version_number_seq="4"><menu_item_obj>712.5053</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;Reset Record</menu_item_label>
<menu_item_description>Reset Record</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Reset record</tooltip_text>
<shortcut_key>ALT-A</shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>reset2</menu_item_reference>
<propagate_links></propagate_links>
<security_token>Reset</security_token>
<item_toolbar_label>&amp;Reset</item_toolbar_label>
<image1_up_filename>ry/img/reset.gif</image1_up_filename>
<image1_down_filename>ry/img/toolclip.bmp,96,0,16,16</image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>PUBLISH</item_select_type>
<item_select_action>toolbar</item_select_action>
<item_link>toolbar-target</item_link>
<item_select_parameter>Reset</item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style>Icon only</item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="40" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="08/11/2003" version_time="46710" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="714.5053" record_version_obj="715.5053" version_number_seq="4" secondary_key_value="cancel2" import_version_number_seq="4"><menu_item_obj>714.5053</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;Cancel Record</menu_item_label>
<menu_item_description>Cancel Record</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Cancel record</tooltip_text>
<shortcut_key>ALT-A</shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>cancel2</menu_item_reference>
<propagate_links></propagate_links>
<security_token>Cancel</security_token>
<item_toolbar_label>&amp;Cancel</item_toolbar_label>
<image1_up_filename>ry/img/cancel.gif</image1_up_filename>
<image1_down_filename>ry/img/toolclip.bmp,112,0,16,16</image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>PUBLISH</item_select_type>
<item_select_action>toolbar</item_select_action>
<item_link>toolbar-target</item_link>
<item_select_parameter>Cancel</item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style>Icon only</item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="41" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="05/15/2003" version_time="60016" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="1381.5498" record_version_obj="1382.5498" version_number_seq="2.5498" secondary_key_value="cbexport" import_version_number_seq="2.5498"><menu_item_obj>1381.5498</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;Export...</menu_item_label>
<menu_item_description>Export...</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Export</tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>cbexport</menu_item_reference>
<propagate_links></propagate_links>
<security_token>Export</security_token>
<item_toolbar_label>&amp;Export...</item_toolbar_label>
<image1_up_filename>ry/img/aftoexcel.gif</image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>PUBLISH</item_select_type>
<item_select_action>toolbar</item_select_action>
<item_link>containertoolbar-target</item_link>
<item_select_parameter>Export</item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="42" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="06/05/2003" version_time="61320" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="4651.24" record_version_obj="1000001203.28" version_number_seq="5.766" secondary_key_value="ICF_00000201" import_version_number_seq="5.766"><menu_item_obj>4651.24</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>2000001496.28</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>SmartData&amp;Field Maintenance</menu_item_label>
<menu_item_description>SmartDataField Maintenance</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Maintain dynamic combos and lookups</tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>ICF_00000201</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label>SmartDataField Maintenance</item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>LAUNCH</item_select_type>
<item_select_action></item_select_action>
<item_link>?</item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="43" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="09/22/2003" version_time="61885" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="5126.81" record_version_obj="5127.81" version_number_seq="4.81" secondary_key_value="ICF18_00000204" import_version_number_seq="4.81"><menu_item_obj>5126.81</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>5057.81</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>SCM &amp;Tool Control</menu_item_label>
<menu_item_description>SCM Tool Control</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>SCM Tool Control</tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>ICF18_00000204</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label>SCM Tool Control</item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>LAUNCH</item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="44" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="06/05/2003" version_time="61323" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="8449.9875" record_version_obj="8450.9875" version_number_seq="3.9875" secondary_key_value="ClassOptionText" import_version_number_seq="3.9875"><menu_item_obj>8449.9875</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>1000709352.09</item_category_obj>
<menu_item_label>Options</menu_item_label>
<menu_item_description>Options</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>ClassOptionText</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label></item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type></item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Label</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="45" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="11/15/2002" version_time="46263" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="8453.9875" record_version_obj="8454.9875" version_number_seq="1.09" secondary_key_value="LoadCustomProp" import_version_number_seq="1.09"><menu_item_obj>8453.9875</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>6039.9875</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>Load Custom Attributes</menu_item_label>
<menu_item_description>Load Custom Attributes</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>LoadCustomProp</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label>Load Customised Attributes</item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>LAUNCH</item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="46" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="11/15/2002" version_time="46263" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="8455.9875" record_version_obj="8456.9875" version_number_seq="1.09" secondary_key_value="ObjTypeChgUtil" import_version_number_seq="1.09"><menu_item_obj>8455.9875</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>8567.009</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>Object Type Change Utility</menu_item_label>
<menu_item_description>Object Type Change Utility</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>ObjTypeChgUtil</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label>Object Type Change Utility</item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>LAUNCH</item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="47" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="05/15/2003" version_time="60016" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="13067.5053" record_version_obj="13068.5053" version_number_seq="4.5498" secondary_key_value="CBFind" import_version_number_seq="4.5498"><menu_item_obj>13067.5053</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;Open</menu_item_label>
<menu_item_description>Open</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Open</tooltip_text>
<shortcut_key>F3</shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>CBFind</menu_item_reference>
<propagate_links></propagate_links>
<security_token>Open</security_token>
<item_toolbar_label>Fi&amp;nd...</item_toolbar_label>
<image1_up_filename>ry/img/view.gif</image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>PUBLISH</item_select_type>
<item_select_action>toolbar</item_select_action>
<item_link>containertoolbar-target</item_link>
<item_select_parameter>Open</item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="48" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="09/22/2003" version_time="61885" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="15307.81" record_version_obj="15308.81" version_number_seq="2.81" secondary_key_value="ICF18_00000220" import_version_number_seq="2.81"><menu_item_obj>15307.81</menu_item_obj>
<product_module_obj>1004874707.09</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>1000709352.09</item_category_obj>
<menu_item_label>&amp;SCM Xref</menu_item_label>
<menu_item_description>SCM Xref Options</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>ICF18_00000220</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label></item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type></item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Label</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="49" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="09/22/2003" version_time="61885" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="15311.81" record_version_obj="15312.81" version_number_seq="2.81" secondary_key_value="ICF18_00000221" import_version_number_seq="2.81"><menu_item_obj>15311.81</menu_item_obj>
<product_module_obj>1004874707.09</product_module_obj>
<object_obj>15089.81</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;Product Module Xref</menu_item_label>
<menu_item_description>SCM Product Module Xref</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>SCM Tool Control</tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>ICF18_00000221</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label>SCM Tool Control</item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>LAUNCH</item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="50" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="09/22/2003" version_time="61885" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="15313.81" record_version_obj="15314.81" version_number_seq="4.81" secondary_key_value="ICF18_00000222" import_version_number_seq="4.81"><menu_item_obj>15313.81</menu_item_obj>
<product_module_obj>1004874707.09</product_module_obj>
<object_obj>15248.81</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;Object Type Xref</menu_item_label>
<menu_item_description>SCM Object Type Xref</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>SCM Tool Control</tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>ICF18_00000222</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label>SCM Tool Control</item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>LAUNCH</item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="51" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="09/22/2003" version_time="61885" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="15400.81" record_version_obj="15401.81" version_number_seq="4.81" secondary_key_value="ICF18_00000224" import_version_number_seq="4.81"><menu_item_obj>15400.81</menu_item_obj>
<product_module_obj>1004874707.09</product_module_obj>
<object_obj>15321.81</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;Generate SCM Xref Data</menu_item_label>
<menu_item_description>SCM Xref Data Generation</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>SCM Tool Control</tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>ICF18_00000224</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label>SCM Tool Control</item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>LAUNCH</item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="52" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="05/15/2003" version_time="60015" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="15855.53" record_version_obj="15856.53" version_number_seq="7.5498" secondary_key_value="cbcancel" import_version_number_seq="7.5498"><menu_item_obj>15855.53</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>Cance&amp;l</menu_item_label>
<menu_item_description>Cancel</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Cancel</tooltip_text>
<shortcut_key>ALT-L</shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>cbcancel</menu_item_reference>
<propagate_links></propagate_links>
<security_token>Cancel</security_token>
<item_toolbar_label>&amp;Cancel</item_toolbar_label>
<image1_up_filename>ry/img/objectcancel.bmp</image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>PUBLISH</item_select_type>
<item_select_action>toolbar</item_select_action>
<item_link>containertoolbar-target</item_link>
<item_select_parameter>Cancel</item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style>Icon only</item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="53" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="05/15/2003" version_time="60016" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="15857.53" record_version_obj="15858.53" version_number_seq="4.5498" secondary_key_value="new" import_version_number_seq="4.5498"><menu_item_obj>15857.53</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;New</menu_item_label>
<menu_item_description>New</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>New</tooltip_text>
<shortcut_key>SHIFT-F3</shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>new</menu_item_reference>
<propagate_links></propagate_links>
<security_token>New</security_token>
<item_toolbar_label>&amp;New</item_toolbar_label>
<image1_up_filename>adeicon/new.bmp</image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>PUBLISH</item_select_type>
<item_select_action>toolbar</item_select_action>
<item_link>containertoolbar-target</item_link>
<item_select_parameter>New</item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style>Icon only</item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="54" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="05/15/2003" version_time="60016" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="15859.53" record_version_obj="15860.53" version_number_seq="4.5498" secondary_key_value="cbsave" import_version_number_seq="4.5498"><menu_item_obj>15859.53</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;Save</menu_item_label>
<menu_item_description>Save</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Save</tooltip_text>
<shortcut_key>F6</shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>cbsave</menu_item_reference>
<propagate_links></propagate_links>
<security_token>Save</security_token>
<item_toolbar_label>&amp;Save</item_toolbar_label>
<image1_up_filename>adeicon/save.bmp</image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>PUBLISH</item_select_type>
<item_select_action>toolbar</item_select_action>
<item_link>containertoolbar-target</item_link>
<item_select_parameter>Save</item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style>Icon only</item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="55" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="05/15/2003" version_time="60016" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="15861.53" record_version_obj="15862.53" version_number_seq="2.5498" secondary_key_value="cbundo" import_version_number_seq="2.5498"><menu_item_obj>15861.53</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;Undo</menu_item_label>
<menu_item_description>Undo</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Undo</tooltip_text>
<shortcut_key>CTRL-Z</shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>cbundo</menu_item_reference>
<propagate_links></propagate_links>
<security_token>Reset</security_token>
<item_toolbar_label>&amp;Undo</item_toolbar_label>
<image1_up_filename>ry/img/objectundo.gif</image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>PUBLISH</item_select_type>
<item_select_action>toolbar</item_select_action>
<item_link>containertoolbar-target</item_link>
<item_select_parameter>Undo</item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style>Icon only</item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="56" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="09/04/2002" version_time="56940" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="15865.53" record_version_obj="15866.53" version_number_seq="2.5053" secondary_key_value="Advanced" import_version_number_seq="2.5053"><menu_item_obj>15865.53</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>1000709352.09</item_category_obj>
<menu_item_label>&amp;Advanced</menu_item_label>
<menu_item_description>Advanced Container Builder Features</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>Advanced</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label></item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type></item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Label</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="57" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="05/15/2003" version_time="60015" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="15870.53" record_version_obj="15871.53" version_number_seq="2.5498" secondary_key_value="cbDelete" import_version_number_seq="2.5498"><menu_item_obj>15870.53</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;Delete</menu_item_label>
<menu_item_description>Delete</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Delete</tooltip_text>
<shortcut_key>ALT-D</shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>cbDelete</menu_item_reference>
<propagate_links></propagate_links>
<security_token>Delete</security_token>
<item_toolbar_label>&amp;Delete</item_toolbar_label>
<image1_up_filename>ry/img/objectdelete.bmp</image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>PUBLISH</item_select_type>
<item_select_action>toolbar</item_select_action>
<item_link>containertoolbar-target</item_link>
<item_select_parameter>Delete</item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style>Icon only</item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="58" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="05/15/2003" version_time="60015" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="15872.53" record_version_obj="15873.53" version_number_seq="2.5498" secondary_key_value="cbcopy" import_version_number_seq="2.5498"><menu_item_obj>15872.53</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;Copy</menu_item_label>
<menu_item_description>Copy</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Copy</tooltip_text>
<shortcut_key>ALT-C</shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>cbcopy</menu_item_reference>
<propagate_links></propagate_links>
<security_token>Copy</security_token>
<item_toolbar_label>&amp;Copy</item_toolbar_label>
<image1_up_filename>ry/img/objectcopy.gif</image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>PUBLISH</item_select_type>
<item_select_action>toolbar</item_select_action>
<item_link>containertoolbar-target</item_link>
<item_select_parameter>Copy</item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style>Icon only</item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="59" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="09/04/2002" version_time="56940" version_user="Admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="15874.53" record_version_obj="15875.53" version_number_seq="2.5053" secondary_key_value="cbsearch" import_version_number_seq="2.5053"><menu_item_obj>15874.53</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>1000709352.09</item_category_obj>
<menu_item_label>&amp;Search</menu_item_label>
<menu_item_description>CB Search SubMenu</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>cbsearch</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label></item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type></item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Label</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="60" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="05/15/2003" version_time="60016" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="15878.53" record_version_obj="15879.53" version_number_seq="3.5498" secondary_key_value="cbpagesequence" import_version_number_seq="3.5498"><menu_item_obj>15878.53</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;Initialization Sequence</menu_item_label>
<menu_item_description>Container Builder Properties</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Object instance initialization sequence</tooltip_text>
<shortcut_key>ALT-I</shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>cbpagesequence</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label>Properties</item_toolbar_label>
<image1_up_filename>ry/img/instordr.gif</image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>PUBLISH</item_select_type>
<item_select_action>toolbar</item_select_action>
<item_link>containertoolbar-target</item_link>
<item_select_parameter>pageSequence</item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style>Icon only</item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="61" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="05/15/2003" version_time="60016" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="15884.53" record_version_obj="15885.53" version_number_seq="5.5498" secondary_key_value="cbobjectlocator" import_version_number_seq="5.5498"><menu_item_obj>15884.53</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>Find &amp;Object Instance</menu_item_label>
<menu_item_description>Find object instance</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Find object instance</tooltip_text>
<shortcut_key>CTRL-F</shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>cbobjectlocator</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label>Find</item_toolbar_label>
<image1_up_filename>ry/img/objectlocator.gif</image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>PUBLISH</item_select_type>
<item_select_action>toolbar</item_select_action>
<item_link>containertoolbar-target</item_link>
<item_select_parameter>locateObject</item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style>Icon only</item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="62" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="09/23/2002" version_time="35440" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="16169.53" record_version_obj="16170.53" version_number_seq="2.09" secondary_key_value="cbShowFilter" import_version_number_seq="2.09"><menu_item_obj>16169.53</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>Show/Hide &amp;Filter</menu_item_label>
<menu_item_description>Show/hide the filter for the object</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Show/hide the filter for the object</tooltip_text>
<shortcut_key>ALT-F</shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>cbShowFilter</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label>Find</item_toolbar_label>
<image1_up_filename>ry/img/showfilter.gif</image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename>ry/img/hidefilter.gif</image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>PUBLISH</item_select_type>
<item_select_action>toolbar</item_select_action>
<item_link>bottomtoolbar-target</item_link>
<item_select_parameter>showFilter</item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule>isFilterShowing()</image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style>Icon only</item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="63" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="05/15/2003" version_time="60016" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="16357.53" record_version_obj="16358.53" version_number_seq="4.5498" secondary_key_value="cbMoveUp" import_version_number_seq="4.5498"><menu_item_obj>16357.53</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>Move &amp;Up</menu_item_label>
<menu_item_description>Move Up</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Move Up</tooltip_text>
<shortcut_key>CTRL-CURSOR-UP</shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>cbMoveUp</menu_item_reference>
<propagate_links></propagate_links>
<security_token>Copy</security_token>
<item_toolbar_label>&amp;Move Up</item_toolbar_label>
<image1_up_filename>ry/img/moveup.gif</image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>PUBLISH</item_select_type>
<item_select_action>toolbar</item_select_action>
<item_link>containertoolbar-target</item_link>
<item_select_parameter>MoveUp</item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style>Icon only</item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="64" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="05/15/2003" version_time="60016" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="16361.53" record_version_obj="16362.53" version_number_seq="5.5498" secondary_key_value="cbMoveDown" import_version_number_seq="5.5498"><menu_item_obj>16361.53</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>Move &amp;Down</menu_item_label>
<menu_item_description>Move Down</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Move Down</tooltip_text>
<shortcut_key>CTRL-CURSOR-DOWN</shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>cbMoveDown</menu_item_reference>
<propagate_links></propagate_links>
<security_token>Copy</security_token>
<item_toolbar_label>&amp;Move Down</item_toolbar_label>
<image1_up_filename>ry/img/movedown.gif</image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>PUBLISH</item_select_type>
<item_select_action>toolbar</item_select_action>
<item_link>containertoolbar-target</item_link>
<item_select_parameter>MoveDown</item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style>Icon only</item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="65" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="05/15/2003" version_time="60016" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="16605.53" record_version_obj="16606.53" version_number_seq="4.5498" secondary_key_value="objMenuStruct" import_version_number_seq="4.5498"><menu_item_obj>16605.53</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>Menu &amp;Structures</menu_item_label>
<menu_item_description>Object Menu Structures</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Object menu structures</tooltip_text>
<shortcut_key>ALT-S</shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>objMenuStruct</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label>Menu Structure</item_toolbar_label>
<image1_up_filename>ry/img/menumenubar.gif</image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>PUBLISH</item_select_type>
<item_select_action>toolbar</item_select_action>
<item_link>containertoolbar-target</item_link>
<item_select_parameter>objMenuStruct</item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style>Icon only</item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="66" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="05/15/2003" version_time="60016" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="17023.53" record_version_obj="17024.53" version_number_seq="2.5498" secondary_key_value="cbModify" import_version_number_seq="2.5498"><menu_item_obj>17023.53</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;Modify</menu_item_label>
<menu_item_description>Modify</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Modify</tooltip_text>
<shortcut_key>ALT-M</shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>cbModify</menu_item_reference>
<propagate_links></propagate_links>
<security_token>Modify</security_token>
<item_toolbar_label>&amp;Modify</item_toolbar_label>
<image1_up_filename>adeicon/editcode.bmp</image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>PUBLISH</item_select_type>
<item_select_action>toolbar</item_select_action>
<item_link>containertoolbar-target</item_link>
<item_select_parameter>Modify</item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style>Icon only</item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="67" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="05/21/2003" version_time="51055" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="17182.0766" record_version_obj="17183.0766" version_number_seq="2.766" secondary_key_value="ICF667_00000204" import_version_number_seq="2.766"><menu_item_obj>17182.0766</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>17075.0766</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;Nationality Control</menu_item_label>
<menu_item_description>Nationality Control</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>ICF667_00000204</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label></item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>LAUNCH</item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="68" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="05/22/2003" version_time="61656" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="17343.0766" record_version_obj="17344.0766" version_number_seq="2.766" secondary_key_value="ICF667_00000205" import_version_number_seq="2.766"><menu_item_obj>17343.0766</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>17244.0766</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;Country Control</menu_item_label>
<menu_item_description>Country Control</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>ICF667_00000205</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label></item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>LAUNCH</item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="69" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="06/05/2003" version_time="61319" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="17747.0766" record_version_obj="17748.0766" version_number_seq="4.766" secondary_key_value="ICF667_00000206" import_version_number_seq="4.766"><menu_item_obj>17747.0766</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>17412.0766</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>Custom Proce&amp;dure Control</menu_item_label>
<menu_item_description>Custom Procedure Control</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>ICF667_00000206</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label></item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>LAUNCH</item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="70" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="08/27/2003" version_time="49258" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="36141.3993" record_version_obj="36142.3993" version_number_seq="2.3993" secondary_key_value="ICF3993_00000204" import_version_number_seq="2.3993"><menu_item_obj>36141.3993</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>36124.3993</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;Generate Client Cache</menu_item_label>
<menu_item_description>Client Cache Generation Tool</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Client Cache Generation Tool</tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>ICF3993_00000204</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label>&amp;Generate Client Cache</item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>LAUNCH</item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="71" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="02/03/2003" version_time="56820" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="48549.9875" record_version_obj="48550.9875" version_number_seq="1.09" secondary_key_value="NodeMaintenance" import_version_number_seq="1.09"><menu_item_obj>48549.9875</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>Node Maintenance</menu_item_label>
<menu_item_description>Node Maintenance</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>NodeMaintenance</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label>Node Maintenance</item_toolbar_label>
<image1_up_filename>ry/img/treeview_up.bmp</image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>PUBLISH</item_select_type>
<item_select_action>toolbar</item_select_action>
<item_link></item_link>
<item_select_parameter>nodemaintenance</item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style>Icon only</item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="72" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="02/04/2003" version_time="53874" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="50791.9875" record_version_obj="50792.9875" version_number_seq="1.09" secondary_key_value="OGPreferences" import_version_number_seq="1.09"><menu_item_obj>50791.9875</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>50377.9875</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;Preferences...</menu_item_label>
<menu_item_description>Preferences</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>OGPreferences</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label>Preferences</item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>LAUNCH</item_select_type>
<item_select_action></item_select_action>
<item_link>run-source</item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="73" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="05/15/2003" version_time="60016" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="90241.9875" record_version_obj="90242.9875" version_number_seq="3.5498" secondary_key_value="cbSaveAs" import_version_number_seq="3.5498"><menu_item_obj>90241.9875</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>Save &amp;As</menu_item_label>
<menu_item_description>Save As</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Save As</tooltip_text>
<shortcut_key>SHIFT-F6</shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>cbSaveAs</menu_item_reference>
<propagate_links></propagate_links>
<security_token>SaveAs</security_token>
<item_toolbar_label>Save &amp;As</item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>PUBLISH</item_select_type>
<item_select_action>toolbar</item_select_action>
<item_link>containertoolbar-target</item_link>
<item_select_parameter>SaveAs</item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style>Icon only</item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="74" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="99019" record_version_obj="3000058500.09" version_number_seq="1.09" secondary_key_value="ASMNU_00000350" import_version_number_seq="1.09"><menu_item_obj>99019</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>1000709352.09</item_category_obj>
<menu_item_label>&amp;Links</menu_item_label>
<menu_item_description>Dynamics menu</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>ASMNU_00000350</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label></item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type></item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Label</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="75" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="99023" record_version_obj="3000058501.09" version_number_seq="1.09" secondary_key_value="ASMNU_00000354" import_version_number_seq="1.09"><menu_item_obj>99023</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>243052</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>Database Viewer</menu_item_label>
<menu_item_description>Database Viewer</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Database Viewer</tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>ASMNU_00000354</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label></item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>Launch</item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="76" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="03/27/2003" version_time="58635" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="300002.24" record_version_obj="300003.24" version_number_seq="1.09" secondary_key_value="ICF42_00000204" import_version_number_seq="1.09"><menu_item_obj>300002.24</menu_item_obj>
<product_module_obj>1004874679.09</product_module_obj>
<object_obj>300004.24</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>Reset Data Modified Status</menu_item_label>
<menu_item_description>Reset Data Modified Status</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Reset Data Modified Status</tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>ICF42_00000204</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label>Reset Data Modified Status</item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>LAUNCH</item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style>Icon only</item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration>This option will allows for the Data Modified Status on all objects to be reset.</item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="77" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="09/12/2003" version_time="34389" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="908470.24" record_version_obj="908471.24" version_number_seq="2.24" secondary_key_value="ICF42_00000905" import_version_number_seq="2.24"><menu_item_obj>908470.24</menu_item_obj>
<product_module_obj>1004874710.09</product_module_obj>
<object_obj>908460.24</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>Configuration File Import</menu_item_label>
<menu_item_description>Configuration File Import</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Configuration File Import</tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>ICF42_00000905</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label>Configuration File Import</item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>LAUNCH</item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration>Import a Configuration XML file into the repository.</item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="78" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="09/22/2003" version_time="61900" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="910643.24" record_version_obj="910644.24" version_number_seq="3.24" secondary_key_value="ICF42_00000906" import_version_number_seq="3.24"><menu_item_obj>910643.24</menu_item_obj>
<product_module_obj>1004874679.09</product_module_obj>
<object_obj>910637.24</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>Session Type Control Data</menu_item_label>
<menu_item_description>Session Type Control Data</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Session Type Control Data</tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>ICF42_00000906</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label>Session Type Control Data</item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>LAUNCH</item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="79" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/01/2003" version_time="39949" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="911075.24" record_version_obj="911076.24" version_number_seq="2.24" secondary_key_value="ICF42_00000907" import_version_number_seq="2.24"><menu_item_obj>911075.24</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>911001.24</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>Release Version Control</menu_item_label>
<menu_item_description>Release Version Control</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Release Version Control</tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>ICF42_00000907</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label>Release Version Control</item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>LAUNCH</item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="80" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="06/05/2003" version_time="61319" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="1000000174.5566" record_version_obj="1000000175.5566" version_number_seq="3.766" secondary_key_value="ICF6655_00000204" import_version_number_seq="3.766"><menu_item_obj>1000000174.5566</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>1000000003.5566</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>Redund&amp;ant ADO Listing</menu_item_label>
<menu_item_description>Redundant ADO Listing</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Redundant ADO Listing</tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>ICF6655_00000204</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label>Redundant ADO Listing</item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>LAUNCH</item_select_type>
<item_select_action></item_select_action>
<item_link>?</item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="81" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="09/04/2002" version_time="56942" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="1000000806.28" record_version_obj="1000000807.28" version_number_seq="3.28" secondary_key_value="ICF_00000204" import_version_number_seq="3.28"><menu_item_obj>1000000806.28</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>1000000525.28</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>G&amp;lobal Control</menu_item_label>
<menu_item_description>Global Control Maintenance</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>ICF_00000204</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label>Global Control</item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>LAUNCH</item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="82" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="09/04/2002" version_time="56942" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="1000000924.48" record_version_obj="1000000925.48" version_number_seq="1.09" secondary_key_value="ICF84_00000204" import_version_number_seq="1.09"><menu_item_obj>1000000924.48</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>2000041402.28</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>Customization Maintenance</menu_item_label>
<menu_item_description>Customization Maintenance</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>ICF84_00000204</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label>Customisation Type</item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>LAUNCH</item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style>Icon only</item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="83" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="09/04/2002" version_time="56942" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="1000000926.48" record_version_obj="1000000927.48" version_number_seq="2.48" secondary_key_value="ICF84_00000205" import_version_number_seq="2.48"><menu_item_obj>1000000926.48</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>1000000716.48</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>Customisation Result</menu_item_label>
<menu_item_description>Customisation Result Maintenance</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>ICF84_00000205</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label>Customisation Result</item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>LAUNCH</item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style>Icon only</item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="84" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="09/04/2002" version_time="56942" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="1000000928.48" record_version_obj="1000000929.48" version_number_seq="2.48" secondary_key_value="ICF84_00000206" import_version_number_seq="2.48"><menu_item_obj>1000000928.48</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>1000000911.48</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>Customisation Reference</menu_item_label>
<menu_item_description>Customisation Reference Maintenance</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>ICF84_00000206</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label>Customisation Reference</item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>LAUNCH</item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style>Icon only</item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="85" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="09/22/2003" version_time="61885" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="1000009544.81" record_version_obj="1000009545.81" version_number_seq="2.81" secondary_key_value="ICF18_00000205" import_version_number_seq="2.81"><menu_item_obj>1000009544.81</menu_item_obj>
<product_module_obj>1004874707.09</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>1000709352.09</item_category_obj>
<menu_item_label>&amp;SCM</menu_item_label>
<menu_item_description>Software Configuration Management</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>yes</under_development>
<menu_item_reference>ICF18_00000205</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label></item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type></item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Label</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="86" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="08/11/2003" version_time="46710" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="1000708103.09" record_version_obj="4317.7692" version_number_seq="3" secondary_key_value="Exit" import_version_number_seq="3"><menu_item_obj>1000708103.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>E&amp;xit</menu_item_label>
<menu_item_description>Exit</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Exit</tooltip_text>
<shortcut_key>ALT-X</shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>Exit</menu_item_reference>
<propagate_links></propagate_links>
<security_token>Exit</security_token>
<item_toolbar_label>E&amp;xit</item_toolbar_label>
<image1_up_filename>ry/img/exit.gif</image1_up_filename>
<image1_down_filename>ry/img/toolclip.bmp,96,64,16,16</image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>PUBLISH</item_select_type>
<item_select_action>exitObject</item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>ACTION</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="87" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="08/11/2003" version_time="46710" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="1000708104.09" record_version_obj="4301.7692" version_number_seq="3" secondary_key_value="Add" import_version_number_seq="3"><menu_item_obj>1000708104.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>1000709351.09</item_category_obj>
<menu_item_label>&amp;Add record</menu_item_label>
<menu_item_description>Add record</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Add record</tooltip_text>
<shortcut_key>ALT-A</shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>Add</menu_item_reference>
<propagate_links></propagate_links>
<security_token>Add</security_token>
<item_toolbar_label>&amp;Add</item_toolbar_label>
<image1_up_filename>ry/img/add.gif</image1_up_filename>
<image1_down_filename>ry/img/toolclip.bmp,0,0,16,16</image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>PUBLISH</item_select_type>
<item_select_action>addRecord</item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule>RecordState=RecordAvailable,NoRecordAvailable and Editable and DataModified=no and CanNavigate()</enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>ACTION</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="88" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="08/11/2003" version_time="46711" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="1000708105.09" record_version_obj="4306.7692" version_number_seq="3" secondary_key_value="Update" import_version_number_seq="3"><menu_item_obj>1000708105.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>1000709351.09</item_category_obj>
<menu_item_label>&amp;Update record</menu_item_label>
<menu_item_description>Update record</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Modify record</tooltip_text>
<shortcut_key>ALT-U</shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>Update</menu_item_reference>
<propagate_links></propagate_links>
<security_token>Modify</security_token>
<item_toolbar_label>&amp;Modify</item_toolbar_label>
<image1_up_filename>ry/img/update.gif</image1_up_filename>
<image1_down_filename>ry/img/toolclip.bmp,48,0,16,16</image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>PUBLISH</item_select_type>
<item_select_action>updateMode</item_select_action>
<item_link></item_link>
<item_select_parameter>UpdateBegin</item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule>RecordState=RecordAvailable  and  Editable and ObjectMode=View</enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>ACTION</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="89" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="08/11/2003" version_time="46710" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="1000708106.09" record_version_obj="4302.7692" version_number_seq="3" secondary_key_value="Copy" import_version_number_seq="3"><menu_item_obj>1000708106.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>1000709351.09</item_category_obj>
<menu_item_label>&amp;Copy record</menu_item_label>
<menu_item_description>Copy record</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Copy record</tooltip_text>
<shortcut_key>ALT-C</shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>Copy</menu_item_reference>
<propagate_links></propagate_links>
<security_token>Copy</security_token>
<item_toolbar_label>&amp;Copy</item_toolbar_label>
<image1_up_filename>ry/img/copyrec.gif</image1_up_filename>
<image1_down_filename>ry/img/toolclip.bmp,16,0,16,16</image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>PUBLISH</item_select_type>
<item_select_action>copyRecord</item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule>RecordState=RecordAvailable and Editable and DataModified=no and canNavigate()</enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>ACTION</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="90" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="08/11/2003" version_time="46710" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="1000708107.09" record_version_obj="4303.7692" version_number_seq="3" secondary_key_value="Delete" import_version_number_seq="3"><menu_item_obj>1000708107.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>1000709351.09</item_category_obj>
<menu_item_label>&amp;Delete record</menu_item_label>
<menu_item_description>Delete record</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Delete record</tooltip_text>
<shortcut_key>ALT-D</shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>Delete</menu_item_reference>
<propagate_links></propagate_links>
<security_token>Delete</security_token>
<item_toolbar_label>&amp;Delete</item_toolbar_label>
<image1_up_filename>ry/img/deleterec.gif</image1_up_filename>
<image1_down_filename>ry/img/toolclip.bmp,32,0,16,16</image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>PUBLISH</item_select_type>
<item_select_action>deleteRecord</item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule>RecordState=RecordAvailable and DataModified=no and canNavigate()</enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>ACTION</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="91" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="08/11/2003" version_time="46711" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="1000708108.09" record_version_obj="4305.7692" version_number_seq="3" secondary_key_value="Save" import_version_number_seq="3"><menu_item_obj>1000708108.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>1000709351.09</item_category_obj>
<menu_item_label>&amp;Save record</menu_item_label>
<menu_item_description>Save record</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Save record</tooltip_text>
<shortcut_key>ALT-S</shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>Save</menu_item_reference>
<propagate_links></propagate_links>
<security_token>Save</security_token>
<item_toolbar_label>&amp;Save</item_toolbar_label>
<image1_up_filename>ry/img/saverec.gif</image1_up_filename>
<image1_down_filename>ry/img/toolclip.bmp,80,0,16,16</image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>PUBLISH</item_select_type>
<item_select_action>updateRecord</item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule>NewRecord=add,copy or DataModified</enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>ACTION</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="92" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="08/11/2003" version_time="46711" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="1000708109.09" record_version_obj="4304.7692" version_number_seq="3" secondary_key_value="Reset" import_version_number_seq="3"><menu_item_obj>1000708109.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>1000709351.09</item_category_obj>
<menu_item_label>&amp;Reset record</menu_item_label>
<menu_item_description>Reset record</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Reset record</tooltip_text>
<shortcut_key>ALT-R</shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>Reset</menu_item_reference>
<propagate_links></propagate_links>
<security_token>Reset</security_token>
<item_toolbar_label>&amp;Reset</item_toolbar_label>
<image1_up_filename>ry/img/reset.gif</image1_up_filename>
<image1_down_filename>ry/img/toolclip.bmp,96,0,16,16</image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>PUBLISH</item_select_type>
<item_select_action>resetRecord</item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule>DataModified</enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>ACTION</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="93" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="08/11/2003" version_time="46710" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="1000708110.09" record_version_obj="18275.66" version_number_seq="5" secondary_key_value="Cancel" import_version_number_seq="5"><menu_item_obj>1000708110.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>1000709351.09</item_category_obj>
<menu_item_label>Cance&amp;l record</menu_item_label>
<menu_item_description>Cancel record</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Cancel record</tooltip_text>
<shortcut_key>ALT-L</shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>Cancel</menu_item_reference>
<propagate_links></propagate_links>
<security_token>Cancel</security_token>
<item_toolbar_label>Cance&amp;l</item_toolbar_label>
<image1_up_filename>ry/img/cancel.gif</image1_up_filename>
<image1_down_filename>ry/img/toolclip.bmp,112,0,16,16</image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>PUBLISH</item_select_type>
<item_select_action>cancelRecord</item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule>ObjectMode=Modify and SaveSource=no and DataModified or ObjectMode=Update or NewRecord=add,copy</enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>ACTION</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="94" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="08/11/2003" version_time="46711" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="1000708111.09" record_version_obj="4310.7692" version_number_seq="3" secondary_key_value="Undo" import_version_number_seq="3"><menu_item_obj>1000708111.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>1000709349.09</item_category_obj>
<menu_item_label>U&amp;ndo</menu_item_label>
<menu_item_description>Undo</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Undo transaction</tooltip_text>
<shortcut_key>ALT-N</shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>Undo</menu_item_reference>
<propagate_links></propagate_links>
<security_token>Undo</security_token>
<item_toolbar_label>U&amp;ndo</item_toolbar_label>
<image1_up_filename>ry/img/rollback.gif</image1_up_filename>
<image1_down_filename>ry/img/toolclip.bmp,0,32,16,16</image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>PUBLISH</item_select_type>
<item_select_action>undoTransaction</item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule>RowObjectState=RowUpdated</enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>ACTION</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="95" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="08/11/2003" version_time="46710" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="1000708112.09" record_version_obj="4312.7692" version_number_seq="3" secondary_key_value="Commit" import_version_number_seq="3"><menu_item_obj>1000708112.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>1000709349.09</item_category_obj>
<menu_item_label>Co&amp;mmit</menu_item_label>
<menu_item_description>Commit</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Commit transaction</tooltip_text>
<shortcut_key>ALT-M</shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>Commit</menu_item_reference>
<propagate_links></propagate_links>
<security_token>Commit</security_token>
<item_toolbar_label>Co&amp;mmit</item_toolbar_label>
<image1_up_filename>ry/img/commit.gif</image1_up_filename>
<image1_down_filename>ry/img/toolclip.bmp,16,32,16,16</image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>PUBLISH</item_select_type>
<item_select_action>commitTransaction</item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule>RowObjectState=RowUpdated</enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>ACTION</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="96" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="08/11/2003" version_time="46711" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="1000708113.09" record_version_obj="4307.7692" version_number_seq="3" secondary_key_value="First" import_version_number_seq="3"><menu_item_obj>1000708113.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>1000709350.09</item_category_obj>
<menu_item_label>&amp;First</menu_item_label>
<menu_item_description>First</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>First</tooltip_text>
<shortcut_key>ALT-CURSOR-UP</shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>First</menu_item_reference>
<propagate_links></propagate_links>
<security_token>First</security_token>
<item_toolbar_label>&amp;First</item_toolbar_label>
<image1_up_filename>ry/img/first.gif</image1_up_filename>
<image1_down_filename>ry/img/toolclip.bmp,64,16,16,16</image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>PUBLISH</item_select_type>
<item_select_action>fetchFirst</item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule>QueryPosition=LastRecord,NotFirstOrlast and canNavigate()</enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>ACTION</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="97" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="08/11/2003" version_time="46711" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="1000708114.09" record_version_obj="4309.7692" version_number_seq="3" secondary_key_value="Prev" import_version_number_seq="3"><menu_item_obj>1000708114.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>1000709350.09</item_category_obj>
<menu_item_label>&amp;Prev</menu_item_label>
<menu_item_description>Prev</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Previous</tooltip_text>
<shortcut_key>ALT-CURSOR-LEFT</shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>Prev</menu_item_reference>
<propagate_links></propagate_links>
<security_token>Prev</security_token>
<item_toolbar_label>&amp;Prev</item_toolbar_label>
<image1_up_filename>ry/img/prev.gif</image1_up_filename>
<image1_down_filename>ry/img/toolclip.bmp,80,16,16,16</image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>PUBLISH</item_select_type>
<item_select_action>fetchPrev</item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule>QueryPosition=LastRecord,NotFirstOrlast and canNavigate()</enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>ACTION</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="98" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="08/11/2003" version_time="46711" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="1000708115.09" record_version_obj="4308.7692" version_number_seq="3" secondary_key_value="Next" import_version_number_seq="3"><menu_item_obj>1000708115.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>1000709350.09</item_category_obj>
<menu_item_label>&amp;Next</menu_item_label>
<menu_item_description>Next</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Next</tooltip_text>
<shortcut_key>ALT-CURSOR-RIGHT</shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>Next</menu_item_reference>
<propagate_links></propagate_links>
<security_token>Next</security_token>
<item_toolbar_label>&amp;Next</item_toolbar_label>
<image1_up_filename>ry/img/next.gif</image1_up_filename>
<image1_down_filename>ry/img/toolclip.bmp,96,16,16,16</image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>PUBLISH</item_select_type>
<item_select_action>fetchNext</item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule>QueryPosition=FirstRecord,NotFirstOrlast and canNavigate()</enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>ACTION</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="99" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="08/11/2003" version_time="46711" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="1000708116.09" record_version_obj="4311.7692" version_number_seq="3" secondary_key_value="Last" import_version_number_seq="3"><menu_item_obj>1000708116.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>1000709350.09</item_category_obj>
<menu_item_label>&amp;Last</menu_item_label>
<menu_item_description>Last</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Last</tooltip_text>
<shortcut_key>ALT-CURSOR-DOWN</shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>Last</menu_item_reference>
<propagate_links></propagate_links>
<security_token>Last</security_token>
<item_toolbar_label>&amp;Last</item_toolbar_label>
<image1_up_filename>ry/img/last.gif</image1_up_filename>
<image1_down_filename>ry/img/toolclip.bmp,112,16,16,16</image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>PUBLISH</item_select_type>
<item_select_action>fetchLast</item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule>QueryPosition=FirstRecord,NotFirstOrlast and canNavigate()</enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>ACTION</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="100" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="08/11/2003" version_time="46711" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="1000708117.09" record_version_obj="4313.7692" version_number_seq="3" secondary_key_value="Filter" import_version_number_seq="3"><menu_item_obj>1000708117.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>Fil&amp;ter...</menu_item_label>
<menu_item_description>Filter...</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Filter</tooltip_text>
<shortcut_key>ALT-T</shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>Filter</menu_item_reference>
<propagate_links></propagate_links>
<security_token>Filter</security_token>
<item_toolbar_label>Fil&amp;ter...</item_toolbar_label>
<image1_up_filename>ry/img/filter.gif</image1_up_filename>
<image1_down_filename>ry/img/toolclip.bmp,48,16,16,16</image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>PUBLISH</item_select_type>
<item_select_action>startFilter</item_select_action>
<item_link>navigation-target</item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule>FilterAvailable=yes</enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>ACTION</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="101" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="05/15/2003" version_time="60017" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="1000708118.09" record_version_obj="440.5498" version_number_seq="1.5498" secondary_key_value="TxtOK" import_version_number_seq="1.5498"><menu_item_obj>1000708118.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;OK</menu_item_label>
<menu_item_description>OK</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key>ALT-O</shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>TxtOK</menu_item_reference>
<propagate_links></propagate_links>
<security_token>OK</security_token>
<item_toolbar_label>&amp;OK</item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>PUBLISH</item_select_type>
<item_select_action>okObject</item_select_action>
<item_link>containertoolbar-target</item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule>UpdateActive=no</hide_rule>
<item_control_type>ACTION</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="102" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1000708120.09" record_version_obj="3000058502.09" version_number_seq="1.09" secondary_key_value="TxtClear" import_version_number_seq="1.09"><menu_item_obj>1000708120.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;Clear</menu_item_label>
<menu_item_description>Clear</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key>ALT-C</shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>TxtClear</menu_item_reference>
<propagate_links></propagate_links>
<security_token>Clear</security_token>
<item_toolbar_label>&amp;Clear</item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>PUBLISH</item_select_type>
<item_select_action>toolbar</item_select_action>
<item_link>toolbar-target</item_link>
<item_select_parameter>Clear</item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>ACTION</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="103" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="05/15/2003" version_time="60017" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="1000708121.09" record_version_obj="561.5498" version_number_seq="2.5498" secondary_key_value="TxtSelect" import_version_number_seq="2.5498"><menu_item_obj>1000708121.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;Select Record</menu_item_label>
<menu_item_description>Select Record</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key>ALT-S</shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>TxtSelect</menu_item_reference>
<propagate_links></propagate_links>
<security_token>Select</security_token>
<item_toolbar_label>&amp;Select</item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>PUBLISH</item_select_type>
<item_select_action>toolbar</item_select_action>
<item_link></item_link>
<item_select_parameter>Select</item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>ACTION</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="104" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="05/15/2003" version_time="60017" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="1000708122.09" record_version_obj="428.5498" version_number_seq="1.5498" secondary_key_value="TxtCancel" import_version_number_seq="1.5498"><menu_item_obj>1000708122.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;Cancel</menu_item_label>
<menu_item_description>Cancel</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key>ALT-C</shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>TxtCancel</menu_item_reference>
<propagate_links></propagate_links>
<security_token>Cancel</security_token>
<item_toolbar_label>&amp;Cancel</item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>PUBLISH</item_select_type>
<item_select_action>cancelObject</item_select_action>
<item_link>containertoolbar-target</item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule>UpdateActive=no</hide_rule>
<item_control_type>ACTION</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="105" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="05/15/2003" version_time="60017" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="1000708124.09" record_version_obj="432.5498" version_number_seq="1.5498" secondary_key_value="TxtExit" import_version_number_seq="1.5498"><menu_item_obj>1000708124.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>E&amp;xit</menu_item_label>
<menu_item_description>Exit</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key>ALT-X</shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>TxtExit</menu_item_reference>
<propagate_links></propagate_links>
<security_token>Exit</security_token>
<item_toolbar_label>E&amp;xit</item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>PUBLISH</item_select_type>
<item_select_action>exitObject</item_select_action>
<item_link>containertoolbar-target</item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule>UpdateActive</hide_rule>
<item_control_type>ACTION</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="106" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="05/15/2003" version_time="60017" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="1000708125.09" record_version_obj="433.5498" version_number_seq="2.5498" secondary_key_value="TxtTableioExit" import_version_number_seq="2.5498"><menu_item_obj>1000708125.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>E&amp;xit</menu_item_label>
<menu_item_description>Exit</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key>ALT-X</shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>TxtTableioExit</menu_item_reference>
<propagate_links></propagate_links>
<security_token>Exit</security_token>
<item_toolbar_label>E&amp;xit</item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>PUBLISH</item_select_type>
<item_select_action>exitObject</item_select_action>
<item_link>toolbar-target</item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule>UpdateActive</hide_rule>
<item_control_type>ACTION</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="107" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1000708126.09" record_version_obj="3000058503.09" version_number_seq="1.09" secondary_key_value="TxtApply" import_version_number_seq="1.09"><menu_item_obj>1000708126.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;Apply</menu_item_label>
<menu_item_description>Apply</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key>ALT-A</shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>TxtApply</menu_item_reference>
<propagate_links></propagate_links>
<security_token>Apply</security_token>
<item_toolbar_label>&amp;Apply</item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>PUBLISH</item_select_type>
<item_select_action>toolbar</item_select_action>
<item_link></item_link>
<item_select_parameter>Apply</item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>ACTION</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="108" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1000708127.09" record_version_obj="3000058504.09" version_number_seq="1.09" secondary_key_value="TxtCreate" import_version_number_seq="1.09"><menu_item_obj>1000708127.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>Cre&amp;ate</menu_item_label>
<menu_item_description>Create</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key>ALT-A</shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>TxtCreate</menu_item_reference>
<propagate_links></propagate_links>
<security_token>Create</security_token>
<item_toolbar_label>Cre&amp;ate</item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>PUBLISH</item_select_type>
<item_select_action>toolbar</item_select_action>
<item_link>toolbar-target</item_link>
<item_select_parameter>Create</item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>ACTION</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="109" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="05/15/2003" version_time="60017" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="1000708128.09" record_version_obj="435.5498" version_number_seq="1.5498" secondary_key_value="TxtHelp" import_version_number_seq="1.5498"><menu_item_obj>1000708128.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;Help</menu_item_label>
<menu_item_description>Help</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key>ALT-H</shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>TxtHelp</menu_item_reference>
<propagate_links></propagate_links>
<security_token>Help</security_token>
<item_toolbar_label>&amp;Help</item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>PUBLISH</item_select_type>
<item_select_action>toolbar</item_select_action>
<item_link>containertoolbar-target</item_link>
<item_select_parameter>Help</item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>ACTION</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="110" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="05/15/2003" version_time="60016" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="1000708129.09" record_version_obj="434.5498" version_number_seq="3.5498" secondary_key_value="IconHelp" import_version_number_seq="3.5498"><menu_item_obj>1000708129.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;Help</menu_item_label>
<menu_item_description>Help</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key>ALT-H</shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>IconHelp</menu_item_reference>
<propagate_links></propagate_links>
<security_token>Help</security_token>
<item_toolbar_label>&amp;Help</item_toolbar_label>
<image1_up_filename>ry/img/help.gif</image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>PUBLISH</item_select_type>
<item_select_action>toolbar</item_select_action>
<item_link>containertoolbar-target</item_link>
<item_select_parameter>Help</item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>ACTION</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="111" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="09/12/2003" version_time="72239" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="1000708130.09" record_version_obj="2681.5498" version_number_seq="2.5498" secondary_key_value="Copy2" import_version_number_seq="2.5498"><menu_item_obj>1000708130.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;Copy record</menu_item_label>
<menu_item_description>Copy record</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Copy record</tooltip_text>
<shortcut_key>ALT-C</shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>Copy2</menu_item_reference>
<propagate_links></propagate_links>
<security_token>Copy</security_token>
<item_toolbar_label>&amp;Copy</item_toolbar_label>
<image1_up_filename>ry/img/copyrec.gif</image1_up_filename>
<image1_down_filename>ry/img/toolclip.bmp,16,0,16,16</image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>PUBLISH</item_select_type>
<item_select_action>toolbar</item_select_action>
<item_link>toolbar-target</item_link>
<item_select_parameter>Copy</item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule>canLaunchDetailWindow() and RecordState=RecordAvailable and CanNavigate()</enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>ACTION</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="112" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="09/12/2003" version_time="72239" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="1000708131.09" record_version_obj="2682.5498" version_number_seq="2.5498" secondary_key_value="Delete2" import_version_number_seq="2.5498"><menu_item_obj>1000708131.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;Delete record</menu_item_label>
<menu_item_description>Delete record</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Delete record</tooltip_text>
<shortcut_key>ALT-D</shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>Delete2</menu_item_reference>
<propagate_links></propagate_links>
<security_token>Delete</security_token>
<item_toolbar_label>&amp;Delete</item_toolbar_label>
<image1_up_filename>ry/img/deleterec.gif</image1_up_filename>
<image1_down_filename>ry/img/toolclip.bmp,32,0,16,16</image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>PUBLISH</item_select_type>
<item_select_action>toolbar</item_select_action>
<item_link>toolbar-target</item_link>
<item_select_parameter>Delete</item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule>canLaunchDetailWindow() and RecordState=RecordAvailable and CanNavigate()</enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>ACTION</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="113" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="09/18/2003" version_time="59592" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="1000708132.09" record_version_obj="2680.5498" version_number_seq="2.5498" secondary_key_value="Add2" import_version_number_seq="2.5498"><menu_item_obj>1000708132.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;Add record</menu_item_label>
<menu_item_description>Add record</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Add record</tooltip_text>
<shortcut_key>ALT-A</shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>Add2</menu_item_reference>
<propagate_links></propagate_links>
<security_token>Add</security_token>
<item_toolbar_label>&amp;Add</item_toolbar_label>
<image1_up_filename>ry/img/add.gif</image1_up_filename>
<image1_down_filename>ry/img/toolclip.bmp,0,0,16,16</image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>PUBLISH</item_select_type>
<item_select_action>toolbar</item_select_action>
<item_link>toolbar-target</item_link>
<item_select_parameter>Add</item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule>canLaunchDetailWindow() and RecordState=RecordAvailable,NoRecordAvailable and CanNavigate()</enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>ACTION</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="114" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="09/12/2003" version_time="72239" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="1000708134.09" record_version_obj="2683.5498" version_number_seq="2.5498" secondary_key_value="Modify" import_version_number_seq="2.5498"><menu_item_obj>1000708134.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;Modify record</menu_item_label>
<menu_item_description>Modify record</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Modify record</tooltip_text>
<shortcut_key>ALT-M</shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>Modify</menu_item_reference>
<propagate_links></propagate_links>
<security_token>Modify</security_token>
<item_toolbar_label>&amp;Modify</item_toolbar_label>
<image1_up_filename>ry/img/update.gif</image1_up_filename>
<image1_down_filename>ry/img/toolclip.bmp,48,0,16,16</image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>PUBLISH</item_select_type>
<item_select_action>toolbar</item_select_action>
<item_link>toolbar-target</item_link>
<item_select_parameter>Modify</item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule>canLaunchDetailWindow() and RecordState=RecordAvailable and CanNavigate()</enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>ACTION</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="115" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="09/12/2003" version_time="72239" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="1000708135.09" record_version_obj="4304.66" version_number_seq="2.5498" secondary_key_value="View" import_version_number_seq="2.5498"><menu_item_obj>1000708135.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;View record</menu_item_label>
<menu_item_description>View record</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>View record</tooltip_text>
<shortcut_key>ALT-V</shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>View</menu_item_reference>
<propagate_links></propagate_links>
<security_token>View</security_token>
<item_toolbar_label>&amp;View</item_toolbar_label>
<image1_up_filename>ry/img/viewrecord.gif</image1_up_filename>
<image1_down_filename>ry/img/toolclip.bmp,64,0,16,16</image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>PUBLISH</item_select_type>
<item_select_action>toolbar</item_select_action>
<item_link>toolbar-target</item_link>
<item_select_parameter>View</item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule>canLaunchDetailWindow() and RecordState=RecordAvailable and CanNavigate()</enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>ACTION</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="116" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="08/11/2003" version_time="46711" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="1000708136.09" record_version_obj="4315.7692" version_number_seq="3" secondary_key_value="Find" import_version_number_seq="3"><menu_item_obj>1000708136.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>Fi&amp;nd record...</menu_item_label>
<menu_item_description>Find record...</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Find record</tooltip_text>
<shortcut_key>ALT-N</shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>Find</menu_item_reference>
<propagate_links></propagate_links>
<security_token>Find</security_token>
<item_toolbar_label>Fi&amp;nd...</item_toolbar_label>
<image1_up_filename>ry/img/affind.gif</image1_up_filename>
<image1_down_filename>ry/img/toolclip.bmp,0,16,16,16</image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>PUBLISH</item_select_type>
<item_select_action>toolbar</item_select_action>
<item_link>toolbar-target</item_link>
<item_select_parameter>Find</item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>ACTION</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="117" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="08/11/2003" version_time="46711" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="1000708137.09" record_version_obj="4316.7692" version_number_seq="3" secondary_key_value="Filter2" import_version_number_seq="3"><menu_item_obj>1000708137.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>Fil&amp;ter records...</menu_item_label>
<menu_item_description>Filter records...</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Filter records</tooltip_text>
<shortcut_key>ALT-T</shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>Filter2</menu_item_reference>
<propagate_links></propagate_links>
<security_token>Filter</security_token>
<item_toolbar_label>Fil&amp;ter...</item_toolbar_label>
<image1_up_filename>ry/img/affunnel.gif</image1_up_filename>
<image1_down_filename>ry/img/toolclip.bmp,16,16,16,16</image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename>ry/img/affuntick.gif</image2_up_filename>
<image2_down_filename>ry/img/toolclip.bmp,32,16,16,16</image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>PUBLISH</item_select_type>
<item_select_action>toolbar</item_select_action>
<item_link>toolbar-target</item_link>
<item_select_parameter>Filter</item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule>FilterActive</image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>ACTION</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="118" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="08/11/2003" version_time="46711" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="1000708138.09" record_version_obj="2685.5498" version_number_seq="4" secondary_key_value="Preview" import_version_number_seq="4"><menu_item_obj>1000708138.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>Print Pre&amp;view</menu_item_label>
<menu_item_description>Print Preview</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Print Preview</tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>Preview</menu_item_reference>
<propagate_links></propagate_links>
<security_token>Preview</security_token>
<item_toolbar_label>Pre&amp;view</item_toolbar_label>
<image1_up_filename>ry/img/afprintpre.gif</image1_up_filename>
<image1_down_filename>ry/img/toolclip.bmp,96,32,16,16</image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>PUBLISH</item_select_type>
<item_select_action>toolbar</item_select_action>
<item_link>toolbar-target</item_link>
<item_select_parameter>Preview</item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule>PrintPreviewActive=yes and RecordState=RecordAvailable</enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>ACTION</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="119" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="08/11/2003" version_time="46710" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="1000708139.09" record_version_obj="2686.5498" version_number_seq="4" secondary_key_value="Export" import_version_number_seq="4"><menu_item_obj>1000708139.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;Export...</menu_item_label>
<menu_item_description>Export...</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Export</tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>Export</menu_item_reference>
<propagate_links></propagate_links>
<security_token>Export</security_token>
<item_toolbar_label>&amp;Export...</item_toolbar_label>
<image1_up_filename>ry/img/aftoexcel.gif</image1_up_filename>
<image1_down_filename>ry/img/toolclip.bmp,112,32,16,16</image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>PUBLISH</item_select_type>
<item_select_action>toolbar</item_select_action>
<item_link>toolbar-target</item_link>
<item_select_parameter>Export</item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule>RecordState=RecordAvailable</enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>ACTION</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="120" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="08/11/2003" version_time="46710" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="1000708140.09" record_version_obj="27309.48" version_number_seq="6" secondary_key_value="Audit" import_version_number_seq="6"><menu_item_obj>1000708140.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;Audit...</menu_item_label>
<menu_item_description>Audit...</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Audit</tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>Audit</menu_item_reference>
<propagate_links></propagate_links>
<security_token>Audit</security_token>
<item_toolbar_label>&amp;Audit...</item_toolbar_label>
<image1_up_filename>ry/img/afauditlog.gif</image1_up_filename>
<image1_down_filename>ry/img/toolclip.bmp,0,48,16,16</image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename>ry/img/afaudtick.gif</image2_up_filename>
<image2_down_filename>ry/img/toolclip.bmp,16,48,16,16</image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>PUBLISH</item_select_type>
<item_select_action>toolbar</item_select_action>
<item_link>toolbar-target</item_link>
<item_select_parameter>Audit</item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule>RecordState=RecordAvailable and AuditEnabled</enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule>hasActiveAudit()</image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>ACTION</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="121" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="08/11/2003" version_time="46710" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="1000708141.09" record_version_obj="4314.7692" version_number_seq="3" secondary_key_value="Comments" import_version_number_seq="3"><menu_item_obj>1000708141.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>Co&amp;mments...</menu_item_label>
<menu_item_description>Comments...</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Comments</tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>Comments</menu_item_reference>
<propagate_links></propagate_links>
<security_token>Comments</security_token>
<item_toolbar_label>Co&amp;mments...</item_toolbar_label>
<image1_up_filename>ry/img/afcomment.gif</image1_up_filename>
<image1_down_filename>ry/img/toolclip.bmp,32,48,16,16</image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename>ry/img/afcomtick.gif</image2_up_filename>
<image2_down_filename>ry/img/toolclip.bmp,48,48,16,16</image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>PUBLISH</item_select_type>
<item_select_action>toolbar</item_select_action>
<item_link>toolbar-Target</item_link>
<item_select_parameter>Comments</item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule> RecordState=RecordAvailable</enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule>hasActiveComments()</image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>ACTION</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="122" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1000708142.09" record_version_obj="3000058505.09" version_number_seq="1.09" secondary_key_value="History" import_version_number_seq="1.09"><menu_item_obj>1000708142.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>Status &amp;History...</menu_item_label>
<menu_item_description>Status History...</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Status History</tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>History</menu_item_reference>
<propagate_links></propagate_links>
<security_token>Status History</security_token>
<item_toolbar_label>Status &amp;History...</item_toolbar_label>
<image1_up_filename>ry/img/gs_status.gif</image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>PUBLISH</item_select_type>
<item_select_action>toolbar</item_select_action>
<item_link>toolbar-target</item_link>
<item_select_parameter>History</item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>ACTION</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="123" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="08/11/2003" version_time="46711" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="1000708143.09" record_version_obj="442.5498" version_number_seq="4" secondary_key_value="ReLogon" import_version_number_seq="4"><menu_item_obj>1000708143.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>Re-&amp;Logon...</menu_item_label>
<menu_item_description>Re-Logon...</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Re-Logon</tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>ReLogon</menu_item_reference>
<propagate_links></propagate_links>
<security_token>Re-Logon</security_token>
<item_toolbar_label>Re-&amp;Logon...</item_toolbar_label>
<image1_up_filename>ry/img/gs_pword.gif</image1_up_filename>
<image1_down_filename>ry/img/toolclip.bmp,32,32,16,16</image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>PUBLISH</item_select_type>
<item_select_action>toolbar</item_select_action>
<item_link>containertoolbar-target</item_link>
<item_select_parameter>Re-Logon</item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>ACTION</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="124" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="08/11/2003" version_time="46711" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="1000708144.09" record_version_obj="443.5498" version_number_seq="4" secondary_key_value="Suspend" import_version_number_seq="4"><menu_item_obj>1000708144.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;Suspend...</menu_item_label>
<menu_item_description>Suspend...</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Suspend</tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>Suspend</menu_item_reference>
<propagate_links></propagate_links>
<security_token>Suspend</security_token>
<item_toolbar_label>&amp;Suspend...</item_toolbar_label>
<image1_up_filename>ry/img/gs_secure.gif</image1_up_filename>
<image1_down_filename>ry/img/toolclip.bmp,48,32,16,16</image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>PUBLISH</item_select_type>
<item_select_action>toolbar</item_select_action>
<item_link>containertoolbar-target</item_link>
<item_select_parameter>Suspend</item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>ACTION</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="125" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="05/15/2003" version_time="60017" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="1000708145.09" record_version_obj="439.5498" version_number_seq="1.5498" secondary_key_value="Translate" import_version_number_seq="1.5498"><menu_item_obj>1000708145.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;Translate...</menu_item_label>
<menu_item_description>Translate...</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Translate</tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>Translate</menu_item_reference>
<propagate_links></propagate_links>
<security_token>Translate</security_token>
<item_toolbar_label>&amp;Translate...</item_toolbar_label>
<image1_up_filename>ry/img/gs_lang.gif</image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>PUBLISH</item_select_type>
<item_select_action>toolbar</item_select_action>
<item_link>containertoolbar-target</item_link>
<item_select_parameter>Translate</item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>ACTION</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="126" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="08/11/2003" version_time="46711" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="1000708146.09" record_version_obj="446.5498" version_number_seq="4" secondary_key_value="Notepad" import_version_number_seq="4"><menu_item_obj>1000708146.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;Notepad...</menu_item_label>
<menu_item_description>Notepad...</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Notepad</tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>Notepad</menu_item_reference>
<propagate_links></propagate_links>
<security_token>Notepad</security_token>
<item_toolbar_label>&amp;Notepad...</item_toolbar_label>
<image1_up_filename>ry/img/afnotepad.gif</image1_up_filename>
<image1_down_filename>ry/img/toolclip.bmp,96,48,16,16</image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>PUBLISH</item_select_type>
<item_select_action>toolbar</item_select_action>
<item_link>containertoolbar-target</item_link>
<item_select_parameter>Notepad</item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>ACTION</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="127" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="08/11/2003" version_time="46711" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="1000708147.09" record_version_obj="447.5498" version_number_seq="4" secondary_key_value="Wordpad" import_version_number_seq="4"><menu_item_obj>1000708147.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;Wordpad...</menu_item_label>
<menu_item_description>Wordpad...</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Wordpad</tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>Wordpad</menu_item_reference>
<propagate_links></propagate_links>
<security_token>Wordpad</security_token>
<item_toolbar_label>&amp;Wordpad...</item_toolbar_label>
<image1_up_filename>ry/img/afwordpad.gif</image1_up_filename>
<image1_down_filename>ry/img/toolclip.bmp,112,48,16,16</image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>PUBLISH</item_select_type>
<item_select_action>toolbar</item_select_action>
<item_link>containertoolbar-target</item_link>
<item_select_parameter>Wordpad</item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>ACTION</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="128" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="08/11/2003" version_time="46710" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="1000708148.09" record_version_obj="425.5498" version_number_seq="4" secondary_key_value="Calculator" import_version_number_seq="4"><menu_item_obj>1000708148.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;Calculator...</menu_item_label>
<menu_item_description>Calculator...</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Calculator</tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>Calculator</menu_item_reference>
<propagate_links></propagate_links>
<security_token>Calculator</security_token>
<item_toolbar_label>&amp;Calculator...</item_toolbar_label>
<image1_up_filename>ry/img/afcalc.gif</image1_up_filename>
<image1_down_filename>ry/img/toolclip.bmp,0,64,16,16</image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>PUBLISH</item_select_type>
<item_select_action>toolbar</item_select_action>
<item_link>containertoolbar-target</item_link>
<item_select_parameter>Calculator</item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>ACTION</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="129" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="08/11/2003" version_time="46711" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="1000708149.09" record_version_obj="448.5498" version_number_seq="4" secondary_key_value="Word" import_version_number_seq="4"><menu_item_obj>1000708149.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;Word...</menu_item_label>
<menu_item_description>Word...</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Word</tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>Word</menu_item_reference>
<propagate_links></propagate_links>
<security_token>Word</security_token>
<item_toolbar_label>&amp;Word...</item_toolbar_label>
<image1_up_filename>ry/img/afword.gif</image1_up_filename>
<image1_down_filename>ry/img/toolclip.bmp,48,64,16,16</image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>PUBLISH</item_select_type>
<item_select_action>toolbar</item_select_action>
<item_link>containertoolbar-target</item_link>
<item_select_parameter>Word</item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>ACTION</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="130" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="08/11/2003" version_time="46710" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="1000708150.09" record_version_obj="431.5498" version_number_seq="4" secondary_key_value="Excel" import_version_number_seq="4"><menu_item_obj>1000708150.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>E&amp;xcel...</menu_item_label>
<menu_item_description>Excel...</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Excel</tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>Excel</menu_item_reference>
<propagate_links></propagate_links>
<security_token>Excel</security_token>
<item_toolbar_label>E&amp;xcel...</item_toolbar_label>
<image1_up_filename>ry/img/afexcel.gif</image1_up_filename>
<image1_down_filename>ry/img/toolclip.bmp,64,64,16,16</image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>PUBLISH</item_select_type>
<item_select_action>toolbar</item_select_action>
<item_link>containertoolbar-target</item_link>
<item_select_parameter>Excel</item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>ACTION</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="131" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="08/11/2003" version_time="46711" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="1000708151.09" record_version_obj="2684.5498" version_number_seq="4" secondary_key_value="Status" import_version_number_seq="4"><menu_item_obj>1000708151.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;Status...</menu_item_label>
<menu_item_description>Status...</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Status</tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>Status</menu_item_reference>
<propagate_links></propagate_links>
<security_token>Status</security_token>
<item_toolbar_label>&amp;Status...</item_toolbar_label>
<image1_up_filename>ry/img/afstatus.gif</image1_up_filename>
<image1_down_filename>ry/img/toolclip.bmp,64,48,16,16</image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>PUBLISH</item_select_type>
<item_select_action>toolbar</item_select_action>
<item_link>toolbar-target</item_link>
<item_select_parameter>Status</item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule>RecordState=RecordAvailable</enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>ACTION</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="132" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1000708152.09" record_version_obj="3000058506.09" version_number_seq="1.09" secondary_key_value="Lookup" import_version_number_seq="1.09"><menu_item_obj>1000708152.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;Lookup...</menu_item_label>
<menu_item_description>Lookup...</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Lookup</tooltip_text>
<shortcut_key>F4</shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>Lookup</menu_item_reference>
<propagate_links></propagate_links>
<security_token>Lookup</security_token>
<item_toolbar_label>&amp;Lookup...</item_toolbar_label>
<image1_up_filename>ry/img/aflkfind.gif</image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>PUBLISH</item_select_type>
<item_select_action>toolbar</item_select_action>
<item_link>toolbar-target</item_link>
<item_select_parameter>Lookup</item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>ACTION</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="133" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="08/11/2003" version_time="46711" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="1000708153.09" record_version_obj="441.5498" version_number_seq="4" secondary_key_value="Spell" import_version_number_seq="4"><menu_item_obj>1000708153.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;Spell</menu_item_label>
<menu_item_description>Spell</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Spell</tooltip_text>
<shortcut_key>F7</shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>Spell</menu_item_reference>
<propagate_links></propagate_links>
<security_token>Spell</security_token>
<item_toolbar_label>&amp;Spell</item_toolbar_label>
<image1_up_filename>ry/img/afspell.gif</image1_up_filename>
<image1_down_filename>ry/img/toolclip.bmp,64,32,16,16</image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>PUBLISH</item_select_type>
<item_select_action>toolbar</item_select_action>
<item_link>containertoolbar-target</item_link>
<item_select_parameter>Spell</item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>ACTION</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="134" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="08/11/2003" version_time="46710" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="1000708154.09" record_version_obj="430.5498" version_number_seq="4" secondary_key_value="Email" import_version_number_seq="4"><menu_item_obj>1000708154.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;Email...</menu_item_label>
<menu_item_description>Email...</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Email</tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>Email</menu_item_reference>
<propagate_links></propagate_links>
<security_token>Email</security_token>
<item_toolbar_label>&amp;Email...</item_toolbar_label>
<image1_up_filename>ry/img/afmail.gif</image1_up_filename>
<image1_down_filename>ry/img/toolclip.bmp,16,64,16,16</image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>PUBLISH</item_select_type>
<item_select_action>toolbar</item_select_action>
<item_link>containertoolbar-target</item_link>
<item_select_parameter>Email</item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>ACTION</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="135" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="08/11/2003" version_time="46711" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="1000708155.09" record_version_obj="438.5498" version_number_seq="4" secondary_key_value="Internet" import_version_number_seq="4"><menu_item_obj>1000708155.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;Internet...</menu_item_label>
<menu_item_description>Internet...</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Internet</tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>Internet</menu_item_reference>
<propagate_links></propagate_links>
<security_token>Internet</security_token>
<item_toolbar_label>&amp;Internet...</item_toolbar_label>
<image1_up_filename>ry/img/afinternet.gif</image1_up_filename>
<image1_down_filename>ry/img/toolclip.bmp,32,64,16,16</image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>PUBLISH</item_select_type>
<item_select_action>toolbar</item_select_action>
<item_link>containertoolbar-target</item_link>
<item_select_parameter>Internet</item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>ACTION</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="136" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="05/15/2003" version_time="60016" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="1000708157.09" record_version_obj="429.5498" version_number_seq="1.5498" secondary_key_value="FilterClear" import_version_number_seq="1.5498"><menu_item_obj>1000708157.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>C&amp;lear</menu_item_label>
<menu_item_description>Clear</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key>ALT-L</shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>FilterClear</menu_item_reference>
<propagate_links></propagate_links>
<security_token>Clear</security_token>
<item_toolbar_label>C&amp;lear</item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>PUBLISH</item_select_type>
<item_select_action>toolbar</item_select_action>
<item_link>containertoolbar-target</item_link>
<item_select_parameter>Clear</item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>ACTION</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="137" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1000708163.09" record_version_obj="3000058507.09" version_number_seq="1.09" secondary_key_value="MultiWindow" import_version_number_seq="1.09"><menu_item_obj>1000708163.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;Multiple Windows</menu_item_label>
<menu_item_description>Multiple Windows</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>MultiWindow</menu_item_reference>
<propagate_links></propagate_links>
<security_token>MultiWindow</security_token>
<item_toolbar_label>&amp;Multiple Windows</item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>PROPERTY</item_select_type>
<item_select_action>MultiInstanceActivated</item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>ACTION</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="138" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="05/15/2003" version_time="60017" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="1000708164.09" record_version_obj="444.5498" version_number_seq="1.5498" secondary_key_value="Pref" import_version_number_seq="1.5498"><menu_item_obj>1000708164.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;Preferences...</menu_item_label>
<menu_item_description>Preferences...</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>Pref</menu_item_reference>
<propagate_links></propagate_links>
<security_token>Preferences</security_token>
<item_toolbar_label>&amp;Preferences...</item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>PUBLISH</item_select_type>
<item_select_action>toolbar</item_select_action>
<item_link>containertoolbar-target</item_link>
<item_select_parameter>Preferences</item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>ACTION</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="139" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="06/05/2003" version_time="61320" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="1000708165.09" record_version_obj="445.5498" version_number_seq="2.766" secondary_key_value="PrintSetup" import_version_number_seq="2.766"><menu_item_obj>1000708165.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>P&amp;rint Setup...</menu_item_label>
<menu_item_description>Print Setup...</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>PrintSetup</menu_item_reference>
<propagate_links></propagate_links>
<security_token>PrintSetup</security_token>
<item_toolbar_label>Print &amp;Setup...</item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>PUBLISH</item_select_type>
<item_select_action>toolbar</item_select_action>
<item_link>containertoolbar-target</item_link>
<item_select_parameter>PrintSetup</item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>ACTION</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="140" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1000708166.09" record_version_obj="3000058508.09" version_number_seq="1.09" secondary_key_value="Print" import_version_number_seq="1.09"><menu_item_obj>1000708166.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;Print</menu_item_label>
<menu_item_description>Print</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>Print</menu_item_reference>
<propagate_links></propagate_links>
<security_token>Print</security_token>
<item_toolbar_label>&amp;Print</item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>PUBLISH</item_select_type>
<item_select_action>toolbar</item_select_action>
<item_link>toolbar-target</item_link>
<item_select_parameter>Print</item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>ACTION</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="141" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="05/15/2003" version_time="60016" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="1000708167.09" record_version_obj="437.5498" version_number_seq="1.5498" secondary_key_value="HelpTopics" import_version_number_seq="1.5498"><menu_item_obj>1000708167.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;Help Topics</menu_item_label>
<menu_item_description>Help Topics</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Help topics</tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>HelpTopics</menu_item_reference>
<propagate_links></propagate_links>
<security_token>HelpTopics</security_token>
<item_toolbar_label>&amp;Help Topics</item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>PUBLISH</item_select_type>
<item_select_action>toolbar</item_select_action>
<item_link>containertoolbar-target</item_link>
<item_select_parameter>HelpTopics</item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>ACTION</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="142" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="05/15/2003" version_time="60016" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="1000708168.09" record_version_obj="581.5498" version_number_seq="1.5498" secondary_key_value="HelpContents" import_version_number_seq="1.5498"><menu_item_obj>1000708168.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>Help &amp;Contents</menu_item_label>
<menu_item_description>Help Contents</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Help contents</tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>HelpContents</menu_item_reference>
<propagate_links></propagate_links>
<security_token>HelpContents</security_token>
<item_toolbar_label>Help &amp;Contents</item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>PUBLISH</item_select_type>
<item_select_action>toolbar</item_select_action>
<item_link>containertoolbar-target</item_link>
<item_select_parameter>HelpContents</item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>ACTION</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="143" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="05/15/2003" version_time="60016" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="1000708169.09" record_version_obj="582.5498" version_number_seq="1.5498" secondary_key_value="HelpHelp" import_version_number_seq="1.5498"><menu_item_obj>1000708169.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>How to &amp;Use Help</menu_item_label>
<menu_item_description>How to Use Help</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>HelpHelp</menu_item_reference>
<propagate_links></propagate_links>
<security_token>HelpHelp</security_token>
<item_toolbar_label>How to &amp;Use Help</item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>PUBLISH</item_select_type>
<item_select_action>toolbar</item_select_action>
<item_link>containertoolbar-target</item_link>
<item_select_parameter>HelpHelp</item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>ACTION</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="144" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="05/15/2003" version_time="60016" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="1000708170.09" record_version_obj="436.5498" version_number_seq="1.5498" secondary_key_value="HelpAbout" import_version_number_seq="1.5498"><menu_item_obj>1000708170.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>Help &amp;About</menu_item_label>
<menu_item_description>Help About</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>HelpAbout</menu_item_reference>
<propagate_links></propagate_links>
<security_token>HelpAbout</security_token>
<item_toolbar_label>Help &amp;About</item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>PUBLISH</item_select_type>
<item_select_action>toolbar</item_select_action>
<item_link>containertoolbar-target</item_link>
<item_select_parameter>HelpAbout</item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>ACTION</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="145" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="08/11/2003" version_time="46711" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="1000708172.09" record_version_obj="4290.66" version_number_seq="6" secondary_key_value="FolderUpdate" import_version_number_seq="6"><menu_item_obj>1000708172.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>1000709351.09</item_category_obj>
<menu_item_label>&amp;Modify record</menu_item_label>
<menu_item_description>Modify record</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Modify record</tooltip_text>
<shortcut_key>ALT-M</shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>FolderUpdate</menu_item_reference>
<propagate_links></propagate_links>
<security_token>Modify</security_token>
<item_toolbar_label>&amp;Modify</item_toolbar_label>
<image1_up_filename>ry/img/update.gif</image1_up_filename>
<image1_down_filename>ry/img/toolclip.bmp,48,0,16,16</image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>PUBLISH</item_select_type>
<item_select_action>updateMode</item_select_action>
<item_link></item_link>
<item_select_parameter>Modify</item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule>RecordState=RecordAvailable and ObjectMode=view and Editable</enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>ACTION</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="146" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="08/11/2003" version_time="46711" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="1000708177.09" record_version_obj="4292.66" version_number_seq="8" secondary_key_value="FolderView" import_version_number_seq="8"><menu_item_obj>1000708177.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>1000709351.09</item_category_obj>
<menu_item_label>&amp;View record</menu_item_label>
<menu_item_description>View record</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>View record</tooltip_text>
<shortcut_key>ALT-V</shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>FolderView</menu_item_reference>
<propagate_links></propagate_links>
<security_token>View</security_token>
<item_toolbar_label>&amp;View</item_toolbar_label>
<image1_up_filename>ry/img/viewrecord.gif</image1_up_filename>
<image1_down_filename>ry/img/toolclip.bmp,64,0,16,16</image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>PUBLISH</item_select_type>
<item_select_action>updateMode</item_select_action>
<item_link></item_link>
<item_select_parameter>View</item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule>ObjectMode=Modify and Editable and newRecord=no and DataModified=no</enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>ACTION</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="147" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1000708178.09" record_version_obj="3000058509.09" version_number_seq="1.09" secondary_key_value="FolderUndo" import_version_number_seq="1.09"><menu_item_obj>1000708178.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;Undo</menu_item_label>
<menu_item_description>Undo</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Undo transaction</tooltip_text>
<shortcut_key>ALT-U</shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>FolderUndo</menu_item_reference>
<propagate_links></propagate_links>
<security_token>Undo</security_token>
<item_toolbar_label>&amp;Undo</item_toolbar_label>
<image1_up_filename>ry/img/rollback.gif</image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>PUBLISH</item_select_type>
<item_select_action>undoTransaction</item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>ACTION</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="148" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1000708188.09" record_version_obj="3000058510.09" version_number_seq="1.09" secondary_key_value="wbProduct" import_version_number_seq="1.09"><menu_item_obj>1000708188.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label></menu_item_label>
<menu_item_description>wbProduct</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>wbProduct</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label></item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename>/af/wimg/a_032_trans.gif</image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type></item_select_type>
<item_select_action>fnHelpOpen(&quot;/af/hlp/astraweb/htm/helpcontents1.htm&quot;)</item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>ACTION</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="149" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1000708189.09" record_version_obj="3000058511.09" version_number_seq="1.09" secondary_key_value="wbMenu" import_version_number_seq="1.09"><menu_item_obj>1000708189.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label></menu_item_label>
<menu_item_description>Menu</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Toggle the menu frame on/off</tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>wbMenu</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label>Menu</item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename>/af/wimg/pnl_in_menu.gif</image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type></item_select_type>
<item_select_action>fnMenuToggle()</item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>ACTION</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="150" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1000708190.09" record_version_obj="3000058512.09" version_number_seq="1.09" secondary_key_value="wbInfo" import_version_number_seq="1.09"><menu_item_obj>1000708190.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label></menu_item_label>
<menu_item_description>Info</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Toggle the info frame on/off</tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>wbInfo</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label>Info</item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename>/af/wimg/pnl_in_align.gif</image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type></item_select_type>
<item_select_action>fnInfoToggle()</item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>ACTION</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="151" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1000708191.09" record_version_obj="3000058513.09" version_number_seq="1.09" secondary_key_value="wbCalculator" import_version_number_seq="1.09"><menu_item_obj>1000708191.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label></menu_item_label>
<menu_item_description>Calculator</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Pop-up calculator</tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>wbCalculator</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label>Calculator</item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename>/af/wimg/pnl_in_help.gif</image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type></item_select_type>
<item_select_action>fnFilterToggle()</item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>ACTION</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="152" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1000708192.09" record_version_obj="3000058514.09" version_number_seq="1.09" secondary_key_value="wbFilter" import_version_number_seq="1.09"><menu_item_obj>1000708192.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label></menu_item_label>
<menu_item_description>Filter</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Toggle to view/hide filter criteria</tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>wbFilter</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label>Filter</item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename>/af/wimg/pnl_in_filter_off.gif</image1_insensitive_filename>
<image2_up_filename>/af/wimg/pnl_ac_filter_on.gif</image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename>/af/wimg/pnl_in_filter_on.gif</image2_insensitive_filename>
<item_select_type></item_select_type>
<item_select_action>fnFilterToggle()</item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>ACTION</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="153" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1000708193.09" record_version_obj="3000058515.09" version_number_seq="1.09" secondary_key_value="wbRefresh" import_version_number_seq="1.09"><menu_item_obj>1000708193.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label></menu_item_label>
<menu_item_description>Refresh</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Refresh the browser</tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>wbRefresh</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label>Refresh</item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename>/af/wimg/pnl_in_refresh.gif</image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type></item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>ACTION</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="154" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1000708194.09" record_version_obj="3000058516.09" version_number_seq="1.09" secondary_key_value="wbFirst" import_version_number_seq="1.09"><menu_item_obj>1000708194.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label></menu_item_label>
<menu_item_description>First</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>First record</tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>wbFirst</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label>First</item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename>/af/wimg/pnl_in_first.gif</image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type></item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>ACTION</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="155" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1000708195.09" record_version_obj="3000058517.09" version_number_seq="1.09" secondary_key_value="wbPrevious" import_version_number_seq="1.09"><menu_item_obj>1000708195.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label></menu_item_label>
<menu_item_description>Prev</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Previous record</tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>wbPrevious</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label>Prev</item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename>/af/wimg/pnl_in_prev.gif</image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type></item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>ACTION</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="156" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1000708196.09" record_version_obj="3000058518.09" version_number_seq="1.09" secondary_key_value="wbNext" import_version_number_seq="1.09"><menu_item_obj>1000708196.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label></menu_item_label>
<menu_item_description>Next</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Next record</tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>wbNext</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label>Next</item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename>/af/wimg/pnl_in_next.gif</image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type></item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>ACTION</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="157" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1000708197.09" record_version_obj="3000058519.09" version_number_seq="1.09" secondary_key_value="wbLast" import_version_number_seq="1.09"><menu_item_obj>1000708197.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label></menu_item_label>
<menu_item_description>Last</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Last record</tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>wbLast</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label>Last</item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename>/af/wimg/pnl_in_last.gif</image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type></item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>ACTION</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="158" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1000708198.09" record_version_obj="3000058520.09" version_number_seq="1.09" secondary_key_value="wbAdd" import_version_number_seq="1.09"><menu_item_obj>1000708198.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label></menu_item_label>
<menu_item_description>Add</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Add a record</tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>wbAdd</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label>Add</item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename>/af/wimg/pnl_in_add.gif</image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type></item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>ACTION</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="159" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1000708199.09" record_version_obj="3000058521.09" version_number_seq="1.09" secondary_key_value="wbDelete" import_version_number_seq="1.09"><menu_item_obj>1000708199.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label></menu_item_label>
<menu_item_description>Delete</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Delete the record</tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>wbDelete</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label>Delete</item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename>/af/wimg/pnl_in_del.gif</image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type></item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>ACTION</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="160" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1000708200.09" record_version_obj="3000058522.09" version_number_seq="1.09" secondary_key_value="wbCopy" import_version_number_seq="1.09"><menu_item_obj>1000708200.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label></menu_item_label>
<menu_item_description>Copy</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Copy the record</tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>wbCopy</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label>Copy</item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename>/af/wimg/pnl_in_copy.gif</image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type></item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>ACTION</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="161" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1000708201.09" record_version_obj="3000058523.09" version_number_seq="1.09" secondary_key_value="wbModify" import_version_number_seq="1.09"><menu_item_obj>1000708201.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label></menu_item_label>
<menu_item_description>Modify</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Modify the record</tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>wbModify</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label>Modify</item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename>/af/wimg/pnl_in_mod.gif</image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type></item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>ACTION</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="162" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1000708202.09" record_version_obj="3000058524.09" version_number_seq="1.09" secondary_key_value="wbView" import_version_number_seq="1.09"><menu_item_obj>1000708202.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label></menu_item_label>
<menu_item_description>View</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>View the record</tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>wbView</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label>View</item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename>/af/wimg/pnl_in_view.gif</image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type></item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>ACTION</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="163" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1000708203.09" record_version_obj="3000058525.09" version_number_seq="1.09" secondary_key_value="wbOK" import_version_number_seq="1.09"><menu_item_obj>1000708203.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label></menu_item_label>
<menu_item_description>OK</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Accept this action</tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>wbOK</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label>OK</item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename>/af/wimg/pnl_in_ok.gif</image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type></item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>ACTION</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="164" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1000708204.09" record_version_obj="3000058526.09" version_number_seq="1.09" secondary_key_value="wbCancel" import_version_number_seq="1.09"><menu_item_obj>1000708204.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label></menu_item_label>
<menu_item_description>Cancel</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Cancel this action</tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>wbCancel</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label>Cancel</item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename>/af/wimg/pnl_in_cancel.gif</image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type></item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>ACTION</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="165" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1000708205.09" record_version_obj="3000058527.09" version_number_seq="1.09" secondary_key_value="wbApply" import_version_number_seq="1.09"><menu_item_obj>1000708205.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label></menu_item_label>
<menu_item_description>Apply</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Apply updates</tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>wbApply</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label>Apply</item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename>/af/wimg/pnl_in_commit.gif</image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type></item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>ACTION</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="166" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1000708206.09" record_version_obj="3000058528.09" version_number_seq="1.09" secondary_key_value="wbLookupOK" import_version_number_seq="1.09"><menu_item_obj>1000708206.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label></menu_item_label>
<menu_item_description>OK</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Accept this action</tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>wbLookupOK</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label>OK</item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename>/af/wimg/pnl_in_ok.gif</image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type></item_select_type>
<item_select_action>fnReturnLookup()</item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>ACTION</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="167" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1000708207.09" record_version_obj="3000058529.09" version_number_seq="1.09" secondary_key_value="wbLookupCancel" import_version_number_seq="1.09"><menu_item_obj>1000708207.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label></menu_item_label>
<menu_item_description>Cancel</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Cancel this action</tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>wbLookupCancel</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label>Cancel</item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename>/af/wimg/pnl_in_cancel.gif</image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type></item_select_type>
<item_select_action>parent.window.close()</item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>ACTION</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="168" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1000708208.09" record_version_obj="3000058530.09" version_number_seq="1.09" secondary_key_value="wbBack" import_version_number_seq="1.09"><menu_item_obj>1000708208.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label></menu_item_label>
<menu_item_description>Back</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Back</tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>wbBack</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label>Back</item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename>/af/wimg/pnl_in_back.gif</image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type></item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>ACTION</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="169" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1000708209.09" record_version_obj="3000058531.09" version_number_seq="1.09" secondary_key_value="wbExit" import_version_number_seq="1.09"><menu_item_obj>1000708209.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label></menu_item_label>
<menu_item_description>Exit</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Exit</tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>wbExit</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label>Exit</item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename>/af/wimg/pnl_in_exit.gif</image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type></item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>ACTION</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="170" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1000708210.09" record_version_obj="3000058532.09" version_number_seq="1.09" secondary_key_value="wbHelp" import_version_number_seq="1.09"><menu_item_obj>1000708210.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label></menu_item_label>
<menu_item_description>Help</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Debugging information</tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>wbHelp</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label>Help</item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename>/af/wimg/pnl_in_help2.gif</image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type></item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>ACTION</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="171" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1000708213.09" record_version_obj="3000058533.09" version_number_seq="1.09" secondary_key_value="File" import_version_number_seq="1.09"><menu_item_obj>1000708213.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>1000709352.09</item_category_obj>
<menu_item_label>&amp;File</menu_item_label>
<menu_item_description>File</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>File</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label>&amp;File</item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type></item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Label</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="172" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1000708216.09" record_version_obj="3000058534.09" version_number_seq="1.09" secondary_key_value="Navigation" import_version_number_seq="1.09"><menu_item_obj>1000708216.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>1000709352.09</item_category_obj>
<menu_item_label>Navigation</menu_item_label>
<menu_item_description>Navigation</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>Navigation</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label>Navigation</item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type></item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Label</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="173" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1000708221.09" record_version_obj="3000058535.09" version_number_seq="1.09" secondary_key_value="Help" import_version_number_seq="1.09"><menu_item_obj>1000708221.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>1000709352.09</item_category_obj>
<menu_item_label>&amp;Help</menu_item_label>
<menu_item_description>Help</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>Help</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label>&amp;Help</item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type></item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Label</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="174" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1000708229.09" record_version_obj="3000058536.09" version_number_seq="1.09" secondary_key_value="Window" import_version_number_seq="1.09"><menu_item_obj>1000708229.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>1000709352.09</item_category_obj>
<menu_item_label>&amp;Window</menu_item_label>
<menu_item_description>Window</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>Window</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label>&amp;Window</item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type></item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Label</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="175" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1000708231.09" record_version_obj="3000058537.09" version_number_seq="1.09" secondary_key_value="Desktop" import_version_number_seq="1.09"><menu_item_obj>1000708231.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>1000709352.09</item_category_obj>
<menu_item_label>Desktop</menu_item_label>
<menu_item_description>Desktop</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>Desktop</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label>Desktop</item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type></item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Label</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="176" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1000709147.09" record_version_obj="3000058538.09" version_number_seq="1.09" secondary_key_value="DynamicMenu" import_version_number_seq="1.09"><menu_item_obj>1000709147.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>1000709352.09</item_category_obj>
<menu_item_label></menu_item_label>
<menu_item_description>DynamicMenu</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>DynamicMenu</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label></item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type></item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Placeholder</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="177" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1003576820" record_version_obj="3000058539.09" version_number_seq="1.09" secondary_key_value="Options" import_version_number_seq="1.09"><menu_item_obj>1003576820</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>1000709352.09</item_category_obj>
<menu_item_label>&amp;Options</menu_item_label>
<menu_item_description>Options</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>Options</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label></item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type></item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Label</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="178" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1003576821" record_version_obj="3000058540.09" version_number_seq="1.09" secondary_key_value="ASMNU_00001653" import_version_number_seq="1.09"><menu_item_obj>1003576821</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>1003574037</object_obj>
<instance_attribute_obj>1003576832</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;Attribute Control</menu_item_label>
<menu_item_description>Attribute Control</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>ASMNU_00001653</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label></item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>Launch</item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="179" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1003606204" record_version_obj="3000058541.09" version_number_seq="1.09" secondary_key_value="ASMNU_00001659" import_version_number_seq="1.09"><menu_item_obj>1003606204</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;Generate Dynamic Object</menu_item_label>
<menu_item_description>Generate Dynamic Object</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>ASMNU_00001659</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label></item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>Publish</item_select_type>
<item_select_action>generate</item_select_action>
<item_link></item_link>
<item_select_parameter>menc</item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="180" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1003606412" record_version_obj="3000058542.09" version_number_seq="1.09" secondary_key_value="ASMNU_00001660" import_version_number_seq="1.09"><menu_item_obj>1003606412</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;Generate Dynamic Object</menu_item_label>
<menu_item_description>Generate Dynamic Object</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>ASMNU_00001660</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label></item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>Publish</item_select_type>
<item_select_action>generate</item_select_action>
<item_link></item_link>
<item_select_parameter>objc</item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="181" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1003606415" record_version_obj="3000058543.09" version_number_seq="1.09" secondary_key_value="ASMNU_00001662" import_version_number_seq="1.09"><menu_item_obj>1003606415</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;Generate Dynamic Object</menu_item_label>
<menu_item_description>Generate Dynamic Object</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>ASMNU_00001662</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label></item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>Publish</item_select_type>
<item_select_action>generate</item_select_action>
<item_link></item_link>
<item_select_parameter>fold</item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="182" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1003606418" record_version_obj="3000058544.09" version_number_seq="1.09" secondary_key_value="ASMNU_00001664" import_version_number_seq="1.09"><menu_item_obj>1003606418</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;Generate Dynamic Object</menu_item_label>
<menu_item_description>Generate Dynamic Object</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>ASMNU_00001664</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label></item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>Publish</item_select_type>
<item_select_action>generate</item_select_action>
<item_link></item_link>
<item_select_parameter>brow</item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="183" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1003606421" record_version_obj="3000058545.09" version_number_seq="1.09" secondary_key_value="ASMNU_00001666" import_version_number_seq="1.09"><menu_item_obj>1003606421</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;Generate Dynamic Object</menu_item_label>
<menu_item_description>Generate Dynamic Object</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>ASMNU_00001666</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label></item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>Publish</item_select_type>
<item_select_action>generate</item_select_action>
<item_link></item_link>
<item_select_parameter>view</item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="184" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1003606423" record_version_obj="3000058546.09" version_number_seq="1.09" secondary_key_value="ASMNU_00001668" import_version_number_seq="1.09"><menu_item_obj>1003606423</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>1000709352.09</item_category_obj>
<menu_item_label>&amp;Wizards</menu_item_label>
<menu_item_description>Wizards</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>ASMNU_00001668</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label></item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type></item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Label</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="185" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1003699856" record_version_obj="3000058547.09" version_number_seq="1.09" secondary_key_value="ASMNU_00001874" import_version_number_seq="1.09"><menu_item_obj>1003699856</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>1000709352.09</item_category_obj>
<menu_item_label>&amp;ProTools</menu_item_label>
<menu_item_description>ProTools</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>yes</under_development>
<menu_item_reference>ASMNU_00001874</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label></item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type></item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Label</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="186" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1003700024" record_version_obj="3000058548.09" version_number_seq="1.09" secondary_key_value="ASMNU_00001880" import_version_number_seq="1.09"><menu_item_obj>1003700024</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>1003699895</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>Se&amp;rvice Parameters</menu_item_label>
<menu_item_description>Service Parameters</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>ASMNU_00001880</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label></item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>Launch</item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="187" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1003700025" record_version_obj="3000058549.09" version_number_seq="1.09" secondary_key_value="ASMNU_00001881" import_version_number_seq="1.09"><menu_item_obj>1003700025</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>1003699903</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;Walvis Viewer</menu_item_label>
<menu_item_description>Walvis Viewer</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>ASMNU_00001881</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label></item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>Launch</item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="188" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1003700026" record_version_obj="3000058550.09" version_number_seq="1.09" secondary_key_value="ASMNU_00001882" import_version_number_seq="1.09"><menu_item_obj>1003700026</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>1003699904</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;Widget Attributes</menu_item_label>
<menu_item_description>Widget Attributes</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>ASMNU_00001882</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label></item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>Launch</item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="189" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1003700174" record_version_obj="3000058551.09" version_number_seq="1.09" secondary_key_value="RULE" import_version_number_seq="1.09"><menu_item_obj>1003700174</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label></menu_item_label>
<menu_item_description></menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>yes</under_development>
<menu_item_reference>RULE</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label></item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type></item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Separator</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="190" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1003700292" record_version_obj="3000058552.09" version_number_seq="1.09" secondary_key_value="ASMNU_00001886" import_version_number_seq="1.09"><menu_item_obj>1003700292</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>1003500211</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;Connection Status</menu_item_label>
<menu_item_description>Connection Status</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>ASMNU_00001886</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label></item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>Launch</item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="191" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1003764285" record_version_obj="3000058553.09" version_number_seq="1.09" secondary_key_value="ASMNU_00002051" import_version_number_seq="1.09"><menu_item_obj>1003764285</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>1000709352.09</item_category_obj>
<menu_item_label>&amp;Objects</menu_item_label>
<menu_item_description>Objects</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>ASMNU_00002051</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label></item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type></item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Label</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="192" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="09/04/2002" version_time="56962" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="1003764286" record_version_obj="2000000940.28" version_number_seq="1.28" secondary_key_value="ASMNU_00002044" import_version_number_seq="1.28"><menu_item_obj>1003764286</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>2000000876.28</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>Object &amp;Type Control</menu_item_label>
<menu_item_description>Object Type Control</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>ASMNU_00002044</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label></item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>Launch</item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="193" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1003764342" record_version_obj="3000058554.09" version_number_seq="1.09" secondary_key_value="ASMNU_00002054" import_version_number_seq="1.09"><menu_item_obj>1003764342</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>1000709352.09</item_category_obj>
<menu_item_label>&amp;Attributes</menu_item_label>
<menu_item_description>Attributes</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>ASMNU_00002054</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label></item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type></item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Label</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="194" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1003764344" record_version_obj="3000058555.09" version_number_seq="1.09" secondary_key_value="ASMNU_00002053" import_version_number_seq="1.09"><menu_item_obj>1003764344</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>1004926880</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>Attribute &amp;Group Control</menu_item_label>
<menu_item_description>Attribute Group Control</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>ASMNU_00002053</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label></item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>Launch</item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="195" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="03/11/2003" version_time="53148" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="1003764377" record_version_obj="36847.48" version_number_seq="1.09" secondary_key_value="ASMNU_00002055" import_version_number_seq="1.09"><menu_item_obj>1003764377</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>1003574037</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;Attribute Control</menu_item_label>
<menu_item_description>Attribute Control</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>ASMNU_00002055</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label></item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>Launch</item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="196" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1003765182" record_version_obj="3000058556.09" version_number_seq="1.09" secondary_key_value="ASMNU_00002056" import_version_number_seq="1.09"><menu_item_obj>1003765182</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>1003764966</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>Attribute &amp;Value</menu_item_label>
<menu_item_description>Attribute Value</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>ASMNU_00002056</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label></item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>Launch</item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="197" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1003765394" record_version_obj="3000058557.09" version_number_seq="1.09" secondary_key_value="ASMNU_00002057" import_version_number_seq="1.09"><menu_item_obj>1003765394</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>1003764966</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>Attribute &amp;Value Control</menu_item_label>
<menu_item_description>Attribute Value Control</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>ASMNU_00002057</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label></item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>Launch</item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="198" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1003766393" record_version_obj="3000058558.09" version_number_seq="1.09" secondary_key_value="ASMNU_00002062" import_version_number_seq="1.09"><menu_item_obj>1003766393</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>1000709352.09</item_category_obj>
<menu_item_label>&amp;Toolbars</menu_item_label>
<menu_item_description>Toolbars</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>ASMNU_00002062</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label></item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type></item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Label</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="199" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1003767061" record_version_obj="3000058559.09" version_number_seq="1.09" secondary_key_value="ASMNU_00002063" import_version_number_seq="1.09"><menu_item_obj>1003767061</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>1003766846</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;SmartLink Type Control</menu_item_label>
<menu_item_description>Smartlink Type Control</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>ASMNU_00002063</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label></item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>Launch</item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="200" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1003767455" record_version_obj="3000058560.09" version_number_seq="1.09" secondary_key_value="ASMNU_00002064" import_version_number_seq="1.09"><menu_item_obj>1003767455</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>1003767209</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;Layout Control</menu_item_label>
<menu_item_description>Layout Control</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>ASMNU_00002064</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label></item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>Launch</item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="201" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="09/26/2002" version_time="48039" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="1003897390" record_version_obj="3000031137.09" version_number_seq="2.09" secondary_key_value="ASMNU_00002123" import_version_number_seq="2.09"><menu_item_obj>1003897390</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>1003599905</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;Development</menu_item_label>
<menu_item_description>Development</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>yes</under_development>
<menu_item_reference>ASMNU_00002123</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label>&amp;Development</item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>Launch</item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="202" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="09/26/2002" version_time="48024" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="1004820209.09" record_version_obj="3000031136.09" version_number_seq="2.09" secondary_key_value="ASMNU_00005000" import_version_number_seq="2.09"><menu_item_obj>1004820209.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>1004820128.09</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;Administration</menu_item_label>
<menu_item_description>Administration</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>ASMNU_00005000</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label>&amp;Administration</item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>Launch</item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="203" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1004918450.09" record_version_obj="3000058561.09" version_number_seq="1.09" secondary_key_value="ICF_00000042" import_version_number_seq="1.09"><menu_item_obj>1004918450.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>1000709352.09</item_category_obj>
<menu_item_label>&amp;Print</menu_item_label>
<menu_item_description>Print</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>ICF_00000042</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label></item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type></item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Label</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="204" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1004918452.09" record_version_obj="3000058562.09" version_number_seq="1.09" secondary_key_value="ICF_00000043" import_version_number_seq="1.09"><menu_item_obj>1004918452.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>1000709352.09</item_category_obj>
<menu_item_label>Se&amp;curity</menu_item_label>
<menu_item_description>Security</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>ICF_00000043</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label></item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type></item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Label</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="205" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1004918453.09" record_version_obj="3000058563.09" version_number_seq="1.09" secondary_key_value="ICF_00000044" import_version_number_seq="1.09"><menu_item_obj>1004918453.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>1000709352.09</item_category_obj>
<menu_item_label>&amp;Session</menu_item_label>
<menu_item_description>Session</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>ICF_00000044</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label></item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type></item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Label</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="206" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1004918454.09" record_version_obj="3000058564.09" version_number_seq="1.09" secondary_key_value="ICF_00000045" import_version_number_seq="1.09"><menu_item_obj>1004918454.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>1000709352.09</item_category_obj>
<menu_item_label>S&amp;ystem</menu_item_label>
<menu_item_description>System</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>ICF_00000045</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label></item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type></item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Label</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="207" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1004918456.09" record_version_obj="3000058565.09" version_number_seq="1.09" secondary_key_value="ICF_00000047" import_version_number_seq="1.09"><menu_item_obj>1004918456.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>1000709352.09</item_category_obj>
<menu_item_label>&amp;Menu</menu_item_label>
<menu_item_description>Menu</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>ICF_00000047</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label></item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type></item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Label</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="208" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1004918457.09" record_version_obj="3000058566.09" version_number_seq="1.09" secondary_key_value="ICF_00000048" import_version_number_seq="1.09"><menu_item_obj>1004918457.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>1000709352.09</item_category_obj>
<menu_item_label>&amp;Application</menu_item_label>
<menu_item_description>Application</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>ICF_00000048</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label></item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type></item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Label</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="209" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1004918462.09" record_version_obj="3000058567.09" version_number_seq="1.09" secondary_key_value="ICF_00000049" import_version_number_seq="1.09"><menu_item_obj>1004918462.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>1004841449.09</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;Language Control</menu_item_label>
<menu_item_description>Language Control</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>ICF_00000049</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label></item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>Launch</item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="210" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="06/05/2003" version_time="61319" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="1004918463.09" record_version_obj="17830.0766" version_number_seq="1.766" secondary_key_value="ICF_00000051" import_version_number_seq="1.766"><menu_item_obj>1004918463.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>1004825327.09</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>T&amp;ranslation Control</menu_item_label>
<menu_item_description>Translation Control</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>ICF_00000051</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label></item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>Launch</item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="211" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="06/05/2003" version_time="61319" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="1004918464.09" record_version_obj="17831.0766" version_number_seq="1.766" secondary_key_value="ICF_00000052" import_version_number_seq="1.766"><menu_item_obj>1004918464.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>1004830963.09</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>Categ&amp;ory Control</menu_item_label>
<menu_item_description>Category Control</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>ICF_00000052</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label></item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>Launch</item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="212" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1004918470.09" record_version_obj="3000058568.09" version_number_seq="1.09" secondary_key_value="ICF_00000054" import_version_number_seq="1.09"><menu_item_obj>1004918470.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>1004834694.09</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;Status Control</menu_item_label>
<menu_item_description>Status Control</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>ICF_00000054</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label></item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>Launch</item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="213" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1004918487.09" record_version_obj="3000058569.09" version_number_seq="1.09" secondary_key_value="ICF_00000055" import_version_number_seq="1.09"><menu_item_obj>1004918487.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>1004833700.09</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;Multi Media Type Control</menu_item_label>
<menu_item_description>Multi Media Type Control</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>ICF_00000055</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label></item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>Launch</item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="214" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="09/03/2003" version_time="54284" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="1004918490.09" record_version_obj="1000009902.81" version_number_seq="3.81" secondary_key_value="ICF_00000057" import_version_number_seq="3.81"><menu_item_obj>1004918490.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>1004858519.09</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;Product Control</menu_item_label>
<menu_item_description>Product control</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>ICF_00000057</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label></item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>Launch</item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="215" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1004918497.09" record_version_obj="3000058571.09" version_number_seq="1.09" secondary_key_value="ICF_00000059" import_version_number_seq="1.09"><menu_item_obj>1004918497.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>1004886561.09</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;Instance Attribute Control</menu_item_label>
<menu_item_description>Instance Attribute Control</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>ICF_00000059</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label></item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>Launch</item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="216" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1004918498.09" record_version_obj="3000058572.09" version_number_seq="1.09" secondary_key_value="ICF_00000060" import_version_number_seq="1.09"><menu_item_obj>1004918498.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>1005124320.101</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>Rep&amp;ository Maintenance</menu_item_label>
<menu_item_description>Repository Maintenance</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>ICF_00000060</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label>Rep&amp;ository Maintenance</item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>Launch</item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="217" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1004918500.09" record_version_obj="3000058573.09" version_number_seq="1.09" secondary_key_value="ICF_00000061" import_version_number_seq="1.09"><menu_item_obj>1004918500.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>1007600006.09</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;Toolbar and Menu Designer</menu_item_label>
<menu_item_description>Toolbar and Menu Designer</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>ICF_00000061</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label>&amp;Toolbar and Menu Designer</item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>Launch</item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="218" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="05/20/2003" version_time="56647" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="1004918504.09" record_version_obj="125393.9875" version_number_seq="1.9875" secondary_key_value="ICF_00000062" import_version_number_seq="1.9875"><menu_item_obj>1004918504.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>123406.9875</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;Security Control</menu_item_label>
<menu_item_description>Security Control</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>ICF_00000062</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label></item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>LAUNCH</item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="219" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1004918505.09" record_version_obj="3000058574.09" version_number_seq="1.09" secondary_key_value="ICF_00000063" import_version_number_seq="1.09"><menu_item_obj>1004918505.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>1004869204.09</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;Login Company Control</menu_item_label>
<menu_item_description>Login Company Control</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>ICF_00000063</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label></item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>Launch</item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="220" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1004918857.09" record_version_obj="3000058575.09" version_number_seq="1.09" secondary_key_value="ICF_00000064" import_version_number_seq="1.09"><menu_item_obj>1004918857.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>1004833889.09</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;Token Security Control</menu_item_label>
<menu_item_description>Token Security Control</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>ICF_00000064</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label></item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>Launch</item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="221" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1004918858.09" record_version_obj="3000058576.09" version_number_seq="1.09" secondary_key_value="ICF_00000065" import_version_number_seq="1.09"><menu_item_obj>1004918858.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>1004824412.09</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;Field Security Control</menu_item_label>
<menu_item_description>Field Security Control</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>ICF_00000065</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label></item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>Launch</item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="222" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1004918859.09" record_version_obj="3000058577.09" version_number_seq="1.09" secondary_key_value="ICF_00000066" import_version_number_seq="1.09"><menu_item_obj>1004918859.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>1004830432.09</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;Range Security Control</menu_item_label>
<menu_item_description>Range Security Control</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>ICF_00000066</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label></item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>Launch</item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="223" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1004918860.09" record_version_obj="3000058578.09" version_number_seq="1.09" secondary_key_value="ICF_00000067" import_version_number_seq="1.09"><menu_item_obj>1004918860.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>1004832784.09</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>User &amp;Category Control</menu_item_label>
<menu_item_description>User Category Control</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>ICF_00000067</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label></item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>Launch</item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="224" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1004918861.09" record_version_obj="3000058579.09" version_number_seq="1.09" secondary_key_value="ICF_00000068" import_version_number_seq="1.09"><menu_item_obj>1004918861.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>1004826830.09</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;User Control</menu_item_label>
<menu_item_description>User Control</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>ICF_00000068</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label></item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>Launch</item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="225" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1004918863.09" record_version_obj="3000058580.09" version_number_seq="1.09" secondary_key_value="ICF_00000069" import_version_number_seq="1.09"><menu_item_obj>1004918863.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>1004898185.09</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;Manager Type Control</menu_item_label>
<menu_item_description>Manager Type Control</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>ICF_00000069</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label></item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>Launch</item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="226" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="05/29/2003" version_time="60572" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="1004918881.09" record_version_obj="725000008034.5566" version_number_seq="1.5566" secondary_key_value="ICF_00000070" import_version_number_seq="1.5566"><menu_item_obj>1004918881.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>725000006790.5566</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>Session &amp;Type Control</menu_item_label>
<menu_item_description>Session Type Control</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>ICF_00000070</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label></item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>Launch</item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="227" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1004918886.09" record_version_obj="3000058581.09" version_number_seq="1.09" secondary_key_value="ICF_00000071" import_version_number_seq="1.09"><menu_item_obj>1004918886.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>1004898584.09</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>Ser&amp;vice Type Control</menu_item_label>
<menu_item_description>Service Type Control</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>ICF_00000071</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label></item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>Launch</item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="228" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1004919021.09" record_version_obj="3000058582.09" version_number_seq="1.09" secondary_key_value="ICF_00000073" import_version_number_seq="1.09"><menu_item_obj>1004919021.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>1004914475.09</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;Session Property Control</menu_item_label>
<menu_item_description>Session Property Control</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>ICF_00000073</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label></item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>Launch</item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="229" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1004919024.09" record_version_obj="3000058583.09" version_number_seq="1.09" secondary_key_value="ICF_00000076" import_version_number_seq="1.09"><menu_item_obj>1004919024.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>1000709352.09</item_category_obj>
<menu_item_label>&amp;Transaction</menu_item_label>
<menu_item_description>Transaction</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>ICF_00000076</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label></item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type></item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Label</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="230" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1004919027.09" record_version_obj="3000058584.09" version_number_seq="1.09" secondary_key_value="ICF_00000077" import_version_number_seq="1.09"><menu_item_obj>1004919027.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>1004900936.09</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;Logical Service Control</menu_item_label>
<menu_item_description>Logical Service Control</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>ICF_00000077</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label></item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>Launch</item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="231" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1004919028.09" record_version_obj="3000058585.09" version_number_seq="1.09" secondary_key_value="ICF_00000078" import_version_number_seq="1.09"><menu_item_obj>1004919028.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>1004904130.09</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;Physical Service Control</menu_item_label>
<menu_item_description>Physical Service Control</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>ICF_00000078</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label></item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>Launch</item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="232" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="03/20/2003" version_time="56945" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="1004919029.09" record_version_obj="14144.0766" version_number_seq="1.09" secondary_key_value="ICF_00000079" import_version_number_seq="1.09"><menu_item_obj>1004919029.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>1004894575.09</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>P&amp;rofile Control</menu_item_label>
<menu_item_description>Profile Control</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>ICF_00000079</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label></item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>Launch</item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="233" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1004919030.09" record_version_obj="3000058586.09" version_number_seq="1.09" secondary_key_value="ICF_00000080" import_version_number_seq="1.09"><menu_item_obj>1004919030.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>1004883883.09</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>Security &amp;Allocation</menu_item_label>
<menu_item_description>Security Allocation</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>ICF_00000080</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label></item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>Launch</item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="234" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1004919032.09" record_version_obj="3000058587.09" version_number_seq="1.09" secondary_key_value="ICF_00000082" import_version_number_seq="1.09"><menu_item_obj>1004919032.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>1004837652.09</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;Context Help Control</menu_item_label>
<menu_item_description>Context Help Control</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>ICF_00000082</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label></item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>Launch</item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="235" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1004919033.09" record_version_obj="3000058588.09" version_number_seq="1.09" secondary_key_value="ICF_00000083" import_version_number_seq="1.09"><menu_item_obj>1004919033.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>1004859335.09</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;Message Control</menu_item_label>
<menu_item_description>Message Control</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>ICF_00000083</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label></item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>Launch</item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="236" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1004919035.09" record_version_obj="3000058589.09" version_number_seq="1.09" secondary_key_value="ICF_00000085" import_version_number_seq="1.09"><menu_item_obj>1004919035.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>1004870754.09</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>Se&amp;quence Control</menu_item_label>
<menu_item_description>Sequence Control</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>ICF_00000085</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label></item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>Launch</item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="237" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="12/05/2002" version_time="35429" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="1004919036.09" record_version_obj="2000001423.28" version_number_seq="1.09" secondary_key_value="ICF_00000086" import_version_number_seq="1.09"><menu_item_obj>1004919036.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>33166.9875</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>Entity &amp;Import</menu_item_label>
<menu_item_description>Entity Import</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>ICF_00000086</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label></item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>LAUNCH</item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="238" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1004919037.09" record_version_obj="3000058590.09" version_number_seq="1.09" secondary_key_value="ICF_00000087" import_version_number_seq="1.09"><menu_item_obj>1004919037.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>1004888356.09</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>E&amp;ntity Control</menu_item_label>
<menu_item_description>Entity Control</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>ICF_00000087</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label></item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>Launch</item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="239" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1004928876.09" record_version_obj="3000058591.09" version_number_seq="1.09" secondary_key_value="ICF_00000091" import_version_number_seq="1.09"><menu_item_obj>1004928876.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>1000709352.09</item_category_obj>
<menu_item_label>&amp;Options</menu_item_label>
<menu_item_description>Options</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>ICF_00000091</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label></item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type></item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Label</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="240" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1004928877.09" record_version_obj="3000058592.09" version_number_seq="1.09" secondary_key_value="ICF_00000092" import_version_number_seq="1.09"><menu_item_obj>1004928877.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>1004928233.09</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;Record Version Control</menu_item_label>
<menu_item_description>Record Version Control</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>ICF_00000092</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label></item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>Launch</item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="241" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="09/04/2002" version_time="56971" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="1004935154.09" record_version_obj="1000002636.48" version_number_seq="1.48" secondary_key_value="ICF_00000099" import_version_number_seq="1.48"><menu_item_obj>1004935154.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>1000000943.48</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;Object Generator</menu_item_label>
<menu_item_description>Object Generator</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>ICF_00000099</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label>&amp;Object Generator</item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>Launch</item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="242" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1004935510.09" record_version_obj="3000058593.09" version_number_seq="1.09" secondary_key_value="ICF_00000102" import_version_number_seq="1.09"><menu_item_obj>1004935510.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>1000709352.09</item_category_obj>
<menu_item_label>&amp;Deployment</menu_item_label>
<menu_item_description>Deployment</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>ICF_00000102</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label></item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type></item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Label</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="243" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1004935511.09" record_version_obj="3000058594.09" version_number_seq="1.09" secondary_key_value="ICF_00000103" import_version_number_seq="1.09"><menu_item_obj>1004935511.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>1004929092.09</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;Deployment Dataset Control</menu_item_label>
<menu_item_description>Deployment Dataset Control</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>ICF_00000103</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label></item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>Launch</item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="244" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1004956227.09" record_version_obj="3000058595.09" version_number_seq="1.09" secondary_key_value="ICF_00000104" import_version_number_seq="1.09"><menu_item_obj>1004956227.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>1000709352.09</item_category_obj>
<menu_item_label>&amp;Option</menu_item_label>
<menu_item_description>Option</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>ICF_00000104</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label></item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type></item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Label</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="245" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="09/14/2003" version_time="75724" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="1004956228.09" record_version_obj="908839.24" version_number_seq="1.24" secondary_key_value="ICF_00000105" import_version_number_seq="1.24"><menu_item_obj>1004956228.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>908832.24</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;Generate Configuration File</menu_item_label>
<menu_item_description>Generate Configuration File</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>ICF_00000105</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label></item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>Launch</item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="246" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1005016817" record_version_obj="3000058596.09" version_number_seq="1.09" secondary_key_value="ASMNU_00002447" import_version_number_seq="1.09"><menu_item_obj>1005016817</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>1000709352.09</item_category_obj>
<menu_item_label>&amp;Setup</menu_item_label>
<menu_item_description>Setup</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>ASMNU_00002447</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label></item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type></item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Label</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="247" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1005016818" record_version_obj="3000058597.09" version_number_seq="1.09" secondary_key_value="ASMNU_00002448" import_version_number_seq="1.09"><menu_item_obj>1005016818</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>1000709352.09</item_category_obj>
<menu_item_label>&amp;Maintenance</menu_item_label>
<menu_item_description>Maintenance</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>ASMNU_00002448</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label></item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type></item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Label</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="248" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1005080150.09" record_version_obj="3000058598.09" version_number_seq="1.09" secondary_key_value="ICF_00000120" import_version_number_seq="1.09"><menu_item_obj>1005080150.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>1005080059.09</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>Audit Control</menu_item_label>
<menu_item_description>Audit Control</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>ICF_00000120</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label></item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>Launch</item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="249" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="06/05/2003" version_time="61319" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="1005099733.101" record_version_obj="49211.9875" version_number_seq="3.766" secondary_key_value="ICF_00000123" import_version_number_seq="3.766"><menu_item_obj>1005099733.101</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>2000060478.28</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;Dynamic TreeView Builder</menu_item_label>
<menu_item_description>Dynamic TreeView Builder</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>ICF_00000123</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label>Dynamic &amp;TreeView Builder</item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>Launch</item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="250" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1005100066.101" record_version_obj="3000058599.09" version_number_seq="1.09" secondary_key_value="ICF_00000125" import_version_number_seq="1.09"><menu_item_obj>1005100066.101</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;Generate Dynamic Object</menu_item_label>
<menu_item_description>Generate Dynamic Object</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>ICF_00000125</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label></item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>Publish</item_select_type>
<item_select_action>generate</item_select_action>
<item_link></item_link>
<item_select_parameter>TreeView</item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="251" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="06/05/2003" version_time="61320" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="1005100206.101" record_version_obj="123376.9875" version_number_seq="2.766" secondary_key_value="ICF_00000126" import_version_number_seq="2.766"><menu_item_obj>1005100206.101</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>1005100861.101</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>Tree &amp;Node Control</menu_item_label>
<menu_item_description>Tree Node Control</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>ICF_00000126</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label></item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>Launch</item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="252" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1007600001.09" record_version_obj="3000058600.09" version_number_seq="1.09" secondary_key_value="ICF_00000151" import_version_number_seq="1.09"><menu_item_obj>1007600001.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>1000709352.09</item_category_obj>
<menu_item_label>&amp;Build</menu_item_label>
<menu_item_description>Build</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>ICF_00000151</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label></item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type></item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Label</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="253" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="03/21/2003" version_time="36394" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="1007600002.09" record_version_obj="3000005139.09" version_number_seq="4.09" secondary_key_value="ICF_00000152" import_version_number_seq="4.09"><menu_item_obj>1007600002.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>1000000943.48</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>Object &amp;Generator</menu_item_label>
<menu_item_description>Object &amp;Generator</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>ICF_00000152</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label></item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>LAUNCH</item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="254" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="09/04/2002" version_time="56973" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="1007600005.09" record_version_obj="15552.5053" version_number_seq="1.5053" secondary_key_value="ICF_00000153" import_version_number_seq="1.5053"><menu_item_obj>1007600005.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>22.5053</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;Container Builder</menu_item_label>
<menu_item_description>Container Builder</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>ICF_00000153</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label>&amp;Container Builder</item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>LAUNCH</item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="255" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="10/02/2003" version_time="49460" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMI" key_field_value="1007600007.09" record_version_obj="3000058601.09" version_number_seq="1.09" secondary_key_value="ICF_00000156" import_version_number_seq="1.09"><menu_item_obj>1007600007.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>1005124320.101</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>Rep&amp;ository Maintenance</menu_item_label>
<menu_item_description>Repository Maintenance</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_reference>ICF_00000156</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label>Rep&amp;ository Maintenance</item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>LAUNCH</item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="256" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="06/05/2003" version_time="61320" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="1007600009.09" record_version_obj="2000001304.28" version_number_seq="2.766" secondary_key_value="ICF_00000157" import_version_number_seq="2.766"><menu_item_obj>1007600009.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>2000001278.28</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;Set Site Number</menu_item_label>
<menu_item_description>Set Site Number</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>ICF_00000157</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label></item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>LAUNCH</item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="257" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="09/12/2003" version_time="34384" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="1007600013.09" record_version_obj="4619.5498" version_number_seq="3.5498" secondary_key_value="ICF_00000158" import_version_number_seq="3.5498"><menu_item_obj>1007600013.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>4979.5498</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>Dataset &amp;Export</menu_item_label>
<menu_item_description>Dataset &amp;Export</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>ICF_00000158</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label></item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>LAUNCH</item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="258" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="09/04/2002" version_time="56974" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="1007600014.09" record_version_obj="2000001204.28" version_number_seq="1.28" secondary_key_value="ICF_00000159" import_version_number_seq="1.28"><menu_item_obj>1007600014.09</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>2000001186.28</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>Dataset &amp;Import</menu_item_label>
<menu_item_description>Dataset &amp;Import</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>ICF_00000159</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label></item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>LAUNCH</item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="259" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="06/05/2003" version_time="61320" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="2000001159.28" record_version_obj="2000001160.28" version_number_seq="2.766" secondary_key_value="multi_media_img" import_version_number_seq="2.766"><menu_item_obj>2000001159.28</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>1005117525.101</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>Multi M&amp;edia Image Control</menu_item_label>
<menu_item_description>Multi Media Image Control</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>multi_media_img</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label>Multi Media Image Control</item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>LAUNCH</item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="260" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="05/15/2003" version_time="60015" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="725000000744.5566" record_version_obj="725000000745.5566" version_number_seq="5.5498" secondary_key_value="cbEditCustomObj" import_version_number_seq="5.5498"><menu_item_obj>725000000744.5566</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>Edit &amp;Custom SmartObject...</menu_item_label>
<menu_item_description>Edit Custom SmartObject Procedure</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Edit Custom SmartObject</tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>cbEditCustomObj</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label>Edit Custom SmartObject...</item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>PUBLISH</item_select_type>
<item_select_action>toolbar</item_select_action>
<item_link>containertoolbar-target</item_link>
<item_select_parameter>SuperProcedure</item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style>Icon only</item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="261" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="05/15/2003" version_time="60016" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="725000000749.5566" record_version_obj="725000000750.5566" version_number_seq="5.5498" secondary_key_value="cbGenDataLogic" import_version_number_seq="5.5498"><menu_item_obj>725000000749.5566</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;Generate DataLogicProcedure</menu_item_label>
<menu_item_description>Generate Data Logic Procedure</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Edit Data Logic Procedure</tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>cbGenDataLogic</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label>Generate DataLogicProcedure</item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>PUBLISH</item_select_type>
<item_select_action>toolbar</item_select_action>
<item_link>containertoolbar-target</item_link>
<item_select_parameter>GenDataLogicProcedure</item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style>Icon only</item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="262" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="05/15/2003" version_time="60015" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="725000000753.5566" record_version_obj="725000000754.5566" version_number_seq="5.5498" secondary_key_value="cbEditDataLogic" import_version_number_seq="5.5498"><menu_item_obj>725000000753.5566</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>Edit &amp;DataLogicProcedure...</menu_item_label>
<menu_item_description>Edit Data Logic Procedure</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Edit Data Logic Procedure</tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>cbEditDataLogic</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label>Edit DataLogicProcedure...</item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>PUBLISH</item_select_type>
<item_select_action>toolbar</item_select_action>
<item_link>containertoolbar-target</item_link>
<item_select_parameter>DataLogicProcedure</item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style>Icon only</item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="263" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="03/17/2003" version_time="41318" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="725000000757.5566" record_version_obj="725000000758.5566" version_number_seq="1.09" secondary_key_value="cbProceduresLbl" import_version_number_seq="1.09"><menu_item_obj>725000000757.5566</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>0</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>1000709352.09</item_category_obj>
<menu_item_label>&amp;Procedures</menu_item_label>
<menu_item_description>CBuilder Procedure Features Label</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>cbProceduresLbl</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label></item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type></item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Label</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="264" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="06/17/2003" version_time="58281" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="725000009401.5566" record_version_obj="725000009402.5566" version_number_seq="2.5566" secondary_key_value="filterset" import_version_number_seq="2.5566"><menu_item_obj>725000009401.5566</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>725000006184.5566</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>Filter Set Maintenance</menu_item_label>
<menu_item_description>Filter Set Maintenance</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text>Filter Set Maintenance</tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>filterset</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label>Filter Set Maintenance</item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>LAUNCH</item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="265" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="06/05/2003" version_time="61320" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="3000000000203.6893" record_version_obj="3000000000204.6893" version_number_seq="2.766" secondary_key_value="neil" import_version_number_seq="2.766"><menu_item_obj>3000000000203.6893</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>3000000000121.6893</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>Currenc&amp;y Control</menu_item_label>
<menu_item_description>Currency Control</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>neil</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label>&amp;Currencies</item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>LAUNCH</item_select_type>
<item_select_action></item_select_action>
<item_link>?</item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="266" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="03/24/2003" version_time="39245" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="8100000012143.18" record_version_obj="8100000012144.18" version_number_seq="1.09" secondary_key_value="081_00000081" import_version_number_seq="1.09"><menu_item_obj>8100000012143.18</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>8100000011863.18</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>&amp;Replace Object Instances</menu_item_label>
<menu_item_description>Replace Object Instances</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>081_00000081</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label>&amp;Replace Object Instances</item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>LAUNCH</item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="267" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="06/05/2003" version_time="61320" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="30000000001004.6893" record_version_obj="30000000001005.6893" version_number_seq="2.766" secondary_key_value="neil_01" import_version_number_seq="2.766"><menu_item_obj>30000000001004.6893</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>30000000000026.6893</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>Deploymen&amp;t Destinations</menu_item_label>
<menu_item_description>Deployment Destinations</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>neil_01</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label>&amp;Deployment Destinations</item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>LAUNCH</item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="268" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_item" version_date="09/20/2002" version_time="73503" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmi" key_field_value="30000000001141.6893" record_version_obj="30000000001142.6893" version_number_seq="2.6893" secondary_key_value="neil_02" import_version_number_seq="2.6893"><menu_item_obj>30000000001141.6893</menu_item_obj>
<product_module_obj>0</product_module_obj>
<object_obj>30000000001017.6893</object_obj>
<instance_attribute_obj>0</instance_attribute_obj>
<item_category_obj>0</item_category_obj>
<menu_item_label>Deploy &amp;Static Objects</menu_item_label>
<menu_item_description>Deploy Static Objects</menu_item_description>
<toggle_menu_item>no</toggle_menu_item>
<tooltip_text></tooltip_text>
<shortcut_key></shortcut_key>
<hide_if_disabled>no</hide_if_disabled>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_reference>neil_02</menu_item_reference>
<propagate_links></propagate_links>
<security_token></security_token>
<item_toolbar_label>&amp;Deployment Destinations</item_toolbar_label>
<image1_up_filename></image1_up_filename>
<image1_down_filename></image1_down_filename>
<image1_insensitive_filename></image1_insensitive_filename>
<image2_up_filename></image2_up_filename>
<image2_down_filename></image2_down_filename>
<image2_insensitive_filename></image2_insensitive_filename>
<item_select_type>LAUNCH</item_select_type>
<item_select_action></item_select_action>
<item_link></item_link>
<item_select_parameter></item_select_parameter>
<item_menu_drop></item_menu_drop>
<on_create_publish_event></on_create_publish_event>
<enable_rule></enable_rule>
<disable_rule></disable_rule>
<image_alternate_rule></image_alternate_rule>
<hide_rule></hide_rule>
<item_control_type>Action</item_control_type>
<item_control_style></item_control_style>
<substitute_text_property></substitute_text_property>
<item_narration></item_narration>
<source_language_obj>426</source_language_obj>
</contained_record>
</dataset_transaction>
</dataset_records>
</dataset>