//  File:         ryinfo.js
//  Description:  Implements  Info Object


Info.prototype.elem;
Info.prototype.msgs;

function Info(e){
  this.elem=e;
  var node=document.createElement('b');
  node.appendChild(document.createTextNode('Messages:'));
  e.appendChild(node);
  e.oncontextmenu=function(e){window.fixEvent(e?e:window.event);window.action('main.info.hide');}
  e.setAttribute('ondblclick',"window.action('info.clear')");  // Mozilla
  e.ondblclick=function(e){window.action('info.clear');}       // IE
}

Info.prototype.load=function(data){
  this.msgs=data;
  /*
  this.msgs=data.concat(
     'HTM14|Filter values;Save settings;From:;To:;OK;Cancel;Clear'
    ,'HTM15|Find record criteria;From:;To:;OK;Cancel;Clear'
    ,'HTM16|From:;To:;'
    ,'HTM17|Record has changed!\nWould you like to overwrite the other changes?'
    ,'HTM18|User input:Yes:No:Cancel:OK'
    ,'HTM19|Invalid data for &1 = &2'
    ,'HTM20|Number of rows of data');
  */
}

Info.prototype.action=function(c,prm){
  with(this){
    var a=(prm+'|||||').split('|');
    var msg=a[1];

    if(a[1]==''){ // Override with localized messages
      for(var i=0;i<msgs.length;i++){  
        if(msgs[i].split('|')[0]==a[0]){
          msg=msgs[i].split('|')[1];
          break; 
        }
      }
    }

    if(msg=='') msg='Undefined message ('+a[0]+').';
    msg=msg.replace('&1',a[2]).replace('&2',a[3])
    msg=msg.replace('&3',a[4]).replace('&4',a[5])
    var msg2=msg.replace('\n','<br>');
    
    switch(c){
    case 'clear':   
      while(elem.hasChildNodes()) elem.removeChild(elem.lastChild);
      return;
    case 'get':  
      return msg;
    case 'msg':  
      window.action('main.info.show');
      return addText(c,msg2);
    case 'field':  
      window.action('main.info.show');
      addText(c,msg2);
      return window.action(a[2] + '.mark');
    case 'alert':  
      window.action('main.info.show');
      addText(c,msg2);
      return alert(msg);
    case 'prompt':   
      return prompt(msg,a[2]);
    case 'confirm':   
      if (confirm(msg)){
        window.action(a[2]);
        return true;
      }  
      return false;
    case 'yesno':   
      window.returnValue=msg;
      window.action('util.../dhtml/ryyesno.htm');
      switch(window.returnValue){
       case 'yes':
      	window.action(a[2]);
        return true;
       case 'no':
      	window.action(a[3]);
        return true;
      }
      return false;
    case 'yesnocancel':   
      window.returnValue=msg;
      window.action('util.../dhtml/ryyesno.htm');
      return true;
    default:
      //alert(c + ' for INFO not implemented yet!');
      alert(window.action('info.get|HTM20||'+c+'|INFO')); //ok
    }
  }
}

Info.prototype.addText=function(c,msg){
  var node=document.createElement('nobr');
  node.className=c;
  node.appendChild(document.createTextNode(msg));
  this.elem.appendChild(document.createElement('br'));
  this.elem.appendChild(node);
  this.elem.lastChild.scrollIntoView();
}	

info=new Info(maindoc.getElementById('info'));
