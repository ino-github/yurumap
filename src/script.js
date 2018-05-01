
var map;
var list_marker       = new google.maps.MVCArray();
var list_marker_info  = new Array();
var MAP_CENTER_STAY   = 0;
var MAP_CENTER_CHANGE = 1;

/***********************
***********************/
function initialize() {
	var zoom_level = MAP_INIT_ZOOM_LEVEL;
	var center_lat = MAP_INIT_CENTER_LAT;
	var center_lng = MAP_INIT_CENTER_LNG;

	var mapOptions = {
		zoom                : zoom_level,
		center              : new google.maps.LatLng(center_lat, center_lng),
		mapTypeId           : google.maps.MapTypeId.ROADMAP,
		streetViewControl   : false,
		gestureHandling     : 'greedy',
		zoomControlOptions  : {
			position: google.maps.ControlPosition.TOP_RIGHT
		}
	};
	map = new google.maps.Map(document.getElementById('AREA_MAP'),mapOptions);
	
	setMarker(MAP_CENTER_CHANGE, MAP_INIT_AREA1, MAP_INIT_AREA2);
	openTitle();

	map.addListener('zoom_changed', function() {
		changeZoomLevel();
	});
}

/***********************
***********************/
function changeZoomLevel(){
	//var code_area1 = SELECT_AREA1.value;
	//var code_area2 = SELECT_AREA2.value;
	//setMarker(MAP_CENTER_STAY, code_area1, code_area2);
}


/***********************
***********************/
function clearMarker(){
    list_marker.forEach(function(marker, idx) {
      marker.setMap(null);
    });
}

/***********************
***********************/
function setMarker(p_chg_center, p_area1, p_area2){
	clearMarker();

	$.ajax({
		type    : "POST",
		url     : "AjaxManager.cgi",
		data    : { "REQUEST_TYPE" : "REQ_LIST_SPOT",
					"SELECT_AREA1" : p_area1,
					"SELECT_AREA2" : p_area2},
		success : function(str_list_spot){
			var list_spot  = str_list_spot.split(";");
			var i          = 0;
			var i_max      = list_spot.length;

			list_marker_info = new Array();

			for ( i=0; i<i_max; i++ ){
				if ( list_spot[i].length == 0 ){ continue; }

				var list_info = list_spot[i].split(",");
				var lat       = Number(list_info[IDX_LAT]);
				var lng       = Number(list_info[IDX_LNG]);
				var latlng    = new google.maps.LatLng(lat,lng);

				var obj_info          = new Object();
				obj_info.code         = list_info[IDX_CODE];
				obj_info.enable       = list_info[IDX_ENABLE];
				obj_info.latlng       = latlng;
				obj_info.yuru         = list_info[IDX_CODE_YURU];
				obj_info.marker_type  = list_info[IDX_MARKER_TYPE];
				obj_info.marker_area  = list_info[IDX_MARKER_AREA];
				obj_info.marker_lr    = list_info[IDX_MARKER_LR];
				obj_info.update       = list_info[IDX_CODE_UPDATE];

				list_marker_info[i]  = obj_info;
			}
			drawMarker();
			if( p_chg_center == MAP_CENTER_CHANGE ){
				setMapCenter();
			}
		}
	});
}

/***********************
***********************/
function createMaker(obj, icon, latlng, title){
	var marker = new google.maps.Marker({
		map      : map,
		icon     : icon,
		position : latlng,
		title    : title
	});
	return marker;
}

/***********************
***********************/
function createIcon(img, size_w, size_h, org_w, org_h, anch_w, anch_h ){
	var size = new google.maps.Size(  size_w, size_h );
	var org  = new google.maps.Point( org_w,  org_h );
	var anch = new google.maps.Point( anch_w, anch_h );
	var icon = new google.maps.MarkerImage( img, size, org, anch );
	return icon;
}

