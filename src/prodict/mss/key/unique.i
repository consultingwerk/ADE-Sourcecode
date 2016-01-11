/*********************************************************************
* Copyright (C) 2011 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: unique.i

Description:   
   This file contains the form for unique Constraints.

HISTORY
Author: Kumar Mayur

Date Created:08/05/2011
----------------------------------------------------------------------------*/
{prodict/mss/key/clust.i }


/* Query definitions                                                    */
DEFINE {1} QUERY BROWSE-UNIQUE FOR 
      temp SCROLLING.
      
      /* Browse definitions                                                   */
DEFINE {1} BROWSE BROWSE-UNIQUE
  QUERY BROWSE-UNIQUE NO-LOCK DISPLAY
      temp.ind FORMAT "x(16)":U
      temp.pri FORMAT "x(8)":U
      temp.uni FORMAT "x(8)":U
      temp.clu FORMAT "x(8)":U
      temp.man FORMAT "x(10)":U
  WITH NO-ROW-MARKERS SEPARATORS
    &IF "{&WINDOW-SYSTEM}" <> "TTY"
    &THEN SIZE 75 BY 4.52 FIT-LAST-COLUMN.
    &ELSE SIZE 75 BY 8.3 FIT-LAST-COLUMN.
    &ENDIF 

/*    DEFINATION FOR UNIQUE FRAME  */  
&Scoped-define FRAME-NAME frame_unique 
&Scoped-define BROWSE-NAME BROWSE-UNIQUE
&Scoped-define FIELDS-IN-QUERY-BROWSE-UNIQUE temp.pri temp.uni temp.ind temp.clu temp.man
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-UNIQUE 
&Scoped-define QUERY-STRING-BROWSE-UNIQUE FOR EACH temp NO-LOCK.    
&Scoped-define OPEN-QUERY-BROWSE-UNIQUE OPEN QUERY BROWSE-UNIQUE FOR EACH temp NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-UNIQUE temp
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-UNIQUE temp
        
        DEF VAR uintSub AS INTEGER NO-UNDO.
        DEF VAR irec AS INTEGER   NO-UNDO.

        DEFINE VARIABLE uQuery AS HANDLE.
        DEFINE VARIABLE uBrowse AS HANDLE.
        DEFINE VARIABLE uBuffer AS HANDLE.
        DEFINE VARIABLE uField AS HANDLE.
        DEFINE VARIABLE uField1 AS HANDLE.
        DEFINE VARIABLE uField2 AS HANDLE.
        DEFINE VARIABLE uField3 AS HANDLE.
        DEFINE VARIABLE uField4 AS HANDLE.
        DEFINE VARIABLE uField5 AS HANDLE.
        
        uBrowse = BROWSE BROWSE-UNIQUE:HANDLE. /* Browse-3 is browser name */
        uQuery  = uBrowse:QUERY.
        uBuffer = uQuery:GET-BUFFER-HANDLE(1).    
    
