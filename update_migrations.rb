#!/usr/bin/env ruby

require 'fileutils'

# Get all migrations in db/migrate directory
migrations = Dir.glob("db/migrate/*.rb")

migrations.each do |file|
  content = File.read(file)
  if content.include?("< ActiveRecord::Migration\n")
    puts "Updating #{file}"
    new_content = content.gsub("< ActiveRecord::Migration\n", "< ActiveRecord::Migration[7.1]\n")
    File.write(file, new_content)
  end
end