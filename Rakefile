load 'consumer/Rakefile'
load 'provider/Rakefile'

task 'contract:e2e' => ['contract:create', 'contract:verify']

task :default => 'contract:e2e'
