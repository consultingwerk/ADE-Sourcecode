&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*--------------------------------------------------------------------------
    File        : protools\convt89.p
    Purpose     : To convert Version 8 SmartObjects to Version 9 SmartObjects

    Syntax      : RUN protools\convt89.p (INPUT input-file,
                                          INPUT output-file,
                                          OUTPUT num-changes).

    Description : This procedure attempts to Convert V8 SmartObject syntax
                  to V9 SmartObject syntax.  Unfortunately this task cannot
                  be fully automated.  Therefore we do the best we can and
                  attempt to flag as many problem spots as possible.  We
                  flag them in two ways:
                     1) A logfile is generated
                     2) &MESSAGE statements are positioned in the code
                        near the problem area.

    Author(s)   : Ross Hunte & John Sadd
    Created     : March 12, 1998
    Notes       :
    
    Modified    : 08/02/99  by tsm  Stop call to removePrefixes for controls
                                    this will prevent "broker-" from being removed
                                    from a trigger of a control that contains "broker-" 
               
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

{adecomm/adefext.i}

/* ***************************  Definitions  ************************** */
DEFINE INPUT PARAMETER i-flnm     AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER o-flnm     AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER changes   AS INTEGER   NO-UNDO.

DEFINE SHARED TEMP-TABLE name-switch
  FIELD forget   AS LOGICAL
  FIELD seq      AS INTEGER
  FIELD old-name AS CHARACTER
  FIELD new-name AS CHARACTER
  INDEX forget-seq IS PRIMARY UNIQUE forget seq.

DEFINE SHARED TEMP-TABLE method
  FIELD v8method AS CHARACTER
  FIELD v9method AS CHARACTER
  FIELD mType    AS CHARACTER
  FIELD params   AS CHARACTER
  INDEX v8method IS PRIMARY UNIQUE v8method.
  
DEFINE SHARED TEMP-TABLE prprty
  FIELD v8prop   AS CHARACTER
  FIELD v9prop   AS CHARACTER
  INDEX v8prop IS PRIMARY UNIQUE v8prop.

DEFINE TEMP-TABLE substitute  NO-UNDO
  FIELD seq        AS INTEGER
  FIELD fld        AS CHARACTER
  FIELD qualifiers AS CHARACTER
  INDEX seq IS PRIMARY UNIQUE seq
  INDEX q-f qualifiers fld.

DEFINE VARIABLE browseTrigs    AS LOGICAL   NO-UNDO.  /* In browse trigger section */
DEFINE VARIABLE cIncLib        AS CHARACTER NO-UNDO.  /* Include libraries code    */
DEFINE VARIABLE cLine          AS CHARACTER NO-UNDO.  /* One line of code.         */
DEFINE VARIABLE cSubLine       AS CHARACTER NO-UNDO.
DEFINE VARIABLE cAction        AS CHARACTER NO-UNDO.  /* Action to perform         */
DEFINE VARIABLE cState         AS CHARACTER NO-UNDO.  /* Current parsing state.    */
DEFINE VARIABLE com-bgns       AS INTEGER   NO-UNDO.  /* The begining of a comment */
DEFINE VARIABLE com-ends       AS INTEGER   NO-UNDO.  /* The ending of a comment   */
DEFINE VARIABLE cProcName      AS CHARACTER NO-UNDO.
DEFINE VARIABLE cName          AS CHARACTER NO-UNDO.
DEFINE VARIABLE cAttrName      AS CHARACTER NO-UNDO.
DEFINE VARIABLE cValue         AS CHARACTER NO-UNDO.
DEFINE VARIABLE cCustomPrefix  AS CHARACTER NO-UNDO.  /* User-defined              */
DEFINE VARIABLE lReturn        AS LOGICAL   NO-UNDO.  /* Convert RETURN-VALUE      */
DEFINE VARIABLE cQuoteMark     AS CHARACTER NO-UNDO.
DEFINE VARIABLE cInHdl         AS CHARACTER NO-UNDO.
DEFINE VARIABLE iIndex         AS INTEGER   NO-UNDO.
DEFINE VARIABLE iIndex2        AS INTEGER   NO-UNDO.
DEFINE VARIABLE iName          AS INTEGER   NO-UNDO.
DEFINE VARIABLE inProcSettings AS LOGICAL   NO-UNDO.
DEFINE VARIABLE stmnt-end      AS INTEGER   NO-UNDO.  /* The end of a statement   */
DEFINE VARIABLE browseName     AS CHARACTER NO-UNDO.  /* The name of the browser  */
DEFINE VARIABLE templateType   AS CHARACTER NO-UNDO.  /* Type of template         */
DEFINE VARIABLE nTokens        AS INTEGER   NO-UNDO.  /* Number of tokens         */
DEFINE VARIABLE nTokens2       AS INTEGER   NO-UNDO.
DEFINE VARIABLE i              AS INTEGER   NO-UNDO.  /* A loop counter           */
DEFINE VARIABLE asnList        AS CHARACTER NO-UNDO.  /* List variable assignmnts */
DEFINE VARIABLE blockType      AS CHARACTER NO-UNDO.  /* Typu eof UIB block       */
DEFINE VARIABLE fldList        AS CHARACTER NO-UNDO.  /* List of fields in query  */
DEFINE VARIABLE fListByTbl     AS CHARACTER NO-UNDO.  /* Like fldList but by tbl  */
DEFINE VARIABLE fldRebuild     AS CHARACTER NO-UNDO.  /* Field rebuild info       */
DEFINE VARIABLE tblList        AS CHARACTER NO-UNDO.  /* List of tables in query  */
DEFINE VARIABLE includeFile    AS CHARACTER NO-UNDO.  /* Name of SDO include file */
DEFINE VARIABLE save-line      AS CHARACTER NO-UNDO.  /* Saveline for later outpt */
DEFINE VARIABLE tmpLine        AS CHARACTER NO-UNDO.  /* Temporary Line           */
DEFINE VARIABLE tmpParam       AS CHARACTER NO-UNDO.  /* A parameter info entry   */
DEFINE VARIABLE numbers        AS CHARACTER NO-UNDO  INITIAL
     "SPC,SPC,FIRST,SECOND,THIRD,FOURTH,FIFTH,SIXTH,SEVENTH,EIGHTH,NINTH,TENTH":U.
DEFINE VARIABLE window-name    AS CHARACTER NO-UNDO.  /* Window name for headers  */
DEFINE VARIABLE xTableList     AS CHARACTER NO-UNDO.  /* List of external tables  */
DEFINE VARIABLE tkns           AS CHARACTER EXTENT 5 NO-UNDO.  /*cLine Tokens     */
DEFINE VARIABLE lCont          AS LOGICAL   NO-UNDO.
DEFINE VARIABLE iInd           AS INTEGER   NO-UNDO.
 
DEFINE VARIABLE cStateVals    AS CHARACTER NO-UNDO INIT      /* state messages */
   "record-available,no-record-available,no-external-record-available,~
update-begin,update,update-complete,delete-complete,~
first-record,last-record,only-record,not-first-or-last".
DEFINE VARIABLE cStateProps   AS CHARACTER NO-UNDO INIT /* matching new properties */
   "Record,Record,Record,~
Update,Update,Update,Update,~
Position,Position,Position,Position".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-convertLinkFunctions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD convertLinkFunctions Procedure 
FUNCTION convertLinkFunctions RETURNS LOGICAL FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-determineAction) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD determineAction Procedure 
FUNCTION determineAction RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchToken) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fetchToken Procedure 
FUNCTION fetchToken RETURNS CHARACTER
  (pcString AS CHARACTER, piToken AS INTEGER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ProcessV8Run) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD ProcessV8Run Procedure 
FUNCTION ProcessV8Run RETURNS LOGICAL FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-removePrefixes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD removePrefixes Procedure 
FUNCTION removePrefixes RETURNS CHARACTER
  (pcLine AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-replaceOne) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD replaceOne Procedure 
FUNCTION replaceOne RETURNS CHARACTER
  ( /* parameter-definitions */
     pcLine AS CHARACTER,  
     pqualifiers AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-replaceQualifiers) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD replaceQualifiers Procedure 
