&ANALYZE-SUSPEND _VERSION-NUMBER WDT_v2r1 Method-Library
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _CUSTOM Definitions 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*--------------------------------------------------------------------------
    Library     : message.i
    Purpose     : Utilities for message queuing and output
    Syntax      : { src/web/method/message.i }
    Updated     : 01/14/97 billb@progress.com
                    Initial version
                  01/23/02 adams@progress.com
                    Modified seq-grp index, added grp-seq index
    Notes       : cgidefs.i must be included before this file.
    
    	    	  This file is for internal use by WebSpeed runtime
		  procedures ONLY. Applications should not include this file.

  ------------------------------------------------------------------------*/
/*           This .i file was created with WebSpeed WorkShop.             */
/*------------------------------------------------------------------------*/

/* Only define things if this file has not yet been included */
&IF DEFINED(MESSAGE_I) = 0 &THEN
&GLOBAL-DEFINE MESSAGE_I = TRUE

/* ***************************  Definitions  ************************** */

/* Variables used only by message.i */

/* Output message sequence to preserve order of each message group. */
DEFINE VARIABLE msg-seq AS INTEGER NO-UNDO.

/* Output message work table */
DEFINE TEMP-TABLE ttMessage NO-UNDO
  FIELD seq AS  INTEGER
  FIELD grp AS  CHARACTER
  FIELD msg AS  CHARACTER
  INDEX grp-seq IS PRIMARY grp seq
  INDEX seq-grp seq grp.
  
&ANALYZE-RESUME
/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _INCLUDED-LIBRARIES
/* ************************* Included-Libraries *********************** */
&ANALYZE-RESUME _END-INCLUDED-LIBRARIES

/* ***************************  Functions  **************************** */

&IF DEFINED(EXCLUDE-available-messages) = 0 &THEN

&ANALYZE-SUSPEND _CODE-BLOCK _FUNCTION available-messages 
/****************************************************************************
Function: available-messages
Description: Returns TRUE if there are any messages queued for the
  specified group or any group if the specified group is ?.
Input Parameters: Message group or ? for messages in any group
Returns: TRUE if there are one or more messages queued, otherwise FALSE.
****************************************************************************/
FUNCTION available-messages RETURNS LOGICAL
  (INPUT p_grp AS CHARACTER) :

  DEFINE VARIABLE v-status AS LOGICAL NO-UNDO.

  FOR FIRST ttMessage WHERE
    (IF p_grp = ? THEN TRUE       /* match any group */
     ELSE ttMessage.grp = p_grp): /* else, match specified group */
    ASSIGN v-status = TRUE.
  END.

  RETURN v-status.
END FUNCTION. /* available-messages */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-get-message-groups) = 0 &THEN

&ANALYZE-SUSPEND _CODE-BLOCK _FUNCTION get-message-groups 
/****************************************************************************
Function: get-message-groups
Description: Returns a list of groups for which there are queued messages.
Input Parameters: None
Returns: Comma-delimited list of message groups.
****************************************************************************/
FUNCTION get-message-groups RETURNS CHARACTER :

  DEFINE VARIABLE v-out AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE v-cnt AS INTEGER     NO-UNDO.

  FOR EACH ttMessage
    BREAK BY ttMessage.grp:
    /* At the start of each group, save the group name */
    IF FIRST-OF(ttMessage.grp) THEN
      ASSIGN
        v-cnt = v-cnt + 1
        v-out = v-out +
    	  /* add delimiter after the first group */
      	  (IF v-cnt = 1 THEN "" ELSE ",":U) +
          ttMessage.grp.
  END.

  RETURN v-out.
END FUNCTION. /* get-message-groups */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-get-messages) = 0 &THEN

&ANALYZE-SUSPEND _CODE-BLOCK _FUNCTION get-messages 
/****************************************************************************
Function: get-messages
Description: Returns any messages queued for the specified group or any
  group if the specified group is ?.
Input Parameters: Message group or ? for messages in all groups, logical
  indicating if messages should be deleted from the queue.
Returns: List of messages delimited by the newline character "~n".
****************************************************************************/
FUNCTION get-messages RETURNS CHARACTER
  (INPUT p_grp AS CHARACTER,
   INPUT p_delete AS LOGICAL) :

  DEFINE VARIABLE v-out    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE v-mdelim AS CHARACTER  NO-UNDO INITIAL "~n":U.
  DEFINE VARIABLE v-gdelim AS CHARACTER  NO-UNDO INITIAL "~t":U.

  IF p_delete = ? THEN p_delete = TRUE.

  FOR EACH ttMessage WHERE
    (IF p_grp = ? THEN TRUE	   /* match any group */
     ELSE ttMessage.grp = p_grp)   /* else, match specified group */
    BY ttMessage.seq BY ttMessage.grp:
    ASSIGN
      v-out = v-out +
      	(IF v-out = "" THEN "" ELSE v-mdelim) + /* message delimiter */
	ttMessage.msg.
    IF p_delete THEN
      DELETE ttMessage.
  END.

  RETURN v-out.
