
/*------------------------------------------------------------------------
    File        : statussummary.i
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : rkumar
    Created     : Tue Mar 20 17:27:48 IST 2012
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */


/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */
define protected temp-table ttStatusSummary no-undo serialize-name "summary" {1}
    field TaskName           as character format "x(30)" label "TaskName" serialize-name "taskName"
    field LogTime               as datetime-tz serialize-name "logTime"
    field StartTime          as datetime-tz serialize-name "startTime"
    field EndTime            as datetime-tz serialize-name "endTime"
    field NumSharedTables    as integer   serialize-name "numSharedTables"
    field NumTenantTables    as integer   serialize-name "numTenantTables"
    field NumGroupTables     as integer   serialize-name "numGroupTables"
    field NumProcessedSharedTables    as integer   serialize-name "numProcessedSharedTables"
    field NumProcessedTenantTables    as integer   serialize-name "numProcessedTenantTables"
    field NumProcessedGroupTables     as integer   serialize-name "numProcessedGroupTables"
    field NoLobs              as logical      serialize-name "noLobs"
    field AnyError            as logical      serialize-name "anyError"
    field ErrorMessage        as character    serialize-name "errorMessage"
    field IsComplete          as logical      serialize-name "isComplete"
    
    index idxtask as primary unique TaskName. 