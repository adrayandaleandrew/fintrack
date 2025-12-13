# Software Engineering Best Practices

A comprehensive guide to professional software development from a senior engineering perspective. These practices apply across languages, frameworks, and domains.

---

## Table of Contents

1. [Code Quality & Craftsmanship](#code-quality--craftsmanship)
2. [Architecture & Design](#architecture--design)
3. [Testing Strategy](#testing-strategy)
4. [Security Practices](#security-practices)
5. [Performance & Scalability](#performance--scalability)
6. [Database & Data Management](#database--data-management)
7. [API Design](#api-design)
8. [Version Control & Collaboration](#version-control--collaboration)
9. [DevOps & Deployment](#devops--deployment)
10. [Monitoring & Observability](#monitoring--observability)
11. [Documentation](#documentation)
12. [Team & Process](#team--process)

---

## Code Quality & Craftsmanship

### Core Principles

**SOLID Principles**
- **Single Responsibility**: Each class/function does one thing well
- **Open/Closed**: Open for extension, closed for modification
- **Liskov Substitution**: Subtypes must be substitutable for their base types
- **Interface Segregation**: Many specific interfaces beat one general interface
- **Dependency Inversion**: Depend on abstractions, not concretions

**DRY (Don't Repeat Yourself)**
- Abstract common patterns into reusable functions/classes
- But don't over-abstract - three instances before extraction
- Duplication is better than the wrong abstraction

**YAGNI (You Aren't Gonna Need It)**
- Build what you need now, not what you might need later
- Premature generalization is as bad as premature optimization
- Requirements will change - over-engineering is waste

**KISS (Keep It Simple, Stupid)**
- Simple solutions are easier to understand, test, and maintain
- Complexity should be justified by clear benefits
- If you can't explain it simply, you don't understand it well enough

### Clean Code Practices

**Naming**
```python
# Bad
def calc(d, r):
    return d * r * 0.01

# Good
def calculate_discount(price: Decimal, discount_rate: Decimal) -> Decimal:
    """Calculate discounted price based on rate."""
    return price * discount_rate * Decimal('0.01')
```

**Function Size**
- Functions should do one thing
- Aim for < 20 lines per function
- Maximum 50 lines - if longer, split it
- Maximum 3-4 levels of indentation

**Meaningful Comments**
```python
# Bad - Obvious comment
x = x + 1  # Increment x

# Good - Explains why
x = x + 1  # Account for 0-based indexing in API response

# Better - Self-documenting code
current_index = current_index + 1  # No comment needed
```

**Error Handling**
```python
# Bad - Swallowing errors
try:
    risky_operation()
except:
    pass

# Good - Explicit handling
try:
    risky_operation()
except SpecificException as e:
    logger.error(f"Operation failed: {e}", extra={'context': data})
    raise ApplicationError("User-friendly message") from e
```

**Early Returns**
```python
# Bad - Nested conditions
def process_user(user):
    if user is not None:
        if user.is_active:
            if user.has_permission:
                return perform_action(user)
    return None

# Good - Early returns
def process_user(user):
    if user is None:
        return None
    if not user.is_active:
        return None
    if not user.has_permission:
        return None
    
    return perform_action(user)
```

### Code Organization

**File Structure**
- One class per file (with exceptions for tightly coupled helper classes)
- Group related files into modules/packages
- Keep file length reasonable (< 500 lines)

**Import Organization**
1. Standard library
2. Third-party packages
3. Internal packages
4. Relative imports
5. Type imports (if separate)

**Dependency Management**
- Pin exact versions in production
- Use lock files (package-lock.json, poetry.lock, etc.)
- Regularly update dependencies for security
- Document why you're using each major dependency

---

## Architecture & Design

### Architectural Patterns

**Layered Architecture**
```
Presentation Layer (UI, API)
    ↓
Business Logic Layer (Services, Domain)
    ↓
Data Access Layer (Repositories, ORM)
    ↓
Database
```

**Benefits:**
- Clear separation of concerns
- Each layer can evolve independently
- Easier to test
- Team members can work on different layers

**When to Use:**
- Most business applications
- When team needs clear boundaries
- When different layers may scale differently

**Hexagonal/Ports & Adapters**
```
Core Domain (Business Logic)
    ↔ Ports (Interfaces)
        ↔ Adapters (Implementations)
            ↔ External Systems
```

**Benefits:**
- Domain logic isolated from infrastructure
- Easy to swap implementations
- Highly testable

**When to Use:**
- Domain-rich applications
- When you need flexibility to change infrastructure
- When business logic complexity justifies the overhead

**Microservices**
- Independent deployable services
- Own their data
- Communicate via APIs or message queues

**When to Use:**
- Large teams working independently
- Different scaling requirements per service
- Need for technology diversity
- Only when you have operational maturity

**When NOT to Use:**
- Small teams (< 10 developers)
- Unproven product/market fit
- Lack of DevOps maturity
- Network latency is critical

### Design Patterns (Use Judiciously)

**Creational Patterns**
- **Factory**: When object creation is complex
- **Builder**: For objects with many optional parameters
- **Singleton**: Rarely - use dependency injection instead

**Structural Patterns**
- **Adapter**: To integrate third-party code
- **Decorator**: To add behavior without inheritance
- **Facade**: To simplify complex subsystems

**Behavioral Patterns**
- **Strategy**: For interchangeable algorithms
- **Observer**: For event-driven systems
- **Command**: For undo/redo or queuing operations

**Pattern Anti-Pattern**
Don't force patterns where they don't fit. Simple solutions beat complex patterns.

### Domain-Driven Design (DDD)

**Core Concepts**
- **Entities**: Objects with identity (User, Order)
- **Value Objects**: Objects without identity (Email, Money)
- **Aggregates**: Consistency boundaries (Order + OrderItems)
- **Repositories**: Abstract data access
- **Domain Events**: Express business occurrences

**Bounded Contexts**
- Define clear boundaries between subsystems
- Each context has its own models
- Shared Kernel or Anti-Corruption Layer for integration

**When to Use DDD:**
- Complex business domains
- Long-lived applications
- When business experts are available
- Team is willing to invest in domain modeling

### Separation of Concerns

**Vertical Slicing**
Organize by feature, not technical layer:
```
user-management/
├── user-api.ts
├── user-service.ts
├── user-repository.ts
├── user-model.ts
└── user-tests.ts
```

**Benefits:**
- Features are cohesive
- Easier to understand complete flow
- Easier to delete features
- Reduces coupling between unrelated features

### API-First Design

- Design APIs before implementation
- Use OpenAPI/Swagger for REST
- Use Protocol Buffers for gRPC
- Treat APIs as contracts with consumers
- Version APIs explicitly
- Never break backwards compatibility

---

## Testing Strategy

### Testing Pyramid

```
        /\
       /E2E\      Few, slow, expensive
      /------\
     /Integration\ Some, moderate cost
    /------------\
   /  Unit Tests  \ Many, fast, cheap
  /----------------\
```

### Unit Tests (70-80% of tests)

**Characteristics:**
- Test single units in isolation
- Fast (< 1ms per test)
- No I/O, no network, no database
- Use mocks/stubs for dependencies

**Example:**
```python
def test_calculate_discount():
    # Arrange
    price = Decimal('100.00')
    discount_rate = Decimal('10')
    
    # Act
    result = calculate_discount(price, discount_rate)
    
    # Assert
    assert result == Decimal('10.00')
```

**Best Practices:**
- One logical assertion per test
- Test behavior, not implementation
- Use descriptive test names: `test_user_creation_with_duplicate_email_raises_error`
- Follow AAA pattern: Arrange, Act, Assert
- Keep tests independent - no shared state

### Integration Tests (15-25% of tests)

**Characteristics:**
- Test component interactions
- Use real dependencies (database, APIs)
- Slower than unit tests
- Test realistic scenarios

**Example:**
```python
def test_user_registration_flow(db_session):
    # Arrange
    user_data = {"email": "test@example.com", "password": "secure123"}
    
    # Act
    user = user_service.register(user_data, db_session)
    
    # Assert
    assert user.id is not None
    assert db_session.query(User).filter_by(email=user_data["email"]).count() == 1
```

### E2E Tests (5-10% of tests)

**Characteristics:**
- Test entire user workflows
- Use real UI/API
- Slowest tests
- Test critical paths only

**When to Write:**
- User authentication flows
- Payment processing
- Critical business workflows
- Regulatory requirements

### Test-Driven Development (TDD)

**Red-Green-Refactor:**
1. **Red**: Write failing test
2. **Green**: Write minimal code to pass
3. **Refactor**: Improve code quality

**Benefits:**
- Better design (testable code is good code)
- Fewer defects
- Living documentation
- Confidence to refactor

**When to Use:**
- Complex business logic
- Critical functionality
- When requirements are clear
- When learning new domains

### Test Coverage

**Target:**
- Overall: 80%+ coverage
- Critical paths: 95%+ coverage
- New code: 90%+ coverage

**Important:**
- Coverage is necessary but not sufficient
- 100% coverage ≠ bug-free code
- Focus on meaningful assertions
- Test edge cases and error paths

### Testing Best Practices

**Don't Test:**
- Framework code (already tested)
- Trivial getters/setters
- Third-party libraries

**Do Test:**
- Business logic
- Edge cases and error conditions
- Integration points
- Data transformations

**Test Data:**
- Use factories/builders for test data
- Keep test data minimal and focused
- Use realistic data for integration tests
- Separate test data from production data

---

## Security Practices

### Security Mindset

**Assume Breach:**
- Design systems assuming they will be compromised
- Minimize blast radius
- Implement defense in depth
- Plan incident response

**Principle of Least Privilege:**
- Grant minimum necessary permissions
- Time-bound access when possible
- Regularly audit permissions
- Revoke unused access

### Authentication & Authorization

**Authentication:**
```python
# Bad - Storing passwords in plain text
user.password = request.password

# Good - Hash with salt
user.password_hash = bcrypt.hashpw(
    request.password.encode('utf-8'),
    bcrypt.gensalt(rounds=12)
)
```

**Password Requirements:**
- Minimum 12 characters
- No maximum length (within reason)
- Don't require special characters (they reduce entropy)
- Use password strength meters
- Support passphrases
- Implement rate limiting

**Multi-Factor Authentication:**
- Required for admin accounts
- Strongly encouraged for all users
- Use TOTP (Time-based One-Time Password)
- Support hardware keys (FIDO2/WebAuthn)

**Session Management:**
- Use secure, httpOnly cookies
- Implement session timeouts
- Regenerate session IDs after authentication
- Implement logout on all devices

**JWT Tokens:**
```python
# Good JWT practices
{
    "iss": "your-app",
    "sub": "user-id",
    "iat": 1516239022,
    "exp": 1516239922,  # Short expiration (15-30 min)
    "roles": ["user"]   # Minimal claims
}
```

- Short expiration times
- Refresh tokens for long-lived sessions
- Store sensitive data server-side, not in JWT
- Validate all claims

### Input Validation

**Never Trust User Input:**
```python
# Bad - SQL Injection vulnerability
query = f"SELECT * FROM users WHERE email = '{email}'"

# Good - Parameterized queries
query = "SELECT * FROM users WHERE email = ?"
cursor.execute(query, (email,))
```

**Validation Strategy:**
- Validate on the server (client validation is UX, not security)
- Use allowlists, not denylists
- Validate data type, format, length, and range
- Sanitize output (context-specific escaping)

**Common Vulnerabilities:**
- **SQL Injection**: Use ORMs or parameterized queries
- **XSS**: Escape output, use CSP headers
- **CSRF**: Use CSRF tokens for state-changing operations
- **Command Injection**: Never pass user input to shell commands
- **Path Traversal**: Validate and sanitize file paths

### Data Protection

**Encryption:**
- Encrypt data at rest (database encryption, disk encryption)
- Encrypt data in transit (TLS 1.3+)
- Use authenticated encryption (AES-GCM)
- Never roll your own crypto

**Sensitive Data:**
```python
# Bad - Logging sensitive data
logger.info(f"User {user_id} paid with card {credit_card_number}")

# Good - Mask sensitive data
logger.info(f"User {user_id} paid with card ****{credit_card_number[-4:]}")
```

**PII (Personally Identifiable Information):**
- Minimize collection
- Document what you collect and why
- Implement data retention policies
- Enable user data export/deletion
- Comply with regulations (GDPR, CCPA, etc.)

**Secrets Management:**
- Never commit secrets to version control
- Use environment variables or secret managers
- Rotate secrets regularly
- Use different secrets per environment
- Audit secret access

### Security Headers

```
# Essential security headers
Strict-Transport-Security: max-age=31536000; includeSubDomains
X-Content-Type-Options: nosniff
X-Frame-Options: DENY
Content-Security-Policy: default-src 'self'
Permissions-Policy: geolocation=(), microphone=(), camera=()
```

### Dependency Security

- Regularly scan for vulnerabilities (Snyk, Dependabot, npm audit)
- Keep dependencies updated
- Review dependency licenses
- Minimize number of dependencies
- Pin exact versions in production

### Security Testing

- Regular penetration testing
- Automated security scanning in CI/CD
- Dependency vulnerability scanning
- SAST (Static Application Security Testing)
- DAST (Dynamic Application Security Testing)

---

## Performance & Scalability

### Performance Principles

**Measure First, Optimize Second:**
- Profile before optimizing
- Focus on bottlenecks (80/20 rule)
- Set performance budgets
- Monitor real-world performance

**Premature Optimization is the Root of All Evil:**
- Get it working first
- Get it right second
- Get it fast third
- But: Design for performance from the start

### Database Performance

**Indexing:**
```sql
-- Bad - Missing index on frequently queried column
SELECT * FROM users WHERE email = 'user@example.com';

-- Good - Index on email
CREATE INDEX idx_users_email ON users(email);
```

**Index Guidelines:**
- Index foreign keys
- Index columns in WHERE clauses
- Index columns in JOIN conditions
- Don't over-index (slows writes)
- Use composite indexes for multi-column queries
- Monitor index usage and remove unused indexes

**Query Optimization:**
```python
# Bad - N+1 query problem
users = User.query.all()
for user in users:
    print(user.profile.name)  # Separate query per user

# Good - Eager loading
users = User.query.options(joinedload(User.profile)).all()
for user in users:
    print(user.profile.name)  # Single query
```

**Pagination:**
```python
# Bad - Fetching all records
users = User.query.all()

# Good - Pagination
users = User.query.limit(20).offset(page * 20).all()

# Better - Cursor-based pagination for large datasets
users = User.query.filter(User.id > last_id).limit(20).all()
```

### Caching Strategy

**Cache Layers:**
1. **Browser Cache**: Static assets, HTTP caching headers
2. **CDN**: Global content distribution
3. **Application Cache**: Redis, Memcached
4. **Database Cache**: Query results, ORM cache
5. **Database**: Built-in caching

**Caching Patterns:**

**Cache-Aside (Lazy Loading):**
```python
def get_user(user_id):
    # Try cache first
    user = cache.get(f"user:{user_id}")
    if user:
        return user
    
    # Miss - fetch from DB
    user = db.query(User).get(user_id)
    cache.set(f"user:{user_id}", user, ttl=3600)
    return user
```

**Write-Through:**
```python
def update_user(user_id, data):
    # Update database
    user = db.query(User).get(user_id)
    user.update(data)
    db.commit()
    
    # Update cache
    cache.set(f"user:{user_id}", user, ttl=3600)
```

**Cache Invalidation:**
- Time-based expiration (TTL)
- Event-based invalidation
- Manual purging when data changes
- Cache stampede prevention (locking, probabilistic expiration)

### API Performance

**Response Time Targets:**
- < 100ms: Excellent
- < 200ms: Good
- < 500ms: Acceptable
- > 1s: Poor (investigate)

**Optimization Techniques:**
- Return only requested fields
- Implement pagination
- Use HTTP compression (gzip, brotli)
- Enable HTTP/2
- Use CDN for static content
- Implement rate limiting

**Async Processing:**
```python
# Bad - Slow synchronous operation
def process_order(order):
    validate_order(order)
    charge_payment(order)       # Slow
    send_confirmation_email()   # Slow
    update_inventory()
    return "Order processed"

# Good - Async for slow operations
def process_order(order):
    validate_order(order)
    task_queue.enqueue(charge_payment, order)
    task_queue.enqueue(send_confirmation_email, order)
    task_queue.enqueue(update_inventory, order)
    return "Order processing started"
```

### Scalability Patterns

**Horizontal Scaling:**
- Stateless application servers
- Load balancing
- Shared nothing architecture
- Distributed caching

**Vertical Scaling:**
- Increase CPU, RAM, disk
- Limited by hardware
- Easier but expensive
- Good for databases

**Database Scaling:**

**Read Replicas:**
```python
# Write to primary
primary_db.execute("INSERT INTO users ...")

# Read from replica
replica_db.execute("SELECT * FROM users ...")
```

**Sharding:**
- Partition data across multiple databases
- Shard by user_id, geography, or domain
- Complex but necessary for massive scale

**CQRS (Command Query Responsibility Segregation):**
- Separate read and write models
- Optimize each independently
- Use for complex domains

### Frontend Performance

**Critical Rendering Path:**
- Minimize critical resources
- Defer non-critical JavaScript
- Inline critical CSS
- Optimize images (WebP, lazy loading)

**Bundle Size:**
- Code splitting
- Tree shaking
- Lazy loading routes
- Remove unused dependencies

**Performance Budgets:**
- JavaScript: < 200KB (gzipped)
- CSS: < 50KB (gzipped)
- Images: Optimized and lazy loaded
- First Contentful Paint: < 1.8s
- Time to Interactive: < 3.8s

---

## Database & Data Management

### Database Design

**Normalization:**
- 1NF: Atomic values, no repeating groups
- 2NF: No partial dependencies
- 3NF: No transitive dependencies
- BCNF: Every determinant is a candidate key

**Denormalization:**
- Trade storage for query performance
- Use for read-heavy workloads
- Maintain consistency carefully
- Document denormalized fields

**Schema Design Principles:**
- Use meaningful names
- Consistent naming conventions
- Use appropriate data types
- Enforce constraints at database level
- Add foreign keys for referential integrity

### Migrations

**Best Practices:**
```python
# Bad - Destructive migration
def upgrade():
    op.drop_column('users', 'old_field')

# Good - Safe migration with rollback
def upgrade():
    op.add_column('users', sa.Column('new_field', sa.String()))
    # Copy data from old_field to new_field
    op.execute("UPDATE users SET new_field = old_field")

def downgrade():
    op.drop_column('users', 'new_field')
```

**Migration Guidelines:**
- Never edit old migrations
- Always provide rollback (downgrade)
- Test migrations on production-like data
- Make migrations backwards compatible
- Break large migrations into smaller steps
- Run migrations during low-traffic windows

### Data Integrity

**Constraints:**
```sql
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(255) NOT NULL UNIQUE,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    CONSTRAINT email_format CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}$')
);
```

**Transactions:**
```python
# Ensure atomicity
try:
    db.begin()
    user = create_user(data)
    profile = create_profile(user.id, profile_data)
    send_welcome_email(user)
    db.commit()
except Exception as e:
    db.rollback()
    raise
```

**ACID Properties:**
- **Atomicity**: All or nothing
- **Consistency**: Valid state transitions
- **Isolation**: Concurrent transactions don't interfere
- **Durability**: Committed data survives failures

### Backup & Recovery

**Backup Strategy:**
- Automated daily backups
- Test restore procedures regularly
- Keep multiple backup versions
- Store backups off-site
- Encrypt backups

**Recovery Time Objective (RTO):**
- Critical systems: < 1 hour
- Important systems: < 4 hours
- Normal systems: < 24 hours

**Recovery Point Objective (RPO):**
- Critical systems: < 5 minutes
- Important systems: < 1 hour
- Normal systems: < 24 hours

### Data Retention

**Retention Policies:**
- Define retention periods per data type
- Automated archival/deletion
- Comply with regulations
- Balance storage costs vs requirements

**Soft Deletes:**
```python
# Instead of hard delete
user.deleted_at = datetime.utcnow()

# Query only active records
users = User.query.filter(User.deleted_at.is_(None)).all()
```

---

## API Design

### REST API Best Practices

**Resource Naming:**
```
✅ Good
GET    /users              # List users
GET    /users/{id}         # Get user
POST   /users              # Create user
PUT    /users/{id}         # Update user (full)
PATCH  /users/{id}         # Update user (partial)
DELETE /users/{id}         # Delete user

❌ Bad
GET    /getUsers
POST   /createUser
GET    /user/delete/{id}
```

**HTTP Status Codes:**
- **200 OK**: Successful GET, PUT, PATCH
- **201 Created**: Successful POST
- **204 No Content**: Successful DELETE
- **400 Bad Request**: Invalid input
- **401 Unauthorized**: Authentication required
- **403 Forbidden**: Authenticated but not authorized
- **404 Not Found**: Resource doesn't exist
- **409 Conflict**: Resource conflict (e.g., duplicate)
- **422 Unprocessable Entity**: Validation errors
- **429 Too Many Requests**: Rate limit exceeded
- **500 Internal Server Error**: Server error
- **503 Service Unavailable**: Temporary outage

**Request/Response Format:**
```json
// Request
POST /api/v1/users
{
  "email": "user@example.com",
  "name": "John Doe"
}

// Success Response (201)
{
  "id": "123e4567-e89b-12d3-a456-426614174000",
  "email": "user@example.com",
  "name": "John Doe",
  "created_at": "2024-01-15T10:30:00Z"
}

// Error Response (422)
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid input data",
    "details": [
      {
        "field": "email",
        "message": "Email already exists"
      }
    ]
  }
}
```

### API Versioning

**URL Versioning (Recommended):**
```
/api/v1/users
/api/v2/users
```

**Header Versioning:**
```
Accept: application/vnd.company.v1+json
```

**Versioning Strategy:**
- Version major breaking changes
- Maintain at least 2 versions
- Deprecation warnings before removal
- Document migration guides

### Pagination

**Offset-Based (Simple):**
```
GET /users?page=2&limit=20
```

**Cursor-Based (Recommended for large datasets):**
```
GET /users?cursor=eyJpZCI6MTAwfQ&limit=20

Response:
{
  "data": [...],
  "next_cursor": "eyJpZCI6MTIwfQ",
  "has_more": true
}
```

### Filtering & Sorting

```
# Filtering
GET /users?status=active&role=admin

# Sorting
GET /users?sort=created_at&order=desc

# Multiple sorts
GET /users?sort=last_name,first_name

# Complex filtering
GET /products?price_min=10&price_max=100&category=electronics
```

### Rate Limiting

```python
# Return rate limit info in headers
X-RateLimit-Limit: 1000
X-RateLimit-Remaining: 950
X-RateLimit-Reset: 1640995200

# 429 response when exceeded
{
  "error": {
    "code": "RATE_LIMIT_EXCEEDED",
    "message": "Too many requests. Try again in 60 seconds.",
    "retry_after": 60
  }
}
```

### GraphQL Considerations

**When to Use:**
- Mobile apps needing flexible queries
- Many entity relationships
- Avoid over/under-fetching

**Best Practices:**
- Implement query depth limiting
- Use DataLoader for N+1 prevention
- Implement proper error handling
- Provide schema documentation
- Monitor query complexity

---

## Version Control & Collaboration

### Git Workflow

**Branch Strategy (GitFlow):**
```
main (production)
├── develop (integration)
    ├── feature/user-authentication
    ├── feature/payment-integration
    ├── bugfix/login-error
    └── hotfix/critical-security-patch
```

**Branch Naming:**
- `feature/description` - New features
- `bugfix/description` - Bug fixes
- `hotfix/description` - Production hotfixes
- `refactor/description` - Code refactoring
- `docs/description` - Documentation updates

### Commit Messages

**Format (Conventional Commits):**
```
<type>(<scope>): <subject>

<body>

<footer>
```

**Example:**
```
feat(auth): implement JWT token refresh

Add automatic token refresh mechanism to prevent user
session interruptions. Tokens are refreshed 5 minutes
before expiration.

Closes #234
Breaking Change: Token format changed, clients must update
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation
- `style`: Formatting (no code change)
- `refactor`: Code restructuring
- `test`: Adding tests
- `chore`: Maintenance tasks
- `perf`: Performance improvement

**Commit Best Practices:**
- Atomic commits (one logical change)
- Write descriptive messages
- Use imperative mood ("Add feature" not "Added feature")
- Reference issue numbers
- Explain why, not what (code shows what)

### Code Review

**What to Review:**
- Correctness: Does it work?
- Testing: Are there tests?
- Design: Is it well-designed?
- Complexity: Can it be simpler?
- Naming: Are names clear?
- Comments: Are they necessary and helpful?
- Style: Follows conventions?
- Documentation: Are docs updated?

**Review Feedback:**
```
❌ Bad
"This is wrong."
"Why did you do it this way?"

✅ Good
"This could cause a race condition when multiple users access it simultaneously. 
Consider adding a lock or using a transaction."

"I suggest extracting this into a helper function for reusability. 
What do you think?"
```

**Review Etiquette:**
- Be kind and constructive
- Explain why, don't just critique
- Offer alternatives and suggestions
- Praise good solutions
- Ask questions rather than make demands
- Approve when it's good enough (don't seek perfection)

### Pull Request Guidelines

**PR Description Template:**
```markdown
## What
Brief description of changes

## Why
Context and motivation

## How
Technical approach

## Testing
How to test the changes

## Screenshots
(If UI changes)

## Checklist
- [ ] Tests added/updated
- [ ] Documentation updated
- [ ] Breaking changes noted
- [ ] Migrations created (if needed)
```

**PR Best Practices:**
- Keep PRs small (< 400 lines)
- One logical change per PR
- Link related issues
- Include tests
- Update documentation
- Self-review before requesting review
- Respond to feedback promptly

---

## DevOps & Deployment

### CI/CD Pipeline

**Continuous Integration:**
```yaml
# Example pipeline stages
stages:
  - lint
  - test
  - build
  - security-scan
  - deploy

lint:
  - Run linter
  - Check code style
  - Verify commit messages

test:
  - Run unit tests
  - Run integration tests
  - Generate coverage report
  - Fail if coverage < 80%

build:
  - Build application
  - Build Docker image
  - Tag with commit SHA

security-scan:
  - Scan dependencies
  - SAST analysis
  - Container vulnerability scan

deploy:
  - Deploy to staging (auto)
  - Deploy to production (manual approval)
```

**Pipeline Best Practices:**
- Fast feedback (< 10 minutes)
- Fail fast (run quick tests first)
- Parallel execution when possible
- Immutable builds (same artifact to all environments)
- Automated rollback on failure

### Infrastructure as Code (IaC)

**Benefits:**
- Version controlled infrastructure
- Reproducible environments
- Disaster recovery
- Documentation through code

**Tools:**
- Terraform (multi-cloud)
- CloudFormation (AWS)
- Pulumi (programming language-based)
- Ansible (configuration management)

**Best Practices:**
```hcl
# Use modules for reusability
module "vpc" {
  source = "./modules/vpc"
  cidr_block = "10.0.0.0/16"
  environment = var.environment
}

# Separate environments
# environments/
#   ├── dev/
#   ├── staging/
#   └── production/

# Use variables for configuration
variable "instance_type" {
  default = "t3.medium"
  description = "EC2 instance type"
}

# State management
# - Store remote state (S3, Terraform Cloud)
# - Enable state locking
# - Never commit state files
```

### Containerization

**Docker Best Practices:**
```dockerfile
# Use specific base images
FROM python:3.11-slim

# Run as non-root user
RUN useradd -m appuser
USER appuser

# Multi-stage builds
FROM node:18 AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

FROM node:18-slim
COPY --from=builder /app/dist /app
CMD ["node", "app/server.js"]

# .dockerignore to reduce context
node_modules
.git
*.md
tests
```

**Container Guidelines:**
- One process per container
- Immutable containers
- Small images (use alpine when possible)
- Scan for vulnerabilities
- Tag images semantically
- Don't store data in containers

### Deployment Strategies

**Blue-Green Deployment:**
- Two identical environments
- Switch traffic instantly
- Easy rollback
- Double resource cost

**Canary Deployment:**
- Gradual rollout (5% → 25% → 50% → 100%)
- Monitor metrics at each stage
- Automatic rollback on errors
- Lower risk

**Rolling Deployment:**
- Update instances one by one
- No downtime
- Slower rollout
- Can't easily rollback

**Feature Flags:**
```python
if feature_flags.is_enabled('new_checkout_flow', user):
    return new_checkout_flow()
else:
    return old_checkout_flow()
```

**Benefits:**
- Deploy anytime, enable when ready
- A/B testing
- Gradual rollout
- Quick rollback (just toggle)

### Environment Management

**Environment Parity:**
- Development ≈ Staging ≈ Production
- Same dependencies, versions, configurations
- Different: Scale, data, monitoring level

**Configuration:**
```bash
# 12-Factor App: Config in environment
# .env.development
DATABASE_URL=localhost:5432/devdb
LOG_LEVEL=DEBUG
FEATURE_X_ENABLED=true

# .env.production
DATABASE_URL=prod-rds.amazonaws.com/proddb
LOG_LEVEL=INFO
FEATURE_X_ENABLED=false
```

**Secrets Management:**
- Never in version control
- Use secret managers (AWS Secrets Manager, HashiCorp Vault)
- Rotate regularly
- Principle of least privilege
- Audit access

---

## Monitoring & Observability

### Logging

**Log Levels:**
- **DEBUG**: Detailed diagnostic information
- **INFO**: General informational messages
- **WARNING**: Unexpected but handled situations
- **ERROR**: Error conditions, application can continue
- **CRITICAL**: Severe errors, application may crash

**Structured Logging:**
```python
# Bad
logger.info("User logged in")

# Good
logger.info(
    "User logged in",
    extra={
        "user_id": user.id,
        "ip_address": request.ip,
        "user_agent": request.user_agent,
        "timestamp": datetime.utcnow().isoformat()
    }
)
```

**What to Log:**
- Application start/stop
- User authentication events
- API requests/responses (sanitized)
- Errors with stack traces
- Performance issues
- Security events
- Business-critical operations

**What NOT to Log:**
- Passwords, tokens, API keys
- Credit card numbers, SSNs
- Full request/response bodies (may contain PII)
- Excessive debug info in production

### Metrics

**Key Metrics:**

**Application Metrics:**
- Request rate (requests/second)
- Error rate (errors/second, percentage)
- Response time (p50, p95, p99)
- Active users
- Business metrics (signups, transactions, etc.)

**Infrastructure Metrics:**
- CPU utilization
- Memory usage
- Disk I/O
- Network throughput
- Database connections

**RED Method (for services):**
- **Rate**: Requests per second
- **Errors**: Number of failed requests
- **Duration**: Time per request

**USE Method (for resources):**
- **Utilization**: Busy time %
- **Saturation**: Queue depth
- **Errors**: Error count

### Tracing

**Distributed Tracing:**
```python
# Track request across services
with tracer.start_span('process_order') as span:
    span.set_tag('order_id', order.id)
    
    with tracer.start_span('validate_order', child_of=span):
        validate_order(order)
    
    with tracer.start_span('charge_payment', child_of=span):
        charge_payment(order)
    
    with tracer.start_span('send_confirmation', child_of=span):
        send_confirmation(order)
```

**Benefits:**
- Identify bottlenecks
- Understand request flow
- Debug complex interactions
- Measure service dependencies

### Alerting

**Alert Principles:**
- Alert on symptoms, not causes
- Alerts should be actionable
- Avoid alert fatigue
- Define clear severity levels

**Alert Levels:**
- **P1 (Critical)**: Production down, immediate response required
- **P2 (High)**: Degraded performance, respond within 1 hour
- **P3 (Medium)**: Minor issues, respond during business hours
- **P4 (Low)**: Informational, can wait for planned work

**Example Alerts:**
```yaml
alerts:
  - name: high_error_rate
    condition: error_rate > 5%
    duration: 5m
    severity: P1
    action: page_on_call
    
  - name: slow_response_time
    condition: p95_latency > 1s
    duration: 10m
    severity: P2
    action: notify_slack
    
  - name: disk_space_low
    condition: disk_usage > 80%
    duration: 30m
    severity: P3
    action: create_ticket
```

### Dashboards

**Essential Dashboards:**
1. **Service Health**: Error rate, latency, throughput
2. **Infrastructure**: CPU, memory, disk, network
3. **Business Metrics**: Conversions, revenue, users
4. **On-Call**: Current incidents, recent deploys

**Dashboard Best Practices:**
- Start with most important metrics
- Use consistent time ranges
- Include context (deploy markers, incidents)
- Make it actionable
- Review and update regularly

---

## Documentation

### Code Documentation

**When to Comment:**
```python
# ❌ Bad - Obvious comment
i = i + 1  # Increment i

# ✅ Good - Explains why
i = i + 1  # Adjust for 0-based API indexing

# ✅ Better - Self-documenting
api_index = database_index + 1  # No comment needed
```

**Function Documentation:**
```python
def calculate_shipping_cost(
    weight: float,
    distance: float,
    priority: ShippingPriority
) -> Decimal:
    """Calculate shipping cost based on weight, distance, and priority.
    
    Uses a tiered rate structure with discounts for high-volume shippers.
    Priority shipping adds 50% to the base cost.
    
    Args:
        weight: Package weight in kilograms
        distance: Shipping distance in kilometers
        priority: Shipping priority level
        
    Returns:
        Shipping cost in USD
        
    Raises:
        ValueError: If weight or distance is negative
        
    Examples:
        >>> calculate_shipping_cost(5.0, 100.0, ShippingPriority.STANDARD)
        Decimal('12.50')
    """
```

### API Documentation

**OpenAPI/Swagger:**
```yaml
/users:
  post:
    summary: Create a new user
    description: |
      Creates a new user account with the provided information.
      Email must be unique and will be verified.
    requestBody:
      required: true
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/UserCreate'
          example:
            email: user@example.com
            name: John Doe
            password: SecurePassword123!
    responses:
      201:
        description: User created successfully
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/User'
      422:
        description: Validation error
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/ValidationError'
```

### Architecture Documentation

**C4 Model (Recommended):**
1. **Context**: System in environment
2. **Containers**: High-level technology choices
3. **Components**: Component relationships
4. **Code**: Class diagrams (optional)

**Architecture Decision Records (ADRs):**
```markdown
# ADR 001: Use PostgreSQL for Primary Database

## Status
Accepted

## Context
We need to choose a primary database for our application.
Requirements: ACID compliance, complex queries, JSON support,
strong ecosystem.

## Decision
We will use PostgreSQL 14.

## Consequences
Positive:
- Strong ACID guarantees
- Excellent query optimizer
- JSON support for flexible schemas
- Large ecosystem and community

Negative:
- Higher operational complexity than managed NoSQL
- Requires careful indexing for performance
- Horizontal scaling requires partitioning strategy

## Alternatives Considered
- MongoDB: Less consistency guarantees
- MySQL: Weaker JSON support
- DynamoDB: Vendor lock-in, different query model
```

### README Files

**Project README Template:**
```markdown
# Project Name

Brief description of what this project does.

## Features
- Feature 1
- Feature 2
- Feature 3

## Prerequisites
- Node.js 18+
- PostgreSQL 14+
- Redis 7+

## Installation
```bash
git clone https://github.com/org/project
cd project
npm install
cp .env.example .env
npm run db:migrate
```

## Usage
```bash
npm run dev          # Development
npm run test         # Tests
npm run build        # Production build
```

## Configuration
See [Configuration Guide](docs/configuration.md)

## Contributing
See [Contributing Guide](CONTRIBUTING.md)

## License
MIT
```

### Onboarding Documentation

**New Developer Checklist:**
- [ ] Development environment setup
- [ ] Access to repositories
- [ ] Access to staging environment
- [ ] Introduction to codebase architecture
- [ ] First small task/bug fix
- [ ] Code review process explanation
- [ ] Team meeting attendance

---

## Team & Process

### Agile Best Practices

**Sprint Planning:**
- 2-week sprints (recommended)
- Clear sprint goals
- Story pointing (Fibonacci sequence)
- Include buffer time (20%)
- Definition of Ready for stories

**Daily Standups:**
- Time-boxed (15 minutes)
- What did you do yesterday?
- What will you do today?
- Any blockers?
- Not a status report - focus on coordination

**Sprint Review/Demo:**
- Show working software
- Gather feedback
- Update product backlog

**Retrospective:**
- What went well?
- What could be improved?
- Action items (max 3)
- Rotate facilitator

### Code Ownership

**Collective Ownership:**
- Anyone can change any code
- Pair programming encouraged
- Code reviews required
- Documentation helps everyone

**Component Ownership (for large teams):**
- Designated owners for components
- Owners approve changes
- Others can contribute
- Prevents silos if done right

### Technical Debt Management

**Technical Debt Quadrant:**
```
        Deliberate
            |
Reckless ---|--- Prudent
            |
        Inadvertent
```

**Managing Debt:**
- Track in backlog with "tech-debt" label
- Allocate 20% of sprint to debt reduction
- Never ship Reckless debt
- Sometimes Deliberate-Prudent debt is necessary
- Refactor Inadvertent debt when you find it

**Boy Scout Rule:**
"Leave the code better than you found it"

### Incident Management

**Incident Response:**
1. **Detect**: Monitoring alerts
2. **Acknowledge**: On-call engineer responds
3. **Triage**: Assess severity
4. **Mitigate**: Stop the bleeding
5. **Resolve**: Fix root cause
6. **Document**: Write postmortem

**Postmortem (Blameless):**
```markdown
## Incident: API Outage on 2024-01-15

### Impact
- Duration: 45 minutes
- Users affected: ~10,000
- Revenue impact: ~$5,000

### Timeline
- 14:00 - Deployment starts
- 14:15 - Error rate spikes
- 14:20 - On-call paged
- 14:25 - Rollback initiated
- 14:45 - Service restored

### Root Cause
Database migration added index without CONCURRENTLY flag,
locking table during peak traffic.

### What Went Well
- Fast detection (alerts working)
- Quick mitigation (rollback)
- Good communication

### What Went Wrong
- Migration not tested on production-like data volume
- No deployment checklist
- Lock timeout not configured

### Action Items
1. Add deployment checklist (Owner: Alice, Due: 2024-01-20)
2. Configure lock timeouts (Owner: Bob, Due: 2024-01-18)
3. Create staging environment with production data volume (Owner: Charlie, Due: 2024-02-01)
```

### Knowledge Sharing

**Documentation:**
- Wiki for architecture and processes
- README files in repositories
- API documentation (always up-to-date)
- Runbooks for operational procedures

**Knowledge Transfer:**
- Brown bag lunches (tech talks)
- Pair programming
- Code reviews (teaching opportunities)
- Architecture discussions
- Conference attendance/sharing

### Hiring & Growth

**Technical Interviews:**
- Coding exercise (realistic problem)
- System design (for senior roles)
- Behavioral questions
- Pair programming session
- Code review exercise

**Onboarding:**
- Structured 30-60-90 day plan
- Assigned mentor
- Progressive task complexity
- Regular check-ins
- Documentation review

**Career Development:**
- Regular 1-on-1s
- Clear career ladder
- Technical and management tracks
- Training budget
- Conference attendance
- Side projects encouraged

---

## Principles Summary

### Engineering Excellence
1. **Code quality over speed** - Technical debt compounds
2. **Test first, ask questions later** - Tests are documentation and safety net
3. **Simple beats clever** - Optimize for readability
4. **Automate everything** - Reduce toil, increase consistency
5. **Measure, then optimize** - Data drives decisions

### Team Collaboration
6. **Be kind in code review** - We're all learning
7. **Documentation is love** - Help your future self and teammates
8. **Share knowledge freely** - Rising tide lifts all boats
9. **Blameless postmortems** - Learn from mistakes
10. **Collective ownership** - Anyone can improve any code

### Product Mindset
11. **Ship early, iterate** - Perfect is the enemy of good
12. **User feedback is gold** - Build what users need
13. **Monitor production** - Know how your system behaves
14. **Security from the start** - It's expensive to add later
15. **Performance matters** - Every millisecond counts

### Long-term Thinking
16. **Build for change** - Requirements will evolve
17. **Invest in infrastructure** - Productivity compounds
18. **Refactor regularly** - Code rots without care
19. **Plan for scale** - But don't over-engineer
20. **Enjoy the craft** - We're lucky to build things

---

## Recommended Reading

**Books:**
- *Clean Code* - Robert C. Martin
- *Refactoring* - Martin Fowler
- *Design Patterns* - Gang of Four
- *Domain-Driven Design* - Eric Evans
- *The Pragmatic Programmer* - Hunt & Thomas
- *Building Microservices* - Sam Newman
- *Site Reliability Engineering* - Google
- *Accelerate* - Forsgren, Humble, Kim

**Blogs & Resources:**
- Martin Fowler (martinfowler.com)
- High Scalability (highscalability.com)
- AWS Architecture Blog
- Engineering blogs (Netflix, Uber, Spotify, etc.)

---

**Remember:** These are guidelines, not laws. Context matters. Sometimes you need to break rules for good reasons - just document why.

**Last Updated:** 2024-01-15
**Maintained By:** Engineering Leadership
