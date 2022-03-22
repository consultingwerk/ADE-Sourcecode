/**********************************************************************
* Copyright (C) 2000-2011,2013,2016,2020 by Progress Software Corporation. *
* All rights reserved.  Prior versions of this work may contain portions  *
* contributed by participants of Possenet.                            *
*                                                                     *
**********************************************************************/

/* _usrtchg.p 

   History:  D. McMann 01/14/98 Added check for ORACLE and AS400 to stop user
                                from trying to create a table
             D. McMann 02/09/98 Added character variable for original area
                                so N/A can be displayed for DataServers.
             D. McMann 03/18/98 98-03-16-022 Changed assignment to file-area-number
                                instead of workfile. 
             D. McMann 04/20/98 98-04-20-030 changed how area name is found. 
             D. McMann 07/09/98 Added AND (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN")
                                to FIND _File.
             Mario B   12/28/98 Add s_In_Schema_Area enabling one time notification 
             D. McMann 05/15/00 Removed warning if only Schema Area in DB.
             D. McMann 08/16/00 Added _db-recid to StorageObject find 20000815029
             D. McMann 10/17/03 Add NO-LOCK statement to _Db find in support of on-line schema add
             fernando  06/15/06 Expanding Dump-name to 32 characters
             fernando  09/27/06 Use a different delimiter for areaname - 20051228-008
             fernando  10/03/07 Fixed delimiter issue on area name list - OE00135682
             fernando  06/26/08 Filter out schema tables for encryption
             hdaniels  06/27/10 Multi-tenant support
             rkamboj   10/11/11 Fixed tab issue for area field during update for non-MT database.
             tmasood   10/23/20 Added table default area support 
*/

&IF "{&WINDOW-SYSTEM}" = "TTY" &THEN

/*---------------------------------------------------------------------
   Input: 
      user_env[1] = The name of the file to modify.  If "" then we're
                                 adding.
---------------------------------------------------------------------*/

{ prodict/dictvar.i }
{ prodict/user/uservar.i }
{ prodict/user/userhue.i }
{ prodict/user/userhdr.f }
{ prodict/dump/loaddefs.i NEW }
/*defines setAreaState */
{ prodict/pro/arealabel.i }
DEFINE VARIABLE adding             AS LOGICAL                      NO-UNDO.
DEFINE VARIABLE c             AS CHARACTER              NO-UNDO.
DEFINE VARIABLE capabs       AS LOGICAL   EXTENT    5 NO-UNDO.
    /* 1 add                 */
    /* 2 chg_foreign_name    */
    /* 3 rename              */
    /* 4 chg_foreign_size    */
    /* 5 chg_foreign_type    */
 

DEFINE VARIABLE dbkey           AS RECID                 NO-UNDO.
DEFINE VARIABLE do-get          AS CHARACTER             NO-UNDO.
DEFINE VARIABLE ftyp            AS CHARACTER             NO-UNDO.
DEFINE VARIABLE get-hit         AS LOGICAL INITIAL FALSE NO-UNDO.
DEFINE VARIABLE go_field        AS LOGICAL INITIAL FALSE NO-UNDO.
DEFINE VARIABLE go-key          AS INTEGER               NO-UNDO.
DEFINE VARIABLE hiding          AS LOGICAL               NO-UNDO.
DEFINE VARIABLE i               AS INTEGER               NO-UNDO.
DEFINE VARIABLE isbad           AS LOGICAL               NO-UNDO.
DEFINE VARIABLE j               AS INTEGER               NO-UNDO.
DEFINE VARIABLE newnam          AS LOGICAL               NO-UNDO.
DEFINE VARIABLE override        AS LOGICAL   EXTENT    7 NO-UNDO.
DEFINE VARIABLE pname           AS CHARACTER EXTENT    7 NO-UNDO.
DEFINE VARIABLE crc             AS LOGICAL   EXTENT    7 NO-UNDO.
DEFINE VARIABLE romode          AS INTEGER               NO-UNDO.
DEFINE VARIABLE stdmsg          AS CHARACTER INITIAL  "" NO-UNDO.
DEFINE VARIABLE touched         AS LOGICAL INITIAL FALSE NO-UNDO.
DEFINE VARIABLE old_crc_val     AS INTEGER   EXTENT    7 NO-UNDO.
DEFINE VARIABLE new_crc_val     AS INTEGER   EXTENT    7 NO-UNDO.
DEFINE VARIABLE check_syntax    AS LOGICAL   INITIAL yes NO-UNDO.
DEFINE VARIABLE fldeditor       AS LOGICAL               NO-UNDO.
DEFINE VARIABLE odbtyp          AS CHARACTER             NO-UNDO.
DEFINE VARIABLE filearea        AS CHARACTER             NO-UNDO.
DEFINE VARIABLE filearealog     AS CHARACTER             NO-UNDO.
DEFINE VARIABLE CDCenabled      AS LOGICAL   INITIAL NO  NO-UNDO.
DEFINE VARIABLE cSkipArea       AS CHARACTER INITIAL ""  NO-UNDO.