END FUNCTION. /* get-messages */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-queue-message) = 0 &THEN

&ANALYZE-SUSPEND _CODE-BLOCK _FUNCTION queue-message 
/****************************************************************************
Function: queue-message
Description: Queues a message for later output by output-messages(). If the
  message text has the possiblility of containing the characters "<", ">",
  or "&", then the html-encode() function should be used on the message text
  to escape or encode these characters.  i.e.
    queue-message("runtime", html-encode(ERROR-STATUS:GET-MESSAGE(1))).
Input Parameters: Message group or "", message string
Returns: Message number in queue.
****************************************************************************/
FUNCTION queue-message RETURNS INTEGER
  (INPUT p_grp AS CHARACTER,
   INPUT p_message AS CHARACTER) :

  CREATE ttMessage.
  ASSIGN
    /* Replace tab and newline characters with a space to prevent problems
       with an application parsing the output of get-messages(). */
    p_message     = REPLACE(p_message, "~n":U, " ":U)
    msg-seq       = msg-seq + 1  /* increment global sequence counter */
    ttMessage.seq = msg-seq
    ttMessage.grp = (IF p_grp = ? THEN "" ELSE p_grp)
    ttMessage.msg = (IF p_message = ? THEN "" ELSE p_message).
  RETURN msg-seq.
END FUNCTION. /* queue-message */
&ANALYZE-RESUME

&ENDIF

&ANALYZE-SUSPEND _CODE-BLOCK _CUSTOM "Main Code Block" 


/* ***************************  Main Block  *************************** */
&ANALYZE-RESUME
/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-output-messages) = 0 &THEN

&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE output-messages 
/***
THIS IS TEMPORARY UNTIL WE CAN VERIFY THE PROCEDURE SEGMENT WON'T BLOW DUE
TO ADDING THIS LARGE FUNCTION OR OTHER FUNCTIONS. [billb]
***/
&SCOPED-DEFINE OM-FUNCTION TRUE
&IF DEFINED(OM-FUNCTION) = 0 &THEN
PROCEDURE output-messages :
/****************************************************************************
Procedure: output-messages
Description: Outputs messages queued by queue-message.  If there are no 
  messages to output, then no HTML is generated.
Parameters:
  * Input option is one of "page", "all" or "group".
    - If "page" is specified, an entire HTML page is output with all queued
      messages.
    - The "all" option is like "page" but no HTML title and H1 are output.
      This option is suitable for dumping all messages out from an
      application.
    - The "group" option allows outputting just the messages in a specified
      group as specified with queue-message.
  * Input message group specified which group of messages to output.  If
    ? is specified, all messages are output.
  * Input message text.  With the "page" option, this text is displayed
    in the HTML title and H1 sections.  With the "all" option, or "group"
    option, the text is displayed before the messages are output as a heading.
  * Return value is the number of messages output.

Note:  If the Content-Type header has not been output (via the function
output-content-type), then "page" mode will override any other mode specified.
Examples:
  * All messages the the group "validation" with the heading text
    queue-message ("validation",
    	    	   "When country is 'USA', zip-code must be numeric").
    ... 
    output-messages ("group","validation","Data Validation Errors").
  * All queued messages.  Don't output a heading.
    output-messages ("all",?,?).
  * All queued messages on a self-contained page with HTML HEAD and BODY.  
    output-messages ("page",?,"Application Error Messages").
****************************************************************************/
  DEFINE INPUT PARAMETER p_option   AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER p_grp 	    AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER p_message  AS CHARACTER  NO-UNDO.
&ELSE
FUNCTION output-messages RETURNS INTEGER
  (INPUT p_option AS CHARACTER,
   INPUT p_grp AS CHARACTER,
   INPUT p_message AS CHARACTER) :
