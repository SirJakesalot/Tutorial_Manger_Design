<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<%@ page session="true" %>
<%@ page isELIgnored="false" %>
<%@ page import="pageDB_model.Settings"%>
<%@ page import="pageDB_model.Category"%>
<%@ page import="pageDB_model.Page"%>
<%@ page import="pageDB_model.TreeNode"%>

<c:set var="context" value="${pageContext.request.contextPath}" />

<html>
<head>
  <meta charset="utf-8"/>
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <!-- The above 3 meta tags must come first in the head; any other head content must come *after* these tags -->

  <!-- JAVASCRIPT LIBRARIES -->
  <!-- Jquery -->
  <script src="${context}/vendors/jquery/jquery.min.js"></script>
  <!-- Bootstrap -->
  <script src="${context}/vendors/bootstrap/bootstrap-dist.min.js"></script>
  <!-- Latest compiled and Minified JavaScript -->
  <script src="${context}/vendors/bootstrap-select/bootstrap-select.js"></script>
  <!-- Ace Editor -->
  <script src="${context}/vendors/ace/ace.js"></script>
  <!-- Google Prettify -->
  <script src="${context}/vendors/code-prettify/loader/run_prettify.js"></script>
  <!-- Tree Manager -->
  <script src="${context}/js/manage-files.js"></script>
  <!-- Bootstrap Validator -->
  <script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/jquery.bootstrapvalidator/0.5.3/js/bootstrapValidator.js"></script>

  <!-- CSS LIBRARIES -->
  <!-- Bootstrap -->
  <link rel="stylesheet" href="${context}/vendors/bootstrap/bootstrap-dist.min.css">
  <!-- Bootstrap Theme -->
  <link rel="stylesheet" href="${context}/vendors/bootstrap/bootstrap-theme.min.css">
  <!-- Google Prettify Theme -->
  <link rel="stylesheet" href="css/prettyprint_theme.css">
  <!-- Tree Manager -->
  <link rel="stylesheet" href="css/tree-manager.css">
  <!-- Bootstrap SelectPicker -->
  <link rel="stylesheet" href="${context}/vendors/bootstrap-select/bootstrap-select.css">

  <title>${title}</title>
  ${settings.head_snippet()}
</head>

<!-- USEFUL LINKS -->
<!-- http://stackoverflow.com/questions/17386993/twitters-bootstrap-dropdowns-with-click-event -->
<!-- http://www.roytuts.com/infinite-dynamic-multi-level-nested-category-with-php-and-mysql/ -->

<body>
  <div class="container">
    <nav class="navbar navbar-default">
      <div class="container-fluid">
        <!-- Brand and toggle get grouped for better mobile display -->
        <div class="navbar-header">
          <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
            <span class="sr-only">Toggle navigation</span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </button>
          <a class="navbar-brand" href="${context}">${settings.site_label()}</a>
        </div>

        <!-- Collect the nav links, forms, and other content for toggling -->
        <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
          <ul class="nav navbar-nav">
            <li class="dropdown">
              <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">${tree.cat().label()}<span class="caret"></span></a>
              <ul class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu">

                <c:forEach var="node" items="${tree.children()}">
                  <c:if test="${node.cat() != null}">
                    <h6 class="dropdown-header"><a href="${context}/${node.cat().name()}.html">${node.cat().label()}</a></h6>
                    <c:forEach var="child" items="${node.children()}">
                      <c:if test="${child.cat() != null}">
                        <li><a href="${context}/${child.cat().name()}.html">${child.cat().label()}</a></li>
                      </c:if>
                    </c:forEach>
                    <li role="separator" class="divider"></li>
                  </c:if>
                </c:forEach>
              </ul>
            </li>
            <li class="dropdown">
              <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">Admin Actions<span class="caret"></span></a>
                <ul class="dropdown-menu" role="menu" >
                  <li><a href="${context}/settings">Settings</a></li>
                  <li><a href="${context}/manage-pages">Manage Pages</a></li>
                </ul>
            </li>
          </ul>
        </div> <!-- /.navbar-collapse -->
      </div> <!-- /.container-fluid -->
    </nav>
    <div class="container-fluid">
      <div class="row">
        <div class="col-sm-1">ads</div>
        <div class="col-sm-10">
