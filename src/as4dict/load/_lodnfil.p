/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/

/* _lodnfil.p  -  moves temptable-info to new or existing wtp__file 

  Created 11/07/95 to run from as4dict directory structure  D. McMann 
                                    and work with temporary tables.
  Modified 03/21/96 Load files with null capable indicator on as
                    default D. McMann
           08/10/96 Verify what version of dict utilities and assign
                    null capable only if version > 0.  D. McMann   
           10/25/96 Load not correctly assigning _Frozen from df 
           03/21/97 Added Object Library support (user_env[34]) D. McMann 97-01-20-020   
           11/24/97 Correct how RPG names were created D. McMann 97-11-14-007 
           11/30/98 Added loop for check of AS/400 name D. McMann 98-09-11-038        
*/

{ as4dict/dictvar.i  SHARED}
{ as4dict/load/loaddefs.i }

DEFINE VARIABLE scrap    AS CHARACTER NO-UNDO.
DEFINE VARIABLE old_name AS CHARACTER NO-UNDO CASE-SENS.
DEFINE VARIABLE new_name AS CHARACTER NO-UNDO CASE-SENS.

/* defines for dumpname.i and As4 Name/Library validations */

DEFINE VARIABLE As4Name AS CHARACTER NO-UNDO.
DEFINE VARIABLE As4Library AS CHARACTER NO-UNDO.
DEFINE VARIABLE i AS INTEGER.
DEFINE VARIABLE lngth AS INTEGER.
DEFINE VARIABLE nam  AS CHARACTER NO-UNDO.
DEFINE VARIABLE pass AS INTEGER   NO-UNDO.              


/*---------------------------  MAIN-CODE  --------------------------*/        

FIND FIRST wfil.       

   IF CAN-FIND(FIRST wtp__file WHERE  wtp__file._File-name = wfil._File-name) THEN
        ierror = 7. /* "&2 already exists with name &3" */
   IF CAN-FIND(FIRST wtp__View WHERE wtp__View._View-name = wfil._File-name) THEN
        ierror = 19. /* VIEW exists with name &3" */                                                              
   IF ierror > 0 THEN RETURN.         
    
/* If we don't have an _As4-File Name, generate one.  Then, validate
   the As400 name and check or the object. */
   IF wfil._As4-File = "" then
      if LENGTH(wfil._File-name) < 11 then
           assign nam = CAPS(wfil._File-name).
      else 
           assign nam = CAPS(SUBSTRING(wfil._File-name,1,10)).
   ELSE
         assign nam = CAPS(wfil._As4-File).
   
    {as4dict/load/wtpname.i}
   ASSIGN As4Name = CAPS(nam).
   ASSIGN AS4Library = CAPS(user_dbname).
   
/* Do a CHKF to see if the file exists already */
   dba_cmd = "CHKF".
   RUN as4dict/_dbaocmd.p
       (INPUT "PF",
        INPUT As4Name,
        INPUT user_env[34],
        INPUT 0,
        INPUT 0).
   
   IF dba_return = 1 THEN 
   DO pass = 1 TO 9999:
     IF user_env[29] = "yes" THEN
       ASSIGN As4Name = SUBSTRING(As4Name,1,lngth - LENGTH(STRING(pass)))
                          + STRING(pass).
     ELSE        
       ASSIGN As4Name = SUBSTRING(As4Name + "_______",1,10 - LENGTH(STRING(pass)))
                      + STRING(pass)   
                      
     dba_cmd = "CHKF".
     RUN as4dict/_dbaocmd.p
       (INPUT "PF",
        INPUT As4Name,
        INPUT user_env[34],
        INPUT 0,
        INPUT 0).
   
     IF dba_return <> 1 THEN
       assign pass = 10000.
   END.    
   
   
   IF dba_return = 1 THEN DO:
      ierror = 7.  /* File already exists */
      RETURN.
   END.   

   ELSE If dba_return = 2 THEN DO:
     dba_cmd = "RESERVE".
     RUN as4dict/_dbaocmd.p 
       (INPUT "PF",
        INPUT As4Name,
        INPUT user_env[34],
        INPUT 0,
        INPUT 0).                     

     If dba_return <> 12 THEN DO:
        RUN as4dict/_dbamsgs.p.
        ierror = 23.
        RETURN.                 
     END.
   END.

   ELSE IF dba_return > 2 THEN DO:
       RUN as4dict/_dbamsgs.p.
       ierror = 23. /* default error to general table attr error */              
       RETURN.
   END.

