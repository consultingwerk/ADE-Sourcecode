/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*

Procedure:    adetran/vt/_trgdins.p
Author:       F. Chang
Created:      1/95 
Updated:      9/95
Purpose:      Delete trigger for XL_Instance
Background:   Fired off when a delete occurs for XL_Instance
              Deletes occurs when the translator presses the
              delete button on the toolbar and/or the delete
              menu item under Edit.  In addition to the delete
              taking place, the trigger also records the update
              date.
*/

TRIGGER PROCEDURE FOR DELETE OF kit.XL_Instance.
  find first kit.XL_Project exclusive-lock no-error.
  IF AVAILABLE kit.XL_Project THEN 
     assign kit.XL_Project.UpdateDate = TODAY
     kit.XL_Project.NumberOfPhrases = kit.XL_Project.NumberOfPhrases - 1.
