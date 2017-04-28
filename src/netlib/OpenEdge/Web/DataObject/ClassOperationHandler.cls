/* *************************************************************************************************************************
Copyright (c) 2016 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
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
using OpenEdge.Core.IOModeEnum.
using OpenEdge.Core.LogLevelEnum.
using OpenEdge.Core.System.ArgumentError.
using OpenEdge.Core.Util.ILogWriter.
using OpenEdge.Net.HTTP.IHttpResponse.
using OpenEdge.Net.HTTP.StatusCodeEnum.
using OpenEdge.Web.DataObject.MappedOperation.
using OpenEdge.Web.DataObject.OperationArgument.
using OpenEdge.Web.DataObject.OperationHandler.
using OpenEdge.Web.DataObject.OperationParameter.
using OpenEdge.Web.DataObject.Writer.ArgumentValueWriter.
using OpenEdge.Web.DataObject.Writer.ArgumentValueWriterBuilder.
using OpenEdge.Web.IWebRequest.
using OpenEdge.Web.SendExceptionError.
using Progress.Lang.AppError.
using Progress.Lang.ParameterList.
using Progress.Reflect.DataType.
using Progress.Reflect.Flags.

class OpenEdge.Web.DataObject.ClassOperationHandler  inherits OperationHandler:
    
    constructor public ClassOperationHandler():
        super().
    end constructor.
    
    constructor public ClassOperationHandler(input poLogger as ILogWriter):
        super(poLogger).
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
       @param MappedOperation The mapped operation
       @param P.L.Object The business logic/entity  
       @return integer A non-null status code use to deal with errors */
    method override public integer Execute(input poRequest  as IWebRequest,
                                           input poMessageBody as Progress.Lang.Object,
                                           input poResponse as IHttpResponse,
                                           input poOperation as MappedOperation,
                                           input poEntity as Progress.Lang.Object):
        define variable iMax as integer no-undo.
        define variable iLoop as integer no-undo.
        define variable iArgIdx as integer no-undo.
        define variable iStartTime as integer no-undo.
        define variable iEndTime as integer no-undo.
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
        Assert:NotNull(poOperation, 'Mapped operation').
        Assert:NotNull(poEntity, 'Entity').

        ClearArguments().
        
        /* CREATE PARAMETER LIST FROM OPERATION */
        if valid-object(poOperation:ReturnValue) then
        do:
            create lbArg.
            assign lbArg.ParentCOH  = int64(this-object)
                   lbArg.ParamIndex = 0
                   oOperArg = new OperationArgument(poOperation, 
                                                    poOperation:ReturnValue, 
                                                    poRequest, 
                                                    poResponse)
                   lbArg.Arg = oOperArg
                   .
        end.
        
        /* create ParameterList from operation params (IN, IN-OUT, OUT ) */
        assign iMax       = poOperation:Parameters:Size
               oParamList = new ParameterList(iMax).
        PARAM-LOOP:
        do iLoop = 1 to iMax:
            assign oOperArg = new OperationArgument(poOperation, 
                                                    cast(poOperation:Parameters:Get(iLoop), OperationParameter), 
                                                    poRequest, 
                                                    poResponse).
            case oOperArg:Parameter:IOMode:
                when IOModeEnum:Input  or
                when IOModeEnum:Input-Output or
                when IOModeEnum:Output then
                do:
                    /* hold and store args for later processing  */
                    create lbArg.
                    assign lbArg.ParentCOH  = int64(this-object)
                           lbArg.Arg        = oOperArg
                           iArgIdx          = iArgIdx + 1
                           lbArg.ParamIndex = iArgIdx. 
                end.

                otherwise
                do:
                    LogMessage(substitute('IoMode &1 not supported for operation target &2',
                                    string(oOperArg:Parameter:IOMode),
                                    string(poOperation:TargetType)),
                               LogLevelEnum:INFO).
                    next PARAM-LOOP.
                end.    /* unsupported */
            end case.
            
            /* always create the schema if we can for input modes (IN and IN-OUT), so that we are not
               trying to infer schema. OUT and RETURN do the right thing */
            if oOperArg:Parameter:IOMode ne IOModeEnum:Output then
                InitDataStructure(oOperArg).
            
            /* sets the primtive or object value on the operation argument */
            GetInputValue(oOperArg, poMessageBody).
            
            /* Sets the value to true if required. Only do this AFTER we've loaded data
               from the HTTP message since things like READ-JSON do a CREATE tt. under the 
               covers which messes with the ROW-STATE */
            if oOperArg:HasSchema then
                SetTrackingChanges(oOperArg, true).
            
            LogMessage(substitute('&4: SetParameter(&1 [&6], &2, &3) &5',
                         lbArg.ParamIndex,
                         oOperArg:DataType,
                         oOperArg:IoMode,
                         poOperation:TargetFunction,
                         string(oOperArg:ArgumentValue),
                         oOperArg:Parameter:ABLName),
                       LogLevelEnum:TRACE).
            
            if oOperArg:IsArray then
            case oOperArg:DataType:
                {OpenEdge/Web/DataObject/doh_execute_setparam_array.i &ARG-TYPE=int64       &ARG-VALUE-TYPE=Ccs.Common.Support.IInt64ArrayHolder }
                {OpenEdge/Web/DataObject/doh_execute_setparam_array.i &ARG-TYPE=integer     &ARG-VALUE-TYPE=Ccs.Common.Support.IInt64ArrayHolder  } 
                {OpenEdge/Web/DataObject/doh_execute_setparam_array.i &ARG-TYPE=character   &ARG-VALUE-TYPE=Ccs.Common.Support.ILongcharArrayHolder  &COERCE-TYPE=string  }
                {OpenEdge/Web/DataObject/doh_execute_setparam_array.i &ARG-TYPE=longchar    &ARG-VALUE-TYPE=Ccs.Common.Support.ILongcharArrayHolder }
                {OpenEdge/Web/DataObject/doh_execute_setparam_array.i &ARG-TYPE=decimal     &ARG-VALUE-TYPE=Ccs.Common.Support.IDecimalArrayHolder  }
                {OpenEdge/Web/DataObject/doh_execute_setparam_array.i &ARG-TYPE=logical     &ARG-VALUE-TYPE=Ccs.Common.Support.ILogicalArrayHolder }
                {OpenEdge/Web/DataObject/doh_execute_setparam_array.i &ARG-TYPE=rowid       &ARG-VALUE-TYPE=Ccs.Common.Support.IRowidArrayHolder }
                {OpenEdge/Web/DataObject/doh_execute_setparam_array.i &ARG-TYPE=recid       &ARG-VALUE-TYPE=Ccs.Common.Support.IInt64ArrayHolder    &COERCE-TYPE=integer }
