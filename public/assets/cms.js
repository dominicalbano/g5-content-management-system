define("cms/adapters/application", 
  ["ember","ember-data","cms/config/environment","exports"],
  function(__dependency1__, __dependency2__, __dependency3__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    var DS = __dependency2__["default"];
    var config = __dependency3__["default"];
    var ApplicationAdapter;

    ApplicationAdapter = DS.ActiveModelAdapter.extend({
      host: config.APP.host,
      namespace: 'api/v1'
    });

    __exports__["default"] = ApplicationAdapter;
  });
define("cms/app", 
  ["ember","ember/resolver","ember/load-initializers","cms/config/environment","exports"],
  function(__dependency1__, __dependency2__, __dependency3__, __dependency4__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    var Resolver = __dependency2__["default"];
    var loadInitializers = __dependency3__["default"];
    var config = __dependency4__["default"];
    var App;

    Ember.MODEL_FACTORY_INJECTIONS = true;

    App = Ember.Application.extend({
      modulePrefix: config.modulePrefix,
      podModulePrefix: config.podModulePrefix,
      Resolver: Resolver
    });

    loadInitializers(App, config.modulePrefix);

    __exports__["default"] = App;
  });
define("cms/components/click-select", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    var ClickSelectComponent, SelectText;

    SelectText = function(element) {
      var doc, range, selection, text;
      doc = document;
      text = doc.getElementById(element);
      range = void 0;
      selection = void 0;
      if (doc.body.createTextRange) {
        range = doc.body.createTextRange();
        range.moveToElementText(text);
        range.select();
      } else if (window.getSelection) {
        selection = window.getSelection();
        range = doc.createRange();
        range.selectNodeContents(text);
        selection.removeAllRanges();
        selection.addRange(range);
      }
    };

    ClickSelectComponent = Ember.Component.extend({
      click: function(evt) {
        return SelectText(this.elementId);
      }
    });

    __exports__["default"] = ClickSelectComponent;
  });
define("cms/components/confirm-button", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    var ConfirmButtonComponent;

    ConfirmButtonComponent = Ember.Component.extend({
      actions: {
        confirm: function() {
          if (confirm("Are you sure you want to delete this image?")) {
            this.sendAction("action", this.get("param"));
          }
        }
      }
    });

    __exports__["default"] = ConfirmButtonComponent;
  });
define("cms/components/confirmation-link", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    var ConfirmationLinkComponent;

    ConfirmationLinkComponent = Ember.Component.extend({
      tagName: "",
      classes: "",
      actions: {
        showConfirmation: function() {
          var userConfirm;
          this.toggleProperty("isShowingConfirmation");
          userConfirm = confirm(this.get("message"));
          if (userConfirm) {
            this.sendAction("action", this.get("param"));
          }
        },
        confirm: function() {
          this.toggleProperty("isShowingConfirmation");
          this.sendAction("action", this.get("param"));
        }
      }
    });

    __exports__["default"] = ConfirmationLinkComponent;
  });
define("cms/components/flash-message", 
  ["ember","flash-messages/components/flash-message","exports"],
  function(__dependency1__, __dependency2__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    var FlashMessage = __dependency2__["default"];
    __exports__["default"] = FlashMessage;
  });
define("cms/components/s3-upload", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    var S3UploadComponent;

    S3UploadComponent = Ember.FileField.extend({
      multiple: true,
      url: "",
      websiteName: "",
      filesDidChange: (function() {
        var count, countWrapper, file, files, index, label, loader, success, uploadUrl, uploader, _i, _len;
        uploadUrl = this.get("url") + "?locationName=" + this.get('websiteName');
        files = this.get("files");
        uploader = Ember.S3Uploader.create({
          url: uploadUrl
        });
        label = $(".assets-uploader label");
        loader = $(".assets-loader");
        success = $(".assets-success");
        countWrapper = $(".asset-count");
        count = 0;
        uploader.on("didUpload", (function(_this) {
          return function(response) {
            var uploadedUrl;
            count = count + 1;
            uploadedUrl = $(response).find("Location")[0].textContent;
            uploadedUrl = unescape(uploadedUrl);
            _this.sendAction('action', uploadedUrl);
            countWrapper.text(count);
            if (count === files.length) {
              loader.hide();
              success.show(0).delay(2000).fadeOut("fast");
              label.delay(2200).fadeIn("fast");
            }
          };
        })(this));
        if (!Ember.isEmpty(files)) {
          $(".asset-total").text(files.length);
          loader.show();
          label.hide();
          for (index = _i = 0, _len = files.length; _i < _len; index = ++_i) {
            file = files[index];
            uploader.upload(file);
          }
        }
      }).observes("files")
    });

    __exports__["default"] = S3UploadComponent;
  });
define("cms/components/widget-modal", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    var WidgetModalComponent;

    WidgetModalComponent = Ember.Component.extend({
      widgetNameForTitle: "WIDGET",
      setTitleFromGarden: (function() {
        return this.set("widgetNameForTitle", this.get("observableObject.selectedWidgetName"));
      }).observes("observableObject.selectedWidgetName"),
      setTitleFromWidget: (function() {
        return this.set("widgetNameForTitle", this.get("selectedWidgetName"));
      }).observes("selectedWidgetName"),
      addWidgetGardenObservableObject: (function() {
        var observableObject;
        observableObject = Ember.Object.create();
        this.set("observableObject", observableObject);
        return this.$("#modal").data("component", observableObject);
      }).on("didInsertElement")
    });

    __exports__["default"] = WidgetModalComponent;
  });
define("cms/controllers/application", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    var ApplicationController;

    ApplicationController = Ember.Controller.extend({
      needs: ['client', 'location', 'website', 'webPageTemplate', 'webHomeTemplate', 'webTheme', 'webLayout']
    });

    __exports__["default"] = ApplicationController;
  });
define("cms/controllers/aside-after-main-widgets", 
  ["ember","cms/controllers/sortable-widgets","exports"],
  function(__dependency1__, __dependency2__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    var SortableWidgetsController = __dependency2__["default"];
    var AsideAfterMainWidgetsController;

    AsideAfterMainWidgetsController = SortableWidgetsController.extend({
      needs: ["website"]
    });

    __exports__["default"] = AsideAfterMainWidgetsController;
  });
define("cms/controllers/aside-before-main-widgets", 
  ["ember","cms/controllers/sortable-widgets","exports"],
  function(__dependency1__, __dependency2__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    var SortableWidgetsController = __dependency2__["default"];
    var AsideBeforeMainWidgetsController;

    AsideBeforeMainWidgetsController = SortableWidgetsController.extend({
      needs: ["website"]
    });

    __exports__["default"] = AsideBeforeMainWidgetsController;
  });
define("cms/controllers/btn-widgets", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    var BtnWidgetsController;

    BtnWidgetsController = Ember.ArrayController.extend({
      needs: ["website"]
    });

    __exports__["default"] = BtnWidgetsController;
  });
define("cms/controllers/client", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    var ClientController;

    ClientController = Ember.Controller.extend();

    __exports__["default"] = ClientController;
  });
define("cms/controllers/footer-widgets", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    var FooterWidgetsController;

    FooterWidgetsController = Ember.ArrayController.extend({
      needs: ["website"]
    });

    __exports__["default"] = FooterWidgetsController;
  });
define("cms/controllers/garden-web-layout", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    var GardenWebLayoutController;

    GardenWebLayoutController = Ember.Controller.extend();

    __exports__["default"] = GardenWebLayoutController;
  });
define("cms/controllers/garden-web-layouts", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    var GardenWebLayoutsController;

    GardenWebLayoutsController = Ember.ArrayController.extend({
      needs: ["webLayout", "gardenWebLayout"],
      selectedLayout: (function() {
        return this.get("controllers.webLayout.model");
      }).property("controllers.webLayout.model"),
      relevantLayouts: (function() {
        var layouts, names;
        layouts = this.store.all('web_layout');
        names = layouts.map(function(layout) {
          return layout.get('name');
        });
        return names;
      }).property(),
      actions: {
        update: function(gardenWebLayout) {
          var webLayout;
          webLayout = this.get("controllers.webLayout.model");
          webLayout.set("gardenWebLayoutId", gardenWebLayout.get("id"));
          return webLayout.save();
        }
      }
    });

    __exports__["default"] = GardenWebLayoutsController;
  });
define("cms/controllers/garden-web-themes", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    var GardenWebThemesController;

    GardenWebThemesController = Ember.ArrayController.extend({
      needs: ["webTheme", "webThemes", "gardenWebThemes"],
      selectedTheme: (function() {
        return this.get("controllers.webTheme.model");
      }).property("controllers.webTheme.model"),
      relevantThemes: (function() {
        var names, themes;
        themes = this.store.all('web_theme');
        names = themes.map(function(theme) {
          return theme.get('name');
        });
        return names;
      }).property(),
      actions: {
        update: function(gardenWebTheme) {
          var userConfirm, webTheme;
          userConfirm = confirm("You are about to select this theme. Are you sure?");
          if (userConfirm) {
            webTheme = this.get("controllers.webTheme.model");
            webTheme.set("gardenWebThemeId", gardenWebTheme.get("id"));
            return webTheme.save();
          }
        }
      }
    });

    __exports__["default"] = GardenWebThemesController;
  });
define("cms/controllers/garden-widgets", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    var GardenWidgetsController;

    GardenWidgetsController = Ember.ArrayController.extend({
      sortProperties: ["name"],
      sortAscending: true,
      currentDragItem: (function() {
        return this.findProperty("isDragging", true);
      }).property("@each.isDragging")
    });

    __exports__["default"] = GardenWidgetsController;
  });
define("cms/controllers/head-widgets", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    var HeadWidgetsController;

    HeadWidgetsController = Ember.ArrayController.extend({
      needs: ["website"]
    });

    __exports__["default"] = HeadWidgetsController;
  });
define("cms/controllers/location", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    var LocationController;

    LocationController = Ember.Controller.extend();

    __exports__["default"] = LocationController;
  });
define("cms/controllers/locations", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    var LocationsController;

    LocationsController = Ember.ArrayController.extend({
      needs: ["client"]
    });

    __exports__["default"] = LocationsController;
  });
define("cms/controllers/logo-widgets", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    var LogoWidgetsController;

    LogoWidgetsController = Ember.ArrayController.extend({
      needs: ["website"]
    });

    __exports__["default"] = LogoWidgetsController;
  });
define("cms/controllers/main-widgets", 
  ["ember","cms/controllers/sortable-widgets","exports"],
  function(__dependency1__, __dependency2__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    var SortableWidgetsController = __dependency2__["default"];
    var MainWidgetsController;

    MainWidgetsController = SortableWidgetsController.extend({
      needs: ["website"]
    });

    __exports__["default"] = MainWidgetsController;
  });
define("cms/controllers/nav-widgets", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    var NavWidgetsController;

    NavWidgetsController = Ember.ArrayController.extend({
      needs: ["website"]
    });

    __exports__["default"] = NavWidgetsController;
  });
define("cms/controllers/redirect-manager", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    var RedirectManagerController;

    RedirectManagerController = Ember.Controller.extend({
      actions: {
        save: function(model) {
          model.get("webHomeTemplate").save();
          return model.get("webPageTemplates").forEach(function(webPageTemplate) {
            return webPageTemplate.save();
          });
        }
      }
    });

    __exports__["default"] = RedirectManagerController;
  });
define("cms/controllers/sortable-widgets", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    var SortableWidgetsController;

    SortableWidgetsController = Ember.ArrayController.extend({
      needs: ["website"],
      sortProperties: ["displayOrder"],
      updateSortOrder: function(indexes) {
        this.beginPropertyChanges();
        this.get("content").forEach(function(item) {
          var index;
          if ((item != null) && item.get("currentState.stateName") !== "root.deleted.saved") {
            if (item.get("isRemoved")) {
              item.deleteRecord();
              return item.save();
            } else {
              index = indexes[item.get("id")];
              item.set("displayOrderPosition", index);
              return item.save();
            }
          }
        });
        return this.endPropertyChanges();
      }
    });

    __exports__["default"] = SortableWidgetsController;
  });
define("cms/controllers/web-home-template", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    var WebHomeTemplateController;

    WebHomeTemplateController = Ember.Controller.extend();

    __exports__["default"] = WebHomeTemplateController;
  });
define("cms/controllers/web-layout", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    var WebLayoutController;

    WebLayoutController = Ember.Controller.extend();

    __exports__["default"] = WebLayoutController;
  });
define("cms/controllers/web-page-template", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    var WebPageTemplateController;

    WebPageTemplateController = Ember.Controller.extend({
      needs: ["client"],
      templates: (function() {
        var mutableTemplates;
        mutableTemplates = [];
        this.parentController.get('content').forEach(function(template) {
          return mutableTemplates.pushObject(template);
        });
        return mutableTemplates.removeObject(this.get("model"));
      }).property(),
      classNameForVertical: (function() {
        var vertical;
        vertical = this.get("controllers.client.vertical");
        if (vertical) {
          return ("" + (vertical.toLowerCase()) + " client").dasherize();
        } else {
          return "";
        }
      }).property('controllers.client.vertical'),
      actions: {
        deploy: function(model) {
          var url;
          url = "/websites/" + model.get("website.id") + "/deploy";
          $("<form action='" + url + "' method='post'></form>").appendTo("body").submit();
          return false;
        },
        deploy_all: function(model) {
          var $form, url;
          url = "/api/v1/clients/1/deploy_websites";
          $form = $("<form action='" + url + "' method='post'></form>");
          $form.appendTo("body").submit();
          return false;
        },
        save: function(model) {
          return model.save();
        }
      }
    });

    __exports__["default"] = WebPageTemplateController;
  });
define("cms/controllers/web-page-templates", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    var WebPageTemplatesController;

    WebPageTemplatesController = Ember.ArrayController.extend();

    __exports__["default"] = WebPageTemplatesController;
  });
define("cms/controllers/web-theme", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    var WebThemeController;

    WebThemeController = Ember.Controller.extend();

    __exports__["default"] = WebThemeController;
  });
define("cms/controllers/web-themes", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    var WebThemesController;

    WebThemesController = Ember.ArrayController.extend();

    __exports__["default"] = WebThemesController;
  });
define("cms/controllers/website-template", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    var WebsiteTemplateController;

    WebsiteTemplateController = Ember.Controller.extend();

    __exports__["default"] = WebsiteTemplateController;
  });
define("cms/controllers/website-web-home-template", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    var WebsiteWebHomeTemplateController;

    WebsiteWebHomeTemplateController = Ember.Controller.extend({
      actions: {
        save: function(model) {
          return model.save();
        },
        cancel: function(model) {
          return model.rollback();
        }
      }
    });

    __exports__["default"] = WebsiteWebHomeTemplateController;
  });
define("cms/controllers/website-web-page-templates-in-trash", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    var WebsiteWebPageTemplatesInTrashController;

    WebsiteWebPageTemplatesInTrashController = Ember.Controller.extend({
      actions: {
        save: function(model) {
          return model.save();
        },
        cancel: function(model) {
          return model.rollback();
        }
      }
    });

    __exports__["default"] = WebsiteWebPageTemplatesInTrashController;
  });
define("cms/controllers/website-web-page-templates", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    var WebsiteWebPageTemplatesController;

    WebsiteWebPageTemplatesController = Ember.Controller.extend({
      itemController: 'WebPageTemplate',
      updateSortOrder: function(indexes) {
        var length;
        this.beginPropertyChanges();
        length = this.get("length") - 1;
        this.get("model").forEach(function(item, i) {
          var index;
          index = indexes[item.get("id")];
          item.set("displayOrderPosition", index);
          return item.set("shouldUpdateNavigationSettings", (i === length ? true : false));
        });
        this.endPropertyChanges();
        return this.get("model").save().then((function(_this) {
          return function() {
            return _this.get("model").map(function(item) {
              return item.set("shouldUpdateNavigationSettings", true);
            });
          };
        })(this));
      },
      templates: (function() {
        return this.get("model");
      }).property(),
      actions: {
        save: function(model) {
          return model.save();
        },
        cancel: function(model) {
          return model.rollback();
        }
      }
    });

    __exports__["default"] = WebsiteWebPageTemplatesController;
  });
define("cms/controllers/website", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    var WebsiteController;

    WebsiteController = Ember.Controller.extend({
      selectedWidgetName: null
    });

    __exports__["default"] = WebsiteController;
  });
define("cms/controllers/website/asset", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    var AssetController;

    AssetController = Ember.Controller.extend({
      needs: ['website', 'website/assets'],
      website: Ember.computed.alias("controllers.website.content"),
      categories: (function() {
        return this.parentController.get("categories");
      }).property()
    });

    __exports__["default"] = AssetController;
  });
define("cms/controllers/website/assets", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    var AssetsController;

    AssetsController = Ember.ArrayController.extend({
      itemController: 'website/asset',
      sortProperties: ['created_at'],
      sortAscending: false,
      needs: ['website'],
      website: Ember.computed.alias("controllers.website.content"),
      categories: (function() {
        return this.store.find("category");
      }).property(),
      actions: {
        save: function(model) {
          return model.save();
        },
        saveAsset: function(uploadedUrl) {
          var asset, website;
          website = this.get('website');
          asset = this.get('store').createRecord('asset', {
            website_id: website.get('id'),
            url: uploadedUrl,
            category_id: 1
          });
          website.get('assets').addObject(asset);
          return asset.save().then(((function(_this) {
            return function(asset) {};
          })(this)), (function(_this) {
            return function(asset) {
              var errorField, key;
              errorField = void 0;
              for (key in asset.get('errors')) {
                errorField = key;
              }
              console.log("the error field is: " + errorField);
              return asset.deleteRecord();
            };
          })(this));
        },
        deleteAsset: function(asset) {
          var uploader, website;
          website = this.get('website');
          uploader = Ember.S3Uploader.create({
            url: '/api/v1/sign_delete?locationName=' + website.get('name')
          });
          return uploader.deleteAsset(asset).then((function(response) {
            website.get('assets').removeObject(asset);
            asset.deleteRecord();
            return asset.save();
          }), function(response) {
            return console.log('The delete failed: ' + response);
          });
        }
      }
    });

    __exports__["default"] = AssetsController;
  });
define("cms/controllers/website/index", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    var WebsiteIndexController;

    WebsiteIndexController = Ember.Controller.extend({
      confirmEmptyTrash: false,
      needs: ["client"],
      websiteTemplate: (function() {
        return this.get('model.websiteTemplate');
      }).property(),
      webHomeTemplate: (function() {
        return this.get('model.webHomeTemplate');
      }).property(),
      webPageTemplates: (function() {
        return this.get('model.webPageTemplates');
      }).property(),
      actions: {
        confirmEmptyTrash: function() {
          return this.set("confirmEmptyTrash", !this.get("confirmEmptyTrash"));
        },
        emptyTrash: function() {
          this.beginPropertyChanges();
          this.get("webPageTemplates").filterBy("inTrash", true).forEach(function(item) {
            item.deleteRecord();
            return item.save();
          });
          this.endPropertyChanges();
          return this.set("confirmEmptyTrash", false);
        }
      }
    });

    __exports__["default"] = WebsiteIndexController;
  });
define("cms/controllers/website/releases", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    var ReleasesController;

    ReleasesController = Ember.ArrayController.extend({
      needs: ['website'],
      actions: {
        rollback: function(id) {
          var slug;
          slug = this.get('controllers.website.model.slug');
          this.postTo(this.get('adapter').buildURL('releases') + id + '/website/' + slug);
          return false;
        }
      },
      adapter: (function() {
        return this.container.lookup("adapter:application");
      }).property(),
      postTo: function(url) {
        return this.get('adapter').ajax(url, "POST").then((function(_this) {
          return function(response) {
            return _this.get('flashes').success(response.message);
          };
        })(this), (function(_this) {
          return function(response) {
            return _this.get('flashes').danger(response.statusText);
          };
        })(this));
      }
    });

    __exports__["default"] = ReleasesController;
  });
define("cms/helpers/format-date", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    var FormatDateHelper;

    FormatDateHelper = Ember.Handlebars.registerBoundHelper('formatDate', function(date) {
      return moment(date).format('MMMM Do YYYY, h:mm:ss a');
    });

    __exports__["default"] = FormatDateHelper;
  });
define("cms/initializers/export-application-global", 
  ["ember","cms/config/environment","exports"],
  function(__dependency1__, __dependency2__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    var config = __dependency2__["default"];

    function initialize(container, application) {
      var classifiedName = Ember.String.classify(config.modulePrefix);

      if (config.exportApplicationGlobal) {
        window[classifiedName] = application;
      }
    };
    __exports__.initialize = initialize;

    __exports__["default"] = {
      name: 'export-application-global',

      initialize: initialize
    };
  });
define("cms/initializers/inject-flash-messages", 
  ["flash-messages/services/flash-message-service","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var flashMessagesService = __dependency1__["default"];

    function initialize(container, application) {
      application.register('service:flash-messages', flashMessagesService, { singleton: true });
      application.inject('controller', 'flashes', 'service:flash-messages');
    }

    __exports__.initialize = initialize;
    __exports__["default"] = {
      name: 'inject-flash-messages',
      initialize: initialize
    };
  });
define("cms/mixins/jq-base", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    var JqBaseMixin;

    JqBaseMixin = Ember.Mixin.create({
      didInsertElement: function() {
        var options, ui;
        options = this._gatherOptions();
        this._gatherEvents(options);
        ui = jQuery.ui[this.get("uiType")](options, this.get("element"));
        return this.set("ui", ui);
      },
      willDestroyElement: function() {
        var observers, prop, ui;
        ui = this.get("ui");
        if (ui) {
          observers = this._observers;
          for (prop in observers) {
            if (observers.hasOwnProperty(prop)) {
              this.removeObserver(prop, observers[prop]);
            }
          }
          return ui._destroy();
        }
      },
      _gatherOptions: function() {
        var options, uiOptions;
        uiOptions = this.get("uiOptions");
        options = {};
        uiOptions.forEach((function(key) {
          var observer;
          options[key] = this.get(key);
          observer = function() {
            var value;
            value = this.get(key);
            return this.get("ui").option(key, value);
          };
          this.addObserver(key, observer);
          this._observers = this._observers || {};
          return this._observers[key] = observer;
        }), this);
        return options;
      },
      _gatherEvents: function(options) {
        var self, uiEvents;
        uiEvents = this.get("uiEvents") || [];
        self = this;
        return uiEvents.forEach(function(event) {
          var callback;
          callback = self[event];
          if (callback) {
            return options[event] = function(event, ui) {
              return callback.call(self, event, ui);
            };
          }
        });
      }
    });

    __exports__["default"] = JqBaseMixin;
  });
define("cms/mixins/jq-draggable", 
  ["ember","cms/mixins/jq-base","exports"],
  function(__dependency1__, __dependency2__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    var JqBaseMixin = __dependency2__["default"];
    var JqDraggableMixin;

    JqDraggableMixin = Ember.Mixin.create(JqBaseMixin, {
      uiType: "draggable",
      uiOptions: ["addClasses", "appendTo", "axis", "cancel", "connectToSortable", "containment", "cursor", "cursorAt", "delay", "disabled", "distance", "grid", "handle", "helper", "iframeFix", "opacity", "refreshPositions", "revert", "revertDuration", "scope", "scroll", "scrollSensitivity", "scrollSpeed", "snap", "snapMode", "snapTolerance", "stack", "zIndex"],
      uiEvents: ["create", "drag", "start", "stop"]
    });

    __exports__["default"] = JqDraggableMixin;
  });
define("cms/mixins/jq-droppable", 
  ["ember","cms/mixins/jq-base","exports"],
  function(__dependency1__, __dependency2__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    var JqBaseMixin = __dependency2__["default"];
    var JqDroppableMixin;

    JqDroppableMixin = Ember.Mixin.create(JqBaseMixin, {
      uiType: "droppable",
      uiOptions: ["accept", "activeClass", "addClasses", "disabled", "greedy", "hoverClass", "scope", "tolerance"],
      uiEvents: ["activate", "create", "deactivate", "drop", "out", "over"]
    });

    __exports__["default"] = JqDroppableMixin;
  });
define("cms/mixins/jq-sortable", 
  ["ember","cms/mixins/jq-base","exports"],
  function(__dependency1__, __dependency2__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    var JqBaseMixin = __dependency2__["default"];
    var JqSortableMixin;

    JqSortableMixin = Ember.Mixin.create(JqBaseMixin, {
      uiType: "sortable",
      uiOptions: ["appendTo", "axis", "cancel", "connectWith", "containment", "cursor", "cursorAt", "delay", "disabled", "distance", "dropOnEmpty", "forceHelperSize", "forcePlaceholderSize", "grid", "handle", "helper", "items", "opacity", "placeholder", "revert", "scroll", "scrollSensitivity", "scrollSpeed", "tolerance", "zIndex"],
      uiEvents: ["activate", "beforeStop", "change", "create", "deactivate", "out", "over", "receive", "remove", "sort", "start", "stop", "update"]
    });

    __exports__["default"] = JqSortableMixin;
  });
define("cms/mixins/reload-iframe", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    var ReloadIframeMixin;

    ReloadIframeMixin = Ember.Mixin.create({
      reloadIframe: function() {
        var url;
        url = $('iframe').prop('src');
        return $('iframe').prop('src', url);
      },
      didCreate: function() {
        return this.reloadIframe();
      },
      didUpdate: function() {
        return this.reloadIframe();
      },
      didDelete: function() {
        return this.reloadIframe();
      }
    });

    __exports__["default"] = ReloadIframeMixin;
  });
define("cms/models/aside-after-main-widget", 
  ["ember-data","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var DS = __dependency1__["default"];
    var AsideAfterMainWidget;

    AsideAfterMainWidget = DS.Model.extend({
      gardenWidgetId: DS.attr("number"),
      websiteTemplate: DS.belongsTo("websiteTemplate"),
      name: DS.attr("string"),
      thumbnail: DS.attr("string"),
      url: DS.attr("string"),
      section: DS.attr("string"),
      displayOrder: DS.attr("number"),
      displayOrderPosition: DS.attr("number"),
      isRemoved: false
    });

    __exports__["default"] = AsideAfterMainWidget;
  });
define("cms/models/aside-before-main-widget", 
  ["ember-data","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var DS = __dependency1__["default"];
    var AsideBeforeMainWidget;

    AsideBeforeMainWidget = DS.Model.extend({
      gardenWidgetId: DS.attr("number"),
      websiteTemplate: DS.belongsTo("websiteTemplate"),
      name: DS.attr("string"),
      thumbnail: DS.attr("string"),
      url: DS.attr("string"),
      section: DS.attr("string"),
      displayOrder: DS.attr("number"),
      displayOrderPosition: DS.attr("number"),
      isRemoved: false,
      widget_type: DS.attr("string"),
      drop_target_id: DS.attr()
    });

    __exports__["default"] = AsideBeforeMainWidget;
  });
define("cms/models/asset", 
  ["ember-data","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var DS = __dependency1__["default"];
    var Asset;

    Asset = DS.Model.extend({
      website: DS.belongsTo("website"),
      category: DS.belongsTo("category"),
      url: DS.attr("string"),
      categoryName: DS.attr("string")
    });

    __exports__["default"] = Asset;
  });
define("cms/models/btn-widget", 
  ["ember-data","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var DS = __dependency1__["default"];
    var BtnWidget;

    BtnWidget = DS.Model.extend({
      websiteTemplate: DS.belongsTo("websiteTemplate"),
      name: DS.attr("string"),
      thumbnail: DS.attr("string"),
      url: DS.attr("string"),
      section: DS.attr("string")
    });

    __exports__["default"] = BtnWidget;
  });
define("cms/models/category", 
  ["ember-data","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var DS = __dependency1__["default"];
    var Category;

    Category = DS.Model.extend({
      name: DS.attr("string"),
      slug: DS.attr("string"),
      assets: DS.hasMany("asset")
    });

    __exports__["default"] = Category;
  });
