CLASS OpenEdge.DataAdmin.Util.RowidGenerator:
    DEFINE PRIVATE STATIC VAR partId AS CHAR INIT ?.  
    DEFINE PRIVATE STATIC VAR startRowid AS CHAR.
    DEFINE PRIVATE STATIC VAR intStartRowid AS INT64.
    DEFINE PRIVATE STATIC VAR currRowid AS CHAR.
    DEFINE PRIVATE STATIC VAR intCurrRowid AS INT64.
    DEFINE PRIVATE STATIC VAR intMaxRowid AS INT64.
    DEFINE PRIVATE STATIC VAR partitions AS CHAR EXTENT.
    DEFINE PRIVATE STATIC VAR currPartitionIx AS INT.

    DEFINE PRIVATE STATIC VAR powersOf16 AS INT64 EXTENT 15. 

    DEFINE PRIVATE STATIC BUFFER bFile FOR _File.
    DEFINE PRIVATE STATIC BUFFER bPartitionPolicy FOR _Partition-Policy.
    DEFINE PRIVATE STATIC BUFFER bPartitionPolicyDetail FOR _Partition-Policy-Detail.

    CONSTRUCTOR STATIC RowidGenerator():
        /* Initialize the powersOf16 array */
        DEFINE VAR ix AS INT.
        DO ix = 1 TO 15:
            powersOf16[ix] = EXP(16, 16 - ix).
        END.
    END.

    /* Call this once for each table you want to run through.
       Then call GetNextRowid repeatedly until it returns ?.
       
       startId: The smallest Rowid to start at.  If ?, this will start
            at 1.
       maxId: Max rowid that will be returned 
              (within one partition if partitioned)
       partitionId:
            If the table is not partitioned, it doesn't matter what
            partitionId is.
            ?: If table is partitioned, this will scan all partitions
                for this table.
            A specific partition Id: only scan this partition.
    */            
    METHOD PUBLIC STATIC VOID TableStart(
                    tableName AS CHAR,
                    startId AS INT64,
                    maxId AS INT64,
                    partitionId AS INT):

        DEFINE VAR cnt AS INT INIT 0.
        DEFINE VAR ix AS INT INIT 1.
        DEFINE VAR sawPidZero AS LOGICAL.
        DEFINE VAR usePid AS LOGICAL.

        IF startId < 0 OR startId = ? THEN DO: 
            MESSAGE "You must supply a valid minimum rowid value."
                VIEW-AS ALERT-BOX ERROR. 
            RETURN.
        END.

        IF maxId <= 0 OR maxId = ? THEN DO: 
            MESSAGE "You must supply a valid maximum rowid value."
                VIEW-AS ALERT-BOX ERROR.
            RETURN.
        END.

        IF startId > maxId THEN DO: 
            MESSAGE "The startId must be less than or equal to the maxId."
                VIEW-AS ALERT-BOX ERROR. 
            RETURN.
        END.

        intMaxRowid = maxId.
        currPartitionIx = 1.

        IF startId = ? THEN DO:
            intStartRowid = 0.
            currRowid = "0x0000000000000000".
            intCurrRowid = 0.
        END.
        ELSE DO:
            intStartRowid = startId - 1.
            startRowid = "0x" + ConvertToHex(intStartRowid, 16).
            currRowid = startRowid.
            intCurrRowid = intStartRowid.
        END.

        FIND bFile WHERE _File-name = tableName.
        IF bFile._File-attributes[3] THEN DO: /* Partitioned */
            IF partitionId <> ? THEN
                partId = ConvertToHex(partitionId, 4).
            ELSE DO:
                partId = "". /* Scan all partitions */
                FOR EACH bPartitionPolicy WHERE 
                        bPartitionPolicy._Object-number = bFile._file-num.

                    /* Make an array big enoubh to hold all the partitionId 
                       #s to scan */
                    sawPidZero = FALSE.
                    FOR EACH bPartitionPolicyDetail OF bPartitionPolicy:
                        usePid = TRUE.
                        IF bPartitionPolicyDetail._Partition-Id = 0 THEN 
                        DO:
                            IF sawPidZero THEN
                                /* Don't use pId 0 more than once */
                                usePid = FALSE.
                            ELSE
                                sawPidZero = TRUE.
                        END.
                        IF usePid THEN 
                            cnt = cnt + 1.
                    END.

                    IF EXTENT(partitions) <> ? THEN
                        /* Have to reset before we can change size */
                        EXTENT(partitions) = ?.
                    EXTENT(partitions) = cnt.

                    /* This is normally 1 to cnt, but I don't want to
                       rely on that - in case the user makes a mistake 
                       and deletes one in the middle. */
                    sawPidZero = FALSE.
                    FOR EACH bPartitionPolicyDetail OF bPartitionPolicy:
                        usePid = TRUE.
                        IF bPartitionPolicyDetail._Partition-Id = 0 THEN 
                        DO:
                            IF sawPidZero THEN
                                usePid = FALSE.
                            ELSE
                                sawPidZero = TRUE.
                        END.
                        IF usePid THEN DO:
                            partitions[ix] = ConvertToHex(_Partition-id, 4).
                            ix = ix + 1.                    
                        END.
                    END.
                END.
            END.
        END.
        ELSE 
            partId = ?. /* Not partitioned */
    END.

    /* Return next ROWID, or ? if we've exceeded the max ROWID */
    METHOD PUBLIC STATIC ROWID GetNextRowid():

        DEFINE VAR strPartitionId AS CHAR.

        intCurrRowid = intCurrRowid + 1.
        IF intCurrRowid > intMaxRowid THEN DO:
            IF partId = "" THEN DO:
                /* We're scanning partitions.  We've scanned all rowid
                   for the current partitionId, so set up for the 
                   next one. */
                IF currPartitionIx = EXTENT(partitions) THEN
                    RETURN ?. /* We've done them all */
                ELSE DO:
                    /* Start again for the next partition */
                    currRowid = startRowid.
                    intCurrRowid = intStartRowid.
                    currPartitionIx = currPartitionIx + 1.
                END.
            END.
            ELSE DO: 
                /* Given one partition Id and we're done */
                RETURN ?.
            END.
        END.
         
        /* Increment starting with the right-most digit.  We will
           add one string-wise, rather than add one to the integer 
           value and convert to a hex string each time. It should be
           much faster. */
        IF IncrementDigit(INPUT-OUTPUT currRowid, 18) = FALSE THEN
            RETURN ?.  

        IF partId <> ? THEN DO: 
            IF partId <> "" THEN DO:
                /* If given a specific partition Id, use that. */
                strPartitionId = partId.
            END.
            ELSE DO:
                /* Use the current partition Id from our array. */
                strPartitionId = partitions[currPartitionIx].
            END.

            RETURN TO-ROWID(currRowid + strPartitionId).
        END.

        /* Non-partitioned table */
        RETURN TO-ROWID(currRowid).
    END.

    /* This increments the strDigit at the digitIx position 
       (updating the currRowid string) and does a carry if necessary  
       by recursing into here. 
       Returns: FALSE if we've exceeded the biggest possible #
                      This should never happen if we're fed a valid
                      maxId value.
                TRUE otherwise
    */
    METHOD PRIVATE STATIC LOGICAL IncrementDigit(
                INPUT-OUTPUT hexString AS char, 
                digitIx AS INT):

        DEFINE VAR strDigit AS CHAR.
        DEFINE VAR intDigit AS INT.        

        strDigit = SUBSTR(hexString, digitIx, 1).

        CASE strDigit:
            WHEN '9' THEN
                strDigit = 'a'.
            WHEN 'a' THEN
                strDigit = 'b'.
            WHEN 'b' THEN
                strDigit = 'c'.
            WHEN 'c' THEN
                strDigit = 'd'.
            WHEN 'd' THEN
                strDigit = 'e'.
            WHEN 'e' THEN
                strDigit = 'f'.
            WHEN 'f' THEN DO:
                strDigit = '0'.
            END.
            OTHERWISE DO:
                intDigit = INTEGER(strDigit).
                intDigit = intDigit + 1.
                strDigit = STRING(intDigit).
            END.
        END.

        SUBSTR(hexString, digitIx, 1) = strDigit.

        IF strDigit = '0' THEN DO:
            /* Carry the one into the next column */
            digitIx = digitIx - 1.
            IF digitIx = 2 THEN 
                RETURN FALSE. /* Overflow */
            IncrementDigit(INPUT-OUTPUT hexString, digitIx).
        END.
        RETURN TRUE.
    END.

    /* Convert the given integer value to a 4 character hex string. 
       Return the Hex string.
    */
    METHOD PRIVATE STATIC CHAR ConvertToHex(intVal AS INT64, numDigits AS INT):

        DEFINE VAR powerOf16 AS INT64.
        DEFINE VAR intDigit AS INT.
        DEFINE VAR strDigit AS CHAR.
        DEFINE VAR digitix AS INT.
        DEFINE VAR hexString AS CHAR INIT "0000000000000000".

        IF numDigits = 4 THEN
            digitIx = 13. /* 13 - 16 */
        ELSE
            digitIx = 1. /* 1 - 16 */
        DO WHILE digitIx <= 16:
            IF digitIx < 16 THEN DO:
                powerOf16 = powersOf16[digitIx].
                intDigit = TRUNCATE(intVal / powerOf16, 0).
            END.
            ELSE
                intDigit = intVal.

            IF intDigit > 0 THEN DO:
                CASE intDigit:
                    WHEN 10 THEN
                        strDigit = 'a'.
                    WHEN 11 THEN
                        strDigit = 'b'.
                    WHEN 12 THEN
                        strDigit = 'c'.
                    WHEN 13 THEN
                        strDigit = 'd'.
                    WHEN 14 THEN
                        strDigit = 'e'.
                    WHEN 15 THEN
                        strDigit = 'f'.
                    OTHERWISE
                        strDigit = STRING(intDigit).
                END CASE.
                SUBSTR(hexString, digitIx, 1) = STRING(strDigit).

                IF digitIx < 16 THEN
                    intVal = intVal - (intDigit * powerOf16).
            END.
            digitIx = digitIx + 1.
        END.

        IF numDigits = 4 THEN
            RETURN SUBSTR(hexString, 13, 4).
        ELSE
            RETURN hexString.
    END.
END.
