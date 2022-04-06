&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI
/* Procedure Description
"External table Wizard"
*/
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------
  File: _wizetbl.w

  Description: Add External tables to Report or Detail HTML objects
  Input Parameters:
      hWizard (handle) - handle of Wizard dialog

  Output Parameters:
      <none>

  Author  : Haavard Danielsen
  Created : Aug 98 
  Modified: Mars 22. 99,  Haavard Danielsen
            Added ForeignField support  
  Modified: July 22. 00,  Haavard Danielsen
            Use ExternalDispName for the external objects/tables  
            (Ther .dat still uses ExternalTables)
                       
  Note:     The external table definitions are stored in a temp-table tExternal
            
            We may define both External Tables and External Objects.  
            
            If this object uses a Query the external table join may be defined 
            in the QueryBuilder.
             
            In that case the External Tables are joined to the query by passing 
            rowids and adding the external tables as buffers to the dynamic query
            ROWID(table) =  is added to the where clause, and join and where 
            are added to the original tables where clause (The rather complicated
            use of having the criteria separated in a join and a where is because
            the QueryBuilder uses that....) 
           
            External Tables may also use Foreign Fields.
            
            External Objects always uses Foreign Fields.
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* NEVER NEVER Create an unnamed pool to store all the widgets created 
     by this procedure. This only assures that everything dynamic 
     that is created in this procedure will die as soon as this proecure dies */
     
/* ***************************  Definitions  ************************** */
{ src/adm2/support/admhlp.i } /* ADM Help File Defs */

/* CHR(3) creates a mess in HTML */ 
&SCOP WSdlm  "|"
&SCOP ABdlm CHR(3)

/* Parameters Definitions ---                                           */
DEFINE INPUT        PARAMETER hWizard   AS WIDGET-HANDLE NO-UNDO.

/* Temp table Definitions ---                                       */
DEFINE TEMP-TABLE tExternal 
 FIELD Ident         AS CHAR
 FIELD RunName       AS CHAR  
 FIELD NoJoin        AS LOG 
 FIELD Type          AS CHAR INIT "T" /* T Table, O object */  
 FIELD JoinCode      AS CHAR 
 FIELD WhereCode     AS CHAR 
 FIELD QueryCode     AS CHAR 
 FIELD ForeignFields AS CHAR 
 INDEX Tables AS UNIQUE  Ident.

DEFINE VARIABLE ghHTML     AS HANDLE    NO-UNDO.
    
/* Local Variable Definitions ---                                       */
DEFINE VARIABLE gcObjtype     AS CHARACTER NO-UNDO.
DEFINE VARIABLE gcQueryRecStr AS CHARACTER NO-UNDO.
DEFINE VARIABLE gcProcRecStr  AS CHARACTER NO-UNDO.
DEFINE Variable ghWizard   AS HANDLE    NO-UNDO.
DEFINE Variable ghFuncLib  AS HANDLE    NO-UNDO.
       
DEFINE Variable gcInitSDO    AS CHARACTER NO-UNDO.
DEFINE Variable gcInitTables AS CHARACTER NO-UNDO.

DEFINE Variable glWeb        AS LOGICAL   NO-UNDO.
 
/* Constants */
DEFINE VARIABLE xHTMLproc        AS CHAR NO-UNDO INIT "adeweb/_genwpg.p":U.
DEFINE VARIABLE xSmartDataObject AS CHAR NO-UNDO INIT "SmartDataObject":U.

FUNCTION getField RETURNS CHARACTER
  (pField AS CHAR) IN ghHTML. /*  xHTMLproc */ 

FUNCTION setField RETURNS LOGICAL
  ( pField AS CHAR,
    pValue AS CHAR) IN ghHTML. /*  xHTMLproc */ 

FUNCTION db-tbl-name RETURNS CHARACTER
  ( db-tbl AS CHARACTER ) IN ghFuncLib.

FUNCTION is-sdo RETURNS LOGICAL
        (INPUT h_do AS HANDLE) IN ghFuncLib.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE WINDOW
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS e_msg seExternal eJoin btnHelp fiExtLabel ~
rectDataSrc 
&Scoped-Define DISPLAYED-OBJECTS e_msg seExternal fiExtLabel 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD anyOtherTable C-Win 
FUNCTION anyOtherTable RETURNS LOGICAL
   (pcTables   AS CHAR,
    pcDbTables AS CHAR) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createExternal C-Win 
