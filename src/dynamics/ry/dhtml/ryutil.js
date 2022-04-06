//  File:         ryutil.js
//  Description:  Implements Generic utilities

function runOnServer(call,targ,flag,prm){
  // Encode periods in file path
  call = dotEncode(call);
	targ = dotEncode(targ);

	if (call == '') call = ' ';
	if (targ == '') targ = ' ';
	if (flag == '') flag = ' ';
  /*
	alert("[runOnServer]\n\n" +
	      "call=" + call + "\n" +
	      "targ=" + targ + "\n" +
	      "flag=" + flag + "\n" +
	      "prm=" + prm + "\n\n" +
	      "server."+call+"."+targ+".run."+flag+".\t"+prm);
	*/
	// TBD: Parameter delimiter (tab) needs to be replaced with an unprintable character
  actions(["server."+call+"."+targ+".run."+flag+".\t"+prm,'wbo.submit']);
}

// Convert to value that Javascript can deal with
function strip(val,test){   
  val+='';
  switch (test){
    case 'dec':
    case 'int':
      var re=new RegExp('[^0-9\\'+appcontrol.numformat+'\\-]','g');
      return val.replace(re,'').replace(appcontrol.numformat,'.');
    case 'date':
      if(val=='') return '';
      var a=val.match(/(\D*)(\d*)(\D*)(\d*)(\D*)(\d*)(\D*)/);
      if(a.length<8) return 'error';
      var mdy=appcontrol.dateformat;
      return (a[mdy.indexOf('m')*2+2]+'/'+a[mdy.indexOf('d')*2+2]+'/'+a[mdy.indexOf('y')*2+2]);
    default:
  }
  return val;
}

// Value format for saving 
function saveformat(val,test){   
  val+='';
  switch (test){
    case 'dec':
    case 'int':
      var re=new RegExp('[^0-9\\'+appcontrol.numformat+'\\-]','g');
      return val.replace(re,'');
    case 'date':
      if(val=='') return '';
      var a=val.match(/(\D*)(\d*)(\D*)(\d*)(\D*)(\d*)(\D*)/);
      if(a.length<8) return 'error';
      var mdy=appcontrol.dateformat;
      return (a[2]+'/'+a[4]+'/'+a[6]);
    default:
  }
  return val;
}

// Convert from value to regional string format
function format(val,test){
  switch (test){
    case 'dec':
    case 'int':
      val+='';
      return val.replace('.',appcontrol.numformat);
    case 'date':
      if(val=='') return '';
      val=new Date(val);
      var mdy=appcontrol.dateformat;
      var b=new Array(3);
      b[mdy.indexOf('m')]=val.getMonth()+1;
      b[mdy.indexOf('d')]=val.getDate();
      b[mdy.indexOf('y')]=val.getFullYear();
      return (b.join('/'));
    default:
  }
  return ''+val;
}

function formatMenuLabel(a){
  return a.replace(/&{1}([\w])/g,"<u>$1</u>").replace(/&{2}/g,"&amp;");   
  // swap && with html & and underline other characters prefixed with &
}

function escapedata(a){
  return a.replace(/\r/g,'');   // get rid of automatically inserted Carriage-returns
}

function fixEvent(e){
  if(document.all){
/*
    if(!e){
      e=(window.event?window.event:window.app.event);
      //return alert('Event unknown');
      return alert(window.action('info.get|HTM21||')); //ok
    }
*/
    e.target=e.srcElement;
    e.returnValue=false;
    e.cancelBubble=true;
  } else {
    e.stopPropagation();
    e.preventDefault();
  }
  return e;
}

function dotEncode(val) {
  return (val==null?'':val.replace('.','..'));
}

function fContains(ch,el){
  while (ch.nodeName!='BODY') {
    ch=ch.parentNode;
    if(ch==el) return true;
  }
  return false;
}
