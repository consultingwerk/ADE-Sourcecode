&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/
/*--------------------------------------------------------------------------
    File        : adecomm/as-utils.w
    Purpose     : Appserver Utilities

    Syntax      :

    Description : Utilities to aid in the deployment of distributed applications

    Author(s)   : Ross Hunter
    Created     : 12/01/97
    Notes       :
    
    Modified    : 
      05/10/2000  - BSG - JMS Support. Multiple Partition Types.
      06/01/2000  - GFS - Fixed problem with not passing URLs
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
{adecomm/appsrvtt.i "NEW GLOBAL"}
{adecomm/_adetool.i}

DEFINE VARIABLE usr-id AS CHARACTER FORMAT "X(256)":U 
     LABEL "User ID" 
     VIEW-AS FILL-IN 
     SIZE 23 BY 1 TOOLTIP "Enter your User ID" NO-UNDO.

DEFINE VARIABLE psswrd AS CHARACTER FORMAT "X(256)":U 
     LABEL "Password" 
     VIEW-AS FILL-IN 
     SIZE 23 BY 1 TOOLTIP "Enter your password" NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-definedPartitions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD definedPartitions Procedure 
FUNCTION definedPartitions RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getASConnectString) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getASConnectString Procedure 
FUNCTION getASConnectString RETURNS CHARACTER
  ( BUFFER bAppSrvTT FOR AppSrv-TT )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getJMSPartitions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getJMSPartitions Procedure 
FUNCTION getJMSPartitions RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getJMSPtnInfo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getJMSPtnInfo Procedure 
FUNCTION getJMSPtnInfo RETURNS CHARACTER
  ( INPUT cPartition AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPartitionsByType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getPartitionsByType Procedure 
FUNCTION getPartitionsByType RETURNS CHARACTER
  ( INPUT cType AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


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
         HEIGHT             = 22.81
         WIDTH              = 62.2.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* The first thing to do is load up the service records into the
   AppSrv-TT.  This is only done here and this adecomm/as-utils.w
   should only be called once per session so there never should be
   any records already there.  But it is cheap to check it anyway.     */

IF CAN-FIND(FIRST AppSrv-TT) THEN
  MESSAGE "The Application Server Service Table has been previously defined."
          VIEW-AS ALERT-BOX ERROR.
ELSE
  RUN loadPartitionInfo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-appServerConnect) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE appServerConnect Procedure 
PROCEDURE appServerConnect :
/*------------------------------------------------------------------------------
  Purpose:  appServerConnect calls the AppServer CONNECT method.  The extra
            layer facilitates the switching between running locally and running
            remotely (through AppServer Technology) at run time without
            modifying source code.  This is achieved by managing service name
            records in the AppSrv-TT temp-table.
  Parameters:  service_name    the name of partition or service name to be 
                               connected.
               security_prompt Yes causes a prompt for a userid/password which
                               is included in the AppServer CONNECT method.
                               No passes blanks to the AppServer.
               app_server_info Any string is put into the 4Th argument of the
                               AppServer CONNECT method.
               conn-hdl        The connection handle for the AppServer session
  Notes:  
------------------------------------------------------------------------------*/

DEFINE INPUT  PARAMETER partition_name  AS CHARACTER                    NO-UNDO.
DEFINE INPUT  PARAMETER security_prompt AS LOGICAL                      NO-UNDO.
DEFINE INPUT  PARAMETER app_server_info AS CHARACTER                    NO-UNDO.
DEFINE OUTPUT PARAMETER conn-hdl        AS HANDLE                       NO-UNDO.

DEFINE VARIABLE ret         AS LOGICAL                                  NO-UNDO.
DEFINE VARIABLE cConnString AS CHARACTER                                NO-UNDO.
DEFINE BUFFER   xAppSrv-TT  FOR AppSrv-TT.
DEFINE VARIABLE lcancel     AS LOGICAL                                  NO-UNDO.

FIND FIRST AppSrv-TT WHERE AppSrv-TT.Partition = partition_name NO-ERROR.
IF NOT AVAILABLE AppSrv-TT THEN DO:
  MESSAGE "Attempt to connect a partition named" partition_name + "."
          SKIP
          "This partition is not currently defined in the"
          "Service Parameter Maintenance tool." VIEW-AS ALERT-BOX ERROR.
          RETURN "ERROR".
END.  /* If not record is available for this partiton */