/*                {OpenEdge/Web/DataObject/doh_execute_setparam_array.i &ARG-TYPE=raw         &ARG-VALUE-TYPE=OpenEdge.Core.Memptr}*/
                {OpenEdge/Web/DataObject/doh_execute_setparam_array.i &ARG-TYPE=date        &ARG-VALUE-TYPE=Ccs.Common.Support.IDateArrayHolder  }
                {OpenEdge/Web/DataObject/doh_execute_setparam_array.i &ARG-TYPE=datetime    &ARG-VALUE-TYPE=Ccs.Common.Support.IDateTimeArrayHolder }
                {OpenEdge/Web/DataObject/doh_execute_setparam_array.i &ARG-TYPE=datetime-tz &ARG-VALUE-TYPE=Ccs.Common.Support.IDateTimeTzArrayHolder }
                {OpenEdge/Web/DataObject/doh_execute_setparam_array.i &ARG-TYPE=memptr      &ARG-VALUE-TYPE=Ccs.Common.Support.IMemptrArrayHolder }
                {OpenEdge/Web/DataObject/doh_execute_setparam_array.i &ARG-TYPE=handle      &ARG-VALUE-TYPE=Ccs.Common.Support.IHandleArrayHolder }
                /* data structures & objects */               
                {OpenEdge/Web/DataObject/doh_execute_setparam_array.i &ARG-TYPE=pds         &ARG-VALUE-TYPE=Ccs.Common.Support.IHandleArrayHolder   &SWITCH-VALUE=dataset-handle }
                {OpenEdge/Web/DataObject/doh_execute_setparam_array.i &ARG-TYPE=tt          &ARG-VALUE-TYPE=Ccs.Common.Support.IHandleArrayHolder   &SWITCH-VALUE=table-handle   }
                {OpenEdge/Web/DataObject/doh_execute_setparam_array.i &ARG-TYPE=plo         &ARG-VALUE-TYPE=OpenEdge.Core.ObjectArrayHolder         &SWITCH-VALUE=class          }
            end case.   /* arrays */
            else
            case oOperArg:DataType:
                {OpenEdge/Web/DataObject/doh_execute_setparam_scalar.i &ARG-TYPE=int64       &ARG-VALUE-TYPE=Ccs.Common.Support.IInt64Holder}
                {OpenEdge/Web/DataObject/doh_execute_setparam_scalar.i &ARG-TYPE=integer     &ARG-VALUE-TYPE=Ccs.Common.Support.IInt64Holder    &COERCE-TYPE=integer }
                {OpenEdge/Web/DataObject/doh_execute_setparam_scalar.i &ARG-TYPE=character   &ARG-VALUE-TYPE=Ccs.Common.Support.ILongcharHolder &COERCE-TYPE=string }
                {OpenEdge/Web/DataObject/doh_execute_setparam_scalar.i &ARG-TYPE=longchar    &ARG-VALUE-TYPE=Ccs.Common.Support.ILongcharHolder}
                {OpenEdge/Web/DataObject/doh_execute_setparam_scalar.i &ARG-TYPE=decimal     &ARG-VALUE-TYPE=Ccs.Common.Support.IDecimalHolder}
                {OpenEdge/Web/DataObject/doh_execute_setparam_scalar.i &ARG-TYPE=logical     &ARG-VALUE-TYPE=Ccs.Common.Support.ILogicalHolder}
                {OpenEdge/Web/DataObject/doh_execute_setparam_scalar.i &ARG-TYPE=rowid       &ARG-VALUE-TYPE=Ccs.Common.Support.IRowidHolder}
                {OpenEdge/Web/DataObject/doh_execute_setparam_scalar.i &ARG-TYPE=recid       &ARG-VALUE-TYPE=Ccs.Common.Support.IInt64Holder    &COERCE-TYPE=integer}
