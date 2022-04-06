/*********************************************************************
* Copyright (C) 2007 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*--------------------------------------------------------------------------
    File        : gopendialog.w
    Purpose     : Open Object Dialog for repository objects.

    Syntax      : 

    Input Parameters:
      phWindow            : Window in which to display the dialog box.
      gcProductModule     : Initial Product Module Code.
      glOpenInAppBuilder  : Open in Appbuilder
      pcTitle             : Title for Dialog Window to be launched

    Output Parameters:
      gcFileName          : The filename selected.
      pressedOK           : TRUE if user successfully choose an object file name.

    Description: from cntnrdlg.w - ADM2 SmartDialog Template

    History     :
                  05/24/2002     Updated By           Don Bulua
                  - IZ 2433, Added search on filename with timer, 
                  - Greatly improved query when 'Display Repostiory Data' set to yes.
                  - Modifed batch rows from 20 to 100
                  - IZ:4571 - restuctured adm calls
                  - Added most recent used combo-box displaying filename and description
                  - Save MRU and column sizes as user profiles
                  - Added verification for existence of static files. 
           
    
                  02/25/2002      Updated by          Ross Hunter
                  Allow the reading of Dynamic Viewers (DynView)

                  11/20/2001      Updated by          John Palazzo (jep)
                  IZ 3195 Description missing from PM list.
                  Fix: Added description to PM list: "code // description".

                  09/30/2001      Updated by          John Palazzo (jep)
                  IZ 2009 Objects the AB can't open are in dialog.
                  Fix: Filter the Object Type combo query and the
                  SDO query with preprocessor gcOpenObjectTypes, which
                  lists the object type codes that the AB knows to open.

                  09/30/2001      Updated by          John Palazzo (jep)
                  IZ 1940 Long delay in Open Object dialog browser.
                  Fix: Changed rows-to-batch instance property for SDO
                  to 20 (was 200).
                  
                  08/16/2001      created by          Yongjian Gu
                  
                  04/12/2001      Update By           Peter Judge
                  IZ3130: Change delimiter in combos from comma to CHR(3)
                  to avoid issue with non-American numeric formats.
------------------------------------------------------------------------*/
/* Parameters Definitions ---                                           */
DEFINE INPUT  PARAMETER phWindow           AS HANDLE NO-UNDO.
define input  parameter gcProductModule    as character no-undo.
DEFINE INPUT  PARAMETER glOpenInAppBuilder AS LOGICAL    NO-UNDO.
DEFINE INPUT  PARAMETER pcTitle            AS CHARACTER  NO-UNDO.
define output parameter gcFilename         as character no-undo.
DEFINE OUTPUT PARAMETER pressedOK          AS LOGICAL.

{src/adm2/globals.i}

def var cButtonPressed as character no-undo.

run showMessages in gshSessionManager ({aferrortxt.i 'AF' '40' '?' '?' '"This procedure (ry/obj/gopendialog.w) has been deprecated. Please report any occurrences of this message to Tech Support"'},
                                       'INF',
                                       '&Ok',
                                       '&Ok',
                                       '&Ok',
                                       'Deprecated procedure',
                                       Yes,
                                       ?,
                                       output cButtonPressed) no-error.

run adeuib/_opendialog.w (phWindow,
                          gcProductModule,
                          glOpenInAppBuilder,
                          pcTitle,
                          output gcFilename,
                          output pressedOK ).
