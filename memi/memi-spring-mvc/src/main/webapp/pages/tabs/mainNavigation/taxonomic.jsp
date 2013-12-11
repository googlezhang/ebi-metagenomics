<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<div id="fragment-taxonomy">

    <div class="main_tab_full_content">
        <p>These are the results from the taxonomic analysis steps of our pipeline. You can switch between
            different views of the data using the menu of icons below (pie, bar, stacked and interactive krona
            charts). If you wish to download the full set of results, all files are listed under the
            "Download" tab.</p>

        <c:choose>
            <c:when test="${empty model.sample.analysisCompleted}">
                <div class="msg_error">Analysis in progress.</div>
            </c:when>
            <c:when test="${not empty model.sample.analysisCompleted && !model.analysisStatus.taxonomicAnalysisTabDisabled}">
                <h3>Top taxonomy Hits</h3>
                <%--<a id="exportTest"--%>
                <%--href="javascript:saveAsSVG(document.getElementById('tax_chart_pie_dom'),'<spring:message code="file.name.tax.pie.chart.domain.svg"/>',1);">Save--%>
                <%--as SVG</a>--%>
                <%--<a id="taxDomSvgExport"--%>
                <%--href="javascript:saveAsSVG(document.getElementById('tax_chart_pie_dom'),'<spring:message code="file.name.tax.pie.chart.domain.svg"/>');">Save--%>
                <%--as SVG</a>--%>
                <div id="tabs-taxchart">
                    <ul>
                        <li class="selector_tab">Switch view:</li>
                            <%--<li><a href="#tax-table" title="Table view"><span class="ico-table"></span></a></li>--%>
                        <li><a title="Pie-Chart-View"
                               href="<c:url value="${baseURL}/sample/${model.sample.sampleId}/taxPieChartView"/>"><span
                                class="ico-pie"></span></a></li>
                        <li><a title="Bar-Chart-View"
                               href="<c:url value="${baseURL}/sample/${model.sample.sampleId}/taxBarChartView"/>"><span
                                class="ico-barh"></span></a></li>
                        <li><a title="Stacked-Column-Chart-View"
                               href="<c:url value="${baseURL}/sample/${model.sample.sampleId}/taxColumnChartView"/>"><span
                                class="ico-col"></span></a></li>
                        <li class="but_krona"><a title="Krona-Chart-View"
                                                 href="<c:url value="${baseURL}/sample/${model.sample.sampleId}/kronaChartView"/>"><span
                                class="ico-krona"></span></a></li>
                        <div class="chart-block">
                            <div class="but_chart_export">
                                <button id="taxpie" style="display: none;"></button>
                                <button id="select">Export</button>
                            </div>
                            <ul class="export_list">
                                <li>Domain composition</li>
                                <li id="taxDomSvgExport" class="chart_exp_png">
                                    <a href="javascript:saveAsSVG(document.getElementById('tax_chart_pie_dom'),'<spring:message code="file.name.tax.pie.chart.domain.svg"/>');">Save
                                        as SVG</a>
                                </li>
                                <li id="taxDomPngExport" class="chart_exp_png">
                                    <a href="javascript:saveAsImg(document.getElementById('tax_chart_pie_dom'),'<spring:message code="file.name.tax.pie.chart.domain.png"/>');">Save
                                        as PNG</a></li>
                                <li id="taxDomSnapshot" class="chart_exp_snap">
                                    <a href="javascript:toImg(document.getElementById('tax_chart_pie_dom'), document.getElementById('img_div'));">Snapshot</a>
                                </li>
                                <li>---------------------------</li>
                                <li>Phylum composition</li>
                                <li id="taxPhySvgExport" class="chart_exp_png"><a
                                        href="javascript:saveAsSVG(document.getElementById('tax_chart_pie_phy'),'<spring:message code="file.name.tax.pie.chart.phylum.svg"/>');">Save
                                    as SVG</a></li>
                                <li id="taxPhyPngExport" class="chart_exp_png"><a
                                        href="javascript:saveAsImg(document.getElementById('tax_chart_pie_phy'),'<spring:message code="file.name.tax.pie.chart.phylum.png"/>');">Save
                                    as PNG</a></li>
                                <li id="taxPhySnapshot" class="chart_exp_snap">
                                    <a href="javascript:toImg(document.getElementById('tax_chart_pie_phy'), document.getElementById('img_div'));">Snapshot</a>
                                </li>
                            </ul>
                        </div>
                    </ul>
                </div>

            </c:when>
            <c:otherwise>
                <div class="msg_error">No taxonomy result files have been associated with this sample.</div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<script type="text/javascript">

    //Ajax load approach as described here: http://jqueryui.com/tabs/#ajax
    $("#tabs-taxchart").tabs({
        cache:true,
        ajaxOptions:{
            error:function (xhr, status, index, anchor) {
                $(anchor.hash).html("<div class='msg_error'>Couldn't load this tab. We'll try to fix this as soon as possible.</div>");
            }
        },
        spinner:false,
        select:function (event, ui) {
//            ui.index: Type: Integer Def: The zero-based index of the tab.
            var tabID = "#ui-tabs-" + (ui.index + 1);
            $(tabID).html("<b>Loading Data.... Please wait....</b>");
            if (ui.index == 0) {
                $("#taxDomSvgExport").html("<a>Save as SVG</a>");
                $("#taxDomPngExport").html("<a>Save as PNG</a>");
                $("#taxDomSnapshot").html("<a>Snapshot</a>");
                $("#taxDomSvgExport a:first").attr("href", "javascript:saveAsSVG(document.getElementById('tax_chart_pie_dom'),'<spring:message code="file.name.tax.pie.chart.domain.svg"/>');");
                $("#taxDomPngExport a:first").attr('href', "javascript:saveAsImg(document.getElementById('tax_chart_pie_dom'),'<spring:message code="file.name.tax.pie.chart.domain.png"/>');");
                $("#taxDomSnapshot a:first").attr('href', "javascript:toImg(document.getElementById('tax_chart_pie_dom'), document.getElementById('img_div'));");
            <%----%>
                $("#taxPhySvgExport a:first").attr('href', "javascript:saveAsSVG(document.getElementById('tax_chart_pie_phy'),'<spring:message code="file.name.tax.pie.chart.phylum.svg"/>');");
                $("#taxPhyPngExport a:first").attr('href', "javascript:saveAsImg(document.getElementById('tax_chart_pie_phy'),'<spring:message code="file.name.tax.pie.chart.phylum.png"/>');");
                $("#taxPhySnapshot a:first").attr('href', "javascript:toImg(document.getElementById('tax_chart_pie_phy'), document.getElementById('img_div'));");

            } else if (ui.index == 1) {
                $("#taxDomSvgExport").html("<a>Save as SVG</a>");
                $("#taxDomPngExport").html("<a>Save as PNG</a>");
                $("#taxDomSnapshot").html("<a>Snapshot</a>");
                $("#taxDomSvgExport a:first").attr("href", "javascript:saveAsSVG(document.getElementById('tax_chart_bar_dom'),'<spring:message code="file.name.tax.bar.chart.domain.svg"/>');");
                $("#taxDomPngExport a:first").attr('href', "javascript:saveAsImg(document.getElementById('tax_chart_bar_dom'),'<spring:message code="file.name.tax.bar.chart.domain.png"/>');");
                $("#taxDomSnapshot a:first").attr('href', "javascript:toImg(document.getElementById('tax_chart_bar_dom'), document.getElementById('img_div'));");
            <%----%>
                $("#taxPhySvgExport a:first").attr('href', "javascript:saveAsSVG(document.getElementById('tax_chart_bar_phy'),'<spring:message code="file.name.tax.bar.chart.phylum.svg"/>');");
                $("#taxPhyPngExport a:first").attr('href', "javascript:saveAsImg(document.getElementById('tax_chart_bar_phy'),'<spring:message code="file.name.tax.bar.chart.phylum.png"/>');");
                $("#taxPhySnapshot a:first").attr('href', "javascript:toImg(document.getElementById('tax_chart_bar_phy'), document.getElementById('img_div'));");
            }
            else if (ui.index == 2) {
                $("#taxDomSvgExport").html("<a>Not available</a>");
                $("#taxDomPngExport").html("<a>Not available</a>");
                $("#taxDomSnapshot").html("<a>Not available</a>");
                <%----%>
                $("#taxPhySvgExport a:first").attr('href', "javascript:saveAsSVG(document.getElementById('tax_chart_col'),'<spring:message code="file.name.tax.col.chart.phylum.svg"/>');");
                $("#taxPhyPngExport a:first").attr('href', "javascript:saveAsImg(document.getElementById('tax_chart_col'),'<spring:message code="file.name.tax.col.chart.phylum.png"/>');");
                $("#taxPhySnapshot a:first").attr('href', "javascript:toImg(document.getElementById('tax_chart_col'), document.getElementById('img_div'));");
            }
            <%--$("#exportTest").attr('href', "javascript:saveAsSVG(document.getElementById('tax_chart_pie_dom'),'<spring:message code="file.name.tax.pie.chart.domain.svg"/>');");--%>
        }
    });
    //Default functionality
    $("#tabs-taxchart").tabs({${model.analysisStatus.taxonomicAnalysisTab.tabsOptions}});


</script>
<script>
    <%--You will find the method definition in the file sampleViewBody.jsp--%>
    loadCssStyleForExportSelection('#taxpie');
</script>
<%--Remove the filter box for taxonomy table when the total number of phylum is less than 10--%>
<c:if test="${fn:length(model.taxonomyAnalysisResult.taxonomyDataSet)<10}">
    <style>#tax_table_filter, #tax_table_col_filter, #tax_table_bar_filter {
        display: none;
    }</style>
</c:if>