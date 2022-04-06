&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME gDialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS gDialog
/*********************************************************************
* Copyright (C) 2000, 2007 by Progress Software Corporation.         *
* All rights reserved. Prior versions of this work may contain       *
* portions contributed by participants of Possenet.                  *
*                                                                    *
*********************************************************************/
/*--------------------------------------------------------------------------
    File        : ryaddfile.w
    Purpose     : AppBuilder's Add to Repository dialog box.

    Syntax      : RUN ry/obj/ryaddfile.w
                  (INPUT  phWindow,
                   INPUT  gcProductModule,
                   INPUT  gcFileName,
                   INPUT  gcType,
                   OUTPUT p_ok)

    Input Parameters:
        phWindow        : Window in which to display the dialog box.
        gcProductModule : Initial Product Module Code.
        gcFileName      : Full filename of object to add.
        gcType          : Initialo object type code (may be AppBuilder type)

    Output Parameters:
        p_ok      : TRUE if user successfully choose to add file to repos.

    Description: from cntnrdlg.w - ADM2 SmartDialog Template

    History     :

                  11/20/2001      Updated by          John Palazzo (jep)
                  IZ 3195 Description missing from PM list.
                  Fix: Added description to PM list: "code // description".

                  11/18/2001      Updated by          John Palazzo
                  IZ 2513 Error when trying to save structured include
                  Updated the FORMAT for coObjectType so code can extract
                  object type obj and codes correctly. Make database call
                  to FIND gsc_object_type using obj id. Should be replaced
                  with AppServer-aware call instead of straight db search.

                  11/10/2001      created by          John Palazzo
                  Based on gopendialog.w file.
------------------------------------------------------------------------*/
/* Parameters Definitions ---                                           */
DEFINE INPUT  PARAMETER phWindow        AS HANDLE       NO-UNDO.
define input  parameter gcProductModule as character    no-undo.
define input  parameter gcFilename      as character    no-undo.
DEFINE INPUT  PARAMETER gcType          AS CHARACTER    NO-UNDO.
DEFINE OUTPUT PARAMETER pressedOK       AS LOGICAL      NO-UNDO.

{src/adm2/globals.i}

def var cButtonPressed as character no-undo.

run showMessages in gshSessionManager ({aferrortxt.i 'AF' '40' '?' '?' '"This procedure (ry/obj/ryaddfile.w) has been deprecated. Please report any occurrences of this message to Tech Support"'},
                                       'INF',
                                       '&Ok',
                                       '&Ok',
                                       '&Ok',
                                       'Deprecated procedure',
                                       Yes,
                                       ?,
                                       output cButtonPressed) no-error.


run adeuib/_addreposfile.w (phWindow, gcProductModule, gcFilename, gcType, output pressedOK).