define("cms/models/client", 
  ["ember-data","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var DS = __dependency1__["default"];
    var Client;

    Client = DS.Model.extend({
      locations: DS.hasMany("location"),
      websites: DS.hasMany("website"),
      urn: DS.attr("string"),
      name: DS.attr("string"),
      url: DS.attr("string"),
      location_urns: DS.attr("string"),
      location_urls: DS.attr("string"),
      cms_urn: DS.attr("string"),
      cms_url: DS.attr("string"),
      cpns_urn: DS.attr("string"),
      cpns_url: DS.attr("string"),
      cpas_urn: DS.attr("string"),
      cpas_url: DS.attr("string"),
      cls_urn: DS.attr("string"),
      cls_url: DS.attr("string"),
      cxm_urn: DS.attr("string"),
      cxm_url: DS.attr("string"),
      dsh_urn: DS.attr("string"),
      dsh_url: DS.attr("string"),
      single_domain: DS.attr("boolean"),
      vertical: DS.attr("string")
    });

    __exports__["default"] = Client;
  });
define("cms/models/flash", 
  ["ember","flash-messages/models/flash","exports"],
  function(__dependency1__, __dependency2__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    var Flash = __dependency2__["default"];
    __exports__["default"] = Flash;
  });
define("cms/models/footer-widget", 
  ["ember-data","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var DS = __dependency1__["default"];
    var FooterWidget;

    FooterWidget = DS.Model.extend({
      websiteTemplate: DS.belongsTo("websiteTemplate"),
      name: DS.attr("string"),
      thumbnail: DS.attr("string"),
      url: DS.attr("string"),
      section: DS.attr("string"),
      widget_type: DS.attr("string"),
      garden_widget_id: DS.attr(),
      drop_target_id: DS.attr(),
      display_order: DS.attr()
    });

    __exports__["default"] = FooterWidget;
  });
define("cms/models/garden-web-layout", 
  ["ember-data","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var DS = __dependency1__["default"];
    var GardenWebLayout;

    GardenWebLayout = DS.Model.extend({
      name: DS.attr("string"),
      thumbnail: DS.attr("string"),
      url: DS.attr("string")
    });

    __exports__["default"] = GardenWebLayout;
  });
define("cms/models/garden-web-theme", 
  ["ember-data","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var DS = __dependency1__["default"];
    var GardenWebTheme;

    GardenWebTheme = DS.Model.extend({
      name: DS.attr("string"),
      thumbnail: DS.attr("string"),
      url: DS.attr("string")
    });

    __exports__["default"] = GardenWebTheme;
  });
define("cms/models/garden-widget", 
  ["ember-data","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var DS = __dependency1__["default"];
    var GardenWidget;

    GardenWidget = DS.Model.extend({
      name: DS.attr("string"),
      thumbnail: DS.attr("string"),
      url: DS.attr("string"),
      widget_type: DS.attr("string")
    });

    __exports__["default"] = GardenWidget;
  });
define("cms/models/head-widget", 
  ["ember-data","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var DS = __dependency1__["default"];
    var HeadWidget;

    HeadWidget = DS.Model.extend({
      websiteTemplate: DS.belongsTo("websiteTemplate"),
      name: DS.attr("string"),
      thumbnail: DS.attr("string"),
      url: DS.attr("string"),
      section: DS.attr("string"),
      widget_type: DS.attr("string"),
      garden_widget_id: DS.attr(),
      drop_target_id: DS.attr(),
      display_order: DS.attr()
    });

    __exports__["default"] = HeadWidget;
  });
define("cms/models/location", 
  ["ember-data","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var DS = __dependency1__["default"];
    var Location;

    Location = DS.Model.extend({
      urn: DS.attr("string"),
      domain: DS.attr("string"),
      name: DS.attr("string"),
      corporate: DS.attr("boolean"),
      single_domain: DS.attr("boolean"),
      websiteHerokuUrl: DS.attr("string"),
      websiteSlug: DS.attr("string"),
      websiteId: DS.attr("string"),
      status: DS.attr("string"),
      status_class: DS.attr("string")
    });

    __exports__["default"] = Location;
  });
define("cms/models/logo-widget", 
  ["ember-data","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var DS = __dependency1__["default"];
    var LogoWidget;

    LogoWidget = DS.Model.extend({
      websiteTemplate: DS.belongsTo("websiteTemplate"),
      name: DS.attr("string"),
      thumbnail: DS.attr("string"),
      url: DS.attr("string"),
      section: DS.attr("string"),
      widget_type: DS.attr("string"),
      garden_widget_id: DS.attr(),
      drop_target_id: DS.attr(),
      display_order: DS.attr()
    });

    __exports__["default"] = LogoWidget;
  });
define("cms/models/main-widget", 
  ["ember-data","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var DS = __dependency1__["default"];
    var MainWidget;

    MainWidget = DS.Model.extend({
      gardenWidgetId: DS.attr("number"),
      webHomeTemplate: DS.belongsTo("WebHomeTemplate"),
      webPageTemplate: DS.belongsTo("WebPageTemplate"),
      name: DS.attr("string"),
      thumbnail: DS.attr("string"),
      url: DS.attr("string"),
      section: DS.attr("string"),
      displayOrder: DS.attr("number"),
      displayOrderPosition: DS.attr("number"),
      widget_type: DS.attr("string"),
      isRemoved: false,
      drop_target_id: DS.attr()
    });

    __exports__["default"] = MainWidget;
  });
define("cms/models/nav-widget", 
  ["ember-data","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var DS = __dependency1__["default"];
    var NavWidget;

    NavWidget = DS.Model.extend({
      websiteTemplate: DS.belongsTo("websiteTemplate"),
      name: DS.attr("string"),
      thumbnail: DS.attr("string"),
      url: DS.attr("string"),
      section: DS.attr("string"),
      widget_type: DS.attr("string"),
      garden_widget_id: DS.attr(),
      drop_target_id: DS.attr(),
      display_order: DS.attr()
    });

    __exports__["default"] = NavWidget;
  });
define("cms/models/release", 
  ["ember-data","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var DS = __dependency1__["default"];
    var Release;

    Release = DS.Model.extend({
      created_at: DS.attr("date"),
      current: DS.attr("boolean"),
      slug: DS.attr(),
      website: DS.belongsTo("website")
    });

    __exports__["default"] = Release;
  });
define("cms/models/save", 
  ["ember-data","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var DS = __dependency1__["default"];
    var Save;

    Save = DS.Model.extend({
      created_at: DS.attr("string")
    });

    __exports__["default"] = Save;
  });
define("cms/models/web-home-template", 
  ["ember-data","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var DS = __dependency1__["default"];
    var WebHomeTemplate;

    WebHomeTemplate = DS.Model.extend({
      website: DS.belongsTo("website"),
      mainWidgets: DS.hasMany("mainWidget"),
      previewUrl: DS.attr("string"),
      name: DS.attr("string"),
      slug: DS.attr("string"),
      title: DS.attr("string"),
      redirect_patterns: DS.attr("string"),
      enabled: DS.attr("boolean"),
      isWebHomeTemplate: true
    });

    __exports__["default"] = WebHomeTemplate;
  });
define("cms/models/web-layout", 
  ["ember-data","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var DS = __dependency1__["default"];
    var WebLayout;

    WebLayout = DS.Model.extend({
      gardenWebLayoutId: DS.attr("number"),
      websiteTemplate: DS.belongsTo("websiteTemplate"),
      name: DS.attr("string"),
      thumbnail: DS.attr("string"),
      url: DS.attr("string"),
      title: "Layouts"
    });

    __exports__["default"] = WebLayout;
  });
define("cms/models/web-page-template", 
  ["ember-data","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var DS = __dependency1__["default"];
    var WebPageTemplate;

    WebPageTemplate = DS.Model.extend({
      website: DS.belongsTo("website"),
      mainWidgets: DS.hasMany("mainWidget"),
      previewUrl: DS.attr("string"),
      name: DS.attr("string"),
      slug: DS.attr("string"),
      title: DS.attr("string"),
      redirect_patterns: DS.attr("string"),
      enabled: DS.attr("boolean"),
      displayOrder: DS.attr("number"),
      displayOrderPosition: DS.attr("number"),
      inTrash: DS.attr("boolean"),
      parent: DS.belongsTo("WebPageTemplate", {
        inverse: null
      }),
      shouldUpdateNavigationSettings: DS.attr("boolean"),
      defaultValue: function() {
        return true;
      },
      parentChanged: (function() {
        return this.set('shouldUpdateNavigationSettings', true);
      }).observes('parent')
    });

    __exports__["default"] = WebPageTemplate;
  });
define("cms/models/web-theme", 
  ["ember-data","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var DS = __dependency1__["default"];
    var WebTheme;

    WebTheme = DS.Model.extend({
      gardenWebThemeId: DS.attr("number"),
      websiteTemplate: DS.belongsTo("websiteTemplate"),
      name: DS.attr("string"),
      thumbnail: DS.attr("string"),
      url: DS.attr("string"),
      customColors: DS.attr("boolean"),
      primaryColor: DS.attr("string"),
      secondaryColor: DS.attr("string"),
      tertiaryColor: DS.attr("string"),
      customFonts: DS.attr("boolean"),
      primaryFont: DS.attr("string"),
      secondaryFont: DS.attr("string"),
      noCustomFonts: Ember.computed.not('customFonts'),
      primaryFontValue: (function() {
        if (this.get('customFonts')) {
          return this.get('primaryFont');
        } else {
          return '';
        }
      }).property('customFonts'),
      secondaryFontValue: (function() {
        if (this.get('customFonts')) {
          return this.get('secondaryFont');
        } else {
          return '';
        }
      }).property('customFonts'),
      defaultPrimaryFont: "PT Sans",
      defaultSecondaryFont: "Georgia"
    });

    __exports__["default"] = WebTheme;
  });
define("cms/models/website-template", 
  ["ember-data","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var DS = __dependency1__["default"];
    var WebsiteTemplate;

    WebsiteTemplate = DS.Model.extend({
      website: DS.belongsTo("website"),
      webLayout: DS.belongsTo("WebLayout"),
      webTheme: DS.belongsTo("WebTheme"),
      headWidgets: DS.hasMany("HeadWidget"),
      logoWidgets: DS.hasMany("LogoWidget"),
      btnWidgets: DS.hasMany("BtnWidget"),
      navWidgets: DS.hasMany("NavWidget"),
      asideBeforeMainWidgets: DS.hasMany("AsideBeforeMainWidget"),
      asideAfterMainWidgets: DS.hasMany("AsideAfterMainWidget"),
      footerWidgets: DS.hasMany("FooterWidget")
    });

    __exports__["default"] = WebsiteTemplate;
  });
define("cms/models/website", 
  ["ember-data","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var DS = __dependency1__["default"];
    var Website;

    Website = DS.Model.extend({
      location: DS.belongsTo("location"),
      websiteTemplate: DS.belongsTo("websiteTemplate"),
      webHomeTemplate: DS.belongsTo("webHomeTemplate"),
      webPageTemplates: DS.hasMany("webPageTemplate"),
      releases: DS.hasMany("release"),
      assets: DS.hasMany("asset"),
      name: DS.attr("string"),
      urn: DS.attr("string"),
      slug: DS.attr("string"),
      corporate: DS.attr("boolean"),
      herokuUrl: DS.attr("string"),
      owner_id: DS.attr(),
      owner_type: DS.attr(),
      category_ids: DS.attr()
    });

    __exports__["default"] = Website;
  });
define("cms/router", 
  ["ember","cms/config/environment","exports"],
  function(__dependency1__, __dependency2__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];

    var config = __dependency2__["default"];

    var Router;

    Router = Ember.Router.extend({
      location: config.locationType
    });

    Router.map(function() {
      this.route("redirectManager", {
        path: "/:website_slug/redirects"
      });
      this.route("docs", {
        path: "/:website_slug/docs"
      });
      this.route("saves");
      this.resource("website", {
        path: "/:website_slug"
      }, function() {
        this.route("assets");
        this.route("releases");
        this.resource("webHomeTemplate", {
          path: "home"
        });
        this.resource("webPageTemplate", {
          path: ":web_page_template_slug"
        });
        return this.resource("webPageTemplates", {
          path: "web-page-template"
        }, function() {
          return this.route("new");
        });
      });
      return this.resource("locations", {
        path: "/"
      });
    });

    __exports__["default"] = Router;;
  });
define("cms/routes/application", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    var ApplicationRoute;

    ApplicationRoute = Ember.Route.extend({
      model: function() {
        return this.store.find("Client", 1);
      },
      setupController: function(controller, model) {
        return this.controllerFor("client").set("model", model);
      },
      actions: {
        deploy: function(id) {
          this.postTo(this.get('adapter').buildURL('websites', id) + '/deploy');
          return false;
        },
        deploy_all: function(id) {
          this.postTo(this.get('adapter').buildURL('client', 1) + '/deploy_websites');
          return false;
        },
        updateGardenWebLayouts: function() {
          this.postTo(this.get('adapter').buildURL('garden_web_layouts') + '/update');
          return false;
        },
        updateGardenWebThemes: function() {
          this.postTo(this.get('adapter').buildURL('garden_web_themes') + '/update');
          return false;
        },
        updateGardenWidgets: function() {
          this.postTo(this.get('adapter').buildURL('garden_widgets') + '/update');
          return false;
        }
      },
      adapter: (function() {
        return this.container.lookup("adapter:application");
      }).property(),
      postTo: function(url) {
        var flash;
        flash = this.controllerFor('application').get('flashes');
        return this.get('adapter').ajax(url, "POST").then((function(_this) {
          return function(response) {
            return flash.success(response.message);
          };
        })(this), (function(_this) {
          return function(response) {
            return flash.danger(response.statusText);
          };
        })(this));
      }
    });

    __exports__["default"] = ApplicationRoute;
  });
define("cms/routes/docs", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    var DocsRoute;

    DocsRoute = Ember.Route.extend({
      serialize: function(model) {
        return {
          website_slug: model.get("slug")
        };
      }
    });

    __exports__["default"] = DocsRoute;
  });
define("cms/routes/locations", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    var LocationsRoute;

    LocationsRoute = Ember.Route.extend({
      setupController: function(controller, model) {
        return controller.set("model", this.store.find('location'));
      }
    });

    __exports__["default"] = LocationsRoute;
  });
define("cms/routes/redirect-manager", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    var RedirectManagerRoute;

    RedirectManagerRoute = Ember.Route.extend({
      model: function(params) {
        var slug, websites;
        slug = params["website_slug"];
        websites = this.store.find('website');
        websites.one("didLoad", function() {
          var website;
          website = null;
          websites.forEach(function(x) {
            if (x.get("slug") === slug) {
              return website = x;
            }
          });
          return websites.resolve(website);
        });
        return websites;
      },
      setupController: function(controller, model) {
        controller.set("model", model);
        this.controllerFor("webHomeTemplate").set("model", model.get("webHomeTemplate"));
        return this.controllerFor("webPageTemplates").set("model", model.get("webPageTemplates"));
      },
      serialize: function(model) {
        return {
          website_slug: model.get("slug")
        };
      }
    });

    __exports__["default"] = RedirectManagerRoute;
  });
define("cms/routes/saves", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    var SavesRoute, inflector;

    inflector = Ember.Inflector.inflector;

    inflector.irregular('save', 'saves');

    SavesRoute = Ember.Route.extend({
      model: function() {
        return this.get('store').find('save');
      },
      actions: {
        restore: function(id) {
          var $form, url;
          url = "/api/v1/saves/" + id + "/restore";
          $form = $("<form action='" + url + "' method='post'></form>");
          $form.appendTo("body").submit();
          return false;
        },
        save: function() {
          var $form, url;
          url = "/api/v1/saves";
          $form = $("<form action='" + url + "' method='post'></form>");
          $form.appendTo("body").submit();
          return false;
        }
      }
    });

    __exports__["default"] = SavesRoute;
  });
define("cms/routes/web-home-template", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    var WebHomeTemplateRoute;

    WebHomeTemplateRoute = Ember.Route.extend({
      model: function() {
        return this.modelFor("website").get("webHomeTemplate");
      },
      setupController: function(controller, model) {
        controller.set("model", model);
        this.controllerFor("mainWidgets").set("model", model.get("mainWidgets"));
        this.controllerFor("websiteTemplate").set("model", model.get("websiteTemplate"));
        this.controllerFor("webLayout").set("model", model.get("website.websiteTemplate.webLayout"));
        this.controllerFor("webTheme").set("model", model.get("website.websiteTemplate.webTheme"));
        this.controllerFor("headWidgets").set("model", model.get("website.websiteTemplate.headWidgets"));
        this.controllerFor("logoWidgets").set("model", model.get("website.websiteTemplate.logoWidgets"));
        this.controllerFor("btnWidgets").set("model", model.get("website.websiteTemplate.btnWidgets"));
        this.controllerFor("navWidgets").set("model", model.get("website.websiteTemplate.navWidgets"));
        this.controllerFor("asideBeforeMainWidgets").set("model", model.get("website.websiteTemplate.asideBeforeMainWidgets"));
        this.controllerFor("asideAfterMainWidgets").set("model", model.get("website.websiteTemplate.asideAfterMainWidgets"));
        this.controllerFor("footerWidgets").set("model", model.get("website.websiteTemplate.footerWidgets"));
        this.controllerFor("gardenWebLayouts").set("model", this.store.find('gardenWebLayout'));
        this.controllerFor("gardenWebThemes").set("model", this.store.find("gardenWebTheme"));
        this.controllerFor("gardenWidgets").set("model", this.store.find("gardenWidget"));
        return this.setBreadcrumb(this.controllerFor("webHomeTemplate").get("model").get("name"));
      },
      setBreadcrumb: function(name) {
        return $('.page-name').show().find('strong').text(name);
      },
      deactivate: function() {
        return $('.page-name').hide();
      }
    });

    __exports__["default"] = WebHomeTemplateRoute;
  });
define("cms/routes/web-page-template", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    var WebPageTemplateRoute;

    WebPageTemplateRoute = Ember.Route.extend({
      model: function(params) {
        return this.store.find("webPageTemplate").then(function(result) {
          return result.findBy("slug", params.web_page_template_slug);
        });
      },
      afterModel: function(webPageTemplate, transition) {
        if (webPageTemplate.get("isWebHomeTemplate") != null) {
          return this.transitionTo("webHomeTemplate", webPageTemplate);
        }
      },
      setupController: function(controller, model) {
        controller.set("model", model);
        this.controllerFor("website").set("model", model.get("website"));
        this.controllerFor("mainWidgets").set("model", model.get("mainWidgets"));
        this.controllerFor("websiteTemplate").set("model", model.get("websiteTemplate"));
        this.controllerFor("webLayout").set("model", model.get("website.websiteTemplate.webLayout"));
        this.controllerFor("webTheme").set("model", model.get("website.websiteTemplate.webTheme"));
        this.controllerFor("headWidgets").set("model", model.get("website.websiteTemplate.headWidgets"));
        this.controllerFor("logoWidgets").set("model", model.get("website.websiteTemplate.logoWidgets"));
        this.controllerFor("btnWidgets").set("model", model.get("website.websiteTemplate.btnWidgets"));
        this.controllerFor("navWidgets").set("model", model.get("website.websiteTemplate.navWidgets"));
        this.controllerFor("asideBeforeMainWidgets").set("model", model.get("website.websiteTemplate.asideBeforeMainWidgets"));
        this.controllerFor("asideAfterMainWidgets").set("model", model.get("website.websiteTemplate.asideAfterMainWidgets"));
        this.controllerFor("footerWidgets").set("model", model.get("website.websiteTemplate.footerWidgets"));
        this.controllerFor("gardenWebLayouts").set("model", this.store.find('gardenWebLayout'));
        this.controllerFor("gardenWebThemes").set("model", this.store.find('gardenWebTheme'));
        return this.controllerFor("gardenWidgets").set("model", this.store.find('gardenWidget'));
      },
      serialize: function(model, params) {
        return {
          website_slug: model.get("website.slug"),
          web_page_template_slug: model.get("slug")
        };
      },
      deactivate: function() {
        return $('.page-name').hide();
      }
    });

    __exports__["default"] = WebPageTemplateRoute;
  });
define("cms/routes/web-page-templates", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    var WebPageTemplatesRoute;

    WebPageTemplatesRoute = Ember.Route.extend({
      model: function() {
        return false;
      }
    });

    __exports__["default"] = WebPageTemplatesRoute;
  });
define("cms/routes/web-page-templates/new", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    var WebPageTemplatesNewRoute;

    WebPageTemplatesNewRoute = Ember.Route.extend({
      model: function() {
        return this.store.createRecord("WebPageTemplate", {
          enabled: true,
          website: this.modelFor("website")
        });
      },
      actions: {
        save: function(model) {
          model.save();
          return this.transitionTo('website.index');
        },
        cancel: function() {
          this.get('model').deleteRecord();
          return this.transitionToRoute('website.index');
        }
      }
    });

    __exports__["default"] = WebPageTemplatesNewRoute;
  });
define("cms/routes/website", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    var WebsiteRoute;

    WebsiteRoute = Ember.Route.extend({
      model: function(params) {
        return this.store.find("website", params.website_slug);
      },
      serialize: function(model) {
        return {
          website_slug: model.get("slug")
        };
      },
      setupController: function(controller, model) {
        controller.set("model", model);
        this.controllerFor("websiteTemplate").set("model", model.get("websiteTemplate"));
        this.controllerFor("websiteWebHomeTemplate").set("model", model.get("webHomeTemplate"));
        this.controllerFor("websiteWebPageTemplates").set("model", model.get("webPageTemplates"));
        return this.controllerFor("websiteWebPageTemplatesInTrash").set("model", model.get("webPageTemplates"));
      }
    });

    __exports__["default"] = WebsiteRoute;
  });
define("cms/routes/website/assets", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    var AssetsRoute;

    AssetsRoute = Ember.Route.extend({
      model: function() {
        return this.modelFor('website').get('assets');
      }
    });

    __exports__["default"] = AssetsRoute;
  });
define("cms/routes/website/releases", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    var ReleasesRoute;

    ReleasesRoute = Ember.Route.extend({
      model: function() {
        var slug;
        slug = this.modelFor("website").get("slug");
        return this.get('store').find('release', {
          website_slug: slug
        });
      },
      serialize: function(model) {
        return {
          website_slug: model.get("slug")
        };
      }
    });

    __exports__["default"] = ReleasesRoute;
  });
define("cms/templates/-header", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    __exports__["default"] = Ember.Handlebars.template(function anonymous(Handlebars,depth0,helpers,partials,data) {
    this.compilerInfo = [4,'>= 1.0.0'];
    helpers = this.merge(helpers, Ember.Handlebars.helpers); data = data || {};
      var buffer = '', stack1, self=this, helperMissing=helpers.helperMissing;

    function program1(depth0,data) {
      
      var buffer = '', stack1, helper, options;
      data.buffer.push("\n          <li>\n            &raquo;\n            ");
      stack1 = (helper = helpers['link-to'] || (depth0 && depth0['link-to']),options={hash:{},hashTypes:{},hashContexts:{},inverse:self.noop,fn:self.program(2, program2, data),contexts:[depth0,depth0],types:["STRING","ID"],data:data},helper ? helper.call(depth0, "website", "controllers.website", options) : helperMissing.call(depth0, "link-to", "website", "controllers.website", options));
      if(stack1 || stack1 === 0) { data.buffer.push(stack1); }
      data.buffer.push("\n          </li>\n        ");
      return buffer;
      }
    function program2(depth0,data) {
      
      var buffer = '', stack1;
      data.buffer.push("\n              ");
      stack1 = helpers._triageMustache.call(depth0, "controllers.website.model.name", {hash:{},hashTypes:{},hashContexts:{},contexts:[depth0],types:["ID"],data:data});
      if(stack1 || stack1 === 0) { data.buffer.push(stack1); }
      data.buffer.push("\n            ");
      return buffer;
      }

    function program4(depth0,data) {
      
      var buffer = '', stack1;
      data.buffer.push("\n          <a>");
      stack1 = helpers._triageMustache.call(depth0, "controllers.webPageTemplate.model.name", {hash:{},hashTypes:{},hashContexts:{},contexts:[depth0],types:["ID"],data:data});
      if(stack1 || stack1 === 0) { data.buffer.push(stack1); }
      data.buffer.push("</a>\n        ");
      return buffer;
      }

    function program6(depth0,data) {
      
      var buffer = '', stack1;
      data.buffer.push("\n          <a>");
      stack1 = helpers._triageMustache.call(depth0, "controllers.webHomeTemplate.model.name", {hash:{},hashTypes:{},hashContexts:{},contexts:[depth0],types:["ID"],data:data});
      if(stack1 || stack1 === 0) { data.buffer.push(stack1); }
      data.buffer.push("</a>\n        ");
      return buffer;
      }

      data.buffer.push("<div class=\"breadcrumb\">\n  <div class=\"l-container\">\n    <nav class=\"nav\" role=\"navigation\">\n      <ul>\n        <li><a href=\"/\">");
      stack1 = helpers._triageMustache.call(depth0, "controllers.client.model.name", {hash:{},hashTypes:{},hashContexts:{},contexts:[depth0],types:["ID"],data:data});
      if(stack1 || stack1 === 0) { data.buffer.push(stack1); }
      data.buffer.push("</a></li>\n\n        ");
      stack1 = helpers['if'].call(depth0, "controllers.website.model", {hash:{},hashTypes:{},hashContexts:{},inverse:self.noop,fn:self.program(1, program1, data),contexts:[depth0],types:["ID"],data:data});
      if(stack1 || stack1 === 0) { data.buffer.push(stack1); }
      data.buffer.push("\n\n        ");
      stack1 = helpers['if'].call(depth0, "controllers.webPageTemplate.model", {hash:{},hashTypes:{},hashContexts:{},inverse:self.noop,fn:self.program(4, program4, data),contexts:[depth0],types:["ID"],data:data});
      if(stack1 || stack1 === 0) { data.buffer.push(stack1); }
      data.buffer.push("\n\n        ");
      stack1 = helpers['if'].call(depth0, "controllers.webHomeTemplate.model", {hash:{},hashTypes:{},hashContexts:{},inverse:self.noop,fn:self.program(6, program6, data),contexts:[depth0],types:["ID"],data:data});
      if(stack1 || stack1 === 0) { data.buffer.push(stack1); }
      data.buffer.push("\n      </ul>\n    </nav>\n  </div>\n</div>\n");
      return buffer;
      
    });
  });
define("cms/templates/-widgets", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    __exports__["default"] = Ember.Handlebars.template(function anonymous(Handlebars,depth0,helpers,partials,data) {
    this.compilerInfo = [4,'>= 1.0.0'];
    helpers = this.merge(helpers, Ember.Handlebars.helpers); data = data || {};
      var buffer = '', stack1, escapeExpression=this.escapeExpression, self=this;

    function program1(depth0,data) {
      
      var buffer = '';
      data.buffer.push("\n  ");
      data.buffer.push(escapeExpression(helpers.view.call(depth0, "widget", {hash:{
        'contentBinding': ("this")
      },hashTypes:{'contentBinding': "STRING"},hashContexts:{'contentBinding': depth0},contexts:[depth0],types:["STRING"],data:data})));
      data.buffer.push("\n");
      return buffer;
      }

      data.buffer.push("<ul class=\"add-widgets\">\n");
      stack1 = helpers.each.call(depth0, "model", {hash:{},hashTypes:{},hashContexts:{},inverse:self.noop,fn:self.program(1, program1, data),contexts:[depth0],types:["ID"],data:data});
      if(stack1 || stack1 === 0) { data.buffer.push(stack1); }
      data.buffer.push("\n</ul>\n");
      return buffer;
      
    });
  });
