!function(){function e(e){return{"aria-label":e,"class":"cke_pagebreak",contenteditable:"false","data-cke-display-name":"pagebreak","data-cke-pagebreak":1,style:"page-break-after: always",title:e}}CKEDITOR.plugins.add("pagebreak",{requires:"fakeobjects",lang:"af,ar,bg,bn,bs,ca,cs,cy,da,de,el,en,en-au,en-ca,en-gb,eo,es,et,eu,fa,fi,fo,fr,fr-ca,gl,gu,he,hi,hr,hu,id,is,it,ja,ka,km,ko,ku,lt,lv,mk,mn,ms,nb,nl,no,pl,pt,pt-br,ro,ru,si,sk,sl,sq,sr,sr-latn,sv,th,tr,tt,ug,uk,vi,zh,zh-cn",icons:"pagebreak,pagebreak-rtl",hidpi:!0,onLoad:function(){var e=("background:url("+CKEDITOR.getUrl(this.path+"images/pagebreak.gif")+") no-repeat center center;clear:both;width:100%;border-top:#999 1px dotted;border-bottom:#999 1px dotted;padding:0;height:5px;cursor:default;").replace(/;/g," !important;");CKEDITOR.addCss("div.cke_pagebreak{"+e+"}")},init:function(e){e.blockless||(e.addCommand("pagebreak",CKEDITOR.plugins.pagebreakCmd),e.ui.addButton&&e.ui.addButton("PageBreak",{label:e.lang.pagebreak.toolbar,command:"pagebreak",toolbar:"insert,70"}),CKEDITOR.env.webkit&&e.on("contentDom",function(){e.document.on("click",function(a){a=a.data.getTarget(),a.is("div")&&a.hasClass("cke_pagebreak")&&e.getSelection().selectElement(a)})}))},afterInit:function(a){function t(t){CKEDITOR.tools.extend(t.attributes,e(a.lang.pagebreak.alt),!0),t.children.length=0}var n=a.dataProcessor,r=n&&n.dataFilter,n=n&&n.htmlFilter,l=/page-break-after\s*:\s*always/i,i=/display\s*:\s*none/i;n&&n.addRules({attributes:{"class":function(e,a){var t=e.replace("cke_pagebreak","");if(t!=e){var n=CKEDITOR.htmlParser.fragment.fromHtml('<span style="display: none;">&nbsp;</span>').children[0];a.children.length=0,a.add(n),n=a.attributes,delete n["aria-label"],delete n.contenteditable,delete n.title}return t}}},{applyToAll:!0,priority:5}),r&&r.addRules({elements:{div:function(e){if(e.attributes["data-cke-pagebreak"])t(e);else if(l.test(e.attributes.style)){var a=e.children[0];a&&"span"==a.name&&i.test(a.attributes.style)&&t(e)}}}})}}),CKEDITOR.plugins.pagebreakCmd={exec:function(a){var t=a.document.createElement("div",{attributes:e(a.lang.pagebreak.alt)});a.insertElement(t)},context:"div",allowedContent:{div:{styles:"!page-break-after"},span:{match:function(e){return(e=e.parent)&&"div"==e.name&&e.styles&&e.styles["page-break-after"]},styles:"display"}},requiredContent:"div{page-break-after}"}}();