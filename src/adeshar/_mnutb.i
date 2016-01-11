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
/*
*  _mnutb.i
*
*    The GUI interface to edit the toolbar of themenu sub system.
*    This is a "cooperative" interface. These contructs may live on a
*    dialog box with other GUI objects that are not related to menus.
*
*  Input
*
*    &frme         The frame of these UI objects
*    &appId        The application of these UI object
*    &featureList  The list of all menu features
*    &addButton    The "add to toolbar" button
*    &delButton    The "remove the current button from the toolbar" button
*    &microHelp    The micro help
*    &resetFunc    The reset function. Should be the same as the one
*                  provided to _minit.p
*    &guiResetFunc The application callback to reinitialize the lists.
*    &upImageBut   The button to display the image of the upimage
*    &downImageBut The button to display the image of the down image
*    &insImageBut  The button to display the image of the insensitive image
*    &dirty        Has the user made any changes
*/

&IF DEFINED(ADEICONDIR) = 0 &THEN
{adecomm/icondir.i}
&ENDIF

DEFINE VARIABLE _tItsType         AS CHARACTER NO-UNDO.
DEFINE VARIABLE _tfeatureId       AS CHARACTER NO-UNDO.
DEFINE VARIABLE _tToolbarId       AS CHARACTER NO-UNDO.
DEFINE VARIABLE _tUserDefined     AS LOGICAL   NO-UNDO.
DEFINE VARIABLE _tItemHandle      AS HANDLE    NO-UNDO.
DEFINE VARIABLE _tEditHandle      AS HANDLE    NO-UNDO.
DEFINE VARIABLE _tStatus          AS LOGICAL   NO-UNDO.
DEFINE VARIABLE _tPrvData         AS CHARACTER NO-UNDO.
DEFINE VARIABLE _tArgs            AS CHARACTER NO-UNDO.
DEFINE VARIABLE _tFunc            AS CHARACTER NO-UNDO.
DEFINE VARIABLE _tDefaultLabel    AS CHARACTER NO-UNDO.
DEFINE VARIABLE _tDefaultUpIcon   AS CHARACTER NO-UNDO.
DEFINE VARIABLE _tDefaultDownIcon AS CHARACTER NO-UNDO.
DEFINE VARIABLE _tDefaultInsIcon  AS CHARACTER NO-UNDO.
DEFINE VARIABLE _tMicroHelp       AS CHARACTER NO-UNDO.
DEFINE VARIABLE _tUpImage         AS CHARACTER NO-UNDO.
DEFINE VARIABLE _tUpImage2        AS CHARACTER NO-UNDO.
DEFINE VARIABLE _tDownImage       AS CHARACTER NO-UNDO.
DEFINE VARIABLE _tDownImage2      AS CHARACTER NO-UNDO.
DEFINE VARIABLE _tInsImage        AS CHARACTER NO-UNDO.
DEFINE VARIABLE _tInsImage2       AS CHARACTER NO-UNDO.
DEFINE VARIABLE _tItemList        AS CHARACTER NO-UNDO.
DEFINE VARIABLE _tHandle          AS HANDLE    NO-UNDO.
DEFINE VARIABLE _tX               AS INTEGER   NO-UNDO.
DEFINE VARIABLE _tY               AS INTEGER   NO-UNDO.
DEFINE VARIABLE _tW               AS INTEGER   NO-UNDO.
DEFINE VARIABLE _tH               AS INTEGER   NO-UNDO.
DEFINE VARIABLE _tI               AS INTEGER   NO-UNDO.
DEFINE VARIABLE _tCurrentEditBut  AS HANDLE    NO-UNDO.
DEFINE VARIABLE _tCurrentEditX    AS INTEGER   NO-UNDO.
DEFINE VARIABLE _tState           AS CHARACTER NO-UNDO INITIAL "start".
DEFINE VARIABLE _tName            AS CHARACTER NO-UNDO.

_tToolbarId = {&toolbarId}.

ON CHOOSE, DEFAULT-ACTION, VALUE-CHANGED OF {&featureList} 
  RUN changeTbToFeatureValue ({&featureList}:SCREEN-VALUE, TRUE).

ON CHOOSE OF {&upImageBut} DO:
  RUN adecomm/_setcurs.p ("WAIT":u).
  RUN _tGetImage (INPUT-OUTPUT _tUpImage2, "up":u).