&ENDIF

  DEFINE VARIABLE message-title     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE message-heading   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE msg-list  	    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE msg-out    	    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE msg-cnt   	    AS INTEGER    NO-UNDO.
  DEFINE VARIABLE msg-return-cnt    AS INTEGER    NO-UNDO.

  /*
  ** If we're generating an entire HTML page ...
  */
  IF p_option = "page":U THEN DO:

    /* Output HTML header */
    output-content-type(INPUT "text/html":U).
    /* If something was specified in the message argument, use that for
       the HTML title and H1 tags.  Otherwise, use a generic message. */
    ASSIGN message-title =
      (IF p_message = "" OR p_message = ? THEN "Application Messages"
       ELSE p_message).
    {&OUT}
    "<HTML>~n":U
    "<HEAD><TITLE>":U message-title "</TITLE></HEAD>~n":U
    "<BODY>~n":U
    "<H1>":U message-title "</H1>~n~n":U
    .

    /* Output messages by running ourself with the "all" option */
    &IF DEFINED(OM-FUNCTION) = 0 &THEN
    RUN output-messages (INPUT "all":U, INPUT ?, INPUT p_message).
    ASSIGN msg-return-cnt = INTEGER(RETURN-VALUE).  /* # of messages output */
    &ELSE
    ASSIGN msg-return-cnt = output-messages("all":U, ?, "").
    &ENDIF

    /* Output HTML footer */
    {&OUT}
    (IF HelpAddress <> "" THEN
      "<P>":U + "In the event of a problem with this application, please " +
      "contact " + HelpAddress + "</P>~n":U ELSE "")
    "</BODY>~n":U
    "</HTML>~n":U
    .

    RETURN msg-return-cnt.
  END. /* p_option = "page" */
    
  /* Any option other than "page" */
  ELSE DO:
    /* If nothing has been output yet, run ourself with the "page" option
       to get the HTML header also. */
    IF output-content-type = "" THEN DO:
      &IF DEFINED(OM-FUNCTION) = 0 &THEN
      RUN output-messages IN THIS-PROCEDURE (INPUT "page":U,
                                            INPUT ?, INPUT p_message).
      RETURN RETURN-VALUE.  /* return number of messages output */
      &ELSE
      RETURN output-messages("page":U, ?, p_message).
      &ENDIF
    END.
  END.

  /*
  ** Output all messages
  */
  IF p_option = "all":U THEN DO:
    ASSIGN
      p_option = "group":U
      p_grp    = ?
      msg-seq  = 0.  /* reset global message counter */
    /* Fall through to "group" handling */
  END.

  /*
  ** Output all messages in a specific group or all groups if the specified
  ** group is ?
  */
  IF p_option = "group":U THEN DO:
    /* If something was specified in the message argument, use that for
       the message group heading.  Otherwise, use a generic message. */
    ASSIGN 
      message-heading =
      (IF p_message = ? THEN "Messages of type " +
        p_grp + ":":U ELSE p_message)
      msg-list        = get-messages(p_grp, TRUE). /* get messages deleting them */

    /* Output all messages returned */
    DO msg-cnt = 1 TO NUM-ENTRIES(msg-list, "~n":U):
      /* Get message from list */
      ASSIGN msg-out = ENTRY(msg-cnt, msg-list, "~n":U).
      /* Before the first message line, start an HTML un-ordered list and 
         output the message group heading. */
      IF msg-cnt = 1 THEN
        {&OUT} "<UL>":U p_message "<BR>~n":U {&END}

      /* Output the message as a HTML list item */
      {&OUT} "  <LI>":U msg-out "~n":U {&END}
    END.
    /* If no messages, reset counter so it will be correct for RETURN. */
    IF msg-list = "" THEN
      ASSIGN msg-cnt = 0.

    /* If any messages were output, end un-ordered list */
    IF msg-cnt > 0 THEN
      {&OUT} "</UL>~n":U {&END}

  END.  /* p_option = "group" */

&IF DEFINED(OM-FUNCTION) = 0 &THEN
  RETURN STRING(msg-cnt).  /* return number of messages output */
END PROCEDURE. /* output-messages */
&ELSE
  RETURN msg-cnt.
END FUNCTION. /* output-messages */
&ENDIF

&ENDIF  /* DEFINED(MESSAGE_I) = 0 */

&ANALYZE-RESUME

&ENDIF
