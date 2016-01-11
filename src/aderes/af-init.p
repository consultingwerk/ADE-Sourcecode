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
 * af-init.p
 *
 *    Creates all of the Results "core" features. This file is to be called
 *    at startup, before the menus are created.
 */

{ aderes/s-system.i }
{ aderes/_fdefs.i }
{ adeshar/_mnudefs.i }

/*
 * NOTE: If you are adding a feature and the function in _dspfunc doesn't
 *       take any args make sure that you put a comma after the function.
 *       Check out PrintPreview as an example.
 */                                         

RUN AddSubMenuFeature( {&rfNewSubMenu},    "",
                                           {&rlNewSubMenu},
                                           {&rhNewSubMenu}).

RUN AddSubMenuFeature( {&rfPrintSubMenu},  "",
                                           {&rlPrintSubMenu},
                                           {&rhPrintSubMenu}).

RUN AddSubMenuFeature( {&rfAdminSubMenu},  "",
                                           {&rlAdminSubMenu},
                                           {&rhAdminSubMenu}).

RUN AddSubMenuFeature( {&rfProgSubMenu},   "",
                                           {&rlProgSubMenu},
                                           {&rhProgSubMenu}).

RUN AddSubMenuFeature( {&rfExportSubMenu}, "",
                                           {&rlExportSubMenu},
                                           {&rhExportSubMenu}).

RUN AddFeatureTb( {&rfNewDuplicateView},   "aderes/_dspfunc.p":u,
                                           "NewDupModule,":u,
                                           {&rlNewDuplicateView},
                                           {&riNewDuplicateView},
                                           {&rhNewDuplicateView}).

RUN AddFeature( {&rfNewBrowseView},        "aderes/_dspfunc.p":u,
                                           "ChooseModule,b":u,
                                           {&rlNewBrowseView},
                                           {&rhNewBrowseView}).

RUN AddFeature( {&rfNewReportView},        "aderes/_dspfunc.p":u,
                                           "ChooseModule,r":u,
                                           {&rlNewReportView},
                                           {&rhNewReportView}).

RUN AddFeature( {&rfNewFormView},          "aderes/_dspfunc.p":u,
                                           "ChooseModule,f":u,
                                           {&rlNewFormView},
                                           {&rhNewFormView}).

RUN AddFeature( {&rfNewLabelView},         "aderes/_dspfunc.p":u,
                                           "ChooseModule,l":u,
                                           {&rlNewLabelView},
                                           {&rhNewLabelView}).

RUN AddFeature( {&rfNewExportView},        "aderes/_dspfunc.p":u,
                                           "ChooseModule,e":u,
                                           {&rlNewExportView},
                                           {&rhNewExportView}).

RUN AddFeatureTb( {&rfFileOpen},           "aderes/_dspfunc.p":u,
                                           "FileOpen,":u,
                                           {&rlFileOpen},
                                           {&riFileOpen},
                                           {&rhFileOpen}).

RUN AddFeatureTb( {&rfFileSave},           "aderes/_dspfunc.p":u,
                                           "RunDirty,i-opnsav.p,1":u,
                                           {&rlFileSave},
                                           {&riFileSave},
                                           {&rhFileSave}).

RUN AddFeature( {&rfFileSaveAs},           "aderes/_dspfunc.p":u,
                                           "RunDirty,i-opnsav.p,2":u, 
                                           {&rlFileSaveAs},
                                           {&rhFileSaveAs}).

RUN AddFeature( {&rfFileCLose},            "aderes/_dspfunc.p":u,
                                           "ChooseModule,?":u,
                                           {&rlFileClose}, 
                                           {&rhFileClose}).

RUN AddFeature( {&rfFileDelete},           "aderes/_dspfunc.p":u,
                                           "RunSingle,i-zap.p,":u,
                                           {&rlFileDelete}, 
                                           {&rhFileDelete}).

