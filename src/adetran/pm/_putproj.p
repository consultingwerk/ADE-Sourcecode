/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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

