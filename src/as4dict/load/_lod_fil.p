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

/* _lod_fil.p  -  moves temptabel-info to new or existing as4dict.p__File 

   Modified 1/31/95 to run from as4dict directory structure  D. McMann

            3/21/96 Load files with null capable indicator on as default
                    D. McMann
           08/10/96 Verify what version of dict utilities and assign
                    null capable only if version > 0.  D. McMann 
           03/21/97 Added Object Library support (user_env[34]) D. McMann
                    97-01-20-020   
           10/01/97 Added RPG/400 Length name support (user_env[29]) D. McMann 
           04/10/98 CHKF having error when AS-File name is present 98-04-01-073 
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

IF imod <> "a" THEN DO:
  FIND as4dict.p__File WHERE TRIM(as4dict.p__File._File-name) = TRIM(wfil._File-name).
  IF as4dict.p__File._Frozen = "Y" THEN ierror = 16. /* "Cannot &1 frozen file &3" */
  ELSE DO:
     pfilenumber = as4dict.p__file._File-number.
     /* Indicate ADE change operation to APYPRODCT and Sync */
     ASSIGN as4dict.p__file._Fil-Res1[8] = 1 
         as4dict.p__file._fil-Misc1[1] = as4dict.p__file._fil-Misc1[1] + 1.
  END.
END.

IF ierror > 0 THEN RETURN.

IF imod = "m" OR imod = "d" THEN DO:
  /* If not adding, assume it exists and issue a reserve */
  dba_cmd = "RESERVE".
  RUN as4dict/_dbaocmd.p
      (INPUT "PF",
      INPUT as4dict.p__File._As4-File,
      INPUT as4dict.p__File._As4-Library,
      INPUT 0,
      INPUT 0).  
  
  If dba_return <> 1 THEN DO:
      RUN as4dict/_dbamsgs.p.
      ierror = 23.
      RETURN.
  END.
END.

IF imod = "a" THEN DO: /*---------------------------------------------------*/
   IF CAN-FIND(as4dict.p__File WHERE as4dict.p__File._Db-recid = INTEGER(drec_db)
        AND as4dict.p__File._File-name = wfil._File-name) THEN
        ierror = 7. /* "&2 already exists with name &3" */
   IF CAN-FIND(FIRST as4dict.p__View WHERE as4dict.p__View._View-name = wfil._File-name) THEN
        ierror = 19. /* VIEW exists with name &3" */                                                              
   IF ierror > 0 THEN RETURN.         
    
