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
/* Modified March 22, 2001 for ICF
   John Sadd
   -- removed all occurrences of "mip" prefix
   -- changed CreateSection to put the preTransactionValidate procedure
      into a new sdo logic procedure
   */
/* Modified September 26, 2001 for ICF - Johan Meyer
   -- Added function to check blank character values
   -- Change to cater for fields shorter than 4 characters
   -- Change to cater for tables that have fields with the same name as the tablename
   */   
/* Modified - 01/16/2002 - Mark Davies (MIP)
   - All path seperators MUST be '/' and not '\' - it will not compile on a UNIX platform
   */
&GLOBAL-DEFINE ROLENAME  "company_|current_|login_|requested_by_|funeral_|paying_|donated_by_|transplanted_by_|received_by_|managed_by_|diagnosed_by_|closed_by_|transmitted_by_|policy_owner_|checked_by_|institution_|notify_|responsible_|admitted_by_|therapy_plan_by_|automated_by_|bill_to_|funding_|prescribed_by_|referred_by_|transfered_to_|authorised_by_|done_by_|debtor_"
&GLOBAL-DEFINE FIELDNAME "*reference,*code,last_name,*tla,*short*,*id|*desc*,first_name,*name*"
&GLOBAL-DEFINE TABLELIST "FIRST|SECOND|THIRD|FOURTH|FIFTH|SIXTH|SEVENTH|EIGHTH|NINTH|TENTH|ELEVENTH|TWELFTH"
&GLOBAL-DEFINE FRAME-NAME EDIT-FRAME

/* ICF -- set DIAG to YES for test */
&SCOPED-DEFINE DIAG

FUNCTION buildRowObjectValidate RETURNS CHARACTER
  ( INPUT pcTable AS CHARACTER) FORWARD.

FUNCTION buildPreTransactionValidate RETURNS CHARACTER
  ( INPUT pcTable AS CHARACTER) FORWARD.

FUNCTION buildCreatePreTransValidate RETURNS CHARACTER
  ( INPUT pcTable AS CHARACTER) FORWARD.

FUNCTION buildWritePreTransValidate RETURNS CHARACTER
  ( INPUT pcTable AS CHARACTER) FORWARD.

FUNCTION getMandatoryFields RETURNS CHARACTER
  ( INPUT pcTable AS CHARACTER) FORWARD.

FUNCTION getIndexFields RETURNS CHARACTER
  ( INPUT pcTable AS CHARACTER) FORWARD.

FUNCTION getAKFields RETURNS CHARACTER
  ( INPUT pcTable AS CHARACTER) FORWARD.

FUNCTION editFixCRLF RETURNS LOGICAL FORWARD.

DEFINE TEMP-TABLE tt_filetable 
    FIELD tt_db     AS CHARACTER 
    FIELD tt_type   AS CHARACTER 
    FIELD tt_tag    AS CHARACTER 
    FIELD tt_data   AS CHARACTER EXTENT 6 
    INDEX tt_main tt_db tt_type tt_tag.

DEFINE TEMP-TABLE tt_fieldtable 
    FIELD tt_tag    AS INTEGER 
    FIELD tt_data   AS CHARACTER 
    INDEX tt_main tt_tag.

DEFINE VARIABLE eEdit AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL LARGE
     SIZE 200 BY 20 NO-UNDO FONT 2.

DEFINE FRAME {&FRAME-NAME}
    eEdit AT ROW 1 COL 1 NO-LABEL
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 200 BY 20.

DEFINE STREAM sStream.

&IF "{&DIAG}" EQ "YES":U &THEN
DEFINE VARIABLE pcQuery         AS CHARACTER  NO-UNDO INITIAL "FOR EACH ora2001.courier NO-LOCK".
DEFINE VARIABLE pcReadF         AS CHARACTER  NO-UNDO INITIAL "ry/obj/rysttasdoo.w".
DEFINE VARIABLE pcSaveF         AS CHARACTER  NO-UNDO INITIAL "c:/possenet/work/af/courierfullo.w".
DEFINE VARIABLE pcMethod        AS CHARACTER  NO-UNDO INITIAL "FOLLOW".
DEFINE VARIABLE pcLogicReadF    AS CHARACTER  NO-UNDO INITIAL "ry/obj/rytemlogic.p":U. /* new for ICF */
DEFINE VARIABLE pcLogicSaveF    AS CHARACTER  NO-UNDO INITIAL "c:/possenet/work/af/courierlogic.p". /* new for ICF */
DEFINE VARIABLE pcRootDir       AS CHARACTER  NO-UNDO INITIAL "c:/possenet/work/af":U.
DEFINE VARIABLE piSort           AS INTEGER    NO-UNDO. /* new for icf 1.1. */
DEFINE VARIABLE plSuppressValidate AS LOGICAL NO-UNDO.  
DEFINE VARIABLE pcError         AS CHARACTER  NO-UNDO INITIAL "".

UPDATE
    pcQuery         VIEW-AS EDITOR SIZE 50 BY 5 LABEL "Query" SKIP 
    pcReadF         LABEL "Read File"          FORMAT "X(50)" SKIP
    pcSaveF         LABEL "Save File"          FORMAT "X(50)" SKIP
    pcLogicReadF    LABEL "Logic Read File"    FORMAT "x(50)" SKIP
    pcLogicSaveF    LABEL "Logic Save File"    FORMAT "x(50)" SKIP
    WITH SIDE-LABELS.
&ENDIF

&IF "{&DIAG}" NE "YES":U &THEN
DEFINE INPUT PARAMETER pcQuery          AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER pcReadF          AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER pcSaveF          AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER pcMethod         AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER pcLogicReadF     AS CHARACTER  NO-UNDO. /* new for ICF */
DEFINE INPUT PARAMETER pcLogicSaveF     AS CHARACTER  NO-UNDO. /* new for ICF */
DEFINE INPUT PARAMETER pcRootDir        AS CHARACTER  NO-UNDO. /* new for ICF */
DEFINE INPUT PARAMETER piSort           AS INTEGER    NO-UNDO. /* new for icf 1.1. */
DEFINE INPUT PARAMETER plSuppressValidate AS LOGICAL NO-UNDO.  
DEFINE OUTPUT PARAMETER pcError         AS CHARACTER  NO-UNDO. /* new for ICF */
DEFINE OUTPUT PARAMETER pcFollowJoins   AS CHARACTER  NO-UNDO. /* new for ICF */
&ENDIF

RUN CreateSection (pcQuery, pcReadF, pcSaveF, pcMethod, pcLogicReadF, pcLogicSaveF,piSort,plSuppressValidate).

&IF "{&DIAG}" EQ "YES":U &THEN
WAIT-FOR WINDOW-CLOSE OF CURRENT-WINDOW.
&ENDIF

PROCEDURE CreateSection:
/*------------------------------------------------------------------------------
  Purpose:     CreateSection
  Parameters:  <none>
  Notes:       Creates a section
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcQueryList       AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pcReadFile        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pcSaveFile        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pcMethod          AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pcLogicReadFile   AS CHARACTER NO-UNDO. /* new for ICF */
DEFINE INPUT PARAMETER pcLogicSaveFile   AS CHARACTER NO-UNDO. /* new for ICF */ 
DEFINE INPUT PARAMETER piSort            AS INTEGER   NO-UNDO. /* new for icf 1.1 */
DEFINE INPUT PARAMETER plSuppressValidate AS LOGICAL  NO-UNDO. /* new for icf 1.1 */

