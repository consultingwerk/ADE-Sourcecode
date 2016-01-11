/*--------------------------------------------------------------------
 
File: prodict/mss/_genrowid.p
 
Description:
    wrapper to prodict/mss/genrowid.i, which generates constraint entries in original
    PROGRESS-DB based on ROWID's selected in SI 
 
 
Input-Parameters:
    none
 
Output-Parameters:
    none
 
History:
    06/11   ashukla    created
 
 
--------------------------------------------------------------------*/
/*h-*/
 
/*----------------------------  DEFINES  ---------------------------*/
 
{ prodict/mss/mssvar.i NEW }
{ prodict/mss/genrowid.i
  &edb-type = "MSS"}

