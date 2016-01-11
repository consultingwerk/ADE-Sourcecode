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
* _msett.p
*
*  Build the default layout for the toolbar
*
*  This file assumes that all features have already been defined!
*/

{ aderes/_fdefs.i }
{ aderes/s-system.i }
{ adeshar/_mnudefs.i }

RUN AddButton({&rfNewDuplicateView},  {&riNewDuplicateView},  1).
RUN AddButton({&rfFileOpen},          {&riFileOpen},          2).
RUN AddButton({&rfFileSave},          {&riFileSave},          3).
RUN AddButton({&rfPrintPrinterNoBox}, {&riPrintPrinterNoBox}, 4).
RUN AddButton({&rfPrintPreview},      {&riPrintPreview},      5).
RUN AddButton({&rfSelection},         {&riSelection},         7).
RUN AddButton({&rfSortOrdering},      {&riSortOrdering},      8).
RUN AddButton({&rfBrowseView},        {&riBrowseView},       10).
RUN AddButton({&rfReportView},        {&riReportView},       11).
RUN AddButton({&rfFormView},          {&riFormView},         12).
RUN AddButton({&rfLabelView},         {&riLabelView},        13).
RUN AddButton({&rfExportView},        {&riExportView},       14).

RUN adeshar/_mupdatt.p({&resId}).

/* ---------------------------------------------------------------------- */
PROCEDURE AddButton:
  DEFINE INPUT PARAMETER featureId AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER image     AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER slot      AS INTEGER   NO-UNDO.

  DEFINE VARIABLE qbf-x AS INTEGER   NO-UNDO.
  DEFINE VARIABLE qbf-s AS LOGICAL   NO-UNDO.

  qbf-x = ((slot - 1) * {&mnuIconSize}) + {&mnuIconOffset}.
  RUN adeshar/_maddt.p ({&resId}, featureId,
                        {&resToolbar},
                        "adeicon/":u + image + "-u":U,
                        "",
                        "",
                        qbf-x,
                        {&mnuIconY},
                        {&mnuIconSize},
                        {&mnuIconSize},
                        {&tbItemType},
                        FALSE,
                        ?,
                        OUTPUT qbf-s).
END.

/* _msett.p - end of file */