FUNCTION replaceQualifiers RETURNS CHARACTER
  ( /* parameter-definitions */
     pcLine AS CHARACTER,  
     pqualifiers AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-userProcName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD userProcName Procedure 
FUNCTION userProcName RETURNS LOGICAL
  ( /* parameter-definitions */
     cInLine AS CHARACTER,
     iInd AS INTEGER, 
     cv8Method AS CHARACTER )  FORWARD.

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
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */


ASSIGN changes = 0
       cIncLib = "".

RUN prelim-scan.   /* Prelinary scan to pick up method library section */

INPUT  FROM VALUE(i-flnm).
OUTPUT TO   VALUE(o-flnm).

readLine:
REPEAT:
  IMPORT UNFORMATTED cLine.

  /* Check for empty lines. */
  IF LENGTH(cLine) = 0 THEN DO:
    PUT UNFORMATTED CHR(10).
    NEXT readLine.
  END.
  
  /* Define the actions to perform on this line. */

  /* Look for a procedure header. Remove adm- or local- prefix
     from preprocessor lines and from the procedure name itself. 
     First check for the EXCLUDE preprocessor line.
     Also check for the ANALYZE-SUSPEND line. */
  cAction = determineAction().

  CASE cAction:

    WHEN "Prefixes" THEN DO:
      IF fetchToken(cLine,4) NE "adm-create-objects" AND
         fetchToken(cLine,3) NE "_CONTROL" THEN removePrefixes(cLine).
      ASSIGN cProcName = TRIM(fetchToken(cLine,4), "~"")
             blockType = fetchToken(cLine,3).
      /* See if we can get the window name here */
      IF cProcName = "_DEFINITIONS" AND blockType = "_CUSTOM" THEN
        window-name = fetchToken(cLine, 5).
      /* See if we need to supress this section */
      ELSE IF CAN-FIND(FIRST name-switch WHERE name-switch.forget AND
                             name-switch.old-name = cProcName AND
                             name-switch.new-name = "Procedure") THEN DO:
        RUN remove-block.  /* Removes all code through the next &ANALYZE-RESUME */
        NEXT readline.
      END.  /* If this procedure is to be removed */
      ELSE IF cProcName = browseName AND blockType = "_CONTROL" THEN DO:
        /* We are in the trigger section of a Smart Browse.  First create an
           OFF-END trigger, then fix up the ROW-ENTRY, ROW-LEAVE and
           VALUE-CHANGED triggers. */
        tmpLine = cLine.
        IMPORT UNFORMATTED cLine.
        IF LOOKUP(fetchToken(cLine, 2),"ROW-ENTRY,ROW-LEAVE,VALUE-CHANGED") > 0 THEN DO:
          IF NOT browseTrigs THEN DO:  /* Just entered the section */
            ASSIGN browseTrigs = TRUE
                   tkns[2]     = ENTRY(2, cLine, " ":U)
                   tkns[4]     = ENTRY(4, cLine, " ":U)
                   changes     = changes + 1.
            PUT UNFORMATTED tmpLine SKIP
                REPLACE(cLine,tkns[2],"CTRL-END":U) SKIP
                'DO:':U SKIP
                '  APPLY "END":U TO BROWSE ' + tkns[4] + '.' SKIP
                'END.' SKIP (1)
                '/* _UIB-CODE-BLOCK-END */' SKIP
                '~&ANALYZE-RESUME':U SKIP (2).
            PUT UNFORMATTED tmpLine SKIP
                REPLACE(cLine,tkns[2],"CTRL-HOME":U) SKIP
                'DO:':U SKIP
                '  APPLY "HOME":U TO BROWSE ' + tkns[4] + '.' SKIP
                'END.' SKIP (1)
                '/* _UIB-CODE-BLOCK-END */' SKIP
                '~&ANALYZE-RESUME':U SKIP (2).
            PUT UNFORMATTED tmpLine SKIP
                REPLACE(cLine,tkns[2],"END":U) SKIP
                'DO:':U SKIP
                '  ~{src/adm2/brsend.i}':U SKIP
                'END.':U SKIP (1)
                '/* _UIB-CODE-BLOCK-END */' SKIP
                '~&ANALYZE-RESUME':U SKIP (2).
            PUT UNFORMATTED tmpLine SKIP
                REPLACE(cLine,tkns[2],"HOME":U) SKIP
                'DO:':U SKIP 
                '  ~{src/adm2/brshome.i}':U SKIP
                'END.':U SKIP (1)
                '/* _UIB-CODE-BLOCK-END */' SKIP
                '~&ANALYZE-RESUME':U SKIP (2).
            PUT UNFORMATTED tmpLine SKIP
                REPLACE(cLine,tkns[2],"OFF-END":U) SKIP
                "DO:":U SKIP
                "  ~{src/adm2/brsoffnd.i}":U SKIP
                "END.":U SKIP (1)
                "/* _UIB-CODE-BLOCK-END */" SKIP
                "~&ANALYZE-RESUME":U SKIP (2).
            PUT UNFORMATTED tmpLine SKIP
                REPLACE(cLine,tkns[2],"OFF-HOME":U) SKIP
                "DO:":U SKIP
                "  ~{src/adm2/brsoffhm.i}":U SKIP
                "END.":U SKIP (1)
                "/* _UIB-CODE-BLOCK-END */" SKIP
                "~&ANALYZE-RESUME":U SKIP (2).
            PUT UNFORMATTED tmpLine SKIP
                REPLACE(cLine,tkns[2],"SCROLL-NOTIFY":U) SKIP
                "DO:":U SKIP
                "  ~{src/adm2/brsscrol.i}":U SKIP
                "END.":U SKIP (1)
                "/* _UIB-CODE-BLOCK-END */" SKIP
                "~&ANALYZE-RESUME":U SKIP (2).
         END. /* IF NOT browseTrigs */
        END. /* IF a ROW-ENTRY, ROW-LEAVE or VALUE-CHANGED trigger */
        PUT UNFORMATTED tmpLine SKIP.
      END.  /* If this is a trigger for the browse control */
      ELSE IF cProcName = "_MAIN-BLOCK":U AND blockType = "_CONTROL":U 
        THEN browseTrigs = FALSE.
      ELSE IF cProcName = "exit" AND blockType = "_PROCEDURE" THEN DO:
        RUN remove-block.
        RUN gen-exitObject.
        NEXT readline.
      END. /* If a local-exit procedure */
      ELSE IF blockType = "_PROCEDURE":U AND
           CAN-FIND(FIRST method WHERE method.v8method = cProcName) THEN DO:
        /* This is an override of an adm-method */
        FIND FIRST method WHERE method.v8method = cProcName.
        cLine = REPLACE(cLine, method.v8method, method.v9method).
        IF method.mType BEGINS "F" THEN cLine = REPLACE(cLine, "_PROCEDURE", "_FUNCTION").
        PUT UNFORMATTED cLine SKIP.
        PUT UNFORMATTED (IF method.mType = "P" THEN
          "PROCEDURE " + method.v9method + " :" ELSE
          "FUNCTION " + method.v9method + " RETURNS " +
              (IF method.mType = "FL" THEN "LOGICAL" ELSE "CHARACTER") +
              " ( ) :") SKIP.
        IF method.params NE " " THEN DO:
          DO i = 1 TO NUM-ENTRIES(method.params):
            tmpParam = ENTRY(i, method.params).
            PUT UNFORMATTED "  DEFINE " +
                (IF ENTRY(3, tmpParam, "|":U) = "I" THEN "INPUT"
                 ELSE IF ENTRY(3, tmpParam, "|":U) = "O" THEN "OUTPUT"
                 ELSE "INPUT-OUTPUT") + " PARAMETER " + ENTRY(1, tmpParam, "|":U) +
                 " AS " + ENTRY(2, tmpParam, "|":U) + " NO-UNDO." SKIP.
          END.  /* Do for each parameter */
        END. /* If there are parameters to define */
        /* Read in what should be the method definition line */
        IMPORT UNFORMATTED cLine. /* Swallow it */
        IMPORT UNFORMATTED cLine.
        changes = changes + 1.
      END.  /* When on a method header */
    END.  /* When Prefixes */

    WHEN "Scoped-Def" THEN DO:
      cName = fetchToken(cLine, 2).
      /* See if this is on the list to get rid of */
      IF cName BEGINS "FIELD-PAIRS" THEN DO:
        changes = changes + 1.
        DO WHILE (R-INDEX(cLine,"~~") = LENGTH(cLine)):
          IMPORT UNFORMATTED cLine.
        END.
        NEXT readline.
      END.
      ELSE IF CAN-FIND(FIRST name-switch WHERE name-switch.forget AND
                                          name-switch.old-name = cName)
        THEN NEXT readline.
      ELSE IF cName = "ADM-SUPPORTED-LINKS" THEN DO:
        PUT UNFORMATTED "&Scoped-define DB-AWARE " +
                        IF templateType eq "QUERY.W" THEN "yes" ELSE "no" SKIP.
        ASSIGN cLine = REPLACE(cLine,"Record-Source",
                 IF templateType eq "BROWSER.W" THEN "Update-Source"
                                                 ELSE "Data-Source")
               cLine = REPLACE(cLine,"Record-Target", "Data-Target").
        IF templateType eq "QUERY.W" THEN
          ASSIGN cLine = TRIM(cLine) + ",Update-Target,Commit-Target,Commit-Source" + 
                         CHR(10) + CHR(10) + CHR(10) +
                         "/* Db-Required definitions. */" + CHR(10) +
                         "~&IF DEFINED(DB-REQUIRED) = 0 ~&THEN" + CHR(10) +
                         "    ~&GLOBAL-DEFINE DB-REQUIRED TRUE" + CHR(10) +
                         "~&ENDIF" + CHR(10) +
                         "~&GLOBAL-DEFINE DB-REQUIRED-START   ~&IF ~{~&DB-REQUIRED} " +
                         "~&THEN" + CHR(10) +
                         "~&GLOBAL-DEFINE DB-REQUIRED-END     ~&ENDIF" + CHR(10).

        IF templateType eq "VIEWER.W" THEN
          ASSIGN cLine = TRIM(REPLACE(cLine,"Data-Source,","")) +
                            ",Group-Assign-Source,Group-Assign-Target,Update-Source".
      END.  /* If ADM-SUPPORTED-LINKS */
      ELSE IF cName BEGINS "TABLES-IN-QUERY-" OR cName BEGINS "ENABLED-TABLES-IN-QUERY-" THEN DO:
        nTokens = NUM-ENTRIES(cLine, " ").
        IF templateType = "BROWSER.W" THEN DO:
          cLine = fetchToken(cLine, 1) + " ":U + fetchToken(cLine, 2) + " rowObject".
        END.  /* if browser */
        ELSE DO:
          IF templateType = "QUERY.W" THEN RUN gen-preprocs.
       
          IF nTokens > 3 THEN DO:  /* If there is more than 1 table */
            /* Note: v8 only outputted FIRST table, v9 Needs to output upto ten.  */
            /* If there is only one table, it will be taken care of in the normal */
            /* readline loop.  If there are more, things need to be handled       */
            /* differently.                                                       */
          
            /* Write out cLine */
            PUT UNFORMATTED cLine SKIP.
            /* Read in what shoule be the first table line */
            IMPORT UNFORMATTED tmpLine.
            PUT UNFORMATTED tmpLine SKIP.
            cName = fetchToken(tmpLine, 2).
            /* Write out SECOND thorugh n table lines */
            DO i = 4 TO nTokens:
              IF i > 12 THEN NEXT readline.
              tmpLine = "&Scoped-define " + REPLACE(cName,"FIRST", ENTRY(i,numbers)) +
                           " " + fetchToken(cLine, i).
              PUT UNFORMATTED tmpLine SKIP.
           END. /* DO i = 3 TO nTokens */
           NEXT readline.
          END. /* If there is more than 1 table */
        END.  /* else do - not browser */
      END. /* If cName BEGINS "TABLES-IN-QUERY-" */
      ELSE IF templateType = "BROWSER.W" AND cName = "BROWSE-NAME"
        THEN browseName = fetchToken(cLine, 3).  /* we need this later */
      ELSE IF cName EQ "DISPLAYED-FIELDS" AND templateType = "VIEWER.W" THEN
        RUN collect-sdo-info.
      ELSE IF cName BEGINS "FIELDS-IN-QUERY" AND templateType = "BROWSER.W" THEN
        RUN collect-sdo-info.
      ELSE IF cName BEGINS "INTERNAL-TABLES" AND templateType = "BROWSER.W" THEN
        cLine = "~&Scoped-define INTERNAL-TABLES rowObject".
      ELSE IF INDEX(cLine,"External") > 0 AND INDEX(cLine,"Table") > 0 THEN DO:
        /* Here we always remove the line, but if it is the list of external
           table, save the list if we are working with a query.  We need the
           list to suppress "OF" clauses.                                    */
        IF templateType = "QUERY.W" OR templateType = "BROWSER.W" AND
          cName = "EXTERNAL-TABLES" THEN DO:
          nTokens = NUM-ENTRIES(cLine, " ").
          DO i = 3 TO nTokens:
            xTableList = xTableList + "," + fetchToken(cLine,i).
          END.  /* Do i = 3 TO nTokens */
          xTableList = LEFT-TRIM(xTableList, ",":U).
        END.  /* If processing a Query and have the External-Tables definition */
        NEXT readline.  /* Remove all Scoped-defines dealing with external tables */
      END. /* If working on something about external tables */
      ELSE IF cName BEGINS "OPEN-QUERY-" AND templateType = "QUERY.W" THEN DO:
        nTokens = NUM-ENTRIES(xTableList).
        IF nTokens > 0 THEN DO:
          DO i = 1 TO nTokens:
            cLine = replace(cLine, "OF " + ENTRY(i, xTableList), "").
          END.  /* For each external table */
        END.  /* If there are any external tables */
        IF templateType = "QUERY.W" THEN DO:  /* Save cLine for later */
          /* In a SDO the OPEN-QUERY comes after DATA-FIELD-DEFS (and
             DB-REQUIRED-START)  */
          save-line = cLine.
          IMPORT UNFORMATTED cLine. /* Read the sortby phrase */
          save-line = save-line + CHR(10) + cLine.
          IF cLine BEGINS "&Scoped-define TABLES-IN-QUERY-" THEN DO:
            nTokens = NUM-ENTRIES(cLine, " ").
            RUN gen-preprocs.
          END.
          NEXT readline.
        END.  /* If working on a SmartQuery */
      END.  /* If we have the OPEN-QUERY definition in a QUERY  */
      ELSE IF cName BEGINS "OPEN-QUERY-" AND templateType = "BROWSER.W" THEN DO:
        nTokens = NUM-ENTRIES(cLine, " ":U).
        DO i = 1 TO 5:
          tmpLine = tmpLine + fetchToken(cLine, i) + " ":U.
        END.  /* do i = 1 to 5 */
        cLine = tmpLine + "FOR EACH rowObject.":U.
        lCont = TRUE.
        DO WHILE lCont:
          IMPORT UNFORMATTED tmpLine.
          IF LEFT-TRIM(tmpLine) MATCHES '*SORTBY-PHRASE*':U THEN lCont = FALSE. 
        END.
      END.  /* If we have the OPEN-QUERY definition in a BROWSER */
      ELSE IF cName = "ADM-CONTAINER" THEN DO:
        /* Write out cLine */
        PUT UNFORMATTED cLine SKIP (1).
        cLine = "~&Scoped-Define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target".
      END.  /* If we are processing a WINDOW or DIALOG-BOX */
    END.  /* When Scoped-define */

    WHEN "Procedure" THEN DO:
      cName = removePrefixes(cLine).
      /* Note: removePrefixes returns the prefix removed.
         If this is a local or possibly custom-prefix version of a 
         procedure, we need to hang onto the base procedure name so
         that if we encounter it within the body of the procedure we can 
         replace it with SUPER. */
      IF (cName = "local-") OR (cCustomPrefix NE "" AND cName = cCustomPrefix)
        THEN cProcName = fetchToken(cLine, 2).

      /* See if we should delete the entire procedure */
      IF CAN-FIND(first name-switch WHERE name-switch.forget AND
                                          name-switch.old-name = cName AND
                                          name-switch.new-name = "Procedure") THEN DO:
        /* Remove to past the next "&ANALYZE-RESUME" */
        changes = changes + 1.
        REPEAT WHILE cLine NE "&ANALYZE-RESUME":
          IMPORT UNFORMATTED cLine.
        END.
        /* Have found the &analyze-resume - NOW start again */
        NEXT readline.
      END.
    END. /* When "Procedure */

    WHEN "Dispatch" OR WHEN "Notify" OR WHEN "Get-Attribute" OR
    WHEN "Set-Attribute" OR WHEN "New-State" THEN DO:
      /* This is to screen out cases where users have procedures that start
         with notify or dispatch, as in RUN notify-me-now. */
      ASSIGN i = IF cAction = "Notify" THEN INDEX(cLine, "notify") + 6
                 ELSE IF cAction = "Dispatch" THEN INDEX(cLine, "dispatch") + 8
                 ELSE -1.
      IF i > 0 THEN DO:
        ASSIGN tkns[1]  = SUBSTRING(cLine,i,1).
        IF tkns[1] NE " " AND tkns[1] NE "(" THEN
          ASSIGN cAction = "RUN"
                 lReturn = no. /* A normal run */
      END.
      IF cAction NE "RUN" THEN DO:  
        lReturn = processV8Run().
        IF NOT lReturn THEN NEXT readline.
      END.
    END.

    WHEN "Init-Object" THEN DO:
      lReturn = no.    /* Turn off RETURN-VALUE conversion with each new RUN stmt. */
      RUN convertInitObject.
    END.  /* WHEN Init-Object */

    WHEN "Get-Link-Handle" OR WHEN "Set-Link-Attribute" OR WHEN "Request-Attribute"
    THEN DO:
      convertLinkFunctions().
    END.

    WHEN "Run" THEN DO:
      lReturn = no.       /* Turn off RETURN-VALUE conversion with each new RUN stmt. */
      /* If it is a method, replace the name */
      FOR EACH method:
        iInd = INDEX(cLine,method.v8method).
        IF iInd > 0 AND NOT userProcName(cLine,iInd,method.v8method) THEN DO:
          IF method.mType = "FL" THEN
            ASSIGN cLine = REPLACE(cLine, "RUN ":U, "":U)
                   cLine = REPLACE(cLine, method.v8Method, method.v9method + "()":U).
          ELSE
            ASSIGN cLine = REPLACE(cLine,method.v8method, method.v9method).
          changes = changes + 1.
        END.
      END.
    END.

    WHEN "EndProc" THEN DO:
      ASSIGN cProcName      = ""                            /* reset at procedure end */
             lReturn        = no
             inProcSettings = no.
    END. /* WHEN "EndProc" */

    WHEN "Other" THEN DO:     /* In all other lines, convert RETURN-VALUE to attr name. */
      /* If we haven't yet established the templateType try here */
      cName = fetchToken(cLine,1).
      IF templateType = "" AND cName = "Description" THEN DO:
        cName = fetchToken(cLine, 4).
        IF LOOKUP(cName,"BROWSER.W,cntnrdlg.w,cntnrfrm.w,cntnrwin.w,QUERY.W,SMART.W,VIEWER.W")
           > 0 THEN templateType = cName.
      END.
      ELSE IF cName = "&ANALYZE-SUSPEND" AND fetchToken(cLine,2) = "_PROCEDURE-SETTINGS"
        THEN inProcSettings = TRUE.
      ELSE IF inProcSettings AND cName = "Allow" AND templateType = "QUERY.W"
        THEN ASSIGN cLine   = "   Allow: Query"
                    changes = changes + 1.
      ELSE IF inProcSettings AND cName = "Allow" AND templateType BEGINS "cntnr"
        THEN ASSIGN cLine = cLine + CHR(10) +
                            "   Container Links: Data-Target,Data-Source,Page-Target".
      ELSE IF inProcSettings AND cName = "Frames" AND templateType = "QUERY.W"
        THEN ASSIGN cLine   = "   Frames: 0"
                    changes = changes + 1.
      ELSE IF inProcSettings AND cName = "Add" AND
              LOOKUP(templateType,"QUERY.W,BROWSER.W") > 0 AND
              fetchToken(cLine,2) = "Fields"
        THEN ASSIGN cLine   = "   Add Fields to: Neither"
                    changes = changes + 1.
      ELSE IF inProcSettings AND cName = "OTHER" AND templateType = "QUERY.W"
        THEN ASSIGN cLine   = cLine + " DB-AWARE"
                    changes = changes + 1.
      ELSE IF browseTrigs AND LEFT-TRIM(cLine) BEGINS "~{src":U
        THEN ASSIGN cLine   = REPLACE(cLine, "adm/template", "adm2")
                    changes = changes + 1.
      ELSE IF cName = "_Design-Parent" AND templateType = "QUERY.W" THEN DO:
        PUT UNFORMATTED fldRebuild SKIP.
        changes = changes + 1.
      END.
      ELSE IF templateType NE "" AND
              fetchToken(cLine,3) = "Runtime":U AND
              fetchToken(cLine,4) = "Attributes":U AND
              fetchToken(cLine,7) = "Settings":U THEN RUN gen-include-lib.
      ELSE IF templateType = "QUERY.W" AND cName = "/*" THEN DO:
        ASSIGN tkns[2] = fetchToken(cLine,2)
               tkns[3] = fetchToken(cLine,3)
               tkns[4] = fetchToken(cLine,4).
        IF tkns[2] = "Custom":U AND
           tkns[3] = "List":U AND
           tkns[4] = "Definitions":U THEN DO:
          /* Insert a DB-REQUIRED-END */
          PUT UNFORMATTED "~{~&DB-REQUIRED-END}" SKIP (1).
        END.
        ELSE IF tkns[2] = "Query":U AND
                tkns[3] = "definitions":U THEN DO:
          /* Insert a DB-REQUIRED-START */
          PUT UNFORMATTED "~{~&DB-REQUIRED-START}" SKIP (1).          
        END.
        ELSE IF tkns[2] BEGINS "~*" AND
                tkns[3] = "Frame":U AND
                tkns[4] = "Definitions":U THEN DO:
          /* Insert a DB-REQUIRED-END */
          PUT UNFORMATTED "~{~&DB-REQUIRED-END}" SKIP (1).          
        END.
        ELSE cLine = REPLACE(REPLACE(cLine, "List-1", "ADM-CREATE-FIELDS"),
                             "List-6           ", "List-6").
      END.  /* If query.w and a comment */
      ELSE IF lReturn AND INDEX(cLine,'RETURN-VALUE') > 0 AND
           INDEX(cLine,'ADM-ERROR') = 0 THEN
        ASSIGN cLine   = REPLACE(cLine, 'RETURN-VALUE', cAttrName)
               changes = changes + 1.
      ELSE IF INDEX(cLine,"External") > 0 AND INDEX(cLine,"Table") > 0 THEN
        NEXT readline.
      ELSE IF cProcName NE "" AND cName = "END":U AND
           fetchToken(cLine, 2) = "PROCEDURE.":U THEN DO:
        FIND method WHERE method.v8method = cProcName NO-ERROR.
        IF AVAILABLE method AND method.mTYPE BEGINS "F" THEN
          cLine = "END.":U.
      END.
      
    END. /* WHEN "Other" */
    
  END CASE.
            
  /* Before writing the line, make the easy one-for-one substitutions */
  NAME-SWITCH-SCAN:
  FOR EACH name-switch:
    IF INDEX(cLine,old-name) > 0 THEN DO:
      IF NOT name-switch.forget THEN DO:
        IF old-name = "SET-SIZE" AND INDEX(cLine,old-name) < INDEX(cLine,"=":U) 
          THEN NEXT NAME-SWITCH-SCAN.
        ASSIGN changes = changes + 1
               cLine   = REPLACE(cLine, old-name, new-name).
        IF old-name = "Current-Page":U THEN
          cLine = REPLACE(cLine, "ADM-CurrentPage", "CurrentPage").
      END.
      ELSE DO: /* remove the whole line */
        IF old-name = "key-value" THEN DO:
          /* if its key-value, be carefull */
          IF INDEX(cLine, " key-value":U) > 0 THEN 
            cLine = "/* " + cLine + " */".
        END.
        ELSE cLine = "/* " + cLine + " */".
      END.  /* Else remove the line */
    END.  /* If the string exists */
  END. /* For each simple change */
        
  PUT UNFORMATTED cLine SKIP.
END.                            /* END of REPEAT: IMPORT loop */

INPUT CLOSE.
OUTPUT CLOSE.

/* If this is a SmartViewer or SmartDataBrowser - create the sdo type include file 
   and reopen the .w file making the proper changes                     */
IF LOOKUP(templateType, "VIEWER.W,BROWSER.W") > 0 THEN 
  RUN second-pass(o-flnm).

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-appendLine) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE appendLine Procedure 
PROCEDURE appendLine :
/*------------------------------------------------------------------------------
  Purpose:     This procedure appends the next line in the input file to the
               current line (cLine).
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE next-line AS CHARACTER                             NO-UNDO.
  
  IMPORT UNFORMATTED next-line.
  cLine = cLine + " " + TRIM(next-Line).
END PROCEDURE.  /* Procedure appendLine */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-collect-sdo-info) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE collect-sdo-info Procedure 
PROCEDURE collect-sdo-info :
/*------------------------------------------------------------------------------
  Purpose:     In processing a SmartViewer, it is necessary to build an include
               file for the RowObject temptable defininition.  Also all table
               references need to be switched to "RowObject". This procedure
               processes the DISPLAYED-FIELDS preprocess to make a first guess
               at what the RowObject include file should look like.  A second
               pass through the SmartViewer is where we make the necessary 
               corrections to the source code.
               
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE field-list AS CHARACTER                                 NO-UNDO.
DEFINE VARIABLE fld        AS CHARACTER                                 NO-UNDO.
DEFINE VARIABLE i          AS INTEGER                                   NO-UNDO.
DEFINE VARIABLE n          AS INTEGER                                   NO-UNDO.
DEFINE VARIABLE n-entries  AS INTEGER                                   NO-UNDO.

/* Build comma delimited list of displayed fields */
PROCESS-FIELDS:
REPEAT:
  n = NUM-ENTRIES(TRIM(cLine)," ").
  DO i = 1 TO n:
    fld = ENTRY(i,cLine," ").
    IF fld NE "&Scoped-Define" AND fld NE "DISPLAYED-FIELDS" AND
       fld NE "~~" THEN
      field-list = field-list + "," + ENTRY(i,cLine," ").
    IF i = n THEN DO:
      IF fld EQ "~~" THEN DO:
        PUT UNFORMATTED cLine SKIP.
        IMPORT UNFORMATTED cLine.
        NEXT PROCESS-FIELDS.
      END.  /* If line ends with tilda */
      ELSE LEAVE PROCESS-FIELDS. 
    END.  /* If at the end of the line and there is a continuation */
  END.  /* Do i = 1 to n */
