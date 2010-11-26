<%--
  Created by Maxim Scheremetjew, EMBL-EBI, InterPro
  Date: 11-Nov-2010
  Desc: Represents the Metagenomics portal home page, which inludes
  1. a login function
  2. a link to submission form
  3. a link of public and private (if you logged in) studies
  4. a link to study list
  4. info about what Metagenomics is and what kind of services this portal provides
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>MG Portal home page</title>
    <link href="css/memi.css" rel="stylesheet" type="text/css" media="all"/>
</head>
<body>
<div id="right_side_navigation">
    <p><a href="<c:url value="loginForm.htm"/>">Login or register</a></p>

    <p>
    <table>
        <c:forEach var="study" items="${studies}">
            <tr>
                <td><c:out value="${study.dateStringFormatted} - ${study.studyName}"/></td>
            </tr>
        </c:forEach>
    </table>
    <a href="<c:url value="installationSitePage.htm"/>">more</a>
</div>
<div id="content">
    <div style="margin-top:60px"></div>
    <h2>EBI Metagenomics Portal</h2>

    <div style="margin-top:6px"></div>
    <h3>What's metagenomics?</h3>

    <p>The study of all genomes present in any given environment without the need for prior individual identification or
        amplification is termed metagenomics. For example, in its simplest form a metagenomic study might be the direct
        sequence results of DNA extracted from a bucket of sea water.<br><a
                href="<c:url value="installationSitePage.htm"/>">more</a></p>

    <div style="margin-top:6px"></div>
    <h3>TODOs</h3>

    <p>
    <ul>
        <li>Short description about what Metagenomics is and what kind of services this portal
            provides.
        </li>
    </ul>
    </p>

    <div style="margin-top:6px"></div>
    <h3>Already implemented</h3>

    <p>
    <ol>
        <li>Login page (you find the link on the right side)</li>
    </ol>
    </p>
</div>
</body>
</html>