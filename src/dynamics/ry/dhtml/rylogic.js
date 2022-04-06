//  File:         rylogic.js
//  Description:  Implements Client Logic API

function Logic(e){}

Logic.prototype.setWidgetPrefix=function(fld){
  // Determine if 'widget' or 'tool' needs to be prefixed to field name. For internal use only.   var f=fld.split('.');
  fld=fld.toLowerCase();
  var f=fld.split('.');
  if(f.length==1) return 'tool.'+fld;
  if(f[0]=='browse'||f[0]=='tool'||f[0]=='viewer'||f[0]=='widget') return fld;
  return 'widget.'+fld;
}

Logic.prototype.assignFocusedWidget=function(fld){
  // Sets focus to a widget
  return action(this.setWidgetPrefix(fld)+'.focus');
}

Logic.prototype.assignWidgetValue=function(fld,val){
  // Sets a field's screen value
  return action(this.setWidgetPrefix(fld)+'.setinput|'+val);
}

Logic.prototype.assignWidgetValueList=function(flds,vals){
  // Sets screen value for a field list.  If any assignments fail because the 
  // widget is not found, FALSE is returned after list processing completes.
  var f=flds.split(',');
  var v=vals.split('|');
  var artn=true, rtn=true;
  var val;
  if(f.length!=v.length && v.length>1) return false;
  for (var i=0;i<f.length;i++){
    val=(v.length==1?v[0]:v[i]);
    artn=action(this.setWidgetPrefix(f[i])+'.setinput|'+val);
    rtn=rtn&&artn;
  }
  return rtn;
}

Logic.prototype.blankWidget=function(flds){
  // Blanks the screen value for a list of fields.  This does nothing to 
  // objects where a blank screen value does not make sense, such as radio 
  // sets, toggle boxes and selection lists. 
  var f=flds.split(','); // create field list array
  for (var i=0;i<f.length;i++){
    action(this.setWidgetPrefix(f[i])+'.setinput|');
  }
  return true;
}

Logic.prototype.disableRadioButton=function(fld,num){
  // Returns FALSE if a widget is not a radio-set, if a widget is not found, 
  // or if the button number is invalid.
  var fld=this.widgetHandle(this.setWidgetPrefix(fld));
  if(!fld) return;
  var e=app.document.getElementsByName(fld.name);
  if(num<1 || e.length<num || e[num-1].type!='radio') return false;
  e[num-1].disabled='true';
  return true;
}

Logic.prototype.disableWidget=function(flds){
  // Returns FALSE if any field in the list is not found.
  var f=flds.split(','); // create field list array
  var artn=true, rtn=true;
  for (var i=0;i<f.length;i++){
    artn=action(this.setWidgetPrefix(f[i])+'.lock');
    artn=action(this.setWidgetPrefix(f[i])+'.disable');
    rtn=rtn&&artn;
  }
  return rtn;
}

Logic.prototype.enableRadioButton=function(fld,num){
  var fld=this.widgetHandle(this.setWidgetPrefix(fld));
  if(!fld) return;
  var e=app.document.getElementsByName(fld.name);
  if(num<1 || e.length<num || e[num-1].type!='radio') return false;
  e[num-1].disabled=null;
  return true;
}

Logic.prototype.enableWidget=function(flds){
  // Returns FALSE if any field in the list is not found.
  var f=flds.split(','); // create field list array
  var artn=true, rtn=true;
  for (var i=0;i<f.length;i++){
    artn=action(this.setWidgetPrefix(f[i])+'.unlock');
    artn=action(this.setWidgetPrefix(f[i])+'.enable');
    rtn=rtn&&artn;
  }
  return rtn;
}

Logic.prototype.formattedWidgetValue=function(fld){
  // Returns a widget's formatted screen value
  return action(this.setWidgetPrefix(fld)+'.get');
}

Logic.prototype.formattedWidgetValueList=function(flds,dlm){
  // Returns delimited list of formatted screen values, dlm delimited.
  // If a field or its value is unknown, a '?' placeholder is returned. 
  if(dlm==null||dlm==undefined) dlm='|'; // default to pipe
  var f=flds.split(','); // create field list array
  var lst='', val;
  for (var i=0;i<f.length;i++){
    if(i>0) lst+=dlm;
    val=action(this.setWidgetPrefix(f[i])+'.get');
    if(!val) val='?';
     lst+=val;
  }
  return lst;
}

Logic.prototype.hideWidget=function(flds){
  // Returns FALSE if any field in the list is not found.
  var f=flds.split(','); // create field list array
  var artn=true, rtn=true;
  for (var i=0;i<f.length;i++){
    artn=action(this.setWidgetPrefix(f[i])+'.hide');
    rtn=rtn&&artn;
  }
  return rtn;
}

