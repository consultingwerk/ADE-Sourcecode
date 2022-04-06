/*********************************************/
/****** Lookup functionality        **********/
/*********************************************/
Lookup.prototype.lookuptitle;
Lookup.prototype.lookupcols;
Lookup.prototype.lookuplabels;
Lookup.prototype.lookupdata;
Lookup.prototype.lookupdlm;
Lookup.prototype.lookupbatch;
Lookup.prototype.lookupval;

Lookup.prototype.init=function(title,cols,labels){
  this.lookuptitle=title;
  this.lookupcols=cols;
  this.lookuplabels=labels;
  app._lookup=this;
}

Lookup.prototype.load=function(data,dlm,batch){
  this.lookupdata=data;
  this.lookupdlm=dlm;
  this.lookupbatch=batch;
}

Lookup.prototype.launch=function(){
  app.document.form['do'].value='';
  if(this.lookupdata.length!=1)
    if(this.lookupval>'' || returnfield.value=='') appcontrol.markField(returnfield,'');
  if(this.lookupdata.length==0) return appcontrol.markField(returnfield,'error');
  if(this.lookupdata.length>1) return userAction('util.../dhtml/rylookup.htm|resize');
  this.setFields();
}

Lookup.prototype.setFields=function(){
  var cur=this.lookupdata[0].split(this.lookupdlm);
  app=appcontrol.activeframe.win;
  var names=('rowident|_key|'+this.lookupcols).split('|');
  var dfield=returnfield.getAttribute('dfield').split(',');
  appcontrol.markField(returnfield,'');
  var wdo=app['_'+returnfield.id.split('.')[0]];
  var idx='_'+returnfield.getAttribute('lookup').split('.')[0];
  var disp=cur[1];     // Displayedfield is stored in the "_key" field unless given other
  for(var i=0;i<dfield.length;i++){   // linked fields
    for(var j=2;j<names.length;j++){
	  var field=dfield[i].split('.').pop();
      if(names[j]==dfield[i]){
         // Loose widgets gets prefixed with "idx", datafields not
        if(i){
           try{
              // First test if it is a local field, otherwise it's a datafield
             wdo.action(idx+field+'.setinput',cur[j]); 
           } catch(e){
             wdo.action(field+'.setinput',cur[j]); 
           } 
        }
        else disp=cur[j]; // The displayfield
      }
    }
  }
  appcontrol.setField(returnfield,disp);
  // Setting Displayedfield and remember last selected 
  returnfield.setAttribute('select',disp);
  app.wbo.custom(returnfield.getAttribute('lookup').split('.')[0]+"_lookup");
  if(wdo) wdo.action('modify');
}

function Lookup(){}

var lookup = new Lookup();
