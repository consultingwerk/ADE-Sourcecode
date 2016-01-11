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
* _mset.p
*
*    Builds the menu and toolbar structures for Results. This includes
*    building the menu feature list, which is not to be confused
*    with the Progress feature list. Although they are both share
*    the same ids.
*
*/

{ aderes/s-system.i }
{ aderes/s-menu.i }
{ aderes/_fdefs.i }
{ adeshar/_mnudefs.i }

DEFINE INPUT PARAMETER appId       AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER dispToolbar AS LOGICAL   NO-UNDO.

/* Reset/create the menu structure */

/* ------------------- File Menu ----------------------*/
  
RUN AddMenu({&rlFile}).

RUN AddSubM( {&rfNewSubMenu},       {&rlFile}, {&rlNewSubMenu}).
RUN AddItem( {&rfNewBrowseView},    {&rlNewSubMenu}, {&rlNewBrowseView}).
RUN AddItem( {&rfNewReportView},    {&rlNewSubMenu}, {&rlNewReportView}).
RUN AddItem( {&rfNewFormView},      {&rlNewSubMenu}, {&rlNewFormView}).
RUN AddItem( {&rfNewLabelView},     {&rlNewSubMenu}, {&rlNewLabelView}).
RUN AddItem( {&rfNewExportView},    {&rlNewSubMenu}, {&rlNewExportView}).
RUN AddItem( {&rfFileOpen},         {&rlFile}, {&rlFileOpen}).
RUN AddItem( {&rfFileSave},         {&rlFile}, {&rlFileSave}).
RUN AddItem( {&rfFileSaveAs},       {&rlFile}, {&rlFileSaveAs}).
RUN AddItem( {&rfFileClose},        {&rlFile}, {&rlFileClose}).
RUN AddItem( {&rfFileDelete},       {&rlFile}, {&rlFileDelete}).
RUN AddItem( {&rfGenerate},         {&rlFile}, {&rlGenerate}).

RUN AddSep ( {&rlFile}).
RUN AddSubM( {&rfPrintSubMenu},     {&rlFile}, {&rlPrintSubMenu}).
RUN AddItem( {&rfPrintPrinter},     {&rlPrintSubMenu}, {&rlPrintPrinter}).
RUN AddItem( {&rfPrintClip},        {&rlPrintSubMenu}, {&rlPrintClip}).
RUN AddItem( {&rfPrintFile},        {&rlPrintSubMenu}, {&rlPrintFile}).
RUN AddItem( {&rfPrintPreview},     {&rlFile}, {&rlPrintPreview}).

RUN AddSep ( {&rlFile}).
RUN AddSubM( {&rfAdminSubMenu},     {&rlFile}, {&rlAdminSubMenu}).
RUN AddItem( {&rfAdminRelations},   {&rlAdminSubMenu}, {&rlAdminRelations}).
RUN AddItem( {&rfAdminWhere},       {&rlAdminSubMenu}, {&rlAdminWhere}).
RUN AddItem( {&rfAdminTableAlias},  {&rlAdminSubMenu}, {&rlAdminTableAlias}).

RUN AddSep ( {&rlAdminSubMenu}).
RUN AddItem( {&rfAdminRebuild},     {&rlAdminSubMenu}, {&rlAdminRebuild}).
RUN AddItem( {&rfAdminPerm},        {&rlAdminSubMenu}, {&rlAdminPerm}).

RUN AddSep ( {&rlAdminSubMenu}).
RUN AddItem( {&rfAdminReportType},  {&rlAdminSubMenu}, {&rlAdminReportType}).
RUN AddItem( {&rfAdminExportType},  {&rlAdminSubMenu}, {&rlAdminExportType}).
RUN AddItem( {&rfAdminLabelType},   {&rlAdminSubMenu}, {&rlAdminLabelType}).
RUN AddItem( {&rfAdminLabelField},  {&rlAdminSubMenu}, {&rlAdminLabelField}).

RUN AddSubM( {&rfProgSubMenu},      {&rlFile}, {&rlProgSubMenu}).
RUN AddItem( {&rfAdminFeature},     {&rlProgSubMenu}, {&rlAdminFeature}).
RUN AddItem( {&rfAdminMenuEdit},    {&rlProgSubMenu}, {&rlAdminMenuEdit}).
RUN AddItem( {&rfAdminToolbarEdit}, {&rlProgSubMenu}, {&rlAdminToolbarEdit}).

RUN AddSep ( {&rlProgSubMenu}).
RUN AddItem( {&rfAdminIntegration}, {&rlProgSubMenu}, {&rlAdminIntegration}).
RUN AddItem( {&rfAdminDeployment},  {&rlProgSubMenu}, {&rlAdminDeployment}).
RUN AddItem( {&rfAdminReset},       {&rlProgSubMenu}, {&rlAdminReset}).

