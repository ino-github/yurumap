require "./Common"
require "./DataManager"

class DataArea1 < DataManager
	
	@@DATA_FILE_PATH   = Common::FILE_PATH_AREA1
	@@IDX_CODE         = 0
	@@IDX_ENABLE       = 1
	@@IDX_LAT          = 2
	@@IDX_LNG          = 3
	@@IDX_NAME         = 4

	#####################
	#####################
	def initialize(is_admin = false)
		@@IS_ADMIN = is_admin
		@list_prop = getListProp(@@DATA_FILE_PATH)
	end

	#####################
	#####################
    def getSelectArea1(p_code_area1)
		str_select   = ""
		all_opt      = ""

		@list_prop.each { |prop_row|
			code     = prop_row[@@IDX_CODE].to_s
			enable   = prop_row[@@IDX_ENABLE].to_s
			name     = prop_row[@@IDX_NAME].to_s

			next if ( enable != @@VAL_ENABLE && @@IS_ADMIN == false )

			selected = ""
			selected = "selected" if ( code == p_code_area1 ) 

			tmp_opt  = "<option value='#{code}' #{selected} >" + name + "</option>\n"
			all_opt += tmp_opt
		}

		str_select += "<select id='SELECT_AREA1' onchange='onChangeSelectArea1()'>\n"
		str_select += all_opt
		str_select += "</select>\n"

		return str_select
	end	

	#####################
	#####################
	def getName(p_code_area1)
		return getPropArea1(p_code_area1, @@IDX_NAME)
	end

	#####################
	#####################
	def getPropArea1(p_code_area1, p_idx)

		ret_val = ""
		code    = ""
		enable  = ""
		name    = ""
		@list_prop.each { |prop_row|
			code     = prop_row[@@IDX_CODE].to_s
			enable   = prop_row[@@IDX_ENABLE].to_s
			name     = prop_row[@@IDX_NAME].to_s
			next if ( enable != @@VAL_ENABLE && @@IS_ADMIN == false  )
			next if ( p_code_area1 != code )
			break
		}

		case p_idx
		when @@IDX_NAME then
			ret_val = name
		end
		return ret_val
	end
end