/*    If we get here, OK to add so get a sequence number */
    dba_cmd="GETNUM".
    RUN as4dict/_dbaocmd.p
        (INPUT " ",
         INPUT " ",
         INPUT As4Library,
         INPUT 0,
         INPUT 0).

    If dba_return >= 32600 THEN DO:
       MESSAGE "The sequence generator for the file numbers in the server"
               "schema library is either missing or is locked.  A new file"
               "can not be generated."   
       ierror = 23.
       RETURN.
     END. 

     pfilenumber = dba_return.
     CREATE wtp__file.
     ASSIGN
          wtp__file._File-number = pfilenumber
          wtp__file._Db-recid = 1
          wtp__file._As4-File = As4Name
          wtp__file._As4-Library = user_env[34].
              
/* tmp-change: check for duplicate dump-names <hutegger> 94/05 */
    IF wfil._Dump-name = ? OR wfil._Dump-name = "" THEN 
        ASSIGN nam = SUBSTRING(wfil._file-name, 1,  8).
     ELSE
        ASSIGN nam = wfil._Dump-name.

    nam = LC(SUBSTRING(nam,1,8)).
    IF CAN-FIND(FIRST wtp__file WHERE wtp__file._Dump-name = nam) THEN
    ASSIGN
      pass = 1 /*ABSOLUTE(_File-num)*/
      nam  = SUBSTRING(nam + "-------",1,8 - LENGTH(STRING(pass)))
           + STRING(pass).

  DO pass = 1 TO 9999 WHILE CAN-FIND(FIRST wtp__file WHERE wtp__file._Dump-name = nam):
    ASSIGN nam = SUBSTRING(nam + "-------",1,8 - LENGTH(STRING(pass)))
               + STRING(pass).
  END.  
  
   ASSIGN wfil._Dump-name = nam.

    { as4dict/load/copy_fil.i &from=wfil &to=wtp__file &all=false}
       
   /* Take out cr/lf in description and valexp fields */
   ASSIGN wtp__file._Desc = TRIM(REPLACE (wtp__file._Desc, CHR(13), ""))
          wtp__file._Valexp = TRIM(REPLACE (wtp__file._Valexp, CHR(13), "")).

     /* assign some defaults */
     ASSIGN wtp__file._For-number = pfilenumber
                       wtp__file._Can-create = "*"
                       wtp__file._Can-delete = "*" 
                       wtp__file._Can-read    = "*"
                       wtp__file._Can-write   = "*"
                       wtp__file._Prime-Index = -1.
      
      IF wtp__file._For-name = "" THEN ASSIGN wtp__file._For-name = 
                                            wtp__file._AS4-Library + "/" + wtp__file._AS4-File.  
                                            
      IF wtp__file._For-format = "" or wtp__file._For-Format = ? THEN DO: 
         IF user_env[29] = "yes" THEN DO:  
            IF LENGTH(wtp__file._AS4-file) < 8 THEN
                ASSIGN wtp__file._For-format = wtp__file._AS4-File + "Z".
            ELSE
                ASSIGN wtp__file._For-format = 
                           SUBSTRING(wtp__file._AS4-File,1,7) + "Z" . 
            IF INDEX(wtp__file._For-format,"_") > 0 THEN DO:
              ASSIGN nam = wtp__file._For-format.
              {as4dict/load/forname.i }
              ASSIGN wtp__file._For-format = nam.
            END.
         END.  
         ELSE DO:
           IF LENGTH(wtp__file._AS4-file) < 10 THEN
               ASSIGN wtp__file._For-format = wtp__file._AS4-File + "R".
           ELSE
               ASSIGN wtp__file._For-format = 
                           SUBSTRING(wtp__file._AS4-File,1,9) + "R" . 
         END.                        
      END.
        
       /* Check if we might have a virtual file definition.  If so,
          turn it into a physical file by setting some values  */
       IF (SUBSTRING(wtp__file._Fil-Misc2[4],8,1) = "Y") AND 
              (wtp__file._For-Flag > 0) THEN 
          /* Allow Read Write Update as default for physical file */
          ASSIGN SUBSTRING(wtp__file._Fil-Misc2[4],8,1) = "N"
                 SUBSTRING(wtp__file._Fil-Misc2[4],5,2) = "YY"
                 wtp__file._For-Flag = 0
                 wtp__file._Fil-Misc2[6] = ""
                 wtp__file._For-Type = "".
                 
       IF wtp__file._Fil-Misc2[4] = "" THEN DO:
         FIND FIRST as4dict.p__Db NO-LOCK.
         IF as4dict.p__Db._Db-Misc1[3] > 0 THEN       
             ASSIGN wtp__file._Fil-Misc2[4] = "NNYYYYNN".
         ELSE
             ASSIGN wtp__file._Fil-Misc2[4] = "NNNYYYNN".             
       END.
       
       ASSIGN 
          wtp__file._Dump-name = wfil._Dump-name   /* Put in dump name */
          wtp__file._Fil-Misc2[5] = "Y"   /* Client Created */
          wtp__file._Fil-Misc1[7] = -1.   /* No primary Idx yet */

       /* Default some yes/no values */
       IF wtp__file._Hidden = ? OR wtp__file._Hidden = "" THEN 
            ASSIGN wtp__file._Hidden = "N".                       
  
       IF wfil._Frozen = "Y" THEN
            ASSIGN wtp__File._Frozen = "Y".
       ELSE      
            ASSIGN wtp__file._Frozen = "N".                                                                    

      IF wfil._Db-lang = 1 THEN
            dblangcache = dblangcache + "," + STRING(RECID(wtp__file)).
  
      ierror = 0.  /* if we get here, there were no errors */

