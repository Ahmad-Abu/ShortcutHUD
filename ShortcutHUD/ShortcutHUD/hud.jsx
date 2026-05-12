// HUD.jsx — A faithful replica of HUDView.swift, in HTML/CSS.
// Matches sizes from the source: 280px wide, 12pt corners, 11pt rows, etc.

const HUD_FONT = '-apple-system, BlinkMacSystemFont, "SF Pro", "Helvetica Neue", sans-serif';
const MONO_FONT = 'ui-monospace, "SF Mono", Menlo, monospace';

const LEVEL_COLOR = {
  basic:        '#34c759', // green
  intermediate: '#ffcc00', // yellow
  advanced:     '#ff9500', // orange
};

function HUDPanel({ appName, shortcuts, counts, threshold = 10, style = {}, highlightId = null, justGraduatedId = null }) {
  const visible = shortcuts.slice(0, 7);
  return (
    <div style={{
      width: 280,
      minHeight: 200,
      borderRadius: 12,
      background: 'rgba(28, 28, 30, 0.72)',
      backdropFilter: 'blur(40px) saturate(180%)',
      WebkitBackdropFilter: 'blur(40px) saturate(180%)',
      border: '0.5px solid rgba(255,255,255,0.12)',
      boxShadow: '0 12px 40px rgba(0,0,0,0.45), inset 0 0.5px 0 rgba(255,255,255,0.08)',
      fontFamily: HUD_FONT,
      color: 'rgba(255,255,255,0.92)',
      overflow: 'hidden',
      ...style,
    }}>
      <HUDHeader appName={appName} />
      <div style={{ height: 0.5, background: 'rgba(255,255,255,0.1)', margin: '0 12px' }} />
      {visible.length === 0 ? (
        <div style={{
          fontSize: 11, color: 'rgba(255,255,255,0.55)',
          textAlign: 'center', padding: '18px 12px',
        }}>No shortcuts for this app</div>
      ) : (
        <div style={{ padding: '4px 0' }}>
          {visible.map((s) => (
            <ShortcutRow
              key={s.id}
              shortcut={s}
              count={counts[s.id] ?? 0}
              threshold={threshold}
              highlight={highlightId === s.id}
              graduated={justGraduatedId === s.id}
            />
          ))}
        </div>
      )}
    </div>
  );
}

function HUDHeader({ appName }) {
  return (
    <div style={{
      display: 'flex', alignItems: 'center', gap: 6,
      padding: '10px 12px',
    }}>
      <KeyboardGlyph size={11} />
      <span style={{ fontSize: 12, fontWeight: 600 }}>{appName || 'No App'}</span>
      <span style={{ flex: 1 }} />
      <span style={{ fontSize: 10, color: 'rgba(255,255,255,0.45)' }}>shortcuts</span>
    </div>
  );
}

function KeyboardGlyph({ size = 11, color = 'rgba(255,255,255,0.65)' }) {
  return (
    <svg width={size + 4} height={size} viewBox="0 0 16 12" fill="none" aria-hidden>
      <rect x="0.5" y="0.5" width="15" height="11" rx="2" stroke={color} strokeWidth="1" />
      <circle cx="3" cy="4" r="0.7" fill={color} />
      <circle cx="6" cy="4" r="0.7" fill={color} />
      <circle cx="9" cy="4" r="0.7" fill={color} />
      <circle cx="12" cy="4" r="0.7" fill={color} />
      <rect x="3" y="7" width="10" height="1.4" rx="0.7" fill={color} />
    </svg>
  );
}

function ShortcutRow({ shortcut, count, threshold, highlight, graduated }) {
  const color = LEVEL_COLOR[shortcut.level];
  const pct = Math.min(count / threshold, 1);

  return (
    <div style={{
      padding: '5px 12px 4px',
      transition: 'background 200ms ease, opacity 400ms ease',
      background: highlight ? `${color}22` : 'transparent',
      opacity: graduated ? 0 : 1,
      transform: graduated ? 'translateX(20px)' : 'translateX(0)',
    }}>
      <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
        <KeyChip keys={shortcut.keys} color={color} />
        <span style={{
          fontSize: 11,
          color: 'rgba(255,255,255,0.7)',
          whiteSpace: 'nowrap',
          overflow: 'hidden',
          textOverflow: 'ellipsis',
          flex: 1,
        }}>{shortcut.description}</span>
        {count > 0 && (
          <span style={{
            fontSize: 9, fontFamily: MONO_FONT, fontWeight: 500,
            color: 'rgba(255,255,255,0.5)',
            fontVariantNumeric: 'tabular-nums',
          }}>{count}/{threshold}</span>
        )}
      </div>
      {count > 0 && (
        <div style={{ height: 2, marginTop: 4, background: 'rgba(255,255,255,0.06)', borderRadius: 1, overflow: 'hidden' }}>
          <div style={{
            height: '100%', width: `${pct * 100}%`,
            background: color, opacity: 0.7,
            transition: 'width 350ms cubic-bezier(.2,.8,.2,1)',
          }} />
        </div>
      )}
    </div>
  );
}

function KeyChip({ keys, color = '#34c759', size = 'sm' }) {
  // size: 'sm' (HUD), 'md' (in-onboarding examples)
  const fontSize = size === 'md' ? 13 : 11;
  const padX = size === 'md' ? 8 : 6;
  const padY = size === 'md' ? 3 : 2;
  return (
    <span style={{
      display: 'inline-flex',
      fontFamily: MONO_FONT,
      fontSize,
      fontWeight: 500,
      padding: `${padY}px ${padX}px`,
      borderRadius: 4,
      background: `${color}26`, // ~15% alpha
      border: `0.5px solid ${color}59`, // ~35% alpha
      color: 'rgba(255,255,255,0.95)',
      minWidth: size === 'md' ? 84 : 70,
      justifyContent: 'center',
      whiteSpace: 'nowrap',
      letterSpacing: 0.2,
    }}>{keys}</span>
  );
}

Object.assign(window, { HUDPanel, HUDHeader, ShortcutRow, KeyChip, LEVEL_COLOR, KeyboardGlyph, HUD_FONT, MONO_FONT });
