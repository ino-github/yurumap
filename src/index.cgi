#!/usr/local/bin/ruby
print "Content-type: text/html\n\n"

require "./Common"
require "./DataSpot"
require "./DataArea1"
require "./DataArea2"
require "./AccessLog"
require "./AccessCounter"


obj_spot  = DataSpot.new()
obj_area1 = DataArea1.new()
obj_area2 = DataArea2.new()

obj_log   = AccessLog.new
obj_log.writeLog(ENV)

obj_counter  = AccessCounter.new()
count_str    = obj_counter.getCount()

##########################################################################
str = <<"EOS"
<!DOCTYPE html>
<html>
	<head>
	<title>【非公式】ゆるキャラ地図</title>
	<meta name="viewport" content="initial-scale=1.0, user-scalable=no">
	<meta charset="utf-8">
	<link rel="stylesheet" type="text/css" href="style.css" media="all">
	<script src="https://maps.googleapis.com/maps/api/js?key=#{Common::MAP_API_KEY}"></script>
	<script type="text/javascript" src="jquery-1.11.0.js"></script>
	<script type="text/javascript">
		#{obj_spot.getListSpotIdx()}

		var MAP_INIT_ZOOM_LEVEL          = #{Common::MAP_INIT_ZOOM_LEVEL};
		var MAP_INIT_CENTER_LAT          = #{Common::MAP_INIT_CENTER_LAT};
		var MAP_INIT_CENTER_LNG          = #{Common::MAP_INIT_CENTER_LNG};
		var MAP_INIT_AREA1               = #{Common::MAP_INIT_AREA1};
		var MAP_INIT_AREA2               = #{Common::MAP_INIT_AREA2};
		var MAP_MARGIN_FIT_BOUNDS        = #{Common::MAP_MARGIN_FIT_BOUNDS};
		var MAP_MARKER_CHANGE_ZOOM_LEVEL = #{Common::MAP_MARKER_CHANGE_ZOOM_LEVEL};

	</script>
	<script type="text/javascript" src="script.js"></script>

	</head>

	<body onload="initialize()">
	<table width="100%" height="100%" cellpadding="0" cellspacing="16"><tr><td align="center">
	<table width="100%" height="100%" #{Common::HTML_TABLE_BORDER_01}>
	<tr>
		<td #{Common::HTML_TD_COLOR_01} height="5">
			<table width="100%" #{Common::HTML_TABLE_BORDER_02}><tr>
			<td #{Common::HTML_TD_COLOR_03} >
			</td><td #{Common::HTML_TD_COLOR_01} width="80" align="center">
				<a href="javascript:openTitle()">News</a>
			</td><td #{Common::HTML_TD_COLOR_01} width="160" align="center">
				<table width="160" border="0" cellspacing="0" cellpadding="0"><tr>
				<td align="center" width="80"><div id="AREA_AREA1">#{obj_area1.getSelectArea1(Common::MAP_INIT_AREA1)}</div></td>
				<td align="center" width="80"><div id="AREA_AREA2">#{obj_area2.getSelectArea2(Common::MAP_INIT_AREA1,Common::MAP_INIT_AREA2)}</div></td>
				</tr></table>
			</td>
			</tr></table>
		</td>
	</tr><tr>
		<td #{Common::HTML_TD_COLOR_01} >
			<table width="100%" height="100%" #{Common::HTML_TABLE_BORDER_02}><tr>
			<td align="center" valign="middle" #{Common::HTML_TD_COLOR_01} >
				<div id="AREA_MAP" style="width: 100%; height: 100%;"></div>
			</td>
			</tr></table>
		</td>
	</tr><tr>
		<td #{Common::HTML_TD_COLOR_01} height="5">
			<table width="100%" height="100%" #{Common::HTML_TABLE_BORDER_02}><tr>
			<td #{Common::HTML_TD_COLOR_01} align="center" valign="middle">
				<table cellpadding="0" cellspacing="2"><tr>
				<td rowspan="2" aligh="center" valign="middle" width="90" height="90">
					<img src="./img/eigomonogatari.png" width="86">
				</td><td>
					#{Common::BADGE_GOOGLE}
				</td></tr><tr><td>
					#{Common::BADGE_APPLE}
				</td></tr></table>
			</td>
			</tr></table>
		</td>
	</tr><tr>
		<td #{Common::HTML_TD_COLOR_01} height="5">
			<table width="100%" height="100%" #{Common::HTML_TABLE_BORDER_02}><tr>
			<td #{Common::HTML_TD_COLOR_03} align="right">
				version:#{Common::VERSION}
			</td>
			</tr></table>
		</td>
	</tr>
	</table>
	</td></tr><table >

	<div id="AREA_GRAY" class="GRAY_AREA" onclick="closeDetail()" ></div>
	<div id="AREA_DETAIL" style="display: none;">
		<center>
				<div id="AREA_INFO"></div>
		</center>
	</div>
	</body>
</html>
EOS
##########################################################################

print str