/*************************************************************/  
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : _aud-conflict.p
    Purpose     : Checks for conflicts on active policies in the dataset
                  object passed in. Or it returns the aggregation of all
                  active policies with the effective settings.

    Syntax      : 

    Description : 

    Author(s)   : Fernando de Souza
    Created     : Mar 02,2005
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* temp-table definitions */
{auditing/ttdefs/_audpolicytt.i}
{auditing/ttdefs/_audfilepolicytt.i}
{auditing/ttdefs/_audfieldpolicytt.i}
{auditing/ttdefs/_audeventpolicytt.i}

/* dataset definition */
{auditing/include/_dspolicy.i}

/*some useful definitions */
{auditing/include/_aud-std.i}

{auditing/include/aud-report.i}

DEFINE TEMP-TABLE workAudEvent NO-UNDO
    FIELD event-id          AS INTEGER
    FIELD event-level       AS INTEGER
    FIELD policy-name       AS CHARACTER
    FIELD data-sec-lvl      AS INTEGER
    FIELD custom-detail-lvl AS INTEGER
    FIELD conflict          AS LOGICAL
    FIELD cFieldList        AS CHARACTER
    INDEX event-id event-id.

DEFINE TEMP-TABLE workAudFile NO-UNDO
    FIELD tbl-name          AS CHARACTER
    FIELD tbl-owner         AS CHARACTER
    FIELD create-lvl        AS INTEGER
    FIELD update-lvl        AS INTEGER
    FIELD delete-lvl        AS INTEGER
    FIELD data-sec-lvl      AS INTEGER
    FIELD create-event-id   AS INTEGER
    FIELD update-event-id   AS INTEGER
    FIELD delete-event-id   AS INTEGER
    FIELD policy-name       AS CHARACTER
    FIELD conflict          AS LOGICAL
    FIELD cFieldList        AS CHARACTER
    INDEX tbl tbl-name tbl-owner.

DEFINE TEMP-TABLE workAudField NO-UNDO
    FIELD tbl-name    AS CHARACTER
    FIELD tbl-owner   AS CHARACTER
    FIELD field-name  AS CHARACTER
    FIELD create-lvl  AS INTEGER
    FIELD update-lvl  AS INTEGER
    FIELD delete-lvl  AS INTEGER
    FIELD identifying AS INTEGER
    FIELD policy-name AS CHARACTER
    FIELD conflict    AS LOGICAL
    FIELD cFieldList        AS CHARACTER
    INDEX fld tbl-name tbl-owner field-name.


/* parameters */
DEFINE INPUT  PARAMETER lconflictMode AS LOGICAL.
DEFINE INPUT  PARAMETER DATASET FOR dsAudPolicy.
DEFINE OUTPUT PARAMETER TABLE FOR ttAudReport.

FUNCTION isEventOff RETURNS LOGICAL (INPUT pEventID AS INTEGER) FORWARD.

/* main block */

/* if no policy is active, return */
FIND FIRST ttAuditPolicy WHERE ttAuditPolicy._Audit-policy-active = YES NO-LOCK NO-ERROR.
IF NOT AVAILABLE ttAuditPolicy THEN DO:
    CREATE ttAudReport.
    ASSIGN ttAudReport.cType = "NOACTIVEPOLICY":U.
   RETURN.
END.

RUN gatherInfo.

/* now let's record the info to pass to the caller */

FOR EACH workAudEvent NO-LOCK:

    /* check if all we care is conflicting information */
    IF lconflictMode AND NOT workAudEvent.conflict THEN NEXT.

    CREATE ttAudReport.
    ASSIGN ttAudReport.cType = "EVENT"
           ttAudReport.CId = STRING(workAudEvent.event-id)
           ttAudReport.cPolicies = workAudEvent.policy-name
           ttAudReport.level-1 = workAudEvent.event-level
           ttAudReport.level-2 = workAudEvent.data-sec-lvl
           ttAudReport.level-3 = workAudEvent.custom-detail-lvl
           ttAudReport.cFieldList = workAudEvent.cFieldList.
END.


