/*********************************************************************
* Copyright (C) 2011 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: modclus.i

Description:   
   This file contains the form for modification of clustered Constraints.

HISTORY
Author: Kumar Mayur

Date Created:08/05/2011
----------------------------------------------------------------------------*/
{prodict/mss/key/modpri.i }


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
                       
 ASSIGN BROWSE-CLUSTERED:COLUMN-RESIZABLE IN FRAME frame_clustered        = TRUE.         


ON CHOOSE OF OK_BUT IN FRAME frame_clustered
  DO:          
          RUN clust_save.
          APPLY "CLOSE":U TO THIS-PROCEDURE.
          RETURN NO-APPLY.        
  END.

ON CHOOSE OF CREATE_BUT IN FRAME frame_clustered
 DO:
          RUN clust_save.
          RUN TEMP1.
          RUN clustered.
          &IF "{&WINDOW-SYSTEM}" <> "TTY"  &THEN
          ASSIGN msg:SCREEN-VALUE ="Constraint Modified".  &ENDIF  
 END. 
 
 
ON CHOOSE OF CANCEL_BUT IN FRAME frame_clustered
  DO:     
           APPLY "CLOSE":U TO THIS-PROCEDURE.
           RETURN NO-APPLY.      
  END.  

ON ENTRY OF DESC_EDIT2 IN FRAME frame_clustered
 DO:
  &IF "{&WINDOW-SYSTEM}" <> "TTY"  &THEN
  ASSIGN msg:SCREEN-VALUE IN FRAME frame_clustered ="". 
  &ENDIF
END. 

ON VALUE-CHANGED OF BROWSE-CLUSTERED IN FRAME frame_clustered
  DO:
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
     &IF "{&WINDOW-SYSTEM}" <> "TTY"  &THEN
     ASSIGN msg:SCREEN-VALUE IN FRAME frame_clustered ="". 
     &ENDIF
     RUN valid_clus.
  END. 

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
           ASSIGN name:SCREEN-VALUE IN FRAME frame_clustered =  constr_name.
           IF act = "t" THEN Active:SCREEN-VALUE IN FRAME frame_clustered ="yes".
           ASSIGN Clustered:SCREEN-VALUE IN FRAME frame_clustered ="yes".           
           ASSIGN DESC_EDIT2:SCREEN-VALUE IN FRAME frame_clustered = descrip.
           ENABLE  BROWSE-CLUSTERED Active DESC_EDIT2 
                  OK_BUT CREATE_BUT CANCEL_BUT  
                  &IF "{&WINDOW-SYSTEM}" <> "TTY"
                  &THEN HELP_BUT  
                  &ENDIF 
                  WITH FRAME frame_clustered.
            {&OPEN-BROWSERS-IN-QUERY-frame_clustered}

        FIND FIRST DICTDB._constraint where _con-name = constr_name AND DICTDB._constraint._Db-Recid =DbRecid NO-LOCK NO-ERROR.
        FOR EACH temp WHERE rec = DICTDB._constraint._index-recid NO-LOCK:
           curr-rec = ROWID(temp).
           REPOSITION BROWSE-CLUSTERED TO ROWID curr-rec.
        END.
             
END PROCEDURE.

PROCEDURE clust_save:
          FOR EACH DICTDB._constraint where _con-name = constr_name AND DICTDB._constraint._Db-Recid =DbRecid:
             IF ACTIVE:SCREEN-VALUE IN FRAME frame_clustered = "yes" THEN
             ASSIGN _Con-Active = TRUE.
             ELSE ASSIGN _Con-Active = FALSE.
             ASSIGN _Con-Desc = DESC_EDIT2:SCREEN-VALUE IN FRAME frame_clustered. 
             ASSIGN _Con-Status = "C".                     
          END.  
END.

PROCEDURE valid_clus:
          IF CAN-FIND (DICTDB._Constraint WHERE DICTDB._Constraint._File-Recid = file_rec AND (DICTDB._Constraint._Con-Type = "P"  OR
                       DICTDB._Constraint._Con-Type = "PC" OR DICTDB._Constraint._Con-Type = "MP"))
          THEN DO:
               IF cField1:BUFFER-VALUE = "C" OR cField1:BUFFER-VALUE = "I , C"
                  THEN ASSIGN Primary:SCREEN-VALUE IN FRAME frame_clustered ="yes".
               ELSE  ASSIGN Primary:SCREEN-VALUE IN FRAME frame_clustered ="no".  
               DISABLE Primary WITH FRAME frame_clustered.
          END. 
        IF cField2:BUFFER-VALUE = "I , C"  OR cField2:BUFFER-VALUE = "C"
        THEN ASSIGN Clustered:SCREEN-VALUE IN FRAME frame_clustered ="yes".
        ELSE ASSIGN Clustered:SCREEN-VALUE IN FRAME frame_clustered ="no".
        DISABLE Clustered WITH FRAME frame_clustered.     
END PROCEDURE.
