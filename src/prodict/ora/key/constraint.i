/*********************************************************************
* Copyright (C) 2011 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: constraint.i

Description:   
   This file contains the forms the base file for creation of Constraints.

HISTORY
Author: Kumar Mayur

Date Created:08/05/2011
----------------------------------------------------------------------------*/


{prodict/ora/key/viewmnt.i  }

DEFINE {1} TEMP-TABLE temp NO-UNDO
    FIELD ind AS CHAR LABEL "Index"
    FIELD pri AS CHAR LABEL "Primary"
    FIELD uni AS CHAR LABEL "Unique"
    FIELD man AS CHAR LABEL "All Columns Mandatory"
    FIELD rec AS RECID LABEL "REC ID".

DEFINE {1} TEMP-TABLE temp2 NO-UNDO
    FIELD fld AS CHAR LABEL "Field"
    FIELD ini AS CHAR LABEL "Initial Value"
    FIELD chk AS CHAR LABEL "Constraint Expression"
    FIELD rec AS RECID LABEL "REC ID"
    FIELD cdf AS CHAR LABEL "Constraint Expression"
    FIELD exp AS CHAR LABEL "valid" .

DEFINE {1} TEMP-TABLE temp-parent NO-UNDO  
    FIELD ptb AS CHAR LABEL "Parent Table"
    FIELD pidx AS CHAR LABEL "Parent Index"
    FIELD prec AS RECID LABEL "REC ID".


DEFINE {1} TEMP-TABLE temp-parent1 NO-UNDO
    FIELD idxn AS CHAR LABEL "Name"
    FIELD ctyp AS CHAR LABEL "Type"
    FIELD fldl AS INTEGER LABEL "Length"
    FIELD fnum AS INTEGER LABEL "Number".
   

DEFINE {1} TEMP-TABLE temp-child NO-UNDO
    FIELD cidx AS CHAR LABEL "Child Index"
    FIELD crec AS RECID LABEL "REC ID".

DEFINE {1} TEMP-TABLE temp-child1 NO-UNDO
    FIELD idxn AS CHAR LABEL "Name"
    FIELD ctyp AS CHAR LABEL "Type"
    FIELD fldl AS INTEGER LABEL "Length"
    FIELD fnum AS INTEGER LABEL "NUMBER".
      
    
DEFINE {1} VARIABLE  file_rec       AS RECID     NO-UNDO.
DEFINE {1} VARIABLE  mandatory      AS INTEGER   NO-UNDO.
DEFINE {1} VARIABLE  A              AS INTEGER   NO-UNDO.
DEFINE {1} VARIABLE  num            AS INTEGER   NO-UNDO.
DEFINE {1} VARIABLE  Par_Idx        AS CHAR      NO-UNDO.
DEFINE {1} VARiable  Selected_Idx   AS CHAR      NO-UNDO.
DEFINE {1} VARIABLE  is-saved       AS LOGICAL   NO-UNDO INITIAL FALSE.

DEFINE {1} BUTTON OK_BUT  
     LABEL "&OK" 
     SIZE 13 BY 1.

DEFINE {1} BUTTON CREATE_BUT 
     LABEL "&Create" 
     SIZE 13 BY 1.

DEFINE {1} BUTTON CANCEL_BUT 
     LABEL "Ca&ncel" 
     SIZE 13 BY 1.

DEFINE {1} BUTTON HELP_BUT 
     LABEL "&Help" 
     SIZE 13 BY 1.

DEFINE {1} VARIABLE Constrainttype AS CHARACTER FORMAT "X(12)":U 
     &IF "{&WINDOW-SYSTEM}" <> "TTY"
     &THEN  LABEL "Constraint Type." 
     &ELSE   LABEL "Constraint Type" 
     &ENDIF
    
     VIEW-AS COMBO-BOX INNER-LINES 4
     LIST-ITEMS "PRIMARY","UNIQUE","FOREIGN KEY","CHECK" 
     DROP-DOWN-LIST
     SIZE 20 BY 1 NO-UNDO.

