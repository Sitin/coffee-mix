module.exports = function (grunt) {
  "use strict";

  var options = {
    buildPath:  'lib',
    coffeePath: 'src',
    testPath:   'test'
  };

  // Project configuration
  grunt.initConfig({
    pkg:        '<json:package.json>',

    coffeelint: {
      main: {
        files: [options.coffeePath + '/**/*.coffee', './*.coffee'],
        options: {
          "max_line_length": {
            "level": "warn"
          }
        }
      }
    },

    coffee:     {
      main: {
        src:     [options.coffeePath + '/**/*.coffee'],
        dest:    options.buildPath,
        options: {
          bare:          false,
          preserve_dirs: true,
          base_path:     options.coffeePath
        }
      },

      index: {
        src:     ['./*.coffee'],
        options: {
          bare:          false
        }
      },

      tests: {
        src: [options.testPath + '/**/*.coffee']
      }
    },

    mochaTest: {
      files: [options.testPath + '/**/*.test.js']
    },
    mochaTestConfig: {
      options: {
        reporter: 'spec'
      }
    },

    lint:       {
      files: ['*.js', options.buildPath + '/**/*.js']
    },

    watch:      [
      {
        files: [options.coffeePath + '/**/*.coffee', './*.coffee'],
        tasks: 'default'
      }
    ],

    jshint:     {
      options: {
        curly:   true,
        eqeqeq:  true,
        immed:   true,
        latedef: true,
        newcap:  true,
        noarg:   true,
        sub:     true,
        undef:   true,
        boss:    true,
        eqnull:  true,
        node:    true,
        strict:  true
      },
      globals: {
        exports: true
      }
    },

    clean: {
      build: [
        "doc",
        "lib",
        "test/**/*.test.js",
        "index.js"
      ],
      tests: "test/**/*.test.js"
    },

    bgShell: {
      run: {
        cmd: 'node index.js',
        stdout: true,
        stderr: true,
        bg: false,
        fail: false,
        done: function(err, stdout, stderr) {}
      },
      codo: {
        cmd: 'node_modules/.bin/codo',
        stdout: true,
        stderr: true,
        bg: false,
        fail: false,
        done: function(err, stdout, stderr) {}
      }
    }
  });

  grunt.loadNpmTasks('grunt-coffee');
  grunt.loadNpmTasks('grunt-coffeelint');
  grunt.loadNpmTasks('grunt-mocha-test');
  grunt.loadNpmTasks('grunt-contrib-clean');
  grunt.loadNpmTasks('grunt-bg-shell');

  // Documentation task.
  grunt.registerTask('codo', 'bgShell:codo');

  // Test task.
  grunt.registerTask('test', 'mochaTest clean:tests');

  // Compile task.
  grunt.registerTask('compile', 'coffeelint coffee');

  // Default task.
  grunt.registerTask('default', 'clean compile test codo');

  // Publishing task.
  grunt.registerTask('publish', 'default');

  // Standalone execution task.
  grunt.registerTask('run', 'clean compile bgShell:run');

};