/* update triggers */

  scrap = "".
  trig_loop:
  FOR EACH wfit:
     IF wfit._Proc-name = "!" THEN DO:
        DELETE wfit. /* triggers are deleted via .df when proc-name set to "!" */
        NEXT trig_loop.
     END.
     scrap = scrap + (IF scrap = "" THEN "" ELSE ",") + CAPS(wfit._Event).
     FIND FIRST wtp__Trgfl WHERE wtp__Trgfl._Event = CAPS(wfit._Event) 
               AND wtp__Trgfl._File-number = pfilenumber NO-ERROR.
     IF AVAILABLE wtp__Trgfl THEN DO:
        old_name = wtp__Trgfl._Proc-name.
        new_name = wfit._Proc-name.
        IF  wtp__Trgfl._Event     = CAPS(wfit._Event)
              AND wtp__Trgfl._Override  = wfit._Override
              AND old_name              = new_name
              AND wtp__Trgfl._Trig-CRC  = wfit._Trig-CRC THEN 
         NEXT trig_loop.
     END.

    /* Progress doesn't let you modify a trigger record, so delete and
       recreate. */
     IF AVAILABLE wtp__Trgfl THEN DELETE wtp__Trgfl.
     CREATE wtp__Trgfl.
     ASSIGN
        wtp__Trgfl._File-recid  = RECID(wtp__file)
        wtp__Trgfl._File-number = pfilenumber
        wtp__Trgfl._Event       = CAPS(wfit._Event)
        wtp__Trgfl._Override    = wfit._Override
        wtp__Trgfl._Proc-Name   = wfit._Proc-Name
        wtp__Trgfl._Trig-CRC    = wfit._Trig-CRC.
   END.
   FOR EACH wtp__Trgfl WHERE wtp__Trgfl._File-number = wtp__file._File-number 
                                                                AND NOT CAN-DO(scrap,wtp__Trgfl._Event):
       DELETE wtp__Trgfl.
   END.                
         

ASSIGN
  kindexcache = "". /* and reset index delete cache on db or file change */

RETURN.




