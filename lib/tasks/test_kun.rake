namespace :test_kun do
  desc "Helloを表示するタスク"
  task say_hello: :environment do
    puts "Hello"
  end
end
