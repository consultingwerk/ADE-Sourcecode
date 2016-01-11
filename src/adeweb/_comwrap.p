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
