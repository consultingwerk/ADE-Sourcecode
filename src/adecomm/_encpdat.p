/*********************************************************************
* Copyright (C) 2008-2009 by Progress Software Corporation. All rights *
* reserved.                                                          *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _encpdat.p

Description:
   Display encryption policy info for the quick and detailed encryption policy
   report.  It will go to the currently set output device (e.g., a file,
   the printer).
 
Input Parameters:
    p_RepId =  Numeric Identifier of the report being called.
               1 = quick report
               2 = detailed report
   p_Tbl   - The name of the table to report on - or ALL for all tables.

Author: Fernando de Souza

Date Created: 10/28/08
    
    Modified: 

----------------------------------------------------------------------------*/
{ prodict/sec/sec-pol.i }
{ prodict/misc/misc-funcs.i }

DEFINE INPUT PARAMETER p_RepId   AS INT NO-UNDO.
DEFINE INPUT PARAMETER p_Tbl     AS CHAR  NO-UNDO.

DEFINE SHARED STREAM rpt.

DEF VAR myEPolicyCache AS prodict.sec._sec-pol-util NO-UNDO.
DEF VAR isQuick        AS LOGICAL                   NO-UNDO.
DEF VAR cObj           AS CHARACTER                 NO-UNDO.
DEF VAR cTable         AS CHARACTER                 NO-UNDO.
DEF VAR line           AS CHAR                      NO-UNDO.
DEF VAR areaName       AS CHAR                      NO-UNDO.
DEF VAR lStopped       AS LOGICAL                   NO-UNDO.

DEFINE VAR separators AS CHAR EXTENT 3 NO-UNDO INITIAL 
[
  "=========================================================================",
  "============================= Table: ",
  "-------------------------------------------------------------------------"
].

&GLOBAL-DEFINE SEP_NEXTTBL    1
&GLOBAL-DEFINE SEP_TBLNAME    2
&GLOBAL-DEFINE SEP_OTHER      3
&GLOBAL-DEFINE SEP_TBLEND    " " + STRING(separators[{&SEP_NEXTTBL}],  SUBSTITUTE("x(&1)", 35 - LENGTH(cTable,"RAW":u)))

/* for quick report */
FORM
   cObj                         FORMAT "x(43)"  COLUMN-LABEL "Object!Name" 
   ttObjEncPolicyVersions.pol-cipher   FORMAT "x(20)"  COLUMN-LABEL "Cipher Name!(Current Policy)" 
   ttObjEncPolicyVersions.pol-version  FORMAT ">>>9"   COLUMN-LABEL "Policy!Version"
   WITH FRAME quick-report USE-TEXT STREAM-IO DOWN.

/* For general long text strings.  line is formatted as appropriate. */
FORM
   line FORMAT "x(77)" NO-LABEL
   WITH FRAME rptline NO-ATTR-SPACE DOWN NO-BOX USE-TEXT STREAM-IO.

/* for detailed report */
FORM 
    ttObjAttrs.obj-name  AT 2 FORMAT "x(65)" LABEL "Object Name "
    ttObjAttrs.obj-type  AT 2 FORMAT "x(32)" LABEL "Object Type " 
    areaName               AT 2 FORMAT "x(42)" LABEL "Storage Area"
    WITH FRAME obj-info SIDE-LABELS NO-ATTR-SPACE DOWN NO-BOX 
                        USE-TEXT STREAM-IO.

/* for detailed report */
FORM
    ttObjEncPolicyVersions.pol-version AT 8 FORMAT ">>>9"   COLUMN-LABEL "Policy Version"
    ttObjEncPolicyVersions.pol-cipher  FORMAT "x(20)"   COLUMN-LABEL "Cipher Name" 
    ttObjEncPolicyVersions.pol-state   FORMAT "x(20)"   COLUMN-LABEL "Policy State" 
    WITH FRAME pol-info NO-ATTR-SPACE DOWN NO-BOX USE-TEXT STREAM-IO.



/* Main block */
IF NOT CONNECTED("DICTDB") THEN DO:
    MESSAGE "DICTDB database is required but it is not connected."
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    RETURN "".
END.

IF NOT dbAdmin(USERID("DICTDB")) THEN DO:
  MESSAGE "You must be a Security Administrator to use this option."
      VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN "".
END.

IF DBTYPE("DICTDB") NE "PROGRESS" THEN DO:
    MESSAGE "Cannot use this option with this database type."
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    RETURN "".
END.

ASSIGN isQuick = p_RepId EQ 1.

