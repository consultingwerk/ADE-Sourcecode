/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*

Procedure:    adetran/vt/_trgdprc.p
Author:       F. Chang
Deleted:      1/95 
Updated:      9/95
Purpose:      Create trigger for XL_Procedure
Background:   Fired off when a the number of procedures is
              decremented (this shouldn't happen but the trigger
              was left to handle this possibility).
              The XL_Procedure.NumberOfProcedures fields reflects
              this count and the XL_Project.UpdateDate shows
              today's date.
             
*/

TRIGGER PROCEDURE FOR DELETE OF kit.XL_Procedure.
   find first kit.XL_Project exclusive-lock no-error.
   if avail kit.XL_Project then
     assign kit.XL_Project.UpdateDate = TODAY
            kit.XL_Project.NumberOfProcedures = 
                   kit.XL_Project.NumberOfProcedures - 1.
