/************************************************
Copyright (c) 2013, 2018-2019 by Progress Software Corporation. All rights reserved.
*************************************************/
/** ------------------------------------------------------------------------
    File        : Session
    Purpose     : An extension of the SESSION system handle. 
    Description : Session object : this object lives for the lifespan of 
                  an AVM Session. 
    @author pjudge
    Created     : Fri Jun 04 15:00:56 EDT 2010
    Notes       : * Discover handle- and object- references for given names
                  * Resolves weak references
  ---------------------------------------------------------------------- */
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.Collections.Array.
using OpenEdge.Core.WidgetHandle.
using Progress.Lang.Object.

class OpenEdge.Core.Session:
    /** Returns the first running persistent procedure instance found
        for a given name.
        
        @param character The (relative) path name for a procedure.
        @return handle The handle to that procedure, if any. Unknown value if
                       there's no running instance of that name. */
    method static public WidgetHandle GetFirstRunningProc (input pcName as character):
        define variable hProc as handle no-undo.
        
        hProc = session:first-procedure.
        do while valid-handle(hProc):
            if hProc:file-name eq pcName then
                return new WidgetHandle(hProc).
            
            hProc = hProc:next-sibling. 
        end.
        
        return ?.
    end method.

    /** Returns all the running persistent procedure instances found
        for a given name.
        
        @param character The (relative) path name for a procedure.
        @return handle An array of handles to that procedure, if any.
                       If there's no running instance of that name, then
                       the array has an extent of 1 (one) which contains the 
                       unknown value.       */ 
    method static public Array GetAllRunningProcs (input pcName as character):
        define variable oProcedures as Array no-undo.        
        define variable hTemp as handle no-undo.
        
        assign oProcedures            = new Array()
               oProcedures:AutoExpand = true 
               .
        hTemp = session:first-procedure.
        do while valid-handle(hTemp):
            if hTemp:file-name eq pcName then
                oProcedures:Add(new WidgetHandle(hTemp)).
            
            hTemp = hTemp:next-sibling. 
        end.
        
        return oProcedures.
    end method.
    
    /** Resolves a weak reference into an object instance. A weak reference is an integer
        representation of an object reference. This method is analogous to the WIDGET-HANDLE()
        function.
        
        Notes: * Based on http://msdn.microsoft.com/en-us/library/ms404247(v=VS.90).aspx
               * Performance of ResolveWeakReference() will probably suck.
               * An ABL statement "OBJECT-REFERENCE(int)" would entirely replace this method.    
        @param integer A weak reference to an object.
        @return Object The object instance corresponding to that reference. The unknown value/null
                is returned if the referecen cannot be resolved.  */
    method static public Object ResolveWeakReference(input piReference as integer):
        define variable oInstance as Object no-undo.
        
        assign oInstance = session:first-object.
        do while valid-object(oInstance):
            if piReference eq integer(oInstance) then
                return oInstance.
            
            assign oInstance = oInstance:Next-Sibling.
        end.
        
        return ?.
    end method.
    
    /** Returns the first object instance found that is of the type given.
        
        @param Class The type. This can be a class or an interface. 
        @return Object The reference to that type, if any. Unknown value if
                       there's no running instance of that name. */
    method static public Object GetFirstClassInstance(input poType as Progress.Lang.Class):
        define variable oInstance as Object no-undo.
        
        Assert:NotNull(poType, 'type').
        
        assign oInstance = session:first-object.
        do while valid-object(oInstance):
            if oInstance:GetClass():IsA(poType) then
                return oInstance. 
            
            assign oInstance = oInstance:next-sibling. 
        end.
        
        return ?.
    end method.
    
    /** Returns all the object instances found that are of the type given.
        
        @param Class The type. This can be a class or an interface.
        @return Object The reference to that type, if any. Unknown value if
                       there's no running instance of that name. */
    method static public Array GetAllInstances(input poType as Progress.Lang.Class):
        define variable oInstance as Array no-undo.
        define variable oTemp as Object no-undo.
        
        Assert:NotNull(poType, 'type').
        
        assign oInstance            = new Array()
               oInstance:AutoExpand = true
               oTemp                = session:first-object
               .
        do while valid-object(oTemp):
            if oTemp:GetClass():IsA(poType) then
                oInstance:Add(oTemp).
            
            assign oTemp = oTemp:next-sibling. 
        end.
        
        return oInstance.
    end method.
    
end class.