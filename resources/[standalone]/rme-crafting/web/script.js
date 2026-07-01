const RES = 'rme-crafting';
function post(name, data) {
  return fetch('https://' + RES + '/' + name, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json; charset=UTF-8' },
    body: JSON.stringify(data || {})
  }).catch(() => {});
}

let ITEMS = [], ITEM_MAP = {}, CATEGORIES = {}, JOBS = [], GANGS = [], PROPS = [], THEME = {};
let editing = null;      // bench being edited (deep copy)
let pickerTarget = null; // callback for item picker
let PICKER_CAT = 'All';

function esc(s){ return String(s==null?'':s).replace(/[&<>\"']/g, function(c){ return {'&':'&amp;','<':'&lt;','>':'&gt;','\"':'&quot;',\"'\":'&#39;'}[c]; }); }

function applyTheme(t){
  if(!t) return;
  document.documentElement.style.setProperty('--primary', t.primary || '#3B82F6');
  document.documentElement.style.setProperty('--accent', t.accent || '#22C55E');
}

function closeAll(){
  document.getElementById('creator').classList.add('hidden');
  document.getElementById('craft').classList.add('hidden');
  document.getElementById('itemPicker').classList.add('hidden');
}

// ================= messages =================
window.addEventListener('message', function(e){
  const d = e.data; if(!d || !d.action) return;
  if(d.action==='openCreator') openCreator(d);
  else if(d.action==='openCraft') openCraft(d);
  else if(d.action==='close') closeAll();
});
document.addEventListener('keyup', function(e){ if(e.key==='Escape'){ closeAll(); post('close'); } });

// ================= CREATOR =================
function openCreator(d){
  ITEMS=d.items||[]; CATEGORIES=d.categories||{}; JOBS=d.jobs||[]; GANGS=d.gangs||[]; PROPS=d.props||[]; THEME=d.theme||{};
  ITEM_MAP={}; ITEMS.forEach(function(i){ ITEM_MAP[i.name]=i; });
  applyTheme(THEME);
  editing=null;
  renderBenchList(d.benches||[]);
  document.getElementById('editor').classList.add('hidden');
  document.getElementById('editorEmpty').classList.remove('hidden');
  document.getElementById('craft').classList.add('hidden');
  document.getElementById('itemPicker').classList.add('hidden');
  document.getElementById('creator').classList.remove('hidden');
}

function renderBenchList(benches){
  const el=document.getElementById('benchList'); el.innerHTML='';
  if(!benches.length){ el.innerHTML='<div class=\"empty-note\">No benches yet. Click + New Bench.</div>'; return; }
  benches.forEach(function(b){
    const div=document.createElement('div'); div.className='bench-item';
    div.innerHTML='<div class=\"bi-title\">'+esc(b.label||'Bench')+'</div><div class=\"bi-sub\">'+((b.recipes||[]).length)+' recipe(s) &bull; '+esc(b.access||'public')+'</div>';
    div.onclick=function(){ editBench(b); };
    el.appendChild(div);
  });
}

function newBench(){
  editing={ id:null, label:'New Bench', prop:(PROPS[0]||'gr_prop_gr_bench_04a'), access:'public', accessValue:null, accessGrade:0, recipes:[] };
  renderEditor(true);
}
function editBench(b){
  editing=JSON.parse(JSON.stringify(b));
  editing.recipes=editing.recipes||[];
  renderEditor(false);
}

function renderEditor(isNew){
  document.getElementById('editorEmpty').classList.add('hidden');
  document.getElementById('editor').classList.remove('hidden');
  document.getElementById('placeBench').classList.toggle('hidden', !isNew);
  document.getElementById('saveBench').classList.toggle('hidden', isNew);
  document.getElementById('deleteBench').classList.toggle('hidden', isNew);
  renderBasic(); renderAccess(); renderRecipes(); renderSettings();
  switchTab('basic');
}

function switchTab(name){
  document.querySelectorAll('.tab').forEach(function(t){ t.classList.toggle('active', t.dataset.tab===name); });
  document.querySelectorAll('.tab-pane').forEach(function(p){ p.classList.toggle('active', p.dataset.pane===name); });
}

function renderBasic(){
  const pane=document.querySelector('[data-pane=\"basic\"]');
  const propOpts=PROPS.map(function(p){ return '<option value=\"'+esc(p)+'\"'+(editing.prop===p?' selected':'')+'>'+esc(p)+'</option>'; }).join('');
  pane.innerHTML='<label class=\"field\">Bench Name<input id=\"f-label\" value=\"'+esc(editing.label||'')+'\"/></label>'+
    '<label class=\"field\">Prop Model<select id=\"f-prop\">'+propOpts+'</select></label>'+
    '<div class=\"hint\">Pick the prop, then use Place Bench (new benches) to position it. During placement: Left/Right arrows rotate, Enter places, Backspace cancels.</div>';
  pane.querySelector('#f-label').oninput=function(e){ editing.label=e.target.value; };
  pane.querySelector('#f-prop').onchange=function(e){ editing.prop=e.target.value; };
}

function renderAccess(){
  const pane=document.querySelector('[data-pane=\"access\"]');
  const jobOpts=JOBS.map(function(j){ return '<option value=\"'+esc(j.name)+'\"'+(editing.accessValue===j.name?' selected':'')+'>'+esc(j.label)+'</option>'; }).join('');
  const gangOpts=GANGS.map(function(g){ return '<option value=\"'+esc(g.name)+'\"'+(editing.accessValue===g.name?' selected':'')+'>'+esc(g.label)+'</option>'; }).join('');
  const modes=['public','job','gang'].map(function(a){ return '<label class=\"radio '+(editing.access===a?'sel':'')+'\"><input type=\"radio\" name=\"acc\" value=\"'+a+'\"'+(editing.access===a?' checked':'')+'/> '+(a.charAt(0).toUpperCase()+a.slice(1))+'</label>'; }).join('');
  pane.innerHTML='<div class=\"access-modes\">'+modes+'</div>'+
    '<label class=\"field '+(editing.access==='job'?'':'hidden')+'\" id=\"acc-job\">Job<select id=\"f-job\">'+jobOpts+'</select></label>'+
    '<label class=\"field '+(editing.access==='job'?'':'hidden')+'\" id=\"acc-grade\">Minimum Grade<input id=\"f-grade\" type=\"number\" min=\"0\" value=\"'+(editing.accessGrade||0)+'\"/></label>'+
    '<label class=\"field '+(editing.access==='gang'?'':'hidden')+'\" id=\"acc-gang\">Gang<select id=\"f-gang\">'+gangOpts+'</select></label>'+
    '<div class=\"hint\">Public = anyone. Job/Gang = only members (and grade &gt;= minimum for jobs) can use this bench.</div>';
  pane.querySelectorAll('input[name=\"acc\"]').forEach(function(r){ r.onchange=function(e){
    editing.access=e.target.value;
    if(editing.access==='job' && !editing.accessValue) editing.accessValue=(JOBS[0]&&JOBS[0].name)||null;
    if(editing.access==='gang' && !editing.accessValue) editing.accessValue=(GANGS[0]&&GANGS[0].name)||null;
    if(editing.access==='public') editing.accessValue=null;
    renderAccess();
  }; });
  const jb=pane.querySelector('#f-job'); if(jb) jb.onchange=function(e){ editing.accessValue=e.target.value; };
  const gr=pane.querySelector('#f-grade'); if(gr) gr.oninput=function(e){ editing.accessGrade=parseInt(e.target.value)||0; };
  const gg=pane.querySelector('#f-gang'); if(gg) gg.onchange=function(e){ editing.accessValue=e.target.value; };
}

function renderRecipes(){
  const pane=document.querySelector('[data-pane=\"recipes\"]'); pane.innerHTML='';
  const add=document.createElement('button'); add.className='btn btn-accent'; add.textContent='+ Add Recipe';
  add.onclick=function(){ editing.recipes.push({ output:'', amount:1, time:5000, materials:[] }); renderRecipes(); };
  pane.appendChild(add);
  editing.recipes.forEach(function(r,ri){
    const card=document.createElement('div'); card.className='recipe-card';
    const outItem=ITEM_MAP[r.output];
    const outInner = r.output ? '<img src=\"'+(outItem?outItem.image:'')+'\" onerror=\"this.style.visibility=&#39;hidden&#39;\"/><span>'+esc(outItem?outItem.label:r.output)+'</span>' : '<span class=\"muted\">Pick output item</span>';
    const out=document.createElement('div'); out.innerHTML='<div class=\"mats-label\">Output</div><div class=\"ro-pick\">'+outInner+'</div>';
    out.querySelector('.ro-pick').onclick=function(){ openPicker(function(name){ r.output=name; renderRecipes(); }); };
    card.appendChild(out);
    const row=document.createElement('div'); row.className='recipe-row';
    row.innerHTML='<label>Amount<input type=\"number\" min=\"1\" value=\"'+(r.amount||1)+'\" class=\"r-amt\"/></label><label>Craft time (ms)<input type=\"number\" min=\"0\" value=\"'+(r.time||5000)+'\" class=\"r-time\"/></label>';
    row.querySelector('.r-amt').oninput=function(e){ r.amount=parseInt(e.target.value)||1; };
    row.querySelector('.r-time').oninput=function(e){ r.time=parseInt(e.target.value)||5000; };
    card.appendChild(row);
    const mats=document.createElement('div'); mats.className='mats'; mats.innerHTML='<div class=\"mats-label\">Materials</div>';
    (r.materials||[]).forEach(function(m,mi){
      const mItem=ITEM_MAP[m.item];
      const mInner = m.item ? '<img src=\"'+(mItem?mItem.image:'')+'\" onerror=\"this.style.visibility=&#39;hidden&#39;\"/><span>'+esc(mItem?mItem.label:m.item)+'</span>' : '<span class=\"muted\">Pick item</span>';
      const mrow=document.createElement('div'); mrow.className='mat-row';
      mrow.innerHTML='<div class=\"mat-pick\">'+mInner+'</div><input type=\"number\" min=\"1\" value=\"'+(m.amount||1)+'\" class=\"m-amt\"/><button class=\"btn btn-danger sm\">X</button>';
      mrow.querySelector('.mat-pick').onclick=function(){ openPicker(function(name){ m.item=name; renderRecipes(); }); };
      mrow.querySelector('.m-amt').oninput=function(e){ m.amount=parseInt(e.target.value)||1; };
      mrow.querySelector('button').onclick=function(){ r.materials.splice(mi,1); renderRecipes(); };
      mats.appendChild(mrow);
    });
    const addMat=document.createElement('button'); addMat.className='btn btn-ghost sm'; addMat.textContent='+ Material';
    addMat.onclick=function(){ r.materials=r.materials||[]; r.materials.push({ item:'', amount:1 }); renderRecipes(); };
    mats.appendChild(addMat);
    card.appendChild(mats);
    const del=document.createElement('button'); del.className='btn btn-danger sm recipe-del'; del.textContent='Delete Recipe';
    del.onclick=function(){ editing.recipes.splice(ri,1); renderRecipes(); };
    card.appendChild(del);
    pane.appendChild(card);
  });
  if(!editing.recipes.length){ const n=document.createElement('div'); n.className='empty-note'; n.textContent='No recipes yet. Click + Add Recipe.'; pane.appendChild(n); }
}

function renderSettings(){
  const pane=document.querySelector('[data-pane=\"settings\"]');
  pane.innerHTML='<div class=\"hint\">Everything you set here (name, prop, access and recipes) saves with this bench in the database. Use <b>Save Changes</b> for an existing bench, or <b>Place Bench</b> to position a brand new one.</div>';
}

// ================= ITEM PICKER =================
function itemCategoryOf(name){
  for(const cat in CATEGORIES){ if((CATEGORIES[cat]||[]).indexOf(name)!==-1) return cat; }
  return 'Other';
}
function openPicker(cb){
  pickerTarget=cb; PICKER_CAT='All';
  document.getElementById('pickerSearch').value='';
  renderPickerCats(); renderPickerGrid();
  document.getElementById('itemPicker').classList.remove('hidden');
}
function renderPickerCats(){
  const cats=['All'].concat(Object.keys(CATEGORIES)).concat(['Other']);
  const el=document.getElementById('pickerCats'); el.innerHTML='';
  cats.forEach(function(c){ const d=document.createElement('div'); d.className='pcat'+(c===PICKER_CAT?' active':''); d.textContent=c; d.onclick=function(){ PICKER_CAT=c; renderPickerCats(); renderPickerGrid(); }; el.appendChild(d); });
}
function renderPickerGrid(){
  const q=(document.getElementById('pickerSearch').value||'').toLowerCase();
  const el=document.getElementById('pickerGrid'); el.innerHTML='';
  let shown=0;
  for(let idx=0; idx<ITEMS.length; idx++){
    const it=ITEMS[idx];
    if(PICKER_CAT!=='All' && itemCategoryOf(it.name)!==PICKER_CAT) continue;
    if(q && it.label.toLowerCase().indexOf(q)===-1 && it.name.toLowerCase().indexOf(q)===-1) continue;
    const d=document.createElement('div'); d.className='item-cell';
    d.innerHTML='<img src=\"'+it.image+'\" onerror=\"this.style.visibility=&#39;hidden&#39;\"/><span>'+esc(it.label)+'</span>';
    (function(name){ d.onclick=function(){ if(pickerTarget) pickerTarget(name); document.getElementById('itemPicker').classList.add('hidden'); }; })(it.name);
    el.appendChild(d);
    shown++; if(shown>=400) break;
  }
  if(shown===0){ el.innerHTML='<div class=\"empty-note\">No items match.</div>'; }
}

// ================= CRAFT =================
function openCraft(d){
  ITEMS=d.items||[]; ITEM_MAP={}; ITEMS.forEach(function(i){ ITEM_MAP[i.name]=i; });
  applyTheme(d.theme||{});
  const b=d.bench||{};
  document.getElementById('craftTitle').textContent=b.label||'Crafting';
  const grid=document.getElementById('craftGrid'); grid.innerHTML='';
  (b.recipes||[]).forEach(function(r,i){
    const outItem=ITEM_MAP[r.output];
    const mats=(r.materials||[]).map(function(m){ const mi=ITEM_MAP[m.item]; return '<div class=\"cm\"><img src=\"'+(mi?mi.image:'')+'\" onerror=\"this.style.visibility=&#39;hidden&#39;\"/><span>'+(m.amount||1)+'x '+esc(mi?mi.label:m.item)+'</span></div>'; }).join('');
    const card=document.createElement('div'); card.className='craft-card';
    card.innerHTML='<div class=\"cc-top\"><img class=\"cc-img\" src=\"'+(outItem?outItem.image:'')+'\" onerror=\"this.style.visibility=&#39;hidden&#39;\"/><div class=\"cc-name\">'+(r.amount||1)+'x '+esc(outItem?outItem.label:r.output)+'</div></div><div class=\"cc-mats\">'+mats+'</div><button class=\"btn btn-accent full\">Craft</button>';
    (function(idx){ card.querySelector('button').onclick=function(){ post('craft', { index:idx+1 }); }; })(i);
    grid.appendChild(card);
  });
  if(!(b.recipes||[]).length){ grid.innerHTML='<div class=\"empty-note\">This bench has no recipes yet.</div>'; }
  document.getElementById('creator').classList.add('hidden');
  document.getElementById('itemPicker').classList.add('hidden');
  document.getElementById('craft').classList.remove('hidden');
}

// ================= wiring =================
window.addEventListener('DOMContentLoaded', function(){
  document.getElementById('newBenchBtn').onclick=newBench;
  document.getElementById('closeCreator').onclick=function(){ closeAll(); post('close'); };
  document.getElementById('saveBench').onclick=function(){ if(editing){ post('saveBench', editing); closeAll(); } };
  document.getElementById('placeBench').onclick=function(){ if(editing){ closeAll(); post('placeBench', editing); } };
  document.getElementById('deleteBench').onclick=function(){ if(editing && editing.id){ post('deleteBench', { id:editing.id }); closeAll(); } };
  document.querySelectorAll('.tab').forEach(function(t){ t.onclick=function(){ switchTab(t.dataset.tab); }; });
  document.getElementById('pickerClose').onclick=function(){ document.getElementById('itemPicker').classList.add('hidden'); };
  document.getElementById('pickerSearch').oninput=renderPickerGrid;
  document.getElementById('closeCraft').onclick=function(){ closeAll(); post('close'); };
});
