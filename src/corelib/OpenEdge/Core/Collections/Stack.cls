/************************************************
Copyright (c)  2013 by Progress Software Corporation. All rights reserved.
*************************************************/
/** ------------------------------------------------------------------------
    File        : Stack
    Purpose     : A stack is a last-in-first-out collection. 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Jan 05 15:09:51 EST 2010
    Notes       : * Non-char primitive values will have their own IntegerStack() say,that calls PrimitivePush and
                    converts to/from character to their native datatype. 
                  * The Stack temp-table could probably be dynamic, and have a single value field that
                    is dynamically constructed, but stacks need to be lightweight at runtime (IMO anyway). 
  ---------------------------------------------------------------------- */
block-level on error undo, throw.

using OpenEdge.Core.Collections.Stack.
using OpenEdge.Core.Collections.StackOverflowError.
using OpenEdge.Core.Collections.StackUnderflowError.
using OpenEdge.Core.Collections.ResizeError.
using OpenEdge.Core.DataTypeEnum.
using OpenEdge.Core.IOModeEnum.
using OpenEdge.Core.Assert.
using Progress.Lang.ParameterList.
using Progress.Lang.Object.
using OpenEdge.Core.DataTypeHelper.

class OpenEdge.Core.Collections.Stack abstract serializable:
    define public static property DefaultStackDepth as integer no-undo get. set.
    
    /** NOTE/ the expand/shrink behaviour could be handled with an enumeration,
        but as of 10.2B performance is better when using logical variables.
     **/
    /* Keep incrementally growing stack Depth as new elements are added.
       This will negatively impact performance. */
    define public property AutoExpand as logical no-undo get. set.
    
    /* If true, we'll discard stuff off the bottom of the stack if
       we resize the stack smaller than its contents. */
    define public property DiscardOnShrink as logical no-undo get. set.
    
    define public property Depth as integer no-undo 
        get.
        set (piDepth as int):
            SetStackDepth(piDepth).
            Depth = piDepth.
        end set.
    
    define public property Size as integer no-undo get. protected set.
    
    define private variable mcPrimitiveStack as character extent no-undo.
    define private variable moObjectStack as Object extent no-undo.
    define private variable mlObjectStack as logical no-undo.
    
    constructor protected Stack(poArray as Object extent):
        define variable iLoop as integer no-undo.
        
        this-object(extent(poArray)).
        
        /* The Size may not equal Depth for the input array, especially
           if this is a Stack being cloned. */        
        do iLoop = 1 to Depth while valid-object(poArray[iLoop]):
            this-object:ObjectPush(poArray[iLoop]).
        end.
    end constructor.
    
    constructor protected Stack(pcArray as character extent):
        this-object(extent(pcArray)).
        
        define variable iLoop as integer no-undo.
        do iLoop = 1 to Depth:
            this-object:PrimitivePush(pcArray[iLoop]).
        end.
    end constructor.
    
    constructor static Stack():
        Stack:DefaultStackDepth = 10.
    end constructor.
    
    constructor public Stack(piDepth as int):
        assign Depth = piDepth
               mlObjectStack = ?
               AutoExpand = false
               DiscardOnShrink = false.
    end constructor.
    
    constructor public Stack():
        this-object(Stack:DefaultStackDepth).
    end constructor.
    
    method private void SetStackDepth(piDepth as int):
        define variable cTempPrimitive as character extent no-undo.
        define variable oTempObject as Object extent no-undo.
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        
        /* do nothing if there's nothing to do */
        if piDepth ne Depth then
        do:
            if piDepth lt Size and not DiscardOnShrink then
                undo, throw new ResizeError('array', 'smaller').
            
            /* On init there's no need for any of this. */
            if Depth eq 0 then
                assign iMax = 0.
            else
                assign extent(oTempObject) = Depth
                       extent(cTempPrimitive) = Depth
                       oTempObject = moObjectStack
                       cTempPrimitive = mcPrimitiveStack
                       extent(moObjectStack) = ?
                       extent(mcPrimitiveStack) = ?
                       iMax = Size.
            
            assign extent(moObjectStack) = piDepth
                   extent(mcPrimitiveStack) = piDepth
                   Size = 0.
            
            /* On init this loop won't execute */
            do iLoop = 1 to iMax:
                /* A stack can only be one or the other ... */
                if mlObjectStack then
                    ObjectPush(oTempObject[iLoop]).
                else
                    PrimitivePush(cTempPrimitive[iLoop]).
            end.
        end.
    end method.
    
    method protected void ObjectPush(poValue as Object):
        Assert:NotNull(poValue, 'Value').
        
        if Size eq Depth then
        do:
            if AutoExpand then 
                Depth = Size + round(0.5 * Size, 0).
            else
                undo, throw new StackOverflowError().
        end.
        
        assign Size = Size + 1
               moObjectStack[Size] = poValue
               mlObjectStack = true when mlObjectStack eq ?.
    end method.
    
    method protected Object ObjectPeek():
        /* Size should never be <= 0 but hey! ... */
        if Size le 0 then
            undo, throw new StackUnderflowError().
        
        if Size gt Depth then
            undo, throw new StackOverflowError().
        
        return moObjectStack[Size].
    end method.
    
    method protected Object ObjectPop():
        define variable oValue as Object no-undo.
        
        assign oValue = ObjectPeek()
               /* clean out necessary even though Size defines what's on top, 
                  so that we don't leak by holding a reference */
               moObjectStack[Size] = ?
               Size = Size - 1
               .
        return oValue.
    end method.    

    method protected void PrimitivePush(pcValue as character):
        if Size eq Depth then
        do:
            if AutoExpand then 
                Depth = Size + round(0.5 * Size, 0).
            else
                undo, throw new StackOverflowError().
        end.
        
        assign Size = Size + 1
               mcPrimitiveStack[Size] = pcValue
               mlObjectStack = false when mlObjectStack eq ?.
    end method.
    
    method protected character PrimitivePeek():
        /* Size should never be < 0 but hey! ... */
        if Size eq 0 then
            undo, throw new StackUnderflowError().
                        
        if Size gt Depth then
            undo, throw new StackOverflowError().
        
        return mcPrimitiveStack[Size].        
    end method.
    
    method protected character PrimitivePop():
        define variable cValue as character no-undo.
        
        assign cValue = PrimitivePeek()
               /* clean out not totally necessary, since Size defines what's on top */
               mcPrimitiveStack[Size] = ?   
               Size = Size - 1.
        
        return cValue.
    end method.
    
    method public void Swap(piFromPos as integer, piToPos as integer):
        define variable cTempPrimitive as character no-undo.
        define variable oTempObject as Object no-undo.

        if piFromPos eq piToPos then
            return.
        
        /* keep the first item */        
        if mlObjectStack then
            assign oTempObject = moObjectStack[piFromPos]
                   moObjectStack[piFromPos] = moObjectStack[piToPos]
                   moObjectStack[piToPos] = oTempObject.
        else
            assign cTempPrimitive = mcPrimitiveStack[piFromPos]
                   mcPrimitiveStack[piFromPos] = mcPrimitiveStack[piToPos]
                   mcPrimitiveStack[piToPos] = cTempPrimitive.
    end method.
    
    method public void Rotate(piItems as integer):
        define variable cTempPrimitive as character no-undo.
        define variable oTempObject as Object no-undo.
        define variable iLoop as integer no-undo.
        
        if piItems le 1 then
            return.
        
        /* keep the first item */        
        if mlObjectStack then
            oTempObject = moObjectStack[1].
        else
            cTempPrimitive = mcPrimitiveStack[1]. 
        
        do iLoop = 1 to piItems - 1:
            if mlObjectStack then
                moObjectStack[iLoop] = moObjectStack[iLoop + 1].
            else
                mcPrimitiveStack[iLoop] = mcPrimitiveStack[iLoop + 1]. 
        end.
        
        /* put the first item at the bottom of the rotation */
        if mlObjectStack then
            moObjectStack[piItems] = oTempObject.
        else
            mcPrimitiveStack[piItems] = cTempPrimitive.
    end method.
    
    method protected Object extent ObjectToArray():
        return moObjectStack.
    end method.

    method protected character extent PrimitiveToArray():
        return mcPrimitiveStack.        
    end method.
    
    method public void Invert():
        define variable cTempPrimitive as character extent no-undo.
        define variable oTempObject as Object extent no-undo.
        define variable iLoop as integer no-undo.
        
        /* No point, really */
        if Size le 1 then
            return.
        
        /* keep the first item */
        if mlObjectStack then
            oTempObject = moObjectStack.
        else            
            cTempPrimitive = mcPrimitiveStack.
        
        do iLoop = 1 to Size:
            if mlObjectStack then
                moObjectStack[iLoop] = oTempObject[Size - iLoop + 1].
            else
                mcPrimitiveStack[iLoop] = cTempPrimitive[Size - iLoop + 1].
        end.
    end method.
    
    method public override Object Clone():
        define variable oParams as ParameterList no-undo.
        
        oParams = new ParameterList(1).
        if Size eq 0 then
            oParams:SetParameter(1,
                                 DataTypeHelper:GetMask(DataTypeEnum:Integer),
                                 IOModeEnum:Input:ToString(),
                                 this-object:Depth).
        else
        if mlObjectStack then
            oParams:SetParameter(1,
                                 substitute(DataTypeHelper:GetMask(DataTypeEnum:ClassArray),
                                            DataTypeHelper:GetMask(DataTypeEnum:ProgressLangObject)),
                                 IOModeEnum:Input:ToString(),
                                 this-object:ObjectToArray() ).
        else
            oParams:SetParameter(1,
                                 DataTypeHelper:GetMask(DataTypeEnum:CharacterArray),
                                 IOModeEnum:Input:ToString(),
                                 this-object:PrimitiveToArray() ).
        
        return this-object:GetClass():New(oParams).
    end method.
    
    method protected logical ObjectContains(poItem as Object):
        define variable lContains as logical no-undo.
        define variable iLoop as integer no-undo.
        
        lContains = false.
        do iLoop = Size to 1 by -1 while not lContains:
            lContains = moObjectStack[iLoop]:Equals(poItem).
        end.
        
        return lContains.
    end method.
    
    method protected logical PrimitiveContains(pcItem as character):
        define variable lContains as logical no-undo.
        define variable iLoop as integer no-undo.

        lContains = false.
        do iLoop = Size to 1 by -1 while not lContains:
            lContains = mcPrimitiveStack[iLoop] eq pcItem.
        end.
        
        return lContains.
    end method.
    
end class.
