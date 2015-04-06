CKEDITOR.plugins.add("colorbutton",{requires:"panelbutton,floatpanel",lang:"af,ar,bg,bn,bs,ca,cs,cy,da,de,el,en,en-au,en-ca,en-gb,eo,es,et,eu,fa,fi,fo,fr,fr-ca,gl,gu,he,hi,hr,hu,id,is,it,ja,ka,km,ko,ku,lt,lv,mk,mn,ms,nb,nl,no,pl,pt,pt-br,ro,ru,si,sk,sl,sq,sr,sr-latn,sv,th,tr,tt,ug,uk,vi,zh,zh-cn",icons:"bgcolor,textcolor",hidpi:!0,init:function(e){function t(t,l,a,c){var i=new CKEDITOR.style(n["colorButton_"+l+"Style"]),s=CKEDITOR.tools.getNextId()+"_colorBox";e.ui.add(t,CKEDITOR.UI_PANELBUTTON,{label:a,title:a,modes:{wysiwyg:1},editorFocus:0,toolbar:"colors,"+c,allowedContent:i,requiredContent:i,panel:{css:CKEDITOR.skin.getPath("editor"),attributes:{role:"listbox","aria-label":r.panelTitle}},onBlock:function(t,n){n.autoSize=!0,n.element.addClass("cke_colorblock"),n.element.setHtml(o(t,l,s)),n.element.getDocument().getBody().setStyle("overflow","hidden"),CKEDITOR.ui.fire("ready",this);var r=n.keys,a="rtl"==e.lang.dir;r[a?37:39]="next",r[40]="next",r[9]="next",r[a?39:37]="prev",r[38]="prev",r[CKEDITOR.SHIFT+9]="prev",r[32]="click"},refresh:function(){e.activeFilter.check(i)||this.setState(CKEDITOR.TRISTATE_DISABLED)},onOpen:function(){var t,o=e.getSelection(),o=o&&o.getStartElement(),o=e.elementPath(o);if(o){o=o.block||o.blockLimit||e.document.getBody();do t=o&&o.getComputedStyle("back"==l?"background-color":"color")||"transparent";while("back"==l&&"transparent"==t&&o&&(o=o.getParent()));return t&&"transparent"!=t||(t="#ffffff"),this._.panel._.iframe.getFrameDocument().getById(s).setStyle("background-color",t),t}}})}function o(t,o,a){var c=[],i=n.colorButton_colors.split(","),s=e.plugins.colordialog&&!1!==n.colorButton_enableMore,u=i.length+(s?2:1),d=CKEDITOR.tools.addFunction(function(o,r){function a(e){this.removeListener("ok",a),this.removeListener("cancel",a),"ok"==e.name&&c(this.getContentElement("picker","selectedColor").getValue(),r)}var c=arguments.callee;if("?"==o)e.openDialog("colordialog",function(){this.on("ok",a),this.on("cancel",a)});else{if(e.focus(),t.hide(),e.fire("saveSnapshot"),e.removeStyle(new CKEDITOR.style(n["colorButton_"+r+"Style"],{color:"inherit"})),o){var i=n["colorButton_"+r+"Style"];i.childRule="back"==r?function(e){return l(e)}:function(e){return!(e.is("a")||e.getElementsByTag("a").count())||l(e)},e.applyStyle(new CKEDITOR.style(i,{color:o}))}e.fire("saveSnapshot")}});for(c.push('<a class="cke_colorauto" _cke_focus=1 hidefocus=true title="',r.auto,'" onclick="CKEDITOR.tools.callFunction(',d,",null,'",o,"');return false;\" href=\"javascript:void('",r.auto,'\')" role="option" aria-posinset="1" aria-setsize="',u,'"><table role="presentation" cellspacing=0 cellpadding=0 width="100%"><tr><td><span class="cke_colorbox" id="',a,'"></span></td><td colspan=7 align=center>',r.auto,'</td></tr></table></a><table role="presentation" cellspacing=0 cellpadding=0 width="100%">'),a=0;a<i.length;a++){0===a%8&&c.push("</tr><tr>");var f=i[a].split("/"),p=f[0],F=f[1]||p;f[1]||(p="#"+p.replace(/^(.)(.)(.)$/,"$1$1$2$2$3$3")),f=e.lang.colorbutton.colors[F]||F,c.push('<td><a class="cke_colorbox" _cke_focus=1 hidefocus=true title="',f,'" onclick="CKEDITOR.tools.callFunction(',d,",'",p,"','",o,"'); return false;\" href=\"javascript:void('",f,'\')" role="option" aria-posinset="',a+2,'" aria-setsize="',u,'"><span class="cke_colorbox" style="background-color:#',F,'"></span></a></td>')}return s&&c.push('</tr><tr><td colspan=8 align=center><a class="cke_colormore" _cke_focus=1 hidefocus=true title="',r.more,'" onclick="CKEDITOR.tools.callFunction(',d,",'?','",o,"');return false;\" href=\"javascript:void('",r.more,"')\"",' role="option" aria-posinset="',u,'" aria-setsize="',u,'">',r.more,"</a></td>"),c.push("</tr></table>"),c.join("")}function l(e){return"false"==e.getAttribute("contentEditable")||e.getAttribute("data-nostyle")}var n=e.config,r=e.lang.colorbutton;CKEDITOR.env.hc||(t("TextColor","fore",r.textColorTitle,10),t("BGColor","back",r.bgColorTitle,20))}}),CKEDITOR.config.colorButton_colors="000,800000,8B4513,2F4F4F,008080,000080,4B0082,696969,B22222,A52A2A,DAA520,006400,40E0D0,0000CD,800080,808080,F00,FF8C00,FFD700,008000,0FF,00F,EE82EE,A9A9A9,FFA07A,FFA500,FFFF00,00FF00,AFEEEE,ADD8E6,DDA0DD,D3D3D3,FFF0F5,FAEBD7,FFFFE0,F0FFF0,F0FFFF,F0F8FF,E6E6FA,FFF",CKEDITOR.config.colorButton_foreStyle={element:"span",styles:{color:"#(color)"},overrides:[{element:"font",attributes:{color:null}}]},CKEDITOR.config.colorButton_backStyle={element:"span",styles:{"background-color":"#(color)"}};