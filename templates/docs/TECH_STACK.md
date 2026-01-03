# Technology Stack Definition
# 🛠️ Project Technology Stack

**Purpose:** Explicitly define technologies, versions, and constraints for AI assistants.

---

## 📋 Core Technologies

### Language
```yaml
Language: TypeScript
Version: 5.3+
Mode: Strict
```

### Framework
```yaml
Framework: Next.js
Version: 14.x
Router: App Router
```

### UI Library
```yaml
Library: React
Version: 18+
Styling: Tailwind CSS 3.4+
```

### State Management
```yaml
Global: Zustand
Local: useState / useReducer
Server State: TanStack Query (React Query)
```

### Database
```yaml
Database: PostgreSQL
ORM: Prisma
Version: 5.0+
```

---

## 🚫 Forbidden Technologies

**Do NOT use without explicit permission:**
- ❌ jQuery
- ❌ Bootstrap
- ❌ Redux (unless explicitly required)
- ❌ Angular
- ❌ Vue.js (this is a React project)

---

## ✅ Allowed Libraries

### UI Components
```yaml
Base: React
Forms: react-hook-form
Validation: Zod
Data: TanStack Table
Icons: Lucide React
```

### Utilities
```yaml
Dates: date-fns
Http: axios / fetch
Styles: clsx / tailwind-merge
```

### Development
```yaml
Linting: ESLint
Formatting: Prettier
Testing: Vitest + @testing-library/react
Type Checking: TypeScript
```

---

## 📐 Code Style Standards

### TypeScript
```typescript
// ✅ Allowed
interface Props {
  title: string;
  count: number;
}

// ❌ Forbidden
interface Props {
  title: any;  // No any types
  count?: number;  // Always specify optional explicitly
}
```

### React
```tsx
// ✅ Allowed - Functional components with hooks
export const Component = ({ prop }: Props) => {
  return <div>{prop}</div>;
};

// ❌ Forbidden - Class components
export class Component extends React.Component {
  render() {
    return <div>{this.props.prop}</div>;
  }
}
```

### State
```tsx
// ✅ Allowed - useState for local state
const [count, setCount] = useState(0);

// ✅ Allowed - Zustand for global state
const useStore = create((set) => ({
  count: 0,
  increment: () => set((state) => ({ count: state.count + 1 }))
}));

// ❌ Forbidden - Context for complex state
const AppContext = createContext(...);  // Use Zustand instead
```

---

## 🎯 Quality Requirements

### Code Metrics
```yaml
Max Function Length: 50 lines
Max Nesting Depth: 4 levels
Max Component Props: 8 props
Code Coverage Target: 80%
```

### Performance
```yaml
Max Bundle Size: 500kb (gzip)
LCP Target: < 2.5s
FID Target: < 100ms
CLS Target: < 0.1
```

### Accessibility
```yaml
Standard: WCAG 2.1 AA
Keyboard Navigation: Required
Screen Reader: Supported
Color Contrast: AAA or AA minimum
```

---

## 🔒 Security Requirements

### Authentication
```yaml
Provider: NextAuth.js v5
Session: JWT tokens
Password Hashing: bcrypt
```

### Data Validation
```yaml
Schema: Zod
Validation: All user inputs
Sanitization: DOMPurify for HTML
```

### Secrets
```yaml
Storage: Environment variables only
Never commit: API keys, secrets, passwords
```

---

## 🧪 Testing Requirements

### Unit Tests
```yaml
Framework: Vitest
Coverage: 80%+
Test files: *.test.ts or *.spec.ts
```

### Integration Tests
```yaml
Framework: Playwright / Cypress
E2E scenarios: Critical user flows
```

### Test Patterns
```typescript
// ✅ Use Testing Library
render(<Component />);
screen.getByText('Submit');

// ❌ Avoid internal implementation details
wrapper.instance().handleSubmit();
```

---

## 📁 File Structure Conventions

```
src/
├── app/                    # Next.js App Router pages
├── components/              # Reusable React components
│   └── ui/               # Base UI components
├── lib/                    # Utility functions
├── hooks/                  # Custom React hooks
├── store/                  # Zustand stores
├── types/                  # TypeScript types
└── styles/                 # Global styles
```

---

## 🔄 Git & CI/CD

### Git Hooks
```yaml
Pre-commit: ESLint + Prettier
Pre-push: Tests
```

### Branching Strategy
```yaml
Main: main
Development: develop
Features: feature/feature-name
Fixes: fix/issue-name
```

### CI Pipeline
```yaml
On Push:
  - Run linter
  - Run tests
  - Build project

On Pull Request:
  - All above
  - Code coverage check
  - Security scan
```

---

## 📦 Package.json Constraints

### Dependencies
```json
{
  "dependencies": {
    "react": "^18.3.0",
    "next": "^14.2.0",
    "typescript": "^5.3.0"
  }
}
```

### No Deprecated Packages
```yaml
❌ isomorphic-fetch
❌ redux-thunk
❌ enzyme
❌ prop-types (use TypeScript instead)
```

---

## 🌐 Environment Configuration

### Required Environment Variables
```env
DATABASE_URL=
NEXTAUTH_SECRET=
NEXTAUTH_URL=
API_ENDPOINT=
```

### Optional Environment Variables
```env
NODE_ENV=development
LOG_LEVEL=debug
```

---

## 📚 Documentation Requirements

### Code Comments
```typescript
// ✅ Required: Complex business logic
// ✅ Required: Why (not what)
// ✅ Required: Edge cases

// ❌ Avoid: Obvious statements
// This function returns the count
```

### Documentation Files
```yaml
README.md: Required
CHANGELOG.md: Required
API.md: If has API
CONTRIBUTING.md: If open source
```

---

## 🎨 Design System

### Color Palette
```css
Primary: #3B82F6 (blue-500)
Secondary: #6B7280 (gray-500)
Success: #10B981 (green-500)
Error: #EF4444 (red-500)
Warning: #F59E0B (yellow-500)
```

### Typography
```css
Font Family: Inter, system-ui, sans-serif
Font Sizes: 12px, 14px, 16px, 18px, 24px, 32px
Line Heights: 1.4, 1.6, 1.8
```

### Spacing
```css
Scale: 0.25rem (4px), 0.5rem (8px), 1rem (16px)
```

---

## ⚡ Performance Optimizations

### Required Patterns
```tsx
// ✅ Use React.memo for expensive components
export const Expensive = React.memo(Component);

// ✅ Use useMemo for expensive calculations
const memoized = useMemo(() => heavyCalc(a, b), [a, b]);

// ✅ Use useCallback for function references
const handleClick = useCallback(() => {}, [deps]);

// ✅ Lazy load routes
const Page = dynamic(() => import('./Page'));
```

---

## 🔧 Development Tools

### VS Code Extensions (Recommended)
```yaml
ESLint: dbaeumer.vscode-eslint
Prettier: esbenp.prettier-vscode
TypeScript: ms-vscode.vscode-typescript-next
Tailwind: bradlc.vscode-tailwindcss
Git: eamodio.gitlens
```

### CLI Tools
```bash
# Development
npm run dev

# Building
npm run build

# Linting
npm run lint
npm run lint:fix

# Testing
npm run test
npm run test:coverage
npm run test:e2e
```

---

## 📝 Notes

**Important:**
1. Always check this file before starting work
2. If technology is not listed, do NOT use it without asking
3. Follow version constraints strictly
4. Update this file when stack changes
5. Reference in all AI prompts: `@docs/TECH_STACK.md`

---

**Last Updated:** [Date]
**Maintainer:** [Name]
