<?xml version="1.0" encoding="utf-8" ?>
<dataset Transactions="139"><dataset_header DisableRI="yes" DatasetObj="1007600108.08" DateFormat="mdy" FullHeader="yes" SCMManaged="no" YearOffset="1950" DatasetCode="GSCGD" NumericFormat="AMERICAN" NumericDecimal="." OriginatingSite="90" NumericSeparator=","><deploy_dataset_obj>1007600108.08</deploy_dataset_obj>
<dataset_code>GSCGD</dataset_code>
<dataset_description>gsc_global_defaults - Global deflt</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<deploy_additions_only>no</deploy_additions_only>
<enable_data_versioning>yes</enable_data_versioning>
<deletion_dataset>yes</deletion_dataset>
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
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
<entity_mnemonic_description>gsc_global_default</entity_mnemonic_description>
<entity_dbname>ICFDB</entity_dbname>
</dataset_entity>
<table_definition><name>gsc_global_default</name>
<dbname>icfdb</dbname>
<index-1>XAK1gsc_global_default,1,0,0,owning_entity_mnemonic,0,owning_obj,0,default_type,0,effective_date,0</index-1>
<index-2>XPKgsc_global_default,1,1,0,global_default_obj,0</index-2>
<field><name>global_default_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
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
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
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
<dataset_records><dataset_transaction TransactionNo="1" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>-1294967294.91</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>11/21/01</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>33762</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="2" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>-1294967281.91</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>11/24/01</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>29303</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="3" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>1.19</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>11/19/01</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>39732</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="4" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>24.98</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>11/14/01</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>44880</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="5" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>179</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>10/10/01</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>40619</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="6" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>5968</global_default_obj>
<owning_entity_mnemonic></owning_entity_mnemonic>
<default_type>PRD</default_type>
<effective_date>01/01/90</effective_date>
<owning_obj>0</owning_obj>
<default_value>Default Product</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="7" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>5970</global_default_obj>
<owning_entity_mnemonic>GSCPR</owning_entity_mnemonic>
<default_type>PRD</default_type>
<effective_date>01/01/90</effective_date>
<owning_obj>1035</owning_obj>
<default_value>Default Product</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="8" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>8979</global_default_obj>
<owning_entity_mnemonic>GSCPR</owning_entity_mnemonic>
<default_type>PRD</default_type>
<effective_date>07/03/99</effective_date>
<owning_obj>1035</owning_obj>
<default_value>Default Product</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="9" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>20293</global_default_obj>
<owning_entity_mnemonic>GSCTT</owning_entity_mnemonic>
<default_type>PRM</default_type>
<effective_date>01/01/90</effective_date>
<owning_obj>531</owning_obj>
<default_value>GL</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="10" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>30886</global_default_obj>
<owning_entity_mnemonic>GSCTT</owning_entity_mnemonic>
<default_type>PRM</default_type>
<effective_date>01/01/90</effective_date>
<owning_obj>529</owning_obj>
<default_value>AR</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="11" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>30927</global_default_obj>
<owning_entity_mnemonic>GSCTT</owning_entity_mnemonic>
<default_type>PRM</default_type>
<effective_date>01/01/90</effective_date>
<owning_obj>539</owning_obj>
<default_value>AR</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="12" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>30968</global_default_obj>
<owning_entity_mnemonic>GSCTT</owning_entity_mnemonic>
<default_type>PRM</default_type>
<effective_date>01/01/90</effective_date>
<owning_obj>532</owning_obj>
<default_value>AP</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="13" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>100872</global_default_obj>
<owning_entity_mnemonic>GSCTT</owning_entity_mnemonic>
<default_type>PRM</default_type>
<effective_date>01/01/90</effective_date>
<owning_obj>530</owning_obj>
<default_value>AP</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="14" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>110546</global_default_obj>
<owning_entity_mnemonic>GSCTT</owning_entity_mnemonic>
<default_type>APR</default_type>
<effective_date>08/19/99</effective_date>
<owning_obj>532</owning_obj>
<default_value>6413,0,528,8964,21905,75</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="15" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>174257</global_default_obj>
<owning_entity_mnemonic>GSCTT</owning_entity_mnemonic>
<default_type>PRM</default_type>
<effective_date>01/01/90</effective_date>
<owning_obj>174048</owning_obj>
<default_value>AP</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="16" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>174776</global_default_obj>
<owning_entity_mnemonic>GSCTT</owning_entity_mnemonic>
<default_type>PRM</default_type>
<effective_date>01/01/90</effective_date>
<owning_obj>174057</owning_obj>
<default_value>AR</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="17" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>238406</global_default_obj>
<owning_entity_mnemonic>GSCTT</owning_entity_mnemonic>
<default_type>PST</default_type>
<effective_date>10/06/99</effective_date>
<owning_obj>531</owning_obj>
<default_value>ONLINE</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="18" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>238482</global_default_obj>
<owning_entity_mnemonic>GSCTT</owning_entity_mnemonic>
<default_type>PST</default_type>
<effective_date>10/11/99</effective_date>
<owning_obj>524</owning_obj>
<default_value>ONLINE</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="19" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>238526</global_default_obj>
<owning_entity_mnemonic>GSCTT</owning_entity_mnemonic>
<default_type>PST</default_type>
<effective_date>10/11/99</effective_date>
<owning_obj>525</owning_obj>
<default_value>ONLINE</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="20" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>238936</global_default_obj>
<owning_entity_mnemonic>GSCTT</owning_entity_mnemonic>
<default_type>PRM</default_type>
<effective_date>01/01/90</effective_date>
<owning_obj>528</owning_obj>
<default_value>AP</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="21" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>238937</global_default_obj>
<owning_entity_mnemonic>GSCTT</owning_entity_mnemonic>
<default_type>PRM</default_type>
<effective_date>01/01/90</effective_date>
<owning_obj>524</owning_obj>
<default_value>AP</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="22" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>251911</global_default_obj>
<owning_entity_mnemonic>GSCTT</owning_entity_mnemonic>
<default_type>TTC</default_type>
<effective_date>11/23/99</effective_date>
<owning_obj>542</owning_obj>
<default_value>1033</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="23" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>251916</global_default_obj>
<owning_entity_mnemonic>GSCTT</owning_entity_mnemonic>
<default_type>TTC</default_type>
<effective_date>11/23/99</effective_date>
<owning_obj>541</owning_obj>
<default_value>1033</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="24" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>2121740</global_default_obj>
<owning_entity_mnemonic>GSMRF</owning_entity_mnemonic>
<default_type>PGS</default_type>
<effective_date>12/09/99</effective_date>
<owning_obj>289925</owning_obj>
<default_value>80</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="25" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>2135920</global_default_obj>
<owning_entity_mnemonic>GSMRF</owning_entity_mnemonic>
<default_type>PGS</default_type>
<effective_date>12/12/99</effective_date>
<owning_obj>289925</owning_obj>
<default_value>80</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="26" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>2135929</global_default_obj>
<owning_entity_mnemonic>GSMRF</owning_entity_mnemonic>
<default_type>PGS</default_type>
<effective_date>12/13/99</effective_date>
<owning_obj>289925</owning_obj>
<default_value>80</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="27" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>2265200</global_default_obj>
<owning_entity_mnemonic>GSCTT</owning_entity_mnemonic>
<default_type>PRM</default_type>
<effective_date>01/01/1900</effective_date>
<owning_obj>2265195</owning_obj>
<default_value>AR</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="28" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>1003020477</global_default_obj>
<owning_entity_mnemonic>GSCTT</owning_entity_mnemonic>
<default_type>PRM</default_type>
<effective_date>04/17/00</effective_date>
<owning_obj>1003017723</owning_obj>
<default_value>AP</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="29" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>1003020847</global_default_obj>
<owning_entity_mnemonic>GSCTT</owning_entity_mnemonic>
<default_type>PRM</default_type>
<effective_date>04/17/00</effective_date>
<owning_obj>1003019282</owning_obj>
<default_value>AP</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="30" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>1003020848</global_default_obj>
<owning_entity_mnemonic>GSCTT</owning_entity_mnemonic>
<default_type>PRM</default_type>
<effective_date>04/17/00</effective_date>
<owning_obj>1003019283</owning_obj>
<default_value>AP</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="31" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>1003951398</global_default_obj>
<owning_entity_mnemonic>GSCTT</owning_entity_mnemonic>
<default_type>PRM</default_type>
<effective_date>12/31/00</effective_date>
<owning_obj>0</owning_obj>
<default_value>Monday test</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="32" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>1003951494</global_default_obj>
<owning_entity_mnemonic>GSCTT</owning_entity_mnemonic>
<default_type>PST</default_type>
<effective_date>01/01/00</effective_date>
<owning_obj>0</owning_obj>
<default_value>test 2 - watch owning_obj</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="33" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>1004627722</global_default_obj>
<owning_entity_mnemonic>GSCPR</owning_entity_mnemonic>
<default_type>PRD</default_type>
<effective_date>12/11/00</effective_date>
<owning_obj>2114702</owning_obj>
<default_value>Default Product</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="34" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>1004804799.2</global_default_obj>
<owning_entity_mnemonic></owning_entity_mnemonic>
<default_type>RPD</default_type>
<effective_date>01/02/00</effective_date>
<owning_obj>0</owning_obj>
<default_value>C:/Astra/work/dlc90b</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="35" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>1007600464.08</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>10/08/01</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>16440</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="36" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>1008000218.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>10/17/01</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>64862</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="37" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000000303.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>05/27/02</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>33632</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="38" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000000304.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>05/28/02</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>35080</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="39" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000000307.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>05/29/02</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>52672</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="40" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000000371.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>05/30/02</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>73656</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="41" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000000372.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>06/14/02</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>56270</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="42" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000000373.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>06/18/02</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>30174</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="43" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000001564.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>11/28/01</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>53270</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="44" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000001565.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>01/21/02</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>32774</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="45" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000001566.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>01/23/02</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>57162</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="46" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000001712.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>02/13/02</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>39164</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="47" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000001775.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>02/24/02</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>33515</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="48" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000001865.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>04/26/02</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>39890</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="49" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000002005.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>06/19/02</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>41966</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="50" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000002006.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>06/20/02</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>77251</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="51" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000004823.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>06/21/02</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>72458</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="52" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000004824.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>06/24/02</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>84400</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="53" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000004828.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>06/25/02</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>37860</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="54" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000004884.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>06/27/02</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>56518</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="55" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000004916.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>06/28/02</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>66360</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="56" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000004923.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>07/01/02</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>38598</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="57" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000004933.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>07/02/02</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>68370</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="58" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000005125.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>07/04/02</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>40578</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="59" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000005126.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>07/07/02</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>48682</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="60" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000005127.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>07/08/02</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>71322</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="61" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000005346.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>07/09/02</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>70492</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="62" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000005347.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>07/10/02</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>66696</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="63" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000005348.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>07/11/02</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>29284</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="64" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000005349.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>07/14/02</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>53000</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="65" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000005350.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>07/17/02</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>56262</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="66" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000005351.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>07/21/02</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>47732</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="67" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000005361.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>07/23/02</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>45326</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="68" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000005362.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>07/28/02</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>77940</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="69" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000005368.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>07/29/02</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>64176</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="70" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000005369.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>07/30/02</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>36090</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="71" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000005373.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>07/31/02</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>53586</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="72" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000005374.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>08/01/02</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>50463</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="73" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000005376.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>08/02/02</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>52676</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="74" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000005379.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>08/05/02</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>47693</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="75" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000005380.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>08/06/02</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>58550</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="76" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000005385.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>08/09/02</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>35954</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="77" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000005386.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>08/14/02</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>41934</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="78" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000005387.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>08/15/02</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>57082</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="79" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000005388.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>08/19/02</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>61034</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="80" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000005389.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>08/23/02</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>68284</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="81" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000005392.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>08/28/02</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>70140</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="82" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000005395.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>09/02/02</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>58372</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="83" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000005397.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>09/05/02</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>41896</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="84" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000005399.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>09/13/02</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>37368</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="85" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000005402.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>09/14/02</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>56696</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="86" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000005403.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>09/15/02</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>71756</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="87" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000005404.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>09/18/02</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>40240</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="88" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000005405.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>09/20/02</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>72601</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="89" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000005452.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>09/23/02</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>37118</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="90" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000031141.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>09/27/02</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>61246</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="91" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000033277.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>09/30/02</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>41240</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="92" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000038025.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>10/01/02</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>50968</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="93" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000040646.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>10/02/02</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>53234</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="94" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000040654.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>10/03/02</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>42684</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="95" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000040655.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>10/04/02</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>28600</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="96" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000040681.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>10/07/02</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>57738</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="97" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000040682.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>10/08/02</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>35700</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="98" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000040690.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>10/22/02</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>50804</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="99" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000040693.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>11/05/02</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>41738</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="100" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000040694.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>11/07/02</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>40848</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="101" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000040696.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>11/12/02</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>68292</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="102" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000040697.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>11/13/02</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>68740</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="103" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000040698.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>11/18/02</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>27544</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="104" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000040699.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>11/21/02</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>61104</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="105" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000040700.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>12/02/02</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>26443</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="106" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000040701.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>12/03/02</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>60540</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="107" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000040702.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>12/05/02</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>43136</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="108" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000040706.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>12/06/02</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>60226</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="109" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000040745.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>01/09/03</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>50409</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="110" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000040749.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>01/29/03</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>29460</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="111" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000040758.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>02/03/03</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>27504</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="112" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000040759.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>02/04/03</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>55356</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="113" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000040761.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>02/05/03</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>51102</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="114" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000040762.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>02/07/03</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>51140</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="115" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000040763.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>02/10/03</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>43582</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="116" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000040764.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>02/11/03</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>55750</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="117" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000040765.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>02/13/03</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>64032</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="118" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000040766.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>02/18/03</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>45226</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="119" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000040767.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>02/21/03</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>40846</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="120" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000040768.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>02/25/03</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>35152</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="121" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000040769.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>02/26/03</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>63206</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="122" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000040770.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>02/27/03</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>51352</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="123" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000040771.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>03/05/03</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>60406</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="124" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000040772.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>03/06/03</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>56022</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="125" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000040776.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>03/07/03</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>62102</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="126" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000040777.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>03/11/03</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>36790</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="127" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000040780.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>03/12/03</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>61642</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="128" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000040783.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>03/14/03</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>56418</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="129" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000040784.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>03/16/03</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>66698</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="130" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000040785.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>03/17/03</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>63060</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="131" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000040786.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>03/18/03</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>52616</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="132" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000044719.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>03/19/03</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>55124</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="133" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000044729.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>03/20/03</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>42990</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="134" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000044733.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>03/21/03</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>60168</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="135" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000044747.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>03/24/03</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>81098</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="136" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000045121.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>03/25/03</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>73854</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="137" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000045134.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>03/27/03</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>57306</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="138" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000045142.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>03/31/03</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>45954</default_value>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="139" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_global_default"><global_default_obj>3000045144.09</global_default_obj>
<owning_entity_mnemonic>GSCGC</owning_entity_mnemonic>
<default_type>DDU</default_type>
<effective_date>04/02/03</effective_date>
<owning_obj>1003545208</owning_obj>
<default_value>40818</default_value>
</contained_record>
</dataset_transaction>
</dataset_records>
</dataset>