DEFINE VARIABLE child AS CHARACTER FORMAT "X(12)":U 
     LABEL "Child Table" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .92 NO-UNDO.
     
DEFINE {1} VARIABLE EXPRESSION AS CHARACTER
     &IF "{&WINDOW-SYSTEM}" <> "TTY"
     &THEN LABEL "Constraint ."  
           VIEW-AS EDITOR SCROLLBAR-VERTICAL
           SIZE 49 BY 2 NO-UNDO.
     &ELSE 
           LABEL "Constraint." 
           VIEW-AS EDITOR SCROLLBAR-VERTICAL
           SIZE 49 BY 3 NO-UNDO.
     &ENDIF     

DEFINE {1} VARIABLE VALIDATE AS CHARACTER 
     &IF "{&WINDOW-SYSTEM}" <> "TTY"
     &THEN LABEL "Validation ." 
           VIEW-AS EDITOR SCROLLBAR-VERTICAL
           SIZE 49 BY 2 NO-UNDO.
     &ELSE 
           LABEL "Validation." 
           VIEW-AS EDITOR SCROLLBAR-VERTICAL
           SIZE 49 BY 3 NO-UNDO.
     &ENDIF

DEFINE {1} VARIABLE DESC_EDIT AS CHARACTER 
     LABEL "Description"
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     &IF "{&WINDOW-SYSTEM}" <> "TTY"
     &THEN SIZE 49 BY 2 NO-UNDO.
     &ELSE SIZE 49 BY 3 NO-UNDO.
     &ENDIF
     
DEFINE {1} VARIABLE DESC_EDIT2 AS CHARACTER 
     LABEL "Description"
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     &IF "{&WINDOW-SYSTEM}" <> "TTY"
     &THEN SIZE 49 BY 2 NO-UNDO.
     &ELSE SIZE 49 BY 4.3 NO-UNDO.
     &ENDIF     


DEFINE {1} VARIABLE name AS CHARACTER FORMAT "X(80)":U 
     LABEL "Constraint &Name" 
     VIEW-AS FILL-IN 
     SIZE 36 BY 1 NO-UNDO.

DEFINE {1} VARIABLE Active AS LOGICAL INITIAL no 
     LABEL "Active" 
     VIEW-AS TOGGLE-BOX
     SIZE 11 BY .81 NO-UNDO.
     
DEFINE {1} VARIABLE msg AS CHARACTER FORMAT "X(80)":U 
     LABEL ""
     VIEW-AS FILL-IN 
     SIZE 36 BY 1 NO-UNDO.
     
DEFINE {1} VARIABLE Primary AS LOGICAL INITIAL no 
     LABEL "Primary" 
     VIEW-AS TOGGLE-BOX
     SIZE 13.4 BY .81 NO-UNDO.

Define {1} var s_Status as char  FORMAT "X(12)":U 
     LABEL "" 
          VIEW-AS FILL-IN 
     SIZE 13.4 BY .81 NO-UNDO.

DEFINE {1} FRAME DEFAULT-FRAME
   &IF "{&WINDOW-SYSTEM}" <> "TTY"
   &THEN Constrainttype AT ROW 1.4 COL 17 COLON-ALIGNED WIDGET-ID 2
   &ELSE Constrainttype AT ROW 1.95 COL 17 COLON-ALIGNED WIDGET-ID 2
   &ENDIF
   WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         &IF "{&WINDOW-SYSTEM}" <> "TTY"
         &THEN SIZE 82 BY 19 WIDGET-ID 100
         &ELSE SIZE 82 BY 24 WIDGET-ID 100
         &ENDIF
         
         VIEW-AS DIALOG-BOX 
         TITLE "Create Foreign Constraint Definition for " + c_table_name .
DEFINE {1} FRAME frame_primary.
DEFINE {1} FRAME frame_foreign.
DEFINE {1} FRAME frame_unique.
DEFINE {1} FRAME frame_check.


