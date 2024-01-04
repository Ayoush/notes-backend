# Notes
if you are getting error you like 

Failed to fetch record for phoenix_live_reload from registry (using cache instead)
Run following command
mix local.hex  and then run mix deps.get 
if it still doesn't work then you can try this option 
mix hex.config http_concurrency 1 && mix hex.config http_timeout 120
and then run 
mix deps.get
In mix.exs aliases you can modify to see what all things are running at the time of setup but remember it only takes unique command so if you are running a command which is already been ran then it will be simply ignored

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