IF AppSrv-TT.PartitionType <> "A":U THEN
DO:
  MESSAGE "Attempt to connect a partition named" partition_name + "."
          SKIP
          "This partition is not defined as an AppServer Partition in the"
          "Service Parameter Maintenance tool." VIEW-AS ALERT-BOX ERROR.
          RETURN "ERROR".
END.

/* Determine whether or not to override the defaults */
IF security_prompt = ? THEN security_prompt = AppSrv-TT.Security.
IF app_server_info = ? THEN app_server_info = AppSrv-TT.Info.

IF VALID-HANDLE(AppSrv-TT.AS-HANDLE) AND
   AppSrv-TT.AS-HANDLE = SESSION:HANDLE THEN
   AppSrv-TT.AS-Handle = ?.

/* Return the Session handle if this service isn't remote */
IF NOT AppSrv-TT.Configuration THEN DO:  /* Remote = true : Local = false */
  ASSIGN AppSrv-TT.AS-HANDLE = SESSION:HANDLE
         conn-hdl            = SESSION:HANDLE.
  RETURN.
END.  /* If this service is to be run locally */

/* We have found the record, return the handle if it is already connected */
ASSIGN conn-hdl             = AppSrv-TT.AS-Handle
       AppSrv-TT.Conn-Count = AppSrv-TT.Conn-Count + 1.
IF VALID-HANDLE(conn-hdl) AND
   conn-hdl:CONNECTED() THEN 
    RETURN.  /* Return the existing handle */
ELSE  /* This is now an invalid AppServer Handle */
DO:
  IF conn-hdl NE ? AND            
     conn-hdl NE SESSION:HANDLE THEN                          /* If we are dealing with an AppServer handle */
  DO:
    IF VALID-HANDLE(conn-hdl) THEN
    DO:
      DELETE OBJECT conn-hdl NO-ERROR.                          /* delete the handle to the server object and */
    END.
    FOR EACH xAppSrv-TT WHERE xAppSrv-TT.AS-Handle = conn-hdl:  /* make sure any other references to this handle */
      ASSIGN xAppSrv-TT.AS-Handle = ?.                          /* are set to unknown */
    END.
  END.
END.

conn-hdl = ?.

/* See if any other partition with the same AppService is connected - if so
   use that handle                                                        */
FIND FIRST xAppSrv-TT WHERE xAppSrv-TT.App-Service = AppSrv-TT.App-Service AND
                            xAppSrv-TT.Partition  NE AppSrv-TT.Partition AND
                            VALID-HANDLE(xAppSrv-TT.AS-HANDLE) NO-ERROR.
IF AVAILABLE xAppSrv-TT THEN DO:
  conn-hdl = xAppSrv-TT.AS-Handle.
  IF conn-hdl:CONNECTED() THEN DO:
    ASSIGN AppSrv-TT.AS-Handle = xAppSrv-TT.AS-Handle.
    RETURN.
  END.
  ELSE
  DO:
    DELETE OBJECT conn-hdl NO-ERROR.                          
    ASSIGN conn-hdl = ?
           xAppSrv-TT.AS-Handle = ?.
  END.
END.  /* We found another partition that is currently connected to this AppService */


/* We need to make a connection. */
CREATE SERVER conn-hdl.

/*  Check to see if we need to prompt for userid/password */
IF security_prompt THEN DO:
  IF NUM-DBS > 0 THEN RUN adecomm/get-user.p (OUTPUT usr-id).
  RUN security_prompt (OUTPUT lCancel).
  IF lcancel THEN DO:       /* user pressed cancel when prompted for userid and pw */
    ASSIGN conn-hdl = ?.
    RETURN 'ERROR'.
  END.
END.

cConnString = getASConnectString(BUFFER AppSrv-TT).

/* Do the connection */
ASSIGN ret = conn-hdl:CONNECT(cConnString, usr-id, psswrd, app_server_info).
IF NOT ret THEN DO:
  MESSAGE "Unable to connect to the AppServer for the" AppSrv-TT.App-Service
          "service." VIEW-AS ALERT-BOX ERROR.
  ASSIGN conn-hdl = SESSION:HANDLE.
END.