DEFINE VARIABLE cQueryList AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cFieldList AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cEnablList AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDataList  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iTableList AS INTEGER    NO-UNDO.
DEFINE VARIABLE cTableName AS CHARACTER  NO-UNDO.                                                                                         
DEFINE VARIABLE cDbaseName AS CHARACTER  NO-UNDO.                                                                                         
DEFINE VARIABLE cTableList AS CHARACTER  NO-UNDO.            
DEFINE VARIABLE cDbaseList AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cSortList  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cConDbList AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iOffset    AS INTEGER    NO-UNDO.
DEFINE VARIABLE iLoop      AS INTEGER    NO-UNDO.
DEFINE VARIABLE iCount     AS INTEGER    NO-UNDO.
DEFINE VARIABLE cPathName  AS CHARACTER  NO-UNDO.  
DEFINE VARIABLE cSaveLogicFile AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cFileName  AS CHARACTER  NO-UNDO.

    /* Get the query and field list */
    RUN FollowLinks (INPUT        pcMethod, 
                     INPUT        piSort,
                     INPUT        plSuppressValidate,
                     INPUT-OUTPUT pcQueryList, 
                     INPUT-OUTPUT cFieldList).
    
    ASSIGN pcSaveFile = REPLACE(pcSaveFile,"~\":U,"/":U).

    /* Build a database and table List*/
    DO iLoop = 1 to NUM-ENTRIES(pcQueryList," "):
        IF CAN-DO("EACH,FIRST,LAST",ENTRY(iLoop,pcQueryList," "))
        THEN DO:
            ASSIGN
                cTableName = REPLACE(ENTRY(iLoop + 1,pcQueryList," "),",":U,"":U)
                cTableList = cTableList + "|":U WHEN cTableList <> "":U
                cDbaseList = cDbaseList + "|":U WHEN cDbaseList <> "":U
                cDbaseName = cTableName
                cTableName = IF NUM-ENTRIES(cTableName,".") > 1 THEN ENTRY(2,cTableName,".") ELSE cTableName
                cDbaseList = cDbaseList + cDbaseName
                cTableList = cTableList + cTableName
                cQueryList = REPLACE(cQueryList,cDbaseName,cTableName).

            IF INDEX(cConDbList,ENTRY(1,cDbaseName,".")) = 0 THEN            
                ASSIGN cCondbList = cCondbList + CHR(10) WHEN cConDbList <> "":U
                       cCondbList = cCondbList + FILL(" ":U, 10) + ENTRY(1,cDbaseName,".") + FILL(" ":U, 13) + DBTYPE(ENTRY(1,cDbaseName,"."))
                       .
        END.
    END. 

    /* First get the main table fields */
    ASSIGN pcFollowJoins = "Main: " + ENTRY(1,cTableList,"|") + ' - '.
    DO iLoop = 1 TO NUM-ENTRIES(cFieldList,"|"):
       ASSIGN cFileName = ENTRY(iLoop,cFieldList,"|").
       IF ENTRY(2,cFileName,".") = ENTRY(1,cTableList,"|")
          THEN ASSIGN pcFollowJoins = pcFollowJoins + 
                                      (IF iLoop = 1
                                       THEN "" 
                                       ELSE ",") +  
                                       ENTRY(3,(ENTRY(iLoop,cFieldList,"|")),".").
    END.
    /* Then get the joined table fields */
    DO iLoop = 1 TO NUM-ENTRIES(cFieldList,"|"):
       ASSIGN cFileName = ENTRY(iLoop,cFieldList,"|").
       IF ENTRY(2,cFileName,".") <> ENTRY(1,cTableList,"|")
          THEN ASSIGN pcFollowJoins = pcFollowJoins +
                                     (IF iLoop = 1
                                      THEN "Join Field: " 
                                      ELSE ",Join Field: ") +
                                      REPLACE(ENTRY(iLoop,cFieldList,"|"),"ICFDB.","").
    END.

    ASSIGN
      
      iLoop      = 1
      cSortList  = getAKFields(ENTRY(1,cTableList,"|":U))
      cQueryList = pcQueryList + " ~~":U + CHR(10).

      IF csortlist <> "" AND csortlist <> ? THEN 
        cQueryList = cQueryList + " BY ":U + REPLACE(cSortList,",":U," BY ":U) + " INDEXED-REPOSITION.":U.
      ELSE 
        cQueryList = cQueryList + ".".

    /* Build an enabled fields list */
    DO iLoop = 1 to NUM-ENTRIES(cFieldList,"|"):
        /* If the field is in the main table and it is not the main table _obj then it is enabled */
        /* strip off the database and table name from the field list*/
        IF ENTRY(2,ENTRY(iLoop,cFieldList,"|":U),".":U) = ENTRY(1,cTableList,"|":U) THEN
        DO:
           IF (AVAILABLE gsc_entity_mnemonic AND gsc_entity_mnemonic.TABLE_has_object_field AND gsc_entity_mnemonic.entity_object_field NE ""
               AND ENTRY(3,ENTRY(iLoop,cFieldList,"|":U),".":U) NE gsc_entity_mnemonic.entity_object_field)
               OR
               (REPLACE(ENTRY(3,ENTRY(iLoop,cFieldList,"|":U),".":U),"_obj":U,"":U) 
                  <> SUBSTRING(ENTRY(1,cTableList,"|":U),INDEX(ENTRY(1,cTableList,"|":U),"_") + 1))
           THEN
               ASSIGN
                   cEnablList = cEnablList + "|":U WHEN cEnablList <> "":U
                   cEnablList = cEnablList + ENTRY(3,ENTRY(iLoop,cFieldList,"|":U),".":U).
        END.
        /*Strip off the database and table name from all fields in field list*/
        ASSIGN
            cDataList  = cDataList  + "|":U WHEN cDataList <> "":U
            cDataList  = cDataList  + ENTRY(3,ENTRY(iLoop,cFieldList,"|":U),".":U).

    END.
    DO WITH FRAME {&FRAME-NAME}:

        ASSIGN
            eEdit:SENSITIVE = NO
            eEdit:VISIBLE   = NO
            eEdit:PROGRESS-SOURCE = YES.

        eEdit:READ-FILE(pcReadFile).
        /*Fixes problems when template files deployed on unix*/
        editFixCRLF().

        &IF "{&DIAG}" EQ "YES":U &THEN
        ENABLE eEdit. 
        &ENDIF

        /*Remove procedure description*/
        RUN EditFind(INPUT "&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2",
                        INPUT "&ANALYZE-RESUME",
                        OUTPUT iOffset).

        /*Replace wizard extended feature*/
        RUN EditFind(INPUT "/* Static SmartDataObject Wizard",
                        INPUT "/* _UIB-CODE-BLOCK-END */",
                        OUTPUT iOffset).
        eEdit:INSERT-STRING("Destroy on next read */").
        /*Insert connected databases*/                
        RUN EditFind(INPUT "&ANALYZE-RESUME",
                        INPUT "&Scoped-define WINDOW-NAME CURRENT-WINDOW",
                        OUTPUT iOffset).
        eEdit:INSERT-STRING(CHR(10) + "/* Connected Databases" + CHR(10) + cCondbList + CHR(10) + "*/").
        /*Update Settings for THIS-PROCEDURE*/
        RUN EditFind(INPUT "/* Settings for THIS-PROCEDURE",
                        INPUT "   Allow: Query",
                        OUTPUT iOffset).
        eEdit:INSERT-STRING("   Type: SmartDataObject").
        /*Update the name of the procedure*/

        RUN EditReplace(INPUT "&scop object-name",
                           INPUT ".w",
                           INPUT "&scop object-name       " + ENTRY(NUM-ENTRIES(pcSaveFile,"/":U),pcSaveFile,"/":U),
                           OUTPUT iOffset).

        /*Update the name of the procedure - with a relative path ! */
        /*
        MESSAGE pcLogicSaveFile SKIP pcRootDir SKIP REPLACE(REPLACE(pcLogicSaveFile,"~\":U,"/":U),REPLACE(pcRootDir,"~\":U,"/":U) + "/":U,"":U).
        */
        RUN EditReplace(INPUT "&glob DATA-LOGIC-PROCEDURE",
                           INPUT ".p",
                           INPUT "&glob DATA-LOGIC-PROCEDURE       " + REPLACE(REPLACE(pcLogicSaveFile,"~\":U,"/":U),REPLACE(pcRootDir,"~\":U,"/":U) + "/":U,"":U),
                           OUTPUT iOffset).

        /*Now start updating the query information*/
        RUN EditFind(INPUT "&Scoped-define QUERY-NAME Query-Main",
                        INPUT "/* Custom List Definitions                                              */",
                        OUTPUT iOffset).
        /*Put all tables in the join in INTERNAL-TABLES*/
        eEdit:INSERT-STRING(CHR(10) + "/* Internal Tables (found by Frame, Query & Browse Queries)             */" + CHR(10)).
        eEdit:INSERT-STRING("&SCOPED-DEFINE INTERNAL-TABLES " + REPLACE(cTableList,"|"," ") + CHR(10)).
        /*Put all enabled fields in the main table in ENABLED-FIELDS*/
        eEdit:INSERT-STRING("&SCOPED-DEFINE ENABLED-FIELDS " + REPLACE(cEnablList,"|"," ") + CHR(10)).
        /*Put all enabled fields in the main table in ENABLED-FIELDS-IN-main table*/
        eEdit:INSERT-STRING("&SCOPED-DEFINE ENABLED-FIELDS-IN-" + ENTRY(1,cTableList,"|") + " ":U + REPLACE(cEnablList,"|"," ") + CHR(10)).
        /*No fields in joined tables will be enabled, so the ENABLED-FIELDS-IN- is defined empty*/
        DO iLoop = 2 TO NUM-ENTRIES(cTableList,"|"):
            eEdit:INSERT-STRING("&SCOPED-DEFINE ENABLED-FIELDS-IN-" + ENTRY(iLoop,cTableList,"|") + CHR(10)).
        END.
        /*Put all fields in the join in DATA-FIELDS*/
        eEdit:INSERT-STRING("&SCOPED-DEFINE DATA-FIELDS " + REPLACE(cDataList,"|"," ") + CHR(10)).
        /*Put all fields per table in the join in DATA-FIELDS-IN-table*/
        DO iLoop = 1 TO NUM-ENTRIES(cTableList,"|"):
            cDataList = "":U.
            DO iCount = 1 TO NUM-ENTRIES(cFieldList,"|"):
                IF ENTRY(2,ENTRY(iCount,cFieldList,"|":U),".":U) = ENTRY(iLoop,cTableList,"|":U) THEN
                    ASSIGN
                        cDataList = cDataList + "|":U WHEN cDataList <> "":U
                        cDataList = cDataList + ENTRY(3,ENTRY(iCount,cFieldList,"|":U),".":U).
            END.
            eEdit:INSERT-STRING("&SCOPED-DEFINE DATA-FIELDS-IN-" + ENTRY(iLoop,cTableList,"|") + " ":U + REPLACE(cDataList,"|"," ":U) + CHR(10)).
        END.
        
        /*Put in all the other gumf*/
        ASSIGN
          FILE-INFO:FILE-NAME = pcSaveFile
          cPathName = REPLACE(REPLACE(REPLACE(REPLACE(FILE-INFO:PATHNAME,"~\":U,"/":U),pcRootDir + "/":U,""),"~\":U,"/":U),".w":U,".i":U).
            /*REPLACE(REPLACE(REPLACE(FILE-INFO:PATHNAME,REPLACE(pcRootDir,"/":U,"~\":U) + "\":U,"":U),".w",".i"),"~\":U,"/":U).*/
        eEdit:INSERT-STRING("&SCOPED-DEFINE MANDATORY-FIELDS" + CHR(10)).
        eEdit:INSERT-STRING("&SCOPED-DEFINE APPLICATION-SERVICE" + CHR(10)).
        eEdit:INSERT-STRING("&SCOPED-DEFINE ASSIGN-LIST" + CHR(10)).
        eEdit:INSERT-STRING('&SCOPED-DEFINE DATA-FIELD-DEFS "' + cPathName + '"' + CHR(10)).
        eEdit:INSERT-STRING('&SCOPED-DEFINE QUERY-STRING-Query-Main ' + cQueryList + CHR(10)).
        eEdit:INSERT-STRING("~{&DB-REQUIRED-START~}" + CHR(10)).
        /*Put the query in OPEN-QUERY-Query-Main*/
        eEdit:INSERT-STRING("&SCOPED-DEFINE OPEN-QUERY-Query-Main OPEN QUERY Query-Main " + cQueryList + CHR(10)).
        eEdit:INSERT-STRING("~{&DB-REQUIRED-END~}" + CHR(10)).
        /*Put all tables in the join in TABLES-IN-QUERY-Query-Main*/
        eEdit:INSERT-STRING("&SCOPED-DEFINE TABLES-IN-QUERY-Query-Main " + REPLACE(cTableList,"|"," ") + CHR(10)).
        /*Put each table in the query seperately*/
        DO iLoop = 1 TO NUM-ENTRIES(cTableList,"|"):
            eEdit:INSERT-STRING("&SCOPED-DEFINE " + ENTRY(iLoop,{&TABLELIST},"|") + "-TABLE-IN-QUERY-Query-Main " + ENTRY(iLoop,cTableList,"|") + CHR(10)).
        END.

        /*Find the second section*/
        RUN EditFind(INPUT "/* ***********************  Control Definitions  ********************** */",
                        INPUT "/* ************************  Frame Definitions  *********************** */",
                        OUTPUT iOffset).
        /*Put in all the other gumf*/
        eEdit:INSERT-STRING("~{&DB-REQUIRED-START~}" + CHR(10)).
        eEdit:INSERT-STRING("/* Query definitions                                                    */" + CHR(10)).
        eEdit:INSERT-STRING("&ANALYZE-SUSPEND" + CHR(10)).
        eEdit:INSERT-STRING("DEFINE QUERY Query-Main FOR" + CHR(10)).
        /*All fields in the main table is returned*/
        cDataList = IF NUM-ENTRIES(cTableList,"|") > 1 THEN ",":U ELSE "":U.
        eEdit:INSERT-STRING("    " + ENTRY(1,cTableList,"|") + cDataList + CHR(10)).
        /*Only fields selected in joined tables is returned*/
        DO iLoop = 2 TO NUM-ENTRIES(cTableList,"|"):
            cDataList = "":U.
            DO iCount = 1 TO NUM-ENTRIES(cFieldList,"|"):
                IF ENTRY(2,ENTRY(iCount,cFieldList,"|":U),".":U) = ENTRY(iLoop,cTableList,"|":U) THEN
                    ASSIGN
                        cDataList = cDataList + "|":U WHEN cDataList <> "":U
                        cDataList = cDataList + ENTRY(iLoop,cTableList,"|") + "." + ENTRY(3,ENTRY(iCount,cFieldList,"|":U),".":U).
            END.
            eEdit:INSERT-STRING("    " + ENTRY(iLoop,cTableList,"|") + " FIELDS(":U + REPLACE(cDataList,"|"," ":U)).
            IF iLoop < NUM-ENTRIES(cTableList,"|") THEN
                eEdit:INSERT-STRING(")," + CHR(10)).
            ELSE
                eEdit:INSERT-STRING(")"  + CHR(10)).
        END.

        eEdit:INSERT-STRING(" SCROLLING." + CHR(10)).
        /*Put in all the other gumf*/
        eEdit:INSERT-STRING("&ANALYZE-RESUME" + CHR(10)).
        eEdit:INSERT-STRING("~{&DB-REQUIRED-END~}" + CHR(10)).

        /*Find the third section*/ 
        RUN EditFind(INPUT "&ANALYZE-SUSPEND _QUERY-BLOCK QUERY Query-Main",
                        INPUT "&ANALYZE-RESUME",
                        OUTPUT iOffset). 
        eEdit:INSERT-STRING("/* Query rebuild information for SmartDataObject Query-Main" + CHR(10)).
        /*_TblList*/
        cDataList = '     _TblList          = "' + ENTRY(1,cDBaseList,"|").
        DO iLoop = 2 TO NUM-ENTRIES(cDBaseList,"|"):
            ASSIGN
                cDataList = cDataList + ",":U WHEN cDataList <> "":U
                cDataList = cDataList + ENTRY(iLoop,cDbaseList,"|") + " WHERE " + ENTRY(1,cDBaseList,"|") + " ...".
        END.
        cDataList = cDataList + '"'.
        eEdit:INSERT-STRING(cDataList + CHR(10)).
        /*_Options*/
        eEdit:INSERT-STRING('     _Options          = "NO-LOCK INDEXED-REPOSITION "' + CHR(10)).
        /*_TblOptList*/
        cDataList = '     _TblOptList       = "'.
        DO iLoop = 2 TO NUM-ENTRIES(cDBaseList,"|"):
            ASSIGN
                cDataList = cDataList + ",":U WHEN cDataList <> "":U
                cDataList = cDataList + " FIRST USED".
        END.
        cDataList = cDataList + '"'.
        eEdit:INSERT-STRING(cDataList + CHR(10)).
        /*_OrdList*/
        cDataList = '' .
        IF csortlist NE "":U AND csortlist NE ? THEN 
            cDataList = '     _OrdList          = "' + REPLACE(cSortList,",":U,"|yes,") + '|yes"'.

        DO iLoop = 1 TO NUM-ENTRIES(cDBaseList,"|":U):
            IF INDEX(cDataList,ENTRY(iLoop,cTableList,"|":U)) GT 0 THEN
               SUBSTRING(cDataList,INDEX(cDataList,ENTRY(iLoop,cTableList,"|":U)),LENGTH(ENTRY(iLoop,cTableList,"|":U))) 
                  = ENTRY(iLoop,cDBaseList,"|":U).
        END.
        eEdit:INSERT-STRING(cDataList + CHR(10)).
        /*_JoinCode and _FldNameList*/
        FOR EACH tt_fieldtable NO-LOCK:
            eEdit:INSERT-STRING(tt_fieldtable.tt_data + CHR(10)).
        END.
        eEdit:INSERT-STRING("     _Design-Parent    is WINDOW dTables @ ( 1.14 , 2.6 )" + CHR(10)).
        eEdit:INSERT-STRING("*/  /* QUERY Query-Main */" + CHR(10)).

        /* ICF -- moved generation of preTransactionValidate and
           rowObjectValidate to logic file below. jrs */

        eEdit:SAVE-FILE(pcSaveFile).

        OUTPUT STREAM sStream TO VALUE(REPLACE(pcSaveFile,".w",".i")).
        DO iLoop = 1 to NUM-ENTRIES(cFieldList,"|"):

            PUT STREAM sStream UNFORMATTED
                "  FIELD " + ENTRY(3,ENTRY(iLoop,cFieldList,"|"),".") + 
                " LIKE " + ENTRY(2,ENTRY(iLoop,cFieldList,"|"),".") + 
                "."      + ENTRY(3,ENTRY(iLoop,cFieldList,"|"),".") + 
                IF plSuppressValidate THEN CHR(10) ELSE " VALIDATE ~~" + 
                CHR(10).

        END.
        OUTPUT STREAM sStream CLOSE.

        OUTPUT STREAM sStream TO VALUE(REPLACE(pcSaveFile,".w","_cl.w")).
        ASSIGN
            FILE-INFO:FILE-NAME = pcSaveFile
            cPathName = REPLACE(REPLACE(FILE-INFO:PATHNAME,"~\":U,"/":U),REPLACE(pcRootDir,"~\":U,"/":U) + "/":U,"":U).
        PUT STREAM sStream UNFORMATTED
            '/* ' + REPLACE(cPathname,".w","_cl.w") + ' - non-db proxy for ' + cPathname + ' */ ' SKIP(1)
            '&GLOBAL-DEFINE DB-REQUIRED FALSE' SKIP(1)
            '~{"' + cPathname + '"~}' SKIP.
        OUTPUT STREAM sStream CLOSE.

        /* ICF -- jrs -- 3/23/01 -- generate new SDO logic procedure to
           put all the business logic into. */
        /* Open the template for the SDO logic procedure -- datalogic.p */
        eEdit:READ-FILE(pcLogicReadFile).
        pcLogicSaveFile = REPLACE(pcLogicSaveFile, "~\":U, "/":U).

        /*Fixes problems when template files deployed on unix*/
        editFixCRLF().

        RUN EditReplace(INPUT "  File:         logic",
                           INPUT ".p",
                           INPUT "  File:         " + ENTRY(NUM-ENTRIES(pcLogicSaveFile,"/":U),pcLogicSaveFile,"/":U),
                           OUTPUT iOffset).

        RUN EditReplace(INPUT "  Description:  Data ",
                           INPUT "Logic",
                           INPUT "  Description:  " + ENTRY(1,cTableList,"|":U) + " Data Logic",
                           OUTPUT iOffset).

        RUN EditReplace(INPUT "data-",
                           INPUT "logic",
                           INPUT ENTRY(1,cTableList,"|":U),
                           OUTPUT iOffset).

        RUN EditReplace(INPUT "&scop object-name",
                           INPUT ".p",
                           INPUT "&scop object-name       " + ENTRY(NUM-ENTRIES(pcLogicSaveFile,"/":U),pcLogicSaveFile,"/":U),
                           OUTPUT iOffset).

        RUN EditFind(INPUT  "/* Data Preprocessor Definitions */":U,
                     INPUT  "/* Error handling definitions */":U,
                     OUTPUT iOffset).

        eEdit:INSERT-STRING("&GLOB DATA-LOGIC-TABLE " + ENTRY(1,cTableList,"|":U) + CHR(10)).
        eEdit:INSERT-STRING('&GLOB DATA-FIELD-DEFS  "' + REPLACE(cPathName,".w":U,".i":U) + '"':U + CHR(10)).

        RUN EditReplace(INPUT "ASSIGN cDescription = ",
                        INPUT "PLIP",
                        INPUT 'ASSIGN cDescription = "' +  ENTRY(1,cTableList,"|":U) + ' Data Logic Procedure',
                        OUTPUT iOffset).

        eEdit:CURSOR-OFFSET = iOffset.               
        /* Put the standard businesslogic into the new procedure. */
        RUN addProcedure("createPreTransValidate":U,
                         "Procedure used to validate records server-side before the transaction scope upon create":U,
                         YES,
                         OUTPUT iOffset).

        eEdit:CURSOR-OFFSET = iOffset.       
        eEdit:INSERT-STRING(buildCreatePreTransValidate(ENTRY(1,cTableList,"|":U))).


        RUN addProcedure("writePreTransValidate":U,
                         "Procedure used to validate records server-side before the transaction scope upon write":U,
                         YES,
                         OUTPUT iOffset).

        eEdit:CURSOR-OFFSET = iOffset.       
        eEdit:INSERT-STRING(buildWritePreTransValidate(ENTRY(1,cTableList,"|":U))).


        RUN addProcedure("rowObjectValidate":U,
                         "Procedure used to validate RowObject record client-side":U,
                         NO,
                         OUTPUT iOffset).
        eEdit:CURSOR-OFFSET = iOffset.
        eEdit:INSERT-STRING(buildRowObjectValidate(ENTRY(1,cTableList,"|":U))).

        eEdit:SAVE-FILE(pcLogicSaveFile).

        OUTPUT STREAM sStream TO VALUE(REPLACE(pcLogicSaveFile,".p","_cl.p")).
        ASSIGN
            FILE-INFO:FILE-NAME = pcLogicSaveFile
            cPathName = REPLACE(REPLACE(FILE-INFO:PATHNAME,"~\":U,"/":U),REPLACE(pcRootDir,"~\":U,"/":U) + "/":U,"":U).
        PUT STREAM sStream UNFORMATTED
            '/* ' + REPLACE(cPathname,".p","_cl.p") + ' - non-db proxy for ' + cPathname + ' */ ' SKIP(1)
            '&GLOBAL-DEFINE DB-REQUIRED FALSE' SKIP(1)
            '~{"' + cPathname + '"~}' SKIP.
        OUTPUT STREAM sStream CLOSE.


        /* ICF -- end code to save SDO logic procedure file. */
    END.
    
    /* Compile the sdo.w  This doesn't work because the SDOs need to be */
    /* read into the AppBuilder and written out to compile.  - DRH  
    RUN adecomm/_adeevnt.p ("ICF":U, "BEFORE-COMPILE", " ":U /* context identifier */, pcSaveFile,
                            OUTPUT ok2continue).      

    IF ok2continue THEN DO:
      /* Can we compile into the Save into directory? */    
      COMPILE-BLK:
      DO ON STOP UNDO COMPILE-BLK, LEAVE COMPILE-BLK
         ON ERROR UNDO COMPILE-BLK, LEAVE COMPILE-BLK:
        COMPILE VALUE(pcSaveFile) SAVE NO-ERROR.
      END. /* COMPILE-BLK */
    END.  /*IF ok2continue */

    /* Note that the compile is over. */
    RUN adecomm/_adeevnt.p ("ICF":U, "COMPILE", " ":U /* context identifier */, pcSaveFile,
                            OUTPUT ok2continue). 


    IF NOT COMPILER:ERROR THEN DO:
      /* Compile the sdo_cl.w */
      RUN adecomm/_adeevnt.p ("ICF":U, "BEFORE-COMPILE", " ":U /* context identifier */, cProxyFile,
                              OUTPUT ok2continue).      
      IF ok2continue THEN DO:
        COMPILE-PROXY-BLK:
        DO ON STOP UNDO COMPILE-PROXY-BLK, LEAVE COMPILE-PROXY-BLK
           ON ERROR UNDO COMPILE-PROXY-BLK, LEAVE COMPILE-PROXY-BLK:
          COMPILE VALUE(cProxyFile) SAVE NO-ERROR.
        END.  /* COMPILE-PROXY-BLK */
      END.  /* IF ok2continue */

      /* Note that the compile is over. */
      RUN adecomm/_adeevnt.p ("ICF":U, "COMPILE", " ":U /* context identifier */, cProxyFile,
                              OUTPUT ok2continue). 
    END.  /* IF no error from the SDO compile */
    */

END PROCEDURE.

PROCEDURE addProcedure:
/*------------------------------------------------------------------------------
  Purpose:     addProcedure
  Notes:       Adds a procedure if it does not exist and positions the editor cursor
               at the start of the procedure, ready to receive text. If the procedure exists,
               does nothing
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcProcedureName  AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcPurpose        AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER plRequired       AS LOGICAL    NO-UNDO.
  DEFINE OUTPUT PARAMETER piLine           AS INTEGER    NO-UNDO.

  DEFINE VARIABLE iStart     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iEnd       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lExists    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cRequired  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iOffset    AS INTEGER    NO-UNDO.

  IF plRequired THEN
    cRequired = "_DB-REQUIRED".

      DO WITH FRAME {&FRAME-NAME}:
          eEdit:CURSOR-OFFSET = 1.
          eEdit:SEARCH("/* **********************  Internal Procedures",5).
          lExists = eEdit:SEARCH(pcProcedureName,5).
          IF lExists THEN RETURN.
          lExists = eEdit:SEARCH("/* ************************  Function Implementations",5).
          IF lExists 
          THEN eEdit:CURSOR-LINE = eEdit:CURSOR-LINE - 1.
          ELSE eEdit:MOVE-TO-EOF().
          eEdit:INSERT-STRING(CHR(10)).
          IF plRequired THEN eEdit:INSERT-STRING("~{&DB-REQUIRED-START~}" + CHR(10)).
          eEdit:INSERT-STRING("&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE " + pcProcedureName + " dTables " + cRequired + CHR(10)).
          eEdit:INSERT-STRING("PROCEDURE " + pcProcedureName + " : " + CHR(10)).
          eEdit:INSERT-STRING("/*------------------------------------------------------------------------------" + CHR(10)).
          eEdit:INSERT-STRING("  Purpose:     " + pcPurpose + CHR(10)).
          eEdit:INSERT-STRING("  Parameters:  <none>" + CHR(10)).
          eEdit:INSERT-STRING("  Notes:       " + CHR(10)).
          eEdit:INSERT-STRING("------------------------------------------------------------------------------*/" + CHR(10) + CHR(10)).
          eEdit:INSERT-STRING("  DEFINE VARIABLE cMessageList    AS CHARACTER    NO-UNDO." + CHR(10)).
          eEdit:INSERT-STRING("  DEFINE VARIABLE cValueList      AS CHARACTER    NO-UNDO." + CHR(10) + CHR(10)).
          piLine = eEdit:CURSOR-OFFSET.
          eEdit:INSERT-STRING("  ERROR-STATUS:ERROR = NO." + CHR(10)).
          eEdit:INSERT-STRING("  RETURN cMessageList." + CHR(10) + CHR(10)).
          eEdit:INSERT-STRING("END PROCEDURE." + CHR(10) + CHR(10)).
          eEdit:INSERT-STRING("/* _UIB-CODE-BLOCK-END */" + CHR(10) + "&ANALYZE-RESUME" + CHR(10)).
          IF plRequired THEN eEdit:INSERT-STRING("~{&DB-REQUIRED-END~}" + CHR(10)).

      END.

END PROCEDURE.

PROCEDURE EditFind:
/*------------------------------------------------------------------------------
  Purpose:     EditFind
  Notes:       Clears the section between the specified phrases, 
               retuning the start position
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcFrom  AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcUpto  AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER piStart AS INTEGER    NO-UNDO.

DEFINE VARIABLE iStart     AS INTEGER    NO-UNDO.
DEFINE VARIABLE iEnd       AS INTEGER    NO-UNDO.

    DO WITH FRAME {&FRAME-NAME}:
        eEdit:CURSOR-OFFSET = 1.
        eEdit:SEARCH(pcFrom,5).
        iStart = eEdit:CURSOR-OFFSET.
        eEdit:SEARCH(pcUpto,1).
        iEnd = eEdit:CONVERT-TO-OFFSET(eEdit:CURSOR-LINE,1) - 1.
        IF iStart > 1 THEN DO:
            eEdit:SET-SELECTION ( iStart , iEnd ).
            eEdit:REPLACE-SELECTION-TEXT(chr(10)).
            piStart = eEdit:CURSOR-OFFSET.
        END.
    END.
END PROCEDURE.

PROCEDURE EditReplace:
/*------------------------------------------------------------------------------
  Purpose:     ReplaceLine
  Notes:       Clears the first line containing the phrase and replaces it 
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcFrom    AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcUpto    AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcReplace AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER piStart AS INTEGER    NO-UNDO.

DEFINE VARIABLE iStart     AS INTEGER    NO-UNDO.
DEFINE VARIABLE iEnd       AS INTEGER    NO-UNDO.

    DO WITH FRAME {&FRAME-NAME}:
        eEdit:CURSOR-OFFSET = 1.
        eEdit:SEARCH(pcFrom,37).
        iStart = eEdit:SELECTION-START.
        eEdit:SEARCH(pcUpto,37).
        iEnd = eEdit:SELECTION-END.
        IF iStart > 1 THEN DO:
            eEdit:SET-SELECTION ( iStart , iEnd ).
            eEdit:REPLACE-SELECTION-TEXT(pcReplace).
            piStart = eEdit:CURSOR-OFFSET.
        END.
    END.
END PROCEDURE.


PROCEDURE FollowLinks :
/*------------------------------------------------------------------------------
  Purpose:     FollowLinks
  Parameters:  <none>
  Notes:       Follows the joins to a table and assigns the fields to display
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER ip_method            AS CHARACTER    NO-UNDO.
DEFINE INPUT PARAMETER ip_sortField         AS INTEGER      NO-UNDO.
DEFINE INPUT PARAMETER plSuppressValidate   AS LOGICAL      NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER ip_query_list AS CHARACTER    NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER ip_field_list AS CHARACTER    NO-UNDO.

DEFINE VARIABLE lv_value_table  AS CHARACTER    NO-UNDO.
DEFINE VARIABLE lv_lookup_list  AS CHARACTER    NO-UNDO.
DEFINE VARIABLE lv_first        AS LOGICAL      NO-UNDO.
DEFINE VARIABLE lv_found        AS LOGICAL      NO-UNDO.
DEFINE VARIABLE lv_cnt          AS INTEGER      NO-UNDO.
DEFINE VARIABLE lv_join         AS INTEGER      NO-UNDO INITIAL 1.
DEFINE VARIABLE lv_field        AS INTEGER      NO-UNDO.
DEFINE VARIABLE cEnabled        AS CHARACTER    NO-UNDO.
DEFINE VARIABLE iIndex          AS INTEGER      NO-UNDO.

DEFINE BUFFER lb_file   FOR tt_filetable.
DEFINE BUFFER lb_field  FOR tt_filetable.
DEFINE BUFFER lb_file2  FOR tt_filetable.
DEFINE BUFFER lb_field2 FOR tt_filetable.

/* if ip_sortField is _order (1) then sort by tt_data[2] */
/* if ip_sortField is _field-name (2) then sort by tt_data[3] */
ASSIGN iIndex = 2. /* by order sequence */
IF ip_sortField = 2 THEN ASSIGN iIndex = 3. /* by field name */

    EMPTY TEMP-TABLE tt_filetable.

    ASSIGN lv_value_table    = ENTRY(LOOKUP("EACH",ip_query_list," ") + 1,ip_query_list," ")
           lv_value_table    = IF NUM-ENTRIES(lv_value_table,".") > 1 THEN ENTRY(2,lv_value_table,".") ELSE lv_value_table
           .
    /* Build a temp-table of all the _File and _Field records for all the connected DB's.
     * This  procedure replaces all getLinkData calls.                                   */
    DO lv_cnt = 1 TO NUM-DBS:
        RUN getDbData ( INPUT LDBNAME(lv_cnt) ).
    END.    /* lv_cnt */

    /*Find the temp-table record for the first table in the query*/
    /*tt_type = _file, tt_tag = file-name*/
    FIND FIRST lb_file NO-LOCK
        WHERE lb_file.tt_type = "_file":U
        AND   lb_file.tt_tag  = lv_value_table NO-ERROR.
    IF AVAILABLE lb_file THEN
    DO:
        /* Read the gsc_entity_mnemonic record related to the first table in the query */
        FIND FIRST gsc_entity_mnemonic NO-LOCK
             WHERE gsc_entity_mnemonic.entity_mnemonic_description = lv_value_table
             NO-ERROR.

        /*for each temp-table _field record of the first table in the query*/
        /*lb_field.tt_tag = _file-recid  lb_file.tt_data[2] = recid(_file)*/
        FOR EACH  lb_field NO-LOCK
            WHERE lb_field.tt_db   = lb_file.tt_db
              AND lb_field.tt_type = "_field":U
              AND lb_field.tt_tag  = lb_file.tt_data[2]
               BY lb_field.tt_db 
               BY lb_field.tt_type 
               BY lb_field.tt_data[iIndex]:

            /* All fields on the main table except the table's obj must be enabled */
            IF  AVAILABLE gsc_entity_mnemonic 
            AND gsc_entity_mnemonic.table_has_object_field 
            AND gsc_entity_mnemonic.entity_object_field NE ""
            THEN
                cEnabled = IF gsc_entity_mnemonic.entity_object_field EQ lb_field.tt_data[3] THEN "no" ELSE "yes".
            ELSE
                cEnabled = IF SUBSTRING(lb_file.tt_tag,INDEX(lb_file.tt_tag,"_") + 1) = REPLACE(lb_field.tt_data[3],"_obj":U,"":U) THEN
                              "no"
                           ELSE 
                              "yes".

            /* If the _field-name does not end in _obj then build the field list of all fields on the first table */
            IF ((NOT lb_field.tt_data[3] MATCHES "*_obj") AND ip_method = "FOLLOW":U) OR ip_method = "NORMAL":U THEN 
                IF LOOKUP(lb_file.tt_db + ".":U + lb_file.tt_tag + ".":U + lb_field.tt_data[3],ip_field_list,"|") = 0 
                THEN DO:
                    CREATE tt_fieldtable.
                    ASSIGN
                        ip_field_list = ip_field_list + "|":U + lb_file.tt_db + ".":U + lb_file.tt_tag + ".":U + lb_field.tt_data[3]
                        lv_field             = lv_field + 1
                        tt_fieldtable.tt_tag  = 100 + lv_field
                        tt_fieldtable.tt_data = '     _FldNameList['+ STRING(lv_field) + ']   > ' + 
                                               lb_file.tt_db + ".":U + lb_file.tt_tag + ".":U + lb_field.tt_data[3] + CHR(10) + 
                                               ' "' + lb_field.tt_data[3] + '"' + ' "' + lb_field.tt_data[3] + '" ? ?' +
                                               ' "' + lb_field.tt_data[5] + '" ? ? ? ? ? ? ' + cEnabled + ' ? no ' +
                                               lb_field.tt_data[6] + 
                        IF plSuppressValidate THEN ' no' ELSE ' yes'.
                END.

            /* If the _field-name does end in _obj */
            IF lb_field.tt_data[3] MATCHES "*_obj" AND CAN-DO("FOLLOW*":U,ip_method)
            THEN OBJ-BLOCK: DO:

                /*Add it to the field list anyway*/
                CREATE tt_fieldtable.
                ASSIGN
                    ip_field_list = ip_field_list + "|":U + lb_file.tt_db + ".":U + lb_file.tt_tag + ".":U + lb_field.tt_data[3]
                    lv_field      = lv_field + 1
                    tt_fieldtable.tt_tag  = 100 + lv_field
                    tt_fieldtable.tt_data = '     _FldNameList['+ STRING(lv_field) + ']   > ' + 
                                           lb_file.tt_db + ".":U + lb_file.tt_tag + ".":U + lb_field.tt_data[3] + CHR(10) +
                                           ' "' + lb_field.tt_data[3] + '"' + ' "' + lb_field.tt_data[3] + '" ? ?' +
                                           ' "' + lb_field.tt_data[5] + '" ? ? ? ? ? ? ' + cEnabled + ' ? no ' +
                                           lb_field.tt_data[6] + ' yes'.

                /*Find temp-table _file record that matches the field-name first in the same database as the field*/
                FIND FIRST lb_file2 NO-LOCK
                    WHERE lb_file2.tt_db = lb_field.tt_db
                    AND   SUBSTRING(lb_file2.tt_tag,INDEX(lb_file2.tt_tag,"_") + 1) = REPLACE(lb_field.tt_data[3],"_obj":U,"":U)
                    NO-ERROR.
                /*If it's not available in this find temp-table _file record that matches the field-name first in any database*/
                IF NOT AVAILABLE lb_file2 THEN
                FIND FIRST lb_file2 NO-LOCK
                    WHERE SUBSTRING(lb_file2.tt_tag,INDEX(lb_file2.tt_tag,"_") + 1) = REPLACE(lb_field.tt_data[3],"_obj":U,"":U)
                    NO-ERROR.

                ASSIGN
                    lv_lookup_list = {&ROLENAME}.
                /*If it's not found yet, find temp-table that matches the lookup-list entries (ROLENAMES) as prefixes*/
                IF NOT AVAILABLE lb_file2
                THEN DO lv_cnt = 1 TO NUM-ENTRIES(lv_lookup_list,"|":U):
                    IF INDEX(lb_field.tt_data[3],ENTRY(lv_cnt,lv_lookup_list,"|":U)) <> 0
                    THEN DO:
                        /*Find temp-table _file record that matches the lookup-list entries in the same database as the field*/
                        FIND FIRST lb_file2 NO-LOCK
                            WHERE lb_file2.tt_db = lb_field.tt_db
                            AND   SUBSTRING(lb_file2.tt_tag,INDEX(lb_file2.tt_tag,"_") + 1) = REPLACE(REPLACE(lb_field.tt_data[3],"_obj":U,"":U),ENTRY(lv_cnt,lv_lookup_list,"|":U),"":U)
                            NO-ERROR.
                        /*If it's not available in this find temp-table _file record that matches the lookup-list entries in any database*/
                        IF NOT AVAILABLE lb_file2 THEN
                        FIND FIRST lb_file2 NO-LOCK
                            WHERE SUBSTRING(lb_file2.tt_tag,INDEX(lb_file2.tt_tag,"_") + 1) = REPLACE(REPLACE(lb_field.tt_data[3],"_obj":U,"":U),ENTRY(lv_cnt,lv_lookup_list,"|":U),"":U)
                            NO-ERROR.
                    END.
                END.

                IF AVAILABLE lb_file2 AND lb_file2.tt_tag <> lb_file.tt_tag
                THEN DO:
                    ASSIGN
                        lv_first = NO
                        lv_lookup_list = {&FIELDNAME}.

                    LOOKUP-BLOCK:
                    DO lv_cnt = 1 to NUM-ENTRIES(lv_lookup_list,"|":U):
                        ASSIGN
                            lv_found = NO.
                        IF NOT lv_found THEN FOR EACH lb_field2 NO-LOCK
                            WHERE lb_field2.tt_db   = lb_file2.tt_db
                            AND   lb_field2.tt_type = "_field":U
                            AND   lb_field2.tt_tag  = lb_file2.tt_data[2]
                            BY lb_field2.tt_db
                            BY lb_field2.tt_type
                            BY lb_field2.tt_data[iIndex]:

                            IF NOT lv_found AND CAN-DO(ENTRY(lv_cnt,lv_lookup_list,"|":U),lb_field2.tt_data[3]) 
                            THEN DO:
                                /*Add the related table find to the query_list. Note the related _file-name is used */
                                /*to derive the _field-name in the where clause because of the field names may not be the same in */
                                IF NOT lv_first THEN DO:
                                    CREATE tt_fieldtable.
                                    ASSIGN
                                        ip_query_list = ip_query_list + ", ~~" + CHR(13) + " FIRST ":U + lb_file2.tt_db + "." + lb_file2.tt_tag 
                                        ip_query_list = ip_query_list + " WHERE ":U + lb_file2.tt_db + "." + lb_file2.tt_tag + ".":U + SUBSTRING(lb_file2.tt_tag,INDEX(lb_file2.tt_tag,"_":U) + 1) + "_obj" + " = ":U + lb_file.tt_db + "." + lb_file.tt_tag + ".":U + lb_field.tt_data[3] + " NO-LOCK ":U
                                        lv_first      = YES
                                        lv_join       = lv_join + 1
                                        tt_fieldtable.tt_tag  = lv_join
                                        tt_fieldtable.tt_data = '     _JoinCode[' + STRING(lv_join) + ']      = "' + lb_file2.tt_db + "." + lb_file2.tt_tag + ".":U + SUBSTRING(lb_file2.tt_tag,INDEX(lb_file2.tt_tag,"_":U) + 1) + "_obj" + " = ":U + lb_file.tt_db + "." + lb_file.tt_tag + ".":U + lb_field.tt_data[3] + '"'.
                                    CREATE tt_fieldtable.
                                    ASSIGN    
                                        lv_field              = lv_field + 1
                                        tt_fieldtable.tt_tag  = 100 + lv_field
                                        tt_fieldtable.tt_data = '     _FldNameList['+ STRING(lv_field) + ']   > ' + 
                                                               lb_file2.tt_db + ".":U + lb_file2.tt_tag + ".":U + lb_field2.tt_data[3] + CHR(10) + 
                                                               ' "' + lb_field2.tt_data[3] + '"' + ' "' + lb_field2.tt_data[3] + '" ? ?' +
                                                               ' "' + lb_field2.tt_data[5] + '" ? ? ? ? ? ? no ? no ' +
                                                               lb_field2.tt_data[6] + ' yes'.
                                END.
                                ASSIGN
                                    ip_field_list = ip_field_list + "|":U + lb_file2.tt_db + ".":U + lb_file2.tt_tag + ".":U + lb_field2.tt_data[3]
                                    lv_found      = YES.
                                NEXT LOOKUP-BLOCK.
                            END.    
                        END.
                    END.
                END.
            END.
        END.    
    END.    

    IF SUBSTRING(ip_field_list,1,1) = "|":U
    THEN
        ip_field_list = SUBSTRING(ip_field_list,2).

    EMPTY TEMP-TABLE tt_filetable.

END PROCEDURE.

FUNCTION getIndexFields RETURNS CHARACTER
  ( INPUT pcTable AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  To return a comma delimited list of fields in an AK index
            for the passed in table - selecting best index
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cIndexInformation           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cIndexField                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cReturnFields               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hKeyBuffer                  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hField                      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iLoop                       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iCnt                        AS INTEGER    NO-UNDO.

/* Create buffer for passed in table */
  CREATE BUFFER hKeyBuffer FOR TABLE TRIM(pcTable) NO-ERROR.

  ASSIGN
    iLoop             = 0
    iCnt              = 0
    cIndexInformation = "":U
    cReturnFields     = "":U.

  find-index-loop:
  REPEAT WHILE cIndexInformation <> ?:
    ASSIGN
      iLoop = iLoop + 1
      cIndexInformation = hKeyBuffer:INDEX-INFORMATION(iLoop).

    DO iCnt = 5 TO NUM-ENTRIES(cIndexInformation) BY 2:
      ASSIGN
        cIndexField = TRIM(ENTRY(iCnt, cIndexInformation)).
      IF LOOKUP(cIndexField,cReturnFields) = 0 THEN
      DO:
        ASSIGN
          hField        = hKeyBuffer:BUFFER-FIELD(cIndexField)
          cReturnFields = cReturnFields + "," WHEN cReturnFields <> "":U
          cReturnFields = cReturnFields + cIndexField + "," + hField:DATA-TYPE + "," + hField:LABEL.
      END.
    END.

  END.

  DELETE OBJECT hKeyBuffer.
  ASSIGN hKeyBuffer = ?.
  RETURN cReturnFields.   /* Function return value. */

END FUNCTION.

FUNCTION getMandatoryFields RETURNS CHARACTER
  ( INPUT pcTable AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  To return a comma delimited list of mandatory fields 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cReturnFields               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hKeyBuffer                  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hField                      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iLoop                       AS INTEGER    NO-UNDO.

/* Create buffer for passed in table */
  CREATE BUFFER hKeyBuffer FOR TABLE TRIM(pcTable) NO-ERROR.

  ASSIGN
    cReturnFields     = "":U.

  find-field-loop:
  DO iLoop = 1 TO hKeyBuffer:NUM-FIELDS:

        ASSIGN
          hField        = hKeyBuffer:BUFFER-FIELD(iLoop).

        IF VALID-HANDLE(hField) AND hField:MANDATORY THEN
          ASSIGN
            cReturnFields = cReturnFields + "," WHEN cReturnFields <> "":U
            cReturnFields = cReturnFields + hField:NAME + "," + hField:DATA-TYPE + "," + hField:LABEL.
  END.

  DELETE OBJECT hKeyBuffer.
  ASSIGN hKeyBuffer = ?.
  RETURN cReturnFields.   /* Function return value. */

END FUNCTION.

FUNCTION buildRowObjectValidate RETURNS CHARACTER
  ( INPUT pcTable AS CHARACTER):
/*------------------------------------------------------------------------------
  Purpose:  To create the RowObjectValidate Routine 
    Notes:  
------------------------------------------------------------------------------*/

DEFINE VARIABLE cField        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cLabel        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cData         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cConvert      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cCompare      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cCompar2      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cIndexFields  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cMandaFields  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iLoop         AS INTEGER    NO-UNDO.
DEFINE VARIABLE cValidate     AS CHARACTER  NO-UNDO.

  ASSIGN
    cIndexFields = getIndexFields(pcTable)
    cIndexFields = REPLACE(cIndexFields,"'","`")
    cMandaFields = getMandatoryFields(pcTable)
    cMandaFields = REPLACE(cMandaFields,"'","`").

  /*Add only mandatory fields that are not yet in cIndexFields to the string*/
  IF cMandaFields <> "":U THEN
  DO iLoop = 1 TO NUM-ENTRIES(cMandaFields) BY 3:
    ASSIGN
      cField = ENTRY(iLoop,cMandaFields)
      cData  = ENTRY(iLoop + 1,cMandaFields)
      cLabel = ENTRY(iLoop + 2,cMandaFields).
      

    IF LOOKUP(cField,cIndexFields) = 0 THEN
      ASSIGN
        cIndexFields = cIndexFields + ",":U WHEN cIndexFields <> "":U
        cIndexFields = cIndexFields + cField + ",":U + cData + ",":U + cLabel.
  END.

  field-loop:
  DO iLoop = 1 TO NUM-ENTRIES(cindexFields) BY 3:

    ASSIGN
      cField = ENTRY(iLoop,cIndexFields)
      cData  = ENTRY(iLoop + 1,cIndexFields)
      cLabel = ENTRY(iLoop + 2,cIndexFields).

    IF  AVAILABLE gsc_entity_mnemonic
    AND gsc_entity_mnemonic.table_has_object_field 
    AND gsc_entity_mnemonic.entity_object_field NE ""
    THEN DO:
        IF cField = gsc_entity_mnemonic.entity_object_field THEN
           NEXT field-loop.
    END.
    ELSE
    DO:
        IF  LENGTH(cField) GT 4 
        AND SUBSTRING(cField,LENGTH(cField) - 3)   = "_obj":U 
        AND SUBSTRING(cField,1,LENGTH(cField) - 4) = SUBSTRING(pcTable,5) THEN
           NEXT field-loop.
    END.

    CASE cData:
      WHEN "character":U THEN 
        ASSIGN 
          cConvert = "isFieldBlank(":U
          cCompare = ")":U
          cCompar2 = "":U.
      WHEN "date":U THEN 
        ASSIGN 
          cConvert = "":U
          cCompare = " = ?":U
          cCompar2 = "":U.
      WHEN "logical":U THEN
        ASSIGN
          cConvert = "":U
          cCompare = " = ?":U
          cCompar2 = "":U.
      OTHERWISE  
        ASSIGN 
          cConvert = "":U
          cCompare = " = 0":U
          cCompar2 = " = ?":U.
    END CASE.

    ASSIGN
      cValidate = cValidate + IF cCompar2 EQ "":U THEN 
                                 SUBSTITUTE(
                                        "  IF &4b_&1.&2&5 THEN":U + CHR(10) +
                                        "    ASSIGN" + CHR(10) +
                                        "      cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + " + CHR(10) + 
                                        "                    ~{aferrortxt.i 'AF' '1' '&1' '&2' ""'&3'""~}." + CHR(10) + CHR(10),
                                        pcTable,cField,cLabel,cConvert,cCompare,cCompar2)
                              ELSE
                                 SUBSTITUTE(
                                        "  IF &4b_&1.&2&5 OR &4b_&1.&2&6 THEN":U + CHR(10) +
                                        "    ASSIGN" + CHR(10) +
                                        "      cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + " + CHR(10) + 
                                        "                    ~{aferrortxt.i 'AF' '1' '&1' '&2' ""'&3'""~}." + CHR(10) + CHR(10),
                                        pcTable,cField,cLabel,cConvert,cCompare,cCompar2).


  END.

  RETURN cValidate.

END FUNCTION.

FUNCTION buildCreatePreTransValidate RETURNS CHARACTER
  ( INPUT pcTable AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  To create the CreatePreTransValidate Routine
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cIndexInformation           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cIndexField                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cClauseFields               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cClauseString               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cClause                     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFieldList                  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cValueList                  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hKeyBuffer                  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hField                      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iLoop                       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iCnt                        AS INTEGER    NO-UNDO.

/* Create buffer for passed in table */
  CREATE BUFFER hKeyBuffer FOR TABLE TRIM(pcTable) NO-ERROR.

  ASSIGN
    iLoop             = 0
    iCnt              = 0
    cIndexInformation = "":U
    cClauseFields     = "":U
    cFieldList        = "":U.

  find-index-loop:
  REPEAT WHILE cIndexInformation <> ?:
    ASSIGN
      iLoop = iLoop + 1
      cIndexInformation = hKeyBuffer:INDEX-INFORMATION(iLoop)
      cFieldList        = "":U
      cValueList        = "":U
      cClauseFields     = "":U.

    IF ENTRY(2,cIndexInformation) = "1":U THEN
    DO:
      DO iCnt = 5 TO NUM-ENTRIES(cIndexInformation) BY 2:
        ASSIGN
          cIndexField = TRIM(ENTRY(iCnt, cIndexInformation)).

        IF  AVAILABLE gsc_entity_mnemonic
        AND gsc_entity_mnemonic.table_has_object_field 
        AND gsc_entity_mnemonic.entity_object_field NE ""
        THEN DO:
            IF cIndexField = gsc_entity_mnemonic.entity_object_field THEN
               NEXT find-index-loop.
        END.
        ELSE
        DO:
          IF LENGTH(cIndexField) > 4 THEN
            IF SUBSTRING(cIndexField,LENGTH(cIndexField) - 3) = "_obj":U AND
               SUBSTRING(cIndexField,1,LENGTH(cIndexField) - 4) = SUBSTRING(pcTable,5) THEN
               NEXT find-index-loop.
        END.

        IF LOOKUP(cIndexField,cClauseFields) = 0 THEN
        DO:
          ASSIGN
            cClause       = IF iCnt = 5 THEN "              WHERE " ELSE CHR(10) + "                AND "
            cFieldList    = cFieldList + cIndexField + ", ":U
            cValueList    = cValueList + " + ', ' + " WHEN cValueList <> "":U
            cValueList    = cValueList + "STRING(b_":U + pcTable + ".":U + cIndexField + ")":U
            cClauseFields = cClauseFields + cClause + pcTable + ".":U + cIndexField + " = b_":U + pcTable + ".":U + cIndexField.
        END.
      END.

      ASSIGN
        cClauseFields = SUBSTITUTE(
            "  IF CAN-FIND(FIRST &1 ":U + CHR(10) + 
            cClauseFields + ") THEN":U  + CHR(10) + 
            "  DO:":U     + CHR(10) + 
            "     ASSIGN" + CHR(10) +
            "        cValueList   = " + cValueList + CHR(10) +
            "        cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + " + CHR(10) +
            "                      ~{aferrortxt.i 'AF' '8' '&1' '' ""'&2'"" cValueList ~}." + CHR(10) + 
            "  END." + CHR(10),
            pcTable,cFieldList)        
        cClauseString = cClauseString + CHR(10) WHEN cClauseString <> "":U
        cClauseString = cClauseString + cClauseFields + CHR(10)
        cClauseFields = "":U.
    END.

  END.

  DELETE OBJECT hKeyBuffer.
  ASSIGN hKeyBuffer = ?.
  RETURN cClauseString.   /* Function return value. */

END FUNCTION.

FUNCTION buildWritePreTransValidate RETURNS CHARACTER
  ( INPUT pcTable AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  To create the WritePreTransValidate Routine
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cIndexInformation           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cIndexField                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cClauseFields               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cClauseString               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cClause                     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFieldList                  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cValueList                  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hKeyBuffer                  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hField                      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iLoop                       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iCnt                        AS INTEGER    NO-UNDO.

/* Create buffer for passed in table */
  CREATE BUFFER hKeyBuffer FOR TABLE TRIM(pcTable) NO-ERROR.

  ASSIGN
    iLoop             = 0
    iCnt              = 0
    cIndexInformation = "":U
    cClauseFields     = "":U
    cFieldList        = "":U.

  find-index-loop:
  REPEAT WHILE cIndexInformation <> ?:
    ASSIGN
      iLoop = iLoop + 1
      cIndexInformation = hKeyBuffer:INDEX-INFORMATION(iLoop)
      cFieldList        = "":U
      cValueList        = "":U
      cClauseFields     = "":U.

    IF ENTRY(2,cIndexInformation) = "1":U THEN
    DO:
      DO iCnt = 5 TO NUM-ENTRIES(cIndexInformation) BY 2:
        ASSIGN
          cIndexField = TRIM(ENTRY(iCnt, cIndexInformation)).

        IF  AVAILABLE gsc_entity_mnemonic
        AND gsc_entity_mnemonic.table_has_object_field 
        AND gsc_entity_mnemonic.entity_object_field NE ""
        THEN DO:
            IF cIndexField = gsc_entity_mnemonic.entity_object_field THEN
               NEXT find-index-loop.
        END.
        ELSE
        DO:
          IF LENGTH(cIndexField) > 4 THEN
            IF SUBSTRING(cIndexField,LENGTH(cIndexField) - 3) = "_obj":U AND
               SUBSTRING(cIndexField,1,LENGTH(cIndexField) - 4) = SUBSTRING(pcTable,5) THEN
               NEXT find-index-loop.
        END.

        IF LOOKUP(cIndexField,cClauseFields) = 0 THEN
        DO:
            ASSIGN
              cClause       = IF iCnt = 5 THEN "              WHERE " ELSE CHR(10) + "                AND "
              cFieldList    = cFieldList + cIndexField + ", ":U
              cValueList    = cValueList + " + ', ' + " WHEN cValueList <> "":U
              cValueList    = cValueList + "STRING(b_":U + pcTable + ".":U + cIndexField + ")":U
              cClauseFields = cClauseFields + cClause + pcTable + ".":U + cIndexField + " = b_":U + pcTable + ".":U + cIndexField.
        END.
      END.
      ASSIGN
        cClauseFields = SUBSTITUTE(
              "  IF NOT isCreate() AND CAN-FIND(FIRST &1 ":U + CHR(10) + 
              cClauseFields + CHR(10) +              
              "                AND ROWID(&1) <> TO-ROWID(ENTRY(1,b_":U + pcTable + ".RowIDent))) THEN":U  + CHR(10) + 
              "  DO:":U     + CHR(10) + 
              "     ASSIGN" + CHR(10) +
              "        cValueList   = " + cValueList + CHR(10) +
              "        cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + " + CHR(10) +
              "                      ~{aferrortxt.i 'AF' '8' '&1' '' ""'&2'"" cValueList ~}." + CHR(10) + 
              "  END." + CHR(10),
              pcTable,cFieldList)        

        cClauseString = cClauseString + CHR(10) WHEN cClauseString <> "":U
        cClauseString = cClauseString + cClauseFields + CHR(10)
        cClauseFields = "":U.
    END.

  END.

  DELETE OBJECT hKeyBuffer.
  ASSIGN hKeyBuffer = ?.
  RETURN cClauseString.   /* Function return value. */

END FUNCTION.


FUNCTION getAKFields
RETURNS CHARACTER
  ( INPUT pcTable AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  To return a sort order list of fields in an AK index
            for the passed in table - selecting best index
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cIndexInformation           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cIndexField                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cReturnFields               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hKeyBuffer                  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iLoop                       AS INTEGER    NO-UNDO.

  DEFINE VARIABLE iUseIndex                   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iOneFieldIndex              AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iUniqueIndex                AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iPrimaryIndex               AS INTEGER    NO-UNDO.

  /* Create buffer for passed in table */
  CREATE BUFFER hKeyBuffer FOR TABLE TRIM(pcTable) NO-ERROR.

  ASSIGN
    iLoop = 0
    iOneFieldIndex = 0
    iUseIndex = 0
    iPrimaryIndex = 0
    iUniqueIndex = 0
    cIndexInformation = "":U
    cReturnFields = "":U.

  find-index-loop:
  REPEAT WHILE cIndexInformation <> ?:
    iLoop = iLoop + 1.
    cIndexInformation = hKeyBuffer:INDEX-INFORMATION(iLoop).

    /* primary index */
    IF cIndexInformation <> ? AND
       INTEGER(ENTRY(3, cIndexInformation)) = 1 THEN ASSIGN iPrimaryIndex = iLoop. 

    IF  AVAILABLE gsc_entity_mnemonic
    AND gsc_entity_mnemonic.table_has_object_field 
    AND gsc_entity_mnemonic.entity_object_field NE ""
    THEN DO:
        /* single unique field <> table_obj */
        IF cIndexInformation <> ? AND
           INTEGER(ENTRY(2, cIndexInformation)) = 1 AND
           INDEX(cIndexInformation,gsc_entity_mnemonic.entity_object_field) = 0 AND
           ((NUM-ENTRIES(cIndexInformation) - 4) / 2) = 1
          THEN ASSIGN iOneFieldIndex = iLoop.

        /* 1st unique index that does not have table_obj in it */
        IF cIndexInformation <> ? AND
           INTEGER(ENTRY(2, cIndexInformation)) = 1 AND
           INDEX(cIndexInformation,gsc_entity_mnemonic.entity_object_field) = 0 AND 
           iUniqueIndex = 0 THEN
          ASSIGN iUniqueIndex = iLoop.
    END.
    ELSE
    DO:
        /* single unique field <> table_obj */
        IF cIndexInformation <> ? AND
           INTEGER(ENTRY(2, cIndexInformation)) = 1 AND
           INDEX(cIndexInformation,SUBSTRING(pcTable,5) + "_obj,":U) = 0 AND
           ((NUM-ENTRIES(cIndexInformation) - 4) / 2) = 1
          THEN ASSIGN iOneFieldIndex = iLoop.

        /* 1st unique index that does not have table_obj in it */
        IF cIndexInformation <> ? AND
           INTEGER(ENTRY(2, cIndexInformation)) = 1 AND
           INDEX(cIndexInformation,SUBSTRING(pcTable,5) + "_obj,":U) = 0 AND 
           iUniqueIndex = 0 THEN
          ASSIGN iUniqueIndex = iLoop.
    END.

  END. /* Find index loop */

  IF iOneFieldIndex > 0 THEN
    ASSIGN iUseIndex = iOneFieldIndex.
  ELSE IF iUniqueIndex > 0 THEN
    ASSIGN iUseIndex = iUniqueIndex.
  ELSE
    ASSIGN iUseIndex = iPrimaryIndex.

  ASSIGN
    cIndexInformation = hKeyBuffer:INDEX-INFORMATION(iUseIndex)
    cReturnFields = "":U.

  DO iLoop = 5 TO NUM-ENTRIES(cIndexInformation) BY 2:
    ASSIGN
      cIndexField = TRIM(ENTRY(iLoop, cIndexInformation))
      .
    IF LOOKUP(cIndexField,cReturnFields) = 0 THEN
      ASSIGN cReturnFields = cReturnFields + (IF cReturnFields <> "":U THEN ",":U ELSE "":U) +
                             pcTable + ".":U + cIndexField
      .                                 
  END.

  DELETE OBJECT hKeyBuffer.
  ASSIGN 
    hKeyBuffer = ?.
  RETURN cReturnFields.   /* Function return value. */

END FUNCTION.

FUNCTION editFixCRLF RETURNS LOGICAL:
/*------------------------------------------------------------------------------
  Purpose:  Changes all single CHR(10) to CR/LF so that template files saved on a unix 
            file system will not cause errors when read on a windows system
    Notes:  
------------------------------------------------------------------------------*/

DEFINE VARIABLE lResult AS LOGICAL    NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    eEdit:CURSOR-OFFSET = 1.
    IF eEdit:SEARCH(CHR(10),17) AND NOT eEdit:SEARCH(CHR(10) + CHR(13),17) THEN
      lResult = eEdit:REPLACE(CHR(10),CHR(10) + CHR(13),8).
    eEdit:CURSOR-OFFSET = 1.
  END.

  RETURN lResult.

END FUNCTION.

PROCEDURE getDbData:
/*------------------------------------------------------------------------------
  Purpose:     Retrieves all _File and _Field data for a given logical DB.
  Parameters:  pcDatabase - 
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcDatabase               AS CHARACTER        NO-UNDO.

    DEFINE VARIABLE cSchemaName             AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cTableWhere             AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cFieldWhere             AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cTableBufferName        AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cFileBufferName         AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cFieldBufferName        AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cFieldWidth             AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE hDbBuffer               AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE hFileBuffer             AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE hFieldBuffer            AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE hFieldFileName          AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE hFieldFieldName         AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE hFieldOrder             AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE hFieldDataType          AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE hFieldWidth             AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE hFieldFormat            AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE hTableQuery             AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE hFieldQuery             AS HANDLE                   NO-UNDO.

    DEFINE BUFFER lb_Filetable      FOR tt_Filetable.

    /* If the logical object name and the schema name differ, then we assume that we are working with 
     * a DataServer. If the schema and logical names are the same, we are dealing with a native 
     * Progress DB.                                                                                   */
    ASSIGN cSchemaName = SDBNAME(pcDatabase).
    
    IF cSchemaName EQ pcDatabase THEN
        ASSIGN cTableBufferName = pcDatabase + "._Db":U
               cFileBufferName  = pcDatabase + "._File":U
               cTableWhere      = "FOR EACH ":U + cTableBufferName + " NO-LOCK, ":U
                                + " EACH " + cFileBufferName + " WHERE ":U
                                +  cFileBufferName + "._Db-recid = RECID(" + cTableBufferName + ") AND ":U
                                +  cFileBufferName + "._Tbl-type = 'T':U AND ":U
                                +  cFileBufferName + "._Owner    = 'PUB':U ":U
                                + " NO-LOCK ":U.
    ELSE
        ASSIGN cTableBufferName = cSchemaName + "._Db":U
               cFileBufferName  = cSchemaName + "._File":U
               cTableWhere      = " FOR EACH ":U + cTableBufferName + " WHERE ":U
                                +   cTableBufferName + "._Db-Name = '" + pcDatabase + "' ":U
                                + " NO-LOCK, ":U
                                + " EACH " + cFileBufferName + " WHERE ":U
                                +  cFileBufferName + "._Db-recid = RECID(":U + cTableBufferName + ") AND ":U
                                +  cFileBufferName + "._Tbl-type = 'T':U AND ":U
                                +  cFileBufferName + "._Owner    = '_Foreign':U ":U
                                + " NO-LOCK ":U.
    
    CREATE BUFFER hDbBuffer         FOR TABLE cTableBufferName.
    CREATE BUFFER hFileBuffer       FOR TABLE cFileBufferName.
    
    CREATE QUERY hTableQuery.
    
    ASSIGN hFieldFileName = hFileBuffer:BUFFER-FIELD("_File-name":U).

    hTableQuery:SET-BUFFERS(hDbBuffer,hFileBuffer).
    hTableQuery:QUERY-PREPARE(cTableWhere).
    hTableQuery:QUERY-OPEN().
    
    hTableQuery:GET-FIRST(NO-LOCK).
    DO WHILE hDbBuffer:AVAILABLE:
        CREATE tt_Filetable.
        ASSIGN tt_filetable.tt_tag     = TRIM(hFieldFileName:STRING-VALUE)
               tt_filetable.tt_data[1] = TRIM(hFieldFileName:STRING-VALUE)
               tt_filetable.tt_data[2] = STRING(hFileBuffer:RECID)
               tt_filetable.tt_data[3] = pcDatabase
               tt_filetable.tt_db      = pcDatabase
               tt_filetable.tt_type    = hFileBuffer:TABLE
               .
        /* Create _Field records for this _File */
        IF cSchemaName EQ pcDatabase THEN
            ASSIGN cFieldBufferName = pcDatabase + "._Field":U.
        ELSE
            ASSIGN cFieldBufferName = cSchemaName + "._Field":U.

        ASSIGN cFieldWhere = "FOR EACH ":U + cFieldBufferName + " WHERE ":U
                           +  cFieldBufferName + "._File-recid = ":U + STRING(hFileBuffer:RECID)
                           + " NO-LOCK ":U.

        CREATE QUERY hFieldQuery.
        CREATE BUFFER hFieldBuffer      FOR TABLE cFieldBufferName.

        ASSIGN hFieldOrder     = hFieldBuffer:BUFFER-FIELD("_Order":U)
               hFieldFieldName = hFieldBuffer:BUFFER-FIELD("_Field-name":U)
               hFieldDataType  = hFieldBuffer:BUFFER-FIELD("_Data-type":U)
               hFieldWidth     = hFieldBuffer:BUFFER-FIELD("_Width":U)
               hFieldFormat    = hFieldBuffer:BUFFER-FIELD("_Format":U)
               .        
        hFieldQuery:SET-BUFFERS(hFieldBuffer).
        hFieldQuery:QUERY-PREPARE(cFieldWhere).
        hFieldQuery:QUERY-OPEN().

        hFieldQuery:GET-FIRST(NO-LOCK).

        DO WHILE hFieldBuffer:AVAILABLE:
            CREATE lb_Filetable.
            ASSIGN lb_filetable.tt_tag     = STRING(hFileBuffer:RECID)
                   lb_filetable.tt_data[1] = STRING(hFileBuffer:RECID)
                   lb_filetable.tt_data[2] = STRING(hFieldOrder:BUFFER-VALUE, "99999":U)
                   lb_filetable.tt_data[3] = TRIM(hFieldFieldName:STRING-VALUE)
                   lb_filetable.tt_data[4] = STRING(hFieldBuffer:RECID)
                   lb_filetable.tt_data[5] = TRIM(hFieldDataType:STRING-VALUE)
                   lb_filetable.tt_data[6] = TRIM(hFieldWidth:STRING-VALUE)
                   lb_filetable.tt_db      = pcDatabase
                   lb_filetable.tt_type    = hFieldBuffer:TABLE
                   .
            IF hFieldWidth:BUFFER-VALUE EQ ? THEN
                IF lb_filetable.tt_data[5] EQ "CHARACTER":U THEN                
                    ASSIGN cFieldWidth             = SUBSTRING(hFieldFormat:STRING-VALUE, INDEX(hFieldFormat:STRING-VALUE, "(":U) + 1)
                           cFieldWidth             = SUBSTRING(cFieldWidth, 1, R-INDEX(cFieldWidth, ")":U) - 1)
                           lb_filetable.tt_data[6] = TRIM(cFieldWidth)
                           .
                ELSE
                    ASSIGN lb_filetable.tt_data[6] = STRING(FONT-TABLE:GET-TEXT-WIDTH-CHARS(hFieldFormat:STRING-VALUE)).

            hFieldQuery:GET-NEXT(NO-LOCK).
        END.    /* avail _Field */

        hFieldQuery:QUERY-CLOSE().

        DELETE OBJECT hFieldQuery NO-ERROR.
        ASSIGN hFieldQuery = ?.

        DELETE OBJECT hFieldBuffer NO-ERROR.
        ASSIGN hFieldBuffer = ?.

        DELETE OBJECT hFieldOrder NO-ERROR.
        ASSIGN hFieldOrder = ?.

        DELETE OBJECT hFieldFieldName NO-ERROR.
        ASSIGN hFieldFieldName = ?.

        DELETE OBJECT hFieldDataType NO-ERROR.
        ASSIGN hFieldDataType = ?.

        DELETE OBJECT hFieldWidth NO-ERROR.
        ASSIGN hFieldWidth = ?.

        hTableQuery:GET-NEXT(NO-LOCK).
    END.    /* avail db buffer */
    
    hTableQuery:QUERY-CLOSE().
    
    DELETE OBJECT hTableQuery NO-ERROR.
    ASSIGN hTableQuery = ?.
    
    DELETE OBJECT hDbBuffer NO-ERROR.
    ASSIGN hDbBuffer = ?.
    
    DELETE OBJECT hFileBuffer NO-ERROR.
    ASSIGN hFileBuffer = ?.
    
    DELETE OBJECT hFieldFileName NO-ERROR.
    ASSIGN hFieldFileName = ?.
    
    RETURN.
END PROCEDURE.  /* getDbData */
