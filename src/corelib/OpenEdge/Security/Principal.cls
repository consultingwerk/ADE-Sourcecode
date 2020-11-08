/************************************************
  Copyright (c) 2016-2020 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : Principal
    Purpose     : A wrapper/helper around a ABL Client-principal object 
    Author(s)   : pjudge
    Created     : Thu Feb 25 14:19:36 EST 2016
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.DataTypeEnum.
using OpenEdge.Security.Principal.
using Progress.Lang.AppError.
using OpenEdge.Core.AssertionFailedError.
using Progress.Lang.OERequestInfo.
using OpenEdge.Core.Memptr.

class OpenEdge.Security.Principal :
    /* Determines whether the contained token will be destroyed when this wrapper 
       is destroyed. Typically TRUE for Imports */
    define private variable mlAutoDestroy as logical no-undo.
    
    /* (mandatory) The C-P this class represents. */
    define public property Token as handle no-undo get. private set.
    
    /* Default constructor.
    
       Made private since we need this class to always hold a 
       client-principal */
    constructor private Principal():
    end constructor.
    
    /* Constructor.
    
       @param handle A valid client-principal (state not checked) */
    constructor public Principal(input phClientPrincipal as handle):
        this-object(phClientPrincipal, false).
    end method.
    
    /* Constructor.
       
       @param handle A valid client-principal (state not checked) 
       @param logical Determines whether the contained token will be destroyed 
                      when this wrapper is destroyed. Typically TRUE for Imports */ 
    constructor public Principal(input phClientPrincipal as handle,
                                 input plAutoDestroy as logical):
        Assert:IsType(phClientPrincipal, DataTypeEnum:ClientPrincipal, 'Token').
        Assert:NotUnknown(plAutoDestroy, 'Auto-destroy flag').
        
        assign this-object:Token = phClientPrincipal
               mlAutoDestroy     = plAutoDestroy.
    end constructor.
    
    destructor Principal():
        if     mlAutoDestroy 
           and valid-object(this-object:Token ) then
            delete object this-object:Token no-error.
        
        assign this-object:Token = ?.
    end destructor. 
    
    /* Validates the current token. 
       
       @return logical TRUE if the token is valid.      */
    method public logical Validate():
        return this-object:Token:validate-seal().
    end method.

    /* Validates the current token. 
       
       @param character The key used to seal the principal
       @return logical TRUE if the token is valid.      */
    method public logical Validate(input pcKey as character):
        Assert:NotNull(pcKey, 'Key').
        
        return this-object:Token:validate-seal(pcKey).
    end method.
    
    /* Authorises the current token for a particular role
       
       @param character A non-empty role
       @return logical TRUE if the user is authorised for the given role */
    method public logical Authorize(input pcRole as character):
        if pcRole eq ? then
            return false.
        
        return can-do(this-object:Token:roles, pcRole).
    end method.
    
    /* Authorises the current token for all given roles 
       
       @param character[] A non-empty array of roles
       @return logical TRUE if the user is authorised for ALL the given roles */
    method public logical Authorize(input pcRole as character extent):
        return AuthorizeAll(pcRole).
    end method.
    
    /* Authorises the current token for all given roles 
       
       @param character[] A non-empty array of roles
       @return logical TRUE if the user is authorised for ALL the given roles */
    method public logical AuthorizeAll(input pcRole as character extent):
        define variable lAllowed as logical no-undo.
        define variable iLoop as integer no-undo.
        
        assign lAllowed = no.
        
        do iLoop = extent(pcRole) to 1 by -1:
            assign lAllowed = lAllowed and Authorize(pcRole[iLoop]).
            if not lAllowed then
                leave.
        end.
        
        return lAllowed.
    end method.
    
    /* Authorises the current token for ONE of the given roles 
       
       @param character[] A non-empty array of roles
       @return logical TRUE if the user is authorised for ONE the given roles */
    method public logical AuthorizeOne(input pcRole as character extent):
        define variable loop as integer no-undo.
        
        do loop = extent(pcRole) to 1 by -1:
            if Authorize(pcRole[loop]) then
                return true.
        end.
        
        return false.
    end method.    
    
    /* Asserts the user represented by this token in the current session.
       Will set for all connected dbs.
       
       @return logical TRUE if the assertion passed */
    method public logical AssertUser():
        return security-policy:set-client(this-object:Token).
    end method.
    
    /* Asserts the user represented by this token in the current session.
       Passing in a value of * results in asserting the user against all
       connected DB's.
       
       @param character The name of the connected database (logical or alias) 
                        into which the user is asserted.
       @return logical TRUE if the assertion passed */
    method public logical AssertUser(input pcDb as character):
        define variable lAsserted as logical no-undo.
        
        Assert:NotNullOrEmpty(pcDb, 'Database name').
        
        case pcDb:
            when '*':u then
                assign lAsserted = AssertUser(). 
            otherwise
            do:        
                if not connected(pcDb) then
                    return error new AppError(substitute('Database &1 not connected', pcDb), 0).
                
                assign lAsserted = set-db-client(this-object:Token, pcDb).
            end.
        end case.
        
        return lAsserted.
    end method.
    
    /* Creates a new Principal from RAW data
       
       @param raw An exported version of a CP 
       @return Principal A new object representing the input CP */
    method static public Principal Import(input prCP as raw):
        define variable hCP as handle no-undo.
        
        Assert:NotNull(prCP, 'Input token').
        
        create client-principal hCP.
        hCP:import-principal (prCP).
        
        return new Principal(hCP, true).
    end method.

    /* Creates a new Principal from BASE64 data
       
       @param character An exported version of a CP, encoded as base64 
       @return Principal A new object representing the input CP */
    method static public Principal Import(input pcCP as character):
        define variable rCP as raw no-undo.
        
        Assert:NotNullOrEmpty(pcCP, 'Input token').
        
        assign rCP = base64-decode(pcCP).
        
        return Principal:Import(rCP).
    end method.
    
    /* Creates a new Principal from the CP asserted in this session
       
       @return Principal A new object representing the input CP. May be null */
    method static public Principal Import():
        define variable hCP as handle no-undo.
        
        assign hCP = security-policy:get-client().
        if valid-handle(hCP) then
            return new Principal(hCP, true).
        
        return ?.
    end method.
    
    /* Creates a new Principal from the CP returned by a server. 
       
       @param OERequestInfo The request info containing the CP
       @return Principal A new object representing the input CP. May be null */
    method static public Principal Import(input poRequestInfo as OERequestInfo):
        define variable hCP as handle no-undo.
        
        if not valid-object(poRequestInfo) then
            return ?.
        
        assign hCP = poRequestInfo:GetClientPrincipal().
        if valid-handle(hCP) then
            return new Principal(hCP, true).
        
        return ?.
    end method.
    
    /* Creates a new Principal from the CP asserted against a database 
       
       @param integer The logical DB connection number
       @return Principal A new object representing the input CP. May be null */
    method static public Principal Import(input pDbNum as integer):
        define variable hCP as handle no-undo.
        define variable name as character no-undo.
        
        Assert:NotNull(pDbNum, 'Logical database number').
        if pDbNum gt num-dbs then
            undo, throw new AssertionFailedError(substitute('&1 is greater than the number of connected DBs &2', pDbNum, num-dbs)).
        
        assign name = ldbname(pDbNum)
               hCP  = get-db-client(name)
               .
        if valid-handle(hCP) then
            return new Principal(hCP, true).
        
        return ?.
    end method.
    
    /* Creates a new Principal from a object-wrapper memptr 
        
       CALLER IS RESPONSIBLE FOR MEMORY DEALLOCATION
       
       @param Memptr The OO wrapper containing the CP
       @return Principal A new object representing the input CP. May be null */
    method static public Principal Import(input poCP as class Memptr):
        Assert:NotNull(poCP, 'Client principal').
        
        return Principal:Import(poCP:Value).
    end method.
    
    /* Creates a new Principal from a primitive memptr.
    
       CALLER IS RESPONSIBLE FOR MEMORY DEALLOCATION
       
       @param memptr The CP
       @return Principal A new object representing the input CP. May be null */
    method static public Principal Import(input pmCP as memptr):
        define variable rCP as raw no-undo.
        
        Assert:NotNull(get-size(pmCP), 'Client principal size').
        Assert:IsPositive(get-size(pmCP), 'Client principal size').
        
        assign rCP = pmCP.
        return Principal:Import(rCP).
    end method.
    
end class.