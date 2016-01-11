/*********************************************************************
* Copyright (C) 2009 by Progress Software Corporation. All rights    *
* reserved.                                                          *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _altbufdat.p

Description:
   Display _Field information for the quick field report.  It will go to 
   the currently set output device (e.g., a file, the printer).
 
Input Parameters:
   p_DbId  - Id of the _Db record for this database. Not used.

Author: Fernando de Souza

Date Created: 04/07/09

----------------------------------------------------------------------------*/

{prodict/sec/sec-pol.i}
{ prodict/misc/misc-funcs.i }

DEFINE INPUT PARAMETER p_DbId AS RECID NO-UNDO.


DEFINE SHARED STREAM rpt.

DEF VAR myObjAttrs     AS prodict.pro._obj-attrib-util NO-UNDO.
DEF VAR cObj           AS CHARACTER                    NO-UNDO.
DEF VAR cTable         AS CHARACTER                    NO-UNDO.
DEF VAR line           AS CHAR                         NO-UNDO.
DEF VAR areaName       AS CHAR                         NO-UNDO.
DEF VAR lStopped       AS LOGICAL                      NO-UNDO.

/* for quick report */
FORM
   cObj                         FORMAT "x(43)"  COLUMN-LABEL "Object!Name" 
   areaName                     FORMAT "x(20)"  COLUMN-LABEL "Area!Name" 
   WITH FRAME quick-report USE-TEXT STREAM-IO DOWN.

/* For general long text strings.  line is formatted as appropriate. */
FORM
   line FORMAT "x(77)" NO-LABEL
   WITH FRAME rptline NO-ATTR-SPACE DOWN NO-BOX USE-TEXT STREAM-IO.

/* Main block */
IF NOT CONNECTED("DICTDB") THEN DO:
    MESSAGE "DICTDB database is required but it is not connected."
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    RETURN "".
END.

IF NOT dbAdmin(USERID("DICTDB")) THEN DO:
  MESSAGE "You must be a Security Administrator to run this report."
      VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN "".
END.

IF DBTYPE("DICTDB") NE "PROGRESS" THEN DO:
    MESSAGE "Cannot use this option with this database type."
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    RETURN "".
END.

/* get buffer-pool information now */
DO TRANSACTION ON ERROR UNDO, LEAVE
               ON STOP  UNDO, LEAVE:

   lStopped = YES.

   /* this will acquire a schema lock for us on the DICTDB database */
   myObjAttrs = NEW prodict.pro._obj-attrib-util().

   /* if this is the detailed report, we want to get the area number for the
      objects too.
   */
   myObjAttrs:FillAreaNum = YES.

   /* populate the dataset with the objects assignable to the 
     alternate buffer pool */
   myObjAttrs:getTableList(OUTPUT DATASET dsObjAttrs BY-REFERENCE).

   FOR EACH ttObjAttrs.
       /* just want the ones that are assigned to the alternate buffer pool
          at the object or area level.
       */
       IF ttObjAttrs.obj-buf-pool = "Primary" AND 
          ttObjAttrs.area-buf-pool = "Primary" THEN DO:
           DELETE ttObjAttrs.
           NEXT.
       END.
   END.

   /* check if there is anything to be reported */
   IF NOT CAN-FIND (FIRST ttObjAttrs) THEN DO:
      PUT STREAM rpt UNFORMATTED "All objects are assigned to the primary buffer pool."
              SKIP.
   END.

   lStopped = NO.

   CATCH ae AS PROGRESS.Lang.AppError:
       MESSAGE ae:GetMessage(1) 
               VIEW-AS ALERT-BOX ERROR BUTTONS OK.
       DELETE OBJECT ae.
   END CATCH.
   FINALLY:
      IF VALID-OBJECT(myObjAttrs) THEN
         DELETE OBJECT myObjAttrs NO-ERROR.
   END FINALLY. 
END.

/* if we got a stop condition (such as a canceled lock), stop it now */
IF lStopped THEN
    STOP.

/* message was logged above */
IF NOT CAN-FIND (FIRST ttObjAttrs) THEN
   RETURN.

RUN doQuickReport.

