/************************************************
Copyright (c)  2013 by Progress Software Corporation. All rights reserved.
*************************************************/
/** ------------------------------------------------------------------------
    File        : OpenEdge/BusinessRules/ttRulesMessage.i
    Purpose     : Contains schema definition of messages temp-table returned by
                  the Corticon Decision Service class OpenEdge.BusinessRules.DecisionService. 
    Syntax      :
    Description : 
    @author pjudge 
    Created     : Fri Mar 01 14:24:29 EST 2013
    Notes       : * Separated into an include so that client code (business logic)
                    can statically query the data.
  ----------------------------------------------------------------------*/
define temp-table RulesMessage no-undo
    field Severity      as character  /* Value matches to one of OpenEdge.BusinessRules.SeverityEnum */
    field MessageText   as character  /* Message text returned by service */
    field TableName     as character  /* Entity/table that this message is associated with. */
    field DataKeyField  as character  /* Field that contains the value of the DataKeyValue  */
    field DataKeyValue  as character  /* String value of the associated (response data) temp-table record's unique identifier. Typically a ROWID */
    
    index idx1 as primary TableName DataKeyValue  /* there may be multiple messages assocated with a single record */
    index idx2 Severity
    .
    
/** EOF **/