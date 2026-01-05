# ✅ Validation Checklist Template
# Quality Assurance & Validation Gates

**Purpose:** Ensure code meets all quality standards before commit. **NO EXCEPTIONS ALLOWED.**

---

## 🎯 Validation Overview

**When to Use:** After every code implementation
**Who Performs:** VALIDATOR phase (automated or manual)
**Result:** ✅ PASS = Commit allowed | ❌ FAIL = Return to EXECUTOR

---

## 🔧 Technology Stack Compliance

### Language & Framework
- [ ] **TypeScript strict mode** enabled (no JavaScript)
- [ ] **Approved frameworks only** (matches TECH_STACK.md)
- [ ] **Version constraints** followed
- [ ] **No forbidden technologies** used
- [ ] **Platform compatibility** maintained

### Dependencies & Libraries
- [ ] **Only approved packages** from TECH_STACK.md
- [ ] **No deprecated libraries** (checked via npm audit)
- [ ] **License compatibility** verified
- [ ] **Bundle size** within limits (<500kb gzip)
- [ ] **No circular dependencies**

---

## 🛡️ Code Quality Standards

### TypeScript/Type Safety
- [ ] **Zero any types** (explicit types only)
- [ ] **No implicit any** parameters
- [ ] **Strict null checks** enabled
- [ ] **Interface segregation** (small, focused interfaces)
- [ ] **Generic constraints** properly defined

### Code Structure & Organization
- [ ] **Single Responsibility Principle** followed
- [ ] **Functions < 50 lines** each
- [ ] **Files < 300 lines** each
- [ ] **Proper imports/exports** (no wildcard imports)
- [ ] **Consistent naming** conventions

### Error Handling
- [ ] **Try-catch blocks** around async operations
- [ ] **Proper error types** (not generic Error)
- [ ] **Error messages** user-friendly and informative
- [ ] **Graceful degradation** implemented
- [ ] **Logging** for debugging purposes

---

## 🧪 Testing Requirements

### Unit Tests
- [ ] **All public functions** have unit tests
- [ ] **Edge cases** covered (null, undefined, empty arrays)
- [ ] **Error conditions** tested
- [ ] **Mocking** used appropriately
- [ ] **Test isolation** maintained

### Integration Tests
- [ ] **API endpoints** tested end-to-end
- [ ] **Database operations** verified
- [ ] **External service** integrations tested
- [ ] **Authentication flows** validated

### Test Quality
- [ ] **Test coverage >80%** overall
- [ ] **No flakey tests** (consistent results)
- [ ] **Descriptive test names** (not "test1", "test2")
- [ ] **Arrange-Act-Assert** pattern followed
- [ ] **No business logic** in tests

---

## 🔒 Security Validation

### Input Validation
- [ ] **All user inputs** validated with Zod/schema
- [ ] **SQL injection** prevention (prepared statements)
- [ ] **XSS protection** (sanitization)
- [ ] **CSRF protection** implemented
- [ ] **Rate limiting** applied to APIs

### Authentication & Authorization
- [ ] **JWT tokens** properly validated
- [ ] **Password hashing** with bcrypt/argon2
- [ ] **Session management** secure
- [ ] **Role-based access** control implemented
- [ ] **Secure headers** configured

### Data Protection
- [ ] **No hardcoded secrets** in code
- [ ] **Environment variables** used for config
- [ ] **Sensitive data** encrypted at rest
- [ ] **HTTPS only** in production
- [ ] **CORS** properly configured

---

## 🏗️ Architecture Compliance

### Plan Adherence
- [ ] **File structure** matches PLAN.md
- [ ] **Component hierarchy** follows specification
- [ ] **API contracts** implemented as designed
- [ ] **Database schema** matches plan
- [ ] **No scope creep** (only planned features)

### Design Patterns
- [ ] **SOLID principles** followed
- [ ] **DRY principle** maintained (no duplication)
- [ ] **Appropriate patterns** used (Observer, Strategy, etc.)
- [ ] **Separation of concerns** clear
- [ ] **Dependency injection** where appropriate

### Performance
- [ ] **No memory leaks** (useEffect cleanup)
- [ ] **Lazy loading** for heavy components
- [ ] **Memoization** for expensive operations
- [ ] **Optimistic updates** for better UX
- [ ] **Code splitting** implemented

---

## 🎨 Code Style & Conventions

### Formatting & Linting
- [ ] **ESLint** passes with zero errors
- [ ] **Prettier** formatting applied
- [ ] **Consistent indentation** (2 spaces)
- [ ] **Semicolons** used consistently
- [ ] **Trailing commas** in multi-line structures

### Documentation
- [ ] **Complex functions** have JSDoc comments
- [ ] **Public APIs** documented
- [ ] **README.md** updated if needed
- [ ] **Inline comments** for business logic
- [ ] **TODO comments** removed or addressed

### Git & Version Control
- [ ] **Commit message** follows conventional format
- [ ] **No large files** committed (>10MB)
- [ ] **Sensitive files** in .gitignore
- [ ] **Branch naming** convention followed
- [ ] **Merge conflicts** resolved properly

---

## 🚀 Deployment Readiness

