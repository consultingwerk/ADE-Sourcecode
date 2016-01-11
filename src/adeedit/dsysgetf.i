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

/*****************************************************************************

    Procedure  :  dsysgetf.i

    Syntax     :
                  { adeedit/dsysgetf.i }

    Description:

    GET-FILE defiinitions.  Use to maintain the File Filter descriptions
    and patterns.  These are used for the List Files of Type box in the
    File Open, File Save As, etc. dialog boxes.

    Notes     : Prodedure file is psysgetf.i .

    Author    : John Palazzo
    Date      : 02.09.93

*****************************************************************************/

  &SCOPED-DEFINE Max_Filters 6

  DEFINE VAR Filter_Desc    AS CHAR NO-UNDO.
  DEFINE VAR Filter_Pattern AS CHAR NO-UNDO.
  DEFINE VAR Filter_NameString AS CHAR EXTENT {&Max_Filters} NO-UNDO.
  DEFINE VAR Filter_FileSpec   AS CHAR EXTENT {&Max_Filters} NO-UNDO.
