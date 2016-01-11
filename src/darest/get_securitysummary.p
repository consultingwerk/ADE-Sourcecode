/*************************************************************/
/* Copyright (c) 2011 by progress Software Corporation.      */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : get_securitysummary.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : hdaniels
    Created     : 
    Notes       :
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using Progress.Lang.* from propath.
using OpenEdge.DataAdmin.DataAdminService from propath.
using OpenEdge.DataAdmin.IArea from propath.
using OpenEdge.DataAdmin.IAreaSet from propath.
using OpenEdge.DataAdmin.Rest.RestRequest from propath.
using OpenEdge.DataAdmin.Error.DataAdminErrorHandler from propath.
using OpenEdge.DataAdmin.Error.NotFoundError from propath.

define variable mMode       as char init "get" no-undo.
define variable mCollection as char init "securitysummary" no-undo.

define temp-table ttSummary serialize-name "securitySummary" 
    field AllowBlankUserid          as log  serialize-name "allowBlankUserId"
    field HasSecurityAdministrator  as log  serialize-name "hasSecurityAdministrator"
    field NumUsers                  as int  serialize-name "numUsers"
    field NumTenants                as int  serialize-name "numTenants"
    field NumSuperTenants           as int  serialize-name "numSuperTenants"
    field NumRegularTenants         as int  serialize-name "numRegularTenants"
    field NumDomains                as int  serialize-name "numDomains"
    field NumEnabledDomains         as int  serialize-name "numEnabledDomains"
    field NumDisabledDomains        as int  serialize-name "numDisabledDomains"
 .
    

if session:batch-mode and not this-procedure:persistent then 
do:
   output to value("get_securitysummary.log"). 
   run executeRequest(session:parameter).  
end.
finally:
    if session:batch-mode then output close.            
end finally.  

procedure executeRequest:
    define input  parameter pcURL as character no-undo.
     
    /* ***************************  Definitions  ************************** */
   
    define variable restRequest  as RestRequest no-undo.
    define variable service      as DataAdminService no-undo.
    define variable errorHandler as DataAdminErrorHandler no-undo.
    
    
     
    /* ***************************  Main Block  *************************** */
    
    restRequest = new RestRequest(mMode,mCollection,pcUrl).  
    
    /*service = new DataAdminService(restRequest:ConnectionName).*/ 
    restRequest:Validate().
    
    /*service:URL = restRequest:ConnectionUrl.*/ 
    
    
    run fillSummary.
 
    run writeSummary(restRequest:OutFileName).  
     
    catch e as Progress.Lang.Error :
        if session:batch-mode then
            errorHandler =  new DataAdminErrorHandler(restRequest:ErrorFileName).
        else
            errorHandler = new DataAdminErrorHandler().
        errorHandler:Error(e).      
    end catch.

     
end.

procedure FillSummary:
      
  define variable  NumUsers           as integer  no-undo.
  define variable  NumDomains         as integer  no-undo.
  define variable  NumEnabledDomains  as integer  no-undo.
  define variable  NumDisabledDomains as integer  no-undo.
  define variable  NumTenants         as integer  no-undo.
  define variable  NumRegularTenants  as integer  no-undo.
  define variable  NumSuperTenants    as integer  no-undo.
  define variable  HasSecurityAdministrator as logical initial true no-undo.
  define variable  AllowBlankUserid   as logical  no-undo.
       
   for each DICTDB._Tenant no-lock:
     NumTenants = NumTenants + 1.
     if DICTDB._Tenant._Tenant-type eq 1 THEN 
        NumRegularTenants = NumRegularTenants + 1.
     else if DICTDB._Tenant._Tenant-type eq 2 THEN 
        NumSuperTenants = NumSuperTenants + 1.
   end.

   for each DICTDB._sec-authentication-domain no-lock:
       NumDomains = NumDomains + 1.
       if DICTDB._sec-authentication-domain._Domain-enabled eq true THEN
          NumEnabledDomains = NumEnabledDomains + 1.
       else if DICTDB._sec-authentication-domain._Domain-enabled eq false THEN
          NumDisabledDomains = NumDisabledDomains + 1.
   end.
   
   for each DICTDB._User no-lock:
      NumUsers = NumUsers + 1.
   end.

   find DICTDB._File "_User" where DICTDB._File._Owner = "PUB" no-lock.
   if  _File._Can-create EQ "*" and _File._Can-delete EQ "*" then 
     HasSecurityAdministrator = false.

   find first DICTDB._db where DICTDB._db._db-local = true no-lock.
   find DICTDB._db-option where DICTDB._db-option._db-recid = RECID(DICTDB._db) 
        and   DICTDB._db-option._db-option-code =  "_pvm.noBlankUser"
        and   DICTDB._db-option._db-option-type =  2 no-lock.
   assign AllowBlankUserid = NOT logical(DICTDB._db-option._db-option-value). 
  
  
   create ttSummary.
   assign 
       ttSummary.AllowBlankUserid = AllowBlankUserid
       ttSummary.HasSecurityAdministrator = HasSecurityAdministrator
       ttSummary.NumUsers = NumUsers
       ttSummary.NumDomains = NumDomains
       ttSummary.NumEnabledDomains = NumEnabledDomains
       ttSummary.NumDisabledDomains = NumDisabledDomains
       ttSummary.NumTenants = NumTenants
       ttSummary.NumRegularTenants = NumRegularTenants
       ttSummary.NumSuperTenants = NumSuperTenants  
.       
         
end.

procedure WriteSummary.
    define input  parameter pcfile as character no-undo.
    temp-table ttSummary:write-json("File",pcfile,yes).
end.

