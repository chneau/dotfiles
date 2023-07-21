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

```tsx
// src/App.stories.tsx
import { expect } from "@storybook/jest";
import type { Meta, StoryObj } from "@storybook/react";
import { waitFor, within } from "@storybook/testing-library";
import { App } from "./App";

export default { component: App } satisfies Meta<typeof App>;

export const Default: StoryObj<typeof App> = {
  args: { user: { name: "Jane Doe" } },
  play: async ({ canvasElement }) => {
    const canvas = within(canvasElement);
    canvas.getByText("count is 0").click();
    waitFor(() => expect(canvas.getByText("count is 1")).toBeInTheDocument());
  },
};
```

```jsonc
// package.json
{
  "name": "name",
  "private": true,
  "version": "0.0.0",
  "type": "module",
  "scripts": {
    "start": "npm run storybook",
    "dev": "vite",
    "build": "tsc && vite build",
    "lint": "eslint . --ext ts,tsx --report-unused-disable-directives --max-warnings 0",
    "preview": "vite preview",
    "update": "npm run upgrade",
    "upgrade": "npx npm-check-updates@latest -u && npm update",
    "check": "tsc --noEmit",
    "format": "npx prettier@latest --write . --ignore-path .gitignore",
    "storybook": "storybook dev -p 6006",
    "build-storybook": "storybook build",
    "test": "test-storybook"
  },
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0"
  },
  "devDependencies": {
    "@storybook/addon-essentials": "^7.1.0",
    "@storybook/addon-interactions": "^7.1.0",
    "@storybook/addon-links": "^7.1.0",
    "@storybook/addon-onboarding": "^1.0.8",
    "@storybook/blocks": "^7.1.0",
    "@storybook/jest": "^0.1.0",
    "@storybook/react": "^7.1.0",
    "@storybook/react-vite": "^7.1.0",
    "@storybook/test-runner": "^0.11.0",
    "@storybook/testing-library": "^0.2.0",
    "@types/react": "^18.2.15",
    "@types/react-dom": "^18.2.7",
    "@typescript-eslint/eslint-plugin": "^6.1.0",
    "@typescript-eslint/parser": "^6.1.0",
    "@vitejs/plugin-react-swc": "^3.3.2",
    "eslint": "^8.45.0",
    "eslint-plugin-react-hooks": "^4.6.0",
    "eslint-plugin-react-refresh": "^0.4.3",
    "eslint-plugin-storybook": "^0.6.13",
    "storybook": "^7.1.0",
    "typescript": "^5.1.6",
    "vite": "^4.4.6"
  },
  "prettier": {}
}
```
