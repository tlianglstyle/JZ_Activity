<%@ page language="java" pageEncoding="UTF-8"%>
<%@include file="../common/common.jsp"%>
<%@include file="battlefieldReport_common.jsp"%>
<style>
div.total{
    float: left;
    width: 350px;
    text-align: right;
    margin: 1px 11px 0px 0px;
    height: 20px;
}
div.totalSize{
    float: left;
}
div.checkboxTitle{
    margin: 30px 0px 0px 45px;
}
div.checkboxValue{
    margin: 2px 0px 35px 50px;
    width: 1243px;;
}
div.checkboxValue div{
    margin:0px;
    width: 230px;
}
div.dataTable{
    margin: 0px 0px 0px 44px;
}
div.jduuuieioxe div{
    font-weight: 900;
}
</style>
<div style="border-bottom: 2px solid #9e9696;">
    <form id="searchForm" action="efficiency" method="get">
        <table style="float: left;">
            <tr>
                <td>日期:</td>
                <td>
                    <input name="startTime" class="easyui-datebox" data-options="sharedCalendar:'#cc'" value="${startTime}">
                </td>
                <td>至</td>
                <td>
                    <input name="endTime" class="easyui-datebox" data-options="sharedCalendar:'#cc'" value="${endTime}">
                </td>
            </tr>
        </table>
        <div id="cc" class="easyui-calendar" style=""></div>
        <div style="height: 40px;float: left;margin: 3px 14px 0px 10px;font-size: 15px;">
            <span>门店:</span>
            <select name="shopId" class="easyui-combobox" style="width:130px;">
            		 <option value="0" <c:if test="${0==shopId}">selected</c:if>>全部</option>
                <c:forEach items="${shopMap}" var="user" varStatus="ee">
                    <option value="${user.key}" <c:if test="${user.key==shopId}">selected</c:if>>${user.value}</option>
                </c:forEach>
            </select>
        </div>

        <a href="#" class="easyui-linkbutton" onclick="javascript:$('#searchForm').submit();">查询</a>
	</form>
</div>
<div>
    <div style="margin: 21px 21px -18px 21px;"><span style="font-weight: 900;font-size: 25px;">客户统计</span></div>
    <div style="clear: both;">
        <div class="checkboxTitle"><span>列数据展示过滤:</span></div>
        <div id="efficiency_checkbox" class="checkboxValue"></div>
        <div style="clear: both;" class="dataTable">
            <div>
                <table id="efficiency_1" width="1050"></table>
            </div>
            <div class="jduuuieioxe" style="margin-top: -2px;">
                <table id="efficiency_total" width="1050" style="margin-top:-1px;"></table>
            </div>
        </div>

    </div>
</div>
<div>
    <div style="margin: 21px 21px -18px 21px;"><span style="font-weight: 900;font-size: 25px;">业绩统计</span></div>
    <div style="clear: both;">
        <div class="checkboxTitle"><span>列数据展示过滤:</span></div>
        <div id="achievement_checkbox" class="checkboxValue"></div>
        <div style="clear: both;" class="dataTable">
            <div>
                <table id="achievement_1" width="3310"></table>
            </div>
            <div class="jduuuieioxe" style="margin-top: -2px;">
                <table id="achievement_total" width="3310" style="margin-top:-1px;"></table>
            </div>
        </div>

    </div>
</div>

<script>

var efficiency=[
    <c:forEach items="${dataList}" var="user" varStatus="ee">
        <c:if test="${ee.index>0}">,</c:if>
        {
            name:'${user.managerName}',
            新增客户数:${user.customerSize},
            放弃客户数:${user.abandonSize},
            渠道客户数:${user.channelSize},
            渠道客户数占比:(100*${user.proportionForchannelSize}).toFixed(2),
            自主开发客户数:${user.selfSize},
            自主开发客户数占比:(100*${user.proportionForselfSize}).toFixed(2),
            自然到店客户数:${user.autoSize},
            自然到店客户数占比:(100*${user.proportionForautoSize}).toFixed(2)
        }
    </c:forEach>
   ];
