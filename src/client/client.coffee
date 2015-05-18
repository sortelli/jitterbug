jachiSoro = angular.module('jachiSoro', []);

http_get = ($http, $scope, url, success) ->
  $http.get url
    .success success
    .error (data) ->
      $scope.error = data
      console.log data

jachiSoro.controller 'JachiSoroMainController', ['$scope', '$http', ($scope, $http) ->
  http_get $http, $scope, '/api/session/user', (data) ->
    $scope.user = data
    console.log data
]
