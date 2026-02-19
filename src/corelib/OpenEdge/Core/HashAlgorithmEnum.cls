/************************************************
Copyright (c)  2015,2025 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : HashAlgorithmEnum
    Purpose     : Enumeration of ABL-supported hash algorithms, from the
                  documentation for the message-digest() function
    Description :
    Author(s)   : pjudge
    Created     : Mon Nov 03 15:00:23 EST 2014
    Notes       :
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

enum OpenEdge.Core.HashAlgorithmEnum:
    define enum
        /**
         * This is provided for backward compatibility only and should not be used in new development. Disallowed in FIPS mode.
         * RSA Message Digest Hash Algorithm, which returns a 16-byte RAW binary message digest value (DEPRECATED).
         */
        MD5 = 0
        /**
         * This is provided for backward compatibility only and should not be used in new development. Disallowed in FIPS mode.
         * United States Government Secure Hash Algorithm, which returns a RAW 20-byte binary message digest value.
         */
        SHA-1
        /**
         * This is provided for backward compatibility only and should not be used in new development.
         * United States Government Secure Hash Algorithm, which returns a RAW 32-byte binary message digest value.
         */
        SHA-256
        /**
         * United States Government Secure Hash Algorithm, which returns a RAW 64-byte binary message digest value.
         */
        SHA-512
        /**
         * United States Government HMAC (Hash-based Message Authentication Code) algorithm, which returns a RAW 20-byte binary message digest value.
         */
        HMAC-SHA-1
        /**
         * This is provided for backward compatibility only and should not be used in new development.
         * United States Government HMAC (Hash-based Message Authentication Code) algorithm, which returns a RAW 32-byte binary message digest value.
         */
        HMAC-SHA-256
        /**
         * United States Government HMAC (Hash-based Message Authentication Code) algorithm, which returns a RAW 48-byte binary message digest value.
         */
        HMAC-SHA-384
        /**
         * United States Government HMAC (Hash-based Message Authentication Code) algorithm, which returns a RAW 64-byte binary message digest value.
         */
        HMAC-SHA-512
        .
end enum.
