module.exports = (grunt) ->
  'use strict'

  path = require 'path'

  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-mocha-test'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-istanbul'
  grunt.loadNpmTasks 'grunt-coffeelint'
  grunt.loadNpmTasks 'grunt-env'

  grunt.initConfig
    clean:
      dist:
        src: 'dist/js/*'

      test:
        src: 'test/compiled'

      coverage:
        src: ['coverage/instrument', 'coverage/src/']

    # use in a test to require either real or instrumented module.
    # example: module = require process.env.srcPath + '/lib/logger'
    env:
      test: # used in normal testing
        srcPath: path.join __dirname, 'src'

      coverage: #used for doing a coverage test run
        srcPath: path.join __dirname, 'coverage/instrument/coverage/src/'

    instrument: # istanbul-instrumenting for coverage
      files: 'coverage/src/**/*.js' # asumes coffee coverage has run
      options:
        lazy: true
        basePath: 'coverage/instrument'

    storeCoverage:
      options:
        dir: 'coverage/reports'

    makeReport:
      src: 'coverage/reports/**/*.json'
      options:
        type: 'lcov'
        dir: 'coverage/reports'
        print: 'dot'

    coffee:
      dist:
        expand: true
        flatten: false
        cwd: 'src/'
        src: '**/*.coffee'
        dest: 'dist/js/'
        ext: '.js'

      test:
        expand: true
        flatten: false
        cwd: 'test/'
        src: '**/*_test.coffee'
        dest: 'test/compiled/'
        ext: '.js'

      coverage:
        expand: true
        flatten: false
        cwd: 'src/'
        src: '**/*.coffee'
        dest: 'coverage/src/'
        ext: '.js'

    coffeelint:
      src:
        src: 'src/**/*.coffee'
        options:
          configFile: 'coffeeLint.json'

      test:
        src: 'test/**/*.coffee'
        options:
          configFile: 'coffeeLint.json'

    mochaTest:
      test:
        options:
          ui: 'bdd'
          reporter: 'spec'
          require: [ 'should', 'nock']
        expand: true
        src: 'test/compiled/**/*_test.js'

  grunt.registerTask 'test', ['coffeelint',
                              'clean:test',
                              'coffee:test',
                              'env:test',
                              'mochaTest',
                              'clean:test']

  grunt.registerTask 'build', ['coffeelint:src',
                                 'clean:dist',
                                 'coffee:dist']

  grunt.registerTask 'coverage', ['coffeelint',
                                  'clean:coverage',
                                  'clean:test',
                                  'coffee:coverage',
                                  'instrument',
                                  'env:coverage',
                                  'coffee:test',
                                  'mochaTest',
                                  'storeCoverage',
                                  'makeReport',
                                  'clean:coverage',
                                  'clean:test'
  ]
