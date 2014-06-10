require 'date'
load 'logbook.rb'

activity = ARGV[0].strip
LogBook.save(activity)
