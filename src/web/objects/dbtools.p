&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------
  File: dbtools.p

  Description: Contains all database tool functions

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
{ src/web/method/webutils.i NEW }

DEFINE NEW GLOBAL SHARED VARIABLE web-utilities-hdl AS HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE gcDBset           AS CHARACTER NO-UNDO INIT "".

DEFINE VARIABLE cfg-failover AS LOGICAL    NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 17.52
         WIDTH              = 75.2.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-dbCheck) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE dbCheck Procedure 
PROCEDURE dbCheck :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:      Called from web-util after filename has been figured out 
------------------------------------------------------------------------------*/
   DEFINE INPUT  PARAMETER pcFilename AS CHARACTER NO-UNDO.
   DEFINE OUTPUT PARAMETER lRetVal    AS LOGICAL   NO-UNDO INIT TRUE.
   DEFINE VARIABLE c1         AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE i1         AS INTEGER    NO-UNDO.
   DEFINE VARIABLE cConnected AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cDbList    AS CHARACTER  NO-UNDO.
   
   IF cfg-failover THEN 
     RUN dbDisconnect.
   
   FOR EACH ttAgentSetting NO-LOCK WHERE 
        ttAgentSetting.cKey  = "DbObject" AND
        ttAgentSetting.cSub  = "":
     c1 = ttAgentSetting.cVal.
     IF CAN-DO(c1,pcFilename)  
     THEN DO:
       DYNAMIC-FUNCTION("logNote":U IN web-utilities-hdl,"RUN":U,"DbGroup:" + ttAgentSetting.cName + " = " + ttAgentSetting.cVal).
       cDbList = cDbList + (IF cDbList > "" THEN "," ELSE "") 
               + DYNAMIC-FUNCTION("getAgentSetting":U IN web-utilities-hdl,"DbGroup":U,"":U,ttAgentSetting.cName) NO-ERROR.
     END. 
   END.
   

   IF cDbList GT "" THEN DO:                                      /*there is a default set of databases*/
     RUN webutil/dbcheck.p.
     ASSIGN cConnected = RETURN-VALUE.
     DYNAMIC-FUNCTION("logNote":U IN web-utilities-hdl,"RUN":U,"dbCheck:" + cDbList + "=>" + cConnected).
     
     IF ERROR-STATUS:ERROR THEN
        DYNAMIC-FUNCTION("logNote":U IN web-utilities-hdl,"Error":U,SUBSTITUTE ("Could not run proactive database check: &1",ERROR-STATUS:GET-MESSAGE(1))).
     
     DO i1 = 1 TO NUM-ENTRIES(cDbList):                    /*each database in the list*/
       ASSIGN c1 = ENTRY(i1,cDBlist).
       IF c1 <> "" AND NOT CAN-DO(cConnected,c1) THEN DO:
          DYNAMIC-FUNCTION("logNote":U IN web-utilities-hdl,"Error":U,SUBSTITUTE (" Proactive database connection check shows that &1 was not connected. Attempting reconnect.",c1)).
          RUN dbConnect (c1).
          IF RETURN-VALUE = "no" THEN lRetVal = FALSE.
       END. /*NOT CONNECTED*/
     END. /* default databases */
   END.
   IF gcDBset = "" AND NOT lRetVal THEN DO: /* only if not already in failover */
     RUN dbFailover IN web-utilities-hdl. 
     RUN dbDisconnect.     
     RUN dbCheck (INPUT pcFilename,OUTPUT lRetVal).
   END.

   RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-dbConnect) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE dbConnect Procedure 
