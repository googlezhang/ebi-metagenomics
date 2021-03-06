<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<div id="tax-col">
    <div class="chart_container">
        <div class="chart-block col-1-2">

            <div class="but_chart_export ui-buttonset">
                <button id="select"
                        class="ui-button ui-widget ui-state-default ui-button-text-icon-secondary ui-corner-right"><span
                        class="ui-button-text">Export</span><span
                        class="ui-button-icon-secondary ui-icon ui-icon-triangle-1-s"></span></button>
            </div>

            <ul class="export_list">
                <li><strong>Phylum composition</strong></li>
                <li class="chart_exp png" id="col_phy_png"><a
                        onclick="saveAsImg(document.getElementById('tax_chart_col'),'<spring:message code="file.name.tax.col.chart.phylum.png"/>',1);">PNG</a>
                </li>
                <li class="chart_exp png" id="col_phy_png_h"><a
                        onclick="saveAsImg(document.getElementById('tax_chart_col'),'<spring:message code="file.name.tax.col.chart.phylum.high.png"/>',300/72);">PNG
                    (Higher quality)</a></li>
                <li class="chart_exp" id="col_phy_svg"><a
                        onclick="saveAsSVG(document.getElementById('tax_chart_col'),'<spring:message code="file.name.tax.col.chart.phylum.svg"/>');">SVG</a>
            </ul>

            <div id="tax_chart_col"></div>
        </div>

        <div id="tax_dashboard_col" class="col-1-2">
            <div id="tax_table_col_filter"></div>
            <div id="tax_table_col"></div>
            <div class="msg_help blue_h phylum_help">
                <p><span class="icon icon-generic" data-icon="i"></span>This view aggregates the taxonomy information at
                    the domain and phylum level. To download the full detailed taxonomy distribution (TSV format),
                    <a href="#ui-id-6" class="open-tab" data-tab-index="4"> please follow this link</a>.</p>
            </div>
        </div>

    </div>

</div>

<%--Globale page properties--%>
<c:choose>
    <c:when test="${model.run.releaseVersion == '1.0'}"><c:set var="phylumCompositionTitle" scope="request"
                                                               value="Phylum composition (Total: ${model.taxonomyAnalysisResult.sliceVisibilityThresholdDenominator} OTUs)"/></c:when>
    <c:otherwise><c:set var="phylumCompositionTitle" scope="request"
                        value="Phylum composition (Total: ${model.taxonomyAnalysisResult.sliceVisibilityThresholdDenominator} reads)"/></c:otherwise>
</c:choose>
<script type="text/javascript">
       // script to make the tab download link work
    $('.open-tab').click(function (event) {
        $('#navtabs').tabs("option", "active", $(this).data("tab-index"));
    });

    drawPhylumStackChart();
    drawPhylumTable();

    function drawPhylumTable() {
        // Taxonomy top phylum table - stacked column
        var taxMatchesDataColumnChart = new google.visualization.DataTable();
        taxMatchesDataColumnChart.addColumn('string', 'Phylum');
        taxMatchesDataColumnChart.addColumn('string', 'Domain');
    <c:choose>
        <c:when test="${model.run.releaseVersion == '1.0'}">taxMatchesDataColumnChart.addColumn('number', 'Unique OTUs');
        taxMatchesDataColumnChart.addColumn('number', '%');
    </c:when>
        <c:otherwise>taxMatchesDataColumnChart.addColumn('number', 'Number of reads');
        taxMatchesDataColumnChart.addColumn('number', '%');
    </c:otherwise>
    </c:choose>
        taxMatchesDataColumnChart.addRows([
            <c:set var="addComma" value="false"/><c:forEach var="taxonomyData" items="${model.taxonomyAnalysisResult.taxonomyDataSet}" varStatus="status"><c:choose><c:when test="${addComma}">,
            </c:when><c:otherwise><c:set var="addComma" value="true"/></c:otherwise></c:choose>
            ['<div title="${taxonomyData.phylum}" class="_cc" style="background-color: <c:choose><c:when test="${status.index>9}">#b9b9b9</c:when><c:otherwise>#<c:out value="${model.colorCodeList[status.index]}"/></c:otherwise></c:choose>;"></div> ${taxonomyData.phylum}', '${taxonomyData.superKingdom}', ${taxonomyData.numberOfHits}, ${taxonomyData.percentage}]</c:forEach>
        ]);

        // Define a StringFilter control for the 'Phylum' column - Stacked column table
        var taxcolStringFilter = new google.visualization.ControlWrapper({
            'controlType':'StringFilter',
            'containerId':'tax_table_col_filter',
            'options':{'matchType':'any', 'filterColumnIndex':'0', 'ui':{'label':'Filter table', 'labelSeparator':':', 'ui.labelStacking':'vertical', 'ui.cssClass':'custom_col_search'}
            }
        });

        // Table visualization option - Stacked column table
        var taxcolTableOptions = new google.visualization.ChartWrapper({
            'chartType':'Table',
            'containerId':'tax_table_col',
            'options':{ allowHtml:true, showRowNumber:true, width: '100%', page:'enable', pageSize:10, pagingSymbols:{prev:'prev', next:'next'}, sortColumn:2, sortAscending:false }
        });

        // Draw the Dashboard for the Stacked column
        new google.visualization.Dashboard(document.getElementById('tax_dashboard_col')).
            // Configure the string filter to affect the table contents
                bind(taxcolStringFilter, taxcolTableOptions).
            // Draw the dashboard
                draw(taxMatchesDataColumnChart);

    }  //END function drawPhylumTable()

    function drawPhylumStackChart() {
// DATA taxonomy Stacked column
        var data = google.visualization.arrayToDataTable([
            [''<c:forEach var="taxonomyData" items="${model.taxonomyAnalysisResult.taxonomyDataSet}" varStatus="status">
                , '${taxonomyData.phylum}'
                </c:forEach>],
            [''<c:forEach var="taxonomyData" items="${model.taxonomyAnalysisResult.taxonomyDataSet}" varStatus="status">
                , <fmt:formatNumber type="number" maxFractionDigits="3" value="${taxonomyData.numberOfHits *100/ model.taxonomyAnalysisResult.sliceVisibilityThresholdDenominator}" />
                </c:forEach>]
        ]);

// Stacked column graph
        var options = {'title':'${phylumCompositionTitle}', 'titleTextStyle':{fontSize:12}, 'fontName':'"Arial"',
            'colors':[${model.taxonomyAnalysisResult.colorCodeForStackChart}],
            'height':420,
            'legend':{position:'right', textStyle:{fontSize:10}},
            'chartArea':{left:40, top:50, width:"38%", height:"86%"},
            'pieSliceBorderColor':'none',
            'vAxis':{viewWindowMode:'maximized'}, //  important to keep viewWindowMode separated from the rest to keep the display of the value 100% on vaxis
            'vAxis':{
            title:'Relative abundance (%)',
            baselineColor:'#ccc'},
            'isStacked':true
        };

        var phylumStackChart = new google.visualization.ColumnChart(document.getElementById('tax_chart_col'));
        phylumStackChart.draw(data, options);
    }
       //make the charts responsive
       $(window).resize(function(){
         drawPhylumStackChart();
         drawPhylumTable();
       });
</script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/export-button-menu.js"></script>