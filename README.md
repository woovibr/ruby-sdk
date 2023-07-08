# OpenPix/Woovi Ruby SDK

Welcome to the Woovi Ruby SDK! This SDK provides convenient access to the Woovi REST API, allowing you to easily integrate Woovi's REST API into your Ruby applications.

## Documentation

Documentation for Woovi REST API can be found [here](https://developers.woovi.com/api).
RDoc documentation for classes included in the gem can be found [here]().

## Installation

To install this gem using Bundler, add this following line to your `Gemfile`.

```shell
gem 'openpix-ruby_sdk', '~> 0.1.0'
```

To manually install `openpix-ruby_sdk` via Rubygems simply:

```shell
gem install openpix-ruby_sdk -v 1.0.0
```

## Usage

Main class `openpix/ruby_sdk/client` is your entrypoint to the endpoints.

### Authenticating client

```ruby
require 'openpix/ruby_sdk'

# Your AppID from https://app.openpix.com/home/applications/tab/list
app_id = 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'

client = Openpix::RubySdk::Client.new(app_id)
```

### Using resources

`Openpix::RubySdk::Client` has access to all resources available through a accessor method with resource name in plural form
E.g: Charge -> client.charges (returns the charge resource class with all available methods)

```ruby
# Creating a Charge
client.charges.init_body(
  params: {
    correlation_id: 'my-correlation-id',
    value: 50000
  }
)
response = client.charges.save
response.success? # should yield true
response.resource_response # API response for this resource, example bellow \/
# {
#   "status" => "ACTIVE",
#   "value" => 100,
#   "comment" => "good",
#   "correlationID" => "9134e286-6f71-427a-bf00-241681624586",
#   ... and so on
# }

# Listing Charges
# Default skip is 0 and limit is 100
response = client.charges.fetch(skip: 0, limit: 100) # skip and limit are pagination params, https://developers.woovi.com/api#tag/charge/paths/~1api~1v1~1charge/get
response.pagination_meta # holds information about pagination, like total, hasNextPage and so on
response.resource_response # API response for this resource, should be an array

# If next or previous pages available, there is a convenience method to fetch next or previous pages
# In order to call those methods, you need first to call #fetch or #fetch! to set the pagination params
# Those methods will preserve any :params sent to #fetch or #fetch! method
# BE CAREFUL, those methods only have bang! versions because they have a strong dependency on #fetch, handle properly their errors
client.charges.fetch_next_page!
client.charges.fetch_previous_page!

# Finding Charge
response = client.charges.find(id: 'my-charge-id')
# response has same attributes from save, since it is a single resource response

# Destroying Charge
response = client.charges.destroy(id: 'my-charge-id')
response.success? # this operations just returns success
```

### Available resources

The available resources are:

- Charge (charges)
- Customer (customers)
- Payment (payments)
- Refund (refunds)
- Subscription (subscriptions)
- Webhook (webhooks)

### Handling errors

All available resource methods have their bang! version, which raises an error whenever something goes wrong so you can properly handle those cases
All errors have some helpful message, showing response status and error response from API

Error classes are:
**save!** -> `Openpix::RubySdk::Resources::RequestError`
**fetch!** -> `Openpix::RubySdk::Resources::RequestError`
**fetch_next_page!** -> `Openpix::RubySdk::Resources::RequestError`, `Openpix::RubySdk::Resources::NotFetchedError`, `Openpix::RubySdk::Resources::PageNotDefinedError`
**fetch_previous_page!** -> `Openpix::RubySdk::Resources::RequestError`, `Openpix::RubySdk::Resources::NotFetchedError`, `Openpix::RubySdk::Resources::PageNotDefinedError`
**find!** -> `Openpix::RubySdk::Resources::RequestError`
**destroy!** -> `Openpix::RubySdk::Resources::RequestError`

For the safe version (without bang!) there will be an `error_response` attribute setted in the API response whenever `success?` is false.

```ruby
response = client.customers.save

unless response.success?
  response.error_response # error response from API
end
```

## Contributing

If you have suggestions for how Woovi Ruby SDK could be improved, or want to report a bug, open an issue! We'd love all and any contributions.

For more, check out the [Contributing Guide](CONTRIBUTING.md).

## License

Woovi Ruby SDK is distributed under the terms of the [MIT license](LICENSE).