END.

ON CHOOSE OF {&addButton} DO:
  DO WITH FRAME {&frme}:
    RUN adeshar/_maddt.p ({&appId},
      {&featureList}:SCREEN-VALUE,
      {&toolbarID},
      _tUpImage2,
      _tDownImage2,
      _tInsImage2,
      _tCurrentEditX, {&y}, {&mnuIconSize}, {&mnuIconsize},
      {&tbItemType},
      FALSE,
      ?,
      OUTPUT _tStatus).

    /* Change the current feature to point to the current edit button */
    RUN adeshar/_msett1.p({&appId}, {&featureList}:SCREEN-VALUE,
      _tToolbarId,
      _tCurrentEditBut,
      OUTPUT _tStatus).

    /* Make sure everything gets updated on the screen */
    {&dirty} = TRUE.

    RUN loadImage(_tCurrentEditBut, _tUpImage2, _tDownImage2).
    RUN changeTbToFeatureValue({&featureList}:SCREEN-VALUE, TRUE).
    RUN _tFigureButtonState("addBut").
  END.
END.

ON CHOOSE OF {&delButton} DO:
  /*
  * Delete will remove the image from the current edit button. But
  * the button stays on the screen. The association of button to
  * feature is also broken.
  */

  ASSIGN
    {&dirty} = TRUE
    _tStatus = _tCurrentEditBut:LOAD-IMAGE-UP("")
    .

  /*
  * Make sure that the handle is removed from the table. When cleanup
  * occurs the table is walked record by record and any remaining
  * "edit" widgets are destroyed
  */
  RUN adeshar/_msett1.p({&appId},
    {&featureList}:SCREEN-VALUE IN FRAME {&frme},
    _tToolbarId,
    ?,
    OUTPUT _tStatus).

  RUN adeshar/_mdelt.p({&appId},
    {&featureList}:SCREEN-VALUE IN FRAME {&frme},
    _tToolbarId,
    OUTPUT _tStatus).

  RUN _tFigureButtonState("delBut").
END.

/*----------------------------------------------------------------------*/
PROCEDURE changeLocToFeature:
  DEFINE INPUT PARAMETER h AS HANDLE  NO-UNDO.
  DEFINE INPUT PARAMETER X AS INTEGER NO-UNDO.
  DEFINE INPUT PARAMETER Y AS INTEGER NO-UNDO.
  
  IF VALID-HANDLE(_tCurrentEditBut) THEN
    _tCurrentEditBut:LABEL = "".
  ASSIGN
    _tCurrentEditBut = h
    _tCurrentEditX   = X
    .

  /*
  * Given an x,y position in the toolbar, get the feature and then change
  * the UI to that feature
  */
  RUN adeshar/_mgett3.p({&appId},
    _tToolbarId,
    X,
    Y,
    OUTPUT _tFeatureId,
    OUTPUT _tUpImage,
    OUTPUT _tDownImage,
    OUTPUT _tInsImage,
    OUTPUT _tItsType,
    OUTPUT _tUserDefined,
    OUTPUT _tPrvData,
    OUTPUT _tW,
    OUTPUT _tH,
    OUTPUT _tItemHandle,
    OUTPUT _tHandle,
    OUTPUT _tStatus).
  
  IF _tStatus = FALSE THEN DO:
    _tFeatureId = ?.
    _tCurrentEditBut:LABEL = "x":u.
    RUN _tFigureButtonState("emptySlot":u).
  END.
  ELSE
    RUN _tFigureButtonState("usedSlot":u).

  /*
  * If the current state of the UI is "add?", that is the user has
  * deleted an icon and can now decide to add it back, then do not
  * try to change the feature. We want to have the old feature around.
  */
  
  IF _tState <> "add?" THEN
    RUN changeTbToFeatureValue(_tFeatureId, FALSE).
END.

/*----------------------------------------------------------------------*/

