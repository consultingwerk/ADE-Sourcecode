<?xml version="1.0" encoding="utf-8" ?>
<dataset Transactions="73"><dataset_header DisableRI="yes" DatasetObj="1007600138.08" DateFormat="mdy" FullHeader="yes" SCMManaged="no" YearOffset="1950" DatasetCode="GSCSP" NumericFormat="AMERICAN" NumericDecimal="." OriginatingSite="90" NumericSeparator=","><deploy_dataset_obj>1007600138.08</deploy_dataset_obj>
<dataset_code>GSCSP</dataset_code>
<dataset_description>gsc_session_property - Session Prop</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<deploy_additions_only>no</deploy_additions_only>
<enable_data_versioning>yes</enable_data_versioning>
<deletion_dataset>yes</deletion_dataset>
<dataset_entity><dataset_entity_obj>1007600139.08</dataset_entity_obj>
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
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
<exclude_field_list>default_property_value,always_used</exclude_field_list>
<entity_mnemonic_description>gsc_session_property</entity_mnemonic_description>
<entity_dbname>ICFDB</entity_dbname>
</dataset_entity>
<table_definition><name>gsc_session_property</name>
<dbname>icfdb</dbname>
<index-1>XAK1gsc_session_property,1,0,0,session_property_name,0</index-1>
<index-2>XPKgsc_session_property,1,1,0,session_property_obj,0</index-2>
<field><name>session_property_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Session property obj</label>
<column-label>Session property obj</column-label>
</field>
<field><name>session_property_name</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Session property name</label>
<column-label>Session property name</column-label>
</field>
<field><name>session_property_description</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Session property description</label>
<column-label>Session property description</column-label>
</field>
<field><name>system_owned</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>System owned</label>
<column-label>System owned</column-label>
</field>
<field><name>default_property_value</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Default property value</label>
<column-label>Default property value</column-label>
</field>
<field><name>always_used</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>Always used</label>
<column-label>Always used</column-label>
</field>
</table_definition>
</dataset_header>
<dataset_records><dataset_transaction TransactionNo="1" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_session_property" version_date="03/06/2003" version_time="65741" version_user="admin" deletion_flag="no" entity_mnemonic="gscsp" key_field_value="1131.7692" record_version_obj="1132.7692" version_number_seq="1.09" secondary_key_value="IDETemplate" import_version_number_seq="1.09"><session_property_obj>1131.7692</session_property_obj>
<session_property_name>IDETemplate</session_property_name>
<session_property_description>Comma delimited list of template objects to load for the appBuilder</session_property_description>
<system_owned>no</system_owned>
<default_property_value>templateContainer,templateSmartObject,templateProcedure,templateWeb</default_property_value>
<always_used>no</always_used>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="2" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_session_property" version_date="03/06/2003" version_time="65741" version_user="admin" deletion_flag="no" entity_mnemonic="gscsp" key_field_value="1133.7692" record_version_obj="1134.7692" version_number_seq="1.09" secondary_key_value="IDEPalette" import_version_number_seq="1.09"><session_property_obj>1133.7692</session_property_obj>
<session_property_name>IDEPalette</session_property_name>
<session_property_description>Comma delimited list of palette objects</session_property_description>
<system_owned>no</system_owned>
<default_property_value></default_property_value>
<always_used>no</always_used>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="3" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_session_property" version_date="09/12/2003" version_time="34373" version_user="admin" deletion_flag="no" entity_mnemonic="gscsp" key_field_value="4622.5498" record_version_obj="4623.5498" version_number_seq="6.5498" secondary_key_value="UseThinRendering" import_version_number_seq="6.5498"><session_property_obj>4622.5498</session_property_obj>
<session_property_name>UseThinRendering</session_property_name>
<session_property_description>Determines whether ThinRenderingProcedure is used to render objects</session_property_description>
<system_owned>yes</system_owned>
<default_property_value>NO</default_property_value>
<always_used>no</always_used>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="4" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_session_property" version_date="09/19/2003" version_time="33915" version_user="admin" deletion_flag="no" entity_mnemonic="gscsp" key_field_value="7002.6893" record_version_obj="7003.6893" version_number_seq="2" secondary_key_value="StartupCacheToolbars" import_version_number_seq="2"><session_property_obj>7002.6893</session_property_obj>
<session_property_name>StartupCacheToolbars</session_property_name>
<session_property_description>Toolbars to cache on client at session startup</session_property_description>
<system_owned>no</system_owned>
<default_property_value></default_property_value>
<always_used>no</always_used>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="5" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_session_property" version_date="09/19/2003" version_time="33915" version_user="admin" deletion_flag="no" entity_mnemonic="gscsp" key_field_value="7004.6893" record_version_obj="7005.6893" version_number_seq="2" secondary_key_value="StartupCacheMenusForObjects" import_version_number_seq="2"><session_property_obj>7004.6893</session_property_obj>
<session_property_name>StartupCacheMenusForObjects</session_property_name>
<session_property_description>Objects to cache menus for at session startup</session_property_description>
<system_owned>no</system_owned>
<default_property_value></default_property_value>
<always_used>no</always_used>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="6" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_session_property" version_date="06/20/2002" version_time="77748" version_user="bgruenba" deletion_flag="no" entity_mnemonic="gscsp" key_field_value="9031.24" record_version_obj="9032.24" version_number_seq="2.24" secondary_key_value="_debug_tools_on" import_version_number_seq="2.24"><session_property_obj>9031.24</session_property_obj>
<session_property_name>_debug_tools_on</session_property_name>
<session_property_description>Switches on special tools in the framework for diagnostics</session_property_description>
<system_owned>yes</system_owned>
<default_property_value>NO</default_property_value>
<always_used>no</always_used>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="7" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_session_property" version_date="06/25/2002" version_time="61276" version_user="admin" deletion_flag="no" entity_mnemonic="gscsp" key_field_value="9033.24" record_version_obj="9034.24" version_number_seq="1.09" secondary_key_value="_framework_directory" import_version_number_seq="1.09"><session_property_obj>9033.24</session_property_obj>
<session_property_name>_framework_directory</session_property_name>
<session_property_description>Directory that the framework is running from</session_property_description>
<system_owned>yes</system_owned>
<default_property_value></default_property_value>
<always_used>no</always_used>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="8" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_session_property" version_date="06/25/2002" version_time="61263" version_user="admin" deletion_flag="no" entity_mnemonic="gscsp" key_field_value="9035.24" record_version_obj="9036.24" version_number_seq="1.09" secondary_key_value="_framework_root_directory" import_version_number_seq="1.09"><session_property_obj>9035.24</session_property_obj>
<session_property_name>_framework_root_directory</session_property_name>
<session_property_description>Framework directory excluding /src, /gui or /tty</session_property_description>
<system_owned>yes</system_owned>
<default_property_value></default_property_value>
<always_used>no</always_used>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="9" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_session_property" version_date="06/25/2002" version_time="61295" version_user="admin" deletion_flag="no" entity_mnemonic="gscsp" key_field_value="9037.24" record_version_obj="9038.24" version_number_seq="1.09" secondary_key_value="_framework_drive_letter" import_version_number_seq="1.09"><session_property_obj>9037.24</session_property_obj>
<session_property_name>_framework_drive_letter</session_property_name>
<session_property_description>Drive letter that framework is running from</session_property_description>
<system_owned>yes</system_owned>
<default_property_value></default_property_value>
<always_used>no</always_used>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="10" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_session_property" version_date="06/20/2002" version_time="77749" version_user="bgruenba" deletion_flag="no" entity_mnemonic="gscsp" key_field_value="9039.24" record_version_obj="9040.24" version_number_seq="2.24" secondary_key_value="_startup_proc" import_version_number_seq="2.24"><session_property_obj>9039.24</session_property_obj>
<session_property_name>_startup_proc</session_property_name>
<session_property_description>Name of procedure used to start Dynamics session</session_property_description>
<system_owned>yes</system_owned>
<default_property_value></default_property_value>
<always_used>no</always_used>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="11" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_session_property" version_date="08/12/2003" version_time="48231" version_user="admin" deletion_flag="no" entity_mnemonic="gscsp" key_field_value="9041.24" record_version_obj="9042.24" version_number_seq="4.24" secondary_key_value="startup_procedure10" import_version_number_seq="4.24"><session_property_obj>9041.24</session_property_obj>
<session_property_name>startup_procedure10</session_property_name>
<session_property_description>Used if more than 1 startup procedure needs to be specified.</session_property_description>
<system_owned>yes</system_owned>
<default_property_value></default_property_value>
<always_used>no</always_used>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="12" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_session_property" version_date="08/12/2003" version_time="48231" version_user="admin" deletion_flag="no" entity_mnemonic="gscsp" key_field_value="9043.24" record_version_obj="9044.24" version_number_seq="4.24" secondary_key_value="startup_procedure20" import_version_number_seq="4.24"><session_property_obj>9043.24</session_property_obj>
<session_property_name>startup_procedure20</session_property_name>
<session_property_description>Used if more than 1 startup procedure needs to be specified.</session_property_description>
<system_owned>no</system_owned>
<default_property_value></default_property_value>
<always_used>no</always_used>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="13" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_session_property" version_date="08/07/2003" version_time="37588" version_user="admin" deletion_flag="no" entity_mnemonic="gscsp" key_field_value="149994.9875" record_version_obj="149995.9875" version_number_seq="2.9875" secondary_key_value="MaxHiddenContainers" import_version_number_seq="2.9875"><session_property_obj>149994.9875</session_property_obj>
<session_property_name>MaxHiddenContainers</session_property_name>
<session_property_description>Maximum number of hidden containers per session</session_property_description>
<system_owned>yes</system_owned>
<default_property_value>10</default_property_value>
<always_used>no</always_used>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="14" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_session_property" version_date="08/12/2003" version_time="48231" version_user="admin" deletion_flag="no" entity_mnemonic="gscsp" key_field_value="902291.24" record_version_obj="902292.24" version_number_seq="2.24" secondary_key_value="bound_icfdb" import_version_number_seq="2.24"><session_property_obj>902291.24</session_property_obj>
<session_property_name>bound_icfdb</session_property_name>
<session_property_description>Indicates whether a session is bound to the repository</session_property_description>
<system_owned>yes</system_owned>
<default_property_value>YES</default_property_value>
<always_used>no</always_used>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="15" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_session_property" version_date="08/12/2003" version_time="48231" version_user="admin" deletion_flag="no" entity_mnemonic="gscsp" key_field_value="902293.24" record_version_obj="902294.24" version_number_seq="3.24" secondary_key_value="StartupCacheClasses" import_version_number_seq="3.24"><session_property_obj>902293.24</session_property_obj>
<session_property_name>StartupCacheClasses</session_property_name>
<session_property_description>Comma-separated list of classes to cache at session startup</session_property_description>
<system_owned>yes</system_owned>
<default_property_value></default_property_value>
<always_used>no</always_used>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="16" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_session_property" version_date="08/12/2003" version_time="48231" version_user="admin" deletion_flag="no" entity_mnemonic="gscsp" key_field_value="902295.24" record_version_obj="902296.24" version_number_seq="4.24" secondary_key_value="StartupCacheEntities" import_version_number_seq="4.24"><session_property_obj>902295.24</session_property_obj>
<session_property_name>StartupCacheEntities</session_property_name>
<session_property_description>Comma-separated list of Entities to cache at startup</session_property_description>
<system_owned>yes</system_owned>
<default_property_value></default_property_value>
<always_used>no</always_used>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="17" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_session_property" version_date="09/22/2003" version_time="61900" version_user="admin" deletion_flag="no" entity_mnemonic="gscsp" key_field_value="909694.24" record_version_obj="909695.24" version_number_seq="2.24" secondary_key_value="configuration_source" import_version_number_seq="2.24"><session_property_obj>909694.24</session_property_obj>
<session_property_name>configuration_source</session_property_name>
<session_property_description>Config Source specifies where and order to get config info from</session_property_description>
<system_owned>yes</system_owned>
<default_property_value>DB</default_property_value>
<always_used>no</always_used>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="18" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_session_property" version_date="09/22/2003" version_time="61902" version_user="admin" deletion_flag="no" entity_mnemonic="gscsp" key_field_value="910727.24" record_version_obj="910728.24" version_number_seq="3.24" secondary_key_value="setup_type" import_version_number_seq="3.24"><session_property_obj>910727.24</session_property_obj>
<session_property_name>setup_type</session_property_name>
<session_property_description>Setup Type to be run. Used with DCU.</session_property_description>
<system_owned>no</system_owned>
<default_property_value></default_property_value>
<always_used>no</always_used>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="19" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_session_property" version_date="09/22/2003" version_time="61902" version_user="admin" deletion_flag="no" entity_mnemonic="gscsp" key_field_value="910730.24" record_version_obj="910731.24" version_number_seq="3.24" secondary_key_value="setup_type_file" import_version_number_seq="3.24"><session_property_obj>910730.24</session_property_obj>
<session_property_name>setup_type_file</session_property_name>
<session_property_description>File to use for setup. Used with DCU.</session_property_description>
<system_owned>no</system_owned>
<default_property_value></default_property_value>
<always_used>no</always_used>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="20" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_session_property" version_date="09/22/2003" version_time="61902" version_user="admin" deletion_flag="no" entity_mnemonic="gscsp" key_field_value="910733.24" record_version_obj="910734.24" version_number_seq="3.24" secondary_key_value="window_title" import_version_number_seq="3.24"><session_property_obj>910733.24</session_property_obj>
<session_property_name>window_title</session_property_name>
<session_property_description>Window Title for DCU main window. Used for DCU.</session_property_description>
<system_owned>no</system_owned>
<default_property_value></default_property_value>
<always_used>no</always_used>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="21" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_session_property" version_date="09/22/2003" version_time="61902" version_user="admin" deletion_flag="no" entity_mnemonic="gscsp" key_field_value="910776.24" record_version_obj="910777.24" version_number_seq="2.24" secondary_key_value="auto_dump_entity_cache" import_version_number_seq="2.24"><session_property_obj>910776.24</session_property_obj>
<session_property_name>auto_dump_entity_cache</session_property_name>
<session_property_description>Indicates whether the entity cache should automatically be created</session_property_description>
<system_owned>no</system_owned>
<default_property_value></default_property_value>
<always_used>no</always_used>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="22" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_session_property" version_date="09/24/2003" version_time="61904" version_user="admin" deletion_flag="no" entity_mnemonic="gscsp" key_field_value="910858.24" record_version_obj="910859.24" version_number_seq="2.24" secondary_key_value="expand_list" import_version_number_seq="2.24"><session_property_obj>910858.24</session_property_obj>
<session_property_name>expand_list</session_property_name>
<session_property_description>List of properties that should be run through the property expander</session_property_description>
<system_owned>yes</system_owned>
<default_property_value></default_property_value>
<always_used>no</always_used>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="23" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_session_property" version_date="09/24/2003" version_time="61904" version_user="admin" deletion_flag="no" entity_mnemonic="gscsp" key_field_value="910860.24" record_version_obj="910861.24" version_number_seq="4.24" secondary_key_value="registry_keys" import_version_number_seq="4.24"><session_property_obj>910860.24</session_property_obj>
<session_property_name>registry_keys</session_property_name>
<session_property_description>List of properties that should be read as registry keys</session_property_description>
<system_owned>no</system_owned>
<default_property_value>reg_install_path,reg_work_path</default_property_value>
<always_used>no</always_used>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="24" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_session_property" version_date="10/16/2003" version_time="59465" version_user="admin" deletion_flag="no" entity_mnemonic="gscsp" key_field_value="910862.24" record_version_obj="910863.24" version_number_seq="2.09" secondary_key_value="DynamicsVersion" import_version_number_seq="2.24"><session_property_obj>910862.24</session_property_obj>
<session_property_name>DynamicsVersion</session_property_name>
<session_property_description>Dynamics Version No</session_property_description>
<system_owned>yes</system_owned>
<default_property_value>2.1A</default_property_value>
<always_used>yes</always_used>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="25" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_session_property" version_date="09/24/2003" version_time="61905" version_user="admin" deletion_flag="no" entity_mnemonic="gscsp" key_field_value="910864.24" record_version_obj="910865.24" version_number_seq="2.24" secondary_key_value="reg_install_path" import_version_number_seq="2.24"><session_property_obj>910864.24</session_property_obj>
<session_property_name>reg_install_path</session_property_name>
<session_property_description>Registry Install Path</session_property_description>
<system_owned>no</system_owned>
<default_property_value>HKEY_LOCAL_MACHINE:SOFTWARE\PSC\Progress Dynamics:#DynamicsVersion#:DLC</default_property_value>
<always_used>no</always_used>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="26" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_session_property" version_date="09/24/2003" version_time="61905" version_user="admin" deletion_flag="no" entity_mnemonic="gscsp" key_field_value="910866.24" record_version_obj="910867.24" version_number_seq="2.24" secondary_key_value="reg_work_path" import_version_number_seq="2.24"><session_property_obj>910866.24</session_property_obj>
<session_property_name>reg_work_path</session_property_name>
<session_property_description>Working path in registry</session_property_description>
<system_owned>no</system_owned>
<default_property_value>HKEY_LOCAL_MACHINE:SOFTWARE\PSC\Progress Dynamics:#DynamicsVersion#:workingPath</default_property_value>
<always_used>no</always_used>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="27" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_session_property" version_date="09/24/2003" version_time="61904" version_user="admin" deletion_flag="no" entity_mnemonic="gscsp" key_field_value="910871.24" record_version_obj="910872.24" version_number_seq="2.24" secondary_key_value="enable_save_into" import_version_number_seq="2.24"><session_property_obj>910871.24</session_property_obj>
<session_property_name>enable_save_into</session_property_name>
<session_property_description>Used to automatically save compiled code to more than one target area</session_property_description>
<system_owned>no</system_owned>
<default_property_value></default_property_value>
<always_used>no</always_used>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="28" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_session_property" version_date="09/24/2003" version_time="61905" version_user="admin" deletion_flag="no" entity_mnemonic="gscsp" key_field_value="910873.24" record_version_obj="910874.24" version_number_seq="2.24" secondary_key_value="session_type_template" import_version_number_seq="2.24"><session_property_obj>910873.24</session_property_obj>
<session_property_name>session_type_template</session_property_name>
<session_property_description>Indicates whether a session type is a template session type</session_property_description>
<system_owned>no</system_owned>
<default_property_value></default_property_value>
<always_used>no</always_used>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="29" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_session_property" version_date="06/25/2002" version_time="69568" version_user="admin" deletion_flag="no" entity_mnemonic="gscsp" key_field_value="1004955828.09" record_version_obj="3000004869.09" version_number_seq="1.09" secondary_key_value="session_date_format" import_version_number_seq="1.09"><session_property_obj>1004955828.09</session_property_obj>
<session_property_name>session_date_format</session_property_name>
<session_property_description>SESSION:DATE-FORMAT setting</session_property_description>
<system_owned>yes</system_owned>
<default_property_value>mdy</default_property_value>
<always_used>yes</always_used>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="30" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_session_property" version_date="10/02/2003" version_time="49459" version_user="admin" deletion_flag="no" entity_mnemonic="GSCSP" key_field_value="1004955844.09" record_version_obj="3000058488.09" version_number_seq="1.09" secondary_key_value="run_local" import_version_number_seq="1.09"><session_property_obj>1004955844.09</session_property_obj>
<session_property_name>run_local</session_property_name>
<session_property_description>Should this session run locally?</session_property_description>
<system_owned>yes</system_owned>
<default_property_value>no</default_property_value>
<always_used>no</always_used>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="31" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_session_property" version_date="10/02/2003" version_time="49459" version_user="admin" deletion_flag="no" entity_mnemonic="GSCSP" key_field_value="1004955845.09" record_version_obj="3000058489.09" version_number_seq="1.09" secondary_key_value="session_year_offset" import_version_number_seq="1.09"><session_property_obj>1004955845.09</session_property_obj>
<session_property_name>session_year_offset</session_property_name>
<session_property_description>Session year offset attribute</session_property_description>
<system_owned>yes</system_owned>
<default_property_value>1950</default_property_value>
<always_used>yes</always_used>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="32" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_session_property" version_date="06/25/2002" version_time="69611" version_user="admin" deletion_flag="no" entity_mnemonic="gscsp" key_field_value="1004956478.09" record_version_obj="3000004857.09" version_number_seq="2.09" secondary_key_value="session_propath" import_version_number_seq="2.09"><session_property_obj>1004956478.09</session_property_obj>
<session_property_name>session_propath</session_property_name>
<session_property_description>PROPATH setting</session_property_description>
<system_owned>yes</system_owned>
<default_property_value></default_property_value>
<always_used>no</always_used>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="33" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_session_property" version_date="06/25/2002" version_time="69586" version_user="admin" deletion_flag="no" entity_mnemonic="gscsp" key_field_value="1004956479.09" record_version_obj="3000004870.09" version_number_seq="1.09" secondary_key_value="session_debug_alert" import_version_number_seq="1.09"><session_property_obj>1004956479.09</session_property_obj>
<session_property_name>session_debug_alert</session_property_name>
<session_property_description>SESSION:DEBUG-ALERT setting</session_property_description>
<system_owned>yes</system_owned>
<default_property_value>no</default_property_value>
<always_used>no</always_used>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="34" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_session_property" version_date="06/25/2002" version_time="69630" version_user="admin" deletion_flag="no" entity_mnemonic="gscsp" key_field_value="1004956480.09" record_version_obj="3000004871.09" version_number_seq="1.09" secondary_key_value="session_time_source" import_version_number_seq="1.09"><session_property_obj>1004956480.09</session_property_obj>
<session_property_name>session_time_source</session_property_name>
<session_property_description>SESSION:TIME-SOURCE setting</session_property_description>
<system_owned>yes</system_owned>
<default_property_value>LOCAL</default_property_value>
<always_used>no</always_used>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="35" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_session_property" version_date="10/02/2003" version_time="49459" version_user="admin" deletion_flag="no" entity_mnemonic="GSCSP" key_field_value="1004956481.09" record_version_obj="3000058490.09" version_number_seq="1.09" secondary_key_value="session_tooltips" import_version_number_seq="1.09"><session_property_obj>1004956481.09</session_property_obj>
<session_property_name>session_tooltips</session_property_name>
<session_property_description>Session Tooltips</session_property_description>
<system_owned>yes</system_owned>
<default_property_value>YES</default_property_value>
<always_used>no</always_used>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="36" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_session_property" version_date="10/02/2003" version_time="49459" version_user="admin" deletion_flag="no" entity_mnemonic="GSCSP" key_field_value="1004956689.09" record_version_obj="3000058491.09" version_number_seq="1.09" secondary_key_value="startup_procedure" import_version_number_seq="1.09"><session_property_obj>1004956689.09</session_property_obj>
<session_property_name>startup_procedure</session_property_name>
<session_property_description>Startup Procedure</session_property_description>
<system_owned>yes</system_owned>
<default_property_value></default_property_value>
<always_used>no</always_used>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="37" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_session_property" version_date="10/02/2003" version_time="49459" version_user="admin" deletion_flag="no" entity_mnemonic="GSCSP" key_field_value="1004956778.09" record_version_obj="3000058492.09" version_number_seq="1.09" secondary_key_value="root_directory" import_version_number_seq="1.09"><session_property_obj>1004956778.09</session_property_obj>
<session_property_name>root_directory</session_property_name>
<session_property_description>Root Directory</session_property_description>
<system_owned>no</system_owned>
<default_property_value>.</default_property_value>
<always_used>yes</always_used>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="38" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_session_property" version_date="06/17/2002" version_time="49313" version_user="admin" deletion_flag="no" entity_mnemonic="gscsp" key_field_value="3000000387.09" record_version_obj="3000000389.09" version_number_seq="1.09" secondary_key_value="allow_anonymous_login" import_version_number_seq="1.09"><session_property_obj>3000000387.09</session_property_obj>
<session_property_name>allow_anonymous_login</session_property_name>
<session_property_description>Used to determine whether anonymous logins are allowed for Webspeed</session_property_description>
<system_owned>yes</system_owned>
<default_property_value>NO</default_property_value>
<always_used>no</always_used>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="39" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_session_property" version_date="06/17/2002" version_time="49313" version_user="admin" deletion_flag="no" entity_mnemonic="gscsp" key_field_value="3000001001.09" record_version_obj="3000001003.09" version_number_seq="1.09" secondary_key_value="anonymous_user_name" import_version_number_seq="1.09"><session_property_obj>3000001001.09</session_property_obj>
<session_property_name>anonymous_user_name</session_property_name>
<session_property_description>Used if allow_anonymous_login is on</session_property_description>
<system_owned>yes</system_owned>
<default_property_value>anonymous</default_property_value>
<always_used>no</always_used>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="40" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_session_property" version_date="06/17/2002" version_time="49313" version_user="admin" deletion_flag="no" entity_mnemonic="gscsp" key_field_value="3000001004.09" record_version_obj="3000001005.09" version_number_seq="2.09" secondary_key_value="anonymous_user_password" import_version_number_seq="2.09"><session_property_obj>3000001004.09</session_property_obj>
<session_property_name>anonymous_user_password</session_property_name>
<session_property_description>Password to apply to anonymous_user_name</session_property_description>
<system_owned>yes</system_owned>
<default_property_value></default_property_value>
<always_used>no</always_used>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="41" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_session_property" version_date="06/17/2002" version_time="49313" version_user="admin" deletion_flag="no" entity_mnemonic="gscsp" key_field_value="3000001006.09" record_version_obj="3000001007.09" version_number_seq="2.09" secondary_key_value="display_login_screen" import_version_number_seq="2.09"><session_property_obj>3000001006.09</session_property_obj>
<session_property_name>display_login_screen</session_property_name>
<session_property_description>Indicates whether or not the login screen should be displayed</session_property_description>
<system_owned>yes</system_owned>
<default_property_value>YES</default_property_value>
<always_used>no</always_used>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="42" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_session_property" version_date="06/25/2002" version_time="59776" version_user="admin" deletion_flag="no" entity_mnemonic="gscsp" key_field_value="3000004829.09" record_version_obj="3000004830.09" version_number_seq="2.09" secondary_key_value="_start_in_directory" import_version_number_seq="2.09"><session_property_obj>3000004829.09</session_property_obj>
<session_property_name>_start_in_directory</session_property_name>
<session_property_description>Start in directory</session_property_description>
<system_owned>yes</system_owned>
<default_property_value></default_property_value>
<always_used>no</always_used>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="43" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_session_property" version_date="06/25/2002" version_time="59814" version_user="admin" deletion_flag="no" entity_mnemonic="gscsp" key_field_value="3000004831.09" record_version_obj="3000004832.09" version_number_seq="2.09" secondary_key_value="_framework_tty_directory" import_version_number_seq="2.09"><session_property_obj>3000004831.09</session_property_obj>
<session_property_name>_framework_tty_directory</session_property_name>
<session_property_description>Framework directory containing ChUI code</session_property_description>
<system_owned>yes</system_owned>
<default_property_value></default_property_value>
<always_used>no</always_used>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="44" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_session_property" version_date="06/25/2002" version_time="59849" version_user="admin" deletion_flag="no" entity_mnemonic="gscsp" key_field_value="3000004833.09" record_version_obj="3000004834.09" version_number_seq="2.09" secondary_key_value="_framework_source_directory" import_version_number_seq="2.09"><session_property_obj>3000004833.09</session_property_obj>
<session_property_name>_framework_source_directory</session_property_name>
<session_property_description>Framework directory containing source code</session_property_description>
<system_owned>yes</system_owned>
<default_property_value></default_property_value>
<always_used>no</always_used>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="45" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_session_property" version_date="06/25/2002" version_time="59884" version_user="admin" deletion_flag="no" entity_mnemonic="gscsp" key_field_value="3000004835.09" record_version_obj="3000004836.09" version_number_seq="2.09" secondary_key_value="_framework_gui_directory" import_version_number_seq="2.09"><session_property_obj>3000004835.09</session_property_obj>
<session_property_name>_framework_gui_directory</session_property_name>
<session_property_description>Framework directory containing GUI code</session_property_description>
<system_owned>yes</system_owned>
<default_property_value></default_property_value>
<always_used>no</always_used>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="46" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_session_property" version_date="06/25/2002" version_time="59941" version_user="admin" deletion_flag="no" entity_mnemonic="gscsp" key_field_value="3000004837.09" record_version_obj="3000004838.09" version_number_seq="2.09" secondary_key_value="_framework_code_directory" import_version_number_seq="2.09"><session_property_obj>3000004837.09</session_property_obj>
<session_property_name>_framework_code_directory</session_property_name>
<session_property_description>Framework directory containing code that is currently being run</session_property_description>
<system_owned>yes</system_owned>
<default_property_value></default_property_value>
<always_used>no</always_used>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="47" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_session_property" version_date="06/25/2002" version_time="60054" version_user="admin" deletion_flag="no" entity_mnemonic="gscsp" key_field_value="3000004839.09" record_version_obj="3000004840.09" version_number_seq="3.09" secondary_key_value="ICFPATH1" import_version_number_seq="3.09"><session_property_obj>3000004839.09</session_property_obj>
<session_property_name>ICFPATH1</session_property_name>
<session_property_description>Derived from ICFPATH -icfparam</session_property_description>
<system_owned>yes</system_owned>
<default_property_value></default_property_value>
<always_used>no</always_used>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="48" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_session_property" version_date="06/25/2002" version_time="60035" version_user="admin" deletion_flag="no" entity_mnemonic="gscsp" key_field_value="3000004841.09" record_version_obj="3000004842.09" version_number_seq="2.09" secondary_key_value="ICFPATHn" import_version_number_seq="2.09"><session_property_obj>3000004841.09</session_property_obj>
<session_property_name>ICFPATHn</session_property_name>
<session_property_description>Derived from ICFPATH -icfparam</session_property_description>
<system_owned>yes</system_owned>
<default_property_value></default_property_value>
<always_used>no</always_used>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="49" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_session_property" version_date="06/25/2002" version_time="60095" version_user="admin" deletion_flag="no" entity_mnemonic="gscsp" key_field_value="3000004843.09" record_version_obj="3000004844.09" version_number_seq="2.09" secondary_key_value="ICFPATH" import_version_number_seq="2.09"><session_property_obj>3000004843.09</session_property_obj>
<session_property_name>ICFPATH</session_property_name>
<session_property_description>Derived from ICFPATH -icfparam</session_property_description>
<system_owned>yes</system_owned>
<default_property_value></default_property_value>
<always_used>no</always_used>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="50" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_session_property" version_date="06/25/2002" version_time="61722" version_user="admin" deletion_flag="no" entity_mnemonic="gscsp" key_field_value="3000004845.09" record_version_obj="3000004846.09" version_number_seq="5.09" secondary_key_value="session_time_format" import_version_number_seq="5.09"><session_property_obj>3000004845.09</session_property_obj>
<session_property_name>session_time_format</session_property_name>
<session_property_description>Time format used as a format mask</session_property_description>
<system_owned>yes</system_owned>
<default_property_value>HH:MM:SS</default_property_value>
<always_used>no</always_used>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="51" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_session_property" version_date="06/25/2002" version_time="60838" version_user="admin" deletion_flag="no" entity_mnemonic="gscsp" key_field_value="3000004847.09" record_version_obj="3000004848.09" version_number_seq="2.09" secondary_key_value="ICFCONFIG" import_version_number_seq="2.09"><session_property_obj>3000004847.09</session_property_obj>
<session_property_name>ICFCONFIG</session_property_name>
<session_property_description>Derived from ICFCONFIG -icfparam</session_property_description>
<system_owned>yes</system_owned>
<default_property_value></default_property_value>
<always_used>no</always_used>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="52" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_session_property" version_date="06/25/2002" version_time="60865" version_user="admin" deletion_flag="no" entity_mnemonic="gscsp" key_field_value="3000004849.09" record_version_obj="3000004850.09" version_number_seq="2.09" secondary_key_value="ICFSESSTYPE" import_version_number_seq="2.09"><session_property_obj>3000004849.09</session_property_obj>
<session_property_name>ICFSESSTYPE</session_property_name>
<session_property_description>Derived from ICFSESSTYPE -icfparam</session_property_description>
<system_owned>no</system_owned>
<default_property_value></default_property_value>
<always_used>no</always_used>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="53" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_session_property" version_date="06/25/2002" version_time="60907" version_user="admin" deletion_flag="no" entity_mnemonic="gscsp" key_field_value="3000004851.09" record_version_obj="3000004852.09" version_number_seq="2.09" secondary_key_value="DCUSETUPTYPE" import_version_number_seq="2.09"><session_property_obj>3000004851.09</session_property_obj>
<session_property_name>DCUSETUPTYPE</session_property_name>
<session_property_description>Derived from DCUSETUPTYPE -icfparam (used only by DCU)</session_property_description>
<system_owned>yes</system_owned>
<default_property_value></default_property_value>
<always_used>no</always_used>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="54" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_session_property" version_date="06/25/2002" version_time="61040" version_user="admin" deletion_flag="no" entity_mnemonic="gscsp" key_field_value="3000004853.09" record_version_obj="3000004854.09" version_number_seq="3.09" secondary_key_value="valid_os_list" import_version_number_seq="3.09"><session_property_obj>3000004853.09</session_property_obj>
<session_property_name>valid_os_list</session_property_name>
<session_property_description>Automatically inserted into ICFCONFIG from session type</session_property_description>
<system_owned>yes</system_owned>
<default_property_value></default_property_value>
<always_used>no</always_used>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="55" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_session_property" version_date="06/25/2002" version_time="61027" version_user="admin" deletion_flag="no" entity_mnemonic="gscsp" key_field_value="3000004855.09" record_version_obj="3000004856.09" version_number_seq="2.09" secondary_key_value="physical_session_list" import_version_number_seq="2.09"><session_property_obj>3000004855.09</session_property_obj>
<session_property_name>physical_session_list</session_property_name>
<session_property_description>Automatically inserted into ICFCONFIG from session type</session_property_description>
<system_owned>yes</system_owned>
<default_property_value></default_property_value>
<always_used>no</always_used>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="56" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_session_property" version_date="06/25/2002" version_time="63119" version_user="admin" deletion_flag="no" entity_mnemonic="gscsp" key_field_value="3000004860.09" record_version_obj="3000004861.09" version_number_seq="2.09" secondary_key_value="session_appl_alert_boxes" import_version_number_seq="2.09"><session_property_obj>3000004860.09</session_property_obj>
<session_property_name>session_appl_alert_boxes</session_property_name>
<session_property_description>SESSION:APPL-ALERT-BOXES setting</session_property_description>
<system_owned>yes</system_owned>
<default_property_value></default_property_value>
<always_used>no</always_used>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="57" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_session_property" version_date="06/25/2002" version_time="63238" version_user="admin" deletion_flag="no" entity_mnemonic="gscsp" key_field_value="3000004862.09" record_version_obj="3000004863.09" version_number_seq="2.09" secondary_key_value="session_context_help_file" import_version_number_seq="2.09"><session_property_obj>3000004862.09</session_property_obj>
<session_property_name>session_context_help_file</session_property_name>
<session_property_description>SESSION:CONTEXT-HELP-FILE setting</session_property_description>
<system_owned>yes</system_owned>
<default_property_value></default_property_value>
<always_used>no</always_used>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="58" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_session_property" version_date="09/22/2002" version_time="37037" version_user="admin" deletion_flag="no" entity_mnemonic="gscsp" key_field_value="3000004865.09" record_version_obj="3000004866.09" version_number_seq="3.09" secondary_key_value="CustomizationTypePriority" import_version_number_seq="3.09"><session_property_obj>3000004865.09</session_property_obj>
<session_property_name>CustomizationTypePriority</session_property_name>
<session_property_description>Comma separated list of customization codes in order of priority</session_property_description>
<system_owned>yes</system_owned>
<default_property_value></default_property_value>
<always_used>no</always_used>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="59" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_session_property" version_date="06/25/2002" version_time="69528" version_user="admin" deletion_flag="no" entity_mnemonic="gscsp" key_field_value="3000004867.09" record_version_obj="3000004868.09" version_number_seq="2.09" secondary_key_value="session_data_entry_return" import_version_number_seq="2.09"><session_property_obj>3000004867.09</session_property_obj>
<session_property_name>session_data_entry_return</session_property_name>
<session_property_description>SESSION:DATA-ENTRY-RETURN setting</session_property_description>
<system_owned>yes</system_owned>
<default_property_value></default_property_value>
<always_used>no</always_used>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="60" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_session_property" version_date="06/25/2002" version_time="69677" version_user="admin" deletion_flag="no" entity_mnemonic="gscsp" key_field_value="3000004872.09" record_version_obj="3000004873.09" version_number_seq="2.09" secondary_key_value="session_immediate_display" import_version_number_seq="2.09"><session_property_obj>3000004872.09</session_property_obj>
<session_property_name>session_immediate_display</session_property_name>
<session_property_description>SESSION:IMMEDIATE-DISPLAY setting</session_property_description>
<system_owned>yes</system_owned>
<default_property_value></default_property_value>
<always_used>no</always_used>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="61" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_session_property" version_date="06/25/2002" version_time="69734" version_user="admin" deletion_flag="no" entity_mnemonic="gscsp" key_field_value="3000004874.09" record_version_obj="3000004875.09" version_number_seq="2.09" secondary_key_value="session_multitasking_interva" import_version_number_seq="2.09"><session_property_obj>3000004874.09</session_property_obj>
<session_property_name>session_multitasking_interva</session_property_name>
<session_property_description>SESSION:MULTITASKING-INTERVAL setting</session_property_description>
<system_owned>yes</system_owned>
<default_property_value></default_property_value>
<always_used>no</always_used>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="62" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_session_property" version_date="06/25/2002" version_time="69807" version_user="admin" deletion_flag="no" entity_mnemonic="gscsp" key_field_value="3000004876.09" record_version_obj="3000004877.09" version_number_seq="2.09" secondary_key_value="session_numeric_format" import_version_number_seq="2.09"><session_property_obj>3000004876.09</session_property_obj>
<session_property_name>session_numeric_format</session_property_name>
<session_property_description>SESSION:NUMERIC-FORMAT and SESSION:SET-NUMERIC-FORMAT setting</session_property_description>
<system_owned>yes</system_owned>
<default_property_value></default_property_value>
<always_used>no</always_used>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="63" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_session_property" version_date="06/25/2002" version_time="69853" version_user="admin" deletion_flag="no" entity_mnemonic="gscsp" key_field_value="3000004878.09" record_version_obj="3000004879.09" version_number_seq="2.09" secondary_key_value="session_suppress_warnings" import_version_number_seq="2.09"><session_property_obj>3000004878.09</session_property_obj>
<session_property_name>session_suppress_warnings</session_property_name>
<session_property_description>SESSION:SUPPRESS-WARNINGS setting</session_property_description>
<system_owned>yes</system_owned>
<default_property_value></default_property_value>
<always_used>no</always_used>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="64" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_session_property" version_date="06/25/2002" version_time="69914" version_user="admin" deletion_flag="no" entity_mnemonic="gscsp" key_field_value="3000004880.09" record_version_obj="3000004881.09" version_number_seq="2.09" secondary_key_value="session_system_alert_boxes" import_version_number_seq="2.09"><session_property_obj>3000004880.09</session_property_obj>
<session_property_name>session_system_alert_boxes</session_property_name>
<session_property_description>SESSION:SYSTEM-ALERT-BOXES setting</session_property_description>
<system_owned>yes</system_owned>
<default_property_value></default_property_value>
<always_used>no</always_used>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="65" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_session_property" version_date="06/25/2002" version_time="69968" version_user="admin" deletion_flag="no" entity_mnemonic="gscsp" key_field_value="3000004882.09" record_version_obj="3000004883.09" version_number_seq="2.09" secondary_key_value="session_v6display" import_version_number_seq="2.09"><session_property_obj>3000004882.09</session_property_obj>
<session_property_name>session_v6display</session_property_name>
<session_property_description>SESSION:V6DISPLAY setting</session_property_description>
<system_owned>yes</system_owned>
<default_property_value></default_property_value>
<always_used>no</always_used>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="66" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_session_property" version_date="07/08/2002" version_time="67754" version_user="admin" deletion_flag="no" entity_mnemonic="gscsp" key_field_value="3000005164.09" record_version_obj="3000005165.09" version_number_seq="2.09" secondary_key_value="AB_source_code_directory" import_version_number_seq="2.09"><session_property_obj>3000005164.09</session_property_obj>
<session_property_name>AB_source_code_directory</session_property_name>
<session_property_description>AppBuilder source code root directory</session_property_description>
<system_owned>no</system_owned>
<default_property_value>#_start_in_directory#</default_property_value>
<always_used>no</always_used>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="67" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_session_property" version_date="07/08/2002" version_time="67789" version_user="admin" deletion_flag="no" entity_mnemonic="gscsp" key_field_value="3000005166.09" record_version_obj="3000005167.09" version_number_seq="2.09" secondary_key_value="AB_compile_into_directory" import_version_number_seq="2.09"><session_property_obj>3000005166.09</session_property_obj>
<session_property_name>AB_compile_into_directory</session_property_name>
<session_property_description>AppBuilder object code root directory</session_property_description>
<system_owned>no</system_owned>
<default_property_value>#_start_in_directory#</default_property_value>
<always_used>no</always_used>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="68" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_session_property" version_date="03/19/2003" version_time="57897" version_user="admin" deletion_flag="no" entity_mnemonic="gscsp" key_field_value="3000044721.09" record_version_obj="3000044722.09" version_number_seq="2.09" secondary_key_value="login_procedure" import_version_number_seq="2.09"><session_property_obj>3000044721.09</session_property_obj>
<session_property_name>login_procedure</session_property_name>
<session_property_description>Login procedure to be used at session startup.</session_property_description>
<system_owned>yes</system_owned>
<default_property_value>af/cod2/aftemlognw.w</default_property_value>
<always_used>no</always_used>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="69" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_session_property" version_date="03/19/2003" version_time="58153" version_user="admin" deletion_flag="no" entity_mnemonic="gscsp" key_field_value="3000044723.09" record_version_obj="3000044724.09" version_number_seq="2.09" secondary_key_value="OG_ValidateFrom" import_version_number_seq="2.09"><session_property_obj>3000044723.09</session_property_obj>
<session_property_name>OG_ValidateFrom</session_property_name>
<session_property_description>Used by OG to determine
 validation logic within DLProc</session_property_description>
