'use strict';

/**
 * @ngdoc function
 * @name adminApp.controller:DashboardCtrl
 * @description
 * # DashboardCtrl
 * Controller of the adminApp
 */
angular.module('adminApp')
  .controller('DashboardCtrl', function (banner) {
    var self = this;
    self.banners = [];
    //self.filter = {
    //  "chain_id": {"$regex": ""},
    //  "area_id":  {"$regex": ""}
    //};

    self.awesomeThings = [
      'HTML5 Boilerplate',
      'AngularJS',
      'Karma'
    ];

    (function () {
      banner.getBanners(function(response) {
        self.banners = response._embedded["rh:doc"];
      });
    })();

    self.addNew = function() {
      self.hasNew = true;
      self.banners.push({"editable":true, "isnew": true});
    }

    self.search = function (filters) {
      banner.searchBanners(filters, function(response) {
        self.banners = response._embedded["rh:doc"];
      })
    }


    self.getSortClass = function (filters, findValue) {
      if(!filters || !filters.sort_by) return 'glyphicon-sort';
      switch (filters.sort_by) {
        case findValue:
              return 'glyphicon-sort-by-alphabet';
        case '-'+findValue:
              return 'glyphicon-sort-by-alphabet-alt';
        default:
              return 'glyphicon-sort';
      }
    }

    self.deleteBanner = function (item) {
      debugger;
    }

    self.removeBanner = function (index) {
      self.banners.splice(index, 1);
      var newBanners = self.banners.filter(function(elem) {
        if(elem.isnew) return true;
        return false;
      });

      if(newBanners.length == 0) {
        self.hasNew = false;
      }
    }
    self.saveBanner = function (key, item) {
      if(item) {
        banner.saveBanners(self.banners, function (response) {
        });
      }
    }

    self.deleteBanner = function (item) {
      if(item) {
        banner.deleteBanner(item, function (response) {
          if(response.success) {
            banner.getBanners(function(response) {
              self.banners = response._embedded["rh:doc"];
            });
          }
        })
      }
    }

    self.saveNewBanners = function (item) {
      debugger;
      banner.saveNewBanners(self.banners, function (response) {
        banner.getBanners(function(response) {
          self.banners = response._embedded["rh:doc"];
        });
      });
    }

  });
