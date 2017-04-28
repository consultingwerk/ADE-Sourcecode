&if false &then
/* *************************************************************************************************************************
Copyright (c) 2016 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : paramlist_setparam.i
    Purpose     : 
    Author(s)   : pjudge 
    Created     : 2016-05-27
    Notes       : 
                  &IDX      = index of the the array to use 
                  &ARG-TYPE = ABL datatype, no abbreviation (integer etc)
                  &ARG-VALUE-TYPE = the holder type (derived from IPrimitiveHolder)
                  &PARAM-IDX = the number of the parameter being set in the method arguments
                  &OPER-ARG = a reference to the operation argument in use
                  &PARAM-LIST = the Progress.Lang.ParameterList reference in use
                  &COERCE-TYPE = the ABL primitive/function to turn a INT64 into an INT, say
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
&if '{&SWITCH-VALUE}' eq 'class' &then
    assign arg_arr_{&ARG-TYPE}_{&IDX} = cast({&OPER-ARG}:ArgumentValue, {&ARG-VALUE-TYPE}).
    {&PARAM-LIST}:SetParameter({&PARAM-IDX}, substitute('class &1 extent':u, {&OPER-ARG}:ArgumentType:TypeName), {&OPER-ARG}:IOMode, arg_arr_{&ARG-TYPE}_{&IDX}).
&else
    /* input and input-output arguments will have a value at this point; not so for return and output */
    if valid-object({&OPER-ARG}:ArgumentValue) then
        assign arg_arr_{&ARG-TYPE}_{&IDX} = {&COERCE-TYPE}(cast({&OPER-ARG}:ArgumentValue, {&ARG-VALUE-TYPE}):Value).
    {&PARAM-LIST}:SetParameter({&PARAM-IDX}, substitute('&1 extent':u, {&OPER-ARG}:DataType), {&OPER-ARG}:IOMode, arg_arr_{&ARG-TYPE}_{&IDX}).
&endif
end.