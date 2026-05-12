// shared.jsx — fonts, colors, primitives shared across onboarding screens

const SHU_FONT = '-apple-system, BlinkMacSystemFont, "SF Pro", "Helvetica Neue", sans-serif';
const SHU_MONO = 'ui-monospace, "SF Mono", Menlo, monospace';

// 15 supported apps from ShortcutLibrary.swift
const SUPPORTED_APPS = [
  { id: 'vscode',   name: 'VS Code',  bundle: 'com.microsoft.VSCode',          tint: '#007ACC' },
  { id: 'cursor',   name: 'Cursor',   bundle: 'com.todesktop.230313mzl4w4u92', tint: '#3a3a3c' },
  { id: 'xcode',    name: 'Xcode',    bundle: 'com.apple.dt.Xcode',            tint: '#1577F2' },
  { id: 'finder',   name: 'Finder',   bundle: 'com.apple.finder',              tint: '#1FA0F2' },
  { id: 'safari',   name: 'Safari',   bundle: 'com.apple.Safari',              tint: '#1B88F8' },
  { id: 'chrome',   name: 'Chrome',   bundle: 'com.google.Chrome',             tint: '#4285F4' },
  { id: 'arc',      name: 'Arc',      bundle: 'company.thebrowser.Browser',    tint: '#FF6363' },
  { id: 'terminal', name: 'Terminal', bundle: 'com.apple.Terminal',            tint: '#4a4a4c' },
  { id: 'iterm2',   name: 'iTerm2',   bundle: 'com.googlecode.iterm2',         tint: '#2a2a2c' },
  { id: 'figma',    name: 'Figma',    bundle: 'com.figma.Desktop',             tint: '#A259FF' },
  { id: 'slack',    name: 'Slack',    bundle: 'com.tinyspeck.slackmacgap',     tint: '#611F69' },
  { id: 'notion',   name: 'Notion',   bundle: 'notion.id',                     tint: '#5a5a5c' },
  { id: 'spotify',  name: 'Spotify',  bundle: 'com.spotify.client',            tint: '#1DB954' },
  { id: 'mail',     name: 'Mail',     bundle: 'com.apple.mail',                tint: '#21A4FD' },
  { id: 'notes',    name: 'Notes',    bundle: 'com.apple.Notes',               tint: '#FFC400' },
];

// Generic placeholder app icon — gradient tile w/ first letter.
// Original art is not used to avoid copying brand marks.
function AppTile({ app, size = 56, selected = false, onClick }) {
  const letter = app.name[0];
  const tint = app.tint || '#666';
  return (
    <button
      onClick={onClick}
      style={{
        width: size, height: size, borderRadius: size * 0.22,
        background: `linear-gradient(135deg, ${tint}, ${shade(tint, -0.25)})`,
        boxShadow: selected
          ? `0 0 0 2px #1c1c1e, 0 0 0 5px #0a84ff, 0 6px 14px rgba(0,0,0,0.4)`
          : '0 4px 10px rgba(0,0,0,0.4), inset 0 1px 0 rgba(255,255,255,0.18), 0 0 0 0.5px rgba(255,255,255,0.06)',
        border: 'none',
        cursor: 'pointer',
        position: 'relative',
        transition: 'all 200ms ease',
        flexShrink: 0,
        padding: 0,
        fontFamily: SHU_FONT,
      }}
      aria-pressed={selected}
    >
      <span style={{
        position: 'absolute', inset: 0,
        display: 'flex', alignItems: 'center', justifyContent: 'center',
        color: 'rgba(255,255,255,0.95)',
        fontWeight: 700, fontSize: size * 0.45, letterSpacing: -0.5,
        textShadow: '0 1px 2px rgba(0,0,0,0.25)',
      }}>{letter}</span>
    </button>
  );
}

// Crude HSL shading for tile gradient
function shade(hex, amount) {
  const h = hex.replace('#', '');
  const r = parseInt(h.substr(0, 2), 16);
  const g = parseInt(h.substr(2, 2), 16);
  const b = parseInt(h.substr(4, 2), 16);
  const k = 1 + amount;
  const c = (v) => Math.max(0, Math.min(255, Math.round(v * k))).toString(16).padStart(2, '0');
  return `#${c(r)}${c(g)}${c(b)}`;
}

// Square macOS button — primary (blue) and secondary (translucent).
function SHUButton({ label, kind = 'primary', onClick, disabled = false, style = {} }) {
  const base = {
    fontFamily: SHU_FONT, fontSize: 13, fontWeight: 500,
    padding: '8px 18px', borderRadius: 8, border: 'none',
    cursor: disabled ? 'not-allowed' : 'pointer',
    transition: 'transform 80ms ease, opacity 200ms ease, background 200ms ease',
    opacity: disabled ? 0.4 : 1,
    minWidth: 100,
  };
  const styles = kind === 'primary' ? {
    background: '#0a84ff', color: '#fff',
    boxShadow: '0 1px 0 rgba(0,0,0,0.15), inset 0 0.5px 0 rgba(255,255,255,0.25)',
  } : kind === 'ghost' ? {
    background: 'transparent', color: '#0a84ff',
  } : {
    background: 'rgba(255,255,255,0.1)', color: 'rgba(255,255,255,0.92)',
    boxShadow: 'inset 0 0 0 0.5px rgba(255,255,255,0.08)',
  };
  return (
    <button
      onClick={disabled ? undefined : onClick}
      style={{ ...base, ...styles, ...style }}
      onMouseDown={(e) => !disabled && (e.currentTarget.style.transform = 'scale(0.97)')}
      onMouseUp={(e) => (e.currentTarget.style.transform = 'scale(1)')}
      onMouseLeave={(e) => (e.currentTarget.style.transform = 'scale(1)')}
    >{label}</button>
  );
}

// Step indicator dots — non-interactive, just a hint of progress
function StepDots({ count, current }) {
  return (
    <div style={{ display: 'flex', gap: 6, alignItems: 'center' }}>
      {Array.from({ length: count }, (_, i) => (
        <div key={i} style={{
          width: i === current ? 18 : 6, height: 6, borderRadius: 3,
          background: i === current ? '#0a84ff' : 'rgba(255,255,255,0.18)',
          transition: 'all 250ms ease',
        }} />
      ))}
    </div>
  );
}

Object.assign(window, {
  SHU_FONT, SHU_MONO, SUPPORTED_APPS,
  AppTile, SHUButton, StepDots, shade,
});