DEFINE VARIABLE arealist                   AS CHARACTER INITIAL ?   NO-UNDO.
DEFINE VARIABLE areaname                   AS CHARACTER             NO-UNDO.
define variable multitenantdb              as logical               no-undo.
define variable isPartitionEnabled         as logical no-undo.
define variable canEnablePartitionOptions  as logical no-undo.
define variable isType2                    as logical no-undo.
define variable fldIsType2                    as logical no-undo.
define variable idxIsType2                    as logical no-undo.
DEFINE VARIABLE events   AS CHARACTER EXTENT    7 NO-UNDO 
   init ["Create","Delete","Find","Write",
         "Replication-Create","Replication-Delete","Replication-Write"].

DEFINE BUTTON button-f LABEL "&Triggers...".
DEFINE BUTTON button-v LABEL "&Validation...".
DEFINE BUTTON button-s LABEL "&String Attributes...".
DEFINE BUTTON button-d LABEL "&DS...".
DEFINE BUTTON btn_flds LABEL "Field Editor" AUTO-GO. 

IF FALSE THEN FIND FIRST _Db NO-LOCK.

{ prodict/user/user-d.i }  /* description frame, triggers and procedures */
{ prodict/user/user-v.i }  /* validation frame, triggers and procedures */
{ prodict/user/user-f.i }  /* trigger frame, triggers and procedures */
{ prodict/user/user-s.i }  /* string attribute frame and procedures */

FORM
  c FORMAT "x(78)" 
  WITH FRAME box-shadow
  /* need scrollable to compile cleanly on gui - though it's not run there */
  NO-ATTR-SPACE NO-LABELS OVERLAY SCROLLABLE 
  ROW 1 COLUMN 1 16 DOWN.

ASSIGN
  do-get = "(press [" + KBLABEL("PUT") + "] to edit trigger program)"
  do-get = FILL(" ",45 - LENGTH(do-get)) + do-get
  go-key= KEYCODE(KBLABEL("GO")).

/* get all the capabilities for the current data-server-type */
{ prodict/dictgate.i &action=query &dbtype=user_dbtype &dbrec=? &output=c }
assign
  capabs[1] = INDEX(ENTRY(2,c),"a") > 0
  capabs[2] = INDEX(ENTRY(2,c),"f") > 0
  capabs[3] = INDEX(ENTRY(2,c),"r") > 0
  capabs[4] = INDEX(ENTRY(2,c),"s") > 0
  capabs[5] = INDEX(ENTRY(2,c),"t") > 0.
  

/*--------------------------------------------------------------------------*/
/* Initialization.  Strategy is to copy working set into workfiles, */
/* modify the workfiles, and then copy the information back using   */
/* the same programs as load data definitions.                      */

/* This sets things up properly for when creating a file (user_env[1] = "") */
user_filename = user_env[1].
DISPLAY user_filename WITH FRAME user_ftr.

PAUSE 0 BEFORE-HIDE.

ASSIGN  odbtyp = {adecomm/ds_type.i
                  &direction = "ODBC"
                  &from-type = "odbtyp"}.

/* point to proper _Db record */
FIND DICTDB._Db WHERE
  DICTDB._Db._Db-name = (IF user_dbtype = "PROGRESS" THEN ? ELSE user_dbname) NO-LOCK.
  
