`import Ember from 'ember'`

JqBaseMixin = Ember.Mixin.create

  # When Ember creates the view's DOM element, it will call this
  # method.
  didInsertElement: ->

    # Make jQuery UI options available as Ember properties
    options = @_gatherOptions()

    # Make sure that jQuery UI events trigger methods on this view.
    @_gatherEvents options

    # Create a new instance of the jQuery UI widget based on its `uiType`
    # and the current element.
    ui = jQuery.ui[@get("uiType")](options, @get("element"))

    # Save off the instance of the jQuery UI widget as the `ui` property
    # on this Ember view.
    @set "ui", ui


  # When Ember tears down the view's DOM element, it will call
  # this method.
  willDestroyElement: ->
    ui = @get("ui")
    if ui

      # Tear down any observers that were created to make jQuery UI
      # options available as Ember properties.
      observers = @_observers
      for prop of observers
        @removeObserver prop, observers[prop]  if observers.hasOwnProperty(prop)
      ui._destroy()


  # Each jQuery UI widget has a series of options that can be configured.
  # For instance, to disable a button, you call
  # `button.options('disabled', true)` in jQuery UI. To make this compatible
  # with Ember bindings, any time the Ember property for a
  # given jQuery UI option changes, we update the jQuery UI widget.
  _gatherOptions: ->
    uiOptions = @get("uiOptions")
    options = {}

    # The view can specify a list of jQuery UI options that should be treated
    # as Ember properties.
    uiOptions.forEach ((key) ->
      options[key] = @get(key)

      # Set up an observer on the Ember property. When it changes,
      # call jQuery UI's `option` method to reflect the property onto
      # the jQuery UI widget.
      observer = ->
        value = @get(key)
        @get("ui").option key, value

      @addObserver key, observer

      # Insert the observer in a Hash so we can remove it later.
      @_observers = @_observers or {}
      @_observers[key] = observer
    ), @
    options


  # Each jQuery UI widget has a number of custom events that they can
  # trigger. For instance, the progressbar widget triggers a `complete`
  # event when the progress bar finishes. Make these events behave like
  # normal Ember events. For instance, a subclass of JQ.ProgressBarView
  # could implement the `complete` method to be notified when the jQuery
  # UI widget triggered the event.
  _gatherEvents: (options) ->
    uiEvents = @get("uiEvents") or []
    self = this
    # use fat arrow syntax instead of self
    uiEvents.forEach (event) ->
      callback = self[event]
      if callback

        # You can register a handler for a jQuery UI event by passing
        # it in along with the creation options. Update the options hash
        # to include any event callbacks.
        options[event] = (event, ui) ->
          callback.call self, event, ui

`export default JqBaseMixin`
