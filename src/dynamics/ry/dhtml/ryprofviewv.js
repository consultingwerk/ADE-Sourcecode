function buLaunch(){
  win=window.open('default.htm?icfobj=' + document.getElementById("cCont").value);
}

function buClose(){
  win.close();
}

function newDescription(){
  var call, target, flags, params;
  call   = 'setProfilerAttrs'; // procedure or function to run
  target = 'SessionManager'; //program to run
  flags  = 's'; // Dynamic Call Wrapper flags
  op     = "DESCRIPTION="+document.getElementById("fiDescription").value;
  params =          "input logical no \t";
  params = params + "input character '"+op+"'";
  apph.runOnServer(call,target,flags,params);
}

function newFileName(){
  var call, target, flags, params;
  call   = 'setProfilerAttrs'; // procedure or function to run
  target = 'SessionManager'; //program to run
  flags  = 's'; // Dynamic Call Wrapper flags
  op     = "FILE-NAME="+document.getElementById("fiFileName").value;
  params =          "input logical no \t";
  params = params + "input character '"+op+"'";
  apph.runOnServer(call,target,flags,params);
}

function newDirectory(){
  var call, target, flags, params;
  call   = 'setProfilerAttrs'; // procedure or function to run
  target = 'SessionManager'; //program to run
  flags  = 's'; // Dynamic Call Wrapper flags
  op     = "DIRECTORY="+document.getElementById("fiDirectory").value;
  params =          "input logical no \t";
  params = params + "input character '"+op+"'";
  apph.runOnServer(call,target,flags,params);
}

function newTraceFilter(){
  var call, target, flags, params;
  call   = 'setProfilerAttrs'; // procedure or function to run
  target = 'SessionManager'; //program to run
  flags  = 's'; // Dynamic Call Wrapper flags
  op     = "TRACE-FILTER="+document.getElementById("fiTraceFilter").value;
  params =          "input logical no \t";
  params = params + "input character '"+op+"'";
  apph.runOnServer(call,target,flags,params);
}

function newTracing(){
  var call, target, flags, params;
  call   = 'setProfilerAttrs'; // procedure or function to run
  target = 'SessionManager'; //program to run
  flags  = 's'; // Dynamic Call Wrapper flags
  op     = "TRACING="+document.getElementById("fiTracing").value;
  params =          "input logical no \t";
  params = params + "input character '"+op+"'";
  apph.runOnServer(call,target,flags,params);
}

function newEnabled(){
  var call, target, flags, params;
  call   = 'setProfilerAttrs'; // procedure or function to run
  target = 'SessionManager'; //program to run
  flags  = 's'; // Dynamic Call Wrapper flags
  op     = "ENABLED="+document.getElementById("fiEnabled").value;
  params =          "input logical no \t";
  params = params + "input character '"+op+"'";
  apph.runOnServer(call,target,flags,params);
}

function newListings(){
  var call, target, flags, params;
  call   = 'setProfilerAttrs'; // procedure or function to run
  target = 'SessionManager'; //program to run
  flags  = 's'; // Dynamic Call Wrapper flags
  op     = "LISTINGS="+document.getElementById("fiListings").value;
  params =          "input logical no \t";
  params = params + "input character '"+op+"'";
  apph.runOnServer(call,target,flags,params);
}

function newCoverage(){
  var call, target, flags, params;
  call   = 'setProfilerAttrs'; // procedure or function to run
  target = 'SessionManager'; //program to run
  flags  = 's'; // Dynamic Call Wrapper flags
  op     = "COVERAGE="+document.getElementById("fiCoverage").value;
  params =          "input logical no \t";
  params = params + "input character '"+op+"'";
  apph.runOnServer(call,target,flags,params);
}

function newProfiling(){
  var call, target, flags, params;
  if(document.getElementsByName("raProfiling")[0].checked==true)
    call = 'startProfiling'; // procedure or function to run
  else
    call = 'stopProfiling'; // procedure or function to run
  target = 'SessionManager'; //program to run
  flags  = 's'; // Dynamic Call Wrapper flags
  params = "input logical no";
  apph.runOnServer(call,target,flags,params);
}

function refreshValues(){
  var call, target, flags, params;
  call   = 'refreshValues'; // procedure or function to run
  target = 'ry/prc/ryprofplipp.p'; //program to run
  flags  = 's'; // Dynamic Call Wrapper flags
  params = "";
  apph.runOnServer(call,target,flags,params);
}

function displayValues(pvalue){
  val=pvalue.split("|");
  for(i=0;i<val.length;i++)
    switch(i){
      case 0: document.getElementById("fiDescription").value=val[i]; break;
      case 1: document.getElementById("fiFileName").value=val[i]; break;
      case 2: document.getElementById("fiDirectory").value=val[i]; break;
      case 3: document.getElementById("fiTraceFilter").value=val[i]; break;
      case 4: document.getElementById("fiTracing").value=val[i]; break;
      case 5: document.getElementById("toEnabled").checked=eval(val[i]); break;
      case 6: document.getElementById("toListings").checked=eval(val[i]); break;
      case 7: document.getElementById("toCoverage").checked=eval(val[i]); break;
      case 8: if(val[i]=="true")
                document.getElementsByName("raProfiling")[0].checked=true;
              else
                document.getElementsByName("raProfiling")[1].checked=true;
   }
}

function refresh(){
  apph.action("tool.buFiles.hide");
  document.getElementsByName("rarunonserver")[0].checked=true;
  document.getElementsByName("raRunOnServer")[0].disabled=true;
  document.getElementsByName("raRunOnServer")[1].disabled=true;
  refreshValues();
}