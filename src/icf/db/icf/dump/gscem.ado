<?xml version="1.0" encoding="ISO8859-1" ?>
<dataset Transactions="140" version_date="02/23/2002" version_time="42922" version_user="admin" entity_mnemonic="GSTDF" key_field_value="3000000373.09" record_version_obj="3000000374.09" version_number_seq="2.09" import_version_number_seq="1.09"><dataset_header DisableRI="yes" DatasetObj="1007600196.08" DateFormat="mdy" FullHeader="yes" SCMManaged="no" YearOffset="1950" DatasetCode="GSCEM" DateCreated="02/23/2002" TimeCreated="11:55:08" NumericFormat="AMERICAN" NumericDecimal="." OriginatingSite="93" NumericSeparator=","><deploy_dataset_obj>1007600196.08</deploy_dataset_obj>
<owner_site_code></owner_site_code>
<dataset_code>GSCEM</dataset_code>
<dataset_description>gsc_entity_mnemonic - Entity Mnemon</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<dataset_entity><dataset_entity_obj>1007600197.08</dataset_entity_obj>
<deploy_dataset_obj>1007600196.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSCEM</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>entity_mnemonic</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<entity_mnemonic_description>gsc_entity_mnemonic</entity_mnemonic_description>
<entity_dbname>icfdb</entity_dbname>
</dataset_entity>
<dataset_entity><dataset_entity_obj>1007600198.08</dataset_entity_obj>
<deploy_dataset_obj>1007600196.08</deploy_dataset_obj>
<entity_sequence>2</entity_sequence>
<entity_mnemonic>GSCED</entity_mnemonic>
<primary_entity>no</primary_entity>
<join_entity_mnemonic>GSCEM</join_entity_mnemonic>
<join_field_list>entity_mnemonic,entity_mnemonic</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<entity_mnemonic_description>gsc_entity_display_field</entity_mnemonic_description>
<entity_dbname>icfdb</entity_dbname>
</dataset_entity>
<table_definition><name>gsc_entity_mnemonic</name>
<dbname>ICFDB</dbname>
<index-1>XAK1gsc_entity_mnemonic,1,0,0,entity_mnemonic_obj,0</index-1>
<index-2>XIE1gsc_entity_mnemonic,0,0,0,entity_mnemonic_short_desc,0</index-2>
<index-3>XIE2gsc_entity_mnemonic,0,0,0,entity_mnemonic_description,0</index-3>
<index-4>XIE3gsc_entity_mnemonic,0,0,0,deploy_data,0,entity_mnemonic,0</index-4>
<index-5>XIE4gsc_entity_mnemonic,0,0,0,replicate_entity_mnemonic,0</index-5>
<index-6>XIE5gsc_entity_mnemonic,0,0,0,version_data,0,entity_mnemonic,0</index-6>
<index-7>XPKgsc_entity_mnemonic,1,1,0,entity_mnemonic,0</index-7>
<field><name>entity_mnemonic</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(8)</format>
<initial></initial>
<label>Entity Mnemonic</label>
<column-label>Entity Mnemonic</column-label>
</field>
<field><name>entity_mnemonic_short_desc</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>Entity Mnemonic Short Description</label>
<column-label>Entity Mnemonic Short Desc</column-label>
</field>
<field><name>entity_mnemonic_description</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>Entity Mnemonic Description</label>
<column-label>Entity Mnemonic Description</column-label>
</field>
<field><name>auto_properform_strings</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>Auto Properform Strings</label>
<column-label>Auto Properform Strings</column-label>
</field>
<field><name>entity_mnemonic_label_prefix</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(28)</format>
<initial></initial>
<label>Entity Mnemonic Label Prefix</label>
<column-label>Entity Mnemonic Label Prefix</column-label>
</field>
<field><name>entity_mnemonic_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>>>>>>>>>>>>>>>>>>9.999999999</format>
<initial>                 0.000000000</initial>
<label>Entity Mnemonic Obj</label>
<column-label>Entity Mnemonic Obj</column-label>
</field>
<field><name>entity_description_field</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Entity Description Field</label>
<column-label>Entity Description Field</column-label>
</field>
<field><name>entity_description_procedure</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Entity Description Procedure</label>
<column-label>Entity Description Procedure</column-label>
</field>
<field><name>entity_narration</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(500)</format>
<initial></initial>
<label>Entity Narration</label>
<column-label>Entity Narration</column-label>
</field>
<field><name>entity_object_field</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>Entity Object Field</label>
<column-label>Entity Object Field</column-label>
</field>
<field><name>table_has_object_field</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>YES</initial>
<label>Table Has Object Field</label>
<column-label>Table Has Object Field</column-label>
</field>
<field><name>entity_key_field</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>Entity Key Field</label>
<column-label>Entity Key Field</column-label>
</field>
<field><name>table_prefix_length</name>
<data-type>integer</data-type>
<extent>0</extent>
<format>->9</format>
<initial>  0</initial>
<label>Table Prefix Length</label>
<column-label>Table Prefix Length</column-label>
</field>
<field><name>field_name_separator</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(10)</format>
<initial></initial>
<label>Field Name Separator</label>
<column-label>Field Name Separator</column-label>
</field>
<field><name>auditing_enabled</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>Auditing Enabled</label>
<column-label>Auditing Enabled</column-label>
</field>
<field><name>version_data</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>Version Data</label>
<column-label>Version Data</column-label>
</field>
<field><name>deploy_data</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>Deploy Data</label>
<column-label>Deploy Data</column-label>
</field>
<field><name>entity_dbname</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>Entity Dbname</label>
<column-label>Entity Dbname</column-label>
</field>
<field><name>replicate_entity_mnemonic</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(8)</format>
<initial></initial>
<label>Replicate Entity Mnemonic</label>
<column-label>Replicate Entity Mnemonic</column-label>
</field>
<field><name>replicate_key</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Replicate Key</label>
<column-label>Replicate Key</column-label>
</field>
<field><name>scm_field_name</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>Scm Field Name</label>
<column-label>Scm Field Name</column-label>
</field>
</table_definition>
<table_definition><name>gsc_entity_display_field</name>
<dbname>ICFDB</dbname>
<index-1>XAK1gsc_entity_display_field,1,0,0,entity_mnemonic,0,display_field_name,0</index-1>
<index-2>XAK2gsc_entity_display_field,1,0,0,entity_mnemonic,0,display_field_order,0,display_field_name,0</index-2>
<index-3>XPKgsc_entity_display_field,1,1,0,entity_display_field_obj,0</index-3>
<field><name>entity_display_field_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>>>>>>>>>>>>>>>>>>9.999999999</format>
<initial>                 0.000000000</initial>
<label>Entity Display Field Obj</label>
<column-label>Entity Display Field Obj</column-label>
</field>
<field><name>entity_mnemonic</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(8)</format>
<initial></initial>
<label>Entity Mnemonic</label>
<column-label>Entity Mnemonic</column-label>
</field>
<field><name>display_field_name</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>Display Field Name</label>
<column-label>Display Field Name</column-label>
</field>
<field><name>display_field_order</name>
<data-type>integer</data-type>
<extent>0</extent>
<format>->>>>>9</format>
<initial>      0</initial>
<label>Display Field Order</label>
<column-label>Display Field Order</column-label>
</field>
<field><name>display_field_label</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(28)</format>
<initial></initial>
<label>Display Field Label</label>
<column-label>Display Field Label</column-label>
</field>
<field><name>display_field_column_label</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(28)</format>
<initial></initial>
<label>Display Field Column Label</label>
<column-label>Display Field Column Label</column-label>
</field>
<field><name>display_field_format</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>Display Field Format</label>
<column-label>Display Field Format</column-label>
</field>
</table_definition>
</dataset_header>
<dataset_records><dataset_transaction TransactionNo="1"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSCCP</entity_mnemonic>
<entity_mnemonic_short_desc>custom procedure</entity_mnemonic_short_desc>
<entity_mnemonic_description>gsc_custom_procedure</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>41</entity_mnemonic_obj>
<entity_description_field>procedure_name</entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>Due to the complexity and variety of certain business processes, such as calculating contribution amounts, determining limits, etc. parameterisation of these processes becomes impractical.
This table contains a list of all the system supported procedures that satisfy these business rules, categorised by entity and procedure type. A number of variations for each process may exist - the procedure to use in each case must be selected from this list.

The programs that these procedures exist in will run persistently when required.</entity_narration>
<entity_object_field>custom_procedure_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="2"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSCDC</entity_mnemonic>
<entity_mnemonic_short_desc>default code</entity_mnemonic_short_desc>
<entity_mnemonic_description>gsc_default_code</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004947239.09</entity_mnemonic_obj>
<entity_description_field>field_name</entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This table makes provision for any number of parameters or system defaults that need be specified to the system, without neccessitating structural database changes.

How these parameters / defaults are used needs to be hard coded into the application.

These records can be grouped into sets under gsc_default_set, to facilitate different parameter / defaults sets. Again, the selection of a default set would be coded into the application.

An example would be different parameter sets for warehouse control, different controls per administration group etc.</entity_narration>
<entity_object_field>default_code_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="3"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSCDD</entity_mnemonic>
<entity_mnemonic_short_desc>deploy dataset</entity_mnemonic_short_desc>
<entity_mnemonic_description>gsc_deploy_dataset</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004927719.09</entity_mnemonic_obj>
<entity_description_field>dataset_description</entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This table defines the sets of data that need to be deployed to end-user sites and migrated to different workspace databases. Usually it is static data that needs to be deployed. This table with its child table gsc_dataset_entity identify which data must be deployed as a set, i.e. has dependancies. For example, in order to deploy menu items, objects on the menu item would also need to be deployed.

These tables also define the dataset for deployment of logical objects managed by the scm tool, e.g. the ryc_smartobject and related tables.

To deploy and load the data, xml files will be generated for the dataset.

The dataset must always have a main table that is being deployed, plus all related tables that need to be deployed with it, together with appropriate join information.

Example datasets could be for SmartObjects, menus, objects, etc. It is likely that a seperate dataset will be defined for most data tables that need to be deployed, but that these datasets will include a parent dataset that includes this dataset.

When automatically generating triggers from ERWin an entity-level UDP (DeployData) is used to indicate whether trigger code should be generated for the static tables to support data deployment. A flag also exists in the entity mnemonic table called deploy_data for the same purpose.

For customer sites that receive a dataset deployment, the last deployment loaded for this dataset is record here. This helps identify at what version the current static data is for a particular database.

Customers should not modify or deploy from datasets sent by suppliers. The customer can however create their own datasets containing the same tables and deploy from these datasets. As a dataset deployment includes an xml file registered as part of the deployment, the customer can simply utilise this xml file for their database and any subsequent databases and sites they wish to pass the data on to.</entity_narration>
<entity_object_field>deploy_dataset_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field>dataset_code</entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
<contained_record DB="ICFDB" Table="gsc_entity_display_field"><entity_display_field_obj>4611.24</entity_display_field_obj>
<entity_mnemonic>GSCDD</entity_mnemonic>
<display_field_name>dataset_code</display_field_name>
<display_field_order>2</display_field_order>
<display_field_label></display_field_label>
<display_field_column_label></display_field_column_label>
<display_field_format></display_field_format>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_entity_display_field"><entity_display_field_obj>4612.24</entity_display_field_obj>
<entity_mnemonic>GSCDD</entity_mnemonic>
<display_field_name>dataset_description</display_field_name>
<display_field_order>3</display_field_order>
<display_field_label></display_field_label>
<display_field_column_label></display_field_column_label>
<display_field_format></display_field_format>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_entity_display_field"><entity_display_field_obj>4617.24</entity_display_field_obj>
<entity_mnemonic>GSCDD</entity_mnemonic>
<display_field_name>default_ado_filename</display_field_name>
<display_field_order>8</display_field_order>
<display_field_label></display_field_label>
<display_field_column_label></display_field_column_label>
<display_field_format></display_field_format>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_entity_display_field"><entity_display_field_obj>4615.24</entity_display_field_obj>
<entity_mnemonic>GSCDD</entity_mnemonic>
<display_field_name>deploy_full_data</display_field_name>
<display_field_order>6</display_field_order>
<display_field_label></display_field_label>
<display_field_column_label></display_field_column_label>
<display_field_format></display_field_format>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_entity_display_field"><entity_display_field_obj>4613.24</entity_display_field_obj>
<entity_mnemonic>GSCDD</entity_mnemonic>
<display_field_name>disable_ri</display_field_name>
<display_field_order>4</display_field_order>
<display_field_label></display_field_label>
<display_field_column_label></display_field_column_label>
<display_field_format></display_field_format>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_entity_display_field"><entity_display_field_obj>4610.24</entity_display_field_obj>
<entity_mnemonic>GSCDD</entity_mnemonic>
<display_field_name>owner_site_code</display_field_name>
<display_field_order>1</display_field_order>
<display_field_label></display_field_label>
<display_field_column_label></display_field_column_label>
<display_field_format></display_field_format>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_entity_display_field"><entity_display_field_obj>4614.24</entity_display_field_obj>
<entity_mnemonic>GSCDD</entity_mnemonic>
<display_field_name>source_code_data</display_field_name>
<display_field_order>5</display_field_order>
<display_field_label></display_field_label>
<display_field_column_label></display_field_column_label>
<display_field_format></display_field_format>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_entity_display_field"><entity_display_field_obj>4616.24</entity_display_field_obj>
<entity_mnemonic>GSCDD</entity_mnemonic>
<display_field_name>xml_generation_procedure</display_field_name>
<display_field_order>7</display_field_order>
<display_field_label></display_field_label>
<display_field_column_label></display_field_column_label>
<display_field_format></display_field_format>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="4"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSCDE</entity_mnemonic>
<entity_mnemonic_short_desc>dataset entity</entity_mnemonic_short_desc>
<entity_mnemonic_description>gsc_dataset_entity</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004927718.09</entity_mnemonic_obj>
<entity_description_field></entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This table contains a complete list of tables that need to be deployed with the  dataset.

One of the tables in the dataset must be marked as primary, i.e. the main table in the dataset. The join information between the tables must also be specified.

The data in this table can be filtered using the filter where clause.</entity_narration>
<entity_object_field>dataset_entity_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field>dataset_entity_obj</entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
<contained_record DB="ICFDB" Table="gsc_entity_display_field"><entity_display_field_obj>4607.24</entity_display_field_obj>
<entity_mnemonic>GSCDE</entity_mnemonic>
<display_field_name>delete_related_records</display_field_name>
<display_field_order>7</display_field_order>
<display_field_label></display_field_label>
<display_field_column_label></display_field_column_label>
<display_field_format></display_field_format>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_entity_display_field"><entity_display_field_obj>4602.24</entity_display_field_obj>
<entity_mnemonic>GSCDE</entity_mnemonic>
<display_field_name>entity_mnemonic</display_field_name>
<display_field_order>2</display_field_order>
<display_field_label></display_field_label>
<display_field_column_label></display_field_column_label>
<display_field_format></display_field_format>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_entity_display_field"><entity_display_field_obj>4601.24</entity_display_field_obj>
<entity_mnemonic>GSCDE</entity_mnemonic>
<display_field_name>entity_sequence</display_field_name>
<display_field_order>1</display_field_order>
<display_field_label></display_field_label>
<display_field_column_label></display_field_column_label>
<display_field_format></display_field_format>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_entity_display_field"><entity_display_field_obj>4606.24</entity_display_field_obj>
<entity_mnemonic>GSCDE</entity_mnemonic>
<display_field_name>filter_where_clause</display_field_name>
<display_field_order>6</display_field_order>
<display_field_label></display_field_label>
<display_field_column_label></display_field_column_label>
<display_field_format></display_field_format>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_entity_display_field"><entity_display_field_obj>4604.24</entity_display_field_obj>
<entity_mnemonic>GSCDE</entity_mnemonic>
<display_field_name>join_entity_mnemonic</display_field_name>
<display_field_order>4</display_field_order>
<display_field_label></display_field_label>
<display_field_column_label></display_field_column_label>
<display_field_format></display_field_format>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_entity_display_field"><entity_display_field_obj>4605.24</entity_display_field_obj>
<entity_mnemonic>GSCDE</entity_mnemonic>
<display_field_name>join_field_list</display_field_name>
<display_field_order>5</display_field_order>
<display_field_label></display_field_label>
<display_field_column_label></display_field_column_label>
<display_field_format></display_field_format>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_entity_display_field"><entity_display_field_obj>4609.24</entity_display_field_obj>
<entity_mnemonic>GSCDE</entity_mnemonic>
<display_field_name>keep_own_site_data</display_field_name>
<display_field_order>9</display_field_order>
<display_field_label></display_field_label>
<display_field_column_label></display_field_column_label>
<display_field_format></display_field_format>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_entity_display_field"><entity_display_field_obj>4608.24</entity_display_field_obj>
<entity_mnemonic>GSCDE</entity_mnemonic>
<display_field_name>overwrite_records</display_field_name>
<display_field_order>8</display_field_order>
<display_field_label></display_field_label>
<display_field_column_label></display_field_column_label>
<display_field_format></display_field_format>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_entity_display_field"><entity_display_field_obj>4603.24</entity_display_field_obj>
<entity_mnemonic>GSCDE</entity_mnemonic>
<display_field_name>primary_entity</display_field_name>
<display_field_order>3</display_field_order>
<display_field_label></display_field_label>
<display_field_column_label></display_field_column_label>
<display_field_format></display_field_format>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="5"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSCDM</entity_mnemonic>
<entity_mnemonic_short_desc>delivery method</entity_mnemonic_short_desc>
<entity_mnemonic_description>gsc_delivery_method</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924364.09</entity_mnemonic_obj>
<entity_description_field>delivery_method_description</entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>The supported methods of delivery, e.g. by hand, post, email, collection, etc.</entity_narration>
<entity_object_field>delivery_method_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field>delivery_method_tla</entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="6"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSCDP</entity_mnemonic>
<entity_mnemonic_short_desc>deploy package</entity_mnemonic_short_desc>
<entity_mnemonic_description>gsc_deploy_package</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>4618.24</entity_mnemonic_obj>
<entity_description_field>package_description</entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This table facilitates defining groups of datasets that should be deployed together as a single package. This enables users to ensure they send all related datasets inclduing related / dependant data that has also changed.</entity_narration>
<entity_object_field>deploy_package_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field>package_code</entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>ICFDB</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
<contained_record DB="ICFDB" Table="gsc_entity_display_field"><entity_display_field_obj>4619.24</entity_display_field_obj>
<entity_mnemonic>GSCDP</entity_mnemonic>
<display_field_name>package_code</display_field_name>
<display_field_order>1</display_field_order>
<display_field_label></display_field_label>
<display_field_column_label></display_field_column_label>
<display_field_format></display_field_format>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_entity_display_field"><entity_display_field_obj>4620.24</entity_display_field_obj>
<entity_mnemonic>GSCDP</entity_mnemonic>
<display_field_name>package_description</display_field_name>
<display_field_order>2</display_field_order>
<display_field_label></display_field_label>
<display_field_column_label></display_field_column_label>
<display_field_format></display_field_format>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="7"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSCDS</entity_mnemonic>
<entity_mnemonic_short_desc>default set</entity_mnemonic_short_desc>
<entity_mnemonic_description>gsc_default_set</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924362.09</entity_mnemonic_obj>
<entity_description_field>default_set_description</entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This table is used to associate a set of parameters / defaults i.e. a set of gsc_default_code records.

