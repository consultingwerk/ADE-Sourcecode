<?xml version="1.0" encoding="ISO8859-1" ?>
<dataset Transactions="162" version_date="02/23/2002" version_time="42929" version_user="admin" entity_mnemonic="GSTDF" key_field_value="3000000377.09" record_version_obj="3000000378.09" version_number_seq="2.09" import_version_number_seq="1.09"><dataset_header DisableRI="yes" DatasetObj="1007600214.08" DateFormat="mdy" FullHeader="yes" SCMManaged="no" YearOffset="1950" DatasetCode="GSCER" DateCreated="02/23/2002" TimeCreated="11:55:23" NumericFormat="AMERICAN" NumericDecimal="." OriginatingSite="93" NumericSeparator=","><deploy_dataset_obj>1007600214.08</deploy_dataset_obj>
<owner_site_code></owner_site_code>
<dataset_code>GSCER</dataset_code>
<dataset_description>gsc_error - Errors</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<dataset_entity><dataset_entity_obj>1007600215.08</dataset_entity_obj>
<deploy_dataset_obj>1007600214.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSCER</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>error_group,error_number</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<entity_mnemonic_description>gsc_error</entity_mnemonic_description>
<entity_dbname>icfdb</entity_dbname>
</dataset_entity>
<table_definition><name>gsc_error</name>
<dbname>ICFDB</dbname>
<index-1>XAK1gsc_error,1,0,0,error_obj,0</index-1>
<index-2>XIE1gsc_error,0,0,0,error_group,0,error_summary_description,0</index-2>
<index-3>XIE2gsc_error,0,0,0,language_obj,0,error_group,0,error_number,0</index-3>
<index-4>XIE3gsc_error,0,0,0,error_type,0,error_group,0,error_number,0</index-4>
<index-5>XIE4gsc_error,0,0,0,language_obj,0,error_type,0,error_group,0,error_number,0</index-5>
<index-6>XPKgsc_error,1,1,0,error_group,0,error_number,0,language_obj,0</index-6>
<field><name>error_group</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(3)</format>
<initial></initial>
<label>Error Group</label>
<column-label>Error Group</column-label>
</field>
<field><name>error_number</name>
<data-type>integer</data-type>
<extent>0</extent>
<format>->>>>>>>9</format>
<initial>        0</initial>
<label>Error Number</label>
<column-label>Error Number</column-label>
</field>
<field><name>language_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>>>>>>>>>>>>>>>>>>9.999999999</format>
<initial>                 0.000000000</initial>
<label>Language Obj</label>
<column-label>Language Obj</column-label>
</field>
<field><name>error_summary_description</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Error Summary Description</label>
<column-label>Error Summary Description</column-label>
</field>
<field><name>error_full_description</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(3000)</format>
<initial></initial>
<label>Error Full Description</label>
<column-label>Error Full Description</column-label>
</field>
<field><name>error_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>>>>>>>>>>>>>>>>>>9.999999999</format>
<initial>                 0.000000000</initial>
<label>Error Obj</label>
<column-label>Error Obj</column-label>
</field>
<field><name>update_error_log</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>Update Error Log</label>
<column-label>Update Error Log</column-label>
</field>
<field><name>error_type</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(3)</format>
<initial></initial>
<label>Error Type</label>
<column-label>Error Type</column-label>
</field>
</table_definition>
</dataset_header>
<dataset_records><dataset_transaction TransactionNo="1"><contained_record DB="ICFDB" Table="gsc_error" version_date="02/07/2002" version_time="52271" version_user="admin" entity_mnemonic="gscer" key_field_value="241" record_version_obj="8892.28" version_number_seq="-2.28" import_version_number_seq="2.28"><error_group>AF</error_group>
<error_number>1</error_number>
<language_obj>426</language_obj>
<error_summary_description>The &amp;1 must be specified.</error_summary_description>
<error_full_description>The &amp;1 must be specified. &amp;2</error_full_description>
<error_obj>241</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="2"><contained_record DB="ICFDB" Table="gsc_error"><error_group>AF</error_group>
<error_number>2</error_number>
<language_obj>426</language_obj>
<error_summary_description>Unidentified error from trigger.</error_summary_description>
<error_full_description>An error occurred in a trigger that did not return a correct return-value with ^ delimiters to identify the correct error code, group and message. This probably means that the standard trigger procedure error-message was not used.The error raised was &amp;1</error_full_description>
<error_obj>242</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="3"><contained_record DB="ICFDB" Table="gsc_error"><error_group>AF</error_group>
<error_number>3</error_number>
<language_obj>426</language_obj>
<error_summary_description>The &amp;1 cannot be modified if the system owned flag is set to YES.</error_summary_description>
<error_full_description>The &amp;1 cannot be modified if the system owned flag is set to YES.</error_full_description>
<error_obj>243</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="4"><contained_record DB="ICFDB" Table="gsc_error"><error_group>AF</error_group>
<error_number>4</error_number>
<language_obj>426</language_obj>
<error_summary_description>The &amp;1 should not be specified.</error_summary_description>
<error_full_description>The &amp;1 should not be specified.</error_full_description>
<error_obj>244</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="5"><contained_record DB="ICFDB" Table="gsc_error"><error_group>AF</error_group>
<error_number>5</error_number>
<language_obj>426</language_obj>
<error_summary_description>The &amp;1 specified is invalid.</error_summary_description>
<error_full_description>The &amp;1 specified is invalid. &amp;2</error_full_description>
<error_obj>245</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="6"><contained_record DB="ICFDB" Table="gsc_error"><error_group>AF</error_group>
<error_number>6</error_number>
<language_obj>426</language_obj>
<error_summary_description>Valid values for this field are &amp;1.</error_summary_description>
<error_full_description>Valid values for this field are &amp;1.</error_full_description>
<error_obj>246</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="7"><contained_record DB="ICFDB" Table="gsc_error"><error_group>AF</error_group>
<error_number>7</error_number>
<language_obj>426</language_obj>
<error_summary_description>Please enter a relative path.</error_summary_description>
<error_full_description>Please enter a relative path.</error_full_description>
<error_obj>247</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="8"><contained_record DB="ICFDB" Table="gsc_error"><error_group>AF</error_group>
<error_number>8</error_number>
<language_obj>426</language_obj>
<error_summary_description>A record with &amp;1 &amp;2 already exists &amp;3.</error_summary_description>
<error_full_description>A record with &amp;1 &amp;2 already exists &amp;3.</error_full_description>
<error_obj>248</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="9"><contained_record DB="ICFDB" Table="gsc_error"><error_group>AF</error_group>
<error_number>9</error_number>
<language_obj>426</language_obj>
<error_summary_description>The &amp;1 date should be &amp;2.</error_summary_description>
<error_full_description>The &amp;1 date should be &amp;2. You cannot enter a date with this value.  Please try again. &amp;3</error_full_description>
<error_obj>249</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="10"><contained_record DB="ICFDB" Table="gsc_error"><error_group>AF</error_group>
<error_number>10</error_number>
<language_obj>426</language_obj>
<error_summary_description>Cannot &amp;1 file.  Permission denied.</error_summary_description>
<error_full_description>Cannot &amp;1 file.  Permission denied.  &amp;2</error_full_description>
<error_obj>250</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="11"><contained_record DB="ICFDB" Table="gsc_error"><error_group>AF</error_group>
<error_number>11</error_number>
<language_obj>426</language_obj>
<error_summary_description>The &amp;1 could not be found for &amp;2.</error_summary_description>
<error_full_description>The &amp;1 could not be found for &amp;2.  &amp;3</error_full_description>
<error_obj>251</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="12"><contained_record DB="ICFDB" Table="gsc_error"><error_group>AF</error_group>
<error_number>12</error_number>
<language_obj>426</language_obj>
<error_summary_description>Could not run procedure in PLIP specified.</error_summary_description>
<error_full_description>The procedure &amp;1 in PLIP &amp;2 could not be run.</error_full_description>
<error_obj>252</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="13"><contained_record DB="ICFDB" Table="gsc_error"><error_group>AF</error_group>
<error_number>13</error_number>
<language_obj>426</language_obj>
<error_summary_description>The &amp;1 cannot be modified</error_summary_description>
<error_full_description>The &amp;1 cannot be modified. If you wish to modify the &amp;1, then you must delete the record and add a new record with the new value.Changing the &amp;1 will change the nature of the record.</error_full_description>
<error_obj>253</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="14"><contained_record DB="ICFDB" Table="gsc_error"><error_group>AF</error_group>
<error_number>14</error_number>
<language_obj>426</language_obj>
<error_summary_description>&amp;1 is not set up &amp;2.  Please contact your System Administrator.</error_summary_description>
<error_full_description>&amp;1 is not set up &amp;2.  Please contact your System Administrator.  &amp;3.</error_full_description>
<error_obj>254</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="15"><contained_record DB="ICFDB" Table="gsc_error"><error_group>AF</error_group>
<error_number>15</error_number>
<language_obj>426</language_obj>
<error_summary_description>Cannot run because &amp;1</error_summary_description>
<error_full_description>Cannot run because &amp;1</error_full_description>
<error_obj>255</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="16"><contained_record DB="ICFDB" Table="gsc_error"><error_group>AF</error_group>
<error_number>16</error_number>
<language_obj>426</language_obj>
<error_summary_description>The copy of &amp;1 details failed.</error_summary_description>
<error_full_description>The copy of &amp;1 details failed.</error_full_description>
<error_obj>256</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="17"><contained_record DB="ICFDB" Table="gsc_error"><error_group>AF</error_group>
<error_number>17</error_number>
<language_obj>426</language_obj>
<error_summary_description>Access denied - &amp;1.</error_summary_description>
<error_full_description>Access denied - &amp;1.</error_full_description>
<error_obj>257</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="18"><contained_record DB="ICFDB" Table="gsc_error"><error_group>AF</error_group>
<error_number>18</error_number>
<language_obj>426</language_obj>
<error_summary_description>The &amp;1 must contain &amp;2.</error_summary_description>
<error_full_description>The &amp;1 must contain &amp;2. &amp;3</error_full_description>
<error_obj>258</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="19"><contained_record DB="ICFDB" Table="gsc_error"><error_group>AF</error_group>
<error_number>19</error_number>
<language_obj>426</language_obj>
<error_summary_description>Cannot find &amp;1 file: &amp;2</error_summary_description>
<error_full_description>Cannot find &amp;1 file: &amp;2</error_full_description>
<error_obj>259</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="20"><contained_record DB="ICFDB" Table="gsc_error"><error_group>AF</error_group>
<error_number>20</error_number>
<language_obj>426</language_obj>
<error_summary_description>The record has been deleted by another user.</error_summary_description>
<error_full_description>The record has been deleted by another user.</error_full_description>
<error_obj>260</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="21"><contained_record DB="ICFDB" Table="gsc_error"><error_group>AF</error_group>
<error_number>21</error_number>
<language_obj>426</language_obj>
<error_summary_description>The filename specified must &amp;1.</error_summary_description>
<error_full_description>The filename specified must &amp;1.</error_full_description>
<error_obj>261</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="22"><contained_record DB="ICFDB" Table="gsc_error"><error_group>AF</error_group>
<error_number>22</error_number>
<language_obj>426</language_obj>
<error_summary_description>The &amp;1 must be &amp;2 if a &amp;3 is specified.</error_summary_description>
<error_full_description>If a &amp;3 is entered, the &amp;1 must be &amp;2.</error_full_description>
<error_obj>262</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="23"><contained_record DB="ICFDB" Table="gsc_error"><error_group>AF</error_group>
<error_number>23</error_number>
<language_obj>426</language_obj>
<error_summary_description>This object is assigned to a menu structure.</error_summary_description>
<error_full_description>This object is assigned to a menu structure and must be runnable from a menu.</error_full_description>
<error_obj>263</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="24"><contained_record DB="ICFDB" Table="gsc_error"><error_group>AF</error_group>
<error_number>24</error_number>
<language_obj>426</language_obj>
<error_summary_description>The &amp;1 must begin with &amp;2.</error_summary_description>
<error_full_description>The &amp;1 must begin with &amp;2.</error_full_description>
<error_obj>264</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="25"><contained_record DB="ICFDB" Table="gsc_error"><error_group>AF</error_group>
<error_number>25</error_number>
<language_obj>426</language_obj>
<error_summary_description>The &amp;1 should be greater than &amp;2.</error_summary_description>
<error_full_description>The &amp;1 should be greater than &amp;2.  &amp;3.</error_full_description>
<error_obj>265</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="26"><contained_record DB="ICFDB" Table="gsc_error"><error_group>AF</error_group>
<error_number>26</error_number>
<language_obj>426</language_obj>
<error_summary_description>The parent is not a sub-menu.</error_summary_description>
<error_full_description>The parent of a menu item must always be either a menu structure or a sub-menu.</error_full_description>
<error_obj>266</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="27"><contained_record DB="ICFDB" Table="gsc_error"><error_group>AF</error_group>
<error_number>27</error_number>
<language_obj>426</language_obj>
<error_summary_description>The &amp;1 specified on record does not exist.</error_summary_description>
<error_full_description>The &amp;1 specified on record does not exist.</error_full_description>
<error_obj>267</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="28"><contained_record DB="ICFDB" Table="gsc_error"><error_group>AF</error_group>
<error_number>28</error_number>
<language_obj>426</language_obj>
<error_summary_description>The &amp;1 is on &amp;2.</error_summary_description>
<error_full_description>The &amp;1 is on &amp;2.</error_full_description>
<error_obj>268</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="29"><contained_record DB="ICFDB" Table="gsc_error"><error_group>AF</error_group>
<error_number>29</error_number>
<language_obj>426</language_obj>
<error_summary_description>The &amp;1 is not available.</error_summary_description>
<error_full_description>The &amp;1 is not available.  &amp;2.</error_full_description>
<error_obj>269</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="30"><contained_record DB="ICFDB" Table="gsc_error"><error_group>AF</error_group>
<error_number>31</error_number>
<language_obj>426</language_obj>
<error_summary_description>A &amp;1 already exists with &amp;2.</error_summary_description>
<error_full_description>A &amp;1 already exists with &amp;2. You cannot add a duplicate.</error_full_description>
<error_obj>270</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="31"><contained_record DB="ICFDB" Table="gsc_error"><error_group>AF</error_group>
<error_number>32</error_number>
<language_obj>426</language_obj>
<error_summary_description>Calendar period &amp;1 is already closed.</error_summary_description>
<error_full_description>Calendar period &amp;1 is already closed. No processing is allowed for transactions dated prior to the current period's start date.</error_full_description>
<error_obj>271</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="32"><contained_record DB="ICFDB" Table="gsc_error"><error_group>AF</error_group>
<error_number>33</error_number>
<language_obj>426</language_obj>
<error_summary_description>The &amp;1 should be greater than or equal to &amp;2.</error_summary_description>
<error_full_description>The &amp;1 should be greater than or equal to &amp;2.  &amp;3.</error_full_description>
<error_obj>272</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="33"><contained_record DB="ICFDB" Table="gsc_error"><error_group>AF</error_group>
<error_number>34</error_number>
<language_obj>426</language_obj>
<error_summary_description>The &amp;1 should be less than or equal to &amp;2.</error_summary_description>
<error_full_description>The &amp;1 should be less than or equal to &amp;2.  &amp;3.</error_full_description>
<error_obj>273</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="34"><contained_record DB="ICFDB" Table="gsc_error"><error_group>AF</error_group>
<error_number>35</error_number>
<language_obj>426</language_obj>
<error_summary_description>If &amp;1 is specified then &amp;2 must be entered.</error_summary_description>
<error_full_description>If &amp;1 is specified, &amp;2 becomes mandatory and must be entered.</error_full_description>
<error_obj>274</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="35"><contained_record DB="ICFDB" Table="gsc_error"><error_group>AF</error_group>
<error_number>36</error_number>
<language_obj>426</language_obj>
<error_summary_description>The update of &amp;1 failed because &amp;2.</error_summary_description>
<error_full_description>The update of &amp;1 failed because &amp;2. &amp;3</error_full_description>
<error_obj>275</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="36"><contained_record DB="ICFDB" Table="gsc_error"><error_group>AF</error_group>
<error_number>37</error_number>
<language_obj>426</language_obj>
<error_summary_description>Crystal report error number &amp;1.</error_summary_description>
<error_full_description>Error number &amp;1 was returned from the Crystal Reports engine.</error_full_description>
<error_obj>311</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="37"><contained_record DB="ICFDB" Table="gsc_error"><error_group>AF</error_group>
<error_number>38</error_number>
<language_obj>426</language_obj>
<error_summary_description>Only one entry for &amp;1 is valid.</error_summary_description>
<error_full_description>Only one entry for &amp;1 is valid.</error_full_description>
<error_obj>312</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="38"><contained_record DB="ICFDB" Table="gsc_error"><error_group>AF</error_group>
<error_number>39</error_number>
<language_obj>426</language_obj>
<error_summary_description>No &amp;1 was found. &amp;2</error_summary_description>
<error_full_description>No &amp;1 was found. &amp;2</error_full_description>
<error_obj>313</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="39"><contained_record DB="ICFDB" Table="gsc_error"><error_group>AF</error_group>
<error_number>40</error_number>
<language_obj>426</language_obj>
<error_summary_description>The following error occured while processing. &amp;1</error_summary_description>
<error_full_description>The following error occured while processing. &amp;1. Transaction was not completed.</error_full_description>
<error_obj>314</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="40"><contained_record DB="ICFDB" Table="gsc_error"><error_group>AF</error_group>
<error_number>41</error_number>
<language_obj>426</language_obj>
<error_summary_description>If &amp;1 is specified then &amp;2 cannot be entered.</error_summary_description>
<error_full_description>If &amp;1 is specified then &amp;2 cannot be entered.  &amp;3.</error_full_description>
<error_obj>249484</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="41"><contained_record DB="ICFDB" Table="gsc_error"><error_group>AF</error_group>
<error_number>42</error_number>
<language_obj>426</language_obj>
<error_summary_description>The &amp;1 must end with &amp;2.</error_summary_description>
<error_full_description>The &amp;1 must end with &amp;2.</error_full_description>
<error_obj>1003516386</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="42"><contained_record DB="ICFDB" Table="gsc_error"><error_group>AF</error_group>
<error_number>43</error_number>
<language_obj>426</language_obj>
<error_summary_description>A user cannot be a deputy for him/herself.</error_summary_description>
<error_full_description>A user cannot be a deputy for him/herself.</error_full_description>
<error_obj>1003535588</error_obj>
<update_error_log>no</update_error_log>
<error_type>ERR</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="43"><contained_record DB="ICFDB" Table="gsc_error"><error_group>AF </error_group>
<error_number>101</error_number>
<language_obj>426</language_obj>
<error_summary_description>Cannot delete &amp;1 because &amp;2 exists!</error_summary_description>
<error_full_description>Cannot delete &amp;1 because &amp;2 exists!</error_full_description>
<error_obj>276</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="44"><contained_record DB="ICFDB" Table="gsc_error"><error_group>AF </error_group>
<error_number>102</error_number>
<language_obj>426</language_obj>
<error_summary_description>Cannot create &amp;1 because &amp;2 does not exist ! &amp;3</error_summary_description>
<error_full_description>Cannot create &amp;1 because &amp;2 does not exist ! &amp;3</error_full_description>
<error_obj>277</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="45"><contained_record DB="ICFDB" Table="gsc_error"><error_group>AF </error_group>
<error_number>103</error_number>
<language_obj>426</language_obj>
<error_summary_description>Cannot update &amp;1 because &amp;2 does not exist !</error_summary_description>
<error_full_description>Cannot update &amp;1 because &amp;2 does not exist !</error_full_description>
<error_obj>278</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="46"><contained_record DB="ICFDB" Table="gsc_error"><error_group>AF</error_group>
<error_number>104</error_number>
<language_obj>426</language_obj>
<error_summary_description>Cannot &amp;1 - it is locked by another user !</error_summary_description>
<error_full_description>Cannot &amp;1 - it is locked by another user ! This only normally happens when a standard lock message appears and you choose CANCEL to stop waiting. Pressing CANCEL undoes all the updates and you must re-perform the action that you aborted. If the lock occurs again, try waiting a little longer to see if the record gets freed on its own. If it does not, then contact the system administrator and report the locking conflicts as a potential problem.</error_full_description>
<error_obj>105031</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="47"><contained_record DB="ICFDB" Table="gsc_error"><error_group>AF</error_group>
<error_number>105</error_number>
<language_obj>426</language_obj>
<error_summary_description>Deletion of &amp;1 records is not allowed by the system !</error_summary_description>
<error_full_description>Cannot delete &amp;1 ! To disallow further use, set a stop date, disabled flag, etc. as appropriate. If you need to actually delete the record, then please contact your system administrator.



