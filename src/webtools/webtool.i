&IF FALSE &THEN
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* ------------------------------------------------------------------------
 * webtool.i  -- WebTools Standard include file 
 * 
 * This should be included in all webtools.  It defines them as Web-Objects
 * includes standard styles and help, and also does the development check.
 *
 * Author: Wm. T. Wood  Created: 4/22/97 
 * ------------------------------------------------------------------------
 */
&ENDIF

{ src/web/method/wrap-cgi.i }  /* Define this as a Web Object.            */
{ webutil/devcheck.i }         /* Don't allow tool to run in PRODUCTION   */

{ webutil/wstyle.i }           /*  Standard style definitions.            */ 
{ webtools/help.i  }           /*  Help file context definitions.         */

/* webtool.i - end of file */
