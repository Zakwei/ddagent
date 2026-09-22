/** @type {import('tailwindcss').Config} */
// Colors are NOT wired here — the web theme uses CSS vars that NativeWind
// can't resolve; the identical palette lives in src/theme.ts (useTheme).
// NativeWind is used for layout/spacing/typography classes only.
module.exports = {
  content: ['./App.tsx', './src/**/*.{ts,tsx}'],
  presets: [require('nativewind/preset')],
  darkMode: 'class',
  theme: {
    extend: {
      fontFamily: {
        sans: ['EncodeSans'],
        serif: ['Merriweather'],
      },
    },
  },
};