/***********************
***********************/
function drawMarker(){

	var BASE_SIZE_W = 54;
	var BASE_SIZE_H = 80;
	var BASE_ORGN_W = 0;
	var BASE_ORGH_H = 0;

	var AREA_SIZE_W = 54;
	var AREA_SIZE_H = 20;
	var AREA_ORGN_W = 0;
	var AREA_ORGH_H = 0;

	var YURU_SIZE_W = 50;
	var YURU_SIZE_H = 50;
	var YURU_ORGN_W = 0;
	var YURU_ORGN_H = 0;

	var UPDT_SIZE_W = 54;
	var UPDT_SIZE_H = 15;
	var UPDT_ORGN_W = 0;
	var UPDT_ORGN_H = 0;

	var STAT_SIZE_W = 54;
	var STAT_SIZE_H = 15;
	var STAT_ORGN_W = 0;
	var STAT_ORGN_H = 0;

	var YURU_MARGIN_W  = -2;
	var YURU_MARGIN_H  = -2;

	var i     = 0;
	var i_max = list_marker_info.length;
	for( i=0; i<i_max; i++ ){

		var zoom_level    = map.getZoom();
		var stat_code     = list_marker_info[i].enable;
		var marker_latlng = list_marker_info[i].latlng;
		var marker_title  = list_marker_info[i].title;
		var marker_type   = list_marker_info[i].marker_type;
		var marker_area   = list_marker_info[i].marker_area;
		var marker_lr     = list_marker_info[i].marker_lr;
		var yuru_code     = list_marker_info[i].yuru;
		var updt_code     = list_marker_info[i].update;
		var marker_code   = marker_type + marker_lr;
		var offset_w      = 0;
		var offset_h      = 0;

		if ( zoom_level < MAP_MARKER_CHANGE_ZOOM_LEVEL ) {
			marker_area = "0"; 
		}

		// set marker size, offset value
		base_size_w = BASE_SIZE_W;
		base_size_h = BASE_SIZE_H;
		if (marker_lr == "C") { offset_w = 0;                     offset_h = 0; }
		if (marker_lr == "L") { offset_w = BASE_SIZE_W / 2 * -1 ; offset_h = 0; }
		if (marker_lr == "R") { offset_w = BASE_SIZE_W / 2;       offset_h = 0; }

		// set anchor
		var base_anch_w = offset_w + base_size_w / 2;
		var base_anch_h = offset_h + base_size_h;
		var area_anch_w =            AREA_SIZE_W / 2;
		var area_anch_h =            AREA_SIZE_H / 2;
		var yuru_anch_w =            base_anch_w     + YURU_MARGIN_W;
		var yuru_anch_h =            base_anch_h     + YURU_MARGIN_H;
		var updt_anch_w = offset_w + UPDT_SIZE_W / 2;
		var updt_anch_h = offset_h + BASE_SIZE_H     + UPDT_SIZE_H + 2; //2 margin
		var stat_anch_w = offset_w + STAT_SIZE_W / 2;
		var stat_anch_h = offset_h + BASE_SIZE_H     + STAT_SIZE_H + 2; //2 margin

		// draft spot do not show update icon
		if ( stat_code == "2" ) {
			updt_code = "0"
		}

		// icon image
		var base_img  = "./img/B" + marker_code + ".png";
		var area_img  = "./img/A" + marker_area + ".png";
		var yuru_img  = "./img/F" + yuru_code   + ".png";
		var updt_img  = "./img/U" + updt_code   + ".png";
		var stat_img  = "./img/S" + stat_code   + ".png";

		// set icon object
		var base_icon = createIcon(base_img, base_size_w, base_size_h, BASE_ORGN_W, BASE_ORGH_H, base_anch_w, base_anch_h);
		var area_icon = createIcon(area_img, AREA_SIZE_W, AREA_SIZE_H, AREA_ORGN_W, AREA_ORGH_H, area_anch_w, area_anch_h);
		var yuru_icon = createIcon(yuru_img, YURU_SIZE_W, YURU_SIZE_H, YURU_ORGN_W, YURU_ORGN_H, yuru_anch_w, yuru_anch_h);
		var updt_icon = createIcon(updt_img, UPDT_SIZE_W, UPDT_SIZE_H, UPDT_ORGN_W, UPDT_ORGN_H, updt_anch_w, updt_anch_h);
		var stat_icon = createIcon(stat_img, STAT_SIZE_W, STAT_SIZE_H, STAT_ORGN_W, STAT_ORGN_H, stat_anch_w, stat_anch_h);

		// set marker object
		var marker_base = createMaker( map, base_icon, marker_latlng, marker_title );
		var marker_area = createMaker( map, area_icon, marker_latlng, marker_title );
		var marker_yuru = createMaker( map, yuru_icon, marker_latlng, marker_title );
		var marker_updt = createMaker( map, updt_icon, marker_latlng, marker_title );
		var marker_stat = createMaker( map, stat_icon, marker_latlng, marker_title );

		// set maker event
		openDetailSpot1( marker_yuru, list_marker_info[i] );

		list_marker.push(marker_base);
		list_marker.push(marker_area);
		list_marker.push(marker_yuru);
		list_marker.push(marker_updt);
		list_marker.push(marker_stat);
	}
}