FORM
     &IF "{&WINDOW-SYSTEM}" <> "TTY"
     &THEN
     name AT ROW 1.46 COL 17 COLON-ALIGNED WIDGET-ID 4
     BROWSE-UNIQUE AT ROW 3.36 COL 76 RIGHT-ALIGNED WIDGET-ID 200
     Active AT ROW 8.6 COL 2 WIDGET-ID 40
     DESC_EDIT2 AT ROW 10 COL 14 WIDGET-ID 36 NO-LABEL
     msg AT ROW 12.1 COL 2 WIDGET-ID 4 NO-LABEL
     OK_BUT AT ROW 13.3 COL 3
     CREATE_BUT AT ROW 13.3 COL 17
     CANCEL_BUT AT ROW 13.3 COL 31
     HELP_BUT  AT ROW 13.3 COL 60
     "Description:" VIEW-AS TEXT
          SIZE 11 BY .62 AT ROW 10.2 COL 2 WIDGET-ID 38
     "I  - Indicates Progress Index Property" VIEW-AS TEXT
          SIZE 50 BY .62 AT ROW 14.5 COL 2 WIDGET-ID 600
     "C - Indicates Constraint Property" VIEW-AS TEXT
          SIZE 50 BY .62 AT ROW 15.3 COL 2 WIDGET-ID 600
     WITH FRAME frame_unique
         NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 2.4
         SIZE 80 BY 16 WIDGET-ID 100.
     
     &ELSE
     name AT ROW 2 COL 17 COLON-ALIGNED WIDGET-ID 4
     BROWSE-UNIQUE AT ROW 3.76 COL 76 RIGHT-ALIGNED WIDGET-ID 200
     Active AT ROW 13 COL 2 WIDGET-ID 40
     DESC_EDIT2 AT ROW 15 COL 2 WIDGET-ID 36
     OK_BUT AT ROW 20 COL 18 WIDGET-ID 26
     CREATE_BUT AT ROW 20 COL 35 WIDGET-ID 28
     CANCEL_BUT AT ROW 20 COL 52 WIDGET-ID 30
     WITH FRAME frame_unique
         NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 3
         SIZE 80 BY 21 WIDGET-ID 100.   
     &ENDIF                  
 ASSIGN BROWSE-UNIQUE:COLUMN-RESIZABLE IN FRAME frame_unique        = TRUE.         
 

ON CHOOSE OF OK_BUT IN FRAME frame_unique
  DO: 
          ASSIGN is-saved = FALSE.
          RUN unique_save.
     IF is-saved THEN
          APPLY "CLOSE":U TO THIS-PROCEDURE.
          RETURN NO-APPLY.         
  END.

ON CHOOSE OF CREATE_BUT IN FRAME frame_unique
 DO:
          RUN unique_save. 
 END. 
 
 
ON CHOOSE OF CANCEL_BUT IN FRAME frame_unique
  DO:     
           APPLY "CLOSE":U TO THIS-PROCEDURE.
           RETURN NO-APPLY.      
  END.
    
  ON VALUE-CHANGED OF BROWSE-UNIQUE IN FRAME frame_unique
  DO:
      
      RUN unique_validate.
      RUN Fetch_Unique_Name.
  END. 

ON ENTRY OF name IN FRAME frame_unique
 DO:
  &IF "{&WINDOW-SYSTEM}" <> "TTY"  &THEN
  ASSIGN msg:SCREEN-VALUE IN FRAME frame_unique ="". 
  &ENDIF
 END.

ON ENTRY OF DESC_EDIT2 IN FRAME frame_unique
 DO:
  &IF "{&WINDOW-SYSTEM}" <> "TTY"  &THEN
  ASSIGN msg:SCREEN-VALUE IN FRAME frame_unique ="". 
  &ENDIF
END.

PROCEDURE Fetch_Unique_Name:
 
  DO uintSub = 1 TO uBrowse:NUM-SELECTED-ROWS : 
     
     
           uBrowse:FETCH-SELECTED-ROW(uintSub).

           uField  = uBuffer:BUFFER-FIELD( "ind" ).
           uField1 = uBuffer:BUFFER-FIELD( "pri" ).
           uField2 = uBuffer:BUFFER-FIELD( "clu" ).
           uField3 = uBuffer:BUFFER-FIELD( "uni" ).
           uField4 = uBuffer:BUFFER-FIELD( "man" ).
           uField5 = uBuffer:BUFFER-FIELD( "rec" ).
           
           ASSIGN Selected_Idx = uField:BUFFER-VALUE.
  
  END.
run Create_Const_Name.
END PROCEDURE.  

