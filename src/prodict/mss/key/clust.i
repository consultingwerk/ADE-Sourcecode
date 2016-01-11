/*********************************************************************
* Copyright (C) 2011 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: clust.i

Description:   
   This file contains the form for clustered Constraints.

Author: Kumar Mayur

Date Created:08/05/2011
----------------------------------------------------------------------------*/
{prodict/mss/key/primary.i }


/* Query definitions                                                    */
DEFINE {1} QUERY BROWSE-CLUSTERED FOR 
      temp SCROLLING.
      
      /* Browse definitions                                                   */
DEFINE {1} BROWSE BROWSE-CLUSTERED
  QUERY BROWSE-CLUSTERED NO-LOCK DISPLAY
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

/*    DEFINATION FOR CLUSTERED FRAME  */  

&Scoped-define FRAME-NAME frame_clustered

&Scoped-define BROWSE-NAME BROWSE-CLUSTERED
&Scoped-define FIELDS-IN-QUERY-BROWSE-CLUSTERED temp.pri temp.uni temp.ind temp.clu temp.man
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-CLUSTERED 
&Scoped-define QUERY-STRING-BROWSE-CLUSTERED FOR EACH temp NO-LOCK.    
&Scoped-define OPEN-QUERY-BROWSE-CLUSTERED OPEN QUERY BROWSE-CLUSTERED FOR EACH temp NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-CLUSTERED temp
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-CLUSTERED temp

        
        DEF VAR cintSub AS INTEGER NO-UNDO.

        DEFINE VARIABLE cQuery AS HANDLE.
        DEFINE VARIABLE cBrowse AS HANDLE.
        DEFINE VARIABLE cBuffer AS HANDLE.
        DEFINE VARIABLE cField AS HANDLE.
        DEFINE VARIABLE cField1 AS HANDLE.
        DEFINE VARIABLE cField2 AS HANDLE.
        DEFINE VARIABLE cField3 AS HANDLE.
        DEFINE VARIABLE cField4 AS HANDLE.
        DEFINE VARIABLE cField5 AS HANDLE.

        cBrowse = BROWSE BROWSE-CLUSTERED:HANDLE. /* Browse-3 is browser name */
        cQuery  = cBrowse:QUERY.
        cBuffer = cQuery:GET-BUFFER-HANDLE(1).    
    
FORM
     &IF "{&WINDOW-SYSTEM}" <> "TTY"
     &THEN 
     name AT ROW 1.46 COL 17 COLON-ALIGNED WIDGET-ID 4
     BROWSE-CLUSTERED AT ROW 3.36 COL 76 RIGHT-ALIGNED WIDGET-ID 200
     Active AT ROW 8.6 COL 2 WIDGET-ID 40
     Primary AT ROW 8.6 COL 24 WIDGET-ID 42
     Clustered AT ROW 8.6 COL 47 WIDGET-ID 44
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
     WITH FRAME frame_clustered
         NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 2.4
         SIZE 80 BY 16  WIDGET-ID 100.
                  
     &ELSE
     name AT ROW 2 COL 17 COLON-ALIGNED WIDGET-ID 4
     BROWSE-CLUSTERED AT ROW 3.76 COL 76 RIGHT-ALIGNED WIDGET-ID 200
     Active AT ROW 13 COL 2 WIDGET-ID 40
     Primary AT ROW 13 COL 24 WIDGET-ID 42
     Clustered AT ROW 13 COL 47 WIDGET-ID 44
     DESC_EDIT2 AT ROW 15 COL 2 WIDGET-ID 36
     OK_BUT AT ROW 20 COL 18 WIDGET-ID 26
     CREATE_BUT AT ROW 20 COL 35 WIDGET-ID 28
     CANCEL_BUT AT ROW 20 COL 52 WIDGET-ID 30
          
     WITH FRAME frame_clustered
         NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 3
         SIZE 80 BY 21  WIDGET-ID 100.
     &ENDIF       

 ASSIGN BROWSE-CLUSTERED:COLUMN-RESIZABLE IN FRAME frame_clustered  = TRUE .        


