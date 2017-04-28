 
 /*------------------------------------------------------------------------
    File        : RestQueryFactory
    Purpose     : support for named queries as collection on url 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Tue Aug 06 19:42:28 EDT 2013
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using OpenEdge.DataAdmin.Rest.IRestQueryFactory.
using OpenEdge.DataAdmin.Rest.IPageRequest.
using OpenEdge.DataAdmin.Rest.PageRequest.

class OpenEdge.DataAdmin.Rest.RestQueryFactory implements IRestQueryFactory: 
	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
		
	constructor public RestQueryFactory (  ):
		super ().
	end constructor.
	
    method private char extent GetNamedQuery(pcname as char) :
        define variable cInfo as character extent no-undo.
        case pcname:
            when "tablesforhp" then 
            do: 
                extent(cinfo) = 2.
                cInfo[1] = "tables".
                cInfo[2] = "PartitionPolicyName = ' ' and HasType1Area = 'false' and isMultiTenant = 'false'". 
             /*   cInfo[2] = "(PartitionPolicyName = '' and isMultiTenant = 'false' and area.isType2 = 'true')  ".
           */
            end.
            when "hptables" then 
            do: 
                extent(cinfo) = 2.
                cInfo[1] = "tables".
                cInfo[2] = "IsPartitioned = 'true'".
            end.
            when "tablesforcdc" then 
            do: 
                extent(cinfo) = 2.
                cInfo[1] = "tables".
                cInfo[2] = "hidden = 'false' and isChangeTable = 'false'".              
            end.
        end.    
        return cInfo.
    end.
    
    method public IPageRequest GetRequest(pcCollection as char):
        define variable pageRequest as IPageRequest  no-undo.
        pageRequest = GetNamedRequest(pcCollection).
        if not valid-object(pageRequest) then
        do:
            pageRequest = new PageRequest(pccollection).
        end.  
        return pageRequest. 
    end.
    
    method public IPageRequest GetNamedRequest(pcCollection as char):
        define variable pageRequest as IPageRequest  no-undo.
        define variable cInfo as character extent no-undo.
        cinfo =  GetNamedQuery(pcCollection).
        if extent(cinfo) = 2 then
        do:
            pageRequest = new PageRequest(cinfo[1]).
            pageRequest:QueryString = cinfo[2].   
        end. 
        return pageRequest.
    end method.


end class.