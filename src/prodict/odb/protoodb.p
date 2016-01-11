/*********************************************************************
* Copyright (C) 2005-2009 by Progress Software Corporation. All      *
* rights reserved.  Prior versions of this work may contain portions *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* Created:  D. McMann 06/22/98 PROTOODBC Utiity to migrate a Progress
                                database via ODBC to one of the following
                                foreign database:  Informix On-Line, DB2/6000
                                DB2NT, DB2/MVS, MS Access, MS SQL Server,
                                Sybase, and Other which will be a catch all
                                for databases which we do not specifically
                                support but that the user wants to try.
                                
  History:  D. McMann 09/03/98  Added assignment of code-page for default
                                and removed <current database> from progress
                                connect parameters. 
                      09/08/98  Removed compatibility for DB2 data bases. 
                      10/21/98  Removed compatibility for ALL data bases.
                      02/08/99  Added check for pro_dbname being same as DICTDB.
                                98-09-14-053   
                      03/03/99  Removed on-line from informix  
                      03/16/99  Made compatible the default  
                      12/02/99  Changed compatible label 
                                19990305027  
                      02/01/00  Added sqlwidth support                                             
                      04/12/00  Added long Progress Database path name
                      09/05/01  Added support for wrong version of SQL Server
                      11/16/01  Added logic to block moving data if running -rx
                      10/08/02  Added logic to create shadow columns.
                      10/23/02  Changed BLANK to PASSWORD-FIELD
                      06/17/03  Removed unsupported data sources
                      10/16/03  Created two OTHER catigories and removed MS Access
          K. McIntosh 04/13/04  Added Library field for DB2/400 ODBC support
          K. McIntosh 02/28/05  Added ability to override default x(8) character field
                                handling when deciding field width
          fernando    08/14/06  Removed Informix from list of valid foreign db types
          knavneet    08/03/07  For db2/400, making library name a required field
                      08/22/07  For db2/400, changing label from Library to Collection/Library and defaulting it to what is specified in the DSN.
          fernando    10/18/07  Make sure pcompatible is mantain disabled after error - OE00134723           
          fernando    08/18/08  Allow COLLECTION for batch - DB2/400
	  rkumar      01/08/09  Added default values for ODBC DataServer- OE00177724
          rkumar      04/28/09  Added RECID support  for ODBC DataServer- OE00177721
*/            


{ prodict/user/uservar.i NEW }
{ prodict/odb/odbvar.i NEW }

DEFINE VARIABLE cmd           AS CHARACTER                NO-UNDO.
DEFINE VARIABLE wait          AS CHARACTER                NO-UNDO.
DEFINE VARIABLE create_h      AS LOGICAL                  NO-UNDO.
DEFINE VARIABLE db_exist      AS LOGICAL                  NO-UNDO.
DEFINE VARIABLE batch_mode    AS LOGICAL INITIAL NO       NO-UNDO.
DEFINE VARIABLE old-dictdb    AS CHARACTER                NO-UNDO.  
DEFINE VARIABLE output_file   AS CHARACTER                NO-UNDO.
DEFINE VARIABLE tmp_str       AS CHARACTER                NO-UNDO.
DEFINE VARIABLE run_time      AS INTEGER                  NO-UNDO.
DEFINE VARIABLE i             AS INTEGER                  NO-UNDO.
DEFINE VARIABLE err-rtn       AS LOGICAL INITIAL FALSE    NO-UNDO.
DEFINE VARIABLE codb_type     AS CHARACTER FORMAT "x(32)" NO-UNDO.
DEFINE VARIABLE redo          AS LOGICAL                  NO-UNDO.
DEFINE VARIABLE redoblk       AS LOGICAL INITIAL FALSE    NO-UNDO.
DEFINE VARIABLE wrg-ver       AS LOGICAL INITIAL FALSE    NO-UNDO.
DEFINE VARIABLE mvdta         AS LOGICAL                  NO-UNDO.
DEFINE VARIABLE odbctypes     AS CHARACTER 
  INITIAL "Sybase,DB2/400,DB2(Other),Other(MS Access),Other(Generic),Other(MSAcce~ ss)" NO-UNDO.
DEFINE VARIABLE cFormat       AS CHARACTER INITIAL "For field widths use:"
                                           FORMAT "x(21)" NO-UNDO.
DEFINE VARIABLE lExpand             AS LOGICAL                  NO-UNDO.
DEFINE VARIABLE lCompatible_enabled AS LOGICAL                  NO-UNDO.
DEFINE VARIABLE def_libraries       AS CHARACTER INITIAL ""  NO-UNDO.
DEFINE VARIABLE lodbdef_enabled     AS LOGICAL                  NO-UNDO. /* OE00177724 */

DEFINE STREAM   strm.

