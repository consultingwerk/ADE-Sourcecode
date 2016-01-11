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