For example, there could be a general set of defaults applicable to the system in general, and other sets of defaults to be used in certain circumstances e.g. for a specific department.

The way these sets are used must be hard coded into the application.</entity_narration>
<entity_object_field>default_set_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field>default_set_code</entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="8"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSCDT</entity_mnemonic>
<entity_mnemonic_short_desc>document type</entity_mnemonic_short_desc>
<entity_mnemonic_description>gsc_document_type</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924365.09</entity_mnemonic_obj>
<entity_description_field>document_type_description</entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>The document types supported by the system. Certain document types will be hard coded as they form an integral part of the application, e.g. membership cards, etc.

Each document type will have one or more document formats associated with a customised formatting procedure.

A document type should be set up for any outgoing documents.

We need to know the document_type_tla for system owned document types as this will be used in any print_option_tlas fields to determine where certain data should be printed.

</entity_narration>
<entity_object_field>document_type_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field>document_type_tla</entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="9"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSCDU</entity_mnemonic>
<entity_mnemonic_short_desc>default set usage</entity_mnemonic_short_desc>
<entity_mnemonic_description>gsc_default_set_usage</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924363.09</entity_mnemonic_obj>
<entity_description_field></entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This table associates default sets with objects in the application.

For example, in property administration, a default set could be for a specific administration company. In medical aid, a default set could be for a specific scheme option, employer group etc.</entity_narration>
<entity_object_field>default_set_usage_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="10"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSCED</entity_mnemonic>
<entity_mnemonic_short_desc>entity display field</entity_mnemonic_short_desc>
<entity_mnemonic_description>gsc_entity_display_field</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1005079469.09</entity_mnemonic_obj>
<entity_description_field>display_field_name</entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This table defines the fields for a table that should be used when building generic objects for it, e.g. a dynamic browser.

It identifies the fields that should be used, the sequence of the fields, plus allows the label and format of the fields to be overridden.

This is actually used in the generic data security used by the framework. 

If no entries exist in this table, then all the fields other than any object fields will be used, in the standard field order as defined in the database.

This table should initially be populated automatically from the metaschema but may then be modified accordingly.

This table does not support joined fields.
</entity_narration>
<entity_object_field>entity_display_field_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
<contained_record DB="ICFDB" Table="gsc_entity_display_field"><entity_display_field_obj>1005079474.09</entity_display_field_obj>
<entity_mnemonic>GSCED</entity_mnemonic>
<display_field_name>display_field_column_label</display_field_name>
<display_field_order>8</display_field_order>
<display_field_label></display_field_label>
<display_field_column_label></display_field_column_label>
<display_field_format></display_field_format>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_entity_display_field"><entity_display_field_obj>1005079475.09</entity_display_field_obj>
<entity_mnemonic>GSCED</entity_mnemonic>
<display_field_name>display_field_format</display_field_name>
<display_field_order>7</display_field_order>
<display_field_label></display_field_label>
<display_field_column_label></display_field_column_label>
<display_field_format></display_field_format>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_entity_display_field"><entity_display_field_obj>1005079473.09</entity_display_field_obj>
<entity_mnemonic>GSCED</entity_mnemonic>
<display_field_name>display_field_label</display_field_name>
<display_field_order>6</display_field_order>
<display_field_label></display_field_label>
<display_field_column_label></display_field_column_label>
<display_field_format></display_field_format>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_entity_display_field"><entity_display_field_obj>1005079471.09</entity_display_field_obj>
<entity_mnemonic>GSCED</entity_mnemonic>
<display_field_name>display_field_name</display_field_name>
<display_field_order>4</display_field_order>
<display_field_label></display_field_label>
<display_field_column_label></display_field_column_label>
<display_field_format></display_field_format>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_entity_display_field"><entity_display_field_obj>1005079472.09</entity_display_field_obj>
<entity_mnemonic>GSCED</entity_mnemonic>
<display_field_name>display_field_order</display_field_name>
<display_field_order>5</display_field_order>
<display_field_label></display_field_label>
<display_field_column_label></display_field_column_label>
<display_field_format></display_field_format>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_entity_display_field"><entity_display_field_obj>1005079470.09</entity_display_field_obj>
<entity_mnemonic>GSCED</entity_mnemonic>
<display_field_name>entity_mnemonic</display_field_name>
<display_field_order>3</display_field_order>
<display_field_label></display_field_label>
<display_field_column_label></display_field_column_label>
<display_field_format></display_field_format>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="11"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSCEM</entity_mnemonic>
<entity_mnemonic_short_desc>entity mnemonic</entity_mnemonic_short_desc>
<entity_mnemonic_description>gsc_entity_mnemonic</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924406.09</entity_mnemonic_obj>
<entity_description_field>entity_mnemonic_description</entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This table stores all the hard coded entity mnemonics allocated to every table in the application. It defines a meaningful short code and identifies the table name for each table.

It also defines generic information about the entity used when generating dynamic or generic objects based on the table, auto generating triggers, etc.</entity_narration>
<entity_object_field>entity_mnemonic_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
<contained_record DB="ICFDB" Table="gsc_entity_display_field"><entity_display_field_obj>1005079466.09</entity_display_field_obj>
<entity_mnemonic>GSCEM</entity_mnemonic>
<display_field_name>entity_mnemonic</display_field_name>
<display_field_order>3</display_field_order>
<display_field_label></display_field_label>
<display_field_column_label></display_field_column_label>
<display_field_format></display_field_format>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_entity_display_field"><entity_display_field_obj>1005079468.09</entity_display_field_obj>
<entity_mnemonic>GSCEM</entity_mnemonic>
<display_field_name>entity_mnemonic_description</display_field_name>
<display_field_order>5</display_field_order>
<display_field_label>Table Name</display_field_label>
<display_field_column_label>Table Name</display_field_column_label>
<display_field_format></display_field_format>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_entity_display_field"><entity_display_field_obj>1005079467.09</entity_display_field_obj>
<entity_mnemonic>GSCEM</entity_mnemonic>
<display_field_name>entity_mnemonic_short_desc</display_field_name>
<display_field_order>4</display_field_order>
<display_field_label></display_field_label>
<display_field_column_label></display_field_column_label>
<display_field_format></display_field_format>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="12"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSCEP</entity_mnemonic>
<entity_mnemonic_short_desc>entity mnemonic procedure</entity_mnemonic_short_desc>
<entity_mnemonic_description>gsc_entity_mnemonic_procedure</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924366.09</entity_mnemonic_obj>
<entity_description_field></entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This table contains pointers to procedures which may be automatically run by the system before and after table create, write and delete triggers.

The procedures would exist under a single category type with 6 category groups:
Before create
After create
Before write
After write
Before delete
After delete.</entity_narration>
<entity_object_field>entity_mnemonic_procedure_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="13"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSCER</entity_mnemonic>
<entity_mnemonic_short_desc>error</entity_mnemonic_short_desc>
<entity_mnemonic_description>gsc_error</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924407.09</entity_mnemonic_obj>
<entity_description_field>error_summary_description</entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This table defines all the application errors that can occur, together with summary and full descriptions.

The summary description will be shown first, with an option to display a fuller description if available.

The use of error codes from this table facilitates the customisation of error messages.

This table now supports any kind of message to the user. No messages should be hard coded in the application at all, every message to the user should be channelled through here. Supported message types are:

MES = Message
INF = Information
ERR = Error
WAR = Warning
QUE = Question

The default is ERR for Error if nothing is set-up.

Errors in multiple langages are also supported if required.
</entity_narration>
<entity_object_field>error_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="14"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSCGC</entity_mnemonic>
<entity_mnemonic_short_desc>global control</entity_mnemonic_short_desc>
<entity_mnemonic_description>gsc_global_control</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924367.09</entity_mnemonic_obj>
<entity_description_field></entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This table defines system wide defaults. It contains a single record within which to hold the current system defaults.
</entity_narration>
<entity_object_field>global_control_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="15"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSCGD</entity_mnemonic>
<entity_mnemonic_short_desc>global default</entity_mnemonic_short_desc>
<entity_mnemonic_description>gsc_global_default</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924368.09</entity_mnemonic_obj>
<entity_description_field></entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This table contains global default values across the entire application. It differes from the parameter file in that the parameter file is specific to a user, whereas entries in this table are system wide.

Standard entries exist in the gsc_global_control table. This table facilitates the generic addition of other defaults without the need for database change. The entries in this table will be system owned by ther nature, and the only fields that may change are the owning_obj and the default_value. The changing of any of these values will create a new record for the owning_entity_mnemonic and default_type, efffective as of the new date with the new values.

Entries may not therefore be deleted from this table, other than by a system administrator.</entity_narration>
<entity_object_field>global_default_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="16"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSCIA</entity_mnemonic>
<entity_mnemonic_short_desc>instance attribute</entity_mnemonic_short_desc>
<entity_mnemonic_description>gsc_instance_attribute</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924408.09</entity_mnemonic_obj>
<entity_description_field>attribute_description</entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This table contains instance attributes used in the application. Instance attributes change the behaviour of generic objects. For example, a generic object could be developed that behaved differently in a creditors and debtors system. An instance attribute of creditor or debtor could be posted to the program when run to determine its instance specific functionality.

The instance attribute will be posted to the program either via the menu option the program was run from, as setup in the menu option, or hard coded in a program if the program was run from a button, etc.

For this reason, certain instance attributes will be system owned and cannot be maintained / deleted by users.

When security structures e.g. field security are setup, they may be defined globally, for a specific product, product module or down to individual program level. The instance attribute is a level below the program level that permits security settings per instance of a program.

Instance attributes will also be used for reporting to allow reports to be printed direct from menu options. The instance attribute code must map to the report_procedure_name in the report_definition table. Whenever a report definition is created, an instance attribute should automatically be created to facilitate this functionality.

</entity_narration>
<entity_object_field>instance_attribute_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field>attribute_code</entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="17"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSCIC</entity_mnemonic>
<entity_mnemonic_short_desc>item category</entity_mnemonic_short_desc>
<entity_mnemonic_description>gsc_item_category</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1007600146.08</entity_mnemonic_obj>
<entity_description_field>item_category_description</entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This table is used to categorize items into common groups. Typical groups may be ADM Navigation, ADM TableIO or  ADM Menu . Categories may also be used to group items into module specific areas.</entity_narration>
<entity_object_field>item_category_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field>item_category_obj</entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>ICFDB</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
<contained_record DB="ICFDB" Table="gsc_entity_display_field"><entity_display_field_obj>1007600148.08</entity_display_field_obj>
<entity_mnemonic>GSCIC</entity_mnemonic>
<display_field_name>item_category_description</display_field_name>
<display_field_order>4</display_field_order>
<display_field_label></display_field_label>
<display_field_column_label></display_field_column_label>
<display_field_format></display_field_format>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_entity_display_field"><entity_display_field_obj>1007600147.08</entity_display_field_obj>
<entity_mnemonic>GSCIC</entity_mnemonic>
<display_field_name>item_category_label</display_field_name>
<display_field_order>3</display_field_order>
<display_field_label></display_field_label>
<display_field_column_label></display_field_column_label>
<display_field_format></display_field_format>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_entity_display_field"><entity_display_field_obj>1007600149.08</entity_display_field_obj>
<entity_mnemonic>GSCIC</entity_mnemonic>
<display_field_name>item_link</display_field_name>
<display_field_order>5</display_field_order>
<display_field_label></display_field_label>
<display_field_column_label></display_field_column_label>
<display_field_format></display_field_format>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_entity_display_field"><entity_display_field_obj>1007600150.08</entity_display_field_obj>
<entity_mnemonic>GSCIC</entity_mnemonic>
<display_field_name>system_owned</display_field_name>
<display_field_order>6</display_field_order>
<display_field_label></display_field_label>
<display_field_column_label></display_field_column_label>
<display_field_format></display_field_format>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="18"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSCLG</entity_mnemonic>
<entity_mnemonic_short_desc>language</entity_mnemonic_short_desc>
<entity_mnemonic_description>gsc_language</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924369.09</entity_mnemonic_obj>
<entity_description_field>language_name</entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>The languages supported by the system.</entity_narration>
<entity_object_field>language_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field>language_code</entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="19"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSCLS</entity_mnemonic>
<entity_mnemonic_short_desc>logical service</entity_mnemonic_short_desc>
<entity_mnemonic_description>gsc_logical_service</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924409.09</entity_mnemonic_obj>
<entity_description_field>logical_service_description</entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This table defines the logical services available to the application.

A logical service is a separate process running either locally or remotely that requires connection parameters to establish communication between the client and the service. 

Logical service names are unique so that connection to the service can be completely abstracted from the developer. 

The physical service will determine the actual connection parameters.

Which physical service is used is determined by combining the session type with the logical service.

Logical services for appserver service types would in fact be appserver partition names. Logical services for database connection service types would be the logical database name.
</entity_narration>
<entity_object_field>logical_service_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field>logical_service_code</entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="20"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSCLT</entity_mnemonic>
<entity_mnemonic_short_desc>language text</entity_mnemonic_short_desc>
<entity_mnemonic_description>gsc_language_text</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>54</entity_mnemonic_obj>
<entity_description_field></entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>Totally generic text file for all supported languages. Text's may be associated with another entity (via owning_obj) or may be simply generic text of a certain type. Numbers enclosed in {} are for parameter substitution.
E.g. Scheme option names, transaction narrations, valid people titles, etc.</entity_narration>
<entity_object_field>language_text_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="21"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSCMM</entity_mnemonic>
<entity_mnemonic_short_desc>multi media type</entity_mnemonic_short_desc>
<entity_mnemonic_description>gsc_multi_media_type</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924370.09</entity_mnemonic_obj>
<entity_description_field>multi_media_type_description</entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This table contains information related to different types of multi media files.</entity_narration>
<entity_object_field>multi_media_type_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field>multi_media_type_code</entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="22"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSCMT</entity_mnemonic>
<entity_mnemonic_short_desc>manager type</entity_mnemonic_short_desc>
<entity_mnemonic_description>gsc_manager_type</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924410.09</entity_mnemonic_obj>
<entity_description_field>manager_type_name</entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This table contains the definition of the standard managers that are used in the framework.

A predefined set of managers will exist in this table that support the framework functionality. Only managers that directly affect the core functionality of the framework need to be defined as manager types.

For example, without a session manager we cannot start any other code, without a security manager we cannot do user authentication, etc.

</entity_narration>
<entity_object_field>manager_type_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field>manager_type_code</entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="23"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSCNA</entity_mnemonic>
<entity_mnemonic_short_desc>nationality</entity_mnemonic_short_desc>
<entity_mnemonic_description>gsc_nationality</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924371.09</entity_mnemonic_obj>
<entity_description_field>nationality_name</entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration></entity_narration>
<entity_object_field>nationality_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field>nationality_code</entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="24"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSCOB</entity_mnemonic>
<entity_mnemonic_short_desc>object</entity_mnemonic_short_desc>
<entity_mnemonic_description>gsc_object</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924412.09</entity_mnemonic_obj>
<entity_description_field>object_description</entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This table defines the objects (programs) that exist within your applications. Not every program needs to be added as an object - only programs that require security, or that need to appear on a dynamic menu need be setup.

Objects must be assigned an object type and belong to a product module. This facilitates setting up security based on object types and modules, rather than having to secure every object individually.

This table now supports both physical and logical objects. If the object is a physical object, then the link to the physical object will be set to 0. If the object is a dynamic object, then the link to the physical object will point at the object to use as the starting point when building the dynamic object.

If the object is flagged as a generic object, i.e. a physical object that is the basis for dynamic objects, then no security allocations, menus, etc. may be allocated to it as it is useless without the dynamic portions being built first against the logical objects that use it.

For logical objects, the object name will be specified without a file extension, and the path will not be relevant.

This repository concept means that many more objects will exist in this table.

</entity_narration>
<entity_object_field>object_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="25"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSCOT</entity_mnemonic>
<entity_mnemonic_short_desc>object type</entity_mnemonic_short_desc>
<entity_mnemonic_description>gsc_object_type</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924413.09</entity_mnemonic_obj>
<entity_description_field>object_type_description</entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This table defines the types of programs supported. A record will need to exist for the various support templates, e.g. "Object Controller", "Menu Controller", "SmartFolder", smartbrowser, smartviewer, smartdataobject, etc.

