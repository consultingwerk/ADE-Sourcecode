/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : JsonDataTypeEnum
    Purpose     : Enumaeration of JSON data typed. Taken from the ABL doc. 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed Nov 05 16:42:01 EST 2014
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.EnumMember.
using OpenEdge.Core.JsonDataTypeEnum.
using Progress.Json.ObjectModel.JsonDataType.

class OpenEdge.Core.JsonDataTypeEnum inherits EnumMember final:
    &global-define EnumMembers
    &global-define EnumValues
         
    {Consultingwerk/EnumMember.i Array      JsonDataType:ARRAY      JsonDataTypeEnum}
    {Consultingwerk/EnumMember.i String     JsonDataType:STRING     JsonDataTypeEnum}
    {Consultingwerk/EnumMember.i Number     JsonDataType:NUMBER     JsonDataTypeEnum}
    {Consultingwerk/EnumMember.i Boolean    JsonDataType:BOOLEAN    JsonDataTypeEnum}
    {Consultingwerk/EnumMember.i Object     JsonDataType:OBJECT     JsonDataTypeEnum}
    {Consultingwerk/EnumMember.i Null       JsonDataType:NULL       JsonDataTypeEnum}
		
	constructor protected JsonDataTypeEnum ( input piValue as integer, input pcName as character ):
		super (input piValue, input pcName).
	end constructor.

    {Consultingwerk/EnumFromString.i  OpenEdge.Core.JsonDataTypeEnum}
end class.