&IF "{&OPSYS}" NE "UNIX" &THEN 
 DEFINE VARIABLE dsn_name      AS CHARACTER                NO-UNDO.
 DEFINE VARIABLE default_lib   AS CHARACTER                NO-UNDO.
 FUNCTION getRegEntry RETURN CHARACTER (INPUT dsnName as CHARACTER, keyName  AS CHARACTER) FORWARD. 
&ENDIF.
batch_mode = SESSION:BATCH-MODE.

FORM
  " "   SKIP({&VM_WID}) 
  pro_dbname   FORMAT "x({&PATH_WIDG})"  view-as fill-in size 32 by 1 
    LABEL "Original {&PRO_DISPLAY_NAME} Database" colon 36 SKIP({&VM_WID}) 
  pro_conparms FORMAT "x(256)" view-as fill-in size 32 by 1 
    LABEL "Connect Parameters for {&PRO_DISPLAY_NAME}" colon 36 SKIP({&VM_WID})
  osh_dbname   FORMAT "x(32)"  view-as fill-in size 32 by 1 
    LABEL "Name of Schema Holder Database" colon 36 SKIP({&VM_WID})
  odb_dbname   FORMAT "x(32)"  view-as fill-in size 32 by 1 
    LABEL "ODBC Data Source Name" colon 36 SKIP({&VM_WID})
 &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
   codb_type LABEL "Foreign DBMS Type" colon 36 view-as fill-in size 32 by 1
      SKIP ({&VM_WID})  
 &ELSE
   odb_type LABEL "Foreign DBMS Type" colon 36 SKIP ({&VM_WID})       
 &ENDIF  
 
  odb_username FORMAT "x(32)"  view-as fill-in size 32 by 1 
    LABEL "ODBC Username" colon 36 SKIP({&VM_WID})
  odb_password FORMAT "x(32)"  PASSWORD-FIELD
        view-as fill-in size 32 by 1 
        LABEL "ODBC User's Password" colon 36 SKIP({&VM_WID})
  odb_conparms FORMAT "x(256)" view-as fill-in size 32 by 1 
     LABEL "ODBC Connect Parameters" colon 36 SKIP({&VM_WID})
  odb_codepage FORMAT "x(32)"  view-as fill-in size 32 by 1
     LABEL "Codepage for Schema Image" colon 36 SKIP({&VM_WID})
  odb_collname FORMAT "x(32)"  view-as fill-in size 32 by 1
     LABEL "Collation Name" colon 36 SKIP({&VM_WID})
  odb_library FORMAT "x(32)"  VIEW-AS FILL-IN SIZE 32 BY 1
     LABEL "Collection/Library" COLON 36 
  &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN SKIP({&VM_WID})
  &ELSE SKIP({&VM_WIDG}) &ENDIF


  SPACE(2) pcompatible view-as toggle-box 
                       LABEL "Create RECID Column"  
  shadowcol VIEW-AS TOGGLE-BOX LABEL "Create Shadow Columns" COLON 38 SKIP({&VM_WID})
  SPACE(2) iRidOption AT 6 VIEW-AS RADIO-SET RADIO-BUTTONS "All Tables", 1,
                                             "Tables Without Unique Key", 2
                               VERTICAL NO-LABEL 
  loadsql view-as toggle-box label "Load SQL" COLON 38 SKIP({&VM_WID})
 /*&IF "{&WINDOW-SYSTEM}" = "TTY" &THEN SPACE(24)
 &ELSE SPACE(23) &ENDIF */
  movedata view-as toggle-box label "Move Data" AT ROW-OF iRidOption + 1 COL 40 SKIP({&VM_WID})
  SPACE(2) odbdef VIEW-AS TOGGLE-BOX LABEL "Include Defaults" SKIP({&VM_WID})
  SPACE(2) cFormat VIEW-AS TEXT NO-LABEL 
  iFmtOption VIEW-AS RADIO-SET RADIO-BUTTONS "Width", 1,
                                             "ABL Format", 2
                               HORIZONTAL NO-LABEL SKIP({&VM_WID})
  lExpand VIEW-AS TOGGLE-BOX LABEL "Expand x(8) to 30" AT 40
  &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN SKIP({&VM_WIDG})
  &ELSE SKIP({&VM_WID}) &ENDIF
             {prodict/user/userbtns.i}
  WITH FRAME x  CENTERED SIDE-labels OVERLAY
    DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
    &IF "{&WINDOW-SYSTEM}" <> "TTY"
  &THEN VIEW-AS DIALOG-BOX &ENDIF
  TITLE "{&PRO_DISPLAY_NAME} DB to ODBC Conversion".

FORM
  wait FORMAT "x" LABEL
  "Creating tables - Please wait"
  WITH FRAME table-wait ROW SCREEN-LINES - 2 COLUMN 1 NO-BOX OVERLAY
  &IF "{&WINDOW-SYSTEM}" <> "TTY"
  &THEN VIEW-AS DIALOG-BOX &ENDIF.


