/* Self-contained SVG charts: the frozen payload also drives the static exports. */
(() => {
  'use strict';
  const NS = 'http://www.w3.org/2000/svg';
  const format = value => new Intl.NumberFormat('zh-CN', { maximumFractionDigits: 3 }).format(value);
  const pointLabel = value => new Intl.NumberFormat('zh-CN', { maximumFractionDigits: 1 }).format(value);
  const node = (tag, attrs = {}, text = '') => {
    const item = document.createElementNS(NS, tag);
    for (const [key, value] of Object.entries(attrs)) item.setAttribute(key, value);
    if (text) item.textContent = text;
    return item;
  };
  const element = (tag, cls, text) => {
    const item = document.createElement(tag);
    if (cls) item.className = cls;
    if (text) item.textContent = text;
    return item;
  };
  const niceStep = maximum => {
    const raw = Math.max(maximum, .000001) / 5;
    const power = 10 ** Math.floor(Math.log10(raw));
    return [1, 2, 2.5, 5, 10].find(v => v * power >= raw) * power;
  };
  const axisRange = (values, fromZero) => {
    const low = Math.min(...values), high = Math.max(...values);
    // Fit both ends to expose variation without changing the samples. Keep
    // some headroom for labels, and a nonzero span for flat or all-zero data.
    const padding = fromZero ? Math.max(high * .1, .000001)
      : Math.max((high - low) * .12, Math.abs(high) * .01, .000001);
    const lower = fromZero ? 0 : Math.max(0, low - padding);
    const step = niceStep(high + padding - lower);
    const minimum = Math.floor(lower / step) * step;
    const maximum = Math.max(minimum + step, Math.ceil((high + padding) / step) * step);
    return { minimum, maximum, step };
  };

  for (const figure of document.querySelectorAll('.interactive-chart')) {
    const config = JSON.parse(figure.querySelector('.chart-config').textContent);
    const frame = figure.querySelector('.chart-frame');
    const controls = figure.querySelector('.chart-controls');
    const readout = figure.querySelector('.chart-readout');
    // A much faster stage can otherwise flatten all consumer curves on the shared scale.
    const visible = new Set(config.initialVisible ?? config.series.map(s => s.key));
    const xs = config.series[0].x;
    // Keep the comparison bound to both full-precision source series even when
    // the reader hides a line. Visibility and axis controls affect only the top panel.
    const ratios = config.ratio ? config.series.find(s => s.key === config.ratio.numerator).y.map((value, i) =>
      value / config.series.find(s => s.key === config.ratio.denominator).y[i]) : null;
    const ratioColor = value => value >= 1 ? '#2364d2' : '#0d8d7b';
    let index = xs.indexOf(config.initialBatch ?? 32), labels = Boolean(config.labels), autoscale = true;
    let zeroBaseline = config.zeroBaseline ?? true;
    const choices = new Map();
    let plot, ratioPlot, marker, svg;
    const legend = element('div', 'chart-legend');
    legend.setAttribute('role', 'group');
    legend.setAttribute('aria-label', config.title + ' · 曲线选择');
    const options = element('div', 'chart-options');
    const hint = element('p', 'chart-hint', '勾选显示曲线，或点「只看」放大比较。悬停 / 轻触看数值；图上可用 ← → 切换 batch。');
    if (ratios) hint.textContent = '上下图悬停、点选与方向键联动。曲线筛选及纵轴设置仅影响上图；附图始终使用两端完整数据。';
    controls.append(legend, options, hint);
    const scaleNote = element('p', 'chart-scale-note');
    frame.before(scaleNote);
    for (const series of config.series) {
      const chip = element('div', 'series-chip');
      chip.style.setProperty('--series-color', series.color);
      const label = element('label', 'series-toggle');
      const input = document.createElement('input');
      input.type = 'checkbox'; input.checked = true;
      input.setAttribute('aria-label', '显示 ' + series.label);
      label.append(input, element('span', 'series-swatch' + (series.dashed ? ' dashed' : '')), document.createTextNode(series.label));
      const solo = element('button', 'series-solo', '只看');
      solo.type = 'button'; solo.setAttribute('aria-label', '只看 ' + series.label);
      chip.append(label, solo); legend.append(chip); choices.set(series.key, input);
      input.addEventListener('change', () => {
        if (input.checked) visible.add(series.key); else visible.delete(series.key);
        render();
      });
      solo.addEventListener('click', () => {
        visible.clear(); visible.add(series.key); render();
      });
    }
    const reset = element('button', 'chart-reset', '显示全部');
    reset.type = 'button'; reset.addEventListener('click', () => {
      config.series.forEach(s => visible.add(s.key)); render();
    });
    options.append(reset);
    for (const [name, initial, setter] of [
      ['显示点值', labels, value => { labels = value; }],
      ['随筛选缩放纵轴', true, value => { autoscale = value; }],
      ['纵轴从 0 开始', zeroBaseline, value => { zeroBaseline = value; }]
    ]) {
      const label = element('label', 'chart-option');
      const input = document.createElement('input'); input.type = 'checkbox'; input.checked = initial;
      input.addEventListener('change', () => { setter(input.checked); render(); });
      label.append(input, document.createTextNode(name)); options.append(label);
    }
    const selectLabel = element('label', 'batch-select-label', '总 BS ');
    const select = document.createElement('select');
    select.setAttribute('aria-label', config.title + ' · 查看总 batch size');
    for (const x of xs) { const option = element('option', '', String(x)); option.value = x; select.append(option); }
    select.value = xs[index];
    select.addEventListener('change', () => { index = xs.indexOf(Number(select.value)); selection(); });
    selectLabel.append(select); options.append(selectLabel);
    readout.setAttribute('aria-live', 'polite'); readout.setAttribute('aria-atomic', 'true');
    frame.tabIndex = 0;
    frame.setAttribute('role', 'group');
    frame.setAttribute('aria-label', config.title + '，左右方向键查看相邻 batch');

    function selection() {
      if (!plot) return;
      select.value = xs[index];
      marker.replaceChildren(); readout.replaceChildren();
      const selected = config.series.filter(s => visible.has(s.key));
      if (!selected.length && !ratios) {
        readout.append(element('span', 'chart-empty', '已隐藏全部曲线，点击「显示全部」恢复。'));
        return;
      }
      const x = plot.x(xs[index]);
      marker.append(node('line', { x1: x, x2: x, y1: plot.top, y2: plot.bottom, stroke: '#9cacc0', 'stroke-dasharray': '3 5' }));
      if (ratioPlot) {
        marker.append(node('line', { x1: x, x2: x, y1: ratioPlot.top, y2: ratioPlot.bottom, stroke: '#9cacc0', 'stroke-dasharray': '3 5' }));
        svg.querySelectorAll('[data-ratio-index]').forEach(bar => {
          const active = Number(bar.getAttribute('data-ratio-index')) === index;
          bar.setAttribute('fill-opacity', active ? '1' : '.72');
          bar.setAttribute('stroke-width', active ? '2' : '0');
          bar.setAttribute('data-selected', String(active));
        });
      }
      const batch = element('div', 'readout-batch');
      batch.append(element('strong', '', 'BS ' + xs[index]), element('span', '', `${xs[index] / 4} / card`));
      readout.append(batch);
      for (const series of ratios ? config.series : selected) {
        const value = series.y[index];
        if (visible.has(series.key)) marker.append(node('circle', { cx: x, cy: plot.y(value), r: 5, fill: series.color, stroke: '#fff', 'stroke-width': 2 }));
        const item = element('div', 'readout-value');
        item.style.setProperty('--series-color', series.color);
        item.append(element('span', '', series.label), element('strong', '', format(value)));
        item.append(element('small', '', config.unit));
        if (config.band && series.key === 'h200') item.append(element('small', '', `P10–P90：${format(config.band[1][index])}–${format(config.band[2][index])}`));
        readout.append(item);
      }
      if (ratios) {
        const value = ratios[index], delta = (value - 1) * 100;
        const item = element('div', 'readout-value readout-ratio');
        item.style.setProperty('--series-color', ratioColor(value));
        item.append(element('span', '', config.ratio.label + ' · 吞吐比值'), element('strong', '', value.toFixed(3) + '×'),
          element('small', '', delta === 0 ? '与 H200 持平' : `比 H200 ${delta > 0 ? '高' : '低'} ${pointLabel(Math.abs(delta))}%`));
        readout.append(item);
      }
    }

    function render() {
      for (const [key, input] of choices) {
        input.checked = visible.has(key);
        input.closest('.series-chip').classList.toggle('is-hidden', !input.checked);
      }
      const width = Math.max(frame.clientWidth, 260), mobile = width < 600;
      const mainHeight = mobile ? 290 : 370, height = mainHeight + (ratios ? 230 : 0);
      const left = mobile ? 48 : 66, right = ratios ? 30 : 20, top = 38, bottom = mainHeight - 44;
      // Leave half a batch interval at the edges so the first and last bars fit.
      const xInset = ratios ? Math.min(20, (width - left - right) / xs.length / 2) : 0;
      const selected = config.series.filter(s => visible.has(s.key));
      const scaleSeries = autoscale && selected.length ? selected : config.series;
      const values = scaleSeries.flatMap(s => s.y);
      if (config.band && scaleSeries.some(s => s.key === 'h200')) values.push(...config.band[1], ...config.band[2]);
      const { minimum, maximum, step } = axisRange(values, zeroBaseline);
      const rangeText = `${ratios ? '主图' : ''}纵轴范围：${format(minimum)}–${format(maximum)}`
        + (minimum > 0 ? ' · 非零起点，突出变化趋势' : ' · 从 0 开始，比较绝对比例');
      scaleNote.textContent = rangeText;
      scaleNote.classList.toggle('is-zoomed', minimum > 0);
      plot = { top, bottom, x: value => left + xInset + (value - xs[0]) / (xs.at(-1) - xs[0]) * (width - left - right - 2 * xInset),
        y: value => bottom - (value - minimum) / (maximum - minimum) * (bottom - top) };
      svg = node('svg', { viewBox: `0 0 ${width} ${height}`, role: 'img', 'aria-label': config.title,
        class: 'live-chart', 'data-y-min': minimum, 'data-y-max': maximum });
      svg.append(node('title', {}, config.title));
      svg.append(node('text', { x: left, y: 16, class: 'axis-title' }, '纵轴：' + config.unit));
      svg.append(node('desc', {}, '使用图外的曲线开关筛选，数值显示在图下。' + rangeText
        + (autoscale ? '，范围随可见曲线变化。' : '，范围按全部曲线固定。')));
      for (let i = 0; i <= Math.round((maximum - minimum) / step); i++) {
        const value = minimum + i * step, y = plot.y(value);
        svg.append(node('line', { x1: left, x2: width - right, y1: y, y2: y, stroke: i ? '#e8eef5' : '#bccbdd' }));
        svg.append(node('text', { x: left - 10, y: y + 4, 'text-anchor': 'end', class: 'axis-label' }, format(value)));
      }
      const skip = mobile ? 3 : 1;
      xs.forEach((x, i) => {
        if (i % skip && i !== xs.length - 1) return;
        svg.append(node('text', { x: plot.x(x), y: height - 22, 'text-anchor': 'middle', class: 'axis-label' }, String(x)));
      });
      svg.append(node('text', { x: (left + width - right) / 2, y: height - 2, 'text-anchor': 'middle', class: 'axis-title' }, '总 batch size（4 card）'));
      if (config.band && visible.has('h200')) {
        const [x, low, high] = config.band;
        const points = x.map((v, i) => `${plot.x(v)},${plot.y(high[i])}`).concat(x.map((v, i) => `${plot.x(v)},${plot.y(low[i])}`).reverse());
        svg.append(node('polygon', { points: points.join(' '), fill: '#0d8d7b', opacity: '.09', 'data-band': 'h200' }));
      }
      // Straight segments preserve the samples and do not imply interpolated measurements.
      for (const series of selected) {
        const group = node('g', { 'data-series': series.key });
        const points = series.x.map((x, i) => `${plot.x(x)},${plot.y(series.y[i])}`);
        group.append(node('polyline', { points: points.join(' '), fill: 'none', stroke: series.color,
          'stroke-width': series.dashed ? 1.8 : 2.8, 'stroke-dasharray': series.dashed ? '6 5' : 'none', 'stroke-linejoin': 'round' }));
        series.x.forEach((x, i) => {
          group.append(node('circle', { cx: plot.x(x), cy: plot.y(series.y[i]), r: mobile ? 2.5 : 3.5,
            fill: '#fff', stroke: series.color, 'stroke-width': 1.8 }));
          if (labels && (!mobile || i % skip === 0 || i === xs.length - 1)) {
            // Separate the two throughput labels and keep endpoint labels inside the plot.
            const anchor = i === 0 ? 'start' : i === xs.length - 1 ? 'end' : 'middle';
            const peer = config.series.length === 2 ? config.series.find(s => s.key !== series.key) : null;
            const offset = peer && series.y[i] < peer.y[i] ? 18 : -10;
            group.append(node('text', { x: plot.x(x), y: plot.y(series.y[i]) + offset,
              'text-anchor': anchor, fill: series.color, class: 'point-value' }, pointLabel(series.y[i])));
          }
        });
        svg.append(group);
      }
      if (!selected.length) svg.append(node('text', { x: width / 2, y: (top + bottom) / 2, 'text-anchor': 'middle', class: 'axis-title' }, '请选择至少一条曲线'));
      if (ratios) {
        const ratioTop = bottom + 72, ratioBottom = height - 44;
        const range = axisRange([...ratios, 1], true);
        const barWidth = Math.min(30, (plot.x(xs[1]) - plot.x(xs[0])) * .5);
        ratioPlot = { top: ratioTop, bottom: ratioBottom,
          y: value => ratioBottom - value / range.maximum * (ratioBottom - ratioTop) };
        const group = node('g', { class: 'ratio-panel', 'data-ratio-max': range.maximum });
        group.append(node('rect', { x: left, y: ratioTop - 8, width: width - left - right,
          height: ratioBottom - ratioTop + 8, rx: 6, fill: '#f7faff' }));
        group.append(node('text', { x: left, y: ratioTop - 30, class: 'ratio-title' }, config.ratio.label + ' · 吞吐比值（倍）'));
        if (!mobile) group.append(node('text', { x: width - right, y: ratioTop - 30, 'text-anchor': 'end', class: 'axis-title' },
          '蓝 ≥ 1×：Zeus 较高或持平　绿 < 1×：H200 较高'));
        for (let i = 0; i <= Math.round(range.maximum / range.step); i++) {
          const value = i * range.step, y = ratioPlot.y(value);
          group.append(node('line', { x1: left, x2: width - right, y1: y, y2: y, stroke: i ? '#e4ecf6' : '#bccbdd' }));
          group.append(node('text', { x: left - 10, y: y + 4, 'text-anchor': 'end', class: 'axis-label' }, format(value) + '×'));
        }
        const ratioLabels = node('g');
        ratios.forEach((value, i) => {
          const x = plot.x(xs[i]), y = ratioPlot.y(value);
          const bar = node('rect', { x: x - barWidth / 2, y, width: barWidth, height: ratioBottom - y,
            rx: 3, fill: ratioColor(value), stroke: ratioColor(value), 'data-ratio-index': i, 'data-ratio': value });
          bar.append(node('title', {}, `BS ${xs[i]} · ${config.ratio.label}：${value.toFixed(3)}×`));
          group.append(bar);
          if (labels && (!mobile || i % skip === 0 || i === xs.length - 1)) ratioLabels.append(node('text', {
            x, y: y - 8, 'text-anchor': 'middle', fill: ratioColor(value), class: 'point-value ratio-value'
          }, value.toFixed(2) + '×'));
        });
        const baseline = ratioPlot.y(1);
        group.append(node('line', { x1: left, x2: width - right, y1: baseline, y2: baseline,
          stroke: '#687c95', 'stroke-width': 1.2, 'stroke-dasharray': '4 4', 'data-ratio-baseline': 1 }));
        group.append(ratioLabels);
        group.append(node('text', { x: width - right - 4, y: baseline - 8, 'text-anchor': 'end',
          class: 'point-value', fill: '#49617c' }, '1× · 吞吐持平'));
        svg.append(group);
      }
      marker = node('g', { class: 'chart-selection', 'pointer-events': 'none' }); svg.append(marker);
      frame.replaceChildren(svg); selection();
    }
    function point(event) {
      const rect = svg.getBoundingClientRect();
      const x = (event.clientX - rect.left) * svg.viewBox.baseVal.width / rect.width;
      const next = xs.reduce((best, value, i) => Math.abs(plot.x(value) - x) < Math.abs(plot.x(xs[best]) - x) ? i : best, 0);
      if (next !== index) { index = next; selection(); }
    }
    frame.addEventListener('pointermove', event => { if (event.pointerType !== 'touch') point(event); });
    frame.addEventListener('pointerdown', point);
    frame.addEventListener('keydown', event => {
      if (!['ArrowLeft', 'ArrowRight', 'Home', 'End'].includes(event.key)) return;
      event.preventDefault();
      index = event.key === 'Home' ? 0 : event.key === 'End' ? xs.length - 1
        : Math.min(xs.length - 1, Math.max(0, index + (event.key === 'ArrowRight' ? 1 : -1)));
      selection();
    });
    render();
    new ResizeObserver(render).observe(frame);
    figure.classList.add('is-interactive');
  }
})();
