(function() {

var get = Ember.get,
    set = Ember.set;

Ember.Uploader = Ember.Object.extend(Ember.Evented, {
  url: null,

  /**
   * ajax request type (method), by default it will be POST
   *
   * @property type
   */
  type: 'POST',

  upload: function(file) {
    var data = this.setupFormData(file);
    var url  = get(this, 'url');
    var type = get(this, 'type');
    var self = this;

    set(this, 'isUploading', true);

    return this.ajax(url, data, type).then(function(respData) {
      self.didUpload(respData);
      return respData;
    });
  },

  setupFormData: function(file, extraData) {
    var data = new FormData();

    for (var prop in extraData) {
      if (extraData.hasOwnProperty(prop)) {
        data.append(prop, extraData[prop]);
      }
    }

    data.append('file', file);

    return data;
  },

  didUpload: function(data) {
    set(this, 'isUploading', false);

    this.trigger('didUpload', data);
  },

  didProgress: function(e) {
    e.percent = e.loaded / e.total * 100;
    this.trigger('progress', e);
  },

  ajax: function(url, params, method) {
    var self = this;
    var settings = {
      url: url,
      type: method || 'POST',
      contentType: false,
      processData: false,
      xhr: function() {
        var xhr = Ember.$.ajaxSettings.xhr();
        xhr.upload.onprogress = function(e) {
          self.didProgress(e);
        };
        return xhr;
      },
      data: params
    };

    return this._ajax(settings);
  },

  authorizationAjax: function(url, method, signatureJson) {
    var self = this;
    var settings = {
      signature: signatureJson['signature'],
      url: url,
      type: method || 'POST',
      contentType: false,
      processData: false,
      headers: {'Authorization': 'AWS4-HMAC-SHA256 Credential=' + signatureJson['aws_access_key_id'] + 
               '/' + signatureJson['simple_date'] + '/' + signatureJson['region'] + '/s3/aws4_request, SignedHeaders=host;x-amz-date, Signature=' + signatureJson['signature'],
                'x-amz-date': signatureJson['iso8601_date'],
                'x-amz-content-sha256' : 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855'}
    };
    return this._ajax(settings);
  },

  _ajax: function(settings) {
    return new Ember.RSVP.Promise(function(resolve, reject) {
      settings.success = function(data) {
        Ember.run(null, resolve, data);
      };

      settings.error = function(jqXHR, textStatus, errorThrown) {
        Ember.run(null, reject, jqXHR);
      };

      return Ember.$.ajax(settings);
    });
  }
});

})();

(function() {

var get = Ember.get,
    set = Ember.set;

Ember.S3Uploader = Ember.Uploader.extend({
  /**
    Url used to request a signed upload url

    @property url
  */
  url: '/sign',
  type: 'POST',

  upload: function(file) {
    var self = this;

    set(this, 'isUploading', true);
    return this.sign(file).then(function(json) {
      var url = "//s3-" + json.region + ".amazonaws.com/" + json.bucket + "/";
      delete json.region;
      var data = self.setupFormData(file, json);
      var type = get(self, 'type');

      return self.ajax(url, data, type);
    }).then(function(respData) {
      self.didUpload(respData);
      return respData;
    });
  },

  deleteAsset: function(asset) {
    var self = this;
    return this.signDelete(asset).then(function(json) {
      var url = asset.get('url');
      var type = 'DELETE';
      return self.authorizationAjax(url, "DELETE", json);
    });
  },

  sign: function(file) {
    var settings = {
      url: get(this, 'url'),
      type: 'GET',
      contentType: 'json',
      data: {
        name: file.name
      }
    };

    return this._ajax(settings);
  },

  signDelete: function(file) {
    var settings = {
      url: get(this, 'url'),
      type: 'GET',
      contentType: 'json',
      data: {
        name: file.get('url').split('/').pop()
      }
    };
    return this._ajax(settings);
  }
});


})();

(function() {

var set = Ember.set;

Ember.FileField = Ember.TextField.extend({
  type: 'file',
  attributeBindings: ['multiple'],
  multiple: false,
  change: function(e) {
    var input = e.target;
    if (!Ember.isEmpty(input.files)) {
      set(this, 'files', input.files);
    }
  }
});


})();
