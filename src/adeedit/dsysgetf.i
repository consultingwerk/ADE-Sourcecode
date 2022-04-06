/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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
