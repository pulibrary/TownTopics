xquery version "1.0";

declare namespace request="http://exist-db.org/xquery/request";
declare namespace mods="http://www.loc.gov/mods/v3";
declare namespace math="http://exist-db.org/xquery/math";

declare variable $sample-size as xs:integer := 350;
declare variable $masthead-sample-size as xs:integer := 6;
declare variable $error-rate as xs:float := xs:float(0.0005);

declare function local:headlines($batch as xs:string)
as element()+
{
  let $coll := concat("/db/towntopicsqc/", $batch)
  return collection($coll)//mods:relatedItem[@type='constituent']//mods:title[1]
};

declare function local:mastheads($batch as xs:string)
as element()+
{
  let $coll := concat("/db/towntopicsqc/", $batch)
  return collection($coll)//mods:mods/mods:part
};

declare function local:add-to-list($sample as element()+, $list as element()*)
as element()+
{
  let $index := round(math:random() * count($sample))
  let $pick := $sample[$index]
  return
    if ($pick = $list or string-length($pick) = 0) then local:add-to-list($sample, $list)
      else $pick union $list
};

declare function local:sample($headlines as element()+)
as element()+
{
let $list := ()
let $x := for $i in (1 to $sample-size) return  local:add-to-list($headlines, $list)
return $x 
};

declare function local:masthead-sample($mastheads as element()+)
as element()+
{
  let $list := ()
  let $x := for $i in (1 to $masthead-sample-size) return  local:add-to-list($mastheads, $list)
  return $x 
};

declare function local:stats($headlines as element()+, $sample as element()+)
as element()
{
let $charCount := sum(for $x in $sample return string-length($x))
return
<stats>
  <samplesize>{ $sample-size }</samplesize>
  <errorrate>{ $error-rate }</errorrate>
  <totalheadlinecount>{ count($headlines) }</totalheadlinecount>
  <sampleheadlinecount>{ count($sample) }</sampleheadlinecount>
  <samplecharcount>{ $charCount }</samplecharcount>
  <maxerrors>{ round($charCount * $error-rate) }</maxerrors>
</stats>
};


let $coll :=  concat('/db/towntopicsqc/', request:get-parameter('batch', ''))
let $issues := collection($coll)//mods:mods

let $headlines := local:headlines(request:get-parameter('batch', ''))
let $mastheads := local:mastheads(request:get-parameter('batch', ''))
let $sample := local:sample($headlines)
let $sample-mastheads := local:masthead-sample($mastheads)
let $stats := local:stats($headlines, $sample)
return 
<results batch="{request:get-parameter('batch','')}">
{ $stats }
<sample>{
 for $x in $sample
 let $date := xs:string($x/ancestor::mods:mods/mods:originInfo/mods:dateIssued[@encoding = "iso8601"])
 let $page := xs:string($x/ancestor::mods:relatedItem//mods:list)
 return 
   <title page="{$page}" date="{$date}">{ xs:string($x) }</title>
}</sample>

<mastheads>{
  for $x in $sample-mastheads
  let $text := $x/mods:text/text()
  let $date := $x/mods:date/text()
  let $volume := $x/mods:detail[@type='volume']/mods:number/text()
  let $issue := $x/mods:detail[@type='number']/mods:number/text()
  return
    <masthead date="{$date}" volume="{$volume}" issue="{$issue}">{ $text }</masthead>
}</mastheads>


<zones>{
  for $x at $p in $issues where $p mod 2 = 0 (:Change this to something larger for larger batches:)
  return
  <issue>{ concat($x//mods:detail[@type='volume']/mods:caption, ', ', $x//mods:detail[@type='issue']/mods:caption, ' (',$x//mods:dateIssued[@encoding = 'iso8601'],')' ) }</issue>
}</zones>

<articleText>{
 for $x at $p in $sample
  let $date := xs:string($x/ancestor::mods:mods//mods:dateIssued[@encoding = "iso8601"])
 let $page := xs:string($x/ancestor::mods:relatedItem//mods:list)
 where $p mod 5 = 0
return 
   <title page="{$page}" date="{$date}">{ xs:string($x) }</title>
}
</articleText>
</results>



