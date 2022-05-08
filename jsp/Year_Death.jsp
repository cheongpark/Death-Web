<%@page import="java.sql.*"%>
<%@page import="DBPKG.Util"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
request.setCharacterEncoding("UTF-8");

try {
	Connection conn = Util.getConnection();
	Statement stmt = conn.createStatement();
	//resultset 부터 updatable까지는 rs.next로 뒤 값을 읽을 수 밖에 없는데 다시 앞으로 커서를 움직이는 first를 사용하기 위해 사용

	String sql = "SELECT YEAR, DEATH FROM Y_DEATH";
	
	ResultSet rs = stmt.executeQuery(sql);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, minimum-scale=1">
    <title>연간 사망자</title>
    <link rel="stylesheet" href="../css/style.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter&display=swap" rel="stylesheet">
    <script src="https://www.gstatic.com/charts/loader.js"></script>
</head>
<body>
    <header>
        <h1>연간 사망자 수</h1>
    </header>
    <div class="movelink">
        <ul>
            <li>
                <a href="../index.jsp">Main</a>
            </li>
            <li>
                <a href="./Year_Death.jsp">Y_Death</a>
            </li>
            <li>
                <a href="./City_Death.jsp?city=강원도&year=2020">City_Death</a>
            </li>
        </ul>
    </div>
    <main>
        <div id="Y_Death_Chart"></div>
    </main>
    
    <script>
	    google.charts.load('current', {'packages':['corechart']});
	    google.charts.setOnLoadCallback(drawVisualization);
	
	    function drawVisualization() {
	        var Tjson = [['년', '사망자 수']];
	
	        //Tjson.push(['2005', 245874, 245874]);
	        <% while(rs.next()) { %>
	             Tjson.push([<%="'" + rs.getInt("year") + "'"%>, <%=rs.getInt("death")%>]);
	        <%
	        }
	        %>
	        
	        var data = google.visualization.arrayToDataTable(Tjson);
	        
	        var options = {
	            hAxis: {title: '년'},
	            series: {0: {type: 'bars', lineWidth: 3, color: '#FF0000'}},
	            backgroundColor: {fill: 'transparent'},
	            animation: {
	                duration: 1000,
	                easing: 'inAndOut',
	                startup: true
	            },
	            chartArea: {backgroundColor: 'EAEAEA', width: '80%', height: '80%'}
	        };
	        
	        var chart = new google.visualization.ComboChart(document.getElementById('Y_Death_Chart'));
	        chart.draw(data, options); 
	    }

    </script>
<%

rs.close();

} catch(Exception e) {
	e.printStackTrace();
	
}
%>
</body>
</html>