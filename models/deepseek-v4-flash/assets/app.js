(() => {
  "use strict";
  const data = JSON.parse(document.getElementById("measurements").textContent);
  const stages = ["router", "shared", "routed", "reduce"];
  const names = {router: "Router", shared: "Shared", routed: "Routed", reduce: "Reduce"};
  const batchSelect = document.getElementById("token-select");
  const layerSelect = document.getElementById("layer-select");
  const rankSelect = document.getElementById("rank-select");
  const chart = document.getElementById("ep-chart");
  const ms = cycles => (cycles * 1000 / data.clock_hz).toFixed(7);
  const index = new Map(data.cases.map(row => [`${row.bs}/${row.layer}/${row.rank}`, row]));

  for (let layer = 0; layer < data.scope.layers; layer++) {
    layerSelect.add(new Option(`第 ${layer} 层${layer < 3 ? " · Hash" : " · Learned"}`, String(layer)));
  }
  layerSelect.value = "33";
  for (let rank = 0; rank < data.scope.ranks; rank++) {
    rankSelect.add(new Option(`rank ${rank}`, String(rank)));
  }

  function track(row, ceiling) {
    const node = document.createElement("div");
    node.className = "ep-track";
    node.setAttribute("role", "img");
    node.setAttribute("aria-label", stages.map(stage => `${names[stage]} ${ms(row.stages[stage].cycles)} ms`).join("；"));
    for (const stage of stages) {
      const segment = document.createElement("span");
      segment.className = `ep-segment ${stage}`;
      segment.style.width = `${row.stages[stage].cycles / ceiling * 100}%`;
      segment.title = `${names[stage]}：${ms(row.stages[stage].cycles)} ms`;
      node.append(segment);
    }
    return node;
  }

  function render() {
    const bs = Number(batchSelect.value), layer = Number(layerSelect.value);
    const rows = Array.from({length: data.scope.ranks}, (_, rank) => index.get(`${bs}/${layer}/${rank}`));
    const critical = rows.reduce((old, row) => row.cycles > old.cycles ? row : old);
    const selected = rankSelect.value === "critical" ? critical : rows[Number(rankSelect.value)];
    chart.replaceChildren();
    for (const row of rows) {
      const line = document.createElement("div");
      line.className = `ep-row${row.rank === selected.rank ? " selected" : ""}${row.cycles === critical.cycles ? " critical" : ""}`;
      const pick = document.createElement("button");
      pick.type = "button";
      pick.className = "rank-pick";
      pick.textContent = `r${row.rank}${row.cycles === critical.cycles ? " · 最慢" : ""}`;
      pick.setAttribute("aria-pressed", String(row.rank === selected.rank));
      pick.setAttribute("aria-label", `查看 rank ${row.rank} 的双核阶段时间`);
      pick.addEventListener("click", () => { rankSelect.value = String(row.rank); render(); });
      const duration = document.createElement("span");
      duration.className = "rank-duration";
      duration.textContent = `${ms(row.cycles)} ms`;
      line.append(pick, track(row, critical.cycles), duration);
      chart.append(line);
    }
    const details = document.getElementById("selected-stages");
    details.replaceChildren();
    const tbody = document.getElementById("core-table-body");
    tbody.replaceChildren();
    for (const stage of stages) {
      const item = selected.stages[stage];
      const card = document.createElement("div");
      card.className = `stage-stat stage-${stage}`;
      const label = document.createElement("span"), value = document.createElement("strong");
      label.textContent = names[stage];
      value.textContent = `${ms(item.cycles)} ms`;
      card.append(label, value);
      details.append(card);
      for (const launch of item.launches) {
        const tr = document.createElement("tr");
        const kernel = launch.kernel.replace("sgl_moe_", "").replace("_kernel", "");
        const values = [names[stage], kernel, `#${launch.launch}`, ms(launch.core_cycles[0]),
          ms(launch.core_cycles[1]), ms(launch.cycles)];
        for (const text of values) {
          const td = document.createElement("td");
          td.textContent = text;
          tr.append(td);
        }
        tbody.append(tr);
      }
    }
    const status = document.getElementById("explorer-status");
    status.textContent = `BS${bs} · 第 ${layer} 层 · 当前 rank ${selected.rank}：整链 ${ms(selected.cycles)} ms。`
      + `本层整链最慢 rank ${critical.rank}：${ms(critical.cycles)} ms（并列取低 rank）。`
      + `四段始终来自同一 rank；${data.status === "preview" ? "当前是未发布预览数据。" : "当前是最终组合交付数据。"}`;
    document.getElementById("explorer").dataset.case = `${bs}/${layer}/${selected.rank}`;
    document.getElementById("core-table-caption").textContent = `BS${bs} / layer${layer} / rank${selected.rank} · 每个实际计时 launch 的双核持续时间（ms）`;
  }

  for (const select of [batchSelect, layerSelect, rankSelect]) select.addEventListener("change", render);
  document.getElementById("print-page").addEventListener("click", () => window.print());
  const download = document.getElementById("download-data");
  download.textContent = data.status === "preview" ? "下载本页预览数据（JSON）" : "下载本轮公开数据（JSON）";
  download.addEventListener("click", () => {
    const url = URL.createObjectURL(new Blob([JSON.stringify(data, null, 2)], {type: "application/json"}));
    const link = document.createElement("a");
    link.href = url;
    link.download = `dsv4-moe-${data.measurement_id}.json`;
    link.click();
    setTimeout(() => URL.revokeObjectURL(url), 1000);
  });
  const disclosure = [...document.querySelectorAll("details")];
  let printStates = [];
  window.addEventListener("beforeprint", () => {
    printStates = disclosure.map(node => node.open);
    disclosure.forEach(node => { node.open = true; });
  });
  window.addEventListener("afterprint", () => {
    disclosure.forEach((node, index) => { node.open = Boolean(printStates[index]); });
  });
  render();
  document.getElementById("interactive-controls").hidden = false;
  download.hidden = false;
})();
