/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/* admhlp.i */

/*
*****************************************************
* This include file defines the help                *
* context strings that the ADE uses to              *
* display help topics from the ABxxx.HLP file.      * 
* Please contact documentation to                   *
* make changes to this file. Thanks.                *
*                                                   *
* The form used in this file is:                    *
*                                                   *
* <Name of the Help Topic>                          *
*  &Global-define <context-string> <context-number> *
*****************************************************
*/

&GLOBAL-DEFINE ADM_Method_Procedures 60009
&GLOBAL-DEFINE ADM_Links 60006
&GLOBAL-DEFINE ADM_Objects 60008
&GLOBAL-DEFINE Smart_Panel 60011
&GLOBAL-DEFINE SmartNavPanel_Attributes_Dlg_Box 60002
&GLOBAL-DEFINE SmartUpdPanel_Attributes_Dlg_Box 50001
&GLOBAL-DEFINE SmartFolder_Attributes_Dlg_Box 50002  
&GLOBAL-DEFINE SmartViewer_Attributes_Dlg_Box 60001

/* Wizard -- Help on External Tables */
&GLOBAL-DEFINE Wiz_External_Tables 60003

/* Wizard -- Help on Queries */
&GLOBAL-DEFINE Wiz_Queries 60004

/* Wizard -- Help on Browse Objects */
&GLOBAL-DEFINE Wiz_Browse_Objects 60005

/* New for Version 8.1
  -------------------------------------------- */
/* Attribute Dialogs - */
&GLOBAL-DEFINE SmartQuery_Attributes_Dlg_Box 60046        /* 6/96 wood */
&GLOBAL-DEFINE SmartContainer_Attributes_Dlg_Box 60045    /* 6/96 wood */
&GLOBAL-DEFINE AlphabetPanel_Attributes_Dlg_Box 60043     /* 6/96 wood */
&GLOBAL-DEFINE OptionPanel_Attributes_Dlg_Box 60044       /* 6/96 wood */

/* Wizard -- Help on Query/Browse Foreign Keys. */
&GLOBAL-DEFINE Wiz_Foreign_Keys 60050                     /* 6/96 wood */

/* SmartInfo Dialog Box */
&GLOBAL-DEFINE SmartInfo_Dlg_Box 49258                    /* 6/96 wood */

/* SmartObject Attributes Dialog Box --  */
&GLOBAL-DEFINE SmartAttributes_Dlg_Box 70035              /* 6/96 wood */

/* XFTR Editor -- Filter Page of Advanced Query Options -- */
&GLOBAL-DEFINE XFTR_Filter_Page 60048                     /* 6/96 wood */

/* XFTR Editor -- Sortby Options Page of Advanced Query Options -- */
&GLOBAL-DEFINE XFTR_SortBy_Options_Page 60049             /* 6/96 wood */

/* XFTR Editor -- Foreign Keys Dialog -- */
&GLOBAL-DEFINE XFTR_Foreign_Keys_Dlg 60051                /* 6/96 wood */

/* XFTR Editor -- Sample Edit Handler Dialog -- */
&GLOBAL-DEFINE XFTR_Sample_Edit_Dlg 60052                 /* 6/96 wood */

/* ADM Basics section */
&GLOBAL-DEFINE ADM_Basics 49679

/* PROGRESS Advisor - Transaction Update Panel */
&GLOBAL-DEFINE Advisor_Transaction_Update 60170          /* 11/96 gfs */

/* New for Version 9.0A
  -------------------------------------------- */
/* Help on the SDO */
&GLOBAL-DEFINE SmartData 666

/* Help on the SDB */
&GLOBAL-DEFINE SmartData_Browse 666

/* Help in the SDV */
&GLOBAL-DEFINE SmartData_Viewer 666

/* Instance Attribute Dialogs */
&GLOBAL-DEFINE SmartDataBrowser_Attributes_Dlg_Box 666
&GLOBAL-DEFINE SmartDataViewer_Attributes_Dlg_Box 666
&GLOBAL-DEFINE SmartCommitPanel_Attributes_Dlg_Box 666
&GLOBAL-DEFINE SmartDataObject_Attributes_Dlg_Box 33 