/* get policy information now */
DO TRANSACTION ON ERROR UNDO, LEAVE
               ON STOP  UNDO, LEAVE:

   lStopped = YES.

   /* this will acquire a schema lock for us on the DICTDB database */
   myEPolicyCache = NEW prodict.sec._sec-pol-util().

   /* if this is the detailed report, we want to get the are number for the
      objects too.
   */
   IF NOT isQuick THEN
      myEPolicyCache:FillAreaNum = YES.

   /* populate the dataset with the encryptable object names and current 
      policy info*/
   IF isQuick OR p_Tbl = "ALL" THEN
       myEPolicyCache:getTableList(INPUT YES, /* get current policy info */
                                   OUTPUT DATASET dsObjAttrs BY-REFERENCE).
   ELSE
       myEPolicyCache:getObjectList(p_Tbl, 
                                    YES,/* get current policy info */
                                    OUTPUT DATASET dsObjAttrs BY-REFERENCE).

   FOR EACH ttObjAttrs.
       /* for the quick report, only want the policies that are current and
          with encryption enabled.
       */
       IF isQuick AND ttObjAttrs.obj-cipher = "" THEN DO:
           DELETE ttObjAttrs.
           NEXT.
       END.

       /* get the policy info */
       myEPolicyCache:getPolicyVersions(INPUT ttObjAttrs.obj-num, 
                                        INPUT ttObjAttrs.obj-type, 
                                        OUTPUT DATASET dsObjAttrs BY-REFERENCE).

       /* do not want to report on tables with no policies at all */
       IF (isQuick OR p_Tbl = "ALL") AND NOT CAN-FIND (FIRST ttObjEncPolicyVersions OF ttObjAttrs) THEN
          DELETE ttObjAttrs.
   END.

   /* check if there is anything to be reported */
   IF NOT CAN-FIND (FIRST ttObjAttrs) THEN DO:
      IF isQuick OR p_Tbl = "ALL"  THEN
          PUT STREAM rpt UNFORMATTED "There are no objects with encryption currently enabled."
                  SKIP.
      ELSE
          PUT STREAM rpt UNFORMATTED "Table " p_Tbl " (and its objects) is not encryptable or does not" SKIP
                  "contain any encryption policy info." SKIP.
   END.

   lStopped = NO.

   CATCH ae AS PROGRESS.Lang.AppError:
       MESSAGE ae:GetMessage(1) 
               VIEW-AS ALERT-BOX ERROR BUTTONS OK.
       DELETE OBJECT ae.
   END CATCH.
   FINALLY:
      IF VALID-OBJECT(myEPolicyCache) THEN
         DELETE OBJECT myEPolicyCache NO-ERROR.
   END FINALLY. 
END.

/* if we got a stop condition (such as a canceled lock), stop it now */
IF lStopped THEN
    STOP.

/* message was logged above */
IF NOT CAN-FIND (FIRST ttObjAttrs) THEN
   RETURN.

IF isQuick THEN DO:
    RUN doQuickReport.
END.
ELSE DO: /* detailed report */
    RUN doDetailedReport.
END.


PROCEDURE doQuickReport:

    DISPLAY STREAM rpt 
        "Reporting only objects with encryption enabled at the object level."
        @ line
        WITH FRAME rptline.
    DOWN STREAM rpt 1 WITH FRAME rptline.

    FOR EACH ttObjAttrs:
        FIND FIRST ttObjEncPolicyVersions OF ttObjAttrs.
        IF ttObjAttrs.obj-type NE "TABLE" THEN DO:
            /* for table.object, strip out the table part */
           IF cTable NE ENTRY(1, ttObjAttrs.obj-name, ".") THEN DO:
               ASSIGN cTable = ENTRY(1, ttObjAttrs.obj-name, ".").
               /* the table itself did not have any policies, so
                  we will log the table name so the object appears
                  indented underneath it.
               */
               DISPLAY STREAM rpt 
                   ENTRY(1, ttObjAttrs.obj-name,".") @ cObj
                   WITH FRAME quick-report.
               DOWN STREAM rpt WITH FRAME quick-report.
           END.
           /* this will appear indented under the table name */
           ASSIGN cObj = " - " + ENTRY(2, ttObjAttrs.obj-name, ".") 
                          + " (" + ttObjAttrs.obj-type + ")".
        END.
        ELSE
            ASSIGN  cTable = ttObjAttrs.obj-name
                    cObj = cTable.

        DISPLAY STREAM rpt
            cObj
            ttObjEncPolicyVersions.pol-version
            ttObjEncPolicyVersions.pol-cipher
            WITH FRAME quick-report.
         DOWN STREAM rpt WITH FRAME quick-report.
    END.

