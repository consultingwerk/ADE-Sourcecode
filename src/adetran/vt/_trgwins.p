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
Purpose:      Write trigger for XL_Instance
Background:   Fired off when a write occurs for XL_Instance
              Updates XL_Project.UpdateDate.
*/

TRIGGER PROCEDURE FOR WRITE OF kit.XL_Instance.
  IF AVAIL kit.XL_Instance THEN
     kit.XL_Instance.UpdateDate = TODAY.
  find first kit.XL_Project exclusive-lock no-error.
  IF AVAILABLE kit.XL_Project THEN 
     kit.XL_Project.UpdateDate = TODAY.
