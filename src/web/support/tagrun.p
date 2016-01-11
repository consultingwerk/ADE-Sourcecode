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
/***************************************************************************\
*****************************************************************************
**          Program:  tagrun.p
**
**           Author: 
**
**      Description:  The purpose of this procedure is to run a file
**                    that generates an HTML Table. 
**
**                    The file that gets run is based on the FILE 
**                    in WSTAG.  The FILE token can be set to a 
**                    a file name that is run to generate
**                    an HTML table; or it can be set to "screenvalue".
**                    By setting it to "screenvalue", tagrun.p takes
**                    the SCREEN-VALUE of the WebSpeed/Progress fill-in 
**                    field that has been associated with !--WSTAG.
**
**                    * tagmap.dat entry for WSTAG
**                    !--WSTAG,,,fill-in,web/support/tagrun.p
**
**                    * example custom tag stored in 'fieldDef':
**                    <!--WSTAG NAME=CustTbl FILE=custtbl.p-->
**
**                    *  parameters/tokens in the tag:  
**                    NAME, TYPE, FILE
**
**                    Note that in order for the HTML Table generating
**                    file to be run, WSTAG must be parsed for the
**                    FILE token value.  This is accomplished via
**                    web/support/tagparse.p.
*****************************************************************************
\***************************************************************************/ 


{src/web/method/cgidefs.i}

&SCOPED-DEFINE NEWLINE CHR(10)
&SCOPED-DEFINE TAB CHR(9)


PROCEDURE web.output:
  DEFINE INPUT PARAMETER hWid              AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER fieldDef          AS CHARACTER NO-UNDO.

  DEFINE VARIABLE        WSTagParameters   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE        nameValue         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE        fileValue         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE        typeValue         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE        cFile             AS CHARACTER NO-UNDO.
  DEFINE VARIABLE        i                 AS INTEGER   NO-UNDO.
  DEFINE VARIABLE        paramName         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE        paramValue        AS CHARACTER NO-UNDO.
     
  
  ASSIGN WSTagParameters = "name,type,file".
  
  /* Run tagparse.p to retrieve each of WSTAG's token values */ 
  DO i = 1 TO NUM-ENTRIES(WSTagParameters):
    paramName = ENTRY(i, WSTagParameters).
    RUN web/support/tagparse.p (INPUT fieldDef, INPUT paramName, 
                                OUTPUT paramValue).
    
    CASE paramName:
      WHEN "name" THEN
        nameValue = paramValue.
      WHEN "type" THEN
        typeValue = paramValue.
      WHEN "file" THEN
        fileValue = paramValue.
    END CASE.
  END.


  /* Determine what html generating procedure to run */
  CASE fileValue:
    WHEN "screenvalue" THEN
    DO:
      RUN adecomm/_rsearch (INPUT hWid:SCREEN-VALUE, OUTPUT cFile).
      IF (cFile = ?) THEN
        RUN htmlError ('File not found:' + cFile).
      ELSE
        RUN VALUE(cFile) NO-ERROR.
    END.
    WHEN "" THEN
      LEAVE.
    WHEN ? THEN
      RUN htmlError ('File name not specified').
    OTHERWISE
    DO:
      RUN adecomm/_rsearch(INPUT fileValue, OUTPUT cFile).
      IF (cFile = ?) THEN
        RUN htmlError ('File not found:' + cFile).
      ELSE
        RUN VALUE(cFile) NO-ERROR.
    END. 
  END CASE.
END PROCEDURE. /* web.output*/
