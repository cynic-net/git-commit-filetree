Gem::Specification.new do |s|
    s.name        = 'jekyll-release'
    s.version     = '0.0.1'
    s.summary     =
        'Release Jekyll-generated websites to a git branch in a single command.'
    s.description =
        "A Jekyll plugin that provides a 'release' command for jekyll that " +
        "commits the generated site to the 'gh-pages' branch of the git " +
        "repository. This makes it possible to commit the build without using "+
        "multiple checkouts or switching branches and moving files around."

    s.authors     = ['Nishant Rodrigues', 'Curt Sampson']
    s.email       = 'nishantjr@gmail.com'
    s.homepage    = 'http://github.com/cjs-cynic-net/git-commit-filetree'
    s.files       = ['lib/jekyll-release.rb']
    s.executables = ['git-commit-filetree']
end
