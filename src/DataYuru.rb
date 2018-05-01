require "./Common"
require "./DataManager"

class DataYuru < DataManager
	@@DATA_FILE_PATH   = Common::FILE_PATH_YURU
	@@IDX_CODE         = 0
	@@IDX_ENABLE       = 1
	@@IDX_NAME         = 2
	@@IDX_ADDR1        = 3
	@@IDX_ADDR2        = 4
	@@IDX_LEVEL        = 5

	#####################
	#####################
	def initialize(is_admin = false)
		@@IS_ADMIN = is_admin
		@list_prop = getListProp(@@DATA_FILE_PATH)
	end

	#####################
	#####################
	def getName(p_code)
		return getPropYuru(p_code, @@IDX_NAME)
	end

	#####################
	#####################
	def getAddr(p_code)
		ret_val =  ""
		ret_val += getPropYuru(p_code, @@IDX_ADDR1)
		ret_val += " "
		ret_val += getPropYuru(p_code, @@IDX_ADDR2)
		return ret_val
	end

	#####################
	#####################
	def getPropYuru(p_code, p_idx)

		ret_val = ""
		name    = ""
		addr1   = ""
		addr2   = ""
		@list_prop.each { |prop_row|
			code         = prop_row[@@IDX_CODE].to_s
			enable       = prop_row[@@IDX_ENABLE].to_s
			name         = prop_row[@@IDX_NAME].to_s
			addr1        = prop_row[@@IDX_ADDR1].to_s
			addr2        = prop_row[@@IDX_ADDR2].to_s
			level        = prop_row[@@IDX_LEVEL].to_s
			next if ( enable != @@VAL_ENABLE && @@IS_ADMIN == false  )
			next if ( p_code != code )
			break
		}

		case p_idx
		when @@IDX_NAME then
			ret_val = name
		when @@IDX_ADDR1 then
			ret_val = addr1
		when @@IDX_ADDR2 then
			ret_val = addr2
		end
		return ret_val
	end
end