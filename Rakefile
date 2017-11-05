load 'consumer/Rakefile'
load 'provider/Rakefile'

task 'contract:e2e' => ['spec', 'contract:verify']

task :default => 'contract:e2e'
