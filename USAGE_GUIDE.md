# CLAUDE.MD Usage Guide

## Purpose

The `claude.md` file serves as a comprehensive context document for Claude to understand your project quickly and deeply. It acts as an "onboarding guide" that enables Claude to:

- Write code that matches your project's conventions
- Make architectural decisions aligned with your patterns
- Understand domain-specific logic and constraints
- Generate appropriate tests and documentation
- Debug issues with full context of your system

## How to Use This Template

### ⚠️ CRITICAL: Integration with Best Practices

Your `claude.md` file works in conjunction with two mandatory reference documents:

- **bestpractices.md** - Universal engineering principles and patterns
- **antipatterns.md** - Common mistakes to avoid

**These are NOT optional.** Every code change Claude makes should be validated against all three documents:

1. **bestpractices.md** - Is this following established engineering principles?
2. **antipatterns.md** - Am I avoiding known mistakes?
3. **claude.md** - Does this match the project's specific conventions?

Think of it as a three-layer validation system:
```
User Request
    ↓
Claude checks bestpractices.md (universal principles)
    ↓
Claude checks antipatterns.md (what NOT to do)
    ↓
Claude checks claude.md (project-specific conventions)
    ↓
Generate Code
```

**Always include this in your prompts:**
```
"Following bestpractices.md, antipatterns.md, and claude.md, 
create a new user authentication service."

"Check this code against bestpractices.md and antipatterns.md, 
then verify it matches our claude.md conventions."
```

### 1. Initial Setup (15-30 minutes)

**Step 1:** Copy the template to your project root
```bash
cp claude.md /path/to/your/project/
```

**Step 2:** Fill in the basic sections first:
- Project Overview
- Project Structure  
- Development Environment
- Code Standards & Conventions

**Step 3:** Add language/framework-specific details:
- Dependencies
- Testing setup
- Build/run commands

### 2. Incremental Enhancement

You don't need to complete every section immediately. Fill in sections as they become relevant:

**As you start development:**
- Architecture & Design Patterns
- Common Tasks & Workflows

**When working with external services:**
- API & Integrations
- Database & Data

**Before production:**
- Security Considerations
- Deployment
- Performance Considerations

### 3. Keep It Updated

Treat `claude.md` as living documentation:
- Update when you change conventions
- Add new patterns as they emerge
- Document solutions to common problems
- Refine based on how Claude interprets it

## Customization Tips

### Minimal Setup (Quick Start)

If you want to get started quickly, focus on these critical sections:

```markdown
## Project Overview
[What does this project do?]

## Code Standards & Conventions
[How do you name things and format code?]

## Project Structure
[Where is everything?]

## Common Tasks & Workflows
[How to add features, run tests, etc.]
```

### Language-Specific Templates

You may want to create variants for different languages:

**Python Projects - Add:**
- Virtual environment setup
- requirements.txt vs pyproject.toml
- Import organization preferences
- Type hinting requirements

**JavaScript/TypeScript - Add:**
- package.json scripts explanation
- Module system (ESM vs CommonJS)
- Build tool configuration
- TypeScript compiler options

**Java/Kotlin - Add:**
- Build tool (Maven/Gradle)
- Package structure conventions
- Annotation usage guidelines
- Dependency injection approach

**Go - Add:**
- Module organization
- Interface usage patterns
- Error handling conventions
- Testing with table-driven tests

### Framework-Specific Additions

**React:**
- Component structure (functional vs class)
- State management approach
- Hook usage guidelines
- Styling methodology

**Django:**
- App organization
- Model design patterns
- View/serializer conventions
- URL routing structure

**Spring Boot:**
- Annotation preferences
- Bean configuration style
- REST controller patterns
- Service layer architecture

## Tips for Working with Claude

### 1. Reference All Three Documents in Your Prompts

**Always mention the full context:**

```
"Following bestpractices.md, antipatterns.md, and claude.md conventions, 
create a new user service with JWT authentication."

"Review this code against:
1. bestpractices.md for security and architecture patterns
2. antipatterns.md to ensure no N+1 queries or God objects
3. claude.md for our project's naming conventions"

"Update the payment module according to bestpractices.md → Security Practices 
and claude.md → API Standards, while avoiding antipatterns.md → Security Anti-Patterns"
```

