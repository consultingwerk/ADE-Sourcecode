/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*


Procedure:    adetran/common/_environ.p
Author:       R. Ryan
Created:      1/95 
Updated:      9/95
Purpose:      Used by Visual Translator to check whether or not a
              PROGRESS.INI or other settings file is used.  If it
              was, the calling program resets itself by issuing a
              'USE "".'.
              
Called By:    vt/_environ.p
*/


define output parameter pSettingsFile as char no-undo.

find first kit.XL_Project no-lock no-error.
if available kit.XL_Project then
  pSettingsFile = kit.XL_Project.SettingsFile.

