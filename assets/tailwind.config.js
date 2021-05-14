module.exports = {
  mode: 'jit',
  purge: [
    '../lib/phoenix/*.ex',
    '../lib/phoenix/**/*.ex',
    '../lib/phoenix/**/*.leex',
    '../lib/phoenix/template/**/*.eex',
    './js/**/*.js'
  ],
  darkMode: false, // or 'media' or 'class'
  theme: {
    extend: {},
  },
  variants: {
    extend: {},
  },
  plugins: [],
}
