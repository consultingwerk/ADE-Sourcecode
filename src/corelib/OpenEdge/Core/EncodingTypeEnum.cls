/*************************************************************************
Copyright (c) 2021,2025 by Progress Software Corporation. All rights reserved.
**************************************************************************/
/*------------------------------------------------------------------------
    File        : EncodingTypeEnum
    Purpose     : Enumeration of supported (via ABL function) encoding types
    Description :
    Author(s)   : pjudge
    Created     : 2020-12-09
    Notes       : Encoding types should agree with documentation of the genpasswd
                  utility located in the OpenEdge documentation hub at:
  https://docs.progress.com/bundle/openedge-security-keys-and-certificates/page/genpassword.html
------------------------------------------------------------------------*/

enum OpenEdge.Core.EncodingTypeEnum:
    define enum nopr0 // Indicates no encryption of the accompanying string will take place, not valid for use with encryption methods!

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

                oeph0
                oeph1
                oeph2
                oeph3
                oeph4
                oeph5
                oeph6
                oeph7
                oeph8
                oeph9
                .
end enum.
