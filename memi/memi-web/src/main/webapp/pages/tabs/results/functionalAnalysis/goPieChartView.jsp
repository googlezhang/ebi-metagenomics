<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<div id="go-terms-pie">
    <div class="go-chart">
        <div class="chart-block col-1-3">

         <div class="but_chart_export ui-buttonset">
         <button id="select" class="ui-button ui-widget ui-state-default ui-button-text-icon-secondary ui-corner-right"><span class="ui-button-text">Export</span><span class="ui-button-icon-secondary ui-icon ui-icon-triangle-1-s"></span></button>
         </div>

         <ul class="export_list">
         <li><strong>Biological process</strong></li>
         <li class="chart_exp png" id="pie_bp_png"><a onclick="saveAsImg(document.getElementById('func_chart_pie_go_bp'),'<spring:message code="file.name.func.go.pie.chart.bp.png"/>',1);">PNG</a></li>
         <li class="chart_exp png" id="pie_bp_png_h"><a onclick="saveAsImg(document.getElementById('func_chart_pie_go_bp'),'<spring:message code="file.name.func.go.pie.chart.bp.high.png"/>',300/72);">PNG (Higher quality)</a></li>
         <li class="chart_exp" id="pie_bp_svg"><a onclick="saveAsSVG(document.getElementById('func_chart_pie_go_bp'),'<spring:message code="file.name.func.go.pie.chart.bp.svg"/>');">SVG</a></li>
         <li><strong>Molecular function</strong></li>
         <li class="chart_exp png" id="pie_mf_png"><a onclick="saveAsImg(document.getElementById('func_chart_pie_go_mf'),'<spring:message code="file.name.func.go.pie.chart.mf.png"/>',1);">PNG</a></li>
         <li class="chart_exp png" id="pie_mf_png_h"><a onclick="saveAsImg(document.getElementById('func_chart_pie_go_mf'),'<spring:message code="file.name.func.go.pie.chart.mf.high.png"/>',300/72);">PNG (Higher quality)</a></li>
         <li class="chart_exp" id="pie_mf_svg"><a onclick="saveAsSVG(document.getElementById('func_chart_pie_go_mf'),'<spring:message code="file.name.func.go.pie.chart.mf.svg"/>');">SVG</a></li>
         <li><strong>Cellular component</strong></li>
         <li class="chart_exp png" id="pie_cc_png"><a onclick="saveAsImg(document.getElementById('func_chart_pie_go_cc'),'<spring:message code="file.name.func.go.pie.chart.cc.png"/>',1);">PNG</a></li>
         <li class="chart_exp png" id="pie_cc_png_h"><a onclick="saveAsImg(document.getElementById('func_chart_pie_go_cc'),'<spring:message code="file.name.func.go.pie.chart.cc.high.png"/>',300/72);">PNG (Higher quality)</a></li>
         <li class="chart_exp" id="pie_cc_svg"><a onclick="saveAsSVG(document.getElementById('func_chart_pie_go_cc'),'<spring:message code="file.name.func.go.pie.chart.cc.svg"/>');">SVG</a></li>
         </ul>

        <div id="func_chart_pie_go_bp"></div>
        </div>

        <div class="chart-block col-1-3">
        <div id="func_chart_pie_go_mf"></div>
        </div>

        <div class="chart-block col-1-3">
        <div id="func_chart_pie_go_cc"></div>
        </div>
    </div>
