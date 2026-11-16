"""Rebuild the article's measured figures from the adjacent frozen JSON files."""
import json
from pathlib import Path

import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
from matplotlib.patches import Patch

ROOT = Path(__file__).resolve().parent
DATA = json.loads((ROOT/'timeline.json').read_text())
EVIDENCE = json.loads((ROOT/'evidence.json').read_text())
plt.rcParams.update({'font.family':'Noto Sans CJK JP','font.size':10,
                     'axes.spines.top':False,'axes.spines.right':False,
                     'axes.labelcolor':'#293d43','text.color':'#293d43',
                     'xtick.color':'#52676d','ytick.color':'#52676d',
                     'figure.facecolor':'#fcfcf8','axes.facecolor':'#fcfcf8',
                     'svg.hashsalt':'stream-topk-20261116'})
COLORS = dict(topk='#b57632',sigmoid='#377ca2',bias='#93bdcc',
              gather='#bd4b52',rsqrt='#528c6c',square='#73a17e',
              normalize='#23715e',LD='#9daab2',PE='#846eac',ST='#5f6e7b')


def save(fig,name):
    fig.savefig(ROOT/(name+'.svg'),bbox_inches='tight',metadata={'Date':None})
    # Matplotlib emits trailing spaces inside path data. Keep generated
    # vector files clean without changing geometry or formatting user files.
    vector=ROOT/(name+'.svg')
    vector.write_text('\n'.join(line.rstrip() for line in vector.read_text().splitlines())+'\n')
    fig.savefig(ROOT/(name+'.png'),bbox_inches='tight',dpi=150)
    plt.close(fig)


def timeline(name,start,end,title):
    fig,axs=plt.subplots(2,1,figsize=(13.5,7),sharex=True)
    for ax,mode in zip(axs,('off','on')):
        c=DATA[mode]['core1']
        lanes={lane:[] for lane in range(4)}
        slots={}
        for e in sorted(c['events'],key=lambda e:e['raw_start']):
            if e['kind']!='VP':continue
            ends=lanes[e['lane']]
            slot=next((i for i,t in enumerate(ends) if t<=e['raw_start']),len(ends))
            if slot==len(ends):ends.append(0)
            ends[slot]=e['raw_end'];slots[e['pc_start']]=slot
        for event in c['engines']:
            a,b=event['raw_start'],event['raw_end']
            if b<=start or a>=end:continue
            y={'LD':0,'PE':1,'ST':7}[event['unit']]
            ax.barh(y,b-a,left=a,height=.55,color=COLORS[event['unit']],alpha=.8)
        for e in c['events']:
            a,b=e['raw_start'],e['raw_end']
            if b<=start or a>=end:continue
            height=.58 if e['phase']=='gather' else .72/len(lanes[e['lane']])
            y=6 if e['phase']=='gather' else 2+e['lane']-.36+height*(slots[e['pc_start']]+.5)
            ax.barh(y,b-a,left=a,height=height*.94,color=COLORS[e['phase']],
                    edgecolor='#fff',linewidth=.4,hatch='//' if e['phase']=='gather' else None,
                    alpha=.77 if e['phase']=='gather' else .88)
            if end-start<3000:
                label=(f"{e['group_name']}{e['lane']}:{e['offset']}+{e['k']}"
                       if e['phase']=='gather' else
                       f"{e['group_name']}.{e['step']}" if e['phase']=='topk' and e['step'] in (3,7) else
                       f"{e['group_name']}.r" if e['phase']=='rsqrt' else
                       f"{e['group_name']}.n" if e['phase']=='normalize' else '')
                if label:ax.text((a+b)/2,y,label,ha='center',va='center',fontsize=6.7,color='white',clip_on=True)
        ax.set_yticks(range(8),['LD','PE','VP0','VP1','VP2','VP3','CT Gather','ST'])
        ax.set_ylim(7.6,-.7);ax.set_xlim(start,end);ax.grid(axis='x',alpha=.18)
        ax.set_axisbelow(True)
        ax.set_title(f"{mode.upper()} · core1 · launch {c['launch_cycles']:,} cycles",loc='left',fontsize=11,fontweight='bold')
    axs[1].set_xlabel('Native launch cycle（两图同一原点、同一比例）')
    fig.suptitle(title,x=.07,ha='left',fontsize=16,fontweight='bold')
    fig.legend(handles=[Patch(color=COLORS[k],label=v) for k,v in [('topk','TopK step'),('sigmoid','sigmoid / PRG'),('rsqrt','归一化 VP'),('gather','CT Gather 执行窗口')]],
               loc='lower center',ncol=4,frameon=False,bbox_to_anchor=(.5,-.025))
    fig.tight_layout(rect=(0,.03,1,.95))
    save(fig,name)