/* PROCEDURES */
PROCEDURE cleanup:  
  IF NUM-DBS > 1 THEN DO:   
    IF rmvobj THEN DO:
        DISCONNECT VALUE(osh_dbname).
        RUN prodict/misc/_clproto.p (INPUT osh_dbname, INPUT pro_dbname).
    END.
    ELSE DO:       
      CREATE ALIAS DICTDB FOR DATABASE VALUE(osh_dbname).
      RUN prodict/misc/_del-db.p (INPUT odb_dbname, INPUT osh_dbname, 
                                  INPUT pro_dbname).       
    END.
  END.
END PROCEDURE.

/*   TRIGGERS   */

&IF "{&WINDOW-SYSTEM}" = "TTY" &THEN

 ON LEAVE of codb_type IN FRAME x DO :
   IF codb_type BEGINS "SQL" THEN codb_type = "Sql Server 6".
   IF LOOKUP(input codb_type, odbctypes) = 0 THEN DO:
     MESSAGE "THE DBMS types that are supported are: " SKIP  
       "  Sybase, DB2/400, DB2(Other), Other(MS Access), Other(Generic)" SKIP (1)
        VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
   END.

      /* if not changing value, nothing to be done and can't go through or we 
      will end up undoing the user changes and changing stuff back to their 
      default values 
   */
   IF codb_type = SELF:screen-value THEN
      RETURN.

   IF input codb_type BEGINS "DB2" OR
      input codb_type BEGINS "MS Acc" OR
      input codb_type BEGINS "MSAcc" OR
      input codb_type BEGINS "Oth"  THEN 
     ASSIGN pcompatible:screen-value in frame x = "no"
            pcompatible = FALSE
            pcompatible:sensitive in frame x = no.
   ELSE
     ASSIGN pcompatible:sensitive in frame x = YES
            pcompatible = TRUE
            pcompatible:screen-value in frame x = "yes".   

   IF input codb_type EQ "DB2/400" THEN 
     ASSIGN odbdef:screen-value in frame x = "no"
            odbdef = FALSE
            odbdef:sensitive in frame x = yes
            pcompatible:sensitive in frame x = yes.
   ELSE
     ASSIGN odbdef:sensitive in frame x = no
            odbdef = FALSE
            odbdef:screen-value in frame x = "no"
            iRidOption:SCREEN-VALUE in frame x = "1"  
            iRidOption:SENSITIVE in frame x = FALSE.
   ASSIGN lodbdef_enabled = odbdef
          iRidOption = INTEGER(iRidOption:SCREEN-VALUE). /* OE00189366 */
  
   ASSIGN lCompatible_enabled = pcompatible:sensitive in frame x. 

   IF codb_type:SCREEN-VALUE BEGINS "Oth" THEN
       ASSIGN shadowcol:SENSITIVE IN FRAME X = NO
              shadowcol:SCREEN-VALUE IN FRAME X = "no".
   ELSE
       ASSIGN shadowcol:SENSITIVE IN FRAME X = YES
              shadowcol:SCREEN-VALUE IN FRAME X = "no".
   /* If the user has chosen DB2/400, display and enable the Library fill-in. 
      Otherwise, hide it. */
   IF codb_type:SCREEN-VALUE IN FRAME X EQ "DB2/400" THEN
     ASSIGN odb_library:HIDDEN    IN FRAME X = FALSE
            odb_library:SENSITIVE IN FRAME X = TRUE.
   ELSE
     ASSIGN odb_library:HIDDEN       IN FRAME X = TRUE
            odb_library:SENSITIVE    IN FRAME X = FALSE
            odb_library:SCREEN-VALUE IN FRAME X = ""
            odb_library                         = "".

   /*keep value up-to-date - OE00177721 */
   odb_type = SELF:screen-value.
 END.

 ON ENTRY OF pro_dbname IN FRAME X DO:

   IF codb_type:SCREEN-VALUE IN FRAME X EQ "DB2/400" THEN
     ASSIGN odb_library:HIDDEN    IN FRAME X = FALSE
            odb_library:SENSITIVE IN FRAME X = TRUE
            odbdef:SENSITIVE      IN FRAME X = TRUE.
   ELSE
     ASSIGN odb_library:HIDDEN       IN FRAME X = TRUE
            odb_library:SENSITIVE    IN FRAME X = FALSE
            odb_library:SCREEN-VALUE IN FRAME X = ""
            odb_library                         = ""
            odbdef:SENSITIVE         IN FRAME X = FALSE
            odbdef:SCREEN-VALUE      IN FRAME X = "no"
            odbdef                              = NO.
 END.
