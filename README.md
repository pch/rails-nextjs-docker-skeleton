# Rails & Next.js Project Skeleton

This is the structure I use to work on my Rails & Next.js projects.

Backend and frontend are separated, but having everything in Docker allows to run the whole stack with a single command:

~~~ sh
docker-compose up
~~~

Gems and node_modules are stored in shared docker volumes.

## Rails Notes

Add `rails` host to `config/environments/development.rb`, or you won't be able to use `getServerSideProps`:

~~~ ruby
Rails.application.configure do
  # Needed for Next.js's getServerSideProps
  config.hosts << "rails"
end
~~~

If you're using rack-cors, you'll also need to allow the frontend app in `config/initializers/cors.rb`

### Running Commands

I use the script in `bin/d` to run rails commands, e.g.:

~~~ sh
bin/r rails db:migrate
bin/r rails test
~~~

## Next.js Notes

### Running Commands

~~~ sh
bin/n yarn add styled-components
~~~
