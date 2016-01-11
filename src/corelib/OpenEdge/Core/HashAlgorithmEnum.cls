/************************************************
Copyright (c)  2015 by Progress Software Corporation. All rights reserved.
*************************************************/
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

enum OpenEdge.Core.HashAlgorithmEnum: 
    define enum       /* RSA Message Digest Hash Algorithm, 
                         returns a 16-byte RAW binary message digest value.*/
                      MD5     =  0
                      /*  United States Government Secure Hash Algorithm, 
                          returns a RAW 20-byte binary message digest value.*/
                      SHA-1
                      /*  United States Government Secure Hash Algorithm,
                          returns a RAW 32-byte binary message digest value.*/
                      SHA-256
                      /*  United States Government Secure Hash Algorithm, 
                          returns a RAW 64-byte binary message digest value.*/
                      SHA-512
                      .
end enum.
