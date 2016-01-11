&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*-------------------------------------------------------------------------
File: _advsrun.p

Description:
   Advise the user about running the file.  This looks at all SmartObjects and
   sees if any expected links are not filled.
   
   The links of interest are:
       TableIO-Targets, Navigation-Targets, Page-targets and Filter-targets
      (v8 Record-Sources is also checked [on anything with External Tables])
       
Input Parameters:
   phWin - Window Handle of current window
   pcMode   - RUN or SAVE

Output Parameters:
   plOk2run - TRUE if user did choose to cancel the run.
Notes: 
   Although many cases are checked, we only report the first error encountered.
   Otherwise we might really bother the user.

Author:  Wm.T.Wood

Date Created: March 1995

Modifications:
  5/22/95 wood Change default action to RUN, not cancel.
  3/98    slk  Handle ADM2. Change in syntax
  8/99    hd   Added filter-source.
               Moved duplicated logic to advice and linkMissing functions
               Added pcMode in order to also call this from SAVE 
----------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER phWin    AS HANDLE    NO-UNDO.
DEFINE INPUT  PARAMETER pcMode   AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER plOk2run AS LOGICAL   NO-UNDO.

{ adeuib/uniwidg.i }  /* Universal Widget Records */
{ adeuib/links.i }    /* ADM Links temp-table */
{ adeuib/advice.i }   /* Include File containing controls for the Advisor */
{ adeuib/uibhlp.i }   /* Include File containing HELP file Context ID's */
{ adecomm/adefext.i}  /* UIB names */

DEFINE VARIABLE cAdvice        AS CHAR    NO-UNDO.
DEFINE VARIABLE cChoice        AS CHAR    NO-UNDO.
DEFINE VARIABLE lLinkMissing   AS LOGICAL NO-UNDO.
DEFINE VARIABLE cSuppLinks     AS CHAR    NO-UNDO.  
DEFINE VARIABLE cMode          AS CHAR    NO-UNDO.
DEFINE VARIABLE lNA            AS LOGICAL NO-UNDO.
   
/* v8 record-target */
DEFINE VARIABLE s_ext-tables   AS CHAR NO-UNDO.
DEFINE VARIABLE s_key-name     AS CHAR NO-UNDO.

DEFINE BUFFER x_U FOR _U.

/* Variables used for adm version */
{adeuib/vsookver.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-advice) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD advice Procedure 
FUNCTION advice RETURNS CHARACTER
  (pcLink       AS CHARACTER,
   pcSubscriber AS CHARACTER,
   pcTask       AS CHARACTER,
   pcMessage    AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-linkMissing) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD linkMissing Procedure 
