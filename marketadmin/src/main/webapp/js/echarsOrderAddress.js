var nameArr = [];
var valueArr = [];
var obArr = [];

$(function () {
    var path = $("#path").val();
    var total = 0;
    var totalText = $("#total");
    $.ajax({
        method: "POST",
        url: path + "/dataAnalysisControl/findOrderAddress",
        dataType: "text",
        success: function (msg) {
            var arr = JSON.parse(msg);
            for (var i = 0; i < arr.length; i++) {
                // 普通柱状图使用的数据
                nameArr.push(arr[i].name);
                valueArr.push(arr[i].record);
                total += parseInt(arr[i].record);
                // 南丁格尔玫瑰圆饼图使用的数据
                obArr.push({
                    value: arr[i].record,
                    name: arr[i].name
                });

            }
            totalText.append(total);
            createEchars();// 创建普通柱状图
            rose();// 创建南丁格尔玫瑰圆饼图
        },
        error: function () {
            alert("服务器正忙");
        }
    });
});

//普通柱状图
function createEchars() {

    //基于准备好的dom，初始化echarts实例
    var myChart = echarts.init(document.getElementById('echarts_div'));//dark为暗黑主题 不要可以去掉
    // 指定图表的配置项和数据
    var option = {
        tooltip: {},
        legend: {
            data: ['柱状数据表']
        },
        xAxis: {
            // boundaryGap: false,
            "axisLabel": {
                interval: 0
            },
            data: nameArr
        },
        yAxis: {},
        series: [{
            name: '数据',
            type: 'bar',
            data: valueArr,
        }],

    };

    // 使用刚指定的配置项和数据显示图表。
    // myChart.setOption(option);
    myChart.setOption(option)

}

//南丁格尔玫瑰图
function rose() {

    //基于准备好的dom，初始化echarts实例
    var myChart2 = echarts.init(document.getElementById('echarts_div2'), "dark");//dark为暗黑主题 不要可以去掉

    var option = {
        title: {
            text: 'ECharts 南丁格尔玫瑰图'
        },
        series: [{
            name: '访问来源',
            type: 'pie',
            roseType: 'angle',//南丁格尔玫瑰图样式  去掉则显示基本圆饼图
            radius: '55%',
            data: obArr
        }]
    };


    myChart2.setOption(option);
}

function findOrderAddByTime() {

    var path = $("#path").val();
    var total = 0;
    var totalText = $("#total");
    var startTime = $("#beginTime").val();
    var endTime = $("#endTime").val();
    // console.log("startTime="+startTime+"&endTime="+endTime);
    var now = new Date().getTime();
    var startTimeNum = new Date(startTime).getTime();
    var endTimeNum = new Date(endTime).getTime();
    if (startTime != null & endTime != null & startTime != "" & endTime != "") {
        if (endTimeNum < now) {
            if (endTimeNum > startTimeNum) {
                // console.log("startTimeNum="+startTimeNum+"&endTimeNum="+endTimeNum);
                $.ajax({
                    method : "POST",
                    url : path + "/dataAnalysisControl/findOrderAddress",
                    data: "startTime=" + startTime+"&endTime="+endTime,
                    dataType : "text",
                    success : function(msg) {
                        var arr = JSON.parse(msg);
                        nameArr = [];
                        valueArr = [];
                        obArr = [];
                        totalText.empty();
                        for (var i = 0; i < arr.length; i++) {
                            // 普通柱状图使用的数据
                            nameArr.push(arr[i].name);
                            valueArr.push(arr[i].record);
                            total+=parseInt(arr[i].record);
                            // 南丁格尔玫瑰圆饼图使用的数据
                            obArr.push({
                                value : arr[i].record,
                                name : arr[i].name
                            });

                        }
                        totalText.append(total);
                        createEchars();// 创建普通柱状图
                        rose();// 创建南丁格尔玫瑰圆饼图
                    },
                    error : function() {
                        alert("服务器正忙");
                    }
                });
            } else {
                layer.msg("结束时间不能小于开始时间");
            }
        } else {
            layer.msg("结束时间不能大于当前日期");
        }

    } else {
        layer.msg("日期不能为空");
    }

}


$(function () {
    layui.use('laydate', function () {
        var laydate = layui.laydate;

        //执行一个laydate实例
        laydate.render({
            elem: '#beginTime' //指定元素
        });
        laydate.render({
            elem: '#endTime' //指定元素
        });
    });
})