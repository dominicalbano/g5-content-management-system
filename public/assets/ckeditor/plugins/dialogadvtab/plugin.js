!function(){function t(t){var e=this.att,t=t&&t.hasAttribute(e)&&t.getAttribute(e)||"";void 0!==t&&this.setValue(t)}function e(){for(var t,e=0;e<arguments.length;e++)if(arguments[e]instanceof CKEDITOR.dom.element){t=arguments[e];break}if(t){var e=this.att,i=this.getValue();i?t.setAttribute(e,i):t.removeAttribute(e,i)}}var i={id:1,dir:1,classes:1,styles:1};CKEDITOR.plugins.add("dialogadvtab",{requires:"dialog",allowedContent:function(t){t||(t=i);var e=[];t.id&&e.push("id"),t.dir&&e.push("dir");var s="";return e.length&&(s+="["+e.join(",")+"]"),t.classes&&(s+="(*)"),t.styles&&(s+="{*}"),s},createAdvancedTab:function(s,a,l){a||(a=i);var n=s.lang.common,d={id:"advanced",label:n.advancedTab,title:n.advancedTab,elements:[{type:"vbox",padding:1,children:[]}]},r=[];return(a.id||a.dir)&&(a.id&&r.push({id:"advId",att:"id",type:"text",requiredContent:l?l+"[id]":null,label:n.id,setup:t,commit:e}),a.dir&&r.push({id:"advLangDir",att:"dir",type:"select",requiredContent:l?l+"[dir]":null,label:n.langDir,"default":"",style:"width:100%",items:[[n.notSet,""],[n.langDirLTR,"ltr"],[n.langDirRTL,"rtl"]],setup:t,commit:e}),d.elements[0].children.push({type:"hbox",widths:["50%","50%"],children:[].concat(r)})),(a.styles||a.classes)&&(r=[],a.styles&&r.push({id:"advStyles",att:"style",type:"text",requiredContent:l?l+"{cke-xyz}":null,label:n.styles,"default":"",validate:CKEDITOR.dialog.validate.inlineStyle(n.invalidInlineStyle),onChange:function(){},getStyle:function(t,e){var i=this.getValue().match(RegExp("(?:^|;)\\s*"+t+"\\s*:\\s*([^;]*)","i"));return i?i[1]:e},updateStyle:function(t,e){var i=this.getValue(),a=s.document.createElement("span");a.setAttribute("style",i),a.setStyle(t,e),i=CKEDITOR.tools.normalizeCssText(a.getAttribute("style")),this.setValue(i,1)},setup:t,commit:e}),a.classes&&r.push({type:"hbox",widths:["45%","55%"],children:[{id:"advCSSClasses",att:"class",type:"text",requiredContent:l?l+"(cke-xyz)":null,label:n.cssClasses,"default":"",setup:t,commit:e}]}),d.elements[0].children.push({type:"hbox",widths:["50%","50%"],children:[].concat(r)})),d}})}();