<?xml version="1.0" encoding="ISO8859-1" ?>
<dataset Transactions="39" version_date="02/23/2002" version_time="42933" version_user="admin" entity_mnemonic="GSTDF" key_field_value="3000000381.09" record_version_obj="3000000382.09" version_number_seq="2.09" import_version_number_seq="1.09"><dataset_header DisableRI="yes" DatasetObj="1007600108.08" DateFormat="mdy" FullHeader="yes" SCMManaged="no" YearOffset="1950" DatasetCode="GSCGD" DateCreated="02/23/2002" TimeCreated="11:55:30" NumericFormat="AMERICAN" NumericDecimal="." OriginatingSite="93" NumericSeparator=","><deploy_dataset_obj>1007600108.08</deploy_dataset_obj>
<owner_site_code></owner_site_code>
<dataset_code>GSCGD</dataset_code>
<dataset_description>gsc_global_defaults - Global deflt</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<dataset_entity><dataset_entity_obj>1007600110.08</dataset_entity_obj>
<deploy_dataset_obj>1007600108.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSCGD</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>global_default_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<entity_mnemonic_description>gsc_global_default</entity_mnemonic_description>
<entity_dbname>icfdb</entity_dbname>
</dataset_entity>
<table_definition><name>gsc_global_default</name>
<dbname>ICFDB</dbname>
<index-1>XAK1gsc_global_default,1,0,0,owning_entity_mnemonic,0,owning_obj,0,default_type,0,effective_date,0</index-1>
<index-2>XPKgsc_global_default,1,1,0,global_default_obj,0</index-2>
<field><name>global_default_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>>>>>>>>>>>>>>>>>>9.999999999</format>
<initial>                 0.000000000</initial>
<label>Global Default Obj</label>
<column-label>Global Default Obj</column-label>
</field>
<field><name>owning_entity_mnemonic</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(8)</format>
<initial></initial>
<label>Owning Entity Mnemonic</label>
<column-label>Owning Entity Mnemonic</column-label>
</field>
<field><name>default_type</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(3)</format>
<initial></initial>
<label>Default Type</label>
<column-label>Default Type</column-label>
</field>
<field><name>effective_date</name>
<data-type>date</data-type>
<extent>0</extent>
<format>99/99/9999</format>
<initial></initial>
<label>Effective Date</label>
<column-label>Effective Date</column-label>
</field>
<field><name>owning_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>>>>>>>>>>>>>>>>>>9.999999999</format>
<initial>                 0.000000000</initial>
<label>Owning Obj</label>
<column-label>Owning Obj</column-label>
</field>
<field><name>default_value</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Default Value</label>
<column-label>Default Value</column-label>
</field>
</table_definition>
</dataset_header>
<dataset_records><dataset_transaction TransactionNo="1"><contained_record DB="ICFDB" Table="gsc_global_default"><global_default_obj>-1294967294.91</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>11/21/01</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>33762</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="2"><contained_record DB="ICFDB" Table="gsc_global_default"><global_default_obj>-1294967281.91</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>11/24/01</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>29303</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="3"><contained_record DB="ICFDB" Table="gsc_global_default"><global_default_obj>1.19</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>11/19/01</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>39732</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="4"><contained_record DB="ICFDB" Table="gsc_global_default"><global_default_obj>24.98</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>11/14/01</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>44880</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="5"><contained_record DB="ICFDB" Table="gsc_global_default"><global_default_obj>179</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>10/10/01</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>40619</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="6"><contained_record DB="ICFDB" Table="gsc_global_default"><global_default_obj>5968</global_default_obj>
<owning_entity_mnemonic></owning_entity_mnemonic>
<default_type>PRD</default_type>
<effective_date>01/01/90</effective_date>
<owning_obj>0</owning_obj>
<default_value>Default Product</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="7"><contained_record DB="ICFDB" Table="gsc_global_default"><global_default_obj>5970</global_default_obj>
<owning_entity_mnemonic>GSCPR</owning_entity_mnemonic>
<default_type>PRD</default_type>
<effective_date>01/01/90</effective_date>
<owning_obj>1035</owning_obj>
<default_value>Default Product</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="8"><contained_record DB="ICFDB" Table="gsc_global_default"><global_default_obj>8979</global_default_obj>
<owning_entity_mnemonic>GSCPR</owning_entity_mnemonic>
<default_type>PRD</default_type>
<effective_date>07/03/99</effective_date>
<owning_obj>1035</owning_obj>
<default_value>Default Product</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="9"><contained_record DB="ICFDB" Table="gsc_global_default"><global_default_obj>20293</global_default_obj>
<owning_entity_mnemonic>GSCTT</owning_entity_mnemonic>
<default_type>PRM</default_type>
<effective_date>01/01/90</effective_date>
<owning_obj>531</owning_obj>
<default_value>GL</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="10"><contained_record DB="ICFDB" Table="gsc_global_default"><global_default_obj>30886</global_default_obj>
<owning_entity_mnemonic>GSCTT</owning_entity_mnemonic>
<default_type>PRM</default_type>
<effective_date>01/01/90</effective_date>
<owning_obj>529</owning_obj>
<default_value>AR</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="11"><contained_record DB="ICFDB" Table="gsc_global_default"><global_default_obj>30927</global_default_obj>
<owning_entity_mnemonic>GSCTT</owning_entity_mnemonic>
<default_type>PRM</default_type>
<effective_date>01/01/90</effective_date>
<owning_obj>539</owning_obj>
<default_value>AR</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="12"><contained_record DB="ICFDB" Table="gsc_global_default"><global_default_obj>30968</global_default_obj>
<owning_entity_mnemonic>GSCTT</owning_entity_mnemonic>
<default_type>PRM</default_type>
<effective_date>01/01/90</effective_date>
<owning_obj>532</owning_obj>
<default_value>AP</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="13"><contained_record DB="ICFDB" Table="gsc_global_default"><global_default_obj>100872</global_default_obj>
<owning_entity_mnemonic>GSCTT</owning_entity_mnemonic>
<default_type>PRM</default_type>
<effective_date>01/01/90</effective_date>
<owning_obj>530</owning_obj>
<default_value>AP</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="14"><contained_record DB="ICFDB" Table="gsc_global_default"><global_default_obj>110546</global_default_obj>
<owning_entity_mnemonic>GSCTT</owning_entity_mnemonic>
<default_type>APR</default_type>
<effective_date>08/19/99</effective_date>
<owning_obj>532</owning_obj>
<default_value>6413,0,528,8964,21905,75</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="15"><contained_record DB="ICFDB" Table="gsc_global_default"><global_default_obj>174257</global_default_obj>
<owning_entity_mnemonic>GSCTT</owning_entity_mnemonic>
<default_type>PRM</default_type>
<effective_date>01/01/90</effective_date>
<owning_obj>174048</owning_obj>
<default_value>AP</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="16"><contained_record DB="ICFDB" Table="gsc_global_default"><global_default_obj>174776</global_default_obj>
<owning_entity_mnemonic>GSCTT</owning_entity_mnemonic>
<default_type>PRM</default_type>
<effective_date>01/01/90</effective_date>
<owning_obj>174057</owning_obj>
<default_value>AR</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="17"><contained_record DB="ICFDB" Table="gsc_global_default"><global_default_obj>238406</global_default_obj>
<owning_entity_mnemonic>GSCTT</owning_entity_mnemonic>
<default_type>PST</default_type>
<effective_date>10/06/99</effective_date>
<owning_obj>531</owning_obj>
<default_value>ONLINE</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="18"><contained_record DB="ICFDB" Table="gsc_global_default"><global_default_obj>238482</global_default_obj>
<owning_entity_mnemonic>GSCTT</owning_entity_mnemonic>
<default_type>PST</default_type>
<effective_date>10/11/99</effective_date>
<owning_obj>524</owning_obj>
<default_value>ONLINE</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="19"><contained_record DB="ICFDB" Table="gsc_global_default"><global_default_obj>238526</global_default_obj>
<owning_entity_mnemonic>GSCTT</owning_entity_mnemonic>
<default_type>PST</default_type>
<effective_date>10/11/99</effective_date>
<owning_obj>525</owning_obj>
<default_value>ONLINE</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="20"><contained_record DB="ICFDB" Table="gsc_global_default"><global_default_obj>238936</global_default_obj>
<owning_entity_mnemonic>GSCTT</owning_entity_mnemonic>
<default_type>PRM</default_type>
<effective_date>01/01/90</effective_date>
<owning_obj>528</owning_obj>
<default_value>AP</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="21"><contained_record DB="ICFDB" Table="gsc_global_default"><global_default_obj>238937</global_default_obj>
<owning_entity_mnemonic>GSCTT</owning_entity_mnemonic>
<default_type>PRM</default_type>
<effective_date>01/01/90</effective_date>
<owning_obj>524</owning_obj>
<default_value>AP</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="22"><contained_record DB="ICFDB" Table="gsc_global_default"><global_default_obj>251911</global_default_obj>
<owning_entity_mnemonic>GSCTT</owning_entity_mnemonic>
<default_type>TTC</default_type>
<effective_date>11/23/99</effective_date>
<owning_obj>542</owning_obj>
<default_value>1033</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="23"><contained_record DB="ICFDB" Table="gsc_global_default"><global_default_obj>251916</global_default_obj>
<owning_entity_mnemonic>GSCTT</owning_entity_mnemonic>
<default_type>TTC</default_type>
<effective_date>11/23/99</effective_date>
<owning_obj>541</owning_obj>
<default_value>1033</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="24"><contained_record DB="ICFDB" Table="gsc_global_default"><global_default_obj>2121740</global_default_obj>
<owning_entity_mnemonic>GSMRF</owning_entity_mnemonic>
<default_type>PGS</default_type>
<effective_date>12/09/99</effective_date>
<owning_obj>289925</owning_obj>
<default_value>80</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="25"><contained_record DB="ICFDB" Table="gsc_global_default"><global_default_obj>2135920</global_default_obj>
<owning_entity_mnemonic>GSMRF</owning_entity_mnemonic>
<default_type>PGS</default_type>
<effective_date>12/12/99</effective_date>
<owning_obj>289925</owning_obj>
<default_value>80</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="26"><contained_record DB="ICFDB" Table="gsc_global_default"><global_default_obj>2135929</global_default_obj>
<owning_entity_mnemonic>GSMRF</owning_entity_mnemonic>
<default_type>PGS</default_type>
<effective_date>12/13/99</effective_date>
<owning_obj>289925</owning_obj>
<default_value>80</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="27"><contained_record DB="ICFDB" Table="gsc_global_default"><global_default_obj>2265200</global_default_obj>
<owning_entity_mnemonic>GSCTT</owning_entity_mnemonic>
<default_type>PRM</default_type>
<effective_date>01/01/1900</effective_date>
<owning_obj>2265195</owning_obj>
<default_value>AR</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="28"><contained_record DB="ICFDB" Table="gsc_global_default"><global_default_obj>1000000001.39</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>01/21/02</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>32774</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="29"><contained_record DB="ICFDB" Table="gsc_global_default"><global_default_obj>1000000002.39</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>01/23/02</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>57446</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="30"><contained_record DB="ICFDB" Table="gsc_global_default"><global_default_obj>1003020477</global_default_obj>
<owning_entity_mnemonic>GSCTT</owning_entity_mnemonic>
<default_type>PRM</default_type>
<effective_date>04/17/00</effective_date>
<owning_obj>1003017723</owning_obj>
<default_value>AP</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="31"><contained_record DB="ICFDB" Table="gsc_global_default"><global_default_obj>1003020847</global_default_obj>
<owning_entity_mnemonic>GSCTT</owning_entity_mnemonic>
<default_type>PRM</default_type>
<effective_date>04/17/00</effective_date>
<owning_obj>1003019282</owning_obj>
<default_value>AP</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="32"><contained_record DB="ICFDB" Table="gsc_global_default"><global_default_obj>1003020848</global_default_obj>
<owning_entity_mnemonic>GSCTT</owning_entity_mnemonic>
<default_type>PRM</default_type>
<effective_date>04/17/00</effective_date>
<owning_obj>1003019283</owning_obj>
<default_value>AP</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="33"><contained_record DB="ICFDB" Table="gsc_global_default"><global_default_obj>1003951398</global_default_obj>
<owning_entity_mnemonic>GSCTT</owning_entity_mnemonic>
<default_type>PRM</default_type>
<effective_date>12/31/00</effective_date>
<owning_obj>0</owning_obj>
<default_value>Monday test</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="34"><contained_record DB="ICFDB" Table="gsc_global_default"><global_default_obj>1003951494</global_default_obj>
<owning_entity_mnemonic>GSCTT</owning_entity_mnemonic>
<default_type>PST</default_type>
<effective_date>01/01/00</effective_date>
<owning_obj>0</owning_obj>
<default_value>test 2 - watch owning_obj</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="35"><contained_record DB="ICFDB" Table="gsc_global_default"><global_default_obj>1004627722</global_default_obj>
<owning_entity_mnemonic>GSCPR</owning_entity_mnemonic>
<default_type>PRD</default_type>
<effective_date>12/11/00</effective_date>
<owning_obj>2114702</owning_obj>
<default_value>Default Product</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="36"><contained_record DB="ICFDB" Table="gsc_global_default"><global_default_obj>1004804799.2</global_default_obj>
<owning_entity_mnemonic></owning_entity_mnemonic>
<default_type>RPD</default_type>
<effective_date>01/02/00</effective_date>
<owning_obj>0</owning_obj>
<default_value>C:/Astra/work/dlc90b</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="37"><contained_record DB="ICFDB" Table="gsc_global_default"><global_default_obj>1007600464.08</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>10/08/01</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>16440</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="38"><contained_record DB="ICFDB" Table="gsc_global_default"><global_default_obj>1008000218.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>10/17/01</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>64862</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="39"><contained_record DB="ICFDB" Table="gsc_global_default"><global_default_obj>3000001564.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>11/28/01</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>53270</default_value>
</contained_record>
</dataset_transaction>
</dataset_records>
</dataset>