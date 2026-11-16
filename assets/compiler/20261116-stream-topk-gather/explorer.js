/* Use frozen trace times; subtracks separate overlapping command envelopes. */
(() => {
  'use strict';
  const data=window.ROUTER_TIMELINE,container=document.querySelector('#explorer');
  const detail=document.querySelector('#eventDetail'),coreSelect=document.querySelector('#coreSelect'),windowSelect=document.querySelector('#windowSelect');
  const colors={topk:'#b57632',sigmoid:'#377ca2',bias:'#93bdcc',gather:'#bd4b52',rsqrt:'#528c6c',square:'#73a17e',normalize:'#23715e',LD:'#9daab2',PE:'#846eac',ST:'#5f6e7b'};
  const phases={topk:'TopK',sigmoid:'sigmoid / PRG',bias:'bias',gather:'Gather',rsqrt:'rsqrt',square:'square',normalize:'normalize + scale'};
  const windows={full:[0,11400],a:[3650,4950],b:[5500,7450],c:[8150,10550]};
  const ns='http://www.w3.org/2000/svg';
  const node=(tag,attrs={},text='')=>{
    const el=document.createElementNS(ns,tag);
    for(const [k,v] of Object.entries(attrs))el.setAttribute(k,String(v));
    if(text)el.textContent=text;return el;
  };
  function render(){
    const core=coreSelect.value,range=windows[windowSelect.value];
    const shift=core==='core0'&&windowSelect.value!=='full'?160:0;
    const start=range[0]-shift,end=range[1]-shift;
    const width=1100,height=650,left=95,right=20,scale=(width-left-right)/(end-start),x=t=>left+(t-start)*scale;
    const svg=node('svg',{viewBox:`0 0 ${width} ${height}`,role:'img','aria-label':`${core} OFF 与 ON 实际 trace，native cycle ${start} 到 ${end}`,xmlns:ns});
    svg.append(node('rect',{width,height,fill:'#fff'}));
    svg.append(node('text',{x:left,y:24,fill:'#213e45','font-size':15,'font-weight':700},`${core} · native launch cycles · [${start}, ${end}]`));
    const defs=node('defs'),clip=node('clipPath',{id:'trace-clip'});
    clip.append(node('rect',{x:left,y:35,width:width-left-right,height:height-80}));defs.append(clip);svg.append(defs);
    ['off','on'].forEach((mode,mi)=>{
      const c=data[mode][core],base=72+mi*283,rowY=i=>base+20+i*27;
      svg.append(node('text',{x:15,y:base-16,fill:'#213e45','font-size':14,'font-weight':700},`${mode.toUpperCase()} · ${c.launch_cycles.toLocaleString()} cycles`));
      ['LD','PE','VP0','VP1','VP2','VP3','CT Gather','ST'].forEach((label,i)=>{
        svg.append(node('text',{x:left-10,y:rowY(i)+4,'text-anchor':'end',fill:'#65777a','font-size':11},label));
        svg.append(node('line',{x1:left,x2:width-right,y1:rowY(i)+12,y2:rowY(i)+12,stroke:'#edf0ed'}));
      });
      const ends=[[],[],[],[]],slots=new Map();
      c.events.filter(e=>e.kind==='VP').sort((a,b)=>a.raw_start-b.raw_start).forEach(e=>{
        let n=ends[e.lane].findIndex(t=>t<=e.raw_start);if(n<0)n=ends[e.lane].length;
        ends[e.lane][n]=e.raw_end;slots.set(e.pc_start,n);
      });
      const bars=node('g',{'clip-path':'url(#trace-clip)'});
      const plot=(e,unit,row,fill,isGather=false)=>{
        const a=e.raw_start,b=e.raw_end;if(b<=start||a>=end)return;
        let barHeight=17,y=rowY(row)-8.5;
        if(e.kind==='VP'){barHeight=21/ends[e.lane].length;y=rowY(row)-10.5+slots.get(e.pc_start)*barHeight;}
        const description=e.kind?`${mode.toUpperCase()} ${core} · ${e.group_name} lane${e.lane} · ${phases[e.phase]}${e.step!==undefined?' step'+e.step:''}${e.wave!==undefined?' wave'+e.wave:''}${e.k!==undefined?' ['+e.offset+','+(e.offset+e.k)+')':''}`:`${mode.toUpperCase()} ${core} · ${unit} · ${e.name}`;
        const text=`${description}\n${a} → ${b} cycles · 区间长度 ${b-a}\n${e.kind?'ASM L'+e.asm_start+(e.asm_end!==e.asm_start?'–'+e.asm_end:'')+' · PC 0x'+e.pc_start.toString(16):'PC 0x'+e.pc.toString(16)}\n${isGather?'CT 首次呈现 → 最终写回 resolved_at；含间隙与等待，不是 ALU busy。':'命令 start → done；细分轨表示命令区间重叠，不是额外硬件实例。'}`;
        const rect=node('rect',{x:x(a),y,width:Math.max(.8,(b-a)*scale),height:Math.max(2,barHeight-.6),fill,opacity:isGather?.78:.9,tabindex:0,role:'button','aria-label':description});
        rect.append(node('title',{},text));const show=()=>{detail.textContent=text;};
        rect.addEventListener('pointerenter',show);rect.addEventListener('focus',show);rect.addEventListener('click',show);
        rect.addEventListener('keydown',ev=>{if(ev.key==='Enter'||ev.key===' '){ev.preventDefault();show();}});bars.append(rect);
      };
      c.engines.forEach(e=>plot(e,e.unit,{LD:0,PE:1,ST:7}[e.unit],colors[e.unit]));
      c.events.forEach(e=>plot(e,e.kind,e.phase==='gather'?6:2+e.lane,colors[e.phase],e.phase==='gather'));
      svg.append(bars);
      const tick=end-start>5000?2000:end-start>1800?400:200;
      for(let t=Math.ceil(start/tick)*tick;t<=end;t+=tick){
        svg.append(node('line',{x1:x(t),x2:x(t),y1:base+3,y2:rowY(7)+15,stroke:'#87998f','stroke-opacity':.18,'pointer-events':'none'}));
        svg.append(node('text',{x:x(t),y:rowY(7)+34,'text-anchor':'middle',fill:'#65777a','font-size':11},String(t)));
      }
    });
    container.replaceChildren(svg);detail.style.whiteSpace='pre-line';
    detail.textContent=`${core} · ${windowSelect.selectedOptions[0].textContent} · 两图同尺度。悬停或点击色块读取实际事件；局部窗口可能裁切已经开始的命令。`;
  }
  if(!data){detail.textContent='交互数据未加载；下方静态图仍可阅读。';return;}
  coreSelect.addEventListener('change',render);windowSelect.addEventListener('change',render);
  document.querySelector('#exportSvg').addEventListener('click',()=>{
    const blob=new Blob([new XMLSerializer().serializeToString(container.firstChild)],{type:'image/svg+xml'});
    const url=URL.createObjectURL(blob),a=document.createElement('a');a.href=url;
    a.download=`stream-topk-${coreSelect.value}-${windowSelect.value}.svg`;a.click();setTimeout(()=>URL.revokeObjectURL(url),1000);
  });
  render();
})();
