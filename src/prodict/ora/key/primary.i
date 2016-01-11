/*********************************************************************
* Copyright (C) 2011 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: primary.i

Description:   
   This file contains the form for Primary Constraints.

HISTORY
Author: Kumar Mayur

Date Created:08/05/2011
----------------------------------------------------------------------------*/
{prodict/ora/key/constraint.i }

/* Query definitions                                                    */
DEFINE {1} QUERY BROWSE-PRIMARY FOR 
      temp SCROLLING.
      
            /* Browse definitions                                                   */
DEFINE {1} BROWSE BROWSE-PRIMARY
  QUERY BROWSE-PRIMARY NO-LOCK DISPLAY
      temp.ind FORMAT "x(20)":U
      temp.pri FORMAT "x(12)":U
      temp.uni FORMAT "x(12)":U
      temp.man FORMAT "x(15)":U
  WITH NO-ROW-MARKERS SEPARATORS
    &IF "{&WINDOW-SYSTEM}" <> "TTY"
    &THEN SIZE 75 BY 4.52 FIT-LAST-COLUMN.
    &ELSE SIZE 75 BY 8.3 FIT-LAST-COLUMN.
    &ENDIF 

/*    DEFINATION FOR PRIAMRY FRAME  */    
&Scoped-define FRAME-NAME frame_primary 
  
&Scoped-define BROWSE-NAME BROWSE-PRIMARY
&Scoped-define FIELDS-IN-QUERY-BROWSE-PRIMARY temp.pri temp.uni temp.ind temp.man
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-PRIMARY 
&Scoped-define QUERY-STRING-BROWSE-PRIMARY FOR EACH temp NO-LOCK.     
&Scoped-define OPEN-QUERY-BROWSE-PRIMARY OPEN QUERY BROWSE-PRIMARY FOR EACH temp NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-PRIMARY temp
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-PRIMARY temp    

        DEF VAR pri_chk_clus AS INTEGER NO-UNDO.
        DEF VAR pintSub AS INTEGER NO-UNDO.

        DEFINE VARIABLE pQuery AS HANDLE.
        DEFINE VARIABLE pBrowse AS HANDLE.
        DEFINE VARIABLE pBuffer AS HANDLE.
        DEFINE VARIABLE pField AS HANDLE.
        DEFINE VARIABLE pField1 AS HANDLE.
        DEFINE VARIABLE pField2 AS HANDLE.
        DEFINE VARIABLE pField3 AS HANDLE.
        DEFINE VARIABLE pField4 AS HANDLE.
        DEFINE VARIABLE pField5 AS HANDLE.
                
        pBrowse = BROWSE BROWSE-PRIMARY:HANDLE. 
        pQuery  = pBrowse:QUERY.
        pBuffer = pQuery:GET-BUFFER-HANDLE(1).
  
FORM
     &IF "{&WINDOW-SYSTEM}" <> "TTY"
     &THEN 
     name AT ROW 1.46 COL 17 COLON-ALIGNED WIDGET-ID 4
     BROWSE-PRIMARY AT ROW 3.36 COL 76 RIGHT-ALIGNED WIDGET-ID 200
     Active AT ROW 8.6 COL 2 WIDGET-ID 40
     DESC_EDIT2 AT ROW 10 COL 14 WIDGET-ID 36 NO-LABEL
     msg AT ROW 12.1 COL 2 WIDGET-ID 4 NO-LABEL
     OK_BUT AT ROW 13.3 COL 3
     CREATE_BUT AT ROW 13.3 COL 17
     CANCEL_BUT AT ROW 13.3 COL 31
     HELP_BUT  AT ROW 13.3 COL 60
     "Description:" VIEW-AS TEXT
          SIZE 11 BY .62 AT ROW 10.2 COL 2 WIDGET-ID 388
     "I  - Indicates Progress Index Property" VIEW-AS TEXT
          SIZE 50 BY .62 AT ROW 14.5 COL 2 WIDGET-ID 600
     "C - Indicates Constraint Property" VIEW-AS TEXT
          SIZE 50 BY .62 AT ROW 15.3 COL 2 WIDGET-ID 600 
     WITH FRAME frame_primary
         NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 2.4
         SIZE 80 BY 16  WIDGET-ID 100.
     
    &ELSE
     name AT ROW 2 COL 17 COLON-ALIGNED WIDGET-ID 4
     BROWSE-PRIMARY AT ROW 3.76 COL 76 RIGHT-ALIGNED WIDGET-ID 200
     Active AT ROW 13 COL 2 WIDGET-ID 40
     DESC_EDIT2 AT ROW 15 COL 2 WIDGET-ID 36
     OK_BUT AT ROW 20 COL 18 WIDGET-ID 26
     CREATE_BUT AT ROW 20 COL 35 WIDGET-ID 28
     CANCEL_BUT AT ROW 20 COL 52 WIDGET-ID 30
 
     WITH FRAME frame_primary
         NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 3
         SIZE 79 BY 21  WIDGET-ID 100.
    &ENDIF              
 ASSIGN  BROWSE-PRIMARY:COLUMN-RESIZABLE IN FRAME frame_primary        = TRUE.         


ON CHOOSE OF OK_BUT IN FRAME frame_primary
  DO:     
           ASSIGN is-saved = FALSE.
           RUN check_primary_save.
         IF is-saved THEN
           APPLY "CLOSE":U TO THIS-PROCEDURE.
           RETURN NO-APPLY.      
  END.


ON CHOOSE OF CREATE_BUT IN FRAME frame_primary
 DO:
          RUN check_primary_save.
 END. 
 
ON CHOOSE OF CANCEL_BUT IN FRAME frame_primary
  DO:     
           APPLY "CLOSE":U TO THIS-PROCEDURE.
           RETURN NO-APPLY.      
  END. 
  
