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

  for (const figure of document.querySelectorAll('.interactive-chart')) {
    const config = JSON.parse(figure.querySelector('.chart-config').textContent);
    const frame = figure.querySelector('.chart-frame');
    const controls = figure.querySelector('.chart-controls');
    const readout = figure.querySelector('.chart-readout');
    // A much faster stage can otherwise flatten all consumer curves on the shared scale.
    const visible = new Set(config.initialVisible ?? config.series.map(s => s.key));
    const xs = config.series[0].x;
    let index = xs.indexOf(config.initialBatch ?? 32), labels = Boolean(config.labels), autoscale = true;
    const choices = new Map();
    let plot, marker, svg;
    const legend = element('div', 'chart-legend');
    legend.setAttribute('role', 'group');
    legend.setAttribute('aria-label', config.title + ' · 曲线选择');
    const options = element('div', 'chart-options');
    const hint = element('p', 'chart-hint', '勾选显示曲线，或点「只看」放大比较。悬停 / 轻触看数值；图上可用 ← → 切换 batch。');
    controls.append(legend, options, hint);
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
      ['随筛选缩放纵轴', true, value => { autoscale = value; }]
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
      if (!selected.length) {
        readout.append(element('span', 'chart-empty', '已隐藏全部曲线，点击「显示全部」恢复。'));
        return;
      }
      const x = plot.x(xs[index]);
      marker.append(node('line', { x1: x, x2: x, y1: plot.top, y2: plot.bottom, stroke: '#9cacc0', 'stroke-dasharray': '3 5' }));
      const batch = element('div', 'readout-batch');
      batch.append(element('strong', '', 'BS ' + xs[index]), element('span', '', `${xs[index] / 4} / card`));
      readout.append(batch);
      for (const series of selected) {
        const value = series.y[index];
        marker.append(node('circle', { cx: x, cy: plot.y(value), r: 5, fill: series.color, stroke: '#fff', 'stroke-width': 2 }));
        const item = element('div', 'readout-value');
        item.style.setProperty('--series-color', series.color);
        item.append(element('span', '', series.label), element('strong', '', format(value)));
        item.append(element('small', '', config.unit));
        if (config.band && series.key === 'h200') item.append(element('small', '', `P10–P90：${format(config.band[1][index])}–${format(config.band[2][index])}`));
        readout.append(item);
      }
    }

    function render() {
      for (const [key, input] of choices) {
        input.checked = visible.has(key);
        input.closest('.series-chip').classList.toggle('is-hidden', !input.checked);
      }
      const width = Math.max(frame.clientWidth, 260), mobile = width < 600;
      const height = mobile ? 290 : 370;
      const left = mobile ? 48 : 66, right = 20, top = 38, bottom = height - 44;
      const selected = config.series.filter(s => visible.has(s.key));
      const scaleSeries = autoscale && selected.length ? selected : config.series;
      const values = scaleSeries.flatMap(s => s.y);
      if (config.band && scaleSeries.some(s => s.key === 'h200')) values.push(...config.band[2]);
      const step = niceStep(Math.max(...values) * 1.1);
      const maximum = Math.ceil(Math.max(...values) * 1.1 / step) * step;
      plot = { top, bottom, x: value => left + (value - xs[0]) / (xs.at(-1) - xs[0]) * (width - left - right),
        y: value => bottom - value / maximum * (bottom - top) };
      svg = node('svg', { viewBox: `0 0 ${width} ${height}`, role: 'img', 'aria-label': config.title, class: 'live-chart' });
      svg.append(node('title', {}, config.title));
      svg.append(node('text', { x: left, y: 16, class: 'axis-title' }, '纵轴：' + config.unit));
      svg.append(node('desc', {}, '使用图外的曲线开关筛选，数值显示在图下。纵轴始终从零起，' + (autoscale ? '上限随可见曲线变化。' : '上限固定。')));
      for (let i = 0; i <= Math.round(maximum / step); i++) {
        const value = i * step, y = plot.y(value);
        svg.append(node('line', { x1: left, x2: width - right, y1: y, y2: y, stroke: i ? '#e8eef5' : '#bccbdd' }));
        svg.append(node('text', { x: left - 10, y: y + 4, 'text-anchor': 'end', class: 'axis-label' }, format(value)));
      }
      const skip = mobile ? 3 : 1;
      xs.forEach((x, i) => {
        if (i % skip && i !== xs.length - 1) return;
        svg.append(node('text', { x: plot.x(x), y: bottom + 22, 'text-anchor': 'middle', class: 'axis-label' }, String(x)));
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
      if (!selected.length) svg.append(node('text', { x: width / 2, y: height / 2, 'text-anchor': 'middle', class: 'axis-title' }, '请选择至少一条曲线'));
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
