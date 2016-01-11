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
 * Program Name: adetran\pm\_putproj.p
 * Description : Creates and assigns a new project master record
 *
 */


define input  parameter DatabaseName             as char.
define input  parameter Comments                 as char.
define input  parameter ProjectRevision          as char.
define input  parameter ProjectDirectory         as char. 
define input  parameter ApplDirectory            as char. 
define input  parameter DisplayType              as char.
define input  parameter MustUseGlossary          as logical.
define input  parameter SupersedeGlossary        as logical.
define output parameter ErrorStatus              as logical.

FIND FIRST xlatedb.XL_Project EXCLUSIVE-LOCK NO-ERROR.
/* If we were copying a project DB then we have it.  If not available then
   we were creating a new project db.                                   */
IF NOT AVAILABLE xlatedb.XL_Project THEN CREATE xlatedb.XL_Project.
/* Add the new stuff*/
assign
  xlatedb.XL_Project.ProjectName              = DatabaseName
  xlatedb.XL_Project.ProjectDesc              = Comments
  xlatedb.XL_Project.ProjectRevision          = ProjectRevision + CHR(4) + "No":U
         /* The "NO" is a hack to indicate that statistics haven't been updated */
  xlatedb.XL_Project.RootDirectory            = ProjectDirectory
  xlatedb.XL_Project.ApplDirectory            = RIGHT-TRIM(ApplDirectory, "~\":U)
  xlatedb.XL_Project.MustUseGlossary          = MustUseGlossary  
  xlatedb.XL_Project.SupersedeGlossary        = SupersedeGlossary
  xlatedb.XL_Project.DeleteTranslations       = No /* Removed this option */
  xlatedb.XL_Project.CreateDate               = Today
  xlatedb.XL_Project.UpdateDate               = Today
  xlatedb.XL_Project.DisplayType              = DisplayType NO-ERROR.
 
ErrorStatus = error-status:error.   

