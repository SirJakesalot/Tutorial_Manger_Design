<%@ include file="header.jsp" %>
<fieldset>
  <legend>Site Settings</legend>
  <div class="form-group">
    <label for="siteLabel">Site Label</label>
    <input id="siteLabel" name="line" type="text" placeholder="line" value="${settings.site_label()}" class="form-control input-md">
  </div>
  <div class="form-group">
    <label for="mainPageContent">Main Page Content</label>
    <div id="mainPageContent" class="editor"><c:out value="${settings.main_page_content()}"/></div>
  </div>
  <div class="form-group">
    <label for="headSnippet">Head Snippet</label>
    <div id="headSnippet" class="editor"><c:out value="${settings.head_snippet()}"/></div>
  </div>
  <div class="form-group">
    <label for="footSnippet">Foot Snippet</label>
    <div id="footSnippet" class="editor"><c:out value="${settings.foot_snippet()}"/></div>
  </div>
</fieldset>
<button type="button" class="btn btn-primary" onclick="editSettings();">Save</button>

<script>
var editSettingsURL = "${context}/api/editsettings";
var editor;
$('.editor').each(function( index ) {
  editor = ace.edit(this);
  editor.getSession().setMode('ace/mode/html');
  editor.setOptions({maxLines: 15});
  editor.$blockScrolling = Infinity;
});
</script>

<%@ include file="footer.jsp" %>