RUN AddFeature( {&rfGenerate},             "aderes/_dspfunc.p":u,
                                           "ChooseModule,%":u,
                                           {&rlGenerate},
                                           {&rhGenerate}).

RUN AddFeature( {&rfPrintPrinter},         "aderes/_dspfunc.p":u,
                                           "PrintToPrinter,1":u,
                                           {&rlPrintPrinter},
                                           {&rhPrintPrinter}).

RUN AddFeatureTb( {&rfPrintPrinterNoBox},  "aderes/_dspfunc.p":u,
                                           "PrintToPrinter,0":u,
                                           {&rlPrintPrinterNoBox},
                                           {&riPrintPrinterNoBox},
                                           {&rhPrintPrinterNoBox}).

RUN AddFeature( {&rfPrintClip},            "aderes/_dspfunc.p":u,
                                           "PrintClip,":u,
                                           {&rlPrintClip}, 
                                           {&rhPrintClip}).

RUN AddFeature( {&rfPrintFile},            "aderes/_dspfunc.p":u,
                                           "PrintToFile,":u,
                                           {&rlPrintFile},
                                           {&rhPrintFile}).

RUN AddFeatureTb( {&rfPrintPreview},       "aderes/_dspfunc.p":u,
                                           "PrintPreview,":u,
                                           {&rlPrintPreview},
                                           {&riPrintPreview},
                                           {&rhPrintPreview}).
/* Programming Features */

RUN AddFeature( {&rfApInstantiate},        "aderes/_dspfunc.p":u,
                                           "RunSingle,s-level.p":u,
                                           {&rlApInstantiate},
                                           {&rhApInstantiate}).

RUN AddFeature( {&rfApInitialize},         "aderes/_dspfunc.p":u,
                                           "RunLogicalInput,s-zap.p,false":u,
                                           {&rlApInitialize},
                                           {&rhApInitialize}).

RUN AddFeature( {&rfApWrite4GL},           "aderes/_dspfunc.p":u,
                                           "RunTriple,_a4gl.p,test.p,g":u,
                                           {&rlApWrite4GL},
                                           {&rhApWrite4GL}).

/* GUI Admin Features */

RUN AddFeature( {&rfAdminRelations},       "aderes/_dspfunc.p":u,
                                           "RunSingle,_arships.p":u,
                                           {&rlAdminRelations},
                                           {&rhAdminRelations}).

RUN AddFeature( {&rfAdminWhere},           "aderes/_dspfunc.p":u,
                                           "RunDirty,_awhere.p":u,
                                           {&rlAdminWhere},
                                           {&rhAdminWhere}).

RUN AddFeature( {&rfAdminTableAlias},      "aderes/_dspfunc.p":u,
                                           "RunSingle,_atalias.p":u,
                                           {&rlAdminTableAlias},
                                           {&rhAdminTableAlias}).

RUN AddFeature( {&rfAdminRebuild},         "aderes/_dspfunc.p":u,
                                           "RunSingle,_abuild.p":u,
                                           {&rlAdminRebuild},
                                           {&rhAdminRebuild}).

RUN AddFeature( {&rfAdminPerm},            "aderes/_dspfunc.p":u,
                                           "RunSingle,_asecure.p":u,
                                           {&rlAdminPerm},
                                           {&rhAdminPerm}).

RUN AddFeature( {&rfAdminMenuEdit},        "aderes/_dspfunc.p":u,
                                           "RunSingle,_amenu.p":u,
                                           {&rlAdminMenuEdit},
                                           {&rhAdminMenuEdit}).

RUN AddFeature( {&rfAdminToolbarEdit},     "aderes/_dspfunc.p":u,
                                           "RunSingle,_atool.p":u,
                                           {&rlAdminToolbarEdit},
                                           {&rhAdminToolbarEdit}).

RUN AddFeature( {&rfAdminFeature},         "aderes/_dspfunc.p":u,
                                           "RunSingle,_afeat.p":u,
                                           {&rlAdminFeature},
                                           {&rhAdminFeature}).
                                    
