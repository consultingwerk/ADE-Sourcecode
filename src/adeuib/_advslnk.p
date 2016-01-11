&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r2 GUI
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
/*----------------------------------------------------------------------------

File: _advslnk.p

Description:
   Advise the user about SmartLinks to add.  This looks at a SmartObject and
   sees if it needs any links

   groupAssign: If a potential GroupAssign-Source (i.e. an object whose
      SupportedLinks includes GroupAssign-Source) is an Update-Source
      (i.e., has an actual Update link to an SDO or other Update-Target), then
      the Group-Assign link should be suggested between that object and any
      other object which can be a GroupAssign-Target AND which has the same 
      Data-Source

   Commit: Default assumption is that multiple DataObjects should NOT be connected
      by the Commit Link except when the developer specifically requests it. The Link
      Advisor should suggest a link only from an object which can ONLY be a 
      Commit-Source (not a Commit-Target to other objects which can be Commit-Targets.
      It should not suggest a link from an object than can be both a Commit-Source and
      Target.

Input Parameters:
   p_U-self-recid - recid of the object to link.

Output Parameters:
   <None>

Author:  Wm.T.Wood

Date Created: March 1995
Update: 2/98 SLK Handle ADM2
        3/98 SLK Added SmartData to SmartData Mapping
        03/10/98 SLK Added v9 object matching for browser, viewer and smartdata
        03/12/98 SLK disallow recursive linking for SmartData
        03/24/98 SLK Added NA-Foreign-Fields-advslnk
        06/22/98 SLK Added GROUP-ASSIGN
        02/24/99 TSM Changed wording of Advisor to suggest that two query
                     objects "can" be linked rather than "should" be 
                     linked together with a Data Link
        02/25/99 SLK Added ADM2 check to make sure a 
                 updatePanel->TABLE-IO LINK-> is to a visual object that has an
                 existing UPDATE-LINK to a data source


----------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER p_U-self-recid AS RECID NO-UNDO.

/* ************************* Shared Definitions ************************ */
 
{ adeuib/uniwidg.i }  /* Universal Widget Records */
{ adeuib/links.i }    /* ADM Links temp-table */
{ adeuib/advice.i }   /* Include File containing controls for the Advisor */
{ adeuib/uibhlp.i }   /* Include File containing HELP file Context ID's */
{ adecomm/adefext.i } /* UIB names include file */
{ adeuib/sharvars.i } /* Shared variables */

/* _UIB-CODE-BLOCK-END */
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
         HEIGHT             = 2
         WIDTH              = 40.
                                                                        */
&ANALYZE-RESUME
 



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ************************ Local Definitions  ************************* */

DEFINE VAR cnt AS INTEGER NO-UNDO.
DEFINE VAR i   AS INTEGER NO-UNDO.

/* Local copies of attributes for the object. */
DEFINE VAR a-links   AS CHAR NO-UNDO.

DEFINE VAR link2test AS CHAR NO-UNDO.    

DEFINE VARIABLE src_isQuery   AS LOGICAL   NO-UNDO.
DEFINE VARIABLE targ_isQuery  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE src_TblList   AS CHARACTER NO-UNDO.
DEFINE VARIABLE p_Result      AS CHARACTER NO-UNDO.
DEFINE VARIABLE cTargetType   AS CHARACTER NO-UNDO.
DEFINE VARIABLE cSourceType   AS CHARACTER NO-UNDO.

DEFINE VARIABLE pc_errorMsg  AS CHARACTER NO-UNDO.

DEFINE VARIABLE dataObjectString AS CHARACTER NO-UNDO.

DEFINE VARIABLE l-srcSTRINGRECID_U      AS CHARACTER NO-UNDO.
DEFINE VARIABLE l-srcU_NAME             AS CHARACTER NO-UNDO.
DEFINE VARIABLE l-srcU_SUBTYPE          AS CHARACTER NO-UNDO.
DEFINE VARIABLE l-srcS_HANDLE           AS HANDLE    NO-UNDO.
DEFINE VARIABLE l-destSTRINGRECID_U     AS CHARACTER NO-UNDO.
DEFINE VARIABLE l-destU_NAME            AS CHARACTER NO-UNDO.
DEFINE VARIABLE l-destU_SUBTYPE         AS CHARACTER NO-UNDO.
DEFINE VARIABLE l-destS_HANDLE          AS HANDLE    NO-UNDO.

DEFINE BUFFER x_U  FOR _U.
DEFINE BUFFER xx_U FOR _U.
DEFINE BUFFER x_S  FOR _S.
DEFINE BUFFER xx_S FOR _S.

/* Variables used for adm version */
{adeuib/vsookver.i}
/* ***************************  Main Block  *************************** */

/* Find the object and its procedure */
FIND _U WHERE RECID(_U) eq p_U-self-recid.
FIND _S WHERE RECID(_S) eq _U._x-recid.
FIND _P WHERE _P._WINDOW-HANDLE eq _U._WINDOW-HANDLE.

/* Determine admVersion */
{adeuib/admver.i _S._HANDLE admVersion}.

/* Test if the item needs one of the basic links.  Note that the link type
   is used in messages, so make it leading caps. */  

/* Get the list of links supported by this object (and supported tables) */
IF admVersion LT "ADM2":U THEN 
DO:
   RUN get-attribute IN _S._HANDLE ('Supported-Links':U).
   a-links = IF RETURN-VALUE eq ? THEN "":U ELSE RETURN-VALUE.
END.
ELSE
   a-links = DYNAMIC-FUNCTION("getSupportedLinks":U IN _S._HANDLE) NO-ERROR.

/* External Tables only supported in ADM1 */
/* Record linking is a little tricky.  We only want to test Record Source first
   if there are no EXTERNAL-TABLES required by the object. */
IF CAN-DO (a-links, "Record-Source":U) THEN DO:
   IF admVersion LT "ADM2":U THEN DO: 
      RUN get-attribute IN _S._HANDLE ('External-Tables':U).
      IF RETURN-VALUE eq "":U OR RETURN-VALUE eq ? 
      THEN RUN fill-link ("Record-Source":U).
   END. /* ADM1 */
   ELSE DO:
      RUN fill-link ("Record-Source":U).
   END.
END.
IF CAN-DO (a-links, "Record-Target":U) THEN RUN fill-link ("Record-Target":U).

/* Data linking is a little tricky, We want check to see if there is a 
 * data-source for which we can be a data-target first, before testing if
 * we can be a data-source bg#*/
IF CAN-DO(a-links,"Data-Source":U) AND CAN-DO(a-links,"Data-Target":U) THEN
DO:
   RUN fill-link ("Data-Target":U).
   RUN fill-link ("Data-Source":U).
END.

/* Other links involve no special tests... Just see if the object supports
   them. */