define("cms/templates/application", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    __exports__["default"] = Ember.Handlebars.template(function anonymous(Handlebars,depth0,helpers,partials,data) {
    this.compilerInfo = [4,'>= 1.0.0'];
    helpers = this.merge(helpers, Ember.Handlebars.helpers); data = data || {};
      var buffer = '', stack1, helper, options, helperMissing=helpers.helperMissing, escapeExpression=this.escapeExpression, self=this;

    function program1(depth0,data) {
      
      var buffer = '', helper, options;
      data.buffer.push("\n  ");
      data.buffer.push(escapeExpression((helper = helpers['flash-message'] || (depth0 && depth0['flash-message']),options={hash:{
        'flash': ("flash")
      },hashTypes:{'flash': "ID"},hashContexts:{'flash': depth0},contexts:[],types:[],data:data},helper ? helper.call(depth0, options) : helperMissing.call(depth0, "flash-message", options))));
      data.buffer.push("\n");
      return buffer;
      }

      stack1 = helpers.each.call(depth0, "flash", "in", "flashes.content", {hash:{},hashTypes:{},hashContexts:{},inverse:self.noop,fn:self.program(1, program1, data),contexts:[depth0,depth0,depth0],types:["ID","ID","ID"],data:data});
      if(stack1 || stack1 === 0) { data.buffer.push(stack1); }
      data.buffer.push("\n\n");
      data.buffer.push(escapeExpression((helper = helpers.partial || (depth0 && depth0.partial),options={hash:{},hashTypes:{},hashContexts:{},contexts:[depth0],types:["STRING"],data:data},helper ? helper.call(depth0, "header", options) : helperMissing.call(depth0, "partial", "header", options))));
      data.buffer.push("\n\n<section class=\"page\">\n  ");
      stack1 = helpers._triageMustache.call(depth0, "outlet", {hash:{},hashTypes:{},hashContexts:{},contexts:[depth0],types:["ID"],data:data});
      if(stack1 || stack1 === 0) { data.buffer.push(stack1); }
      data.buffer.push("\n</section>\n");
      return buffer;
      
    });
  });
define("cms/templates/aside-after-main-widgets", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    __exports__["default"] = Ember.Handlebars.template(function anonymous(Handlebars,depth0,helpers,partials,data) {
    this.compilerInfo = [4,'>= 1.0.0'];
    helpers = this.merge(helpers, Ember.Handlebars.helpers); data = data || {};
      var buffer = '', escapeExpression=this.escapeExpression;


      data.buffer.push("<div class=\"widget-drop-zone aside-widgets aside-after-main-widgets\">\n  <h2>Aside after main</h2>\n  ");
      data.buffer.push(escapeExpression(helpers.view.call(depth0, "widgets-list", {hash:{
        'contentBinding': ("content")
      },hashTypes:{'contentBinding': "STRING"},hashContexts:{'contentBinding': depth0},contexts:[depth0],types:["STRING"],data:data})));
      data.buffer.push("\n  <div class=\"add-drop-zone\">\n    ");
      data.buffer.push(escapeExpression(helpers.view.call(depth0, "widgets-add", {hash:{
        'contentBinding': ("content")
      },hashTypes:{'contentBinding': "STRING"},hashContexts:{'contentBinding': depth0},contexts:[depth0],types:["STRING"],data:data})));
      data.buffer.push("\n  </div>\n  <div class=\"remove-drop-zone\">\n    ");
      data.buffer.push(escapeExpression(helpers.view.call(depth0, "widgets-remove", {hash:{
        'contentBinding': ("content")
      },hashTypes:{'contentBinding': "STRING"},hashContexts:{'contentBinding': depth0},contexts:[depth0],types:["STRING"],data:data})));
      data.buffer.push("\n  </div>\n</div>\n");
      return buffer;
      
    });
  });
define("cms/templates/aside-before-main-widgets", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    __exports__["default"] = Ember.Handlebars.template(function anonymous(Handlebars,depth0,helpers,partials,data) {
    this.compilerInfo = [4,'>= 1.0.0'];
    helpers = this.merge(helpers, Ember.Handlebars.helpers); data = data || {};
      var buffer = '', escapeExpression=this.escapeExpression;


      data.buffer.push("<div class=\"widget-drop-zone aside-widgets aside-before-main-widgets\">\n  <h2>Aside before main</h2>\n  ");
      data.buffer.push(escapeExpression(helpers.view.call(depth0, "widgets-list", {hash:{
        'contentBinding': ("content")
      },hashTypes:{'contentBinding': "STRING"},hashContexts:{'contentBinding': depth0},contexts:[depth0],types:["STRING"],data:data})));
      data.buffer.push("\n  <div class=\"add-drop-zone\">\n    ");
      data.buffer.push(escapeExpression(helpers.view.call(depth0, "widgets-add", {hash:{
        'contentBinding': ("content")
      },hashTypes:{'contentBinding': "STRING"},hashContexts:{'contentBinding': depth0},contexts:[depth0],types:["STRING"],data:data})));
      data.buffer.push("\n  </div>\n  <div class=\"remove-drop-zone\">\n    ");
      data.buffer.push(escapeExpression(helpers.view.call(depth0, "widgets-remove", {hash:{
        'contentBinding': ("content")
      },hashTypes:{'contentBinding': "STRING"},hashContexts:{'contentBinding': depth0},contexts:[depth0],types:["STRING"],data:data})));
      data.buffer.push("\n  </div>\n</div>\n");
      return buffer;
      
    });
  });
define("cms/templates/btn-widgets", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    __exports__["default"] = Ember.Handlebars.template(function anonymous(Handlebars,depth0,helpers,partials,data) {
    this.compilerInfo = [4,'>= 1.0.0'];
    helpers = this.merge(helpers, Ember.Handlebars.helpers); data = data || {};
      var buffer = '', helper, options, helperMissing=helpers.helperMissing, escapeExpression=this.escapeExpression;


      data.buffer.push(escapeExpression((helper = helpers.partial || (depth0 && depth0.partial),options={hash:{},hashTypes:{},hashContexts:{},contexts:[depth0],types:["STRING"],data:data},helper ? helper.call(depth0, "widgets", options) : helperMissing.call(depth0, "partial", "widgets", options))));
      data.buffer.push("\n");
      return buffer;
      
    });
  });
define("cms/templates/components/click-select", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    __exports__["default"] = Ember.Handlebars.template(function anonymous(Handlebars,depth0,helpers,partials,data) {
    this.compilerInfo = [4,'>= 1.0.0'];
    helpers = this.merge(helpers, Ember.Handlebars.helpers); data = data || {};
      var buffer = '', stack1;


      stack1 = helpers._triageMustache.call(depth0, "url", {hash:{},hashTypes:{},hashContexts:{},contexts:[depth0],types:["ID"],data:data});
      if(stack1 || stack1 === 0) { data.buffer.push(stack1); }
      data.buffer.push("\n");
      return buffer;
      
    });
  });
define("cms/templates/components/confirm-button", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    __exports__["default"] = Ember.Handlebars.template(function anonymous(Handlebars,depth0,helpers,partials,data) {
    this.compilerInfo = [4,'>= 1.0.0'];
    helpers = this.merge(helpers, Ember.Handlebars.helpers); data = data || {};
      var buffer = '', stack1, escapeExpression=this.escapeExpression;


      data.buffer.push("<button ");
      data.buffer.push(escapeExpression(helpers.action.call(depth0, "confirm", {hash:{},hashTypes:{},hashContexts:{},contexts:[depth0],types:["STRING"],data:data})));
      data.buffer.push(" class=\"btn btn--a\">");
      stack1 = helpers._triageMustache.call(depth0, "title", {hash:{},hashTypes:{},hashContexts:{},contexts:[depth0],types:["ID"],data:data});
      if(stack1 || stack1 === 0) { data.buffer.push(stack1); }
      data.buffer.push("</button>\n");
      return buffer;
      
    });
  });
define("cms/templates/components/confirmation-link", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    __exports__["default"] = Ember.Handlebars.template(function anonymous(Handlebars,depth0,helpers,partials,data) {
    this.compilerInfo = [4,'>= 1.0.0'];
    helpers = this.merge(helpers, Ember.Handlebars.helpers); data = data || {};
      var buffer = '', stack1, escapeExpression=this.escapeExpression;


      data.buffer.push("<a ");
      data.buffer.push(escapeExpression(helpers.action.call(depth0, "showConfirmation", {hash:{},hashTypes:{},hashContexts:{},contexts:[depth0],types:["STRING"],data:data})));
      data.buffer.push(" href=\"#\" ");
      data.buffer.push(escapeExpression(helpers['bind-attr'].call(depth0, {hash:{
        'class': ("classes")
      },hashTypes:{'class': "STRING"},hashContexts:{'class': depth0},contexts:[],types:[],data:data})));
      data.buffer.push("\">");
      stack1 = helpers._triageMustache.call(depth0, "title", {hash:{},hashTypes:{},hashContexts:{},contexts:[depth0],types:["ID"],data:data});
      if(stack1 || stack1 === 0) { data.buffer.push(stack1); }
      data.buffer.push("</a>\n\n");
      return buffer;
      
    });
  });
define("cms/templates/components/flash-message", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    __exports__["default"] = Ember.Handlebars.template(function anonymous(Handlebars,depth0,helpers,partials,data) {
    this.compilerInfo = [4,'>= 1.0.0'];
    helpers = this.merge(helpers, Ember.Handlebars.helpers); data = data || {};
      var buffer = '', stack1;


      stack1 = helpers._triageMustache.call(depth0, "flash.message", {hash:{},hashTypes:{},hashContexts:{},contexts:[depth0],types:["ID"],data:data});
      if(stack1 || stack1 === 0) { data.buffer.push(stack1); }
      data.buffer.push("\n");
      return buffer;
      
    });
  });
define("cms/templates/components/s3-upload", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    __exports__["default"] = Ember.Handlebars.template(function anonymous(Handlebars,depth0,helpers,partials,data) {
    this.compilerInfo = [4,'>= 1.0.0'];
    helpers = this.merge(helpers, Ember.Handlebars.helpers); data = data || {};
      var buffer = '';


      return buffer;
      
    });
  });
define("cms/templates/components/widget-modal", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    __exports__["default"] = Ember.Handlebars.template(function anonymous(Handlebars,depth0,helpers,partials,data) {
    this.compilerInfo = [4,'>= 1.0.0'];
    helpers = this.merge(helpers, Ember.Handlebars.helpers); data = data || {};
      var buffer = '', stack1;


      data.buffer.push("<div id=\"modal\" class=\"modal hide fade\" tabindex=\"-1\" role=\"dialog\" aria-labelledby=\"myModalLabel\" aria-hidden=\"true\" data-component=\"\">\n  <div class=\"modal-header\">\n    <button type=\"button\" class=\"close\" data-dismiss=\"modal\" aria-hidden=\"true\">×</button>\n    <h3 id=\"myModalLabel\">Edit ");
      stack1 = helpers._triageMustache.call(depth0, "widgetNameForTitle", {hash:{},hashTypes:{},hashContexts:{},contexts:[depth0],types:["ID"],data:data});
      if(stack1 || stack1 === 0) { data.buffer.push(stack1); }
      data.buffer.push("</h3>\n  </div>\n  <div class=\"modal-body\">\n  </div>\n</div>");
      return buffer;
      
    });
  });
define("cms/templates/docs", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    __exports__["default"] = Ember.Handlebars.template(function anonymous(Handlebars,depth0,helpers,partials,data) {
    this.compilerInfo = [4,'>= 1.0.0'];
    helpers = this.merge(helpers, Ember.Handlebars.helpers); data = data || {};
      var buffer = '';


      data.buffer.push("<div class=\"docs l-container\">\n  <div class=\"page-title\">\n    <h2>Docs</h2>\n  </div>\n\n  <h3>Liquid Variables for page titles</h3>\n\n  <p>When editing a location page title, you have access to the variables below to construct your string. Simply wrap each variable in double curly brackets, {{ and }}. An example title string that can be instructed is:</p>\n\n  <p><em>Photos of {{ location_name }} in {{ location_city }}, {{ location_state }}</em></p>\n\n  <p>This would produce a title of \"Photos of World's Best Apartments in Hollywood, CA\"</p>\n\n  <table class=\"table--small\">\n    <thead>\n      <th>Available Variables</th>\n      <th>Sample Output</th>\n    </thead>\n    <tbody>\n      <tr>\n        <td>web_template_name</td>\n        <td>Photo Gallery</td>\n      </tr>\n      <tr>\n        <td>location_name</td>\n        <td>World's Best Apartments</td>\n      </tr>\n      <tr>\n        <td>location_city</td>\n        <td>Los Angeles</td>\n      </tr>\n      <tr>\n        <td>location_neighborhood</td>\n        <td>Santa Monica</td>\n      </tr>\n      <tr>\n        <td>location_state</td>\n        <td>CA</td>\n      </tr>\n      <tr>\n        <td>location_floor_plans</td>\n        <td>2 Bedroom, 2 Bath</td>\n      </tr>\n      <tr>\n        <td>location_primary_amenity</td>\n        <td>Hot Tub</td>\n      </tr>\n      <tr>\n        <td>location_qualifier</td>\n        <td>Luxury</td>\n      </tr>\n      <tr>\n        <td>location_primary_landmark</td>\n        <td>Seattle Grace Hospital</td>\n      </tr>\n    </tbody>\n  </table>\n\n</div>\n");
      return buffer;
      
    });
  });
define("cms/templates/footer-widgets", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    __exports__["default"] = Ember.Handlebars.template(function anonymous(Handlebars,depth0,helpers,partials,data) {
    this.compilerInfo = [4,'>= 1.0.0'];
    helpers = this.merge(helpers, Ember.Handlebars.helpers); data = data || {};
      var buffer = '', helper, options, helperMissing=helpers.helperMissing, escapeExpression=this.escapeExpression;


      data.buffer.push("<div class=\"widget-drop-zone\">\n  <h2>Footer</h2>\n  ");
      data.buffer.push(escapeExpression((helper = helpers.partial || (depth0 && depth0.partial),options={hash:{},hashTypes:{},hashContexts:{},contexts:[depth0],types:["STRING"],data:data},helper ? helper.call(depth0, "widgets", options) : helperMissing.call(depth0, "partial", "widgets", options))));
      data.buffer.push("\n</div>");
      return buffer;
      
    });
  });
define("cms/templates/garden-web-layouts", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    __exports__["default"] = Ember.Handlebars.template(function anonymous(Handlebars,depth0,helpers,partials,data) {
    this.compilerInfo = [4,'>= 1.0.0'];
    helpers = this.merge(helpers, Ember.Handlebars.helpers); data = data || {};
      var buffer = '', stack1, escapeExpression=this.escapeExpression, self=this;

    function program1(depth0,data) {
      
      
      data.buffer.push("\n      <span class=\"toggle-panel-text btn--toggle-hide\">Hide Layouts</span>\n      <span class=\"toggle-panel-text hide btn--toggle-show\">Show Layouts</span>\n    ");
      }

    function program3(depth0,data) {
      
      
      data.buffer.push("\n        <div class=\"loading\">Loading...</div>\n      ");
      }

    function program5(depth0,data) {
      
      var buffer = '', stack1;
      data.buffer.push("\n        <div class=\"thumbs clearfix\">\n        ");
      stack1 = helpers.each.call(depth0, "model", {hash:{},hashTypes:{},hashContexts:{},inverse:self.noop,fn:self.program(6, program6, data),contexts:[depth0],types:["ID"],data:data});
      if(stack1 || stack1 === 0) { data.buffer.push(stack1); }
      data.buffer.push("\n        </div>\n      ");
      return buffer;
      }
    function program6(depth0,data) {
      
      var buffer = '', stack1;
      data.buffer.push("\n          <div class=\"thumb\">\n            <a href=\"#\" ");
      data.buffer.push(escapeExpression(helpers.action.call(depth0, "update", "", {hash:{},hashTypes:{},hashContexts:{},contexts:[depth0,depth0],types:["STRING","ID"],data:data})));
      data.buffer.push(">\n              ");
      stack1 = helpers.view.call(depth0, "garden-web-layout", {hash:{
        'contentBinding': ("this")
      },hashTypes:{'contentBinding': "STRING"},hashContexts:{'contentBinding': depth0},inverse:self.noop,fn:self.program(7, program7, data),contexts:[depth0],types:["STRING"],data:data});
      if(stack1 || stack1 === 0) { data.buffer.push(stack1); }
      data.buffer.push("\n            </a>\n          </div>\n        ");
      return buffer;
      }
    function program7(depth0,data) {
      
      var buffer = '', stack1;
      data.buffer.push("\n                <img alt=\"Thumbnail\" ");
      data.buffer.push(escapeExpression(helpers['bind-attr'].call(depth0, {hash:{
        'src': ("thumbnail"),
        'class': ("view.isSelected")
      },hashTypes:{'src': "STRING",'class': "STRING"},hashContexts:{'src': depth0,'class': depth0},contexts:[],types:[],data:data})));
      data.buffer.push(">\n                ");
      stack1 = helpers._triageMustache.call(depth0, "name", {hash:{},hashTypes:{},hashContexts:{},contexts:[depth0],types:["ID"],data:data});
      if(stack1 || stack1 === 0) { data.buffer.push(stack1); }
      data.buffer.push("\n              ");
      return buffer;
      }

      data.buffer.push("<div class=\"layout-picker thumbnail-field\">\n  <div class=\"l-container\">\n\n    ");
      stack1 = helpers.view.call(depth0, "toggle-panel", {hash:{
        'contentBinding': ("this")
      },hashTypes:{'contentBinding': "STRING"},hashContexts:{'contentBinding': depth0},inverse:self.noop,fn:self.program(1, program1, data),contexts:[depth0],types:["STRING"],data:data});
      if(stack1 || stack1 === 0) { data.buffer.push(stack1); }
      data.buffer.push("\n\n    <div id=\"layouts\" class=\"toggle-content page-section\">\n      <div class=\"page-title\"><h2>Select a Layout</h2></div>\n      ");
      stack1 = helpers['if'].call(depth0, "model.isUpdating", {hash:{},hashTypes:{},hashContexts:{},inverse:self.program(5, program5, data),fn:self.program(3, program3, data),contexts:[depth0],types:["ID"],data:data});
      if(stack1 || stack1 === 0) { data.buffer.push(stack1); }
      data.buffer.push("\n    </div>\n  </div>\n</div>\n");
      return buffer;
      
    });
  });
define("cms/templates/garden-web-themes", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    __exports__["default"] = Ember.Handlebars.template(function anonymous(Handlebars,depth0,helpers,partials,data) {
    this.compilerInfo = [4,'>= 1.0.0'];
    helpers = this.merge(helpers, Ember.Handlebars.helpers); data = data || {};
      var buffer = '', stack1, helper, options, escapeExpression=this.escapeExpression, self=this, helperMissing=helpers.helperMissing;

    function program1(depth0,data) {
      
      
      data.buffer.push("\n      <span class=\"toggle-panel-text btn--toggle-hide\">Hide Themes</span>\n      <span class=\"toggle-panel-text hide btn--toggle-show\">Show Themes</span>\n    ");
      }

    function program3(depth0,data) {
      
      
      data.buffer.push("\n        <div class=\"loading\">Loading...</div>\n      ");
      }

    function program5(depth0,data) {
      
      var buffer = '', stack1;
      data.buffer.push("\n        ");
      stack1 = helpers.view.call(depth0, "thumnail-scroller", {hash:{},hashTypes:{},hashContexts:{},inverse:self.noop,fn:self.program(6, program6, data),contexts:[depth0],types:["STRING"],data:data});
      if(stack1 || stack1 === 0) { data.buffer.push(stack1); }
      data.buffer.push("\n      ");
      return buffer;
      }
    function program6(depth0,data) {
      
      var buffer = '', stack1;
      data.buffer.push("\n          <div class=\"jTscrollerContainer\">\n            <div class=\"jTscroller thumbs clearfix\" style=\"width:100%\">\n              ");
      stack1 = helpers.each.call(depth0, "model", {hash:{},hashTypes:{},hashContexts:{},inverse:self.noop,fn:self.program(7, program7, data),contexts:[depth0],types:["ID"],data:data});
      if(stack1 || stack1 === 0) { data.buffer.push(stack1); }
      data.buffer.push("\n            </div>\n          </div>\n          <a href=\"#\" class=\"jTscrollerPrevButton\"></a>\n          <a href=\"#\" class=\"jTscrollerNextButton\"></a>\n        ");
      return buffer;
      }
    function program7(depth0,data) {
      
      var buffer = '', stack1;
      data.buffer.push("\n                <div class=\"thumb\">\n                  <a href=\"#\" ");
      data.buffer.push(escapeExpression(helpers.action.call(depth0, "update", "", {hash:{},hashTypes:{},hashContexts:{},contexts:[depth0,depth0],types:["STRING","ID"],data:data})));
      data.buffer.push(">\n                    ");
      stack1 = helpers.view.call(depth0, "garden-web-theme", {hash:{
        'contentBinding': ("this")
      },hashTypes:{'contentBinding': "STRING"},hashContexts:{'contentBinding': depth0},inverse:self.noop,fn:self.program(8, program8, data),contexts:[depth0],types:["STRING"],data:data});
      if(stack1 || stack1 === 0) { data.buffer.push(stack1); }
      data.buffer.push("\n                  </a>\n                </div>\n              ");
      return buffer;
      }
    function program8(depth0,data) {
      
      var buffer = '', stack1;
      data.buffer.push("\n                    <img alt=\"Thumbnail\" ");
      data.buffer.push(escapeExpression(helpers['bind-attr'].call(depth0, {hash:{
        'src': ("thumbnail")
      },hashTypes:{'src': "STRING"},hashContexts:{'src': depth0},contexts:[],types:[],data:data})));
      data.buffer.push(" ");
      data.buffer.push(escapeExpression(helpers['bind-attr'].call(depth0, {hash:{
        'class': ("view.isSelected")
      },hashTypes:{'class': "STRING"},hashContexts:{'class': depth0},contexts:[],types:[],data:data})));
      data.buffer.push(">\n                    ");
      stack1 = helpers._triageMustache.call(depth0, "name", {hash:{},hashTypes:{},hashContexts:{},contexts:[depth0],types:["ID"],data:data});
      if(stack1 || stack1 === 0) { data.buffer.push(stack1); }
      data.buffer.push("\n                    ");
      return buffer;
      }

      data.buffer.push("<div class=\"theme-picker thumbnail-field clearfix\">\n  <div class=\"l-container\">\n\n    ");
      stack1 = helpers.view.call(depth0, "toggle-panel", {hash:{
        'contentBinding': ("this")
      },hashTypes:{'contentBinding': "STRING"},hashContexts:{'contentBinding': depth0},inverse:self.noop,fn:self.program(1, program1, data),contexts:[depth0],types:["STRING"],data:data});
      if(stack1 || stack1 === 0) { data.buffer.push(stack1); }
      data.buffer.push("\n\n    <div class=\"toggle-content page-section\">\n      <div class=\"page-title\"><h2>Select a Theme</h2></div>\n      ");
      stack1 = helpers['if'].call(depth0, "model.isUpdating", {hash:{},hashTypes:{},hashContexts:{},inverse:self.program(5, program5, data),fn:self.program(3, program3, data),contexts:[depth0],types:["ID"],data:data});
      if(stack1 || stack1 === 0) { data.buffer.push(stack1); }
      data.buffer.push("\n      ");
      data.buffer.push(escapeExpression((helper = helpers.render || (depth0 && depth0.render),options={hash:{},hashTypes:{},hashContexts:{},contexts:[depth0],types:["STRING"],data:data},helper ? helper.call(depth0, "webTheme", options) : helperMissing.call(depth0, "render", "webTheme", options))));
      data.buffer.push("\n    </div>\n  </div>\n</div>\n");
      return buffer;
      
    });
  });
define("cms/templates/garden-widgets", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    __exports__["default"] = Ember.Handlebars.template(function anonymous(Handlebars,depth0,helpers,partials,data) {
    this.compilerInfo = [4,'>= 1.0.0'];
    helpers = this.merge(helpers, Ember.Handlebars.helpers); data = data || {};
      var buffer = '', stack1, escapeExpression=this.escapeExpression, self=this;

    function program1(depth0,data) {
      
      
      data.buffer.push("\n      <span class=\"toggle-panel-text btn--toggle-hide\">Hide Widgets</span>\n      <span class=\"toggle-panel-text hide btn--toggle-show\">Show Widgets</span>\n    ");
      }

    function program3(depth0,data) {
      
      
      data.buffer.push("\n        <span class=\"toggle-widget-text\">Grid View</span>\n        <span class=\"toggle-widget-text hide\">List View</span>\n      ");
      }

    function program5(depth0,data) {
      
      
      data.buffer.push("\n        <div class=\"loading\">Loading...</div>\n      ");
      }

    function program7(depth0,data) {
      
      var buffer = '', stack1;
      data.buffer.push("\n        <ul class=\"widgets--list-view widget-view\">\n          ");
      stack1 = helpers.each.call(depth0, "", {hash:{},hashTypes:{},hashContexts:{},inverse:self.noop,fn:self.program(8, program8, data),contexts:[depth0],types:["ID"],data:data});
      if(stack1 || stack1 === 0) { data.buffer.push(stack1); }
      data.buffer.push("\n        </ul>\n\n        <div class=\"widget-view visuallyhidden\">\n          ");
      stack1 = helpers.view.call(depth0, "thumnail-scroller", {hash:{},hashTypes:{},hashContexts:{},inverse:self.noop,fn:self.program(10, program10, data),contexts:[depth0],types:["STRING"],data:data});
      if(stack1 || stack1 === 0) { data.buffer.push(stack1); }
      data.buffer.push("\n        </div>\n      ");
      return buffer;
      }
    function program8(depth0,data) {
      
      var buffer = '';
      data.buffer.push("\n            ");
      data.buffer.push(escapeExpression(helpers.view.call(depth0, "garden-widget", {hash:{
        'contentBinding': ("this")
      },hashTypes:{'contentBinding': "STRING"},hashContexts:{'contentBinding': depth0},contexts:[depth0],types:["STRING"],data:data})));
      data.buffer.push("\n          ");
      return buffer;
      }

    function program10(depth0,data) {
      
      var buffer = '', stack1;
      data.buffer.push("\n            <div class=\"jTscrollerContainer\">\n              <ul id=\"choose-widgets\" class=\"jTscroller clearfix\">\n              ");
      stack1 = helpers.each.call(depth0, "", {hash:{},hashTypes:{},hashContexts:{},inverse:self.noop,fn:self.program(11, program11, data),contexts:[depth0],types:["ID"],data:data});
      if(stack1 || stack1 === 0) { data.buffer.push(stack1); }
      data.buffer.push("\n              </ul>\n            </div>\n            <a href=\"#\" class=\"jTscrollerPrevButton\"></a>\n            <a href=\"#\" class=\"jTscrollerNextButton\"></a>\n          ");
      return buffer;
      }
    function program11(depth0,data) {
      
      var buffer = '';
      data.buffer.push("\n                ");
      data.buffer.push(escapeExpression(helpers.view.call(depth0, "garden-widget", {hash:{
        'contentBinding': ("this")
      },hashTypes:{'contentBinding': "STRING"},hashContexts:{'contentBinding': depth0},contexts:[depth0],types:["STRING"],data:data})));
      data.buffer.push("\n              ");
      return buffer;
      }

      data.buffer.push("<div class=\"widget-list\">\n  <div class=\"l-container\">\n    ");
      stack1 = helpers.view.call(depth0, "toggle-panel", {hash:{
        'contentBinding': ("this")
      },hashTypes:{'contentBinding': "STRING"},hashContexts:{'contentBinding': depth0},inverse:self.noop,fn:self.program(1, program1, data),contexts:[depth0],types:["STRING"],data:data});
      if(stack1 || stack1 === 0) { data.buffer.push(stack1); }
      data.buffer.push("\n\n    <div class=\"toggle-content page-section\">\n      ");
      stack1 = helpers.view.call(depth0, "garden-widgets-toggle", {hash:{
        'contentBinding': ("this")
      },hashTypes:{'contentBinding': "STRING"},hashContexts:{'contentBinding': depth0},inverse:self.noop,fn:self.program(3, program3, data),contexts:[depth0],types:["STRING"],data:data});
      if(stack1 || stack1 === 0) { data.buffer.push(stack1); }
      data.buffer.push("\n      <div class=\"page-title\"><h2>Select Widgets</h2></div>\n      <span class=\"instructions\">Drag widgets onto drop areas below</span>\n      ");
      stack1 = helpers['if'].call(depth0, "model.isUpdating", {hash:{},hashTypes:{},hashContexts:{},inverse:self.program(7, program7, data),fn:self.program(5, program5, data),contexts:[depth0],types:["ID"],data:data});
      if(stack1 || stack1 === 0) { data.buffer.push(stack1); }
      data.buffer.push("\n    </div>\n  </div>\n</div>\n");
      return buffer;
      
    });
  });
