define ['angular'], (angular)->
  class NgRegistered
    @type: undefined
    @deps: []

    @getName: () ->
      @name

    @getDependencies: () ->
      Array.prototype.concat @deps, @

    @register: (module)->
    # Should be called in every subclass
      module[@type] @getName(), @getDependencies()

  # module[type](dependencies)
  class NgRunner extends NgRegistered
    @register: ()->
      _module[@type] @getDependencies()

  # EXPORTS
  ng =
    Service: class NgService extends NgRegistered
      @type: 'service'

    # module.factory
    Factory: class NgFactory extends NgRegistered
      @type: 'factory'
#      @getName: () ->
#        @name.replace /^./, (firstChar)->
#          firstChar.toUpperCase()

    # module.controller
    Controller: class NgController extends NgRegistered
      @type: 'controller'

      @getDependencies: () ->
        Array.prototype.concat '$scope', @deps, @

    # module.config
    Config: class NgConfig extends NgRunner
      @type: 'config'

    # module.run
    Run: class NgRun extends NgRunner
      @type: 'run'

    module: (name, deps=[])->
      angular.module name, deps