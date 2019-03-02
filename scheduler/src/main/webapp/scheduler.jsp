<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>일정관리</title>
<link rel="stylesheet" type="text/css" href="./css/fullcalendar.css" />
<link rel="stylesheet" type="text/css" href="./css/fullcalendar.min.css" />
<link rel="stylesheet" type="text/css" href="./css/main.css?20190222" />
<link rel="stylesheet" type="text/css" href="./css/jquery.datetimepicker.css" />

<script type="text/javascript" src="./js/jquery-3.3.1.js"></script>
<script type="text/javascript" src="./js/moment.js"></script>
<script type="text/javascript" src="./js/fullcalendar.js"></script>
<script type="text/javascript" src="./js/jquery.datetimepicker.full.min.js"></script>

</head>
<body>
	<div id="calendar"></div>

	<div id="create_modal">
		<div class="modal_title">
			<h1>일정등록</h1>
		</div>
		<div class="modal_body">
			<div class="modal_content">
				<div class="modal_label">
					<label>제목</label>
				</div>
				<div class="modal_input">
					<input type="text" id="title" name="title">
				</div>
			</div>
			<div class="modal_content">
				<div class="modal_label">
					<label>내용</label>
				</div>
				<div class="modal_input">
					<textarea id="content" name="content"></textarea>
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
					</table>
				</div>
			</div>
		</div>
		<div class="modal_foot">
			<button id="btn_submit" class="btn_submit">등록</button>
			<button class="btn_exit">취소</button>
		</div>
	</div>

	<div id="modify_modal">
		<div class="modal_title">
			<h1 id="read_title">일정</h1>
		</div>
		<div class="modal_body">
			<div class="modify_content">
				<div class="modify_left">
					<label>내용</label>
				</div>
				<div class="modify_right">
					<textarea id="read_content" readonly="readonly"></textarea>
				</div>
			</div>
			<div class="modify_content">
				<div class="modify_left">
					<label>기간</label>
				</div>
				<div class="modify_right">
					<label id="read_date"></label>
				</div>
			</div>
			<div class="modify_content">
				<div class="modify_left">
					<label>작성자</label>
				</div>
				<div class="modify_right">
					<label id="read_writer"></label>
				</div>
			</div>
			<div class="modify_content">
				<div class="modify_left">
					<label>맴버</label>
				</div>
			</div>
			<div class="modify_content">
				<div class="modify_member">
					<table id="modify_table">
					</table>
				</div>
			</div>
			<input type='hidden' name='seq' value="" id="seq">
		</div>
		<div class="modal_foot">
			<button id="btn_modify" class="btn_submit">수정</button>
			<button id="btn_delete" class="btn_submit">삭제</button>
			<button class="btn_exit">취소</button>
		</div>
	</div>
