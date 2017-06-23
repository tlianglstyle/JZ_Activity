Common.initForm();
$('.activity-button').click(function(){
	Common.hmt('【热区按钮】- 页面:'+activity + ',按钮序号:'+$('.activity-button').index($(this))+',渠道:'+parastr('utm_source') + ',客户经理:'+parastr('customerManagerId'),1);
	$('.common_form ').show();
});
$(".common_form .form-close").click(function() {
	$('.common_form').hide();
});