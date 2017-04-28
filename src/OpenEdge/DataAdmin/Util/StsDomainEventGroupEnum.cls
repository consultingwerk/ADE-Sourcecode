/************************************************
  Copyright (c) 2016 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : StsDomainEventGroupEnum
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 
    Notes       : 
  ----------------------------------------------------------------------*/
enum OpenEdge.DataAdmin.Util.StsDomainEventGroupEnum flags:
    define enum None                = 0
                
                Client
                TokenAuthenticate
                TokenExchange
                TokenRevoke
                TokenValidate
                TokenRefresh
                Policy
                SessionLogin
                SessionLogout
                SessionValidate
                SessionRefresh
                .
                
end enum.
