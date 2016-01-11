/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/
/*
 * _fdefs.i
 *
 *    This include contains all the Results features, sub menu features,
 *    and labels needed for menu layout and Results security.
 */

&GLOBAL-DEFINE rlFile              "&Query"
&GLOBAL-DEFINE rlTableMenu         "&Table"
&GLOBAL-DEFINE rlFieldMenu         "&Field"
&GLOBAL-DEFINE rlData              "&Data"
&GLOBAL-DEFINE rlOptions           "&Options"
&GLOBAL-DEFINE rlViewMenu          "&View"
&GLOBAL-DEFINE rlUsers             "&Users"
&GLOBAL-DEFINE rlHelp              "&Help"

&GLOBAL-DEFINE resId               "Results"
&GLOBAL-DEFINE resToolbar          "ResultsToolbar"

&GLOBAL-DEFINE rfNewSubMenu        "NewSubMenu"
&GLOBAL-DEFINE rlNewSubMenu        "&New"
&GLOBAL-DEFINE rhNewSubMenu        "Submenu to Organize New Views"

&GLOBAL-DEFINE rfPrintSubMenu      "PrintSubMenu"
&GLOBAL-DEFINE rlPrintSubMenu      "&Print"
&GLOBAL-DEFINE rhPrintSubMenu      "Submenu to Organize Print Options"

&GLOBAL-DEFINE rfAdminSubMenu      "AdminSubMenu"
&GLOBAL-DEFINE rlAdminSubMenu      "Si&te Admin"
&GLOBAL-DEFINE rhAdminSubMenu      "Submenu to Organize Site Adminstration Options"

&GLOBAL-DEFINE rfProgSubMenu       "ProgrammingSubMenu"
&GLOBAL-DEFINE rlProgSubMenu       "C&ustomize"
&GLOBAL-DEFINE rhProgSubMenu       "Submenu to Organize Programming Options"

&GLOBAL-DEFINE rfExportSubMenu     "ExportSubMenu"
&GLOBAL-DEFINE rlExportSubMenu     "Custom E&xport"
&GLOBAL-DEFINE rhExportSubMenu     "Submenu to Organize Custom Exports"

&GLOBAL-DEFINE rfNewDuplicateView  "NewDuplicateView"
&GLOBAL-DEFINE rlNewDuplicateView  "&New (Same As Current)"
&GLOBAL-DEFINE riNewDuplicateView  "new"
&GLOBAL-DEFINE rhNewDuplicateView  "Create a New View, Same Type as Current"

&GLOBAL-DEFINE rfNewBrowseView     "NewBrowseView"
&GLOBAL-DEFINE rlNewBrowseView     "&Browse..."
&GLOBAL-DEFINE rhNewBrowseView     "Create a New Browse View"

&GLOBAL-DEFINE rfNewReportView     "NewReportView"
&GLOBAL-DEFINE rlNewReportView     "&Report..."
&GLOBAL-DEFINE rhNewReportView     "Create a New Report View"

&GLOBAL-DEFINE rfNewFormView       "NewFormView"
&GLOBAL-DEFINE rlNewFormView       "&Form..."
&GLOBAL-DEFINE rhNewFormView       "Create a New Form View"

&GLOBAL-DEFINE rfNewLabelView      "NewLabelView"
&GLOBAL-DEFINE rlNewLabelView      "&Label..."
&GLOBAL-DEFINE rhNewLabelView      "Create a New Label View"

&GLOBAL-DEFINE rfNewExportView     "NewExportView"
&GLOBAL-DEFINE rlNewExportView     "&Export..."
&GLOBAL-DEFINE rhNewExportView     "Create a New Export View"

&GLOBAL-DEFINE rfFileOpen          "FileOpen"
&GLOBAL-DEFINE rlFileOpen          "&Open..."
&GLOBAL-DEFINE riFileOpen          "open"
&GLOBAL-DEFINE rhFileOpen          "Open an Existing Query"

&GLOBAL-DEFINE rfFileSave          "FileSave"
&GLOBAL-DEFINE rlFileSave          "&Save"
&GLOBAL-DEFINE riFileSave          "save"
&GLOBAL-DEFINE rhFileSave          "Save the Query"

&GLOBAL-DEFINE rfFileSaveAs        "FileSaveAs"
&GLOBAL-DEFINE rlFileSaveAs        "Save &As..."
&GLOBAL-DEFINE rhFileSaveAs        "Save the Query with a Different Name"

