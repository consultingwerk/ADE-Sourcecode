/*************************************************************/  
/* Copyright (c) 1984-2007 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*---------------------------------------------------------------------------------
  File: afsvwizdw.w

  Description:  Save repository object wizard

  Purpose:

  Parameters:

  History:
  --------
  (v:010000)    Task:           1   UserRef:    
                Date:   02/01/2003  Author:     Thomas Hansen

  Update Notes: 02/02/03 thomas:
                Object checked out to update workspace with posse_main changes.

  (v:010001)    Task:           9   UserRef:    
                Date:   02/14/2003  Author:     Thomas Hansen

  Update Notes: Issue 8579
                Added support for RTB workspace root paths

  (v:010002)    Task:          18   UserRef:    
                Date:   02/28/2003  Author:     Thomas Hansen

  Update Notes: Issue 3533:
                Extended reference to RTB include files to be :
                scm/rtb/inc/ryrtbproch.i
                
                Changed syntax to not make use of RTB variables but use session parameter as much as possible instead..
                
                Also changed getting of root directories to use the new getSessionRootDirectory API.

  (v:020000)    Task:          49   UserRef:    
                Date:   06/20/2003  Author:     Thomas Hansen

  Update Notes: Clean up code to remove scmTool references.

-------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/
/* Parameters Definitions ---                                           */
&IF DEFINED(UIB_is_Running) = 0 &THEN
  DEFINE INPUT PARAMETER  plSaveAs       AS LOGICAL  NO-UNDO.
  DEFINE OUTPUT PARAMETER plRegisterObj  AS LOGICAL  NO-UNDO.
  DEFINE OUTPUT PARAMETER p_OK           AS LOGICAL  NO-UNDO .
    /* YES - User choose OK. NO - User choose Cancel.       */
&ELSE 
  DEFINE VARIABLE plSaveAs      AS LOGICAL  NO-UNDO.
  DEFINE VARIABLE plRegisterObj AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE p_OK          AS LOGICAL NO-UNDO.
&ENDIF

{src/adm2/globals.i}

def var cButtonPressed as character no-undo.

run showMessages in gshSessionManager ({aferrortxt.i 'AF' '40' '?' '?' '"This procedure (af/cod/afsvwizd.w) has been deprecated. Please report any occurrences of this message to Tech Support"'},
                                       'INF',
                                       '&Ok',
                                       '&Ok',
                                       '&Ok',
                                       'Deprecated procedure',
                                       Yes,
                                       ?,
                                       output cButtonPressed) no-error.


run adeuib/_saveaswizd.w (input plSaveAs, output plRegisterObj, output p_OK).
