&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*************************************************************/
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/

/*------------------------------------------------------------------------

File        : prodict/sec/sec-func.i
Purpose     : Definitions of common routines, used specifically in
              the security section of the Data Administration Tool

Syntax      :

Description :

Author(s)   : Kenneth S. McIntosh
Created     : April 4, 2005

History     : 
  kmcintos  May 24, 2005 Added sanity checks in canGrant 20050523-033.
  kmcintos  May 27, 2005 Moved hasChildren back to _sec-perm.p 20050526-026.
  kmcintos June 17, 2005 Made security API more generic 20050617-003.
  kmcintos June 17, 2005 Tweaked permissions API to allow DBAs to be 
                         Audit Administrators when there aren't any 
                         20050606-003.  
  kmcintos June 17, 2005 Refined canChange/canRevoke logic 20050615-024.
  kmcintos June 21, 2005 Refined canGrant logic to ignore dba in some
                         cases 20050621-011.
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD canChange Include 
FUNCTION canChange RETURNS LOGICAL
  ( INPUT pcPerm           AS CHARACTER,
    INPUT pcGrantee        AS CHARACTER,
    INPUT pcGrantor        AS CHARACTER,
    INPUT pcUser           AS CHARACTER,
    INPUT pcMode           AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD canGrant Include 
FUNCTION canGrant RETURNS LOGICAL
  ( INPUT pcRole           AS CHARACTER,
    INPUT pcPermissionList AS CHARACTER,
    INPUT pcMode           AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD canRevoke Include 
FUNCTION canRevoke RETURNS LOGICAL
  ( INPUT pcRole    AS CHARACTER,
    INPUT pcGrantee AS CHARACTER,
    INPUT pcGrantor AS CHARACTER,
    INPUT pcUser    AS CHARACTER,
    INPUT pcMode    AS CHARACTER ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getPermissions Include 
FUNCTION getPermissions RETURNS CHARACTER
  ( INPUT pcUserID AS CHARACTER,
    INPUT pcMode   AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getRoleDesc Include 
FUNCTION getRoleDesc RETURNS CHARACTER
  ( INPUT pcRoleName AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD hasRole Include 
FUNCTION hasRole RETURNS LOGICAL
  ( INPUT pcUser    AS CHARACTER,
    INPUT pcRole    AS CHARACTER,
    INPUT plGranter AS LOGICAL ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD roleAvailable Include 
FUNCTION roleAvailable RETURNS LOGICAL
  ( INPUT pcRoleName AS CHARACTER ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD whoGranted Include 
FUNCTION whoGranted RETURNS CHARACTER
  ( INPUT pcRole    AS CHARACTER,
    INPUT pcGrantee AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Include
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Include ASSIGN
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION canChange Include 
FUNCTION canChange RETURNS LOGICAL
  ( INPUT pcPerm           AS CHARACTER,
    INPUT pcGrantee        AS CHARACTER,
    INPUT pcGrantor        AS CHARACTER,
    INPUT pcUser           AS CHARACTER,
    INPUT pcMode           AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Returns whether the specified user has rights to change a specific
           permission record.
Parameters: INPUT pcPerm           - Permission to change
            INPUT pcGrantee        - Grantee of the permission
            INPUT pcGrantor        - Grantor of the permission
            INPUT pcUser           - User attempting to change the permission
            INPUT pcMode           - Operating Mode
                                     "a" = Auditing
                                     no others implemented at this time
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lAudAdmin   AS LOGICAL     NO-UNDO.
  DEFINE VARIABLE lAdminRole  AS LOGICAL     NO-UNDO.
  DEFINE VARIABLE lDBA        AS LOGICAL     NO-UNDO.
  DEFINE VARIABLE lAdminAvail AS LOGICAL     NO-UNDO.

  DEFINE VARIABLE cPerms      AS CHARACTER   NO-UNDO.

  /* Get the user's current list permissions */
  cPerms = getPermissions(pcUser,pcMode).

  /* If this applies to Auditing permissions */
  IF pcMode = "a" THEN DO:
    ASSIGN lAudAdmin   = CAN-DO(cPerms,"_sys.audit.admin")
           lAdminRole  = INDEX(pcPerm,"audit.admin") > 0
           lDBA        = CAN-DO(cPerms,"dba")
           lAdminAvail = roleAvailable("_sys.audit.admin").

    /* If the user is an audit admin he has the ability to 
       change all audit related permissions, even audit admin. */
    IF lAudAdmin THEN DO:
      /* Audit admin can change any audit permission besides admin, so just
         return true if this is the case */
      IF NOT lAdminRole THEN
        RETURN TRUE.

      /* If this is an admin role and there is more than one audit administrator
         then an audit admin can change it */
      IF lAdminRole AND 
         lAdminAvail EQ ? THEN
        RETURN TRUE.
    END. /* If the user is an audit admin */

    /* If this is the last audit admin, and the user is a DBA */
    IF lAdminRole AND 
       lDBA       AND 
       (lAdminAvail = TRUE) THEN
      RETURN TRUE.

    /* If the user has grant-rights for the specified role and
       it's not an admin role and the user was the grantor */
    IF LOOKUP(pcPerm,cPerms) > 0                     AND
       ENTRY(LOOKUP(pcPerm,cPerms) + 1,cPerms) = "w" AND
       NOT lAdminRole                                AND
       (pcGrantor EQ pcUser) THEN
      RETURN TRUE.

    /* If there are no audit administrators and the user is a DBA */
    IF (lAdminAvail = FALSE) AND
       lDBA THEN
      RETURN TRUE.

  END. /* pcMode = "a" */
  ELSE
    /* We have no rules for non audit related permissions, at this point.
       This code will have to change when Security is introduced to the 
       product. */
    RETURN (CAN-DO(cPerms,"dba")).

  RETURN FALSE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION canGrant Include 
