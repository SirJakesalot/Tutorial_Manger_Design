<%@ include file="header.jsp" %>


<c:if test="${error != null}">
  <div class="panel panel-danger">
    <div class="panel-heading">ERROR!</div>
    <div class="panel-body">${error}</div>
  </div>
</c:if>

<c:if test="${crumbs != null}">
  <ol class="breadcrumb">
    <c:forEach var="crumb" items="${crumbs}">
      <c:if test="${crumb.cat() != null}">
        <li class="breadcrumb-item">
          <a href="${context}/${crumb.cat().name()}.html">${crumb.cat().label()}</a>
        </li>
      </c:if>
      <c:if test="${crumb.page() != null}">
        <li class="breadcrumb-item">
          <a href="${context}/${crumb.page().name()}.html">${crumb.page().label()}</a>
        </li>
      </c:if>
    </c:forEach>
  </ol>
</c:if>

<c:if test="${category != null}">
  <h1 class="c-text">${category.label()}</h1>
  <div class="list-group">
    <c:forEach var="child" items="${children}">
      <c:if test="${child.cat() != null}">
        <a class="list-group-item list-group-item-action" href="${context}/${child.cat().name()}.html">${child.cat().label()}</a>
      </c:if>
      <c:if test="${child.page() != null}">
        <a class="list-group-item list-group-item-action" href="${context}/${child.page().name()}.html">${child.page().label()}</a>
      </c:if>
    </c:forEach>
  </div>
</c:if>

<c:if test="${page != null}">
  <h1 class="c-text">${page.label()}</h1>
  ${page.content()}
</c:if>

<%@ include file="footer.jsp" %>
