/*********************************************************************
* Copyright (C) 2011 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: check.i

Description:   
   This file contains the form for creating check Constraints.

Author: Kumar Mayur

Date Created:08/05/2011
----------------------------------------------------------------------------*/
{prodict/mss/key/default.i }

/* Query definitions                                                    */
DEFINE {1} QUERY BROWSE-CHECK FOR 
      temp2 SCROLLING.
      
      /* Browse definitions                                                   */
DEFINE {1} BROWSE BROWSE-CHECK
  QUERY BROWSE-CHECK NO-LOCK DISPLAY
      temp2.fld FORMAT "x(33)":U
      temp2.chk FORMAT "x(33)":U

  WITH NO-ROW-MARKERS SEPARATORS 
  &IF "{&WINDOW-SYSTEM}" <> "TTY"
  &THEN SIZE 75 BY 3.32 FIT-LAST-COLUMN.
  &ELSE SIZE 75 BY 6 FIT-LAST-COLUMN.
  &ENDIF
  /*    DEFINATION FOR CHECK FRAME  */  
&Scoped-define FRAME-NAME frame_check
&Scoped-define BROWSE-NAME BROWSE-CHECK
&Scoped-define FIELDS-IN-QUERY-BROWSE-CHECK temp2.fld temp2.chk 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-CHECK 
&Scoped-define QUERY-STRING-BROWSE-CHECK FOR EACH temp2 NO-LOCK.    
&Scoped-define OPEN-QUERY-BROWSE-CHECK OPEN QUERY BROWSE-CHECK FOR EACH temp2 NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-CHECK temp2
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-CHECK temp2

        
        DEF VAR chintSub AS INTEGER NO-UNDO.

        DEFINE VARIABLE chQuery  AS HANDLE.
        DEFINE VARIABLE chBrowse AS HANDLE.
        DEFINE VARIABLE chBuffer AS HANDLE.
        DEFINE VARIABLE chField  AS HANDLE.
        DEFINE VARIABLE chField1 AS HANDLE.
        DEFINE VARIABLE chField2 AS HANDLE.
        DEFINE VARIABLE chField3 AS HANDLE.
        
        chBrowse = BROWSE BROWSE-CHECK:HANDLE. /* Browse-3 is browser name */
        chQuery  = chBrowse:QUERY.
        chBuffer = chQuery:GET-BUFFER-HANDLE(1).    
    
