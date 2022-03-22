/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/**************************************************************************
    Procedure:  _ossfnam.p
    
    Purpose:    Returns the shortened version of an os filename when the
                filename does not display withing a given width for a
                specified font.

    Syntax :    RUN adeedit/_ossfnam.p
                    (INPUT  p_Name,
                     INPUT  p_Width,
                     INPUT  p_Font,
                     INPUT  p_Short_Name).

    Description:
    
    Notes  :
    
    Authors: John Palazzo
    Date   : October, 1996
    Updated: 
**************************************************************************/

&IF "{&OPSYS}" = "UNIX" &THEN
&SCOPED-DEFINE    OS-SLASH    /
&ELSE
&SCOPED-DEFINE    OS-SLASH    ~\
&ENDIF

DEFINE INPUT  PARAM p_Name       AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAM p_Width      AS DECIMAL   NO-UNDO.
DEFINE INPUT  PARAM p_Font       AS INTEGER   NO-UNDO.
DEFINE OUTPUT PARAM p_Short_Name AS CHARACTER NO-UNDO.

DEFINE VAR Text-Width    AS INTEGER   NO-UNDO.
DEFINE VAR Text-Prefix   AS CHARACTER NO-UNDO.
DEFINE VAR Text-Basename AS CHARACTER NO-UNDO.
DEFINE VAR Num_Entries   AS INTEGER   NO-UNDO.

DO ON STOP   UNDO, LEAVE
   ON ERROR  UNDO, LEAVE
   ON ENDKEY UNDO, LEAVE:
   
    ASSIGN p_Short_Name = p_Name.

    /* Only do the shortname on UNIX or DOS. */
    IF LOOKUP(OPSYS, "UNIX,MSDOS,WIN32") = 0 THEN RETURN.

    ASSIGN Text-Width = FONT-TABLE:GET-TEXT-WIDTH(p_Name, p_Font).
    
    IF (Text-Width > p_Width) THEN
    DO:
        /* Clear out short name. */
        ASSIGN p_Short_Name = "".
        
        /* Keep track of the total number of path elements. */
        ASSIGN Num_Entries = NUM-ENTRIES(p_Name, "{&OS-SLASH}").

        /* Is this a UNC pathname? E.g., \\Server\SharedFolder\Folder\Subfolder\filename.p */
        IF (p_Name BEGINS "~\~\":u) THEN
        DO:
            /* Set our prefix to Server and Shared Folder entries. Note that
               Server name is entry 3 in a slash delimited list "\\Server\SharedFolder".
            */
            ASSIGN Text-Prefix = "~\~\":u + ENTRY(3 , p_Name, "~\") + "~\" +
                                 ENTRY(4, p_Name, "~\").
            /* If more than 5 path elements, then we can grab the last two elements
               Subfolder\filename.p. Otherwise, just use the filename.p.
            */
            IF (Num_Entries > 5) THEN
                ASSIGN Text-Basename = ENTRY(Num_Entries - 1, p_Name, "~\")
                                       + "~\" +  ENTRY(Num_Entries, p_Name, "~\").
            ELSE
                ASSIGN Text-Basename = ENTRY(Num_Entries, p_Name, "~\").
        END.
        /* Else, Drive path: P:\Folder\Subfolder\filename.p */
        ELSE
        DO:
            /* Set our prefix to the Drive letter (or Null for no drive and for UNIX). */
            ASSIGN Text-Prefix = ENTRY(1 , p_Name, "{&OS-SLASH}").
            /* If more than 4 path elements, then we can grab the last two elements
               Subfolder\filename.p. Otherwise, just use the filename.p.
            */
            IF (Num_Entries > 4) THEN
            DO:
                ASSIGN Text-Prefix = Text-Prefix +  "{&OS-SLASH}" + ENTRY(2 , p_Name, "{&OS-SLASH}").
                ASSIGN Text-Basename = ENTRY(Num_Entries - 1, p_Name, "{&OS-SLASH}")
                                       + "{&OS-SLASH}" + ENTRY(Num_Entries, p_Name, "{&OS-SLASH}").
            END.
            ELSE
                ASSIGN Text-Basename = ENTRY(Num_Entries, p_Name, "{&OS-SLASH}").
        END.
        ASSIGN p_Short_Name = Text-Prefix + "{&OS-SLASH}" + "..." + "{&OS-SLASH}" + Text-Basename.
        
        /* If the abbreviated file name with 4 path elements is too long, truncate the original
           path up to half of the display witdth then add "...\filename.p".
        */
        IF (FONT-TABLE:GET-TEXT-WIDTH(p_Short_Name, p_Font) > p_Width) THEN
        DO:
            RUN adecomm/_osprefx.p (INPUT p_Name, OUTPUT Text-Prefix, OUTPUT Text-Basename).
            ASSIGN p_Short_Name = SUBSTRING(p_Name, 1, INTEGER((p_Width / 2)) + 4, "CHARACTER":U)
                                  + "..." + "{&OS-SLASH}" + Text-Basename.
        END.
        /* If the short name got shortened too much, set back to original file name. */
        IF (p_Short_Name = "") OR (p_Short_Name = ?) THEN
            ASSIGN p_Short_Name = p_Name.
    END.

/*
    MESSAGE "Name       = " p_Name          SKIP
            "Short Name = " p_Short_Name    SKIP
            "p_Width    = " p_Width         SKIP
            "Text-Width = " Text-Width      SKIP
            "p_Font     = " p_Font          SKIP
            "Prefix     = " Text-Prefix     SKIP
            "Basename   = " Text-Basename
        VIEW-AS ALERT-BOX.
*/
    
END.


