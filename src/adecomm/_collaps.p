/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

  File: _collaps.p

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: Greg O'Connor

  Created: 05/12/93 - 12:17 pm


-----------------------------------------------------------------------------*/
DEFINE INPUT         PARAMETER whList       AS widget-handle NO-UNDO.
DEFINE INPUT         PARAMETER cTemp        AS CHARACTER NO-UNDO.

  DEFINE VARIABLE cArrayList   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cArrayEntry  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lArray       AS LOGICAL   NO-UNDO INIT FALSE.
  DEFINE VARIABLE lMatch       AS LOGICAL   NO-UNDO INIT FALSE.
  DEFINE VARIABLE lOk          AS LOGICAL   NO-UNDO INIT FALSE.
  DEFINE VARIABLE cMatch       AS CHARACTER NO-UNDO INIT FALSE.
  DEFINE VARIABLE cMatchNext   AS CHARACTER NO-UNDO INIT FALSE.
  DEFINE VARIABLE cName        AS CHARACTER NO-UNDO.
  Define VARIABLE cTempOrg     AS CHARACTER NO-UNDO.
  Define VARIABLE j            AS INTEGER   NO-UNDO.  /* loop index */
  Define VARIABLE i            AS INTEGER   NO-UNDO.  /* loop index */
  Define VARIABLE iPos         AS INTEGER   NO-UNDO.  /* loop index */
  Define VARIABLE k            AS INTEGER   NO-UNDO.  /* loop index */
  Define VARIABLE icurrent     AS INTEGER   NO-UNDO.  /* loop index */
  Define VARIABLE iHigh        AS INTEGER   NO-UNDO.  
  Define VARIABLE iLow         AS INTEGER   NO-UNDO.  
  Define VARIABLE iHighNext    AS INTEGER   NO-UNDO.  
  Define VARIABLE iLowNext     AS INTEGER   NO-UNDO.  
  Define VARIABLE iListLen     AS INTEGER   NO-UNDO.

  ASSIGN cTempOrg = cTemp.

  IF cTemp MATCHES ("*[*]*") THEN 
    ASSIGN cArrayEntry = ENTRY(2,cTemp,'[':u)
           cArrayEntry = RIGHT-TRIM(cArrayEntry,"]":u)
           cTemp       = ENTRY(1,cTemp,'[':u)
           lArray      = TRUE.
  /*  
  ** This code assumes that the list on the Left side is in
  ** aplhabetical order and will insert or add accordingly
  */
  DO j = 1 TO NUM-ENTRIES(whList:LIST-ITEMS,whList:DELIMITER):
    cName = ENTRY(j,whList:LIST-ITEMS,whList:DELIMITER).

    IF (lArray = TRUE) AND cName MATCHES ("*[*]*":u) THEN
      ASSIGN cArrayList = ENTRY(2,cName,'[':u)
             cArrayList = RIGHT-TRIM(cArrayList,"]":u)
             cName      = ENTRY(1,cName,'[':u)
             iListLen   = NUM-ENTRIES(cArrayList).	
    /*
    ** If it is an array and the names match the add the index in to
    ** the existing list.
    */
    IF (lArray = TRUE) AND (cTemp = cName) THEN DO:

      ASSIGN lMatch   = FALSE
             cMatch   = ENTRY (1, cArrayList, ' ':u)
             iListLen = NUM-ENTRIES (cArrayList, ' ':u).

      DO k = 1 to iListLen:
        ASSIGN cMatch = ENTRY (k, cArrayList, ' ')
               iHigh  = INTEGER (ENTRY (NUM-ENTRIES (cMatch, '-'), cMatch, '-'))
               iLow   = INTEGER (ENTRY (1, cMatch, '-')).
        /*
        ** Check here for adding a number that will extend a sequence.
		** [1-4] andding 5 => [1-5] or
		** [2-4] andding 1 => [1-5] or
		** [2-4] andding 6 => [2-4,6] 
        */ 
        IF iHigh > INTEGER (cArrayEntry) THEN DO:
          IF NUM-ENTRIES (cMatch, '-') = 2 AND
             iHigh + 1 = INTEGER (cArrayEntry) THEN 
            ENTRY (k, cArrayList, ' ') = STRING (iLow) + '-' + cArrayEntry.
          ELSE IF NUM-ENTRIES (cMatch, '-') = 2 AND
             iLow - 1 = INTEGER (cArrayEntry) THEN 
            ENTRY (k, cArrayList, ' ') = cArrayEntry + '-' + STRING (iHigh).
		  ELSE
            ENTRY (k, cArrayList, ' ') = cArrayEntry + " " + ENTRY (k, cArrayList, ' ').
          LEAVE.
        END.  /* If iHigh > INTEGER */
      END.  /* do k = 1 to iListLen */
  
