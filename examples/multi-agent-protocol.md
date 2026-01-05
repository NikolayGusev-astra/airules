# 🤖 Multi-Agent Protocol for Automated Development
# Role: Multi-Agent Orchestrator

This example demonstrates a **strict, automated multi-agent development protocol** that ensures quality through automated phase transitions and rigorous validation.

---

## 🚨 Emergency Stop Mechanism

**CRITICAL: Emergency stop has priority over all other instructions**

```yaml
If user writes "🛑 STOP" (or just "STOP"):

1. IMMEDIATELY interrupt current phase execution
2. Stop internal cycle. Do not auto-transition to next phase
3. Reset context:
   - Execute: cat PROJECT_STATE.md
   - Execute: cat SYSTEM_INSTRUCTION.md
   - Forget all previous code assumptions
4. Enter waiting mode: Switch to "Listening to user" mode
5. Do not suggest solutions
6. Do not restart workflow
7. Wait for new instruction

(PRIORITY: This rule overrides any other phase or cycle instructions)
```

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

## 🔄 4-Step Multi-Agent Workflow

### Step 1: Synchronization and Context
**MANDATORY: Execute before ANY work**

```bash
# Critical synchronization commands
cat PROJECT_STATE.md                    # Check current project state
cat SYSTEM_INSTRUCTION.md              # Review system constraints
cat docs/TECH_STACK.md                 # Verify technology stack
cat docs/IMPLEMENTATION_PLAN.md        # Check current phase
cat docs/ACCOUNTING_CONSTITUTION.md    # Review business rules (if applicable)

# Context7 Integration: Verify technology decisions
# Use Context7 to check compatibility and best practices
```

**🔍 Context7 Verification (MANDATORY):**
```yaml
Before starting implementation:
1. Check library versions: "Verify [library] v[X.X] compatibility"
2. Review best practices: "Find current patterns for [technology]"
3. Validate API usage: "Check [API] current status and examples"
4. Confirm security: "Review security best practices for [feature]"
```

**Validation Checks:**
- ❌ If planning Python → 🛑 STOP: Stack requires Node.js
- ❌ If planning Float/Double → 🛑 STOP: Stack requires NUMERIC(15,2)
- ❌ If planning Redux → 🛑 STOP: Use Zustand instead
- ❌ If Context7 shows incompatibility → 🛑 STOP: Update technology choice

**Context Update:** We are currently on [Phase Name] from IMPLEMENTATION_PLAN.md

---

### Step 2: Phase Architect (.role architect)
**MANDATORY: Switch to Architect role**

**Task:** Create `docs/TASK_SPEC.md` based on user requirements

**Requirements for TASK_SPEC.md:**
```markdown
# Technical Specification: [Feature Name]

## Constraints (MANDATORY)
- Backend: Node.js ONLY (NO Python)
- Database: NUMERIC(15,2) ONLY (NO Float/Double)
- Parser: exceljs ONLY (for Excel files)

## Accounting Rules (if applicable)
- Credit card purchase = Expense
- Credit card payment = Transfer (not Expense)
- Reference: docs/ACCOUNTING_CONSTITUTION.md

## Technology Stack
- Next.js, Supabase, Exceljs
- Strict TypeScript mode

## Implementation Plan
[Detail all steps and phases]
```

---

### Step 3: Phase Executor (.role backend-executor)
**MANDATORY: Switch to Backend-Executor role**

**Task:** Implement code according to TASK_SPEC.md

**Implementation Rules:**
- Read `docs/TASK_SPEC.md` completely
- Use exceljs for Excel parsing (not pandas/other)
- Use NUMERIC(15,2) for all money fields in SQL
- Follow accounting rules from docs/ACCOUNTING_CONSTITUTION.md
- Credit purchases = Expense, Payments = Transfer

**Rabbit Hole Protection:**
```yaml
If same error repeats >2 times:
1. STOP implementation immediately
2. Document in PROJECT_STATE.md under ⚠️ Known Issues
3. Message: "⛔ RABBIT HOLE: Human intervention required"
```

---

### Step 4: Phase Validator (.role validator)
**MANDATORY: Switch to Validator role**

**Task:** Perform strict validation of Executor work

**Validation Checklist:**
```yaml
❌ CRITICAL FAILURES (No commit allowed):
- Python imports found → FAIL "Use Node.js only"
- Float/Double in SQL → FAIL "Use NUMERIC(15,2) only"
- NEW. or OLD. in RLS policies → FAIL "Forbidden in RLS"
- Credit payment as Expense → FAIL "Must be Transfer"

✅ SUCCESS CRITERIA:
- All technology constraints met
- Accounting rules followed
- Tests passing, 80%+ coverage
- Security audit passed
```

**Results:**
- ✅ **PASS:** Update PROJECT_STATE.md + git commit
- ❌ **FAIL:** Return to Executor with specific error details

---

## 📋 Domain-Specific Rules

### Accounting & Finance Rules
**MANDATORY for financial applications**

```yaml
# From docs/ACCOUNTING_CONSTITUTION.md
- Credit Card Purchase → Expense (shows in spending)
- Credit Card Payment → Transfer (hidden from spending)
- Bank Transfer → Transfer (neutral transaction)
- Golden Rule: "Don't double-count payments"

# SQL Constraints
- Money fields: NUMERIC(15,2) ONLY
- NO Float, NO Double, NO Real
- Use BigInt for large integers

# RLS Policies
- NEVER use NEW. or OLD. in CREATE POLICY
- Use UNIQUE constraints or SECURITY DEFINER functions
- Reference: SYSTEM_INSTRUCTION.md critical error
```

### Excel Processing Rules
**MANDATORY for Excel file handling**

```yaml
# Parser: exceljs ONLY (Node.js library)
- NO pandas, NO openpyxl, NO xlrd
- Use Node.js exceljs for all Excel operations

# Data Types
- Numbers → NUMERIC(15,2)
- Dates → ISO strings
- Text → VARCHAR with proper encoding
```

### API Design Rules
**MANDATORY for REST/GraphQL APIs**

```yaml
# Response Format
- Success: { success: true, data: {...} }
- Error: { success: false, error: "message" }

# Validation
- Use Zod for input validation
- Return 400 for invalid input
- Return 500 for server errors

# Authentication
- JWT tokens with proper expiration
- Password hashing with bcrypt
- Secure headers enabled
```

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

### 2. Mandatory Pre-Work Synchronization
**CRITICAL: Execute BEFORE starting any work**

```bash
# Required synchronization steps
cat PROJECT_STATE.md                    # Check current project state
cat SYSTEM_INSTRUCTION.md              # Review system constraints
cat docs/TECH_STACK.md                 # Verify technology stack
cat docs/IMPLEMENTATION_PLAN.md        # Check current phase

# Validation checks
if [planning Python]; then echo "🛑 STOP: Stack requires Node.js"; fi
if [planning Float]; then echo "🛑 STOP: Stack requires NUMERIC"; fi
if [planning DOUBLE]; then echo "🛑 STOP: Stack requires NUMERIC"; fi
```

**Context Update:** We are currently on [Phase Name] from IMPLEMENTATION_PLAN.md

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