define("cms/templates/head-widgets", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    __exports__["default"] = Ember.Handlebars.template(function anonymous(Handlebars,depth0,helpers,partials,data) {
    this.compilerInfo = [4,'>= 1.0.0'];
    helpers = this.merge(helpers, Ember.Handlebars.helpers); data = data || {};
      var buffer = '', helper, options, helperMissing=helpers.helperMissing, escapeExpression=this.escapeExpression;


      data.buffer.push(escapeExpression((helper = helpers.partial || (depth0 && depth0.partial),options={hash:{},hashTypes:{},hashContexts:{},contexts:[depth0],types:["STRING"],data:data},helper ? helper.call(depth0, "widgets", options) : helperMissing.call(depth0, "partial", "widgets", options))));
      data.buffer.push("\n");
      return buffer;
      
    });
  });
define("cms/templates/header-widgets", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    __exports__["default"] = Ember.Handlebars.template(function anonymous(Handlebars,depth0,helpers,partials,data) {
    this.compilerInfo = [4,'>= 1.0.0'];
    helpers = this.merge(helpers, Ember.Handlebars.helpers); data = data || {};
      var buffer = '', helper, options, helperMissing=helpers.helperMissing, escapeExpression=this.escapeExpression;


      data.buffer.push("<div class=\"widget-drop-zone\">\n  <h2>Head</h2>\n  ");
      data.buffer.push(escapeExpression((helper = helpers.render || (depth0 && depth0.render),options={hash:{},hashTypes:{},hashContexts:{},contexts:[depth0],types:["STRING"],data:data},helper ? helper.call(depth0, "headWidgets", options) : helperMissing.call(depth0, "render", "headWidgets", options))));
      data.buffer.push("\n  <br/>\n  <h2>Header</h2>\n  ");
      data.buffer.push(escapeExpression((helper = helpers.render || (depth0 && depth0.render),options={hash:{},hashTypes:{},hashContexts:{},contexts:[depth0],types:["STRING"],data:data},helper ? helper.call(depth0, "logoWidgets", options) : helperMissing.call(depth0, "render", "logoWidgets", options))));
      data.buffer.push("\n  ");
      data.buffer.push(escapeExpression((helper = helpers.render || (depth0 && depth0.render),options={hash:{},hashTypes:{},hashContexts:{},contexts:[depth0],types:["STRING"],data:data},helper ? helper.call(depth0, "btnWidgets", options) : helperMissing.call(depth0, "render", "btnWidgets", options))));
      data.buffer.push("\n  ");
      data.buffer.push(escapeExpression((helper = helpers.render || (depth0 && depth0.render),options={hash:{},hashTypes:{},hashContexts:{},contexts:[depth0],types:["STRING"],data:data},helper ? helper.call(depth0, "navWidgets", options) : helperMissing.call(depth0, "render", "navWidgets", options))));
      data.buffer.push("\n</div>\n");
      return buffer;
      
    });
  });
define("cms/templates/loading", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    __exports__["default"] = Ember.Handlebars.template(function anonymous(Handlebars,depth0,helpers,partials,data) {
    this.compilerInfo = [4,'>= 1.0.0'];
    helpers = this.merge(helpers, Ember.Handlebars.helpers); data = data || {};
      


      data.buffer.push("<div class=\"loader\">Loading...</div>\n");
      
    });
  });
define("cms/templates/locations", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    __exports__["default"] = Ember.Handlebars.template(function anonymous(Handlebars,depth0,helpers,partials,data) {
    this.compilerInfo = [4,'>= 1.0.0'];
    helpers = this.merge(helpers, Ember.Handlebars.helpers); data = data || {};
      var buffer = '', stack1, helper, options, helperMissing=helpers.helperMissing, escapeExpression=this.escapeExpression, self=this;

    function program1(depth0,data) {
      
      
      data.buffer.push("Saves");
      }

    function program3(depth0,data) {
      
      var buffer = '', helper, options;
      data.buffer.push("\n         ");
      data.buffer.push(escapeExpression((helper = helpers['confirmation-link'] || (depth0 && depth0['confirmation-link']),options={hash:{
        'title': ("Deploy All"),
        'action': ("deploy_all"),
        'param': (""),
        'message': ("You are about to deploy. Are you sure?"),
        'classes': ("btn")
      },hashTypes:{'title': "STRING",'action': "STRING",'param': "ID",'message': "STRING",'classes': "STRING"},hashContexts:{'title': depth0,'action': depth0,'param': depth0,'message': depth0,'classes': depth0},contexts:[],types:[],data:data},helper ? helper.call(depth0, options) : helperMissing.call(depth0, "confirmation-link", options))));
      data.buffer.push("\n      ");
      return buffer;
      }

    function program5(depth0,data) {
      
      
      data.buffer.push("\n      <div class=\"loading\">Loading...</div>\n    ");
      }

    function program7(depth0,data) {
      
      var buffer = '', stack1;
      data.buffer.push("\n      <ul class=\"faux-table-body\">\n        ");
      stack1 = helpers.each.call(depth0, "model", {hash:{},hashTypes:{},hashContexts:{},inverse:self.noop,fn:self.program(8, program8, data),contexts:[depth0],types:["ID"],data:data});
      if(stack1 || stack1 === 0) { data.buffer.push(stack1); }
      data.buffer.push("\n      </ul>\n    ");
      return buffer;
      }
    function program8(depth0,data) {
      
      var buffer = '', stack1, helper, options;
      data.buffer.push("\n        <li ");
      data.buffer.push(escapeExpression(helpers['bind-attr'].call(depth0, {hash:{
        'class': (":faux-table-row :location corporate status_class")
      },hashTypes:{'class': "STRING"},hashContexts:{'class': depth0},contexts:[],types:[],data:data})));
      data.buffer.push(">\n          <div class=\"faux-table-cell\">\n            ");
      stack1 = helpers['if'].call(depth0, "corporate", {hash:{},hashTypes:{},hashContexts:{},inverse:self.noop,fn:self.program(9, program9, data),contexts:[depth0],types:["ID"],data:data});
      if(stack1 || stack1 === 0) { data.buffer.push(stack1); }
      data.buffer.push("\n            ");
      stack1 = helpers._triageMustache.call(depth0, "name", {hash:{},hashTypes:{},hashContexts:{},contexts:[depth0],types:["ID"],data:data});
      if(stack1 || stack1 === 0) { data.buffer.push(stack1); }
      data.buffer.push("\n          </div>\n          <div class=\"faux-table-cell status\">\n            <div class=\"status-label\">\n              ");
      stack1 = helpers._triageMustache.call(depth0, "status", {hash:{},hashTypes:{},hashContexts:{},contexts:[depth0],types:["ID"],data:data});
      if(stack1 || stack1 === 0) { data.buffer.push(stack1); }
      data.buffer.push("\n            </div>\n          </div>\n          <div ");
      data.buffer.push(escapeExpression(helpers['bind-attr'].call(depth0, {hash:{
        'class': (":faux-table-cell single_domain")
      },hashTypes:{'class': "STRING"},hashContexts:{'class': depth0},contexts:[],types:[],data:data})));
      data.buffer.push(">\n            ");
      stack1 = (helper = helpers['link-to'] || (depth0 && depth0['link-to']),options={hash:{
        'class': ("btn btn--a")
      },hashTypes:{'class': "STRING"},hashContexts:{'class': depth0},inverse:self.noop,fn:self.program(11, program11, data),contexts:[depth0,depth0],types:["STRING","ID"],data:data},helper ? helper.call(depth0, "website", "websiteSlug", options) : helperMissing.call(depth0, "link-to", "website", "websiteSlug", options));
      if(stack1 || stack1 === 0) { data.buffer.push(stack1); }
      data.buffer.push("\n            <a ");
      data.buffer.push(escapeExpression(helpers['bind-attr'].call(depth0, {hash:{
        'href': ("this.websiteHerokuUrl")
      },hashTypes:{'href': "STRING"},hashContexts:{'href': depth0},contexts:[],types:[],data:data})));
      data.buffer.push(" class=\"btn btn--a\">View</a>\n            ");
      data.buffer.push(escapeExpression((helper = helpers['confirmation-link'] || (depth0 && depth0['confirmation-link']),options={hash:{
        'title': ("Deploy"),
        'action': ("deploy"),
        'param': ("websiteId"),
        'message': ("You are about to deploy. Are you sure?"),
        'classes': ("btn btn--a deploy")
      },hashTypes:{'title': "STRING",'action': "STRING",'param': "ID",'message': "STRING",'classes': "STRING"},hashContexts:{'title': depth0,'action': depth0,'param': depth0,'message': depth0,'classes': depth0},contexts:[],types:[],data:data},helper ? helper.call(depth0, options) : helperMissing.call(depth0, "confirmation-link", options))));
      data.buffer.push("\n          </div>\n        </li>\n        ");
      return buffer;
      }
    function program9(depth0,data) {
      
      
      data.buffer.push("\n            <strong>Corporate:</strong>\n            ");
      }

    function program11(depth0,data) {
      
      
      data.buffer.push("Edit");
      }

      data.buffer.push("<div class=\"l-container\">\n  <div class=\"page-title\">\n    <h2>Locations</h2>\n    <div class=\"buttons l-pullRight\">\n      ");
      stack1 = (helper = helpers['link-to'] || (depth0 && depth0['link-to']),options={hash:{
        'class': ("btn")
      },hashTypes:{'class': "STRING"},hashContexts:{'class': depth0},inverse:self.noop,fn:self.program(1, program1, data),contexts:[depth0],types:["STRING"],data:data},helper ? helper.call(depth0, "saves", options) : helperMissing.call(depth0, "link-to", "saves", options));
      if(stack1 || stack1 === 0) { data.buffer.push(stack1); }
      data.buffer.push("\n      <a ");
      data.buffer.push(escapeExpression(helpers.action.call(depth0, "updateGardenWidgets", {hash:{},hashTypes:{},hashContexts:{},contexts:[depth0],types:["STRING"],data:data})));
      data.buffer.push(" href=\"#\" class=\"btn\">Update Widgets</a>\n      <a ");
      data.buffer.push(escapeExpression(helpers.action.call(depth0, "updateGardenWebThemes", {hash:{},hashTypes:{},hashContexts:{},contexts:[depth0],types:["STRING"],data:data})));
      data.buffer.push(" href=\"#\" class=\"btn\">Update Themes</a>\n      <a ");
      data.buffer.push(escapeExpression(helpers.action.call(depth0, "updateGardenWebLayouts", {hash:{},hashTypes:{},hashContexts:{},contexts:[depth0],types:["STRING"],data:data})));
      data.buffer.push(" href=\"#\" class=\"btn\">Update Layouts</a>\n\n      ");
      stack1 = helpers['if'].call(depth0, "controllers.client.single_domain", {hash:{},hashTypes:{},hashContexts:{},inverse:self.noop,fn:self.program(3, program3, data),contexts:[depth0],types:["ID"],data:data});
      if(stack1 || stack1 === 0) { data.buffer.push(stack1); }
      data.buffer.push("\n    </div>\n  </div>\n\n  <div class=\"faux-table faux-table--striped\">\n    <div class=\"faux-table-head\">\n      <span class=\"faux-table-cell\">Name</span>\n      <span class=\"faux-table-cell\">Status</span>\n      <span class=\"faux-table-cell\">Actions</span>\n    </div>\n\n    ");
      stack1 = helpers['if'].call(depth0, "model.isUpdating", {hash:{},hashTypes:{},hashContexts:{},inverse:self.program(7, program7, data),fn:self.program(5, program5, data),contexts:[depth0],types:["ID"],data:data});
      if(stack1 || stack1 === 0) { data.buffer.push(stack1); }
      data.buffer.push("\n  </div>\n</div>\n");
      return buffer;
      
    });
  });
define("cms/templates/logo-widgets", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    __exports__["default"] = Ember.Handlebars.template(function anonymous(Handlebars,depth0,helpers,partials,data) {
    this.compilerInfo = [4,'>= 1.0.0'];
    helpers = this.merge(helpers, Ember.Handlebars.helpers); data = data || {};
      var buffer = '', helper, options, helperMissing=helpers.helperMissing, escapeExpression=this.escapeExpression;


      data.buffer.push(escapeExpression((helper = helpers.partial || (depth0 && depth0.partial),options={hash:{},hashTypes:{},hashContexts:{},contexts:[depth0],types:["STRING"],data:data},helper ? helper.call(depth0, "widgets", options) : helperMissing.call(depth0, "partial", "widgets", options))));
      data.buffer.push("\n");
      return buffer;
      
    });
  });
define("cms/templates/main-widgets", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    __exports__["default"] = Ember.Handlebars.template(function anonymous(Handlebars,depth0,helpers,partials,data) {
    this.compilerInfo = [4,'>= 1.0.0'];
    helpers = this.merge(helpers, Ember.Handlebars.helpers); data = data || {};
      var buffer = '', escapeExpression=this.escapeExpression;


      data.buffer.push("<div class=\"widget-drop-zone main-widgets\">\n  <h2>Main</h2>\n  ");
      data.buffer.push(escapeExpression(helpers.view.call(depth0, "widgets-list", {hash:{
        'contentBinding': ("content")
      },hashTypes:{'contentBinding': "STRING"},hashContexts:{'contentBinding': depth0},contexts:[depth0],types:["STRING"],data:data})));
      data.buffer.push("\n  <div class=\"add-drop-zone\">\n    ");
      data.buffer.push(escapeExpression(helpers.view.call(depth0, "widgets-add", {hash:{
        'contentBinding': ("content")
      },hashTypes:{'contentBinding': "STRING"},hashContexts:{'contentBinding': depth0},contexts:[depth0],types:["STRING"],data:data})));
      data.buffer.push("\n  </div>\n  <div class=\"remove-drop-zone\">\n    ");
      data.buffer.push(escapeExpression(helpers.view.call(depth0, "widgets-remove", {hash:{
        'contentBinding': ("content")
      },hashTypes:{'contentBinding': "STRING"},hashContexts:{'contentBinding': depth0},contexts:[depth0],types:["STRING"],data:data})));
      data.buffer.push("\n  </div>\n</div>\n");
      return buffer;
      
    });
  });
define("cms/templates/nav-widgets", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    __exports__["default"] = Ember.Handlebars.template(function anonymous(Handlebars,depth0,helpers,partials,data) {
    this.compilerInfo = [4,'>= 1.0.0'];
    helpers = this.merge(helpers, Ember.Handlebars.helpers); data = data || {};
      var buffer = '', helper, options, helperMissing=helpers.helperMissing, escapeExpression=this.escapeExpression;


      data.buffer.push(escapeExpression((helper = helpers.partial || (depth0 && depth0.partial),options={hash:{},hashTypes:{},hashContexts:{},contexts:[depth0],types:["STRING"],data:data},helper ? helper.call(depth0, "widgets", options) : helperMissing.call(depth0, "partial", "widgets", options))));
      data.buffer.push("\n");
      return buffer;
      
    });
  });
define("cms/templates/phone-widgets", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    __exports__["default"] = Ember.Handlebars.template(function anonymous(Handlebars,depth0,helpers,partials,data) {
    this.compilerInfo = [4,'>= 1.0.0'];
    helpers = this.merge(helpers, Ember.Handlebars.helpers); data = data || {};
      var buffer = '', helper, options, helperMissing=helpers.helperMissing, escapeExpression=this.escapeExpression;


      data.buffer.push(escapeExpression((helper = helpers.partial || (depth0 && depth0.partial),options={hash:{},hashTypes:{},hashContexts:{},contexts:[depth0],types:["STRING"],data:data},helper ? helper.call(depth0, "widgets", options) : helperMissing.call(depth0, "partial", "widgets", options))));
      data.buffer.push("\n");
      return buffer;
      
    });
  });
define("cms/templates/redirect-manager-row", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    __exports__["default"] = Ember.Handlebars.template(function anonymous(Handlebars,depth0,helpers,partials,data) {
    this.compilerInfo = [4,'>= 1.0.0'];
    helpers = this.merge(helpers, Ember.Handlebars.helpers); data = data || {};
      var buffer = '', stack1, helper, options, helperMissing=helpers.helperMissing, escapeExpression=this.escapeExpression;


      data.buffer.push("<li class=\"faux-table-row location\">\n  <div class=\"faux-table-cell\">\n    ");
      stack1 = helpers._triageMustache.call(depth0, "name", {hash:{},hashTypes:{},hashContexts:{},contexts:[depth0],types:["ID"],data:data});
      if(stack1 || stack1 === 0) { data.buffer.push(stack1); }
      data.buffer.push("\n  </div>\n  <div class=\"faux-table-cell\">\n    ");
      data.buffer.push(escapeExpression((helper = helpers.textarea || (depth0 && depth0.textarea),options={hash:{
        'value': ("redirect_patterns"),
        'placeholder': ("Add URLs separated by space or line with no leading or trailing slashes here. Ex: \\n redirect redirect/this more/redirects/here"),
        'rows': ("3")
      },hashTypes:{'value': "ID",'placeholder': "STRING",'rows': "STRING"},hashContexts:{'value': depth0,'placeholder': depth0,'rows': depth0},contexts:[],types:[],data:data},helper ? helper.call(depth0, options) : helperMissing.call(depth0, "textarea", options))));
      data.buffer.push("\n  </div>\n</li>");
      return buffer;
      
    });
  });
define("cms/templates/redirect-manager", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    __exports__["default"] = Ember.Handlebars.template(function anonymous(Handlebars,depth0,helpers,partials,data) {
    this.compilerInfo = [4,'>= 1.0.0'];
    helpers = this.merge(helpers, Ember.Handlebars.helpers); data = data || {};
      var buffer = '', stack1, helper, options, helperMissing=helpers.helperMissing, escapeExpression=this.escapeExpression, self=this;

    function program1(depth0,data) {
      
      var buffer = '', helper, options;
      data.buffer.push("\n          ");
      data.buffer.push(escapeExpression((helper = helpers.render || (depth0 && depth0.render),options={hash:{},hashTypes:{},hashContexts:{},contexts:[depth0,depth0],types:["STRING","ID"],data:data},helper ? helper.call(depth0, "redirectManagerRow", "", options) : helperMissing.call(depth0, "render", "redirectManagerRow", "", options))));
      data.buffer.push("\n        ");
      return buffer;
      }

      data.buffer.push("<div class=\"l-container\">\n  <div class=\"redirects\">\n    <div class=\"page-title\">\n      <h2>Redirects Manager</h2>\n    </div>\n\n    <div class=\"faux-table faux-table--striped\">\n\n      <div class=\"faux-table-head\">\n        <span class=\"faux-table-cell\">Page Name</span>\n        <span class=\"faux-table-cell\">Redirect Rules</span>\n      </div> <!-- end .faux-table-head -->\n\n      <ul class=\"faux-table-body\">\n        ");
      data.buffer.push(escapeExpression((helper = helpers.render || (depth0 && depth0.render),options={hash:{},hashTypes:{},hashContexts:{},contexts:[depth0,depth0],types:["STRING","ID"],data:data},helper ? helper.call(depth0, "redirectManagerRow", "webHomeTemplate", options) : helperMissing.call(depth0, "render", "redirectManagerRow", "webHomeTemplate", options))));
      data.buffer.push("\n        ");
      stack1 = helpers.each.call(depth0, "webPageTemplates", {hash:{},hashTypes:{},hashContexts:{},inverse:self.noop,fn:self.program(1, program1, data),contexts:[depth0],types:["ID"],data:data});
      if(stack1 || stack1 === 0) { data.buffer.push(stack1); }
      data.buffer.push("\n      </ul>\n    </div>\n    <button class=\"save-redirects btn l-pullRight\" ");
      data.buffer.push(escapeExpression(helpers.action.call(depth0, "save", "", {hash:{},hashTypes:{},hashContexts:{},contexts:[depth0,depth0],types:["ID","ID"],data:data})));
      data.buffer.push(">Submit</button>\n  </div>\n</div>\n");
      return buffer;
      
    });
  });
define("cms/templates/saves", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    __exports__["default"] = Ember.Handlebars.template(function anonymous(Handlebars,depth0,helpers,partials,data) {
    this.compilerInfo = [4,'>= 1.0.0'];
    helpers = this.merge(helpers, Ember.Handlebars.helpers); data = data || {};
      var buffer = '', stack1, escapeExpression=this.escapeExpression, helperMissing=helpers.helperMissing, self=this;

    function program1(depth0,data) {
      
      var buffer = '', stack1, helper, options;
      data.buffer.push("\n      <li ");
      data.buffer.push(escapeExpression(helpers['bind-attr'].call(depth0, {hash:{
        'class': (":faux-table-row current")
      },hashTypes:{'class': "STRING"},hashContexts:{'class': depth0},contexts:[],types:[],data:data})));
      data.buffer.push(">\n        <div class=\"faux-table-cell\">");
      data.buffer.push(escapeExpression((helper = helpers.formatDate || (depth0 && depth0.formatDate),options={hash:{},hashTypes:{},hashContexts:{},contexts:[depth0],types:["ID"],data:data},helper ? helper.call(depth0, "created_at", options) : helperMissing.call(depth0, "formatDate", "created_at", options))));
      data.buffer.push("</div>\n        <div class=\"faux-table-cell\">");
      stack1 = helpers._triageMustache.call(depth0, "id", {hash:{},hashTypes:{},hashContexts:{},contexts:[depth0],types:["ID"],data:data});
      if(stack1 || stack1 === 0) { data.buffer.push(stack1); }
      data.buffer.push("</div>\n        <div class=\"faux-table-cell\">\n          <button class=\"btn\" ");
      data.buffer.push(escapeExpression(helpers.action.call(depth0, "restore", "id", {hash:{},hashTypes:{},hashContexts:{},contexts:[depth0,depth0],types:["ID","ID"],data:data})));
      data.buffer.push(">Restore</button>\n        </div>\n      </li>\n      ");
      return buffer;
      }

      data.buffer.push("<div class=\"saves l-container\">\n  <div class=\"page-title\"><h2>CMS State Save Points</h2></div>\n\n  <button class=\"btn\" ");
      data.buffer.push(escapeExpression(helpers.action.call(depth0, "save", {hash:{},hashTypes:{},hashContexts:{},contexts:[depth0],types:["ID"],data:data})));
      data.buffer.push(">Save</button>\n  <div class=\"faux-table faux-table--striped\">\n    <ul class=\"faux-table-body\">\n      ");
      stack1 = helpers.each.call(depth0, "model", {hash:{},hashTypes:{},hashContexts:{},inverse:self.noop,fn:self.program(1, program1, data),contexts:[depth0],types:["ID"],data:data});
      if(stack1 || stack1 === 0) { data.buffer.push(stack1); }
      data.buffer.push("\n    </ul>\n  </div>\n</div>\n\n");
      return buffer;
      
    });
  });
define("cms/templates/web-home-template", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    __exports__["default"] = Ember.Handlebars.template(function anonymous(Handlebars,depth0,helpers,partials,data) {
    this.compilerInfo = [4,'>= 1.0.0'];
    helpers = this.merge(helpers, Ember.Handlebars.helpers); data = data || {};
      var buffer = '', helper, options, helperMissing=helpers.helperMissing, escapeExpression=this.escapeExpression;


      data.buffer.push("<div class=\"builder\">\n  ");
      data.buffer.push(escapeExpression((helper = helpers.render || (depth0 && depth0.render),options={hash:{},hashTypes:{},hashContexts:{},contexts:[depth0,depth0],types:["STRING","ID"],data:data},helper ? helper.call(depth0, "webPageTemplate", "", options) : helperMissing.call(depth0, "render", "webPageTemplate", "", options))));
      data.buffer.push("\n</div>\n");
      return buffer;
      
    });
  });
define("cms/templates/web-page-template", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    __exports__["default"] = Ember.Handlebars.template(function anonymous(Handlebars,depth0,helpers,partials,data) {
    this.compilerInfo = [4,'>= 1.0.0'];
    helpers = this.merge(helpers, Ember.Handlebars.helpers); data = data || {};
      var buffer = '', stack1, helper, options, helperMissing=helpers.helperMissing, escapeExpression=this.escapeExpression, self=this;

    function program1(depth0,data) {
      
      var buffer = '', helper, options;
      data.buffer.push("\n        ");
      data.buffer.push(escapeExpression((helper = helpers['confirmation-link'] || (depth0 && depth0['confirmation-link']),options={hash:{
        'title': ("Deploy All"),
        'action': ("deploy_all"),
        'param': (""),
        'message': ("You are about to deploy. Are you sure?"),
        'classes': ("btn l-pullRight")
      },hashTypes:{'title': "STRING",'action': "STRING",'param': "ID",'message': "STRING",'classes': "STRING"},hashContexts:{'title': depth0,'action': depth0,'param': depth0,'message': depth0,'classes': depth0},contexts:[],types:[],data:data},helper ? helper.call(depth0, options) : helperMissing.call(depth0, "confirmation-link", options))));
      data.buffer.push("\n      ");
      return buffer;
      }

    function program3(depth0,data) {
      
      var buffer = '', helper, options;
      data.buffer.push("\n        ");
      data.buffer.push(escapeExpression((helper = helpers['confirmation-link'] || (depth0 && depth0['confirmation-link']),options={hash:{
        'title': ("Deploy"),
        'action': ("deploy"),
        'param': (""),
        'message': ("You are about to deploy. Are you sure?"),
        'classes': ("btn l-pullRight")
      },hashTypes:{'title': "STRING",'action': "STRING",'param': "ID",'message': "STRING",'classes': "STRING"},hashContexts:{'title': depth0,'action': depth0,'param': depth0,'message': depth0,'classes': depth0},contexts:[],types:[],data:data},helper ? helper.call(depth0, options) : helperMissing.call(depth0, "confirmation-link", options))));
      data.buffer.push("\n      ");
      return buffer;
      }

      data.buffer.push("<div ");
      data.buffer.push(escapeExpression(helpers['bind-attr'].call(depth0, {hash:{
        'class': (":builder classNameForVertical")
      },hashTypes:{'class': "STRING"},hashContexts:{'class': depth0},contexts:[],types:[],data:data})));
      data.buffer.push(">\n  <div class=\"l-container\">\n    <div class=\"page-title  builder-title\">\n      ");
      stack1 = helpers['if'].call(depth0, "controllers.client.single_domain", {hash:{},hashTypes:{},hashContexts:{},inverse:self.program(3, program3, data),fn:self.program(1, program1, data),contexts:[depth0],types:["ID"],data:data});
      if(stack1 || stack1 === 0) { data.buffer.push(stack1); }
      data.buffer.push("\n    </div>\n  </div>\n  ");
      data.buffer.push(escapeExpression((helper = helpers.render || (depth0 && depth0.render),options={hash:{},hashTypes:{},hashContexts:{},contexts:[depth0],types:["STRING"],data:data},helper ? helper.call(depth0, "gardenWebLayouts", options) : helperMissing.call(depth0, "render", "gardenWebLayouts", options))));
      data.buffer.push("\n  ");
      data.buffer.push(escapeExpression((helper = helpers.render || (depth0 && depth0.render),options={hash:{},hashTypes:{},hashContexts:{},contexts:[depth0],types:["STRING"],data:data},helper ? helper.call(depth0, "gardenWebThemes", options) : helperMissing.call(depth0, "render", "gardenWebThemes", options))));
      data.buffer.push("\n  ");
      data.buffer.push(escapeExpression((helper = helpers.render || (depth0 && depth0.render),options={hash:{},hashTypes:{},hashContexts:{},contexts:[depth0],types:["STRING"],data:data},helper ? helper.call(depth0, "gardenWidgets", options) : helperMissing.call(depth0, "render", "gardenWidgets", options))));
      data.buffer.push("\n\n  <div class=\"l-container page-section\">\n    ");
      data.buffer.push(escapeExpression((helper = helpers.render || (depth0 && depth0.render),options={hash:{},hashTypes:{},hashContexts:{},contexts:[depth0],types:["STRING"],data:data},helper ? helper.call(depth0, "headerWidgets", options) : helperMissing.call(depth0, "render", "headerWidgets", options))));
      data.buffer.push("\n    ");
      data.buffer.push(escapeExpression((helper = helpers.render || (depth0 && depth0.render),options={hash:{},hashTypes:{},hashContexts:{},contexts:[depth0],types:["STRING"],data:data},helper ? helper.call(depth0, "mainWidgets", options) : helperMissing.call(depth0, "render", "mainWidgets", options))));
      data.buffer.push("\n    ");
      data.buffer.push(escapeExpression((helper = helpers.render || (depth0 && depth0.render),options={hash:{},hashTypes:{},hashContexts:{},contexts:[depth0],types:["STRING"],data:data},helper ? helper.call(depth0, "asideBeforeMainWidgets", options) : helperMissing.call(depth0, "render", "asideBeforeMainWidgets", options))));
      data.buffer.push("\n    ");
      data.buffer.push(escapeExpression((helper = helpers.render || (depth0 && depth0.render),options={hash:{},hashTypes:{},hashContexts:{},contexts:[depth0],types:["STRING"],data:data},helper ? helper.call(depth0, "asideAfterMainWidgets", options) : helperMissing.call(depth0, "render", "asideAfterMainWidgets", options))));
      data.buffer.push("\n    ");
      data.buffer.push(escapeExpression((helper = helpers.render || (depth0 && depth0.render),options={hash:{},hashTypes:{},hashContexts:{},contexts:[depth0],types:["STRING"],data:data},helper ? helper.call(depth0, "footerWidgets", options) : helperMissing.call(depth0, "render", "footerWidgets", options))));
      data.buffer.push("\n  </div>\n\n  <div class=\"preview\">\n    ");
      data.buffer.push(escapeExpression(helpers.view.call(depth0, "iframe", {hash:{
        'contentBinding': ("this")
      },hashTypes:{'contentBinding': "STRING"},hashContexts:{'contentBinding': depth0},contexts:[depth0],types:["STRING"],data:data})));
      data.buffer.push("\n  </div>\n</div>\n\n");
      return buffer;
      
    });
  });
