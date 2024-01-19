/************************************************
Copyright (c)  2014, 2023 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : IStringStringMap
    Purpose     : A typed String/String Map
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
    &MapType = IStringStringMap
    &KeyType = String
    &ValueType = String
    &NoEndInterface = true
}

    /** Adds an entry to the map

        @param character The key value
        @param longchar The value
        @return longchar The value added (may be blank or unknown) */
    method public longchar Put(input pcKey as character, input pcValue as longchar).

    /** Retrieves the value for a particular key

        @param character The key value
        @return longchar The associated value */
    method public longchar Get(input pcKey as character).

    /** Removes the value for a particular key

        @param character The key value
        @return longchar The associated value */
    method public longchar Remove(input pcKey as character).

    /** Indicates whether a map exists for this key

        @param character the key value
        @return logical True if this key exists */
    method public logical ContainsKey(input pcKey as character).

    /** Indicates whether there is at least one value represented
        by the parameter in the map.

        @param longchar The value
        @return logical True if there is at least one entry with this value */
    method public logical ContainsValue(input pcValue as character).

end interface.
