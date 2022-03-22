/***********************************************************************
* Copyright (C) 2000-2011,2013 by Progress Software Corporation. All   *
* rights reserved.  Prior versions of this work may contain portions   *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/

/* _lod_fil.p  -  moves temptable-info to new or existing _File

   History:  98-10-05-016 added block for dbversion DLM
             99-01-21-013 Reinitialized file-area-number DLM
	     99-07-08 Mario B. Assign _File._File-name when trigger is created
	                       or updated.  BUG# 99-02-09-002
      
      fernando 08/16/06 Raw comparison when checking if char values are different - 20060301-002
      
      nprajapa 2019/25/09 Removed the code, which updated the _File._File-name added by 
      BUG# 99-02-09-002, as it is causing problem while loading delta.df for online tirgger 
      operation. Timestamp will be updated by ABL client code for this operation. For more
      details about the issue please refer https://progresssoftware.atlassian.net/browse/OCTA-16013
        
 */

{ prodict/dictvar.i }
{ prodict/dump/loaddefs.i }

DEFINE VARIABLE scrap    AS CHARACTER NO-UNDO.
DEFINE VARIABLE old_name AS CHARACTER NO-UNDO CASE-SENS.
DEFINE VARIABLE new_name AS CHARACTER NO-UNDO CASE-SENS.

/* defines for dumpname.i */
DEFINE VARIABLE nam  AS CHARACTER NO-UNDO.
DEFINE VARIABLE pass AS INTEGER   NO-UNDO.

define variable lForceSharedSchema   as logical no-undo.
define variable dictLoader as OpenEdge.DataAdmin.Binding.IDataDefinitionLoader no-undo.


/*---------------------------  MAIN-CODE  --------------------------*/

/* dictLoadOptions - could have options only or be a logger/loader or reader/parser  */

if valid-object(dictLoadOptions) then
do: 
    /* the code below use valid-object(dictLoader) as flag to logg data and return */
    dictLoader = dictLoadOptions:Logger.
    lForceSharedSchema = dictLoadOptions:ForceSharedSchema.
  
end.

FIND FIRST wfil.
 
IF imod <> "a" THEN DO:
  IF INTEGER(DBVERSION("DICTDB")) > 8 THEN
    FIND DICTDB._File WHERE DICTDB._File._db-recid  = drec_db
                        AND DICTDB._File._File-name = wfil._File-name
                        AND (DICTDB._File._Owner = "PUB" OR DICTDB._File._Owner = "_FOREIGN"). /* proven to exist */
  ELSE
    FIND DICTDB._File WHERE DICTDB._File._db-recid  = drec_db
                        AND DICTDB._File._File-name = wfil._File-name.
											                   
  IF DICTDB._File._Frozen and NOT DICTDB._File._file-attributes[6] THEN ierror = 16. /* "Cannot &1 frozen file &3" */

END.
 
IF ierror > 0 THEN RETURN.

IF imod = "a" THEN DO: /*---------------------------------------------------*/
  IF INTEGER(DBVERSION("DICTDB")) > 8 THEN DO:
    IF CAN-FIND(DICTDB._File WHERE DICTDB._File._Db-recid = drec_db
                               AND DICTDB._File._File-name = wfil._File-name
                               AND (DICTDB._File._Owner = "PUB" OR DICTDB._File._Owner = "_FOREIGN") ) THEN
    do:
        if valid-object(dictLoader) and dictLoader:isReader then
        do:   
            /* this is not an error if parsing and the existing table is renamed */
            if dictLoader:TableNewName(wfil._File-name) = "" then
                ierror = 7. /* "&2 already exists with name &3" */
              
         end. 
         else   
            ierror = 7. /* "&2 already exists with name &3" */  
    end.
  END.  
  ELSE IF CAN-FIND(DICTDB._File WHERE DICTDB._File._Db-recid = drec_db
                                  AND DICTDB._File._File-name = wfil._File-name) THEN
    ierror = 7. /* "&2 already exists with name &3" */
 
  IF CAN-FIND(FIRST DICTDB._View WHERE DICTDB._View._View-name = wfil._File-name) THEN
    ierror = 19. /* VIEW exists with name &3" */
		  
  IF ierror > 0 THEN RETURN.

