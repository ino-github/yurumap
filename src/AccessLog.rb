require "date"

class AccessLog

	def writeLogAccess(env)
		date_now  = Time.now
		str_now   = date_now.strftime("%Y/%m/%d %H:%M:%S")
		file_path = "./log/" + date_now.strftime("%Y%m") + ".log"

		if ( !File.exists?(file_path) ) 
			File.open(file_path, "w").close()
		end

		host  = ""
		agent = ""
		refer = ""
		env.collect { |key,value|
			host  =  value if ( key=='HTTP_HOST' )
			agent =  value if ( key=='HTTP_USER_AGENT' )
			refer =  value if ( key=='HTTP_REFERER' )
		}

		str_log = str_now + "\t" + host + "\t" + agent + "\t" + refer + "\n"
		log_file = open(file_path, "a+")
		log_file.flock(File::LOCK_EX)

		log_file.write(str_log)
		log_file.flock(File::LOCK_UN)
		log_file.close

	end

	def writeLogYuru(p_code)
		date_now  = Time.now
		str_now   = date_now.strftime("%Y/%m/%d %H:%M:%S")
		file_path = "./log/" + date_now.strftime("%Y%m") + "_yuru.log"

		if ( !File.exists?(file_path) ) 
			File.open(file_path, "w").close()
		end

		str_log = str_now + "\t" + p_code + "\n"
		log_file = open(file_path, "a+")
		log_file.flock(File::LOCK_EX)

		log_file.write(str_log)
		log_file.flock(File::LOCK_UN)
		log_file.close

	end
end