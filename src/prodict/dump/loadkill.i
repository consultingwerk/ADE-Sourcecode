/*********************************************************************
* Copyright (C) 2011 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/* prodict/dump/loadkill.i - delete a file definition */

FOR EACH {&alias}_Constraint OF {&alias}_File:
  FOR EACH {&alias}_Constraint-Keys WHERE {&alias}_Constraint-Keys._Con-Recid = RECID({&alias}_Constraint):
    DELETE {&alias}_Constraint-Keys.
  END.  
  DELETE {&alias}_Constraint.
END.
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
FOR EACH {&alias}_Partition-Set WHERE {&alias}_Partition-Set._Object-number = {&alias}_File._File-Num:
  FOR EACH {&alias}_Partition-Set-Detail OF {&alias}_Partition-Set:
    DELETE {&alias}_Partition-Set-Detail.
  END.
  DELETE {&alias}_Partition-Set.
END.
DELETE {&alias}_File.
