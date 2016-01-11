/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
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
