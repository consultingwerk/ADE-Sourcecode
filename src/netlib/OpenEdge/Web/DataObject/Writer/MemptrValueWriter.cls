/* *************************************************************************************************************************
Copyright (c) 2016 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : MemptrValueWriter
    Purpose     : Writes values to a IMemptrHolder
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2016-06-08
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.Common.Support.IDecimalHolder.
using Ccs.Common.Support.IInt64Holder.
using Ccs.Common.Support.ILongcharHolder.
using Ccs.Common.Support.IMemptrHolder.
using OpenEdge.Core.Assert.
using OpenEdge.Core.ByteBucket.
using OpenEdge.Web.DataObject.Writer.ArgumentValueWriter.
using Progress.Lang.AppError.
using Progress.Json.ObjectModel.JsonConstruct.

class OpenEdge.Web.DataObject.Writer.MemptrValueWriter inherits ArgumentValueWriter:
    
    define variable mHolder as ByteBucket no-undo.
    
    constructor public MemptrValueWriter():
        super(get-class(IMemptrHolder)).
    end constructor.
    
    method override public void Flush(  ):
        super:Flush().
        
        assign this-object:Value = mHolder:GetBytes().
    end method.
    
    method override public void Open(  ):
        if not valid-object(mHolder) then
            assign mHolder = ByteBucket:Instance().
        else
            mHolder:Clear().
        
        super:Open().
    end method.

    method override public void Write(input pData as memptr):
        mHolder:PutBytes(pData).
        
        finally:
            set-size(pData) = 0.
        end finally.
    end method.

    method override public void Write(input pData as raw ):
        mHolder:PutBytes(get-bytes(pData, 1, length(pData))).
    end method.
    
    method override public void Write(input pData as integer ):
        define variable mTemp as memptr no-undo.
        
        set-size(mTemp) = 4.
        put-long(mTemp, 1) = pData.
        mHolder:PutBytes(mTemp).
        
        finally:
            set-size(mTemp) = 0.
        end finally.
    end method.

    method override public void Write(input pData as character):
        mHolder:PutString(pData).
    end method.

    method override public void Write(input pData as longchar):
        mHolder:PutString(pData).
    end method.
    
    method override public void Write(input pData as decimal):
        define variable mTemp as memptr no-undo.
        
        set-size(mTemp) = 8.
        put-double(mTemp, 1) = pData.
        mHolder:PutBytes(mTemp).
        
        finally:
            set-size(mTemp) = 0.
        end finally.
    end method.

    method override public void Write(input pData as int64):
        define variable mTemp as memptr no-undo.
        
        set-size(mTemp) = 8.
        put-int64(mTemp, 1) = pData.
        mHolder:PutBytes(mTemp).
        
        finally:
            set-size(mTemp) = 0.
        end finally.
    end method.
        
    method override public void Write(input pData as Progress.Lang.Object):
        define variable mData as memptr no-undo.
        
        case true:
            when not valid-object(pData) then
                .   /* no-op */
                
            when type-of(pData, ILongcharHolder) then
               this-object:Write(cast(pData, ILongcharHolder):Value).

            when type-of(pData, IDecimalHolder) then
               this-object:Write(cast(pData, IDecimalHolder):Value).

            when type-of(pData, IInt64Holder) then
               this-object:Write(cast(pData, IInt64Holder):Value).

            when type-of(pData, IMemptrHolder) then
            do:
                if type-of(pData, OpenEdge.Core.Memptr) then
                    mHolder:PutBytes(cast(pData, OpenEdge.Core.Memptr)).
                else
                    this-object:Write(cast(pData, IMemptrHolder):Value).
            end.
            
            when type-of(pData, JsonConstruct) then
            do:
                cast(pData, JsonConstruct):Write(mData, session:debug-alert).
                mHolder:PutBytes(mData).
            end.
            
            when type-of(pData, Progress.Lang.Enum) then
               this-object:Write(int64(cast(pData, Progress.Lang.Enum))).
            
            otherwise 
                return error new AppError(
                            substitute('Unsupported object type: &1', pData:GetClass():TypeName)
                            , 0).
        end case.
        
        finally:
            set-size(mData) = 0.
        end finally.
    end method.

end class.