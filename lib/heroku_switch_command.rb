=begin
  Copyright (c) 2009 Terence Lee.

  This file is part of Heroku Switch Command.

  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program.  If not, see <http://www.gnu.org/licenses/>.
=end

module Heroku::Command

  # switch which heroku app to use
  class Switch < BaseWithApp
    DEFAULT_HEROKU_REMOTE_NAME = "heroku"

    # switch APPNAME
    #
    # switch which heroku app to use (set it as the default heroku remote, to run commands against by default)
    #
    def index
      unless @args.size > 0
        raise(CommandFailed, "Need to specify heroku app to switch to")
      end

      git_repo = ::Git.open(Dir.pwd)
      git_repo.remotes.each do |remote|
        if remote.url.split(':').first == default_git_remote_host
          begin
            remote.remove
            # remove command isn't working for ruby-git 1.2.5
          rescue Git::GitExecuteError
            shell("git remote rm #{remote.name}") end
        end
      end

      remote_location = default_git_remote_path(@args.first)
      git_repo.add_remote(DEFAULT_HEROKU_REMOTE_NAME, remote_location)
      display("Switched heroku remote to #{git_repo.remote(DEFAULT_HEROKU_REMOTE_NAME).url}")
    end

    def default_git_remote_path(name)
      "#{default_git_remote_host}:#{name}.git"
    end

    def default_git_remote_host
      "git@#{heroku.host}"
    end
  end
end
