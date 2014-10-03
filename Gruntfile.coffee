module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'

    clean: ['bower_components', 'vendor', 'webapp']

    bower:
      install:
        options:
          targetDir: 'vendor'
          install: true

    coffee:
      compile:
        files:
          'webapp/nodevox.js': 'src/back/nodevox.coffee'
          'webapp/routes/index.js' : 'src/back/routes/index.coffee'
          'webapp/public/js/nodevox.js': [
            'src/front/js/nodevox.coffee'
          ]
        options:
          bare: true
          join: true
          sourceMap: true

    coffeelint:
      app: ['src/**/*.coffee', 'test/**/*.coffee']
      options:
        arrow_spacing:
          level: 'warn'
        colon_assignment_spacing:
          spacing:
            left: 0
            right: 1
          level: 'warn'
        max_line_length:
          value: 120
          level: 'warn'
        no_implicit_braces:
          level: 'ignore'
        no_trailing_semicolons:
          level: 'error'
        missing_fat_arrows:
          level: 'warn'
        no_empty_param_list:
          level: 'warn'
        cyclomatic_complexity:
          value: 5
          level: 'warn'
        no_implicit_parens:
          level: 'ignore'
        space_operators:
          level: 'warn'

    concat:
      js:
        src: ['vendor/jquery/jquery.js',
              'vendor/bootstrap/bootstrap.js'
            ]
        dest: 'webapp/public/js/vendor.js'
      css:
        src: ['vendor/bootstrap/bootstrap.css',
              'vendor/font-awesome/css/font-awesome.css']
        dest: 'webapp/public/css/vendor.css'

    stylus:
      compile:
        files:
          'webapp/public/css/nodevox.css': ['src/front/css/nodevox.styl']

    env:
      mac:
        PHANTOMJS_BIN: 'node_modules/phantomjs/bin/phantomjs'
      dev:
        PHANTOMJS_BIN: 'node_modules/phantomjs/bin/phantomjs'

    copy:
      font:
        files: [expand: true, flatten: true, src: ['vendor/font-awesome/fonts/*', 'bower_components/bootstrap/dist/fonts/*'], dest: 'webapp/public/fonts']
      img:
        files: [expand: true, flatten: true, src: ['components/bootstrap/img/*.png', 'images/*.png'], dest: 'webapp/public/img']
      views:
        files: [ expand:true, flatten: true, filter:'isFile', src: ['src/front/views/**'], dest: 'webapp/views/']

    karma:
      'watch-unit':
        configFile: 'build/karma.conf.js'
        autoWatch: true
      unit:
        configFile: 'build/karma.conf.js'
        singleRun: true
        browsers: ['PhantomJS']

    watch:
      coffee:
        files: 'src/**/*.coffee'
        tasks: ['coffeelint', 'build']
      stylus:
        files: 'src/**/*.styl'
        tasks: ['build']

  grunt.loadNpmTasks 'grunt-bower-task'
  grunt.loadNpmTasks 'grunt-karma'
  grunt.loadNpmTasks 'grunt-env'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-stylus'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-coffeelint'

  grunt.registerTask 'build', ['coffee', 'stylus', 'concat', 'copy']
  grunt.registerTask 'test', ['env:mac', 'karma:unit']
  grunt.registerTask 'lint', ['coffeelint']

  grunt.registerTask 'default', ['clean', 'bower', 'build']