AppSrv-TT.AS-HANDLE = conn-hdl.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-appServerDisconnect) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE appServerDisconnect Procedure 
PROCEDURE appServerDisconnect :
/*------------------------------------------------------------------------------
  Purpose:     To disconnect from a named service (a Partition)
  Parameters:  service_name  The name of the service to be disconnected from
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER partition_name AS CHARACTER                     NO-UNDO.

  DEFINE VARIABLE        ret            AS LOGICAL                       NO-UNDO.
  DEFINE BUFFER          xAppSrv-TT     FOR AppSrv-TT.

  FIND FIRST AppSrv-TT WHERE AppSrv-TT.Partition = partition_name NO-ERROR.
  
  IF NOT AVAILABLE AppSrv-TT THEN RETURN.

  /* This was being run locally don't disconnect, just null out the handle */ 
  IF NOT VALID-HANDLE(AppSrv-TT.AS-Handle) OR
     (AppSrv-TT.AS-Handle = SESSION:HANDLE) THEN DO:
    AppSrv-TT.AS-Handle = ?.
    RETURN.
  END.

  AppSrv-TT.Conn-Count = AppSrv-TT.Conn-Count - 1.
  
  IF AppSrv-TT.Conn-Count < 1 THEN DO:  /* This partition is tapped out - disconnect it */
    /* Check to see if another partition is still using the connection */
    IF CAN-FIND(FIRST xAppSrv-TT WHERE xAppSrv-TT.App-Service = AppSrv-TT.App-Service AND
                                       xAppSrv-TT.Partition  NE partition_name AND
                                       VALID-HANDLE(xAppSrv-TT.AS-Handle)) THEN DO:
      AppSrv-TT.AS-Handle = ?.         /* Keep the connection for this other partition */
      RETURN.
    END. /* Found another active connection */
 
    /* Disconnect here */
    ret = AppSrv-TT.AS-Handle:DISCONNECT().
    IF ret THEN DO:  /* Disconnection was succesful */
      DELETE OBJECT AppSrv-TT.AS-HANDLE.
      AppSrv-TT.AS-Handle = ?.
    END.
    ELSE MESSAGE "There is an error disconnecting from the" AppSrv-TT.App-Service
                 "AppServer Service." VIEW-AS ALERT-BOX ERROR.
  END. /* If the partition has no active connections (Conn-Count < 1) */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loadPartitionInfo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadPartitionInfo Procedure 
PROCEDURE loadPartitionInfo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE tt-file AS CHARACTER                             NO-UNDO.

tt-file = SEARCH("appsrvtt.d":U).
IF tt-file ne ? THEN DO:  /* We found the file */
  INPUT FROM value(tt-file) NO-ECHO.
  REPEAT TRANSACTION:
    CREATE AppSrv-TT.
    IMPORT AppSrv-TT.Partition 
           AppSrv-TT.Host
           AppSrv-TT.Service
           AppSrv-TT.Configuration
           AppSrv-TT.Security
           AppSrv-TT.Info
           AppSrv-TT.App-Service
           AppSrv-TT.PartitionType
           AppSrv-TT.ServerURL.
    IF AppSrv-TT.App-Service = "":U THEN /* Convert from 9.0A to 9.0B */
      AppSrv-TT.App-Service = AppSrv-TT.Partition.
    IF AppSrv-TT.PartitionType = "":U THEN
      AppSrv-TT.PartitionType = "A":U.
    ASSIGN AppSrv-TT.AS-Handle = ?.
    VALIDATE AppSrv-TT.
  END. /* Repeat */
  INPUT CLOSE.
END. /* If we found the appsrvtt.d file */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-savePartitionInfo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE savePartitionInfo Procedure 
PROCEDURE savePartitionInfo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
OUTPUT TO appsrvtt.d.
FOR EACH AppSrv-TT NO-LOCK:
  /* This next 3 lines shouldn't be necessary, but there seems to be a bug
     in the updatable browse */
  IF AppSrv-TT.App-Service = "" AND AppSrv-TT.Host = "" AND
     AppSrv-TT.Service = "" AND AppSrv-TT.Configuration = NO THEN
    DELETE AppSrv-TT.
  ELSE
    EXPORT AppSrv-TT.Partition
           AppSrv-TT.Host
           AppSrv-TT.Service
           AppSrv-TT.Configuration
           AppSrv-TT.Security
           AppSrv-TT.Info
           AppSrv-TT.App-Service
           AppSrv-TT.PartitionType
           AppSrv-TT.ServerURL.
