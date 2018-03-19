&if false &then
/* *************************************************************************************************************************
Copyright (c) 2016-2017 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : doh_execute_setparam_array.i
    Purpose     : sets values for an entire data type 
    Author(s)   : 
    Created     : Sun May 29 11:40:23 EDT 2016
    Notes       : &ARG-TYPE     = ABL datatype, no abbreviation (integer etc)
                  &OPER-ARG     = a reference to the operation argument in use
                  &PARAM-LIST   = the Progress.Lang.ParameterList reference in use
                  &SWITCH-VALUE = The underlying 'real' value  
  ----------------------------------------------------------------------*/
&endif
&if defined(OPER-ARG) eq 0 &then
&scoped-define OPER-ARG oOperArg
&endif
&if defined(PARAM-LIST) eq 0 &then
&scoped-define PARAM-LIST oParamList
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
case (arg_arr_idx_{&ARG-TYPE} + 1):   // +1 because the variable starts at 0
    {OpenEdge/Web/DataObject/doh_execute_setparam.i &IDX=01 &ARG-TYPE="{&ARG-TYPE}" &ARG-VALUE-TYPE="{&ARG-VALUE-TYPE}" &PARAM-IDX="{&PARAM-IDX}" &OPER-ARG="{&OPER-ARG}" &PARAM-LIST="{&PARAM-LIST}" &SWITCH-VALUE="{&SWITCH-VALUE}" }
    {OpenEdge/Web/DataObject/doh_execute_setparam.i &IDX=02 &ARG-TYPE="{&ARG-TYPE}" &ARG-VALUE-TYPE="{&ARG-VALUE-TYPE}" &PARAM-IDX="{&PARAM-IDX}" &OPER-ARG="{&OPER-ARG}" &PARAM-LIST="{&PARAM-LIST}" &SWITCH-VALUE="{&SWITCH-VALUE}" }
    {OpenEdge/Web/DataObject/doh_execute_setparam.i &IDX=03 &ARG-TYPE="{&ARG-TYPE}" &ARG-VALUE-TYPE="{&ARG-VALUE-TYPE}" &PARAM-IDX="{&PARAM-IDX}" &OPER-ARG="{&OPER-ARG}" &PARAM-LIST="{&PARAM-LIST}" &SWITCH-VALUE="{&SWITCH-VALUE}" }
    {OpenEdge/Web/DataObject/doh_execute_setparam.i &IDX=04 &ARG-TYPE="{&ARG-TYPE}" &ARG-VALUE-TYPE="{&ARG-VALUE-TYPE}" &PARAM-IDX="{&PARAM-IDX}" &OPER-ARG="{&OPER-ARG}" &PARAM-LIST="{&PARAM-LIST}" &SWITCH-VALUE="{&SWITCH-VALUE}" }
    {OpenEdge/Web/DataObject/doh_execute_setparam.i &IDX=05 &ARG-TYPE="{&ARG-TYPE}" &ARG-VALUE-TYPE="{&ARG-VALUE-TYPE}" &PARAM-IDX="{&PARAM-IDX}" &OPER-ARG="{&OPER-ARG}" &PARAM-LIST="{&PARAM-LIST}" &SWITCH-VALUE="{&SWITCH-VALUE}" }
    {OpenEdge/Web/DataObject/doh_execute_setparam.i &IDX=06 &ARG-TYPE="{&ARG-TYPE}" &ARG-VALUE-TYPE="{&ARG-VALUE-TYPE}" &PARAM-IDX="{&PARAM-IDX}" &OPER-ARG="{&OPER-ARG}" &PARAM-LIST="{&PARAM-LIST}" &SWITCH-VALUE="{&SWITCH-VALUE}" }
    {OpenEdge/Web/DataObject/doh_execute_setparam.i &IDX=07 &ARG-TYPE="{&ARG-TYPE}" &ARG-VALUE-TYPE="{&ARG-VALUE-TYPE}" &PARAM-IDX="{&PARAM-IDX}" &OPER-ARG="{&OPER-ARG}" &PARAM-LIST="{&PARAM-LIST}" &SWITCH-VALUE="{&SWITCH-VALUE}" }
    {OpenEdge/Web/DataObject/doh_execute_setparam.i &IDX=08 &ARG-TYPE="{&ARG-TYPE}" &ARG-VALUE-TYPE="{&ARG-VALUE-TYPE}" &PARAM-IDX="{&PARAM-IDX}" &OPER-ARG="{&OPER-ARG}" &PARAM-LIST="{&PARAM-LIST}" &SWITCH-VALUE="{&SWITCH-VALUE}" }
    {OpenEdge/Web/DataObject/doh_execute_setparam.i &IDX=09 &ARG-TYPE="{&ARG-TYPE}" &ARG-VALUE-TYPE="{&ARG-VALUE-TYPE}" &PARAM-IDX="{&PARAM-IDX}" &OPER-ARG="{&OPER-ARG}" &PARAM-LIST="{&PARAM-LIST}" &SWITCH-VALUE="{&SWITCH-VALUE}" }
    {OpenEdge/Web/DataObject/doh_execute_setparam.i &IDX=10 &ARG-TYPE="{&ARG-TYPE}" &ARG-VALUE-TYPE="{&ARG-VALUE-TYPE}" &PARAM-IDX="{&PARAM-IDX}" &OPER-ARG="{&OPER-ARG}" &PARAM-LIST="{&PARAM-LIST}" &SWITCH-VALUE="{&SWITCH-VALUE}" }
    {OpenEdge/Web/DataObject/doh_execute_setparam.i &IDX=11 &ARG-TYPE="{&ARG-TYPE}" &ARG-VALUE-TYPE="{&ARG-VALUE-TYPE}" &PARAM-IDX="{&PARAM-IDX}" &OPER-ARG="{&OPER-ARG}" &PARAM-LIST="{&PARAM-LIST}" &SWITCH-VALUE="{&SWITCH-VALUE}" }
    {OpenEdge/Web/DataObject/doh_execute_setparam.i &IDX=12 &ARG-TYPE="{&ARG-TYPE}" &ARG-VALUE-TYPE="{&ARG-VALUE-TYPE}" &PARAM-IDX="{&PARAM-IDX}" &OPER-ARG="{&OPER-ARG}" &PARAM-LIST="{&PARAM-LIST}" &SWITCH-VALUE="{&SWITCH-VALUE}" }
    {OpenEdge/Web/DataObject/doh_execute_setparam.i &IDX=13 &ARG-TYPE="{&ARG-TYPE}" &ARG-VALUE-TYPE="{&ARG-VALUE-TYPE}" &PARAM-IDX="{&PARAM-IDX}" &OPER-ARG="{&OPER-ARG}" &PARAM-LIST="{&PARAM-LIST}" &SWITCH-VALUE="{&SWITCH-VALUE}" }
    {OpenEdge/Web/DataObject/doh_execute_setparam.i &IDX=14 &ARG-TYPE="{&ARG-TYPE}" &ARG-VALUE-TYPE="{&ARG-VALUE-TYPE}" &PARAM-IDX="{&PARAM-IDX}" &OPER-ARG="{&OPER-ARG}" &PARAM-LIST="{&PARAM-LIST}" &SWITCH-VALUE="{&SWITCH-VALUE}" }
    {OpenEdge/Web/DataObject/doh_execute_setparam.i &IDX=15 &ARG-TYPE="{&ARG-TYPE}" &ARG-VALUE-TYPE="{&ARG-VALUE-TYPE}" &PARAM-IDX="{&PARAM-IDX}" &OPER-ARG="{&OPER-ARG}" &PARAM-LIST="{&PARAM-LIST}" &SWITCH-VALUE="{&SWITCH-VALUE}" }
    {OpenEdge/Web/DataObject/doh_execute_setparam.i &IDX=16 &ARG-TYPE="{&ARG-TYPE}" &ARG-VALUE-TYPE="{&ARG-VALUE-TYPE}" &PARAM-IDX="{&PARAM-IDX}" &OPER-ARG="{&OPER-ARG}" &PARAM-LIST="{&PARAM-LIST}" &SWITCH-VALUE="{&SWITCH-VALUE}" }
    {OpenEdge/Web/DataObject/doh_execute_setparam.i &IDX=17 &ARG-TYPE="{&ARG-TYPE}" &ARG-VALUE-TYPE="{&ARG-VALUE-TYPE}" &PARAM-IDX="{&PARAM-IDX}" &OPER-ARG="{&OPER-ARG}" &PARAM-LIST="{&PARAM-LIST}" &SWITCH-VALUE="{&SWITCH-VALUE}" }
    {OpenEdge/Web/DataObject/doh_execute_setparam.i &IDX=18 &ARG-TYPE="{&ARG-TYPE}" &ARG-VALUE-TYPE="{&ARG-VALUE-TYPE}" &PARAM-IDX="{&PARAM-IDX}" &OPER-ARG="{&OPER-ARG}" &PARAM-LIST="{&PARAM-LIST}" &SWITCH-VALUE="{&SWITCH-VALUE}" }
    {OpenEdge/Web/DataObject/doh_execute_setparam.i &IDX=19 &ARG-TYPE="{&ARG-TYPE}" &ARG-VALUE-TYPE="{&ARG-VALUE-TYPE}" &PARAM-IDX="{&PARAM-IDX}" &OPER-ARG="{&OPER-ARG}" &PARAM-LIST="{&PARAM-LIST}" &SWITCH-VALUE="{&SWITCH-VALUE}" }
    {OpenEdge/Web/DataObject/doh_execute_setparam.i &IDX=20 &ARG-TYPE="{&ARG-TYPE}" &ARG-VALUE-TYPE="{&ARG-VALUE-TYPE}" &PARAM-IDX="{&PARAM-IDX}" &OPER-ARG="{&OPER-ARG}" &PARAM-LIST="{&PARAM-LIST}" &SWITCH-VALUE="{&SWITCH-VALUE}" }
    {OpenEdge/Web/DataObject/doh_execute_setparam.i &IDX=21 &ARG-TYPE="{&ARG-TYPE}" &ARG-VALUE-TYPE="{&ARG-VALUE-TYPE}" &PARAM-IDX="{&PARAM-IDX}" &OPER-ARG="{&OPER-ARG}" &PARAM-LIST="{&PARAM-LIST}" &SWITCH-VALUE="{&SWITCH-VALUE}" }
    {OpenEdge/Web/DataObject/doh_execute_setparam.i &IDX=22 &ARG-TYPE="{&ARG-TYPE}" &ARG-VALUE-TYPE="{&ARG-VALUE-TYPE}" &PARAM-IDX="{&PARAM-IDX}" &OPER-ARG="{&OPER-ARG}" &PARAM-LIST="{&PARAM-LIST}" &SWITCH-VALUE="{&SWITCH-VALUE}" }
    {OpenEdge/Web/DataObject/doh_execute_setparam.i &IDX=23 &ARG-TYPE="{&ARG-TYPE}" &ARG-VALUE-TYPE="{&ARG-VALUE-TYPE}" &PARAM-IDX="{&PARAM-IDX}" &OPER-ARG="{&OPER-ARG}" &PARAM-LIST="{&PARAM-LIST}" &SWITCH-VALUE="{&SWITCH-VALUE}" }
    {OpenEdge/Web/DataObject/doh_execute_setparam.i &IDX=24 &ARG-TYPE="{&ARG-TYPE}" &ARG-VALUE-TYPE="{&ARG-VALUE-TYPE}" &PARAM-IDX="{&PARAM-IDX}" &OPER-ARG="{&OPER-ARG}" &PARAM-LIST="{&PARAM-LIST}" &SWITCH-VALUE="{&SWITCH-VALUE}" }
    {OpenEdge/Web/DataObject/doh_execute_setparam.i &IDX=25 &ARG-TYPE="{&ARG-TYPE}" &ARG-VALUE-TYPE="{&ARG-VALUE-TYPE}" &PARAM-IDX="{&PARAM-IDX}" &OPER-ARG="{&OPER-ARG}" &PARAM-LIST="{&PARAM-LIST}" &SWITCH-VALUE="{&SWITCH-VALUE}" }
    {OpenEdge/Web/DataObject/doh_execute_setparam.i &IDX=26 &ARG-TYPE="{&ARG-TYPE}" &ARG-VALUE-TYPE="{&ARG-VALUE-TYPE}" &PARAM-IDX="{&PARAM-IDX}" &OPER-ARG="{&OPER-ARG}" &PARAM-LIST="{&PARAM-LIST}" &SWITCH-VALUE="{&SWITCH-VALUE}" }
    {OpenEdge/Web/DataObject/doh_execute_setparam.i &IDX=27 &ARG-TYPE="{&ARG-TYPE}" &ARG-VALUE-TYPE="{&ARG-VALUE-TYPE}" &PARAM-IDX="{&PARAM-IDX}" &OPER-ARG="{&OPER-ARG}" &PARAM-LIST="{&PARAM-LIST}" &SWITCH-VALUE="{&SWITCH-VALUE}" }
    {OpenEdge/Web/DataObject/doh_execute_setparam.i &IDX=28 &ARG-TYPE="{&ARG-TYPE}" &ARG-VALUE-TYPE="{&ARG-VALUE-TYPE}" &PARAM-IDX="{&PARAM-IDX}" &OPER-ARG="{&OPER-ARG}" &PARAM-LIST="{&PARAM-LIST}" &SWITCH-VALUE="{&SWITCH-VALUE}" }
    {OpenEdge/Web/DataObject/doh_execute_setparam.i &IDX=29 &ARG-TYPE="{&ARG-TYPE}" &ARG-VALUE-TYPE="{&ARG-VALUE-TYPE}" &PARAM-IDX="{&PARAM-IDX}" &OPER-ARG="{&OPER-ARG}" &PARAM-LIST="{&PARAM-LIST}" &SWITCH-VALUE="{&SWITCH-VALUE}" }
    {OpenEdge/Web/DataObject/doh_execute_setparam.i &IDX=30 &ARG-TYPE="{&ARG-TYPE}" &ARG-VALUE-TYPE="{&ARG-VALUE-TYPE}" &PARAM-IDX="{&PARAM-IDX}" &OPER-ARG="{&OPER-ARG}" &PARAM-LIST="{&PARAM-LIST}" &SWITCH-VALUE="{&SWITCH-VALUE}" }
    {OpenEdge/Web/DataObject/doh_execute_setparam.i &IDX=31 &ARG-TYPE="{&ARG-TYPE}" &ARG-VALUE-TYPE="{&ARG-VALUE-TYPE}" &PARAM-IDX="{&PARAM-IDX}" &OPER-ARG="{&OPER-ARG}" &PARAM-LIST="{&PARAM-LIST}" &SWITCH-VALUE="{&SWITCH-VALUE}" }
    {OpenEdge/Web/DataObject/doh_execute_setparam.i &IDX=32 &ARG-TYPE="{&ARG-TYPE}" &ARG-VALUE-TYPE="{&ARG-VALUE-TYPE}" &PARAM-IDX="{&PARAM-IDX}" &OPER-ARG="{&OPER-ARG}" &PARAM-LIST="{&PARAM-LIST}" &SWITCH-VALUE="{&SWITCH-VALUE}" }
    otherwise undo, throw new OpenEdge.Core.System.ArgumentError('Too many values specified for array argument', {&OPER-ARG}:Parameter:ABLType).
end case.   /* array: index to use */
            