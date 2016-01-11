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
using OpenEdge.DataAdmin.Rest.IRestRequest from propath.
using OpenEdge.DataAdmin.Error.DataAdminErrorHandler from propath.
using OpenEdge.DataAdmin.Error.NotFoundError from propath.
 

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
{darest/restbase.i get securitysummary}  

procedure Execute:
    define input  parameter restRequest as IRestRequest  no-undo.      
 
     
    /* ***************************  Definitions  ************************** */
   
    define variable service      as DataAdminService no-undo.
    define variable errorHandler as DataAdminErrorHandler no-undo.
    
    
     
    /* ***************************  Main Block  *************************** */
    
    
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
  define variable  AllowBlankUserid   as logical  initial true no-undo.
       
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

   /* changes which do the reverse of disallow blank userid access- _usrblnk.p */ 
   find first DICTDB._db where DICTDB._db._db-local = true no-lock.
   FOR EACH DICTDB._File
     WHERE DICTDB._File._Db-recid = RECID(DICTDB._db)
     AND (DICTDB._File._Owner = "PUB" OR DICTDB._File._Owner = "_FOREIGN" )
     AND NOT _File-Name BEGINS "_aud" :

      IF _Can-read = "!,*" and _Can-write = "!,*" and 
         _Can-create = "!,*" and _Can-delete = "!,*" then
             AllowBlankUserid = FALSE.
      else do:
             AllowBlankUserid = TRUE.
             LEAVE.
      end.   
   END.
  
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

