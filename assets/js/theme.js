/**
 * Axmol theme manager: auto (OS), light, dark.
 * - Persists user selection in localStorage.
 * - Updates data-bs-theme attribute on <html>.
 * - Updates theme icon in navbar.
 */
(function () {
  const STORAGE_KEY = "axmol-theme"; // "light" | "dark" | "auto"

  function getSystemTheme() {
    return window.matchMedia("(prefers-color-scheme: dark)").matches ? "dark" : "light";
  }

  function applyTheme(theme) {
    const root = document.documentElement;
    const finalTheme = theme === "auto" ? getSystemTheme() : theme;
    root.setAttribute("data-bs-theme", finalTheme);
    updateThemeIcon(theme);
  }

  function loadTheme() {
    const saved = localStorage.getItem(STORAGE_KEY) || "auto";
    applyTheme(saved);
    return saved;
  }

  function saveTheme(theme) {
    localStorage.setItem(STORAGE_KEY, theme);
    applyTheme(theme);
  }

  const ICONS = {
    light: "sun-fill",
    dark: "moon-stars-fill",
    auto: "circle-half",
  };

  const LABELS = {
    light: "Switch to light theme",
    dark: "Switch to dark theme",
    auto: "Switch to automatic theme",
  };

  // Update the theme icon + ARIA state in navbar
  function updateThemeIcon(theme) {
    const iconUse = document.querySelector(".theme-icon use");
    if (iconUse) {
      iconUse.setAttribute("href", "/assets/icons.svg#" + ICONS[theme]);
    }

    const toggle = document.getElementById("themeDropdown");
    if (toggle) {
      toggle.setAttribute("aria-label", LABELS[theme] || "Theme");
    }

    document.querySelectorAll("[data-theme-option]").forEach((btn) => {
      const opt = btn.getAttribute("data-theme-option");
      btn.setAttribute("aria-pressed", opt === theme ? "true" : "false");
    });
  }

  // Initialize
  loadTheme();

  // Listen for system theme changes when in auto
  const media = window.matchMedia("(prefers-color-scheme: dark)");
  media.addEventListener("change", () => {
    const saved = localStorage.getItem(STORAGE_KEY) || "auto";
    if (saved === "auto") applyTheme("auto");
  });

  // Expose to global
  window.AxmolTheme = { saveTheme, loadTheme, applyTheme };

  // scroll fadein
  document.addEventListener("DOMContentLoaded", () => {
    const items = document.querySelectorAll(".fade-in-list .list-group-item");
    const observer = new IntersectionObserver((entries) => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          entry.target.classList.add("visible");
          observer.unobserve(entry.target); // only animate once
        }
      });
    }, { threshold: 0.2 });

    items.forEach(item => observer.observe(item));
  });

  /* Enable bootstrap static tooltip */
  document.addEventListener("DOMContentLoaded", function () {
    const tooltipTriggerList = document.querySelectorAll('[data-bs-toggle="tooltip"]');
    [...tooltipTriggerList].forEach(el => new bootstrap.Tooltip(el));
  });

  /* Enable bootstrap dynamic tooltip */
  document.addEventListener("DOMContentLoaded", function () {
    new bootstrap.Tooltip(document.body, {
      selector: '[data-bs-toggle="tooltip"]'
    });
  });

})();
