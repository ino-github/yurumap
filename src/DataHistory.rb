require "./Common"
require "./DataManager"

class DataHistory < DataManager
	
	@@DATA_FILE_PATH   = Common::FILE_PATH_HISTORY
	@@IDX_CODE         = 0
	@@IDX_ENABLE       = 1
	@@IDX_HISTORY      = 2
	@@IDX_CODE_AREA1   = 3
	@@IDX_CODE_AREA2   = 4
	@@IDX_DATE_REGIST  = 5
	@@IDX_DATE_INFORM  = 6

	@@COUNT_DAYS_INFORM    = Common::COUNT_DAYS_INFORM_HISTORY

	#####################
	#####################
	def initialize(is_admin = false)
		@@IS_ADMIN = is_admin
		@list_prop = getListProp(@@DATA_FILE_PATH)
	end

	#####################
	#####################
    def getNewsTable()
		news_list  = ""
		@list_prop.each { |prop_row|
			code         = prop_row[@@IDX_CODE].to_s
 			enable       = prop_row[@@IDX_ENABLE].to_s
			history      = prop_row[@@IDX_HISTORY].to_s
			code_area1   = prop_row[@@IDX_CODE_AREA1].to_s
			code_area2   = prop_row[@@IDX_CODE_AREA2].to_s
			str_date_inf = prop_row[@@IDX_DATE_INFORM].to_s

			date_inform  = Date.strptime(str_date_inf,'%Y.%m.%d')
			day_count    = Date.today - date_inform

			next if ( enable    != @@VAL_ENABLE && @@IS_ADMIN == false )

			news = ""
			if ( code_area1.length > 0 ) then
				news += "<a href=""javascript:selectNews('" + code_area1 + "','" + code_area2 + "')"" >"
				news += history
				news += "</a>"
			else
				news += history
			end

##########################################################################
news_row = <<"EOS"
	<tr>
		<td #{Common::HTML_TD_COLOR_02} width="10">#{str_date_inf}</td>
		<td #{Common::HTML_TD_COLOR_02} >#{news}</td>
	</tr>
EOS
##########################################################################

			news_list = news_row + news_list
		}

		news_table  = ""
		news_table += "<font size=""-1"">"
		news_table += "<table width=""100%"" " + Common::HTML_TABLE_BORDER_02 + " ><tr>"
		news_table += "<td class=""GRAY_CELL"" colspan=""2"" align=""center"">更新履歴</td></tr>"
		news_table += news_list
		news_table += "</table>"
		news_table += "</font>"

		return news_table

	end	
end
