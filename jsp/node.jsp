<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<c:forEach items="${node.children()}" var="n">
  <c:if test="${empty n.cat()}">
    <ul>
      <li>
        <span><i class="glyphicon glyphicon-leaf"></i> ${n.page().name()}</span>
        <div class="pull-right btn-group btn-group-sm">
          <button class="btn btn-info" data-toggle="modal" data-target="#editPageModal">
            <i class="glyphicon glyphicon-edit"></i>
          </button>
          <button class="btn btn-danger" data-toggle="modal" data-target="#delPageModal">
            <i class="glyphicon glyphicon-trash"></i>
          </button>
        </div>
      </li>
    </ul>
  </c:if>
  <c:if test="${empty n.page()}">
    <ul>
      <li>
        <span><i class="glyphicon glyphicon-folder-open"></i> ${n.cat().name()}</span>
        <div class="pull-right btn-group btn-group-sm">
          <button class="btn btn-success" data-toggle="modal" data-target="#addNodeModal">
            <i class="glyphicon glyphicon-plus"></i>
          </button>
          <button class="btn btn-info" data-toggle="modal" data-target="#editCatModal">
            <i class="glyphicon glyphicon-edit"></i>
          </button>
          <button class="btn btn-danger" data-toggle="modal" data-target="#delCatModal">
            <i class="glyphicon glyphicon-trash"></i>
          </button>
        </div>

        <c:set var="node" value="${n}" scope="request" />
        <jsp:include page="node.jsp"/>
      </li>
    </ul>
  </c:if>
</c:forEach>
