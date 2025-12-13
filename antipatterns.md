# Software Engineering Anti-Patterns & Common Mistakes

What NOT to do: A CTO's guide to recognizing and avoiding common software development pitfalls.

---

## Table of Contents

1. [Code Anti-Patterns](#code-anti-patterns)
2. [Architecture Anti-Patterns](#architecture-anti-patterns)
3. [Testing Anti-Patterns](#testing-anti-patterns)
4. [Security Anti-Patterns](#security-anti-patterns)
5. [Performance Anti-Patterns](#performance-anti-patterns)
6. [Database Anti-Patterns](#database-anti-patterns)
7. [API Anti-Patterns](#api-anti-patterns)
8. [DevOps Anti-Patterns](#devops-anti-patterns)
9. [Team & Process Anti-Patterns](#team--process-anti-patterns)
10. [Management Anti-Patterns](#management-anti-patterns)

---

## Code Anti-Patterns

### God Object / God Class

**Problem:** One class that knows too much and does too much.

```python
# ❌ Bad - God Class
class User:
    def __init__(self):
        pass
    
    def authenticate(self): pass
    def validate_email(self): pass
    def send_email(self): pass
    def calculate_permissions(self): pass
    def log_activity(self): pass
    def generate_report(self): pass
    def export_to_pdf(self): pass
    def process_payment(self): pass
    # ... 50 more methods

# ✅ Good - Single Responsibility
class User:
    def __init__(self): pass

class UserAuthenticator:
    def authenticate(user): pass

class EmailService:
    def send(to, subject, body): pass

class PermissionCalculator:
    def calculate(user): pass
```

**Why it's bad:**
- Hard to understand
- Difficult to test
- Changes ripple everywhere
- Impossible to maintain

### Spaghetti Code

**Problem:** Code with complex, tangled control flow.

```python
# ❌ Bad - Spaghetti
def process_order(order):
    if order:
        if order.user:
            if order.user.is_active:
                if order.items:
                    for item in order.items:
                        if item.in_stock:
                            if item.price > 0:
                                if order.payment_method:
                                    # ... more nesting
                                    pass

# ✅ Good - Early returns and clear flow
def process_order(order):
    if not order or not order.user:
        raise InvalidOrderError("Order or user is missing")
    
    if not order.user.is_active:
        raise InactiveUserError("User is not active")
    
    validate_items(order.items)
    validate_payment(order.payment_method)
    
    return complete_order(order)
```

### Magic Numbers

**Problem:** Unexplained literal values in code.

```python
# ❌ Bad - Magic numbers
if user.age > 18:
    discount = price * 0.15
    if order.total > 100:
        shipping = 0

# ✅ Good - Named constants
MINIMUM_AGE = 18
SENIOR_DISCOUNT_RATE = Decimal('0.15')
FREE_SHIPPING_THRESHOLD = Decimal('100.00')

if user.age > MINIMUM_AGE:
    discount = price * SENIOR_DISCOUNT_RATE
    if order.total > FREE_SHIPPING_THRESHOLD:
        shipping = Decimal('0')
```

### Copy-Paste Programming

**Problem:** Duplicating code instead of abstracting.

```python
# ❌ Bad - Duplicate code
def send_welcome_email(user):
    subject = "Welcome!"
    body = f"Hello {user.name}..."
    smtp = smtplib.SMTP('smtp.gmail.com', 587)
    smtp.starttls()
    smtp.login(EMAIL_USER, EMAIL_PASSWORD)
    smtp.sendmail(FROM_EMAIL, user.email, msg.as_string())
    smtp.quit()

def send_password_reset_email(user):
    subject = "Password Reset"
    body = f"Hello {user.name}..."
    smtp = smtplib.SMTP('smtp.gmail.com', 587)
    smtp.starttls()
    smtp.login(EMAIL_USER, EMAIL_PASSWORD)
    smtp.sendmail(FROM_EMAIL, user.email, msg.as_string())
    smtp.quit()

# ✅ Good - Abstracted email service
class EmailService:
    def __init__(self):
        self.smtp = self._create_smtp_connection()
    
    def send_email(self, to, subject, body):
        # Single implementation
        pass
    
    def send_welcome_email(self, user):
        self.send_email(user.email, "Welcome!", self._get_welcome_body(user))
    
    def send_password_reset_email(self, user):
        self.send_email(user.email, "Password Reset", self._get_reset_body(user))
```

### Cargo Cult Programming

**Problem:** Using code patterns without understanding why.

```javascript
// ❌ Bad - Unnecessary patterns
class UserFactory {
  createUser(data) {
    return new User(data); // Factory adds no value here
  }
}

class UserBuilder {
  setName(name) { this.name = name; return this; }
  setEmail(email) { this.email = email; return this; }
  build() { return new User(this.name, this.email); }
}

// ✅ Good - Simple when possible
const user = new User({ name: "John", email: "john@example.com" });
```

### Premature Optimization

**Problem:** Optimizing before you know where the bottleneck is.

```python
# ❌ Bad - Premature optimization
def get_user(user_id):
    # Complex caching logic before any performance testing
    cache_key = f"user:{user_id}:v2"
    cached = redis.get(cache_key)
    if cached:
        return pickle.loads(cached)
    
    user = db.query(User).get(user_id)
    redis.setex(cache_key, 3600, pickle.dumps(user))
    return user

# ✅ Good - Start simple
def get_user(user_id):
    return db.query(User).get(user_id)
    # Add caching later if profiling shows it's needed
```

### Yo-Yo Problem

**Problem:** Overly deep inheritance hierarchies.

```python
# ❌ Bad - Too much inheritance
class Animal:
    pass

class Mammal(Animal):
    pass

class Carnivore(Mammal):
    pass

class Feline(Carnivore):
    pass

class BigCat(Feline):
    pass

class Lion(BigCat):  # 6 levels deep!
    pass

# ✅ Good - Composition over inheritance
class Lion:
    def __init__(self):
        self.traits = [Mammal(), Carnivore(), Feline()]
```

---

## Architecture Anti-Patterns

### Big Ball of Mud

**Problem:** No discernible architecture, everything depends on everything.

**Signs:**
- No clear module boundaries
- Circular dependencies everywhere
- Can't change one thing without breaking ten others
- New developers take months to understand the system

**Solution:**
- Identify bounded contexts
- Extract modules with clear interfaces
- Gradually refactor toward layers or services
- Enforce dependency rules

### The Monolith When You Need Microservices

**Problem:** Single massive application when team has outgrown it.

**When you actually need microservices:**
- Large team (50+ engineers)
- Different parts scale differently
- Need independent deployment
- Different technology needs per service

**Don't use microservices when:**
- Small team (< 10 engineers)
- Uncertain product-market fit
- Lacking DevOps maturity
- Don't want operational complexity

### Microservices Premature

**Problem:** Starting with microservices before you know your domain.

```
❌ Day 1: User Service, Order Service, Payment Service,
         Inventory Service, Notification Service, Analytics Service
         (6 services, 2 developers)

✅ Day 1: One monolith
   Year 2: Split when you understand boundaries
```

**Why it's bad:**
- Don't know the right boundaries yet
- Massive operational overhead
- Slow development (cross-service changes)
- Debugging nightmares

### Distributed Monolith

**Problem:** Microservices that all depend on each other.

```
Service A → Service B → Service C → Service D
     ↑                                    ↓
     └─────────────────────────────────────
```

**Signs:**
- Can't deploy services independently
- Changes require coordinated releases
- Debugging requires following calls across services
- Network latency everywhere

**You have the worst of both worlds:** Monolith complexity + distributed system problems.

### Golden Hammer

**Problem:** "I know X, therefore everything is X"

```
- "This is a React app" (for a 2-page marketing site)
- "We use microservices" (for a 3-person team)
- "NoSQL for everything" (even transactional data)
- "Blockchain" (for... anything not needing blockchain)
```

**Solution:** Choose technology based on requirements, not familiarity.

### Architecture by Resume

**Problem:** Using tech to pad resume rather than solve problems.

**Red flags:**
- "Let's use Kubernetes" (for 2 services)
- "We need GraphQL" (simple CRUD API)
- "Let's try the new framework" (mature app in production)

**Reality check:**
- Will this technology still be supported in 5 years?
- Do we have expertise to maintain it?
- Does it solve a real problem we have?
- What's the total cost of ownership?

### NIH (Not Invented Here) Syndrome

**Problem:** Rebuilding everything instead of using existing solutions.

```
❌ "We need a custom authentication system"
   (Instead of OAuth/Auth0/Clerk)

❌ "Let's build our own ORM"
   (Instead of SQLAlchemy/TypeORM/Hibernate)

❌ "Our own task queue system"
   (Instead of Celery/Bull/Sidekiq)
```

**When custom makes sense:**
- Core differentiator for your business
- Available solutions genuinely don't fit
- You have resources to maintain it

---

## Testing Anti-Patterns

### Testing the Framework

**Problem:** Testing library/framework code, not your code.

```python
# ❌ Bad - Testing Django's behavior
def test_user_model_has_email_field():
    user = User()
    assert hasattr(user, 'email')

# ✅ Good - Testing your business logic
def test_user_cannot_register_with_duplicate_email():
    create_user(email="test@example.com")
    
    with pytest.raises(DuplicateEmailError):
        create_user(email="test@example.com")
```

### 100% Code Coverage Obsession

**Problem:** Chasing coverage metrics instead of meaningful tests.

```python
# ❌ Bad - High coverage, low value
def test_getter():
    user = User(name="John")
    assert user.get_name() == "John"  # Trivial

# ✅ Good - Lower coverage, high value
def test_password_reset_flow():
    user = create_user()
    token = request_password_reset(user)
    
    # Test expiration
    time.sleep(61 * 60)  # 61 minutes
    with pytest.raises(ExpiredTokenError):
        reset_password(token, "newpass")
```

**Reality:** 80% coverage with meaningful tests > 100% coverage with trivial tests.

### Fragile Tests

**Problem:** Tests break when implementation changes, not behavior.

```python
# ❌ Bad - Tests implementation details
def test_user_registration():
    with patch('app.services.UserService._hash_password') as mock_hash:
        register_user("test@example.com", "password")
        mock_hash.assert_called_once()  # Who cares?

# ✅ Good - Tests behavior
def test_user_registration():
    user = register_user("test@example.com", "password")
    
    # Can authenticate with the password
    assert authenticate("test@example.com", "password") == user
    
    # Password is not stored in plain text
    assert user.password_hash != "password"
```

### Excessive Mocking

**Problem:** Mocking everything, testing nothing real.

```python
# ❌ Bad - Mock hell
def test_process_order():
    mock_user = Mock()
    mock_product = Mock()
    mock_payment = Mock()
    mock_inventory = Mock()
    mock_email = Mock()
    mock_db = Mock()
    
    # Test tells you nothing about real behavior
    process_order(mock_user, mock_product, mock_payment, 
                 mock_inventory, mock_email, mock_db)
    
    mock_email.send.assert_called_once()

# ✅ Good - Test real integration
def test_process_order(test_db):
    user = create_test_user(test_db)
    product = create_test_product(test_db)
    
    # Only mock external services
    with patch('stripe.Charge.create') as mock_stripe:
        order = process_order(user, product, payment_method)
        
        assert order.status == 'completed'
        assert test_db.query(Order).count() == 1
```

### Manual Testing Dependency

**Problem:** "Works on my machine" because no automated tests.

**Signs:**
- "Let me just manually check this"
- QA finds bugs that should've been caught by tests
- Fear of refactoring
- Deployments are scary

**Solution:** Automate tests, run in CI/CD.

### No Test Pyramid

**Problem:** Too many E2E tests, not enough unit tests.

```
❌ Bad test distribution:
    /────────\    80% E2E (slow, brittle)
   /──────────\   15% Integration
  /────────────\  5% Unit

✅ Good test distribution:
       /\          5% E2E
      /──\         25% Integration
     /────\        70% Unit
```

---

## Security Anti-Patterns

### Rolling Your Own Crypto

**Problem:** Implementing encryption yourself.

```python
# ❌ NEVER DO THIS
def encrypt_password(password):
    return ''.join(chr(ord(c) + 3) for c in password)  # Caesar cipher!

# ✅ Use battle-tested libraries
import bcrypt

def hash_password(password):
    return bcrypt.hashpw(password.encode(), bcrypt.gensalt(rounds=12))
```

**Rule:** Never implement your own cryptography. Use libraries.

### Storing Passwords in Plain Text

**Problem:** Exactly what it sounds like.

```sql
-- ❌ NEVER
CREATE TABLE users (
    email VARCHAR(255),
    password VARCHAR(255)  -- Plain text!
);

-- ✅ ALWAYS
CREATE TABLE users (
    email VARCHAR(255),
    password_hash VARCHAR(255),  -- Hashed with bcrypt/argon2
    created_at TIMESTAMP
);
```

### Security by Obscurity

**Problem:** Thinking hidden = secure.

```python
# ❌ Bad - Hiding the endpoint doesn't make it secure
@app.route('/secret_admin_panel_xyz123')
def admin_panel():
    # No authentication check!
    return render_template('admin.html')

# ✅ Good - Actual security
@app.route('/admin')
@require_authentication
@require_role('admin')
def admin_panel():
    return render_template('admin.html')
```

### SQL Injection Vulnerability

**Problem:** Concatenating SQL queries.

```python
# ❌ NEVER - SQL Injection
email = request.form['email']
query = f"SELECT * FROM users WHERE email = '{email}'"
# User inputs: ' OR '1'='1
# Query becomes: SELECT * FROM users WHERE email = '' OR '1'='1'

# ✅ ALWAYS - Parameterized queries
email = request.form['email']
query = "SELECT * FROM users WHERE email = ?"
cursor.execute(query, (email,))
```

### Insufficient Rate Limiting

**Problem:** Allowing unlimited attempts.

```python
# ❌ Bad - No rate limiting
@app.route('/login', methods=['POST'])
def login():
    # Attacker can try millions of passwords
    return authenticate(request.form['email'], request.form['password'])

# ✅ Good - Rate limiting
from flask_limiter import Limiter

limiter = Limiter(app, key_func=lambda: request.remote_addr)

@app.route('/login', methods=['POST'])
@limiter.limit("5 per minute")
def login():
    return authenticate(request.form['email'], request.form['password'])
```

### Exposing Sensitive Info in Errors

**Problem:** Leaking system information in error messages.

```python
# ❌ Bad - Exposing details
try:
    db.execute(query)
except Exception as e:
    return {"error": str(e)}  # "PostgreSQL 14.2 connection failed at 10.0.1.23:5432"

# ✅ Good - Generic error messages
try:
    db.execute(query)
except Exception as e:
    logger.error(f"Database error: {e}", extra={'query': query})
    return {"error": "An error occurred. Please try again."}
```

### No HTTPS in Production

**Problem:** Transmitting data in plain text.

```
❌ http://myapp.com/login
   (Passwords sent in clear text!)

✅ https://myapp.com/login
   (Encrypted connection)
```

**Rule:** HTTPS everywhere in production. No exceptions.

---

## Performance Anti-Patterns

### N+1 Query Problem

**Problem:** Separate query for each item in a list.

```python
# ❌ Bad - N+1 queries
users = User.query.all()  # 1 query
for user in users:
    print(user.profile.bio)  # N queries (one per user)
# Total: 1 + N queries

# ✅ Good - Eager loading
users = User.query.options(joinedload(User.profile)).all()
for user in users:
    print(user.profile.bio)
# Total: 1 query
```

### SELECT * FROM

**Problem:** Fetching more data than needed.

```sql
-- ❌ Bad - Fetching everything
SELECT * FROM users;  -- Includes large BLOB columns, etc.

-- ✅ Good - Select only what you need
SELECT id, email, name FROM users;
```

### Missing Indexes

**Problem:** Full table scans on large tables.

```sql
-- ❌ Bad - No index
SELECT * FROM orders WHERE customer_id = 123;
-- Table scan on million-row table

-- ✅ Good - Add index
CREATE INDEX idx_orders_customer_id ON orders(customer_id);
```

### Synchronous When Async Would Be Better

**Problem:** Blocking operations in request handlers.

```python
# ❌ Bad - Blocking the request
@app.route('/signup', methods=['POST'])
def signup():
    user = create_user(request.form)
    send_welcome_email(user)  # Takes 2 seconds
    generate_pdf_report(user)  # Takes 5 seconds
    return "Signed up"  # User waits 7+ seconds

# ✅ Good - Async processing
@app.route('/signup', methods=['POST'])
def signup():
    user = create_user(request.form)
    task_queue.enqueue(send_welcome_email, user)
    task_queue.enqueue(generate_pdf_report, user)
    return "Signed up"  # Instant response
```

### Caching Done Wrong

**Problem:** Caching things that shouldn't be cached, or bad invalidation.

```python
# ❌ Bad - Caching user-specific data globally
@cache.cached(timeout=3600)
def get_dashboard_data(user_id):
    return expensive_query(user_id)
# Bug: User A sees User B's data!

# ✅ Good - User-specific cache keys
@cache.cached(timeout=3600, key_prefix=lambda: f"dashboard:{current_user.id}")
def get_dashboard_data():
    return expensive_query(current_user.id)
```

### Memory Leaks

**Problem:** Not releasing resources.

```python
# ❌ Bad - Connection leak
def get_user_data():
    conn = psycopg2.connect(DSN)
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM users")
    return cursor.fetchall()
    # Connection never closed!

# ✅ Good - Use context managers
def get_user_data():
    with psycopg2.connect(DSN) as conn:
        with conn.cursor() as cursor:
            cursor.execute("SELECT * FROM users")
            return cursor.fetchall()
    # Automatically closed
```

---

## Database Anti-Patterns

### UUID as Primary Key Without Index

**Problem:** Poor performance on UUID primary keys.

```sql
-- ❌ Bad - Random UUIDs cause page splits
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    ...
);

-- ✅ Better - Sequential UUIDs (UUIDv7) or BIGSERIAL
CREATE TABLE users (
    id BIGSERIAL PRIMARY KEY,
    uuid UUID UNIQUE DEFAULT gen_random_uuid(),
    ...
);
```

### EAV (Entity-Attribute-Value) Anti-Pattern

**Problem:** Storing structured data in key-value format.

```sql
-- ❌ Bad - EAV
CREATE TABLE entity_attributes (
    entity_id INT,
    attribute_name VARCHAR(50),
    attribute_value TEXT
);
-- Query nightmare, no type safety, can't use indexes

-- ✅ Good - Proper schema
CREATE TABLE products (
    id INT PRIMARY KEY,
    name VARCHAR(255),
    price DECIMAL(10,2),
    category VARCHAR(100)
);
-- Or use JSONB for truly flexible fields
```

### No Foreign Keys

**Problem:** Referential integrity not enforced.

```sql
-- ❌ Bad - No foreign key
CREATE TABLE orders (
    id INT PRIMARY KEY,
    user_id INT  -- What if user_id doesn't exist?
);

-- ✅ Good - Foreign key constraint
CREATE TABLE orders (
    id INT PRIMARY KEY,
    user_id INT REFERENCES users(id) ON DELETE CASCADE
);
```

### Storing Comma-Separated Values

**Problem:** Lists in a single column.

```sql
-- ❌ Bad
CREATE TABLE articles (
    id INT,
    tags VARCHAR(255)  -- "tech,programming,python"
);
-- Can't query, can't index, violates 1NF

-- ✅ Good - Junction table
CREATE TABLE articles (
    id INT PRIMARY KEY,
    title VARCHAR(255)
);

CREATE TABLE tags (
    id INT PRIMARY KEY,
    name VARCHAR(50)
);

CREATE TABLE article_tags (
    article_id INT REFERENCES articles(id),
    tag_id INT REFERENCES tags(id),
    PRIMARY KEY (article_id, tag_id)
);
```

### BLOB in Database

**Problem:** Storing large binary files in database.

```sql
-- ❌ Bad - Large files in DB
CREATE TABLE documents (
    id INT,
    content BYTEA  -- Storing 10MB PDFs
);
-- Database bloat, slow backups, expensive

-- ✅ Good - Store in object storage
CREATE TABLE documents (
    id INT,
    s3_key VARCHAR(255),  -- Reference to S3/R2/etc
    file_size INT,
    mime_type VARCHAR(50)
);
```

---

## API Anti-Patterns

### Verbs in REST URLs

**Problem:** Using verbs instead of nouns.

```
❌ Bad REST:
POST /createUser
GET  /getUser?id=123
POST /deleteUser

✅ Good REST:
POST   /users          (Create)
GET    /users/123      (Read)
PUT    /users/123      (Update)
DELETE /users/123      (Delete)
```

### Inconsistent Response Formats

**Problem:** Different formats for different endpoints.

```json
// ❌ Bad - Inconsistent
// Endpoint 1
{"user": {...}}

// Endpoint 2
{...}  // No wrapping

// Endpoint 3
{"data": {...}, "success": true}

// ✅ Good - Consistent
// All endpoints
{
  "data": {...},
  "meta": {"timestamp": "..."}
}
```

### Chatty APIs

**Problem:** Requiring many round trips.

```javascript
// ❌ Bad - 4 requests
const user = await fetch('/api/users/123');
const posts = await fetch('/api/users/123/posts');
const comments = await fetch('/api/users/123/comments');
const likes = await fetch('/api/users/123/likes');

// ✅ Good - 1 request with includes
const data = await fetch('/api/users/123?include=posts,comments,likes');
```

### No Versioning

**Problem:** Breaking API changes without versioning.

```
❌ Bad:
/api/users  (change breaks all clients)

✅ Good:
/api/v1/users  (old clients still work)
/api/v2/users  (new features)
```

### Ignoring HTTP Methods

**Problem:** Using GET for everything or POST for everything.

```
❌ Bad:
GET  /api/createUser    (State-changing GET!)
POST /api/getUser       (POST for read!)

✅ Good:
POST /api/users        (Create)
GET  /api/users/123    (Read - idempotent)
```

### No Rate Limiting

**Problem:** Allowing unlimited API calls.

**Result:**
- DDoS attacks
- Resource exhaustion
- Unfair usage
- High costs

**Solution:** Implement rate limiting (e.g., 1000 requests/hour per API key).

---

## DevOps Anti-Patterns

### Manual Deployments

**Problem:** Deploying by hand.

```bash
# ❌ Bad - Manual steps
ssh production
git pull
npm install
npm run build
pm2 restart app
# (Developer forgets a step, breaks production)

# ✅ Good - Automated deployment
git push origin main
# CI/CD handles everything consistently
```

### No Rollback Plan

**Problem:** Can't undo a bad deployment.

**Scenario:**
1. Deploy new version
2. Customers complain about bugs
3. No way to quickly go back to working version
4. Scramble to fix in production

**Solution:** 
- Blue-green deployments
- Canary releases
- Feature flags
- Keep previous versions deployable

### Deploying on Fridays

**Problem:** Deploying before the weekend.

**Murphy's Law:**
- If something can go wrong, it will
- It will go wrong at 4:45 PM on Friday
- You'll spend the weekend fixing it

**Best Practice:** Deploy Monday-Thursday, never Friday.

### "Works on My Machine"

**Problem:** Dev environment != staging != production.

```
Developer: "It works on my machine!" 🤷‍♂️
Operations: "Well, it doesn't work in production!" 😤
```

**Solution:**
- Use Docker/containers
- Infrastructure as code
- Parity between environments
- Test on production-like data

### Snowflake Servers

**Problem:** Manually configured servers, each slightly different.

**Signs:**
- "Don't restart server 3, it's configured special"
- Only one person knows how to set up servers
- Fear of replacing servers

**Solution:**
- Infrastructure as code
- Immutable infrastructure
- Configuration management
- Document everything

### No Monitoring

**Problem:** First time you hear about issues is from customers.

```
Customer: "Your site is down!"
You: "Oh no, let me check..."
```

**Solution:**
- Monitoring and alerting
- Health checks
- Log aggregation
- Real user monitoring

### Alert Fatigue

**Problem:** Too many alerts, all ignored.

```
❌ Bad:
[ALERT] Disk 45% full (warning)
[ALERT] CPU spike for 1 second
[ALERT] Memory at 51%
[ALERT] Production is DOWN! (gets missed in the noise)

✅ Good:
[CRITICAL] Production is DOWN! (page on-call)
[WARNING] Disk 80% full (email)
(No alerts for normal operations)
```

---

## Team & Process Anti-Patterns

### Hero Culture

**Problem:** Relying on "hero" developers who save the day.

**Signs:**
- "Only Alice can work on the payment system"
- "Let Bob handle it, he knows that code"
- Long hours praised as dedication
- Burnout epidemic

**Problems:**
- Bus factor of 1
- No knowledge sharing
- Unsustainable pace
- Team dependency

**Solution:**
- Pair programming
- Code reviews
- Documentation
- Shared ownership
- Sustainable pace

### Meeting Culture

**Problem:** Too many meetings, no time to code.

**Schedule:**
```
9:00 - Daily standup
9:30 - Sprint planning
11:00 - Architecture discussion
1:00 - Status update
2:00 - Team sync
3:00 - Stakeholder review
4:00 - Retrospective
```

**Result:** 0 hours of focused work time.

**Solution:**
- "No meeting" blocks
- Async communication
- Shorter meetings
- Clear agendas
- Decline optional meetings

### Scope Creep

**Problem:** Adding features mid-sprint.

```
Sprint Start: Implement user login

Week 1: "Can we add social login too?"
Week 2: "Also add 2FA"
Week 3: "And make it work offline"

Sprint End: Nothing finished
```

**Solution:**
- Lock scope during sprint
- Add new requests to backlog
- Prioritize in next planning
- Say no sometimes

### Not Invented Here (NIH)

**Problem:** Rebuilding everything from scratch.

```
❌ "Let's build our own authentication system"
✅ Use Auth0, Clerk, or similar

❌ "Let's write our own ORM"
✅ Use SQLAlchemy, TypeORM, etc.

❌ "Let's create our own monitoring solution"
✅ Use Datadog, New Relic, etc.
```

**When to build:**
- It's your core competency
- No existing solution fits
- You have resources to maintain it

### Analysis Paralysis

**Problem:** Over-planning, never executing.

**Symptoms:**
- Months of architecture discussions
- No prototype built
- Paralyzed by choice
- Perfect is the enemy of good

**Solution:**
- Build a prototype
- Make reversible decisions quickly
- Iterate based on learnings
- Ship and learn

### Blame Culture

**Problem:** Pointing fingers when things go wrong.

```
❌ "Who deployed the bug?"
❌ "Why didn't you catch this in testing?"
❌ "This is YOUR code!"

✅ "What process failed?"
✅ "How can we prevent this?"
✅ "What can we learn?"
```

**Result of blame culture:**
- People hide mistakes
- No learning happens
- Fear prevents innovation
- Talent leaves

---

## Management Anti-Patterns

### Micromanagement

**Problem:** Managing every detail of work.

**Signs:**
- Requiring detailed hourly updates
- Prescribing exact implementation
- No trust in team decisions
- Second-guessing everything

**Problems:**
- Developers feel untrusted
- Innovation stifled
- Bottleneck at manager
- High turnover

### Mythical Man-Month

**Problem:** "9 women can have a baby in 1 month"

```
Project is late?
❌ Add more developers!

Reality:
- Onboarding time
- Communication overhead
- Knowledge transfer
- Coordination complexity
```

**Brooks's Law:** "Adding people to a late project makes it later."

### Feature Factory

**Problem:** Measuring success by features shipped, not outcomes.

**Metrics:**
- ❌ Number of features per quarter
- ❌ Lines of code written
- ❌ Story points completed

**Better metrics:**
- ✅ Customer satisfaction
- ✅ Business value delivered
- ✅ User engagement
- ✅ Revenue impact

### Death March Project

**Problem:** Unrealistic deadlines, permanent crunch mode.

**Phases:**
1. Unrealistic timeline set
2. Team works overtime
3. Quality suffers
4. Tech debt accumulates
5. Burnout begins
6. Talent leaves
7. Project fails anyway

**Solution:**
- Realistic estimates
- Sustainable pace
- Say no to impossible deadlines
- Protect the team

### Resume-Driven Development

**Problem:** Choosing technology for resume, not for product.

**Manager:** "We should use Kubernetes!"
**Developer:** "We have 2 services..."
**Manager:** "But it's on my resume!"

**Better approach:**
- Choose boring technology
- Optimize for maintainability
- Consider team expertise
- Solve actual problems

### Not Listening to Engineers

**Problem:** Ignoring technical concerns.

```
Engineer: "This will take 6 months to do right"
Manager: "You have 2 weeks"

Engineer: "This approach has serious security issues"
Manager: "Ship it anyway"

Engineer: "We need to refactor this"
Manager: "No time, add more features"
```

**Result:**
- Technical debt explosion
- Quality problems
- Lost trust
- Engineer exodus

---

## When Rules Should Be Broken

**These are guidelines, not laws.** Sometimes you need to break them:

### Breaking Best Practices is OK When:

1. **Prototyping / MVP**
   - Quick and dirty is fine for validation
   - Don't over-engineer an experiment
   - Rewrite properly if it works

2. **Emergency Hotfix**
   - Quick fix to stop the bleeding
   - Create ticket to do it properly later
   - Actually follow through on the ticket

3. **Throw-Away Code**
   - Scripts, one-off data migrations
   - Won't be maintained
   - Document that it's throw-away

4. **You Have a Better Reason**
   - You understand the tradeoffs
   - You document the decision
   - The benefit outweighs the cost

### Breaking Best Practices is NOT OK When:

1. **"No time for quality"**
   - You'll pay later with interest
   - Technical debt compounds
   - It's never "temporary"

2. **"We'll fix it later"**
   - Later rarely comes
   - Pressure never decreases
   - "Temporary" becomes permanent

3. **"Nobody will notice"**
   - They will notice
   - It sets precedent
   - It becomes the new standard

4. **"I know better"**
   - Experience of community matters
   - Your edge case probably isn't special
   - Pride goes before a fall

---

## How to Recognize Anti-Patterns

### Code Smells:
- Long functions (>50 lines)
- Large classes (>500 lines)
- Deep nesting (>4 levels)
- Lots of comments (code should be self-documenting)
- God classes
- Duplicate code

### Architecture Smells:
- Circular dependencies
- Everything depends on one module
- Can't deploy independently
- Changes ripple everywhere
- No clear boundaries

### Process Smells:
- Fear of deploying
- Fear of changing code
- Manual, error-prone processes
- Tribal knowledge
- "Only X knows how this works"
- Constant firefighting

### Team Smells:
- High turnover
- Burnout
- Blame culture
- Silos
- Poor communication
- No documentation

---

## The Path Forward

**When you recognize an anti-pattern:**

1. **Don't panic** - All code has some technical debt
2. **Understand the cost** - Is it actually a problem?
3. **Prioritize** - Not everything needs fixing immediately
4. **Plan** - How to fix incrementally
5. **Document** - Why it's an anti-pattern, how to fix
6. **Learn** - Why did this happen? How to prevent?

**Remember:**
- Perfect code doesn't exist
- Some technical debt is acceptable
- Context matters
- Improvement is iterative
- The goal is sustainable development

---

**Most Important:** Learn to recognize anti-patterns early. It's easier to prevent than to fix.

**Last Updated:** 2024-01-15