&GLOBAL-DEFINE rfFileClose         "FileClose"
&GLOBAL-DEFINE rlFileClose         "&Close"
&GLOBAL-DEFINE rhFileClose         "Close the Query"

&GLOBAL-DEFINE rfFileDelete        "FileDelete"
&GLOBAL-DEFINE rlFileDelete        "&Delete..."
&GLOBAL-DEFINE rhFileDelete        "Delete Queries from a Query Directory"

&GLOBAL-DEFINE rfGenerate          "Generate"
&GLOBAL-DEFINE rlGenerate          "&Generate..."
&GLOBAL-DEFINE rhGenerate          "Create 4GL Code Based on the View"

&GLOBAL-DEFINE rfPrintPrinter      "PrintPrinter"
&GLOBAL-DEFINE rlPrintPrinter      "To &Printer..."
&GLOBAL-DEFINE riPrintPrinter      "print"
&GLOBAL-DEFINE rhPrintPrinter      "Send Results of Query to the Default Printer"

&GLOBAL-DEFINE rfPrintPrinterNoBox "PrintPrinterNoBox"
&GLOBAL-DEFINE rlPrintPrinterNoBox "To &Printer"
&GLOBAL-DEFINE riPrintPrinterNoBox "print"
&GLOBAL-DEFINE rhPrintPrinterNoBox "Send Results of Query to the Default Printer"

&GLOBAL-DEFINE rfPrintClip         "PrintClip"
&GLOBAL-DEFINE rlPrintClip         "To &Clipboard"
&GLOBAL-DEFINE rhPrintClip         "Send Results of Query to the Clipboard"

&GLOBAL-DEFINE rfPrintFile         "PrintFile"
&GLOBAL-DEFINE rlPrintFile         "To &File..."
&GLOBAL-DEFINE rhPrintFile         "Send Results of Query to a File"

&GLOBAL-DEFINE rfPrintPreview	   "PrintPreview"
&GLOBAL-DEFINE rlPrintPreview	   "Print Pre&view"
&GLOBAL-DEFINE riPrintPreview	   "prevw"
&GLOBAL-DEFINE rhPrintPreview	   "Check the Results of the Query"

&GLOBAL-DEFINE rfApInstantiate     "AdminProgInstantiate"
&GLOBAL-DEFINE rlApInstantiate     "AP Instantiate"
&GLOBAL-DEFINE rhApInstantiate     "Instantiate the Query"

&GLOBAL-DEFINE rfApInitialize      "AdminProgInitialize"
&GLOBAL-DEFINE rlApInitialize      "AP Initialize"
&GLOBAL-DEFINE rhApInitialize      "Initialize the Variables"

&GLOBAL-DEFINE rfApWrite4GL        "AdminProgWrite4GL"
&GLOBAL-DEFINE rlApWrite4GL        "AP Write4GL"
&GLOBAL-DEFINE rhApWrite4GL        "Create a .p Based on the Query"

&GLOBAL-DEFINE rfAdminRebuild      "AdminRebuild"
&GLOBAL-DEFINE rlAdminRebuild      "&Application Rebuild..."
&GLOBAL-DEFINE rhAdminRebuild      "Rebuild Configuration, Directory, Query Files"

&GLOBAL-DEFINE rfAdminRelations    "AdminTableRelations"
&GLOBAL-DEFINE rlAdminRelations    "Table &Relationships..."
&GLOBAL-DEFINE rhAdminRelations    "Edit Relationships Between Tables"

&GLOBAL-DEFINE rfAdminTableAlias   "AdminTableAlias"
&GLOBAL-DEFINE rlAdminTableAlias   "Table Alia&ses..."
&GLOBAL-DEFINE rhAdminTableAlias   "Create and Delete Table Aliases"

&GLOBAL-DEFINE rfAdminPerm         "AdminSecurity"
&GLOBAL-DEFINE rlAdminPerm         "Feature Securit&y..."
&GLOBAL-DEFINE rhAdminPerm         "Set Security for Features"

&GLOBAL-DEFINE rfAdminReset        "AdminReset"
&GLOBAL-DEFINE rlAdminReset        "&Reset..."
&GLOBAL-DEFINE rhAdminReset        "Delete Existing Features, Menus, Tool Bars"

