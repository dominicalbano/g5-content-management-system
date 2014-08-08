CKEDITOR.config.toolbarGroups = [
  { name: 'clipboard' },
	{ name: 'basicstyles' },
	{ name: 'paragraph', groups: [ 'list', 'align' ] },
	{ name: 'links' },
  { name: 'insert' },
	{ name: 'styles' }
];
CKEDITOR.config.removeButtons = 'Anchor,Underline,Strike,Subscript,Superscript,Copy,Cut,Styles,Flash,Table,Smiley,SpecialChar,PageBreak,Iframe';
CKEDITOR.config.removeDialogTabs = 'link:advanced';
CKEDITOR.config.dialog_backgroundCoverColor = 'transparent'