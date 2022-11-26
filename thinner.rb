puts "Picture thinner\n"

if ARGV.size < 3
	puts "Must supply a directory name, a start file and an end file"
	puts "Example: ruby skimmer.rb /media/calder/1D0F-0142/DCIM/100EK113/ 09110285.JPG 09110285.JPG"
	#print "An optional fourth parameter would be a dry-run flag, which defaults to false"
	#print "Example: ruby skimmer.rb /media/calder/1D0F-0142/DCIM/100EK113/ 09110285.JPG 09110285.JPG"
end

directory = ARGV[0]
start_file = ARGV[1]
end_file = ARGV[2]
dry_run = false

ARGV.each do|a|
  puts "Argument: #{a}"
end

puts "We are going to go through #{directory}, and starting at file #{start_file} and ending at #{end_file} we will delete every other file"

puts  "Start scan? (y)"
start_scan = $stdin.gets.chomp
puts "Start Scan? #{start_scan}"

unless start_scan&.downcase == "y"
  puts "Exiting"
  exit 0
end

start_file_path = File.join(directory, start_file)
unless File.exist?(start_file_path)
	puts "File #{start_file_path} does not exist, exiting"
	exit 0
end

end_file_path = File.join(directory, end_file)
unless File.exist?(end_file_path)
	puts "File #{end_file_path} does not exist, exiting"
	exit 0
end

entries = Dir.entries(directory)
target_subset = []
collect = false
entries.each do |filename|
	if filename == start_file
		collect = true
	end

	target_subset << filename if collect

	if filename == end_file
		break
	end
end

puts "There are #{target_subset.size} files targeted out of #{entries.size}"
puts "Are you sure you want to delete every other file, roughly #{target_subset.size / 2}? (y)"

will_delete = $stdin.gets.chomp
unless will_delete&.downcase == "y"
  puts "Exiting"
  exit 0
end

delete_count = 0
target_subset.each_with_index do |filename, index|
	if index.modulo(2) == 0
		filepath = File.join(directory, filename)
		puts "Deleting #{filepath}"
		File.delete(filepath) unless dry_run || filename == start_file || filename == end_file
		delete_count += 1
	end
end

puts "Deleted #{delete_count} files out of #{target_subset.size}"
