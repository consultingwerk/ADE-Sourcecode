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
    File       : adm2/colprep.i
    Purpose    : This include file is used in query.i to convert AB generated
                 preprocessors to comma-separated lists of columns 
                 separated by {&adm-tabledelimiter} for each table.  
 Preprocessors : &num - number part of AB generated preprocessors
                        (FIRST, SECOND .. TENTH ) 
                 &enabledvar   - Char variable that accumulates enabled-fields
                 &datavar      - Chart variable that accumalates data-fields 
                 &enabledcount - Int var that counts database enabled-fields
                 &datavar      - Int var that counts database data-fields 
                 &adm-tabledelimiter - global delimiter used for column lists 
                                       that have entries per table         
                                               
   Created     : November 16, 1999
----------------------------------------------------------------------*/
&SCOP enFld '{&ENABLED-FIELDS-IN-{&{&num}-TABLE-IN-QUERY-{&QUERY-NAME}}}':U
&SCOP daFld '{&DATA-FIELDS-IN-{&{&num}-TABLE-IN-QUERY-{&QUERY-NAME}}}':U
 
    &IF '{&NUM}':U <> 'FIRST':U &THEN
&SCOP enAcc  {&enabledvar} + {&adm-tabledelimiter} +
&SCOP daAcc  {&datavar} + {&adm-tabledelimiter} +
   &ENDIF /* &num <> first */
                    
    &IF "{&{&num}-TABLE-IN-QUERY-{&QUERY-NAME}}":U NE "":U &THEN
ASSIGN 
 {&enabledcount} = {&enabledcount}  +  NUM-ENTRIES({&enFld}," ":U)  
 {&datacount}    = {&datacount}     +  NUM-ENTRIES({&daFld}," ":U)
 {&enabledvar}   = {&enAcc} REPLACE({&enFld}," ":U,",":U)
 {&datavar}      = {&daAcc} REPLACE({&daFld}," ":U,",":U).
    &ENDIF /* if {&num}-table-in-query-{&query-name <> '' } */