define("cms/templates/web-page-templates/new", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    __exports__["default"] = Ember.Handlebars.template(function anonymous(Handlebars,depth0,helpers,partials,data) {
    this.compilerInfo = [4,'>= 1.0.0'];
    helpers = this.merge(helpers, Ember.Handlebars.helpers); data = data || {};
      var buffer = '', helper, options, helperMissing=helpers.helperMissing, escapeExpression=this.escapeExpression;


      data.buffer.push("<div class=\"card flip-container flipped\">\n  <div class=\"flipper\">\n\n    ");
      data.buffer.push(escapeExpression((helper = helpers.partial || (depth0 && depth0.partial),options={hash:{},hashTypes:{},hashContexts:{},contexts:[depth0],types:["STRING"],data:data},helper ? helper.call(depth0, "website/webPageTemplateFront", options) : helperMissing.call(depth0, "partial", "website/webPageTemplateFront", options))));
      data.buffer.push("\n\n    ");
      data.buffer.push(escapeExpression((helper = helpers.partial || (depth0 && depth0.partial),options={hash:{},hashTypes:{},hashContexts:{},contexts:[depth0],types:["STRING"],data:data},helper ? helper.call(depth0, "website/webPageTemplateBack", options) : helperMissing.call(depth0, "partial", "website/webPageTemplateBack", options))));
      data.buffer.push("\n\n  </div>\n</div>\n\n");
      return buffer;
      
    });
  });
define("cms/templates/web-theme", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    __exports__["default"] = Ember.Handlebars.template(function anonymous(Handlebars,depth0,helpers,partials,data) {
    this.compilerInfo = [4,'>= 1.0.0'];
    helpers = this.merge(helpers, Ember.Handlebars.helpers); data = data || {};
      var buffer = '', stack1, escapeExpression=this.escapeExpression, self=this;

    function program1(depth0,data) {
      
      var buffer = '';
      data.buffer.push("\n  <div class=\"colors clearfix\">\n    <h3>Customize Colors:</h3>\n    <div class=\"color-fields\">\n      <div class=\"check-field\">\n        <label>\n          ");
      data.buffer.push(escapeExpression(helpers.view.call(depth0, "checkbox", {hash:{
        'checkedBinding': ("customColors"),
        'contentBinding': ("content")
      },hashTypes:{'checkedBinding': "STRING",'contentBinding': "STRING"},hashContexts:{'checkedBinding': depth0,'contentBinding': depth0},contexts:[depth0],types:["STRING"],data:data})));
      data.buffer.push("\n          Use Custom Colors\n        </label>\n      </div>\n      <div class=\"color-field\">\n        ");
      data.buffer.push(escapeExpression(helpers.view.call(depth0, "color-field", {hash:{
        'valueBinding': ("primaryColor"),
        'contentBinding': ("content"),
        'id': ("color-1"),
        'class': ("color")
      },hashTypes:{'valueBinding': "STRING",'contentBinding': "STRING",'id': "STRING",'class': "STRING"},hashContexts:{'valueBinding': depth0,'contentBinding': depth0,'id': depth0,'class': depth0},contexts:[depth0],types:["STRING"],data:data})));
      data.buffer.push("\n        <label for=\"color-1\">Primary</label>\n      </div>\n      <div class=\"color-field\">\n        ");
      data.buffer.push(escapeExpression(helpers.view.call(depth0, "color-field", {hash:{
        'valueBinding': ("secondaryColor"),
        'contentBinding': ("content"),
        'id': ("color-2"),
        'class': ("color")
      },hashTypes:{'valueBinding': "STRING",'contentBinding': "STRING",'id': "STRING",'class': "STRING"},hashContexts:{'valueBinding': depth0,'contentBinding': depth0,'id': depth0,'class': depth0},contexts:[depth0],types:["STRING"],data:data})));
      data.buffer.push("\n        <label for=\"color-2\">Secondary</label>\n      </div>\n      <div class=\"color-field\">\n        ");
      data.buffer.push(escapeExpression(helpers.view.call(depth0, "color-field", {hash:{
        'valueBinding': ("tertiaryColor"),
        'contentBinding': ("content"),
        'id': ("color-3"),
        'class': ("color")
      },hashTypes:{'valueBinding': "STRING",'contentBinding': "STRING",'id': "STRING",'class': "STRING"},hashContexts:{'valueBinding': depth0,'contentBinding': depth0,'id': depth0,'class': depth0},contexts:[depth0],types:["STRING"],data:data})));
      data.buffer.push("\n        <label for=\"color-3\">Tertiary</label>\n      </div>\n    </div>\n  </div>\n");
      return buffer;
      }

    function program3(depth0,data) {
      
      var buffer = '';
      data.buffer.push("\n  <div class=\"fonts clearfix\">\n    <h3>Customize Fonts:</h3>\n    <div class=\"font-fields\">\n      <div class=\"check-field\">\n        <label>\n          ");
      data.buffer.push(escapeExpression(helpers.view.call(depth0, "checkbox", {hash:{
        'checkedBinding': ("customFonts"),
        'contentBinding': ("content")
      },hashTypes:{'checkedBinding': "STRING",'contentBinding': "STRING"},hashContexts:{'checkedBinding': depth0,'contentBinding': depth0},contexts:[depth0],types:["STRING"],data:data})));
      data.buffer.push("\n          Use Custom Fonts\n        </label>\n      </div>\n      <div class=\"font-field\">\n        <label for=\"font-1\">Primary</label>\n        ");
      data.buffer.push(escapeExpression(helpers.view.call(depth0, "font-field", {hash:{
        'valueBinding': ("primaryFont"),
        'contentBinding': ("content"),
        'id': ("font-1"),
        'class': ("font"),
        'placeholderBinding': ("defaultPrimaryFont"),
        'disabledBinding': ("noCustomFonts")
      },hashTypes:{'valueBinding': "STRING",'contentBinding': "STRING",'id': "STRING",'class': "STRING",'placeholderBinding': "STRING",'disabledBinding': "STRING"},hashContexts:{'valueBinding': depth0,'contentBinding': depth0,'id': depth0,'class': depth0,'placeholderBinding': depth0,'disabledBinding': depth0},contexts:[depth0],types:["STRING"],data:data})));
      data.buffer.push("\n      </div>\n      <div class=\"font-field\">\n        <label for=\"font-2\">Secondary</label>\n        ");
      data.buffer.push(escapeExpression(helpers.view.call(depth0, "font-field", {hash:{
        'valueBinding': ("secondaryFont"),
        'contentBinding': ("content"),
        'id': ("font-2"),
        'class': ("font"),
        'placeholderBinding': ("defaultSecondaryFont"),
        'disabledBinding': ("noCustomFonts")
      },hashTypes:{'valueBinding': "STRING",'contentBinding': "STRING",'id': "STRING",'class': "STRING",'placeholderBinding': "STRING",'disabledBinding': "STRING"},hashContexts:{'valueBinding': depth0,'contentBinding': depth0,'id': depth0,'class': depth0,'placeholderBinding': depth0,'disabledBinding': depth0},contexts:[depth0],types:["STRING"],data:data})));
      data.buffer.push("\n      </div>\n    </div>\n  </div>\n");
      return buffer;
      }

      stack1 = helpers.view.call(depth0, "color-picker", {hash:{},hashTypes:{},hashContexts:{},inverse:self.noop,fn:self.program(1, program1, data),contexts:[depth0],types:["STRING"],data:data});
      if(stack1 || stack1 === 0) { data.buffer.push(stack1); }
      data.buffer.push("\n\n");
      stack1 = helpers.view.call(depth0, "font-picker", {hash:{},hashTypes:{},hashContexts:{},inverse:self.noop,fn:self.program(3, program3, data),contexts:[depth0],types:["STRING"],data:data});
      if(stack1 || stack1 === 0) { data.buffer.push(stack1); }
      data.buffer.push("\n");
      return buffer;
      
    });
  });
define("cms/templates/website", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    __exports__["default"] = Ember.Handlebars.template(function anonymous(Handlebars,depth0,helpers,partials,data) {
    this.compilerInfo = [4,'>= 1.0.0'];
    helpers = this.merge(helpers, Ember.Handlebars.helpers); data = data || {};
      var buffer = '', stack1, helper, options, helperMissing=helpers.helperMissing, escapeExpression=this.escapeExpression;


      data.buffer.push(escapeExpression((helper = helpers['widget-modal'] || (depth0 && depth0['widget-modal']),options={hash:{
        'selectedWidgetName': ("selectedWidgetName")
      },hashTypes:{'selectedWidgetName': "ID"},hashContexts:{'selectedWidgetName': depth0},contexts:[],types:[],data:data},helper ? helper.call(depth0, options) : helperMissing.call(depth0, "widget-modal", options))));
      data.buffer.push("\n");
      stack1 = helpers._triageMustache.call(depth0, "outlet", {hash:{},hashTypes:{},hashContexts:{},contexts:[depth0],types:["ID"],data:data});
      if(stack1 || stack1 === 0) { data.buffer.push(stack1); }
      data.buffer.push("\n\n");
      return buffer;
      
    });
  });
define("cms/templates/website/-web-page-template-back", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    __exports__["default"] = Ember.Handlebars.template(function anonymous(Handlebars,depth0,helpers,partials,data) {
    this.compilerInfo = [4,'>= 1.0.0'];
    helpers = this.merge(helpers, Ember.Handlebars.helpers); data = data || {};
      var buffer = '', stack1, helper, options, helperMissing=helpers.helperMissing, escapeExpression=this.escapeExpression, self=this;

    function program1(depth0,data) {
      
      var buffer = '', helper, options;
      data.buffer.push("\n        <label>Page Name (for CMS)</label>\n        ");
      data.buffer.push(escapeExpression((helper = helpers.input || (depth0 && depth0.input),options={hash:{
        'value': ("name"),
        'name': ("page_name")
      },hashTypes:{'value': "ID",'name': "STRING"},hashContexts:{'value': depth0,'name': depth0},contexts:[],types:[],data:data},helper ? helper.call(depth0, options) : helperMissing.call(depth0, "input", options))));
      data.buffer.push("\n      ");
      return buffer;
      }

    function program3(depth0,data) {
      
      var buffer = '', helper, options;
      data.buffer.push("\n        <label>Page Title</label>\n        ");
      data.buffer.push(escapeExpression((helper = helpers.input || (depth0 && depth0.input),options={hash:{
        'value': ("title"),
        'name': ("page_title")
      },hashTypes:{'value': "ID",'name': "STRING"},hashContexts:{'value': depth0,'name': depth0},contexts:[],types:[],data:data},helper ? helper.call(depth0, options) : helperMissing.call(depth0, "input", options))));
      data.buffer.push("\n      ");
      return buffer;
      }

    function program5(depth0,data) {
      
      var buffer = '', helper, options;
      data.buffer.push("\n          <div class=\"switch switch-small\" data-on=\"success\" data-off=\"danger\">\n            ");
      data.buffer.push(escapeExpression((helper = helpers.input || (depth0 && depth0.input),options={hash:{
        'type': ("checkbox"),
        'checked': ("enabled")
      },hashTypes:{'type': "STRING",'checked': "ID"},hashContexts:{'type': depth0,'checked': depth0},contexts:[],types:[],data:data},helper ? helper.call(depth0, options) : helperMissing.call(depth0, "input", options))));
      data.buffer.push("\n          </div>\n        ");
      return buffer;
      }

    function program7(depth0,data) {
      
      var buffer = '';
      data.buffer.push("\n          <button ");
      data.buffer.push(escapeExpression(helpers.action.call(depth0, "cancel", "", {hash:{},hashTypes:{},hashContexts:{},contexts:[depth0,depth0],types:["STRING","ID"],data:data})));
      data.buffer.push(" class=\"cancel-link card-flip\">\n            Cancel\n          </button>\n        ");
      return buffer;
      }

    function program9(depth0,data) {
      
      var buffer = '';
      data.buffer.push("\n          <button ");
      data.buffer.push(escapeExpression(helpers.action.call(depth0, "save", "", {hash:{},hashTypes:{},hashContexts:{},contexts:[depth0,depth0],types:["STRING","ID"],data:data})));
      data.buffer.push(" class=\"save btn btn--small\" disabled>\n            Save\n          </button>\n        ");
      return buffer;
      }

      data.buffer.push("<div class=\"card-container back\">\n\n  ");
      data.buffer.push(escapeExpression((helper = helpers.partial || (depth0 && depth0.partial),options={hash:{},hashTypes:{},hashContexts:{},contexts:[depth0],types:["STRING"],data:data},helper ? helper.call(depth0, "website/web-page-template-head", options) : helperMissing.call(depth0, "partial", "website/web-page-template-head", options))));
      data.buffer.push("\n\n  <div class=\"card-body\">\n\n    <form class=\"form\">\n      ");
      stack1 = helpers.view.call(depth0, "validate-empty-form-field", {hash:{},hashTypes:{},hashContexts:{},inverse:self.noop,fn:self.program(1, program1, data),contexts:[depth0],types:["STRING"],data:data});
      if(stack1 || stack1 === 0) { data.buffer.push(stack1); }
      data.buffer.push("\n\n      ");
      stack1 = helpers.view.call(depth0, "validate-empty-form-field", {hash:{},hashTypes:{},hashContexts:{},inverse:self.noop,fn:self.program(3, program3, data),contexts:[depth0],types:["STRING"],data:data});
      if(stack1 || stack1 === 0) { data.buffer.push(stack1); }
      data.buffer.push("\n\n      <div class=\"form-field template-select\">\n        <label>Parent Page</label>\n\n        ");
      data.buffer.push(escapeExpression(helpers.view.call(depth0, "select", {hash:{
        'contentBinding': ("templates"),
        'prompt': ("None"),
        'name': ("parent"),
        'optionValuePath': ("content.id"),
        'optionLabelPath': ("content.name"),
        'selection': ("parent")
      },hashTypes:{'contentBinding': "STRING",'prompt': "STRING",'name': "STRING",'optionValuePath': "STRING",'optionLabelPath': "STRING",'selection': "ID"},hashContexts:{'contentBinding': depth0,'prompt': depth0,'name': depth0,'optionValuePath': depth0,'optionLabelPath': depth0,'selection': depth0},contexts:[depth0],types:["STRING"],data:data})));
      data.buffer.push("\n      </div>\n\n      <div class=\"form-field\">\n        <label class=\"switch-label\">Page Status</label>\n        ");
      stack1 = helpers.view.call(depth0, "toggle-btn", {hash:{},hashTypes:{},hashContexts:{},inverse:self.noop,fn:self.program(5, program5, data),contexts:[depth0],types:["STRING"],data:data});
      if(stack1 || stack1 === 0) { data.buffer.push(stack1); }
      data.buffer.push("\n      </div>\n\n      <div class=\"buttons\">\n        ");
      stack1 = helpers.view.call(depth0, "card-action", {hash:{},hashTypes:{},hashContexts:{},inverse:self.noop,fn:self.program(7, program7, data),contexts:[depth0],types:["STRING"],data:data});
      if(stack1 || stack1 === 0) { data.buffer.push(stack1); }
      data.buffer.push("\n        ");
      stack1 = helpers.view.call(depth0, "card-action", {hash:{},hashTypes:{},hashContexts:{},inverse:self.noop,fn:self.program(9, program9, data),contexts:[depth0],types:["STRING"],data:data});
      if(stack1 || stack1 === 0) { data.buffer.push(stack1); }
      data.buffer.push("\n      </div>\n    </form>\n\n  </div>\n</div>\n\n");
      return buffer;
      
    });
  });
define("cms/templates/website/-web-page-template-flip", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    __exports__["default"] = Ember.Handlebars.template(function anonymous(Handlebars,depth0,helpers,partials,data) {
    this.compilerInfo = [4,'>= 1.0.0'];
    helpers = this.merge(helpers, Ember.Handlebars.helpers); data = data || {};
      var buffer = '', stack1, self=this;

    function program1(depth0,data) {
      
      
      data.buffer.push("\n  <span class=\"icon icon--settings\">Page Settings</span>\n");
      }

      stack1 = helpers.view.call(depth0, "card-flipper", {hash:{
        'contentBinding': ("this")
      },hashTypes:{'contentBinding': "STRING"},hashContexts:{'contentBinding': depth0},inverse:self.noop,fn:self.program(1, program1, data),contexts:[depth0],types:["STRING"],data:data});
      if(stack1 || stack1 === 0) { data.buffer.push(stack1); }
      data.buffer.push("\n");
      return buffer;
      
    });
  });
define("cms/templates/website/-web-page-template-front", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    __exports__["default"] = Ember.Handlebars.template(function anonymous(Handlebars,depth0,helpers,partials,data) {
    this.compilerInfo = [4,'>= 1.0.0'];
    helpers = this.merge(helpers, Ember.Handlebars.helpers); data = data || {};
      var buffer = '', stack1, helper, options, helperMissing=helpers.helperMissing, escapeExpression=this.escapeExpression, self=this;

    function program1(depth0,data) {
      
      var buffer = '', helper, options;
      data.buffer.push("\n        <li>\n          ");
      data.buffer.push(escapeExpression((helper = helpers.partial || (depth0 && depth0.partial),options={hash:{},hashTypes:{},hashContexts:{},contexts:[depth0],types:["STRING"],data:data},helper ? helper.call(depth0, "website/widget", options) : helperMissing.call(depth0, "partial", "website/widget", options))));
      data.buffer.push("\n        </li>\n      ");
      return buffer;
      }

    function program3(depth0,data) {
      
      var buffer = '', stack1, helper, options;
      data.buffer.push("\n        ");
      stack1 = (helper = helpers['link-to'] || (depth0 && depth0['link-to']),options={hash:{
        'class': ("btn btn--small")
      },hashTypes:{'class': "STRING"},hashContexts:{'class': depth0},inverse:self.noop,fn:self.program(4, program4, data),contexts:[depth0],types:["STRING"],data:data},helper ? helper.call(depth0, "webHomeTemplate", options) : helperMissing.call(depth0, "link-to", "webHomeTemplate", options));
      if(stack1 || stack1 === 0) { data.buffer.push(stack1); }
      data.buffer.push("\n      ");
      return buffer;
      }
    function program4(depth0,data) {
      
      
      data.buffer.push("Edit");
      }

    function program6(depth0,data) {
      
      var buffer = '', stack1, helper, options;
      data.buffer.push("\n        ");
      stack1 = (helper = helpers['link-to'] || (depth0 && depth0['link-to']),options={hash:{
        'class': ("btn btn--small")
      },hashTypes:{'class': "STRING"},hashContexts:{'class': depth0},inverse:self.noop,fn:self.program(4, program4, data),contexts:[depth0,depth0],types:["STRING","ID"],data:data},helper ? helper.call(depth0, "webPageTemplate", "slug", options) : helperMissing.call(depth0, "link-to", "webPageTemplate", "slug", options));
      if(stack1 || stack1 === 0) { data.buffer.push(stack1); }
      data.buffer.push("\n      ");
      return buffer;
      }

      data.buffer.push("<div class=\"card-container front\">\n\n  ");
      data.buffer.push(escapeExpression((helper = helpers.partial || (depth0 && depth0.partial),options={hash:{},hashTypes:{},hashContexts:{},contexts:[depth0],types:["STRING"],data:data},helper ? helper.call(depth0, "website/web-page-template-head", options) : helperMissing.call(depth0, "partial", "website/web-page-template-head", options))));
      data.buffer.push("\n\n  <div class=\"card-body\">\n    <ul class=\"widgets\">\n      ");
      stack1 = helpers.each.call(depth0, "mainWidgets", {hash:{},hashTypes:{},hashContexts:{},inverse:self.noop,fn:self.program(1, program1, data),contexts:[depth0],types:["ID"],data:data});
      if(stack1 || stack1 === 0) { data.buffer.push(stack1); }
      data.buffer.push("\n    </ul>\n    <div class=\"buttons\">\n      ");
      stack1 = helpers['if'].call(depth0, "isWebHomeTemplate", {hash:{},hashTypes:{},hashContexts:{},inverse:self.program(6, program6, data),fn:self.program(3, program3, data),contexts:[depth0],types:["ID"],data:data});
      if(stack1 || stack1 === 0) { data.buffer.push(stack1); }
      data.buffer.push("\n      <a ");
      data.buffer.push(escapeExpression(helpers['bind-attr'].call(depth0, {hash:{
        'href': ("previewUrl")
      },hashTypes:{'href': "STRING"},hashContexts:{'href': depth0},contexts:[],types:[],data:data})));
      data.buffer.push(" class=\"btn btn--small\">Preview</a>\n    </div>\n\n    ");
      data.buffer.push(escapeExpression((helper = helpers.partial || (depth0 && depth0.partial),options={hash:{},hashTypes:{},hashContexts:{},contexts:[depth0],types:["STRING"],data:data},helper ? helper.call(depth0, "website/web-page-template-flip", options) : helperMissing.call(depth0, "partial", "website/web-page-template-flip", options))));
      data.buffer.push("\n  </div>\n</div>\n");
      return buffer;
      
    });
  });
define("cms/templates/website/-web-page-template-head", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    __exports__["default"] = Ember.Handlebars.template(function anonymous(Handlebars,depth0,helpers,partials,data) {
    this.compilerInfo = [4,'>= 1.0.0'];
    helpers = this.merge(helpers, Ember.Handlebars.helpers); data = data || {};
      var buffer = '', stack1;


      data.buffer.push("<div class=\"card-head\">\n  <h3>");
      stack1 = helpers._triageMustache.call(depth0, "name", {hash:{},hashTypes:{},hashContexts:{},contexts:[depth0],types:["ID"],data:data});
      if(stack1 || stack1 === 0) { data.buffer.push(stack1); }
      data.buffer.push("</h3>\n</div>");
      return buffer;
      
    });
  });
define("cms/templates/website/assets", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    __exports__["default"] = Ember.Handlebars.template(function anonymous(Handlebars,depth0,helpers,partials,data) {
    this.compilerInfo = [4,'>= 1.0.0'];
    helpers = this.merge(helpers, Ember.Handlebars.helpers); data = data || {};
      var buffer = '', stack1, helper, options, escapeExpression=this.escapeExpression, self=this, helperMissing=helpers.helperMissing;

    function program1(depth0,data) {
      
      var buffer = '', stack1, helper, options;
      data.buffer.push("\n        <li class=\"asset faux-table-row\">\n          <div class=\"faux-table-cell asset-image\">\n            <a ");
      data.buffer.push(escapeExpression(helpers['bind-attr'].call(depth0, {hash:{
        'href': ("model.url")
      },hashTypes:{'href': "ID"},hashContexts:{'href': depth0},contexts:[],types:[],data:data})));
      data.buffer.push(" target='new'>\n              <img ");
      data.buffer.push(escapeExpression(helpers['bind-attr'].call(depth0, {hash:{
        'src': ("model.url")
      },hashTypes:{'src': "ID"},hashContexts:{'src': depth0},contexts:[],types:[],data:data})));
      data.buffer.push(">\n            </a>\n          </div>\n\n          <div class=\"faux-table-cell asset-category\">\n            <form class=\"asset-element\">\n              <div class=\"selected-category\">\n                <i class=\"fa fa-tags\"></i> ");
      stack1 = helpers._triageMustache.call(depth0, "model.categoryName", {hash:{},hashTypes:{},hashContexts:{},contexts:[depth0],types:["ID"],data:data});
      if(stack1 || stack1 === 0) { data.buffer.push(stack1); }
      data.buffer.push("\n              </div>\n\n              ");
      data.buffer.push(escapeExpression(helpers.view.call(depth0, "select", {hash:{
        'content': ("controller.categories"),
        'name': ("category"),
        'prompt': ("Select New Category"),
        'optionValuePath': ("content.id"),
        'optionLabelPath': ("content.name"),
        'selection': ("model.category")
      },hashTypes:{'content': "ID",'name': "STRING",'prompt': "STRING",'optionValuePath': "STRING",'optionLabelPath': "STRING",'selection': "ID"},hashContexts:{'content': depth0,'name': depth0,'prompt': depth0,'optionValuePath': depth0,'optionLabelPath': depth0,'selection': depth0},contexts:[depth0],types:["STRING"],data:data})));
      data.buffer.push("\n\n              ");
      stack1 = helpers.view.call(depth0, "asset-save", {hash:{},hashTypes:{},hashContexts:{},inverse:self.noop,fn:self.program(2, program2, data),contexts:[depth0],types:["STRING"],data:data});
      if(stack1 || stack1 === 0) { data.buffer.push(stack1); }
      data.buffer.push("\n            </form>\n          </div>\n\n          <div class=\"faux-table-cell asset-url\">\n            <div class=\"asset-element\">");
      data.buffer.push(escapeExpression((helper = helpers['click-select'] || (depth0 && depth0['click-select']),options={hash:{
        'url': ("model.url")
      },hashTypes:{'url': "ID"},hashContexts:{'url': depth0},contexts:[],types:[],data:data},helper ? helper.call(depth0, options) : helperMissing.call(depth0, "click-select", options))));
      data.buffer.push("</div>\n          </div>\n          <div class=\"faux-table-cell asset-delete\">");
      data.buffer.push(escapeExpression((helper = helpers['confirm-button'] || (depth0 && depth0['confirm-button']),options={hash:{
        'title': ("delete"),
        'action': ("deleteAsset"),
        'param': ("model")
      },hashTypes:{'title': "STRING",'action': "STRING",'param': "ID"},hashContexts:{'title': depth0,'action': depth0,'param': depth0},contexts:[],types:[],data:data},helper ? helper.call(depth0, options) : helperMissing.call(depth0, "confirm-button", options))));
      data.buffer.push("</div>\n        </li>\n      ");
      return buffer;
      }
    function program2(depth0,data) {
      
      var buffer = '';
      data.buffer.push("\n                <button ");
      data.buffer.push(escapeExpression(helpers.action.call(depth0, "save", "controller.model", {hash:{},hashTypes:{},hashContexts:{},contexts:[depth0,depth0],types:["STRING","ID"],data:data})));
      data.buffer.push(" class=\"save btn btn--a asset-save\">Save</button>\n              ");
      return buffer;
      }

      data.buffer.push("<div class=\"assets\">\n  <div class=\"page-title\">\n    <h2><i class=\"fa fa-cog\"></i> Asset Manager</h2>\n  </div>\n\n  <div class=\"assets-uploader\">\n    <label>\n      <div class=\"upload-left\"><i class=\"fa fa-upload fa-2x\"></i></div>\n      <div class=\"upload-right\">Upload New Files</div>\n      ");
      data.buffer.push(escapeExpression((helper = helpers['s3-upload'] || (depth0 && depth0['s3-upload']),options={hash:{
        'url': ("/api/v1/sign_upload"),
        'action': ("saveAsset"),
        'websiteName': ("website.name")
      },hashTypes:{'url': "STRING",'action': "STRING",'websiteName': "ID"},hashContexts:{'url': depth0,'action': depth0,'websiteName': depth0},contexts:[],types:[],data:data},helper ? helper.call(depth0, options) : helperMissing.call(depth0, "s3-upload", options))));
      data.buffer.push("\n    </label>\n\n    <div class=\"assets-loader\">\n      <i class=\"fa fa-refresh fa-3x fa-spin\"></i><br>\n      Uploaded <strong class=\"asset-count\">0</strong> of <strong class=\"asset-total\">0</strong>\n    </div>\n\n    <div class=\"assets-success\">\n      <i class=\"fa fa-check-circle-o fa-3x\"></i><br>\n      Upload Complete\n    </div>\n  </div>\n\n  <div class=\"faux-table faux-table--striped\">\n    <ul class=\"faux-table-body\">\n\n      ");
      stack1 = helpers.each.call(depth0, "controller", {hash:{},hashTypes:{},hashContexts:{},inverse:self.noop,fn:self.program(1, program1, data),contexts:[depth0],types:["ID"],data:data});
      if(stack1 || stack1 === 0) { data.buffer.push(stack1); }
      data.buffer.push("\n    </ul>\n  </div>\n</div>\n");
      return buffer;
      
    });
  });