IF (DICTDB._Db._DB-type = "ORACLE" OR DICTDB._DB._Db-type = "AS400" OR
    DICTDB._Db._Db-type = "ODBC") and user_filename = "" THEN DO:
  MESSAGE "You may not add a table definition for this database type."
      view-as ALERT-BOX ERROR buttons OK.
  ASSIGN user_path = "".
  RETURN.
END. 
  
FIND DICTDB._File OF DICTDB._Db WHERE
  DICTDB._File._File-name = user_filename 
  AND (DICTDB._File._Owner = "PUB" OR DICTDB._File._Owner = "_FOREIGN")NO-ERROR.
IF AVAILABLE DICTDB._File THEN drec_file = RECID(DICTDB._File).

/* ODBC and ORACLE DataServers need some more Table-specific info
 * currently: ROWID index-info
 */
do with frame frame-d:
  if can-do(odbtyp + ",ORACLE",user_dbtype)
  and available DICTDB._File
   then assign
     button-v:column = 2
     button-f:column = 21
     button-s:column = 37
     button-d:column = 63
     button-d:label  = "DataServer...".
   else assign
     button-d:hidden = TRUE.
  end.

CREATE wfil.

ASSIGN
  adding = NOT AVAILABLE DICTDB._File
  hiding = (AVAILABLE DICTDB._File AND DICTDB._File._Hidden)
  dbkey  = RECID(DICTDB._File).
/* IF adding THEN DO:              moved     */
/*   { prodict/dictgate.i            to      * /
/ *        &action=query               top   * /
/ *        &dbtype=user_dbtype       <hut>   * /
/ *        &dbrec=?                          * /
/ *        &output=c }                       */ 
/*   capabs[1] = INDEX(ENTRY(2,c),"a") > 0.  */
/* END.                                      */

/* 20051228-008 - use other delimiter in case area name has comma */
areaname:DELIMITER IN FRAME frame-d = CHR(1).

IF NOT adding THEN  DO:
  IF DICTDB._File._For-type <> ? THEN
    ASSIGN arealist = "N/A"
           areaname:LIST-ITEMS IN FRAME frame-d = arealist.          
  ELSE DO:
    if DICTDB._File._file-attributes[1] = false or DICTDB._File._file-attributes[2] = true then
    do:
        if DICTDB._File._File-number <> ? then
        do:
            FIND  DICTDB._StorageObject WHERE  DICTDB._StorageObject._Db-recid = DICTDB._File._Db-recid
                                  AND  DICTDB._StorageObject._Object-type = 1
                                  AND  DICTDB._StorageObject._Object-number = DICTDB._File._File-number
                                  and  DICTDB._StorageObject._Partitionid = 0
                                  NO-LOCK NO-ERROR.
            IF AVAILABLE DICTDB._StorageObject THEN 
            DO: 
                 if DICTDB._StorageObject._Area-number <> 0 then                                                
                      FIND DICTDB._Area WHERE DICTDB._Area._Area-number = DICTDB._StorageObject._Area-number NO-LOCK.
            end.
            else if not DICTDB._File._file-attributes[3] then
                FIND DICTDB._Area WHERE DICTDB._Area._Area-number =  6 NO-LOCK.
        end.
        else do:
            if DICTDB._File._ianum <> 0 then
                FIND DICTDB._Area WHERE DICTDB._Area._Area-number = DICTDB._File._ianum no-lock no-error.
            
        end. 
        IF AVAILABLE DICTDB._Area THEN  
        do:   
           ASSIGN arealist = DICTDB._Area._Area-name
                  isType2 = dictdb._Area._Area-clustersize = 8 
                          or  dictdb._Area._Area-clustersize = 64
                          or  dictdb._Area._Area-clustersize = 512    
                  areaname:LIST-ITEMS IN FRAME frame-d = arealist.

        end.   
        else /* file-area-number seems to only be used when adding? 
               (refactored from if not DICTDB._File._file-attributes[3] ) */
            ASSIGN file-area-number = 0
                   arealist = "".
             
    end.       
  END.  
  { prodict/dump/copy_fil.i &from=DICTDB._File &to=wfil &all=true}
  FOR EACH DICTDB._File-Trig OF DICTDB._File:
    CREATE wfit.
    { prodict/dump/copy_fit.i &from=DICTDB._File-trig &to=wfit }
  END.