</error_full_description>
<error_obj>105342</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="48"><contained_record DB="ICFDB" Table="gsc_error"><error_group>AF</error_group>
<error_number>106</error_number>
<language_obj>426</language_obj>
<error_summary_description>Cannot delete &amp;1 because the current status is &amp;2!</error_summary_description>
<error_full_description>Cannot delete &amp;1 because the current status is &amp;2!</error_full_description>
<error_obj>250139</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="49"><contained_record DB="ICFDB" Table="gsc_error"><error_group>AF</error_group>
<error_number>107</error_number>
<language_obj>426</language_obj>
<error_summary_description>Cannot update both &amp;1 and &amp;2.</error_summary_description>
<error_full_description>Cannot update both &amp;1 and &amp;2.

The program you are using is trying to update two mutually exclusive fields. This implies a design problem in the user interface. Contact your system administrator.</error_full_description>
<error_obj>1004870631.09</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="50"><contained_record DB="ICFDB" Table="gsc_error"><error_group>AF</error_group>
<error_number>108</error_number>
<language_obj>426</language_obj>
<error_summary_description>The &amp;1 succeeded. &amp;2</error_summary_description>
<error_full_description>The &amp;1 succeeded. &amp;2</error_full_description>
<error_obj>1004867356.09</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="51"><contained_record DB="ICFDB" Table="gsc_error"><error_group>AF</error_group>
<error_number>109</error_number>
<language_obj>426</language_obj>
<error_summary_description>If the &amp;1 is true, the &amp;2 must also be true.</error_summary_description>
<error_full_description>If the &amp;1 is true, the &amp;2 must also be true.</error_full_description>
<error_obj>1004910210.09</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="52"><contained_record DB="ICFDB" Table="gsc_error"><error_group>AF</error_group>
<error_number>110</error_number>
<language_obj>426</language_obj>
<error_summary_description>The &amp;1 and the &amp;2 must be the same.</error_summary_description>
<error_full_description>The &amp;1 and the &amp;2 must be the same.</error_full_description>
<error_obj>1004926886.09</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="53"><contained_record DB="ICFDB" Table="gsc_error"><error_group>AF</error_group>
<error_number>111</error_number>
<language_obj>426</language_obj>
<error_summary_description>The &amp;1 should be the same as existing &amp;2 for this &amp;3 and &amp;4.</error_summary_description>
<error_full_description>The &amp;1 should be the same as existing &amp;2 for this &amp;3 and &amp;4.</error_full_description>
<error_obj>1004896191.09</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="54"><contained_record DB="ICFDB" Table="gsc_error"><error_group>AF</error_group>
<error_number>112</error_number>
<language_obj>426</language_obj>
<error_summary_description>The &amp;1 cannot contain the &amp;2 keyword.</error_summary_description>
<error_full_description>The &amp;1 cannot contain the &amp;2 keyword.</error_full_description>
<error_obj>1004935528.09</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="55"><contained_record DB="ICFDB" Table="gsc_error"><error_group>AF</error_group>
<error_number>113</error_number>
<language_obj>426</language_obj>
<error_summary_description>The syntax of the dynamic query is invalid.</error_summary_description>
<error_full_description>The query :
"&amp;1" 

