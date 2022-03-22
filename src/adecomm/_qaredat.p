/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _qaredat.p

Description:
   Display _Area and Extent information for the quick index report.  It will go to 
   the currently set output device (e.g., a file, the printer).
 
Input Parameters:
   p_DbId - Id of the _Db record for this database.
   p_area  - The name of the area we're showing or "ALL".

Author: Donna L. McMann

Date Created: 1/5/98
    Modified: 04/09/98 D. McMann changed the area type from a number to the name.
              04/14/00 D. McMann Added long path name support 


----------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER p_DbId AS RECID NO-UNDO.


DEFINE SHARED STREAM rpt.
DEFINE VAR answer AS LOGICAL INITIAL FALSE NO-UNDO.
Define variable Etype    as logical format "Variable/Fixed" NO-UNDO.
DEFINE VARIABLE esize    AS CHARACTER  FORMAT "x(11)"       NO-UNDO.
DEFINE VARIABLE ename    AS CHARACTER  FORMAT "x(30)"       NO-UNDO.
DEFINE VARIABLE epath    AS CHARACTER                       NO-UNDO.
DEFINE VARIABLE epname   AS CHARACTER                       NO-UNDO.
DEFINE VARIABLE atype    AS CHARACTER  FORMAT "x(20)"       NO-UNDO.
DEFINE VARIABLE i        AS INTEGER                         NO-UNDO.
DEFINE VARIABLE areatype AS CHARACTER EXTENT 7              NO-UNDO.
ASSIGN areatype[1] = "Invalid"
       areatype[2] = "Control Recovery"
       areatype[3] = "Before-image"
       areatype[4] = "Transaction Log"
       areatype[5] = "Event Log"
       areatype[6] = "Data"
       areatype[7] = "After-image".

FORM
    _area._area-number label "Area Number"            
    atype  label  "Type" SPACE (5)
    _area-blocksize format ">>>>>9" label "Block Size" SKIP space (5)
     _area-extents format ">>>9" label "Total Extents in Area" SPACE (5)
    _area-name label "Name"
   SKIP
   WITH FRAME areahdr WIDTH 80 USE-TEXT SIDE-LABELS STREAM-IO.

FORM
  space (5)
   _extent-number Label "Extent #"
   etype  Label "Type"
   esize  Label "Size" 
   ename  label "Name"
  WITH FRAME shoextent 
  DOWN USE-TEXT STREAM-IO.

FORM 
    epname FORMAT "x(5)" epath  FORMAT "x(70)" 
    WITH FRAME shopath NO-LABELS DOWN USE-TEXT STREAM-IO.

FORM
  SKIP(1) 
  SPACE(3) _Area._Area-name LABEL "Working on" FORMAT "x(32)" SPACE
  SKIP(1)
  WITH FRAME working_on SIDE-LABELS VIEW-AS DIALOG-BOX 
  TITLE "Generating Report".


/*----------------------------Mainline code--------------------------------*/

SESSION:IMMEDIATE-DISPLAY = yes.

FOR EACH _Area NO-LOCK :
       
   PAGE STREAM rpt.

      DISPLAY _Area._Area-name 
          WITH FRAME working_on.
   
   IF _area-type = 0 THEN
     DISPLAY STREAM rpt _Area._Area-name _area._area-number 
        areatype[_area-type + 1 ] @ atype _area-blocksize _area-extents
        WITH FRAME areahdr.

   ELSE
     DISPLAY STREAM rpt _Area._Area-name _area._area-number 
        areatype[_area-type] @ atype _area-blocksize _area-extents
        WITH FRAME areahdr.
   
  FOR EACH _AreaExtent OF _Area NO-LOCK
     BREAK BY _AreaExtent._Extent-path:
     
     /* Currently you can only have fixed and variable length area extents
        but there is also a raw type.  When this is available this code
        has to change to handle three types FIXED,VARIABLE,RAW
     */   
      IF _extent-size = 0 then 
        assign etype = true
               esize = "N/A".
               
       else 
         assign etype = false
                esize = STRING(_extent-size).

      IF LENGTH(_AreaExtent._extent-path) < 30 THEN
          ASSIGN ename = _AreaExtent._extent-path.
          
     
     ELSE 
        _ename:
        DO i = LENGTH(_AreaExtent._extent-path) TO 1 BY -1:
          IF SUBSTRING(_AreaExtent._extent-path,i,1) = "~/" OR
             SUBSTRING(_AreaExtent._extent-path,i,1) = "~\" THEN DO:         
            ASSIGN ename = SUBSTRING(_AreaExtent._extent-path,i + 1).
            LEAVE _ename.
          END.
      END.

      DISPLAY STREAM rpt
        _AreaExtent._extent-number
        etype 
        esize   
        ename 
        WITH FRAME shoextent.

        DOWN STREAM rpt WITH FRAME shoExtent.
    IF LENGTH(ename) < LENGTH(_AreaExtent._extent-path) THEN DO:
      IF (LENGTH(_AreaExtent._extent-path) - LENGTH(ename) + 1) < 70 THEN DO:
          ASSIGN epath = SUBSTRING(_AreaExtent._extent-path,1,i)
                 epname = "Path: ".
          DISPLAY STREAM rpt epname epname epath WITH FRAME shopath.
          DOWN STREAM rpt WITH FRAME shopath.
      END.
      ELSE DO: 
        ASSIGN ename  = SUBSTRING(_AreaExtent._extent-path,1,i)
               epname = "Path:"
               epath  = SUBSTRING(ename,1,70).

        _getpath:
        DO WHILE TRUE:  
          _ename:
          DO i = LENGTH(epath) TO 1 BY -1:
            IF SUBSTRING(epath,i,1) = "~/" OR SUBSTRING(epath,i,1) = "~\" 
            THEN DO:         
              ASSIGN epath = SUBSTRING(epath,1,i)
                     ename = SUBSTRING(ename,(LENGTH(epath) + 1)).
              LEAVE _ename.
            END.
          END.

          DISPLAY STREAM rpt epname epath WITH FRAME shopath.        
          DOWN STREAM rpt WITH FRAME shopath.
          IF LENGTH(ename) > 0 THEN
             ASSIGN epath = SUBSTRING(ename,1,70)
                    epname = " ".
          ELSE LEAVE _getpath.
        END.
      END.
    END.
     /* Put an extra line in between each Area. */
    IF LAST-OF(_AreaExtent._Extent-path) THEN 
       PUT STREAM rpt UNFORMATTED " " SKIP.
  END.
END.


   HIDE FRAME working_on NO-PAUSE.
   SESSION:IMMEDIATE-DISPLAY = no.

