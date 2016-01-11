/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*   Per S Digre (pdigre@progress.com)                                *
*                                                                    *
*********************************************************************/
/*--------------------------------------------------------------------
File: error.p
Purpose: Code to show current logs in a window programs.
Author(s) :Per S Digre/PSC
Updated: 04/04/00 pdigre@progress.com
           Initial version
         04/25/01 adams@progress.com
           WebSpeed integration
--------------------------------------------------------------------*/

{ src/web/method/cgidefs.i }
{ webtools/plus.i }

fHeader().

DYNAMIC-FUNCTION ("LogNote" IN web-utilities-hdl,
                  "error", "Error:" + get-value("error")) NO-ERROR.

{&OUT} '<H1>Error:</H1>~n' get-value("error").

fFooter().
