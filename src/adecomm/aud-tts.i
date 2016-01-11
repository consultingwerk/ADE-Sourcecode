/*************************************************************/
/* Copyright (c) 1984-2006,2011 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------

  File: adecomm/aud-tts.i

  Description: Defines the temp-tables used for fetching audit data for
               auditing reports.

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: Kenneth S. McIntosh

  Created: June 20,2005

  History:
    kmcintos Sep 1, 2005   Added shared buffers to workaround core bug
                           (core bug # 20050830-017) 20050901-009.
    fernando Dec 23,2005   Removed before-table dom shared temp-tables
------------------------------------------------------------------------*/

DEFINE {1} SHARED VARIABLE ghDataSet    AS HANDLE      NO-UNDO.

DEFINE {1} SHARED TEMP-TABLE clientSess NO-UNDO
    FIELD _Client-session-uuid           AS CHARACTER 
                                            LABEL "Client session uuid" 
                                            FORMAT "X(28)"
                                            CASE-SENSITIVE
    FIELD _Client-name                   AS CHARACTER 
                                            LABEL "Client name" 
                                            FORMAT "X(35)"
    FIELD _User-id                       AS CHARACTER 
                                            LABEL "User id" 
                                            FORMAT "X(35)"
    FIELD _Authentication-date-time      AS DATETIME-TZ 
                                            LABEL "Authentication date/time" 
                                            FORMAT "99/99/9999 HH:MM:SS.SSS+HH:MM" 
                                            INITIAL "?"
    FIELD _Server-uuid                   AS CHARACTER 
                                            LABEL "Server uuid" 
                                            FORMAT "X(28)"
                                            CASE-SENSITIVE
    FIELD _Authentication-domain-type    AS CHARACTER 
                                            LABEL "Authentication domain type" 
                                            FORMAT "X(35)"
    FIELD _Authentication-domain-name    AS CHARACTER 
                                            LABEL "Authentication domain name" 
                                            FORMAT "X(70)"
    FIELD _Db-guid                       AS CHARACTER 
                                            LABEL "Database guid" 
                                            FORMAT "X(28)"
                                            CASE-SENSITIVE
    FIELD _Db-description                AS CHARACTER 
                                            LABEL "Database description" 
                                            FORMAT "X(70)"
    FIELD _Session-custom-detail         AS CHARACTER 
                                            LABEL "Session custom detail" 
                                            FORMAT "X(3000)"
                            VIEW-AS EDITOR SIZE 70 BY 8 SCROLLBAR-VERTICAL 
                                    LARGE MAX-CHARS 3000
    FIELD _Audit-data-security-level     AS INTEGER 
                                            LABEL "Audit data security level" 
                                            FORMAT "->9" INITIAL "0"
                            VIEW-AS COMBO-BOX INNER-LINES 5 
                                    LIST-ITEM-PAIRS "No Additional Security",0,
                                                    "Message Digest",1,
                                                    "DB Passkey",2 
                                    DROP-DOWN-LIST SIZE 37 BY 1    
    FIELD _Audit-data-security-level-name AS CHARACTER 
                                            LABEL "Data security level name" 
                                            FORMAT "X(28)"
    FIELD _Data-sealed                   AS LOGICAL
                                            LABEL "Data sealed" 
                                            VIEW-AS TOGGLE-BOX
    
    INDEX _Auth-time _Authentication-date-time
    INDEX _Db-guid _Db-guid
    INDEX _Session-uuid IS PRIMARY UNIQUE _Client-session-uuid
    INDEX _Userid _User-id.

