<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page isELIgnored="false" %>

<html>
<head>
    <meta charset="utf-8">
    <title>Edit Book</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/lib/layui-v2.5.5/css/layui.css" media="all">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/public.css" media="all">
    <style>
        body {
            background-color: #ffffff;
        }
    </style>
</head>
<body>
<div class="layui-form layuimini-form">
    <input type="hidden" name="id"   value="${info.id}">
    <div class="layui-form-item">
        <label class="layui-form-label required">Book Name</label>
        <div class="layui-input-block">
            <input type="text" name="name" lay-verify="required"  value="${info.name}" class="layui-input">
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label required">Book Number</label>
        <div class="layui-input-block">
            <input type="text" name="isbn" lay-verify="required"value="${info.isbn}"  class="layui-input">
        </div>
    </div>

    <div class="layui-form-item">
        <label class="layui-form-label required">Book Category</label>
        <div class="layui-input-block">
            <select name="typeId" id="typeId" lay-verify="required">
                <option value="${info.typeId}">Please select</option>
            </select>
        </div>
    </div>

    <div class="layui-form-item">
        <label class="layui-form-label required">Book Author</label>
        <div class="layui-input-block">
            <input type="text" name="author" lay-verify="required" value="${info.author}"   class="layui-input">
        </div>
    </div>

    <div class="layui-form-item">
        <label class="layui-form-label required">Book Publisher</label>
        <div class="layui-input-block">
            <input type="text" name="publish" lay-verify="required" value="${info.publish}"   class="layui-input">
        </div>
    </div>

    <div class="layui-form-item">
        <label class="layui-form-label required">Book Language</label>
        <div class="layui-input-block">
            <input type="text" name="language"  value="${info.language}"   class="layui-input">
        </div>
    </div>

    <div class="layui-form-item">
        <label class="layui-form-label required">Book Price</label>
        <div class="layui-input-block">
            <input type="number" name="price"  value="${info.price}"   class="layui-input">
        </div>
    </div>

    <div class="layui-form-item">
        <label class="layui-form-label">Publish Date</label>
        <div class="layui-input-block">
            <input type="text" name="publishDate" id="date"
                   value="<fmt:formatDate value="${info.publishDate}" pattern="yyyy-MM-dd"/>"
                   lay-verify="date" autocomplete="off" class="layui-input"/>
        </div>
    </div>

    <div class="layui-form-item layui-form-text">
        <label class="layui-form-label">Book Introduction</label>
        <div class="layui-input-block">
            <textarea name="introduction" class="layui-textarea" placeholder="Please enter introduction information">${info.introduction}</textarea>
        </div>
    </div>

    <div class="layui-form-item">
        <div class="layui-input-block">
            <button class="layui-btn layui-btn-normal" lay-submit lay-filter="saveBtn">Confirm modification</button>
        </div>
    </div>
</div>
<script src="${pageContext.request.contextPath}/lib/layui-v2.5.5/layui.js" charset="utf-8"></script>
<script>
    layui.use(['form','laydate'], function () {
        var form = layui.form,
            layer = layui.layer,
            laydate=layui.laydate,
            $ = layui.$;

        //Date
        laydate.render({
            elem: '#date',
            trigger:'click'
        });

        //Get book type data dynamically
        $.get("findAllList",{},function (data) {
            //Get book type value
            var typeId=$('#typeId')[0].value;
            var list=data;
            var select=document.getElementById("typeId");
            if(list!=null|| list.size()>0){
                for(var c in list){
                    var option=document.createElement("option");
                    option.setAttribute("value",list[c].id);
                    option.innerText=list[c].name;
                    select.appendChild(option);
                    //If the type is the same as the ID in the loop, select it
                    if (list[c].id==typeId){
                        option.setAttribute("selected","selected");
                        layui.form.render('select');
                    }
                }
            }
            form.render('select');
        },"json")

        //Submit listener
        form.on('submit(saveBtn)', function (data) {
            var datas=data.field;//Data information in the form
            //Send data to the background to submit the addition
            $.ajax({
                url:"updateBookSubmit",
                type:"POST",
                // data:datas,
                contentType:'application/json',
                data:JSON.stringify(datas),
                success:function(result){
                    if(result.code==0){//If successful
                        layer.msg('Modification succeeded',{
                            icon:6,
                            time:500
                        },function(){
                            parent.window.location.reload();
                            var iframeIndex = parent.layer.getFrameIndex(window.name);
                            parent.layer.close(iframeIndex);
                        })
                    }else{
                        layer.msg("Modification failed");
                    }
                }
            })
            return false;
        });
    });
</script>

</body>
</html>

