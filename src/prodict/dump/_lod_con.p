/*********************************************************************
* Copyright (C) 2011 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/ 
/* _lod_con.p  to load constraint data from DF to schema */
/* History
       created kmayur
       
*/
Define input-output parameter minimum-index as integer.

{ prodict/dictvar.i }
{ prodict/dump/loaddefs.i }
{ prodict/user/uservar.i }

DEFINE VARIABLE scrap      AS LOGICAL   NO-UNDO.
DEFINE VARIABLE gotError   AS LOGICAL   NO-UNDO.
DEFINE VARIABLE mandatory  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE numbe      AS INTEGER   NO-UNDO.
DEFINE VARIABLE dbrec      AS INTEGER   NO-UNDO.
DEFINE BUFFER   con        FOR  _Constraint. 

    FIND _File WHERE RECID(_File) = drec_file no-error.
    IF NOT AVAILABLE _File THEN
        RETURN.

   FOR EACH _Constraint:
    IF numbe < _Constraint._Con-num
    THEN numbe = _Constraint._Con-num.    
   END.
   
FIND FIRST wcon.

DO ON ERROR UNDO, LEAVE:

    ASSIGN gotError = YES.
    
  IF imod = "a" 
  THEN DO:  
    FIND FIRST _Constraint WHERE _Constraint._File-Recid = drec_file AND _Constraint._Con-Name = wcon._Con-Name NO-LOCK NO-ERROR.
       IF AVAILABLE (_Constraint) THEN DO:
              ierror = 7. /* "&2 already exists with name &3" */
              RETURN.
       END.    
    
    IF wcon._Con-Type = "P" OR wcon._Con-Type ="PC" OR wcon._Con-Type = "MP"
    THEN DO:
       mandatory = TRUE.
       FIND FIRST _Constraint WHERE _Constraint._File-Recid = drec_file AND (_Constraint._Con-Type = "P" OR _Constraint._Con-Type ="PC"
                 OR _Constraint._Con-Type = "MP") NO-LOCK NO-ERROR.
        IF AVAILABLE (_Constraint) THEN DO:
              ierror = 75. /* "&2 already exists with name &3" */
              RETURN.
        END.    
        FOR EACH DICTDB._index-field where DICTDB._index-field._Index-recid = wcon._Index-Recid:
               FIND FIRST DICTDB._Field where DICTDB._index-field._Field-Recid = RECID(DICTDB._Field).
               IF DICTDB._Field._Mandatory = NO THEN ASSIGN mandatory = FALSE.
        END.
        IF mandatory = FALSE THEN DO:
              ierror = 74.
              RETURN.
        END.
    END.
            
    IF wcon._Con-Type = "C" OR wcon._Con-Type = "D" THEN
       IF wcon._Con-Expr = "" THEN DO:
        ierror = 73.
        RETURN.
      END.

    IF wcon._Con-Type = "F" AND (wcon._Index-Parent-Recid = ? OR wcon._Index-Parent-Recid=0)
      THEN DO:
        ierror = 76.
        RETURN.
      END.
        
    CREATE _Constraint.
       ASSIGN numbe                   = numbe + 1
              _Constraint._File-Recid = drec_file
              _Constraint._Con-Name   = wcon._Con-Name
              _Constraint._Con-Type   = wcon._Con-Type
              _Constraint._Con-Status = "N"
              _Constraint._Db-recid   = _File._Db-recid
              _Constraint._Con-Num    = numbe
              _COnstraint._Con-Active = wcon._Con-Active
              _Constraint._For-Name   = wcon._Con-Name               
            _Constraint._Con-Misc2[1] = wcon._Con-Misc2[1] .
       
              IF wcon._Index-Recid <> ? THEN _Constraint._Index-Recid = wcon._Index-Recid.
              IF wcon._Field-Recid <> ? THEN _Constraint._Field-Recid = wcon._Field-Recid.
              if wcon._Index-Parent-Recid <> ? THEN _Constraint._Index-Parent-Recid = wcon._Index-Parent-Recid.
              IF wcon._Con-Expr <> ? THEN _Constraint._Con-Expr = wcon._Con-Expr.

  END.
  ELSE IF imod = "m"
  THEN DO:
       FIND FIRST _Constraint OF _File WHERE _Constraint._Con-Name = wcon._Con-Name NO-ERROR.
       IF NOT AVAILABLE (_Constraint) THEN.      
       ELSE _Constraint._Con-Active = wcon._Con-Active.  
  END.
  ELSE IF imod = "d"
  THEN DO:
       FIND FIRST _Constraint OF _File WHERE _Constraint._Con-Name = wcon._Con-Name NO-ERROR.
       IF NOT AVAILABLE (_Constraint) THEN.
       ELSE DO:
          IF _Constraint._Con-Type <> "PC" AND _Constraint._Con-Type <> "P" AND _Constraint._Con-Type <> "MP" AND _Constraint._Con-Type <> "U"
          THEN DO:
             FOR EACH _Constraint-Keys WHERE _Constraint-Keys._Con-Recid = RECID(_Constraint):
                 DELETE _Constraint-Keys.
             END.                
             DELETE _Constraint.
          END.   
          ELSE DO:
             FIND FIRST con where con._Index-Parent-Recid = _Constraint._Index-Recid NO-LOCK NO-ERROR.
             IF AVAILABLE (con) THEN.
             ELSE DO:
                FOR EACH _Constraint-Keys WHERE _Constraint-Keys._Con-Recid = RECID(_Constraint):
                   DELETE _Constraint-Keys.
                END.  
                DELETE _Constraint.      
             END.   
          END.
       END.   
  END.       
ASSIGN gotError = NO.
END.

IF gotError THEN
   ierror = 56. /* generic error - some client error raised */

RETURN.