When objects are created, they must be assigned an object type.

The object type is used as a grouping mechanism for security, to allow restrictions to be created for certain types of objects, rather than having to setup security for every object.
</entity_narration>
<entity_object_field>object_type_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field>object_type_code</entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="26"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSCPC</entity_mnemonic>
<entity_mnemonic_short_desc>profile code</entity_mnemonic_short_desc>
<entity_mnemonic_description>gsc_profile_code</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924373.09</entity_mnemonic_obj>
<entity_description_field>profile_description</entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This table defines the codes that exist for each profile type, and the structure of the key / data value fields when this code is allocated against a user in the gsm_profile_data table.

An example profile type would be filter settings, and example profile codes for filter settings would be filter from values, filter to values, filtering enabled, filter field names, etc.</entity_narration>
<entity_object_field>profile_code_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="27"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSCPD</entity_mnemonic>
<entity_mnemonic_short_desc>package dataset</entity_mnemonic_short_desc>
<entity_mnemonic_description>gsc_package_dataset</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>4621.24</entity_mnemonic_obj>
<entity_description_field></entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This table defines the datasets that should be included with a package. A dataset may be included in multiple packages.</entity_narration>
<entity_object_field>package_dataset_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field>package_dataset_obj</entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>ICFDB</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
<contained_record DB="ICFDB" Table="gsc_entity_display_field"><entity_display_field_obj>4622.24</entity_display_field_obj>
<entity_mnemonic>GSCPD</entity_mnemonic>
<display_field_name>deploy_full_data</display_field_name>
<display_field_order>1</display_field_order>
<display_field_label></display_field_label>
<display_field_column_label></display_field_column_label>
<display_field_format></display_field_format>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="28"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSCPF</entity_mnemonic>
<entity_mnemonic_short_desc>profile type</entity_mnemonic_short_desc>
<entity_mnemonic_description>gsc_profile_type</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924374.09</entity_mnemonic_obj>
<entity_description_field>profile_type_description</entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This table defines the types of profile codes supported for allocation to users.

Records will exist for any type of profile information stored against a user between sessions. Examples include browser filter settings, report filter settings, Toolbar cusomisation settings, window positions and sizes, system wide settings such as tooltips on/off, etc.




</entity_narration>
<entity_object_field>profile_type_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field>profile_type_code</entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="29"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSCPM</entity_mnemonic>
<entity_mnemonic_short_desc>product module</entity_mnemonic_short_desc>
<entity_mnemonic_description>gsc_product_module</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924415.09</entity_mnemonic_obj>
<entity_description_field>product_module_description</entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This table contains information about the installed product modules with appropriate license details.</entity_narration>
<entity_object_field>product_module_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field>product_module_code</entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="30"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSCPR</entity_mnemonic>
<entity_mnemonic_short_desc>product</entity_mnemonic_short_desc>
<entity_mnemonic_description>gsc_product</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924414.09</entity_mnemonic_obj>
<entity_description_field>product_description</entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This table contains information about the installed products with appropriate license details.</entity_narration>
<entity_object_field>product_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field>product_code</entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="31"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSCSC</entity_mnemonic>
<entity_mnemonic_short_desc>security control</entity_mnemonic_short_desc>
<entity_mnemonic_description>gsc_security_control</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924375.09</entity_mnemonic_obj>
<entity_description_field></entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>Extra control information pertinent to security settings. This table will actually only contain a single record.</entity_narration>
<entity_object_field>security_control_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="32"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSCSN</entity_mnemonic>
<entity_mnemonic_short_desc>next sequence</entity_mnemonic_short_desc>
<entity_mnemonic_description>gsc_next_sequence</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924372.09</entity_mnemonic_obj>
<entity_description_field></entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This table is used to allocate sequence numbers where it is possible that multiple sequence numbers may be requested by multiple transactions simultaneously - it is intended to avoid deadly embrace record locks.

When a gsc_sequence is created / updated with multi_transaction set to YES, number_of_sequences records are created in this table starting from gsc-sequence.next_value.

When a sequence number is requested, the first record in this table for the gsc_sequence is found, saved and deleted. At the same time, a new gsc_next_sequence record is tagged on the end i.e. with the sequence number just found plus number_of_sequences.</entity_narration>
<entity_object_field>next_sequence_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>no</version_data>
<deploy_data>no</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="33"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSCSP</entity_mnemonic>
<entity_mnemonic_short_desc>session property</entity_mnemonic_short_desc>
<entity_mnemonic_description>gsc_session_property</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924418.09</entity_mnemonic_obj>
<entity_description_field>session_property_name</entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This table contains the list of valid properties that may be specified in the "properties" node of the ICF configuration file (ICFCONFIG.XML).

These property values can be set and retrieved using calls to the Session Manager. They can thus be used to alter the way that the session performs depending on the session type.
</entity_narration>
<entity_object_field>session_property_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="34"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSCSQ</entity_mnemonic>
<entity_mnemonic_short_desc>sequence</entity_mnemonic_short_desc>
<entity_mnemonic_description>gsc_sequence</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924376.09</entity_mnemonic_obj>
<entity_description_field>sequence_description</entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This is a generic sequence number / format table. All entries in this table will be system owned by their nature.

When a sequence number is required to be generated, it will be done at the end of the update as part of the transaction. This table is a potential bottle neck and so locks should be kept to an absolute minimum, i.e. no locks during user interaction.

If the sequence number is to be automatically generated, then there can be no holes in the sequence numbers, which is why a Progress sequence will not be used.

Example uses for this table would be for the automatic generation of document numbers, transaction references, etc.</entity_narration>
<entity_object_field>sequence_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="35"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSCST</entity_mnemonic>
<entity_mnemonic_short_desc>service type</entity_mnemonic_short_desc>
<entity_mnemonic_description>gsc_service_type</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924417.09</entity_mnemonic_obj>
<entity_description_field>service_type_description</entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This entity describes the different types of services available to applications and provides the management procedures for the different types of connections.

To illustrate, database services, AppServer services and JMS partitions are all different service types. The Database and AppServer services are system owned.

The maintenance object defines the datafield object used to maintain the physical connection parameter attribute on the physical service table. For example, if this is a service type for database connections, then the datafield may allow the specifiction of -S -N and -H prompts independantly and then put the result as 1 field into the connection parameter.

The management object is the api procedure that is responsible for making the physical connections to the service.

In the case of an appserver partition, the default logical service could point at the default logical appserver partition to use.

</entity_narration>
<entity_object_field>service_type_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field>service_type_code</entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="36"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSMAV</entity_mnemonic>
<entity_mnemonic_short_desc>profile alpha value</entity_mnemonic_short_desc>
<entity_mnemonic_description>gsm_profile_alpha_value</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924388.09</entity_mnemonic_obj>
<entity_description_field></entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>List of valid values / ranges for an alpha profile</entity_narration>
<entity_object_field>profile_alpha_value_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="37"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSMCA</entity_mnemonic>
<entity_mnemonic_short_desc>category</entity_mnemonic_short_desc>
<entity_mnemonic_description>gsm_category</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924377.09</entity_mnemonic_obj>
<entity_description_field>category_description</entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>A multi-purpose grouping mechanism for generic entities. Certain categories may be system owned / generated and may not be deleted. These are usually hard coded into programs.

Additionally, some categories may not be associated with another generic entity. These are used to store hard coded valid value lists, lookup lists, etc. Where ever we have made use of hard coded mnemonics within the application, their usage and description will be defined in this table. 

Refer to the "Generic Table Usage" document for a detailed description and sample instance data.</entity_narration>
<entity_object_field>category_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="38"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSMCL</entity_mnemonic>
<entity_mnemonic_short_desc>control code</entity_mnemonic_short_desc>
<entity_mnemonic_description>gsm_control_code</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924378.09</entity_mnemonic_obj>
<entity_description_field>control_description</entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This is a generic table for holding device control codes. The category is used to define what the code is for, and the owning_obj is optionally to define the device the code relates to. If the owning_obj is left as 0, then it applies to all devices.

An example use is in a point of sale system where codes must be sent to a pole for various reasons, e.g. to reset the poll, to make the message scroll, etc. Different categories would be defined for each action. The owning_entity_mnemonic on the category would determine which table the owning_obj related to. This will usually be some sort of application specific device table.
</entity_narration>
<entity_object_field>control_code_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="39"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSMCM</entity_mnemonic>
<entity_mnemonic_short_desc>comment</entity_mnemonic_short_desc>
<entity_mnemonic_description>gsm_comment</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>87</entity_mnemonic_obj>
<entity_description_field>comment_description</entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>Generic comment linked to any entity.</entity_narration>
<entity_object_field>comment_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>no</version_data>
<deploy_data>no</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="40"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSMCR</entity_mnemonic>
<entity_mnemonic_short_desc>currency</entity_mnemonic_short_desc>
<entity_mnemonic_description>gsm_currency</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924380.09</entity_mnemonic_obj>
<entity_description_field>currency_description</entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This table contains all the currency codes and their symbol references that are available to the system</entity_narration>
<entity_object_field>currency_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field>currency_code</entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="41"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSMCY</entity_mnemonic>
<entity_mnemonic_short_desc>country</entity_mnemonic_short_desc>
<entity_mnemonic_description>gsm_country</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924379.09</entity_mnemonic_obj>
<entity_description_field>country_name</entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>Supported countries, e.g. USA = United States of America, SA = South Africa, UK = United Kingdom</entity_narration>
<entity_object_field>country_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field>country_code</entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="42"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSMDR</entity_mnemonic>
<entity_mnemonic_short_desc>default report format</entity_mnemonic_short_desc>
<entity_mnemonic_description>gsm_default_report_format</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924381.09</entity_mnemonic_obj>
<entity_description_field></entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This table provides an override mechanism for default report layouts. For example, specific organisations or people can specify a different default report format for a specific document type.

This would typically be used for login company organisations, where for each of the different login companies, a different statement print layout or cheque layout , etc. could be used by default.</entity_narration>
<entity_object_field>default_report_format_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="43"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSMEF</entity_mnemonic>
<entity_mnemonic_short_desc>entity field</entity_mnemonic_short_desc>
<entity_mnemonic_description>gsm_entity_field</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924382.09</entity_mnemonic_obj>
<entity_description_field>entity_field_name</entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This table facilitates securing any application specific or generic data against any entity.

For example, if there is a requirement to secure access to specific companies, then the company entity, with the company code field could be set-up in this table. The valid values could then be setup in the entity field values table, and users allocated access to the specific values.</entity_narration>
<entity_object_field>entity_field_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="44"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSMEV</entity_mnemonic>
<entity_mnemonic_short_desc>entity field value</entity_mnemonic_short_desc>
<entity_mnemonic_description>gsm_entity_field_value</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924383.09</entity_mnemonic_obj>
<entity_description_field></entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>The valid values for the entity field, e.g. company codes.</entity_narration>
<entity_object_field>entity_field_value_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="45"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSMEX</entity_mnemonic>
<entity_mnemonic_short_desc>external xref</entity_mnemonic_short_desc>
<entity_mnemonic_description>gsm_external_xref</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924384.09</entity_mnemonic_obj>
<entity_description_field>external_description</entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This table defines generic cross reference information to details in external tables.

For example, an organisation whose accounts are held in this database, may have other account codes in an external database where these account codes originated from. This table could be used to define which internal accounts point to which external accounts for xref and reporting purposes. In this example, the fields would be setup as follows:
related entity = The gsm_organisation table in this database
related object = Specific organisations
Internal entity = The gsm_account table in this database
internal object = specific account codes

If an external table is available, then the external entity and object can be defined, otherwise the external details can be keyed directly into this table.
</entity_narration>
<entity_object_field>external_xref_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>no</version_data>
<deploy_data>no</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="46"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSMFF</entity_mnemonic>
<entity_mnemonic_short_desc>field</entity_mnemonic_short_desc>
<entity_mnemonic_description>gsm_field</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>103</entity_mnemonic_obj>
<entity_description_field>field_description</entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>Fields that require secured access in the software. Not many fields required security, but those that do should be defined in this table. Users can only be given restricted access to fields specified in this table.

If a user is given restricted access to a field specified in this table, then the access granted to the user may be view only, hidden, or update.

For field security to be activated, entries must be created in the security structure table, as it is this table that is allocated to users, and allows the field security to be restricted or different in various parts of the application.

Usually developers will create appropriate fields, and users may then assign them to certain parts of the application via the security structure table.
</entity_narration>
<entity_object_field>field_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="47"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSMFS</entity_mnemonic>
<entity_mnemonic_short_desc>flow step</entity_mnemonic_short_desc>
<entity_mnemonic_description>gsm_flow_step</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924420.09</entity_mnemonic_obj>
<entity_description_field></entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This table contains the steps that have to be followed to complete a flow.

Each step may involve the running of an object, the running of an internal procedure within an object, or the execution of another complete flow.

The flow steps may be customised for specific login organisations so that entire steps may be replaced with custom specific code. 

The standard flow steps will be specified with a 0 login company. Within a single flow the login company can either be 0 or a specific company. When running each step it will first check for a customisation for the login company and if not found will just run the standard step. 

If a customisation is found, this may either be an additional step in which case the custom step will be run first, or else it will be a complete replacement of the standard step.

It is also possible to add custom steps that do not have any standard code at all, i.e. no step with a 0 login company exists. This facilitates adding customisations after the standard behaviour.





 and so setting up company specific steps would involve copying the default flow steps to a specific login company in full and then customising the specific steps as required. If the standard flow is modified, customised steps would also need to be manually modified as appropriate.
</entity_narration>
<entity_object_field>flow_step_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="48"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSMFW</entity_mnemonic>
<entity_mnemonic_short_desc>flow</entity_mnemonic_short_desc>
<entity_mnemonic_description>gsm_flow</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924419.09</entity_mnemonic_obj>
<entity_description_field>flow_description</entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>A flow is a set of steps that have to be performed in a certain order to result in certain desired behavior. 

This table groups the steps that have to be performed.

af/sup2/afrun2.i takes a parameter (&amp;FLOW) which maps to one of these flows and then executes the steps that make up the flow.

A flow must ultimately map to a single transaction and therefore must be executed on a single physical partition or service.

Example flows may be shipOrder, completeOrder, postTransaction, etc.
</entity_narration>
<entity_object_field>flow_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="49"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSMHE</entity_mnemonic>
<entity_mnemonic_short_desc>help</entity_mnemonic_short_desc>
<entity_mnemonic_description>gsm_help</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924421.09</entity_mnemonic_obj>
<entity_description_field></entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This table defines help contexts for containers, objects on containers, and fields on obejcts if required.

When context sensitive help is requested, the context and help file will be retrieved from this file if available.

Help may be specified in multiple languages if required.

An entry in this table for a specific language but no container, object or field specified will override the standard help file used systemwide for the specified language from gsc_security_control.</entity_narration>
<entity_object_field>help_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="50"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSMIT</entity_mnemonic>
<entity_mnemonic_short_desc>menu structure item</entity_mnemonic_short_desc>
<entity_mnemonic_description>gsm_menu_structure_item</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1007600157.08</entity_mnemonic_obj>
<entity_description_field></entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This table associates menu items with menu structures. A menu structure may contain many menu items and a menu item can be used by many menu structures.

This tables also defines the sequence that menu items appear within a menu structure.
</entity_narration>
<entity_object_field>menu_structure_item_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field>menu_structure_obj,menu_item_sequence</entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>ICFDB</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
<contained_record DB="ICFDB" Table="gsc_entity_display_field"><entity_display_field_obj>1007600158.08</entity_display_field_obj>
<entity_mnemonic>GSMIT</entity_mnemonic>
<display_field_name>menu_item_sequence</display_field_name>
<display_field_order>3</display_field_order>
<display_field_label></display_field_label>
<display_field_column_label></display_field_column_label>
<display_field_format></display_field_format>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="51"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSMLG</entity_mnemonic>
<entity_mnemonic_short_desc>login company</entity_mnemonic_short_desc>
<entity_mnemonic_description>gsm_login_company</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924385.09</entity_mnemonic_obj>
<entity_description_field>login_company_name</entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This framework table defines login companies (organisations) and is used to provide a list of valid companies the user may log into at runtime.

It is intended that this table will link into an external application database where additional details will be stored for the login company, e.g. address and contact information. The code or the object field could be used as the xref into the external application database.

The table is required in the framework to facilitate the generic set-up of framework data specific to login companies, e.g. security allocations, automatic reference numbers, etc.

The existence of a login company in the framework supports the concept of holding multiple company application data in a single database as apposed to having separate databases for each company. Application databases would further have to link to this table or a corresponding table in their database design to filter appropriate data for each login company.

We only hold on this table the minimum details as required by the framework. Applications that also have an organisation table will need to replicate modifications from their full organisation table into this table in order to simplify and syncrhonise maintenance of this data.
</entity_narration>
<entity_object_field>login_company_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field>login_company_code</entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="52"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSMMI</entity_mnemonic>
<entity_mnemonic_short_desc>menu item</entity_mnemonic_short_desc>
<entity_mnemonic_description>gsm_menu_item</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>124</entity_mnemonic_obj>
<entity_description_field>menu_item_description</entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This table defines the dynamic menu items that belong to a menu structure, and their hierarchy.

Menu items can be sub-menus, rulers, toggle options, or point to an actual program object to run.</entity_narration>
<entity_object_field>menu_item_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field>menu_item_reference</entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="53"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSMMM</entity_mnemonic>
<entity_mnemonic_short_desc>multi media</entity_mnemonic_short_desc>
<entity_mnemonic_description>gsm_multi_media</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924386.09</entity_mnemonic_obj>
<entity_description_field>multi_media_description</entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>Generic multi media file linked to any entity.</entity_narration>
<entity_object_field>multi_media_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="54"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSMMS</entity_mnemonic>
<entity_mnemonic_short_desc>menu structure</entity_mnemonic_short_desc>
<entity_mnemonic_description>gsm_menu_structure</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924422.09</entity_mnemonic_obj>
<entity_description_field>menu_structure_description</entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This table defines the dynamic menu structues available. A menu structure must belong to a product, and can optionally also be associated with a product module if required - for sorting purposes.

