# Contributing to Terraform Serverless API Boilerplate

We love your input! We want to make contributing to this project as easy and transparent as possible, whether it's:

- Reporting a bug
- Discussing the current state of the code
- Submitting a fix
- Proposing new features
- Becoming a maintainer

## 🚀 Quick Start for Contributors

1. **Fork the repository**
2. **Create a feature branch** from `master`
3. **Make your changes**
4. **Test your changes** with at least one example
5. **Submit a pull request**

## 📝 How We Use GitHub

We use GitHub to host code, track issues and feature requests, and accept pull requests.

## 🐛 Report Bugs Using GitHub Issues

We use GitHub issues to track public bugs. Report a bug by [opening a new issue](../../issues/new).

### Write Bug Reports with Detail, Background, and Sample Code

**Great Bug Reports** tend to have:

- A quick summary and/or background
- Steps to reproduce
  - Be specific!
  - Give sample code if you can
- What you expected would happen
- What actually happens
- Notes (possibly including why you think this might be happening, or stuff you tried that didn't work)

People *love* thorough bug reports.

## 💡 Suggest Features Using GitHub Discussions

We use GitHub Discussions for feature requests and general questions. Before creating a new discussion:

1. Search existing discussions to see if someone already suggested it
2. Provide a clear use case
3. Explain why this would be valuable to other users

## 🔧 Development Process

### Setting Up Development Environment

1. **Clone your fork**
   ```bash
   git clone https://github.com/YOUR_USERNAME/terraform-starter.git
   cd terraform-starter
   ```

2. **Test with an example**
   ```bash
   cd examples/simple_landing
   terraform init
   terraform plan
   ```

### Making Changes

1. **Create a branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make changes**
   - Follow existing code style
   - Add documentation for new features
   - Update relevant README files

3. **Test your changes**
   - Test with at least one example
   - Verify terraform plan/apply works
   - Check that outputs are correct

4. **Commit your changes**
   ```bash
   git add .
   git commit -m "feat: add your feature description"
   ```

### Pull Request Process

1. **Push your branch**
   ```bash
   git push origin feature/your-feature-name
   ```

2. **Create Pull Request**
   - Use a clear title describing the change
   - Reference any related issues
   - Explain what you changed and why

3. **Address feedback**
   - Respond to review comments
   - Make requested changes
   - Update your PR

## 📐 Coding Standards

### Terraform Code Style

- Use **consistent naming**: `snake_case` for variables, `kebab-case` for resources
- Add **descriptions** to all variables and outputs
- Include **validation blocks** where appropriate
- Use **locals** for complex expressions
- Add **tags** to all resources

Example:
```hcl
variable "project_name" {
  type        = string
  description = "Name of the project, used for naming resources."
  
  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.project_name))
    error_message = "Project name must contain only lowercase letters, numbers, and hyphens."
  }
}

resource "aws_lambda_function" "api" {
  function_name = "${var.project_name}-api"
  # ... other configuration
  
  tags = local.tags
}
```

### JavaScript Code Style

- Use **ES6+** features
- Add **error handling** for all async operations
- Include **JSDoc comments** for functions
- Use **descriptive variable names**
- Follow **AWS Lambda best practices**

Example:
```javascript
/**
 * Handles API Gateway requests
 * @param {Object} event - API Gateway event
 * @returns {Object} HTTP response
 */
exports.handler = async (event) => {
  try {
    // Handle request logic
    return {
      statusCode: 200,
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({ success: true })
    };
  } catch (error) {
    console.error('Error:', error);
    return {
      statusCode: 500,
      body: JSON.stringify({ error: 'Internal server error' })
    };
  }
};
```

### Documentation Style

- Use **clear, concise language**
- Include **code examples** for configuration
- Add **troubleshooting sections** for common issues
- Use **emojis** for section headers (like 🚀, 📁, etc.)
- Link to **related resources**

## 🏷️ Types of Contributions

### 📚 Documentation

- Fix typos or unclear explanations
- Add missing documentation
- Improve examples
- Update outdated information

### 🛠️ Bug Fixes

- Fix terraform configuration issues
- Resolve AWS service integration problems
- Fix example code errors
- Improve error handling

### ✨ Features

- Add new AWS service integrations
- Create new example projects
- Improve existing modules
- Add new configuration options

### 🧪 Testing

- Add tests for terraform modules
- Improve example validation
- Add CI/CD workflows
- Performance testing

## 🚦 Review Process

1. **Automated Checks**
   - Terraform validation
   - Code formatting
   - Link checking

2. **Manual Review**
   - Code quality
   - Documentation completeness
   - Backward compatibility
   - Security considerations

3. **Testing**
   - Deploy examples to verify functionality
   - Test edge cases
   - Verify outputs

## 🎯 Getting Started Ideas

Looking for a way to contribute? Here are some good first issues:

- **Documentation**: Improve README files or add missing docs
- **Examples**: Add new example projects or improve existing ones
- **Bug fixes**: Look for issues labeled "good first issue"
- **Testing**: Help test examples in different regions or configurations

## ❓ Questions?

- 💬 [Start a discussion](../../discussions) for general questions
- 🐛 [Open an issue](../../issues) for bugs
- 📧 Contact maintainers for sensitive issues

## 📜 Code of Conduct

This project follows the [Contributor Covenant Code of Conduct](https://www.contributor-covenant.org/version/2/1/code_of_conduct/). By participating, you are expected to uphold this code.

## 📄 License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

Thank you for contributing! 🎉