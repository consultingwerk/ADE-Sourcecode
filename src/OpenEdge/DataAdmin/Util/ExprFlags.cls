USING PROGRESS.Lang.*.
BLOCK-LEVEL ON ERROR UNDO, THROW.

ENUM OpenEdge.DataAdmin.Util.ExprFlags FLAGS:
    DEFINE ENUM NO_FLAGS =    0x00000000     /* No Flags */
                RE_EXTR  =    0x00000001     /* Re-Extracted */
                REPLSWP  =    0x00000002     /* Swap Replacement */
                REPLCHG  =    0x00000004     /* SubExpr Replacement */
                REPLSUB  =    0x00000008     /* TextSub Replacement */
                REPLCSV  =    0x00000010     /* CSV Text Replacement */
                OREPLSWP =    0x00000020     /* Swap Overwrite */
                OREPLCHG =    0x00000040     /* SubExpr Overwrite */
                OREPLSUB =    0x00000080     /* TextSub Overwrite */
                OREPLCSV =    0x00000100     /* CSV Text Overwrite */
                DFLTPUB  =    0x00000200     /* Default PUBLIC */
                RDFLTPUB =    0x00000400     /* Revoke Blank PUBLIC */
                MDFLTPUB =    0x00000800     /* Mixed Dflt/Rvk PUBLIC */
                CREPLCSV =    0x00001000     /* CSV Command Replacement */
                OCREPLCSV =   0x00002000     /* CSV Command Overwrite */

                ALL       =   0x00003FFF

                ACT-4000 =    0x00004000
                ACT-8000 =    0x00008000
                ACT-10000 =   0x00010000
                ACT-20000 =   0x00020000
                ACT-40000 =   0x00040000
                ACT-80000 =   0x00080000
                HIGHMARK  =   0x80000000.
END ENUM.


