jachiSoro = angular.module('jachiSoro', ['ui.router']);

http_get = ($http, $scope, url, success) ->
  $http.get url
    .success success
    .error (data) ->
      $scope.error = data
      console.log data

jachiSoro.config ['$stateProvider', '$urlRouterProvider',
  ($stateProvider, $urlRouterProvider) ->
    $urlRouterProvider.otherwise '/game'

    $stateProvider
      .state 'login',
        url:         '/login'
        templateUrl: 'templates/login.html'
      .state 'game',
        url:         '/game'
        templateUrl: 'templates/game.html'
        controller:  'GameController'
]

jachiSoro.controller 'JachiSoroMainController', [
  '$scope', '$http', ($scope, $http) ->
    $http.get '/api/session/user'
      .success (data) ->
        $scope.user        = data
        $scope.login_state = 'logged-in'
      .error (data) ->
        console.log data
        if data == "No active session"
          $scope.login_state = 'logged-out'
        else
          $scope.error       = data
          $scope.login_state = 'error'
]

jachiSoro.controller 'GameController', [
  '$scope', '$state', ($scope, $state) ->
    $state.go 'login' unless $scope.login_state == 'logged-in'
]
