&if false &then
/* *************************************************************************************************************************
Copyright (c) 2016-2017 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : doh_execute_setargvalues.i
    Purpose     : 
    Author(s)   : pjudge 
    Created     : 2016-05-27
    Notes       : Arguments
                    &OPER-ARG = the operation argument for this param 
                    &DATA-TYPE = the name of the ABL data type 
                    &VALUE-WRITER = a reference to the value holder/writer
                    &SWITCH-VALUE = the parameter data type
  ----------------------------------------------------------------------*/
&endif
&if defined(OPER-ARG) eq 0 &then
&scoped-define OPER-ARG oOperArg
&endif
&if defined(VALUE-WRITER}) eq 0 &then
&scoped-define VALUE-WRITER oValueWriter
&endif
&if defined(SWITCH-VALUE) eq 0 &then
&scoped-define SWITCH-VALUE {&DATA-TYPE}
&endif
when '{&SWITCH-VALUE}':u then
    if {&OPER-ARG}:Parameter:IsArray then 
    case {&OPER-ARG}:ArgumentIndex:
        when 01 then {&VALUE-WRITER}:Write(arg_arr_{&DATA-TYPE}_01).
        when 02 then {&VALUE-WRITER}:Write(arg_arr_{&DATA-TYPE}_02).
        when 03 then {&VALUE-WRITER}:Write(arg_arr_{&DATA-TYPE}_03).
        when 04 then {&VALUE-WRITER}:Write(arg_arr_{&DATA-TYPE}_04).
        when 05 then {&VALUE-WRITER}:Write(arg_arr_{&DATA-TYPE}_05).
        when 06 then {&VALUE-WRITER}:Write(arg_arr_{&DATA-TYPE}_06).
        when 07 then {&VALUE-WRITER}:Write(arg_arr_{&DATA-TYPE}_07).
        when 08 then {&VALUE-WRITER}:Write(arg_arr_{&DATA-TYPE}_08).
        when 09 then {&VALUE-WRITER}:Write(arg_arr_{&DATA-TYPE}_09).
        when 10 then {&VALUE-WRITER}:Write(arg_arr_{&DATA-TYPE}_10).
        when 11 then {&VALUE-WRITER}:Write(arg_arr_{&DATA-TYPE}_11).
        when 12 then {&VALUE-WRITER}:Write(arg_arr_{&DATA-TYPE}_12).
        when 13 then {&VALUE-WRITER}:Write(arg_arr_{&DATA-TYPE}_13).
        when 14 then {&VALUE-WRITER}:Write(arg_arr_{&DATA-TYPE}_14).
        when 15 then {&VALUE-WRITER}:Write(arg_arr_{&DATA-TYPE}_15).
        when 16 then {&VALUE-WRITER}:Write(arg_arr_{&DATA-TYPE}_16).
        when 17 then {&VALUE-WRITER}:Write(arg_arr_{&DATA-TYPE}_17).
        when 18 then {&VALUE-WRITER}:Write(arg_arr_{&DATA-TYPE}_18).
        when 19 then {&VALUE-WRITER}:Write(arg_arr_{&DATA-TYPE}_19).
        when 20 then {&VALUE-WRITER}:Write(arg_arr_{&DATA-TYPE}_20).
        when 21 then {&VALUE-WRITER}:Write(arg_arr_{&DATA-TYPE}_21).
        when 22 then {&VALUE-WRITER}:Write(arg_arr_{&DATA-TYPE}_22).
        when 23 then {&VALUE-WRITER}:Write(arg_arr_{&DATA-TYPE}_23).
        when 24 then {&VALUE-WRITER}:Write(arg_arr_{&DATA-TYPE}_24).
        when 25 then {&VALUE-WRITER}:Write(arg_arr_{&DATA-TYPE}_25).
        when 26 then {&VALUE-WRITER}:Write(arg_arr_{&DATA-TYPE}_26).
        when 27 then {&VALUE-WRITER}:Write(arg_arr_{&DATA-TYPE}_27).
        when 28 then {&VALUE-WRITER}:Write(arg_arr_{&DATA-TYPE}_28).
        when 29 then {&VALUE-WRITER}:Write(arg_arr_{&DATA-TYPE}_29).
        when 20 then {&VALUE-WRITER}:Write(arg_arr_{&DATA-TYPE}_30).
        when 31 then {&VALUE-WRITER}:Write(arg_arr_{&DATA-TYPE}_31).
        when 32 then {&VALUE-WRITER}:Write(arg_arr_{&DATA-TYPE}_32).
        otherwise undo, throw new OpenEdge.Core.System.ArgumentError('Too many values specified', {&OPER-ARG}:Parameter:ABLType).
    end case.   /* ArgumentIndex */
    else
        {&VALUE-WRITER}:Write(arg_scalar_{&DATA-TYPE}[{&OPER-ARG}:ArgumentIndex]).