END.
ELSE DO:
  
  FIND DICTDB._Db NO-ERROR.
  IF AVAIL DICTDB._Db AND DICTDB._Db._Db-misc1[1] <> 0 THEN DO:
    FIND DICTDB._Area WHERE DICTDB._Area._Area-num = DICTDB._Db._Db-misc1[1] NO-LOCK NO-ERROR.
    IF AVAIL DICTDB._Area THEN
      assign arealist  = DICTDB._Area._Area-name
             cSkipArea = DICTDB._Area._Area-name.
  END.
  
  FOR EACH DICTDB._Area WHERE DICTDB._Area._Area-num > 6
                          AND DICTDB._Area._Area-type = 6
                          AND NOT CAN-DO ({&INVALID_AREAS}, DICTDB._Area._Area-name)
                          AND DICTDB._Area._Area-name <> cSkipArea
                          NO-LOCK. 
    
    IF arealist = ? THEN
      ASSIGN arealist = DICTDB._Area._Area-name
             filearea = DICTDB._Area._Area-name.
    ELSE
      /* 20051228-008 - use other delimiter in case area name has comma */
      ASSIGN arealist = arealist + CHR(1) + DICTDB._Area._Area-name.

  END.
  
  FIND DICTDB._Area WHERE DICTDB._Area._Area-num = 6
                      AND DICTDB._Area._Area-name <> cSkipArea NO-LOCK.
  IF arealist = ? THEN 
    ASSIGN arealist = DICTDB._Area._Area-name
           filearea = DICTDB._Area._Area-name
           s_In_Schema_Area = TRUE.
  ELSE
    ASSIGN arealist = arealist + CHR(1) + DICTDB._Area._Area-name.
  
  ASSIGN areaname:LIST-ITEMS IN FRAME frame-d = arealist.

  RELEASE DICTDB._Db. 
         
END.
          
/*--------------------------------------------------------------------------*/
/* Check Security.
romode =  0 - can read/write
       = +1 - file frozen
       = +2 - dict in r/o mode
       = +3 - no permission to change
       = -1 - new file and no create permission
       = -2 - old file and no write permission
       = -3 - can't add for this dbtype
*/

FIND DICTDB._File "_File".
   
romode = (IF wfil._Frozen THEN 1 ELSE IF dict_rog THEN 2 ELSE IF wfil._Db-lang > 1 THEN 4 ELSE 0).
IF adding AND NOT CAN-DO(DICTDB._File._Can-write,USERID("DICTDB"))
  THEN romode = 3.
IF adding AND NOT CAN-DO(DICTDB._File._Can-create,USERID("DICTDB"))
  THEN romode = -1.
IF NOT adding AND NOT CAN-DO(DICTDB._File._Can-read,USERID("DICTDB"))
  THEN romode = -2.
IF adding AND NOT capabs[1] THEN romode = -3.

/* 0: Use the [GET] key to switch files quickly.                          */
/*+1: This file definition has been FROZEN and cannot be altered here.    */
/*+2: The dictionary is in read-only mode, so alterations are not allowed.*/
/*+3: You do not have permission to modify files.                         */
/*+4: SQL92 Table can not modify                                          */
/*-1: You do not have permission to create files.                         */
/*-2: You do not have permission to see file definitions.                 */
/*-3: You may not add a file definition here for this database type.      */

if not adding then do:
FIND FIRST DICTDB._File where DICTDB._File._File-name eq user_filename.
   ASSIGN CDCenabled = _File._File-Attributes[6].
end.

HIDE MESSAGE NO-PAUSE.
IF romode < 0 THEN DO:
  MESSAGE (IF romode = -1
    THEN "You do not have permission to create tables."
    ELSE IF romode = -2
    THEN "You do not have permission to see table definitions."
    ELSE "You may not add a table definition here for this database type.").
  user_path = "".
  RETURN.
END.