DEFINE {1} SHARED TEMP-TABLE audDataValue NO-UNDO
    FIELD _Audit-data-guid               AS CHARACTER 
                                            LABEL "Audit data guid" 
                                            FORMAT "X(28)"
                                            CASE-SENSITIVE
    FIELD _Field-name                    AS CHARACTER 
                                            LABEL "Field name" 
                                            FORMAT "X(32)"
    FIELD _Continuation-sequence         AS INTEGER 
                                            LABEL "Continuation sequence" 
                                            FORMAT "->9" INITIAL "0"
    FIELD _Data-type-code                AS INTEGER 
                                            LABEL "Data type code" 
                                            FORMAT "->9" INITIAL "0"
                            VIEW-AS COMBO-BOX INNER-LINES 5 
                                    LIST-ITEM-PAIRS "Character",1,
                                                    "Date",2,
                                                    "Logical",3,
                                                    "Integer",4,
                                                    "INT64",41,
                                                    "Decimal",5,
                                                    "Recid",7,
                                                    "Raw",8,
                                                    "Memptr",11,
                                                    "Rowid",13,
                                                    "Blob",18,
                                                    "Clob",19,
                                                    "Datetime",34,
                                                    "Longchar",39,
                                                    "Datetime-TZ",40 
                                    DROP-DOWN-LIST SIZE 37 BY 1    
    FIELD _Data-type-name                AS CHARACTER 
                                            LABEL "Data type" 
                                            FORMAT "X(20)" 
    FIELD _Old-string-value              AS CHARACTER 
                                            LABEL "Old value" 
                                            FORMAT "X(3000)"
                            VIEW-AS EDITOR SIZE 60 BY 2
                                    LARGE MAX-CHARS 3000
    FIELD _New-string-value              AS CHARACTER 
                                            LABEL "New value" 
                                            FORMAT "X(3000)"
                            VIEW-AS EDITOR SIZE 60 BY 2
                                    LARGE MAX-CHARS 3000
    FIELD _Audit-data-security-level     AS INTEGER 
                                            LABEL "Audit data security level" 
                                            FORMAT "->9" INITIAL "0"
                            VIEW-AS COMBO-BOX INNER-LINES 5 
                                    LIST-ITEM-PAIRS "No Additional Security",0,
                                                    "Message Digest",1,
                                                    "DB Passkey",2 
                                    DROP-DOWN-LIST SIZE 37 BY 1    
    FIELD _Audit-data-security-level-name AS CHARACTER 
                                            LABEL "Data security level name" 
                                            FORMAT "X(28)" 
    FIELD _Data-sealed                   AS LOGICAL
                                            LABEL "Data sealed" 
                                            VIEW-AS TOGGLE-BOX
    INDEX _Continuation-seq IS PRIMARY UNIQUE _Audit-data-guid
                                              _Field-name
                                              _Continuation-sequence
    INDEX _Field-name _Field-name.