END.  /* Do while field-list ends in a comma */

ASSIGN field-list = TRIM(field-list,"~,")
       n-entries  = NUM-ENTRIES(field-list).
DO i = 1 TO n-entries:  /* For each displayed field */
  ASSIGN fld = ENTRY(i, field-list)
         /* Is this field qualified with db or table ? */
          n  = NUM-ENTRIES(fld,".").
  IF n > 1 THEN DO:
    CREATE substitute.
    ASSIGN substitute.seq        = i
           substitute.fld        = ENTRY(n,fld,".")
           substitute.qualifiers = SUBSTR(fld,1,R-INDEX(fld,".") - 1).
  END. /* Field is qualified with something */
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-convertInitObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE convertInitObject Procedure 
PROCEDURE convertInitObject :
/*------------------------------------------------------------------------------
  Purpose:     To convert Init-Object to ConstructObject.  The main focus is
               to get the attribute list in the 4th line correct.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE endOfString AS INTEGER                              NO-UNDO.

  PUT UNFORMATTED "       RUN constructObject (" SKIP.
  IMPORT UNFORMATTED cLine.
  IF INDEX(cLine,"adm/objects") > 0 THEN DO:
    ASSIGN cLine = REPLACE(cLine, "adm/objects":U, "adm2":U)
           cLine = REPLACE(cLine, "p-navico", "pnavico")
           cLine = REPLACE(cLine, "p-navlbl", "pnavlbl")
           cLine = REPLACE(cLine, "p-updsav", "pupdsav").
  END.
  PUT UNFORMATTED cLine SKIP.
  IMPORT UNFORMATTED cLine.
  PUT UNFORMATTED cLine SKIP.
  IMPORT UNFORMATTED cLine.
  cName = fetchToken(cLine,1).
  IF INDEX(cLine,"FOLDER-LABELS") = 0 THEN DO:
    SCAN-INSTANCE-ATTRIBUTES:
    REPEAT WHILE cName ne "OUTPUT":
      ASSIGN cLine = REPLACE(cLine," = ":U, CHR(4))
             cLine = REPLACE(cLine,",":U, CHR(3))
             cLine = REPLACE(cLine,"Layout","ObjectLayout")
             cLine = REPLACE(cLine,"Edge-Pixels","EdgePixels")
             cLine = REPLACE(cLine,"SmartPanelType","PanelType")
             cLine = REPLACE(cLine,"Right-to-Left","RightToLeft")
             tmpLine = IF cName ne "INPUT" THEN tmpLine + TRIM(cLine)
                       ELSE cLine.

      IMPORT UNFORMATTED cLine.
      cName = fetchToken(cLine,1).
    END. /* Repeat */
    ASSIGN tmpLine = tmpLine + ","
           tmpLine = REPLACE(tmpLine,CHR(3) + ",", ",").
  END.  /* If not converting a folder */
  ELSE DO:  /* Here we do convert a folder */
    REPEAT WHILE cName ne "OUTPUT":
      ASSIGN cLine = REPLACE(cLine," = ":U, CHR(4))
             cLine = REPLACE(cLine,",":U, CHR(3))
             cLine = REPLACE(cLine,"FOLDER-LABELS","FolderLabels")
             cLine = REPLACE(cLine,"FOLDER-TAB-TYPE","FolderTabType")
             tmpLine = IF cName ne "INPUT" THEN tmpLine + TRIM(cLine)
                       ELSE cLine.

      IMPORT UNFORMATTED cLine.
      cName = fetchToken(cLine,1).
    END. /* Repeat */
    ASSIGN endOfString = R-INDEX(tmpLine,"':U") - 1
           tmpLine = SUBSTRING(tmpLine,1,endOfString) + CHR(3) +
                             "HideOnInit" + CHR(4) + "no" + CHR(3) +
                             "DisableOnInit" + CHR(4) + "no" + CHR(3) +
                             "ObjectLayout" + "':U ,"                                  
           tmpLine = REPLACE(tmpLine,CHR(3) + ",", ",").
  END.
  PUT UNFORMATTED tmpLine SKIP.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-gen-exitObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE gen-exitObject Procedure 
