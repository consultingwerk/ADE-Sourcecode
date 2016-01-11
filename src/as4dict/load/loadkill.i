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

/* as4dict/load/loadkill.i - delete a file definition 

   Modified 95/01/31 to work with DB2/400 Utilities  
*/

FOR EACH as4dict.p__Index WHERE as4dict.p__Index._File-number = as4dict.p__File._File-number:
  FOR EACH as4dict.p__Idxfd WHERE as4dict.p__Idxfd._Idx-num =  as4dict.p__Index._Idx-num
                                                                AND as4dict.p__Idxfd._File-number = as4dict.p__Index._File-number:
    DELETE as4dict.p__Idxfd.
  END.
  DELETE as4dict.p__Index.
END.
FOR EACH as4dict.p__Trgfl WHERE as4dict.p__Trgfl._File-number = as4dict.p__File._File-number:
  DELETE as4dict.p__Trgfl.
END.
FOR EACH as4dict.p__Field WHERE as4dict.p__Field._File-number = as4dict.p__File._File-number:
  FOR EACH as4dict.p__Trgfd WHERE as4dict.p__Trgfd._File-number = as4dict.p__Field._File-number
                                                                 AND as4dict.p__Trgfd._Fld-number = as4dict.p__Field._File-number:
    DELETE as4dict.p__Trgfd.
  END.
  DELETE as4dict.p__Field.
END.
DELETE as4dict.p__File.
