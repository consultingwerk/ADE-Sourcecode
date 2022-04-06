/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*

Procedure:    adetran/pm/_pmstats.p
Author:       R. Ryan
Created:      1/95 
Updated:      9/95
		12/96 SLK Long Filename
Purpose:      Statistics tab procedure
Background:   This is a persistent procedure that is run from
              pm/_pmmain.p *only* after a database is connected.
              Once connected, this procedure has the browser
              associated with the statistics functions. 
Notes:        Each time the statistics tab is selected, the
              underlying temp-table is re-populated with statistical
              information and the query is re-opened. Once useful
              statistics is the size of the kit database just in
              case it closes in on the 8mb DOS limit.
Procedures:   key procedures include:   
                Realize         enables the browse and opens the
                                query.
                GetByteSize     scans the size of the kit database.
                SetStatistics   If specified, it deletes the temp-table 
                                then reads
                                various kit tables and sets the 
                                statistics.    
Called By:    pm/_pmmain.p
*/


&Scoped-define frame-NAME Statsframe

define shared var _MainWindow as widget-handle no-undo.
DEFINE SHARED VAR tModFlag AS LOGICAL NO-UNDO. 
DEFINE VARIABLE ByteSize AS DECIMAL NO-UNDO.
DEFINE VARIABLE last-sq  AS INTEGER NO-UNDO.
DEFINE VARIABLE unused   AS INTEGER NO-UNDO.
DEFINE VARIABLE indentValue AS INTEGER NO-UNDO.
 
DEFINE TEMP-TABLE stats NO-UNDO
       FIELD seq-num   AS INTEGER
       FIELD ItemIndent AS INTEGER 
       FIELD Item      AS CHARACTER
       FIELD ItemValue AS CHARACTER
    INDEX seq-num IS PRIMARY UNIQUE seq-num
    INDEX item Item.

define query StatsBrowse for stats scrolling.

define browse StatsBrowse query StatsBrowse NO-LOCK
  display
    Stats.Item width 42 FORMAT "x(256)"
    Stats.ItemValue width 70 FORMAT "x(256)"
  enable
    Stats.Item 
    Stats.ItemValue
  with no-labels size-pixels 602 BY 299 
  bgcolor 8 font 4 title bgcolor 8 "Statistics".

define frame Statsframe
  StatsBrowse AT Y 0 X 0       
  with 1 down no-box overlay side-labels no-underline three-d
  at x 14 y 52 size-p 602 by 299 font 4.

ON ANY-KEY OF Stats.Item IN BROWSE StatsBrowse DO:
  IF NOT CAN-DO("CURSON-*,END,HOME,TAB", KEYLABEL(LASTKEY)) THEN RETURN NO-APPLY.
END.
ON ANY-KEY OF Stats.ItemValue IN BROWSE StatsBrowse DO:
  IF NOT CAN-DO("CURSON-*,END,HOME,TAB", KEYLABEL(LASTKEY)) THEN RETURN NO-APPLY.
END.
 
/* 
** Main Block  
*/
&SCOPED-DEFINE FRAME-NAME StatsFrame
{adetran/common/noscroll.i}

pause 0 before-hide.

main-block:
do on error undo main-block, leave main-block
  on end-key undo main-block, leave main-block: 
end.
{adecomm/_adetool.i}

/*
** Procedures
*/

procedure GetByteSize :
  define var TestFileName as char no-undo.
   
  assign  
    TestFileName       = if num-entries(pdbname("xlatedb"),".") = 1 then
                         pdbname("xlatedb") + ".db"
                         else pdbname("xlatedb")                               
    file-info:filename = TestFileName
    TestFileName       = file-info:full-pathname.
 
  if TestFileName = ? then do:
    ByteSize = 0.
    return.
  end.

  input from value(TestFileName).
  
  seek input to end.
  ByteSize = seek(input). 
  input close.    
end procedure.



procedure HideMe :
  frame Statsframe:hidden = true.
end procedure.

procedure OpenQuery :
  open query StatsBrowse for each Stats no-lock.
end procedure.

