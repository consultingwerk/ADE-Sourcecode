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
    File        : IGetDataTableResponse
    Purpose     : Contains table specific response of the IGetDataResponse
                  interface, part of the response object received by the
                  getData method of the IBusinessEntity
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Sun May 22 19:58:02 CEST 2016
    Notes       :
  ----------------------------------------------------------------------*/

INTERFACE Ccs.BusinessLogic.IGetDataTableResponse:

    /*------------------------------------------------------------------------------
        Purpose: Returns the paging context to be passed back to the business
                 entity when requesting the next set
        Notes:   Used for Paging. This value typically consists of record identifiers
                 (e.g. DATA-SOURCE ROWID retrieved by the RESTART-ROWID function
                 or other data required by the Business Entity to build the next
                 set of data in a follow up call).
    ------------------------------------------------------------------------------*/
    DEFINE PUBLIC PROPERTY NextPagingContext AS CHARACTER NO-UNDO
    GET.

    /*------------------------------------------------------------------------------
        Purpose: Returns the paging context to be passed back to the business
                 entity when requesting the previous set
        Notes:   Used for Paging. This value typically consists of record identifiers
                 (e.g. DATA-SOURCE ROWID retrieved by the RESTART-ROWID function
                 or other data required by the Business Entity to build the previous
                 set of data in a follow up call).
    ------------------------------------------------------------------------------*/
    DEFINE PUBLIC PROPERTY PreviousPagingContext AS CHARACTER NO-UNDO
    GET.

    /*------------------------------------------------------------------------------
        Purpose: Returns the name of the ProDataset Table
        Notes:   Identifies the table this IGetDataTableResponse belongs to
    ------------------------------------------------------------------------------*/
    DEFINE PUBLIC PROPERTY TableName AS CHARACTER NO-UNDO
    GET.

END INTERFACE.