var efficiency_total=[
   {
       name:'总计',
       新增客户数:0<c:forEach items="${dataList}" var="user" varStatus="ee">+${user.customerSize}</c:forEach>,
       放弃客户数:0<c:forEach items="${dataList}" var="user" varStatus="ee">+${user.abandonSize}</c:forEach>,
       渠道客户数:0<c:forEach items="${dataList}" var="user" varStatus="ee">+${user.channelSize}</c:forEach>,
       渠道客户数占比:(100*(0<c:forEach items="${dataList}" var="user" varStatus="ee">+${user.channelSize}</c:forEach>)/((0<c:forEach items="${dataList}" var="user" varStatus="ee">+${user.customerSize}</c:forEach>) == 0 ? 1 : (0<c:forEach items="${dataList}" var="user" varStatus="ee">+${user.customerSize}</c:forEach>))).toFixed(2),
       自主开发客户数:0<c:forEach items="${dataList}" var="user" varStatus="ee">+${user.selfSize}</c:forEach>,
       自主开发客户数占比:(100*(0<c:forEach items="${dataList}" var="user" varStatus="ee">+${user.selfSize}</c:forEach>)/((0<c:forEach items="${dataList}" var="user" varStatus="ee">+${user.customerSize}</c:forEach>) == 0 ? 1 : (0<c:forEach items="${dataList}" var="user" varStatus="ee">+${user.customerSize}</c:forEach>))).toFixed(2),
       自然到店客户数:0<c:forEach items="${dataList}" var="user" varStatus="ee">+${user.autoSize}</c:forEach>,
       自然到店客户数占比:(100*(0<c:forEach items="${dataList}" var="user" varStatus="ee">+${user.autoSize}</c:forEach>)/((0<c:forEach items="${dataList}" var="user" varStatus="ee">+${user.customerSize}</c:forEach>) == 0 ? 1 : (0<c:forEach items="${dataList}" var="user" varStatus="ee">+${user.customerSize}</c:forEach>))).toFixed(2)
   }
  ];
var efficiency_columns = [[
    {field:'name',title:'经理名称',width:100,align:'center',sortable:true,resizable:false},
    {field:'新增客户数',title:'新增客户数',width:100,align:'center',sortable:true,resizable:false},
    {field:'放弃客户数',title:'放弃客户数',width:100,align:'center',sortable:true,resizable:false},
    {field:'渠道客户数',title:'渠道客户数',width:124,align:'center',sortable:true,resizable:false},
    {field:'渠道客户数占比',title:'渠道客户数占比(%)',width:124,align:'center',sortable:true,resizable:false},
    {field:'自主开发客户数',title:'自主开发客户数',width:105,align:'center',sortable:true,resizable:false},
    {field:'自主开发客户数占比',title:'自主开发客户数占比(%)',width:145,align:'center',sortable:true,resizable:false},
    {field:'自然到店客户数',title:'自然到店客户数',width:105,align:'center',sortable:true,resizable:false},
    {field:'自然到店客户数占比',title:'自然到店客户数占比(%)',width:145,align:'center',sortable:true,resizable:false}
  ]];


var achievement=[
    <c:forEach items="${dataList}" var="user" varStatus="ee">
        <c:if test="${ee.index>0}">,</c:if>
        {
            name:'${user.managerName}',
            业绩额:(${user.achievementMoney}).toFixed(2),
            交定客户数:${user.depositSize},
            渠道交定客户数:${user.depositInChannelSize},
            渠道交定客户数占比:(100*${user.proportionFordepositInChannelSize}).toFixed(2),
            自主开发交定客户数:${user.depositInSelfSize},
            自主开发交定客户数占比:(100*${user.proportionFordepositInSelfSize}).toFixed(2),
            自然到店交定客户数:${user.depositInAutoSize},
            自然到店交定客户数占比:(100*${user.proportionFordepositInAutoSize}).toFixed(2),
            预售客户数:${user.presellSize},
            渠道预售客户数:${user.presellInChannelSize},
            渠道预售客户数占比:(100*${user.proportionForpresellInChannelSize}).toFixed(2),
            自主开发预售客户数:${user.presellInSelfSize},
            自主开发预售客户数占比:(100*${user.proportionForpresellInSelfSize}).toFixed(2),
            自然到店预售客户数:${user.presellInAutoSize},
            自然到店预售客户数占比:(100*${user.proportionForpresellInAutoSize}).toFixed(2),
            签单数:${user.orderSize},
            渠道签单数:${user.orderInChannelSize},
            渠道签单数占比:(100*${user.proportionFororderInChannelSize}).toFixed(2),
            自主开发签单数:${user.orderInSelfSize},
            自主开发签单数占比:(100*${user.proportionFororderInSelfSize}).toFixed(2),
            自然到店签单数:${user.orderInAutoSize},
            自然到店签单数占比:(100*${user.proportionFororderInAutoSize}).toFixed(2),
            平均签单时长:'${user.avgTimeForOrder}',
            渠道客户平均签单时长:'${user.avgTimeForOrderInChannel}'
        }
    </c:forEach>
   ];