### Build & Packaging
- [ ] **Build succeeds** without errors
- [ ] **Type checking** passes
- [ ] **Bundle analysis** reviewed
- [ ] **Source maps** generated for debugging
- [ ] **Environment-specific** builds work

### Runtime Validation
- [ ] **No console errors** in production
- [ ] **Loading states** handled properly
- [ ] **Error boundaries** implemented
- [ ] **Fallback UI** for failures
- [ ] **Progressive enhancement** where applicable

---

## 📊 Performance Metrics

### Core Web Vitals (Frontend)
- [ ] **LCP < 2.5s** (Largest Contentful Paint)
- [ ] **FID < 100ms** (First Input Delay)
- [ ] **CLS < 0.1** (Cumulative Layout Shift)
- [ ] **TTFB < 800ms** (Time to First Byte)
- [ ] **Bundle size** monitored

### Backend Performance
- [ ] **Response time < 500ms** for APIs
- [ ] **Database queries** optimized
- [ ] **Caching** implemented where appropriate
- [ ] **Connection pooling** configured
- [ ] **Memory usage** within limits

---

## 🔍 Accessibility (WCAG 2.1 AA)

### Keyboard Navigation
- [ ] **All interactive elements** keyboard accessible
- [ ] **Focus indicators** visible and obvious
- [ ] **Tab order** logical and intuitive
- [ ] **Keyboard shortcuts** documented
- [ ] **No keyboard traps**

### Screen Reader Support
- [ ] **ARIA labels** on all controls
- [ ] **Semantic HTML** used properly
- [ ] **Alt text** on all images
- [ ] **Heading hierarchy** correct (h1→h2→h3)
- [ ] **Live regions** for dynamic content

### Visual Accessibility
- [ ] **Color contrast** ratio >4.5:1
- [ ] **Text size** adjustable (no fixed px)
- [ ] **Focus states** clearly visible
- [ ] **Error states** clearly communicated
- [ ] **Loading states** indicated

---

## 🌐 Browser & Device Compatibility

### Browser Support
- [ ] **Chrome 90+** tested
- [ ] **Firefox 88+** tested
- [ ] **Safari 14+** tested
- [ ] **Edge 90+** tested
- [ ] **Mobile browsers** tested

### Device Support
- [ ] **Responsive design** verified
- [ ] **Touch targets** minimum 44px
- [ ] **Mobile performance** acceptable
- [ ] **Tablet layouts** tested
- [ ] **Desktop layouts** tested

---

## 📋 Validation Results

### Overall Assessment
- [ ] **ALL CHECKLISTS PASSED**
- [ ] **ZERO CRITICAL ISSUES**
- [ ] **READY FOR COMMIT**

### Summary
```
✅ Technology Stack: [X/Y passed]
✅ Code Quality: [X/Y passed]
✅ Testing: [X/Y passed]
✅ Security: [X/Y passed]
✅ Architecture: [X/Y passed]
✅ Performance: [X/Y passed]
✅ Accessibility: [X/Y passed]
```

### Issues Found (if any)
- **Critical:** [List blocking issues]
- **Major:** [List important fixes needed]
- **Minor:** [List nice-to-have improvements]

### Approval
- **Validated By:** [VALIDATOR phase]
- **Date:** [YYYY-MM-DD]
- **Approval:** ✅ APPROVED FOR COMMIT | ❌ REQUIRES FIXES

---

## 🚨 Failure Handling

### If Validation Fails
1. **STOP** - Do not commit
2. **Document** failures in this checklist
3. **Return to EXECUTOR** with specific error details
4. **Allow one retry** attempt
5. **Escalate to human** if retry fails

### Critical Failures (No Commit Allowed)
- ❌ Security vulnerabilities
- ❌ Data loss potential
- ❌ Breaking API changes
- ❌ Performance degradation >50%
- ❌ Accessibility violations (WCAG AA)

### Non-Critical Issues
- ⚠️ Code style violations
- ⚠️ Missing documentation
- ⚠️ Minor performance optimizations
- ⚠️ Test coverage <90%

---

## 📈 Continuous Improvement

### Metrics to Track
- **Validation pass rate** (target: >90%)
- **Time to validation** (target: <10 min)
- **Common failure patterns**
- **Improvement opportunities**

### Regular Reviews
- **Weekly:** Review validation failures
- **Monthly:** Audit checklist completeness
- **Quarterly:** Update standards based on industry changes

---

## 🆘 Emergency Bypass (Rare Cases Only)

**Conditions for bypass:**
- 🚨 **Critical production issue** requiring immediate fix
- 🚨 **Security vulnerability** needing urgent patch
- 🚨 **Data integrity** threat

**Bypass Process:**
1. Document bypass reason in commit message
2. Create follow-up task for proper validation
3. Notify team lead for oversight
4. Address validation issues within 24 hours

**Format:**
```
🚨 EMERGENCY BYPASS: [Reason]
TODO: Complete validation checklist #123
```

---

## 📚 Related Documentation

- `docs/TECH_STACK.md` - Technology constraints
- `docs/PLAN.md` - Implementation specification
- `examples/multi-agent-protocol.md` - Protocol overview
- `AI_BEST_PRACTICES.md` - Development guidelines

---

**Remember: Strict validation ensures quality. No shortcuts allowed.** ✅