PROCEDURE gen-exitObject :
/*------------------------------------------------------------------------------
  Purpose:     To generate the exitObject function
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  PUT UNFORMATTED
    '&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE exitObject ' + window-name +
    CHR(10) + 'PROCEDURE exitObject :' + CHR(10) +
    '/*------------------------------------------------------------------------------'
    + CHR(10) +
    '  Purpose:  Window-specific override of this procedure which destroys' + CHR(10) +
    '            its contents and itself.' + CHR(10) + '    Notes:' + CHR(10) +
    '------------------------------------------------------------------------------*/'
    + CHR(10) + CHR(10) +
    '  APPLY "CLOSE":U TO THIS-PROCEDURE.' + CHR(10) +
    '  RETURN.' + CHR(10) + CHR(10) +
    'END PROCEDURE.' + CHR(10) + CHR(10) + '/* _UIB-CODE-BLOCK-END */' + CHR(10) +
    '&ANALYZE-RESUME' + CHR(10).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-gen-include-lib) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE gen-include-lib Procedure 
PROCEDURE gen-include-lib :
/*------------------------------------------------------------------------------
  Purpose:     Generate the Included libraries section 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  IF cIncLib NE "" THEN
    tmpLine = cIncLib + CHR(10) + CHR(10) + CHR(10) + CHR(10).
  ELSE
  tmpLine = "&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB " +
            window-name + CHR(10) +
            "/* ************************* Included-Libraries *********************** */" +
            CHR(10) + CHR(10) +
            (IF templateType = "BROWSER.W"       THEN "~{src/adm2/browser.i}"
             ELSE IF templateType = "VIEWER.W"   THEN "~{src/adm2/viewer.i}"
             ELSE IF templateType = "cntnrdlg.w" THEN "~{src/adm2/containr.i}"
             ELSE IF templateType = "cntnrfrm.w" THEN "~{src/adm2/containr.i}"
             ELSE IF templateType = "cntnrwin.w" THEN "~{src/adm2/containr.i}"
             ELSE IF templateType = "QUERY.W"    THEN "~{src/adm2/data.i}"
             ELSE "~{src/adm2/smart.i}") + CHR(10) + CHR(10) +
            "/* _UIB-CODE-BLOCK-END */" + CHR(10) +
            "&ANALYZE-RESUME" + CHR(10) + CHR(10) + CHR(10) + CHR(10).
  PUT UNFORMATTED tmpline SKIP.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-gen-preprocs) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE gen-preprocs Procedure 
PROCEDURE gen-preprocs :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  /* Manufacture the field related preprocessors - first get a complete
     list of fields - less duplicates                                   */
  DO i = 3 TO nTokens:
    tblList = tblList + "," + fetchToken(cLine, i).
  END.
  ASSIGN tblList     = TRIM(tblList,"~,")
         includeFile = ENTRY(NUM-ENTRIES(i-flnm,"~\"), i-flnm, "~\")
         includeFile = SUBSTR(includeFile,1, LENGTH(includeFile) - 1) + "i".

  IF NUM-DBS < 1 THEN
    RUN output-error(
        "Cannot determine field list unless the database is connected.").
  ELSE RUN protools/makeflds.w (INPUT includeFile, INPUT tblList,
                                OUTPUT fldList, OUTPUT fListByTbl,
                                OUTPUT asnList, OUTPUT fldRebuild).
  IF fListByTbl NE "" THEN fListByTbl = fListByTbl + CHR(10).

  PUT UNFORMATTED
      "&Scoped-Define ENABLED-FIELDS " + fldList SKIP
      fListByTbl SKIP (1)
      "&Scoped-Define DATA-FIELDS " + fldList SKIP
      "&Scoped-Define MANDATORY-FIELDS" SKIP
      "&Scoped-Define APPLICATION-SERVICE" SKIP
      "&Scoped-Define ASSIGN-LIST " + asnList SKIP
      "&Scoped-Define DATA-FIELD-DEFS " + '"' + includeFile + '"' SKIP (1)
      "~{&DB-REQUIRED-START}" SKIP
      save-line SKIP.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-output-error) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE output-error Procedure 
PROCEDURE output-error :
/*------------------------------------------------------------------------------
  Purpose:    Writes an error message to the log file and also puts a &MESSAGE
              statement into the output file.
  Parameters:  err-msg  - error message to be outputted
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER err-msg AS CHARACTER                NO-UNDO.
    PUT UNFORMATTED cLine SKIP
        "~&MESSAGE Convert Utility: " + err-msg SKIP.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-prelim-scan) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE prelim-scan Procedure 
PROCEDURE prelim-scan :
/*------------------------------------------------------------------------------
  Purpose:     A preliminary scan of the input file to collect some information.
               The current version only collects the include file section.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE inIncLibBlock AS LOGICAL        INITIAL NO            NO-UNDO.

  INPUT FROM VALUE(i-flnm).

  LineScanner:
  REPEAT:
    IMPORT UNFORMATTED cLine.
  
    IF cLine BEGINS "&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB" THEN
      inIncLibBlock = TRUE.  /* We are in the block */

    IF inIncLibBlock THEN DO:
      ASSIGN cLine = REPLACE(cLine, "src/adm/method/query.i":U, "src/adm2/data.i":U)
             cLine = REPLACE(cLine, "src/adm/method":U, "src/adm2":U)
             cIncLib = IF cIncLib NE "" THEN cIncLib + CHR(10) + cLine
                                        ELSE cLine.
      IF cLine BEGINS "&ANALYZE-RESUME" THEN LEAVE LineScanner.
    END.  /* If inIncLibBlock */
  END.  /* End of LineScanner Repeat */

  INPUT CLOSE.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-remove-block) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE remove-block Procedure 