FUNCTION linkMissing RETURNS LOGICAL
  (pcLink AS CHAR)  FORWARD.

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
         HEIGHT             = 14.91
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
 
 /* Degenerate Case: If we don't need to ask, then always run */
 plOk2Run = TRUE.

 IF pcMode = "RUN":U AND {&NA-OK-Links-run-advsrun} THEN 
   RETURN.
 
 IF pcMode = "SAVE":U AND {&NA-OK-Links-save-advsrun} THEN 
   RETURN.
 
 /* Find the object and its procedure.  The procedure RECID is used in 
    linkMissing() to check whether a link goes to the container. */
 FIND _P WHERE _P._WINDOW-HANDLE eq phWin.
  
 /* Don't bother checking if the Procedure doesn't allow SmartObjects */
 IF NOT CAN-DO(_P._Allow, "Smart":U) THEN RETURN.
  
 /* Can we find a SmartObject that needs links, but have none defined? */
 FOR 
 EACH _U WHERE _U._WINDOW-HANDLE eq phWin 
         AND _U._STATUS eq "NORMAL":U
         AND _U._TYPE eq "SmartObject":U,
 FIRST _S WHERE RECID(_S) eq _U._x-recid: 
         /* Get the list of supported links. */
   {adeuib/admver.i _s._HANDLE admVersion}.   
    
   IF admVersion LT "ADM2":U THEN DO:
      RUN get-attribute IN _S._HANDLE ('Supported-Links':U).
      cSuppLinks = RETURN-VALUE.
   END. /* ADM1 */
   ELSE 
     cSuppLinks = dynamic-function("getSupportedLinks":U IN _S._HANDLE) NO-ERROR.
    
    /* Test for a navigation target?  Do this first because the "biggest"
       mistake new users make is not realizing that a query is missing in
       their applications.  They have the SmartPanel and a SmartViewer,
       but no SmartQuery. (wood 3/17/95) */
   IF cAdvice eq "":U AND CAN-DO (cSuppLinks, "Navigation-Source":U) THEN
   DO:
     IF linkMissing("Navigation-Source":U) THEN
         cAdvice = advice("Navigation-Source":U,
                         IF admVersion LT "ADM2":U 
                         THEN "SmartQuery":U
                         ELSE "SmartDataObject":U,
                         "":U,
                         "":U). 

   END. /* IF needs a NAVIGATION TARGET... */
    
    /* Test for a TableIO target? */
   IF cAdvice eq "":U AND CAN-DO (cSuppLinks, "TableIO-Source":U) THEN
   DO:
     IF linkMissing("TableIO-Source":U) THEN
        cAdvice = advice("TableIO-Source":U,           
                        IF admVersion LT "ADM2":U 
                        THEN "SmartViewer":U
                        ELSE "SmartDataViewer":U,
                        "update, add or delete records",
                        "":U).
   END. /* IF needs a TableIO TARGET */
    
    /* Test for a Filter target? */
   IF cAdvice eq "":U AND CAN-DO (cSuppLinks, "Filter-Source":U) 
   AND _U._SUBTYPE = "SmartFilter":U THEN
   DO:
     IF linkMissing("Filter-Source":U) THEN
        cAdvice = advice("Filter-Source":U,
                        "SmartDataObject":U,
                        "":U,
                        "applies selection criteria").
   END. /* IF needs a Filter TARGET */

    /* Test for a missing Page-Target? */
   IF cAdvice eq "":U AND CAN-DO (cSuppLinks,"Page-Source":U)THEN 
   DO:
     IF linkMissing("Page-Source":U) THEN
         cAdvice = advice("Page-Source":U,
                         "container", 
                         "":U,
                         "":U ).
   END. /* IF needs a PAGE TARGET */
   
   /* Test for a SmartDataField Data-source? */
   IF cAdvice eq "":U AND CAN-DO (cSuppLinks, "Data-Target":U)
   AND _U._SUBTYPE = "SmartDataField":U THEN
   DO:
     IF linkMissing("Data-Target":U) THEN
       cAdvice = advice("Data-Target":U,           
                        "SmartDataObject",
                        "":U,
                        "receives records":U).
   END. /* IF needs a Data SOURCE */
    
    /* Test for a missing record source?*/
   IF CAN-DO (cSuppLinks, "Record-Target":U) THEN 
   DO:
      
     lLinkMissing = linkMissing("Record-Target":U).
      /* There's no link, but does the object may not need one if it
         has no KEY-NAME or EXTERNAL-TABLES. */
     IF lLinkMissing THEN 
     DO:            
        {adeuib/admver.i _S._HANDLE admVersion}

       IF admVersion LT "ADM2":U THEN DO:
          RUN get-attribute IN _S._HANDLE ('Key-Name':U). 
          s_key-name = IF RETURN-VALUE eq ? THEN "":U ELSE RETURN-VALUE.
          RUN get-attribute IN _S._HANDLE ('External-Tables':U).
          s_ext-tables = IF RETURN-VALUE eq ? THEN "":U ELSE RETURN-VALUE.
       END. /* ADM1 */
       ELSE DO:
           cValue = dynamic-function("getKeyName":U IN _S._HANDLE) NO-ERROR. 
           s_key-name = IF ERROR-STATUS:ERROR OR cValue eq ? THEN "":U ELSE cValue.
           s_ext-tables = "":U.
       END. /* > ADM1 */

       IF s_key-name eq "":U AND s_ext-tables eq "":U THEN 
          lLinkMissing = no.
     END. /*if lLinkMissing */     
     IF lLinkMissing THEN
        cAdvice = _U._SUBTYPE + " ":U + _U._NAME + " needs a Record Source "
                 + (IF s_ext-tables eq "":U THEN "":U 
                    ELSE "for its external tables (i.e. " + 
                          REPLACE(s_ext-tables, ",":U, ", ":U) + ")":U +
                          (IF s_key-name eq "":U THEN ".":U ELSE " or ")) 
                 + (IF s_key-name eq "":U THEN "":U 
                    ELSE "to supply a key value for " + s_key-name + ".":U)
                 + CHR(10) + CHR(10)
                 + "However, no Record Source is defined.".
   END. /* if needs a record-source */
 END. /* FOR EACH _U...SmartObject... */
  
  /* Do we have any advice? */
 IF cAdvice ne "":U THEN 
 DO:  
    ASSIGN
      cChoice = "Continue"
      cMode   = IF pcMode = "RUN":U THEN "&Run" ELSE "&Save". 
    RUN adeuib/_advisor.w (
      /* Text */        INPUT cAdvice,
      /* Options */     INPUT "Continue. " 
                               + cMode
                               + " the file anyway.,Continue," +
                              "&Cancel. Return to the {&UIB_NAME}.,Cancel",                              
      /* Toggle Box */  INPUT TRUE,
      /* Help Tool  */  INPUT "ab",
      /* Context    */  INPUT {&Advisor_Invalid_Link},
      /* Choice     */  INPUT-OUTPUT cChoice,
      /* Never Again */ OUTPUT lNA )  .
    
    IF pcMode = "RUN":U THEN
      {&NA-OK-Links-run-advsrun}  = lNA.
    ELSE
      {&NA-OK-Links-save-advsrun} = lNA.
    
    IF cChoice eq "Cancel":U THEN plOk2run = FALSE.
  END. /* IF cAdvice */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-advice) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION advice Procedure 
