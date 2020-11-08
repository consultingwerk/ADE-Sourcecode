/***********************************************************************
* Copyright (C) 2008-2014,2020 by Progress Software Corporation.       *
* All rights reserved.  Prior versions of this work may contain        *
* portions contributed by participants of Possenet.                    *
*                                                                      *
************************************************************************/

/*----------------------------------------------------------------------------

File: _usrichg.p

Description: 
   TTY module to allow changes to index properties. 

History:
    05/31/96    tomn        Added rowid support for multi-component indexes. 
    02/09/98    mcmann      Added character display of _ianum.
    03/31/98    mcmann      Changed display of _ianum to Area Name
    04/14/98    laurief     fixed bug 98-04-09-004 - removed APPLY LEAVE
                            if not is-area on line 247-248 and moved prompt for
                            indexarea to last field in idx_top frame
    04/15/98    mcmann      Added check for is-area being not true to know
                            if area has been checked.  If field is not entered
                            the leave trigger does not fire.
    04/17/98    mcmann      Added check of field recid > 0 for default index
                            changes.
    04/20/98    mcmann      default _index now as fields so added delete of
                            _index-field records.  Also changed where the area
                            name is gotten from since the SQL meta-schema does
                            not have an ianum.
    04/21/98    mcmann      Further changes handling proper area information
    12/11/98    mcmann      Changed not allowed to change uniqueness message to be displayed as
                            alert-box.
    12/28/98   Mario B      Add s_In_Schema_Area enabling one time notification. 
    05/15/00   D. McMann    Removed message when only Schema Area in DB    
    06/14/00   D. McMann    Added selection list for areas.  
    08/16/00   D. McMann    Added _db-recid to StorageObject find 20000815029   
    07/29/03   D. McMann    Adjusted screen for new data types with long names 
    03/26/05   K. McIntosh  Added warning when attempting to add an active
                            index on-line
    06/08/06  fernando      Support for large key entries
    10/03/07  fernando      Fixed delimiter issue on area name list - OE00135682
    11/16/07  fernando      Support for _aud-audit-data* indexes deactivation
    06/26/08  fernando      Filter out schema tables for encryption
    04/06/20  tmasood       Fix the active toggle box for online added index

----------------------------------------------------------------------------*/

{ prodict/dictvar.i }
{ prodict/user/uservar.i }
{ prodict/pro/arealabel.i}

DEFINE VARIABLE answer         AS LOGICAL                 NO-UNDO.
DEFINE VARIABLE c              AS CHARACTER               NO-UNDO.
DEFINE VARIABLE i              AS INTEGER                 NO-UNDO.
DEFINE VARIABLE in_trans       AS LOGICAL                 NO-UNDO.
DEFINE VARIABLE is_prime       AS LOGICAL                 NO-UNDO.
DEFINE VARIABLE j              AS INTEGER                 NO-UNDO.
DEFINE VARIABLE qbf#           AS INTEGER   INITIAL 1     NO-UNDO.
DEFINE VARIABLE qbf#list       AS CHARACTER               NO-UNDO.
DEFINE VARIABLE qbf_disp       AS RECID     INITIAL ?     NO-UNDO.
DEFINE VARIABLE qbf_home       AS RECID                   NO-UNDO.
DEFINE VARIABLE qbf_idx_deac   AS LOGICAL                 NO-UNDO.
DEFINE VARIABLE qbf_idx_max    AS INTEGER                 NO-UNDO.
DEFINE VARIABLE qbf_idx_nonu   AS LOGICAL                 NO-UNDO.
DEFINE VARIABLE qbf_idx_num    AS LOGICAL                 NO-UNDO.
DEFINE VARIABLE qbf_idx_uniq   AS LOGICAL                 NO-UNDO.
DEFINE VARIABLE qbf_idx_word   AS LOGICAL                 NO-UNDO.
DEFINE VARIABLE qbf_text       AS CHARACTER               NO-UNDO.
DEFINE VARIABLE qbf_was        AS INTEGER   INITIAL 2     NO-UNDO.
DEFINE VARIABLE r              AS RECID                   NO-UNDO.
DEFINE VARIABLE recid_idx      AS LOGICAL                 NO-UNDO.
DEFINE VARIABLE recid_idx1     AS LOGICAL                 NO-UNDO.
DEFINE VARIABLE redraw         AS LOGICAL   INITIAL TRUE  NO-UNDO.
DEFINE VARIABLE rpos           AS RECID                   NO-UNDO.
DEFINE VARIABLE scratch        AS CHARACTER               NO-UNDO.
DEFINE VARIABLE word_index     AS LOGICAL   INITIAL FALSE NO-UNDO.
DEFINE VARIABLE adding         AS LOGICAL                 NO-UNDO.
DEFINE VARIABLE edbtyp         AS CHARACTER               NO-UNDO. /* db-type external format */
DEFINE VARIABLE warnflg        AS CHAR                    NO-UNDO.
DEFINE VARIABLE l_ifldcnt      AS INT                     NO-UNDO.
DEFINE VARIABLE areaname       AS CHARACTER               NO-UNDO.
DEFINE VARIABLE arealist       AS CHARACTER INITIAL ?     NO-UNDO.
DEFINE VARIABLE indexarea      AS CHARACTER               NO-UNDO.
DEFINE VARIABLE lOk            AS LOGICAL                 NO-UNDO.
DEFINE VARIABLE large_idx      AS LOGICAL                 NO-UNDO INIT ?.
DEFINE VARIABLE ctemp          AS CHARACTER               NO-UNDO.
DEFINE VARIABLE canAudDeact    AS LOGICAL                 NO-UNDO.
define variable cAreaLabel     as character               no-undo.
define variable cAreaMTText    as character               no-undo.
define variable isTablePartitioned      as logical                 no-undo.
define variable isMultitenant    as LOGICAL             no-undo.
define variable isPartitioned    as LOGICAL             no-undo.
define variable isCDCEnabled     as logical             no-undo.
define variable l_actidx         as logical             no-undo.

DEFINE BUFFER bfr_Index FOR DICTDB._Index.

/* LANGUAGE DEPENDENCIES START */ /*---------------------------------------*/

DEFINE VARIABLE qbf AS CHARACTER EXTENT 17 NO-UNDO INITIAL [
  "Next",   "Prev",        "First",         "Last",       "Rename",
  "Add",    "Delete",      "ChangePrimary", "Uniqueness", "MakeInactive",
  "Browse", "SwitchTable", "GoField",       "ROWID",      "Undo",
  "ChangeLocal", "Exit"
].

FORM
  qbf[ 1] /*Next*/              FORMAT "x(4)"
    HELP "Look at the next index of this table."
  qbf[ 2] /*Prev*/              FORMAT "x(4)"
    HELP "Look at the previous index of this table."
  qbf[ 3] /*First*/             FORMAT "x(5)"
    HELP "Look at the first index of this table."
  qbf[ 4] /*Last*/              FORMAT "x(4)"
    HELP "Look at the last index of this table."
  qbf[ 5] /*Rename*/            FORMAT "x(6)"
    HELP "Rename an index."
  qbf[ 6] /*Add*/               FORMAT "x(3)"
    HELP "Add a new index."
  qbf[ 7] /*Delete*/            FORMAT "x(6)"
    HELP "Delete the currently displayed index."
  qbf[ 8] /*ChangePrimary*/     FORMAT "x(13)"
    HELP "Change the Primary Index of this table."  
  qbf[ 9] /*Uniqueness*/        FORMAT "x(10)"
    HELP "Change the Uniqueness of this index." SKIP
  qbf[10] /*MakeInactive*/      FORMAT "x(12)"
    HELP "Make an active index inactive." 
  qbf[11] /*Browse*/            FORMAT "x(6)"
    HELP "Browse through entire index component list." 
  qbf[12] /*SwitchTable*/       FORMAT "x(11)"
   HELP "Switch to another table."
  qbf[13] /*GoField*/           FORMAT "x(7)"
    HELP "Go to Fields Editor."
  qbf[14] /*ROWID*/             FORMAT "x(5)"
    HELP "Use this index for ROWID-support." /* only oracle, odbc */
  qbf[15] /*Undo*/              FORMAT "x(4)"
    HELP "Undo this session's changes to the index structures."
  qbf[16] /*ChangeLocal*/       FORMAT "x(11)"
    HELP "Make a global index local."
  qbf[17] /*Exit*/              FORMAT "x(4)"
    HELP "Exit Index Editor, save changes, and return to menu."  
  WITH FRAME qbf ATTR-SPACE OVERLAY NO-LABELS NO-BOX 
  ROW SCREEN-LINES - 3 COLUMN 3 CENTERED WIDTH 76.
