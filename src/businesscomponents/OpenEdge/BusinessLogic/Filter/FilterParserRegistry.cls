/* *************************************************************************************************************************
Copyright (c) 2018 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : FilterParserRegistry
    Purpose     : Contains a registry of objects used to parse JSON or other (typically)
                  string-based filters and create strongly-typed objects
    Description : 
    Author(s)   : pjudge
    Created     : 2018-08-05
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.BusinessLogic.Filter.AblFilterParser.
using OpenEdge.BusinessLogic.Filter.FilterParser.
using OpenEdge.BusinessLogic.Filter.FilterParserRegistry.
using OpenEdge.BusinessLogic.Filter.JfpFilterParser.
using OpenEdge.BusinessLogic.Filter.KendoFilterParser.
using OpenEdge.Core.Util.BuilderRegistry.

class OpenEdge.BusinessLogic.Filter.FilterParserRegistry:
     
    /** Registry for mapping build types to their implementations */
    define static public property Registry as BuilderRegistry no-undo
        get():
            define variable oRegistry as BuilderRegistry no-undo.
            if not valid-object(FilterParserRegistry:Registry) then
            do:
                assign oRegistry = new BuilderRegistry(get-class(FilterParser)).
                InitializeRegistry(oRegistry).
                assign FilterParserRegistry:Registry = oRegistry.
            end.
            return FilterParserRegistry:Registry.
        end get.
        private set.
    
    /** Adds initial values into the registry
        
        @param BuilderRegistry The registry to populate */
    method static private void InitializeRegistry(input poRegistry as BuilderRegistry):
        // Register known parsers
        poRegistry:Put('WHERE':u,        get-class(AblFilterParser)).
        poRegistry:Put('ABL':u,          get-class(AblFilterParser)).
        
        poRegistry:Put('ablFilter':u,    get-class(JfpFilterParser)).
        poRegistry:Put('JFP':u,          get-class(JfpFilterParser)).
        
        poRegistry:Put('field':u,        get-class(KendoFilterParser)).
        poRegistry:Put('KENDO':u,        get-class(KendoFilterParser)).
    end method.
    
end class.