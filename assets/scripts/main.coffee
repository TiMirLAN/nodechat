define 'assets/scripts/main', [
  'angular',
  'assets/scripts/utils/ng.js',
  'assets/scripts/users.js',
  'assets/scripts/rooms.js',
  'ui.router'
], (angular, ng) ->
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
        .state 'room',
          url: '/:roomId/'
          controller:  'RoomCtrl'
          templateUrl: '/tpls/room.html'

    @register module

  #exports
  angular.bootstrap document.body, [module.name]