RUN AddFeature( {&rfAdminReset},           "aderes/_dspfunc.p":u,
                                           "RunSingle,_areset.p":u,
                                           {&rlAdminReset},
                                           {&rhAdminReset}).

RUN AddFeature( {&rfAdminReportType},      "aderes/_dspfunc.p":u,
                                           "RunDirty,p-type.p,1":u,
                                           {&rlAdminReportType},
                                           {&rhAdminReportType}).

RUN AddFeature( {&rfAdminExportType},      "aderes/_dspfunc.p":u,
                                           "RunDirty,e-type.p,1":u,
                                           {&rlAdminExportType},
                                           {&rhAdminExportType}).

RUN AddFeature( {&rfAdminLabelType},       "aderes/_dspfunc.p":u,
                                           "RunDirty,l-type.p,1":u,
                                           {&rlAdminLabelType},
                                           {&rhAdminLabelType}).

RUN AddFeature( {&rfAdminLabelField},      "aderes/_dspfunc.p":u,
                                           "RunSingle,_alabel.p":u,
                                           {&rlAdminLabelField},
                                           {&rhAdminLabelField}).

RUN AddFeature( {&rfAdminOptions},         "aderes/_dspfunc.p":u,
                                           "RunDirty,_acust.p":u,
                                           {&rlAdminOptions},
                                           {&rhAdminOptions}).

RUN AddFeature( {&rfAdminIntegration},     "aderes/_dspfunc.p":u,
                                           "RunSingle,_aint.p":u,
                                           {&rlAdminOptions},
                                           {&rhAdminIntegration}).

RUN AddFeature( {&rfAdminDeployment},      "aderes/_dspfunc.p":u,
                                           "RunSingle,_adeploy.p":u,
                                           {&rlAdminOptions},
                                           {&rhAdminDeployment}).

RUN AddFeature( {&rfExit},                 "aderes/_dspfunc.p":u,
                                           "Exit,":u,
                                           {&rlExit},
                                           {&rhExit}).

RUN AddFeature( {&rfTable},                "aderes/_dspfunc.p":u,
                                           "RunDirty,y-table.p":u,
                                           {&rlTable},
                                           {&rhTable}).

RUN AddFeature( {&rfJoin},                 "aderes/_dspfunc.p":u,
                                           "RunDirty,s-join.p":u,
                                           {&rlJoin},
                                           {&rhJoin}).

RUN AddFeature( {&rfInclude},              "aderes/_dspfunc.p":u,
                                           "RunDirty,s-inc.p":u,
                                           {&rlInclude},
                                           {&rhInclude}).

RUN AddSubMenuFeature(                     {&rfCalcSubMenu},
                                           "",
                                           {&rlCalcSubMenu},
                                           {&rhCalcSubMenu}).

RUN AddFeature( {&rfFields},               "aderes/_dspfunc.p":u,
                                           "RunDirty,y-field.p":u,
                                           {&rlFields},
                                           {&rhFields}).

RUN AddFeature( {&rfTotals},               "aderes/_dspfunc.p":u,
                                           "RunDirty,y-total.p":u,
                                           {&rlTotals},
                                           {&rhTotals}).

RUN AddFeature( {&rfFieldProps},           "aderes/_dspfunc.p":u,
                                           "RunDirty,y-format.p,qbf-index":u,
                                           {&rlFieldProps},
                                           {&rhFieldProps}).
								      
RUN AddFeature( {&rfPercentTotal},         "aderes/_dspfunc.p":u,
                                           "ipFields,p":u,
                                           {&rlPercentTotal},
                                           {&rhPercentTotal}).

RUN AddFeature( {&rfRunningTotal},         "aderes/_dspfunc.p":u,
                                           "ipFields,r":u,
                                           {&rlRunningTotal},
                                           {&rhRunningTotal}).