FUNCTION advice RETURNS CHARACTER
  (pcLink       AS CHARACTER,
   pcSubscriber AS CHARACTER,
   pcTask       AS CHARACTER,
   pcMessage    AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose: create an advice that says
Parameters:  pcLink        - linkname  
             pcSubscriber  - object type that should be in the other end of the link.          
             pcTask        
                - blank: Use link type BEFORE commands. 
                    It normally sends <linktype> commands to a <pcSubscriber>.
                - optional info to describe the link task.
                    It normally sends commands to a <pcSubscriber> to <pcTask>.
             pcMessage 
                  - Replace "sends commands"   
   Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cAdvice        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cLinkType      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cThisEnd       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cReceiveEnd    AS CHARACTER NO-UNDO.
  
  ASSIGN 
    cLinkType    = ENTRY(1,pcLink,"-":U)
    cThisEnd     = ENTRY(2,pcLink,"-":U)
    cReceiveEnd  = (IF cThisEnd = "Target":U 
                    THEN "Source" 
                    ELSE "Target").

  IF pcMessage = "":U OR pcMessage = ? THEN
     pcMessage = (IF cThisEnd = "Source":U 
                  THEN "sends" 
                  ELSE "receives")
                  /* put in filter type if no task description */
                  + (IF pcTask = "":U 
                     THEN " ":U + LC(cLinkType) + " ":U 
                     ELSE " ":U)
                  + "commands".

  cAdvice =  _U._SUBTYPE + " ":U + _U._NAME + " is a "
             + REPLACE(pcLink,"-"," ") + "."  /* Linkname without dash */
             + " It normally " 
             + pcMessage + " ":U
             + (IF cThisEnd = "Source":U 
                THEN "to" 
                ELSE "from")+ " a " 
             + pcSubscriber  
             + (IF pcTask = "":U THEN "":U ELSE " to " + pcTask)
             + ".":U
             + CHR(10) + CHR(10) 
             + "However, no "
             + pcSubscriber
             + " is defined as its "
             + cReceiveEnd
             + ".":U.
  RETURN cAdvice. 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-linkMissing) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION linkMissing Procedure 
FUNCTION linkMissing RETURNS LOGICAL
  (pcLink AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Check whether a particular link is missing 
    Notes:  _U record MUST be available.
            _P must b available
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lLinkMissing   AS LOGICAL NO-UNDO.
  DEFINE VARIABLE cLinkType      AS CHAR    NO-UNDO.
  DEFINE VARIABLE cLinkSearch AS CHAR    NO-UNDO.
   
  ASSIGN
    lLinkMissing = TRUE  
    cLinkType    = ENTRY(1,pcLink,"-":U)
    cLinkSearch  = ENTRY(2,pcLink,"-":U).

  IF cLinkSearch = "SOURCE":U THEN
  DO:
    LINKSEARCH:
    FOR EACH _admlinks WHERE _admlinks._link-source eq STRING(RECID(_U))
                       AND   _admlinks._link-type   eq cLinkType:
       /* Link can be to another _U or to this procedure. */
      FIND x_U WHERE RECID(x_U) eq INTEGER(_admlinks._link-dest)
                     AND x_U._STATUS eq "NORMAL":U NO-ERROR.
      IF AVAILABLE x_U OR _admlinks._link-dest eq STRING(RECID(_P)) THEN 
      DO:
        /* Found something: stop looking */
        lLinkMissing = NO. 
        LEAVE LINKSEARCH.
      END.
    END. /* LINKSEARCH: FOR EACH link... */  
  END. /* linksearch = SOURCE */
  ELSE DO:
    LINKSEARCH:
    FOR EACH _admlinks WHERE _admlinks._link-dest eq STRING(RECID(_U))
                       AND   _admlinks._link-type eq cLinkType:
      /* Link can be to another _U or to this procedure. */
      FIND x_U WHERE RECID(x_U) eq INTEGER(_admlinks._link-source)
                     AND x_U._STATUS eq "NORMAL":U NO-ERROR.
      IF AVAILABLE x_U OR _admlinks._link-source eq STRING(RECID(_P)) THEN 
      DO:
        /* Found something: stop looking */
        lLinkMissing = NO. 
        LEAVE LINKSEARCH.
      END.
    END. /* LINKSEARCH: FOR EACH link... */     
  END.  /* linksearch = TARGET */

  RETURN lLinkMissing. 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

