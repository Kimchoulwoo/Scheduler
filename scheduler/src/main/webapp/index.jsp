<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인</title>
<script src="./js/jquery-3.3.1.js"></script>
<style rel="stylesheet">
@charset "UTF-8";

@import url(https://fonts.googleapis.com/css?family=Lato:400,700);

* {
	-moz-box-sizing: border-box;
	-webkit-box-sizing: border-box;
	box-sizing: border-box;
}

body {
	font-family: 'Lato', sans-serif;
	background-color: #f8f8f8;
}

body .container {
	position: relative;
	overflow: hidden;
	width: 350px;
	height: 500px;
	margin: 80px auto 0;
	background-color: #ffffff;
	-moz-box-shadow: rgba(0, 0, 0, 0.1) 0px 10px 30px;
	-webkit-box-shadow: rgba(0, 0, 0, 0.1) 0px 10px 30px;
	box-shadow: rgba(0, 0, 0, 0.1) 0px 10px 30px;
	padding: 58px 40px 0;
}

body .container h1 {
	font-size: 18px;
	font-weight: 700;
	margin-bottom: 23px;
	text-align: center;
	text-indent: 6px;
	letter-spacing: 7px;
	text-transform: uppercase;
	color: #263238;
}

body .container .tabs {
	width: 100%;
	margin-bottom: 29px;
	border-bottom: 1px solid #d9d9d9;
}

body .container .tabs .tab {
	display: inline-block;
	margin-bottom: -1px;
	padding: 20px 15px 10px;
	cursor: pointer;
	letter-spacing: 0;
	border-bottom: 1px solid #d9d9d9;
	-moz-user-select: -moz-none;
	-ms-user-select: none;
	-webkit-user-select: none;
	user-select: none;
	transition: all 0.1s ease-in-out;
}

body .container .tabs .tab a {
	font-size: 11px;
	text-decoration: none;
	text-transform: uppercase;
	color: #d9d9d9;
	transition: all 0.1s ease-in-out;
}

body .container .tabs .tab.active a, body .container .tabs .tab:hover a
	{
	color: #263238;
}

body .container .tabs .tab.active {
	border-bottom: 1px solid #263238;
}

body .container .content label {
	font-size: 12px;
	color: #263238;
	-moz-user-select: -moz-none;
	-ms-user-select: none;
	-webkit-user-select: none;
	user-select: none;
}

body .container .content input.inpt {
	font-size: 14px;
	display: block;
	width: 100%;
	height: 42px;
	margin-bottom: 12px;
	padding: 16px 13px;
	color: #999999;
	border: 1px solid #d9d9d9;
	background: transparent;
	-moz-border-radius: 2px;
	-webkit-border-radius: 2px;
	border-radius: 2px;
}

body .container .content input.inpt:focus {
	border-color: #999999;
}

body .container .content .submit {
	font-size: 12px;
	line-height: 42px;
	display: block;
	width: 100%;
	height: 42px;
	cursor: pointer;
	vertical-align: middle;
	letter-spacing: 2px;
	text-transform: uppercase;
	color: #263238;
	border: 1px solid #263238;
	background: transparent;
	-moz-border-radius: 2px;
	-webkit-border-radius: 2px;
	border-radius: 2px;
}

body .container .content .submit:hover {
	background-color: #263238;
	color: #ffffff;
	-moz-transition: all 0.2s;
	-o-transition: all 0.2s;
	-webkit-transition: all 0.2s;
	transition: all 0.2s;
}

body .container .content input:focus {
	outline: none;
}

body .container .content .submit-wrap {
	bottom: 0;
	width: 100%;
	margin-top:20px;
}

body .container .content .submit-wrap a {
	font-size: 12px;
	display: block;
	margin-top: 20px;
	text-align: center;
	text-decoration: none;
	color: #999999;
}

body .container .content .submit-wrap a:hover {
	text-decoration: underline;
}

body .container .content .signup-cont {
	display: none;
}

</style>
</head>
<body>

	<section class="container">
		<article class="half">
			<h1>Scheduler</h1>
			<div class="tabs">
				<span class="tab signin active"><a href="#signin">로그인</a></span>
				<span class="tab signup"><a href="#signup">회원가입</a></span>
			</div>
			<div class="content">
				<div class="signin-cont cont">
					<div class="signin_inputBox">
						<form action="./login.do" method="post" onsubmit="return loginForm();">
							<label for="uid">ID</label> 
							<input type="text" name="user_id" id="user_id" class="inpt" required="required"> 
							<label for="password">Password</label>
							<input type="password" name="user_pw" id="user_pw" class="inpt" required="required">
							<div class="submit-wrap">
								<input type="submit" value="로그인" class="submit" id="btn_login">
							</div> 
						</form>
					</div>
					
				</div>
				<div class="signup-cont cont">
						<label for="uid">ID</label> 
						<input type="text" name="join_id" id="join_id" class="inpt" required="required"> 
						<label for="password">Password</label>
						<input type="password" name="join_pw" id="join_pw" class="inpt" required="required"> 
						<label for="name">Name</label>	 
						<input type="text" name="join_name" id="join_name" class="inpt" required="required">
					<div class="submit-wrap">
							   <button class="submit" id="btn_join">회원가입</button>
						</div>
				</div>
			</div>
		</article>
	</section>

</body>
<script>
	//로그인실패시
	$(document).ready(function() {
		var responseMessage = "<c:out value="${message}" />";
		if (responseMessage != "") {
			alert(responseMessage);
			$("#user_id").focus();

		}
	})

	$('.tabs .tab').click(function() {
		if ($(this).hasClass('signin')) {
			$('.tabs .tab').removeClass('active');
			$(this).addClass('active');
			$('.cont').hide();
			$('.signin-cont').show();
		}
		if ($(this).hasClass('signup')) {
			$('.tabs .tab').removeClass('active');
			$(this).addClass('active');
			$('.cont').hide();
			$('.signup-cont').show();
		}
	});
	
	function loginForm(){
		if($("#user_id").val() == ""){
			alert("아이디를 입력해주세요");
			$("#user_id").focus();
			return false;
		}else if($("#user_pw").val() == ""){
			alert("비밀번호를 입력해주세요");
			$("#user_pw").focus();
			return false;
		}else{
			return true;
		}
	}
	
	
	
	$(document).on("click","#btn_join",function(){
		if($("#join_id").val() == ""){
			alert("아이디를 입력해주세요");
			$("#join_id").focus();
			return false;
		}else if($("#join_pw").val() == ""){
			alert("비밀번호를 입력해주세요");
			$("#join_pw").focus();
			return false;
		}else if($("#join_name").val() == ""){
			alert("이름을 입력해주세요");
			$("#join_name").focus();
			return false;
		}else{
			var obj = {"id":$("#join_id").val(), "pw":$("#join_pw").val(), "name":$("#join_name").val()}
			
			$.ajax({
				url:"./join.do",
				type:"post",
				data:JSON.stringify(obj),
				contentType:"application/json; charset=utf-8",
				success:function(data){
					alert(data);
					$('.signup').removeClass('active');
					$(".signin").addClass('active');
					$('.cont').hide();
					$('.signin-cont').show();
				},
				error:function(){
					alert();
				}
			})
		}
	});
	

</script>


</html>