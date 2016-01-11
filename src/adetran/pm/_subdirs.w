&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r2 GUI
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
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
/*--------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

  DEFINE INPUT  PARAMETER start-dir AS CHARACTER                       NO-UNDO.
  DEFINE OUTPUT PARAMETER children  AS CHARACTER                       NO-UNDO.
  DEFINE VARIABLE FileStream        AS CHARACTER                       NO-UNDO.
  DEFINE VARIABLE TheseChildren     AS CHARACTER                       NO-UNDO.
  DEFINE VARIABLE TestDir           AS CHARACTER                       NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 2
         WIDTH              = 40.
                                                                        */
&ANALYZE-RESUME
 



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */


/* Initialize children to blank */
children = "":U.

INPUT FROM OS-DIR(start-dir) ECHO.
REPEAT:
  IMPORT FileStream.
  /* We only want subdirs, so skip the cwd and its parent. */
     if FileStream begins ".":u then next.
          
  ASSIGN FILE-INFO:FILE-NAME = start-dir + "\" + FileStream.
  IF FILE-INFO:FILE-TYPE BEGINS "D":U THEN DO:
    ASSIGN TestDir = start-dir + "\" + FileStream.
    RUN adetran/pm/_subdirs.w (INPUT TestDir, OUTPUT TheseChildren).
    children = (IF children <> "":U THEN children + ",":U ELSE "":U) +
                TheseChildren.  /* TheseChildren contains TestDir at
                                   a minimum */

  END.  /* If a directory */
END.  /* Repeat */
  
INPUT CLOSE.
/* Now add the start-dir to the children */
children = start-dir + (IF children <> "":U THEN ",":U + children ELSE "":U).

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