END PROCEDURE.


PROCEDURE doDetailedReport.
    DEF VAR hArea         AS HANDLE  NO-UNDO.
    DEF VAR cTmp          AS CHAR    NO-UNDO.
    DEF VAR iLast         AS INT     NO-UNDO.
    DEF VAR lFirstOfTable AS LOGICAL NO-UNDO.

    ASSIGN cTmp = LDBNAME("DICTDB") + "._Area".
    CREATE BUFFER hArea FOR TABLE cTmp NO-ERROR.

    IF p_Tbl = "ALL" THEN DO:
        DISPLAY STREAM rpt 
            "Reporting only objects with encryption policies at the object level."
            @ line
            WITH FRAME rptline.
    END.
    ELSE DO:
        DISPLAY STREAM rpt 
            "Reporting encryptable objects (at the object level)."
            @ line
            WITH FRAME rptline.
    END.
    DOWN STREAM rpt 1 WITH FRAME rptline.

    FOR EACH ttObjAttrs:
        /* first table or switching to a different table */
        IF cTable NE ENTRY(1, ttObjAttrs.obj-name, ".") THEN DO:
           lFirstOfTable = YES.
           cTable = ENTRY(1, ttObjAttrs.obj-name, ".").

           DOWN STREAM rpt 2 WITH FRAME rptline.
           DISPLAY STREAM rpt separators[{&SEP_NEXTTBL}] @ line
                  WITH FRAME rptline.
           DOWN STREAM rpt 1 WITH FRAME rptline.

           DISPLAY STREAM rpt separators[{&SEP_TBLNAME}] +
                              ENTRY(1, ttObjAttrs.obj-name, ".") +
                              {&SEP_TBLEND}
                   @ line WITH FRAME rptline.
           DOWN STREAM rpt 1 WITH FRAME rptline.
        END.
        ELSE
            lFirstOfTable = NO.

        IF NOT lFirstOfTable THEN DO:
            DOWN STREAM rpt 1 WITH FRAME rptline.
            DISPLAY STREAM rpt SEPARATORS[{&SEP_OTHER}] @ line
                 WITH FRAME rptline.
            DOWN STREAM rpt WITH FRAME rptline.
        END.

        /* get the object name */
        IF ttObjAttrs.obj-type NE "TABLE" THEN DO:
           ASSIGN cObj = ENTRY(2, ttObjAttrs.obj-name, ".") +
                         " (Table: " + cTable + ")".
        END.
        ELSE
            ASSIGN  cTable = ttObjAttrs.obj-name
                    cObj = cTable.

        /* try to get the area name. If the area number is the same as
           the previous one, we already got it
        */
        IF iLast NE ttObjAttrs.obj-area THEN DO:
            iLast = ttObjAttrs.obj-area.
            IF ttObjAttrs.obj-area NE ? THEN
               hArea:FIND-FIRST("where _Area-number = " + STRING(ttObjAttrs.obj-area), NO-LOCK) NO-ERROR.
            IF hArea:AVAILABLE THEN DO:
                areaName = hArea::_Area-name.
                hArea:BUFFER-RELEASE().
            END.
            ELSE
                areaName = "".
        END.

        DOWN STREAM rpt 1 WITH FRAME rptline.
        DISPLAY STREAM rpt
            cObj @ ttObjAttrs.obj-name 
            ttObjAttrs.obj-type 
            areaName
            WITH FRAME obj-info.

        DOWN STREAM rpt 1 WITH FRAME rptline.

        /* if the table was never encrypted or there are no current policies,
           just log message.
        */
        IF NOT CAN-FIND (FIRST ttObjEncPolicyVersions OF ttObjAttrs) THEN DO:
            DISPLAY STREAM rpt  "        No policy information available for object."
                                @ line WITH FRAME rptline.

            DOWN STREAM rpt WITH FRAME rptline.
            DOWN STREAM rpt WITH FRAME rptline.
        END.

        FOR EACH ttObjEncPolicyVersions OF ttObjAttrs.
            DISPLAY STREAM rpt ttObjEncPolicyVersions.pol-version
                               ttObjEncPolicyVersions.pol-cipher
                               ttObjEncPolicyVersions.pol-state
                    WITH FRAME pol-info.
            DOWN STREAM rpt WITH FRAME pol-info.
        END.
        DOWN STREAM rpt WITH FRAME rptline.
    END.
    DOWN STREAM rpt WITH FRAME rptline.

    IF VALID-HANDLE(hArea) THEN
        DELETE OBJECT hArea.

END PROCEDURE.
