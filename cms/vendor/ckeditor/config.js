/**
 * @license Copyright (c) 2003-2015, CKSource - Frederico Knabben. All rights reserved.
 * For licensing, see LICENSE.md or http://ckeditor.com/license
 */

CKEDITOR.editorConfig = function( config ) {
	// Define changes to default configuration here.
	// For complete reference see:
	// http://docs.ckeditor.com/#!/api/CKEDITOR.config

	// The toolbar groups arrangement, optimized for two toolbar rows.
	config.toolbarGroups = [
    { name: 'document', groups: [ 'mode' ] },
    { name: 'clipboard' },
    { name: 'basicstyles' },
    { name: 'paragraph', groups: [ 'list', 'align' ] },
    { name: 'links' },
    { name: 'insert' },
    { name: 'styles' }
  ];

	config.removeButtons = 'Anchor,Underline,Strike,Subscript,Superscript,Copy,Cut,Styles,Flash,Table,Smiley,SpecialChar,PageBreak,Iframe,Save,NewPage,Preview,Print';
	config.removeDialogTabs = 'link:advanced';
  config.dialog_backgroundCoverColor = 'transparent';
  config.extraAllowedContent = 'iframe[*]';
};

CKEDITOR.config.removeButtons += ($('body').hasClass('g5-user') ? '' : ',Source')
