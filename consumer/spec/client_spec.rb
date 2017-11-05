require 'json'

# Our domain model class for an Alligator
class Alligator
  attr_accessor :name, :age

  def initialize name, age
    @name = name
    @age = age
  end

  def self.from_hash hash
    Alligator.new(hash[:name], hash[:age])
  end

  def == other
    other.is_a?(Alligator) && other.name == name && other.age == age
  end
end

# The client class responsible for interacting with the provider
# (in this case, a Zoo database)
class ZooClient
  def initialize database
    @database = database
  end

  def get_alligator_by_name name
    query = "select * from alligators where name = '#{name}' limit 1"
    @database[query].collect{ |row| Alligator.from_hash(row) }.first
  end
end

# This array will keep track of all the interactions so that we can
# serialize them to the contract file after the tests have run
interactions = []

# Run the tests for the ZooClient
describe "ZooClient" do

  let(:database) { double('database') }
  let(:zoo_client) { ZooClient.new(database) }
  let(:expected_query) { "select * from alligators where name = 'Mary' limit 1" }

  context "when a record for the alligator called Mary exists" do
    let(:expected_results) { [{name: 'Mary', age: 2}] }

    it "returns an Alligator called Mary"  do
      expect(database).to receive(:[]).with(expected_query).and_return(expected_results)
      expect(zoo_client.get_alligator_by_name('Mary')).to eq Alligator.new('Mary', 2)

      # record the interaction
      interactions << {
        state: 'a record for an alligator named Mary exists',
        query: expected_query,
        results: expected_results
      }
    end
  end

  context "when a record for the alligator called Mary does not exist" do
    let(:expected_results) { [] }

    it "returns nil"  do
      expect(database).to receive(:[]).with(expected_query).and_return(expected_results)
      expect(zoo_client.get_alligator_by_name('Mary')).to eq nil

      # record the interaction
      interactions << {
        state: 'a record for an alligator named Mary does not exist',
        query: expected_query,
        results: expected_results
      }
    end
  end

  after (:all) do
    # serialize the contract so that we can share it with the provider
    contract_json = JSON.pretty_generate({ interactions: interactions })
    File.open("consumer/contract.json", "w") { |file| file << contract_json }
  end
end
