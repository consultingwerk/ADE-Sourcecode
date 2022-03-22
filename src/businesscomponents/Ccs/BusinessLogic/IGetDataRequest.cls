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
    File        : IGetDataRequest
    Purpose     : Inteface for the request object passed to the getData
                  method of the IBusinessEntity
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Sun May 22 19:58:18 CEST 2016
    Notes       :
  ----------------------------------------------------------------------*/

INTERFACE Ccs.BusinessLogic.IGetDataRequest:

    /*------------------------------------------------------------------------------
        Purpose: Returns the custom parameter object
        Notes:   May be used to provide further instructions or information to the
                 Business Entity while executing the GetData request
    ------------------------------------------------------------------------------*/
    DEFINE PUBLIC PROPERTY CustomParameter AS Progress.Lang.Object NO-UNDO
    GET.

    /*------------------------------------------------------------------------------
        Purpose: Returns the named query instance
        Notes:
    ------------------------------------------------------------------------------*/
    DEFINE PUBLIC PROPERTY NamedQuery AS Ccs.BusinessLogic.INamedQuery NO-UNDO
    GET.

    /*------------------------------------------------------------------------------
        Purpose: Returns the Table requests
        Notes:
    ------------------------------------------------------------------------------*/
    DEFINE PUBLIC PROPERTY TableRequests AS Ccs.BusinessLogic.IGetDataTableRequest EXTENT NO-UNDO
    GET.

END INTERFACE.
