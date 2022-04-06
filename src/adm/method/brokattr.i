/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* brokattr.i - attribute include file for broker.p -
   defines the TEMP-TABLEs and preprocessor values for the ADM broker */

DEFINE VARIABLE adm-dispatch-proc AS CHARACTER NO-UNDO. /* Used in dispatch.i */

/* This is the table in which all links between SmartObjects are stored.
   The source-id and target-id fields hold the UNIQUE-ID of each process,
   which helps identify whether the handle still points to the same
   process it used to. The link-target-id is used in the link-source
   index to force 'notify' loops to be consistent in the order in which
   they dispatch a method in their targets - it will always be in the
   order in which the target objects were created (which is determined
   by adm-create-objects in the container). */

DEFINE TEMP-TABLE adm-link-table NO-UNDO
    FIELD link-type  AS CHARACTER 
    FIELD link-source AS HANDLE   
    FIELD link-target AS HANDLE   
    FIELD link-active AS LOGICAL
    FIELD link-source-id AS INTEGER
    FIELD link-target-id AS INTEGER
    INDEX link-type IS PRIMARY link-type link-active 
    INDEX link-source link-source link-type link-active link-target-id
    INDEX link-target link-target link-type link-active. 

/* This work-table is used by set-active links to keep track of
   link-changed notifications. */
DEFINE WORK-TABLE      adm-link-procedure NO-UNDO
       FIELD           link-proc-hdl      AS HANDLE.

/* These are link types which by default *will* be deactivated when
   an object is hidden: */
&IF DEFINED(adm-default-deactivate-links) = 0 &THEN
&GLOB adm-default-deactivate-links ~
"NAVIGATION,TABLEIO,{&adm-user-default-deactivate-links}":U
&ENDIF
DEFINE VARIABLE adm-default-deactivate-links AS CHARACTER 
  INIT {&adm-default-deactivate-links} NO-UNDO.

&IF DEFINED(adm-notify-methods) = 0 &THEN
&GLOB adm-notify-methods ~
"exit,initialize,hide,view,~
enable,row-available,destroy,get-first,~
get-prev,get-next,get-last,open-query,~
add-record,update-record,copy-record,delete-record,~
reposition-query,reset-record,cancel-record,{&adm-user-notify-methods}":U
&ENDIF
DEFINE VARIABLE adm-notify-methods AS CHARACTER 
  INIT {&adm-notify-methods} NO-UNDO.

&IF DEFINED(adm-notify-links) = 0 &THEN
&GLOB adm-notify-links ~
"CONTAINER-SOURCE,CONTAINER-TARGET,CONTAINER-TARGET,CONTAINER-TARGET,~
CONTAINER-TARGET,RECORD-TARGET,CONTAINER-TARGET,NAVIGATION-TARGET,~
NAVIGATION-TARGET,NAVIGATION-TARGET,NAVIGATION-TARGET,RECORD-SOURCE,~
TABLEIO-TARGET,TABLEIO-TARGET,TABLEIO-TARGET,TABLEIO-TARGET,~
RECORD-SOURCE,TABLEIO-TARGET,TABLEIO-TARGET,{&adm-user-notify-links}":U
&ENDIF
DEFINE VARIABLE adm-notify-links AS CHARACTER INIT {&adm-notify-links} NO-UNDO. 

/* Default states and the links they get passed to: */
&IF DEFINED(adm-state-names) = 0 &THEN
&GLOB adm-state-names ~
"link-changed,record-available,no-record-available,update-begin,~
update,update-complete,first-record,last-record,only-record,not-first-or-last,~
delete-complete,no-external-record-available,{&adm-user-state-names}":U
&ENDIF
DEFINE VARIABLE adm-state-names AS CHARACTER INIT {&adm-state-names} NO-UNDO.

&IF DEFINED(adm-state-links) = 0 &THEN
&GLOB adm-state-links ~
"*;TABLEIO-SOURCE,NAVIGATION-SOURCE;TABLEIO-SOURCE,NAVIGATION-SOURCE;~
TABLEIO-TARGET;TABLEIO-SOURCE,RECORD-SOURCE,NAVIGATION-SOURCE;~
TABLEIO-SOURCE,RECORD-SOURCE,NAVIGATION-SOURCE;~
NAVIGATION-SOURCE;NAVIGATION-SOURCE;NAVIGATION-SOURCE;NAVIGATION-SOURCE;~
RECORD-SOURCE;TABLEIO-SOURCE,NAVIGATION-SOURCE;{&adm-user-state-links}":U
&ENDIF
DEFINE VARIABLE adm-state-links AS CHARACTER INIT {&adm-state-links} NO-UNDO.

&IF DEFINED(adm-pass-through-links) = 0 &THEN
&GLOB adm-pass-through-links ~
"NAVIGATION,TABLEIO,RECORD,{&adm-user-pass-through-links}":U
&ENDIF
DEFINE VARIABLE adm-pass-through-links AS CHARACTER 
  INIT {&adm-pass-through-links} NO-UNDO.           
  
&IF DEFINED(adm-circular-links) = 0 &THEN
&GLOB adm-circular-links ~
"RECORD,{&adm-user-circular-links}":U
&ENDIF
DEFINE VARIABLE adm-circular-links AS CHARACTER
  INIT {&adm-circular-links} NO-UNDO.
  
