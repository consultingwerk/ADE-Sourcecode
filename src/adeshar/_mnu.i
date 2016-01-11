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
 *  _mnu.i
 *
 *    The GUI interface to edit the menu sub system. This is a "cooperative"
 *    interface. These contructs may live on a dialog box with other GUI
 *    objects that are not related to menus.
 *
 *  Input
 *
 *    &frme         The frame of these UI objects
 *    &appId        The application of these UI object
 *    &menuList     The selection list for the menus
 *    &itemFill     The fillin where the menu item labels can be editted
 *    &itemList     The list of all menu items
 *    &featureList  The list of all menu features
 *    &addButton    The "add to menu" button
 *    &delButton    The "remove the current menu item from its menu" button
 *    &menuBar      The menubar the menus are attached to
 *    &microHelp    The one line help that goes with features
 *    &dirty        Has the user made any changes
 */
 
DEFINE VARIABLE _mItsType         AS CHARACTER NO-UNDO.
DEFINE VARIABLE _mFeatureId       AS CHARACTER NO-UNDO.
DEFINE VARIABLE _mUserDefined     AS LOGICAL   NO-UNDO.
DEFINE VARIABLE _mItemHandle      AS HANDLE    NO-UNDO.
DEFINE VARIABLE _mMenuHandle      AS HANDLE    NO-UNDO.
DEFINE VARIABLE _mParentId        AS CHARACTER NO-UNDO.
DEFINE VARIABLE _mStatus          AS LOGICAL   NO-UNDO.
DEFINE VARIABLE _mPrvData         AS CHARACTER NO-UNDO.
DEFINE VARIABLE _mArgs            AS CHARACTER NO-UNDO.
DEFINE VARIABLE _mLabel           AS CHARACTER NO-UNDO.
DEFINE VARIABLE _mFunc            AS CHARACTER NO-UNDO.
DEFINE VARIABLE _mDefaultLabel    AS CHARACTER NO-UNDO.
DEFINE VARIABLE _mDefaultUpIcon   AS CHARACTER NO-UNDO.
DEFINE VARIABLE _mDefaultDownIcon AS CHARACTER NO-UNDO.
DEFINE VARIABLE _mDefaultInsIcon  AS CHARACTER NO-UNDO.
DEFINE VARIABLE _mMicroHelp       AS CHARACTER NO-UNDO.
DEFINE VARIABLE _mAns             AS LOGICAL   NO-UNDO.
DEFINE VARIABLE _mItemList        AS CHARACTER NO-UNDO.
DEFINE VARIABLE _mHandle          AS HANDLE    NO-UNDO.
DEFINE VARIABLE _mDeleted         AS LOGICAL   NO-UNDO. 
DEFINE VARIABLE _mLastLabel       AS CHARACTER NO-UNDO.
DEFINE VARIABLE _mLastFeature     AS CHARACTER NO-UNDO.

ON CHOOSE, VALUE-CHANGED OF {&itemList} 
  RUN changeFeatureToItemValue.

ON CHOOSE, VALUE-CHANGED OF {&featureList}
  RUN changeItemToFeatureValue.

ON CHOOSE, VALUE-CHANGED OF {&menuList} DO:
  /* Change the menu items to the value selected from the menu list */
  RUN changeMenu ({&menuList}:SCREEN-VALUE).

  /*
   * Never reset the other widgets if something has been deleted! We want the
   * value of the item and feature to be sticky, so that the user can
   * do 1) delete, 2) choose menu & 3) add. That provides a quick
   * way to move menu items from one menu to another.
   */

  IF _mDeleted = FALSE THEN
    ASSIGN
      {&itemFill}:SCREEN-VALUE = ""
      {&itemList}:SCREEN-VALUE = ""
      {&featureList}:SCREEN-VALUE = ""
      {&microHelp}:SCREEN-VALUE = ""
      .

  /* And check to see what buttons need to be turned on or off. */
  RUN figureButtonState.
END.

ON CHOOSE OF {&addButton} DO:
  {&dirty} = TRUE.
  RUN attachFeatureToItem.

  RUN figureButtonState.
END.

ON ENTRY OF {&itemFill} DO:
  /*
   * Save the current value. We need this information when the user
   * leaves the item fill-in. We need to know if the user changed the
   * value.
   */
  ASSIGN
    _mLastLabel = {&itemFill}:SCREEN-VALUE
    _mLastFeature = {&featureList}:SCREEN-VALUE
    .

  RUN figureButtonState.
