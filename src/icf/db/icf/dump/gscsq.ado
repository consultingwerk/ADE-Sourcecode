<?xml version="1.0" encoding="ISO8859-1" ?>
<dataset Transactions="4" version_date="02/23/2002" version_time="43010" version_user="admin" entity_mnemonic="GSTDF" key_field_value="3000000407.09" record_version_obj="3000000408.09" version_number_seq="2.09" import_version_number_seq="1.09"><dataset_header DisableRI="yes" DatasetObj="1007600105.08" DateFormat="mdy" FullHeader="yes" SCMManaged="no" YearOffset="1950" DatasetCode="GSCSQ" DateCreated="02/23/2002" TimeCreated="11:56:50" NumericFormat="AMERICAN" NumericDecimal="." OriginatingSite="93" NumericSeparator=","><deploy_dataset_obj>1007600105.08</deploy_dataset_obj>
<owner_site_code></owner_site_code>
<dataset_code>GSCSQ</dataset_code>
<dataset_description>gsc_sequence - Sequences</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<dataset_entity><dataset_entity_obj>1007600106.08</dataset_entity_obj>
<deploy_dataset_obj>1007600105.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSCSQ</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>sequence_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<entity_mnemonic_description>gsc_sequence</entity_mnemonic_description>
<entity_dbname>icfdb</entity_dbname>
</dataset_entity>
<dataset_entity><dataset_entity_obj>1007600107.08</dataset_entity_obj>
<deploy_dataset_obj>1007600105.08</deploy_dataset_obj>
<entity_sequence>2</entity_sequence>
<entity_mnemonic>GSCSN</entity_mnemonic>
<primary_entity>no</primary_entity>
<join_entity_mnemonic>GSCSQ</join_entity_mnemonic>
<join_field_list>sequence_obj,sequence_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<entity_mnemonic_description>gsc_next_sequence</entity_mnemonic_description>
<entity_dbname>icfdb</entity_dbname>
</dataset_entity>
<table_definition><name>gsc_sequence</name>
<dbname>ICFDB</dbname>
<index-1>XAK1gsc_sequence,1,0,0,company_organisation_obj,0,owning_entity_mnemonic,0,sequence_tla,0</index-1>
<index-2>XIE1gsc_sequence,0,0,0,sequence_description,0</index-2>
<index-3>XIE2gsc_sequence,0,0,0,sequence_short_desc,0</index-3>
<index-4>XPKgsc_sequence,1,1,0,sequence_obj,0</index-4>
<field><name>sequence_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>>>>>>>>>>>>>>>>>>9.999999999</format>
<initial>                 0.000000000</initial>
<label>Sequence Obj</label>
<column-label>Seq. Obj</column-label>
</field>
<field><name>company_organisation_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>>>>>>>>>>>>>>>>>>9.999999999</format>
<initial>                 0.000000000</initial>
<label>Company Organisation Obj</label>
<column-label>Company Organisation Obj</column-label>
</field>
<field><name>owning_entity_mnemonic</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(8)</format>
<initial></initial>
<label>Owning Entity Mnemonic</label>
<column-label>Owning Entity Mnemonic</column-label>
</field>
<field><name>sequence_tla</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(3)</format>
<initial></initial>
<label>Sequence TLA</label>
<column-label>Seq. TLA</column-label>
</field>
<field><name>sequence_short_desc</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(15)</format>
<initial></initial>
<label>Sequence Short Description</label>
<column-label>Seq. Short Desc</column-label>
</field>
<field><name>sequence_description</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>Sequence Description</label>
<column-label>Seq. Description</column-label>
</field>
<field><name>min_value</name>
<data-type>integer</data-type>
<extent>0</extent>
<format>->>>>>>>9</format>
<initial>        0</initial>
<label>Min. Value</label>
<column-label>Min. Value</column-label>
</field>
<field><name>max_value</name>
<data-type>integer</data-type>
<extent>0</extent>
<format>->>>>>>>9</format>
<initial>        0</initial>
<label>Max. Value</label>
<column-label>Max. Value</column-label>
</field>
<field><name>sequence_format</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>Sequence Format</label>
<column-label>Seq. Format</column-label>
</field>
<field><name>auto_generate</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>YES</initial>
<label>Auto Generate</label>
<column-label>Auto Generate</column-label>
</field>
<field><name>multi_transaction</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>Multi Transaction</label>
<column-label>Multi Transaction</column-label>
</field>
<field><name>next_value</name>
<data-type>integer</data-type>
<extent>0</extent>
<format>->>>>>>>9</format>
<initial>        0</initial>
<label>Next Value</label>
<column-label>Next Value</column-label>
</field>
<field><name>number_of_sequences</name>
<data-type>integer</data-type>
<extent>0</extent>
<format>->>>>>9</format>
<initial>      0</initial>
<label>Number of Sequences</label>
<column-label>Number of Seq.s</column-label>
</field>
<field><name>sequence_active</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>YES</initial>
<label>Sequence Active</label>
<column-label>Seq. Active</column-label>
</field>
</table_definition>
<table_definition><name>gsc_next_sequence</name>
<dbname>ICFDB</dbname>
<index-1>XPKgsc_next_sequence,1,1,0,sequence_obj,0,next_sequence_value,0</index-1>
<field><name>sequence_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>>>>>>>>>>>>>>>>>>9.999999999</format>
<initial>                 0.000000000</initial>
<label>Sequence Obj</label>
<column-label>Seq. Obj</column-label>
</field>
<field><name>next_sequence_value</name>
<data-type>integer</data-type>
<extent>0</extent>
<format>->>>>>>>9</format>
<initial>        0</initial>
<label>Next Sequence Value</label>
<column-label>Next Seq. Value</column-label>
</field>
<field><name>next_sequence_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>>>>>>>>>>>>>>>>>>9.999999999</format>
<initial>                 0.000000000</initial>
<label>Next Sequence Obj</label>
<column-label>Next Seq. Obj</column-label>
</field>
</table_definition>
</dataset_header>
<dataset_records><dataset_transaction TransactionNo="1"><contained_record DB="ICFDB" Table="gsc_sequence"><sequence_obj>2259873</sequence_obj>
<company_organisation_obj>0</company_organisation_obj>
<owning_entity_mnemonic>GSMMI</owning_entity_mnemonic>
<sequence_tla>MNU</sequence_tla>
<sequence_short_desc>Menu Item Ref.</sequence_short_desc>
<sequence_description>Menu Item Reference</sequence_description>
<min_value>1</min_value>
<max_value>99999999</max_value>
<sequence_format>ICF_&amp;9</sequence_format>
<auto_generate>yes</auto_generate>
<multi_transaction>no</multi_transaction>
<next_value>204</next_value>
<number_of_sequences>0</number_of_sequences>
<sequence_active>yes</sequence_active>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="2"><contained_record DB="ICFDB" Table="gsc_sequence"><sequence_obj>2262945</sequence_obj>
<company_organisation_obj>0</company_organisation_obj>
<owning_entity_mnemonic>GSMRD</owning_entity_mnemonic>
<sequence_tla>RDF</sequence_tla>
<sequence_short_desc>Report Def.</sequence_short_desc>
<sequence_description>Report Defenition</sequence_description>
<min_value>1</min_value>
<max_value>99999999</max_value>
<sequence_format>ASRDF_&amp;9</sequence_format>
<auto_generate>yes</auto_generate>
<multi_transaction>no</multi_transaction>
<next_value>156</next_value>
<number_of_sequences>0</number_of_sequences>
<sequence_active>yes</sequence_active>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="3"><contained_record DB="ICFDB" Table="gsc_sequence"><sequence_obj>2262946</sequence_obj>
<company_organisation_obj>0</company_organisation_obj>
<owning_entity_mnemonic>GSMRF</owning_entity_mnemonic>
<sequence_tla>RFM</sequence_tla>
<sequence_short_desc>Report Format</sequence_short_desc>
<sequence_description>Report Format</sequence_description>
<min_value>1</min_value>
<max_value>99999999</max_value>
<sequence_format>ASRFM_&amp;9</sequence_format>
<auto_generate>yes</auto_generate>
<multi_transaction>no</multi_transaction>
<next_value>218</next_value>
<number_of_sequences>0</number_of_sequences>
<sequence_active>yes</sequence_active>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="4"><contained_record DB="ICFDB" Table="gsc_sequence"><sequence_obj>1003604197</sequence_obj>
<company_organisation_obj>0</company_organisation_obj>
<owning_entity_mnemonic>GSMRD</owning_entity_mnemonic>
<sequence_tla>SPL</sequence_tla>
<sequence_short_desc>Spl File Name</sequence_short_desc>
<sequence_description>Spooler File Name</sequence_description>
<min_value>1</min_value>
<max_value>99999999</max_value>
<sequence_format>&amp;9</sequence_format>
<auto_generate>yes</auto_generate>
<multi_transaction>no</multi_transaction>
<next_value>1</next_value>
<number_of_sequences>0</number_of_sequences>
<sequence_active>yes</sequence_active>
</contained_record>
</dataset_transaction>
</dataset_records>
</dataset>