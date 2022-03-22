/***********************************************************************
* Copyright (C) 2000,2010 by Progress Software Corporation. All rights *
* reserved. Prior versions of this work may contain portions           *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/
/****************************************************************************
     PROCEDURE: attribut.i

       PURPOSE: holds general-use variable and table definitions
                for ADM Method Libraries

       REMARKS:

    PARAMETERS: NONE

      HISTORY:
*****************************************************************************/

&IF DEFINED (adm-attribut) = 0 &THEN   /* Make sure not already included */
&GLOB adm-attribut yes

&GLOB      adm-version ADM1.1


/* These preprocessors were added to deal with 8.0 and 8.1 diffferences 
   The version check was removed in v11.
   ADM-DATA is used to store ADM attributes and other ADM-specific information. 
   UNLESS-HIDDEN allows a DISPLAY/ENABLE to bypass fields which are hidden. 
   This is used in building alternate layouts. */
 &GLOB    adm-data      ADM-DATA
 &GLOB    unless-hidden UNLESS-HIDDEN

DEFINE VAR adm-object-hdl       AS HANDLE NO-UNDO. /* current object's handle */
DEFINE VAR adm-query-opened        AS LOGICAL NO-UNDO INIT NO.
DEFINE VAR adm-row-avail-state     AS LOGICAL NO-UNDO INIT ?.
DEFINE VAR adm-initial-lock        AS CHARACTER NO-UNDO INIT "NO-LOCK":U.
DEFINE VAR adm-new-record          AS LOGICAL NO-UNDO INIT no.
DEFINE VAR adm-updating-record     AS LOGICAL NO-UNDO INIT no.
DEFINE VAR adm-check-modified-all  AS LOGICAL NO-UNDO INIT no.

DEFINE NEW GLOBAL SHARED VAR adm-broker-hdl    AS HANDLE  NO-UNDO.

&ENDIF

