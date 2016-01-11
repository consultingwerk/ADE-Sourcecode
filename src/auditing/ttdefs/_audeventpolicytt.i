/*************************************************************/
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
DEFINE TEMP-TABLE ttAuditEventPolicy NO-UNDO  BEFORE-TABLE ttAuditEventPolicyBefore 
    FIELD _Audit-policy-guid            AS CHARACTER FORMAT "X(28)"   LABEL 'Policy GUID'
    FIELD _Event-id                     AS INTEGER   FORMAT "->>>>>9" LABEL 'Event id'
    FIELD _Event-type                   AS CHARACTER FORMAT "X(15)"   LABEL 'Event type'
    FIELD _Event-name                   AS CHARACTER FORMAT "X(35)"   LABEL 'Event name'
    FIELD _Event-description            AS CHARACTER FORMAT "X(50)"   LABEL 'Event description'
    FIELD _Event-level                  AS INTEGER   FORMAT "->9"     LABEL 'Event level'
    FIELD _Event-criteria               AS CHARACTER FORMAT "X(3000)" LABEL 'Event criteria'
    INDEX idxEventGuid AS PRIMARY UNIQUE
      _Audit-policy-guid _Event-id
    INDEX idxEventId
      _Event-id
    .