<system_owned>yes</system_owned>
<default_property_value></default_property_value>
<always_used>no</always_used>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="70" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_session_property" version_date="03/19/2003" version_time="58557" version_user="admin" deletion_flag="no" entity_mnemonic="gscsp" key_field_value="3000044727.09" record_version_obj="3000044728.09" version_number_seq="2.09" secondary_key_value="ClassIgnoreContainedInstances" import_version_number_seq="2.09"><session_property_obj>3000044727.09</session_property_obj>
<session_property_name>ClassIgnoreContainedInstances</session_property_name>
<session_property_description>Comma-delimited list of class names used by repository manager</session_property_description>
<system_owned>yes</system_owned>
<default_property_value></default_property_value>
<always_used>no</always_used>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="71" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_session_property" version_date="03/21/2003" version_time="37315" version_user="admin" deletion_flag="no" entity_mnemonic="gscsp" key_field_value="3000044734.09" record_version_obj="3000044735.09" version_number_seq="2.09" secondary_key_value="menu_images" import_version_number_seq="2.09"><session_property_obj>3000044734.09</session_property_obj>
<session_property_name>menu_images</session_property_name>
<session_property_description>Display images on menu (treeview) if set to &quot;enabled&quot;.</session_property_description>
<system_owned>yes</system_owned>
<default_property_value>disabled</default_property_value>
<always_used>no</always_used>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="72" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_session_property" version_date="09/10/2003" version_time="51948" version_user="admin" deletion_flag="no" entity_mnemonic="gscsp" key_field_value="3000051363.09" record_version_obj="3000051364.09" version_number_seq="4.09" secondary_key_value="image_path" import_version_number_seq="4.09"><session_property_obj>3000051363.09</session_property_obj>
<session_property_name>image_path</session_property_name>
<session_property_description>Web image directory path</session_property_description>
<system_owned>yes</system_owned>
<default_property_value>ry/img/,../img/</default_property_value>
<always_used>no</always_used>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="73" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_session_property" version_date="09/17/2003" version_time="64582" version_user="admin" deletion_flag="no" entity_mnemonic="gscsp" key_field_value="3000052907.09" record_version_obj="3000052908.09" version_number_seq="2.09" secondary_key_value="client_cache_directory" import_version_number_seq="2.09"><session_property_obj>3000052907.09</session_property_obj>
<session_property_name>client_cache_directory</session_property_name>
<session_property_description>Absolute path to the client cache directory</session_property_description>
<system_owned>yes</system_owned>
<default_property_value></default_property_value>
<always_used>no</always_used>
</contained_record>
</dataset_transaction>
</dataset_records>
</dataset>