END.  /* For Each */
OUTPUT CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-security_prompt) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE security_prompt Procedure 
PROCEDURE security_prompt :
/*------------------------------------------------------------------------------
  Purpose:  Prompts for userid and password   
  Parameters:  returns lCancel = TRUE if cancel was pressed.
               returns lCancel = FALSE if ok was pressed.
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER lCancel AS LOGICAL              NO-UNDO.
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON Btn_Help 
     LABEL "&Help" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "OK" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .



/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Security-Dialog
     usr-id AT ROW 1.71 COL 11 COLON-ALIGNED
     psswrd AT ROW 2.91 COL 11 COLON-ALIGNED BLANK 
     Btn_OK AT ROW 1.52 COL 42
     Btn_Cancel AT ROW 2.76 COL 42
     Btn_Help AT ROW 4.76 COL 42
     SPACE(1.99) SKIP(0.28)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Security Check"
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel.

  ASSIGN lCancel = TRUE.        
  UPDATE usr-id psswrd Btn_OK Btn_Cancel Btn_Help 
         WITH FRAME Security-Dialog.
  ASSIGN lCancel = FALSE.       /* If we get to here then OK was pressed (not cancel)*/
  HIDE FRAME Security-Dialog.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-definedPartitions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION definedPartitions Procedure 
FUNCTION definedPartitions RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a list of defined Partitions (separated by CHR(3))
    Notes: 
    Modifications: 
       05/09/00 - BSG - Changed to use getPartitionsByType
------------------------------------------------------------------------------*/

  RETURN getPartitionsByType("A":U).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getASConnectString) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getASConnectString Procedure 
FUNCTION getASConnectString RETURNS CHARACTER
  ( BUFFER bAppSrvTT FOR AppSrv-TT ) :
/*------------------------------------------------------------------------------
  Purpose:  Creates the connect string for the AppServer connect method
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lDirect AS LOGICAL INITIAL ? NO-UNDO.

  /* If the direct connection parameters are blank, don't make a 
     direct connection */
  IF (bAppSrvTT.Host = "":U OR bAppSrvTT.Host = ?) AND
     (bAppSrvTT.Service = "":U OR bAppSrvTT.Service = ?) AND
     (bAppSrvTT.App-Service = "":U OR bAppSrvTT.App-Service = ?) THEN
    lDirect = NO.
  
  /* If the URL parameters are blank, use a direct connetion */
  IF (bAppSrvTT.ServerURL = "":U OR bAppSrvTT.ServerURL = ?)  THEN
    lDirect = YES.
  ELSE 
    lDirect = NO. /* Either WEBCLIENT or 4GL client using a URL */

  /* If we haven't decided the type of connection, decide from the 
     new CLIENT-TYPE attribute */
  IF lDirect = ? AND
      SESSION:CLIENT-TYPE <> "WebClient":U THEN
    lDirect = YES.

  /* Return the appropriate connection string */
  IF lDirect THEN 
    RETURN (IF bAppSrvTT.Host        NE "":U THEN " -H ":U + bAppSrvTT.Host ELSE "":U) +
           (IF bAppSrvTT.Service     NE "":U THEN " -S ":U + bAppSrvTT.Service ELSE "":U) +
           (IF bAppSrvTT.App-Service NE "":U THEN " -AppService ":U + bAppSrvTT.App-Service ELSE "":U).
  ELSE 
    RETURN "-URL ":U + bAppSrvTT.ServerURL.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getJMSPartitions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getJMSPartitions Procedure 
FUNCTION getJMSPartitions RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a CHR(3) delimited list of JMS partition names  
    Notes:  
------------------------------------------------------------------------------*/
  RETURN getPartitionsByType("J":U).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getJMSPtnInfo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getJMSPtnInfo Procedure 
FUNCTION getJMSPtnInfo RETURNS CHARACTER
  ( INPUT cPartition AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Gets the URL and connection string for the JMS Partition Connection
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE BUFFER lAppSrvTT FOR AppSrv-TT.

  FIND FIRST lAppSrvTT WHERE lAppSrvTT.Partition = cPartition NO-ERROR.
  IF NOT AVAILABLE lAppSrvTT THEN
     RETURN "?":U + CHR(3) + "Partition not defined".

  IF lAppSrvTT.PartitionType <> "J":U THEN
     RETURN "?":U + CHR(3) + "Not a JMS Partition".

  RETURN getASConnectString(BUFFER lAppSrvTT) + CHR(3) + lAppSrvTT.Info.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPartitionsByType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getPartitionsByType Procedure 
FUNCTION getPartitionsByType RETURNS CHARACTER
  ( INPUT cType AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a CHR(3) delimited list of partitions of a particular type
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cPartitionList AS CHARACTER  NO-UNDO.
  
  FOR EACH AppSrv-TT NO-LOCK
    WHERE AppSrv-TT.PartitionType = cType:
    cPartitionList = cPartitionList 
                   + (IF cPartitionList = "":U THEN "":U ELSE CHR(3))
                   + AppSrv-TT.Partition.
  END.
            
  RETURN cPartitionList.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