RUN AddSep ( {&rlProgSubMenu}).
RUN AddItem( {&rfAdminOptions},     {&rlProgSubMenu}, {&rlAdminOptions}).

RUN AddSep ( {&rlFile}).
RUN AddItem( {&rfExit},             {&rlFile}, {&rlExit}).

/* ------------------- Table Menu ----------------------*/

RUN AddMenu({&rlTableMenu}).
RUN AddItem( {&rfTable},            {&rlTableMenu}, {&rlTable}).
RUN AddItem( {&rfJoin},             {&rlTableMenu}, {&rlJoin}).

/* ------------------- Field Menu ----------------------*/

RUN AddMenu({&rlFieldMenu}).
RUN AddItem( {&rfFields},           {&rlFieldMenu}, {&rlFields}).

RUN AddSep ( {&rlFieldMenu}).

RUN AddSubM( {&rfCalcSubMenu},      {&rlFieldMenu}, {&rlCalcSubMenu}).
RUN AddItem( {&rfPercentTotal},     {&rlCalcSubMenu}, {&rlPercentTotal}).
RUN AddItem( {&rfRunningTotal},     {&rlCalcSubMenu}, {&rlRunningTotal}).
RUN AddItem( {&rfCounter},          {&rlCalcSubMenu}, {&rlCounter}).
RUN AddItem( {&rfArray},            {&rlCalcSubMenu}, {&rlArray}).
RUN AddItem( {&rfLookup},           {&rlCalcSubMenu}, {&rlLookup}).
RUN AddItem( {&rfMath},             {&rlCalcSubMenu}, {&rlMath}).
RUN AddItem( {&rfStringFunc},       {&rlCalcSubMenu}, {&rlStringFunc}).
RUN AddItem( {&rfNumericFunc},      {&rlCalcSubMenu}, {&rlNumericFunc}).
RUN AddItem( {&rfDateFunc},         {&rlCalcSubMenu}, {&rlDateFunc}).
RUN AddItem( {&rfLogicalFunc},      {&rlCalcSubMenu}, {&rlLogicalFunc}).
RUN AddItem( {&rfTotals},           {&rlFieldMenu}, {&rlTotals}).
RUN AddItem( {&rfFieldProps},       {&rlFieldMenu}, {&rlFieldProps}).

/* ------------------- Data Menu ----------------------*/

RUN AddMenu({&rlData}).
RUN AddItem( {&rfSelection},     {&rlData}, {&rlSelection}).
RUN AddItem( {&rfReAsk},         {&rlData}, {&rlReAsk}).
RUN AddItem( {&rfSortOrdering},  {&rlData}, {&rlSortOrdering}).
RUN AddItem( {&rfGovernor},      {&rlData}, {&rlGovernor}).

/* ------------------- Options Menu ----------------------*/

RUN AddMenu({&rlOptions}).
RUN AddItem( {&rfInformation},       {&rlOptions}, {&rlInformation}).
RUN AddItem( {&rfHeadersAndFooters}, {&rlOptions}, {&rlHeadersAndFooters}).
RUN AddItem( {&rfMasterDetail},      {&rlOptions}, {&rlMasterDetail}).
RUN AddItem( {&rfFrameProps},        {&rlOptions}, {&rlFrameProps}).
RUN AddItem( {&rfTotalsOnly},        {&rlOptions}, {&rlTotalsOnly}).

RUN AddSep ( {&rlOptions}).
RUN AddItem( {&rfStandardReport},    {&rlOptions}, {&rlStandardReport}).
RUN AddItem( {&rfCustomReport},      {&rlOptions}, {&rlCustomReport}).
RUN AddItem( {&rfPageBreak},         {&rlOptions}, {&rlPageBreak}).

RUN AddSep ( {&rlOptions}).
RUN AddItem( {&rfStandardLabel},     {&rlOptions}, {&rlStandardLabel}).
RUN AddItem( {&rfCustomLabel},       {&rlOptions}, {&rlCustomLabel}).

RUN AddSep ( {&rlOptions}).
RUN AddItem( {&rfStandardExport},    {&rlOptions}, {&rlStandardExport}).
RUN AddSubM( {&rfExportSubMenu},     {&rlOptions}, {&rlExportSubMenu}).
RUN AddTogg( {&rfOutputHeader},      {&rlExportSubMenu}, {&rlOutputHeader}).
RUN AddTogg( {&rfFixedWidth},        {&rlExportSubMenu}, {&rlFixedWidth}).

