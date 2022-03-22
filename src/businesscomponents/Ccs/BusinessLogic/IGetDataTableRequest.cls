/*------------------------------------------------------------------------
  This Software is licensed by Progress Software Corporation (licensor)
  under the Progress Software Common Component Specification Project
  Release License Agreement available at
  https://community.progress.com/products/directions/common_component/p/releaselicenseagreement

  The Interface definition is part of the Common Component Specification [CCSBE01]. The
  file is considered as a Specification Implementation Condition as described
  in section 2.1.1.1: If Licensor has made Specification Implementation
  Conditions available as of the date Licensee completes its Independent
  Implementation, then Licensee must, prior to making any claim that its
  Independent Implementation complies with the Specification, ensure that
  the Independent Implementation satisfies all of the Specification
  Implementation Conditions. If Licensor subsequently makes available or
  updates, from time to time, the Specification Implementation Conditions,
  then Licensee will verify that its Independent Implementation satisfies the
  latest version of the Specification Implementation Conditions within ninety
  (90) days following Licensor's release thereof.

  Contributors:
    Mike Fechner, Consultingwerk [2016]
  ----------------------------------------------------------------------*/
/*------------------------------------------------------------------------
    File        : IGetDataTableRequest
    Purpose     : Contains table specific request arguments of the
                  IGetDataRequest interface, part of the request object send
                  to the getData method of the IBusinessEntity
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Sun May 22 19:58:02 CEST 2016
    Notes       :
  ----------------------------------------------------------------------*/

INTERFACE Ccs.BusinessLogic.IGetDataTableRequest:

    /*------------------------------------------------------------------------------
        Purpose: Returns the paging context
        Notes:   Used for Paging. This value typically consists of record identifiers
                 (e.g. DATA-SOURCE ROWID retrieved by the RESTART-ROWID function of
                 the previous call into IBusinessEntity:GetData or other data required
                 by the Business Entity to build the next set of data).
                 The value passed in is the value of the NextPagingContext property
                 of the IGetDataTableResponse for the table
    ------------------------------------------------------------------------------*/
    DEFINE PUBLIC PROPERTY PagingContext AS CHARACTER NO-UNDO
    GET.

    /*------------------------------------------------------------------------------
        Purpose: Returns the number of records requested by the caller of the
                 Business Entity getData method
        Notes:   Used for Paging. When the value is 0, the business entity is expected
                 to return all (remaining) records. When the value is ? the business
                 entity is expected to return a reasonable default number of records
                 to the caller. Negative values indicate paging in backwards direction
                 is requested.
    ------------------------------------------------------------------------------*/
    DEFINE PUBLIC PROPERTY NumRecords AS INT64 NO-UNDO
    GET.

    /*------------------------------------------------------------------------------
        Purpose: Returns the abstract query defintion for this request
        Notes:   Typically used as an alternative to the QueryString
    ------------------------------------------------------------------------------*/
    DEFINE PUBLIC PROPERTY QueryDefinition AS Ccs.BusinessLogic.IQueryDefinition NO-UNDO
    GET.

    /*------------------------------------------------------------------------------
        Purpose: Returns the Query String for this table
        Notes:   Query Strings must be expressed using the fields of the temp-table.
                 It's the task of the Business Entity or Data Access class to translate
                 the Query String into the form understood by the actual DBMS in case
                 field names require mapping etc.
                 Query Strings must be provided in the following format
                 CustNum = 42
                 CustNum = 42 AND OrderStatus = “Ordered”
    ------------------------------------------------------------------------------*/
    DEFINE PUBLIC PROPERTY QueryString AS CHARACTER NO-UNDO
    GET.

    /*------------------------------------------------------------------------------
        Purpose: Returns the number of records to skip
        Notes:   Used for Paging. Typically the value of (page# - 1) * NumRecords is
                 passed in when requesting a certain page of result records
    ------------------------------------------------------------------------------*/
    DEFINE PUBLIC PROPERTY Skip AS INT64 NO-UNDO
    GET.

    /*------------------------------------------------------------------------------
        Purpose: Returns the name of the ProDataset Table
        Notes:   Identifies the table this IGetDataTableRequest belongs to
    ------------------------------------------------------------------------------*/
    DEFINE PUBLIC PROPERTY TableName AS CHARACTER NO-UNDO
    GET.

END INTERFACE.
