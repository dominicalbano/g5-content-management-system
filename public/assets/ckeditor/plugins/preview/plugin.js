!function(){var e,t={modes:{wysiwyg:1,source:1},canUndo:!1,readOnly:1,exec:function(t){var n,a=t.config,o=a.baseHref?'<base href="'+a.baseHref+'"/>':"";if(a.fullPage)n=t.getData().replace(/<head>/,"$&"+o).replace(/[^>]*(?=<\/title>)/,"$& &mdash; "+t.lang.preview.preview);else{var a="<body ",i=t.document&&t.document.getBody();i&&(i.getAttribute("id")&&(a+='id="'+i.getAttribute("id")+'" '),i.getAttribute("class")&&(a+='class="'+i.getAttribute("class")+'" ')),n=t.config.docType+'<html dir="'+t.config.contentsLangDirection+'"><head>'+o+"<title>"+t.lang.preview.preview+"</title>"+CKEDITOR.tools.buildStyleHtml(t.config.contentsCss)+"</head>"+(a+">")+t.getData()+"</body></html>"}o=640,a=420,i=80;try{var r=window.screen,o=Math.round(.8*r.width),a=Math.round(.7*r.height),i=Math.round(.1*r.width)}catch(l){}if(!1===t.fire("contentPreview",t={dataValue:n}))return!1;var d,r="";return CKEDITOR.env.ie&&(window._cke_htmlToLoad=t.dataValue,d="javascript:void( (function(){document.open();"+("("+CKEDITOR.tools.fixDomain+")();").replace(/\/\/.*?\n/g,"").replace(/parent\./g,"window.opener.")+"document.write( window.opener._cke_htmlToLoad );document.close();window.opener._cke_htmlToLoad = null;})() )",r=""),CKEDITOR.env.gecko&&(window._cke_htmlToLoad=t.dataValue,r=CKEDITOR.getUrl(e+"preview.html")),r=window.open(r,null,"toolbar=yes,location=no,status=yes,menubar=yes,scrollbars=yes,resizable=yes,width="+o+",height="+a+",left="+i),CKEDITOR.env.ie&&r&&(r.location=d),!CKEDITOR.env.ie&&!CKEDITOR.env.gecko&&(d=r.document,d.open(),d.write(t.dataValue),d.close()),!0}};CKEDITOR.plugins.add("preview",{lang:"af,ar,bg,bn,bs,ca,cs,cy,da,de,el,en,en-au,en-ca,en-gb,eo,es,et,eu,fa,fi,fo,fr,fr-ca,gl,gu,he,hi,hr,hu,id,is,it,ja,ka,km,ko,ku,lt,lv,mk,mn,ms,nb,nl,no,pl,pt,pt-br,ro,ru,si,sk,sl,sq,sr,sr-latn,sv,th,tr,tt,ug,uk,vi,zh,zh-cn",icons:"preview,preview-rtl",hidpi:!0,init:function(n){n.elementMode!=CKEDITOR.ELEMENT_MODE_INLINE&&(e=this.path,n.addCommand("preview",t),n.ui.addButton&&n.ui.addButton("Preview",{label:n.lang.preview.preview,command:"preview",toolbar:"document,40"}))}})}();