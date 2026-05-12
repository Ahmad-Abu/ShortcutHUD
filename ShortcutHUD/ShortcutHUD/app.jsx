// app.jsx — main onboarding controller

const { useState, useMemo } = React;

// Build a sample shortcut catalog inline (mirrors ShortcutLibrary.swift)
const SHORTCUT_DATA = {
  vscode: [
    { id: 'vsc-1', keys: '⌘ P',    description: 'Quick open file',         level: 'basic' },
    { id: 'vsc-2', keys: '⌘ ⇧ P',  description: 'Command palette',         level: 'basic' },
    { id: 'vsc-3', keys: '⌘ /',    description: 'Toggle line comment',     level: 'basic' },
    { id: 'vsc-4', keys: '⌘ B',    description: 'Toggle sidebar',          level: 'basic' },
    { id: 'vsc-5', keys: '⌥ ↑',    description: 'Move line up',            level: 'intermediate' },
    { id: 'vsc-6', keys: '⌥ ↓',    description: 'Move line down',          level: 'intermediate' },
    { id: 'vsc-7', keys: '⌘ D',    description: 'Select next occurrence',  level: 'intermediate' },
    { id: 'vsc-8', keys: '⌃ `',    description: 'Toggle terminal',         level: 'intermediate' },
    { id: 'vsc-9', keys: '⌘ ⇧ F',  description: 'Search across files',     level: 'advanced' },
  ],
  finder: [
    { id: 'fn-1', keys: '⌘ N',     description: 'New Finder window',       level: 'basic' },
    { id: 'fn-2', keys: '⌘ ⇧ N',   description: 'New folder',              level: 'basic' },
    { id: 'fn-3', keys: '⌘ ⌫',     description: 'Move to Trash',           level: 'basic' },
    { id: 'fn-4', keys: 'Space',   description: 'Quick Look preview',      level: 'basic' },
    { id: 'fn-5', keys: '⌘ ↑',     description: 'Open enclosing folder',   level: 'intermediate' },
    { id: 'fn-6', keys: '⌘ 2',     description: 'List view',               level: 'intermediate' },
    { id: 'fn-7', keys: '⌘ 3',     description: 'Column view',             level: 'intermediate' },
    { id: 'fn-8', keys: '⌘ ⇧ .',   description: 'Show hidden files',       level: 'advanced' },
  ],
  safari: [
    { id: 'sf-1', keys: '⌘ T',     description: 'New tab',                 level: 'basic' },
    { id: 'sf-2', keys: '⌘ W',     description: 'Close tab',               level: 'basic' },
    { id: 'sf-3', keys: '⌘ L',     description: 'Focus address bar',       level: 'basic' },
    { id: 'sf-4', keys: '⌘ R',     description: 'Reload page',             level: 'basic' },
    { id: 'sf-5', keys: '⌘ ⇧ ]',   description: 'Next tab',                level: 'intermediate' },
    { id: 'sf-6', keys: '⌘ ⇧ [',   description: 'Previous tab',            level: 'intermediate' },
    { id: 'sf-7', keys: '⌘ ⇧ T',   description: 'Reopen closed tab',       level: 'intermediate' },
    { id: 'sf-8', keys: '⌘ ⇧ R',   description: 'Reader Mode',             level: 'advanced' },
  ],
  figma: [
    { id: 'fg-1', keys: 'V',       description: 'Move tool',               level: 'basic' },
    { id: 'fg-2', keys: 'F',       description: 'Frame tool',              level: 'basic' },
    { id: 'fg-3', keys: 'R',       description: 'Rectangle tool',          level: 'basic' },
    { id: 'fg-4', keys: 'T',       description: 'Text tool',               level: 'basic' },
    { id: 'fg-5', keys: '⌘ G',     description: 'Group selection',         level: 'basic' },
    { id: 'fg-6', keys: '⌘ ⌥ G',   description: 'Frame selection',         level: 'intermediate' },
    { id: 'fg-7', keys: '⌘ ⌥ K',   description: 'Create component',        level: 'advanced' },
    { id: 'fg-8', keys: '⌘ E',     description: 'Export selection',        level: 'advanced' },
  ],
};

const LEVEL_ORDER = { basic: 0, intermediate: 1, advanced: 2 };