END.

ON LEAVE OF {&itemFill} DO:
  /*
   * If the current value hasn't been changed that means that the user clicked
   * into the fill-in , but didn't change anything. Don't update anything
   * in that case. If we don't go away then the .p will be generated and
   * compiled, and the user won't understand why.
   */
  IF _mLastLabel = TRIM({&itemFill}:SCREEN-VALUE) THEN RETURN.

  IF TRIM({&itemFill}:SCREEN-VALUE) = ""  THEN DO:
    RUN figureButtonState.
    RETURN.
  END.

  /*
   * If the feature already has a menu item attached to it then
   * allow the label to be changed.
   */
  RUN adeshar/_mgeti2.p ({&appId}, _mLastFeature,
    OUTPUT _mLabel,
    OUTPUT _mItsType,
    OUTPUT _mUserDefined,
    OUTPUT _mItemHandle,
    OUTPUT _mMenuHandle,
    OUTPUT _mParentId,
    OUTPUT _mStatus).

  IF NOT((_mStatus = FALSE)
    OR ({&featureList}:SCREEN-VALUE = {&mnuSepFeature})) THEN DO:

    {&dirty} = TRUE.

    /*
     * Trap a corner case here. By using the label of the current feature.
     * instead of the current value of the itemList we insure that a user
     * will get good behavior ff there is a value in the Item fill-in
     * but the itemList doens't have a value then the user went to the
     * fill-in after a menu change. When a menu change happens no
     * default item is selected (due to the "sticky" feature, a default
     * item would break that feature).
     *
     * In this situation we'll assume that the user wants to give the
     * string entered in itemFill to the current feature.
     */
    RUN changeItemLabel ({&menuList}:SCREEN-VALUE,
      _mLastFeature,
      _mLastLabel,
      {&itemFill}:SCREEN-VALUE,
      OUTPUT _mStatus).

    RUN figureButtonState.

    IF _mStatus = FALSE THEN RETURN NO-APPLY.
  END.
END.

ON CHOOSE OF {&delButton} OR DEFAULT-ACTION OF {&itemList} DO:
  /* Delete the menu item from the list */
  RUN adeshar/_mdeli.p ({&appId}, {&itemList}:SCREEN-VALUE,
    FALSE,
    OUTPUT _mStatus).

  IF _mStatus = TRUE THEN DO:
    /*
     * The item, if it is a submenu, has to be removed from
     * the menuList. Since there's error if we try to remove
     * a non existant item, always remove
     */
    ASSIGN
      {&dirty} = TRUE
      _mDeleted = TRUE
      _mStatus = {&menuList}:DELETE( {&itemList}:SCREEN-VALUE )
      _mStatus = {&itemList}:DELETE( {&itemList}:SCREEN-VALUE )
      .

    RUN figureButtonState.
  END.
END.

/*------------------------------------------------------------------------*/
PROCEDURE changeItemLabel:
  DEFINE INPUT  PARAMETER menuId    AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER featureId AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER oldLabel  AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER newLabel  AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER s         AS LOGICAL   NO-UNDO.

  /* First change the menu item. That will always be changed */
  RUN adeshar/_mchgi.p ({&appId}, menuId, featureId, newLabel, OUTPUT s).

  /*
   * Then change the current screen value, if there is one. There is a case
   * when the user does: 1) choose from menu slist, 2) types in a name
   * and 3) goes to feature. In this case, there is no current value
   * from the menuItmes selection list.
   */
  IF NOT s THEN DO:
    MESSAGE "The label" newLabel "is already used."
      VIEW-AS ALERT-BOX INFORMATION.
    RETURN.
  END.

  IF {&itemList}:SCREEN-VALUE IN FRAME {&frme} <> ? THEN 
    ASSIGN _mStatus = {&itemList}:REPLACE(newLabel, oldLabel) IN FRAME {&frme}
      {&itemList}:SCREEN-VALUE IN FRAME {&frme} = newLabel.

  /*
   * Now figure out if the menu item was a submenu. If this is true
   * then we have to also change the menu list, since the label has changed
   * there too!
   */
  RUN adeshar/_mgeti2.p ({&appId}, featureId,
    OUTPUT _mLabel,
    OUTPUT _mItsType,
    OUTPUT _mUserDefined,
    OUTPUT _mItemHandle,
    OUTPUT _mMenuHandle,
    OUTPUT _mParentId,
    OUTPUT _mStatus).

  IF (_mStatus = TRUE) AND (_mItsType = {&mnuSubMenuType}) THEN DO:
    /*
    * Change the value in the menu list but *do not* change the
    * current value of the menu list! The current value of the menu list
    * is always supposed to be the menu the user is looking at
    */
    _mAns = {&menuList}:REPLACE(newLabel, oldLabel) IN FRAME {&frme}.
  END.
