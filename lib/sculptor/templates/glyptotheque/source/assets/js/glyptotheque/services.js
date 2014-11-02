angular.module('services', [])

  .factory('relativePathToRoot', function($window) {
    return function() {
      var pathToRoot = $window.location.pathname.replace(/\/$/, '').split('/').slice(1).map(function() {
        return '../';
      }).join('');
      return pathToRoot;
    };
  });
