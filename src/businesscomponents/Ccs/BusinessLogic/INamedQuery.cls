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
    File        : INamedQuery
    Purpose     : Interface for parameters describing named queries
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Fri May 27 10:03:02 CEST 2016
    Notes       :
  ----------------------------------------------------------------------*/

INTERFACE Ccs.BusinessLogic.INamedQuery:

    /*------------------------------------------------------------------------------
        Purpose: Returns the name of the named query
        Notes:
    ------------------------------------------------------------------------------*/
    DEFINE PUBLIC PROPERTY Name AS CHARACTER NO-UNDO
    GET.

    /*------------------------------------------------------------------------------
        Purpose: Returns the array of (optional) parameters of the named query
        Notes:   Each Named Query Parameter consists of an identifier (name) and a value
                 (primitive holder) or values (primitive array holder)
    ------------------------------------------------------------------------------*/
    DEFINE PUBLIC PROPERTY Parameters AS Ccs.BusinessLogic.INamedQueryParameter EXTENT NO-UNDO
    GET.

END INTERFACE.
