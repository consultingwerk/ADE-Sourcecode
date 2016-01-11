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
* Contributors: MIP Holdings (Pty) Ltd ("MIP")                       *
*               PSC                                                  *
*                                                                    *
*********************************************************************/
  DEFINE BUFFER new_attribute_value FOR ryc_attribute_value.

  IF NEW ryc_smartobject
  THEN DO :
    /* copy attribute values from the object type only when not in assignment mode */
    /* this is so that attributes do net get duplicated when existing objects are  */
    /* re-created from transaction/action tables */

    {af/sup2/afglobals.i}
    DEFINE VARIABLE lAssignUnderway AS LOGICAL NO-UNDO.
    IF VALID-HANDLE(gshSessionManager)
    THEN
      RUN getActionUnderway IN gshSessionManager
                           (INPUT  "":U
                           ,INPUT  "ASS":U
                           ,INPUT  ryc_smartobject.object_filename
                           ,INPUT  "":U
                           ,INPUT  "":U
                           ,INPUT  NO /* Do not remove record */
                           ,OUTPUT lAssignUnderway).
    ELSE
      ASSIGN
        lAssignUnderway = NO.

    IF NOT lAssignUnderway
    THEN
      FOR EACH ryc_attribute_value NO-LOCK
        WHERE ryc_attribute_value.OBJECT_type_obj           = ryc_smartobject.OBJECT_type_obj
        AND   ryc_attribute_value.smartobject_obj           = 0
        AND   ryc_attribute_value.OBJECT_instance_obj       = 0
        AND   ryc_attribute_value.container_smartobject_obj = 0
        :

        CREATE new_attribute_value.
        ASSIGN
          new_attribute_value.smartobject_obj             = ryc_smartobject.smartobject_obj
          new_attribute_value.collect_attribute_value_obj = new_attribute_value.attribute_value_obj.
        BUFFER-COPY ryc_attribute_value EXCEPT attribute_value_obj smartobject_obj collect_attribute_value_obj TO new_attribute_value
        ASSIGN
          new_attribute_value.inheritted_value = YES.
      END.
  END.