&ENDIF  

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
 ON VALUE-CHANGED of odb_type IN FRAME x OR
    LEAVE of odb_type IN FRAME x DO :

   /* if not changing value, nothing to be done and can't go through or we 
      will end up undoing the user changes and changing stuff back to their 
      default values 
   */
   IF odb_type = SELF:screen-value THEN
      RETURN.

   IF odb_type:screen-value BEGINS "DB2" OR
      odb_type:screen-value BEGINS "MS Acc" OR
      odb_type:screen-value BEGINS "Oth" THEN
     ASSIGN pcompatible:screen-value in frame x = "no"
            pcompatible = FALSE
            pcompatible:sensitive in frame x = no.
   ELSE
     ASSIGN pcompatible:sensitive in frame x = YES
            pcompatible:screen-value in frame x = "yes"
            pcompatible = TRUE.  

   IF odb_type:screen-value EQ "DB2/400" THEN
     ASSIGN odbdef:screen-value in frame x = "no"
            odbdef = FALSE
            odbdef:sensitive in frame x = yes
            pcompatible:sensitive in frame x = yes.
   ELSE
     ASSIGN odbdef:sensitive in frame x = NO
            odbdef:screen-value in frame x = "no"
            odbdef = FALSE
            iRidOption:SCREEN-VALUE in frame x  = "1"  
            iRidOption:SENSITIVE in frame x = FALSE.  
   ASSIGN lodbdef_enabled = odbdef
          lCompatible_enabled = pcompatible:sensitive in frame X
          iRidOption = INTEGER(iRidOption:SCREEN-VALUE). /* OE00189366 */. 
    
   IF odb_type:SCREEN-VALUE BEGINS "Other(G" THEN
       ASSIGN shadowcol:SENSITIVE IN FRAME X = NO
              shadowcol:SCREEN-VALUE = "NO".
   ELSE
       ASSIGN shadowcol:SENSITIVE IN FRAME X = YES
              shadowcol:SCREEN-VALUE = "no".
   /* If the user has chosen DB2/400, display and enable the Library fill-in. 
      Otherwise, hide it. */
   IF odb_type:SCREEN-VALUE IN FRAME X EQ "DB2/400" THEN
     ASSIGN odb_library:HIDDEN    IN FRAME X = FALSE
            odb_library:SENSITIVE IN FRAME X = TRUE.
   ELSE
     ASSIGN odb_library:HIDDEN       IN FRAME X = TRUE
            odb_library:SENSITIVE    IN FRAME X = FALSE
            odb_library:SCREEN-VALUE IN FRAME X = ""
            odb_library                         = "".

   /*keep value up-to-date - OE00177721 */
   odb_type = SELF:screen-value.
 END.

 ON ENTRY OF pro_dbname IN FRAME X DO:
   IF odb_type EQ "DB2/400" THEN
     ASSIGN odb_library:HIDDEN    IN FRAME X = FALSE
            odb_library:SENSITIVE IN FRAME X = TRUE
            iRidOption:SENSITIVE  IN FRAME X = TRUE
            odbdef:SENSITIVE      IN FRAME X = TRUE.
   ELSE
     ASSIGN odb_library:HIDDEN       IN FRAME X = TRUE
            odb_library:SENSITIVE    IN FRAME X = FALSE
            odb_library:SCREEN-VALUE IN FRAME X = ""
            odb_library                         = ""
            iRidOption:SENSITIVE     IN FRAME X = FALSE
            odbdef:SENSITIVE         IN FRAME X = FALSE
            odbdef:SCREEN-VALUE      IN FRAME X = "no"
            odbdef                              = NO.
 END.
&ENDIF
  
/* Please Note: In the event that we cover DB2 drivers on a UNIX platform:
   The DataDirect ODBC driver on the UNIX platform has a corresponding 
   location in the ODBC.INI file the connection string attribute
   "Collection" (COL=<value>) and AlternateID (AID=<value>)  
   where these values can be extracted.
   Also Note: The registry keys & values for SQL qualifier are specific to DataDirect drivers.
   The process for obtaining the appropriate qualifier may change if access to DB2 native
   drivers through the ODBC DataServer is considered in the future */
 /* OE00178256- In case of iSeries Access ODBC driver, the registry entry with the key 
    "DefaultLibraries" specifies the iSeries libraries to add to the server job's library list
    The libraries are delimited by commas or spaces, and *USRLIBL may be used as a 
    place holder for the server job's current library list. */
 /* OE00179889- iSeries driver: Default library is genrated based on the following rules:
    If any value is provided for SQL Default Library, then a space-separated list is created 
    in the registry, irrespective of spaces or commas separating the library list.
    If no value is provided for SQL Default Library, then first character is comma and then a 
    space-separated list is created in registry irrespective of presence of spaces or commas 
    separating the libaries in the library list.  */