define("cms/templates/website/index", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    __exports__["default"] = Ember.Handlebars.template(function anonymous(Handlebars,depth0,helpers,partials,data) {
    this.compilerInfo = [4,'>= 1.0.0'];
    helpers = this.merge(helpers, Ember.Handlebars.helpers); data = data || {};
      var buffer = '', stack1, helper, options, helperMissing=helpers.helperMissing, escapeExpression=this.escapeExpression, self=this;

    function program1(depth0,data) {
      
      
      data.buffer.push("Asset Manager");
      }

    function program3(depth0,data) {
      
      
      data.buffer.push("Redirects Manager");
      }

    function program5(depth0,data) {
      
      
      data.buffer.push("Recent Deploys");
      }

    function program7(depth0,data) {
      
      
      data.buffer.push("Docs");
      }

    function program9(depth0,data) {
      
      var buffer = '', helper, options;
      data.buffer.push("\n      ");
      data.buffer.push(escapeExpression((helper = helpers['confirmation-link'] || (depth0 && depth0['confirmation-link']),options={hash:{
        'title': ("Deploy All"),
        'action': ("deploy_all"),
        'param': (""),
        'message': ("You are about to deploy. Are you sure?"),
        'classes': ("btn l-pullRight")
      },hashTypes:{'title': "STRING",'action': "STRING",'param': "ID",'message': "STRING",'classes': "STRING"},hashContexts:{'title': depth0,'action': depth0,'param': depth0,'message': depth0,'classes': depth0},contexts:[],types:[],data:data},helper ? helper.call(depth0, options) : helperMissing.call(depth0, "confirmation-link", options))));
      data.buffer.push("\n    ");
      return buffer;
      }

    function program11(depth0,data) {
      
      var buffer = '', helper, options;
      data.buffer.push("\n      ");
      data.buffer.push(escapeExpression((helper = helpers['confirmation-link'] || (depth0 && depth0['confirmation-link']),options={hash:{
        'title': ("Deploy"),
        'action': ("deploy"),
        'param': ("id"),
        'message': ("You are about to deploy. Are you sure?"),
        'classes': ("btn l-pullRight")
      },hashTypes:{'title': "STRING",'action': "STRING",'param': "ID",'message': "STRING",'classes': "STRING"},hashContexts:{'title': depth0,'action': depth0,'param': depth0,'message': depth0,'classes': depth0},contexts:[],types:[],data:data},helper ? helper.call(depth0, options) : helperMissing.call(depth0, "confirmation-link", options))));
      data.buffer.push("\n    ");
      return buffer;
      }

    function program13(depth0,data) {
      
      var buffer = '', stack1, helper, options;
      data.buffer.push("\n        ");
      stack1 = (helper = helpers['link-to'] || (depth0 && depth0['link-to']),options={hash:{
        'class': ("new-page-btn btn")
      },hashTypes:{'class': "STRING"},hashContexts:{'class': depth0},inverse:self.noop,fn:self.program(14, program14, data),contexts:[depth0],types:["STRING"],data:data},helper ? helper.call(depth0, "webPageTemplates.new", options) : helperMissing.call(depth0, "link-to", "webPageTemplates.new", options));
      if(stack1 || stack1 === 0) { data.buffer.push(stack1); }
      data.buffer.push("\n      ");
      return buffer;
      }
    function program14(depth0,data) {
      
      
      data.buffer.push("Create New Page");
      }

    function program16(depth0,data) {
      
      var buffer = '';
      data.buffer.push("\n      <div class=\"lightbox-body\">\n        <h2>Empty the Trash</h2>\n        <p>This is immediate and permanent. There is no undo.</p>\n        <p class=\"c-important\">Are you sure?</p>\n        <div class=\"buttons\">\n          <a href=\"#\" ");
      data.buffer.push(escapeExpression(helpers.action.call(depth0, "confirmEmptyTrash", {hash:{},hashTypes:{},hashContexts:{},contexts:[depth0],types:["ID"],data:data})));
      data.buffer.push(" class=\"btn--text\" id=\"empty-trash-cancel\">Cancel</a>\n          <a href=\"#\" ");
      data.buffer.push(escapeExpression(helpers.action.call(depth0, "emptyTrash", {hash:{},hashTypes:{},hashContexts:{},contexts:[depth0],types:["ID"],data:data})));
      data.buffer.push(" class=\"btn\" id=\"empty-trash-yes\">Yes</a>\n        </div>\n      </div>\n    ");
      return buffer;
      }

      data.buffer.push("<div class=\"l-container\">\n  <div class=\"page-title\">\n    <span class=\"buttons l-pullLeft\">\n      ");
      stack1 = (helper = helpers['link-to'] || (depth0 && depth0['link-to']),options={hash:{
        'class': ("btn")
      },hashTypes:{'class': "STRING"},hashContexts:{'class': depth0},inverse:self.noop,fn:self.program(1, program1, data),contexts:[depth0,depth0],types:["STRING","ID"],data:data},helper ? helper.call(depth0, "website.assets", "", options) : helperMissing.call(depth0, "link-to", "website.assets", "", options));
      if(stack1 || stack1 === 0) { data.buffer.push(stack1); }
      data.buffer.push("\n      ");
      stack1 = (helper = helpers['link-to'] || (depth0 && depth0['link-to']),options={hash:{
        'class': ("btn")
      },hashTypes:{'class': "STRING"},hashContexts:{'class': depth0},inverse:self.noop,fn:self.program(3, program3, data),contexts:[depth0,depth0],types:["STRING","ID"],data:data},helper ? helper.call(depth0, "redirectManager", "", options) : helperMissing.call(depth0, "link-to", "redirectManager", "", options));
      if(stack1 || stack1 === 0) { data.buffer.push(stack1); }
      data.buffer.push("\n      ");
      stack1 = (helper = helpers['link-to'] || (depth0 && depth0['link-to']),options={hash:{
        'class': ("btn")
      },hashTypes:{'class': "STRING"},hashContexts:{'class': depth0},inverse:self.noop,fn:self.program(5, program5, data),contexts:[depth0,depth0],types:["STRING","ID"],data:data},helper ? helper.call(depth0, "website.releases", "", options) : helperMissing.call(depth0, "link-to", "website.releases", "", options));
      if(stack1 || stack1 === 0) { data.buffer.push(stack1); }
      data.buffer.push("\n      ");
      stack1 = (helper = helpers['link-to'] || (depth0 && depth0['link-to']),options={hash:{
        'class': ("btn")
      },hashTypes:{'class': "STRING"},hashContexts:{'class': depth0},inverse:self.noop,fn:self.program(7, program7, data),contexts:[depth0,depth0],types:["STRING","ID"],data:data},helper ? helper.call(depth0, "docs", "", options) : helperMissing.call(depth0, "link-to", "docs", "", options));
      if(stack1 || stack1 === 0) { data.buffer.push(stack1); }
      data.buffer.push("\n    </span>\n    ");
      stack1 = helpers['if'].call(depth0, "controllers.client.single_domain", {hash:{},hashTypes:{},hashContexts:{},inverse:self.program(11, program11, data),fn:self.program(9, program9, data),contexts:[depth0],types:["ID"],data:data});
      if(stack1 || stack1 === 0) { data.buffer.push(stack1); }
      data.buffer.push("\n  </div>\n\n  <div class=\"site-settings page-section l-grid\">\n    ");
      data.buffer.push(escapeExpression((helper = helpers.render || (depth0 && depth0.render),options={hash:{},hashTypes:{},hashContexts:{},contexts:[depth0,depth0],types:["STRING","ID"],data:data},helper ? helper.call(depth0, "website/websiteTemplate", "websiteTemplate", options) : helperMissing.call(depth0, "render", "website/websiteTemplate", "websiteTemplate", options))));
      data.buffer.push("\n  </div>\n\n  <div class=\"site-pages page-section\">\n    <div class=\"page-title\">\n      ");
      stack1 = helpers.view.call(depth0, "new-page", {hash:{},hashTypes:{},hashContexts:{},inverse:self.noop,fn:self.program(13, program13, data),contexts:[depth0],types:["STRING"],data:data});
      if(stack1 || stack1 === 0) { data.buffer.push(stack1); }
      data.buffer.push("\n    </div>\n    <div class=\"cards\">\n      ");
      data.buffer.push(escapeExpression((helper = helpers.render || (depth0 && depth0.render),options={hash:{},hashTypes:{},hashContexts:{},contexts:[depth0,depth0],types:["STRING","ID"],data:data},helper ? helper.call(depth0, "website/webHomeTemplate", "webHomeTemplate", options) : helperMissing.call(depth0, "render", "website/webHomeTemplate", "webHomeTemplate", options))));
      data.buffer.push("\n      ");
      data.buffer.push(escapeExpression((helper = helpers.render || (depth0 && depth0.render),options={hash:{},hashTypes:{},hashContexts:{},contexts:[depth0,depth0],types:["STRING","ID"],data:data},helper ? helper.call(depth0, "website/webPageTemplates", "webPageTemplates", options) : helperMissing.call(depth0, "render", "website/webPageTemplates", "webPageTemplates", options))));
      data.buffer.push("\n      ");
      data.buffer.push(escapeExpression((helper = helpers.outlet || (depth0 && depth0.outlet),options={hash:{},hashTypes:{},hashContexts:{},contexts:[depth0],types:["STRING"],data:data},helper ? helper.call(depth0, "newWebPageTemplate", options) : helperMissing.call(depth0, "outlet", "newWebPageTemplate", options))));
      data.buffer.push("\n    </div>\n  </div>\n\n  <div id=\"trash\">\n    <a href=\"#\" ");
      data.buffer.push(escapeExpression(helpers.action.call(depth0, "confirmEmptyTrash", {hash:{},hashTypes:{},hashContexts:{},contexts:[depth0],types:["ID"],data:data})));
      data.buffer.push(" id=\"trash-can\">\n      <div class=\"icon icon--trash\"></div>\n    </a>\n\n    <div class=\"l-container\">\n      <div id=\"deleted-pages\" class=\"cards\">\n        ");
      data.buffer.push(escapeExpression((helper = helpers.render || (depth0 && depth0.render),options={hash:{},hashTypes:{},hashContexts:{},contexts:[depth0,depth0],types:["STRING","ID"],data:data},helper ? helper.call(depth0, "website/webPageTemplatesInTrash", "webPageTemplates", options) : helperMissing.call(depth0, "render", "website/webPageTemplatesInTrash", "webPageTemplates", options))));
      data.buffer.push("\n      </div>\n    </div>\n\n    ");
      stack1 = helpers.view.call(depth0, "website-web-page-templates-empty-trash", {hash:{},hashTypes:{},hashContexts:{},inverse:self.noop,fn:self.program(16, program16, data),contexts:[depth0],types:["STRING"],data:data});
      if(stack1 || stack1 === 0) { data.buffer.push(stack1); }
      data.buffer.push("\n  </div>\n</div>\n");
      return buffer;
      
    });
  });
define("cms/templates/website/loading", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    __exports__["default"] = Ember.Handlebars.template(function anonymous(Handlebars,depth0,helpers,partials,data) {
    this.compilerInfo = [4,'>= 1.0.0'];
    helpers = this.merge(helpers, Ember.Handlebars.helpers); data = data || {};
      


      data.buffer.push("<div class=\"loader\">Loading...</div>\n");
      
    });
  });
define("cms/templates/website/releases", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    __exports__["default"] = Ember.Handlebars.template(function anonymous(Handlebars,depth0,helpers,partials,data) {
    this.compilerInfo = [4,'>= 1.0.0'];
    helpers = this.merge(helpers, Ember.Handlebars.helpers); data = data || {};
      var buffer = '', stack1, escapeExpression=this.escapeExpression, self=this;

    function program1(depth0,data) {
      
      var buffer = '', stack1;
      data.buffer.push("\n      <li ");
      data.buffer.push(escapeExpression(helpers['bind-attr'].call(depth0, {hash:{
        'class': (":faux-table-row current")
      },hashTypes:{'class': "STRING"},hashContexts:{'class': depth0},contexts:[],types:[],data:data})));
      data.buffer.push(">\n        <div class=\"faux-table-cell\">");
      stack1 = helpers._triageMustache.call(depth0, "created_at", {hash:{},hashTypes:{},hashContexts:{},contexts:[depth0],types:["ID"],data:data});
      if(stack1 || stack1 === 0) { data.buffer.push(stack1); }
      data.buffer.push("</div>\n        <div class=\"faux-table-cell\">\n          <button class=\"btn\" ");
      data.buffer.push(escapeExpression(helpers.action.call(depth0, "rollback", "id", "controller.slug", {hash:{},hashTypes:{},hashContexts:{},contexts:[depth0,depth0,depth0],types:["STRING","ID","ID"],data:data})));
      data.buffer.push(">Rollback</button>\n        </div>\n      </li>\n      ");
      return buffer;
      }

      data.buffer.push("<div class=\"releases l-container\">\n  <div class=\"page-title\"><h2>Releases</h2></div>\n\n  <div class=\"faux-table faux-table--striped\">\n    <ul class=\"faux-table-body\">\n      ");
      stack1 = helpers.each.call(depth0, "model", {hash:{},hashTypes:{},hashContexts:{},inverse:self.noop,fn:self.program(1, program1, data),contexts:[depth0],types:["ID"],data:data});
      if(stack1 || stack1 === 0) { data.buffer.push(stack1); }
      data.buffer.push("\n    </ul>\n  </div>\n</div>\n");
      return buffer;
      
    });
  });
define("cms/templates/website/web-home-template", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    __exports__["default"] = Ember.Handlebars.template(function anonymous(Handlebars,depth0,helpers,partials,data) {
    this.compilerInfo = [4,'>= 1.0.0'];
    helpers = this.merge(helpers, Ember.Handlebars.helpers); data = data || {};
      var buffer = '', helper, options, helperMissing=helpers.helperMissing, escapeExpression=this.escapeExpression;


      data.buffer.push("<div class=\"card flip-container web-home-template\">\n  <div class=\"flipper\">\n    ");
      data.buffer.push(escapeExpression((helper = helpers.partial || (depth0 && depth0.partial),options={hash:{},hashTypes:{},hashContexts:{},contexts:[depth0],types:["STRING"],data:data},helper ? helper.call(depth0, "website/web-page-template-front", options) : helperMissing.call(depth0, "partial", "website/web-page-template-front", options))));
      data.buffer.push("\n    ");
      data.buffer.push(escapeExpression((helper = helpers.partial || (depth0 && depth0.partial),options={hash:{},hashTypes:{},hashContexts:{},contexts:[depth0],types:["STRING"],data:data},helper ? helper.call(depth0, "website/web-page-template-back", options) : helperMissing.call(depth0, "partial", "website/web-page-template-back", options))));
      data.buffer.push("\n  </div>\n</div>\n\n");
      return buffer;
      
    });
  });
define("cms/templates/website/web-page-template", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    __exports__["default"] = Ember.Handlebars.template(function anonymous(Handlebars,depth0,helpers,partials,data) {
    this.compilerInfo = [4,'>= 1.0.0'];
    helpers = this.merge(helpers, Ember.Handlebars.helpers); data = data || {};
      var buffer = '', helper, options, helperMissing=helpers.helperMissing, escapeExpression=this.escapeExpression;


      data.buffer.push("<div class=\"flipper\">\n  ");
      data.buffer.push(escapeExpression((helper = helpers.partial || (depth0 && depth0.partial),options={hash:{},hashTypes:{},hashContexts:{},contexts:[depth0],types:["STRING"],data:data},helper ? helper.call(depth0, "website/web-page-template-front", options) : helperMissing.call(depth0, "partial", "website/web-page-template-front", options))));
      data.buffer.push("\n  ");
      data.buffer.push(escapeExpression((helper = helpers.partial || (depth0 && depth0.partial),options={hash:{},hashTypes:{},hashContexts:{},contexts:[depth0],types:["STRING"],data:data},helper ? helper.call(depth0, "website/web-page-template-back", options) : helperMissing.call(depth0, "partial", "website/web-page-template-back", options))));
      data.buffer.push("\n</div> <!-- end .flipper -->\n");
      return buffer;
      
    });
  });
define("cms/templates/website/web-page-templates-in-trash", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    __exports__["default"] = Ember.Handlebars.template(function anonymous(Handlebars,depth0,helpers,partials,data) {
    this.compilerInfo = [4,'>= 1.0.0'];
    helpers = this.merge(helpers, Ember.Handlebars.helpers); data = data || {};
      var buffer = '', stack1, escapeExpression=this.escapeExpression, self=this;

    function program1(depth0,data) {
      
      var buffer = '', stack1;
      data.buffer.push("\n  ");
      stack1 = helpers.unless.call(depth0, "isNew", {hash:{},hashTypes:{},hashContexts:{},inverse:self.noop,fn:self.program(2, program2, data),contexts:[depth0],types:["ID"],data:data});
      if(stack1 || stack1 === 0) { data.buffer.push(stack1); }
      data.buffer.push("\n");
      return buffer;
      }
    function program2(depth0,data) {
      
      var buffer = '', stack1;
      data.buffer.push("\n    ");
      stack1 = helpers['if'].call(depth0, "inTrash", {hash:{},hashTypes:{},hashContexts:{},inverse:self.noop,fn:self.program(3, program3, data),contexts:[depth0],types:["ID"],data:data});
      if(stack1 || stack1 === 0) { data.buffer.push(stack1); }
      data.buffer.push("\n  ");
      return buffer;
      }
    function program3(depth0,data) {
      
      var buffer = '';
      data.buffer.push("\n      ");
      data.buffer.push(escapeExpression(helpers.view.call(depth0, "website-web-page-template", {hash:{
        'contentBinding': ("this")
      },hashTypes:{'contentBinding': "STRING"},hashContexts:{'contentBinding': depth0},contexts:[depth0],types:["STRING"],data:data})));
      data.buffer.push("\n    ");
      return buffer;
      }

      stack1 = helpers.each.call(depth0, {hash:{},hashTypes:{},hashContexts:{},inverse:self.noop,fn:self.program(1, program1, data),contexts:[],types:[],data:data});
      if(stack1 || stack1 === 0) { data.buffer.push(stack1); }
      data.buffer.push("\n");
      return buffer;
      
    });
  });
define("cms/templates/website/web-page-templates", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    __exports__["default"] = Ember.Handlebars.template(function anonymous(Handlebars,depth0,helpers,partials,data) {
    this.compilerInfo = [4,'>= 1.0.0'];
    helpers = this.merge(helpers, Ember.Handlebars.helpers); data = data || {};
      var buffer = '', stack1, escapeExpression=this.escapeExpression, self=this;

    function program1(depth0,data) {
      
      var buffer = '', stack1;
      data.buffer.push("\n  ");
      stack1 = helpers.unless.call(depth0, "isNew", {hash:{},hashTypes:{},hashContexts:{},inverse:self.noop,fn:self.program(2, program2, data),contexts:[depth0],types:["ID"],data:data});
      if(stack1 || stack1 === 0) { data.buffer.push(stack1); }
      data.buffer.push("\n");
      return buffer;
      }
    function program2(depth0,data) {
      
      var buffer = '', stack1;
      data.buffer.push("\n    ");
      stack1 = helpers.unless.call(depth0, "inTrash", {hash:{},hashTypes:{},hashContexts:{},inverse:self.noop,fn:self.program(3, program3, data),contexts:[depth0],types:["ID"],data:data});
      if(stack1 || stack1 === 0) { data.buffer.push(stack1); }
      data.buffer.push("\n  ");
      return buffer;
      }
    function program3(depth0,data) {
      
      var buffer = '';
      data.buffer.push("\n      ");
      data.buffer.push(escapeExpression(helpers.view.call(depth0, "website-web-page-template", {hash:{
        'contentBinding': ("this")
      },hashTypes:{'contentBinding': "STRING"},hashContexts:{'contentBinding': depth0},contexts:[depth0],types:["STRING"],data:data})));
      data.buffer.push("\n    ");
      return buffer;
      }

      stack1 = helpers.each.call(depth0, {hash:{},hashTypes:{},hashContexts:{},inverse:self.noop,fn:self.program(1, program1, data),contexts:[],types:[],data:data});
      if(stack1 || stack1 === 0) { data.buffer.push(stack1); }
      data.buffer.push("\n");
      return buffer;
      
    });
  });
define("cms/templates/website/website-template", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    __exports__["default"] = Ember.Handlebars.template(function anonymous(Handlebars,depth0,helpers,partials,data) {
    this.compilerInfo = [4,'>= 1.0.0'];
    helpers = this.merge(helpers, Ember.Handlebars.helpers); data = data || {};
      var buffer = '', stack1, helperMissing=helpers.helperMissing, escapeExpression=this.escapeExpression, self=this;

    function program1(depth0,data) {
      
      var buffer = '', helper, options;
      data.buffer.push("\n        <li>\n          ");
      data.buffer.push(escapeExpression((helper = helpers.partial || (depth0 && depth0.partial),options={hash:{},hashTypes:{},hashContexts:{},contexts:[depth0],types:["STRING"],data:data},helper ? helper.call(depth0, "website/widget", options) : helperMissing.call(depth0, "partial", "website/widget", options))));
      data.buffer.push("\n        </li>\n      ");
      return buffer;
      }

      data.buffer.push("<div>\n  <div class=\"l-cell\">\n    <img alt=\"Thumbnail\" class=\"thumb\" ");
      data.buffer.push(escapeExpression(helpers['bind-attr'].call(depth0, {hash:{
        'src': ("webLayout.thumbnail")
      },hashTypes:{'src': "STRING"},hashContexts:{'src': depth0},contexts:[],types:[],data:data})));
      data.buffer.push(" />\n  </div>\n\n  <div class=\"l-cell\">\n    <img alt=\"Thumbnail\" class=\"thumb\" ");
      data.buffer.push(escapeExpression(helpers['bind-attr'].call(depth0, {hash:{
        'src': ("webTheme.thumbnail")
      },hashTypes:{'src': "STRING"},hashContexts:{'src': depth0},contexts:[],types:[],data:data})));
      data.buffer.push(" />\n  </div>\n\n  <div class=\"l-cell l-double-cell\">\n    <h3 class=\"template-heading\">Widgets</h3>\n    <ul class=\"widgets widgets--small\">\n      <!-- refactor this -->\n      ");
      stack1 = helpers.each.call(depth0, "logoWidgets", {hash:{},hashTypes:{},hashContexts:{},inverse:self.noop,fn:self.program(1, program1, data),contexts:[depth0],types:["ID"],data:data});
      if(stack1 || stack1 === 0) { data.buffer.push(stack1); }
      data.buffer.push("\n      ");
      stack1 = helpers.each.call(depth0, "btnWidgets", {hash:{},hashTypes:{},hashContexts:{},inverse:self.noop,fn:self.program(1, program1, data),contexts:[depth0],types:["ID"],data:data});
      if(stack1 || stack1 === 0) { data.buffer.push(stack1); }
      data.buffer.push("\n      ");
      stack1 = helpers.each.call(depth0, "navWidgets", {hash:{},hashTypes:{},hashContexts:{},inverse:self.noop,fn:self.program(1, program1, data),contexts:[depth0],types:["ID"],data:data});
      if(stack1 || stack1 === 0) { data.buffer.push(stack1); }
      data.buffer.push("\n      ");
      stack1 = helpers.each.call(depth0, "asideBeforeMainWidgets", {hash:{},hashTypes:{},hashContexts:{},inverse:self.noop,fn:self.program(1, program1, data),contexts:[depth0],types:["ID"],data:data});
      if(stack1 || stack1 === 0) { data.buffer.push(stack1); }
      data.buffer.push("\n      ");
      stack1 = helpers.each.call(depth0, "asideAfterMainWidgets", {hash:{},hashTypes:{},hashContexts:{},inverse:self.noop,fn:self.program(1, program1, data),contexts:[depth0],types:["ID"],data:data});
      if(stack1 || stack1 === 0) { data.buffer.push(stack1); }
      data.buffer.push("\n      ");
      stack1 = helpers.each.call(depth0, "footerWidgets", {hash:{},hashTypes:{},hashContexts:{},inverse:self.noop,fn:self.program(1, program1, data),contexts:[depth0],types:["ID"],data:data});
      if(stack1 || stack1 === 0) { data.buffer.push(stack1); }
      data.buffer.push("\n    </ul>\n  </div>\n</div>\n");
      return buffer;
      
    });
  });
define("cms/templates/website/widget", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    __exports__["default"] = Ember.Handlebars.template(function anonymous(Handlebars,depth0,helpers,partials,data) {
    this.compilerInfo = [4,'>= 1.0.0'];
    helpers = this.merge(helpers, Ember.Handlebars.helpers); data = data || {};
      var buffer = '', stack1, escapeExpression=this.escapeExpression, self=this;

    function program1(depth0,data) {
      
      var buffer = '', stack1;
      data.buffer.push("\n  \n  <img alt=\"Thumbnail\" ");
      data.buffer.push(escapeExpression(helpers['bind-attr'].call(depth0, {hash:{
        'src': ("view.content.thumbnail")
      },hashTypes:{'src': "STRING"},hashContexts:{'src': depth0},contexts:[],types:[],data:data})));
      data.buffer.push(" />\n  ");
      stack1 = helpers._triageMustache.call(depth0, "view.content.name", {hash:{},hashTypes:{},hashContexts:{},contexts:[depth0],types:["ID"],data:data});
      if(stack1 || stack1 === 0) { data.buffer.push(stack1); }
      data.buffer.push("\n");
      return buffer;
      }

    function program3(depth0,data) {
      
      var buffer = '', stack1;
      data.buffer.push("\n  <img alt=\"Thumbnail\" ");
      data.buffer.push(escapeExpression(helpers['bind-attr'].call(depth0, {hash:{
        'src': ("thumbnail")
      },hashTypes:{'src': "STRING"},hashContexts:{'src': depth0},contexts:[],types:[],data:data})));
      data.buffer.push(" />\n  ");
      stack1 = helpers._triageMustache.call(depth0, "name", {hash:{},hashTypes:{},hashContexts:{},contexts:[depth0],types:["ID"],data:data});
      if(stack1 || stack1 === 0) { data.buffer.push(stack1); }
      data.buffer.push("\n");
      return buffer;
      }

      stack1 = helpers['if'].call(depth0, "view.content.thumbnail", {hash:{},hashTypes:{},hashContexts:{},inverse:self.program(3, program3, data),fn:self.program(1, program1, data),contexts:[depth0],types:["ID"],data:data});
      if(stack1 || stack1 === 0) { data.buffer.push(stack1); }
      data.buffer.push("\n");
      return buffer;
      
    });
  });
define("cms/templates/widgets-add", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    __exports__["default"] = Ember.Handlebars.template(function anonymous(Handlebars,depth0,helpers,partials,data) {
    this.compilerInfo = [4,'>= 1.0.0'];
    helpers = this.merge(helpers, Ember.Handlebars.helpers); data = data || {};
      


      data.buffer.push("Add Widget\n");
      
    });
  });
define("cms/templates/widgets-remove", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    __exports__["default"] = Ember.Handlebars.template(function anonymous(Handlebars,depth0,helpers,partials,data) {
    this.compilerInfo = [4,'>= 1.0.0'];
    helpers = this.merge(helpers, Ember.Handlebars.helpers); data = data || {};
      


      data.buffer.push("Remove Widget\n");
      
    });
  });
