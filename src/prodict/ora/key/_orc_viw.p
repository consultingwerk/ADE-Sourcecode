/*********************************************************************
* Copyright (C) 2011 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _orc_viw.p

Description:   
   This file contains form for View Maintain Foreign Constraints in Oracle.

HISTORY
Author: Kumar Mayur

Date Created:08/05/2011
----------------------------------------------------------------------------*/
{prodict/user/uservar.i }
{prodict/ora/key/viewmnt.i NEW}

Define var access as logical NO-UNDO.
Define FRAME frame_const. 
Define {1} var sTbLbl2          as char NO-UNDO init "Tables".
Define {1} var cnstLbl2       as char NO-UNDO INIT "Constraints" .
Define {1} var TblRecId         as recid    NO-UNDO. 
Define {1} var Show_Hidden_Tbls as logical init no  NO-UNDO.

DEFINE BUFFER   CON_DICTDB         FOR DICTDB._Constraint.

DEFINE BUTTON btnCreate 
     LABEL "C&reate Constraint..." 
     SIZE 22 BY 1.3.

DEFINE BUTTON btnProps  
     LABEL "Constraint &Properties..." 
     SIZE 24 BY 1.3.

DEFINE BUTTON s_btnDelete  
     LABEL "De&lete Constraint" 
     SIZE 22 BY 1.3.

DEFINE VARIABLE is_error    AS LOGICAL.
DEFINE VARIABLE c_lst_Cnsts AS CHARACTER.
DEFINE VARIABLE c_lstTbls   AS CHARACTER.
DEFINE VARIABLE tbl_fill    AS CHARACTER FORMAT "X(256)":U.
DEFINE VARIABLE cnst_fill   AS CHARACTER FORMAT "X(256)":U.

DEFINE FRAME frame_const
     sTbLbl2  AT ROW 2 COL 7  NO-LABEL format "x(28)" view-as TEXT
     cnstLbl2 AT ROW 2 COL 46 NO-LABEL format "x(28)" view-as TEXT
     tbl_fill AT ROW 2.7 COL 7 NO-LABEL VIEW-AS FILL-IN SIZE 28 BY .9
     c_lstTbls AT ROW 3.86 COL 7 NO-LABEL VIEW-AS SELECTION-LIST SIZE 28 BY 6 SINGLE 
                                   SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL 
     cnst_fill AT ROW 2.7 COL 46 NO-LABEL VIEW-AS FILL-IN SIZE 28 BY .9
     c_lst_Cnsts AT ROW 3.86 COL 46 NO-LABEL VIEW-AS SELECTION-LIST SINGLE 
                                   SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL SIZE 28 BY 6
     btnCreate AT ROW 12 COL 4 WIDGET-ID 20
     btnProps AT ROW 12 COL 28.5 WIDGET-ID 22
     s_btnDelete AT ROW 12 COL 55 WIDGET-ID 24
     
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 1
         SIZE 80 BY 16
         view-as DIALOG-BOX TITLE "View/Maintain Foreign Constraint Definitions" .
      
assign cnstLbl2:screen-value in FRAME frame_const = cnstLbl2.
assign sTbLbl2:screen-value in FRAME frame_const = sTbLbl2  .

ON CHOOSE OF btnCreate IN FRAME frame_const
   DO:
      IF NOT is_error THEN DO:
          IF c_table_name = "" OR c_table_name = "?" THEN MESSAGE "No table selected, please select a table" VIEW-AS ALERT-BOX ERROR.
          ELSE DO:
              FIND FIRST DICTDB._index OF DICTDB._file WHERE DICTDB._file._file-name = c_table_name 
                                                            AND DICTDB._File._Db-Recid = DbRecid NO-LOCK NO-ERROR. 
              IF DICTDB._Index._Index-name = "default" THEN 
                          MESSAGE " An index is required before creating a constraint, create an index before proceeding" VIEW-AS ALERT-BOX ERROR.
              ELSE RUN prodict/ora/key/constraint.p.    
          END.
          RUN fill_constraint.
       END. 
       ELSE MESSAGE "Please select a valid table" VIEW-AS ALERT-BOX ERROR.         
   END.

