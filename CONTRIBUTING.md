# Contributing to DeliverGaz 🚚

First off, thank you for considering contributing to DeliverGaz! It's people like you that make DeliverGaz such a great tool for gas delivery services.

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [How Can I Contribute?](#how-can-i-contribute)
- [Development Setup](#development-setup)
- [Pull Request Process](#pull-request-process)
- [Style Guidelines](#style-guidelines)
- [Issue Guidelines](#issue-guidelines)
- [Community](#community)

## 📜 Code of Conduct

This project and everyone participating in it is governed by our [Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code. Please report unacceptable behavior to [conduct@delivergaz.com](mailto:conduct@delivergaz.com).

## 🚀 Getting Started

### Prerequisites

Before you begin, ensure you have the following installed:

- **Node.js** 18+ and npm
- **Flutter** 3.0+ and Dart SDK
- **MongoDB** (local or cloud instance)
- **Git**

### Fork and Clone

1. Fork the repository on GitHub
2. Clone your fork locally:
   ```bash
   git clone https://github.com/YOUR_USERNAME/LiverGaz.git
   cd deliverGaz
   ```
3. Add the original repository as upstream:
   ```bash
   git remote add upstream https://github.com/fabrigeas-gea/LiverGaz.git
   ```

## 🤝 How Can I Contribute?

### 🐛 Reporting Bugs

Before creating bug reports, please check existing issues as you might find that the bug has already been reported. When creating a bug report, include as many details as possible using our [bug report template](.github/ISSUE_TEMPLATE/bug_report.md).

### ✨ Suggesting Features

Feature suggestions are welcome! Please use our [feature request template](.github/ISSUE_TEMPLATE/feature_request.md) and provide:

- Clear use case and problem statement
- Detailed description of the proposed solution
- Consider alternative approaches
- Mockups or wireframes if applicable

### 💻 Code Contributions

1. **Find an Issue**: Look for issues labeled `good-first-issue` or `help-wanted`
2. **Discuss**: Comment on the issue to discuss your approach
3. **Code**: Create your feature branch and implement your changes
4. **Test**: Ensure all tests pass and add new tests if needed
5. **Submit**: Create a pull request using our template

## 🛠️ Development Setup

### Backend Setup

```bash
cd backend
npm install
cp .env.example .env
# Configure your .env file
npm run dev
```

### Frontend Setup

```bash
cd frontend
flutter pub get
flutter run
```

### Running Tests

```bash
# Backend tests
cd backend
npm test

# Frontend tests
cd frontend
flutter test
```

## 📤 Pull Request Process

1. **Branch**: Create a feature branch from `main`
   ```bash
   git checkout -b feature/amazing-feature
   ```

2. **Code**: Make your changes following our style guidelines

3. **Test**: Ensure your code is well-tested
   ```bash
   npm test  # Backend
   flutter test  # Frontend
   ```

4. **Commit**: Use conventional commits
   ```bash
   git commit -m "feat: add amazing feature"
   ```

5. **Push**: Push to your fork
   ```bash
   git push origin feature/amazing-feature
   ```

6. **PR**: Create a pull request using our template

7. **Review**: Address feedback from maintainers

### Conventional Commits

We use [Conventional Commits](https://www.conventionalcommits.org/) for commit messages:

- `feat:` - New features
- `fix:` - Bug fixes
- `docs:` - Documentation changes
- `style:` - Code style changes (formatting, etc.)
- `refactor:` - Code refactoring
- `test:` - Adding or updating tests
- `chore:` - Maintenance tasks

## 🎨 Style Guidelines

### TypeScript/JavaScript (Backend)

- Use ESLint configuration provided
- Follow TypeScript best practices
- Use meaningful variable and function names
- Comment complex logic
- Prefer `const` over `let`, avoid `var`

```typescript
// Good
const getUserById = async (userId: string): Promise<User | null> => {
  try {
    return await User.findById(userId);
  } catch (error) {
    logger.error('Error fetching user:', error);
    throw new Error('User not found');
  }
};

// Bad
function getUser(id) {
  return User.findById(id);
}
```

### Dart/Flutter (Frontend)

- Follow [Dart style guide](https://dart.dev/guides/language/effective-dart/style)
- Use `flutter analyze` to check for issues
- Follow Flutter widget conventions
- Use meaningful widget names

```dart
// Good
class UserProfileCard extends StatelessWidget {
  const UserProfileCard({
    Key? key,
    required this.user,
    this.onTap,
  }) : super(key: key);

  final User user;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(user.name),
        subtitle: Text(user.email),
        onTap: onTap,
      ),
    );
  }
}
```

### Git Commit Messages

- Use imperative mood ("Add feature" not "Added feature")
- Keep first line under 50 characters
- Reference issues and pull requests when applicable
- Use conventional commit format

```bash
# Good
feat: add user authentication system

Implements JWT-based authentication with login, logout,
and token refresh functionality.

Fixes #123
```

### Documentation

- Update README.md if you change functionality
- Comment your code, especially complex algorithms
- Update API documentation for backend changes
- Add inline documentation for public methods

## 🐛 Issue Guidelines

### Before Submitting an Issue

1. **Search existing issues** to avoid duplicates
2. **Check documentation** - the answer might already be there
3. **Update to latest version** - the issue might be already fixed

### Writing Good Issues

- **Use descriptive titles** - "Button doesn't work" vs "Login button throws error on invalid credentials"
- **Provide context** - What were you trying to do?
- **Include details** - OS, browser, app version, etc.
- **Steps to reproduce** - How can we reproduce the issue?
- **Expected vs actual behavior** - What should happen vs what actually happens?

### Issue Labels

We use labels to categorize issues:

- `bug` - Something isn't working
- `enhancement` - New feature request
- `documentation` - Documentation improvements
- `good-first-issue` - Good for newcomers
- `help-wanted` - Extra attention needed
- `question` - Further information requested

## 🏗️ Architecture Guidelines

### Backend Architecture

- Follow MVC pattern
- Use middleware for cross-cutting concerns
- Implement proper error handling
- Use DTOs for API responses
- Follow RESTful API conventions

### Frontend Architecture

- Follow BLoC or Provider pattern for state management
- Separate business logic from UI
- Use proper folder structure
- Implement proper error handling
- Follow Material Design guidelines

## 🧪 Testing Guidelines

### Backend Testing

- Write unit tests for business logic
- Write integration tests for API endpoints
- Mock external dependencies
- Aim for >80% code coverage

```typescript
describe('UserController', () => {
  it('should return user by id', async () => {
    const mockUser = { id: '1', name: 'John Doe' };
    jest.spyOn(userService, 'findById').mockResolvedValue(mockUser);
    
    const response = await request(app)
      .get('/api/users/1')
      .expect(200);
    
    expect(response.body).toEqual(mockUser);
  });
});
```

### Frontend Testing

- Write unit tests for business logic
- Write widget tests for UI components
- Write integration tests for user flows
- Test error states and edge cases

```dart
testWidgets('UserProfileCard displays user information', (tester) async {
  const user = User(id: '1', name: 'John Doe', email: 'john@example.com');
  
  await tester.pumpWidget(
    MaterialApp(
      home: UserProfileCard(user: user),
    ),
  );
  
  expect(find.text('John Doe'), findsOneWidget);
  expect(find.text('john@example.com'), findsOneWidget);
});
```

## 🚀 Release Process

1. **Version Bump**: Update version numbers in `package.json` and `pubspec.yaml`
2. **Changelog**: Update `CHANGELOG.md` with new features and fixes
3. **Tag**: Create a git tag with the version number
4. **Release**: Create a GitHub release with release notes

## 📞 Community

- **Discord**: [Join our community](https://discord.gg/delivergaz)
- **Email**: [developers@delivergaz.com](mailto:developers@delivergaz.com)
- **GitHub Discussions**: Use for questions and discussions
- **Stack Overflow**: Tag questions with `delivergaz`

## 🙏 Recognition

Contributors will be recognized in:
- README.md contributors section
- Release notes
- Special thanks in major version releases

## ❓ Questions?

Don't hesitate to ask questions! You can:
- Open a discussion on GitHub
- Join our Discord community
- Email us at developers@delivergaz.com

Thank you for contributing to DeliverGaz! 🚚💙