END PROCEDURE.

/*------------------------------------------------------------------------*/
PROCEDURE attachFeatureToItem:
  /* The user wants to add a new menu item to a menu.
   *
   *   1. The feature already exists, but is not attached to any menu item.
   *   2. The menu to be added to exists.
   *   3. The label of the proposed menu item is known.
   *
   * Retrieve the info from the temp table for the menu and
   * feature and then create the new menu item.  
   */
  RUN adeshar/_mgetf.p ({&appId},
    {&featureList}:SCREEN-VALUE IN FRAME {&frme},
    OUTPUT _mItsType,
    OUTPUT _mFunc,
    OUTPUT _mArgs,
    OUTPUT _mDefaultLabel,
    OUTPUT _mDefaultUpIcon,
    OUTPUT _mDefaultDownIcon,
    OUTPUT _mDefaultInsIcon,
    OUTPUT _mMicroHelp,
    OUTPUT _mPrvData,
    OUTPUT _mUserDefined,
    OUTPUT _mStatus).

  RUN adeshar/_mgetm.p ({&appId},
    {&menuList}:SCREEN-VALUE IN FRAME {&frme},
    OUTPUT _mMenuHandle,
    OUTPUT _mPrvData,
    OUTPUT _mStatus).
  
  /*
   * Add the new item into the database, after figuring out if
   * the user is adding a sep. If the user is adding a sep, then
   * generate a unique name for the sep.
   */
  _mLabel = {&itemFill}:SCREEN-VALUE IN FRAME {&frme}.
  
  IF {&featureList}:SCREEN-VALUE IN FRAME {&frme} = {&mnuSepFeature} THEN
    RUN adeshar/_msepnm.p ({&appId}, OUTPUT _mLabel).

  ELSE IF _mLabel = "" THEN DO:
    RUN adecomm/_s-alert.p (INPUT-OUTPUT _mAns, "error":u, "ok":u,
      SUBSTITUTE("You need to supply a label for the feature &1 before you can add it to a menu.",
      {&featureList}:SCREEN-VALUE IN FRAME {&frme})).
      
    RETURN.
  END.

  RUN adeshar/_maddi.p ({&appId},
    {&featureList}:SCREEN-VALUE IN FRAME {&frme},
    {&menuList}:SCREEN-VALUE IN FRAME {&frme},
    _mLabel,
    _mItsType,
    FALSE,
    "",
    OUTPUT _mStatus).
  
  IF _mStatus = FALSE THEN RETURN.
  
  /* Add the new item into the user interface */
  ASSIGN
    _mAns = {&itemList}:ADD-LAST(_mLabel) IN FRAME {&frme}
    {&itemList}:SCREEN-VALUE IN FRAME {&frme} = _mLabel
    .
  
  /* Make sure the new item is seen */
  &IF NOT "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
  RUN adecomm/_scroll.p ({&itemList}:HANDLE, {&itemList}:SCREEN-VALUE).
  &ENDIF

  /* If this a submenu then add it to the menu list */
  IF _mItsType = {&mnuSubMenuType} THEN DO:
    _mAns = {&menuList}:ADD-LAST(_mLabel) IN FRAME {&frme}.
    &IF NOT "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
    RUN adecomm/_scroll.p ({&menuList}:HANDLE, {&menuList}:SCREEN-VALUE).
    &ENDIF
  END.
END PROCEDURE.

