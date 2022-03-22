/*********************************************************************
* Copyright (C) 2011 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/                    
/*
    History:
   
    21/06/2011 Added logic to delete constraint OE00195067 kmayur
     
*/ 
define input-output parameter minimum-index as integer.

{ prodict/dictvar.i }
{ prodict/dump/loaddefs.i }
{ prodict/user/uservar.i }

/*---------------------- INTERNAL PROCEDURES -----------------------*/

PROCEDURE check_area_num:
  DEFINE OUTPUT PARAMETER is-area AS LOGICAL INITIAL TRUE NO-UNDO.

    FIND FIRST DICTDB._Area WHERE DICTDB._Area._Area-number = index-area-number AND DICTDB._Area._Area-number >= 6 NO-ERROR.
    IF NOT AVAILABLE DICTDB._Area THEN DO:
      is-area = NOT is-area.
      RETURN.
     END.
     ELSE DO:
       is-area = TRUE.
       RETURN.
     END.
END PROCEDURE.

/*------------------------------------------------------------------*/
DEFINE VARIABLE scrap AS LOGICAL NO-UNDO.
DEFINE BUFFER another_index FOR _Index.
define variable lnewparent  as logical no-undo.
define variable lCheckArea as logical no-undo.
define variable lCheckAttrs as logical extent no-undo.
DEFINE VARIABLE gotError AS LOGICAL   NO-UNDO.
DEFINE BUFFER   con        FOR  _Constraint. 

define variable dictLoader as OpenEdge.DataAdmin.Binding.IDataDefinitionLoader no-undo.

/* dictLoadOptions - could have options only or be a logger/loader or reader/parser  */

if valid-object(dictLoadOptions) then
do:
    /* the code below use valid-object(dictLoader) as flag to logg data and return */
    dictLoader = dictLoadOptions:Logger.
end.

if valid-object(dictLoader) and dictLoader:isReader and imod = "a" then
    lnewparent = dictLoader:AddingChildToNewTable.

if not lnewParent then
do:  
    FIND _File WHERE RECID(_File) = drec_file no-error.
    IF NOT AVAILABLE _File THEN
        RETURN.
end.
FIND FIRST widx.

IF imod <> "a" AND imod <> "d" THEN
  FIND _Index OF _File
    WHERE _Index._Index-name = widx._Index-name. /* proven to exist */