/*              {OpenEdge/Web/DataObject/doh_execute_setparam_scalar.i &ARG-TYPE=raw         &ARG-VALUE-TYPE=OpenEdge.Core.Memptr} */                                                                                        
                {OpenEdge/Web/DataObject/doh_execute_setparam_scalar.i &ARG-TYPE=date        &ARG-VALUE-TYPE=Ccs.Common.Support.IDateHolder       }
                {OpenEdge/Web/DataObject/doh_execute_setparam_scalar.i &ARG-TYPE=datetime    &ARG-VALUE-TYPE=Ccs.Common.Support.IDateTimeHolder   }
                {OpenEdge/Web/DataObject/doh_execute_setparam_scalar.i &ARG-TYPE=datetime-tz &ARG-VALUE-TYPE=Ccs.Common.Support.IDateTimeTzHolder }
                {OpenEdge/Web/DataObject/doh_execute_setparam_scalar.i &ARG-TYPE=memptr      &ARG-VALUE-TYPE=Ccs.Common.Support.IMemptrHolder}
                {OpenEdge/Web/DataObject/doh_execute_setparam_scalar.i &ARG-TYPE=handle      &ARG-VALUE-TYPE=Ccs.Common.Support.IHandleHolder}
                /* data structures & objects */                                             
                {OpenEdge/Web/DataObject/doh_execute_setparam_scalar.i &ARG-TYPE=pds        &ARG-VALUE-TYPE=Ccs.Common.Support.IHandleHolder    &SWITCH-VALUE=dataset-handle }
                {OpenEdge/Web/DataObject/doh_execute_setparam_scalar.i &ARG-TYPE=tt         &ARG-VALUE-TYPE=Ccs.Common.Support.IHandleHolder    &SWITCH-VALUE=table-handle   }
                {OpenEdge/Web/DataObject/doh_execute_setparam_scalar.i &ARG-TYPE=plo        &ARG-VALUE-TYPE=Progress.Lang.Object                &SWITCH-VALUE=class          }
            end case.    /* scalar */
        end.    // PARAM-LOOP
        
        /* FIND THE METHOD TO INVOKE */
        assign oMethod = poEntity:GetClass()
                                 :GetMethod(poOperation:TargetFunction, 
                                           // don't want static stuff 
                                           (Flags:Public or Flags:Instance),
                                           oParamList).
                                           
        if not valid-object(oMethod) then
            undo, throw new SendExceptionError(StatusCodeEnum:NotImplemented,
                                               new AppError(substitute('Unable to find class method for &1',
                                                    string(poOperation)),
                                                    0)).
        
        LogMessage(substitute('Using method &1 for operation &2',
                        oMethod:ToString(),
                        poOperation:ToString()),
                   LogLevelEnum:TRACE).                                   
                                           
        /* INVOKE & HANDLE RETURN-VALUE */
        find lbArg where lbArg.ParentCOH eq int64(this-object) and
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
            
            SetOutputValue(oOperArg).
        end.
        else
        do:
            assign iStartTime = mtime.
            /* This invoke is basically what doh_execute_invoke.i does, but there are
               no return values to deal with in this case (or we don't care about them). */
            oMethod:Invoke(poEntity, oParamList).
            assign iEndTime = mtime.
        end.
        
        LogMessage(substitute('Execution time for &1:&2 = &3 (ms)',
                    poOperation:TargetName,
                    poOperation:TargetFunction,
                    iEndTime - iStartTime),
                   LogLevelEnum:TRACE).
        
        /* HANDLE OUTPUT args */
        OUTPUT-ARGS-LOOP:
        for each lbArg where lbArg.ParentCOH eq int64(this-object) and
                 lbArg.ParamIndex gt 0 
                 by lbArg.ParamIndex :
            
            assign oOperArg = cast(lbArg.Arg, OperationArgument).
            /* We've done INPUT already */
            if oOperArg:IoMode eq IOModeEnum:Input:ToString() then
                next OUTPUT-ARGS-LOOP.
            
            assign oValueWriter = ArgumentValueWriterBuilder:Build(oOperArg)
                                    :Logger(this-object:Logger)
                                    :Writer.
            Assert:NotNull(oValueWriter, 'Argument value writer').
            oValueWriter:Open().
            
            /* The datatype of the ABL parameter. */
            case oOperArg:DataType:
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
            
            SetOutputValue(oOperArg).
        end.
        
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
    
    /** Logs a message 
        
        @param character The message to log */ 
    method private void LogMessage(input pcMessage as character,
                                   input poLogLevel as LogLevelEnum):
        OnLogMessage(pcMessage, poLogLevel, 'DOH-CLS':u).
    end method.

end class.
