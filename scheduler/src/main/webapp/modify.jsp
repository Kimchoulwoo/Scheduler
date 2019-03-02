<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
    <%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" type="text/css" href="./css/main.css?20190222" />
<link rel="stylesheet" type="text/css"
	href="./css/jquery.datetimepicker.css" />

<script type="text/javascript" src="./js/jquery-3.3.1.js"></script>
<script type="text/javascript" src="./js/moment.js"></script>
<script type="text/javascript"
	src="./js/jquery.datetimepicker.full.min.js"></script>
<title>일정 수정</title>
</head>
<body>
<div id="modify">
		<div class="title">
			<h1>일정수정</h1>
		</div>
		<div class="body">
			<div class="modal_content">
				<div class="modal_label">
					<label>제목</label>
				</div>
				<div class="modal_input">
					<input type="text" id="title" name="title" value=${map.title }>
				</div>
			</div>
			<div class="modal_content">
				<div class="modal_label">
					<label>내용</label>
				</div>
				<div class="modal_input">
					<textarea id="content" name="content">${map.content }</textarea>
				</div>
			</div>
			<div class="modal_content">
				<div class="modal_label">
					<label>시작일</label>
				</div>
				<div class="modal_input">
					<input id="datetimepicker1" type="text">
				</div>
			</div>
			<div class="modal_content">
				<div class="modal_label">
					<label>종료일</label>
				</div>
				<div class="modal_input">
					<input id="datetimepicker2" type="text">
				</div>
			</div>
			<div class="modal_content">
				<div class="modal_label">
					<label>일정공유</label>
				</div>
				<div class="modal_btn">
					<button id="btn_search">검색</button>
				</div>
			</div>
			<div class="modal_content">
				<div class="modal_member">
					<table id="member">
						<c:forEach var="mem_list" items="${list }">
							<tr id=${mem_list.mem_seq }>
								<td>${mem_list.mem_dep }</td>
								<td>${mem_list.mem_rank }</td>
								<td>${mem_list.mem_name }</td>
							</tr>
						</c:forEach>
					</table>
				</div>
			</div>
			<input type="hidden" id="seq" name="seq" value=${seq }>
		</div>
		<div class="modal_foot">
			<button id="btn_submit" class="btn_submit">등록</button>
			<button id="btn_close" class="btn_exit">취소</button>
		</div>
		
	</div>
</body>
<script>
	//create_modal : datetimepicker option
	$(document).ready(function(){
		datepicker();
		$("#datetimepicker1").val("${map.start}");
		$("#datetimepicker2").val("${map.end}");
	});
	
	function datepicker() {
		$.datetimepicker.setLocale('de');
		$('#datetimepicker1, #datetimepicker2').datetimepicker(
				{
					format : 'Y-m-d H:i',
					lang : 'ko',
					i18n : {
						de : {
							months : [ '1월', '2월', '3월', '4월', '5월', '6월',
									'7월', '8월', '9월', '10월', '11월', '12월' ],
							dayOfWeek : [ "일", "월", "화", "수", "목", "금", "토" ]
						}
					}
				});
	
		$('#datetimepicker1').datetimepicker(
				{
					onShow : function(ct) {
						this.setOptions({
							maxDate : $('#datetimepicker2').val() ? $(
									'#datetimepicker2').val() : false
						})
					}
				});
	
		$('#datetimepicker2').datetimepicker(
				{
					onShow : function(ct) {
						this.setOptions({
							minDate : $('#datetimepicker1').val() ? $(
									'#datetimepicker1').val() : false
						})
					}
				});
	};
	
	$(document).on("click", "#btn_search", function() {
		openWin();
	})

	function openWin() {
		var seq_Array = [];

		if ($("#member tr").length > 0) {
			for (var i = 0; i < $("#member tr").length; i++) {
				seq_Array.push($("#member tr").eq(i).attr("id"));
			}
			window.open("./search.do?seq_Array=" + seq_Array, "맴버검색창",
							"width=400, height=400, toolbar=no, menubar=no, scrollbars=no, resizable=yes");
		} else {
			window.open("./search.do", "맴버검색창",
							"width=400, height=400, toolbar=no, menubar=no, scrollbars=no, resizable=yes");
		}
	}
	
	
	$(document).on("click","#btn_submit",function(){
		//유효성검사
		if ($("#title").val() == "") {
			alert("제목을 입력해주세요!");
			$("#title").focus();
			return false;
		} else if ($("#content").val() == "") {
			alert("내용을 입력해주세요!");
			$("#content").focus();
			return false;
		} else if ($("#datetimepicker1").val().length < 16) {
			alert("시작일 및 시간을 선택해주세요!");
			return false;
		} else if ($("#datetimepicker2").val().length < 16) {
			alert("종료일 및 시간을 선택해주세요!");
			return false;
		} else {
			var obj_submit = new Object();
			var mem_seq_arr = [];

			obj_submit.title = $("#title").val();
			obj_submit.content = $("#content").val();
			obj_submit.writer = "<%=session.getAttribute("uid")%>";
			obj_submit.start = $("#datetimepicker1").val();
			obj_submit.end = $("#datetimepicker2").val();

			for (var i = 0; i < $("#member tr").length; i++) {
				mem_seq_arr.push($("#member tr").eq(i).attr("id"));
			}
			obj_submit.member = mem_seq_arr;
			obj_submit.seq = $("#seq").val();
			
			$.ajax({
				type : "POST",
				url : './modify.do',
				data : JSON.stringify(obj_submit),
				contentType : "application/json; charset=utf-8",
				//dataType:"json",
				success : function(data) {
					if(data == "true"){
						alert("수정 완료되었습니다.");
						location.href="./scheduler.do";
					}else{
						alert("다시 시도해주세요.");
					}
				},
				error : function(xhr, status, e) {
					alert(xhr + " // " + status + " // " + e);
				}
			})
		}
	});
	
	$(document).on("click","#btn_close", function(){
		var cf = confirm("취소하시겠습니까?");
		if(cf == true){
			location.href="./scheduler.do";
		}else{
			
		}
	});
	
</script>

</html>