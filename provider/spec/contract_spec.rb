require 'fileutils'
require 'sequel'
require 'json'

# Set up the test database
FileUtils.rm_rf 'tmp/database.sqlite3'
DB = Sequel.connect(adapter: "sqlite", database: "tmp/database.sqlite3")
DB.create_table(:alligators) do
  primary_key :id
  String :name, null: false, unique: true
  Integer :age, null: false
end

# The method that will be used in the tests to set up the test data
# so that the expected results will be returned
def set_up_state(state)
  DB[:alligators].delete

  case state
  when "a record for an alligator named Mary exists"
    DB[:alligators].insert(name: "Mary", age: 2)
  when "a record for an alligator named Mary does not exist"
    # do nothing
  else
    raise "Unrecognised state #{state}"
  end
end

# The method that executes the query and returns the actual results
def execute_query(query)
  DB[query].to_a
end

contract = JSON.parse(File.read('./consumer/contract.json'), symbolize_names: true)
interactions = contract[:interactions]

describe "a contract with the database client" do

  interactions.each do | interaction |

    context "when #{interaction[:state] || "no data exists" }" do

      context "when the query \"#{interaction[:query]}\" is executed" do

        it "returns the expected result" do
          set_up_state(interaction[:state])
          actual = execute_query(interaction[:query])
          expected = interaction[:results]

          # Check that each actual item 'matches' the expected one, according
          # to the desired matching rules.
          # In this case, any unexpected fields will be ignored by the client
          # so we just need to check that the actual results *includes* the expected.
          # This is the recommended practice (following Postel's law),
          # though it may not be applicable for all protocols.
          expected.size.times do | i |
            expect(actual[i]).to include expected[i]
          end

          # make sure there weren't extra unexpected rows if this is important
          expect(actual.size).to eq expected.size
        end

      end

    end

  end

end