/***********************
***********************/
function setMapCenter(){
	var max_lat = 0;
	var max_lng = 0;
	var min_lat = 0;
	var min_lng = 0;
	var i       = 0;
	var i_max   = list_marker_info.length;
	for( i=0; i<i_max; i++ ){
		var lat = list_marker_info[i].latlng.lat();
		var lng = list_marker_info[i].latlng.lng();
		if ( i == 0 ){
			max_lat = lat;
			min_lat = lat;
			max_lng = lng;
			min_lng = lng;
		}else{
			if ( max_lat < lat ){ max_lat = lat; }
			if ( min_lat > lat ){ min_lat = lat; }
			if ( max_lng < lng ){ max_lng = lng; }
			if ( min_lng > lng ){ min_lng = lng; }
		}
	}
	var cnt_lat = ( max_lat + min_lat ) / 2;
	var cnt_lng = ( max_lng + min_lng ) / 2;
	map.setCenter( new google.maps.LatLng(cnt_lat,cnt_lng) );

	var southwest = new google.maps.LatLng(max_lat,min_lng);
	var notheast  = new google.maps.LatLng(min_lat,max_lng);
	var bounds    = new google.maps.LatLngBounds(southwest, notheast);
 	map.fitBounds(bounds, MAP_MARGIN_FIT_BOUNDS); 
}

/***********************
２段階でクリックイベントを呼び出さないと、
オブジェクトが正しく渡らない
***********************/
function openDetailSpot1(marker, marker_info){
		google.maps.event.addListener(marker, 'click', function(event) {
			openDetailSpot2(marker_info);
		});
}
/***********************
***********************/
function openDetailSpot2(marker_info){

	var code_spot = marker_info.code;
	$.ajax({
		type    : "POST",
		url     : "AjaxManager.cgi",
		data    : { "REQUEST_TYPE" : "REQ_SPOT_DETAIL",
					"SELECT_SPOT"  : code_spot},
		success : function(html){
			$("#AREA_INFO").html(html);
		}
	});
	openDetail(300);
}

/***********************
***********************/
function openTitle(){

	$.ajax({
		type    : "POST",
		url     : "AjaxManager.cgi",
		data    : { "REQUEST_TYPE" : "REQ_TITLE"},
		success : function(html){
			$("#AREA_INFO").html(html);
		}
	});
	openDetail(300);
}

/***********************
***********************/
function openDetail(detail_width){

	var left_positon = ($("body").width()/2) - (detail_width/2);
	
	$( "#AREA_GRAY" ).fadeIn("slow");
	$( "#AREA_DETAIL" )
	 .css("z-index","51")
	 .css("position", "fixed")
	 .css("top", 50)
	 .css("left", left_positon)
	 .css("width", detail_width)
	 .fadeIn("slow");
}

/***********************
***********************/
function closeDetail(){
	$( "#AREA_GRAY" ).fadeOut("slow");
	$( "#AREA_DETAIL" ).fadeOut("slow");
	$( "#AREA_INFO" ).html("");
}

/***********************
***********************/
function onChangeSelectArea1(){
	var code_area1 = SELECT_AREA1.value;
	changeSelectArea(code_area1, null);
}

/***********************
***********************/
function onChangeSelectArea2(){
	var code_area1 = SELECT_AREA1.value;
	var code_area2 = SELECT_AREA2.value;
	setMarker(MAP_CENTER_CHANGE, code_area1, code_area2);
}

/***********************
***********************/
function changeSelectArea(p_area1, p_area2){
	var code_area1 = p_area1;
	var code_area2 = p_area2;
	$.ajax({
		type    : "POST",
		url     : "AjaxManager.cgi",
		data    : { "REQUEST_TYPE" : "REQ_SELECT_AREA2",
					"SELECT_AREA1" : code_area1},
		success : function(html){
			$("#AREA_AREA2").html(html);
			if ( code_area2 == null ){
				code_area2 = SELECT_AREA2.value;
			}else{
				SELECT_AREA2.value = code_area2;
			}
			setMarker(MAP_CENTER_CHANGE, code_area1, code_area2);
		}
	});

}

/***********************
***********************/
function selectNews(p_area1, p_area2){
	SELECT_AREA1.value = p_area1;
	SELECT_AREA2.value = p_area2;

	closeDetail();
	changeSelectArea(p_area1, p_area2);
	setMarker(MAP_CENTER_CHANGE, p_area1, p_area2);
}
