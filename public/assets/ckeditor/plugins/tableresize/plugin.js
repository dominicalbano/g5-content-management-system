!function(){function e(e){return CKEDITOR.env.ie?e.$.clientWidth:parseInt(e.getComputedStyle("width"),10)}function t(e,t){var n=e.getComputedStyle("border-"+t+"-width"),o={thin:"0px",medium:"1px",thick:"2px"};return 0>n.indexOf("px")&&(n=n in o&&"none"!=e.getComputedStyle("border-style")?o[n]:0),parseInt(n,10)}function n(e){var n,o=[],i=-1,a="rtl"==e.getComputedStyle("direction");n=e.$.rows;for(var r,l,s,u=0,d=0,m=n.length;m>d;d++)s=n[d],r=s.cells.length,r>u&&(u=r,l=s);for(n=l,u=new CKEDITOR.dom.element(e.$.tBodies[0]),r=u.getDocumentPosition(),l=0,s=n.cells.length;s>l;l++){var c,f,d=new CKEDITOR.dom.element(n.cells[l]),m=n.cells[l+1]&&new CKEDITOR.dom.element(n.cells[l+1]),i=i+(d.$.colSpan||1),h=d.getDocumentPosition().x;a?f=h+t(d,"left"):c=h+d.$.offsetWidth-t(d,"right"),m?(h=m.getDocumentPosition().x,a?c=h+m.$.offsetWidth-t(m,"right"):f=h+t(m,"left")):(h=e.getDocumentPosition().x,a?c=h:f=h+e.$.offsetWidth),d=Math.max(f-c,3),o.push({table:e,index:i,x:c,y:r.y,width:d,height:u.$.offsetHeight,rtl:a})}return o}function o(e){(e.data||e).preventDefault()}function i(n){function i(){h=0,f.setOpacity(0),p&&a();var e=m.table;setTimeout(function(){e.removeCustomData("_cke_table_pillars")},0),c.removeListener("dragstart",o)}function a(){for(var n=m.rtl,o=n?b.length:v.length,i=0;o>i;i++){var a=v[i],l=b[i],s=m.table;CKEDITOR.tools.setTimeout(function(e,t,o,i,a,l){e&&e.setStyle("width",r(Math.max(t+l,1))),o&&o.setStyle("width",r(Math.max(i-l,1))),a&&s.setStyle("width",r(a+l*(n?-1:1)))},0,this,[a,a&&e(a),l,l&&e(l),(!a||!l)&&e(s)+t(s,"left")+t(s,"right"),p])}}function s(t){o(t);for(var t=m.index,n=CKEDITOR.tools.buildTableMap(m.table),i=[],a=[],r=Number.MAX_VALUE,l=r,s=m.rtl,x=0,C=n.length;C>x;x++){var T=n[x],E=T[t+(s?1:0)],T=T[t+(s?0:1)],E=E&&new CKEDITOR.dom.element(E),T=T&&new CKEDITOR.dom.element(T);E&&T&&E.equals(T)||(E&&(r=Math.min(r,e(E))),T&&(l=Math.min(l,e(T))),i.push(E),a.push(T))}v=i,b=a,y=m.x-r,D=m.x+l,f.setOpacity(.5),g=parseInt(f.getStyle("left"),10),p=0,h=1,f.on("mousemove",d),c.on("dragstart",o),c.on("mouseup",u,this)}function u(e){e.removeListener(),i()}function d(e){x(e.data.getPageOffset().x)}var m,c,f,h,g,p,v,b,y,D;c=n.document,f=CKEDITOR.dom.element.createFromHtml('<div data-cke-temp=1 contenteditable=false unselectable=on style="position:absolute;cursor:col-resize;filter:alpha(opacity=0);opacity:0;padding:0;background-color:#004;background-image:none;border:0px none;z-index:10"></div>',c),n.on("destroy",function(){f.remove()}),l||c.getDocumentElement().append(f),this.attachTo=function(e){h||(l&&(c.getBody().append(f),p=0),m=e,f.setStyles({width:r(e.width),height:r(e.height),left:r(e.x),top:r(e.y)}),l&&f.setOpacity(.25),f.on("mousedown",s,this),c.getBody().setStyle("cursor","col-resize"),f.show())};var x=this.move=function(e){if(!m)return 0;if(!h&&(e<m.x||e>m.x+m.width))return m=null,h=p=0,c.removeListener("mouseup",u),f.removeListener("mousedown",s),f.removeListener("mousemove",d),c.getBody().setStyle("cursor","auto"),l?f.remove():f.hide(),0;if(e-=Math.round(f.$.offsetWidth/2),h){if(e==y||e==D)return 1;e=Math.max(e,y),e=Math.min(e,D),p=e-g}return f.setStyle("left",r(e)),1}}function a(e){var t=e.data.getTarget();if("mouseout"==e.name){if(!t.is("table"))return;for(var n=new CKEDITOR.dom.element(e.data.$.relatedTarget||e.data.$.toElement);n&&n.$&&!n.equals(t)&&!n.is("body");)n=n.getParent();if(!n||n.equals(t))return}t.getAscendant("table",1).removeCustomData("_cke_table_pillars"),e.removeListener()}var r=CKEDITOR.tools.cssLength,l=CKEDITOR.env.ie&&(CKEDITOR.env.ie7Compat||CKEDITOR.env.quirks);CKEDITOR.plugins.add("tableresize",{requires:"tabletools",init:function(e){e.on("contentDom",function(){var t,r=e.editable();r.attachListener(r.isInline()?r:e.document,"mousemove",function(r){var r=r.data,l=r.getTarget();if(l.type==CKEDITOR.NODE_ELEMENT){var s=r.getPageOffset().x;if(t&&t.move(s))o(r);else if((l.is("table")||l.getAscendant("tbody",1))&&(l=l.getAscendant("table",1),e.editable().contains(l))){(r=l.getCustomData("_cke_table_pillars"))||(l.setCustomData("_cke_table_pillars",r=n(l)),l.on("mouseout",a),l.on("mousedown",a));e:{for(var l=0,u=r.length;u>l;l++){var d=r[l];if(s>=d.x&&s<=d.x+d.width){s=d;break e}}s=null}s&&(!t&&(t=new i(e)),t.attachTo(s))}}})})}})}();