/* tmp-change: check for duplicate dump-names <hutegger> 94/05 */
  IF wfil._Dump-name <> ? THEN
  DO:
    ASSIGN nam = wfil._Dump-name.

    {prodict/dump/dumpname.i}


    ASSIGN wfil._Dump-name = nam.
  END. 
  
  if wfil._File-Attributes[1] = true and wfil._File-Attributes[3] = false then
  do:
      if not can-find(first _tenant) then
      do:
         /* db must be mt enabled to add mt file  */
         iError = 72.
         RETURN.
      end.     
  end.    
  
  If lForceSharedSchema and ((wfil._File-Attributes[1] and wfil._File-Attributes[2] = false) or (wfil._File-Attributes[3] = true)) then
  do:
      /* cannot force shared with keep default area false  */
      iError = 71.
      return.
  end.     
    
  If  wfil._File-Attributes[3] = true then
  do:
     /* avoid area check  - (leave check for error  if wfil._File-Attributes[1] true to core for now) */ 
  end.          
  else If (wfil._File-Attributes[1] = false or wfil._File-Attributes[2] = true) then
  do:
      RUN check_area_num (OUTPUT is-area).
      IF NOT is-area THEN DO:
        ierror = 31.
        RETURN NO-APPLY.
      END.
  end.
  
  if valid-object(dictLoader) and dictLoader:isReader then
  do:
      dictLoader:AddTable(iMod,buffer wfil:handle,file-area-number).
      return.
  end.
  
  ierror = 23. /* default error to general table attr error */

  CREATE DICTDB._File.
  assign
    DICTDB._File._Db-recid    = drec_db
    DICTDB._File._ianum       = file-area-number
    DICTDB._File._File-Number = ?
    
    file-area-number = 6.

  { prodict/dump/copy_fil.i &from=wfil &to=_File &all=false}
  
  If wfil._File-Attributes[1] then
  do:
      if not lForceSharedSchema then
      do:          
          DICTDB._File._File-Attributes[1] = wfil._File-Attributes[1]. 
          DICTDB._File._File-Attributes[2] = wfil._File-Attributes[2]. 
      end.
  end.  
  
  If wfil._File-Attributes[3] then
  do:
      DICTDB._File._File-Attributes[3] = wfil._File-Attributes[3].
  end.  

  IF wfil._Dump-name <> ? THEN DICTDB._File._Dump-name = wfil._Dump-name.

  IF wfil._Db-lang = 1 THEN
    dblangcache = dblangcache + "," + STRING(RECID(DICTDB._File)).
  IF wfil._Frozen THEN
    frozencache = frozencache + "," + STRING(RECID(DICTDB._File)).

  ierror = 0.  /* if we get here, there were no errors */