Logic.prototype.highlightWidget=function(flds,typ){
  switch (typ) {
    case 'err':  typ='error';
    case 'info': typ='information';
    case 'warn': typ='warning';
    default:     typ='';
  }

  var f=flds.split(',');
  for (var i=0;i<f.length;i++){
    action(this.setWidgetPrefix(f[i])+'.mark|'+typ);
  }
  return true;
}

Logic.prototype.resetWidgetValue=function(flds){
  // Resets the object screen value to its original data source value.  If a 
  // field is not found, FALSE is returned after list processing completes. */
  var f=flds.split(',');
  var rtn=false;
  for (var i=0;i<f.length;i++){
    var old=action(this.setWidgetPrefix(f[i])+'.getdata');
    if(old!=null) rtn=true;
    action(this.setWidgetPrefix(f[i])+'.setinput|'+old);
  }
  return rtn;
}

Logic.prototype.toggleWidget=function(flds){
  // Supports logical text input, non-SDO checkbox (see ryapph.js).  If any
  // assignment fails, FALSE is returned after list processing completes. 
  var f=flds.split(',');
  var rtn=true, val;
  for (var i=0;i<f.length;i++){
  	var e=this.widgetHandle(this.setWidgetPrefix(f[i]));
    e.checked=(e.checked?null:'true');
    rtn=false;
  }
  return rtn;
}

Logic.prototype.viewWidget=function(flds){
  // Returns FALSE if any field in the list is not found.
  var f=flds.split(','); // create field list array
  var artn=true, rtn=true;
  for (var i=0;i<f.length;i++){
    artn=action(this.setWidgetPrefix(f[i])+'.show');
    rtn=rtn&&artn;
  }
  return rtn;
}

Logic.prototype.widgetHandle=function(fld){
  // Returns widget handle 
  var pfx=this.setWidgetPrefix(fld);
  if(pfx.split('.')[0]=='tool') return action(pfx+'.handle')[0];
  return action(pfx+'.handle');
}

Logic.prototype.widgetLabel=function(fld){
  // Returns handle to widget's label 
  return this.widgetHandle(fld).previousSibling.previousSibling;
}

Logic.prototype.locateWidget=Logic.prototype.widgetHandle;

Logic.prototype.widgetIsBlank=function(flds){
  var f=flds.split(','); // create field list array
  var rtn=true;
  for (var i=0;i<f.length;i++)
    rtn=rtn&&(action(this.setWidgetPrefix(f[i])+'.get')=='');
  return rtn;
}

Logic.prototype.widgetIsModified=function(flds){
  // Returns TRUE if the screen value for any field in the list is different
  // from its underlying data value.
  var f=flds.split(',');  // create field list array
  var artn=true, rtn=false;
  for (var i=0;i<f.length;i++){
    artn=(action(this.setWidgetPrefix(f[i])+'.get')!=action(this.setWidgetPrefix(f[i])+'.getdata'));
    rtn=rtn||artn;
  }
  return rtn;
}

Logic.prototype.widgetIsTrue=function(fld){
  // Returns TRUE if the value of a logical object is TRUE, otherwise FALSE.
  // Returns null if the field is not found, if the value is unknown, or if 
  // the widget is not a logical field.
  // Supports logical text input with yes/no values. 
  var hdl=this.widgetHandle(fld);
  if(hdl.type=='checkbox') return (hdl.checked && true); 
  if(hdl.type=='text') return ((this.widgetValue(fld)).toLowerCase()=='yes');
  return null; // Widget not found
}

Logic.prototype.widgetValue=function(fld){
  // Returns a widget's unformatted input value.  Supports date, decimal, and
  // integer datatypes. 
  var pfx=this.setWidgetPrefix(fld);
  if(pfx.split('.')[0]=='tool') return action(pfx+'.get');
  var val=action(pfx+'.get');
  var typ=action(pfx+'.gettype');
  return window.strip(val,typ);
}

Logic.prototype.widgetValueList=function(flds,dlm){
  // Returns unformatted list of values.  Supports date, decimal, and integer
  // datatypes. 
  var f=flds.split(','); // create field list array
  if(dlm==null||dlm==undefined) dlm='|';
  var lst='';
  var fld, typ, val; 
  for (var i=0;i<f.length;i++){
    if(i>0) lst+='|';
    val=action(this.setWidgetPrefix(f[i])+'.get');
    typ=action(this.setWidgetPrefix(f[i])+'.gettype');
    lst+=window.strip(val,typ);
  }
  return lst;
}

logic=new Logic();