ON CHOOSE OF OK_BUT IN FRAME frame_clustered
  DO:          
       ASSIGN is-saved = FALSE.
       RUN check_clust_save.
      IF is-saved THEN
       APPLY "CLOSE":U TO THIS-PROCEDURE.
       RETURN NO-APPLY.        
  END.

ON CHOOSE OF CREATE_BUT IN FRAME frame_clustered
 DO:
       RUN check_clust_save.
 END. 
 
 
ON CHOOSE OF CANCEL_BUT IN FRAME frame_clustered
  DO:     
       APPLY "CLOSE":U TO THIS-PROCEDURE.
       RETURN NO-APPLY.      
  END.  

ON VALUE-CHANGED OF BROWSE-CLUSTERED IN FRAME frame_clustered
  DO:
      RUN Fetch_Clustered_Name.
      RUN clust_validate.
  END. 

ON ENTRY OF name IN FRAME frame_clustered
 DO:
  &IF "{&WINDOW-SYSTEM}" <> "TTY"  &THEN
  ASSIGN msg:SCREEN-VALUE IN FRAME frame_clustered ="". 
  &ENDIF
 END.

ON ENTRY OF DESC_EDIT2 IN FRAME frame_clustered
 DO:
  &IF "{&WINDOW-SYSTEM}" <> "TTY"  &THEN
  ASSIGN msg:SCREEN-VALUE IN FRAME frame_clustered ="". 
  &ENDIF
END. 

PROCEDURE Fetch_Clustered_Name:
 
  DO cintSub = 1 TO cBrowse:NUM-SELECTED-ROWS : 
     
     
           cBrowse:FETCH-SELECTED-ROW(cintSub).

           cField  = cBuffer:BUFFER-FIELD( "ind" ).
           cField1 = cBuffer:BUFFER-FIELD( "pri" ).
           cField2 = cBuffer:BUFFER-FIELD( "clu" ).
           cField3 = cBuffer:BUFFER-FIELD( "uni" ).
           cField4 = cBuffer:BUFFER-FIELD( "man" ).
           cField5 = cBuffer:BUFFER-FIELD( "rec" ).

           ASSIGN Selected_Idx = cField:BUFFER-VALUE.
  
  END.
run Create_Const_Name.
END PROCEDURE.  

PROCEDURE clustered :
           &Scoped-define OPEN-BROWSERS-IN-QUERY-frame_clustered ~
           ~{&OPEN-QUERY-BROWSE-CLUSTERED}
           
           HIDE FRAME frame_primary.
           HIDE FRAME frame_foreign.   
           HIDE FRAME frame_unique.  
           HIDE FRAME frame_default.  
           HIDE FRAME frame_check.  
           VIEW FRAME frame_clustered.
           DISPLAY NAME BROWSE-CLUSTERED Active Primary Clustered DESC_EDIT2 
               &IF "{&WINDOW-SYSTEM}" <> "TTY"  &THEN msg &ENDIF           
                   WITH FRAME frame_clustered.
           ASSIGN Active:SCREEN-VALUE IN FRAME frame_clustered ="yes".
           ENABLE NAME BROWSE-CLUSTERED Active Primary DESC_EDIT2 
                  OK_BUT CREATE_BUT CANCEL_BUT 
                  &IF "{&WINDOW-SYSTEM}" <> "TTY"
                  &THEN HELP_BUT  
                  &ENDIF
                  WITH FRAME frame_clustered.
            {&OPEN-BROWSERS-IN-QUERY-frame_clustered}
            RUN Fetch_Clustered_Name.
            RUN clust_validate.
END PROCEDURE.