END. /*---------------------------------------------------------------------*/
ELSE
IF imod = "m" THEN DO: /*---------------------------------------------------*/
  if valid-object(dictLoader) and dictLoader:isReader then
  do:
      dictLoader:AddTable(iMod,buffer wfil:handle,?).
      return.
  end.
      
  ierror = 23. /* default error to general table attr error */
  IF DICTDB._File._Db-lang = 0 THEN DO:
    IF COMPARE(DICTDB._File._Can-create,"NE", wfil._Can-create,"RAW") THEN
      DICTDB._File._Can-create = wfil._Can-create.
    IF COMPARE(DICTDB._File._Can-delete,"NE",wfil._Can-delete,"RAW") THEN
      DICTDB._File._Can-delete = wfil._Can-delete.
    IF COMPARE(DICTDB._File._Can-write,"NE",wfil._Can-write,"RAW") THEN
      DICTDB._File._Can-write = wfil._Can-write.
    IF COMPARE(DICTDB._File._Can-read,"NE",wfil._Can-read,"RAW") THEN
      DICTDB._File._Can-read = wfil._Can-read.
    IF COMPARE(DICTDB._File._Can-dump,"NE",wfil._Can-dump,"RAW") THEN
      DICTDB._File._Can-dump = wfil._Can-dump.
    IF COMPARE(DICTDB._File._Can-load,"NE",wfil._Can-load,"RAW") THEN
      DICTDB._File._Can-load = wfil._Can-load.
  END.
  
  IF DICTDB._File._Desc       	<> wfil._Desc   THEN DICTDB._File._Desc   = wfil._Desc.
  IF COMPARE(DICTDB._File._File-label,"NE",wfil._File-label,"RAW") THEN 
    DICTDB._File._File-label = wfil._File-label.
  IF COMPARE(DICTDB._File._File-label-SA,"NE",wfil._File-label-SA,"RAW") THEN 
    DICTDB._File._File-label-SA = wfil._File-label-SA.
  IF COMPARE(DICTDB._File._Valexp,"NE",wfil._Valexp,"RAW") THEN DICTDB._File._Valexp = wfil._Valexp.
  IF DICTDB._File._Valmsg   	<> wfil._Valmsg THEN DICTDB._File._Valmsg = wfil._Valmsg.
  IF COMPARE(DICTDB._File._Valmsg-SA,"NE",wfil._Valmsg-SA,"RAW") THEN 
    DICTDB._File._Valmsg-SA = wfil._Valmsg-SA.
  IF DICTDB._File._Hidden   	<> wfil._Hidden THEN DICTDB._File._Hidden = wfil._Hidden.
  IF DICTDB._File._Dump-name 	<> wfil._Dump-name AND wfil._Dump-name <> ? THEN
    DICTDB._File._Dump-name = wfil._Dump-name.

  IF DICTDB._File._For-Format <> wfil._For-Format THEN
    DICTDB._File._For-Format = wfil._For-Format.
  IF DICTDB._File._For-Owner <> wfil._For-Owner THEN
    DICTDB._File._For-Owner = wfil._For-Owner.
  IF DICTDB._File._For-number <> wfil._For-number THEN
    DICTDB._File._For-number = wfil._For-number.
  IF DICTDB._File._For-Id   <> wfil._For-Id   THEN DICTDB._File._For-Id   = wfil._For-Id.
  IF DICTDB._File._For-Cnt1 <> wfil._For-Cnt1 THEN DICTDB._File._For-Cnt1 = wfil._For-Cnt1.
  IF DICTDB._File._For-Cnt2 <> wfil._For-Cnt2 THEN DICTDB._File._For-Cnt2 = wfil._For-Cnt2.
  IF DICTDB._File._For-Flag <> wfil._For-Flag THEN DICTDB._File._For-Flag = wfil._For-Flag.
  IF DICTDB._File._For-Info <> wfil._For-Info THEN DICTDB._File._For-Info = wfil._For-Info.
  IF DICTDB._File._For-Name <> wfil._For-Name THEN DICTDB._File._For-Name = wfil._For-Name.
  IF DICTDB._File._For-Size <> wfil._For-Size THEN DICTDB._File._For-Size = wfil._For-Size.
  IF DICTDB._File._For-Type <> wfil._For-Type THEN DICTDB._File._For-Type = wfil._For-Type.

  IF DICTDB._File._Fil-misc2[1] <> wfil._Fil-misc2[1] THEN
    DICTDB._File._Fil-misc2[1] = wfil._Fil-misc2[1].

  IF DICTDB._File._Fil-misc2[2] <> wfil._Fil-misc2[2] THEN
    DICTDB._File._Fil-misc2[2] = wfil._Fil-misc2[2].

  IF DICTDB._File._Fil-misc2[3] <> wfil._Fil-misc2[3] THEN
    DICTDB._File._Fil-misc2[3] = wfil._Fil-misc2[3].

  IF DICTDB._File._Fil-misc2[4] <> wfil._Fil-misc2[4] THEN
    DICTDB._File._Fil-misc2[4] = wfil._Fil-misc2[4].

  IF DICTDB._File._Fil-misc2[5] <> wfil._Fil-misc2[5] THEN
    DICTDB._File._Fil-misc2[5] = wfil._Fil-misc2[5].

  IF COMPARE(DICTDB._File._Fil-misc2[6],"NE",wfil._Fil-misc2[6],"RAW") THEN
    DICTDB._File._Fil-misc2[6] = wfil._Fil-misc2[6].

  IF DICTDB._File._Fil-misc2[7] <> wfil._Fil-misc2[7] THEN
    DICTDB._File._Fil-misc2[7] = wfil._Fil-misc2[7].

  IF DICTDB._File._Fil-misc2[8] <> wfil._Fil-misc2[8] THEN
    DICTDB._File._Fil-misc2[8] = wfil._Fil-misc2[8].

  IF DICTDB._File._Fil-misc1[1] <> wfil._Fil-misc1[1] THEN
    DICTDB._File._Fil-misc1[1] = wfil._Fil-misc1[1].

  IF DICTDB._File._Fil-misc1[2] <> wfil._Fil-misc1[2] THEN
    DICTDB._File._Fil-misc1[2] = wfil._Fil-misc1[2].

  IF DICTDB._File._Fil-misc1[3] <> wfil._Fil-misc1[3] THEN
    DICTDB._File._Fil-misc1[3] = wfil._Fil-misc1[3].

  IF DICTDB._File._Fil-misc1[4] <> wfil._Fil-misc1[4] THEN
    DICTDB._File._Fil-misc1[4] = wfil._Fil-misc1[4].

  IF DICTDB._File._Fil-misc1[5] <> wfil._Fil-misc1[5] THEN
    DICTDB._File._Fil-misc1[5] = wfil._Fil-misc1[5].

  IF DICTDB._File._Fil-misc1[6] <> wfil._Fil-misc1[6] THEN
    DICTDB._File._Fil-misc1[6] = wfil._Fil-misc1[6].

  IF DICTDB._File._Fil-misc1[7] <> wfil._Fil-misc1[7] THEN
    DICTDB._File._Fil-misc1[7] = wfil._Fil-misc1[7].

  IF DICTDB._File._Fil-misc1[8] <> wfil._Fil-misc1[8] THEN
    DICTDB._File._Fil-misc1[8] = wfil._Fil-misc1[8].
  
  IF DICTDB._File._File-attributes[1] = false and wfil._File-attributes[1] THEN
  DO.
      if not lForceSharedSchema then
      do:          
          DICTDB._File._File-Attributes[1] = wfil._File-Attributes[1]. 
          /* keep default area is set to True in the UI when _wfil._File-Attributes[1] changes */
          DICTDB._File._File-Attributes[2] = wfil._File-Attributes[2]. 
      end.
  END.
  
  If wfil._File-Attributes[3] <> _File._File-Attributes[3] then
  do:
      DICTDB._File._File-Attributes[3] = wfil._File-Attributes[3].
  end.  

  /* keep default area is currently not changable 
  ELSE 
  IF DICTDB._File._File-attributes[1] = true 
  and DICTDB._File._File-attributes[2] <> wfil._File-attributes[2] THEN
  do:
      DICTDB._File._File-attributes[2] = wfil._File-attributes[2].
  end. 
  */
  
  IF wfil._Frozen THEN
    frozencache = frozencache + "," + STRING(RECID(_File)).
  
  ierror = 0.  /* if we get here, there were no errors */