PROCEDURE doQuickReport:
    DEF VAR hArea            AS HANDLE  NO-UNDO.
    DEF VAR iLast            AS INT     NO-UNDO.
    DEF VAR cTmp             AS CHAR    NO-UNDO.
    DEF VAR foundNotAssigned AS LOGICAL NO-UNDO.
    DEF VAR skipLine         AS LOGICAL NO-UNDO.

    ASSIGN cTmp = LDBNAME("DICTDB") + "._Area".
    CREATE BUFFER hArea FOR TABLE cTmp NO-ERROR.

    IF CAN-FIND (FIRST ttObjAttrs WHERE ttObjAttrs.obj-buf-pool NE "Primary") THEN DO:
        DISPLAY STREAM rpt 
            "List of object-level assignable objects that are assigned to the"
            @ line
            WITH FRAME rptline.
        DOWN STREAM rpt 1 WITH FRAME rptline.
        DISPLAY STREAM rpt 
            "alternate buffer pool at the object level"
            @ line
            WITH FRAME rptline.
        DOWN STREAM rpt 1 WITH FRAME rptline.
        skipLine = YES.
    END.

    /* first the objects assigned at the object level */
    FOR EACH ttObjAttrs WHERE ttObjAttrs.obj-buf-pool NE "Primary":
        
        IF ttObjAttrs.obj-type NE "TABLE" THEN DO:
            /* for table.object, strip out the table part */
           IF cTable NE ENTRY(1, ttObjAttrs.obj-name, ".") THEN DO:
               ASSIGN cTable = ENTRY(1, ttObjAttrs.obj-name, ".")
                      foundNotAssigned = YES.
               /* the table itself is not assigned, so
                  we will log the table name so the object appears
                  indented underneath it.
               */
               DISPLAY STREAM rpt 
                   ENTRY(1, ttObjAttrs.obj-name,".") + " (*)" @ cObj
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

        DISPLAY STREAM rpt
            cObj
            areaName
            WITH FRAME quick-report.
        DOWN STREAM rpt WITH FRAME quick-report.

        /* done with this */
        IF ttObjAttrs.area-buf-pool = "Primary" THEN
           DELETE ttObjAttrs.
    END.

    IF foundNotAssigned THEN DO:
        IF skipLine THEN 
            DOWN STREAM rpt 1 WITH FRAME rptline.

        DISPLAY STREAM rpt 
            "(*) Table not assigned to the alternate buffer pool at the object level"
            @ line
            WITH FRAME rptline.
        DOWN STREAM rpt 1 WITH FRAME rptline.
    END.

    /* now check if there are objects assigned at the area level */
    IF CAN-FIND(FIRST ttObjAttrs) THEN DO:
        IF skipLine THEN 
            DOWN STREAM rpt 1 WITH FRAME rptline.

        DISPLAY STREAM rpt 
            "List of object-level assignable objects that are assigned to the"
            @ line
            WITH FRAME rptline.
        DOWN STREAM rpt 1 WITH FRAME rptline.
        DISPLAY STREAM rpt 
            "alternate buffer pool at the area level"
            @ line
            WITH FRAME rptline.
        DOWN STREAM rpt 1 WITH FRAME rptline.

        cTable = "".

        FOR EACH ttObjAttrs:

            IF ttObjAttrs.obj-type NE "TABLE" THEN DO:
                /* for table.object, strip out the table part */
               IF cTable NE ENTRY(1, ttObjAttrs.obj-name, ".") THEN DO:
                   ASSIGN cTable = ENTRY(1, ttObjAttrs.obj-name, ".").
                   /* the table itself is not assigned, so
                      we will log the table name so the object appears
                      indented underneath it.
                   */
                   DISPLAY STREAM rpt 
                       ENTRY(1, ttObjAttrs.obj-name,".") + " (*)" @ cObj
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

            DISPLAY STREAM rpt
                cObj
                areaName
                WITH FRAME quick-report.
            DOWN STREAM rpt WITH FRAME quick-report.
        END.

    END.

    IF VALID-HANDLE(hArea) THEN
        DELETE OBJECT hArea.

END PROCEDURE.


