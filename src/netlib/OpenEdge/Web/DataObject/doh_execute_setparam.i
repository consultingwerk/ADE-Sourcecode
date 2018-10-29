&if false &then
/* *************************************************************************************************************************
Copyright (c) 2016-2018 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : doh_execute_setparam.i
    Purpose     : 
    Author(s)   : pjudge 
    Created     : 2016-05-27
    Notes       : * Arguments are
                  &IDX            = index of the the array to use 
                  &ARG-TYPE       = ABL datatype, no abbreviation (integer etc)
                  &ARG-VALUE-TYPE = the holder type (derived from IPrimitiveHolder)
                  &PARAM-IDX      = the number of the parameter being set in the method arguments
                  &OPER-ARG       = a reference to the operation argument in use
                  &PARAM-LIST     = the Progress.Lang.ParameterList reference in use
                  &SWITCH-VALUE   = The underlying 'real' value  
  ----------------------------------------------------------------------*/
&endif 
&if defined(OPER-ARG) eq 0 &then
&scoped-define OPER-ARG oOperArg
&endif
&if defined(PARAM-LIST) eq 0 &then
&scoped-define PARAM-LIST oParamList
&endif
&if defined(PARAM-IDX) eq 0 &then
&scoped-define PARAM-IDX lbArg.ParamIndex
&endif
when {&IDX} then
do:
    assign arg_arr_idx_{&ARG-TYPE}   = arg_arr_idx_{&ARG-TYPE} + 1
           {&OPER-ARG}:ArgumentIndex = arg_arr_idx_{&ARG-TYPE}.
    if valid-object({&OPER-ARG}:ArgumentValue) then
&if '{&SWITCH-VALUE}' eq 'class' &then
        assign arg_arr_{&ARG-TYPE}_{&IDX} = {&OPER-ARG}:ArgumentValue.
&else
        assign arg_arr_{&ARG-TYPE}_{&IDX} = cast({&OPER-ARG}:ArgumentValue, {&ARG-VALUE-TYPE}):Value.
&endif
    {&PARAM-LIST}:SetParameter({&PARAM-IDX}, 
&if '{&SWITCH-VALUE}' eq 'class' &then
                               'class ':u + {&OPER-ARG}:Parameter:ArgumentType:TypeName
&else
                                {&OPER-ARG}:Parameter:DataType
&endif
                                + ' extent':u,
                               OpenEdge.Core.IOModeHelper:ToString({&OPER-ARG}:Parameter:IOMode, get-class(Progress.Lang.ParameterList):TypeName), 
                               arg_arr_{&ARG-TYPE}_{&IDX}).
end.