/*------------------------------------------------------------------------
    File        : AbstractModelDecorator
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Thu Jul 04 13:35:00 EDT 2013
    Notes       : Not in use. 
                  Could be used to extend context behavior 
                  for example for a narrower query 
                  Currently handled by 
                  
----------------------------------------------------------------------*/

using Progress.Lang.*.
using OpenEdge.DataAdmin.Binding.IDataAdminModel.

routine-level on error undo, throw.

class OpenEdge.DataAdmin.Binding.AbstractModelDecorator /*implements IDataAdminModel*/ abstract: 
    
    define protected property Model as IDataAdminModel no-undo get. private set. 

	define public event AddedToContext  signature void (input newContext as OpenEdge.DataAdmin.Binding.IDataAdminContext).

	define public event BeforeDelete  signature void (input rid as rowid).

	define public event ContextDeleted  signature void ().

	define public event ContextRefreshed  signature void (input tblResponse as OpenEdge.DataAdmin.Message.ITableResponse).

	define public event KeyChanged  signature void (input keyChange as OpenEdge.DataAdmin.Binding.IRowChange).

	define public event RowCreated  signature void ().

	define public event RowDeleted  signature void ().

	define public event SearchQuery  signature void (input id as character, input-output queryContext as OpenEdge.DataAdmin.Binding.IDataAdminContext).

	define public event SearchRequest  signature void (input Req as OpenEdge.DataAdmin.IRequestInfo, input pcParent as character, input pcKeys as character extent, input-output queryContext as OpenEdge.DataAdmin.Binding.IDataAdminContext).

	define public property BaseQuery as character no-undo 
        get():
            return Model:BaseQuery.
        end.      
        set(c as char):
            Model:BaseQuery = c.
        end.

	define public property CanEditKey as logical no-undo 
        get():
            return Model:CanEditKey.
        end.      
      
	define public property ContentId as character no-undo 
        get():
            return Model:ContentId.
        end.      

	define public property ContextScope as OpenEdge.DataAdmin.Binding.Factory.IContextScope no-undo 
        get():
            return Model:ContextScope.
        end.      

	define public property Count as integer no-undo 
	    get(): 
	        
	    end.

	define public property DatasetHandle as handle no-undo 
	    get():
            return Model:DatasetHandle.
        end. 
        
	define public property EntityFieldName as character no-undo 
	    get():
            return Model:EntityFieldName.
        end.     

	define public property Id as character no-undo 
	    get():
            return Model:Id.
        end.  
         
	define public property IsLocal as logical no-undo 
	    get():
             return Model:IsLocal.
        end.  

	define public property IteratorHandle as handle no-undo 
	    get():
             return Model:IteratorHandle.
        end.

	define public property KeyFields as character no-undo 
	    get():
             return Model:KeyFields.
        end. 

	define public property LastSavedDataset as handle no-undo 
	    get():
             return Model:LastSavedDataset.
        end. 
        set(val as handle):
            Model:LastSavedDataset = val.
        end.

	define public property Lazy as logical no-undo 
	    get.
	    set. 

	define public property Name as character no-undo 
	    get():
             return Model:Name.
        end. 

	define public property ReadOnly as logical no-undo 
	    get():
             return Model:ReadOnly.
        end. 

	define public property RootId as rowid no-undo 
	    get():
             return Model:RootId.
        end. 
    
    define public property SerializeName as character no-undo 
        get.
	    set. 

	define public property Service as OpenEdge.DataAdmin.IDataAdminService no-undo 
	    get():
             return Model:Service.
        end. 

	define public property Table as character no-undo 
	    get():
             return Model:Table.
        end.

	define public property TableHandle as handle no-undo 
	    get():
             return Model:TableHandle.
        end.

	define public property TargetService as OpenEdge.DataAdmin.IDataAdminService no-undo 
	    get():
             return Model:TargetService.
        end.
        
	define public property Total as int64 no-undo 
	    get():
             return Model:Total.
        end. 
	
	method public void AddChildrenTo( input tree as OpenEdge.DataAdmin.Binding.IContextTree, input pReq as OpenEdge.DataAdmin.IRequestInfo ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public void AddChildrenTo( input tree as OpenEdge.DataAdmin.Binding.IContextTree, input pcCollections as character, input pReq as OpenEdge.DataAdmin.IRequestInfo ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public void AddRowTo( input tree as OpenEdge.DataAdmin.Binding.IContextTree, input prid as rowid ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public void AddTableTo( input tree as OpenEdge.DataAdmin.Binding.IContextTree ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public void AddTableTo( input tree as OpenEdge.DataAdmin.Binding.IContextTree, input pReq as OpenEdge.DataAdmin.IRequestInfo ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public void AddTreeTo( input tree as OpenEdge.DataAdmin.Binding.IContextTree ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public void AddTreeTo( input tree as OpenEdge.DataAdmin.Binding.IContextTree, input pReq as OpenEdge.DataAdmin.IRequestInfo ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public void AddTreeTo( input tree as OpenEdge.DataAdmin.Binding.IContextTree, input pcCollections as character ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public void AddTreeTo( input tree as OpenEdge.DataAdmin.Binding.IContextTree, input pcCollections as character, input pReq as OpenEdge.DataAdmin.IRequestInfo ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public void AddTreeTo( input tree as OpenEdge.DataAdmin.Binding.IContextTree, input parent as OpenEdge.DataAdmin.Binding.IDataAdminContext, input pReq as OpenEdge.DataAdmin.IRequestInfo ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public void AddTreeTo( input tree as OpenEdge.DataAdmin.Binding.IContextTree, input parent as OpenEdge.DataAdmin.Binding.IDataAdminContext, input pcCollections as character, input pReq as OpenEdge.DataAdmin.IRequestInfo ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public logical CanFind( input i as integer ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public logical CanFind( input c as character ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public character ColumnExpression( input pcColumn as character, input pcOperator as character, input pcValue as character ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public character ColumnSortSource( input pcColumn as character ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public character ColumnSource( input pcColumn as character ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public void Copy( input cntxt as OpenEdge.DataAdmin.Binding.IDataAdminContext ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public void CopyForParent( input pRow as OpenEdge.DataAdmin.Binding.IRow, input cntxt as OpenEdge.DataAdmin.Binding.IDataAdminContext ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public void CopyForParent( input pParent as character, input pValue as character, input cntxt as OpenEdge.DataAdmin.Binding.IDataAdminContext ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public OpenEdge.DataAdmin.IDataAdminElement CreateRootEntity(  ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public OpenEdge.DataAdmin.IDataAdminElement CreateRootEntity( input i as integer ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public OpenEdge.DataAdmin.IDataAdminElement CreateRootEntity( input c as character ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public OpenEdge.DataAdmin.IDataAdminElement CreateRootEntity( input pReq as OpenEdge.DataAdmin.IRequestInfo ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public void CreateRootRow(  ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public void CreateRootRow( input i as integer ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public void CreateRootRow( input c as character ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public void CreateRootRow( input pReq as OpenEdge.DataAdmin.IRequestInfo ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public void CreateRow( input entity as OpenEdge.DataAdmin.IDataAdminElement ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public void DataRefreshed( input response as OpenEdge.DataAdmin.Message.IFetchResponse ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public logical Delete( input c as character ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public logical Delete( input i as integer ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public logical Delete( input c as character extent ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public void Export( input pcfile as character, input pchidefields as character ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public void ExportLastSaved( input pcfile as character ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public void ExportLastSavedTree( input pcfile as character ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public void ExportNormalized( input pcfile as character ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public logical Find( input i as integer ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public logical Find( input req as OpenEdge.DataAdmin.IRequestInfo ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public logical Find( input c as character ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public logical Find( input c as character extent ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public OpenEdge.DataAdmin.IDataAdminElement FindEntity( input h as handle, input pReq as OpenEdge.DataAdmin.IRequestInfo ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public OpenEdge.DataAdmin.IDataAdminElement FindEntity( input i as integer, input pReq as OpenEdge.DataAdmin.IRequestInfo ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public OpenEdge.DataAdmin.IDataAdminElement FindEntity( input c as character, input pReq as OpenEdge.DataAdmin.IRequestInfo ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public OpenEdge.DataAdmin.IDataAdminElement FindEntity( input c as character extent, input pReq as OpenEdge.DataAdmin.IRequestInfo ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public OpenEdge.DataAdmin.IDataAdminElement FindEntity( input req as OpenEdge.DataAdmin.IRequestInfo ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public OpenEdge.DataAdmin.IDataAdminElement FindEntity( input i as integer ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public OpenEdge.DataAdmin.IDataAdminElement FindEntity( input c as character ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public OpenEdge.DataAdmin.IDataAdminElement FindEntity( input c as character extent ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public OpenEdge.DataAdmin.IDataAdminElement FindEntity( input phdl as handle ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public logical FindOrigin( input rOriginid as rowid ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public void ForeignKeyChanged( input parentChange as OpenEdge.DataAdmin.Binding.IRowChange ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public OpenEdge.DataAdmin.Binding.IDataAdminContext GetChild( input name as character ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public OpenEdge.DataAdmin.IDataAdminCollection GetChildCollection( input pParent as OpenEdge.DataAdmin.Binding.IRow, input preq as OpenEdge.DataAdmin.IRequestInfo ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public OpenEdge.DataAdmin.IDataAdminCollection GetChildCollection( input pParent as OpenEdge.DataAdmin.Binding.IRow, input serializename as character ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public OpenEdge.DataAdmin.IDataAdminCollection GetChildCollection( input ckey as character, input serializename as character ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public OpenEdge.DataAdmin.IDataAdminCollection GetChildCollection( input ikey as integer, input serializename as character ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public OpenEdge.DataAdmin.IDataAdminCollection GetChildCollection( input cKey as character extent, input serializename as character ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public OpenEdge.DataAdmin.IDataAdminCollection GetChildCollection( input pcKey as character, input preq as OpenEdge.DataAdmin.IRequestInfo ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public OpenEdge.DataAdmin.IDataAdminCollection GetChildCollection( input piKey as integer, input preq as OpenEdge.DataAdmin.IRequestInfo ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public OpenEdge.DataAdmin.IDataAdminCollection GetChildCollection( input pcKey as character extent, input preq as OpenEdge.DataAdmin.IRequestInfo ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public character GetChildJoinFields( input parentid as character ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public character GetChildQuery( input parentid as character, input pcKeyValue as character ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public character GetChildQuery( input parentid as character, input pcKeyValues as character extent ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public OpenEdge.DataAdmin.IDataAdminCollection GetCollection(  ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public OpenEdge.DataAdmin.IDataAdminCollection GetCollection( input filter as character ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public OpenEdge.DataAdmin.IDataAdminCollection GetCollection( input preq as OpenEdge.DataAdmin.IRequestInfo ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public OpenEdge.DataAdmin.IDataAdminCollection GetCollection( input pParentRow as OpenEdge.DataAdmin.Binding.IRow, input pReq as OpenEdge.DataAdmin.IRequestInfo ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public OpenEdge.DataAdmin.IDataAdminCollection GetCollection( input pcParentSerializename as character, input pKey as character ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public OpenEdge.DataAdmin.IDataAdminCollection GetCollection( input pcParentSerializename as character, input pKey as character extent ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public OpenEdge.DataAdmin.IDataAdminCollection GetCollection( input pcParentSerializename as character, input pKey as character, input preq as OpenEdge.DataAdmin.IRequestInfo ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public OpenEdge.DataAdmin.IDataAdminCollection GetCollection( input pcParentSerializename as character, input pKey as character extent, input preq as OpenEdge.DataAdmin.IRequestInfo ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public OpenEdge.DataAdmin.Message.ISaveRequest GetCreateRowRequest(  ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public OpenEdge.DataAdmin.Message.ISaveRequest GetCreateRowRequest( input pRow as OpenEdge.DataAdmin.Binding.IRow ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public OpenEdge.DataAdmin.Message.ISaveRequest GetDeleteRowRequest( input pRow as OpenEdge.DataAdmin.Binding.IRow, input pReq as OpenEdge.DataAdmin.IRequestInfo ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public OpenEdge.DataAdmin.IDataAdminElement GetEntity( input i as integer ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public OpenEdge.DataAdmin.IDataAdminElement GetEntity( input c as character ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public OpenEdge.DataAdmin.IDataAdminElement GetEntity( input req as OpenEdge.DataAdmin.IRequestInfo ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.
	
    method public character GetNamedQuery( input pname as character ):
        
        undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

    end method.
    
	method public character GetJoinFields( input parentid as character ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public character GetJoinQuery( input parentname as character ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public character extent GetKeyValues( input pBuffer as handle ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public character GetKeyWhere( input pcValues as character extent ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public handle extent GetQueryHandles( input parentid as character ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public OpenEdge.DataAdmin.Message.IFetchRequest GetRequest(  ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public OpenEdge.DataAdmin.Message.ISaveRequest GetSaveRequest( input pid as character ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public OpenEdge.DataAdmin.Message.ISaveRequest GetSaveRequest(  ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public OpenEdge.DataAdmin.Message.ISaveRequest GetSaveRowRequest( input pcKey as character, input pReq as OpenEdge.DataAdmin.IRequestInfo ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public OpenEdge.DataAdmin.Message.ISaveRequest GetSaveRowRequest( input pRow as OpenEdge.DataAdmin.Binding.IRow, input pReq as OpenEdge.DataAdmin.IRequestInfo ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public character GetServerChildQuery( input parentid as character, input pcKeyValue as character ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public character GetServerChildQuery( input parentid as character, input pcKeyValues as character extent ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public character GetServerJoinQuery( input parentname as character ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public logical HasChanges(  ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public handle extent HideColumns( input cList as character ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public handle extent HideUrlColumns(  ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public void Import( input pcfile as character, input pcMode as character ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public void ImportForParent( input pcparent as character, input pckey as character, input pcfile as character ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public void ImportNewForParent( input pcparent as character, input pckey as character, input pcfile as character ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public void ImportRow( input pcfile as character, input cKeyValues as character extent ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public void ImportRow( input pcfile as character, input i as integer ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public void ImportRow( input pcfile as character, input c as character ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public void ImportRowTree( input pcfile as character, input cKeyValues as character extent ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public void ImportRowTree( input pcfile as character, input i as integer ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public void ImportRowTree( input pcfile as character, input c as character ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public void ImportTree( input pcfile as character, input pcMode as character ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public void MergeChanges( input pResponse as OpenEdge.DataAdmin.Message.ISaveRequest ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public void MergeChanges( input phChangeDataset as handle ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public void MoveQueries( input cntxt as OpenEdge.DataAdmin.Binding.IDataAdminContext ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public OpenEdge.DataAdmin.IDataAdminCollection NewCollection(  ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public void ReadChild( input parentRow as OpenEdge.DataAdmin.Binding.IRow, input json as Progress.Json.ObjectModel.JsonObject ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public logical Remove( input phdl as handle ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public logical SetProperty( input pid as rowid, input pname as character, input pvalue as character ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public void TransferMatchingRequests( input pReq as OpenEdge.DataAdmin.IRequestInfo extent, input pmsg as OpenEdge.DataAdmin.Message.IFetchRequest ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public void TransferMatchingRequests( input pReq as OpenEdge.DataAdmin.IRequestInfo, input pmsg as OpenEdge.DataAdmin.Message.IFetchRequest ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public character TransformQuery( input pcTables as character, input pWhere as character, input mapcontxt as OpenEdge.DataAdmin.Lang.IQueryMap ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public character TransformQuery( input pQuery as character ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public void ValidateChanges( input phDs as handle ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public void ValidateQueryChanges( input phQuery as handle ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public void ValidateRelationChanges( input hRel as handle, input pReq as OpenEdge.DataAdmin.IRequestInfo ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public void ValidateRowChanges( input hBuffer as handle, input pReq as OpenEdge.DataAdmin.IRequestInfo ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public void ViewHiddenColumns( input phdls as handle extent ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

end class.