&IF "{&OPSYS}" NE "UNIX" 
&THEN
  ON LEAVE of odb_dbname in frame X DO:
  dsn_name = odb_dbname:SCREEN-VALUE.
  IF INDEX(getRegEntry(dsn_name,"Driver"),"cwbodbc.dll") EQ 0 THEN 
	default_lib = (IF getRegEntry(dsn_name,"AlternateID") <> ? THEN
                   getRegEntry(dsn_name,"AlternateID")
                 ELSE (IF getRegEntry(dsn_name,"Collection") <> ? THEN
                   getRegEntry(dsn_name,"Collection")
                 ELSE (IF getRegEntry(dsn_name,"LogOnID") <> ? THEN
                   getRegEntry(dsn_name,"LogOnID")
		 ELSE "" ))).
  ELSE DO:
         ASSIGN def_libraries = getRegEntry(dsn_name,"DefaultLibraries").
	 default_lib = (IF def_libraries <> ? AND index(def_libraries,",") EQ 1 THEN
		    SUBSTRING(def_libraries,2,index(def_libraries," ") - 1) 
		 ELSE (IF def_libraries <> ? AND index(def_libraries," ") GE 0 THEN
		    SUBSTRING(def_libraries,1,index(def_libraries," ") - 1) 
		 ELSE (IF def_libraries EQ ? AND getRegEntry(dsn_name,"UserID") <> ? THEN 
                    getRegEntry(dsn_name,"UserID")
		 ELSE ""))).  
  END. 
  ASSIGN odb_library:SCREEN-VALUE IN FRAME X = default_lib
         odb_library                         = default_lib.
  END. 
&ENDIF.

ON LEAVE OF odb_library IN FRAME X 
  ASSIGN odb_library.

ON WINDOW-CLOSE of FRAME x
   APPLY "END-ERROR" to FRAME x.
   
ON VALUE-CHANGED OF iFmtOption IN FRAME x DO:
  IF SELF:SCREEN-VALUE = "1" THEN
    ASSIGN lExpand:CHECKED   = FALSE
           lExpand:SENSITIVE = FALSE
           lFormat           = ?.
  ELSE 
    ASSIGN lExpand:CHECKED   = TRUE
           lExpand:SENSITIVE = TRUE
           lFormat           = FALSE.
END.
ON VALUE-CHANGED of loadsql IN FRAME x DO:
  IF SELF:screen-value = "yes" THEN 
     movedata:sensitive in frame x = YES.
  ELSE DO:
     movedata:screen-value in frame x = "no".
     movedata = false.
     movedata:sensitive in frame x = NO.
  END.   
END.  

ON VALUE-CHANGED of pcompatible IN FRAME x DO: 
/* only need to do this for db2/400 since iRidOption cannot be enabled otherwise */ 
    IF SELF:screen-value = "yes" THEN DO:
       assign pcompatible = TRUE.
       IF odb_type EQ "DB2/400" THEN DO:
          ASSIGN iRidOption:SCREEN-VALUE in frame x = "2"
                 iRidOption:SENSITIVE in frame x = TRUE.

&IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
           iRidOption:MOVE-AFTER-TAB-ITEM(pcompatible:HANDLE in frame x) in frame X.
&ENDIF
       END.
       ELSE
          ASSIGN iRidOption:SCREEN-VALUE in frame x  = "1"
                 iRidOption:SENSITIVE in frame x = FALSE.   
    END. 
    ELSE 
       ASSIGN pcompatible = FALSE
              iRidOption:SCREEN-VALUE in frame x  = "1" 
              iRidOption:SENSITIVE in frame x = FALSE.
ASSIGN iRidOption = INTEGER(iRidOption:SCREEN-VALUE). /* OE00189366 */
END.

ON VALUE-CHANGED of odbdef IN FRAME x DO:
  IF SELF:screen-value = "yes" THEN
     assign lodbdef_enabled = TRUE
            odbdef = TRUE.
  ELSE DO:
     assign lodbdef_enabled = FALSE
            odbdef = FALSE.
  END.   
END.  

&IF "{&WINDOW-SYSTEM}"<> "TTY" &THEN   
/*----- HELP in Progress DB to Oracle Database -----*/
on CHOOSE of btn_Help in frame x
   RUN "adecomm/_adehelp.p" (INPUT "admn", INPUT "CONTEXT", 
                             INPUT {&PROGRESS_DB_to_ODBC_Dlg_Box},
                             INPUT ?).
&ENDIF

IF LDBNAME ("DICTDB") <> ? THEN
  ASSIGN pro_dbname = LDBNAME ("DICTDB").

IF NOT batch_mode THEN DO:
   {adecomm/okrun.i  
       &FRAME  = "FRAME x" 
       &BOX    = "rect_Btns"
       &OK     = "btn_OK" 
       {&CAN_BTN}
   }
   &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
   btn_Help:visible IN FRAME x = yes.
   &ENDIF
END.

ASSIGN pcompatible = YES
    lCompatible_enabled = YES.
ASSIGN odbdef = NO
    lodbdef_enabled = NO.

