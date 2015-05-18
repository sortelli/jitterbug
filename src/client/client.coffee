jachiSoro = angular.module('jachiSoro', []);

http_get = ($http, $scope, url, success) ->
  $http.get url
    .success success
    .error (data) ->
      $scope.error = data
      console.log data

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
