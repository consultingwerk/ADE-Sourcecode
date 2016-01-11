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
**          Program:  webmsg.p
**
**           Author: 
**
**      Description:  The purpose of this procedure file is to output 
**                    web application messages through the use of the
**                    !--WSMSG -- tag.  Messages are output via a call
**                    to the output-messages function defined in
**                    src/web/method/message.i.  However, the only 
**                    messages that are output are those that have
**                    been 'queued' up using the queue-messages function
**                    also defined in src/web/method/message.i.
**
**                    The tag attributes that are associated with
**                    !--WSMSG -- are ones that will store the necessary
**                    input parameters for the output-messages function. 
**
**                    The allowable attributes associated with the WSTAG
**                    include:  NAME and VALUE.  The NAME attribute
**                    stores the group with which the messages are to be
**                    output.  For example, the application may output
**                    "validation" messages.  Note that this group has to
**                    have been specified when the queue-messages function
**                    was called.  The possible NAME attribute values
**                    include:  "<group name>", "all", and "page".  The
**                    VALUE attribute stores the heading that is to be
**                    output prior to the messages that are output.  When
**                    NAME="all", all queued up messages are output,
**                    regardless of group type.  The contents of the VALUE
**                    attribute are output as a heading prior to the messages 
**                    (if NAME="all").  When NAME="page", all queued up messages
**                    (regardless of group type) are output in an HTML page.  
**                    The contents of the VALUE attribute are output as an HTML 
**                    title or as an H1 heading.  When NAME=<group name>, all 
**                    messages queued up for <group name> are output.  The
**                      contents of the VALUE attribute are output as a heading
**                      prior to the messages that output.
**
**                    The NAME and VALUE attributes, are not mandatory.  If
**                    a NAME attribute has not been specified then the value
**                    defaults to "all".  If the VALUE attribute has not been
**                    specified then the default heading is "Application
**                    Messages".
**
**                    * tagmap.dat entry for WSTAG
**                    !--WSTAG,,,fill-in,web/support/webmsg.p
**
**                    * example custom tag stored in 'fieldDef':
**                    <!--WSTAG NAME="all" VALUE="All Messages" -->
**
**                    *  parameters/tokens/attributes in the tag:  
**                    NAME, VALUE 
**
**                    Note that in order for the output-messages to be 
**                    run, WSMSG must be parsed for the token values,
**                    so that the appropriate input parameters can be
**                    passed to the output-messages function.  This is
**                    accomplished via web/support/tagparse.p
*****************************************************************************
\***************************************************************************/ 

{src/web/method/cgidefs.i}

&SCOPED-DEFINE NEWLINE CHR(10)
&SCOPED-DEFINE TAB CHR(9)

PROCEDURE web.output:
  DEFINE INPUT PARAMETER hWid              AS HANDLE                    NO-UNDO.
  DEFINE INPUT PARAMETER fieldDef          AS CHARACTER                 NO-UNDO.

  DEFINE VARIABLE        WSMSGParameters   AS CHARACTER                 NO-UNDO.
  DEFINE VARIABLE        groupType         AS CHARACTER INITIAL ?       NO-UNDO.
  DEFINE VARIABLE        groupValue        AS CHARACTER INITIAL ?       NO-UNDO.
  DEFINE VARIABLE        nameValue         AS CHARACTER INITIAL ?       NO-UNDO.
  DEFINE VARIABLE        titleValue        AS CHARACTER INITIAL ?       NO-UNDO.
  DEFINE VARIABLE        i                 AS INTEGER   INITIAL 0       NO-UNDO.
  DEFINE VARIABLE        paramName         AS CHARACTER INITIAL ""      NO-UNDO.
  DEFINE VARIABLE        paramValue        AS CHARACTER INITIAL ""      NO-UNDO.
  DEFINE VARIABLE        msgCount          AS INTEGER   INITIAL 0       NO-UNDO.
  

  ASSIGN WSMSGParameters = "name,value".
  
  /* Run tagparse.p to retrieve each of WSTAG's token values */ 
  DO i = 1 TO NUM-ENTRIES(WSMSGParameters):
    paramName = ENTRY(i, WSMSGParameters).
    RUN web/support/tagparse.p (INPUT fieldDef, INPUT paramName, 
                                OUTPUT paramValue).

    CASE paramName:
      WHEN "name" THEN
        nameValue = paramValue.
      WHEN "value" THEN 
      DO:
        titleValue = paramValue.
        IF titleValue = "" THEN titleValue = ?.
      END.
    END CASE.
  END.

  CASE nameValue:
    WHEN "page" THEN 
      ASSIGN
        groupType = "page"
        groupValue = ?.
    WHEN "all" THEN      
      ASSIGN
        groupType = "all"
        groupValue = ?.
    WHEN ? THEN
      ASSIGN
        groupType = "all"
        groupValue = ?.
    WHEN "" THEN
      ASSIGN
        groupType = "all"
        groupValue = ?.
    OTHERWISE
      ASSIGN
        groupValue = groupType
        groupType = "group".
  END CASE.
 
  output-messages(groupType, groupValue, titleValue).
   
END PROCEDURE. /* web.output*/
