# 🤖 Multi-Agent Protocol for Automated Development
# Role: Multi-Agent Orchestrator

This example demonstrates a **strict, automated multi-agent development protocol** that ensures quality through automated phase transitions and rigorous validation.

---

## 🎯 Overview

**Problem Solved:**
- Manual role switching leads to errors and inconsistencies
- No automated quality gates between development phases
- Risk of "rabbit holes" where AI gets stuck repeating the same mistakes

**Solution:**
- **Automated phase transitions**: Architect → Executor → Validator
- **Strict validation gates**: No commit without passing validation
- **Rabbit hole protection**: Automatic error escalation after 2 failed attempts

---

## 🔄 Core Protocol

### Phase 1: ARCHITECT (Planning)
**Role:** Create comprehensive technical specifications

**Responsibilities:**
1. Read project context (`docs/TECH_STACK.md`, existing code)
2. Analyze requirements and constraints
3. Create detailed implementation plan (`docs/PLAN.md`)
4. Define file structure and technology choices
5. **STRICT RULE:** Write NO code in this phase

**Output:**
```markdown
# Implementation Plan: [Feature Name]

## Architecture
[Component structure, data flow, state management]

## File Structure
[List of new/modified files]

## Technology Choices
[Justified tech stack decisions]

## Implementation Phases
1. [Phase 1 steps]
2. [Phase 2 steps]
3. [Phase 3 steps]
```

**Success Criteria:**
- Plan covers all requirements
- Technology choices justified
- File structure defined
- No code written yet

---

### Phase 2: EXECUTOR (Implementation)
**Role:** Implement code exactly according to plan

**Responsibilities:**
1. Read `docs/PLAN.md` created by Architect
2. Follow implementation steps exactly
3. Use only approved technologies from `docs/TECH_STACK.md`
4. Write clean, tested code
5. **Handle errors with Rabbit Hole detection**

**Rabbit Hole Rules:**
```yaml
If same error occurs 2+ times:
  STOP immediately
  Document error in docs/DEBUG_REPORT.md
  Escalate: "⛔ RABBIT HOLE: Requires human intervention"
```

**Output:**
- Complete implementation of planned features
- Unit tests passing
- Code follows project conventions
- No console errors or warnings

---

### Phase 3: VALIDATOR (Quality Assurance)
**Role:** Perform strict validation before allowing commits

**Responsibilities:**
1. **Technology Stack Validation:**
   ```yaml
   ❌ FAIL if found: Python imports, Float types, any types
   ✅ PASS only if: Approved tech stack, strict types, clean code
   ```

2. **Code Quality Validation:**
   ```yaml
   ❌ FAIL if: Missing tests, poor coverage, security issues
   ✅ PASS only if: >80% coverage, security audit passed, performance OK
   ```

3. **Architecture Validation:**
   ```yaml
   ❌ FAIL if: Deviates from PLAN.md, wrong patterns, poor structure
   ✅ PASS only if: Matches specification, follows best practices
   ```

**Output:**
- `✅ VALIDATION PASSED` + Git commit
- OR `⛔ VALIDATION FAILED` + Return to EXECUTOR

---

## 🛠️ Setup Instructions

### 1. Create Project Structure
```bash
# Copy from AIRules templates
mkdir -p docs/
cp templates/docs/TECH_STACK.md docs/
cp templates/docs/PLAN.md docs/
cp templates/docs/VALIDATION_CHECKLIST.md docs/

# Create roles directory
mkdir -p .clinerules/roles/
```

### 2. Define Your Technology Stack
Edit `docs/TECH_STACK.md`:
```yaml
# Strict Technology Constraints
Language: TypeScript (NO JavaScript)
Framework: React/Next.js (NO Vue/Angular)
Database: PostgreSQL (NO MongoDB)
State: Zustand (NO Redux)

# Forbidden Technologies
❌ Python, Flask, Django
❌ Float/Double (use Decimal/BigInt)
❌ any types, implicit any
❌ jQuery, Bootstrap
```

### 3. Configure Automated Protocol
Create `.clinerules/auto-protocol.md`:
```markdown
# Automated Development Protocol

## Phase Transitions
1. ARCHITECT creates PLAN.md → Auto-transition to EXECUTOR
2. EXECUTOR implements code → Auto-transition to VALIDATOR
3. VALIDATOR passes → Auto-commit + success message
3. VALIDATOR fails → Return to EXECUTOR with error details

## Quality Gates
- No commit without validation
- Rabbit hole detection after 2 errors
- Strict technology compliance
```

---

## 🎨 Example Workflow

### Task: Create User Registration API

**Phase 1 - ARCHITECT:**
```
Reading project context...
Analyzing requirements...
Creating implementation plan...

✅ PLAN.md created:
# User Registration API

## Endpoints
POST /api/auth/register
POST /api/auth/login

## Tech Stack
- Next.js API routes
- Zod validation
- Prisma ORM
- bcrypt hashing

## File Structure
src/pages/api/auth/
├── register.ts
├── login.ts
└── types.ts

## Implementation Steps
1. Create Zod schemas
2. Implement register endpoint
3. Implement login endpoint
4. Add error handling
```

**Auto-transition to Phase 2...**

**Phase 2 - EXECUTOR:**
```
Reading PLAN.md...
Implementing according to specification...

✅ Created src/pages/api/auth/register.ts
✅ Created src/pages/api/auth/login.ts
✅ Created src/pages/api/auth/types.ts
✅ All tests passing
✅ Code follows conventions
```

**Auto-transition to Phase 3...**

