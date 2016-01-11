/************************************************
Copyright (c)  2015 by Progress Software Corporation. All rights reserved.
*************************************************/
 /*------------------------------------------------------------------------
    File        : FormatMaskHelper
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Apr 09 14:57:20 EDT 2015
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.ServerConnection.FormatMaskHelper.
using OpenEdge.Core.ServerConnection.FormatMaskEnum.

class OpenEdge.Core.ServerConnection.FormatMaskHelper:
    
    /** Returns an actual format mask for an enumeration
        
        @param FormatMaskEnum The format mask type to return the mask for
        @return character The format mask */
    method static public character GetMask(input poFormatMask as FormatMaskEnum):
        Assert:NotNull(poFormatMask, 'Format mask').
        
        case poFormatMask:
            when FormatMaskEnum:None                then return ' &1 &2 ':u.
            when FormatMaskEnum:DashSpace           then return ' -&1 &2':u.
            when FormatMaskEnum:DoubleDashEquals    then return ' --&1=&2':u.
            when FormatMaskEnum:DoubleDashSpace     then return ' --&1 &2':u.
            when FormatMaskEnum:NameEquals          then return ' &1=&2':u.
            /* has no mask */
            when FormatMaskEnum:Custom then return ' ':u.
            /* NEVER ADD AN OTHERWISE so that we can make sure that this class always
               reflects all of the members of the FormatMaskEnum type */
        end case.
    end method.
    
end class.