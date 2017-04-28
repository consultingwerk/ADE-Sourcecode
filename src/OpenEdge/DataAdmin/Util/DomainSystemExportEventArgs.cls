/************************************************
  Copyright (c) 2016 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : DomainSystemExportEventArgs
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Fri Apr 22 11:53:11 EDT 2016
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.EventArgs.
using OpenEdge.Core.Assert.
using OpenEdge.DataAdmin.Util.StsDomain.

class OpenEdge.DataAdmin.Util.DomainSystemExportEventArgs inherits EventArgs:
    /* The domain being exported, in the STS config format */
    define public property Domain as StsDomain no-undo get. private set.
    
    /* The name of the database in which the domain is defined */
    define public property DbName as character no-undo get. private set.

    /* The domain being exported, in the STS config format */
    define public property DomainName as character no-undo
        get():
            return this-object:Domain:Name.
        end get.
    
    /* Cancels the export of this domain */
    define public property Cancel as logical no-undo initial false get. private set. 
    
    /* (mandatory) A reason for cancelling the export. */
    define public property CancelReason as character no-undo get. private set.
    
    /* Constructor
    
       @param character The database name
       @param handle An available buffer for the domain export record */
    constructor public DomainSystemExportEventArgs(input pcDbName as character,
                                                   input poDomain as StsDomain):
        Assert:NotNullOrEmpty(pcDbName, 'Database').
        Assert:NotNull(poDomain, 'Domain').
        
        assign this-object:DbName = pcDbName
               this-object:Domain = poDomain
               .
    end constructor.
    
    /* Cancels the export 
       
       @param character  A clear-text reason or the cancellation */
    method public void CancelExport(input pcReason as character):
        Assert:NotNullOrEmpty(pcReason, 'Cancellation reason').
        assign this-object:Cancel       = true
               this-object:CancelReason = pcReason.
    end method.
    
    /* Resumes the export 
       
       @param character  An optional  clear-text reason for resuming */
    method public void ResumeExport(input pcReason as character):
        Assert:NotNull(pcReason, 'Un-cancellation reason').
        assign this-object:Cancel       = false
               this-object:CancelReason = pcReason.
    end method.
    
end class.