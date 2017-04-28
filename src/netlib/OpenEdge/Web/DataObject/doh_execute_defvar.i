&if false &then
/************************************************
Copyright (c) 2016 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : paramlist_arg_def.i
    Purpose     : Include to create many variables 'easily' per ABL datatype
    Author(s)   : pjudge
    Created     : 2016-05-23
    Notes       : * Adds 3 sets of variables for the data type
                    2 for return values (scalar and array)
                    1 array-of-type for scalar parameters
                    1 variable to keep track of the current extent of the above in use  
                    32 arrays-of-type for array parameters
    * Defaults to a max of 32. &NUM-VARS can be used to specify fewer 
  ----------------------------------------------------------------------*/
&endif  
&if defined(NUM-VARS) eq 0 &then 
&scoped-define NUM-VARS 32 
&endif
&if defined(NAME-SUFFIX) eq 0 &then 
&scoped-define NAME-SUFFIX {&DATA-TYPE} 
&endif
/* return value variables */
define variable retval_scalar_{&NAME-SUFFIX} as {&DATA-TYPE}        no-undo.
define variable retval_arr_{&NAME-SUFFIX}    as {&DATA-TYPE} extent no-undo.
/* parameters variables, for scalar/single values. this is an array because we can use a single 
   variable for ALL a method's input values of the same type */
define variable arg_scalar_{&NAME-SUFFIX}     as {&DATA-TYPE} extent no-undo.
/* last-used value */
define variable arg_scalar_idx_{&NAME-SUFFIX} as integer no-undo.
define variable arg_arr_idx_{&NAME-SUFFIX} as integer no-undo.
/* for parameters that are arrays */
&if {&NUM-VARS} ge  1 &then define variable arg_arr_{&NAME-SUFFIX}_01 as {&DATA-TYPE} extent no-undo. &endif
&if {&NUM-VARS} ge  2 &then define variable arg_arr_{&NAME-SUFFIX}_02 as {&DATA-TYPE} extent no-undo. &endif 
&if {&NUM-VARS} ge  3 &then define variable arg_arr_{&NAME-SUFFIX}_03 as {&DATA-TYPE} extent no-undo. &endif 
&if {&NUM-VARS} ge  4 &then define variable arg_arr_{&NAME-SUFFIX}_04 as {&DATA-TYPE} extent no-undo. &endif 
&if {&NUM-VARS} ge  5 &then define variable arg_arr_{&NAME-SUFFIX}_05 as {&DATA-TYPE} extent no-undo. &endif 
&if {&NUM-VARS} ge  6 &then define variable arg_arr_{&NAME-SUFFIX}_06 as {&DATA-TYPE} extent no-undo. &endif 
&if {&NUM-VARS} ge  7 &then define variable arg_arr_{&NAME-SUFFIX}_07 as {&DATA-TYPE} extent no-undo. &endif 
&if {&NUM-VARS} ge  8 &then define variable arg_arr_{&NAME-SUFFIX}_08 as {&DATA-TYPE} extent no-undo. &endif 
&if {&NUM-VARS} ge  9 &then define variable arg_arr_{&NAME-SUFFIX}_09 as {&DATA-TYPE} extent no-undo. &endif 
&if {&NUM-VARS} ge 10 &then define variable arg_arr_{&NAME-SUFFIX}_10 as {&DATA-TYPE} extent no-undo. &endif 
&if {&NUM-VARS} ge 11 &then define variable arg_arr_{&NAME-SUFFIX}_11 as {&DATA-TYPE} extent no-undo. &endif 
&if {&NUM-VARS} ge 12 &then define variable arg_arr_{&NAME-SUFFIX}_12 as {&DATA-TYPE} extent no-undo. &endif 
&if {&NUM-VARS} ge 13 &then define variable arg_arr_{&NAME-SUFFIX}_13 as {&DATA-TYPE} extent no-undo. &endif 
&if {&NUM-VARS} ge 14 &then define variable arg_arr_{&NAME-SUFFIX}_14 as {&DATA-TYPE} extent no-undo. &endif 
&if {&NUM-VARS} ge 15 &then define variable arg_arr_{&NAME-SUFFIX}_15 as {&DATA-TYPE} extent no-undo. &endif 
&if {&NUM-VARS} ge 16 &then define variable arg_arr_{&NAME-SUFFIX}_16 as {&DATA-TYPE} extent no-undo. &endif 
&if {&NUM-VARS} ge 17 &then define variable arg_arr_{&NAME-SUFFIX}_17 as {&DATA-TYPE} extent no-undo. &endif 
&if {&NUM-VARS} ge 18 &then define variable arg_arr_{&NAME-SUFFIX}_18 as {&DATA-TYPE} extent no-undo. &endif 
&if {&NUM-VARS} ge 19 &then define variable arg_arr_{&NAME-SUFFIX}_19 as {&DATA-TYPE} extent no-undo. &endif 
&if {&NUM-VARS} ge 20 &then define variable arg_arr_{&NAME-SUFFIX}_20 as {&DATA-TYPE} extent no-undo. &endif 
&if {&NUM-VARS} ge 21 &then define variable arg_arr_{&NAME-SUFFIX}_21 as {&DATA-TYPE} extent no-undo. &endif 
&if {&NUM-VARS} ge 22 &then define variable arg_arr_{&NAME-SUFFIX}_22 as {&DATA-TYPE} extent no-undo. &endif 
&if {&NUM-VARS} ge 23 &then define variable arg_arr_{&NAME-SUFFIX}_23 as {&DATA-TYPE} extent no-undo. &endif 
&if {&NUM-VARS} ge 24 &then define variable arg_arr_{&NAME-SUFFIX}_24 as {&DATA-TYPE} extent no-undo. &endif 
&if {&NUM-VARS} ge 25 &then define variable arg_arr_{&NAME-SUFFIX}_25 as {&DATA-TYPE} extent no-undo. &endif 
&if {&NUM-VARS} ge 26 &then define variable arg_arr_{&NAME-SUFFIX}_26 as {&DATA-TYPE} extent no-undo. &endif 
&if {&NUM-VARS} ge 27 &then define variable arg_arr_{&NAME-SUFFIX}_27 as {&DATA-TYPE} extent no-undo. &endif 
&if {&NUM-VARS} ge 28 &then define variable arg_arr_{&NAME-SUFFIX}_28 as {&DATA-TYPE} extent no-undo. &endif 
&if {&NUM-VARS} ge 29 &then define variable arg_arr_{&NAME-SUFFIX}_29 as {&DATA-TYPE} extent no-undo. &endif 
&if {&NUM-VARS} ge 30 &then define variable arg_arr_{&NAME-SUFFIX}_30 as {&DATA-TYPE} extent no-undo. &endif 
&if {&NUM-VARS} ge 31 &then define variable arg_arr_{&NAME-SUFFIX}_31 as {&DATA-TYPE} extent no-undo. &endif 
&if {&NUM-VARS} ge 32 &then define variable arg_arr_{&NAME-SUFFIX}_32 as {&DATA-TYPE} extent no-undo. &endif 