/*------------------------------------------------------------------------*/
PROCEDURE changeFeatureToItemValue:
  RUN adeshar/_mgeti.p ({&appId},
    {&itemList}:SCREEN-VALUE IN FRAME {&frme},
    OUTPUT _mFeatureId,
    OUTPUT _mItsType,
    OUTPUT _mUserDefined,
    OUTPUT _mItemHandle,
    OUTPUT _mMenuHandle,
    OUTPUT _mStatus).

  RUN adeshar/_mgetf.p ({&appId},
    _mFeatureId,
    OUTPUT _mItsType,
    OUTPUT _mFunc,
    OUTPUT _mArgs,
    OUTPUT _mDefaultLabel,
    OUTPUT _mDefaultUpIcon,
    OUTPUT _mDefaultDownIcon,
    OUTPUT _mDefaultInsIcon,
    OUTPUT _mMicroHelp,
    OUTPUT _mPrvData,
    OUTPUT _mUserDefined,
    OUTPUT _mStatus).

  ASSIGN
    {&featureList}:SCREEN-VALUE IN FRAME {&frme} = _mFeatureId
    {&microHelp}:SCREEN-VALUE IN FRAME {&frme}   = _mMicroHelp
    {&itemFill}:SCREEN-VALUE IN FRAME {&frme}    =
      {&itemList}:SCREEN-VALUE IN FRAME {&frme}
    _mDeleted                                    = FALSE
    .

  &IF NOT "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
  RUN adecomm/_scroll.p ({&featureList}:HANDLE,
                         {&featureList}:SCREEN-VALUE).
  &ENDIF
  
  RUN figureButtonState.
END PROCEDURE.

/*------------------------------------------------------------------------*/
PROCEDURE changeItemToFeatureValue:
  /* Check to make sure that the feature item exists */

  RUN adeshar/_mgetf.p ({&appId},
    {&featureList}:SCREEN-VALUE IN FRAME {&frme},
    OUTPUT _mItsType,
    OUTPUT _mFunc,
    OUTPUT _mArgs,
    OUTPUT _mDefaultLabel,
    OUTPUT _mDefaultUpIcon,
    OUTPUT _mDefaultDownIcon,
    OUTPUT _mDefaultInsIcon,
    OUTPUT _mMicroHelp,
    OUTPUT _mPrvData,
    OUTPUT _mUserDefined,
    OUTPUT _mStatus).

  IF (_mStatus = FALSE) THEN RETURN.

  IF (_mItsType = {&mnuSepType}) THEN DO:
    /*
     * If the user picked a menu sep from the feature list then
     * reset the menu item list. The reason? There can be multiple seps
     * out there. We can't switch any one of them.
     */
    ASSIGN
      {&itemFill}:SCREEN-VALUE = ""
      {&itemList}:SCREEN-VALUE = ""
      .
  END.
  ELSE DO:
    /*
     * Get the menu item that is attached to the feature, if there
     * is one
     */
    RUN adeshar/_mgeti2.p ({&appId},
      {&featureList}:SCREEN-VALUE IN FRAME {&frme},
      OUTPUT _mLabel,
      OUTPUT _mItsType,
      OUTPUT _mUserDefined,
      OUTPUT _mItemHandle,
      OUTPUT _mMenuHandle,
      OUTPUT _mParentId,
      OUTPUT _mStatus).

    IF _mStatus THEN DO:
      /* The selected feature has a menu item assigned to it.
       * Figure out if the feature chosen by the user is currently
       * being displayed. Do this by getting the handle of the
       * menu being displayed and checking it against the menu item
       * of the feature. If they match then the menu (and therefore the menu
       * item) is already being displayed in the selection list.
       * Otherwise, change the menu.
       */
      _mDeleted = FALSE.

      RUN adeshar/_mgetm.p ({&appId},
        {&menuList}:SCREEN-VALUE IN FRAME {&frme},
        OUTPUT _mHandle,
        OUTPUT _mPrvData,
        OUTPUT _mStatus).
  
      IF (_mParentId <> {&menuList}:SCREEN-VALUE IN FRAME {&frme}) THEN DO:
        /* The menu item is in another menu. Change to it.  */
        RUN changeMenu (_mParentId).
  
        {&menuList}:SCREEN-VALUE IN FRAME {&frme} = _mParentId.
      END.
  
      /* Set the combo box to the proper menu item.  */
      ASSIGN
        {&itemList}:SCREEN-VALUE IN FRAME {&frme} = _mLabel
        {&itemFill}:SCREEN-VALUE IN FRAME {&frme} = _mLabel
        .
  
      &IF NOT "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
      RUN adecomm/_scroll.p ({&menuList}:HANDLE,{&menuList}:SCREEN-VALUE).
      RUN adecomm/_scroll.p ({&itemList}:HANDLE,{&itemList}:SCREEN-VALUE).
      &ENDIF
    END.
    ELSE DO:
      /*
       * There is no menu item for this feature, we'll assume that the user
       * wishes to add this feature to a menu. Provide the default
       * label for the feature and set the button states
       * explicitly, since there is no way (short of a state
       * variable) by looking at the screen artifacts to figure
       * out where we are at.
       */
      ASSIGN
        {&itemFill}:SCREEN-VALUE IN FRAME {&frme} = _mDefaultLabel
        {&itemList}:SCREEN-VALUE IN FRAME {&frme} = ""
        .
  
    END.
  END.
  {&microHelp}:SCREEN-VALUE IN FRAME {&frme} = _mMicroHelp.
  
  RUN figureButtonState.
