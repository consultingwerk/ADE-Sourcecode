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
/*

Procedure:    adetran/vt/_props.i
Author:       F. Chang
Created:      1/95
Updated:      9/95
Purpose:      Visual Translator's Properties Window
Background:   Include file for populating a temp-table which
              the Properties Window uses for keeping track of objects.
Called By:    vt/_props.w
*/

/* First look for an instance that is already translated */
FIND FIRST kit.XL_Instance WHERE
           kit.XL_Instance.StringKey  BEGINS SUBSTRING({1}, 1, 63, "RAW":U) AND
           COMPARE(kit.XL_Instance.SourcePhrase, "=":U, {1}, "CAPS":U) AND
           kit.XL_Instance.ProcedureName = tmp-flnm NO-LOCK NO-ERROR.
IF (AVAILABLE kit.XL_Instance) AND (kit.XL_Instance.TargetPhrase <> "":U) THEN DO:
  CREATE tTblObj.
  ASSIGN tTblObj.ObjWName = PFileName
         tTblObj.ObjName = {2}
         tTblObj.ObjType = "{3}":u
         tTblObj.ObjOLbl = {1}
         tTblObj.ObjNLbl = kit.XL_Instance.TargetPhrase
         tTblObj.FoundIn = "INST":U
         {1}  = kit.XL_Instance.TargetPhrase.
END.
ELSE DO: /* No translated instance, now look for a glossary entry */
  no-andpersand = REPLACE({1}, "&":U, "").
  FIND FIRST kit.XL_GlossEntry WHERE
      kit.XL_GlossEntry.ShortSrc BEGINS SUBSTRING(no-andpersand, 1, 63, "RAW":U) AND
      COMPARE(kit.XL_GlossEntry.SourcePhrase, "=":U, no-andpersand, "CAPS":U)
    NO-LOCK NO-ERROR.
  IF (AVAILABLE kit.XL_GlossEntry) AND (kit.XL_GlossEntry.TargetPhrase <> "") THEN DO:
    CREATE tTblObj.
    ASSIGN tTblObj.ObjWName = pFileName
           tTblObj.ObjName  = {2}
           tTblObj.ObjType  = "{3}":U
           tTblObj.ObjOLbl  = no-andpersand
           tTblObj.ObjNLbl  = kit.XL_GlossEntry.TargetPhrase
           tTblObj.FoundIn  = "GLOSS":U.
    IF AutoTrans THEN ASSIGN {1}  = kit.XL_GlossEntry.TargetPhrase.
  END.
END.