function sortBySkill(shortcuts, skill) {
  if (skill === 'advanced') {
    return [...shortcuts].sort((a, b) => LEVEL_ORDER[b.level] - LEVEL_ORDER[a.level]);
  }
  if (skill === 'mixed') {
    // Interleave levels
    const groups = { basic: [], intermediate: [], advanced: [] };
    shortcuts.forEach((s) => groups[s.level].push(s));
    const out = [];
    while (groups.basic.length || groups.intermediate.length || groups.advanced.length) {
      if (groups.intermediate.length) out.push(groups.intermediate.shift());
      if (groups.basic.length) out.push(groups.basic.shift());
      if (groups.advanced.length) out.push(groups.advanced.shift());
    }
    return out;
  }
  return [...shortcuts].sort((a, b) => LEVEL_ORDER[a.level] - LEVEL_ORDER[b.level]);
}

const STEPS = ['welcome', 'permission', 'apps', 'skill', 'demo', 'done'];

function App() {
  const tweaks = useTweaks(window.TWEAK_DEFAULTS);
  const [t, setTweak] = tweaks;

  const [stepIdx, setStepIdx] = useState(0);
  const [granted, setGranted] = useState(false);
  const [selectedIds, setSelectedIds] = useState(['vscode', 'finder', 'safari', 'figma', 'chrome']);
  const [skill, setSkill] = useState('beginner');
  const [threshold, setThreshold] = useState(10);
  const [demoApp, setDemoApp] = useState('vscode');
  const [demoCounts, setDemoCounts] = useState({});
  const [justGraduated, setJustGraduated] = useState(null);
  const [finished, setFinished] = useState(false);
  const [closing, setClosing] = useState(false);

  const totalSteps = STEPS.length;
  const step = STEPS[stepIdx];

  const demoShortcuts = useMemo(() => {
    const list = SHORTCUT_DATA[demoApp] || [];
    return sortBySkill(list, skill);
  }, [demoApp, skill]);

  function next() { setStepIdx((i) => Math.min(i + 1, totalSteps - 1)); }
  function back() { setStepIdx((i) => Math.max(i - 1, 0)); }

  function toggleApp(id) {
    setSelectedIds((prev) => prev.includes(id) ? prev.filter((x) => x !== id) : [...prev, id]);
  }
  function selectAll() { setSelectedIds(SUPPORTED_APPS.map((a) => a.id)); }
  function clearAll() { setSelectedIds([]); }

  function finish() {
    setClosing(true);
    setTimeout(() => {
      setFinished(true);
      setClosing(false);
    }, 520);
  }
  function restart() {
    setStepIdx(0); setFinished(false); setClosing(false);
    setGranted(false);
    setDemoCounts({}); setJustGraduated(null);
  }

  const wallpaper = t.wallpaper || 'mojave';

  return (
    <div className="shu-dark" style={{
      minHeight: '100vh', width: '100%',
      background: WALLPAPERS[wallpaper] || WALLPAPERS.mojave,
      backgroundSize: 'cover',
      backgroundPosition: 'center',
      display: 'flex', alignItems: 'center', justifyContent: 'center',
      padding: 40,
      position: 'relative',
      overflow: 'hidden',
      fontFamily: SHU_FONT,
      colorScheme: 'dark',
    }}>
      <style>{`
        .shu-dark input[type=range] { accent-color: #0a84ff; }
        .shu-dark ::-webkit-scrollbar { width: 8px; height: 8px; }
        .shu-dark ::-webkit-scrollbar-thumb { background: rgba(255,255,255,0.18); border-radius: 4px; }
        .shu-dark ::-webkit-scrollbar-track { background: transparent; }
      `}</style>
      {/* Faux desktop top bar */}
      <DesktopMenuBar finished={finished} />

      {finished ? (
        <FinishedDesktop
          demoApp={demoApp} setDemoApp={setDemoApp}
          demoCounts={demoCounts} setDemoCounts={setDemoCounts}
          threshold={threshold} demoShortcuts={demoShortcuts}
          justGraduated={justGraduated} setJustGraduated={setJustGraduated}
          onRestart={restart}
        />
      ) : (
        <OnboardingWindow closing={closing}>
          {step === 'welcome' && (
            <WelcomeScreen onNext={next} totalSteps={totalSteps} currentStep={stepIdx} />
          )}
          {step === 'permission' && (
            <PermissionScreen
              onNext={next} onBack={back}
              totalSteps={totalSteps} currentStep={stepIdx}
              granted={granted} onGrant={setGranted}
            />
          )}
          {step === 'apps' && (
            <AppsScreen
              onNext={next} onBack={back}
              totalSteps={totalSteps} currentStep={stepIdx}
              selectedIds={selectedIds} toggleApp={toggleApp}
              selectAll={selectAll} clearAll={clearAll}
            />
          )}
          {step === 'skill' && (
            <SkillScreen
              onNext={next} onBack={back}
              totalSteps={totalSteps} currentStep={stepIdx}
              skill={skill} setSkill={setSkill}
              threshold={threshold} setThreshold={setThreshold}
            />
          )}
          {step === 'demo' && (
            <DemoScreen
              onNext={next} onBack={back}
              totalSteps={totalSteps} currentStep={stepIdx}
              demoApp={demoApp} setDemoApp={setDemoApp}
              demoCounts={demoCounts} setDemoCounts={setDemoCounts}
              threshold={threshold} demoShortcuts={demoShortcuts}
              justGraduated={justGraduated} setJustGraduated={setJustGraduated}
            />
          )}
          {step === 'done' && (
            <DoneScreen
              onFinish={finish} onBack={back}
              totalSteps={totalSteps} currentStep={stepIdx}
              selectedCount={selectedIds.length} threshold={threshold} skill={skill}
            />
          )}
        </OnboardingWindow>
      )}

      {/* Tweaks */}
      <TweaksPanel title="Tweaks">
        <TweakSection label="Stage" />
        <TweakSelect
          label="Wallpaper"
          value={wallpaper}
          options={['mojave', 'sequoia', 'sonoma', 'mono']}
          onChange={(v) => setTweak('wallpaper', v)}
        />
        <TweakButton label="Restart onboarding" onClick={restart} />
        <TweakButton
          label={'Next step (' + STEPS[stepIdx] + ')'}
          onClick={() => setStepIdx((i) => (i + 1) % totalSteps)}
        />
      </TweaksPanel>
    </div>
  );
}

