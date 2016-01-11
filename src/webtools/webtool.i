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