### 2. Provide Context Selectively

If Claude is working on a specific area, you can point to relevant sections:

```
"See the 'API & Integrations' section of claude.md. 
Now create an endpoint for user registration that follows those patterns."
```

### 3. Iterate Based on Claude's Output

If Claude consistently misinterprets something, your claude.md needs clarification:
- Add examples for ambiguous conventions
- Be more explicit about preferences
- Include anti-patterns to avoid

### 4. Use for Onboarding New Developers

Your `claude.md` can serve double duty:
- Helps Claude understand your project
- Helps human developers too
- Keeps conventions documented in one place

## Section-by-Section Guidance

### Project Overview
**Keep it brief** - 2-3 sentences on purpose, not implementation details

### Code Standards & Conventions  
**Be specific** - Don't say "use good naming." Say "Functions are camelCase, classes are PascalCase"

### Architecture & Design Patterns
**Show the patterns** - Brief examples are more helpful than long explanations

### Common Tasks & Workflows
**Write step-by-step** - Treat this like instructions for a new teammate

### When Working with Claude
**Be honest about preferences** - If you hate comments, say so. If you want verbose documentation, specify that.

## Advanced Usage

### Multiple claude.md Files

For large projects, consider:
- `/claude.md` - Root level overview
- `/frontend/claude.md` - Frontend-specific details  
- `/backend/claude.md` - Backend-specific details

### Integration with CI/CD

You can use claude.md to enforce standards:
```bash
# In CI, check if code follows claude.md conventions
claude-check --config claude.md --path src/
```

### Templates by Project Type

Consider maintaining templates for different project types:
- `claude-web-app.md`
- `claude-cli-tool.md`
- `claude-library.md`
- `claude-api-service.md`

## Common Pitfalls to Avoid

### ❌ Don't Make It Too Long
If it's more than 500 lines, break it up or remove redundancy.

### ❌ Don't Duplicate Existing Docs
Link to external documentation instead of copying it.

### ❌ Don't Over-Specify
Leave room for Claude's judgment on implementation details.

### ❌ Don't Let It Get Stale
Outdated information is worse than no information.

### ✅ Do Keep It Actionable
Every section should help Claude make better decisions.

### ✅ Do Use Examples
Show don't tell - code examples clarify conventions.

### ✅ Do Update Regularly
Make it part of your code review process.

## Example Workflow

Here's how a typical interaction might work:

**Developer:** "Claude, I'm starting a new feature for user authentication. Check claude.md and create the necessary components following our project conventions."

**Claude reads claude.md and sees:**
- Project uses TypeScript with React
- Components go in `src/components/`
- We use functional components with hooks
- Authentication uses JWT tokens
- Testing requires minimum 80% coverage
- We follow the Container/Presenter pattern

**Claude generates:**
- `src/components/auth/LoginContainer.tsx` - Logic container
- `src/components/auth/LoginForm.tsx` - Presentational component
- `src/services/authService.ts` - API interaction
- `tests/components/auth/LoginForm.test.tsx` - Unit tests
- All following TypeScript conventions, naming patterns, and architectural style specified in claude.md

## Maintenance Schedule

**Weekly:** Review for accuracy if actively developing
**Monthly:** Check for outdated information
**Per Feature:** Update relevant sections when patterns change
**Per Release:** Update version-specific details

## Questions to Ask Yourself

When maintaining your claude.md, ask:

1. Would a new developer understand the project from this?
2. Does this explain WHY not just WHAT?
3. Are there recurring questions Claude asks that should be answered here?
4. Is this still accurate after recent changes?
5. Can I delete anything without losing important information?

## Getting Help

If you're unsure how to fill out a section, ask Claude:

```
"Based on our conversation and the code you've seen, 
help me write the 'Architecture & Design Patterns' 
section of our claude.md file."
```

Claude can help you articulate your own conventions by observing your codebase!

---

**Remember:** claude.md is a tool to make your collaboration with Claude more effective. Start simple, iterate often, and keep it relevant to your actual needs.
