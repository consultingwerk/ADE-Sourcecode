/************************************************
Copyright (c) 2022 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : LeakReportParameters
    Purpose     : Parameters for a leak check report
    Syntax      :
    Description :
    Author(s)   : pjudge
    Created     : 2022-02-17
    Notes       :
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.Util.LeakReportFilterTypeEnum.

class OpenEdge.Core.Util.LeakReportParameters
serializable:

    /* The filter type: GROUP, SESSION, TYPE, NONE */
    define public property FilterType as LeakReportFilterTypeEnum no-undo
        get.
        set(input pValue as LeakReportFilterTypeEnum):
            Assert:NotNull(pValue, 'Filter type').
            assign this-object:FilterType = pValue.
        end set.

    /* The value to filter on */
    define public property Filter as character no-undo
        get.
        set.

    /* If TRUE then only prints objects that are leaks. Leaks are defined as objects that have a CREATE and no related DELETE.
       If FALSE the all data is shown.
       Default is TRUE. */
    define public property OnlyReportLeaks as logical no-undo
        initial true
        get.
        set.

    /* If TRUE then related objects are printed in a nested manner. This report prints all records with a CREATE action
       and finds their related records.
       If FALSE then all records are simply printed. This may include records that have a DELETE but no parent CREATE.
       Default is TRUE. */
    define public property NestRelatedObjects as logical no-undo
        initial true
        get.
        set.

    /* If TRUE the individual object data is reported. If FALSE then it is not.
       Default is TRUE. */
    define public property PrintDetailData as logical no-undo
        initial true
        get.
        set.

    /* If TRUE the header data is reported. If FALSE then it is not.
       Default is TRUE. */
    define public property PrintHeaderData as logical no-undo
        initial true
        get.
        set.

    /* Default constructor */
    constructor public LeakReportParameters():
        assign this-object:FilterType = LeakReportFilterTypeEnum:Default.
    end constructor.

end class.