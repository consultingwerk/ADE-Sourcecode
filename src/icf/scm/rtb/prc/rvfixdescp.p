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
DEFINE VARIABLE cRTBName AS CHARACTER NO-UNDO.

FOR EACH ryc_smartobject NO-LOCK,
   FIRST gsc_object NO-LOCK
   WHERE gsc_object.Object_Obj = ryc_smartobject.Object_Obj:

  FOR EACH rvt_item_version EXCLUSIVE-LOCK
     WHERE rvt_item_version.configuration_type = "rycso":U
       AND rvt_item_version.scm_object_name = ryc_smartobject.Object_filename:

    ASSIGN rvt_item_version.ITEM_description =  gsc_object.Object_description.

  END.

  IF gsc_object.Object_Extension <> "":U  THEN  
    ASSIGN cRTBName = gsc_object.Object_filename + "." + gsc_object.Object_Extension.
  ELSE
    IF NUM-ENTRIES(gsc_object.Object_filename,".") > 1 /* Check if extension inc in filename */
    AND LENGTH(ENTRY(NUM-ENTRIES(gsc_object.Object_filename,".":U),gsc_object.Object_filename,".":U)) <= 3
    THEN ASSIGN cRTBName = gsc_object.Object_filename.
    ELSE ASSIGN cRTBName = gsc_object.Object_filename + ".ado":U.

  FOR EACH rtb_ver EXCLUSIVE-LOCK
     WHERE rtb_ver.obj-type = "pcode":U
       AND rtb_ver.OBJECT = cRTBName:

    ASSIGN rtb_ver.DESCRIPTION = gsc_object.Object_description.

  END.

END.