&GLOBAL-DEFINE rfAdminFeature      "AdminFeatures"
&GLOBAL-DEFINE rlAdminFeature      "&Features..."
&GLOBAL-DEFINE rhAdminFeature      "Create and Modify VAR defined Features"

&GLOBAL-DEFINE rfAdminMenuEdit     "AdminMenuEdit"
&GLOBAL-DEFINE rlAdminMenuEdit     "&Menu Layout..."
&GLOBAL-DEFINE rhAdminMenuEdit     "Create and Modify Menu Layout"

&GLOBAL-DEFINE rfAdminToolbarEdit  "AdminToolbarEdit"
&GLOBAL-DEFINE rlAdminToolbarEdit  "&Tool Bar Layout..."
&GLOBAL-DEFINE rhAdminToolbarEdit  "Create and Modify Tool Bar Layout"

&GLOBAL-DEFINE rfAdminReportType   "AdminReportType"
&GLOBAL-DEFINE rlAdminReportType   "S&tandard Page..."
&GLOBAL-DEFINE rhAdminReportType   "Choose a Standard Page Size"

&GLOBAL-DEFINE rfAdminExportType   "AdminExportType"
&GLOBAL-DEFINE rlAdminExportType   "Standard E&xport..."
&GLOBAL-DEFINE rhAdminExportType   "Choose a Standard Export Format"

&GLOBAL-DEFINE rfAdminLabelType    "AdminLabelType"
&GLOBAL-DEFINE rlAdminLabelType    "Standard &Label..."
&GLOBAL-DEFINE rhAdminLabelType    "Choose a Standard Label Size"

&GLOBAL-DEFINE rfAdminLabelField   "AdminLabelField"
&GLOBAL-DEFINE rlAdminLabelField   "Label &Field Selection..."
&GLOBAL-DEFINE rhAdminLabelField   "Select Fields for Label Layout"

&GLOBAL-DEFINE rfAdminOptions      "AdminCustomizeInterface"
&GLOBAL-DEFINE rlAdminOptions      "&Preferences..."
&GLOBAL-DEFINE rhAdminOptions      "Customize User Interface Components"

&GLOBAL-DEFINE rfAdminIntegration  "AdminIntegration"
&GLOBAL-DEFINE rlAdminIntegration  "&Integration Procedures..."
&GLOBAL-DEFINE rhAdminIntegration  "Set Integration Procedures"

&GLOBAL-DEFINE rfAdminDeployment   "AdminDeployment"
&GLOBAL-DEFINE rlAdminDeployment   "&Deployment..."
&GLOBAL-DEFINE rhAdminDeployment   "Manage Deployment Files"

&GLOBAL-DEFINE rfAdminWhere        "AdminWhere"
&GLOBAL-DEFINE rlAdminWhere        "Ta&ble Data Selection..."
&GLOBAL-DEFINE rhAdminWhere        "Create and Edit Site Restrictions"

&GLOBAL-DEFINE rfExit              "Exit"
&GLOBAL-DEFINE rlExit              "E&xit"
&GLOBAL-DEFINE rhExit              "Exit the Product"

&GLOBAL-DEFINE rfTable             "Tables"
&GLOBAL-DEFINE rlTable             "Add/Remove &Tables..."
&GLOBAL-DEFINE rhTable             "Modify Tables Active in the Query"

&GLOBAL-DEFINE rfJoin              "Joins"
&GLOBAL-DEFINE rlJoin              "&Relationship Types..."
&GLOBAL-DEFINE rhJoin              "Set Record Inclusion Behavior"

&GLOBAL-DEFINE rfInclude           "Includes"
&GLOBAL-DEFINE rlInclude           "&Include Files..."
&GLOBAL-DEFINE rhInclude           "Include Files"

&GLOBAL-DEFINE rfCalcSubMenu       "CalcSubMenu"
&GLOBAL-DEFINE rlCalcSubMenu       "Add &Calculated Field..."
&GLOBAL-DEFINE rhCalcSubMenu       "Submenu to Organize Calculated Fields"

&GLOBAL-DEFINE rfFields            "Fields"
&GLOBAL-DEFINE rlFields            "Add/Remove &Fields..."
&GLOBAL-DEFINE rhFields            "Modify Fields in the Query"