PROCEDURE remove-block :
/*------------------------------------------------------------------------------
  Purpose: Remove an entire block of code upto the next &ANALYZE-RESUME    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  changes = changes + 1.
  REPEAT WHILE cLine NE "&ANALYZE-RESUME":
    IMPORT UNFORMATTED cLine.
  END.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-second-pass) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE second-pass Procedure 
PROCEDURE second-pass :
/*------------------------------------------------------------------------------
  Purpose:     This is called when processing a SmartViewer.  It is necessary
               to first build a SmartData type temp-table include file, then
               reopen the new file and make proper substitions and changes.
  Parameters:  dotwFile - the name of the new .w file
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER dotwFile AS CHARACTER                        NO-UNDO.
  
  DEFINE VARIABLE incl-fl       AS CHARACTER                          NO-UNDO.
  DEFINE VARIABLE last-seq      AS INTEGER                            NO-UNDO.
  DEFINE VARIABLE n-parts       AS INTEGER                            NO-UNDO.
  DEFINE VARIABLE proc-settings AS LOGICAL                            NO-UNDO.
  DEFINE VARIABLE tokn1         AS CHARACTER                          NO-UNDO.
  DEFINE VARIABLE tokn2         AS CHARACTER                          NO-UNDO.
  DEFINE VARIABLE tmpflnm       AS CHARACTER                          NO-UNDO.

  /* ------------------------------------------------------------------------ */
  /*     First create the include file                                        */
  /* ------------------------------------------------------------------------ */
  ASSIGN incl-fl = ENTRY(1,dotwFile, ".")
         n-parts = NUM-ENTRIES(incl-fl, "~/")
         tokn1   = ENTRY(n-parts, incl-fl, "~/")
         tokn1   = "d" + SUBSTR(tokn1,2)
         tokn1   = (IF LENGTH(tokn1) < 8 THEN tokn1 ELSE SUBSTR(tokn1,1,7))
                    + "x.i".
  ENTRY(n-parts, incl-fl, "~/") = tokn1.

  FIND LAST substitute NO-ERROR.
  IF AVAILABLE substitute THEN last-seq = SUBSTITUTE.seq.

  OUTPUT TO VALUE(incl-fl).
  FOR EACH substitute:
    PUT UNFORMATTED "  FIELD " + substitute.fld + " LIKE " +
                    substitute.qualifiers + "." + substitute.fld +
                    IF substitute.seq NE last-seq THEN " ~~" ELSE " " SKIP.
  END.
  OUTPUT CLOSE.
  
  
  /* ------------------------------------------------------------------------ */
  /*     Now review the output file                                           */
  /* ------------------------------------------------------------------------ */
  
  /* Rename the file to a temporary file */
  RUN adecomm/_tmpfile.p ({&STD_TYP_UIB_DUP}, {&STD_EXT_UIB}, OUTPUT tmpflnm).
  OS-COPY VALUE(dotwfile) VALUE(tmpflnm).
  
  /* Open the input and output files and start processing */
  INPUT  FROM VALUE(tmpflnm).
  OUTPUT TO   VALUE(dotwfile).

  readLine:
  REPEAT:
    IMPORT UNFORMATTED cLine.

    /* Check for empty lines. */
    IF LENGTH(cLine) = 0 THEN DO:
      PUT UNFORMATTED CHR(10).
      NEXT readLine.
    END.

    IF templateType = "BROWSER.W" AND LEFT-TRIM(cLine) BEGINS "_Where" THEN DO:
      lCont = TRUE.
      DO WHILE lCont:
          IMPORT UNFORMATTED cLine.
          IF LEFT-TRIM(cLine) BEGINS "_":U AND NOT(LEFT-TRIM(cLine) BEGINS "_Where":U) THEN lCont = FALSE.
      END.  /* do while lCont */
    END.  /* If cLine is _WHERE */
 
    IF templateType NE "BROWSER.W" AND cLine BEGINS "&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS" THEN DO:
      /* Insert the include inclusion */
      PUT UNFORMATTED CHR(10) +
      "/* Temp-Table and Buffer definitions                                    */"
      SKIP
      "~&MESSAGE Convert Utility: " +
        "You should substitute a proper SmartData include file below." SKIP
      "DEFINE TEMP-TABLE RowObject" + CHR(10) +
      "       ~{" + '"' + incl-fl + '"' + "}." + CHR(10)
              SKIP.
    END. /* If cLine is _CUSTOM _DEFINITIONS */

    ELSE IF cLine BEGINS "/* Name of first Frame and/or Browse" THEN DO:
      PUT UNFORMATTED 
       "/* Include file with RowObject temp-table definition */" SKIP
       "~&MESSAGE Convert Utility: " +
        "You should substitute a proper SmartData include file below." SKIP
       "&Scoped-define DATA-FIELD-DEFS " + incl-fl SKIP (1).
    END.

    ELSE IF cLine BEGINS "&ANALYZE-SUSPEND _PROCEDURE-SETTINGS" THEN
      proc-settings = TRUE.

    ELSE IF cLine BEGINS "&ANALYZE-RESUME _END-PROCEDURE-SETTINGS" THEN
      proc-settings = FALSE.

    ELSE IF proc-settings THEN DO:
      ASSIGN tokn1 = fetchToken(cLine,1)
             tokn2 = fetchToken(cLine,2).
      IF tokn1 = "~/~*" AND tokn2 = "Settings" THEN
        PUT UNFORMATTED 
          '~&MESSAGE Convert Utility: ' +
          'You should substitute a proper SmartData procedure name and ' +
          'include file below.' SKIP.
        
      ELSE IF tokn1 = "Allow" AND
              tokn2 = "~:" THEN
        PUT UNFORMATTED '   Data Source: ~<_CONVERTED_~>' SKIP.
      ELSE IF templateType NE "BROWSER.W" AND tokn1 = "Other" AND tokn2 = "Settings" THEN DO:
        PUT UNFORMATTED
          '   Add Fields to: Neither' SKIP 
          cLine SKIP
          '   Temp-Tables and Buffers:' SKIP
          '      TABLE: RowObject D "?" ?' SKIP
          '      ADDITIONAL-FIELDS:' SKIP
          '          ~{' + incl-fl + '}' SKIP
          '      END-FIELDS.' SKIP
          '   END-TABLES.' SKIP.
        IMPORT UNFORMATTED cLine.
        proc-settings = FALSE.
      END. /* Other settings: */
    END.  /* If end of proc-settings comment */

    ELSE IF templateType NE "BROWSER.W" AND 
            cLine BEGINS "&Scoped-define ENABLED-TABLES" THEN
      cLine = "&Scoped-define ENABLED-TABLES RowObject".

    ELSE IF templateType NE "BROWSER.W" AND 
            cLine BEGINS "&Scoped-define FIRST-ENABLED-TABLE" THEN
      cLine = "&Scoped-define FIRST-ENABLED-TABLE RowObject".

    ELSE IF templateType = "BROWSER.W" AND cLine BEGINS "DEFINE QUERY" THEN DO:
      PUT UNFORMATTED 
        'DEFINE TEMP-TABLE RowObject' SKIP
        '    ~{~{&DATA-FIELD-DEFS~}~}' SKIP
        '    ~{src/adm2/robjflds.i~}.' SKIP(1).

      PUT UNFORMATTED cLine SKIP.
      lCont = TRUE.
      DO WHILE lCont:
        IMPORT UNFORMATTED tmpLine.
        IF LEFT-TRIM(tmpLine) BEGINS '&ANALYZE-RESUME':U THEN lCont = FALSE. 
      END.
      PUT UNFORMATTED '     rowObject SCROLLING.':U SKIP.
      cLine = '~&ANALYZE-RESUME':U.
    END.  /* define query */

    ELSE IF templateType = "BROWSER.W" AND LEFT-TRIM(cLine) BEGINS "QUERY" THEN DO:
      PUT UNFORMATTED cLine SKIP.
      lCont = TRUE.
      DO WHILE lCont:
        IMPORT UNFORMATTED tmpLine.
        IF tmpLine BEGINS "/* _UIB-CODE-BLOCK-END":U THEN lCont = FALSE.
        ELSE IF LEFT-TRIM(tmpLine) BEGINS "ENABLE":U THEN PUT UNFORMATTED "  ENABLE":U SKIP. 
        ELSE DO:
            tmpLine = ENTRY(1, LEFT-TRIM(tmpLine), " ":U).
            PUT UNFORMATTED "      " + ENTRY(NUM-ENTRIES(tmpLine, ".":U), tmpLine, ".":U) SKIP.
        END.  /* else do - field name */
      END.  /* do while lCont */
      cLine = "/* _UIB-CODE-BLOCK-END */":U.
    END.

    ELSE IF templateType = "BROWSER.W" AND LEFT-TRIM(cLine) BEGINS "_TblList" THEN
      ASSIGN cLine = '     _TblList          = "rowObject"'.
   
    ELSE IF templateType = "BROWSER.W" AND LEFT-TRIM(cLine) BEGINS "_Options" THEN
      ASSIGN cLine = '     _Options          = "NO-LOCK INDEXED-REPOSITION"'.

    ELSE IF templateType = "BROWSER.W" AND LEFT-TRIM(cLine) BEGINS "_TblOptList" THEN
      NEXT readLine.

    ELSE IF templateType = "BROWSER.W" AND LEFT-TRIM(cLine) BEGINS "_FldNameList["  THEN DO:
      ASSIGN nTokens = NUM-ENTRIES(LEFT-TRIM(cLine), " ":U).
             nTokens2 = NUM-ENTRIES(ENTRY(nTokens, LEFT-TRIM(cLine), " ":U), ".":U).
      
     ASSIGN cLine = '     ' + ENTRY(1, LEFT-TRIM(cLine), " ":U) + '   ' + 
        ENTRY(nTokens - 1, LEFT-TRIM(cLine), " ":U) + ' _<SDO>.rowobject.' +
        ENTRY(nTokens2, ENTRY(nTokens, LEFT-TRIM(cLine), " ":U), ".":U).
    END.

    ELSE DO: /* Go throught field substitutions */
      FOR EACH substitute BREAK BY qualifiers:
        IF FIRST-OF(qualifiers) THEN DO:
         cline = replaceQualifiers(cline,qualifiers).
        END.
      END.  /* For each substitute */
    END.  /* Else do the substitutions */
    
    PUT UNFORMATTED cLine SKIP.

  END.  /* Readline Repeat */
  
  INPUT CLOSE.
  OUTPUT CLOSE.

  OS-DELETE VALUE(tmpflnm).
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-convertLinkFunctions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION convertLinkFunctions Procedure 
FUNCTION convertLinkFunctions RETURNS LOGICAL:
 
