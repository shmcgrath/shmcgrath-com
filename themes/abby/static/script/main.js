(function() {
  const root = document.documentElement;
  const saved = localStorage.getItem('theme');
	const toggle = document.getElementById('theme-toggle');
	const icon = document.getElementById('theme-toggle-icon');
	const color = window.iconColor || 'blue'; // blue is fallback
	const iconPrefix = `/img/icons-${color}/`;
	const iconLight = `${iconPrefix}sun-light.png`;
	const iconDark = `${iconPrefix}moon-dark.png`;

  function setTheme(theme) {
    root.setAttribute('data-theme', theme);
    localStorage.setItem('theme', theme);
    if (icon) {
      icon.src = theme === 'dark' ? `${iconLight}` : `${iconDark}`;
    }
  }

  if (saved) {
		setTheme(saved);
		if (toggle) { toggle.checked = saved === 'light'; } // set checkbox position
  } else if (window.matchMedia('(prefers-color-scheme: light)').matches) {
		setTheme('light');
    if (toggle) { toggle.checked = true; }
  } else {
		setTheme('dark');
    if (toggle) { toggle.checked = false; }
  }

	if (toggle) {
		toggle.addEventListener('change', () => {
			const next = toggle.checked ? 'light' : 'dark';
			setTheme(next);
		});
  }
})();
