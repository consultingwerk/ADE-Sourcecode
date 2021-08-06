/*************************************************************************
Copyright (c) 2021 by Progress Software Corporation. All rights reserved.
**************************************************************************/
/*------------------------------------------------------------------------
    File        : EncodingTypeEnum
    Purpose     : Enumeration of supported (via ABL function) encodings
    Syntax      :
    Description :
    Author(s)   : pjudge
    Created     : 2020-12-09
    Notes       : * Encodings from doc at https://docs.progress.com/bundle/openedge-security-keys-and-certificates/page/genpassword.html
  ----------------------------------------------------------------------*/
enum OpenEdge.Core.EncodingTypeEnum :
    define enum oech1
                odeb0
                nopr0
                
                ae1b1
                ae1b2
                ae1b3
                ae1b4
                ae1b5
                ae1b6
                ae1b7
                ae1b8
                ae1b9
                
                ae1h1
                ae1h2
                ae1h3
                ae1h4
                ae1h5
                ae1h6
                ae1h7
                ae1h8
                ae1h9
                
                ae2b1
                ae2b2
                ae2b3
                ae2b4
                ae2b5
                ae2b6
                ae2b7
                ae2b8
                ae2b9
                
                ae2h1
                ae2h2
                ae2h3
                ae2h4
                ae2h5
                ae2h6
                ae2h7
                ae2h8
                ae2h9
                
                oepb1
                oepb2
                oepb3
                oepb4
                oepb5
                oepb6
                oepb7
                oepb8
                oepb9
                
                Default = odeb0.
end enum.
