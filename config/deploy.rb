set :application, "rread"

#github stuff
set :repository,  "git@github.com:iansilber/Newsie.git"
set :scm, :git

set :use_sudo,    false
set :deploy_to,   "/rails_apps/#{application}"

#server login
set :user, "app"
set :password, "Megaman1@"

ssh_options[:forward_agent] = true

# will be different entries for app, web, db if you host them on different servers
server "rread.co", :app, :web, :db, :primary => true

namespace :deploy do
  task :start, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end

  task :stop, :roles => :app do
    # Do nothing.
  end

  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end
end

desc "Tail the logs"
task :tail_logs do
  run "tail -f /rails_apps/rread/current/log/*"
end

desc "Get ram usage"
task :mem do
  run "vmstat -S M"
end