'use strict';

/**
 * @ngdoc service
 * @name adminApp.authInterceptor
 * @description
 * # authInterceptor
 * Service in the adminApp.
 */
angular.module('adminApp')
  .service('authInterceptor', function ($q) {
    var service = this;

    service.responseError = function(response) {
      if (response.status == 401 || response.status == 403){
        window.location = "#/login";
      }
      return $q.reject(response);
    };
    return service;
  }).config(['$httpProvider', function($httpProvider) {
  $httpProvider.interceptors.push('authInterceptor');
}]);
