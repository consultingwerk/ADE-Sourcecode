/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

  File: _comwrap.p

  Description:  API wrapper for adeweb/_webcom.w
  
  INPUT Parameters:
    pProcID     Not used.  Supply unknown value, ?.
    pBrokerURL  Host and messenger to reach WebSpeed agent
    pFileName   File to open or save
    pOptions    A string indicating what the intent of this call is, e.g.
                open, save.  
                 
  OUTPUT Parameters:
    pRelName    Relative path of file to open.
    
  INPUT-OUTPUT Parameters:
    pTempFile:  Local temp file name for opening/saving.  On an "open" this
                parameter is usually input empty and output with a filename. 
                On a "save" this parameter is input with a filename to copy 
                to the web.

  Author:  Doug Adams
  Created: 07/07/99

----------------------------------------------------------------------------*/

/* Local Variable Definitions */
{ adeuib/sharvars.i NEW}
{ adeuib/uniwidg.i NEW}

/* Parameters Definitions     */
DEFINE INPUT        PARAMETER pProcID    AS RECID     NO-UNDO.
DEFINE INPUT        PARAMETER pBrokerURL AS CHARACTER NO-UNDO.
DEFINE INPUT        PARAMETER pFileName  AS CHARACTER NO-UNDO.
DEFINE INPUT        PARAMETER pOptions   AS CHARACTER NO-UNDO.
DEFINE OUTPUT       PARAMETER pRelName   AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pTempFile  AS CHARACTER NO-UNDO.

RUN adeweb/_webcom.w (pProcID, pBrokerURL, pFileName, pOptions,
                      OUTPUT pRelName, INPUT-OUTPUT pTempFile).

/* _comwrap.p - end of file */