RUN AddSep ( {&rlExportSubMenu}).
RUN AddItem( {&rfRecordStart},       {&rlExportSubMenu}, {&rlRecordStart}).
RUN AddItem( {&rfRecordEnd},         {&rlExportSubMenu}, {&rlRecordEnd}).
RUN AddItem( {&rfFieldDelims},       {&rlExportSubMenu}, {&rlFieldDelims}).
RUN AddItem( {&rfFieldSeps},         {&rlExportSubMenu}, {&rlFieldSeps}).

/* ------------------- View Menu ----------------------*/

RUN AddMenu( {&rlViewMenu} ).
RUN AddItem( {&rfBrowseView},     {&rlViewMenu}, {&rlBrowseView}).
RUN AddItem( {&rfReportView},     {&rlViewMenu}, {&rlReportView}).
RUN AddItem( {&rfFormView},       {&rlViewMenu}, {&rlFormView}).
RUN AddItem( {&rfLabelView},      {&rlViewMenu}, {&rlLabelView}).
RUN AddItem( {&rfExportView},     {&rlViewMenu}, {&rlExportView}).

RUN AddSep ( {&rlViewMenu}).
RUN AddTogg( {&rfToolBar},        {&rlViewMenu}, {&rlToolBar}).
RUN AddTogg( {&rfStatusLine},     {&rlViewMenu}, {&rlStatusLine}).

/* ------------------- Help Menu ----------------------*/

RUN AddMenu({&rlHelp}).

RUN AddItem( {&rfHelpTopics},   {&rlHelp}, {&rlHelpTopics}).
RUN AddSep ( {&rlHelp}).
RUN AddItem( {&rfMessages},       {&rlHelp}, {&rlMessages}).
RUN AddItem( {&rfRecentMessages}, {&rlHelp}, {&rlRecentMessages}).

RUN AddSep ( {&rlHelp}).
RUN AddItem( {&rfAboutResults}, {&rlHelp}, {&rlAboutResults}).

RUN adeshar/_mupdatm.p ({&resId}).

/*
* Now build the toolbar. THe toolbar defs are in a seperate file so that
* the toolbar can be built seperately as needed. The reason the toolbar must
* built now is because of the .r version that an admin can build. There is
* only one menu definition file for the GUI.
*/

IF (dispToolbar) THEN
  RUN aderes/_msett.p.

/*--------------------------------------------------------------------------*/
PROCEDURE AddSep:
  DEFINE INPUT  PARAMETER parentId AS CHARACTER NO-UNDO.

  DEFINE VARIABLE s       AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE sepName AS CHARACTER NO-UNDO.

  RUN adeshar/_msepnm.p ({&resId}, OUTPUT sepName).
  RUN adeshar/_maddi.p ({&resId}, {&mnuSepFeature},
    parentId,
    sepName,
    {&mnuSepType},
    FALSE,
    "",
    OUTPUT s).
END PROCEDURE.

/*--------------------------------------------------------------------------*/
PROCEDURE AddItem:
  DEFINE INPUT  PARAMETER featureId AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER parentId  AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER itemLabel AS CHARACTER NO-UNDO.

  DEFINE VARIABLE s AS LOGICAL NO-UNDO.

  RUN adeshar/_maddi.p ({&resId}, featureId,
    parentId,
    itemLabel,
    {&mnuItemType},
    FALSE,
    "",
    OUTPUT s).
END PROCEDURE.

/*--------------------------------------------------------------------------*/
PROCEDURE AddSubM:
  DEFINE INPUT  PARAMETER featureId AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER parentId  AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER itemLabel AS CHARACTER NO-UNDO.

  DEFINE VARIABLE s AS LOGICAL NO-UNDO.

  RUN adeshar/_maddi.p ({&resId}, featureId,
    parentId,
    itemLabel,
    {&mnuSubMenuType},
    FALSE,
    "",
    OUTPUT s).
END PROCEDURE.

/*--------------------------------------------------------------------------*/
PROCEDURE AddTogg:
  DEFINE INPUT  PARAMETER featureId AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER parentId  AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER itemLabel AS CHARACTER NO-UNDO.

  DEFINE VARIABLE s AS LOGICAL NO-UNDO.

  RUN adeshar/_maddi.p ({&resId}, featureId,
    parentId,
    itemLabel,
    {&mnuToggleType},
    FALSE,
    "",
    OUTPUT s).
END PROCEDURE.

/*--------------------------------------------------------------------------*/
PROCEDURE AddMenu:
  DEFINE INPUT PARAMETER menuLabel AS CHARACTER NO-UNDO.

  DEFINE VARIABLE qbf-s AS LOGICAL NO-UNDO.

  RUN adeshar/_maddm.p ({&resId},menuLabel,"","aderes/_mstate.p",
                        OUTPUT qbf-s).
END PROCEDURE.

/* _mset.p -  end of file */