/*      message  'first' ihigh cArrayList  view-as alert-box error buttons Ok. */

      /* NOT ADDED ABOVE SO...
      ** Check here for adding a number that will extend a sequence.
	  ** [1-4] andding 5 => [1-5] or
	  ** [2-4] andding 1 => [1-5] or
	  ** [2-4] andding 6 => [2-4,6]    */ 
      IF k > iListLen THEN 
        IF NUM-ENTRIES (cMatch, '-') = 2 AND
           iHigh + 1 = INTEGER (cArrayEntry) THEN 
            ENTRY (iListLen, cArrayList, ' ') = STRING (iLow) + '-' + cArrayEntry.
        ELSE IF NUM-ENTRIES (cMatch, '-') = 2 AND
           iLow - 1 = INTEGER (cArrayEntry) THEN 
            ENTRY (iListLen, cArrayList, ' ') = cArrayEntry + '-' + STRING (iHigh).
 		ELSE
          cArrayList = cArrayList + " " + cArrayEntry.

      /* Remove and extra , if we collapsed some where  */
      cArrayList =  TRIM (REPLACE (cArrayList, '  ', ' '), ' ').
      DO WHILE INDEX(cArrayList, '  ') > 0:
        cArrayList = REPLACE (cArrayList, '  ', ' ').
      END.

/*      message  'first' cArrayList  view-as alert-box error buttons Ok. */

      ASSIGN cMatch   = ENTRY (1, cArrayList, ' ')
             iCurrent = INTEGER (ENTRY (NUM-ENTRIES (cMatch, '-'), cMatch, '-'))
             iListLen = NUM-ENTRIES (cArrayList, ' ') - 1.

      DO k = 1 TO iListLen:
        cMatch = ENTRY (k + 1, cArrayList, ' ').
/*      message  'colapse2 ' iCurrent INTEGER (ENTRY (1, cMatch, '-')) lMatch skip cArrayList
                  view-as alert-box error buttons Ok.	   */

        /* Check for consecutive entries to collapse.
           ** [1,2,3] => [1-3]                    */      
        IF ((iCurrent + 1) = INTEGER (ENTRY (1, cMatch, '-'))) THEN DO:
          IF lMatch THEN
            ASSIGN ENTRY (iPos, cArrayList, ' ')  =  ENTRY (iPos, cArrayList, ' ') + '-' +
                                                         ENTRY (k + 1,  cArrayList, ' ') 
                   ENTRY (k,  cArrayList, ' ')     = ''
                   ENTRY (k + 1,  cArrayList, ' ') = ''.

          /* If not a match the set for next time around and save position.  */
          IF NOT lMatch THEN
            ASSIGN lMatch = TRUE
                   iPos   = k.

          iCurrent = iCurrent + 1.
        END. /* consecutive entries */
        ELSE /* Reset match */
          ASSIGN iCurrent = INTEGER (ENTRY (NUM-ENTRIES (cMatch, '-'), cMatch, '-')) 
                 lMatch   = FALSE.
      END.  /* k = 1 TO iListLen */

      /* Remove and extra , if we collapsed some where  */
      cArrayList =  TRIM (REPLACE (cArrayList, '  ', ' ')).
      DO WHILE INDEX(cArrayList, '  ') > 0:
        cArrayList = REPLACE (cArrayList, '  ', ' ').
      END.

      ASSIGN iListLen   = NUM-ENTRIES (cArrayList, ' ').

/*      message  'middle' cArrayList iListLen view-as alert-box error buttons Ok.  */

      DO k = 1 to iListLen:
        ASSIGN cMatch = ENTRY (k, cArrayList, ' ')
               iHigh  = INTEGER (ENTRY (NUM-ENTRIES (cMatch, '-'), cMatch, '-'))
               iLow   = INTEGER (ENTRY (1, cMatch, '-')).

