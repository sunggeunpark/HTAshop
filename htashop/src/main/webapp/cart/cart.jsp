<%@page import="com.shop.dao.UserDao"%>
<%@page import="com.shop.vo.Cart"%>
<%@page import="com.shop.vo.User"%>
<%@page import="com.shop.dao.CartDao"%>
<%@page import="java.util.List"%>
<%@page import="com.shop.dao.ProductDao"%>
<%@page import="com.shop.vo.Product"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!doctype html>
<html lang="ko">
<head>
   <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
   <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" >
   <link href="../resources/css/newstyle.css" rel="stylesheet">
    <title>HTA shop :: 장바구니 페이지</title>
</head>
<style>
img {width:50px; height:50px; }
</style>
<body>

<%
	pageContext.setAttribute("menu", "cart");
%>
<%@include file = "../common/navbar.jsp" %> 
<%//로그인 안하면 장바구니페이지로 이동 불가

	if(loginedUserInfo == null) {
		response.sendRedirect("../loginform.jsp?fail=login-required");
		return;
	}
	CartDao cartDao = CartDao.getInstance();
	ProductDao productDao = ProductDao.getInstance();

	List<Cart> carts = cartDao.selectAllCartListByUserNo(loginedUserInfo.getUserNo());
 %>
 
<div class="container">    
<div class="row justify-content-start">
	<div class="col-sm-2">
		<%@ include file="../common/left.jsp" %>
		</div>
		<div class="col-10 align-self-end">
			<div class="row mb-3">
				<div class="col-10 mb-3 ">
				<div class="row">
				</div>
					<table class="col-10 table table-hover" id="cart">
						<thead>
							<tr>
								<th>이미지</th>
								<th>상품명</th>
								<th>상품가격</th>
								<th>수량</th>
								<th>예상적립금</th>
								<th>총 결제금액</th>
								<th></th>
							</tr>
						</thead>
						<tbody>
<%
	for (Cart cart : carts) {
		Product product = productDao.getProductDetailById(cart.getProductNo());
%>						
						<tr>
							<td><img src="/htashop/resources/images/<%=product.getImage()%>"/></td>
							<td><%=product.getName() %></td>
							<td><%=product.getPrice() %>원</td>
							<td><div class="product-stock">
									<span class="minus" onclick="minus(<%=cart.getCartNo() %>)"></span>
									<input type="number" id="Qty-<%=cart.getCartNo() %>" class="count" value="<%=cart.getQuantity() %>" min="1" max="20" />
									<span class="plus" onclick="plus(<%=cart.getCartNo() %>)"></span>

									<button class="btn-modify btn-dark btn-sm" type="button" onclick="changeQty(<%=cart.getCartNo() %>)">변경</button>
								</div>
								</td>
							<td><%=Math.round(product.getPrice() * cart.getQuantity() * 0.01) %>원</td>
							<td><%=product.getPrice() * cart.getQuantity()%>원</td>
							<td>
							<button type="button" class="btn btn-outline-dark btn-sm" onclick="deletedCart(<%=cart.getCartNo()  %>)">삭제</button>
							</td>
						</tr>
<%
}
%>
						</tbody>
					</table>
					<div class="text-center">
						<a class="btn btn-lg btn-warning" href="../order/orderCartForm.jsp" >주문하기</a>
					</div>		
				</div>
			</div>
		</div>
	</div>
</div>

		
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<script type="text/javascript">
function plus(cartNo) {
	var count = Number(document.getElementById("Qty-" + cartNo).value);
	if(count < 20) {
		count ++;
	} else {
		count;
	}
	document.getElementById("Qty-" + cartNo).value = count;
}

function minus(cartNo) {
	var count = Number(document.getElementById("Qty-" + cartNo).value);
	if(count > 1) {
		count--;
	} else {
		count;
	}
	document.getElementById("Qty-" + cartNo).value = count;
}

function changeQty(cartNo) {
	var Qty = document.getElementById("Qty-" + cartNo).value;
	location.href = "changeQuantity.jsp?no=" + cartNo + "&quantity=" + Qty;
}

function deletedCart(cartNo) {
	location.href = "deleteCart.jsp?no=" + cartNo; 
}


</script>
</body>
</html>