PROCEDURE unique :
           &Scoped-define OPEN-BROWSERS-IN-QUERY-frame_unique ~
           ~{&OPEN-QUERY-BROWSE-UNIQUE}
           
           HIDE FRAME frame_clustered.
           HIDE FRAME frame_foreign.   
           HIDE FRAME frame_primary.  
           HIDE FRAME frame_default.  
           HIDE FRAME frame_check.  
           VIEW FRAME frame_unique.
           DISPLAY name BROWSE-UNIQUE Active DESC_EDIT2 
               &IF "{&WINDOW-SYSTEM}" <> "TTY"  &THEN msg &ENDIF           
                    WITH FRAME frame_unique.
           ASSIGN Active:SCREEN-VALUE IN FRAME frame_unique ="yes".
           ENABLE name BROWSE-UNIQUE Active DESC_EDIT2 
                    OK_BUT CREATE_BUT CANCEL_BUT 
                 &IF "{&WINDOW-SYSTEM}" <> "TTY"
                 &THEN HELP_BUT  
                 &ENDIF 
                  WITH FRAME frame_unique.
            {&OPEN-BROWSERS-IN-QUERY-frame_unique}
           
           RUN Fetch_Unique_Name.           
           RUN unique_validate.
END PROCEDURE.

PROCEDURE unique_save:

 IF index(trim(temp.uni),"I") = 0 THEN
    MESSAGE "Only Unique indexes are eligible candidates." VIEW-AS ALERT-BOX ERROR.
 ELSE DO:
    IF NOT CAN-FIND (FIRST DICTDB._Constraint WHERE DICTDB._Constraint._Con-Name = name:SCREEN-VALUE IN FRAME frame_unique 
                     AND DICTDB._Constraint._Db-Recid = DbRecId AND DICTDB._constraint._Con-Status <> "O" AND
                             DICTDB._constraint._Con-Status <> "D") 
    THEN DO:          
          num = num + 1.
          CREATE DICTDB._Constraint.
          ASSIGN _Con-Type = "U"
               _Con-Name = name:SCREEN-VALUE IN FRAME frame_unique
               _For-Name = "".
          IF ACTIVE:SCREEN-VALUE IN FRAME frame_unique = "yes"
          THEN ASSIGN _Con-Active = TRUE.
          ELSE ASSIGN _Con-Active = FALSE.
          ASSIGN _Con-Desc = DESC_EDIT2:SCREEN-VALUE IN FRAME frame_unique
               _File-recid = file_rec
               _Con-Status = "N"
               _Index-recid = uField5:BUFFER-VALUE
               _Con-Num = num
               _db-recid = DbRecId.
       RUN TEMP1.
       RUN unique.    
       &IF "{&WINDOW-SYSTEM}" <> "TTY"  &THEN
       ASSIGN msg:SCREEN-VALUE IN FRAME frame_unique ="Constraint Created".  &ENDIF  
     ASSIGN is-saved = TRUE.              
    END.       
    ELSE
      MESSAGE "Constraint with this name already exists in the DB" VIEW-AS ALERT-BOX ERROR.                 
  END.
END.          
          
PROCEDURE unique_validate:
         
    FIND FIRST DICTDB._Constraint WHERE DICTDB._Constraint._Index-Recid = uField5:BUFFER-VALUE AND(DICTDB._Constraint._con-type = "U" OR
         DICTDB._Constraint._con-type = "P" OR DICTDB._Constraint._con-type = "PC" OR DICTDB._Constraint._con-type = "MP")
         AND (DICTDB._Constraint._Con-Status <> "D" AND DICTDB._Constraint._Con-Status <> "O") AND DICTDB._constraint._Db-Recid = DbRecid
    NO-LOCK NO-ERROR.
    IF AVAILABLE (DICTDB._Constraint) 
    THEN DO:
       DISABLE OK_BUT WITH FRAME frame_unique.
       DISABLE CREATE_BUT WITH FRAME frame_unique.
    END.   
    ELSE
       ENABLE  OK_BUT CREATE_BUT WITH FRAME frame_unique.
END.         
          
