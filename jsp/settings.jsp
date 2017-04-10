<%@ include file="header.jsp" %>
<fieldset>
  <legend>Site Settings</legend>
  <div class="form-group">
    <label for="siteLabel">Site Label</label>
    <input id="siteLabel" name="line" type="text" placeholder="line" class="form-control input-md">
  </div>
  <div class="form-group">
    <label for="mainPageContent">Main Page Content</label>
    <div id="mainPageContent" class="editor"></div>
  </div>
  <div class="form-group">
    <label for="headSnippet">Head Snippet</label>
    <div id="headSnippet" class="editor"></div>
  </div>
  <div class="form-group">
    <label for="footSnippet">Foot Snippet</label>
    <div id="footSnippet" class="editor"></div>
  </div>
</fieldset>

<script>
var editor;
$('.editor').each(function( index ) {
  editor = ace.edit(this);
  editor.getSession().setMode('ace/mode/html');
  editor.setOptions({maxLines: 15});
});

</script>

<%@ include file="footer.jsp" %>
