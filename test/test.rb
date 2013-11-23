require_relative '../lib/identiconify'

string = ARGV[0]
identicon = Identiconify::Identicon.new(string, size: 512, colors: :tinted)
png_data = identicon.to_png_blob
tmpdir = File.join(File.dirname(__FILE__), "tmp")
Dir.mkdir(tmpdir) unless File.directory?(tmpdir)
filename = File.join(tmpdir, "image.png")
File.open(filename, "w") do |file|
  file.write(png_data)
end
system "open #{filename}"