/* 'Help on Links' (adm2/support/_wizrepl.w) */
&GLOBAL-DEFINE Help_on_Links 9

/* Help on Data Object' in SDO wizard (pg 3) (adm2/support/_wizfld.w) */
&GLOBAL-DEFINE Help_on_Data_Object 10

/* 'Help on HTML files' in HTML map wiz (pg 2) (adm2/support/_wizhtml.w) */
&GLOBAL-DEFINE Help_on_HTML_Files 21

/* 'Help on Mapping' in HTML map wiz (pg 4) (adm2/support/_wizmap.w) */
&GLOBAL-DEFINE Help_on_Mapping 22

/* 'Help on Style' in HTML report wiz (pg 4) (adm2/support/_wizreps.w) */
&GLOBAL-DEFINE Help_on_Style 23

/* 'Help on Fields' in SDB wiz (pg 3) (adm2/support/_wizdfld.w) */
&GLOBAL-DEFINE Help_on_Fields 24

/* 'Help on Data Sources' (adm2/support/_wizds.w) */
&GLOBAL-DEFINE Help_on_Data_Sources 26

/* 'Help on External Tables' (adm2/support/_wizetbl.w) */
&GLOBAL-DEFINE Help_on_External_Tables 27

/* 'Help on Background' (adm2/support/_wizbkgr.w) */
/* &GLOBAL-DEFINE Help_on_Background 563 */
&GLOBAL-DEFINE Help_on_Background 1224

/* 'Help on Link' (adm2/support/_wizhref.w) */
/* &GLOBAL-DEFINE Help_on_Link 564 */
&GLOBAL-DEFINE Help_on_Link 1225

/* 'Help on Style' (adm2/support/_wizstyl.w) */
&GLOBAL-DEFINE Help_on_Style_Detail_Wizard 1229

/* 'Help on Style' (adm2/support/_wizstyl.w) */
&GLOBAL-DEFINE Help_on_Style_Report_Wizard 1226

/* 'Help for Wizard Page Basics (adm2/support/_wizard.w) */
&GLOBAL-DEFINE Help_on_Wizard 107

/* Help for V9 Visual SmartObjects (e.g. SDB and SDV) 
 * instance attribute dialogs */
&GLOBAL-DEFINE VisualSmartObject_Attributes_Dlg_Box 106

&GLOBAL-DEFINE BrowserSmartObject_Attributes_Dlg_Box 47026

/* New for version 9.1A */                                                           
&GLOBAL-DEFINE SmartSelect_Instance_Properties_Dialog_Box      189
&GLOBAL-DEFINE SmartFilter_Instance_Properties_Dialog_Box      190
&GLOBAL-DEFINE SmartToolbar_Instance_Properties_Dialog_Box     191
/* Help for Smart TreeView Instance Properties */
&GLOBAL-DEFINE SmTreeView_Instance_Properties_Dialog_Box        47238
/* Help for Viewer instance dialog */
&GLOBAL-DEFINE Viewer_Instance_Properties_Dialog_Box  47035


/* New for version 9.1B */
&GLOBAL-DEFINE SmartBusinessObject_Instance_Properties_Dialog_Box 195
&GLOBAL-DEFINE SmartB2BObject_Instance_Properties_Dialog_Box 196
&GLOBAL-DEFINE SmartSender_Instance_Properties_Dialog_Box 197
&GLOBAL-DEFINE SmartProducer_Instance_Properties_Dialog_Box 198
&GLOBAL-DEFINE SmartConsumer_Instance_Properties_Dialog_Box 199
&GLOBAL-DEFINE SmartRouter_Instance_Properties_Dialog_Box 200

/* New for 9.1D...*/
/* Help for Dynamic SDB Instance Properties */
&GLOBAL-DEFINE Dynamic_SmDataBrowser_Instance_Properties_Dialog_Box 47243

/* New for 10.0B  */
&GLOBAL-DEFINE SmartLOBField_Instance_Properties_Dialog_Box 219
&GLOBAL-DEFINE SmartLOBField_Instance_Properties_Dialog_Box_For_Dynamics 15 

/* New for 10.1A */
&GLOBAL-DEFINE DataView_Instance_Properties_Dialog_Box 101001





