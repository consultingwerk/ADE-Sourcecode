/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* adecomm/appsrvtt.i Contains the definition for the AppServer Service
                      temp-table

   This definition is declared "NEW GLOBAL" in adecomm/as-utils.w which is 
   called once per PROGRESS session.  adecomm/as-utils is also responsible
   for loading the records when it is called.  protools/as-partn.w is
   responsible for maintaining and dumping the record in the table.  Any
   procedure needing to connect or disconnect needs to call methods in
   adecomm/as-utils.w to lookup information in AppSrv-TT.
   
   Created 11/26/97 by Ross Hunter                                          
   Modified:
     05/09/2000 BSG  Support for multiple partition types and Server URLs */
   
DEFINE {1} SHARED TEMP-TABLE AppSrv-TT
       FIELD Partition     AS CHARACTER FORMAT "X(25)"
       FIELD Host          AS CHARACTER FORMAT "X(15)"  /* NS -H parameter      */
       FIELD Service       AS CHARACTER FORMAT "X(15)"  /* NS -S parameter      */
       FIELD Configuration AS LOGICAL   FORMAT "Remote/Local"
       FIELD Security      AS LOGICAL   FORMAT "Prompt/No"
       FIELD Info          AS CHARACTER LABEL  "AppServer Information"
                                               FORMAT "X(255)"
       FIELD AS-Handle     AS HANDLE                    /* Handle if connected  */
       FIELD App-Service   AS CHARACTER LABEL  "Application Service" FORMAT "X(25)"
       FIELD Conn-Count    AS INTEGER   LABEL  "Pseudo connections" INITIAL 0
       FIELD PartitionType AS CHARACTER FORMAT "X(10)" 
       FIELD ServerURL     AS CHARACTER FORMAT "X(255)"
       FIELD Parameters    AS CHARACTER FORMAT "X(255)"
    INDEX Partition IS PRIMARY UNIQUE Partition
    INDEX App-Service App-Service
    INDEX PartitionType PartitionType.


