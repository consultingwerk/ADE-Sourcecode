/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*****************************************************************************

  PROCEDURE: _kvlist.p
  
  Purpose:  Reads/saves Key Values to and from Progress Environment File
            for an enumerated list of items in the Environment File 
            as follows:
            
                Item01=Value
                Item02=Value
                Item##=Value.
                  
  Syntax:
	    RUN adecomm/_kvlist.p ( INPUT p_Mode ,
                                    INPUT p_Section ,
                                    INPUT p_Key ,
                                    INPUT-OUTPUT p_List ) .
                                   
  Parameters:
  
            INPUT   p_Mode  - "GET" - routine reads using GET-KEY-VALUE.
                              "PUT" - routine saves using PUT-KEY-VALUE.
                              
            INPUT   p_Section - Section name in .INI or resource name in
                                .Xdefaults.
                                
            INPUT   p_Key   - Key name being saved. Example: Pass, "BufList",
                              and values are saved as "BufList01=Value,
                              "BufList02=Value", etc..
                              
            INPUT-OUTPUT p_List - Comma-delimited list of values.
            
  Notes:    1. If the PUT or GET fails, this routine returns ERROR.
            2. Current max limit on values to read/save is 99.
            3. In executing a GET, the routine reads sequentially until
               the next item number in sequence is not found.
            4. In executing a PUT, the routine saves up to the number
               of items in the list, and then deletes any items sequentially
               higher.  
               
               For example, if 2 items are being saved, and the
               environment file had three previously stored, then the
               routine would save the two in the list and removed Item03
               from the environment file.          

  Author: John Palazzo

  Date Created: 06/93
*****************************************************************************/

DEFINE INPUT        PARAMETER p_Mode    AS CHAR FORMAT "x(15)" NO-UNDO .
DEFINE INPUT        PARAMETER p_Section AS CHAR FORMAT "x(15)" NO-UNDO .
DEFINE INPUT        PARAMETER p_Key	AS CHAR FORMAT "x(15)" NO-UNDO .
DEFINE INPUT-OUTPUT PARAMETER p_List    AS CHAR FORMAT "x(15)" NO-UNDO .

DEFINE VARIABLE Max_Get_Limit AS INTEGER INIT 99 NO-UNDO.
       /* Max enumerated items to GET/PUT. */
    
DEFINE VARIABLE Key_Value   AS CHARACTER NO-UNDO.
DEFINE VARIABLE Entry_Num   AS INTEGER   NO-UNDO.
DEFINE VARIABLE Entry_Value AS CHARACTER NO-UNDO.
DEFINE VARIABLE Entry_Key   AS CHARACTER NO-UNDO.
DEFINE VARIABLE List_Items  AS INTEGER   NO-UNDO.
DEFINE VARIABLE New_List    AS CHARACTER NO-UNDO.

    
/* proc-main */
DO ON STOP  UNDO, RETURN ERROR      /* Note 1. */
   ON ERROR UNDO, RETURN ERROR :
       

    ASSIGN List_Items = IF ( p_Mode = "GET" )
                            THEN Max_Get_Limit
                            ELSE NUM-ENTRIES( p_List ).
    
    REPEAT:
        ASSIGN Entry_Num = Entry_Num + 1.
        IF ( Entry_Num > Max_Get_Limit ) THEN LEAVE. /* Note 2. */
        
        /*-----------------------------------------------------------------
            Get the key value. Do this regadless of PUT or GET mode.
            Then, if PUT mode and the key's value is different than
            what's currently in environment file, go ahead and save
            the new value.
        -----------------------------------------------------------------*/
        
        ASSIGN Entry_Key   = p_Key + STRING( Entry_Num , "99" )
               Key_Value   = ENTRY( Entry_Num , p_List )
               Entry_Value = Key_Value
               NO-ERROR.

        GET-KEY-VALUE SECTION p_Section KEY Entry_Key VALUE Entry_Value.

        /* Look no further if we can't find the next item. Note 3. */
        IF ( p_Mode = "GET" ) AND ( Entry_Value = ? ) THEN LEAVE.

        /* If we're finished saving the list, are there others in the
           env. file which need to be deleted? Note 4. */        
        IF ( p_Mode = "PUT" ) AND ( Entry_Num > List_Items )
        THEN DO:
            IF ( Entry_Value = ? ) THEN LEAVE.
            /* Left over item still in env. file, so delete it. */
            PUT-KEY-VALUE SECTION p_Section KEY Entry_Key VALUE ? NO-ERROR.
            IF ERROR-STATUS:ERROR THEN STOP. /* ON STOP RETURN ERROR. */
            NEXT.
        END.

        /* Check if we should save a changed value. */        
        IF ( p_Mode = "PUT" ) AND ( Entry_Value <> Key_Value )
        THEN DO:
            ASSIGN Entry_Value = Key_Value.
            PUT-KEY-VALUE SECTION p_Section 
                          KEY Entry_Key VALUE Entry_Value NO-ERROR.
            IF ERROR-STATUS:ERROR THEN STOP. /* ON STOP RETURN ERROR. */
        END.
        
        ASSIGN New_List = IF ( New_List <> "" )
                             THEN ( New_List + "," + Entry_Value )
                             ELSE Entry_Value.
   
    END. /* DO Entry_Num */
    ASSIGN p_List = New_List.
    
END. /* DO ON STOP */