**Phase 3 - VALIDATOR:**
```
Running validation checks...

✅ Technology Stack: TypeScript, Next.js, Prisma - APPROVED
✅ Type Safety: No any types, strict validation - PASSED
✅ Code Quality: Tests passing, coverage >80% - PASSED
✅ Architecture: Matches PLAN.md specification - PASSED
✅ Security: Password hashing, input validation - PASSED

✅ VALIDATION PASSED

Committing changes...
git add .
git commit -m "feat: Add user registration API"
```

---

## 🔒 Quality Assurance System

### Validation Checklists

**Technology Compliance:**
- [ ] Only approved languages/frameworks
- [ ] No forbidden libraries
- [ ] Version constraints followed
- [ ] No deprecated patterns

**Code Quality:**
- [ ] TypeScript strict mode
- [ ] No any/implicit types
- [ ] Comprehensive error handling
- [ ] Clean, readable code

**Architecture Compliance:**
- [ ] Follows PLAN.md structure
- [ ] Proper separation of concerns
- [ ] Scalable patterns used
- [ ] No technical debt added

**Testing Requirements:**
- [ ] Unit tests for all functions
- [ ] Integration tests for APIs
- [ ] 80%+ code coverage
- [ ] Edge cases covered

---

## 🚨 Error Handling & Recovery

### Rabbit Hole Detection
```yaml
Trigger: Same error repeated 2+ times

Response:
1. STOP implementation
2. Document in docs/DEBUG_REPORT.md
3. Escalate: "⛔ RABBIT HOLE: Human intervention required"

Example:
Attempt 1: "TypeError: Cannot read property"
Attempt 2: "TypeError: Cannot read property"
Attempt 3: "TypeError: Cannot read property"

→ RABBIT HOLE DETECTED
→ Require human help
```

### Validation Failures
```yaml
Trigger: Code fails validation checks

Response:
1. Return to EXECUTOR phase
2. Provide specific error details
3. Allow one retry attempt

Example:
⛔ VALIDATION FAILED
Reason: Using Float instead of Decimal for money
Action: Replace Float with Decimal in all financial calculations
```

### Escalation Protocol
```yaml
Priority 1 (Immediate): Security vulnerabilities
Priority 2 (High): Breaking API changes
Priority 3 (Medium): Performance issues
Priority 4 (Low): Code style violations
```

---

## 📊 Success Metrics

### Quality Metrics
- **0 forbidden technologies** used
- **100% type safety** (no any types)
- **80%+ test coverage**
- **0 critical security issues**

### Process Metrics
- **Automated transitions**: 95%+ of phase changes
- **First-time validation pass**: 80%+ of implementations
- **Rabbit hole incidents**: <5% of tasks

### Developer Experience
- **Setup time**: <10 minutes for new projects
- **Error recovery**: <5 minutes for non-rabbit-hole issues
- **Validation feedback**: Clear, actionable error messages

---

## 🔧 Integration with AIRules

### Combining Approaches

**Use Multi-Agent Protocol for:**
- Complex features requiring careful planning
- High-stakes implementations (payments, security)
- Team projects needing consistency
- Critical business logic

**Use Flexible Templates for:**
- Quick prototypes and MVPs
- Exploratory development
- Simple UI components
- Personal projects

### Hybrid Approach
```yaml
# For complex projects
1. Use multi-agent protocol for core business logic
2. Use flexible templates for UI components
3. Combine both approaches in single project

# Project structure
.clinerules/          # Strict protocol for API/backend
templates/            # Flexible templates for UI
docs/
  ├── TECH_STACK.md   # Shared constraints
  ├── PLAN.md         # Multi-agent plans
  └── INSTRUCTIONS.md # Template-based roles
```

---

## 🎯 When to Use This Protocol

### ✅ Recommended For
- **Enterprise applications** requiring high quality
- **Payment systems** needing strict validation
- **APIs and backend services** with complex logic
- **Team development** needing consistency
- **Critical features** where errors are expensive

### ❌ Not Recommended For
- **Rapid prototyping** (too much overhead)
- **Simple UI components** (overkill)
- **Personal projects** (too strict)
- **Exploratory development** (limits flexibility)

### 🤝 Sweet Spot
- Medium to large features
- 2-4 hour implementation time
- Multiple files/components
- Business-critical functionality

---

## 📚 Related Resources

- `templates/docs/TECH_STACK.md` - Technology constraints
- `templates/docs/PLAN.md` - Implementation planning
- `templates/docs/VALIDATION_CHECKLIST.md` - Quality gates
- `AI_BEST_PRACTICES.md` - General development practices

---

## 🚀 Quick Start Template

Copy this to your project to get started:

```bash
# 1. Set up structure
mkdir -p .clinerules/roles/ docs/

# 2. Copy templates
cp airules/templates/docs/TECH_STACK.md docs/
cp airules/templates/docs/PLAN.md docs/

# 3. Create protocol file
cat > .clinerules/auto-protocol.md << 'EOF'
# Automated Development Protocol

## Phase 1: ARCHITECT
Create PLAN.md, define architecture, NO CODE

## Phase 2: EXECUTOR
Implement exactly per PLAN.md, handle errors

## Phase 3: VALIDATOR
Strict validation, commit only if passed

## Rules
- Automated transitions between phases
- Rabbit hole detection after 2 errors
- Strict technology compliance
EOF

# 4. Start development
echo "Ready for automated development!"
```

---

**This protocol transforms AI from a coding assistant into a reliable development automation system.** 🚀
