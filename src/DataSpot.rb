require "date"
require "./Common"
require "./DataManager"
require "./DataYuru"

class DataSpot < DataManager
	@@DATA_FILE_PATH   = Common::FILE_PATH_SPOT
	@@IDX_CODE         = 0
	@@IDX_ENABLE       = 1
	@@IDX_LAT          = 2
	@@IDX_LNG          = 3
	@@IDX_NAME1        = 4
	@@IDX_NAME2        = 5
	@@IDX_NAME3        = 6
	@@IDX_ADDR1        = 7
	@@IDX_ADDR2        = 8
	@@IDX_ADDR3        = 9
	@@IDX_WIKI_NAME    = 10
	@@IDX_WIKI_DATE    = 11
	@@IDX_WIKI_URL     = 12
	@@IDX_WIKI_DESC    = 13
	@@IDX_SITE_NAME    = 14
	@@IDX_SITE_URL     = 15
	@@IDX_CODE_YURU    = 16
	@@IDX_MARKER_TYPE1 = 17
	@@IDX_MARKER_TYPE2 = 18
	@@IDX_MARKER_TYPE3 = 19
	@@IDX_CODE_AREA1   = 20
	@@IDX_CODE_AREA2   = 21
	@@IDX_CAUTION      = 22
	@@IDX_DATE_REGIST  = 23
	@@IDX_DATE_UPDATE  = 24

	@@DAY_COUNT_UPD    = Common::COUNT_DAYS_SHOW_UPDATE
	@@UPD_TYPE_OLD     = "0"
	@@UPD_TYPE_NEW     = "1"
	@@UPD_TYPE_UPD     = "2"

	#####################
	#####################
	def initialize(is_admin = false)
		@@IS_ADMIN = is_admin
		@list_prop = getListProp(@@DATA_FILE_PATH)
	end
	
	#####################
	#####################
	def getListSpotIdx()
##########################################################################
list_spot_idx = <<"EOS"
	var IDX_CODE        = 0;
	var IDX_ENABLE      = 1;
	var IDX_LAT         = 2;
	var IDX_LNG         = 3;
	var IDX_CODE_YURU   = 4;
	var IDX_MARKER_TYPE = 5;
	var IDX_MARKER_AREA = 6;
	var IDX_MARKER_LR   = 7;
	var IDX_CODE_UPDATE = 8;
