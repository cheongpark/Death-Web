<%@page import="java.text.DecimalFormat"%>
<%@page import="java.sql.*"%>
<%@page import="DBPKG.Util"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%
request.setCharacterEncoding("UTF-8");

try {
	DecimalFormat formatter = new DecimalFormat("###,###"); //숫자에 콤마 표시
	String City = request.getParameter("city"); //주소의 파라메터 값을 가져오는 거
	int Year = Integer.parseInt(request.getParameter("year")); //주소의 파라메터 값을 가져오는 거
	
	Connection conn = Util.getConnection();
	
	Statement City_Kind_stmt = conn.createStatement();
	Statement Year_Kind_stmt = conn.createStatement();
	
	Statement Cause_Death_stmt = conn.createStatement();
	Statement Chart_Year_Death_stmt = conn.createStatement();
	Statement Chart_Year_Age_Death_stmt = conn.createStatement();
	
	Statement Year_Min_Max_stmt = conn.createStatement();
	
	//Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE);
	//resultset 부터 updatable까지는 rs.next로 뒤 값을 읽을 수 밖에 없는데 다시 앞으로 커서를 움직이는 first를 사용하기 위해 사용

	String S_City_Kind = "SELECT DISTINCT CITY FROM C_DEATH ORDER BY 1";
	String S_Year_Kind = "SELECT DISTINCT YEAR FROM C_DEATH ORDER BY 1 DESC";
	
	String S_Cause_Death_log = "SELECT DISTINCT YEAR, CAUSE, CITY, SUM(DEATH) DEATH FROM C_DEATH GROUP BY CAUSE, YEAR, CITY ORDER BY 1";
	String S_Chart_Year_Death = "SELECT DISTINCT CITY, YEAR, SUM(DEATH) DEATH FROM C_DEATH GROUP BY CITY, YEAR ORDER BY 1";
	String S_Chart_Year_Age_Death = "SELECT DISTINCT CITY, YEAR, AGE, SUM(DEATH) DEATH FROM C_DEATH GROUP BY CITY, YEAR, AGE ORDER BY 1";
	
	String S_Year_Min_Max = "SELECT MAX(YEAR) MAX, MIN(YEAR) MIN FROM C_DEATH";
	
	ResultSet City_Kind = City_Kind_stmt.executeQuery(S_City_Kind);
	ResultSet Year_Kind = Year_Kind_stmt.executeQuery(S_Year_Kind);
	
	ResultSet Cause_Death_log = Cause_Death_stmt.executeQuery(S_Cause_Death_log);
	ResultSet Chart_Year_Death = Chart_Year_Death_stmt.executeQuery(S_Chart_Year_Death);
	ResultSet Chart_Year_Age_Death = Chart_Year_Age_Death_stmt.executeQuery(S_Chart_Year_Age_Death);
	
	ResultSet Year_Min_Max = Year_Min_Max_stmt.executeQuery(S_Year_Min_Max);
	
	Year_Min_Max.next();
	if(Year > Year_Min_Max.getInt("MAX") || Year < Year_Min_Max.getInt("MIN")) 
		Year = Year_Min_Max.getInt("MAX");
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
        <h1><%= City%> 사망자 수</h1>
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
    <nav>
        <div class="menu">
        	<form action="City_Death.jsp" class="menu">
	        	<select class="citylist" name="city">
	            <% while(City_Kind.next()) { %>
	            	<option value="<%=City_Kind.getString("CITY")%>" <% if(City.equals(City_Kind.getString("CITY"))) out.println("selected");%>><%=City_Kind.getString("CITY")%></option>
	            <%
		        }
		        %>
	            </select>
	            <select class="yearlist" name="year">
	           	<% while(Year_Kind.next()) { %>
	               	<option value="<%=Year_Kind.getInt("YEAR")%>" <% if(Year_Kind.getInt("YEAR") == Year) out.println("selected");%>><%=Year_Kind.getInt("YEAR") + "년"%></option>
	        	<%
		        }
		        %>
	            </select>
	            <input class="loadb" type="submit" value="불러오기"></input>
        	</form>
        </div>
    </nav>
    <main>
        <div class="mleft">
            <div id="chart1">
                <div class="chart1list">
                <% while(Cause_Death_log.next()) { 
                	if((Cause_Death_log.getInt("YEAR") == Year) && (City.equals(Cause_Death_log.getString("CITY")))) {%>
                    <div class="list">
                        <h3><%= Cause_Death_log.getString("CAUSE")%></h3>
                        <div class="numbox">
                            <div class="numwhitebox">
                            	<%= formatter.format(Cause_Death_log.getInt("DEATH")) %>
                            </div>
                            <h3>명</h3>
                        </div>
                    </div>
                    <%}}%>
                </div>
            </div>
            <div id="chart2"></div>
        </div>
        <div class="mright">
            <div id="chart3"></div>
            <p class="chart3des">
                못 계집애들의 이름자 이국 이름과, 비둘기, 아직 있습니다. 무엇인지 사람들의 딴은 한 까닭입니다. 때 청춘이 것은 프랑시스 별 차 피어나듯이 북간도에 봅니다. 이름과, 때 옥 나는 언덕 어머님, 딴은 다 계절이 까닭입니다. 프랑시스 마디씩 이름과, 봄이 경, 나의 듯합니다. 않은 무엇인지 내 나는 마리아 거외다. 계절이 묻힌 풀이 하나에 별을 다 하나 버리었습니다. 지나가는 릴케 별빛이 말 우는 까닭입니다. 잔디가 말 너무나 가난한 위에 있습니다. 아직 이런 까닭이요, 북간도에 까닭이요, 언덕 다하지 거외다.
            </p>
        </div>
    </main>
    
    <script>
	    google.charts.load('current', {'packages':['corechart']});
	    google.charts.setOnLoadCallback(drawVisualization);
	
	    function drawVisualization() {
	        var Tjson = [['년', '사망자 수', '사망자 수', { role: 'style' }]];
	
	        <% while(Chart_Year_Death.next()) { 
            	if(City.equals(Chart_Year_Death.getString("CITY"))) {%>
	        Tjson.push(["<%= Chart_Year_Death.getInt("YEAR")%>", <%= Chart_Year_Death.getInt("DEATH")%>, <%= Chart_Year_Death.getInt("DEATH")%>, "<% if(Chart_Year_Death.getInt("YEAR") == Year) out.print("color: #FF0000"); else out.print("color: #000000");%>"]);
			<%}}%>
	        
	        var data = google.visualization.arrayToDataTable(Tjson);
	        
	        var options = {
	            series: {0: {type: 'line', lineWidth: 1, color: '#000000'}, 1: {type: 'scatter'}},
	            legend: 'none',
	            pointSize: 5,
	            backgroundColor: {fill: '#EAEAEA'},
	            chartArea: {width: '90%'},
	            hAxis: {viewWindow: {min: <%=(Year - Year_Min_Max.getInt("MIN"))%> - 2, max: <%=(Year - Year_Min_Max.getInt("MIN"))%> + 3}},
	            vAxis: {textPosition: 'none', gridlines: {color: 'transparent'}}
	        };
	        
	        var chart = new google.visualization.ComboChart(document.getElementById('chart2'));
	        chart.draw(data, options); 
	    }
    </script>
    <script>
	    google.charts.load('current', {'packages':['corechart']});
	    google.charts.setOnLoadCallback(drawVisualization);
	
	    function drawVisualization() {
	        var Tjson = [['나이', '사망자 수']];
	
	        <% while(Chart_Year_Age_Death.next()) { 
            	if((Chart_Year_Age_Death.getInt("YEAR") == Year) && (City.equals(Chart_Year_Age_Death.getString("CITY")))) {%>
	        Tjson.push(["<%= Chart_Year_Age_Death.getString("AGE")%>", <%= Chart_Year_Age_Death.getInt("DEATH")%>]);
			<%}}%>
	        
	        var data = google.visualization.arrayToDataTable(Tjson);
	        
	        var options = {
	            legend: {position: 'bottom'},
	            pieSliceText: 'label',
	            backgroundColor: {fill: '#EAEAEA'}
	        };
	        
	        var chart = new google.visualization.PieChart(document.getElementById('chart3'));
	        chart.draw(data, options); 
	    }
    </script>
    
<%

City_Kind.close();
Year_Kind.close();

Cause_Death_log.close();
Chart_Year_Death.close();
Chart_Year_Age_Death.close();

} catch(Exception e) {
	e.printStackTrace();
	
}
%>
</body>
</html>