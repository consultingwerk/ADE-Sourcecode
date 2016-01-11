#
# Name: fxprg2.awk
# Description: AWK script to read all patch files for a given setup type
# 
# Called from adebuild/pbuildfxprg
##################################################################################
 
BEGIN {startwriting=0; rightsetup=0}

/<MinimumVersion/ {
  if(rightsetup==1&&startwriting==1){
    # STARTVER set as variable on awk command
    ver=STARTVER
    minver=$0
    
    # Get MinimumVersion from XML Markup
    # Line looks like:
    #    <MinimumVersion>101000</MinimumVersion>
    sub("<","",minver)
    startpos=index(minver,">")
    minver=substr(minver,startpos+1)
    endpos=index(minver,"<")
    minver=substr(minver,1,endpos-1)
	
    #turn minver from char into number
    minver=minver+0
    
    #print a list of versions less than the minver
    while (ver<=minver) {
      if(length(ver)==5)ver="0" ver
      print ver " MinimumVersion"
      ver++
    }
  }
}

# Note the space after setup. We want the setup node and
# not the Setups node (note the plural)
/<setup / {
  if(substr($1,1,6)=="<setup"){
    if(length($2)>0){
      setup=substr($2,12)
      setup=substr(setup,1,length(setup) - 2)
      # HACK -- sometime unixes will leave an extra quote
      gsub(/\"/,"",setup)    
      #SETUPTYPE passed as var on awk command
      if(setup==SETUPTYPE){rightsetup=1}
    }
  }
}

/<database>/ {startwriting=1}

/<\/database>/ {startwriting=0}

/<patch/ {
  if(rightsetup==1&&startwriting==1){
    #only deal with delta files contents of patch files
    patchlevel=substr($2,13)
    patchlevel=substr(patchlevel,1,length(patchlevel)-1)
    if(patchlevel>0){
      nodeurl=substr($3,10)
      nodeurl=substr(nodeurl,1,length(nodeurl)-3)
      # HACK -- sometime unixes will leave an extra quote
      gsub(/\"/,"",nodeurl)    
      ispatchfile=match(nodeurl,"patch\\.xml")
      if(ispatchfile>0){
        print patchlevel " " nodeurl
      }
    }
  }
}

/\/setup>/ {rightsetup=0}