RUN AddFeature( {&rfCounter},              "aderes/_dspfunc.p":u,
                                           "ipFields,c":u,
                                           {&rlCounter},
                                           {&rhCounter}).

RUN AddFeature( {&rfArray},                "aderes/_dspfunc.p":u,
                                           "ipFields,e":u,
                                           {&rlArray},
                                           {&rhArray}).

RUN AddFeature( {&rfLookup},               "aderes/_dspfunc.p":u,
                                           "ipFields,x":u,
                                           {&rlLookup},
                                           {&rhLookup}).

RUN AddFeature( {&rfMath},                 "aderes/_dspfunc.p":u,
                                           "ipFields,m":u,
                                           {&rlMath},
                                           {&rhMath}).

RUN AddFeature( {&rfStringFunc},           "aderes/_dspfunc.p":u,
                                           "ipFields,s":u,
                                           {&rlStringFunc},
                                           {&rhStringFunc}).

RUN AddFeature( {&rfNumericFunc},          "aderes/_dspfunc.p":u,
                                           "ipFields,n":u,
                                           {&rlNumericFunc},
                                           {&rhNumericFunc}).

RUN AddFeature( {&rfDateFunc},             "aderes/_dspfunc.p":u,
                                           "ipFields,d":u,
                                           {&rlDateFunc},
                                           {&rhDateFunc}).

RUN AddFeature( {&rfLogicalFunc},          "aderes/_dspfunc.p":u,
                                           "ipFields,l":u,
                                           {&rlLogicalFunc},
                                           {&rhLogicalFunc}).

RUN AddFeatureTb( {&rfSelection},          "aderes/_dspfunc.p":u,
                                           "RunDirty,s-where.p":u,
                                           {&rlSelection},
                                           {&riSelection},
                                           {&rhSelection}).

RUN AddFeature( {&rfGovernor},             "aderes/_dspfunc.p":u,
                                           "RunDirty,_governr.p":u,
                                           {&rlGovernor},
                                           {&rhGovernor}).

RUN AddFeature( {&rfReAsk},                "aderes/_dspfunc.p":u,
                                           "RunDirty,_reask.p":u,
                                           {&rlReAsk},
                                           {&rhReAsk}).

RUN AddFeatureTb( {&rfSortOrdering},       "aderes/_dspfunc.p":u,
                                           "RunDirty,y-sort.p":u,
                                           {&rlSortOrdering},
                                           {&riSortOrdering},
                                           {&rhSortOrdering}).

RUN AddFeature( {&rfInformation},          "aderes/_dspfunc.p":u,
                                           "RunSingle,s-info.p":u,
                                           {&rlInformation},
                                           {&rhInformation}).

RUN AddFeature( {&rfHeadersAndFooters},    "aderes/_dspfunc.p":u,
                                           "RunDirty,r-header.p":u,
                                           {&rlHeadersAndFooters},
                                           {&rhHeadersAndFooters}).

RUN AddFeature( {&rfMasterDetail},         "aderes/_dspfunc.p":u,
                                           "RunDirty,r-level.p":u,
                                           {&rlMasterDetail},
                                           {&rhMasterDetail}).

RUN AddFeature( {&rfTotalsOnly},           "aderes/_dspfunc.p":u,
                                           "RunDirty,r-short.p":u,
                                           {&rlTotalsOnly},
                                           {&rhTotalsOnly}).

RUN AddFeature( {&rfFrameProps},           "aderes/_dspfunc.p":u,
                                           "RunDirty,_fbprop.p":u,
                                           {&rlFrameProps},
                                           {&rhFrameProps}).

RUN AddFeature( {&rfStandardReport},       "aderes/_dspfunc.p":u,
                                           "RunDirty,p-type.p,0":u,
                                           {&rlStandardReport},
                                           {&rhStandardReport}).

RUN AddFeature( {&rfCustomReport},         "aderes/_dspfunc.p":u,
                                           "RunDirty,r-layout.p":u,
                                           {&rlCustomReport},
                                           {&rhCustomReport}).