FORM
     &IF "{&WINDOW-SYSTEM}" <> "TTY"
     &THEN 
     name AT ROW 1.46 COL 17 COLON-ALIGNED WIDGET-ID 4
     BROWSE-CHECK AT ROW 2.6 COL 76 RIGHT-ALIGNED WIDGET-ID 200
     Active AT ROW 6.3 COL 2 WIDGET-ID 40
     EXPRESSION AT ROW 7.1 COL 14 NO-LABEL
     VALIDATE AT ROW 9.2 COL 14 NO-LABEL
     DESC_EDIT AT ROW 11.8 COL 14 NO-LABEL
     msg AT ROW 14 COL 2 WIDGET-ID 4  NO-LABEL
    
     OK_BUT AT ROW 15 COL 3
     CREATE_BUT AT ROW 15 COL 17
     CANCEL_BUT AT ROW 15 COL 31
     HELP_BUT AT ROW 15 COL 60
     "Constraint" VIEW-AS TEXT
          SIZE 11 BY .62 AT ROW 7.3 COL 2 WIDGET-ID 38
     "Expression:" VIEW-AS TEXT
          SIZE 11 BY .62 AT ROW 7.9 COL 2 WIDGET-ID 38 
     "Validation" VIEW-AS TEXT
          SIZE 11 BY .62 AT ROW 9.4 COL 2 WIDGET-ID 38
     "Expression:" VIEW-AS TEXT
          SIZE 11 BY .62 AT ROW 10 COL 2 WIDGET-ID 38
     "Description:" VIEW-AS TEXT
          SIZE 11 BY .62 AT ROW 12 COL 2 WIDGET-ID 38              

     WITH FRAME frame_check
         NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 2.4
         SIZE 80 BY 15.14 WIDGET-ID 100.
    &ELSE
     name AT ROW 2 COL 17 COLON-ALIGNED WIDGET-ID 4
     BROWSE-CHECK AT ROW 3.2 COL 76 RIGHT-ALIGNED WIDGET-ID 200
     Active AT ROW 9 COL 2 WIDGET-ID 40
     EXPRESSION AT ROW 10.4 COL 2 
     VALIDATE AT ROW 13.4 COL 2.3
     DESC_EDIT AT ROW 16.4 COL 2 WIDGET-ID 36
    
     OK_BUT AT ROW 20 COL 18 WIDGET-ID 26
     CREATE_BUT AT ROW 20 COL 35 WIDGET-ID 28
     CANCEL_BUT AT ROW 20 COL 52 WIDGET-ID 30  
    
     "Expression" VIEW-AS TEXT
          SIZE 11 BY .62 AT ROW 11.4 COL 2 WIDGET-ID 38
     "Expression" VIEW-AS TEXT
          SIZE 11 BY .62 AT ROW 14.4 COL 2 WIDGET-ID 38
     WITH FRAME frame_check
         NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 3
         SIZE 80 BY 21 WIDGET-ID 100.
    &ENDIF       
                          
 ASSIGN 
      
       BROWSE-CHECK:COLUMN-RESIZABLE IN FRAME frame_check        = TRUE.        


ON CHOOSE OF OK_BUT IN FRAME frame_check
  DO:          
       ASSIGN is-saved = FALSE.
       RUN check_save.
     IF is-saved THEN
       APPLY "CLOSE":U TO THIS-PROCEDURE.
       RETURN NO-APPLY.                   
  END.

ON CHOOSE OF CREATE_BUT IN FRAME frame_check
 DO:
       RUN check_save.
 END. 
 
 
ON CHOOSE OF CANCEL_BUT IN FRAME frame_check
  DO:     
       APPLY "CLOSE":U TO THIS-PROCEDURE.
       RETURN NO-APPLY.      
  END.  

ON VALUE-CHANGED OF BROWSE-CHECK IN FRAME frame_check
  DO:
      RUN Fetch_Check_Name.
  END. 

ON ENTRY OF name IN FRAME frame_check
 DO:
  &IF "{&WINDOW-SYSTEM}" <> "TTY"  &THEN
  ASSIGN msg:SCREEN-VALUE IN FRAME frame_check ="". 
  &ENDIF
 END.

ON ENTRY OF EXPRESSION IN FRAME frame_check
 DO:
  &IF "{&WINDOW-SYSTEM}" <> "TTY"  &THEN
  ASSIGN msg:SCREEN-VALUE IN FRAME frame_check ="". 
  &ENDIF
 END.

ON ENTRY OF DESC_EDIT IN FRAME frame_check
 DO:
  &IF "{&WINDOW-SYSTEM}" <> "TTY"  &THEN
  ASSIGN msg:SCREEN-VALUE IN FRAME frame_check ="". 
  &ENDIF
END. 

PROCEDURE Fetch_Check_Name:
 
  DO chintSub = 1 TO chBrowse:NUM-SELECTED-ROWS : 
     
     
     chBrowse:FETCH-SELECTED-ROW(chintSub).

     chField  = chBuffer:BUFFER-FIELD( "fld" ).
     chField1 = chBuffer:BUFFER-FIELD( "chk" ).
     chField2 = chBuffer:BUFFER-FIELD( "rec" ).
     chField3 = chBuffer:BUFFER-FIELD( "exp" ).
         
     ASSIGN Selected_Idx = chField:BUFFER-VALUE.
  
  END.
  ASSIGN VALIDATE:SCREEN-VALUE IN FRAME frame_check = chField3:BUFFER-VALUE.
  ASSIGN EXPRESSION:SCREEN-VALUE IN FRAME frame_check = chField1:BUFFER-VALUE. 