The menu structure code will be referenced in source code to build any dynamic menu items associated with the menu structure.</entity_narration>
<entity_object_field>menu_structure_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="55"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSMND</entity_mnemonic>
<entity_mnemonic_short_desc>node_code</entity_mnemonic_short_desc>
<entity_mnemonic_description>gsm_node</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1005103085.101</entity_mnemonic_obj>
<entity_description_field></entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This table contains a parent-child relationship of node behaviour for the TreeView controller.</entity_narration>
<entity_object_field>node_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="56"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSMNV</entity_mnemonic>
<entity_mnemonic_short_desc>profile numeric value</entity_mnemonic_short_desc>
<entity_mnemonic_description>gsm_profile_numeric_value</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924393.09</entity_mnemonic_obj>
<entity_description_field></entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>List of valid numeric values / ranges for a profile.

For other systems, this table is also used for determining contribution rule values e.g. for age or income ranges in conjunction with a hard coded category. The rule value used would be the numeric_value_to.
</entity_narration>
<entity_object_field>profile_numeric_value_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="57"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSMOM</entity_mnemonic>
<entity_mnemonic_short_desc>object menu structure</entity_mnemonic_short_desc>
<entity_mnemonic_description>gsm_object_menu_structure</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924423.09</entity_mnemonic_obj>
<entity_description_field></entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This table defines the dynamic menu structures used by the object - if applicable. Only container objects may have dynamic menu structures.

If an instance attribute is specified, then the menu structure will only be dynamically built if the instance attribute is passed in from the previous menu option.

This facilitates pulling in different dynamic menu options for a specific object based on its use, e.g. creditors, debtors, etc. having different options.

</entity_narration>
<entity_object_field>object_menu_structure_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field>object_obj,menu_structure_obj,instance_attribute_obj</entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
<contained_record DB="ICFDB" Table="gsc_entity_display_field"><entity_display_field_obj>1007600087.08</entity_display_field_obj>
<entity_mnemonic>GSMOM</entity_mnemonic>
<display_field_name>insert_submenu</display_field_name>
<display_field_order>7</display_field_order>
<display_field_label></display_field_label>
<display_field_column_label></display_field_column_label>
<display_field_format></display_field_format>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_entity_display_field"><entity_display_field_obj>1007600088.08</entity_display_field_obj>
<entity_mnemonic>GSMOM</entity_mnemonic>
<display_field_name>menu_structure_sequence</display_field_name>
<display_field_order>8</display_field_order>
<display_field_label></display_field_label>
<display_field_column_label></display_field_column_label>
<display_field_format></display_field_format>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="58"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSMPA</entity_mnemonic>
<entity_mnemonic_short_desc>profile alpha options</entity_mnemonic_short_desc>
<entity_mnemonic_description>gsm_profile_alpha_options</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924387.09</entity_mnemonic_obj>
<entity_description_field></entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>Alpha specific details for a profile</entity_narration>
<entity_object_field>profile_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="59"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSMPD</entity_mnemonic>
<entity_mnemonic_short_desc>profile date value</entity_mnemonic_short_desc>
<entity_mnemonic_description>gsm_profile_date_value</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924390.09</entity_mnemonic_obj>
<entity_description_field></entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>List of valid dates / date ranges for a profile</entity_narration>
<entity_object_field>profile_date_value_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="60"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSMPF</entity_mnemonic>
<entity_mnemonic_short_desc>profile data</entity_mnemonic_short_desc>
<entity_mnemonic_description>gsm_profile_data</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924389.09</entity_mnemonic_obj>
<entity_description_field></entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This table is used to store profile information for specific users, e.g. browser filter settings, window positions and sizes, report filtter settings, etc.

The nature of the data key and data value fields is determined by the profile type and code.

Data can be stored permannently, or only for the current session, depending on the context_id field.</entity_narration>
<entity_object_field>profile_data_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>no</version_data>
<deploy_data>no</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="61"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSMPH</entity_mnemonic>
<entity_mnemonic_short_desc>profile history</entity_mnemonic_short_desc>
<entity_mnemonic_description>gsm_profile_history</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924391.09</entity_mnemonic_obj>
<entity_description_field></entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>History of profiles relating to an object from the effective date onwards.

In other systems, in the case where a profile is related to contribution rule value determination, the value fields are not applicable.</entity_narration>
<entity_object_field>profile_history_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>no</version_data>
<deploy_data>no</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="62"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSMPN</entity_mnemonic>
<entity_mnemonic_short_desc>profile numeric options</entity_mnemonic_short_desc>
<entity_mnemonic_description>gsm_profile_numeric_options</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924392.09</entity_mnemonic_obj>
<entity_description_field></entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>Numeric specific options for a profile.</entity_narration>
<entity_object_field>profile_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="63"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSMPR</entity_mnemonic>
<entity_mnemonic_short_desc>profile</entity_mnemonic_short_desc>
<entity_mnemonic_description>gsm_profile</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>143</entity_mnemonic_obj>
<entity_description_field>profile_description</entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>Generic profiles that can be attached to any entity or may stand alone to be used as control information or lookup lists. Profiles could be utilised for user defined fields e.g. smoking and drinking habits of members.

For other systems, the modification of a profile and it's related tables must be inhibited where it exists in any s_contribution_type.rule_code_profile_objs with existing s_contribution_rules records.</entity_narration>
<entity_object_field>profile_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="64"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSMPY</entity_mnemonic>
<entity_mnemonic_short_desc>physical service</entity_mnemonic_short_desc>
<entity_mnemonic_description>gsm_physical_service</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924424.09</entity_mnemonic_obj>
<entity_description_field>physical_service_description</entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>A physical service provides the specific connection parameters that are required to connect a physical service to a session.

The physical service is connected to a logical service and session type via the session service.

The maintenance object on the service type defines the datafield object used to maintain the physical connection parameters attribute. For example, if this is a service type for database connections, then the datafield may allow the specifiction of -S -N and -H prompts independantly and then put the result as 1 field into the connection parameters.

The management object on the service type is the api procedure that is responsible for making the physical connections to the service.
</entity_narration>
<entity_object_field>physical_service_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field>physical_service_code</entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="65"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSMRA</entity_mnemonic>
<entity_mnemonic_short_desc>range</entity_mnemonic_short_desc>
<entity_mnemonic_description>gsm_range</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>146</entity_mnemonic_obj>
<entity_description_field>range_description</entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>These are range structures that control what data a user may view. When allocated to a user, the ranges of permitted data will be specified.

Sample range structures could include "Nominal Codes", "Cost Centres", or "Member Codes", etc.

The appropriate data will be hidden from the user.

For range security to be activated, entries must be created in the security structure table, as it is this table that is allocated to users, and allows the range security to be restricted or different in various parts of the application.

Usually developers will create appropriate ranges, and users may then assign them to certain parts of the application via the security structure table.
</entity_narration>
<entity_object_field>range_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field>range_code</entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="66"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSMRD</entity_mnemonic>
<entity_mnemonic_short_desc>report definition</entity_mnemonic_short_desc>
<entity_mnemonic_description>gsm_report_definition</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>147</entity_mnemonic_obj>
<entity_description_field>launch_window_name</entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This table contains control and default  information about all the reports produced by the system.

Note that all reports will be created by initially extracting a delimited data file which could then be printed using any reporting tool.

This table actually defines the report extract procedure and default report options. The extract can the be printed in various formats as defined by the gsm_report_format table.

The name of the extract file(s) produced will be hard coded in the extract procedure, but will be derived from the extract procedure name. The extension will be .rpd suffixed with the date and time down to seconds for multi-user support. The actual names used will be recorded in the gst_extract_log.</entity_narration>
<entity_object_field>report_definition_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field>report_definition_reference</entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="67"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSMRE</entity_mnemonic>
<entity_mnemonic_short_desc>reporting tool</entity_mnemonic_short_desc>
<entity_mnemonic_description>gsm_reporting_tool</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924425.09</entity_mnemonic_obj>
<entity_description_field></entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This table contains information about the reporting tools available to the system. These would be:
Progress
Results
Crystal reports
Actuate
etc.</entity_narration>
<entity_object_field>reporting_tool_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field>reporting_tool_code</entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="68"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSMRF</entity_mnemonic>
<entity_mnemonic_short_desc>report format</entity_mnemonic_short_desc>
<entity_mnemonic_description>gsm_report_format</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>149</entity_mnemonic_obj>
<entity_description_field>report_format_description</entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>Once data for a report has been extracted, it may be printed in different formats using different reporting tools.

This table defines the report procedures that may be used to format the extracted data. If printing to Crystal, the report fromat procedure is the name of the Crystal Report definition file.

The extract files to send as data to the report will be hard coded in the report extract procedure.</entity_narration>
<entity_object_field>report_format_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field>report_format_reference</entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="69"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSMRM</entity_mnemonic>
<entity_mnemonic_short_desc>required manager</entity_mnemonic_short_desc>
<entity_mnemonic_description>gsm_required_manager</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924426.09</entity_mnemonic_obj>
<entity_description_field></entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This table contains a list of the managers that are required to be started during the startup of the session and the order in which they must be started. Any manager types which need to be written to the config file must always be started first. 

The write_to_config attribute of the manager will cause this procedure name to be written to the config.xml file so that it can be started up before the session makes a connection to the runtime repository.

The framework supports a standard set of managers that are required but specific applications may require the startup of additional managers for performance reasons, e.g. a financial system may require a frequently referenced financial manager api to be pre-started.</entity_narration>
<entity_object_field>required_manager_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="70"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSMSC</entity_mnemonic>
<entity_mnemonic_short_desc>server context</entity_mnemonic_short_desc>
<entity_mnemonic_description>gsm_server_context</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924427.09</entity_mnemonic_obj>
<entity_description_field>context_name</entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This table is a generic table to stored context information between stateless appserver connections.

The type of information that is required includes user information, security information, possibly SCM workspace and task information, etc.

</entity_narration>
<entity_object_field>server_context_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>no</version_data>
<deploy_data>no</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="71"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSMSE</entity_mnemonic>
<entity_mnemonic_short_desc>session type</entity_mnemonic_short_desc>
<entity_mnemonic_description>gsm_session_type</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924429.09</entity_mnemonic_obj>
<entity_description_field>session_type_description</entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>A session type is a namespace for grouping specific types of sessions together.

For example, a "receipting workstation" would be a specific session type while a "salesman's web agent" could be another.

Each session type is combined with a physical session type that maps to a list of known Progress 4GL run-time environments. 

Thus, "receipting workstation" may be mapped to a 4GL GUI client while "salesman's web agent" could be mapped to a WebSpeed Transaction Agent.

Thus you could create any number of session types mapping them to specific 4GL session types.

Where different managers, etc. need to be pre-started for different applications, then the different applications would be defined as new session types.

In order to run locally without appserver connections, etc. you would need to define a new session type that connects to appropriate databases and has no session service records for the appserver logical services thereby forcing them to not connect and rather simply use the session handle for code portability. Also, this new session type would define a different set of managers to run, i.e. run the server side managers locally.

We will provide a facility to change the session type on the fly (if possible).

</entity_narration>
<entity_object_field>session_type_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field>session_type_code</entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="72"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSMSF</entity_mnemonic>
<entity_mnemonic_short_desc>startup flow</entity_mnemonic_short_desc>
<entity_mnemonic_description>gsm_startup_flow</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924432.09</entity_mnemonic_obj>
<entity_description_field></entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This table defines a list of flows that have to be run at startup of the session after the management procedures have been initialized, in order to perform any specific session setup, e.g. caching of various information.</entity_narration>
<entity_object_field>startup_flow_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="73"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSMSH</entity_mnemonic>
<entity_mnemonic_short_desc>status history</entity_mnemonic_short_desc>
<entity_mnemonic_description>gsm_status_history</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924396.09</entity_mnemonic_obj>
<entity_description_field></entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>Actual status of an object as from the effective date</entity_narration>
<entity_object_field>status_history_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>no</version_data>
<deploy_data>no</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="74"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSMSI</entity_mnemonic>
<entity_mnemonic_short_desc>site</entity_mnemonic_short_desc>
<entity_mnemonic_description>gsm_site</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924431.09</entity_mnemonic_obj>
<entity_description_field>site_name</entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This table contain sites or locations where ICF software is running.

Its use is to make certain data specific to a particular site, e.g. menu items, menu structures, report definitions, report formats, etc. specific to ICF. It can further define data specific to product and product modules.

Sites could be further broken down to provide additional filtering by site location if required.

Sites can either be development sites or customer sites. Only development sites need a unique site number.

Every site you intend to deploy data to needs to be set up in this table as the site is used to track deployments.

Every site must be allocated a totally unique number worldwide. This number will then be used as part of the object numbers in any databases used by that site for ICF applications.

This will mean that you can safely deploy data to sites without fear of having conflicting object numbers. Any data modified by the site will never be overwritten as the object numbers will never clash. Also data could be returned to us safely with no fear of object number clashes.

The site number must be uniqe worldwide to facilitate software houses developing with ICF releasing data to other software houses developing with ICF

The ICFDB will contain two sequences, seq_site_reverse and seq_site_division that will have their current value set by the allocation of the site number. They will then never be changed, and the current value of the sequences used to calculate the decimal portion of the object number, making the object numbers unique within that site. See the description of the site number for details of the calculations required.

A site will only ever have one version of the ICFDB database, ensuring they keep the same site number for all their ICF products.

Any object numbers that do not conform to this new standard should be fixed immediately to avoid problems in the future.

The data is linked to a site via the gsm_site_specific table in the ICFDB database which supports any type of data. The data being filtered is identified by the owning entity mnemonic, and the specific reference identifies the actual item of data being filtered. It is possible to make an item of data available to many sites. If the item of data does not exist in the table, then it will be assumed the data is applicable to all sites.

The gsm_site_specific table is also used to allocate which sites a specific user is associated with. In this case the entity mnemonic would be GSMUS and the specific reference would be the user login name.

Examples of data that may be specific to site codes are menu items, menu structures, report definitions and report formats.

For any supported tables, e.g. menu items when building menus, a check will need to be made in the site specific data table for the appropriate entity mnemonic and unique reference. If any records exist at all, then the site codes allocated to the user must be checked to see that the user has a matching site code. If not, the data should be skipped over as it is not relevant.

This table is in ICFDB because it is not specific to any product or workspace. The site specific data table is in ICFDB because it relates to the specific product and workspace data, allowing different workspaces to support different configurations of site specific data.

The current site can always be found by checking the value of the site sequence.</entity_narration>
<entity_object_field>site_number</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field>site_code</entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="75"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSMSP</entity_mnemonic>
<entity_mnemonic_short_desc>site specific</entity_mnemonic_short_desc>
<entity_mnemonic_description>gsm_site_specific</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924395.09</entity_mnemonic_obj>
<entity_description_field></entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This table defines data that is specific to a site or location where ICF is running, e.g. ICF, POSSE, PCS, etc.

Additionally the data may be specific to a product or product module.

Its use is to make certain data specific to a particular site, e.g. menu items, menu structures, report definitions, report formats, etc. specific to ICF.

The data being filtered is identified by the owning entity mnemonic, and the specific reference identifies the actual item of data being filtered. It is possible to make an item of data available to many sites. If the item of data does not exist in the table, then it will be assumed the data is applicable to all sites.

This table is also used to allocate which sites a specific user is associated with. In this case the entity mnemonic would be GSMUS and the specific reference would be the user login name.

Examples of data that may be specific to site codes are menu items, menu structures, report definitions and report formats.

For any supported tables, e.g. menu items when building menus, a check will need to be made in the site specific data table for the appropriate entity mnemonic and unique reference (e.g. menu item reference). If any records exist at all, then the site codes allocated to the user must be checked to see that the user has a matching site code. If not, the data should be skipped over as it is not relevant.

This site table is in RVDB because it is not specific to any product or workspace. This table is in ICFDB because it relates to the specific product and workspace data, allowing different workspaces to support different configurations of site specific data.

A standard folder with a 2 selection list viewer must be developed to allow the generic allocation of site codes for a specific item of data by passing in an instance attribute for the entity mnemonic. Also a standard api should be developed to check for the existence of data in this table and whether the user has a matching site code. To avoid checking the user site codes all the time, they should be placed into the extra user login value variables.</entity_narration>
<entity_object_field>site_specific_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>no</version_data>
<deploy_data>no</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="76"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSMSS</entity_mnemonic>
<entity_mnemonic_short_desc>security structure</entity_mnemonic_short_desc>
<entity_mnemonic_description>gsm_security_structure</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924394.09</entity_mnemonic_obj>
<entity_description_field></entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>The parts of the application where security restrictions are applicable to. Currently access tokens, fields, and ranges are supported. The owning_obj will refer either to a gsm_token record, a gsm_field record, or a gsm_range record.

One table is used rather than a usage table for each of the above as the fields are identical, and if another type is introduced, no major rewrites will be required as this table will automatically support it.

The security restriction may be assigned globally, in which case the product module, object and instance attribute will be 0.

Alternatively the restriction may be allocated to a product module, a specific program object, or even an insance attribute for a program.

A restriction must be assigned to this table for it to be active at all. It is entries in this table that are allocated to users.
</entity_narration>
<entity_object_field>security_structure_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="77"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSMST</entity_mnemonic>
<entity_mnemonic_short_desc>status</entity_mnemonic_short_desc>
<entity_mnemonic_description>gsm_status</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>160</entity_mnemonic_obj>
<entity_description_field>status_description</entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>The actual valid status codes are set-up in the category table. For example:

