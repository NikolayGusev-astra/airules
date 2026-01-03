# Implementation Plan Template
# 📋 Implementation Plan

**Created by:** ARCHITECT
**Date:** [Date]
**Feature:** [Feature Name]

---

## 🎯 Objectives

1. [Objective 1]
2. [Objective 2]
3. [Objective 3]

---

## 🏗️ Architecture

### Component Structure
```
[File structure visualization]
```

### Data Flow
```
[Data flow diagram or description]
```

### State Management
- **Global State:** [Zustand/Context/etc]
- **Local State:** [useState/useReducer]
- **Server State:** [React Query/Fetch/etc]
- **Rationale:** [Why this approach]

---

## 📁 File Structure

```
[Root directory]/
├── [Folder 1]/
│   ├── [File 1].tsx
│   └── [File 2].tsx
├── [Folder 2]/
│   └── [File 3].ts
└── [Folder 3]/
    └── [File 4].ts
```

### New Files
- `path/to/File1.tsx` — [Purpose]
- `path/to/File2.ts` — [Purpose]
- `path/to/File3.ts` — [Purpose]

### Modified Files
- `path/to/ExistingFile.tsx` — [Changes needed]
- `path/to/Config.ts` — [Changes needed]

---

## 🛠️ Technology Choices

### Framework/Libraries
| Technology | Version | Purpose | Rationale |
|------------|----------|---------|-----------|
| [Tech 1] | [Version] | [Why] | [Justification] |
| [Tech 2] | [Version] | [Why] | [Justification] |

### Why NOT [Alternative 1]
- [Reason 1]
- [Reason 2]

### Why NOT [Alternative 2]
- [Reason 1]
- [Reason 2]

---

## 🔌 API Integration

### Endpoints Required
| Method | Endpoint | Purpose | Response Type |
|--------|----------|---------|---------------|
| GET | `/api/resource` | Fetch data | `DataType` |
| POST | `/api/resource` | Create data | `DataType` |
| PUT | `/api/resource/:id` | Update data | `DataType` |
| DELETE | `/api/resource/:id` | Delete data | `void` |

### Data Validation
- **Input Schema:** [Zod schema]
- **Output Schema:** [TypeScript interface]
- **Error Handling:** [Strategy]

---

## 🎨 UI/UX Design

### Component Hierarchy
```
[Parent Component]
├── [Child Component 1]
│   └── [Grandchild Component]
└── [Child Component 2]
    └── [Grandchild Component]
```

### Design Patterns
- [Pattern 1] — [Description]
- [Pattern 2] — [Description]
- [Pattern 3] — [Description]

### Accessibility Requirements
- [ ] Keyboard navigation
- [ ] Screen reader support
- [ ] ARIA labels
- [ ] Focus management

---

## 🧪 Testing Strategy

### Unit Tests
- **Files to test:** [List of files]
- **Test coverage target:** [Percentage]
- **Key scenarios:**
  - [Scenario 1]
  - [Scenario 2]
  - [Scenario 3]

### Integration Tests
- **User flows to test:**
  1. [Flow 1]
  2. [Flow 2]
  3. [Flow 3]

### Edge Cases
- [Edge case 1]
- [Edge case 2]
- [Edge case 3]

---

## 🔒 Security Considerations

- [ ] Authentication/Authorization check
- [ ] Input validation
- [ ] Output sanitization
- [ ] Rate limiting
- [ ] Sensitive data handling

---

## ⚡ Performance Considerations

- [ ] Lazy loading for heavy components
- [ ] Memoization for expensive computations
- [ ] Optimistic UI updates
- [ ] Code splitting
- [ ] Image optimization

---

## 📝 Implementation Steps

### Phase 1: Setup & Types
1. [ ] Create TypeScript interfaces/types
2. [ ] Set up file structure
3. [ ] Configure build tools

### Phase 2: Core Logic
1. [ ] Implement API integration
2. [ ] Create business logic functions
3. [ ] Set up state management

### Phase 3: UI Components
1. [ ] Build [Component A]
2. [ ] Build [Component B]
3. [ ] Build [Component C]

### Phase 4: Integration
1. [ ] Connect components
2. [ ] Wire up data flow
3. [ ] Handle events

### Phase 5: Testing
1. [ ] Write unit tests
2. [ ] Write integration tests
3. [ ] Manual testing

### Phase 6: Polish
1. [ ] Performance optimization
2. [ ] Accessibility audit
3. [ ] Code review

---

## ✅ Acceptance Criteria

The feature is complete when:

- [ ] All objectives from section 1 are met
- [ ] File structure matches architecture
- [ ] All specified components are implemented
- [ ] API endpoints are integrated
- [ ] Unit tests pass (80%+ coverage)
- [ ] Integration tests pass
- [ ] No console errors or warnings
- [ ] Accessibility requirements met
- [ ] Performance targets met
- [ ] Code follows project conventions

---

## 🚫 Constraints & Limitations

### Technology Constraints
- Use only technologies listed in `docs/TECH_STACK.md`
- Follow version constraints
- No forbidden libraries

### Time Constraints
- Estimated effort: [Hours/Days]
- Priority: [High/Medium/Low]

### Scope Constraints
- **In scope:** [What's included]
- **Out of scope:** [What's excluded]

---

## 🔄 Dependencies

### External Dependencies
- [Dependency 1] — [Purpose]
- [Dependency 2] — [Purpose]

### Internal Dependencies
- Requires changes to: [File A]
- Requires changes to: [File B]
- Requires changes to: [File C]

---

## 📚 References

- `docs/TECH_STACK.md` — Technology requirements
- `docs/PROJECT_RULES.md` — Project guidelines
- [Related issue/PR] — Issue number
- [Design mockups] — Link if available

---

## 🎯 Success Metrics

- **Performance:** [Target metric]
- **Code coverage:** [Target percentage]
- **User satisfaction:** [NPS/feedback target]
- **Bug rate:** [Target reduction]

---

**📝 Notes for EXECUTOR:**

1. **Follow this plan EXACTLY**
   - Do NOT deviate from file structure
   - Do NOT change architecture without approval
   - Use specified technologies only

2. **Before coding:**
   - Read `docs/TECH_STACK.md`
   - Understand each section of this plan
   - Ask questions if anything is unclear

3. **While coding:**
   - Create files in order specified
   - Follow component hierarchy
   - Implement acceptance criteria checklist

4. **After coding:**
   - Verify all acceptance criteria
   - Run all tests
   - Check for errors/warnings

---

**Status:** 🔄 Ready for Implementation
**Next Step:** EXECUTOR phase