timeline('timeline-full',0,11400,'01  /  全程：同样的工作，缩短相邻阶段之间的空档')
timeline('timeline-a',3650,4950,'02  /  A → B：前缀 Gather 与 TopK 尾部、下一组 sigmoid 重叠')
timeline('timeline-b',5500,7450,'03  /  B → C：把 A 的归一化放进 B 的 Gather 窗口')
timeline('timeline-c',8150,10550,'04  /  末组 C：保留完整 Gather，避免无后继时的分段成本')

fig,ax=plt.subplots(figsize=(11.5,3.2))
for i,core in enumerate(('core0','core1')):
    for j,mode in enumerate(('off','on')):
        value=DATA[mode][core]['launch_cycles'];y=i+(j-.5)*.28
        ax.barh(y,value,height=.25,color=('#9aa7ac','#23715e')[j])
        ax.text(value+85,y,f'{value:,}',va='center',fontweight='bold')
ax.set_yticks([0,1],['core0','core1（慢核）']);ax.invert_yaxis();ax.set_xlim(0,12600)
ax.set_xlabel('Native launch cycles');ax.grid(axis='x',alpha=.15);ax.set_axisbelow(True)
ax.set_title('完整 Router：两核均减少 752 cycles；慢核延迟 −6.63%',loc='left',fontsize=15,fontweight='bold')
ax.legend(handles=[Patch(color='#9aa7ac',label='OFF'),Patch(color='#23715e',label='ON')],frameon=False)
save(fig,'latency')

keys=['A_topk_done','B_sigmoid_start','B_topk_start','C_topk_start','C_rsqrt_start','C_rsqrt_done','launch_done']
labels=['A TopK\n完成','B sigmoid\n开始','B TopK\n开始','C TopK\n开始','C rsqrt\n开始','C rsqrt\n完成','kernel\n完成']
lead=[DATA['off']['core1']['milestones'][k]-DATA['on']['core1']['milestones'][k] for k in keys]
fig,ax=plt.subplots(figsize=(11.5,3.4));ax.plot(range(len(keys)),lead,'o-',color='#23715e',lw=2.5)
ax.fill_between(range(len(keys)),lead,color='#23715e',alpha=.08)
for i,v in enumerate(lead):ax.annotate(str(v),(i,v),xytext=(0,10),textcoords='offset points',ha='center',fontweight='bold')
ax.set_xticks(range(len(keys)),labels);ax.set_ylim(-50,1160);ax.set_ylabel('ON 相对 OFF 提前的 cycles')
ax.grid(axis='y',alpha=.2);ax.set_title('领先量不是可相加的收益：987 → 752，收尾回吐 235 cycles',loc='left',fontsize=15,fontweight='bold')
save(fig,'checkpoints')

fig,ax=plt.subplots(figsize=(11.5,3.2))
for i,mode in enumerate(('off','on')):
    c=EVIDENCE['runs'][mode]['cores']['core1'];busy=c['asynchronous_busy_union'];idle=c['asynchronous_idle']
    ax.barh(i,busy,height=.5,color='#377ca2');ax.barh(i,idle,left=busy,height=.5,color='#e5c39e')
    ax.text(busy/2,i,f'至少一个异步引擎有命令区间：{busy:,}',va='center',ha='center',color='white')
    ax.text(busy+idle/2,i,str(idle),va='center',ha='center',fontsize=9)
ax.set_yticks([0,1],['OFF','ON']);ax.invert_yaxis();ax.set_xlim(0,11600)
ax.set_xlabel('Report span cycles；不包含 CT 推导 busy 或 MAIL wait')
ax.set_title('空档少 887，异步忙碌区间并集多 135 → 总跨度少 752',loc='left',fontsize=15,fontweight='bold')
ax.legend(handles=[Patch(color='#377ca2',label='LD / PE / VP / ST 区间并集'),Patch(color='#e5c39e',label='这些异步引擎均无活动区间')],frameon=False)
save(fig,'occupancy')
print('Wrote seven measured SVG/PNG pairs.')
