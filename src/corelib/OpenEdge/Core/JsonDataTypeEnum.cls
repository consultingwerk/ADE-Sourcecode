/************************************************
Copyright (c)  2014, 2015 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : JsonDataTypeEnum
    Purpose     : Enumaeration of JSON data typed. Taken from the ABL doc. 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed Nov 05 16:42:01 EST 2014
    Notes       : Based on the values in Progress.Json.ObjectModel.JsonDataType
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

enum OpenEdge.Core.JsonDataTypeEnum :
    define enum       String      =  1 /* = JsonDataType:STRING */ 
                      Number   /* =  2 = JsonDataType:NUMBER */     
                      Boolean  /* =  3 = JsonDataType:BOOLEAN */
                      Object   /* =  4 = JsonDataType:OBJECT */
                      Array    /* =  5 = JsonDataType:ARRAY */
                      Null     /* =  6 = JsonDataType:NULL */
                      .
end enum.
