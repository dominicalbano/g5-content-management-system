!function(){CKEDITOR.plugins.add("iframe",{requires:"dialog,fakeobjects",lang:"af,ar,bg,bn,bs,ca,cs,cy,da,de,el,en,en-au,en-ca,en-gb,eo,es,et,eu,fa,fi,fo,fr,fr-ca,gl,gu,he,hi,hr,hu,id,is,it,ja,ka,km,ko,ku,lt,lv,mk,mn,ms,nb,nl,no,pl,pt,pt-br,ro,ru,si,sk,sl,sq,sr,sr-latn,sv,th,tr,tt,ug,uk,vi,zh,zh-cn",icons:"iframe",hidpi:!0,onLoad:function(){CKEDITOR.addCss("img.cke_iframe{background-image: url("+CKEDITOR.getUrl(this.path+"images/placeholder.png")+");background-position: center center;background-repeat: no-repeat;border: 1px solid #a9a9a9;width: 80px;height: 80px;}")},init:function(e){var a=e.lang.iframe,i="iframe[align,longdesc,frameborder,height,name,scrolling,src,title,width]";e.plugins.dialogadvtab&&(i+=";iframe"+e.plugins.dialogadvtab.allowedContent({id:1,classes:1,styles:1})),CKEDITOR.dialog.add("iframe",this.path+"dialogs/iframe.js"),e.addCommand("iframe",new CKEDITOR.dialogCommand("iframe",{allowedContent:i,requiredContent:"iframe"})),e.ui.addButton&&e.ui.addButton("Iframe",{label:a.toolbar,command:"iframe",toolbar:"insert,80"}),e.on("doubleclick",function(e){var a=e.data.element;a.is("img")&&"iframe"==a.data("cke-real-element-type")&&(e.data.dialog="iframe")}),e.addMenuItems&&e.addMenuItems({iframe:{label:a.title,command:"iframe",group:"image"}}),e.contextMenu&&e.contextMenu.addListener(function(e){return e&&e.is("img")&&"iframe"==e.data("cke-real-element-type")?{iframe:CKEDITOR.TRISTATE_OFF}:void 0})},afterInit:function(e){var a=e.dataProcessor;(a=a&&a.dataFilter)&&a.addRules({elements:{iframe:function(a){return e.createFakeParserElement(a,"cke_iframe","iframe",!0)}}})}})}();