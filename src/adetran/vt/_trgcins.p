/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*

Procedure:    adetran/vt/_trgcins.p
Author:       F. Chang
Created:      1/95 
Updated:      9/95
Purpose:      Create trigger for XL_Instance
Background:   Fired off when a create occurs for XL_Instance
              which *only* should happen when a kit is created
              since no actual inserts are allow.  Updates
              XL_Project.UpdateDate and XL_Project.NumberOfPhrases.
*/

TRIGGER PROCEDURE FOR CREATE OF kit.XL_Instance.
  IF AVAIL kit.XL_Instance THEN
     kit.XL_Instance.UpdateDate = TODAY.
  find first kit.XL_Project exclusive-lock no-error.
  IF AVAILABLE kit.XL_Project THEN 
     assign kit.XL_Project.UpdateDate = TODAY
            kit.XL_Project.NumberOfPhrases = kit.XL_Project.NumberOfPhrases + 1.