&IF DEFINED(adm-translation-attrs) = 0 &THEN
&GLOB adm-translation-attrs ~
"FOLDER-LABELS,LABEL,{&adm-user-translation-attrs}":U
&ENDIF
DEFINE VARIABLE adm-translation-attrs AS CHARACTER
  INIT {&adm-translation-attrs} NO-UNDO.
  
&IF DEFINED(adm-trans-methods) = 0 &THEN
&GLOB adm-trans-methods ~
"delete-record,{&adm-user-trans-methods}":U
&ENDIF
DEFINE VARIABLE adm-trans-methods AS CHARACTER 
  INIT {&adm-trans-methods} NO-UNDO.

&IF DEFINED(adm-pre-initialize-events) = 0 &THEN
&GLOB adm-pre-initialize-events ~
"initialize,create-objects,change-page,destroy,edit-attribute-list,~
{&adm-user-pre-initialize-events}":U
&ENDIF
DEFINE VARIABLE adm-pre-initialize-events AS CHARACTER 
  INIT {&adm-pre-initialize-events} NO-UNDO.


DEFINE VARIABLE adm-watchdog-hdl          AS HANDLE NO-UNDO. /* PRO*Spy */
DEFINE VARIABLE adm-show-dispatch-errors  AS LOGICAL   NO-UNDO INIT ?.

DEFINE NEW GLOBAL SHARED VAR adm-broker-hdl    AS HANDLE  NO-UNDO.

/* This is the list of all the basic attributes whose values are
   stored in the first segment of each object's ADM-DATA. */

DEFINE VARIABLE adm-basic-attrs AS CHARACTER NO-UNDO
  INIT "VERSION,TYPE,CONTAINER-TYPE,QUERY-OBJECT,EXTERNAL-TABLES,~
INTERNAL-TABLES,ENABLED-TABLES,ADM-OBJECT-HANDLE,ADM-ATTRIBUTE-LIST,~
SUPPORTED-LINKS,ADM-DISPATCH-QUALIFIER,ADM-PARENT,LAYOUT,ENABLED,HIDDEN,~
CONTAINER-HIDDEN,INITIALIZED,FIELDS-ENABLED,CURRENT-PAGE,ADM-NEW-RECORD,~
UIB-MODE,ADM-DEACTIVATE-LINKS":U.

/* This is the list of all the attributes which are not returned
   by get-attribute-list. This list is here to preserve compatibility with
   ADM Version 1.0 (Progress V8.0). If an object has no value for
   the preprocessor ADM-ATTRIBUTE-LIST, which is the list of all attributes
   which *should* be returned by get-attribute-list, then get-attribute-list
   will return all object attributes which are not in adm-non-list-attrs. */

DEFINE VARIABLE adm-non-list-attrs AS CHARACTER NO-UNDO.
  adm-non-list-attrs = adm-basic-attrs +
  ",PROSPY-HANDLE,ADM-CONTAINER-EXTERNAL-TABLES,~
KEYS-ACCEPTED,KEYS-SUPPLIED":U.

/* These preprocessors hold the index of each basic attribute into
   the list of attribute held by the SmartObject procedure's ADM-DATA. 
   Note: no values for CONTAINER-HIDDEN and ADM-CONTAINER-EXTERNAL-TABLES,
   which are calculated dynamically. */

&GLOB VERSION-INDEX                 1
&GLOB TYPE-INDEX                    2
&GLOB CONTAINER-TYPE-INDEX          3
&GLOB QUERY-OBJECT-INDEX            4
&GLOB EXTERNAL-TABLES-INDEX         5
&GLOB INTERNAL-TABLES-INDEX         6
&GLOB ENABLED-TABLES-INDEX          7
&GLOB ADM-OBJECT-HANDLE-INDEX       8
&GLOB ADM-ATTRIBUTE-LIST-INDEX      9 
&GLOB SUPPORTED-LINKS-INDEX        10
&GLOB ADM-DISPATCH-QUALIFIER-INDEX 11
&GLOB ADM-PARENT-INDEX             12
&GLOB LAYOUT-INDEX                 13
&GLOB ENABLED-INDEX                14
&GLOB HIDDEN-INDEX                 15
&GLOB CONTAINER-HIDDEN-INDEX       16
&GLOB INITIALIZED-INDEX            17
&GLOB FIELDS-ENABLED-INDEX         18
&GLOB CURRENT-PAGE-INDEX           19
&GLOB ADM-NEW-RECORD-INDEX         20
&GLOB UIB-MODE-INDEX               21
&GLOB ADM-DEACTIVATE-LINKS-INDEX   22
&GLOB DUMMY-INDEX                  23  
/* The dummy index preserves the end of the list, and these temp vars are
   used by set-attr.i etc. in parsing the list. */
DEFINE VARIABLE adm-tmp-pos1  AS INTEGER   NO-UNDO.
DEFINE VARIABLE adm-tmp-pos2  AS INTEGER   NO-UNDO.
DEFINE VARIABLE adm-tmp-index AS INTEGER   NO-UNDO.
DEFINE VARIABLE adm-tmp-str   AS CHARACTER NO-UNDO.
