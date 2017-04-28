/************************************************
Copyright (c) 2016 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : PAMStatusEnum
    Purpose     : ABL Enum based on Progress.Security.PAMStatus values
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Mar 03 11:11:01 EST 2016
    Notes       : * Based on Progress.Security.PAMStatus
  ----------------------------------------------------------------------*/
enum OpenEdge.Security.PAMStatusEnum:
    define enum None                    = 0     // not in Progress.Security.PAMStatus
                Success             
                PermissionDenied    
                AuthenticationFailed
                MissingCredentials  
                AuthenticationAccess
                UnknownUser         
                AccountExpired      
                PasswordExpired     
                MaxTries            
                InvalidConfiguration
                Custom
                AccountDisabled         //"The user's account was disabled"
                AccessRevoked           //"Access has been revoked for the user account"
                LoginDenied             //"Login is denied"
                AccessDenied            //"Access is denied"
                LoginLockout            //"The user's account has been locked for security reasons"
                .
end enum.