/*------------------------------------------------------------------------------
  Purpose:     To convert a V8 style RUN Get-Link-Handle, RUN set-link-attribute
               or RUN Request-Attribute statement to a V9 style linkHandles(cLink),
               assignLinkProperties or linkProperties function
  Parameters:  <none>
  Notes:       Returns True if reasonably successful, False if confused 
------------------------------------------------------------------------------*/


DEFINE VARIABLE cArg1     AS CHARACTER                             NO-UNDO.
DEFINE VARIABLE cArg2     AS CHARACTER                             NO-UNDO.
DEFINE VARIABLE cArg3     AS CHARACTER                             NO-UNDO.
DEFINE VARIABLE cArg4     AS CHARACTER                             NO-UNDO.
DEFINE VARIABLE i         AS INTEGER                               NO-UNDO.
DEFINE VARIABLE n-e       AS INTEGER                               NO-UNDO.
DEFINE VARIABLE parms     AS CHARACTER                             NO-UNDO.

  /* Before attempting to parse this statment, lets strip out any comments and make
     sure continuation lines are tacked on */

  /* Find the end of the statement - there must be a ")" near then end of
     the statement (after OUTPUT parameter in the case of get-link-handle)
      - but make sure its not in a comment */
  IF cAction = "Get-Link-Handle" THEN DO:
    ASSIGN stmnt-end = INDEX(cLine, "OUTPUT").
    DO WHILE stmnt-end = 0:
      RUN appendLine.
      ASSIGN stmnt-end = INDEX(cLine, "OUTPUT").
    END.
  END.  /* IF Get-Link-Handle */
  ELSE stmnt-end = 1.

  /* Found OUTPUT keyword (in Get-Link-Handle case) , look for ")" after it */  
  ASSIGN stmnt-end = INDEX(cLine, ")", stmnt-end).
  DO WHILE stmnt-end = 0:
    RUN appendLine.
    ASSIGN stmnt-end = INDEX(cLine, ")").
  END.

  /* We now have a candidate for the end of the statement - make sure that it is not
     in a comment */
  ASSIGN com-bgns  = INDEX(cLine, "~/~*")                 /* Begining of a comment */
         com-ends  = INDEX(cLine, "~*~/", com-bgns + 2 ). /* End of comment        */

  DO WHILE com-bgns > 0 AND         /* There is a comment                          */
           stmnt-end > com-bgns AND /* The ) is after the start of the comment     */
          (stmnt-end < com-ends OR  /* The ) is before the end of the comment or   */
           com-ends = 0):           /* The comment is continued onto the next line */
    IF com-ends = 0 THEN DO:   /* Find the end of the comment */
      DO WHILE com-ends = 0:
        RUN appendLine.
        com-ends = INDEX(cLine, "~*~/", com-bgns + 2 ). /* End of comment        */
      END.
    END.  /* Find the end of the comment */

    /* Now we know that the ")" is in the comment, remove the comment and
       cycle back to find the next statement end candidate                       */
    ASSIGN cLine     = SUBSTRING(cLine,1,com-bgns - 1) + " " +
                        SUBSTRING(cLine,com-ends + 2)
           com-bgns  = INDEX(cLine, "~/~*")
           com-ends  = INDEX(cLine, "~*~/", com-bgns + 2)
           stmnt-end = INDEX(cLine,")").
    IF cLine = "" THEN RETURN TRUE.
    DO WHILE stmnt-end = 0:
      RUN appendLine.
      ASSIGN stmnt-end = INDEX(cLine, ")").
    END.  /* Looking for the end of the statement ")" */
  END.  /* DO while the end ")" is in a comment */

  /* This much code is common to all "RUN" get-link-handle statements: 
     Skip, for the moment, everything before RUN. This assign expects a line to 
     look like:
Token 1       2                    2          3      4         5     
    RUN get-link-handle or set-link-attribute IN adm-broker-hdl ( <cArg1>, cArg2, OUTPUT cArg3 ).
                                                                                        */
  ASSIGN lReturn  = no /* Turn off RETURN-VALUE conversion with each new RUN stmt.      */
         cSubLine = SUBSTR(cLine, INDEX(cLine, "RUN "))  /* cSubLine is everything
                                                            from the RUN keyword on     */
         parms    = ENTRY(2, cLine, "(":U)               /* the parameter list          */
         carg1    = TRIM(ENTRY(1, parms))                /* cArg1 is handle of proc     */
         n-e      = NUM-ENTRIES(cArg1, " ":U)            /* Maybe has "INPUT"           */
         cArg1   = IF n-e > 1 THEN                       /* This strips the INPUT keywd */
                      ENTRY(n-e, cArg1, " ")
                    ELSE cArg1
 
         cArg2    = TRIM(ENTRY(2, parms))                /* Link type                   */
         n-e      = NUM-ENTRIES(cArg2, " ":U)            /* Maybe has "INPUT"           */
         cArg2    = IF n-e > 1 THEN                      /* Strip out INPUT keyword     */
                      ENTRY(n-e, cArg2, " ")
                    ELSE cArg2
 
         cArg3 = TRIM(ENTRY(1,ENTRY(3, parms), ")"))     /* Link Handle                 */
         n-e      = NUM-ENTRIES(cArg3, " ":U)            /* Has "OUTPUT"                */
         cArg3 = ENTRY(n-e, cArg3, " ")                  /* Strip out OUTPUT keyword    */
         cArg1   = IF cArg1 = "THIS-PROCEDURE" THEN ""
                    ELSE cArg1
         changes  = changes + 1.
 
  CASE cAction:
    WHEN "Get-Link-Handle" THEN DO:
        cLine = SUBSTR(cLine,1,INDEX(cLine, "RUN") - 1) +   /* Keep indentation as RUN */
                 cArg3 + " = " +
                 (IF cArg1 EQ "" THEN "linkHandles(" + cArg2 + ")."
                  ELSE "DYNAMIC-FUNCTION('linkHandles' IN " + cArg1 + ", " + cArg2 + ")."
                  ).
    END.  /* Get-Link-Handle case */

    WHEN "Set-Link-Attribute" THEN DO:
        cLine = SUBSTR(cLine,1,INDEX(cLine, "RUN") - 1) +   /* Keep indentation as RUN */
                 (IF cArg1 EQ "" THEN "assignLinkProperty(" + cArg2 + ", " + 
                                       TRIM(ENTRY(1, cArg3, "=":U)) + ", " +
                                       TRIM(ENTRY(2, cArg3, "=":U)) + ")."
                  ELSE "DYNAMIC-FUNCTION('assignlinkProperty':U IN " + cArg1 + ", " + cArg2 +
                                       TRIM(ENTRY(1, cArg3, "=":U)) + ", " +
                                       TRIM(ENTRY(2, cArg3, "=":U)) + ")."
                  ).
    END.  /* Set-Link-Attribute */

    WHEN "Request-Attribute" THEN DO:
      /* Look for RETURN-VALUE */
      REPEAT WHILE INDEX(cLine, "RETURN-VALUE") = 0:
        IMPORT UNFORMATTED cLine.
      END.  /* While looking for Mr. Return Value */
      cLine = ENTRY(1, cLine, "=":U) + "= ":U +
              (IF cArg1 = "" THEN "linkProperty("
               ELSE "DYNAMIC-FUNCTION('linkProperty':U IN " + cArg1 + ", ":U) +
               cArg2 + ", " + cArg3 + ").".
    END.  /* Request-Attribute Case */

    WHEN "Modify-List-Attribute" THEN DO:
      ASSIGN cLine = SUBSTR(cLine,1,INDEX(cLine, "RUN") - 1) +  /* Keep indentation as RUN */
                        "modifyListProperty(" + parms.          /* Params don't change     */
    END.  /* Modify-List-Attribute Case */
  END CASE. /* Case on cAction */
 
  RETURN FALSE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-determineAction) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION determineAction Procedure 
FUNCTION determineAction RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  A new line has read this determines the action to perform. The
            possible choices are:
                Prefixes            Scoped-Def          Procedure
                Dispatch            Notify              Init-Object
                Get-Attribute       Set-Attribute       Get-Link-Handle
                Set-Link-Attribute  Request-Attribute   Modify-List-Attribute
                New-State           Run                 EndProc
                Other
                
    Notes:  
------------------------------------------------------------------------------*/

  cAction = IF SUBSTR(cLine,1,20) = "&IF DEFINED(EXCLUDE-" 
              OR SUBSTR(cLine,1,32) = "&ANALYZE-SUSPEND _UIB-CODE-BLOCK" 
                THEN "Prefixes"
            ELSE IF SUBSTR(cLine,1,10) = "&SCOPED-DE"
                THEN "Scoped-Def"
            /* Next check for the procedure header itself. */
            ELSE IF SUBSTR(cLine,1,10) = "PROCEDURE " 
                THEN "Procedure"
            /* Next check for all the RUN statements we have to convert. */
            ELSE IF INDEX(cLine, "RUN dispatch") NE 0 
                THEN "Dispatch"
            ELSE IF INDEX(cLine, "RUN notify") NE 0 
                THEN "Notify"
            ELSE IF INDEX(cLine, "RUN init-object") NE 0
                THEN "Init-Object"
            ELSE IF INDEX(cLine, "RUN get-attribute") NE 0 
                THEN "Get-Attribute"
            ELSE IF INDEX(cLine, "RUN set-attribute-list") NE 0 
                THEN "Set-Attribute"
            ELSE "Other".

  /* Need to break this up due to 4096 byte limit */
  IF cAction = "Other" THEN
    ASSIGN cAction =
            IF INDEX(cLine, "RUN get-link-handle") NE 0 
                THEN "Get-Link-Handle"
            ELSE IF INDEX(cLine, "RUN set-link-attribute") NE 0 
                THEN "Set-Link-Attribute"
            ELSE IF INDEX(cLine, "RUN request-attribute") NE 0 
                THEN "Request-Attribute"
            ELSE IF INDEX(cLine, "RUN modify-list-attribute") NE 0 
                THEN "Modify-List-Attribute"
            ELSE IF INDEX(cLine, "RUN new-state") NE 0
                THEN "New-State"
            ELSE IF INDEX(cLine, "RUN ") NE 0 
                THEN "Run"           /* Any other RUN statement. */
            ELSE IF cLine BEGINS "&ANALYZE-RESUME" 
                THEN "EndProc"
            ELSE "Other".       /* For any code that looks at all other lines. */

  RETURN cAction.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchToken) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fetchToken Procedure 
FUNCTION fetchToken RETURNS CHARACTER
  (pcString AS CHARACTER, piToken AS INTEGER) :
