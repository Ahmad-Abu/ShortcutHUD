// screens-1.jsx — Welcome, Permission, Apps, Skill level

// ─────────────────────────────────────────────────────────────
// Shared screen frame — title, subtitle, body slot, footer slot
// ─────────────────────────────────────────────────────────────
function ScreenFrame({ eyebrow, title, subtitle, children, footer, hideHeader = false }) {
  return (
    <div style={{
      display: 'flex', flexDirection: 'column',
      width: '100%', height: '100%',
      fontFamily: SHU_FONT,
      color: 'rgba(255,255,255,0.92)',
      background: '#1c1c1e',
    }}>
      {!hideHeader && (
        <div style={{ padding: '36px 56px 0', flexShrink: 0 }}>
          {eyebrow && (
            <div style={{
              fontSize: 11, fontWeight: 600, letterSpacing: 1.4,
              textTransform: 'uppercase', color: '#0a84ff',
              marginBottom: 10,
            }}>{eyebrow}</div>
          )}
          <h1 style={{
            fontSize: 30, fontWeight: 600, margin: 0,
            letterSpacing: -0.6, lineHeight: 1.15,
            color: 'rgba(255,255,255,0.96)',
          }}>{title}</h1>
          {subtitle && (
            <p style={{
              fontSize: 14, lineHeight: 1.5,
              color: 'rgba(255,255,255,0.55)',
              margin: '8px 0 0', maxWidth: 540,
              textWrap: 'pretty',
            }}>{subtitle}</p>
          )}
        </div>
      )}
      <div style={{ flex: 1, position: 'relative', overflow: 'hidden' }}>
        {children}
      </div>
      {footer && (
        <div style={{
          padding: '14px 24px',
          borderTop: '0.5px solid rgba(255,255,255,0.06)',
          background: 'rgba(255,255,255,0.02)',
          display: 'flex', alignItems: 'center', gap: 12,
          flexShrink: 0,
        }}>
          {footer}
        </div>
      )}
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// 1. Welcome
// ─────────────────────────────────────────────────────────────
function WelcomeScreen({ onNext, totalSteps, currentStep }) {
  return (
    <ScreenFrame
      hideHeader
      footer={
        <>
          <StepDots count={totalSteps} current={currentStep} />
          <div style={{ flex: 1 }} />
          <SHUButton label="Get started" onClick={onNext} />
        </>
      }
    >
      <div style={{
        height: '100%', display: 'flex', flexDirection: 'column',
        alignItems: 'center', justifyContent: 'center',
        padding: '0 56px', textAlign: 'center',
      }}>
        {/* Hero: a giant key chip */}
        <div style={{
          display: 'flex', gap: 8, alignItems: 'center', marginBottom: 36,
          animation: 'shu-float 4s ease-in-out infinite',
        }}>
          <BigKey label="⌘" />
          <BigKey label="⇧" />
          <BigKey label="⌘" />
        </div>

        <h1 style={{
          fontSize: 36, fontWeight: 600, margin: 0,
          letterSpacing: -0.8, color: 'rgba(255,255,255,0.96)',
        }}>Welcome to ShortcutHUD</h1>
        <p style={{
          fontSize: 15, lineHeight: 1.55, color: 'rgba(255,255,255,0.55)',
          margin: '14px 0 0', maxWidth: 460, textWrap: 'pretty',
        }}>
          A quiet little panel that teaches you keyboard shortcuts for
          whichever app you're using — then gets out of the way once
          you've learned them.
        </p>

        <div style={{
          marginTop: 36, display: 'flex', gap: 32, alignItems: 'flex-start',
        }}>
          <Feature
            color="#34c759"
            title="Context-aware"
            body="Watches the front app and shows shortcuts that work right now."
          />
          <Feature
            color="#ffcc00"
            title="Tracks your progress"
            body="Counts every shortcut you press. Watch your progress bars fill up."
          />
          <Feature
            color="#ff9500"
            title="Graduates with you"
            body="Use a shortcut 10 times and it retires — replaced by a harder one."
          />
        </div>
      </div>
      <style>{`
        @keyframes shu-float {
          0%, 100% { transform: translateY(0); }
          50% { transform: translateY(-6px); }
        }
      `}</style>
    </ScreenFrame>
  );
}

function BigKey({ label }) {
  return (
    <div style={{
      width: 76, height: 76, borderRadius: 14,
      background: 'linear-gradient(180deg, #fefefe, #e8e8ec)',
      boxShadow: '0 1px 0 rgba(255,255,255,0.9) inset, 0 -2px 0 rgba(0,0,0,0.08) inset, 0 8px 18px rgba(0,0,0,0.12), 0 0 0 0.5px rgba(0,0,0,0.12)',
      display: 'flex', alignItems: 'center', justifyContent: 'center',
      fontFamily: SHU_FONT, fontSize: 36, fontWeight: 500,
      color: 'rgba(0,0,0,0.85)',
    }}>{label}</div>
  );
}

function Feature({ color, title, body }) {
  return (
    <div style={{ maxWidth: 160, textAlign: 'left' }}>
      <div style={{
        width: 10, height: 10, borderRadius: 5,
        background: color, marginBottom: 10,
        boxShadow: `0 0 0 4px ${color}26`,
      }} />
      <div style={{ fontSize: 13, fontWeight: 600, color: 'rgba(255,255,255,0.9)', marginBottom: 4 }}>{title}</div>
      <div style={{ fontSize: 12, lineHeight: 1.45, color: 'rgba(255,255,255,0.55)' }}>{body}</div>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// 2. Permission
// ─────────────────────────────────────────────────────────────
function PermissionScreen({ onNext, onBack, totalSteps, currentStep, granted, onGrant }) {
  return (
    <ScreenFrame
      eyebrow="Step 1 of 4"
      title="Allow ShortcutHUD to read keystrokes"
      subtitle="To count shortcuts as you press them, ShortcutHUD needs Accessibility access. Keystrokes are matched on-device against the shortcut for the front app — nothing is logged, transmitted, or stored."
      footer={
        <>
          <SHUButton label="Back" kind="secondary" onClick={onBack} />
          <StepDots count={totalSteps} current={currentStep} />
          <div style={{ flex: 1 }} />
          <SHUButton
            label={granted ? 'Continue' : 'Continue'}
            onClick={onNext}
            disabled={!granted}
          />
        </>
      }
    >
      <div style={{
        height: '100%', padding: '24px 56px 36px',
        display: 'flex', flexDirection: 'column', gap: 20,
      }}>
        {/* Faux System Settings panel */}
        <FauxSystemSettings granted={granted} onGrant={onGrant} />

        {/* Privacy callouts */}
        <div style={{
          display: 'grid', gridTemplateColumns: '1fr 1fr 1fr', gap: 12,
        }}>
          <PrivacyChip icon="◉" title="On-device" body="Match runs in the menu-bar process." />
          <PrivacyChip icon="✕" title="No logging" body="Keys aren't written to disk or sent anywhere." />
          <PrivacyChip icon="⌫" title="Revocable" body="Disable any time in System Settings." />
        </div>
      </div>
    </ScreenFrame>
  );
}

function FauxSystemSettings({ granted, onGrant }) {
  return (
    <div style={{
      borderRadius: 12,
      border: '0.5px solid rgba(0,0,0,0.12)',
      background: 'rgba(44,44,46,0.85)',
      overflow: 'hidden',
      boxShadow: '0 8px 24px rgba(0,0,0,0.08)',
    }}>
      {/* Window chrome */}
      <div style={{
        height: 36, padding: '0 12px',
        display: 'flex', alignItems: 'center', gap: 8,
        background: 'linear-gradient(180deg, #2c2c2e, #232325)',
        borderBottom: '0.5px solid rgba(0,0,0,0.08)',
      }}>
        <div style={{ width: 11, height: 11, borderRadius: '50%', background: '#ff5f57' }} />
        <div style={{ width: 11, height: 11, borderRadius: '50%', background: '#febc2e' }} />
        <div style={{ width: 11, height: 11, borderRadius: '50%', background: '#28c840' }} />
        <span style={{
          flex: 1, textAlign: 'center', fontSize: 12, fontWeight: 600,
          color: 'rgba(255,255,255,0.55)', marginRight: 50,
        }}>System Settings — Privacy &amp; Security › Accessibility</span>
      </div>

      {/* Body */}
      <div style={{ padding: 16, display: 'flex', alignItems: 'center', gap: 14 }}>
        <div style={{
          width: 40, height: 40, borderRadius: 8,
          background: 'linear-gradient(135deg, #1c1c1e, #3a3a3c)',
          display: 'flex', alignItems: 'center', justifyContent: 'center',
          boxShadow: '0 2px 6px rgba(0,0,0,0.18)',
        }}>
          <KeyboardGlyph size={18} color="rgba(255,255,255,0.95)" />
        </div>
        <div style={{ flex: 1 }}>
          <div style={{ fontSize: 13, fontWeight: 600, color: 'rgba(255,255,255,0.9)' }}>ShortcutHUD</div>
          <div style={{ fontSize: 11, color: 'rgba(255,255,255,0.5)', marginTop: 2 }}>
            Allow this app to receive keystrokes from any application.
          </div>
        </div>
        <Toggle on={granted} onChange={onGrant} />
      </div>

      {/* Status banner */}
      <div style={{
        padding: '10px 16px',
        background: granted ? 'rgba(52,199,89,0.10)' : 'rgba(255,159,10,0.08)',
        borderTop: '0.5px solid rgba(0,0,0,0.06)',
        fontSize: 11.5, color: granted ? '#34c759' : '#ff9f0a',
        display: 'flex', alignItems: 'center', gap: 8,
        transition: 'all 250ms ease',
      }}>
        <span style={{ fontFamily: SHU_MONO, fontSize: 11 }}>{granted ? '✓' : '!'}</span>
        <span>{granted
          ? 'Access granted. ShortcutHUD will count keystrokes for the front app only.'
          : 'Access not granted. Flip the switch to continue.'}</span>
      </div>
    </div>
  );
}

function Toggle({ on, onChange }) {
  return (
    <button
      role="switch"
      aria-checked={on}
      onClick={() => onChange(!on)}
      style={{
        width: 44, height: 26, borderRadius: 13,
        background: on ? '#34c759' : 'rgba(120,120,128,0.32)',
        border: 'none', padding: 0, cursor: 'pointer',
        transition: 'background 250ms ease',
        boxShadow: on ? '0 0 0 0.5px rgba(0,0,0,0.06)' : 'inset 0 0.5px 1px rgba(0,0,0,0.06)',
        position: 'relative',
        flexShrink: 0,
      }}
    >
      <div style={{
        position: 'absolute', top: 2, left: on ? 20 : 2,
        width: 22, height: 22, borderRadius: '50%',
        background: '#fff',
        boxShadow: '0 1px 2px rgba(0,0,0,0.25), 0 0 0 0.5px rgba(0,0,0,0.04)',
        transition: 'left 250ms cubic-bezier(.2,.8,.2,1)',
      }} />
    </button>
  );
}

function PrivacyChip({ icon, title, body }) {
  return (
    <div style={{
      padding: '12px 14px', borderRadius: 10,
      background: 'rgba(255,255,255,0.04)',
      border: '0.5px solid rgba(0,0,0,0.06)',
    }}>
      <div style={{
        fontFamily: SHU_MONO, fontSize: 14, fontWeight: 600,
        color: 'rgba(255,255,255,0.7)', marginBottom: 4,
      }}>{icon}</div>
      <div style={{ fontSize: 12, fontWeight: 600, color: 'rgba(255,255,255,0.88)' }}>{title}</div>
      <div style={{ fontSize: 11.5, color: 'rgba(255,255,255,0.55)', marginTop: 2, lineHeight: 1.4 }}>{body}</div>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// 3. App selection
// ─────────────────────────────────────────────────────────────
function AppsScreen({ onNext, onBack, totalSteps, currentStep, selectedIds, toggleApp, selectAll, clearAll }) {
  const count = selectedIds.length;
  return (
    <ScreenFrame
      eyebrow="Step 2 of 4"
      title="Pick the apps you actually use"
      subtitle="ShortcutHUD will surface shortcuts for these apps. You can change this later from the menu bar."
      footer={
        <>
          <SHUButton label="Back" kind="secondary" onClick={onBack} />
          <StepDots count={totalSteps} current={currentStep} />
          <div style={{ flex: 1 }} />
          <span style={{ fontSize: 12, color: 'rgba(255,255,255,0.5)' }}>
            {count} of {SUPPORTED_APPS.length} selected
          </span>
          <SHUButton label="Continue" onClick={onNext} disabled={count === 0} />
        </>
      }
    >
      <div style={{
        height: '100%', padding: '14px 56px 28px',
        display: 'flex', flexDirection: 'column', gap: 14,
        overflow: 'hidden',
      }}>
        <div style={{ display: 'flex', gap: 10, alignItems: 'center' }}>
          <SHUButton label="Select all" kind="ghost" onClick={selectAll} style={{ minWidth: 0, padding: '4px 8px' }} />
          <span style={{ color: 'rgba(255,255,255,0.18)' }}>·</span>
          <SHUButton label="Clear" kind="ghost" onClick={clearAll} style={{ minWidth: 0, padding: '4px 8px' }} />
        </div>
        <div style={{
          flex: 1, overflowY: 'auto',
          display: 'grid', gridTemplateColumns: 'repeat(5, 1fr)',
          gap: 14,
          paddingRight: 4,
        }}>
          {SUPPORTED_APPS.map((app) => {
            const selected = selectedIds.includes(app.id);
            return (
              <button
                key={app.id}
                onClick={() => toggleApp(app.id)}
                style={{
                  display: 'flex', flexDirection: 'column',
                  alignItems: 'center', gap: 8, padding: '12px 8px',
                  borderRadius: 12, cursor: 'pointer',
                  background: selected ? 'rgba(0,122,255,0.08)' : 'transparent',
                  border: '0.5px solid ' + (selected ? 'rgba(0,122,255,0.3)' : 'rgba(255,255,255,0.08)'),
                  transition: 'all 180ms ease',
                  fontFamily: SHU_FONT,
                }}
              >
                <AppTile app={app} size={48} selected={selected} />
                <span style={{
                  fontSize: 12, fontWeight: 500,
                  color: 'rgba(255,255,255,0.88)',
                }}>{app.name}</span>
              </button>
            );
          })}
        </div>
      </div>
    </ScreenFrame>
  );
}

// ─────────────────────────────────────────────────────────────
// 4. Skill / pace
// ─────────────────────────────────────────────────────────────
function SkillScreen({ onNext, onBack, totalSteps, currentStep, skill, setSkill, threshold, setThreshold }) {
  const skills = [
    { id: 'beginner', label: 'I know a few', body: 'Show basics first. Easy ramp-up.', color: '#34c759' },
    { id: 'mixed',    label: 'Mix it up',    body: 'A blend of basics and intermediates.', color: '#ffcc00' },
    { id: 'advanced', label: 'Throw it all', body: 'Skip basics. Go straight to power moves.', color: '#ff9500' },
  ];
  return (
    <ScreenFrame
      eyebrow="Step 3 of 4"
      title="Set your pace"
      subtitle="ShortcutHUD shows up to 7 shortcuts at a time. Tell us where to start, and how many times you want to use a shortcut before it graduates off the list."
      footer={
        <>
          <SHUButton label="Back" kind="secondary" onClick={onBack} />
          <StepDots count={totalSteps} current={currentStep} />
          <div style={{ flex: 1 }} />
          <SHUButton label="Continue" onClick={onNext} />
        </>
      }
    >
      <div style={{
        height: '100%', padding: '20px 56px 28px',
        display: 'flex', flexDirection: 'column', gap: 28,
      }}>
        {/* Skill level cards */}
        <div>
          <div style={{ fontSize: 12, fontWeight: 600, color: 'rgba(255,255,255,0.55)', textTransform: 'uppercase', letterSpacing: 0.8, marginBottom: 10 }}>
            Starting point
          </div>
          <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: 12 }}>
            {skills.map((s) => {
              const sel = skill === s.id;
              return (
                <button
                  key={s.id}
                  onClick={() => setSkill(s.id)}
                  style={{
                    textAlign: 'left', padding: 16, borderRadius: 12,
                    background: sel ? 'rgba(255,255,255,0.1)' : 'rgba(255,255,255,0.04)',
                    border: '0.5px solid ' + (sel ? s.color : 'rgba(255,255,255,0.1)'),
                    boxShadow: sel ? `0 0 0 2px ${s.color}55, 0 8px 20px rgba(0,0,0,0.3)` : 'none',
                    cursor: 'pointer',
                    transition: 'all 200ms ease',
                    fontFamily: SHU_FONT,
                  }}
                >
                  <div style={{
                    width: 8, height: 8, borderRadius: 4, background: s.color, marginBottom: 10,
                    boxShadow: `0 0 0 4px ${s.color}26`,
                  }} />
                  <div style={{ fontSize: 14, fontWeight: 600, color: 'rgba(255,255,255,0.9)' }}>{s.label}</div>
                  <div style={{ fontSize: 12, color: 'rgba(255,255,255,0.55)', marginTop: 4, lineHeight: 1.45 }}>{s.body}</div>
                </button>
              );
            })}
          </div>
        </div>

        {/* Graduation slider */}
        <div>
          <div style={{ fontSize: 12, fontWeight: 600, color: 'rgba(255,255,255,0.55)', textTransform: 'uppercase', letterSpacing: 0.8, marginBottom: 10 }}>
            Graduation threshold
          </div>
          <div style={{
            padding: '20px 22px', borderRadius: 12,
            background: 'rgba(255,255,255,0.04)',
            border: '0.5px solid rgba(0,0,0,0.06)',
          }}>
            <div style={{ display: 'flex', alignItems: 'baseline', gap: 8, marginBottom: 14 }}>
              <span style={{
                fontFamily: SHU_MONO, fontSize: 30, fontWeight: 600,
                color: 'rgba(255,255,255,0.92)', fontVariantNumeric: 'tabular-nums',
              }}>{threshold}</span>
              <span style={{ fontSize: 13, color: 'rgba(255,255,255,0.55)' }}>uses → graduate</span>
            </div>
            <input
              type="range"
              min="3" max="25" value={threshold}
              onChange={(e) => setThreshold(parseInt(e.target.value))}
              style={{ width: '100%', accentColor: '#0a84ff' }}
            />
            <div style={{
              display: 'flex', justifyContent: 'space-between', marginTop: 6,
              fontSize: 11, color: 'rgba(255,255,255,0.4)',
            }}>
              <span>3 — quick</span>
              <span>10 — default</span>
              <span>25 — thorough</span>
            </div>
          </div>
        </div>
      </div>
    </ScreenFrame>
  );
}

Object.assign(window, {
  ScreenFrame, WelcomeScreen, PermissionScreen, AppsScreen, SkillScreen,
  Toggle,
});
