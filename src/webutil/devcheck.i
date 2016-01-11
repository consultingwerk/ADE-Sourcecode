&IF FALSE &THEN
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
**********************************************************************
  webutil/devcheck.i  -- Workshop Development check 
  
  Included in all workshop files that might be run from the browser.
  This is intended to prevent unauthorized browsers from using any 
  workshop or webtools file if Agent Mode is "PRODUCTION".
 
  Author:  Wm.T.Wood    
  Created: 04/01/97
---------------------------------------------------------------------*/
&ENDIF

/* If production mode, then display an error and return. */
IF check-agent-mode ("PRODUCTION":U) THEN DO:
  /* Give a similar error to what web-util.p gives if the file wasn't found */
  RUN HtmlError IN web-utilities-hdl 
      (SUBSTITUTE ("Unable to run web object file '&1'", THIS-PROCEDURE:FILE-NAME )).
  RETURN.
END.

/* devcheck.i - end of file */
