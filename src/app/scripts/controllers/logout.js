'use strict';

/**
 * @ngdoc function
 * @name adminApp.controller:LogoutCtrl
 * @description
 * # LogoutCtrl
 * Controller of the adminApp
 */
angular.module('adminApp')
  .controller('LogoutCtrl', function ($location, Authentication) {

    (function initController() {
      // reset login status
      Authentication.ClearCredentials();
    })();

    $location.path('/login');
  });