cnt = NUM-ENTRIES(a-links).
DO i = 1 TO cnt:
  link2test = ENTRY(i, a-links).

  /* Don't redo the Data-Target, Data-Source if it was taken care of above.
   * If would have been taken care of above ONLY if Data-Target AND Data-Source
   * is w/in the a-links. Ditto for Record-Source, Record-Target.
   * Do all other possible links otherwise
   */
  IF NOT CAN-DO ("Record-Source,Record-Target":U, link2test)
     AND 
  (NOT (CAN-DO(a-links,"Data-Target":U) 
    AND CAN-DO(a-links,"Data-Source":U)
    AND CAN-DO("Data-Target,Data-Source":U, link2test))
  )
  THEN RUN fill-link (link2test).     
END.

/* ********************** Included Procedures ***************************** */ 

/* Routines to validate record link between two objects -
   (Shared by _linkadd.p and this procedure). */
{ adeuib/_chkrlnk.i }

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fill-link Procedure 
PROCEDURE fill-link :
/*--------------------------------------------------------------------
 * fill-link: Tries to find a suitable SmartOject to link to.  Where the
 *            current object will be the link-type.  For example, if
 *            p_link-name is "Record-Source", then we are looking for a 
 *            SmartObject to be the Target.  In the parlance of this 
 *            routine:
 *                  p_link-name   = Record-Source
 *                  link-end      = Source
 *                  link-to-find  = Target
 *                  a-links       = Supported-lins for p_link-name
 *                  x-links       = Supported-Links for testing
 * Inputs:
 *    p_link-name - The link (e.g. "Navigation-Source" or "Record-Target"
 * NOTE: This is used in messages to the user so it should be
 *       Leading Caps.
 *--------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p_link-name AS CHAR NO-UNDO.

  DEFINE VARIABLE choice           AS CHAR NO-UNDO.
  DEFINE VARIABLE choice2          AS CHAR NO-UNDO.
  
  DEFINE VARIABLE ipos             AS INTEGER NO-UNDO.
  
  DEFINE VARIABLE link-end         AS CHAR NO-UNDO. 
  DEFINE VARIABLE link-to-find     AS CHAR NO-UNDO.
  DEFINE VARIABLE link-type        AS CHAR NO-UNDO.
  DEFINE VARIABLE x-links          AS CHAR NO-UNDO.

  
  DEFINE VARIABLE link-filled      AS LOGICAL NO-UNDO.
  DEFINE VARIABLE link-possible    AS LOGICAL NO-UNDO.
  DEFINE VARIABLE link-found       AS LOGICAL NO-UNDO.
  DEFINE VARIABLE keys-possible    AS CHAR NO-UNDO.
  DEFINE VARIABLE never-again      AS LOGICAL NO-UNDO.

  DEFINE VARIABLE more-info        AS CHAR NO-UNDO.
  DEFINE VARIABLE opt-cnt          AS INTEGER NO-UNDO.
  DEFINE VARIABLE opt-list         AS CHAR NO-UNDO.
  DEFINE VARIABLE test             AS CHAR NO-UNDO.
  DEFINE VARIABLE crecommend       AS CHAR INIT " should" NO-UNDO.
  
  /* Variables needed to store local copies of values. */
  DEFINE VAR source-ext-tables AS CHAR NO-UNDO.
  DEFINE VAR source-int-tables AS CHAR NO-UNDO.
  DEFINE VAR source-all-tables AS CHAR NO-UNDO.
  DEFINE VAR source-keys-sup   AS CHAR NO-UNDO.
  DEFINE VAR target-keys-acc   AS CHAR NO-UNDO.
  DEFINE VAR target-ext-tables AS CHAR NO-UNDO.
  
  /* Get additional attribute need to test "Record-Source" and "Record-Target".
     Test to see if we don't need to check further. */
  IF p_link-name eq "Record-Source":U THEN DO:
     IF admVersion LT "ADM2":U THEN DO:
       RUN get-attribute IN _S._HANDLE ('External-Tables':U).
       source-ext-tables = IF RETURN-VALUE eq ? THEN "" ELSE RETURN-VALUE.
       RUN get-attribute IN _S._HANDLE ('Internal-Tables':U).
       source-int-tables = IF RETURN-VALUE eq ? THEN "" ELSE RETURN-VALUE.
       RUN get-attribute IN _S._HANDLE ('Keys-Supplied':U).
       source-keys-sup = IF RETURN-VALUE eq ? THEN "" ELSE RETURN-VALUE.
     END. /* ADM1 */
     ELSE DO:
       /* Progress ADM2 does not support Record-Source but an user can 
        * set it up on their own.
        */
       source-ext-tables = "":U.
       cValue = DYNAMIC-FUNCTION("getInternalTables":U IN _S._HANDLE) NO-ERROR.
       source-int-tables = IF ERROR-STATUS:ERROR OR cValue eq ? THEN "":U ELSE cValue.
       cValue = DYNAMIC-FUNCTION("getKeysSupplied":U IN _S._HANDLE) NO-ERROR.
       source-keys-sup = IF ERROR-STATUS:ERROR OR cValue eq ? THEN "":U ELSE cValue.
     END. /* > ADM1 */
    /* Can we just leave? If it has can supply no keys or tables. */
    IF source-keys-sup eq "":U AND 
       source-ext-tables eq "":U AND source-int-tables eq "":U 
    THEN RETURN.

  END.
  /* "Record-Target" test. */
  IF p_link-name eq "Record-Target":U THEN DO:
    IF admVersion LT "ADM2":U THEN DO:
       RUN get-attribute IN _S._HANDLE ('External-Tables':U).
       target-ext-tables = IF RETURN-VALUE eq ? THEN "":U ELSE RETURN-VALUE.
       RUN get-attribute IN _S._HANDLE ('Keys-Accepted':U).
       target-keys-acc = IF RETURN-VALUE eq ? THEN "":U ELSE RETURN-VALUE.
    END. /* ADM1 */
    ELSE DO:
       target-ext-tables = "":U.
       cValue = DYNAMIC-FUNCTION("getKeysAccepted":U IN _S._HANDLE) NO-ERROR.
       target-keys-acc = IF ERROR-STATUS:ERROR OR cValue eq ? THEN "":U ELSE cValue.
    END. /* > ADM1 */
    /* Can we just leave? */
    IF target-keys-acc eq "":U AND target-ext-tables eq "":U 
    THEN RETURN.
  END.
  
  /* The link name is the type followed by the direction.  The other end
     is the opposite of link-end. [NOTE that links themselves may have
     a hyphen in them, so use R-INDEX to find the end.] */  
  ipos = R-INDEX (p_link-name, "-":U).
  IF ipos < 1 /* This should never happen...but just in case...*/
  THEN ASSIGN 
         link-type     = "SmartLink":U
         link-end      = "Source":U
         link-to-find  = "SmartLink-Target":U.
  ELSE ASSIGN
         link-type     = SUBSTRING (p_link-name, 1, ipos - 1, "CHARACTER":U)
         link-end      = SUBSTRING (p_link-name, ipos + 1, -1, "CHARACTER":U)
         link-to-find  = link-type + "-":U +
                      (IF link-end eq "Source":U THEN "Target":U ELSE "Source":U)   
         /* No options have yet been found. */
         opt-cnt       = 0
         opt-list      = "":U.    
  
  /* If the object can be a source, then does it have for a target.
     If it can be a target, then does it already have a source. */
  link-filled = no.
  IF link-end eq "SOURCE":U THEN DO:
    FROM-SEARCH:
    FOR EACH _admlinks WHERE _admlinks._link-source eq STRING(RECID(x_U))
                         AND _admlinks._link-type   eq link-type,
        FIRST xx_U WHERE RECID(xx_U) eq INTEGER(_admlinks._link-dest)
                     AND xx_U._STATUS eq "NORMAL":U:
      link-filled = YES.
      LEAVE FROM-SEARCH.
    END. /* FROM-SEARCH */
  END. /* IF ... SOURCE... */
  ELSE DO: 
    FROM-SEARCH:
    FOR EACH _admlinks WHERE _admlinks._link-dest   eq STRING(RECID(x_U))
                         AND _admlinks._link-type   eq link-type,
        FIRST xx_U WHERE RECID(xx_U) eq INTEGER(_admlinks._link-source)
                     AND xx_U._STATUS eq "NORMAL":U:
      link-filled = YES.
      LEAVE FROM-SEARCH.
    END. /* FROM-SEARCH */
  END. /* IF...NOT SOURCE... */ 
  
  /* The link was NOT filled... Find something not deleted to fill it */   
  IF NOT link-filled THEN DO:
  
    /* Special Cases: ---
       A PAGE-SOURCE generally links to the current container. */
    IF link-to-find eq "PAGE-TARGET":U THEN DO:
      IF CAN-DO(_P._links, "PAGE-TARGET":U) THEN 
        ASSIGN opt-cnt  = 1
               opt-list =  "Add. Create link to this container.," +          
                           STRING(RECID(_P)).
    END.
    
    /* Look for something that needs a link of this type. (and that isn't
       the same object we are trying to link). */
    /* No need to check for version since we are only looking at the same
     * window handle which we already restrict to the valid versions */
    FOR EACH x_U WHERE x_U._TYPE eq "SmartObject":U
                   AND x_U._WINDOW-HANDLE eq _U._WINDOW-HANDLE
                   AND x_U._STATUS eq "NORMAL":U
                   AND RECID(x_U) ne p_U-self-recid,
          FIRST x_S WHERE RECID(x_S) eq x_U._x-recid:    
      /* Get the SmartObject information. */
      IF admVersion LT "ADM2":U THEN DO:
         RUN get-attribute IN x_S._HANDLE('Supported-Links':U).
         x-links = IF RETURN-VALUE eq ? THEN "":U ELSE RETURN-VALUE.
      END. /* ADM1 */
      ELSE DO:
         cValue = DYNAMIC-FUNCTION("getSupportedLinks":U IN x_S._HANDLE) NO-ERROR.
         x-links = IF ERROR-STATUS:ERROR OR cValue eq ? THEN "":U ELSE cValue.
      END. /* > ADM1 */

      /* Is this a possibility?  That is, is it a possible other end for the
         link, and are there no links already defined of this type 
         (to not-DELETED objects) */
      IF CAN-DO (x-links, link-to-find) THEN DO:
        ASSIGN link-possible = YES       
               more-info     = "":U.

        /* Starting with V9 objects, for Browser and Viewers to use a 
         * SmartData as a Data Source, their 'signatures' must match.
         */
        IF admVersion >= "ADM2":U THEN
        DO:
           RUN ok-sig-match (INPUT _S._HANDLE, 
                          INPUT x_S._HANDLE, 
                          INPUT link-type, 
                          INPUT NO,
                          OUTPUT link-possible,
                          OUTPUT pc_errorMsg).

           IF link-possible THEN 
           DO:
              RUN ok-link (INPUT _S._HANDLE, 
                          INPUT x_S._HANDLE, 
                          INPUT link-type, 
                          INPUT NO,
                          OUTPUT link-possible,
                          OUTPUT pc_errorMsg).
           END. /* Passed signature, test link */ 
        END. /* ADM2 */

        IF link-possible THEN DO:

           IF link-end eq "SOURCE":U THEN DO:
             /* A SmartObject is not a possible RECORD-TARGET if it does not
                use the TABLES found by this object. */
             IF link-type eq "RECORD":U THEN DO:
               IF admVersion LT "ADM2":U THEN DO:
                  RUN get-attribute IN x_S._HANDLE ('External-Tables':U).
                  target-ext-tables = IF RETURN-VALUE eq ? THEN "":U ELSE RETURN-VALUE.
                 END. /* ADM1 */
               ELSE DO:
                  target-ext-tables = "":U.
               END. /* > ADM1 */
               /* Try to link with External Tables... */
               RUN ok-table-source (
                           INPUT  source-int-tables, source-ext-tables,
                           INPUT  target-ext-tables,
                           OUTPUT link-possible). 
               /* Test keys if external tables didn't work... */
               IF link-possible eq NO THEN DO:
                 IF admVersion LT "ADM2":U THEN DO:
                    RUN get-attribute IN x_S._HANDLE ('Keys-Accepted').
                    target-keys-acc = IF RETURN-VALUE eq ? THEN "":U ELSE RETURN-VALUE.
                 END. /* ADM1 */
                 ELSE DO:
                    cValue = DYNAMIC-FUNCTION("getKeysAccepted":U IN x_S._HANDLE) NO-ERROR.
                    target-keys-acc = IF ERROR-STATUS:ERROR OR cValue eq ? THEN "":U ELSE cValue.
                 END. /* > ADM1 */
   
                 RUN ok-key-source (
                           INPUT  source-keys-sup,
                           INPUT  target-keys-acc,
                           OUTPUT keys-possible). 
                 IF keys-possible ne  "":U THEN link-possible = YES.
                 IF link-possible THEN more-info = REPLACE(keys-possible,",":U, CHR(13)).
               END.
             END.
             IF link-possible THEN DO:          
                /* Why isn't there a check for RECORD? */
                IF link-type EQ "DATA":U THEN DO:

                /* A SmartObject is not a possible DATA-TARGET if it already 
                has a DATA-SOURCE. */
                 FOR EACH _admlinks WHERE 
                          _admlinks._link-dest EQ STRING(RECID(x_U))
                      AND _admlinks._link-type EQ link-type,
                    FIRST xx_U WHERE 
                          RECID(xx_U) EQ INTEGER(_admlinks._link-source) 
                      AND xx_u._STATUS EQ "NORMAL":U:
                     link-possible = NO.
                 END.

                 IF link-possible THEN
                 DO:
               /* If we finding a DATA-SOURCE, make sure that we don't get a
                  circular link. Keep checking DATA-TARGET of this object to make
                  sure that the link is possible. */
                 test = STRING(RECID(_U)). /* The object we are testing. */
                 LOOP-SEARCH:
                 REPEAT:
                   FIND _admlinks WHERE _admlinks._link-dest EQ test
                                    AND _admlinks._link-type EQ link-type NO-ERROR.
                   /* If we get to the end, then no loop has been found, and we can leave.
                      If we find a loop that goes to the proposed object (x_U), then the
                      link is not possible. */
                   IF NOT AVAILABLE _admlinks THEN 
                     LEAVE LOOP-SEARCH.
                   /* If we get back to where we started, then there is already a 
                      circular link.  THIS SHOULD NEVER HAPPEN, but check for it anyway
                      to avoid an infinite loop. */
                   IF _admlinks._link-source EQ STRING(RECID(_U)) THEN 
                     LEAVE LOOP-SEARCH.
                   /* This is a "real" circular link. If we find it, a link is NOT possible. */
                   IF _admlinks._link-source EQ STRING(RECID(x_U)) THEN DO:
                     link-possible = no.
                     LEAVE LOOP-SEARCH.
                   END.
                   /* Test the next link in the chain. */
                   test = _admlinks._link-source.
                END. /* LOOP-SEARCH */
                END. /* If link-possible */
               END. /* DATA */
               /* groupAssign: If a potential GroupAssign-Source (i.e. an object whose
                * SupportedLinks includes GroupAssign-Source) is an Update-Source
                * (i.e., has an actual Update link to an SDO or other Update-Target),
                * then the Group-Assign link should be suggested between that object 
                * and any other object which can be a GroupAssign-Target AND which has 
                * the same Data-Source
                */
               ELSE IF link-type = "GROUPASSIGN":U THEN DO:
                  /* SOURCE
                   * CASE 1: I am a DATA-TARGET and UPDATE-SOURCE viewer
                   *         I am potential GROUPASSIGN-SOURCE 
                   *         Check current object if it has same DATA-TARGET 
                   *         and is a potential GROUPASSIGN-TARGET
                   *  By the time you get here, the potential GROUPASSIGN-TARGET
                   *  has already been checked via FOR EACH x_U...
                   * CASE 2: I am a DATA-TARGET and NOT UPDATE-SOURCE viewer
                   *         I am potential GROUPASSIGN-TARGET 
                   *         DO NOTHING
                   *
                   * One source, Many targets
                   */
                  /* Am I an Update-Source? */
                  FIND FIRST _admlinks WHERE _admlinks._link-source EQ STRING(RECID(_U))
                                         AND _admlinks._link-type = "UPDATE":U NO-ERROR.
                  IF NOT AVAILABLE _admlinks THEN link-possible = NO.
                  ELSE DO:
                     /* Am I a Data-Target */
                     FIND FIRST _admlinks 
                          WHERE _admlinks._link-source EQ STRING(RECID(_U))
                            AND _admlinks._link-type = "DATA":U NO-ERROR.
                     IF NOT AVAILABLE _admlinks THEN link-possible = NO.
                     ELSE DO:
                        ASSIGN dataObjectString = _admlinks._link-dest.
                        /* Do they share a data-target? */
                        FIND FIRST _admlinks
                          WHERE _admlinks._link-dest EQ STRING(RECID(x_U))
                            AND _admlinks._link-source = dataObjectString
                            AND _admlinks._link-type = "DATA":U NO-ERROR.
                        IF NOT AVAILABLE _admlinks THEN link-possible = NO.
                     END. /* Date-Target */ 
                  END. /* Update-Source */
               END. /* GroupAssign */
               /* Commit: Default assumption is that multiple DataObjects should NOT 
                * be connected by the Commit Link except when the developer 
                * specifically requests it. The Link Advisor should suggest a link 
                * only from an object which can ONLY be a Commit-Source (not a 
                * Commit-Target to other objects which can be Commit-Targets.  It 
                * should not suggest a link from an object than can be both a 
                * Commit-Source and Target.
                * 
                * One source, one target
                */
               ELSE IF link-type = "COMMIT":U THEN DO:
                /* Am I also a commit-target? */
                IF CAN-DO(a-links, "Commit-Target":U) THEN link-possible = NO.
               END. /* Commit */
               ELSE IF admVersion >= "ADM2":U AND
                    link-type = "TABLEIO":U THEN
               DO: /* Only in ADM2 - UpdatePanel->TableIO->Object if 
                    * object already is an UpdateSource 
                    * NOTE: This is when the UpdatePanel is dropped after object*/
                     ASSIGN link-found = NO.
                     TO-SEARCH:
                     FOR EACH _admlinks WHERE 
                                          _admlinks._link-source eq STRING(RECID(x_U))
                                      AND _admlinks._link-type  eq "UPDATE":U,
                               FIRST xx_U WHERE 
                                  RECID(xx_U) eq INTEGER(_admlinks._link-dest) 
                                  AND xx_U._STATUS eq "NORMAL":U:
                               ASSIGN 
                                  link-found = YES.
                               LEAVE TO-SEARCH.
                     END. /* TO-SEARCH */
                     IF NOT link-found THEN link-possible = NO. 
               END.
               ELSE DO:
                   TO-SEARCH:
                   FOR EACH _admlinks WHERE _admlinks._link-dest  eq STRING(RECID(x_U))
                                    AND _admlinks._link-type  eq link-type,
                      FIRST xx_U WHERE RECID(xx_U) eq INTEGER(_admlinks._link-source) 
                                AND xx_U._STATUS eq "NORMAL":U:
                    link-possible = NO.
                    LEAVE TO-SEARCH.
                  END. /* TO-SEARCH */
                END. /* ELSE... */
             END. /* IF link-possible...*/
           END. /* IF...SOURCE... */
           ELSE DO:
             /* Another SmartObject is not a possible Record-Source if it does not
                find the TABLES or KEYS needed by this object. */
             IF link-type eq "RECORD":U THEN DO:
                IF admVersion LT "ADM2":U THEN DO:
                  RUN get-attribute IN x_S._HANDLE('Internal-Tables':U).
                  source-int-tables = IF RETURN-VALUE eq ? THEN "":U ELSE RETURN-VALUE.
                  RUN get-attribute IN x_S._HANDLE ('External-Tables').
                  source-ext-tables = IF RETURN-VALUE eq ? THEN "":U ELSE RETURN-VALUE.
                 END. /* ADM1 */
               ELSE DO:
                  cValue = DYNAMIC-FUNCTION("getInternalTables":U IN x_S._HANDLE) NO-ERROR.
                  source-int-tables = IF ERROR-STATUS:ERROR OR cValue eq ? THEN "":U ELSE cValue.
                  source-ext-tables = "":U.
               END. /* > ADM1 */
               IF target-ext-tables ne "":U 
               THEN RUN ok-table-source (
                           INPUT  source-int-tables, source-ext-tables,
                           INPUT  target-ext-tables,
                           OUTPUT link-possible). 
               ELSE DO:
                  IF admVersion LT "ADM2":U THEN DO:
                    RUN get-attribute IN x_S._HANDLE ('Keys-Supplied':U).
                    source-keys-sup = IF RETURN-VALUE eq ? THEN "":U ELSE RETURN-VALUE.
                   END. /* ADM1 */
                 ELSE DO:
                    cValue = DYNAMIC-FUNCTION("getKeysSupplied":U IN x_S._HANDLE) NO-ERROR.
                    source-keys-sup = IF ERROR-STATUS:ERROR OR cValue eq ? THEN "":U ELSE cValue.
                 END. /* > ADM1 */
                 RUN ok-key-source (
                           INPUT  source-keys-sup,
                           INPUT  target-keys-acc,
                           OUTPUT keys-possible). 
                 IF keys-possible eq  "":U THEN link-possible = NO.
                 IF link-possible THEN more-info = REPLACE(keys-possible,",":U, CHR(13)).
               END.
             END.

             /* A SmartDataObject->Data->SmartDataBrowser only
              * if there is not existing SmartDataObject->Data->SmartDataBrowser which exists
              * In other words, no 2 smartDataBrowsers can be linked to the same SmartDataObject
              * unless one is a query SmartDataBrowser 
              */
             IF     link-possible 
                AND admVersion >= "ADM2":U
                AND link-type EQ "DATA":U THEN DO:
                /* Determine if TARGET is a SmartDataBrowser
                 * Determine if SOURCE is a SmartDataObject
                 */
                ASSIGN
                   cTargetType  = DYNAMIC-FUNCTION("getObjectType":U IN _S._HANDLE)
                   targ_isQuery = DYNAMIC-FUNCTION("getQueryObject":U IN _S._HANDLE)
                   cSourceType  = DYNAMIC-FUNCTION("getObjectType":U IN x_S._HANDLE) NO-ERROR.
                IF     (cTargetType = "SmartDataBrowser":U AND NOT targ_isQuery)
                   AND cSourceType = "SmartDataObject":U THEN
                DO: 
                   /* Determine if the SmartDataObject already has a DATA link 
                    * with another SmartDataBrowser (not a query SmartDataBrowser)
                    */
                   TO-SEARCH:
                   FOR EACH _admlinks WHERE _admlinks._link-source  eq STRING(RECID(x_U))
                                    AND _admlinks._link-type  eq link-type,
                      FIRST xx_U WHERE RECID(xx_U) eq INTEGER(_admlinks._link-dest)  
                                AND xx_U._STATUS eq "NORMAL":U:
                      /* Determine if SDB */
                      FIND FIRST xx_S WHERE RECID(xx_S) eq xx_U._x-recid NO-ERROR.
                      ASSIGN 
                         cTargetType = 
                             DYNAMIC-FUNCTION("getObjectType":U  IN xx_S._HANDLE)
                         targ_isQuery = 
                             DYNAMIC-FUNCTION("getQueryObject":U IN xx_S._HANDLE)
                      NO-ERROR.
                      IF cTargetType = "SmartDataBrowser":U 
                         AND NOT targ_isQuery THEN 
                      DO:
                         ASSIGN link-possible = NO.
                         LEAVE TO-SEARCH.
                      END. /* Invalid link attempt */
                  END. /* TO-SEARCH */
                END. /* Check SmartDataBrowser, SmartDataObject */
             END. /* Check DATA link in ADM2 */ 

             IF link-possible THEN DO:
               /* If we finding a RECORD-TARGET, make sure that we don't get a
                  circular link. Keep checking RECORD-SOURCE of this object to make
                  sure that the link is possible. */
               IF link-type eq "Record":U OR link-type EQ "DATA":U THEN DO:
                 test = STRING(RECID(_U)). /* The object we are testing. */
                 LOOP-SEARCH:
                 REPEAT:
                   FIND _admlinks WHERE _admlinks._link-source eq test
                                    AND _admlinks._link-type eq link-type NO-ERROR.
                   /* If we get to the end, then no loop has been found, and we can leave.
                      If we find a loop that goes to the proposed object (x_U), then the
                      link is not possible. */
                   IF NOT AVAILABLE _admlinks THEN 
                     LEAVE LOOP-SEARCH.
                   /* If we get back to where we started, then there is already a 
                      circular link.  THIS SHOULD NEVER HAPPEN, but check for it anyway
                      to avoid an infinite loop. */
                   IF _admlinks._link-dest eq STRING(RECID(_U)) THEN 
                     LEAVE LOOP-SEARCH.
                   /* This is a "real" circular link. If we find it, a link is NOT possible. */
                   IF _admlinks._link-dest eq STRING(RECID(x_U)) THEN DO:
                     link-possible = no.
                     LEAVE LOOP-SEARCH.
                   END.
                   /* Test the next link in the chain. */
                   test = _admlinks._link-dest.
                 END.
               END.
               /* groupAssign: If a potential GroupAssign-Source (i.e. an object whose
                * SupportedLinks includes GroupAssign-Source) is an Update-Source
                * (i.e., has an actual Update link to an SDO or other Update-Target),
                * then the Group-Assign link should be suggested between that object 
                * and any other object which can be a GroupAssign-Target AND which has 
                * the same Data-Source
                * 
                * One Target, One Source
                */
               ELSE IF link-type = "GROUPASSIGN":U THEN DO:
                  /* TARGET
                   * CASE 1: I am a DATA-TARGET and NOT UPDATE-SOURCE viewer
                   *         I am a potential GROUPASSIGN-TARGET
                   *         Is the current object have the same DATA-TARGET, is an
                   *         UPDATE-SOURCE 
                   * CASE 2: I am a DATA-TARGET and UPDATE-SOURCE viewer
                   *         I am a potential GROUPASSIGN-TARGET
                   *         DO NOTHING
                   * one target, one source 
                   */
                  /* Am I an Update-Source? */
                  FIND FIRST _admlinks WHERE _admlinks._link-source EQ STRING(RECID(_U))
                                         AND _admlinks._link-type = "UPDATE":U NO-ERROR.
                  IF AVAILABLE _admlinks THEN link-possible = NO.
                  ELSE DO:
                     /* Am I a Data-Target */
                     ASSIGN link-found = NO.
                     TO-SEARCH:
                     FOR EACH _admlinks WHERE 
                                          _admlinks._link-dest eq STRING(RECID(_U))
                                      AND _admlinks._link-type  eq "DATA":U,
                               FIRST xx_U WHERE 
                                  RECID(xx_U) eq INTEGER(_admlinks._link-dest) 
                                  AND xx_U._STATUS eq "NORMAL":U:
                               ASSIGN 
                                  link-found = YES
                                  dataObjectString = _admlinks._link-source.
                               LEAVE TO-SEARCH.
                     END. /* TO-SEARCH */
                     IF NOT link-found THEN link-possible = NO. 
                     IF link-possible THEN
                     DO:
                        /* Does the object to test have a DATA link to the same
                         * object? Does the object have an UPDATE link?
                         */
                        /* Do they share a data-target? */
                        FIND FIRST _admlinks
                              WHERE _admlinks._link-dest EQ STRING(RECID(x_U))
                                AND _admlinks._link-source = dataObjectString
                                AND _admlinks._link-type = "DATA":U NO-ERROR.
                        FIND FIRST xx_U WHERE 
                                  RECID(xx_U) eq INTEGER(_admlinks._link-dest) 
                                  AND xx_U._STATUS eq "NORMAL":U NO-ERROR.
                        IF NOT AVAILABLE _admlinks 
                           AND NOT AVAILABLE xx_U THEN 
                        link-possible = NO.

                        /* Does the object have an UPDATE link? */
                        FIND FIRST _admlinks
                              WHERE _admlinks._link-source EQ STRING(RECID(x_U))
                                AND _admlinks._link-type = "UPDATE":U NO-ERROR.
                        FIND FIRST xx_U WHERE 
                                  RECID(xx_U) eq INTEGER(_admlinks._link-dest) 
                                  AND xx_U._STATUS eq "NORMAL":U NO-ERROR.
                        IF NOT AVAILABLE _admlinks 
                           AND NOT AVAILABLE xx_U THEN 
                        link-possible = NO.
                     END. /* Date-Target */ 
                  END. /* Update-Source */
               END. /* GroupAssign */
               /* Commit: Default assumption is that multiple DataObjects should NOT 
                * be connected by the Commit Link except when the developer 
                * specifically requests it. The Link Advisor should suggest a link 
                * only from an object which can ONLY be a Commit-Source (not a 
                * Commit-Target to other objects which can be Commit-Targets.  It 
                * should not suggest a link from an object than can be both a 
                * Commit-Source and Target.
                */
               ELSE IF link-type = "COMMIT":U THEN DO:
                  IF CAN-DO(x-links,"COMMIT-TARGET":U) THEN link-possible = NO.
               END. /* Commit */
               ELSE IF admVersion >= "ADM2":U AND
                    link-type = "TABLEIO":U THEN
               DO: /* Only in ADM2 - UpdatePanel->TableIO->Object if 
                    * object already is an UpdateSource 
                    * NOTE This is when the object is dropped after the UpdatePanel */
                     /* Am I a Update-Source? */
                     ASSIGN link-found = NO.
                     TO-SEARCH:
                     FOR EACH _admlinks WHERE 
                                          _admlinks._link-source eq STRING(RECID(_U))
                                      AND _admlinks._link-type  eq "UPDATE":U,
                               FIRST xx_U WHERE 
                                  RECID(xx_U) eq INTEGER(_admlinks._link-dest) 
                                  AND xx_U._STATUS eq "NORMAL":U:
                               ASSIGN 
                                  link-found = YES.
                               LEAVE TO-SEARCH.
                     END. /* TO-SEARCH */
                     IF NOT link-found THEN link-possible = NO. 
               END.
               ELSE DO:
               /* See if the object already is already has a link of this type. 
                * Generally, this would preclude it from being used again -- 
                * except in the case of a RECORD-SOURCE.  Record-Sources can have 
                * many record-targets. 
               */

                 TO-SEARCH:
                 FOR EACH _admlinks WHERE _admlinks._link-source eq STRING(RECID(x_U))
                                      AND _admlinks._link-type  eq link-type,
                     FIRST xx_U WHERE RECID(xx_U) eq INTEGER(_admlinks._link-dest) 
                                  AND xx_U._STATUS eq "NORMAL":U:
                   link-possible = NO.
                   LEAVE TO-SEARCH.
                
                 END. /* TO-SEARCH */
               END. /* ELSE... */
             END. /* IF link-possible...*/
           END. /* IF...NOT SOURCE...*/
        END. /* IF link-possible after signature match ...*/

        /* Is this a possible link? */
        IF link-possible THEN 
          /* 
           * Create line like: 
           *     "Add. Create link to SmartPanel h_test.,1234" 
           * Optionally add additional information to the RECID, for example in the
           * case of KEY-NAME needed. For example:
           *     "Add. Create record link to SmartViewer h_v-cust.,4321|Cust-Num<CR>Sales-Rep"
           */
          ASSIGN opt-cnt  = opt-cnt + 1
                 opt-list = opt-list +
                       (IF opt-cnt > 1 THEN  "," ELSE "") +  
                       "Add. Create link " +
                       (IF link-end eq "Source" THEN "to " ELSE "from ") + 
                       x_U._SUBTYPE + " " + x_U._NAME + ".," + 
                       STRING(RECID(x_U)) + 
                       (IF more-info eq "":U THEN "":U ELSE "|" + more-info).
        
        /* If this is a Data Link between two query objects then the advisor 
           should suggest that two objects "can" be linked with a Data Link
           rather than "should" be linked.  With two query objects the Data
           Link can go in either direction and we should not recommend that
           it "should" be linked one way and then recommend that it "should"
           be linked in the exact opposite way next - so we will just
           suggest that they "can" be linked */
        IF link-possible AND link-type = "Data" THEN DO:
          ASSIGN
            src_isQuery  = DYNAMIC-FUNCTION("getQueryObject":U IN _S._HANDLE)
            targ_isQuery = DYNAMIC-FUNCTION("getQueryObject":U IN x_S._HANDLE) NO-ERROR.
          IF src_isQuery AND targ_isQuery THEN crecommend = " can".
        END.  /* if link possible and Data link */
         
      END. /* IF CAN-DO (x-links, link-to-find) */
    END. /* FOR EACH x_U... */
     
    /* Are there any options?  We generally want to ask the user if there are
       choices, unless the user has said they don't want to be asked.  There are
       two levels that we remember:
         - Does the user want to be asked is there only one choice?
         - Do we ask when there are many choices?
       We remember each of these individually.   Also, we use a different 
       default in both cases.  If there is one choice, default to that.  If
       there are multiple choices, then default to "Cancel".
     */
    IF opt-cnt > 0 THEN DO:
      choice = IF opt-cnt eq 1 THEN ENTRY(2,opt-list) ELSE "Cancel":U.
      /* Do we need to ask the user? Check the appropriate Advisor flag. */
      IF (opt-cnt eq 1 AND {&NA-Add-Link1-advslnk} eq NO) OR
         (opt-cnt > 1  AND {&NA-Add-Link2-advslnk} eq NO)
      THEN DO:
        RUN adeuib/_advisor.w (
        /* Text */        INPUT _U._SUBTYPE + " " + _U._NAME + crecommend + " be a " +
                                link-type + " " + link-end + 
                                " for some other SmartObject. " +
                                CHR(10) + CHR(10) +
                                "The {&UIB_NAME} can automatically add a " +
                                link-type + " SmartLink for you." 
                                ,
        /* Options */     INPUT opt-list + 
                                 /* Decided not to allow Edit option from
                                  * the Advisor (wood 3/28/95) 
                                  * ",Edit. Go to the SmartLinks editor.,Edit" + */
                                 ",Cancel. Do not make a link.,Cancel",
        /* Toggle Box */  INPUT TRUE,
        /* Help Tool  */  INPUT "ab",
        /* Context    */  INPUT {&Advisor_Choose_Link},
        /* Choice     */  INPUT-OUTPUT choice,
        /* Never Again */ OUTPUT never-again ).
        
        /* Store the never again value, depending on the number of choices */
        IF opt-cnt eq 1 
        THEN {&NA-Add-Link1-advslnk} = never-again.
        ELSE {&NA-Add-Link2-advslnk} = never-again.
      END.
      
      /* Add the link if the user didn't cancel. */
      CASE choice:
        WHEN "Cancel":U THEN . /* Do Nothing */
        WHEN "Edit":U THEN RUN adeuib/_linked.w (RECID(_P), RECID(_U)).
        OTHERWISE DO:

          IF link-type = "Data":U THEN 
          DO:
             /* Using _U, find related _S which will give you object instance handle */
             FIND _S WHERE RECID(_S) eq _U._x-recid.
             /* Using choice taken, get the _U and the _S */
             FIND xx_U WHERE STRING(RECID(xx_U)) eq ENTRY(1,choice,"|":U).
             FIND xx_S WHERE RECID(xx_S) eq xx_U._x-recid.
             ASSIGN
                src_isQuery  = DYNAMIC-FUNCTION("getQueryObject":U IN _S._HANDLE)
                targ_isQuery = DYNAMIC-FUNCTION("getQueryObject":U IN xx_S._HANDLE) NO-ERROR
             .
              IF link-end eq "SOURCE":U THEN 
                 ASSIGN
                    l-srcSTRINGRECID_U = STRING(RECID(_U))
                    l-srcU_NAME        = _U._NAME
                    l-srcU_SUBTYPE     = _U._SUBTYPE
                    l-srcS_HANDLE      = _S._HANDLE
                    l-destSTRINGRECID_U = STRING(RECID(xx_U))
                    l-destU_NAME        = xx_U._NAME
                    l-destU_SUBTYPE     = xx_U._SUBTYPE
                    l-destS_HANDLE      = xx_S._HANDLE.
              ELSE
                 ASSIGN
                    l-srcSTRINGRECID_U = STRING(RECID(xx_U))
                    l-srcU_NAME        = xx_U._NAME
                    l-srcU_SUBTYPE     = xx_U._SUBTYPE
                    l-srcS_HANDLE      = xx_S._HANDLE
                    l-destSTRINGRECID_U = STRING(RECID(_U))
                    l-destU_NAME        = _U._NAME
                    l-destU_SUBTYPE     = _U._SUBTYPE
                    l-destS_HANDLE      = _S._HANDLE.

          IF src_isQuery AND targ_isQuery THEN 
          DO:
            /* Do we need to ask the user? Check the appropriate Advisor flag. */
            IF {&NA-Foreign-Fields-advslnk} eq NO THEN
            DO:
             /* SmartData h_d-sadd-3 is a Query Object.
              * SmartData h_d-sadd-2 is a Query Object.
              * You have requested a Data SmartLink to be automatically added.
              * Would you like to choose the Foreign Fields between
              * SmartData h_d-sadd-3 and SmartData h_d-sadd2
              *
              * Choose Foreign Fields SmartData h_d-sadd3 to 
              * Cancel. Add Foreign Fields later.
              */

             ASSIGN opt-list = 
                       "Choose. Specify Foreign Fields for " + l-destU_NAME 
                       + ".," + l-destSTRINGRECID_U 
                       + ",Cancel. Choose Foreign Fields later.,Cancel"
             .
             RUN adeuib/_advisor.w (
             /* Text */ 
                    l-srcU_SUBTYPE + " " + l-srcU_NAME + " is a Query Object." 
                    + CHR(10)
                    + l-destU_SUBTYPE + " " + l-destU_NAME + " is a Query Object." 
                    + CHR(10) + "You have requested a "
                    + link-type + " SmartLink to be automatically added." + CHR(10)
                    + "Would you like to choose the Foreign Fields."
                    ,
             /* Options */     INPUT opt-list,
             /* Toggle Box */  INPUT TRUE,
             /* Help Tool  */  INPUT "ab",
             /* Context    */  INPUT {&Foreign_Fields},
             /* Choice     */  INPUT-OUTPUT choice2,
             /* Never Again */ OUTPUT {&NA-Foreign-Fields-advslnk}).

             /* Get the mapping dialog if the user didn't cancel. */
             CASE choice2:
                WHEN "Cancel":U THEN . /* Do Nothing */
                OTHERWISE DO: /* Chose to map & define Foreign Fields */
                /* 
                 * src_TblList MUST BE OF FORMAT sports.customer not just customer
                 */

                 IF VALID-HANDLE(l-srcS_HANDLE) AND VALID-HANDLE(l-destS_HANDLE) THEN
                 DO:
                    RUN createObjects IN l-destS_HANDLE NO-ERROR.
                    ERROR-STATUS:ERROR = NO.
                    ASSIGN
                       p_Result = DYNAMIC-FUNCTION("getForeignFields":U IN l-destS_HANDLE)
                    NO-ERROR.

                    RUN adecomm/_mfldmap.p 
                        (INPUT l-destU_NAME,
                         INPUT l-srcU_NAME,
                         INPUT l-destS_HANDLE,
                         INPUT l-srcS_HANDLE,
                         INPUT ?,
                         INPUT IF _suppress_dbname THEN "2":U ELSE "3":U,
                         INPUT ",":U,
                         INPUT-OUTPUT p_Result).
                    ASSIGN lValue = 
                      DYNAMIC-FUNCTION("setForeignFields":U IN l-destS_HANDLE, 
                                          p_Result) NO-ERROR.
                    IF ERROR-STATUS:ERROR THEN 
                         MESSAGE "Could not set the Foreign Field Keys." VIEW-AS ALERT-BOX.
                    END. /* both are valid handles */
                END. /* Chose to map & define Foreign Fields */
             END CASE.
            END. /* Checked _never_advise */
          END. /* Two queryObjects */
          END. /* Data Link */
          ELSE
          DO:
              IF link-end eq "SOURCE":U THEN 
                 ASSIGN
                    l-srcSTRINGRECID_U = STRING(RECID(_U))
                    l-destSTRINGRECID_U = ENTRY(1,choice,"|":U).
              ELSE
                 ASSIGN
                    l-srcSTRINGRECID_U = ENTRY(1,choice,"|":U)
                    l-destSTRINGRECID_U = STRING(RECID(_U)).
          END.

          CREATE _admlinks.
          ASSIGN _admlinks._P-recid     = RECID(_P)
                 _admlinks._link-type   = link-type
                 _admlinks._link-source = l-srcSTRINGRECID_U
                 _admlinks._link-dest   = l-destSTRINGRECID_U.
          /* Is this a Record-Link using keys? We can tell by looking at the
             additional informatin in "choice", which may be of the form:
                "4321|Cust-Num<CR>Sales-Rep". 
             Replace the <CR> with commas. */
          ipos = INDEX(choice, "|":U).
          IF _admlinks._link-type eq "Record":U AND ipos > 0
          THEN RUN find-key-name (IF link-end eq "Source":U THEN x_S._HANDLE ELSE _S._HANDLE,
                                  REPLACE(SUBSTRING(choice, ipos + 1, -1, "CHARACTER":U), 
                                          CHR(13), ",")).
        END.
      END CASE. /* choice */    
    END. /* IF opt-cnt > 0... */
    
    /* As a final check...
       If we added a SmartPanel, and if there are no Queries added to it, then
       remind the user that they should add a SmartQuery (or SmartData for ADM2). 
       This was added at the suggestion of the usability testing (wood - 3/95) */
    IF NOT {&NA-No-Query-advslnk} 
       AND p_link-name eq "Navigation-Source":U
       AND opt-cnt eq 0 
    THEN DO:
      RUN adeuib/_advisor.w (
        /* Text */        INPUT _U._SUBTYPE + " " + _U._NAME +
                                " should be a Navigation Source " +
                                "for some other SmartObject. However, all " +
                                "Navigation Targets already have Navigation " +
                                "Sources associated with them." +
                                CHR(10) + 
                                "If there is a SmartBusinessObject in this window " +
                                "that you want to use as a Navigation Target, you will " +
                                "need to add the link manually. Otherwise, you may want " +
                                "to choose an existing " +
                                IF admVersion LT "ADM2":U THEN 
                                     "SmartQuery":U 
                                ELSE "SmartDataObject":U +
                                ", or create a new one, and add " +
                                "it to this " + _P._TYPE + "."
                                ,
        /* Options */     INPUT "",
        /* Toggle Box */  INPUT TRUE,
        /* Help Tool  */  INPUT "ab",
        /* Context    */  INPUT {&Advisor_No_Target},
        /* Choice     */  INPUT-OUTPUT choice ,
        /* Never Again */ OUTPUT {&NA-No-Query-advslnk}  ).
        
    END.
  END. /* IF NOT link-filled... */