ON CHOOSE OF btnProps IN FRAME frame_const 
   DO:
      IF NOT is_error THEN DO:
          constr_name = cnst_fill:screen-value.
          IF constr_name = "" OR constr_name = "?" THEN MESSAGE "No constraint selected, please select a constraint" VIEW-AS ALERT-BOX ERROR.
          ELSE RUN prodict/ora/key/modcons.p.
          RUN fill_constraint.
      END. 
      ELSE MESSAGE "Please select a valid constraint" VIEW-AS ALERT-BOX ERROR.         
   END.       

ON CHOOSE OF s_btnDelete IN FRAME frame_const 
   DO:
      IF NOT is_error THEN DO:
          constr_name = cnst_fill:screen-value.
          IF constr_name = "" OR constr_name = "?" THEN MESSAGE "No constraint selected, please select a constraint" VIEW-AS ALERT-BOX ERROR.
          ELSE RUN prodict/mss/key/del_con.p.
          RUN fill_constraint.
       END.
       ELSE MESSAGE "Please select a valid constraint" VIEW-AS ALERT-BOX ERROR.  
   END.                

ON WINDOW-CLOSE OF FRAME frame_const
   DO:
        APPLY "END-ERROR" TO FRAME frame_const.
   END.

ON VALUE-CHANGED OF c_lstTbls  IN FRAME frame_const
   DO:
       RUN fill_constraint.
   END.


ON LEAVE OF cnst_fill IN FRAME frame_const
DO:
   define var lst_val as char NO-UNDO.
    
   lst_val = c_lst_Cnsts:screen-value IN FRAME frame_const.
   IF lst_val = ? THEN ASSIGN lst_val="".
   IF lst_val BEGINS SELF:screen-value THEN DO:
      cnst_fill:screen-value IN FRAME frame_const = lst_val.
      is_error = FALSE.
   END.   
   ELSE DO:
       is_error = TRUE.
   END.    
END.

ON VALUE-CHANGED OF c_lstTbls IN FRAME frame_const
DO:
   /* Reflect selection in fill-in. */
   IF SELF:screen-value = ? THEN
      Tbl_Fill:screen-value IN FRAME frame_const = "".
   ELSE 
      Tbl_Fill:screen-value in  FRAME frame_const = SELF:screen-value.
   ASSIGN is_error = FALSE.   
   RUN fill_constraint.
END.

ON VALUE-CHANGED OF c_lst_Cnsts  IN FRAME frame_const
DO:
   /* Reflect selection in fill-in. */
   IF SELF:screen-value = ? THEN
      cnst_fill:screen-value IN FRAME frame_const = "".
   ELSE 
      cnst_fill:screen-value in  FRAME frame_const = SELF:screen-value.
   ASSIGN is_error = FALSE.   
END.

PROCEDURE fill_constraint:
   c_table_name = c_lstTbls:screen-value IN FRAME frame_const.   
   c_lst_Cnsts:list-items IN FRAME frame_const = "".  
   FIND FIRST DICTDB._File WHERE DICTDB._File._File-Name =  c_table_name AND DICTDB._FIle._Db-Recid = DbRecId NO-LOCK NO-ERROR.
   IF AVAILABLE(DICTDB._File) THEN
   DO :
      TblRecId = RECID(DICTDB._File).
                    
       FOR EACH _constraint WHERE _File-recid = TblRecId AND _Constraint._Db-Recid = DbRecId NO-LOCK:
          IF (( _constraint._Con-Status = "N" OR _constraint._Con-Status = "C" OR _constraint._Con-Status = "M") 
          AND ( _constraint._Con-type = "C" OR _constraint._Con-type = "P" OR _constraint._Con-type = "MP" OR _constraint._Con-type = "PC"
           OR _constraint._Con-type = "U" OR _constraint._Con-type = "F"))
           THEN DO:
             IF _constraint._Con-type = "F" THEN DO:
               IF CAN-FIND (FIRST CON_DICTDB WHERE CON_DICTDB._Index-recid = _constraint._Index-parent-recid AND CON_DICTDB._Con-Type <> "U")
                 THEN c_lst_Cnsts:ADD-LAST(_constraint._con-name) IN FRAME frame_const.           
             END.
             ELSE c_lst_Cnsts:ADD-LAST(_constraint._con-name) IN FRAME frame_const.
           END.        
       END.	
   END.
     
   IF c_lst_Cnsts:NUM-ITEMS > 0 
   THEN cnst_fill = c_lst_Cnsts:entry(1) IN FRAME frame_const.
   ELSE cnst_fill = "".
   ASSIGN c_lst_Cnsts:screen-value IN FRAME frame_const = cnst_fill.
          cnst_fill:screen-value IN FRAME frame_const   = cnst_fill.
       