failed to compile due to the following errors:
&amp;2</error_full_description>
<error_obj>1004936844.09</error_obj>
<update_error_log>yes</update_error_log>
<error_type>WAR</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="56"><contained_record DB="ICFDB" Table="gsc_error"><error_group>AF</error_group>
<error_number>114</error_number>
<language_obj>426</language_obj>
<error_summary_description>Field references not valid for buffer &amp;1</error_summary_description>
<error_full_description>The field(s) &amp;2 were not found in buffer &amp;1.

Progress returned:
&amp;3</error_full_description>
<error_obj>1004936853.09</error_obj>
<update_error_log>no</update_error_log>
<error_type>WAR</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="57"><contained_record DB="ICFDB" Table="gsc_error"><error_group>AF</error_group>
<error_number>116</error_number>
<language_obj>426</language_obj>
<error_summary_description>Unable to build dataset &amp;1.</error_summary_description>
<error_full_description>The dataset generation procedure was unable to build the dataset &amp;1. The reasons are listed below.</error_full_description>
<error_obj>1004937063.09</error_obj>
<update_error_log>no</update_error_log>
<error_type>WAR</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="58"><contained_record DB="ICFDB" Table="gsc_error"><error_group>AF</error_group>
<error_number>117</error_number>
<language_obj>426</language_obj>
<error_summary_description>Unable to &amp;1 XML document &amp;2</error_summary_description>
<error_full_description>The application was unable to &amp;1 the XML document &amp;2. 

Progress returned the following errors:
&amp;3</error_full_description>
<error_obj>1004938198.09</error_obj>
<update_error_log>no</update_error_log>
<error_type>WAR</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="59"><contained_record DB="ICFDB" Table="gsc_error"><error_group>AF</error_group>
<error_number>118</error_number>
<language_obj>426</language_obj>
<error_summary_description>Viewer Link Name cannot be GroupAssign.</error_summary_description>
<error_full_description>The Viewer Link Name can only be GroupAssign when One-to-One Update in SBO is checked.</error_full_description>
<error_obj>1004938474.09</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="60"><contained_record DB="ICFDB" Table="gsc_error"><error_group>AF</error_group>
<error_number>119</error_number>
<language_obj>426</language_obj>
<error_summary_description>Unable to build temp-table structure for table &amp;1</error_summary_description>
<error_full_description>The temp-table structure for table &amp;1 could not be built.

