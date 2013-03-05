"use strict"

module.exports = (grunt) ->
  # Common options
  options =
    buildPath:  'lib'
    coffeePath: 'src'
    testPath:   'test'

  # Project configuration
  grunt.initConfig
    pkg: '<json:package.json>'

    coffeelint:
      main:
        files:
          src: ["#{options.coffeePath}/**/*.coffee", './*.coffee']
        options:
          max_line_length:
            level: "warn"

    coffee:
      main:
        expand:  yes
        cwd:     options.coffeePath
        src:     '**/*.coffee'
        dest:    options.buildPath
        ext: '.js'
      index:
        files:
          'index.js': 'index.coffee'
      tests:
        expand:  yes
        src: options.testPath + '/**/*.coffee'
        ext: '.test.js'

    mochaTest:
      files: ["#{options.testPath}/**/*.test.js"]
    mochaTestConfig:
      options:
        reporter: 'spec'

    watch: [
      files: [options.coffeePath + '/**/*.coffee', './*.coffee']
      tasks: 'default'
    ]

    clean:
      build: [
        "doc"
        "lib"
        "test/**/*.test.js"
        "index.js"
      ]
      tests: "test/**/*.test.js"

    bgShell:
      run:
        cmd: 'node index.js'
        stdout: true
        stderr: true
        bg: false
        fail: false
        done: (err, stdout, stderr) ->
      codo:
        cmd: 'node_modules/.bin/codo'
        stdout: yes
        stderr: yes
        bg: no
        fail: no
        done: (err, stdout, stderr) ->

  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-coffeelint'
  grunt.loadNpmTasks 'grunt-mocha-test'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-bg-shell'

  # Documentation task.
  grunt.registerTask 'codo', ['bgShell:codo']

  # Test task.
  grunt.registerTask 'test', ['mochaTest', 'clean:tests']

  # Compile task.
  grunt.registerTask 'compile', ['coffeelint', 'coffee']

  # Default task.
  grunt.registerTask 'default', ['clean', 'compile', 'test', 'codo']

  # Publishing task.
  grunt.registerTask 'publish', ['default']

  # Standalone execution task.
  grunt.registerTask 'run', ['clean', 'compile', 'bgShell:run']