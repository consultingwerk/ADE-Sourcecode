/*************************************************************/
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
DEFINE TEMP-TABLE ttAuditEvent NO-UNDO BEFORE-TABLE ttAuditEventBefore
    FIELD _Event-id                     AS INTEGER   FORMAT "->>>>>9" LABEL 'Event id'
    FIELD _Event-type                   AS CHARACTER FORMAT "X(15)"   LABEL 'Event type'
    FIELD _Event-name                   AS CHARACTER FORMAT "X(35)"   LABEL 'Event name'
    FIELD _Event-description            AS CHARACTER FORMAT "X(500)"  LABEL 'Event description'
    INDEX idxEventId AS PRIMARY UNIQUE
      _Event-id
    INDEX idxEventName
      _Event-type _Event-name
    INDEX idxEventDesc
      _Event-description
    .
