/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : PushNotificationFilterOperandEnum
    Purpose     : Various operands for building filter strings for push notifications 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Fri Jun 13 14:06:51 EDT 2014
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Mobile.PushNotificationFilterOperandEnum.
using OpenEdge.Core.EnumMember.

class OpenEdge.Mobile.PushNotificationFilterOperandEnum inherits EnumMember: 
    &global-define EnumValues 
    
    {Consultingwerk/EnumMember.i Equals         1        PushNotificationFilterOperandEnum}
    {Consultingwerk/EnumMember.i NotEqual       2        PushNotificationFilterOperandEnum}
    {Consultingwerk/EnumMember.i Includes       3        PushNotificationFilterOperandEnum}
    {Consultingwerk/EnumMember.i NotIncludes    4        PushNotificationFilterOperandEnum}
    {Consultingwerk/EnumMember.i Matches        5        PushNotificationFilterOperandEnum}
    {Consultingwerk/EnumMember.i GreaterThan    6        PushNotificationFilterOperandEnum}
    {Consultingwerk/EnumMember.i GreaterOrEqual 7        PushNotificationFilterOperandEnum}
    {Consultingwerk/EnumMember.i LessThan       8        PushNotificationFilterOperandEnum}
    {Consultingwerk/EnumMember.i LessOrEqual    9        PushNotificationFilterOperandEnum}
    /* Last 3 for GEO type */
    {Consultingwerk/EnumMember.i Near           10       PushNotificationFilterOperandEnum}
    {Consultingwerk/EnumMember.i NearSphere     11       PushNotificationFilterOperandEnum}
    {Consultingwerk/EnumMember.i Within         12       PushNotificationFilterOperandEnum}
    {Consultingwerk/EnumMember.i And            13       PushNotificationFilterOperandEnum}
    {Consultingwerk/EnumMember.i Or             14       PushNotificationFilterOperandEnum}

    constructor protected PushNotificationFilterOperandEnum( input piValue as integer, input pcName as character ):
        super (input piValue, input pcName).
    end constructor.
    
    {Consultingwerk/EnumFromString.i OpenEdge.Mobile.PushNotificationFilterOperandEnum}
end class.