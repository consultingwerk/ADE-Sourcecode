/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: pre_proc.i

Description:
   UIB pre-procesor definitions

Input Parameters:
   <None>

Output Parameters:
   <None>

Author: D. Ross Hunter

Date Created: 1992   

Last modified by GFS on 9/29/94 - Added XFTR support

----------------------------------------------------------------------------*/
&GLOBAL-DEFINE WIDGET-COUNT-DIMENSION 15
&GLOBAL-DEFINE BRWSR                   1
&GLOBAL-DEFINE BTN                     2
&GLOBAL-DEFINE CBBOX                   3
&GLOBAL-DEFINE DIALG                   4
&GLOBAL-DEFINE EDITR                   5
&GLOBAL-DEFINE FILLN                   6
&GLOBAL-DEFINE FRAME                   7
&GLOBAL-DEFINE IMAGE                   8
&GLOBAL-DEFINE RADIO                   9
&GLOBAL-DEFINE RECT                   10
&GLOBAL-DEFINE SELCT                  11
&GLOBAL-DEFINE SLIDR                  12
&GLOBAL-DEFINE TEXT                   13
&GLOBAL-DEFINE TOGGL                  14
&GLOBAL-DEFINE WINDW                  15

&GLOBAL-DEFINE DIR-DIMENSION           6
&GLOBAL-DEFINE ICON-DIRS               _directory[1]
&GLOBAL-DEFINE TEMPLATE-DIRS           _directory[2]
&GLOBAL-DEFINE WIDGET-DIRS             _directory[3]
&GLOBAL-DEFINE CODE-DIRS               _directory[4]
&GLOBAL-DEFINE CUSTOM-FILES            _directory[5]
&GLOBAL-DEFINE XFTR-FILE               _directory[6]

/* Sections being written out that XFTR's need to know about */
&GLOBAL-DEFINE TOPOFFILE                -1
&GLOBAL-DEFINE DEFINITIONS              -2
&GLOBAL-DEFINE STDPREPROCS              -3
&GLOBAL-DEFINE CONTROLDEFS              -4
&GLOBAL-DEFINE RUNTIMESET               -5
&GLOBAL-DEFINE INCLUDED-LIB             -6
&GLOBAL-DEFINE CONTROLTRIG              -7
&GLOBAL-DEFINE MAINBLOCK                -8
&GLOBAL-DEFINE INTPROCS                 -9

&GLOBAL-DEFINE ImageSize                24
&GLOBAL-DEFINE LabelSize                100

&GLOBAL-DEFINE WVT-CONTROL              VBX
&GLOBAL-DEFINE WVL-CONTROL              VBX-Controls

&GLOBAL-DEFINE WVT-CONTAINER            CONTROL-CONTAINER
&GLOBAL-DEFINE WVL-CONTAINER            Container

&GLOBAL-DEFINE WT-CONTROL               OCX
&GLOBAL-DEFINE WL-CONTROL               OCX-Controls

&GLOBAL-DEFINE WT-CONTAINER             CONTROL-FRAME
&GLOBAL-DEFINE WL-CONTAINER             Container
&GLOBAL-DEFINE WS-TEMPTABLE             ab_unmap

&GLOBAL-DEFINE UIB-PRIVATE              UIB/_U
&GLOBAL-DEFINE AB_Pool                  _ADE_AB-Main
