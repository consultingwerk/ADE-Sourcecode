/************************************************
Copyright (c)  2014, 2015 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : ApplicationPlatformEnum
    Purpose     : Enumeration of Mobile platform types
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu May 15 16:57:57 EDT 2014
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.EnumMember.
using OpenEdge.Mobile.ApplicationPlatformEnum.

class OpenEdge.Mobile.ApplicationPlatformEnum inherits EnumMember: 
    define public static property WindowsPhone as ApplicationPlatformEnum no-undo 
    get:
        if not valid-object (ApplicationPlatformEnum:WindowsPhone) then 
            ApplicationPlatformEnum:WindowsPhone = new ApplicationPlatformEnum (1, "WP":U) .
            
        return ApplicationPlatformEnum:WindowsPhone.
    end get . 
    private set. 

    define public static property Windows8 as ApplicationPlatformEnum no-undo 
    get:
        if not valid-object (ApplicationPlatformEnum:Windows8) then 
            ApplicationPlatformEnum:Windows8 = new ApplicationPlatformEnum (2, "W8":U) .
            
        return ApplicationPlatformEnum:Windows8.           
    end get . 
    private set. 

    define public static property Android as ApplicationPlatformEnum no-undo 
    get:
        if not valid-object (ApplicationPlatformEnum:Android) then 
            ApplicationPlatformEnum:Android= new ApplicationPlatformEnum (3, "A":U) .
            
        return ApplicationPlatformEnum:Android.           
    end get . 
    private set. 
    
    define public static property IOS as ApplicationPlatformEnum no-undo 
    get:
        if not valid-object (ApplicationPlatformEnum:IOS) then 
            ApplicationPlatformEnum:IOS = new ApplicationPlatformEnum (4, "I":U) .
            
        return ApplicationPlatformEnum:IOS.           
    end get . 
    private set. 

    &global-define EnumMembers WP,W8,A,I

	constructor protected ApplicationPlatformEnum ( input piValue as integer, input pcName as character ):
		super (input piValue, input pcName).
	end constructor.
	
	{Consultingwerk/EnumFromString.i OpenEdge.Mobile.ApplicationPlatformEnum}

end class.