const WALLPAPERS = {
  mojave:  'linear-gradient(180deg, #4a3d5d 0%, #6b5f8a 40%, #8d7caf 100%)',
  sequoia: 'linear-gradient(160deg, #0c4e5e 0%, #1e7d8a 50%, #6cb6c4 100%)',
  sonoma:  'linear-gradient(160deg, #2d2155 0%, #813583 45%, #e26a52 100%)',
  mono:    'linear-gradient(180deg, #2a2a2e 0%, #3e3e44 100%)',
};

function DesktopMenuBar({ finished }) {
  return (
    <div style={{
      position: 'absolute', top: 0, left: 0, right: 0, height: 26,
      background: 'rgba(0,0,0,0.32)',
      backdropFilter: 'blur(20px) saturate(150%)',
      WebkitBackdropFilter: 'blur(20px) saturate(150%)',
      borderBottom: '0.5px solid rgba(255,255,255,0.06)',
      display: 'flex', alignItems: 'center',
      padding: '0 14px', gap: 14,
      fontFamily: SHU_FONT, fontSize: 12,
      color: 'rgba(255,255,255,0.92)',
      zIndex: 1,
    }}>
      <span style={{ fontWeight: 700, fontSize: 14 }}> </span>
      <span style={{ fontWeight: 600 }}>ShortcutHUD</span>
      <span style={{ opacity: 0.7 }}>File</span>
      <span style={{ opacity: 0.7 }}>Edit</span>
      <span style={{ opacity: 0.7 }}>View</span>
      <span style={{ opacity: 0.7 }}>Window</span>
      <span style={{ opacity: 0.7 }}>Help</span>
      <span style={{ flex: 1 }} />
      {finished && (
        <span style={{ display: 'inline-flex', alignItems: 'center', gap: 4, opacity: 0.95 }}>
          <KeyboardGlyph size={11} color="rgba(255,255,255,0.95)" />
        </span>
      )}
      <span style={{ opacity: 0.85 }}>Wed 9:41 AM</span>
    </div>
  );
}

