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
    Peter Judge, Progress Software [2016]
    Mike Fechner, Consultingwerk [2016]
  ----------------------------------------------------------------------*/
/*------------------------------------------------------------------------
    File        : CommitScopeEnum
    Purpose     :
    Syntax      :
    Description :
    Author(s)   : Peter Judge / Progress Software
    Created     : Sun May 22 19:44:59 CEST 2016
    Notes       :
  ----------------------------------------------------------------------*/

ENUM Ccs.BusinessLogic.CommitScopeEnum:

    DEFINE ENUM /* All records in the dataset in a single tx */
                All

                /* One transaction per table row */
                Row

                /* One transaction for all records in a single table */
                Table

                /* One database transaction per parent row and its child table and all grand-child records.. */
                Nested

                Default = Row
                .
END ENUM .
