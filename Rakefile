require 'rake/testtask'

task :default => :test

Rake::TestTask.new('test:unit') do |t|
  t.libs << 'test'
  t.test_files = FileList['test/unit/**/*_test.rb']
  t.verbose = false
end

Rake::TestTask.new('test:integration') do |t|
  t.libs << 'test'
  t.test_files = FileList['test/integration/**/*_test.rb']
  t.verbose = false
end

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList['test/**/*_test.rb']
  t.verbose = false
end
