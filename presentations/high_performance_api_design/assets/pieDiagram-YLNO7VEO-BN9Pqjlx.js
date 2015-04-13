import{p as N}from"./chunk-K2ZEYYM2-D4BTmbJc.js";import{p as B}from"./radar-VG2SY3DT-N7HQ5CTK-B5szcHeV.js";import{_ as i,g as U,s as Q,a as V,b as Z,v as j,t as q,l as C,c as H,G as J,aN as K,aP as X,aQ as z,aR as Y,e as ee,A as te,aS as ae,I as re}from"./md-BJff_wIn.js";import"./chunk-TGZYFRKZ-D7SHaR6O.js";import"./index-DyrPoP32.js";import"./modules/vue-CNSExgwE.js";import"./modules/shiki-CdPLP8fG.js";import"./slidev/VClicks-C7TVo3ie.js";import"./slidev/context-4h_BmpBJ.js";import"./modules/file-saver-C8BEGaqa.js";import"./slidev/default-oy_3vQo-.js";var ie=re.pie,D={sections:new Map,showData:!1},m=D.sections,w=D.showData,se=structuredClone(ie),oe=i(()=>structuredClone(se),"getConfig"),ne=i(()=>{m=new Map,w=D.showData,te()},"clear"),le=i(({label:e,value:t})=>{m.has(e)||(m.set(e,t),C.debug(`added new section: ${e}, with value: ${t}`))},"addSection"),ce=i(()=>m,"getSections"),pe=i(e=>{w=e},"setShowData"),de=i(()=>w,"getShowData"),G={getConfig:oe,clear:ne,setDiagramTitle:q,getDiagramTitle:j,setAccTitle:Z,getAccTitle:V,setAccDescription:Q,getAccDescription:U,addSection:le,getSections:ce,setShowData:pe,getShowData:de},ge=i((e,t)=>{N(e,t),t.setShowData(e.showData),e.sections.map(t.addSection)},"populateDb"),ue={parse:i(async e=>{const t=await B("pie",e);C.debug(t),ge(t,G)},"parse")},fe=i(e=>`
  .pieCircle{
    stroke: ${e.pieStrokeColor};
    stroke-width : ${e.pieStrokeWidth};
    opacity : ${e.pieOpacity};
  }
  .pieOuterCircle{
    stroke: ${e.pieOuterStrokeColor};
    stroke-width: ${e.pieOuterStrokeWidth};
    fill: none;
  }
  .pieTitleText {
    text-anchor: middle;
    font-size: ${e.pieTitleTextSize};
    fill: ${e.pieTitleTextColor};
    font-family: ${e.fontFamily};
  }
  .slice {
    font-family: ${e.fontFamily};
    fill: ${e.pieSectionTextColor};
    font-size:${e.pieSectionTextSize};
    // fill: white;
  }
  .legend text {
    fill: ${e.pieLegendTextColor};
    font-family: ${e.fontFamily};
    font-size: ${e.pieLegendTextSize};
  }
`,"getStyles"),me=fe,he=i(e=>{const t=[...e.entries()].map(s=>({label:s[0],value:s[1]})).sort((s,n)=>n.value-s.value);return ae().value(s=>s.value)(t)},"createPieArcs"),Se=i((e,t,F,s)=>{C.debug(`rendering pie chart
`+e);const n=s.db,y=H(),T=J(n.getConfig(),y.pie),$=40,o=18,d=4,c=450,h=c,S=K(t),l=S.append("g");l.attr("transform","translate("+h/2+","+c/2+")");const{themeVariables:a}=y;let[A]=X(a.pieOuterStrokeWidth);A??=2;const _=T.textPosition,g=Math.min(h,c)/2-$,P=z().innerRadius(0).outerRadius(g),R=z().innerRadius(g*_).outerRadius(g*_);l.append("circle").attr("cx",0).attr("cy",0).attr("r",g+A/2).attr("class","pieOuterCircle");const b=n.getSections(),v=he(b),W=[a.pie1,a.pie2,a.pie3,a.pie4,a.pie5,a.pie6,a.pie7,a.pie8,a.pie9,a.pie10,a.pie11,a.pie12],p=Y(W);l.selectAll("mySlices").data(v).enter().append("path").attr("d",P).attr("fill",r=>p(r.data.label)).attr("class","pieCircle");let E=0;b.forEach(r=>{E+=r}),l.selectAll("mySlices").data(v).enter().append("text").text(r=>(r.data.value/E*100).toFixed(0)+"%").attr("transform",r=>"translate("+R.centroid(r)+")").style("text-anchor","middle").attr("class","slice"),l.append("text").text(n.getDiagramTitle()).attr("x",0).attr("y",-400/2).attr("class","pieTitleText");const x=l.selectAll(".legend").data(p.domain()).enter().append("g").attr("class","legend").attr("transform",(r,u)=>{const f=o+d,M=f*p.domain().length/2,O=12*o,L=u*f-M;return"translate("+O+","+L+")"});x.append("rect").attr("width",o).attr("height",o).style("fill",p).style("stroke",p),x.data(v).append("text").attr("x",o+d).attr("y",o-d).text(r=>{const{label:u,value:f}=r.data;return n.getShowData()?`${u} [${f}]`:u});const I=Math.max(...x.selectAll("text").nodes().map(r=>r?.getBoundingClientRect().width??0)),k=h+$+o+d+I;S.attr("viewBox",`0 0 ${k} ${c}`),ee(S,c,k,T.useMaxWidth)},"draw"),ve={draw:Se},ke={parser:ue,db:G,renderer:ve,styles:me};export{ke as diagram};
