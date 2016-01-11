/*********************************************************************
* Copyright (C) 2011 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: default.i

Description:   
   This file contains the form for default Constraints.

HISTORY
Author: Kumar Mayur

Date Created:08/05/2011
----------------------------------------------------------------------------*/
{prodict/mss/key/unique.i }


/* Query definitions                                                    */
DEFINE {1} QUERY BROWSE-DEFAULT FOR 
      temp2 SCROLLING.
      
      /* Browse definitions                                                   */
DEFINE {1} BROWSE BROWSE-DEFAULT
  QUERY BROWSE-DEFAULT NO-LOCK DISPLAY
      temp2.fld FORMAT "x(22)":U
      temp2.ini FORMAT "x(22)":U
      temp2.cdf FORMAT "x(250)":U

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


        DEF VAR dintSub AS INTEGER NO-UNDO.

        DEFINE VARIABLE dQuery AS HANDLE.
        DEFINE VARIABLE dBrowse AS HANDLE.
        DEFINE VARIABLE dBuffer AS HANDLE.
        DEFINE VARIABLE dField AS HANDLE.
        DEFINE VARIABLE dField1 AS HANDLE.
        DEFINE VARIABLE dField2 AS HANDLE.
        DEFINE VARIABLE dField3 AS HANDLE.

        dBrowse = BROWSE BROWSE-DEFAULT:HANDLE. /* Browse-3 is browser name */
        dQuery  = dBrowse:QUERY.
        dBuffer = dQuery:GET-BUFFER-HANDLE(1).    
    
FORM
     &IF "{&WINDOW-SYSTEM}" <> "TTY"
     &THEN   
     name AT ROW 1.46 COL 17 COLON-ALIGNED WIDGET-ID 4
     BROWSE-DEFAULT AT ROW 2.8 COL 76 RIGHT-ALIGNED WIDGET-ID 200
     Active AT ROW 7.9 COL 2 WIDGET-ID 40
     EXPRESSION AT ROW 8.9 COL 14  NO-LABEL
     DESC_EDIT AT ROW 11.5 COL 14 WIDGET-ID 36 NO-LABEL
     msg AT ROW 13.7 COL 2 WIDGET-ID 4 NO-LABEL
    
     OK_BUT AT ROW 15 COL 3
     CREATE_BUT AT ROW 15 COL 17
     CANCEL_BUT AT ROW 15 COL 31
     HELP_BUT AT ROW 15 COL 60
     "Constraint" VIEW-AS TEXT
          SIZE 11 BY .62 AT ROW 9.1 COL 2 WIDGET-ID 38     
     "Expression:" VIEW-AS TEXT
          SIZE 11 BY .62 AT ROW 9.7 COL 2 WIDGET-ID 38
     "Description:" VIEW-AS TEXT
          SIZE 11 BY .62 AT ROW 11.7 COL 2 WIDGET-ID 38          
     WITH FRAME frame_default
         NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 2.4
         SIZE 80 BY 15.14 WIDGET-ID 100.
     
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
     ASSIGN is-saved = FALSE.

     IF EXPRESSION:SCREEN-VALUE IN FRAME frame_default = "" OR EXPRESSION:SCREEN-VALUE IN FRAME frame_default = ?
     THEN MESSAGE " The constraint expression cannot be left blank" VIEW-AS ALERT-BOX ERROR.
     ELSE DO:
	   RUN default_save.
       IF is-saved THEN
        APPLY "CLOSE":U TO THIS-PROCEDURE.
        RETURN NO-APPLY.         
     END.
  END.

ON CHOOSE OF CREATE_BUT IN FRAME frame_default
 DO:
     IF EXPRESSION:SCREEN-VALUE IN FRAME frame_default = "" OR EXPRESSION:SCREEN-VALUE IN FRAME frame_default = ?
     THEN MESSAGE " The constraint expression cannot be left blank" VIEW-AS ALERT-BOX ERROR.
     ELSE RUN default_save.
 END. 
 
 
ON CHOOSE OF CANCEL_BUT IN FRAME frame_default
  DO:     
       APPLY "CLOSE":U TO THIS-PROCEDURE.
       RETURN NO-APPLY.      
  END.  

ON VALUE-CHANGED OF BROWSE-DEFAULT IN FRAME frame_default
  DO:
       RUN Fetch_Default_Name.
  END. 

ON ENTRY OF name IN FRAME frame_default
 DO:
  &IF "{&WINDOW-SYSTEM}" <> "TTY"  &THEN
  ASSIGN msg:SCREEN-VALUE IN FRAME frame_default ="". 
  &ENDIF
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