/* If we don't have an _As4-File Name, generate one.  Then, validate
   the As400 name and check or the object. */
   IF wfil._As4-File = "" OR wfil._As4-File = ? then do:
      if LENGTH(wfil._File-name) < 11 then
            assign nam = CAPS(wfil._File-name).
      else 
          assign nam = CAPS(SUBSTRING(wfil._File-name,1,10)).
   END.
   ELSE 
     assign nam = wfil._As4-File.
   
   {as4dict/load/as4name.i}
      
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
   CREATE as4dict.p__File.
   ASSIGN
          as4dict.p__File._File-number = pfilenumber
          as4dict.p__File._Db-recid = 1
          as4dict.p__File._As4-File = As4Name
          as4dict.p__File._As4-Library = user_env[34].
              
   /* tmp-change: check for duplicate dump-names <hutegger> 94/05 */
   IF wfil._Dump-name = ? OR wfil._Dump-name = "" THEN 
        ASSIGN nam = SUBSTRING(wfil._file-name, 1, 8).
   ELSE
        ASSIGN nam = wfil._Dump-name.

   {as4dict/load/dumpname.i}
   ASSIGN wfil._Dump-name = nam.

   { as4dict/load/copy_fil.i &from=wfil &to=as4dict.p__File &all=false}
       
   /* Take out cr/lf in description and valexp fields */
   ASSIGN as4dict.p__File._Desc = TRIM(REPLACE (as4dict.p__File._Desc, CHR(13), ""))
          as4dict.p__File._Valexp = TRIM(REPLACE (as4dict.p__File._Valexp, CHR(13), "")).

   /* assign some defaults */
   ASSIGN as4dict.p__File._For-number = pfilenumber
          as4dict.p__File._Can-create = "*"
          as4dict.p__File._Can-delete = "*" 
          as4dict.p__File._Can-read    = "*"
          as4dict.p__File._Can-write   = "*"
          as4dict.p__File._Prime-Index = -1.
      
   IF as4dict.p__File._For-name = "" THEN ASSIGN as4dict.p__File._For-name = 
                  as4dict.p__File._AS4-Library + "/" + as4dict.p__File._AS4-File.  
                                            
   IF as4dict.p__File._For-format = "" or as4dict.p__file._For-Format = ? THEN DO:   
      IF user_env[29] = "yes" THEN DO:
         IF LENGTH(as4dict.p__File._AS4-File) < 8 THEN
            ASSIGN as4dict.p__File._For-format =  as4dict.p__File._AS4-File + "Z".
         ELSE
            ASSIGN as4dict.p__File._For-format =  
                     SUBSTRING(as4dict.p__File._AS4-File,1,7) + "Z".
   
         IF INDEX(as4dict.p__File._For-format,"_") > 0 THEN DO:
            ASSIGN nam = as4dict.p__File._For-format.
           {as4dict/load/forname.i }
            ASSIGN as4dict.p__File._For-format = nam.
         END.
      END.  
      ELSE DO: 
        IF LENGTH(as4dict.p__File._AS4-file) < 10 THEN
            ASSIGN as4dict.p__File._For-format = as4dict.p__File._AS4-File + "R".
         ELSE
            ASSIGN as4dict.p__File._For-format = 
                           SUBSTRING(as4dict.p__File._AS4-File,1,9) + "R" .                                                  
      end.
   END.  
   /* Check if we might have a virtual file definition.  If so,
      turn it into a physical file by setting some values  */
   IF (SUBSTRING(as4dict.p__File._Fil-Misc2[4],8,1) = "Y") AND 
              (as4dict.p__File._For-Flag > 0) THEN 
          /* Allow Read Write Update as default for physical file */
       ASSIGN SUBSTRING(as4dict.p__File._Fil-Misc2[4],8,1) = "N"
              SUBSTRING(as4dict.p__File._Fil-Misc2[4],5,2) = "YY"
              as4dict.p__File._For-Flag = 0
              as4dict.p__File._Fil-Misc2[6] = ""
              as4dict.p__File._For-Type = "".
                 
   IF as4dict.p__File._Fil-Misc2[4] = "" THEN DO:
      FIND FIRST as4dict.p__Db NO-LOCK.
      IF as4dict.p__Db._Db-Misc1[3] > 0 THEN
          ASSIGN as4dict.p__File._Fil-Misc2[4] = "NNYYYYNN".
      ELSE    
          ASSIGN as4dict.p__File._Fil-Misc2[4] = "NNNYYYNN".
   END.
             
   ASSIGN 
          as4dict.p__File._Dump-name = wfil._Dump-name   /* Put in dump name */
          as4dict.p__File._Fil-Misc2[5] = "Y"   /* Client Created */
          as4dict.p__File._Fil-Misc1[7] = -1.   /* No primary Idx yet */

   /* Default some yes/no values */
   IF as4dict.p__File._Hidden = ? OR as4dict.p__File._Hidden = "" THEN 
       ASSIGN as4dict.p__File._Hidden = "N".                       
  
   IF as4dict.p__File._Frozen = ? OR as4dict.p__File._Frozen = "" THEN 
       ASSIGN as4dict.p__File._Frozen = "N".                                                                    

   IF wfil._Db-lang = 1 THEN
       dblangcache = dblangcache + "," + STRING(RECID(as4dict.p__File)).
   IF wfil._Frozen = "Y" THEN
       frozencache = frozencache + "," + STRING(RECID(as4dict.p__File)).

   ierror = 0.  /* if we get here, there were no errors */

END. /*---------------------------------------------------------------------*/
ELSE
IF imod = "m" THEN DO: /*---------------------------------------------------*/
   ierror = 23. /* default error to general table attr error */
   IF as4dict.p__File._Db-lang = 0 THEN DO:
      IF as4dict.p__File._Can-create <> wfil._Can-create THEN
          as4dict.p__File._Can-create = wfil._Can-create.
      IF as4dict.p__File._Can-delete <> wfil._Can-delete THEN
          as4dict.p__File._Can-delete = wfil._Can-delete.
      IF as4dict.p__File._Can-write <> wfil._Can-write THEN
          as4dict.p__File._Can-write = wfil._Can-write.
      IF as4dict.p__File._Can-read <> wfil._Can-read THEN
          as4dict.p__File._Can-read = wfil._Can-read.
      IF as4dict.p__File._Can-dump <> wfil._Can-dump THEN
             as4dict.p__File._Can-dump = wfil._Can-dump.
      IF as4dict.p__File._Can-load <> wfil._Can-load THEN
             as4dict.p__File._Can-load = wfil._Can-load.
   END.

   IF as4dict.p__File._Desc       	<> wfil._Desc   THEN 
       as4dict.p__File._Desc   = wfil._Desc.
   IF as4dict.p__File._File-label 	<> wfil._File-label THEN 
       as4dict.p__File._File-label = wfil._File-label.
   IF as4dict.p__File._File-label-SA <> wfil._File-label-SA THEN 
       as4dict.p__File._File-label-SA = wfil._File-label-SA.
   IF as4dict.p__File._Valexp   	<> wfil._Valexp THEN 
       as4dict.p__File._Valexp = wfil._Valexp.
   IF as4dict.p__File._Valmsg   	<> wfil._Valmsg THEN 
       as4dict.p__File._Valmsg = wfil._Valmsg.
   IF as4dict.p__File._Valmsg-SA  	<> wfil._Valmsg-SA THEN 
       as4dict.p__File._Valmsg-SA = wfil._Valmsg-SA.
   IF as4dict.p__File._Hidden   	<> wfil._Hidden THEN 
       as4dict.p__File._Hidden = wfil._Hidden.
   IF as4dict.p__File._Dump-name 	<> wfil._Dump-name AND wfil._Dump-name <> ? THEN
       as4dict.p__File._Dump-name = wfil._Dump-name.
   IF as4dict.p__File._Fil-misc2[4] <> wfil._Fil-misc2[4] AND wfil._Fil-misc2[4] <> ? THEN
       as4dict.p__File._Fil-misc2[4] = wfil._Fil-misc2[4].
   IF as4dict.p__File._Fil-misc2[5] <> wfil._Fil-misc2[5] AND wfil._Fil-misc2[5] <> ? THEN
       as4dict.p__File._Fil-misc2[5] = wfil._Fil-misc2[5].
   IF as4dict.p__File._Fil-misc2[6] <> wfil._Fil-misc2[6] AND wfil._Fil-misc2[6] <> ? THEN
       as4dict.p__File._Fil-misc2[6] = wfil._Fil-misc2[6].
   IF wfil._Frozen = "Y" THEN
       frozencache = frozencache + "," + STRING(RECID(as4dict.p__File)).   
   ierror = 0.  /* if we get here, there were no errors */
