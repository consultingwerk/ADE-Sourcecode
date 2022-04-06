//  File:         rywizard.js
//  Description:  Implements Paged wizard flows

function Wizard() {
}

Wizard.prototype.init=function(e){
  with(this){
    var enabled=e.getAttribute('enabled').split('|');
    var aNames=e.getAttribute('tabs').split('|');
    app.page=app.document.body.getAttribute('startpage');
    
    var c='',add='',iBack=0;
    for (var i=0;i<aNames.length;i++){
      if(enabled[i]=='no') continue;
      if(!app.page) app.page=(i+1);
      c+=add.replace('wbo.page.changepage','wbo.'+(i+1)+'.changepage')
        +'\n<div class="layout '+(app.page==i+1?'show':'hide')+'" page='+(i+1)+'>';
      if(iBack>0) c+='<button class="tool enable" id="wbo.'+iBack+'.changepage"> Back to '+aNames[i-1]+' </button>'
      iBack=i+1;
      add='<button class="tool enable" id="wbo.page.changepage"> Continue to '+aNames[i+1]+' </button></div>';
    }
    e.innerHTML=c+'</div>';
  }  
}	
