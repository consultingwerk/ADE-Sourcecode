/*************************************************************/
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
DEFINE TEMP-TABLE ttAuditFilePolicy NO-UNDO BEFORE-TABLE ttAuditFilePolicyBefore
    FIELD _Audit-policy-guid            AS CHARACTER FORMAT "X(28)"   LABEL 'Policy GUID'
    FIELD _File-name                    AS CHARACTER FORMAT "X(32)"   LABEL 'File name'
    FIELD _Owner                        AS CHARACTER FORMAT "X(32)"   LABEL 'SQL Owner'
    FIELD _Audit-create-level           AS INTEGER   FORMAT "->9"     LABEL 'Audit create level'
    FIELD _Create-event-id              AS INTEGER   FORMAT "->>>>>9" LABEL 'Create event id'
    FIELD _Audit-create-criteria        AS CHARACTER FORMAT "X(3000)" LABEL 'Audit create criteria'
    FIELD _Audit-update-level           AS INTEGER   FORMAT "->9"     LABEL 'Audit update level'
    FIELD _Update-event-id              AS INTEGER   FORMAT "->>>>>9" LABEL 'Update event id'
    FIELD _Audit-update-criteria        AS CHARACTER FORMAT "X(3000)" LABEL 'Audit update criteria'
    FIELD _Audit-delete-level           AS INTEGER   FORMAT "->9"     LABEL 'Audit delete level'
    FIELD _Delete-event-id              AS INTEGER   FORMAT "->>>>>9" LABEL 'Delete event id'
    FIELD _Audit-delete-criteria        AS CHARACTER FORMAT "X(3000)" LABEL 'Audit delete criteria'
    FIELD _Audit-read-level             AS INTEGER   FORMAT "->9"     LABEL 'Audit read level'
    FIELD _Read-event-id                AS INTEGER   FORMAT "->>>>>9" LABEL 'Read event id' INIT 5103
    FIELD _Audit-read-criteria          AS CHARACTER FORMAT "X(3000)" LABEL 'Audit read criteria'
    INDEX idxGuidFileOwner AS PRIMARY UNIQUE
      _Audit-policy-guid _File-Name _Owner
    INDEX idxFileOwner
      _File-Name _Owner
    .
