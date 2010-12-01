<%--
  Created by Maxim Scheremetjew, EMBL-EBI, InterPro
  Date: 29-Nov-2010
  Desc: Represents a page which lists all studies within a table.
  Example URL: http://www.springbyexample.org/examples/sdms-simple-spring-mvc-web-module.html
  --%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>Overview about all studies</title>
    <link href="css/memi.css" rel="stylesheet" type="text/css" media="all"/>
</head>
<body>
<div id="right_side_navigation">
    <p><a href="<c:url value="homePage.htm"/>">Home</a></p>
</div>
<div id="content">
    <div style="margin-top:60px"></div>
    <h2>Overview about all studies</h2>

    <table>
        <tr>
            <td width="80%">
                <table border="1">
                    <tr>
                        <th>Study Id</th>
                        <th>Study name</th>
                        <th>Study type</th>
                        <th>Start date</th>
                        <th>Status</th>
                        <th>Sample size</th>
                        <th>Study Overview</th>
                    </tr>
                    <c:forEach var="study" items="${studyList}" varStatus="status">
                        <tr>
                            <c:set var="studyId" value="study${status.index}"/>

                            <c:url var="detailedViewUrl" value="/studyOverview.htm">
                                <c:param name="id" value="${study.studyId}"/>
                            </c:url>

                            <td>${study.studyId}</td>
                            <td><a href='<c:out value="${detailedViewUrl}"/>'>${study.studyName}</a></td>
                            <td>${study.studyType}</td>
                            <td>${study.submitDate}</td>
                            <td>${study.analyseStatus}</td>
                            <td>${study.sampleSize}</td>
                            <td><a href='<c:out value="${detailedViewUrl}"/>'>Show overview</a></td>
                        </tr>
                    </c:forEach>
                </table>
            </td>
            <td width="20%" valign="top">Filter:<br>
                <table border="0" style="border-width: 1px;border-color: #000000;border-style: solid;">
                    <form:form action="listStudies.htm" commandName="filterForm">
                        <tr>
                            <td>Study type:</td>
                            <td>
                                <form:select path="studyType">
                                    <form:option value="NONE" label="--- Select ---"/>
                                    <form:options items="${studyTypeList}" itemValue="studyTypeId"
                                                  itemLabel="studyTypeName"/>
                                </form:select>
                            </td>
                            <td><form:errors path="studyType" cssClass="error"/></td>
                        </tr>
                        <tr>
                            <td>Study status:</td>
                            <td><form:select path="studyStatus">
                                <form:option value="NONE" label="--- Select ---"/>
                                <form:options items="${studyStatusList}" itemValue="studyStatusId"
                                              itemLabel="studyStatusName"/>
                            </form:select></td>
                            <td><form:errors path="studyStatus" cssClass="error"/></td>
                        </tr>
                        <tr>
                            <td></td>
                            <td></td>
                            <td>
                                <input type="submit" value="Do filter"/>
                            </td>
                        </tr>
                    </form:form>
                </table>
            </td>
        </tr>
    </table>
</div>
</body>
</html>