FUNCTION canGrant RETURNS LOGICAL
  ( INPUT pcRole           AS CHARACTER,
    INPUT pcPermissionList AS CHARACTER,
    INPUT pcMode           AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Returns whether the current permissions allow to grant a specified
           permission.
Parameters: INPUT pcRole           - Permission to grant
            INPUT pcPermissionList - List of permissions 
            IUNPUT pcMode          - Security Mode
                                     "a" = "Auditing"
                                     no others implemented
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lCanGrant   AS LOGICAL     NO-UNDO.
  DEFINE VARIABLE lAdminAvail AS LOGICAL     NO-UNDO.

  DEFINE VARIABLE hSecRole    AS HANDLE      NO-UNDO.

  /* If we're in auditing mode and this isn't an auditing permission
     then return false.  Or if we're not in auditing mode and it IS
     an auditing permission return false. */
  IF (pcMode = "a" AND
      INDEX(pcRole,".audit.") = 0) OR
     (pcMode NE "a" AND
      INDEX(pcRole,".audit.") NE 0) THEN
    lCanGrant = FALSE.

  IF pcRole NE "dba" THEN DO:
    CREATE BUFFER hSecRole FOR TABLE "DICTDB._sec-role".

    /* Check to see if this role even exists in the role table */
    hSecRole:FIND-FIRST("WHERE _role-name = ~"" + pcRole + "~"",NO-LOCK) NO-ERROR.
    IF NOT hSecRole:AVAILABLE THEN RETURN FALSE.
  END.

  IF pcRole NE "dba" AND pcMode EQ "a" THEN
    /* If the given role is in the list, followed by a "w", the user has
       permission to grant it. */
    lCanGrant = 
          (ENTRY(LOOKUP(pcRole,pcPermissionList) + 1,pcPermissionList) = "w").
  
  /* Initial value of logicals is FALSE, so this works for both worlds. 
     This will only affect the outcome of the next statement down if we're 
     in auditing mode. */
  IF pcMode = "a" THEN
    lAdminAvail = roleAvailable("_sys.audit.admin").

  /* If there's no Audit Admin and the user is a dba, then that's ok. */
  IF NOT lCanGrant AND 
     CAN-DO(pcPermissionList,"dba") AND
     lAdminAvail = FALSE THEN
    lCanGrant = TRUE.

  RETURN lCanGrant.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION canRevoke Include 
FUNCTION canRevoke RETURNS LOGICAL
  ( INPUT pcRole    AS CHARACTER,
    INPUT pcGrantee AS CHARACTER,
    INPUT pcGrantor AS CHARACTER,
    INPUT pcUser    AS CHARACTER,
    INPUT pcMode    AS CHARACTER ):
/*------------------------------------------------------------------------------
  Purpose: Returns whether the specified user has rights to revoke a specific
           permission record.
Parameters: INPUT pcRole           - Permission to revoke
            INPUT pcGrantee        - Grantee of the permission
            INPUT pcGrantor        - Grantor of the permission
            INPUT pcUser           - User attempting to revoke the permission
            INPUT pcMode           - Operating Mode
                                     "a" = Auditing
                                     no others implemented at this time
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lAdminRole  AS LOGICAL     NO-UNDO.
  DEFINE VARIABLE lDBA        AS LOGICAL     NO-UNDO.
  DEFINE VARIABLE lAudAdmin   AS LOGICAL     NO-UNDO.
  DEFINE VARIABLE lCanRevoke  AS LOGICAL     NO-UNDO.
  DEFINE VARIABLE lAdminAvail AS LOGICAL     NO-UNDO.

  DEFINE VARIABLE cPerms      AS CHARACTER   NO-UNDO.
                             
  cPerms = getPermissions(pcUser,pcMode).
  IF pcMode = "a" THEN DO:
    ASSIGN lAdminRole  = LOOKUP("audit.admin",pcRole,".") > 0
           lDBA        = CAN-DO(cPerms,"dba")
           lAudAdmin   = INDEX(cPerms,"audit.admin") > 0
           lAdminAvail = roleAvailable("_sys.audit.admin").

    /* If the user is an audit admin he has the ability to 
       revoke all audit related permissions, even audit admin. */
    IF lAudAdmin THEN DO:
      /* Audit admin can revoke any audit permission besides admin, so just
         return true if this is the case */
      IF NOT lAdminRole THEN
        RETURN TRUE.

      /* If this is an admin role and there is more than one audit administrator
         then an audit admin can revoke it */
      IF lAdminRole AND 
         lAdminAvail EQ ? THEN
        RETURN TRUE.
    END. /* If the user is an audit admin */

    /* If this is the last audit admin, and the user is a DBA */
    IF lAdminRole AND 
       lDBA       AND 
       (lAdminAvail = TRUE) THEN
      RETURN TRUE.

    /* If the user has grant-rights for the specified role and
       it's not an admin role and the user was the grantor */
    IF LOOKUP(pcRole,cPerms) > 0                     AND
       ENTRY(LOOKUP(pcRole,cPerms) + 1,cPerms) = "w" AND
       NOT lAdminRole                                AND
       (pcGrantor EQ pcUser) THEN
      RETURN TRUE.

    /* If there are no audit administrators and the user is a DBA */
    IF (lAdminAvail = FALSE) AND
       lDBA THEN
      RETURN TRUE.

    RETURN FALSE.
  END. /* Auditing mode */

  RETURN FALSE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getPermissions Include 
FUNCTION getPermissions RETURNS CHARACTER
  ( INPUT pcUserID AS CHARACTER,
    INPUT pcMode   AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Lists the permissions the specified user holds in the currently
            connected database, along with whether those permissions are 
            "read/write" or "read" only.
Parameters: INPUT pcUserID - UserID of user to get permissions for. 
            INPUT pcMode   - Operating Mode
                             "a" = Auditing
                             No others implemented at this time
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hSGRole      AS HANDLE      NO-UNDO.
  DEFINE VARIABLE hQuery       AS HANDLE      NO-UNDO.
  DEFINE VARIABLE hSecRole     AS HANDLE      NO-UNDO.

  DEFINE VARIABLE cPermissions AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cRight       AS CHARACTER   NO-UNDO.

  DEFINE VARIABLE lAuditAdmin  AS LOGICAL     NO-UNDO.

  /* The rule is... If there is only one Audit Administrator, the
     DBA can delete the Audit Administrator from the DB.  If there 
     are more than one Audit Administrator, they can only be deleted
     by another Audit Administrator.  Kind of a hole, but necessary. 

     This code block adds DBA as the first permission and indicates 
     that he can delete Audit Administrator roles by placing a "w"
     in the next slot after DBA.  Otherwise DBA is followed by "r" */
  IF hasRole(pcUserID,"dba",FALSE) THEN DO:
    lAuditAdmin = roleAvailable("_sys.audit.admin").
    IF (lAuditAdmin = ?) THEN
      cPermissions = "dba," + (IF pcMode = "a" THEN "r" ELSE "w").
    ELSE cPermissions = "dba,w".
  END.

  /* Is this user an Audit Administrator? */
  lAuditAdmin = hasRole(pcUserID,"_sys.audit.admin",FALSE).

  CREATE BUFFER hSGRole  FOR TABLE "DICTDB._sec-granted-role".
  CREATE BUFFER hSecRole FOR TABLE "DICTDB._sec-role".

  CREATE QUERY hQuery.

  hQuery:SET-BUFFERS(hSecRole).
  hQuery:QUERY-PREPARE("FOR EACH _sec-role NO-LOCK").
  hQuery:QUERY-OPEN().
  hQuery:GET-FIRST().

  /* Here we go through all of the roles that are available in the 
     _sec-role table and try to find permissions records for that role.

     This block contains all the logic for deciding what incendiary 
     permissions granting rights various roles may have.

     For instance; Audit Administrators can grant permissions for all
     other audit roles, so we add all available audit permissions to 
     the list when the user is an audit administrator. */
  DO WHILE NOT hQuery:QUERY-OFF-END:
    hSGRole:FIND-FIRST("WHERE _sec-granted-role._grantee = ~'" + pcUserID + 
                       "~' AND _sec-granted-role._role-name = ~'" + 
                       hSecRole::_role-name + "~'") NO-ERROR.
    IF hSGRole:AVAILABLE THEN DO:
      IF pcMode = "a" THEN DO:
        IF lAuditAdmin THEN DO:
          /* If the user is an audit admin and it's an auditing right but 
             not audit admin, give the user grant-rights for the role.  */
          IF LOOKUP("audit",hSGRole::_role-name,".") > 0 AND
             LOOKUP("admin",hSGRole::_role-name,".") < 1 THEN
            cRight = "w".
          ELSE cRight = "".
        END.
        ELSE cRight = "".
      END. /* pcMode = "a" */
      ELSE DO:
        /* If the user is a DBA and this is not an auditing permission,
           they automatically get this permission, with grant rights. */
        IF CAN-DO(cPermissions,"dba") AND 
           LOOKUP("audit",hSGRole::_role-name,".") < 1 THEN
          cRight = "w".
        ELSE cRight = "".
      END.

      /* Add the permission to the list with the rights that we decided
         on above, or the rights they were actually assigned */
      cPermissions = cPermissions + (IF cPermissions NE "" THEN "," ELSE "") +
                     hSGRole::_role-name + "," + 
                     (IF cRight = "" THEN 
                        (IF hSGRole::_grant-rights THEN "w" ELSE "r")
                      ELSE cRight).
    END.
    ELSE DO:
      IF pcMode = "a" THEN DO:
        IF lAuditAdmin THEN DO:
          IF LOOKUP("audit",hSecRole::_role-name,".") > 0 AND
             LOOKUP("admin",hSecRole::_role-name,".") < 1 THEN
            cPermissions = cPermissions + 
                           (IF cPermissions NE "" THEN "," ELSE "") +
                           hSecRole::_role-name + ",w".
        END.
      END.
      ELSE DO:
        IF CAN-DO(cPermissions,"dba") AND 
           LOOKUP("audit",hSecRole::_role-name,".") < 1 THEN
          cPermissions = cPermissions + 
                         (IF cPermissions NE "" THEN "," ELSE "") +
                         hSecRole::_role-name + ",w".
      END.
    END.
    hQuery:GET-NEXT().
  END.
  hQuery:QUERY-CLOSE().

  DELETE OBJECT hSecRole.
  DELETE OBJECT hQuery.
  DELETE OBJECT hSGRole.
  RETURN cPermissions.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getRoleDesc Include 
FUNCTION getRoleDesc RETURNS CHARACTER
  ( INPUT pcRoleName AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Match up a role name with the role description.
Parameters: INPUT pcRoleName - The name of the role
    Notes:  Roles haven't been implemented yet so, in anticipation
            of the future implementation, we check the _sec-role table
            first for a role description and, if it doesn't exist yet,
            we have a list to use.  
            
            If it isn't in the _sec-role table and it isn't in our
            shortlist, simply return the role name back to the caller.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hSRole    AS HANDLE      NO-UNDO.

  DEFINE VARIABLE cRoleDesc AS CHARACTER   NO-UNDO.

  CREATE BUFFER hSRole FOR TABLE "DICTDB._sec-role".

  hSRole:FIND-FIRST("WHERE _role-name = ~'" + pcRoleName + "~'") NO-ERROR.
  IF hSRole:AVAILABLE THEN
    cRoleDesc = hSRole::_role-description.
  ELSE DO:
    CASE pcRoleName:
      WHEN "_sys.audit.admin" THEN
        cRoleDesc = "Audit Administrator".
      WHEN "_sys.audit.archive" THEN
        cRoleDesc = "Audit Archiver".
      WHEN "_sys.audit.appevent.insert" THEN
        cRoleDesc = "Application Audit Event Creator".
      WHEN "_sys.audit.read" THEN
        cRoleDesc = "Audit Data Reader".
    END CASE.
  END.
  DELETE OBJECT hSRole.
  
  RETURN (IF cRoleDesc EQ ? THEN "" 
          ELSE (IF cRoleDesc EQ "" THEN pcRoleName 
                ELSE cRoleDesc)).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION hasRole Include 
FUNCTION hasRole RETURNS LOGICAL
  ( INPUT pcUser    AS CHARACTER,
    INPUT pcRole    AS CHARACTER,
    INPUT plGranter AS LOGICAL ):
/*------------------------------------------------------------------------------
  Purpose:  Checks whether the supplied userid holds the specified role
            in the connected database.  
Parameters: INPUT pcUser    - UserID of user
            INPUT pcRole    - Role name to check for
            INPUT plGranter - Does user have "grant" rights for this role
    Notes:  If plGranter is TRUE, this returns FALSE unless the user has
            "grant" rights for said role.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lOk     AS LOGICAL     NO-UNDO.
  DEFINE VARIABLE lDBA    AS LOGICAL     NO-UNDO.

  DEFINE VARIABLE hSGRole AS HANDLE      NO-UNDO.

  RUN prodict/_dctadmn.p ( INPUT pcUser,
                           OUTPUT lDBA ).
                           
  IF pcRole EQ "dba" THEN 
    RETURN lDBA.
  
  CREATE BUFFER hSGRole FOR TABLE "DICTDB._sec-granted-role".
  hSGRole:FIND-FIRST("WHERE _grantee   = ~'" + pcUser + 
                     "~' AND _role-name = ~'" + pcRole + "~'" +
                     (IF plGranter THEN " AND _grant-rights"
                      ELSE ""),NO-LOCK) NO-ERROR.

  lOk = hSGRole:AVAILABLE.
  
  IF INDEX(pcRole,"audit.admin") > 0 AND
     (lOk  = FALSE) THEN DO:
    IF roleAvailable(pcRole) EQ FALSE THEN
      lOk = lDBA.
  END.

  DELETE OBJECT hSGRole.

  RETURN lOk.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION roleAvailable Include 
FUNCTION roleAvailable RETURNS LOGICAL
  ( INPUT pcRoleName AS CHARACTER ):
/*------------------------------------------------------------------------------
  Purpose:  Checks whether any users have been granted the specified role. 
Parameters: INPUT pcRoleName - Role to test for 
    Notes:  If the role is "_sys.audit.admin" we do a unique find and return
            the unknown value (?) if more than one user holds it.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hSGRole    AS HANDLE      NO-UNDO.

  DEFINE VARIABLE lAvailable AS LOGICAL     NO-UNDO.

  CREATE BUFFER hSGRole FOR TABLE "DICTDB._sec-granted-role".

  IF INDEX(pcRoleName,"audit.admin") > 0 THEN
    lAvailable = hSGRole:FIND-UNIQUE("WHERE _role-name = ~'" + 
                                     pcRoleName + "~'",NO-LOCK) NO-ERROR.
  ELSE 
    lAvailable = hSGRole:FIND-FIRST("WHERE _role-name = ~'" + 
                                    pcRoleName + "~'",NO-LOCK) NO-ERROR.
  IF NOT lAvailable THEN
    IF hSGRole:AMBIGUOUS THEN lAvailable = ?.
  
  DELETE OBJECT hSGRole.

  RETURN lAvailable.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION whoGranted Include 
FUNCTION whoGranted RETURNS CHARACTER
  ( INPUT pcRole    AS CHARACTER,
    INPUT pcGrantee AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Returns who the specified permission to the specified grantee.
Parameters: INPUT pcRole    - Permission to grant
            INPUT pcGrantee - User who role was granted to 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cGrantor AS CHARACTER   NO-UNDO.

  DEFINE VARIABLE hSGRole  AS HANDLE      NO-UNDO.

  CREATE BUFFER hSGRole FOR TABLE "DICTDB._sec-granted-role".
  hSGRole:FIND-FIRST("WHERE _grantee = ~'" + pcGrantee + "~' AND " +
                     "_role-name = ~'" + pcRole + "~'",NO-LOCK) NO-ERROR.
  IF hSGRole:AVAILABLE THEN
    cGrantor = hSGRole::_grantor.
  ELSE cGrantor = ?.

  DELETE OBJECT hSGRole.
  RETURN cGrantor.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