/*------------------------------------------------------------------------------
  Purpose: Given a string (pcString) fetchToken returns the nth (piToken)
           space delimited token 
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE iToken   AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iPos     AS INTEGER   NO-UNDO INIT 1.
  DEFINE VARIABLE iLen     AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iStart   AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cChar    AS CHARACTE  NO-UNDO.
  DEFINE VARIABLE cQuote   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cSpecial AS CHARACTER NO-UNDO INIT ":()=".  /* Special tokens. */

  ASSIGN pcString = pcString + " "
                    /* Pad with a space to avoid counting problems at end. */
         iLen     = LENGTH(pcString,"CHARACTER").
                    /* Make sure we don't walk off the end of the string.  */

  DO iToken = 1 TO piToken:
    /* Skip white space */
    cChar = SUBSTR(pcString, iPos, 1).
    DO WHILE iPos < iLen AND (cChar = " " OR cChar = CHR(10)):
      ASSIGN iPos  = iPos + 1
             cChar = SUBSTR(pcString, iPos, 1).
    END.  /* DO WHILE iPos < iLen and character is " " or CHR(10) */

    /* We are currently at the start of a token */
    ASSIGN iStart = iPos.    /* Mark the beginning of each token. */
 
    /* cChar is non blank - Look for quotes */
    IF  cChar = "'" OR cChar = '"' THEN DO:
      /* Treat the quoted string (incl. the quotes) as one token. */
      iPos = iPos + 1.        /* Move past the leading quote. */
      DO WHILE iPos < iLen AND SUBSTR(pcString, iPos, 1) NE cChar:
        iPos = iPos + 1.      /* Find the matching end quote */
      END.
      iPos = iPos + 1.        /* and position beyond it. */
    END.  /* If single or double quote */
    ELSE DO:  /* This token isn't in quotes */
      IF INDEX(cSpecial,cChar) NE 0 THEN  /* Special tokens */
        iPos = iPos + 1.
      ELSE DO WHILE iPos < iLen AND INDEX(" " + cSpecial, cChar) = 0:
        ASSIGN iPos = iPos + 1
               cChar = SUBSTR(pcString, iPos, 1).    /* Walk through the token. */
      END.
    END.  /* Else do: */
  END.  /* iToken = 1 to piToken */
  RETURN SUBSTR(pcString, iStart, iPos - iStart).
END FUNCTION.  /* fetchToken */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ProcessV8Run) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION ProcessV8Run Procedure 
FUNCTION ProcessV8Run RETURNS LOGICAL:
/*------------------------------------------------------------------------------
  Purpose:     To process a V8 style RUN statement of any of the following v8
               procesdures: Dispatch, Notify, Get-Attribute, Set-Attribute OR
               New-State
  Parameters:  <none>
  Notes:       Returns True if reasonably successful, False if confused 
------------------------------------------------------------------------------*/