run Create_Const_Name.
END PROCEDURE.  

PROCEDURE check :
           &Scoped-define OPEN-BROWSERS-IN-QUERY-frame_check~
           ~{&OPEN-QUERY-BROWSE-CHECK}
           
           HIDE FRAME frame_clustered.
           HIDE FRAME frame_foreign.   
           HIDE FRAME frame_primary. 
           
           HIDE FRAME frame_unique.
           HIDE FRAME frame_default.
           VIEW FRAME frame_check. 
           DISPLAY NAME BROWSE-CHECK Active DESC_EDIT EXPRESSION  VALIDATE 
               &IF "{&WINDOW-SYSTEM}" <> "TTY"  &THEN msg &ENDIF
                    WITH FRAME frame_check.
           ASSIGN Active:SCREEN-VALUE IN FRAME frame_check ="yes".
           ENABLE name BROWSE-CHECK Active DESC_EDIT EXPRESSION
                  OK_BUT CREATE_BUT CANCEL_BUT 
                  &IF "{&WINDOW-SYSTEM}" <> "TTY"
                  &THEN HELP_BUT  
                  &ENDIF
                  WITH FRAME frame_check.
           {&OPEN-BROWSERS-IN-QUERY-frame_check}
           RUN Fetch_Check_Name.
END PROCEDURE.

PROCEDURE check_save:

    IF NOT CAN-FIND (FIRST DICTDB._Constraint WHERE DICTDB._Constraint._Con-Name = name:SCREEN-VALUE IN FRAME frame_check 
                     AND DICTDB._Constraint._Db-Recid = DbRecId AND DICTDB._constraint._Con-Status <> "O" AND
                             DICTDB._constraint._Con-Status <> "D") 
    THEN DO:
          num = num + 1.
          CREATE DICTDB._Constraint.
          ASSIGN _Con-Type = "C"
               _Con-Name = name:SCREEN-VALUE IN FRAME frame_check
               _For-Name = "".
          IF ACTIVE:SCREEN-VALUE IN FRAME frame_check = "yes" 
          THEN ASSIGN _Con-Active = TRUE.
          ELSE ASSIGN _Con-Active = FALSE.
          ASSIGN _Con-Desc = DESC_EDIT:SCREEN-VALUE IN FRAME frame_check
               _File-recid = file_rec
               _Con-Status = "N"
               _Con-Expr = EXPRESSION:SCREEN-VALUE IN FRAME frame_check
               _Field-recid = chField2:BUFFER-VALUE
               _Con-Num = num
               _db-recid = DbRecId.
       RUN FILL_TEMP2.
       RUN check.
       &IF "{&WINDOW-SYSTEM}" <> "TTY"  &THEN
       ASSIGN msg:SCREEN-VALUE IN FRAME frame_check ="Constraint Created".  &ENDIF 
     ASSIGN is-saved = TRUE.           
    END.       
    ELSE
      MESSAGE "Constraint with this name already exists in the DB" VIEW-AS ALERT-BOX ERROR.               
         
END.  

PROCEDURE check_validate:
        FIND FIRST DICTDB._Constraint WHERE DICTDB._Constraint._Field-Recid = chField2:BUFFER-VALUE AND DICTDB._Constraint._Con-Type = "C"
        AND DICTDB._Constraint._Con-Status <> "D" AND DICTDB._Constraint._Con-Status <> "O" AND DICTDB._constraint._Db-Recid = DbRecid
        NO-LOCK NO-ERROR.
        IF AVAILABLE (DICTDB._Constraint)
        THEN DISABLE OK_BUT CREATE_BUT WITH FRAME frame_check.
        ELSE ENABLE OK_BUT CREATE_BUT WITH FRAME frame_check.
END PROCEDURE.
