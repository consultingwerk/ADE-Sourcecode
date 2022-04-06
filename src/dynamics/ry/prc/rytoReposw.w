&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME gDialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS gDialog 
/*********************************************************************
* Copyright (C) 2005-2007 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*--------------------------------------------------------------------------
    File        : rytoReposw.w
    Purpose     : AppBuilder's Save as a dynamic object dialog box.

    Syntax      : RUN ry/prc/rytoReposw.w
                  (INPUT  phWindow,
                   INPUT  gcProductModule,
                   INPUT  gcFileName,
                   INPUT  gcType,
                   OUTPUT pRyObject,
                   OUTPUT p_ok)
    
    Input Parameters:
        phWindow        : Window in which to display the dialog box.
        gcProductModule : Initial Product Module Code.
        gcFileName      : Full filename of object to add.
        gcType          : Initial object type code (may be AppBuilder type)
        pRecid          : RECID of the _P table
    
    Output Parameters:
        pRyObject : RECID of the RyObject Temp-table record with Object info
        p_ok      : TRUE if user successfully choose to add file to repos.

    Description: from cntnrdlg.w - ADM2 SmartDialog Template

    History     : 
                  03/08/2002      Created by          Ross Hunter  (DRH)
                  Created from ry/obj/ryaddfile.w
                  
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
DEFINE INPUT  PARAMETER phWindow        AS HANDLE       NO-UNDO.
DEFINE INPUT  PARAMETER gcProductModule as character no-undo.
DEFINE INPUT  PARAMETER gcFileName      as character no-undo.
DEFINE INPUT  PARAMETER gcType          AS CHARACTER    NO-UNDO.
DEFINE INPUT  PARAMETER pRecid          AS RECID        NO-UNDO.
DEFINE OUTPUT PARAMETER pRyObject       AS RECID        NO-UNDO.
DEFINE OUTPUT PARAMETER pressedOK       AS LOGICAL      NO-UNDO.

{src/adm2/globals.i}

def var cButtonPressed as character no-undo.

run showMessages in gshSessionManager ({errortxt.i 'AF' '40' '?' '?' '"This procedure (ry/prc/rytoReposw.w) has been deprecated. Please report any occurrences of this message to Tech Support"'},
                                       'INF',
                                       '&Ok',
                                       '&Ok',
                                       '&Ok',
                                       'Deprecated procedure',
                                       Yes,
                                       ?,
                                       output cButtonPressed) no-error.

run adeuib/_saveasdynobject.w (input  phWindow,
                               input  gcProductModule,
                               input  gcFilename,
                               input  gcType,
                               input  pRecid,
                               output pRyObject,
                               output pressedOK ).

/* EOF */

                                       