(() => {
  "use strict";
  const data = JSON.parse(document.getElementById("measurements").textContent);
  const tokenSelect = document.getElementById("token-select");
  const caseSelect = document.getElementById("case-select");
  const chart = document.getElementById("ep-chart");
  const stageNames = ["router", "shared", "routed", "reduce"];
  const ms = cycles => (cycles / (data.clock_mhz * 1000)).toFixed(7);
  function fillCases() {
    const old = caseSelect.value;
    caseSelect.replaceChildren();
    for (const row of data.batches.filter(row => row.T === Number(tokenSelect.value))) {
      const option = new Option(row.case.replace("s", "seed ").replace("_", " · "), row.case);
      caseSelect.add(option);
    }
    if ([...caseSelect.options].some(option => option.value === old)) caseSelect.value = old;
  }
  function render() {
    const batch = data.batches.find(row => row.T === Number(tokenSelect.value) && row.case === caseSelect.value);
    chart.replaceChildren();
    const tbody = document.getElementById("core-table-body");
    tbody.replaceChildren();
    for (const ep of batch.per_ep) {
      const row = document.createElement("div");
      row.className = "ep-row";
      const label = document.createElement("strong");
      label.textContent = `EP${ep.ep}${batch.slow_eps.includes(ep.ep) ? " · 最慢" : ""}`;
      const track = document.createElement("div");
      track.className = "ep-track";
      track.setAttribute("role", "img");
      track.setAttribute("aria-label", `EP${ep.ep}: ${stageNames.map(name => `${name} ${ms(ep.stages[name].cycles)} ms`).join("; ")}`);
      for (const name of stageNames) {
        const stage = ep.stages[name];
        const segment = document.createElement("div");
        segment.className = `ep-segment ${name}`;
        segment.style.width = `${stage.cycles / batch.ds_cycles * 100}%`;
        segment.title = `${name}: ${ms(stage.cycles)} ms`;
        track.append(segment);
        const tr = document.createElement("tr");
        for (const value of [`EP${ep.ep}`, name, ms(stage.core_cycles["0"]), ms(stage.core_cycles["1"]), ms(stage.cycles)]) {
          const td = document.createElement("td");
          td.textContent = value;
          tr.append(td);
        }
        tbody.append(tr);
      }
      const duration = document.createElement("span");
      duration.textContent = `${ms(ep.cycles)} ms`;
      row.append(label, track, duration);
      chart.append(row);
    }
    document.getElementById("explorer-status").textContent = `T${batch.T} · ${batch.case}：DS 最慢完整 EP ${ms(batch.ds_cycles)} ms；GLM ${ms(batch.glm_cycles)} ms；同 batch 比值 ${(batch.ds_cycles / batch.glm_cycles).toFixed(5)}。条宽在当前 batch 内使用同一刻度。`;
    document.getElementById("explorer").dataset.case = `${batch.T}/${batch.case}`;
  }
  tokenSelect.addEventListener("change", () => { fillCases(); render(); });
  caseSelect.addEventListener("change", render);
  document.getElementById("print-page").addEventListener("click", () => window.print());
  const disclosure = document.querySelectorAll("details");
  let states;
  window.addEventListener("beforeprint", () => { states = [...disclosure].map(node => node.open); disclosure.forEach(node => { node.open = true; }); });
  window.addEventListener("afterprint", () => disclosure.forEach((node, i) => { node.open = states[i]; }));
  fillCases();
  caseSelect.value = "s528590_independent";
  render();
  document.getElementById("interactive-controls").hidden = false;
})();
