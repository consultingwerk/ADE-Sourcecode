/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*

Procedure:    adetran/vt/_trgdgls.p
Author:       F. Chang
Deleted:      1/95 
Updated:      9/95
Purpose:      Delete trigger for XL_Glossary
Background:   Fired off when a Delete occurs for XL_GlossEntry
              Delete occurs when the translator deletes a record
              from the glossary. As this counter gets decremented the
              XL_Project.GlossaryCount and XL_Project.UpdateDate
              fields are also updated.
*/

TRIGGER PROCEDURE FOR DELETE OF kit.XL_GlossEntry.
  find first kit.XL_Project exclusive-lock no-error.
  IF AVAILABLE kit.XL_Project THEN 
     assign kit.XL_Project.UpdateDate = TODAY
            kit.XL_Project.GlossaryCount = kit.XL_Project.GlossaryCount - 1.