/*
|  Next  Prev  First  Last  Rename  Add  Delete  ChangePrimary  Uniqueness
|  MakeInactive  Browse  SwitchTable  GoField  Undo  Exit
*/

DEFINE VARIABLE new_lang AS CHARACTER EXTENT 39 NO-UNDO INITIAL [
  /* 1*/ "This index is already the Primary Index of this table.",
  /* 2*/ "Are you sure that you want to make this the PRIMARY INDEX?",
  /* 3*/ "You cannot delete the Primary Index of a table.",
  /* 4*/ "Set another index to be the Primary and then try again.",
  /* 5*/ "Are you sure that you want to remove this index?",
  /* 6*/ "Undo all changes since selection of Index Update from menu?",
  /* 7*/ "You cannot rename the ~"default~" index.",
  /* 8*/ "This table has no user-created indexes.",
  /* 9*/ "You have reached the last index in the table.",
  /*10*/ "You have reached the first index in the table.",
  /*11*/ "This operation is not supported on table type", /* type appended */
  /*12*/ "You may now change the index name.",
  /*13*/ "That index name is already used.",
  /*14*/ ?, /* see below */
  /*15*/ "The dictionary is in read-only mode - alterations not allowed.",
  /*16*/ "You do not have permission to use this option.",
  /*17*/ ?, /* see below */
  /*18*/ "You have no [non-array] fields available for index components.",
  /*19*/ "Cannot deactivate indexes for this database type.",
  /*20*/ "This index has already been deactivated.",
  /*21*/ "Are you sure that you want to make the index", /*see #22*/
  /*22*/ "inactive?", /*see #21*/
  /*23*/ "You haven't yet made changes that need to be undone!",
  /*24*/ "For {&PRO_DISPLAY_NAME}/SQL, you must use the CREATE INDEX statement.",
  /*25*/ "For {&PRO_DISPLAY_NAME}/SQL, you must use the DROP INDEX statement.",
  /*26*/ "A Word Index can not be Primary.",
  /*27*/ "This table is frozen - You may not add or modify its indexes.",
  /*28*/ "A Word Index can not be Unique.",
  /*29*/ "Are you sure that you want to make this index &1?",
  /*30*/ "Uniqueness changes are not supported for &1 databases.",
  /*31*/ "The precision or scale of that field allow values incorrect for ROWID-Index.",
  /*32*/ "Index field is not Unique - Your application has to take care of that.",
  /*33*/ "Index field is not Mandatory - Your application has to take care of that.",
  /*34*/ "Are you sure you want to make this the index for ROWID support?",
  /*35*/ "This DataServer does not support/need ROWID-Indexes to be specified.",
  /*36*/ "This index can not be used for ROWID support.",
  /*37*/ "{&PRO_DISPLAY_NAME}/SQL92 Table, cannot modify.",
  /*38*/ "Large key entries support not enabled",
  /*39*/ "Local/Global index changes are not supported for &1 databases."
].

ASSIGN
  new_lang[14] = "~"Abbreviate~" is an index option that lets you "
               + "conveniently search for a partial match based on the first "
               + "few characters of a field (like using BEGINS) in the FIND "
               + "... USING statement.  This option is only available on "
               + "indexes that have a character field as their last index "
               + "component.!!Do you want this to be an abbreviated index?"

  new_lang[17] = "IF {&PRO_DISPLAY_NAME} finds duplicate values while creating this new "
               + "unique index, it will UNDO the entire transaction, causing "
               + "you to lose any schema changes just made.  Creating an "
               + "inactive index and then building it with ~"proutil -C "
               + "idxbuild~" will eliminate this problem.  Do you want to "
               + "de-activate this index?".

FORM " " SKIP
  WITH FRAME idx_box OVERLAY
  ROW 1 COLUMN 1 SCREEN-LINES - 4 DOWN NO-LABELS NO-ATTR-SPACE
  WIDTH 80 USE-TEXT.
 
FORM
  _Index._Index-name FORMAT "x(32)" LABEL "Name" 
    HELP "Please enter the Index Name"         
  is_prime     FORMAT "PRIMARY"    at col 34 row 1    NO-LABEL   SPACE
  _Index._Unique     FORMAT "UNIQUE/Non-Unique"       NO-LABEL 
    HELP "Please enter U or N for UNIQUE or Non-Unique"          SPACE
  _Index._Active     FORMAT "ACTIVE/Inactive"         NO-LABEL 
    HELP "Please enter A or I for ACTIVE or Inactive"            SPACE 
  word_index         FORMAT "Word/"                   NO-LABEL 
    HELP "Please enter W for WORD index or <BLANK> for standard index" SPACE
  _Index._index-attributes[1]         FORMAT "Local/Global" NO-LABEL 
    HELP "Please enter L for Local index or G for Global index" SPACE  
  recid_idx          FORMAT "ROWID"                   NO-LABEL          SKIP   
    areaname  COLON 5 VIEW-AS SELECTION-LIST INNER-CHARS 32 INNER-LINES 1 NO-LABEL 
    HELP "Please select an area where to store the new index."    
    "Area:"  at col 1 row 3 view-as text size 5 by 1
    cAreaMTText at col 44 row 3 no-label format "x(20)"

  WITH FRAME idx_top OVERLAY ROW 2 COLUMN 2 SIDE-LABELS ATTR-SPACE NO-BOX.

FORM
  _Index._Index-name FORMAT "x(27)" SKIP
  WITH FRAME idx_lst USE-TEXT
  OVERLAY ROW 6 COLUMN 1 NO-LABELS ATTR-SPACE SCREEN-LINES - 11 DOWN SCROLL 1.

FORM
  _Index-field._Index-Seq  FORMAT ">>"       LABEL "Seq"
  _Field._Field-Name       FORMAT "x(21)"    LABEL "Field Name"
  _Field._Data-Type        FORMAT "x(11)"     LABEL "Type"
  _Index-field._Ascending  FORMAT "Asc/Desc" LABEL "Asc"
  _Index-field._Abbreviate FORMAT "Yes/No"   LABEL "Abbr"
  WITH FRAME idx_long OVERLAY USE-TEXT
  ROW 6 COLUMN 32  SCREEN-LINES - 13 DOWN SCROLL 1.

/*
123456789012345678901234567890123456789012345678901234567890123456789012345678

Index: Cust-num________________________  Primary Non-Unique Inactive ROWID
 Area: ________________________________
+----------------------------------++-----------------------------------------+
| idx1                             ||Seq Field Name             Type Asc  Abbr|
| index2                           ||--- ---------------------- ---- ---- ----|
| ix3                              ||  1 1234567890123456789012 Char          |
| index-4                          ||  2                        Date          |
| idx_5                            ||  3                        Logi          |
| ix#6                             ||  4                        Inte          |
| index007                         ||  5                        Deci          |
| 12345678901234567890123456789012 ||  6                        Floa          |
|                                  ||  7                        Reci          |
|                                  ||  8                                      |
|                                  ||  9                                      |
|                                  || 10                                      |
+----------------------------------++-----------------------------------------+
*/


/* LANGUAGE DEPENDENCIES END */ /*-----------------------------------------*/

/*-----------------------------------Triggers------------------------------*/