ON VALUE-CHANGED OF BROWSE-PRIMARY IN FRAME frame_primary
  DO:
      RUN Fetch_Primary_Name.
  END.   


ON ENTRY OF name IN FRAME frame_primary
 DO:
  &IF "{&WINDOW-SYSTEM}" <> "TTY"  &THEN
  ASSIGN msg:SCREEN-VALUE IN FRAME frame_primary ="". 
  &ENDIF
 END.

ON ENTRY OF DESC_EDIT2 IN FRAME frame_primary
 DO:
  &IF "{&WINDOW-SYSTEM}" <> "TTY"  &THEN
  ASSIGN msg:SCREEN-VALUE IN FRAME frame_primary ="". 
  &ENDIF
END.

PROCEDURE Fetch_Primary_Name:
 
  DO pintSub = 1 TO pBrowse:NUM-SELECTED-ROWS : 
     
     
           pBrowse:FETCH-SELECTED-ROW(pintSub).

           pField  = pBuffer:BUFFER-FIELD( "ind" ).
           pField1 = pBuffer:BUFFER-FIELD( "pri" ).
           pField3 = pBuffer:BUFFER-FIELD( "uni" ).
           pField4 = pBuffer:BUFFER-FIELD( "man" ).
           pField5 = pBuffer:BUFFER-FIELD( "rec" ).
           
           ASSIGN Selected_Idx = pField:BUFFER-VALUE.
  
  END.
run Create_Const_Name.
END PROCEDURE.

PROCEDURE primary :
           &Scoped-define OPEN-BROWSERS-IN-QUERY-frame_primary ~
           ~{&OPEN-QUERY-BROWSE-PRIMARY}

           HIDE FRAME frame_foreign.   
           HIDE FRAME frame_unique.    
           HIDE FRAME frame_check.     
           VIEW FRAME frame_primary.
           DISPLAY  name BROWSE-PRIMARY Active DESC_EDIT2 
               &IF "{&WINDOW-SYSTEM}" <> "TTY"  &THEN msg &ENDIF           
                   WITH FRAME frame_primary.
           ASSIGN Active:SCREEN-VALUE IN FRAME frame_primary ="yes".
           ENABLE  name BROWSE-PRIMARY Active DESC_EDIT2 
                 OK_BUT CREATE_BUT CANCEL_BUT 
                 &IF "{&WINDOW-SYSTEM}" <> "TTY"
                 &THEN HELP_BUT  
                 &ENDIF
                 WITH FRAME frame_primary.
          {&OPEN-BROWSERS-IN-QUERY-frame_primary}
         
          RUN Fetch_Primary_Name.
END PROCEDURE.

PROCEDURE primary_save:
   
   IF pField3:BUFFER-VALUE = "I , C" OR pField3:BUFFER-VALUE = "C" THEN DO:
      MESSAGE "Unique constraint already exists on this Index, Primary constraint cannot be" SKIP
              "created on the same Index" VIEW-AS ALERT-BOX ERROR.
   END.
   ELSE DO:
    IF NOT CAN-FIND (FIRST DICTDB._Constraint WHERE DICTDB._Constraint._Con-Name = name:SCREEN-VALUE IN FRAME frame_primary 
                     AND DICTDB._Constraint._Db-Recid = DbRecId  AND DICTDB._constraint._Con-Status <> "O" AND
                             DICTDB._constraint._Con-Status <> "D") 
    THEN DO:
           num = num + 1.
           CREATE DICTDB._Constraint.
           ASSIGN _Con-Type = "PC".
           ASSIGN   _Con-Name = name:SCREEN-VALUE IN FRAME frame_primary
                    _For-Name = "".
           IF ACTIVE:SCREEN-VALUE IN FRAME frame_primary = "yes" THEN
           ASSIGN _Con-Active = TRUE.
           ELSE _Con-Active = FALSE.
           ASSIGN _Con-Desc = DESC_EDIT2:SCREEN-VALUE IN FRAME frame_primary
               _File-recid = file_rec
               _Con-Status = "N"
               _Index-recid = pField5:BUFFER-VALUE
               _Con-Num = num
               _db-recid = DbRecId.
          RUN TEMP1.
          RUN primary.  
          &IF "{&WINDOW-SYSTEM}" <> "TTY"  &THEN
           ASSIGN msg:SCREEN-VALUE IN FRAME frame_primary ="Constraint Created". &ENDIF  
          ASSIGN is-saved = TRUE.                         
    END.       
    ELSE
      MESSAGE "Constraint with this name already exists in the DB" VIEW-AS ALERT-BOX ERROR.               
  END.     
END PROCEDURE.           

PROCEDURE check_primary_save:
         
         IF temp.man <> "  I" THEN
             MESSAGE "For creation of Primary constraint all Columns of the Index Should be mandatory" VIEW-AS ALERT-BOX ERROR.
          
         ELSE DO: 
          FIND FIRST DICTDB._Constraint WHERE DICTDB._Constraint._File-Recid = file_rec
                               AND (DICTDB._Constraint._Con-Type = "P"  OR
                                           DICTDB._Constraint._Con-Type = "PC" OR DICTDB._Constraint._Con-Type = "MP" )
                               AND Dictdb._constraint._Con-Status <> "D" AND DICTDB._constraint._Con-Status = "O" NO-LOCK NO-ERROR.
           IF AVAILABLE (DICTDB._Constraint)THEN 
           DO:
                MESSAGE "Primary constraint already exists in this table" VIEW-AS ALERT-BOX ERROR.
           END.               
           ELSE DO:
             RUN primary_save.           
           END.
         END.

END PROCEDURE.
