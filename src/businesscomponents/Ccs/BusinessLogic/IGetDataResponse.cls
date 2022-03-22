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
    File        : IGetDataResponse
    Purpose     : Interface for the response of the getData method of the
                  IBusinessEntiy
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Sun May 22 20:03:46 CEST 2016
    Notes       :
  ----------------------------------------------------------------------*/

INTERFACE Ccs.BusinessLogic.IGetDataResponse:

    /*------------------------------------------------------------------------------
        Purpose: Returns the custom response object
        Notes:   May be used to return further information to the caller. May return
                 the reference to the IGetDataRequest:CustomParameter object
    ------------------------------------------------------------------------------*/
    DEFINE PUBLIC PROPERTY CustomResponse AS Progress.Lang.Object NO-UNDO
    GET.

    /*------------------------------------------------------------------------------
        Purpose: Returns the Table requests
        Notes:
    ------------------------------------------------------------------------------*/
    DEFINE PUBLIC PROPERTY TableResponses AS Ccs.BusinessLogic.IGetDataTableResponse EXTENT NO-UNDO
    GET.

END INTERFACE.