DEFINE {1} SHARED TEMP-TABLE audData NO-UNDO
    FIELD _Audit-date-time               AS DATETIME-TZ 
                                            LABEL "Audit date / time" 
                                        FORMAT "99/99/9999 HH:MM:SS.SSS+HH:MM" 
                                            INITIAL "?"
    FIELD _Event-description             AS CHARACTER 
                                            LABEL "Event description" 
                                            FORMAT "X(50)"
    FIELD _User-id                       AS CHARACTER 
                                            LABEL "User id" 
                                            FORMAT "X(35)"
    FIELD _Formatted-event-context        AS CHARACTER 
                                            LABEL "Formatted event context" 
                                            FORMAT "X(200)" 
                                            VIEW-AS EDITOR 
                                              INNER-CHARS 60 
                                              INNER-LINES 3 
                                              LARGE MAX-CHARS 200
    FIELD _Db-description                 AS CHARACTER 
                                            LABEL "Database description" 
                                            FORMAT "X(70)" 
    FIELD _Transaction-id                AS INTEGER 
                                            LABEL "Transaction id" 
                                            FORMAT "->>>>>>>9" INITIAL "0"
    FIELD _Transaction-sequence          AS INTEGER 
                                            LABEL "Transaction sequence" 
                                            FORMAT "->>>>>>>9" INITIAL "0"
    FIELD _Client-name                    AS CHARACTER 
                                            LABEL "Client name" 
                                            FORMAT "X(70)"
    FIELD _Audit-event-group             AS CHARACTER 
                                            LABEL "Audit event group" 
                                            FORMAT "X(28)"
                                            CASE-SENSITIVE
    FIELD _Audit-event-group-name         AS CHARACTER 
                                            LABEL "Event group name" 
                                            FORMAT "X(70)"
    FIELD _Application-context-id        AS CHARACTER 
                                            LABEL "Application context id" 
                                            FORMAT "X(28)"
                                            CASE-SENSITIVE
    FIELD _Application-context-summary    AS CHARACTER 
                                            LABEL "Application context summary" 
                                            FORMAT "X(70)" 
    FIELD _Audit-data-guid               AS CHARACTER 
                                            LABEL "Audit data guid" 
                                            FORMAT "X(28)"
                                            CASE-SENSITIVE
    FIELD _Database-connection-id        AS CHARACTER 
                                            LABEL "Database connection id" 
                                            FORMAT "X(28)"
    FIELD _Event-id                      AS INTEGER 
                                            LABEL "Event id" 
                                            FORMAT "->>>>>9" INITIAL "0"
    FIELD _Event-detail                  AS CHARACTER 
                                            LABEL "Event detail" 
                                            FORMAT "X(3000)"
                            VIEW-AS EDITOR SIZE 70 BY 8 SCROLLBAR-VERTICAL 
                                    LARGE MAX-CHARS 3000
    FIELD _Audit-custom-detail           AS CHARACTER 
                                            LABEL "Audit custom detail" 
                                            FORMAT "X(3000)"
                            VIEW-AS EDITOR SIZE 70 BY 8 SCROLLBAR-VERTICAL 
                                    LARGE MAX-CHARS 3000
    FIELD _Audit-data-security-level     AS INTEGER 
                                            LABEL "Audit data security level" 
                                            FORMAT "->9" INITIAL "0"
                            VIEW-AS COMBO-BOX INNER-LINES 5 
                                    LIST-ITEM-PAIRS "No Additional Security",0,
                                                    "Message Digest",1,
                                                    "DB Passkey",2 
                                    DROP-DOWN-LIST SIZE 37 BY 1    
    FIELD _Audit-data-security-level-name AS CHARACTER 
                                            LABEL "Audit Data Security Level" 
                                            FORMAT "X(28)"
    FIELD _Client-session-uuid           AS CHARACTER 
                                            LABEL "Client session uuid" 
                                            FORMAT "X(28)"
                                            CASE-SENSITIVE
    FIELD _Db-guid                       AS CHARACTER 
                                            LABEL "Database guid" 
                                            FORMAT "X(28)"
                                            CASE-SENSITIVE
    FIELD _Event-context                 AS CHARACTER 
                                            LABEL "Event context" 
                                            FORMAT "X(200)"
                            VIEW-AS EDITOR SIZE 70 BY 3 SCROLLBAR-VERTICAL 
                                    LARGE MAX-CHARS 200
    FIELD _Data-sealed                   AS LOGICAL
                                            LABEL "Data Seal Generated" 
                                            VIEW-AS TOGGLE-BOX
    FIELD _Event-Name                    AS CHARACTER
                                            LABEL "Event Name"
                                            FORMAT "x(50)"
    FIELD _Event-Type                    AS CHARACTER
                                            LABEL "Event Type"
                                            FORMAT "x(20)"
    INDEX _AppContext-Id _Application-context-id
    INDEX _Audit-time _Audit-date-time
    INDEX _Connection-id _Database-connection-id 
                         _Client-session-uuid
    INDEX _Data-guid IS UNIQUE _audit-data-guid
    INDEX _main-idx IS PRIMARY UNIQUE _audit-date-time DESC _event-id DESC _Audit-data-guid
   /* INDEX _Event-context _Event-context */
    INDEX _Event-group _Audit-event-group
                       _Db-guid
                       _Transaction-id
                       _Transaction-sequence
    INDEX _EventId _Event-id
    INDEX _Userid _User-id.

DEFINE {1} SHARED BUFFER bClientSess   FOR clientSess.
DEFINE {1} SHARED BUFFER bAudData      FOR audData.
DEFINE {1} SHARED BUFFER bAudDataValue FOR audDataValue.