&GLOBAL-DEFINE rfPercentTotal      "PercentTotal"
&GLOBAL-DEFINE rlPercentTotal      "&Percent of Total..."
&GLOBAL-DEFINE rhPercentTotal      "Create a Percent of Total Calculated Field"

&GLOBAL-DEFINE rfRunningTotal      "RunningTotal"
&GLOBAL-DEFINE rlRunningTotal      "&Running Total..."
&GLOBAL-DEFINE rhRunningTotal      "Create a Running Total Calculated Field"

&GLOBAL-DEFINE rfCounter           "Counter"
&GLOBAL-DEFINE rlCounter           "&Counter..."
&GLOBAL-DEFINE rhCounter           "Create a Counter Calculated Field"

&GLOBAL-DEFINE rfArray             "Array"
&GLOBAL-DEFINE rlArray             "Stacked &Array..."
&GLOBAL-DEFINE rhArray             "Add an Array Field As a Stacked Array"

&GLOBAL-DEFINE rfLookup            "Lookup"
&GLOBAL-DEFINE rlLookup            "Loo&kup..." 
&GLOBAL-DEFINE rhLookup            "Create a Lookup Calculated Field"

&GLOBAL-DEFINE rfMath              "Math"
&GLOBAL-DEFINE rlMath              "&Math..." 
&GLOBAL-DEFINE rhMath              "Create an Arithmetic Calculated Field"

&GLOBAL-DEFINE rfStringFunc        "StringFunc"
&GLOBAL-DEFINE rlStringFunc        "&String Function..."
&GLOBAL-DEFINE rhStringFunc        "Create a String Based Calculated Field" 

&GLOBAL-DEFINE rfNumericFunc       "NumericFunc"
&GLOBAL-DEFINE rlNumericFunc       "&Numeric Function..." 
&GLOBAL-DEFINE rhNumericFunc       "Create a Numeric Calculated Field"

&GLOBAL-DEFINE rfDateFunc          "DateFunc"
&GLOBAL-DEFINE rlDateFunc          "&Date Function..." 
&GLOBAL-DEFINE rhDateFunc          "Create a Date Based Calculated Field"

&GLOBAL-DEFINE rfLogicalFunc       "LogicalFunc"
&GLOBAL-DEFINE rlLogicalFunc       "&Logical Function..."
&GLOBAL-DEFINE rhLogicalFunc       "Create a Logical Variable Calculated Field"

&GLOBAL-DEFINE rfTotals            "Totals"
&GLOBAL-DEFINE rlTotals            "&Aggregates..." 
&GLOBAL-DEFINE rhTotals            "Define Aggregates for the Query"

&GLOBAL-DEFINE rfFieldProps        "FieldProperties"
&GLOBAL-DEFINE rlFieldProps        "&Properties..." 
&GLOBAL-DEFINE rhFieldProps        "Define Field Properties"

&GLOBAL-DEFINE rfSelection         "Selection"
&GLOBAL-DEFINE rlSelection         "&Selection..."
&GLOBAL-DEFINE rhSelection         "Add Restrictions to a Query"
&GLOBAL-DEFINE riSelection         "select"

&GLOBAL-DEFINE rfReAsk             "ReAsk"
&GLOBAL-DEFINE rlReAsk             "&Re-ask Questions..."
&GLOBAL-DEFINE rhReAsk             "Provide Answers for variables"

&GLOBAL-DEFINE rfSortOrdering      "SortOrdering"
&GLOBAL-DEFINE rlSortOrdering      "Sort &Ordering..."
&GLOBAL-DEFINE rhSortOrdering      "Create and Modify the Ordering of a Query"
&GLOBAL-DEFINE riSortOrdering      "sort"

&GLOBAL-DEFINE rfGovernor          "Governor"
&GLOBAL-DEFINE rlGovernor          "&Governor..."
&GLOBAL-DEFINE rhGovernor          "Limit Number of Records Selected"

&GLOBAL-DEFINE rfInformation       "Information"
&GLOBAL-DEFINE rlInformation       "&Query Information..."
&GLOBAL-DEFINE rhInformation       "View Information About the Current Query"

&GLOBAL-DEFINE rfHeadersAndFooters "HeadersAndFooters"
&GLOBAL-DEFINE rlHeadersAndFooters "&Headers and Footers..."
&GLOBAL-DEFINE rhHeadersAndFooters "Define Report Headers and Footers"

