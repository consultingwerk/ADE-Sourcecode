/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------
 File          : adm2/delrecst.i
 Purpose       : This include file is used to produce DELETE
                 statements for each table in the associated query. 
                 The code is conditionally included when there is an 
                 open query definition and when there is an "nth" 
                 table referenced in the query.
 Preprocessors : &num - number part of AB generated preprocessors
                        (FIRST, SECOND .. TENTH )  
 Created       : December 14, 1999
 Referenced by : query.i
----------------------------------------------------------------------*/

&IF DEFINED(OPEN-QUERY-{&QUERY-NAME}) NE 0 AND 
  "{&{&num}-TABLE-IN-QUERY-{&QUERY-NAME}}":U NE "":U
 &THEN
  DELETE {&{&num}-TABLE-IN-QUERY-{&QUERY-NAME}} NO-ERROR.
  lRet = NOT ERROR-STATUS:ERROR.
&ENDIF
