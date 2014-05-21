angular.module('directives', [])
  .directive('glyptoModel', function($compile, $http, $templateCache) {
    return {
      restrict: 'C',
      scope: true
    };
  })
  .directive('navToggle', function() {
    return {
      restrict: 'C',
      link: function($scope, $element, $attrs) {
        $scope.hidden = false;
        var nav = $element.parent('nav');

        if(!nav.length) {
          return;
        }

        Mousetrap.bind('f', function() {
          $scope.toggle();
        });

        $scope.toggle = function() {
          $scope.hidden = !$scope.hidden;
          nav.toggleClass('m-hide', $scope.hidden);
        };
      }
    };
  });
