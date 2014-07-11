# Client Services Utility Class

## How does it work at a high level?

- `ClientServices` provides helper methods to expose service URNs & URLs
- Exposed to widget settings
- Added to the `ClientSerializer` to expose to the Ember app
- Added attrs for the service URNs & URLs to the `Client` model in the Ember app

## Where is it implemented?

- `app/lib/client_services.rb`
- `app/lib/website_seeder.rb`
- `app/serializers/client_serializer.rb`

## Ruby

```ruby
# Adds ClientServices methods as attrs on Client Serializer to feed to Ember App

class ClientSerializer < ActiveModel::Serializer
  embed :ids, include: true

  has_many :locations

  attributes  :id,
              :urn,
              :name,
              :url,
              :location_urns,
              :location_urls,
              :cms_urn,
              :cms_url,
              :cpns_urn,
              :cpns_url,
              :cpas_urn,
              :cpas_url,
              :cls_urn,
              :cls_url,
              :cxm_urn,
              :cxm_url

  def url
    client_services.client_url
  end

  def location_urns
    client_services.client_location_urns
  end

  def location_urls
    client_services.client_location_urls
  end

  ClientServices::SERVICES.each do |service|
    define_method("#{service}_urn") do
      client_services.send(:"#{service}_urn")
    end

    define_method("#{service}_url") do
      client_services.send(:"#{service}_url")
    end
  end

  private

  def client_services
    @client_services ||= ClientServices.new
  end
end
```

## Ember

```coffee
# Client Ember Model - Grabs the attrs from the Client Serializer
App.Client = DS.Model.extend
  locations:     DS.hasMany("Location")
  websites:      DS.hasMany("Website")
  urn:           DS.attr("string")
  name:          DS.attr("string")
  url:           DS.attr("string")
  location_urns: DS.attr("string")
  location_urls: DS.attr("string")
  cms_urn:       DS.attr("string")
  cms_url:       DS.attr("string")
  cpns_urn:      DS.attr("string")
  cpns_url:      DS.attr("string")
  cpas_urn:      DS.attr("string")
  cpas_url:      DS.attr("string")
  cls_urn:       DS.attr("string")
  cls_url:       DS.attr("string")
  cxm_urn:       DS.attr("string")
  cxm_url:       DS.attr("string")

App.ApplicationRoute = Ember.Route.extend
  setupController: (controller, model)->
    # setup client controller
    @controllerFor("client").set("model", App.Client.find(1))

App.ApplicationController = Ember.Controller.extend
  needs: ["client", "location", "website"]
```

```html
<header role="banner" class="banner">
  <h1 class="banner-title">
    <a href="/">
      <img class="banner-logo" src="<%= asset_path("logo.png") %>" alt="G5" /> Client Management System:
    </a>
    <a href="/">
      <strong class="banner-subtitle">{{controllers.client.name}}</strong>
    </a>
  </h1>
</header>
```