RUN AddFeature( {&rfPageBreak},            "aderes/_dspfunc.p":u,
                                           "NewPage,":u,
                                           {&rlPageBreak},
                                           {&rhPageBreak}).

RUN AddFeature( {&rfStandardLabel},        "aderes/_dspfunc.p":u,
                                           "RunDirty,l-type.p,0":u,
                                           {&rlStandardLabel},
                                           {&rhStandardLabel}).

RUN AddFeature( {&rfStandardExport},       "aderes/_dspfunc.p":u,
                                           "RunDirty,e-type.p,0":u,
                                           {&rlStandardExport},
                                           {&rhStandardExport}).

RUN AddFeature( {&rfCustomLabel},          "aderes/_dspfunc.p":u,
                                           "RunDirty,l-layout.p":u,
                                           {&rlCustomLabel},
                                           {&rhCustomLabel}).

RUN AddFeature( {&rfOutputHeader},         "aderes/_dspfunc.p":u,
                                           "Headers,h":u,
                                           {&rlOutputHeader},
                                           {&rhOutputHeader}).

RUN AddFeature( {&rfFixedWidth},           "aderes/_dspfunc.p":u,
                                           "Headers,f":u,
                                           {&rlFixedWidth},
                                           {&rhFixedWidth}).

RUN AddFeature( {&rfRecordStart},          "aderes/_dspfunc.p":u,
                                           "Custom,b":u,
                                           {&rlRecordStart},
                                           {&rhRecordStart}).

RUN AddFeature( {&rfRecordEnd},            "aderes/_dspfunc.p":u,
                                           "Custom,l":u,
                                           {&rlRecordEnd},
                                           {&rhRecordEnd}).

RUN AddFeature( {&rfFieldDelims},          "aderes/_dspfunc.p":u,
                                           "Custom,f":u,
                                           {&rlFieldDelims},
                                           {&rhFieldDelims}).

RUN AddFeature( {&rfFieldSeps},            "aderes/_dspfunc.p":u,
                                           "Custom,s":u,
                                           {&rlFieldSeps},
                                           {&rhFieldSeps}).

RUN AddFeatureTb( {&rfBrowseView},         "aderes/_dspfunc.p":u,
                                           "ViewAs,b":u,
                                           {&rlBrowseView},
                                           {&riBrowseView},
                                           {&rhBrowseView}).

RUN AddFeatureTb( {&rfReportView},         "aderes/_dspfunc.p":u,
                                           "ViewAs,r":u,
                                           {&rlReportView},
                                           {&riReportView},
                                           {&rhReportView}).

RUN AddFeatureTb( {&rfFormView},           "aderes/_dspfunc.p":u,
                                           "ViewAs,f":u,
                                           {&rlFormView},
                                           {&riFormView},
                                           {&rhFormView}).

RUN AddFeatureTb( {&rfLabelView},          "aderes/_dspfunc.p":u,
                                           "ViewAs,l":u,
                                           {&rlLabelView},
                                           {&riLabelView},
                                           {&rhLabelView}).

RUN AddFeatureTb( {&rfExportView},         "aderes/_dspfunc.p":u,
                                           "ViewAs,e":u,
                                           {&rlExportView},
                                           {&riExportView},
                                           {&rhExportView}).

RUN AddFeature( {&rfToolBar},              "aderes/_dspfunc.p":u,
                                           "ToolView,t":u,
                                           {&rlToolBar},
                                           {&rhToolBar}).
									       
RUN AddFeature( {&rfStatusLine},           "aderes/_dspfunc.p":u,
                                           "ToolView,s":u,
                                           {&rlStatusLine},
                                           {&rhStatusLine}).
									       
RUN AddFeature( {&rfHelpTopics},           "aderes/_dspfunc.p":u,
                                           "RunHelp,topics":u,
                                           {&rlHelpTopics},
                                           {&rhHelpTopics}).

