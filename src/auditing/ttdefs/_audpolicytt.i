/*************************************************************/
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
DEFINE TEMP-TABLE ttAuditPolicy NO-UNDO BEFORE-TABLE ttAuditPolicyBefore
    FIELD _Audit-policy-guid            AS CHARACTER FORMAT "X(28)"  LABEL 'Policy GUID'
    FIELD _Audit-policy-name            AS CHARACTER FORMAT "X(35)"  LABEL 'Audit policy name'
    FIELD _Audit-policy-description     AS CHARACTER FORMAT "X(70)"  LABEL 'Audit policy description'
    FIELD _Audit-data-security-level    AS INTEGER   FORMAT "->9"    LABEL 'Data security level'
    FIELD _Audit-custom-detail-level    AS INTEGER   FORMAT "->9"    LABEL 'Audit custom detail level'
    FIELD _Audit-policy-active          AS LOGICAL   FORMAT "YES/NO" LABEL 'Audit policy active' INITIAL 'NO'
    FIELD _imported                     AS LOGICAL   INITIAL NO
    INDEX idxPolicyGuid AS PRIMARY UNIQUE
      _Audit-policy-guid
    INDEX idxPolicyName AS UNIQUE
     _Audit-policy-name
    INDEX idxPolicyActive
      _Audit-policy-active
    INDEX idxPolicyDesc
     _Audit-policy-description
    .
