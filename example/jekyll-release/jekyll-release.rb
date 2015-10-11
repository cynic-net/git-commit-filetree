class ReleaseCommand < Jekyll::Command
    class << self
        def init_with_program(prog)
            prog.command(:release) { |c|
                c.syntax "release"
                c.description 'Release current build to gh-pages branch.'
                c.action { |args, options|
                    build_options = options.dup
                    build_options['quiet'] = true
                    Jekyll::Commands::Build.process(build_options)
                    process(options)
                }
            }
        end

        def process(options)
            dest = configuration_from_options(options)['destination']
            system(Gem.bin_path('jekyll-release', 'git-commit-filetree'), 'gh-pages', dest) \
                || fail('git-commit-filetree failed.')
        end
    end
end
