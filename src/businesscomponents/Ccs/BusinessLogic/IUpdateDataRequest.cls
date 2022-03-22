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
    File        : IUpdateDataRequest
    Purpose     : Interface for the parameter object to the updateData method
                  of the IBusinessEntity interface
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Sun May 22 19:43:01 CEST 2016
    Notes       :
  ----------------------------------------------------------------------*/

INTERFACE Ccs.BusinessLogic.IUpdateDataRequest:

    /*------------------------------------------------------------------------------
        Purpose: Returns the CommitScope to be used by the updateData method
        Notes:   The value is considered as a recommendation as the Business Entity
                 may ignore this setting and use a different commit scope based on
                 the business logic requirements
    ------------------------------------------------------------------------------*/
    DEFINE PUBLIC PROPERTY CommitScope AS Ccs.BusinessLogic.CommitScopeEnum NO-UNDO
    GET.

    /*------------------------------------------------------------------------------
        Purpose: Returns a custom request object
        Notes:
    ------------------------------------------------------------------------------*/
    DEFINE PUBLIC PROPERTY CustomRequest AS Progress.Lang.Object NO-UNDO
    GET.

END INTERFACE.