&GLOBAL-DEFINE rfMasterDetail      "MasterDetail"
&GLOBAL-DEFINE rlMasterDetail      "&Master-Detail..."
&GLOBAL-DEFINE rhMasterDetail      "Set the Master-Detail Relationship"

&GLOBAL-DEFINE rfTotalsOnly        "TotalsOnly"
&GLOBAL-DEFINE rlTotalsOnly        "&Totals Only Summary..."
&GLOBAL-DEFINE rhTotalsOnly        "Specify Totals for Fields in a Query"

&GLOBAL-DEFINE rfFrameProps        "FrameProperties"
&GLOBAL-DEFINE rlFrameProps        "&Frame Properties..."
&GLOBAL-DEFINE rhFrameProps        "Form and Browse View Frame Properties"

&GLOBAL-DEFINE rfStandardReport    "StandardReport"
&GLOBAL-DEFINE rlStandardReport    "Standard &Page..."
&GLOBAL-DEFINE rhStandardReport    "Choose a Standard Page Size"

&GLOBAL-DEFINE rfCustomReport      "CustomReport"
&GLOBAL-DEFINE rlCustomReport      "&Custom Page..."
&GLOBAL-DEFINE rhCustomReport      "Define Custom Page Sizes"

&GLOBAL-DEFINE rfPageBreak         "PageBreak"
&GLOBAL-DEFINE rlPageBreak         "Page &Break..."
&GLOBAL-DEFINE rhPageBreak         "Set a Page Break in a Report"

&GLOBAL-DEFINE rfStandardLabel     "StandardLabel"
&GLOBAL-DEFINE rlStandardLabel     "&Standard Label..."
&GLOBAL-DEFINE rhStandardLabel     "Choose a Standard Label Size"

&GLOBAL-DEFINE rfCustomLabel       "CustomLabel"
&GLOBAL-DEFINE rlCustomLabel       "Custom &Label..."
&GLOBAL-DEFINE rhCustomLabel       "Create a Customized Label"

&GLOBAL-DEFINE rfStandardExport    "StandardExport"
&GLOBAL-DEFINE rlStandardExport    "Standard &Export..."
&GLOBAL-DEFINE rhStandardExport    "Choose a Standard Export Format"

&GLOBAL-DEFINE rfOutputHeader      "OutputHeaderRecord"
&GLOBAL-DEFINE rlOutputHeader      "&Output Header Record"
&GLOBAL-DEFINE rhOutputHeader      "Create Header Description for Custom Export"

&GLOBAL-DEFINE rfFixedWidth        "FixedWidthFields"
&GLOBAL-DEFINE rlFixedWidth        "&Fixed-width Fields"
&GLOBAL-DEFINE rhFixedWidth        "Toggle Fixed Width Columns for Exports"

&GLOBAL-DEFINE rfRecordStart       "RecordStart"
&GLOBAL-DEFINE rlRecordStart       "Record &Start..."
&GLOBAL-DEFINE rhRecordStart       "Choose the Export Record Start Codes"

&GLOBAL-DEFINE rfRecordEnd          "RecordEnd"
&GLOBAL-DEFINE rlRecordEnd          "Record &End..."
&GLOBAL-DEFINE rhRecordEnd          "Choose the Export Record End Codes"

&GLOBAL-DEFINE rfFieldDelims        "FieldDelimiters"
&GLOBAL-DEFINE rlFieldDelims        "Field De&limiters..."
&GLOBAL-DEFINE rhFieldDelims        "Choose the Export Field Delimiters"

&GLOBAL-DEFINE rfFieldSeps          "FieldSeparators"
&GLOBAL-DEFINE rlFieldSeps          "Field Se&parators..."
&GLOBAL-DEFINE rhFieldSeps          "Choose the Export Field Separators"

&GLOBAL-DEFINE rfBrowseView         "BrowseView"
&GLOBAL-DEFINE rlBrowseView         "As &Browse"
&GLOBAL-DEFINE riBrowseView         "browse"
&GLOBAL-DEFINE rhBrowseView         "Switch to Browse View"

&GLOBAL-DEFINE rfReportView         "ReportView"
&GLOBAL-DEFINE rlReportView         "As &Report"
&GLOBAL-DEFINE riReportView         "rpt"
&GLOBAL-DEFINE rhReportView         "Switch to Report View"

