require "rubygems"
require "exifr"
require "find"

input  = "./input"
output = "./output"

Find.find(input) do |f|
	next unless FileTest.file?(f)
	begin
#if File.basename(f).gsub(".jpg", "")[-1].to_i > 1
		tm = nil
		fx = nil
		if File.basename(f).downcase.index(".jpg")
			if ex = EXIFR::JPEG.new(f)
				tm = ex.date_time_original.strftime("%Y%m%d%H%M%S") unless ex.date_time_original.nil?
				tm = File.mtime(f).strftime("%Y%m%d%H%M%S") if ex.date_time_original.nil?
				fx = "jpg"
			end
		elsif File.basename(f).downcase.index(".mp4")
			tm = File.mtime(f).strftime("%Y%m%d%H%M%S")
			fx = "mp4"
		end
		if tm
			cn = 0
			for i in 0..9
				cn = i and break unless File.exist?("#{output}/#{tm}#{i}.#{fx}")
			end
			File.rename("#{input}/#{File.basename(f)}", "#{output}/#{tm}#{cn}.#{fx}")
		end
#end
	rescue => e
		p e
	end
end