PROCEDURE Realize :
  DEFINE VARIABLE ErrorStatus AS LOGICAL NO-UNDO.
  DEFINE VARIABLE ThisMessage AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lNeedUpdate AS LOGICAL   NO-UNDO INIT no.

  ENABLE ALL WITH FRAME Statsframe IN WINDOW _MainWindow.
  RUN ViewStats (INPUT NO).

  FIND FIRST stats WHERE TRIM(stats.item) = "Last Updated" NO-LOCK NO-ERROR.
  IF NOT AVAILABLE stats THEN
    lNeedUpdate = yes. 

  FIND FIRST xlatedb.XL_Project NO-LOCK NO-ERROR.
  IF AVAILABLE xlatedb.XL_Project THEN DO:
    IF (AVAILABLE stats AND stats.itemvalue NE STRING(xlatedb.XL_Project.UpdateDate)) OR
       (NUM-ENTRIES(xlatedb.XL_Project.ProjectRevision, CHR(4)) > 1 AND
        ENTRY(2, xlatedb.XL_Project.ProjectRevision, CHR(4)) = "no":U) OR
       tModFlag = yes
      THEN lNeedUpdate = yes.
  END.  /* If there is more than 1 entry */

  IF NOT lNeedUpdate THEN
    RUN SetStatistics (INPUT NO).  /* Just reopen the query */
  ELSE
  DO:
    ASSIGN ThisMessage =  
      "Statistic data may not be current. If you have a large project, it may take some time to recalculate the data. Recalculate?". 
    RUN adecomm/_s-alert.p (INPUT-OUTPUT ErrorStatus, "q":U, "ok-cancel":U, ThisMessage).
    IF ErrorStatus <> ? THEN 
    DO:
      RUN adetran/pm/_pmrecnt.p (INPUT _MainWindow).
      RUN SetStatistics (INPUT YES).
    END.
    ELSE
      RUN SetStatistics (INPUT NO).
  END.

  FRAME Statsframe:HIDDEN = no.
END PROCEDURE.

