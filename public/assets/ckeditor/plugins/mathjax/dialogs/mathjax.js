CKEDITOR.dialog.add("mathjax",function(t){var e,a=t.lang.mathjax;return{title:a.title,minWidth:350,minHeight:100,contents:[{id:"info",elements:[{id:"equation",type:"textarea",label:a.dialogInput,onLoad:function(){var t=this;CKEDITOR.env.ie&&8==CKEDITOR.env.version||this.getInputElement().on("keyup",function(){e.setValue("\\("+t.getInputElement().getValue()+"\\)")})},setup:function(t){this.setValue(CKEDITOR.plugins.mathjax.trim(t.data.math))},commit:function(t){t.setData("math","\\("+this.getValue()+"\\)")}},{id:"documentation",type:"html",html:'<div style="width:100%;text-align:right;margin:-8px 0 10px"><a class="cke_mathjax_doc" href="'+a.docUrl+'" target="_black" style="cursor:pointer;color:#00B2CE;text-decoration:underline">'+a.docLabel+"</a></div>"},!(CKEDITOR.env.ie&&8==CKEDITOR.env.version)&&{id:"preview",type:"html",html:'<div style="width:100%;text-align:center;"><iframe style="border:0;width:0;height:0;font-size:20px" scrolling="no" frameborder="0" allowTransparency="true" src="'+CKEDITOR.plugins.mathjax.fixSrc+'"></iframe></div>',onLoad:function(){var a=CKEDITOR.document.getById(this.domId).getChild(0);e=new CKEDITOR.plugins.mathjax.frameWrapper(a,t)},setup:function(t){e.setValue(t.data.math)}}]}]}});