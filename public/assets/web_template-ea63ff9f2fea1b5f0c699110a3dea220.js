(function() {


}).call(this);
(function() {
  var FormSubmitDisabler;

  $(function() {
    return $('body[class~=preview] form').each(function() {
      return new FormSubmitDisabler($(this));
    });
  });

  FormSubmitDisabler = (function() {
    function FormSubmitDisabler($element) {
      var $submitInput;
      $submitInput = $element.find('input[type=submit]');
      $submitInput.attr('disabled', 'disabled');
    }

    return FormSubmitDisabler;

  })();

}).call(this);
(function() {
  $(function() {
    var previewConfigs;
    previewConfigs = JSON.parse($('#preview-configs').html());
    return $('body').delegate('a', 'click', function() {
      var linkHref, previewHref;
      linkHref = $(this).attr('href');
      if (typeof linkHref !== 'undefined' && !linkHref.match(/^http|^\/\//i)) {
        if (previewConfigs.corporate) {
          previewHref = previewConfigs.slug_corporate + linkHref;
        } else {
          previewHref = linkHref.replace("" + previewConfigs.slug + "/", "" + previewConfigs.urn + "/" + previewConfigs.slug + "/");
        }
        return $(this).attr('href', previewHref);
      }
    });
  });

}).call(this);
