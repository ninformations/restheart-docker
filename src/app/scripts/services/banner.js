'use strict';

/**
 * @ngdoc service
 * @name adminApp.banner
 * @description
 * # banner
 * Service in the adminApp.
 */
angular.module('adminApp')
  .service('banner', function ($http) {
    const baseUrl = '//'+window.location.hostname+':8080/banners/vlp';
    var service = {};
    service.getBanners = GetBanners;
    service.saveBanners = SaveBanners;
    service.saveNewBanners = SaveNewBanners;
    service.searchBanners = SearchBanners;
    service.deleteBanner = DeleteBanner;
    return service;

    function GetBanners(callback) {
      $http.get(baseUrl)
          .success(function (response) {
              response.success = true;
              callback(response);
          });
    }

    function SearchBanners(data, callback) {
      if(data.chain_id && data.chain_id['$regex'] == "") {
        delete data.chain_id;
      }

      if(data.area_id && data.area_id['$regex'] == "") {
        delete data.area_id;
      }

      if(angular.toJson(data) == "{}") {
        return GetBanners(callback);
      }

      $http.get(baseUrl+'/?filter='+angular.toJson(data)).then(function (response) {
        var data = response.data;
        data.success = true;
        callback(data);
      },function (response) {
        var data = response.data;
        data.success = false;
        callback(data);
      });
    }

    function SaveNewBanners(data, callback) {
      angular.forEach(data, function (elem) {
        if(elem.editable && elem.isnew) {
          delete elem.editable;
          delete elem.isnew;
          $http.post(baseUrl, angular.toJson(elem)).then(function (response) {
            response.success = true;
            callback(response);
          }, function (response) {
            response.success = false;
            callback(response);
          });
          }

      });
    }

    function DeleteBanner(elem, callback) {
      if(elem._id['$oid']) {
        $http.delete(baseUrl+ '/' + elem._id['$oid']).then(function (response) {
          response.success = true;
          callback(response);
        }, function (response) {
          response.success = false;
          callback(response);
        })
      }
    }

    function SaveBanners(data, callback) {
      angular.forEach(data, function (elem) {
        if(elem.editable && elem._id) {
          delete elem.editable;
          delete elem._etag;
            $http.patch(baseUrl+ '/' + elem._id['$oid'], angular.toJson(elem)).then(function (response) {
              response.success = true;
              callback(response);
            }, function (response) {
              response.success = false;
              callback(response);
            });
        }
      });
    }
    // AngularJS will instantiate a singleton by calling "new" on this function
  });
