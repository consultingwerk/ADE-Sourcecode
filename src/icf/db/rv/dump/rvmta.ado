<?xml version="1.0" encoding="ISO8859-1" ?>
<dataset Transactions="164"><dataset_header DisableRI="yes" DatasetObj="1000000148.39" DateFormat="mdy" FullHeader="yes" SCMManaged="no" YearOffset="1950" DatasetCode="RVMTA" DateCreated="02/14/2002" TimeCreated="11:19:58" NumericFormat="AMERICAN" NumericDecimal="." OriginatingSite="93" NumericSeparator=","><deploy_dataset_obj>1000000148.39</deploy_dataset_obj>
<owner_site_code></owner_site_code>
<dataset_code>RVMTA</dataset_code>
<dataset_description>rvm_task</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<dataset_entity><dataset_entity_obj>1000000150.39</dataset_entity_obj>
<deploy_dataset_obj>1000000148.39</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>RVMTA</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>task_number</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>no</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<entity_mnemonic_description>rvm_task</entity_mnemonic_description>
<entity_dbname>rvdb</entity_dbname>
</dataset_entity>
<table_definition><name>rvm_task</name>
<dbname>RVDB</dbname>
<index-1>XIE1rvm_task,0,0,0,current_test_area,0,current_test_status,0,task_priority,0,test_status_date,0</index-1>
<index-2>XIE2rvm_task,0,0,0,fix_for_task_number,0</index-2>
<index-3>XIE3rvm_task,0,0,0,test_status_user,0,current_test_area,0,current_test_status,0,task_priority,0,test_status_date,0</index-3>
<index-4>XIE4rvm_task,0,0,0,task_manager,0,current_test_area,0,current_test_status,0,task_priority,0,test_status_date,0</index-4>
<index-5>XIE5rvm_task,0,0,0,task_programmer,0,current_test_area,0,current_test_status,0,task_priority,0,test_status_date,0</index-5>
<index-6>XIE6rvm_task,0,0,0,task_user_reference,0,task_entered_date,0</index-6>
<index-7>XIE7rvm_task,0,0,0,task_summary,0</index-7>
<index-8>XIE8rvm_task,0,0,0,task_obj,0</index-8>
<index-9>XIE9rvm_task,0,0,0,task_workspace,0,current_test_area,0,current_test_status,0</index-9>
<index-10>XPKrvm_task,1,1,0,task_number,0</index-10>
<field><name>task_number</name>
<data-type>integer</data-type>
<extent>0</extent>
<format>->>>>>>>9</format>
<initial>        0</initial>
<label>Task Number</label>
<column-label>Task Number</column-label>
</field>
<field><name>task_workspace</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(15)</format>
<initial></initial>
<label>Task Workspace</label>
<column-label>Task Workspace</column-label>
</field>
<field><name>task_manager</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(15)</format>
<initial></initial>
<label>Task Manager</label>
<column-label>Task Manager</column-label>
</field>
<field><name>task_programmer</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(15)</format>
<initial></initial>
<label>Task Programmer</label>
<column-label>Task Programmer</column-label>
</field>
<field><name>task_status</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(3)</format>
<initial></initial>
<label>Task Status</label>
<column-label>Task Status</column-label>
</field>
<field><name>task_entered_date</name>
<data-type>date</data-type>
<extent>0</extent>
<format>99/99/9999</format>
<initial>02/14/2002</initial>
<label>%Include("%DiagramProp("RootDir")af/erw/aferlabel.i")</label>
<column-label>Task Entered Date</column-label>
</field>
<field><name>task_completed_date</name>
<data-type>date</data-type>
<extent>0</extent>
<format>99/99/9999</format>
<initial></initial>
<label>%Include("%DiagramProp("RootDir")af/erw/aferlabel.i")</label>
<column-label>Task Completed Date</column-label>
</field>
<field><name>task_user_reference</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(15)</format>
<initial></initial>
<label>Task User Reference</label>
<column-label>Task User Reference</column-label>
</field>
<field><name>task_summary</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Task Summary</label>
<column-label>Task Summary</column-label>
</field>
<field><name>task_description</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(3000)</format>
<initial></initial>
<label>Task Description</label>
<column-label>Task Description</column-label>
</field>
<field><name>task_priority</name>
<data-type>integer</data-type>
<extent>0</extent>
<format>->9</format>
<initial>  0</initial>
<label>Task Priority</label>
<column-label>Task Priority</column-label>
</field>
<field><name>fix_for_task_number</name>
<data-type>integer</data-type>
<extent>0</extent>
<format>->>>>>>>9</format>
<initial>        0</initial>
<label>Fix For Task Number</label>
<column-label>Fix For Task Number</column-label>
</field>
<field><name>estimated_hrs</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>->>>,>>9.99</format>
<initial>       0.00</initial>
<label>Estimated Hrs</label>
<column-label>Estimated Hrs</column-label>
</field>
<field><name>actual_hrs</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>->>>,>>9.99</format>
<initial>       0.00</initial>
<label>Actual Hrs</label>
<column-label>Actual Hrs</column-label>
</field>
<field><name>current_test_area</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(15)</format>
<initial></initial>
<label>Current Test Area</label>
<column-label>Current Test Area</column-label>
</field>
<field><name>current_test_status</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(10)</format>
<initial></initial>
<label>Current Test Status</label>
<column-label>Current Test Status</column-label>
</field>
<field><name>test_status_date</name>
<data-type>date</data-type>
<extent>0</extent>
<format>99/99/9999</format>
<initial>02/14/2002</initial>
<label>%Include("%DiagramProp("RootDir")af/erw/aferlabel.i")</label>
<column-label>Test Status Date</column-label>
</field>
<field><name>test_status_user</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(15)</format>
<initial></initial>
<label>Test Status User</label>
<column-label>Test Status User</column-label>
</field>
<field><name>task_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>>>>>>>>>>>>>>>>>>9.999999999</format>
<initial>                 0.000000000</initial>
<label>Task Obj</label>
<column-label>Task Obj</column-label>
</field>
</table_definition>
</dataset_header>
<dataset_records><dataset_transaction TransactionNo="1"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000001</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Anthony</task_manager>
<task_programmer>Anthony</task_programmer>
<task_status>C</task_status>
<task_entered_date>03/29/01</task_entered_date>
<task_completed_date>03/29/01</task_completed_date>
<task_user_reference>Astra</task_user_reference>
<task_summary>Initial load of Astra DBs into ICF project</task_summary>
<task_description>Initial load of Astra DBs into ICF project</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>03/29/01</test_status_date>
<test_status_user>anthony</test_status_user>
<task_obj>1004873305.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="2"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000002</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Anthony</task_manager>
<task_programmer>Anthony</task_programmer>
<task_status>C</task_status>
<task_entered_date>03/29/01</task_entered_date>
<task_completed_date>03/29/01</task_completed_date>
<task_user_reference>Astra</task_user_reference>
<task_summary>Initial load of Astra code into ICF</task_summary>
<task_description>Initial load of Astra code into ICF</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>03/29/01</test_status_date>
<test_status_user>anthony</test_status_user>
<task_obj>1004873339.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="3"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000003</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Anthony</task_manager>
<task_programmer>Anthony</task_programmer>
<task_status>C</task_status>
<task_entered_date>03/29/01</task_entered_date>
<task_completed_date>03/29/01</task_completed_date>
<task_user_reference></task_user_reference>
<task_summary>Initial load RV into ICF project</task_summary>
<task_description>Initial load RV into ICF project</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>03/29/01</test_status_date>
<test_status_user>anthony</test_status_user>
<task_obj>1004873371.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="4"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000004</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Anthony</task_manager>
<task_programmer>Anthony</task_programmer>
<task_status>C</task_status>
<task_entered_date>03/29/01</task_entered_date>
<task_completed_date>03/29/01</task_completed_date>
<task_user_reference></task_user_reference>
<task_summary>Register ASDB database</task_summary>
<task_description>Register ASDB database</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>03/29/01</test_status_date>
<test_status_user>anthony</test_status_user>
<task_obj>1004874293.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="5"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000005</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Anthony</task_manager>
<task_programmer>Anthony</task_programmer>
<task_status>C</task_status>
<task_entered_date>03/29/01</task_entered_date>
<task_completed_date>03/29/01</task_completed_date>
<task_user_reference></task_user_reference>
<task_summary>Register RYDB Database</task_summary>
<task_description>Register RYDB Database</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>03/29/01</test_status_date>
<test_status_user>anthony</test_status_user>
<task_obj>1004874661.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="6"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000006</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Anthony</task_manager>
<task_programmer>Anthony</task_programmer>
<task_status>C</task_status>
<task_entered_date>03/29/01</task_entered_date>
<task_completed_date>03/29/01</task_completed_date>
<task_user_reference></task_user_reference>
<task_summary>Register RVDB Database</task_summary>
<task_description>Register RVDB Database</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>03/29/01</test_status_date>
<test_status_user>anthony</test_status_user>
<task_obj>1004874664.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="7"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000007</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Anthony</task_manager>
<task_programmer>Anthony</task_programmer>
<task_status>C</task_status>
<task_entered_date>03/29/01</task_entered_date>
<task_completed_date>03/29/01</task_completed_date>
<task_user_reference></task_user_reference>
<task_summary>Fix afrtbevntp.p to turn on rv system</task_summary>
<task_description>Fix afrtbevntp.p to turn on rv system</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>03/29/01</test_status_date>
<test_status_user>anthony</test_status_user>
<task_obj>1004874667.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="8"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000008</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Bruce</task_manager>
<task_programmer>Bruce</task_programmer>
<task_status>C</task_status>
<task_entered_date>03/29/01</task_entered_date>
<task_completed_date>03/29/01</task_completed_date>
<task_user_reference></task_user_reference>
<task_summary>Complete gsc_object maintenance suite</task_summary>
<task_description>Complete gsc_object maintenance suite</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>03/29/01</test_status_date>
<test_status_user>bruce</test_status_user>
<task_obj>1004882246.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="9"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000009</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Anthony</task_manager>
<task_programmer>Tammy</task_programmer>
<task_status>C</task_status>
<task_entered_date>03/30/01</task_entered_date>
<task_completed_date>03/30/01</task_completed_date>
<task_user_reference>posse</task_user_reference>
<task_summary>Reference Maintenance</task_summary>
<task_description>Reference Maintenance</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>03/30/01</test_status_date>
<test_status_user>tammy</test_status_user>
<task_obj>1004882603.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="10"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000010</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Anthony</task_manager>
<task_programmer>Phil</task_programmer>
<task_status>W</task_status>
<task_entered_date>03/31/01</task_entered_date>
<task_completed_date>?</task_completed_date>
<task_user_reference>POSSE</task_user_reference>
<task_summary>User Maintenance</task_summary>
<task_description>User Maintenance program</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>1-OPN</current_test_status>
<test_status_date>03/31/01</test_status_date>
<test_status_user>phil</test_status_user>
<task_obj>1004882833.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="11"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000011</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Phil</task_manager>
<task_programmer>Anthony</task_programmer>
<task_status>W</task_status>
<task_entered_date>03/31/01</task_entered_date>
<task_completed_date>?</task_completed_date>
<task_user_reference>POSSE</task_user_reference>
<task_summary>Security Allocations</task_summary>
<task_description>Security Allocations</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>1-OPN</current_test_status>
<test_status_date>03/31/01</test_status_date>
<test_status_user>phil</test_status_user>
<task_obj>1004882835.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="12"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000012</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Anthony</task_manager>
<task_programmer>Tammy</task_programmer>
<task_status>C</task_status>
<task_entered_date>03/30/01</task_entered_date>
<task_completed_date>03/30/01</task_completed_date>
<task_user_reference>posse</task_user_reference>
<task_summary>Reference Maintenance</task_summary>
<task_description>Reference Maintenance</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>03/30/01</test_status_date>
<test_status_user>tammy</test_status_user>
<task_obj>1004883207.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="13"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000014</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Anthony</task_manager>
<task_programmer>Tammy</task_programmer>
<task_status>C</task_status>
<task_entered_date>03/30/01</task_entered_date>
<task_completed_date>03/30/01</task_completed_date>
<task_user_reference>posse</task_user_reference>
<task_summary>Sequence Maintenance</task_summary>
<task_description>Sequence Maintenance</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>03/30/01</test_status_date>
<test_status_user>tammy</test_status_user>
<task_obj>1004883331.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="14"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000015</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Anthony</task_manager>
<task_programmer>Tammy</task_programmer>
<task_status>C</task_status>
<task_entered_date>03/30/01</task_entered_date>
<task_completed_date>04/02/01</task_completed_date>
<task_user_reference>posse</task_user_reference>
<task_summary>Product Maintenance</task_summary>
<task_description>Product Maintenance</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>04/02/01</test_status_date>
<test_status_user>tammy</test_status_user>
<task_obj>1004883433.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="15"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000016</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Bruce</task_manager>
<task_programmer>Bruce</task_programmer>
<task_status>C</task_status>
<task_entered_date>03/31/01</task_entered_date>
<task_completed_date>03/31/01</task_completed_date>
<task_user_reference></task_user_reference>
<task_summary>Fix compilations problems for Unix</task_summary>
<task_description>Fix compilations problems for Unix</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>03/31/01</test_status_date>
<test_status_user>Bruce</test_status_user>
<task_obj>1004884126.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="16"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000017</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Bruce</task_manager>
<task_programmer>Bruce</task_programmer>
<task_status>C</task_status>
<task_entered_date>04/01/01</task_entered_date>
<task_completed_date>04/01/01</task_completed_date>
<task_user_reference></task_user_reference>
<task_summary>Test Task</task_summary>
<task_description>Test Task</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>04/01/01</test_status_date>
<test_status_user>Bruce</test_status_user>
<task_obj>1004884188.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="17"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000018</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>John</task_manager>
<task_programmer>Bruce</task_programmer>
<task_status>C</task_status>
<task_entered_date>04/01/01</task_entered_date>
<task_completed_date>04/05/01</task_completed_date>
<task_user_reference></task_user_reference>
<task_summary>Complete Object Maintenance</task_summary>
<task_description>Complete Object Maintenance</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>04/05/01</test_status_date>
<test_status_user>Bruce</test_status_user>
<task_obj>1004884237.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="18"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000019</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Anthony</task_manager>
<task_programmer>Tammy</task_programmer>
<task_status>C</task_status>
<task_entered_date>04/02/01</task_entered_date>
<task_completed_date>04/02/01</task_completed_date>
<task_user_reference>posse</task_user_reference>
<task_summary>Instance Attribute Maintenance</task_summary>
<task_description>Instance Attribute Maintenance</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>04/02/01</test_status_date>
<test_status_user>tammy</test_status_user>
<task_obj>1004886498.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="19"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000020</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Anthony</task_manager>
<task_programmer>Tammy</task_programmer>
<task_status>C</task_status>
<task_entered_date>04/02/01</task_entered_date>
<task_completed_date>04/24/01</task_completed_date>
<task_user_reference>posse</task_user_reference>
<task_summary>Entity Mnemonic Maintenance</task_summary>
<task_description>Entity Mnemonic Maintenance</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>04/24/01</test_status_date>
<test_status_user>tammy</test_status_user>
<task_obj>1004887717.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="20"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000021</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Anthony</task_manager>
<task_programmer>Tammy</task_programmer>
<task_status>C</task_status>
<task_entered_date>04/04/01</task_entered_date>
<task_completed_date>04/04/01</task_completed_date>
<task_user_reference>posse</task_user_reference>
<task_summary>Site Maintenance</task_summary>
<task_description>Site Maintenance</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>04/04/01</test_status_date>
<test_status_user>tammy</test_status_user>
<task_obj>1004893452.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="21"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000022</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Anthony</task_manager>
<task_programmer>Tammy</task_programmer>
<task_status>C</task_status>
<task_entered_date>04/04/01</task_entered_date>
<task_completed_date>04/05/01</task_completed_date>
<task_user_reference>posse</task_user_reference>
<task_summary>Profile Type Maintenance</task_summary>
<task_description>Profile Type Maintenance</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>04/05/01</test_status_date>
<test_status_user>tammy</test_status_user>
<task_obj>1004894544.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="22"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000023</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>John</task_manager>
<task_programmer>Bruce</task_programmer>
<task_status>C</task_status>
<task_entered_date>04/05/01</task_entered_date>
<task_completed_date>04/11/01</task_completed_date>
<task_user_reference></task_user_reference>
<task_summary>Complete Menu Maintenance</task_summary>
<task_description>Complete Menu Maintenance</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>04/11/01</test_status_date>
<test_status_user>Bruce</test_status_user>
<task_obj>1004895534.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="23"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000024</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Anthony</task_manager>
<task_programmer>Tammy</task_programmer>
<task_status>C</task_status>
<task_entered_date>04/06/01</task_entered_date>
<task_completed_date>04/06/01</task_completed_date>
<task_user_reference>posse</task_user_reference>
<task_summary>Profile Type Maintenance</task_summary>
<task_description>Profile Type Maintenance</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>04/06/01</test_status_date>
<test_status_user>tammy</test_status_user>
<task_obj>1004897827.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="24"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000025</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Anthony</task_manager>
<task_programmer>Tammy</task_programmer>
<task_status>C</task_status>
<task_entered_date>04/06/01</task_entered_date>
<task_completed_date>04/06/01</task_completed_date>
<task_user_reference>posse</task_user_reference>
<task_summary>Complete Category Maintenance</task_summary>
<task_description>Complete Category Maintenance</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>04/06/01</test_status_date>
<test_status_user>tammy</test_status_user>
<task_obj>1004897966.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="25"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000026</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Anthony</task_manager>
<task_programmer>Tammy</task_programmer>
<task_status>C</task_status>
<task_entered_date>04/10/01</task_entered_date>
<task_completed_date>04/17/01</task_completed_date>
<task_user_reference>posse</task_user_reference>
<task_summary>Session Manager Maintenance</task_summary>
<task_description>Session Manager Maintenance</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>04/17/01</test_status_date>
<test_status_user>tammy</test_status_user>
<task_obj>1004898154.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="26"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000027</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>John</task_manager>
<task_programmer>Bruce</task_programmer>
<task_status>C</task_status>
<task_entered_date>04/11/01</task_entered_date>
<task_completed_date>05/11/01</task_completed_date>
<task_user_reference></task_user_reference>
<task_summary>Configuration File parser</task_summary>
<task_description>Configuration File parser</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>05/11/01</test_status_date>
<test_status_user>Bruce</test_status_user>
<task_obj>1004902734.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="27"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000028</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Anthony</task_manager>
<task_programmer>Bruce</task_programmer>
<task_status>C</task_status>
<task_entered_date>04/17/01</task_entered_date>
<task_completed_date>04/17/01</task_completed_date>
<task_user_reference></task_user_reference>
<task_summary>ASDB Session Property Schema enhancements</task_summary>
<task_description>ASDB Session Property Schema enhancements</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>04/17/01</test_status_date>
<test_status_user>bruce</test_status_user>
<task_obj>1004910187.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="28"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000029</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Anthony</task_manager>
<task_programmer>Bruce</task_programmer>
<task_status>C</task_status>
<task_entered_date>04/17/01</task_entered_date>
<task_completed_date>04/17/01</task_completed_date>
<task_user_reference></task_user_reference>
<task_summary>ASDB Session Property trigger load</task_summary>
<task_description>ASDB Session Property trigger load</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>04/17/01</test_status_date>
<test_status_user>bruce</test_status_user>
<task_obj>1004910189.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="29"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000030</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Anthony</task_manager>
<task_programmer>Phil</task_programmer>
<task_status>W</task_status>
<task_entered_date>04/17/01</task_entered_date>
<task_completed_date>?</task_completed_date>
<task_user_reference>POSSE</task_user_reference>
<task_summary>SDO Business Logic Procedure</task_summary>
<task_description>SDO Business Logic Procedure</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>1-OPN</current_test_status>
<test_status_date>04/17/01</test_status_date>
<test_status_user>phil</test_status_user>
<task_obj>1004910203.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="30"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000031</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>John</task_manager>
<task_programmer>Bruce</task_programmer>
<task_status>C</task_status>
<task_entered_date>04/17/01</task_entered_date>
<task_completed_date>04/17/01</task_completed_date>
<task_user_reference></task_user_reference>
<task_summary>Add menus to objects</task_summary>
<task_description>Add menus to objects</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>04/17/01</test_status_date>
<test_status_user>Bruce</test_status_user>
<task_obj>1004910242.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="31"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000032</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Anthony</task_manager>
<task_programmer>Bruce</task_programmer>
<task_status>C</task_status>
<task_entered_date>04/17/01</task_entered_date>
<task_completed_date>04/17/01</task_completed_date>
<task_user_reference></task_user_reference>
<task_summary>Fix Object Folder Window</task_summary>
<task_description>Fix Object Folder Window</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>04/17/01</test_status_date>
<test_status_user>Bruce</test_status_user>
<task_obj>1004912823.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="32"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000033</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Phil</task_manager>
<task_programmer>Phil</task_programmer>
<task_status>W</task_status>
<task_entered_date>04/18/01</task_entered_date>
<task_completed_date>?</task_completed_date>
<task_user_reference>POSSE</task_user_reference>
<task_summary>Logic Procedure Auto-Generation</task_summary>
<task_description>Logic Procedure Auto-Generation</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>1-OPN</current_test_status>
<test_status_date>04/18/01</test_status_date>
<test_status_user>phil</test_status_user>
<task_obj>1004912827.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="33"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000034</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Anthony</task_manager>
<task_programmer>Anthony</task_programmer>
<task_status>C</task_status>
<task_entered_date>04/17/01</task_entered_date>
<task_completed_date>04/18/01</task_completed_date>
<task_user_reference></task_user_reference>
<task_summary>Fix module for object type maintenance</task_summary>
<task_description>Fix module for object type maintenance</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>04/18/01</test_status_date>
<test_status_user>anthony</test_status_user>
<task_obj>1004913468.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="34"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000035</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Anthony</task_manager>
<task_programmer>Tammy</task_programmer>
<task_status>C</task_status>
<task_entered_date>04/17/01</task_entered_date>
<task_completed_date>04/18/01</task_completed_date>
<task_user_reference>posse</task_user_reference>
<task_summary>Complete Session Property Maintenance</task_summary>
<task_description>Complete Session Property Maintenance</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>04/18/01</test_status_date>
<test_status_user>tammy</test_status_user>
<task_obj>1004916062.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="35"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000036</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Bruce</task_manager>
<task_programmer>Bruce</task_programmer>
<task_status>C</task_status>
<task_entered_date>04/18/01</task_entered_date>
<task_completed_date>04/18/01</task_completed_date>
<task_user_reference></task_user_reference>
<task_summary>Fix menu maintenance bugs</task_summary>
<task_description>Fix menu maintenance bugs</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>04/18/01</test_status_date>
<test_status_user>Bruce</test_status_user>
<task_obj>1004917050.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="36"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000037</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Anthony</task_manager>
<task_programmer>Tammy</task_programmer>
<task_status>C</task_status>
<task_entered_date>04/18/01</task_entered_date>
<task_completed_date>04/19/01</task_completed_date>
<task_user_reference>posse</task_user_reference>
<task_summary>Complete Session Type Maintenance</task_summary>
<task_description>Complete Session Type Maintenance</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>04/19/01</test_status_date>
<test_status_user>tammy</test_status_user>
<task_obj>1004917244.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="37"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000038</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Anthony</task_manager>
<task_programmer>Anthony</task_programmer>
<task_status>C</task_status>
<task_entered_date>04/18/01</task_entered_date>
<task_completed_date>04/20/01</task_completed_date>
<task_user_reference></task_user_reference>
<task_summary>Fix Object Menu Structure Allocation</task_summary>
<task_description>Fix Object Menu Structure Allocation</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>04/20/01</test_status_date>
<test_status_user>anthony</test_status_user>
<task_obj>1004918207.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="38"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000040</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Anthony</task_manager>
<task_programmer>Tammy</task_programmer>
<task_status>C</task_status>
<task_entered_date>04/19/01</task_entered_date>
<task_completed_date>04/19/01</task_completed_date>
<task_user_reference>posse</task_user_reference>
<task_summary>Complete Service Type Maintenance</task_summary>
<task_description>Complete Service Type Maintenance</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>04/19/01</test_status_date>
<test_status_user>tammy</test_status_user>
<task_obj>1004918848.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="39"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000041</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Anthony</task_manager>
<task_programmer>Ross</task_programmer>
<task_status>C</task_status>
<task_entered_date>04/19/01</task_entered_date>
<task_completed_date>04/20/01</task_completed_date>
<task_user_reference></task_user_reference>
<task_summary>Reduce dependacies on _obj numbers</task_summary>
<task_description>Reduce dependacies on _obj numbers</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>04/20/01</test_status_date>
<test_status_user>ross</test_status_user>
<task_obj>1004918882.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="40"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000042</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Anthony</task_manager>
<task_programmer>Tammy</task_programmer>
<task_status>C</task_status>
<task_entered_date>04/19/01</task_entered_date>
<task_completed_date>04/19/01</task_completed_date>
<task_user_reference>posse</task_user_reference>
<task_summary>Complete Logical Service Maintenance</task_summary>
<task_description>Complete Logical Service Maintenance</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>04/19/01</test_status_date>
<test_status_user>tammy</test_status_user>
<task_obj>1004918988.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="41"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000043</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Anthony</task_manager>
<task_programmer>Tammy</task_programmer>
<task_status>C</task_status>
<task_entered_date>04/19/01</task_entered_date>
<task_completed_date>04/20/01</task_completed_date>
<task_user_reference>posse</task_user_reference>
<task_summary>Complete Physical Service Maintenance</task_summary>
<task_description>Complete</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>04/20/01</test_status_date>
<test_status_user>tammy</test_status_user>
<task_obj>1004919012.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="42"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000044</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Anthony</task_manager>
<task_programmer>Anthony</task_programmer>
<task_status>C</task_status>
<task_entered_date>04/19/01</task_entered_date>
<task_completed_date>04/20/01</task_completed_date>
<task_user_reference></task_user_reference>
<task_summary>Rename some references from Astra to ICF</task_summary>
<task_description>Rename some references from Astra to ICF</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>04/20/01</test_status_date>
<test_status_user>anthony</test_status_user>
<task_obj>1004919041.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="43"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000045</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Phil</task_manager>
<task_programmer>Phil</task_programmer>
<task_status>W</task_status>
<task_entered_date>04/21/01</task_entered_date>
<task_completed_date>?</task_completed_date>
<task_user_reference>POSSE</task_user_reference>
<task_summary>Security Manager Logic</task_summary>
<task_description>Security Manager Logic</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>1-OPN</current_test_status>
<test_status_date>04/21/01</test_status_date>
<test_status_user>phil</test_status_user>
<task_obj>1004919945.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="44"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000046</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Ross</task_manager>
<task_programmer>Ross</task_programmer>
<task_status>C</task_status>
<task_entered_date>04/20/01</task_entered_date>
<task_completed_date>04/20/01</task_completed_date>
<task_user_reference></task_user_reference>
<task_summary>Fix the getEntityObj function</task_summary>
<task_description>The current algorithm is incorrect and needs to be fixed.</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>04/20/01</test_status_date>
<test_status_user>ross</test_status_user>
<task_obj>1004919947.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="45"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000048</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Ross</task_manager>
<task_programmer>Ross</task_programmer>
<task_status>C</task_status>
<task_entered_date>04/20/01</task_entered_date>
<task_completed_date>04/20/01</task_completed_date>
<task_user_reference></task_user_reference>
<task_summary>Spell gsgetenmnp.p correctly</task_summary>
<task_description>Spell gsgetenmnp.p correctly in afgenmngrp.i</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>04/20/01</test_status_date>
<test_status_user>ross</test_status_user>
<task_obj>1004920101.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="46"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000049</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Ross</task_manager>
<task_programmer>Ross</task_programmer>
<task_status>C</task_status>
<task_entered_date>04/20/01</task_entered_date>
<task_completed_date>04/20/01</task_completed_date>
<task_user_reference></task_user_reference>
<task_summary>Remove _obj naming dependacies</task_summary>
<task_description>Remove _obj naming dependacies</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>04/20/01</test_status_date>
<test_status_user>ross</test_status_user>
<task_obj>1004920189.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="47"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000050</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Ross</task_manager>
<task_programmer>Ross</task_programmer>
<task_status>C</task_status>
<task_entered_date>04/20/01</task_entered_date>
<task_completed_date>04/20/01</task_completed_date>
<task_user_reference></task_user_reference>
<task_summary>Fix compile error in afgensrvrp.p</task_summary>
<task_description>Fix compile error in afgensrvrp.p</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>04/20/01</test_status_date>
<test_status_user>ross</test_status_user>
<task_obj>1004920247.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="48"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000051</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Bruce</task_manager>
<task_programmer>Bruce</task_programmer>
<task_status>C</task_status>
<task_entered_date>04/23/01</task_entered_date>
<task_completed_date>04/24/01</task_completed_date>
<task_user_reference></task_user_reference>
<task_summary>Update RoundTable AppServer Integration</task_summary>
<task_description>Update RoundTable AppServer Integration</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>04/24/01</test_status_date>
<test_status_user>Bruce</test_status_user>
<task_obj>1004920359.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="49"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000052</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Phil</task_manager>
<task_programmer>Phil</task_programmer>
<task_status>C</task_status>
<task_entered_date>04/24/01</task_entered_date>
<task_completed_date>05/26/01</task_completed_date>
<task_user_reference>POSSE</task_user_reference>
<task_summary>Respository Object Maintenance</task_summary>
<task_description>Respository Object Maintenance</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>05/26/01</test_status_date>
<test_status_user>phil</test_status_user>
<task_obj>1004920391.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="50"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000053</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Anthony</task_manager>
<task_programmer>Tammy</task_programmer>
<task_status>C</task_status>
<task_entered_date>04/24/01</task_entered_date>
<task_completed_date>04/25/01</task_completed_date>
<task_user_reference>IZ867</task_user_reference>
<task_summary>IZ867 Error Control Bug Fixing</task_summary>
<task_description>Error Control Bug Fixing</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>04/25/01</test_status_date>
<test_status_user>tammy</test_status_user>
<task_obj>1004922798.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="51"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000054</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Anthony</task_manager>
<task_programmer>Tammy</task_programmer>
<task_status>C</task_status>
<task_entered_date>04/24/01</task_entered_date>
<task_completed_date>04/24/01</task_completed_date>
<task_user_reference>IZ878</task_user_reference>
<task_summary>IZ878 Session Service focus bug fix</task_summary>
<task_description>Service Type Bug Fixing</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>04/24/01</test_status_date>
<test_status_user>tammy</test_status_user>
<task_obj>1004922838.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="52"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000055</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Anthony</task_manager>
<task_programmer>Tammy</task_programmer>
<task_status>C</task_status>
<task_entered_date>04/24/01</task_entered_date>
<task_completed_date>04/24/01</task_completed_date>
<task_user_reference>IZ882</task_user_reference>
<task_summary>IZ882 Translation Maintenance Bug Fixes</task_summary>
<task_description>IZ882 Translation Maintenance Bug Fixes</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>04/24/01</test_status_date>
<test_status_user>tammy</test_status_user>
<task_obj>1004922863.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="53"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000056</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Anthony</task_manager>
<task_programmer>Tammy</task_programmer>
<task_status>C</task_status>
<task_entered_date>04/24/01</task_entered_date>
<task_completed_date>04/24/01</task_completed_date>
<task_user_reference>IZ883</task_user_reference>
<task_summary>IZ883 Language Maintenance Bug Fix</task_summary>
<task_description>IZ883 Language Maintenance Bug Fix</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>04/24/01</test_status_date>
<test_status_user>tammy</test_status_user>
<task_obj>1004922922.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="54"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000057</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Anthony</task_manager>
<task_programmer>Tammy</task_programmer>
<task_status>C</task_status>
<task_entered_date>04/24/01</task_entered_date>
<task_completed_date>04/24/01</task_completed_date>
<task_user_reference>IZ885</task_user_reference>
<task_summary>IZ885 Category Maintenance Bug Fixes</task_summary>
<task_description>IZ885 Category Maintenance Bug Fixes</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>04/24/01</test_status_date>
<test_status_user>tammy</test_status_user>
<task_obj>1004923011.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="55"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000059</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Anthony</task_manager>
<task_programmer>Tammy</task_programmer>
<task_status>C</task_status>
<task_entered_date>04/24/01</task_entered_date>
<task_completed_date>04/24/01</task_completed_date>
<task_user_reference>IZ886</task_user_reference>
<task_summary>IZ886 Status Maintenance Bug Fix</task_summary>
<task_description>IZ886 Status Maintenance Bug Fix</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>04/24/01</test_status_date>
<test_status_user>tammy</test_status_user>
<task_obj>1004923056.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="56"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000060</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Anthony</task_manager>
<task_programmer>Tammy</task_programmer>
<task_status>C</task_status>
<task_entered_date>04/24/01</task_entered_date>
<task_completed_date>04/24/01</task_completed_date>
<task_user_reference>IZ887</task_user_reference>
<task_summary>IZ887 Multi Media Type Bug Fixes</task_summary>
<task_description>IZ887 Multi Media Type Bug Fixes</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>04/24/01</test_status_date>
<test_status_user>tammy</test_status_user>
<task_obj>1004923407.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="57"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000061</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Anthony</task_manager>
<task_programmer>Tammy</task_programmer>
<task_status>C</task_status>
<task_entered_date>04/24/01</task_entered_date>
<task_completed_date>04/24/01</task_completed_date>
<task_user_reference>IZ888</task_user_reference>
<task_summary>IZ888 Product Control Bug Fixes</task_summary>
<task_description>IZ888 Product Control Bug Fixes</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>04/24/01</test_status_date>
<test_status_user>tammy</test_status_user>
<task_obj>1004923734.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="58"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000062</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Anthony</task_manager>
<task_programmer>Tammy</task_programmer>
<task_status>C</task_status>
<task_entered_date>04/24/01</task_entered_date>
<task_completed_date>04/24/01</task_completed_date>
<task_user_reference>IZ889</task_user_reference>
<task_summary>IZ889 Instance Attribute Control Bug Fixes</task_summary>
<task_description>IZ889 Instance Attribute Control Bug Fixes</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>04/24/01</test_status_date>
<test_status_user>tammy</test_status_user>
<task_obj>1004923746.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="59"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000063</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Anthony</task_manager>
<task_programmer>Tammy</task_programmer>
<task_status>C</task_status>
<task_entered_date>04/24/01</task_entered_date>
<task_completed_date>04/24/01</task_completed_date>
<task_user_reference>IZ893</task_user_reference>
<task_summary>IZ893 Login Company Maintenance Bug Fix</task_summary>
<task_description>IZ893 Login Company Maintenance Bug Fix</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>04/24/01</test_status_date>
<test_status_user>tammy</test_status_user>
<task_obj>1004923815.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="60"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000064</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Anthony</task_manager>
<task_programmer>Tammy</task_programmer>
<task_status>C</task_status>
<task_entered_date>04/24/01</task_entered_date>
<task_completed_date>04/25/01</task_completed_date>
<task_user_reference>IZ894</task_user_reference>
<task_summary>IZ894 Fix window and folder titles</task_summary>
<task_description>IZ894 Fix window and folder titles</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>04/25/01</test_status_date>
<test_status_user>tammy</test_status_user>
<task_obj>1004923896.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="61"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000065</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Anthony</task_manager>
<task_programmer>Tammy</task_programmer>
<task_status>C</task_status>
<task_entered_date>04/24/01</task_entered_date>
<task_completed_date>04/24/01</task_completed_date>
<task_user_reference>posse</task_user_reference>
<task_summary>Complete Entity Mnemonic Import</task_summary>
<task_description>Complete Entity Mnemonic Import</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>04/24/01</test_status_date>
<test_status_user>tammy</test_status_user>
<task_obj>1004924154.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="62"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000066</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Anthony</task_manager>
<task_programmer>Tammy</task_programmer>
<task_status>C</task_status>
<task_entered_date>04/24/01</task_entered_date>
<task_completed_date>04/24/01</task_completed_date>
<task_user_reference>posse</task_user_reference>
<task_summary>Session Service Bug Fix</task_summary>
<task_description>Session Service Bug Fix</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>04/24/01</test_status_date>
<test_status_user>tammy</test_status_user>
<task_obj>1004924162.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="63"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000067</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Anthony</task_manager>
<task_programmer>Anthony</task_programmer>
<task_status>C</task_status>
<task_entered_date>04/24/01</task_entered_date>
<task_completed_date>04/29/01</task_completed_date>
<task_user_reference></task_user_reference>
<task_summary>Remove RTB dependancy</task_summary>
<task_description>Remove RTB dependancy, so code does not break if RTB not connected / in use.</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>04/29/01</test_status_date>
<test_status_user>anthony</test_status_user>
<task_obj>1004924181.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="64"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000068</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Anthony</task_manager>
<task_programmer>Tammy</task_programmer>
<task_status>C</task_status>
<task_entered_date>04/25/01</task_entered_date>
<task_completed_date>04/25/01</task_completed_date>
<task_user_reference>posse</task_user_reference>
<task_summary>Complete Entity Mnemonic Import</task_summary>
<task_description>Complete Entity Mnemonic Import</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>04/25/01</test_status_date>
<test_status_user>tammy</test_status_user>
<task_obj>1004924252.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="65"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000069</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Anthony</task_manager>
<task_programmer>Tammy</task_programmer>
<task_status>C</task_status>
<task_entered_date>04/25/01</task_entered_date>
<task_completed_date>04/26/01</task_completed_date>
<task_user_reference>IZ939</task_user_reference>
<task_summary>IZ939 Physical Service maintenance add bug</task_summary>
<task_description>IZ939 Physical Service maintenance add bug</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>04/26/01</test_status_date>
<test_status_user>tammy</test_status_user>
<task_obj>1004925753.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="66"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000070</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Bruce</task_manager>
<task_programmer>Bruce</task_programmer>
<task_status>C</task_status>
<task_entered_date>04/26/01</task_entered_date>
<task_completed_date>04/26/01</task_completed_date>
<task_user_reference></task_user_reference>
<task_summary>Workaround to fix afstartupp.p for QA environment</task_summary>
<task_description>Workaround to fix afstartupp.p for QA environment</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>04/26/01</test_status_date>
<test_status_user>Bruce</test_status_user>
<task_obj>1004926318.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="67"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000071</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Anthony</task_manager>
<task_programmer>Tammy</task_programmer>
<task_status>C</task_status>
<task_entered_date>04/26/01</task_entered_date>
<task_completed_date>04/26/01</task_completed_date>
<task_user_reference>posse</task_user_reference>
<task_summary>Add root directory to workspace maintenance</task_summary>
<task_description>Add root directory to workspace maintenance</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>04/26/01</test_status_date>
<test_status_user>tammy</test_status_user>
<task_obj>1004926547.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="68"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000072</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Anthony</task_manager>
<task_programmer>Tammy</task_programmer>
<task_status>C</task_status>
<task_entered_date>04/26/01</task_entered_date>
<task_completed_date>04/26/01</task_completed_date>
<task_user_reference>posse</task_user_reference>
<task_summary>Add fields to security control</task_summary>
<task_description>Add fields to security control</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>04/26/01</test_status_date>
<test_status_user>tammy</test_status_user>
<task_obj>1004926862.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="69"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000073</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Anthony</task_manager>
<task_programmer>Tammy</task_programmer>
<task_status>C</task_status>
<task_entered_date>04/26/01</task_entered_date>
<task_completed_date>04/27/01</task_completed_date>
<task_user_reference>posse</task_user_reference>
<task_summary>Entity Mnemonic changes/record version maintenance</task_summary>
<task_description>Entity Mnemonic changes/record version maintenance</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>04/27/01</test_status_date>
<test_status_user>tammy</test_status_user>
<task_obj>1004926869.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="70"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000074</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Bruce</task_manager>
<task_programmer>Bruce</task_programmer>
<task_status>C</task_status>
<task_entered_date>04/26/01</task_entered_date>
<task_completed_date>04/26/01</task_completed_date>
<task_user_reference></task_user_reference>
<task_summary>Import schema changes for ASDB</task_summary>
<task_description>Import schema changes for ASDB</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>04/26/01</test_status_date>
<test_status_user>Bruce</test_status_user>
<task_obj>1004926871.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="71"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000075</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Bruce</task_manager>
<task_programmer>Bruce</task_programmer>
<task_status>C</task_status>
<task_entered_date>04/26/01</task_entered_date>
<task_completed_date>04/26/01</task_completed_date>
<task_user_reference></task_user_reference>
<task_summary>Import Schema Changes for AFDB</task_summary>
<task_description>Import Schema Changes for AFDB</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>04/26/01</test_status_date>
<test_status_user>Bruce</test_status_user>
<task_obj>1004926873.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="72"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000076</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Bruce</task_manager>
<task_programmer>Bruce</task_programmer>
<task_status>C</task_status>
<task_entered_date>04/26/01</task_entered_date>
<task_completed_date>04/26/01</task_completed_date>
<task_user_reference></task_user_reference>
<task_summary>Import Schema Changes for RVDB</task_summary>
<task_description>Import Schema Changes for RVDB</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>04/26/01</test_status_date>
<test_status_user>Bruce</test_status_user>
<task_obj>1004926876.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="73"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000077</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Bruce</task_manager>
<task_programmer>Bruce</task_programmer>
<task_status>C</task_status>
<task_entered_date>04/26/01</task_entered_date>
<task_completed_date>04/26/01</task_completed_date>
<task_user_reference></task_user_reference>
<task_summary>Import Schema Changes for ASDB</task_summary>
<task_description>Import Schema Changes for ASDB</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>04/26/01</test_status_date>
<test_status_user>Bruce</test_status_user>
<task_obj>1004926878.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="74"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000078</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Bruce</task_manager>
<task_programmer>Bruce</task_programmer>
<task_status>C</task_status>
<task_entered_date>04/26/01</task_entered_date>
<task_completed_date>04/26/01</task_completed_date>
<task_user_reference></task_user_reference>
<task_summary>Import Triggers for ASDB</task_summary>
<task_description>Import Triggers for ASDB</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>04/26/01</test_status_date>
<test_status_user>Bruce</test_status_user>
<task_obj>1004926880.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="75"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000079</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Bruce</task_manager>
<task_programmer>Bruce</task_programmer>
<task_status>C</task_status>
<task_entered_date>04/26/01</task_entered_date>
<task_completed_date>04/26/01</task_completed_date>
<task_user_reference></task_user_reference>
<task_summary>Import Triggers for AFDB</task_summary>
<task_description>Import Triggers for AFDB</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>04/26/01</test_status_date>
<test_status_user>Bruce</test_status_user>
<task_obj>1004926882.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="76"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000080</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Bruce</task_manager>
<task_programmer>Bruce</task_programmer>
<task_status>C</task_status>
<task_entered_date>04/26/01</task_entered_date>
<task_completed_date>04/26/01</task_completed_date>
<task_user_reference></task_user_reference>
<task_summary>Import Triggers for RVDB</task_summary>
<task_description>Import Triggers for RVDB</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>04/26/01</test_status_date>
<test_status_user>Bruce</test_status_user>
<task_obj>1004926884.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="77"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000081</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Bruce</task_manager>
<task_programmer>Bruce</task_programmer>
<task_status>C</task_status>
<task_entered_date>04/26/01</task_entered_date>
<task_completed_date>04/26/01</task_completed_date>
<task_user_reference></task_user_reference>
<task_summary>Import Triggers and DFs for RYDB</task_summary>
<task_description>Import Triggers and DFs for RYDB</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>04/26/01</test_status_date>
<test_status_user>Bruce</test_status_user>
<task_obj>1004927526.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="78"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000082</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Bruce</task_manager>
<task_programmer>Bruce</task_programmer>
<task_status>C</task_status>
<task_entered_date>04/26/01</task_entered_date>
<task_completed_date>04/26/01</task_completed_date>
<task_user_reference></task_user_reference>
<task_summary>Synch Up DB Version</task_summary>
<task_description>Synch Up DB Version</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>04/26/01</test_status_date>
<test_status_user>Bruce</test_status_user>
<task_obj>1004927681.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="79"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000083</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Anthony</task_manager>
<task_programmer>Bruce</task_programmer>
<task_status>C</task_status>
<task_entered_date>04/27/01</task_entered_date>
<task_completed_date>05/16/01</task_completed_date>
<task_user_reference></task_user_reference>
<task_summary>Create Dataset Export Utility</task_summary>
<task_description>Create Dataset Export Utility</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>05/16/01</test_status_date>
<test_status_user>Bruce</test_status_user>
<task_obj>1004928541.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="80"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000084</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Anthony</task_manager>
<task_programmer>Tammy</task_programmer>
<task_status>C</task_status>
<task_entered_date>04/27/01</task_entered_date>
<task_completed_date>04/27/01</task_completed_date>
<task_user_reference>posse</task_user_reference>
<task_summary>Added site type to site maintenance</task_summary>
<task_description>Added site type to site maintenance</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>04/27/01</test_status_date>
<test_status_user>tammy</test_status_user>
<task_obj>1004928549.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="81"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000085</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Anthony</task_manager>
<task_programmer>Tammy</task_programmer>
<task_status>C</task_status>
<task_entered_date>04/27/01</task_entered_date>
<task_completed_date>04/28/01</task_completed_date>
<task_user_reference>posse</task_user_reference>
<task_summary>Deploy Dataset Maintenance</task_summary>
<task_description>Deploy Dataset Maintenance</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>04/28/01</test_status_date>
<test_status_user>tammy</test_status_user>
<task_obj>1004928864.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="82"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000086</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Anthony</task_manager>
<task_programmer>Anthony</task_programmer>
<task_status>C</task_status>
<task_entered_date>04/27/01</task_entered_date>
<task_completed_date>04/27/01</task_completed_date>
<task_user_reference></task_user_reference>
<task_summary>Fix menu controller</task_summary>
<task_description>Fix menu controller</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>04/27/01</test_status_date>
<test_status_user>anthony</test_status_user>
<task_obj>1004929770.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="83"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000087</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Anthony</task_manager>
<task_programmer>Haavard</task_programmer>
<task_status>C</task_status>
<task_entered_date>04/27/01</task_entered_date>
<task_completed_date>05/01/01</task_completed_date>
<task_user_reference>POSSE</task_user_reference>
<task_summary>Dynamic Browse</task_summary>
<task_description>Changed to support adm2 browser.p defaultAction</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>05/01/01</test_status_date>
<test_status_user>haavard</test_status_user>
<task_obj>1004930392.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="84"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000088</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Bruce</task_manager>
<task_programmer>Bruce</task_programmer>
<task_status>C</task_status>
<task_entered_date>04/29/01</task_entered_date>
<task_completed_date>04/29/01</task_completed_date>
<task_user_reference></task_user_reference>
<task_summary>Import schema changes ASDB</task_summary>
<task_description>Import schema changes ASDB</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>04/29/01</test_status_date>
<test_status_user>Bruce</test_status_user>
<task_obj>1004932607.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="85"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000089</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Bruce</task_manager>
<task_programmer>Bruce</task_programmer>
<task_status>C</task_status>
<task_entered_date>04/29/01</task_entered_date>
<task_completed_date>04/29/01</task_completed_date>
<task_user_reference></task_user_reference>
<task_summary>Import new schema triggers</task_summary>
<task_description>Import new schema triggers</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>04/29/01</test_status_date>
<test_status_user>Bruce</test_status_user>
<task_obj>1004932609.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="86"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000090</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Anthony</task_manager>
<task_programmer>Tammy</task_programmer>
<task_status>W</task_status>
<task_entered_date>04/29/01</task_entered_date>
<task_completed_date>?</task_completed_date>
<task_user_reference>posse</task_user_reference>
<task_summary>Complete Deploy Dataset Maintenance</task_summary>
<task_description>Complete Deploy Dataset Maintenance</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>1-OPN</current_test_status>
<test_status_date>04/29/01</test_status_date>
<test_status_user>tammy</test_status_user>
<task_obj>1004933195.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="87"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000091</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Anthony</task_manager>
<task_programmer>Tammy</task_programmer>
<task_status>W</task_status>
<task_entered_date>04/29/01</task_entered_date>
<task_completed_date>?</task_completed_date>
<task_user_reference>IZ892</task_user_reference>
<task_summary>IZ892 Menu Maintenance Bug Fixes</task_summary>
<task_description>IZ892 Menu Maintenance Bug Fixes</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>1-OPN</current_test_status>
<test_status_date>04/29/01</test_status_date>
<test_status_user>tammy</test_status_user>
<task_obj>1004934805.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="88"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000092</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Anthony</task_manager>
<task_programmer>Anthony</task_programmer>
<task_status>C</task_status>
<task_entered_date>04/29/01</task_entered_date>
<task_completed_date>04/29/01</task_completed_date>
<task_user_reference></task_user_reference>
<task_summary>Register schema changes</task_summary>
<task_description>Register schema changes</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>04/29/01</test_status_date>
<test_status_user>anthony</test_status_user>
<task_obj>1004934822.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="89"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000093</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Anthony</task_manager>
<task_programmer>Anthony</task_programmer>
<task_status>C</task_status>
<task_entered_date>04/29/01</task_entered_date>
<task_completed_date>04/29/01</task_completed_date>
<task_user_reference></task_user_reference>
<task_summary>Register schema changes</task_summary>
<task_description>Register schema changes</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>04/29/01</test_status_date>
<test_status_user>anthony</test_status_user>
<task_obj>1004934825.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="90"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000094</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Anthony</task_manager>
<task_programmer>Anthony</task_programmer>
<task_status>C</task_status>
<task_entered_date>04/29/01</task_entered_date>
<task_completed_date>04/29/01</task_completed_date>
<task_user_reference></task_user_reference>
<task_summary>Register schema changes</task_summary>
<task_description>Register schema changes</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>04/29/01</test_status_date>
<test_status_user>anthony</test_status_user>
<task_obj>1004934828.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="91"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000095</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Anthony</task_manager>
<task_programmer>Anthony</task_programmer>
<task_status>C</task_status>
<task_entered_date>04/29/01</task_entered_date>
<task_completed_date>04/29/01</task_completed_date>
<task_user_reference></task_user_reference>
<task_summary>Register schema changes</task_summary>
<task_description>Register schema changes</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>04/29/01</test_status_date>
<test_status_user>anthony</test_status_user>
<task_obj>1004934831.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="92"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000096</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Anthony</task_manager>
<task_programmer>Anthony</task_programmer>
<task_status>C</task_status>
<task_entered_date>04/29/01</task_entered_date>
<task_completed_date>04/29/01</task_completed_date>
<task_user_reference></task_user_reference>
<task_summary>Register trigger changes</task_summary>
<task_description>Register trigger changes</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>04/29/01</test_status_date>
<test_status_user>anthony</test_status_user>
<task_obj>1004934834.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="93"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000097</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Anthony</task_manager>
<task_programmer>Anthony</task_programmer>
<task_status>W</task_status>
<task_entered_date>04/29/01</task_entered_date>
<task_completed_date>?</task_completed_date>
<task_user_reference></task_user_reference>
<task_summary>Implement XML hooks for RTB</task_summary>
<task_description>Implement XML hooks for RTB</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>1-OPN</current_test_status>
<test_status_date>04/29/01</test_status_date>
<test_status_user>anthony</test_status_user>
<task_obj>1004935092.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="94"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000100</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Anthony</task_manager>
<task_programmer>Tammy</task_programmer>
<task_status>C</task_status>
<task_entered_date>04/30/01</task_entered_date>
<task_completed_date>04/30/01</task_completed_date>
<task_user_reference>posse</task_user_reference>
<task_summary>IZ913 Session Type SDF enabling bug fix</task_summary>
<task_description>IZ913 Session Type SDF enabling bug fix</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>04/30/01</test_status_date>
<test_status_user>tammy</test_status_user>
<task_obj>1004935435.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="95"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000101</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Anthony</task_manager>
<task_programmer>Tammy</task_programmer>
<task_status>C</task_status>
<task_entered_date>04/30/01</task_entered_date>
<task_completed_date>05/01/01</task_completed_date>
<task_user_reference>posse</task_user_reference>
<task_summary>IZ891 Object control bug fixes</task_summary>
<task_description>IZ891 Object control bug fixes</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>05/01/01</test_status_date>
<test_status_user>tammy</test_status_user>
<task_obj>1004935473.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="96"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000102</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Anthony</task_manager>
<task_programmer>Tammy</task_programmer>
<task_status>C</task_status>
<task_entered_date>04/30/01</task_entered_date>
<task_completed_date>04/30/01</task_completed_date>
<task_user_reference>posse</task_user_reference>
<task_summary>IZ878 Property focus bug fix</task_summary>
<task_description>IZ878 Property focus bug fix</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>04/30/01</test_status_date>
<test_status_user>tammy</test_status_user>
<task_obj>1004935477.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="97"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000103</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Anthony</task_manager>
<task_programmer>Tammy</task_programmer>
<task_status>C</task_status>
<task_entered_date>04/30/01</task_entered_date>
<task_completed_date>04/30/01</task_completed_date>
<task_user_reference>posse</task_user_reference>
<task_summary>IZ894 Finish fixing window titles</task_summary>
<task_description>IZ894 Finish fixing window titles</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>04/30/01</test_status_date>
<test_status_user>tammy</test_status_user>
<task_obj>1004935559.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="98"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000104</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Anthony</task_manager>
<task_programmer>Tammy</task_programmer>
<task_status>C</task_status>
<task_entered_date>05/01/01</task_entered_date>
<task_completed_date>05/01/01</task_completed_date>
<task_user_reference>posse</task_user_reference>
<task_summary>Add desc to deploy dataset maintenance lookups</task_summary>
<task_description>Add desc to deploy dataset maintenance lookups</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>05/01/01</test_status_date>
<test_status_user>johns</test_status_user>
<task_obj>1004936222.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="99"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000105</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Anthony</task_manager>
<task_programmer>Tammy</task_programmer>
<task_status>C</task_status>
<task_entered_date>05/01/01</task_entered_date>
<task_completed_date>05/01/01</task_completed_date>
<task_user_reference>posse</task_user_reference>
<task_summary>Added Dataset query validation</task_summary>
<task_description>Added Dataset query validation</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>05/01/01</test_status_date>
<test_status_user>tammy</test_status_user>
<task_obj>1004936529.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="100"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000107</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Anthony</task_manager>
<task_programmer>Anthony</task_programmer>
<task_status>C</task_status>
<task_entered_date>05/01/01</task_entered_date>
<task_completed_date>05/01/01</task_completed_date>
<task_user_reference></task_user_reference>
<task_summary>Fix images on login window</task_summary>
<task_description>Fix images on login window</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>05/01/01</test_status_date>
<test_status_user>anthony</test_status_user>
<task_obj>1004936733.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="101"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000108</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Anthony</task_manager>
<task_programmer>Tammy</task_programmer>
<task_status>C</task_status>
<task_entered_date>05/01/01</task_entered_date>
<task_completed_date>05/03/01</task_completed_date>
<task_user_reference>posse</task_user_reference>
<task_summary>Wizard support for SBOs</task_summary>
<task_description>Wizard support for SBOs</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>05/03/01</test_status_date>
<test_status_user>tammy</test_status_user>
<task_obj>1004936745.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="102"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000109</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Anthony</task_manager>
<task_programmer>Haavard</task_programmer>
<task_status>C</task_status>
<task_entered_date>05/01/01</task_entered_date>
<task_completed_date>05/01/01</task_completed_date>
<task_user_reference>POSSE</task_user_reference>
<task_summary>SBO Wizard</task_summary>
<task_description>Create custom file and template for SBO support</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>05/01/01</test_status_date>
<test_status_user>haavard</test_status_user>
<task_obj>1004936788.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="103"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000110</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Anthony</task_manager>
<task_programmer>Haavard</task_programmer>
<task_status>W</task_status>
<task_entered_date>05/03/01</task_entered_date>
<task_completed_date>?</task_completed_date>
<task_user_reference>POSSE</task_user_reference>
<task_summary>Forward Engineer support for SBO</task_summary>
<task_description>Forward Engineer support for SBO</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>1-OPN</current_test_status>
<test_status_date>05/03/01</test_status_date>
<test_status_user>haavard</test_status_user>
<task_obj>1004938458.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="104"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000111</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Anthony</task_manager>
<task_programmer>Anthony</task_programmer>
<task_status>C</task_status>
<task_entered_date>05/03/01</task_entered_date>
<task_completed_date>05/03/01</task_completed_date>
<task_user_reference></task_user_reference>
<task_summary>Fix deployment issues</task_summary>
<task_description>Fix deployment issues</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>05/03/01</test_status_date>
<test_status_user>anthony</test_status_user>
<task_obj>1004938550.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="105"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000112</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Anthony</task_manager>
<task_programmer>Haavard</task_programmer>
<task_status>W</task_status>
<task_entered_date>05/03/01</task_entered_date>
<task_completed_date>?</task_completed_date>
<task_user_reference>POSSE</task_user_reference>
<task_summary>Configuration Type</task_summary>
<task_description>Configuration Type Maintenance</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>1-OPN</current_test_status>
<test_status_date>05/03/01</test_status_date>
<test_status_user>haavard</test_status_user>
<task_obj>1004942995.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="106"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000113</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Anthony</task_manager>
<task_programmer>Tammy</task_programmer>
<task_status>C</task_status>
<task_entered_date>05/03/01</task_entered_date>
<task_completed_date>05/03/01</task_completed_date>
<task_user_reference>posse</task_user_reference>
<task_summary>Modify dataset query validate message</task_summary>
<task_description>Modify dataset query validate message</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>05/03/01</test_status_date>
<test_status_user>tammy</test_status_user>
<task_obj>1004943023.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="107"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000114</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Anthony</task_manager>
<task_programmer>Tammy</task_programmer>
<task_status>C</task_status>
<task_entered_date>05/03/01</task_entered_date>
<task_completed_date>05/03/01</task_completed_date>
<task_user_reference>posse</task_user_reference>
<task_summary>Re-generate record version SDO</task_summary>
<task_description>Re-generate record version SDO</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>05/03/01</test_status_date>
<test_status_user>tammy</test_status_user>
<task_obj>1004943048.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="108"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000115</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Bruce</task_manager>
<task_programmer>Bruce</task_programmer>
<task_status>C</task_status>
<task_entered_date>05/03/01</task_entered_date>
<task_completed_date>05/24/01</task_completed_date>
<task_user_reference>IZ1091</task_user_reference>
<task_summary>IZ1091 Object SDO does not support copying records</task_summary>
<task_description>IZ1091 Object SDO does not support copying records</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>05/24/01</test_status_date>
<test_status_user>Bruce</test_status_user>
<task_obj>1004943052.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="109"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000116</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Bruce</task_manager>
<task_programmer>Bruce</task_programmer>
<task_status>C</task_status>
<task_entered_date>05/03/01</task_entered_date>
<task_completed_date>05/03/01</task_completed_date>
<task_user_reference></task_user_reference>
<task_summary>afstartupp.p doesn't work standalone</task_summary>
<task_description>afstartupp.p doesn't work standalone</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>05/03/01</test_status_date>
<test_status_user>Bruce</test_status_user>
<task_obj>1004943082.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="110"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000117</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Bruce</task_manager>
<task_programmer>Bruce</task_programmer>
<task_status>C</task_status>
<task_entered_date>05/03/01</task_entered_date>
<task_completed_date>05/03/01</task_completed_date>
<task_user_reference></task_user_reference>
<task_summary>afstartupp.p still doesn't work</task_summary>
<task_description>afstartupp.p still doesn't work</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>05/03/01</test_status_date>
<test_status_user>Bruce</test_status_user>
<task_obj>1004943311.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="111"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000118</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Anthony</task_manager>
<task_programmer>Haavard</task_programmer>
<task_status>W</task_status>
<task_entered_date>05/03/01</task_entered_date>
<task_completed_date>?</task_completed_date>
<task_user_reference>POSSE</task_user_reference>
<task_summary>Wizard adm astra incompatible</task_summary>
<task_description>Wizard adm astra incompatible</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>1-OPN</current_test_status>
<test_status_date>05/03/01</test_status_date>
<test_status_user>haavard</test_status_user>
<task_obj>1004943359.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="112"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000119</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Anthony</task_manager>
<task_programmer>Haavard</task_programmer>
<task_status>W</task_status>
<task_entered_date>05/03/01</task_entered_date>
<task_completed_date>?</task_completed_date>
<task_user_reference>posse</task_user_reference>
<task_summary>Datalogic and logic method libraries into adm2</task_summary>
<task_description>New task</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>1-OPN</current_test_status>
<test_status_date>05/03/01</test_status_date>
<test_status_user>haavard</test_status_user>
<task_obj>1004944355.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="113"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000120</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Haavard</task_manager>
<task_programmer>Haavard</task_programmer>
<task_status>W</task_status>
<task_entered_date>05/03/01</task_entered_date>
<task_completed_date>?</task_completed_date>
<task_user_reference></task_user_reference>
<task_summary>Folderwiz test</task_summary>
<task_description>Folderwiz test</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>1-OPN</current_test_status>
<test_status_date>05/03/01</test_status_date>
<test_status_user>haavard</test_status_user>
<task_obj>1004944377.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="114"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000121</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Anthony</task_manager>
<task_programmer>Anthony</task_programmer>
<task_status>C</task_status>
<task_entered_date>05/03/01</task_entered_date>
<task_completed_date>05/03/01</task_completed_date>
<task_user_reference></task_user_reference>
<task_summary>Fix menu build issues</task_summary>
<task_description>Fix menu build issues</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>05/03/01</test_status_date>
<test_status_user>ANTHONY</test_status_user>
<task_obj>1004946493.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="115"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000122</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Anthony</task_manager>
<task_programmer>Anthony</task_programmer>
<task_status>C</task_status>
<task_entered_date>05/03/01</task_entered_date>
<task_completed_date>05/03/01</task_completed_date>
<task_user_reference></task_user_reference>
<task_summary>fix menu item build issues</task_summary>
<task_description>fix menu item build issues</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>05/03/01</test_status_date>
<test_status_user>anthony</test_status_user>
<task_obj>1004946572.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="116"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000123</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Anthony</task_manager>
<task_programmer>Tammy</task_programmer>
<task_status>C</task_status>
<task_entered_date>05/04/01</task_entered_date>
<task_completed_date>05/04/01</task_completed_date>
<task_user_reference>IZ1037</task_user_reference>
<task_summary>IZ1037 Attribute Control bug fix</task_summary>
<task_description>IZ1037 Attribute Control bug fix</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>05/04/01</test_status_date>
<test_status_user>tammy</test_status_user>
<task_obj>1004946691.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="117"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000124</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Bruce</task_manager>
<task_programmer>Bruce</task_programmer>
<task_status>C</task_status>
<task_entered_date>05/05/01</task_entered_date>
<task_completed_date>05/06/01</task_completed_date>
<task_user_reference></task_user_reference>
<task_summary>afstartupp.p problem</task_summary>
<task_description>afstartupp.p problem</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>05/06/01</test_status_date>
<test_status_user>Bruce</test_status_user>
<task_obj>1004946962.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="118"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000125</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Bruce</task_manager>
<task_programmer>Bruce</task_programmer>
<task_status>C</task_status>
<task_entered_date>05/06/01</task_entered_date>
<task_completed_date>05/06/01</task_completed_date>
<task_user_reference></task_user_reference>
<task_summary>rydb: Load schema changes</task_summary>
<task_description>rydb: Load schema changes</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>05/06/01</test_status_date>
<test_status_user>Bruce</test_status_user>
<task_obj>1004947004.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="119"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000126</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Bruce</task_manager>
<task_programmer>Bruce</task_programmer>
<task_status>C</task_status>
<task_entered_date>05/06/01</task_entered_date>
<task_completed_date>05/06/01</task_completed_date>
<task_user_reference></task_user_reference>
<task_summary>rydb: load trigger changes and df</task_summary>
<task_description>rydb: load trigger changes and df</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>05/06/01</test_status_date>
<test_status_user>Bruce</test_status_user>
<task_obj>1004947007.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="120"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000127</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Anthony</task_manager>
<task_programmer>Tammy</task_programmer>
<task_status>C</task_status>
<task_entered_date>05/08/01</task_entered_date>
<task_completed_date>05/08/01</task_completed_date>
<task_user_reference>posse</task_user_reference>
<task_summary>Entity Mnemonic Import bug fix</task_summary>
<task_description>Entity Mnemonic Import bug fix</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>05/08/01</test_status_date>
<test_status_user>tammy</test_status_user>
<task_obj>1004947234.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="121"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000128</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Bruce</task_manager>
<task_programmer>Bruce</task_programmer>
<task_status>C</task_status>
<task_entered_date>05/09/01</task_entered_date>
<task_completed_date>05/09/01</task_completed_date>
<task_user_reference></task_user_reference>
<task_summary>293 error in gsmpyviewv.w</task_summary>
<task_description>293 error in gsmpyviewv.w</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>05/09/01</test_status_date>
<test_status_user>Bruce</test_status_user>
<task_obj>1004947506.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="122"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000129</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Phil</task_manager>
<task_programmer>Phil</task_programmer>
<task_status>W</task_status>
<task_entered_date>05/11/01</task_entered_date>
<task_completed_date>?</task_completed_date>
<task_user_reference></task_user_reference>
<task_summary>Kathy's task</task_summary>
<task_description>SDO Query Construction Fix - Issues 1090 &amp; 1132</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>1-OPN</current_test_status>
<test_status_date>05/11/01</test_status_date>
<test_status_user>phil</test_status_user>
<task_obj>1004948354.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="123"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000131</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Anthony</task_manager>
<task_programmer>Tammy</task_programmer>
<task_status>C</task_status>
<task_entered_date>05/10/01</task_entered_date>
<task_completed_date>05/10/01</task_completed_date>
<task_user_reference>posse</task_user_reference>
<task_summary>Change dummy physical service SDF to save data</task_summary>
<task_description>Change dummy physical service SDF to save data</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>05/10/01</test_status_date>
<test_status_user>tammy</test_status_user>
<task_obj>1004950599.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="124"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000132</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Bruce</task_manager>
<task_programmer>Bruce</task_programmer>
<task_status>C</task_status>
<task_entered_date>05/11/01</task_entered_date>
<task_completed_date>05/14/01</task_completed_date>
<task_user_reference></task_user_reference>
<task_summary>Complete Session Management Updates</task_summary>
<task_description>Complete Session Management Updates</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>05/14/01</test_status_date>
<test_status_user>Bruce</test_status_user>
<task_obj>1004955718.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="125"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000133</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Bruce</task_manager>
<task_programmer>Bruce</task_programmer>
<task_status>C</task_status>
<task_entered_date>05/11/01</task_entered_date>
<task_completed_date>05/11/01</task_completed_date>
<task_user_reference></task_user_reference>
<task_summary>Create aflaunch.i</task_summary>
<task_description>Create aflaunch.i</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>05/11/01</test_status_date>
<test_status_user>Bruce</test_status_user>
<task_obj>1004955769.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="126"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000134</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Anthony</task_manager>
<task_programmer>Tammy</task_programmer>
<task_status>C</task_status>
<task_entered_date>05/11/01</task_entered_date>
<task_completed_date>05/15/01</task_completed_date>
<task_user_reference>posse</task_user_reference>
<task_summary>Complete Physical Connection SmartDataFields</task_summary>
<task_description>Complete Physical Connection SmartDataFields</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>05/15/01</test_status_date>
<test_status_user>tammy</test_status_user>
<task_obj>1004955980.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="127"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000135</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Bruce</task_manager>
<task_programmer>Bruce</task_programmer>
<task_status>C</task_status>
<task_entered_date>05/14/01</task_entered_date>
<task_completed_date>05/15/01</task_completed_date>
<task_user_reference></task_user_reference>
<task_summary>XML Configuration File Export</task_summary>
<task_description>XML Configuration File Export</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>05/15/01</test_status_date>
<test_status_user>Bruce</test_status_user>
<task_obj>1004956172.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="128"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000136</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Anthony</task_manager>
<task_programmer>Tammy</task_programmer>
<task_status>C</task_status>
<task_entered_date>05/15/01</task_entered_date>
<task_completed_date>05/15/01</task_completed_date>
<task_user_reference>posse</task_user_reference>
<task_summary>Add editors to session manager properties</task_summary>
<task_description>Add editors to session manager properties</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>05/15/01</test_status_date>
<test_status_user>tammy</test_status_user>
<task_obj>1004956482.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="129"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000137</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Bruce</task_manager>
<task_programmer>Bruce</task_programmer>
<task_status>C</task_status>
<task_entered_date>05/16/01</task_entered_date>
<task_completed_date>05/16/01</task_completed_date>
<task_user_reference></task_user_reference>
<task_summary>Fix FIND bttManager not found bug</task_summary>
<task_description>Fix FIND bttManager not found bug</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>05/16/01</test_status_date>
<test_status_user>Bruce</test_status_user>
<task_obj>1004956759.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="130"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000138</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Bruce</task_manager>
<task_programmer>Bruce</task_programmer>
<task_status>C</task_status>
<task_entered_date>05/16/01</task_entered_date>
<task_completed_date>05/16/01</task_completed_date>
<task_user_reference></task_user_reference>
<task_summary>Fix Menu Name</task_summary>
<task_description>Fix Menu Name</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>05/16/01</test_status_date>
<test_status_user>johns</test_status_user>
<task_obj>1004956836.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="131"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000139</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Bruce</task_manager>
<task_programmer>Bruce</task_programmer>
<task_status>C</task_status>
<task_entered_date>05/16/01</task_entered_date>
<task_completed_date>05/16/01</task_completed_date>
<task_user_reference></task_user_reference>
<task_summary>remove broken web stuff</task_summary>
<task_description>remove broken web stuff</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>05/16/01</test_status_date>
<test_status_user>Bruce</test_status_user>
<task_obj>1004957038.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="132"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000140</task_number>
<task_workspace>090af-v1x</task_workspace>
<task_manager>Bruce</task_manager>
<task_programmer>Bruce</task_programmer>
<task_status>W</task_status>
<task_entered_date>05/16/01</task_entered_date>
<task_completed_date>?</task_completed_date>
<task_user_reference></task_user_reference>
<task_summary>Import release 4</task_summary>
<task_description>Import release 4</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>V1X</current_test_area>
<current_test_status>1-OPN</current_test_status>
<test_status_date>05/16/01</test_status_date>
<test_status_user>Bruce</test_status_user>
<task_obj>1004957118.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="133"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000141</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Bruce</task_manager>
<task_programmer>Bruce</task_programmer>
<task_status>C</task_status>
<task_entered_date>05/16/01</task_entered_date>
<task_completed_date>05/24/01</task_completed_date>
<task_user_reference></task_user_reference>
<task_summary>Deployment Dataset Creation</task_summary>
<task_description>Deployment Dataset Creation</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>05/24/01</test_status_date>
<test_status_user>Bruce</test_status_user>
<task_obj>1004957691.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="134"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000142</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Anthony</task_manager>
<task_programmer>Haavard</task_programmer>
<task_status>W</task_status>
<task_entered_date>05/17/01</task_entered_date>
<task_completed_date>?</task_completed_date>
<task_user_reference></task_user_reference>
<task_summary>Synchronize DO when SDV and SDB on same page</task_summary>
<task_description>Synchronize DO when SDV and SDB on same page</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>1-OPN</current_test_status>
<test_status_date>05/17/01</test_status_date>
<test_status_user>haavard</test_status_user>
<task_obj>1004959731.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="135"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000143</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Anthony</task_manager>
<task_programmer>Tammy</task_programmer>
<task_status>C</task_status>
<task_entered_date>05/18/01</task_entered_date>
<task_completed_date>05/18/01</task_completed_date>
<task_user_reference>posse</task_user_reference>
<task_summary>Fix parsing of physical connection parameters</task_summary>
<task_description>Fix parsing of physical connection parameters</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>05/18/01</test_status_date>
<test_status_user>tammy</test_status_user>
<task_obj>1004959751.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="136"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000144</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Anthony</task_manager>
<task_programmer>Tammy</task_programmer>
<task_status>C</task_status>
<task_entered_date>05/18/01</task_entered_date>
<task_completed_date>05/18/01</task_completed_date>
<task_user_reference>IZ1046</task_user_reference>
<task_summary>IZ1046 Object Instance Maintenance bug fix</task_summary>
<task_description>IZ1046 Object Instance Maintenance bug fix</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>05/18/01</test_status_date>
<test_status_user>tammy</test_status_user>
<task_obj>1004959761.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="137"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000145</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Phil</task_manager>
<task_programmer>Phil</task_programmer>
<task_status>W</task_status>
<task_entered_date>05/19/01</task_entered_date>
<task_completed_date>?</task_completed_date>
<task_user_reference>POSSE</task_user_reference>
<task_summary>Translation logic changes</task_summary>
<task_description>Translation logic changes</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>1-OPN</current_test_status>
<test_status_date>05/19/01</test_status_date>
<test_status_user>phil</test_status_user>
<task_obj>1004959863.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="138"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000146</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Anthony</task_manager>
<task_programmer>Haavard</task_programmer>
<task_status>W</task_status>
<task_entered_date>05/19/01</task_entered_date>
<task_completed_date>?</task_completed_date>
<task_user_reference></task_user_reference>
<task_summary>Allow ForeignFields on one (first) page</task_summary>
<task_description>Allow ForeignFields on one (first) page</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>1-OPN</current_test_status>
<test_status_date>05/19/01</test_status_date>
<test_status_user>haavard</test_status_user>
<task_obj>1004979020.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="139"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000148</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Bruce</task_manager>
<task_programmer>Bruce</task_programmer>
<task_status>C</task_status>
<task_entered_date>05/24/01</task_entered_date>
<task_completed_date>05/24/01</task_completed_date>
<task_user_reference></task_user_reference>
<task_summary>New icons</task_summary>
<task_description>New icons</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>05/24/01</test_status_date>
<test_status_user>Bruce</test_status_user>
<task_obj>1005050343.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="140"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000149</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Bruce</task_manager>
<task_programmer>Bruce</task_programmer>
<task_status>C</task_status>
<task_entered_date>05/24/01</task_entered_date>
<task_completed_date>05/24/01</task_completed_date>
<task_user_reference></task_user_reference>
<task_summary>Anthony's changes</task_summary>
<task_description>Anthony's changes</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>05/24/01</test_status_date>
<test_status_user>Bruce</test_status_user>
<task_obj>1005050373.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="141"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000150</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Bruce</task_manager>
<task_programmer>Bruce</task_programmer>
<task_status>C</task_status>
<task_entered_date>05/24/01</task_entered_date>
<task_completed_date>05/24/01</task_completed_date>
<task_user_reference></task_user_reference>
<task_summary>Fix template wizard to include POSSE license</task_summary>
<task_description>Fix template to include POSSE license</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>05/24/01</test_status_date>
<test_status_user>Bruce</test_status_user>
<task_obj>1005050405.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="142"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000151</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Bruce</task_manager>
<task_programmer>Bruce</task_programmer>
<task_status>C</task_status>
<task_entered_date>05/24/01</task_entered_date>
<task_completed_date>05/24/01</task_completed_date>
<task_user_reference></task_user_reference>
<task_summary>Posse License Program</task_summary>
<task_description>Posse License Program</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>05/24/01</test_status_date>
<test_status_user>Bruce</test_status_user>
<task_obj>1005050465.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="143"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000152</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Bruce</task_manager>
<task_programmer>Bruce</task_programmer>
<task_status>C</task_status>
<task_entered_date>05/24/01</task_entered_date>
<task_completed_date>05/24/01</task_completed_date>
<task_user_reference></task_user_reference>
<task_summary>Check in license changes</task_summary>
<task_description>Check in license changes</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>05/24/01</test_status_date>
<test_status_user>Bruce</test_status_user>
<task_obj>1005050652.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="144"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000153</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Bruce</task_manager>
<task_programmer>Bruce</task_programmer>
<task_status>C</task_status>
<task_entered_date>05/24/01</task_entered_date>
<task_completed_date>05/24/01</task_completed_date>
<task_user_reference></task_user_reference>
<task_summary>Bug in rylayoutsp.p</task_summary>
<task_description>Bug in rylayoutsp.p</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>05/24/01</test_status_date>
<test_status_user>Bruce</test_status_user>
<task_obj>1005053355.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="145"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000154</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Bruce</task_manager>
<task_programmer>Bruce</task_programmer>
<task_status>C</task_status>
<task_entered_date>05/25/01</task_entered_date>
<task_completed_date>05/25/01</task_completed_date>
<task_user_reference></task_user_reference>
<task_summary>ERWin macro corrections</task_summary>
<task_description>ERWin macro corrections</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>05/25/01</test_status_date>
<test_status_user>Bruce</test_status_user>
<task_obj>1005053494.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="146"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000155</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Phil</task_manager>
<task_programmer>Phil</task_programmer>
<task_status>W</task_status>
<task_entered_date>05/25/01</task_entered_date>
<task_completed_date>?</task_completed_date>
<task_user_reference></task_user_reference>
<task_summary>Tab folder page initialization</task_summary>
<task_description>Tab folder page initialization</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>1-OPN</current_test_status>
<test_status_date>05/25/01</test_status_date>
<test_status_user>phil</test_status_user>
<task_obj>1005053544.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="147"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000156</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Phil</task_manager>
<task_programmer>Phil</task_programmer>
<task_status>W</task_status>
<task_entered_date>05/26/01</task_entered_date>
<task_completed_date>?</task_completed_date>
<task_user_reference></task_user_reference>
<task_summary>Token security bugs</task_summary>
<task_description>Token security bugs</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>1-OPN</current_test_status>
<test_status_date>05/26/01</test_status_date>
<test_status_user>phil</test_status_user>
<task_obj>1005053598.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="148"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000157</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Phil</task_manager>
<task_programmer>Phil</task_programmer>
<task_status>W</task_status>
<task_entered_date>05/31/01</task_entered_date>
<task_completed_date>?</task_completed_date>
<task_user_reference></task_user_reference>
<task_summary>Folder Page Tokens</task_summary>
<task_description>Folder Page Tokens</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>1-OPN</current_test_status>
<test_status_date>05/31/01</test_status_date>
<test_status_user>phil</test_status_user>
<task_obj>1005077406.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="149"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000158</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Bruce</task_manager>
<task_programmer>Bruce</task_programmer>
<task_status>C</task_status>
<task_entered_date>05/31/01</task_entered_date>
<task_completed_date>06/13/01</task_completed_date>
<task_user_reference></task_user_reference>
<task_summary>Layout fix</task_summary>
<task_description>Layout fix</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>06/13/01</test_status_date>
<test_status_user>Bruce</test_status_user>
<task_obj>1005077446.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="150"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000159</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Anthony</task_manager>
<task_programmer>Tammy</task_programmer>
<task_status>C</task_status>
<task_entered_date>06/11/01</task_entered_date>
<task_completed_date>06/12/01</task_completed_date>
<task_user_reference>IZ1305</task_user_reference>
<task_summary>Dynamic Lookup Property Bug Fix - IZ 1305</task_summary>
<task_description>Dynamic Lookup Property Bug Fix - IZ 1305</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>06/12/01</test_status_date>
<test_status_user>tammy</test_status_user>
<task_obj>1005077463.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="151"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000160</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Bruce</task_manager>
<task_programmer>Tammy</task_programmer>
<task_status>W</task_status>
<task_entered_date>06/12/01</task_entered_date>
<task_completed_date>?</task_completed_date>
<task_user_reference>IZ1372</task_user_reference>
<task_summary>Bug Fix for Issue 1372</task_summary>
<task_description>Bug Fix for Issue 1372</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>1-OPN</current_test_status>
<test_status_date>06/12/01</test_status_date>
<test_status_user>tammy</test_status_user>
<task_obj>1005077557.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="152"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000161</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Bruce</task_manager>
<task_programmer>Bruce</task_programmer>
<task_status>C</task_status>
<task_entered_date>06/13/01</task_entered_date>
<task_completed_date>06/13/01</task_completed_date>
<task_user_reference></task_user_reference>
<task_summary>Load new icons</task_summary>
<task_description>Load new icons</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>06/13/01</test_status_date>
<test_status_user>Bruce</test_status_user>
<task_obj>1005077851.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="153"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000162</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Bruce</task_manager>
<task_programmer>Bruce</task_programmer>
<task_status>W</task_status>
<task_entered_date>06/13/01</task_entered_date>
<task_completed_date>?</task_completed_date>
<task_user_reference></task_user_reference>
<task_summary>XML Import/Export routine for datasets</task_summary>
<task_description>XML Import/Export routine for datasets</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>1-OPN</current_test_status>
<test_status_date>06/13/01</test_status_date>
<test_status_user>Bruce</test_status_user>
<task_obj>1005077950.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="154"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000163</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Bruce</task_manager>
<task_programmer>Bruce</task_programmer>
<task_status>C</task_status>
<task_entered_date>06/26/01</task_entered_date>
<task_completed_date>06/26/01</task_completed_date>
<task_user_reference></task_user_reference>
<task_summary>General Manager modifications</task_summary>
<task_description>General Manager modifications</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>06/26/01</test_status_date>
<test_status_user>Bruce</test_status_user>
<task_obj>1005077982.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="155"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000164</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Bruce</task_manager>
<task_programmer>Bruce</task_programmer>
<task_status>C</task_status>
<task_entered_date>06/26/01</task_entered_date>
<task_completed_date>06/26/01</task_completed_date>
<task_user_reference></task_user_reference>
<task_summary>Moved ERWin models and dfs</task_summary>
<task_description>Moved ERWin models and dfs</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>06/26/01</test_status_date>
<test_status_user>Bruce</test_status_user>
<task_obj>1005077988.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="156"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000165</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Bruce</task_manager>
<task_programmer>Bruce</task_programmer>
<task_status>C</task_status>
<task_entered_date>06/26/01</task_entered_date>
<task_completed_date>06/26/01</task_completed_date>
<task_user_reference></task_user_reference>
<task_summary>ERWin Macro Code Move</task_summary>
<task_description>ERWin Macro Code Move</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>06/26/01</test_status_date>
<test_status_user>Bruce</test_status_user>
<task_obj>1005078065.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="157"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000166</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Bruce</task_manager>
<task_programmer>Bruce</task_programmer>
<task_status>C</task_status>
<task_entered_date>06/26/01</task_entered_date>
<task_completed_date>06/26/01</task_completed_date>
<task_user_reference></task_user_reference>
<task_summary>Schema updates from MIP</task_summary>
<task_description>Schema updates from MIP</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>06/26/01</test_status_date>
<test_status_user>Bruce</test_status_user>
<task_obj>1005078135.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="158"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000167</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Bruce</task_manager>
<task_programmer>Bruce</task_programmer>
<task_status>C</task_status>
<task_entered_date>06/26/01</task_entered_date>
<task_completed_date>06/26/01</task_completed_date>
<task_user_reference></task_user_reference>
<task_summary>Schema updates from MIP (RVDB)</task_summary>
<task_description>Schema updates from MIP (RVDB)</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>06/26/01</test_status_date>
<test_status_user>Bruce</test_status_user>
<task_obj>1005078138.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="159"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000168</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Bruce</task_manager>
<task_programmer>Bruce</task_programmer>
<task_status>C</task_status>
<task_entered_date>06/26/01</task_entered_date>
<task_completed_date>06/26/01</task_completed_date>
<task_user_reference></task_user_reference>
<task_summary>Schema updates from MIP (RYDB)</task_summary>
<task_description>Schema updates from MIP (RYDB)</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>06/26/01</test_status_date>
<test_status_user>Bruce</test_status_user>
<task_obj>1005078140.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="160"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000169</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Bruce</task_manager>
<task_programmer>Bruce</task_programmer>
<task_status>C</task_status>
<task_entered_date>06/26/01</task_entered_date>
<task_completed_date>06/27/01</task_completed_date>
<task_user_reference></task_user_reference>
<task_summary>Updates from MIP for POSSE</task_summary>
<task_description>Updates from MIP for POSSE</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>06/27/01</test_status_date>
<test_status_user>Bruce</test_status_user>
<task_obj>1005078144.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="161"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000170</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Bruce</task_manager>
<task_programmer>Bruce</task_programmer>
<task_status>C</task_status>
<task_entered_date>06/27/01</task_entered_date>
<task_completed_date>06/27/01</task_completed_date>
<task_user_reference></task_user_reference>
<task_summary>Import ERWin template</task_summary>
<task_description>Import ERWin template</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>06/27/01</test_status_date>
<test_status_user>Bruce</test_status_user>
<task_obj>1005078970.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="162"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000171</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Anthony</task_manager>
<task_programmer>pm</task_programmer>
<task_status>C</task_status>
<task_entered_date>07/19/01</task_entered_date>
<task_completed_date>07/19/01</task_completed_date>
<task_user_reference></task_user_reference>
<task_summary>Create ICFDB</task_summary>
<task_description>Create ICFDB</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>07/19/01</test_status_date>
<test_status_user>pm</test_status_user>
<task_obj>1005079035.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="163"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000174</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>pm</task_manager>
<task_programmer>pm</task_programmer>
<task_status>C</task_status>
<task_entered_date>07/19/01</task_entered_date>
<task_completed_date>07/19/01</task_completed_date>
<task_user_reference></task_user_reference>
<task_summary>Load RVDB changes</task_summary>
<task_description>Load RVDB changes</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>3-COM</current_test_status>
<test_status_date>07/19/01</test_status_date>
<test_status_user>pm</test_status_user>
<task_obj>1005079034.09</task_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="164"><contained_record DB="RVDB" Table="rvm_task"><task_number>90000175</task_number>
<task_workspace>090af-dev</task_workspace>
<task_manager>Anthony</task_manager>
<task_programmer>pm</task_programmer>
<task_status>W</task_status>
<task_entered_date>07/19/01</task_entered_date>
<task_completed_date>?</task_completed_date>
<task_user_reference></task_user_reference>
<task_summary>Load new and changed ICF objects</task_summary>
<task_description>Load new and changed ICF objects</task_description>
<task_priority>99</task_priority>
<fix_for_task_number>0</fix_for_task_number>
<estimated_hrs>0</estimated_hrs>
<actual_hrs>0</actual_hrs>
<current_test_area>DEV</current_test_area>
<current_test_status>1-OPN</current_test_status>
<test_status_date>07/19/01</test_status_date>
<test_status_user>pm</test_status_user>
<task_obj>1005079036.09</task_obj>
</contained_record>
</dataset_transaction>
</dataset_records>
</dataset>