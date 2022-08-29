# Joust
Joust is an interactive, fun, and useful website for groups of people to better enjoy the process of selecting one option among many. It succeeds in this goal by incorporating a bracket-style matchup of everyone’s options, breaking down a large decision into many smaller ones.

# Development
## Setup
To setup the codebase on your own computer, first clone the repository. Then run these commands to install dependencies and setup Vite:
```bash
bundle install
bundle exec vite install

npm install
```

## Making Changes
Start your postgresql database by running this command:
```bash
brew services start postgresql
```

Make sure to create the database if it isn't already with:
```bash
bin/rails db:create
bin/rails db:migrate
```

To test your code in Rails development server, run the following commands in separate shells:
```bash
rails s
bin/vite dev
redis-server start
```

To shut down the server, perform the following actions in each corresponding window:

Rails - `ctrl+C` in the Rails window

Vite - `ctrl+C` in the Vite window

Redis - `redis-cli shutdown` in any window that is not running redis