stdmsg =  
  (IF romode = 0
  THEN IF adding THEN "" 
       ELSE "Use the [" + KBLABEL("GET") + "] key to switch tables quickly."
  ELSE IF romode = 1 
  THEN IF NOT CDCenabled THEN "This table definition has been FROZEN and cannot be altered here."
       ELSE "Use the [" + KBLABEL("GET") + "] key to switch tables quickly."
  ELSE IF romode = 2
  THEN "The dictionary is in read-only mode, so alterations are not allowed."
  ELSE IF romode = 4 THEN
    "{&PRO_DISPLAY_NAME}/SQL92 table cannot be modify."
  ELSE "You do not have permission to modify tables.").







/*--------------------------------------------------------------------------*/

/* See if the field editor is in user_path.  If not, don't show field editor
   button.  It won't be for certain gateway operations.
*/

fldeditor = (IF INDEX(user_path,"_usrfchg") = 0 THEN no ELSE yes).

VIEW FRAME box-shadow.
/*UNDERLINE c WITH FRAME box-shadow. */ /* FIX THIS */
/* above line produces a remaining "_" on the table-modify screen */

IF adding OR NOT fldeditor THEN DO:
  /* Use this to center the ok and cancel buttons */
  {adecomm/okrun.i  
     &FRAME  = "FRAME frame-d" 
     &OK     = "btn_OK" 
     &CANCEL = "btn_Cancel"
  }
  FRAME frame-d:WIDTH = FRAME frame-d:WIDTH - 1.  /* undo widening of frame */
  btn_flds:VISIBLE IN FRAME frame-d = no.
END.

VIEW FRAME frame-d.    
/*
This code sets the file type.
File-types:
  PROGRESS Schema   _File-num = -1..-6, -30..-32
  FAST TRACK Schema _File-num = -7..-29
  PROGRESS/SQL      _Db-lang = 1 for SQL89 and 2 for SQL92
  non-PROGRESS      _Db-type <> "PROGRESS"
  PROGRESS          (whatever's left)
*/

ftyp = (IF wfil._File-number >= -29
       AND wfil._File-number <= -7 THEN "FAST TRACK Schema"
       ELSE IF wfil._File-number < 0 THEN "{&PRO_DISPLAY_NAME} Schema"
       ELSE IF wfil._File-number > 32767  THEN "SQL92 View"
       ELSE IF wfil._Db-lang > 0  THEN "{&PRO_DISPLAY_NAME}/SQL"
       ELSE                             user_dbtype)
      + (IF wfil._For-Type = ? THEN "" ELSE " (" + wfil._For-Type + ")").
i = INDEX(ftyp,") (").
IF i > 0 THEN SUBSTRING(ftyp,i,3) = ", ".

MESSAGE COLOR NORMAL stdmsg.
IF adding THEN
   ASSIGN
      wfil._File-name = "" /* instead of ? */
      wfil._Dump-name = "".
      
multitenantdb = can-find(first dictdb._tenant) .
find dictdb._Database-feature where dictdb._Database-feature._DBFeature_Name = "Table Partitioning" no-lock no-error.
if avail dictdb._Database-feature and dictdb._Database-feature._dbfeature_enabled="1" then
    isPartitionEnabled = true.

if not multitenantdb then
    wfil._File-attribute[2]:hidden in frame frame-d = true.
DISPLAY
  wfil._File-name
  wfil._File-attribute[1] 
  wfil._File-attribute[2] when multitenantdb
  wfil._File-attribute[3]  
  areaname
  wfil._Dump-name
  ftyp @ wfil._For-Type
  wfil._Hidden
  wfil._File-label
  wfil._Frozen
  (IF wfil._Db-lang > 0 THEN ENTRY(1,wfil._Owner) ELSE wfil._For-Owner)
    @ wfil._For-Owner
  (IF wfil._For-Size = ? THEN "n/a" ELSE STRING(wfil._For-Size))
    @ wfil._For-Size
  (IF wfil._For-Name = ? THEN "n/a" ELSE wfil._For-Name)
    @ wfil._For-Name
  (IF user_dbtype <> "ORACLE" then "n/a" ELSE IF 
   wfil._Fil-misc2[8] = ? THEN "<Local-Db>" ELSE
   wfil._Fil-misc2[8]) @ wfil._Fil-misc2[8]
  wfil._Fil-misc2[6]
  wfil._Desc
  WITH FRAME frame-d.

