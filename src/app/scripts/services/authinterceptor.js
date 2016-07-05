'use strict';

/**
 * @ngdoc service
 * @name adminApp.authInterceptor
 * @description
 * # authInterceptor
 * Service in the adminApp.
 */
angular.module('adminApp')
  .service('authInterceptor', function ($q, $rootScope, $cookieStore) {
    var service = this;

    service.request = function(config) {
      var globals = $rootScope.globals || $cookieStore.get('globals');

      if(globals && globals.currentUser) {
        if(!$rootScope.globals) $rootScope.globals = globals;
        config.headers.Authorization = 'Basic ' + globals.currentUser.authdata;
      }

      return config;
    }

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
