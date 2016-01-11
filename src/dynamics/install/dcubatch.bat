@echo off
SET DLC=c:\apps\progress\91e
SET PATH=%DLC%;%DLC%\bin;%PATH%

:CHECKPHASE1ERRFILE
   echo Starting DCU Phase 1...
   if exist dcuphase1err.txt goto DELPHASE1ERRFILE
   goto PROCESSPHASE1

:DELPHASE1ERRFILE
   del dcuphase1err.txt

:PROCESSPHASE1
   SET DISPBANNER=no
   call mbpro -b -p dcuphase1.p -ini dcubatch.ini -pf dcuphase1.pf 
   if exist dcuphase1err.txt goto PHASE1FAILED
   echo DCU Upgrade Phase 1 Successful.
   goto CHECKPHASE2ERRFILE

:PHASE1FAILED
  echo *** DCU Upgrade Phase 1 Failed. Please see log file for more information.
  type dcuphase1err.txt
  del dcuphase1err.txt
  goto CLEANUP

:CHECKPHASE2ERRFILE
   echo Starting DCU Phase 2...
   if exist dcuphase2err.txt goto DELPHASE2ERRFILE
   goto PROCESSPHASE2

:DELPHASE2ERRFILE
   del dcuphase2err.txt
  
:PROCESSPHASE2
   SET DISPBANNER=no
   call mbpro -b -p dcuphase2.p -ini dcubatch.ini -pf dcuphase2.pf 
   if exist dcuphase2err.txt goto PHASE2FAILED
   echo DCU Upgrade Phase 2 Successful.
   goto CLEANUP

:PHASE2FAILED
  echo *** DCU Upgrade Phase 2 Failed. Please see log file for more information.
  type dcuphase2err.txt
  del dcuphase2err.txt
  goto CLEANUP
  

:CLEANUP
set DISPBANNER=
:END