END PROCEDURE.

ON LEAVE OF tbl_fill IN FRAME frame_const
DO:
   define var lst_val as char NO-UNDO.
 
   /* If the value entered in the fill-in prefix-matches a value in the
      select list, reset it's value to be the full selection list value. 
      Otherwise, we'll leave it alone. */
   lst_val = c_lstTbls:screen-value IN FRAME frame_const.
   IF lst_val BEGINS SELF:screen-value THEN DO:
      tbl_fill:screen-value IN FRAME frame_const = lst_val.
      ASSIGN is_error = FALSE.
   END.   
   ELSE DO:
       ASSIGN is_error = TRUE.
   END.    
   RUN fill_constraint.
END.

{prodict/mss/key/fillin.i &Frame  = "FRAME frame_const"
                     &CBFill = "Tbl_Fill"
                     &CBList = "c_lstTbls"
                     &CBInit = """"}

{prodict/mss/key/fillin.i &Frame  = "FRAME frame_const"
                     &CBFill = "cnst_fill"
                     &CBList = "c_lst_Cnsts"
                     &CBInit = """"}
       
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
   RUN enable_UI.

   FIND FIRST DICTDB._Db WHERE DICTDB._Db._Db-Name = user_dbname NO-LOCK NO-ERROR.
   IF AVAILABLE (DICTDB._Db)
   THEN DO:
      assign DbRecId = RECID(DICTDB._Db)
             cDbType  = user_dbtype.
   END.
   ELSE DO:
      FIND LAST DICTDB._Db.
         ASSIGN DbRecId = RECID(DICTDB._Db)
                cDbType  = user_dbtype.
   END.
   run adecomm/_tbllist.p 
      	    (INPUT  c_lstTbls:HANDLE in frame frame_const,
      	     INPUT  Show_Hidden_Tbls,
      	     INPUT  DbRecId,
      	     INPUT  "",
             INPUT  " " , /* all foreign types allowed (hutegger 95/06) */
                   /* BUFFER,FUNCTION,PACKAGE,PROCEDURE,SEQUENCE,VIEW", */
      	     OUTPUT access).
   
   IF c_lstTbls:NUM-ITEMS > 0 THEN tbl_fill = c_lstTbls:entry(1) IN FRAME frame_const.
      c_lstTbls:screen-value IN FRAME frame_const = tbl_fill.
      tbl_fill:screen-value IN FRAME frame_const = tbl_fill.

   RUN fill_constraint.     
   IF cDbType = "ORACLE" OR cDbType = "MSS" THEN DO:
       DISABLE  s_btnDelete WITH FRAME frame_const.
       DISABLE  btnCreate WITH FRAME frame_const.
   END. 
     
   IF NOT THIS-PROCEDURE:PERSISTENT THEN
   WAIT-FOR CLOSE OF THIS-PROCEDURE. 
END.

PROCEDURE enable_UI :
  DISPLAY c_lst_Cnsts c_lstTbls tbl_fill cnst_fill
      WITH FRAME frame_const.
  ENABLE c_lst_Cnsts c_lstTbls btnCreate btnProps s_btnDelete tbl_fill cnst_fill
      WITH FRAME frame_const.
END PROCEDURE.

