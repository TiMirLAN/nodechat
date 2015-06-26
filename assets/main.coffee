define [
  '/assets/utils/ng.js',
  '/assets/users.js',
  '/assets/rooms.js',
  'ui.router'
], (ng) ->
  module = ng.module 'Chat', [
    'Chat.Users',
    'Chat.Rooms',
    'ui.router'
  ]

  class Config extends ng.Config
    @deps = ['$stateProvider', '$urlRouterProvider']

    constructor: ($stateProvider, $urlRouterProvider) ->
      $urlRouterProvider.otherwise '/'

      $stateProvider
        .state 'index',
          url: '/'
          templateUrl: '/tpls/index.html'
    @register module


  #exports
  module.name