main-blk:
DO ON ERROR UNDO main-blk, RETRY main-blk:
  
  IF redo THEN
     RUN cleanup.

  IF logfile_open THEN DO:
     OUTPUT STREAM logfile CLOSE.
     logfile_open = FALSE.
  END.

  IF wrg-ver THEN DO:
    MESSAGE "The DataServer for ODBC was designed to work with MS SQL Server 6 and " SKIP
            "below.  You have tried to connect to a later version. " SKIP
            "Use the DataServer for MS SQL Server to perform this function. " SKIP(1)       
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    RETURN.
  END.

  ASSIGN run_time = TIME.

  IF OS-GETENV("PRODBNAME")   <> ? THEN
      pro_dbname   = OS-GETENV("PRODBNAME").
  IF OS-GETENV("PROCONPARMS")   <> ? THEN
        pro_conparms = OS-GETENV("PROCONPARMS").
  IF OS-GETENV("SHDBNAME")    <> ? THEN
      osh_dbname   = OS-GETENV("SHDBNAME").
  IF OS-GETENV("ODBCDBNAME")   <> ? THEN
      odb_dbname   = OS-GETENV("ODBCDBNAME").
  IF OS-GETENV("ODBCTYPE")   <> ? THEN
      odb_type   = OS-GETENV("ODBCTYPE").    
  IF OS-GETENV("ODBCUSERNAME") <> ? THEN
      odb_username = OS-GETENV("ODBCUSERNAME").
  IF OS-GETENV("ODBCPASSWORD") <> ? THEN
      odb_password = OS-GETENV("ODBCPASSWORD").
  IF OS-GETENV("ODBCCONPARMS") <> ? THEN
      odb_conparms = OS-GETENV("ODBCCONPARMS").
  IF OS-GETENV("ODBCCODEPAGE") <> ? THEN
      odb_codepage = OS-GETENV("ODBCODEPAGE").
  ELSE
     ASSIGN odb_codepage = session:cpinternal.
  IF OS-GETENV("ODBCCOLLNAME") <> ? THEN
      odb_collname = OS-GETENV("ODBCCOLLNAME").
  ELSE
     ASSIGN odb_collname = session:CPCOLL.
  IF OS-GETENV("MOVEDATA")    <> ? THEN
      tmp_str      = OS-GETENV("MOVEDATA").
  IF tmp_str BEGINS "Y" THEN movedata = TRUE.

  IF OS-GETENV("COMPATIBLE") <> ? 
  THEN DO:
      tmp_str      = OS-GETENV("COMPATIBLE").
      IF tmp_str BEGINS "Y" then pcompatible = TRUE.
      ELSE pcompatible = FALSE.
   END. 
  ELSE IF batch_mode AND odb_type EQ "DB2/400" THEN ASSIGN
      pcompatible = FALSE.

  IF OS-GETENV("SHADOWCOL") <> ? THEN DO:
    tmp_str      = OS-GETENV("SHADOWCOL").
    IF tmp_str BEGINS "Y" then shadowcol = TRUE.
    ELSE shadowcol = FALSE.
  END. 
  ELSE 
    shadowcol = FALSE.

  IF OS-GETENV("CRTDEFAULT") <> ? 
   THEN DO:
      tmp_str      = OS-GETENV("CRTDEFAULT").
      IF tmp_str BEGINS "Y" then odbdef = TRUE.
      ELSE odbdef = FALSE.
   END. 
  ELSE
      odbdef = FALSE.

  /* Initialize field width choice */
  IF OS-GETENV("SQLWIDTH") <> ? THEN DO:
    tmp_str      = OS-GETENV("SQLWIDTH").
    IF tmp_str BEGINS "Y" THEN 
      iFmtOption = 1.
    ELSE 
      iFmtOption = 2.
  END. 
  ELSE
    iFmtOption = 2.
 
  IF OS-GETENV("EXPANDX8") <> ? THEN DO:
    ASSIGN tmp_str  = OS-GETENV("EXPANDX8").
    IF tmp_str BEGINS "Y" THEN 
      ASSIGN lExpand = TRUE
             lFormat = FALSE.
    ELSE 
      ASSIGN lExpand = FALSE
             lFormat = TRUE.
  END. 
  ELSE
    ASSIGN lExpand = TRUE
           lFormat = FALSE.

  IF odb_type = "DB2/400" THEN DO: 
    tmp_str      = OS-GETENV("RECIDALLTABLES").
    IF tmp_str BEGINS "Y" THEN 
      iRidOption = 1.
    ELSE 
      iRidOption = 2.
  END. 
  ELSE
    iRidOption = 1.

  IF OS-GETENV("LOADSQL") <> ? THEN DO:
    tmp_str      = OS-GETENV("LOADSQL").
    IF tmp_str BEGINS "Y" then loadsql = TRUE.
    ELSE loadsql = FALSE.
  END. 
  ELSE 
    loadsql = TRUE.
 
  /* allow collection to be specified */
  IF odb_type = "DB2/400" AND OS-GETENV("COLLECTION") <> ? THEN
     odb_library = OS-GETENV("COLLECTION").

  IF PROGRESS EQ "COMPILE-ENCRYPT" THEN
    ASSIGN mvdta = FALSE.
  ELSE
    ASSIGN mvdta = TRUE.

  if   pro_dbname   = ldbname("DICTDB")
   and pro_conparms = ""
   then assign pro_conparms = "<current working database>".

  IF redoblk THEN DO:
      MESSAGE "You have received error messages from the client stating why" 
              SKIP
              "the process was stopped.  Correct the errors and try again." SKIP
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  END.

  /*
   * if this is not batch mode, allow override of environment variables.
   */
  
  IF NOT batch_mode THEN 
  _updtvar: 
  DO WHILE TRUE:
    &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
      DISPLAY cFormat lExpand WITH FRAME x.
      UPDATE pro_dbname
        pro_conparms
        osh_dbname
        odb_dbname
        odb_type 
        odb_username
        odb_password
        odb_conparms
        odb_codepage  
        odb_collname
        odb_library
        pcompatible WHEN lCompatible_enabled    
        iRidOption WHEN pcompatible
        shadowcol
        loadsql
        movedata WHEN mvdta
        odbdef
        iFmtOption
        lExpand WHEN iFmtOption = 2
        btn_OK btn_Cancel 
        &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
            btn_Help
        &ENDIF
        WITH FRAME x.
    &ELSE
      DISPLAY cFormat lExpand WITH FRAME x.
      UPDATE pro_dbname
        pro_conparms
        osh_dbname
        odb_dbname
        codb_type 
        odb_username
        odb_password
        odb_conparms
        odb_codepage
        odb_collname
        odb_library
        pcompatible
        iRidOption WHEN pcompatible AND codb_type = "DB2/400"
        shadowcol
        loadsql
        movedata
        odbdef
        iFmtOption
        lExpand WHEN iFmtOption = 2
        btn_OK btn_Cancel
        WITH FRAME X.
        
      IF codb_type = ? OR codb_type = "" THEN DO:
        MESSAGE "Foreign DBMS Type is required." SKIP
            VIEW-AS ALERT-BOX.
        NEXT-PROMPT codb_type with frame x.
        NEXT _updtvar.
      END.
      ELSE
        ASSIGN odb_type = codb_type.              
    &ENDIF      

    IF iFmtOption = 1 THEN
        lFormat = ?.
      ELSE
        lFormat = (NOT lExpand).
      
    IF pro_conparms = "<current working database>" THEN
      ASSIGN pro_conparms = "".

      IF odb_library:HIDDEN = NO and (odb_library = "" OR odb_library = ?) THEN DO:
        MESSAGE "Collection/Library is required."
             VIEW-AS ALERT-BOX ERROR.
        NEXT-PROMPT odb_library with frame x.
        NEXT _updtvar.
      END.

    IF loadsql THEN DO:
      IF Osh_dbname = "" OR osh_dbname = ? THEN DO:
        MESSAGE "Schema holder database Name is required." 
             VIEW-AS ALERT-BOX ERROR.    
        NEXT _updtvar.
      END.

      IF odb_dbname = "" OR odb_dbname = ? THEN DO:
        MESSAGE "ODBC Data Source Name is required."  
            VIEW-AS ALERT-BOX ERROR.  
        NEXT _updtvar.
      END.
     ELSE
       ASSIGN odb_library = UPPER(odb_library).
    END.      
    LEAVE _updtvar.
  END.
  
  IF osh_dbname <> "" AND osh_dbname <> ? THEN
      output_file = osh_dbname + ".log".
  ELSE
      output_file = "protoodb.log". 

  OUTPUT STREAM logfile TO VALUE(output_file) NO-ECHO NO-MAP UNBUFFERED. 
  logfile_open = true. 
  IF pro_dbname = "" OR pro_dbname = ? THEN DO:
    PUT STREAM logfile UNFORMATTED "{&PRO_DISPLAY_NAME} Database name is required." SKIP.
    ASSIGN err-rtn = TRUE.
  END.
  ELSE DO:
      IF LDBNAME ("DICTDB") <> pro_dbname THEN DO:
          ASSIGN old-dictdb = LDBNAME("DICTDB").
          IF NOT CONNECTED(pro_dbname) THEN
            CONNECT VALUE (pro_dbname) VALUE (pro_conparms) -1 NO-ERROR.              
          
          IF ERROR-STATUS:ERROR OR NOT CONNECTED (pro_dbname) THEN DO:
            DO i = 1 TO  ERROR-STATUS:NUM-MESSAGES:
              IF batch_mode THEN
                PUT STREAM logfile UNFORMATTED ERROR-STATUS:GET-MESSAGE(i) skip.
              ELSE
                MESSAGE ERROR-STATUS:GET-MESSAGE(i).
            END.
            IF batch_mode THEN
               PUT STREAM logfile UNFORMATTED "Unable to connect to {&PRO_DISPLAY_NAME} database"
               skip.
            ELSE DO:
              &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
                  MESSAGE "Unable to connect to {&PRO_DISPLAY_NAME} database".
              &ELSE
                 MESSAGE "Unable to connect to {&PRO_DISPLAY_NAME} database" 
                 VIEW-AS ALERT-BOX ERROR.
              &ENDIF
            END.            
            ASSIGN err-rtn = TRUE.
          END.
          ELSE DO:
            CREATE ALIAS DICTDB FOR DATABASE VALUE(pro_dbname).
          end.  
      END.
      ELSE
          ASSIGN old-dictdb = LDBNAME("DICTDB").
  END.

  IF odb_type = "" OR odb_type = ? THEN DO:
     PUT STREAM logfile UNFORMATTED "Foreign DBMS type is required." SKIP.   
     ASSIGN err-rtn = TRUE.
  END.

  /* for DB2/400, must specify collection name */
  IF odb_type = "DB2/400" AND (odb_library = "" OR odb_library = ?) THEN DO:
     PUT STREAM logfile UNFORMATTED "Collection/Library is required." SKIP.
     ASSIGN err-rtn = TRUE.
  END.

  IF loadsql THEN DO:
    IF Osh_dbname = "" OR osh_dbname = ? THEN DO:
       PUT STREAM logfile UNFORMATTED  "Schema holder Database Name is required." SKIP.   
       ASSIGN err-rtn = TRUE.        
    END.
    IF odb_dbname = "" OR odb_dbname = ? THEN DO:
       PUT STREAM logfile UNFORMATTED "ODBC data source name is required." SKIP.   
       ASSIGN err-rtn = TRUE.
    END.
  END.      
  IF err-rtn THEN RETURN.

  ASSIGN redo = TRUE.
  /* Set correct odbc type for the next process */
  IF odb_type BEGINS "Oth" THEN DO:
    IF odb_type = "Other(Ms Access)" OR odb_type = "Other(MsAccess)" THEN
       ASSIGN odb_type = "Ms Access".
    ELSE
       ASSIGN odb_type = "Other".
  END.

  RUN prodict/odb/protood1.p.
  IF RETURN-VALUE = "indb" THEN DO:
    ASSIGN redo = FALSE.
    UNDO, RETRY.
  END.
  ELSE IF RETURN-VALUE = "wrg-ver" THEN DO:
    ASSIGN wrg-ver = TRUE.
    UNDO, RETRY.
  END.
  ELSE IF RETURN-VALUE = "undo" THEN DO:
    ASSIGN redoblk = TRUE.
    UNDO, RETRY.
  END.
  /*
   * If this is batch mode, make sure we close the output file we
   * opened above.
  */
  IF logfile_open
    THEN OUTPUT STREAM logfile CLOSE.
 
  IF CONNECTED (osh_dbname) THEN 
     DISCONNECT VALUE (osh_dbname).

  IF pro_dbname <> old-dictdb THEN DO:
    DISCONNECT VALUE(pro_dbname).
    IF old-dictdb NE ? THEN
       CREATE ALIAS DICTDB FOR DATABASE VALUE(old-dictdb).   
  END.