PROCEDURE changeTbToFeatureValue:
  DEFINE INPUT PARAMETER feature    AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER checkState AS LOGICAL   NO-UNDO.

  DEFINE VARIABLE attachedToToolbar AS LOGICAL NO-UNDO.

  RUN adeshar/_mgetf.p({&appId},
    feature,
    OUTPUT _tItsType,
    OUTPUT _tFunc,
    OUTPUT _tArgs,
    OUTPUT _tDefaultLabel,
    OUTPUT _tDefaultUpIcon,
    OUTPUT _tDefaultDownIcon,
    OUTPUT _tDefaultInsIcon,
    OUTPUT _tMicroHelp,
    OUTPUT _tPrvData,
    OUTPUT _tUserDefined,
    OUTPUT _tStatus).

  /*
  * If there is no feature, then don't even try to see if there is a button
  * attached to feature. No sense in wasting time.
  */

  IF feature =  ? THEN
    attachedToToolbar = FALSE.

  /* Get the toolbar button that is attached to the feature, if there is one */
  ELSE
  RUN adeshar/_mgett2.p({&appId},
    feature,
    _tToolbarId,
    OUTPUT _tUpImage,
    OUTPUT _tDownImage,
    OUTPUT _tInsImage,
    OUTPUT _tItsType,
    OUTPUT _tUserDefined,
    OUTPUT _tPrvData,
    OUTPUT _tX,
    OUTPUT _tY,
    OUTPUT _tW,
    OUTPUT _tH,
    OUTPUT _tItemHandle,
    OUTPUT _tEditHandle,
    OUTPUT attachedToToolbar).

  IF attachedToToolbar THEN DO:
  
    /*
    * The selected feature has a toolbar button attached to it.
    * Display the pertinent info. Figure out the slot number
    */

    ASSIGN
      {&featureList}:SCREEN-VALUE IN FRAME {&frme} = feature
      {&microHelp}:SCREEN-VALUE IN FRAME {&frme}   = _tMicroHelp
      _tUpImage2                                   = _tUpImage
      _tDownImage2                                 = _tDownImage
      _tInsImage2                                  = _tInsImage
      _tCurrentEditBut                             = _tEditHandle
      _tCurrentEditX                               = _tX
    .

    RUN figureImageName (_tUpImage, OUTPUT _tName).
    _tStatus = {&upImageBut}:LOAD-IMAGE-UP(_tName).

    /* Motif doesn't automatically scroll the current value into view ... */
    &IF NOT "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
    RUN adecomm/_scroll.p ({&featureList}:HANDLE,
    {&featureList}:SCREEN-VALUE).
    &ENDIF
  END.
  ELSE DO:
    ASSIGN
      {&microHelp}:SCREEN-VALUE IN FRAME {&frme} = _tMicroHelp
      _tUpImage2                                 = _tDefaultUpIcon
      _tDownImage2                               = _tDefaultDownIcon
      _tinsImage2                                = _tDefaultInsIcon
      .

    RUN figureImageName (_tDefaultUpIcon, OUTPUT _tName).
    _tStatus = {&upImageBut}:LOAD-IMAGE-UP(_tName).

    IF feature = ? THEN
      {&featureList}:SCREEN-VALUE = "".
  END.

  IF VALID-HANDLE(_tCurrentEditBut) THEN
    _tCurrentEditBut:LABEL = "".

  IF checkState THEN DO:
    IF attachedToToolbar THEN
      RUN _tFigureButtonState("fList").
    ELSE
      RUN _tFigureButtonState("fListAdd").
  END.
END PROCEDURE.

/*----------------------------------------------------------------------*/

PROCEDURE _tInitEdit:
  DEFINE VARIABLE defaultButton AS LOGICAL INITIAL TRUE NO-UNDO.

  DO _tI = 1 TO 14 WITH FRAME {&frme}:
    ASSIGN
      _tX = ((_tI - 1) * {&mnuIconSize}) + {&mnuIconOffset}
      _tY = {&mnuIconY}
      .

    RUN adeshar/_mgett3.p({&appId},
      _tToolbarId,
      _tX,
      _tY,
      OUTPUT _tFeatureId,
      OUTPUT _tUpImage,
      OUTPUT _tDownImage,
      OUTPUT _tInsImage,
      OUTPUT _tItsType,
      OUTPUT _tUserDefined,
      OUTPUT _tPrvData,
      OUTPUT _tW,
      OUTPUT _tH,
      OUTPUT _tItemHandle,
      OUTPUT _tEditHandle,
      OUTPUT _tStatus).

    /*
    * If we didn't find a feature that means there is a gap.
    * Create a button anyway.
    */
    IF _tStatus = FALSE THEN
      ASSIGN
        _tW = {&mnuIconsize}
        _tH = {&mnuIconsize}
        .

    RUN _tCreateEditButton(_tFeatureId,
      _tUpImage,
      _tDownImage,
      _tX,
      _tY,
      _tW,
      _tH,
      _tPrvData,
      FALSE).

    /* _tHandle is a shared var. So it is available after the call */
    IF _tStatus = TRUE AND defaultButton = TRUE THEN DO:
      defaultButton = FALSE.
      RUN changeLocToFeature(_tHandle, _tX, _tY).
    END.
  END.
  
