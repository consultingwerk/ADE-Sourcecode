 /*************************************************************/
  /* Copyright (c) 2011 by progress Software Corporation.      */
  /*                                                           */
  /* all rights reserved.  no part of this program or document */
  /* may be  reproduced in  any form  or by  any means without */
  /* permission in writing from progress Software Corporation. */
  /*************************************************************/
 /*------------------------------------------------------------------------
    File        : UtilityCommand.cls
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Fri Apr 29 13:19:23 EDT 2011
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.* from propath.
 
using OpenEdge.DataAdmin.Message.IUtilityRequest from propath.
using OpenEdge.DataAdmin.Error.IllegalArgumentError from propath. 
using OpenEdge.DataAdmin.ServerCommand.IServerCommand from propath.
using OpenEdge.DataAdmin.Error.UnsupportedOperationError from propath.
using OpenEdge.DataAdmin.Error.DataAdminError from propath.

routine-level on error undo, throw.

class OpenEdge.DataAdmin.ServerCommand.SequenceValueWriterCommand implements IServerCommand: 
	/*------------------------------------------------------------------------------
			Purpose:  																	  
			Notes:  																	  
	------------------------------------------------------------------------------*/
	{daschema/utilityoptions.i REFERENCE-ONLY}
    {daschema/tenantdata.i REFERENCE-ONLY}
	
	define property ProcedureHandle as handle no-undo get. set.
		
	constructor public SequenceValueWriterCommand (databasename as char):
		super ().	
	end constructor.
   
    method private void ValidateRequest():
       
    end method.    
     
    method public void Execute(prequest as IUtilityRequest):
        define variable hUtil as handle no-undo.
        define variable hTenant as handle no-undo.

        define variable cTenantFullName as character no-undo.
        define variable cFullName as character no-undo.
        define variable iStat as integer no-undo.
        define variable err as Error no-undo.
        
        hutil = pRequest:DataHandle:get-buffer-handle ("ttUtilityOptions"):table-handle.
        hTenant = pRequest:DataHandle:get-buffer-handle ("ttTenantData"):table-handle.
        
        BindUtility(table-handle hUtil  bind).
        BindTenant(table-handle hTenant bind).
         
        run prodict/dmpseqvals.p persistent set ProcedureHandle.
        
        find ttUtilityOptions no-error.
        if ambiguous ttUtilityOptions then 
            undo, throw new IllegalArgumentError("More than one option record passed to Utility Command"). 
        if not avail ttUtilityOptions then 
            undo, throw new IllegalArgumentError("No option record passed to Utility Command"). 
        
        if lookup(ttUtilityOptions.SequenceSelection,"all,shared,tenant") EQ 0 then
            undo, throw new IllegalArgumentError("SequenceSelection " + quoter(ttUtilityOptions.SequenceSelection) + " passed to Utility Command.").
             
        run SetSilent in ProcedureHandle(true).
        
        run setCodePage in Procedurehandle(ttUtilityOptions.CodePage). 
        
        if not validdirectory(ttUtilityOptions.Directory) then
        do:
            os-create-dir VALUE(ttUtilityOptions.Directory). 
            iStat = os-error. 
        
            if not session:batch-mode then
            do:        
                if iStat <> 0 then
                    message "Cannot create directory " + ttUtilityOptions.Directory + ". System error:" iStat
                        view-as alert-box error buttons ok.
            end.                        
        end.  /* end of validdirectory */
        
        cFullName = ttUtilityOptions.Directory 
                  + (if ttUtilityOptions.Directory = "" then "" else "/")
                  + ttUtilityOptions.FileName.
                  
        /* if shared or all - then dump the shared data */
        if ttUtilityOptions.SequenceSelection = "shared"
        /* Avoid this if "all" sequencee, but not use Default (tenant dir) in 
           which case we have to dump all sequences in the same file   */
        or (ttUtilityOptions.SequenceSelection = "all" 
            and 
            (ttUtilityOptions.TenantSelection <> "one"
             or
             ttUtilityOptions.UseDefaultLocation
             ) 
            ) then
        do:
            run SetSequenceSelection in Procedurehandle ("shared").
            DoShared(cFullName).
        end.
        /*else*/ /* the below code is required for export functionality */    
        if lookup(ttUtilityOptions.SequenceSelection,"all,tenant") > 0 then
        do:
            
            /* all tenants */
            if ttUtilityOptions.TenantSelection = "all" then
            do:
                run SetSequenceSelection in Procedurehandle ("tenant").
                ForAllTenants(ttUtilityOptions.Directory,ttUtilityOptions.FileName).
            end.
            
            /* list of tenants or one tenant with UseDefault */
            else if ttUtilityOptions.TenantSelection = "list"
                 or (ttUtilityOptions.TenantSelection = "one" 
                     and 
                     ttUtilityOptions.UseDefaultLocation) then
            do:
                run setSequenceSelection in Procedurehandle ("tenant").
                ForEachTenant(ttUtilityOptions.Directory,ttUtilityOptions.FileName).
            end. 
            /* TenantSelection = "one" and UseDefaultLocation - false then
               dump the tenant in the fullname directory (no tenant name) */
            else if ttUtilityOptions.TenantSelection = "one" then
            do:                
                find first ttTenantData no-error. 
                if not avail ttTenantdata then
                    undo, throw new IllegalArgumentError("No tenant specified for dump of tenant sequence values"). 
                
                run setSequenceSelection in Procedurehandle (ttUtilityOptions.SequenceSelection).
                DoTenantNotDefault(ttTenantData.Name,cFullName).                    
            end.
            else do:
                undo, throw new IllegalArgumentError("TenantSelection " + quoter(ttUtilityOptions.TenantSelection) + " passed to Utility Command"). 
            end.      
        end.

    
        catch e as Progress.Lang.Error :
            if valid-object(e) then 
            do:
                if e:GetMessageNum(1) = 15984 then 
                     undo, throw new UnsupportedOperationError("SequenceValues for other tenants can only be accessed by a super-tenant.", e).
           
            end.    
            undo,throw e.
                
        end catch.
    end method.    
    
    method private void BindUtility(table ttUtilityOptions bind):
    end method.
    
    method private void BindTenant(table ttTenantData bind):
    end method.
    
    method public logical validDirectory ( cValue as char):
        if cValue <> "" then 
        do:
            assign file-info:file-name = cValue. 
            return substring(file-info:file-type,1,1) = "D".
        end.
        return true.
 
    end method. /* validateDirectory */

    
    method private void ForAllTenants(pcdir as char, pcFilename as char):
        /* skip super tenants */
        for each dictdb._tenant where dictdb._tenant._tenantid >=0 no-lock:
            DoTenant(pcdir,dictdb._tenant._tenant-name,pcFilename).               
        end.    
    end method.
    
    method private void ForEachTenant(pcDir as char, pcFilename as char):
        for each ttTenantData:
            DoTenant(pcDir,ttTenantData.Name,pcFilename).               
        end.    
    end method.
    
    /* dump shared tenant sequence values */
    method protected void DoShared(pcFullname as char):
        run setFileName in Procedurehandle(pcFullname).
        run doDump in Procedurehandle.
    end method.

    /* dump tenant data but don't use default dir (allowed with single tenant only)  */
    method protected void DoTenantNotDefault(pcTenant as char,pcFullName as char):    
        run setFileName in Procedurehandle(pcFullName).
        run setEffectiveTenant in Procedurehandle(pcTenant).
        run doDump in Procedurehandle.    
    end method.
   
    method protected void DoTenant(pcRoot as char,pcTenant as char,pcFilename as char):
        define variable cDir      as character no-undo.
        define variable cFullFileName as character no-undo.
        define variable iStat as integer no-undo.
        
        if pcRoot ne "" then 
            cDir = pcRoot + "/" + pcTenant.
        /* add logic to create directory if not exist */
       
        if not validdirectory(cDir) then
        do:
          os-create-dir VALUE(cDir). 
          iStat = os-error. 
        
          if iStat <> 0 then
                 undo, throw new AppError("Cannot create directory " + quoter(cDir) + ". System error: " + string(iStat)).
        end. /* end of validdirectory */
        
        cFullFileName = cDir 
                        + (if cDir = "" then "" else "/")
                        + pcFilename.    
        run setFileName in Procedurehandle(cFullFileName).
       
        run setEffectiveTenant in Procedurehandle(pcTenant).
        run doDump in Procedurehandle.
        catch e as Progress.Lang.Error :
            if valid-object(e) then 
            do:
                if e:GetMessageNum(1) = 15984 then 
                     undo, throw new UnsupportedOperationError("SequenceValues for other tenants can only be accessed by a super-tenant.", e).
           
            end.    
            undo,throw e.
                
        end catch.
    end method.
     
end class.