Progress returned the following errors from the TEMP-TABLE-PREPARE method:
&amp;2
</error_full_description>
<error_obj>1004938475.09</error_obj>
<update_error_log>no</update_error_log>
<error_type>WAR</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="61"><contained_record DB="ICFDB" Table="gsc_error"><error_group>AF</error_group>
<error_number>120</error_number>
<language_obj>426</language_obj>
<error_summary_description>Only one or all of the Data Source Names can be Update Targets.</error_summary_description>
<error_full_description>A viewer normally updates only one SDO of an SBO.  When updating multiple SDOs of an SBO (one-to-one) all SDOs need to be defined as update targets.  

</error_full_description>
<error_obj>1004938476.09</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="62"><contained_record DB="ICFDB" Table="gsc_error"><error_group>AF</error_group>
<error_number>121</error_number>
<language_obj>426</language_obj>
<error_summary_description>Update Target Names must match one or all Data Source Names.</error_summary_description>
<error_full_description>A viewer normally updates only one SDO of an SBO.  When updating multiple SDOs of an SBO (one-to-one) all SDOs need to be defined as update targets.</error_full_description>
<error_obj>1004943079.09</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="63"><contained_record DB="ICFDB" Table="gsc_error"><error_group>AF</error_group>
<error_number>122</error_number>
<language_obj>426</language_obj>
<error_summary_description>Unable to load &amp;1 node in XML file: &amp;2</error_summary_description>
<error_full_description>Unable to load &amp;1 node in XML file: &amp;2</error_full_description>
<error_obj>1004943408.09</error_obj>
<update_error_log>no</update_error_log>
<error_type>WAR</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="64"><contained_record DB="ICFDB" Table="gsc_error"><error_group>AF</error_group>
<error_number>123</error_number>
<language_obj>426</language_obj>
<error_summary_description>XML/ADO file &amp;1 is invalid</error_summary_description>
<error_full_description>The data contained in the XML/ADO file &amp;1 cannot be read as the XML file has an invalid format. The &amp;2 is invalid.</error_full_description>
<error_obj>1004946674.09</error_obj>
<update_error_log>no</update_error_log>
<error_type>WAR</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="65"><contained_record DB="ICFDB" Table="gsc_error"><error_group>AF</error_group>
<error_number>124</error_number>
<language_obj>426</language_obj>
<error_summary_description>Unable to create ICFCONFIG file. &amp;1</error_summary_description>
<error_full_description>The framework was unable to create the ICFCONFIG file requested. The framework returned the following message:

&amp;1</error_full_description>
<error_obj>1004955997.09</error_obj>
<update_error_log>no</update_error_log>
<error_type>WAR</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="66"><contained_record DB="ICFDB" Table="gsc_error"><error_group>AF</error_group>
<error_number>125</error_number>
<language_obj>426</language_obj>
<error_summary_description>The Host, Name Service and AppService are all required.</error_summary_description>
<error_full_description>The Host, Name Service and AppService are all required for Regular Physical Service connections.</error_full_description>
<error_obj>1004956039.09</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="67"><contained_record DB="ICFDB" Table="gsc_error"><error_group>AF</error_group>
<error_number>126</error_number>
<language_obj>426</language_obj>
<error_summary_description>The AppServer URL is required.</error_summary_description>
<error_full_description>The AppServer URL is required for URL Physical Service connections.</error_full_description>
<error_obj>1004956055.09</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="68"><contained_record DB="ICFDB" Table="gsc_error"><error_group>AF</error_group>
<error_number>127</error_number>
<language_obj>426</language_obj>
<error_summary_description>The Host, Name Service, AppService and AppServer URL are all required.</error_summary_description>
<error_full_description>The Host, Name Service, AppService and AppServer URL are all required for Decide At Run-time Physical Service connections.</error_full_description>
<error_obj>1004956056.09</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="69"><contained_record DB="ICFDB" Table="gsc_error"><error_group>AF</error_group>
<error_number>128</error_number>
<language_obj>426</language_obj>
<error_summary_description>The Broker URL is required.</error_summary_description>
<error_full_description>The Broker URL is required.</error_full_description>
<error_obj>1004956063.09</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="70"><contained_record DB="ICFDB" Table="gsc_error"><error_group>AF</error_group>
<error_number>129</error_number>
<language_obj>426</language_obj>
<error_summary_description>The Physical Database Name is required.</error_summary_description>
<error_full_description>The Physical Database Name is required.</error_full_description>
<error_obj>1004956064.09</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="71"><contained_record DB="ICFDB" Table="gsc_error"><error_group>AF</error_group>
<error_number>130</error_number>
<language_obj>426</language_obj>
<error_summary_description>The Network Type, Host, and Service are all required.</error_summary_description>
<error_full_description>The Network Type, Host, and Service are all required if any one of them is specified.
</error_full_description>
<error_obj>1004956065.09</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="72"><contained_record DB="ICFDB" Table="gsc_error"><error_group>CR</error_group>
<error_number>20500</error_number>
<language_obj>426</language_obj>
<error_summary_description>There is not enough memory available to complete the call.</error_summary_description>
<error_full_description>Not enough memory for operation, or not enough memory to get selection formula or cannot get selection formula.</error_full_description>
<error_obj>175262</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="73"><contained_record DB="ICFDB" Table="gsc_error"><error_group>CR</error_group>
<error_number>20501</error_number>
<language_obj>426</language_obj>
<error_summary_description>Internal error.</error_summary_description>
<error_full_description>Invalid job number.</error_full_description>
<error_obj>175263</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="74"><contained_record DB="ICFDB" Table="gsc_error"><error_group>CR</error_group>
<error_number>20502</error_number>
<language_obj>426</language_obj>
<error_summary_description>You have specified an MDI form as the parent of a print window.</error_summary_description>
<error_full_description>Invalid handle, or parent window cannot be an MDI form, or invalid parent window handle.</error_full_description>
<error_obj>175264</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="75"><contained_record DB="ICFDB" Table="gsc_error"><error_group>CR</error_group>
<error_number>20503</error_number>
<language_obj>426</language_obj>
<error_summary_description>Internal error.</error_summary_description>
<error_full_description>Buffer too small for string.</error_full_description>
<error_obj>175265</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="76"><contained_record DB="ICFDB" Table="gsc_error"><error_group>CR</error_group>
<error_number>20504</error_number>
<language_obj>426</language_obj>
<error_summary_description>Report not found.</error_summary_description>
<error_full_description>You have specified a form that does not exist.</error_full_description>
<error_obj>175266</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="77"><contained_record DB="ICFDB" Table="gsc_error"><error_group>CR</error_group>
<error_number>20505</error_number>
<language_obj>426</language_obj>
<error_summary_description>No print destination specified or invalid print destination.</error_summary_description>
<error_full_description>Print destination must be 0, 1 or 2. You have specified a print destination other than one of these values.</error_full_description>
<error_obj>175267</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="78"><contained_record DB="ICFDB" Table="gsc_error"><error_group>CR</error_group>
<error_number>20506</error_number>
<language_obj>426</language_obj>
<error_summary_description>Invalid file number.</error_summary_description>
<error_full_description>You have tried to set an N-th file name and the file number you specified is out of the existing range: 0 &lt;= fileN &lt; N files</error_full_description>
<error_obj>175268</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="79"><contained_record DB="ICFDB" Table="gsc_error"><error_group>CR</error_group>
<error_number>20507</error_number>
<language_obj>426</language_obj>
<error_summary_description>Invalid filename.</error_summary_description>
<error_full_description>There is an error in the file name you specified.</error_full_description>
<error_obj>175269</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="80"><contained_record DB="ICFDB" Table="gsc_error"><error_group>CR</error_group>
<error_number>20508</error_number>
<language_obj>426</language_obj>
<error_summary_description>Internal error.</error_summary_description>
<error_full_description>Invalid field number.</error_full_description>
<error_obj>175270</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="81"><contained_record DB="ICFDB" Table="gsc_error"><error_group>CR</error_group>
<error_number>20509</error_number>
<language_obj>426</language_obj>
<error_summary_description>Invalid field name.</error_summary_description>
<error_full_description>You specified an invalid database field for a sort field. The program cannot add the sort field name you specified.</error_full_description>
<error_obj>175271</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="82"><contained_record DB="ICFDB" Table="gsc_error"><error_group>CR</error_group>
<error_number>20510</error_number>
<language_obj>426</language_obj>
<error_summary_description>Invalid formula name.</error_summary_description>
<error_full_description>The formula name you specified is invalid or non-existent.</error_full_description>
<error_obj>175272</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="83"><contained_record DB="ICFDB" Table="gsc_error"><error_group>CR</error_group>
<error_number>20511</error_number>
<language_obj>426</language_obj>
<error_summary_description>Internal error.</error_summary_description>
<error_full_description>Invalid sort direction.</error_full_description>
<error_obj>175273</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="84"><contained_record DB="ICFDB" Table="gsc_error"><error_group>CR</error_group>
<error_number>20512</error_number>
<language_obj>426</language_obj>
<error_summary_description>Internal error.</error_summary_description>
<error_full_description>Print engine not open.</error_full_description>
<error_obj>175274</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="85"><contained_record DB="ICFDB" Table="gsc_error"><error_group>CR</error_group>
<error_number>20513</error_number>
<language_obj>426</language_obj>
<error_summary_description>Invalid printer.</error_summary_description>
<error_full_description>The printer driver for the printer you specified is missing.</error_full_description>
<error_obj>175275</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="86"><contained_record DB="ICFDB" Table="gsc_error"><error_group>CR</error_group>
<error_number>20514</error_number>
<language_obj>426</language_obj>
<error_summary_description>Print file exists.</error_summary_description>
<error_full_description>The name you have specified for the print file already exists. You must delete the file and print again, or specify a different file.</error_full_description>
<error_obj>175276</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="87"><contained_record DB="ICFDB" Table="gsc_error"><error_group>CR</error_group>
<error_number>20515</error_number>
<language_obj>426</language_obj>
<error_summary_description>Error in formula.</error_summary_description>
<error_full_description>There is a formula error in the replacement formula text. Review the formula syntax and retry.</error_full_description>
<error_obj>175277</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="88"><contained_record DB="ICFDB" Table="gsc_error"><error_group>CR</error_group>
<error_number>20517</error_number>
<language_obj>426</language_obj>
<error_summary_description>Internal error.</error_summary_description>
<error_full_description>Print engine already in use.</error_full_description>
<error_obj>175278</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="89"><contained_record DB="ICFDB" Table="gsc_error"><error_group>CR</error_group>
<error_number>20520</error_number>
<language_obj>426</language_obj>
<error_summary_description>Print job already started.</error_summary_description>
<error_full_description>You are trying to start a print job that has already been started. This can happen if a user starts a print job, and then tries to start printing again before the previous printing has finished.
(Programmer's note: Disable the form while action is in progress, and re-enable the form once action is complete. This will help avoid the conflict that generates this error.)</error_full_description>
<error_obj>175279</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="90"><contained_record DB="ICFDB" Table="gsc_error"><error_group>CR</error_group>
<error_number>20521</error_number>
<language_obj>426</language_obj>
<error_summary_description>Invalid summary field.</error_summary_description>
<error_full_description>Invalid summary field.The summary field specified as a group sort field is invalid or non-existent.</error_full_description>
<error_obj>175280</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="91"><contained_record DB="ICFDB" Table="gsc_error"><error_group>CR</error_group>
<error_number>20522</error_number>
<language_obj>426</language_obj>
<error_summary_description>Not enough system resources.</error_summary_description>
<error_full_description>There are not enough Windows system resources to process the function.</error_full_description>
<error_obj>175281</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="92"><contained_record DB="ICFDB" Table="gsc_error"><error_group>CR</error_group>
<error_number>20524</error_number>
<language_obj>426</language_obj>
<error_summary_description>Print job busy.</error_summary_description>
<error_full_description>You tried to initiate printing while Crystal Reports is already rprinting a job.
(Programmers' Note: Disable the form while action is in progress and re-enable the form once action is complete. This will help avoid the conflict that generates this message.)</error_full_description>
<error_obj>175282</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="93"><contained_record DB="ICFDB" Table="gsc_error"><error_group>CR</error_group>
<error_number>20525</error_number>
<language_obj>426</language_obj>
<error_summary_description>Unable to load report.</error_summary_description>
<error_full_description>There is something wrong with the report you are trying to open.</error_full_description>
<error_obj>175283</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="94"><contained_record DB="ICFDB" Table="gsc_error"><error_group>CR</error_group>
<error_number>20526</error_number>
<language_obj>426</language_obj>
<error_summary_description>No default printer.</error_summary_description>
<error_full_description>You haven't specified a default printer. Specify a default print via the Windows Control Panel.</error_full_description>
<error_obj>175284</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="95"><contained_record DB="ICFDB" Table="gsc_error"><error_group>CR</error_group>
<error_number>20527</error_number>
<language_obj>426</language_obj>
<error_summary_description>SQL server error.</error_summary_description>
<error_full_description>There is a problem connecting with the SQL server.</error_full_description>
<error_obj>175285</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="96"><contained_record DB="ICFDB" Table="gsc_error"><error_group>CR</error_group>
<error_number>20529</error_number>
<language_obj>426</language_obj>
<error_summary_description>Disk full.</error_summary_description>
<error_full_description>When printing to file or when sorting, the program requires more room than is available on the disk.</error_full_description>
<error_obj>175288</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="97"><contained_record DB="ICFDB" Table="gsc_error"><error_group>CR</error_group>
<error_number>20530</error_number>
<language_obj>426</language_obj>
<error_summary_description>File I/O error.</error_summary_description>
<error_full_description>In trying to print to file, the program is encountering another file problem besides disk full.</error_full_description>
<error_obj>175289</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="98"><contained_record DB="ICFDB" Table="gsc_error"><error_group>CR</error_group>
<error_number>20531</error_number>
<language_obj>426</language_obj>
<error_summary_description>Incorrect password.</error_summary_description>
<error_full_description>You have specified an incorrect password.</error_full_description>
<error_obj>175290</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="99"><contained_record DB="ICFDB" Table="gsc_error"><error_group>CR</error_group>
<error_number>20532</error_number>
<language_obj>426</language_obj>
<error_summary_description>Missing database DLL.</error_summary_description>
<error_full_description>The database DLL is corrupt.</error_full_description>
<error_obj>175291</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="100"><contained_record DB="ICFDB" Table="gsc_error"><error_group>CR</error_group>
<error_number>20533</error_number>
<language_obj>426</language_obj>
<error_summary_description>Unable to open database file.</error_summary_description>
<error_full_description>Something is wrong with the database you have specified. You may need to verify using the Database </error_full_description>
<error_obj>175292</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="101"><contained_record DB="ICFDB" Table="gsc_error"><error_group>CR</error_group>
<error_number>20534</error_number>
<language_obj>426</language_obj>
<error_summary_description>Error detected by database DLL.
</error_summary_description>
<error_full_description>The database DLL is corrupt.
</error_full_description>
<error_obj>175293</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="102"><contained_record DB="ICFDB" Table="gsc_error"><error_group>CR</error_group>
<error_number>20535</error_number>
<language_obj>426</language_obj>
<error_summary_description>Unable to connect: incorrect session parameters.</error_summary_description>
<error_full_description>You have attempted to log on using incomplete or incorrect session parameters.</error_full_description>
<error_obj>175294</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="103"><contained_record DB="ICFDB" Table="gsc_error"><error_group>CR</error_group>
<error_number>20536</error_number>
<language_obj>426</language_obj>
<error_summary_description>Unable to connect: incorrect log on parameters.</error_summary_description>
<error_full_description>You have attempted to log on using incomplete or incorrect session parameters.</error_full_description>
<error_obj>175295</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="104"><contained_record DB="ICFDB" Table="gsc_error"><error_group>CR</error_group>
<error_number>20537</error_number>
<language_obj>426</language_obj>
<error_summary_description>Unable to connect: incorrect table location.</error_summary_description>
<error_full_description>The table you have specified cannot be found.</error_full_description>
<error_obj>175296</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="105"><contained_record DB="ICFDB" Table="gsc_error"><error_group>CR</error_group>
<error_number>20538</error_number>
<language_obj>426</language_obj>
<error_summary_description>Internal error.
</error_summary_description>
<error_full_description>Parameter has invalid structure size.</error_full_description>
<error_obj>175297</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="106"><contained_record DB="ICFDB" Table="gsc_error"><error_group>CR</error_group>
<error_number>20599</error_number>
<language_obj>426</language_obj>
<error_summary_description>Internal error.</error_summary_description>
<error_full_description>Check that your ODBC settings are correct and that your network connection is working.</error_full_description>
<error_obj>250140</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="107"><contained_record DB="ICFDB" Table="gsc_error"><error_group>CR</error_group>
<error_number>20999</error_number>
<language_obj>426</language_obj>
<error_summary_description>Internal error.</error_summary_description>
<error_full_description>Operation not yet implemented.</error_full_description>
<error_obj>175298</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="108"><contained_record DB="ICFDB" Table="gsc_error"><error_group>GS</error_group>
<error_number>1</error_number>
<language_obj>426</language_obj>
<error_summary_description>This object uses a menu structure and so must be a container</error_summary_description>
<error_full_description>This object uses a menu structure and so must be a container</error_full_description>
<error_obj>279</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="109"><contained_record DB="ICFDB" Table="gsc_error"><error_group>GS</error_group>
<error_number>2</error_number>
<language_obj>426</language_obj>
<error_summary_description>Profile flag must be YES because users are based on this profile.</error_summary_description>
<error_full_description>The user profile flag must be YES because users exist that are based on this profile user. To disable this user as a profile user, you must first change all users based on this user to be based on a different profile user.</error_full_description>
<error_obj>280</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="110"><contained_record DB="ICFDB" Table="gsc_error"><error_group>GS</error_group>
<error_number>3</error_number>
<language_obj>426</language_obj>
<error_summary_description>Password must be at least &amp;1 characters.</error_summary_description>
<error_full_description>Password must be at least &amp;1 characters.</error_full_description>
<error_obj>281</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="111"><contained_record DB="ICFDB" Table="gsc_error"><error_group>GS</error_group>
<error_number>4</error_number>
<language_obj>426</language_obj>
<error_summary_description>The same password cannot be used within &amp;1 days.</error_summary_description>
<error_full_description>The password entered exists in the password history for this user within the password lifetime parameter setting of &amp;1 days. Please select a different password.</error_full_description>
<error_obj>282</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="112"><contained_record DB="ICFDB" Table="gsc_error"><error_group>GS</error_group>
<error_number>5</error_number>
<language_obj>426</language_obj>
<error_summary_description>Only a radio-set may contain a widget entry number > 1.</error_summary_description>
<error_full_description>Only a radio-set may contain a widget entry number > 1. The widget entry number corresponds to the label number in the radio-set list.</error_full_description>
<error_obj>283</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="113"><contained_record DB="ICFDB" Table="gsc_error"><error_group>GS</error_group>
<error_number>6</error_number>
<language_obj>426</language_obj>
<error_summary_description>The date of birth must be within the last &amp;1 years.</error_summary_description>
<error_full_description>The date of birth must be earlier than today's date, and not more than &amp;1 years ago.</error_full_description>
<error_obj>284</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="114"><contained_record DB="ICFDB" Table="gsc_error"><error_group>GS</error_group>
<error_number>7</error_number>
<language_obj>426</language_obj>
<error_summary_description>Another person was found with the same ID type and number.</error_summary_description>
<error_full_description>Another person was found with the same ID type and number.The ID number must be unique within this ID type.</error_full_description>
<error_obj>285</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="115"><contained_record DB="ICFDB" Table="gsc_error"><error_group>GS</error_group>
<error_number>8</error_number>
<language_obj>426</language_obj>
<error_summary_description>&amp;1 is an invalid country. Failed Clavis validation.</error_summary_description>
<error_full_description>&amp;1 is not a valid country in the Clavis data files. Valid countries are:&amp;2.</error_full_description>
<error_obj>286</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="116"><contained_record DB="ICFDB" Table="gsc_error"><error_group>GS</error_group>
<error_number>9</error_number>
<language_obj>426</language_obj>
<error_summary_description>This role is not valid for this organisation.</error_summary_description>
<error_full_description>This role is not valid for this organisation.Role = &amp;1Organisation = &amp;2</error_full_description>
<error_obj>315</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="117"><contained_record DB="ICFDB" Table="gsc_error"><error_group>GS</error_group>
<error_number>10</error_number>
<language_obj>426</language_obj>
<error_summary_description>Unable to look up &amp;1 as no &amp;2 has been entered.</error_summary_description>
<error_full_description>Unable to look up &amp;1 as no &amp;2 has been entered.</error_full_description>
<error_obj>316</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="118"><contained_record DB="ICFDB" Table="gsc_error"><error_group>GS</error_group>
<error_number>11</error_number>
<language_obj>426</language_obj>
<error_summary_description>Please specify a unique password</error_summary_description>
<error_full_description>This password is already in use.  The system requires that the user's password is unique to the system.</error_full_description>
<error_obj>317</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="119"><contained_record DB="ICFDB" Table="gsc_error"><error_group>GS</error_group>
<error_number>12</error_number>
<language_obj>426</language_obj>
<error_summary_description>Access denied - Log in using a valid company.</error_summary_description>
<error_full_description>Access denied - Log in using a valid company. This procedure requires that you log into a valid login organisation. Please re-logon, specifying a valid company to continue.</error_full_description>
<error_obj>1003699845</error_obj>
<update_error_log>no</update_error_log>
<error_type>ERR</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="120"><contained_record DB="ICFDB" Table="gsc_error"><error_group>ICF</error_group>
<error_number>1</error_number>
<language_obj>426</language_obj>
<error_summary_description>Unable to obtain handle to buffer &amp;1</error_summary_description>
<error_full_description>The session was unable to obtain a handle to a buffer object for the table &amp;1.</error_full_description>
<error_obj>1005079049.09</error_obj>
<update_error_log>no</update_error_log>
<error_type>WAR</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="121"><contained_record DB="ICFDB" Table="gsc_error"><error_group>ICF</error_group>
<error_number>2</error_number>
<language_obj>426</language_obj>
<error_summary_description>No record available in buffer &amp;1</error_summary_description>
<error_full_description>There is no record available in the &amp;1 buffer where it is expected that the record would already have been found.</error_full_description>
<error_obj>1005079050.09</error_obj>
<update_error_log>no</update_error_log>
<error_type>WAR</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="122"><contained_record DB="ICFDB" Table="gsc_error"><error_group>ICF</error_group>
<error_number>3</error_number>
<language_obj>426</language_obj>
<error_summary_description>Field &amp;1 could not be found in buffer &amp;2</error_summary_description>
<error_full_description>A BUFFER-FIELD called &amp;1 could not be found in the &amp;2 buffer. No handle to the field &amp;1 could therefore not be obtained.</error_full_description>
<error_obj>1005079051.09</error_obj>
<update_error_log>no</update_error_log>
<error_type>WAR</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="123"><contained_record DB="ICFDB" Table="gsc_error"><error_group>RV</error_group>
<error_number>1</error_number>
<language_obj>426</language_obj>
<error_summary_description>No current transaction context exists for database alias &amp;1. &amp;2</error_summary_description>
<error_full_description>No current transaction context exists for database alias &amp;1. &amp;2</error_full_description>
<error_obj>1003021328</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="124"><contained_record DB="ICFDB" Table="gsc_error"><error_group>RV</error_group>
<error_number>2</error_number>
<language_obj>426</language_obj>
<error_summary_description>Attempt to modify items outside the context of a specific workspace. &amp;1</error_summary_description>
<error_full_description>Attempt to modify items outside the context of a specific workspace. &amp;1</error_full_description>
<error_obj>1003021329</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="125"><contained_record DB="ICFDB" Table="gsc_error"><error_group>RV</error_group>
<error_number>3</error_number>
<language_obj>426</language_obj>
<error_summary_description>Attempt to modify items in workspace &amp;1 which is not registered. &amp;2</error_summary_description>
<error_full_description>Attempt to modify items in workspace &amp;1 which is not registered. &amp;2</error_full_description>
<error_obj>1003021330</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="126"><contained_record DB="ICFDB" Table="gsc_error"><error_group>RV</error_group>
<error_number>4</error_number>
<language_obj>426</language_obj>
<error_summary_description>Attempt to modify items in workspace &amp;1 which is currently locked. &amp;2</error_summary_description>
<error_full_description>Attempt to modify items in workspace &amp;1 which is currently locked. &amp;2</error_full_description>
<error_obj>1003021331</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="127"><contained_record DB="ICFDB" Table="gsc_error"><error_group>RV</error_group>
<error_number>5</error_number>
<language_obj>426</language_obj>
<error_summary_description>Attempt to modify items outside the context of a specific task. &amp;2</error_summary_description>
<error_full_description>Attempt to modify items outside the context of a specific task. &amp;2

The Versioning system was unable to obtain details of your currently selected task from Roundtable.</error_full_description>
<error_obj>1003021332</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="128"><contained_record DB="ICFDB" Table="gsc_error"><error_group>RV</error_group>
<error_number>6</error_number>
<language_obj>426</language_obj>
<error_summary_description>Attempt to modify item within workspace &amp;1 under task &amp;2, when that workspace is currently checked out under task &amp;3. &amp;4</error_summary_description>
<error_full_description>Attempt to modify item within workspace &amp;1 under task &amp;2, when that workspace is currently checked out under task &amp;3. &amp;4</error_full_description>
<error_obj>1003021333</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="129"><contained_record DB="ICFDB" Table="gsc_error"><error_group>RV</error_group>
<error_number>7</error_number>
<language_obj>426</language_obj>
<error_summary_description>Attempt to modify an element of item &amp;1 which is not a recognised Configuratino Type. &amp;2</error_summary_description>
<error_full_description>Attempt to modify an element of item &amp;1 which is not a recognised Configuration Type. &amp;2

A replication trigger on Table-A has invoked Versioning with a primary FLA corresponding to Table-B.  This primary FLA is not present in the Configuration Type table.</error_full_description>
<error_obj>1003021334</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="130"><contained_record DB="ICFDB" Table="gsc_error"><error_group>RV</error_group>
<error_number>8</error_number>
<language_obj>426</language_obj>
<error_summary_description>Attempt to modify item of configuration type &amp;1 which is currently locked. &amp;2</error_summary_description>
<error_full_description>Attempt to modify item of configuration type &amp;1 which is currently locked. &amp;2

When the Configuration Type is locked no modifications to items of that type are permitted.  </error_full_description>
<error_obj>1003021335</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="131"><contained_record DB="ICFDB" Table="gsc_error"><error_group>RV</error_group>
<error_number>9</error_number>
<language_obj>426</language_obj>
<error_summary_description>Attempt to modify item of Configuration Type &amp;1 under task &amp;2, when that Configuration Type is currently checked out under task &amp;3. &amp;4</error_summary_description>
<error_full_description>Attempt to modify item of Configuration Type &amp;1 under task &amp;2, when that Configuration Type is currently checked out under task &amp;3. &amp;4

The Configuration Type has been checked out under a task.  Items of that Configuration Type can only be modifies under this task, until such time as it is checked in again.</error_full_description>
<error_obj>1003021345</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="132"><contained_record DB="ICFDB" Table="gsc_error"><error_group>RV</error_group>
<error_number>10</error_number>
<language_obj>426</language_obj>
<error_summary_description>Attempt to create item &amp;1 with key &amp;2 which already exists in workspace &amp;3. &amp;4</error_summary_description>
<error_full_description>Attempt to create item &amp;1 with key &amp;2 which already exists in workspace &amp;3. &amp;4

Your attempt to create a new item in the workspace has been rejected because the Versioning system believe that the item already exists.  This would appear to indicate that the Versioning system is out of step with the data actually present in your workspace: the duplicate creation should have been detected within your workspace (by the WRITE trigger) prior to it being registered in the Versioning system (by the REPLICATION-WRITE trigger).</error_full_description>
<error_obj>1003021425</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="133"><contained_record DB="ICFDB" Table="gsc_error"><error_group>RV</error_group>
<error_number>11</error_number>
<language_obj>426</language_obj>
<error_summary_description>Attempt to modify item &amp;1 with key &amp;2 which does not exist in workspace &amp;3. &amp;4</error_summary_description>
<error_full_description>Attempt to modify item &amp;1 with key &amp;2 which does not exist in workspace &amp;3. &amp;4

This error may indicate that the Versioning system is out of step with the data actually in your workspace.  Alternatively it may indicate timing errors in that REPLICATION-WRITE triggers for the item are firing before the REPLICATION-CREATE trigger.</error_full_description>
<error_obj>1003021426</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="134"><contained_record DB="ICFDB" Table="gsc_error"><error_group>RV</error_group>
<error_number>12</error_number>
<language_obj>426</language_obj>
<error_summary_description>Attempt to modify item &amp;1 with key &amp;2 under task &amp;3 when that item is currently checked out under task &amp;4. &amp;5</error_summary_description>
<error_full_description>Attempt to modify item &amp;1 with key &amp;2 under task &amp;3 when that item is currently checked out under task &amp;4. &amp;5

Modifications to an item are only permitted within the same task as that under which the item is currently checked-out.  </error_full_description>
<error_obj>1003021428</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="135"><contained_record DB="ICFDB" Table="gsc_error"><error_group>RV</error_group>
<error_number>13</error_number>
<language_obj>426</language_obj>
<error_summary_description>Attempt to modify item checked out with an invalid modification type of &amp;1.  Valid modification types are VER, REV, PAT or UNK. &amp;4</error_summary_description>
<error_full_description>Attempt to modify item checked out with an invalid modification type of &amp;1.  Valid modification types are VER, REV, PAT or UNK.

There is an error in the check out record for this item.  The modification type indicates which element of the version number will be incremented.  The checkout record has an invalid modification type.</error_full_description>
<error_obj>1003021429</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="136"><contained_record DB="ICFDB" Table="gsc_error"><error_group>RV</error_group>
<error_number>14</error_number>
<language_obj>426</language_obj>
<error_summary_description>Unable to identify Product Module for a new Configuration Item of Configuration Type &amp;1. &amp;2</error_summary_description>
<error_full_description>Unable to identify Product Module for a new Configuration Item of Configuration Type &amp;1. &amp;2

The product module is determined by either 
(a) examining the product_module_fieldname of the Configuration Type record and using the corresponding value in the primary table buffer, or
(b) using the default value contained in the product_module_obj field of the Configuration Type.

The error arose because both of these fields (product_module_fieldname and product_module_obj) are empty.</error_full_description>
<error_obj>1003032020</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="137"><contained_record DB="ICFDB" Table="gsc_error"><error_group>RV</error_group>
<error_number>15</error_number>
<language_obj>426</language_obj>
<error_summary_description>Attempt to check out an item with an SCM SubType of &amp;1.  However no COnfiguration Type record exists with an scm_code of &amp;1. &amp;2</error_summary_description>
<error_full_description>Attempt to check out an item with an SCM SubType of &amp;1.  However no COnfiguration Type record exists with an scm_code of &amp;1. &amp;2</error_full_description>
<error_obj>1003032105</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="138"><contained_record DB="ICFDB" Table="gsc_error"><error_group>RV</error_group>
<error_number>16</error_number>
<language_obj>426</language_obj>
<error_summary_description>Attempt to check out an item in workspace with scm_code &amp;1 which does not exist.</error_summary_description>
<error_full_description>Attempt to check out an item in workspace with scm_code &amp;1 which does not exist.</error_full_description>
<error_obj>1003032126</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="139"><contained_record DB="ICFDB" Table="gsc_error"><error_group>RV</error_group>
<error_number>17</error_number>
<language_obj>426</language_obj>
<error_summary_description>Attempt to checkout from workspace &amp;2 item with object name &amp;1, which does not exist.</error_summary_description>
<error_full_description>Attempt to checkout from workspace &amp;2 item with object name &amp;1, which does not exist.</error_full_description>
<error_obj>1003032128</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="140"><contained_record DB="ICFDB" Table="gsc_error"><error_group>RV</error_group>
<error_number>18</error_number>
<language_obj>426</language_obj>
<error_summary_description>Attempt to checkout from workspace &amp;3 item of subtype &amp;1 with object name &amp;2 which does not exist.</error_summary_description>
<error_full_description>Attempt to checkout from workspace &amp;3 item of subtype &amp;1 with object name &amp;2 which does not exist.</error_full_description>
<error_obj>1003032130</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="141"><contained_record DB="ICFDB" Table="gsc_error"><error_group>RV</error_group>
<error_number>19</error_number>
<language_obj>426</language_obj>
<error_summary_description>Error attempting to open dynamic query: &amp;1</error_summary_description>
<error_full_description>Error attempting to open dynamic query: 

&amp;1

The identifying object name (field &amp;2) could not be determined.</error_full_description>
<error_obj>1003183249</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="142"><contained_record DB="ICFDB" Table="gsc_error"><error_group>RV</error_group>
<error_number>20</error_number>
<language_obj>426</language_obj>
<error_summary_description>Error retrieving first record from dynamic query: &amp;1</error_summary_description>
<error_full_description>Error attempting to open dynamic query: 

&amp;1

The identifying object name (field &amp;2) could not be determined.</error_full_description>
<error_obj>1003183253</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="143"><contained_record DB="ICFDB" Table="gsc_error"><error_group>RV</error_group>
<error_number>21</error_number>
<language_obj>426</language_obj>
<error_summary_description>Attempt to delete object with name &amp;1 from workspace &amp;2 under task &amp;3 .  A deleted item record already exists for this item in the workspace, but under a different task.</error_summary_description>
<error_full_description>Attempt to delete object with name &amp;1 from workspace &amp;2 under task &amp;3.  A deleted item record already exists for this item in the workspace, but under a different task.</error_full_description>
<error_obj>1003183287</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="144"><contained_record DB="ICFDB" Table="gsc_error"><error_group>RV</error_group>
<error_number>22</error_number>
<language_obj>426</language_obj>
<error_summary_description>You cannot create data item for &amp;1 since this is already a configuration item in its own right.  Use your SCM tool to assign the item to this workspace.</error_summary_description>
<error_full_description>You cannot create data item for &amp;1 since this is already a configuration item in its own right.  Use your SCM tool to assign the item to this workspace.</error_full_description>
<error_obj>1003203002</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="145"><contained_record DB="ICFDB" Table="gsc_error"><error_group>RV</error_group>
<error_number>23</error_number>
<language_obj>426</language_obj>
<error_summary_description>Could not find Configuration Item with name &amp;1 and type &amp;2 when performing deletion checks.</error_summary_description>
<error_full_description>Could not find Configuration Item with name &amp;1 and type &amp;2 when performing deletion checks.</error_full_description>
<error_obj>1003223586</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="146"><contained_record DB="ICFDB" Table="gsc_error"><error_group>RV</error_group>
<error_number>24</error_number>
<language_obj>426</language_obj>
<error_summary_description>Attempt to modify an item with object name &amp;1 which is not checked out in workspace &amp;2.</error_summary_description>
<error_full_description>Attempt to modify an item with object name &amp;1 which is not checked out in workspace &amp;2.</error_full_description>
<error_obj>1003223702</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="147"><contained_record DB="ICFDB" Table="gsc_error"><error_group>RV</error_group>
<error_number>25</error_number>
<language_obj>426</language_obj>
<error_summary_description>Attempt to modify items within the context of task &amp;1 which is not an open task.</error_summary_description>
<error_full_description>Attempt to modify items within the context of task &amp;1 which is not an open task.</error_full_description>
<error_obj>1003223706</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="148"><contained_record DB="ICFDB" Table="gsc_error"><error_group>RV</error_group>
<error_number>26</error_number>
<language_obj>426</language_obj>
<error_summary_description>Attempt to create data corresponding to an object name &amp;1 which exists in your SCM tool but has not been assigned to workspace &amp;2.</error_summary_description>
<error_full_description>Attempt to create data corresponding to an object name &amp;1 which exists in your SCM tool but has not been assigned to workspace &amp;2.</error_full_description>
<error_obj>1003249904</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="149"><contained_record DB="ICFDB" Table="gsc_error"><error_group>RV</error_group>
<error_number>27</error_number>
<language_obj>426</language_obj>
<error_summary_description>Attempt to create data corresponding to an object named &amp;1 which is not checked out in your SCM tool under workspace &amp;2.</error_summary_description>
<error_full_description>Attempt to create data corresponding to an object named &amp;1 which is not checked out in your SCM tool under workspace &amp;2.</error_full_description>
<error_obj>1003249905</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="150"><contained_record DB="ICFDB" Table="gsc_error"><error_group>RV</error_group>
<error_number>28</error_number>
<language_obj>426</language_obj>
<error_summary_description>Attempt to create data corresponding to an object named &amp;1 under task &amp;2, when that object is checked out in your SCM toool under task &amp;3.</error_summary_description>
<error_full_description>Attempt to create data corresponding to an object named &amp;1 under task &amp;2, when that object is checked out in your SCM tool under task &amp;3.</error_full_description>
<error_obj>1003249906</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="151"><contained_record DB="ICFDB" Table="gsc_error"><error_group>RV</error_group>
<error_number>29</error_number>
<language_obj>426</language_obj>
<error_summary_description>Unable to escalate lock status to Exclusive for &amp;1 record.</error_summary_description>
<error_full_description>Unable to escalate lock status to Exclusive for &amp;1 record.

The record was found NO-LOCK, but the subsequent FIND CURRENT &amp;1 EXCLUSIVE-LOCK NO-WAIT has reported that the record was locked by another session.</error_full_description>
<error_obj>1003289550</error_obj>
<update_error_log>no</update_error_log>
<error_type>INF</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="152"><contained_record DB="ICFDB" Table="gsc_error"><error_group>RY</error_group>
<error_number>1</error_number>
<language_obj>426</language_obj>
<error_summary_description>Object &amp;1 is not defined in the repository.</error_summary_description>
<error_full_description>Object &amp;1 is not defined in the repository.</error_full_description>
<error_obj>1003496757</error_obj>
<update_error_log>no</update_error_log>
<error_type>ERR</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="153"><contained_record DB="ICFDB" Table="gsc_error"><error_group>RY</error_group>
<error_number>2</error_number>
<language_obj>426</language_obj>
<error_summary_description>The object name &amp;1 does not exist in the &amp;2 wizard table.</error_summary_description>
<error_full_description>The object name &amp;1 does not exist in the &amp;2 wizard table.</error_full_description>
<error_obj>1003596940</error_obj>
<update_error_log>no</update_error_log>
<error_type>ERR</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="154"><contained_record DB="ICFDB" Table="gsc_error"><error_group>RY</error_group>
<error_number>3</error_number>
<language_obj>426</language_obj>
<error_summary_description>The physical object name &amp;1 does not exist.</error_summary_description>
<error_full_description>The physical object name &amp;1 does not exist. This name is hard-coded in the wizard generation program ry/app/rywizogenp.p and so must exist in order to forward generate dynamic objects based on this generic object template.
</error_full_description>
<error_obj>1003597140</error_obj>
<update_error_log>no</update_error_log>
<error_type>ERR</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="155"><contained_record DB="ICFDB" Table="gsc_error"><error_group>RY</error_group>
<error_number>4</error_number>
<language_obj>426</language_obj>
<error_summary_description>The object type &amp;1 does not exist.</error_summary_description>
<error_full_description>The object type &amp;1 does not exist. This name is hard-coded in the wizard generation program ry/app/rywizogenp.p and so must exist in order to forward generate dynamic objects based on this object type.
</error_full_description>
<error_obj>1003597141</error_obj>
<update_error_log>no</update_error_log>
<error_type>ERR</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="156"><contained_record DB="ICFDB" Table="gsc_error"><error_group>RY</error_group>
<error_number>5</error_number>
<language_obj>426</language_obj>
<error_summary_description>Unsupported object type &amp;1 passed to forward generate program.</error_summary_description>
<error_full_description>Unsupported object type &amp;1 passed to forward generate program ry/app/rywizogenp.p.
The supported object types for forward generation are menc,objc,fold,view,brow.
</error_full_description>
<error_obj>1003597179</error_obj>
<update_error_log>no</update_error_log>
<error_type>ERR</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="157"><contained_record DB="ICFDB" Table="gsc_error"><error_group>RY</error_group>
<error_number>6</error_number>
<language_obj>426</language_obj>
<error_summary_description>Cannot launch container &amp;1.</error_summary_description>
<error_full_description>Cannot launch container &amp;1. The likely cause is the object does not exist yet in the ICFDB object table gsc_object, or is set-up incorrectly. For logical objects ensure the physical object name is specified correctly. Also ensure the object exists in the repository database table ryc_smartobject.
</error_full_description>
<error_obj>1003602711</error_obj>
<update_error_log>no</update_error_log>
<error_type>ERR</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="158"><contained_record DB="ICFDB" Table="gsc_error"><error_group>RY</error_group>
<error_number>7</error_number>
<language_obj>426</language_obj>
<error_summary_description>An extension should not be specified for a logical object.</error_summary_description>
<error_full_description>An extension should not be specified for a logical object.</error_full_description>
<error_obj>1003604536</error_obj>
<update_error_log>no</update_error_log>
<error_type>ERR</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="159"><contained_record DB="ICFDB" Table="gsc_error"><error_group>RY</error_group>
<error_number>8</error_number>
<language_obj>426</language_obj>
<error_summary_description>A physical file name should be specified for a logical object.</error_summary_description>
<error_full_description>A physical file name should be specified for a logical object.</error_full_description>
<error_obj>1003604772</error_obj>
<update_error_log>no</update_error_log>
<error_type>ERR</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="160"><contained_record DB="ICFDB" Table="gsc_error"><error_group>RY</error_group>
<error_number>9</error_number>
<language_obj>426</language_obj>
<error_summary_description>You are attempting to &amp;1 on a non-indexed field or are using the index inefficiently.  This could potentially make your query slow.  Do you want to continue?</error_summary_description>
<error_full_description>You are attempting to &amp;1 on a non-indexed field or are using the index inefficiently.  This could potentially make your query slow.  Do you want to continue?</error_full_description>
<error_obj>1003607408</error_obj>
<update_error_log>no</update_error_log>
<error_type>WAR</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="161"><contained_record DB="ICFDB" Table="gsc_error"><error_group>RY</error_group>
<error_number>10</error_number>
<language_obj>426</language_obj>
<error_summary_description>Concurrent multiple lookups not supported</error_summary_description>
<error_full_description>A lookup is already running that is using the data set required for the lookup you have just chosen. Close the currently running lookup to be able to run the new lookup.</error_full_description>
<error_obj>1003653986</error_obj>
<update_error_log>no</update_error_log>
<error_type>ERR</error_type>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="162"><contained_record DB="ICFDB" Table="gsc_error"><error_group>RY</error_group>
<error_number>11</error_number>
<language_obj>426</language_obj>
<error_summary_description>This folder window will be shut down as all tabs are disabled.</error_summary_description>
<error_full_description>Due to the fact that all the tabs for this program were programmatically disabled, the folder will now shut down.</error_full_description>
<error_obj>1003981540</error_obj>
<update_error_log>no</update_error_log>
<error_type>ERR</error_type>
</contained_record>
</dataset_transaction>
</dataset_records>
</dataset>