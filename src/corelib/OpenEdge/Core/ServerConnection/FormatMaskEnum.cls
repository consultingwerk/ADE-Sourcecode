/************************************************
Copyright (c)  2013 by Progress Software Corporation. All rights reserved.
*************************************************/
/** ------------------------------------------------------------------------
    File        : FormatMaskEnum
    Purpose     : Contains simple, substitutable masks, capable of being used with the basic
                  OpenEdge.Core.ServerConnection.ConnectionParameters class
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Thu Feb 28 15:25:46 EST 2013
    Notes       : More specialised masks, that will require specialised IConnectionParameters 
                  implementations. And example of this is the OpenEdge.Core.ServerConnection.WebServiceConnectionParameters
                  class.
  ---------------------------------------------------------------------- */
block-level on error undo, throw.

using OpenEdge.Core.ServerConnection.FormatMaskEnum.
using OpenEdge.Core.EnumMember.

class OpenEdge.Core.ServerConnection.FormatMaskEnum serializable inherits EnumMember:       
    define public static property Default as FormatMaskEnum no-undo get. private set.
    define public static property None as FormatMaskEnum no-undo get. private set.
    define public static property ABLConnect as FormatMaskEnum no-undo get. private set.
    define public static property DashSpace as FormatMaskEnum no-undo get. private set.
    define public static property DoubleDashEquals as FormatMaskEnum no-undo get. private set.
    define public static property DoubleDashSpace as FormatMaskEnum no-undo get. private set.
    define public static property NameEquals as FormatMaskEnum no-undo get. private set.
    define public static property Custom as FormatMaskEnum no-undo get. private set.
    
    constructor static FormatMaskEnum():
        /* simple, substitutable masks, capable of being used with the basic 
           OpenEdge.Core.ServerConnection.ConnectionParameters class */
        FormatMaskEnum:None = new FormatMaskEnum(' &1 &2 ').
        FormatMaskEnum:DashSpace = new FormatMaskEnum(' -&1 &2').
        FormatMaskEnum:ABLConnect = FormatMaskEnum:DashSpace.
        FormatMaskEnum:DoubleDashEquals = new FormatMaskEnum(' --&1=&2').
        FormatMaskEnum:DoubleDashSpace = new FormatMaskEnum(' --&1 &2').
        FormatMaskEnum:NameEquals = new FormatMaskEnum(' &1=&2').
        /* has no mask */
        FormatMaskEnum:Custom = new FormatMaskEnum(' ').
        
        /* standard format for ABL server connections */
        FormatMaskEnum:Default = FormatMaskEnum:ABLConnect.
    end constructor.
    
	constructor protected FormatMaskEnum ( input pcName as character ):
        super(pcName).
	end constructor.
	
end class.
