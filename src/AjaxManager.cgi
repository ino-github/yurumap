#!/usr/local/bin/ruby
print "Content-type: text/html\n\n"

require "cgi"
require "./Common"
require "./DataSpot"
require "./DataArea2"
require "./DataHistory"

REQ_TITLE        = "REQ_TITLE"
REQ_LIST_SPOT    = "REQ_LIST_SPOT"
REQ_SPOT_DETAIL  = "REQ_SPOT_DETAIL"
REQ_SELECT_AREA2 = "REQ_SELECT_AREA2"

cgi      = CGI.new
req_type = cgi["REQUEST_TYPE"]


case req_type
when REQ_TITLE then
	obj_hist   = DataHistory.new()
	table_news = obj_hist.getNewsTable()

##########################################################################
	str = <<"TITLE_EOS"
	<table width="100%"><tr><td>
	<table width="100%" border="0" cellpadding="5" cellspacing="0"><tr><td>
	<table width="100%" #{Common::HTML_TABLE_BORDER_01} >
		<tr>
			<td class="GRAY_CELL">
				<table width="100%" #{Common::HTML_TABLE_BORDER_02}><tr>
				<td #{Common::HTML_TD_COLOR_01} >
					<table width="100%" border="0" cellpadding="0" cellspacing="0"><tr>
					<td width="95%" align="center">【非公式】ゆるキャラ地図</td>
					<td width="5%"  align="right"><a href="javascript:closeDetail()"><img valign="middle" src="./img/close.png"></a></td>
					</tr></table>
				</td>
				</tr></table>
			</td>
		</tr><tr>
			<td #{Common::HTML_TD_COLOR_01} align="center">
				<table width="100%" #{Common::HTML_TABLE_BORDER_02}><tr>
				<td #{Common::HTML_TD_COLOR_01} >
					<img src="./img/title.png">
					<font size="-1">
					ゲームアプリ「英語物語」の登場キャラクターを地図に配置した、<font color="#ff0000"><b>非公式</b></font>のファンサイトです。
					</font>
				</td>
				</tr></table>
			</td>
		</tr><tr>
			<td #{Common::HTML_TD_COLOR_01} >
				#{table_news}
			</td>
		</tr></table>
TITLE_EOS
##########################################################################
	print str

when REQ_LIST_SPOT then
	code_area1 = cgi["SELECT_AREA1"]
	code_area2 = cgi["SELECT_AREA2"]
	obj_spot       = DataSpot.new()
	str_spot_liset = obj_spot.getListSpot(code_area1, code_area2)
	print str_spot_liset

when REQ_SPOT_DETAIL then
	code_spot = cgi["SELECT_SPOT"]

	obj_spot  = DataSpot.new()
	spot_info = obj_spot.getSpotInfo(code_spot)
	print spot_info

when REQ_SELECT_AREA2 then
	code_area1 = cgi["SELECT_AREA1"]

	obj_area2    = DataArea2.new()
	select_area2 = obj_area2.getSelectArea2(code_area1)
	print select_area2
end

