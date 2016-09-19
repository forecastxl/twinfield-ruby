# Installation

```ruby
gem 'twinfield-ruby'
```

# Usage

Create a configuration instance you can use in requests. The last argument is optional.

```ruby
config = Twinfield::Configuration.new(username, password, organisation, office)
```

The configuration can be used create a new Process.

```ruby
process = Twinfield::Process.new(config)
```

Or you can use it to create a new Session.

```ruby
session = Twinfield::Session.new(config)
```

With the Process you can execute requests.

```ruby
process.search(params)
process.request(action, params)

```

Or with the Session.

```ruby
session.service(:process).action(:search, params)
```
