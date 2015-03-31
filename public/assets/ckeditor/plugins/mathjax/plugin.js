!function(){var t="http://cdn.mathjax.org/mathjax/2.2-latest/MathJax.js?config=TeX-AMS_HTML";CKEDITOR.plugins.add("mathjax",{lang:"af,ar,ca,cs,cy,da,de,el,en,en-gb,eo,es,fa,fi,fr,gl,he,hr,hu,it,ja,km,ku,lt,nb,nl,no,pl,pt,pt-br,ro,ru,sk,sl,sq,sv,tr,tt,uk,vi,zh,zh-cn",requires:"widget,dialog",icons:"mathjax",hidpi:!0,init:function(e){var a=e.config.mathJaxClass||"math-tex";e.widgets.add("mathjax",{inline:!0,dialog:"mathjax",button:e.lang.mathjax.button,mask:!0,allowedContent:"span(!"+a+")",styleToAllowedContentRules:function(t){return(t=t.getClassesArray())?(t.push("!"+a),"span("+t.join(",")+")"):null},pathName:e.lang.mathjax.pathName,template:'<span class="'+a+'" style="display:inline-block" data-cke-survive=1></span>',parts:{span:"span"},defaults:{math:"\\(x = {-b \\pm \\sqrt{b^2-4ac} \\over 2a}\\)"},init:function(){var t=this.parts.span.getChild(0);t&&t.type==CKEDITOR.NODE_ELEMENT&&t.is("iframe")||(t=new CKEDITOR.dom.element("iframe"),t.setAttributes({style:"border:0;width:0;height:0",scrolling:"no",frameborder:0,allowTransparency:!0,src:CKEDITOR.plugins.mathjax.fixSrc}),this.parts.span.append(t)),this.once("ready",function(){CKEDITOR.env.ie&&t.setAttribute("src",CKEDITOR.plugins.mathjax.fixSrc),this.frameWrapper=new CKEDITOR.plugins.mathjax.frameWrapper(t,e),this.frameWrapper.setValue(this.data.math)})},data:function(){this.frameWrapper&&this.frameWrapper.setValue(this.data.math)},upcast:function(t,e){if("span"==t.name&&t.hasClass(a)&&!(1<t.children.length||t.children[0].type!=CKEDITOR.NODE_TEXT)){e.math=CKEDITOR.tools.htmlDecode(t.children[0].value);var n=t.attributes;return n.style=n.style?n.style+";display:inline-block":"display:inline-block",n["data-cke-survive"]=1,t.children[0].remove(),t}},downcast:function(t){t.children[0].replaceWith(new CKEDITOR.htmlParser.text(CKEDITOR.tools.htmlEncode(this.data.math)));var e=t.attributes;return e.style=e.style.replace(/display:\s?inline-block;?\s?/,""),""===e.style&&delete e.style,t}}),CKEDITOR.dialog.add("mathjax",this.path+"dialogs/mathjax.js"),e.on("contentPreview",function(a){a.data.dataValue=a.data.dataValue.replace(/<\/head>/,'<script src="'+(e.config.mathJaxLib?CKEDITOR.getUrl(e.config.mathJaxLib):t)+'"></script></head>')}),e.on("paste",function(t){t.data.dataValue=t.data.dataValue.replace(RegExp("<span[^>]*?"+a+".*?</span>","ig"),function(t){return t.replace(/(<iframe.*?\/iframe>)/i,"")})})}}),CKEDITOR.plugins.mathjax={},CKEDITOR.plugins.mathjax.fixSrc=CKEDITOR.env.gecko?"javascript:true":CKEDITOR.env.ie?"javascript:void((function(){"+encodeURIComponent("document.open();("+CKEDITOR.tools.fixDomain+")();document.close();")+"})())":"javascript:void(0)",CKEDITOR.plugins.mathjax.loadingIcon=CKEDITOR.plugins.get("mathjax").path+"images/loader.gif",CKEDITOR.plugins.mathjax.copyStyles=function(t,e){for(var a="color font-family font-style font-weight font-variant font-size".split(" "),n=0;n<a.length;n++){var i=a[n],s=t.getComputedStyle(i);s&&e.setStyle(i,s)}},CKEDITOR.plugins.mathjax.trim=function(t){var e=t.indexOf("\\(")+2,a=t.lastIndexOf("\\)");return t.substring(e,a)},CKEDITOR.plugins.mathjax.frameWrapper=CKEDITOR.env.ie&&8==CKEDITOR.env.version?function(t,e){return t.getFrameDocument().write('<!DOCTYPE html><html><head><meta charset="utf-8"></head><body style="padding:0;margin:0;background:transparent;overflow:hidden"><span style="white-space:nowrap;" id="tex"></span></body></html>'),{setValue:function(a){var n=t.getFrameDocument(),i=n.getById("tex");i.setHtml(CKEDITOR.plugins.mathjax.trim(CKEDITOR.tools.htmlEncode(a))),CKEDITOR.plugins.mathjax.copyStyles(t,i),e.fire("lockSnapshot"),t.setStyles({width:Math.min(250,i.$.offsetWidth)+"px",height:n.$.body.offsetHeight+"px",display:"inline","vertical-align":"middle"}),e.fire("unlockSnapshot")}}}:function(e,a){function n(){h=e.getFrameDocument(),h.getById("preview")||(CKEDITOR.env.ie&&e.removeAttribute("src"),h.write('<!DOCTYPE html><html><head><meta charset="utf-8"><script type="text/x-mathjax-config">MathJax.Hub.Config( {showMathMenu: false,messageStyle: "none"} );function getCKE() {if ( typeof window.parent.CKEDITOR == \'object\' ) {return window.parent.CKEDITOR;} else {return window.parent.parent.CKEDITOR;}}function update() {MathJax.Hub.Queue([ \'Typeset\', MathJax.Hub, this.buffer ],function() {getCKE().tools.callFunction( '+u+" );});}MathJax.Hub.Queue( function() {getCKE().tools.callFunction("+c+');} );</script><script src="'+(a.config.mathJaxLib||t)+'"></script></head><body style="padding:0;margin:0;background:transparent;overflow:hidden"><span id="preview"></span><span id="buffer" style="display:none"></span></body></html>'))}function i(){p=!0,o=r,a.fire("lockSnapshot"),s.setHtml(o),l.setHtml("<img src="+CKEDITOR.plugins.mathjax.loadingIcon+" alt="+a.lang.mathjax.loading+">"),e.setStyles({height:"16px",width:"16px",display:"inline","vertical-align":"middle"}),a.fire("unlockSnapshot"),h.getWindow().$.update(o)}var s,l,o,r,h=e.getFrameDocument(),d=!1,p=!1,c=CKEDITOR.tools.addFunction(function(){l=h.getById("preview"),s=h.getById("buffer"),d=!0,r&&i(),CKEDITOR.fire("mathJaxLoaded",e)}),u=CKEDITOR.tools.addFunction(function(){CKEDITOR.plugins.mathjax.copyStyles(e,l),l.setHtml(s.getHtml()),a.fire("lockSnapshot"),e.setStyles({height:0,width:0});var t=Math.max(h.$.body.offsetHeight,h.$.documentElement.offsetHeight),n=Math.max(l.$.offsetWidth,h.$.body.scrollWidth);e.setStyles({height:t+"px",width:n+"px"}),a.fire("unlockSnapshot"),CKEDITOR.fire("mathJaxUpdateDone",e),o!=r?i():p=!1});return e.on("load",n),n(),{setValue:function(t){r=CKEDITOR.tools.htmlEncode(t),d&&!p&&i()}}}}();