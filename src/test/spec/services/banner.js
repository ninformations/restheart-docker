'use strict';

describe('Service: banner', function () {

  // load the service's module
  beforeEach(module('adminApp'));

  // instantiate service
  var banner;
  beforeEach(inject(function (_banner_) {
    banner = _banner_;
  }));

  it('should do something', function () {
    expect(!!banner).toBe(true);
  });

});
