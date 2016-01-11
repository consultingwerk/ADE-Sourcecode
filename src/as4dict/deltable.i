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

/*----------------------------------------------------------------------------

File: deltable.i

Description:
   Delete an AS/400 file (i.e., table) definition and all associated 
   indexes, fields and triggers from DB2/Dictionary.

Author: Tony Lavinio (annotated by Laura Stern)

Date Created: 02/24/92                         

Modified for PROGRESS/400 Dictionary:  12/05/94  This file is in 
        AS4DICT.  The original deltable.i for the PROGRESS dictionary
        remains untouched in ADECOMM.  Only the PROGRESS/400 Dictionary
        (for the As/400) calls this include file.  

----------------------------------------------------------------------------*/

/* Delete Related Indices */

FOR EACH as4dict.p__Index WHERE as4dict.p__Index._File-number = as4dict.p__File._File-Number:
    FOR EACH as4dict.p__Idxfd WHERE  as4dict.p__Idxfd._File-number = as4dict.p__Index._File-number
                                                                   AND as4dict.p__Idxfd._Idx-num = as4dict.p__Index._idx-num:
        DELETE as4dict.p__Idxfd.
    END.
    DELETE as4dict.p__Index.
END.

/* Delete File Triggers */
FOR EACH as4dict.p__trgfl WHERE as4dict.p__trgfl._File-number = as4dict.p__file._File-Number:
    DELETE as4dict.p__trgfl.
END. 

/* Delete All Fields */
FOR EACH as4dict.p__Field WHERE as4dict.p__field._file-number = as4dict.p__file._File-Number:
    FOR EACH as4dict.p__trgfd WHERE   as4dict.p__trgfd._File-number = as4dict.p__Field._File-number
                                                                   AND as4dict.p__trgfd._Fld-number = as4dict.p__field._Fld-number:
        DELETE as4dict.p__trgfd.
    END.  
    DELETE as4dict.p__Field.
END.                   

/* Delete the File itself */
DELETE as4dict.p__File.
