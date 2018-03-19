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
    File        : IGetTableResultCountResponse
    Purpose     : Contains table specific response of the IGetResultCountResponse
                  interface, part of the response object received by the
                  getResultCount method of the IBusinessEntity
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Fri May 27 09:37:59 CEST 2016
    Notes       :
  ----------------------------------------------------------------------*/

INTERFACE Ccs.BusinessLogic.IGetTableResultCountResponse:

    /*------------------------------------------------------------------------------
        Purpose: Returns is the result is exact (TRUE) or Guessed or Cached (FALSE)
        Notes:
    ------------------------------------------------------------------------------*/
    DEFINE PUBLIC PROPERTY Exact AS LOGICAL NO-UNDO
    GET.

    /*------------------------------------------------------------------------------
        Purpose: Returns the number of results for this table
        Notes:
    ------------------------------------------------------------------------------*/
    DEFINE PUBLIC PROPERTY NumResults AS INT64 NO-UNDO
    GET.

    /*------------------------------------------------------------------------------
        Purpose: Returns the name of the table this result belongs to
        Notes:
    ------------------------------------------------------------------------------*/
    DEFINE PUBLIC PROPERTY TableName AS CHARACTER NO-UNDO
    GET.

END INTERFACE.
