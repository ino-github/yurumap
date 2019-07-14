
class AccessCounter

	@@FILE_PATH = "./log/access_counter.txt"

	def getCount()
		counter_file = open(@@FILE_PATH, "r+")
		counter_file.flock(File::LOCK_EX)

		count_str = counter_file.read
		count_num = count_str.to_i
		count_num += 1
		count_str = count_num.to_s

		counter_file.rewind
		counter_file.write(count_str)
		counter_file.flock(File::LOCK_UN)
		counter_file.close

		return count_str
	end
end