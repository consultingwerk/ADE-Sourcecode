&if false &then
/* *************************************************************************************************************************
Copyright (c) 2016-2017 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : doh_execute_invoke.i
    Purpose     : Calls the method, and sets the return value into the Arg
    Author(s)   : pjudge 
    Created     : 2016-05-27
    Notes       : Arguments
                    &RETURN-TYPE = the name of the Progress.Reflect.DataType enum 
                                      of the return type. Defaults to &VAR-DATA-TYPE
                    &METHOD = instance of Progress.Reflect.Method
                    &VAR-DATA-TYPE = the name of the ABL data type
                    &ENTITY-INSTANCE = the instance of the business entity/logic
                    &PARAM-LIST = the ParameterList object instace
                    &OPER-ARG= arguments for this operation
  ----------------------------------------------------------------------*/
&endif
&if defined(OPER-ARG) eq 0 &then
&scoped-define OPER-ARG oOperArg
&endif
&if defined(METHOD) eq 0 &then
&scoped-define METHOD oMethod 
&endif
&if defined(ENTITY-INSTANCE) eq 0 &then
&scoped-define ENTITY-INSTANCE poEntity
&endif
&if defined(PARAM-LIST) eq 0 &then
&scoped-define PARAM-LIST oParamList
&endif
&if defined(RETURN-TYPE) eq 0 &then
&scoped-define RETURN-TYPE {&VAR-DATA-TYPE}
&endif
&if defined(VALUE-WRITER}) eq 0 &then
&scoped-define VALUE-WRITER oValueWriter
&endif
when Progress.Reflect.DataType:{&RETURN-TYPE} then 
case {&METHOD}:ReturnExtent:
    when 0 then
    do:
        assign execTime[1] = now
               retval_scalar_{&VAR-DATA-TYPE} = {&METHOD}:Invoke({&ENTITY-INSTANCE}, {&PARAM-LIST})
               execTime[2] = now.
        if valid-object({&VALUE-WRITER}) then
            {&VALUE-WRITER}:Write(retval_scalar_{&VAR-DATA-TYPE}).
    end.
    otherwise
    do:
        if {&METHOD}:ReturnExtent eq ? then
            assign execTime[1] = now 
                   retval_arr_{&VAR-DATA-TYPE} = {&METHOD}:Invoke({&ENTITY-INSTANCE}, {&PARAM-LIST})
                   execTime[2] = now.
        else
            assign extent(retval_arr_{&VAR-DATA-TYPE}) = {&METHOD}:ReturnExtent
                   execTime[1] = now
                   retval_arr_{&VAR-DATA-TYPE} = {&METHOD}:Invoke({&ENTITY-INSTANCE}, {&PARAM-LIST})
                   execTime[2] = now.
        if valid-object({&VALUE-WRITER}) then
            {&VALUE-WRITER}:Write(retval_arr_{&VAR-DATA-TYPE}).
    end.
end case.