PROCEDURE Fetch_Default_Name:
 
  DO dintSub = 1 TO dBrowse:NUM-SELECTED-ROWS : 
     
     
           dBrowse:FETCH-SELECTED-ROW(dintSub).

           dField  = dBuffer:BUFFER-FIELD( "fld" ).
           dField1 = dBuffer:BUFFER-FIELD( "ini" ).
           dField2 = dBuffer:BUFFER-FIELD( "rec" ).
           dField3 = dBuffer:BUFFER-FIELD( "cdf" ).

           ASSIGN Selected_Idx = dField:BUFFER-VALUE.
           
  END.
  IF dfield3:BUFFER-VALUE <> ""
  THEN ASSIGN EXPRESSION:SCREEN-VALUE IN FRAME frame_default = dfield3:BUFFER-VALUE.
  ELSE ASSIGN EXPRESSION:SCREEN-VALUE IN FRAME frame_default = dfield1:BUFFER-VALUE.

run Create_Const_Name.
RUN default_validate.

END PROCEDURE.  

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
           ASSIGN Active:SCREEN-VALUE IN FRAME frame_default ="yes".
           ENABLE  name BROWSE-DEFAULT Active DESC_EDIT EXPRESSION 
                    OK_BUT CREATE_BUT CANCEL_BUT 
                 &IF "{&WINDOW-SYSTEM}" <> "TTY"
                 &THEN HELP_BUT  
                 &ENDIF
                    WITH FRAME frame_default.
             {&OPEN-BROWSERS-IN-QUERY-frame_default}
           RUN Fetch_Default_Name.
END PROCEDURE.

PROCEDURE default_save:
    IF NOT CAN-FIND (FIRST DICTDB._Constraint WHERE DICTDB._Constraint._Con-Name = name:SCREEN-VALUE IN FRAME frame_default 
                     AND DICTDB._Constraint._Db-Recid = DbRecId AND DICTDB._constraint._Con-Status <> "O" AND
                             DICTDB._constraint._Con-Status <> "D") 
    THEN DO:
          num = num + 1.
          IF dfield1:BUFFER-VALUE <> EXPRESSION:SCREEN-VALUE IN FRAME frame_default
          THEN message "Default Constraint added for the field " dfield:BUFFER-VALUE " but the server-side " skip
                       "constraint value is different from the Progress default value"  view-as alert-box INFORMATION.
          
          CREATE DICTDB._Constraint.
          ASSIGN _Con-Type = "D"
               _Con-Name = name:SCREEN-VALUE IN FRAME frame_default
               _For-Name = "".
          IF ACTIVE:SCREEN-VALUE IN FRAME frame_default = "yes" 
          THEN ASSIGN _Con-Active = TRUE.
          ELSE ASSIGN _Con-Active = FALSE.
          ASSIGN _Con-Desc = DESC_EDIT:SCREEN-VALUE IN FRAME frame_default
               _File-recid = file_rec
               _Con-Status = "N"
               _Con-Expr = EXPRESSION:SCREEN-VALUE IN FRAME frame_default
               _Field-recid = dfield2:BUFFER-VALUE
               _Con-Num = num
               _db-recid = DbRecId.
       RUN FILL_TEMP2.
       RUN default.  
       &IF "{&WINDOW-SYSTEM}" <> "TTY"  &THEN
       ASSIGN msg:SCREEN-VALUE IN FRAME frame_default ="Constraint Created".  &ENDIF  
     ASSIGN is-saved = TRUE.            
    END.       
    ELSE
      MESSAGE "Constraint with this name already exists in the DB" VIEW-AS ALERT-BOX ERROR.                                             
END PROCEDURE.          

PROCEDURE default_validate:
          
          FIND FIRST DICTDB._Constraint WHERE DICTDB._Constraint._Field-recid = dfield2:BUFFER-VALUE AND DICTDB._Constraint._Con-Type = "D"
          AND DICTDB._Constraint._Con-Status <> "D" AND DICTDB._Constraint._Con-Status <> "O" AND DICTDB._constraint._Db-Recid = DbRecid
          NO-LOCK NO-ERROR.
          IF AVAILABLE (DICTDB._Constraint)
          THEN DO:
                DISABLE OK_BUT CREATE_BUT WITH FRAME frame_default.
               END.
          ELSE 
               ENABLE OK_BUT CREATE_BUT WITH FRAME frame_default.
         
END PROCEDURE.         
