/********************************************************************* *
* Copyright (C) 2000-2010,2013 by Progress Software Corporation. All   *
* rights reserved.  Prior versions of this work may contain portions   *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/

/* Progress Lex Converter 7.1A->7.1B Version 1.11 */

/*
-------------------------------------------------------------------------------
DESCRIPTION:
------------
  Table Name: ______________________________     Table Type: _________ 
 Partitioned: ___   
Multi-tenant: ___  Keep Area for Default Tenant: __ 
        Area: _____________________________________         
   Dump File: _____________________________________         Hidden: ___
       Label: _____________________________________         Frozen: ___
       Owner: _____________________________________    Record Size: _____
 Replication: _____________________________________
  DataServer Name: ______________________________________________
         DB Link : ______________________________________________

 Description: _______________________________________________________________
              _______________________________________________________________
              _______________________________________________________________
              _______________________________________________________________

          [^Validation] [^Triggers] [String Attributes] [^DataServer]
-------------------------------------------------------------------------------
*/
/*
   HISTORY:  D. McMann change Area variable to character so N/A could be
                       displayed for DataServer files 02/9/98
                       
             D. McMann Removed _file-number 03/18/98   
             D. McMann Added Area name support 
             D. McMann Added _Owner to _File finds 07/14/98
             Mario B Add s_In_Schema_Area enabling one time notification 12/28/98.
             D. McMann changes for 99-02-26-025
             D. McMann Added selection-list for areas.
             fernando  06/15/06 Expanding Dump-name to 32 characters
*/

FORM
  wfil._File-name FORMAT "x(32)"  colon 13 LABEL "Table Name"
  /* progress is longest db type name */  
  wfil._For-Type  FORMAT "x(10)"  colon 64 LABEL "Table Type"
  skip
  wfil._File-attributes[3]  colon 13 label "Partitioned" 
  skip
  wfil._File-attributes[1]  colon 13 label "Multi-tenant" 
  wfil._File-attributes[2]  label "Support Default Tenant"
  SKIP
  areaname  colon 13 VIEW-AS SELECTION-LIST INNER-CHARS 32 INNER-LINES 1 
                                     LABEL "Area" SKIP
 
  wfil._Dump-name    FORMAT "x(32)"  colon 13 LABEL "Dump File" 
  wfil._Hidden       FORMAT "yes/no" colon 64 LABEL "Hidden" SKIP
  wfil._File-label   FORMAT "x(32)"  colon 13 LABEL "Label"      
  wfil._Frozen       FORMAT "yes/no" colon 64 LABEL "Frozen" SKIP
  wfil._For-Owner    FORMAT "x(32)"  colon 13 LABEL "Owner"
  wfil._For-Size     FORMAT ">>>>9"  colon 64 LABEL "Record Size" SKIP

  wfil._Fil-misc2[6] FORMAT "X(32)"  colon 13 LABEL "Replication"
 
  wfil._For-Name     FORMAT "x(45)" colon 19   LABEL  "DataServer Name"
    HELP "The name of the table in the DataServer's schema"  SKIP
  wfil._Fil-misc2[8] FORMAT "x(45)"  colon 19  LABEL "DB Link"   SKIP
 
  wfil._Desc      colon 13 VIEW-AS EDITOR
                           INNER-CHARS 63 INNER-LINES 2
                           BUFFER-LINES 4     LABEL "Description"    SKIP

  button-v AT 12 SPACE(2) button-f SPACE(2) 
        button-s SPACE(2) button-d                           SKIP
  btn_OK   AT 22 SPACE(4) btn_Cancel SPACE(4) btn_flds
  WITH FRAME frame-d
    /* need scrollable to compile cleanly on gui - though it's not run there */
    NO-BOX  SIDE-LABELS OVERLAY ROW 2 COLUMN 2 SCROLLABLE.


/*----- GO or OK -----*/
ON GO OF FRAME frame-d DO:

  RUN check_file_name (OUTPUT isbad).
  IF isbad THEN DO:
    ASSIGN
      go_field = no
      get-hit = no.
    RETURN NO-APPLY.
  END.

  RUN check_dump_name (OUTPUT isbad).
  IF isbad THEN DO:
    ASSIGN
      get-hit = no
      go_field = no.
    RETURN NO-APPLY.
  END.

  IF adding and input wfil._File-attributes[3] = FALSE THEN DO:   
    ASSIGN filearea = areaname:SCREEN-VALUE IN FRAME FRAME-d.    

    RUN check_area_name (INPUT-OUTPUT s_In_Schema_Area).
    IF NOT s_In_Schema_Area THEN 
    DO:
      ASSIGN get-hit = no
             go_field = no.
      RETURN NO-APPLY.
    END.
  END.
  ELSE DO:
    if input wfil._File-attributes[1] and not wfil._File-attributes[1] then
    do:  
        if input wfil._File-attributes[3] then
        do:
            message "Partitioning of a multi-tenant table is not supported"
            view-as alert-box error.
            isBad = true.
        end.    
        else /* yes - input input...   */
            RUN check_multi_tenant (input input wfil._File-attributes[2],OUTPUT isBad).
        IF isBad THEN DO:
          ASSIGN
            go_field = no
            get-hit = no.
          RETURN NO-APPLY.
        END.
    end.
  END.
  