</div>
<script type="text/javascript">
    drawBiologicalProcessPieChart();
    drawMolecularFunctionPieChart();
    drawCellularComponentPieChart();


    //Draws GO term pie chart for Biological process
    function drawBiologicalProcessPieChart() {

        var sortedBiologicalProcessGOTerms = new google.visualization.DataTable();
        sortedBiologicalProcessGOTerms.addColumn('string', 'GO term');
        sortedBiologicalProcessGOTerms.addColumn('number', 'Match');
        sortedBiologicalProcessGOTerms.addRows([
            <c:set var="addComma" value="false"/><c:forEach var="goTerm" items="${model.sortedBiologicalProcessGOTerms}" varStatus="status"><c:choose><c:when test="${addComma}">,
            </c:when><c:otherwise><c:set var="addComma" value="true"/></c:otherwise></c:choose>
            ['${goTerm.synonym}', ${goTerm.numberOfMatches}]</c:forEach>
        ]);

        var options = {'title':'Biological process', 'titleTextStyle':{fontSize:12}, 'fontName':'"Arial"',
            'colors':[<c:set var="addComma" value="false"/><c:forEach begin="0" end="10" varStatus="status"><c:choose><c:when test="${addComma}">, </c:when><c:otherwise><c:set var="addComma" value="true"/></c:otherwise></c:choose><c:choose><c:when test="${status.index>9}">'#ccc'</c:when><c:otherwise>'#<c:out value="${model.colorCodeList[status.index]}"/>'</c:otherwise></c:choose></c:forEach>],
            'height':240, 'legend':{position:'right', 'textStyle':{'fontSize':10}}, 'chartArea':{left:9, top:30, width:"100%", height:"80%"}, 'pieSliceBorderColor':'none',
//      'backgroundColor':'green',
            'sliceVisibilityThreshold':${model.functionalAnalysisResult.goTermSection.biologicalProcessGoTerms.sliceVisibilityThresholdValue}
        };

        var pieChart = new google.visualization.PieChart(document.getElementById('func_chart_pie_go_bp'));
        pieChart.draw(sortedBiologicalProcessGOTerms, options);
    }

    //Draws GO term pie chart for Molecular Function
    function drawMolecularFunctionPieChart() {

        var sortedMolecularFunctionGOTerms = new google.visualization.DataTable();
        sortedMolecularFunctionGOTerms.addColumn('string', 'GO term');
        sortedMolecularFunctionGOTerms.addColumn('number', 'Match');
        sortedMolecularFunctionGOTerms.addRows([
            <c:set var="addComma" value="false"/><c:forEach var="goTerm" items="${model.sortedMolecularFunctionGOTerms}" varStatus="status"><c:choose><c:when test="${addComma}">,
            </c:when><c:otherwise><c:set var="addComma" value="true"/></c:otherwise></c:choose>
            ['${goTerm.synonym}', ${goTerm.numberOfMatches}]</c:forEach>
        ]);

        // GO TERM Pie Molecular function
        var options = {'title':'Molecular function', 'titleTextStyle':{fontSize:12}, 'fontName':'"Arial"',
           'colors':[<c:set var="addComma" value="false"/><c:forEach begin="0" end="10" varStatus="status"><c:choose><c:when test="${addComma}">, </c:when><c:otherwise><c:set var="addComma" value="true"/></c:otherwise></c:choose><c:choose><c:when test="${status.index>9}">'#ccc'</c:when><c:otherwise>'#<c:out value="${model.colorCodeList[status.index]}"/>'</c:otherwise></c:choose></c:forEach>],
           'height':240, 'legend':{position:'right', 'textStyle':{'fontSize':10}}, 'chartArea':{left:9, top:30, width:"100%", height:"80%"}, 'pieSliceBorderColor':'none',
//      'backgroundColor':'blue',
           'sliceVisibilityThreshold':${model.functionalAnalysisResult.goTermSection.molecularFunctionGoTerms.sliceVisibilityThresholdValue}
        };

        var pieChart = new google.visualization.PieChart(document.getElementById('func_chart_pie_go_mf'));
        pieChart.draw(sortedMolecularFunctionGOTerms, options);
    }


    //Draws GO term pie chart for Cellular component
    function drawCellularComponentPieChart() {
        var sortedCellularComponentGOTerms = new google.visualization.DataTable();
        sortedCellularComponentGOTerms.addColumn('string', 'GO term');
        sortedCellularComponentGOTerms.addColumn('number', 'Match');
        sortedCellularComponentGOTerms.addRows([
            <c:set var="addComma" value="false"/><c:forEach var="goTerm" items="${model.sortedCellularComponentGOTerms}" varStatus="status"><c:choose> <c:when test="${addComma}">,
            </c:when><c:otherwise><c:set var="addComma" value="true"/></c:otherwise></c:choose>
            ['${goTerm.synonym}', ${goTerm.numberOfMatches}]</c:forEach>
        ]);

        // GO TERM Pie Cellular component
        var options = {'title':'Cellular component', 'titleTextStyle':{fontSize:12}, 'fontName':'"Arial"',
            'colors':[<c:set var="addComma" value="false"/><c:forEach begin="0" end="10" varStatus="status"><c:choose><c:when test="${addComma}">, </c:when><c:otherwise><c:set var="addComma" value="true"/></c:otherwise></c:choose><c:choose><c:when test="${status.index>9}">'#ccc'</c:when><c:otherwise>'#<c:out value="${model.colorCodeList[status.index]}"/>'</c:otherwise></c:choose></c:forEach>],
            'height':240, 'legend':{position:'right', 'textStyle':{'fontSize':10}}, 'chartArea':{left:9, top:30, width:"100%", height:"80%"}, 'pieSliceBorderColor':'none',
//      'backgroundColor':'yellow',
            'sliceVisibilityThreshold':${model.functionalAnalysisResult.goTermSection.cellularComponentGoTerms.sliceVisibilityThresholdValue}
        };

        var pieChart = new google.visualization.PieChart(document.getElementById('func_chart_pie_go_cc'));
        pieChart.draw(sortedCellularComponentGOTerms, options);
    }
    //make the charts responsive
           $(window).resize(function(){
               drawBiologicalProcessPieChart();
               drawMolecularFunctionPieChart();
               drawCellularComponentPieChart();
           });
</script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/export-button-menu.js"></script>