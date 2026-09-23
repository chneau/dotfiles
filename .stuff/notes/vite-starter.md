# vite stuff

```bash
# create a vite project
npm create vite@latest . -- --template react-swc-ts

# add storybook
npx storybook@latest init

# remove useless files
rm -rf public src/{assets,stories,vite-env.d.ts,index.css,App.css} tsconfig.node.json

# remove references to `tsconfig.node.json` in `tsconfig.json`
sed -i '/tsconfig.node.json/d' tsconfig.json

# remove references to `vite.svg` in `index.html`
sed -i '/vite.svg/d' index.html

# remove `reactLogo`, `viteLogo` and `App.css` from `App.tsx`
sed -i '/reactLogo/d' src/App.tsx
sed -i '/viteLogo/d' src/App.tsx
sed -i '/App.css/d' src/App.tsx

# remove `index.css` from `main.tsx`
sed -i '/index.css/d' src/main.tsx

# Add <link rel="icon" href="data:," /> to `index.html` header
sed -i 's/<\/head>/<link rel="icon" href="data:," \/><\/head>/' index.html

# format all files
npx prettier@latest --ignore-path .gitignore --cache --write .
```
