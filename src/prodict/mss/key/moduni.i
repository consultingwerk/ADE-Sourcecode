/*********************************************************************
* Copyright (C) 2011 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: moduni.i

Description:   
   This file contains the form for modification of unique Constraints.

HISTORY
Author: Kumar Mayur

Date Created:08/05/2011
----------------------------------------------------------------------------*/
{prodict/mss/key/modclus.i }

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
          RUN unique_save.
          APPLY "CLOSE":U TO THIS-PROCEDURE.
          RETURN NO-APPLY.         
  END.

ON CHOOSE OF CREATE_BUT IN FRAME frame_unique
 DO:
          RUN unique_save.
          RUN TEMP1.
          RUN unique.
          &IF "{&WINDOW-SYSTEM}" <> "TTY"  &THEN
          ASSIGN msg:SCREEN-VALUE ="Constraint Modified".  &ENDIF 
 END. 
 
 
ON CHOOSE OF CANCEL_BUT IN FRAME frame_unique
  DO:     
           APPLY "CLOSE":U TO THIS-PROCEDURE.
           RETURN NO-APPLY.      
  END.

ON ENTRY OF DESC_EDIT2 IN FRAME frame_unique
 DO:
  &IF "{&WINDOW-SYSTEM}" <> "TTY"  &THEN
  ASSIGN msg:SCREEN-VALUE IN FRAME frame_unique ="". 
  &ENDIF
END.

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
           ASSIGN name:SCREEN-VALUE IN FRAME frame_unique =  constr_name.
           IF act = "t" THEN Active:SCREEN-VALUE IN FRAME frame_unique ="yes".
           ASSIGN DESC_EDIT2:SCREEN-VALUE IN FRAME frame_unique = descrip. 
           ENABLE BROWSE-UNIQUE Active DESC_EDIT2 
                    OK_BUT CREATE_BUT CANCEL_BUT 
                 &IF "{&WINDOW-SYSTEM}" <> "TTY"
                 &THEN HELP_BUT  
                 &ENDIF 
                  WITH FRAME frame_unique.
            {&OPEN-BROWSERS-IN-QUERY-frame_unique}
        FIND FIRST  DICTDB._constraint where _con-name = constr_name AND DICTDB._constraint._Db-Recid =DbRecid NO-LOCK NO-ERROR.
        FOR EACH temp WHERE rec = DICTDB._constraint._index-recid NO-LOCK:
           curr-rec = ROWID(temp).
           REPOSITION BROWSE-UNIQUE TO ROWID curr-rec.
        END.  
END PROCEDURE.

PROCEDURE unique_save:
           
           FOR EACH DICTDB._constraint where _con-name = constr_name AND DICTDB._constraint._Db-Recid =DbRecid:
             IF ACTIVE:SCREEN-VALUE IN FRAME frame_unique = "yes" THEN
             ASSIGN _Con-Active = TRUE.
             ELSE ASSIGN _Con-Active = FALSE. 
             ASSIGN _Con-Desc = DESC_EDIT2:SCREEN-VALUE IN FRAME frame_unique. 
             ASSIGN _Con-Status = "C".                    
           END.  
END.          
          
