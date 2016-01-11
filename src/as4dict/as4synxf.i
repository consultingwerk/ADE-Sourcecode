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
/*-------------------------------------------------------------
File: as4synxf.i

Description:  These are the field assignments for the Index Fields 
    
History:

      nhorn     12/09/94   Created   
      DMcmann   01/23/95   Modified, finished assignments
-------------------------------------------------------------*/

/* ==================== Main Line Code  ===================== */

/* Get the as4dict.p__field record to find the name of the field to then
   use to get the _field record and its recid to fill the _field-recid 
   field.  */
   
FIND as4dict.p__field where as4dict.p__field._fld-number = as4dict.p__idxfd._fld-number 
                        AND as4dict.p__Field._File-number = as4dict.p__File._File-number NO-ERROR.

/* The field record must exist, but handle the possibility that it
    does not.  */
    
IF AVAILABLE (as4dict.p__field) THEN DO:
  FIND _field OF _FILE WHERE _field._field-name = as4dict.p__field._field-name
                         AND _field._File-RECID = RECID(_File) NO-ERROR.
  IF AVAILABLE (_field) THEN 
     ASSIGN _Index-Field._Field-recid = RECID(_field)
            _Index-Field._Ascending = 
                 (if as4dict.p__idxfd._Ascending = "Y" then yes else no)
            _Index-Field._Abbreviate = 
                 (if as4dict.p__idxfd._Abbreviate = "Y" then yes else no)
            _Index-Field._Index-seq = as4dict.p__Idxfd._Index-seq
            _Index-Field._IF-misc1[1] = as4dict.p__Idxfd._If-misc1[1]
            _Index-Field._IF-misc1[2] = as4dict.p__Idxfd._If-misc1[2]
            _Index-Field._IF-misc1[3] = as4dict.p__Idxfd._If-misc1[3]
            _Index-Field._IF-misc1[4] = as4dict.p__Idxfd._If-misc1[4]
            _Index-Field._IF-misc1[5] = as4dict.p__Idxfd._If-misc1[5]
            _Index-Field._IF-misc1[6] = as4dict.p__Idxfd._If-misc1[6]
            _Index-Field._IF-misc1[7] = as4dict.p__Idxfd._If-misc1[7]
            _Index-Field._IF-misc1[8] = as4dict.p__Idxfd._If-misc1[8]
            _Index-Field._IF-misc2[1] = as4dict.p__Idxfd._If-misc2[1]
            _Index-Field._IF-misc2[2] = as4dict.p__Idxfd._If-misc2[2]
            _Index-Field._IF-misc2[3] = as4dict.p__Idxfd._If-misc2[3]
            _Index-Field._IF-misc2[4] = as4dict.p__Idxfd._If-misc2[4]
            _Index-Field._IF-misc2[5] = as4dict.p__Idxfd._If-misc2[5]
            _Index-Field._IF-misc2[6] = as4dict.p__Idxfd._If-misc2[6]
            _Index-Field._IF-misc2[7] = as4dict.p__Idxfd._If-misc2[7]
            _Index-Field._IF-misc2[8] = as4dict.p__Idxfd._If-misc2[8].
            
  ELSE Message "Unable to add Index Field record.  " 
               as4dict.p__field._field-name "does not exist in _Field file."
               "Do you want to stop the synchronization?"
               VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO UPDATE answer. 
   IF answer THEN   DO:
        HIDE  FRAME working NO-PAUSE.  
        UNDO, RETURN "error".            
     END.          
END.
ELSE DO: 
   MESSAGE "Unable to find Index fields for Index " as4dict.p__Index._Index-name 
     "no Index Fields added.  Do you want to stop the synchronization?"
     VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO UPDATE answer.
   
   IF answer THEN   DO:       
       HIDE FRAME working NO-PAUSE.
       UNDO, RETURN "error".       
    END.   
END.
     
     

          