END PROCEDURE. /* fill-link */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE find-key-name Procedure 
PROCEDURE find-key-name :
/*------------------------------------------------------------------------------
  Purpose:     Ask the user what Foreign-Key to use on a Record Link.  Set the
               Key-Name attribute on the target SmartObject.
  Input Parameters: 
    p_hSmO    - Handle of the Record-Target SmartObject.
    p_options - Possible keys
    
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p_hSmO AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p_options AS CHAR NO-UNDO.
   
  DEFINE VARIABLE choice           AS CHAR NO-UNDO.
  
  DEFINE VARIABLE cnt              AS INTEGER NO-UNDO.
  DEFINE VARIABLE i                AS INTEGER NO-UNDO.
  
  DEFINE VARIABLE ch               AS CHAR NO-UNDO.
  DEFINE VARIABLE opt-list         AS CHAR NO-UNDO.
  
  DEFINE VARIABLE target-key-name  AS CHAR NO-UNDO.
  
  /* What is the current value. */
  IF admVersion LT "ADM2":U THEN DO:
     RUN get-attribute IN p_hSMO ('Key-Name':U).
     target-key-name = IF RETURN-VALUE eq ? THEN "":U ELSE RETURN-VALUE.
  END. /* ADM1 */
  ELSE DO:
     cValue = DYNAMIC-FUNCTION("getKeyName":U IN p_hSMO) NO-ERROR.
     target-key-name = IF ERROR-STATUS:ERROR OR cValue eq ? THEN "":U ELSE cValue.
  END. /* > ADM1 */

  /* Ask the user about the key-name options, if necessary. */
  cnt = NUM-ENTRIES (p_options).
  CASE cnt:
    WHEN 0 THEN RETURN.
    WHEN 1 THEN choice = p_options.
    OTHERWISE DO:
      /* Assume the current choice.  Optionally ask the user if they 
         want to change. */
      IF CAN-DO(p_options, target-key-name) 
      THEN choice = target-key-name.
      ELSE choice = ENTRY(1, p_options).
      /* Should we ask if there are multiple key choices? */
      IF NOT {&NA-Key-Choice-advslnk} THEN DO:
        /* Double up each entry in options and use the advisor to
           ask the user which entry should be used.  */
        DO i = 1 TO cnt:
          ASSIGN ch      = ENTRY(i, p_options) 
                 opt-list = (IF i eq 1 THEN "":U ELSE opt-list + ",":U) + ch + ",":U + ch.
        END.
        RUN adeuib/_advisor.w (
                INPUT "Which foreign key should be used for this Record link?", 
                INPUT opt-list + ",Cancel. Set the foreign key later.,Cancel",
                INPUT yes,
                INPUT "ab":U,
                INPUT {&Advisor_Choose_Key},
                INPUT-OUTPUT choice,
                OUTPUT {&NA-Key-Choice-advslnk}). 
      END. /* IF NOT...key-choice.... */
    END. /* OTHERWISE...*/
  END CASE.

  /* Set the Key-Name attribute in the object. */
  IF choice ne "Cancel":U AND choice ne target-key-name THEN DO:
     IF admVersion LT "ADM2":U THEN
        RUN set-attribute-list IN p_hSMO ('Key-Name=':U + choice).
     ELSE lValue = DYNAMIC-FUNCTION("setKeyName":U IN p_hSMO, choice) NO-ERROR.
  END. /* ne Cancel and choice ne target-key-name */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

