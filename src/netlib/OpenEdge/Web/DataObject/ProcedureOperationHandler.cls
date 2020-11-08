/* *************************************************************************************************************************
Copyright (c) 2016-2019 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : ProcedureOperationHandler
    Purpose     : Delegate for mapped procedure operations for the DOH
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Fri May 20 12:15:00 EDT 2016
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.Common.Support.IHandleHolder.
using OpenEdge.Core.Assert.
using OpenEdge.Core.DateTimeAddIntervalEnum.
using OpenEdge.Core.IOModeEnum.
using OpenEdge.Logging.Logger.
using OpenEdge.Net.HTTP.IHttpResponse.
using OpenEdge.Net.HTTP.StatusCodeEnum.
using OpenEdge.Web.DataObject.DataObjectService.
using OpenEdge.Web.DataObject.MappedOperation.
using OpenEdge.Web.DataObject.OperationArgument.
using OpenEdge.Web.DataObject.OperationHandler.
using OpenEdge.Web.DataObject.Writer.ArgumentValueWriter.
using OpenEdge.Web.DataObject.Writer.ArgumentValueWriterBuilder.
using OpenEdge.Web.IWebRequest.
using OpenEdge.Web.SendExceptionError.
using Progress.Lang.AppError.

class OpenEdge.Web.DataObject.ProcedureOperationHandler inherits OperationHandler:
    
    constructor public ProcedureOperationHandler():
        super().
    end constructor.
    
    /* Executes the operation.
    
       @param IWebRequest The request that resulting in the exception
       @param P.L.Object The message body of the incoming request. Typically 
                         will be transformed from bytes into something useful; may also have an envelope removed. 
       @param IHttpResponse The current response object, if any
       @param DataObjectService The service being operated on
       @param MappedOperation The mapped operation
       @param P.L.Object The business entity (business logic service)  
       @return integer A non-null status code use to deal with errors */
    method override public integer Execute(input poRequest as IWebRequest, 
                                           input poMessageBody as Progress.Lang.Object, 
                                           input poResponse as IHttpResponse,
                                           input pService as DataObjectService,
                                           input poOperation as MappedOperation, 
                                           input poEntity as Progress.Lang.Object ):    
        define variable iMax as integer no-undo.
        define variable iLoop as integer no-undo.
        define variable iArgIdx as integer no-undo.
        define variable execTime as datetime extent 2 no-undo.
        define variable oOperArg as OperationArgument no-undo.
        define variable hDynCall as handle no-undo.
        define variable oValueWriter as ArgumentValueWriter no-undo.
        define variable cSignature as character no-undo.
        define variable cReturnType as character no-undo.
        define variable oRetVal as Progress.Lang.Object extent no-undo.

        define buffer lbArg for ttArgument.
        
        /* 32 array vars per data-type */
        {OpenEdge/Web/DataObject/doh_execute_defvar.i &data-type=character}
        {OpenEdge/Web/DataObject/doh_execute_defvar.i &data-type=longchar}
        {OpenEdge/Web/DataObject/doh_execute_defvar.i &data-type=int64}
        {OpenEdge/Web/DataObject/doh_execute_defvar.i &data-type=integer}
        {OpenEdge/Web/DataObject/doh_execute_defvar.i &data-type=raw}
        {OpenEdge/Web/DataObject/doh_execute_defvar.i &data-type=memptr}
        {OpenEdge/Web/DataObject/doh_execute_defvar.i &data-type=handle}
        {OpenEdge/Web/DataObject/doh_execute_defvar.i &data-type=handle     &name-suffix=pds}
        {OpenEdge/Web/DataObject/doh_execute_defvar.i &data-type=handle     &name-suffix=tt}
        {OpenEdge/Web/DataObject/doh_execute_defvar.i &data-type=decimal}
        {OpenEdge/Web/DataObject/doh_execute_defvar.i &data-type=date}
        {OpenEdge/Web/DataObject/doh_execute_defvar.i &data-type=datetime}
        {OpenEdge/Web/DataObject/doh_execute_defvar.i &data-type=datetime-tz}
        {OpenEdge/Web/DataObject/doh_execute_defvar.i &data-type=logical}
        {OpenEdge/Web/DataObject/doh_execute_defvar.i &data-type=recid}
        {OpenEdge/Web/DataObject/doh_execute_defvar.i &data-type=rowid}
        {OpenEdge/Web/DataObject/doh_execute_defvar.i &data-type=Progress.Lang.Object &name-suffix=plo}
        
        Assert:NotNull(poRequest,   'Web request').
        Assert:NotNull(poResponse,  'Web response').
        Assert:NotNull(poOperation, 'Mapped operation').
        Assert:NotEmpty(poOperation:TargetFunction, 'Target function').

        Assert:IsType(poEntity, get-class(IHandleHolder)).
        Assert:NotNull(cast(poEntity, IHandleHolder):Value, 'Procedure handle').
        
        assign cSignature = cast(poEntity, IHandleHolder):Value:get-signature(poOperation:TargetFunction).
        if cSignature eq '':u then
            undo, throw new SendExceptionError(StatusCodeEnum:NotImplemented,
                                               new AppError(substitute('Unable to find target function for &1',
                                                    string(poOperation)),
                                                    0)).
        
        /* create Call object from operation params (IN, IN-OUT, OUT ) */
        create call hDynCall.
        assign iMax                    = poOperation:Parameters:Size
               
               hDynCall:num-parameters = iMax
               hDynCall:call-name      = poOperation:TargetFunction
               cReturnType             = entry(2, cSignature)
               .
        if not poOperation:TargetFunction eq ? then
            assign hDynCall:in-handle = cast(poEntity, IHandleHolder):Value.
        
        case entry(1, cSignature):
            when 'FUNCTION':u  then hDynCall:call-type = function-call-type.
            when 'PROCEDURE':u then hDynCall:call-type = procedure-call-type.
            otherwise
                undo, throw new SendExceptionError(StatusCodeEnum:NotImplemented,
                                                   new AppError(substitute('Unsupported call type &1 for &2',
                                                        entry(1, cSignature), string(poOperation)),
                                                        0)).
        end case.
        
        // make sure there are the right number of params. If there are no params, there's still a trailing comma
        if num-entries(cSignature) - 2 /* -type - return-data-type */ ne iMax and
           not (iMax eq 0 and entry(3, cSignature) eq '':u) then  
            undo, throw new SendExceptionError(StatusCodeEnum:NotImplemented,
                                               new AppError(substitute('Unsupported call type &1 for &2',
                                                    entry(1, cSignature), string(poOperation)),
                                                    0)).
        
        Logger:Trace(substitute('Using internal procedure "&1" for operation &2', cSignature, poOperation:ToString())).
        
        BuildArguments(poRequest, poMessageBody, poResponse, pService, poOperation).

        for each lbArg where 
                 lbArg.ParentOH eq int64(this-object) and
                 lbArg.ParamIndex ge 1:
            assign oOperArg = cast(lbArg.Arg, OperationArgument).
             
            Logger:Trace(substitute('&4: Set-Parameter(&1 [&6&7], &2, &3) &5', 
                               lbArg.ParamIndex,
                               oOperArg:Parameter:DataType,
                               string(oOperArg:Parameter:IoMode),
                               poOperation:TargetFunction,   
                               string(oOperArg:ArgumentValue),
                               oOperArg:Parameter:ABLName,
                               string(oOperArg:Parameter:IsArray, '[]/  ':u))).
            
            if oOperArg:Parameter:IsArray then
            case oOperArg:Parameter:DataType:
                {OpenEdge/Web/DataObject/poh_execute_setparam_array.i &ARG-TYPE=int64       &ARG-VALUE-TYPE=Ccs.Common.Support.IInt64ArrayHolder        }
                {OpenEdge/Web/DataObject/poh_execute_setparam_array.i &ARG-TYPE=integer     &ARG-VALUE-TYPE=Ccs.Common.Support.IInt64ArrayHolder        } 
                {OpenEdge/Web/DataObject/poh_execute_setparam_array.i &ARG-TYPE=character   &ARG-VALUE-TYPE=Ccs.Common.Support.ILongcharArrayHolder     }
                {OpenEdge/Web/DataObject/poh_execute_setparam_array.i &ARG-TYPE=longchar    &ARG-VALUE-TYPE=Ccs.Common.Support.ILongcharArrayHolder     }
                {OpenEdge/Web/DataObject/poh_execute_setparam_array.i &ARG-TYPE=decimal     &ARG-VALUE-TYPE=Ccs.Common.Support.IDecimalArrayHolder      }
                {OpenEdge/Web/DataObject/poh_execute_setparam_array.i &ARG-TYPE=logical     &ARG-VALUE-TYPE=Ccs.Common.Support.ILogicalArrayHolder      }
                {OpenEdge/Web/DataObject/poh_execute_setparam_array.i &ARG-TYPE=rowid       &ARG-VALUE-TYPE=Ccs.Common.Support.IRowidArrayHolder        }
                {OpenEdge/Web/DataObject/poh_execute_setparam_array.i &ARG-TYPE=recid       &ARG-VALUE-TYPE=Ccs.Common.Support.IInt64ArrayHolder        }
                {OpenEdge/Web/DataObject/poh_execute_setparam_array.i &ARG-TYPE=date        &ARG-VALUE-TYPE=Ccs.Common.Support.IDateArrayHolder         }
                {OpenEdge/Web/DataObject/poh_execute_setparam_array.i &ARG-TYPE=datetime    &ARG-VALUE-TYPE=Ccs.Common.Support.IDateTimeArrayHolder     }
                {OpenEdge/Web/DataObject/poh_execute_setparam_array.i &ARG-TYPE=datetime-tz &ARG-VALUE-TYPE=Ccs.Common.Support.IDateTimeTzArrayHolder   }
                {OpenEdge/Web/DataObject/poh_execute_setparam_array.i &ARG-TYPE=memptr      &ARG-VALUE-TYPE=Ccs.Common.Support.IMemptrArrayHolder       }
                {OpenEdge/Web/DataObject/poh_execute_setparam_array.i &ARG-TYPE=handle      &ARG-VALUE-TYPE=Ccs.Common.Support.IHandleArrayHolder       }
                {OpenEdge/Web/DataObject/poh_execute_setparam_array.i &ARG-TYPE=plo         &ARG-VALUE-TYPE=OpenEdge.Core.IObjectArrayHolder         &SWITCH-VALUE=class }
            end case.   /* arrays */
            else
            case oOperArg:Parameter:DataType:
                {OpenEdge/Web/DataObject/poh_execute_setparam_scalar.i &ARG-TYPE=int64       &ARG-VALUE-TYPE=Ccs.Common.Support.IInt64Holder     }
                {OpenEdge/Web/DataObject/poh_execute_setparam_scalar.i &ARG-TYPE=integer     &ARG-VALUE-TYPE=Ccs.Common.Support.IInt64Holder    &COERCE-TYPE=integer }
                {OpenEdge/Web/DataObject/poh_execute_setparam_scalar.i &ARG-TYPE=character   &ARG-VALUE-TYPE=Ccs.Common.Support.ILongcharHolder &COERCE-TYPE=string  }
                {OpenEdge/Web/DataObject/poh_execute_setparam_scalar.i &ARG-TYPE=longchar    &ARG-VALUE-TYPE=Ccs.Common.Support.ILongcharHolder   }
                {OpenEdge/Web/DataObject/poh_execute_setparam_scalar.i &ARG-TYPE=decimal     &ARG-VALUE-TYPE=Ccs.Common.Support.IDecimalHolder    }
                {OpenEdge/Web/DataObject/poh_execute_setparam_scalar.i &ARG-TYPE=logical     &ARG-VALUE-TYPE=Ccs.Common.Support.ILogicalHolder    }
                {OpenEdge/Web/DataObject/poh_execute_setparam_scalar.i &ARG-TYPE=rowid       &ARG-VALUE-TYPE=Ccs.Common.Support.IRowidHolder      }
                {OpenEdge/Web/DataObject/poh_execute_setparam_scalar.i &ARG-TYPE=recid       &ARG-VALUE-TYPE=Ccs.Common.Support.IInt64Holder    &COERCE-TYPE=integer }
                {OpenEdge/Web/DataObject/poh_execute_setparam_scalar.i &ARG-TYPE=date        &ARG-VALUE-TYPE=Ccs.Common.Support.IDateHolder       }
                {OpenEdge/Web/DataObject/poh_execute_setparam_scalar.i &ARG-TYPE=datetime    &ARG-VALUE-TYPE=Ccs.Common.Support.IDateTimeHolder   }
                {OpenEdge/Web/DataObject/poh_execute_setparam_scalar.i &ARG-TYPE=datetime-tz &ARG-VALUE-TYPE=Ccs.Common.Support.IDateTimeTzHolder }
                {OpenEdge/Web/DataObject/poh_execute_setparam_scalar.i &ARG-TYPE=memptr      &ARG-VALUE-TYPE=Ccs.Common.Support.IMemptrHolder     }
                {OpenEdge/Web/DataObject/poh_execute_setparam_scalar.i &ARG-TYPE=handle      &ARG-VALUE-TYPE=Ccs.Common.Support.IHandleHolder     }
                /* data structures & objects */                                             
                {OpenEdge/Web/DataObject/poh_execute_setparam_scalar.i &ARG-TYPE=pds        &ARG-VALUE-TYPE=Ccs.Common.Support.IHandleHolder    &SWITCH-VALUE=dataset-handle }
                {OpenEdge/Web/DataObject/poh_execute_setparam_scalar.i &ARG-TYPE=tt         &ARG-VALUE-TYPE=Ccs.Common.Support.IHandleHolder    &SWITCH-VALUE=table-handle   }
                {OpenEdge/Web/DataObject/poh_execute_setparam_scalar.i &ARG-TYPE=plo        &ARG-VALUE-TYPE=Progress.Lang.Object                &SWITCH-VALUE=class          }
            end case.    /* scalar */
        end.    // PARAM-LOOP
        
        /* INVOKE & HANDLE RETURN-VALUE */
        find lbArg where
             lbArg.ParentOH  eq int64(this-object) and
             lbArg.ParamIndex eq 0
             no-error.
        if available lbArg and cReturnType ne '':u then
        do:
            assign oOperArg = cast(lbArg.Argument, OperationArgument)
                   oValueWriter = ArgumentValueWriterBuilder:Build(oOperArg)
                                    :Logger(this-object:Logger)
                                    :Writer.
            if valid-object(oValueWriter) then
                oValueWriter:Open().
        end.
        else
            assign oOperArg     = ?
                   oValueWriter = ?.
        
        /* RUNIT */
        assign execTime[1] = now.
        hDynCall:Invoke().
        assign execTime[2] = now.
        
        Logger:Trace(substitute('Execution time for &1:&2 = &3 (ms)', 
                        poOperation:TargetName, poOperation:TargetFunction,
                        interval(execTime[2], execTime[1], string(DateTimeAddIntervalEnum:Milliseconds)))).
        
        // PROCESS THE RETURN VALUE
        if valid-object(oValueWriter) then
        do:
            // AVM magic takes care of type conversions. The Write() call will barf if needed
            if hDynCall:call-type eq function-call-type then
            do:
                case hDynCall:return-value-data-type:
                    when get-class(Progress.Lang.Object):TypeName then
                    do:
                        if oOperArg:Parameter:IsArray then
                        do:
                            assign oRetVal = hDynCall:return-value.
                            oValueWriter:Write(oRetVal).
                        end.
                        else
                        do:
                            assign extent(oRetVal) = 1
                                   oRetVal[1] = hDynCall:return-value.
                            oValueWriter:Write(oRetVal[1]).
                        end.
                    end.    // CLASS P.L.O
                    otherwise
                        oValueWriter:Write(hDynCall:return-value).
                end case.
            end.
            else
                oValueWriter:Write(return-value).
            
            oValueWriter:Close().
            
            assign oOperArg:ArgumentValue = oValueWriter:Value.
            
            SetOutputValue(oOperArg, poResponse).
        end.
        
        /* HANDLE OUTPUT args */
        OUTPUT-ARGS-LOOP:
        for each lbArg where
                 lbArg.ParentOH eq int64(this-object) and
                 lbArg.ParamIndex gt 0 
                 by lbArg.ParamIndex :
            
            assign oOperArg = cast(lbArg.Arg, OperationArgument).
            // We've done INPUT (we want OUTPUT and INPUT-OUTPUT) 
            if not oOperArg:Parameter:IoMode:IsFlagSet(IOModeEnum:Output) then
                next OUTPUT-ARGS-LOOP.
            
            assign oValueWriter = ArgumentValueWriterBuilder:Build(oOperArg)
                                    :Logger(this-object:Logger)
                                    :Writer.
            Assert:NotNull(oValueWriter, 'Argument value writer').
            
            // If this is an IN-OUT operation we can reuse the ArgValue object
            if valid-object(oOperArg:ArgumentValue) then
                assign oValueWriter:Value = oOperArg:ArgumentValue.
            
            oValueWriter:Open().
            
            /* The datatype of the ABL parameter. */
            case oOperArg:Parameter:DataType:
                {OpenEdge/Web/DataObject/doh_execute_setargvalues.i &DATA-TYPE=integer     }
                {OpenEdge/Web/DataObject/doh_execute_setargvalues.i &DATA-TYPE=int64       }
                {OpenEdge/Web/DataObject/doh_execute_setargvalues.i &DATA-TYPE=character   }
                {OpenEdge/Web/DataObject/doh_execute_setargvalues.i &DATA-TYPE=longchar    }
                {OpenEdge/Web/DataObject/doh_execute_setargvalues.i &DATA-TYPE=decimal     }
                {OpenEdge/Web/DataObject/doh_execute_setargvalues.i &DATA-TYPE=logical     }
                {OpenEdge/Web/DataObject/doh_execute_setargvalues.i &DATA-TYPE=date        }
                {OpenEdge/Web/DataObject/doh_execute_setargvalues.i &DATA-TYPE=datetime    }
                {OpenEdge/Web/DataObject/doh_execute_setargvalues.i &DATA-TYPE=datetime-tz }
                {OpenEdge/Web/DataObject/doh_execute_setargvalues.i &DATA-TYPE=handle      }
                {OpenEdge/Web/DataObject/doh_execute_setargvalues.i &DATA-TYPE=recid       }
                {OpenEdge/Web/DataObject/doh_execute_setargvalues.i &DATA-TYPE=rowid       }
                {OpenEdge/Web/DataObject/doh_execute_setargvalues.i &DATA-TYPE=raw         }
                {OpenEdge/Web/DataObject/doh_execute_setargvalues.i &DATA-TYPE=memptr      }
                {OpenEdge/Web/DataObject/doh_execute_setargvalues.i &DATA-TYPE=pds         &SWITCH-VALUE=dataset-handle }
                {OpenEdge/Web/DataObject/doh_execute_setargvalues.i &DATA-TYPE=tt          &SWITCH-VALUE=table-handle   }
                {OpenEdge/Web/DataObject/doh_execute_setargvalues.i &DATA-TYPE=plo         &SWITCH-VALUE=class          }
                otherwise
                    undo, throw new AppError(substitute('Unsupported data type &1', oOperArg:Parameter:ABLType), 0).
            end case.   /* oOperParam:ABLType */
            
            oValueWriter:Close().
            /* get the values from the writer, incl object writers */
            assign oOperArg:ArgumentValue = oValueWriter:Value.
            
            SetOutputValue(oOperArg, poResponse).
        end.
        
        return integer(StatusCodeEnum:None).
        finally:            
            delete object hDynCall no-error.
            // so that cleanArguments can, in fact, clean
            assign oOperArg     = ?
                   oValueWriter = ?
                   // reset the error-status:error flag
                   no-error.
            
            ClearArguments().
            
            /* clean variables */   
            define variable iCleanLoop as integer no-undo. 
            /* memptrs */
            set-size(retval_scalar_memptr) = 0.
            do iCleanLoop = extent(retval_arr_memptr) to 1 by -1: set-size(retval_arr_memptr[iCleanLoop]) = 0. end.
            do iCleanLoop = extent(arg_scalar_memptr) to 1 by -1: set-size(arg_scalar_memptr[iCleanLoop]) = 0. end.
            
            do iCleanLoop = extent(arg_arr_memptr_01) to 1 by -1: set-size(arg_arr_memptr_01[iCleanLoop]) = 0. end. 
            do iCleanLoop = extent(arg_arr_memptr_02) to 1 by -1: set-size(arg_arr_memptr_02[iCleanLoop]) = 0. end.
            do iCleanLoop = extent(arg_arr_memptr_03) to 1 by -1: set-size(arg_arr_memptr_03[iCleanLoop]) = 0. end.
            do iCleanLoop = extent(arg_arr_memptr_04) to 1 by -1: set-size(arg_arr_memptr_04[iCleanLoop]) = 0. end.
            do iCleanLoop = extent(arg_arr_memptr_05) to 1 by -1: set-size(arg_arr_memptr_05[iCleanLoop]) = 0. end.
            do iCleanLoop = extent(arg_arr_memptr_06) to 1 by -1: set-size(arg_arr_memptr_06[iCleanLoop]) = 0. end.
            do iCleanLoop = extent(arg_arr_memptr_07) to 1 by -1: set-size(arg_arr_memptr_07[iCleanLoop]) = 0. end.
            do iCleanLoop = extent(arg_arr_memptr_08) to 1 by -1: set-size(arg_arr_memptr_08[iCleanLoop]) = 0. end.
            do iCleanLoop = extent(arg_arr_memptr_09) to 1 by -1: set-size(arg_arr_memptr_09[iCleanLoop]) = 0. end.
            do iCleanLoop = extent(arg_arr_memptr_10) to 1 by -1: set-size(arg_arr_memptr_10[iCleanLoop]) = 0. end.
            do iCleanLoop = extent(arg_arr_memptr_11) to 1 by -1: set-size(arg_arr_memptr_11[iCleanLoop]) = 0. end.
            do iCleanLoop = extent(arg_arr_memptr_12) to 1 by -1: set-size(arg_arr_memptr_12[iCleanLoop]) = 0. end.
            do iCleanLoop = extent(arg_arr_memptr_13) to 1 by -1: set-size(arg_arr_memptr_13[iCleanLoop]) = 0. end.
            do iCleanLoop = extent(arg_arr_memptr_14) to 1 by -1: set-size(arg_arr_memptr_14[iCleanLoop]) = 0. end.
            do iCleanLoop = extent(arg_arr_memptr_15) to 1 by -1: set-size(arg_arr_memptr_15[iCleanLoop]) = 0. end.
            do iCleanLoop = extent(arg_arr_memptr_16) to 1 by -1: set-size(arg_arr_memptr_16[iCleanLoop]) = 0. end.
            do iCleanLoop = extent(arg_arr_memptr_17) to 1 by -1: set-size(arg_arr_memptr_17[iCleanLoop]) = 0. end.
            do iCleanLoop = extent(arg_arr_memptr_18) to 1 by -1: set-size(arg_arr_memptr_18[iCleanLoop]) = 0. end.
            do iCleanLoop = extent(arg_arr_memptr_19) to 1 by -1: set-size(arg_arr_memptr_19[iCleanLoop]) = 0. end.
            do iCleanLoop = extent(arg_arr_memptr_20) to 1 by -1: set-size(arg_arr_memptr_20[iCleanLoop]) = 0. end.
            do iCleanLoop = extent(arg_arr_memptr_21) to 1 by -1: set-size(arg_arr_memptr_21[iCleanLoop]) = 0. end.
            do iCleanLoop = extent(arg_arr_memptr_22) to 1 by -1: set-size(arg_arr_memptr_22[iCleanLoop]) = 0. end.
            do iCleanLoop = extent(arg_arr_memptr_23) to 1 by -1: set-size(arg_arr_memptr_23[iCleanLoop]) = 0. end.
            do iCleanLoop = extent(arg_arr_memptr_24) to 1 by -1: set-size(arg_arr_memptr_24[iCleanLoop]) = 0. end.
            do iCleanLoop = extent(arg_arr_memptr_25) to 1 by -1: set-size(arg_arr_memptr_25[iCleanLoop]) = 0. end.
            do iCleanLoop = extent(arg_arr_memptr_26) to 1 by -1: set-size(arg_arr_memptr_26[iCleanLoop]) = 0. end.
            do iCleanLoop = extent(arg_arr_memptr_27) to 1 by -1: set-size(arg_arr_memptr_27[iCleanLoop]) = 0. end.
            do iCleanLoop = extent(arg_arr_memptr_28) to 1 by -1: set-size(arg_arr_memptr_28[iCleanLoop]) = 0. end.
            do iCleanLoop = extent(arg_arr_memptr_29) to 1 by -1: set-size(arg_arr_memptr_29[iCleanLoop]) = 0. end.
            do iCleanLoop = extent(arg_arr_memptr_30) to 1 by -1: set-size(arg_arr_memptr_30[iCleanLoop]) = 0. end.
            do iCleanLoop = extent(arg_arr_memptr_31) to 1 by -1: set-size(arg_arr_memptr_31[iCleanLoop]) = 0. end.
            do iCleanLoop = extent(arg_arr_memptr_32) to 1 by -1: set-size(arg_arr_memptr_32[iCleanLoop]) = 0. end.
        end finally.
    end method.
    
end class.