DEFINE VARIABLE attrEntry AS CHARACTER                             NO-UNDO.
DEFINE VARIABLE attr-i    AS CHARACTER                             NO-UNDO.
DEFINE VARIABLE built-in  AS LOGICAL                               NO-UNDO.
DEFINE VARIABLE frst-chr  AS CHARACTER                             NO-UNDO.
DEFINE VARIABLE i         AS INTEGER                               NO-UNDO.
DEFINE VARIABLE nspcs     AS INTEGER                               NO-UNDO.
DEFINE VARIABLE ntokens   AS INTEGER                               NO-UNDO.
DEFINE VARIABLE save-line AS CHARACTER                             NO-UNDO.

  /* Before attempting to parse this statment, lets strip out any comments and make
     sure continuation lines are tacked on */

  /* Find the end of the statement - since this is a Dispatch, Notify, Get-Attribute,
     Set-Attribute or New-State RUN statement, there must be a ")" near then end of
     the statement - but make sure its not in a comment */
  ASSIGN stmnt-end = INDEX(cLine, ")").
  DO WHILE stmnt-end = 0:
    RUN appendLine.
    ASSIGN stmnt-end = INDEX(cLine, ")").
  END.

  /* We now have a candidate for the end of the statement - make sure that it is not
     in a comment */
  ASSIGN com-bgns  = INDEX(cLine, "~/~*")                 /* Begining of a comment */
         com-ends  = INDEX(cLine, "~*~/", com-bgns + 2 ). /* End of comment        */

  DO WHILE com-bgns > 0 AND         /* There is a comment                          */
           stmnt-end > com-bgns AND /* The ) is after the start of the comment     */
          (stmnt-end < com-ends OR  /* The ) is before the end of the comment or   */
           com-ends = 0):           /* The comment is continued onto the next line */
    IF com-ends = 0 THEN DO:   /* Find the end of the comment */
      DO WHILE com-ends = 0:
        RUN appendLine.
        com-ends = INDEX(cLine, "~*~/", com-bgns + 2 ). /* End of comment        */
      END.
    END.  /* Find the end of the comment */

    /* Now we know that the ")" is in the comment, remove the comment and
       cycle back to find the next statement end candidate                       */
    ASSIGN cLine     = SUBSTRING(cLine,1,com-bgns - 1) + " " +
                        SUBSTRING(cLine,com-ends + 2)
           com-bgns  = INDEX(cLine, "~/~*")
           com-ends  = INDEX(cLine, "~*~/", com-bgns + 2)
           stmnt-end = INDEX(cLine,")").
    IF cLine = "" THEN RETURN TRUE.
    DO WHILE stmnt-end = 0:
      RUN appendLine.
      ASSIGN stmnt-end = INDEX(cLine, ")").
    END.  /* Looking for the end of the statement ")" */
  END.  /* DO while the end ")" is in a comment */

  /* This much code is common to all the special "RUN" statements: 
     Skip, for the moment, everything before RUN. This assign expects a line to 
     look like:
Token 1     2   or 2   or 2          or 2          or 2        3    4     5    6      7   8
    RUN dispatch|notify|get-attribute|set-attribute!new-state [IN cInHdl] ( [INPUT] cName ).
or    1     2      2      2             2             2                   3    4     5[4] 6[5]
                                                                                        */

  ASSIGN lReturn  = no /* Turn off RETURN-VALUE conversion with each new RUN stmt.  */
         cSubLine = SUBSTR(cLine, INDEX(cLine, "RUN ")) /* cSubLine is everything
                                                           from the RUN keyword on  */
         cInHdl   = IF fetchToken(cSubLine, 3) = "IN"   /* cInHdl is handle of proc */
                      THEN fetchToken(cSubLine, 4)      /* that the internal proc   */
                      ELSE ""                           /* will be run "IN"         */
         iIndex   = IF cInHdl = "" THEN 4 ELSE 6        /* Look for 'cName' token.  */
         cName    = IF fetchToken(cSubLine, iIndex) = 'INPUT' /* cName is the proc  */
                      THEN fetchToken(cSubLine, iIndex + 1)
                      ELSE fetchToken(cSubLine, iIndex)
         changes  = changes + 1.

  /* Is this attribute a built-in property? */
  FIND prprty WHERE prprty.v8prop = SUBSTR(cName, 2, LENGTH(cName) - 2) NO-ERROR.
  ASSIGN built-in = AVAILABLE prprty.

  CASE cAction:
    WHEN "Dispatch" THEN DO:
      /* Look for "RUN dispatch [IN hdl] ('proc')" and change to 
         "RUN proc [IN hdl]"  or "RUN SUPER" if we're in a local 'proc'. */
      cName = SUBSTR(cName, 2, LENGTH(cName) - 2).   /* Eliminate quote marks. */
      IF cName = "CREATE-OBJECTS" THEN cName = "createObjects".
  
      /* If the name of the procedure we're dispatching is the same as the
         name of the procedure we're *in*, then use the SUPER keyword. */
      IF cName = cProcName THEN DO:
        IF cInHdl = "" OR cInHdl = "This-Procedure":U THEN
          cName = "SUPER".
        ELSE DO:
          FIND FIRST method WHERE method.v8method = cName NO-ERROR.
          IF AVAILABLE method then cName = method.v9method.
        END.
        FIND FIRST method WHERE method.v8method = cProcName NO-ERROR.
        IF AVAILABLE method AND method.params NE "" THEN DO:
          DO i = 1 TO NUM-ENTRIES(method.params):
            tmpParam = ENTRY(i, method.params).
            cName = cName + (IF i = 1 THEN " (":U  ELSE ", ":U) +
                      (IF ENTRY(3,tmpParam,"|":U) = "I":U THEN "INPUT ":U
                       ELSE IF ENTRY(3,tmpParam,"|":U) = "O":U THEN "OUTPUT ":U
                       ELSE "INPUT-OUTPUT ":U) + ENTRY(1,tmpParam,"|":U).
          END.  /* DO i = 1 to num-entries */
          cName = cName + ")".
        END.  /* If this is an adm-method */
      END.  /* If this is a call to itself */
      FIND FIRST method WHERE method.v8method = cName NO-ERROR.
      IF AVAILABLE method THEN cName = method.v9method.
      IF AVAILABLE method AND method.mTYPE = "FL" THEN cName = cName + "()".
  
      cLine = SUBSTR(cLine,1,INDEX(cLine, "RUN") + 3) +       /* Up through "RUN " */
                cName + (IF cInHdl NE "" THEN " IN " + cInHdl ELSE " ") +
                SUBSTR(cSubLine,INDEX(cSubLine,")") + 1).       /* Statement End */
      IF AVAILABLE method AND method.mType = "FL" THEN
        cLine = REPLACE(cLine, "RUN ":U, "":U).
    END.  /* WHEN cAction = "Dispatch" */
    WHEN "Notify" THEN DO:
      /* Look for "RUN notify [IN hdl] ('proc')" and change to 
         "PUBLISH 'proc' [FROM hdl]". ("cName" is the notify proc name here,
         including the enclosing quote marks and :U, because the PUBLISH
         syntax requires the event name to be a string literal or expression.)
         If there is a link name specified in the Notify, then for now we simply
         eliminate it by searching for a comma and ignoring everything after that.
         In principle this means that the object at the other end of the link must
         SUBSCRIBE to that event. This is probably OK for, say, GROUP-ASSIGN-TARGETs,
         which can subscribe to all the same events as a TABLEIO-TARGET, but gets
         more interesting for, say, "apply-entry, TABLEIO-SOURCE" or
         "view, CONTAINER-SOURCE". */
      IF INDEX(cName, ",") NE 0 THEN    /* Keep initial quote mark and match at end. */
        cName = SUBSTR(cName, 1, INDEX(cName, ",") - 1) + SUBSTR(cName, 1, 1).
      FIND FIRST method WHERE method.v8method = TRIM(TRIM(cName,"'":U),'"':U) NO-ERROR.
      IF AVAILABLE method THEN cName = IF cName BEGINS "'":U OR cName BEGINS '"':U
                                       THEN "'":U + method.v9method + "'":U ELSE
                                       method.v9method.
      IF AVAILABLE method AND method.mTYPE = "FL" THEN cName = cName + "()".
  
      cLine = SUBSTR(cLine,1,INDEX(cLine, "RUN") - 1) +       /* Any initial space */
              "PUBLISH " + cName + ":U" + 
              (IF cInHdl NE "" THEN " FROM " + cInHdl ELSE " ") +
              SUBSTR(cSubLine,INDEX(cSubLine,")") + 1).       /* Statement End */
    END.  /* WHEN cAction = "Notify" */
    WHEN "Get-Attribute" THEN DO:
      ASSIGN lReturn   = yes   /* Flag to convert RETURN-VALUEs. */
      /* Look for RUN get-attribute. If found, remove that line, unless there's
         a comment or something else at the end, and replace all occurrences
         of RETURN-VALUE up to the procedure end or next RUN with get<attrname>. 
         Note that users may wish to change the code to avoid multiple invocations
         of the get function, so we may wish to flag multiple RETURN-VALUEs. */
             cInHdl    = IF cInHdl = "THIS-PROCEDURE" THEN "" ELSE cInHdl
             cAttrName = (IF cInHdl NE "" THEN
                          "DYNAMIC-FUNCTION('" ELSE "") +
                         "get" + /* If built-in then v9prop else user defined */
                         (IF built-in THEN prprty.v9prop +
                            (IF cInHdl NE "" THEN "':U IN " + cInHdl + ")" ELSE "()")
                          ELSE "UserProperty('" + SUBSTR(cName, 2, LENGTH(cName) - 2) + 
                            (IF cInHdl NE "" THEN "':U IN " + cInHdl + ")" ELSE "':U)"))
      /* Look for a comment at the end of the line; if found, write it out.
         All following RETURN-VALUEs up to the end of procedure or next RUN statement
         will be replaced with the getAttr function (see "Other" below). */
             iIndex    = INDEX(cLine, "/*")
             cLine     = IF iIndex NE 0 THEN SUBSTR(cLine, iIndex) ELSE " ".
    END.  /* WHEN xAction = "Get-Attribute" */
    WHEN "Set-Attribute" THEN DO:
      /* Look for RUN set-attribute-list and convert each attribute to new style:
         Example:
            RUN set-attribute-list ( 'attr1 = value1, attr2 = value2, ... attr3 = value3':U).
         Becomes:
            {set attr1 value1}
            {set attr2 value2}
                 . . .
            {set attrn valuen}        */
  
     ASSIGN cName     = REPLACE(cName, "=":U, " = ":U)
            cName     = REPLACE(cName, "  ", " ")
            nTokens   = NUM-ENTRIES(cName," ")
            save-line = cLine
            nspcs     = INDEX(cLine, "RUN") - 1
            cLine     = "".
      DO i = 2 TO nTokens - 1:  /* Look for "="'s */
        ASSIGN attrEntry = ENTRY(i, cName, " ").
        IF attrEntry = "=" THEN DO:
          /* At this point we are in the midst of a "Attr = Value" triplet */
          ASSIGN attr-i   = TRIM(ENTRY(i - 1, cName, " "), "~',~"")
                 cValue   = TRIM(ENTRY(i + 1, cName, " "), "~,")
                 frst-chr = SUBSTRING(cValue,1,1)
                 cValue   = IF frst-chr = '"' THEN RIGHT-TRIM(cValue,"~'")
                            ELSE IF frst-chr = "'" THEN RIGHT-TRIM(cValue, '~"')
                            ELSE RIGHT-TRIM(cValue, '~',~"')
                 frst-chr = SUBSTRING(cValue,1,1)
                 cValue   = IF INDEX("0123456789-+.,",frst-chr) = 0
                               THEN "'" + cValue + "'" ELSE cValue.
                 
          IF NOT CAN-FIND(FIRST name-switch WHERE name-switch.forget AND
                                            attr-i = name-switch.old-name) THEN DO:
            /* If this is not on the forget list then write it out */
            /* Check to see if this is a built-in property */
            FIND prprty WHERE prprty.v8prop = attr-i NO-ERROR.

            IF AVAILABLE prprty THEN
              cLine = cLine + (IF cLine ne "" THEN CHR(10) ELSE "") + FILL(" ", nspcs) +
                      "~{set " + prprty.v9prop + " " + cvalue + "}.".
            ELSE  /* Not a buit-in property */
              cLine = cLine + (IF cLine ne "" THEN CHR(10) ELSE "") + FILL(" ", nspcs) +
                      "DYNAMIC-FUNCTION ('setUserProperty':U" +
                               (IF cInHdl NE "" THEN " IN " + cInHdl ELSE "") + ", '" +
                               attr-i + "':U, " + cvalue + ").".

          END.  /* If not on the forget list */
        END.  /* If attrEntry = "+" */
      END.  /* Do i = 2 TO nTokens - 1 */
    END. /* WHEN cAction = "Set-Attribute */
    WHEN "New-State" THEN DO:
      /* Each state message is really a value for a group property in the new world.
         Look up the message, find the corresponding property name (add "State" to it),
         and turn it into a setPropState function. */
      ASSIGN iIndex = LOOKUP(SUBSTR(cName, 2, LENGTH(cName) - 2),
                          cStateVals).                              /* w/o quotes */
      IF iIndex > 0 THEN
        ASSIGN cLine = SUBSTR(cLine,1,INDEX(cLine, "RUN") - 1) +    /* Any initial space */
                       (IF cInHdl NE "" THEN cInHdl + ":" ELSE "") +
                       "set" + ENTRY(iIndex,cStateProps) + "State(" +
                       cName + ":U)" +  
                       SUBSTR(cSubLine,INDEX(cSubLine,")") + 1).    /* Statement End */
      /* Special handling for setUpdateState('update-begin') */
      IF cLine MATCHES "*setUpdateState*" THEN
        cLine = REPLACE(REPLACE(cLine,"setUpdateState":U, "RUN updateState":U),
                        "update-begin":U, "UPDATE":U).
    END.  /* WHEN cAction = "New-State" */
  END CASE.  /* End the case on cAction */

  RETURN TRUE.   /* Reasonably succesfull */

END FUNCTION.  /* ProcessV8Run */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-removePrefixes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION removePrefixes Procedure 
FUNCTION removePrefixes RETURNS CHARACTER
  (pcLine AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose: Remove adm-, local-, broker-, or custom- prefix from the line and
           return the kind of prefix removed. 
    Notes:  
------------------------------------------------------------------------------*/
 
  DEFINE VARIABLE cPrefix AS CHARACTER NO-UNDO INIT "".

  cPrefix = IF INDEX(pcLine,"adm-") NE 0          THEN "adm-"
            ELSE IF INDEX(pcLine,"local-") NE 0   THEN "local-"
            ELSE IF INDEX(pcLine,"broker-") NE 0  THEN "broker-"
            ELSE IF cCustomPrefix NE "" AND INDEX(pcLine,cCustomPrefix) NE 0
                                                  THEN cCustomPrefix
            ELSE "".

  /* Don't change adm-create-object */
  IF cPrefix = "adm-" AND INDEX(pcLine,"adm-create-objects") NE 0 THEN
    cPrefix = "".

  IF cPrefix NE "" THEN           /* Don't touch non-"dispatch" procedure names. */
    ASSIGN cLine   = REPLACE(cLine, cPrefix, "")
           changes = changes + 1.
  RETURN cPrefix.
END FUNCTION.  /* removePrefixes */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-replaceOne) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION replaceOne Procedure 
FUNCTION replaceOne RETURNS CHARACTER
  ( /* parameter-definitions */
     pcLine AS CHARACTER,  
     pqualifiers AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  This routine replaces each occurence of a qualifier with RowObject. 
        We have to look at each occurence
        separately to make sure it is not a substring. For example, we don't want
        to replace Order with RowObject in the Order-Line case.
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE cx          AS CHARACTER.
DEFINE VARIABLE cStr1       AS CHARACTER.
DEFINE VARIABLE cStr2       AS CHARACTER.
DEFINE VARIABLE tempLine    AS CHARACTER INIT ?.
DEFINE VARIABLE ix          AS INTEGER.
DEFINE VARIABLE iqLen       AS INTEGER.  


ASSIGN iqLen = LENGTH(pqualifiers).    


ix = INDEX(pcline,pqualifiers).
DO WHILE ix > 0:

/* look at the character following the tablename to see if is really
    just a substring of another tablename like Order is a substring of Order-Line 
 */
    cx = SUBSTR(pcline,ix + iqLen,1).
    /* if it is a valid match, then do the substitution */
    IF cx = " " OR cx = "" OR cx = "." THEN DO:
        cStr1 = SUBSTR(pcline, 1, ix + iqLen - 1).
        cStr2 = SUBSTR(pcline,ix + iqLen).

        cStr1 = REPLACE(cStr1, pqualifiers, " RowObject").
        pcLine = cStr1 + cStr2.    
        /* if we haven't run into any bad matches then look again from beginning */
        /* otherwise we have to advance temporarily past the bad match so we 
         * don't keep finding it
         */
        IF templine = ? THEN
            ix = INDEX(pcline,pqualifiers).
        ELSE DO:    
            templine = SUBSTR(pcline,ix + iqLen).
            IF INDEX(templine,pqualifiers) > 0 THEN
                ix = ix + iqlen + INDEX(templine, pqualifiers) - 1.
            ELSE LEAVE.
        END.
    END. /* if cx = " " */
    ELSE DO:    /* this was the bad match so advance past it */ 
        templine = SUBSTR(pcline,ix + iqLen).
        IF INDEX(templine, pqualifiers) > 0 THEN
            ix = ix + iqlen + INDEX(templine, pqualifiers) - 1.
         ELSE LEAVE.
    END.
        
END. /* end Do while */
RETURN pcLine.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-replaceQualifiers) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION replaceQualifiers Procedure 
FUNCTION replaceQualifiers RETURNS CHARACTER
  ( /* parameter-definitions */
     pcLine AS CHARACTER,  
     pqualifiers AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  Replaces qualifier (with and without appropriate prefixes) with
            'RowObject'. The replacement is done for all appropriate occurences
            in the pcLine.
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE iqLen   AS INTEGER.
DEFINE VARIABLE cx      AS CHARACTER.

iqLen = LENGTH(pqualifiers) + 1.
pcLine = replaceOne(pcLine, " " + pqualifiers).
pcLine = replaceOne(pcLine, "(" + pqualifiers).

/* last case is when it is at beginning of line and not preceded by space
    or left parenthesis 
 */
IF pcLine BEGINS pqualifiers THEN DO:
    cx = SUBSTR(pcline,iqLen,1).
    /* if it is a valid match, then do the substitution */
    IF cx = " " OR cx = "" OR cx = "." 
        THEN pcLine = "RowObject" + SUBSTRING(pcLine, iqLen).
END. /* if pcline Begins */
  
RETURN pcLine.   /* Function return value. */
   
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-userProcName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION userProcName Procedure 
FUNCTION userProcName RETURNS LOGICAL
  ( /* parameter-definitions */
     cInLine AS CHARACTER,
     iInd AS INTEGER, 
     cv8Method AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Determine if the procedure name is exactly the method name
  and not just a prefix for a user-defined procedure name.
    Notes:  
------------------------------------------------------------------------------*/
  
  DEFINE VARIABLE cNext AS CHARACTER NO-UNDO.

 
  /* look at the character immediately following the method name.
     Determine if cinLine is exactly that method or if the methodname is just
     a prefix.
   */
   cNext = substring(cInLine,iInd + length(cv8Method)).
   IF cNext = " " OR cNext = "(" OR cNext = "." THEN RETURN FALSE.
       ELSE RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

