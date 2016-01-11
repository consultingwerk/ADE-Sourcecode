<?xml version="1.0" encoding="utf-8" ?>
<dataset Transactions="27"><dataset_header DisableRI="yes" DatasetObj="1007600192.08" DateFormat="mdy" FullHeader="yes" SCMManaged="no" YearOffset="1950" DatasetCode="GSMMM" NumericFormat="AMERICAN" NumericDecimal="." OriginatingSite="90" NumericSeparator=","><deploy_dataset_obj>1007600192.08</deploy_dataset_obj>
<dataset_code>GSMMM</dataset_code>
<dataset_description>gsm_multi_media - Multi Media</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<deploy_additions_only>no</deploy_additions_only>
<enable_data_versioning>yes</enable_data_versioning>
<deletion_dataset>yes</deletion_dataset>
<dataset_entity><dataset_entity_obj>1007600193.08</dataset_entity_obj>
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
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
<exclude_field_list></exclude_field_list>
<entity_mnemonic_description>gsm_multi_media</entity_mnemonic_description>
<entity_dbname>ICFDB</entity_dbname>
</dataset_entity>
<table_definition><name>gsm_multi_media</name>
<dbname>icfdb</dbname>
<index-1>XIE1gsm_multi_media,0,0,0,category_obj,0,owning_obj,0,multi_media_type_obj,0,creation_date,0</index-1>
<index-2>XIE2gsm_multi_media,0,0,0,physical_file_name,0</index-2>
<index-3>XIE3gsm_multi_media,0,0,0,multi_media_description,0</index-3>
<index-4>XIE4gsm_multi_media,0,0,0,owning_obj,0</index-4>
<index-5>XPKgsm_multi_media,1,1,0,multi_media_obj,0</index-5>
<field><name>multi_media_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Multi media obj</label>
<column-label>Multi media obj</column-label>
</field>
<field><name>category_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Category obj</label>
<column-label>Category obj</column-label>
</field>
<field><name>owning_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Owning obj</label>
<column-label>Owning obj</column-label>
</field>
<field><name>multi_media_type_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Multi media type obj</label>
<column-label>Multi media type obj</column-label>
</field>
<field><name>physical_file_name</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Physical file name</label>
<column-label>Physical file name</column-label>
</field>
<field><name>multi_media_description</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>Multi media description</label>
<column-label>Multi media description</column-label>
</field>
<field><name>creation_date</name>
<data-type>date</data-type>
<extent>0</extent>
<format>99/99/9999</format>
<initial>10/12/2003</initial>
<label>Creation date</label>
<column-label>Creation date</column-label>
</field>
</table_definition>
</dataset_header>
<dataset_records><dataset_transaction TransactionNo="1" TransactionType="DELETION"><contained_record version_date="05/18/2003" version_time="56758" version_user="admin" deletion_flag="yes" entity_mnemonic="gsmmm" key_field_value="124715.9875" record_version_obj="124716.9875" version_number_seq="3.9875" secondary_key_value="124715.9875" import_version_number_seq="3.9875"/>
</dataset_transaction>
<dataset_transaction TransactionNo="2" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_multi_media" version_date="09/30/2002" version_time="23297" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmm" key_field_value="17087.5053" record_version_obj="17088.5053" version_number_seq="3.5053" secondary_key_value="17087.5053" import_version_number_seq="3.5053"><multi_media_obj>17087.5053</multi_media_obj>
<category_obj>1005081017.28</category_obj>
<owning_obj>0</owning_obj>
<multi_media_type_obj>1005100225.101</multi_media_type_obj>
<physical_file_name>ry/img/links16.ico</physical_file_name>
<multi_media_description>Links</multi_media_description>
<creation_date>08/28/01</creation_date>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="3" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_multi_media" version_date="05/19/2003" version_time="54167" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmm" key_field_value="124717.9875" record_version_obj="124718.9875" version_number_seq="3.9875" secondary_key_value="124717.9875" import_version_number_seq="3.9875"><multi_media_obj>124717.9875</multi_media_obj>
<category_obj>1005081017.28</category_obj>
<owning_obj>0</owning_obj>
<multi_media_type_obj>1005100225.101</multi_media_type_obj>
<physical_file_name>ry/img/secgscsc.bmp</physical_file_name>
<multi_media_description>Security Icon</multi_media_description>
<creation_date>05/18/03</creation_date>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="4" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_multi_media" version_date="05/19/2003" version_time="54167" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmm" key_field_value="124719.9875" record_version_obj="124720.9875" version_number_seq="2.9875" secondary_key_value="124719.9875" import_version_number_seq="2.9875"><multi_media_obj>124719.9875</multi_media_obj>
<category_obj>1005081017.28</category_obj>
<owning_obj>0</owning_obj>
<multi_media_type_obj>1005100225.101</multi_media_type_obj>
<physical_file_name>ry/img/secrycso.bmp</physical_file_name>
<multi_media_description>Secured Containers</multi_media_description>
<creation_date>05/18/03</creation_date>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="5" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_multi_media" version_date="05/19/2003" version_time="54167" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmm" key_field_value="124721.9875" record_version_obj="124722.9875" version_number_seq="2.9875" secondary_key_value="124721.9875" import_version_number_seq="2.9875"><multi_media_obj>124721.9875</multi_media_obj>
<category_obj>1005081017.28</category_obj>
<owning_obj>0</owning_obj>
<multi_media_type_obj>1005100225.101</multi_media_type_obj>
<physical_file_name>ry/img/secgsmss.bmp</physical_file_name>
<multi_media_description>Secured Menu Structures</multi_media_description>
<creation_date>05/18/03</creation_date>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="6" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_multi_media" version_date="05/19/2003" version_time="54167" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmm" key_field_value="124723.9875" record_version_obj="124724.9875" version_number_seq="2.9875" secondary_key_value="124723.9875" import_version_number_seq="2.9875"><multi_media_obj>124723.9875</multi_media_obj>
<category_obj>1005081017.28</category_obj>
<owning_obj>0</owning_obj>
<multi_media_type_obj>1005100225.101</multi_media_type_obj>
<physical_file_name>ry/img/secgsmlg.bmp</physical_file_name>
<multi_media_description>Secured Login Companies</multi_media_description>
<creation_date>05/18/03</creation_date>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="7" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_multi_media" version_date="05/19/2003" version_time="54167" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmm" key_field_value="124725.9875" record_version_obj="124726.9875" version_number_seq="2.9875" secondary_key_value="124725.9875" import_version_number_seq="2.9875"><multi_media_obj>124725.9875</multi_media_obj>
<category_obj>1005081017.28</category_obj>
<owning_obj>0</owning_obj>
<multi_media_type_obj>1005100225.101</multi_media_type_obj>
<physical_file_name>ry/img/mntgsmlg.bmp</physical_file_name>
<multi_media_description>Login Company Maintenance</multi_media_description>
<creation_date>05/18/03</creation_date>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="8" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_multi_media" version_date="05/19/2003" version_time="54167" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmm" key_field_value="124727.9875" record_version_obj="124728.9875" version_number_seq="2.9875" secondary_key_value="124727.9875" import_version_number_seq="2.9875"><multi_media_obj>124727.9875</multi_media_obj>
<category_obj>1005081017.28</category_obj>
<owning_obj>0</owning_obj>
<multi_media_type_obj>1005100225.101</multi_media_type_obj>
<physical_file_name>ry/img/secgsmto.bmp</physical_file_name>
<multi_media_description>Secured Actions</multi_media_description>
<creation_date>05/18/03</creation_date>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="9" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_multi_media" version_date="05/19/2003" version_time="54167" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmm" key_field_value="124729.9875" record_version_obj="124730.9875" version_number_seq="2.9875" secondary_key_value="124729.9875" import_version_number_seq="2.9875"><multi_media_obj>124729.9875</multi_media_obj>
<category_obj>1005081017.28</category_obj>
<owning_obj>0</owning_obj>
<multi_media_type_obj>1005100225.101</multi_media_type_obj>
<physical_file_name>ry/img/mntgsmto.bmp</physical_file_name>
<multi_media_description>Action Maintenance</multi_media_description>
<creation_date>05/18/03</creation_date>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="10" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_multi_media" version_date="05/19/2003" version_time="54167" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmm" key_field_value="124731.9875" record_version_obj="124732.9875" version_number_seq="2.9875" secondary_key_value="124731.9875" import_version_number_seq="2.9875"><multi_media_obj>124731.9875</multi_media_obj>
<category_obj>1005081017.28</category_obj>
<owning_obj>0</owning_obj>
<multi_media_type_obj>1005100225.101</multi_media_type_obj>
<physical_file_name>ry/img/mntgsmra.bmp</physical_file_name>
<multi_media_description>Data Range Maintenance</multi_media_description>
<creation_date>05/18/03</creation_date>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="11" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_multi_media" version_date="05/19/2003" version_time="54167" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmm" key_field_value="124733.9875" record_version_obj="124734.9875" version_number_seq="2.9875" secondary_key_value="124733.9875" import_version_number_seq="2.9875"><multi_media_obj>124733.9875</multi_media_obj>
<category_obj>1005081017.28</category_obj>
<owning_obj>0</owning_obj>
<multi_media_type_obj>1005100225.101</multi_media_type_obj>
<physical_file_name>ry/img/mntgsmff.bmp</physical_file_name>
<multi_media_description>Field Maintenance</multi_media_description>
<creation_date>05/18/03</creation_date>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="12" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_multi_media" version_date="05/19/2003" version_time="54167" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmm" key_field_value="124735.9875" record_version_obj="124736.9875" version_number_seq="2.9875" secondary_key_value="124735.9875" import_version_number_seq="2.9875"><multi_media_obj>124735.9875</multi_media_obj>
<category_obj>1005081017.28</category_obj>
<owning_obj>0</owning_obj>
<multi_media_type_obj>1005100225.101</multi_media_type_obj>
<physical_file_name>ry/img/secgsmff.bmp</physical_file_name>
<multi_media_description>Secured Fields</multi_media_description>
<creation_date>05/18/03</creation_date>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="13" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_multi_media" version_date="05/19/2003" version_time="54167" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmm" key_field_value="124737.9875" record_version_obj="124738.9875" version_number_seq="2.9875" secondary_key_value="124737.9875" import_version_number_seq="2.9875"><multi_media_obj>124737.9875</multi_media_obj>
<category_obj>1005081017.28</category_obj>
<owning_obj>0</owning_obj>
<multi_media_type_obj>1005100225.101</multi_media_type_obj>
<physical_file_name>ry/img/secgsmra.bmp</physical_file_name>
<multi_media_description>Secured Data Ranges</multi_media_description>
<creation_date>05/18/03</creation_date>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="14" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_multi_media" version_date="05/19/2003" version_time="54167" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmm" key_field_value="124739.9875" record_version_obj="124740.9875" version_number_seq="2.9875" secondary_key_value="124739.9875" import_version_number_seq="2.9875"><multi_media_obj>124739.9875</multi_media_obj>
<category_obj>1005081017.28</category_obj>
<owning_obj>0</owning_obj>
<multi_media_type_obj>1005100225.101</multi_media_type_obj>
<physical_file_name>ry/img/secdata.bmp</physical_file_name>
<multi_media_description>Secured Data</multi_media_description>
<creation_date>05/18/03</creation_date>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="15" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_multi_media" version_date="05/19/2003" version_time="54167" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmm" key_field_value="124741.9875" record_version_obj="124742.9875" version_number_seq="2.9875" secondary_key_value="124741.9875" import_version_number_seq="2.9875"><multi_media_obj>124741.9875</multi_media_obj>
<category_obj>1005081017.28</category_obj>
<owning_obj>0</owning_obj>
<multi_media_type_obj>1005100225.101</multi_media_type_obj>
<physical_file_name>ry/img/secgsmmi.bmp</physical_file_name>
<multi_media_description>Secured Menu Items</multi_media_description>
<creation_date>05/18/03</creation_date>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="16" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_multi_media" version_date="05/19/2003" version_time="54167" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmm" key_field_value="124747.9875" record_version_obj="124748.9875" version_number_seq="2.9875" secondary_key_value="124747.9875" import_version_number_seq="2.9875"><multi_media_obj>124747.9875</multi_media_obj>
<category_obj>1005081017.28</category_obj>
<owning_obj>0</owning_obj>
<multi_media_type_obj>1005100225.101</multi_media_type_obj>
<physical_file_name>ry/img/secusers.bmp</physical_file_name>
<multi_media_description>User Maintenance</multi_media_description>
<creation_date>05/18/03</creation_date>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="17" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_multi_media" version_date="05/19/2003" version_time="54167" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmm" key_field_value="124749.9875" record_version_obj="124750.9875" version_number_seq="2.9875" secondary_key_value="124749.9875" import_version_number_seq="2.9875"><multi_media_obj>124749.9875</multi_media_obj>
<category_obj>1005081017.28</category_obj>
<owning_obj>0</owning_obj>
<multi_media_type_obj>1005100225.101</multi_media_type_obj>
<physical_file_name>ry/img/secgroups.bmp</physical_file_name>
<multi_media_description>Security Group Maintenance</multi_media_description>
<creation_date>05/18/03</creation_date>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="18" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_multi_media" version_date="09/30/2002" version_time="23297" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmm" key_field_value="1005117654.101" record_version_obj="3000005412.09" version_number_seq="1.09" secondary_key_value="1005117654.101" import_version_number_seq="1.09"><multi_media_obj>1005117654.101</multi_media_obj>
<category_obj>1005081017.28</category_obj>
<owning_obj>0</owning_obj>
<multi_media_type_obj>1005100225.101</multi_media_type_obj>
<physical_file_name>ry/img/treefile.ico</physical_file_name>
<multi_media_description>File Folder (Closed)</multi_media_description>
<creation_date>08/28/01</creation_date>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="19" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_multi_media" version_date="09/30/2002" version_time="23297" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmm" key_field_value="1005117656.101" record_version_obj="3000005413.09" version_number_seq="1.09" secondary_key_value="1005117656.101" import_version_number_seq="1.09"><multi_media_obj>1005117656.101</multi_media_obj>
<category_obj>1005081017.28</category_obj>
<owning_obj>0</owning_obj>
<multi_media_type_obj>1005100225.101</multi_media_type_obj>
<physical_file_name>ry/img/treefils.ico</physical_file_name>
<multi_media_description>File Folder (Open)</multi_media_description>
<creation_date>08/28/01</creation_date>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="20" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_multi_media" version_date="05/29/2003" version_time="60572" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmm" key_field_value="725000006875.5566" record_version_obj="725000006876.5566" version_number_seq="4.5566" secondary_key_value="725000006875.5566" import_version_number_seq="4.5566"><multi_media_obj>725000006875.5566</multi_media_obj>
<category_obj>1005081017.28</category_obj>
<owning_obj>0</owning_obj>
<multi_media_type_obj>1005100225.101</multi_media_type_obj>
<physical_file_name>ry/img/tvservices.bmp</physical_file_name>
<multi_media_description>Session Services</multi_media_description>
<creation_date>08/28/01</creation_date>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="21" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_multi_media" version_date="05/29/2003" version_time="60572" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmm" key_field_value="725000006883.5566" record_version_obj="725000006884.5566" version_number_seq="3.5566" secondary_key_value="725000006883.5566" import_version_number_seq="3.5566"><multi_media_obj>725000006883.5566</multi_media_obj>
<category_obj>1005081017.28</category_obj>
<owning_obj>0</owning_obj>
<multi_media_type_obj>1005100225.101</multi_media_type_obj>
<physical_file_name>ry/img/tvprops.bmp</physical_file_name>
<multi_media_description>Session Properties</multi_media_description>
<creation_date>08/28/01</creation_date>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="22" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_multi_media" version_date="05/29/2003" version_time="60572" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmm" key_field_value="725000006885.5566" record_version_obj="725000006886.5566" version_number_seq="2.5566" secondary_key_value="725000006885.5566" import_version_number_seq="2.5566"><multi_media_obj>725000006885.5566</multi_media_obj>
<category_obj>1005081017.28</category_obj>
<owning_obj>0</owning_obj>
<multi_media_type_obj>1005100225.101</multi_media_type_obj>
<physical_file_name>ry/img/tvpropsfold.bmp</physical_file_name>
<multi_media_description>Session Properties Folder</multi_media_description>
<creation_date>08/28/01</creation_date>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="23" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_multi_media" version_date="05/29/2003" version_time="60572" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmm" key_field_value="725000006887.5566" record_version_obj="725000006888.5566" version_number_seq="2.5566" secondary_key_value="725000006887.5566" import_version_number_seq="2.5566"><multi_media_obj>725000006887.5566</multi_media_obj>
<category_obj>1005081017.28</category_obj>
<owning_obj>0</owning_obj>
<multi_media_type_obj>1005100225.101</multi_media_type_obj>
<physical_file_name>ry/img/tvservicesfold.bmp</physical_file_name>
<multi_media_description>Session Services Folder</multi_media_description>
<creation_date>08/28/01</creation_date>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="24" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_multi_media" version_date="05/29/2003" version_time="60572" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmm" key_field_value="725000006889.5566" record_version_obj="725000006890.5566" version_number_seq="2.5566" secondary_key_value="725000006889.5566" import_version_number_seq="2.5566"><multi_media_obj>725000006889.5566</multi_media_obj>
<category_obj>1005081017.28</category_obj>
<owning_obj>0</owning_obj>
<multi_media_type_obj>1005100225.101</multi_media_type_obj>
<physical_file_name>ry/img/tvmngr.bmp</physical_file_name>
<multi_media_description>Session Managers</multi_media_description>
<creation_date>08/28/01</creation_date>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="25" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_multi_media" version_date="05/29/2003" version_time="60572" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmm" key_field_value="725000006891.5566" record_version_obj="725000006892.5566" version_number_seq="2.5566" secondary_key_value="725000006891.5566" import_version_number_seq="2.5566"><multi_media_obj>725000006891.5566</multi_media_obj>
<category_obj>1005081017.28</category_obj>
<owning_obj>0</owning_obj>
<multi_media_type_obj>1005100225.101</multi_media_type_obj>
<physical_file_name>ry/img/tvmngrfold.bmp</physical_file_name>
<multi_media_description>Session Managers Folder</multi_media_description>
<creation_date>08/28/01</creation_date>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="26" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_multi_media" version_date="05/29/2003" version_time="60572" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmm" key_field_value="725000006893.5566" record_version_obj="725000006894.5566" version_number_seq="2.5566" secondary_key_value="725000006893.5566" import_version_number_seq="2.5566"><multi_media_obj>725000006893.5566</multi_media_obj>
<category_obj>1005081017.28</category_obj>
<owning_obj>0</owning_obj>
<multi_media_type_obj>1005100225.101</multi_media_type_obj>
<physical_file_name>ry/img/tvsessiontype.bmp</physical_file_name>
<multi_media_description>Session Type</multi_media_description>
<creation_date>08/28/01</creation_date>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="27" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_multi_media" version_date="05/29/2003" version_time="60573" version_user="admin" deletion_flag="no" entity_mnemonic="gsmmm" key_field_value="725000006895.5566" record_version_obj="725000006896.5566" version_number_seq="2.5566" secondary_key_value="725000006895.5566" import_version_number_seq="2.5566"><multi_media_obj>725000006895.5566</multi_media_obj>
<category_obj>1005081017.28</category_obj>
<owning_obj>0</owning_obj>
<multi_media_type_obj>1005100225.101</multi_media_type_obj>
<physical_file_name>ry/img/tvsessiontypefold.bmp</physical_file_name>
<multi_media_description>Session Type Folder</multi_media_description>
<creation_date>08/28/01</creation_date>
</contained_record>
</dataset_transaction>
</dataset_records>
</dataset>