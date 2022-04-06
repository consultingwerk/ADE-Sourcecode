/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*

Procedure:    adetran/vt/_trgcgls.p
Author:       F. Chang
Created:      1/95 
Updated:      9/95
Purpose:      Create trigger for XL_Glossary
Background:   Fired off when a create occurs for XL_GlossEntry.
              Create occurs when the translator does one of three
              things: during the kit creation, insert a record 
              into the glossary, imports records into the
              glossary.  As this counter gets incremented, the
              XL_Project.GlossaryCount and XL_Project.UpdateDate
              fields are also updated.
*/


TRIGGER PROCEDURE FOR CREATE OF kit.XL_GlossEntry.
  find first kit.XL_Project exclusive-lock no-error.
 
  IF AVAILABLE kit.XL_Project THEN 
     assign kit.XL_Project.UpdateDate = TODAY
            kit.XL_Project.GlossaryCount = kit.XL_Project.GlossaryCount + 1.