/* conflicted table settings */
FOR EACH workAudFile NO-LOCK:

    /* check if all we care is conflicting information */
    IF lconflictMode AND NOT workAudFile.conflict THEN NEXT.

    CREATE ttAudReport.
    ASSIGN ttAudReport.cType = "TABLE"
           ttAudReport.CId = workAudFile.tbl-name + "," + workAudFile.tbl-owner
           ttAudReport.cPolicies = workAudFile.policy-name
           ttAudReport.level-1 = workAudFile.create-lvl
           ttAudReport.level-2 = workAudFile.update-lvl
           ttAudReport.level-3 = workAudFile.delete-lvl
           ttAudReport.cFieldList = workAudFile.cFieldList
           ttAudReport.cData = STRING(workAudFile.data-sec-lvl)
                    + ","  + STRING(workAudFile.create-event-id) + "," + STRING(workAudFile.update-event-id)
                    + "," + STRING(workAudFile.delete-event-id).

    /* if not checking for conflicts, report the field settings for the current table settings */
    IF NOT lconflictMode THEN DO:

        /* aggregated field settings for this table */
        FOR EACH workAudField WHERE workAudField.tbl-name = workAudFile.tbl-name AND 
            workAudField.tbl-owner = workAudFile.tbl-owner NO-LOCK:
            
            CREATE ttAudReport.
            ASSIGN ttAudReport.cType = "FIELD"
                   ttAudReport.CId = workAudField.field-name
                   ttAudReport.cPolicies = workAudField.policy-name
                   ttAudReport.level-1 = workAudField.create-lvl
                   ttAudReport.level-2 = workAudField.update-lvl
                   ttAudReport.level-3 = workAudField.delete-lvl
                   ttAudReport.cFieldList = workAudField.cFieldList
                   ttAudReport.cData = workAudField.tbl-name + "," + workAudField.tbl-owner 
                                       + "," + STRING(workAudField.identifying).
        END.
    END.

END.
   
/* if checking for conflicts, report conflicting field settings */
IF lconflictMode THEN DO:
    
    FOR EACH workAudField WHERE workAudField.conflict = YES NO-LOCK:
        
        CREATE ttAudReport.
        ASSIGN ttAudReport.cType = "FIELD"
               ttAudReport.CId = workAudField.field-name
               ttAudReport.cPolicies = workAudField.policy-name
               ttAudReport.level-1 = workAudField.create-lvl
               ttAudReport.level-2 = workAudField.update-lvl
               ttAudReport.level-3 = workAudField.delete-lvl
               ttAudReport.cFieldList = workAudField.cFieldList
               ttAudReport.cData = workAudField.tbl-name + "," + workAudField.tbl-owner 
                                   + "," + STRING(workAudField.identifying).
    END.
END.