/*----- LEAVE of INDEX NAME -----*/
ON LEAVE OF _Index._Index-Name IN FRAME idx_top
DO:
  DEFINE VAR rec_id AS RECID NO-UNDO.

  /* See if there's another index with this name. If there is, 
     put up an error.  Otherwise check the new name.
  */
  rec_id = (IF adding THEN ? ELSE RECID(_Index)).
  FIND FIRST bfr_Index OF _File
    WHERE bfr_Index._Index-name = SELF:SCREEN-VALUE
    AND   RECID(bfr_Index) <> rec_id
    NO-ERROR.
  IF AVAILABLE bfr_Index THEN DO:
    MESSAGE new_lang[13] VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    RETURN NO-APPLY.
  END.
  ELSE DO:
    RUN "adecomm/_valname.p" (SELF:SCREEN-VALUE, INPUT no, OUTPUT answer).    
    IF NOT answer THEN RETURN NO-APPLY.
  END.
END.

/*---- VALIDATE area name ----*/
ON LEAVE OF INPUT FRAME idx_top areaname
DO:
 If (_File._File-attributes[1] = FALSE  OR _File._File-attributes[2] = TRUE) AND (isTablePartitioned and _Index._index-attributes[1]:screen-value = "Global") THEN DO:
  DEFINE VARIABLE ans AS LOGICAL INITIAL FALSE NO-UNDO.
   IF user_dbtype = "PROGRESS" AND adding THEN DO:
     IF INPUT FRAME idx_top areaname:SCREEN-VALUE = ? THEN
       ASSIGN indexarea = INPUT FRAME idx_top areaname:ENTRY(1).
     ELSE
       ASSIGN indexarea = INPUT FRAME idx_top areaname:SCREEN-VALUE.
     FIND DICTDB._Area WHERE DICTDB._Area._Area-name = indexarea NO-LOCK.
     IF NOT s_In_Schema_Area THEN DO:
       IF DICTDB._Area._Area-name = "Schema Area" THEN DO:         
         ASSIGN ans = FALSE.
         FIND FIRST DICTDB._Area WHERE DICTDB._Area._Area-number > 6
                                   AND DICTDB._Area._Area-type = 6
                                   no-lock no-error.
         IF AVAILABLE DICTDB._Area THEN DO:
           MESSAGE "Progress Software Corporation does not recommend" SKIP
                   "creating user indices in the Schema Area." SKIP (1)
                   "Should index be created in this area?" SKIP(1)
                   VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO UPDATE ans.
           IF ans THEN DO:
             s_In_Schema_Area = TRUE.
              APPLY "GO" TO areaname IN FRAME idx_top.
             RETURN.
           END.  
           ELSE DO:
             s_In_Schema_Area = FALSE.
             APPLY "ENTRY" TO areaname IN FRAME idx_top.
             RETURN NO-APPLY.
           END.
         END.
         ELSE DO:          
           ASSIGN s_In_Schema_Area = TRUE.
           APPLY "GO" TO areaname IN FRAME idx_top.
           RETURN.
         END.
       END.
    END. /* IF NOT s_In_Schema_Area */
    ELSE DO:
      s_In_Schema_Area = TRUE.
      RETURN.
    END.
  END.
 END. /* end of if _File._File-attributes[1] = FALSE  OR _File._File-attributes[2] = TRUE  */
END.

/*----- Value change of Local/Global index -----*/
ON value-changed OF _Index._index-attributes[1] IN FRAME idx_top
DO:
   if _Index._index-attributes[1]:SCREEN-VALUE = "Global" then
   do:
       enable areaname with frame idx_top.
          /* PSC00288448 and PSC00288469 - removed check condition " if areaname:SCREEN-VALUE = "N/A" " */ 
          run prodict/pro/_pro_area_list(recid(_File),{&INVALID_AREAS},areaname:DELIMITER in frame idx_top, output AreaList).
          ASSIGN areaname:LIST-ITEMS  IN FRAME idx_top = arealist.
          /* PSC00288453 - on value change of index to global, area is selected by default */
          areaname:SCREEN-VALUE IN FRAME idx_top = areaname:ENTRY(1).
/*         apply "entry" to areaname in frame idx_top.*/
          
   end.
   else
   do:
     ASSIGN areaname:LIST-ITEMS  IN FRAME idx_top = "N/A".
      areaname:SCREEN-VALUE IN FRAME idx_top = "N/A".
     disable areaname with frame idx_top.
   end.  
END.


/*============================Mainline code===============================*/

{ prodict/dictgate.i &action=query &dbtype=user_dbtype &dbrec=? &output=c }

FIND _File "_Index".
IF NOT CAN-DO(_Can-read,USERID("DICTDB")) THEN DO:
  MESSAGE new_lang[16] VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  user_path = "".
  RETURN.
END.
 
/* In qbf#list, negative numbers are the negated subscripts */
/* from new_lang[] to display when that option is disabled. */
qbf#list = "1,2,3,4,"
         + (IF INDEX(ENTRY(3,c),"r") = 0                THEN "-11" ELSE
            IF dict_rog                                 THEN "-15" ELSE
            IF NOT CAN-DO(_Can-write ,USERID("DICTDB")) THEN "-17" ELSE "5")
         + "," +
           (IF INDEX(ENTRY(3,c),"a") = 0                THEN "-11" ELSE
            IF dict_rog                                 THEN "-15" ELSE
            IF NOT CAN-DO(_Can-create,USERID("DICTDB")) THEN "-17" ELSE "6")
         + "," +
           (IF INDEX(ENTRY(3,c),"d") = 0                THEN "-11" ELSE
            IF dict_rog                                 THEN "-15" ELSE
            IF NOT CAN-DO(_Can-delete,USERID("DICTDB")) THEN "-17" ELSE "7")
         + "," +
           (IF INDEX(ENTRY(3,c),"s") = 0 THEN "-11" ELSE
            IF dict_rog                                 THEN "-15" ELSE
            IF NOT CAN-DO(_Can-write ,USERID("DICTDB")) THEN "-17" ELSE "8")
         + "," +
           (IF INDEX(ENTRY(3,c),"u") = 0                THEN "-30" ELSE
            IF dict_rog                                 THEN "-15" ELSE
            IF NOT CAN-DO(_Can-write ,USERID("DICTDB")) THEN "-17" ELSE "9")
         + "," +
           (IF user_dbtype <> "PROGRESS"                THEN "-11" ELSE
            IF dict_rog                                 THEN "-15" ELSE
            IF NOT CAN-DO(_Can-write ,USERID("DICTDB")) THEN "-17" ELSE "10")
         + ",11,12,13," +
           (IF INDEX(ENTRY(3,c),"u") = 0                THEN "-35" ELSE
            IF dict_rog                                 THEN "-15" ELSE
            IF NOT CAN-DO(_Can-write ,USERID("DICTDB")) THEN "-17" ELSE "14")
         + ",15,16,17".


FIND _File WHERE RECID(_File) = drec_file.

ASSIGN
  edbtyp       = {adecomm/ds_type.i
                   &direction = "itoe"
                   &from-type = "user_dbtype"
                   }
                   
  new_lang[11] = new_lang[11] + " " + (IF _File._Db-lang > 0
                 THEN "PROGRESS/SQL" ELSE edbtyp)
  new_lang[30] = substitute(new_lang[30],edbtyp)
  qbf_idx_max  = MINIMUM(INTEGER(ENTRY(6,c)),16) /* max index key comps    */
  qbf_idx_deac = INDEX(ENTRY(3,c),"i") > 0  /* deactivate indexes allowed? */
  qbf_idx_nonu = INDEX(ENTRY(3,c),"n") > 0  /* non-unique indexes allowed? */
  qbf_idx_num  = INDEX(ENTRY(3,c),"#") > 0  /* idx-num to be generated?    */
  qbf_idx_uniq = INDEX(ENTRY(3,c),"u") > 0  /* change uniqueness allowed?  */
  qbf_idx_word = INDEX(ENTRY(3,c),"w") > 0. /* supports word indexing      */
 
IF _File._For-type = ? THEN 
DO:

    /* check if this db supports large index keys 
       just care about large_idx really.
    */
    /* dbs running with pre-10.01B servers will have no knowledge of large key entries
       support, so don't need to display message (in which case large_idx = ?)
    */
    /*
       Pass the DICTDB name since that for non-OE schemas, we will know if
       it is turned on of it's on for the schema holder.
    */
    RUN prodict/user/_usrinf3.p 
          (INPUT  LDBNAME("DICTDB"),
           INPUT  "PROGRESS",
           OUTPUT cTemp, 
           OUTPUT cTemp,
           OUTPUT answer,
           OUTPUT large_idx,
	   OUTPUT isMultitenant,
           OUTPUT isPartitioned,
           OUTPUT isCDCEnabled).

