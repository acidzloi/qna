# config valid for current version and patch releases of Capistrano
lock "~> 3.19.2"

set :application, "qna"
set :repo_url, "git@github.com:acidzloi/qna.git"
set :branch, 'main'

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/deployer/qna"
set :deploy_user, "deployer"

# Default value for :linked_files is []
append :linked_files, "config/database.yml", 'config/master.key'

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", "vendor/bundle", "storage"

set :rvm_ruby_version, 'ruby-3.2.4'

after 'deploy:publishing', 'unicorn:restart'
