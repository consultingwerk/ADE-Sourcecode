<?xml version="1.0" encoding="utf-8" ?>
<dataset Transactions="87"><dataset_header DisableRI="yes" DatasetObj="1007600155.08" DateFormat="mdy" FullHeader="yes" SCMManaged="no" YearOffset="1950" DatasetCode="GSMMS" NumericFormat="AMERICAN" NumericDecimal="." OriginatingSite="90" NumericSeparator=","><deploy_dataset_obj>1007600155.08</deploy_dataset_obj>
<dataset_code>GSMMS</dataset_code>
<dataset_description>gsm_menu_structure - Menu Structure</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<deploy_additions_only>no</deploy_additions_only>
<enable_data_versioning>yes</enable_data_versioning>
<deletion_dataset>yes</deletion_dataset>
<dataset_entity><dataset_entity_obj>1007600156.08</dataset_entity_obj>
<deploy_dataset_obj>1007600155.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSMMS</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>menu_structure_code</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
<entity_mnemonic_description>gsm_menu_structure</entity_mnemonic_description>
<entity_dbname>ICFDB</entity_dbname>
</dataset_entity>
<dataset_entity><dataset_entity_obj>1007600159.08</dataset_entity_obj>
<deploy_dataset_obj>1007600155.08</deploy_dataset_obj>
<entity_sequence>2</entity_sequence>
<entity_mnemonic>GSMIT</entity_mnemonic>
<primary_entity>no</primary_entity>
<join_entity_mnemonic>GSMMS</join_entity_mnemonic>
<join_field_list>menu_structure_obj,menu_structure_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
<entity_mnemonic_description>gsm_menu_structure_item</entity_mnemonic_description>
<entity_dbname>ICFDB</entity_dbname>
</dataset_entity>
<table_definition><name>gsm_menu_structure</name>
<dbname>icfdb</dbname>
<index-1>XAK1gsm_menu_structure,1,0,0,menu_structure_code,0</index-1>
<index-2>XAK2gsm_menu_structure,1,0,0,product_module_obj,0,menu_structure_code,0</index-2>
<index-3>XIE2gsm_menu_structure,0,0,0,menu_structure_description,0</index-3>
<index-4>XIE3gsm_menu_structure,0,0,0,menu_structure_type,0</index-4>
<index-5>XIE4gsm_menu_structure,0,0,0,menu_item_obj,0</index-5>
<index-6>XPKgsm_menu_structure,1,1,0,menu_structure_obj,0</index-6>
<field><name>menu_structure_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Menu Structure Obj</label>
<column-label>Menu Structure Obj</column-label>
</field>
<field><name>product_module_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Product Module Obj</label>
<column-label>Product Module Obj</column-label>
</field>
<field><name>product_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Product Obj</label>
<column-label>Product Obj</column-label>
</field>
<field><name>menu_structure_code</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(28)</format>
<initial></initial>
<label>Menu Structure Code</label>
<column-label>Menu Structure Code</column-label>
</field>
<field><name>menu_structure_description</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>Menu Structure Description</label>
<column-label>Menu Structure Description</column-label>
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
<label>System Owned</label>
<column-label>System Owned</column-label>
</field>
<field><name>under_development</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>Under Development</label>
<column-label>Under Development</column-label>
</field>
<field><name>menu_item_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Menu Item Obj</label>
<column-label>Menu Item Obj</column-label>
</field>
<field><name>menu_structure_type</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(15)</format>
<initial></initial>
<label>Menu Structure Type</label>
<column-label>Menu Structure Type</column-label>
</field>
<field><name>menu_structure_hidden</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>Menu Structure Hidden</label>
<column-label>Menu Structure Hidden</column-label>
</field>
<field><name>control_spacing</name>
<data-type>integer</data-type>
<extent>0</extent>
<format>-&gt;&gt;9</format>
<initial>   0</initial>
<label>Control Spacing</label>
<column-label>Control Spacing</column-label>
</field>
<field><name>control_padding</name>
<data-type>integer</data-type>
<extent>0</extent>
<format>-&gt;&gt;9</format>
<initial>   0</initial>
<label>Control Padding</label>
<column-label>Control Padding</column-label>
</field>
<field><name>menu_structure_narrative</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(500)</format>
<initial></initial>
<label>Menu Structure Narrative</label>
<column-label>Menu Structure Narrative</column-label>
</field>
</table_definition>
<table_definition><name>gsm_menu_structure_item</name>
<dbname>icfdb</dbname>
<index-1>XAK1gsm_menu_structure_item,1,0,0,menu_structure_item_obj,0</index-1>
<index-2>XIE1gsm_menu_structure_item,0,0,0,child_menu_structure_obj,0</index-2>
<index-3>XIE2gsm_menu_structure_item,0,0,0,menu_item_obj,0</index-3>
<index-4>XPKgsm_menu_structure_item,1,1,0,menu_structure_obj,0,menu_item_sequence,0</index-4>
<field><name>menu_structure_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Menu Structure Obj</label>
<column-label>Menu Structure Obj</column-label>
</field>
<field><name>menu_item_sequence</name>
<data-type>integer</data-type>
<extent>0</extent>
<format>-&gt;&gt;9</format>
<initial>   0</initial>
<label>Menu Item Sequence</label>
<column-label>Menu Item Seq.</column-label>
</field>
<field><name>menu_item_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Menu Item Obj</label>
<column-label>Menu Item Obj</column-label>
</field>
<field><name>child_menu_structure_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Child Menu Structure Obj</label>
<column-label>Child Menu Structure Obj</column-label>
</field>
<field><name>menu_structure_item_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Menu Structure Item Obj</label>
<column-label>Menu Structure Item Obj</column-label>
</field>
</table_definition>
</dataset_header>
<dataset_records><dataset_transaction TransactionNo="1" TransactionType="DELETION"><contained_record version_date="09/23/2002" version_time="56980" version_user="admin" deletion_flag="yes" entity_mnemonic="gsmms" key_field_value="1000708021.09" record_version_obj="3000031049.09" version_number_seq="92.09" secondary_key_value="ProTools" import_version_number_seq="92.09"/>
</dataset_transaction>
<dataset_transaction TransactionNo="2" TransactionType="DELETION"><contained_record version_date="09/23/2002" version_time="58361" version_user="admin" deletion_flag="yes" entity_mnemonic="gsmms" key_field_value="1003606201" record_version_obj="3000031081.09" version_number_seq="1.09" secondary_key_value="A2MencWiz" import_version_number_seq="1.09"/>
</dataset_transaction>
<dataset_transaction TransactionNo="3" TransactionType="DELETION"><contained_record version_date="09/23/2002" version_time="58370" version_user="admin" deletion_flag="yes" entity_mnemonic="gsmms" key_field_value="1003606410" record_version_obj="3000031082.09" version_number_seq="1.09" secondary_key_value="A2ObjcWiz" import_version_number_seq="1.09"/>
</dataset_transaction>
<dataset_transaction TransactionNo="4" TransactionType="DELETION"><contained_record version_date="09/23/2002" version_time="58352" version_user="admin" deletion_flag="yes" entity_mnemonic="gsmms" key_field_value="1003606413" record_version_obj="3000031080.09" version_number_seq="2.09" secondary_key_value="A2FoldWiz" import_version_number_seq="2.09"/>
</dataset_transaction>
<dataset_transaction TransactionNo="5" TransactionType="DELETION"><contained_record version_date="09/23/2002" version_time="58385" version_user="admin" deletion_flag="yes" entity_mnemonic="gsmms" key_field_value="1003606416" record_version_obj="3000031083.09" version_number_seq="1.09" secondary_key_value="A2BrowWiz" import_version_number_seq="1.09"/>
</dataset_transaction>
<dataset_transaction TransactionNo="6" TransactionType="DELETION"><contained_record version_date="09/23/2002" version_time="58400" version_user="admin" deletion_flag="yes" entity_mnemonic="gsmms" key_field_value="1003606419" record_version_obj="3000031084.09" version_number_seq="1.09" secondary_key_value="A2ViewWiz" import_version_number_seq="1.09"/>
</dataset_transaction>
<dataset_transaction TransactionNo="7" TransactionType="DELETION"><contained_record version_date="02/03/2003" version_time="56922" version_user="admin" deletion_flag="yes" entity_mnemonic="gsmms" key_field_value="1003606422" record_version_obj="3000031132.09" version_number_seq="2.09" secondary_key_value="A2Wizards" import_version_number_seq="2.09"/>
</dataset_transaction>
<dataset_transaction TransactionNo="8" TransactionType="DELETION"><contained_record version_date="09/23/2002" version_time="59582" version_user="admin" deletion_flag="yes" entity_mnemonic="gsmms" key_field_value="1003694840" record_version_obj="3000000053.09" version_number_seq="11.09" secondary_key_value="A2SmrtObjc" import_version_number_seq="11.09"/>
</dataset_transaction>
<dataset_transaction TransactionNo="9" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_structure"><menu_structure_obj>14.66</menu_structure_obj>
<product_module_obj>0</product_module_obj>
<product_obj>0</product_obj>
<menu_structure_code>FileTableIOMod</menu_structure_code>
<menu_structure_description>FileTableio Modify/View</menu_structure_description>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_obj>1000708213.09</menu_item_obj>
<menu_structure_type>Submenu</menu_structure_type>
<menu_structure_hidden>no</menu_structure_hidden>
<control_spacing>0</control_spacing>
<control_padding>0</control_padding>
<menu_structure_narrative></menu_structure_narrative>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>14.66</menu_structure_obj>
<menu_item_sequence>1</menu_item_sequence>
<menu_item_obj>1000708104.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>15.66</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>14.66</menu_structure_obj>
<menu_item_sequence>2</menu_item_sequence>
<menu_item_obj>1000708106.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>16.66</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>14.66</menu_structure_obj>
<menu_item_sequence>3</menu_item_sequence>
<menu_item_obj>1000708107.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>17.66</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>14.66</menu_structure_obj>
<menu_item_sequence>4</menu_item_sequence>
<menu_item_obj>1003700174</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>21.66</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>14.66</menu_structure_obj>
<menu_item_sequence>5</menu_item_sequence>
<menu_item_obj>1000708172.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>19.66</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>14.66</menu_structure_obj>
<menu_item_sequence>6</menu_item_sequence>
<menu_item_obj>1000708177.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>20.66</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>14.66</menu_structure_obj>
<menu_item_sequence>7</menu_item_sequence>
<menu_item_obj>1003700174</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>18.66</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>14.66</menu_structure_obj>
<menu_item_sequence>8</menu_item_sequence>
<menu_item_obj>1000708108.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>22.66</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>14.66</menu_structure_obj>
<menu_item_sequence>9</menu_item_sequence>
<menu_item_obj>1000708109.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>24.66</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>14.66</menu_structure_obj>
<menu_item_sequence>10</menu_item_sequence>
<menu_item_obj>1000708110.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>25.66</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>14.66</menu_structure_obj>
<menu_item_sequence>11</menu_item_sequence>
<menu_item_obj>1003700174</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>73.66</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>14.66</menu_structure_obj>
<menu_item_sequence>12</menu_item_sequence>
<menu_item_obj>1000708111.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>27.66</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>14.66</menu_structure_obj>
<menu_item_sequence>13</menu_item_sequence>
<menu_item_obj>1000708112.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>28.66</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>14.66</menu_structure_obj>
<menu_item_sequence>14</menu_item_sequence>
<menu_item_obj>1003700174</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>29.66</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>14.66</menu_structure_obj>
<menu_item_sequence>15</menu_item_sequence>
<menu_item_obj>1000708117.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>30.66</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>14.66</menu_structure_obj>
<menu_item_sequence>16</menu_item_sequence>
<menu_item_obj>1003700174</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>74.66</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>14.66</menu_structure_obj>
<menu_item_sequence>17</menu_item_sequence>
<menu_item_obj>1000708145.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>32.66</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>14.66</menu_structure_obj>
<menu_item_sequence>18</menu_item_sequence>
<menu_item_obj>71.6893</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>90.6893</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>14.66</menu_structure_obj>
<menu_item_sequence>19</menu_item_sequence>
<menu_item_obj>1000708165.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>33.66</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>14.66</menu_structure_obj>
<menu_item_sequence>20</menu_item_sequence>
<menu_item_obj>1003700174</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>31.66</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>14.66</menu_structure_obj>
<menu_item_sequence>21</menu_item_sequence>
<menu_item_obj>1000708103.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>34.66</menu_structure_item_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="10" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_structure"><menu_structure_obj>63.66</menu_structure_obj>
<product_module_obj>0</product_module_obj>
<product_obj>0</product_obj>
<menu_structure_code>StandardMenubar</menu_structure_code>
<menu_structure_description>StandardMenubar</menu_structure_description>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_obj>0</menu_item_obj>
<menu_structure_type>Menubar</menu_structure_type>
<menu_structure_hidden>no</menu_structure_hidden>
<control_spacing>0</control_spacing>
<control_padding>0</control_padding>
<menu_structure_narrative></menu_structure_narrative>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>63.66</menu_structure_obj>
<menu_item_sequence>1</menu_item_sequence>
<menu_item_obj>1000708213.09</menu_item_obj>
<child_menu_structure_obj>14.66</child_menu_structure_obj>
<menu_structure_item_obj>64.66</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>63.66</menu_structure_obj>
<menu_item_sequence>2</menu_item_sequence>
<menu_item_obj>1000709147.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>82.99</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>63.66</menu_structure_obj>
<menu_item_sequence>3</menu_item_sequence>
<menu_item_obj>1000708216.09</menu_item_obj>
<child_menu_structure_obj>1000708215.09</child_menu_structure_obj>
<menu_structure_item_obj>67.66</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>63.66</menu_structure_obj>
<menu_item_sequence>4</menu_item_sequence>
<menu_item_obj>1000708229.09</menu_item_obj>
<child_menu_structure_obj>1000708228.09</child_menu_structure_obj>
<menu_structure_item_obj>65.66</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>63.66</menu_structure_obj>
<menu_item_sequence>5</menu_item_sequence>
<menu_item_obj>1000708221.09</menu_item_obj>
<child_menu_structure_obj>1000708224.09</child_menu_structure_obj>
<menu_structure_item_obj>66.66</menu_structure_item_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="11" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_structure" version_date="01/29/2003" version_time="22715" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMS" key_field_value="487.5053" record_version_obj="488.5053" version_number_seq="14.09" secondary_key_value="ContainerBuilder" import_version_number_seq="14.09"><menu_structure_obj>487.5053</menu_structure_obj>
<product_module_obj>0</product_module_obj>
<product_obj>0</product_obj>
<menu_structure_code>ContainerBuilder</menu_structure_code>
<menu_structure_description>Container Builder Specific Items</menu_structure_description>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_obj>0</menu_item_obj>
<menu_structure_type>Menu&amp;Toolbar</menu_structure_type>
<menu_structure_hidden>no</menu_structure_hidden>
<control_spacing>0</control_spacing>
<control_padding>0</control_padding>
<menu_structure_narrative>This band will be used for container builder specific actions sucha as the container preview, properties, pages, links etc.</menu_structure_narrative>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>487.5053</menu_structure_obj>
<menu_item_sequence>1</menu_item_sequence>
<menu_item_obj>558.5053</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>562.5053</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>487.5053</menu_structure_obj>
<menu_item_sequence>2</menu_item_sequence>
<menu_item_obj>489.5053</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>550.5053</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>487.5053</menu_structure_obj>
<menu_item_sequence>3</menu_item_sequence>
<menu_item_obj>552.5053</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>554.5053</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>487.5053</menu_structure_obj>
<menu_item_sequence>4</menu_item_sequence>
<menu_item_obj>16605.53</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>16608.53</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>487.5053</menu_structure_obj>
<menu_item_sequence>5</menu_item_sequence>
<menu_item_obj>15878.53</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>15880.53</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>487.5053</menu_structure_obj>
<menu_item_sequence>6</menu_item_sequence>
<menu_item_obj>556.5053</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>560.5053</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>487.5053</menu_structure_obj>
<menu_item_sequence>7</menu_item_sequence>
<menu_item_obj>48549.9875</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>48551.9875</menu_structure_item_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="12" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_structure" version_date="09/23/2002" version_time="35442" version_user="admin" deletion_flag="no" entity_mnemonic="gsmms" key_field_value="702.5053" record_version_obj="703.5053" version_number_seq="1.09" secondary_key_value="ContainerBuilderIO" import_version_number_seq="1.09"><menu_structure_obj>702.5053</menu_structure_obj>
<product_module_obj>0</product_module_obj>
<product_obj>0</product_obj>
<menu_structure_code>ContainerBuilderIO</menu_structure_code>
<menu_structure_description>Container Builder IO Specific Items</menu_structure_description>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_obj>0</menu_item_obj>
<menu_structure_type>Menu&amp;Toolbar</menu_structure_type>
<menu_structure_hidden>no</menu_structure_hidden>
<control_spacing>0</control_spacing>
<control_padding>0</control_padding>
<menu_structure_narrative>This band will be used for container builder specific io actions such as add, copy, delete etc. that require no rules</menu_structure_narrative>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>702.5053</menu_structure_obj>
<menu_item_sequence>1</menu_item_sequence>
<menu_item_obj>15857.53</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>706.5053</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>702.5053</menu_structure_obj>
<menu_item_sequence>2</menu_item_sequence>
<menu_item_obj>15872.53</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>704.5053</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>702.5053</menu_structure_obj>
<menu_item_sequence>3</menu_item_sequence>
<menu_item_obj>15870.53</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>708.5053</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>702.5053</menu_structure_obj>
<menu_item_sequence>4</menu_item_sequence>
<menu_item_obj>17023.53</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>17025.53</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>702.5053</menu_structure_obj>
<menu_item_sequence>5</menu_item_sequence>
<menu_item_obj>13067.5053</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1178.5053</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>702.5053</menu_structure_obj>
<menu_item_sequence>6</menu_item_sequence>
<menu_item_obj>15859.53</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>716.5053</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>702.5053</menu_structure_obj>
<menu_item_sequence>7</menu_item_sequence>
<menu_item_obj>15861.53</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>780.5053</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>702.5053</menu_structure_obj>
<menu_item_sequence>8</menu_item_sequence>
<menu_item_obj>15855.53</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>718.5053</menu_structure_item_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="13" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_structure" version_date="11/15/2002" version_time="46263" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMS" key_field_value="8451.9875" record_version_obj="8452.9875" version_number_seq="1.09" secondary_key_value="ClassOptionBand" import_version_number_seq="1.09"><menu_structure_obj>8451.9875</menu_structure_obj>
<product_module_obj>0</product_module_obj>
<product_obj>0</product_obj>
<menu_structure_code>ClassOptionBand</menu_structure_code>
<menu_structure_description>Class Options</menu_structure_description>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_obj>8449.9875</menu_item_obj>
<menu_structure_type>Submenu</menu_structure_type>
<menu_structure_hidden>no</menu_structure_hidden>
<control_spacing>0</control_spacing>
<control_padding>0</control_padding>
<menu_structure_narrative></menu_structure_narrative>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>8451.9875</menu_structure_obj>
<menu_item_sequence>1</menu_item_sequence>
<menu_item_obj>8453.9875</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>8457.9875</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>8451.9875</menu_structure_obj>
<menu_item_sequence>2</menu_item_sequence>
<menu_item_obj>8455.9875</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>8458.9875</menu_structure_item_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="14" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_structure" version_date="03/17/2003" version_time="41318" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMS" key_field_value="15844.53" record_version_obj="15845.53" version_number_seq="85.09" secondary_key_value="CBMenuBar" import_version_number_seq="85.09"><menu_structure_obj>15844.53</menu_structure_obj>
<product_module_obj>0</product_module_obj>
<product_obj>0</product_obj>
<menu_structure_code>CBMenuBar</menu_structure_code>
<menu_structure_description>Container Builder Menu Bar</menu_structure_description>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_obj>0</menu_item_obj>
<menu_structure_type>Menubar</menu_structure_type>
<menu_structure_hidden>no</menu_structure_hidden>
<control_spacing>0</control_spacing>
<control_padding>0</control_padding>
<menu_structure_narrative></menu_structure_narrative>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>15844.53</menu_structure_obj>
<menu_item_sequence>1</menu_item_sequence>
<menu_item_obj>1000708213.09</menu_item_obj>
<child_menu_structure_obj>17716.5053</child_menu_structure_obj>
<menu_structure_item_obj>15849.53</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>15844.53</menu_structure_obj>
<menu_item_sequence>2</menu_item_sequence>
<menu_item_obj>15865.53</menu_item_obj>
<child_menu_structure_obj>487.5053</child_menu_structure_obj>
<menu_structure_item_obj>15867.53</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>15844.53</menu_structure_obj>
<menu_item_sequence>3</menu_item_sequence>
<menu_item_obj>15874.53</menu_item_obj>
<child_menu_structure_obj>15882.53</child_menu_structure_obj>
<menu_structure_item_obj>15876.53</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>15844.53</menu_structure_obj>
<menu_item_sequence>4</menu_item_sequence>
<menu_item_obj>725000000757.5566</menu_item_obj>
<child_menu_structure_obj>725000000742.5566</child_menu_structure_obj>
<menu_structure_item_obj>3000041085.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>15844.53</menu_structure_obj>
<menu_item_sequence>5</menu_item_sequence>
<menu_item_obj>1003576820</menu_item_obj>
<child_menu_structure_obj>16355.53</child_menu_structure_obj>
<menu_structure_item_obj>16364.53</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>15844.53</menu_structure_obj>
<menu_item_sequence>6</menu_item_sequence>
<menu_item_obj>1000708229.09</menu_item_obj>
<child_menu_structure_obj>1000708228.09</child_menu_structure_obj>
<menu_structure_item_obj>15851.53</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>15844.53</menu_structure_obj>
<menu_item_sequence>7</menu_item_sequence>
<menu_item_obj>1000708221.09</menu_item_obj>
<child_menu_structure_obj>1000708224.09</child_menu_structure_obj>
<menu_structure_item_obj>15853.53</menu_structure_item_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="15" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_structure" version_date="09/23/2002" version_time="35441" version_user="admin" deletion_flag="no" entity_mnemonic="gsmms" key_field_value="15863.53" record_version_obj="15864.53" version_number_seq="2.5053" secondary_key_value="CBAdvanced" import_version_number_seq="2.5053"><menu_structure_obj>15863.53</menu_structure_obj>
<product_module_obj>0</product_module_obj>
<product_obj>0</product_obj>
<menu_structure_code>CBAdvanced</menu_structure_code>
<menu_structure_description>Advanced Container Builder Features</menu_structure_description>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_obj>0</menu_item_obj>
<menu_structure_type>Submenu</menu_structure_type>
<menu_structure_hidden>no</menu_structure_hidden>
<control_spacing>0</control_spacing>
<control_padding>0</control_padding>
<menu_structure_narrative></menu_structure_narrative>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="16" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_structure" version_date="09/23/2002" version_time="35442" version_user="admin" deletion_flag="no" entity_mnemonic="gsmms" key_field_value="15882.53" record_version_obj="15883.53" version_number_seq="2.5053" secondary_key_value="ContainerBuilderSearch" import_version_number_seq="2.5053"><menu_structure_obj>15882.53</menu_structure_obj>
<product_module_obj>0</product_module_obj>
<product_obj>0</product_obj>
<menu_structure_code>ContainerBuilderSearch</menu_structure_code>
<menu_structure_description>Container Builder Search</menu_structure_description>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_obj>0</menu_item_obj>
<menu_structure_type>Menu&amp;Toolbar</menu_structure_type>
<menu_structure_hidden>no</menu_structure_hidden>
<control_spacing>0</control_spacing>
<control_padding>0</control_padding>
<menu_structure_narrative>This band will be used for container builder specific search actions such as the object locator</menu_structure_narrative>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>15882.53</menu_structure_obj>
<menu_item_sequence>1</menu_item_sequence>
<menu_item_obj>15884.53</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>15886.53</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>15882.53</menu_structure_obj>
<menu_item_sequence>2</menu_item_sequence>
<menu_item_obj>16169.53</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>16171.53</menu_structure_item_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="17" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_structure" version_date="09/23/2002" version_time="35442" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMS" key_field_value="16355.53" record_version_obj="16356.53" version_number_seq="24.09" secondary_key_value="ContainerBuilderSeq" import_version_number_seq="24.09"><menu_structure_obj>16355.53</menu_structure_obj>
<product_module_obj>0</product_module_obj>
<product_obj>0</product_obj>
<menu_structure_code>ContainerBuilderSeq</menu_structure_code>
<menu_structure_description>Container Builder Sequencing</menu_structure_description>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_obj>0</menu_item_obj>
<menu_structure_type>Menu&amp;Toolbar</menu_structure_type>
<menu_structure_hidden>no</menu_structure_hidden>
<control_spacing>0</control_spacing>
<control_padding>0</control_padding>
<menu_structure_narrative>This band will be used for container builder sequencing actions.</menu_structure_narrative>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>16355.53</menu_structure_obj>
<menu_item_sequence>1</menu_item_sequence>
<menu_item_obj>16357.53</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>16367.53</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>16355.53</menu_structure_obj>
<menu_item_sequence>2</menu_item_sequence>
<menu_item_obj>16361.53</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>16369.53</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>16355.53</menu_structure_obj>
<menu_item_sequence>3</menu_item_sequence>
<menu_item_obj>1003700174</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>17864.5053</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>16355.53</menu_structure_obj>
<menu_item_sequence>4</menu_item_sequence>
<menu_item_obj>1000708164.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>17865.5053</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>16355.53</menu_structure_obj>
<menu_item_sequence>5</menu_item_sequence>
<menu_item_obj>1000708139.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>17866.5053</menu_structure_item_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="18" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_structure" version_date="02/07/2003" version_time="56192" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMS" key_field_value="17716.5053" record_version_obj="17717.5053" version_number_seq="28.09" secondary_key_value="FileCB" import_version_number_seq="28.09"><menu_structure_obj>17716.5053</menu_structure_obj>
<product_module_obj>0</product_module_obj>
<product_obj>0</product_obj>
<menu_structure_code>FileCB</menu_structure_code>
<menu_structure_description>File menu for Container Builder</menu_structure_description>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_obj>1000708213.09</menu_item_obj>
<menu_structure_type>Submenu</menu_structure_type>
<menu_structure_hidden>no</menu_structure_hidden>
<control_spacing>0</control_spacing>
<control_padding>0</control_padding>
<menu_structure_narrative></menu_structure_narrative>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>17716.5053</menu_structure_obj>
<menu_item_sequence>1</menu_item_sequence>
<menu_item_obj>15857.53</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>17718.5053</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>17716.5053</menu_structure_obj>
<menu_item_sequence>2</menu_item_sequence>
<menu_item_obj>15872.53</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>17719.5053</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>17716.5053</menu_structure_obj>
<menu_item_sequence>3</menu_item_sequence>
<menu_item_obj>15870.53</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>17720.5053</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>17716.5053</menu_structure_obj>
<menu_item_sequence>4</menu_item_sequence>
<menu_item_obj>17023.53</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>17721.5053</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>17716.5053</menu_structure_obj>
<menu_item_sequence>5</menu_item_sequence>
<menu_item_obj>13067.5053</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>17722.5053</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>17716.5053</menu_structure_obj>
<menu_item_sequence>6</menu_item_sequence>
<menu_item_obj>15859.53</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>17723.5053</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>17716.5053</menu_structure_obj>
<menu_item_sequence>7</menu_item_sequence>
<menu_item_obj>90241.9875</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>90243.9875</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>17716.5053</menu_structure_obj>
<menu_item_sequence>8</menu_item_sequence>
<menu_item_obj>15861.53</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>17724.5053</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>17716.5053</menu_structure_obj>
<menu_item_sequence>9</menu_item_sequence>
<menu_item_obj>15855.53</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>17725.5053</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>17716.5053</menu_structure_obj>
<menu_item_sequence>10</menu_item_sequence>
<menu_item_obj>1003700174</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>17726.5053</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>17716.5053</menu_structure_obj>
<menu_item_sequence>11</menu_item_sequence>
<menu_item_obj>1000708145.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>17727.5053</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>17716.5053</menu_structure_obj>
<menu_item_sequence>12</menu_item_sequence>
<menu_item_obj>71.6893</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>17728.5053</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>17716.5053</menu_structure_obj>
<menu_item_sequence>13</menu_item_sequence>
<menu_item_obj>1003700174</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>17729.5053</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>17716.5053</menu_structure_obj>
<menu_item_sequence>14</menu_item_sequence>
<menu_item_obj>1000708103.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>17730.5053</menu_structure_item_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="19" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_structure" version_date="02/04/2003" version_time="53874" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMS" key_field_value="50793.9875" record_version_obj="50794.9875" version_number_seq="1.09" secondary_key_value="OGOption" import_version_number_seq="1.09"><menu_structure_obj>50793.9875</menu_structure_obj>
<product_module_obj>0</product_module_obj>
<product_obj>0</product_obj>
<menu_structure_code>OGOption</menu_structure_code>
<menu_structure_description>Object Generator Options</menu_structure_description>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_obj>1003576820</menu_item_obj>
<menu_structure_type>Submenu</menu_structure_type>
<menu_structure_hidden>no</menu_structure_hidden>
<control_spacing>0</control_spacing>
<control_padding>0</control_padding>
<menu_structure_narrative></menu_structure_narrative>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>50793.9875</menu_structure_obj>
<menu_item_sequence>1</menu_item_sequence>
<menu_item_obj>50791.9875</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>50795.9875</menu_structure_item_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="20" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_structure" version_date="09/26/2002" version_time="43692" version_user="admin" deletion_flag="no" entity_mnemonic="gsmms" key_field_value="99018" record_version_obj="3000031124.09" version_number_seq="1.09" secondary_key_value="zICF-Link" import_version_number_seq="1.09"><menu_structure_obj>99018</menu_structure_obj>
<product_module_obj>1004874679.09</product_module_obj>
<product_obj>1004874669.09</product_obj>
<menu_structure_code>zICF-Link</menu_structure_code>
<menu_structure_description>Extra Linked Menus</menu_structure_description>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_obj>99019</menu_item_obj>
<menu_structure_type>SubMenu</menu_structure_type>
<menu_structure_hidden>no</menu_structure_hidden>
<control_spacing>0</control_spacing>
<control_padding>0</control_padding>
<menu_structure_narrative></menu_structure_narrative>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>99018</menu_structure_obj>
<menu_item_sequence>6</menu_item_sequence>
<menu_item_obj>1004820209.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708017.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>99018</menu_structure_obj>
<menu_item_sequence>13</menu_item_sequence>
<menu_item_obj>1003897390</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708018.09</menu_structure_item_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="21" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_structure"><menu_structure_obj>1000708211.09</menu_structure_obj>
<product_module_obj>0</product_module_obj>
<product_obj>0</product_obj>
<menu_structure_code>Exit</menu_structure_code>
<menu_structure_description>Exit</menu_structure_description>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_obj>0</menu_item_obj>
<menu_structure_type>Menu&amp;Toolbar</menu_structure_type>
<menu_structure_hidden>no</menu_structure_hidden>
<control_spacing>0</control_spacing>
<control_padding>0</control_padding>
<menu_structure_narrative></menu_structure_narrative>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000708211.09</menu_structure_obj>
<menu_item_sequence>1</menu_item_sequence>
<menu_item_obj>1000708103.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708256.09</menu_structure_item_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="22" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_structure"><menu_structure_obj>1000708214.09</menu_structure_obj>
<product_module_obj>0</product_module_obj>
<product_obj>0</product_obj>
<menu_structure_code>Function</menu_structure_code>
<menu_structure_description>Function</menu_structure_description>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_obj>0</menu_item_obj>
<menu_structure_type>Menu&amp;Toolbar</menu_structure_type>
<menu_structure_hidden>no</menu_structure_hidden>
<control_spacing>0</control_spacing>
<control_padding>0</control_padding>
<menu_structure_narrative></menu_structure_narrative>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000708214.09</menu_structure_obj>
<menu_item_sequence>1</menu_item_sequence>
<menu_item_obj>1000708117.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708257.09</menu_structure_item_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="23" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_structure"><menu_structure_obj>1000708215.09</menu_structure_obj>
<product_module_obj>0</product_module_obj>
<product_obj>0</product_obj>
<menu_structure_code>Navigation</menu_structure_code>
<menu_structure_description>Navigation</menu_structure_description>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_obj>1000708216.09</menu_item_obj>
<menu_structure_type>Menu&amp;Toolbar</menu_structure_type>
<menu_structure_hidden>no</menu_structure_hidden>
<control_spacing>0</control_spacing>
<control_padding>0</control_padding>
<menu_structure_narrative></menu_structure_narrative>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000708215.09</menu_structure_obj>
<menu_item_sequence>1</menu_item_sequence>
<menu_item_obj>1000708113.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708258.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000708215.09</menu_structure_obj>
<menu_item_sequence>2</menu_item_sequence>
<menu_item_obj>1000708114.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708259.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000708215.09</menu_structure_obj>
<menu_item_sequence>3</menu_item_sequence>
<menu_item_obj>1000708115.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708260.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000708215.09</menu_structure_obj>
<menu_item_sequence>4</menu_item_sequence>
<menu_item_obj>1000708116.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708261.09</menu_structure_item_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="24" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_structure"><menu_structure_obj>1000708217.09</menu_structure_obj>
<product_module_obj>0</product_module_obj>
<product_obj>0</product_obj>
<menu_structure_code>NavRight</menu_structure_code>
<menu_structure_description>NavRight</menu_structure_description>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_obj>0</menu_item_obj>
<menu_structure_type>Menu&amp;Toolbar</menu_structure_type>
<menu_structure_hidden>no</menu_structure_hidden>
<control_spacing>0</control_spacing>
<control_padding>0</control_padding>
<menu_structure_narrative></menu_structure_narrative>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000708217.09</menu_structure_obj>
<menu_item_sequence>1</menu_item_sequence>
<menu_item_obj>1000708113.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708262.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000708217.09</menu_structure_obj>
<menu_item_sequence>2</menu_item_sequence>
<menu_item_obj>1000708114.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708263.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000708217.09</menu_structure_obj>
<menu_item_sequence>3</menu_item_sequence>
<menu_item_obj>1000708115.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708264.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000708217.09</menu_structure_obj>
<menu_item_sequence>4</menu_item_sequence>
<menu_item_obj>1000708116.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708265.09</menu_structure_item_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="25" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_structure"><menu_structure_obj>1000708218.09</menu_structure_obj>
<product_module_obj>0</product_module_obj>
<product_obj>0</product_obj>
<menu_structure_code>TableIo</menu_structure_code>
<menu_structure_description>TableIo</menu_structure_description>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_obj>0</menu_item_obj>
<menu_structure_type>Menu&amp;Toolbar</menu_structure_type>
<menu_structure_hidden>no</menu_structure_hidden>
<control_spacing>0</control_spacing>
<control_padding>0</control_padding>
<menu_structure_narrative></menu_structure_narrative>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000708218.09</menu_structure_obj>
<menu_item_sequence>1</menu_item_sequence>
<menu_item_obj>1000708104.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708266.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000708218.09</menu_structure_obj>
<menu_item_sequence>2</menu_item_sequence>
<menu_item_obj>1000708105.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708272.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000708218.09</menu_structure_obj>
<menu_item_sequence>3</menu_item_sequence>
<menu_item_obj>1000708106.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708267.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000708218.09</menu_structure_obj>
<menu_item_sequence>4</menu_item_sequence>
<menu_item_obj>1000708107.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708268.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000708218.09</menu_structure_obj>
<menu_item_sequence>5</menu_item_sequence>
<menu_item_obj>1000708108.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708269.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000708218.09</menu_structure_obj>
<menu_item_sequence>6</menu_item_sequence>
<menu_item_obj>1000708109.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708270.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000708218.09</menu_structure_obj>
<menu_item_sequence>7</menu_item_sequence>
<menu_item_obj>1000708110.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708271.09</menu_structure_item_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="26" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_structure"><menu_structure_obj>1000708219.09</menu_structure_obj>
<product_module_obj>0</product_module_obj>
<product_obj>0</product_obj>
<menu_structure_code>Transaction</menu_structure_code>
<menu_structure_description>Transaction</menu_structure_description>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_obj>0</menu_item_obj>
<menu_structure_type>Menu&amp;Toolbar</menu_structure_type>
<menu_structure_hidden>no</menu_structure_hidden>
<control_spacing>0</control_spacing>
<control_padding>0</control_padding>
<menu_structure_narrative></menu_structure_narrative>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000708219.09</menu_structure_obj>
<menu_item_sequence>1</menu_item_sequence>
<menu_item_obj>1000708111.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708273.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000708219.09</menu_structure_obj>
<menu_item_sequence>3</menu_item_sequence>
<menu_item_obj>1000708112.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1007500284.09</menu_structure_item_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="27" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_structure"><menu_structure_obj>1000708223.09</menu_structure_obj>
<product_module_obj>0</product_module_obj>
<product_obj>0</product_obj>
<menu_structure_code>Filter</menu_structure_code>
<menu_structure_description>Filter</menu_structure_description>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_obj>0</menu_item_obj>
<menu_structure_type>Toolbar</menu_structure_type>
<menu_structure_hidden>no</menu_structure_hidden>
<control_spacing>0</control_spacing>
<control_padding>0</control_padding>
<menu_structure_narrative></menu_structure_narrative>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000708223.09</menu_structure_obj>
<menu_item_sequence>1</menu_item_sequence>
<menu_item_obj>1000708118.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708276.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000708223.09</menu_structure_obj>
<menu_item_sequence>2</menu_item_sequence>
<menu_item_obj>1000708122.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708277.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000708223.09</menu_structure_obj>
<menu_item_sequence>3</menu_item_sequence>
<menu_item_obj>1000708126.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708278.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000708223.09</menu_structure_obj>
<menu_item_sequence>4</menu_item_sequence>
<menu_item_obj>1000708157.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708279.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000708223.09</menu_structure_obj>
<menu_item_sequence>5</menu_item_sequence>
<menu_item_obj>1000708128.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708280.09</menu_structure_item_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="28" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_structure"><menu_structure_obj>1000708224.09</menu_structure_obj>
<product_module_obj>0</product_module_obj>
<product_obj>0</product_obj>
<menu_structure_code>Help</menu_structure_code>
<menu_structure_description>Help</menu_structure_description>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_obj>1000708221.09</menu_item_obj>
<menu_structure_type>SubMenu</menu_structure_type>
<menu_structure_hidden>no</menu_structure_hidden>
<control_spacing>0</control_spacing>
<control_padding>0</control_padding>
<menu_structure_narrative></menu_structure_narrative>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000708224.09</menu_structure_obj>
<menu_item_sequence>1</menu_item_sequence>
<menu_item_obj>1000708167.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000709148.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000708224.09</menu_structure_obj>
<menu_item_sequence>4</menu_item_sequence>
<menu_item_obj>1003700174</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000709151.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000708224.09</menu_structure_obj>
<menu_item_sequence>5</menu_item_sequence>
<menu_item_obj>1000708170.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000709152.09</menu_structure_item_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="29" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_structure"><menu_structure_obj>1000708225.09</menu_structure_obj>
<product_module_obj>0</product_module_obj>
<product_obj>0</product_obj>
<menu_structure_code>IconExit</menu_structure_code>
<menu_structure_description>IconExit</menu_structure_description>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_obj>1000708213.09</menu_item_obj>
<menu_structure_type>Menu&amp;Toolbar</menu_structure_type>
<menu_structure_hidden>no</menu_structure_hidden>
<control_spacing>0</control_spacing>
<control_padding>0</control_padding>
<menu_structure_narrative></menu_structure_narrative>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000708225.09</menu_structure_obj>
<menu_item_sequence>1</menu_item_sequence>
<menu_item_obj>1000708103.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708284.09</menu_structure_item_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="30" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_structure"><menu_structure_obj>1000708228.09</menu_structure_obj>
<product_module_obj>0</product_module_obj>
<product_obj>0</product_obj>
<menu_structure_code>Window</menu_structure_code>
<menu_structure_description>Window</menu_structure_description>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_obj>1000708229.09</menu_item_obj>
<menu_structure_type>SubMenu</menu_structure_type>
<menu_structure_hidden>no</menu_structure_hidden>
<control_spacing>0</control_spacing>
<control_padding>0</control_padding>
<menu_structure_narrative></menu_structure_narrative>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000708228.09</menu_structure_obj>
<menu_item_sequence>1</menu_item_sequence>
<menu_item_obj>1000708163.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708289.09</menu_structure_item_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="31" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_structure"><menu_structure_obj>1000708230.09</menu_structure_obj>
<product_module_obj>0</product_module_obj>
<product_obj>0</product_obj>
<menu_structure_code>Windows</menu_structure_code>
<menu_structure_description>Windows</menu_structure_description>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_obj>1000708231.09</menu_item_obj>
<menu_structure_type>Menu&amp;Toolbar</menu_structure_type>
<menu_structure_hidden>no</menu_structure_hidden>
<control_spacing>0</control_spacing>
<control_padding>0</control_padding>
<menu_structure_narrative></menu_structure_narrative>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000708230.09</menu_structure_obj>
<menu_item_sequence>1</menu_item_sequence>
<menu_item_obj>1000708146.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708290.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000708230.09</menu_structure_obj>
<menu_item_sequence>2</menu_item_sequence>
<menu_item_obj>1000708147.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708291.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000708230.09</menu_structure_obj>
<menu_item_sequence>3</menu_item_sequence>
<menu_item_obj>1000708148.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708292.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000708230.09</menu_structure_obj>
<menu_item_sequence>4</menu_item_sequence>
<menu_item_obj>1000708154.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708293.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000708230.09</menu_structure_obj>
<menu_item_sequence>5</menu_item_sequence>
<menu_item_obj>1000708155.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708294.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000708230.09</menu_structure_obj>
<menu_item_sequence>6</menu_item_sequence>
<menu_item_obj>1000708149.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708295.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000708230.09</menu_structure_obj>
<menu_item_sequence>7</menu_item_sequence>
<menu_item_obj>1000708150.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708296.09</menu_structure_item_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="32" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_structure"><menu_structure_obj>1000708232.09</menu_structure_obj>
<product_module_obj>0</product_module_obj>
<product_obj>0</product_obj>
<menu_structure_code>BrowseFunction</menu_structure_code>
<menu_structure_description>BrowseFunction</menu_structure_description>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_obj>0</menu_item_obj>
<menu_structure_type>Menu&amp;Toolbar</menu_structure_type>
<menu_structure_hidden>no</menu_structure_hidden>
<control_spacing>0</control_spacing>
<control_padding>0</control_padding>
<menu_structure_narrative></menu_structure_narrative>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000708232.09</menu_structure_obj>
<menu_item_sequence>1</menu_item_sequence>
<menu_item_obj>1000708138.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708297.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000708232.09</menu_structure_obj>
<menu_item_sequence>2</menu_item_sequence>
<menu_item_obj>1000708139.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708298.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000708232.09</menu_structure_obj>
<menu_item_sequence>3</menu_item_sequence>
<menu_item_obj>1000708140.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708299.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000708232.09</menu_structure_obj>
<menu_item_sequence>4</menu_item_sequence>
<menu_item_obj>1000708141.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708300.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000708232.09</menu_structure_obj>
<menu_item_sequence>5</menu_item_sequence>
<menu_item_obj>1000708151.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708301.09</menu_structure_item_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="33" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_structure"><menu_structure_obj>1000708234.09</menu_structure_obj>
<product_module_obj>0</product_module_obj>
<product_obj>0</product_obj>
<menu_structure_code>BrowseSearch</menu_structure_code>
<menu_structure_description>BrowseSearch</menu_structure_description>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_obj>0</menu_item_obj>
<menu_structure_type>Menu&amp;Toolbar</menu_structure_type>
<menu_structure_hidden>no</menu_structure_hidden>
<control_spacing>0</control_spacing>
<control_padding>0</control_padding>
<menu_structure_narrative></menu_structure_narrative>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000708234.09</menu_structure_obj>
<menu_item_sequence>1</menu_item_sequence>
<menu_item_obj>1000708136.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708304.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000708234.09</menu_structure_obj>
<menu_item_sequence>2</menu_item_sequence>
<menu_item_obj>1000708137.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708305.09</menu_structure_item_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="34" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_structure"><menu_structure_obj>1000708235.09</menu_structure_obj>
<product_module_obj>0</product_module_obj>
<product_obj>0</product_obj>
<menu_structure_code>BrowseTableio</menu_structure_code>
<menu_structure_description>BrowseTableio</menu_structure_description>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_obj>0</menu_item_obj>
<menu_structure_type>Menu&amp;Toolbar</menu_structure_type>
<menu_structure_hidden>no</menu_structure_hidden>
<control_spacing>0</control_spacing>
<control_padding>0</control_padding>
<menu_structure_narrative></menu_structure_narrative>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000708235.09</menu_structure_obj>
<menu_item_sequence>1</menu_item_sequence>
<menu_item_obj>1000708132.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708306.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000708235.09</menu_structure_obj>
<menu_item_sequence>2</menu_item_sequence>
<menu_item_obj>1000708131.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708307.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000708235.09</menu_structure_obj>
<menu_item_sequence>3</menu_item_sequence>
<menu_item_obj>1000708130.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708308.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000708235.09</menu_structure_obj>
<menu_item_sequence>4</menu_item_sequence>
<menu_item_obj>1000708134.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708309.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000708235.09</menu_structure_obj>
<menu_item_sequence>5</menu_item_sequence>
<menu_item_obj>1000708135.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708310.09</menu_structure_item_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="35" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_structure"><menu_structure_obj>1000708237.09</menu_structure_obj>
<product_module_obj>0</product_module_obj>
<product_obj>0</product_obj>
<menu_structure_code>BrowseTableioView</menu_structure_code>
<menu_structure_description>BrowseTableioView</menu_structure_description>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_obj>0</menu_item_obj>
<menu_structure_type>Menu&amp;Toolbar</menu_structure_type>
<menu_structure_hidden>no</menu_structure_hidden>
<control_spacing>0</control_spacing>
<control_padding>0</control_padding>
<menu_structure_narrative></menu_structure_narrative>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000708237.09</menu_structure_obj>
<menu_item_sequence>1</menu_item_sequence>
<menu_item_obj>1000708135.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708315.09</menu_structure_item_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="36" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_structure"><menu_structure_obj>1000708239.09</menu_structure_obj>
<product_module_obj>0</product_module_obj>
<product_obj>0</product_obj>
<menu_structure_code>TableioMod</menu_structure_code>
<menu_structure_description>TableioMod</menu_structure_description>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_obj>0</menu_item_obj>
<menu_structure_type>Menu&amp;Toolbar</menu_structure_type>
<menu_structure_hidden>no</menu_structure_hidden>
<control_spacing>0</control_spacing>
<control_padding>0</control_padding>
<menu_structure_narrative></menu_structure_narrative>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000708239.09</menu_structure_obj>
<menu_item_sequence>1</menu_item_sequence>
<menu_item_obj>1000708104.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708316.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000708239.09</menu_structure_obj>
<menu_item_sequence>2</menu_item_sequence>
<menu_item_obj>1000708106.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708317.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000708239.09</menu_structure_obj>
<menu_item_sequence>3</menu_item_sequence>
<menu_item_obj>1000708107.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708318.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000708239.09</menu_structure_obj>
<menu_item_sequence>4</menu_item_sequence>
<menu_item_obj>1000708108.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708319.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000708239.09</menu_structure_obj>
<menu_item_sequence>5</menu_item_sequence>
<menu_item_obj>1000708109.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708320.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000708239.09</menu_structure_obj>
<menu_item_sequence>6</menu_item_sequence>
<menu_item_obj>1000708110.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708321.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000708239.09</menu_structure_obj>
<menu_item_sequence>7</menu_item_sequence>
<menu_item_obj>1000708177.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708322.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000708239.09</menu_structure_obj>
<menu_item_sequence>8</menu_item_sequence>
<menu_item_obj>1000708172.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708323.09</menu_structure_item_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="37" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_structure"><menu_structure_obj>1000708240.09</menu_structure_obj>
<product_module_obj>0</product_module_obj>
<product_obj>0</product_obj>
<menu_structure_code>FolderFunction</menu_structure_code>
<menu_structure_description>FolderFunction</menu_structure_description>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_obj>0</menu_item_obj>
<menu_structure_type>Toolbar</menu_structure_type>
<menu_structure_hidden>no</menu_structure_hidden>
<control_spacing>0</control_spacing>
<control_padding>0</control_padding>
<menu_structure_narrative></menu_structure_narrative>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000708240.09</menu_structure_obj>
<menu_item_sequence>1</menu_item_sequence>
<menu_item_obj>1000708153.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708324.09</menu_structure_item_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="38" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_structure"><menu_structure_obj>1000708241.09</menu_structure_obj>
<product_module_obj>0</product_module_obj>
<product_obj>0</product_obj>
<menu_structure_code>FolderTableIo</menu_structure_code>
<menu_structure_description>FolderTableIo</menu_structure_description>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_obj>0</menu_item_obj>
<menu_structure_type>Menu&amp;Toolbar</menu_structure_type>
<menu_structure_hidden>no</menu_structure_hidden>
<control_spacing>0</control_spacing>
<control_padding>0</control_padding>
<menu_structure_narrative></menu_structure_narrative>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000708241.09</menu_structure_obj>
<menu_item_sequence>1</menu_item_sequence>
<menu_item_obj>1000708104.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708326.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000708241.09</menu_structure_obj>
<menu_item_sequence>2</menu_item_sequence>
<menu_item_obj>1000708106.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708327.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000708241.09</menu_structure_obj>
<menu_item_sequence>3</menu_item_sequence>
<menu_item_obj>1000708107.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>95.7893</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000708241.09</menu_structure_obj>
<menu_item_sequence>4</menu_item_sequence>
<menu_item_obj>1000708108.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708328.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000708241.09</menu_structure_obj>
<menu_item_sequence>5</menu_item_sequence>
<menu_item_obj>1000708109.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708329.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000708241.09</menu_structure_obj>
<menu_item_sequence>6</menu_item_sequence>
<menu_item_obj>1000708110.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>7.66</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000708241.09</menu_structure_obj>
<menu_item_sequence>7</menu_item_sequence>
<menu_item_obj>1000708177.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708330.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000708241.09</menu_structure_obj>
<menu_item_sequence>8</menu_item_sequence>
<menu_item_obj>1000708172.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708331.09</menu_structure_item_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="39" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_structure"><menu_structure_obj>1000708242.09</menu_structure_obj>
<product_module_obj>0</product_module_obj>
<product_obj>0</product_obj>
<menu_structure_code>MenuFunction</menu_structure_code>
<menu_structure_description>MenuFunction</menu_structure_description>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_obj>0</menu_item_obj>
<menu_structure_type>Menu&amp;Toolbar</menu_structure_type>
<menu_structure_hidden>no</menu_structure_hidden>
<control_spacing>0</control_spacing>
<control_padding>0</control_padding>
<menu_structure_narrative></menu_structure_narrative>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000708242.09</menu_structure_obj>
<menu_item_sequence>1</menu_item_sequence>
<menu_item_obj>1000708143.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708332.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000708242.09</menu_structure_obj>
<menu_item_sequence>2</menu_item_sequence>
<menu_item_obj>1000708144.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708333.09</menu_structure_item_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="40" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_structure"><menu_structure_obj>1000708243.09</menu_structure_obj>
<product_module_obj>0</product_module_obj>
<product_obj>0</product_obj>
<menu_structure_code>TxtClose</menu_structure_code>
<menu_structure_description>TxtClose</menu_structure_description>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_obj>0</menu_item_obj>
<menu_structure_type>Toolbar</menu_structure_type>
<menu_structure_hidden>no</menu_structure_hidden>
<control_spacing>0</control_spacing>
<control_padding>0</control_padding>
<menu_structure_narrative></menu_structure_narrative>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000708243.09</menu_structure_obj>
<menu_item_sequence>1</menu_item_sequence>
<menu_item_obj>1000708118.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708334.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000708243.09</menu_structure_obj>
<menu_item_sequence>2</menu_item_sequence>
<menu_item_obj>1000708122.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708335.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000708243.09</menu_structure_obj>
<menu_item_sequence>3</menu_item_sequence>
<menu_item_obj>1000708124.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708336.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000708243.09</menu_structure_obj>
<menu_item_sequence>4</menu_item_sequence>
<menu_item_obj>1000708128.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708337.09</menu_structure_item_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="41" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_structure"><menu_structure_obj>1000708244.09</menu_structure_obj>
<product_module_obj>0</product_module_obj>
<product_obj>0</product_obj>
<menu_structure_code>TxtLookup</menu_structure_code>
<menu_structure_description>TxtLookup</menu_structure_description>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_obj>0</menu_item_obj>
<menu_structure_type>Toolbar</menu_structure_type>
<menu_structure_hidden>no</menu_structure_hidden>
<control_spacing>0</control_spacing>
<control_padding>0</control_padding>
<menu_structure_narrative></menu_structure_narrative>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000708244.09</menu_structure_obj>
<menu_item_sequence>1</menu_item_sequence>
<menu_item_obj>1000708121.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708339.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000708244.09</menu_structure_obj>
<menu_item_sequence>2</menu_item_sequence>
<menu_item_obj>1000708124.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708340.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000708244.09</menu_structure_obj>
<menu_item_sequence>4</menu_item_sequence>
<menu_item_obj>1000708128.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708342.09</menu_structure_item_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="42" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_structure" version_date="02/11/2003" version_time="54045" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMS" key_field_value="1000709153.09" record_version_obj="1283.6893" version_number_seq="1.09" secondary_key_value="File" import_version_number_seq="1.09"><menu_structure_obj>1000709153.09</menu_structure_obj>
<product_module_obj>0</product_module_obj>
<product_obj>0</product_obj>
<menu_structure_code>File</menu_structure_code>
<menu_structure_description>File</menu_structure_description>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_obj>1000708213.09</menu_item_obj>
<menu_structure_type>SubMenu</menu_structure_type>
<menu_structure_hidden>no</menu_structure_hidden>
<control_spacing>0</control_spacing>
<control_padding>0</control_padding>
<menu_structure_narrative></menu_structure_narrative>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709153.09</menu_structure_obj>
<menu_item_sequence>1</menu_item_sequence>
<menu_item_obj>71.6893</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1284.6893</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709153.09</menu_structure_obj>
<menu_item_sequence>2</menu_item_sequence>
<menu_item_obj>1000708103.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000709154.09</menu_structure_item_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="43" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_structure"><menu_structure_obj>1000709155.09</menu_structure_obj>
<product_module_obj>0</product_module_obj>
<product_obj>0</product_obj>
<menu_structure_code>File2</menu_structure_code>
<menu_structure_description>File2</menu_structure_description>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_obj>1000708213.09</menu_item_obj>
<menu_structure_type>SubMenu</menu_structure_type>
<menu_structure_hidden>no</menu_structure_hidden>
<control_spacing>0</control_spacing>
<control_padding>0</control_padding>
<menu_structure_narrative></menu_structure_narrative>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709155.09</menu_structure_obj>
<menu_item_sequence>1</menu_item_sequence>
<menu_item_obj>1000708153.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000709156.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709155.09</menu_structure_obj>
<menu_item_sequence>2</menu_item_sequence>
<menu_item_obj>1000708145.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000709157.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709155.09</menu_structure_obj>
<menu_item_sequence>3</menu_item_sequence>
<menu_item_obj>71.6893</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>92.6893</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709155.09</menu_structure_obj>
<menu_item_sequence>4</menu_item_sequence>
<menu_item_obj>1003700174</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000709158.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709155.09</menu_structure_obj>
<menu_item_sequence>5</menu_item_sequence>
<menu_item_obj>1000708103.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000709159.09</menu_structure_item_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="44" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_structure"><menu_structure_obj>1000709160.09</menu_structure_obj>
<product_module_obj>0</product_module_obj>
<product_obj>0</product_obj>
<menu_structure_code>File3</menu_structure_code>
<menu_structure_description>File3</menu_structure_description>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_obj>1000708213.09</menu_item_obj>
<menu_structure_type>SubMenu</menu_structure_type>
<menu_structure_hidden>no</menu_structure_hidden>
<control_spacing>0</control_spacing>
<control_padding>0</control_padding>
<menu_structure_narrative></menu_structure_narrative>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709160.09</menu_structure_obj>
<menu_item_sequence>1</menu_item_sequence>
<menu_item_obj>1000708145.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000709161.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709160.09</menu_structure_obj>
<menu_item_sequence>2</menu_item_sequence>
<menu_item_obj>71.6893</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>94.6893</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709160.09</menu_structure_obj>
<menu_item_sequence>3</menu_item_sequence>
<menu_item_obj>1003700174</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000709162.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709160.09</menu_structure_obj>
<menu_item_sequence>4</menu_item_sequence>
<menu_item_obj>1000708103.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000709163.09</menu_structure_item_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="45" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_structure"><menu_structure_obj>1000709164.09</menu_structure_obj>
<product_module_obj>0</product_module_obj>
<product_obj>0</product_obj>
<menu_structure_code>File4</menu_structure_code>
<menu_structure_description>File4</menu_structure_description>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_obj>1000708213.09</menu_item_obj>
<menu_structure_type>SubMenu</menu_structure_type>
<menu_structure_hidden>no</menu_structure_hidden>
<control_spacing>0</control_spacing>
<control_padding>0</control_padding>
<menu_structure_narrative></menu_structure_narrative>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709164.09</menu_structure_obj>
<menu_item_sequence>1</menu_item_sequence>
<menu_item_obj>1000708136.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000709165.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709164.09</menu_structure_obj>
<menu_item_sequence>2</menu_item_sequence>
<menu_item_obj>1000708137.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000709166.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709164.09</menu_structure_obj>
<menu_item_sequence>3</menu_item_sequence>
<menu_item_obj>1003700174</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000709167.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709164.09</menu_structure_obj>
<menu_item_sequence>4</menu_item_sequence>
<menu_item_obj>1000708138.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000709168.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709164.09</menu_structure_obj>
<menu_item_sequence>5</menu_item_sequence>
<menu_item_obj>1000708139.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000709169.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709164.09</menu_structure_obj>
<menu_item_sequence>6</menu_item_sequence>
<menu_item_obj>1000708140.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000709170.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709164.09</menu_structure_obj>
<menu_item_sequence>7</menu_item_sequence>
<menu_item_obj>1000708141.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000709171.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709164.09</menu_structure_obj>
<menu_item_sequence>8</menu_item_sequence>
<menu_item_obj>1000708151.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000709172.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709164.09</menu_structure_obj>
<menu_item_sequence>9</menu_item_sequence>
<menu_item_obj>1003700174</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000709173.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709164.09</menu_structure_obj>
<menu_item_sequence>10</menu_item_sequence>
<menu_item_obj>1000708103.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000709174.09</menu_structure_item_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="46" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_structure"><menu_structure_obj>1000709175.09</menu_structure_obj>
<product_module_obj>0</product_module_obj>
<product_obj>0</product_obj>
<menu_structure_code>File5</menu_structure_code>
<menu_structure_description>File5</menu_structure_description>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_obj>1000708213.09</menu_item_obj>
<menu_structure_type>SubMenu</menu_structure_type>
<menu_structure_hidden>no</menu_structure_hidden>
<control_spacing>0</control_spacing>
<control_padding>0</control_padding>
<menu_structure_narrative></menu_structure_narrative>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709175.09</menu_structure_obj>
<menu_item_sequence>1</menu_item_sequence>
<menu_item_obj>1000708132.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000709176.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709175.09</menu_structure_obj>
<menu_item_sequence>2</menu_item_sequence>
<menu_item_obj>1000708131.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000709177.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709175.09</menu_structure_obj>
<menu_item_sequence>3</menu_item_sequence>
<menu_item_obj>1000708130.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000709178.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709175.09</menu_structure_obj>
<menu_item_sequence>4</menu_item_sequence>
<menu_item_obj>1000708134.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000709179.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709175.09</menu_structure_obj>
<menu_item_sequence>5</menu_item_sequence>
<menu_item_obj>1000708135.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000709180.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709175.09</menu_structure_obj>
<menu_item_sequence>6</menu_item_sequence>
<menu_item_obj>1003700174</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000709181.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709175.09</menu_structure_obj>
<menu_item_sequence>7</menu_item_sequence>
<menu_item_obj>1000708136.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000709182.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709175.09</menu_structure_obj>
<menu_item_sequence>8</menu_item_sequence>
<menu_item_obj>1000708137.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000709183.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709175.09</menu_structure_obj>
<menu_item_sequence>9</menu_item_sequence>
<menu_item_obj>1003700174</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000709184.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709175.09</menu_structure_obj>
<menu_item_sequence>10</menu_item_sequence>
<menu_item_obj>1000708138.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000709185.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709175.09</menu_structure_obj>
<menu_item_sequence>11</menu_item_sequence>
<menu_item_obj>1000708139.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000709186.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709175.09</menu_structure_obj>
<menu_item_sequence>12</menu_item_sequence>
<menu_item_obj>1000708140.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000709187.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709175.09</menu_structure_obj>
<menu_item_sequence>13</menu_item_sequence>
<menu_item_obj>1000708141.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000709188.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709175.09</menu_structure_obj>
<menu_item_sequence>14</menu_item_sequence>
<menu_item_obj>1000708151.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000709189.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709175.09</menu_structure_obj>
<menu_item_sequence>15</menu_item_sequence>
<menu_item_obj>1003700174</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000709190.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709175.09</menu_structure_obj>
<menu_item_sequence>16</menu_item_sequence>
<menu_item_obj>1000708103.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000709191.09</menu_structure_item_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="47" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_structure"><menu_structure_obj>1000709206.09</menu_structure_obj>
<product_module_obj>0</product_module_obj>
<product_obj>0</product_obj>
<menu_structure_code>File7</menu_structure_code>
<menu_structure_description>File7</menu_structure_description>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_obj>1000708213.09</menu_item_obj>
<menu_structure_type>SubMenu</menu_structure_type>
<menu_structure_hidden>no</menu_structure_hidden>
<control_spacing>0</control_spacing>
<control_padding>0</control_padding>
<menu_structure_narrative></menu_structure_narrative>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709206.09</menu_structure_obj>
<menu_item_sequence>1</menu_item_sequence>
<menu_item_obj>1000708135.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000709207.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709206.09</menu_structure_obj>
<menu_item_sequence>2</menu_item_sequence>
<menu_item_obj>1003700174</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000709208.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709206.09</menu_structure_obj>
<menu_item_sequence>3</menu_item_sequence>
<menu_item_obj>1000708136.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000709209.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709206.09</menu_structure_obj>
<menu_item_sequence>4</menu_item_sequence>
<menu_item_obj>1000708137.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000709210.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709206.09</menu_structure_obj>
<menu_item_sequence>5</menu_item_sequence>
<menu_item_obj>1003700174</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000709211.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709206.09</menu_structure_obj>
<menu_item_sequence>6</menu_item_sequence>
<menu_item_obj>1000708138.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000709212.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709206.09</menu_structure_obj>
<menu_item_sequence>7</menu_item_sequence>
<menu_item_obj>1000708139.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000709213.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709206.09</menu_structure_obj>
<menu_item_sequence>8</menu_item_sequence>
<menu_item_obj>1003700174</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000709214.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709206.09</menu_structure_obj>
<menu_item_sequence>9</menu_item_sequence>
<menu_item_obj>1000708103.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000709215.09</menu_structure_item_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="48" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_structure"><menu_structure_obj>1000709216.09</menu_structure_obj>
<product_module_obj>0</product_module_obj>
<product_obj>0</product_obj>
<menu_structure_code>File8</menu_structure_code>
<menu_structure_description>File8</menu_structure_description>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_obj>1000708213.09</menu_item_obj>
<menu_structure_type>SubMenu</menu_structure_type>
<menu_structure_hidden>no</menu_structure_hidden>
<control_spacing>0</control_spacing>
<control_padding>0</control_padding>
<menu_structure_narrative></menu_structure_narrative>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709216.09</menu_structure_obj>
<menu_item_sequence>1</menu_item_sequence>
<menu_item_obj>1000708104.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000709217.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709216.09</menu_structure_obj>
<menu_item_sequence>2</menu_item_sequence>
<menu_item_obj>1000708106.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000709218.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709216.09</menu_structure_obj>
<menu_item_sequence>3</menu_item_sequence>
<menu_item_obj>1000708107.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000709219.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709216.09</menu_structure_obj>
<menu_item_sequence>4</menu_item_sequence>
<menu_item_obj>1000708108.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000709220.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709216.09</menu_structure_obj>
<menu_item_sequence>5</menu_item_sequence>
<menu_item_obj>1000708109.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000709221.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709216.09</menu_structure_obj>
<menu_item_sequence>6</menu_item_sequence>
<menu_item_obj>1000708110.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000709222.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709216.09</menu_structure_obj>
<menu_item_sequence>7</menu_item_sequence>
<menu_item_obj>1000708177.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000709223.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709216.09</menu_structure_obj>
<menu_item_sequence>8</menu_item_sequence>
<menu_item_obj>1000708172.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000709224.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709216.09</menu_structure_obj>
<menu_item_sequence>9</menu_item_sequence>
<menu_item_obj>1003700174</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000709225.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709216.09</menu_structure_obj>
<menu_item_sequence>10</menu_item_sequence>
<menu_item_obj>1000708216.09</menu_item_obj>
<child_menu_structure_obj>1000708215.09</child_menu_structure_obj>
<menu_structure_item_obj>1000709226.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709216.09</menu_structure_obj>
<menu_item_sequence>11</menu_item_sequence>
<menu_item_obj>1003700174</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000709227.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709216.09</menu_structure_obj>
<menu_item_sequence>12</menu_item_sequence>
<menu_item_obj>1000708103.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000709228.09</menu_structure_item_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="49" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_structure"><menu_structure_obj>1000709229.09</menu_structure_obj>
<product_module_obj>0</product_module_obj>
<product_obj>0</product_obj>
<menu_structure_code>File9</menu_structure_code>
<menu_structure_description>File9</menu_structure_description>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_obj>1000708213.09</menu_item_obj>
<menu_structure_type>SubMenu</menu_structure_type>
<menu_structure_hidden>no</menu_structure_hidden>
<control_spacing>0</control_spacing>
<control_padding>0</control_padding>
<menu_structure_narrative></menu_structure_narrative>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709229.09</menu_structure_obj>
<menu_item_sequence>1</menu_item_sequence>
<menu_item_obj>1000708104.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000709230.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709229.09</menu_structure_obj>
<menu_item_sequence>2</menu_item_sequence>
<menu_item_obj>1000708106.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000709231.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709229.09</menu_structure_obj>
<menu_item_sequence>3</menu_item_sequence>
<menu_item_obj>1000708108.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000709232.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709229.09</menu_structure_obj>
<menu_item_sequence>4</menu_item_sequence>
<menu_item_obj>1000708109.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000709233.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709229.09</menu_structure_obj>
<menu_item_sequence>5</menu_item_sequence>
<menu_item_obj>1000708110.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>8.66</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709229.09</menu_structure_obj>
<menu_item_sequence>6</menu_item_sequence>
<menu_item_obj>1000708177.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000709234.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709229.09</menu_structure_obj>
<menu_item_sequence>7</menu_item_sequence>
<menu_item_obj>1000708172.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000709235.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709229.09</menu_structure_obj>
<menu_item_sequence>8</menu_item_sequence>
<menu_item_obj>1003700174</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000709236.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709229.09</menu_structure_obj>
<menu_item_sequence>9</menu_item_sequence>
<menu_item_obj>1000708216.09</menu_item_obj>
<child_menu_structure_obj>1000708215.09</child_menu_structure_obj>
<menu_structure_item_obj>1000709237.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709229.09</menu_structure_obj>
<menu_item_sequence>10</menu_item_sequence>
<menu_item_obj>1003700174</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000709238.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709229.09</menu_structure_obj>
<menu_item_sequence>11</menu_item_sequence>
<menu_item_obj>1000708153.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000709239.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709229.09</menu_structure_obj>
<menu_item_sequence>12</menu_item_sequence>
<menu_item_obj>1000708145.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000709240.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709229.09</menu_structure_obj>
<menu_item_sequence>13</menu_item_sequence>
<menu_item_obj>71.6893</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>96.6893</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709229.09</menu_structure_obj>
<menu_item_sequence>14</menu_item_sequence>
<menu_item_obj>1003700174</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000709241.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709229.09</menu_structure_obj>
<menu_item_sequence>15</menu_item_sequence>
<menu_item_obj>1000708103.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000709242.09</menu_structure_item_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="50" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_structure"><menu_structure_obj>1000709243.09</menu_structure_obj>
<product_module_obj>0</product_module_obj>
<product_obj>0</product_obj>
<menu_structure_code>FileMenu</menu_structure_code>
<menu_structure_description>FileMenu</menu_structure_description>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_obj>1000708213.09</menu_item_obj>
<menu_structure_type>SubMenu</menu_structure_type>
<menu_structure_hidden>no</menu_structure_hidden>
<control_spacing>0</control_spacing>
<control_padding>0</control_padding>
<menu_structure_narrative></menu_structure_narrative>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709243.09</menu_structure_obj>
<menu_item_sequence>1</menu_item_sequence>
<menu_item_obj>1000708143.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000709244.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709243.09</menu_structure_obj>
<menu_item_sequence>2</menu_item_sequence>
<menu_item_obj>1000708144.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000709245.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709243.09</menu_structure_obj>
<menu_item_sequence>3</menu_item_sequence>
<menu_item_obj>1003700174</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000709246.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709243.09</menu_structure_obj>
<menu_item_sequence>4</menu_item_sequence>
<menu_item_obj>1000708164.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000709247.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709243.09</menu_structure_obj>
<menu_item_sequence>5</menu_item_sequence>
<menu_item_obj>1000708165.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000709248.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709243.09</menu_structure_obj>
<menu_item_sequence>6</menu_item_sequence>
<menu_item_obj>1000708145.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000709249.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709243.09</menu_structure_obj>
<menu_item_sequence>7</menu_item_sequence>
<menu_item_obj>71.6893</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>98.6893</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709243.09</menu_structure_obj>
<menu_item_sequence>8</menu_item_sequence>
<menu_item_obj>1003700174</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000709250.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709243.09</menu_structure_obj>
<menu_item_sequence>9</menu_item_sequence>
<menu_item_obj>1000708231.09</menu_item_obj>
<child_menu_structure_obj>1000708230.09</child_menu_structure_obj>
<menu_structure_item_obj>1000709251.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709243.09</menu_structure_obj>
<menu_item_sequence>10</menu_item_sequence>
<menu_item_obj>1003700174</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000709252.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709243.09</menu_structure_obj>
<menu_item_sequence>11</menu_item_sequence>
<menu_item_obj>1000708103.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000709253.09</menu_structure_item_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="51" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_structure"><menu_structure_obj>1000709254.09</menu_structure_obj>
<product_module_obj>0</product_module_obj>
<product_obj>0</product_obj>
<menu_structure_code>FileLookup</menu_structure_code>
<menu_structure_description>FileLookup</menu_structure_description>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_obj>1000708213.09</menu_item_obj>
<menu_structure_type>SubMenu</menu_structure_type>
<menu_structure_hidden>no</menu_structure_hidden>
<control_spacing>0</control_spacing>
<control_padding>0</control_padding>
<menu_structure_narrative></menu_structure_narrative>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709254.09</menu_structure_obj>
<menu_item_sequence>1</menu_item_sequence>
<menu_item_obj>1000708121.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000709255.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709254.09</menu_structure_obj>
<menu_item_sequence>2</menu_item_sequence>
<menu_item_obj>1000708145.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000709256.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709254.09</menu_structure_obj>
<menu_item_sequence>3</menu_item_sequence>
<menu_item_obj>71.6893</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>100.6893</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709254.09</menu_structure_obj>
<menu_item_sequence>4</menu_item_sequence>
<menu_item_obj>1003700174</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000709257.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709254.09</menu_structure_obj>
<menu_item_sequence>5</menu_item_sequence>
<menu_item_obj>1000708103.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000709258.09</menu_structure_item_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="52" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_structure"><menu_structure_obj>1000709259.09</menu_structure_obj>
<product_module_obj>0</product_module_obj>
<product_obj>0</product_obj>
<menu_structure_code>FileNav</menu_structure_code>
<menu_structure_description>FileNav</menu_structure_description>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_obj>1000708213.09</menu_item_obj>
<menu_structure_type>SubMenu</menu_structure_type>
<menu_structure_hidden>no</menu_structure_hidden>
<control_spacing>0</control_spacing>
<control_padding>0</control_padding>
<menu_structure_narrative></menu_structure_narrative>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709259.09</menu_structure_obj>
<menu_item_sequence>1</menu_item_sequence>
<menu_item_obj>1000708216.09</menu_item_obj>
<child_menu_structure_obj>1000708215.09</child_menu_structure_obj>
<menu_structure_item_obj>1000709260.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709259.09</menu_structure_obj>
<menu_item_sequence>2</menu_item_sequence>
<menu_item_obj>1003700174</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000709261.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709259.09</menu_structure_obj>
<menu_item_sequence>3</menu_item_sequence>
<menu_item_obj>1000708103.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000709262.09</menu_structure_item_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="53" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_structure"><menu_structure_obj>1000709270.09</menu_structure_obj>
<product_module_obj>0</product_module_obj>
<product_obj>0</product_obj>
<menu_structure_code>File14</menu_structure_code>
<menu_structure_description>File14</menu_structure_description>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_obj>1000708213.09</menu_item_obj>
<menu_structure_type>SubMenu</menu_structure_type>
<menu_structure_hidden>no</menu_structure_hidden>
<control_spacing>0</control_spacing>
<control_padding>0</control_padding>
<menu_structure_narrative></menu_structure_narrative>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709270.09</menu_structure_obj>
<menu_item_sequence>1</menu_item_sequence>
<menu_item_obj>1000708216.09</menu_item_obj>
<child_menu_structure_obj>1000708215.09</child_menu_structure_obj>
<menu_structure_item_obj>1000709271.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709270.09</menu_structure_obj>
<menu_item_sequence>2</menu_item_sequence>
<menu_item_obj>1003700174</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000709272.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709270.09</menu_structure_obj>
<menu_item_sequence>3</menu_item_sequence>
<menu_item_obj>1000708145.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000709273.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709270.09</menu_structure_obj>
<menu_item_sequence>4</menu_item_sequence>
<menu_item_obj>71.6893</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>102.6893</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709270.09</menu_structure_obj>
<menu_item_sequence>5</menu_item_sequence>
<menu_item_obj>1003700174</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000709274.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709270.09</menu_structure_obj>
<menu_item_sequence>6</menu_item_sequence>
<menu_item_obj>1000708103.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000709275.09</menu_structure_item_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="54" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_structure"><menu_structure_obj>1000709276.09</menu_structure_obj>
<product_module_obj>0</product_module_obj>
<product_obj>0</product_obj>
<menu_structure_code>BrowseMenubarView</menu_structure_code>
<menu_structure_description>BrowseMenuBarView</menu_structure_description>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_obj>0</menu_item_obj>
<menu_structure_type>MenuBar</menu_structure_type>
<menu_structure_hidden>no</menu_structure_hidden>
<control_spacing>0</control_spacing>
<control_padding>0</control_padding>
<menu_structure_narrative></menu_structure_narrative>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709276.09</menu_structure_obj>
<menu_item_sequence>1</menu_item_sequence>
<menu_item_obj>1000708213.09</menu_item_obj>
<child_menu_structure_obj>1000709206.09</child_menu_structure_obj>
<menu_structure_item_obj>1000709278.09</menu_structure_item_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="55" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_structure"><menu_structure_obj>1000709279.09</menu_structure_obj>
<product_module_obj>0</product_module_obj>
<product_obj>0</product_obj>
<menu_structure_code>NavMenuBar</menu_structure_code>
<menu_structure_description>NavMenuBar</menu_structure_description>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_obj>0</menu_item_obj>
<menu_structure_type>MenuBar</menu_structure_type>
<menu_structure_hidden>no</menu_structure_hidden>
<control_spacing>0</control_spacing>
<control_padding>0</control_padding>
<menu_structure_narrative></menu_structure_narrative>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709279.09</menu_structure_obj>
<menu_item_sequence>1</menu_item_sequence>
<menu_item_obj>1000708213.09</menu_item_obj>
<child_menu_structure_obj>1000709259.09</child_menu_structure_obj>
<menu_structure_item_obj>1000709281.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709279.09</menu_structure_obj>
<menu_item_sequence>2</menu_item_sequence>
<menu_item_obj>1000708229.09</menu_item_obj>
<child_menu_structure_obj>1000708228.09</child_menu_structure_obj>
<menu_structure_item_obj>1000709282.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709279.09</menu_structure_obj>
<menu_item_sequence>3</menu_item_sequence>
<menu_item_obj>1000708221.09</menu_item_obj>
<child_menu_structure_obj>1000708224.09</child_menu_structure_obj>
<menu_structure_item_obj>1000709283.09</menu_structure_item_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="56" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_structure"><menu_structure_obj>1000709284.09</menu_structure_obj>
<product_module_obj>0</product_module_obj>
<product_obj>0</product_obj>
<menu_structure_code>BrowseMenuBar</menu_structure_code>
<menu_structure_description>BrowseMenuBar</menu_structure_description>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_obj>0</menu_item_obj>
<menu_structure_type>MenuBar</menu_structure_type>
<menu_structure_hidden>no</menu_structure_hidden>
<control_spacing>0</control_spacing>
<control_padding>0</control_padding>
<menu_structure_narrative></menu_structure_narrative>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709284.09</menu_structure_obj>
<menu_item_sequence>1</menu_item_sequence>
<menu_item_obj>1000708213.09</menu_item_obj>
<child_menu_structure_obj>1000709175.09</child_menu_structure_obj>
<menu_structure_item_obj>1000709286.09</menu_structure_item_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="57" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_structure"><menu_structure_obj>1000709287.09</menu_structure_obj>
<product_module_obj>0</product_module_obj>
<product_obj>0</product_obj>
<menu_structure_code>BrowseMenuBarNoUpdate</menu_structure_code>
<menu_structure_description>BrowseMenuBarNoUpdate</menu_structure_description>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_obj>0</menu_item_obj>
<menu_structure_type>MenuBar</menu_structure_type>
<menu_structure_hidden>no</menu_structure_hidden>
<control_spacing>0</control_spacing>
<control_padding>0</control_padding>
<menu_structure_narrative></menu_structure_narrative>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709287.09</menu_structure_obj>
<menu_item_sequence>1</menu_item_sequence>
<menu_item_obj>1000708213.09</menu_item_obj>
<child_menu_structure_obj>1000709164.09</child_menu_structure_obj>
<menu_structure_item_obj>1000709289.09</menu_structure_item_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="58" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_structure"><menu_structure_obj>1000709293.09</menu_structure_obj>
<product_module_obj>0</product_module_obj>
<product_obj>0</product_obj>
<menu_structure_code>FolderPageTop</menu_structure_code>
<menu_structure_description>FolderPageTop</menu_structure_description>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_obj>0</menu_item_obj>
<menu_structure_type>MenuBar</menu_structure_type>
<menu_structure_hidden>no</menu_structure_hidden>
<control_spacing>0</control_spacing>
<control_padding>0</control_padding>
<menu_structure_narrative></menu_structure_narrative>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709293.09</menu_structure_obj>
<menu_item_sequence>1</menu_item_sequence>
<menu_item_obj>1000708213.09</menu_item_obj>
<child_menu_structure_obj>1000709216.09</child_menu_structure_obj>
<menu_structure_item_obj>1000709295.09</menu_structure_item_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="59" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_structure"><menu_structure_obj>1000709296.09</menu_structure_obj>
<product_module_obj>0</product_module_obj>
<product_obj>0</product_obj>
<menu_structure_code>FolderTop</menu_structure_code>
<menu_structure_description>FolderTop</menu_structure_description>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_obj>0</menu_item_obj>
<menu_structure_type>MenuBar</menu_structure_type>
<menu_structure_hidden>no</menu_structure_hidden>
<control_spacing>0</control_spacing>
<control_padding>0</control_padding>
<menu_structure_narrative></menu_structure_narrative>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709296.09</menu_structure_obj>
<menu_item_sequence>1</menu_item_sequence>
<menu_item_obj>1000708213.09</menu_item_obj>
<child_menu_structure_obj>1000709229.09</child_menu_structure_obj>
<menu_structure_item_obj>1000709298.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709296.09</menu_structure_obj>
<menu_item_sequence>2</menu_item_sequence>
<menu_item_obj>1000708229.09</menu_item_obj>
<child_menu_structure_obj>1000708228.09</child_menu_structure_obj>
<menu_structure_item_obj>1000709299.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709296.09</menu_structure_obj>
<menu_item_sequence>3</menu_item_sequence>
<menu_item_obj>1000708221.09</menu_item_obj>
<child_menu_structure_obj>1000708224.09</child_menu_structure_obj>
<menu_structure_item_obj>1000709300.09</menu_structure_item_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="60" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_structure"><menu_structure_obj>1000709301.09</menu_structure_obj>
<product_module_obj>0</product_module_obj>
<product_obj>0</product_obj>
<menu_structure_code>FolderTopNoSDO</menu_structure_code>
<menu_structure_description>FolderTopNoSDO</menu_structure_description>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_obj>0</menu_item_obj>
<menu_structure_type>MenuBar</menu_structure_type>
<menu_structure_hidden>no</menu_structure_hidden>
<control_spacing>0</control_spacing>
<control_padding>0</control_padding>
<menu_structure_narrative></menu_structure_narrative>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709301.09</menu_structure_obj>
<menu_item_sequence>1</menu_item_sequence>
<menu_item_obj>1000708213.09</menu_item_obj>
<child_menu_structure_obj>1000709160.09</child_menu_structure_obj>
<menu_structure_item_obj>1000709303.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709301.09</menu_structure_obj>
<menu_item_sequence>2</menu_item_sequence>
<menu_item_obj>1000708229.09</menu_item_obj>
<child_menu_structure_obj>1000708228.09</child_menu_structure_obj>
<menu_structure_item_obj>1000709304.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709301.09</menu_structure_obj>
<menu_item_sequence>3</menu_item_sequence>
<menu_item_obj>1000708221.09</menu_item_obj>
<child_menu_structure_obj>1000708224.09</child_menu_structure_obj>
<menu_structure_item_obj>1000709305.09</menu_structure_item_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="61" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_structure"><menu_structure_obj>1000709306.09</menu_structure_obj>
<product_module_obj>0</product_module_obj>
<product_obj>0</product_obj>
<menu_structure_code>LookupMenuBar</menu_structure_code>
<menu_structure_description>LookupMenuBar</menu_structure_description>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_obj>0</menu_item_obj>
<menu_structure_type>MenuBar</menu_structure_type>
<menu_structure_hidden>no</menu_structure_hidden>
<control_spacing>0</control_spacing>
<control_padding>0</control_padding>
<menu_structure_narrative></menu_structure_narrative>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709306.09</menu_structure_obj>
<menu_item_sequence>1</menu_item_sequence>
<menu_item_obj>1000708213.09</menu_item_obj>
<child_menu_structure_obj>1000709254.09</child_menu_structure_obj>
<menu_structure_item_obj>1000709308.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709306.09</menu_structure_obj>
<menu_item_sequence>2</menu_item_sequence>
<menu_item_obj>1000708229.09</menu_item_obj>
<child_menu_structure_obj>1000708228.09</child_menu_structure_obj>
<menu_structure_item_obj>1000709309.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709306.09</menu_structure_obj>
<menu_item_sequence>3</menu_item_sequence>
<menu_item_obj>1000708221.09</menu_item_obj>
<child_menu_structure_obj>1000708224.09</child_menu_structure_obj>
<menu_structure_item_obj>1000709310.09</menu_structure_item_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="62" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_structure"><menu_structure_obj>1000709311.09</menu_structure_obj>
<product_module_obj>0</product_module_obj>
<product_obj>0</product_obj>
<menu_structure_code>MenuController</menu_structure_code>
<menu_structure_description>MenuController</menu_structure_description>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_obj>0</menu_item_obj>
<menu_structure_type>MenuBar</menu_structure_type>
<menu_structure_hidden>no</menu_structure_hidden>
<control_spacing>0</control_spacing>
<control_padding>0</control_padding>
<menu_structure_narrative></menu_structure_narrative>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709311.09</menu_structure_obj>
<menu_item_sequence>1</menu_item_sequence>
<menu_item_obj>1000708213.09</menu_item_obj>
<child_menu_structure_obj>1000709243.09</child_menu_structure_obj>
<menu_structure_item_obj>1000709313.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709311.09</menu_structure_obj>
<menu_item_sequence>2</menu_item_sequence>
<menu_item_obj>1000709147.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000709314.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709311.09</menu_structure_obj>
<menu_item_sequence>3</menu_item_sequence>
<menu_item_obj>1000708229.09</menu_item_obj>
<child_menu_structure_obj>1000708228.09</child_menu_structure_obj>
<menu_structure_item_obj>1000709315.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709311.09</menu_structure_obj>
<menu_item_sequence>4</menu_item_sequence>
<menu_item_obj>1000708221.09</menu_item_obj>
<child_menu_structure_obj>1000708224.09</child_menu_structure_obj>
<menu_structure_item_obj>1000709316.09</menu_structure_item_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="63" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_structure"><menu_structure_obj>1000709317.09</menu_structure_obj>
<product_module_obj>0</product_module_obj>
<product_obj>0</product_obj>
<menu_structure_code>ObjcTop</menu_structure_code>
<menu_structure_description>ObjcTop</menu_structure_description>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_obj>0</menu_item_obj>
<menu_structure_type>MenuBar</menu_structure_type>
<menu_structure_hidden>no</menu_structure_hidden>
<control_spacing>0</control_spacing>
<control_padding>0</control_padding>
<menu_structure_narrative></menu_structure_narrative>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709317.09</menu_structure_obj>
<menu_item_sequence>1</menu_item_sequence>
<menu_item_obj>1000708213.09</menu_item_obj>
<child_menu_structure_obj>1000709270.09</child_menu_structure_obj>
<menu_structure_item_obj>1000709319.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709317.09</menu_structure_obj>
<menu_item_sequence>2</menu_item_sequence>
<menu_item_obj>1000709147.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000709320.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709317.09</menu_structure_obj>
<menu_item_sequence>3</menu_item_sequence>
<menu_item_obj>1000708229.09</menu_item_obj>
<child_menu_structure_obj>1000708228.09</child_menu_structure_obj>
<menu_structure_item_obj>1000709321.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709317.09</menu_structure_obj>
<menu_item_sequence>4</menu_item_sequence>
<menu_item_obj>1000708221.09</menu_item_obj>
<child_menu_structure_obj>1000708224.09</child_menu_structure_obj>
<menu_structure_item_obj>1000709322.09</menu_structure_item_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="64" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_structure"><menu_structure_obj>1000709323.09</menu_structure_obj>
<product_module_obj>0</product_module_obj>
<product_obj>0</product_obj>
<menu_structure_code>SimpleMenuBar</menu_structure_code>
<menu_structure_description>SimpleMenuBar</menu_structure_description>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_obj>0</menu_item_obj>
<menu_structure_type>MenuBar</menu_structure_type>
<menu_structure_hidden>no</menu_structure_hidden>
<control_spacing>0</control_spacing>
<control_padding>0</control_padding>
<menu_structure_narrative></menu_structure_narrative>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709323.09</menu_structure_obj>
<menu_item_sequence>1</menu_item_sequence>
<menu_item_obj>1000708213.09</menu_item_obj>
<child_menu_structure_obj>1000709153.09</child_menu_structure_obj>
<menu_structure_item_obj>1000709325.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709323.09</menu_structure_obj>
<menu_item_sequence>2</menu_item_sequence>
<menu_item_obj>1000708229.09</menu_item_obj>
<child_menu_structure_obj>1000708228.09</child_menu_structure_obj>
<menu_structure_item_obj>1000709326.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709323.09</menu_structure_obj>
<menu_item_sequence>3</menu_item_sequence>
<menu_item_obj>1000708221.09</menu_item_obj>
<child_menu_structure_obj>1000708224.09</child_menu_structure_obj>
<menu_structure_item_obj>1000709327.09</menu_structure_item_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="65" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_structure"><menu_structure_obj>1000709338.09</menu_structure_obj>
<product_module_obj>0</product_module_obj>
<product_obj>0</product_obj>
<menu_structure_code>TopToolOkCancel</menu_structure_code>
<menu_structure_description>TopToolOkCancel</menu_structure_description>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_obj>0</menu_item_obj>
<menu_structure_type>MenuBar</menu_structure_type>
<menu_structure_hidden>no</menu_structure_hidden>
<control_spacing>0</control_spacing>
<control_padding>0</control_padding>
<menu_structure_narrative></menu_structure_narrative>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709338.09</menu_structure_obj>
<menu_item_sequence>1</menu_item_sequence>
<menu_item_obj>1000708213.09</menu_item_obj>
<child_menu_structure_obj>1000709270.09</child_menu_structure_obj>
<menu_structure_item_obj>1000709340.09</menu_structure_item_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="66" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_structure"><menu_structure_obj>1000709341.09</menu_structure_obj>
<product_module_obj>0</product_module_obj>
<product_obj>0</product_obj>
<menu_structure_code>TopToolOkCancelNoNav</menu_structure_code>
<menu_structure_description>TopToolOkCancelNoNav</menu_structure_description>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_obj>0</menu_item_obj>
<menu_structure_type>MenuBar</menu_structure_type>
<menu_structure_hidden>no</menu_structure_hidden>
<control_spacing>0</control_spacing>
<control_padding>0</control_padding>
<menu_structure_narrative></menu_structure_narrative>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1000709341.09</menu_structure_obj>
<menu_item_sequence>1</menu_item_sequence>
<menu_item_obj>1000708213.09</menu_item_obj>
<child_menu_structure_obj>1000709155.09</child_menu_structure_obj>
<menu_structure_item_obj>1000709343.09</menu_structure_item_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="67" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_structure" version_date="09/26/2002" version_time="43664" version_user="admin" deletion_flag="no" entity_mnemonic="gsmms" key_field_value="1003576819" record_version_obj="3000031121.09" version_number_seq="1.09" secondary_key_value="RCYAG OPT" import_version_number_seq="1.09"><menu_structure_obj>1003576819</menu_structure_obj>
<product_module_obj>1004874679.09</product_module_obj>
<product_obj>1004874669.09</product_obj>
<menu_structure_code>RCYAG OPT</menu_structure_code>
<menu_structure_description>Attribute Group Options</menu_structure_description>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_obj>1003576820</menu_item_obj>
<menu_structure_type>SubMenu</menu_structure_type>
<menu_structure_hidden>no</menu_structure_hidden>
<control_spacing>0</control_spacing>
<control_padding>0</control_padding>
<menu_structure_narrative></menu_structure_narrative>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1003576819</menu_structure_obj>
<menu_item_sequence>2</menu_item_sequence>
<menu_item_obj>1003576821</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708036.09</menu_structure_item_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="68" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_structure" version_date="09/26/2002" version_time="43697" version_user="admin" deletion_flag="no" entity_mnemonic="gsmms" key_field_value="1003695948" record_version_obj="3000031125.09" version_number_seq="1.09" secondary_key_value="A2ObjTyp" import_version_number_seq="1.09"><menu_structure_obj>1003695948</menu_structure_obj>
<product_module_obj>1004874679.09</product_module_obj>
<product_obj>1004874669.09</product_obj>
<menu_structure_code>A2ObjTyp</menu_structure_code>
<menu_structure_description>Object Type Control</menu_structure_description>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_obj>1003576820</menu_item_obj>
<menu_structure_type>SubMenu</menu_structure_type>
<menu_structure_hidden>no</menu_structure_hidden>
<control_spacing>0</control_spacing>
<control_padding>0</control_padding>
<menu_structure_narrative></menu_structure_narrative>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1003695948</menu_structure_obj>
<menu_item_sequence>2</menu_item_sequence>
<menu_item_obj>1003765182</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708052.09</menu_structure_item_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="69" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_structure" version_date="03/24/2003" version_time="39245" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMS" key_field_value="1003764284" record_version_obj="2000041474.28" version_number_seq="27.09" secondary_key_value="A2Objects" import_version_number_seq="27.09"><menu_structure_obj>1003764284</menu_structure_obj>
<product_module_obj>1004874679.09</product_module_obj>
<product_obj>1004874669.09</product_obj>
<menu_structure_code>A2Objects</menu_structure_code>
<menu_structure_description>Smart Objects</menu_structure_description>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_obj>1003764285</menu_item_obj>
<menu_structure_type>SubMenu</menu_structure_type>
<menu_structure_hidden>no</menu_structure_hidden>
<control_spacing>0</control_spacing>
<control_padding>0</control_padding>
<menu_structure_narrative></menu_structure_narrative>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1003764284</menu_structure_obj>
<menu_item_sequence>1</menu_item_sequence>
<menu_item_obj>1003764286</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708054.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1003764284</menu_structure_obj>
<menu_item_sequence>2</menu_item_sequence>
<menu_item_obj>1003767061</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708056.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1003764284</menu_structure_obj>
<menu_item_sequence>3</menu_item_sequence>
<menu_item_obj>1003767455</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708057.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1003764284</menu_structure_obj>
<menu_item_sequence>4</menu_item_sequence>
<menu_item_obj>1003700174</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>11.48</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1003764284</menu_structure_obj>
<menu_item_sequence>5</menu_item_sequence>
<menu_item_obj>1000000924.48</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>13.48</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1003764284</menu_structure_obj>
<menu_item_sequence>6</menu_item_sequence>
<menu_item_obj>1003700174</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>8100000012146.18</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1003764284</menu_structure_obj>
<menu_item_sequence>7</menu_item_sequence>
<menu_item_obj>8100000012143.18</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>8100000012147.18</menu_structure_item_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="70" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_structure" version_date="09/26/2002" version_time="43671" version_user="admin" deletion_flag="no" entity_mnemonic="gsmms" key_field_value="1003764341" record_version_obj="3000031122.09" version_number_seq="1.09" secondary_key_value="A2Attrib" import_version_number_seq="1.09"><menu_structure_obj>1003764341</menu_structure_obj>
<product_module_obj>1004874683.09</product_module_obj>
<product_obj>1004874669.09</product_obj>
<menu_structure_code>A2Attrib</menu_structure_code>
<menu_structure_description>Attributes</menu_structure_description>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_obj>1003764342</menu_item_obj>
<menu_structure_type>SubMenu</menu_structure_type>
<menu_structure_hidden>no</menu_structure_hidden>
<control_spacing>0</control_spacing>
<control_padding>0</control_padding>
<menu_structure_narrative></menu_structure_narrative>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1003764341</menu_structure_obj>
<menu_item_sequence>1</menu_item_sequence>
<menu_item_obj>1003764344</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708058.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1003764341</menu_structure_obj>
<menu_item_sequence>2</menu_item_sequence>
<menu_item_obj>1003764377</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708060.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1003764341</menu_structure_obj>
<menu_item_sequence>3</menu_item_sequence>
<menu_item_obj>1003765394</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708061.09</menu_structure_item_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="71" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_structure" version_date="09/26/2002" version_time="43767" version_user="admin" deletion_flag="no" entity_mnemonic="gsmms" key_field_value="1004917040.09" record_version_obj="3000031130.09" version_number_seq="1.09" secondary_key_value="ICFAF-Tran" import_version_number_seq="1.09"><menu_structure_obj>1004917040.09</menu_structure_obj>
<product_module_obj>1004874679.09</product_module_obj>
<product_obj>1004874669.09</product_obj>
<menu_structure_code>ICFAF-Tran</menu_structure_code>
<menu_structure_description>Transaction Options</menu_structure_description>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_obj>1004919024.09</menu_item_obj>
<menu_structure_type>SubMenu</menu_structure_type>
<menu_structure_hidden>no</menu_structure_hidden>
<control_spacing>0</control_spacing>
<control_padding>0</control_padding>
<menu_structure_narrative></menu_structure_narrative>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1004917040.09</menu_structure_obj>
<menu_item_sequence>2</menu_item_sequence>
<menu_item_obj>1005080150.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708063.09</menu_structure_item_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="72" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_structure" version_date="09/26/2002" version_time="43703" version_user="admin" deletion_flag="no" entity_mnemonic="gsmms" key_field_value="1004917041.09" record_version_obj="3000031126.09" version_number_seq="1.09" secondary_key_value="ICFAF-Prnt" import_version_number_seq="1.09"><menu_structure_obj>1004917041.09</menu_structure_obj>
<product_module_obj>1004874679.09</product_module_obj>
<product_obj>1004874669.09</product_obj>
<menu_structure_code>ICFAF-Prnt</menu_structure_code>
<menu_structure_description>Print Options</menu_structure_description>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_obj>1004918450.09</menu_item_obj>
<menu_structure_type>SubMenu</menu_structure_type>
<menu_structure_hidden>no</menu_structure_hidden>
<control_spacing>0</control_spacing>
<control_padding>0</control_padding>
<menu_structure_narrative></menu_structure_narrative>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="73" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_structure" version_date="09/26/2002" version_time="43759" version_user="admin" deletion_flag="no" entity_mnemonic="gsmms" key_field_value="1004917042.09" record_version_obj="3000031129.09" version_number_seq="1.09" secondary_key_value="ICFAF-Syst" import_version_number_seq="1.09"><menu_structure_obj>1004917042.09</menu_structure_obj>
<product_module_obj>1004874679.09</product_module_obj>
<product_obj>1004874669.09</product_obj>
<menu_structure_code>ICFAF-Syst</menu_structure_code>
<menu_structure_description>System Options</menu_structure_description>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_obj>1004918454.09</menu_item_obj>
<menu_structure_type>SubMenu</menu_structure_type>
<menu_structure_hidden>no</menu_structure_hidden>
<control_spacing>0</control_spacing>
<control_padding>0</control_padding>
<menu_structure_narrative></menu_structure_narrative>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1004917042.09</menu_structure_obj>
<menu_item_sequence>1</menu_item_sequence>
<menu_item_obj>1007600009.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1007600016.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1004917042.09</menu_structure_obj>
<menu_item_sequence>2</menu_item_sequence>
<menu_item_obj>1004919032.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708065.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1004917042.09</menu_structure_obj>
<menu_item_sequence>3</menu_item_sequence>
<menu_item_obj>1004919033.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708066.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1004917042.09</menu_structure_obj>
<menu_item_sequence>4</menu_item_sequence>
<menu_item_obj>1004919035.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708067.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1004917042.09</menu_structure_obj>
<menu_item_sequence>5</menu_item_sequence>
<menu_item_obj>1004919037.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708069.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1004917042.09</menu_structure_obj>
<menu_item_sequence>6</menu_item_sequence>
<menu_item_obj>1004919036.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708068.09</menu_structure_item_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="74" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_structure" version_date="09/26/2002" version_time="43656" version_user="admin" deletion_flag="no" entity_mnemonic="gsmms" key_field_value="1004917044.09" record_version_obj="3000000000205.6893" version_number_seq="1.09" secondary_key_value="ICFAF-Appl" import_version_number_seq="1.09"><menu_structure_obj>1004917044.09</menu_structure_obj>
<product_module_obj>1004874679.09</product_module_obj>
<product_obj>1004874669.09</product_obj>
<menu_structure_code>ICFAF-Appl</menu_structure_code>
<menu_structure_description>Application Options</menu_structure_description>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_obj>1004918457.09</menu_item_obj>
<menu_structure_type>SubMenu</menu_structure_type>
<menu_structure_hidden>no</menu_structure_hidden>
<control_spacing>0</control_spacing>
<control_padding>0</control_padding>
<menu_structure_narrative></menu_structure_narrative>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1004917044.09</menu_structure_obj>
<menu_item_sequence>1</menu_item_sequence>
<menu_item_obj>1004918490.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>2000000126.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1004917044.09</menu_structure_obj>
<menu_item_sequence>2</menu_item_sequence>
<menu_item_obj>1004918497.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>2000000127.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1004917044.09</menu_structure_obj>
<menu_item_sequence>3</menu_item_sequence>
<menu_item_obj>1004918500.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>2000000128.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1004917044.09</menu_structure_obj>
<menu_item_sequence>4</menu_item_sequence>
<menu_item_obj>1004918462.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708076.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1004917044.09</menu_structure_obj>
<menu_item_sequence>5</menu_item_sequence>
<menu_item_obj>1004918463.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708075.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1004917044.09</menu_structure_obj>
<menu_item_sequence>6</menu_item_sequence>
<menu_item_obj>1004918464.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708077.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1004917044.09</menu_structure_obj>
<menu_item_sequence>7</menu_item_sequence>
<menu_item_obj>1004918487.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708079.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1004917044.09</menu_structure_obj>
<menu_item_sequence>8</menu_item_sequence>
<menu_item_obj>2000001159.28</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>2000001169.28</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1004917044.09</menu_structure_obj>
<menu_item_sequence>9</menu_item_sequence>
<menu_item_obj>1004918470.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708078.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1004917044.09</menu_structure_obj>
<menu_item_sequence>10</menu_item_sequence>
<menu_item_obj>3000000000203.6893</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>3000000000206.6893</menu_structure_item_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="75" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_structure" version_date="09/26/2002" version_time="43709" version_user="admin" deletion_flag="no" entity_mnemonic="gsmms" key_field_value="1004917045.09" record_version_obj="3000031127.09" version_number_seq="1.09" secondary_key_value="ICFAF-Secu" import_version_number_seq="1.09"><menu_structure_obj>1004917045.09</menu_structure_obj>
<product_module_obj>1004874679.09</product_module_obj>
<product_obj>1004874669.09</product_obj>
<menu_structure_code>ICFAF-Secu</menu_structure_code>
<menu_structure_description>Security Options</menu_structure_description>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_obj>1004918452.09</menu_item_obj>
<menu_structure_type>SubMenu</menu_structure_type>
<menu_structure_hidden>no</menu_structure_hidden>
<control_spacing>0</control_spacing>
<control_padding>0</control_padding>
<menu_structure_narrative></menu_structure_narrative>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1004917045.09</menu_structure_obj>
<menu_item_sequence>2</menu_item_sequence>
<menu_item_obj>1004918504.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708081.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1004917045.09</menu_structure_obj>
<menu_item_sequence>3</menu_item_sequence>
<menu_item_obj>1004918505.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708082.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1004917045.09</menu_structure_obj>
<menu_item_sequence>4</menu_item_sequence>
<menu_item_obj>1004918857.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708083.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1004917045.09</menu_structure_obj>
<menu_item_sequence>5</menu_item_sequence>
<menu_item_obj>1004918858.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708084.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1004917045.09</menu_structure_obj>
<menu_item_sequence>6</menu_item_sequence>
<menu_item_obj>1004918859.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708085.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1004917045.09</menu_structure_obj>
<menu_item_sequence>7</menu_item_sequence>
<menu_item_obj>1004918860.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708086.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1004917045.09</menu_structure_obj>
<menu_item_sequence>8</menu_item_sequence>
<menu_item_obj>1004918861.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708087.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1004917045.09</menu_structure_obj>
<menu_item_sequence>9</menu_item_sequence>
<menu_item_obj>1004919030.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708088.09</menu_structure_item_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="76" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_structure" version_date="09/26/2002" version_time="43716" version_user="admin" deletion_flag="no" entity_mnemonic="gsmms" key_field_value="1004918242.09" record_version_obj="3000031128.09" version_number_seq="1.09" secondary_key_value="ICFAF-Sesn" import_version_number_seq="1.09"><menu_structure_obj>1004918242.09</menu_structure_obj>
<product_module_obj>1004874679.09</product_module_obj>
<product_obj>1004874669.09</product_obj>
<menu_structure_code>ICFAF-Sesn</menu_structure_code>
<menu_structure_description>Session Options</menu_structure_description>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_obj>1004918453.09</menu_item_obj>
<menu_structure_type>SubMenu</menu_structure_type>
<menu_structure_hidden>no</menu_structure_hidden>
<control_spacing>0</control_spacing>
<control_padding>0</control_padding>
<menu_structure_narrative></menu_structure_narrative>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1004918242.09</menu_structure_obj>
<menu_item_sequence>1</menu_item_sequence>
<menu_item_obj>1004918863.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708089.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1004918242.09</menu_structure_obj>
<menu_item_sequence>2</menu_item_sequence>
<menu_item_obj>1004918881.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708090.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1004918242.09</menu_structure_obj>
<menu_item_sequence>3</menu_item_sequence>
<menu_item_obj>1004918886.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708091.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1004918242.09</menu_structure_obj>
<menu_item_sequence>4</menu_item_sequence>
<menu_item_obj>1004919021.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708092.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1004918242.09</menu_structure_obj>
<menu_item_sequence>5</menu_item_sequence>
<menu_item_obj>1004919027.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708093.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1004918242.09</menu_structure_obj>
<menu_item_sequence>6</menu_item_sequence>
<menu_item_obj>1004919028.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708094.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1004918242.09</menu_structure_obj>
<menu_item_sequence>7</menu_item_sequence>
<menu_item_obj>1004919029.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708095.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1004918242.09</menu_structure_obj>
<menu_item_sequence>8</menu_item_sequence>
<menu_item_obj>1000000806.28</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000000815.28</menu_structure_item_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="77" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_structure"><menu_structure_obj>1004928875.09</menu_structure_obj>
<product_module_obj>1004874679.09</product_module_obj>
<product_obj>1004874669.09</product_obj>
<menu_structure_code>GSTRV OPT</menu_structure_code>
<menu_structure_description>Record Version Option</menu_structure_description>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_obj>1004928876.09</menu_item_obj>
<menu_structure_type>SubMenu</menu_structure_type>
<menu_structure_hidden>no</menu_structure_hidden>
<control_spacing>0</control_spacing>
<control_padding>0</control_padding>
<menu_structure_narrative></menu_structure_narrative>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1004928875.09</menu_structure_obj>
<menu_item_sequence>2</menu_item_sequence>
<menu_item_obj>1004928877.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708096.09</menu_structure_item_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="78" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_structure" version_date="03/27/2003" version_time="58635" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMS" key_field_value="1004935509.09" record_version_obj="30000000001006.6893" version_number_seq="28.24" secondary_key_value="ICFAF-Depl" import_version_number_seq="28.24"><menu_structure_obj>1004935509.09</menu_structure_obj>
<product_module_obj>1004874679.09</product_module_obj>
<product_obj>1004874669.09</product_obj>
<menu_structure_code>ICFAF-Depl</menu_structure_code>
<menu_structure_description>Deployment Options</menu_structure_description>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_obj>1004935510.09</menu_item_obj>
<menu_structure_type>SubMenu</menu_structure_type>
<menu_structure_hidden>no</menu_structure_hidden>
<control_spacing>0</control_spacing>
<control_padding>0</control_padding>
<menu_structure_narrative></menu_structure_narrative>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1004935509.09</menu_structure_obj>
<menu_item_sequence>1</menu_item_sequence>
<menu_item_obj>1004935511.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708097.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1004935509.09</menu_structure_obj>
<menu_item_sequence>2</menu_item_sequence>
<menu_item_obj>1003700174</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>-1294967285.91</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1004935509.09</menu_structure_obj>
<menu_item_sequence>3</menu_item_sequence>
<menu_item_obj>1007600013.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1007600017.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1004935509.09</menu_structure_obj>
<menu_item_sequence>4</menu_item_sequence>
<menu_item_obj>1007600014.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1007600018.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1004935509.09</menu_structure_obj>
<menu_item_sequence>5</menu_item_sequence>
<menu_item_obj>300002.24</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>300006.24</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1004935509.09</menu_structure_obj>
<menu_item_sequence>6</menu_item_sequence>
<menu_item_obj>1003700174</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>30000000001007.6893</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1004935509.09</menu_structure_obj>
<menu_item_sequence>7</menu_item_sequence>
<menu_item_obj>30000000001004.6893</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>30000000001008.6893</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1004935509.09</menu_structure_obj>
<menu_item_sequence>8</menu_item_sequence>
<menu_item_obj>30000000001141.6893</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>30000000001143.6893</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1004935509.09</menu_structure_obj>
<menu_item_sequence>9</menu_item_sequence>
<menu_item_obj>1000000174.5566</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000000176.5566</menu_structure_item_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="79" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_structure"><menu_structure_obj>1004956226.09</menu_structure_obj>
<product_module_obj>1004874683.09</product_module_obj>
<product_obj>1004874669.09</product_obj>
<menu_structure_code>GSMSE-Opt</menu_structure_code>
<menu_structure_description>Session Type Options</menu_structure_description>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_obj>1004956227.09</menu_item_obj>
<menu_structure_type>SubMenu</menu_structure_type>
<menu_structure_hidden>no</menu_structure_hidden>
<control_spacing>0</control_spacing>
<control_padding>0</control_padding>
<menu_structure_narrative></menu_structure_narrative>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1004956226.09</menu_structure_obj>
<menu_item_sequence>2</menu_item_sequence>
<menu_item_obj>1004956228.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708098.09</menu_structure_item_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="80" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_structure" version_date="09/26/2002" version_time="43796" version_user="admin" deletion_flag="no" entity_mnemonic="gsmms" key_field_value="1005016815" record_version_obj="3000000062.09" version_number_seq="11.09" secondary_key_value="A2VSetup" import_version_number_seq="11.09"><menu_structure_obj>1005016815</menu_structure_obj>
<product_module_obj>1004874679.09</product_module_obj>
<product_obj>1004874669.09</product_obj>
<menu_structure_code>A2VSetup</menu_structure_code>
<menu_structure_description>Versioning Setup</menu_structure_description>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_obj>1005016817</menu_item_obj>
<menu_structure_type>SubMenu</menu_structure_type>
<menu_structure_hidden>no</menu_structure_hidden>
<control_spacing>0</control_spacing>
<control_padding>0</control_padding>
<menu_structure_narrative></menu_structure_narrative>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="81" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_structure" version_date="09/26/2002" version_time="43787" version_user="admin" deletion_flag="no" entity_mnemonic="gsmms" key_field_value="1005016816" record_version_obj="3000000063.09" version_number_seq="2.09" secondary_key_value="A2VMaint" import_version_number_seq="2.09"><menu_structure_obj>1005016816</menu_structure_obj>
<product_module_obj>1004874679.09</product_module_obj>
<product_obj>1004874669.09</product_obj>
<menu_structure_code>A2VMaint</menu_structure_code>
<menu_structure_description>Versioning Maintenance</menu_structure_description>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_obj>1005016818</menu_item_obj>
<menu_structure_type>SubMenu</menu_structure_type>
<menu_structure_hidden>no</menu_structure_hidden>
<control_spacing>0</control_spacing>
<control_padding>0</control_padding>
<menu_structure_narrative></menu_structure_narrative>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="82" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_structure" version_date="09/26/2002" version_time="43775" version_user="admin" deletion_flag="no" entity_mnemonic="gsmms" key_field_value="1005100064.101" record_version_obj="3000031131.09" version_number_seq="1.09" secondary_key_value="A2TreeWiz" import_version_number_seq="1.09"><menu_structure_obj>1005100064.101</menu_structure_obj>
<product_module_obj>1004874679.09</product_module_obj>
<product_obj>1004874669.09</product_obj>
<menu_structure_code>A2TreeWiz</menu_structure_code>
<menu_structure_description>TreeView Wizard</menu_structure_description>
<disabled>no</disabled>
<system_owned>no</system_owned>
<under_development>no</under_development>
<menu_item_obj>1003576820</menu_item_obj>
<menu_structure_type>SubMenu</menu_structure_type>
<menu_structure_hidden>no</menu_structure_hidden>
<control_spacing>0</control_spacing>
<control_padding>0</control_padding>
<menu_structure_narrative></menu_structure_narrative>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1005100064.101</menu_structure_obj>
<menu_item_sequence>1</menu_item_sequence>
<menu_item_obj>1005100066.101</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1000708102.09</menu_structure_item_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="83" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_structure"><menu_structure_obj>1007500265.09</menu_structure_obj>
<product_module_obj>0</product_module_obj>
<product_obj>0</product_obj>
<menu_structure_code>FileTableIOUpd</menu_structure_code>
<menu_structure_description>File tableio Update/Cancel</menu_structure_description>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_obj>1000708213.09</menu_item_obj>
<menu_structure_type>Submenu</menu_structure_type>
<menu_structure_hidden>no</menu_structure_hidden>
<control_spacing>0</control_spacing>
<control_padding>0</control_padding>
<menu_structure_narrative></menu_structure_narrative>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1007500265.09</menu_structure_obj>
<menu_item_sequence>1</menu_item_sequence>
<menu_item_obj>1000708104.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1007500272.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1007500265.09</menu_structure_obj>
<menu_item_sequence>2</menu_item_sequence>
<menu_item_obj>1000708105.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1007500273.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1007500265.09</menu_structure_obj>
<menu_item_sequence>3</menu_item_sequence>
<menu_item_obj>1000708106.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1007500274.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1007500265.09</menu_structure_obj>
<menu_item_sequence>4</menu_item_sequence>
<menu_item_obj>1000708107.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1007500275.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1007500265.09</menu_structure_obj>
<menu_item_sequence>5</menu_item_sequence>
<menu_item_obj>1003700174</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1007500276.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1007500265.09</menu_structure_obj>
<menu_item_sequence>6</menu_item_sequence>
<menu_item_obj>1000708108.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1007500277.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1007500265.09</menu_structure_obj>
<menu_item_sequence>7</menu_item_sequence>
<menu_item_obj>1000708109.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1007500278.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1007500265.09</menu_structure_obj>
<menu_item_sequence>8</menu_item_sequence>
<menu_item_obj>1000708110.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1007500279.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1007500265.09</menu_structure_obj>
<menu_item_sequence>9</menu_item_sequence>
<menu_item_obj>1003700174</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1007500280.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1007500265.09</menu_structure_obj>
<menu_item_sequence>10</menu_item_sequence>
<menu_item_obj>1000708111.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1007500287.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1007500265.09</menu_structure_obj>
<menu_item_sequence>11</menu_item_sequence>
<menu_item_obj>1000708112.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1007500295.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1007500265.09</menu_structure_obj>
<menu_item_sequence>12</menu_item_sequence>
<menu_item_obj>1003700174</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1007500288.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1007500265.09</menu_structure_obj>
<menu_item_sequence>13</menu_item_sequence>
<menu_item_obj>1000708117.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1007500281.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1007500265.09</menu_structure_obj>
<menu_item_sequence>14</menu_item_sequence>
<menu_item_obj>1003700174</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1007500282.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1007500265.09</menu_structure_obj>
<menu_item_sequence>15</menu_item_sequence>
<menu_item_obj>1000708103.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1007500289.09</menu_structure_item_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="84" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_structure"><menu_structure_obj>1007500266.09</menu_structure_obj>
<product_module_obj>0</product_module_obj>
<product_obj>0</product_obj>
<menu_structure_code>DynToolbar</menu_structure_code>
<menu_structure_description>Dyntoolbar menubar</menu_structure_description>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_obj>0</menu_item_obj>
<menu_structure_type>Menubar</menu_structure_type>
<menu_structure_hidden>no</menu_structure_hidden>
<control_spacing>0</control_spacing>
<control_padding>0</control_padding>
<menu_structure_narrative></menu_structure_narrative>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1007500266.09</menu_structure_obj>
<menu_item_sequence>1</menu_item_sequence>
<menu_item_obj>1000708213.09</menu_item_obj>
<child_menu_structure_obj>1007500265.09</child_menu_structure_obj>
<menu_structure_item_obj>1007500267.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1007500266.09</menu_structure_obj>
<menu_item_sequence>2</menu_item_sequence>
<menu_item_obj>1000708216.09</menu_item_obj>
<child_menu_structure_obj>1000708215.09</child_menu_structure_obj>
<menu_structure_item_obj>1007500269.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1007500266.09</menu_structure_obj>
<menu_item_sequence>3</menu_item_sequence>
<menu_item_obj>1000708229.09</menu_item_obj>
<child_menu_structure_obj>1000708228.09</child_menu_structure_obj>
<menu_structure_item_obj>10.66</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1007500266.09</menu_structure_obj>
<menu_item_sequence>4</menu_item_sequence>
<menu_item_obj>1000708221.09</menu_item_obj>
<child_menu_structure_obj>1000708224.09</child_menu_structure_obj>
<menu_structure_item_obj>11.66</menu_structure_item_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="85" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_structure"><menu_structure_obj>1007500335.09</menu_structure_obj>
<product_module_obj>0</product_module_obj>
<product_obj>0</product_obj>
<menu_structure_code>Filterbar</menu_structure_code>
<menu_structure_description>Filter toolbar</menu_structure_description>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_obj>0</menu_item_obj>
<menu_structure_type>Menubar</menu_structure_type>
<menu_structure_hidden>no</menu_structure_hidden>
<control_spacing>0</control_spacing>
<control_padding>0</control_padding>
<menu_structure_narrative></menu_structure_narrative>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1007500335.09</menu_structure_obj>
<menu_item_sequence>1</menu_item_sequence>
<menu_item_obj>1000708213.09</menu_item_obj>
<child_menu_structure_obj>1000709153.09</child_menu_structure_obj>
<menu_structure_item_obj>1007500336.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1007500335.09</menu_structure_obj>
<menu_item_sequence>2</menu_item_sequence>
<menu_item_obj>1000708229.09</menu_item_obj>
<child_menu_structure_obj>1000708228.09</child_menu_structure_obj>
<menu_structure_item_obj>1007500337.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1007500335.09</menu_structure_obj>
<menu_item_sequence>3</menu_item_sequence>
<menu_item_obj>1000708221.09</menu_item_obj>
<child_menu_structure_obj>1000708224.09</child_menu_structure_obj>
<menu_structure_item_obj>1007500338.09</menu_structure_item_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="86" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_structure" version_date="09/26/2002" version_time="43679" version_user="admin" deletion_flag="no" entity_mnemonic="gsmms" key_field_value="1007600020.09" record_version_obj="3000031123.09" version_number_seq="1.09" secondary_key_value="ICFAFBuild" import_version_number_seq="1.09"><menu_structure_obj>1007600020.09</menu_structure_obj>
<product_module_obj>0</product_module_obj>
<product_obj>1004874669.09</product_obj>
<menu_structure_code>ICFAFBuild</menu_structure_code>
<menu_structure_description>Build</menu_structure_description>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_obj>1007600001.09</menu_item_obj>
<menu_structure_type>Submenu</menu_structure_type>
<menu_structure_hidden>no</menu_structure_hidden>
<control_spacing>0</control_spacing>
<control_padding>0</control_padding>
<menu_structure_narrative></menu_structure_narrative>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1007600020.09</menu_structure_obj>
<menu_item_sequence>1</menu_item_sequence>
<menu_item_obj>1007600002.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1007600023.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1007600020.09</menu_structure_obj>
<menu_item_sequence>2</menu_item_sequence>
<menu_item_obj>1007600005.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1007600024.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1007600020.09</menu_structure_obj>
<menu_item_sequence>3</menu_item_sequence>
<menu_item_obj>1004918500.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1007600026.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1007600020.09</menu_structure_obj>
<menu_item_sequence>4</menu_item_sequence>
<menu_item_obj>1007600007.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1007600025.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1007600020.09</menu_structure_obj>
<menu_item_sequence>5</menu_item_sequence>
<menu_item_obj>4651.24</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>4652.24</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1007600020.09</menu_structure_obj>
<menu_item_sequence>6</menu_item_sequence>
<menu_item_obj>1003700174</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>2000000106.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1007600020.09</menu_structure_obj>
<menu_item_sequence>7</menu_item_sequence>
<menu_item_obj>1005100206.101</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>2000000105.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1007600020.09</menu_structure_obj>
<menu_item_sequence>8</menu_item_sequence>
<menu_item_obj>1005099733.101</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1007600027.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1007600020.09</menu_structure_obj>
<menu_item_sequence>9</menu_item_sequence>
<menu_item_obj>1003700174</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>2000000107.09</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>1007600020.09</menu_structure_obj>
<menu_item_sequence>10</menu_item_sequence>
<menu_item_obj>1007600009.09</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>1007600028.09</menu_structure_item_obj>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="87" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_menu_structure" version_date="03/17/2003" version_time="41319" version_user="admin" deletion_flag="no" entity_mnemonic="GSMMS" key_field_value="725000000742.5566" record_version_obj="725000000743.5566" version_number_seq="1.09" secondary_key_value="cbProcedures" import_version_number_seq="1.09"><menu_structure_obj>725000000742.5566</menu_structure_obj>
<product_module_obj>0</product_module_obj>
<product_obj>0</product_obj>
<menu_structure_code>cbProcedures</menu_structure_code>
<menu_structure_description>CBuilder Procedure Features</menu_structure_description>
<disabled>no</disabled>
<system_owned>yes</system_owned>
<under_development>no</under_development>
<menu_item_obj>0</menu_item_obj>
<menu_structure_type>Menu&amp;Toolbar</menu_structure_type>
<menu_structure_hidden>no</menu_structure_hidden>
<control_spacing>0</control_spacing>
<control_padding>0</control_padding>
<menu_structure_narrative>This band will contain procedure related actions for the Container Builder, such as to generate DataLogicProcedures for SBOs, to edit them or to edit Custom SmartObjects (Super Procedures) for containers</menu_structure_narrative>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>725000000742.5566</menu_structure_obj>
<menu_item_sequence>1</menu_item_sequence>
<menu_item_obj>725000000744.5566</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>725000000747.5566</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>725000000742.5566</menu_structure_obj>
<menu_item_sequence>2</menu_item_sequence>
<menu_item_obj>1003700174</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>725000000748.5566</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>725000000742.5566</menu_structure_obj>
<menu_item_sequence>3</menu_item_sequence>
<menu_item_obj>725000000749.5566</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>725000000752.5566</menu_structure_item_obj>
</contained_record>
<contained_record DB="icfdb" Table="gsm_menu_structure_item"><menu_structure_obj>725000000742.5566</menu_structure_obj>
<menu_item_sequence>4</menu_item_sequence>
<menu_item_obj>725000000753.5566</menu_item_obj>
<child_menu_structure_obj>0</child_menu_structure_obj>
<menu_structure_item_obj>725000000756.5566</menu_structure_item_obj>
</contained_record>
</contained_record>
</dataset_transaction>
</dataset_records>
</dataset>