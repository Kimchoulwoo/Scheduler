<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="./js/jquery-3.3.1.js"></script>
<link rel="stylesheet" type="text/css" href="./css/main.css?20190224" />
<title>Search</title>
</head>
<body>
	<input type="hidden" id="seq_Array" value="${seq_Array }">
	<div class="search">
		<div class="search_head">
			<div class="search_title">
				<h1>맴버검색</h1>
			</div>
		</div>
		<div class="search_body">
			<div class="search_input">
				<table id="search_table">
					<thead>
						<tr>
							<td colspan="3" style="text-align: right;">
							<select	name="items" id="search_option">
									<option value="mem_name">이름</option>
									<option value="mem_dep">부서</option>
									<option value="mem_rank">직급</option>
							</select> <input type="text" id="input_search" name="input_search">
							</td>
						</tr>
						<tr>
							<th>부서</th>
							<th>직급</th>
							<th>이름</th>
						</tr>
					</thead>
					<tbody>
					</tbody>
				</table>
			</div>
		</div>
		<div class="search_foot">
			<button class="btn_submit">등록</button>
			<button class="btn_exit">취소</button>
		</div>
	</div>
</body>
<script>
	$(document).ready(function() {
		search();
	});

	//등록버튼
	$(document).on("click", ".btn_submit", function() {
		var trArray = [];
		var hiddenArray = [];

		var cf = confirm("등록하시겠습니까?");

		if (cf == true) {
			trArray.push($("#search_table").find(".click").clone());
			opener.$("#member tr").remove();
			opener.$("#member").append(trArray);

			window.close();
		} else {

		}
	});

	//취소버튼
	$(document).on("click", ".btn_exit", function() {
		window.close();
	});


	
	function search(){
		$.ajax({
			url:"./search.do",
			type:"post",
			contentType:"application/json; charset=utf-8",
			success:function(data){
					for(var i=0; i<data.length; i++){
						$("#search_table tbody").append("<tr id="+data[i].mem_seq+"><td>"+data[i].mem_dep+"</td><td>"+data[i].mem_rank+"</td><td>"+data[i].mem_name+"</td></tr>");
					}
					tr_class();
			},
			error:function(){
				
			}
		})
	}

	$(document).on("keyup","#input_search", function(){
		var option = $("#search_option option:selected").val();
		var content = $("#input_search").val();
		var obj = {"option":option, "content":content};
		$.ajax({
			url:"./search_mem.do",
			type:"post",
			data:JSON.stringify(obj),
			contentType:"application/json; charset=utf-8",
			success:function(data){
				$("#search_table tbody tr").remove();
				if(data.length>0){
					for(var i=0; i<data.length; i++){
						$("#search_table tbody").append("<tr id="+data[i].mem_seq+"><td>"+data[i].mem_dep+"</td><td>"+data[i].mem_rank+"</td><td>"+data[i].mem_name+"</td></tr>");
					}
				}else{
					$("#search_table tbody").append("<tr><td colspan='3'>조건에 맞는 맴버가 없습니다.</td></tr>");
				}
				tr_class();
			},
			error:function(){
				
			}
		}) 
	});
	
	$(document).on("click", "#search_table tbody tr", function(){
		if ($(this).hasClass("click")) {
			$(this).removeClass("click");
		} else {
			$(this).addClass("click");
		}
	});
	
	function tr_class(){
		var seq_Array = $("#seq_Array").val();
		var tr_id = seq_Array.split(",");
		for (i in tr_id) {
			for (var x = 0; x < $("#search_table tr").length; x++) {
				if (tr_id[i] == $("#search_table tr").eq(x).attr("id")) {
					$("#search_table tr").eq(x).addClass("click");
				}
			}
		}
	};
	
	
</script>

</html>