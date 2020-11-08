/* *************************************************************************************************************************
Copyright (c) 2016-2019 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : ClassOperationHandler
    Purpose     : Delegate for mapped file operations for the DOH
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Fri May 20 12:15:00 EDT 2016
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.DateTimeAddIntervalEnum.
using OpenEdge.Core.IOModeEnum.
using OpenEdge.Logging.LogLevelEnum.
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
using Progress.Lang.ParameterList.
using Progress.Reflect.DataType.

class OpenEdge.Web.DataObject.ClassOperationHandler  inherits OperationHandler:
    
    constructor public ClassOperationHandler():
        super().
    end constructor.
    
    /* Executes the operation.
    
       This is a big, big, huge ugly method because we have to keep the variables used
       by the ParameterList object in scope - particularly for output values -
       and so cannot create the param list anywhere but in the same method in 
       which we invoke the method.
       
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
        define variable execTime as datetime extent 2 no-undo.
        define variable paramTime as datetime extent 2 no-undo.
        define variable oParamList as Progress.Lang.ParameterList no-undo.
        define variable oMethod as Progress.Reflect.Method no-undo.
        define variable oOperArg as OperationArgument no-undo.
        define variable oValueWriter as ArgumentValueWriter no-undo.

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
        Assert:NotNull(pService, 'Service').
        Assert:NotNull(poOperation, 'Mapped operation').
        Assert:NotNull(poEntity, 'Entity').
        
        BuildArguments(poRequest, poMessageBody, poResponse, pService, poOperation).
        
        /* create ParameterList from operation params (IN, IN-OUT, OUT ) */
        assign execTime[1] = now
               oParamList  = new ParameterList(poOperation:Parameters:Size)
               .
        for each lbArg where
                 lbArg.ParentOH eq int64(this-object) and
                 lbArg.ParamIndex ge 1:
            assign paramTime[1] = now
                   oOperArg = cast(lbArg.Arg, OperationArgument).
            if oOperArg:Parameter:IsArray then
            case oOperArg:Parameter:DataType:
                {OpenEdge/Web/DataObject/doh_execute_setparam_array.i &ARG-TYPE=int64       &ARG-VALUE-TYPE=Ccs.Common.Support.IInt64ArrayHolder        }
                {OpenEdge/Web/DataObject/doh_execute_setparam_array.i &ARG-TYPE=integer     &ARG-VALUE-TYPE=Ccs.Common.Support.IInt64ArrayHolder        }
                {OpenEdge/Web/DataObject/doh_execute_setparam_array.i &ARG-TYPE=character   &ARG-VALUE-TYPE=Ccs.Common.Support.ILongcharArrayHolder     }
                {OpenEdge/Web/DataObject/doh_execute_setparam_array.i &ARG-TYPE=longchar    &ARG-VALUE-TYPE=Ccs.Common.Support.ILongcharArrayHolder     }
                {OpenEdge/Web/DataObject/doh_execute_setparam_array.i &ARG-TYPE=decimal     &ARG-VALUE-TYPE=Ccs.Common.Support.IDecimalArrayHolder      }
                {OpenEdge/Web/DataObject/doh_execute_setparam_array.i &ARG-TYPE=logical     &ARG-VALUE-TYPE=Ccs.Common.Support.ILogicalArrayHolder      }
                {OpenEdge/Web/DataObject/doh_execute_setparam_array.i &ARG-TYPE=rowid       &ARG-VALUE-TYPE=Ccs.Common.Support.IRowidArrayHolder        }
                {OpenEdge/Web/DataObject/doh_execute_setparam_array.i &ARG-TYPE=recid       &ARG-VALUE-TYPE=Ccs.Common.Support.IInt64ArrayHolder        }
                {OpenEdge/Web/DataObject/doh_execute_setparam_array.i &ARG-TYPE=date        &ARG-VALUE-TYPE=Ccs.Common.Support.IDateArrayHolder         }
                {OpenEdge/Web/DataObject/doh_execute_setparam_array.i &ARG-TYPE=datetime    &ARG-VALUE-TYPE=Ccs.Common.Support.IDateTimeArrayHolder     }
                {OpenEdge/Web/DataObject/doh_execute_setparam_array.i &ARG-TYPE=datetime-tz &ARG-VALUE-TYPE=Ccs.Common.Support.IDateTimeTzArrayHolder   }
                {OpenEdge/Web/DataObject/doh_execute_setparam_array.i &ARG-TYPE=memptr      &ARG-VALUE-TYPE=Ccs.Common.Support.IMemptrArrayHolder       }
                {OpenEdge/Web/DataObject/doh_execute_setparam_array.i &ARG-TYPE=handle      &ARG-VALUE-TYPE=Ccs.Common.Support.IHandleArrayHolder       }
                {OpenEdge/Web/DataObject/doh_execute_setparam_array.i &ARG-TYPE=plo         &ARG-VALUE-TYPE=OpenEdge.Core.IObjectArrayHolder             &SWITCH-VALUE=class }
            end case.   /* arrays */
            else
            case oOperArg:Parameter:DataType:
                {OpenEdge/Web/DataObject/doh_execute_setparam_scalar.i &ARG-TYPE=int64       &ARG-VALUE-TYPE=Ccs.Common.Support.IInt64Holder        }
                {OpenEdge/Web/DataObject/doh_execute_setparam_scalar.i &ARG-TYPE=integer     &ARG-VALUE-TYPE=Ccs.Common.Support.IInt64Holder    &COERCE-TYPE=integer }
                {OpenEdge/Web/DataObject/doh_execute_setparam_scalar.i &ARG-TYPE=character   &ARG-VALUE-TYPE=Ccs.Common.Support.ILongcharHolder &COERCE-TYPE=string  }
                {OpenEdge/Web/DataObject/doh_execute_setparam_scalar.i &ARG-TYPE=longchar    &ARG-VALUE-TYPE=Ccs.Common.Support.ILongcharHolder     }
                {OpenEdge/Web/DataObject/doh_execute_setparam_scalar.i &ARG-TYPE=decimal     &ARG-VALUE-TYPE=Ccs.Common.Support.IDecimalHolder      }
                {OpenEdge/Web/DataObject/doh_execute_setparam_scalar.i &ARG-TYPE=logical     &ARG-VALUE-TYPE=Ccs.Common.Support.ILogicalHolder      }
                {OpenEdge/Web/DataObject/doh_execute_setparam_scalar.i &ARG-TYPE=rowid       &ARG-VALUE-TYPE=Ccs.Common.Support.IRowidHolder        }
                {OpenEdge/Web/DataObject/doh_execute_setparam_scalar.i &ARG-TYPE=recid       &ARG-VALUE-TYPE=Ccs.Common.Support.IInt64Holder    &COERCE-TYPE=integer }
                {OpenEdge/Web/DataObject/doh_execute_setparam_scalar.i &ARG-TYPE=date        &ARG-VALUE-TYPE=Ccs.Common.Support.IDateHolder         }
                {OpenEdge/Web/DataObject/doh_execute_setparam_scalar.i &ARG-TYPE=datetime    &ARG-VALUE-TYPE=Ccs.Common.Support.IDateTimeHolder     }
                {OpenEdge/Web/DataObject/doh_execute_setparam_scalar.i &ARG-TYPE=datetime-tz &ARG-VALUE-TYPE=Ccs.Common.Support.IDateTimeTzHolder   }
                {OpenEdge/Web/DataObject/doh_execute_setparam_scalar.i &ARG-TYPE=memptr      &ARG-VALUE-TYPE=Ccs.Common.Support.IMemptrHolder       }
                {OpenEdge/Web/DataObject/doh_execute_setparam_scalar.i &ARG-TYPE=handle      &ARG-VALUE-TYPE=Ccs.Common.Support.IHandleHolder       }
                {OpenEdge/Web/DataObject/doh_execute_setparam_scalar.i &ARG-TYPE=pds         &ARG-VALUE-TYPE=Ccs.Common.Support.IHandleHolder   &SWITCH-VALUE=dataset-handle }
                {OpenEdge/Web/DataObject/doh_execute_setparam_scalar.i &ARG-TYPE=tt          &ARG-VALUE-TYPE=Ccs.Common.Support.IHandleHolder   &SWITCH-VALUE=table-handle   }
                {OpenEdge/Web/DataObject/doh_execute_setparam_scalar.i &ARG-TYPE=plo         &ARG-VALUE-TYPE=Progress.Lang.Object               &SWITCH-VALUE=class          }
            end case.    /* scalar */
            
            assign paramTime[2] = now.
            Logger:Trace(substitute('&4: SetParameter(&1 [&6], &2&7, &3) &5 (&8ms)', 
                                lbArg.ParamIndex,
                                oOperArg:Parameter:DataType,
                                string(oOperArg:Parameter:IoMode),
                                poOperation:TargetFunction,
                                string(oOperArg:ArgumentValue),
                                oOperArg:Parameter:ABLName,
                                string(oOperArg:Parameter:IsArray, '[]/  ':u),
                                interval(paramTime[2], paramTime[1], string(DateTimeAddIntervalEnum:Milliseconds)) )).
        end.    // PARAM-LOOP
        
        assign execTime[2] = now.
        Logger:Debug(substitute('Arguments for &1:&2 initialized in &3ms', 
                                poOperation:TargetName, poOperation:TargetFunction, 
                                interval(execTime[2], execTime[1], string(DateTimeAddIntervalEnum:Milliseconds)))).
        
        /* FIND THE METHOD TO INVOKE */
        assign oMethod = GetEntityMethod(poEntity, poOperation:TargetFunction, oParamList).
        if not valid-object(oMethod) then
            undo, throw new SendExceptionError(StatusCodeEnum:NotImplemented,
                                               new AppError(substitute('Unable to find class method for &1',
                                                    string(poOperation)),
                                                    0)).
        Logger:Trace(substitute('Using method &1 for operation &2', oMethod:ToString(), poOperation:ToString())).
        
        /* INVOKE & HANDLE RETURN-VALUE */
        find lbArg where lbArg.ParentOH eq int64(this-object) and
             lbArg.ParamIndex eq 0
             no-error.
        /* either we haven't set up a return parameter or there is none. Either way ignore it. */
        if available lbArg and oMethod:ReturnType ne DataType:Void then 
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
        
        assign execTime[1] = now.
        if valid-object(oOperArg) then
        do:
            case oMethod:ReturnType:
                {OpenEdge/Web/DataObject/doh_execute_invoke.i &VAR-DATA-TYPE=Integer    }
                {OpenEdge/Web/DataObject/doh_execute_invoke.i &VAR-DATA-TYPE=Longchar   }
                {OpenEdge/Web/DataObject/doh_execute_invoke.i &VAR-DATA-TYPE=Int64      }
                {OpenEdge/Web/DataObject/doh_execute_invoke.i &VAR-DATA-TYPE=Decimal    }
                {OpenEdge/Web/DataObject/doh_execute_invoke.i &VAR-DATA-TYPE=Character  }
                {OpenEdge/Web/DataObject/doh_execute_invoke.i &VAR-DATA-TYPE=Logical    }
                {OpenEdge/Web/DataObject/doh_execute_invoke.i &VAR-DATA-TYPE=Rowid      }
                {OpenEdge/Web/DataObject/doh_execute_invoke.i &VAR-DATA-TYPE=Recid      }
                {OpenEdge/Web/DataObject/doh_execute_invoke.i &VAR-DATA-TYPE=Raw        }
                {OpenEdge/Web/DataObject/doh_execute_invoke.i &VAR-DATA-TYPE=Memptr     }
                {OpenEdge/Web/DataObject/doh_execute_invoke.i &VAR-DATA-TYPE=Handle     }
                {OpenEdge/Web/DataObject/doh_execute_invoke.i &VAR-DATA-TYPE=Date       }
                {OpenEdge/Web/DataObject/doh_execute_invoke.i &VAR-DATA-TYPE=Datetime   }
                
                {OpenEdge/Web/DataObject/doh_execute_invoke.i &VAR-DATA-TYPE=Datetime-TZ &RETURN-TYPE=DatetimeTZ }
                {OpenEdge/Web/DataObject/doh_execute_invoke.i &VAR-DATA-TYPE=handle      &RETURN-TYPE=DataSet}
                {OpenEdge/Web/DataObject/doh_execute_invoke.i &VAR-DATA-TYPE=handle      &RETURN-TYPE=DataSetHandle}
                {OpenEdge/Web/DataObject/doh_execute_invoke.i &VAR-DATA-TYPE=handle      &RETURN-TYPE=Table}
                {OpenEdge/Web/DataObject/doh_execute_invoke.i &VAR-DATA-TYPE=handle      &RETURN-TYPE=TableHandle}
                {OpenEdge/Web/DataObject/doh_execute_invoke.i &VAR-DATA-TYPE=plo         &RETURN-TYPE=Object}
                otherwise
                    undo, throw new AppError(substitute('Unsupported data type &1', string(oMethod:ReturnType)), 0).
            end case.   /* return types */
            if valid-object(oValueWriter) then
            do:
                oValueWriter:Close().
                assign oOperArg:ArgumentValue = oValueWriter:Value.
            end.
            
            SetOutputValue(oOperArg, poResponse).
        end.
        else
            /* This invoke is basically what doh_execute_invoke.i does, but there are
               no return values to deal with in this case (or we don't care about them). */
            oMethod:Invoke(poEntity, oParamList).
        
        assign execTime[2] = now.
        Logger:Trace(substitute('Execution time for &1:&2 = &3 (ms)', 
                                poOperation:TargetName, poOperation:TargetFunction, 
                                interval(execTime[2], execTime[1], string(DateTimeAddIntervalEnum:Milliseconds)))).
        
        /* HANDLE OUTPUT args */
        assign execTime[1] = now.
        OUTPUT-ARGS-LOOP:
        for each lbArg where lbArg.ParentOH eq int64(this-object) and
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
        
        assign execTime[2] = now.
        Logger:Trace(substitute('Building output values time for &1:&2 (num-params:&3) = &4 (ms)', 
                                poOperation:TargetName, poOperation:TargetFunction, poOperation:Parameters:Size, 
                                interval(execTime[2], execTime[1], string(DateTimeAddIntervalEnum:Milliseconds)))).
        
        return integer(StatusCodeEnum:None).
        finally:
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
    
    /* Attempts to find a method by reflection, using the name and # parameters.
       Methods must be public and instance-based
       
       @param P.L.Object The business logic code
       @param character The name of the method
       @param ParameterList The list of parameters for this operation    
       @return Method A matching method, or NULL if none can be found. */
    method private Progress.Reflect.Method GetEntityMethod(input pEntity as Progress.Lang.Object,
                                                           input pMethodName as character,
                                                           input pParams as Progress.Lang.ParameterList):
        define variable targetMethod as Progress.Reflect.Method extent no-undo.
        define variable methodParams as Progress.Reflect.Parameter extent no-undo.
        define variable entityType as class Progress.Lang.Class no-undo.
        define variable loop as integer no-undo.
        define variable cnt as integer no-undo.
        define variable paramLoop as integer no-undo.
        define variable paramCnt as integer no-undo.
        define variable hasMatchingSig as logical no-undo.
        define variable hasMatchingName as logical no-undo.
        define variable methFlags as Progress.Reflect.Flags no-undo.
        
        assign entityType           = pEntity:GetClass()
               extent(targetMethod) = 1
               methFlags            = (   Progress.Reflect.Flags:Instance
                                       or Progress.Reflect.Flags:Public) 
               targetMethod[1]      = entityType:GetMethod(pMethodName, methFlags, pParams)
               .
        // if we're debugging, write more stuff
        if     not valid-object(targetMethod[1])
           and Logger:LogLevel ge LogLevelEnum:DEBUG
        then
        do:
            // this block attempts to figure out what failed in the GetMethod() call
            Logger:Debug(substitute('Unable to find PUBLIC instance method &1 in entity &2 with matching parameters (&3)',
                            pMethodName, entityType:TypeName, pParams:NumParameters)).
            
            // Is the access level wrong?
            assign methFlags       = (   Progress.Reflect.Flags:Instance 
                                      or Progress.Reflect.Flags:Private
                                      or Progress.Reflect.Flags:Protected)
                   targetMethod[1] = entityType:GetMethod(pMethodName, methFlags, pParams)
                   .
            if valid-object(targetMethod[1]) then
            do:
                Logger:Debug(substitute('Instance method &1 exists with the correct parameters but is &2',
                                pMethodName, caps(string(targetMethod[1]:AccessMode)))).
                return ?.
            end.
            
            // Is it a static method?
            assign methFlags       = (   Progress.Reflect.Flags:Static
                                      or Progress.Reflect.Flags:Public
                                      or Progress.Reflect.Flags:Protected
                                      or Progress.Reflect.Flags:Private   )
                   targetMethod[1] = entityType:GetMethod(pMethodName, methFlags, pParams)
                   .
            if valid-object(targetMethod[1]) then
            do:
                Logger:Debug(substitute('Method &1 exists with the correct parameters but is STATIC and &2',
                                pMethodName, caps(string(targetMethod[1]:AccessMode)))).
                return ?.
            end.
            
            assign extent(targetMethod) = ?
                   methFlags            = (   Progress.Reflect.Flags:Instance
                                           or Progress.Reflect.Flags:Public)
                   targetMethod         = entityType:GetMethods(methFlags)
                   cnt                  = extent(targetMethod)
                   hasMatchingSig       = no
                   hasMatchingName      = no
                   .
            do loop = 1 to cnt:
                if not targetMethod[loop]:Name eq pMethodName then
                    next.
                
                assign hasMatchingName = yes.
                if targetMethod[loop]:NumParameters eq pParams:NumParameters then
                do:
                    assign hasMatchingSig       = yes
                           extent(methodParams) = ?
                           methodParams         = targetMethod[loop]:GetParameters()
                           paramCnt             = extent(methodParams)
                           .
                    do paramLoop = 1 to paramCnt:
                        case methodParams[paramLoop]:DataType:
                            when DataType:DataSet or
                            when DataType:DataSetHandle or
                            when DataType:Table or
                            when DataType:TableHandle then
                                Logger:Debug(substitute('Method &1 parameter &4 ("&2") is a &3; make sure that schemas match between the code and mapping file, and that temp-tables are not defined LIKE <db-table>, or that tables, fields and indexes are in the correct order', 
                                                pMethodName, methodParams[paramLoop]:Name, string(methodParams[paramLoop]:DataType), paramLoop)).
                        end case.
                    end.
                end.
                
                if not hasMatchingSig then
                    Logger:Debug(substitute('Method &1 exists and is PUBLIC but does not have the expected number of parameters - &2',
                                                pMethodName, pParams:NumParameters )).
            end.
            
            if not hasMatchingName then
                Logger:Debug(substitute('Method &1 does not exist in entity &2', pMethodName, entityType:TypeName )).
            
            // we know we couldn't find the right one
            return ?.
        end.
        
        return targetMethod[1].
    end method.

end class.