&GLOBAL-DEFINE rfFormView           "FormView"
&GLOBAL-DEFINE rlFormView           "As &Form"
&GLOBAL-DEFINE riFormView           "form"
&GLOBAL-DEFINE rhFormView           "Switch to Form View"

&GLOBAL-DEFINE rfLabelView          "LabelView"
&GLOBAL-DEFINE rlLabelView          "As &Label"
&GLOBAL-DEFINE riLabelView          "labels"
&GLOBAL-DEFINE rhLabelView          "Switch to Label View"

&GLOBAL-DEFINE rfExportView         "ExportView"
&GLOBAL-DEFINE rlExportView         "As &Export"
&GLOBAL-DEFINE riExportView         "export"
&GLOBAL-DEFINE rhExportView         "Switch to Export View"

&GLOBAL-DEFINE rfToolBar            "ToolBar"
&GLOBAL-DEFINE rlToolBar            "&Tool Bar"
&GLOBAL-DEFINE rhToolBar            "Turn the Tool Bar On or Off"

&GLOBAL-DEFINE rfStatusLine         "StatusLine"
&GLOBAL-DEFINE rlStatusLine         "&Status Line"
&GLOBAL-DEFINE rhStatusLine         "Turn the Status Line On or Off"
                                              
&GLOBAL-DEFINE rfHelpTopics         "HelpTopics"
&GLOBAL-DEFINE rlHelpTopics         "&Help Topics"
&GLOBAL-DEFINE rhHelpTopics         "Access Help Contents, Index, and Search Options"

/* Help Contents, Search, and How To are not on Help menu starting with 8.2B. */
&GLOBAL-DEFINE rfHelpContents       "HelpContents"
&GLOBAL-DEFINE rlHelpContents       "&Contents"
&GLOBAL-DEFINE rhHelpContents       "Display the Table of Contents for Help"

&GLOBAL-DEFINE rfHelpSearch         "HelpSearch"
&GLOBAL-DEFINE rlHelpSearch         "&Search for Help On..."
&GLOBAL-DEFINE rhHelpSearch         "Search Help for a Specific Topic"

&GLOBAL-DEFINE rfHowTo              "HowTo"
&GLOBAL-DEFINE rlHowTo              "&How To"
&GLOBAL-DEFINE rhHowTo              "Information On How To Use This Product"

&GLOBAL-DEFINE rfMessages           "Messages"
&GLOBAL-DEFINE rlMessages           "M&essages..."
&GLOBAL-DEFINE rhMessages           "Lookup Standard Error Message"

&GLOBAL-DEFINE rfRecentMessages     "RecentMessages"
&GLOBAL-DEFINE rlRecentMessages     "&Recent Messages..."
&GLOBAL-DEFINE rhRecentMessages     "Display Recent Error Messages"

&GLOBAL-DEFINE rfAboutResults       "AboutResults"
&GLOBAL-DEFINE rlAboutResults       "&About RESULTS..."
&GLOBAL-DEFINE rhAboutResults       "Information About This Product"

/*
 * The following are Results features that are not intended to be tied to
 * menu items, but are used elsewhere in the user interface. They don't have
 * a label, but do have help.
 */

&GLOBAL-DEFINE rfReadOtherDir       "ReadOtherDirectory"
&GLOBAL-DEFINE rhReadOtherDir       "Read Another Directory File"

&GLOBAL-DEFINE rfWriteOtherDir      "WriteOtherDirectory"
&GLOBAL-DEFINE rhWriteOtherDir      "Write Another Directory File"

&GLOBAL-DEFINE rfReadPublicDir      "ReadPublicDirectory"
&GLOBAL-DEFINE rhReadPublicDir      "Read Public Directory File"

&GLOBAL-DEFINE rfWritePublicDir     "WritePublicDirectory"
&GLOBAL-DEFINE rhWritePublicDir     "Write Public Directory File"

&GLOBAL-DEFINE rfRecordAdd          "RecordAdd"
&GLOBAL-DEFINE rhRecordAdd          "Add a Record in a Form View"

&GLOBAL-DEFINE rfRecordDelete       "RecordDelete"
&GLOBAL-DEFINE rhRecordDelete       "Delete a Record in a Form View"

&GLOBAL-DEFINE rfRecordUpdate       "RecordUpdate"
&GLOBAL-DEFINE rhRecordUpdate       "Update a Record in a Form View"

/* _fdefs.i -  end of file */