END. /*---------------------------------------------------------------------*/
ELSE
IF imod = "r" THEN DO: /*---------------------------------------------------*/
  IF CAN-FIND(FIRST DICTDB._View-ref WHERE DICTDB._View-ref._Ref-Table = wfil._File-name) THEN
    ierror = 20. /* "Cannot &1 &2 referenced in SQL view" */
  IF DICTDB._File._Db-lang = 1 THEN
    ierror = 18. /* "Cannot rename SQL table" */
  IF CAN-FIND(FIRST DICTDB._File WHERE DICTDB._File._Db-recid = drec_db
    AND DICTDB._File._File-name = irename
    AND (DICTDB._File._Owner = "PUB" OR DICTDB._File._Owner = "_FOREIGN") ) THEN
    ierror = 7. /* "&2 already exists with name &3" */
  
  IF ierror > 0 THEN RETURN.
  
  if valid-object(dictLoader) and dictLoader:isReader then
  do:
      dictLoader:RenameTable(wfil._File-name,irename).
      return.
  end.
  
  DICTDB._File._File-name = irename.
END. /*---------------------------------------------------------------------*/
ELSE
IF imod = "d" THEN DO: /*---------------------------------------------------*/
  IF DICTDB._File._Db-lang = 1 THEN
    ierror = 17. /* "Use SQL DROP TABLE to remove &3" */
  IF CAN-FIND(FIRST DICTDB._View-ref WHERE DICTDB._View-ref._Ref-Table = DICTDB._File._File-name) THEN
    ierror = 20. /* "Cannot &1 &2 referenced in SQL view" */
  IF ierror > 0 THEN RETURN.
  
  if valid-object(dictLoader) and dictLoader:isReader then
  do:
      dictLoader:AddTable(iMod,buffer wfil:handle,?).
      return.
  end.
  
  &scop alias dictdb.
  { prodict/dump/loadkill.i }
  &undefine alias  

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
    scrap = scrap + (IF scrap = "" THEN "" ELSE ",") + wfit._Event.
    FIND DICTDB._File-trig OF DICTDB._File WHERE DICTDB._File-trig._Event = wfit._Event NO-ERROR.
    IF AVAILABLE DICTDB._File-trig THEN DO:
      old_name = DICTDB._File-trig._Proc-name.
      new_name = wfit._Proc-name.
      IF  DICTDB._File-trig._Event     = wfit._Event
      AND DICTDB._File-trig._Override  = wfit._Override
      AND compare(old_name,'=',new_name,'raw')
      AND DICTDB._File-trig._Trig-CRC  = wfit._Trig-CRC THEN NEXT trig_loop.
    
    END.
		
    /* Progress doesn't let you modify a trigger record, so delete and
       recreate. */
    IF AVAILABLE DICTDB._File-trig THEN DELETE DICTDB._File-trig.
    CREATE DICTDB._File-trig.
    ASSIGN
      DICTDB._File-trig._File-recid = RECID(DICTDB._File)
      DICTDB._File-trig._Event      = wfit._Event
      DICTDB._File-trig._Override   = wfit._Override
      DICTDB._File-trig._Proc-Name  = wfit._Proc-Name
      DICTDB._File-trig._Trig-CRC   = wfit._Trig-CRC.
	  	        
  END.
      
  FOR EACH DICTDB._File-trig OF DICTDB._File WHERE NOT CAN-DO(scrap,DICTDB._File-trig._Event): 
    DELETE DICTDB._File-trig.
  END.
END.

ASSIGN
  drec_file   = RECID(DICTDB._File)
  kindexcache = "". /* and reset index delete cache on db or file change */

RETURN.

/*---------------------- INTERNAL PROCEDURES -----------------------*/

PROCEDURE check_area_num:
  DEFINE OUTPUT PARAMETER is-area AS LOGICAL INITIAL TRUE NO-UNDO.

    FIND FIRST DICTDB._Area WHERE DICTDB._Area._Area-number = file-area-number AND DICTDB._Area._Area-number >= 6 NO-ERROR.
    IF NOT AVAILABLE DICTDB._Area THEN DO:
      is-area = NOT is-area.
      RETURN.
     END.
     ELSE DO:
       is-area = TRUE.
       RETURN.
     END.
END PROCEDURE.