END PROCEDURE.

/*----------------------------------------------------------------------*/

PROCEDURE _tCreateEditButton:
  DEFINE INPUT  PARAMETER featureId  AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER upImage    AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER downImage  AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER X          AS INTEGER   NO-UNDO.
  DEFINE INPUT  PARAMETER Y          AS INTEGER   NO-UNDO.
  DEFINE INPUT  PARAMETER w          AS INTEGER   NO-UNDO.
  DEFINE INPUT  PARAMETER h          AS INTEGER   NO-UNDO.
  DEFINE INPUT  PARAMETER prvData    AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER displayNow AS LOGICAL   NO-UNDO.
  
  CREATE BUTTON _tHandle
    ASSIGN
    FRAME   	= FRAME {&frme}:HANDLE
    X             = X
    Y             = Y
    WIDTH-PIXELS  = w
    HEIGHT-PIXELS = h
    AUTO-RESIZE   = FALSE
    SENSITIVE     = TRUE
    PRIVATE-DATA  = prvData
    TRIGGERS:
      ON CHOOSE
        PERSISTENT RUN changeLocToFeature(_tHandle, X, Y).
      END TRIGGERS.
    .

  RUN loadImage(_tHandle, upImage, downImage).

  IF featureId <> "" THEN
  RUN adeshar/_msett1.p({&appId}, featureId,
    _tToolbarId,
    _tHandle,
    OUTPUT _tStatus).

  /*
  * When adding a single button during an edit session we need the
  * button to be displayed immediately. But we don't want the buttons
  * displayed immediately when the dialog box is being created
  */
  IF displayNow THEN
    _tHandle:VISIBLE = TRUE.
END PROCEDURE.

/*----------------------------------------------------------------------*/

PROCEDURE loadImage:
  DEFINE INPUT PARAMETER h         AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER upImage   AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER downImage AS CHARACTER NO-UNDO.
  
  IF (upImage <> ?) AND (upImage <> "") THEN DO:
    RUN figureImageName (upImage, OUTPUT _tName).
    IF NOT h:LOAD-IMAGE-UP(_tName) THEN
      MESSAGE upImage "(up) was not found by loadImage.".
  END.
  
END PROCEDURE.

/*----------------------------------------------------------------------*/

PROCEDURE figureImageName:
  DEFINE INPUT  PARAMETER realName AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER iName    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE         slash    AS CHARACTER NO-UNDO.

  iName = realName.
  IF iName BEGINS "adeicon":u THEN 
    ASSIGN
      slash = IF INDEX(realName,"/":u) > 0 THEN "/":u ELSE "~\":u
      iName = {&ADEICON-DIR} + ENTRY(2, realName, slash).
END PROCEDURE.

/*----------------------------------------------------------------------*/

PROCEDURE _tFinishEdit:
  RUN adeshar/_mgettl.p({&appId}, OUTPUT _tItemList).

  DO _tI = 1 TO NUM-ENTRIES(_tItemList):
    RUN adeshar/_mgett2.p({&appId},
      ENTRY(_tI, _tItemList),
      _tToolbarId,
      OUTPUT _tUpImage,
      OUTPUT _tDownImage,
      OUTPUT _tInsImage,
      OUTPUT _tItsType,
      OUTPUT _tUserDefined,
      OUTPUT _tPrvData,
      OUTPUT _tX,
      OUTPUT _tY,
      OUTPUT _tW,
      OUTPUT _tH,
      OUTPUT _tItemHandle,
      OUTPUT _tEditHandle,
      OUTPUT _tStatus).

    IF VALID-HANDLE (_tEditHandle) = TRUE THEN DO:
      DELETE WIDGET _tEditHandle.

      /*
      * Set the edit handle to ?. This makes sure that any further code
      * that deletes records  won't hit a stale handle
      */
      RUN adeshar/_msett1.p({&appId},
        ENTRY(_tI, _tItemList),
        _tToolbarId,
        ?,
        OUTPUT _tStatus).
    END.
  END.
