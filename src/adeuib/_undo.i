/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _undo.i

Description:
   This include file defines the _action temp table that is used to implement
   the undo mechanism.  Associated with this are its shared variables that
   are described below.

   Implementation:  There are several actions that one would like to be able to
   undo.  The following is a list of actions that are desirable to undo:
   delete, move, resize, create, property sheet changes, color/font changes.
   Also, "unlimited undo" and the capability to "redo" would be a good feature
   to have in a graphical system.

   When an action occurs, and if it is considered to be an undoable action, a
   new action record is created to denote the START of the action.  This is
   followed by the addition of one or more action records for each object that
   the action is applicable to. Finally a new action that denotes the END of
   the action is created.

   When the user does an undo, the action records between the START action
   record and the END action record are deleted from the _action temp-table
   after the action is undone.  Relevant information is stored in the
   _data field in character form for use when the undo occurs.  When the END
   action record is created, the _data field of this record contains the
   _seq-num of the START action record.  This is maintained for performance
   reasons.

   Example: User selects a button and deletes it.  The following records are
     added to the _action temp-table in the order shown below:
	StartDelete
        Delete   <--- This record contains information related to the button
        EndDelete


Input Parameters: <None>

Output Parameters: <None>

Author: Ravi-Chandar Ramalingam

Date Created: 11 February 1993

---------------------------------------------------------------------------- */

DEFINE {1} SHARED TEMP-TABLE _action
   FIELD _seq-num	AS INTEGER	LABEL "Sequence Number" INITIAL ?
   FIELD _u-recid	AS RECID	LABEL "Universal RECID" INITIAL ?
   FIELD _window-handle	AS WIDGET	LABEL "Window Handle"
   FIELD _operation	AS CHARACTER	LABEL "Operation"	INITIAL ?
   FIELD _data		AS CHARACTER	LABEL "Client Data"	INITIAL ?
   FIELD _other_Ls      AS CHARACTER    LABEL "Other Ls"
   /* The field _widget-handle added March 12,2003-DB.  Used for dynamics only
      to store the handle of deleted widgets  */
   FIELD _widget-handle AS WIDGET-HANDLE LABEL "Widget Handle" 
INDEX _seq-num IS PRIMARY UNIQUE  _seq-num
index _window-handle _window-handle. 

/* This variable behaves like a sequence number, since temp-table do not
   support it.  The number generated is unique for a session and is currently
   never reused. */
DEFINE {1} SHARED VARIABLE _undo-seq-num AS INTEGER
			LABEL "Sequence Number"	INITIAL 1.

/* This variable is used when there is composite action (i.e., an action
   that is done to a group of selected objects).  At the start of the undoable
   action, the number of selected objects is saved in this variable.  At the
   end of the action, this variable is reset to ?.  This is currently used
   when a group of objects are selected and moved or resized.
*/
DEFINE {1} SHARED VARIABLE _undo-num-objects AS INTEGER
			LABEL "Number Of Selected Objects" INITIAL ?.
/*
  When a new START... action record is created, the _seq-num of this record
  is saved in this variable.  This is used when its corresponding END...
  action record is created and then reset to ?.
*/
DEFINE {1} SHARED VARIABLE _undo-start-seq-num AS INTEGER
			LABEL "Action Start Sequence Number" INITIAL ?.

/* This variable is a handle to the "Undo XXX" menu item.  If you want to
   change the status of this menu item do:
      ASSIGN _undo-menu-item:LABEL = "&Undo Align"
             _undo-menu-item:SENSITIVE = TRUE.
*/
DEFINE {1} SHARED VARIABLE _undo-menu-item AS WIDGET-HANDLE NO-UNDO.
