
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html class="x-admin-sm">
<head>
    <meta charset="UTF-8">
    <title>平台商品管理</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width,user-scalable=no, minimum-scale=0.8, initial-scale=1,target-densitydpi=low-dpi" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/X-admin/lib/layui/css/layui.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/X-admin/css/font.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/X-admin/css/xadmin.css">
    <script src="${pageContext.request.contextPath}/static/X-admin/lib/layui/layui.js"></script>
    <script src="${pageContext.request.contextPath}/static/X-admin/js/xadmin.js"></script>
</head>
<body style="background-color: #bfdff6">
<div class="x-nav">
          <span class="layui-breadcrumb">
            <a href="">首页</a>
            <a href="">演示</a>
            <a><cite>导航元素</cite></a>
          </span>
    <a class="layui-btn layui-btn-small" style="line-height:1.6em;margin-top:3px;float:right" onclick="location.reload()" title="刷新"><i class="layui-icon layui-icon-refresh" style="line-height:30px"></i></a>

</div>
<div class="layui-fluid">
    <div class="layui-row layui-col-space15">
        <div class="layui-col-md12">
            <div class="layui-card">
                <div class="layui-card-header">
                    平台商品管理
                </div>
                <div class="layui-card-body">
                    <form class="layui-form layui-col-space5" lay-filter="formTest"  >
                        <div class="layui-inline layui-show-xs-block">
                            <input type="text" name="name"  placeholder="请输入商品名称" autocomplete="off" class="layui-input" id="name" >
                        </div>
<%--                        <div class="layui-inline layui-show-xs-block">--%>
<%--                            <input class="layui-input"  autocomplete="off" placeholder="开始日" name="startTime" id="startTime">--%>
<%--                        </div>--%>
<%--                        <div class="layui-inline layui-show-xs-block">--%>
<%--                            <input class="layui-input"  autocomplete="off" placeholder="截止日" name="endTime" id="endTime">--%>
<%--                        </div>--%>
                        <div class="layui-inline layui-show-xs-block">
                            <select class="layui-form-select" name="shop" ></select>
                        </div>
                        <div class="layui-inline layui-show-xs-block">
                            <button type="button" class="layui-btn"  title="搜索" lay-submit=""  lay-filter="go"><i class="layui-icon">&#xe615;</i></button>
                        </div>
                    </form>
                    <table id="list" lay-filter="test"></table>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
