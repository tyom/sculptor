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

        Mousetrap.bind('f', function() {
          $scope.toggle();
          $scope.$apply();
        });

        $scope.toggle = function() {
          $scope.hidden = !$scope.hidden;
        };
      }
    };
  });
