<?xml version="1.0" encoding="utf-8" ?>
<dataset Transactions="22"><dataset_header DisableRI="yes" DatasetObj="1007600132.08" DateFormat="mdy" FullHeader="yes" SCMManaged="no" YearOffset="1950" DatasetCode="GSMSE" NumericFormat="AMERICAN" NumericDecimal="." OriginatingSite="90" NumericSeparator=","><deploy_dataset_obj>1007600132.08</deploy_dataset_obj>
<dataset_code>GSMSE</dataset_code>
<dataset_description>gsm_session_type - Session Types</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<deploy_additions_only>no</deploy_additions_only>
<enable_data_versioning>yes</enable_data_versioning>
<deletion_dataset>yes</deletion_dataset>
<dataset_entity><dataset_entity_obj>1007600134.08</dataset_entity_obj>
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
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
<exclude_field_list>inactivity_timeout_period,automatic_reconnect</exclude_field_list>
<entity_mnemonic_description>gsm_session_type</entity_mnemonic_description>
<entity_dbname>ICFDB</entity_dbname>
</dataset_entity>
<dataset_entity><dataset_entity_obj>1007600135.08</dataset_entity_obj>
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
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
<exclude_field_list>property_value</exclude_field_list>
<entity_mnemonic_description>gsm_session_type_property</entity_mnemonic_description>
<entity_dbname>ICFDB</entity_dbname>
</dataset_entity>
<dataset_entity><dataset_entity_obj>1007600136.08</dataset_entity_obj>
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
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
<exclude_field_list>physical_service_obj</exclude_field_list>
<entity_mnemonic_description>gsm_session_service</entity_mnemonic_description>
<entity_dbname>ICFDB</entity_dbname>
</dataset_entity>
<dataset_entity><dataset_entity_obj>1007600137.08</dataset_entity_obj>
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
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
<exclude_field_list></exclude_field_list>
<entity_mnemonic_description>gsm_required_manager</entity_mnemonic_description>
<entity_dbname>ICFDB</entity_dbname>
</dataset_entity>
<table_definition><name>gsm_session_type</name>
<dbname>icfdb</dbname>
<index-1>XAK1gsm_session_type,1,0,0,session_type_code,0</index-1>
<index-2>XIE1gsm_session_type,0,0,0,session_type_description,0</index-2>
<index-3>XIE2gsm_session_type,0,0,0,extends_session_type_obj,0</index-3>
<index-4>XPKgsm_session_type,1,1,0,session_type_obj,0</index-4>
<field><name>session_type_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Session type obj</label>
<column-label>Session type obj</column-label>
</field>
<field><name>session_type_code</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(20)</format>
<initial></initial>
<label>Session type code</label>
<column-label>Session type code</column-label>
</field>
<field><name>session_type_description</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>Session type description</label>
<column-label>Session type description</column-label>
</field>
<field><name>physical_session_list</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Physical session list</label>
<column-label>Physical session list</column-label>
</field>
<field><name>valid_os_list</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Valid os list</label>
<column-label>Valid os list</column-label>
</field>
<field><name>inactivity_timeout_period</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Inactivity timeout period</label>
<column-label>Inactivity timeout period</column-label>
</field>
<field><name>automatic_reconnect</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>YES</initial>
<label>Automatic reconnect</label>
<column-label>Automatic reconnect</column-label>
</field>
<field><name>extends_session_type_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Extends session type obj</label>
<column-label>Extends session type obj</column-label>
</field>
</table_definition>
<table_definition><name>gsm_session_type_property</name>
<dbname>icfdb</dbname>
<index-1>XAK1gsm_session_type_property,1,0,0,session_property_obj,0,session_type_obj,0</index-1>
<index-2>XIE1gsm_session_type_property,0,0,0,session_type_obj,0</index-2>
<index-3>XPKgsm_session_type_property,1,1,0,session_type_property_obj,0</index-3>
<field><name>session_type_property_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Session type property obj</label>
<column-label>Session type property obj</column-label>
</field>
<field><name>session_type_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Session type obj</label>
<column-label>Session type obj</column-label>
</field>
<field><name>session_property_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Session property obj</label>
<column-label>Session property obj</column-label>
</field>
<field><name>property_value</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Property value</label>
<column-label>Property value</column-label>
</field>
</table_definition>
<table_definition><name>gsm_session_service</name>
<dbname>icfdb</dbname>
<index-1>XAK1gsm_session_service,1,0,0,session_type_obj,0,logical_service_obj,0</index-1>
<index-2>XAK2gsm_session_service,1,0,0,logical_service_obj,0,session_type_obj,0</index-2>
<index-3>XIE1gsm_session_service,0,0,0,physical_service_obj,0</index-3>
<index-4>XPKgsm_session_service,1,1,0,session_service_obj,0</index-4>
<field><name>session_service_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Session service obj</label>
<column-label>Session service obj</column-label>
</field>
<field><name>session_type_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Session type obj</label>
<column-label>Session type obj</column-label>
</field>
<field><name>logical_service_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Logical service obj</label>
<column-label>Logical service obj</column-label>
</field>
<field><name>physical_service_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Physical service obj</label>
<column-label>Physical service obj</column-label>
</field>
</table_definition>
<table_definition><name>gsm_required_manager</name>
<dbname>icfdb</dbname>
<index-1>XAK1gsm_required_manager,1,0,0,session_type_obj,0,startup_order,0</index-1>
<index-2>XAK2gsm_required_manager,1,0,0,manager_type_obj,0,session_type_obj,0</index-2>
<index-3>XPKgsm_required_manager,1,1,0,required_manager_obj,0</index-3>
<field><name>required_manager_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Required manager obj</label>
<column-label>Required manager obj</column-label>
</field>
<field><name>session_type_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Session type obj</label>
<column-label>Session type obj</column-label>
</field>
<field><name>startup_order</name>
<data-type>integer</data-type>
<extent>0</extent>
<format>-&gt;&gt;9</format>
<initial>   0</initial>
<label>Startup order</label>
<column-label>Startup order</column-label>
</field>
<field><name>manager_type_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Manager type obj</label>
<column-label>Manager type obj</column-label>
</field>
<field><name>system_owned</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>System owned</label>
<column-label>System owned</column-label>
</field>
</table_definition>
</dataset_header>
<dataset_records><dataset_transaction TransactionNo="1" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_session_type" version_date="09/24/2003" version_time="61905" version_user="admin" deletion_flag="no" entity_mnemonic="GSMSE" key_field_value="910719.24" record_version_obj="910720.24" version_number_seq="5.24" secondary_key_value="Basic" import_version_number_seq="5.24"><session_type_obj>910719.24</session_type_obj>
<session_type_code>Basic</session_type_code>
<session_type_description>Basic Session Type</session_type_description>
<physical_session_list></physical_session_list>
<valid_os_list></valid_os_list>
<inactivity_timeout_period>0</inactivity_timeout_period>
<automatic_reconnect>yes</automatic_reconnect>
<extends_session_type_obj>0</extends_session_type_obj>
<contained_record DB="icfdb" Table="gsm_session_type_property"><session_type_property_obj>910875.24</session_type_property_obj>
<session_type_obj>910719.24</session_type_obj>
<session_property_obj>910873.24</session_property_obj>
<property_value>yes</property_value>
</contained_record>
<contained_record DB="icfdb" Table="gsm_required_manager"><required_manager_obj>910721.24</required_manager_obj>
<session_type_obj>910719.24</session_type_obj>
<startup_order>1</startup_order>
<manager_type_obj>1004947362.09</manager_type_obj>
<system_owned>no</system_owned>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="2" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_session_type" version_date="09/24/2003" version_time="40372" version_user="admin" deletion_flag="no" entity_mnemonic="GSMSE" key_field_value="910722.24" record_version_obj="910723.24" version_number_seq="22.24" secondary_key_value="ProgressSetup" import_version_number_seq="22.24"><session_type_obj>910722.24</session_type_obj>
<session_type_code>ProgressSetup</session_type_code>
<session_type_description>ProgressSetup</session_type_description>
<physical_session_list>GUI,WBC</physical_session_list>
<valid_os_list>WIN32</valid_os_list>
<inactivity_timeout_period>0</inactivity_timeout_period>
<automatic_reconnect>yes</automatic_reconnect>
<extends_session_type_obj>910749.24</extends_session_type_obj>
<contained_record DB="icfdb" Table="gsm_session_type_property"><session_type_property_obj>910729.24</session_type_property_obj>
<session_type_obj>910722.24</session_type_obj>
<session_property_obj>910727.24</session_property_obj>
<property_value>ProgressSetup</property_value>
</contained_record>
<contained_record DB="icfdb" Table="gsm_session_type_property"><session_type_property_obj>910732.24</session_type_property_obj>
<session_type_obj>910722.24</session_type_obj>
<session_property_obj>910730.24</session_property_obj>
<property_value>db/icf/dfd/setup0201A.xml</property_value>
</contained_record>
<contained_record DB="icfdb" Table="gsm_session_type_property"><session_type_property_obj>910735.24</session_type_property_obj>
<session_type_obj>910722.24</session_type_obj>
<session_property_obj>910733.24</session_property_obj>
<property_value>Progress Dynamics Configuration Utility</property_value>
</contained_record>
<contained_record DB="icfdb" Table="gsm_required_manager"><required_manager_obj>910746.24</required_manager_obj>
<session_type_obj>910722.24</session_type_obj>
<startup_order>4</startup_order>
<manager_type_obj>910744.24</manager_type_obj>
<system_owned>no</system_owned>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="3" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_session_type" version_date="10/16/2003" version_time="59565" version_user="admin" deletion_flag="no" entity_mnemonic="GSMSE" key_field_value="910747.24" record_version_obj="910748.24" version_number_seq="6.24" secondary_key_value="Dynamics" import_version_number_seq="6.24"><session_type_obj>910747.24</session_type_obj>
<session_type_code>Dynamics</session_type_code>
<session_type_description>Dynamics Session Type</session_type_description>
<physical_session_list>APP,WBC,GUI,CUI,WBS</physical_session_list>
<valid_os_list></valid_os_list>
<inactivity_timeout_period>0</inactivity_timeout_period>
<automatic_reconnect>yes</automatic_reconnect>
<extends_session_type_obj>910719.24</extends_session_type_obj>
<contained_record DB="icfdb" Table="gsm_session_type_property"><session_type_property_obj>910778.24</session_type_property_obj>
<session_type_obj>910747.24</session_type_obj>
<session_property_obj>910776.24</session_property_obj>
<property_value>YES</property_value>
</contained_record>
<contained_record DB="icfdb" Table="gsm_session_type_property"><session_type_property_obj>964081.24</session_type_property_obj>
<session_type_obj>910747.24</session_type_obj>
<session_property_obj>910862.24</session_property_obj>
<property_value>2.1A</property_value>
</contained_record>
<contained_record DB="icfdb" Table="gsm_session_type_property"><session_type_property_obj>910877.24</session_type_property_obj>
<session_type_obj>910747.24</session_type_obj>
<session_property_obj>910873.24</session_property_obj>
<property_value>yes</property_value>
</contained_record>
<contained_record DB="icfdb" Table="gsm_session_service"><session_service_obj>910773.24</session_service_obj>
<session_type_obj>910747.24</session_type_obj>
<logical_service_obj>1004947455.09</logical_service_obj>
<physical_service_obj>1004947554.09</physical_service_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_required_manager"><required_manager_obj>910766.24</required_manager_obj>
<session_type_obj>910747.24</session_type_obj>
<startup_order>3</startup_order>
<manager_type_obj>1004947428.09</manager_type_obj>
<system_owned>no</system_owned>
</contained_record>
<contained_record DB="icfdb" Table="gsm_required_manager"><required_manager_obj>910769.24</required_manager_obj>
<session_type_obj>910747.24</session_type_obj>
<startup_order>4</startup_order>
<manager_type_obj>1004947448.09</manager_type_obj>
<system_owned>no</system_owned>
</contained_record>
<contained_record DB="icfdb" Table="gsm_required_manager"><required_manager_obj>910767.24</required_manager_obj>
<session_type_obj>910747.24</session_type_obj>
<startup_order>5</startup_order>
<manager_type_obj>1004947429.09</manager_type_obj>
<system_owned>no</system_owned>
</contained_record>
<contained_record DB="icfdb" Table="gsm_required_manager"><required_manager_obj>910768.24</required_manager_obj>
<session_type_obj>910747.24</session_type_obj>
<startup_order>6</startup_order>
<manager_type_obj>1004947431.09</manager_type_obj>
<system_owned>no</system_owned>
</contained_record>
<contained_record DB="icfdb" Table="gsm_required_manager"><required_manager_obj>910770.24</required_manager_obj>
<session_type_obj>910747.24</session_type_obj>
<startup_order>7</startup_order>
<manager_type_obj>1004947430.09</manager_type_obj>
<system_owned>no</system_owned>
</contained_record>
<contained_record DB="icfdb" Table="gsm_required_manager"><required_manager_obj>910771.24</required_manager_obj>
<session_type_obj>910747.24</session_type_obj>
<startup_order>8</startup_order>
<manager_type_obj>1004947432.09</manager_type_obj>
<system_owned>no</system_owned>
</contained_record>
<contained_record DB="icfdb" Table="gsm_required_manager"><required_manager_obj>910772.24</required_manager_obj>
<session_type_obj>910747.24</session_type_obj>
<startup_order>9</startup_order>
<manager_type_obj>3000000312.09</manager_type_obj>
<system_owned>no</system_owned>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="4" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_session_type" version_date="09/24/2003" version_time="61905" version_user="admin" deletion_flag="no" entity_mnemonic="GSMSE" key_field_value="910749.24" record_version_obj="910750.24" version_number_seq="6.24" secondary_key_value="DCU" import_version_number_seq="6.24"><session_type_obj>910749.24</session_type_obj>
<session_type_code>DCU</session_type_code>
<session_type_description>DCU Session Type</session_type_description>
<physical_session_list>GUI</physical_session_list>
<valid_os_list></valid_os_list>
<inactivity_timeout_period>0</inactivity_timeout_period>
<automatic_reconnect>yes</automatic_reconnect>
<extends_session_type_obj>910719.24</extends_session_type_obj>
<contained_record DB="icfdb" Table="gsm_session_type_property"><session_type_property_obj>910876.24</session_type_property_obj>
<session_type_obj>910749.24</session_type_obj>
<session_property_obj>910873.24</session_property_obj>
<property_value>yes</property_value>
</contained_record>
<contained_record DB="icfdb" Table="gsm_required_manager"><required_manager_obj>910751.24</required_manager_obj>
<session_type_obj>910749.24</session_type_obj>
<startup_order>2</startup_order>
<manager_type_obj>910741.24</manager_type_obj>
<system_owned>no</system_owned>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="5" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_session_type" version_date="09/24/2003" version_time="61905" version_user="admin" deletion_flag="no" entity_mnemonic="GSMSE" key_field_value="910752.24" record_version_obj="910753.24" version_number_seq="8.24" secondary_key_value="DynDBBound" import_version_number_seq="8.24"><session_type_obj>910752.24</session_type_obj>
<session_type_code>DynDBBound</session_type_code>
<session_type_description>Dynamics DB Bound Session Types</session_type_description>
<physical_session_list>APP</physical_session_list>
<valid_os_list></valid_os_list>
<inactivity_timeout_period>0</inactivity_timeout_period>
<automatic_reconnect>yes</automatic_reconnect>
<extends_session_type_obj>910747.24</extends_session_type_obj>
<contained_record DB="icfdb" Table="gsm_session_type_property"><session_type_property_obj>910879.24</session_type_property_obj>
<session_type_obj>910752.24</session_type_obj>
<session_property_obj>910873.24</session_property_obj>
<property_value>yes</property_value>
</contained_record>
<contained_record DB="icfdb" Table="gsm_session_type_property"><session_type_property_obj>910780.24</session_type_property_obj>
<session_type_obj>910752.24</session_type_obj>
<session_property_obj>1004955844.09</session_property_obj>
<property_value>YES</property_value>
</contained_record>
<contained_record DB="icfdb" Table="gsm_session_service"><session_service_obj>910775.24</session_service_obj>
<session_type_obj>910752.24</session_type_obj>
<logical_service_obj>1004947458.09</logical_service_obj>
<physical_service_obj>1004947549.09</physical_service_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_required_manager"><required_manager_obj>910774.24</required_manager_obj>
<session_type_obj>910752.24</session_type_obj>
<startup_order>2</startup_order>
<manager_type_obj>3000005352.09</manager_type_obj>
<system_owned>no</system_owned>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="6" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_session_type" version_date="09/24/2003" version_time="61905" version_user="admin" deletion_flag="no" entity_mnemonic="GSMSE" key_field_value="910754.24" record_version_obj="910755.24" version_number_seq="6.24" secondary_key_value="DynAppServer" import_version_number_seq="6.24"><session_type_obj>910754.24</session_type_obj>
<session_type_code>DynAppServer</session_type_code>
<session_type_description>Dynamics AppServers</session_type_description>
<physical_session_list>APP</physical_session_list>
<valid_os_list></valid_os_list>
<inactivity_timeout_period>0</inactivity_timeout_period>
<automatic_reconnect>yes</automatic_reconnect>
<extends_session_type_obj>910752.24</extends_session_type_obj>
<contained_record DB="icfdb" Table="gsm_session_type_property"><session_type_property_obj>910802.24</session_type_property_obj>
<session_type_obj>910754.24</session_type_obj>
<session_property_obj>4622.5498</session_property_obj>
<property_value>NO</property_value>
</contained_record>
<contained_record DB="icfdb" Table="gsm_session_type_property"><session_type_property_obj>910880.24</session_type_property_obj>
<session_type_obj>910754.24</session_type_obj>
<session_property_obj>910873.24</session_property_obj>
<property_value>yes</property_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="7" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_session_type" version_date="09/24/2003" version_time="61906" version_user="admin" deletion_flag="no" entity_mnemonic="GSMSE" key_field_value="910756.24" record_version_obj="910757.24" version_number_seq="17.24" secondary_key_value="DynWeb" import_version_number_seq="17.24"><session_type_obj>910756.24</session_type_obj>
<session_type_code>DynWeb</session_type_code>
<session_type_description>Dynamics Web</session_type_description>
<physical_session_list>WBS</physical_session_list>
<valid_os_list></valid_os_list>
<inactivity_timeout_period>0</inactivity_timeout_period>
<automatic_reconnect>yes</automatic_reconnect>
<extends_session_type_obj>910752.24</extends_session_type_obj>
<contained_record DB="icfdb" Table="gsm_session_type_property"><session_type_property_obj>910835.24</session_type_property_obj>
<session_type_obj>910756.24</session_type_obj>
<session_property_obj>4622.5498</session_property_obj>
<property_value>No</property_value>
</contained_record>
<contained_record DB="icfdb" Table="gsm_session_type_property"><session_type_property_obj>910883.24</session_type_property_obj>
<session_type_obj>910756.24</session_type_obj>
<session_property_obj>910873.24</session_property_obj>
<property_value>yes</property_value>
</contained_record>
<contained_record DB="icfdb" Table="gsm_session_type_property"><session_type_property_obj>910836.24</session_type_property_obj>
<session_type_obj>910756.24</session_type_obj>
<session_property_obj>1004955844.09</session_property_obj>
<property_value>YES</property_value>
</contained_record>
<contained_record DB="icfdb" Table="gsm_session_type_property"><session_type_property_obj>910840.24</session_type_property_obj>
<session_type_obj>910756.24</session_type_obj>
<session_property_obj>3000000387.09</session_property_obj>
<property_value>NO</property_value>
</contained_record>
<contained_record DB="icfdb" Table="gsm_session_type_property"><session_type_property_obj>910841.24</session_type_property_obj>
<session_type_obj>910756.24</session_type_obj>
<session_property_obj>3000001001.09</session_property_obj>
<property_value>anonymous</property_value>
</contained_record>
<contained_record DB="icfdb" Table="gsm_session_type_property"><session_type_property_obj>910842.24</session_type_property_obj>
<session_type_obj>910756.24</session_type_obj>
<session_property_obj>3000001004.09</session_property_obj>
<property_value></property_value>
</contained_record>
<contained_record DB="icfdb" Table="gsm_session_type_property"><session_type_property_obj>910843.24</session_type_property_obj>
<session_type_obj>910756.24</session_type_obj>
<session_property_obj>3000001006.09</session_property_obj>
<property_value>Yes</property_value>
</contained_record>
<contained_record DB="icfdb" Table="gsm_session_type_property"><session_type_property_obj>910839.24</session_type_property_obj>
<session_type_obj>910756.24</session_type_obj>
<session_property_obj>3000004845.09</session_property_obj>
<property_value>HH:MM:SS</property_value>
</contained_record>
<contained_record DB="icfdb" Table="gsm_session_type_property"><session_type_property_obj>910838.24</session_type_property_obj>
<session_type_obj>910756.24</session_type_obj>
<session_property_obj>3000044734.09</session_property_obj>
<property_value>disabled</property_value>
</contained_record>
<contained_record DB="icfdb" Table="gsm_session_type_property"><session_type_property_obj>910837.24</session_type_property_obj>
<session_type_obj>910756.24</session_type_obj>
<session_property_obj>3000051363.09</session_property_obj>
<property_value>ry/img,../img/</property_value>
</contained_record>
<contained_record DB="icfdb" Table="gsm_required_manager"><required_manager_obj>910793.24</required_manager_obj>
<session_type_obj>910756.24</session_type_obj>
<startup_order>12</startup_order>
<manager_type_obj>3000000310.09</manager_type_obj>
<system_owned>no</system_owned>
</contained_record>
<contained_record DB="icfdb" Table="gsm_required_manager"><required_manager_obj>910794.24</required_manager_obj>
<session_type_obj>910756.24</session_type_obj>
<startup_order>13</startup_order>
<manager_type_obj>3000000308.09</manager_type_obj>
<system_owned>no</system_owned>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="8" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_session_type" version_date="09/24/2003" version_time="61905" version_user="admin" deletion_flag="no" entity_mnemonic="GSMSE" key_field_value="910758.24" record_version_obj="910759.24" version_number_seq="6.24" secondary_key_value="DynCS" import_version_number_seq="6.24"><session_type_obj>910758.24</session_type_obj>
<session_type_code>DynCS</session_type_code>
<session_type_description>Dynamics Client/Server</session_type_description>
<physical_session_list>GUI</physical_session_list>
<valid_os_list></valid_os_list>
<inactivity_timeout_period>0</inactivity_timeout_period>
<automatic_reconnect>yes</automatic_reconnect>
<extends_session_type_obj>910752.24</extends_session_type_obj>
<contained_record DB="icfdb" Table="gsm_session_type_property"><session_type_property_obj>910881.24</session_type_property_obj>
<session_type_obj>910758.24</session_type_obj>
<session_property_obj>910873.24</session_property_obj>
<property_value>yes</property_value>
</contained_record>
<contained_record DB="icfdb" Table="gsm_required_manager"><required_manager_obj>910851.24</required_manager_obj>
<session_type_obj>910758.24</session_type_obj>
<startup_order>12</startup_order>
<manager_type_obj>159203.9875</manager_type_obj>
<system_owned>no</system_owned>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="9" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_session_type" version_date="09/24/2003" version_time="61905" version_user="admin" deletion_flag="no" entity_mnemonic="GSMSE" key_field_value="910760.24" record_version_obj="910761.24" version_number_seq="7.24" secondary_key_value="DynASClient" import_version_number_seq="7.24"><session_type_obj>910760.24</session_type_obj>
<session_type_code>DynASClient</session_type_code>
<session_type_description>Dynamics AppServer Clients</session_type_description>
<physical_session_list>WBC,GUI</physical_session_list>
<valid_os_list></valid_os_list>
<inactivity_timeout_period>0</inactivity_timeout_period>
<automatic_reconnect>yes</automatic_reconnect>
<extends_session_type_obj>910747.24</extends_session_type_obj>
<contained_record DB="icfdb" Table="gsm_session_type_property"><session_type_property_obj>910878.24</session_type_property_obj>
<session_type_obj>910760.24</session_type_obj>
<session_property_obj>910873.24</session_property_obj>
<property_value>yes</property_value>
</contained_record>
<contained_record DB="icfdb" Table="gsm_session_type_property"><session_type_property_obj>910803.24</session_type_property_obj>
<session_type_obj>910760.24</session_type_obj>
<session_property_obj>4622.5498</session_property_obj>
<property_value>YES</property_value>
</contained_record>
<contained_record DB="icfdb" Table="gsm_required_manager"><required_manager_obj>910849.24</required_manager_obj>
<session_type_obj>910760.24</session_type_obj>
<startup_order>12</startup_order>
<manager_type_obj>159203.9875</manager_type_obj>
<system_owned>no</system_owned>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="10" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_session_type" version_date="09/26/2003" version_time="61571" version_user="Admin" deletion_flag="no" entity_mnemonic="GSMSE" key_field_value="910762.24" record_version_obj="910763.24" version_number_seq="22.24" secondary_key_value="DynRTB" import_version_number_seq="22.24"><session_type_obj>910762.24</session_type_obj>
<session_type_code>DynRTB</session_type_code>
<session_type_description>Dynamics Rountable Session Type</session_type_description>
<physical_session_list>GUI</physical_session_list>
<valid_os_list></valid_os_list>
<inactivity_timeout_period>0</inactivity_timeout_period>
<automatic_reconnect>yes</automatic_reconnect>
<extends_session_type_obj>910747.24</extends_session_type_obj>
<contained_record DB="icfdb" Table="gsm_session_type_property"><session_type_property_obj>910795.24</session_type_property_obj>
<session_type_obj>910762.24</session_type_obj>
<session_property_obj>902291.24</session_property_obj>
<property_value>YES</property_value>
</contained_record>
<contained_record DB="icfdb" Table="gsm_session_type_property"><session_type_property_obj>910946.24</session_type_property_obj>
<session_type_obj>910762.24</session_type_obj>
<session_property_obj>910776.24</session_property_obj>
<property_value>NO</property_value>
</contained_record>
<contained_record DB="icfdb" Table="gsm_session_type_property"><session_type_property_obj>910884.24</session_type_property_obj>
<session_type_obj>910762.24</session_type_obj>
<session_property_obj>910873.24</session_property_obj>
<property_value>yes</property_value>
</contained_record>
<contained_record DB="icfdb" Table="gsm_session_type_property"><session_type_property_obj>910800.24</session_type_property_obj>
<session_type_obj>910762.24</session_type_obj>
<session_property_obj>1004955844.09</session_property_obj>
<property_value>YES</property_value>
</contained_record>
<contained_record DB="icfdb" Table="gsm_session_type_property"><session_type_property_obj>910799.24</session_type_property_obj>
<session_type_obj>910762.24</session_type_obj>
<session_property_obj>1131.7692</session_property_obj>
<property_value>templateContainer,templateSmartObject,templateProcedure,templateWebObject</property_value>
</contained_record>
<contained_record DB="icfdb" Table="gsm_session_type_property"><session_type_property_obj>910798.24</session_type_property_obj>
<session_type_obj>910762.24</session_type_obj>
<session_property_obj>1133.7692</session_property_obj>
<property_value>PaletteDynamics</property_value>
</contained_record>
<contained_record DB="icfdb" Table="gsm_session_type_property"><session_type_property_obj>910801.24</session_type_property_obj>
<session_type_obj>910762.24</session_type_obj>
<session_property_obj>4622.5498</session_property_obj>
<property_value>NO</property_value>
</contained_record>
<contained_record DB="icfdb" Table="gsm_required_manager"><required_manager_obj>910796.24</required_manager_obj>
<session_type_obj>910762.24</session_type_obj>
<startup_order>2</startup_order>
<manager_type_obj>3000005352.09</manager_type_obj>
<system_owned>no</system_owned>
</contained_record>
<contained_record DB="icfdb" Table="gsm_required_manager"><required_manager_obj>910797.24</required_manager_obj>
<session_type_obj>910762.24</session_type_obj>
<startup_order>11</startup_order>
<manager_type_obj>3000000378.09</manager_type_obj>
<system_owned>no</system_owned>
</contained_record>
<contained_record DB="icfdb" Table="gsm_required_manager"><required_manager_obj>910852.24</required_manager_obj>
<session_type_obj>910762.24</session_type_obj>
<startup_order>12</startup_order>
<manager_type_obj>159203.9875</manager_type_obj>
<system_owned>no</system_owned>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="11" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_session_type" version_date="09/24/2003" version_time="61905" version_user="admin" deletion_flag="no" entity_mnemonic="GSMSE" key_field_value="910764.24" record_version_obj="910765.24" version_number_seq="18.24" secondary_key_value="DynDevelopment" import_version_number_seq="18.24"><session_type_obj>910764.24</session_type_obj>
<session_type_code>DynDevelopment</session_type_code>
<session_type_description>Dynamics Development</session_type_description>
<physical_session_list></physical_session_list>
<valid_os_list></valid_os_list>
<inactivity_timeout_period>0</inactivity_timeout_period>
<automatic_reconnect>yes</automatic_reconnect>
<extends_session_type_obj>910758.24</extends_session_type_obj>
<contained_record DB="icfdb" Table="gsm_session_type_property"><session_type_property_obj>910785.24</session_type_property_obj>
<session_type_obj>910764.24</session_type_obj>
<session_property_obj>1131.7692</session_property_obj>
<property_value>templateContainer,templateSmartObject,templateProcedure,templateWebObject</property_value>
</contained_record>
<contained_record DB="icfdb" Table="gsm_session_type_property"><session_type_property_obj>910784.24</session_type_property_obj>
<session_type_obj>910764.24</session_type_obj>
<session_property_obj>1133.7692</session_property_obj>
<property_value>PaletteDynamics</property_value>
</contained_record>
<contained_record DB="icfdb" Table="gsm_session_type_property"><session_type_property_obj>910787.24</session_type_property_obj>
<session_type_obj>910764.24</session_type_obj>
<session_property_obj>4622.5498</session_property_obj>
<property_value>NO</property_value>
</contained_record>
<contained_record DB="icfdb" Table="gsm_session_type_property"><session_type_property_obj>910868.24</session_type_property_obj>
<session_type_obj>910764.24</session_type_obj>
<session_property_obj>9031.24</session_property_obj>
<property_value>YES</property_value>
</contained_record>
<contained_record DB="icfdb" Table="gsm_session_type_property"><session_type_property_obj>910786.24</session_type_property_obj>
<session_type_obj>910764.24</session_type_obj>
<session_property_obj>9043.24</session_property_obj>
<property_value>_ab.p</property_value>
</contained_record>
<contained_record DB="icfdb" Table="gsm_session_type_property"><session_type_property_obj>910792.24</session_type_property_obj>
<session_type_obj>910764.24</session_type_obj>
<session_property_obj>149994.9875</session_property_obj>
<property_value>10</property_value>
</contained_record>
<contained_record DB="icfdb" Table="gsm_session_type_property"><session_type_property_obj>910779.24</session_type_property_obj>
<session_type_obj>910764.24</session_type_obj>
<session_property_obj>910776.24</session_property_obj>
<property_value>NO</property_value>
</contained_record>
<contained_record DB="icfdb" Table="gsm_session_type_property"><session_type_property_obj>910882.24</session_type_property_obj>
<session_type_obj>910764.24</session_type_obj>
<session_property_obj>910873.24</session_property_obj>
<property_value>yes</property_value>
</contained_record>
<contained_record DB="icfdb" Table="gsm_required_manager"><required_manager_obj>910781.24</required_manager_obj>
<session_type_obj>910764.24</session_type_obj>
<startup_order>11</startup_order>
<manager_type_obj>3000000378.09</manager_type_obj>
<system_owned>no</system_owned>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="12" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_session_type" version_date="09/24/2003" version_time="40371" version_user="admin" deletion_flag="no" entity_mnemonic="gsmse" key_field_value="910782.24" record_version_obj="910783.24" version_number_seq="2.24" secondary_key_value="ASICFRuntime" import_version_number_seq="2.24"><session_type_obj>910782.24</session_type_obj>
<session_type_code>ASICFRuntime</session_type_code>
<session_type_description>Runtime AppServer</session_type_description>
<physical_session_list>APP</physical_session_list>
<valid_os_list></valid_os_list>
<inactivity_timeout_period>0</inactivity_timeout_period>
<automatic_reconnect>yes</automatic_reconnect>
<extends_session_type_obj>910754.24</extends_session_type_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="13" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_session_type" version_date="09/25/2003" version_time="63053" version_user="Admin" deletion_flag="no" entity_mnemonic="gsmse" key_field_value="1000000011.39" record_version_obj="1000000012.39" version_number_seq="23.24" secondary_key_value="rtb_090dyndep" import_version_number_seq="23.24"><session_type_obj>1000000011.39</session_type_obj>
<session_type_code>rtb_090dyndep</session_type_code>
<session_type_description>Roundtable 090dyn-dep Session</session_type_description>
<physical_session_list>GUI</physical_session_list>
<valid_os_list>WIN32</valid_os_list>
<inactivity_timeout_period>0</inactivity_timeout_period>
<automatic_reconnect>yes</automatic_reconnect>
<extends_session_type_obj>910762.24</extends_session_type_obj>
<contained_record DB="icfdb" Table="gsm_session_service"><session_service_obj>1000000019.39</session_service_obj>
<session_type_obj>1000000011.39</session_type_obj>
<logical_service_obj>1004947455.09</logical_service_obj>
<physical_service_obj>1000000003.39</physical_service_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="14" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_session_type" version_date="09/25/2003" version_time="63053" version_user="Admin" deletion_flag="no" entity_mnemonic="gsmse" key_field_value="1000000013.39" record_version_obj="1000000014.39" version_number_seq="23.24" secondary_key_value="rtb_091dyndep" import_version_number_seq="23.24"><session_type_obj>1000000013.39</session_type_obj>
<session_type_code>rtb_091dyndep</session_type_code>
<session_type_description>Roundtable 091dyn-dep Session</session_type_description>
<physical_session_list>GUI</physical_session_list>
<valid_os_list>WIN32</valid_os_list>
<inactivity_timeout_period>0</inactivity_timeout_period>
<automatic_reconnect>yes</automatic_reconnect>
<extends_session_type_obj>910762.24</extends_session_type_obj>
<contained_record DB="icfdb" Table="gsm_session_service"><session_service_obj>1000000037.39</session_service_obj>
<session_type_obj>1000000013.39</session_type_obj>
<logical_service_obj>1004947455.09</logical_service_obj>
<physical_service_obj>1000000007.39</physical_service_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="15" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_session_type" version_date="09/25/2003" version_time="63053" version_user="Admin" deletion_flag="no" entity_mnemonic="gsmse" key_field_value="1000000015.39" record_version_obj="1000000016.39" version_number_seq="23.24" secondary_key_value="rtb_091dyndev" import_version_number_seq="23.24"><session_type_obj>1000000015.39</session_type_obj>
<session_type_code>rtb_091dyndev</session_type_code>
<session_type_description>Roundtable 091dyn-dev Session</session_type_description>
<physical_session_list>GUI</physical_session_list>
<valid_os_list>WIN32</valid_os_list>
<inactivity_timeout_period>0</inactivity_timeout_period>
<automatic_reconnect>yes</automatic_reconnect>
<extends_session_type_obj>910762.24</extends_session_type_obj>
<contained_record DB="icfdb" Table="gsm_session_service"><session_service_obj>1000000055.39</session_service_obj>
<session_type_obj>1000000015.39</session_type_obj>
<logical_service_obj>1004947455.09</logical_service_obj>
<physical_service_obj>1000000005.39</physical_service_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="16" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_session_type" version_date="09/25/2003" version_time="63053" version_user="Admin" deletion_flag="no" entity_mnemonic="gsmse" key_field_value="1000000017.39" record_version_obj="1000000018.39" version_number_seq="23.24" secondary_key_value="rtb_091dyntst" import_version_number_seq="23.24"><session_type_obj>1000000017.39</session_type_obj>
<session_type_code>rtb_091dyntst</session_type_code>
<session_type_description>Roundtable 091dyn-tst Session</session_type_description>
<physical_session_list>GUI</physical_session_list>
<valid_os_list>WIN32</valid_os_list>
<inactivity_timeout_period>0</inactivity_timeout_period>
<automatic_reconnect>yes</automatic_reconnect>
<extends_session_type_obj>910762.24</extends_session_type_obj>
<contained_record DB="icfdb" Table="gsm_session_service"><session_service_obj>1000000073.39</session_service_obj>
<session_type_obj>1000000017.39</session_type_obj>
<logical_service_obj>1004947455.09</logical_service_obj>
<physical_service_obj>1000000009.39</physical_service_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="17" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_session_type" version_date="09/24/2003" version_time="40372" version_user="admin" deletion_flag="no" entity_mnemonic="GSMSE" key_field_value="1004947449.09" record_version_obj="3000005384.09" version_number_seq="23.24" secondary_key_value="ICFDevAS" import_version_number_seq="23.24"><session_type_obj>1004947449.09</session_type_obj>
<session_type_code>ICFDevAS</session_type_code>
<session_type_description>Dynamics Development with AS</session_type_description>
<physical_session_list>GUI</physical_session_list>
<valid_os_list>WIN32</valid_os_list>
<inactivity_timeout_period>0</inactivity_timeout_period>
<automatic_reconnect>yes</automatic_reconnect>
<extends_session_type_obj>910764.24</extends_session_type_obj>
<contained_record DB="icfdb" Table="gsm_session_type_property"><session_type_property_obj>1005079052.09</session_type_property_obj>
<session_type_obj>1004947449.09</session_type_obj>
<session_property_obj>1004955844.09</session_property_obj>
<property_value>NO</property_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="18" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_session_type" version_date="09/24/2003" version_time="40371" version_user="admin" deletion_flag="no" entity_mnemonic="GSMSE" key_field_value="1004947452.09" record_version_obj="4625.5498" version_number_seq="16.24" secondary_key_value="ASICFDev" import_version_number_seq="16.24"><session_type_obj>1004947452.09</session_type_obj>
<session_type_code>ASICFDev</session_type_code>
<session_type_description>AppServer Service Type for ICF Dev</session_type_description>
<physical_session_list>APP</physical_session_list>
<valid_os_list>WIN32,UNIX</valid_os_list>
<inactivity_timeout_period>0</inactivity_timeout_period>
<automatic_reconnect>yes</automatic_reconnect>
<extends_session_type_obj>910754.24</extends_session_type_obj>
<contained_record DB="icfdb" Table="gsm_required_manager"><required_manager_obj>3000000380.09</required_manager_obj>
<session_type_obj>1004947452.09</session_type_obj>
<startup_order>10</startup_order>
<manager_type_obj>3000000378.09</manager_type_obj>
<system_owned>yes</system_owned>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="19" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_session_type" version_date="09/24/2003" version_time="40372" version_user="admin" deletion_flag="no" entity_mnemonic="GSMSE" key_field_value="1004955892.09" record_version_obj="149998.9875" version_number_seq="13.24" secondary_key_value="ICFRuntime" import_version_number_seq="13.24"><session_type_obj>1004955892.09</session_type_obj>
<session_type_code>ICFRuntime</session_type_code>
<session_type_description>Dynamics Run Time Environment</session_type_description>
<physical_session_list>GUI,WBC</physical_session_list>
<valid_os_list>WIN32</valid_os_list>
<inactivity_timeout_period>0</inactivity_timeout_period>
<automatic_reconnect>yes</automatic_reconnect>
<extends_session_type_obj>910760.24</extends_session_type_obj>
<contained_record DB="icfdb" Table="gsm_session_type_property"><session_type_property_obj>149997.9875</session_type_property_obj>
<session_type_obj>1004955892.09</session_type_obj>
<session_property_obj>149994.9875</session_property_obj>
<property_value>10</property_value>
</contained_record>
<contained_record DB="icfdb" Table="gsm_session_type_property"><session_type_property_obj>1005079480.09</session_type_property_obj>
<session_type_obj>1004955892.09</session_type_obj>
<session_property_obj>1004956689.09</session_property_obj>
<property_value>ICFOBJ|afallmencw</property_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="20" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_session_type" version_date="09/24/2003" version_time="40371" version_user="admin" deletion_flag="no" entity_mnemonic="GSMSE" key_field_value="1005079481.09" record_version_obj="4627.5498" version_number_seq="14.24" secondary_key_value="Default" import_version_number_seq="14.24"><session_type_obj>1005079481.09</session_type_obj>
<session_type_code>Default</session_type_code>
<session_type_description>Default Session Type</session_type_description>
<physical_session_list>GUI</physical_session_list>
<valid_os_list>WIN32</valid_os_list>
<inactivity_timeout_period>0</inactivity_timeout_period>
<automatic_reconnect>yes</automatic_reconnect>
<extends_session_type_obj>910758.24</extends_session_type_obj>
<contained_record DB="icfdb" Table="gsm_session_type_property"><session_type_property_obj>4626.5498</session_type_property_obj>
<session_type_obj>1005079481.09</session_type_obj>
<session_property_obj>4622.5498</session_property_obj>
<property_value>YES</property_value>
</contained_record>
<contained_record DB="icfdb" Table="gsm_session_type_property"><session_type_property_obj>1005079493.09</session_type_property_obj>
<session_type_obj>1005079481.09</session_type_obj>
<session_property_obj>1004956689.09</session_property_obj>
<property_value>ICFOBJ|afallmencw</property_value>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="21" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_session_type" version_date="09/24/2003" version_time="40372" version_user="admin" deletion_flag="no" entity_mnemonic="GSMSE" key_field_value="1005080066.09" record_version_obj="1526.7692" version_number_seq="24.24" secondary_key_value="ICFDev" import_version_number_seq="24.24"><session_type_obj>1005080066.09</session_type_obj>
<session_type_code>ICFDev</session_type_code>
<session_type_description>Dynamics Development Environment</session_type_description>
<physical_session_list>GUI</physical_session_list>
<valid_os_list>WIN32</valid_os_list>
<inactivity_timeout_period>0</inactivity_timeout_period>
<automatic_reconnect>yes</automatic_reconnect>
<extends_session_type_obj>910764.24</extends_session_type_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="22" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_session_type" version_date="09/24/2003" version_time="40372" version_user="admin" deletion_flag="no" entity_mnemonic="GSMSE" key_field_value="3000000314.09" record_version_obj="3000000315.09" version_number_seq="35.24" secondary_key_value="ICFWS" import_version_number_seq="35.24"><session_type_obj>3000000314.09</session_type_obj>
<session_type_code>ICFWS</session_type_code>
<session_type_description>ICF WebSpeed Session</session_type_description>
<physical_session_list>WBS,APP</physical_session_list>
<valid_os_list>WIN32,UNIX</valid_os_list>
<inactivity_timeout_period>0</inactivity_timeout_period>
<automatic_reconnect>yes</automatic_reconnect>
<extends_session_type_obj>910756.24</extends_session_type_obj>
</contained_record>
</dataset_transaction>
</dataset_records>
</dataset>