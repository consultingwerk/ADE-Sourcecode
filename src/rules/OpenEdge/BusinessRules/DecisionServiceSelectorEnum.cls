/************************************************
Copyright (c)  2013 by Progress Software Corporation. All rights reserved.
*************************************************/
/** ------------------------------------------------------------------------
    File        : DecisionServiceSelectorEnum
    Purpose     : Enumeration of the methods available for decision service selection
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Mon Jun 17 16:17:39 EDT 2013
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.BusinessRules.DecisionServiceSelectorEnum.
using OpenEdge.Lang.EnumMember.

class OpenEdge.BusinessRules.DecisionServiceSelectorEnum final inherits EnumMember:

    define public static property Default as DecisionServiceSelectorEnum no-undo get. private set.
    define public static property Date as DecisionServiceSelectorEnum no-undo get. private set.
    define public static property Version as DecisionServiceSelectorEnum no-undo get. private set.
    
    constructor static DecisionServiceSelectorEnum():
        DecisionServiceSelectorEnum:Default = new DecisionServiceSelectorEnum('Default').
        DecisionServiceSelectorEnum:Date = new DecisionServiceSelectorEnum('Date').
        DecisionServiceSelectorEnum:Version = new DecisionServiceSelectorEnum('Version').
    end constructor.
    
    constructor protected DecisionServiceSelectorEnum(input pcName as character):
        super(pcName).
    end constructor.
    
    method public DecisionServiceSelectorEnum EnumFromName(input pcName as character):
        case pcName:
            when DecisionServiceSelectorEnum:Default:Name then return DecisionServiceSelectorEnum:Default.
            when DecisionServiceSelectorEnum:Date:Name then return DecisionServiceSelectorEnum:Date.
            when DecisionServiceSelectorEnum:Version:Name then return DecisionServiceSelectorEnum:Version.
        end.
    end method.
      
end class.