END.
Assign isTablePartitioned = _File._File-Attributes[3]. /* Check if table partitioned. */
     
/*IF NOT qbf_idx_uniq THEN ASSIGN qbf[9] = "".*/

IF qbf_idx_word THEN
  FIND FIRST _Field OF _File WHERE _Data-type = "character" NO-LOCK NO-ERROR.
qbf_idx_word = (qbf_idx_word AND AVAILABLE _Field).
RELEASE _Field.

/* OE00135682  - use other delimiter in case area name has comma */
areaname:DELIMITER IN FRAME idx_top = CHR(1).

qbf_block:
DO TRANSACTION ON ERROR UNDO,RETRY:
   
    in_trans = FALSE. /* no changes made yet */
    FIND FIRST _Index WHERE _Index._File-recid = drec_file NO-ERROR.
    PAUSE 0.
    IF NOT RETRY THEN VIEW FRAME idx_box.
    PAUSE 0.
      
    if _file._file-attributes[1] and _file._file-attributes[2] then
    do:
       cAreaMTText:screen-value in frame idx_top  = "(for default tenant)" .
    end.
    else
        cAreaMTText:screen-value in frame idx_top  = "" .
      
    /*  setAreaLabel(areaname:handle in frame idx_top,_file._file-attributes[1]).*/
      /*
      areaname:col = length(areaname:label) + 3.
      areaname:side-label-handle:width  = length(areaname:label) + 1.
      /* shrinking seems to work from left label */
      areaname:side-label-handle:col  = 1.
     */
     VIEW FRAME idx_top.
    
    PAUSE 0.
    VIEW FRAME idx_lst.
    VIEW FRAME idx_long.

    DO WHILE TRUE:
        ASSIGN
    /*      qbf[14] = ( IF CAN-DO("a,u",_Index._I-misc2[1])
                        THEN "ROWID"
                        ELSE ""
                    ) */
            rpos    = RECID(_Index).
        DISPLAY qbf WITH FRAME qbf.

        IF redraw THEN 
        DO:
            ASSIGN areaname:LIST-ITEMS  IN FRAME idx_top = "".
            FIND FIRST _Index OF _File NO-ERROR.
            ASSIGN
                qbf_disp = ?
                qbf_home = RECID(_Index)
                redraw   = FALSE.
            IF rpos <> ? THEN
                FIND _Index WHERE RECID(_Index) = rpos NO-ERROR.
            ASSIGN
                rpos = RECID(_Index)
                j    = (IF FRAME-LINE(idx_lst) = 0 THEN 1 ELSE FRAME-LINE(idx_lst))
                i    = 3.
            UP j - 1 WITH FRAME idx_lst.
            IF j > 1 THEN 
            DO i = 2 TO j WHILE AVAILABLE _Index:
                FIND PREV _Index WHERE _Index._File-recid = drec_file NO-ERROR.
            END.      
      
            IF NOT AVAILABLE _Index THEN 
            DO:
                FIND FIRST _Index OF _File NO-ERROR.
                j = i - 2.
            END.
      
            DO i = 1 TO FRAME-DOWN(idx_lst):
                IF INPUT FRAME idx_lst _Index._Index-name = (IF AVAILABLE _Index THEN _Index._Index-name ELSE "") THEN.
                ELSE IF AVAILABLE _Index THEN 
                DO:
                    DISPLAY _Index._Index-name WITH FRAME idx_lst.
                    IF user_dbtype = "PROGRESS" THEN
                    DO:
                        if (_File._File-attributes[1] = TRUE  AND _File._File-attributes[2] = FALSE) or (_File._File-attributes[3] = TRUE) THEN
                            ASSIGN arealist = ""
                                   areaname = "".  
                        ELSE DO:
                            IF _Index._Idx-num <> ? AND _Index._Idx-num <> 0 THEN 
                            DO:
                               /* first - could have one for each collation */ 
                                FIND first _StorageObject WHERE _StorageObject._Db-recid = _File._Db-recid
                                                            AND _StorageObject._Object-type = 2
                                                            AND _Storageobject._Object-number =  _Index._Idx-num
                                                            AND _Storageobject._Partitionid = 0
                                                            NO-LOCK NO-ERROR.
                                IF AVAILABLE _StorageObject THEN                    
                                    FIND _Area WHERE _Area._Area-number = _StorageObject._Area-number NO-ERROR.
                                ELSE
                                    FIND _Area WHERE _Area._Area-number = 6 NO-LOCK NO-ERROR.  
                            END.
                            ELSE
                                FIND _Area WHERE _Area._Area-number = _Index._ianum NO-LOCK NO-ERROR.
                                IF AVAILABLE _Area THEN  
                                    ASSIGN  arealist = _Area._Area-name.
                                ELSE
                                    ASSIGN arealist = "N/A".  
                            END. /* end of  else loop for _File-attributes[1] = TRUE  AND _File-attributes[2] = FALSE */
                        END.  
                    ELSE
                        ASSIGN arealist = "N/A".
                    ASSIGN areaname:LIST-ITEMS  IN FRAME idx_top = arealist
                           indexarea = areaname:ENTRY(1) IN FRAME idx_top.          
                END.
                ELSE
                    CLEAR FRAME idx_lst NO-PAUSE.

                    COLOR DISPLAY VALUE(IF RECID(_Index) = rpos AND RECID(_Index) <> ? THEN 
                    "MESSAGES" ELSE "NORMAL") _Index._Index-name WITH FRAME idx_lst.
                    DOWN WITH FRAME idx_lst.
                    FIND NEXT _Index OF _File NO-ERROR.
                END.
                FIND _Index WHERE RECID(_Index) = rpos NO-ERROR.
                UP FRAME-DOWN(idx_lst) - j + 1 WITH FRAME idx_lst.
            END.

            IF qbf_was <> FRAME-LINE(idx_lst) THEN 
            DO WITH FRAME idx_lst:
                i = FRAME-LINE.
                DOWN qbf_was - i.
                COLOR DISPLAY NORMAL _Index._Index-name.
                DOWN i - qbf_was.
                COLOR DISPLAY MESSAGES _Index._Index-name.
                qbf_was = FRAME-LINE.
            END.
    
            IF AVAILABLE _Index THEN 
            DO:
                assign
                    recid_idx  = substring(_Index._I-misc2[1],1,1,"character") = "r"
                    recid_idx1 = ( IF _Index._I-misc2[1] <> ?
                                    THEN CAN-DO("a,u,ru,ra,u1,ru1,u2,ru2",_Index._I-misc2[1])
                                    ELSE FALSE
                                 ).
                IF user_dbtype = "PROGRESS" THEN
                DO:
    
                    if (_File._File-attributes[1] = TRUE  AND _File._File-attributes[2] = FALSE) or (isTablePartitioned and _Index._index-attributes[1] = true) THEN
                        ASSIGN arealist = "N/A"
                                areaname = "N/A".  
                    ELSE DO:
                        IF _Index._Idx-num <> ? AND _Index._Idx-num <> 0 THEN 
                        DO:
                            /* first - could have one for each collation  */               
                            FIND first _StorageObject WHERE _StorageObject._Db-recid = _File._Db-recid
                                                        AND _StorageObject._Object-type = 2
                                                        AND _StorageObject._Object-number = _Index._Idx-num
                                                        AND _Storageobject._Partitionid = 0                   
                                                        NO-LOCK.                     
                            FIND _Area WHERE _Area._Area-number = _StorageObject._Area-number NO-LOCK NO-ERROR.
                        END.
                        ELSE
                            FIND _Area WHERE _Area._Area-number = _Index._ianum NO-LOCK NO-ERROR.
              
                        ASSIGN arealist = (IF AVAILABLE _AREA 
                                           THEN _Area._Area-name
                                           ELSE "N/A").
                    END. /* if _File._File-attributes[1] = TRUE  AND _File._File-attributes[2] = FALSE */
                END.  
                ELSE
                    ASSIGN arealist = "N/A".
                  
                ASSIGN areaname:LIST-ITEMS  IN FRAME idx_top = ""
                       areaname:LIST-ITEMS IN FRAME idx_top = arealist
                       indexarea = areaname:ENTRY(1) IN FRAME idx_top.
                
                IF user_dbtype = "PROGRESS" THEN
                DO:
                    FIND first dictdb._StorageObject WHERE dictdb._StorageObject._Db-recid = _File._Db-recid
                                                       AND dictdb._StorageObject._Object-type = 2
                                                       AND dictdb._StorageObject._Object-number = _Index._Idx-num
                                                       AND dictdb._StorageObject._partitionid = 0
                                                       NO-LOCK NO-ERROR.
                    IF AVAILABLE _StorageObject AND (get-bits(_StorageObject._Object-State,1,1) = 1) AND _Index._Active THEN /* Inactive */
                      ASSIGN l_actidx = FALSE.
                    ELSE
                      ASSIGN l_actidx = TRUE.
                END.
                ELSE
                  ASSIGN l_actidx = TRUE.
                    
                DISPLAY
                    _File._Prime-index = RECID(_Index) @ is_prime
                    _Index._Index-name 
                    _Index._Unique 
                    IF l_actidx THEN _Index._Active ELSE l_actidx @ _Index._Active
                    _Index._Wordidx = 1 @ word_index
                    recid_idx
                    areaname
                    WITH FRAME idx_top.
          
                if isTablePartitioned then
                    display _Index._index-attributes[1] with frame idx_top.
     
                DISPLAY _Index._Index-name WITH FRAME idx_lst.
            END.
            ELSE DO:
         
                if (_File._File-attributes[1] = TRUE  AND _File._File-attributes[2] = FALSE) or (_File._File-attributes[3] = TRUE) THEN
                    ASSIGN arealist = ""
                           areaname:LIST-ITEMS  IN FRAME idx_top = ""
                           indexarea = areaname:ENTRY(1) IN FRAME idx_top. 
                else do:
                    FIND FIRST _Area WHERE _Area._Area-number > 6
                                       AND _Area._Area-type = 6 
                                       AND NOT CAN-DO ({&INVALID_AREAS}, _Area._Area-name) NO-ERROR.
                 ASSIGN arealist = (IF AVAILABLE _AREA THEN _Area._Area-name
                                        ELSE "N/A").
                 ASSIGN areaname:LIST-ITEMS  IN FRAME idx_top = "" 
                        areaname:LIST-ITEMS IN FRAME idx_top = arealist
                        indexarea = areaname:ENTRY(1) IN FRAME idx_top.
            END.
        END. /* if redraw */                    

        IF qbf_disp <> RECID(_Index) THEN 
        DO i = 1 TO FRAME-DOWN(idx_long):
            DOWN i - FRAME-LINE(idx_long) WITH FRAME idx_long.
            RELEASE _Index-field.
            IF AVAILABLE _Index THEN
                FIND _Index-field OF _Index WHERE _Index-seq = i NO-ERROR.
            IF AVAILABLE _Index-field and _Index-field._Field-recid > 0  THEN
                FIND _Field OF _Index-field.
            ELSE IF INPUT FRAME idx_long _Field._Field-Name = "" THEN
                LEAVE.
            IF AVAILABLE _Index-field THEN
                DISPLAY
                    (IF LENGTH(_Field._Field-Name,"character") > 18
                     THEN SUBSTRING(_Field._Field-Name,1,18,"character") + "..."
                     ELSE _Field._Field-Name) @ _Field._Field-Name
                    _Index-field._Index-Seq _Field._Data-Type
                    _Index-field._Ascending _Index-field._Abbreviate
                    WITH FRAME idx_long.
            ELSE
                CLEAR FRAME idx_long NO-PAUSE.
        END.
        qbf_disp = RECID(_Index).
    
        IF large_idx = NO THEN 
        DO:
            /* display message about large key entries support */
            HIDE MESSAGE NO-PAUSE.
            MESSAGE new_lang[38].
        END.
       
        ON CURSOR-LEFT BACK-TAB.
        ON CURSOR-RIGHT     TAB.
    
        _choose:
        DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
            IF qbf# > 16 THEN qbf# = qbf# - 16.
            IF qbf# >= 1 AND qbf# <= 16 THEN
                NEXT-PROMPT qbf[qbf#] WITH FRAME qbf.
            CHOOSE FIELD qbf PAUSE (IF qbf_disp = RECID(_Index) THEN ? ELSE 0)
                NO-ERROR AUTO-RETURN GO-ON ("CURSOR-UP" "CURSOR-DOWN") WITH FRAME qbf.
            qbf# = FRAME-INDEX.
            IF KEYFUNCTION(LASTKEY) = CHR(LASTKEY) AND CHR(LASTKEY) <> "."
            AND NOT qbf[qbf#] BEGINS CHR(LASTKEY) THEN 
                UNDO,RETRY _choose.
        END.
        ON CURSOR-LEFT  CURSOR-LEFT.
        ON CURSOR-RIGHT CURSOR-RIGHT.
    
        i = LOOKUP(KEYFUNCTION(LASTKEY),
                  "CURSOR-DOWN,CURSOR-UP,HOME,END,,,,,,,GET,PUT,,,,,END-ERROR").
     
        IF i > 0 THEN DO:
            COLOR DISPLAY NORMAL qbf[qbf#] WITH FRAME qbf. 
            qbf# = i.
        END.
        IF CAN-DO("HOME,MOVE",KEYFUNCTION(LASTKEY)) THEN
            qbf# = (IF rpos = qbf_home THEN 4 ELSE 3).

        HIDE MESSAGE NO-PAUSE.
        
        IF large_idx = NO THEN
            MESSAGE new_lang[38].
        IF ENTRY(qbf#,qbf#list) BEGINS "-" THEN 
        DO:   
            MESSAGE new_lang[- INTEGER(ENTRY(qbf#,qbf#list))].
            IF _File._Db-lang = 0 THEN .
            ELSE IF qbf# = 6 THEN MESSAGE new_lang[24]. /* use CREATE INDEX */
            ELSE IF qbf# = 7 THEN MESSAGE new_lang[25]. /* use DROP INDEX */
            ELSE IF qbf# >= 5 AND qbf# <= 10 THEN MESSAGE new_lang[37].
            NEXT.
        END.

        IF qbf# > 2 THEN redraw = TRUE.

        IF qbf# = 1 THEN 
        DO: /*------------------------------ start of NEXT */
            FIND NEXT _Index WHERE _Index._File-recid = drec_file NO-ERROR.
            IF NOT AVAILABLE _Index THEN DO:
                FIND LAST _Index WHERE _Index._File-recid = drec_file NO-ERROR.
             MESSAGE new_lang[9].
        END.
        ELSE DO WITH FRAME idx_lst:
            IF FRAME-LINE = FRAME-DOWN THEN qbf_was = qbf_was - 1.
            IF FRAME-LINE = FRAME-DOWN THEN SCROLL UP. ELSE DOWN.
        END.
    END. /*------------------------------------------------ end of NEXT */
    ELSE IF qbf# = 2 THEN DO: /*------------------------------ start of PREV */
        FIND PREV _Index WHERE _Index._File-recid = drec_file NO-ERROR.
        IF NOT AVAILABLE _Index THEN 
        DO:
            FIND FIRST _Index WHERE _Index._File-recid = drec_file NO-ERROR.
            MESSAGE new_lang[10].
        END.
        ELSE DO WITH FRAME idx_lst:
            IF FRAME-LINE = 1 THEN qbf_was = qbf_was + 1.
            IF FRAME-LINE = 1 THEN SCROLL DOWN. ELSE UP.
        END.
    END. /*------------------------------------------------ end of PREV */
    ELSE IF qbf# = 3 THEN DO: /*----------------------------- start of FIRST */
        FIND FIRST _Index WHERE _Index._File-recid = drec_file NO-ERROR.
        UP FRAME-LINE(idx_lst) - 1 WITH FRAME idx_lst.
        MESSAGE new_lang[10].
    END. /*----------------------------------------------- end of FIRST */
    ELSE
    IF qbf# = 4 THEN DO: /*------------------------------ start of LAST */
        FIND LAST _Index WHERE _Index._File-recid = drec_file NO-ERROR.
        DOWN FRAME-DOWN(idx_lst) - FRAME-LINE(idx_lst) WITH FRAME idx_lst.
        MESSAGE new_lang[9].
    END. /*------------------------------------------------ end of LAST */
    ELSE
    IF qbf# = 5 AND rpos <> ? THEN _qbf5: DO: /*------- start of RENAME */
        IF _File._Frozen THEN 
            MESSAGE new_lang[27].
        ELSE IF _Index._Index-name = "default" THEN 
        DO:
            MESSAGE new_lang[7].
            MESSAGE new_lang[8].
        END.
        ELSE IF _File._Db-lang > 1 THEN 
        DO: 
            MESSAGE new_lang[37].
            LEAVE _qbf5.
        END.
        ELSE 
        DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
            adding = false.
            MESSAGE new_lang[12].
            PROMPT-FOR _Index._Index-name WITH FRAME idx_top.
            user_env[1] = INPUT FRAME idx_top _Index._Index-name.
            ASSIGN
                _Index._Index-name = user_env[1]
            in_trans = TRUE.
            DOWN FRAME-DOWN(idx_lst) - FRAME-LINE(idx_lst) WITH FRAME idx_lst.
        END.
    END. /*---------------------------------------------- end of RENAME */
    ELSE IF qbf# = 6 THEN _qbf6: DO ON ERROR UNDO,LEAVE: /*---- start of ADD */
        IF _File._Frozen THEN 
        DO:
            MESSAGE new_lang[27]. /* table is frozen */
                LEAVE _qbf6.
        END.
        ELSE IF _File._Db-lang > 1 THEN DO: 
            MESSAGE new_lang[37].
            LEAVE _qbf6.
        END.
        /* are there any fields */
        FIND FIRST _Field OF _File WHERE _Extent = 0 NO-ERROR.
        IF NOT AVAILABLE _Field THEN 
        DO:
            MESSAGE new_lang[18]. /* no non-array fields available */
            LEAVE _qbf6.
        END. 
        ASSIGN areaname:LIST-ITEMS IN FRAME idx_top = ""
              arealist = ?.

        if (_File._File-attributes[1] = TRUE  AND _File._File-attributes[2] = FALSE) or (_File._File-attributes[3] = TRUE) THEN
               ASSIGN arealist = ""
                      indexarea = "".  
        else
            run prodict/pro/_pro_area_list(recid(_File),{&INVALID_AREAS},areaname:DELIMITER in frame idx_top, output arealist).

        if isTablePartitioned then
            ASSIGN areaname:LIST-ITEMS IN FRAME idx_top = "N/A".
        else 
            ASSIGN areaname:LIST-ITEMS IN FRAME idx_top = arealist.

        DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
            adding = TRUE.
            COLOR DISPLAY NORMAL _Index._Index-name WITH FRAME idx_lst.
            DISPLAY
                  ""               @ _Index._Index-name
                  ""               @ is_prime
                  NOT qbf_idx_nonu @ _Index._Unique
                  TRUE             @ _Index._Active
                  true             @ _Index._index-attributes[1]
                  FALSE            @ word_index
                  areaname
                  WITH FRAME idx_top.
          
            if isTablePartitioned then 
                assign _Index._index-attributes[1]:hidden= false. 
            else
                assign _Index._index-attributes[1]:hidden = true.
                       
            PF-BLK:
            DO WHILE TRUE:
            /*        PROMPT-FOR*/
                Enable
                  _Index._Index-name
                  _Index._Unique    WHEN (qbf_idx_uniq AND qbf_idx_nonu)
                                    OR   user_dbtype = "PROGRESS"
                  _Index._Active    WHEN qbf_idx_deac
                  word_index             WHEN qbf_idx_word
                  _Index._index-attributes[1] when isTablePartitioned
                  areaname          WHEN user_dbtype = "PROGRESS" and (_File._File-attributes[1] = false or _File._File-attributes[2] = TRUE)  
                  WITH FRAME idx_top.
                 wait-for go of frame idx_top.
         
                /* IF On-Line and index Active */
                IF SESSION:SCHEMA-CHANGE <> "" 
                AND SESSION:SCHEMA-CHANGE <> ?  
                AND INPUT FRAME idx_top _Index._Active THEN 
                DO:
                    MESSAGE 
                        "The Data Dictionary has detected that you are attempting to" SKIP
                        "add an ACTIVE index while ON-LINE.  If some other user is"   SKIP
                        "locking the table you are attempting to update, when you"    SKIP
                        "commit, your changes may be lost."                        SKIP(1)
                        "Do you wish to continue?"
                    VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO-CANCEL 
                                    TITLE "ON-LINE Index Add" UPDATE lOk.
                    IF (lOk = FALSE) THEN NEXT PF-BLK.
                    ELSE IF (lOk = TRUE) THEN LEAVE PF-BLK.
                    ELSE RETURN. 
                END.
                ELSE LEAVE PF-BLK.
            END.
        
            ASSIGN indexarea = areaname:SCREEN-VALUE IN FRAME idx_top.
            IF indexarea = ? THEN
                ASSIGN indexarea =  areaname:ENTRY(1) IN FRAME idx_top.
            IF NOT s_In_Schema_Area THEN
                APPLY "LEAVE" to areaname IN FRAME idx_top.
 
	        if isTablePartitioned then
                disable areaname with frame idx_top.
         
        END.
        IF KEYFUNCTION(LASTKEY) = "END-ERROR" THEN 
            LEAVE _qbf6.
        ASSIGN
            user_env[1] = INPUT FRAME idx_top _Index._Index-name
            user_env[2] = (IF INPUT FRAME idx_top _Index._Unique AND
                          NOT INPUT FRAME idx_top word_index     THEN "u" ELSE "")
                        + (IF INPUT FRAME idx_top _Index._Active THEN ""  ELSE "i")
                        + (IF INPUT FRAME idx_top word_index     THEN "w" ELSE "")
                        + (IF INPUT FRAME idx_top _Index._index-attributes[1]   THEN "l" ELSE "g")
            user_env[3] = "".

        if _File._File-attributes[1] = true 
        and _File._File-attributes[2] = FALSE THEN /* if no keep default area then assign ianum to 0 */
            ASSIGN index-area-number = 0
                   indexarea = "".
        else 
        do:
            IF indexarea <> "N/A"  THEN 
            DO:
                FIND _Area WHERE _Area._Area-name = indexarea.
                ASSIGN index-area-number = _Area._Area-number.
            END.
            ELSE
                ASSIGN index-area-number = 6.
        END. /* end of if _File._File-attributes[2] = FALSE  */
      
        RUN "prodict/user/_usriadd.p".  /* get index key components */
        IF user_env[1] = "" THEN LEAVE _qbf6.

        /* maybe ask about abbreviate if not word index */
        IF NOT user_env[2] MATCHES "*w*" THEN 
        DO:
            DO i = 4 TO 18: /* 1 less than 19 */
              IF user_env[i + 1] = "" THEN LEAVE.
            END.
            FIND _Field OF _File WHERE _Field._Field-name = ENTRY(1,user_env[i]).
            IF _Data-type = "character" THEN 
            DO:
                answer = FALSE.
                RUN "prodict/user/_usrdbox.p"
                      (INPUT-OUTPUT answer,?,?,new_lang[14]). /* abbr index? */
                IF KEYFUNCTION(LASTKEY) = "END-ERROR" THEN LEAVE _qbf6.
                IF answer THEN user_env[i] = user_env[i] + "a".
            END.
        END.
        IF qbf_idx_deac AND user_env[2] MATCHES "*u*"
        AND NOT user_env[2] MATCHES "*i*" THEN
        DO:
            /* make new unique index inactive */
            answer = FALSE.
            RUN "prodict/user/_usrdbox.p"
              (INPUT-OUTPUT answer,?,?,new_lang[17]).
            IF KEYFUNCTION(LASTKEY) = "END-ERROR" THEN LEAVE _qbf6.
            IF answer THEN DO:
              user_env[2] = user_env[2] + "i".
              DISPLAY FALSE @ _Index._Active WITH FRAME idx_top.
            END.
        END.

        /* add index */
          /* input: user_env[1] = index-name to add to file in '_File'
              user_env[2] MATCHES "*p*" for primary-index
              user_env[2] MATCHES "*i*" for deactivated index
              user_env[2] MATCHES "*u*" for unique index
              user_env[2] MATCHES "*w*" for word index
              user_env[4..19] index components 1..16
                these are formatted as follows:
                ENTRY(1,user_env[x]) = field-name
                ENTRY(2,user_env[x]) MATCHES "*+*" for ascending (the default)
                ENTRY(2,user_env[x]) MATCHES "*-*" for descending
                ENTRY(2,user_env[x]) MATCHES "*a*" for abbreviated (pro only)
                ENTRY(2,user_env[x]) MATCHES "*u*" for unsorted (not for pro)
          */
     
        CREATE _Index.
        ASSIGN
            _Index._File-recid = RECID(_File)
            _Index._Idx-num    = ?
            _Index._ianum      = if (isTablePartitioned and _Index._index-attributes[1]:screen-value = "Local") then 0 else index-area-number
            _Index._Index-name = user_env[1]
            _Index._Unique     = user_env[2] MATCHES "*u*"
            _Index._Wordidx    = (IF user_env[2] MATCHES "*w*" THEN 1 ELSE ?)
            _Index._Active     = NOT user_env[2] MATCHES "*i*".


        if _Index._index-attributes[1]:screen-value = "Local" and isTablePartitioned then
            assign _Index._index-attributes[1] = true. 
	 
        DO i = 1 TO 16:
            c = user_env[i + 3].
            IF c = "" THEN LEAVE.
            FIND _Field OF _File WHERE _Field-name = ENTRY(1,c).
            CREATE _Index-field.  
 
            ASSIGN
              c = ENTRY(2,c)
              _Index-field._Field-recid = RECID(_Field)
              _Index-field._Abbreviate  = c MATCHES "*a*"
              _Index-field._Index-recid = RECID(_Index)              
              _Index-field._Index-Seq   = i
              _Index-field._Ascending   = NOT (c MATCHES "*-*").
	 
        END.
        /* some DataServers don't initialize the _Index._idx-num - field */
        /* (see <DS>/_<DS>_sys.p), so we call the intialization routine */
        if qbf_idx_num then 
            RUN "prodict/gate/_gatxnum.p" 
               (INPUT  RECID(_File),
                OUTPUT _Index._idx-num).

        rpos = RECID(_Index).
      /* delete default index (there is one if _dft-pk is true) 
               and replace with this one unless this is a word index. */
        IF _File._dft-pk AND _Index._Wordidx <> 1 THEN
        DO:
            ASSIGN
                r                  = _File._Prime-Index
                _File._Prime-Index = RECID(_Index) /* this block will delete the */
                _File._dft-pk      = FALSE.        /* default index if there one */
            FIND _Index WHERE RECID(_Index) = r.
            FOR EACH _Index-field WHERE _Index-field._Index-recid = RECID(_index):
                delete _Index-field.
            END.  
            DELETE _Index.
        END.
         /* If there is no primary index, or this is new primary index,
            make this new one it */
        IF _File._Prime-Index = ? OR user_env[2] MATCHES "*p*" THEN
            _File._Prime-Index = rpos.

        in_trans = TRUE.
        IF RECID(_Index) <> rpos THEN 
        DO:        /* in case we looked up default idx */  
            FIND _Index OF _File WHERE _Index._Index-name = user_env[1] NO-ERROR.
            DOWN FRAME-DOWN(idx_lst) - FRAME-LINE(idx_lst) WITH FRAME idx_lst.
        END.
    END. /*------------------------------------------------- end of ADD */
    ELSE
    IF qbf# = 7 AND rpos <> ? THEN 
    DO: /*-------------- start of DELETE */
        IF _File._Frozen THEN 
            MESSAGE new_lang[27]. /* table is frozen */
        ELSE IF _File._Prime-Index = RECID(_Index) THEN 
        DO:
            MESSAGE new_lang[3]  . /* cannot delete primary index */
            MESSAGE new_lang[4]  . /* try again */
        END.
        ELSE IF _File._Db-lang > 1 THEN  
            MESSAGE new_lang[37].

        ELSE DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
            answer = FALSE. /* are you sure... delete? */
            RUN "prodict/user/_usrdbox.p"
              (INPUT-OUTPUT answer,?,?,new_lang[5]).
            IF answer THEN 
            DO:
                FOR EACH _Index-field OF _Index:
                    DELETE _Index-field.
                END.
                DELETE _Index.
                in_trans = TRUE.
            END.
        END.
    END. /*---------------------------------------------- end of DELETE */
    ELSE
    IF qbf# = 8 AND rpos <> ? THEN 
    DO: /*------ start of CHANGE-PRIMARY */
        IF _File._Frozen THEN 
            MESSAGE new_lang[27]. /* table is frozen */
        ELSE IF _File._Db-lang > 1 THEN  
            MESSAGE new_lang[37].
        ELSE IF _Index._Wordidx = 1 THEN
            MESSAGE new_lang[26].  
        ELSE IF _File._Prime-Index = RECID(_Index) THEN
            MESSAGE new_lang[1]. /* already primary index */
        ELSE DO:
            answer = FALSE.   /* are you sure... set prime? */
            RUN "prodict/user/_usrdbox.p"
                (INPUT-OUTPUT answer,?,?,new_lang[2]).
            IF answer THEN
                ASSIGN
                    _File._Prime-Index = RECID(_Index)
                    in_trans = TRUE.
        END.
    END. /*-------------------------------------- end of CHANGE-PRIMARY */
    ELSE IF qbf# = 9 AND rpos <> ? THEN DO: /*---------- start of UNIQUENESS */
        IF _File._Frozen THEN 
            MESSAGE new_lang[27]. /* table is frozen */
        ELSE IF _File._Db-lang > 1 THEN  
            MESSAGE new_lang[37].
        ELSE IF _Index._Wordidx = 1 THEN
            MESSAGE new_lang[28].  /* word index can't be unique */
        ELSE IF NOT qbf_idx_uniq THEN 
            /* doesn't support uniquness-changes. */
            MESSAGE  new_lang[30] . 
         
        ELSE DO:
            ASSIGN
                answer  = FALSE   /* are you sure... set prime? */
                scratch = SUBSTITUTE(new_lang[29],
                            STRING(_Index._Unique,"NON UNIQUE/UNIQUE")).
            RUN "prodict/user/_usrdbox.p"
                (INPUT-OUTPUT answer,?,?,scratch).
            IF answer THEN
                ASSIGN
                    in_trans = TRUE
                    _Index._Unique = (NOT _Index._Unique).
        END.
    END. /*------------------------------------------ end of UNIQUENESS */
    ELSE IF qbf# = 10 AND rpos <> ? THEN DO: /*------ start of MAKE-INACTIVE */
        
        /* we will allow some of the indexes on the _aud-audit-data tables to be
           deactivated. The primary index and the _audit-time index cannot be
           deactivated.
         */  

        IF (_File._file-name BEGINS "_aud-audit-data") 
        AND (_Index._Index-Name NE "_audit-time") 
        AND (NOT (_File._Prime-Index = RECID(_Index))) THEN
            ASSIGN canAudDeact = YES.
        ELSE
            ASSIGN canAudDeact = NO.

        IF _File._Frozen AND NOT canAudDeact THEN 
        DO:
	   IF _Index._Index-Name = "_Identifying-Fields" THEN
	   DO:
	      IF NOT _Index._Active THEN
                 MESSAGE new_lang[20]. /* already off */
	      ELSE
	      DO:
	         answer = FALSE. /* are you sure... make inactive? */
                 RUN "prodict/user/_usrdbox.p"
                   (INPUT-OUTPUT answer,?,?,new_lang[21] + ' "'
                    + _Index._Index-name + '" ' + new_lang[22]).
                 IF answer THEN 
                    _Index._Active = FALSE.
                 in_trans = in_trans OR answer. 
               END.
	   END.
	   ELSE
              MESSAGE new_lang[27]. /* table is frozen */
        END.
        ELSE IF _File._Db-lang > 1 THEN  
            MESSAGE new_lang[37].
          
        ELSE IF NOT qbf_idx_deac THEN
            MESSAGE new_lang[19]. /* not PROGRESS db */
        ELSE IF (NOT _Index._Active OR NOT l_actidx) THEN
            MESSAGE new_lang[20]. /* already off */
        ELSE DO:
            answer = FALSE. /* are you sure... make inactive? */
            RUN "prodict/user/_usrdbox.p"
            (INPUT-OUTPUT answer,?,?,new_lang[21] + ' "'
              + _Index._Index-name + '" ' + new_lang[22]).
            IF answer THEN 
                _Index._Active = FALSE.
            in_trans = in_trans OR answer.
        END.
    END. /*--------------------------------------- end of MAKE-INACTIVE */
    ELSE IF qbf# = 11 AND rpos <> ? THEN DO: /*------------- start of BROWSE */
        HIDE FRAME qbf NO-PAUSE.
        COLOR DISPLAY NORMAL _Index._Index-name WITH FRAME idx_lst.
        user_env[1] = _Index._Index-name.
        RUN "prodict/user/_usribro.p".
        COLOR DISPLAY MESSAGES _Index._Index-name WITH FRAME idx_lst.
        VIEW FRAME qbf.
        IF KEYFUNCTION(LASTKEY) = "GET" THEN 
        DO:
            user_path = "1=,_usrtget,_usrichg".
            LEAVE qbf_block.
        END.
    END. /*---------------------------------------------- end of BROWSE */
    ELSE IF qbf# = 12 THEN 
    DO: /*---------------------- start of SWITCH-FILE */
        user_path = "1=,_usrtget,_usrichg".
        LEAVE qbf_block.
    END. /*----------------------------------------- end of SWITCH-FILE */
    ELSE IF qbf# = 13 THEN 
    DO: /*------------------------ start of GO-FIELDS */
        user_path = "_usrfchg".
        LEAVE qbf_block.
    END. /*------------------------------------------- end of GO-FIELDS */
    ELSE IF qbf# = 14 AND rpos <> ? THEN 
    DO: /*-------------- start of ROWID */
        IF _Index._I-misc2[1] BEGINS "r" THEN NEXT.  /* already recid-idx */
        IF _Index._I-misc2[1] = ? THEN 
            MESSAGE new_lang[36]. /* can't be used for ROWID support */
        ELSE IF _File._Frozen THEN 
            MESSAGE new_lang[27]. /* table is frozen */
        ELSE DO:
            FIND FIRST _File of _Index.
            assign
                l_ifldcnt = 0
                scratch   = ""
                warnflg   = "nnn".
          
            for each _Index-field of _Index, _Field of _Index-field:
                l_ifldcnt = l_ifldcnt + 1.  /* count index fields */
          
                IF    _Index._I-misc2[1]    = "u"
                AND _Index._Unique        = TRUE
                AND _Field._Mandatory     = TRUE
                AND SUBSTR(warnflg, 1, 1) = "n"  /* hasn't already been set by previous index field */ THEN 
                    ASSIGN
                        scratch = scratch + new_lang[31] + chr(10)
                        SUBSTR(warnflg, 1, 1) = "ynn".
        
                IF _Index._Unique = FALSE
                AND SUBSTR(warnflg, 2, 1) = "n"  /* hasn't already been set by previous index field */ THEN 
                    ASSIGN
                        scratch = scratch + new_lang[32] + chr(10)
                        SUBSTR(warnflg, 2, 1) = "y".

                IF _Field._Mandatory = FALSE AND SUBSTR(warnflg, 3, 1) = "n"  /* hasn't already been set by previous index field */ THEN
                    ASSIGN
                        scratch = scratch + new_lang[33] + chr(10)
                        SUBSTR(warnflg, 3, 1) = "y".
            end.  /* for each */        

            assign
                scratch = scratch + new_lang[34].

            RUN "prodict/user/_usrdbox.p"
                (INPUT-OUTPUT answer,?,?,scratch).
            IF answer THEN 
            DO:  /* set this index to be the recid-index */
                FIND FIRST bfr_Index of _File
                    WHERE bfr_Index._I-misc2[1] begins "r"
                    EXCLUSIVE-LOCK NO-ERROR.
            
                IF user_dbtype = "ORACLE" THEN 
                    ASSIGN
                        in_trans            = TRUE
                        _Index._I-misc2[1]  = "r" + _Index._I-misc2[1]
                        _File._Fil-misc1[4] = _Field._Fld-stoff.

                ELSE IF l_ifldcnt > 1 OR _Field._For-type <> "INTEGER" THEN 
                    ASSIGN   /*----- ODBC -----*/
                        in_trans            = TRUE
                        _Index._I-misc2[1]  = "r" + _Index._I-misc2[1]
                        _File._Fil-misc1[2] = _Index._idx-num  /* rowid info */
                        _File._Fil-misc1[1] = ?                /* recid      */
                        _File._Fil-misc2[3] = ?.               /* info       */
                        
                ELSE 
                    ASSIGN
                        _Index._I-misc2[1]  = "r" + _Index._I-misc2[1]
                        _File._Fil-misc1[1] = _Field._Fld-stoff * -1          /* rowid info */
                        _File._Fil-misc2[3] = ( IF _Field._Fld-misc2[3] <> ?  /* recid      */
                                                  THEN _Field._Fld-misc2[3]   /* info       */
                                                  ELSE _Field._For-name
                                              ).
                IF AVAILABLE bfr_Index then 
                    assign
                        bfr_Index._I-misc2[1] = substring(bfr_Index._I-misc2[1]
                                             ,2
                                             ,-1
                                             ,"character"
                                             ).
          
            END.     /* set this index to be the recid-index */
        END.
    END. /*----------------------------------------------- end of ROWID */
    ELSE IF qbf# = 15 THEN DO: /*----------------------------- start of UNDO */
        IF in_trans THEN 
        DO:
            answer = FALSE. /* undo session? */
            RUN "prodict/user/_usrdbox.p"
                  (INPUT-OUTPUT answer,?,?,new_lang[6]).
            IF answer THEN UNDO qbf_block,RETRY qbf_block.
        END.
        ELSE
            MESSAGE new_lang[23]. /* what changes? */
    END. /*------------------------------------------------ end of UNDO */
    else IF qbf# = 16 THEN DO: /*----------------------------- start of ChangeLocal */
       IF user_dbtype = "PROGRESS" THEN
       do:
            if isTablePartitioned then
            do:
               if _Index._index-attributes[1] then
                    MESSAGE "Selected index is already a local index.".
               else
               do: 
                   answer = FALSE. 
                   RUN "prodict/user/_usrdbox.p"
                      (INPUT-OUTPUT answer,?,?,new_lang[21] + " Local?").
                   IF answer THEN 
                   DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
                      in_trans =  true.
                      assign _Index._index-attributes[1]:SCREEN-VALUE = "Local"
                             _Index._index-attributes[1] =   true.
                   end.
               end. /* DO ON ERROR UNDO */
            end. /* if isTablePartitioned then */   
            else
                MESSAGE "Selected table does not support Local/Global index.".
       end.      
       ELSE 
           MESSAGE new_lang[39]. /* dataserver does not support.. */  
           
    END. /*----------------------------------------------------- end of ChangeLocal */
    ELSE
    IF qbf# = 17 THEN /*--------------------------------- start of EXIT */
      LEAVE qbf_block.
  END. /* iterating block */
END. /* scoping block */

HIDE FRAME qbf      NO-PAUSE.
HIDE FRAME idx_box  NO-PAUSE.
HIDE FRAME idx_long NO-PAUSE.
HIDE FRAME idx_lst  NO-PAUSE.
HIDE FRAME idx_top  NO-PAUSE.
dict_dirty = dict_dirty OR in_trans.
RETURN.
