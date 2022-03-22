/************************************************
Copyright (c) 2013, 2015, 2018, 2020-2021 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : OpenEdge.Core.System.ApplicationError
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Mon Mar 09 10:37:02 EDT 2009
    Notes       : * Based on the AutoEdge|TheFactory version
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.DataTypeEnum.
using OpenEdge.Core.DataTypeHelper.
using OpenEdge.Core.IOModeEnum.
using OpenEdge.Core.System.ApplicationError.
using OpenEdge.Core.System.ErrorSeverityEnum.
using Progress.Lang.AppError.
using Progress.Lang.Error.
using Progress.Lang.Object.
using Progress.Lang.ParameterList.

class OpenEdge.Core.System.ApplicationError abstract serializable inherits AppError:
    /* Registry of error strings.  */
    define static private temp-table ApplicationErrorText no-undo
        field ErrorType as character
        field ShortMessage as character
        field ErrorMessage as clob
        index idx1 as primary unique ErrorType. 
    
    /* (optional) The P.L.Error that caused this error. Only one of InnerError or InnerStop is supported. */
    define public property InnerError as Progress.Lang.Error no-undo get. private set.
    
    /* (optional) The P.L.Stop that caused this error. Only one of InnerError or InnerStop is supported. */
    define public property InnerStop as Progress.Lang.Stop no-undo get. private set.
    
    constructor static ApplicationError():
        ApplicationError:AddError(
            get-class(ApplicationError), 
            'Application Error',
            'Default Application Error: &1 &2 &3 &4 &5 &6 &7 &8 &9').
    end constructor.
    
    /** Registers an error's texts. Works on last-in-wins basis,
        so if an error text is registered multiple times, the last 
        one wins. 
        
        @param Progress.Lang.Class The application error type
        @param character The short message
        @param lonchar The complete, long error description */
    method protected static void AddError(input poType as Progress.Lang.Class,
                                          input pcShortMessage as character,
                                          input pcMessage as longchar):
        define buffer ApplicationErrorText for ApplicationErrorText.
         
        if can-find(ApplicationErrorText where ApplicationErrorText.ErrorType eq poType:TypeName) then
            /* Intentional lack of no-error on find. */
            {&_proparse_ prolint-nowarn(findnoerror)}
            find ApplicationErrorText where ApplicationErrorText.ErrorType eq poType:TypeName.
        if not available ApplicationErrorText then
        do:
            create ApplicationErrorText.
            assign ApplicationErrorText.ErrorType = poType:TypeName.
        end.
        
        assign ApplicationErrorText.ShortMessage = pcShortMessage
               ApplicationErrorText.ErrorMessage = pcMessage.
    end method.
    
    /* Default constructor */
    constructor public ApplicationError():
        /* Severity can/will be overwritten by individual Error */
        assign this-object:Severity = integer(ErrorSeverityEnum:Default).
    end constructor.
    
    /* Constructor
       
       @param P.L.Error The error that caused this app error */
    constructor public ApplicationError(input poInnerError as Error):
        this-object().
        /* may be null */
        assign this-object:InnerError = poInnerError.
    end constructor.
    
    /* Constructor
       
       @param P.L.Error The error that caused this app error */
    constructor public ApplicationError(input pInnerStop as Progress.Lang.Stop):
        this-object().
        /* may be null */
        assign this-object:InnerStop = pInnerStop.
    end constructor.
    
    method public override Object Clone():
        define variable oParams as ParameterList no-undo.
        define variable oClone as ApplicationError no-undo.
        define variable oClass as Progress.Lang.Class no-undo. 
        define variable iLoop  as integer no-undo.
        
        oClass = this-object:GetClass().
        oParams = new ParameterList(1).
        if valid-object(this-object:InnerStop) then
            oParams:SetParameter(1,
                                 substitute(DataTypeHelper:GetMask(DataTypeEnum:Class), 'Progress.Lang.Stop':u),
                                 IOModeEnum:Input:ToString(),
                                 this-object:InnerStop).
        else
            oParams:SetParameter(1,
                                 substitute(DataTypeHelper:GetMask(DataTypeEnum:Class), 'Progress.Lang.Error':u),
                                 IOModeEnum:Input:ToString(),
                                 this-object:InnerError).
        oClone = cast(oClass:New(oParams), ApplicationError).
        do iLoop = 1 to NumMessages:
            oClone:AddMessage(GetMessage(iLoop), iLoop).
        end.
        
        oClone:Severity = this-object:Severity.
        oClone:ReturnValue = this-object:ReturnValue.
        
        return oClone.
    end method.
 
    /** Returns the resolved/substituted short message for the error. Note
        that this excludes the inner error, if any.
        
        @return character A resolve string version of the short message. */
    method public character GetShortMessage():
        define buffer ApplicationErrorText for ApplicationErrorText.
        
        if can-find(ApplicationErrorText where ApplicationErrorText.ErrorType eq this-object:GetClass():TypeName) then
            /* Intentional lack of no-error on find. */
            {&_proparse_ prolint-nowarn(findnoerror)}
            find ApplicationErrorText where ApplicationErrorText.ErrorType = this-object:GetClass():TypeName.
        
        if not available ApplicationErrorText 
           and can-find(ApplicationErrorText where ApplicationErrorText.ErrorType eq get-class(ApplicationError):TypeName)
        then
            /* Intentional lack of no-error on find. */
            {&_proparse_ prolint-nowarn(findnoerror)}
            find ApplicationErrorText where ApplicationErrorText.ErrorType eq get-class(ApplicationError):TypeName.
        
        return substitute(ApplicationErrorText.ShortMessage,
                               GetMessage(1),
                               GetMessage(2),
                               GetMessage(3),
                               GetMessage(4),
                               GetMessage(5),
                               GetMessage(6),
                               GetMessage(7),
                               GetMessage(8),
                               GetMessage(9)).
    end method.
    
    /** Returns the resolved/substituted message text for the error. Note
        that this excludes the inner error, if any.
        
        @return longchar A resolved version of the error message. */
    method public longchar GetErrorMessage():
        define variable cMessage as longchar no-undo.
        define buffer ApplicationErrorText for ApplicationErrorText.
        
        if can-find(ApplicationErrorText where 
                    ApplicationErrorText.ErrorType eq this-object:GetClass():TypeName) then
        /* Intentional lack of no-error on find. */
        {&_proparse_ prolint-nowarn(findnoerror)}
        find ApplicationErrorText where ApplicationErrorText.ErrorType = this-object:GetClass():TypeName.
        
        if not available ApplicationErrorText 
           and can-find(ApplicationErrorText where ApplicationErrorText.ErrorType eq get-class(ApplicationError):TypeName)
        then
            /* Intentional lack of no-error on find. */
            {&_proparse_ prolint-nowarn(findnoerror)}
            find ApplicationErrorText where ApplicationErrorText.ErrorType = get-class(ApplicationError):TypeName.
        
        assign cMessage = ApplicationErrorText.ErrorMessage.
        return substitute(cMessage,
                               GetMessage(1),
                               GetMessage(2),
                               GetMessage(3),
                               GetMessage(4),
                               GetMessage(5),
                               GetMessage(6),
                               GetMessage(7),
                               GetMessage(8),
                               GetMessage(9)).
    end method.

    method override public character ToString(  ):
        return GetShortMessage().
    end method.
        
end class.