related entity mnemonic = GSMST for gsm_status
category type = STS for Status
category group = HST for History
category subgroup = COD for Code

The category subgroup is the actual status in this case. The categories of status will always be system owned and mandatory. The category mandatory flag will be used to indicate whether an object at this status may be modified.

At least 1 record must exist in this table for every category subgroup that has a related entity mnemonic of status (GSMST). This record will be system owned, have a sequence of 0 and may not be deleted. It will always be the default status for this category subgroup.

This table allows users to modify the narrative of the status, and add extra status's within the same category subgroup to represent their internal business processes.

From a business logic point of view, when the status changes within the same category, we do not need to do anything and the user may do this manually via a combo box. The change of status from 1 category to the next within a category group will usually be done via a business logic process.

We will always need to join back to the category table to determine what status an object is at from a business logic point of view.

The status an object is at effective from a specific date is determined by an entry in the status history table, which means the status does not need to be added to every table it is used for. However, in some cases we have linked objects directly to the status table to show the current status for performance reasons.</entity_narration>
<entity_object_field>status_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="78"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSMSV</entity_mnemonic>
<entity_mnemonic_short_desc>session service</entity_mnemonic_short_desc>
<entity_mnemonic_description>gsm_session_service</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924428.09</entity_mnemonic_obj>
<entity_description_field></entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>The session service table defines the different physical services for each session type in order to establish the logical service.

For example, an AppServer may require a shared memory connection to the repository database whereas a client session would require a network connection to the same databases. The physical connection parameters are different for each of these. Therefore the logical service identifies the database that needs to be connected and the physical service describes the mechanism for the connection dependant on the session type.

If no session service record exists then the logical service can only run locally.
</entity_narration>
<entity_object_field>session_service_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="79"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSMSY</entity_mnemonic>
<entity_mnemonic_short_desc>session type property</entity_mnemonic_short_desc>
<entity_mnemonic_description>gsm_session_type_property</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924430.09</entity_mnemonic_obj>
<entity_description_field></entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This table resolves the many-to-many relationship between gsc_session_property and gsm_session_type.

If a record is found in this table for a property and a session type, the value specified in that record is written to the ICF configuration file for the parameter.

If no record exists for a given property and session type, the always_used flag on the gsc_session_property table is checked. If the flag is on, the default value in the default_property_value field on the gsc_session_property table is used.</entity_narration>
<entity_object_field>session_type_property_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="80"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSMTL</entity_mnemonic>
<entity_mnemonic_short_desc>translation</entity_mnemonic_short_desc>
<entity_mnemonic_description>gsm_translation</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924397.09</entity_mnemonic_obj>
<entity_description_field>widget_name</entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This table containes user defined translations for the various languages for widget labels and tooltip text.

The setup of every program will first walk the widget tree and change the label / tooltip to the entry in this table according to the language selected by the user - if an entry exists.

Translations can be turned off globally using the gsc_security_control.translation_enabled flag.
</entity_narration>
<entity_object_field>translation_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="81"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSMTM</entity_mnemonic>
<entity_mnemonic_short_desc>toolbar menu structure</entity_mnemonic_short_desc>
<entity_mnemonic_description>gsm_toolbar_menu_structure</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1007600089.08</entity_mnemonic_obj>
<entity_description_field></entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This table is used to group bands or menu structures into a complete toolbar and menubar structure.</entity_narration>
<entity_object_field>toolbar_menu_structure_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field>object_obj,menu_structure_sequence,menu_structure_obj</entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>ICFDB</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
<contained_record DB="ICFDB" Table="gsc_entity_display_field"><entity_display_field_obj>1007600094.08</entity_display_field_obj>
<entity_mnemonic>GSMTM</entity_mnemonic>
<display_field_name>insert_rule</display_field_name>
<display_field_order>9</display_field_order>
<display_field_label></display_field_label>
<display_field_column_label></display_field_column_label>
<display_field_format></display_field_format>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_entity_display_field"><entity_display_field_obj>1007600092.08</entity_display_field_obj>
<entity_mnemonic>GSMTM</entity_mnemonic>
<display_field_name>menu_structure_alignment</display_field_name>
<display_field_order>7</display_field_order>
<display_field_label></display_field_label>
<display_field_column_label></display_field_column_label>
<display_field_format></display_field_format>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_entity_display_field"><entity_display_field_obj>1007600093.08</entity_display_field_obj>
<entity_mnemonic>GSMTM</entity_mnemonic>
<display_field_name>menu_structure_row</display_field_name>
<display_field_order>8</display_field_order>
<display_field_label></display_field_label>
<display_field_column_label></display_field_column_label>
<display_field_format></display_field_format>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_entity_display_field"><entity_display_field_obj>1007600090.08</entity_display_field_obj>
<entity_mnemonic>GSMTM</entity_mnemonic>
<display_field_name>menu_structure_sequence</display_field_name>
<display_field_order>3</display_field_order>
<display_field_label></display_field_label>
<display_field_column_label></display_field_column_label>
<display_field_format></display_field_format>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_entity_display_field"><entity_display_field_obj>1007600091.08</entity_display_field_obj>
<entity_mnemonic>GSMTM</entity_mnemonic>
<display_field_name>menu_structure_spacing</display_field_name>
<display_field_order>6</display_field_order>
<display_field_label></display_field_label>
<display_field_column_label></display_field_column_label>
<display_field_format></display_field_format>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="82"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSMTO</entity_mnemonic>
<entity_mnemonic_short_desc>token</entity_mnemonic_short_desc>
<entity_mnemonic_description>gsm_token</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>164</entity_mnemonic_obj>
<entity_description_field>token_description</entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>Tokens are used in the application to control access to functions the user may perform within a program via tab folder page names and button names.

Tokens may be created for any tab page names or button labels, being careful to ignore any shortcut characters and ... suffixes. The tokens must then be added to the security structure table to become active. The security structure table facilitates the token being restricted for a specific object instance, specific object, specific product module, or generically for everything.

The software will only check security providing a valid enabled token exists for the button label or tab folder page.

If a user has no tokens allocated at all, then it is assumed they have full access (providing security contol is set to full access by default). Once a user is allocated tokens, then security comes into force and the user will only be granted access for folder pages and buttons they have been granted access to (an that have restricted access set up).

Example tokens would be add, delete, modify, view, copy, page 1, page 2, etc.
</entity_narration>
<entity_object_field>token_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field>token_code</entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="83"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSMUC</entity_mnemonic>
<entity_mnemonic_short_desc>user category</entity_mnemonic_short_desc>
<entity_mnemonic_description>gsm_user_category</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924400.09</entity_mnemonic_obj>
<entity_description_field>user_category_description</entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This table defines categories of users. It could be used for job functions, etc. It's primary use is for filtering and reporting.</entity_narration>
<entity_object_field>user_category_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field>user_category_code</entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="84"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSMUL</entity_mnemonic>
<entity_mnemonic_short_desc>user allocation</entity_mnemonic_short_desc>
<entity_mnemonic_description>gsm_user_allocation</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924399.09</entity_mnemonic_obj>
<entity_description_field></entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>When a user logs into the system, they log in with a user id, and a select a company (organisation). This table defines the security options for the user when they log into a certian organisation. The user may have different security options when logged into different companies.

If the organisation_obj is 0, then the security allocation applies to all companies. Likewise, if the user_obj is 0, then the security allocation applies to all users logged into this company. User security will always override company security. In addition, and owning_obj of 0 always indicates no access to all the data for that entity mnemonic (not supported for security structures, or menus - only really for data).

This table generically assigns all security options for the user / company. The standard options that may be specified via the owning_entity_mnemonic and owning_obj are:

gsm_security_structure records for security relating to tokens, fields and ranges.
gsm_menu_items for securing access to menu items
gsm_menu_structure for securing access to menu structures
gsm_entity_field_value for securing access to generic entity field values e.g. companies.

Additionally, access to any entity data can be secured using this table. For example, to secure access to specific cost centre codes in a general ledger, the owning_entity_mnemonic could be the cost centre table, and the owning_obj used to allocate specific cost centres the user / company has access to.

The rules applied to this table for the entity in order are as follows:
0) If security is disabled, then user security is passed.
1) If a specific record exists for the user / company then security is passed
2) If a specific record is found for the user / company with an owning_obj of     0, security is failed
3) If not full access by default, and no entries exist for the user at all, including     all users and all companies, security is failed
4) If a record exists for all users or all companies with an owning_obj of 0,     then security is failed
5) If a record is found for all users, security is passed
6) If a record is found for all companies, security is passed
7) If full access by default and no records are found at all for the specific     user, all users, or all companies, then security is passed.

Some allocations require additional data, e.g. allocating a field restriction needs to determine what can be done with the field, e.g. View, Update, Hide, etc.

Entries must exist in this table for all security allocations. There is no option for inclusion or exclusion to make querying as fast as possible. The maintenance programs however should allow the specification by inclusion or exclusion for fast data entry - then create / delete all relevant entries in this table.
</entity_narration>
<entity_object_field>user_allocation_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>no</version_data>
<deploy_data>no</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="85"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSMUS</entity_mnemonic>
<entity_mnemonic_short_desc>user</entity_mnemonic_short_desc>
<entity_mnemonic_description>gsm_user</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924398.09</entity_mnemonic_obj>
<entity_description_field>user_login_name</entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This table defines the users who may log into the system, i.e. the users of the system.

The main user details are contained in an external security system, e.g. openstart pointed at by the external_userid field. This table defines extra user information for this system, and allows a user to be optionally associated with a person to facilitate full name, address, etc. details to be entered for a user as well as comments.

There is a logged in flag on this user record to facilitate the identification of user availability (a user is available if they are logged into this application).

The existence of this specific user table in our database also facilitates automatic referential integrity.

</entity_narration>
<entity_object_field>user_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>no</version_data>
<deploy_data>no</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="86"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSMVP</entity_mnemonic>
<entity_mnemonic_short_desc>valid object partition</entity_mnemonic_short_desc>
<entity_mnemonic_description>gsm_valid_object_partition</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924436.09</entity_mnemonic_obj>
<entity_description_field></entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This table defines a list of valid partitions in which a procedure can be run.

A partition is a logical AppServer Partition.

The list only contains records when the object is restricted to certain partitions. When the object may be run on any partition, there are no records in this table.

The records in this table are only applicable to appserver session types.</entity_narration>
<entity_object_field>valid_object_partition_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>no</version_data>
<deploy_data>no</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="87"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSTAD</entity_mnemonic>
<entity_mnemonic_short_desc>audit</entity_mnemonic_short_desc>
<entity_mnemonic_description>gst_audit</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>186</entity_mnemonic_obj>
<entity_description_field></entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>Global audit file to record modifications to data. The audit can be turned on by defining a category of audit for an entity type. It can be turned off again simply by resetting the active flag on the category.
The audit will hold basic details on the action (create, amend, or delete), the user, date &amp; time, the program and procedure used to perform the action, and possibly a record of the data before the update.
The audit could easily be used to keep old values of fields by defining more categories, e.g. one for each field or group of fields on an entity.</entity_narration>
<entity_object_field>audit_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>no</version_data>
<deploy_data>no</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="88"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSTBT</entity_mnemonic>
<entity_mnemonic_short_desc>batch job</entity_mnemonic_short_desc>
<entity_mnemonic_description>gst_batch_job</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924401.09</entity_mnemonic_obj>
<entity_description_field></entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>A job can be run immediately or at a user selected time in which case it is stored as a batch job. A daemon will monitor this table and initiate the jobs at the selected time.

The batch_job_procedure_name may be the same as a report_procedure_name, or it may be for a separate procedure that initiates a number of separate procedures. These may or may not be report_procedure_name's.

Parameters for the batch job will be stored as per those for the report definition.</entity_narration>
<entity_object_field>batch_job_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>no</version_data>
<deploy_data>no</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="89"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSTDF</entity_mnemonic>
<entity_mnemonic_short_desc>dataset file</entity_mnemonic_short_desc>
<entity_mnemonic_description>gst_dataset_file</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>4623.24</entity_mnemonic_obj>
<entity_description_field></entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This table keeps a record of ADO files generated for a dataset. A single dataset may be generated out to multiple ADO files.

The purpose of this table is to record the date and time this dataset ADO file was last loaded into the current repository. Checks will be made against the file date on disk to see whether a new files has been downloaded from POSSE and needs to be updated into the local repository.

If an ADO file is included as part of a package, this table records the package that the ADO file belongs to.</entity_narration>
<entity_object_field>dataset_file_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field>dataset_file_obj</entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>no</version_data>
<deploy_data>no</deploy_data>
<entity_dbname>ICFDB</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
<contained_record DB="ICFDB" Table="gsc_entity_display_field"><entity_display_field_obj>4624.24</entity_display_field_obj>
<entity_mnemonic>GSTDF</entity_mnemonic>
<display_field_name>ado_filename</display_field_name>
<display_field_order>1</display_field_order>
<display_field_label></display_field_label>
<display_field_column_label></display_field_column_label>
<display_field_format></display_field_format>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_entity_display_field"><entity_display_field_obj>4625.24</entity_display_field_obj>
<entity_mnemonic>GSTDF</entity_mnemonic>
<display_field_name>loaded_date</display_field_name>
<display_field_order>2</display_field_order>
<display_field_label></display_field_label>
<display_field_column_label></display_field_column_label>
<display_field_format></display_field_format>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_entity_display_field"><entity_display_field_obj>4626.24</entity_display_field_obj>
<entity_mnemonic>GSTDF</entity_mnemonic>
<display_field_name>loaded_time</display_field_name>
<display_field_order>3</display_field_order>
<display_field_label></display_field_label>
<display_field_column_label></display_field_column_label>
<display_field_format></display_field_format>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="90"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSTDP</entity_mnemonic>
<entity_mnemonic_short_desc>deployment</entity_mnemonic_short_desc>
<entity_mnemonic_description>gst_deployment</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>4627.24</entity_mnemonic_obj>
<entity_description_field></entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This table defines an instance of a deployment package, from a particular site. Records in this table may be manually created for the curent site, or may be imported as part of loading a deployment package from an external site.</entity_narration>
<entity_object_field>deployment_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field>deployment_obj</entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>no</version_data>
<deploy_data>no</deploy_data>
<entity_dbname>ICFDB</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
<contained_record DB="ICFDB" Table="gsc_entity_display_field"><entity_display_field_obj>4633.24</entity_display_field_obj>
<entity_mnemonic>GSTDP</entity_mnemonic>
<display_field_name>baseline_deployment</display_field_name>
<display_field_order>6</display_field_order>
<display_field_label></display_field_label>
<display_field_column_label></display_field_column_label>
<display_field_format></display_field_format>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_entity_display_field"><entity_display_field_obj>4631.24</entity_display_field_obj>
<entity_mnemonic>GSTDP</entity_mnemonic>
<display_field_name>deployment_date</display_field_name>
<display_field_order>4</display_field_order>
<display_field_label></display_field_label>
<display_field_column_label></display_field_column_label>
<display_field_format></display_field_format>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_entity_display_field"><entity_display_field_obj>4630.24</entity_display_field_obj>
<entity_mnemonic>GSTDP</entity_mnemonic>
<display_field_name>deployment_description</display_field_name>
<display_field_order>3</display_field_order>
<display_field_label></display_field_label>
<display_field_column_label></display_field_column_label>
<display_field_format></display_field_format>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_entity_display_field"><entity_display_field_obj>4629.24</entity_display_field_obj>
<entity_mnemonic>GSTDP</entity_mnemonic>
<display_field_name>deployment_number</display_field_name>
<display_field_order>2</display_field_order>
<display_field_label></display_field_label>
<display_field_column_label></display_field_column_label>
<display_field_format></display_field_format>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_entity_display_field"><entity_display_field_obj>4632.24</entity_display_field_obj>
<entity_mnemonic>GSTDP</entity_mnemonic>
<display_field_name>deployment_time</display_field_name>
<display_field_order>5</display_field_order>
<display_field_label></display_field_label>
<display_field_column_label></display_field_column_label>
<display_field_format></display_field_format>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_entity_display_field"><entity_display_field_obj>4634.24</entity_display_field_obj>
<entity_mnemonic>GSTDP</entity_mnemonic>
<display_field_name>manual_record_selection</display_field_name>
<display_field_order>7</display_field_order>
<display_field_label></display_field_label>
<display_field_column_label></display_field_column_label>
<display_field_format></display_field_format>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_entity_display_field"><entity_display_field_obj>4628.24</entity_display_field_obj>
<entity_mnemonic>GSTDP</entity_mnemonic>
<display_field_name>originating_site_number</display_field_name>
<display_field_order>1</display_field_order>
<display_field_label></display_field_label>
<display_field_column_label></display_field_column_label>
<display_field_format></display_field_format>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_entity_display_field"><entity_display_field_obj>4635.24</entity_display_field_obj>
<entity_mnemonic>GSTDP</entity_mnemonic>
<display_field_name>package_control_file</display_field_name>
<display_field_order>8</display_field_order>
<display_field_label></display_field_label>
<display_field_column_label></display_field_column_label>
<display_field_format></display_field_format>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_entity_display_field"><entity_display_field_obj>4636.24</entity_display_field_obj>
<entity_mnemonic>GSTDP</entity_mnemonic>
<display_field_name>package_exception_file</display_field_name>
<display_field_order>9</display_field_order>
<display_field_label></display_field_label>
<display_field_column_label></display_field_column_label>
<display_field_format></display_field_format>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="91"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSTEL</entity_mnemonic>
<entity_mnemonic_short_desc>extract log</entity_mnemonic_short_desc>
<entity_mnemonic_description>gst_extract_log</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924403.09</entity_mnemonic_obj>
<entity_description_field></entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>Each time a data extract report is run, an entry is created in this file. The main intention is to track the completion of extract procedures so that report formatting procedures can be initiated where required.

