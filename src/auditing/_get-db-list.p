&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*************************************************************/  
/* Copyright (c) 1984-2006 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------

    File        : _get-db-list.p
    Purpose     : Gets a list of db's connected with some information
                  about the db. The caller determines if the list should
                  contain only audit-enabled db's or not.

    Syntax      :

    Description :

    Author(s)   : Fernando de Souza
    Created     : Feb 23,2005
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

{auditing/include/_aud-std.i}
{prodict/sec/sec-func.i}
                 
/* ***************************  Definitions  ************************** */

DEFINE INPUT  PARAMETER pcgetCompleteList AS LOGICAL NO-UNDO.
DEFINE OUTPUT PARAMETER cList           AS CHAR    NO-UNDO.

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
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

IF  pcgetCompleteList THEN 
    RUN get-complete-dbname-list.
ELSE
    RUN get-dbname-list.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-get-complete-dbname-list) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get-complete-dbname-list Procedure 
PROCEDURE get-complete-dbname-list :
/*------------------------------------------------------------------------------
  Purpose:     Gets a complete comma-separated list of databases connected
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE name-string AS CHAR    NO-UNDO.
DEFINE VARIABLE iLoop       AS INTEGER NO-UNDO.
DEFINE VARIABLE hBuffer     AS HANDLE  NO-UNDO.

    ASSIGN cList = ?
           iLoop = 1.

    DO WHILE iLoop <= NUM-DBS:
        ASSIGN name-string = LDBNAME(iLoop) + ",":U.

        IF SESSION:CLIENT-TYPE = "APPSERVER" THEN
            ASSIGN name-string = name-string + {&DB-APPSERVER}.

        IF INDEX (DBRESTRICTIONS(LDBNAME(iLoop)), "READ-ONLY":U) > 0 THEN DO:
            IF SESSION:CLIENT-TYPE = "APPSERVER" THEN
                ASSIGN name-string = name-string + ",".

            ASSIGN name-string = name-string + {&DB-READ-ONLY}.
        END.

        IF cList = ? THEN
           cList = LC(name-string).
        ELSE
          cList = cList + CHR(1) + LC(name-string).
    
        ASSIGN iLoop = iLoop + 1.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-get-dbname-list) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get-dbname-list Procedure 
PROCEDURE get-dbname-list :
/*------------------------------------------------------------------------------
  Purpose:     Get the list of database connected at this time which has auditing
               enabled. The list format is logical db-name,tags and each dbInfo is
               separated by the CHR(1) character. For now, there are only two tags
               possible:
               READ-ONLY, if user can't make changes to the tables, and APPSERVER
               if the db is on the AppServer. This is an example of the db info
               for a given db.
               mydb,READ-ONLY,APPSERVER
  Parameters:  
  Notes: 
------------------------------------------------------------------------------*/
DEFINE VARIABLE iLoop        AS INTEGER   NO-UNDO.
DEFINE VARIABLE hBuffer      AS HANDLE    NO-UNDO.
DEFINE VARIABLE name-string  AS CHARACTER NO-UNDO.
DEFINE VARIABLE cDbName      AS CHARACTER NO-UNDO.
DEFINE VARIABLE cTemp        AS CHARACTER NO-UNDO.

DEFINE VARIABLE hAudit       AS HANDLE    NO-UNDO.

    ASSIGN cList = ?.

    /* loop through the db's connected */
    REPEAT iLoop = 1 TO NUM-DBS:

        ASSIGN cDbName =LDBNAME(iLoop).

        /* check if the db is enabled for auditing */
        IF AUDIT-ENABLED(cDbName) THEN DO:

            /* create a buffer for the _aud-audit-policy so we can check
               the user's permissions
            */
            CREATE BUFFER hAudit FOR TABLE cDbName + "._aud-audit-policy" NO-ERROR.

            /* if for any reason the handle is not valid, can't add db to list */
            /* if user can't read table, don't add it to the list */
            IF NOT VALID-HANDLE(hAudit) OR NOT hAudit:CAN-READ THEN DO:
                /* first delete the dynamic object */
                IF VALID-HANDLE (hAudit) THEN
                    DELETE OBJECT hAudit.
                NEXT.
            END.

            ASSIGN name-string = cDbName + ",":U.

            IF SESSION:CLIENT-TYPE = "APPSERVER":U THEN
                ASSIGN name-string = name-string + {&DB-APPSERVER}.

            IF INDEX (DBRESTRICTIONS(LDBNAME(iLoop)), "READ-ONLY":U) > 0 THEN DO:
                IF SESSION:CLIENT-TYPE = "APPSERVER":U THEN
                    ASSIGN name-string = name-string + ",".

                ASSIGN name-string = name-string + {&DB-READ-ONLY}.
            END.
            ELSE DO:
                /* if we got this far, check if the user can't write to table, add read-only entry.
                */
                IF NOT hAudit:CAN-WRITE THEN DO:
                   IF SESSION:CLIENT-TYPE = "APPSERVER":U THEN
                      ASSIGN name-string = name-string + ",".

                   ASSIGN name-string = name-string + {&DB-READ-ONLY}.
                END.
            END.
                
            /* delete the buffer object */
            DELETE OBJECT hAudit NO-ERROR.

            /* save this for now */
            cTemp = LDBNAME("DICTDB").

            CREATE ALIAS "DICTDB" FOR DATABASE VALUE(cDBName).

            /* add the fact that the user is an audit admin */
            IF hasRole(USERID(cDbName),"_sys.audit.admin",FALSE) THEN 
               ASSIGN name-string = name-string + ',' + {&AUDIT-ADMIN}.

            DELETE ALIAS "DICTDB".

            /* reset it back */
            IF cTemp NE ? AND cTemp NE "" THEN
               CREATE ALIAS "DICTDB" FOR DATABASE VALUE(cTemp).

            IF cList = ? THEN
               cList = LC(name-string).
            ELSE
              cList = cList + CHR(1) + LC(name-string).

        END.
        
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

