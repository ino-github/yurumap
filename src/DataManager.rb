require "csv"

class DataManager

	@@IS_ADMIN       = false
	@@VAL_ENABLE     = "1"
	@@VAL_DISABLE    = "0"

	#####################
	#####################
	def initialize()
	end

	#####################
	#####################
	def getListProp(file_path)
		list_prop   = []
		#CSV.foreach(file_path) { |csv_row| #server setting (ruby 1.8)
		CSV.foreach(file_path, encoding: "UTF-8") { |csv_row| #local setting (ruby 2.3)
			list_prop.push(csv_row)
		}
		return list_prop
	end
end