In the event that an extract log record is deleted, then any document produced records associated with the extract should be cascade deleted, providing that the print date has not been set - in order to tidy up the data.</entity_narration>
<entity_object_field>extract_log_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>no</version_data>
<deploy_data>no</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="92"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSTER</entity_mnemonic>
<entity_mnemonic_short_desc>error log</entity_mnemonic_short_desc>
<entity_mnemonic_description>gst_error_log</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924402.09</entity_mnemonic_obj>
<entity_description_field></entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This table holds a list of errors generated either from business logic or user interface code.

The table will be periodically archived to ensure it does not get too huge.

The data in the table will be fed direct from the user interface, and periodically fed by the business logic error file which will be a flat file due to the fact that we cannot write direct to this table as the write would form part of the transaction being undone..</entity_narration>
<entity_object_field>error_log_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>no</version_data>
<deploy_data>no</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="93"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSTPH</entity_mnemonic>
<entity_mnemonic_short_desc>password history</entity_mnemonic_short_desc>
<entity_mnemonic_description>gst_password_history</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924404.09</entity_mnemonic_obj>
<entity_description_field></entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This table keeps a history of previous passwords used by users. It is used for audit purposes, and preventing users using the same password within a given time period, e.g. 1 year.</entity_narration>
<entity_object_field>password_history_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>no</version_data>
<deploy_data>no</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="94"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSTRV</entity_mnemonic>
<entity_mnemonic_short_desc>record version</entity_mnemonic_short_desc>
<entity_mnemonic_description>gst_record_version</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004927721.09</entity_mnemonic_obj>
<entity_description_field></entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This table provides the means for identifying when static data is changed and needs to be deployed. 

When an item of data on a record changes, the replication trigger on the table will check if the version_data flag on the gsc_entity_mnemonic table is switched on. 

If the flag is on, either a record is written to this table or an existing record in the table is updated to indicate that the data has changed by incrementing the version_number_seq and resetting date, time and user. 

This table is checked every time the deployment data is written to ensure that all data that matches the deployment criteria is written out.

If no record exists for a record that is supposed to be deployed, it is assumed that this data already exists in the remote database because it would have been created from a baseline or initial installation.</entity_narration>
<entity_object_field>record_version_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field>record_version_obj</entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>no</version_data>
<deploy_data>no</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
<contained_record DB="ICFDB" Table="gsc_entity_display_field"><entity_display_field_obj>4643.24</entity_display_field_obj>
<entity_mnemonic>GSTRV</entity_mnemonic>
<display_field_name>deletion_flag</display_field_name>
<display_field_order>7</display_field_order>
<display_field_label></display_field_label>
<display_field_column_label></display_field_column_label>
<display_field_format></display_field_format>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_entity_display_field"><entity_display_field_obj>4637.24</entity_display_field_obj>
<entity_mnemonic>GSTRV</entity_mnemonic>
<display_field_name>entity_mnemonic</display_field_name>
<display_field_order>1</display_field_order>
<display_field_label></display_field_label>
<display_field_column_label></display_field_column_label>
<display_field_format></display_field_format>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_entity_display_field"><entity_display_field_obj>4644.24</entity_display_field_obj>
<entity_mnemonic>GSTRV</entity_mnemonic>
<display_field_name>import_version_number_seq</display_field_name>
<display_field_order>8</display_field_order>
<display_field_label></display_field_label>
<display_field_column_label></display_field_column_label>
<display_field_format></display_field_format>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_entity_display_field"><entity_display_field_obj>4638.24</entity_display_field_obj>
<entity_mnemonic>GSTRV</entity_mnemonic>
<display_field_name>key_field_value</display_field_name>
<display_field_order>2</display_field_order>
<display_field_label></display_field_label>
<display_field_column_label></display_field_column_label>
<display_field_format></display_field_format>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_entity_display_field"><entity_display_field_obj>4645.24</entity_display_field_obj>
<entity_mnemonic>GSTRV</entity_mnemonic>
<display_field_name>last_version_number_seq</display_field_name>
<display_field_order>9</display_field_order>
<display_field_label></display_field_label>
<display_field_column_label></display_field_column_label>
<display_field_format></display_field_format>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_entity_display_field"><entity_display_field_obj>4640.24</entity_display_field_obj>
<entity_mnemonic>GSTRV</entity_mnemonic>
<display_field_name>version_date</display_field_name>
<display_field_order>4</display_field_order>
<display_field_label></display_field_label>
<display_field_column_label></display_field_column_label>
<display_field_format></display_field_format>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_entity_display_field"><entity_display_field_obj>4639.24</entity_display_field_obj>
<entity_mnemonic>GSTRV</entity_mnemonic>
<display_field_name>version_number_seq</display_field_name>
<display_field_order>3</display_field_order>
<display_field_label></display_field_label>
<display_field_column_label></display_field_column_label>
<display_field_format></display_field_format>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_entity_display_field"><entity_display_field_obj>4641.24</entity_display_field_obj>
<entity_mnemonic>GSTRV</entity_mnemonic>
<display_field_name>version_time</display_field_name>
<display_field_order>5</display_field_order>
<display_field_label></display_field_label>
<display_field_column_label></display_field_column_label>
<display_field_format></display_field_format>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_entity_display_field"><entity_display_field_obj>4642.24</entity_display_field_obj>
<entity_mnemonic>GSTRV</entity_mnemonic>
<display_field_name>version_user</display_field_name>
<display_field_order>6</display_field_order>
<display_field_label></display_field_label>
<display_field_column_label></display_field_column_label>
<display_field_format></display_field_format>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="95"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>GSTTO</entity_mnemonic>
<entity_mnemonic_short_desc>trigger override</entity_mnemonic_short_desc>
<entity_mnemonic_description>gst_trigger_override</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>0</entity_mnemonic_obj>
<entity_description_field>table_name</entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This table facilitates the generic override of triggers for any table in the database. 

It is required because the trigger override statements can not be done generically. It also offers more flexibility over which triggers to override. Any comination of triggers is supported with * for all, e.g.

create
delete
write
find
replication-create
replication-delete
replication-find
replication-write

Standard checks are included into triggers via the include file af/sup2/aftrgover.i which references this table and does a can find check on the table name, the transaction id (from dbtaskid) and also checks for a date range of 2 days from the current system date to ensure we do not find redundant data.

A transaction id as generated from the dbtaskid statement. This is used so that the override functionality only works within the context of a single transaction.

Records must therefore be created in this table within the same transaction that the triggers need to be overridden.

Extra information is included in the table for audit purposes to track down problem areas if records get left in this table.

One area where this is used is when dumping / loading data via xml files for deployment datasets that require ri triggers to be disabled.

</entity_narration>
<entity_object_field>trigger_override_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>no</version_data>
<deploy_data>no</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="96"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>RVCCT</entity_mnemonic>
<entity_mnemonic_short_desc>configuration type</entity_mnemonic_short_desc>
<entity_mnemonic_description>rvc_configuration_type</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924350.09</entity_mnemonic_obj>
<entity_description_field>type_description</entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This defines the types of data item which require version control.  Each type should correspond to a single database table.  Any alteration to this table or its direct children will be versioned, and require the item to be checked out.  This is achieved by having suitable REPLICATION triggers on all involved tables.