END PROCEDURE.

/*----------------------------------------------------------------------*/

PROCEDURE _tGetImage:
  DEFINE INPUT-OUTPUT PARAMETER f-name    AS CHARACTER NO-UNDO.
  DEFINE INPUT        PARAMETER imageType AS CHARACTER NO-UNDO.

  DEFINE VARIABLE newName      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE absoluteName AS CHARACTER NO-UNDO.

  /* fileFilters needs to be in format of list-items-pairs for the combo-box in
     _fndfile.p that displays the File Types */ 

  &IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
  DEFINE VARIABLE fileFilters AS CHARACTER NO-UNDO.
  fileFilters = "All Picture Files|*.bmp,*.dib,*.ico,*.gif,*.jpg,*.cal,*.cut,*.dcx,*.eps,*.ica,*.iff,*.img," +
    "*.lv,*.mac,*.msp,*.pcd,*.pct,*.pcx,*.psd,*.ras,*.im,*.im1,*.im8,*.tga,*.tif,*.xbm,*.bm,*.xpm,*.wmf,*.wpg" +
    "|Bitmaps (*.bmp,*.dib)|*.bmp,*.dib|Icons (*.ico)|*.ico|GIF (*.gif)|*.gif|JPEG (*.jpg)|*.jpg" +
    "|CALS (*.cal)|*.cal|Halo CUT (*.cut)|*.cut|Intel FAX (*.dcx)|*.dcx|EPS (*.eps)|*.eps|IOCA (*.ica)|*.ica" +
    "|Amiga IFF (*.iff)|*.iff|GEM IMG (*.img)|*.img|LaserView (*.lv)|*.lv|MacPaint (*.mac)|*.mac" +
    "|Microsoft Paint (*.msp)|*.msp|Photo CD (*.pcd)|*.pcd|PICT (*.pct)|*.pct|PC Paintbrush (*.pcx)|*.pcx" +
    "|Adobe Photoshop (*.psd)|*.psd|Sun Raster (*.ras,*.im,*.im1,*.im8)|*.ras,*.im,*.im1,*.im8|TARGA (*.tga)|*.tga" +
    "|TIFF (*.tif)|*.tif|Pixmap (*.xpm)|*.xpm|Metafiles (*.wmf)|*.wmf|WordPerfect graphics (*.wpg)|*.wpg|" +
    "Xbitmap (*.xbm,*.bm)|*.xbm,*.bm|All Files|*.*":U.
  &ELSE
  DEFINE VARIABLE fileFilters AS CHARACTER INITIAL "*.xbm,*.xpm|*"   NO-UNDO.
  &ENDIF

  DO WITH FRAME {&frme}:
    newName = f-name.

    RUN adecomm/_fndfile.p ("Image Files", "Image", fileFilters,
                            INPUT-OUTPUT {&iconDir}, INPUT-OUTPUT newName,
                            OUTPUT absoluteName, OUTPUT _tStatus).

    IF _tStatus = FALSE THEN RETURN.

    /* If we have the same name then don't do anything. */
    IF f-name = newName THEN RETURN.

    /*
     * For portability, strip off any file extension. The LOAD-IMAGE stuff
     * doesn't require it!

       newName is coming back sans extension, so don't strip off what's not
       there.  The following code wreaks havoc when the directory contains
       a period.  Let's take newName as is. -dma

    f-name = SUBSTRING(newName,1,R-INDEX(newName,".":u) - 1,"CHARACTER":u).
    */
    f-name = newName.

    CASE imageType:
      WHEN "up":u THEN DO:
        RUN figureImageName (f-name, OUTPUT _tName).
        _tStatus = {&upImageBut}:LOAD-IMAGE-UP(_tName).

        RUN adeshar/_msett2.p({&appId},
          {&featureList}:SCREEN-VALUE,
          _tToolbarId,
          imageType,
          f-name,
          OUTPUT _tStatus).
      END.
    END CASE. /* imageType */

    /*
    * If the user deletes a toolbar button, the button is removed from
    * editor's toolbar space. But the toolbar definition stays on
    * the screen. Therefore the uer can change the image of the button
    * while the item is not on the screen. In fact the user may want to to
    * this! For example, the user may be changing slots and images of a
    * button.
    *
    * So if the button isn't in the toolbar then don't change the current
    * image.
    */

    IF NOT ((_tState = "add?":u) OR (_tState = "inter":u)) THEN DO:
      CASE imageType:
        WHEN "up":u THEN DO:
          RUN figureImageName (f-name, OUTPUT _tName).
          _tStatus = _tCurrentEditBut:LOAD-IMAGE-UP(_tName).
        END.
      END.
    
      {&dirty} = TRUE.
    END.
  END.