function OnboardingWindow({ children, closing = false }) {
  return (
    <div style={{
      width: 880, height: 580,
      borderRadius: 14, overflow: 'hidden',
      background: '#1c1c1e',
      boxShadow: '0 0 0 0.5px rgba(255,255,255,0.08), 0 30px 80px rgba(0,0,0,0.55), 0 6px 18px rgba(0,0,0,0.35)',
      display: 'flex', flexDirection: 'column',
      position: 'relative',
      zIndex: 2,
      transformOrigin: 'calc(100% - 60px) calc(100% + 200px)',
      transform: closing ? 'scale(0.18) translateY(60px)' : 'scale(1)',
      opacity: closing ? 0 : 1,
      filter: closing ? 'blur(6px)' : 'blur(0)',
      transition: 'transform 520ms cubic-bezier(.4,0,.2,1), opacity 480ms ease-in, filter 380ms ease-in',
      pointerEvents: closing ? 'none' : 'auto',
      color: 'rgba(255,255,255,0.92)',
    }}>
      <div style={{
        height: 38, flexShrink: 0,
        background: 'linear-gradient(180deg, #2c2c2e, #232325)',
        borderBottom: '0.5px solid rgba(255,255,255,0.06)',
        display: 'flex', alignItems: 'center', padding: '0 14px',
        gap: 8,
      }}>
        <div style={{ width: 12, height: 12, borderRadius: '50%', background: '#ff5f57', boxShadow: 'inset 0 0 0 0.5px rgba(0,0,0,0.2)' }} />
        <div style={{ width: 12, height: 12, borderRadius: '50%', background: '#febc2e', boxShadow: 'inset 0 0 0 0.5px rgba(0,0,0,0.2)' }} />
        <div style={{ width: 12, height: 12, borderRadius: '50%', background: '#28c840', boxShadow: 'inset 0 0 0 0.5px rgba(0,0,0,0.2)' }} />
        <span style={{
          flex: 1, textAlign: 'center', fontSize: 12, fontWeight: 600,
          color: 'rgba(255,255,255,0.55)', marginRight: 50,
        }}>ShortcutHUD — Setup</span>
      </div>
      <div style={{ flex: 1, position: 'relative', overflow: 'hidden' }}>
        {children}
      </div>
    </div>
  );
}

