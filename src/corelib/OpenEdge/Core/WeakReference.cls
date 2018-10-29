/* *************************************************************************************************************************
Copyright (c) 2018 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : WeakReference
    Purpose     : Holds a weak reference to an object to help avoid  blocking GC with circular references 
    Author(s)   : pjudge
    Created     : 2018-08-03
    Notes       : * Based on https://docs.microsoft.com/en-us/previous-versions/visualstudio/visual-studio-2008/ms404247(v=vs.90)  
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

class OpenEdge.Core.WeakReference:
    // The weak reference 'handle' to object type
    define private variable mReferenceType as class Progress.Lang.Class no-undo.

    // The weak reference 'handle' to the object
    define private variable mObjectId as integer no-undo.
    
    /* The 'strong' reference */
    define public property Reference as Progress.Lang.Object no-undo
        get():
            define variable strongRef as Progress.Lang.Object no-undo.
            
            assign strongRef = OpenEdge.Core.Session:ResolveWeakReference(mObjectId).
            // the strong type must be of the type we expect.
            if     valid-object(strongRef)
               and not strongRef:GetClass() eq mReferenceType
            then
                assign strongRef = ?.
            
            return strongRef. 
        end get.
        // this is a completely derived property
    
    /* Constructor
        
       @param P.L.Object The object reference to weakly hold */
    constructor public WeakReference(input pReference as Progress.Lang.Object):
        assign mObjectId      = int64(pReference)
               mReferenceType = pReference:GetClass()
               .
    end constructor.
    
    method override public character ToString():
        return substitute('&3 for &1_&2',
                    mReferenceType:TypeName,
                    mObjectId,
                    this-object:GetClass():TypeName).
    end method.
end class.