define("cms/tests/cms/tests/helpers/resolver.jshint", 
  [],
  function() {
    "use strict";
    module('JSHint - cms/tests/helpers');
    test('cms/tests/helpers/resolver.js should pass jshint', function() { 
      ok(true, 'cms/tests/helpers/resolver.js should pass jshint.'); 
    });
  });
define("cms/tests/cms/tests/helpers/start-app.jshint", 
  [],
  function() {
    "use strict";
    module('JSHint - cms/tests/helpers');
    test('cms/tests/helpers/start-app.js should pass jshint', function() { 
      ok(true, 'cms/tests/helpers/start-app.js should pass jshint.'); 
    });
  });
define("cms/tests/cms/tests/test-helper.jshint", 
  [],
  function() {
    "use strict";
    module('JSHint - cms/tests');
    test('cms/tests/test-helper.js should pass jshint', function() { 
      ok(true, 'cms/tests/test-helper.js should pass jshint.'); 
    });
  });
define("cms/tests/helpers/resolver", 
  ["ember/resolver","cms/config/environment","exports"],
  function(__dependency1__, __dependency2__, __exports__) {
    "use strict";
    var Resolver = __dependency1__["default"];
    var config = __dependency2__["default"];

    var resolver = Resolver.create();

    resolver.namespace = {
      modulePrefix: config.modulePrefix,
      podModulePrefix: config.podModulePrefix
    };

    __exports__["default"] = resolver;
  });
define("cms/tests/helpers/start-app", 
  ["ember","cms/app","cms/router","cms/config/environment","exports"],
  function(__dependency1__, __dependency2__, __dependency3__, __dependency4__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    var Application = __dependency2__["default"];
    var Router = __dependency3__["default"];
    var config = __dependency4__["default"];

    __exports__["default"] = function startApp(attrs) {
      var application;

      var attributes = Ember.merge({}, config.APP);
      attributes = Ember.merge(attributes, attrs); // use defaults, but you can override;

      Ember.run(function() {
        application = Application.create(attributes);
        application.setupForTesting();
        application.injectTestHelpers();
      });

      return application;
    }
  });
define("cms/tests/test-helper", 
  ["cms/tests/helpers/resolver","ember-qunit"],
  function(__dependency1__, __dependency2__) {
    "use strict";
    var resolver = __dependency1__["default"];
    var setResolver = __dependency2__.setResolver;

    setResolver(resolver);

    document.write('<div id="ember-testing-container"><div id="ember-testing"></div></div>');

    QUnit.config.urlConfig.push({ id: 'nocontainer', label: 'Hide container'});
    var containerVisibility = QUnit.urlParams.nocontainer ? 'hidden' : 'visible';
    document.getElementById('ember-testing-container').style.visibility = containerVisibility;
  });
define("cms/tests/unit/adapters/application-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var moduleFor = __dependency1__.moduleFor;
    var test = __dependency1__.test;
    moduleFor('adapter:application', 'ApplicationAdapter', {});

    test('it exists', function() {
      var adapter;
      adapter = this.subject();
      return ok(adapter);
    });
  });
define("cms/tests/unit/components/click-select-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleForComponent = __dependency1__.moduleForComponent;
    moduleForComponent('click-select', 'ClickSelectComponent', {});

    test('it renders', function() {
      var component;
      expect(2);
      component = this.subject();
      equal(component._state, 'preRender');
      this.append();
      return equal(component._state, 'inDOM');
    });
  });
define("cms/tests/unit/components/confirm-button-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleForComponent = __dependency1__.moduleForComponent;
    moduleForComponent('confirm-button', 'ConfirmButtonComponent', {});

    test('it renders', function() {
      var component;
      expect(2);
      component = this.subject();
      equal(component._state, 'preRender');
      this.append();
      return equal(component._state, 'inDOM');
    });
  });
define("cms/tests/unit/components/confirmation-link-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleForComponent = __dependency1__.moduleForComponent;
    moduleForComponent('confirmation-link', 'ConfirmationLinkComponent', {});

    test('it renders', function() {
      var component;
      expect(2);
      component = this.subject();
      equal(component._state, 'preRender');
      this.append();
      return equal(component._state, 'inDOM');
    });
  });
define("cms/tests/unit/components/s3-upload-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleForComponent = __dependency1__.moduleForComponent;
    moduleForComponent('s3-upload', 'S3UploadComponent', {});

    test('it renders', function() {
      var component;
      expect(2);
      component = this.subject();
      equal(component._state, 'preRender');
      this.append();
      return equal(component._state, 'inDOM');
    });
  });
define("cms/tests/unit/components/widget-modal-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleForComponent = __dependency1__.moduleForComponent;
    moduleForComponent('widget-modal', 'WidgetModalComponent', {});

    test('it renders', function() {
      var component;
      expect(2);
      component = this.subject();
      equal(component._state, 'preRender');
      this.append();
      return equal(component._state, 'inDOM');
    });
  });
define("cms/tests/unit/controllers/application-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleFor = __dependency1__.moduleFor;
    moduleFor('controller:application', 'ApplicationController', {});

    test('it exists', function() {
      var controller;
      controller = this.subject();
      return ok(controller);
    });
  });
define("cms/tests/unit/controllers/aside-after-main-widgets-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleFor = __dependency1__.moduleFor;
    moduleFor('controller:aside-after-main-widgets', 'AsideAfterMainWidgetsController', {});

    test('it exists', function() {
      var controller;
      controller = this.subject();
      return ok(controller);
    });
  });
define("cms/tests/unit/controllers/aside-before-main-widgets-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleFor = __dependency1__.moduleFor;
    moduleFor('controller:aside-before-main-widgets', 'AsideBeforeMainWidgetsController', {});

    test('it exists', function() {
      var controller;
      controller = this.subject();
      return ok(controller);
    });
  });
define("cms/tests/unit/controllers/assets-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleFor = __dependency1__.moduleFor;
    moduleFor('controller:assets', 'AssetsController', {});

    test('it exists', function() {
      var controller;
      controller = this.subject();
      return ok(controller);
    });
  });
define("cms/tests/unit/controllers/btn-widgets-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleFor = __dependency1__.moduleFor;
    moduleFor('controller:btn-widgets', 'BtnWidgetsController', {});

    test('it exists', function() {
      var controller;
      controller = this.subject();
      return ok(controller);
    });
  });
define("cms/tests/unit/controllers/client-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleFor = __dependency1__.moduleFor;
    moduleFor('controller:client', 'ClientController', {});

    test('it exists', function() {
      var controller;
      controller = this.subject();
      return ok(controller);
    });
  });
define("cms/tests/unit/controllers/footer-widgets-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleFor = __dependency1__.moduleFor;
    moduleFor('controller:footer-widgets', 'FooterWidgetsController', {});

    test('it exists', function() {
      var controller;
      controller = this.subject();
      return ok(controller);
    });
  });
define("cms/tests/unit/controllers/garden-web-layout-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleFor = __dependency1__.moduleFor;
    moduleFor('controller:garden-web-layout', 'GardenWebLayoutController', {});

    test('it exists', function() {
      var controller;
      controller = this.subject();
      return ok(controller);
    });
  });
define("cms/tests/unit/controllers/garden-web-layouts-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleFor = __dependency1__.moduleFor;
    moduleFor('controller:garden-web-layouts', 'GardenWebLayoutsController', {});

    test('it exists', function() {
      var controller;
      controller = this.subject();
      return ok(controller);
    });
  });
define("cms/tests/unit/controllers/garden-web-themes-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleFor = __dependency1__.moduleFor;
    moduleFor('controller:garden-web-themes', 'GardenWebThemesController', {});

    test('it exists', function() {
      var controller;
      controller = this.subject();
      return ok(controller);
    });
  });
define("cms/tests/unit/controllers/garden-widgets-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleFor = __dependency1__.moduleFor;
    moduleFor('controller:garden-widgets', 'GardenWidgetsController', {});

    test('it exists', function() {
      var controller;
      controller = this.subject();
      return ok(controller);
    });
  });
define("cms/tests/unit/controllers/head-widgets-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleFor = __dependency1__.moduleFor;
    moduleFor('controller:head-widgets', 'HeadWidgetsController', {});

    test('it exists', function() {
      var controller;
      controller = this.subject();
      return ok(controller);
    });
  });
define("cms/tests/unit/controllers/location-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleFor = __dependency1__.moduleFor;
    moduleFor('controller:location', 'LocationController', {});

    test('it exists', function() {
      var controller;
      controller = this.subject();
      return ok(controller);
    });
  });
define("cms/tests/unit/controllers/locations-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleFor = __dependency1__.moduleFor;
    moduleFor('controller:locations', 'LocationsController', {});

    test('it exists', function() {
      var controller;
      controller = this.subject();
      return ok(controller);
    });
  });
define("cms/tests/unit/controllers/logo-widgets-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleFor = __dependency1__.moduleFor;
    moduleFor('controller:logo-widgets', 'LogoWidgetsController', {});

    test('it exists', function() {
      var controller;
      controller = this.subject();
      return ok(controller);
    });
  });
define("cms/tests/unit/controllers/main-widgets-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleFor = __dependency1__.moduleFor;
    moduleFor('controller:main-widgets', 'MainWidgetsController', {});

    test('it exists', function() {
      var controller;
      controller = this.subject();
      return ok(controller);
    });
  });
define("cms/tests/unit/controllers/nav-widgets-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleFor = __dependency1__.moduleFor;
    moduleFor('controller:nav-widgets', 'NavWidgetsController', {});

    test('it exists', function() {
      var controller;
      controller = this.subject();
      return ok(controller);
    });
  });
define("cms/tests/unit/controllers/redirect-manager-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleFor = __dependency1__.moduleFor;
    moduleFor('controller:redirect-manager', 'RedirectManagerController', {});

    test('it exists', function() {
      var controller;
      controller = this.subject();
      return ok(controller);
    });
  });
define("cms/tests/unit/controllers/releases-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleFor = __dependency1__.moduleFor;
    moduleFor('controller:releases', 'ReleasesController', {});

    test('it exists', function() {
      var controller;
      controller = this.subject();
      return ok(controller);
    });
  });
define("cms/tests/unit/controllers/sortable-widgets-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleFor = __dependency1__.moduleFor;
    moduleFor('controller:sortable-widgets', 'SortableWidgetsController', {});

    test('it exists', function() {
      var controller;
      controller = this.subject();
      return ok(controller);
    });
  });
define("cms/tests/unit/controllers/web-home-template-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleFor = __dependency1__.moduleFor;
    moduleFor('controller:web-home-template', 'WebHomeTemplateController', {});

    test('it exists', function() {
      var controller;
      controller = this.subject();
      return ok(controller);
    });
  });
define("cms/tests/unit/controllers/web-layout-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleFor = __dependency1__.moduleFor;
    moduleFor('controller:web-layout', 'WebLayoutController', {});

    test('it exists', function() {
      var controller;
      controller = this.subject();
      return ok(controller);
    });
  });
define("cms/tests/unit/controllers/web-page-template-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleFor = __dependency1__.moduleFor;
    moduleFor('controller:web-page-template', 'WebPageTemplateController', {});

    test('it exists', function() {
      var controller;
      controller = this.subject();
      return ok(controller);
    });
  });
define("cms/tests/unit/controllers/web-page-templates-new-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleFor = __dependency1__.moduleFor;
    moduleFor('controller:web-page-templates-new', 'WebPageTemplatesNewController', {});

    test('it exists', function() {
      var controller;
      controller = this.subject();
      return ok(controller);
    });
  });
define("cms/tests/unit/controllers/web-page-templates-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleFor = __dependency1__.moduleFor;
    moduleFor('controller:web-page-templates', 'WebPageTemplatesController', {});

    test('it exists', function() {
      var controller;
      controller = this.subject();
      return ok(controller);
    });
  });
define("cms/tests/unit/controllers/web-theme-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleFor = __dependency1__.moduleFor;
    moduleFor('controller:web-theme', 'WebThemeController', {});

    test('it exists', function() {
      var controller;
      controller = this.subject();
      return ok(controller);
    });
  });
define("cms/tests/unit/controllers/web-themes-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleFor = __dependency1__.moduleFor;
    moduleFor('controller:web-themes', 'WebThemesController', {});

    test('it exists', function() {
      var controller;
      controller = this.subject();
      return ok(controller);
    });
  });
define("cms/tests/unit/controllers/website-index-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleFor = __dependency1__.moduleFor;
    moduleFor('controller:website-index', 'WebsiteIndexController', {});

    test('it exists', function() {
      var controller;
      controller = this.subject();
      return ok(controller);
    });
  });
define("cms/tests/unit/controllers/website-template-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleFor = __dependency1__.moduleFor;
    moduleFor('controller:website-template', 'WebsiteTemplateController', {});

    test('it exists', function() {
      var controller;
      controller = this.subject();
      return ok(controller);
    });
  });
define("cms/tests/unit/controllers/website-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleFor = __dependency1__.moduleFor;
    moduleFor('controller:website', 'WebsiteController', {});

    test('it exists', function() {
      var controller;
      controller = this.subject();
      return ok(controller);
    });
  });
define("cms/tests/unit/controllers/website-web-home-template-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleFor = __dependency1__.moduleFor;
    moduleFor('controller:website-web-home-template', 'WebsiteWebHomeTemplateController', {});

    test('it exists', function() {
      var controller;
      controller = this.subject();
      return ok(controller);
    });
  });
define("cms/tests/unit/controllers/website-web-page-templates-in-trash-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleFor = __dependency1__.moduleFor;
    moduleFor('controller:website-web-page-templates-in-trash', 'WebsiteWebPageTemplatesInTrashController', {});

    test('it exists', function() {
      var controller;
      controller = this.subject();
      return ok(controller);
    });
  });
define("cms/tests/unit/controllers/website-web-page-templates-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleFor = __dependency1__.moduleFor;
    moduleFor('controller:website-web-page-templates', 'WebsiteWebPageTemplatesController', {});

    test('it exists', function() {
      var controller;
      controller = this.subject();
      return ok(controller);
    });
  });
define("cms/tests/unit/helpers/format-date-test", 
  ["cms/helpers/format-date"],
  function(__dependency1__) {
    "use strict";
    var formatDate = __dependency1__.formatDate;
    module('FormatDateHelper');

    test('it works', function() {
      var result;
      result = formatDate(42);
      return ok(result);
    });
  });
define("cms/tests/unit/mixins/jq-base-test", 
  ["ember","cms/mixins/jq-base"],
  function(__dependency1__, __dependency2__) {
    "use strict";
    var Ember = __dependency1__["default"];
    var JqBaseMixin = __dependency2__["default"];
    module('JqBaseMixin');

    test('it works', function() {
      var JqBaseObject, subject;
      JqBaseObject = Ember.Object.extend(JqBaseMixin);
      subject = JqBaseObject.create();
      return ok(subject);
    });
  });
define("cms/tests/unit/mixins/jq-draggable-test", 
  ["ember","cms/mixins/jq-draggable"],
  function(__dependency1__, __dependency2__) {
    "use strict";
    var Ember = __dependency1__["default"];
    var JqDraggableMixin = __dependency2__["default"];
    module('JqDraggableMixin');

    test('it works', function() {
      var JqDraggableObject, subject;
      JqDraggableObject = Ember.Object.extend(JqDraggableMixin);
      subject = JqDraggableObject.create();
      return ok(subject);
    });
  });
define("cms/tests/unit/mixins/jq-droppable-test", 
  ["ember","cms/mixins/jq-droppable"],
  function(__dependency1__, __dependency2__) {
    "use strict";
    var Ember = __dependency1__["default"];
    var JqDroppableMixin = __dependency2__["default"];
    module('JqDroppableMixin');

    test('it works', function() {
      var JqDroppableObject, subject;
      JqDroppableObject = Ember.Object.extend(JqDroppableMixin);
      subject = JqDroppableObject.create();
      return ok(subject);
    });
  });
define("cms/tests/unit/mixins/jq-sortable-test", 
  ["ember","cms/mixins/jq-sortable"],
  function(__dependency1__, __dependency2__) {
    "use strict";
    var Ember = __dependency1__["default"];
    var JqSortableMixin = __dependency2__["default"];
    module('JqSortableMixin');

    test('it works', function() {
      var JqSortableObject, subject;
      JqSortableObject = Ember.Object.extend(JqSortableMixin);
      subject = JqSortableObject.create();
      return ok(subject);
    });
  });
define("cms/tests/unit/mixins/reload-iframe-test", 
  ["ember","cms/mixins/reload-iframe"],
  function(__dependency1__, __dependency2__) {
    "use strict";
    var Ember = __dependency1__["default"];
    var ReloadIframeMixin = __dependency2__["default"];
    module('ReloadIframeMixin');

    test('it works', function() {
      var ReloadIframeObject, subject;
      ReloadIframeObject = Ember.Object.extend(ReloadIframeMixin);
      subject = ReloadIframeObject.create();
      return ok(subject);
    });
  });
define("cms/tests/unit/models/aside-after-main-widget-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleForModel = __dependency1__.moduleForModel;
    moduleForModel('aside-after-main-widget', 'AsideAfterMainWidget', {
      needs: []
    });

    test('it exists', function() {
      var model;
      model = this.subject();
      return ok(!!model);
    });
  });
define("cms/tests/unit/models/aside-before-main-widget-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleForModel = __dependency1__.moduleForModel;
    moduleForModel('aside-before-main-widget', 'AsideBeforeMainWidget', {
      needs: []
    });

    test('it exists', function() {
      var model;
      model = this.subject();
      return ok(!!model);
    });
  });
define("cms/tests/unit/models/asset-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleForModel = __dependency1__.moduleForModel;
    moduleForModel('asset', 'Asset', {
      needs: []
    });

    test('it exists', function() {
      var model;
      model = this.subject();
      return ok(!!model);
    });
  });
define("cms/tests/unit/models/btn-widget-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleForModel = __dependency1__.moduleForModel;
    moduleForModel('btn-widget', 'BtnWidget', {
      needs: []
    });

    test('it exists', function() {
      var model;
      model = this.subject();
      return ok(!!model);
    });
  });
define("cms/tests/unit/models/category-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleForModel = __dependency1__.moduleForModel;
    moduleForModel('category', 'Category', {
      needs: []
    });

    test('it exists', function() {
      var model;
      model = this.subject();
      return ok(!!model);
    });
  });
define("cms/tests/unit/models/client-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleForModel = __dependency1__.moduleForModel;
    moduleForModel('client', 'Client', {
      needs: []
    });

    test('it exists', function() {
      var model;
      model = this.subject();
      return ok(!!model);
    });
  });
define("cms/tests/unit/models/footer-widget-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleForModel = __dependency1__.moduleForModel;
    moduleForModel('footer-widget', 'FooterWidget', {
      needs: []
    });

    test('it exists', function() {
      var model;
      model = this.subject();
      return ok(!!model);
    });
  });
define("cms/tests/unit/models/garden-web-layout-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleForModel = __dependency1__.moduleForModel;
    moduleForModel('garden-web-layout', 'GardenWebLayout', {
      needs: []
    });

    test('it exists', function() {
      var model;
      model = this.subject();
      return ok(!!model);
    });
  });
define("cms/tests/unit/models/garden-web-theme-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleForModel = __dependency1__.moduleForModel;
    moduleForModel('garden-web-theme', 'GardenWebTheme', {
      needs: []
    });

    test('it exists', function() {
      var model;
      model = this.subject();
      return ok(!!model);
    });
  });
define("cms/tests/unit/models/garden-widget-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleForModel = __dependency1__.moduleForModel;
    moduleForModel('garden-widget', 'GardenWidget', {
      needs: []
    });

    test('it exists', function() {
      var model;
      model = this.subject();
      return ok(!!model);
    });
  });
define("cms/tests/unit/models/head-widget-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleForModel = __dependency1__.moduleForModel;
    moduleForModel('head-widget', 'HeadWidget', {
      needs: []
    });

    test('it exists', function() {
      var model;
      model = this.subject();
      return ok(!!model);
    });
  });
define("cms/tests/unit/models/location-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleForModel = __dependency1__.moduleForModel;
    moduleForModel('location', 'Location', {
      needs: []
    });

    test('it exists', function() {
      var model;
      model = this.subject();
      return ok(!!model);
    });
  });
define("cms/tests/unit/models/logo-widget-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleForModel = __dependency1__.moduleForModel;
    moduleForModel('logo-widget', 'LogoWidget', {
      needs: []
    });

    test('it exists', function() {
      var model;
      model = this.subject();
      return ok(!!model);
    });
  });
define("cms/tests/unit/models/main-widget-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleForModel = __dependency1__.moduleForModel;
    moduleForModel('main-widget', 'MainWidget', {
      needs: []
    });

    test('it exists', function() {
      var model;
      model = this.subject();
      return ok(!!model);
    });
  });
define("cms/tests/unit/models/nav-widget-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleForModel = __dependency1__.moduleForModel;
    moduleForModel('nav-widget', 'NavWidget', {
      needs: []
    });

    test('it exists', function() {
      var model;
      model = this.subject();
      return ok(!!model);
    });
  });
define("cms/tests/unit/models/release-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleForModel = __dependency1__.moduleForModel;
    moduleForModel('release', 'Release', {
      needs: []
    });

    test('it exists', function() {
      var model;
      model = this.subject();
      return ok(!!model);
    });
  });
define("cms/tests/unit/models/save-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleForModel = __dependency1__.moduleForModel;
    moduleForModel('save', 'Save', {
      needs: []
    });

    test('it exists', function() {
      var model;
      model = this.subject();
      return ok(!!model);
    });
  });
define("cms/tests/unit/models/web-home-template-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleForModel = __dependency1__.moduleForModel;
    moduleForModel('web-home-template', 'WebHomeTemplate', {
      needs: []
    });

    test('it exists', function() {
      var model;
      model = this.subject();
      return ok(!!model);
    });
  });
define("cms/tests/unit/models/web-layout-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleForModel = __dependency1__.moduleForModel;
    moduleForModel('web-layout', 'WebLayout', {
      needs: []
    });

    test('it exists', function() {
      var model;
      model = this.subject();
      return ok(!!model);
    });
  });
define("cms/tests/unit/models/web-page-template-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleForModel = __dependency1__.moduleForModel;
    moduleForModel('web-page-template', 'WebPageTemplate', {
      needs: []
    });

    test('it exists', function() {
      var model;
      model = this.subject();
      return ok(!!model);
    });
  });
define("cms/tests/unit/models/web-theme-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleForModel = __dependency1__.moduleForModel;
    moduleForModel('web-theme', 'WebTheme', {
      needs: []
    });

    test('it exists', function() {
      var model;
      model = this.subject();
      return ok(!!model);
    });
  });
define("cms/tests/unit/models/website-template-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleForModel = __dependency1__.moduleForModel;
    moduleForModel('website-template', 'WebsiteTemplate', {
      needs: []
    });

    test('it exists', function() {
      var model;
      model = this.subject();
      return ok(!!model);
    });
  });
define("cms/tests/unit/models/website-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleForModel = __dependency1__.moduleForModel;
    moduleForModel('website', 'Website', {
      needs: []
    });

    test('it exists', function() {
      var model;
      model = this.subject();
      return ok(!!model);
    });
  });
define("cms/tests/unit/routes/application-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleFor = __dependency1__.moduleFor;
    moduleFor('route:application', 'ApplicationRoute', {});

    test('it exists', function() {
      var route;
      route = this.subject();
      return ok(route);
    });
  });
define("cms/tests/unit/routes/docs-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleFor = __dependency1__.moduleFor;
    moduleFor('route:docs', 'DocsRoute', {});

    test('it exists', function() {
      var route;
      route = this.subject();
      return ok(route);
    });
  });
define("cms/tests/unit/routes/locations-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleFor = __dependency1__.moduleFor;
    moduleFor('route:locations', 'LocationsRoute', {});

    test('it exists', function() {
      var route;
      route = this.subject();
      return ok(route);
    });
  });
define("cms/tests/unit/routes/redirect-manager-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleFor = __dependency1__.moduleFor;
    moduleFor('route:redirect-manager', 'RedirectManagerRoute', {});

    test('it exists', function() {
      var route;
      route = this.subject();
      return ok(route);
    });
  });
define("cms/tests/unit/routes/saves-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleFor = __dependency1__.moduleFor;
    moduleFor('route:saves', 'SavesRoute', {});

    test('it exists', function() {
      var route;
      route = this.subject();
      return ok(route);
    });
  });
define("cms/tests/unit/routes/website-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleFor = __dependency1__.moduleFor;
    moduleFor('route:website', 'WebsiteRoute', {});

    test('it exists', function() {
      var route;
      route = this.subject();
      return ok(route);
    });
  });
define("cms/tests/unit/routes/website/assets-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleFor = __dependency1__.moduleFor;
    moduleFor('route:assets', 'AssetsRoute', {});

    test('it exists', function() {
      var route;
      route = this.subject();
      return ok(route);
    });
  });
define("cms/tests/unit/routes/website/releases-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleFor = __dependency1__.moduleFor;
    moduleFor('route:releases', 'ReleasesRoute', {});

    test('it exists', function() {
      var route;
      route = this.subject();
      return ok(route);
    });
  });
define("cms/tests/unit/routes/website/web-home-template-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleFor = __dependency1__.moduleFor;
    moduleFor('route:web-home-template', 'WebHomeTemplateRoute', {});

    test('it exists', function() {
      var route;
      route = this.subject();
      return ok(route);
    });
  });
define("cms/tests/unit/routes/website/web-page-template-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleFor = __dependency1__.moduleFor;
    moduleFor('route:web-page-template', 'WebPageTemplateRoute', {});

    test('it exists', function() {
      var route;
      route = this.subject();
      return ok(route);
    });
  });
define("cms/tests/unit/routes/website/web-page-templates/new-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleFor = __dependency1__.moduleFor;
    moduleFor('route:website/web-page-templates/new', 'WebsiteWebPageTemplatesNewRoute', {});

    test('it exists', function() {
      var route;
      route = this.subject();
      return ok(route);
    });
  });
define("cms/tests/unit/views/asset-save-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleFor = __dependency1__.moduleFor;
    moduleFor('view:asset-save', 'AssetSaveView');

    test('it exists', function() {
      var view;
      view = this.subject();
      return ok(view);
    });
  });
define("cms/tests/unit/views/card-action-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleFor = __dependency1__.moduleFor;
    moduleFor('view:card-action', 'CardActionView');

    test('it exists', function() {
      var view;
      view = this.subject();
      return ok(view);
    });
  });
define("cms/tests/unit/views/card-flipper-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleFor = __dependency1__.moduleFor;
    moduleFor('view:card-flipper', 'CardFlipperView');

    test('it exists', function() {
      var view;
      view = this.subject();
      return ok(view);
    });
  });
define("cms/tests/unit/views/checkbox-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleFor = __dependency1__.moduleFor;
    moduleFor('view:checkbox', 'CheckboxView');

    test('it exists', function() {
      var view;
      view = this.subject();
      return ok(view);
    });
  });
define("cms/tests/unit/views/color-field-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleFor = __dependency1__.moduleFor;
    moduleFor('view:color-field', 'ColorFieldView');

    test('it exists', function() {
      var view;
      view = this.subject();
      return ok(view);
    });
  });
define("cms/tests/unit/views/color-picker-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleFor = __dependency1__.moduleFor;
    moduleFor('view:color-picker', 'ColorPickerView');

    test('it exists', function() {
      var view;
      view = this.subject();
      return ok(view);
    });
  });
define("cms/tests/unit/views/font-field-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleFor = __dependency1__.moduleFor;
    moduleFor('view:font-field', 'FontFieldView');

    test('it exists', function() {
      var view;
      view = this.subject();
      return ok(view);
    });
  });
define("cms/tests/unit/views/font-picker-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleFor = __dependency1__.moduleFor;
    moduleFor('view:font-picker', 'FontPickerView');

    test('it exists', function() {
      var view;
      view = this.subject();
      return ok(view);
    });
  });
define("cms/tests/unit/views/garden-web-layout-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleFor = __dependency1__.moduleFor;
    moduleFor('view:garden-web-layout', 'GardenWebLayoutView');

    test('it exists', function() {
      var view;
      view = this.subject();
      return ok(view);
    });
  });
