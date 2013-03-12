"use strict"

module.exports = (grunt) ->
  # Common options
  options =
    buildPath:  'lib'
    coffeePath: 'src'
    testPath:   'test'

  # Project configuration
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'

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
      client:
        files:
          'client.js': 'client.coffee'
      tests:
        expand:  yes
        src: options.testPath + '/**/*.coffee'
        ext: '.test.js'

    mochaTest:
      files: ["#{options.testPath}/**/*.test.js"]
    mochaTestConfig:
      options:
        reporter: 'spec'

    watch:
      gruntfile:
        files: 'Gruntfile.*'
        tasks: ['compile', 'test', 'browserify']
      sources:
        files: [options.coffeePath + '/**/*.coffee', 'index.coffee', 'client.coffee']
        tasks: ['compile', 'test', 'browserify']
      tests:
        files: [options.testPath + '**/*.coffee']
        tasks: ['coffee:tests', 'test']
      testStuff:
        files: [options.testPath + 'responses/*']
        tasks: ['test']

    clean:
      build: [
        "doc"
        "lib"
        "client"
        "index.js"
      ]
      garbage: [
        "client.js"
        "Gruntfile.js"
      ]
      src: "src/**/*.js"
      tests: "test/**/*.test.js"
      browserified: "coffee-mix.*"

    bgShell:
      run:
        cmd: 'node index.js'
        stdout: yes
        stderr: yes
        bg: no
        fail: no
        done: (err, stdout, stderr) ->
      codo:
        cmd: 'node_modules/.bin/codo'
        stdout: yes
        stderr: yes
        bg: no
        fail: yes
        done: (err, stdout, stderr) ->
      browserify:
        cmd: "node_modules/.bin/browserify client.js -o coffee-mix.<%= pkg.version %>.js"
        stdout: yes
        stderr: yes
        bg: no
        fail: yes

    copy:
      browserified:
        expand: yes
        src: 'coffee-mix.*'
        dest: 'client'

  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-coffeelint'
  grunt.loadNpmTasks 'grunt-mocha-test'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-bg-shell'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-notify'
  grunt.loadNpmTasks 'grunt-contrib-copy'

  # Browserification task.
  grunt.registerTask 'browserify', ['bgShell:browserify', 'copy:browserified', 'clean:browserified']

  # Build cleanup task
  grunt.registerTask 'cleanup', ['clean:garbage']

  # Documentation task.
  grunt.registerTask 'codo', ['bgShell:codo']

  # Test task.
  grunt.registerTask 'test', ['mochaTest', 'clean:tests']

  # Compile task.
  grunt.registerTask 'compile', ['coffeelint', 'coffee']

  # Default task.
  grunt.registerTask 'default', ['clean', 'compile', 'test', 'browserify', 'cleanup', 'codo']

  # Publishing task.
  grunt.registerTask 'publish', ['default']

  # Standalone execution task.
  grunt.registerTask 'run', ['clean', 'compile', 'bgShell:run']