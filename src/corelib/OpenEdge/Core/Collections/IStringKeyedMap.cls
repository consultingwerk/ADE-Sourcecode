/************************************************
Copyright (c)  2014, 2023 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : IStringKeyedMap
    Purpose     : A typed String/Object Map
    Syntax      :
    Description :
    Author(s)   : pjudge
    Created     : Wed Dec 18 13:58:44 EST 2013
    Notes       : * Also contains IMap methods using ABL primitives instead
                    of OpenEdge.Core.String
  ----------------------------------------------------------------------*/

using OpenEdge.Core.String.

{OpenEdge/Core/Collections/typedmapinterface.i
    &Package = OpenEdge.Core.Collections
    &MapType = IStringKeyedMap
    &KeyType = String
    &ValueType = Progress.Lang.Object
    &NoEndInterface = true
}

    /** Adds an entry to the map

        @param character The key value
        @param longchar The value
        @return longchar The value added (may be blank or unknown) */
    method public Progress.Lang.Object Put(input pcKey as character, input poValue as Progress.Lang.Object).

    /** Retrieves the value for a particular key

        @param character The key value
        @return longchar The associated value */
    method public Progress.Lang.Object Get(input pcKey as character).

    /** Removes the value for a particular key

        @param character The key value
        @return longchar The associated value */
    method public Progress.Lang.Object Remove(input pcKey as character).

    /** Indicates whether a map exists for this key

        @param character the key value
        @return logical True if this key exists */
    method public logical ContainsKey(input pcKey as character).

end interface.