PROCEDURE dbConnect :
/*------------------------------------------------------------------------------
  Purpose:     Handle problem when a database is not connected. 
  Parameters:  p_databasename = the jname of the database that is not connected.
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE INPUT  PARAMETER p_databasename AS CHARACTER NO-UNDO.
   DEFINE        VARIABLE  cConnect       AS CHARACTER NO-UNDO.

   ASSIGN
     cConnect = DYNAMIC-FUNCTION("getAgentSetting" IN web-utilities-hdl,"Databases",gcDBset,p_databasename).
   IF cConnect = ? THEN DO:
     DYNAMIC-FUNCTION("logNote" IN web-utilities-hdl,"WARNING"," Database not defined!").
     RETURN "".
   END.

   
   DYNAMIC-FUNCTION("logNote":U IN web-utilities-hdl,"CONNECT":U,"Connect:" + p_databasename + " --> " + cConnect).
   IF NUM-ENTRIES(cConnect," ") > 1 THEN 
     RUN webutil/dbConnect.p(p_databasename,cConnect) NO-ERROR.
   ELSE DO:
     cConnect = SEARCH(cConnect).
     IF cConnect = ? 
     THEN DO:
       DYNAMIC-FUNCTION("logNote" IN web-utilities-hdl,"WARNING"," Unable to attempt a reconnect to " + P_databasename + "!").
       RETURN "".
     END.
     RUN VALUE(cConnect) NO-ERROR.
   END.
         
   IF ERROR-STATUS:ERROR 
   THEN DYNAMIC-FUNCTION("logNote" IN web-utilities-hdl,"WARNING"," Unable to reconnect " + P_databasename + " with " + cConnect + ", because it either the connection procedure could not be found, or there was an error running it!)").
   IF RETURN-VALUE = "yes" 
   THEN DYNAMIC-FUNCTION("logNote" IN web-utilities-hdl,"Recovery"," " + P_databasename + " was successfully reconnected.)").
   ELSE DYNAMIC-FUNCTION("logNote" IN web-utilities-hdl,"WARNING"," " + P_databasename + " could not be reconnected.)").
   RETURN RETURN-VALUE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-dbDisconnect) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE dbDisconnect Procedure 
PROCEDURE dbDisconnect :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE c1 AS CHARACTER  NO-UNDO.
  c1 = DYNAMIC-FUNCTION("getGlobal" IN web-utilities-hdl,"DBset").
  IF gcDBset <> c1 THEN DO:
    gcDBset  = c1.
    RUN webutil/dbDisconnect.p NO-ERROR.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-dbFailover) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE dbFailover Procedure 
PROCEDURE dbFailover :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DYNAMIC-FUNCTION("logNote":U IN web-utilities-hdl,"WARNING":U,"Failover!").
  IF gcDBset > '' THEN RETURN. /* only run when not already in failover mode */
  DYNAMIC-FUNCTION("setGlobal" IN web-utilities-hdl,'DBset','failover').
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-init-config) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE init-config Procedure 
PROCEDURE init-config :
/*------------------------------------------------------------------------------
  Purpose:     Read configuration for database failover 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE c1         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE c2         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE i1         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lRetVal    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cDatabases AS CHARACTER  NO-UNDO.
  
  /* Databases that the application is to be aware of.  
     Following each database is parameters or a program that will run if the database is not connected.
     Databases=sports2000=sportsconnect.p|db1=db1connect.p
  */
  ASSIGN c1 = OS-GETENV("DATABASES":U).
  IF c1 NE ? AND c1 > "" THEN
  DO i1 = 1 TO NUM-ENTRIES(c1,"|"):
    ASSIGN 
      c2 = ENTRY(i1,c1, "|")
      cDatabases = cDatabases + "," + ENTRY(1,c2, "=")
      lRetVal = DYNAMIC-FUNCTION("setAgentSetting" IN web-utilities-hdl,"Databases":U,"":U,ENTRY(1,c2, "="),TRIM(ENTRY(2,c2,"="))).
  END.
  
  /* dbGroup -- Organizes connected DBs into logical association sets.  
     These can be used to maintain 
     connections, or associate DBs with code objects.
     
     c1=Default=webstate|sports=sports;webstate
  */
  ASSIGN c1 = REPLACE(OS-GETENV("DB_GROUP":U),";",",").
  IF c1 NE ? AND c1 > "" THEN
  c1-Block:
  DO i1 = 1 TO NUM-ENTRIES(c1,"|"):
    ASSIGN 
      c2      = ENTRY(i1,c1,"|").
      lRetVal = DYNAMIC-FUNCTION("setAgentSetting" IN web-utilities-hdl,"dbGroup":U,"",TRIM(ENTRY(1,c2,"=")),TRIM(ENTRY(2,c2,"="))).
  END. /* c1 block */
  ELSE DO:
    IF cDatabases > "" THEN cDatabases = substring(cDatabases,2).  
    lRetVal = DYNAMIC-FUNCTION("setAgentSetting" IN web-utilities-hdl,"dbGroup":U,"","Default",cDatabases).
  END.

  /* DbOject.  Associate code objects with their required DB(s).  When a code 
     object is run, and it is not found in any of the lists it is assumed that 
     it does not require DB access.  When a code object is run and it's DB is 
     not connected, attempts will be made to connect the necessary db, then a 
     controlled error message will result.
     
     [DbOject] Default=login|sports=c:/usr/apps/cart/ *;/app2/collect|sports2=c:/usr/apps/other/ *
  */
  
  ASSIGN c1 = REPLACE(OS-GETENV("DB_OBJECT":U),";",",").
  IF c1 NE ? AND c1 GT "" THEN
  DO i1 = 1 TO NUM-ENTRIES(c1,"|"):
    ASSIGN 
      c2      = ENTRY(i1,c1,"|")
      lRetVal = DYNAMIC-FUNCTION("setAgentSetting" IN web-utilities-hdl,"DbObject":U,"",ENTRY(1,c2,"="),TRIM(ENTRY(2,c2,"="))).
  END.

  IF cDatabases > "" THEN
    lRetVal = DYNAMIC-FUNCTION("setAgentSetting" IN web-utilities-hdl,"DbObject":U,"","Default":U,"*":U).

   
   /* Failover Databases in case the real DBset cannot connect...
  */
  ASSIGN c1 = OS-GETENV("DB_FAILOVER":U).
  IF c1 NE ? AND c1 > "" THEN DO:
    ASSIGN cfg-failover = TRUE.
    DO i1 = 1 TO NUM-ENTRIES(c1,"|"):
      ASSIGN 
        c2 = ENTRY(i1,c1, "|")
        lRetVal = DYNAMIC-FUNCTION("setAgentSetting" IN web-utilities-hdl,"Databases":U,"failover":U,ENTRY(1,c2, "="),TRIM(ENTRY(2,c2,"="))).
    END.
  END.

  RUN SUPER.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

