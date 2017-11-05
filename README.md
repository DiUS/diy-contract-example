# DIY contract example

This repository demonstrates how to roll your own contract using the concepts of `consumer driven contracts` and test symmetry.

The key steps in performing consumer driven contract testing are:

1. Consumer specs are run using a mock provider. The interactions (inputs and expected outputs) are serialized in a contract file.
1. The contract file is used to replay the recorded calls against the provider, and to check that the actual outputs match the expected outputs. If they do, then we have proven that the real provider behaves the same way as the mock provider, and hence, the consumer and provider should work together correctly in real life.

The key to setting up a new contract to work out where in the call chain between the consumer and provider you can insert a mock that accepts arguments and returns a response that can be serialized to a file.

This example codebase demonstrates a contract between a `Zoo database client` and a `Zoo database`. The purpose of the `Zoo database client` is to retrieve an `Alligator` from the database. We show how the client and database respond in the scenario where the desired record is found, and when it is not found.

The provider object that will be mocked in this example is an instance of a `Sequel` database. The argument that the mock and real provider accept is a query string, and the result returned by both is an array of hashes.

The purpose of the consumer specs (where the contract is written) is to demonstrate that the client is making the correct query to the provider, and that it can correctly handle the expected results.

The purpose of the provider specs (where the contract is verified) is to ensure that the provider returns the expected results when the given query is run.

The contract consists of an `interactions` array. Each interaction contains a `query`, the expected `results` and a `state`. The `state` is a description that will allow the correct data to be set up on the provider before an interaction is replayed, so that the expected result can be returned.

## Usage

1. Install Ruby 2.2 or later
1. Run `gem install bundler`
1. Run `bundle install`
1. Run `bundle exec rake`. To run just the consumer specs that generate the contract, run `bundle exec contract:create`. To run just the provider specs that verify the contract, run `bundle exec contract:verify`

