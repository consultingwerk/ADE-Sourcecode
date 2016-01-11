&IF FALSE &THEN
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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