var achievement_total=[
   {
       name:'总计',
       业绩额:(0<c:forEach items="${dataList}" var="user" varStatus="ee">+${user.achievementMoney}</c:forEach>).toFixed(2),
       交定客户数:0<c:forEach items="${dataList}" var="user" varStatus="ee">+${user.depositSize}</c:forEach>,
       渠道交定客户数:0<c:forEach items="${dataList}" var="user" varStatus="ee">+${user.depositInChannelSize}</c:forEach>,
       渠道交定客户数占比:(100*(0<c:forEach items="${dataList}" var="user" varStatus="ee">+${user.depositInChannelSize}</c:forEach>)/((0<c:forEach items="${dataList}" var="user" varStatus="ee">+${user.depositSize}</c:forEach>) == 0 ? 1 : (0<c:forEach items="${dataList}" var="user" varStatus="ee">+${user.depositSize}</c:forEach>))).toFixed(2),
       自主开发交定客户数:0<c:forEach items="${dataList}" var="user" varStatus="ee">+${user.depositInSelfSize}</c:forEach>,
       自主开发交定客户数占比:(100*(0<c:forEach items="${dataList}" var="user" varStatus="ee">+${user.depositInSelfSize}</c:forEach>)/((0<c:forEach items="${dataList}" var="user" varStatus="ee">+${user.depositSize}</c:forEach>) == 0 ? 1 : (0<c:forEach items="${dataList}" var="user" varStatus="ee">+${user.depositSize}</c:forEach>))).toFixed(2),
       自然到店交定客户数:0<c:forEach items="${dataList}" var="user" varStatus="ee">+${user.depositInAutoSize}</c:forEach>,
       自然到店交定客户数占比:(100*(0<c:forEach items="${dataList}" var="user" varStatus="ee">+${user.depositInAutoSize}</c:forEach>)/((0<c:forEach items="${dataList}" var="user" varStatus="ee">+${user.depositSize}</c:forEach>) == 0 ? 1 : (0<c:forEach items="${dataList}" var="user" varStatus="ee">+${user.depositSize}</c:forEach>))).toFixed(2),
       预售客户数:0<c:forEach items="${dataList}" var="user" varStatus="ee">+${user.presellSize}</c:forEach>,
       渠道预售客户数:0<c:forEach items="${dataList}" var="user" varStatus="ee">+${user.presellInChannelSize}</c:forEach>,
       渠道预售客户数占比:(100*(0<c:forEach items="${dataList}" var="user" varStatus="ee">+${user.presellInChannelSize}</c:forEach>)/((0<c:forEach items="${dataList}" var="user" varStatus="ee">+${user.presellSize}</c:forEach>) == 0 ? 1 : (0<c:forEach items="${dataList}" var="user" varStatus="ee">+${user.presellSize}</c:forEach>))).toFixed(2),
       自主开发预售客户数:0<c:forEach items="${dataList}" var="user" varStatus="ee">+${user.presellInSelfSize}</c:forEach>,
       自主开发预售客户数占比:(100*(0<c:forEach items="${dataList}" var="user" varStatus="ee">+${user.presellInSelfSize}</c:forEach>)/((0<c:forEach items="${dataList}" var="user" varStatus="ee">+${user.presellSize}</c:forEach>) == 0 ? 1 : (0<c:forEach items="${dataList}" var="user" varStatus="ee">+${user.presellSize}</c:forEach>))).toFixed(2),
       自然到店预售客户数:0<c:forEach items="${dataList}" var="user" varStatus="ee">+${user.presellInAutoSize}</c:forEach>,
       自然到店预售客户数占比:(100*(0<c:forEach items="${dataList}" var="user" varStatus="ee">+${user.presellInAutoSize}</c:forEach>)/((0<c:forEach items="${dataList}" var="user" varStatus="ee">+${user.presellSize}</c:forEach>) == 0 ? 1 : (0<c:forEach items="${dataList}" var="user" varStatus="ee">+${user.presellSize}</c:forEach>))).toFixed(2),
       签单数:0<c:forEach items="${dataList}" var="user" varStatus="ee">+${user.orderSize}</c:forEach>,
       渠道签单数:0<c:forEach items="${dataList}" var="user" varStatus="ee">+${user.orderInChannelSize}</c:forEach>,
       渠道签单数占比:(100*(0<c:forEach items="${dataList}" var="user" varStatus="ee">+${user.orderInChannelSize}</c:forEach>)/((0<c:forEach items="${dataList}" var="user" varStatus="ee">+${user.orderSize}</c:forEach>) == 0 ? 1 : (0<c:forEach items="${dataList}" var="user" varStatus="ee">+${user.orderSize}</c:forEach>))).toFixed(2),
       自主开发签单数:0<c:forEach items="${dataList}" var="user" varStatus="ee">+${user.orderInSelfSize}</c:forEach>,
       自主开发签单数占比:(100*(0<c:forEach items="${dataList}" var="user" varStatus="ee">+${user.orderInSelfSize}</c:forEach>)/((0<c:forEach items="${dataList}" var="user" varStatus="ee">+${user.orderSize}</c:forEach>) == 0 ? 1 : (0<c:forEach items="${dataList}" var="user" varStatus="ee">+${user.orderSize}</c:forEach>))).toFixed(2),
       自然到店签单数:0<c:forEach items="${dataList}" var="user" varStatus="ee">+${user.orderInAutoSize}</c:forEach>,
       自然到店签单数占比:(100*(0<c:forEach items="${dataList}" var="user" varStatus="ee">+${user.orderInAutoSize}</c:forEach>)/((0<c:forEach items="${dataList}" var="user" varStatus="ee">+${user.orderSize}</c:forEach>) == 0 ? 1 : (0<c:forEach items="${dataList}" var="user" varStatus="ee">+${user.orderSize}</c:forEach>))).toFixed(2),
       平均签单时长:'${avgTimeForOrderTotal}',
       渠道客户平均签单时长:'${avgTimeForOrderInChannelTotal}'
   }
  ];
