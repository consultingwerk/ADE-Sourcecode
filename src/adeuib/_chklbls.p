/***********************************************************************
* Copyright (C) 2005,2007 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/
/*----------------------------------------------------------------------------

File: _chklbls.p

Description: Calculates the _frmx variable to draw fields in a container.

Input Paramaters:
    font - font of the frame the fields are being drawn into (_L._FONT)

Output Paramaters:
    none      

Author: Gerry Seidl

Date Created: 1995

Notes: Before 10.1C this program handled all the field types that could be added
       in the container, they could be SmartDataObject fields, SmartBussinesObjects fields, or
       DB fields dropped from the 'DB Fields tool'.
       Due to the introduction of DataViews, include files could be used now in order to
       select the SmartDataViewer fields. This new feature raises a bug
       reported in OE00119743 "Cannot create SDV w/ include without db connection".

       In order to fix that bug, and starting in 10.1C this file was splitted
       in two more files. This file now, calls the appropiate file according to the
       field types that are being drawn in the container. The files to be called are:

       adeuib/_chklblsds.p: This is called when we are drawing files from a datasource,
                            the container in which the files are drawn is a viewer.
       adeuib/_chklblsdb.p: This is called when we are drawing database files
                            using the 'DB List' tool, the container in which
                            the files are drawn could be Windows, Dialogs,etc.
----------------------------------------------------------------------------*/
{adeuib/sharvars.i}
{adeuib/uniwidg.i}

DEFINE INPUT PARAMETER ffont AS INTEGER NO-UNDO. /* frame font */

DEFINE BUFFER b_P FOR _P.

FIND b_P WHERE b_P._WINDOW-HANDLE = _h_win NO-LOCK NO-ERROR.

IF NOT AVAILABLE(b_P) THEN RETURN.

   IF b_P._data-object NE "":U AND
      b_P._data-object NE ? THEN
       RUN adeuib/_chklblsds.p (INPUT ffont).
   ELSE
       RUN adeuib/_chklblsdb.p (INPUT ffont).

RETURN.