END.

ON VALUE-CHANGED OF areaname IN FRAME frame-d DO :
  ASSIGN filearea = areaname:SCREEN-VALUE.
  /* keep track of last non-bank area for resetting when 
     changing Keep default area - wfil._File-attribute[2] */
  if filearea <> "" then 
     filearealog = filearea.
  RETURN.
END.

ON any-printable OF wfil._File-attribute[1] IN FRAME frame-d,
                    wfil._File-attribute[2] IN FRAME frame-d,
                    wfil._File-attribute[3] IN FRAME frame-d
DO :
   if last-event:label = "?" then
    do: 
        bell. 
        return no-apply.  
    end.  
end.

ON VALUE-CHANGED OF wfil._File-attribute[1] IN FRAME frame-d,
                    wfil._File-attribute[2] IN FRAME frame-d
DO :
             
   /* { defined in prodict/pro/arealabel.i } */
   setAreaState(input frame frame-d wfil._File-attribute[1],
                input frame frame-d wfil._File-attribute[2],   
                yes,
                adding,
                wfil._File-attribute[2]:handle in frame frame-d, 
                areaname:handle in frame frame-d,
                ?, /* no area button */
                filearealog).
                 
END.

ON VALUE-CHANGED OF wfil._File-attributes[3] IN FRAME frame-d
DO :
   if adding then do:
      if wfil._File-Attributes[3]:screen-value in frame frame-d eq "yes" then do:
            hideArea(areaname:handle in frame frame-d). 
	    areaname:handle:sensitive in frame frame-d = false.       
      end.
      else do:
            showArea(areaname:handle in frame frame-d, areaname,adding).
	    areaname:handle:sensitive in frame frame-d = true.
      end.
    end.
    
END.

/*----- CHOOSE OF FIELD EDITOR BUTTON-----*/
ON CHOOSE OF btn_flds IN FRAME frame-d 
   go_field = yes.
   /* GO trigger will fire after this */


/*----- CHOOSE of SUB-DIALOG BUTTONS -----*/
ON CHOOSE OF button-v IN FRAME frame-d DO:
  RUN Tbl_Validation.
  MESSAGE COLOR NORMAL stdmsg.
END.

ON CHOOSE OF button-f IN FRAME frame-d DO:
  RUN Tbl_Triggers.
  MESSAGE COLOR NORMAL stdmsg.
END.

ON CHOOSE OF button-s IN FRAME frame-d DO:
  /* used for GUI too! */
  RUN Tbl_String_Attrs.
  MESSAGE COLOR NORMAL stdmsg.
END.

ON CHOOSE OF button-d IN FRAME frame-d DO:
  RUN prodict/gate/_gat_row.p 
    ( INPUT user_dbtype,
      INPUT dbkey
    ).
  MESSAGE COLOR NORMAL stdmsg.
END.



/*---- DEFAULT DUMP NAME -----*/
ON ENTRY OF wfil._Dump-name IN FRAME frame-d DO:
  IF SELF:SCREEN-VALUE = "?" OR SELF:SCREEN-VALUE = "" THEN
    DISPLAY LC(INPUT FRAME frame-d wfil._File-name)
      @ wfil._Dump-name WITH FRAME frame-d.
END.


/*----- HANDLE GET TO SWITCH TABLES -----*/
ON   GET OF wfil._File-name  IN FRAME frame-d
  OR GET OF wfil._File-attribute[1]  IN FRAME frame-d
  OR GET OF wfil._File-attribute[2]  IN FRAME frame-d
  OR GET OF wfil._File-attribute[3]  IN FRAME frame-d
  OR GET OF areaname         IN FRAME frame-d
  OR GET OF wfil._For-Type   IN FRAME frame-d
  OR GET OF wfil._Hidden     IN FRAME frame-d
  OR GET OF wfil._Dump-name  IN FRAME frame-d
  OR GET OF wfil._File-label IN FRAME frame-d
  OR GET OF wfil._For-Size   IN FRAME frame-d
  OR GET OF wfil._Desc       IN FRAME frame-d 
  OR GET OF button-v         IN FRAME frame-d
  OR GET OF button-f         IN FRAME frame-d 
  OR GET OF button-s         IN FRAME frame-d 
  OR GET OF btn_OK           IN FRAME frame-d 
  OR GET OF btn_Cancel       IN FRAME frame-d 
  OR GET OF btn_flds         IN FRAME frame-d 
