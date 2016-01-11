/*************************************************************/
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
  FIELD _Audit-policy-guid LIKE ttAuditFilePolicy._Audit-policy-guid~
  FIELD _File-name LIKE ttAuditFilePolicy._File-name LABEL "Table name" COLUMN-LABEL "Table name"~
  FIELD _Owner LIKE ttAuditFilePolicy._Owner~
  FIELD _Audit-create-level LIKE ttAuditFilePolicy._Audit-create-level~
  FIELD _Create-event-id LIKE ttAuditFilePolicy._Create-event-id~
  FIELD _Audit-create-criteria LIKE ttAuditFilePolicy._Audit-create-criteria~
  FIELD _Audit-update-level LIKE ttAuditFilePolicy._Audit-update-level~
  FIELD _Update-event-id LIKE ttAuditFilePolicy._Update-event-id~
  FIELD _Audit-update-criteria LIKE ttAuditFilePolicy._Audit-update-criteria~
  FIELD _Audit-delete-level LIKE ttAuditFilePolicy._Audit-delete-level~
  FIELD _Delete-event-id LIKE ttAuditFilePolicy._Delete-event-id~
  FIELD _Audit-delete-criteria LIKE ttAuditFilePolicy._Audit-delete-criteria~
  FIELD _Audit-read-level LIKE ttAuditFilePolicy._Audit-read-level~
  FIELD _Audit-read-criteria LIKE ttAuditFilePolicy._Audit-read-criteria~
  FIELD CreateLevelDesc AS CHARACTER FORMAT "x(20)" LABEL "Create"~
  FIELD UpdateLevelDesc AS CHARACTER FORMAT "x(20)" LABEL "Update"~
  FIELD DeleteLevelDesc AS CHARACTER FORMAT "x(20)" LABEL "Delete"~
  FIELD ReadLevelDesc AS CHARACTER FORMAT "x(8)" LABEL "Read"
