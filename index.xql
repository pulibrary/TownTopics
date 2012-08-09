xquery version "1.0";
declare namespace xdb="http://exist-db.org/xquery/xmldb";

let $subcolls := xdb:get-child-collections('/db/towntopicsqc')
return
 <html xmlns="http://www.w3.org/1999/xhtml">
<head><title>Historic Newspapers QC Tool</title></head>
<body>
<h1>Princeton Weekly Bulletin Quality Control Tool</h1>
<p>The following batches are available for assessment:</p>
  <ol>{
    for $c in $subcolls order by $c return
      <li><a href="headline-sample?batch={$c}">{$c}</a></li>

  }</ol>
</body>
</html>