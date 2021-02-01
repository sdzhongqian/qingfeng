// window.onbeforeunload = function(event) {
//       return "您编辑的信息尚未保存，您确定要离开吗？"//这里内容不会显示在提示框，为了增加语义化。
// };

function get_img() {
    html2canvas(document.querySelector("body")).then(function(canvas){
      $("#img_data").val(canvas.toDataURL());
      $("#demo").attr('src',canvas.toDataURL());
      post_add();
    });
}


function post_add() {
	layer.msg('正在保存', {
		icon: 16
		,shade: 0.6
	});
    $.post(save_out_url, $('.layui-form').serialize(), function(data, textStatus, xhr) {
		layer.confirm('主题保存成功，立即查看？', {
			btn: ['立即查看','关闭'] //按钮
		}, function(){
			xadmin.add_tab("主题设置",theme_url,true);
			layer.closeAll();
		}, function(){
			layer.closeAll();
		});
    });
}

layui.use(['colorpicker','form'], function(){
  var $ = layui.$
  ,colorpicker = layui.colorpicker
  ,form = layui.form;

  	$('#show_create').click(function(event) {
  		if($(this).parent().css('bottom')=='30px'){
  			$(this).parent().animate({bottom:'310px'}, 'fast');
  			$('#tool').slideDown('fast');
  		}else{
  			$(this).parent().animate({bottom:'30px'}, 'fast');
  			$('#tool').slideUp('fast');
  		}
  	});

  	form.on('submit(save_out)', function(data){
          var file = new File([set_style()+set_son_style()], "theme.min.css", {type: "text/css;charset=utf-8"});
          saveAs(file);
        return false;
    		
	   });

    form.on('submit(add)', function(data){
      set_style();
      set_son_style();
      $('#show_create').parent().animate({bottom:'30px'}, 'fast');
      $('#tool').slideUp('fast');
      $('.layui-tab-title li').eq(0).click();

		layer.prompt({title: '请输入主题名称，并确认', formType: 2}, function(text, index){
			if(text==''||text==null){
				layer.msg("请输入主题名称");
			}else{
				$("#title").val(text);
				layer.close(index);
				get_img();
			}
		});

      return false;
     });

  	form.on('switch(turn)', function(data){
  		var layui_card = $(data.elem).parents('.layui-card')
  		if(data.elem.checked){
  			var result = layui_card.find('.result');
  			var block =  layui_card.find('.layui-show-md-inline-block').clone();
  			var id =  layui_card.find('.selecter').attr('id');
  			var color = layui_card.find('input[type=hidden]').eq(0).val();
  			block.find('.selecter').attr('id',id+"_copy");
  			block.find('input').attr('name',id+'[1]');
  			result.append(block);
  			colorpicker.render({
			    elem: "#"+id+"_copy"
			    ,color: color
			    ,format: 'rgb'
			    ,predefine: true
			    ,alpha: true
			    ,done: function(color){
			      color || this.change(color); //清空时执行
			    }
			    ,change: function(color){
			      	$(this.elem).siblings('input').val(color);

			      	if($(this.elem).parent().parent().hasClass('son')){
			      		set_son_style();
			      	}else{
			      		set_style();
			      	}
			    }
			});
  		}else{
  			layui_card.find('.layui-show-md-inline-block').eq(1).remove();
  			set_style();
  		}
	  // console.log(data.elem); //得到checkbox原始DOM对象
	  // console.log(data.elem.checked); //开关是否开启，true或者false
	  // console.log(data.value); //开关value值，也可以通过data.elem.value得到
	  // console.log(data.othis); //得到美化后的DOM对象
	});

  $('.selecter').each(function(index, el) {
  		var id = $(this).attr('id');
  		var color = $(this).siblings('input').val();
  		colorpicker.render({
		    elem: '#'+id
		    ,color: color
		    ,format: 'rgb'
		    ,predefine: true
		    ,alpha: true
		    ,done: function(color){
		      color || this.change(color); //清空时执行
		    }
		    ,change: function(color){
		      	$(this.elem).siblings('input').val(color);

		      	if($(this.elem).parent().parent().hasClass('son')){
		      		set_son_style();
		      	}else{
		      		set_style();
		      	}
		    }
		});

  });

  	function set_son_style() {
  		var style = "";
	  	$('.son').each(function(index, el) {
	  		var selecter_name = $(this).attr('selecter_name');
	  		var selecter_name_attr = $(this).attr('selecter_name_attr');
	  		var color = $(this).find('input').val();
	  		color = color ? color : "rgba(0,0,0,0)";
	  		style += selecter_name+"{"+selecter_name_attr+":"+color+" !important"+";}";
	  	});

	  	var dom = $('.layui-show .x-iframe').contents();
	  	dom.find('#welcome_style').html(style);
      $('#iframe_style').val(style);
      // console.log(style);
	  	return style;
  	}

  function set_style() {
  	var style = "";
  	$('.result').each(function(index, el) {
  		var selecter_name = $(this).attr('selecter_name');
  		var selecter_name_attr = $(this).attr('selecter_name_attr');
  		if($(this).find('input').length==1){
	  		var color = $(this).find('input').val();
	  		color = color ? color : "rgba(0,0,0,0)";
	  		style += selecter_name+"{"+selecter_name_attr+":"+color+" !important"+";}";
  		}else{
  			color1 = $(this).find('input').eq(0).val();
  			color1 = color1 ? color1 : "rgba(0,0,0,0)";
  			color2 = $(this).find('input').eq(1).val();
  			color2 = color2 ? color2 : "rgba(0,0,0,0)";
  			style += selecter_name+"{"+selecter_name_attr+": linear-gradient(to left,"+color1+", "+color2+") !important;}";
  		}
  	});

  	
    // console.log(style);

  	$("#theme_style").html(style);

    $('#index_style').val(style);
  	return style;
  }

})

//
//window.onload= function () {
//    $('.left-nav #nav li').eq(0).click();
//    $('.left-nav #nav li').eq(2).click();
//}