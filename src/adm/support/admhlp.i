/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* admhlp.i */

/*
*****************************************************
* This include file defines the help                *
* context strings that the ADE uses to              *
* display help topics from the ADMxxx.HLP file.     * 
* Please contact documentation to                   *
* make changes to this file. Thanks.                *
*                                                   *
* The form used in this file is:                    *
*                                                   *
* <Name of the Help Topic>                          *
*  &Global-define <context-string> <context-number> *
*****************************************************
*/

/* [gfs 10/18/96] Context references now point to the UIB help file */

&Global-Define ADM_Method_Procedures 60009
&Global-Define ADM_Links 60006
&Global-Define ADM_Objects 60008
&Global-Define Smart_Browse 60010
&Global-Define Smart_Panel 60011
&Global-Define Smart_Query 60012
&Global-Define Smart_Viewer 90
&GLOBAL-DEFINE SmartBrowser_Attributes_Dlg_Box 60000
&GLOBAL-DEFINE SmartViewer_Attributes_Dlg_Box 60001
&GLOBAL-DEFINE SmartNavPanel_Attributes_Dlg_Box 60002
&GLOBAL-DEFINE SmartUpdPanel_Attributes_Dlg_Box 50001
&GLOBAL-DEFINE SmartFolder_Attributes_Dlg_Box 50002  

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
