/*************************************************************/
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
DEFINE TEMP-TABLE ttAuditFieldPolicy NO-UNDO BEFORE-TABLE ttAuditFieldPolicyBefore
    FIELD _Audit-policy-guid            AS CHARACTER FORMAT "X(28)"   LABEL 'Policy GUID'
    FIELD _File-name                    AS CHARACTER FORMAT "X(32)"   LABEL 'File name'
    FIELD _Owner                        AS CHARACTER FORMAT "X(32)"   LABEL 'SQL Owner'
    FIELD _Field-name                   AS CHARACTER FORMAT "X(32)"   LABEL 'Field name'
    FIELD _Audit-create-level           AS INTEGER   FORMAT "->9"     LABEL 'Audit create level'
    FIELD _Audit-update-level           AS INTEGER   FORMAT "->9"     LABEL 'Audit update level'
    FIELD _Audit-delete-level           AS INTEGER   FORMAT "->9"     LABEL 'Audit delete level'
    FIELD _Audit-read-level             AS INTEGER   FORMAT "->9"     LABEL 'Audit read level'
    FIELD _Audit-identifying-field      AS INTEGER   FORMAT "->9"     LABEL 'Audit identifying field'
    INDEX idxGuidFileOwner AS PRIMARY UNIQUE
      _Audit-policy-guid _File-Name _Owner _Field-Name
    INDEX idxFileOwner
      _File-Name _Field-Name _Owner
    .
