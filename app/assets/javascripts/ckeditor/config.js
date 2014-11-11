CKEDITOR.config.toolbarGroups = [
  { name: 'document', groups: [ 'mode' ] },
  { name: 'clipboard' },
	{ name: 'basicstyles' },
	{ name: 'paragraph', groups: [ 'list', 'align' ] },
	{ name: 'links' },
  { name: 'insert' },
	{ name: 'styles' }
];
CKEDITOR.config.removeButtons = 'Anchor,Underline,Strike,Subscript,Superscript,Copy,Cut,Styles,Flash,Table,Smiley,SpecialChar,PageBreak,Iframe,Save,NewPage,Preview,Print';
CKEDITOR.config.removeButtons += ($('body').hasClass('g5-user') ? '' : ',Source')
CKEDITOR.config.removeDialogTabs = 'link:advanced';
CKEDITOR.config.dialog_backgroundCoverColor = 'transparent'
CKEDITOR.config.extraAllowedContent = 'iframe[*],meta[*],link'