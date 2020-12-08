 /*************************************************************/
 /* Copyright (c) 2011-2017 by Progress Software Corporation  */
 /*                                                           */
 /* all rights reserved.  no part of this program or document */
 /* may be  reproduced in  any form  or by  any means without */
 /* permission in writing from progress Software Corporation. */
 /*************************************************************/ 
 /*------------------------------------------------------------------------
    File        : SecurityOptionsSource
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : rkumar
    Created     : Thu Nov 24 18:04:51 IST 2011
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.

using OpenEdge.DataAdmin.Error.UnsupportedOperationError from propath.
using OpenEdge.DataAdmin.DataAccess.DataAccessError from propath.
using OpenEdge.DataAdmin.ISecurityOptions from propath.
  
routine-level on error undo, throw.

class OpenEdge.DataAdmin.DataSource.SecurityOptionsSource: 
 /* {prodict/misc/misc-funcs.i}*/
 
 
/*    ------------------------------------------------------------------------------*/


/* ***************************  Definitions  ************************** */
    constructor public SecurityOptionsSource (  ):
        super (). 
    end constructor.
       
    method public void Fill(hbuffer as handle):
        if num-dbs EQ 0 then
          undo , throw  new AppError("No database connected!" + "~n" +
            "You must be connected to a database to acces this tool!").
            
        // check permissions starting itself
        isDbAdmin(USERID("DICTDB")).
        checkReadOnlyDatabase("DICTDB","_Db-option"). 
        
        hBuffer:buffer-create ( ).
        find first DICTDB._db where DICTDB._db._db-local = true  no-lock.
   
        for each DICTDB._db-option where DICTDB._db-option._db-recid = RECID(DICTDB._db) 
            and   DICTDB._db-option._db-option-type =  2 no-lock:

          if DICTDB._db-option._db-option-code =  "_pvm.noBlankUser" then 
            assign hBuffer::DisallowBlankUserid = logical(DICTDB._db-option._db-option-value). 
          if DICTDB._db-option._db-option-code =  "_pvm.recordSessions" then 
            assign hBuffer::RecordAuthenticatedSessions = logical(DICTDB._db-option._db-option-value). 
          if DICTDB._db-option._db-option-code =  "_pvm.RuntimePermissions" then 
            assign hBuffer::UseRuntimePermissions = logical(DICTDB._db-option._db-option-value). 
          if DICTDB._db-option._db-option-code =  "_pvm.useAppRegistry" then 
            assign hBuffer::TrustApplicationDomainRegistry = logical(DICTDB._db-option._db-option-value). 
        end.
        
        for each DICTDB._db-option where DICTDB._db-option._db-recid = RECID(DICTDB._db) 
            and   DICTDB._db-option._db-option-type =  1 no-lock:
          if DICTDB._db-option._db-option-code =  "_pvm.CDCUserID" then 
            assign hBuffer::CDCUserid = DICTDB._db-option._db-option-value. 
        end.
    end method.    
    
    method public void Save(phbuffer as handle):
        define variable hBeforeBuff as handle    no-undo.  
        define variable secOptions  as ISecurityOptions no-undo.
        
        if num-dbs EQ 0 then
          undo , throw  new AppError("No database connected!" + "~n" +
            "You must be connected to a database to acces this tool!").
            
        // check permissions starting itself
        isDbAdmin(USERID("DICTDB")).
        checkReadOnlyDatabase("DICTDB","_Db-option"). 
        
        hBeforeBuff = phBuffer:before-buffer.
        
        if hBeforeBuff:row-state = row-created then
            undo, throw new UnsupportedOperationError("Create SecurityOptions"). 
        if hBeforeBuff:row-state = row-deleted then
            undo, throw new UnsupportedOperationError("Delete SecurityOptions"). 
        phBuffer:find-first().
        
        /* add code from _db-optn.p here. also modify code where _db-optn gets called */
        find first DICTDB._db where DICTDB._db._db-local = true  no-lock.
        
        for each  DICTDB._db-option where DICTDB._db-option._db-recid = RECID(DICTDB._db) 
            and   DICTDB._db-option._db-option-type =  2 :

          if DICTDB._db-option._db-option-code =  "_pvm.noBlankUser" 
          and phBuffer::DisallowBlankUserid NE DICTDB._db-option._db-option-value then 
            assign DICTDB._db-option._db-option-value = phBuffer::DisallowBlankUserid. 
          if DICTDB._db-option._db-option-code =  "_pvm.recordSessions" 
          and phBuffer::RecordAuthenticatedSessions NE LOGICAL(DICTDB._db-option._db-option-value) then 
            assign DICTDB._db-option._db-option-value = phBuffer::RecordAuthenticatedSessions. 
          if DICTDB._db-option._db-option-code =  "_pvm.RuntimePermissions"  
          and phBuffer::UseRuntimePermissions NE LOGICAL(DICTDB._db-option._db-option-value) then 
            assign DICTDB._db-option._db-option-value = phBuffer::UseRuntimePermissions. 
          if DICTDB._db-option._db-option-code =  "_pvm.useAppRegistry" 
          and phBuffer::TrustApplicationDomainRegistry NE LOGICAL(DICTDB._db-option._db-option-value) then  
            assign DICTDB._db-option._db-option-value = phBuffer::TrustApplicationDomainRegistry. 
       end.
       
        find dictdb._Database-feature where dictdb._Database-feature._DBFeature_Name = "Change Data Capture" no-lock no-error.        
        if avail dictdb._Database-feature and dictdb._Database-feature._dbfeature_enabled = "1" then
        do:
            find DICTDB._db-option where DICTDB._db-option._db-recid = RECID(DICTDB._db)
                and DICTDB._db-option._db-option-code =  "_pvm.CDCUserID" no-error. 
            if avail DICTDB._db-option then 
            do:                
                if phBuffer::CDCUserid NE DICTDB._db-option._db-option-value then  
                    assign DICTDB._db-option._db-option-value = phBuffer::CDCUserid.            
            end.
            else if not avail DICTDB._db-option 
                    and (phBuffer::CDCUserid eq "APP" or phBuffer::CDCUserid eq "DB") then 
                do:
                    create DICTDB._Db-option.
                    assign 
                        DICTDB._db-option._db-option-code  = "_pvm.CDCUserID"
                        DICTDB._db-option._db-option-type  = 1
                        DICTDB._db-option._db-option-value = phBuffer::CDCUserid
                        DICTDB._db-option._db-option-description = "CDC User Identity"
                        DICTDB._db-option._db-recid = RECID(DICTDB._db).          
                end.
        end.
        
        catch e as AppError  :
            undo, throw  e.     
        end catch.
        
        catch e2 as Error  :
            undo, throw new DataAccessError(e2).
        end.
    end method.
    
    /*------------------------------------------------------------------------------
      Purpose:  Returns whether the user (pcUser) is a database administrator or not.
      Parameters: INPUT pcUser - Userid of the user to check
      Notes:  
    ------------------------------------------------------------------------------*/
    method public void isDbAdmin(pcUser as character):
        DEFINE VARIABLE lOk AS LOGICAL NO-UNDO.

        RUN prodict/_dctadmn.p ( INPUT USERID("DICTDB"),
            OUTPUT lOk ).

        if not lOk then
            undo , throw  new AppError("You do not have permission to run this tool!").        
    end.    
    
    method public void checkReadOnlyDatabase(INPUT pcdbNname AS CHARACTER, INPUT pctableName AS CHARACTER):
        DEFINE VARIABLE hFileBuffer AS HANDLE NO-UNDO.
        DEFINE VARIABLE cWhere      AS CHAR   NO-UNDO.
        
        CREATE BUFFER hFileBuffer FOR TABLE pcdbNname + "._File" NO-ERROR.
    
        /* if we can't even get a handle to the table, assume it's that
          user doesn't have permissions.
        */
        IF NOT VALID-HANDLE(hFileBuffer) THEN
            undo , throw  new AppError("You do not have permission to run this tool!").
    
        ASSIGN cWhere = "WHERE " + pcdbNname + "._File._File-name = '" +
            pctableName + "'".
        hFileBuffer:FIND-FIRST(cWhere, NO-LOCK).
    
        IF NOT CAN-DO(hFileBuffer::_Can-read,USERID(pcdbNname)) THEN DO:
             undo , throw  new AppError("You do not have read permission to use this option.").          
        END.
    
        IF CAN-DO("READ-ONLY", DBRESTRICTIONS(pcdbNname)) or
            NOT CAN-DO(hFileBuffer::_Can-write,USERID(pcdbNname)) THEN
           undo , throw  new AppError("You do not have write permission to use this option.").        
    end.    
    
end class.