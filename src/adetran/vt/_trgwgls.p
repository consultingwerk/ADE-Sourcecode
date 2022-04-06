/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*

Procedure:    adetran/vt/_trgwgls.p
Author:       F. Chang
Deleted:      1/95 
Updated:      9/95
Purpose:      Write trigger for XL_Glossary
Background:   Fired off when a write occurs for XL_GlossEntry.
              Writing occurs when the translator updates a
              glossary record.  The XL_Project.UpdateDate record
              is also updated.
*/

TRIGGER PROCEDURE FOR WRITE OF kit.XL_GlossEntry.
  find first kit.XL_Project exclusive-lock no-error.   
  IF AVAILABLE kit.XL_Project THEN 
     kit.XL_Project.UpdateDate = TODAY.

