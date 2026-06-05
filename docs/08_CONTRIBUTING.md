# Contributing Guidelines

Thank you for your interest in contributing to the Network Monitoring ML project!

## Team Members

- **Habibullah Turkmen** - Backend Lead
- **Bernard Appiah** - Frontend Developer  
- **Soumita Bose** - ML Engineer
- **Alshaima Syed Ibrahim** - DevOps/Database

## Code Style

### TypeScript (Backend & Frontend)

```typescript
// Use explicit types
const processData = (data: TrafficData): PredictionResult => {
  // Implementation
};

// Use interfaces over types for objects
interface TrafficData {
  src_ip: string;
  dst_ip: string;
  src_port: number;
  dst_port: number;
}

// Use const for immutable variables
const DEFAULT_PORT = 5000;

// Use arrow functions
const handleRequest = () => {
  // Implementation
};
```

### Python (ML Service)

```python
# Follow PEP 8
from typing import List, Dict, Tuple

# Use type hints
def predict_traffic(features: List[float]) -> Dict[str, float]:
    """Predict if traffic is anomalous."""
    pass

# Use docstrings
class TrafficClassifier:
    """Classifies network traffic as normal or suspicious."""
    
    def __init__(self):
        """Initialize classifier."""
        pass
```

## Git Workflow

### Branch Naming

```
# Feature branches
feature/backend-api
feature/frontend-dashboard
feature/ml-model-training

# Bug fixes
bugfix/auth-issue

# Hotfixes
hotfix/critical-bug

# Documentation
docs/installation-guide
```

### Commit Messages

```
# Format: <type>(<scope>): <subject>

feat(backend): add traffic logging endpoint
fix(frontend): resolve dashboard refresh issue
docs(readme): update installation instructions
test(ml): add model validation tests
refactor(backend): simplify error handling
chore(deps): update dependencies
```

### Pull Request Process

1. **Create feature branch**
   ```bash
   git checkout -b feature/my-feature
   ```

2. **Make changes and commit**
   ```bash
   git add .
   git commit -m "feat(backend): add new endpoint"
   ```

3. **Push to origin**
   ```bash
   git push origin feature/my-feature
   ```

4. **Create Pull Request**
   - Add clear description
   - Link related issues
   - Request team members as reviewers

5. **Code Review**
   - Address feedback
   - Make requested changes
   - Re-request review after updates

6. **Merge**
   - Squash commits if needed
   - Delete branch after merge

## Testing Requirements

### Backend Tests

```bash
# Run all tests
npm test

# Run with coverage
npm test -- --coverage

# Watch mode
npm test -- --watch
```

Minimum coverage: **80%**

### ML Service Tests

```bash
# Run tests
python -m pytest tests/

# With coverage
python -m pytest --cov=src tests/
```

Minimum coverage: **80%**

### Frontend Tests

```bash
# Run tests
npm test

# Watch mode
npm test -- --watch
```

## Code Review Checklist

- [ ] Code follows style guidelines
- [ ] Tests are included
- [ ] Comments added for complex logic
- [ ] No console.log/print statements
- [ ] Error handling implemented
- [ ] Documentation updated
- [ ] No breaking changes
- [ ] Performance impact considered

## Documentation

All contributions should update documentation:

- **New Features**: Add to [API_REFERENCE.md](04_API_REFERENCE.md)
- **Configuration Changes**: Update [.env.example](.env.example)
- **Architecture Changes**: Update [ARCHITECTURE.md](03_ARCHITECTURE.md)
- **Bug Fixes**: Update [TROUBLESHOOTING.md](09_TROUBLESHOOTING.md)

## Development Setup

See [INSTALLATION.md](02_INSTALLATION.md) for detailed setup instructions.

## Communication

- **Daily Standup**: 10:00 AM (Team Sync)
- **Code Review**: Within 24 hours
- **Issue Discussion**: GitHub Issues
- **General Discussion**: Team Chat

## Issue Reporting

When reporting issues:

1. Check existing issues first
2. Provide clear title
3. Include:
   - Steps to reproduce
   - Expected behavior
   - Actual behavior
   - Screenshots/logs
4. Assign label (bug, enhancement, documentation)
5. Assign to relevant team member

## Questions?

Reach out to your team lead or create a GitHub discussion.

---

Thank you for contributing! 🎉