<script>
    layui.use(['form','table','jquery','layer','laytpl','laydate'], function(){
        var $ = layui.jquery;
        var form = layui.form;
        var table = layui.table;
        var layer = layui.layer;
        var laydate = layui.laydate;
        var laytpl = layui.laytpl;

        var path = $("#path").val();




        var tableIns = table.render({
            elem: '#list'//容器id
            ,id:'idTest'//结合checkStatus使用
            ,height: 350
            ,url: '${pageContext.request.contextPath}/goodsController/searchGoodsList' //数据接口
            ,method:'get'
            ,where: {}//查询条件
            ,request: {
                pageName: 'curPage' //改变页码的参数名称，默认：page，接在url后
                ,limitName: 'pageSize' //改变每页数据量的参数名，默认：limit，接在url后
            }
            ,page: { //可以是boolean值，也支持传入 laypage 组件的所有参数（某些参数除外，如：jump/elem,这两个参数需要将table模块的page设为false，单独使用laypage模块并render）
                layout: ['limit', 'count', 'prev', 'page', 'next', 'skip','refresh'] //自定义分页布局排版
                ,limit:6 //每页显示6条数据
                ,limits:[3,6,9,12,15,20]//可选每页分页数
                ,curr: 1 //设定初始在第 1 页
                ,groups: 3 //只显示 3 个连续页码
                ,first: '到首页' //显示首页
                ,last: '到尾页' //显示尾页
                ,theme: '#ccc75e'//主题颜色
            }
            ,parseData: function(res){ //res 即为原始返回的数据
                console.log(res);
                return {
                    "code": res.code, //解析数据接口返回状态
                    "msg": "", //解析提示文本
                    "count": res.count, //解析数据长度
                    "data": res.data //解析数据列表[]
                };
            }
            ,cols: [[ //表头
                { width:40, type:'checkbox'}//选择列，有选中的行才能通过checkStatus得到值
                ,{field: 'id', title: 'ID', width:80, sort: true}
                ,{field: 'name', title: '商品名称', width:160, sort: true}
                ,{field: 'price', title: '价格', width:100, sort: true},
                ,{field: 'stateStr', title: '商品状态', width:160, sort: true},
                ,{field: 'shopName', title: '所属店铺', width:160, sort: true}
                // ,{field: 'operation', title: '操作', width:250, sort: true,align:'center',toolbar: '#barDemo'}
            ]]
        });

        form.on('submit(go)',function (data) {
            //可设定异步数据接口的所有参数，如果不进行任何设置原参数会被保留，相当于做一次表格刷新
            // 如果设置的参数和原参数冲突将会覆盖
            // 翻页只会修改curr参数，不会修改其它任何参数
            tableIns.reload({
                where: {
                    name: data.field.name
                    ,shopId: $("select[name=shop]").children(":selected").val()
                }
                ,page: {
                    curr: 1 //重新从第 1 页开始
                }
            });
            return false;
        });


        // table.on('tool(test)', function(obj){ //注：tool 显示是工具条的事件名，test 是 table的lay-filter=属性值
        //     var data = obj.data; //获得当前行数据
        //     var layEvent = obj.event; //获得 lay-event 对应的自定义事件名（也可以是表头的 event 参数对应的事件名）
        //     var tr = obj.tr; //获得当前行 tr 的 DOM 对象（如果有的话）
        //
        //     if(layEvent!='下载'){
        //         var statusId = null;
        //         for(var i=0;i<statusParams.length;i++){
        //             if(statusParams[i].name==layEvent){
        //                 statusId=statusParams[i].value;
        //                 break;
        //             }
        //         }
        //
        //         $.ajax({
        //             url:path+"/adminController/changeFileStatus",
        //             async:false,
        //             type:"POST",
        //             data:"id="+data.id+"&statusId="+statusId+"&typeId="+data.typeId,
        //             dataType:"text",
        //             success:function(data5){
        //                 console.log(data5);
        //                 if(data5==1){
        //                     layer.msg("操作成功",{time:1000});
        //                     tableIns.reload();
        //                 }else{
        //                     layer.msg("操作失败",{time:1000});
        //                 }
        //             },
        //             error:function (xhr,textstatus) {
        //                 layer.alert("错误:"+textstatus, {icon: 2});
        //             },
        //         });
        //     }
        //
        // });



        $(function () {
            $.ajax({
                url:path+"/shopController/searchShop",
                async:false,
                type:"POST",
                dataType:"json",
                success:function(res){
                    $("select[name=shop]").append("<option value=''>分店名称</option>")
                    $(res).get().forEach(function (item) {
                        $("select[name=shop]").append("<option value='"+item.id+"'>"+item.name+"</option>")
                    });
                    form.render();
                },
                error:function (xhr,textStatus) {
                    layer.alert("错误:"+textStatus, {icon: 2});
                },
            });
        })

    });
</script>
<%--<script type="text/html" id="barDemo">--%>
<%--    {{#  if(d.statusName=='待审核'){ }}--%>
<%--    <a class="layui-btn layui-btn-xs" lay-event="下载">下载</a>--%>
<%--    <a class="layui-btn layui-btn-xs" lay-event="审核通过">审核通过</a>--%>
<%--    <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="审核不通过">审核不通过</a>--%>
<%--    {{#  }else if(d.statusName=='审核通过'){ }}--%>
<%--    <a class="layui-btn layui-btn-xs" lay-event="下载">下载</a>--%>
<%--    {{#  }if(d.statusName=='审核不通过'){ }}--%>
<%--    <a class="layui-btn layui-btn-xs" lay-event="下载">下载</a>--%>
<%--    {{#  } }}--%>
<%--</script>--%>

<input id="path" value="${pageContext.request.contextPath}">

</html>

