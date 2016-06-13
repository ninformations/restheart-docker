'use strict';

/**
 * @ngdoc function
 * @name adminApp.controller:LoginCtrl
 * @description
 * # LoginCtrl
 * Controller of the adminApp
 */
 angular.module('adminApp')
 .controller('LoginCtrl', function ($location, Authentication) {
 	var self = this;
 	self.awesomeThings = [
 	'HTML5 Boilerplate',
 	'AngularJS',
 	'Karma'
 	];

 	self.login = function () {
 		self.dataLoading = true;
 		Authentication.Login(self.username, self.password, function (response) {
 			if (response.success) {
 				Authentication.SetCredentials(self.username, self.password);
 				$location.path('/');
 			} else {
 				alert(response.message);
 				//FlashService.Error(response.message);
 				//self.dataLoading = false;
 			}
 		});
 	};
 });
