/*
    Copyright © 2021 Progress Software Corporation and/or its subsidiaries or affiliates. All Rights Reserved.
*/

/**
    This class holds common constants related to TimeStamp class. These have been
    extracted to allow TimeStamp class to participate in object re-use cache.
*/
class OpenEdge.Core.TimeStampConstants:
    
    /**
        This constant holds unix epoch as "01-01-1970 00:00:00.000+00:00"
    */
    define public static property UnixEpoch as datetime-tz initial "01-01-1970 00:00:00.000+00:00":u no-undo public get. private set.

end class.