e.g. ryc_smartobject (and it's related tables: ryc_page, ryc_smartlink, etc.).

In this case the SmartObject is a configuration type.  Any changes to records in ryv_smartobject, ryc_page etc.  will result in a new version of that smartobject.  

The log records maintained are sensitive to schema changes in any of the invoved tables.  Utilities will be provided for restructuring these log entries in the event that version recovery is desired across schema changes.

Fields exist in this table for integration with a SCM tool, e.g. Roundtable. They identify the identifying field in the table that maps to the object name in the SCM tool. They then identify which fields form the primary key to enable a simple cross reference between the SCM object and the primary key of the data. For example, in the ryc_smartbject table, the identify field would be object_filename and the primary key fields would be smartobject_obj. This means that we could find a smartobject record using the object filename and get the smartobject object number.</entity_narration>
<entity_object_field>configuration_type_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field>configuration_type</entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>no</version_data>
<deploy_data>no</deploy_data>
<entity_dbname>rvdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="97"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>RVMCI</entity_mnemonic>
<entity_mnemonic_short_desc>configuration item</entity_mnemonic_short_desc>
<entity_mnemonic_description>rvm_configuration_item</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924351.09</entity_mnemonic_obj>
<entity_description_field>scm_object_name</entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This is a particular item of data under version control e.g. a particular smartobject. 

Configuration items must belong to a product module.  The configuration type dictates the type of data, and the object name represents the identifying field of the record in the table - also as used for the object name in the SCM tool.
</entity_narration>
<entity_object_field>configuration_item_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>no</version_data>
<deploy_data>no</deploy_data>
<entity_dbname>rvdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="98"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>RVMTA</entity_mnemonic>
<entity_mnemonic_short_desc>task</entity_mnemonic_short_desc>
<entity_mnemonic_description>rvm_task</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924433.09</entity_mnemonic_obj>
<entity_description_field></entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This table replicates the rtb_task table in the Roundtable repository. Its purpose is so that we can add extra fields to the task table, and also add our own indexes for optimum performance with our test status tracking.

We have duplicated the fields from the rtb_task table to avoid having to join to it, plus to allow additional indexing on the fields within it.

The main additions are for actual and estimated hours, current test area and status to track the progress of the task through the workspaces.

Any actions peformed on rtb_task must be done on this table also, and vice-versa, as the tables should be viewed as a single table.</entity_narration>
<entity_object_field>task_number</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field>task_number</entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>no</version_data>
<deploy_data>no</deploy_data>
<entity_dbname>rvdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="99"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>RVMTB</entity_mnemonic>
<entity_mnemonic_short_desc>task object</entity_mnemonic_short_desc>
<entity_mnemonic_description>rvm_task_object</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924435.09</entity_mnemonic_obj>
<entity_description_field>task_object_name</entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This table defines the object versions that were worked on in a task. It is similar to the rtb_ver table in Roundtable, but holds different information for test status tracking and additional indexing.

In this table, we are only interested in PCODE objects, not schema, as schema is always changed outside Roundtable in ERwin and changes stored in incremental df files. We do not need to track testing over schema changes, we rather need to track the program changes made to implement the schema changes, which will be in a seperate task.

Also, this table only contains objects that have been checked in under a task, as until they have been checked in, no test status tracking is required and the object may be deleted.</entity_narration>
<entity_object_field>task_object_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>no</version_data>
<deploy_data>no</deploy_data>
<entity_dbname>rvdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="100"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>RVMTY</entity_mnemonic>
<entity_mnemonic_short_desc>task history</entity_mnemonic_short_desc>
<entity_mnemonic_description>rvm_task_history</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924434.09</entity_mnemonic_obj>
<entity_description_field></entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This table records a history of the different test status's and areas the task has progressed through, recording the date, time and user, and allowing additional recording of notes and hours for each stage of the tasks lifecycle.</entity_narration>
<entity_object_field>task_history_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>no</version_data>
<deploy_data>no</deploy_data>
<entity_dbname>rvdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="101"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>RVMWI</entity_mnemonic>
<entity_mnemonic_short_desc>workspace item</entity_mnemonic_short_desc>
<entity_mnemonic_description>rvm_workspace_item</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924353.09</entity_mnemonic_obj>
<entity_description_field>scm_object_name</entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This table defines which item versions exist in a specific workspace.

Where an item is being worked on in the workspace, this table will record both the current version number and the wip version number.  The wip version is available in the database, but may not be checked back in, in which case the wip version recorded here will revert to the current version.

The wip version number will only contain a value whilst the workspace item is checked out under a task, otherwise it will be 0.

When moving items between workspaces, only the item version number will be used. A modification must be completed (checked in) before it can progress to any other workspace.</entity_narration>
<entity_object_field>workspace_item_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>no</version_data>
<deploy_data>no</deploy_data>
<entity_dbname>rvdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="102"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>RVMWM</entity_mnemonic>
<entity_mnemonic_short_desc>workspace module</entity_mnemonic_short_desc>
<entity_mnemonic_description>rvm_workspace_module</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924354.09</entity_mnemonic_obj>
<entity_description_field></entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This table defines the product modules that belong to a particular workspace, and whether the product module is primary or sourced from a different workspace.

If a product module is primary to this workspace then the data versions should ordinarily be modified within this workspace.  If the product module is not primary, then the data versions should ordinarily be modified in their source workspace and imported into this workspace.  These rules may not be rigorously enforced.

</entity_narration>
<entity_object_field>workspace_module_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>no</version_data>
<deploy_data>no</deploy_data>
<entity_dbname>rvdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="103"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>RVMWS</entity_mnemonic>
<entity_mnemonic_short_desc>workspace</entity_mnemonic_short_desc>
<entity_mnemonic_description>rvm_workspace</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924352.09</entity_mnemonic_obj>
<entity_description_field>workspace_description</entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This is the definition of a workspace, which is a specific configuration of item versions (in this case the items represent data).  Item versions exist outside the context of a workspace.  Workspaces are used to control the various stages of the development process, typically including Development, Test and Deployment areas.  They also exist to manage customer-specific configurations (e.g. what specific products and versions thereof a customer is running).  

If a workspace becomes obsolete then it can be deleted.  This does not delete the items or their versions, but merely the record of what versions were in the particular workspace.

If using Roundtable, these workspaces should correspond to those in Roundtable itself.

It is possible to check out an entire workspace if desired.

In the first version of the Versioning system we are going to be heavilly dependant on Roundtable integration.  Smartobject records correspond to logical gsc_object records which are actually checked out in roundtable  We will not initially support versioning of orther configuration types.
</entity_narration>
<entity_object_field>workspace_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field>workspace_code</entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>no</version_data>
<deploy_data>no</deploy_data>
<entity_dbname>rvdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="104"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>RVTAC</entity_mnemonic>
<entity_mnemonic_short_desc>action</entity_mnemonic_short_desc>
<entity_mnemonic_description>rvt_action</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924355.09</entity_mnemonic_obj>
<entity_description_field></entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This table contains entries for every action (CREATE, WRITE, DELETE) for all involved tables in the database.  Actions form parts of a transaction, which must be assigned to a task.

The information stored in the action table is sufficient to replay that action at some later stage: The name of the table, the action, and the raw-transfer data representing the action.

Action entries rely on a raw-transfer operation for the efficient construction of data.  This is sensitive to schema changes in the involved tables.  Utilities will be provided to restructure log entries when version recovery is required across schema changes.
</entity_narration>
<entity_object_field>action_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>no</version_data>
<deploy_data>no</deploy_data>
<entity_dbname>rvdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="105"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>RVTAU</entity_mnemonic>
<entity_mnemonic_short_desc>action underway</entity_mnemonic_short_desc>
<entity_mnemonic_description>rvt_action_underway</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924356.09</entity_mnemonic_obj>
<entity_description_field>action_scm_object_name</entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This table will only contain records during a  transaction for some acrtion, e.g. deletion, assignment, etc. Its purpose is to make primary table information available to involved tables during the operation, e.g. cascade deletion, object assignment, etc.

The problem is that during a deletion of the primary table, the involved tables replication triggers can not access the primary table anymore, as it has been deleted.

To resolve this issue, we will create a record in this table at the top of the delete trigger of a primary table, and subsequently delete the record at the end of the primary table replication delete trigger. This means the information will be available throughout the entire delete transaction.

For the assignment of data between repositories via the versioning system, we need to know we are doing the assignment and ensure we do not fire off replication code to create transaction and action records, as it is simply moving existing versions of data rather than changing data.

Under normal cicumstances (no active transaction), this table will be empty.</entity_narration>
<entity_object_field>action_underway_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>no</version_data>
<deploy_data>no</deploy_data>
<entity_dbname>rvdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="106"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>RVTDI</entity_mnemonic>
<entity_mnemonic_short_desc>deleted item</entity_mnemonic_short_desc>
<entity_mnemonic_description>rvt_deleted_item</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924357.09</entity_mnemonic_obj>
<entity_description_field>scm_object_name</entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This table records items that were deleted from a workspace in the context of a task. Only registered items that are deleted from a workspace need to be recorded in this table.

The purpose of this table is to provide the SCM tool with the information required to delete its corresponding item from its repository, probably as part of some task completion process.

The SCM tool should remove this record once it has actioned the deletion in its own repository.
</entity_narration>
<entity_object_field>deleted_item_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>no</version_data>
<deploy_data>no</deploy_data>
<entity_dbname>rvdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="107"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>RVTIV</entity_mnemonic>
<entity_mnemonic_short_desc>item version</entity_mnemonic_short_desc>
<entity_mnemonic_description>rvt_item_version</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924358.09</entity_mnemonic_obj>
<entity_description_field>item_description</entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This represents a single version of a configuration item.  At least one version must exist for the item.

New versions are not created when an item is checked out, but only when an item that has been checked out is first modified.

Once a version has been checked in it may not be deleted.  We may provide archiving facilities, but in principle the item version still exists.





</entity_narration>
<entity_object_field>item_version_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>no</version_data>
<deploy_data>no</deploy_data>
<entity_dbname>rvdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="108"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>RVTTR</entity_mnemonic>
<entity_mnemonic_short_desc>transaction</entity_mnemonic_short_desc>
<entity_mnemonic_description>rvt_transaction</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924359.09</entity_mnemonic_obj>
<entity_description_field>scm_object_name</entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This table, in conjunction with rvt_action, contains the information required to construct an item version (including all related table information) from its previous version. The construcrtion of an item version may span multiple transactions.

This table defines all transactions that occur on involved tables in the database. Involved tables means the table being version controlled, plus all its related tables.

We assume in this model that a single transaction affects only a single item version within a single task. This means you cannot have a single transaction that would delete for example many records in a versioned table. Each deletion would need to occur in a seperate transaction. The reason for this is that a single transaction spanning multiple objects and versions would cause massive complexity in the roll forward behaviour.

We also assume that the transaction id is unique within a task. We do not assume it is unique universally (which it would not be).

The storing of the transaction id enables us to reproduce all updates performed in the context of a single transaction. When rolling forward the updates in a single transaction, we will disable all triggers, as the transaction will already include all updates that resulted from the initial firing of the triggers for related tables, e.g. cascade deletes, update of statistical information, etc.

Note: the update of statistical information on unrelated tables will not be performed automatically.

We assume that the transaction_id is in ascending sequence, and that groups of actions should be performed in this sequence.  Within the sequence, all actions with the same transaction_id form part of the same physical transaction.  Experience will dictate whether this sequencing is valid.

The deletion of an item of data in the primary table will not generate transaction and action records. The replication of this deletion between repositories will be handled by the SCM Tool (via import /assign hooks).
</entity_narration>
<entity_object_field>transaction_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>no</version_data>
<deploy_data>no</deploy_data>
<entity_dbname>rvdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="109"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>RVTWC</entity_mnemonic>
<entity_mnemonic_short_desc>workspace checkout</entity_mnemonic_short_desc>
<entity_mnemonic_description>rvt_workspace_checkout</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924360.09</entity_mnemonic_obj>
<entity_description_field></entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This table defines the configuration items that are checked out in the various workspaces. When the item is checked back in, this record will be deleted.

A check_out record can be considered to be a licence to change the item and associated data. 

The checkout of an item should also create a new rtv_item_version record and assign that to be the task version for that item in the workspace.</entity_narration>
<entity_object_field>workspace_checkout_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>no</version_data>
<deploy_data>no</deploy_data>
<entity_dbname>rvdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="110"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>RYCAC</entity_mnemonic>
<entity_mnemonic_short_desc>action</entity_mnemonic_short_desc>
<entity_mnemonic_description>ryc_action</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924437.09</entity_mnemonic_obj>
<entity_description_field></entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This table defines the actions available to place on a toolbar. Actions are organised into bands and whole bands are always allocated to toolbars rather than individual actions. An action however may be included in many bands.

Example toolbar actions would include navigation - first, next, previous, last, tableio - add, delete, modify, view, copy, etc. etc.

All actions in this table are standard actions available to all applications using the repository.
</entity_narration>
<entity_object_field>action_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field>action_reference</entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="111"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>RYCAP</entity_mnemonic>
<entity_mnemonic_short_desc>attribute group</entity_mnemonic_short_desc>
<entity_mnemonic_description>ryc_attribute_group</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924439.09</entity_mnemonic_obj>
<entity_description_field>attribute_group_name</entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This table facilitates the logical grouping of attributes to simplify their use, e.g. geometry, statusbar, etc. The primary use of this table is make the presentation of the attributes to the user more effective and usable. It is likely we could use a tree view, with attribute groups as a node and pressing plus on the group, showing all attributes within that group.</entity_narration>
<entity_object_field>attribute_group_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="112"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>RYCAT</entity_mnemonic>
<entity_mnemonic_short_desc>attribute</entity_mnemonic_short_desc>
<entity_mnemonic_description>ryc_attribute</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924438.09</entity_mnemonic_obj>
<entity_description_field></entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This table defines the attributes that may be allocated to smartobjects, e.g. size, position, window title, query, where clause, etc. They are used to defined the properties of dynamic objects, plus to dynamically alter the behaviour of static objects.

Certain attributes are required for the application to function correctly and these will be set to system owned to prevent accidental deletion. Only users that are classified as able to maintain system owned information may manipulate this data. In many cases, the actual attribute label will need to match to a valid Progress supported attribute.

Default attributes may be defined for the various smartobject types in the type attribute table, plus additional attributes allocated for each instance of a smartobject, thus the types define default bahaviour that may be overriden and extended for each instance.

Due to the powerful feature of allowing attributes to be defined at various levels, most dynamic data about smartobjects will utilise attributes.

Example areas that we will utilise attributes for include browser query, sort order and where clauses, container window titles, which window to run based on various button actions in a browser, e.g. add, modify, view, etc., status bar configuration, page enabling and disabling, field enabling and disabling by object instance, whether toolbar items are included in the menu, etc.

</entity_narration>
<entity_object_field>attribute_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="113"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>RYCAV</entity_mnemonic>
<entity_mnemonic_short_desc>attribute value</entity_mnemonic_short_desc>
<entity_mnemonic_description>ryc_attribute_value</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924441.09</entity_mnemonic_obj>
<entity_description_field></entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This entity associated attributes with object types, smartobjects, and smartobject instances, and specifies the value of the attribute.

Where the attribute is associated with an object type or a smartobject, then the attribute value will reflect a default value. where the attribute is associated with an instance of a smartobject, then the value will reflect an actual value.

When creating entries in this table for attributes associated with an object type, then the smart object and instance will be 0.

When creating entries in the table for a smartobject, we will also populate the object type field to avoid having 0 in the key. Likewise when creating attributes for an object instance, we will populate the object type and the smartobject. This ensures effective use of the alternate keys.

Note: We must be careful when looking for attributes associated with an object type to ensure we look for the specific object type and 0 values for the smartobject and instance fields.

Where an attribute is defined as a collection, then attribute values can be linked together. The "attribute_value" field of the collection attribute_value record will be the number of elements in the collection, and this will then parent each of the attribute value records in the collection by collection sequence.

Where attribute values are defined for object types and smartobjects, these values will be cascaded down to actual smartobject instances for performance reasons. Any future modifications of these values will also be cascaded down to all instances where the inherrited_value is set to YES, therefore ensuring we do not overwrite manual changes made at an instance level.
</entity_narration>
<entity_object_field>attribute_value_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="114"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>RYCAY</entity_mnemonic>
<entity_mnemonic_short_desc>attribute type</entity_mnemonic_short_desc>
<entity_mnemonic_description>ryc_attribute_type</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924440.09</entity_mnemonic_obj>
<entity_description_field>attribute_type_description</entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This table defines the types of attributes supported. Attribute types then define the structure of values associated with attributes of this type. Example attribute types could be:

CHR = Character
COL = Collection
IMG = Image (so we can search/preview)
FIL = File (so we can search)
</entity_narration>
<entity_object_field>attribute_type_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field>attribute_type_tla</entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="115"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>RYCBA</entity_mnemonic>
<entity_mnemonic_short_desc>band action</entity_mnemonic_short_desc>
<entity_mnemonic_description>ryc_band_action</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924443.09</entity_mnemonic_obj>
<entity_description_field></entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This table defines the actions allocated to bands. an action may be allocated to many bands, and a band may include many actions.

This table facilitates the re-use of actions in many bands. If multiple bands are included on a toolbar, and duplicate actions occur then this will be ignored and the user must re-organise the band actions accordingly.</entity_narration>
<entity_object_field>band_action_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="116"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>RYCBD</entity_mnemonic>
<entity_mnemonic_short_desc>band</entity_mnemonic_short_desc>
<entity_mnemonic_description>ryc_band</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924442.09</entity_mnemonic_obj>
<entity_description_field>band_name</entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This table provides a grouping mechanism for related toolbar actions, e.g. navigation, update, browse, desktop, system, etc. They equate to toolbar bands and each band will likely be demarkated with seperators for clarity.

Bands are allocated to the dynamic toolbar using instance attributes.</entity_narration>
<entity_object_field>band_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="117"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>RYCCT</entity_mnemonic>
<entity_mnemonic_short_desc>custom ui trigger</entity_mnemonic_short_desc>
<entity_mnemonic_description>ryc_custom_ui_trigger</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924444.09</entity_mnemonic_obj>
<entity_description_field></entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This table facilitates the generic allocation of UI triggers to individual fields and frames directly from the repository. For example, we could define an event to publish or a procedure to run when a specific button is pressed on a specific viewer.

The actual code would have to already exist or reside in a super procedure.</entity_narration>
<entity_object_field>custom_ui_trigger_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="118"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>RYCLA</entity_mnemonic>
<entity_mnemonic_short_desc>layout</entity_mnemonic_short_desc>
<entity_mnemonic_description>ryc_layout</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924445.09</entity_mnemonic_obj>
<entity_description_field>layout_name</entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This table defines the available page layouts for pages on smartfolder windows, e.g. 1 browser with 1 toolbar underneath, n viewers above each other, 2 side by side viewers, 2 side by side browsers, etc.

It also defines the available frame layouts for objects on a frame, e.g. 1 column, 2 columns, etc.

The purpose of this table is to specify the program which is responsible for the layout when the window / frame  is construted or resized.
</entity_narration>
<entity_object_field>layout_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="119"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>RYCOI</entity_mnemonic>
<entity_mnemonic_short_desc>object instance</entity_mnemonic_short_desc>
<entity_mnemonic_description>ryc_object_instance</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924446.09</entity_mnemonic_obj>
<entity_description_field></entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This is a running instance of an object on a container. This facilitates the allocation of specific attributes, links, and page numbers, etc. for the specific instance of an object.

The reason that the container_obj is included in the primary key is to ensure that we can only create links between objects in a single container, and to stop us creating links between objects in different containers at design time. The object_instance_obj however is uniqe in its own right, therefor avoiding having to specify a rolename for the container when propogating the key onto the smartlink table.</entity_narration>
<entity_object_field>object_instance_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="120"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>RYCPA</entity_mnemonic>
<entity_mnemonic_short_desc>page</entity_mnemonic_short_desc>
<entity_mnemonic_description>ryc_page</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924447.09</entity_mnemonic_obj>
<entity_description_field></entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This table defines the actual pages in a container. All containers must at least have one page, which is page 0 and is always displayed. All objects on page 0 are always displayed. If there are no other pages, then no tab folder is visualised.

Example pages could be Page 1, Page 2, Customer Details, etc.</entity_narration>
<entity_object_field>page_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="121"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>RYCPO</entity_mnemonic>
<entity_mnemonic_short_desc>page object</entity_mnemonic_short_desc>
<entity_mnemonic_description>ryc_page_object</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924448.09</entity_mnemonic_obj>
<entity_description_field></entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This table defines the object instances that appear on a page of a container and in what sequence they should be created by the layout manager. How these objects communicate on the container is defined by the supported links table.</entity_narration>
<entity_object_field>page_object_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="122"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>RYCSF</entity_mnemonic>
<entity_mnemonic_short_desc>smartobject field</entity_mnemonic_short_desc>
<entity_mnemonic_description>ryc_smartobject_field</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924452.09</entity_mnemonic_obj>
<entity_description_field>field_name</entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This table contains field infromation for smartdataobjects (sdo's), smartviewers, smartbrowsers, webbrower's, webforms, etc.

Certain information is specific to certain types of objects, but is contained in a central table for performance and simplicity reasons, and to reduce the number of tables required by the repository.

The table defines the fields for a smartdataobject which are all the fields available to any objects using the smartdataobject.

When the fields are related to anything other than a smartdataobject, certain of the values only need to be specified if they differ from the default values defined in the smartdataobject fields, thereby facilitating the override of default values per instance.

Holding this information in the repository removes the dependany on the Progress system tables (underscore tables) and also allows us to add extra information required by the repository. We provide import tables to automatically create a lot of this information directly from existing objects, and wizards on the smartdataobject to populate the data for new objects.



</entity_narration>
<entity_object_field>smartobject_field_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="123"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>RYCSL</entity_mnemonic>
<entity_mnemonic_short_desc>supported link</entity_mnemonic_short_desc>
<entity_mnemonic_description>ryc_supported_link</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924454.09</entity_mnemonic_obj>
<entity_description_field></entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This table defines the supported smartlinks for the various type of smartobjects, and whether the link can be a source, target, or both.

User defined links should not be set-up in this table. This table is purely to ensure that when linking objects on containers, only valid system links are used, plus user defined links. It is merely a developer aid.

Not all types of smartobjects support links, in which case there will be no entries in this table for them.</entity_narration>
<entity_object_field>supported_link_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="124"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>RYCSM</entity_mnemonic>
<entity_mnemonic_short_desc>smartlink</entity_mnemonic_short_desc>
<entity_mnemonic_description>ryc_smartlink</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924449.09</entity_mnemonic_obj>
<entity_description_field>link_name</entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This table defines the actual smartlinks between objects on a container, to facilitate object communication. The link name may be user defined, or automatically copied from the smartlink type for system supported links.

If the source object instance is not specified, then the source s assumed to be the container. Likewise if the target object instance is not specified, then the target is assumed to be the container.

Example links would be a tableio link between a smartbrowser and a smarttoolbar, a record link between a smartbrowser and a smartviewer, etc.</entity_narration>
<entity_object_field>smartlink_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="125"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>RYCSO</entity_mnemonic>
<entity_mnemonic_short_desc>smartobject</entity_mnemonic_short_desc>
<entity_mnemonic_description>ryc_smartobject</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924451.09</entity_mnemonic_obj>
<entity_description_field></entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This entity represents every smartobject known to the repository, whether static or dynamic.

Relationships exist to various child tables; however the existence of data in these child tables corresponding to this particular smartobject is dictated by the smartobject type - e.g. only Toolbar smartobjects may have toolbar group data.

Some smartobjects are visualisations of data provided by a smartdataobject.  This is represented by the cyclic relationship "provides data for".

NOTE: Every ICF object will be automatically created in this table to make it easy to use a mixture of static and dynamic objects onto static or dynamic containers. The creation of these records should therefore be done by the appropriate wizards, etc.

NOTE2: We have turned off the delete trigger RI to prevent an object being deleted if it is on a container somewhere - to allow our imports and assignments of the data in the versioning system to work. Therefore, this RI must be manually coded wherever it is possible to delete a smartobject, to ensure smartobjects that exist on containers are not inadvertantly deleted.

NOTE3: We turned off the automatic delete cascade of smartobject attributes as it was also deleting attributes for instances of the smartobject when we did not want it to. Added a specific delete trigger customisation that rather joined on the primary_smartobject_obj in the attribute table when deleting attributes, to ensure only attributes for the smartobject were deleted, not also instance attributes.</entity_narration>
<entity_object_field>smartobject_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="126"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>RYCST</entity_mnemonic>
<entity_mnemonic_short_desc>smartlink type</entity_mnemonic_short_desc>
<entity_mnemonic_description>ryc_smartlink_type</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924450.09</entity_mnemonic_obj>
<entity_description_field>link_name</entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This table defines the supported smart links available for linking objects on containers for object communication purposes.

Example links include page, container, update, commit, tableio, etc.

The main purpose of this table is to provide a valid list of smart links to choose from when building generic containers. Additional user defined smart links may be implemented by defining a user defined link.

The actual link name will be cascaded down onto the smartlink table where this is not a user defined link.

The supported link table will be used to highlight which are the expected links between any two smartobjects.
</entity_narration>
<entity_object_field>smartlink_type_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="127"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>RYCSU</entity_mnemonic>
<entity_mnemonic_short_desc>subscribe</entity_mnemonic_short_desc>
<entity_mnemonic_description>ryc_subscribe</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924453.09</entity_mnemonic_obj>
<entity_description_field></entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This is a generic table that facilitates any object subscribing to events across links and running internal procedures to perform some action as a result of the event.

Its primary use would be to subscribe frames or containers to system events.</entity_narration>
<entity_object_field>subscribe_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="128"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>RYCUE</entity_mnemonic>
<entity_mnemonic_short_desc>ui event</entity_mnemonic_short_desc>
<entity_mnemonic_description>ryc_ui_event</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1007600043.08</entity_mnemonic_obj>
<entity_description_field>event_name</entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This entity stores information about UI events for a smartobject. It works very similar to the ryc_attribute_value table in that UI events can be associated with object types, smartobjects, and smartobject instances.

Where the event is associated with an object type or a smartobject, then the event will reflect a default action. where the event is associated with an instance of a smartobject, then the action will reflect an actual action.

When creating entries in this table for events associated with an object type, then the smart object and instance will be 0.

When creating entries in the table for a smartobject, we will also populate the object type field to avoid having 0 in the key. Likewise when creating events for an object instance, we will populate the object type and the smartobject. This ensures effective use of the alternate keys.

Note: We must be careful when looking for events associated with an object type to ensure we look for the specific object type and 0 values for the smartobject and instance fields.

Where events are defined for object types and smartobjects, these values will be cascaded down to actual smartobject instances for performance reasons. Any future modifications of these values will also be cascaded down to all instances where the inherrited_value is set to YES, therefore ensuring we do not overwrite manual changes made at an instance level.
</entity_narration>
<entity_object_field>ui_event_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field>ui_event_obj</entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>ICFDB</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
<contained_record DB="ICFDB" Table="gsc_entity_display_field"><entity_display_field_obj>1007600048.08</entity_display_field_obj>
<entity_mnemonic>RYCUE</entity_mnemonic>
<display_field_name>action_target</display_field_name>
<display_field_order>12</display_field_order>
<display_field_label></display_field_label>
<display_field_column_label></display_field_column_label>
<display_field_format></display_field_format>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_entity_display_field"><entity_display_field_obj>1007600047.08</entity_display_field_obj>
<entity_mnemonic>RYCUE</entity_mnemonic>
<display_field_name>action_type</display_field_name>
<display_field_order>10</display_field_order>
<display_field_label></display_field_label>
<display_field_column_label></display_field_column_label>
<display_field_format></display_field_format>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_entity_display_field"><entity_display_field_obj>1007600046.08</entity_display_field_obj>
<entity_mnemonic>RYCUE</entity_mnemonic>
<display_field_name>constant_value</display_field_name>
<display_field_order>9</display_field_order>
<display_field_label></display_field_label>
<display_field_column_label></display_field_column_label>
<display_field_format></display_field_format>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_entity_display_field"><entity_display_field_obj>1007600049.08</entity_display_field_obj>
<entity_mnemonic>RYCUE</entity_mnemonic>
<display_field_name>event_action</display_field_name>
<display_field_order>11</display_field_order>
<display_field_label></display_field_label>
<display_field_column_label></display_field_column_label>
<display_field_format></display_field_format>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_entity_display_field"><entity_display_field_obj>1007600051.08</entity_display_field_obj>
<entity_mnemonic>RYCUE</entity_mnemonic>
<display_field_name>event_disabled</display_field_name>
<display_field_order>14</display_field_order>
<display_field_label></display_field_label>
<display_field_column_label></display_field_column_label>
<display_field_format></display_field_format>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_entity_display_field"><entity_display_field_obj>1007600044.08</entity_display_field_obj>
<entity_mnemonic>RYCUE</entity_mnemonic>
<display_field_name>event_name</display_field_name>
<display_field_order>7</display_field_order>
<display_field_label></display_field_label>
<display_field_column_label></display_field_column_label>
<display_field_format></display_field_format>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_entity_display_field"><entity_display_field_obj>1007600050.08</entity_display_field_obj>
<entity_mnemonic>RYCUE</entity_mnemonic>
<display_field_name>event_parameter</display_field_name>
<display_field_order>13</display_field_order>
<display_field_label></display_field_label>
<display_field_column_label></display_field_column_label>
<display_field_format></display_field_format>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_entity_display_field"><entity_display_field_obj>1007600045.08</entity_display_field_obj>
<entity_mnemonic>RYCUE</entity_mnemonic>
<display_field_name>inheritted_value</display_field_name>
<display_field_order>8</display_field_order>
<display_field_label></display_field_label>
<display_field_column_label></display_field_column_label>
<display_field_format></display_field_format>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="129"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>RYCUT</entity_mnemonic>
<entity_mnemonic_short_desc>ui trigger</entity_mnemonic_short_desc>
<entity_mnemonic_description>ryc_ui_trigger</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924455.09</entity_mnemonic_obj>
<entity_description_field>ui_trigger_name</entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>The supported Progress UI events, e.g. choose, value-changed, etc.</entity_narration>
<entity_object_field>ui_trigger_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="130"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>RYCVT</entity_mnemonic>
<entity_mnemonic_short_desc>valid ui trigger</entity_mnemonic_short_desc>
<entity_mnemonic_description>ryc_valid_ui_trigger</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924456.09</entity_mnemonic_obj>
<entity_description_field></entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This table defines the valid triggers supported for each widget type, e.g. a button may have a choose UI trigger. This is used to filter down the available UI triggers when defining custom UI triggers - therefore avoiding runtime errors.</entity_narration>
<entity_object_field>valid_ui_trigger_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="131"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>RYCWT</entity_mnemonic>
<entity_mnemonic_short_desc>widget type</entity_mnemonic_short_desc>
<entity_mnemonic_description>ryc_widget_type</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924457.09</entity_mnemonic_obj>
<entity_description_field>widget_type_name</entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This table defines the supported widget types, e.g. frame, button, fill-in, editor, radio-set, menu-item, etc.</entity_narration>
<entity_object_field>widget_type_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="132"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>RYMDV</entity_mnemonic>
<entity_mnemonic_short_desc>data version</entity_mnemonic_short_desc>
<entity_mnemonic_description>rym_data_version</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924458.09</entity_mnemonic_obj>
<entity_description_field></entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This table facilitates the generic storage of data version numbers without having to add a specific version number field to any tables that require version control.

This will definitely be used in the context of versioning smartobjects, but may also be used to record a version number for any data, e.g. menu items, help, etc.

The update of this table will be automated by the version control procedures if they are being used to control maintenance of the data.

This information must be made available generically to a help about window in the context of smartobject versioning.

The version number is the version number as at the time written by the versioning procedures. The data may have been subsequently changed by the user outside of the version control procedures, which is a situation we cannot generically hande.

</entity_narration>
<entity_object_field>data_version_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>no</version_data>
<deploy_data>no</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="133"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>RYMFP</entity_mnemonic>
<entity_mnemonic_short_desc>wizard fold page</entity_mnemonic_short_desc>
<entity_mnemonic_description>rym_wizard_fold_page</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924462.09</entity_mnemonic_obj>
<entity_description_field>sdo_object_name</entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This table defines the pages of the folder window, the objects that should appear on the page and attributes about the page itself.

How the objects are linked and organised on the page will be defaulted according to rules for a standard dynamic folder window.</entity_narration>
<entity_object_field>wizard_fold_page_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="134"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>RYMLF</entity_mnemonic>
<entity_mnemonic_short_desc>lookup field</entity_mnemonic_short_desc>
<entity_mnemonic_description>rym_lookup_field</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924459.09</entity_mnemonic_obj>
<entity_description_field>specific_object_name</entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This table defines fields that have smartdatafields linked to them.

If the smartdatafield is the special case of a dynamic lookup, then the majority of the fields define the instance attributes for the dynamic lookup.

The lookup can be specific to an object, or whereever a specific field occurs in any object.

This table is used by dynamic viewers to apply smartdatafields.
</entity_narration>
<entity_object_field>lookup_field_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="135"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>RYMWB</entity_mnemonic>
<entity_mnemonic_short_desc>wizard brow</entity_mnemonic_short_desc>
<entity_mnemonic_description>rym_wizard_brow</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924460.09</entity_mnemonic_obj>
<entity_description_field>sdo_name</entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This table captures wizard responses for the creation / modification of a standard ICF Dynamic Browser object.

It is used to forward engineer the object into the full Repository, generating all appropriate smartobject instances and attributes. Many assumptions are made regarding the look and feel of a standard ICF Browser which significantly simplifies the data that must be captured.

More complex specific modifications to an object may be made using the standard Repository Maintenance options.

This table also facilitates generation of the object into different UI's, e.g. Java.
</entity_narration>
<entity_object_field>wizard_brow_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="136"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>RYMWF</entity_mnemonic>
<entity_mnemonic_short_desc>wizard fold</entity_mnemonic_short_desc>
<entity_mnemonic_description>rym_wizard_fold</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924461.09</entity_mnemonic_obj>
<entity_description_field>object_description</entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This table captures wizard responses for the creation / modification of a standard ICF Dynamic Folder Window object.

It is used to forward engineer the object into the full Repository, generating all appropriate smartobject instances and attributes. Many assumptions are made regarding the look and feel of a standard ICF Folder Window which significantly simplifies the data that must be captured.

More complex specific modifications to an object may be made using the standard Repository Maintenance options.

This table also facilitates generation of the object into different UI's, e.g. Java.
</entity_narration>
<entity_object_field>wizard_fold_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="137"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>RYMWM</entity_mnemonic>
<entity_mnemonic_short_desc>wizard menc</entity_mnemonic_short_desc>
<entity_mnemonic_description>rym_wizard_menc</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924463.09</entity_mnemonic_obj>
<entity_description_field>object_description</entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This table captures wizard responses for the creation / modification of a standard ICF Dynamic Menu Controller object.

It is used to forward engineer the object into the full Repository, generating all appropriate smartobject instances and attributes. Many assumptions are made regarding the look and feel of a standard ICF Menu Controller which significantly simplifies the data that must be captured.

More complex specific modifications to an object may be made using the standard Repository Maintenance options.

This table also facilitates generation of the object into different UI's, e.g. Java.
</entity_narration>
<entity_object_field>wizard_menc_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="138"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>RYMWO</entity_mnemonic>
<entity_mnemonic_short_desc>wizard objc</entity_mnemonic_short_desc>
<entity_mnemonic_description>rym_wizard_objc</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924464.09</entity_mnemonic_obj>
<entity_description_field>browser_name</entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This table captures wizard responses for the creation / modification of a standard ICF Dynamic Object Controller object.

It is used to forward engineer the object into the full Repository, generating all appropriate smartobject instances and attributes. Many assumptions are made regarding the look and feel of a standard ICF Object Controller which significantly simplifies the data that must be captured.

More complex specific modifications to an object may be made using the standard Repository Maintenance options.

This table also facilitates generation of the object into different UI's, e.g. Java.
</entity_narration>
<entity_object_field>wizard_objc_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="139"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>RYMWT</entity_mnemonic>
<entity_mnemonic_short_desc>wizard tree</entity_mnemonic_short_desc>
<entity_mnemonic_description>rym_wizard_tree</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1007600054.08</entity_mnemonic_obj>
<entity_description_field>object_description</entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This table captures wizard responses for the creation / modification of a standard ICF Dynamic TreeView Controller object.

It is used to forward engineer the object into the full Repository, generating all appropriate smartobject instances and attributes. Many assumptions are made regarding the look and feel of a standard ICF TreeView Controller which significantly simplifies the data that must be captured.

More complex specific modifications to an object may be made using the standard Repository Maintenance options.

This table also facilitates generation of the object into different UI's, e.g. Java.
</entity_narration>
<entity_object_field>wizard_tree_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field>wizard_tree_obj</entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>ICFDB</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
<contained_record DB="ICFDB" Table="gsc_entity_display_field"><entity_display_field_obj>1007600067.08</entity_display_field_obj>
<entity_mnemonic>RYMWT</entity_mnemonic>
<display_field_name>auto_sort</display_field_name>
<display_field_order>16</display_field_order>
<display_field_label></display_field_label>
<display_field_column_label></display_field_column_label>
<display_field_format></display_field_format>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_entity_display_field"><entity_display_field_obj>1007600064.08</entity_display_field_obj>
<entity_mnemonic>RYMWT</entity_mnemonic>
<display_field_name>custom_super_procedure</display_field_name>
<display_field_order>13</display_field_order>
<display_field_label></display_field_label>
<display_field_column_label></display_field_column_label>
<display_field_format></display_field_format>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_entity_display_field"><entity_display_field_obj>1007600066.08</entity_display_field_obj>
<entity_mnemonic>RYMWT</entity_mnemonic>
<display_field_name>filter_viewer</display_field_name>
<display_field_order>14</display_field_order>
<display_field_label></display_field_label>
<display_field_column_label></display_field_column_label>
<display_field_format></display_field_format>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_entity_display_field"><entity_display_field_obj>1007600075.08</entity_display_field_obj>
<entity_mnemonic>RYMWT</entity_mnemonic>
<display_field_name>generated_date</display_field_name>
<display_field_order>8</display_field_order>
<display_field_label></display_field_label>
<display_field_column_label></display_field_column_label>
<display_field_format></display_field_format>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_entity_display_field"><entity_display_field_obj>1007600074.08</entity_display_field_obj>
<entity_mnemonic>RYMWT</entity_mnemonic>
<display_field_name>generated_time</display_field_name>
<display_field_order>9</display_field_order>
<display_field_label></display_field_label>
<display_field_column_label></display_field_column_label>
<display_field_format></display_field_format>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_entity_display_field"><entity_display_field_obj>1007600068.08</entity_display_field_obj>
<entity_mnemonic>RYMWT</entity_mnemonic>
<display_field_name>hide_selection</display_field_name>
<display_field_order>18</display_field_order>
<display_field_label></display_field_label>
<display_field_column_label></display_field_column_label>
<display_field_format></display_field_format>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_entity_display_field"><entity_display_field_obj>1007600069.08</entity_display_field_obj>
<entity_mnemonic>RYMWT</entity_mnemonic>
<display_field_name>image_height</display_field_name>
<display_field_order>19</display_field_order>
<display_field_label></display_field_label>
<display_field_column_label></display_field_column_label>
<display_field_format></display_field_format>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_entity_display_field"><entity_display_field_obj>1007600070.08</entity_display_field_obj>
<entity_mnemonic>RYMWT</entity_mnemonic>
<display_field_name>image_width</display_field_name>
<display_field_order>20</display_field_order>
<display_field_label></display_field_label>
<display_field_column_label></display_field_column_label>
<display_field_format></display_field_format>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_entity_display_field"><entity_display_field_obj>1007600058.08</entity_display_field_obj>
<entity_mnemonic>RYMWT</entity_mnemonic>
<display_field_name>object_description</display_field_name>
<display_field_order>5</display_field_order>
<display_field_label></display_field_label>
<display_field_column_label></display_field_column_label>
<display_field_format></display_field_format>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_entity_display_field"><entity_display_field_obj>1007600057.08</entity_display_field_obj>
<entity_mnemonic>RYMWT</entity_mnemonic>
<display_field_name>object_name</display_field_name>
<display_field_order>3</display_field_order>
<display_field_label></display_field_label>
<display_field_column_label></display_field_column_label>
<display_field_format></display_field_format>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_entity_display_field"><entity_display_field_obj>1007600065.08</entity_display_field_obj>
<entity_mnemonic>RYMWT</entity_mnemonic>
<display_field_name>page_layout</display_field_name>
<display_field_order>17</display_field_order>
<display_field_label></display_field_label>
<display_field_column_label></display_field_column_label>
<display_field_format></display_field_format>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_entity_display_field"><entity_display_field_obj>1007600055.08</entity_display_field_obj>
<entity_mnemonic>RYMWT</entity_mnemonic>
<display_field_name>product_code</display_field_name>
<display_field_order>4</display_field_order>
<display_field_label></display_field_label>
<display_field_column_label></display_field_column_label>
<display_field_format></display_field_format>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_entity_display_field"><entity_display_field_obj>1007600056.08</entity_display_field_obj>
<entity_mnemonic>RYMWT</entity_mnemonic>
<display_field_name>product_module_code</display_field_name>
<display_field_order>6</display_field_order>
<display_field_label></display_field_label>
<display_field_column_label></display_field_column_label>
<display_field_format></display_field_format>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_entity_display_field"><entity_display_field_obj>1007600061.08</entity_display_field_obj>
<entity_mnemonic>RYMWT</entity_mnemonic>
<display_field_name>root_node_code</display_field_name>
<display_field_order>10</display_field_order>
<display_field_label></display_field_label>
<display_field_column_label></display_field_column_label>
<display_field_format></display_field_format>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_entity_display_field"><entity_display_field_obj>1007600062.08</entity_display_field_obj>
<entity_mnemonic>RYMWT</entity_mnemonic>
<display_field_name>root_node_sdo_name</display_field_name>
<display_field_order>12</display_field_order>
<display_field_label></display_field_label>
<display_field_column_label></display_field_column_label>
<display_field_format></display_field_format>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_entity_display_field"><entity_display_field_obj>1007600063.08</entity_display_field_obj>
<entity_mnemonic>RYMWT</entity_mnemonic>
<display_field_name>sdo_foreign_fields</display_field_name>
<display_field_order>11</display_field_order>
<display_field_label></display_field_label>
<display_field_column_label></display_field_column_label>
<display_field_format></display_field_format>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_entity_display_field"><entity_display_field_obj>1007600071.08</entity_display_field_obj>
<entity_mnemonic>RYMWT</entity_mnemonic>
<display_field_name>show_check_boxes</display_field_name>
<display_field_order>21</display_field_order>
<display_field_label></display_field_label>
<display_field_column_label></display_field_column_label>
<display_field_format></display_field_format>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_entity_display_field"><entity_display_field_obj>1007600072.08</entity_display_field_obj>
<entity_mnemonic>RYMWT</entity_mnemonic>
<display_field_name>show_root_lines</display_field_name>
<display_field_order>22</display_field_order>
<display_field_label></display_field_label>
<display_field_column_label></display_field_column_label>
<display_field_format></display_field_format>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_entity_display_field"><entity_display_field_obj>1007600073.08</entity_display_field_obj>
<entity_mnemonic>RYMWT</entity_mnemonic>
<display_field_name>tree_style</display_field_name>
<display_field_order>23</display_field_order>
<display_field_label></display_field_label>
<display_field_column_label></display_field_column_label>
<display_field_format></display_field_format>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_entity_display_field"><entity_display_field_obj>1007600059.08</entity_display_field_obj>
<entity_mnemonic>RYMWT</entity_mnemonic>
<display_field_name>window_title</display_field_name>
<display_field_order>7</display_field_order>
<display_field_label></display_field_label>
<display_field_column_label></display_field_column_label>
<display_field_format></display_field_format>
</contained_record>
<contained_record DB="ICFDB" Table="gsc_entity_display_field"><entity_display_field_obj>1007600060.08</entity_display_field_obj>
<entity_mnemonic>RYMWT</entity_mnemonic>
<display_field_name>window_title_field</display_field_name>
<display_field_order>15</display_field_order>
<display_field_label></display_field_label>
<display_field_column_label></display_field_column_label>
<display_field_format></display_field_format>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="140"><contained_record DB="ICFDB" Table="gsc_entity_mnemonic"><entity_mnemonic>RYMWV</entity_mnemonic>
<entity_mnemonic_short_desc>wizard view</entity_mnemonic_short_desc>
<entity_mnemonic_description>rym_wizard_view</entity_mnemonic_description>
<auto_properform_strings>yes</auto_properform_strings>
<entity_mnemonic_label_prefix></entity_mnemonic_label_prefix>
<entity_mnemonic_obj>1004924465.09</entity_mnemonic_obj>
<entity_description_field>sdo_name</entity_description_field>
<entity_description_procedure></entity_description_procedure>
<entity_narration>This table captures wizard responses for the creation / modification of a standard ICF Dynamic Viewer object.

It is used to forward engineer the object into the full Repository, generating all appropriate smartobject instances and attributes. Many assumptions are made regarding the look and feel of a standard ICF Viewer which significantly simplifies the data that must be captured.

More complex specific modifications to an object may be made using the standard Repository Maintenance options.

This table also facilitates generation of the object into different UI's, e.g. Java.
</entity_narration>
<entity_object_field>wizard_view_obj</entity_object_field>
<table_has_object_field>yes</table_has_object_field>
<entity_key_field></entity_key_field>
<table_prefix_length>4</table_prefix_length>
<field_name_separator>_</field_name_separator>
<auditing_enabled>no</auditing_enabled>
<version_data>yes</version_data>
<deploy_data>yes</deploy_data>
<entity_dbname>icfdb</entity_dbname>
<replicate_entity_mnemonic></replicate_entity_mnemonic>
<replicate_key></replicate_key>
<scm_field_name></scm_field_name>
</contained_record>
</dataset_transaction>
</dataset_records>
</dataset>