</body>
<script>
	$(document).ready(function() {
		datepicker();
		fullcalendar();
	});

	function fullcalendar() {
		$('#calendar').fullCalendar({
							customButtons:{
								logoutBtn:{
									text:'logout',
									click:function(){
										logout();
									}	
								}
							},
							header : {
								left : 'prev,next',
								center : 'title',
								right : 'month,basicWeek,basicDay,logoutBtn'
							},
							views:{
								month: {
								  titleFormat : "YYYY년 MMMM"
								  },
								week:{
									titleFormat:"YYYY년 MMMM DD일"
								},
								day:{
									titleFormat:"YYYY년 MMMM DD일"
								}
							},
							monthNames : [ "1월", "2월", "3월", "4월", "5월", "6월","7월", "8월", "9월", "10월", "11월", "12월" ],
							monthNamesShort : [ "1월", "2월", "3월", "4월", "5월","6월", "7월", "8월", "9월", "10월", "11월", "12월" ],
							dayNames : [ "일요일", "월요일", "화요일", "수요일", "목요일","금요일", "토요일" ],
							dayNamesShort : [ "일", "월", "화", "수", "목", "금", "토" ],
							buttonText : {
								today : "오늘",
								month : "월별",
								week : "주별",
								day : "일별"
							},
							navLinks : true, // can click day/week names to navigate views
							editable : true,
							eventLimit : true, // allow "more" link when too many events
							nextDayThreshold : "00:00", // 이벤트종료일 표시 기준 시간대설정
							dayClick : function(date, jsEvent, view) {
								modal_open("create_modal");
								$('#datetimepicker1, #datetimepicker2').val(
										date.format());
							},
							eventSources : [
									{
										events : function(start, end, timezone,callback) {
											var obj = {
												"start" : start.format(),
												"end" : end.format()
											}
											$.ajax({
														type : 'post',
														url : './list.do',
														data : JSON.stringify(obj),
														contentType : "application/json; charset=utf-8",
														success : function(data) {
															var list = data;
															var events = [];
															for (var i = 0; i < list.length; i++) {
																events.push({
																			start : list[i].start,
																			end : list[i].end,
																			title : list[i].title,
																			id : list[i].seq
																		})
															}
															callback(events);
														},
														error : function() {

														},
													})
										},

									},
									{
										events : function(start, end, timezone,callback) {
											var obj = {
												"start" : start.format(),
												"end" : end.format()
											}
											$.ajax({
														type : 'post',
														url : './sharelist.do',
														data : JSON.stringify(obj),
														contentType : "application/json; charset=utf-8",
														success : function(data) {
															var list = data;
															var events = [];
															for (var i = 0; i < list.length; i++) {
																events.push({
																			start : list[i].start,
																			end : list[i].end,
																			title : list[i].title,
																			id : list[i].seq
																		})
															}
															callback(events);
														},
														error : function() {

														},
													})

										},
										color : '#50bb5e',
										textColor : 'white'
									} ],
							timeFormat : 'HH:mm',
							eventClick : function(calEvent, jsEvent, view) {
								// console.log($("#myCalendar").fullCalendar( 'clientEvents', eventId ));
								//alert('Event: ' + calEvent.id);
								modal_open("modify_modal",calEvent.id);
							}
						})
	}

	//modal open
	function modal_open(name, seq) {
		if($("#create_modal").css("display")=='none' && $("#modify_modal").css("display")=='none'){
			$("#" + name).toggle();
			if(name == "modify_modal"){
				$.ajax({
					url:"./read.do",
					type:"post",
					contentType:"application/json; charset=utf-8",
					data:JSON.stringify({"seq":seq}),
					success:function(data){
						$("#seq").val(data[0].seq);
						$("#read_title").text(data[0].title);
						$("#read_content").val(data[0].content);
						var date = data[0].start + " ~ " + data[0].end;
						$("#read_date").text(date);
						var writer = data[0].writer +"("+data[0].writer_id+")";
						$("#read_writer").text(writer);
						if(data.length>2){
							for(var i=1; i<data.length; i++){
								$("#modify_table").append("<tr id="+data[i].mem_seq+"><td>"+data[i].mem_dep+"</td><td>"+data[i].mem_rank+"</td><td>"+data[i].mem_name+"</td></tr>");
							}
						}else{
							$("#modify_table").append("<tr><td colspan='3'>공유된 맴버 없음</tr>");
						}
					},
					error:function(){
						
					}
				})
			}
		}else{
			alert("창을 닫고 실행해주세요");
		}

	}

	//modal close
	$(document).on("click", ".btn_exit", function() {
		var name = $(this).parent().parent().attr("id");

		//create_modal : reset
		if (name == "create_modal") {
			$("#title").val("");
			$("#content").val("");
			$('#datetimepicker1, #datetimepicker2').datetimepicker("reset");
			$("#member tr").remove();
		}

		//modify_modal : reset
		if (name == "modify_modal") {
			$("#seq").val("");
			$("#read_title").text("");
			$("#read_content").val("");
			$("#read_date").text("");
			$("#read_writer").text("");
			$("#modify_table tr").remove();
		}

		$("#" + name).toggle();
	})

	//create_modal : datetimepicker option
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
	}

	//create_modal : search.jsp btn
	$(document).on("click", "#btn_search", function() {
		openWin();
	})

	//create_modal : search.jsp window open
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

	//create_modal : submit btn
	$(document).on("click","#btn_submit",function() {
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

					$.ajax({
						type : "POST",
						url : './submit.do',
						data : JSON.stringify(obj_submit),
						contentType : "application/json; charset=utf-8",
						//dataType:"json",
						success : function(data) {
							alert(data);

							//create_modal : reset
							$("#title").val("");
							$("#content").val("");
							$('#datetimepicker1, #datetimepicker2')
									.datetimepicker("reset");
							$("#member tr").remove();
							$("#create_modal").toggle();

							location.reload();

						},
						error : function(xhr, status, e) {
							alert(xhr + " // " + status + " // " + e);
						}
					})
				}
			});
	
	//modify btn : id confirm
	function id_confirm(){
		var uid = "<%=session.getAttribute("uid") %>";
		var s = $("#read_writer").text().indexOf("(");
		var e = $("#read_writer").text().indexOf(")");
		var writer = $("#read_writer").text().substring(s+1,e);
		if(uid != writer){
			return "fail"
		}else{
			return "success"
		}
	}
	
	$(document).on("click","#btn_modify", function(){
		var seq = $("#seq").val();
		if(id_confirm() == "success"){
			var cf = confirm("수정하시겠습니까?");
			if(cf == true){
				location.href="./modify.do?seq="+seq;
			}else{
				
			}
		}else{
			alert("등록하신 분만 수정이 가능합니다");
		}
	});
	
	$(document).on("click","#btn_delete",function(){
		var obj= {"seq":$("#seq").val()};
		if(id_confirm() =="success"){
			var cf = confirm("정말 삭제하시겠습니까?");
			if(cf == true){
				$.ajax({
					url:"./delete.do",
					data:JSON.stringify(obj),
					type:"post",
					contentType:"application/json; charset=utf-8",
					success:function(data){
						if(data=="true"){
							alert("삭제되었습니다.");
							location.reload();
						}else{
							alert("삭제 실패!");
						}
					},
					error : function(xhr, status, e) {
						alert(xhr + " // " + status + " // " + e);
					}
				});
			}else{
				
			}
		}else{
			alert("등록하신 분만 삭제가 가능합니다");
		}
	});
	
	function logout(){
		$.ajax({
			url:"./logout.do",
			type:"post",
			success:function(data){
				alert(data);
				location.href="./index.do";
			},error:function(){
				
			}
		})
	}
			
			
</script>

</html>