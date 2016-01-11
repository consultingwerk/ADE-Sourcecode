/*************************************************************/
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
  FIELD _Audit-policy-guid LIKE ttAuditEventPolicy._Audit-policy-guid~
  FIELD _Event-id LIKE ttAuditEventPolicy._Event-id~
  FIELD _Event-name LIKE ttAuditEventPolicy._Event-name~
  FIELD _Event-type LIKE ttAuditEventPolicy._Event-type~
  FIELD _Event-level LIKE ttAuditEventPolicy._Event-level~
  FIELD _Event-criteria LIKE ttAuditEventPolicy._Event-criteria~
  FIELD EventLevelDesc AS CHARACTER FORMAT "x(8)" LABEL "Event Level"~
  FIELD EventCriteriaDesc AS CHARACTER FORMAT "x(3)" LABEL "Criteria"~
  FIELD _Event-description LIKE ttAuditEventPolicy._Event-description