ASSIGN FRAME frame_primary:FRAME = FRAME DEFAULT-FRAME:HANDLE
       FRAME frame_foreign:FRAME = FRAME DEFAULT-FRAME:HANDLE   
       FRAME frame_unique:FRAME = FRAME DEFAULT-FRAME:HANDLE
       FRAME frame_check:FRAME = FRAME DEFAULT-FRAME:HANDLE.

ASSIGN num = 0.
FOR EACH DICTDB._Constraint WHERE DICTDB._constraint._Db-Recid = DbRecid:
    IF DICTDB._Constraint._Con-Num > num 
     THEN ASSIGN num = DICTDB._Constraint._Con-Num. 
END.

PROCEDURE TEMP1:

EMPTY TEMP-TABLE temp.

FOR EACH DICTDB._file WHERE DICTDB._file._file-name = c_table_name AND DICTDB._File._Db-Recid = DbRecid NO-LOCK:
   file_rec = RECID(DICTDB._file).
   FOR EACH DICTDB._index WHERE DICTDB._index._file-recid = file_rec AND _Index._Wordidx <> 1 NO-LOCK:
       CREATE temp.
       ASSIGN ind = DICTDB._index._index-name.
              IF _unique = YES
              THEN ASSIGN uni = "I".
              IF DICTDB._File._Prime-Index = RECID(DICTDB._Index) 
              THEN ASSIGN pri = "I".
              A = RECID(DICTDB._index).
              FOR EACH DICTDB._Constraint WHERE DICTDB._Constraint._Index-recid = A AND DICTDB._Constraint._Con-Status <> "D"
                                                   AND DICTDB._Constraint._Con-Status <> "O":
                            
                IF (DICTDB._Constraint._Con-Type = "P" OR DICTDB._Constraint._Con-Type = "MP" OR DICTDB._Constraint._Con-Type = "PC")               
                   THEN DO:
                   IF pri <> "" THEN pri = pri + " , C".
                                     ELSE pri = "C".
                   END.
                IF (DICTDB._Constraint._Con-Type = "U")
                   THEN DO:
                   IF uni <> "" THEN uni = uni + " , C".
                                     ELSE uni = "C".  
                   END.
               END.    
              ASSIGN mandatory = 0.
              ASSIGN rec = RECID(DICTDB._index).
              FOR EACH DICTDB._index-field where DICTDB._index-field._Index-recid = A:
                  FIND FIRST DICTDB._Field where DICTDB._index-field._Field-Recid = RECID(DICTDB._Field).
                  IF DICTDB._Field._Mandatory = NO THEN ASSIGN mandatory = 1.
              END.
              IF mandatory = 0 THEN ASSIGN man = "  I".    
   END.
END.
END PROCEDURE.

PROCEDURE FILL_TEMP2:
EMPTY TEMP-TABLE temp2.
FOR EACH DICTDB._file WHERE DICTDB._file._file-name = c_table_name AND DICTDB._File._Db-Recid = DbRecid NO-LOCK:
   file_rec = RECID(DICTDB._file).
   FOR EACH DICTDB._Field WHERE DICTDB._Field._file-recid = file_rec NO-LOCK:
      CREATE temp2.
      ASSIGN fld = DICTDB._Field._Field-Name
             ini = DICTDB._Field._Initial
             rec = RECID(DICTDB._Field)
             exp = DICTDB._Field._Valexp
             chk = "".
      A = RECID(DICTDB._Field).
      FOR EACH DICTDB._Constraint WHERE DICTDB._Constraint._Field-Recid = A AND DICTDB._Constraint._Con-Type = "C"      
           AND DICTDB._Constraint._Con-Status <> "D" AND DICTDB._Constraint._Con-Status <> "O":
        IF AVAILABLE(DICTDB._Constraint)  
        THEN DO:
          IF chk = "" THEN  ASSIGN chk = DICTDB._Constraint._Con-Expr.
          ELSE  ASSIGN chk = chk + " ; " + DICTDB._Constraint._Con-Expr.  
        END.
      END.    
   END.
END.      
END PROCEDURE.
