require "./Common"
require "./DataManager"

class DataArea2 < DataManager
	
	@@DATA_FILE_PATH   = Common::FILE_PATH_AREA2
	@@IDX_CODE         = 0
	@@IDX_ENABLE       = 1
	@@IDX_LAT          = 2
	@@IDX_LNG          = 3
	@@IDX_NAME         = 4
	@@IDX_CODE_AREA1   = 5
	@@IDX_CODE_AREA2   = 6

	#####################
	#####################
	def initialize(is_admin = false)
		@@IS_ADMIN = is_admin
		@list_prop = getListProp(@@DATA_FILE_PATH)
	end

	#####################
	#####################
    def getSelectArea2(p_code_area1, p_code_area2 = "101")
		str_select   = ""
		all_opt      = ""

		@list_prop.each { |prop_row|
			code_area1    = prop_row[@@IDX_CODE_AREA1].to_s
			code_area2    = prop_row[@@IDX_CODE_AREA2].to_s
			enable        = prop_row[@@IDX_ENABLE].to_s
			name          = prop_row[@@IDX_NAME].to_s

			next if ( enable     != @@VAL_ENABLE && @@IS_ADMIN == false )
			next if ( code_area1 != p_code_area1 )

			selected = ""
			selected = "selected" if ( code_area2 == p_code_area2 ) 

			tmp_opt  = "<option value='#{code_area2}' #{selected} >" + name + "</option>\n"
			all_opt += tmp_opt
		}

		str_select += "<select id='SELECT_AREA2' onchange='onChangeSelectArea2()'>\n"
		str_select += all_opt
		str_select += "</select>\n"

		return str_select
	end	
end