if multitenantdb then 
    setAreaState(wfil._File-attribute[1],
             wfil._File-attribute[2],
             no,
             adding,
             wfil._File-attribute[1]:handle in frame frame-d,
             areaname:handle in frame frame-d,
             ?,
             /* onl one entry in list when editing */
             if not adding then areaname:list-items else "").

newnam = (romode = 0)
         AND (wfil._Db-lang = 0)
         AND (NOT CAN-FIND(FIRST DICTDB._View-ref
         WHERE DICTDB._View-ref._Ref-Table = wfil._File-name)).
         
desc_frame:
DO ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE WITH FRAME frame-d:
   canEnablePartitionOptions = adding 
                             or (isType2 and  wfil._File-Attributes[1] = false and wfil._File-Attributes[3] = false).

/* mkondra- PSC00279093:added below code to disable MT or TP option in table prop when index or lob field area is of type-1 */ 
if not adding then do:
    find dictdb._file where dictdb._file._file-name = user_filename.
      
    FOR EACH dictdb._Field where dictdb._Field._File-recid = recid(_File) NO-LOCK:
        IF (dictdb._field._Data-type = "BLOB" OR dictdb._Field._Data-type = "CLOB") then do:
            FIND dictdb._storageobject WHERE dictdb._Storageobject._Db-recid = _File._Db-recid
                                              AND dictdb._Storageobject._Object-type = 3
                                              AND dictdb._Storageobject._Object-number = dictdb._Field._Fld-stlen
                                              and dictdb._Storageobject._Partitionid = 0
                                              NO-LOCK NO-ERROR.
                                              
            FIND DICTDB._Area WHERE DICTDB._Area._Area-number = dictdb._StorageObject._Area-number NO-LOCK NO-ERROR.
            IF AVAILABLE DICTDB._Area THEN
                ASSIGN fldIsType2 = dictdb._Area._Area-clustersize EQ 8 OR  dictdb._Area._Area-clustersize EQ 64 OR  dictdb._Area._Area-clustersize EQ 512. 
            IF fldIsType2 = FALSE THEN
		        LEAVE.
         END.
         else
            fldIsType2 = true.
     END.

     FOR EACH DICTDB._Index WHERE _file-recid = RECID(dictdb._file) NO-LOCK:
        IF NOT _File._File-Attributes[3] THEN DO:
            FIND dictdb._StorageObject WHERE dictdb._StorageObject._Db-recid = _File._Db-recid
                                     AND dictdb._StorageObject._Object-type = 2
                                     AND dictdb._StorageObject._Object-number = dictdb._Index._Idx-num
                                     AND dictdb._StorageObject._partitionid = 0
                                     NO-LOCK NO-ERROR.

            FIND DICTDB._Area WHERE DICTDB._Area._Area-number = dictdb._StorageObject._Area-number NO-LOCK NO-ERROR.     
	        IF AVAILABLE DICTDB._Area THEN
                ASSIGN idxIsType2 = dictdb._Area._Area-clustersize EQ 8 OR  dictdb._Area._Area-clustersize EQ 64 OR  dictdb._Area._Area-clustersize EQ 512. 
		    IF idxIsType2 = FALSE THEN
		        LEAVE.
        END.
    END.
end.

  /* use enable and wait-for in order to control wfil._File-attributes[2] tab order
     even if it is not enabled and the area is not sensitive (the SetAreaState
     is fired from value changed on the File-attributes and set [2] tab order 
     before the Area */ 
if adding then do:  
  ENABLE 
    wfil._File-name  WHEN newnam
    wfil._File-attributes[3] when romode = 0 and isPartitionEnabled and canEnablePartitionOptions 
    wfil._File-attributes[1] when romode = 0 and multitenantdb and canEnablePartitionOptions /* disabled below if necessary */
    /* enable here for tab order - senistive is set false below and enabling is managed in triggers */  
    wfil._File-attributes[2] when romode = 0 and multitenantdb and canEnablePartitionOptions  
    areaname when ierror EQ 0  /* disabled below if necessary  */
    wfil._Dump-name  WHEN romode = 0
	     VALIDATE(INDEX(INPUT wfil._Dump-name, " ") = 0, "Invalid character in Dump Name")
    wfil._For-Type   WHEN romode = 0 AND capabs[5]
    wfil._Hidden     WHEN romode = 0
    wfil._File-label WHEN romode = 0
    wfil._Fil-misc2[6] WHEN romode < 4   /* replication procedure name */
    wfil._For-Size   WHEN romode = 0 AND capabs[4]
    wfil._For-name   WHEN romode = 0 AND capabs[2]
    wfil._Desc       WHEN romode = 0
    button-v button-f button-s
    button-d         WHEN can-do(odbtyp + ",ORACLE", user_dbtype)
                            and not adding
    btn_OK           WHEN romode = 0 OR (romode = 1 and CDCenabled) 
    btn_Cancel 
    btn_flds         WHEN NOT adding AND fldeditor
    WITH FRAME frame-d.