END.

&IF "{&OPSYS}" NE "UNIX" &THEN

&SCOPED-DEFINE KEY_PATH "ODBC~\ODBC.INI~\"

/* Function : getRegEntry
   Purpose  : To read from WindowsRegistry
   Input    : DSN name as charcter & Key as Character
   Output   : Value read from registry as character */

FUNCTION getRegEntry RETURN CHARACTER 
 (INPUT dsnName as CHARACTER, keyName AS CHARACTER):
  DEFINE VARIABLE keyData AS CHARACTER NO-UNDO INIT ?.

  /* Look for User DSN first */
   LOAD "SOFTWARE" BASE-KEY "HKEY_CURRENT_USER".
   USE "SOFTWARE".
   GET-KEY-VALUE SECTION {&KEY_PATH} + dsnName
   KEY keyName
   VALUE keyData.
   UNLOAD "SOFTWARE".

  /* Look for System DSN, if User DSN not found */
  IF keyData EQ ? THEN DO:
   LOAD "SOFTWARE" BASE-KEY "HKEY_LOCAL_MACHINE".
   USE "SOFTWARE".
   GET-KEY-VALUE SECTION {&KEY_PATH} + dsnName
   KEY keyName
   VALUE keyData.
   UNLOAD "SOFTWARE".
  END.

  RETURN keyData.
END FUNCTION.
&ENDIF 
