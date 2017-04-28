/************************************************
  Copyright (c) 2016 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : DatabaseOptionContext
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2016-04-25
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.DataAdmin.Binding.DataAdminContext.
using OpenEdge.DataAdmin.Binding.Factory.IContextScope.
using OpenEdge.DataAdmin.Binding.IDataAdminContext.
using OpenEdge.DataAdmin.Binding.IDataAdminModel.
using OpenEdge.DataAdmin.Binding.IRow.
using OpenEdge.DataAdmin.DatabaseOption.
using OpenEdge.DataAdmin.DatabaseOptionSet.
using OpenEdge.DataAdmin.Error.DataContextError.
using OpenEdge.DataAdmin.Error.DataError.
using OpenEdge.DataAdmin.Error.IllegalArgumentError.
using OpenEdge.DataAdmin.IDataAdminCollection.
using OpenEdge.DataAdmin.IDataAdminElement.
using OpenEdge.DataAdmin.IDatabaseOption.
using OpenEdge.DataAdmin.IRequestInfo.
using Progress.Lang.Error.
using OpenEdge.DataAdmin.Error.UnsupportedOperationError.

class OpenEdge.DataAdmin.Binding.DatabaseOptionContext inherits DataAdminContext :

    {daschema/dboption.i} 
    define private dataset dsDbOption serialize-name "root":u for ttDbOption.
    define buffer bOption for ttDbOption.
    define temp-table copytable reference-only like ttDbOption .  
   
	define public override property TableHandle as handle no-undo 
    	get():
    		return temp-table ttDbOption:handle.
    	end get.
    
    define public override property KeyFields as character  no-undo  
        get():
            return "Code":u. 
        end.   
    
    define public override property Count as integer init ? no-undo  
        get(): 
            define buffer bOption for ttDbOption.
            define query qryOption for bOption.
            if Count = ? then
            do:
                open query qryOption preselect each bOption.
                assign this-object:Count = query qryOption:num-results. 
            end.
            return this-object:Count.
        end get.
        protected set.
    
    constructor public DatabaseOptionContext (pscope as IContextScope):
        super('DatabaseOption':u, pScope).    
    end constructor.
    
    constructor public DatabaseOptionContext ():
        super ("DatabaseOption":u).
    end constructor.
    
	method override public character GetJoinFields( input parenturl as character ):
        return '':u.		
	end method.

    /*   temporary until all sub classes are using createDataset  */
    method override protected handle InitDataset ():
        return dataset dsDbOption:handle. 
    end method.
        
	method public override void CreateRow(entity as IDataAdminElement):
	    /* the default syserror has all info */
	    CreateRow(cast(entity,IDatabaseOption)).    
	end method.

    method protected override void CopyTableForParent(pRow as IRow,cntxt as IDataAdminModel):
        undo, throw new IllegalArgumentError("DatabaseOptionContext:CopyTableForParent called with IRow " + quoter(prow:SerializeName)).        
    end method.    
    
    method protected override void CopyTable(cntxt as IDataAdminModel):
        define variable hTbl as handle no-undo.
        hTbl = cntxt:TableHandle.
        CopyTable(table-handle hTbl by-reference). 
        Loaded = false.
    end method.    
    
    method private void CopyTable(input table copytable):
        define variable dataerror as DataContextError no-undo.      
        for each copytable on error undo, throw:  
            if valid-object(Service) and valid-object(copytable.Entity) then 
                ValidateRow(cast(copytable.Entity,IDatabaseOption)).

            do on error undo, throw:
                find bOption where bOption.code = copytable.code no-error.
                /* force error message 
                   - DataError will transform progress message 
                     to "entity" message */
                if avail bOption then
                do:
                    create bOption.
                    bOption.code = copytable.code.
                end.    
                catch e as Progress.Lang.Error :
                    delete bOption.
                    if not valid-object(DataError) then 
                        dataError = new DataContextError("DatabaseOption":u,e).
                    else 
                        dataError:AddMessage(e).             		
                end catch. 
            end.             
        end.    
        
        if valid-object(dataError) then
            undo, throw dataError. 
        temp-table ttDbOption:tracking-changes = true.
        for each copytable:
            create ttDbOption.    
            Count = Count + 1.
            buffer-copy copytable to ttDbOption.    
            OnRowCreated().
        end.
        temp-table ttDbOption:tracking-changes = false.
            
    end method.  
    
    /** default find expression assumes there is a name field 
       override in context with different key name or more complex logic */
    method override protected character FindExpression(c as char):
        return substitute('&1.&2 eq &3', TableHandle:name, this-object:KeyFields, quoter(c)).
    end method.    
	
	method private character GetCreateError(input poDbOption as IDatabaseOption):
        return this-object:GetCreateError(cast(poDbOption,IDataAdminElement), poDbOption:Code). 
    end method.
    
	method override protected logical Remove():
        undo, throw new UnsupportedOperationError('database option delete').
	end method.

    method protected override void ValidateBuffer(phOption as handle):
        define variable hBefore as handle no-undo.
       
        if phOption:row-state eq row-modified or 
           phOption:row-state eq row-created and 
           valid-object(Service) then
        do:
            hBefore = phOption:before-buffer.
            hBefore:find-by-rowid(phOption:before-rowid).
        end.
    end method. 
         
	method private void ValidateRow(input poDbOption as IDatabaseOption):
        Assert:NotNull(poDbOption, 'Database option').
        Assert:NotNullOrEmpty(string(poDbOption:Code), 'Option code').
        Assert:IsPositive(poDbOption:OptionType, 'Option type').
        Assert:NotNull(string(poDbOption:Description), 'Option description').
	end method.    
	
	method public void CreateRow(input poDbOption as IDatabaseOption):
	    temp-table ttDbOption:tracking-changes = true.
	    ValidateRow(poDbOption).
	    
	    do on error undo, throw: 
	        Count = Count + 1.
	        create ttDbOption.
            assign 
                ttDbOption.Code            = poDbOption:Code
                ttDbOption.OptionType      = poDbOption:OptionType 
                ttDbOption.OptionValue     = poDbOption:OptionValue   
                ttDbOption.Description     = poDbOption:Description
                .   
            OnRowCreated().      
            catch e as Error:  
                delete ttDbOption.
                Count = Count - 1.
                undo, throw new DataContextError(GetCreateError(poDbOption),"DatabaseOption",e).  
            end catch.  
        end.
        finally:
            temp-table ttDbOption:tracking-changes = false.        		
        end finally.
    end method.
    
    method public override logical CanFind(input pcCode as character):
        return can-find(ttDbOption where ttDbOption.Code = pcCode).            
    end.     
     
    method public override logical Find(input pcCode as character):
        find ttDbOption where ttDbOption.Code eq pcCode no-error.
        return avail ttDbOption.            
    end.     
    
    /* called with tracking-changes */
    method protected override void CopyNewTableForParent(pRow as IRow,phTbl as handle):       
        undo, throw new IllegalArgumentError("UserContext:ImportNewTableForParent parent " + quoter(pRow:SerializeName)).
    end method.
    
    method protected override IDataAdminCollection CreateCollection(cntxt as IDataAdminContext):     
        return new DatabaseOptionSet(cntxt).
    end method.
    
    method protected override IDataAdminElement CreateEntity(req as IRequestInfo):
        return new DatabaseOption(this-object,req).
    end method.

end class.