FUNCTION createExternal RETURNS LOGICAL
  (pcIdent    AS CHAR,
   pcRunName  AS CHAR,
   pcJoin     AS CHAR,
   pcWhere    AS CHAR,
   pcType     AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD DispExternal C-Win 
FUNCTION DispExternal RETURNS CHARACTER
  (pcIdent   AS CHAR,
   pcRunName AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD dispJoin C-Win 
FUNCTION dispJoin RETURNS LOGICAL
  ()  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD findExternalOfList C-Win 
FUNCTION findExternalOfList RETURNS LOGICAL
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD IdentFromDispName C-Win 
FUNCTION IdentFromDispName RETURNS CHARACTER
  (pcDispName AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD RunNameFromDispName C-Win 
FUNCTION RunNameFromDispName RETURNS CHARACTER
  (pcDispName AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD sameTables C-Win 
FUNCTION sameTables RETURNS LOGICAL
  (pTables   AS CHAR,
   pDbTables AS CHAR) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setButtons C-Win 
FUNCTION setButtons RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btnForeign 
     LABEL "&Foreign Fields" 
     SIZE 16 BY 1.14.

DEFINE BUTTON btnHelp 
     LABEL "&Help on External Tables" 
     SIZE 26 BY 1.14.

DEFINE BUTTON btnJoin 
     LABEL "Edit &Join" 
     SIZE 9 BY 1.14.

DEFINE BUTTON btnRemove 
     LABEL "&Remove" 
     SIZE 26 BY 1.14.

DEFINE BUTTON btnSDO 
     LABEL "Add External &Object..." 
     SIZE 26 BY 1.14.

DEFINE BUTTON btnTables 
     LABEL "Add External &Table..." 
     SIZE 26 BY 1.14.

DEFINE VARIABLE eJoin AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 52 BY 3.33 NO-UNDO.

DEFINE VARIABLE e_msg AS CHARACTER 
     VIEW-AS EDITOR
     SIZE 26 BY 3.52
     BGCOLOR 8  NO-UNDO.

DEFINE VARIABLE fiExtLabel AS CHARACTER FORMAT "X(256)":U INITIAL "External Tables and Objects (Optional)" 
      VIEW-AS TEXT 
     SIZE 26 BY .62 NO-UNDO.

DEFINE RECTANGLE rectDataSrc
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 54 BY 10.67.

DEFINE VARIABLE seExternal AS CHARACTER 
     VIEW-AS SELECTION-LIST SINGLE SCROLLBAR-VERTICAL 
     SIZE 52 BY 5.95 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     e_msg AT ROW 1.52 COL 57 NO-LABEL
     seExternal AT ROW 2.19 COL 3 NO-LABEL
     btnTables AT ROW 5.29 COL 57
     btnSDO AT ROW 6.71 COL 57
     btnRemove AT ROW 8.14 COL 57
     eJoin AT ROW 8.62 COL 3 NO-LABEL
     btnForeign AT ROW 9.57 COL 57
     btnJoin AT ROW 9.57 COL 74
     btnHelp AT ROW 11.05 COL 57
     fiExtLabel AT ROW 1.24 COL 1 COLON-ALIGNED NO-LABEL
     rectDataSrc AT ROW 1.52 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: WINDOW
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* SUPPRESS Window definition (used by the UIB) 
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "<insert title>"
         HEIGHT             = 11.43
         WIDTH              = 83.8
         MAX-HEIGHT         = 37.57
         MAX-WIDTH          = 182.8
         VIRTUAL-HEIGHT     = 37.57
         VIRTUAL-WIDTH      = 182.8
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
                                                                        */
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME
ASSIGN C-Win = CURRENT-WINDOW.




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME DEFAULT-FRAME
   Size-to-Fit                                                          */
ASSIGN 
       FRAME DEFAULT-FRAME:SCROLLABLE       = FALSE.

/* SETTINGS FOR BUTTON btnForeign IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON btnJoin IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON btnRemove IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON btnSDO IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON btnTables IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR EDITOR eJoin IN FRAME DEFAULT-FRAME
   NO-DISPLAY                                                           */
ASSIGN 
       eJoin:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

ASSIGN 
       e_msg:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* <insert title> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* <insert title> */
DO:
  /* These events will close the window and terminate the procedure.      */
  /* (NOTE: this will override any user-defined triggers previously       */
  /*  defined on the window.)                                             */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnForeign
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnForeign C-Win
ON CHOOSE OF btnForeign IN FRAME DEFAULT-FRAME /* Foreign Fields */
DO:
  RUN ForeignFields.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnHelp C-Win
ON CHOOSE OF btnHelp IN FRAME DEFAULT-FRAME /* Help on External Tables */
DO:
  RUN adecomm/_adehelp.p ("AB":U, "CONTEXT":U, {&Help_on_External_tables}, ?).  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnJoin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnJoin C-Win
ON CHOOSE OF btnJoin IN FRAME DEFAULT-FRAME /* Edit Join */
DO:
  RUN EditJoin.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnRemove
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnRemove C-Win
ON CHOOSE OF btnRemove IN FRAME DEFAULT-FRAME /* Remove */
DO:
  DEF VAR icurrent AS int NO-UNDO.
  
  DO WITH FRAME {&FRAME-NAME}:
    FIND tExternal WHERE tExternal.Ident = seExternal:SCREEN-VALUE NO-ERROR.    
    IF AVAIL tExternal THEN
      DELETE tExternal.
    iCurrent = seExternal:LOOKUP(seExternal:SCREEN-VALUE).
    seExternal:DELETE(seExternal:SCREEN-VALUE).
    
    seExternal:SCREEN-VALUE = seExternal:ENTRY(MIN(iCurrent,seExternal:NUM-ITEMS)).
    findExternalOfList().
    DispJoin().
    SetButtons().
  END. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnSDO
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnSDO C-Win
ON CHOOSE OF btnSDO IN FRAME DEFAULT-FRAME /* Add External Object... */
DO:
  DEFINE VARIABLE cDataObject AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cObjectName AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hSDO        AS HANDLE     NO-UNDO.

  RUN adecomm/_chossdo.p ("PREVIEW,BROWSE":U, 
                           glWeb, /*  remote */
                           INPUT-OUTPUT cDataObject).
  
  IF cDataObject <> "":U THEN 
  DO:
    RUN getSDOHandle IN ghWizard (cDataObject, OUTPUT hSDO).
    IF VALID-HANDLE(hSDO) THEN
    DO:    
      cObjectName = DYNAMIC-FUNCTION('getObjectName' IN hSDO).
      createExternal(cObjectName,cDataObject,"":U,"":U,"O":U).    
      RUN ForeignFields. 
    END.
  END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnTables
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnTables C-Win
ON CHOOSE OF btnTables IN FRAME DEFAULT-FRAME /* Add External Table... */
DO:
  
  DEF VAR cDb          AS CHAR NO-UNDO. 
  DEF VAR cExtTables   AS CHAR NO-UNDO.   
  DEF VAR cQueryTables AS CHAR NO-UNDO.   
  DEF VAR cDbTable     AS CHAR NO-UNDO.   
  DEF VAR lAnyOther    AS LOG  NO-UNDO.   
  DEF VAR lOk          AS LOG  NO-UNDO.
  DEF VAR lNoJoin      AS LOG  NO-UNDO.
  DEF VAR cIsAre       AS CHAR NO-UNDO.
  DEF VAR i            AS INT  NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}: 

    RUN adecomm/_tblsel.p
       (TRUE /* Multi */, 
        ?, 
        INPUT-OUTPUT cDb, 
        INPUT-OUTPUT cExtTables,
        OUTPUT lOk).
          
    IF lok AND seExternal:LOOKUP(cExtTables) = 0 THEN 
    DO:           
       
      IF gcInitTables <> "" THEN 
      DO:
        lanyOther = anyOtherTable(cExtTables,gcinitTables).
        
        /* Add db to external tables if qualify with dbname is true */    
        DO i = 1 to NUM-ENTRIES(cExtTables):  
          /* Add db for comparison with gcInitTables */    
          ASSIGN 
            cDbTable     = cDb + ".":U + ENTRY(i,cExtTables)  
            ENTRY(i,cExtTables) = db-tbl-name(cDbTable).
        END.
        
        /* If all the external tables are in the query we give the user a 
           question if he want to keep the definition */
        IF NOT lAnyOther THEN
        DO:         
            cIsAre = IF NUM-ENTRIES(cExtTables) > 1 THEN "are" ELSe "is". 
            MESSAGE 
             REPLACE(cExtTables,",":U," and ":U) cIsAre 
 "defined in the query and will be joined automatically when passed as external." 
             SKIP(1)
 "Do you want to continue and define Foreign Fields?" 
             VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
             UPDATE lNoJoin.  
             IF NOT lNoJoin THEN RETURN.         
        END. /* if not lAnyOther */
          
      END. /* gcInitTables <> '' */
      
      /* createExternal runs _joinext.p if type = 't' so we set it to blank
         temporarily in order to avoid this */  
       
      createExternal(cExtTables,"":U,"":U,"":U, 
                     IF NOT lNoJoin THEN "T":U ELSE "":U).                 
      
      IF lNoJoin THEN 
        ASSIGN
          tExternal.type    = "T":U
          tExternal.NoJoin = TRUE.
      
      IF gcInitSdo <> "" OR lNoJoin THEN
        RUN ForeignFields.
            
      seExternal:SCREEN-VALUE = cExtTables.     
      DispJoin().
      SetButtons().           
    END. /*lok AND seExternal:LOOKUP(cExtTables) = 0 */
  END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME seExternal
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL seExternal C-Win
ON MOUSE-SELECT-DBLCLICK OF seExternal IN FRAME DEFAULT-FRAME
DO:
  RUN EditJoin.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL seExternal C-Win
ON VALUE-CHANGED OF seExternal IN FRAME DEFAULT-FRAME
DO:
  findExternalOfList().
  DispJoin().  
  SetButtons().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */
ASSIGN ghWizard  = SOURCE-PROCEDURE   
       FRAME {&FRAME-NAME}:FRAME    = hwizard
       FRAME {&FRAME-NAME}:HEIGHT-P = FRAME {&FRAME-NAME}:VIRTUAL-HEIGHT-P
       FRAME {&FRAME-NAME}:WIDTH-P  = FRAME {&FRAME-NAME}:VIRTUAL-WIDTH-P
       fiExtLabel:WIDTH IN FRAME {&FRAME-NAME} = 
           FONT-TABLE:GET-TEXT-WIDTH-CHARS(fiExtLabel,FRAME {&FRAME-NAME}:FONT)
       ghHTML    = DYNAMIC-FUNCTION("getSupportHandle":U in ghWizard,xHTMLProc) 
       ghFuncLib = DYNAMIC-FUNCTION("getFuncLibHandle":U in ghWizard). 

/* Get context id of procedure */
RUN adeuib/_uibinfo.p (?, "PROCEDURE ?":U, "PROCEDURE":U, OUTPUT gcProcRecStr).
  
/* Get procedure type  */
RUN adeuib/_uibinfo.p (?, "PROCEDURE ?":U, "TYPE":U, OUTPUT gcObjType).

ASSIGN glWeb = gcObjType BEGINS "WEB":U. 

/* Get the DataObject */
RUN adeuib/_uibinfo.p (INT(gcProcRecStr), "PROCEDURE ?":U, 
    "DataObject":U, OUTPUT gcInitSDO).

IF gcInitSDO = "":U THEN
DO:
 /* Get the Browser _U recid */
 RUN adeuib/_uibinfo.p (INT(gcProcRecStr), "PROCEDURE ?":U, 
    "CONTAINS BROWSE RETURN CONTEXT":U, OUTPUT gcQueryRecStr).

 /* If no browser get the Query _U recid */
 IF gcQueryRecStr = "":U THEN 
   RUN adeuib/_uibinfo.p (INT(gcProcRecStr), "PROCEDURE ?":U, 
      "CONTAINS QUERY RETURN CONTEXT":U, OUTPUT gcQueryRecStr).
      
 IF gcQueryRecStr <> "":U THEN 
   RUN adeuib/_uibinfo.p(INT(gcQueryRecStr), ?, "TABLES":U, OUTPUT gcInitTables). 
 
 e_msg = 
   "Map fields or join to an external source.".
        
END.
ELSE
 e_msg = 
   "Map to fields of an external source.".
e_msg = e_msg    
     + "  Define a general link as External Tables and a specific link"
     + "  as an External Object.".
         
ASSIGN
  seExternal:DELIMITER  IN FRAME {&FRAME-NAME} = CHR(3) 
  FRAME {&FRAME-NAME}:HIDDEN   = NO    
  /* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
  CURRENT-WINDOW                = {&WINDOW-NAME} 
  THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE DO:
  IF DYNAMIC-FUNCTION('getLastButton':U in ghWizard) <> "CANCEL":U THEN
     RUN ProcessPage NO-ERROR.
  IF ERROR-STATUS:ERROR THEN 
  DO:
    RETURN NO-APPLY.
  END.

  RUN disable_UI.
END.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.
  RUN DisplayPage.
  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI C-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME DEFAULT-FRAME.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DisplayPage C-Win 
PROCEDURE DisplayPage :
/*------------------------------------------------------------------------------
  Purpose:     Display list of external tables.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE qSyntax        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE DataObject     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cTables        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cExtTypeList   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cExternal      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cSDO           AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cJoinList      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cWhereList     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cForeignList   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cJoin          AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cWhere         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cForeign       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE i              AS INTEGER   NO-UNDO.     
  DEFINE VARIABLE lNoJoin        AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cType          AS CHARACTER NO-UNDO.
  
  setField('Procid',gcProcRecStr).  
  
  ASSIGN
    cTables    = getField('Tables':U)    
    cSDO       = getField('DataObject':U).
  
  /* This check is not really necessary because _datasrc.w deletes data if
     the datasource is changed */ 
       
  IF  (gcInitTables = "":U OR sameTables(cTables,gcInitTables))
  AND (gcInitSdo    = "":U OR gcInitSdo = cSDO) THEN  
  DO:
     ASSIGN
        seExternal   = REPLACE(getField('ExternalDispNames'),{&WSdlm},{&ABdlm})
        cJoinList    = REPLACE(getField('ExternalJoin'),{&WSdlm},{&ABdlm})
        cWhereList   = REPLACE(getField('ExternalWhere'),{&WSdlm},{&ABdlm})
        cForeignList = REPLACE(getField('ForeignFields'),{&WSdlm},{&ABdlm}).
        cExtTypeList = REPLACE(getField('ExternalTypes'),{&WSdlm},{&ABdlm}).
      
      IF seExternal <> "":U THEN
      DO WITH FRAME {&FRAME-NAME}:
        
        DO i = 1 TO NUM-ENTRIES(seExternal,{&ABdlm}):
          ASSIGN 
            cExternal    = ENTRY(i,seExternal,{&ABdlm})
            cType        = ENTRY(i,cExtTypeList,{&ABdlm})   
            cJoin        = (IF cJoinList = "":U 
                            THEN "":U 
                            ELSE ENTRY(i,cJoinList,{&ABdlm}))
            cWhere       = (IF cWhereList = "":U 
                            THEN "":U 
                            ELSE ENTRY(i,cWhereList,{&ABdlm}))
            /* If the external are "T" (table), but the tables are the 
               same as in the query we do not allow rowid join 
               (because it will be automatic) */
            lNoJoin      =  cType = "T"
                            AND NOT anyOtherTable(cExternal,gcInitTables).
            cForeign     =  IF cForeignList <> "":U    
                            THEN ENTRY(i,cForeignList,{&ABdlm}) 
                            ELSE "":U.
            
            createExternal(IdentFromDispName(cExternal),
                           RunNameFromDispName(cExternal),
                           cJoin,
                           cWhere,                         
                          /* 
                          if Foreignfields or no joion avoid call to _joinext
                          */
                         (IF cForeign <> "":U
                          OR lNoJoin  
                          THEN "":U 
                          ELSE cType)).
          
          ASSIGN
            tExternal.NoJoin        = lNoJoin
            tExternal.Type          = cType 
            tExternal.ForeignFields = cForeign.
                              
        END. /* do i = 1 to num-entries(cexternal) */
        
        ASSIGN
          seExternal:LIST-ITEMS   = seExternal 
          seExternal:SCREEN-VALUE = seExternal:ENTRY(1).
        
        findExternalOfList().
        dispJoin().  
         
      END. /* if seexternal <> '' */
  END. /* else do  ctables = ginitables or cSdo = ginitSdo */
  setButtons().
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE EditJoin C-Win 
PROCEDURE EditJoin :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:      tExternal is always available
              - value-changed of seExternal
              - Trigger btnTables -> createExternal      
------------------------------------------------------------------------------*/  
  RUN adeweb/_joinext.p
                (tExternal.Ident,
                 "Edit":U,
                 INPUT-OUTPUT tExternal.JoinCode,
                 INPUT-OUTPUT tExternal.Wherecode,
                 INPUT-OUTPUT tExternal.QueryCode).  
  
  IF tExternal.QueryCode <> "":U THEN
    tExternal.ForeignFields = "":U.                              
  
  dispJoin().

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI C-Win  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  DISPLAY e_msg seExternal fiExtLabel 
      WITH FRAME DEFAULT-FRAME.
  ENABLE e_msg seExternal eJoin btnHelp fiExtLabel rectDataSrc 
      WITH FRAME DEFAULT-FRAME.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ForeignFields C-Win 
PROCEDURE ForeignFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:    tExternal is always available
            - value-changed of seExternal
            - Trigger btnTables   -> createExternal  
            - Trigger btnForeign  -> createExternal  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cForeignFields AS CHAR   NO-UNDO.
  DEFINE VARIABLE hSource        AS HANDLE NO-UNDO.
  DEFINE VARIABLE hTarget        AS HANDLE NO-UNDO.
    
  /* If external is table create dummy Source object */
  IF tExternal.type = "T" THEN 
  DO: 
    RUN adecomm/_dynbuf.w PERSISTENT SET hSource.   
    DYNAMIC-FUNCTION('setBuffers':U IN hSource,tExternal.Ident).   
  END. /* tExternal.Type = "T" */
  
  /* If internal object is query table create dummy Target object */
  IF gcInitTables <> "" THEN
  DO:
    RUN adecomm/_dynbuf.w PERSISTENT SET hTarget.   
    DYNAMIC-FUNCTION('setBuffers':U IN hTarget,gcInitTables).       
  END. /* gcIniTables = '' */
  
  IF NOT VALID-HANDLE(hTarget) THEN 
    RUN startSDO(gcInitSDo, OUTPUT hTarget).
      
  IF NOT VALID-HANDLE(hSource) THEN
    RUN startSDO(tExternal.RunName, OUTPUT hSource).
  
  IF VALID-HANDLE(hTarget) AND VALID-HANDLE(hSource) THEN
  DO:
    cForeignfields = tExternal.Foreignfields.    
    RUN adecomm/_mfldmap.p 
               (INPUT IF gcInitSDO <> "":U 
                      THEN gcInitSdo 
                      ELSE "":U ,
                INPUT tExternal.Ident,
                INPUT hTarget,
                INPUT hSource,
                INPUT ?,
                INPUT "2":U,
                INPUT ",":U,
                INPUT-OUTPUT cForeignFields).           
    
    tExternal.Foreignfields = cForeignfields.
    
    IF tExternal.ForeignFields <> "":U THEN 
      ASSIGN 
        tExternal.QueryCode = "":U 
        tExternal.JoinCode  = "":U 
        tExternal.WhereCode = "":U. 
                
  END. /* both are valid handles */
  
  IF gcInitTables <> "" THEN 
    RUN destroyObject IN hTarget.    
      
  IF tExternal.type = "T":U THEN 
    RUN destroyObject IN hSource.

  dispJoin().
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ProcessPage C-Win 
PROCEDURE ProcessPage :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE BUFFER btExternal FOR tExternal.
   
   DEFINE VARIABLE cExternal    AS CHAR NO-UNDO.
   DEFINE VARIABLE cExtTypes    AS CHAR NO-UNDO.
   DEFINE VARIABLE cJoinList    AS CHAR NO-UNDO.
   DEFINE VARIABLE cWhereList   AS CHAR NO-UNDO.
   DEFINE VARIABLE cForeignList AS CHAR NO-UNDO.
   DEFINE VARIABLE cDelimit     AS CHAR NO-UNDO.
   
   /* Store the Querytables and SDO to be able to check changes if
      we reenter this program */          
   
   setField('Tables',gcInitTables).    
   setField('DataObject',gcInitSDO).        
       
   
   FOR EACH BtExternal  WITH FRAME {&FRAME-NAME}:
     
     IF DYNAMIC-FUNCTION("getLastButton" in ghWizard) = "NEXT":U THEN
     DO:
       IF  BtExternal.joincode      = "":U 
       AND BtExternal.WhereCode     = "":U
       AND BtExternal.ForeignFields = "":U THEN
       DO:
         ASSIGN seExternal:SCREEN-VALUE = DispExternal(btExternal.ident,
                                                       btExternal.RunName).

         findExternalOfList().         

         dispJoin().         
                  
         MESSAGE 
          "Foreign Fields" 
          (IF gcInitTables <> "" AND NOT btExternal.NoJoin
           THEN "or Join "
           ELSE "":U) +
          "must be defined for"  
          "the External" 
          (IF btExternal.Type = "T":U 
           THEN IF NUM-ENTRIES(gcInitTables) > 1 
                THEN "Tables" 
                ELSE "Table"
           ELSE "Object")
           REPLACE(btExternal.Ident,",":U," and ":U)  
 
         VIEW-AS ALERT-BOX WARNING.      
         RETURN ERROR.         
       END.     
     END.
           
     ASSIGN 
       cExternal    = cExternal    + cDelimit + DispExternal(btExternal.ident,
                                                             btExternal.RunName)
       cExtTypes    = cExtTypes    + cDelimit + btExternal.Type
       cJoinList    = cJoinList    + cDelimit + btExternal.JoinCode  
       cForeignList = cForeignList + cDelimit + btExternal.ForeignFields  
       cWhereList   = cWhereList   + cDelimit + btExternal.WhereCode
       cDelimit     = {&WSdlm}.             
     
  END. /* for each tExternal  */      
  setField('ExternalDispNames':U,cExternal).
  setField('ExternalTypes':U ,cExtTypes). 
  setField('ForeignFields':U,cForeignList). 
  
  /* Join and where are only used for queries */       
  IF gcInitTables <> "":U THEN
  DO:
     setField('ExternalJoin':U,cJoinList).
     setField('ExternalWhere':U,cWhereList).
  END.
     
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE startSDO C-Win 
PROCEDURE startSDO :
/*------------------------------------------------------------------------------
  Purpose: Start an SDO, used to start the DataSource for this object and 
           selected external objects in order to map foreign fields
    Notes: This cannot be a function, because of the potential use of the http 
           ocx control that has a wait-for.   
------------------------------------------------------------------------------*/
 DEFINE INPUT PARAMETER pcSDO   AS CHARACTER NO-UNDO.
 DEFINE OUTPUT PARAMETEr phSDO  AS HANDLE NO-UNDO.
 
 DEFINE VARIABLE cRemote AS CHAR   NO-UNDO.
 DEFINE VARIABLE cMsg    AS CHAR   NO-UNDO.

   /* Get the handle of the data object */
 IF pcSdo ne "" and pcSDO ne ? THEN
 DO:
   RUN getSDOHandle IN ghWizard (pcSDO, OUTPUT phSDO).
   
   /* Ensure the chosen file is a SmartData object.*/  
   IF NOT VALID-HANDLE(phSdo) THEN
     cMsg = "Handle to object is invalid. The file may not be compiling correctly.".
   ELSE IF NOT is-sdo(phSdo) THEN
     cMsg = "The file is not a SmartDataObject.".
   
   IF cMsg <> "" THEN
   DO ON STOP UNDO, LEAVE:
     cMsg = pcSDO + CHR(10) + CHR(10) + cMsg.
     MESSAGE cMsg VIEW-AS ALERT-BOX WARNING BUTTONS OK.
   END.    
 END.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION anyOtherTable C-Win 
FUNCTION anyOtherTable RETURNS LOGICAL
   (pcTables   AS CHAR,
    pcDbTables AS CHAR): 
/*-----------------------------------------------------------------------------
  Purpose: Compare a two comma separated lists of tables where one of them 
           always have database reference and the other may not
  Parameters:
    ptables   - With or without db. 
    pdbtables - Always with db.      
    Notes:     RETURN TRUE if ANY of the tables in the FIRST list is NOT found 
               in the LAST.
------------------------------------------------------------------------------*/
  DEF VAR i        AS INTEGER NO-UNDO.
  DEF VAR j        AS INTEGER NO-UNDO.
  DEF VAR cDbTable AS CHAR    NO-UNDO.
  DEF VAR cEntry   AS CHAR    NO-UNDO.  
  DEF VAR cTable   AS CHAR    NO-UNDO.
  DEF VAR cDb      AS CHAR    NO-UNDO.
  DEF VAR lUseDb   AS LOG     NO-UNDO.
  
  FirstLoop:  
  DO i = 1 TO NUM-ENTRIES(pcTables):    
    ASSIGN
      cEntry = ENTRY(i,pcTables) 
      lUseDb = INDEX(cEntry,".":U) > 0.    
    /* If we have db in the FIRST list we just do a lookup */
    IF lUseDb THEN
    DO: 
      IF LOOKUP(cEntry,pcDbTables) = 0 THEN 
        RETURN TRUE.
    END. /* lUseDb */
    ELSE
    InnerLoop: 
    DO j = 1 TO NUM-ENTRIES(pcDbTables):  
      ASSIGN  
        cDbTable = ENTRY(j,pcDbTables) 
        cDb      = ENTRY(1,cDbTable,".":U)
        cTable   = ENTRY(2,cDbTable,".":U).
        
      IF cEntry = cTable THEN 
        NEXT Firstloop. 
      
    END. /* do j = 1 to num-entries(pDbTables) */
    
    RETURN TRUE.
     
  END. /* do i = 1 to num-entries(pTables) */  
  RETURN FALSE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createExternal C-Win 
FUNCTION createExternal RETURNS LOGICAL
  (pcIdent    AS CHAR,
   pcRunName  AS CHAR,
   pcJoin     AS CHAR,
   pcWhere    AS CHAR,
   pcType     AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Add a table to the temptable and selection list 
    Notes:  
------------------------------------------------------------------------------*/
  CREATE tExternal.
  ASSIGN tExternal.Ident   = pcIdent
         tExternal.Type    = pcType 
         tExternal.RunName = pcRunName.

  /* If this is a Query object and the external is a table we create a 
     default join */ 
     
  IF  gcInitTables      <> "":U 
  AND tExternal.Type    = "T":U THEN
  DO:
    RUN adeweb/_joinext.p(tExternal.Ident,
                         "Check":U,
                         INPUT-OUTPUT pcJoin,
                         INPUT-OUTPUT pcWhere,
                         INPUT-OUTPUT tExternal.QueryCode). 
  
    ASSIGN 
      tExternal.JoinCode  = pcJoin
      tExternal.WhereCode = pcWhere.                      
  
  END. /* gcInitTables <> '' */    
  seExternal:ADD-LAST(DispExternal(pcIdent,pcRunName)) IN FRAME {&FRAME-NAME}.                                
  
  RETURN TRUE.   
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION DispExternal C-Win 
FUNCTION DispExternal RETURNS CHARACTER
  (pcIdent   AS CHAR,
   pcRunName AS CHAR) :
/*------------------------------------------------------------------------------
   Purpose: Returns the External object/table as used in the selection list 
            and the property 
Parameters: pcIdent    - Table or objectName 
            pcrunName  - SDO name or blank  if table         
     Notes:  
------------------------------------------------------------------------------*/
  RETURN IF   pcRunName = "":U 
         THEN pcIdent
         ELSE pcRunName + " (":U + pcIdent + ")":U.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION dispJoin C-Win 
FUNCTION dispJoin RETURNS LOGICAL
  () :
/*------------------------------------------------------------------------------
  Purpose: Show the current query in the editor. 
    Notes:  
------------------------------------------------------------------------------*/

  ASSIGN eJoin:SCREEN-VALUE IN FRAME {&FRAME-NAME}  = 
               IF AVAIL tExternal 
               THEN (IF tExternal.QueryCode <> "":U
                     THEN tExternal.QueryCode
                     ELSE tExternal.ForeignFields)
               ELSE "":U.

  RETURN TRUE.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION findExternalOfList C-Win 
FUNCTION findExternalOfList RETURNS LOGICAL
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Called everywhere screen-value changes to find the correct record   
    Notes:  
------------------------------------------------------------------------------*/
  FIND tExternal 
    WHERE tExternal.Ident = 
        IdentFromDispName(seExternal:SCREEN-VALUE IN FRAME {&FRAME-NAME})
  NO-ERROR.
  
  RETURN AVAIL tExternal.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION IdentFromDispName C-Win 
FUNCTION IdentFromDispName RETURNS CHARACTER
  (pcDispName AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Returns the ObjectName or Table used as ident in the tExternal. 
Parameter: pcDispName - 'RunName (ObjectName)' for an object  
                         as used in selectionlist or property                           
    Notes:  
------------------------------------------------------------------------------*/
  RETURN IF INDEX(pcDispName,"(":U) > 0 
         THEN  RIGHT-TRIM(ENTRY(2,pcDispName,"(":U),")":U)
         ELSE  pcDispName. 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION RunNameFromDispName C-Win 
FUNCTION RunNameFromDispName RETURNS CHARACTER
  (pcDispName AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Returns the runname (blank if table) 
Parameter: pcDispName - 'RunName (ObjectName)' for an object  
                         as used in selectionlist or property
                           
    Notes:  
------------------------------------------------------------------------------*/
  RETURN IF INDEX(pcDispName,"(":U) > 0 
         THEN TRIM(ENTRY(1,pcDispName,"(":U))
         ELSE "":U. 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION sameTables C-Win 
FUNCTION sameTables RETURNS LOGICAL
  (pTables   AS CHAR,
   pDbTables AS CHAR): 
/*-----------------------------------------------------------------------------
  Purpose: Compare a two comma separated lists of tables where one of them 
           always have database reference and the other may not
  Parameters:
    ptables   - With or without db. 
    pdbtables - Always with db.
      
    Notes: The function RETURNs FALSE as soon as a difference ids found.  
------------------------------------------------------------------------------*/
  DEF VAR i        AS INTEGER NO-UNDO.
  DEF VAR cDbTable AS CHAR    NO-UNDO.
  DEF VAR cEntry   AS CHAR    NO-UNDO.
  
  DEF VAR cTable  AS CHAR    NO-UNDO.
  DEF VAR cDb     AS CHAR    NO-UNDO.
  
  IF NUM-ENTRIES(pDbTables) <> NUM-ENTRIES(pTables) THEN
    RETURN FALSE.
    
  DO i = 1 TO NUM-ENTRIES(pDbTables):
    ASSIGN
      cDbTable = ENTRY(i,pDbTables) 
      cEntry   = ENTRY(i,pTables) 
      cDb      = ENTRY(1,cDbTable,".":U)
      cTable   = ENTRY(2,cDbTable,".":U).
    IF cTable <> ENTRY(NUM-ENTRIES(cEntry,".":U),cEntry,".":U) THEN 
      RETURN FALSE.  
    
    IF  NUM-ENTRIES(cEntry,".":U) = 2 
    AND ENTRY(1,cEntry,".":U) <> cDB THEN 
      RETURN FALSE. 
 
    
  END.
  
  RETURN TRUE. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setButtons C-Win 
FUNCTION setButtons RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
      btnTables:SENSITIVE  = TRUE
      btnSDO:SENSITIVE     = gcInitSDO    <> "":U 
                             OR
                             gcInitTables <> "":U 
      btnForeign:SENSITIVE = seExternal:SCREEN-VALUE <> ?                              
      btnJoin:SENSITIVE    = seExternal:SCREEN-VALUE <> ?
                             AND AVAIL tExternal
                             AND tExternal.NoJoin = FALSE
                             AND tExternal.Type   = "T":U
                             AND gcInitTables <> "":U
      btnRemove:SENSITIVE  = seExternal:SCREEN-VALUE <> ?.
  END.


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

