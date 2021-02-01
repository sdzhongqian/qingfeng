<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>

<script type="text/javascript">
    var setting = {
        check: {
            enable: false
        },
        data: {
            simpleData: {
                enable: true,
                idKey: "id",
                pIdKey: "parent_id",
                rootPId: 'parent'
            }
        },
        callback: {
            beforeExpand: beforeExpand,
            onExpand: onExpand,
            onClick: zTreeOnClick
        }
    };

    function beforeExpand() {
        //leftResize();
        // 防止右侧出现滚动条
    }

    function onExpand() {
        //leftResize();
        // 防止右侧出现滚动条
    }

    $(document).ready(function (){
        findTreeData(0);
    });

    //查询数据
    function findTreeData(tree_id){
        var treeNodes = '';
        $.ajax({
            url : "${pageContext.request.contextPath}/system/area/findList?level_num=2",
            data : {},
            type : 'GET',
            dataType : 'json',
            success : function(res) {
                if (res.success) {
                    treeNodes += "[{id:'0',parent_id:'parent',name:'地区管理',area_cascade:'area',level_num:'0'},";
                    $.each(res.data,function(i,n){
                        treeNodes += "{";
                        treeNodes += "id:'"+n.id+"'";
                        treeNodes += ",parent_id:'"+n.parent_id+"'";
                        treeNodes += ",name:'"+n.name+"'";
                        treeNodes += ",area_cascade:'"+n.area_cascade+"'";
                        treeNodes += ",level_num:'"+n.level_num+"'";
                        treeNodes += "},";
                    });
                    treeNodes = treeNodes.substr(0,treeNodes.length-1)+"]";
                    if(treeNodes != ']'){
                        $.fn.zTree.init($("#treeDemo"), setting ,eval(treeNodes));
                        if(tree_id==''||tree_id==null){
                            expandFirst();
                        }else{
                            expandDefault(tree_id);
                        }
                    }
                }else{
                    if(res.loseSession=='loseSession'){
                        loseSession(res.msg,res.url)
                    }else{
                        layer.msg(res.msg, {time: 2000});
                    }
                }

            },
            error : function(xhr, status) {
                alert('Sorry, there was a problem!');
            },
            complete : function(xhr, status) {
            }
        });
    }


    /*右侧默认显示*/
    function rightDefault(){
        var treeObj = $.fn.zTree.getZTreeObj("treeDemo");
        var nodes = treeObj.getNodesByFilter(filter2);
        if(nodes!=null&&nodes!=''){
            show(nodes[0].url);
        }
    }

    //展开第一个节点
    function expandFirst(){
        var treeObj = $.fn.zTree.getZTreeObj("treeDemo");
        var nodes = treeObj.getNodes();
        treeObj.expandNode(nodes[0],true,false,true,true);
        $("#tree_id").val(nodes[0].id);
        $("#tree_name").val(nodes[0].name);
        $("#area_cascade").val(nodes[0].area_cascade);
        $("#level_num").val(nodes[0].level_num);
        $("#current_dic").html("当前节点："+nodes[0].name);
        show(nodes[0].id);
        //show(nodes[0].children[0].id,nodes[0].children[0].name);
    }
    //展开指定节点
    function expandDefault(tree_id){
        var treeObj = $.fn.zTree.getZTreeObj("treeDemo");
        var nodes = treeObj.getNodeByTId(tree_id);
        var node = treeObj.getNodeByParam("id", tree_id, null);
        var ns = node.children;
        if(node.children){
            treeObj.expandNode(node,true,false,true,true);
        }else{
            var pnode = node.getParentNode();
            treeObj.expandNode(pnode,true,true,true);
        }
        $("#tree_id").val(node.id);
        $("#tree_name").val(node.name);
        $("#area_cascade").val(node.area_cascade);
        $("#level_num").val(node.level_num);
        $("#current_dic").html("当前节点："+node.name);
        show(node.id);
        //show(nodes[0].children[0].id,nodes[0].children[0].name);
    }

    /*展开全部*/
    function openAll(treeId){
        var treeObj = $.fn.zTree.getZTreeObj("treeDemo");
        treeObj.expandAll(true);
    }

    /*折叠全部*/
    function closeAll(treeId){
        var treeObj = $.fn.zTree.getZTreeObj("treeDemo");
        var node = treeObj.getNodes()[0];
        treeObj.expandNode(node, true, false, false);
        var nodes = node.children;
        $.each(nodes,function(i,n){
            treeObj.expandNode(n, false, true, false,true);
        });
    }

    /*点击时操作*/
    function zTreeOnClick(event, treeId, treeNode) {
        show(treeNode.id);
        $("#tree_id").val(treeNode.id);
        $("#tree_name").val(treeNode.name);
        $("#area_cascade").val(treeNode.area_cascade);
        $("#level_num").val(treeNode.level_num);
        $("#current_dic").html("当前节点："+treeNode.name);
    };

    //显示
    function show(id){
        reloadData(id);
    }

</script>
