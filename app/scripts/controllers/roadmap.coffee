'use strict'

###*
 # @ngdoc function
 # @name topMapApp.controller:roadmapCtrl
 # @description
 # # RoadmapCtrl
 # Controller of the topMapApp
###
angular.module 'topMapApp'
  .controller 'RoadmapCtrl', ($scope, config, ogc) ->
    $scope.$on '$routeChangeSuccess', ($currentRoute, $previousRoute) ->
      footer = angular.element '#footer'
      footer.removeClass 'hidden'
    
    $scope.roadmap = [
      {
        'area': 'Download',
        'item': 'Basic data download facilities',
        'details': 'Basic download of the datasets through OGC web services - WCS for raster data, and WFS for vector data. The datasets will be filtered prior to download eg covering a specific geographic region or date range, to make the download file size manageable.',
        'progress': 'Specified',
        'iteration': 'Expected 1'
      },
      {
        'area': 'Mapper',
        'item': 'Draw polygon boundary',
        'details': 'Draw a polygon boundary on the map as a precursor to enabling filtering of datasets by geographic area.',
        'progress': 'None',
        'iteration': 'Not assessed'
      },
      {
        'area': 'Mapper',
        'item': 'Enable filtering of datasets by location and date range',
        'details': 'Draw a polygon boundary on the map as a precursor to enabling filtering of datasets by geographic area.',
        'progress': 'None',
        'iteration': 'Not assessed'
      },
      {
        'area': 'Mapper',
        'item': 'Cloud cover estimates',
        'details': 'Part 1 - A user will specify a geographic area of interest by drawing a polygon. The datasets overlapping with the specified area are highlighted to the user.\nPart 2 – The user specifies a date range of interest which updates the dataset list.\nPart 3 – The user selects the datasets of interest to view on the map',
        'progress': 'None',
        'iteration': 'Not assessed'
      },
      {
        'area': 'Download',
        'item': 'Preview data selected for download',
        'details': 'Prior to download, present the option for users to preview the data selected for download, to check for cloud cover for example.',
        'progress': 'None',
        'iteration': 'Not assessed'
      },
      {
        'area': 'Metadata',
        'item': 'Make dataset metadata available',
        'details': 'Metadata available by the datasets in the dataset list. Metadata available wherever datasets are named in the mapper.',
        'progress': 'None',
        'iteration': 'Not assessed'
      },
      {
        'area': 'Mapper',
        'item': 'Classify satellite data by date range',
        'details': 'Satellite data displayed using a colour scale, classified by date range.',
        'progress': 'None',
        'iteration': 'Not assessed'
      },
      {
        'area': 'Mapper',
        'item': 'Quick-look samples',
        'details': 'Quick-look samples to allow users to view a part of a dataset, rather than the whole, where datasets are very large and would take time to display. This could be in the form of a jpeg image. The sample could show the latest acquisitions for the dataset of interest.',
        'progress': 'None',
        'iteration': 'Not assessed'
      },
      {
        'area': 'Mapper',
        'item': 'Seasonality',
        'details': 'Seasonality for phenology information.',
        'progress': 'None',
        'iteration': 'Not assessed'
      },
      {
        'area': 'Administration',
        'item': 'Data use cases',
        'details': 'Gather information on use of data at the download stage, to network users to target further reduction in duplicated tasks and information sharing.',
        'progress': 'None',
        'iteration': 'Not assessed'
      },
      {
        'area': 'Mapper',
        'item': 'Visualisation of imagery data',
        'details': 'Landsat and satellite data to be displayed as greyscale rather than wireframe. Samples of the data should be available for visualisation.',
        'progress': 'None',
        'iteration': 'Not assessed'
      }
    ]