PROCEDURE clust_save:
          num = num + 1.
          CREATE DICTDB._Constraint.
          IF Primary:SCREEN-VALUE IN FRAME frame_clustered = "yes"
           THEN ASSIGN _Con-Type = "MP".
           ELSE ASSIGN _Con-Type = "M".
          ASSIGN _Con-Name = name:SCREEN-VALUE IN FRAME frame_clustered
                 _For-Name = "".
          IF ACTIVE:SCREEN-VALUE IN FRAME frame_clustered = "yes"
          THEN ASSIGN _Con-Active = TRUE.
          ELSE ASSIGN _Con-Active = FALSE.
          ASSIGN _Con-Desc = DESC_EDIT2:SCREEN-VALUE IN FRAME frame_clustered
               _File-recid = file_rec
               _Con-Status = "N"
               _Index-recid = cField5:BUFFER-VALUE
               _Con-Num = num
               _db-recid = DbRecId.
          RUN TEMP1.
          RUN clustered. 
          &IF "{&WINDOW-SYSTEM}" <> "TTY"  &THEN
          ASSIGN msg:SCREEN-VALUE IN FRAME frame_clustered ="Constraint Created".  &ENDIF 
     ASSIGN is-saved = TRUE.                         
END.          

PROCEDURE clust_validate:
          IF CAN-FIND (DICTDB._Constraint WHERE DICTDB._Constraint._File-Recid = file_rec AND (DICTDB._Constraint._Con-Type = "P"  OR
                       DICTDB._Constraint._Con-Type = "PC" OR DICTDB._Constraint._Con-Type = "MP"))
          THEN DO:
               IF cField:BUFFER-VALUE = "C" OR cField1:BUFFER-VALUE = "I , C"
                  THEN ASSIGN Primary:SCREEN-VALUE IN FRAME frame_clustered ="yes".
               ELSE  ASSIGN Primary:SCREEN-VALUE IN FRAME frame_clustered ="no".  
               DISABLE Primary WITH FRAME frame_clustered.
          END.      
          ELSE              
          DO:
              IF temp.man = "  I" THEN
                  ENABLE Primary WITH FRAME frame_clustered.
              ELSE
                  DISABLE Primary WITH FRAME frame_clustered.
          END.
                  
END PROCEDURE.

PROCEDURE check_clust_save:
    IF CAN-FIND (DICTDB._Constraint WHERE DICTDB._Constraint._File-Recid = file_rec AND (DICTDB._Constraint._Con-Type = "M"  OR
          DICTDB._Constraint._Con-Type = "PC" OR DICTDB._Constraint._Con-Type = "MP")AND DICTDB._Constraint._Con-Status <> "D" 
                          AND DICTDB._Constraint._Con-Status <> "O")
    THEN  MESSAGE " Clustered constraint already exists in this table" VIEW-AS ALERT-BOX ERROR.
    
    ELSE DO:
       IF NOT CAN-FIND (FIRST DICTDB._Constraint WHERE DICTDB._Constraint._Con-Name = name:SCREEN-VALUE IN FRAME frame_clustered 
                     AND DICTDB._Constraint._Db-Recid = DbRecId AND DICTDB._constraint._Con-Status <> "O" AND
                             DICTDB._constraint._Con-Status <> "D") 
       THEN DO:
           IF cField:BUFFER-VALUE = "C" OR cField1:BUFFER-VALUE = "I , C" THEN DO:
             MESSAGE "As you are trying to create a Clustered constraint on an existing Primary non clustered constraint," SKIP
                     "the primary non clustered constraint will be deleted and a new Primary Clustered constraint" SKIP
                     "will be created, do you want to proceed ?" VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO  update ans.
             IF ans = YES THEN DO:
             FIND FIRST DICTDB._Constraint WHERE DICTDB._Constraint._Index-recid = cField5:BUFFER-VALUE  AND 
                   DICTDB._Constraint._Con-Type = "P" EXCLUSIVE-LOCK NO-ERROR.
                   IF AVAILABLE DICTDB._Constraint THEN DELETE DICTDB._Constraint.          
               RUN clust_save. 
             END.
           END.
           ELSE  RUN clust_save.   
       END.       
       ELSE MESSAGE "Constraint with this name already exists in the DB" VIEW-AS ALERT-BOX ERROR.                                        
    END.    
END PROCEDURE.