EOS
##########################################################################
		return list_spot_idx
	end

	#####################
	#####################
	def getNewUpdate(p_str_date_reg, p_str_date_upd)
		date_regist  = Date.strptime('2000.1.1','%Y.%m.%d')
		date_update  = Date.strptime('2000.1.1','%Y.%m.%d')

		if ( p_str_date_reg.length > 0 && p_str_date_upd.length > 0 ) then
			date_regist  = Date.strptime(p_str_date_reg,'%Y.%m.%d')
			date_update  = Date.strptime(p_str_date_upd,'%Y.%m.%d')
		end

		day_count = Date.today - date_update
		ret_val = @@UPD_TYPE_OLD

		if ( day_count < @@DAY_COUNT_UPD ) then
			ret_val = @@UPD_TYPE_NEW if ( date_regist == date_update ) 
			ret_val = @@UPD_TYPE_UPD if ( date_regist != date_update ) 
		end
		return ret_val
	end


	#####################
	#####################
	def getListSpot(p_code_area1, p_code_area2)
		data_marker  = ""
		list_spot    = ""

		@list_prop.each { |prop_row|

			code         = prop_row[@@IDX_CODE].to_s
			enable       = prop_row[@@IDX_ENABLE].to_s
			lat          = prop_row[@@IDX_LAT].to_s
			lng          = prop_row[@@IDX_LNG].to_s
			code_yuru    = prop_row[@@IDX_CODE_YURU].to_s
			marker_type1 = prop_row[@@IDX_MARKER_TYPE1].to_s
			marker_type2 = prop_row[@@IDX_MARKER_TYPE2].to_s
			marker_type3 = prop_row[@@IDX_MARKER_TYPE3].to_s
			code_area1   = prop_row[@@IDX_CODE_AREA1].to_s
			code_area2   = prop_row[@@IDX_CODE_AREA2].to_s

			str_date_reg = prop_row[@@IDX_DATE_REGIST].to_s
			str_date_upd = prop_row[@@IDX_DATE_UPDATE].to_s
			code_update  = getNewUpdate(str_date_reg, str_date_upd)

			next if ( enable       == @@VAL_DISABLE && @@IS_ADMIN     == false  )
			next if ( p_code_area1 != code_area1    || p_code_area2 != code_area2 )

			marker_base  = marker_type1 + marker_type2 + marker_type3

			tmp_spot  = ""
			tmp_spot  += code         + "," 
			tmp_spot  += enable       + "," 
			tmp_spot  += lat          + ","
			tmp_spot  += lng          + ","
			tmp_spot  += code_yuru    + "," 
			tmp_spot  += marker_type1 + ","
			tmp_spot  += marker_type2 + ","
			tmp_spot  += marker_type3 + ","
			tmp_spot  += code_update  + ";"

			list_spot += tmp_spot
		}
		return list_spot
	end

	#####################
	#####################
	def getSpotInfo(code_spot)

		obj_yuru        = DataYuru.new()
		name            = ""
		addr            = ""
		wiki_name       = ""
		wiki_url        = ""
		wiki_icon       = ""
		wiki_link       = ""
		wiki_desc       = ""
		site_name       = ""
		site_url        = ""
		site_icon       = ""
		site_link       = ""
		code_yuru       = ""
		caution         = ""
		caution_cmt_bgn = ""
		caution_cmt_end = ""

		@list_prop.each { |prop_row|
			if ( code_spot == prop_row[@@IDX_CODE].to_s ) then

				code         = prop_row[@@IDX_CODE].to_s
				enable       = prop_row[@@IDX_ENABLE].to_s
				name1        = prop_row[@@IDX_NAME1].to_s
				name2        = prop_row[@@IDX_NAME2].to_s
				name3        = prop_row[@@IDX_NAME3].to_s
				addr1        = prop_row[@@IDX_ADDR1].to_s
				addr2        = prop_row[@@IDX_ADDR2].to_s
				addr3        = prop_row[@@IDX_ADDR3].to_s
				site_name    = prop_row[@@IDX_SITE_NAME].to_s
				site_url     = prop_row[@@IDX_SITE_URL].to_s
				wiki_name    = prop_row[@@IDX_WIKI_NAME].to_s
				wiki_date    = prop_row[@@IDX_WIKI_DATE].to_s
				wiki_url     = prop_row[@@IDX_WIKI_URL].to_s
				wiki_desc    = prop_row[@@IDX_WIKI_DESC].to_s
				code_yuru    = prop_row[@@IDX_CODE_YURU].to_s
				caution      = prop_row[@@IDX_CAUTION].to_s

				name      = name1 + " " + name2 + " " + name3
				addr      = addr1 + " " + addr2 + " " + addr3

				if ( site_name.length > 0 ) then
					site_icon = "<img src=""./img/link.png"" border=""0"">"
					site_link = "<a href=""" + site_url + """ target=""_blank"">" + site_name + "</a>"
				else
					site_link = "未設定"
				end
				if ( wiki_name.length > 0 ) then
					wiki_name = "参考：" + wiki_name + "(" + wiki_date + ")"
					wiki_icon = "<img src=""./img/link.png"" border=""0"">"
					wiki_link = "<a href=""" + wiki_url + """ target=""_blank"">" + wiki_name + "</a>"
				end
				if ( wiki_desc.length > 0 ) then
					wiki_desc = wiki_desc
				else
					wiki_desc = "未設定"
				end
				if ( caution.length > 0 ) then
					caution = caution
				else
					caution_cmt_bgn = "<!--"
					caution_cmt_end = "-->"
				end

				break
			end
		}

##########################################################################
spot_info = <<"EOS"
	<font size="-1">
	<table width="100%"><tr><td>
	<table width="100%" border="0" cellpadding="10" cellspacing="0"><tr><td>
	<table width="100%" #{Common::HTML_TABLE_BORDER_01}><tr>
	<td #{Common::HTML_TD_COLOR_01} height="5">
		<table width="100%" #{Common::HTML_TABLE_BORDER_02}>
			<tr>
				<td class="GRAY_CELL" colspan="2">
					<table width="100%" border="0" cellpadding="0" cellspacing="0"><tr>
					<td width="95%" align="center">詳細情報</td>
					<td width="5%"  align="right"><a href="javascript:closeDetail()"><img valign="middle" src="./img/close.png"></a></td>
					</tr></table>
				</td>
			</tr><tr>
				<td class="GRAY_CELL" nowrap width="50">
					<img align="center" valign="middle" src="./img/F#{code_yuru}.png">
				</td>
				<td #{Common::HTML_TD_COLOR_02} >
					名前：#{obj_yuru.getName(code_yuru)}<br>
					出身：#{obj_yuru.getAddr(code_yuru)}
				</td>
			</tr><tr>
				<td class="GRAY_CELL" nowrap>場所</td>
				<td #{Common::HTML_TD_COLOR_02} >
					<table border="0" cellpadding="0" cellspacing="0">
					<tr><td>#{name}</td></tr>
					<tr><td>#{addr}</td></tr>
					</table>
				</td>
			</tr><tr>
				<td class="GRAY_CELL" nowrap>関連<br>リンク</td>
				<td #{Common::HTML_TD_COLOR_02} >
					<table width="100%" border="0" cellpadding="0" cellspacing="0"><tr>
					<td width="95%" align="left">#{site_link}</td>
					<td width="5%"  align="right">#{site_icon}</td>
					</tr></table>
				</td>
			</tr><tr>
				<td colspan="2" class="GRAY_CELL"> 
					<table width="100%" border="0" cellpadding="0" cellspacing="0"><tr>
						<td align="left" nowrap>解説</td>
						<td align="right">#{wiki_link}</td>
						<td align="right" width="25">#{wiki_icon}</td>
					</tr></table>
				</td>
			</tr><tr>
				<td #{Common::HTML_TD_COLOR_02} colspan="2"> #{wiki_desc} </td>
			#{caution_cmt_bgn}
			</tr><tr>
				<td colspan="2" class="PINK_CELL"> 
					<table width="100%" border="0" cellpadding="0" cellspacing="0"><tr>
						<td align="left" nowrap>注意事項</td>
					</tr></table>
				</td>
			</tr><tr>
				<td #{Common::HTML_TD_COLOR_02} colspan="2"> #{caution} </td>
			#{caution_cmt_end}
			</tr>
		</table>
	</td></tr></table>
	</td></tr></table>
	</td></tr></table>
	</font>
EOS
##########################################################################

		return spot_info
	end
end