DO ON ERROR UNDO, LEAVE:

    ASSIGN gotError = YES.
    
    IF imod = "a" THEN DO: /*----------------------------------------------*/
      if not lnewparent then
      do:
        IF CAN-FIND(FIRST _Index OF _File 
              	    WHERE _Index._Index-name = widx._Index-name) THEN 
        DO:
            if valid-object(dictLoader) and dictLoader:isReader then
            do:   
                /* this is not an error if the existing index is renamed */
                if dictLoader:IndexNewName(_File._File-name,widx._Index-name) = "" then
                do:
                   ierror = 7. /* "&2 already exists with name &3" */
                   RETURN.
                end.    
            end. 
            else do:
               ierror = 7. /* "&2 already exists with name &3" */
               RETURN.
            end.   
        END.
      end.
      
      /* if index ne 0 validate - note default set to 6 in _lodsddl unless Mt (no default area ) or HP  */
      if index-area-number NE 0 then
          lCheckArea = true.
      else do:
          if lnewparent then
          do:
             lCheckAttrs =  dictLoader:CurrentTableAttributes().
             /* should not happen, but we should probably throw an error in case
                for now just set to all to false, which will require area check   */
             if extent(lCheckAttrs) = ? then
                extent(lCheckAttrs) = 3.
          end.   
          else do:
              /* could just use the attr but  */
             extent(lCheckAttrs) = 3.
             assign
                lCheckAttrs[1] =  _File._File-Attributes[1]
                lCheckAttrs[2] =  _File._File-Attributes[2]
                lCheckAttrs[3] =  _File._File-Attributes[3].
          end.
          
          if lCheckAttrs[1] then
              lCheckArea = lCheckAttrs[2]. 
          /* table partition */
          else if lCheckAttrs[3] then   
              lCheckArea = not widx._index-attributes[1].
          else
              lCheckArea = true.
      end.
      
      if lCheckArea then
      do:  
         RUN check_area_num (OUTPUT is-area).
         IF NOT is-area THEN 
         DO:
           ierror = 31.
           RETURN NO-APPLY.
         END.
      END.
     
      if valid-object(dictLoader) and dictLoader:isReader then
      do:
          dictLoader:AddIndex(iMod,if lnewparent then ? else _File._file-name,buffer widx:handle,index-area-number,iprimary).
          return.   
      end.
  
      CREATE _Index.
      ASSIGN
        _Index._File-recid = drec_file
        _Index._I-misc1[1] = widx._I-misc1[1]
        _Index._Index-name = widx._Index-name
        _Index._Unique     = widx._Unique.
      IF widx._Desc       <> ? THEN _Index._Desc       = widx._Desc.
      IF widx._Wordidx    <> ? THEN _Index._Wordidx    = widx._Wordidx.
      IF widx._Idx-num    <> ? THEN _Index._Idx-num    = widx._Idx-num.
      IF widx._For-name   <> ? THEN _Index._For-name   = widx._For-name.
      IF widx._I-misc2[1] <> ? THEN _Index._I-misc2[1] = widx._I-misc2[1].
      IF widx._index-attributes[1] = no then
         assign _Index._ianum      = index-area-number
                index-area-number = 6. /* reset it to default value */
      if _File._File-Attributes[3] and widx._index-attributes[1] <> ? then 
      do: 
         _Index._index-attributes[1] = widx._index-attributes[1].
      end. 
      IF NOT widx._Active 
      or (valid-object(dictLoadOptions) and dictLoadOptions:ForceIndexDeactivate) THEN 
          _Index._Active = FALSE.
     
      FOR EACH wixf:
        CREATE _Index-field.
        ASSIGN
          _Index-field._Index-recid = RECID(_Index)
          _Index-field._Field-recid = wixf._Field-recid
          _Index-field._Index-Seq   = wixf._Index-Seq
          _Index-field._Abbreviate  = wixf._Abbreviate
          _Index-field._Ascending   = wixf._Ascending
          _Index-field._Unsorted    = FALSE.
        /*_Index-field._Unsorted    = wixf._Unsorted*/
        /*   The above line will be turned on when */
        /*   we implement a gateway that needs it. */
      END.
    
      /* only delete default index if there is a non-word index also */
      IF _File._dft-pk AND _Index._Wordidx <> 1 THEN DO:
        FIND another_Index WHERE RECID(another_Index) = _File._Prime-Index NO-ERROR.
        IF AVAILABLE _Index THEN DO:
          ASSIGN
            _File._Prime-Index = RECID(_Index) /* this block will delete the */
            _File._dft-pk      = FALSE.     /* default index if there is one */
          FOR EACH _index-field OF another_Index:
            DELETE _Index-field.
          END.    
          DELETE another_Index.
        END.
      END.
      IF iprimary THEN _File._Prime-index = RECID(_Index).
    END. /*---------------------------------------------------------------------*/
    ELSE
    IF imod = "m" THEN DO: /*---------------------------------------------------*/
      if valid-object(dictLoader) and dictLoader:isReader then
      do:
          dictLoader:AddIndex(iMod,_File._file-name,buffer widx:handle,?,if iprimary then true else _File._Prime-index = RECID(_Index)).
          return.   
      end.
      
      IF NOT widx._Active AND _Index._Active THEN _Index._Active = FALSE.
       
      IF iprimary AND _Index._Wordidx <> 1
        AND _File._Prime-index <> RECID(_Index) THEN
        _File._Prime-index = RECID(_Index).
    
      IF widx._Desc     <> _Index._Desc     THEN _Index._Desc     = widx._Desc.
      IF widx._For-name <> _Index._For-name THEN _Index._For-name = widx._For-name.
      IF widx._For-type <> _Index._For-type THEN _Index._For-type = widx._For-type.
      IF widx._I-misc1[1] <> _Index._I-misc1[1] THEN _Index._I-misc1[1] = widx._I-misc1[1].
      IF widx._I-misc2[1] <> _Index._I-misc2[1] THEN _Index._I-misc2[1] = widx._I-misc2[1].
      if _File._File-Attributes[3] and _Index._index-attributes[1] <> widx._index-attributes[1] then 
      do: 
          _Index._index-attributes[1] = widx._index-attributes[1].
      end. 
    END.  
    /*---------------------------------------------------------------------*/
    ELSE
    IF imod = "r" THEN DO: /*---------------------------------------------------*/
      IF CAN-FIND(FIRST _Index OF _File WHERE _Index._Index-name = irename) THEN
        ierror = 7. /* "&2 already exists with name &3" */
      IF ierror > 0 THEN RETURN.
      if valid-object(dictLoader) and dictLoader:isReader then
      do:
          dictLoader:RenameIndex(_File._file-name,_Index._Index-name ,irename).
          return.   
      end.
      
      IF irename <> "default" THEN _Index._Index-name = irename.
    END. /*---------------------------------------------------------------------*/
    ELSE
    IF imod = "d" THEN DO: /*---------------------------------------------------*/
      FIND _Index OF _File WHERE _Index._Index-name = widx._Index-name NO-ERROR.
    
      /* if a field is deleted, then its index is deleted.  therefore, this
         index might be missing.  so don't complain if we don't find it. */
      IF NOT AVAILABLE _Index AND NOT CAN-DO(kindexcache,widx._Index-name) THEN
        ierror = 9. /* "Index already deleted" */
      IF ierror > 0 THEN RETURN.
      
      if valid-object(dictLoader) and dictLoader:isReader then
      do:
          dictLoader:AddIndex(iMod,_File._file-name,buffer widx:handle,?,_File._Prime-index = RECID(_Index)).
          return.   
      end.
      
      IF AVAILABLE _Index THEN DO:
        FIND _File OF _Index.
        IF RECID(_Index) = _File._Prime-Index THEN DO:
          /* move primary to another index */
          FIND FIRST another_index OF _File
            WHERE RECID(another_index) <> RECID(_Index)
            AND another_index._Wordidx <> 1 NO-ERROR.
          IF NOT AVAILABLE another_index THEN ierror = 22.
            /* "Cannot remove last non-word index" */
          IF ierror > 0 THEN RETURN.
          _File._Prime-Index = RECID(another_index).
        END.
        FOR EACH _Constraint OF _Index:
           FOR EACH con WHERE con._Index-Parent-Recid = _Constraint._Index-Recid :
              ASSIGN con._con-status = "O"
                     con._con-active = FALSE.
           END.                     
           FOR EACH _Constraint-Keys WHERE _Constraint-Keys._Con-Recid = RECID(_Constraint):
              DELETE _Constraint-Keys.
           END.  
           DELETE _Constraint.

        END.
        FOR EACH _Index-field OF _Index:
          DELETE _Index-field.
        END.
        DELETE _Index.
      END.
    
    END. /*---------------------------------------------------------------------*/

    ASSIGN gotError = NO.
END.

IF gotError THEN
   ierror = 56. /* generic error - some client error raised */

RETURN.

