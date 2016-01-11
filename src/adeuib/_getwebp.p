&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
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
/*------------------------------------------------------------------------
    File        : _getwebp.p 
    Purpose     : Read web related preferences

    Syntax      : run adeuib/_getwebp.p('AB').

    Description : This code is copyed from _getpref.p  

    Author(s)   : Haavard Danielsen
    Created     : May 98
    Notes       : This is separated from _getpref.p because it also is needed 
                  outside the Appbuilder to run WebTools. 
                 (In that case the sharvars.i variables is defined NEW in the 
                  caller)    
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

{adeuib/sharvars.i}
DEFINE INPUT PARAMETER pSection AS CHAR NO-UNDO.

DEFINE VARIABLE EnvValue AS CHAR NO-UNDO.
DEFINE VARIABLE KeyValue AS CHAR NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure

/* _UIB-PREPROCESSOR-BLOCK-END */
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
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 

/* ***************************  Main Block  *************************** */

/* Open new browser session for every Web object RUN.  Default to Yes on
   initial AppBuilder startup. */
GET-KEY-VALUE SECTION pSection KEY "OpenNewBrowser" VALUE KeyValue.
  _open_new_browse = (KeyValue EQ ?) OR NOT CAN-DO("false,no,off",KeyValue).

/* Open/Save/Compiles remotely by default for users who have Enterprise
   and WebSpeed licensed. */
GET-KEY-VALUE SECTION pSection KEY "RemoteFileManagement" VALUE KeyValue.
  _remote_file = NOT ((KeyValue EQ ?) OR CAN-DO ("false,no,off",KeyValue)).

/* Get path to default Web browser. */
GET-KEY-VALUE SECTION pSection KEY "WebBrowser":U VALUE KeyValue.
IF (KeyValue EQ ?) THEN DO:
  LOAD "http\shell\open":U BASE-KEY "HKEY_CLASSES_ROOT":U NO-ERROR.
  IF NOT ERROR-STATUS:ERROR THEN DO:
    USE "http\shell\open":U NO-ERROR.
    GET-KEY-VALUE SECTION "command":U KEY DEFAULT VALUE KeyValue.
    IF KeyValue NE ? THEN
      _WebBrowser = REPLACE(SUBSTRING(KeyValue, 1, R-INDEX(KeyValue,".EXE":U) + 3,
                                      "CHARACTER":U),'"':U,"").
    USE "" NO-ERROR. /* Go back to using startup defaults file */
  END.
END.  /* IF KeyValue EQ ? */
ELSE 
  _WebBrowser = KeyValue.

/* Get name of local host machine. */
GET-KEY-VALUE SECTION pSection KEY "LocalHost":U VALUE KeyValue.
IF (KeyValue EQ ?) THEN DO:
  LOAD "SYSTEM\CurrentControlSet\Control\ComputerName":U 
    BASE-KEY "HKEY_LOCAL_MACHINE":U NO-ERROR.
  IF NOT ERROR-STATUS:ERROR THEN DO:
    USE "SYSTEM\CurrentControlSet\Control\ComputerName":U NO-ERROR.
    GET-KEY-VALUE SECTION "ComputerName":U KEY "ComputerName" VALUE KeyValue.
    IF KeyValue NE ? THEN
      _LocalHost = KeyValue.
    USE "" NO-ERROR. /* Go back to using startup defaults file */
  END.
END.  /* IF KeyValue EQ ? */
ELSE 
  _LocalHost = KeyValue.

/* Default Web Broker URL */
GET-KEY-VALUE SECTION pSection KEY "WebBroker":U VALUE KeyValue.
_BrokerURL = (IF KeyValue NE ? THEN KeyValue ELSE 
              "http://localhost/scripts/cgiip.exe/WService=wsbroker1":U).

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


