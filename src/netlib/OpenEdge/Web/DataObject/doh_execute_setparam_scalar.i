&if false &then
/*------------------------------------------------------------------------
    File        : doh_execute_setparam_scalar.i
    Purpose     : sets values for an entire data type 
    Author(s)   : 
    Created     : Sun May 29 11:40:23 EDT 2016
    Notes       : &SWTICH-TYPE = the name of the ABL type used for the case
                  &ARG-TYPE = ABL datatype, no abbreviation (integer etc)
                  &ARG-VALUE-TYPE = the holder type (derived from IPrimitiveHolder)
                  &OPER-ARG = a reference to the operation argument in use
                  &PARAM-LIST = the Progress.Lang.ParameterList reference in use
                  &COERCE-TYPE = the ABL primitive/function to turn a INT64 into an INT, say
                  &PARAM-IDX = the number of the parameter being set in the method arguments
  ----------------------------------------------------------------------*/
&endif
&if defined(OPER-ARG) eq 0 &then
&scoped-define OPER-ARG oOperArg
&endif
&if defined(PARAM-LIST) eq 0 &then
&scoped-define PARAM-LIST oParamList
&endif
&if defined(SWITCH-VALUE) eq 0 &then
&scoped-define SWITCH-VALUE {&ARG-TYPE}
&endif
&if defined(PARAM-IDX) eq 0 &then
&scoped-define PARAM-IDX lbArg.ParamIndex
&endif
when '{&SWITCH-VALUE}':u then
do:
    /* eh, what can you do */
    if arg_scalar_idx_{&ARG-TYPE} eq 0 then
        assign extent(arg_scalar_{&ARG-TYPE}) = {&OPER-ARG}:Operation:Parameters:Size.
    assign arg_scalar_idx_{&ARG-TYPE} = arg_scalar_idx_{&ARG-TYPE} + 1
           {&OPER-ARG}:ArgumentIndex  = arg_scalar_idx_{&ARG-TYPE}
           .
    /* input and input-output arguments will have a value at this point; not so for return and output */
&if '{&SWITCH-VALUE}' eq 'class' &then
    assign arg_scalar_{&ARG-TYPE}[arg_scalar_idx_{&ARG-TYPE}] = {&OPER-ARG}:ArgumentValue.
    {&PARAM-LIST}:SetParameter({&PARAM-IDX}, substitute('class &1':u, {&OPER-ARG}:ArgumentType:TypeName), {&OPER-ARG}:IOMode, arg_scalar_{&ARG-TYPE}[{&OPER-ARG}:ArgumentIndex]).
&else
    if valid-object({&OPER-ARG}:ArgumentValue) then
        assign arg_scalar_{&ARG-TYPE}[arg_scalar_idx_{&ARG-TYPE}] = {&COERCE-TYPE}(cast({&OPER-ARG}:ArgumentValue, {&ARG-VALUE-TYPE}):Value).
    {&PARAM-LIST}:SetParameter({&PARAM-IDX}, {&OPER-ARG}:DataType, {&OPER-ARG}:IOMode, arg_scalar_{&ARG-TYPE}[{&OPER-ARG}:ArgumentIndex]).
&endif
end.
