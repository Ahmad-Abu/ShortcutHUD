// screens-2.jsx — Live demo, Graduation, Done

// ─────────────────────────────────────────────────────────────
// 5. Live demo — shows a faux desktop, the user "presses" a shortcut
// ─────────────────────────────────────────────────────────────
function DemoScreen({
  onNext, onBack, totalSteps, currentStep,
  demoApp, setDemoApp, demoCounts, setDemoCounts,
  threshold, demoShortcuts, justGraduated, setJustGraduated,
}) {
  const visible = demoShortcuts.slice(0, 7);
  const target = visible[0]; // hint at the first row

  function press(s) {
    setDemoCounts((prev) => {
      const next = { ...prev, [s.id]: (prev[s.id] ?? 0) + 1 };
      if ((next[s.id] ?? 0) >= threshold) {
        setJustGraduated(s);
        // schedule reset of "just graduated" later
        setTimeout(() => setJustGraduated(null), 2200);
      }
      return next;
    });
  }

  return (
    <ScreenFrame
      eyebrow="Step 4 of 4"
      title="Try it out"
      subtitle="Switch the front app and the HUD updates instantly. Tap a shortcut to simulate pressing it — the count ticks up, the bar fills, and once it hits the threshold, the shortcut retires."
      footer={
        <>
          <SHUButton label="Back" kind="secondary" onClick={onBack} />
          <StepDots count={totalSteps} current={currentStep} />
          <div style={{ flex: 1 }} />
          <SHUButton label="Finish setup" onClick={onNext} />
        </>
      }
    >
      <div style={{
        height: '100%', padding: '14px 56px 28px',
        display: 'flex', gap: 22, alignItems: 'stretch', overflow: 'hidden',
      }}>
        {/* Left: app switcher + tap-to-press list */}
        <div style={{ flex: 1, display: 'flex', flexDirection: 'column', gap: 16, minWidth: 0 }}>
          <div>
            <div style={{ fontSize: 11, fontWeight: 600, color: 'rgba(255,255,255,0.5)', textTransform: 'uppercase', letterSpacing: 0.8, marginBottom: 8 }}>
              Front app
            </div>
            <div style={{ display: 'flex', gap: 8, flexWrap: 'wrap' }}>
              {['vscode', 'finder', 'safari', 'figma'].map((id) => {
                const app = SUPPORTED_APPS.find((a) => a.id === id);
                const sel = demoApp === id;
                return (
                  <button
                    key={id}
                    onClick={() => setDemoApp(id)}
                    style={{
                      display: 'flex', alignItems: 'center', gap: 8,
                      padding: '6px 10px 6px 6px', borderRadius: 10,
                      background: sel ? 'rgba(255,255,255,0.1)' : 'rgba(0,0,0,0.03)',
                      border: '0.5px solid ' + (sel ? '#0a84ff' : 'rgba(255,255,255,0.1)'),
                      boxShadow: sel ? '0 0 0 2px rgba(0,122,255,0.18)' : 'none',
                      cursor: 'pointer',
                      transition: 'all 180ms ease',
                      fontFamily: SHU_FONT,
                    }}
                  >
                    <AppTile app={app} size={26} />
                    <span style={{ fontSize: 12, fontWeight: 500 }}>{app.name}</span>
                  </button>
                );
              })}
            </div>
          </div>

          <div style={{ flex: 1, display: 'flex', flexDirection: 'column', minHeight: 0 }}>
            <div style={{ fontSize: 11, fontWeight: 600, color: 'rgba(255,255,255,0.5)', textTransform: 'uppercase', letterSpacing: 0.8, marginBottom: 8 }}>
              Practice — tap to “press”
            </div>
            <div style={{
              flex: 1, overflowY: 'auto', borderRadius: 12,
              border: '0.5px solid rgba(0,0,0,0.08)',
              background: 'rgba(0,0,0,0.02)',
              padding: 8,
              display: 'flex', flexDirection: 'column', gap: 4,
            }}>
              {visible.map((s, i) => {
                const c = demoCounts[s.id] ?? 0;
                const isHint = i === 0 && c === 0;
                const color = LEVEL_COLOR[s.level];
                return (
                  <button
                    key={s.id}
                    onClick={() => press(s)}
                    style={{
                      display: 'flex', alignItems: 'center', gap: 10,
                      padding: '8px 10px', borderRadius: 8,
                      background: isHint ? 'rgba(0,122,255,0.08)' : 'transparent',
                      border: '0.5px solid ' + (isHint ? 'rgba(0,122,255,0.3)' : 'transparent'),
                      cursor: 'pointer',
                      transition: 'all 150ms ease',
                      textAlign: 'left',
                      fontFamily: SHU_FONT,
                    }}
                    onMouseEnter={(e) => e.currentTarget.style.background = 'rgba(0,0,0,0.04)'}
                    onMouseLeave={(e) => e.currentTarget.style.background = isHint ? 'rgba(0,122,255,0.08)' : 'transparent'}
                  >
                    <KeyChip keys={s.keys} color={color} size="md" />
                    <span style={{ fontSize: 12.5, color: 'rgba(255,255,255,0.85)', flex: 1, overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>{s.description}</span>
                    {c > 0 && (
                      <span style={{
                        fontFamily: SHU_MONO, fontSize: 11, fontWeight: 500,
                        color: 'rgba(255,255,255,0.5)',
                        fontVariantNumeric: 'tabular-nums',
                      }}>{c}/{threshold}</span>
                    )}
                    {isHint && (
                      <span style={{
                        fontSize: 10, fontWeight: 600, color: '#0a84ff',
                        textTransform: 'uppercase', letterSpacing: 0.6,
                      }}>Try me</span>
                    )}
                  </button>
                );
              })}
            </div>
          </div>
        </div>

        {/* Right: live HUD preview */}
        <div style={{
          width: 320, flexShrink: 0,
          display: 'flex', flexDirection: 'column', alignItems: 'stretch', gap: 10,
        }}>
          <div style={{ fontSize: 11, fontWeight: 600, color: 'rgba(255,255,255,0.5)', textTransform: 'uppercase', letterSpacing: 0.8 }}>
            Live HUD
          </div>
          <div style={{
            flex: 1, borderRadius: 14,
            background: 'linear-gradient(135deg, #2c5364, #203a43, #0f2027)',
            position: 'relative', overflow: 'hidden',
            boxShadow: 'inset 0 1px 0 rgba(255,255,255,0.06)',
            padding: 16,
            display: 'flex', alignItems: 'flex-end', justifyContent: 'flex-end',
          }}>
            {/* faux mac top bar */}
            <div style={{
              position: 'absolute', top: 0, left: 0, right: 0, height: 22,
              background: 'rgba(0,0,0,0.3)',
              backdropFilter: 'blur(20px)', WebkitBackdropFilter: 'blur(20px)',
              display: 'flex', alignItems: 'center', justifyContent: 'flex-end',
              padding: '0 10px', gap: 8,
              fontSize: 10, color: 'rgba(255,255,255,0.7)',
              fontFamily: SHU_FONT,
            }}>
              <KeyboardGlyph size={9} color="rgba(255,255,255,0.85)" />
              <span style={{ opacity: 0.6 }}>Wed 09:41</span>
            </div>
            <HUDPanel
              appName={SUPPORTED_APPS.find((a) => a.id === demoApp)?.name || 'No App'}
              shortcuts={visible.filter((s) => (demoCounts[s.id] ?? 0) < threshold)}
              counts={demoCounts}
              threshold={threshold}
              justGraduatedId={justGraduated?.id}
              style={{ transform: 'scale(0.92)', transformOrigin: 'bottom right' }}
            />

            {/* Graduation toast */}
            {justGraduated && (
              <div style={{
                position: 'absolute', top: 36, left: 16, right: 16,
                padding: '12px 14px', borderRadius: 10,
                background: 'rgba(52,199,89,0.95)',
                color: '#fff', fontFamily: SHU_FONT,
                boxShadow: '0 8px 24px rgba(52,199,89,0.4)',
                animation: 'shu-toast-in 250ms ease-out',
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
        </div>
      </div>
      <style>{`
        @keyframes shu-toast-in {
          from { opacity: 0; transform: translateY(-8px); }
          to { opacity: 1; transform: translateY(0); }
        }
      `}</style>
    </ScreenFrame>
  );
}

// ─────────────────────────────────────────────────────────────
// 6. Done — pin location, menu bar reveal, ready
// ─────────────────────────────────────────────────────────────
function DoneScreen({ onFinish, onBack, totalSteps, currentStep, selectedCount, threshold, skill }) {
  return (
    <ScreenFrame
      hideHeader
      footer={
        <>
          <SHUButton label="Back" kind="secondary" onClick={onBack} />
          <StepDots count={totalSteps} current={currentStep} />
          <div style={{ flex: 1 }} />
          <SHUButton label="Start using ShortcutHUD" onClick={onFinish} />
        </>
      }
    >
      <div style={{
        height: '100%', display: 'flex', flexDirection: 'column',
        alignItems: 'center', justifyContent: 'center',
        padding: '0 56px', textAlign: 'center', gap: 24,
      }}>
        <div style={{
          width: 88, height: 88, borderRadius: 22,
          background: 'linear-gradient(135deg, #34c759, #1f9d47)',
          display: 'flex', alignItems: 'center', justifyContent: 'center',
          boxShadow: '0 14px 40px rgba(52,199,89,0.35)',
        }}>
          <svg width="44" height="44" viewBox="0 0 44 44" fill="none">
            <path d="M11 22.5l7 7 15-16" stroke="#fff" strokeWidth="3.6" strokeLinecap="round" strokeLinejoin="round"/>
          </svg>
        </div>

        <div>
          <h1 style={{ fontSize: 30, fontWeight: 600, margin: 0, letterSpacing: -0.6 }}>
            You're all set
          </h1>
          <p style={{
            fontSize: 14, lineHeight: 1.55, color: 'rgba(255,255,255,0.55)',
            margin: '8px 0 0', maxWidth: 420, textWrap: 'pretty',
          }}>
            ShortcutHUD lives in your menu bar and floats in the bottom-right of your screen.
            It updates as you switch apps. Quietly. Forever.
          </p>
        </div>

        {/* Summary */}
        <div style={{
          display: 'flex', gap: 0,
          background: 'rgba(255,255,255,0.04)',
          border: '0.5px solid rgba(0,0,0,0.06)',
          borderRadius: 12, padding: 4,
        }}>
          <SummaryStat value={selectedCount} label="apps tracked" />
          <Sep />
          <SummaryStat value={threshold} label="uses to graduate" />
          <Sep />
          <SummaryStat
            value={skill === 'beginner' ? 'Easy' : skill === 'mixed' ? 'Mixed' : 'Hard'}
            label="starting pace"
          />
        </div>

        {/* Menu bar reveal */}
        <div style={{ width: '100%', maxWidth: 540, marginTop: 6 }}>
          <div style={{
            fontSize: 11, fontWeight: 600, color: 'rgba(255,255,255,0.5)',
            textTransform: 'uppercase', letterSpacing: 0.8, marginBottom: 10,
            textAlign: 'left',
          }}>Find it here, any time</div>
          <FauxMenuBar />
        </div>
      </div>
    </ScreenFrame>
  );
}

function SummaryStat({ value, label }) {
  return (
    <div style={{ padding: '10px 22px' }}>
      <div style={{
        fontSize: 22, fontWeight: 600, fontFamily: SHU_FONT,
        color: 'rgba(255,255,255,0.9)', fontVariantNumeric: 'tabular-nums',
        lineHeight: 1.1,
      }}>{value}</div>
      <div style={{ fontSize: 11, color: 'rgba(255,255,255,0.55)', marginTop: 2 }}>{label}</div>
    </div>
  );
}

function Sep() {
  return <div style={{ width: 0.5, background: 'rgba(255,255,255,0.12)', alignSelf: 'stretch', margin: '6px 0' }} />;
}

function FauxMenuBar() {
  return (
    <div style={{
      height: 24, borderRadius: 6,
      background: 'rgba(20,20,22,0.85)',
      backdropFilter: 'blur(20px)', WebkitBackdropFilter: 'blur(20px)',
      border: '0.5px solid rgba(255,255,255,0.08)',
      display: 'flex', alignItems: 'center',
      padding: '0 8px', gap: 12,
      color: 'rgba(255,255,255,0.85)',
      fontFamily: SHU_FONT, fontSize: 11,
      position: 'relative',
    }}>
      <span style={{ fontWeight: 700, fontSize: 13 }}> </span>
      <span style={{ opacity: 0.7 }}>ShortcutHUD</span>
      <span style={{ opacity: 0.5 }}>File</span>
      <span style={{ opacity: 0.5 }}>Edit</span>
      <span style={{ opacity: 0.5 }}>View</span>
      <span style={{ flex: 1 }} />
      {/* highlight ring */}
      <div style={{
        position: 'relative',
        display: 'flex', alignItems: 'center', justifyContent: 'center',
        width: 22, height: 18,
      }}>
        <div style={{
          position: 'absolute', inset: -4,
          borderRadius: 8,
          boxShadow: '0 0 0 2px rgba(0,122,255,0.85), 0 0 20px rgba(0,122,255,0.45)',
          animation: 'shu-pulse 1.6s ease-in-out infinite',
        }} />
        <KeyboardGlyph size={11} color="rgba(255,255,255,0.95)" />
      </div>
      <span style={{ opacity: 0.5 }}>🔋</span>
      <span style={{ opacity: 0.5 }}>📶</span>
      <span style={{ opacity: 0.7 }}>9:41</span>
      <style>{`
        @keyframes shu-pulse {
          0%, 100% { opacity: 1; }
          50% { opacity: 0.5; }
        }
      `}</style>
    </div>
  );
}

Object.assign(window, { DemoScreen, DoneScreen });
