module.exports = function(grunt) {

    grunt.initConfig({
        pkg: grunt.file.readJSON('package.json'),
        concat: {
            options: {
                separator: ';'
            },
            dist: {
                src: ['src/**/*.js'],
                dest: 'dist/<%= pkg.name %>.js'
            }
        },
        // Allow the use of non-minsafe AngularJS files. Automatically makes it
        // minsafe compatible so Uglify does not destroy the ng references
        ngmin: {
            dist: {
                files: [{
                    expand: true,
                    cwd: 'build/',
                    src: '*.js',
                    dest: './build'
                }]
            }
        },
        coffee: {
            compile: {
                expand: true,
                options: {
                    sourceMap: false
                },
                // flatten: true,
                cwd: 'build/',
                src: ['*.coffee'],
                dest: './build',
                ext: '.js'
            }
        },
        uglify: {
            options: {
                banner: '/*! <%= pkg.name %> <%= grunt.template.today("dd-mm-yyyy") %> */\n'
            },
            dist: {
                files: {
                    './build/<%= pkg.name %>.min.js': ['./build/<%= pkg.name %>.js']
                }
            }
        },
        jshint: {
            files: ['Gruntfile.js', 'src/**/*.js', 'test/**/*.js'],
            options: {
                // options here to override JSHint defaults
                globals: {
                    jQuery: true,
                    console: true,
                    module: true,
                    document: true
                }
            }
        },
        // Copies remaining files to places other tasks can use
        copy: {
            initial: {
                files: [{
                    expand: true,
                    cwd: 'src/',
                    dest: './build/',
                    src: [
                        '*'
                    ]
                }]
            },
            dist: {
                files: [{
                    expand: true,
                    cwd: 'build/',
                    dest: './dist',
                    src: [
                        '<%= pkg.name %>.js',
                        '<%= pkg.name %>.min.js'
                    ]
                }]
            },
            demo: {
                files: [{
                    expand: true,
                    cwd: 'build/',
                    dest: './demo',
                    src: [
                        '<%= pkg.name %>.js'
                    ]
                }]
            }
        },
        watch: {
            files: ['<%= jshint.files %>'],
            tasks: ['jshint', 'qunit']
        }
    });

    grunt.loadNpmTasks('grunt-contrib-uglify');
    grunt.loadNpmTasks('grunt-contrib-jshint');
    grunt.loadNpmTasks('grunt-contrib-watch');
    grunt.loadNpmTasks('grunt-contrib-concat');
    grunt.loadNpmTasks('grunt-contrib-coffee');
    grunt.loadNpmTasks('grunt-contrib-copy');
    grunt.loadNpmTasks('grunt-ngmin');

    grunt.registerTask('test', ['jshint']);

//    'jshint',
//    , 'coffee', 'ngmin', 'uglify', 'copy:dist', 'copy:demo'
    grunt.registerTask('default', ['copy:initial', 'coffee', 'ngmin', 'uglify', 'copy:dist', 'copy:demo']);

};