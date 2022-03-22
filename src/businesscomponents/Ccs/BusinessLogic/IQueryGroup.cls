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
    File        : IQueryGroup
    Purpose     : Interface for a group of Query Entries or Query Groups
                  (nested)
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Mon Jun 06 21:34:50 CEST 2016
    Notes       :
  ----------------------------------------------------------------------*/

INTERFACE Ccs.BusinessLogic.IQueryGroup
    INHERITS Ccs.BusinessLogic.IQueryEntry:

    /*------------------------------------------------------------------------------
        Purpose: Returns the array of query predicates and nested query groups
        Notes:
    ------------------------------------------------------------------------------*/
    DEFINE PUBLIC PROPERTY Entries AS Ccs.BusinessLogic.IQueryEntry EXTENT NO-UNDO
    GET.

END INTERFACE.