RUN AddFeature( {&rfHelpContents},         "aderes/_dspfunc.p":u,
                                           "RunHelp,contents":u,
                                           {&rlHelpContents},
                                           {&rhHelpContents}).

RUN AddFeature( {&rfHelpSearch},           "aderes/_dspfunc.p":u,
                                           "RunHelp,search":u,
                                           {&rlHelpSearch},
                                           {&rhHelpSearch}).

RUN AddFeature( {&rfHowTo},                "aderes/_dspfunc.p":u,
                                           "RunHelp,howto":u,
                                           {&rlHowTo},
                                           {&rhHowTo}).

RUN AddFeature( {&rfMessages},             "aderes/_dspfunc.p":u,
                                           "RunHelp,messages":u,
                                           {&rlMessages},
                                           {&rhMessages}).

RUN AddFeature( {&rfRecentMessages},       "aderes/_dspfunc.p":u,
                                           "RunHelp,recentmsgs":u,
                                           {&rlRecentMessages},
                                           {&rhRecentMessages}).
								           
RUN AddFeature( {&rfAboutResults},         "aderes/_dspfunc.p":u,
                                           "RunHelp,aboutres":u,
                                           {&rlAboutResults},
                                           {&rhAboutResults}).

RUN AddFeature( {&rfReadOtherDir}, "", "", "", {&rhReadOtherDir}).
RUN AddFeature( {&rfReadPublicDir}, "", "", "", {&rhReadPublicDir}).
RUN AddFeature( {&rfWriteOtherDir}, "", "", "", {&rhWriteOtherDir}).
RUN AddFeature( {&rfWritePublicDir}, "", "", "", {&rhWritePublicDir}).
RUN AddFeature( {&rfRecordAdd}, "", "", "", {&rhRecordAdd}).
RUN AddFeature( {&rfRecordDelete}, "", "", "", {&rhRecordDelete}).
RUN AddFeature( {&rfRecordUpdate}, "", "", "", {&rhRecordUpdate}).

RUN adeshar/_mupdatm.p({&resId}).

/*--------------------------------------------------------------------------*/
PROCEDURE AddFeatureTb:
  DEFINE INPUT PARAMETER featureId    AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER func         AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER args         AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER featureLabel AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER image        AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER microHelp    AS CHARACTER NO-UNDO.

  /*
   * The only difference between this and AddFeature is that this function
   * handles Icons. Other than that, a feature is a feature is a feature...
   */

  DEFINE variable s      as logical NO-UNDO.

  RUN adeshar/_maddf.p({&resId}, featureId,
                       {&mnuItemType},
                       func,
                       args,
                       featureLabel,
                       "adeicon/":u + image + "-u":U,
                       "",
                       "",
                       microHelp,
                       FALSE,
                       "",
                       "*":u,
                       OUTPUT s).
END PROCEDURE.

/*--------------------------------------------------------------------------*/
PROCEDURE AddFeature:
  DEFINE INPUT PARAMETER featureId    AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER func         AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER args         AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER featureLabel AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER microHelp    AS CHARACTER NO-UNDO.

  RUN AddFeatureTb(featureId, func, args, featureLabel, ?, microHelp).
END PROCEDURE.

/*--------------------------------------------------------------------------*/
PROCEDURE AddSubMenuFeature:
  DEFINE INPUT PARAMETER featureId    AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER args         AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER featureLabel AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER microHelp    AS CHARACTER NO-UNDO.

  DEFINE VARIABLE lReturn AS LOGICAL NO-UNDO.

  RUN adeshar/_maddf.p({&resId}, featureId,
                                 {&mnuSubMenuType},
                                 "",
                                 args,
                                 featureLabel,
                                 ?,
                                 ?,
                                 ?,
                                 microHelp,
                                 FALSE,
                                 "",
                                 "*":u,
                                 OUTPUT lReturn).
END PROCEDURE.

/* 	af-init.p - end of file */

