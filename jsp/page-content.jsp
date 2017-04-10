<%@ include file="header.jsp" %>

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

<c:if test="${category != null}">
  <h1 class="c-text">${category.label()}</h1>
  <p>Category ${category.name()}</p>
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
  <p>Page ${page.name()}</p>
  ${page.content()}
</c:if>

<%@ include file="footer.jsp" %>
