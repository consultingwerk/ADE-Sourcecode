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
   Delete a file (i.e., table) definition and all associated indexes,
   fields and triggers.

Argument: 
   {&alias} - alias for the database containing the file to delete - of
      	      the form "DB."  The argument may be omitted if working on 
      	      the current database.
 
Author: Tony Lavinio (annotated by Laura Stern)

Date Created: 02/24/92 

----------------------------------------------------------------------------*/


FOR EACH {&alias}_Index OF {&alias}_File:
  FOR EACH {&alias}_Index-field OF {&alias}_Index:
    DELETE {&alias}_Index-field.
  END.
  DELETE {&alias}_Index.
END.
FOR EACH {&alias}_File-trig OF {&alias}_File:
  DELETE {&alias}_File-trig.
END.
FOR EACH {&alias}_Field OF {&alias}_File:
  FOR EACH {&alias}_Field-trig OF {&alias}_Field:
    DELETE {&alias}_Field-trig.
  END.
  DELETE {&alias}_Field.
END.
DELETE {&alias}_File.
