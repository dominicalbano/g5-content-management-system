CKEDITOR.plugins.add("smiley",{requires:"dialog",lang:"af,ar,bg,bn,bs,ca,cs,cy,da,de,el,en,en-au,en-ca,en-gb,eo,es,et,eu,fa,fi,fo,fr,fr-ca,gl,gu,he,hi,hr,hu,id,is,it,ja,ka,km,ko,ku,lt,lv,mk,mn,ms,nb,nl,no,pl,pt,pt-br,ro,ru,si,sk,sl,sq,sr,sr-latn,sv,th,tr,tt,ug,uk,vi,zh,zh-cn",icons:"smiley",hidpi:!0,init:function(e){e.config.smiley_path=e.config.smiley_path||this.path+"images/",e.addCommand("smiley",new CKEDITOR.dialogCommand("smiley",{allowedContent:"img[alt,height,!src,title,width]",requiredContent:"img"})),e.ui.addButton&&e.ui.addButton("Smiley",{label:e.lang.smiley.toolbar,command:"smiley",toolbar:"insert,50"}),CKEDITOR.dialog.add("smiley",this.path+"dialogs/smiley.js")}}),CKEDITOR.config.smiley_images="regular_smile.png sad_smile.png wink_smile.png teeth_smile.png confused_smile.png tongue_smile.png embarrassed_smile.png omg_smile.png whatchutalkingabout_smile.png angry_smile.png angel_smile.png shades_smile.png devil_smile.png cry_smile.png lightbulb.png thumbs_down.png thumbs_up.png heart.png broken_heart.png kiss.png envelope.png".split(" "),CKEDITOR.config.smiley_descriptions="smiley;sad;wink;laugh;frown;cheeky;blush;surprise;indecision;angry;angel;cool;devil;crying;enlightened;no;yes;heart;broken heart;kiss;mail".split(";");