/*********************************************************************
* Copyright (C) 2011 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: moddef.i

Description:   
   This file contains the form for modification of default Constraints.

HISTORY
Author: Kumar Mayur

Date Created:08/05/2011
----------------------------------------------------------------------------*/

{prodict/mss/key/moduni.i }

/* Query definitions                                                    */
DEFINE {1} QUERY BROWSE-DEFAULT FOR 
      temp2 SCROLLING.
      
      /* Browse definitions                                                   */
DEFINE {1} BROWSE BROWSE-DEFAULT
  QUERY BROWSE-DEFAULT NO-LOCK DISPLAY
      temp2.fld FORMAT "x(22)":U
      temp2.ini FORMAT "x(22)":U
      temp2.cdf FORMAT "x(22)":U

  WITH NO-ROW-MARKERS SEPARATORS 
  &IF "{&WINDOW-SYSTEM}" <> "TTY"
  &THEN SIZE 75 BY  4.52 FIT-LAST-COLUMN.
  &ELSE SIZE 75 BY 7 FIT-LAST-COLUMN.
  &ENDIF      

/*    DEFINATION FOR DEFAULT FRAME  */  

&Scoped-define FRAME-NAME frame_default 
&Scoped-define BROWSE-NAME BROWSE-DEFAULT
&Scoped-define FIELDS-IN-QUERY-BROWSE-DEFAULT temp2.fld temp2.ini 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-DEFAULT 
&Scoped-define QUERY-STRING-BROWSE-DEFAULT FOR EACH temp2 NO-LOCK.    
&Scoped-define OPEN-QUERY-BROWSE-DEFAULT OPEN QUERY BROWSE-DEFAULT FOR EACH temp2 NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-DEFAULT temp2
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-DEFAULT temp2

FORM
     &IF "{&WINDOW-SYSTEM}" <> "TTY"
     &THEN   
     name AT ROW 1.46 COL 17 COLON-ALIGNED WIDGET-ID 4
     BROWSE-DEFAULT AT ROW 2.8 COL 76 RIGHT-ALIGNED WIDGET-ID 200
     Active AT ROW 7.9 COL 2 WIDGET-ID 40
     EXPRESSION AT ROW 8.9 COL 14 NO-LABEL
     DESC_EDIT AT ROW 11.5 COL 14 WIDGET-ID 36 NO-LABEL
     msg AT ROW 13.7 COL 2 WIDGET-ID 4 NO-LABEL
    
     OK_BUT AT ROW 15 COL 3
     CREATE_BUT AT ROW 15 COL 17
     CANCEL_BUT AT ROW 15 COL 31
     HELP_BUT AT ROW 15 COL 60
     "Description:" VIEW-AS TEXT
          SIZE 11 BY .62 AT ROW 11.7 COL 2 WIDGET-ID 38
     "Constraint" VIEW-AS TEXT
          SIZE 11 BY .62 AT ROW 9.1 COL 2 WIDGET-ID 38
     "Expression" VIEW-AS TEXT
          SIZE 11 BY .62 AT ROW 9.8 COL 2 WIDGET-ID 38
     WITH FRAME frame_default
         NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 2.4
         SIZE 80 BY 16 WIDGET-ID 100.
     
     &ELSE
     name AT ROW 2 COL 17 COLON-ALIGNED WIDGET-ID 4
     BROWSE-DEFAULT AT ROW 3.76 COL 76 RIGHT-ALIGNED WIDGET-ID 200
     Active AT ROW 11 COL 2 WIDGET-ID 40
     EXPRESSION AT ROW 12.5 COL 2 
     DESC_EDIT AT ROW 16 COL 2 WIDGET-ID 36
    
     OK_BUT AT ROW 20 COL 18 WIDGET-ID 26
     CREATE_BUT AT ROW 20 COL 35 WIDGET-ID 28
     CANCEL_BUT AT ROW 20 COL 52 WIDGET-ID 30
     "Expression" VIEW-AS TEXT
          SIZE 11 BY .62 AT ROW 13.5 COL 2 WIDGET-ID 38
     WITH FRAME frame_default
         NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 3
         SIZE 80 BY 21 WIDGET-ID 100.
     &ENDIF        
                          
 ASSIGN BROWSE-DEFAULT:COLUMN-RESIZABLE IN FRAME frame_default        = TRUE.         


ON CHOOSE OF OK_BUT IN FRAME frame_default
  DO:          
     IF EXPRESSION:SCREEN-VALUE IN FRAME frame_default = "" OR EXPRESSION:SCREEN-VALUE IN FRAME frame_default = ?
     THEN MESSAGE " The constraint expression cannot be left blank" VIEW-AS ALERT-BOX ERROR.
     ELSE DO:
          RUN default_save.
          APPLY "CLOSE":U TO THIS-PROCEDURE.
          RETURN NO-APPLY.         
     END.     
  END.