// After finishing, show the user a "free roam" desktop where the HUD is real
function FinishedDesktop({
  demoApp, setDemoApp, demoCounts, setDemoCounts,
  threshold, demoShortcuts, justGraduated, setJustGraduated, onRestart,
}) {
  const visible = demoShortcuts.filter((s) => (demoCounts[s.id] ?? 0) < threshold).slice(0, 7);

  function press(s) {
    setDemoCounts((prev) => {
      const next = { ...prev, [s.id]: (prev[s.id] ?? 0) + 1 };
      if ((next[s.id] ?? 0) >= threshold) {
        setJustGraduated(s);
        setTimeout(() => setJustGraduated(null), 2200);
      }
      return next;
    });
  }

  return (
    <div style={{ position: 'relative', width: '100%', height: '100%', minHeight: 580 }}>
      {/* Subtle "running" pill near the menu bar — Dock-style notification */}
      <div style={{
        position: 'absolute', top: 38, left: '50%', transform: 'translateX(-50%)',
        background: 'rgba(28,28,30,0.85)',
        backdropFilter: 'blur(24px) saturate(180%)',
        WebkitBackdropFilter: 'blur(24px) saturate(180%)',
        border: '0.5px solid rgba(255,255,255,0.08)',
        borderRadius: 22,
        padding: '8px 14px 8px 10px',
        display: 'flex', alignItems: 'center', gap: 10,
        boxShadow: '0 12px 32px rgba(0,0,0,0.3)',
        animation: 'shu-running-in 600ms cubic-bezier(.2,.8,.2,1) both',
        fontFamily: SHU_FONT,
      }}>
        <div style={{
          width: 22, height: 22, borderRadius: 6,
          background: 'linear-gradient(135deg, #1c1c1e, #3a3a3c)',
          display: 'flex', alignItems: 'center', justifyContent: 'center',
        }}>
          <KeyboardGlyph size={11} color="rgba(255,255,255,0.95)" />
        </div>
        <div>
          <div style={{ fontSize: 12, fontWeight: 600, color: '#fff' }}>ShortcutHUD is running</div>
          <div style={{ fontSize: 10.5, color: 'rgba(255,255,255,0.55)', marginTop: 1 }}>
            Switch apps · the HUD follows
          </div>
        </div>
        <button onClick={onRestart}
          style={{
            marginLeft: 6, background: 'rgba(255,255,255,0.12)',
            border: 'none', color: 'rgba(255,255,255,0.85)',
            fontSize: 10.5, fontWeight: 500, padding: '4px 8px',
            borderRadius: 6, cursor: 'pointer',
            fontFamily: SHU_FONT,
          }}>↺ Restart</button>
      </div>

      {/* Floating app switcher — bottom center, like a tiny dock */}
      <div style={{
        position: 'absolute', bottom: 28, left: '50%', transform: 'translateX(-50%)',
        background: 'rgba(28,28,30,0.7)',
        backdropFilter: 'blur(40px) saturate(180%)',
        WebkitBackdropFilter: 'blur(40px) saturate(180%)',
        border: '0.5px solid rgba(255,255,255,0.1)',
        borderRadius: 18, padding: 8,
        display: 'flex', alignItems: 'center', gap: 6,
        boxShadow: '0 12px 32px rgba(0,0,0,0.4)',
        animation: 'shu-running-in 700ms 120ms cubic-bezier(.2,.8,.2,1) both',
      }}>
        {['vscode', 'finder', 'safari', 'figma'].map((id) => {
          const app = SUPPORTED_APPS.find((a) => a.id === id);
          const sel = demoApp === id;
          return (
            <button key={id} onClick={() => setDemoApp(id)}
              title={app.name}
              style={{
                position: 'relative',
                background: 'transparent', border: 'none', padding: 4,
                cursor: 'pointer', borderRadius: 10,
                transition: 'transform 180ms ease',
                transform: sel ? 'translateY(-4px) scale(1.05)' : 'translateY(0) scale(1)',
              }}>
              <AppTile app={app} size={42} />
              {sel && (
                <div style={{
                  position: 'absolute', bottom: -2, left: '50%', transform: 'translateX(-50%)',
                  width: 4, height: 4, borderRadius: '50%',
                  background: 'rgba(255,255,255,0.85)',
                }} />
              )}
            </button>
          );
        })}
        <div style={{ width: 0.5, alignSelf: 'stretch', background: 'rgba(255,255,255,0.14)', margin: '4px 4px' }} />
        {visible.slice(0, 3).map((s) => (
          <button key={s.id} onClick={() => press(s)}
            title={s.description}
            style={{
              display: 'inline-flex', alignItems: 'center', gap: 5,
              padding: '6px 8px', borderRadius: 8,
              background: 'rgba(255,255,255,0.06)',
              border: '0.5px solid rgba(0,0,0,0.08)',
              cursor: 'pointer', fontFamily: SHU_FONT, fontSize: 11,
            }}>
            <KeyChip keys={s.keys} color={LEVEL_COLOR[s.level]} />
          </button>
        ))}
      </div>

      {/* Real HUD in bottom-right */}
      <div style={{
        position: 'absolute', bottom: 24, right: 24,
        animation: 'shu-hud-in 700ms 200ms cubic-bezier(.2,.8,.2,1) both',
      }}>
        <HUDPanel
          appName={SUPPORTED_APPS.find((a) => a.id === demoApp)?.name || 'No App'}
          shortcuts={visible}
          counts={demoCounts}
          threshold={threshold}
          justGraduatedId={justGraduated?.id}
        />
        {justGraduated && (
          <div style={{
            position: 'absolute', bottom: '100%', right: 0, marginBottom: 10,
            padding: '12px 14px', borderRadius: 10,
            background: 'rgba(52,199,89,0.95)',
            color: '#fff', fontFamily: SHU_FONT,
            boxShadow: '0 8px 24px rgba(52,199,89,0.4)',
            animation: 'shu-toast-in 250ms ease-out',
            minWidth: 240,
          }}>
            <div style={{ fontSize: 11, fontWeight: 700, textTransform: 'uppercase', letterSpacing: 0.8, opacity: 0.9 }}>
              Graduated 🎓
            </div>
            <div style={{ fontSize: 13, fontWeight: 500, marginTop: 3 }}>
              <span style={{ fontFamily: SHU_MONO }}>{justGraduated.keys}</span> · {justGraduated.description}
            </div>
          </div>
        )}
      </div>
      <style>{`
        @keyframes shu-running-in {
          from { opacity: 0; transform: translate(-50%, -12px); }
          to { opacity: 1; transform: translate(-50%, 0); }
        }
        @keyframes shu-hud-in {
          from { opacity: 0; transform: translate(20px, 20px) scale(0.9); }
          to { opacity: 1; transform: translate(0, 0) scale(1); }
        }
      `}</style>
    </div>
  );
}

ReactDOM.createRoot(document.getElementById('root')).render(<App />);
