/************************************************
Copyright (c)  2014, 2015 by Progress Software Corporation. All rights reserved.
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

enum OpenEdge.Mobile.PushNotificationFilterOperandEnum: 
    define enum       Equals         = 1 
                      NotEqual
                      Includes 
                      NotIncludes 
                      Matches 
                      GreaterThan 
                      GreaterOrEqual 
                      LessThan 
                      LessOrEqual 
                      /* Last 3 for GEO type */
                      Near
                      NearSphere
                      Within
                      Intersects
                      /* array operator */
                      All
                      /* logical/join operands */
                      And
                      Or
                      Not
                      Nor
                      .
end enum.
