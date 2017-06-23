if($('.activity-modules').length>0){
	$('.activity-modules').css({width:1920,marginLeft:($(window).width()-1920)/2});	
	$(window).resize(function(){
		$('.activity-modules').css({width:1920,marginLeft:($(window).width()-1920)/2});
	});
}