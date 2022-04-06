/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _delet_u.p

Description:
   Procedure file that uses delete_u.i.   Delete_u.i was getting very big
   so this procedure lets us replace it with an external call. 
ame
Input Parameters:
   p_Urecid -  Recid of _U to be deleted.
   p_TRASH  -  True if objects are to be truely deleted, else select the objects
               as being deleted. 

Output Parameters:
   <None>
       
Author: Wm. T. Wood

Created: 3/95
Updated: 12/9/97 adams added WebSpeed support

----------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER p_Urecid AS RECID NO-UNDO.
DEFINE INPUT PARAMETER p_TRASH  AS LOGICAL NO-UNDO.

DEFINE SHARED VAR _h_menubar_proc  AS HANDLE   NO-UNDO. /* Dynamics prop sheet */
{adeuib/uniwidg.i}   /* Universal Widget Records */
{adeuib/layout.i}    /* Layout information */
{adeuib/brwscols.i}  /* Browse column definitions */
{adeuib/triggers.i}  /* Triggers */
{adeuib/links.i}     /* Links */
{adeuib/xftr.i}      /* XFTR's */
{adeweb/htmwidg.i}   /* WebSpeed _HTM temp-table */


/* Find a _U record and delete it */
FIND _U WHERE RECID(_U) eq p_Urecid.
{ adeuib/delete_u.i &TRASH = p_TRASH }

/* _delet_u.p - end of file */
