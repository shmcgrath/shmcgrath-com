(function() {
  const root = document.documentElement;
  const saved = localStorage.getItem('theme');
	const toggle = document.getElementById('theme-toggle');
	const syntaxCss = document.getElementById('syntax-theme');
	const synxtaxThemeLight = '/css/syntax-theme-light.css';
	const synxtaxThemeDark = '/css/syntax-theme-dark.css';

  function setTheme(theme) {
    root.setAttribute('data-theme', theme);
    localStorage.setItem('theme', theme);
		if (syntaxCss) {
			syntaxCss.href = theme === 'dark' ? `${synxtaxThemeDark}` : `${synxtaxThemeLight}`;
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

(function () {
    try {
        const currentYear = new Date().getFullYear();
        const yearDiv = document.getElementById('current-year');
        if (yearDiv) {
            yearDiv.textContent = currentYear;
        } else {
            console.error('no div with id "current-year"');
        }
    } catch (error) {
        console.error('Error while updating current year:', error);
    }
})();
