/*************************************************************/
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
  FIELD _Audit-policy-guid LIKE ttAuditFieldPolicy._Audit-policy-guid~
  FIELD _File-name LIKE ttAuditFieldPolicy._File-name LABEL "Table name" COLUMN-LABEL "Table name"~
  FIELD _Owner LIKE ttAuditFieldPolicy._Owner~
  FIELD _Field-name LIKE ttAuditFieldPolicy._Field-name~
  FIELD _Audit-create-level LIKE ttAuditFieldPolicy._Audit-create-level~
  FIELD _Audit-update-level LIKE ttAuditFieldPolicy._Audit-update-level~
  FIELD _Audit-read-level LIKE ttAuditFieldPolicy._Audit-read-level~
  FIELD _Audit-delete-level LIKE ttAuditFieldPolicy._Audit-delete-level~
  FIELD _Audit-identifying-field LIKE ttAuditFieldPolicy._Audit-identifying-field LABEL "Identifying" COLUMN-LABEL "Identifying"~
  FIELD CreateLevelDesc AS CHARACTER FORMAT "x(20)" LABEL "Create"~
  FIELD UpdateLevelDesc AS CHARACTER FORMAT "x(20)" LABEL "Update"~
  FIELD DeleteLevelDesc AS CHARACTER FORMAT "x(20)" LABEL "Delete"~
  FIELD ReadLevelDesc AS CHARACTER FORMAT "x(9)" LABEL "Read"
