const RES = 'rme-crafting';
function post(name, data) {
  return fetch('https://' + RES + '/' + name, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json; charset=UTF-8' },
    body: JSON.stringify(data || {})
  }).catch(function(){});
}

let ITEMS = [], ITEM_MAP = {}, CATEGORIES = {}, RECIPE_CATS = [], JOBS = [], GANGS = [], PROPS = [], THEME = {};
let editing = null;
let pickerTarget = null;
let PICKER_CAT = 'All';
// craft state
let CRAFT_BENCH = null, INV = {}, XPINFO = { level:0, into:0, perLevel:100, enabled:false }, CRAFT_CAT = 'All', QTY = 1;

function esc(s){ s = String(s == null ? '' : s); return s.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/\"/g,'&quot;').replace(/'/g,'&#39;'); }

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

window.addEventListener('message', function(e){
  const d = e.data; if(!d || !d.action) return;
  if(d.action==='openCreator') openCreator(d);
  else if(d.action==='openCraft') openCraft(d);
  else if(d.action==='close') closeAll();
});
document.addEventListener('keyup', function(e){ if(e.key==='Escape'){ closeAll(); post('close'); } });

// ================= CREATOR =================
function openCreator(d){
  ITEMS=d.items||[]; CATEGORIES=d.categories||{}; RECIPE_CATS=d.recipeCategories||[]; JOBS=d.jobs||[]; GANGS=d.gangs||[]; PROPS=d.props||[]; THEME=d.theme||{};
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
function dupBench(){
  if(!editing) return;
  editing.id=null; editing.label=(editing.label||'Bench')+' Copy';
  renderEditor(true);
}

function renderEditor(isNew){
  document.getElementById('editorEmpty').classList.add('hidden');
  document.getElementById('editor').classList.remove('hidden');
  document.getElementById('placeBench').classList.toggle('hidden', !isNew);
  document.getElementById('saveBench').classList.toggle('hidden', isNew);
  document.getElementById('deleteBench').classList.toggle('hidden', isNew);
  document.getElementById('moveBench').classList.toggle('hidden', isNew);
  document.getElementById('dupBench').classList.toggle('hidden', isNew);
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
    '<div class=\"hint\">Place Bench = new bench. Move = reposition this bench. Duplicate = copy this bench (recipes included) to place a new one.</div>';
  pane.querySelector('#f-label').oninput=function(e){ editing.label=e.target.value; };
  pane.querySelector('#f-prop').onchange=function(e){ editing.prop=e.target.value; };
}

function accessSelect(cls, val){
  return '<select class=\"'+cls+'\">'+['inherit','public','job','gang'].map(function(a){ return '<option value=\"'+a+'\"'+(val===a?' selected':'')+'>'+(a==='inherit'?'Inherit bench':a.charAt(0).toUpperCase()+a.slice(1))+'</option>'; }).join('')+'</select>';
}
function jobSelect(cls, val){ return '<select class=\"'+cls+'\">'+JOBS.map(function(j){ return '<option value=\"'+esc(j.name)+'\"'+(val===j.name?' selected':'')+'>'+esc(j.label)+'</option>'; }).join('')+'</select>'; }
function gangSelect(cls, val){ return '<select class=\"'+cls+'\">'+GANGS.map(function(g){ return '<option value=\"'+esc(g.name)+'\"'+(val===g.name?' selected':'')+'>'+esc(g.label)+'</option>'; }).join('')+'</select>'; }

function renderAccess(){
  const pane=document.querySelector('[data-pane=\"access\"]');
  const modes=['public','job','gang'].map(function(a){ return '<label class=\"radio '+(editing.access===a?'sel':'')+'\"><input type=\"radio\" name=\"acc\" value=\"'+a+'\"'+(editing.access===a?' checked':'')+'/> '+(a.charAt(0).toUpperCase()+a.slice(1))+'</label>'; }).join('');
  pane.innerHTML='<div class=\"access-modes\">'+modes+'</div>'+
    '<label class=\"field '+(editing.access==='job'?'':'hidden')+'\">Job'+jobSelect('f-job', editing.accessValue)+'</label>'+
    '<label class=\"field '+(editing.access==='job'?'':'hidden')+'\">Minimum Grade<input id=\"f-grade\" type=\"number\" min=\"0\" value=\"'+(editing.accessGrade||0)+'\"/></label>'+
    '<label class=\"field '+(editing.access==='gang'?'':'hidden')+'\">Gang'+gangSelect('f-gang', editing.accessValue)+'</label>'+
    '<div class=\"hint\">This is the default access for the whole bench. Individual recipes can override it in the Recipes tab.</div>';
  pane.querySelectorAll('input[name=\"acc\"]').forEach(function(r){ r.onchange=function(e){
    editing.access=e.target.value;
    if(editing.access==='job' && !editing.accessValue) editing.accessValue=(JOBS[0]&&JOBS[0].name)||null;
    if(editing.access==='gang' && !editing.accessValue) editing.accessValue=(GANGS[0]&&GANGS[0].name)||null;
    if(editing.access==='public') editing.accessValue=null;
    renderAccess();
  }; });
  const jb=pane.querySelector('.f-job'); if(jb) jb.onchange=function(e){ editing.accessValue=e.target.value; };
  const gr=pane.querySelector('#f-grade'); if(gr) gr.oninput=function(e){ editing.accessGrade=parseInt(e.target.value)||0; };
  const gg=pane.querySelector('.f-gang'); if(gg) gg.onchange=function(e){ editing.accessValue=e.target.value; };
}

function renderRecipes(){
  const pane=document.querySelector('[data-pane=\"recipes\"]'); pane.innerHTML='';
  const add=document.createElement('button'); add.className='btn btn-accent'; add.textContent='+ Add Recipe';
  add.onclick=function(){ editing.recipes.push({ output:'', amount:1, time:5000, materials:[], category:'General', requiredLevel:0, failChance:0, xp:5, access:'inherit', accessValue:null, accessGrade:0 }); renderRecipes(); };
  pane.appendChild(add);
  editing.recipes.forEach(function(r,ri){
    const card=document.createElement('div'); card.className='recipe-card';
    const outItem=ITEM_MAP[r.output];
    const outInner = r.output ? '<img src=\"'+(outItem?outItem.image:'')+'\" onerror=\"this.style.visibility=&#39;hidden&#39;\"/><span>'+esc(outItem?outItem.label:r.output)+'</span>' : '<span class=\"muted\">Pick output item</span>';
    const out=document.createElement('div'); out.innerHTML='<div class=\"mats-label\">Output</div><div class=\"ro-pick\">'+outInner+'</div>';
    out.querySelector('.ro-pick').onclick=function(){ openPicker(function(name){ r.output=name; renderRecipes(); }); };
    card.appendChild(out);

    const catOpts=(RECIPE_CATS.indexOf(r.category)===-1 && r.category ? [r.category] : []).concat(RECIPE_CATS).map(function(c){ return '<option value=\"'+esc(c)+'\"'+(r.category===c?' selected':'')+'>'+esc(c)+'</option>'; }).join('');
    const sf=document.createElement('div'); sf.className='small-fields';
    sf.innerHTML='<label>Amount<input type=\"number\" min=\"1\" value=\"'+(r.amount||1)+'\" class=\"r-amt\"/></label>'+
      '<label>Time (ms)<input type=\"number\" min=\"0\" value=\"'+(r.time||5000)+'\" class=\"r-time\"/></label>'+
      '<label>Category<select class=\"r-cat\">'+catOpts+'</select></label>'+
      '<label>Req. Level<input type=\"number\" min=\"0\" value=\"'+(r.requiredLevel||0)+'\" class=\"r-lvl\"/></label>'+
      '<label>Fail %<input type=\"number\" min=\"0\" max=\"100\" value=\"'+(r.failChance||0)+'\" class=\"r-fail\"/></label>'+
      '<label>XP<input type=\"number\" min=\"0\" value=\"'+(r.xp!=null?r.xp:5)+'\" class=\"r-xp\"/></label>';
    card.appendChild(sf);
    sf.querySelector('.r-amt').oninput=function(e){ r.amount=parseInt(e.target.value)||1; };
    sf.querySelector('.r-time').oninput=function(e){ r.time=parseInt(e.target.value)||5000; };
    sf.querySelector('.r-cat').onchange=function(e){ r.category=e.target.value; };
    sf.querySelector('.r-lvl').oninput=function(e){ r.requiredLevel=parseInt(e.target.value)||0; };
    sf.querySelector('.r-fail').oninput=function(e){ r.failChance=parseInt(e.target.value)||0; };
    sf.querySelector('.r-xp').oninput=function(e){ r.xp=parseInt(e.target.value)||0; };

    const af=document.createElement('div'); af.className='small-fields';
    let accHtml='<label>Recipe Access'+accessSelect('r-acc', r.access||'inherit')+'</label>';
    if(r.access==='job'){ accHtml+='<label>Job'+jobSelect('r-accjob', r.accessValue)+'</label><label>Min Grade<input type=\"number\" min=\"0\" value=\"'+(r.accessGrade||0)+'\" class=\"r-accgrade\"/></label>'; }
    else if(r.access==='gang'){ accHtml+='<label>Gang'+gangSelect('r-accgang', r.accessValue)+'</label>'; }
    af.innerHTML=accHtml; card.appendChild(af);
    af.querySelector('.r-acc').onchange=function(e){ r.access=e.target.value; if(r.access==='job'&&!r.accessValue) r.accessValue=(JOBS[0]&&JOBS[0].name)||null; if(r.access==='gang'&&!r.accessValue) r.accessValue=(GANGS[0]&&GANGS[0].name)||null; renderRecipes(); };
    const aj=af.querySelector('.r-accjob'); if(aj) aj.onchange=function(e){ r.accessValue=e.target.value; };
    const ag=af.querySelector('.r-accgrade'); if(ag) ag.oninput=function(e){ r.accessGrade=parseInt(e.target.value)||0; };
    const agg=af.querySelector('.r-accgang'); if(agg) agg.onchange=function(e){ r.accessValue=e.target.value; };

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

    const actions=document.createElement('div'); actions.className='recipe-actions';
    const dup=document.createElement('button'); dup.className='btn btn-ghost sm'; dup.textContent='Duplicate';
    dup.onclick=function(){ editing.recipes.splice(ri+1,0, JSON.parse(JSON.stringify(r))); renderRecipes(); };
    const del=document.createElement('button'); del.className='btn btn-danger sm'; del.textContent='Delete Recipe';
    del.onclick=function(){ editing.recipes.splice(ri,1); renderRecipes(); };
    actions.appendChild(dup); actions.appendChild(del);
    card.appendChild(actions);
    pane.appendChild(card);
  });
  if(!editing.recipes.length){ const n=document.createElement('div'); n.className='empty-note'; n.textContent='No recipes yet. Click + Add Recipe.'; pane.appendChild(n); }
}

function renderSettings(){
  const pane=document.querySelector('[data-pane=\"settings\"]');
  pane.innerHTML='<div class=\"hint\">Everything (name, prop, access, recipes) saves with this bench in the database. Recipes support a category, required crafting level, fail chance, XP reward and their own access override. Players earn crafting XP on successful crafts.</div>';
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
  CRAFT_BENCH=d.bench||{}; INV=d.inventory||{}; XPINFO=d.xp||{ level:0, into:0, perLevel:100, enabled:false };
  CRAFT_CAT='All'; QTY=1;
  document.getElementById('qtyVal').textContent='1';
  document.getElementById('craftSearch').value='';
  document.getElementById('craftTitle').textContent=CRAFT_BENCH.label||'Crafting';
  const lb=document.getElementById('craftLevel');
  lb.textContent = XPINFO.enabled ? ('Crafting Lv '+(XPINFO.level||0)+'  ('+(XPINFO.into||0)+'/'+(XPINFO.perLevel||100)+')') : '';
  renderCraftCats(); renderCraftGrid();
  document.getElementById('creator').classList.add('hidden');
  document.getElementById('itemPicker').classList.add('hidden');
  document.getElementById('craft').classList.remove('hidden');
}

function renderCraftCats(){
  const set={}; (CRAFT_BENCH.recipes||[]).forEach(function(r){ set[r.category||'General']=true; });
  const cats=['All'].concat(Object.keys(set));
  const el=document.getElementById('craftCats'); el.innerHTML='';
  if(cats.length<=2){ el.style.display='none'; } else { el.style.display='flex'; }
  cats.forEach(function(c){ const d=document.createElement('div'); d.className='ccat'+(c===CRAFT_CAT?' active':''); d.textContent=c; d.onclick=function(){ CRAFT_CAT=c; renderCraftCats(); renderCraftGrid(); }; el.appendChild(d); });
}

function renderCraftGrid(){
  const q=(document.getElementById('craftSearch').value||'').toLowerCase();
  const grid=document.getElementById('craftGrid'); grid.innerHTML='';
  const recipes=CRAFT_BENCH.recipes||[];
  let shown=0;
  recipes.forEach(function(r,i){
    if(CRAFT_CAT!=='All' && (r.category||'General')!==CRAFT_CAT) return;
    const outItem=ITEM_MAP[r.output];
    const outLabel=outItem?outItem.label:r.output;
    if(q && String(outLabel).toLowerCase().indexOf(q)===-1) return;
    const locked = XPINFO.enabled && (r.requiredLevel||0) > (XPINFO.level||0);
    let canAfford=true;
    const mats=(r.materials||[]).map(function(m){
      const mi=ITEM_MAP[m.item];
      const need=(m.amount||1)*QTY;
      const have=INV[m.item]||0;
      const okm=have>=need; if(!okm) canAfford=false;
      return '<div class=\"cm '+(okm?'have':'need')+'\"><img src=\"'+(mi?mi.image:'')+'\" onerror=\"this.style.visibility=&#39;hidden&#39;\"/><span>'+have+'/'+need+' '+esc(mi?mi.label:m.item)+'</span></div>';
    }).join('');
    const card=document.createElement('div'); card.className='craft-card'+(locked?' locked':'')+((!locked&&!canAfford)?' cant':'');
    let sub=(r.failChance&&r.failChance>0)?('<div class=\"cc-sub\">'+r.failChance+'% fail chance</div>'):'';
    let lockTag = locked ? '<div class=\"cc-lock\">Requires level '+(r.requiredLevel||0)+'</div>' : '';
    card.innerHTML='<div class=\"cc-top\"><img class=\"cc-img\" src=\"'+(outItem?outItem.image:'')+'\" onerror=\"this.style.visibility=&#39;hidden&#39;\"/><div><div class=\"cc-name\">'+((r.amount||1)*QTY)+'x '+esc(outLabel)+'</div>'+sub+lockTag+'</div></div><div class=\"cc-mats\">'+mats+'</div><button class=\"btn btn-accent full cc-btn\">Craft</button>';
    (function(idx){ card.querySelector('.cc-btn').onclick=function(){ if(locked){ return; } if(!canAfford){ return; } post('craft', { index:idx+1, qty:QTY }); }; })(i);
    grid.appendChild(card); shown++;
  });
  if(shown===0){ grid.innerHTML='<div class=\"empty-note\">No recipes'+(q?' match your search':' here yet')+'.</div>'; }
}

// ================= wiring =================
function wireUI(){
  document.getElementById('newBenchBtn').onclick=newBench;
  document.getElementById('closeCreator').onclick=function(){ closeAll(); post('close'); };
  document.getElementById('saveBench').onclick=function(){ if(editing){ post('saveBench', editing); closeAll(); } };
  document.getElementById('placeBench').onclick=function(){ if(editing){ closeAll(); post('placeBench', editing); } };
  document.getElementById('moveBench').onclick=function(){ if(editing && editing.id){ closeAll(); post('moveBench', editing); } };
  document.getElementById('dupBench').onclick=dupBench;
  document.getElementById('deleteBench').onclick=function(){ if(editing && editing.id){ post('deleteBench', { id:editing.id }); closeAll(); } };
  document.querySelectorAll('.tab').forEach(function(t){ t.onclick=function(){ switchTab(t.dataset.tab); }; });
  document.getElementById('pickerClose').onclick=function(){ document.getElementById('itemPicker').classList.add('hidden'); };
  document.getElementById('pickerSearch').oninput=renderPickerGrid;
  document.getElementById('closeCraft').onclick=function(){ closeAll(); post('close'); };
  document.getElementById('craftSearch').oninput=renderCraftGrid;
  document.getElementById('qtyMinus').onclick=function(){ QTY=Math.max(1, QTY-1); document.getElementById('qtyVal').textContent=QTY; renderCraftGrid(); };
  document.getElementById('qtyPlus').onclick=function(){ QTY=Math.min(20, QTY+1); document.getElementById('qtyVal').textContent=QTY; renderCraftGrid(); };
}
if (document.readyState === 'loading') { document.addEventListener('DOMContentLoaded', wireUI); } else { wireUI(); }
