jitterbug = angular.module('jitterbug', ['ui.router']);

http_get = ($http, $scope, url, success) ->
  $http.get url
    .success success
    .error (data) ->
      $scope.error = data
      console.log data

jitterbug.config ['$stateProvider', '$urlRouterProvider',
  ($stateProvider, $urlRouterProvider) ->
    $urlRouterProvider.otherwise '/game'

    $stateProvider
      .state 'login',
        url:         '/login'
        templateUrl: 'templates/login.html'
        controller:  'LoginController'
      .state 'game',
        url:         '/game'
        templateUrl: 'templates/game.html'
        controller:  'GameController'
]

jitterbug.controller 'JitterbugMainController', [
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

jitterbug.controller 'LoginController', [
  '$scope', '$state', ($scope, $state) ->
    $state.go 'game' if $scope.login_state == 'logged-in'
]

jitterbug.controller 'GameController', [
  '$scope', '$state', ($scope, $state) ->
    $state.go 'login' unless $scope.login_state == 'logged-in'

    $scope.$on '$viewContentLoaded', ->
      $('#jitterbug_game'          ).html '<canvas id="jitterbug_game_canvas"        />'
      $('#jitterbug_progress_chart').html '<svg    id="jitterbug_progress_chart_svg" />'

      jitterbug_game 'jitterbug_game_canvas'
]