ON CHOOSE OF CREATE_BUT IN FRAME frame_default
 DO:
     IF EXPRESSION:SCREEN-VALUE IN FRAME frame_default = "" OR EXPRESSION:SCREEN-VALUE IN FRAME frame_default = ?
     THEN MESSAGE " The constraint expression cannot be left blank" VIEW-AS ALERT-BOX ERROR.
     ELSE DO:
          RUN default_save.
          RUN FILL_TEMP2.
          RUN default.
     END.      
 END. 
 
 
ON CHOOSE OF CANCEL_BUT IN FRAME frame_default
  DO:     
           APPLY "CLOSE":U TO THIS-PROCEDURE.
           RETURN NO-APPLY.      
  END.  

ON ENTRY OF EXPRESSION IN FRAME frame_default
 DO:
  &IF "{&WINDOW-SYSTEM}" <> "TTY"  &THEN
  ASSIGN msg:SCREEN-VALUE IN FRAME frame_default ="". 
  &ENDIF
 END.

ON ENTRY OF DESC_EDIT IN FRAME frame_default
 DO:
  &IF "{&WINDOW-SYSTEM}" <> "TTY"  &THEN
  ASSIGN msg:SCREEN-VALUE IN FRAME frame_default ="". 
  &ENDIF
END. 
 
PROCEDURE default :
           &Scoped-define OPEN-BROWSERS-IN-QUERY-frame_default ~
           ~{&OPEN-QUERY-BROWSE-DEFAULT}
           
           HIDE FRAME frame_clustered.
           HIDE FRAME frame_foreign.   
           HIDE FRAME frame_primary. 
           
           HIDE FRAME frame_unique.
           HIDE FRAME frame_check.
           VIEW FRAME frame_default. 
           DISPLAY name BROWSE-DEFAULT Active DESC_EDIT EXPRESSION 
               &IF "{&WINDOW-SYSTEM}" <> "TTY"  &THEN msg &ENDIF           
                   WITH FRAME frame_default.
           ASSIGN name:SCREEN-VALUE IN FRAME frame_default =  constr_name.
           IF act = "t" THEN Active:SCREEN-VALUE IN FRAME frame_default ="yes".
           IF chek <> "" THEN EXPRESSION:SCREEN-VALUE IN FRAME frame_default = chek.
           ASSIGN DESC_EDIT:SCREEN-VALUE IN FRAME frame_default = descrip.

           IF user_dbtype    NE "MSS" then
              ENABLE   BROWSE-DEFAULT Active DESC_EDIT EXPRESSION 
                    OK_BUT CREATE_BUT CANCEL_BUT 
                 &IF "{&WINDOW-SYSTEM}" <> "TTY"
                 &THEN HELP_BUT  
                 &ENDIF 
                    WITH FRAME frame_default.
           ELSE
               ENABLE   BROWSE-DEFAULT DESC_EDIT 
                    OK_BUT CREATE_BUT CANCEL_BUT 
                 &IF "{&WINDOW-SYSTEM}" <> "TTY"
                 &THEN HELP_BUT  
                 &ENDIF 
                    WITH FRAME frame_default.
             {&OPEN-BROWSERS-IN-QUERY-frame_default}
        FIND FIRST DICTDB._constraint where _con-name = constr_name AND DICTDB._constraint._Db-Recid =DbRecid NO-LOCK NO-ERROR.
        FOR EACH temp2 WHERE rec = DICTDB._constraint._field-recid NO-LOCK:
           curr-rec = ROWID(temp2).
           REPOSITION BROWSE-DEFAULT TO ROWID curr-rec.
        END.               
END PROCEDURE.

PROCEDURE default_save:
     FOR EACH DICTDB._constraint where _con-name = constr_name AND DICTDB._constraint._Db-Recid =DbRecid:
         IF EXPRESSION:SCREEN-VALUE IN FRAME frame_default <> DICTDB._constraint._Con-Expr AND
            EXPRESSION:SCREEN-VALUE IN FRAME frame_default <> ""
         THEN DO:
          MESSAGE "Default constraint expression changed" VIEW-AS ALERT-BOX INFORMATION.
          IF ACTIVE:SCREEN-VALUE IN FRAME frame_default= "yes" THEN
          ASSIGN _Con-Active = TRUE.
          ELSE ASSIGN _Con-Active = FALSE.
          ASSIGN _Con-Desc = DESC_EDIT:SCREEN-VALUE IN FRAME frame_default. 
          ASSIGN _Con-Status = "C"
                 _Con-Expr = EXPRESSION:SCREEN-VALUE IN FRAME frame_default.   
                 
          &IF "{&WINDOW-SYSTEM}" <> "TTY"  &THEN
          ASSIGN msg:SCREEN-VALUE ="Constraint Modified".  &ENDIF                                    
         END.
     END.  
END.   