END PROCEDURE.
  
/*------------------------------------------------------------------------*/
PROCEDURE figureButtonState:
  DEFINE VARIABLE _mFeatureId AS CHARACTER NO-UNDO.

  /* If nothing is selected anywhere then nothing is on */
  IF ({&itemList}:SCREEN-VALUE IN FRAME {&frme} = ?)
    AND ({&featureList}:SCREEN-VALUE IN FRAME {&frme} = ?) THEN DO:

    ASSIGN
      {&addButton}:SENSITIVE IN FRAME {&frme} = FALSE
      {&delButton}:SENSITIVE IN FRAME {&frme} = FALSE
      .
    RETURN.
  END.

  /*
   * The add button is on only if the feature doesn't have
   * a menu item. Unless we are working with the menu separator.
   *
   */
  _mFeatureId = {&featureList}:SCREEN-VALUE IN FRAME {&frme}.

  IF _mFeatureId = {&mnuSepFeature} THEN
    ASSIGN {&addButton}:SENSITIVE IN FRAME {&frme} = TRUE.

  ELSE DO:
    RUN adeshar/_mgeti2.p ({&appId}, _mFeatureId,
      OUTPUT _mLabel,
      OUTPUT _mItsType,
      OUTPUT _mUserDefined,
      OUTPUT _mItemHandle,
      OUTPUT _mMenuHandle,
      OUTPUT _mParentId,
      OUTPUT _mStatus).

    /* There is a menu item. Turn off the add button */
    ASSIGN 
      {&addButton}:SENSITIVE IN FRAME {&frme} = IF (_mStatus = TRUE) THEN
                                                  FALSE ELSE TRUE. 
  END.

  /*
   * The delete button is on if there is an item selected and
   *   1) the item is not a submenu OR
   *   2) it is a submenu with no children attached
   */
  IF {&itemList}:SCREEN-VALUE IN FRAME {&frme} <> ? THEN DO:
    IF _mItsType = {&mnuSubMenuType} THEN DO:
      RUN adeshar/_mgetsmc.p ({&appId}, _mLabel, OUTPUT _mStatus).

      {&delButton}:SENSITIVE IN FRAME {&frme} = (_mItemHandle <> ?) 
                                            AND (_mStatus= FALSE).
    END.
    ELSE
      {&delButton}:SENSITIVE IN FRAME {&frme} = TRUE.
  END.
  ELSE
    {&delButton}:SENSITIVE IN FRAME {&frme} = FALSE.

  /* js - bug 95-06-02-044 fix
     The Add Button should not be on when:
     - Menu fill-in is blank
     - Remove Button is on
  */
  /* I may be choosing a feature that does not have a label, such as
     WritePublicDirectory, so {&itemFill}:SCREEN-VALUE will be blank -dma 
  */
  IF {&delButton}:SENSITIVE IN FRAME {&frme} = TRUE
    /*OR {&itemFill}:SCREEN-VALUE = ""*/ THEN
    ASSIGN {&addButton}:SENSITIVE IN FRAME {&frme} = FALSE.
END PROCEDURE.

/*------------------------------------------------------------------------*/
PROCEDURE changeMenu:
  DEFINE INPUT PARAMETER menuLabel AS CHARACTER NO-UNDO.

  ASSIGN
    {&itemList}:SCREEN-VALUE IN FRAME {&frme} = ""	
    {&itemList}:LIST-ITEMS IN FRAME {&frme} = ""		
    .
  
  RUN adeshar/_mgetil.p ({&appId}, menuLabel, OUTPUT _mItemList).
  _mAns = {&itemList}:ADD-LAST(_mItemList) IN FRAME {&frme}.
END PROCEDURE.

/* _mnu.i - end of file */

