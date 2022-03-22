&ANALYZE-SUSPEND _VERSION-NUMBER WDT_v2r1 Method-Library
/* Procedure Description
"Standard include file for HTML Generating procedures. 
This file is included in every wrap-cgi.w."
*/
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _CUSTOM Definitions 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*--------------------------------------------------------------------------
    Library     : web/method/wrap-cgi.i
    Purpose     : Standard include file for HTML Generating objects. 
                  This file is included in every web/template/wrap-cgi.w

    Syntax      :

    Description :

    Author(s)   : Wm. T. Wood
    Created     : May 19, 1996
    Notes       :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
&ANALYZE-RESUME
/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _INCLUDED-LIBRARIES
/* Included Libraries -- */

{src/web/method/cgidefs.i}
{src/web/method/admweb.i}
&ANALYZE-RESUME _END-INCLUDED-LIBRARIES

&ANALYZE-SUSPEND _CODE-BLOCK _CUSTOM "Main Code Block" 


/* ***************************  Main Block  *************************** */
&ANALYZE-RESUME
 