end.

if not adding then do:  
  ENABLE 
    wfil._File-name  WHEN newnam
    wfil._File-attributes[3] when romode = 0 and isPartitionEnabled and canEnablePartitionOptions and fldIsType2 and idxIsType2
    wfil._File-attributes[1] when romode = 0 and multitenantdb and canEnablePartitionOptions and fldIsType2 and idxIsType2 /* disabled below if necessary */
    /* enable here for tab order - senistive is set false below and enabling is managed in triggers */  
    wfil._File-attributes[2] when romode = 0 and multitenantdb and canEnablePartitionOptions  
    areaname when ierror EQ 0  /* disabled below if necessary  */
    wfil._Dump-name  WHEN romode = 0
	     VALIDATE(INDEX(INPUT wfil._Dump-name, " ") = 0, "Invalid character in Dump Name")
    wfil._For-Type   WHEN romode = 0 AND capabs[5]
    wfil._Hidden     WHEN romode = 0
    wfil._File-label WHEN romode = 0
    wfil._Fil-misc2[6] WHEN romode < 4   /* replication procedure name */
    wfil._For-Size   WHEN romode = 0 AND capabs[4]
    wfil._For-name   WHEN romode = 0 AND capabs[2]
    wfil._Desc       WHEN romode = 0
    button-v button-f button-s
    button-d         WHEN can-do(odbtyp + ",ORACLE", user_dbtype)
                            and not adding
    btn_OK           WHEN romode = 0 OR (romode = 1 and CDCenabled) 
    btn_Cancel 
    btn_flds         WHEN NOT adding AND fldeditor
    WITH FRAME frame-d.
