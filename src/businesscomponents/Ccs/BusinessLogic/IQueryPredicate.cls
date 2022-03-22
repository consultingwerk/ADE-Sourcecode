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
    File        : IQueryPredicate
    Purpose     : Interface describing a query predicate
    Syntax      :
    Description : Query predicates provide an abstractred way of expressing
                  queries to a businness entity table.
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Fri May 27 09:50:04 CEST 2016
    Notes       :
  ----------------------------------------------------------------------*/

INTERFACE Ccs.BusinessLogic.IQueryPredicate
    INHERITS Ccs.BusinessLogic.IQueryEntry:

    /*------------------------------------------------------------------------------
        Purpose: Returns the name of the field for this query predicate
        Notes:
    ------------------------------------------------------------------------------*/
    DEFINE PUBLIC PROPERTY FieldName AS CHARACTER NO-UNDO
    GET.

    /*------------------------------------------------------------------------------
        Purpose: Returns the operator for this query predicate
        Notes:
    ------------------------------------------------------------------------------*/
    DEFINE PUBLIC PROPERTY Operator AS Ccs.BusinessLogic.QueryOperatorEnum NO-UNDO
    GET.

    /*------------------------------------------------------------------------------
        Purpose: Returns a single value for this query predicate
        Notes:
    ------------------------------------------------------------------------------*/
    DEFINE PUBLIC PROPERTY Value AS Ccs.Common.Support.IPrimitiveHolder NO-UNDO
    GET.

    /*------------------------------------------------------------------------------
        Purpose: Returns a list of values for this query predicate
        Notes:   Used by the InRange and InList operators
    ------------------------------------------------------------------------------*/
    DEFINE PUBLIC PROPERTY Values AS Ccs.Common.Support.IPrimitiveArrayHolder NO-UNDO
    GET.

END INTERFACE.