END PROCEDURE.
    
/*----------------------------------------------------------------------*/
    
PROCEDURE _tFigureButtonState:
  DEFINE INPUT PARAMETER action AS CHARACTER NO-UNDO.

  DEFINE VARIABLE delAvail  AS LOGICAL INITIAL TRUE.
  DEFINE VARIABLE addAvail  AS LOGICAL INITIAL TRUE.
  DEFINE VARIABLE upAvail   AS LOGICAL INITIAL TRUE.
  DEFINE VARIABLE downAvail AS LOGICAL INITIAL TRUE.
  DEFINE VARIABLE insAvail  AS LOGICAL INITIAL TRUE.

  /*
  * This procedure, in effect, is a finite state machine. The first
  * column is current, the header is the transitioning state, the contents
  * is what causes transformation.
  *
  *          start    del?      inter   add?      empty
  * start             fList                       nothing in toolbar
  *
  * del?              fList     remove  flistAdd  emptySlot
  *                   usedSlot
  *
  * inter             usedSlot          emptySlot
  *                   fList
  *
  * add?              usedSlot          emptySlot
  *                   fList
  *                   add
  *
  * empty             usedSlot          fList
  *
  */

  DO WITH FRAME {&frme}:
    /*  Handle the start case. */
    IF action = "start":u THEN DO:
      IF {&featureList}:SCREEN-VALUE = ? THEN
        _tState = "empty":u.
      ELSE
        _tState = "del?":u.
    END.

    /* The first case statement determines what state to move into */
    CASE _tState:
      WHEN "del?":u THEN DO:
        IF action = "delBut":u THEN
          _tState = "inter":u.
        ELSE IF action = "emptySlot":u THEN
          _tState = "empty":u.
        ELSE IF action = "fListAdd":u THEN
          _tState = "inter":u.
      END.

      WHEN "inter":u THEN DO:
        IF action = "usedSlot":u THEN
          _tState = "del?":u.
        ELSE IF action = "fList":u THEN
          _tState = "del?":u.
        ELSE IF action = "emptySlot":u THEN
          _tState = "add?":u.
      END.

      WHEN "add?":u THEN DO:
        IF action = "usedSlot":u THEN
          _tState = "del?":u.
        ELSE IF action = "fList":u THEN
          _tState = "del?":u.  
        ELSE IF action = "fListAdd":u THEN
          _tState = "inter":u.
        ELSE IF action = "addBut":u THEN
          _tState = "del?":u.
      END.

      WHEN "empty":u THEN DO:
        IF action = "usedSlot":u THEN
        _tState = "del?":u.
        IF action = "fList":u THEN
        _tState = "del?":u.
        ELSE
        IF action = "fListAdd":u THEN
        _tState = "add?":u.
      END.
    END CASE. /* tState */

  /* The second case determines what should be on in a given state.  */
  CASE _tState:
    WHEN "del?":u THEN
      addAvail = FALSE.

    WHEN "inter" THEN
      ASSIGN
        addAvail = FALSE
        delAvail = FALSE
        .

    WHEN "add?" THEN
      delAvail = FALSE.

    WHEN "empty" THEN
      ASSIGN
        delAvail  = FALSE
        addAvail  = FALSE
        upAvail   = FALSE
        downAvail = FALSE
        insAvail  = FALSE
        .
  END CASE.

  ASSIGN
    {&addButton}:SENSITIVE IN FRAME {&frme}  = addAvail
    {&delButton}:SENSITIVE IN FRAME {&frme}  = delAvail
    {&upImageBut}:SENSITIVE IN FRAME {&frme} = upAvail
    .
  END.
END PROCEDURE.

/* _mnutb.i - end of file */

