/*********************************************************************
* Copyright (C) 2011 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: modcheck.i

Description:   
   This file contains the form for modification of Check Constraints.

HISTORY
Author: Kumar Mayur

Date Created:08/05/2011
----------------------------------------------------------------------------*/
{prodict/ora/key/moduni.i }


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

FORM
     &IF "{&WINDOW-SYSTEM}" <> "TTY"
     &THEN 
     name AT ROW 1.46 COL 17 COLON-ALIGNED WIDGET-ID 4
     BROWSE-CHECK AT ROW 2.6 COL 76 RIGHT-ALIGNED WIDGET-ID 200
     Active AT ROW 6.3 COL 2 WIDGET-ID 40
     EXPRESSION AT ROW 7.1 COL 14 NO-LABEL
     VALIDATE AT ROW 9.2 COL 14 NO-LABEL
     DESC_EDIT AT ROW 11.8 COL 14 WIDGET-ID 36 NO-LABEL
     msg AT ROW 14 COL 2 WIDGET-ID 4 NO-LABEL
    
     OK_BUT AT ROW 15 COL 3 WIDGET-ID 26
     CREATE_BUT AT ROW 15 COL 17 WIDGET-ID 28
     CANCEL_BUT AT ROW 15 COL 31 WIDGET-ID 30
     HELP_BUT AT ROW 15 COL 60 WIDGET-ID 32
     "Constraint" VIEW-AS TEXT
          SIZE 11 BY .62 AT ROW 7.3 COL 2 WIDGET-ID 38
     "Expression:" VIEW-AS TEXT
          SIZE 11 BY .62 AT ROW 7.9 COL 2 WIDGET-ID 38 
     "Validation" VIEW-AS TEXT
          SIZE 11 BY .62 AT ROW 9.4 COL 2 WIDGET-ID 38
     "Expression:" VIEW-AS TEXT
          SIZE 11 BY .62 AT ROW 10.1 COL 2 WIDGET-ID 38
     "Description:" VIEW-AS TEXT
          SIZE 11 BY .62 AT ROW 12 COL 2 WIDGET-ID 38  

     WITH FRAME frame_check
         NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 3
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
                          
 ASSIGN BROWSE-CHECK:COLUMN-RESIZABLE IN FRAME frame_check        = TRUE.         


ON CHOOSE OF OK_BUT IN FRAME frame_check
  DO:          
          RUN check_save.
          APPLY "CLOSE":U TO THIS-PROCEDURE.
          RETURN NO-APPLY.                   
  END.
ON CHOOSE OF CREATE_BUT IN FRAME frame_check
 DO:
          RUN check_save.
          RUN FILL_TEMP2.
          RUN check.
          &IF "{&WINDOW-SYSTEM}" <> "TTY"  &THEN
          ASSIGN msg:SCREEN-VALUE ="Constraint Modified".  &ENDIF 
 END. 
 
 
ON CHOOSE OF CANCEL_BUT IN FRAME frame_check
  DO:     
           APPLY "CLOSE":U TO THIS-PROCEDURE.
           RETURN NO-APPLY.      
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

PROCEDURE check :
           &Scoped-define OPEN-BROWSERS-IN-QUERY-frame_check~
           ~{&OPEN-QUERY-BROWSE-CHECK}
           
           HIDE FRAME frame_foreign.   
           HIDE FRAME frame_primary. 
           
           HIDE FRAME frame_unique.
           VIEW FRAME frame_check. 
           DISPLAY NAME BROWSE-CHECK Active DESC_EDIT EXPRESSION  VALIDATE 
               &IF "{&WINDOW-SYSTEM}" <> "TTY"  &THEN msg &ENDIF           
                    WITH FRAME frame_check.
           ASSIGN name:SCREEN-VALUE IN FRAME frame_check =  constr_name.
           IF act = "t" THEN Active:SCREEN-VALUE IN FRAME frame_check ="yes".
           IF chek <> "" THEN EXPRESSION:SCREEN-VALUE IN FRAME frame_check = chek.
           ASSIGN DESC_EDIT:SCREEN-VALUE IN FRAME frame_check = descrip.
           ENABLE BROWSE-CHECK Active DESC_EDIT EXPRESSION
                    OK_BUT CREATE_BUT CANCEL_BUT  
                 &IF "{&WINDOW-SYSTEM}" <> "TTY"
                 &THEN HELP_BUT  
                 &ENDIF 
                    WITH FRAME frame_check.
           {&OPEN-BROWSERS-IN-QUERY-frame_check}
        FIND FIRST  _constraint where _con-name = constr_name AND DICTDB._Constraint._Db-Recid = DbRecid NO-LOCK NO-ERROR.
        FOR EACH temp2 WHERE rec = _constraint._field-recid NO-LOCK:
           curr-rec = ROWID(temp2).
           REPOSITION BROWSE-CHECK TO ROWID curr-rec.
        END.
END PROCEDURE.

PROCEDURE check_save:
    FOR EACH _constraint where _con-name = constr_name AND DICTDB._constraint._Db-Recid = DbRecid:
      IF EXPRESSION:SCREEN-VALUE IN FRAME frame_check <> _Con-Expr THEN 
      MESSAGE "Check Constraint expression changed" VIEW-AS ALERT-BOX INFORMATION.

      IF ACTIVE:SCREEN-VALUE IN FRAME frame_check = "yes" THEN
         ASSIGN _Con-Active = TRUE.
      ELSE ASSIGN _Con-Active = FALSE.
         ASSIGN _Con-Desc = DESC_EDIT:SCREEN-VALUE IN FRAME frame_check. 
         ASSIGN _Con-Status = "C"
                _Con-Expr = EXPRESSION:SCREEN-VALUE IN FRAME frame_check.         
    END.  
END.          