var achievement_columns = [[
    {field:'name',title:'经理名称',width:128,align:'center',sortable:true,resizable:false},
    {field:'业绩额',title:'业绩额',width:100,align:'center',sortable:true,resizable:false},
    {field:'交定客户数',title:'交定客户数',width:100,align:'center',sortable:true,resizable:false},
    {field:'渠道交定客户数',title:'渠道交定客户数',width:105,align:'center',sortable:true,resizable:false},
    {field:'渠道交定客户数占比',title:'渠道交定客户数占比(%)',width:145,align:'center',sortable:true,resizable:false},
    {field:'自主开发交定客户数',title:'自主开发交定客户数',width:135,align:'center',sortable:true,resizable:false},
    {field:'自主开发交定客户数占比',title:'自主开发交定客户数占比(%)',width:175,align:'center',sortable:true,resizable:false},
    {field:'自然到店交定客户数',title:'自然到店交定客户数',width:135,align:'center',sortable:true,resizable:false},
    {field:'自然到店交定客户数占比',title:'自然到店交定客户数占比(%)',width:175,align:'center',sortable:true,resizable:false},
    {field:'预售客户数',title:'预售客户数',width:100,align:'center',sortable:true,resizable:false},
    {field:'渠道预售客户数',title:'渠道预售客户数',width:105,align:'center',sortable:true,resizable:false},
    {field:'渠道预售客户数占比',title:'渠道预售客户数占比(%)',width:145,align:'center',sortable:true,resizable:false},
    {field:'自主开发预售客户数',title:'自主开发预售客户数',width:135,align:'center',sortable:true,resizable:false},
    {field:'自主开发预售客户数占比',title:'自主开发预售客户数占比(%)',width:175,align:'center',sortable:true,resizable:false},
    {field:'自然到店预售客户数',title:'自然到店预售客户数',width:135,align:'center',sortable:true,resizable:false},
    {field:'自然到店预售客户数占比',title:'自然到店预售客户数占比(%)',width:175,align:'center',sortable:true,resizable:false},
    {field:'签单数',title:'签单数',width:100,align:'center',sortable:true,resizable:false},
    {field:'渠道签单数',title:'渠道签单数',width:100,align:'center',sortable:true,resizable:false},
    {field:'渠道签单数占比',title:'渠道签单数占比(%)',width:145,align:'center',sortable:true,resizable:false},
    {field:'自主开发签单数',title:'自主开发签单数',width:105,align:'center',sortable:true,resizable:false},
    {field:'自主开发签单数占比',title:'自主开发签单数占比(%)',width:150,align:'center',sortable:true,resizable:false},
    {field:'自然到店签单数',title:'自然到店签单数',width:105,align:'center',sortable:true,resizable:false},
    {field:'自然到店签单数占比',title:'自然到店签单数占比(%)',width:150,align:'center',sortable:true,resizable:false},
    {field:'平均签单时长',title:'平均签单时长',width:130,align:'center',sortable:true,resizable:false},
    {field:'渠道客户平均签单时长',title:'渠道客户平均签单时长',width:145,align:'center',sortable:true,resizable:false}
  ]];
$(document).ready(function(){
    battlefieldReport.init('efficiency_checkbox','efficiency_1','efficiency_total',efficiency,efficiency_total,efficiency_columns);
    battlefieldReport.init('achievement_checkbox','achievement_1','achievement_total',achievement,achievement_total,achievement_columns);

});
</script>