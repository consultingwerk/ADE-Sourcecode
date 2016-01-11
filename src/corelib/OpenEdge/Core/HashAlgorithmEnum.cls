 /*------------------------------------------------------------------------
    File        : HashAlgorithmEnum
    Purpose     : Enumeration of ABL-supported digest algorithms, from the doc
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Mon Nov 03 15:00:23 EST 2014
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.EnumMember.
using OpenEdge.Core.HashAlgorithmEnum.

class OpenEdge.Core.HashAlgorithmEnum inherits EnumMember: 
    /* RSA Message Digest Hash Algorithm, which returns a 16-byte RAW binary message digest value.*/
    {Consultingwerk/EnumMember.i MD5     0 HashAlgorithmEnum}
    /*  United States Government Secure Hash Algorithm, which returns a RAW 20-byte binary message digest value.*/
    {Consultingwerk/EnumMember.i SHA-1  1 HashAlgorithmEnum}
    /*  United States Government Secure Hash Algorithm, which returns a RAW 32-byte binary message digest value.*/
    {Consultingwerk/EnumMember.i SHA-256  2 HashAlgorithmEnum}
    /*  United States Government Secure Hash Algorithm, which returns a RAW 64-byte binary message digest value.*/
    {Consultingwerk/EnumMember.i SHA-512 3 HashAlgorithmEnum}
    
    constructor protected HashAlgorithmEnum( input piValue as integer, input pcName as character):
        super (input piValue, input pcName).
    end constructor.    

end class.


   
