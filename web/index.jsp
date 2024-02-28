<%--
  Created by IntelliJ IDEA.
  User: Losgai
  Date: 2024/2/28
  Time: 20:19
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>电子日历</title>
    <style>
        /*上个月*/
        #pre{
            position: absolute;
            top: 120px;
            left: 5%;
            width: 50px;
            height: 50px;
        }
        /*下个月*/
        #next{
            position: absolute;
            top: 120px;
            right: 5%;
            width: 50px;
            height: 50px;
        }
        /*主标题*/
        .title{
            color:black;
            font-family: "SimHei", Verdana, sans-serif;
            font-size: 25px;
            text-align:center;
        }
        /*日历主体框架*/
        .cbody ul{
            font-size: 40px;
            font-family: "SimHei", Verdana, sans-serif;
            font-weight: bold;
            width: 100%;
            box-sizing: border-box;
        }
        /*日期框架*/
        .cbody ul li{
            list-style: none;
            display: block;
            width: 14.25%;
            float: left;
            height: 40px;
            line-height: 40px;
            box-sizing: border-box;
            text-align: center;
        }
        /*年份样式*/
        .year{
            color:black;
            font-family: "SimSun", Verdana, sans-serif;
            font-size: 15px;
            font-weight:bold;
            text-align:center;
        }
        /*月份样式*/
        .month{
            color:black;
            font-family: "SimSun", Verdana, sans-serif;
            font-size: 50px;
            font-weight:bold;
            text-align:center;
        }
        /*日期样式*/
        .day{
            color:black;
            font-family: "SimSun", Verdana, sans-serif;
            font-size: 14%;
        }
        /*设置已经过去的日期颜色*/
        .pass{
            color:#979292;
        }
        /*设置将来的日期颜色*/
        .futrue{
            color:#413e3e;
        }
        /*类选择器,设置现在的日期颜色以及背景*/
        .blue{
            color:#064d66;
        }
        .blueground{
            border: 1px solid #0494b1;
            background: #b9f5f5;
        }
    </style>
</head>
<body>
<div class="calendar">
    <hr>
    <div class="title">电子日历</div>
    <hr>
    <div class="title">
        <h1 class="blue" id="month">Month</h1>
        <h2 class="blue" id="year">Year</h2>
        <a href="" id="pre">◀</a>
        <a href="" id="next">▶</a>
    </div>
    <hr>
    <div class="body">
        <div class="weeks cbody">
            <ul>
                <!--无序列表标签显示星期-->
                <li class="daybody">一</li>
                <li class="daybody">二</li>
                <li class="daybody">三</li>
                <li class="daybody">四</li>
                <li class="daybody">五</li>
                <li class="daybody">六</li>
                <li class="daybody">日</li>
            </ul>
            <!--使用无序列表标签显示日期，日期使用JavaScript动态获取，然后使用innerHTML设置<ul>标签之间的HTML-->
        </div>
        <div class="dayslist cbody">
            <ul id="days">

            </ul>
        </div>
    </div>
</div>
<script type="text/javascript">
    var month_common = [31,29,31,30,31,30,31,31,30,31,30,31];//正常月份对应的天数
    var month_leap = [31,28,31,30,31,30,31,31,30,31,30,31];//闰年月份对应的天数
    var month_name =["1月","2月","3月","4月","5月","6月","7月","8月","9月","10月","11月","12月"];//显示的月份
    //获取在标签中对应的id
    var holder = document.getElementById("days");//日期部分
    var prev = document.getElementById("prev");//上个月份的超链接id
    var next = document.getElementById("next");//下个月份的超链接id
    var ctitle = document.getElementById("month");//设置月份
    var cyear = document.getElementById("year");//设置年份
    //获取当天的年月日
    var my_date = new Date();
    var my_year = my_date.getFullYear();//获取年份
    var my_month = my_date.getMonth(); //获取月份，下标从0开始
    var my_day = my_date.getDate();//获取当前日期
    //根据年月获取当月第一天是周几
    function dayStart(month,year){
        var tmpDate = new Date(year, month, 0);
        return (tmpDate.getDay());
    }
    //区分平闰年,返回当年当月的日期
    function daysMonth(month, year){
        var tmp1 = year % 4;
        var tmp2 = year % 100;
        var tmp3 = year % 400;
        if((tmp1 == 0 && tmp2 != 0) || (tmp3 == 0)){
            return (month_leap[month]);//闰年
        }else{
            return (month_common[month]);//平年
        }
    }
    //日期样式
    function refreshDate(){
        var str = "";
        //计算当月的天数和每月第一天都是周几
        var totalDay = daysMonth(my_month,my_year);
        var firstDay = dayStart(my_month, my_year);
        //添加每个月前面的空白部分，即若某个月的第一天是从周三开始，则前面的周一，周二需要空出来
        for(var i = 0; i < firstDay; i++){
            str += "<li>"+"</li>";
        }
        //从一号开始添加到totalDay（每个月的总天数），并为pre，next和当天添加样式
        var myclass;
        for(var i = 1; i <= totalDay; i++){
            //如果是已经过去的日期，则用浅色显示
            if((my_year < my_date.getFullYear())||(my_year == my_date.getFullYear() &&
                my_month < my_date.getMonth()) || (my_year == my_date.getFullYear() &&
                my_month == my_date.getMonth() && i < my_day)){
                myclass = " class='pass'";
            }
            //如果正好是今天，则用蓝色显示
            else if(my_year == my_date.getFullYear() && my_month == my_date.getMonth() && i == my_day){
                myclass = "class = 'blue blueground'";
            }
            //将来的日期用深色显示
            else{
                myclass = "class = 'futrue'";
            }
            str += "<li "+myclass+">"+i+"</li>";
        }
        holder.innerHTML = str;//为日期的列表标签设置HTML；
        ctitle.innerHTML = month_name[my_month];//设置当前显示的月份
        cyear.innerHTML = my_year;//设置当前显示的年份
    }
    refreshDate();//显示日期，更新界面
    //上个月的点击事件
    pre.onclick = function(e){
        e.preventDefault();
        my_month--;
        if(my_month < 0){
            my_year--;
            my_month = 11;
        }
        refreshDate();//更新页面
    }
    //下个月的点击事件
    next.onclick = function(e){
        e.preventDefault();
        my_month++;
        if(my_month > 11){
            my_month = 0;
            my_year++;
        }
        refreshDate();//更新界面
    }
</script>
</body>
</html>