PROCEDURE SetStatistics :
  DEFINE INPUT PARAMETER p-clear AS LOGICAL NO-UNDO.
  DEFINE VAR i AS INTEGER NO-UNDO.  
       
  FIND FIRST stats NO-ERROR.
  IF NOT p-clear AND AVAILABLE stats THEN
  DO:
    RUN OpenQuery. 
    RUN ViewStats (INPUT YES).
    RETURN.
  END. /* NOT p-clear */

  /*
  ** Clear out old statistics from the temp table
  */
  FOR EACH stats:
    DELETE stats NO-ERROR.
  END.
  last-sq = 0.
  
  FIND FIRST xlatedb.XL_Project NO-LOCK NO-ERROR.
  IF AVAILABLE xlatedb.XL_Project THEN
  DO: 
    RUN adecomm/_setcurs.p ("wait").

    /*
    ** Get the bytes of the database
    */
    RUN GetByteSize.
    
    create stats. 
    assign last-sq   = last-sq + 1
           seq-num   = last-sq
	   indentValue = 0
	   ItemIndent = indentValue
           Item      = FILL(" ":U,indentValue) + "PROJECT INFORMATION:" 
           ItemValue = "":U.
        
    create stats. 
    assign last-sq   = last-sq + 1
           seq-num   = last-sq
	   indentValue = 4
	   ItemIndent = indentValue
           Item      = FILL(" ":U,indentValue) + "Project Name"             
           ItemValue = xlatedb.XL_Project.ProjectName.
        
    if xlatedb.XL_Project.ProjectDesc <> "" then do:        
      create stats. 
       assign last-sq   = last-sq + 1
              seq-num   = last-sq
	      indentValue = 4
	      ItemIndent = indentValue
              Item      = FILL(" ":U,indentValue) + "Description"
              ItemValue = xlatedb.XL_Project.ProjectDesc.   
    end.
               
    create stats.   
    assign last-sq   = last-sq + 1
           seq-num   = last-sq
	   indentValue = 4
	   ItemIndent = indentValue
           Item      = FILL(" ":U,indentValue) + "Revision"                 
           ItemValue = ENTRY(1, xlatedb.XL_Project.ProjectRevision, CHR(4)).
    /* ENTRY(1,,CHR(4)) is a hack to store is statistics have been updated */
               
    create stats. 
    assign last-sq   = last-sq + 1
           seq-num   = last-sq
	   indentValue = 4
	   ItemIndent = indentValue
           Item      = FILL(" ":U,indentValue) + "Create Date"              
           ItemValue = string(xlatedb.XL_Project.CreateDate). 
               
    create stats.   
    assign last-sq   = last-sq + 1
           seq-num   = last-sq
	   indentValue = 4
	   ItemIndent = indentValue
           Item      = FILL(" ":U,indentValue) + "Last Updated"             
           ItemValue = string(xlatedb.XL_Project.UpdateDate).
               
    create stats. 
    assign last-sq   = last-sq + 1
           seq-num   = last-sq
	   indentValue = 4
	   ItemIndent = indentValue
           Item      = FILL(" ":U,indentValue) + "Database Size (in Bytes)"     
           ItemValue = trim(string(ByteSize / 1000,">>>,>>>,>>9.9K")).

    create stats. 
    assign last-sq   = last-sq + 1
           seq-num   = last-sq
	   indentValue = 4
	   ItemIndent = indentValue
           Item      = FILL(" ":U,indentValue) + "Display Type".
    /* Modified since we maintain Sequence/Instance IDs
     *  xlatedb.XL_Project.DisplayType    
     *       DisplayType CHR(4) Sequence_Num CHR(4) Instance_Number
     */ 
    IF NUM-ENTRIES(xlatedb.XL_Project.DisplayType,CHR(4)) > 1 THEN
    DO:
       ASSIGN ItemValue = 
         IF ENTRY(1, xlatedb.XL_Project.DisplayType, CHR(4)) = "G":U
           THEN "Graphical"
         ELSE "Character".
    END.
    ELSE 
       ASSIGN ItemValue = IF xlatedb.XL_Project.DisplayType = "G":U
                            THEN "Graphical"
                          ELSE "Character".

    create stats. 
    assign last-sq   = last-sq + 1
           seq-num   = last-sq
	   indentValue = 4
	   ItemIndent = indentValue
           Item      = FILL(" ":U,indentValue)  + "Root Directory (Resource procedures)"           
           ItemValue = (if xlatedb.XL_Project.RootDirectory = "" 
                         then "None" 
                         else xlatedb.XL_Project.RootDirectory). 

    create stats. 
    assign last-sq   = last-sq + 1
           seq-num   = last-sq
	   indentValue = 4
	   ItemIndent = indentValue
           Item      = FILL(" ":U,indentValue) + "Environment Settings Files "           
           ItemValue = xlatedb.XL_Project.SettingsFile. 

    create stats.  
    assign last-sq   = last-sq + 1
           seq-num   = last-sq
	   indentValue = 4
	   ItemIndent = indentValue
           Item      = FILL(" ":U,indentValue) + "Number of procedures"     
           ItemValue = string(xlatedb.XL_Project.NumberOfprocedures).

    create stats. 
    assign last-sq   = last-sq + 1
           seq-num   = last-sq
	   indentValue = 4
	   ItemIndent = indentValue
           Item      = FILL(" ":U,indentValue) + "Number of Phrases"        
           ItemValue = string(xlatedb.XL_Project.NumberOfPhrases).
               
    create stats. 
    assign last-sq   = last-sq + 1
           seq-num   = last-sq
	   indentValue = 4
	   ItemIndent = indentValue
           Item      = FILL(" ":U,indentValue) + "Number of Unique Phrases" 
           ItemValue = string(xlatedb.XL_Project.NumberOfUniquePhrases).
               
    create stats. 
    assign last-sq   = last-sq + 1
           seq-num   = last-sq
	   indentValue = 4
	   ItemIndent = indentValue
           Item      = FILL(" ":U,indentValue)  + "Number of Words"          
           ItemValue = string(xlatedb.XL_Project.NumberOfWords). 
               
    create stats. 
    assign last-sq   = last-sq + 1
           seq-num   = last-sq
	   indentValue = 4
	   ItemIndent = indentValue
           Item      = FILL(" ":U,indentValue)  + "Number of Unique Words"   
           ItemValue = string(xlatedb.XL_Project.NumberOfUniqueWords).
      
    /*
    ** Now read through the list of glossaries and kits
    */                              
    create stats. 
    assign last-sq   = last-sq + 1
           seq-num   = last-sq
           Item      = "":U
           ItemValue = "":U.
      
    create stats. 
    assign last-sq   = last-sq + 1
           seq-num   = last-sq
	   indentValue = 0
	   ItemIndent = indentValue
           Item      = FILL(" ":U,indentValue) + "KIT STATUS:"   
           ItemValue = "":U.

    for each xlatedb.XL_Kit no-lock:   
      create stats.
      assign last-sq   = last-sq + 1
             seq-num   = last-sq
	   indentValue = 4
	   ItemIndent = indentValue
             Item      = FILL(" ":U,indentValue)  + "KIT: " + xlatedb.XL_Kit.Kitname
             ItemValue = xlatedb.XL_Kit.LanguageName.
      FIND xlatedb.XL_Glossary WHERE
              xlatedb.XL_Glossary.GlossaryName = xlatedb.XL_Kit.GlossaryName
           NO-LOCK NO-ERROR.
      IF AVAILABLE xlatedb.XL_Glossary THEN DO:
        CREATE stats.
        assign last-sq   = last-sq + 1
               seq-num   = last-sq
               indentValue = 11
               ItemIndent = indentValue
               Item      = FILL(" ":U,indentValue)  + "Glossary: " + xlatedb.XL_Glossary.GlossaryName   
               ItemValue = xlatedb.XL_Glossary.GlossaryType + " (" +
                                string(xlatedb.XL_Glossary.GlossaryCount) + " entries)".
      END.

      FOR EACH xlatedb.XL_Kit-Proc WHERE
                  xlatedb.XL_Kit-Proc.KitName = xlatedb.XL_Kit.KitName NO-LOCK:
        CREATE stats.
        ASSIGN last-sq   = last-sq + 1
               seq-num   = last-sq
 	       indentValue = 15
               ItemIndent = indentValue
               Item      = FILL(" ":U,indentValue) + xlatedb.XL_Kit-Proc.FileName
               ItemValue = xlatedb.XL_Kit-Proc.CurrentStatus.
      END. /* For each kit-proc */ 
      create stats. 
      assign last-sq   = last-sq + 1
             seq-num   = last-sq
             Item      = "":U
             ItemValue = "":U.
    end. /* For each kit */
    
    /* Unused glossaries */
    create stats. 
    assign last-sq   = last-sq + 1
           unused    = 0
           seq-num   = last-sq
	   indentValue = 0
	   ItemIndent = indentValue
           Item      = FILL(" ":U,indentValue) + "UNUSED GLOSSARIES:"   
           ItemValue = "":U.
      
    for each xlatedb.XL_Glossary WHERE
         NOT CAN-FIND(FIRST xlatedb.XL_Kit WHERE 
                      xlatedb.XL_Kit.GlossaryName = xlatedb.XL_Glossary.GlossaryName) no-lock:
      create stats. 
      assign last-sq   = last-sq + 1
             unused    = unused + 1
             seq-num   = last-sq
	   indentValue = 6
	   ItemIndent = indentValue
             Item      = FILL(" ":U,indentValue) + xlatedb.XL_Glossary.GlossaryName + " Glossary"    
             ItemValue = xlatedb.XL_Glossary.GlossaryType + " (" +
                           string(xlatedb.XL_Glossary.GlossaryCount) + " entries)".
    end.
    IF unused = 0 THEN DO:
      create stats. 
      assign last-sq   = last-sq + 1
             seq-num   = last-sq
	   indentValue = 5
	   ItemIndent = indentValue
             Item      = FILL(" ":U,indentValue) + "- None":U
             ItemValue = "":U.
    END. /* If no unused glossaries */

    RUN ViewStats (INPUT YES).
    RUN adecomm/_setcurs.p ("").
  END. /* If the project record is available */

  ASSIGN StatsBrowse:MAX-DATA-GUESS IN FRAME StatsFrame = last-sq.
  RUN OpenQuery. 
END PROCEDURE.

procedure EnableFrame :   
  define input parameter pMode as logical no-undo.
  frame {&frame-name}:sensitive = pMode.
end procedure.

PROCEDURE ViewStats:
  DEFINE INPUT PARAMETER plView AS LOGICAL NO-UNDO.  /* View statistics? */

  StatsBrowse:HIDDEN IN FRAME Statsframe = NOT plView.  
END PROCEDURE.

PROCEDURE print_statistics:
  {adetran/common/pr_stats.i "xlatedb.XL_Project.ProjectName"}
END PROCEDURE.