/*      message iListLen cMatch k skip cArrayList iHigh  INTEGER (cArrayEntry)    view-as alert-box error buttons Ok. */
        /* Check here for adding a number that will extend a sequence.
		** [1-4-9] => [1-9]     */ 
        IF NUM-ENTRIES (cMatch, '-') > 2 THEN DO:
          ENTRY (k, cArrayList, ' ') = STRING (iLow) + '-' + STRING (iHigh).
          LEAVE.
        END.  /* If more than 2 entries */
      END.  /* Do k = 1 TO iListLen */
  
      /* Remove and extra - if we collapsed some where  */
      DO WHILE INDEX(cArrayList,"--":U) > 0:
        cArrayList = REPLACE (cArrayList, '--', '-').
      END.

      /* Remove and extra , if we collapsed some where	  */
      cArrayList =  TRIM (REPLACE (cArrayList, '  ', ' ')).
      DO WHILE INDEX(cArrayList,'  ') > 0:
        cArrayList = REPLACE (cArrayList, '  ', ' ').
      END.

      ASSIGN iListLen   = NUM-ENTRIES (cArrayList, ' ') - 1.

/*    message  'last' cArrayList  view-as alert-box error buttons Ok.  */

      DO k = 1 to iListLen:
        ASSIGN cMatchNext = ENTRY (k + 1, cArrayList, ' ')
               iHighNext  = INTEGER (ENTRY (NUM-ENTRIES (cMatchNext, '-'), cMatchNext, '-'))
               iLowNext   = INTEGER (ENTRY (1, cMatchNext, '-'))
               cMatch     = ENTRY (k, cArrayList, ' ')
               iHigh      = INTEGER (ENTRY (NUM-ENTRIES (cMatch, '-'), cMatch, '-'))
               iLow       = INTEGER (ENTRY (1, cMatch, '-')).

/*        message  iHigh   '=' ilowNext skip   iHighNext  ilow skip    
        view-as alert-box error buttons Ok. */

        IF ((iHigh + 1) = iLowNext) THEN DO:
        /*   ** Check here for adding a number that will extend a sequence.
             ** [1-4,5-7]  => [1-7]        */ 
          IF NUM-ENTRIES (cMatch, '-') = 2 THEN 
            ASSIGN ENTRY (k, cArrayList, ' ') =  STRING (iLow) + '-' + STRING (iHighNext)
                   /*REPLACE (cMatch, STRING (iHigh), STRING(iHighNext))*/
                   ENTRY (k + 1, cArrayList, ' ') = "" .
          /*  ** Check here for adding a number that will extend a sequence.
		** [1,4,5-7]  => [1,4-7]        */ 
          ELSE IF NUM-ENTRIES (cMatchNext, '-') = 2 THEN 
            ASSIGN ENTRY (k + 1, cArrayList, ' ') = STRING (iLow) + '-' + STRING (iHighNext)
                   ENTRY (k    , cArrayList, ' ') = "" .
          LEAVE.
        END.  /* If iHigh + 1 = iLowNext */
      END. /* Do k = 1 TO iListLen */

/*        message  'replace' j ilistlen cArrayList       view-as alert-box error buttons Ok. */

      /* Remove and extra - if we collapsed some where */
      DO WHILE INDEX(cArrayList,"--") > 0:
        cArrayList = REPLACE (cArrayList, '--', '-').
      END.

      /* Remove and extra , if we collapsed some where	  */
      cArrayList =  TRIM (REPLACE (cArrayList, '  ', ' ')).
      DO WHILE INDEX(cArrayList, '  ':U) > 0:
        cArrayList = REPLACE (cArrayList, '  ', ' ').
      END.

      /* Need to check if this is the last item to be added and the collapse
  	  to 1-N notation where N is the number of extents...  	  */
      ASSIGN cName = cName + '[' + cArrayList + ']'
             lOk = whList:REPLACE (cName, ENTRY (j, whList:LIST-ITEMS, whList:DELIMITER))
             cTempOrg = cName.
      LEAVE.
    END.  /* IF (lArray = TRUE) AND (cTemp = cName) */
    ELSE IF (ENTRY(1,ENTRY(j,whList:LIST-ITEMS,whList:DELIMITER),"[":U) > cTemp) THEN DO:
      ASSIGN lOk = whList:INSERT(cTempOrg, 
                   ENTRY (j, whList:LIST-ITEMS, whList:DELIMITER)).
      RUN adecomm/_scroll.p (whList:HANDLE, INPUT cTempOrg). 
      LEAVE.
    END. /* Else if entry j is after cTemp */
  END. /*   DO j = 1 TO num-entries of whList */

  IF (j > NUM-ENTRIES (whList:LIST-ITEMS, whList:DELIMITER) OR whList:LIST-ITEMS = ?) THEN DO:
    lOK = whList:ADD-LAST(cTempOrg). 
    RUN adecomm/_scroll.p (whList:HANDLE, INPUT cTempOrg). 
  END.

RETURN.

/* _collaps.p - end of file */