define("cms/tests/unit/views/garden-web-theme-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleFor = __dependency1__.moduleFor;
    moduleFor('view:garden-web-theme', 'GardenWebThemeView');

    test('it exists', function() {
      var view;
      view = this.subject();
      return ok(view);
    });
  });
define("cms/tests/unit/views/garden-widget-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleFor = __dependency1__.moduleFor;
    moduleFor('view:garden-widget', 'GardenWidgetView');

    test('it exists', function() {
      var view;
      view = this.subject();
      return ok(view);
    });
  });
define("cms/tests/unit/views/garden-widgets-toggle-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleFor = __dependency1__.moduleFor;
    moduleFor('view:garden-widgets-toggle', 'GardenWidgetsToggleView');

    test('it exists', function() {
      var view;
      view = this.subject();
      return ok(view);
    });
  });
define("cms/tests/unit/views/iframe-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleFor = __dependency1__.moduleFor;
    moduleFor('view:iframe', 'IframeView');

    test('it exists', function() {
      var view;
      view = this.subject();
      return ok(view);
    });
  });
define("cms/tests/unit/views/new-page-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleFor = __dependency1__.moduleFor;
    moduleFor('view:new-page', 'NewPageView');

    test('it exists', function() {
      var view;
      view = this.subject();
      return ok(view);
    });
  });
define("cms/tests/unit/views/thumnail-scroller-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleFor = __dependency1__.moduleFor;
    moduleFor('view:thumnail-scroller', 'ThumnailScrollerView');

    test('it exists', function() {
      var view;
      view = this.subject();
      return ok(view);
    });
  });
define("cms/tests/unit/views/toggle-btn-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleFor = __dependency1__.moduleFor;
    moduleFor('view:toggle-btn', 'ToggleBtnView');

    test('it exists', function() {
      var view;
      view = this.subject();
      return ok(view);
    });
  });
define("cms/tests/unit/views/toggle-panel-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleFor = __dependency1__.moduleFor;
    moduleFor('view:toggle-panel', 'TogglePanelView');

    test('it exists', function() {
      var view;
      view = this.subject();
      return ok(view);
    });
  });
define("cms/tests/unit/views/validate-empty-form-field-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleFor = __dependency1__.moduleFor;
    moduleFor('view:validate-empty-form-field', 'ValidateEmptyFormFieldView');

    test('it exists', function() {
      var view;
      view = this.subject();
      return ok(view);
    });
  });
define("cms/tests/unit/views/website-web-page-template-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleFor = __dependency1__.moduleFor;
    moduleFor('view:website-web-page-template', 'WebsiteWebPageTemplateView');

    test('it exists', function() {
      var view;
      view = this.subject();
      return ok(view);
    });
  });
define("cms/tests/unit/views/website-web-page-templates-empty-trash-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleFor = __dependency1__.moduleFor;
    moduleFor('view:website-web-page-templates-empty-trash', 'WebsiteWebPageTemplatesEmptyTrashView');

    test('it exists', function() {
      var view;
      view = this.subject();
      return ok(view);
    });
  });
define("cms/tests/unit/views/website-web-page-templates-in-trash-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleFor = __dependency1__.moduleFor;
    moduleFor('view:website-web-page-templates-in-trash', 'WebsiteWebPageTemplatesInTrashView');

    test('it exists', function() {
      var view;
      view = this.subject();
      return ok(view);
    });
  });
define("cms/tests/unit/views/website-web-page-templates-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleFor = __dependency1__.moduleFor;
    moduleFor('view:website-web-page-templates', 'WebsiteWebPageTemplatesView');

    test('it exists', function() {
      var view;
      view = this.subject();
      return ok(view);
    });
  });
define("cms/tests/unit/views/widget-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleFor = __dependency1__.moduleFor;
    moduleFor('view:widget', 'WidgetView');

    test('it exists', function() {
      var view;
      view = this.subject();
      return ok(view);
    });
  });
define("cms/tests/unit/views/widgets-add-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleFor = __dependency1__.moduleFor;
    moduleFor('view:widgets-add', 'WidgetsAddView');

    test('it exists', function() {
      var view;
      view = this.subject();
      return ok(view);
    });
  });
define("cms/tests/unit/views/widgets-list-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleFor = __dependency1__.moduleFor;
    moduleFor('view:widgets-list', 'WidgetsListView');

    test('it exists', function() {
      var view;
      view = this.subject();
      return ok(view);
    });
  });
define("cms/tests/unit/views/widgets-remove-test", 
  ["ember-qunit"],
  function(__dependency1__) {
    "use strict";
    var test = __dependency1__.test;
    var moduleFor = __dependency1__.moduleFor;
    moduleFor('view:widgets-remove', 'WidgetsRemoveView');

    test('it exists', function() {
      var view;
      view = this.subject();
      return ok(view);
    });
  });
define("cms/views/asset-save", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    var AssetSaveView;

    AssetSaveView = Ember.View.extend({
      click: function(e) {
        var target;
        target = $(e.target);
        target.html('  <i class="fa fa-refresh fa-spin">  ');
        return setTimeout((function() {
          target.html("Save");
        }), 500);
      }
    });

    __exports__["default"] = AssetSaveView;
  });
define("cms/views/card-action", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    var CardActionView;

    CardActionView = Ember.View.extend({
      tagName: "span",
      click: function(e) {
        var allInputs, cancelBtn, inputsAreEmpty, invalidForm, saveBtn;
        saveBtn = $(e.currentTarget).find(".save");
        cancelBtn = $(e.currentTarget).find(".cancel-link");
        allInputs = $(e.currentTarget).parents("form").find("input[type=text]");
        inputsAreEmpty = function() {
          allInputs.each(function() {
            if ($(this).val().trim().length === 0) {
              $(this).addClass("error");
              return true;
            }
          });
          return false;
        };
        invalidForm = function() {
          if (inputsAreEmpty()) {
            return true;
          }
        };
        if (invalidForm()) {
          saveBtn.prop("disabled", true);
          return false;
        } else {
          allInputs.removeClass("error");
          return $(e.currentTarget).parents(".flip-container").toggleClass("flipped");
        }
      }
    });

    __exports__["default"] = CardActionView;
  });
define("cms/views/card-flipper", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    var CardFlipperView;

    CardFlipperView = Ember.View.extend({
      tagName: "a",
      classNames: ["card-corner", "card-flip"],
      attributeBindings: ['href'],
      href: '#',
      title: "Page Settings",
      click: function(e) {
        var saveBtn, toggleBtn;
        toggleBtn = $(e.currentTarget);
        saveBtn = toggleBtn.parents(".card").find(".save");
        toggleBtn.parents(".flip-container").toggleClass("flipped");
        saveBtn.prop("disabled", false);
        return false;
      }
    });

    __exports__["default"] = CardFlipperView;
  });
define("cms/views/checkbox", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    var CheckboxView;

    CheckboxView = Ember.Checkbox.extend({
      change: function() {
        return this.get("content").save();
      }
    });

    __exports__["default"] = CheckboxView;
  });
define("cms/views/color-field", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    var ColorFieldView;

    ColorFieldView = Ember.TextField.extend({
      type: "color",
      change: function() {
        return this.get("content").save();
      }
    });

    __exports__["default"] = ColorFieldView;
  });
define("cms/views/color-picker", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    var ColorPickerView;

    ColorPickerView = Ember.View.extend({
      tagName: "form",
      didInsertElement: function() {
        return $("input.color").spectrum({
          preferredFormat: "hex",
          showInput: true
        });
      },
      primaryColorDidChange: (function() {
        return Ember.run.next(this, function() {
          return $("input.color").spectrum({
            preferredFormat: "hex",
            showInput: true
          });
        });
      }).observes("controller.primaryColor")
    });

    __exports__["default"] = ColorPickerView;
  });
define("cms/views/font-field", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    var FontFieldView;

    FontFieldView = Ember.TextField.extend({
      type: "text",
      change: function() {
        return this.get("content").save();
      }
    });

    __exports__["default"] = FontFieldView;
  });
define("cms/views/font-picker", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    var FontPickerView;

    FontPickerView = Ember.View.extend({
      tagName: "form"
    });

    __exports__["default"] = FontPickerView;
  });
define("cms/views/garden-web-layout", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    var GardenWebLayoutView;

    GardenWebLayoutView = Ember.View.extend({
      tagName: "span",
      classNameBindings: ['layoutRelevance'],
      isSelected: (function() {
        return this.get("controller.selectedLayout.name") === this.get("content.name");
      }).property("controller.selectedLayout.name"),
      layoutRelevance: (function() {
        var layoutClass, relevantLayouts;
        relevantLayouts = this.get("controller.relevantLayouts");
        if (relevantLayouts.indexOf(this.get("content.name")) > -1) {
          return layoutClass = "used-layout";
        } else {
          return layoutClass = "unused-layout";
        }
      }).property("controller.gardenWebLayout.model")
    });

    __exports__["default"] = GardenWebLayoutView;
  });
define("cms/views/garden-web-theme", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    var GardenWebThemeView;

    GardenWebThemeView = Ember.View.extend({
      tagName: "span",
      classNameBindings: ['themeRelevance'],
      isSelected: (function() {
        return this.get("controller.selectedTheme.name") === this.get("content.name");
      }).property("controller.selectedTheme.name"),
      themeRelevance: (function() {
        var relevantThemes, themeClass;
        relevantThemes = this.get("controller.relevantThemes");
        if (relevantThemes.indexOf(this.get("content.name")) > -1) {
          return themeClass = "used-theme";
        } else {
          return themeClass = "unused-theme";
        }
      }).property("controller.gardenWebTheme.model")
    });

    __exports__["default"] = GardenWebThemeView;
  });
define("cms/views/garden-widget", 
  ["ember","cms/mixins/jq-draggable","exports"],
  function(__dependency1__, __dependency2__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    var JqDraggableMixin = __dependency2__["default"];
    var GardenWidgetView;

    GardenWidgetView = Ember.View.extend(JqDraggableMixin, {
      tagName: "li",
      classNames: ["thumb", "widget", "new-widget"],
      classNameBindings: ["dasherizedName", "widgetType"],
      templateName: "website/widget",
      revert: true,
      zIndex: 1000,
      dasherizedName: (function() {
        var name;
        name = this.get("content.name");
        if (name) {
          return name.dasherize();
        }
      }).property("content.name"),
      widgetType: (function() {
        var type;
        type = this.get("content.widget_type");
        if (type) {
          return "" + (type.dasherize()) + "-feature";
        }
      }).property(),
      start: function(event, ui) {
        return this.set("content.isDragging", true);
      },
      stop: function(event, ui) {
        return this.set("content.isDragging", false);
      }
    });

    __exports__["default"] = GardenWidgetView;
  });
define("cms/views/garden-widgets-toggle", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    var GardenWidgetsToggleView;

    GardenWidgetsToggleView = Ember.View.extend({
      tagName: "a",
      classNames: ["toggle-widget-view", "btn", "btn--small"],
      attributeBindings: ['href'],
      href: '#',
      click: function(e) {
        var toggleBtn, widgetViews;
        toggleBtn = $(e.currentTarget);
        widgetViews = $('.widget-view');
        toggleBtn.find('.toggle-widget-text').toggle();
        widgetViews.toggleClass("visuallyhidden");
        return false;
      }
    });

    __exports__["default"] = GardenWidgetsToggleView;
  });
define("cms/views/iframe", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    var IframeView;

    IframeView = Ember.View.extend({
      tagName: "iframe",
      attributeBindings: ["src"],
      didInsertElement: function() {
        return this.set("src", this.get("content.model.previewUrl"));
      }
    });

    __exports__["default"] = IframeView;
  });
define("cms/views/new-page", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    var NewPageView;

    NewPageView = Ember.View.extend({
      click: function() {
        var btnHeight, newPageBtn, target, targetHeight;
        newPageBtn = $('.new-page-btn');
        btnHeight = newPageBtn.outerHeight();
        target = $('.card:last-of-type');
        targetHeight = $('.card:last-of-type').outerHeight();
        $("html, body").animate({
          scrollTop: target.offset().top - newPageBtn.offset().top + targetHeight + btnHeight
        });
        return target.find('.ember-text-field').first().focus();
      }
    });

    __exports__["default"] = NewPageView;
  });
define("cms/views/thumnail-scroller", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    var ThumnailScrollerView;

    ThumnailScrollerView = Ember.View.extend({
      tagName: "div",
      classNames: ["jThumbnailScroller"],
      didInsertElement: function() {
        return this.$().mThumbnailScroller({
          scrollerType: "clickButtons",
          scrollerOrientation: "horizontal",
          scrollEasing: "easeOutCirc",
          scrollEasingAmount: 600,
          acceleration: 4,
          scrollSpeed: 800,
          noScrollCenterSpace: 10,
          autoScrolling: 0,
          autoScrollingSpeed: 2000,
          autoScrollingEasing: "easeInOutQuad",
          autoScrollingDelay: 500
        });
      }
    });

    __exports__["default"] = ThumnailScrollerView;
  });
define("cms/views/toggle-btn", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    var ToggleBtnView;

    ToggleBtnView = Ember.View.extend({
      didInsertElement: function() {
        return this.$().find('.switch').bootstrapSwitch();
      }
    });

    __exports__["default"] = ToggleBtnView;
  });
define("cms/views/toggle-panel", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    var TogglePanelView;

    TogglePanelView = Ember.View.extend({
      tagName: "a",
      classNames: ["btn--toggle", "toggle-1"],
      attributeBindings: ['href'],
      href: '#',
      click: function(e) {
        var toggleBtn, toggleBtns;
        toggleBtn = $(e.currentTarget);
        toggleBtns = $('.btn--toggle');
        toggleBtns.each(function(i) {
          if (toggleBtn.is($(this)) && i !== 0) {
            if (toggleBtn.hasClass('toggle-closed')) {
              toggleBtn.removeClass('toggle-closed');
              $(toggleBtns[i - 1]).removeClass('toggle-2 toggle-3').addClass('toggle-1');
              if ($(toggleBtns[i - 2]).hasClass('toggle-3')) {
                return $(toggleBtns[i - 2]).removeClass('toggle-3').addClass('toggle-2');
              }
            } else {
              toggleBtn.addClass('toggle-closed');
              $(toggleBtns[i - 1]).removeClass('toggle-1').addClass('toggle-2');
              if (toggleBtn.hasClass('toggle-2')) {
                $(toggleBtns[i - 1]).removeClass('toggle-2').addClass('toggle-3');
              }
              if ($(toggleBtns[i - 2]).hasClass('toggle-2')) {
                return $(toggleBtns[i - 2]).removeClass('toggle-2').addClass('toggle-3');
              }
            }
          }
        });
        toggleBtn.find('.toggle-panel-text').toggle();
        toggleBtn.siblings('.toggle-content').slideToggle();
        return false;
      },
      didInsertElement: function() {
        return $("#" + this.elementId).trigger("click");
      }
    });

    __exports__["default"] = TogglePanelView;
  });
define("cms/views/validate-empty-form-field", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    var ValidateEmptyFormFieldView;

    ValidateEmptyFormFieldView = Ember.View.extend({
      classNames: ["form-field"],
      keyUp: function(e) {
        var allInputs, input, saveBtn, updateCurrentInput, updateEmptyInputs, validateForm;
        input = $(e.currentTarget).find("input");
        allInputs = $(e.currentTarget).parents("form").find("input[type=text]");
        saveBtn = $(e.currentTarget).parents("form").find(".save");
        updateCurrentInput = function() {
          if (input.val().trim().length === 0) {
            input.addClass("error");
            return saveBtn.prop("disabled", true);
          } else {
            input.removeClass("error");
            return validateForm();
          }
        };
        updateEmptyInputs = function() {
          allInputs.each(function() {
            if ($(this).val().trim().length === 0) {
              return $(this).addClass("error");
            }
          });
          return false;
        };
        validateForm = function() {
          updateEmptyInputs();
          if (allInputs.hasClass("error")) {
            return false;
          } else {
            return saveBtn.prop("disabled", false);
          }
        };
        return updateCurrentInput();
      }
    });

    __exports__["default"] = ValidateEmptyFormFieldView;
  });
define("cms/views/website-web-page-template", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    var WebsiteWebPageTemplateView;

    WebsiteWebPageTemplateView = Ember.View.extend({
      tagName: "div",
      classNames: ["card", "flip-container", "web-page-template"],
      attributeBindings: ["id:data-id"],
      templateName: "website/webPageTemplate",
      id: (function() {
        var id;
        return id = this.get("content.id");
      }).property("content.id")
    });

    __exports__["default"] = WebsiteWebPageTemplateView;
  });
define("cms/views/website-web-page-templates-empty-trash", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    var WebsiteWebPageTemplatesEmptyTrashView;

    WebsiteWebPageTemplatesEmptyTrashView = Ember.View.extend({
      classNames: ["empty-trash", "lightbox", "lightbox-overlay"],
      classNameBindings: ["isHidden:hidden"],
      isHidden: (function() {
        return !this.get("controller.confirmEmptyTrash");
      }).property("controller.confirmEmptyTrash")
    });

    __exports__["default"] = WebsiteWebPageTemplatesEmptyTrashView;
  });
define("cms/views/website-web-page-templates-in-trash", 
  ["ember","cms/mixins/jq-sortable","exports"],
  function(__dependency1__, __dependency2__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    var JqSortableMixin = __dependency2__["default"];
    var WebsiteWebPageTemplatesInTrashView;

    WebsiteWebPageTemplatesInTrashView = Ember.View.extend(JqSortableMixin, {
      classNames: ["web-page-templates-in-trash", "ui-sortable-connected"],
      connectWith: ".ui-sortable-connected",
      revert: true,
      remove: function(event, ui) {
        var droppedView, droppedViewId;
        if ((ui != null) && (ui.item != null)) {
          droppedViewId = ui.item.attr("id");
          droppedView = Ember.View.views[droppedViewId];
          droppedView.content.set("inTrash", false);
          return droppedView.content.save();
        }
      }
    });

    __exports__["default"] = WebsiteWebPageTemplatesInTrashView;
  });
define("cms/views/website-web-page-templates", 
  ["ember","cms/mixins/jq-sortable","exports"],
  function(__dependency1__, __dependency2__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    var JqSortableMixin = __dependency2__["default"];
    var WebsiteWebPageTemplatesView;

    WebsiteWebPageTemplatesView = Ember.View.extend(JqSortableMixin, {
      classNames: ["web-page-templates", "ui-sortable-connected"],
      connectWith: ".ui-sortable-connected",
      revert: true,
      update: function(event, ui) {
        var indexes;
        indexes = {};
        this.$(".web-page-template").each(function(index) {
          return indexes[$(this).data("id")] = index;
        });
        return this.get("controller").updateSortOrder(indexes);
      },
      remove: function(event, ui) {
        var droppedView, droppedViewId;
        if ((ui != null) && (ui.item != null)) {
          droppedViewId = ui.item.attr("id");
          droppedView = Ember.View.views[droppedViewId];
          return droppedView.content.set("inTrash", true);
        }
      }
    });

    __exports__["default"] = WebsiteWebPageTemplatesView;
  });
define("cms/views/website/widget", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    var WidgetView;

    WidgetView = Ember.View.extend({
      tagName: "li",
      classNames: ["thumb", "widget", "existing-widget"],
      classNameBindings: ["dasherizedName", "widgetType"],
      attributeBindings: ["id:data-id"],
      templateName: "_widget",
      dasherizedName: (function() {
        var name;
        name = this.get("content.name");
        if (name) {
          return name.dasherize();
        }
      }).property("content.name"),
      id: (function() {
        var id;
        return id = this.get("content.id");
      }).property("content.id"),
      widgetType: (function() {
        var type;
        type = this.get("content.widget_type");
        if (type) {
          return "" + (type.dasherize()) + "-feature";
        }
      }).property(),
      click: function(event) {
        if (this.get("content.id")) {
          this.set("controller.controllers.website.selectedWidgetName", this.get("content.name"));
          this.getEditForm();
        }
        return false;
      },
      getEditForm: function() {
        var callback;
        callback = (function(_this) {
          return function(response) {
            return _this.openModal(response);
          };
        })(this);
        return $.get(this.editURL(), {}, callback, "json");
      },
      openModal: function(response) {
        $('#modal .modal-body').html(response["html"]);
        if ($('#ckeditor').length >= 1) {
          CKEDITOR.replace('ckeditor');
        }
        $('#modal').modal();
        $('.modal-body .edit_widget').submit((function(_this) {
          return function() {
            if ($('#ckeditor').length >= 1) {
              $('#ckeditor').val(CKEDITOR.instances.ckeditor.getData());
            }
            _this.saveEditForm();
            return false;
          };
        })(this));
        return false;
      },
      editURL: function() {
        return '/widgets/' + this.get("content.id") + "/edit";
      },
      saveEditForm: function() {
        return $.ajax({
          url: $('.modal-body .edit_widget').prop('action'),
          type: 'PUT',
          dataType: 'json',
          data: $('.modal-body .edit_widget').serialize(),
          success: (function(_this) {
            return function() {
              var url;
              $('#modal').modal('hide');
              url = $('.preview iframe').prop('src');
              return $('iframe').prop('src', url);
            };
          })(this),
          error: (function(_this) {
            return function(xhr) {
              if (xhr.status === 204) {
                return $('#modal').modal('hide');
              } else if (xhr.responseText.length) {
                return _this.insertErrorMessages($.parseJSON(xhr.responseText));
              } else {
                return _this.insertErrorMessages({
                  errors: {
                    base: ["There was a problem saving the widget"]
                  }
                });
              }
            };
          })(this)
        });
      },
      insertErrorMessages: function(errors) {
        var error;
        error = "<div class=\"alert alert-error\">" + errors["errors"]["base"][0] + "</div>";
        return $('#modal .modal-body').prepend(error);
      }
    });

    __exports__["default"] = WidgetView;
  });
define("cms/views/widget", 
  ["ember","exports"],
  function(__dependency1__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    var WidgetView;

    WidgetView = Ember.View.extend({
      tagName: "li",
      classNames: ["thumb", "widget", "existing-widget"],
      classNameBindings: ["dasherizedName", "widgetType"],
      attributeBindings: ["id:data-id"],
      templateName: "website/widget",
      dasherizedName: (function() {
        var name;
        name = this.get("content.name");
        if (name) {
          return name.dasherize();
        }
      }).property("content.name"),
      id: (function() {
        var id;
        return id = this.get("content.id");
      }).property("content.id"),
      widgetType: (function() {
        var type;
        type = this.get("content.widget_type");
        if (type) {
          return "" + (type.dasherize()) + "-feature";
        }
      }).property(),
      click: function(event) {
        if (this.get("content.id")) {
          this.set("controller.controllers.website.selectedWidgetName", this.get("content.name"));
          this.getEditForm();
        }
        return false;
      },
      getEditForm: function() {
        var callback;
        callback = (function(_this) {
          return function(response) {
            return _this.openModal(response);
          };
        })(this);
        return $.get(this.editURL(), {}, callback, "json");
      },
      openModal: function(response) {
        $('#modal .modal-body').html(response["html"]);
        if ($('#ckeditor').length >= 1) {
          CKEDITOR.replace('ckeditor');
        }
        $('#modal').modal();
        $('.modal-body .edit_widget').submit((function(_this) {
          return function() {
            if ($('#ckeditor').length >= 1) {
              $('#ckeditor').val(CKEDITOR.instances.ckeditor.getData());
            }
            _this.saveEditForm();
            return false;
          };
        })(this));
        return false;
      },
      editURL: function() {
        return '/widgets/' + this.get("content.id") + "/edit";
      },
      saveEditForm: function() {
        return $.ajax({
          url: $('.modal-body .edit_widget').prop('action'),
          type: 'PUT',
          dataType: 'json',
          data: $('.modal-body .edit_widget').serialize(),
          success: (function(_this) {
            return function() {
              var url;
              $('#modal').modal('hide');
              url = $('.preview iframe').prop('src');
              return $('iframe').prop('src', url);
            };
          })(this),
          error: (function(_this) {
            return function(xhr) {
              if (xhr.status === 204) {
                return $('#modal').modal('hide');
              } else if (xhr.responseText.length) {
                return _this.insertErrorMessages($.parseJSON(xhr.responseText));
              } else {
                return _this.insertErrorMessages({
                  errors: {
                    base: ["There was a problem saving the widget"]
                  }
                });
              }
            };
          })(this)
        });
      },
      insertErrorMessages: function(errors) {
        var error;
        error = "<div class=\"alert alert-error\">" + errors["errors"]["base"][0] + "</div>";
        return $('#modal .modal-body').prepend(error);
      }
    });

    __exports__["default"] = WidgetView;
  });
define("cms/views/widgets-add", 
  ["ember","cms/mixins/jq-droppable","exports"],
  function(__dependency1__, __dependency2__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    var JqDroppableMixin = __dependency2__["default"];
    var WidgetsAddView;

    WidgetsAddView = Ember.View.extend(JqDroppableMixin, {
      tagName: "span",
      classNames: ["drop-target drop-target-add"],
      classNameBindings: ["dropTargetActive"],
      templateName: ["widgets_add"],
      accept: ".new-widget",
      activeClass: "drop-target-active",
      tolerance: "pointer",
      hoverClass: "hovering",
      drop: function(event, ui) {
        var droppedView, droppedViewId, gardenWidgetId;
        if (ui == null) {
          return;
        }
        droppedViewId = ui.draggable.attr("id");
        droppedView = Ember.View.views[droppedViewId];
        gardenWidgetId = droppedView.content.get("id");
        return this.get("content").createRecord({
          gardenWidgetId: gardenWidgetId
        }).save();
      }
    });

    __exports__["default"] = WidgetsAddView;
  });
define("cms/views/widgets-list", 
  ["ember","cms/mixins/jq-sortable","cms/views/widget","exports"],
  function(__dependency1__, __dependency2__, __dependency3__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    var JqSortableMixin = __dependency2__["default"];
    var WidgetView = __dependency3__["default"];
    var WidgetsListView;

    WidgetsListView = Ember.CollectionView.extend(JqSortableMixin, {
      tagName: "ul",
      classNames: ["add-widgets"],
      itemViewClass: WidgetView,
      revert: true,
      stop: function(event) {
        var indexes;
        indexes = {};
        this.$(".widget").each(function(index) {
          return indexes[$(this).data("id")] = index;
        });
        return this.get("controller").updateSortOrder(indexes);
      }
    });

    __exports__["default"] = WidgetsListView;
  });
define("cms/views/widgets-remove", 
  ["ember","cms/mixins/jq-droppable","exports"],
  function(__dependency1__, __dependency2__, __exports__) {
    "use strict";
    var Ember = __dependency1__["default"];
    var JqDroppableMixin = __dependency2__["default"];
    var WidgetsRemoveView;

    WidgetsRemoveView = Ember.View.extend(JqDroppableMixin, {
      tagName: "span",
      classNames: ["drop-target drop-target-remove"],
      classNameBindings: ["dropTargetActive"],
      templateName: ["widgets_remove"],
      accept: ".existing-widget",
      activeClass: "drop-target-active",
      tolerance: "pointer",
      hoverClass: "hovering",
      drop: function(event, ui) {
        var droppedView, droppedViewId, userConfirm;
        if (ui == null) {
          return;
        }
        userConfirm = confirm("You are about to delete this widget. Are you sure?");
        if (userConfirm) {
          droppedViewId = ui.draggable.attr("id");
          droppedView = Ember.View.views[droppedViewId];
          droppedView.get("content").one("didDelete", ui, function() {
            return this.draggable.remove();
          });
          return droppedView.set("content.isRemoved", true);
        }
      }
    });

    __exports__["default"] = WidgetsRemoveView;
  });
/* jshint ignore:start */

define('cms/config/environment', ['ember'], function(Ember) {
  var prefix = 'cms';
/* jshint ignore:start */

try {
  var metaName = prefix + '/config/environment';
  var rawConfig = Ember['default'].$('meta[name="' + metaName + '"]').attr('content');
  var config = JSON.parse(unescape(rawConfig));

  return { 'default': config };
}
catch(err) {
  throw new Error('Could not read config from meta tag with name "' + metaName + '".');
}

/* jshint ignore:end */

});

if (runningTests) {
  require("cms/tests/test-helper");
} else {
  require("cms/app")["default"].create({"host":"http://localhost:3000"});
}

/* jshint ignore:end */
//# sourceMappingURL=cms.map