PROCEDURE gatherInfo.
/*------------------------------------------------------------------------------
  Purpose:    The bulk of the process. Gathers information on conflicts 
  Parameters: <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE cTemp AS CHARACTER NO-UNDO.

    /* Loop through all active policies and find any conflicts on audit event settings.
       MUST scan event settings first because we need to find out if a given event will be off,
       in case we locate it in more than one active policy, so when we look at table and field
       level settings, we know that the event is off.
    */
    FOR EACH ttAuditPolicy WHERE ttAuditPolicy._Audit-policy-active = YES NO-LOCK:

        FOR EACH ttAuditEventPolicy 
            WHERE ttAuditEventPolicy._Audit-policy-guid =  ttAuditPolicy._Audit-policy-guid NO-LOCK.
    
            /* see if we already found this event */
            FIND FIRST workAudEvent WHERE workAudEvent.event-id = ttAuditEventPolicy._Event-id NO-ERROR.

            IF NOT AVAILABLE workAudEvent THEN DO:
                /* add it to the working table */
                CREATE workAudEvent.
                ASSIGN workAudEvent.event-id = ttAuditEventPolicy._Event-id
                       workAudEvent.event-level = ttAuditEventPolicy._Event-level
                       workAudEvent.policy-name = ttAuditPolicy._Audit-policy-name
                       workAudEvent.data-sec-lvl = ttAuditPolicy._Audit-data-security-level
                       workAudEvent.custom-detail-lvl = ttAuditPolicy._Audit-custom-detail-level
                       workAudEvent.conflict = NO
                       workAudEvent.cFieldList = "".
            END.
            ELSE DO:
                /* now check for conflicts, if necessary */
                IF ttAuditEventPolicy._Event-level NE workAudEvent.event-level OR 
                   ttAuditPolicy._Audit-data-security-level NE workAudEvent.data-sec-lvl OR 
                   ttAuditPolicy._Audit-custom-detail-level NE workAudEvent.custom-detail-lvl THEN DO:
                
                   IF NOT workAudEvent.conflict THEN
                      ASSIGN workAudEvent.conflict = YES. /* found a conflict */

                   /* now add info on what is conflicting */
                   IF (ttAuditEventPolicy._Event-level NE workAudEvent.event-level) AND
                       LOOKUP("_Event-level":U,workAudEvent.cFieldList) = 0 THEN
                       workAudEvent.cFieldList = workAudEvent.cFieldList + "," + "_Event-level":U.

                   IF (ttAuditPolicy._Audit-data-security-level NE workAudEvent.data-sec-lvl) AND
                       LOOKUP("_Audit-data-security-level":U,workAudEvent.cFieldList) = 0 THEN
                       workAudEvent.cFieldList = workAudEvent.cFieldList + "," + "_Audit-data-security-level":U.

                   IF (ttAuditPolicy._Audit-custom-detail-level NE workAudEvent.custom-detail-lvl) AND
                       LOOKUP("_Audit-custom-detail-level":U,workAudEvent.cFieldList) = 0 THEN
                       workAudEvent.cFieldList = workAudEvent.cFieldList + "," + "_Audit-custom-detail-level":U.

                END.

                /* effective level is always the highest value */
                IF ttAuditEventPolicy._Event-level > workAudEvent.event-level THEN
                   ASSIGN workAudEvent.event-level = ttAuditEventPolicy._Event-level.

                IF ttAuditPolicy._Audit-data-security-level > workAudEvent.data-sec-lvl  THEN
                   ASSIGN workAudEvent.data-sec-lvl = ttAuditPolicy._Audit-data-security-level.

                IF ttAuditPolicy._Audit-custom-detail-level > workAudEvent.custom-detail-lvl THEN
                   ASSIGN workAudEvent.custom-detail-lvl = ttAuditPolicy._Audit-custom-detail-level.

                ASSIGN workAudEvent.policy-name = workAudEvent.policy-name + "," + 
                       ttAuditPolicy._Audit-policy-name.
            END. /*  NOT AVAILABLE workAudEvent */
        END. /* ttAuditEventPolicy  */
    END. /* ttAuditPolicy */

    /* loop through all active policies and find any conflicts on audit table/field settings */
    FOR EACH ttAuditPolicy WHERE ttAuditPolicy._Audit-policy-active = YES NO-LOCK:
        
        /* scan table settings */
        FOR EACH ttAuditFilePolicy 
            WHERE ttAuditFilePolicy._Audit-policy-guid =  ttAuditPolicy._Audit-policy-guid NO-LOCK.

            /* see if we already found this table/owner combination */
            FIND FIRST workAudFile WHERE workAudFile.tbl-name = ttAuditFilePolicy._File-Name AND
                workAudFile.tbl-owner = ttAuditFilePolicy._Owner NO-ERROR.

            IF NOT AVAILABLE workAudFile THEN DO:
                /* add it to the working table */
                CREATE workAudFile.
                ASSIGN workAudFile.tbl-name = ttAuditFilePolicy._File-Name
                       workAudFile.tbl-owner = ttAuditFilePolicy._Owner
                       workAudFile.data-sec-lvl = ttAuditPolicy._Audit-data-security-level
                       workAudFile.policy-name = ttAuditPolicy._Audit-policy-name
                       workAudFile.create-event-id = ttAuditFilePolicy._create-event-id
                       workAudFile.update-event-id = ttAuditFilePolicy._update-event-id
                       workAudFile.delete-event-id = ttAuditFilePolicy._delete-event-id
                       workAudFile.cFieldList = "".

                IF IsEventOff(ttAuditFilePolicy._create-event-id) THEN DO:
                   ASSIGN workAudFile.create-lvl = {&EVENT-OFF}.
                END.
                ELSE
                   workAudFile.create-lvl = ttAuditFilePolicy._Audit-create-level.

                IF IsEventOff(ttAuditFilePolicy._update-event-id) THEN DO:
                   ASSIGN workAudFile.update-lvl = {&EVENT-OFF}.
                END.
                ELSE
                   workAudFile.update-lvl = ttAuditFilePolicy._Audit-update-level.

                IF IsEventOff(ttAuditFilePolicy._delete-event-id) THEN DO:
                    ASSIGN workAudFile.delete-lvl = {&EVENT-OFF}.
                END.
                ELSE
                   ASSIGN workAudFile.delete-lvl = ttAuditFilePolicy._Audit-delete-level.

                /* it's an abnormality to have the exact same id for all events, so report it 
                   as conflict - it's really a warning.
                */
                IF workAudFile.create-event-id NE {&EVENT-OFF} AND 
                   workAudFile.create-event-id = workAudFile.update-event-id AND 
                   workAudFile.update-event-id = delete-event-id THEN
                   ASSIGN workAudFile.conflict = YES.

            END.
            ELSE DO:
                /* now check for conflicts */

                IF ttAuditFilePolicy._Audit-create-level NE workAudFile.create-lvl OR 
                   ttAuditFilePolicy._Audit-update-level NE workAudFile.update-lvl OR
                   ttAuditFilePolicy._Audit-delete-level NE workAudFile.delete-lvl OR
                   workAudFile.data-sec-lvl NE ttAuditPolicy._Audit-data-security-level OR
                   workAudFile.create-event-id NE ttAuditFilePolicy._create-event-id OR
                   workAudFile.update-event-id NE ttAuditFilePolicy._update-event-id  OR
                   workAudFile.delete-event-id NE ttAuditFilePolicy._delete-event-id THEN DO:
                
                    IF NOT workAudFile.conflict THEN
                       ASSIGN workAudFile.conflict = YES.

                    /* now add info on what is conflicting */
                    IF (ttAuditFilePolicy._Audit-create-level NE workAudFile.create-lvl) AND
                        LOOKUP("_Audit-create-level":U,workAudFile.cFieldList) = 0 THEN
                        workAudFile.cFieldList = workAudFile.cFieldList + "," + "_Audit-create-level":U.

                    IF (ttAuditFilePolicy._Audit-update-level NE workAudFile.update-lvl) AND
                        LOOKUP("_Audit-update-level":U,workAudFile.cFieldList) = 0 THEN
                        workAudFile.cFieldList = workAudFile.cFieldList + "," + "_Audit-update-level":U.

                    IF (ttAuditFilePolicy._Audit-delete-level NE workAudFile.delete-lvl) AND
                        LOOKUP("_Audit-delete-level":U,workAudFile.cFieldList) = 0 THEN
                        workAudFile.cFieldList = workAudFile.cFieldList + "," + "_Audit-delete-level":U.

                    IF (workAudFile.data-sec-lvl NE ttAuditPolicy._Audit-data-security-level) AND
                        LOOKUP("_Audit-data-security-level":U,workAudFile.cFieldList) = 0 THEN
                        workAudFile.cFieldList = workAudFile.cFieldList + "," + "_Audit-data-security-level":U.

                    /* if different event-ids for a given operation then the result is unpredictable, so report
                       multiple values 
                    */
                    IF ( workAudFile.create-event-id NE ttAuditFilePolicy._create-event-id) AND 
                        workAudFile.create-event-id NE {&MULTIPLE-VALUES} THEN DO: 
                        
                        ASSIGN workAudFile.create-event-id = {&MULTIPLE-VALUES}.

                        IF LOOKUP("_create-event-id":U,workAudFile.cFieldList) = 0 THEN
                        workAudFile.cFieldList = workAudFile.cFieldList + "," + "_create-event-id":U.
                    END.

                    IF ( workAudFile.update-event-id NE ttAuditFilePolicy._update-event-id) AND 
                        workAudFile.update-event-id NE {&MULTIPLE-VALUES} THEN DO:

                        ASSIGN workAudFile.update-event-id = {&MULTIPLE-VALUES}.

                        IF LOOKUP("_update-event-id":U,workAudFile.cFieldList) = 0 THEN
                           workAudFile.cFieldList = workAudFile.cFieldList + "," + "_update-event-id":U.
                    END.

                    IF ( workAudFile.delete-event-id NE ttAuditFilePolicy._delete-event-id) AND 
                        workAudFile.delete-event-id NE {&MULTIPLE-VALUES} THEN DO: 

                         ASSIGN workAudFile.delete-event-id = {&MULTIPLE-VALUES}.

                        IF LOOKUP("_delete-event-id":U,workAudFile.cFieldList) = 0 THEN
                        workAudFile.cFieldList = workAudFile.cFieldList + "," + "_delete-event-id":U.
                    END.
                END. /* if not conflict */


                /* highest value is effective for the levels */

                IF workAudFile.create-lvl <> {&EVENT-OFF} THEN DO:
                    IF ttAuditFilePolicy._Audit-create-level > workAudFile.create-lvl THEN
                       ASSIGN workAudFile.create-lvl = ttAuditFilePolicy._Audit-create-level.
                END.

                IF workAudFile.update-lvl <> {&EVENT-OFF} THEN DO:
                    IF ttAuditFilePolicy._Audit-update-level > workAudFile.update-lvl THEN
                       ASSIGN workAudFile.update-lvl = ttAuditFilePolicy._Audit-update-level.
                END.

                IF workAudFile.delete-lvl <> {&EVENT-OFF} THEN DO:
                    IF ttAuditFilePolicy._Audit-delete-level > workAudFile.delete-lvl THEN
                       ASSIGN workAudFile.delete-lvl = ttAuditFilePolicy._Audit-delete-level.
                END.

                IF ttAuditPolicy._Audit-data-security-level > workAudFile.data-sec-lvl THEN
                   ASSIGN workAudFile.data-sec-lvl = ttAuditPolicy._Audit-data-security-level.

                ASSIGN workAudFile.policy-name = workAudFile.policy-name + "," + 
                       ttAuditPolicy._Audit-policy-name.

            END. /* NOT AVAILABLE workAudFile */
        END. /* ttAuditFilePolicy */


            /* look at field settings on this policy */
            FOR EACH ttAuditFieldPolicy 
                WHERE ttAuditFieldPolicy._Audit-policy-guid =  ttAuditPolicy._Audit-policy-guid NO-LOCK.

                /* see if we already found this table/owner/field combination */
                FIND FIRST workAudField WHERE workAudField.tbl-name = ttAuditFieldPolicy._File-Name AND
                     workAudField.tbl-owner = ttAuditFieldPolicy._Owner AND 
                     workAudField.field-name = ttAuditFieldPolicy._Field-name NO-ERROR.

                IF NOT AVAILABLE workAudField THEN DO:
                    /* add it to the working table */
                    CREATE workAudField.
                    ASSIGN workAudField.tbl-name = ttAuditFieldPolicy._File-Name
                           workAudField.tbl-owner = ttAuditFieldPolicy._Owner
                           workAudField.field-name = ttAuditFieldPolicy._Field-name
                           workAudField.policy-name = ttAuditPolicy._Audit-policy-name
                           workAudField.identifying = ttAuditFieldPolicy._Audit-identifying-field.

                    ASSIGN workAudField.create-lvl = ttAuditFieldPolicy._Audit-create-level
                           workAudField.update-lvl = ttAuditFieldPolicy._Audit-update-level
                           workAudField.delete-lvl = ttAuditFieldPolicy._Audit-delete-level
                           workAudField.cFieldList = "".

                END.
                ELSE DO:

                    IF ttAuditFieldPolicy._Audit-create-level NE workAudField.create-lvl OR
                       ttAuditFieldPolicy._Audit-update-level NE workAudField.update-lvl OR 
                       ttAuditFieldPolicy._Audit-delete-level NE workAudField.delete-lvl OR 
                       ttAuditFieldPolicy._Audit-identifying-field NE workAudField.identifying THEN DO:

                        IF NOT workAudField.conflict THEN
                           ASSIGN workAudField.conflict = YES.

                        /* now add info on what is conflicting */
                        IF (ttAuditFieldPolicy._Audit-create-level NE workAudField.create-lvl) AND
                            LOOKUP("_Audit-create-level":U, workAudField.cFieldList) = 0 THEN
                            workAudField.cFieldList = workAudField.cFieldList + "," + "_Audit-create-level":U.

                        IF (ttAuditFieldPolicy._Audit-update-level NE workAudField.update-lvl) AND
                            LOOKUP("_Audit-update-level":U, workAudField.cFieldList) = 0 THEN
                            workAudField.cFieldList = workAudField.cFieldList + "," + "_Audit-update-level":U.

                        IF (ttAuditFieldPolicy._Audit-delete-level NE workAudField.delete-lvl) AND
                            LOOKUP("_Audit-delete-level":U, workAudField.cFieldList) = 0 THEN
                            workAudField.cFieldList = workAudField.cFieldList + "," + "_Audit-delete-level":U.

                        /* multiple identifying values for the same field causes unpredictable results, so
                           report multiple values 
                        */
                        IF ( ttAuditFieldPolicy._Audit-identifying-field NE workAudField.identifying) AND 
                            workAudField.identifying NE {&MULTIPLE-VALUES} THEN DO: 

                             ASSIGN workAudField.identifying = {&MULTIPLE-VALUES}.

                            IF LOOKUP("_Audit-identifying-field":U, workAudField.cFieldList) = 0 THEN
                               workAudField.cFieldList = workAudFile.cFieldList + "," + "_Audit-identifying-field":U.
                        END.

                    END.

                    /* highest level applies for levels */
                    IF ttAuditFieldPolicy._Audit-create-level > workAudField.create-lvl THEN
                       ASSIGN workAudField.create-lvl = ttAuditFieldPolicy._Audit-create-level.

                    IF ttAuditFieldPolicy._Audit-update-level > workAudField.update-lvl THEN
                       ASSIGN workAudField.update-lvl = ttAuditFieldPolicy._Audit-update-level.

                    IF ttAuditFieldPolicy._Audit-delete-level > workAudField.delete-lvl THEN
                       ASSIGN workAudField.delete-lvl = ttAuditFieldPolicy._Audit-delete-level.


                    ASSIGN workAudField.policy-name = workAudField.policy-name + "," + 
                           ttAuditPolicy._Audit-policy-name.
                END. /* NOT AVAILABLE workAudField */
            END. /* ttAuditFieldPolicy */

    END. /* ttAuditPolicy */


    /* now we have the aggregate of all tables and fields, need to figure out if field settings are 
       going to be ignored - if the event is off at the table level, for instance.
    */
    FOR EACH workAudFile NO-LOCK:

        ASSIGN cTemp = "".

        FOR EACH workAudField WHERE workAudField.tbl-name = workAudFile.tbl-name AND
            workAudField.tbl-owner = workAudFile.tbl-owner.

            /* if event is completely off , and field was set to some higher level, 
               field settings are ignored.
            */
            IF workAudFile.create-lvl = {&EVENT-OFF} THEN DO:
               ASSIGN workAudField.create-lvl = {&FIELD-SETTING-IGNORED}.
            END.

            IF workAudFile.update-lvl = {&EVENT-OFF} THEN DO:
               ASSIGN workAudField.update-lvl = {&FIELD-SETTING-IGNORED}.
            END.

            IF workAudFile.delete-lvl = {&EVENT-OFF} THEN DO: 
               ASSIGN workAudField.delete-lvl = {&FIELD-SETTING-IGNORED}.
            END.

            /* check if more than one field has the same identifying value */
            IF workAudField.identifying <> 0 THEN DO:
               IF LOOKUP(STRING(workAudField.identifying), cTemp) > 0 THEN DO:
                  ASSIGN workAudField.identifying = {&IDENTIFYING-CONFLICT}
                         workAudField.conflict = YES.

                  IF LOOKUP("_Audit-identifying-field":U, workAudField.cFieldList) = 0 THEN
                     workAudField.cFieldList = workAudField.cFieldList + "," + "_Audit-identifying-field":U.
               END.
               ELSE
                   cTemp = cTemp + "," + STRING(workAudField.identifying).
            END.

        END.
    END.

END PROCEDURE.


FUNCTION isEventOff RETURNS LOGICAL (INPUT pEventID AS INTEGER):
    
    /* for some system tables, a given event id may be 0 when it doesn't apply,
       (_db, _db-option, _db-detail). In that case, we can return that the event is not off so we don't 
       report it as a conflict 
    */
    IF pEventId = 0 THEN
        RETURN FALSE.

    /* tries to find the event in our temp-table and return if the event is ON or NOT */
    FIND FIRST workAudEvent WHERE event-id = pEventID NO-ERROR.
    IF AVAILABLE workAudEvent THEN
       RETURN workAudEvent.event-level <= 0.

    RETURN TRUE.

END FUNCTION.