DO:
  IF NOT adding THEN DO:
    get-hit = TRUE.
    APPLY "GO" TO FRAME frame-d.
  END.
  RETURN NO-APPLY.
END.


/*------------------------Internal Procedures--------------------*/
PROCEDURE check_dump_name:
  DEFINE OUTPUT PARAMETER isbad AS LOGICAL INITIAL FALSE NO-UNDO.

  IF INPUT FRAME frame-d wfil._Dump-name = ?
    OR INPUT FRAME frame-d wfil._Dump-name = "" THEN
    DISPLAY LC(INPUT FRAME frame-d wfil._File-name)
      @ wfil._Dump-name WITH FRAME frame-d.
  FIND FIRST DICTDB._File
    WHERE DICTDB._File._Dump-name = INPUT FRAME frame-d wfil._Dump-name
      AND (adding OR RECID(DICTDB._File) <> dbkey) 
      AND (DICTDB._File._Owner = "PUB" OR DICTDB._File._Owner = "_FOREIGN") NO-ERROR.
  IF AVAILABLE DICTDB._File THEN DO:
    MESSAGE "That dump name is not unique within this database."
      VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    isbad = TRUE.
    APPLY "ENTRY" TO wfil._Dump-name IN FRAME frame-d.
  END.
END PROCEDURE.


PROCEDURE check_file_name:
  DEFINE OUTPUT PARAMETER isbad AS LOGICAL INITIAL FALSE NO-UNDO.

  IF newnam THEN DO: 
    RUN "adecomm/_valname.p"
      (INPUT (INPUT FRAME frame-d wfil._File-name),INPUT no,OUTPUT isbad).
    isbad = NOT isbad. /* _valname.p returns opposite of what we want here*/
    IF isbad THEN DO:
       APPLY "ENTRY" TO wfil._File-name IN FRAME frame-d.
       RETURN.
    END.
  END.
  FIND FIRST DICTDB._File OF DICTDB._Db
    WHERE DICTDB._File._File-name = INPUT FRAME frame-d wfil._File-name
      AND (adding OR RECID(DICTDB._File) <> dbkey) 
      AND (DICTDB._File._Owner = "PUB" OR DICTDB._File._Owner = "_FOREIGN") NO-ERROR.
  isbad = (AVAILABLE DICTDB._File).
  IF isbad THEN DO:
    MESSAGE "This table name is already used within this database."
      VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    APPLY "ENTRY" TO wfil._File-name IN FRAME frame-d.
  END.
END PROCEDURE.

PROCEDURE check_area_name:
  DEFINE INPUT-OUTPUT PARAMETER p_In_Schema_Area AS LOGICAL NO-UNDO.
  
  DEFINE VARIABLE ans             AS LOGICAL INITIAL FALSE NO-UNDO. 

  IF filearea = "" OR filearea = ? THEN
      ASSIGN filearea = areaname:ENTRY(1) IN FRAME frame-d.

  IF filearea = "Schema Area"  THEN DO:
    IF p_In_schema_area THEN DO:
      APPLY LASTKEY.
      RETURN.
    END.
    FIND FIRST DICTDB._Area WHERE DICTDB._Area._Area-number > 6
                              AND DICTDB._Area._Area-type = 6
                              no-lock no-error.
    IF AVAILABLE DICTDB._Area THEN DO:
      MESSAGE "Progress Software Corporation does not recommend" SKIP
              "creating user tables in the Schema Area." SKIP (1)
              "Should tables be created in this area?" SKIP(1)
               VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO UPDATE ans.
      IF ans THEN
        p_In_Schema_Area = TRUE.
      ELSE DO:
        p_In_Schema_Area = FALSE.
        APPLY "ENTRY" TO areaname IN FRAME frame-d.
        RETURN.
      END.
    END.
    ELSE DO:
      MESSAGE "Progress Software Corporation does not recommend" SKIP
              "creating user tables in the Schema Area. " SKIP(1)
              "See the System Administration Guide on how to" SKIP
              "create data areas. " SKIP(1)
              VIEW-AS ALERT-BOX WARNING.
      ASSIGN p_In_Schema_Area = TRUE.
    END.
  END.
  ELSE  
    APPLY LASTKEY.
   
END PROCEDURE.

PROCEDURE check_multi_tenant :    
 
    DEFINE INPUT PARAMETER keepdefault AS LOGICAL NO-UNDO.
    DEFINE OUTPUT PARAMETER isbad AS LOGICAL INITIAL FALSE NO-UNDO.
    run prodict/pro/_pro_mt_tbl.p (keepdefault,output isbad). 
END.  
