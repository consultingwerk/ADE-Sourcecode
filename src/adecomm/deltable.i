/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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