end.

     
  if ierror EQ 0 THEN
  do:
    areaname:sensitive = false.
    if multitenantdb then 
    do:
      assign
          wfil._File-attributes[2]:sensitive = FALSE. /* enabled in triggers only*/
          areaname:sensitive = romode = 0 AND adding.
    end.
    else if canEnablePartitionOptions then do:
      assign
          areaname:sensitive = romode = 0 AND adding.
    end.
    else if not multitenantdb and not isPartitionEnabled  then do:
      assign
          areaname:sensitive = romode = 0 AND adding.
    end.
  end.

  wait-for go of frame frame-d.
  hide message no-pause.
  ASSIGN 
     wfil._File-name           when wfil._File-name:sensitive 
     wfil._File-attributes[1]  when wfil._File-attributes[1]:sensitive
                               /* NOT a typo - [2] need to be saved also when disabled
                                  when [1] is enabled  */ 
     wfil._File-attributes[2]  when wfil._File-attributes[1]:sensitive 
     wfil._File-attributes[3]  when wfil._File-attributes[3]:sensitive 
     wfil._Dump-name           when wfil._Dump-name:sensitive      
     wfil._For-Type            when wfil._For-Type:sensitive 
     wfil._Hidden              when wfil._Hidden:sensitive  
     wfil._File-label          when wfil._File-label:sensitive 
     wfil._Fil-misc2[6]        when wfil._Fil-misc2[6]:sensitive 
     wfil._For-Size            when wfil._For-Size:sensitive  
     wfil._For-name            when wfil._For-name:sensitive   
     wfil._Desc                when wfil._Desc:sensitive 
     touched = touched
           OR FRAME frame-d wfil._File-name ENTERED
           OR FRAME frame-d wfil._File-attribute[1] ENTERED
           OR FRAME frame-d wfil._File-attribute[2] ENTERED
           OR FRAME frame-d wfil._File-attribute[3] ENTERED
           OR FRAME frame-d wfil._For-Type ENTERED
           OR FRAME frame-d wfil._Hidden ENTERED
           OR FRAME frame-d areaname ENTERED
           OR FRAME frame-d wfil._File-label ENTERED
           OR FRAME frame-d wfil._Dump-name ENTERED
           OR FRAME frame-d wfil._For-Size ENTERED
           OR FRAME frame-d wfil._Desc ENTERED
           OR FRAME frame-d wfil._Fil-misc2[6] ENTERED
    wfil._Dump-name = INPUT FRAME frame-d wfil._Dump-name.

  IF adding THEN DO:
    if (wfil._File-attributes[1] = true and wfil._File-attributes[2] = false) or (wfil._File-attributes[3]) then
    do:
        ASSIGN file-area-number = 0.
    end.      
    else do:
        FIND DICTDB._Area WHERE DICTDB._Area._Area-name = filearea NO-LOCK.
        ASSIGN file-area-number = DICTDB._Area._Area-number.
    end.
  END.
  
  /* Any user-added tables for an ODBC db will be of type BUFFER */
  IF CAN-DO(odbtyp, user_dbtype)
     AND wfil._For-Name = ? AND wfil._For-Owner = ? THEN
    ASSIGN 
      wfil._For-Type = "BUFFER"
      wfil._For-Name = "NONAME".
        
  IF romode = 0 OR (romode = 1 and CDCenabled)  THEN DO:
    ierror = 0.
    IF NOT adding AND wfil._File-name <> user_filename THEN DO:	
      ASSIGN
        irename         = wfil._File-name
        wfil._File-name = user_filename
        imod            = "r".
      RUN "prodict/dump/_lod_fil.p".
      wfil._File-name = irename.
    END.
		     
    IF ierror > 0 THEN UNDO, RETRY.

    ASSIGN
      cache_dirty = cache_dirty OR adding
                          OR (NOT adding AND
                              (wfil._File-name <> user_filename OR 
                                      wfil._Hidden <> hiding))
      dict_dirty    = dict_dirty OR cache_dirty OR touched OR RETURN-VALUE = "MOD"
      user_filename = wfil._File-name      /* RETURN-VALUE set by _gat_row.p (tty) */
      imod          = (IF adding THEN "a" ELSE "m").
    if not adding then 
    do:
      /*-----------------------------------------------------------------------
        We need to point back to the _File being modified to copy any changes
        made in _gat_row.p (above we find the "_File" file to check permissions
        ----------------------------------------------------------------------*/
      find DICTDB._File where recid(DICTDB._File) = drec_file.

      /*---------------------------------------------------------------------
        Needed to prevent _lod_fil.p from blowing away changes made to schema
        holder "rowid" fields in _gat_row.p, which does not use wfil. (tsn)
        --------------------------------------------------------------------*/
      assign
        wfil._Fil-misc1[1] = DICTDB._File._Fil-misc1[1]
        wfil._Fil-misc1[2] = DICTDB._File._Fil-misc1[2]
        wfil._Fil-misc1[4] = DICTDB._File._Fil-misc1[4]
        wfil._Fil-misc2[3] = DICTDB._File._Fil-misc2[3].
      /*--------------------------------------------------------------------*/
    end.
		      
    RUN "prodict/dump/_lod_fil.p".
		    
    IF ierror > 0 THEN UNDO, RETRY.
    DISPLAY user_filename WITH FRAME user_ftr.
  END.

  IF KEYFUNCTION(LASTKEY) = "GO" OR get-hit then LEAVE desc_frame.
END.  /* if romode = o then do; */
 
IF get-hit THEN
  user_path = "1=,_usrtget,_usrtchg,_usrfchg".
ELSE IF KEYFUNCTION(LASTKEY) = "END-ERROR" OR 
        (NOT adding AND fldeditor AND NOT go_field) THEN DO:
  user_path = "".
  HIDE MESSAGE NO-PAUSE.
END.

HIDE FRAME box-shadow NO-PAUSE.
HIDE FRAME frame-d NO-PAUSE.

PAUSE 0 BEFORE-HIDE.

RETURN.

&ENDIF  /* only compile for tty */