END. /*---------------------------------------------------------------------*/
ELSE
IF imod = "r" THEN DO: /*---------------------------------------------------*/
   IF CAN-FIND(FIRST as4dict.p__Vref WHERE as4dict.p__Vref._Ref-Table = wfil._File-name) THEN
       ierror = 20. /* "Cannot &1 &2 referenced in SQL view" */
   IF as4dict.p__File._Db-lang = 1 THEN
       ierror = 18. /* "Cannot rename SQL table" */
   IF CAN-FIND(FIRST as4dict.p__File WHERE as4dict.p__File._Db-recid = INTEGER(drec_db)
       AND as4dict.p__File._File-name = irename) THEN
       ierror = 7. /* "&2 already exists with name &3" */
   IF ierror > 0 THEN RETURN.
        as4dict.p__File._File-name = irename.
END. /*---------------------------------------------------------------------*/
ELSE
IF imod = "d" THEN DO: /*---------------------------------------------------*/
   IF as4dict.p__File._Db-lang = 1 THEN
        ierror = 17. /* "Use SQL DROP TABLE to remove &3" */
   IF CAN-FIND(FIRST as4dict.p__Vref WHERE as4dict.p__Vref._Ref-Table = as4dict.p__File._File-name) THEN
        ierror = 20. /* "Cannot &1 &2 referenced in SQL view" */

   IF ierror > 0 THEN RETURN.        

   dba_cmd = "DLTOBJ".
   RUN as4dict/_dbaocmd.p 
	  (INPUT "PF", 
	   INPUT as4dict.p__File._AS4-File,
      	   INPUT as4dict.p__File._AS4-Library,
	   INPUT as4dict.p__file._File-number,
	   INPUT 0).     
    
   { as4dict/deltable.i }

END. /*---------------------------------------------------------------------*/

/* update triggers */
IF imod = "a" OR imod = "m" THEN DO:
  scrap = "".
  trig_loop:
  FOR EACH wfit:
     IF wfit._Proc-name = "!" THEN DO:
        DELETE wfit. /* triggers are deleted via .df when proc-name set to "!" */
        NEXT trig_loop.
     END.
     scrap = scrap + (IF scrap = "" THEN "" ELSE ",") + CAPS(wfit._Event).
     FIND as4dict.p__Trgfl WHERE as4dict.p__Trgfl._Event = CAPS(wfit._Event) 
               AND as4dict.p__Trgfl._File-number = pfilenumber NO-ERROR.
     IF AVAILABLE as4dict.p__Trgfl THEN DO:
        old_name = as4dict.p__Trgfl._Proc-name.
        new_name = wfit._Proc-name.
        IF  as4dict.p__Trgfl._Event     = CAPS(wfit._Event)
              AND as4dict.p__Trgfl._Override  = wfit._Override
              AND old_name              = new_name
              AND as4dict.p__Trgfl._Trig-CRC  = wfit._Trig-CRC THEN 
         NEXT trig_loop.
     END.

    /* Progress doesn't let you modify a trigger record, so delete and
       recreate. */
     IF AVAILABLE as4dict.p__Trgfl THEN DELETE as4dict.p__Trgfl.
     CREATE as4dict.p__Trgfl.
     ASSIGN
        as4dict.p__Trgfl._File-recid  = RECID(as4dict.p__File)
        as4dict.p__Trgfl._File-number = pfilenumber
        as4dict.p__Trgfl._Event       = CAPS(wfit._Event)
        as4dict.p__Trgfl._Override    = wfit._Override
        as4dict.p__Trgfl._Proc-Name   = wfit._Proc-Name
        as4dict.p__Trgfl._Trig-CRC    = wfit._Trig-CRC.
   END.
   FOR EACH as4dict.p__Trgfl WHERE as4dict.p__Trgfl._File-number = as4dict.p__File._File-number 
                                                                AND NOT CAN-DO(scrap,as4dict.p__Trgfl._Event):
       DELETE as4dict.p__Trgfl.
   END.                
END.             

ASSIGN
  kindexcache = "". /* and reset index delete cache on db or file change */

RETURN.





